local fs = require("config.core.fs")

local cli = "pg_format"
local command = string.format("%s --", fs.executable(cli))

return {
  formatCommand = command,
  formatStdin = true,
}
