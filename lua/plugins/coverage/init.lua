local cmd = vim.cmd
local g = vim.g
-- for coverage
--" Specify the path to `coverage.json` file relative to your current working directory.
g.coverage_json_report_path = "coverage/coverage-final.json"
g.coverage_sign_covered = "⦿"
g.coverage_interval = 5000
g.coverage_show_covered = 0
g.coverage_show_uncovered = 0

COVERAGE = {}

COVERAGE.disable = function()
    if g.coverage_show_covered == 1 then
        g.coverage_show_covered = 0
    end
    if g.coverage_show_uncovered == 1 then
        g.coverage_show_uncovered = 0
    end
end

COVERAGE.enable = function()
    if g.coverage_show_covered == 0 then
        g.coverage_show_covered = 1
    end
    if g.coverage_show_uncovered == 0 then
        g.coverage_show_uncovered = 1
    end
end

cmd [[command! CoverageEnable packadd packer.nvim | lua COVERAGE.enable()]]
cmd [[command! CoverageDisable packadd packer.nvim | lua COVERAGE.disable()]]
