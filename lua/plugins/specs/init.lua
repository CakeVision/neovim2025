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
  require("plugins.specs.colorscheme"),
  require("plugins.specs.completion"),
  require("plugins.specs.refactoring"),
  require("plugins.specs.telescope"),
  require("plugins.specs.whichkey"),
  require("plugins.specs.lsp"),
  require("plugins.specs.codecompanion"),



  -- Add more plugin specs here as you convert them
  -- require("plugins.specs.lsp"),
  -- require("plugins.specs.telescope"),
  -- require("plugins.specs.completion"),

}
