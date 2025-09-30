-- ~/.config/nvim/lua/config/keymaps.lua
---- Key mappings

local keymap = vim.keymap.set

-- =============================================================================
-- GENERAL MAPPINGS
-- =============================================================================

-- Disable space in normal and visual mode (since it's our leader)
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Quick escape
keymap("i", "jk", "<ESC>", { silent = true })

-- Clear search highlight
keymap("n", "<leader>h", ":nohl<CR>", { desc = "Clear search highlight", silent = true })

-- Quick save
keymap({"n", "i", "v"}, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file", silent = true })

-- =============================================================================
-- WINDOW NAVIGATION
-- =============================================================================

-- Navigate between windows
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window", silent = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", silent = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", silent = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window", silent = true })

-- =============================================================================
-- WINDOW RESIZING
-- =============================================================================

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", { silent = true })
keymap("n", "<C-Down>", ":resize +2<CR>", { silent = true })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })

-- =============================================================================
-- WINDOW MANAGEMENT
-- =============================================================================

-- Split windows
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split vertical", silent = true })
keymap("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal", silent = true })
keymap("n", "<leader>wc", "<C-w>c", { desc = "Close window", silent = true })
keymap("n", "<leader>wo", "<C-w>o", { desc = "Close other windows", silent = true })
keymap("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows", silent = true })
keymap("n", "<leader>wm", "<C-w>|<C-w>_", { desc = "Maximize window", silent = true })

-- =============================================================================
-- BUFFER NAVIGATION
-- =============================================================================

-- Navigate between buffers
keymap("n", "[b", ":bprevious<CR>", { desc = "Previous buffer", silent = true })
keymap("n", "]b", ":bnext<CR>", { desc = "Next buffer", silent = true })

-- Buffer management (most handled by Mini.bufremove)
keymap("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer", silent = true })
keymap("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer", silent = true })
keymap("n", "<leader>ba", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete all other buffers", silent = true })

-- =============================================================================
-- TEXT EDITING
-- =============================================================================

-- Better indenting in visual mode
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- =============================================================================
-- TOGGLE MAPPINGS
-- =============================================================================

-- Toggle relative line numbers
keymap("n", "<leader>tn", "<cmd>set relativenumber!<cr>", { desc = "Toggle relative numbers", silent = true })

-- Toggle word wrap
keymap("n", "<leader>tw", "<cmd>set wrap!<cr>", { desc = "Toggle word wrap", silent = true })

-- Toggle spell check
keymap("n", "<leader>ts", "<cmd>set spell!<cr>", { desc = "Toggle spell check", silent = true })

-- Toggle list chars (show whitespace)
keymap("n", "<leader>tl", "<cmd>set list!<cr>", { desc = "Toggle list chars", silent = true })

-- Toggle conceallevel
keymap("n", "<leader>tc", function()
  if vim.opt.conceallevel:get() == 0 then
    vim.opt.conceallevel = 2
  else
    vim.opt.conceallevel = 0
  end
end, { desc = "Toggle conceallevel", silent = true })

-- =============================================================================
-- QUICKFIX AND LOCATION LIST
-- =============================================================================

-- Quickfix navigation
keymap("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix", silent = true })
keymap("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix", silent = true })
keymap("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix", silent = true })
keymap("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix", silent = true })

-- =============================================================================
-- TREESITTER (will be enhanced by plugin-specific keymaps)
-- =============================================================================

-- Show syntax group under cursor - moved to avoid conflict with toggle spell
keymap("n", "<leader>tS", "<cmd>TSHighlightCapturesUnderCursor<cr>", { desc = "Show syntax group", silent = true })

-- =============================================================================
-- FILE MANAGEMENT
-- =============================================================================

-- Oil.nvim file explorer
keymap("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory", silent = true })
keymap("n", "<leader>e", "<CMD>Oil<CR>", { desc = "File explorer", silent = true })

-- =============================================================================
-- SNIPPETS
-- =============================================================================

-- LuaSnip snippet navigation (handled by plugin-specific keymaps)
-- Tab/S-Tab for expanding and jumping through snippets

-- =============================================================================
-- TELESCOPE (enhanced by plugin-specific keymaps)  
-- =============================================================================

-- Most Telescope keymaps are defined in the plugin spec, but here are some additional ones
-- that integrate well with the existing workflow

-- Quick access to recent searches
keymap("n", "<leader>f;", "<cmd>Telescope command_history<cr>", { desc = "Command history", silent = true })
keymap("n", "<leader>f:", "<cmd>Telescope search_history<cr>", { desc = "Search history", silent = true })

-- =============================================================================
-- GENERAL UTILITIES
-- =============================================================================

-- Better paste in visual mode (doesn't overwrite register)
keymap("v", "p", '"_dP', { desc = "Paste without overwriting register" })

-- Select all
keymap("n", "<leader>a", "ggVG", { desc = "Select all" })

-- Stay in indent mode
keymap("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Terminal left" })
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Terminal down" })
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Terminal up" })
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Terminal right" })

-- Terminal mode escape
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostic navigation
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
