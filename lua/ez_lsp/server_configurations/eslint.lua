local _SERVER_NAME = "eslint-language-server"

local function _eslint_fix_all()
    vim.notify("Fixing all eslint problems", vim.log.levels.INFO)
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({
        bufnr = bufnr,
        name = _SERVER_NAME,
    })
    if clients == nil or #clients == 0 then
        vim.notify("Failed to get the `" .. _SERVER_NAME .. "` client on buffer `" .. bufnr("`."), vim.log.levels.ERROR)
        return
    end

    local eslint_lsp_client = clients[1]

    local params = {
        command = "eslint.applyAllFixes",
        arguments = {
            {
                uri = vim.uri_from_bufnr(bufnr),
                version = vim.lsp.util.buf_versions[bufnr],
            },
        },
    }

    -- TODO: Handle error
    eslint_lsp_client.request_sync("workspace/executeCommand", params, nil, bufnr)
    vim.notify("All eslint problems fixed.", vim.log.levels.INFO)
end

---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = _SERVER_NAME,

    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
        "svelte",
        "astro",
    },
    root_indicators = {
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc.json",
        "eslint.config.js",
        "package.json",
        ".git",
    },
    command = {
        "vscode-eslint-language-server",
        "--stdio",
    },
    -- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
    settings = {
        validate = "on",
        packageManager = nil,
        useESLintClass = false,
        experimental = {
            useFlatConfig = false,
        },
        codeActionOnSave = {
            enable = false,
            mode = "all",
        },
        format = true,
        quiet = false,
        onIgnoredFiles = "off",
        rulesCustomizations = {},
        run = "onType",
        problems = {
            shortenToSingleLine = false,
        },
        -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
        -- This path is relative to the workspace folder (root dir) of the server instance.
        nodePath = "",
        -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
        workingDirectory = {
            mode = "location",
        },
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = "separateLine",
            },
            showDocumentation = {
                enable = true,
            },
        },
    },
    lifecycle_handlers = {
        on_new_config = function(config, new_root_dir)
            -- The "workspaceFolder" is a VSCode concept. It limits how far the
            -- server will traverse the file system when locating the ESLint config
            -- file (e.g., .eslintrc).
            config.settings.workspaceFolder = {
                uri = new_root_dir,
                name = vim.fn.fnamemodify(new_root_dir, ":t"),
            }

            -- Support flat config
            if vim.fn.filereadable(new_root_dir .. "/eslint.config.js") == 1 then
                config.settings.experimental.useFlatConfig = true
            end
        end,
        on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
            })
        end,
    },
    event_handlers = {
        {
            event_name = "eslint/openDoc",
            callback = function(_, result)
                if not result then return end
                os.execute(string.format("xdg-open %q", result.url))
                return {}
            end,
        },
        {
            event_name = "eslint/confirmESLintExecution",
            callback = function(_, result)
                if not result then return end
                return 4 -- approved
            end,
        },
        {
            event_name = "eslint/probeFailed",
            callback = function()
                vim.notify("[eslint LSP] ESLint probe failed.", vim.log.levels.WARN)
                return {}
            end,
        },
        {
            event_name = "eslint/noLibrary",
            callback = function()
                vim.notify("[eslint LSP] Unable to find ESLint library.", vim.log.levels.WARN)
                return {}
            end,
        },
    },
    user_commands = {
        {
            name = "EslintFixAll",
            description = "Fix all eslint problems for this buffer",
            callback = _eslint_fix_all,
        },
    },
    description = "Provides ESLint as a language server.",
    command_installation_help = [[
        `vscode-eslint-language-server` is a part of
        [vscode-langservers-extracted](https://github.com/hrsh7ty/vscode-langservers-extracted) which can
        be installed via npm:

        ```sh
        npm i -g vscode-langservers-extracted
        ```
    ]],
}

-- local lsp = require("lsp_config.utils.lsp")

return Module
