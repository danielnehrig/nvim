---@class Blankline
local M = {}

function M.init()
  local present, blank = pcall(require, "indent_blankline")
  if not present then
    return
  end
  blank.setup({
    indentLine_enabled = 0,
    char = "▏",
    filetype_exclude = {
      "help",
      "terminal",
      "dashboard",
      "alpha",
      "lazy",
      "NvimTree",
      "packer",
      "noice",
      "notify",
      "lspinfo",
      "TelescopePrompt",
      "OverseerForm",
      "TelescopeResults",
      "lsp-installer",
      "",
    },
    buftype_exclude = { "terminal", "dashboard", "notify" },
    show_first_indent_level = false,
    show_current_context = true,
    use_treesitter = true,
    space_char_blankline = " ",
    show_end_of_line = true,
    show_trailing_blankline_indent = false,
  })
end

return M
