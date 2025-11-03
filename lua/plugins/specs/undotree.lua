return {
  "mbbill/undotree",
  lazy = false,
  config = function()
    vim.g.undotree_WindowLayout = 2  -- Vertical split on the left
    vim.g.undotree_ShortIndicators = 1  -- Use short time indicators (s/m/h/d)
    vim.g.undotree_SetFocusWhenToggle = 1  -- Auto-focus undotree when opened
    vim.g.undotree_SplitWidth = 50  -- Reasonable width
    
    -- Enable persistent undo (crucial for undotree to be really useful)
    vim.opt.undofile = true
    vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
    
    -- Keymap to toggle
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
  end
}
