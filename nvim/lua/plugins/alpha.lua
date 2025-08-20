return {
  "goolord/alpha-nvim",
  config = function()
    local theta = require("alpha.themes.theta")

    -- Static header with proper ASCII art
    theta.header.val = {
      "                                                                                                 ",
      " |  |--..--.--..-----..-----.   .-----..-----..--.--.--.   .----..-----..--|  ||__|.-----..-----.",
      " |    < |  |  ||     ||  _  |   |  _  ||  _  ||  |  |  |   |  __||  _  ||  _  ||  ||     ||  _  |",
      " |__|__||_____||__|__||___  |   |   __||_____||________|   |____||_____||_____||__||__|__||___  |",
      "                      |_____|   |__|                                                      |_____|",
    }

    -- Custom MRU filtering to exclude unwanted files
    local default_mru_ignore = { "gitcommit", "gitrebase", "svn", "hgcommit" }
    local custom_mru_opts = {
      ignore = function(path, ext)
        -- Filter out scratch buffers, temp files, and encoded paths
        if string.find(path, "COMMIT_EDITMSG") then
          return true
        end
        if string.find(path, "%%7C") then
          return true
        end -- URL encoded characters
        if string.find(path, "Scratch") then
          return true
        end
        if string.find(path, "alpha%-nvim") then
          return true
        end
        if string.find(path, "%.tmp") then
          return true
        end
        if string.find(path, "%.git/") then
          return true
        end
        if vim.tbl_contains(default_mru_ignore, ext) then
          return true
        end
        return false
      end,
      autocd = false,
    }

    -- Override the MRU options in theta
    theta.mru_opts = custom_mru_opts

    -- Programming humor quotes
    local humor_quotes = {
      "99 little bugs in the code, 99 little bugs. Take one down, patch it around, 117 little bugs in the code.",
      "There are only 10 types of people: those who understand binary and those who don't.",
      "Programming is like sex: one mistake and you have to support it for the rest of your life.",
      "A SQL query goes into a bar, walks up to two tables and asks: 'Can I join you?'",
      "Why do programmers prefer dark mode? Because light attracts bugs!",
      "How many programmers does it take to change a light bulb? None, that's a hardware problem.",
      "I would tell you a UDP joke, but you might not get it.",
      "Why do Java developers wear glasses? Because they can't C#!",
      "There are two hard things in computer science: cache invalidation, naming things, and off-by-one errors.",
      "I'm not a great programmer; I'm just a good programmer with great habits... and Stack Overflow.",
      "Programming is 10% science, 20% ingenuity, and 70% getting the ingenuity to work with the science.",
      "Debugging: Being the detective in a crime movie where you are also the murderer.",
      "Code never lies, comments sometimes do, but documentation is pure fiction.",
      "If debugging is the process of removing bugs, then programming must be the process of putting them in.",
      "A programmer is told to 'go to hell', he finds the worst part of that statement is the 'go to'.",
    }

    local function random_humor()
      return "😄 " .. humor_quotes[math.random(#humor_quotes)]
    end

    -- Plugin count and load time with nil checks
    local function plugin_info()
      local lazy_ok, lazy = pcall(require, "lazy")
      if not lazy_ok then
        return "⚡ Lazy not loaded"
      end

      local count = 0
      local plugins = lazy.plugins()
      if plugins then
        for _ in pairs(plugins) do
          count = count + 1
        end
      end

      local load_time = "unknown"

      -- First try the global variable set by lazy.lua
      if _G.lazy_startup_time then
        load_time = _G.lazy_startup_time .. "ms"
      else
        -- Fallback to lazy stats
        local stats = lazy.stats()
        if stats and stats.startuptime and stats.startuptime > 0 then
          load_time = math.floor(stats.startuptime * 100) / 100 .. "ms"
        end
      end

      return "⚡ " .. count .. " plugins loaded in " .. load_time
    end

    -- Git status with nil checks
    local function git_status()
      local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
      if not handle then
        return "📁 Git status unavailable"
      end

      local is_git = handle:read("*a")
      handle:close()

      if not is_git or is_git:gsub("\n", "") ~= "true" then
        return "📁 Not a git repository"
      end

      local branch_handle = io.popen("git branch --show-current 2>/dev/null")
      local branch = "unknown"
      if branch_handle then
        local branch_result = branch_handle:read("*a")
        if branch_result then
          branch = branch_result:gsub("\n", "")
        end
        branch_handle:close()
      end

      local status_handle = io.popen("git status --porcelain 2>/dev/null | wc -l")
      local changes = "0"
      if status_handle then
        local changes_result = status_handle:read("*a")
        if changes_result then
          changes = changes_result:gsub("\n", "")
        end
        status_handle:close()
      end

      if tonumber(changes) and tonumber(changes) > 0 then
        return "🌿 " .. branch .. " (" .. changes .. " changes)"
      else
        return "🌿 " .. branch .. " (clean)"
      end
    end

    -- Dynamic footer with system info
    local function dynamic_footer()
      local datetime = os.date("📅 %d-%m-%Y  🕐 %H:%M:%S")
      local version = vim.version()
      local nvim_version = "🚀 Neovim v" .. version.major .. "." .. version.minor .. "." .. version.patch

      return {
        "",
        git_status(),
        "",
        plugin_info(),
        "",
        datetime .. "  " .. nvim_version,
        "",
        random_humor(),
        "",
      }
    end

    -- Modify buttons with proper icons including session manager
    theta.buttons.val = {
      { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
      { type = "padding", val = 1 },
      require("alpha.themes.dashboard").button("e", "󰈮  New file", "<cmd>ene<CR>"),
      require("alpha.themes.dashboard").button("SPC f f", "󰈞  Find file"),
      require("alpha.themes.dashboard").button("SPC f g", "󰊄  Live grep"),
      require("alpha.themes.dashboard").button("SPC f r", "󰄉  Recent files"),
      require("alpha.themes.dashboard").button(
        "SPC s l",
        "󰦛  Restore Session",
        "<cmd>lua require('persistence').load()<CR>"
      ),
      require("alpha.themes.dashboard").button(
        "c",
        "  Kung-fu(giration)",
        "<cmd>cd " .. vim.fn.stdpath("config") .. "<CR>"
      ),
      require("alpha.themes.dashboard").button("x", "󰒲  Lazy Extras", "<cmd>LazyExtras<CR>"),
      require("alpha.themes.dashboard").button("u", "󰚰  Update plugins", "<cmd>Lazy sync<CR>"),
      require("alpha.themes.dashboard").button("q", "󰅚  Quit", "<cmd>qa<CR>"),
    }

    -- Add dynamic footer to the layout
    table.insert(theta.config.layout, { type = "padding", val = 2 })
    table.insert(theta.config.layout, {
      type = "text",
      val = function()
        return dynamic_footer()
      end,
      opts = { position = "center", hl = "Comment" },
    })

    -- Setup alpha with the complete theta config
    require("alpha").setup(theta.config)
  end,
}
