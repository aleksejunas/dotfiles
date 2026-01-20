-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.set("n", "H", "0", { desc = "Start of current line" })
-- vim.keymap.set("n", "L", "$", { desc = "End of current line" })

vim.keymap.set("n", "-", "/") -- search forward
vim.keymap.set("n", "_", "?") -- search backwards

vim.keymap.set("n", "<leader>{", "{")
vim.keymap.set("n", "<leader>}", "}")

-- Better Brackets

vim.keymap.set("n", "<leader>{", "{")
vim.keymap.set("n", "<leader>}", "}")
vim.keymap.set("n", "<leader>[", "[")
vim.keymap.set("n", "<leader>]", "]")

-- vim.keymap.set("i", "<c-b>", "[]<Left>")
-- vim.keymap.set("i", "<c-d>", "{}<Left>")
