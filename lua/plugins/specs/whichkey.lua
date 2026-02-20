-- ~/.config/nvim/lua/plugins/specs/whichkey.lua
-- Which-key: Shows available keybindings in a popup

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- Configuration for which-key
      preset = "helix", -- "classic", "modern", or "helix"

      -- Delay before showing the popup (in ms)
      delay = 200,

      -- You can add any additional options here
      filter = function(mapping)
        -- example to exclude mappings without a description
        return mapping.desc and mapping.desc ~= ""
      end,

      -- Replace certain key representations
      replace = {
        ["<space>"] = "SPC",
        ["<leader>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },

      -- Window configuration
      win = {
        border = "rounded", -- none, single, double, rounded, solid, shadow
        padding = { 1, 2 }, -- extra window padding [top/bottom, left/right]
        title = true,
        title_pos = "center",
        zindex = 1000,
      },

      -- Layout configuration
      layout = {
        spacing = 3,    -- spacing between columns
        align = "left", -- align columns left, center or right
      },

      -- Show icons
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
        ellipsis = "…",
        -- set to false to disable all mapping icons,
        -- both those explicitely added in a mapping
        -- and those from rules
        mappings = true,
        -- use the highlights from mini.icons
        -- When `false`, it will use `WhichKeyIcon` instead
        colors = true,
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Define key groups for better organization
      wk.add({
        -- Main groups
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        -- { "<leader>d", group = "debug/direnv" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp" },
        { "<leader>p", group = "python" },
        { "<leader>q", group = "quickfix" },
        { "<leader>r", group = "refactor" },
        { "<leader>t", group = "treesitter/toggle" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics" },

        -- Goto group
        { "g",         group = "goto" },

        -- Bracket navigation
        { "]",         group = "next" },
        { "[",         group = "prev" },

        -- Fold group
        { "z",         group = "fold" },

        -- Marks group
        { "m",         group = "marks" },

        -- Registers group
        { '"',         group = "registers" },

        -- Window commands
        { "<C-w>",     group = "windows" },

        -- Buffer-specific groups that might be added by LSP/other plugins
        mode = { "n", "v" },
      })
      wk.add({
        { "<leader>d",  group = "Debug" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end,          desc = "Continue" },
        { "<leader>di", function() require("dap").step_into() end,         desc = "Step Into" },
        { "<leader>do", function() require("dap").step_over() end,         desc = "Step Over" },
        { "<leader>dr", function() require("dap").repl.open() end,         desc = "REPL" },
      })
      wk.add({
        { "<leader>o",  group = "Overseer" },
        { "<leader>or", "<cmd>OverseerRun<cr>",         desc = "Run task" },
        { "<leader>ot", "<cmd>OverseerToggle<cr>",      desc = "Toggle task list" },
        { "<leader>ol", "<cmd>OverseerRestartLast<cr>", desc = "Restart last task" },
        { "<leader>oc", desc = "Run shell command" },
        { "<leader>oh", desc = "Run from history" },
      })
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
