local config = require("fzf-lua-ast-grep.config")
local message = require("fzf-lua-ast-grep.message")
local stub = require("luassert.stub")

describe("config", function()
    it("handles invalid configs", function()
        local invalid_configs = {
            { fzf_lua_options = true },
            { ast_grep_options = { command = "" } },
            { ast_grep_options = { command = 1 } },
            { ast_grep_options = { command = "sg", args = 1 } },
            { ast_grep_options = { command = "sg", args = { "a", true } } },
        }

        stub(message, "error")

        for _, invalid_config in ipairs(invalid_configs) do
            local ok = config.configure(invalid_config)

            if ok then
                vim.print(invalid_config)
            end

            assert.is_false(ok)
        end

        assert.stub(message.error).was.called(#invalid_configs)

        ---@diagnostic disable-next-line: undefined-field
        message.error:revert()
    end)

    it("throws no errors for a valid config", function()
        assert.is_true(config.configure(config._default_config()))
    end)

    it("throws no errors for empty user config", function()
        ---@diagnostic disable-next-line: missing-fields
        assert.is_true(config.configure({}))
    end)

    it("throws no errors for no user config", function()
        assert.is_true(config.configure())
    end)
end)
