-- ~/.config/nvim/lua/plugins/specs/lsp.lua
-- LSP configuration focused on Python development

return {
  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
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
        float = {
          border = "rounded",
          source = "always"
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚡",
            [vim.diagnostic.severity.INFO] = "ℹ",
          }
        }
      },
      -- Inlay hints
      inlay_hints = {
        enabled = false, -- Can be noisy for Python
      },
      -- Document highlighting
      document_highlight = {
        enabled = true,
      },
      -- Capabilities from blink.cmp
      capabilities = {},
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

        basedpyright = {
          on_init = function(client)
            local root = client.config.root_dir
            local venv_path = root and (root .. "/boot/.venv/bin/python") or nil
            if venv_path and vim.fn.executable(venv_path) == 1 then
              -- client.config.settings.basedpyright = client.config.settings.basedpyright or {}
              client.config.settings.basedpyright = client.config.settings.basedpyright or {}
              client.config.settings.basedpyright.analysis = client.config.settings.basedpyright.analysis or {}
              client.config.settings.python = {pythonPath = venv_path}
              vim.notify("basedpyright: using .venv python", vim.logs.levels.INFO)
            end
          end,
          settings = {
            typeCheckingMode = "standard",
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workleader",
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
                "**/.venv/**",
                "**/venv/**",
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

        -- Rust: handled by rustaceanvim (see rust.lua)
        zls = {
          settings = {
            zls = {
              enable_inlay_hints = false,
              enable_snippets = true,
              warn_style = true,
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

        -- C/C++ (Arduino, embedded)
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders=true",
          },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        },
      },
    },
    flags = {
      debounce_text_changes = 200, -- Increase debounce time
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")

      -- Setup capabilities with blink.cmp
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities(),
        opts.capabilities or {}
      )

      -- Setup diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = {
          severity = { min = vim.diagnostic.severity.WARN },
        },
        signs = {
          severity = { min = vim.diagnostic.severity.WARN },
        },
      })

      -- Setup each server
      for server, config in pairs(opts.servers) do
        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
        lspconfig[server].setup(config)
      end

      -- =====================================================================
      -- PER-FILETYPE ATTACH HELPERS
      -- =====================================================================
      local function watch_file(path, server)
        if not path or vim.fn.filereadable(path) ~= 1 then return end
        local w = vim.uv.new_fs_event()
        if not w then return end
        w:start(path, {}, vim.schedule_wrap(function(err)
          w:stop()
          if err then return end
          vim.defer_fn(function()
            vim.notify(server .. ": dependency changed, restarting LSP...", vim.log.levels.INFO)
            vim.cmd("LspRestart " .. server)
          end, 2000)
        end))
      end

      local function watch_dir(path, server)
        if not path then return end
        local w = vim.uv.new_fs_event()
        if not w then return end
        w:start(path, {}, vim.schedule_wrap(function(err)
          w:stop()
          if err then return end
          vim.defer_fn(function()
            vim.notify(server .. ": dependency changed, restarting LSP...", vim.log.levels.INFO)
            vim.cmd("LspRestart " .. server)
          end, 2000)
        end))
      end

      local ft_attach = {
        python = function(client)
          local root = client.config.root_dir
          if root then watch_dir(root .. "/.venv", "basedpyright") end
        end,
        go = function(client)
          local root = client.config.root_dir
          if root then watch_file(root .. "/go.sum", "gopls") end
        end,
      }

      -- =====================================================================
      -- LSP ATTACH
      -- =====================================================================
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local bufnr = event.buf
          local ft = vim.bo[bufnr].filetype

          local function map(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          -- Shared keymaps
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
          map("<leader>lk", vim.lsp.buf.signature_help, "Signature Documentation")
          map("[d", vim.diagnostic.get_prev, "Previous [D]iagnostic")
          map("]d", vim.diagnostic.get_next, "Next [D]iagnostic")
          map("<leader>ld", vim.diagnostic.open_float, "[L]SP [D]iagnostic")
          map("<leader>lq", vim.diagnostic.setloclist, "[L]SP Diagnostic [Q]uickfix")
          map("<leader>lR", "<cmd>LspRestart<cr>", "[L]SP [R]estart")

          -- Per-filetype attach logic
          local attach_fn = ft_attach[ft]
          if attach_fn then attach_fn(client) end

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
}
