-- ~/.config/nvim/lua/config/options.lua
local opt = vim.opt

-- Usar tabulaciones reales de 4 espacios
opt.expandtab = false      -- No convertir tabs a espacios
opt.tabstop = 4            -- Un tab equivale a 4 espacios (visual)
opt.shiftwidth = 4         -- Sangría de 4 espacios reales (tab)
opt.softtabstop = 4        -- Lo que se borra con <BS> en insert mode

-- Número de línea
opt.number = true
opt.relativenumber = true

-- Líneas largas: resalta si se exceden 80 columnas
opt.colorcolumn = "81"     -- Muestra una línea vertical en la columna 81

-- Visual: resaltado de línea actual y colores verdaderos
opt.cursorline = true
opt.termguicolors = true

-- Columnas invisibles que ayudan a cumplir normas de estilo
opt.list = true
opt.listchars = {
    tab = '→ ',
    trail = '·',
    space = '·',
    eol = '↴'
}

-- Prevención de errores comunes
opt.wrap = false           -- No cortar líneas automáticamente
opt.textwidth = 80         -- Ancho máximo de texto para formateo manual
opt.formatoptions:remove('t') -- No autoinsertar saltos de línea
opt.autoindent = true
opt.smartindent = true

-- Interfaz
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.splitbelow = true
opt.splitright = true

