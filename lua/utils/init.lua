local M = {}

function M.map(bufnr, type, key, value, opt)
    if opt then
        vim.api.nvim_buf_set_keymap(bufnr, type, key, value, opt)
    else
        vim.api.nvim_buf_set_keymap(bufnr, type, key, value, {noremap = true, silent = true, expr = false})
    end
end

function M.map_global(type, key, value, expr)
    vim.api.nvim_set_keymap(type, key, value, {noremap = true, silent = true, expr = expr})
end

function M.autocmd(event, triggers, operations)
    local cmd = string.format("autocmd %s %s %s", event, triggers, operations)
    vim.cmd(cmd)
end

function M.nvim_create_augroups(tbl)
    for group_name, definition in pairs(tbl) do
        vim.api.nvim_command("augroup " .. group_name)
        vim.api.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command("augroup END")
    end
end

return M
