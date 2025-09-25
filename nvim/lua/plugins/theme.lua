return {
  "folke/tokyonight.nvim",
  "catppuccin/nvim", -- Catppuccin theme
  "EdenEast/nightfox.nvim", -- Nightfox theme
  "navarasu/onedark.nvim", -- Onedark theme
  "shaunsingh/nord.nvim", -- Nord theme
  "morhetz/gruvbox", -- Gruvbox theme
  "sainnhe/everforest", -- Everforest theme
  "sainnhe/sonokai", -- Sonokai theme
  "dracula/vim", -- dracula theme
  "rose-pine/neovim", -- rose pine theme
  "mofiqul/vscode.nvim", -- vscode theme
  "projekt0n/github-nvim-theme", -- github theme
  "olimorris/onedarkpro.nvim", -- onedarkpro theme
  "rebelot/kanagawa.nvim", -- kanagawa theme
  "glepnir/zephyr-nvim", -- zephyr theme
  "marko-cerovac/material.nvim", -- material theme
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("nightfox")
  end,
}
