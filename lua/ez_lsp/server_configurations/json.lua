---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = "json",
    filetypes = { "json", "jsonc" },
    root_indicators = {
        ".git",
    },
    command = {
        "vscode-json-language-server",
        "--stdio",
    },
    single_file_support = true,
    init_options = {
        provideFormatter = true,
    },
    settings = {
        json = {
            schemas = require("ez_lsp.server_configurations.jsonschema_mappings"),
        },
    },
    description = "Provides language server support for json and jsonc files.",
    command_installation_help = [[
        `vscode-json-language-server` is a part of [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) which
        can be installed via `npm`:

        ```sh
        npm i -g vscode-langservers-extracted
        ```
    ]],
}

return Module

--   setup = {
--       commands = {
--           Format = {
--               function()
--                   vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
--               end,
--           },
--       },
--   },
