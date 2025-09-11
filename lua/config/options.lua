-- ~/.config/nvim/lua/config/options.lua
-- Neovim options and settings

local opt = vim.opt

-- =============================================================================
-- LINE NUMBERS
-- =============================================================================
opt.number = true
opt.relativenumber = true

-- =============================================================================
-- TABS AND INDENTATION
-- =============================================================================
opt.expandtab = true      -- Use spaces instead of tabs
opt.shiftwidth = 2        -- Size of an indent
opt.tabstop = 2          -- Number of spaces tabs count for
opt.smartindent = true    -- Insert indents automatically

-- =============================================================================
-- UI
-- =============================================================================
opt.termguicolors = true  -- True color support
opt.signcolumn = "yes"    -- Always show the signcolumn
opt.cursorline = true     -- Enable highlighting of the current line
opt.scrolloff = 8         -- Lines of context
opt.sidescrolloff = 8     -- Columns of context
opt.wrap = false          -- Disable line wrap

-- =============================================================================
-- SEARCH
-- =============================================================================
opt.ignorecase = true     -- Ignore case
opt.smartcase = true      -- Don't ignore case with capitals
opt.hlsearch = true       -- Highlight search
opt.incsearch = true      -- Show search results as you type

-- =============================================================================
-- SPLITS
-- =============================================================================
opt.splitbelow = true     -- Put new windows below current
opt.splitright = true     -- Put new windows right of current

-- =============================================================================
-- MISC
-- =============================================================================
opt.updatetime = 50       -- Save swap file and trigger CursorHold
opt.timeoutlen = 300      -- Time to wait for a mapped sequence to complete
opt.backup = false        -- Don't create backup files
opt.swapfile = false      -- Don't create swap files
opt.undofile = true       -- Save undo history
opt.mouse = ""
-- =============================================================================
-- COMPLETION
-- =============================================================================
opt.completeopt = "menuone,noselect,noinsert"

-- =============================================================================
-- CLIPBOARD
-- =============================================================================
opt.clipboard = "unnamedplus"  -- Sync with system clipboard
