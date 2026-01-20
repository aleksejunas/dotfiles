-- Plugin: hakonharnes/img-clip.nvim
-- Installed via store.nvim

return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    -- suggested keymap
    {
      "<leader>i",
      "<cmd>PasteImage<cr>",
      desc = "Paste image from system clipboard",
    },
  },
}

