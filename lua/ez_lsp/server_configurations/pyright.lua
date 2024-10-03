---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = "pyright",
    filetypes = { "python" },
    root_indicators = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git",
    },
    command = {
        "pyright-langserver",
        "--stdio",
    },
    single_file_support = true,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
        },
    },
    user_commands = {
        {
            name = "PyrightOrganizeImports",
            description = "Organize imports using pyright",
            callback = function()
                vim.lsp.buf.execute_command({
                    command = "pyright.organizeimports",
                    arguments = {
                        vim.uri_from_bufnr(0),
                    },
                })
            end,
        },
    },
    description = "Provides langserver support for Python files.",
    command_installation_help = [[lsp
    [pyright](https://github.com/microsoft/pyright) can be installed via pip or pipx:

        ```sh
        pip install pyright
        ```

        ```sh
        pipx install pyright
        ````
    ]],
}

return Module
