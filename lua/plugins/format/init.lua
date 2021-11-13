local M = {}

function M.init()
  require("format").setup({
    ["*"] = {
      { cmd = { "sed -i 's/[ \t]*$//'" } }, -- remove trailing whitespace
    },
    go = {
      {
        cmd = { "gofmt -w", "goimports -w" },
        tempfile_postfix = ".tmp",
      },
    },
    javascript = {
      {
        cmd = {
          "prettier_d_slim --stdin",
          "eslint_d --fix",
        },
      },
    },
    javascriptreact = {
      {
        cmd = {
          "prettier_d_slim --stdin",
          "eslint_d --fix",
        },
      },
    },
    typescript = {
      {
        cmd = {
          "prettier_d_slim --stdin",
          "eslint_d --fix",
        },
      },
    },
    typescriptreact = {
      {
        cmd = {
          "prettier_d_slim --stdin",
          "eslint_d --fix",
        },
      },
    },
  })
end

return M
