local ValidatorsModule = {}

---@param name string
---@param values any
---@param _type any
---@param _optional any
local function _validate_array_item(name, values, _type, _optional)
    if _optional and values == nil then return end

    vim.validate({
        [name] = { values, "table" },
    })

    for _, item in ipairs(values) do
        vim.validate({
            [name .. "_item"] = { item, _type, _optional },
        })
    end
end
---@param inputs {[string]: any[]}
local function validate_array(inputs)
    for name, spec in pairs(inputs) do
        local values = spec[1]
        local _type = spec[2]
        local _optional = spec[3] or false

        _validate_array_item(name, values, _type, _optional)
    end
end

---@param definition any
---@return boolean
function ValidatorsModule.validate_lsp_definition(definition)
    local success, _ = pcall(vim.validate, {
        ez_lsp_config_version = { definition.ez_lsp_config_version, "string" },
        name = { definition.name, "string" },
        description = { definition.description, "string", true },
        filetypes = { definition.filetypes, "table" },
        root_indicators = { definition.root_indicators, "table", true },
        command = { definition.command, "table" },
        command_installation_help = { definition.command_installation_help, "string", true },
        single_file_support = { definition.single_file_support, "boolean", true },
        settings = { definition.settings, "table", true },
        lifecycle_handlers = { definition.lifecycle_handlers, "table", true },
        init_options = { definition.init_options, "table", true },
        event_handlers = { definition.event_handlers, "table", true },
        user_commands = { definition.user_commands, "table", true },
        enabled = { definition.enabled, "function", true },
    })

    if not success then return false end

    success, _ = pcall(validate_array, {
        filetypes = { definition.filetypes, "string" },
        root_indicators = { definition.root_indicators, "string", true },
        command = { definition.command, "string" },
    })

    if not success then return false end

    if definition.lifecycle_handlers then
        success, _ = pcall(vim.validate, {
            on_new_config = { definition.lifecycle_handlers["on_new_config"], {"function", "table"}, true },
            on_attach = { definition.lifecycle_handlers["on_attach"], {"function", "table"}, true },
            on_error = { definition.lifecycle_handlers["on_error"], {"function", "table"}, true },
            before_init = { definition.lifecycle_handlers["before_init"], {"function", "table"}, true },
            on_init = { definition.lifecycle_handlers["on_init"], {"function", "table"}, true },
            on_exit = { definition.lifecycle_handlers["on_exit"], {"function", "table"}, true },
        })

        if not success then return false end
    end

    if definition.event_handlers then
        for _, handler in ipairs(definition.event_handlers) do
            success, _ = pcall(vim.validate, {
                event_name = { handler.event_name, "string" },
                callback = { handler.callback, "function" },
            })

            if not success then return false end
        end
    end

    if definition.user_commands then
        for _, cmd in ipairs(definition.user_commands) do
            success, _ = pcall(vim.validate, {
                name = { cmd.name, "string" },
                description = { cmd.description, "string", true },
                callback = { cmd.callback, "function" },
            })

            if not success then return false end
        end
    end

    return true
end

---@param config any
---@return boolean
function ValidatorsModule.validate_lspconfig_config(config)
    local success, _ = pcall(vim.validate, {
        cmd = { config.cmd, { "table", "function" } }, -- can be a string array or a function
        cmd_cwd = { config.cmd_cwd, "string", true },
        cmd_env = { config.cmd_env, "table", true },
        detached = { config.detached, "boolean", true },
        workspace_folders = { config.workspace_folders, "table", true },
        capabilities = { config.capabilities, "table", true },
        handlers = { config.handlers, "table", true },
        settings = { config.settings, "table", true },
        commands = { config.commands, "table", true },
        init_options = { config.init_options, "table", true },
        name = { config.name, "string", true },
        get_language_id = { config.get_language_id, "function", true },
        offset_encoding = { config.offset_encoding, { "string" }, true },
        on_error = { config.on_error, "function", true },
        before_init = { config.before_init, "function", true },
        on_init = { config.on_init, { "function", "table" }, true },
        on_exit = { config.on_exit, { "function", "table" }, true },
        on_attach = { config.on_attach, { "function", "table" }, true },
        trace = { config.trace, "string", true },
        flags = { config.flags, "table", true },
        root_dir = { config.root_dir, { "string", "function" }, true },

        -- Fields from ez_lsp.lspconfigConfig
        enabled = { config.enabled, "boolean", true },
        single_file_support = { config.single_file_support, "boolean", true },
        filetypes = { config.filetypes, "table", true },
        filetype = { config.filetype, "string", true },
        on_new_config = { config.on_new_config, "function", true },
        autostart = { config.autostart, "boolean", true },
        _on_attach = { config._on_attach, "function", true },
    })

    return success
end

return ValidatorsModule
