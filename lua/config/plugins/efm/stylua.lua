local formatter = "stylua"
local command = string.format("%s --color Never -", formatter)

return {
  formatCommand = command,
  formatStdin = true,
  rootMarkers = { "stylua.toml", ".stylua.toml" },
}
