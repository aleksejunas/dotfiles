-- Autokommando som fyller nye dagboksfiler hvis de åpnes via kalenderen før
-- :ObsidianToday har laget dem.

local journal_glob = vim.fn.expand("~/Obsidian/AreaFiftyOne_RS/AreFiftyOne_RS/journal/*.md")

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = journal_glob,
  callback = function(args)
    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
    if #lines == 1 and lines[1] == "" then
      local date = vim.fn.fnamemodify(args.file, ":t:r") -- YYYY-MM-DD
      local stub = {
        "---",
        "created: " .. date,
        "type: daily",
        "---",
        "",
        "# " .. date,
        "",
        "## Dagens fokus",
        "- ",
        "",
        "## Notater",
        "- ",
        "",
        "## Logg",
        "- ",
      }
      vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, stub)
    end
  end,
})
