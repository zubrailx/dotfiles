local M = {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
  },
  config = function()
    local null_ls = require("null-ls")
    local options = p_require("lspconfig").lspconfig_get_options()

    local code_actions = null_ls.builtins.code_actions
    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting
    local completion = null_ls.builtins.completion
    local hover = null_ls.builtins.hover

    local sources = {
      -- python
      -- diagnostics.pylint,
      -- diagnostics.mypy.with { extra_args = { "--strict" } },
      formatting.black,

      -- proto
      diagnostics.protolint,
    }

    null_ls.setup({
      debounce = options.flags.debounce,
      save_after_format = false,
      debug = false,
      on_attach = options.on_attach,
      diagnostics_format = "[#{c}] #{m} (#{s})",
      sources = sources
    })
  end
}

return M
