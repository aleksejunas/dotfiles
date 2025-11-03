-- Keymaps for obsidian.nvim are now defined in the plugin spec (lua/plugins/obsidian.lua)
-- to enable lazy-loading via keypress.

-- Telescope for vault
vim.keymap.set("n", "<leader>fn", function()
  require("telescope.builtin").find_files({ cwd = vim.fn.expand("~/notes") })
end, { desc = "Finn notat i vault" })

vim.keymap.set("n", "<leader>fg", function()
  require("telescope.builtin").live_grep({ cwd = vim.fn.expand("~/notes") })
end, { desc = "Søk i notater" })
