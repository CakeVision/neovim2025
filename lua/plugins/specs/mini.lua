-- ~/.config/nvim/lua/plugins/specs/mini.lua
-- Mini.nvim: Collection of minimal, independent, and fast Lua modules

return {
  -- Mini.nvim suite
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({
        n_lines = 500,
        custom_textobjects = {
          o = require("mini.ai").gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup({
        mappings = {
          add = "sa", -- Add surrounding in Normal and Visual modes
          delete = "sd", -- Delete surrounding
          find = "sf", -- Find surrounding (to the right)
          find_left = "sF", -- Find surrounding (to the left)
          highlight = "sh", -- Highlight surrounding
          replace = "sr", -- Replace surrounding
          update_n_lines = "sn", -- Update `n_lines`
        },
      })

      -- Auto-pairing of brackets, quotes, etc.
      require("mini.pairs").setup({
        modes = { insert = true, command = false, terminal = false },
        -- skip autopair when next character is one of these
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        -- skip autopair when the cursor is inside these treesitter nodes
        skip_ts = { "string" },
        -- skip autopair when next character is closing pair
        -- and there are more closing pairs than opening pairs
        skip_unbalanced = true,
        -- better deal with markdown code blocks
        markdown = true,
      })

      -- Buffer removing (unshow, delete, wipeout), which saves window layout
      require("mini.bufremove").setup()

      -- Simple and easy statusline
      local statusline = require("mini.statusline")
      statusline.setup({
        use_icons = true,
        set_vim_settings = false, -- We handle this in options.lua
      })

      -- Customize statusline sections
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end

      -- File explorer improvements
      require("mini.files").setup({
        -- Customization of shown content
        content = {
          filter = nil,
          prefix = require("mini.files").default_prefix,
          sort = require("mini.files").default_sort,
        },
        -- Module mappings created only inside explorer
        mappings = {
          close = "q",
          go_in = "l",
          go_in_plus = "L",
          go_out = "h",
          go_out_plus = "H",
          reset = "<BS>",
          reveal_cwd = "@",
          show_help = "g?",
          synchronize = "=",
          trim_left = "<",
          trim_right = ">",
        },
        -- General options
        options = {
          permanent_delete = true,
          use_as_default_explorer = false, -- We use Oil for this
        },
        -- Customization of explorer windows
        windows = {
          max_number = math.huge,
          preview = false,
          width_focus = 50,
          width_nofocus = 15,
          width_preview = 25,
        },
      })

      -- Better text commenting
      require("mini.comment").setup({
        options = {
          custom_commentstring = function()
            return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
          end,
        },
      })

      -- Highlight patterns in text
      require("mini.hipatterns").setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
        },
      })
    end,
    keys = {
      -- Buffer remove
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete buffer",
      },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete buffer (force)" },
      
      -- File explorer
      {
        "<leader>fm",
        function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end,
        desc = "Open mini.files (directory of current file)",
      },
      {
        "<leader>fM",
        function() require("mini.files").open(vim.loop.cwd(), true) end,
        desc = "Open mini.files (cwd)",
      },
    },
  },
}
