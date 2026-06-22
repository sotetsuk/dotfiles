#!/usr/bin/env zsh

source ~/.zshrc

set -e

# Installed w/ package manager
which git
which vim
which curl
which wget
which tree
which tmux
which python3
which pip3
which bat
which xz
which gh
which xsel
which pygmentize
which jq

# Installed w/o package manager
which uv
which fzf
which imgcat
which it2dl
which it2ul

# Original commands
which tmx
which cw

# cw internal helpers (installed into ~/.local/libexec)
test -x ~/.local/libexec/claude-worktree-history.sh
test -x ~/.local/libexec/claude-worktree-include.sh

# Functional test: claude-worktree-include.sh copies .worktreeinclude paths
# (e.g. gitignored skills) into a freshly created worktree.
cw_repo="$(mktemp -d)"
(
  cd "$cw_repo"
  git init -q
  git config user.email test@example.com
  git config user.name test
  mkdir -p .claude/skills/foo
  echo marker > .claude/skills/foo/SKILL.md
  printf '.claude/skills/\n' > .gitignore
  printf '.claude/skills/\n' > .worktreeinclude
  git add .gitignore .worktreeinclude
  git commit -qm init
  git worktree add -q wt -b wt-include-test
  ~/.local/libexec/claude-worktree-include.sh "$cw_repo" "$cw_repo/wt"
  test -f "$cw_repo/wt/.claude/skills/foo/SKILL.md"
  git worktree remove --force wt
)
rm -rf "$cw_repo"
echo "ok [cw worktreeinclude]"

echo "-------------------------------"
echo "All tests passed!"
echo "-------------------------------"
