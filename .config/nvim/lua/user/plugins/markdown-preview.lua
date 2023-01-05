local M = {
  "iamcco/markdown-preview.nvim",
  config = function ()
    vim.g.mkdp_theme = 'dark'
    vim.g.mkdp_auto_close = 0
  end,
  build = function() vim.fn["mkdp#util#install"]() end,
  ft = "markdown",
}

return M
