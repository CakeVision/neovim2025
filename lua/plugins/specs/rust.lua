-- ~/.config/nvim/lua/plugins/specs/rust.lua
-- Rust development: rustaceanvim + crates.nvim

return {
  -- Rustaceanvim: full-featured Rust plugin
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          executor = require("rustaceanvim.executors").overseer,
        },
        server = {
          on_attach = function(_, bufnr)
            local function map(keys, func, desc)
              vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Rust: " .. desc })
            end

            -- Rust-specific keybinds (buffer-local to .rs files)
            map("<leader>rc", function() vim.cmd.RustLsp("codeAction") end, "Code action")
            map("<leader>re", function() vim.cmd.RustLsp("explainError") end, "Explain error")
            map("<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, "Expand macro")
            map("<leader>rp", function() vim.cmd.RustLsp("parentModule") end, "Parent module")
            map("<leader>rj", function() vim.cmd.RustLsp("joinLines") end, "Join lines")
            map("<leader>ro", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
            map("<leader>rd", function() vim.cmd.RustLsp("renderDiagnostic") end, "Render diagnostic")
            map("<leader>rr", function() vim.cmd.RustLsp("runnables") end, "Runnables")
            map("<leader>ra", function() vim.cmd.RustLsp("debuggables") end, "Debuggables")
            map("K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover actions")

            -- Enable inlay hints for Rust
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

            -- Format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end,
          default_settings = {
            ["rust-analyzer"] = {
              checkOnSave = true,
              check = {
                command = "clippy",
                extraArgs = { "--all-targets" },
              },
              cargo = {
                allFeatures = true,
                buildScripts = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
              },
              inlayHints = {
                lifetimeElisionHints = {
                  enable = "skip_trivial",
                  useParameterNames = true,
                },
              },
              diagnostics = {
                enable = true,
                experimental = {
                  enable = true,
                },
              },
            },
          },
        },
      }
    end,
  },

  -- crates.nvim: Cargo.toml dependency management
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      local crates = require("crates")
      crates.setup({
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      })

      -- Buffer-local keymaps for Cargo.toml
      vim.api.nvim_create_autocmd("BufRead", {
        pattern = "Cargo.toml",
        callback = function(ev)
          local function map(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "Crates: " .. desc })
          end
          map("<leader>cu", crates.update_crate, "Update crate")
          map("<leader>cU", crates.upgrade_crate, "Upgrade crate")
          map("<leader>ci", crates.show_popup, "Show crate info")
          map("<leader>cf", crates.show_features_popup, "Show features")
          map("<leader>cd", crates.show_dependencies_popup, "Show dependencies")
        end,
      })
    end,
  },
}
