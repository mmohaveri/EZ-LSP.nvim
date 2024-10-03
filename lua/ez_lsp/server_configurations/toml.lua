---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = "toml",
    filetypes = { "toml" },

    root_indicators = {
        ".git",
    },
    command = {
        "taplo",
        "lsp",
        "stdio",
    },
    single_file_support = true,
    description = "Provides language server support for TOML files.",
    command_installation_help = [[
        [Taplo language server](https://taplo.tamasfe.dev) can be installed
        via cargo:

        ```sh
        cargo install --features lsp --locked taplo-cli
        ```
    ]],
}

return Module
