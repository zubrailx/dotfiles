local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.plugins.lsp.lsp_installer"
require("user.plugins.lsp.handlers").setup()