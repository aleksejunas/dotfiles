return {
  {
    "vim-pandoc/vim-pandoc",
    ft = "markdown", -- Only load for markdown files
    config = function()
      -- Enable vim-pandoc commands
      vim.g.pandoc_filetypes_pandoc_markdown = 1
      vim.g.pandoc_modules_disabled = {} -- Enable all modules
    end,
  },
  {
    "vim-pandoc/vim-pandoc-syntax",
    ft = "markdown", -- Only load for markdown files
  },
}
