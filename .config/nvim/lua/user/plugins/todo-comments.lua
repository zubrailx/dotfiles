return function()
  -- NOTE: remove when https://github.com/folke/todo-comments.nvim/pull/104 will be merged
  local hl = require("todo-comments.highlight")
  local highlight_win = hl.highlight_win
  hl.highlight_win = function(win, force)
    pcall(highlight_win, win, force)
  end

  local todo = require("todo-comments")
  local icons = require("user.icons").comments

  todo.setup {
    signs = false,
    keywords = {
      FIX = {
        icon = icons.fix, -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = icons.todo, color = "info" },
      HACK = { icon = icons.hack, color = "warning" },
      WARN = { icon = icons.warn, color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = icons.perf, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = icons.note, color = "hint", alt = { "INFO" } },
    },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- highlighting of the line containing the todo comment
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
      before = "", -- "fg" or "bg" or empty
      keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
      after = "fg", -- "fg" or "bg" or empty
      pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
      comments_only = true, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = { 'org', 'vimwiki', 'markdown' }, -- list of file types to exclude highlighting
    },
    -- list of named colors where we try to extract the guifg from the
    -- list of hilight groups or use the hex color if hl not found as a fallback
    colors = {
      error = { "#DC2626", "DiagnosticError", "ErrorMsg", },
      warning = { "#FBBF24", "DiagnosticWarning", "WarningMsg", },
      info = { "DiagnosticInfo", "#2563EB", },
      hint = { "#10B981", "DiagnosticHint", },
      default = { "#7C3AED", "Identifier" },
    },
  }
end