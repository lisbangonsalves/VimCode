#!/usr/bin/env bash
# VimCode installer
#   curl -fsSL https://raw.githubusercontent.com/hsarchitects/VimCode/main/install.sh | bash
# or, from a clone:
#   ./install.sh
#
# Installs as a separate Neovim app (NVIM_APPNAME=vimcode), so an existing
# ~/.config/nvim is never touched. Launch with `vimcode`.
set -euo pipefail

REPO="${VIMCODE_REPO:-https://github.com/hsarchitects/VimCode.git}"
APP=vimcode
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/$APP"
BIN="$HOME/.local/bin"

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

command -v git >/dev/null || die "git is required"
command -v nvim >/dev/null || die "Neovim >= 0.11.2 is required: https://neovim.io"
nvim --clean --headless -c 'if !has("nvim-0.11.2") | cquit | endif' -c quit \
  || die "Neovim >= 0.11.2 is required (found: $(nvim --version | head -1))"

# Run from a clone -> use that clone; piped from curl -> clone (or update) into CONFIG
SRC=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [ -n "$SRC" ] && [ "$SRC" != "$CONFIG" ]; then
  if [ -L "$CONFIG" ]; then
    rm "$CONFIG"
  elif [ -e "$CONFIG" ]; then
    die "$CONFIG already exists; move it away and re-run"
  fi
  say "Linking $CONFIG -> $SRC"
  mkdir -p "$(dirname "$CONFIG")"
  ln -s "$SRC" "$CONFIG"
elif [ -d "$CONFIG/.git" ]; then
  say "Updating $CONFIG"
  git -C "$CONFIG" pull --ff-only
elif [ -e "$CONFIG" ]; then
  die "$CONFIG already exists and is not a VimCode checkout; move it away and re-run"
else
  say "Cloning $REPO -> $CONFIG"
  git clone --depth 1 "$REPO" "$CONFIG"
fi

say "Installing launcher $BIN/vimcode"
mkdir -p "$BIN"
printf '#!/bin/sh\nexec env NVIM_APPNAME=%s nvim "$@"\n' "$APP" > "$BIN/vimcode"
chmod +x "$BIN/vimcode"

say "Installing plugins at the versions in lazy-lock.json (first run takes a minute)"
NVIM_APPNAME=$APP nvim --headless -c 'lua if not package.loaded.lazy then vim.cmd.cquit() end' '+Lazy! restore' +qa \
  || die "plugin install failed; run 'vimcode' to see the error"

# Optional tools: warn only, VimCode still starts without them
missing=()
for cmd in rg fd magick ipython jupytext claude; do
  command -v "$cmd" >/dev/null || missing+=("$cmd")
done
python3 -c 'import pynvim, jupyter_client' 2>/dev/null || missing+=("python: pynvim jupyter_client")
if [ ${#missing[@]} -gt 0 ]; then
  say "Optional tools not found (see README): ${missing[*]}"
fi

case ":$PATH:" in
  *":$BIN:"*) ;;
  *) say "Add $BIN to your PATH:  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc" ;;
esac

say "Done. Run: vimcode"
