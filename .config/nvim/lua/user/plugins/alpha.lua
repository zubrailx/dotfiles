local M = {
  "goolord/alpha-nvim",
}

function M.config()
  local alpha = require("alpha")
  -- Imports
  local theme = require("alpha.themes.dashboard")
  local icons = require("user.icons").alpha
  -- Header
  local header = {
    type = "text",
    val = theme.section.header.val,
    opts = {
      position = "center",
      hl = "Character"
    }
  }
  -- Buttons
  local buttons = {
    type = "group",
    val = {
      -- Files
      theme.button("e", icons.File .. " Plain file", "<cmd>ene<cr>"),
      theme.button("c", icons.Settings .. " Edit config", "<cmd>e $MYVIMRC<cr><cmd>ProjectRoot<cr>"),

      -- Session
      theme.button("v", icons.Reference .. " Restore current session", "<cmd>RestoreSession<cr>"),
      theme.button("u", icons.SignIn .. " Find session", "<cmd>Telescope session-lens search_session<cr><cmd>ProjectRoot<cr>"),
      -- theme.button("y", icons.Reference .. " Restore current session", "<cmd>lua require('persistence').load()<cr>"),
      
      -- Telescope
      theme.button("s", icons.FindFile .. " Find file", "<cmd>Telescope find_files<CR>"),
      theme.button("r", icons.RecentlyUsed .. " Recently used files", "<cmd>Telescope oldfiles<CR>"),
      theme.button("p", icons.Folder .. " Find project", "<cmd>Telescope projects<cr><cmd>ProjectRoot<cr>"),
      theme.button("l", icons.Text .. " Find text", "<cmd>Telescope live_grep<CR>"),
      theme.button("t", icons.Telescope .. " Open Telescope", "<cmd>Telescope<cr>"),

      -- Others
      theme.button("h", icons.Checkhealth .. " Checkhealth", "<cmd>checkhealth<cr>"),
      theme.button("q", icons.Quit .. " Quit nvim", "<cmd>qa<cr>"),
    },
    opts = {
      spacing = 1,
    }
  }
  -- Footer
  local footer = {
    type = "text",
    val = {
      "https://github.com/zubrailx"
    },
    opts = {
      position = "center",
      hl = "Number",
    },
  }
  -- Config
  local config = {
    layout = {
      { type = "padding", val = 2 },
      header,
      { type = "padding", val = 2 },
      buttons,
      { type = "padding", val = 1 },
      footer
    },
    opts = {
      margin = 0,
    }
  }
  alpha.setup(config)
end

return M
