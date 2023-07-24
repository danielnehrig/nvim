local helper = require("windline.helpers")
local b_components = require("windline.components.basic")
local git_comps = require("windline.components.git")
local lsp_comps = require("windline.components.lsp")
local breakpoint_width = 90
local state = _G.WindLine.state

local M = {}

local icon_comp = b_components.cache_file_icon({
  default = "",
  hl_colors = { "white", "black" },
})

local colors_mode = {
  Normal = { "red", "black" },
  Insert = { "green", "black" },
  Visual = { "yellow", "black" },
  Replace = { "blue_light", "black" },
  Command = { "magenta", "black" },
}

local hl_list = {
  Normal = { "NormalFg", "NormalBg" },
  Black = { "white", "black" },
  White = { "black", "white" },
  Inactive = { "InactiveFg", "InactiveBg" },
  Active = { "ActiveFg", "ActiveBg" },
}

M.lsp_diagnos = {
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

M.file = {
  name = "file",
  hl_colors = {
    red = { "red", "black" },
    yellow = { "yellow", "black" },
    magenta = { "magenta", "black" },
    blue = { "blue", "black" },
    trans = { "transparent", "transparent" },
    sep = { "black", "transparent" },
    spacer = { "black", "black" },
    white = { "white", "black" },
  },
  text = function(bufnr, _, width)
    -- local filetype = vim.bo.filetype
    -- local len = string.len(filetype)

    if width > breakpoint_width then
      return {
        icon_comp(bufnr),
        { " ", "" },
        { b_components.cache_file_name("[No Name]", ""), "magenta" },
        { b_components.line_col, "white" },
        { b_components.progress, "white" },
        { " ", "" },
        { b_components.file_modified(" "), "magenta" },
        { " ", "spacer" },
        { helper.separators.slant_right, "sep" },
      }
    else
      return {
        { b_components.cache_file_name("[No Name]", ""), "magenta" },
        { " ", "" },
        { b_components.file_modified(" "), "magenta" },
        { " ", "spacer" },
        { helper.separators.slant_right, "sep" },
      }
    end
  end,
}

M.loading_text = ""
M.compiler = {
  name = "compiler",
  hl_colors = {
    green = { "green", "black" },
    red = { "red", "black" },
    spacer = { "black", "black" },
    wave_anim1 = { "waveright2", "black" },
    wave_anim2 = { "waveright3", "black" },
    wave_anim3 = { "waveright4", "black" },
    wave_anim4 = { "waveright5", "black" },
    wave_anim5 = { "waveright6", "black" },
    wave_anim6 = { "waveright7", "black" },
  },
  width = breakpoint_width,
  text = function()
    local tasks = require("overseer.task_list").list_tasks({ unique = true })
    local tasks_by_status =
      require("overseer.util").tbl_group_by(tasks, "status")
    local running = tasks_by_status["RUNNING"]
    local success = tasks_by_status["SUCCESS"]

    if running then
      return {
        { " ", "spacer" },
        { "", "wave_anim1" },
        { " ", "spacer" },
        { "M", "wave_anim2" },
        { "a", "wave_anim3" },
        { "k", "wave_anim4" },
        { "e", "wave_anim5" },
        { " ", "spacer" },
        { M.loading_text, "wave_anim6" },
        { " ", "spacer" },
      }
    end

    if success then
      return {
        { " ", "spacer" },
        { "", "green" },
        { " ", "spacer" },
      }
    end
    return ""
  end,
}

M.path = {
  name = "path",
  hl_colors = {
    loc = { "white", "transparent" },
  },
  width = breakpoint_width,
  text = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local blacklist_bt = { "terminal", "NvimTree" }
    local blacklist_ft = { "alpha" }
    for _, name in ipairs(blacklist_bt) do
      if vim.bo.buftype == name then
        return ""
      end
    end
    for _, name in ipairs(blacklist_ft) do
      if vim.bo.filetype == name then
        return ""
      end
    end

    local path = vim.fn.fnamemodify(bufname, ":~:.")
    return {
      { path, "" },
      { "", "loc" },
    }
  end,
}
M.gps = {
  name = "gps",
  hl_colors = {
    loc = { "white", "transparent" },
  },
  width = breakpoint_width,
  text = function(bufnr)
    local gps_present, gps = pcall(require, "nvim-navic")

    if gps_present then
      if gps.is_available(bufnr) then
        local location = gps.get_location({}, bufnr)
        return {
          { " ", "" },
          { location, "loc" },
        }
      end
    end
    return ""
  end,
}

M.git = {
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
  end,
}

M.lsp_names = {
  name = "lsp_names",
  hl_colors = {
    green = { "green", "black" },
    magenta = { "magenta", "black" },
    sep = { "black", "transparent" },
    sepdebug = { "black", "debug_bg" },
    spacer = { "black", "black" },
  },
  click = function()
    vim.cmd([[LspInfo]])
  end,
  width = breakpoint_width,
  text = function()
    if lsp_comps.check_lsp() then
      local dap_present, _ = pcall(require, "dap")
      local lsp_present, lsp_status = pcall(require, "lsp-status")
      if lsp_present then
        return {
          {
            helper.separators.slant_left,
            dap_present and "sepdebug" or "sep",
          },
          { " ", "spacer" },
          { lsp_comps.lsp_name(), "magenta" },
          { " ", "spacer" },
          { helper.separators.slant_left_thin, "magenta" },
          { lsp_status.status(), "magenta" },
        }
      end
    end
    return ""
  end,
}

M.vi_mode = {
  name = "vi_mode",
  hl_colors = colors_mode,
  text = function()
    return { { "   ", state.mode[2] } }
  end,
}
M.square_mode = {
  hl_colors = colors_mode,
  text = function()
    return { { "▊", state.mode[2] } }
  end,
}

M.file_right = {
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

M.dap = {
  name = "dap",
  hl_colors = {
    dap_status = { "debug_fg", "debug_bg", "bold" },
    spacer = { "debug_bg", "debug_bg" },
    sep = { "debug_bg", "transparent" },
  },
  width = breakpoint_width,
  text = function()
    local debug = require("config.plugins.configs.dap.attach")
    local status = debug.getStatus()
    if status then
      return {
        { helper.separators.slant_left, "sep" },
        { " ", "spacer" },
        { status .. " ", "dap_status" },
      }
    end
    return ""
  end,
}

return M
