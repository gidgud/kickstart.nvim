-- nvim-treesitter `main` branch: it only installs parsers/queries; highlighting
-- and indent are switched on per buffer below. Needs the tree-sitter CLI (Mason).
local ensure_installed = {
  'bash',
  'c',
  'diff',
  'dockerfile',
  'go',
  'gomod',
  'html',
  'java',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'make',
  'markdown',
  'markdown_inline',
  'query',
  'rust',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- does not support lazy-loading
  build = ':TSUpdate',
  config = function()
    local ts = require 'nvim-treesitter'
    ts.install(ensure_installed)

    local function start(buf, lang)
      if vim.api.nvim_buf_is_valid(buf) and pcall(vim.treesitter.start, buf, lang) then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Start treesitter, installing the parser first if it is missing',
      group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end
        if vim.list_contains(ts.get_installed(), lang) then
          start(args.buf, lang)
        elseif vim.list_contains(ts.get_available(), lang) then
          ts.install(lang):await(vim.schedule_wrap(function()
            start(args.buf, lang)
          end))
        end
      end,
    })
  end,
}
