-- Same test keys as Java (ftplugin/java.lua); runs under the debugger so breakpoints work
vim.keymap.set('n', '<leader>cm', function()
  require('dap-go').debug_test()
end, { buffer = true, desc = 'Test nearest [M]ethod' })
vim.keymap.set('n', '<leader>cl', function()
  require('dap-go').debug_last_test()
end, { buffer = true, desc = 'Re-run [L]ast test' })
