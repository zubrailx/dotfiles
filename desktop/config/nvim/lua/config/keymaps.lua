local wk_ok, wk = pcall(require, "which-key")
local funcs = u_require("funcs")
---------------------------------------------------------------------------//
-- TERMINAL BUFFER LOCAL
---------------------------------------------------------------------------//
funcs.augroup("AddTerminalMappings", {
  {
    event = { "TermOpen" },
    pattern = { "term://*", '\\[dap-terminal\\]*' },
    command = function()
      local opts = { buffer = 0, silent = false }
      funcs.set_keynomap('t', '<esc>', [[<C-\><C-n>]], opts)
      funcs.set_keynomap('t', '<C-[>', [[<C-\><C-n>]], opts)
      funcs.set_keynomap('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      funcs.set_keynomap('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      funcs.set_keynomap('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      funcs.set_keynomap('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end
  }
})
---------------------------------------------------------------------------//
-- KEYMAPS
---------------------------------------------------------------------------//
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true })

if not config.is_vscode and not config.is_firenvim then
  -- Window movements
  funcs.set_keynomap("n", "<c-k>", "<c-w>k", "win: Move up")
  funcs.set_keynomap("n", "<c-l>", "<c-w>l", "win: Move right")
  funcs.set_keynomap("n", "<c-j>", "<c-w>j", "win: Move down")
  funcs.set_keynomap("n", "<c-h>", "<c-w>h", "win: Move left")

  -- Window resize
  funcs.set_keynomap("n", "<C-Up>", "<cmd>resize +1<cr>", "win: Increase height")
  funcs.set_keynomap("n", "<C-S-k>", "<cmd>resize +1<cr>", "win: Increase height")
  funcs.set_keynomap("n", "<C-Down>", "<cmd>resize -1<cr>", "win: Decrease height")
  funcs.set_keynomap("n", "<C-S-j>", "<cmd>resize -1<cr>", "win: Decrease height")

  funcs.set_keynomap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "win: Increase width")
  funcs.set_keynomap("n", "<C-S-l>", "<cmd>vertical resize +2<cr>", "win: Increase width")
  funcs.set_keynomap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "win: Decrease width")
  funcs.set_keynomap("n", "<C-S-h>", "<cmd>vertical resize -2<cr>", "win: Decrease width")
end

-- Buffer move
funcs.set_keynomap("n", "<S-l>", "<cmd>bnext<cr>", "buf: Move next")
funcs.set_keynomap("n", "<S-h>", "<cmd>bprevious<cr>", "buf: Move previous")

-- Open in browser
funcs.set_keynomap("n", "gx", ":silent execute '!$BROWSER ' . shellescape(expand('<cfile>'), 1)<cr>",
  "goto: Open link in system browser")

if not config.is_vscode and not config.is_firenvim then
  -- Tabs
  funcs.set_keynomap("n", "[t", "<cmd>tabprev<cr>", "tab: Open previous")
  funcs.set_keynomap("n", "]t", "<cmd>tabnext<cr>", "tab: Open next")
  funcs.set_keynomap("n", "<leader>td", "<cmd>tabclose<cr>", "tab: Close")
  funcs.set_keynomap("n", "<leader>tn", "<cmd>tabedit %<cr>", "tab: Edit current buffer")
  funcs.set_keynomap("n", "<leader>to", "<cmd>tabonly<cr>", "tab: Close all except current")
  funcs.set_keynomap("n", "<leader>tm", function()
    vim.cmd("tabmove " .. tostring(tonumber(vim.fn.input("")) - 1))
  end, { silent = false, desc = "tab: Move current after N - 1" })
  -- Bind leader keys to specific tabs
  funcs.set_keynomap("n", "<leader>1", "1gt")
  funcs.set_keynomap("n", "<leader>2", "2gt")
  funcs.set_keynomap("n", "<leader>3", "3gt")
  funcs.set_keynomap("n", "<leader>4", "4gt")
  funcs.set_keynomap("n", "<leader>5", "5gt")
  funcs.set_keynomap("n", "<leader>6", "6gt")
  funcs.set_keynomap("n", "<leader>7", "7gt")
  funcs.set_keynomap("n", "<leader>8", "8gt")
  funcs.set_keynomap("n", "<leader>9", "9gt")
  funcs.set_keynomap("n", "<leader>0", ":tablast<cr>")
end

-- Move Lines
funcs.set_keynomap("n", '<a-k>', '<cmd>move-2<CR>==')
funcs.set_keynomap("n", '<a-j>', '<cmd>move+<CR>==')
funcs.set_keynomap("x", '<a-k>', ":move-2<CR>='[gv")
funcs.set_keynomap("x", '<a-j>', ":move'>+<CR>='[gv")
funcs.set_keynomap("v", "<", "<gv", "Shift leftwards")
funcs.set_keynomap("v", ">", ">gv", "Shift rightwards")

-- Clear search
local mapnohl_disabled = {
  "color-picker",
  "TelescopePrompt",
  "DressingInput",
  "Trouble",
}

funcs.augroup("_map_hohl", {
  {
    event = "FileType",
    pattern = "*",
    command = function()
      if not vim.tbl_contains(mapnohl_disabled, vim.bo.filetype) then
        funcs.set_keynomap("n", "<esc>", ":nohl<cr>", { buffer = 0 })
      end
    end
  }
})

-- Write
funcs.set_keynomap("n", "<leader>w", "<cmd>wall<cr>", "Write all")
funcs.set_keynomap("i", "<C-s>", "<cmd>wall<cr>", "Write all")
funcs.set_keynomap("n", "<C-s>", "<cmd>wall<cr>", "Write all")

if not funcs.is_vscode then
  -- Quit
  funcs.set_keynomap("n", "<leader>q", "<cmd>q<cr>", "win: Close")
  funcs.set_keynomap("n", "<leader>Q", "<cmd>qall<cr>", "win: Close all")

  -- Splits
  funcs.set_keynomap("n", "<leader>y", "<cmd>split<cr>", "win: Horizontal split")
  funcs.set_keynomap("n", "<leader>u", "<cmd>vsplit<cr>", "win: Vertical split")
end

-- Other
funcs.set_keynomap("n", "<localleader>a", "<cmd>ascii<cr>", "print ASCII character")

-- Makes * and # work on visual mode too.
vim.cmd([[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction
  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]])

-- Emacs like keybinds in commandline
local function with_nosilent(desc)
  return { silent = false, desc = desc }
end

funcs.set_keynomap("c", "<A-b>", "<S-Left>", with_nosilent("Move word left"))
funcs.set_keynomap("c", "<A-f>", "<S-Right>", with_nosilent("Move word right"))
funcs.set_keynomap("c", "<C-b>", "<Left>", with_nosilent("Move char left"))
funcs.set_keynomap("c", "<C-f>", "<Right>", with_nosilent("Move char right"))
funcs.set_keynomap("c", "<C-j>", "<Down>", with_nosilent("History scroll down"))
funcs.set_keynomap("c", "<C-k>", "<Up>", with_nosilent("History scroll up"))


-- Don't load which-key mappings if this plugin is not loaded
if not wk_ok then
  vim.notify("which-key is not istalled. Ignoring some keymaps",
    vim.log.levels.WARN, { title = "keymaps" })
  return
end

-- Leader mappings
local leader = {
  -- Buffers
  f = { "<cmd>Bdelete<cr>", "buf: Delete current" },
  -- Tabs
  t = { name = "tabs" },
  -- Project
  p = { "<cmd>ProjectRoot<cr>", "project: Update root" },
  P = { "<cmd>Telescope projects<cr>", "telescope: Projects" },
  -- Toggleterm
  j = {
    name = "toggleterm",
    t = { "<cmd>ToggleTerm<cr>", "toggleterm: Toggle" },
    a = { "<cmd>ToggleTermToggleAll<cr>", "toggleterm: Toggle all" },
    l = { '<cmd>ToggleTermLazygit<cr>', "toggleterm: Lazygit" },
    h = { "<cmd>ToggleTermHtop<cr>", "toggleterm: Htop" },
    f = { "<cmd>ToggleTermFloat<cr>", "toggleterm: Float" },
  },
  -- Neo-tree
  e = { "<cmd>Neotree toggle<cr>", "neo-tree: Toggle" },
  E = { "<cmd>Neotree<cr>", "neo-tree" },
  -- Session
  v = { "<cmd>PossessionLoad<cr>", "possession: Restore current session" },
  V = { "<cmd>Telescope possession list<cr>", "possession: Search session" },
  -- Telescope
  r = { "<cmd>Telescope oldfiles<cr>", "telescope: Recent files" },
  s = {
    "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
    "telescope: Find files"
  },
  h = { "<cmd>Telescope live_grep<cr>", "telescope: Live grep" },
  g = {
    name = "git",
    b = { "<cmd>Gitsigns blame_line<cr>", "gitsigns: blame line" },
  },
  b = { "<cmd>Telescope buffers<cr>", "telescope: Buffers" },
  -- Which-key
  ["?"] = { "<cmd>WhichKey<cr>", "whichkey: Open" },
  -- Aerial
  A = { "<cmd>AerialToggle!<cr>", "aerial: Toggle" },
  a = { "<cmd>AerialToggle<cr>", "aerial: Toggle focus" },
  -- Trouble
  I = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "trouble: toggle workspace" },
  i = { "<cmd>TroubleToggle document_diagnostics<cr>", "trouble: toggle document" },
}

local localleader = {
  -- Neotree
  e = { "<cmd>Neotree position=current<cr>", "Neotree position=current" },
  -- Lsp
  l = {
    name = "lsp",
    s = { "<cmd>LspInfo<cr>", "Info" },
    i = { "<cmd>LspInstall<cr>", "Install" },
    r = { "<cmd>LspRestart<cr>", "Restart" },
    l = { "<cmd>LspLog<cr>", "Log" },
  },
  -- Null-ls
  u = {
    name = "null-ls",
    s = { "<cmd>NullLsInfo<cr>", "Info" },
    l = { "<cmd>NullLsLog<cr>", "Log" },
  },
  -- Lazy
  z = { "<cmd>Lazy<cr>", "Lazy" },
  -- Noice
  n = {
    name = "noice",
    l = { "<cmd>Noice last<cr>", "Last" },
    h = { "<cmd>Noice history<cr>", "History" },
  },
  -- Mason
  m = {
    name = "mason",
    s = { "<cmd>Mason<cr>", "Info" },
    -- i = { "<cmd>MasonInstall<cr>", "Install" },
    l = { "<cmd>MasonLog<cr>", "Log" },
  },
  -- Luasnip
  s = { "<cmd>lua require('luasnip.loaders.from_lua').edit_snippet_files()<cr>", "luasnip: Edit snippets" },
  -- Git (diffview)
  d = {
    name = "diffview",
    o = { "<cmd>DiffviewOpen<cr>", 'diffview: open' },
    h = { "<cmd>DiffviewFileHistory<cr>", 'diffview: file history' },
  },
  g = {
    name = "git",
    b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "gitsigns: toggle current line blame", },
  },
  -- Watch
  w = {
    name = "watch",
    c = { "<cmd>WatchCreate<cr>", "watch: create" },
    d = { "<cmd>WatchDelete<cr>", "watch: delete" },
    l = { "<cmd>WatchList<cr>", "watch: list" },
  },
  -- Neorg
  o = {
    name = "neorg",
    s = { "<cmd>Telescope neorg switch_workspace<cr>", "neorg: switch workspace" },
  },
  -- a: ASCII
}

wk.register(leader, { prefix = "<leader>" })
wk.register(localleader, { prefix = "<localleader>" })
