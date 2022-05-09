local fs = require("config.core.fs")

local cli = "luafmt"
local command = string.format("%s --stdin", fs.executable(cli))

return {
  formatCommand = command,
  formatStdin = true,
}
