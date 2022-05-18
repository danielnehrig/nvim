local fs = require("config.core.fs")

local formatter = "goimports"
local command = string.format("%s", fs.executable(formatter))

return {
  formatCommand = command,
  formatStdin = true,
}
