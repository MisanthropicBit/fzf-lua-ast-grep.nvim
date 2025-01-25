local fzf_lua_ast_grep = {}

local has_fzf_lua, fzf_lua = pcall(require, "fzf-lua")

if not has_fzf_lua then
    error("[fzf-lua-ast-grep.nvim]: fzf-lua.nvim is not installed")
end

local config = require("fzf-lua-ast-grep.config")
local utils = require("fzf-lua-ast-grep.utils")

local fzf_lua_ast_grep_version = "0.1.0"

function fzf_lua_ast_grep.version()
    return fzf_lua_ast_grep_version
end

function fzf_lua_ast_grep.regex_search_action(_, options)
    options.__ACT_TO({
        resume = true,
    })
end

--- Create a function that will generate the new query on each keystroke
---@param base_command string base ast-grep command
---@return fun(query: string): string
local function create_live_query_func(base_command)
    return function(query)
        local new_query, user_flags = utils.parse_additional_args(query)
        local formatted_user_flags = ""

        if user_flags and #user_flags > 0 then
            formatted_user_flags = " " .. table.concat(user_flags, " ")
        end

        local final_query = ("%s%s --pattern '%s'"):format(
            base_command,
            formatted_user_flags,
            new_query
        )

        return final_query
    end
end

---@param options fzf-lua-ast-grep.Options?
function fzf_lua_ast_grep.ast_live_grep(options)
    local fzf_lua_options = vim.tbl_deep_extend(
        "force",
        config.fzf_lua_options,
        options and options.fzf_lua_options or {}
    )

    local base_command = ("%s %s"):format(
        config.ast_grep_options.command,
        table.concat(config.ast_grep_options.args, " ")
    )

    -- Disable treesitter as it collides with cmd regex highlighting
    fzf_lua_options._treesitter = false

    -- Inherit global opts (highlights, etc) for headers
    fzf_lua_options = fzf_lua.config.normalize_opts(fzf_lua_options, {})
    fzf_lua_options =
        fzf_lua.core.set_header(fzf_lua_options, fzf_lua_options.headers or { "actions", "cwd" })

    fzf_lua_options.__call_fn = fzf_lua.utils.__FNCREF2__()
    fzf_lua_options.__ACT_TO = fzf_lua_options.__ACT_TO or fzf_lua.grep

    -- Set up options for "FzfLua resume" support
    -- fzf_lua_options.__FNCREF__ = fzf_lua_options.__FNCREF__ or fzf_lua.utils.__FNCREF__()
    fzf_lua_options.query = fzf_lua_options.query or fzf_lua.config.__resume_data.last_query

    -- Prepend prompt with "*" to indicate "live" query
    fzf_lua_options.prompt = type(fzf_lua_options.prompt) == "string" and fzf_lua_options.prompt
        or "> "

    if fzf_lua_options.live_ast_prefix ~= false then
        fzf_lua_options.prompt = fzf_lua_options.prompt:match("^%*") and fzf_lua_options.prompt
            or ("*" .. fzf_lua_options.prompt)
    end

    -- TODO: Try with fzf_exec
    fzf_lua.fzf_live(create_live_query_func(base_command), fzf_lua_options)
end

-- Inject the extension into the fzf-lua module so users can run "FzfLua ast-grep"
fzf_lua.ast_live_grep = fzf_lua_ast_grep.ast_live_grep

return fzf_lua_ast_grep
