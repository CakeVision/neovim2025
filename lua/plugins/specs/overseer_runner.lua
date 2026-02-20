return {
  "stevearc/overseer.nvim",
  lazy = false,
  config = function()
    local overseer = require("overseer")
    overseer.setup({
      task_list = {
        direction = "bottom",
        min_height = 15,
        bindings = {
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["<Up>"] = "ScrollOutputUp",
          ["<Down>"] = "ScrollOutputDown",
        },
      },
    })

    -- =========================================================================
    -- COMMAND HISTORY (file-based, independent of bash/tmux)
    -- =========================================================================

    local history_file = vim.fn.stdpath("data") .. "/overseer_cmd_history.json"

    local function load_history()
      local f = io.open(history_file, "r")
      if not f then return {} end
      local content = f:read("*a")
      f:close()
      local ok, data = pcall(vim.json.decode, content)
      if ok and type(data) == "table" then return data end
      return {}
    end

    local function save_history(history)
      local f = io.open(history_file, "w")
      if not f then return end
      f:write(vim.json.encode(history))
      f:close()
    end

    local function add_to_history(cmd)
      local history = load_history()
      -- Remove duplicate if it exists
      for i, entry in ipairs(history) do
        if entry == cmd then
          table.remove(history, i)
          break
        end
      end
      -- Add to front (most recent first)
      table.insert(history, 1, cmd)
      -- Keep last 50 commands
      while #history > 50 do
        table.remove(history)
      end
      save_history(history)
    end

    -- =========================================================================
    -- GENERIC TEMPLATES
    -- =========================================================================

    -- Auto-detect Makefile targets
    overseer.register_template({
      name = "make",
      builder = function()
        return {
          cmd = { "make" },
          components = { "default" },
        }
      end,
      condition = {
        callback = function()
          return vim.fn.filereadable("Makefile") == 1
        end,
      },
    })

    -- Per-language run templates
    overseer.register_template({
      name = "python (uv)",
      builder = function()
        return { cmd = { "uv", "run", "python", vim.fn.expand("%:p") } }
      end,
      condition = { filetype = { "python" } },
    })

    overseer.register_template({
      name = "go (go run)",
      builder = function()
        return { cmd = { "go", "run", vim.fn.expand("%:p") } }
      end,
      condition = { filetype = { "go" } },
    })

    overseer.register_template({
      name = "c/cpp (make)",
      builder = function()
        return { cmd = { "make" } }
      end,
      condition = { filetype = { "c", "cpp" } },
    })

    overseer.register_template({
      name = "node",
      builder = function()
        return { cmd = { "node", vim.fn.expand("%:p") } }
      end,
      condition = { filetype = { "javascript" } },
    })

    overseer.register_template({
      name = "bash",
      builder = function()
        return { cmd = { "bash", vim.fn.expand("%:p") } }
      end,
      condition = { filetype = { "sh", "bash" } },
    })

    -- =========================================================================
    -- CARGO TEMPLATES (available in Rust files)
    -- =========================================================================

    local cargo_tasks = {
      { name = "cargo run",    args = { "run" } },
      { name = "cargo build",  args = { "build" } },
      { name = "cargo test",   args = { "test" } },
      { name = "cargo check",  args = { "check" } },
      { name = "cargo clippy", args = { "clippy", "--all-targets" } },
      { name = "cargo bench",  args = { "bench" } },
      { name = "cargo doc --open", args = { "doc", "--open" } },
      { name = "cargo clean",  args = { "clean" } },
    }

    for _, task in ipairs(cargo_tasks) do
      overseer.register_template({
        name = task.name,
        builder = function()
          return {
            cmd = { "cargo" },
            args = task.args,
            components = {
              { "on_output_quickfix", open_on_match = true },
              "default",
            },
          }
        end,
        condition = { filetype = { "rust", "toml" } },
      })
    end

    -- =========================================================================
    -- SHELL COMMAND RUNNER
    -- =========================================================================

    -- Run an arbitrary shell command (saved to history)
    local function run_shell_command(cmd_string)
      if not cmd_string or cmd_string == "" then return end
      add_to_history(cmd_string)
      local task = overseer.new_task({
        cmd = vim.fn.has("win32") == 1 and { "cmd", "/c", cmd_string } or { "sh", "-c", cmd_string },
        components = {
          { "on_output_quickfix", open_on_match = true },
          "default",
        },
        name = cmd_string,
      })
      task:start()
      overseer.open({ enter = false })
    end

    -- Prompt for a command and run it
    local function prompt_shell_command()
      vim.ui.input({ prompt = "Shell command: " }, function(input)
        run_shell_command(input)
      end)
    end

    -- Pick from command history and run
    local function pick_from_history()
      local history = load_history()
      if #history == 0 then
        vim.notify("No command history yet", vim.log.levels.INFO)
        return
      end
      vim.ui.select(history, {
        prompt = "Command history:",
        format_item = function(item) return item end,
      }, function(choice)
        run_shell_command(choice)
      end)
    end

    -- =========================================================================
    -- KEYMAPS
    -- =========================================================================

    vim.keymap.set("n", "<leader>rs", "<cmd>OverseerRun<cr>", { desc = "Run task" })
    vim.keymap.set("n", "<leader>rt", "<cmd>OverseerToggle<cr>", { desc = "Toggle task list" })
    vim.keymap.set("n", "<leader>rl", "<cmd>OverseerRestartLast<cr>", { desc = "Restart last task" })
    vim.keymap.set("n", "<leader>oc", prompt_shell_command, { desc = "Run shell command" })
    vim.keymap.set("n", "<leader>oh", pick_from_history, { desc = "Run from history" })
  end,
}
