local fs = require("config.core.fs")

local cli = "prettierd"
local command = string.format("%s ${INPUT}", fs.executable(cli))

return {
  formatCommand = command,
  formatStdin = true,
}
