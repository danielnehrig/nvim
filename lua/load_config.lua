local M = {}
M.__index = M

-- this is loaded after bootstrapping packer
-- and or if packer plugins are installed
-- load configs for packer plugins
M.init = function()
  require("plugins.web-devicons").init()
  require("plugins.autopairs").init()
  require("plugins.treesitter").init()
  require("plugins.build"):init()
  require("plugins.bufferline").init()

  -- the init is loaded over a autocmd for lazyload
  -- require("plugins.wildmenu")

  -- load last to overwrite every highlight that has been added by a plugin
  require("core.highlights")

  local Job = require("plenary.job")
  CI = { "LOADING" }
  Job
    :new({
      command = "hub",
      args = { "ci-status", "-f", "%t %S%n" },
      on_exit = function(j, return_val)
        CI = j:result()
      end,
    })
    :start()
end

return M
