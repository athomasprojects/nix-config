-- Note: Handle codelldb setup with nix in home-manager.
local dap = require("dap")
local ui = require("dapui")
local dap_python = require("dap-python")

require("dapui").setup()
require("dap-python").setup()
require("nvim-dap-virtual-text").setup({})

dap_python.Config = {
  justMyCode = false,
}
-- dap_python.test_runner = "pytest"

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

-- Use C++ configuration for C code
dap.configurations.c = dap.configurations.cpp

dap.configurations.zig = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
}

vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

-- Eval var under cursor
vim.keymap.set("n", "<space>?", function()
  require("dapui").eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_into)
vim.keymap.set("n", "<F3>", dap.step_over)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<F5>", dap.step_back)
vim.keymap.set("n", "<F10>", dap.restart)
vim.keymap.set("n", "<space>ro", dap.repl.open)
vim.keymap.set("n", "<space>dt", ui.toggle)
vim.keymap.set(
  "n",
  "<space>dr",
  "<cmd>lua require('dapui').open({reset = true})<CR>",
  { silent = true, desc = "reset dap-ui layout" }
)

dap.listeners.before.attach.dapui_config = function()
  ui.open()
end
dap.listeners.before.launch.dapui_config = function()
  ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  ui.close()
end
