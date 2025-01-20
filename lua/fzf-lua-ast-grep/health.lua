local health = {}

local compat = require("fzf-lua-ast-grep.compat")
local config = require("fzf-lua-ast-grep.config")

local min_neovim_version = "0.9.0"
local report_start, report_ok, report_error

---@diagnostic disable-next-line: deprecated
report_start = vim.health.report_start
---@diagnostic disable-next-line: deprecated
report_ok = vim.health.report_ok
---@diagnostic disable-next-line: deprecated
report_error = vim.health.report_error
---@diagnostic disable-next-line: deprecated

function health.check()
    report_start("fzf-lua-ast-grep")

    if compat.has("nvim-" .. min_neovim_version) then
        report_ok(("has neovim %s+"):format(min_neovim_version))
    else
        report_error("fzf-lua-ast-grep.nvim requires at least neovim " .. min_neovim_version)
    end

    local has_fzf_lua, _ = pcall(require, "fzf-lua")

    if has_fzf_lua then
        report_ok("fzf-lua.nvim installed")
    else
        report_error("fzf-lua.nvim not installed")
    end

    local ast_grep_version = vim.fn.system("sg --version")

    if vim.v.shell_error == 0 then
        report_ok(ast_grep_version .. " installed")
    else
        report_error("ast-grep not installed or not available on path")
    end

    local ok, error = config.validate(config)

    if ok then
        report_ok("found no errors in config")
    else
        report_error("config has errors: " .. error)
    end
end

return health
