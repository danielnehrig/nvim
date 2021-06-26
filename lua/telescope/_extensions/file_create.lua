local telescope = require("telescope")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local action_state = require("telescope.actions.state")
-- local action_set = require("telescope.actions.set")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
-- local Path = require("plenary.path")
-- local os_sep = Path.path.sep
local open_mode = vim.loop.constants.O_CREAT + vim.loop.constants.O_WRONLY + vim.loop.constants.O_TRUNC

local folder_list = function()
    local list = {}
    local p = io.popen("find . -type d")
    for file in p:lines() do
        table.insert(list, file:sub(3))
    end
    return list
end

function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

local function clear_prompt()
    vim.api.nvim_command("normal :esc<CR>")
end

local function get_user_input()
    return vim.fn.nr2char(vim.fn.getchar())
end

local function clear_buffer(absolute_path)
    for _, buf in pairs(vim.api.nvim_list_bufs()) do
        if vim.fn.bufloaded(buf) == 1 and vim.api.nvim_buf_get_name(buf) == absolute_path then
            vim.api.nvim_command(":bd! " .. buf)
        end
    end
end

local function remove_dir(cwd)
    local handle = vim.loop.fs_scandir(cwd)
    if type(handle) == "string" then
        return vim.api.nvim_err_writeln(handle)
    end
    dump(handle)

    while true do
        local name, t = vim.loop.fs_scandir_next(handle)
        print(name)
        if not name then
            break
        end

        local new_cwd = cwd .. name
        if t == "directory" then
            local success = remove_dir(new_cwd)
            if not success then
                return false
            end
        else
            local success = vim.loop.fs_unlink(new_cwd)
            if not success then
                return false
            end
            clear_buffer(new_cwd)
        end
    end

    return vim.loop.fs_rmdir(cwd)
end

local function create_file(file)
    if vim.loop.fs_access(file, "r") ~= false then
        print(file .. " already exists. Overwrite? y/n")
        local ans = get_user_input()
        clear_prompt()
        if ans ~= "y" then
            return
        end
    end
    vim.loop.fs_open(
        file,
        "w",
        open_mode,
        vim.schedule_wrap(
            function(err, fd)
                if err then
                    vim.api.nvim_err_writeln("Couldn't create file " .. file)
                else
                    vim.loop.fs_chmod(file, 420)
                    vim.loop.fs_close(fd)
                end
            end
        )
    )
end

local file_create = function(opts)
    opts = opts or {}
    local results = folder_list()

    pickers.new(
        opts,
        {
            prompt_title = "Create file in",
            results_title = "File Creation",
            finder = finders.new_table {
                results = results,
                entry_maker = make_entry.gen_from_file(opts)
            },
            previewer = conf.file_previewer(opts),
            sorter = conf.file_sorter(opts),
            attach_mappings = function(_, map)
                local create_new_file = function(bufnr)
                    local new_cwd = vim.fn.expand(action_state.get_selected_entry().path)
                    local fileName = vim.fn.input("File Name: ")
                    if fileName == "" and not new_cwd then
                        print("To create a new file name or directory")
                        return
                    end
                    local result = new_cwd .. "/" .. fileName
                    create_file(result)
                    actions.close(bufnr)
                    vim.cmd(string.format(":e %s", result))
                end

                local delete_folder = function(bufnr)
                    local new_cwd = vim.fn.expand(action_state.get_selected_entry().path)

                    print("Are you sure you wanna delete this File? y / n")
                    local ans = get_user_input()
                    clear_prompt()
                    if ans ~= "y" then
                        return
                    end
                    print(new_cwd)
                    remove_dir(new_cwd)
                    actions.close(bufnr)
                end

                local rename_folder = function()
                end

                map("i", "<C-e>", create_new_file)
                map("n", "<C-e>", create_new_file)
                map("i", "<C-d>", delete_folder)
                map("n", "<C-d>", delete_folder)
                map("i", "<C-r>", rename_folder)
                map("n", "<C-r>", rename_folder)
                return true
            end
        }
    ):find()
end

return telescope.register_extension {exports = {file_create = file_create}}
