-- https://github.com/Julian/dotfiles/blob/54d8856daa893b8574b712140607ea624e64d558/.config/nvim/after/ftplugin/lean.lua

-- Match mathlib's default style.
vim.bo.textwidth = 100

-- vim.opt_local.signcolumn = "yes"

vim.g.maplocalleader = "  "

vim.keymap.set('n', '<LocalLeader>g', function()
  require 'telescope.builtin'.live_grep {
    glob_pattern = '*.lean',
    path_display = { 'tail' },
    search_dirs = require('lean').current_search_paths()
  }
end, { buffer = true, desc = 'live grep the Lean search path.' })

vim.cmd [[
  highlight link leanTactic Green
]]
