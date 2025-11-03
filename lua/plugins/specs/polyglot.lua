-- With lazy.nvim
return {
  'sheerun/vim-polyglot',
  lazy = false,
  init = function()
    -- Disable languages you want to handle with Tree-sitter instead
    vim.g.polyglot_disabled = {
      'lua',
      'python', 
      'javascript',
      'typescript',
      'rust',
      'go',
      'zig',
      -- Add any other languages you prefer Tree-sitter for
    }
    
    -- Optional: Performance settings
    vim.g.polyglot_performance = 1
  end,
  config = function()
    -- Any additional configuration can go here
    -- Most of the time, vim-polyglot works out of the box
  end
}
