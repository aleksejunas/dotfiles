-- Plugin: itchyny/calendar.vim
-- Installed via store.nvim

return {
  {
    "itchyny/calendar.vim",
    cmd = { "Calendar", "CalendarH", "CalendarT" },
    init = function()
      -- Peker dagbok til samme mappe som Obsidian sine daily notes
      vim.g.calendar_diary = vim.fn.expand("~/Obsidian/AreaFiftyOne_RS/AreaFiftyOne_RS/journal")
      vim.g.calendar_diary_extension = ".md"
    end,
    config = function()
      -- Valgfritt: keymap for kjapp åpning
      vim.keymap.set("n", "<leader>kc", ":CalendarT<CR>", { desc = "Kalender (top)" })
    end,
  },
}
