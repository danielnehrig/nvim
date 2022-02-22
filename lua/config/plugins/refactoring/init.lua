local M = {}

function M.init()
  local refactor = require("refactoring")
  refactor.setup({})
end

function M.extract()
  if
    packer_plugins["refactoring.nvim"]
    and not packer_plugins["refactoring.nvim"].loaded
  then
    vim.cmd([[packadd plenary.nvim]])
    vim.cmd([[packadd refactoring.nvim]])
  end

  local refactoring = require("refactoring")
  refactoring.refactor("Extract Function")
end

function M.extract_to_file()
  if
    packer_plugins["refactoring.nvim"]
    and not packer_plugins["refactoring.nvim"].loaded
  then
    vim.cmd([[packadd plenary.nvim]])
    vim.cmd([[packadd refactoring.nvim]])
  end

  local refactoring = require("refactoring")
  refactoring.refactor("Extract Function To File")
end

function M.refactor(prompt_bufnr)
  local refactoring = require("refactoring")
  local content = require("telescope.actions.state").get_selected_entry()
  require("telescope.actions").close(prompt_bufnr)
  refactoring.refactor(content.value)
end

return M
