local Func = require("utils")

local definitions = {
    ft = {
        { "FileType", "NvimTree,lspsagafinder,dashboard", "let b:cusorword=0" },
        { "FileType", "dashboard", "set showtabline=0" }, -- disable tabline in dashboard
        { "BufNewFile,BufRead", "*", "set showtabline=2" }, -- renable it
        { "TermOpen", "*", "set nonumber" },
        { "TermOpen", "*", "set norelativenumber" },
        { "TermOpen", "*", "set showtabline=0" }, -- renable it
        { "BufNewFile,BufRead", "*.toml", " setf toml" }, -- set toml filetype
        {
            "FileType",
            "*.toml",
            "lua require('cmp').setup.buffer { sources = { { name = 'crates' } } }",
        },
    },
}

Func.nvim_create_augroups(definitions)
