local g = vim.g
g.indentLine_char_list = {"▏"}
g.indent_blankline_char = "▏"
g.indent_blankline_show_current_context = true
g.indent_blankline_context_patterns = {
    "class",
    "function",
    "method",
    "block",
    "list_literal",
    "selector",
    "^if",
    "^table",
    "if_statement",
    "while",
    "for"
}
g.indent_blankline_show_end_of_line = true
g.indent_blankline_use_treesitter = true
g.indent_blankline_filetype_exclude = {
    "startify",
    "dashboard",
    "dotooagenda",
    "log",
    "fugitive",
    "gitcommit",
    "packer",
    "vimwiki",
    "markdown",
    "json",
    "txt",
    "vista",
    "help",
    "todoist",
    "NvimTree",
    "peekaboo",
    "git",
    "TelescopePrompt",
    "undotree",
    "flutterToolsOutline",
    "" -- for all buffers without a file type
}
vim.g.indent_blankline_buftype_exclude = {"terminal", "nofile"}
