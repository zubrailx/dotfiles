local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "UIEnter",
  config = function()
    local ts_configs = require("nvim-treesitter.configs")

    local ensure_installed = {
      "c",
      "css",
      "cpp",
      "lua",
      "vim",
      "bash",
      "regex",
      "markdown",
      "markdown_inline",
      "cmake",
      "python",
      "norg",
      "rust",
      "sql",
      "go",
      "java",
      "javascript",
      "make",
      "yaml",
      "verilog",
      "haskell"
    }

    ts_configs.setup({
      ensure_installed = ensure_installed,
      highlight = {
        enable = us.is_vscode and false or true,
      },
      indent = {
        enable = false,
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      sync_install = false,
      auto_install = false,
    })

  end
}

return M
