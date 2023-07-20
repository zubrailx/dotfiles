local M = {
  "iamcco/markdown-preview.nvim",
  ft = "markdown",
  build = function() vim.fn["mkdp#util#install"]() end,
  config = function()
    vim.g.mkdp_theme = 'dark'
    vim.g.mkdp_auto_close = 0
  end,
}

return M
