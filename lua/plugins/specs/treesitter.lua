-- ~/.config/nvim/lua/plugins/specs/treesitter.lua
-- Treesitter: Better syntax highlighting and code understanding

return {
  -- Treesitter core (main branch; master is archived and broken on nvim 0.12)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      local ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "go",
        "html",
        "ini",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      }

      local ts = require("nvim-treesitter")
      ts.install(ensure_installed)

      local available = {}
      for _, lang in ipairs(ts.get_available()) do
        available[lang] = true
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then
            return
          end

          local function enable()
            if not vim.api.nvim_buf_is_valid(args.buf) then
              return
            end
            if pcall(vim.treesitter.start, args.buf, lang) then
              vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end

          -- Automatically install missing parsers when entering buffer
          if available[lang] and not vim.list_contains(ts.get_installed(), lang) then
            ts.install(lang):await(function()
              vim.schedule(enable)
            end)
          else
            enable()
          end
        end,
      })

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99

      -- Incremental selection (built-in `an`/`in` node selection in nvim 0.12)
      vim.keymap.set("n", "<CR>", function()
        if vim.bo.buftype == "" and vim.treesitter.get_parser(nil, nil, { error = false }) then
          vim.cmd("normal van")
        else
          vim.api.nvim_feedkeys(vim.keycode("<CR>"), "n", false)
        end
      end, { desc = "Start incremental selection" })
      vim.keymap.set("x", "<CR>", "an", { remap = true, desc = "Increment selection" })
      vim.keymap.set("x", "<BS>", "in", { remap = true, desc = "Decrement selection" })
    end,
  },

  -- Text objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true }, -- Automatically jump forward to textobj
        move = { set_jumps = true }, -- whether to set jumps in the jumplist
      })

      local select = require("nvim-treesitter-textobjects.select")
      for key, query in pairs({
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
      }) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end, { desc = "Select " .. query })
      end

      local move = require("nvim-treesitter-textobjects.move")
      for fn, maps in pairs({
        goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
        goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
      }) do
        for key, query in pairs(maps) do
          vim.keymap.set({ "n", "x", "o" }, key, function()
            move[fn](query, "textobjects")
          end, { desc = fn .. " " .. query })
        end
      end

      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>tn", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap next parameter" })
      vim.keymap.set("n", "<leader>tp", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap previous parameter" })
    end,
  },

  -- Treesitter context - shows current function/class at top
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true,
      max_lines = 3, -- How many lines the context should show
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor", -- cursor or topline
      separator = "─", -- Can be nil for no separator
    },
    keys = {
      {
        "<leader>tc",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },
}
