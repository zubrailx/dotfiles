local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    underline = true,
    virtual_text = false, -- disable virtual text
    signs = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      prefix = "",
      header = "",
    },
  })

  -- Handler opts
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    width = 60,
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    width = 60,
  })
end

-- NOTE: check is based on server_capabilities, not on resolved_capabilities
local function has_provider(client, provider)
  local capabilities = client.server_capabilities
  return capabilities[provider] ~= nil
end

function M.on_attach(client, bufnr)
  local kmps = require("user.keymaps").lsp

  local function with_desc(desc)
    return { buffer = bufnr, desc = desc }
  end

  if has_provider(client, "definitionProvider") then
    us.set_keynomap("n", kmps.definition.key, vim.lsp.buf.definition, with_desc(kmps.definition.desc))
  end
  if has_provider(client, "declarationProvider") then
    us.set_keynomap("n", kmps.declaration.key, vim.lsp.buf.declaration, with_desc(kmps.declaration.desc))
  end
  if has_provider(client, "hoverProvider") then
    us.set_keynomap("n", kmps.hover.key, vim.lsp.buf.hover, with_desc(kmps.hover.desc))
  end
  if has_provider(client, "implementationProvider") then
    us.set_keynomap("n", kmps.implementation.key, vim.lsp.buf.implementation, with_desc(kmps.implementation.desc))
  end
  if has_provider(client, "renameProvider") then
    us.set_keynomap("n", kmps.rename.key, vim.lsp.buf.rename, with_desc(kmps.rename.desc))
  end
  if has_provider(client, "referencesProvider") then
    us.set_keynomap("n", kmps.references.key, vim.lsp.buf.references, with_desc(kmps.references.desc))
  end
  if has_provider(client, "codeActionProvider") then
    us.set_keynomap("n", kmps.code_action.key, vim.lsp.buf.code_action, with_desc(kmps.code_action.desc))
    us.set_keynomap("n", kmps.code_action.key, vim.lsp.buf.range_code_action, with_desc(kmps.code_action.desc))
  end
  if has_provider(client, "signatureHelpProvider") then
    us.set_keynomap("n", kmps.signature_help_n.key, vim.lsp.buf.signature_help, with_desc(kmps.signature_help_n.desc))
    require("lsp_signature").on_attach()
  end
  if has_provider(client, "typeDefinitionProvider") then
    us.set_keynomap("n", kmps.type_definition.key, vim.lsp.buf.type_definition, with_desc(kmps.type_definition.desc))
  end
  if has_provider(client, "codeLensProvider") then
    us.set_keynomap("n", kmps.codelens.key, vim.lsp.codelens.run, with_desc(kmps.codelens.desc))
  end
  if has_provider(client, "documentSymbolProvider") then
    require("aerial").on_attach(client, bufnr)
  end

  -- Formattings
  if has_provider(client, "documentFormattingProvider") then
    us.set_keynomap("n", kmps.formatting.key, function() vim.lsp.buf.formatting({ async = true }) end,
      with_desc(kmps.formatting.desc))
  end
  -- Diagnostics
  us.set_keynomap("n", kmps.goto_next.key, '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>',
    with_desc(kmps.goto_next.desc))
  us.set_keynomap("n", kmps.goto_prev.key, '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',
    with_desc(kmps.goto_prev.desc))
  us.set_keynomap("n", kmps.open_float.key, '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
    with_desc(kmps.open_float.desc))

  -- OTHER PROVIDERS:
  -- workspaceSymbolProvider
  -- documentHighlightProvider - when hover -> highlight references
  -- documentRangeFormattingProvider
  -- completionProvider
  -- documentLinkProvider
  -- colorProvider
  -- documentOnTypeFormattingProvider
  -- foldingRangeProvider
  -- executeCommandProvider
  -- selectionRangeProvider
end

-- capabilities
local status_ok, cmp_nvim_lsp = safe_require("cmp_nvim_lsp")
if not status_ok then
  return
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
