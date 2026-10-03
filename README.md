# VimCode

A Neovim setup built on [LazyVim](https://lazyvim.org), tuned for Python, Jupyter notebooks and working alongside Claude Code.

- **Look:** solarized-osaka (transparent), slanted bufferline tabs with diagnostics, lualine statusline with clock
- **Notebooks:** run Jupyter cells in the buffer (molten), inline plots (image.nvim), `.ipynb` opened as markdown (jupytext)
- **Python:** pyright + ruff language servers, ipython REPL (iron.nvim)
- **Terminals:** three toggleable bottom terminals and a Claude Code side panel

VimCode installs as its own Neovim app (`NVIM_APPNAME=vimcode`), so your existing `~/.config/nvim` is left alone.

## Install

One command:

```bash
curl -fsSL https://raw.githubusercontent.com/hsarchitects/VimCode/main/install.sh | bash
```

Or clone it and install from the clone (edits in the clone take effect directly):

```bash
git clone https://github.com/hsarchitects/VimCode.git
cd VimCode && ./install.sh
```

Then run:

```bash
vimcode
```

### Requirements

- Neovim 0.11.2 or newer, and git
- A [Nerd Font](https://www.nerdfonts.com) set in your terminal

Optional (the installer tells you which are missing):

| For | Install |
|-----|---------|
| Fast file and text search | `brew install ripgrep fd` |
| Inline plots | `brew install imagemagick`, plus Kitty, WezTerm or Ghostty as your terminal |
| Notebooks and REPL | `pip install pynvim jupyter_client ipython jupytext` |
| Claude Code panel | [Claude Code](https://claude.com/claude-code) (`claude` on your PATH) |

## Keymaps

`<leader>` is Space. Everything else is [LazyVim's defaults](https://lazyvim.org/keymaps).

| Keys | Action |
|------|--------|
| `<leader>ac` | Toggle Claude Code panel |
| `<leader>t1` / `t2` / `t3` | Toggle bottom terminal 1 / 2 / 3 |
| `<leader>mi` | Start a Jupyter kernel |
| `<leader>ml` / `me` / `mv` | Run line / motion / visual selection |
| `<leader>mr` / `mc` | Re-run cell / all cells |
| `<leader>mh` / `md` | Hide output / delete cell |
| `<leader>rl` / `rc` | Send line / motion to the ipython REPL |

## Update

Re-run the install command (or `git pull` in your clone), then `:Lazy restore` inside VimCode.

## Uninstall

```bash
rm -rf ~/.config/vimcode ~/.local/share/vimcode ~/.local/state/vimcode ~/.cache/vimcode ~/.local/bin/vimcode
```

## License

Apache-2.0, inherited from the [LazyVim starter](https://github.com/LazyVim/starter).
