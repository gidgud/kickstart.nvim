# nvim

Personal Neovim config (Neovim 0.12+), started from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## Requirements

- `git`, `make`, a C compiler, `curl`, `tar`, `unzip`
- `ripgrep` and `fd` (Telescope)
- A Nerd Font in your terminal (or set `vim.g.have_nerd_font = false` in `init.lua`)
- Language toolchains, for the languages you use:
  - Node.js / npm — needed by Mason for the TypeScript, ESLint, HTML, JSON, YAML, Bash and Docker servers and prettier
  - Go — gopls, goimports, gofumpt and delve are built with `go install`
  - Rust with `rustfmt` and `clippy` (rust-analyzer and codelldb come from Mason)
  - Java 21+ to run jdtls (projects can still target older JDKs)

Language servers, formatters, linters, debuggers and the tree-sitter CLI are installed automatically by Mason on first start; parsers are compiled by nvim-treesitter.

```sh
git clone <this repo> ~/.config/nvim
nvim
```

## Layout

- `init.lua` → `lua/config/` (options, keymaps, autocmds, plugin manager)
- `lua/plugins/` → one file per area: `lsp`, `completion`, `formatting`, `lint`, `debug`, `treesitter`, `telescope`, `editor`, `colorscheme`
- `ftplugin/java.lua` → jdtls setup and Java refactor/generate/test keymaps; `ftplugin/go.lua` → Go test keymaps

## Keys worth remembering

Leader is `<Space>`; `<Space>sk` searches all keymaps.

| Keys | Action |
|---|---|
| `<leader>sf` / `<leader>sg` / `<leader><leader>` | Find files / grep / buffers |
| `<leader>e` | File tree |
| `gr*` (`grd`, `grr`, `grn`, `gra`), `<leader>ca` | LSP: definition, references, rename, code action |
| `<leader>f` | Format buffer (also runs on save) |
| `[d` / `]d`, `[c` / `]c` | Previous/next diagnostic, git change |
| `<leader>h*` | Git hunks: stage, reset, preview, blame, diff |
| `F5` / `F1` `F2` `F3` / `F4` / `F7` | Debug: continue / step into, over, out / stop / toggle UI |
| `<leader>b` / `<leader>B` | Breakpoint / conditional breakpoint |
| `<leader>ct` / `<leader>cm` | Run test class / nearest test (Java; `<leader>cm` also Go) |
| `<leader>sc` | Pick colorscheme |
