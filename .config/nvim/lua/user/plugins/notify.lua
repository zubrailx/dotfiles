local M = {
  "rcarriga/nvim-notify",
}

function M.config()
  local notify = require('notify')
  local renderer = require('notify.render')

  notify.setup {
    --stages = "fade_in_slide_out",
    timeout = 0,
    fps = 30,
    level = vim.log.levels.INFO,
    max_width = function() return math.floor(vim.o.columns * 0.6) end,
    max_height = function() return math.floor(vim.o.lines * 0.6) end,
    render = function(bufnr, notif, highlights, config)
      local style = notif.title[1] == '' and 'minimal' or 'default'
      renderer[style](bufnr, notif, highlights, config)
    end,
  }

  -- Also: https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes
  vim.notify = notify
  if not pcall(function() require("telescope").load_extension("notify") end) then
    vim.notify("module 'telescope' for nvim-notify is not present", vim.log.levels.WARN, { title = "config" })
  end
end

return M
