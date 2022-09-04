local M = {}
M.setup = function()
  local kmps = require("user.keymaps").git
  us.set_keynomap("n", kmps.diffview_open.key, '<cmd>DiffviewOpen<cr>', kmps:desc("diffview_open"))
  us.set_keynomap("n", kmps.diffview_history.key, '<cmd>DiffviewFileHistory<cr>', kmps:desc("diffview_history"))
end

M.config = function()
  local actions = require("diffview.actions")

  require("diffview").setup({
    diff_binaries = true,
    enhanced_diff_hl = true,
    use_icons = true,
    file_panel = {
      win_config = {
        position = "left",
        width = 30,
      },
    },
    file_history_panel = {
      win_config = {
        position = "bottom",
        height = 16,
      },
    },
    hooks = {
      diff_buf_read = function(bufnr)
        -- Change local options in diff buffers
        vim.opt_local.wrap = false
        vim.opt_local.list = false
        vim.opt_local.colorcolumn = { 80 }
      end,
    },
    keymaps = {
      view = {
        q = "<cmd>DiffviewClose<cr>",
      },
      file_panel = {
        q = "<cmd>DiffviewClose<cr>",
      },
      file_history_panel = {
        q = "<cmd>DiffviewClose<cr>",
      },
    },
  })
end

return M
