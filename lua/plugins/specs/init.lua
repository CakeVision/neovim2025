-- ~/.config/nvim/lua/plugins/specs/init.lua
-- Plugin specifications - this file loads all plugin specs

return {
  -- Load all plugin spec files
  require("plugins.specs.mason"),
  require("plugins.specs.treesitter"),
  require("plugins.specs.oil"),
  require("plugins.specs.polyglot"),
  require("plugins.specs.snippets"),
  require("plugins.specs.mini"),
  require("plugins.specs.refactoring"),
  require("plugins.specs.lazygit"),
  -- require("plugins.specs.colorscheme"),
  require("plugins.specs.theme_kanagawa"),
  -- require("plugins.specs.codeium"),
  require("plugins.specs.blink_completion"),
  -- require("plugins.specs.refactoring"),
  require("plugins.specs.telescope"),
  require("plugins.specs.undotree"),
  require("plugins.specs.whichkey"),
  require("plugins.specs.lsp"),
  require("plugins.specs.zotcite"),
  require("plugins.specs.debug"),
  require("plugins.specs.overseer_runner"),
  require("plugins.specs.rust"),
  
  -- require("plugins.specs.codecompanion"),
  -- require("plugins.specs.avante"),


  -- Add more plugin specs here as you convert them
  -- require("plugins.specs.lsp"),
  -- require("plugins.specs.telescope"),
  -- require("plugins.specs.completion"),

}
