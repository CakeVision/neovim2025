-- ~/.config/nvim/lua/plugins/specs/mason.lua
-- Mason: Portable package manager for Neovim

return {
  -- Mason core
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- Language servers (Python focus)
        -- "python-lsp-server",         -- Python LSP
        "basedpyright",
        "ruff",
        "lua-language-server", -- For Neovim config
        "gopls",           -- Go LSP (if you use Go)
        "rust-analyzer",   -- Rust LSP (if you use Rust)
        "marksman",        -- Markdown LSP
        "yaml-language-server", -- YAML LSP
        "json-lsp",        -- JSON LSP
        "bash-language-server", -- Bash LSP
        
        -- Python formatters and linters
        "black",           -- Python formatter
        "isort",           -- Python import sorter
        "mypy",            -- Python type checker
        "pylint",          -- Python linter
        
        -- Other formatters
        "stylua",          -- Lua formatter (for Neovim config)
        "gofumpt",         -- Go formatter (if you use Go)
        
        -- Additional tools for development
        "debugpy",         -- Python debugger
        
        -- Additional tools for Telescope and general use
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      
      -- Function to ensure tools are installed
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      
      -- Install tools on Mason registry refresh
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Mason integration with LSP
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      -- Automatically install LSP servers configured with lspconfig
      automatic_installation = true,
      ensure_installed = {
        "lua_ls",
        --"python-lsp-server",
        "gopls",           -- if you use Go
        "rust_analyzer",   -- if you use Rust
        "marksman",
        "yamlls",
        "jsonls",
        "bashls",
      },
    },
  },
}
