local fs = require("config.core.fs")

local formatter = "shfmt"
local command = string.format("%s -ci -s -bn", fs.executable(formatter))

return { formatCommand = command, formatStdin = true }
