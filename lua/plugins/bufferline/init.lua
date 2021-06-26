local opt = {silent = true}
local g = vim.g

g.mapleader = " "
-- tabnew and tabprev
vim.api.nvim_set_keymap("n", "<Leader>tp", [[<Cmd>BufferPrevious<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>tn", [[<Cmd>BufferNext<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>t1", [[<Cmd>BufferGoto 1<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>t2", [[<Cmd>BufferGoto 2<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>t3", [[<Cmd>BufferGoto 3<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>t4", [[<Cmd>BufferGoto 4<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>t5", [[<Cmd>BufferGoto 5<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>t6", [[<Cmd>BufferGoto 6<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>t6", [[<Cmd>BufferGoto 6<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>tc", [[<Cmd>BufferClose<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>tt", [[<Cmd>BufferPick<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>ta", [[<Cmd>BufferCloseAllButCurrent<CR>]], opt)
