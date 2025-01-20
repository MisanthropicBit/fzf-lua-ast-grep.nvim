rockspec_format = "3.0"
package = "fzf-lua-ast-grep.nvim"
version = "scm-1"

description = {
  summary = "fzf-lua.nvim plugin for using ast-grep",
  detailed = [[]],
  labels = {
    "neovim",
    "plugin",
    "fzf-lua",
    "ast-grep",
  },
  homepage = "https://github.com/MisanthropicBit/fzf-lua-ast-grep.nvim",
  issues_url = "https://github.com/MisanthropicBit/fzf-lua-ast-grep.nvim/issues",
  license = "BSD 3-Clause",
}

dependencies = {
  "lua == 5.1",
}

source = {
   url = "git://github.com/MisanthropicBit/fzf-lua-ast-grep.nvim",
}

build = {
   type = "builtin",
   copy_directories = {
     "doc",
     "plugin",
   },
}

test_dependencies = {
    "busted >= 2.2.0, < 3.0.0",
}

test = {
    type = "command",
    command = "nvim -l ./run-tests.lua",
}
