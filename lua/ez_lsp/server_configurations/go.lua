---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = "go",
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_indicators = {
        "go.work",
        "go.mod",
        ".git",
    },
    command = {
        "gopls",
    },
    single_file_support = true,
    description = [[Provides language server support for Go files.]],
    command_installation_help = [[
        [gopls](https://github.com/golang/tools/tree/master/gopls) can be installed
        via `go`:

        ```sh
        go install gopls
        ```
    ]],
}

return Module
