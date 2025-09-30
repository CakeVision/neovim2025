return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        -- Gemini API setup
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = "GEMINI_API_KEY", 
            },
          })
        end,
        -- Ollama setup (backup option)
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = "http://localhost:11434",
            },
          })
        end,
      },
      -- Set Gemini as default
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },
    })
  end,
  schema = {
    model = {
      default = "gemini-2.0-flash",
    },
  },
  -- Lazy load on commands
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionToggle",
  },
  -- Key mappings
  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "CodeCompanion Chat" },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "v" }, desc = "CodeCompanion Actions" },
    { "<leader>ct", "<cmd>CodeCompanionToggle<cr>", mode = { "n" }, desc = "CodeCompanion Toggle" },
  },
}
