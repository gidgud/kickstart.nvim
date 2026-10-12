-- Claude Code inside nvim: <leader>ac opens it in a split on the right.
-- Claude sees the current selection, and its edits open as diffs here (<leader>aa / <leader>ad).
-- A Claude running in another kitty window or tmux pane can connect too: run `/ide` in it.
return {
  'coder/claudecode.nvim',
  cmd = { 'ClaudeCode', 'ClaudeCodeFocus', 'ClaudeCodeSend', 'ClaudeCodeAdd', 'ClaudeCodeStart', 'ClaudeCodeStatus' },
  keys = {
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = '[C]laude toggle' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = '[F]ocus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = '[R]esume session' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = '[C]ontinue last session' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add [B]uffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = '[S]end selection' },
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = '[A]ccept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = '[D]eny diff' },
    { '<leader>ai', '<cmd>ClaudeCodeStart<cr>', desc = 'Start server for an external Claude ([I]de)' },
  },
  opts = {
    terminal = {
      provider = 'native', -- no snacks.nvim needed
      split_side = 'right',
      split_width_percentage = 0.4,
    },
  },
}
