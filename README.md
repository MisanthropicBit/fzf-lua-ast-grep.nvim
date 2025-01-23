<div align="center">
  <br />
  <h1>fzf-lua-ast-grep.nvim</h1>
  <p><i>fzf-lua.nvim plugin for using ast-grep</i></p>
  <p>
    <img src="https://img.shields.io/badge/version-0.1.0-blue?style=for-the-badge" />
    <img src="https://img.shields.io/badge/Neovim-0.9.0-629751?style=for-the-badge&logo=neovim" />
    <a href="https://luarocks.org/modules/misanthropicbit/fzf-lua-ast-grep.nvim">
        <img src="https://img.shields.io/luarocks/v/misanthropicbit/fzf-lua-ast-grep.nvim?logo=lua&color=purple&style=for-the-badge" />
    </a>
    <a href="/.github/workflows/tests.yml">
        <img src="https://img.shields.io/github/actions/workflow/status/MisanthropicBit/fzf-lua-ast-grep.nvim/tests.yml?branch=master&style=for-the-badge" />
    </a>
    <a href="/LICENSE">
        <img src="https://img.shields.io/github/license/MisanthropicBit/fzf-lua-ast-grep.nvim?style=for-the-badge" />
    </a>
  </p>
  <br />
</div>

<div align="center">

🚧 **This plugin is under development** 🚧

</div>

<!-- panvimdoc-ignore-start -->

- [Requirements](#requirements)
- [Configuration](#configuration)
- [Public API](#public-api)
- [Contributing](#contributing)

<!-- panvimdoc-ignore-end -->

## Requirements

* [fzf-lua.nvim](https://github.com/ibhagwan/fzf-lua)
* [ast-grep](https://github.com/ast-grep/ast-grep)

## Configuration

If you are content with the defaults that are shown below, you don't need to
call the `configure` function.

```lua
require('fzf-lua-ast-grep').configure({
})
```

## Public API

> [!WARNING]  
> Consider only the functions below part of the public API. All other functions
> are subject to change.

#### `fzf_lua_ast_grep.configure`

Configure `fzf_lua_ast_grep`. Also see [Configuration](#configuration).

#### `fzf_lua_ast_grep.ast_live_grep`

## Contributing

See the guidelines [here](/CONTRIBUTING.md).
