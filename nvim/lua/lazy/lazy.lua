vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")
require("lazy").setup({
    -- Ejemplo de plugins básicos
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-lualine/lualine.nvim" },
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "neovim/nvim-lspconfig" }, -- Soporte LSP
    {
        "hrsh7th/nvim-cmp", -- Motor de autocompletado
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- Fuente LSP para autocompletado
            "L3MON4D3/LuaSnip",     -- Snippets
        },
    },
    { "hrsh7th/cmp-buffer" },   -- Autocompletado del buffer actual
    { "hrsh7th/cmp-path" },     -- Autocompletado de rutas de archivos
    { "folke/tokyonight.nvim" },
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
   {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local npairs = require("nvim-autopairs")
            npairs.setup {}
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
{
  "Diogo-ss/42-header.nvim",
  cmd = { "Stdheader" },
  keys = { "<F1>" },
  opts = {
    default_map = true, -- Default mapping <F1> in normal mode.
    auto_update = true, -- Update header when saving.
    user = "danrodr3", -- Your user.
    mail = "danrodr3@students.42madrid.com", -- Your mail.
    -- add other options.
  },
  config = function(_, opts)
    require("42header").setup(opts)
  end,
}
}, {
    rocks = { enabled = false }, -- 🔧 Desactiva soporte de LuaRocks
})
