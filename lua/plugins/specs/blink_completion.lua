-- ~/.config/nvim/lua/plugins/specs/completion.lua
-- Completion system with blink.cmp

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<C-b>"] = { "scroll_documentation_up" },
        ["<C-f>"] = { "scroll_documentation_down" },
        ["<C-Space>"] = { "show" },
        ["<C-e>"] = { "cancel" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["."] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.accept({text_edit = false})
              vim.schedule(function()
                vim.api.nvim_input(".")
              end)
              return true
            end
          end,
          "fallback",
        },
      },

      completion = {
        documentation = {
          auto_show = true,
          window = { border = "rounded" },
        },
        menu = {
          border = "rounded",
          draw = {
            columns = {
              { "kind_icon",  gap = 1 },
              { "label",      "label_description", gap = 1 },
              { "source_name" },
            },
          },
        },
        ghost_text = { enabled = true },
      },

      snippets = { preset = "luasnip" },

      sources = {
        default = { "lsp", "snippets", "buffer", "path" },
      },

      cmdline = {
        enabled = true,
      },
    },
  },
}
