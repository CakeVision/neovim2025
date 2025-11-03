return {
  "kdheepak/lazygit.nvim",
  lazy=false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = "LazyGit" })
    vim.keymap.set('n', '<leader>gc', ':LazyGitCurrentFile<CR>', { desc = "LazyGit Current File" })
  end
}
