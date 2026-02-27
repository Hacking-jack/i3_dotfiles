-- ========================
--   Opciones generales
-- ========================
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
require("plugins")

-- ========================
--   Colorscheme
-- ========================
vim.cmd("colorscheme tokyonight")

-- ========================
--   Autocompletado (cmp)
-- ========================
require("plugin.cmp")

-- ========================
--   LSP config
-- ========================
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local home = os.getenv("HOME")

lspconfig.pyright.setup({ capabilities = capabilities })
lspconfig.clangd.setup({ capabilities = capabilities })
lspconfig.ts_ls.setup({ capabilities = capabilities })

lspconfig.jdtls.setup({
    cmd = {
        "jdtls",
        "-configuration", home .. "/.cache/jdtls/config",
        "-data", home .. "/.cache/jdtls/workspace"
    },
    capabilities = capabilities,
})

-- ========================
--   Norma 42 (opcional)
-- ========================
-- require("plugin.ls-42")

-- ========================
--   Árbol de archivos
-- ========================
require("nvim-tree").setup({
    sort_by = "name",
    view = {
        width = 30,
        side = "left",
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
        dotfiles = true,
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
})

-- ========================
--   Keymaps
-- ========================
require("keys.generales")
