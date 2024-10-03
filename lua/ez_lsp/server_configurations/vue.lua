---@return string
local function _get_global_typescript_lib_path()
    -- Don't forget that vim.fn.system's output has a \n at the end of it!
    local node_binary_path = vim.fn.system("source $HOME/.nvm/nvm.sh && nvm which current"):sub(1, -2)
    local node_root_path = string.gsub(node_binary_path, "/bin/node", "")
    local ts_lib_path = vim.fs.joinpath(node_root_path, "lib", "node_modules", "typescript", "lib")
    return ts_lib_path
end

---@param root_dir? string
---@return string
local function _get_typescript_lib_path(root_dir)
    local global_ts = _get_global_typescript_lib_path()

    local local_ts = vim.fs.find(vim.fs.joinpath("node_modules", "typescript", "lib"), {
        path = root_dir,
        upward = true,
    })

    if #local_ts ~= 0 then
        return local_ts[1]
    else
        return global_ts
    end
end

---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = "vue-language-server",
    filetypes = {
        "vue",
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "json",
    },

    root_indicators = {
        "package.json",
        ".git",
    },
    command = {
        "vue-language-server",
        "--stdio",
    },
    init_options = {
        typescript = {
            -- This only works correctly iff you open the neovim from the project's directory.
            tsdk = _get_typescript_lib_path(),
        },
        languageFeatures = {
            references = true,
            definition = true,
            typeDefinition = true,
            callHierarchy = true,
            hover = true,
            rename = true,
            renameFileRefactoring = true,
            signatureHelp = true,
            codeAction = true,
            completion = {
                defaultTagNameCase = "both",
                defaultAttrNameCase = "kebabCase",
                getDocumentNameCasesRequest = true,
                getDocumentSelectionRequest = true,
            },
            schemaRequestService = true,
            documentHighlight = true,
            documentLink = true,
            codeLens = {
                showReferencesNotification = true,
            },
            diagnostics = true,
        },
        documentFeatures = {
            selectionRange = true,
            foldingRange = true,
            linkedEditingRange = true,
            documentSymbol = true,
            documentColor = true,
            documentFormatting = {
                defaultPrintWidth = 100,
                getDocumentPrintWidthRequest = true,
            },
        },
    },
    lifecycle_handlers = {
        on_new_config = function(new_config, new_root_dir)
            if
                new_config.init_options
                and new_config.init_options.typescript
                and new_config.init_options.typescript.tsdk == ""
            then
                new_config.init_options.typescript.tsdk = _get_typescript_lib_path(new_root_dir)
            end
        end,
    },
    enabled = function() return require("lua.ez_lsp.server_configurations.vue_helpers").is_part_of_vue_project() end,
    description = "Provides language server support for Vue files (Vue 3)",
    command_installation_help = [[
        Uses [volar](https://github.com/vuejs/language-tools) which can be installed via npm:
        ```sh
        npm i -g @vue/language-server
        ```
    ]],
}

return Module
