return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = function(colors)
        return {
          -- Better visibility for Python-specific elements
          ["@variable.python"] = { fg = colors.text },
          ["@variable.builtin.python"] = { fg = colors.red, style = { "italic" } },
          ["@function.call.python"] = { fg = colors.blue },
          ["@function.builtin.python"] = { fg = colors.peach },
          ["@type.builtin.python"] = { fg = colors.yellow },
          ["@string.documentation.python"] = { fg = colors.green, style = { "italic" } },
          ["@keyword.python"] = { fg = colors.mauve },
          ["@keyword.function.python"] = { fg = colors.mauve },
          ["@keyword.return.python"] = { fg = colors.mauve, style = { "bold" } },
          
          -- Better LSP highlights
          ["@lsp.type.class.python"] = { fg = colors.yellow },
          ["@lsp.type.decorator.python"] = { fg = colors.peach },
          ["@lsp.type.function.python"] = { fg = colors.blue },
          ["@lsp.type.method.python"] = { fg = colors.blue },
          
          -- UI improvements
          CursorLine = { bg = colors.surface0 },
          Visual = { bg = colors.surface1, style = { "bold" } },
          
          -- Telescope improvements
          TelescopeSelection = { bg = colors.surface0, fg = colors.text, style = { "bold" } },
          TelescopeSelectionCaret = { fg = colors.flamingo },
          TelescopeMatching = { fg = colors.blue, style = { "bold" } },
          
          -- Better diagnostics visibility
          DiagnosticVirtualTextError = { bg = colors.none, fg = colors.red },
          DiagnosticVirtualTextWarn = { bg = colors.none, fg = colors.yellow },
          DiagnosticVirtualTextInfo = { bg = colors.none, fg = colors.sky },
          DiagnosticVirtualTextHint = { bg = colors.none, fg = colors.teal },
        }
      end,
      integrations = {
        cmp = true,
        treesitter = true,
        telescope = {
          enabled = true,
        },
        mason = true,
        which_key = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
