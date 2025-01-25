local health = {}

local compat = require("fzf-lua-ast-grep.compat")
local config = require("fzf-lua-ast-grep.config")

local min_neovim_version = "0.9.0"

function health.check()
    vim.health.start("fzf-lua-ast-grep")

    if compat.has("nvim-" .. min_neovim_version) then
        vim.health.ok(("has neovim %s+"):format(min_neovim_version))
    else
        vim.health.error("fzf-lua-ast-grep.nvim requires at least neovim " .. min_neovim_version)
    end

    local has_fzf_lua, _ = pcall(require, "fzf-lua")

    if has_fzf_lua then
        vim.health.ok("fzf-lua.nvim installed")
    else
        vim.health.error("fzf-lua.nvim not installed")
    end

    local ast_grep_version = vim.fn.system("sg --version")

    if vim.v.shell_error == 0 then
        local ast_grep_path = vim.fn.exepath("sg")

        vim.health.ok(("%s installed (%s)"):format(vim.fn.trim(ast_grep_version, "\n", 2), ast_grep_path))
    else
        vim.health.error("ast-grep not installed or not available on path")
    end

    local ok, error = config.validate(config)

    if ok then
        vim.health.ok("found no errors in config")
    else
        vim.health.error("config has errors: " .. error)
    end
end

return health
