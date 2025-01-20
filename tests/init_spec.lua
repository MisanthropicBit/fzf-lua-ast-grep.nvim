local utils = require("fzf-lua-ast-grep.utils")

describe("init", function()
    describe("parse_additional_args", function()
        local cmd_prefix = "sg run --color=always --heading=never"
        local parse_func = utils.parse_additional_args

        it("parses additional arguments", function()
            local args, extra_args = parse_func(cmd_prefix .. " -- --interactive -A3")
            assert.same(args, cmd_prefix)
            assert.same(extra_args, { "--interactive", "-A3" })
        end)

        it("does not parse additional non-flag arguments", function()
            local args, extra_args = parse_func(cmd_prefix .. " -- ##ok")

            assert.same(args, cmd_prefix)
            assert.same(extra_args, {})
        end)

        it("handles empty space beyond '--'", function()
            local args, extra_args = parse_func(cmd_prefix .. " -- ")

            assert.same(args, cmd_prefix)
            assert.is_nil(extra_args)
        end)

        it("handles nothing beyond '--'", function()
            local args, extra_args = parse_func(cmd_prefix .. " --")

            assert.same(args, cmd_prefix)
            assert.is_nil(extra_args)
        end)
    end)
end)
