-- Runs CLI apps in float terminals

local M = setmetatable({}, {
  __index = function(t, k)
    local _, cli_module = pcall(require, "custom.cli." .. k)
    local cli_app = setmetatable(cli_module or { cmd = { k }, terminalOpts = t.defaultTerminalOpts }, {
      __call = function(ct)
        t.setup(ct)
      end,
    })
    t[k] = cli_app
    return rawget(t, k)
  end,
})

M.defaultTerminalOpts = {}

function M.setup(app)
  M.runCmd(app.cmd, app.terminalOpts)
end

function M.runCmd(cmd, terminalOpts)
  return Snacks.terminal(cmd, terminalOpts)
end

return M
