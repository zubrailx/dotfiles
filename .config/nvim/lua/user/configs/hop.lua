return function()
  local hop = require("hop")

  -- ISSUE: 't,T' with unicode characters: https://github.com/phaazon/hop.nvim/issues/30701
  hop.setup {
    keys = 'etovxqpdygfbzcisuran',
    quit_key = "<Esc>",
    case_insensitive = true,
    jump_on_sole_occurence = true,
    multi_windows = false,
    current_line_only = false,
    create_hl_autocmd = false
  }

  us.set_keynomap({ "x", "n", "o" }, 's', function()
    hop.hint_char1({
      direction = nil,
      hint_offset = 0,
      current_line_only = false,
    })
  end, "hop: Move multiline included")
  us.set_keynomap({ "x", "n", "o" }, 'F', function()
    hop.hint_char1({
      direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
      hint_offset = 0,
      current_line_only = true,
    })
  end, "hop: Move current line before cursor included")
  us.set_keynomap({ "x", "n", "o" }, 'f', function()
    hop.hint_char1({
      direction = require("hop.hint").HintDirection.AFTER_CURSOR,
      hint_offset = 0,
      current_line_only = true,
    })
  end, "hop: Move current line after cursor included")
  us.set_keynomap({ "x", "n", "o" }, 'T', function()
    hop.hint_char1({
      direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
      hint_offset = 1,
      current_line_only = true,
    })
  end, "hop: Move current line before cursor excluded")
  us.set_keynomap({ "x", "n", "o" }, 't', function()
    hop.hint_char1({
      direction = require("hop.hint").HintDirection.AFTER_CURSOR,
      hint_offset = -1,
      current_line_only = true,
    })
  end, "hop: Move current line after cursor excluded")

  vim.cmd [[
    highlight HopNextKey gui=bold
    highlight HopNextKey1 gui=bold
    highlight HopNextKey2 gui=bold
  ]]
end
