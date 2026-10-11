-- kitty's scrollback in nvim: ctrl+shift+h (everything), ctrl+shift+g (last command's output).
-- The kitty side (remote control socket + maps) is at the bottom of ~/.config/kitty/kitty.conf
return {
  'mikesmithgh/kitty-scrollback.nvim',
  lazy = true,
  cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
  event = { 'User KittyScrollbackLaunch' },
  config = function()
    require('kitty-scrollback').setup()
  end,
}
