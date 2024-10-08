local M = {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  config = function()
    local dv = require("diffview")
    dv.setup({
      enhanced_diff_hl = true,
      default_args = {
        DiffviewFileHistory = { '%' },
      },
      hooks = {
        diff_buf_read = function()
          vim.wo.wrap = false
          vim.wo.list = false
          vim.wo.colorcolumn = ''
        end,
      },
      keymaps = {
        view = { q = '<Cmd>DiffviewClose<CR>' },
        file_panel = { q = '<Cmd>DiffviewClose<CR>' },
        file_history_panel = { q = '<Cmd>DiffviewClose<CR>' },
      },
    })
  end,
  keys = {
    { "<localleader>d",  group = "diffview" },
    { "<localleader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "diffview: file history" },
    { "<localleader>do", "<cmd>DiffviewOpen<cr>",        desc = "diffview: open" },
  }
}

return M
