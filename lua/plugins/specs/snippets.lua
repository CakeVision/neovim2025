-- ~/.config/nvim/lua/plugins/specs/snippets.lua
-- LuaSnip: Snippet engine with custom Python snippets

return {
  -- LuaSnip snippet engine
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets", -- Community snippets
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = {
      {
        "<Tab>",
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end,
        mode = { "i", "s" },
        silent = true,
      },
      {
        "<S-Tab>",
        function()
          local ls = require("luasnip")
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end,
        mode = { "i", "s" },
        silent = true,
      },
    },
    config = function(_, opts)
      local ls = require("luasnip")
      
      -- Setup LuaSnip
      ls.setup(opts)
      
      -- Load VSCode-style snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Load custom snippets
      require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets"})
      
      -- Snippet helper functions
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local fmt = require("luasnip.extras.fmt").fmt
      local rep = require("luasnip.extras").rep
      
      -- Python snippets
      ls.add_snippets("python", {
        -- Main function
        s("main", fmt([[
def main():
    {}

if __name__ == "__main__":
    main()
        ]], { i(1) })),
        
        -- Class with init
        s("class", fmt([[
class {}:
    def __init__(self{}):
        {}
        ]], { i(1, "ClassName"), i(2), i(3) })),
        
        -- Function with docstring
        s("def", fmt([[
def {}({}):
    """{}"""
    {}
        ]], { i(1, "function_name"), i(2), i(3, "Brief description"), i(4, "pass") })),
        
        -- Async function
        s("adef", fmt([[
async def {}({}):
    """{}"""
    {}
        ]], { i(1, "async_function"), i(2), i(3, "Brief description"), i(4, "pass") })),
        
        -- Try/except block
        s("try", fmt([[
try:
    {}
except {} as e:
    {}
        ]], { i(1), i(2, "Exception"), i(3, "pass") })),
        
        -- Try/except/else/finally
        s("tryf", fmt([[
try:
    {}
except {} as e:
    {}
else:
    {}
finally:
    {}
        ]], { i(1), i(2, "Exception"), i(3, "pass"), i(4, "pass"), i(5, "pass") })),
        
        -- Context manager
        s("with", fmt([[
with {} as {}:
    {}
        ]], { i(1), i(2, "f"), i(3) })),
        
        -- List comprehension
        s("lc", fmt("[ {} for {} in {} ]", { i(1, "x"), i(2, "x"), i(3, "iterable") })),
        
        -- Dict comprehension
        s("dc", fmt("{{ {}: {} for {} in {} }}", { i(1, "k"), i(2, "v"), i(3, "item"), i(4, "iterable") })),
        
        -- Set comprehension
        s("sc", fmt("{{ {} for {} in {} }}", { i(1, "x"), i(2, "x"), i(3, "iterable") })),
        
        -- Generator expression
        s("gen", fmt("({} for {} in {})", { i(1, "x"), i(2, "x"), i(3, "iterable") })),
        
        -- Pytest test
        s("test", fmt([[
def test_{}():
    """Test {}."""
    {}
        ]], { i(1, "name"), rep(1), i(2, "assert True") })),
        
        -- Pytest parametrize
        s("param", fmt([[
@pytest.mark.parametrize("{}", [
    {},
])
def test_{}({}):
    """Test {} with parameters."""
    {}
        ]], { i(1, "param"), i(2, "values"), i(3, "name"), rep(1), rep(3), i(4, "assert True") })),
        
        -- Dataclass
        s("dataclass", fmt([[
from dataclasses import dataclass

@dataclass
class {}:
    {}: {}
        ]], { i(1, "ClassName"), i(2, "field"), i(3, "type") })),
        
        -- Pydantic model
        s("pydantic", fmt([[
from pydantic import BaseModel

class {}(BaseModel):
    {}: {}
        ]], { i(1, "ModelName"), i(2, "field"), i(3, "str") })),
        
        -- FastAPI route
        s("fastapi", fmt([[
@app.{}("{}")
async def {}({}):
    """{}"""
    {}
        ]], { 
          c(1, {t("get"), t("post"), t("put"), t("delete")}),
          i(2, "/endpoint"),
          i(3, "endpoint_function"),
          i(4),
          i(5, "Endpoint description"),
          i(6, "return {}")
        })),
        
        -- Logger setup
        s("logger", fmt([[
import logging

logger = logging.getLogger(__name__)
        ]], {})),
        
        -- Enum
        s("enum", fmt([[
from enum import Enum

class {}(Enum):
    {} = "{}"
        ]], { i(1, "MyEnum"), i(2, "VALUE"), i(3, "value") })),
        
        -- Property
        s("property", fmt([[
@property
def {}(self):
    """{}"""
    return self._{}

@{}.setter
def {}(self, value):
    """Set {}."""
    self._{} = value
        ]], {
          i(1, "property_name"),
          i(2, "Property description"),
          rep(1),
          rep(1),
          rep(1),
          rep(1),
          rep(1)
        })),
        
        -- Type hints
        s("typing", fmt([[
from typing import {}
        ]], { i(1, "List, Dict, Optional, Union") })),
        
        -- If name main
        s("ifmain", fmt([[
if __name__ == "__main__":
    {}
        ]], { i(1, "main()") })),
        
        -- Print debug
        s("pdb", fmt([[
import pdb; pdb.set_trace()  # TODO: Remove debug
        ]], {})),
        
        -- Breakpoint (Python 3.7+)
        s("bp", fmt([[
breakpoint()  # TODO: Remove debug
        ]], {})),
      })

      -- Go snippets
      ls.add_snippets("go", {
        -- Main function
        s("main", fmt([[
package main

import "fmt"

func main() {{
	{}
}}
        ]], { i(1) })),
        
        -- Function
        s("func", fmt([[
func {}({}) {} {{
	{}
}}
        ]], { i(1, "name"), i(2), i(3), i(4) })),
        
        -- Method
        s("meth", fmt([[
func ({} {}) {}({}) {} {{
	{}
}}
        ]], { i(1, "r"), i(2, "Receiver"), i(3, "method"), i(4), i(5), i(6) })),
        
        -- If error
        s("iferr", fmt([[
if err != nil {{
	{}
}}
        ]], { i(1, "return err") })),
        
        -- For loop
        s("for", fmt([[
for {} {{
	{}
}}
        ]], { i(1), i(2) })),
        
        -- For range
        s("forr", fmt([[
for {}, {} := range {} {{
	{}
}}
        ]], { i(1, "i"), i(2, "v"), i(3, "slice"), i(4) })),
        
        -- Struct
        s("struct", fmt([[
type {} struct {{
	{}
}}
        ]], { i(1, "Name"), i(2) })),
        
        -- Interface
        s("interface", fmt([[
type {} interface {{
	{}
}}
        ]], { i(1, "Name"), i(2) })),
        
        -- Test function
        s("test", fmt([[
func Test{}(t *testing.T) {{
	{}
}}
        ]], { i(1, "Name"), i(2) })),
      })
    end,
  },
}
