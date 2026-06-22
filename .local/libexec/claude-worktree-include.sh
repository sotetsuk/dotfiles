#!/usr/bin/env bash
# Internal helper for `cw` -- NOT a public command.
# Invoked by cw (which locates it via libexec/) to copy the gitignored paths
# listed in <repo-root>/.worktreeinclude into a freshly created worktree. This
# mirrors `claude -w`, which honors .worktreeinclude so installed skills (and
# any other listed untracked dirs) are available inside the worktree; plain
# `git worktree add` checks out tracked files only and would leave them behind.
# Not meant to be run directly; the interface below may change without notice.

set -euo pipefail

usage() {
  cat >&2 <<'EOF'
internal helper for cw; not intended to be run directly. usage:
  libexec/claude-worktree-include.sh <repo-root> <worktree-dir>
EOF
}

if [[ $# -ne 2 ]]; then
  usage
  exit 2
fi

repo_root="${1%/}"
worktree_dir="${2%/}"
include_file="$repo_root/.worktreeinclude"

# No .worktreeinclude: nothing to do (mirrors `claude -w`).
[[ -f "$include_file" ]] || exit 0

copied=0
while IFS= read -r line || [[ -n "$line" ]]; do
  # Trim surrounding whitespace.
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  # Skip blank lines and comments.
  [[ -z "$line" || "$line" == \#* ]] && continue

  rel="${line%/}"
  src="$repo_root/$rel"
  dest="$worktree_dir/$rel"

  if [[ ! -e "$src" ]]; then
    echo "worktreeinclude: skip (missing in repo): $rel" >&2
    continue
  fi
  if [[ -e "$dest" ]]; then
    # Already present (e.g. tracked and checked out); don't clobber.
    continue
  fi

  mkdir -p "$(dirname "$dest")"
  cp -R "$src" "$dest"
  copied=$((copied + 1))
done < "$include_file"

echo "worktreeinclude: copied $copied path(s) into $worktree_dir" >&2
