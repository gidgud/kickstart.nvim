local prettier = { 'prettier' }

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      go = { 'goimports', 'gofumpt' },
      rust = { 'rustfmt' },
      toml = { 'taplo' },
      javascript = prettier,
      javascriptreact = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      json = prettier,
      html = prettier,
      css = prettier,
      markdown = prettier,
      yaml = prettier,
    },
  },
}
