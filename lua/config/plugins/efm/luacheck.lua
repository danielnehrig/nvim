local linter = "luacheck"
local command = string.format("%s --codes --no-color --quiet -", linter)

return {
  prefix = linter,
  lintCommand = command,
  lintStdin = true,
  lintFormats = { "%.%#:%l:%c: (%t%n) %m" },
  rootMarkers = { ".luacheckrc" },
}
