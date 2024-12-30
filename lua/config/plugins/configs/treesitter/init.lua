local M = {}

function M.init()
  local present, treesitter = pcall(require, "nvim-treesitter.configs")
  if not present then
    vim.notify("treesitter not intalled")
    return
  end

  local ensure_installed = {
      "org",
      "lua",
      "rust",
      "bash",
      "javascript",
      "typescript",
      "jsdoc",
      "html",
      "json",
      "markdown",
      "markdown_inline",
      "python",
    }

  local global = require("config.core.global")
  if not global.is_windows then
    table.insert(ensure_installed, "latex")
  end

  treesitter.setup({
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "org" },
    },
    indent = {
      enable = false,
    },
    yati = { enable = true },
    matchup = {
      enable = true,
      disable = { "c", "ruby" },
    },
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
    sync_install = false,
    ignore_install = {},
    modules = {},
    auto_install = true,
    ensure_installed = ensure_installed,
    textsubjects = {
      enable = true,
      prev_selection = ",",
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
        ["i;"] = "textsubjects-container-inner",
      },
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
  require("ts_context_commentstring").setup({
    enable_autocmd = false,
    languages = {
      typescript = "// %s",
    },
  })
end

return M
