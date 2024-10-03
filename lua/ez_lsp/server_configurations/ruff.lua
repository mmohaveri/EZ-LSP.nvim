---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = "ruff",
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
        "ruff",
        "server",
    },
    single_file_support = true,
    description = "Provides linting for python files as a Language server.",
    command_installation_help = [[
        `ruff` can be installed via `pip` or `pipx`:

        ```sh
        pip install ruff
        ```
        ```sh
        pipx install ruff
        ```
    ]],
}

return Module
