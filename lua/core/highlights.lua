local cmd = vim.cmd

cmd("autocmd ColorScheme * highlight LineNr guibg = none")
cmd("autocmd ColorScheme * highlight SignColumn guibg = none")
cmd("autocmd ColorScheme * highlight VertSplit guibg = none")
cmd("autocmd ColorScheme * highlight DiffAdd guifg = #81A1C1 guibg = none")
cmd("autocmd ColorScheme * highlight DiffChange guifg =#3A3E44 guibg = none")
cmd("autocmd ColorScheme * highlight DiffDeleted guifg = #FF6111 guibg = none")
cmd("autocmd ColorScheme * highlight DiffModified guifg = #81A1C1 guibg = none")
cmd("autocmd ColorScheme * highlight EndOfBuffer guifg=#282c34")

cmd("autocmd ColorScheme * highlight TelescopeBorder   guifg=#3e4451")
cmd("autocmd ColorScheme * highlight TelescopePromptBorder   guifg=#3e4451")
cmd("autocmd ColorScheme * highlight TelescopeResultsBorder  guifg=#3e4451")
cmd("autocmd ColorScheme * highlight TelescopePreviewBorder  guifg=#525865")

-- tree folder name , icon color
cmd("autocmd ColorScheme * highlight NvimTreeFolderIcon guifg = #61afef")
cmd("autocmd ColorScheme * highlight NvimTreeIndentMarker guifg=#545862")
cmd("autocmd ColorScheme * highlight CustomExplorerBg guibg=#242830")
cmd("autocmd ColorScheme * highlight default GHTextViewDark guifg=#e0d8f4 guibg=#332e55")
cmd("autocmd ColorScheme * highlight default GHListDark guifg=#e0d8f4 guibg=#103234")

cmd("autocmd ColorScheme * highlight NormalFloat guifg=#fff guibg=none ctermbg=none")
cmd("autocmd ColorScheme * highlight FloatBorder guifg=#FF6111 guibg=none ctermbg=none")
cmd("autocmd ColorScheme * highlight PmenuSel guifg=#c14a4a guibg=#98c379")

-- gitsigns transparent
-- set signs transparent on terminal app
if not vim.g.neovide or not vim.g.goneovim or not vim.g.uivonim then
    cmd("hi GruvboxGreenSign ctermbg=none guibg=none")
    cmd("hi GruvboxRedSign ctermbg=none guibg=none")
    cmd("hi GruvboxRedSign ctermbg=none guibg=none")
    cmd("hi GruvboxAquaSign ctermbg=none guibg=none")
end
