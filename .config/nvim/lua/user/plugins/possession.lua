local M = {
  "jedrzejboczar/possession.nvim",
  enabled = false,
  config = function()
    local possession = require("possession")
    possession.setup({
      silent = true,
      load_silent = true,
      autosave = {
        current = true, -- or fun(name): boolean
        tmp = false,  -- or fun(): boolean
        on_load = true,
        on_quit = true,
      },
      plugins = {
        delete_buffers = true
      }
    })
  end
}

return M
