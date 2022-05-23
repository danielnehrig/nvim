local M = {}

M.general = {
  v = {
    { "J", "<Cmd>m '>+1<CR>gv=gv" },
    { "K", "<Cmd>m '<-2<CR>gv=gv" },
    { "<leader>p", '"_dP' },
    { "<leader>D", '"_d' },
  },
  n = {
    { "<leader>Y", 'gg"+yG' },
    { "<leader>D", '"_d' },
    { "<C-d>", "<C-d>zz" },
    { "<C-u>", "<C-u>zz" },
    { "<A-h>", "<Cmd>vert resize +5<CR>" },
    { "<A-j>", "<Cmd>resize  +5<CR>" },
    { "<A-k>", "<Cmd>resize  -5<CR>" },
    { "<A-l>", "<Cmd>vert resize -5<CR>" },
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
    { "<Leader>qn", "<Cmd>cnext<CR>" },
    { "<Leader>qp", "<Cmd>cprev<CR>" },
  },
}

M.loclist = {
  n = {
    { "<Leader>lc", "<Cmd>lclose<CR>" },
    { "<Leader>lo", "<Cmd>lopen<CR>" },
    { "<Leader>ln", "<Cmd>lnext<CR>" },
    { "<Leader>lp", "<Cmd>lprev<CR>" },
  },
}

M.others = {
  n = {
    { "<C-p>", "<cmd>FineCmdline<CR>" },
    {
      "<Leader>gy",
      function()
        require("config.plugins.configs.gitlinker").normal()
      end,
    },
    { "<Leader>gt", "<Cmd>Trouble<CR>" },
    { "<Leader>ms", "<Cmd>Neomake<CR>" },
    { "<Leader>mt", "<Cmd>TestFile<CR>" },
    { "<Leader>mu", "<Cmd>Ultest<CR>" },
    { "<Leader>nf", "<Cmd>DocGen<CR>" },
    { "<Leader>w", "<Cmd>WindowPick<CR>" },
  },
  v = {
    {
      "<Leader>gy",
      function()
        require("config.plugins.configs.gitlinker").visual()
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
    { "<Leader>fg", "<Cmd>Telescope live_grep<CR>" },
    { "<Leader>fb", "<Cmd>Telescope file_browser<CR>" },
    { "<Leader>fs", "<Cmd>Telescope git_status<CR>" },
    { "<Leader>fh", "<Cmd>Telescope help_tags<CR>" },
    { "<Leader>fo", "<Cmd>Telescope oldfiles<CR>" },
    { "<Leader>fp", "<Cmd>Telescope project<CR>" },
  },
}

M.tree = {
  n = {
    { "<Leader>n", "<Cmd>NvimTreeFindFile<CR>" },
    { "<C-n>", "<Cmd>NvimTreeToggle<CR>" },
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

function M.set_lsp_mapping(bufnr)
  M.lsp = {
    n = {
      { "gD", vim.lsp.buf.declaration, { buffer = bufnr } },
      { "gd", vim.lsp.buf.definition, { buffer = bufnr } },
      {
        "<C-w>gd",
        "<cmd>split | lua vim.lsp.buf.definition()<CR>",
        { buffer = bufnr },
      },
      { "K", vim.lsp.buf.hover, { buffer = bufnr } },
      { "gr", vim.lsp.buf.references, { buffer = bufnr } },
      { "gs", vim.lsp.buf.signature_help, { buffer = bufnr } },
      { "gi", vim.lsp.buf.implementation, { buffer = bufnr } },
      {
        "<C-w>gi",
        "<cmd>split | lua vim.lsp.buf.implementation()<CR>",
        { buffer = bufnr },
      },
      { "gt", vim.lsp.buf.type_definition, { buffer = bufnr } },
      { "<space>gw", vim.lsp.buf.document_symbol, { buffer = bufnr } },
      { "<space>gW", vim.lsp.buf.workspace_symbol, { buffer = bufnr } },
      { "<Leader>gf", vim.lsp.buf.code_action, { buffer = bufnr } },
      {
        "<space>gr",
        "<cmd>lua require('config.plugins.configs.lspconfig.utils').rename()<CR>",
        { buffer = bufnr },
      },
      {
        "<space>g=",
        function()
          vim.lsp.buf.formatting_sync({}, 2500)
        end,
        { buffer = bufnr },
      },
      { "<space>gi", vim.lsp.buf.incoming_calls, { buffer = bufnr } },
      { "<space>go", vim.lsp.buf.outgoing_calls, { buffer = bufnr } },
      {
        "<space>gd",
        "<cmd>lua vim.diagnostic.open_float({focusable = false, border = 'single', source = 'if_many' })<CR>",
        { buffer = bufnr },
      },
    },
    v = {
      { "<Leader>gf", vim.lsp.buf.range_code_action, { buffer = bufnr } },
    },
  }

  for mode, map in pairs(M.lsp) do
    for _, conf in ipairs(map) do
      if conf[3] then
        vim.keymap.set(mode, conf[1], conf[2], conf[3])
      else
        vim.keymap.set(mode, conf[1], conf[2])
      end
    end
  end
end

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
