-- ~/.config/nvim/snippets/python.lua
-- Custom Python snippets (optional file for additional snippets)
-- This file is loaded by LuaSnip automatically

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- Additional custom Python snippets can go here
-- These will supplement the ones defined in the plugin spec

return {
  -- Django model example
  s("djmodel", fmt([[
from django.db import models

class {}(models.Model):
    {} = models.{}({})
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.{}
    
    class Meta:
        verbose_name = "{}"
        verbose_name_plural = "{}s"
  ]], {
    i(1, "MyModel"),
    i(2, "name"),
    i(3, "CharField"),
    i(4, "max_length=100"),
    i(5, "name"),
    i(6, "My Model"),
    i(7, "My Model")
  })),
  
  -- Flask route
  s("flask", fmt([[
@app.route('{}', methods=[{}])
def {}():
    """{}"""
    {}
  ]], {
    i(1, "/endpoint"),
    i(2, "'GET'"),
    i(3, "endpoint_function"),
    i(4, "Endpoint description"),
    i(5, "return 'Hello World'")
  })),
}


