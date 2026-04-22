-- Plugin: coder/claudecode.nvim
-- Installed via store.nvim

return {
  "coder/claudecode.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    -- Tvinger prosessen til å tro at den har god plass (hindrer hard-wrap klipping)
    vim.env.COLUMNS = 300
    vim.env.LINES = 50

    require("claudecode").setup({
      split_width_percentage = 0.40,
    })

    -- Autocommand som fikser UI-en hver gang Claude åpnes
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*claudecode*",
      callback = function()
        -- Tillat myk linjebryting så tekst ikke forsvinner
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true

        -- Fjern marger som stjeler plass
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.foldcolumn = "0"

        -- Tving terminalen til å oppdatere seg til vinduets størrelse
        vim.cmd("startinsert")
      end,
    })
  end,
  keys = {
    {
      "<leader>a",
      nil,
      desc = "AI/Claude Code",
    },
    {
      "<leader>ac",
      "<cmd>ClaudeCode<cr>",
      desc = "Toggle Claude",
    },
    {
      "<leader>af",
      "<cmd>ClaudeCodeFocus<cr>",
      desc = "Focus Claude",
    },
    {
      "<leader>ar",
      "<cmd>ClaudeCode --resume<cr>",
      desc = "Resume Claude",
    },
    {
      "<leader>aC",
      "<cmd>ClaudeCode --continue<cr>",
      desc = "Continue Claude",
    },
    {
      "<leader>am",
      "<cmd>ClaudeCodeSelectModel<cr>",
      desc = "Select Claude model",
    },
    {
      "<leader>ab",
      "<cmd>ClaudeCodeAdd %<cr>",
      desc = "Add current buffer",
    },
    {
      "<leader>as",
      "<cmd>ClaudeCodeSend<cr>",
      mode = "v",
      desc = "Send to Claude",
    },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = {
        "NvimTree",
        "neo-tree",
        "oil",
        "minifiles",
        "netrw",
      },
    },
    {
      "<leader>aa",
      "<cmd>ClaudeCodeDiffAccept<cr>",
      desc = "Accept diff",
    },
    {
      "<leader>ad",
      "<cmd>ClaudeCodeDiffDeny<cr>",
      desc = "Deny diff",
    },
  },
}
