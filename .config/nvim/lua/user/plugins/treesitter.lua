local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate"
}

function M.config()
  local ts_configs = require("nvim-treesitter.configs")
  ts_configs.setup({
    ensure_installed = {
      "c",
      "cpp",
      "lua",
      "vim",
      "bash",
      "regex",
      "markdown",
      "markdown_inline",
      "cmake",
      "python",
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    sync_install = false,
    auto_install = false,
  })
end

return M
