local fs = require("config.core.fs")

local formatter = "jq"
local lint_command = string.format("%s .", fs.executable(formatter))

return {
  prefix = formatter,
  lintCommand = lint_command,
  lintStdin = true,
  rootMarkers = {},
}
