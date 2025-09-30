return {
  -- Treesitter context for comments
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  
  -- Comment.nvim - better than mini.comment for extensibility
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
     keys = {
      -- Ctrl-/ in normal mode - toggle current line
      { 
        "<C-_>",  -- Ctrl-/ is sent as Ctrl-_ by terminals
        function() 
          require("Comment.api").toggle.linewise.current() 
        end,
        mode = "n",
        desc = "Toggle comment line"
      },
      -- Ctrl-/ in visual mode - toggle selection
      { 
        "<C-_>",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
        mode = "v",
        desc = "Toggle comment selection"
      },
      -- Ctrl-/ in insert mode - toggle current line and stay in insert
      { 
        "<C-_>",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise.current()<CR>i",
        mode = "i",
        desc = "Toggle comment line"
      },
    },
    opts = function()
      return {
        -- Add a space between comment and line
        padding = true,
        -- Whether cursor should stay at the position
        sticky = true,
        -- Lines to ignore
        ignore = "^$",
        
        -- LHS of operator-pending mappings in NORMAL and VISUAL mode
        -- toggler = {
        --   line = "gcc",  -- Line-comment toggle
        --   block = "gbc", -- Block-comment toggle
        -- },
        --
        -- -- LHS of extra mappings
        -- opleader = {
        --   line = "gc",   -- Line-comment operator
        --   block = "gb",  -- Block-comment operator
        -- },
        --
        -- -- LHS of mappings in NORMAL and VISUAL mode
        -- extra = {
        --   above = "gcO", -- Add comment on line above
        --   below = "gco", -- Add comment on line below
        --   eol = "gcA",   -- Add comment at end of line
        -- },
        --
        -- -- Enable keybindings
        -- mappings = {
        --   basic = true,
        --   extra = true,
        -- },
        -- Function to be called before comment
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        -- Function to be called after comment
        post_hook = nil,
      }
    end,
  },
}

