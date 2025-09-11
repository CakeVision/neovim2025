-- ~/.config/nvim/lua/plugins/specs/refactoring.lua
-- Refactoring.nvim: The Refactoring library based off the Refactoring book by Martin Fowler

return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- Enable prompt for function return type
      prompt_func_return_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
        python = true,
      },
      
      -- Enable prompt for function parameters
      prompt_func_param_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
        python = true,
      },
      
      -- Printf statement for debugging
      printf_statements = {},
      
      -- Print var statement for debugging
      print_var_statements = {},
      
      -- Show success messages
      show_success_message = true,
    },
    config = function(_, opts)
      require("refactoring").setup(opts)
    end,
    keys = {
      -- Extract function (visual mode)
      {
        "<leader>re",
        function()
          require('refactoring').refactor('Extract Function')
        end,
        mode = "v",
        desc = "Extract function",
      },
      
      -- Extract function to file (visual mode)
      {
        "<leader>rf",
        function()
          require('refactoring').refactor('Extract Function To File')
        end,
        mode = "v",
        desc = "Extract function to file",
      },
      
      -- Extract variable (visual mode)
      {
        "<leader>rv",
        function()
          require('refactoring').refactor('Extract Variable')
        end,
        mode = "v",
        desc = "Extract variable",
      },
      
      -- Inline variable (visual and normal mode)
      {
        "<leader>ri",
        function()
          require('refactoring').refactor('Inline Variable')
        end,
        mode = { "n", "v" },
        desc = "Inline variable",
      },
      
      -- Extract block (visual mode)
      {
        "<leader>rb",
        function()
          require('refactoring').refactor('Extract Block')
        end,
        mode = "v",
        desc = "Extract block",
      },
      
      -- Extract block to file (visual mode)
      {
        "<leader>rbf",
        function()
          require('refactoring').refactor('Extract Block To File')
        end,
        mode = "v",
        desc = "Extract block to file",
      },
      
      -- Refactoring menu (requires telescope)
      {
        "<leader>rr",
        function()
          require("telescope").extensions.refactoring.refactors()
        end,
        mode = { "n", "v" },
        desc = "Refactoring menu",
      },
      
      -- Debug operations
      {
        "<leader>rp",
        function()
          require('refactoring').debug.printf({ below = false })
        end,
        desc = "Debug print",
      },
      
      {
        "<leader>rdv",
        function()
          require('refactoring').debug.print_var()
        end,
        mode = "v",
        desc = "Debug print variable",
      },
      
      {
        "<leader>rdc",
        function()
          require('refactoring').debug.cleanup({})
        end,
        desc = "Debug cleanup",
      },
    },
  },
  
  -- Pymple.nvim for Python import management
  {
    "alexpasmantier/pymple.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- Optional but recommended
      "nvim-tree/nvim-web-devicons",
    },
    build = ":PympleBuild",
    ft = "python",
    opts = {
      -- Enable for Python and Markdown files
      update_imports = {
        filetypes = { "python", "markdown" }
      },
      
      -- Auto-save after adding imports
      add_import_to_buf = {
        autosave = true
      },
      
      -- Python project settings
      python = {
        root_markers = { "pyproject.toml", "setup.py", ".git", "manage.py", "requirements.txt", ".venv", "venv" },
        virtual_env_names = { ".venv", "venv", "env", ".env" }
      }
    },
    keys = {
      -- Resolve import under cursor
      {
        "<leader>pi",
        function()
          require('pymple.api').resolve_import_under_cursor()
        end,
        ft = "python",
        desc = "Add import for symbol",
      },
      
      -- Update imports after file move/rename
      {
        "<leader>pu",
        function()
          local source = vim.fn.input("Source file: ")
          local dest = vim.fn.input("Destination file: ")
          if source ~= "" and dest ~= "" then
            require('pymple.api').update_imports(source, dest)
          else
            vim.notify("Use :PympleUpdateImports <source> <destination> for moving files", vim.log.levels.INFO)
          end
        end,
        ft = "python",
        desc = "Update imports after move",
      },
    },
  },
}
