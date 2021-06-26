require "nvim-treesitter.configs".setup {
    -- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,
        disable = {"javascript", "typescript"} -- list of language that will be disabled
    },
    indent = {
        enable = true,
        disable = {"javascript", "typescript"} -- list of language that will be disabled
    },
    autotag = {
        enable = true
    },
    textobjects = {
        swap = {
            enable = true,
            swap_next = {
                ["<leader>s"] = "@parameter.inner"
            },
            swap_previous = {
                ["<leader>S"] = "@parameter.inner"
            }
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
                ["]a"] = "@parameter.inner"
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
                ["]A"] = "@parameter.inner"
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
                ["[a"] = "@parameter.inner"
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
                ["[A"] = "@parameter.inner"
            }
        },
        select = {
            enable = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                -- Or you can define your own textobjects like this
                ["iF"] = {
                    python = "(function_definition) @function",
                    cpp = "(function_definition) @function",
                    c = "(function_definition) @function",
                    java = "(method_declaration) @function"
                }
            }
        }
    }
}
