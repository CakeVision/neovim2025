-- ~/.config/nvim/lua/plugins/specs/cpp.lua
-- C/C++ tooling: header/source switching and code generation
-- <leader>c is the per-language prefix; these binds only exist in c/cpp buffers

-- Ask clangd for the matching header/source and open it
local function switch_source_header()
  local bufnr = vim.api.nvim_get_current_buf()
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
  if not client then
    vim.notify("clangd is not attached to this buffer", vim.log.levels.WARN)
    return
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  client:request("textDocument/switchSourceHeader", params, function(err, result)
    if err then
      vim.notify("switchSourceHeader: " .. err.message, vim.log.levels.ERROR)
    elseif not result then
      vim.notify("No matching header/source file found", vim.log.levels.INFO)
    else
      vim.cmd.edit(vim.fn.fnameescape(vim.uri_to_fname(result)))
    end
  end, bufnr)
end

return {
  {
    "Badhi/nvim-treesitter-cpp-tools",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "c", "cpp" },
    opts = function()
      return {
        -- The preview is virtual text that follows the cursor: move with j/k
        -- to choose where it lands, then accept or discard
        preview = {
          quit = "<Esc>",
          accept = "<CR>",
        },
        header_extension = "h",
        source_extension = "cpp",
        custom_define_class_function_commands = {
          -- Like TSCppDefineClassFunc, but appends the definitions straight into the .cpp
          TSCppImplWrite = {
            output_handle = require("nt-cpp-tools.output_handlers").get_add_to_cpp(),
          },
        },
      }
    end,
    config = function(_, opts)
      require("nt-cpp-tools").setup(opts)

      -- The preview maps accept/quit globally and *deletes* them when done, which
      -- would wipe existing global maps (e.g. <CR> incremental selection).
      -- Save them before the preview starts and put them back afterwards.
      local pp = require("nt-cpp-tools.preview_printer")
      local saved = {}
      local function restore()
        for _, m in ipairs(saved) do
          vim.fn.mapset("n", false, m)
        end
        saved = {}
      end
      local start = pp.start_preview
      pp.start_preview = function(...)
        saved = {}
        for _, key in ipairs({ opts.preview.accept, opts.preview.quit }) do
          local m = vim.fn.maparg(key, "n", false, true)
          if not vim.tbl_isempty(m) and m.buffer == 0 then table.insert(saved, m) end
        end
        return start(...)
      end
      for _, fn in ipairs({ "flush_and_end_preview", "accept_and_end_preview" }) do
        local orig = pp[fn]
        pp[fn] = function(...)
          orig(...)
          restore()
        end
      end
    end,
    keys = {
      { "<leader>cg", function() require("utils.cpp_accessors").prompt() end, mode = { "n", "x" }, ft = { "cpp" }, desc = "C++: Generate getter/setter" },
      { "<leader>ch", switch_source_header, ft = { "c", "cpp" }, desc = "C++: Switch header/source" },
      -- Visual mode: only the selected declarations; normal mode: declaration under cursor / whole class
      { "<leader>cd", ":TSCppDefineClassFunc<cr>", mode = { "n", "x" }, ft = { "c", "cpp" }, desc = "C++: Define functions (preview)" },
      { "<leader>cD", ":TSCppImplWrite<cr>", mode = { "n", "x" }, ft = { "c", "cpp" }, desc = "C++: Define functions into .cpp" },
      { "<leader>cv", ":TSCppMakeConcreteClass<cr>", mode = { "n", "x" }, ft = { "c", "cpp" }, desc = "C++: Implement pure virtuals" },
      { "<leader>c3", ":TSCppRuleOf3<cr>", mode = { "n", "x" }, ft = { "c", "cpp" }, desc = "C++: Rule of 3" },
      { "<leader>c5", ":TSCppRuleOf5<cr>", mode = { "n", "x" }, ft = { "c", "cpp" }, desc = "C++: Rule of 5" },
    },
  },
}
