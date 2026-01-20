-- Plugin: epwalsh/obsidian.nvim
-- Installed via store.nvim

return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  event = {
    "BufReadPre " .. vim.fn.expand("~/Obsidian/AreaFiftyOne_RS/AreaFiftyOne_RS") .. "/*.md",
    "BufNewFile " .. vim.fn.expand("~/Obsidian/AreaFiftyOne_RS/AreaFiftyOne_RS") .. "/*.md",
  },
  keys = {
    { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: Dagens notat" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Obsidian: I går" },
    { "<leader>ot", "<cmd>ObsidianTomorrow<cr>", desc = "Obsidian: I morgen" },
    { "gx", "<cmd>ObsidianFollowLink<cr>", desc = "Følg wiki-link" },
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Obsidian/AreaFiftyOne_RS/AreaFiftyOne_RS",
      },
      -- {
      --   name = "work",
      --   path = "~/vaults/work",
      -- },
    },
    -- daglige notater i samme mappe som calendar.vim
    daily_notes = {
      folder = "journal",
      date_format = "%Y-%m-%d",
      template = "daily.md",
    },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    completion = { nvim_cmp = true },
    ui = { enable = true },

    -- see below for full list of options 👇
  },
}
