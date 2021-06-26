local gl = require("galaxyline")
local gls = gl.section
local make = require("plugins.build")

gl.short_line_list = {
    "LuaTree",
    "dbui",
    "dashboard",
    "term",
    "NvimTree",
    "terminal",
    "packer",
    "fugitive",
    "fugitiveblame",
    "dapui_scopes",
    "dapui_stacks",
    "dapui_watches",
    "dap-repl"
}

local colors = {
    bg = "#282c34",
    line_bg = "#353644",
    fg = "#8FBCBB",
    fg_green = "#65a380",
    yellow = "#fabd2f",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#afd700",
    orange = "#FF8800",
    purple = "#5d4d7a",
    magenta = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67"
}

-- https://colordesigner.io/gradient-generator
local failed = {
    "#ec5f67",
    "#be5278",
    "#894c78",
    "#574465",
    "#353644"
}

local success = {
    "#afd700",
    "#28ab15",
    "#25835a",
    "#2f5561",
    "#353644"
}

local Running = {
    "#008080",
    "#0e5970",
    "#1b4161",
    "#283552",
    "#353644"
}

local function LspStatus()
    ---@diagnostic disable-next-line: undefined-field
    if table.getn(vim.lsp.buf_get_clients(0)) > 0 then
        return require("lsp-status").status()
    end

    return ""
end

local buffer_not_empty = function()
    if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
        return true
    end
    return false
end

local function has_file_type()
    local f_type = vim.bo.filetype
    if not f_type or f_type == "" then
        return false
    end
    return true
end

gls.right = {}
gls.left = {}
gls.short_line_left = {}
gls.short_line_right = {}

table.insert(
    gls.left,
    {
        FirstElement = {
            provider = function()
                return " "
            end,
            highlight = {colors.blue, colors.line_bg}
        }
    }
)
table.insert(
    gls.left,
    {
        ViMode = {
            provider = function()
                -- auto change color according the vim mode
                local alias = {
                    n = "NORMAL",
                    i = "INSERT",
                    c = "COMMAND",
                    V = "VISUAL",
                    [""] = "VISUAL",
                    v = "VISUAL",
                    cl = "COMMAND-LINE",
                    ["r?"] = ":CONFIRM",
                    rm = "--MORE",
                    R = "REPLACE",
                    Rv = "VIRTUAL",
                    s = "SELECT",
                    S = "SELECT",
                    ["r"] = "HIT-ENTER",
                    [""] = "SELECT",
                    t = "TERMINAL",
                    ["!"] = "SHELL"
                }
                local mode_color = {
                    n = colors.green,
                    i = colors.blue,
                    v = colors.magenta,
                    [""] = colors.blue,
                    V = colors.blue,
                    c = colors.red,
                    no = colors.magenta,
                    s = colors.orange,
                    S = colors.orange,
                    [""] = colors.orange,
                    ic = colors.yellow,
                    R = colors.purple,
                    Rv = colors.purple,
                    cv = colors.red,
                    ce = colors.red,
                    r = colors.cyan,
                    rm = colors.cyan,
                    ["r?"] = colors.cyan,
                    ["!"] = colors.green,
                    t = colors.green,
                    cl = colors.purple,
                    ["rl?"] = colors.red,
                    ["rl"] = colors.red,
                    rml = colors.red,
                    Rl = colors.yellow,
                    Rvl = colors.magenta
                }
                local vim_mode = vim.fn.mode()
                vim.api.nvim_command("hi GalaxyViMode guifg=" .. mode_color[vim_mode])
                return alias[vim_mode] .. "   "
            end,
            highlight = {colors.red, colors.line_bg, "bold"}
        }
    }
)

table.insert(
    gls.left,
    {
        FileIcon = {
            provider = "FileIcon",
            condition = buffer_not_empty,
            highlight = {require("galaxyline.provider_fileinfo").get_file_icon_color, colors.line_bg}
        }
    }
)

table.insert(
    gls.left,
    {
        FileName = {
            provider = {"FileName", "FileSize"},
            condition = buffer_not_empty,
            highlight = {colors.fg, colors.line_bg, "bold"}
        }
    }
)

table.insert(
    gls.left,
    {
        GitIcon = {
            provider = function()
                return "  "
            end,
            condition = require("galaxyline.provider_vcs").check_git_workspace,
            highlight = {colors.orange, colors.line_bg}
        }
    }
)

table.insert(
    gls.left,
    {
        GitBranch = {
            provider = "GitBranch",
            separator = " ",
            separator_highlight = {colors.line_bg, colors.line_bg},
            condition = require("galaxyline.provider_vcs").check_git_workspace,
            highlight = {"#8FBCBB", colors.line_bg, "bold"}
        }
    }
)

local checkwidth = function()
    local squeeze_width = vim.fn.winwidth(0) / 2
    if squeeze_width > 40 then
        return true
    end
    return false
end

table.insert(
    gls.left,
    {
        DiffAdd = {
            provider = "DiffAdd",
            condition = checkwidth,
            icon = " ",
            highlight = {colors.green, colors.line_bg}
        }
    }
)
table.insert(
    gls.left,
    {
        DiffModified = {
            provider = "DiffModified",
            condition = checkwidth,
            icon = " ",
            highlight = {colors.orange, colors.line_bg}
        }
    }
)
table.insert(
    gls.left,
    {
        DiffRemove = {
            provider = "DiffRemove",
            condition = checkwidth,
            icon = " ",
            highlight = {colors.red, colors.line_bg}
        }
    }
)
table.insert(
    gls.left,
    {
        LeftEnd = {
            provider = function()
                return ""
            end,
            highlight = {colors.line_bg}
        }
    }
)

table.insert(
    gls.left,
    {
        DiagnosticError = {
            provider = "DiagnosticError",
            icon = "  ",
            highlight = {colors.red}
        }
    }
)

table.insert(
    gls.left,
    {
        DiagnosticWarn = {
            provider = "DiagnosticWarn",
            icon = "  ",
            highlight = {colors.yellow}
        }
    }
)

table.insert(
    gls.left,
    {
        LspStatus = {
            provider = function()
                return LspStatus()
            end,
            highlight = {colors.green},
            icon = "  λ "
        }
    }
)

table.insert(
    gls.right,
    {
        RightSepStart = {
            provider = function()
                return ""
            end,
            highlight = {colors.line_bg}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeFailed1 = {
            provider = function()
                if make:GetFailed() then
                    return " "
                end
            end,
            highlight = {failed[1], colors.line_bg}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeFailed2 = {
            provider = function()
                if make:GetFailed() then
                    return " "
                end
            end,
            highlight = {failed[2], failed[1]}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeFailed3 = {
            provider = function()
                if make:GetFailed() then
                    return " "
                end
            end,
            highlight = {failed[3], failed[2]}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeFailed4 = {
            provider = function()
                if make:GetFailed() then
                    return " "
                end
            end,
            highlight = {failed[4], failed[3]}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeFailed5 = {
            provider = function()
                if make:GetFailed() then
                    return " "
                end
            end,
            highlight = {failed[5], failed[4]}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeSuccess1 = {
            provider = function()
                if make:GetSuccess() then
                    return " "
                end
            end,
            highlight = {success[1], colors.line_bg}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeSuccess2 = {
            provider = function()
                if make:GetSuccess() then
                    return " "
                end
            end,
            highlight = {success[2], success[1]}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeSuccess3 = {
            provider = function()
                if make:GetSuccess() then
                    return " "
                end
            end,
            highlight = {success[3], success[2]}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeSuccess4 = {
            provider = function()
                if make:GetSuccess() then
                    return " "
                end
            end,
            highlight = {success[4], success[3]}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeSuccess5 = {
            provider = function()
                if make:GetSuccess() then
                    return " "
                end
            end,
            highlight = {success[5], success[4]}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeRunning1 = {
            provider = function()
                if make:GetRunning() then
                    return " "
                end
            end,
            highlight = {Running[1], colors.bg}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeRunning2 = {
            provider = function()
                if make:GetRunning() then
                    return " "
                end
            end,
            highlight = {Running[2], Running[1]}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeRunning3 = {
            provider = function()
                if make:GetRunning() then
                    return " "
                end
            end,
            highlight = {Running[3], Running[2]}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeRunning4 = {
            provider = function()
                if make:GetRunning() then
                    return " "
                end
            end,
            highlight = {Running[4], Running[3]}
        }
    }
)

table.insert(
    gls.right,
    {
        MakeRunning5 = {
            provider = function()
                if make:GetRunning() then
                    return " "
                end
            end,
            highlight = {Running[5], Running[4]}
        }
    }
)

table.insert(
    gls.right,
    {
        Test = {
            provider = function()
                return "  " .. make:Status()
            end,
            highlight = {colors.fg, colors.line_bg}
        }
    }
)

table.insert(
    gls.right,
    {
        Debug = {
            provider = function()
                if not packer_plugins["nvim-dap"].loaded then
                    return
                end

                return "  " .. require("nvim-dap").status()
            end,
            highlight = {colors.fg, colors.line_bg}
        }
    }
)

table.insert(
    gls.right,
    {
        LineInfo = {
            provider = "LineColumn",
            separator = " | ",
            separator_highlight = {colors.blue, colors.line_bg},
            highlight = {colors.fg, colors.line_bg}
        }
    }
)

table.insert(
    gls.right,
    {
        PerCent = {
            provider = "LinePercent",
            separator = " ",
            separator_highlight = {colors.line_bg, colors.line_bg},
            highlight = {colors.cyan, colors.darkblue, "bold"}
        }
    }
)

table.insert(
    gls.short_line_left,
    {
        BufferType = {
            provider = "FileTypeName",
            separator = "",
            condition = has_file_type,
            separator_highlight = {colors.purple},
            highlight = {colors.fg, colors.purple}
        }
    }
)

table.insert(
    gls.short_line_right,
    {
        BufferIcon = {
            provider = "BufferIcon",
            separator = "",
            condition = has_file_type,
            separator_highlight = {colors.purple},
            highlight = {colors.fg, colors.purple}
        }
    }
)
