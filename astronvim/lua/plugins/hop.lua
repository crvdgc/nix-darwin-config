---@type LazySpec
return {

  {
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup()
    end,
  },

  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          ["<Leader>j"] = {
            group = "Hop",
          },
          ["<Leader>jf"] = { "<cmd>HopChar1<cr>", desc = "HopChar1" },
          ["<Leader>jj"] = { "<cmd>HopVertical<cr>", desc = "HopVertical" },
          ["<Leader>jk"] = { "<cmd>HopVertical<cr>", desc = "HopVertical" },
          ["<Leader>jw"] = { "<cmd>HopWord<cr>", desc = "HopWord" },
        },
      },
    },
  },
}
