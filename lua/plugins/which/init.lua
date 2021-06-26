local wk = require("which-key")
wk.setup {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = true, -- adds help for operators like d, y, ...
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true -- bindings for prefixed with g
        }
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+" -- symbol prepended to a group
    },
    window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
        padding = {2, 2, 2, 2} -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3 -- spacing between columns
    },
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true -- show help message on the command line when the popup is visible
}

local opts = function(prefix)
    return {
        mode = "n", -- NORMAL mode
        -- prefix: use "<leader>f" for example for mapping everything related to finding files
        -- the prefix is prepended to every mapping part of `mappings`
        prefix = prefix,
        buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = false -- use `nowait` when creating keymaps
    }
end

local mappings = {
    f = {
        name = "+file",
        f = {"Find File"},
        g = {"Search in Files"},
        r = {"Open Recent File"},
        n = {"New File"},
        d = {"Dotfiles"},
        b = {"Buffers"},
        h = {"Help Tags"},
        o = {"Old Files"}
    },
    g = {
        name = "+LSP Peek",
        d = {"Difinition Peek"},
        r = {"Reference Peek"},
        t = {"Trouble"},
        w = {"Symbol"},
        W = {"Workspace Symbol"},
        y = {"Git File Link Range"}
    },
    d = {
        name = "+Debug DAP",
        c = {"Continue"},
        b = {"Breakpoint"},
        B = {"Breakpoint Toggle"},
        i = {"Step Into"},
        o = {"Step Out"},
        O = {"Step Over"},
        e = {"Eval"},
        f = {"Float element"},
        s = {"Stop"},
        d = {"Disconnect"},
        r = {"Repl"}
    },
    a = {
        name = "+LSP Action",
        r = {"Rename"},
        f = {"Code Action"}
    },
    c = {
        name = "+Commenting"
    },
    h = {
        name = "+GitSigns",
        p = {"Preview Hunk"},
        r = {"Reset Hunk"},
        s = {"Stage Hunk"},
        u = {"Undo Hunk"},
        b = {"Blame"}
    },
    q = {
        name = "+QuickFix",
        a = "Select Current",
        n = "Next",
        p = "Previous",
        o = "Open",
        c = "Close"
    },
    l = {
        name = "+LocationList",
        a = "Select Current",
        n = "Next",
        p = "Previous",
        o = "Open",
        c = "Close"
    },
    t = {
        name = "+TABLINE",
        t = {"Pick Tab"},
        one = {"GoTo 1"},
        two = {"GoTo 2"},
        p = {"Previous"},
        n = {"Next"},
        c = {"Close Buffer"},
        a = {"Close All but Current"}
    },
    equal = "LSP Format"
}

wk.register(mappings, opts("<leader>"))
