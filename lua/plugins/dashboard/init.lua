local config = {}

function config.dashboard()
    local home = os.getenv("HOME")
    vim.g.dashboard_footer_icon = "ﬦ "
    vim.g.dashboard_preview_command = "cat"
    vim.g.dashboard_preview_pipeline = "lolcat"
    vim.g.dashboard_preview_file = home .. "/.config/nvim/neovim.cat"
    vim.g.dashboard_preview_file_height = 12
    vim.g.dashboard_preview_file_width = 80
    vim.g.dashboard_default_executive = "telescope"
    vim.g.dashboard_custom_section = {
        session = {
            description = {"  Load  Session                              SPC s l"},
            command = "SessionLoad"
        },
        find_file = {
            description = {"  Find  File                              SPC f f"},
            command = "Telescope find_files find_command=rg,--hidden,--files"
        },
        find_word = {
            description = {"  Find  word                              SPC f g"},
            command = "DashboardFindWord"
        },
        new_file = {
            description = {"  File Creator                            SPC f n"},
            command = "Telescope file_create"
        },
        agenda = {
            description = {"  Org Agenda                            SPC o a"},
            command = "normal <space>oa"
        }
    }
end

return config
