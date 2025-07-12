-- autovmp.lua - Autocompletado con nvim-cmp y clangd para C

-- Protege el require por si falta algún plugin
local has_cmp, cmp = pcall(require, 'cmp')
if not has_cmp then
  vim.notify('nvim-cmp no está instalado')
  return
end

local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not has_lspconfig then
  vim.notify('nvim-lspconfig no está instalado')
  return
end

local has_snip, luasnip = pcall(require, 'luasnip')
if not has_snip then
  vim.notify('LuaSnip no está instalado')
  return
end

-- Configuración de nvim-cmp
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }),
})

-- Capabilities para que cmp funcione con LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configurar clangd para C/C++
lspconfig.clangd.setup({
  capabilities = capabilities,
})

