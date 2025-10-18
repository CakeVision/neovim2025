return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    adapters = {
        http = {
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = "ANTHROPIC_API_KEY",
              },
              schema = {
                model = {
                  default = "claude-sonnet-4-20250514",
                },
              },
            })
          end,
        },
      },
    strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
    },
  },
    --[[
  Key mappings for CodeCompanion.nvim plugin
  
  This table defines keyboard shortcuts for interacting with the AI-powered
  CodeCompanion plugin, which provides chat and code generation capabilities.
  
  Mappings:
  - <leader>cc: Opens a new CodeCompanion chat window
    * Modes: normal (n) and visual (v)
    * Use in normal mode to start a new conversation
    * Use in visual mode to include selected text in the chat context
  
  - <leader>ca: Adds selected content to an existing chat
    * Mode: visual (v) only
    * Requires text selection to add context to ongoing conversation
  
  - <leader>cd: Generates comprehensive docstrings for selected code
    * Mode: visual (v) only
    * Uses #{buffer} token to reference the current buffer
    * Automatically prompts AI to create documentation for selected code
  
  All mappings use the <leader> key prefix, which is typically mapped to
  space or backslash depending on user configuration.
  --]]
  keys = {
    { 
      "<leader>cc", 
      "<cmd>CodeCompanionChat<cr>", 
      mode = { "n", "v" }, 
      desc = "AI Chat" 
    },
    
    { 
      "<leader>ca", 
      "<cmd>CodeCompanionChat Add<cr>", 
      mode = "v", 
      desc = "Add to chat" 
    },
    {
      "<leader>cd",
      "<cmd>CodeCompanion #{buffer} Generate a comprehensive docstring for the selected code<cr>",
      mode = "v",
      desc = "Generate docstring"
    },
  },
}
