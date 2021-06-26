local remap = vim.api.nvim_set_keymap
require("trouble").setup {}

remap("n", "<Leader>gt", ":LspTroubleToggle<CR>", {silent = true, noremap = true})
