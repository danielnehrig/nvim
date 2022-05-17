local cmd = vim.cmd

if not vim.g.neovide then
  cmd("highlight! Normal guibg = none")
  cmd("highlight! SignColumn guibg = none")
  cmd("highlight! LineNr guibg = none")
  cmd("highlight! VertSplit guibg = none")
end
cmd(
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
cmd("highlight! NotifyBG guibg=#3d3d3d guifg=#3e4451")
cmd("highlight! EndOfBuffer guifg=#282c34")
cmd("highlight! TelescopeBorder guifg=none guibg=none ctermbg=none")
cmd("highlight! TelescopeNormal guibg=none ctermbg=none")
cmd("highlight! TelescopePromptBorder guibg=none ctermbg=none")
cmd("highlight! TelescopeResultsBorder  guibg=none ctermbg=none")
cmd("highlight! TelescopePreviewBorder  guibg=none ctermbg=none")
cmd("highlight! FoldColumn guifg=#a485dd guibg=none ctermbg=none")
