local fs = require("config.core.fs")

local formatter = "gofmt"
local command = string.format("%s", fs.executable(formatter))

return {
  formatCommand = command,
  formatStdin = true,
}
