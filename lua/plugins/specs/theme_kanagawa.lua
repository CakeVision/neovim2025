return {
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none"
            }
          }
        }
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Set pure black background
          Normal = { bg = "#000000" },
          NormalFloat = { bg = "#000000" },
          FloatBorder = { bg = "#000000" },
          FloatTitle = { bg = "#000000" },
          
          -- Better visibility for Python-specific elements
          ["@variable.python"] = { fg = theme.syn.identifier },
          ["@variable.builtin.python"] = { fg = theme.syn.special1, italic = true },
          ["@function.call.python"] = { fg = theme.syn.fun },
          ["@function.builtin.python"] = { fg = theme.syn.special2 },
          ["@type.builtin.python"] = { fg = theme.syn.type },
          ["@string.documentation.python"] = { fg = theme.syn.string, italic = true },
          ["@keyword.python"] = { fg = theme.syn.keyword },
          ["@keyword.function.python"] = { fg = theme.syn.keyword },
          ["@keyword.return.python"] = { fg = theme.syn.keyword, bold = true },
          
          -- Better LSP highlights
          ["@lsp.type.class.python"] = { fg = theme.syn.type },
          ["@lsp.type.decorator.python"] = { fg = theme.syn.special2 },
          ["@lsp.type.function.python"] = { fg = theme.syn.fun },
          ["@lsp.type.method.python"] = { fg = theme.syn.fun },
          
          -- UI improvements
          CursorLine = { bg = theme.ui.bg_p1 },
          Visual = { bg = theme.ui.bg_visual, bold = true },
          
          -- Telescope improvements
          TelescopeSelection = { bg = theme.ui.bg_p1, fg = theme.ui.fg, bold = true },
          TelescopeSelectionCaret = { fg = theme.syn.special1 },
          TelescopeMatching = { fg = theme.syn.fun, bold = true },
          TelescopePromptNormal = { bg = "#000000" },
          TelescopeResultsNormal = { bg = "#000000" },
          TelescopePreviewNormal = { bg = "#000000" },
          TelescopePromptBorder = { bg = "#000000", fg = theme.ui.bg_p1 },
          TelescopeResultsBorder = { bg = "#000000", fg = theme.ui.bg_p1 },
          TelescopePreviewBorder = { bg = "#000000", fg = theme.ui.bg_p1 },
          
          -- Better diagnostics visibility
          DiagnosticVirtualTextError = { bg = "none", fg = theme.diag.error },
          DiagnosticVirtualTextWarn = { bg = "none", fg = theme.diag.warning },
          DiagnosticVirtualTextInfo = { bg = "none", fg = theme.diag.info },
          DiagnosticVirtualTextHint = { bg = "none", fg = theme.diag.hint },
          
          -- Popup menus with black background
          Pmenu = { fg = theme.ui.shade0, bg = "#000000" },
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
        }
      end,
      theme = "wave", -- Load "wave" theme when 'background' option is not set
      background = {
        dark = "wave",
        light = "lotus"
      },
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
