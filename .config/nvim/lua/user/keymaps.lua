local which_key_ok, which_key = safe_require("which-key")

local M = {}
----------------------------------------------------------------------------//
-- Keymaps
-----------------------------------------------------------------------------//
-- prototype: KeymapDictionary
local KeymapDictionary = {}

function KeymapDictionary:new(table, prefix)
  table = table or {}
  setmetatable(table, self)
  self.__index = self
  -- process input data
  for _, v in pairs(table) do
    v.key = v[1]
    v[1] = nil
    if v[2] then
      v.desc = prefix .. ": " .. v[2]
      v[2] = nil
    end
  end
  table._prefix = prefix
  return table
end

function KeymapDictionary:key(element)
  return self[element].key
end

function KeymapDictionary:desc(element)
  local desc = self[element].desc
  if desc == nil then return "" end
  if self._prefix then
    return self._prefix .. ": " .. desc
  else
    return desc
  end
end

function KeymapDictionary:add_key(name, key, desc)
  self[name] = {}
  self[name].key = key
  if desc then
    self[name].desc = self._prefix .. ": " .. desc
  end
end

function KeymapDictionary:remove_key(name)
  self[name] = nil
end

-- END

M.lsp = KeymapDictionary:new({
  -- gf (override file open), gl, go, gp, gq, gs, gy, gz
  definition = { "<leader>kd", "Definition" },
  g_definition = { "gd" },

  declaration = { "<leader>ke", "Declaration" },
  g_declaration = { "gD" },

  hover = { "<leader>kl", "Hover" },
  g_hover = { "gl" },

  implementation = { "<leader>ki", "Implementation" },
  g_implementation = { "gm" },

  signature_help_n = { "<leader>ks", "Signature help" },
  signature_help_i = { "<C-k>", "Signature help" },

  rename = { "<leader>kn", "Rename" },

  references = { "<leader>kr", "References" },
  g_references = { "gr" },

  code_action = { "<leader>ka", "Code action" },

  open_float = { "<leader>kh", "Open float" },
  g_open_float = { "gh" },

  goto_prev = { "[d", "Goto previous" },
  goto_next = { "]d", "Goto next" },

  formatting = { "<leader>m", "Format file" },

  codelens = { "<leader>kl", "Run codelens" },

  type_definition = { "<leader>kp", "Type definition" },
}, "lsp")

M.dap = KeymapDictionary:new({
  continue = { "<leader>dc", "Continue" },
  run_last = { "<leader>du", "Run last" },
  process_launchjs = { "<leader>dl", "Process launchjs" },
  terminate = { "<leader>dt", "Terminate" },
  disconnect = { "<leader>db", "Disconnect" },
  close = { "<leader>dq", "Close" },
  set_breakpoint_cond = { "<leader>de", "Set conditional break" },
  set_breakpoint_log = { "<leader>dm", "Set log break" },
  toggle_breakpoint = { "<leader>ds", "Toggle breakpoint" },
  clear_breakpoints = { "<leader>dz", "Clear breakpoints" },
  step_over = { "<leader>dn", "Step over" },
  step_into = { "<leader>di", "Step into" },
  step_out = { "<leader>do", "Step out" },
  step_back = { "<leader>dd", "Step back" },
  -- pause = {"<leader>dp", "Pause"},
  reverse_continue = { "<leader>dr", "Reverse continue" },
  up = { "<leader>d[", "Up" },
  down = { "<leader>d]", "Down" },
  run_to_cursor = { "<leader>da", "Run to cursor" },
  repl_toggle = { "<leader>dg", "Toggle REPL" },
  repl_session = { "<leader>dx", "REPL session" },
  hover = { "<leader>dh", "Hover" },
  dapui_toggle = { "<leader>dy", "Toggle dapui" },
}, "dap")

M.dap_hydra = KeymapDictionary:new({
  body = { "<leader>D", },
  quit = { "Z", "Quit" },
  continue = { "C", M.dap.continue.desc },
  run_last = { "<C-u>", M.dap.run_last.desc },
  process_launchjs = { "<C-n>", M.dap.process_launchjs.desc },
  terminate = { "<C-t>", M.dap.terminate.desc },
  disconnect = { "<C-d>", M.dap.disconnect.desc },
  close = { "Q", M.dap.close.desc },
  set_breakpoint_cond = { "E", M.dap.set_breakpoint_cond.desc },
  set_breakpoint_log = { "M", M.dap.set_breakpoint_log.desc },
  toggle_breakpoint = { "S", M.dap.toggle_breakpoint.desc },
  clear_breakpoints = { "z", M.dap.clear_breakpoints.desc },
  step_over = { "N", M.dap.step_over.desc },
  step_into = { "I", M.dap.step_into.desc },
  step_out = { "O", M.dap.step_out.desc },
  step_back = { "D", M.dap.step_back.desc },
  reverse_continue = { "R", M.dap.reverse_continue.desc },
  up = { "d[", M.dap.up.desc },
  down = { "d]", M.dap.down.desc },
  run_to_cursor = { "A", M.dap.run_to_cursor.desc },
  repl_toggle = { "G", M.dap.repl_toggle.desc },
  repl_session = { "X", M.dap.repl_session.desc },
  hover = { "m", M.dap.hover.desc },
  dapui_toggle = { "Y", M.dap.dapui_toggle.desc },
}, "dap")

if which_key_ok then
  which_key.register({
    ["d"] = { name = "dap" },
    ["k"] = { name = "lsp" },
  }, { prefix = "<leader>", mode = "n" })
end
---------------------------------------------------------------------------//
--TERMINAL BUFFER LOCAL
---------------------------------------------------------------------------//
function _G._set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua _set_terminal_keymaps()')

-- Modes
--   normal_mode = "n",
--   visual_and_select = "v",
--   select_mode = "s",
--   visual_mode = "v",
--   operator-pending_mode = "o",
--   insert_mode = "i",
--   term_mode = "t",
--   command_mode = "c",
---------------------------------------------------------------------------//
-- WHICH_KEY
---------------------------------------------------------------------------//
if which_key_ok then
  ---------------------------------------------------------------------------//
  -- NORMAL
  ---------------------------------------------------------------------------//
  which_key.register({
    ["<C-k>"] = { "<c-w>k", "window: Move up" },
    ["<C-l>"] = { "<c-w>l", "window: Move right" },
    ["<C-j>"] = { "<c-w>j", "window: Move down" },
    ["<C-h>"] = { "<c-w>h", "window: Move left" },

    ["<C-Up>"] = { "<cmd>resize +1<cr>", "window: Increase height" },
    ["<C-S-k>"] = { "<cmd>resize +1<cr>", "window: Increase height" },
    ["<C-Down>"] = { "<cmd>resize -1<cr>", "window: Decrease height" },
    ["<C-S-j>"] = { "<cmd>resize -1<cr>", "window: Decrease height" },
    ["<C-Right>"] = { "<cmd>vertical resize +2<cr>", "window: Increase width" },
    ["<C-S-l>"] = { "<cmd>vertical resize +2<cr>", "window: Increase width" },
    ["<C-Left>"] = { "<cmd>vertical resize -2<cr>", "window: Decrease width" },
    ["<C-S-h>"] = { "<cmd>vertical resize -2<cr>", "window: Decrease width" },

    ["<S-l>"] = { "<cmd>bnext<cr>", "buffer: Move next" },
    ["<S-h>"] = { "<cmd>bprevious<cr>", "buffer: Move previous" },

    ["<esc><esc>"] = { "<cmd>nohlsearch<cr>", "hl: Clear search hl" },

    g = {
      name = "special",
      a = { "Print asci character" },
      x = { ":silent execute '!$BROWSER ' . shellescape(expand('<cfile>'), 1)<cr>",
        "goto: Open link in system browser" },
    }

  }, { mode = "n" })

  which_key.register({
    ["<C-w>"] = {
      name = "window",
      s = { "Split horizontally" },
      v = { "Split vertically" },
      n = { "Split horizontally and edit [New File]" },
      ["^"] = { "Split horizontally and edit the alternative file" },
      c = { "Close" },
      o = { "Close all except current one" },
      t = { "Go to top-left" },
      b = { "Go to bottom-right" },
      p = { "Go to previous" },
      P = { "Go to preview" },
      r = { "Rotate downwards/rightwards" },
      R = { "Rotate upwards/leftwards" },
      K = { "Move far Top" },
      J = { "Move far Bottom" },
      H = { "Move far Left" },
      L = { "Move far Right" },

    }
  }, { mode = "n" })

  which_key.register({
    q = { "<cmd>q<cr>", "window: Close" },
    Q = { "<cmd>qall<cr>", "window: Close all" },
    w = { "<cmd>write<cr>", "nvim: Write" },
    W = { "<cmd>wall<cr>", "nvim: Write all" },
    e = { "<cmd>NvimTreeToggle<cr>", "nvim-tree: Toggle" },
    E = { "<cmd>NvimTreeFocus<cr>", "nvim-tree: Focus" },
    r = { "<cmd>Telescope oldfiles<cr>", "telescope: Recent files" },
    t = {
      name = "watch",
      n = { "<cmd>WatchCreate<cr>", "watch: Create" },
      d = { "<cmd>WatchDelete<cr>", "watch: Delete" },
    },
    Y = { "<cmd>RestoreSession<cr>", "session: Try restore" },
    y = { "<cmd>lua require('session-lens').search_session()<cr>", "telescope: Find session" },
    u = { "<cmd>Trouble workspace_diagnostics<CR>", "trouble: Workspace diagnostics" },
    i = { "<cmd>Trouble document_diagnostics<CR>", "trouble: Document diagnostics" },
    p = { "<cmd>Telescope projects<cr>", "telescope: Projects" },
    a = { "<cmd>AerialToggle!<cr>", "aerial: Toggle" },
    A = { "<cmd>AerialToggle<cr>", "aerial: Toggle focus" },
    ['[a'] = { "<cmd>execute v:count . 'AerialPrev'<cr>", "aerial: Jump N previous symbols" },
    [']a'] = { "<cmd>execute v:count . 'AerialNext'<cr>", "aerial: Jump N next symbols" },
    ['[A'] = { "<cmd>execute v:count . 'AerialPrevUp'<cr>", "aerial: Jump N levels up, moving backwards" },
    [']A'] = { "<cmd>execute v:count . 'AerialNextUp'<cr>", "aerial: Jump N levels up, moving forwards" },

    s = {
      "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
      "telescope: Find files"
    },
    f = { "<cmd>lua us.delete_current_buffer()<cr>", "buffer: Delete current" },
    h = { "<cmd>WhichKey<cr>", "whichkey: Open"},
    j = {
      name = "toggleterm",
      t = { "<cmd>ToggleTerm<cr>", "toggleterm: Toggle" },
      a = { "<cmd>ToggleTermToggleAll<cr>", "toggleterm: Toggle all" },
      l = { '<cmd>lua vim.env.NVIM_CWD=vim.fn.getcwd(); vim.cmd("UsToggleTermLazygit")<cr>', "toggleterm: Lazygit" },
      h = { "<cmd>UsToggleTermHtop<cr>", "toggleterm: Htop" },
    },
    l = { "<cmd>Telescope live_grep<cr>", "telescope: Search pattern" },
    b = { "<cmd>Telescope buffers<cr>", "telescope: Buffers" },
    ["'"] = { "<cmd>marks<cr>", "mark: Show" },
    ['"'] = { "<cmd>reg<cr>", "register: Show" },
  }, { mode = "n", prefix = "<leader>" })

  ---------------------------------------------------------------------------//
  -- INSERT
  ---------------------------------------------------------------------------//
  which_key.register({

  }, { mode = "i" })
  ---------------------------------------------------------------------------//
  -- VISUAL-SELECT
  ---------------------------------------------------------------------------//
  which_key.register({
    ["<"] = { "<gv", "Shift leftwards" },
    [">"] = { ">gv", "Shift rightwards" },
    ["p"] = { '"_dP', "Replace selected from buffer" },
    ["<A-j>"] = { ":move '>+1<cr>gv", "Swap selected with next line" },
    ["<A-k>"] = { ":move '<-2<cr>gv", "Swap selected with previous line" },
  }, { mode = "v" })
  ---------------------------------------------------------------------------//
  -- TERMINAL
  ---------------------------------------------------------------------------//
  -- local function termcodes(str)
  --   return vim.api.nvim_replace_termcodes(str, true, true, true)
  -- end
  --
  which_key.register({
    --   ["<Esc>"] = { termcodes "<C-\\><C-n>", "Go to normal mode" },
    --   ["<C-[>"] = { termcodes "<C-\\><C-n>", "Go to normal mode" },
  }, { mode = "t" })

  ---------------------------------------------------------------------------//
  -- COMMAND
  ---------------------------------------------------------------------------//
  -- emacs like keybinds
  which_key.register({
    ["<A-b>"] = { "<S-Left>", "Cursor move word left" },
    ["<A-f>"] = { "<S-Right>", "Cursor move word right" },
    ["<C-b>"] = { "<Left>", "Cursor move left" },
    ["<C-f>"] = { "<Right>", "Cursor move right" },
    ["<C-j>"] = { "<Down>", "History scroll down" },
    ["<C-k>"] = { "<Up>", "History scroll up" },
  }, { mode = "c", noremap = true, silent = false })
end


return M
