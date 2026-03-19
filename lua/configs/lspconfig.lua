-- ~/.config/nvim/lua/configs/lsp.lua
-- LSP config menggunakan vim.lsp API baru (Neovim 0.11+), tanpa Mason
-- Install manual:
--   pip install pyright --break-system-packages
--   pip install ruff --break-system-packages

-- ─────────────────────────────────────────
--  NvChad defaults (html, cssls, dll)
-- ─────────────────────────────────────────
require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls" }
vim.lsp.enable(servers)

-- ─────────────────────────────────────────
--  Pyright  ·  Python (type checking)
-- ─────────────────────────────────────────
vim.lsp.config("pyright", {
  cmd        = { "pyright-langserver", "--stdio" },
  filetypes  = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths        = true,
        useLibraryCodeForTypes = true,
        diagnosticMode         = "openFilesOnly",
        typeCheckingMode       = "basic",
        -- Serahkan semua diagnostic lint ke Ruff
        ignore                 = { "*" },
      },
    },
  },
})

-- ─────────────────────────────────────────
--  Ruff  ·  Python (linting + formatting)
-- ─────────────────────────────────────────
vim.lsp.config("ruff", {
  cmd        = { "ruff", "server" },
  filetypes  = { "python" },
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    ".git",
  },
  init_options = {
    settings = {
      logLevel = "warn",
      lint   = { enable = true },
      format = { enable = true },
      showSyntaxErrors = true,
    },
  },
})

vim.lsp.enable({ "pyright", "ruff" })

-- ─────────────────────────────────────────
--  Keymaps & on_attach via LspAttach
-- ─────────────────────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(event)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = event.buf,
        silent = true,
        desc   = "LSP: " .. desc,
      })
    end

    map("n", "gd",         vim.lsp.buf.definition,     "Go to Definition")
    map("n", "gD",         vim.lsp.buf.declaration,     "Go to Declaration")
    map("n", "gr",         vim.lsp.buf.references,      "References")
    map("n", "gi",         vim.lsp.buf.implementation,  "Implementation")
    map("n", "K",          vim.lsp.buf.hover,           "Hover Docs")
    map("n", "<leader>rn", vim.lsp.buf.rename,          "Rename Symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action,     "Code Action")
    map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document Symbols")
    map("n", "[d",         function() vim.diagnostic.jump({ count = -1 }) end,    "Prev Diagnostic")
    map("n", "]d",         function() vim.diagnostic.jump({ count = 1 }) end,    "Next Diagnostic")
    map("n", "<leader>dl", vim.diagnostic.open_float,   "Diagnostic Float")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      -- Hover dari Ruff dimatikan, biarkan Pyright yang handle
      if client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
      end
      client.server_capabilities.signatureHelpProvider = nil
    end
  end,
})

-- ─────────────────────────────────────────
--  Format on save via Ruff
-- ─────────────────────────────────────────
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern  = "*.py",
  group    = vim.api.nvim_create_augroup("RuffFormatOnSave", { clear = true }),
  callback = function()
    vim.lsp.buf.format({
      filter = function(client)
        return client.name == "ruff"
      end,
      async = false,
    })
  end,
})

-- ─────────────────────────────────────────
--  Diagnostic display
-- ─────────────────────────────────────────
vim.diagnostic.config({
  virtual_text     = { prefix = "●" },
  signs            = true,
  underline        = true,
  update_in_insert = false,
  severity_sort    = true,
  float = {
    border = "rounded",
    source = true,
  },
})

