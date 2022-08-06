----------------------------------------------------------------------------//
-- Keymaps
-----------------------------------------------------------------------------//
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.cmd("cnoreabbrev hs split")
-----------------------------------------------------------------------------//
local M = {}

M.lsp = {
  definition = "<leader>kd",
  declaration = "<leader>ke",
  hover = "<leader>kh",
  implementation = "<leader>ki",
  signature_help_n = "<leader>ks",
  signature_help_i = "<C-k>",
  rename = "<leader>kn",
  references = "<leader>kr",
  code_action = "<leader>ka",
  goto_prev = "[d",
  goto_next = "]d",
  open_float = "<leader>kl",
  formatting = "<leader>m",
  -- not customized
  codelens = "<leader>kc",
  type_definition = "<leader>kp",
  aerial = {

  },
}

M.dap = {
  continue = "<leader>dc",
  run_last = "<leader>du",
  launch = "<leader>dl",
  terminate = "<leader>dt",
  disconnect = "<leader>db",
  close = "<leader>dq",
  set_breakpoint_cond = "<leader>de",
  set_breakpoint_log = "<leader>dm",
  toggle_breakpoint = "<leader>ds",
  clear_breakpoints = "<leader>dz",
  step_over = "<leader>dn",
  step_into = "<leader>di",
  step_out = "<leader>do",
  step_back = "<leader>dd",
  -- pause = "<leader>dp",
  reverse_continue = "<leader>dr",
  up = "<leader>d[",
  down = "<leader>d]",
  run_to_cursor = "<leader>da",
  repl_toggle = "<leader>dg",
  repl_session = "<leader>dx",
  hover = "<leader>dh",
  dapui_toggle = "<leader>dy",
}
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
-- MULTIPLE MODES
---------------------------------------------------------------------------//
-- us.set_keynomap({ "n", "i" }, "<A-s>", "<cmd>write<cr>", "buffer: Save")
---------------------------------------------------------------------------//
-- WHICH_KEY
---------------------------------------------------------------------------//
local which_key_ok, which_key = safe_require("which-key")
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
    ["<C-Down>"] = { "<cmd>resize -1<cr>", "window: Decrease height" },
    ["<C-Right>"] = { "<cmd>vertical resize +2<cr>", "window: Increase width" },
    ["<C-Left>"] = { "<cmd>vertical resize -2<cr>", "window: Decrease width" },

    ["<S-l>"] = { "<cmd>bnext<cr>", "buffer: Move next" },
    ["<S-h>"] = { "<cmd>bprevious<cr>", "buffer: Move previous" },

    ["<esc><esc>"] = { "<cmd>nohlsearch<cr>", "hl: Clear search hl" },

    ["gx"] = { ":silent execute '!$BROWSER ' . shellescape(expand('<cfile>'), 1)<cr>",
      "goto: Open link in system browser" },

  }, { mode = "n" })

  which_key.register({
    ["C-w>"] = {
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
    Q = { "<cmd>Q<cr>", "window: Close all"},
    w = { "<cmd>write<cr>", "nvim: Write" },
    W = { "<cmd>wa<cr>", "nvim: Write all"},
    e = { "<cmd>NvimTreeToggle<cr>", "nvim-tree: Toggle" },
    r = { "<cmd>Telescope oldfiles<cr>", "telescope: Recent files" },
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
    d = { name = "dap" },
    f = { "<cmd>lua us.delete_current_buffer()<cr>", "buffer: Delete current" },
    j = {
      name = "toggleterm",
      t = { "<cmd>ToggleTerm<cr>", "toggleterm: Toggle" },
      a = { "<cmd>ToggleTermToggleAll<cr>", "toggleterm: Toggle all" },
      l = { "<cmd>UsToggleTermLazygit<cr>", "toggleterm: Lazygit" },
      h = { "<cmd>UsToggleTermHtop<cr>", "toggleterm: Htop" },
    },
    k = { name = "lsp" },
    l = { "<cmd>Telescope live_grep<cr>", "telescope: Search pattern" },
    b = { "<cmd>buffers<cr>", "buffer: Show" },
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
