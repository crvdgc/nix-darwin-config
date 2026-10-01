-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {
  -- Neovim 0.12 compat: AstroNvim v6's pinned snapshot constrains aerial to
  -- ^2.2 (-> v2.7.0), whose treesitter backend crashes on Neovim 0.12 because
  -- iter_matches() no longer supports { all = false }. v4.0.0 is the release
  -- that explicitly targets Neovim >= 0.12.
  {
    "stevearc/aerial.nvim",
    version = "^4",
  },

  -- Neovim 0.12 compat: AstroNvim v6's snapshot pins none-ls.nvim to commit
  -- a117163, which reads lsp.protocol._request_name_to_capability /
  -- lsp._request_name_to_capability (both removed in Neovim 0.12) and crashes
  -- on LSP client attach. Pin a commit that uses the 0.12 name
  -- (_request_name_to_server_capability) and fixes supports_method detection.
  {
    "nvimtools/none-ls.nvim",
    commit = "01f8e62ea11603e59ad9ff7afcfa94fd183f76d6",
  },

  -- Rocq / Coqtail
  {
    "whonore/Coqtail",
    ft = "coq",
    init = function()
      vim.g.coqtail_map_prefix = "<leader>r"
    end,
  },

  -- old custom plugins that still make sense
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },
  "tpope/vim-unimpaired",
  "tpope/vim-fugitive",
  {
    "ledger/vim-ledger",
    ft = { "ledger" },
  },
  {
    "johmsalas/text-case.nvim",
    keys = "ga",
    config = function()
      require("textcase").setup {}
    end,
  },
}
-- return {
--
--   -- == Examples of Adding Plugins ==
--
--   "andweeb/presence.nvim",
--   {
--     "ray-x/lsp_signature.nvim",
--     event = "BufRead",
--     config = function() require("lsp_signature").setup() end,
--   },
--
--   -- == Examples of Overriding Plugins ==
--
--   -- customize dashboard options
--   {
--     "folke/snacks.nvim",
--     opts = {
--       dashboard = {
--         preset = {
--           header = table.concat({
--             " █████  ███████ ████████ ██████   ██████ ",
--             "██   ██ ██         ██    ██   ██ ██    ██",
--             "███████ ███████    ██    ██████  ██    ██",
--             "██   ██      ██    ██    ██   ██ ██    ██",
--             "██   ██ ███████    ██    ██   ██  ██████ ",
--             "",
--             "███    ██ ██    ██ ██ ███    ███",
--             "████   ██ ██    ██ ██ ████  ████",
--             "██ ██  ██ ██    ██ ██ ██ ████ ██",
--             "██  ██ ██  ██  ██  ██ ██  ██  ██",
--             "██   ████   ████   ██ ██      ██",
--           }, "\n"),
--         },
--       },
--     },
--   },
--
--   -- You can disable default plugins as follows:
--   { "max397574/better-escape.nvim", enabled = false },
--
--   -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
--   {
--     "L3MON4D3/LuaSnip",
--     config = function(plugin, opts)
--       -- add more custom luasnip configuration such as filetype extend or custom snippets
--       local luasnip = require "luasnip"
--       luasnip.filetype_extend("javascript", { "javascriptreact" })
--
--       -- include the default astronvim config that calls the setup call
--       require "astronvim.plugins.configs.luasnip"(plugin, opts)
--     end,
--   },
--
--   {
--     "windwp/nvim-autopairs",
--     config = function(plugin, opts)
--       require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
--       -- add more custom autopairs configuration such as custom rules
--       local npairs = require "nvim-autopairs"
--       local Rule = require "nvim-autopairs.rule"
--       local cond = require "nvim-autopairs.conds"
--       npairs.add_rules(
--         {
--           Rule("$", "$", { "tex", "latex" })
--             -- don't add a pair if the next character is %
--             :with_pair(cond.not_after_regex "%%")
--             -- don't add a pair if  the previous character is xxx
--             :with_pair(
--               cond.not_before_regex("xxx", 3)
--             )
--             -- don't move right when repeat character
--             :with_move(cond.none())
--             -- don't delete if the next character is xx
--             :with_del(cond.not_after_regex "xx")
--             -- disable adding a newline when you press <cr>
--             :with_cr(cond.none()),
--         },
--         -- disable for .vim files, but it work for another filetypes
--         Rule("a", "a", "-vim")
--       )
--     end,
--   },
-- }
