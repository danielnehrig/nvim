local M = {}

function M.init()
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  parser_config.org = {
    install_info = {
      url = "https://github.com/milisims/tree-sitter-org",
      revision = "main",
      files = { "src/parser.c", "src/scanner.cc" },
    },
    filetype = "org",
  }

  parser_config.tsdoc = {
    install_info = {
      url = "https://github.com/stsewd/tree-sitter-comment",
      revision = "master",
      files = { "src/parser.c", "src/scanner.c" },
    },
    filetype = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
    },
  }

  require("nvim-treesitter.configs").setup({
    -- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    yati = { enable = true },
    autotag = {
      enable = true,
      filetypes = {
        "html",
        "xml",
        "rust",
        "typescriptreact",
        "javascriptreact",
      },
    },
    textsubjects = {
      enable = true,
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
      },
    },
    context_commentstring = {
      enable = true,
      -- This plugin provided an autocommand option
      enable_autocmd = true,
    },
    textobjects = {
      lsp_interop = {
        enable = true,
        border = "none",
        peek_definition_code = {
          ["<leader>]f"] = "@function.outer",
          ["<leader>]F"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["]s"] = "@parameter.inner",
        },
        swap_previous = {
          ["[s"] = "@parameter.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
          ["]a"] = "@parameter.inner",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
          ["]A"] = "@parameter.inner",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
          ["[a"] = "@parameter.inner",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
          ["[A"] = "@parameter.inner",
        },
      },
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },
  })
end

return M
