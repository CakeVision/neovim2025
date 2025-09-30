-- ~/.config/nvim/lua/plugins/specs/colorscheme.lua
-- Custom colorscheme based on your original base16 theme

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- We'll override tokyonight completely with our custom colors
      -- This just gives us a base to work from
      
      -- Define our custom colors based on your original base16 theme
      local colors = {
        base00 = "#030806", -- Dark green (almost black) - Default Background
        base01 = "#0d1f1a", -- Lighter Background (Used for status bars, line highlighting)
        base02 = "#122620", -- Selection Background
        base03 = "#7a8a80", -- Comments, Invisibles, Line Highlighting
        base04 = "#8a9a90", -- Dark Foreground (Used for status bars)
        base05 = "#d4e5d0", -- Default Foreground, Caret, Delimiters, Operators
        base06 = "#e8f4e4", -- Light Foreground (Not often used)
        base07 = "#f5fdf3", -- Light Background (Not often used)
        
        -- Colors
        base08 = "#d4572a", -- Muted Orange - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
        base09 = "#cc6633", -- Burnt Orange - Integers, Boolean, Constants, XML Attributes
        base0A = "#b8860b", -- Dark Goldenrod - Classes, Markup Bold, Search Text Background
        base0B = "#2d5016", -- Forest Green - Strings, Inherited Class, Markup Code, Diff Inserted
        base0C = "#458b74", -- Sea Green - Support, Regular Expressions, Escape Characters
        base0D = "#4682b4", -- Steel Blue - Functions, Methods, Attribute IDs, Headings
        base0E = "#a0522d", -- Sienna Brown - Keywords, Storage, Selector, Markup Italic, Diff Changed
        base0F = "#8b4726", -- Saddle Brown - Deprecated, Opening/Closing Embedded Language Tags
      }
      
      -- Set up our custom colorscheme
      local function setup_colorscheme()
        -- Clear any existing colorscheme
        vim.cmd("hi clear")
        if vim.fn.exists("syntax_on") then
          vim.cmd("syntax reset")
        end
        
        vim.g.colors_name = "custom_green"
        
        -- Basic vim highlights
        local highlights = {
          -- Editor basics
          Normal = { fg = colors.base05, bg = colors.base00 },
          NormalFloat = { fg = colors.base05, bg = colors.base01 },
          NormalNC = { fg = colors.base05, bg = colors.base00 },
          
          -- Cursor and lines
          Cursor = { fg = colors.base00, bg = colors.base05 },
          CursorLine = { bg = colors.base01 },
          CursorColumn = { bg = colors.base01 },
          CursorLineNr = { fg = colors.base0A, bg = colors.base01 },
          LineNr = { fg = colors.base03, bg = colors.base00 },
          
          -- Visual selection
          Visual = { bg = "#3a2215" },
          VisualNOS = { bg = colors.base02 },
          
          -- Search
          Search = { bg = colors.base09, fg = colors.base00, bold = true },
          IncSearch = { bg = colors.base0A, fg = colors.base00, bold = true },
          
          -- Diff
          DiffAdd = { bg = "#122620", fg = "#16c60c" },
          DiffChange = { bg = "#1f1a0f", fg = "#ffa62b" },
          DiffDelete = { bg = "#2a1616", fg = "#ff6b35" },
          DiffText = { bg = colors.base0A, fg = colors.base00 },
          
          -- Syntax highlighting
          Comment = { fg = colors.base03, italic = true },
          Constant = { fg = colors.base09 },
          String = { fg = colors.base0B },
          Character = { fg = colors.base08 },
          Number = { fg = colors.base09 },
          Boolean = { fg = colors.base09 },
          Float = { fg = colors.base09 },
          Identifier = { fg = colors.base08 },
          Function = { fg = colors.base0D },
          Statement = { fg = colors.base0E },
          Conditional = { fg = colors.base0E },
          Repeat = { fg = colors.base0E },
          Label = { fg = colors.base0A },
          Operator = { fg = colors.base05 },
          Keyword = { fg = colors.base0E },
          Exception = { fg = colors.base08 },
          PreProc = { fg = colors.base0A },
          Include = { fg = colors.base0D },
          Define = { fg = colors.base0E },
          Macro = { fg = colors.base08 },
          PreCondit = { fg = colors.base0A },
          Type = { fg = colors.base0A },
          StorageClass = { fg = colors.base0A },
          Structure = { fg = colors.base0E },
          Typedef = { fg = colors.base0A },
          Special = { fg = colors.base0C },
          SpecialChar = { fg = colors.base0F },
          Tag = { fg = colors.base0A },
          Delimiter = { fg = colors.base0F },
          SpecialComment = { fg = colors.base0C },
          Debug = { fg = colors.base08 },
          
          -- UI elements
          Pmenu = { bg = colors.base02, fg = colors.base05 },
          PmenuSel = { bg = "#3a2215", fg = colors.base07 },
          PmenuSbar = { bg = colors.base01 },
          PmenuThumb = { bg = colors.base0C },
          
          -- Statusline
          StatusLine = { bg = colors.base01, fg = colors.base05 },
          StatusLineNC = { bg = colors.base02, fg = colors.base03 },
          
          -- Borders and separators
          VertSplit = { fg = colors.base02 },
          WinSeparator = { fg = colors.base02 },
          
          -- Signs and numbers
          SignColumn = { bg = colors.base00, fg = colors.base03 },
          Folded = { bg = colors.base01, fg = colors.base03 },
          FoldColumn = { bg = colors.base00, fg = colors.base0C },
          
          -- Todo comment highlights
          TodoBgTODO = { bg = colors.base0D, fg = colors.base00, bold = true },
          TodoBgFIX = { bg = colors.base08, fg = colors.base00, bold = true },
          TodoBgHACK = { bg = colors.base0A, fg = colors.base00, bold = true },
          TodoBgWARN = { bg = colors.base0E, fg = colors.base07, bold = true },
          TodoBgPERF = { bg = colors.base0C, fg = colors.base00, bold = true },
          TodoBgNOTE = { bg = colors.base0B, fg = colors.base07, bold = true },
          
          -- Telescope colors
          TelescopeSelection = { bg = colors.base02 },
          TelescopeSelectionCaret = { fg = colors.base08 },
          TelescopeMatching = { fg = colors.base09, bold = true },
          
          -- Which-key colors
          WhichKey = { fg = colors.base08 },
          WhichKeyGroup = { fg = colors.base0D },
          WhichKeyDesc = { fg = colors.base05 },
          WhichKeySeparator = { fg = colors.base03 },
          
          -- Diagnostics
          DiagnosticError = { fg = colors.base08 },
          DiagnosticWarn = { fg = colors.base0A },
          DiagnosticInfo = { fg = colors.base0D },
          DiagnosticHint = { fg = colors.base0C },
          
          -- Tree-sitter context
          TreesitterContext = { bg = colors.base01 },
          TreesitterContextLineNumber = { fg = colors.base03, bg = colors.base01 },
          
          -- Mini.hipatterns
          MiniHipatternsTodo = { bg = colors.base0D, fg = colors.base00, bold = true },
          MiniHipatternsFixme = { bg = colors.base08, fg = colors.base00, bold = true },
          MiniHipatternsHack = { bg = colors.base0A, fg = colors.base00, bold = true },
          MiniHipatternsNote = { bg = colors.base0B, fg = colors.base07, bold = true },
        }
        
        -- Apply all highlights
        for group, opts in pairs(highlights) do
          vim.api.nvim_set_hl(0, group, opts)
        end
      end
      
      -- Set up the colorscheme
      setup_colorscheme()
      
      -- Reapply on colorscheme reload
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "custom_green",
        callback = setup_colorscheme,
      })
    end,
  },
}
