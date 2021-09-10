local windline = require("windline")
local helper = require("windline.helpers")
local sep = helper.separators
local b_components = require("windline.components.basic")
local animation = require("wlanimation")
local efffects = require("wlanimation.effects")
local make = require("plugins.build")
local state = _G.WindLine.state

local lsp_comps = require("windline.components.lsp")
local git_comps = require("windline.components.git")

local anim_colors = {
    "#90CAF9",
    "#64B5F6",
    "#42A5F5",
    "#2196F3",
    "#1E88E5",
    "#1976D2",
    "#1565C0",
    "#0D47A1"
}

local hl_list = {
    Normal = {"NormalFg", "NormalBg"},
    Black = {"white", "black"},
    White = {"black", "white"},
    Inactive = {"InactiveFg", "InactiveBg"},
    Active = {"ActiveFg", "ActiveBg"}
}
local basic = {}

local breakpoint_width = 90
basic.divider = {b_components.divider, ""}
basic.bg = {" ", "StatusLine"}

local colors_mode = {
    Normal = {"red", "black"},
    Insert = {"green", "black"},
    Visual = {"yellow", "black"},
    Replace = {"blue_light", "black"},
    Command = {"magenta", "black"}
}

local util_color = {
    trans = {"transparent", "transparent"}
}

basic.vi_mode = {
    name = "vi_mode",
    hl_colors = colors_mode,
    text = function()
        return {{"  ", state.mode[2]}}
    end
}
basic.square_mode = {
    hl_colors = colors_mode,
    text = function()
        return {{"▊", state.mode[2]}}
    end
}

basic.lsp_diagnos = {
    name = "diagnostic",
    hl_colors = {
        red = {"red", "black"},
        yellow = {"yellow", "black"},
        blue = {"blue", "black"},
        trans = {"transparent", "transparent"},
        sep = {"black", "transparent"},
        spacer = {"black", "black"}
    },
    width = breakpoint_width,
    text = function()
        if lsp_comps.check_lsp() then
            return {
                {" ", "red"},
                {lsp_comps.lsp_error({format = " %s", show_zero = true}), "red"},
                {lsp_comps.lsp_warning({format = "  %s", show_zero = true}), "yellow"},
                {lsp_comps.lsp_hint({format = "  %s", show_zero = true}), "blue"},
                {" ", "spacer"},
                {helper.separators.slant_right, "sep"}
            }
        end
        return ""
    end
}

basic.file = {
    name = "file",
    hl_colors = {
        default = hl_list.Black,
        white = {"white", "black"},
        magenta = {"magenta", "black"}
    },
    text = function(_, _, width)
        if width > breakpoint_width then
            return {
                {b_components.cache_file_size(), "default"},
                {" ", ""},
                {b_components.cache_file_icon({default = ""}), "default"},
                {" ", ""},
                {b_components.cache_file_name("[No Name]", ""), "magenta"},
                {b_components.line_col, "white"},
                {b_components.progress, ""},
                {" ", ""},
                {b_components.file_modified(" "), "magenta"}
            }
        else
            return {
                {b_components.cache_file_size(), "default"},
                {" ", ""},
                {b_components.cache_file_name("[No Name]", ""), "magenta"},
                {" ", ""},
                {b_components.file_modified(" "), "magenta"}
            }
        end
    end
}
basic.file_right = {
    hl_colors = {
        default = hl_list.Black,
        white = {"white", "black"},
        magenta = {"magenta", "black"}
    },
    text = function(_, _, width)
        if width < breakpoint_width then
            return {
                {b_components.line_col, "white"},
                {b_components.progress, ""}
            }
        end
    end
}
basic.git = {
    name = "git",
    hl_colors = {
        green = {"green", "black"},
        red = {"red", "black"},
        blue = {"blue", "black"},
        trans = {"transparent", "transparent"},
        spacer = {"black", "black"},
        sep = {"black", "transparent"}
    },
    width = breakpoint_width,
    text = function()
        if git_comps.is_git() then
            return {
                {helper.separators.slant_left, "sep"},
                {" ", "spacer"},
                {git_comps.diff_added({format = " %s", show_zero = true}), "green"},
                {git_comps.diff_removed({format = "  %s", show_zero = true}), "red"},
                {git_comps.diff_changed({format = " 柳%s", show_zero = true}), "blue"}
            }
        end
        return ""
    end
}

basic.make = {
    name = "make",
    hl_colors = {
        green = {"green", "black"},
        sep = {"black", "transparent"},
        spacer = {"black", "black"},
        wave_anim1 = {"waveright1", "wavedefault"},
        wave_anim2 = {"waveright2", "waveright1"},
        wave_anim3 = {"waveright3", "waveright2"},
        wave_anim4 = {"waveright4", "waveright3"},
        wave_anim5 = {"waveright5", "waveright4"},
        wave_anim6 = {"black", "waveright5"}
    },
    width = breakpoint_width,
    text = function()
        if make:GetRunning() then
            return {
                {helper.separators.slant_left, "sep"},
                {" ", "spacer"},
                {" " .. sep.left_rounded, "wave_anim1"},
                {" " .. sep.left_rounded, "wave_anim2"},
                {" " .. sep.left_rounded, "wave_anim3"},
                {" " .. sep.left_rounded, "wave_anim4"},
                {" " .. sep.left_rounded, "wave_anim5"},
                {" " .. sep.left_rounded, "wave_anim6"},
                {make:Status(), "green"}
            }
        end
        return {
            {helper.separators.slant_left, "sep"},
            {" ", "spacer"},
            {make:Status(), "green"}
        }
    end
}

basic.lsp_workspace = {
    name = "lsp_workspace",
    hl_colors = {
        green = {"green", "black"},
        trans = {"transparent", "transparent"},
        spacer = {"black", "black"},
        sep = {"black", "transparent"}
    },
    width = breakpoint_width,
    text = function()
        if lsp_comps.check_lsp() then
            local lsp_status = require("plugins.lspStatus").lsp_status
            return {
                {helper.separators.slant_left, "sep"},
                {" ", "spacer"},
                {" " .. lsp_status.status(), "green"}
            }
        end
        return ""
    end
}

basic.dap = {
    name = "dap",
    hl_colors = {
        green = {"green", "black"},
        spacer = {"black", "black"},
        sep = {"black", "transparent"}
    },
    width = breakpoint_width,
    text = function()
        local status = require("plugins.dap.attach").getStatus()
        if not status == "" then
            return {
                {helper.separators.slant_left, "sep"},
                {" ", "spacer"},
                {status, "green"}
            }
        end
        return ""
    end
}

basic.lsp_names = {
    name = "lsp_names",
    hl_colors = {
        magenta = {"magenta", "black"},
        sep = {"black", "transparent"},
        spacer = {"black", "black"}
    },
    width = breakpoint_width,
    text = function()
        return {
            {helper.separators.slant_left, "sep"},
            {" ", "spacer"},
            {lsp_comps.lsp_name(), "magenta"}
        }
    end
}

local quickfix = {
    filetypes = {"qf", "Trouble"},
    active = {
        {"🚦 Quickfix ", {"white", "black"}},
        {helper.separators.slant_right, {"black", "black_light"}},
        {
            function()
                return vim.fn.getqflist({title = 0}).title
            end,
            {"cyan", "black_light"}
        },
        {" Total : %L ", {"cyan", "black_light"}},
        {helper.separators.slant_right, {"black_light", "InactiveBg"}},
        {" ", {"InactiveFg", "InactiveBg"}},
        basic.divider,
        {helper.separators.slant_right, {"InactiveBg", "black"}},
        {"🧛 ", {"white", "black"}}
    },
    always_active = true
}

local explorer = {
    filetypes = {"fern", "NvimTree", "lir"},
    active = {
        {"  ", {"white", "black"}},
        {helper.separators.slant_right, {"black", "black_light"}},
        {b_components.divider, ""},
        {b_components.file_name(""), {"white", "black_light"}}
    },
    always_active = true,
    show_last_status = true
}

local dashboard = {
    filetypes = {"dashboard"},
    active = {
        {" ", {"transparent", "transparent"}}
    },
    always_active = true,
    show_last_status = true
}

local default = {
    filetypes = {"default", "terminal"},
    active = {
        basic.square_mode,
        basic.vi_mode,
        basic.file,
        basic.lsp_diagnos,
        basic.divider,
        basic.file_right,
        basic.lsp_names,
        basic.lsp_workspace,
        basic.make,
        basic.dap,
        basic.git,
        {git_comps.git_branch(), {"magenta", "black"}, breakpoint_width},
        {" ", hl_list.Black},
        basic.square_mode
    },
    always_active = true,
    show_last_status = true,
    inactive = {
        basic.square_mode,
        basic.vi_mode,
        basic.file,
        basic.divider,
        basic.file_right,
        basic.git,
        {git_comps.git_branch(), {"magenta", "black"}, breakpoint_width},
        {" ", hl_list.Black},
        basic.square_mode
    }
}

windline.setup(
    {
        colors_name = function(colors)
            -- print(vim.inspect(colors))
            -- ADD MORE COLOR HERE ----
            colors.FilenameFg = colors.white_light
            colors.FilenameBg = colors.black_light
            colors.transparent = "none"

            colors.wavedefault = colors.black
            colors.waveleft1 = colors.wavedefault
            colors.waveleft2 = colors.wavedefault
            colors.waveleft3 = colors.wavedefault
            colors.waveleft4 = colors.wavedefault
            colors.waveleft5 = colors.wavedefault

            colors.waveright1 = colors.wavedefault
            colors.waveright2 = colors.wavedefault
            colors.waveright3 = colors.wavedefault
            colors.waveright4 = colors.wavedefault
            colors.waveright5 = colors.wavedefault

            return colors
        end,
        statuslines = {
            default,
            quickfix,
            explorer,
            dashboard
        }
    }
)

animation.stop_all()
animation.animation(
    {
        data = {
            {"waveleft1", efffects.list_color(anim_colors, 6)},
            {"waveleft2", efffects.list_color(anim_colors, 5)},
            {"waveleft3", efffects.list_color(anim_colors, 4)},
            {"waveleft4", efffects.list_color(anim_colors, 3)},
            {"waveleft5", efffects.list_color(anim_colors, 2)}
        },
        timeout = 100,
        delay = 200,
        interval = 150
    }
)

animation.animation(
    {
        data = {
            {"waveright1", efffects.list_color(anim_colors, 2)},
            {"waveright2", efffects.list_color(anim_colors, 3)},
            {"waveright3", efffects.list_color(anim_colors, 4)},
            {"waveright4", efffects.list_color(anim_colors, 5)},
            {"waveright5", efffects.list_color(anim_colors, 6)}
        },
        timeout = 100,
        delay = 200,
        interval = 150
    }
)
