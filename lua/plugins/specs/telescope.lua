-- ~/.config/nvim/lua/plugins/specs/telescope.lua
-- Telescope: Highly extendable fuzzy finder

return {
  -- Telescope core
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "debugloop/telescope-undo.nvim",
    },
    keys = {
      -- File pickers
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find git files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },

      -- Search pickers
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep search" },
      { "<leader>*", "<cmd>Telescope grep_string<cr>", desc = "Search word under cursor" },
      { "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search current buffer" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Search help" },
      { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Search man pages" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Search keymaps" },
      { "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Search commands" },

      -- LSP pickers (will be enhanced when LSP is added)
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>ld", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "LSP references" },
      { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP implementations" },

      -- Git pickers
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      -- { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Git buffer commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },

      -- Other pickers
      { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo tree" },
      { "<leader><leader>", "<cmd>Telescope resume<cr>", desc = "Resume last search" },

      {
        "<leader>fd",
        function()
          local pickers = require('telescope.pickers')
          local finders = require('telescope.finders')
          local conf = require('telescope.config').values

          pickers.new({}, {
            prompt_title = "Find Directories",
            finder = finders.new_oneshot_job({
              "find", ".", 
              "-type", "d", 
              "-name", ".git", "-prune", "-o", 
              "-type", "d", "-print"
            }, {}),
            sorter = conf.generic_sorter({}),
            previewer = false,
            theme = require('telescope.themes').get_dropdown(),
          }):find()
        end,
        desc = "Find directories",
      },      
      {
        "<leader>ft",
        function()
          require('telescope.builtin').grep_string({
            prompt_title = "Find TODOs",
            search = "\\b(TODO|FIXME|HACK|WARN|PERF|NOTE|TEST|REVIEW|QUESTION):",
            use_regex = true,
            theme = "ivy",
            initial_mode = "normal",
            layout_config = {
              height = 0.4,
            },
          })
        end,
        desc = "Search todos",
      },
      {
        "<leader>fT",
        function()
          require('telescope.builtin').current_buffer_fuzzy_find({
            prompt_title = "Buffer TODOs",
            default_text = "TODO:|FIXME:|HACK:|WARN:|PERF:|NOTE:|TEST:|REVIEW:|QUESTION:",
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
            layout_config = {
              width = 0.6,
              height = 0.4,
            },
          })
        end,
        desc = "Buffer todos",
      },
      {
        "<leader>qd",
        function()
          require('telescope.builtin').find_files({
            prompt_title = "Directories → Quickfix",
            find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git" },
            previewer = false,
            theme = "ivy",
            attach_mappings = function(_, map)
              local actions = require('telescope.actions')
              map('i', '<CR>', function(prompt_bufnr)
                actions.send_to_qflist(prompt_bufnr)
                actions.open_qflist(prompt_bufnr)
              end)
              return true
            end,
          })
        end,
        desc = "Directories to quickfix",
      },
      {
        "<leader>qt",
        function()
          require('telescope.builtin').grep_string({
            prompt_title = "TODOs → Quickfix",
            search = "\\b(TODO|FIXME|HACK|WARN|PERF|NOTE|TEST|REVIEW|QUESTION):",
            use_regex = true,
            theme = "ivy",
            initial_mode = "normal",
            attach_mappings = function(_, map)
              local actions = require('telescope.actions')
              local function send_to_qf(prompt_bufnr)
                actions.send_to_qflist(prompt_bufnr)
                actions.open_qflist(prompt_bufnr)
              end
              map('n', '<CR>', send_to_qf)
              map('i', '<CR>', send_to_qf)
              return true
            end,
          })
        end,
        desc = "TODOs to quickfix",
      },
    },
    opts = {
      defaults = {
        prompt_prefix = "🔍 ",
        selection_caret = "▶ ",
        entry_prefix = "  ",

        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",

        layout_strategy = "flex",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },

        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
          "target/", -- Rust
          "__pycache__/",
          "*.pyc",
          ".venv/",
          "vendor/", -- Go
        },

        path_display = { "truncate" },
        winblend = 0,

        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

        color_devicons = true,
        use_less = true,
        set_env = {
          COLORTERM = "truecolor",
        },

        mappings = {
          i = {
            ["<C-n>"] = "move_selection_next",
            ["<C-p>"] = "move_selection_previous",
            ["<C-c>"] = "close",
            ["<Down>"] = "move_selection_next",
            ["<Up>"] = "move_selection_previous",
            ["<CR>"] = "select_default",
            ["<C-x>"] = "select_horizontal",
            ["<C-v>"] = "select_vertical",
            ["<C-t>"] = "select_tab",
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
            ["<C-q>"] = function(prompt_bufnr)
              local actions = require("telescope.actions")
              actions.send_to_qflist(prompt_bufnr)
              actions.open_qflist(prompt_bufnr)
            end,
            ["<M-q>"] = function(prompt_bufnr)
              local actions = require("telescope.actions")
              actions.send_selected_to_qflist(prompt_bufnr)
              actions.open_qflist(prompt_bufnr)
            end,
            ["<Tab>"] = function(prompt_bufnr)
              local actions = require("telescope.actions")
              actions.toggle_selection(prompt_bufnr)
              actions.move_selection_worse(prompt_bufnr)
            end,
            ["<S-Tab>"] = function(prompt_bufnr)
              local actions = require("telescope.actions")
              actions.toggle_selection(prompt_bufnr)
              actions.move_selection_better(prompt_bufnr)
            end,
            ["<C-l>"] = "complete_tag",
            ["<C-_>"] = "which_key",
          },
          n = {
            ["<esc>"] = "close",
            ["<CR>"] = "select_default",
            ["<C-x>"] = "select_horizontal",
            ["<C-v>"] = "select_vertical",
            ["<C-t>"] = "select_tab",
            ["<Tab>"] = function(prompt_bufnr)
              local actions = require("telescope.actions")
              actions.toggle_selection(prompt_bufnr)
              actions.move_selection_worse(prompt_bufnr)
            end,
            ["<S-Tab>"] = function(prompt_bufnr)
              local actions = require("telescope.actions")
              actions.toggle_selection(prompt_bufnr)
              actions.move_selection_better(prompt_bufnr)
            end,
            ["<C-q>"] = function(prompt_bufnr)
              local actions = require("telescope.actions")
              actions.send_to_qflist(prompt_bufnr)
              actions.open_qflist(prompt_bufnr)
            end,
            ["<M-q>"] = function(prompt_bufnr)
              local actions = require("telescope.actions")
              actions.send_selected_to_qflist(prompt_bufnr)
              actions.open_qflist(prompt_bufnr)
            end,
            ["j"] = "move_selection_next",
            ["k"] = "move_selection_previous",
            ["H"] = "move_to_top",
            ["M"] = "move_to_middle",
            ["L"] = "move_to_bottom",
            ["<Down>"] = "move_selection_next",
            ["<Up>"] = "move_selection_previous",
            ["gg"] = "move_to_top",
            ["G"] = "move_to_bottom",
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
            ["?"] = "which_key",
          },
        },
      },

      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
        },
        live_grep = {
          theme = "ivy",
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
          sort_mru = true,
          sort_lastused = true,
        },
        current_buffer_fuzzy_find = {
          theme = "dropdown",
          previewer = false,
        },
        oldfiles = {
          theme = "dropdown",
          previewer = false,
        },
        command_history = {
          theme = "dropdown",
        },
        git_files = {
          theme = "dropdown",
          previewer = false,
        },
        help_tags = {
          theme = "ivy",
        },
        man_pages = {
          theme = "ivy",
        },
        diagnostics = {
          theme = "ivy",
        },
        lsp_references = {
          theme = "ivy",
          include_declaration = true,
        },
        lsp_implementations = {
          theme = "ivy",
        },
        lsp_document_symbols = {
          theme = "dropdown",
        },
        lsp_workspace_symbols = {
          theme = "dropdown",
        },
      },

      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
        --["ui-select"] = {
        --  require("telescope.themes").get_dropdown({
        --    -- even more opts
        --  }),
        --  specific_opts = {
        --    codeactions = true,
        --  },
        --},
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
        lsp_handlers = {
          definition = {
            telescope = false, -- Use vim's default handler for single definitions
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("undo")
      
      -- Integrate with refactoring.nvim if available
      pcall(telescope.load_extension, "refactoring")
    end,
  },

  -- Mini module for icons (lightweight alternative to nvim-web-devicons)
  {
    "echasnovski/mini.icons",
    opts = {},
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
