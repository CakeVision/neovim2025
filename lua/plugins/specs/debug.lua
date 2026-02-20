return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
  },
  lazy = false,
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "✕", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "DapStoppedLine", numhl = "" })

    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    require("dap-python").setup(vim.fn.trim(vim.fn.system("uv run which python")))
    -- Keymaps
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
    vim.keymap.set("n", "<leader>dc", dap.continue)
    vim.keymap.set("n", "<leader>di", dap.step_into)
    vim.keymap.set("n", "<leader>do", dap.step_over)
    vim.keymap.set("n", "<leader>dr", dap.repl.open)

    dap.listeners.after.event_initialized["keymaps"] = function()
      vim.keymap.set("n", "n", dap.step_over, { buffer = true, desc = "Step Over" })
      vim.keymap.set("n", "s", dap.step_into, { buffer = true, desc = "Step Into" })
      vim.keymap.set("n", "o", dap.step_out, { buffer = true, desc = "Step Out" })
      vim.keymap.set("n", "c", dap.continue, { buffer = true, desc = "Continue" })
      vim.keymap.set("n", "q", dap.terminate, { buffer = true, desc = "Stop" })
    end

    dap.listeners.before.event_terminated["keymaps"] = function()
      -- Clean up by removing buffer-local keymaps
      for _, key in ipairs({ "n", "s", "o", "c", "q" }) do
        pcall(vim.keymap.del, "n", key, { buffer = true })
      end
    end

    dap.listeners.before.event_exited["keymaps"] = function()
      for _, key in ipairs({ "n", "s", "o", "c", "q" }) do
        pcall(vim.keymap.del, "n", key, { buffer = true })
      end
    end
    dapui.setup({
      layouts = {
        {
          -- Left sidebar
          elements = {
            { id = "scopes",      size = 0.5 },
            { id = "breakpoints", size = 0.15 },
            { id = "stacks",      size = 0.2 },
            { id = "watches",     size = 0.15 },
          },
          size = 40,
          position = "left",
        },
        {
          -- Bottom panel
          elements = {
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 0.25,
          position = "bottom",
        },
      },
    })
  end,

}
