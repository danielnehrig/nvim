local fs = require("config.core.fs")

local formatter = "dprint"
local command = string.format(
  "%s fmt --config ~/.config/nvim/dprint.json --stdin ${FILEEXT}",
  fs.executable(formatter)
)

return {
  formatCommand = command,
  formatStdin = true,
}
