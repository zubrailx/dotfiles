local colorscheme = "darkplus"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
vim.cmd("hi VertSplit gui=NONE")

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

-- additional options for colorscheme
vim.cmd("hi clear TSComment")
vim.cmd("hi link TSComment Comment")

vim.cmd("hi clear Cursor")
vim.cmd("hi Cursor guibg=#cccccc")
vim.cmd("hi clear NonText")
vim.cmd("hi link NonText IndentBlanklineChar")
