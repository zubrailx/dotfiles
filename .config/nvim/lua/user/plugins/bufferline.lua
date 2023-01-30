local M = {
  "akinsho/bufferline.nvim",
  event = "UIEnter",
}

function M.config()
  local bufferline = require("bufferline")
  local icons = require("user.icons").bufferline

  bufferline.setup {
    options = {
      mode = "buffers",
      numbers = "none",
      close_command = "Bdelete! %d",
      right_mouse_command = "Bdelete! %d",
      left_mouse_command = "buffer %d",

      indicator = {
        icon = icons.indicator,
        style = 'icon',
      },
      buffer_close_icon = icons.buffer_close,
      modified_icon = icons.modified,
      close_icon = icons.tab_close,
      left_trunc_marker = icons.truncate_left,
      right_trunc_marker = icons.truncate_right,

      max_name_length = 25,
      max_prefix_length = 25, -- prefix used when a buffer is de-duplicated
      tab_size = 18,
      separator_style = { "", "" },

      diagnostics = false,
      diagnostics_update_in_insert = false,

      offsets = { { filetype = "NvimTree", text = "EXPLORER", text_align = "center" } },
      -- offsets = {
        --  { filetype = "NvimTree", text = "", text_align = "center", padding = 1 }
      -- },

      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_buffer_default_icon = true,
      show_close_icon = true,
      show_tab_indicators = true,

      persist_buffer_sort = true,
      enforce_regular_tabs = true,
      always_show_bufferline = true,
    },
    highlights = {
      fill = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLineNC" },
      },
      background = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLine" },
      },
      buffer_visible = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
      },
      buffer_selected = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
      },
      separator = {
        fg = { attribute = "bg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLine" },
      },
      separator_selected = {
        fg = { attribute = "fg", highlight = "Special" },
        bg = { attribute = "bg", highlight = "Normal" },
      },
      separator_visible = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLineNC" },
      },
      close_button = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLine" },
      },
      close_button_selected = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
      },
      close_button_visible = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
      },
    },
  }
end

return M
