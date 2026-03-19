-- ~/.config/nvim/lua/configs/cmp.lua
-- nvim-cmp  ·  hanya insert-mode completion
-- Dioptimasi untuk Termux (debounce, throttle, tanpa docs popup)

local cmp     = require("cmp")
local luasnip = require("luasnip")

-- ─────────────────────────────────────────
--  Helper: tombol Tab / Shift-Tab cerdas
-- ─────────────────────────────────────────
local function tab_next(fallback)
  if cmp.visible() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end

local function tab_prev(fallback)
  if cmp.visible() then
    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

-- ─────────────────────────────────────────
--  Setup utama
-- ─────────────────────────────────────────
cmp.setup({
  -- ── Snippet engine ─────────────────────
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  -- ── Performance (penting di Termux) ────
  performance = {
    debounce          = 80,   -- ms tunggu setelah ketik
    throttle          = 40,   -- ms antar render ulang
    fetching_timeout  = 200,
    max_view_entries  = 10,   -- maksimal item tampil
  },

  -- ── Completion behavior ─────────────────
  completion = {
    completeopt = "menu,menuone,noinsert",
    -- autocomplete hanya ketik 1 karakter
    keyword_length  = 1,
  },

  -- ── Window (tanpa documentation popup) ─
  window = {
    completion = cmp.config.window.bordered({
      border      = "rounded",
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
    }),
    documentation = cmp.config.disable, -- ← doc popup dimatikan
  },

  -- ── Keymaps ─────────────────────────────
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"]   = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"]   = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-b>"]   = cmp.mapping.scroll_docs(-4),
    ["<C-f>"]   = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"]   = cmp.mapping.abort(),
    ["<CR>"]    = cmp.mapping.confirm({ select = false }),
    ["<Tab>"]   = cmp.mapping(tab_next, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(tab_prev, { "i", "s" }),
  }),

  -- ── Sources (hanya LSP + snippet) ───────
  sources = cmp.config.sources({
    { name = "nvim_lsp",              priority = 1000 },
    { name = "luasnip",               priority = 750  },
    { name = "nvim_lsp_signature_help", priority = 500 },
  }, {
    -- fallback: path kalau source utama kosong
    { name = "path", priority = 250 },
  }),

  -- ── Format item di menu ─────────────────
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, item)
      -- label sumber di sebelah kanan
      local source_labels = {
        nvim_lsp    = "[LSP]",
        luasnip     = "[Snip]",
        path        = "[Path]",
      }
      item.menu = source_labels[entry.source.name] or ""
      -- potong teks panjang supaya tidak overflow layar Termux
      if #item.abbr > 30 then
        item.abbr = item.abbr:sub(1, 28) .. "…"
      end
      return item
    end,
  },

  -- ── Eksperimen: matikan preselect ────────
  preselect = cmp.PreselectMode.None,
})

