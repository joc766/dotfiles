#!/usr/bin/env bash
# Symlinks this repo's dotfiles into $HOME, backing up anything already there.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S 2>/dev/null || echo backup)"

# map: source file in this repo -> target path in $HOME
declare -A LINKS=(
  [bashrc]="$HOME/.bashrc"
  [zshrc]="$HOME/.zshrc"
  [tmux.conf]="$HOME/.tmux.conf"
  [vimrc]="$HOME/.vimrc"
)

for src in "${!LINKS[@]}"; do
  target="${LINKS[$src]}"
  source_path="$DOTFILES_DIR/$src"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source_path" ]; then
    echo "skip   $target (already linked)"
    continue
  fi

  if [ -e "$target" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
    echo "backup $target -> $BACKUP_DIR/"
  fi

  ln -s "$source_path" "$target"
  echo "link   $target -> $source_path"
done
