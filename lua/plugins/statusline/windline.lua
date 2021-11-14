local windline = require("windline")
local helper = require("windline.helpers")
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
  "#0D47A1",
}
local loading_text = ""

local hl_list = {
  Normal = { "NormalFg", "NormalBg" },
  Black = { "white", "black" },
  White = { "black", "white" },
  Inactive = { "InactiveFg", "InactiveBg" },
  Active = { "ActiveFg", "ActiveBg" },
}
local basic = {}

local breakpoint_width = 90
basic.divider = { b_components.divider, "" }
basic.bg = { " ", "StatusLine" }

local colors_mode = {
  Normal = { "red", "black" },
  Insert = { "green", "black" },
  Visual = { "yellow", "black" },
  Replace = { "blue_light", "black" },
  Command = { "magenta", "black" },
}

local language_mode = {
  lua = { "blue", "black" },
  typescript = { "blue", "black" },
  typescriptreact = { "blue", "black" },
  javascript = { "red", "black" },
  javascriptreact = { "red", "black" },
  sh = { "white", "black" },
  zsh = { "white", "black" },
  rust = { "orange", "black" },
  java = { "red", "black" },
  python = { "blue", "black" },
  white = { "white", "black" },
  default = { "white", "black" },
  magenta = { "magenta", "black" },
}

basic.vi_mode = {
  name = "vi_mode",
  hl_colors = colors_mode,
  text = function()
    return { { "   ", state.mode[2] } }
  end,
}
basic.square_mode = {
  hl_colors = colors_mode,
  text = function()
    return { { "▊", state.mode[2] } }
  end,
}

basic.lsp_diagnos = {
  name = "diagnostic",
  hl_colors = {
    red = { "red", "black" },
    yellow = { "yellow", "black" },
    blue = { "blue", "black" },
    trans = { "transparent", "transparent" },
    sep = { "black", "transparent" },
    spacer = { "black", "black" },
  },
  width = breakpoint_width,
  text = function()
    if lsp_comps.check_lsp() then
      return {
        { " ", "red" },
        {
          lsp_comps.lsp_error({
            format = " %s",
            show_zero = true,
          }),
          "red",
        },
        {
          lsp_comps.lsp_warning({
            format = "  %s",
            show_zero = true,
          }),
          "yellow",
        },
        {
          lsp_comps.lsp_hint({
            format = "  %s",
            show_zero = true,
          }),
          "blue",
        },
        { " ", "spacer" },
        { helper.separators.slant_right, "sep" },
      }
    end
    return ""
  end,
}

local icon_comp = b_components.cache_file_icon({
  default = "",
  hl_colors = { "white", "black" },
})

basic.file = {
  name = "file",
  hl_colors = language_mode,
  text = function(bufnr, _, width)
    -- local filetype = vim.bo.filetype
    -- local len = string.len(filetype)

    if width > breakpoint_width then
      return {
        { b_components.cache_file_size(), "default" },
        { " ", "" },
        icon_comp(bufnr),
        { " ", "" },
        { b_components.cache_file_name("[No Name]", ""), "magenta" },
        { b_components.line_col, "white" },
        { b_components.progress, "" },
        { " ", "" },
        { b_components.file_modified(" "), "magenta" },
      }
    else
      return {
        { b_components.cache_file_size(), "default" },
        { " ", "" },
        { b_components.cache_file_name("[No Name]", ""), "magenta" },
        { " ", "" },
        { b_components.file_modified(" "), "magenta" },
      }
    end
  end,
}
basic.file_right = {
  hl_colors = {
    default = hl_list.Black,
    white = { "white", "black" },
    magenta = { "magenta", "black" },
  },
  text = function(_, _, width)
    if width < breakpoint_width then
      return {
        { b_components.line_col, "white" },
        { b_components.progress, "" },
      }
    end
  end,
}
basic.git = {
  name = "git",
  hl_colors = {
    green = { "green", "black_light" },
    red = { "red", "black_light" },
    blue = { "blue", "black_light" },
    trans = { "transparent", "transparent" },
    spacer = { "black_light", "black_light" },
    sep = { "black_light", "grey" },
    septwo = { "black_light", "black" },
  },
  width = breakpoint_width,
  text = function()
    if git_comps.is_git() then
      if not packer_plugins["neomake"].loaded then
        return {
          { helper.separators.slant_left, "septwo" },
          { " ", "spacer" },
          {
            git_comps.diff_added({
              format = " %s",
              show_zero = true,
            }),
            "green",
          },
          {
            git_comps.diff_removed({
              format = "  %s",
              show_zero = true,
            }),
            "red",
          },
          {
            git_comps.diff_changed({
              format = " 柳%s",
              show_zero = true,
            }),
            "blue",
          },
        }
      end
    end
    if git_comps.is_git() then
      if packer_plugins["neomake"].loaded then
        return {
          { helper.separators.slant_left, "sep" },
          { " ", "spacer" },
          {
            git_comps.diff_added({
              format = " %s",
              show_zero = true,
            }),
            "green",
          },
          {
            git_comps.diff_removed({
              format = "  %s",
              show_zero = true,
            }),
            "red",
          },
          {
            git_comps.diff_changed({
              format = " 柳%s",
              show_zero = true,
            }),
            "blue",
          },
        }
      end
    end
    return ""
  end,
}

basic.make = {
  name = "make",
  hl_colors = {
    green = { "green", "grey" },
    red = { "red", "grey" },
    sep = { "grey", "black" },
    spacer = { "black", "grey" },
    wave_anim1 = { "waveright2", "grey" },
    wave_anim2 = { "waveright3", "grey" },
    wave_anim3 = { "waveright4", "grey" },
    wave_anim4 = { "waveright5", "grey" },
    wave_anim5 = { "waveright6", "grey" },
    wave_anim6 = { "waveright7", "grey" },
  },
  width = breakpoint_width,
  text = function()
    if packer_plugins["neomake"].loaded then
      if make:GetRunning() then
        return {
          { helper.separators.slant_left, "sep" },
          { " ", "spacer" },
          { "", "wave_anim1" },
          { " ", "spacer" },
          { "M", "wave_anim2" },
          { "a", "wave_anim3" },
          { "k", "wave_anim4" },
          { "e", "wave_anim5" },
          { " ", "spacer" },
          { loading_text, "wave_anim6" },
          { " ", "spacer" },
        }
      end
      if make.failed then
        return {
          { helper.separators.slant_left, "sep" },
          { " ", "spacer" },
          { make:Status(), "red" },
        }
      end
      return {
        { helper.separators.slant_left, "sep" },
        { " ", "spacer" },
        { make:Status(), "green" },
      }
    end
    return ""
  end,
}

basic.lsp_names = {
  name = "lsp_names",
  hl_colors = {
    green = { "green", "black" },
    magenta = { "magenta", "black" },
    sep = { "black", "transparent" },
    sepdebug = { "black", "debug_yellow" },
    spacer = { "black", "black" },
  },
  width = breakpoint_width,
  text = function()
    if lsp_comps.check_lsp() then
      local debug = require("plugins.dap.attach")
      local lsp_status = require("plugins.lspStatus").lsp_status
      return {
        {
          helper.separators.slant_left,
          debug:session() and "sepdebug" or "sep",
        },
        { " ", "spacer" },
        { lsp_comps.lsp_name(), "magenta" },
        { " ", "spacer" },
        { helper.separators.slant_left_thin, "magenta" },
        { lsp_status.status(), "magenta" },
      }
    end
    return ""
  end,
}

basic.gh_num = {
  name = "gh_num",
  hl_colors = {
    green = { "green", "black" },
    magenta = { "magenta", "black_light" },
    sep = { "black", "transparent" },
    sepdebug = { "black", "yellow" },
    spacer = { "black", "black_light" },
  },
  width = breakpoint_width,
  text = function()
    if git_comps.is_git() then
      local num = require("github-notifications").statusline_notification_count
      return {
        { " ", "spacer" },
        { num, "magenta" },
      }
    end
    return ""
  end,
}

basic.dap = {
  name = "dap",
  hl_colors = {
    yellow = { "debug_red", "debug_yellow" },
    spacer = { "debug_yellow", "debug_yellow" },
    sep = { "debug_yellow", "transparent" },
  },
  width = breakpoint_width,
  text = function()
    local debug = require("plugins.dap.attach")
    if debug.dap then
      if debug.dap.session() then
        local status = debug:getStatus()
        return {
          { helper.separators.slant_left, "sep" },
          { " ", "spacer" },
          { "DAP: " .. status .. " ", "yellow" },
        }
      end
    end
    return ""
  end,
}

local quickfix = {
  filetypes = { "qf", "Trouble" },
  active = {
    { "🚦 Quickfix ", { "white", "black" } },
    { helper.separators.slant_right, { "black", "black_light" } },
    {
      function()
        return vim.fn.getqflist({ title = 0 }).title
      end,
      { "cyan", "black_light" },
    },
    { " Total : %L ", { "cyan", "black_light" } },
    { helper.separators.slant_right, { "black_light", "transparent" } },
    { " ", { "InactiveFg", "transparent" } },
    basic.divider,
    { helper.separators.slant_left_2, { "black", "transparent" } },
    { "🧛 ", { "white", "black" } },
  },
  always_active = true,
}

local explorer = {
  filetypes = { "fern", "NvimTree", "lir" },
  active = {
    { "  ", { "white", "black" } },
    { helper.separators.slant_right, { "black", "transparent" } },
    { b_components.divider, "" },
    { helper.separators.slant_left, { "black_light", "transparent" } },
    { b_components.file_name(""), { "white", "black_light" } },
  },
  always_active = true,
  show_last_status = true,
}

local repl = {
  filetypes = { "dap-repl" },
  active = {
    { "  ", { "white", "black" } },
    { helper.separators.slant_right, { "black", "transparent" } },
    { b_components.divider, "" },
    { helper.separators.slant_left, { "black_light", "transparent" } },
    { b_components.file_name(""), { "white", "black_light" } },
  },
  always_active = true,
  show_last_status = true,
}

local dashboard = {
  filetypes = { "dashboard" },
  active = {
    { " ", { "transparent", "transparent" } },
  },
  always_active = true,
  show_last_status = true,
}

local default = {
  filetypes = { "default", "terminal" },
  active = {
    basic.vi_mode,
    basic.file,
    basic.lsp_diagnos,
    basic.divider,
    basic.file_right,
    basic.dap,
    basic.lsp_names,
    --basic.lsp_workspace,
    basic.make,
    basic.git,
    basic.gh_num,
    {
      git_comps.git_branch(),
      { "magenta", "black_light" },
      breakpoint_width,
    },
    { " ", { "black_light", "black_light" } },
  },
  always_active = true,
  show_last_status = true,
  inactive = {
    basic.vi_mode,
    basic.file,
    basic.divider,
    basic.file_right,
    basic.git,
    { git_comps.git_branch(), { "magenta", "black" }, breakpoint_width },
    { " ", hl_list.Black },
  },
}

windline.setup({
  colors_name = function(colors)
    -- print(vim.inspect(colors))
    -- ADD MORE COLOR HERE ----
    colors.FilenameFg = colors.white_light
    colors.FilenameBg = colors.black_light
    colors.transparent = "none"
    colors.grey = "#3d3d3d"
    colors.orange = "#d8a657"
    colors.debug_yellow = "#eae611"
    colors.debug_red = "#ff6902"

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

animation.stop_all()

animation.animation({
  data = {
    { "waveright1", efffects.list_color(anim_colors, 2) },
    { "waveright2", efffects.list_color(anim_colors, 3) },
    { "waveright3", efffects.list_color(anim_colors, 4) },
    { "waveright4", efffects.list_color(anim_colors, 5) },
    { "waveright5", efffects.list_color(anim_colors, 6) },
    { "waveright6", efffects.list_color(anim_colors, 7) },
    { "waveright7", efffects.list_color(anim_colors, 8) },
    { "waveright8", efffects.list_color(anim_colors, 9) },
    { "waveright9", efffects.list_color(anim_colors, 10) },
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
  effect = efffects.list_text(loading),
  on_tick = function(value)
    loading_text = value
  end,
})
