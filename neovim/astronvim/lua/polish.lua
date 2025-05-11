-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }

-- disable relativenumber
vim.opt.relativenumber = false

-- Key bindings {

--typos for save and quit {

---Add an alias to a 0-argument command
---@param alias string
---@param cmd function
local add_alias_to_cmd = function(alias, cmd)
  vim.api.nvim_create_user_command(alias, function(_) cmd() end, { nargs = 0 })
end
add_alias_to_cmd("WQ", vim.cmd.wq)
add_alias_to_cmd("Wq", vim.cmd.wq)
add_alias_to_cmd("W", vim.cmd.w)
add_alias_to_cmd("Q", vim.cmd.q)
add_alias_to_cmd("X", vim.cmd.x)
add_alias_to_cmd("Xa", vim.cmd.xa)

-- }

-- nvim options {
vim.opt.wrap = true
vim.opt.wildmenu = true -- visual autocomplete for command menu
vim.opt.wildmode = "longest:full,full"
vim.opt.textwidth = 80

-- do not wrap in insert mode
vim.api.nvim_create_autocmd({
  "BufReadPre",
  "BufEnter",
  "BufNewFile",
  "BufNew",
}, {
  command = "setlocal formatoptions=jroql",
})

local is_cmp_single_buffer = true
-- toggle auto completion from all buffers
-- https://github.com/LunarVim/LunarVim/issues/4204
-- also https://github.com/hrsh7th/nvim-cmp/discussions/670
-- since setting lvim.builtin.cmp.sources doesn't reload cmp
local toggle_cmp_all_buffers = function()
  local cmp = require "cmp"
  local config = cmp.get_config()
  local new_sources = vim.tbl_filter(function(source) return source.name ~= "buffer" end, config.sources)
  if is_cmp_single_buffer then
    vim.list_extend(new_sources, {
      {
        name = "buffer",
        priority_weight = 50,
        max_item_count = 5,
        option = {
          keyword_length = 2,
          get_bufnrs = function() return vim.api.nvim_list_bufs() end,
        },
      },
    })
  else
    vim.list_extend(new_sources, {
      {
        name = "buffer",
        option = {},
      },
    })
  end
  config.sources = new_sources
  cmp.setup(config)
end
vim.api.nvim_create_user_command("CmpToggleAllBuffers", toggle_cmp_all_buffers, {})

-- folding {
-- use treesitter folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- do not fold by default
vim.opt.foldenable = false
-- }

-- }
