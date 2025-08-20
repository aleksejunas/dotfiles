return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    require("dashboard").setup({
      theme = "hyper", -- or "doom"
      config = {
        header = {
          "Welcome to LazyVim!",
          "",
        },
        center = {
          {
            icon = " ",
            desc = "Find File           ",
            key = "f",
            action = "Telescope find_files",
          },
          -- Add more items
        },
        footer = { "Happy coding!" },
      },
    })
  end,
}
