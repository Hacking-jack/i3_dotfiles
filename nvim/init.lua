vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.termguicolors = true
vim.opt.wrap = true
vim.opt.list = true
vim.opt.listchars = {
  tab = ">>",
  eol = "↲",
  trail = "·",
  space = "·",
}
vim.opt.clipboard = "unnamedplus"

-- ========================
--   Plugins con lazy.nvim
-- ========================
require("lazy.lazy")
vim.cmd("colorscheme tokyonight")
-- ========================
--   LSP config
-- ========================
require("plugin.cmp")
-- ========================
--   LSP config
-- ========================
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local home = os.getenv("HOME")
-- Python
lspconfig.pyright.setup({ capabilities = capabilities })

-- C/C++
lspconfig.clangd.setup({ capabilities = capabilities })

-- JavaScript / TypeScript
lspconfig.ts_ls.setup({ capabilities = capabilities })

-- Java (requiere jdtls instalado aparte)
lspconfig.jdtls.setup({
    cmd = {
        "jdtls",
        "-configuration", home .. "/.cache/jdtls/config",
        "-data", home .. "/.cache/jdtls/workspace"
    },
    capabilities = capabilities,
})



-- ========================
--   Formattrt
-- ========================

-- require("plugin.ls-42")
-- ========================
--   Configuración arbol de arcivos
-- ========================
require("nvim-tree").setup({
    sort_by = "name",
    view = {
        width = 30,         -- ancho del árbol lateral
        side = "left",      -- lado donde aparece
        preserve_window_proportions = true,
    },
    renderer = {
        icons = {
            show = {
                git = true,
                folder = true,
                file = true,
                folder_arrow = true,
            },
        },
    },
    filters = {
        dotfiles = true,     -- mostrar archivos ocultos
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
})
require("keys.generales")
