---@class Blankline
local M = {}

function M.init()
  local present, blank = pcall(require, "ibl")
  if not present then
    return
  end
  blank.setup({
    enabled = true,
    exclude = {
      buftypes = {
        "terminal",
        "dashboard",
        "notify",
      },
      filetypes = {
        "help",
        "terminal",
        "dashboard",
        "alpha",
        "lazy",
        "NvimTree",
        "packer",
        "noice",
        "notify",
        "lspinfo",
        "TelescopePrompt",
        "OverseerForm",
        "TelescopeResults",
        "lsp-installer",
        "",
      }
    },
  })
end

return M
