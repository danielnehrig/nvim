local M = {}

function M.init()
  require("indent_blankline").setup({
    char = "▏",
    buftype_exclude = { "terminal", "dashboard", "nofile" },
    filetype_exclude = { "dashboard", "terminal", "git", "octo" },
    show_current_context = true,
    use_treesitter = true,
    space_char_blankline = " ",
    show_end_of_line = true,
    show_trailing_blankline_indent = false,
  })
end

return M
