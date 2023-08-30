---@class MapModes
---@field n? Map[]
---@field v? Map[]
---@field i? Map[]
---@field x? Map[]
---@field c? Map[]

---@class Map
---@field [1] string key binding
---@field [2] string|fun() command
---@field [3] MapOptions options for the mapping

---@class MapOptions
---@field noremap? boolean
---@field silent? boolean
---@field expr? boolean
---@field desc string for which key

---@class mappings
---@field general MapModes
---@field quickfix MapModes
---@field loclist MapModes
---@field others MapModes
---@field telescope MapModes
---@field tree MapModes
---@field dap MapModes
---@field util MapModes
---@field lsp MapModes
---@field diag MapModes
---@field gram MapModes
---@field run MapModes
local M = {}

M.general = {
  v = {
    { "<leader>p", '"_dP', { desc = "Delete into Void and Paste" } },
    { "<leader>D", '"_d', { desc = "Delete into Void" } },
    { "x", '"_x', { desc = "Delete into Void" } },
  },
  n = {
    { "<leader>Y", 'gg"+yG', { desc = "Copy whole File" } },
    { "<leader>D", '"_d', { desc = "Delete into Void" } },
    { "x", '"_x', { desc = "Delete into Void" } },
    { "<C-d>", "<C-d>zz", { desc = "Jump Down and Center" } },
    { "<C-u>", "<C-u>zz", { desc = "Jump Up and Center" } },
    { "<A-h>", "<Cmd>vert resize +5<CR>", { desc = "Resize Split left" } },
    { "<A-j>", "<Cmd>resize  +5<CR>", { desc = "Resize Split Up" } },
    { "<A-k>", "<Cmd>resize  -5<CR>", { desc = "Resize Split Down" } },
    { "<A-l>", "<Cmd>vert resize -5<CR>", { desc = "Resize Split Right" } },
  },
  i = { { "jj", "<ESC>", { desc = "Normal Mode" } } },
}

M.quickfix = {
  n = {
    {
      "<Leader>qo",
      function()
        require("config.utils").toggle_qf()
      end,
      { desc = "Open QF" },
    },
    { "<Leader>qn", "<Cmd>cnext<CR>", { desc = "Next Item" } },
    { "<Leader>qp", "<Cmd>cprev<CR>", { desc = "Prev Item" } },
  },
}

M.loclist = {
  n = {
    { "<Leader>lc", "<Cmd>lclose<CR>", { desc = "Close" } },
    { "<Leader>lo", "<Cmd>lopen<CR>", { desc = "Open" } },
    { "<Leader>ln", "<Cmd>lnext<CR>", { desc = "Next Item" } },
    { "<Leader>lp", "<Cmd>lprev<CR>", { desc = "Prev Item" } },
  },
}

M.others = {
  n = {
    {
      "<Leader>vh",
      "<cmd>VGit buffer_history_preview<CR>",
      { desc = "Git Buffer History Preview" },
    },
    {
      "<Leader>gy",
      function()
        require("config.plugins.configs.gitlinker").normal()
      end,
      { desc = "GitLinker" },
    },
    { "<Leader>gt", "<Cmd>Trouble<CR>", { desc = "Trouble LSP" } },
    { "<Leader>nf", "<Cmd>DocGen<CR>", { desc = "DocGen" } },
    { "<Leader>w", "<Cmd>WindowPick<CR>", { desc = "WindowPick" } },
  },
  v = {
    {
      "<Leader>gy",
      function()
        require("config.plugins.configs.gitlinker").visual()
      end,
      { desc = "GitLinker" },
    },
    {
      "<Leader>rt",
      "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
      { desc = "Refactoring", noremap = true },
    },
  },
}

M.telescope = {
  n = {
    {
      "<Leader>ff",
      "<Cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<CR>",
      { desc = "FindFiles" },
    },
    {
      "<Leader>fF",
      "<Cmd>Telescope find_files find_command=rg,--files hidden=true no_ignore=true prompt_prefix=🔍<CR>",
      { desc = "FindFiles" },
    },
    { "<Leader>fg", "<Cmd>Telescope live_grep<CR>", { desc = "Grep" } },
    {
      "<Leader>fb",
      "<Cmd>Telescope file_browser<CR>",
      { desc = "File Browser" },
    },
    {
      "<Leader>fs",
      "<Cmd>Telescope git_status<CR>",
      { desc = "Git Status" },
    },
    { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", { desc = "Help Tags" } },
    { "<Leader>fo", "<Cmd>Telescope oldfiles<CR>", { desc = "OldFiles" } },
    { "<Leader>fp", "<Cmd>Telescope project<CR>", { desc = "Projects" } },
  },
}

M.tree = {
  n = {
    {
      "<Leader>n",
      "<Cmd>NvimTreeFindFile<CR>",
      { desc = "TreeToggle gt File" },
    },
    { "<C-n>", "<Cmd>NvimTreeToggle<CR>", { desc = "TreeToggle" } },
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
      { desc = "Attach" },
    },
    {
      "<Leader>db",
      function()
        require("config.plugins.configs.dap.attach").init()
        require("dap").toggle_breakpoint()
      end,
      { desc = "Breakpoint" },
    },
  },
}

-- utility binds
M.util = {
  c = {
    {
      "<C-a>",
      function()
        require("noice").redirect(vim.fn.getcmdline() --[[@as string]])
      end,
      { desc = "Redirect Cmdline output to noice buffer" },
    },
  },
  i = {
    {
      "<Plug>(vimrc:copilot-dummy-map)",
      'copilot#Accept("\\<CR>")',
      { desc = "Copilot Accept", expr = true, silent = true },
    },
    {
      "<C-d>]",
      "<Plug>(copilot-next)",
      { desc = "Copilot Next", silent = true },
    },
    {
      "<C-d>d",
      "<Plug>(copilot-dismiss)",
      { desc = "Copilot Dismiss", silent = true },
    },
    {
      "<C-d>[",
      "<Plug>(copilot-previous)",
      { desc = "Copilot Prev", silent = true },
    },
  },
  n = {
    {
      "<leader>uv",
      "<cmd>Bionic<CR>",
      { desc = "Toggle Bionic", silent = true },
    },
    {
      "<leader>ub",
      "<cmd>Block<CR>",
      { desc = "Toggle Block", silent = true },
    },
    {
      "<leader>uf",
      require("config.core.options").fold_column_toggle,
      { desc = "Toggle Fold", silent = true },
    },
    {
      "<leader>ud",
      vim.diagnostic.disable,
      { desc = "Toggle Diagnostic 0", silent = true },
    },
    {
      "<leader>ut",
      vim.diagnostic.enable,
      { desc = "Toggle Diagnostic 1", silent = true },
    },

    {
      "<leader>ur",
      require("config.core.options").relative_position_toggle,
      {
        desc = "Toggle Relative",
        silent = true,
      },
    },

    {
      "<leader>un",
      require("config.core.options").number_toggle,
      {
        desc = "Toggle Numbers",
        silent = true,
      },
    },
    {
      "<leader>us",
      require("config.core.options").spell_toggle,
      {
        desc = "Toggle Spell",
        silent = true,
      },
    },
    {
      "<leader>ux",
      require("config.core.options").toggle_signcolumn,
      {
        desc = "Toggle Signcolumn",
        silent = true,
      },
    },
  },
}

M.diag = {
  ["n"] = {
    {
      "<leader>gn",
      function()
        vim.diagnostic.goto_next()
      end,
      { desc = "Goto Next Diagnostic Item", silent = false },
    },
    {
      "<leader>gp",
      function()
        vim.diagnostic.goto_prev()
      end,
      { desc = "Goto Previous Diagnostic Item", silent = false },
    },
  },
}

M.gram = {
  n = {
    {
      "<leader>ggf",
      "<Plug>(grammarous-fixall)",
      { desc = "Grammer Fix All", silent = false },
    },
    {
      "<leader>ggo",
      "<Plug>(grammarous-open-info-window)",
      { desc = "Grammer Open", silent = false },
    },
    {
      "<leader>ggn",
      "<Plug>(grammarous-move-to-next-error)",
      { desc = "Grammer Go Next", silent = false },
    },
    {
      "<leader>ggp",
      "<Plug>(grammarous-move-to-previous-error)",
      { desc = "Grammer Go Prev", silent = false },
    },
    {
      "<leader>ggi",
      "<Plug>(grammarous-fixit)",
      { desc = "Grammer Fix It", silent = false },
    },
    {
      "<leader>ggc",
      "<cmd>GrammarousCheck<CR>",
      { desc = "Grammer Check", silent = false },
    },
  },
}

M.run = {
  v = {
    {
      "<leader>br",
      "<cmd>'<,'>SnipRun<CR>",
      { desc = "Run Code", silent = false },
    },
  },
  n = {
    {
      "<leader>br",
      "<cmd>%SnipRun<CR>",
      { desc = "Run Code", silent = false },
    },
    {
      "<leader>bb",
      "<cmd>OverseerRun<CR>",
      { desc = "Overseer Build", silent = false },
    },
    {
      "<leader>bt",
      function()
        require("neotest").overseer.run()
      end,
      { desc = "NeoTest + Overseer", silent = false },
    },
  },
}

M.map = {
  M.general,
  M.telescope,
  M.run,
  M.dap,
  M.others,
  M.loclist,
  M.quickfix,
  M.util,
  M.tree,
  M.diag,
  M.gram,
}

M.vscode_file = {
  n = {
    {
      "<leader>fg",
      "<cmd>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>",
      { desc = "Find in Files", silent = false },
    },
  },
}

M.vscode_map = {
  M.vscode_file,
}

function M.set_lsp_mapping(bufnr)
  M.lsp = {
    n = {
      {
        "gD",
        vim.lsp.buf.declaration,
        { desc = "GT Delcaration", buffer = bufnr },
      },
      {
        "gd",
        vim.lsp.buf.definition,
        { desc = "GT Definition", buffer = bufnr },
      },
      {
        "<C-w>gd",
        "<cmd>split | lua vim.lsp.buf.definition()<CR>",
        { desc = "Split Definition", buffer = bufnr },
      },
      { "K", vim.lsp.buf.hover, { desc = "LSP Hover", buffer = bufnr } },
      { "gr", vim.lsp.buf.references, { desc = "LSP Ref", buffer = bufnr } },
      {
        "gs",
        vim.lsp.buf.signature_help,
        { desc = "Lsp Sig", buffer = bufnr },
      },
      {
        "gi",
        vim.lsp.buf.implementation,
        { desc = "Lsp Impl", buffer = bufnr },
      },
      {
        "<C-w>gi",
        "<cmd>split | lua vim.lsp.buf.implementation()<CR>",
        { desc = "Split Impl", buffer = bufnr },
      },
      {
        "gt",
        vim.lsp.buf.type_definition,
        { desc = "Type Def", buffer = bufnr },
      },
      {
        "<leader>gw",
        vim.lsp.buf.document_symbol,
        { desc = "Doc Symb", buffer = bufnr },
      },
      {
        "<leader>gW",
        vim.lsp.buf.workspace_symbol,
        { desc = "Workspace Symbok", buffer = bufnr },
      },
      {
        "<Leader>gf",
        vim.lsp.buf.code_action,
        { desc = "Code Action", buffer = bufnr },
      },
      {
        "<leader>gr",
        vim.lsp.buf.rename,
        { desc = "Rename", buffer = bufnr },
      },
      {
        "<leader>g=",
        function()
          vim.lsp.buf.format({ async = false, timeout_ms = 2500 })
        end,
        { desc = "Formatting", buffer = bufnr },
      },
      {
        "<leader>gi",
        vim.lsp.buf.incoming_calls,
        { desc = "Inc Calls", buffer = bufnr },
      },
      {
        "<leader>go",
        vim.lsp.buf.outgoing_calls,
        { desc = "Out Calls", buffer = bufnr },
      },
      {
        "<leader>gd",
        "<cmd>lua vim.diagnostic.open_float({focusable = false, border = 'single', source = 'if_many' })<CR>",
        { desc = "Diagnostic Float", buffer = bufnr },
      },
    },
  }

  for mode, map in pairs(M.lsp) do
    for _, conf in ipairs(map) do
      if conf then
        vim.keymap.set(mode, conf[1], conf[2])
      end
    end
  end

  vim.cmd([[:amenu 10.100 PopUp.Definition <cmd>:Telescope lsp_defintions<CR>]])
  vim.cmd(
    [[:amenu 10.120 PopUp.Type\ Definition <cmd>:Telescope lsp_type_definitions<CR>]]
  )
  vim.cmd(
    [[:amenu 10.130 PopUp.Implementations <cmd>:Telescope lsp_implementations<CR>]]
  )
  vim.cmd([[:amenu 10.140 PopUp.References <cmd>:Telescope lsp_references<CR>]])
end

function M.mappings()
  -- merge mappings from user config
  local config = require("config.core.config").config
  table.insert(M.map, config.mappings)

  -- apply mappings
  for _, section in ipairs(M.map) do
    for mode, map in pairs(section) do
      for _, conf in ipairs(map) do
        if conf then
          if conf[3] then
            vim.keymap.set(mode, conf[1], conf[2], conf[3])
          else
            vim.keymap.set(mode, conf[1], conf[2])
          end
        end
      end
    end
  end
end

function M.vscode_mappings()
  for _, section in ipairs(M.vscode_map) do
    for mode, map in pairs(section) do
      for _, conf in ipairs(map) do
        if conf then
          if conf[3] then
            vim.keymap.set(mode, conf[1], conf[2], conf[3])
          else
            vim.keymap.set(mode, conf[1], conf[2])
          end
        end
      end
    end
  end
end

return M
