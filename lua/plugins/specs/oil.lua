-- ~/.config/nvim/lua/plugins/specs/oil.lua
-- Oil.nvim: A vim-vinegar like file explorer

return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
      { "<leader>e", "<CMD>Oil<CR>", desc = "File explorer" },
    },
    opts = {
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      default_file_explorer = true,

      -- Columns to show
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },

      -- Buffer-local options to use for oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },

      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },

      -- Send deleted files to the trash instead of permanently deleting them
      delete_to_trash = true,

      -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
      skip_confirm_for_simple_edits = false,

      -- Selecting a new/moved/renamed file will prompt you to save changes first
      -- (:help oil.prompt_save_on_select_new_entry)
      prompt_save_on_select_new_entry = true,

      -- Oil will automatically delete hidden buffers after this delay
      cleanup_delay_ms = 2000,

      lsp_file_methods = {
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        autosave_changes = false,
      },

      -- Constrain the cursor to the editable parts of the oil buffer
      constrain_cursor = "editable",

      -- Set to true to watch the filesystem for changes and reload oil
      experimental_watch_for_changes = false,

      -- Keymaps in oil buffer
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
        ["Q"] = {
          callback = function()
            local oil = require("oil")
            local current_buf = vim.api.nvim_get_current_buf()
            
            oil.close()
            
             -- Get all listed buffers sorted by most recently used
            local buffers = vim.fn.getbufinfo({buflisted = 1})
            table.sort(buffers, function(a, b)
              return a.lastused > b.lastused
            end)
            
            -- Find the first valid buffer that isn't the current one
            for _, buf in ipairs(buffers) do
              if buf.bufnr ~= current_buf 
                 and vim.api.nvim_buf_get_name(buf.bufnr) ~= "" 
                 and vim.api.nvim_buf_is_loaded(buf.bufnr) then
                vim.cmd("buffer " .. buf.bufnr)
                return
              end
            end
            
            -- No previous buffer found, open an empty one
            vim.cmd("enew")
          end,
          desc = "Close oil and return to previous buffer or empty buffer",
        },
      },

      -- Set to false to disable all of the above keymaps
      use_default_keymaps = true,

      view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          return false
        end,
        -- Sort file names in a more intuitive order for humans
        natural_order = true,
        sort = {
          -- sort order can be "asc" or "desc"
          -- see :help oil-columns to see which columns are sortable
          { "type", "asc" },
          { "name", "asc" },
        },
      },

      -- Configuration for the floating window in oil.open_float
      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 0.9,
        max_height = 0.9,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- This is the config that will be passed to nvim_open_win
        override = function(conf)
          return conf
        end,
      },

      -- Configuration for the actions floating preview window
      preview = {
        -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0.9,
        -- min_width = 40,
        -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_height = 0.9,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
      },

      -- Configuration for the floating progress window
      progress = {
        max_width = 0.9,
        min_width = 40,
        width = nil,
        max_height = 10,
        min_height = 5,
        height = nil,
        border = "rounded",
        minimized_border = "none",
        win_options = {
          winblend = 0,
        },
      },

      -- Configuration for the floating SSH window
      ssh = {
        border = "rounded",
      },
    },
    
    config = function(_, opts)
      local oil = require("oil")
      oil.setup(opts)
    end,
  },
}
