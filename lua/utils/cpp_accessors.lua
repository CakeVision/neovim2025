-- ~/.config/nvim/lua/utils/cpp_accessors.lua
-- CLion-style getter/setter generation for C++ class members (treesitter based)
--
-- Usage: cursor on a member (or visually select several), then pick
-- getter / setter / both. Inline accessors go at the end of the class's
-- public section; move them to the .cpp with clangd's "Define outside" if wanted.

local M = {}

-- Types cheap enough to pass/return by value; everything else uses const T&
local by_value = {}
for _, t in ipairs({
  "bool", "char", "wchar_t", "char8_t", "char16_t", "char32_t", "short", "int", "long",
  "float", "double", "signed", "unsigned", "auto", "size_t", "ssize_t", "ptrdiff_t",
  "intptr_t", "uintptr_t", "int8_t", "int16_t", "int32_t", "int64_t",
  "uint8_t", "uint16_t", "uint32_t", "uint64_t",
}) do
  by_value[t] = true
end

local function text(node, bufnr)
  return vim.treesitter.get_node_text(node, bufnr)
end

-- "m_itemCount" / "s_itemCount" / "itemCount_" / "_itemCount" / "mItemCount" -> "itemCount"
local function base_name(name)
  local stripped = name:gsub("^[ms]_", ""):gsub("^_+", ""):gsub("_+$", "")
  if stripped == name and name:match("^m%u") then
    stripped = name:sub(2, 2):lower() .. name:sub(3)
  end
  return stripped ~= "" and stripped or name
end

-- snake_case members get get_x/set_x, everything else getX/setX
local function accessor_name(prefix, base)
  if base:find("_") then
    return prefix .. "_" .. base
  end
  return prefix .. base:sub(1, 1):upper() .. base:sub(2)
end

-- Unwrap pointer/reference declarators down to the field_identifier
local function unwrap_declarator(decl, bufnr)
  local suffix = ""
  local is_ref = false
  while decl:type() ~= "field_identifier" do
    local t = decl:type()
    if t == "pointer_declarator" then
      suffix = suffix .. "*"
      for child in decl:iter_children() do
        if child:type() == "type_qualifier" then
          suffix = suffix .. " " .. text(child, bufnr)
        end
      end
      decl = decl:field("declarator")[1]
    elseif t == "reference_declarator" then
      suffix = suffix .. "&"
      is_ref = true
      decl = decl:named_child(0)
    else
      return nil -- arrays, function pointers, bitfields: not supported
    end
    if not decl then return nil end
  end
  return text(decl, bufnr), suffix, is_ref
end

-- Collect member info from one field_declaration node
local function parse_field(node, bufnr)
  local type_node = node:field("type")[1]
  if not type_node then return {} end

  local quals, is_static = {}, false
  for child in node:iter_children() do
    local t = child:type()
    if t == "storage_class_specifier" and text(child, bufnr) == "static" then
      is_static = true
    elseif t == "type_qualifier" then
      local q = text(child, bufnr)
      if q == "const" or q == "volatile" then table.insert(quals, q) end
    end
  end
  local base_type = text(type_node, bufnr)
  local is_const = vim.tbl_contains(quals, "const")
  local prefix = #quals > 0 and table.concat(quals, " ") .. " " or ""

  local fields = {}
  for _, decl in ipairs(node:field("declarator")) do
    local name, suffix, is_ref = unwrap_declarator(decl, bufnr)
    if name then
      local is_ptr = suffix:find("%*") ~= nil
      table.insert(fields, {
        name = name,
        type = prefix .. base_type .. suffix,
        is_static = is_static,
        cheap = is_ptr or by_value[base_type:gsub("^std::", "")] or false,
        -- const values and references can't be reassigned
        settable = not is_ref and not (is_const and not is_ptr),
        is_ref = is_ref,
      })
    end
  end
  return fields
end

local function find_ancestor(node, type)
  while node and node:type() ~= type do
    node = node:parent()
  end
  return node
end

local function build_accessors(f, kind, existing)
  local lines = {}
  local base = base_name(f.name)
  local static = f.is_static and "static " or ""
  local this_const = f.is_static and "" or " const"

  if kind ~= "setter" then
    local getter = accessor_name("get", base)
    if not existing[getter] then
      local ret
      if f.cheap or f.is_ref then
        ret = f.type
      elseif f.type:match("^const ") then
        ret = f.type .. "&"
      else
        ret = "const " .. f.type .. "&"
      end
      table.insert(lines, string.format("%s%s %s()%s { return %s; }", static, ret, getter, this_const, f.name))
    end
  end

  if kind ~= "getter" and f.settable then
    local setter = accessor_name("set", base)
    if not existing[setter] then
      local param = f.cheap and f.type or ("const " .. f.type .. "&")
      table.insert(lines, string.format("%svoid %s(%s value) { %s = value; }", static, setter, param, f.name))
    end
  end
  return lines
end

-- Where to insert: end of the first public section (or create one)
local function insertion_point(body, is_struct, bufnr)
  local in_public = is_struct
  local public_found = is_struct
  for child in body:iter_children() do
    if child:type() == "access_specifier" then
      local spec = text(child, bufnr)
      if in_public and spec ~= "public" then
        local row = child:start()
        return row, false
      end
      in_public = spec == "public"
      public_found = public_found or in_public
    end
  end
  local close_row = body:end_() -- row of the closing brace
  return close_row, not public_found
end

function M.generate(kind, range)
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr, nil, { error = false })
  if not parser then
    vim.notify("No treesitter parser for this buffer", vim.log.levels.WARN)
    return
  end
  parser:parse()

  -- Find field_declarations under the cursor or inside the visual range
  local first, last = range[1] - 1, range[2] - 1
  local cursor_node = vim.treesitter.get_node({ bufnr = bufnr, pos = { first, vim.fn.indent(first + 1) } })
  local body = find_ancestor(cursor_node, "field_declaration_list")
  if not body then
    vim.notify("Cursor is not inside a class/struct", vim.log.levels.WARN)
    return
  end

  local fields = {}
  for child in body:iter_children() do
    local srow, _, erow = child:range()
    local decl = child:field("declarator")[1]
    if child:type() == "field_declaration" and erow >= first and srow <= last
      and decl and decl:type() ~= "function_declarator" then
      vim.list_extend(fields, parse_field(child, bufnr))
    end
  end
  if #fields == 0 then
    vim.notify("No data members found on the selected lines", vim.log.levels.WARN)
    return
  end

  -- Skip accessors that already exist anywhere in the class body
  local existing = {}
  for name in text(body, bufnr):gmatch("([%w_]+)%s*%(") do
    existing[name] = true
  end

  local new_lines = {}
  for _, f in ipairs(fields) do
    vim.list_extend(new_lines, build_accessors(f, kind, existing))
  end
  if #new_lines == 0 then
    vim.notify("Accessors already exist (or members are not settable)", vim.log.levels.INFO)
    return
  end

  local class_node = body:parent()
  local is_struct = class_node and class_node:type() == "struct_specifier"
  local row, needs_public = insertion_point(body, is_struct, bufnr)

  -- Indent like the members, access specifiers like the class keyword
  local member_indent = string.rep(" ", vim.fn.indent(first + 1))
  local class_indent = string.rep(" ", vim.fn.indent((class_node and class_node:start() or 0) + 1))
  -- Keep one blank line around the generated block
  local out = {}
  local prev = row > 0 and vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
  if not prev:match("^%s*$") then table.insert(out, "") end
  if needs_public then table.insert(out, class_indent .. "public:") end
  for _, l in ipairs(new_lines) do
    table.insert(out, member_indent .. l)
  end
  local at_close = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]:match("^%s*}")
  if not at_close then table.insert(out, "") end

  vim.api.nvim_buf_set_lines(bufnr, row, row, false, out)
  vim.notify(string.format("Generated %d accessor(s)", #new_lines))
end

-- Entry point for the keymap: asks which accessors to generate
function M.prompt()
  local mode = vim.fn.mode()
  local range
  if mode == "v" or mode == "V" or mode == "\22" then
    local a, b = vim.fn.line("v"), vim.fn.line(".")
    range = { math.min(a, b), math.max(a, b) }
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
  else
    local l = vim.fn.line(".")
    range = { l, l }
  end

  local choices = { "Getter and Setter", "Getter", "Setter" }
  local kinds = { "both", "getter", "setter" }
  vim.ui.select(choices, { prompt = "Generate" }, function(_, idx)
    if idx then M.generate(kinds[idx], range) end
  end)
end

return M
