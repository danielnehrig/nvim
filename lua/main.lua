-- Main Load File
-- Execution Flow of each loaded configuration
-- for various plugins
-- also a lot of configuration for plugins can be found
-- in the packer_config setup
-- because of lazloading
local g = vim.g

-- check if we are in vscode nvim
-- if not do not apply plugins
-- slows down vscode and makes it non usable
if not g.vscode then
    -- load packer plugins
    local pack = require("packer-config")
    pack.ensure_plugins()
    pack.load_compile()

    -- setup conf and lua modules
    require("core.global")
    require("core.options")
    require("core.mappings")
    require("core.autocmd")

    -- load configs for packer plugins
    require("plugins.build")
    require("plugins.coverage")
    require("plugins.lspconfig")
    require("plugins.indent-blankline")
    require("plugins.bufferline")
    require("plugins.statusline")
    require("plugins.web-devicons")
    require("plugins.dashboard")
    require("plugins.which")
    require("plugins.swagger")
    require("plugins.autopairs")
    require("plugins.nvimTree")
    require("plugins.treesitter")
    require("plugins.snap")

    -- setup plugins and init them
    -- those are not worth of own file extraction
    require("colorizer").setup()
    require("lspkind").init({File = " "})

    local nvimux = require("nvimux")

    -- Nvimux configuration
    nvimux.config.set_all {
        prefix = "<C-a>",
        new_window = "enew", -- Use 'term' if you want to open a new term for every new window
        new_tab = nil, -- Defaults to new_window. Set to 'term' if you want a new term for every new tab
        new_window_buffer = "single",
        quickterm_direction = "botright",
        quickterm_orientation = "vertical",
        quickterm_scope = "t", -- Use 'g' for global quickterm
        quickterm_size = "80"
    }

    -- Nvimux custom bindings
    nvimux.bindings.bind_all {
        {"s", ":NvimuxHorizontalSplit", {"n", "v", "i", "t"}},
        {"v", ":NvimuxVerticalSplit", {"n", "v", "i", "t"}}
    }

    -- Required so nvimux sets the mappings correctly
    nvimux.bootstrap()
end
