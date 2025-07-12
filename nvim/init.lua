-- ~/.config/nvim/init.lua
require("config.options")
require("config.lazy")
-- -- Bootstrap lazy.nvim (instala si no está)
-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
--   vim.fn.system({
--     "git", "clone", "--filter=blob:none",
--     "https://github.com/folke/lazy.nvim.git",
--     "--branch=stable", lazypath,
--   })
-- end
-- vim.opt.rtp:prepend(lazypath)
-- 
-- -- Carga tu configuración de lazy (plugins)
-- require("config.lazy")
-- 
-- -- Aquí cargas otras configuraciones como options, keymaps, etc
-- require("config.options")
-- 
