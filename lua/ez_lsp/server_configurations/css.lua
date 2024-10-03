---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = "css",
    filetypes = { "css", "scss", "less" },
    root_indicators = {
        "package.json",
        ".git",
    },
    command = {
        "vscode-css-language-server",
        "--stdio",
    },
    single_file_support = true,
    settings = {
        css = {
            validate = true,
        },
        scss = {
            validate = true,
        },
        less = {
            validate = true,
        },
    },
    description = [[Provides language server support for CSS, SCSS, & LESS files.]],
    command_installation_help = [[
        `vscode-css-language-server` is a part of
        [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted)
        and can be installed via `npm`:

        ```sh
        npm i -g vscode-langservers-extracted
        ```
    ]],
}

return Module
