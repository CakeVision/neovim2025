-- ~/.config/nvim/lua/plugins/specs/lsp.lua
-- LSP configuration focused on Python development

return {
  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      -- Global LSP settings
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      -- Inlay hints
      inlay_hints = {
        enabled = false, -- Can be noisy for Python
      },
      -- Document highlighting
      document_highlight = {
        enabled = true,
      },
      -- Capabilities from nvim-cmp
      capabilities = {},
      -- Format on save
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP server settings
      servers = {
        -- Lua (for Neovim config)
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                },
              },
            },
          },
        },

        --pylsp = {
        --  plugins = {
        --    -- Disable conflicting formatters/linters
        --    autopep8 = { enabled = false },
        --    flake8 = { enabled = false },
        --    mccabe = { enabled = false },
        --    pycodestyle = { enabled = false },
        --    pydocstyle = { enabled = false },
        --    pylint = { enabled = false },
        --    yapf = { enabled = false },

        --    -- Core Jedi features
        --    jedi_completion = {
        --      enabled = true,
        --      include_params = true,
        --      include_class_objects = true,
        --      include_function_objects = true,
        --    },
        --    jedi_hover = { enabled = true },
        --    jedi_references = { enabled = true },
        --    jedi_signature_help = { enabled = true },
        --    jedi_symbols = {
        --      enabled = true,
        --      all_scopes = true,
        --    },
        --    jedi_definition = {
        --      enabled = true,
        --      follow_imports = true,
        --      follow_builtin_imports = true,
        --    },

        --    -- Import sorting
        --    isort = {
        --      enabled = true,
        --      profile = "black",
        --    },

        --    -- Type checking
        --    mypy = {
        --      enabled = true,
        --      live_mode = false,
        --      strict = false,
        --    },

        --    -- Rope features (might be causing conflicts)
        --    rope_completion = { enabled = false }, -- Try disabling this
        --    rope_autoimport = { enabled = false }, -- And this
        --  },
        --},

        basedpyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                indexing = true,
                packageIndexDepths = {
                  {
                    name = "",
                    depth = 2,
                    includeAllSymbols = true,
                  },
                },
                 exclude = {
                  "**/logs/**",
                  "**/script_grave/**", 
                  "**/__pycache__/**",
                  "**/data/eml/**",
                  "**/tests/**/processed_image*",
                  "**/tests/**/*.jpg",
                  "**/tests/**/*.png",
                  "**/tests/**/*.jpeg",
                },
                 diagnosticSeverityOverrides = {
                  reportUnusedImport = "warning",
                  reportUnusedVariable = "warning",
                  reportGeneralTypeIssues = "warning",
                  reportOptionalMemberAccess = "information",
                },
              },
            },
          },
        },

        ruff = {
          init_options = {
            settings = {
               args = {
                  "--extend-select", "I",    -- Import sorting
                  "--extend-select", "UP",   -- pyupgrade
                  "--extend-select", "B",    -- flake8-bugbear  
                  "--extend-select", "C4",   -- flake8-comprehensions
                  "--extend-select", "SIM",  -- flake8-simplify
                  "--line-length", "88",
                  "--exclude", "logs,script_grave,data/eml,__pycache__",
                },
                organizeImports = false,
                fixAll = false,
                codeAction = {
                  fixViolation = { enable = true },
                  organizeImports = { enable = true },
                },
            },
          },
        },
        -- Go (keeping it simple)
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              analyses = {
                unusedparams = true,
                unusedvariable = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
            },
          },
        },

        -- Rust (basic setup)
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
              cargo = {
                allTargets = true,
              },
            },
          },
        },

        -- JSON
        jsonls = {},

        -- YAML
        yamlls = {},

        -- Markdown
        marksman = {},

        -- Bash
        bashls = {},
      },
    },
    handlers = {
      ["textDocument/definition"] = function(err, result, ctx, config)
        if not result or vim.tbl_isempty(result) then
          return
        end
        
        -- If single result, go directly to buffer
        if #result == 1 then
          vim.lsp.util.jump_to_location(result[1], 'utf-8')
        else
          -- Multiple results, use telescope or quickfix
          vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
        end
      end,
    },
    flags = {
      debounce_text_changes = 200, -- Increase debounce time
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- Setup capabilities
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities(),
        opts.capabilities or {}
      )

      -- Setup diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- Setup each server
      for server, config in pairs(opts.servers) do
        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
        lspconfig[server].setup(config)
      end

      -- LSP attach function
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local bufnr = event.buf

          -- Helper function for mappings
          local function map(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          -- LSP keymaps
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
          map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "[L]SP Document [S]ymbols")
          map("<leader>lS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[L]SP Workspace [S]ymbols")
          map("<leader>lr", vim.lsp.buf.rename, "[L]SP [R]ename")
          map("<leader>la", vim.lsp.buf.code_action, "[L]SP Code [A]ction")
          map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "[L]SP [F]ormat")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

          -- Diagnostic keymaps
          map("[d", vim.diagnostic.goto_prev, "Previous [D]iagnostic")
          map("]d", vim.diagnostic.goto_next, "Next [D]iagnostic")
          map("<leader>ld", vim.diagnostic.open_float, "[L]SP [D]iagnostic")
          map("<leader>lq", vim.diagnostic.setloclist, "[L]SP Diagnostic [Q]uickfix")

          -- Python-specific keymaps
          --if client.name == "pyright" then
          --  map("<leader>lo", function()
          --    vim.lsp.buf.execute_command({
          --      command = "pyright.organizeimports",
          --      arguments = { vim.uri_from_bufnr(0) },
          --    })
          --  end, "[L]SP [O]rganize Imports")
          --end

          -- Rust-specific keymaps
          if client.name == "rust_analyzer" then
            map("<leader>rr", function()
              vim.cmd.RustLsp("reloadWorkspace")
            end, "[R]ust [R]eload Workspace")
          end

          -- Document highlighting
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = bufnr,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = bufnr,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end
        end,
      })

      -- Diagnostic signs
      local signs = { Error = "✘", Warn = "▲", Hint = "⚡", Info = "ℹ" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Auto-format on save for Python files
      --vim.api.nvim_create_autocmd("BufWritePre", {
      --  pattern = "*.py",
      --  callback = function()
      --    vim.lsp.buf.format({ async = false })
      --  end,
      --})

      -- Auto-format on save for Go files
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
      vim.cmd([[
        iabbrev nolsp # type: ignore  # pyright: ignore  # noqa
        iabbrev noall # type: ignore  # pyright: ignore  # noqa  
        iabbrev nopy # pyright: ignore
      ]])
    end,
  },

  -- Better Rust support (optional but recommended)
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          -- Disable semantic tokens for better performance
          client.server_capabilities.semanticTokensProvider = nil
        end,
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
}
