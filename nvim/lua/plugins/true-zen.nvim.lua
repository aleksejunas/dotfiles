return {
  "pocco81/true-zen.nvim",
  event = "VeryLazy",
  config = function()
    require("true-zen").setup({})

    local truezen = require("true-zen")
    local keymap = vim.keymap

    keymap.set("n", "<leader>zn", function()
      local first = 0
      local last = vim.api.nvim_buf_line_count(0)
      truezen.narrow(first, last)
    end, { noremap = true, desc = "Narrow (entire buffer)" })

    keymap.set("v", "<leader>zn", function()
      local first = vim.fn.line("v")
      local last = vim.fn.line(".")
      truezen.narrow(first, last)
    end, { noremap = true, desc = "Narrow (selection)" })

    keymap.set("n", "<leader>zf", truezen.focus, { noremap = true, desc = "Focus mode" })
    keymap.set("n", "<leader>zm", truezen.minimalist, { noremap = true, desc = "Minimalist mode" })
    keymap.set("n", "<leader>za", truezen.ataraxis, { noremap = true, desc = "Ataraxis mode" })
  end,
}
