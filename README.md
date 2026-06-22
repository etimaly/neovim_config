# Neovim Config

Small personal Neovim setup using `lazy.nvim`.

## Setup

1. Put this repository at `~/.config/nvim`.
2. Start Neovim with `nvim`.
3. `lazy.nvim` bootstraps itself and installs plugin specs from `lua/plugins/`.
4. Use `:Lazy` for plugin state and `:Mason` for language tools.

## Layout

- `init.lua` loads mappings, options, autocmds, plugins, clipboard, and LSP float styling.
- `lua/config/` contains core editor config.
- `lua/plugins/` contains `lazy.nvim` plugin specs.
- `lua/config/languages.lua` centralizes Treesitter parsers, LSP servers, formatters, linters, and DAP tools.

## Keymaps

Leader key is space.

| Key | Mode | Action |
| --- | --- | --- |
| `;` | Normal | Enter command mode |
| `jk` | Insert | Exit insert mode |
| `<C-w>` | Normal | Save |
| `<C-q>` | Normal | Quit |
| `<C-u>` | Normal | Undo |
| `<A-h/j/k/l>` | Normal | Move between windows |
| `<A-H/J/K/L>` | Normal | Resize windows |
| `<C-j/k>` | Normal, Visual | Move line or selection |
| `<C-Left/Right>` | Normal, Insert | Jump by word |
| `<C-Up/Down>` | Insert | Jump by paragraph |
| `<C-BS>` | Insert | Delete previous word |
| `<leader>d` | Normal, Visual | Delete to void register |
| `<leader>p` | Visual | Paste over selection and keep original yank |
| `<leader>st` | Normal | Open terminal |
| `<Esc>` | Terminal | Exit terminal mode |

## Notes

- Clipboard uses `unnamedplus`.
- LSP hover, signature help, and diagnostic floats use rounded borders.
- Language support is driven by `lua/config/languages.lua`.
