local fs = require("config.core.fs")

local cli = "prettierd"
local command = string.format('%s "${INPUT}"', fs.executable(cli))

return {
  formatCommand = command,
  formatStdin = true,
  env = {
    string.format(
      "PRETTIERD_DEFAULT_CONFIG=%s",
      vim.fn.expand("~/.config/nvim/utils/linter-config/.prettierrc.json")
    ),
  },
}
