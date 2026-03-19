-- ~/.config/nvim/lua/configs/treesitter.lua
-- Dikembalikan sebagai table, di-load via:
--   opts = require("configs.treesitter")  ← di plugins/init.lua

return {

  -- ── Parser yang di-install ───────────────
  ensure_installed = {
    "python",
    "lua",
    "luadoc",
    "vim",
    "vimdoc",
    "bash",
    "json",
    "toml",
    "markdown",
    "markdown_inline",
  },

  auto_install = false,

  -- ── Highlight ────────────────────────────
  highlight = {
    enable  = true,
    additional_vim_regex_highlighting = false,
    -- Disable untuk file >100 KB supaya tidak lag di Termux
    disable = function(_, buf)
      local max_filesize = 100 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },

  -- ── Indentation ──────────────────────────
  indent = {
    enable  = true,
    disable = { "python" }, -- TS indent Python sering meleset
  },

  -- ── Incremental selection ─────────────────
  incremental_selection = {
    enable  = true,
    keymaps = {
      init_selection    = "<C-space>",
      node_incremental  = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental  = "<M-space>",
    },
  },
}

