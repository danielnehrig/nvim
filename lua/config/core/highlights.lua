local cmd = vim.cmd

if not vim.g.neovide then
  cmd("autocmd ColorScheme * highlight Normal guibg = none guifg = #e2cca9")
end
vim.cmd(
  "highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080"
)
cmd("highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6")
cmd("highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6")
cmd("highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE")
cmd("highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE")
cmd("highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE")
cmd("highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0")
cmd("highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0")
cmd("highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4")
cmd("autocmd ColorScheme * highlight NotifyBG guibg=#3d3d3d guifg=#3e4451")
cmd("autocmd ColorScheme * highlight LineNr guibg = none")
cmd("autocmd ColorScheme * highlight SignColumn guibg = none")
cmd("autocmd ColorScheme * highlight VertSplit guibg = none")
cmd(
  "autocmd ColorScheme * highlight DiffAdd ctermbg = none guifg = #b0b846 guibg = none"
)
cmd(
  "autocmd ColorScheme * highlight DiffChange ctermbg = none guifg =#e9b143 guibg = none"
)
cmd(
  "autocmd ColorScheme * highlight DiffDeleted ctermbg = none guifg = #FF6111 guibg = none"
)
cmd(
  "autocmd ColorScheme * highlight DiffModified ctermbg = none guifg = #81A1C1 guibg = none"
)
cmd("autocmd ColorScheme * highlight EndOfBuffer guifg=#282c34")

cmd("autocmd ColorScheme * highlight TelescopeBorder guibg=none ctermbg=none")
cmd("autocmd ColorScheme * highlight TelescopeNormal guibg=none ctermbg=none")
cmd(
  "autocmd ColorScheme * highlight TelescopePromptBorder guibg=none ctermbg=none"
)
cmd(
  "autocmd ColorScheme * highlight TelescopeResultsBorder  guibg=none ctermbg=none"
)

cmd(
  "autocmd ColorScheme * highlight TelescopePreviewBorder  guibg=none ctermbg=none"
)
cmd("autocmd ColorScheme * highlight FloatBorder guibg=none ctermbg=none")

-- tree folder name , icon color
cmd("autocmd ColorScheme * highlight NvimTreeFolderIcon guifg = #61afef")
cmd("autocmd ColorScheme * highlight NvimTreeIndentMarker guifg=#545862")
cmd("autocmd ColorScheme * highlight CustomExplorerBg guibg=#242830")
cmd(
  "autocmd ColorScheme * highlight default GHTextViewDark guifg=#e0d8f4 guibg=#332e55"
)
cmd(
  "autocmd ColorScheme * highlight default GHListDark guifg=#e0d8f4 guibg=#103234"
)

cmd(
  "autocmd ColorScheme * highlight NormalFloat guifg=#fff guibg=none ctermbg=none"
)
cmd("autocmd ColorScheme * highlight PmenuSel guifg=#c14a4a guibg=#98c379")

cmd("autocmd ColorScheme * highlight GitSignsChange ctermbg=none guibg=none")
cmd("autocmd ColorScheme * highlight GitSignsDelete ctermbg=none guibg=none")
cmd("autocmd ColorScheme * highlight GitSignsAdd ctermbg=none guibg=none")
