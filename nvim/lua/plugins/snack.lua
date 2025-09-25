return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      filters = {
        dotfiles = true,
        gitignore = false, -- <— viser også .env
      },
    },
  },
}
