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

---@param options fzf-lua-ast-grep.Options?
function fzf_lua_ast_grep.ast_live_grep(options)
    local fzf_options =
        vim.tbl_deep_extend("force", config.fzf_options, options and options.fzf_options or {})

    local base_command = ("%s %s"):format(
        config.ast_grep_options.command,
        table.concat(config.ast_grep_options.args, " ")
    )
    -- Disable treesitter as it collides with cmd regex highlighting
    fzf_options._treesitter = false

    fzf_options = fzf_lua.core.set_header(fzf_options, fzf_options.headers or { "actions", "cwd" })
    fzf_options.__call_fn = fzf_lua.utils.__FNCREF2__()

    -- Set up options for "FzfLua resume" support
    fzf_options.__FNCREF__ = fzf_options.__FNCREF__ or fzf_lua.utils.__FNCREF__()
    fzf_options.query = fzf_options.query or fzf_lua.config.__resume_data.last_query

    -- TODO: prepend prompt with "*" to indicate "live" query
    -- https://github.com/ibhagwan/fzf-lua/blob/6f7249741168c0751356e3b6c5c1e3bade833b6b/lua/fzf-lua/providers/grep.lua#L213C1-L217

    -- Prepend prompt with "*" to indicate "live" query
    fzf_options.prompt = type(fzf_options.prompt) == "string" and fzf_options.prompt or "> "

    if fzf_options.live_ast_prefix ~= false then
        fzf_options.prompt = fzf_options.prompt:match("^%*") and fzf_options.prompt
            or ("*" .. fzf_options.prompt)
    end

    fzf_lua.fzf_live(function(query)
        local new_query, user_flags = utils.parse_additional_args(query)
        local formatted_user_flags = ""

        if user_flags and #user_flags > 0 then
            formatted_user_flags = " " .. table.concat(user_flags, " ")
        end

        return ("%s%s --pattern '%s'"):format(base_command, formatted_user_flags, new_query)
    end, fzf_options)
end

-- Inject the extension into the fzf-lua module so users can run "FzfLua ast-grep"
fzf_lua.ast_live_grep = fzf_lua_ast_grep.ast_live_grep

return fzf_lua_ast_grep
