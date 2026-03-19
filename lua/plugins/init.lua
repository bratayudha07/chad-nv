-- ~/.config/nvim/lua/plugins/init.lua
-- Plugin spec untuk NvChad (lazy.nvim)

return {

  -- ─────────────────────────────────────────
  --  Conform  ·  formatter
  -- ─────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    -- event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- ─────────────────────────────────────────
  --  LSP  (tanpa Mason)
  -- ─────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- ─────────────────────────────────────────
  --  Completion
  -- ─────────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp", -- skip jika error di Termux
      },
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require "configs.cmp"
    end,
  },

  -- ─────────────────────────────────────────
  --  Treesitter
  -- ─────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = require("configs.treesitter"),
  },

  -- ─────────────────────────────────────────
  --  Nonaktifkan Mason (tidak dipakai)
  -- ─────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    enabled = false,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = false,
  },
}
