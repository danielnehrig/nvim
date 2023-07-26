local tmp_base16 = require("config.themes").get_colors("base_16")
-- local tmp_colors = require("config.themes").get_colors("base_30")
local breakpoint_width = 90

local M = {}

M.theme = {
  name = "slanted_lsp",
  config = function()
    local present, windline = pcall(require, "windline")
    if not present then
      vim.notify(string.format("windline not installed"))
      return
    end
    local helper = require("windline.helpers")
    local b_components = require("windline.components.basic")
    local animation = require("wlanimation")
    local effects = require("wlanimation.effects")
    local git_comps = require("windline.components.git")
    local components = require("config.plugins.configs.statusline.components")
    local config = require("config.core.config").config
    local separator_left_side =
      helper.separators[config.ui.statusline.separator[1]]
    local separator_right_side =
      helper.separators[config.ui.statusline.separator[2]]

    local anim_colors = {
      "#90CAF9",
      "#64B5F6",
      "#42A5F5",
      "#2196F3",
      "#1E88E5",
      "#1976D2",
      "#1565C0",
      "#0D47A1",
    }

    local hl_list = {
      Normal = { "NormalFg", "NormalBg" },
      Black = { "white", "black" },
      White = { "black", "white" },
      Inactive = { "InactiveFg", "InactiveBg" },
      Active = { "ActiveFg", "ActiveBg" },
    }
    local basic = {}

    basic.divider = { b_components.divider, "" }
    basic.bg = { " ", "StatusLine" }

    local quickfix = {
      filetypes = { "qf", "Trouble" },
      active = {
        { "🚦 Quickfix ", { "white", "black" } },
        { separator_left_side, { "black", "black_light" } },
        {
          function()
            return vim.fn.getqflist({ title = 0 }).title
          end,
          { "cyan", "black_light" },
        },
        { " Total : %L ", { "cyan", "black_light" } },
        { separator_left_side, { "black_light", "transparent" } },
        { " ", { "InactiveFg", "transparent" } },
        basic.divider,
        { separator_right_side, { "black", "transparent" } },
        { "🧛 ", { "white", "black" } },
      },
      always_active = true,
    }

    local explorer = {
      filetypes = { "fern", "NvimTree", "lir" },
      active = {
        { "  ", { "white", "black" } },
        { separator_left_side, { "black", "transparent" } },
        { b_components.divider, "" },
        { separator_right_side, { "black_light", "transparent" } },
        { b_components.file_name(""), { "white", "black_light" } },
      },
      always_active = true,
      show_last_status = true,
    }

    local repl = {
      filetypes = { "dap-repl" },
      active = {
        { "  ", { "white", "black" } },
        { separator_left_side, { "black", "transparent" } },
        { b_components.divider, "" },
        { separator_right_side, { "black_light", "transparent" } },
        { b_components.file_name(""), { "white", "black_light" } },
      },
      always_active = true,
      show_last_status = true,
    }

    local dashboard = {
      filetypes = { "alpha" },
      active = {
        { " ", { "transparent", "transparent" } },
      },
      always_active = true,
      show_last_status = true,
    }

    local left = { components.vi_mode, components.file, basic.divider }
    local right = {
      components.compiler,
      components.dap,
      components.lsp_names,
      components.git,
      {
        git_comps.git_branch(),
        { "magenta", "black_light" },
        breakpoint_width,
      },
      { " ", { "black_light", "black_light" } },
    }

    local statusline = vim.list_extend(left, right)

    local default = {
      filetypes = { "default", "terminal" },
      active = statusline,
      always_active = true,
      show_last_status = true,
      inactive = {
        components.vi_mode,
        components.file,
        basic.divider,
        components.file_right,
        components.git,
        { git_comps.git_branch(), { "magenta", "black" }, breakpoint_width },
        { " ", hl_list.Black },
      },
    }

    windline.setup({
      colors_name = function(colors)
        for k, v in pairs(colors) do
          -- replace double ## with one #
          colors[k] = string.gsub(v, "##", "#")
        end
        colors.FilenameFg = colors.white_light
        colors.FilenameBg = colors.black_light
        colors.transparent = "none"
        colors.grey = tmp_base16.base03
        colors.black = tmp_base16.base00
        colors.dark_red = tmp_base16.base0F
        colors.magenta = tmp_base16.base08
        colors.dark_green = tmp_base16.base08
        colors.orange = tmp_base16.base09
        colors.debug_bg = tmp_base16.base08
        colors.debug_fg = tmp_base16.base0B

        colors.wavedefault = colors.black

        colors.waveright1 = colors.wavedefault
        colors.waveright2 = colors.wavedefault
        colors.waveright3 = colors.wavedefault
        colors.waveright4 = colors.wavedefault
        colors.waveright5 = colors.wavedefault
        colors.waveright6 = colors.wavedefault
        colors.waveright7 = colors.wavedefault
        colors.waveright8 = colors.wavedefault
        colors.waveright9 = colors.wavedefault

        return colors
      end,
      statuslines = {
        default,
        quickfix,
        repl,
        explorer,
        dashboard,
      },
    })

    local winbar = {
      filetypes = { "winbar" },
      active = {
        components.path,
        components.gps,
        basic.divider,
      },
      inactive = {
        components.path,
        components.gps,
        basic.divider,
      },
    }
    windline.add_status(winbar)

    animation.stop_all()

    animation.animation({
      data = {
        { "waveright1", effects.list_color(anim_colors, 2) },
        { "waveright2", effects.list_color(anim_colors, 3) },
        { "waveright3", effects.list_color(anim_colors, 4) },
        { "waveright4", effects.list_color(anim_colors, 5) },
        { "waveright5", effects.list_color(anim_colors, 6) },
        { "waveright6", effects.list_color(anim_colors, 7) },
        { "waveright7", effects.list_color(anim_colors, 8) },
        { "waveright8", effects.list_color(anim_colors, 9) },
        { "waveright9", effects.list_color(anim_colors, 10) },
      },
      timeout = nil,
      delay = 200,
      interval = 150,
    })

    local loading = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
    animation.basic_animation({
      timeout = nil,
      delay = 200,
      interval = 150,
      effect = effects.list_text(loading),
      on_tick = function(value)
        require("config.plugins.configs.statusline.components").loading_text =
          value
      end,
    })
  end,
}

return M
