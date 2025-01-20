local config = {}

local fzf_lua = require("fzf-lua")

---@class fzf-lua-ast-grep.AstGrepOptions
---@field command string
---@field args string[]

---@class fzf-lua-ast-grep.Config
---@field fzf_options      table<string, unknown>
---@field ast_grep_options fzf-lua-ast-grep.AstGrepOptions

local config_loaded = false

---@type fzf-lua-ast-grep.Config
local default_config = {
    fzf_options = {
        prompt = "Grep AST> ",
        fn_transform = function(entry)
            return fzf_lua.make_entry.file(entry, {
                file_icons = true,
                color_icons = true,
            })
        end,
        previewer = "builtin",
        actions = {
            ["enter"] = fzf_lua.actions.file_edit,
            ["ctrl-s"] = fzf_lua.actions.file_split,
            ["ctrl-v"] = fzf_lua.actions.file_vsplit,
            ["ctrl-t"] = fzf_lua.actions.file_tabedit,
            ["ctrl-r"] = {}, -- Regex search file results
            ["ctrl-f"] = {}, -- Filter file results by name
            ["ctrl-q"] = { -- Send all results to the quickfix list
                fn = fzf_lua.actions.file_edit_or_qf,
                prefix = "select-all+",
            },
        },
    },
    ast_grep_options = {
        command = "sg",
        args = {
            "run",
            "--color=always",
            "--heading=never",
            "--pattern",
        },
    },
}

--- Check if a value is a valid string option
---@param value any
---@return boolean
function config.valid_string_option(value)
    return value ~= nil and type(value) == "string" and #value > 0
end

local function is_positive_non_zero_number(value)
    return type(value) == "number" and value > 0
end

local function is_non_empty_string(value)
    return type(value) == "string" and #value > 0
end

---@param element_type "number" | "string"
---@return fun(value: unknown): boolean
local function array_validator(element_type)
    return function(value)
        if not vim.islist(value) then
            return false
        end

        for _, element in ipairs(value) do
            if type(element) ~= element_type then
                return false
            end
        end

        return true
    end
end

---@param object table<string, unknown>
---@param schema table<string, unknown>
---@return table
local function validate_schema(object, schema)
    local errors = {}

    for key, value in pairs(schema) do
        if type(value) == "string" then
            local ok, err = pcall(vim.validate, { [key] = { object[key], value } })

            if not ok then
                table.insert(errors, err)
            end
        elseif type(value) == "table" then
            if type(object) ~= "table" then
                table.insert(errors, "Expected a table at key " .. key)
            else
                if vim.is_callable(value[1]) then
                    local ok, err = pcall(vim.validate, {
                        [key] = { object[key], value[1], value[2] },
                    })

                    if not ok then
                        table.insert(errors, err)
                    end
                else
                    vim.list_extend(errors, validate_schema(object[key], value))
                end
            end
        end
    end

    return errors
end

local expected_non_empty_string = "Expected a non-empty string"

local non_empty_string_validator = { is_non_empty_string, expected_non_empty_string }

local is_positive_non_zero_number_validator =
    { is_positive_non_zero_number, "a positive, non-zero number" }

--- Validate a config
---@param _config fzf-lua-ast-grep.Config
---@return boolean
---@return any?
function config.validate(_config)
    -- TODO: Validate superfluous keys

    -- stylua: ignore start
    local config_schema = {
        fzf_options = {},
        ast_grep_options = {
            command = non_empty_string_validator,
            args = array_validator("string"),
        },
    }
    -- stylua: ignore end

    local errors = validate_schema(_config, config_schema)

    return #errors == 0, errors
end

---@type fzf-lua-ast-grep.Config
local _user_config = default_config

---Use in testing
---@private
function config._default_config()
    return default_config
end

---@param user_config? fzf-lua-ast-grep.Config
function config.configure(user_config)
    _user_config = vim.tbl_deep_extend("keep", user_config or {}, default_config)

    local ok, error = config.validate(_user_config)

    if not ok then
        -- message.error("Errors found in config: " .. table.concat(error, "\n"))
    else
        config_loaded = true
    end

    return ok
end

setmetatable(config, {
    __index = function(_, key)
        -- Lazily load configuration so there is no need to call configure explicitly
        if not config_loaded then
            config.configure()
        end

        return _user_config[key]
    end,
})

return config
