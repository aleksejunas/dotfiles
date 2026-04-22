-- Plugin: maskudo/devdocs.nvim
-- Installed via store.nvim

return {
  "maskudo/devdocs.nvim",
  lazy = false,
  dependencies = {
    "folke/snacks.nvim",
  },
  cmd = { "DevDocs" },
  keys = {
    {
      "<leader>Do",
      mode = "n",
      "<cmd>DevDocs get<cr>",
      desc = "Get Devdocs",
    },
    {
      "<leader>Di",
      mode = "n",
      "<cmd>DevDocs install<cr>",
      desc = "Install Devdocs",
    },
    {
      "<leader>Dv",
      mode = "n",
      function()
        local devdocs = require("devdocs")
        local installedDocs = devdocs.GetInstalledDocs()
        vim.ui.select(installedDocs, {}, function(selected)
          if not selected then
            return
          end
          local docDir = devdocs.GetDocDir(selected)
          -- prettify the filename as you wish
          Snacks.picker.files({
            cwd = docDir,
          })
        end)
      end,
      desc = "Get Devdocs",
    },
    {
      "<leader>Dd",
      mode = "n",
      "<cmd>DevDocs delete<cr>",
      desc = "Delete Devdoc",
    },
  },
  opts = {
    ensure_installed = {
      "go",
      "html",
      -- "dom",
      "http",
      -- "css",
      -- "javascript",
      -- "rust",
      -- some docs such as lua require version number along with the language name
      -- check `DevDocs install` to view the actual names of the docs
      "lua~5.1",
      -- "openjdk~21"
    },
  },
}
