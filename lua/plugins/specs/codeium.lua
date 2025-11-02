return {
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("codeium").setup({
      enable_chat = false,  -- Keep it minimal, disable chat
      virtual_text = {
        enabled = true,
        manual = false,  -- Auto-trigger suggestions
        idle_delay = 75,  -- Short delay feels responsive
        virtual_text_priority = 65535,
        map_keys = true,
        key_bindings = {
          accept = "<Tab>",  -- Tab to accept
          accept_word = false,
          accept_line = false,
          next = "<M-]>",  -- Alt+] for next suggestion
          prev = "<M-[>",  -- Alt+[ for previous
          clear = "<C-]>",  -- Ctrl+] to dismiss
        }
      }
    })
  end
}
