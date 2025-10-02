
local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),               -- Abrir menú con Ctrl+Espacio
    ["<CR>"] = cmp.mapping.confirm({ select = true }),    -- Confirmar con Enter
    ["<Down>"] = cmp.mapping.select_next_item(),           -- Navegar con Tab
    ["<Up>"] = cmp.mapping.select_prev_item(),         -- Navegar atrás con Shift+Tab
  }),
  sources = {
    { name = "nvim_lsp" }, -- Fuente principal: LSP
    { name = "luasnip" },  -- Fuente de snippets
	{ name = "buffer" },  -- sugerencias del buffer actual
    { name = "path" },    -- rutas de archivos
  },
})
