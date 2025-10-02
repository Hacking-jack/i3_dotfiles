
vim.g.mapleader = " "  -- Leader = Espacio

-- Guardar y salir
vim.keymap.set("n", "<leader>w", ":w<CR>")     -- Guardar
vim.keymap.set("n", "<leader>q", ":q<CR>")     -- Salir
vim.keymap.set("n", "<leader>x", ":x<CR>")     -- Guardar y salir
vim.keymap.set("n", "<leader><ESC>",":q!<CR>")		--No guaradar y salir 
-- Archivos y búsqueda (requiere Telescope)
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")  -- Buscar archivo
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")   -- Buscar texto
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")     -- Buffers abiertos
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")   -- Ayuda rápida

-- Explorador de archivos (requiere nvim-tree)
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- LSP (requiere nvim-lspconfig + nvim-cmp)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)           -- Renombrar (Shift+F6 en JetBrains)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)      -- Acción rápida / refactor
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition)       -- Ir a definición
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references)       -- Ver referencias
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation)   -- Ir a implementación
vim.keymap.set("n", "<leader>gh", vim.lsp.buf.hover)            -- Documentación flotante

-- Ventanas
vim.keymap.set("n", "<leader>sv", "<C-w>v")  -- Split vertical
vim.keymap.set("n", "<leader>sh", "<C-w>s")  -- Split horizontal
vim.keymap.set("n", "<leader>se", "<C-w>=")  -- Igualar tamaño splits
vim.keymap.set("n", "<leader>sc", ":close<CR>") -- Cerrar split

-- Terminal flotante (requiere toggleterm.nvim)
vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>")
--Funciones de copiado
-- Copiar al portapapeles con <Leader>y
vim.keymap.set({"n", "v"}, "<leader>y", '"+y', { desc = "Copiar al portapapeles" })

-- Pegar desde el portapapeles con <Leader>p
vim.keymap.set({"n", "v"}, "<leader>p", '"+p', { desc = "Pegar desde el portapapeles" })
-- Deshacer
vim.keymap.set({"n","v"},"<leader>z",":undo<CR>") --equivalente a crtl + z
