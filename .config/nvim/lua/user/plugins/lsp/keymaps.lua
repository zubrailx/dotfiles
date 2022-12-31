local M = {}

local KeymapDictionary = require("user.utils.keymaps")

M.keymaps = KeymapDictionary:new({
  -- gf (override file open), gl, go, gp, gq, gs, gy, gz
  g_definition = { "gd" },
  g_declaration = { "gD" },
  g_hover = { "gl" },
  g_implementation = { "gm" },
  g_references = { "gr" },
  g_open_float = { "gh" },
  g_open_float_cursor = { "gH" },

  signature_help_i = { "<C-k>", "Signature help" },

  goto_prev = { "[d", "Goto previous" },
  goto_next = { "]d", "Goto next" },

  definition = { "<leader>kd", "Definition" },
  declaration = { "<leader>ke", "Declaration" },
  hover = { "<leader>kl", "Hover" },
  implementation = { "<leader>ki", "Implementation" },
  signature_help_n = { "<leader>ks", "Signature help" },
  rename = { "<leader>kn", "Rename" },
  references = { "<leader>kr", "References" },
  code_action = { "<leader>ka", "Code action" },
  open_float = { "<leader>kh", "Open float" },
  open_float_cursor = { "<leader>kH", "Open float under cursor" },
  codelens = { "<leader>km", "Run codelens" },
  type_definition = { "<leader>kp", "Type definition" },

  format = { "<leader>m", "Format file" },
}, "lsp")

function M.on_attach(client, bufnr)
  local kmps = M.keymaps
  local lspsaga_ok, _ = pcall(require, "lspsaga")

  local function with_desc(desc)
    return { buffer = bufnr, desc = kmps:desc(desc) }
  end

  -- Editing and movement
  -- If has "definitionProvider"
  us.set_keynomap("n", kmps.definition.key, vim.lsp.buf.definition, with_desc("definition"))
  us.set_keynomap("n", kmps.g_definition.key, vim.lsp.buf.definition, with_desc("definition"))
  -- If has "declarationProvider"
  us.set_keynomap("n", kmps.declaration.key, vim.lsp.buf.declaration, with_desc("declaration"))
  us.set_keynomap("n", kmps.g_declaration.key, vim.lsp.buf.declaration, with_desc("declaration"))
  -- if has "hoverProvider"
  us.set_keynomap("n", kmps.hover.key, vim.lsp.buf.hover, with_desc("hover"))
  us.set_keynomap("n", kmps.g_hover.key, vim.lsp.buf.hover, with_desc("hover"))
  -- if has "implementationProvider"
  us.set_keynomap("n", kmps.implementation.key, vim.lsp.buf.implementation, with_desc("implementation"))
  us.set_keynomap("n", kmps.g_implementation.key, vim.lsp.buf.implementation, with_desc("implementation"))
  -- if has "renameProvider"
  us.set_keynomap("n", kmps.rename.key, vim.lsp.buf.rename, with_desc("rename"))
  -- if has "referencesProvider"
  us.set_keynomap("n", kmps.references.key, vim.lsp.buf.references, with_desc("references"))
  us.set_keynomap("n", kmps.g_references.key, vim.lsp.buf.references, with_desc("references"))
  -- if has "codeActionProvider"
  if lspsaga_ok then
    us.set_keynomap("n", kmps.code_action.key, "<cmd>Lspsaga code_action<cr>", with_desc("code_action"))
  else
    us.set_keynomap("n", kmps.code_action.key, vim.lsp.buf.code_action, with_desc("code_action"))
  end
  -- us.set_keynomap("n", kmps.code_action.key, vim.lsp.buf.range_code_action, with_desc("code_action")) deprecated
  -- if has "signatureHelpProvider"
  us.set_keynomap("n", kmps.signature_help_n.key, vim.lsp.buf.signature_help, with_desc("signature_help_n"))
  -- if has "typeDefinitionProvider"
  us.set_keynomap("n", kmps.type_definition.key, vim.lsp.buf.type_definition, with_desc("type_definition"))
  -- if has "codeLensProvider"
  us.set_keynomap("n", kmps.codelens.key, vim.lsp.codelens.run, with_desc("codelens"))
  -- if has "documentSymbolProvider"

  -- Formattings
  -- if has "documentFormattingProvider"
  us.set_keynomap("n", kmps.format.key, function() vim.lsp.buf.format({ async = true }) end,
    with_desc(("format")))

  -- Diagnostics
  if lspsaga_ok then
    us.set_keynomap("n", kmps.open_float.key, '<cmd>Lspsaga show_line_diagnostics<cr>',
      with_desc("open_float"))
    us.set_keynomap("n", kmps.g_open_float.key, '<cmd>Lspsaga show_line_diagnostics<cr>',
      with_desc("open_float"))
    us.set_keynomap("n", kmps.open_float_cursor.key, '<cmd>Lspsaga show_cursor_diagnostics<cr>',
      with_desc("open_float_cursor"))
    us.set_keynomap("n", kmps.g_open_float_cursor.key, '<cmd>Lspsaga show_cursor_diagnostics<cr>',
      with_desc("open_float_cursor"))
    us.set_keynomap("n", kmps.goto_next.key, '<cmd>Lspsaga diagnostic_jump_next<CR>',
      with_desc("goto_next"))
    us.set_keynomap("n", kmps.goto_prev.key, '<cmd>Lspsaga diagnostic_jump_prev<CR>',
      with_desc("goto_prev"))
  else
    us.set_keynomap("n", kmps.open_float.key, '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
      with_desc("open_float"))
    us.set_keynomap("n", kmps.g_open_float.key, '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
      with_desc("open_float"))
    us.set_keynomap("n", kmps.goto_next.key, '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>',
      with_desc("goto_next"))
    us.set_keynomap("n", kmps.goto_prev.key, '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',
      with_desc("goto_prev"))
  end
end

return M
