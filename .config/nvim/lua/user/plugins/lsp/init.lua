return function ()
  local status_ok, _ = us.safe_require("lspconfig")
  if not status_ok then
    return
  end

  require("user.plugins.lsp.lsp_installer")
  require("user.plugins.lsp.handlers").setup()
  require("user.plugins.lsp.null-ls")
end
