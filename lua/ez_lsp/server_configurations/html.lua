---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = "html",
    filetypes = { "html" },

    root_indicators = {
        "package.json",
        ".git",
    },
    command = {
        "vscode-html-language-server",
        "--stdio",
    },
    single_file_support = true,
    init_options = {
        provideFormatter = true,
        embeddedLanguages = {
            css = true,
            javascript = true,
        },
        configurationSection = {
            "html",
            "css",
            "javascript",
        },
    },
    description = "Provides language server support for HTML files.",
    command_installation_help = [[
        `vscode-html-language-server` is a part of
        [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted)
        which can be installed via `npm`:

        ```sh
        npm i -g vscode-langservers-extracted
        ```
    ]],
}

return Module
