-- Linters that aren't covered by a language server
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      dockerfile = { 'hadolint' },
    }

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('user-lint', { clear = true }),
      callback = function(args)
        if not vim.bo[args.buf].modifiable then
          return
        end
        lint.try_lint()
        if vim.api.nvim_buf_get_name(args.buf):match '/%.github/workflows/.+%.ya?ml$' then
          lint.try_lint 'actionlint'
        end
      end,
    })
  end,
}
