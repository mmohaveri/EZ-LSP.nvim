---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = "typescript",
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },

    root_indicators = {
        ".git",
        "package.json",
        "tsconfig.json",
        "jsconfig.json",
    },
    command = {
        "typescript-language-server",
        "--stdio",
    },
    single_file_support = true,
    init_options = {
        hostInfo = "neovim",
    },
    description = "Provides language server support for JavaScript & TypeScript files.",
    command_installation_help = [[
        Uses [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)
        which depends on typescript. Both can be installed via `npm`:

        ```sh
        npm i -g typescript typescript-language-server
        ```
    ]],
    enabled = function() return require("ez_lsp.server_configurations.vue_helper").is_not_part_of_vue_project() end,
}

return Module
