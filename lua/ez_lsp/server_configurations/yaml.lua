---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = "yaml-language-server",
    filetypes = { "yaml", "yaml.docker-compose" },
    root_indicators = {
        ".git",
    },
    command = {
        "yaml-language-server",
        "--stdio",
    },
    single_file_support = true,
    settings = {
        redhat = {
            telemetry = {
                enabled = false,
            },
        },
        yaml = {
            schemas = require("ez_lsp.server_configurations.jsonschema_mappings"),
        },
    },
    description = "Provides language server support for YAML files.",
    command_installation_help = [[
        [yaml-language-server](https://github.com/redhat-developer/yaml-language-server)
        which can be installed via npm:

        ```sh
        npm i -g yaml-language-server
        ```
    ]],
}

return Module
