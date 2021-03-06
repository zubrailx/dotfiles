local fmt = string.format


_G.us = {
  prefix = {
    plugins = "user.plugins"
  }
}


function _G.safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    vim.notify(result, vim.logresult, vim.log.levels.ERROR, { title = fmt('Error requiring: %s', module) })
  end
  return ok, result
end

function us.dump_lua_table(table)
  return vim.inspect(table)
end

function us.delete_current_buffer()
  local cbn = vim.api.nvim_get_current_buf()
  local buffers = vim.fn.getbufinfo({ buflisted = true })
  local size = 0
  local idx = 0
  for n, e in ipairs(buffers) do
    size = size + 1
    if e.bufnr == cbn then
      idx = n
    end
  end
  if idx == 0 then return end
  if idx == size then
    vim.cmd("bprevious")
  else
    vim.cmd("bnext")
  end
  vim.cmd("bdelete " .. cbn)
end

function us.table_contains(table, value)
  for _, e in ipairs(table) do
    if value == e then return true end
  end
  return false
end

-- MAPPINGS
local function call_mapping(mode, lhs, rhs, opts)
  if type(mode) == "table" then
    for _, v in pairs(mode) do
      vim.keymap.set(v, lhs, rhs, opts)
    end
  else
    for i = 1, #mode do
      vim.keymap.set(mode:sub(i, i), lhs, rhs, opts)
    end
  end
end

local function resolve_opts(opts)
  return type(opts) == 'string' and { desc = opts } or opts and vim.deepcopy(opts) or {}
end

us.set_keyremap = function(mode, lhs, rhs, opts)
  opts = resolve_opts(opts)
  opts.remap = true
  call_mapping(mode, lhs, rhs, opts)
end

us.set_keynomap = function(mode, lhs, rhs, opts)
  opts = resolve_opts(opts)
  opts.remap = false
  call_mapping(mode, lhs, rhs, opts)
end
