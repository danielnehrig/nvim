local remap = require("utils").map_global

-- quickfix
remap("n", "<Leader>qc", ":cclose<CR>")
remap("n", "<Leader>qn", ":cnext<CR>")
remap("n", "<Leader>qo", ":copen<CR>")
remap("n", "<Leader>qp", ":cprev<CR>")
remap("n", "<Leader>qa", ":cc<CR>")

-- locationlist
remap("n", "<Leader>lc", ":lclose<CR>")
remap("n", "<Leader>ln", ":lnext<CR>")
remap("n", "<Leader>lo", ":lopen<CR>")
remap("n", "<Leader>lp", ":lprev<CR>")
remap("n", "<Leader>la", ":ll<CR>")

-- telescope NOTE: Lazyloaded
remap("n", "<Leader>ff", ":Telescope find_files find_command=rg,--ignore,--hidden,--files<CR>")
remap("n", "<Leader>fg", ":Telescope live_grep find_command=rg,--ignore,--hidden<CR>")
remap("n", "<Leader>fb", ":Telescope buffers<CR>")
remap("n", "<Leader>fh", ":Telescope help_tags<CR>")
remap("n", "<Leader>fo", ":Telescope oldfiles<CR>")
remap("n", "<Leader>fp", ":Telescope project<CR>")
remap("n", "<Leader>fn", ":Telescope file_create<CR>")

-- nvim tree NOTE: Lazyloaded
remap("n", "<Leader>n", ":NvimTreeFindFile<CR>")
remap("n", "<C-n>", ":NvimTreeToggle<CR>")

-- dap NOTE: Lazyloaded
remap("n", "<Leader>ds", [[ <Cmd>lua require'dap'.stop()<CR>]])
remap("n", "<Leader>dd", [[ <Cmd>lua require'dap'.disconnect()<CR>]])
remap("n", "<Leader>dc", [[ <Cmd>lua require("plugins.dap.attach").attach()<CR>]])
remap("n", "<Leader>db", [[ <Cmd>lua require("plugins.dap.attach");require'dap'.toggle_breakpoint()<CR>]])
remap("n", "<Leader>dB", [[ <Cmd>lua require'dap'.set_breakpoint(nil, nul vim.fn.input('Log point message: '))<CR>]])
remap("n", "<Leader>dO", [[ <Cmd>lua require'dap'.step_over()<CR>]])
remap("n", "<Leader>di", [[ <Cmd>lua require'dap'.step_into()<CR>]])
remap("n", "<Leader>do", [[ <Cmd>lua require'dap'.step_out()<CR>]])
remap("n", "<Leader>dr", [[ <Cmd>lua require'dap'.repl.open()<CR>]])
remap("n", "<Leader>de", [[ <Cmd>lua require'dapui'.eval()<CR>]])
remap("n", "<Leader>df", [[ <Cmd>lua require'dapui'.float_element()<CR>]])

-- compe: NOTE: Lazyloaded
remap("i", "<C-space>", "compe#complete()", true)
remap("i", "<C-e>", "compe#close('<C-e>')", true)
remap("i", "<C-f>", "compe#scroll({ delta: +4 })", true)
remap("i", "<C-d>", "compe#scroll({ delta: -4 })", true)

-- gitlinker: NOTE: Lazyloaded
remap("n", "<Leader>gy", [[ <Cmd>lua require('plugins.gitlinker'):normal()<CR>]])
remap("v", "<Leader>gy", [[ <Cmd>lua require('plugins.gitlinker'):visual()<CR>]])

-- marker: NOTE: Lazyloaded
remap("v", "<Leader>1", ":<c-u>HSHighlight 1<CR>")
remap("v", "<Leader>2", ":<c-u>HSHighlight 2<CR>")
remap("v", "<Leader>3", ":<c-u>HSHighlight 3<CR>")
remap("v", "<Leader>4", ":<c-u>HSHighlight 4<CR>")
remap("v", "<Leader>5", ":<c-u>HSHighlight 5<CR>")
remap("v", "<Leader>6", ":<c-u>HSHighlight 6<CR>")
remap("v", "<Leader>7", ":<c-u>HSHighlight 7<CR>")
remap("v", "<Leader>8", ":<c-u>HSHighlight 8<CR>")
remap("v", "<Leader>9", ":<c-u>HSHighlight 9<CR>")
remap("v", "<Leader>0", ":<c-u>HSRmHighlight<CR>")
