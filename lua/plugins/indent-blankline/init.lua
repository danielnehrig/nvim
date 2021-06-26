local g = vim.g
g.indentLine_char_list = {"▏"}
g.indent_blankline_char = "▏"
g.indent_blankline_show_current_context = true
g.indent_blankline_context_patterns = {
    "class",
    "function",
    "method",
    "^if",
    "^while",
    "^for",
    "^object",
    "^table",
    "block",
    "arguments",
    "return",
    "const"
}
g.indent_blankline_show_end_of_line = true
g.indent_blankline_use_treesitter = true
g.indent_blankline_filetype_exclude = {
    "help",
    "dashboard",
    "dashpreview",
    "NvimTree",
    "coc-explorer",
    "startify",
    "vista",
    "sagahover"
}
