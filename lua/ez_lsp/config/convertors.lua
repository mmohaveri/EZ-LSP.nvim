local ConvertorModule = {}

---@param lsp_definition ez_lsp.config.LSPDefinition
---@return ez_lsp._LSPDefinition
function ConvertorModule.convert_to_lsp_definition_to_internal_lsp_definition(lsp_definition)
    local handlers = {}
    for _, item in ipairs(lsp_definition.event_handlers or {}) do
        handlers[item.event_name] = handlers[item.callback]
    end

    local commands = {}
    for _, item in ipairs(lsp_definition.user_commands or {}) do
        commands[item.name] = item.callback
    end

    lsp_definition.lifecycle_handlers = lsp_definition.lifecycle_handlers or {}
    ---@type vim.lsp.ClientConfig
    local client_config = {
        name = lsp_definition.name,
        cmd = lsp_definition.command,
        settings = lsp_definition.settings,
        init_options = lsp_definition.init_options,
        handlers = handlers,
        commands = commands,
        on_new_config = lsp_definition.lifecycle_handlers["on_new_config"],
        on_attach = lsp_definition.lifecycle_handlers["on_attach"],
        on_error = lsp_definition.lifecycle_handlers["on_error"],
        before_init = lsp_definition.lifecycle_handlers["before_init"],
        on_init = lsp_definition.lifecycle_handlers["on_init"],
        on_exit = lsp_definition.lifecycle_handlers["on_exit"],
    }

    ---@type ez_lsp._LSPDefinition
    local internal_lsp_definition = vim.tbl_extend("force", lsp_definition, {
        client_config = client_config,
        root_indicators = lsp_definition.root_indicators or { ".git" },
        single_file_support = lsp_definition.single_file_support or false,
    })

    return internal_lsp_definition
end

---@param lsp_config lspconfig.Config
---@return ez_lsp._LSPDefinition
function ConvertorModule.convert_to_lspconfig_to_internal_lsp_definition(lsp_config)
    ---@type table<ez_lsp.LifeCycleEvent, elem_or_list<function>>
    local lifecycle_handlers = {
        on_new_config = lsp_config.on_new_config,
        on_attach = lsp_config.on_attach,
        on_error = lsp_config.on_error,
        before_init = lsp_config.before_init,
        on_init = lsp_config.on_init,
        on_exit = lsp_config.on_exit,
    }

    ---@type  ez_lsp.config.EventHandler[]
    local event_handlers = {}
    for name, callback in pairs(lsp_config.handlers or {}) do
        ---@type  ez_lsp.config.EventHandler
        local handler = {
            event_name = name,
            callback = callback,
        }
        table.insert(event_handlers, handler)
    end

    ---@type  ez_lsp.config.Command[]
    local user_commands = {}

    ---@type ez_lsp._LSPDefinition
    local internal_lsp_definition = {
        ez_lsp_config_version = "1.0.0",
        name = lsp_config.name,
        description = nil,
        filetypes = lsp_config.filetypes or { lsp_config.filetype or ".git" },
        root_indicators = {}, ---
        command = lsp_config.cmd,
        command_installation_help = nil,
        single_file_support = lsp_config.single_file_support,
        settings = lsp_config.settings,
        lifecycle_handlers = lifecycle_handlers,
        init_options = lsp_config.init_options,
        event_handlers = event_handlers,
        user_commands = user_commands,
        enabled = function() return lsp_config.enabled or true end,
        client_config = lsp_config,
    }

    return internal_lsp_definition
end

return ConvertorModule
