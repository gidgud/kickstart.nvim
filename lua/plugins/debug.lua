-- Debugger. Java adapters come from jdtls (see ftplugin/java.lua), which
-- registers itself with nvim-dap and discovers main classes automatically.
local function dap(fn, ...)
  local args = { ... }
  return function()
    require('dap')[fn](unpack(args))
  end
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
    { 'theHamsta/nvim-dap-virtual-text', opts = {} }, -- show variable values inline
  },
  keys = {
    { '<F5>', dap 'continue', desc = 'Debug: Start/Continue' },
    { '<F1>', dap 'step_into', desc = 'Debug: Step Into' },
    { '<F2>', dap 'step_over', desc = 'Debug: Step Over' },
    { '<F3>', dap 'step_out', desc = 'Debug: Step Out' },
    { '<F4>', dap 'terminate', desc = 'Debug: Stop' },
    { '<leader>b', dap 'toggle_breakpoint', desc = 'Debug: Toggle [B]reakpoint' },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Conditional [B]reakpoint',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI (see last session result)',
    },
  },
  config = function()
    local dapui = require 'dapui'
    dapui.setup()

    local listeners = require('dap').listeners
    listeners.after.event_initialized['dapui_config'] = dapui.open
    listeners.before.event_terminated['dapui_config'] = dapui.close
    listeners.before.event_exited['dapui_config'] = dapui.close

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk', linehl = 'Visual' })
  end,
}
