return {
  -- Tema de colores
  {
    "navarasu/onedark.nvim",
    config = function()
      vim.cmd.colorscheme("onedark")
    end
  },
  
  -- Barra de estado
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end
  },
  
  -- Navegador de archivos
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
    end
  }
}
