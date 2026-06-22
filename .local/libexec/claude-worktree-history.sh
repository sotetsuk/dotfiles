#!/usr/bin/env bash
# Internal helper for `cw` -- NOT a public command.
# Invoked by cw (which locates it via libexec/) to share Claude Code prompt
# history between a repository and a temporary worktree. Not meant to be run
# directly; the interface below may change without notice.

set -euo pipefail

usage() {
  cat >&2 <<'EOF'
internal helper for cw; not intended to be run directly. usage:
  libexec/claude-worktree-history.sh seed <repo-root> <worktree-dir>
  libexec/claude-worktree-history.sh finish <repo-root> <worktree-dir>
EOF
}

if [[ $# -ne 3 ]]; then
  usage
  exit 2
fi

mode="$1"
repo_root="${2%/}"
worktree_dir="${3%/}"

if [[ "$mode" != "seed" && "$mode" != "finish" ]]; then
  usage
  exit 2
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "error: jq is required" >&2
  exit 1
fi

history_file="${CLAUDE_HISTORY_FILE:-$HOME/.claude/history.jsonl}"
state_dir="${CLAUDE_WORKTREE_HISTORY_STATE_DIR:-$HOME/.claude/.worktree-seed}"
seed_limit="${CLAUDE_WORKTREE_HISTORY_SEED_LIMIT:-500}"
lock_dir="${CLAUDE_WORKTREE_HISTORY_LOCK_DIR:-$HOME/.claude/.worktree-history.lock}"
temp_files=()

case "$seed_limit" in
  ''|*[!0-9]*)
    echo "error: CLAUDE_WORKTREE_HISTORY_SEED_LIMIT must be a non-negative integer" >&2
    exit 1
    ;;
esac

if [[ ! -f "$history_file" ]]; then
  exit 0
fi

history_dir="$(dirname "$history_file")"
mkdir -p "$state_dir"

key="$(
  printf '%s' "$worktree_dir" |
    shasum -a 256 |
    awk '{print $1}'
)"
state_file="$state_dir/$key"

cleanup_lock() {
  rmdir "$lock_dir" 2>/dev/null || true
}

cleanup() {
  if [[ "${#temp_files[@]}" -gt 0 ]]; then
    rm -f "${temp_files[@]}"
  fi
  cleanup_lock
}

acquire_lock() {
  local i
  for i in $(seq 1 100); do
    if mkdir "$lock_dir" 2>/dev/null; then
      trap cleanup EXIT
      return 0
    fi
    sleep 0.05
  done
  echo "error: could not acquire history lock: $lock_dir" >&2
  exit 1
}

max_timestamp() {
  jq -r 'select((.timestamp? | type) == "number") | .timestamp' "$history_file" |
    sort -n |
    tail -n 1
}

validate_jsonl() {
  local file="$1"
  jq empty "$file" >/dev/null
}

replace_history() {
  local tmp="$1"
  validate_jsonl "$tmp"
  cp "$history_file" "$history_file.bak"
  mv "$tmp" "$history_file"
}

seed_history() {
  local boundary tmp base seeded
  boundary="$(max_timestamp)"
  boundary="${boundary:-0}"
  printf '%s\n' "$boundary" >"$state_file"

  tmp="$(mktemp "$history_dir/history.jsonl.seed.XXXXXX")"
  base="$(mktemp "$history_dir/history.jsonl.base.XXXXXX")"
  seeded="$(mktemp "$history_dir/history.jsonl.seeded.XXXXXX")"
  temp_files+=("$tmp" "$base" "$seeded")

  jq -c --arg wt "$worktree_dir" 'select(.project? != $wt)' "$history_file" >"$base"
  jq -c --arg root "$repo_root" --arg wt "$worktree_dir" \
    'select(.project? == $root) | .project = $wt' "$base" |
    tail -n "$seed_limit" >"$seeded"

  cat "$base" "$seeded" >"$tmp"
  replace_history "$tmp"

  echo "seeded $(wc -l <"$seeded" | tr -d ' ') prompts for $worktree_dir" >&2
}

finish_history() {
  local boundary tmp merged new_entries
  if [[ -f "$state_file" ]]; then
    boundary="$(sed -n '1p' "$state_file")"
  else
    boundary="0"
  fi

  case "$boundary" in
    ''|*[!0-9]*)
      boundary="0"
      ;;
  esac

  tmp="$(mktemp "$history_dir/history.jsonl.finish.XXXXXX")"
  merged="$(mktemp "$history_dir/history.jsonl.merged.XXXXXX")"
  new_entries="$(mktemp "$history_dir/history.jsonl.new.XXXXXX")"
  temp_files+=("$tmp" "$merged" "$new_entries")

  jq -c --arg wt "$worktree_dir" 'select(.project? != $wt)' "$history_file" >"$merged"
  jq -c --arg wt "$worktree_dir" --arg root "$repo_root" --argjson boundary "$boundary" \
    'select(.project? == $wt and ((.timestamp? | type) == "number") and .timestamp > $boundary) | .project = $root' \
    "$history_file" >"$new_entries"

  cat "$merged" "$new_entries" >"$tmp"
  replace_history "$tmp"
  rm -f "$state_file"

  echo "merged $(wc -l <"$new_entries" | tr -d ' ') prompts from $worktree_dir" >&2
}

acquire_lock

case "$mode" in
  seed)
    seed_history
    ;;
  finish)
    finish_history
    ;;
esac
