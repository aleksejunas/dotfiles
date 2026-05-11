-- ~/.config/nvim/lua/plugins/refactoring.lua
return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "lewis6991/async.nvim",
  },
  keys = {
    {
      "<leader>re",
      function()
        require("refactoring").extract_func()
      end,
      mode = { "n", "x" },
      desc = "Extract Function",
    },
    {
      "<leader>rF",
      function()
        require("refactoring").extract_func_to_file()
      end,
      mode = { "n", "x" },
      desc = "Extract Function to File",
    },
    {
      "<leader>rx",
      function()
        require("refactoring").extract_var()
      end,
      mode = { "n", "x" },
      desc = "Extract Variable",
    },
    {
      "<leader>ri",
      function()
        require("refactoring").inline_var()
      end,
      mode = { "n", "x" },
      desc = "Inline Variable",
    },
    {
      "<leader>rI",
      function()
        require("refactoring").inline_func()
      end,
      mode = { "n", "x" },
      desc = "Inline Function",
    },
    {
      "<leader>rr",
      function()
        require("refactoring").select_refactor()
      end,
      mode = { "n", "x" },
      desc = "Select Refactor",
    },
  },
}
