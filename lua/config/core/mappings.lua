local M = {}

M.general = {
  v = {
    { "J", ":m '>+1<CR>gv=gv" },
    { "K", ":m '<-2<CR>gv=gv" },
    { "<leader>p", '"_dP' },
    { "<leader>D", '"_d' },
  },
  n = {
    { "<leader>Y", 'gg"+yG' },
    { "<leader>D", '"_d' },
    { "<C-d>", "<C-d>zz" },
    { "<C-u>", "<C-u>zz" },
    { "<A-h>", ":vert resize +5<CR>" },
    { "<A-j>", ":resize  +5<CR>" },
    { "<A-k>", ":resize  -5<CR>" },
    { "<A-l>", ":vert resize -5<CR>" },
  },
  i = { { "jj", "<ESC>" } },
}

M.quickfix = {
  n = {
    {
      "<Leader>qo",
      function()
        require("config.utils").toggle_qf()
      end,
    },
    { "<Leader>qn", ":cnext<CR>" },
    { "<Leader>qp", ":cprev<CR>" },
  },
}

M.loclist = {
  n = {
    { "<Leader>lc", ":lclose<CR>" },
    { "<Leader>lo", ":lopen<CR>" },
    { "<Leader>ln", ":lnext<CR>" },
    { "<Leader>lp", ":lprev<CR>" },
  },
}

M.others = {
  n = {
    { "<C-p>", "<cmd>FineCmdline<CR>" },
    {
      "<Leader>gy",
      function()
        require("config.plugins.configs.gitlinker"):normal()
      end,
    },
    { "<Leader>gt", ":Trouble<CR>" },
    { "<Leader>ms", ":Neomake<CR>" },
    { "<Leader>mt", ":TestFile<CR>" },
    { "<Leader>mu", ":Ultest<CR>" },
    { "<Leader>nf", ":DocGen<CR>" },
    { "<Leader>w", ":WindowPick<CR>" },
  },
  v = {
    {
      "<Leader>gy",
      function()
        require("config.plugins.configs.gitlinker"):visual()
      end,
    },

    {
      "<Leader>rt",
      "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
      { noremap = true },
    },
  },
}

M.telescope = {
  n = {
    {
      "<Leader>ff",
      "<Cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<CR>",
    },
    { "<Leader>fg", ":Telescope live_grep<CR>" },
    { "<Leader>fb", ":Telescope file_browser<CR>" },
    { "<Leader>fs", ":Telescope git_status<CR>" },
    { "<Leader>fh", ":Telescope help_tags<CR>" },
    { "<Leader>fo", ":Telescope oldfiles<CR>" },
    { "<Leader>fp", ":Telescope project<CR>" },
  },
}

M.tree = {
  n = {
    { "<Leader>n", ":NvimTreeFindFile<CR>" },
    { "<C-n>", ":NvimTreeToggle<CR>" },
  },
}

M.dap = {
  n = {
    {
      "<Leader>dc",
      function()
        require("config.plugins.configs.dap.attach").init()
        require("dap").continue()
      end,
    },
    {
      "<Leader>db",
      function()
        require("config.plugins.configs.dap.attach").init()
        require("dap").toggle_breakpoint()
      end,
    },
  },
}

-- utility binds
M.util = {
  n = {
    {
      "<leader>r",
      function()
        require("config.core.global").reload()
      end,
      { silent = false },
    },
    {
      "<leader>uf",
      require("config.core.options").fold_column_toggle,
      { silent = true },
    },
    {
      "<leader>ud",
      vim.diagnostic.disable,
      { silent = true },
    },
    {
      "<leader>ut",
      vim.diagnostic.enable,
      { silent = true },
    },

    {
      "<leader>ur",
      require("config.core.options").relative_position_toggle,
      {
        silent = true,
      },
    },

    {
      "<leader>un",
      require("config.core.options").number_toggle,
      {
        silent = true,
      },
    },
    {
      "<leader>us",
      require("config.core.options").spell_toggle,
      {
        silent = true,
      },
    },
  },
}

M.map = {
  M.general,
  M.telescope,
  M.dap,
  M.others,
  M.loclist,
  M.quickfix,
  M.util,
  M.tree,
}

function M.mappings()
  -- apply mappings
  for _, section in ipairs(M.map) do
    for mode, map in pairs(section) do
      for _, conf in ipairs(map) do
        if conf[3] then
          vim.keymap.set(mode, conf[1], conf[2], conf[3])
        else
          vim.keymap.set(mode, conf[1], conf[2])
        end
      end
    end
  end
end

return M
