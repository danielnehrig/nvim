local M = {}

M.init = function()
  require("crates").setup({
    smart_insert = true, -- try to be smart about inserting versions
    avoid_prerelease = true, -- don't select a prerelease if the requirement does not have a suffix
    autoload = true, -- automatically run update when opening a Cargo.toml
    autoupdate = true, -- atomatically update when editing text
    loading_indicator = true, -- show a loading indicator while fetching crate versions
    text = {
      loading = "   Loading",
      version = "   %s",
      prerelease = "   %s",
      yanked = "   %s",
      nomatch = "   No match",
      update = "   %s",
      error = "   Error fetching crate",
    },
    highlight = {
      loading = "CratesNvimLoading",
      version = "CratesNvimVersion",
      prerelease = "CratesNvimPreRelease",
      yanked = "CratesNvimYanked",
      nomatch = "CratesNvimNoMatch",
      update = "CratesNvimUpdate",
      error = "CratesNvimError",
    },
    popup = {
      autofocus = false, -- focus the versions popup when opening it
      copy_register = '"', -- the register into which the version will be copied
      style = "minimal", -- same as nvim_open_win opts.style
      border = "none", -- same as nvim_open_win opts.border
      max_height = 30,
      min_width = 20,
      text = {
        title = "  %s ",
        version = "   %s ",
        prerelease = "  %s ",
        yanked = "  %s ",
      },
      highlight = {
        title = "CratesNvimPopupTitle",
        version = "CratesNvimPopupVersion",
        prerelease = "CratesNvimPopupPreRelease",
        yanked = "CratesNvimPopupYanked",
      },
      keys = {
        hide = { "q", "<esc>" },
        select = { "<cr>" },
        select_dumb = { "s" },
        copy_version = { "yy" },
      },
    },
    cmp = {
      text = {
        prerelease = "  pre-release ",
        yanked = "  yanked ",
      },
    },
  })
end

return M
