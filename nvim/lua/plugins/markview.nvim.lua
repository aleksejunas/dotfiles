-- Plugin: OXY2DEV/markview.nvim
-- Installed via store.nvim

return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  keys = {
    { "<leader>mt", "<cmd>Markview toggle<cr>", desc = "Markview: Toggle" },
    { "<leader>me", "<cmd>Markview enable<cr>", desc = "Markview: Enable" },
    { "<leader>md", "<cmd>Markview disable<cr>", desc = "Markview: Disable" },
    { "<leader>ms", "<cmd>Markview splitToggle<cr>", desc = "Markview: Split Toggle" },
    { "<leader>mo", "<cmd>Markview splitOpen<cr>", desc = "Markview: Split Open" },
    { "<leader>mc", "<cmd>Markview splitClose<cr>", desc = "Markview: Split Close" },
    { "<leader>mr", "<cmd>Markview splitRedraw<cr>", desc = "Markview: Split Redraw" },
    { "<leader>mh", "<cmd>Markview hybridToggle<cr>", desc = "Markview: Hybrid Toggle" },
  },
  config = function()
    require("markview").setup()

    -- Auto-refresh splitview on text changes
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
      pattern = "*.md",
      callback = function()
        vim.cmd("silent! Markview splitRedraw")
      end,
    })
  end,
}
