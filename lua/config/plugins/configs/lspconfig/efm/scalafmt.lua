local fs = require("config.core.fs")
local formatter = 'scalafmt'
local args = '--stdin'
local command = string.format('%s %s', fs.executable(formatter), args)

return {
  formatCanRange = true,
  formatCommand = command,
  formatStdin = true,
}
