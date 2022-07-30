local M = {}

function M.setup()
  local dap = require("dap")

  local function continue()
    dap.continue()
  end

  local function step_over()
    dap.step_over()
  end

  local function step_into()
    dap.step_into()
  end

  local function step_out()
    dap.step_out()
  end

  local function toggle_breakpoint()
    dap.toggle_breakpoint()
  end

  local function set_breakpoint()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
  end

  local function repl_toggle()
    dap.repl.toggle(nil, 'botright split')
  end

  local function run_last()
    dap.run_last()
  end

  require('which-key').register({
    a = {
      name = 'debug',
      b = { toggle_breakpoint, 'dap: Toggle breakpoint' },
      B = { set_breakpoint, 'dap: Set breakpoint' },
      c = { continue, 'dap: Continue or start debugging' },
      e = { step_out, 'dap: Step out' },
      i = { step_into, 'dap: Step into' },
      o = { step_over, 'dap: Step over' },
      l = { run_last, 'dap REPL: Run last' },
      t = { repl_toggle, 'dap REPL: Toggle' },
    },
  }, {
    prefix = '<leader>',
  })
end

function M.config()
  require("user.plugins.dap.adapters")
  require("user.plugins.dap.adapters")
end

return M
