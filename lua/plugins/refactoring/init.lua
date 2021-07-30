local M = {}

function M.init()
    local refactor = require("refactoring")
    refactor.setup(
        {
            formatting = {
                lua = function()
                    print("nice COOL")
                    vim.lsp.buf.formatting_sync()
                end
            }
        }
    )
end

function M.extract()
    if packer_plugins["refactoring.nvim"] and not packer_plugins["refactoring.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
        vim.cmd [[packadd refactoring.nvim]]
    end

    local refactoring = require("refactoring")
    refactoring.refactor("Extract Function")
end

function M.extract_to_file()
    if packer_plugins["refactoring.nvim"] and not packer_plugins["refactoring.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
        vim.cmd [[packadd refactoring.nvim]]
    end

    local refactoring = require("refactoring")
    refactoring.refactor("Extract Function To File")
end

local function refactor(prompt_bufnr)
    local refactoring = require("refactoring")
    local content = require("telescope.actions.state").get_selected_entry()
    require("telescope.actions").close(prompt_bufnr)
    refactoring.refactor(content.value)
end

function M.telescope()
    if packer_plugins["refactoring.nvim"] and not packer_plugins["refactoring.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
        vim.cmd [[packadd refactoring.nvim]]
    end
    local refactoring = require("refactoring")
    require("telescope.pickers").new(
        {},
        {
            prompt_title = "refactors",
            finder = require("telescope.finders").new_table(
                {
                    results = refactoring.get_refactors()
                }
            ),
            sorter = require("telescope.config").values.generic_sorter({}),
            attach_mappings = function(_, map)
                map("i", "<CR>", refactor)
                map("n", "<CR>", refactor)
                return true
            end
        }
    ):find()
end

return M
