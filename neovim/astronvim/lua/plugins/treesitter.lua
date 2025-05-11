if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bash",
      "lua",
      "vim",
      "json",
      "rust",
      "yaml",
      "ocaml",
      "haskell",
      "c",
      "ledger",
      "python",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
