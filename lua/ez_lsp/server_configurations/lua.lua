---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = "lua",
    filetypes = { "lua" },
    root_indicators = {
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        "selene.yaml",
        ".git",
    },
    command = {
        "lua-language-server",
        "--metapath",
        vim.fn.stdpath("cache") .. "/lua-language-server",
    },
    single_file_support = true,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            telemetry = {
                enable = false,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
    description = "Provides language server support for Lua files.",
    command_installation_help = [[
        Uses [lua-language-server](https://github.com/luals/lua-language-server).
        On MacOS it can be installed using homebrew:

        ```sh
        brew install lua-language-server
        ```

        On Linux, it can be installed by downloading the binary from
        [github](https://github.com/LuaLS/lua-language-server/releases)
        and moving it to a directory in your `PATH`.
    ]],
}

return Module
