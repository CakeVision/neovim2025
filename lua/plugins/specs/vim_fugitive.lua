return {
  "tpope/vim-fugitive",
  lazy=false,
  config = function()
    -- Quick commit
    vim.keymap.set('n', '<leader>gC', ':Git commit<CR>', { desc = "Git Commit" })
    vim.keymap.set('n', '<leader>gA', ':Git add .', {desc = "Add all"})
    -- Branch operations
    vim.keymap.set('n', '<leader>gb', ':Git branch<CR>', { desc = "Git Branches" })
    vim.keymap.set('n', '<leader>gB', ':Git checkout<Space>', { desc = "Git Checkout Branch" })
    -- Quick status
    vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = "Git Status" })
  end
}
