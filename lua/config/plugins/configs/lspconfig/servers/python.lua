local lsp = require("config.plugins.configs.lspconfig")
local capabilities =
  require("config.plugins.configs.lspconfig.capabilities").capabilities

local config = {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    if client.server_capabilities.documentFormattingProvider then
      local au_lsp =
        vim.api.nvim_create_augroup("pyright_lsp", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
        group = au_lsp,
      })
    end
    local n_present, navic = pcall(require, "nvim-navic")
    if n_present then
      if client:supports_method("textDocument/documentSymbol") then
        navic.attach(client, bufnr)
      end
    end
    lsp.on_attach(client, bufnr)
  end,
}

local M = {}
function M.change_python_interpreter(path)
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  config.settings.python.pythonPath = path
  vim.lsp.config("pyright", config)
  vim.cmd("e%")
end

function M.get_python_interpreters()
  local paths = {}
  local is_home_dir = function()
    return vim.fn.getcwd(0) == vim.fn.expand("$HOME")
  end
  local commands = {
    -- "find $HOME/venvs -name python",
    "which -a python",
    "which -a python2.7",
    "which -a python2",
    "which -a python3.9",
    "which -a python3.12",
    "which -a python3",
    is_home_dir() and "" or "find . -name python",
  }
  for _, cmd in ipairs(commands) do
    local _paths = vim.fn.systemlist(cmd)
    if _paths then
      for _, path in ipairs(_paths) do
        table.insert(paths, path)
      end
    end
  end
  table.sort(paths)
  local res = {}
  for i, path in ipairs(paths) do
    if path ~= paths[i + 1] then
      table.insert(res, path)
    end
  end
  return res
end

vim.lsp.config("pyright", config)

vim.api.nvim_create_user_command("PythonInterpreter", function(tbl)
  M.change_python_interpreter(tbl.args)
end, {
  nargs = 1,
  complete = function(_, _, _)
    return M.get_python_interpreters()
  end,
})

return M
