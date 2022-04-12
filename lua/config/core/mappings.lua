local set = vim.keymap.set
local M = {}

function M.mappings()
  -- general
  set("v", "J", ":m '>+1<CR>gv=gv") -- move lines
  set("v", "K", ":m '<-2<CR>gv=gv") -- move lines
  set("v", "<leader>p", '"_dP') -- delete into blackhole and past last yank
  set("n", "<leader>Y", 'gg"+yG') -- copy hole biffer
  set("n", "<leader>D", '"_d') -- delete into blackhole register
  set("v", "<leader>D", '"_d') -- delete into blackhole register
  set("n", "<C-d>", "<C-d>zz") -- move and center
  set("n", "<C-u>", "<C-u>zz") -- move and center
  set("i", "jj", "<ESC>") -- normal mode map

  -- quickfix
  set("n", "<Leader>qo", ":lua require('config.utils').toggle_qf()<CR>")
  set("n", "<Leader>qn", ":cnext<CR>")
  set("n", "<Leader>qp", ":cprev<CR>")

  -- locationlist
  set("n", "<Leader>lc", ":lclose<CR>")
  set("n", "<Leader>lo", ":lopen<CR>")
  set("n", "<Leader>ln", ":lnext<CR>")
  set("n", "<Leader>lp", ":lprev<CR>")

  -- cmdline
  set("n", "<C-p>", "<cmd>FineCmdline<CR>")

  -- telescope NOTE: Lazyloaded
  set(
    "n",
    "<Leader>ff",
    "<Cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<CR>"
  )
  set("n", "<Leader>fg", ":Telescope live_grep<CR>")
  set("n", "<Leader>fb", ":Telescope file_browser<CR>")
  set("n", "<Leader>gf", ":Telescope lsp_code_actions theme=cursor<CR>")
  set("n", "<Leader>fs", ":Telescope git_status<CR>")
  --set("n", "<Leader>fb", ":Telescope buffers<CR>")
  set("n", "<Leader>fh", ":Telescope help_tags<CR>")
  set("n", "<Leader>fo", ":Telescope oldfiles<CR>")
  set("n", "<Leader>fp", ":Telescope project<CR>")

  -- nvim tree NOTE: Lazyloaded
  set("n", "<Leader>n", ":NvimTreeFindFile<CR>")
  set("n", "<C-n>", ":NvimTreeToggle<CR>")

  -- dap NOTE: Lazyloaded
  set(
    "n",
    "<Leader>dc",
    [[ <Cmd>lua require("config.plugins.dap.attach"):addPlug(); require'dap'.continue()<CR>]]
  )
  set(
    "n",
    "<Leader>db",
    [[ <Cmd>lua require("config.plugins.dap.attach"):addPlug(); require'dap'.toggle_breakpoint()<CR>]]
  )

  -- gitlinker: NOTE: Lazyloaded
  set(
    "n",
    "<Leader>gy",
    [[ <Cmd>lua require('config.plugins.gitlinker'):normal()<CR>]]
  )
  set(
    "v",
    "<Leader>gy",
    [[ <Cmd>lua require('config.plugins.gitlinker'):visual()<CR>]]
  )

  -- refactor: NOTE: Lazyloaded
  set(
    "v",
    "<Leader>re",
    [[ <Cmd>lua require('config.plugins.refactoring').extract()<CR>]]
  )
  set(
    "v",
    "<Leader>rf",
    [[ <Cmd>lua require('config.plugins.refactoring').extract_to_file()<CR>]]
  )
  set(
    "v",
    "<Leader>rt",
    [[<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]]
  )

  -- marker: NOTE: Lazyloaded
  set("v", "<Leader>1", ":<c-u>HSHighlight 1<CR>")
  set("v", "<Leader>2", ":<c-u>HSHighlight 2<CR>")
  set("v", "<Leader>3", ":<c-u>HSHighlight 3<CR>")
  set("v", "<Leader>4", ":<c-u>HSHighlight 4<CR>")
  set("v", "<Leader>5", ":<c-u>HSHighlight 5<CR>")
  set("v", "<Leader>6", ":<c-u>HSHighlight 6<CR>")
  set("v", "<Leader>7", ":<c-u>HSHighlight 7<CR>")
  set("v", "<Leader>8", ":<c-u>HSHighlight 8<CR>")
  set("v", "<Leader>9", ":<c-u>HSHighlight 9<CR>")
  set("v", "<Leader>0", ":<c-u>HSRmHighlight<CR>")

  -- trouble
  set("n", "<Leader>gt", ":Trouble<CR>")

  -- make
  set("n", "<Leader>ms", ":Neomake<CR>")
  set("n", "<Leader>mt", ":TestFile<CR>")
  set("n", "<Leader>mu", ":Ultest<CR>")

  -- neogen
  set("n", "<Leader>nf", ":DocGen<CR>")

  -- Move to window, or swap by using shift + letter
  set("n", "<Leader>w", ":WindowPick<CR>")

  -- utility binds
  set("n", "<A-h>", ":vert resize +5<CR>")
  set("n", "<A-j>", ":resize  +5<CR>")
  set("n", "<A-k>", ":resize  -5<CR>")
  set("n", "<A-l>", ":vert resize -5<CR>")
  set({ "n" }, "<leader>r", function()
    require("config.core.global").reload()
  end, {
    silent = false,
  })
  set({ "n" }, "<leader>uf", require("config.core.options").fold_column_toggle, {
    silent = true,
  })
  set(
    { "n" },
    "<leader>ur",
    require("config.core.options").relative_position_toggle,
    {
      silent = true,
    }
  )
  set({ "n" }, "<leader>un", require("config.core.options").number_toggle, {
    silent = true,
  })
  set({ "n" }, "<leader>us", require("config.core.options").spell_toggle, {
    silent = true,
  })
end

return M
