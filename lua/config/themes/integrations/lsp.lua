local colors = require("config.themes").get_colors("base_30")

return {
  -- LSP References
  LspReferenceText = { fg = colors.darker_black, bg = colors.white },
  LspReferenceRead = { fg = colors.darker_black, bg = colors.white },
  LspReferenceWrite = { fg = colors.darker_black, bg = colors.white },

  -- Lsp Diagnostics
  DiagnosticHint = { fg = colors.purple },
  DiagnosticError = { fg = colors.red },
  DiagnosticWarn = { fg = colors.yellow },
  DiagnosticInformation = { fg = colors.green },
  LspSignatureActiveParameter = { fg = colors.black, bg = colors.green },

  RenamerTitle = { fg = colors.black, bg = colors.red },
  RenamerBorder = { fg = colors.red },
}
