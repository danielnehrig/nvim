local cmd = vim.cmd

local au_highlight = vim.api.nvim_create_augroup("highlight", { clear = true })
if not vim.g.neovide then
  cmd("autocmd ColorScheme * highlight Normal guibg = none")
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
cmd("autocmd ColorScheme * highlight NotifyBG guibg=#3d3d3d guifg=#3e4451")
cmd("autocmd ColorScheme * highlight LineNr guibg = none")
cmd("autocmd ColorScheme * highlight SignColumn guibg = none")
cmd("autocmd ColorScheme * highlight VertSplit guibg = none")
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

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  command = "highlight Pmenu guibg=none",
  group = au_highlight,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  command = "highlight FloatBorder guibg=none ctermbg=none",
  group = au_highlight,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  command = "highlight NormalFloat guifg=#fff guibg=none ctermbg=none",
  group = au_highlight,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  command = "highlight FoldColumn guibg=none ctermbg=none",
  group = au_highlight,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  command = "highlight GitSignsChange ctermbg=none guibg=none",
  group = au_highlight,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  command = "highlight GitSignsDelete ctermbg=none guibg=none",
  group = au_highlight,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  command = "highlight GitSignsAdd ctermbg=none guibg=none",
  group = au_highlight,
})
