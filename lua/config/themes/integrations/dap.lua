local colors = require("config.themes").get_colors("base_30")

return {
  -- Dap
  DapBreakpoint = { fg = colors.red },
  DapBreakpointCondition = { fg = colors.yellow },
  DapLogPoint = { fg = colors.cyan },
  DapStopped = { fg = colors.baby_pink },

  -- DapUI
  DAPUIScope = { fg = colors.cyan },
  DAPUIType = { fg = colors.dark_purple },
  DAPUIValue = { fg = colors.cyan },
  DAPUIVariable = { fg = colors.white },
  DapUIModifiedValue = { fg = colors.orange },
  DapUIDecoration = { fg = colors.cyan },
  DapUIThread = { fg = colors.green },
  DapUIStoppedThread = { fg = colors.cyan },
  DapUISource = { fg = colors.lavender },
  DapUILineNumber = { fg = colors.cyan },
  DapUIFloatBorder = { fg = colors.cyan },

  DapUIWatchesEmpty = { fg = colors.baby_pink },
  DapUIWatchesValue = { fg = colors.green },
  DapUIWatchesError = { fg = colors.baby_pink },

  DapUIBreakpointsPath = { fg = colors.cyan },
  DapUIBreakpointsInfo = { fg = colors.green },
  DapUIBreakPointsCurrentLine = { fg = colors.green, bold = true },
  DapUIBreakpointsDisabledLine = { fg = colors.grey_fg2 },

  DapUIStepOver = { fg = colors.blue },
  DapUIStepOverNC = { fg = colors.blue },
  DapUIStepInto = { fg = colors.blue },
  DapUIStepIntoNC = { fg = colors.blue },
  DapUIStepBack = { fg = colors.blue },
  DapUIStepBackNC = { fg = colors.blue },
  DapUIStepOut = { fg = colors.blue },
  DapUIStepOutNC = { fg = colors.blue },
  DapUIStop = { fg = colors.red },
  DapUIStopNC = { fg = colors.red },
  DapUIPlayPause = { fg = colors.green },
  DapUIPlayPauseNC = { fg = colors.green },
  DapUIRestart = { fg = colors.green },
  DapUIRestartNC = { fg = colors.green },
  DapUIUnavailable = { fg = colors.grey_fg },
  DapUIUnavailableNC = { fg = colors.grey_fg },
}
