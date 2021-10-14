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
      { cmd = { "prettier -w", "./node_modules/.bin/eslint --fix" } },
    },
    javascriptreact = {
      { cmd = { "prettier -w", "./node_modules/.bin/eslint --fix" } },
    },
    typescript = {
      { cmd = { "prettier -w", "./node_modules/.bin/eslint --fix" } },
    },
    typescriptreact = {
      { cmd = { "prettier -w", "./node_modules/.bin/eslint --fix" } },
    },
  })
end

return M
