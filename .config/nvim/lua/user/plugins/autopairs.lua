return function()
  -- Setup nvim-cmp.
  local autopairs = require("nvim-autopairs")

  autopairs.setup {
    disable_in_visualblock = true,
    disable_filetype = { "TelescopePrompt", },
    check_ts = true,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    fast_wrap = {
      map = '<M-e>',
      chars = { '{', '[', '(', '"', "'" },
      pattern = [=[[%'%"%)%>%]%)%}%,]]=],
      end_key = 'L',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
      highlight = 'Search',
      highlight_grey = 'Comment'
    },
    ignored_next_char = "[%w%.]" -- will ignore alphanumeric and `.` symbol
  }

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp_status_ok, cmp = safe_require("cmp")
  if not cmp_status_ok then
    return
  end
  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
end
