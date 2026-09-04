# Neovim Configuration

Leader: `<Space>` | Local leader: `,`

## Plugins

| Plugin | Purpose |
|--------|---------|
| lazy.nvim | Plugin manager |
| mason.nvim | LSP/formatter/linter installer |
| nvim-lspconfig | LSP configuration |
| blink.cmp | Completion |
| telescope.nvim | Fuzzy finder |
| treesitter | Syntax highlighting & text objects |
| oil.nvim | File explorer |
| mini.nvim | Surround, pairs, bufremove, statusline |
| no-neck-pain.nvim | Center buffer for ergonomic editing |
| undotree | Undo history |
| lazygit.nvim | LazyGit integration |
| vim-fugitive | Git commands |
| overseer.nvim | Task runner |
| nvim-dap | Debug adapter protocol |
| refactoring.nvim | Code refactoring |
| rustaceanvim | Rust tooling |
| crates.nvim | Cargo.toml management |
| comment.nvim | Comment toggling |
| which-key.nvim | Keybinding discovery |
| LuaSnip | Snippet engine |
| kanagawa.nvim | Color scheme |
| claude-code.nvim | Claude Code integration |
| vim-polyglot | Filetype & syntax |
| render-markdown.nvim | Markdown rendering |
| zotcite | Zotero citations |
| wakatime | Coding time tracking |

## Keybinding Reference

### General

| Binding | Mode | Action |
|---------|------|--------|
| `jk` | Insert | Escape |
| `<C-s>` | N/I/V | Save file |
| `<C-q>` | Normal | Write and quit all |
| `<leader>y` | Normal | Copy to system clipboard |
| `<leader>h` | Normal | Clear search highlight |
| `<leader>a` | Normal | Select all |
| `p` | Visual | Paste without overwriting register |

### Window Navigation

| Binding | Mode | Action |
|---------|------|--------|
| `<C-h/j/k/l>` | Normal | Navigate windows |
| `<C-Up/Down/Left/Right>` | Normal | Resize windows |
| `<leader>wv` | Normal | Split vertical |
| `<leader>ws` | Normal | Split horizontal |
| `<leader>wc` | Normal | Close window |
| `<leader>wo` | Normal | Close other windows |
| `<leader>w=` | Normal | Equalize windows |
| `<leader>wm` | Normal | Maximize window |

### Buffers (`<leader>b`)

| Binding | Mode | Action |
|---------|------|--------|
| `[b` / `]b` | Normal | Previous/next buffer |
| `<leader>bn` | Normal | Next buffer |
| `<leader>bp` | Normal | Previous buffer |
| `<leader>ba` | Normal | Delete all other buffers |
| `<leader>bd` | Normal | Delete buffer (mini) |
| `<leader>bD` | Normal | Delete buffer force (mini) |

### Find / Telescope (`<leader>f`)

| Binding | Mode | Action |
|---------|------|--------|
| `<C-p>` | Normal | Find files |
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Find git files |
| `<leader>fr` | Normal | Recent files |
| `<leader>fb` | Normal | Find buffers |
| `<leader>/` | Normal | Live grep |
| `<leader>*` | Normal | Grep word under cursor |
| `<leader>fc` | Normal | Search current buffer |
| `<leader>fh` | Normal | Search help |
| `<leader>fm` | Normal | Search man pages / mini.files (current dir) |
| `<leader>fM` | Normal | mini.files (cwd) |
| `<leader>fk` | Normal | Search keymaps |
| `<leader>fC` | Normal | Search commands |
| `<leader>f;` | Normal | Command history |
| `<leader>f:` | Normal | Search history |
| `<leader>fd` | Normal | Find directories |
| `<leader>ft` | Normal | Search TODOs |
| `<leader>fT` | Normal | Buffer TODOs |
| `<leader>fu` | Normal | Undo tree (telescope) |
| `<leader><leader>` | Normal | Resume last search |

### LSP (`<leader>l` and `g`)

| Binding | Mode | Action |
|---------|------|--------|
| `gd` | Normal | Goto definition |
| `gr` | Normal | Goto references |
| `gI` | Normal | Goto implementation |
| `gt` | Normal | Goto type definition |
| `K` | Normal | Hover documentation |
| `<leader>ls` | Normal | Document symbols |
| `<leader>lS` | Normal | Workspace symbols |
| `<leader>lr` | Normal | Rename |
| `<leader>la` | Normal | Code action |
| `<leader>lf` | Normal | Format |
| `<leader>lk` | Normal | Signature help |
| `<leader>ld` | Normal | Diagnostic float / Diagnostics list |
| `<leader>lq` | Normal | Diagnostic quickfix |

### Git (`<leader>g`)

| Binding | Mode | Action |
|---------|------|--------|
| `<leader>gg` | Normal | LazyGit |
| `<leader>gc` | Normal | LazyGit current file / Git commits |
| `<leader>gC` | Normal | Git commit (fugitive) |
| `<leader>gA` | Normal | Git add all (fugitive) |
| `<leader>gb` | Normal | Git branches |
| `<leader>gB` | Normal | Git checkout branch |
| `<leader>gs` | Normal | Git status |

### Debug (`<leader>d`)

| Binding | Mode | Action |
|---------|------|--------|
| `<leader>db` | Normal | Toggle breakpoint |
| `<leader>dc` | Normal | Continue |
| `<leader>di` | Normal | Step into |
| `<leader>do` | Normal | Step over |
| `<leader>dr` | Normal | REPL open |

### Refactoring (`<leader>r`)

| Binding | Mode | Action |
|---------|------|--------|
| `<leader>re` | Visual | Extract function |
| `<leader>rf` | Visual | Extract function to file |
| `<leader>rv` | Visual | Extract variable |
| `<leader>ri` | N/V | Inline variable |
| `<leader>rb` | Visual | Extract block |
| `<leader>rbf` | Visual | Extract block to file |
| `<leader>rr` | N/V | Refactoring menu |
| `<leader>rp` | Normal | Debug print |
| `<leader>rdv` | Visual | Debug print variable |
| `<leader>rdc` | Normal | Debug cleanup |

### Rust (`<leader>r` in .rs files)

| Binding | Mode | Action |
|---------|------|--------|
| `<leader>rc` | Normal | Code action |
| `<leader>re` | Normal | Explain error |
| `<leader>rm` | Normal | Expand macro |
| `<leader>rp` | Normal | Parent module |
| `<leader>rj` | Normal | Join lines |
| `<leader>ro` | Normal | Open Cargo.toml |
| `<leader>rd` | Normal | Render diagnostic |
| `<leader>rr` | Normal | Runnables |
| `<leader>ra` | Normal | Debuggables |

### Crates (`<leader>c` in Cargo.toml)

| Binding | Mode | Action |
|---------|------|--------|
| `<leader>cu` | Normal | Update crate |
| `<leader>cU` | Normal | Upgrade crate |
| `<leader>ci` | Normal | Show crate info |
| `<leader>cf` | Normal | Show features |
| `<leader>cd` | Normal | Show dependencies |

### Overseer / Tasks (`<leader>o`)

| Binding | Mode | Action |
|---------|------|--------|
| `<leader>or` | Normal | Run task |
| `<leader>ot` | Normal | Toggle task list |
| `<leader>ol` | Normal | Restart last task |
| `<leader>oc` | Normal | Run shell command |
| `<leader>oh` | Normal | Run from history |
| `<leader>rs` | Normal | Run task (alt) |
| `<leader>rt` | Normal | Toggle task list (alt) |
| `<leader>rl` | Normal | Restart last task (alt) |

### Toggle (`<leader>t`)

| Binding | Mode | Action |
|---------|------|--------|
| `<leader>tN` | Normal | Toggle relative line numbers |
| `<leader>tw` | Normal | Toggle word wrap |
| `<leader>ts` | Normal | Toggle spell check |
| `<leader>tl` | Normal | Toggle list chars |
| `<leader>tc` | Normal | Toggle conceallevel / treesitter context |
| `<leader>tS` | Normal | Show syntax group |
| `<leader>tn` | Normal | Swap parameter with next |
| `<leader>tp` | Normal | Swap parameter with previous |
| `<leader>tz` | Normal | Toggle No Neck Pain |

### Claude Code (`<leader>a`)

| Binding | Mode | Action |
|---------|------|--------|
| `<leader>ac` | Normal | Toggle Claude |
| `<leader>af` | Normal | Focus Claude |
| `<leader>ar` | Normal | Resume Claude |
| `<leader>aC` | Normal | Continue Claude |
| `<leader>am` | Normal | Select model |
| `<leader>ab` | Normal | Add current buffer |
| `<leader>as` | V/Oil | Send to Claude / Add file |
| `<leader>aa` | Normal | Accept diff |
| `<leader>ad` | Normal | Deny diff |

### File Explorer (Oil)

| Binding | Mode | Action |
|---------|------|--------|
| `-` | Normal | Open parent directory |
| `<leader>e` | Normal | Open Oil |

### Text Objects (Treesitter)

| Object | Scope |
|--------|-------|
| `af` / `if` | Function |
| `ac` / `ic` | Class |
| `aa` / `ia` | Parameter |
| `ab` / `ib` | Block |

### Text Object Navigation

| Binding | Action |
|---------|--------|
| `]m` / `[m` | Next/prev function start |
| `]]` / `[[` | Next/prev class start |
| `]M` / `[M` | Next/prev function end |
| `][` / `[]` | Next/prev class end |
| `]a` / `[a` | Next/prev parameter |

### Commenting

| Binding | Mode | Action |
|---------|------|--------|
| `<C-/>` | N/V/I | Toggle comment |

### Completion (blink.cmp)

| Binding | Mode | Action |
|---------|------|--------|
| `<C-Space>` | Insert | Show completion |
| `<CR>` | Insert | Accept |
| `<Tab>` / `<S-Tab>` | Insert | Next/prev item or snippet jump |
| `<C-b>` / `<C-f>` | Insert | Scroll docs |
| `<C-e>` | Insert | Cancel |

### Quickfix (`<leader>q`)

| Binding | Mode | Action |
|---------|------|--------|
| `[q` / `]q` | Normal | Previous/next quickfix |
| `<leader>qo` | Normal | Open quickfix |
| `<leader>qc` | Normal | Close quickfix |
| `<leader>qd` | Normal | Directories to quickfix |
| `<leader>qt` | Normal | TODOs to quickfix |

### Other

| Binding | Mode | Action |
|---------|------|--------|
| `<leader>u` | Normal | Toggle Undotree |
| `<leader>?` | Normal | Show buffer keymaps (which-key) |
| `<leader>cm` | Normal | Open Mason |
| `<` / `>` | Visual | Indent and reselect |
| `<A-j>` / `<A-k>` | N/V | Move line(s) down/up |

## Leader Key Namespace Overview

| Prefix | Domain |
|--------|--------|
| `<leader>a` | Claude Code |
| `<leader>b` | Buffers |
| `<leader>c` | Code/Crates |
| `<leader>d` | Debug |
| `<leader>e` | File explorer |
| `<leader>f` | Find (Telescope) |
| `<leader>g` | Git |
| `<leader>h` | Clear highlight |
| `<leader>l` | LSP |
| `<leader>o` | Overseer |
| `<leader>q` | Quickfix |
| `<leader>r` | Refactor/Rust/Run |
| `<leader>t` | Toggle/Treesitter |
| `<leader>u` | Undotree |
| `<leader>w` | Windows |
| `<leader>y` | Yank to clipboard |
| `<leader>?` | Which-key |
| `<leader>/` | Live grep |
| `<leader>*` | Grep word |
| `<leader><leader>` | Resume search |

### Free leader prefixes

`<leader>i`, `<leader>j`, `<leader>k`, `<leader>m`, `<leader>n`, `<leader>p` (partial), `<leader>s`, `<leader>v`, `<leader>x`, `<leader>z`
