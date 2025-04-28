local fs = require("config.core.fs")

local formatter = "ruff"
local command = string.format(
  "%s format --stdin-filename=${INPUT} --",
  fs.executable(formatter)
)

return {
  formatCommand = command,
  formatStdin = true,
}
