local fs = require("config.core.fs")

local formatter = "black"
local command = string.format("%s --no-color -q -", fs.executable(formatter))

return {
  formatCommand = command,
  formatStdin = true,
}
