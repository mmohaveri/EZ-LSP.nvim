local LSPModule = {}

---@type table<string, true>
_G.ez_lsp__initialized_clients = _G.ez_lsp__initialized_clients or {}

---@type table<string, ez_lsp._LSPDefinition>
_G.ez_lsp__registered_lsp_definitions = _G.ez_lsp__registered_lsp_definitions or {}

---@param bufnr? integer
local function _set_lsp_highlight_document_on_buffer_if_client_supports(client, bufnr)
    if client.server_capabilities["documentHighlight"] == nil then return end

    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })

    vim.api.nvim_create_autocmd("CursorHold", {
        group = "lsp_document_highlight",
        buffer = bufnr or 0,
        callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
        group = "lsp_document_highlight",
        buffer = bufnr or 0,
        callback = vim.lsp.buf.clear_references,
    })
end

---@return lsp.ClientCapabilities
local function _get_client_capabilities()
    ---@type lsp.ClientCapabilities
    local client_capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
        experimental = {
            serverStatusNotification = true,
        },
    })
    local cmp_lsp_is_installed, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if cmp_lsp_is_installed then
        client_capabilities = vim.tbl_deep_extend("force", client_capabilities, cmp_lsp.default_capabilities())
    end

    return client_capabilities
end

---@param client_config vim.lsp.ClientConfig
---@return vim.lsp.ClientConfig
local function _add_client_capabilities_to_config(client_config)
    local client_capabilities = _get_client_capabilities()

    return vim.tbl_extend("force", {
        capabilities = client_capabilities,
    }, client_config)
end

---@param client vim.lsp.Client
---@param bufnr integer
local function _additional_on_attach(client, bufnr)
    if client.name == "typescript" then client.server_capabilities.documentFormattingProvider = false end

    if _G.ez_lsp_set_lsp_keymaps_for_buffer ~= nil then _G.ez_lsp_set_lsp_keymaps_for_buffer(bufnr) end

    _set_lsp_highlight_document_on_buffer_if_client_supports(client)
end

---@param client_config vim.lsp.ClientConfig
---@return vim.lsp.ClientConfig
local function _add_additional_on_attach_to_config(client_config)
    ---@type vim.lsp.ClientConfig
    local modified_config = vim.tbl_extend("error", {}, client_config)

    ---@type fun(client: vim.lsp.Client, bufnr: integer)

    if modified_config.on_attach == nil then
        modified_config.on_attach = _additional_on_attach
        return modified_config
    end

    if type(client_config.on_attach) == "function" then
        modified_config.on_attach = { client_config.on_attach, _additional_on_attach }
        return modified_config
    end

    table.insert(modified_config.on_attach, _additional_on_attach)

    return modified_config
end

---@param client_config vim.lsp.ClientConfig
---@param root_indicators string[]
---@return vim.lsp.ClientConfig
local function _add_root_dir_to_config(client_config, root_indicators)
    return vim.tbl_extend("force", {
        root_dir = vim.fs.dirname(vim.fs.find(root_indicators, { upward = true })[1]),
    }, client_config)
end

---@param cmd (fun(dispatchers: vim.lsp.rpc.Dispatchers):vim.lsp.rpc.PublicClient) | string[]
---@return boolean
local function _is_cmd_valid(cmd)
    if type(cmd) == "function" then return true end

    if vim.fn.executable(cmd[1]) == 1 then return true end

    return false
end

---@param commands ez_lsp.config.UserCommand[]
local function _register_user_commands(commands)
    --- In future I like to add these commands as subcommands of EZlsp, for example: "EZlsp pyright organize_imports" instead of PyrightOrganizeImports
    for _, command in ipairs(commands) do
        vim.api.nvim_create_user_command(command.name, command.callback, {
            nargs = command.nargs,
            complete = command.complete,
        })
    end
end

---@param client_config vim.lsp.ClientConfig
---@param root_indicators string[]
local function _start_lsp_server(client_config, root_indicators)
    if not _is_cmd_valid(client_config.cmd) then
        vim.notify(
            "Failed to start '"
                .. client_config.name
                .. "' LSP client. '. '"
                .. client_config.cmd[1]
                .. "' binary does not exist!",
            vim.log.levels.ERROR
        )
        return
    end

    client_config = _add_client_capabilities_to_config(client_config)
    client_config = _add_additional_on_attach_to_config(client_config)
    client_config = _add_root_dir_to_config(client_config, root_indicators)
    vim.lsp.set_log_level(vim.lsp.log_levels.WARN)

    _register_user_commands(client_config.commands)

    local client = vim.lsp.start(client_config)
    if client == nil then
        vim.notify("Failed to start '" .. client_config.name .. "' LSP client.", vim.log.levels.ERROR)
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()

    if not vim.lsp.buf_attach_client(bufnr, client) then
        vim.notify(
            "Failed to attache '" .. client_config.name .. "' LSP client to buffer " .. bufnr .. ".",
            vim.log.levels.ERROR
        )
        return
    end

    local client_key = client_config.name .. "_" .. client_config.root_dir
    if _G.ez_lsp__initialized_clients[client_key] then
        vim.notify(
            "'" .. client_config.name .. "' LSP client started and attached to buffer" .. bufnr .. ".",
            vim.log.levels.DEBUG
        )
        return
    end

    _G.ez_lsp__initialized_clients[client_key] = true
    vim.notify("'" .. client_config.name .. "' LSP client started and attached.", vim.log.levels.INFO)
end

---@param client_config vim.lsp.ClientConfig
---@param file_types string | string[]
---@param root_indicators string[]
---@param enabled? fun(): boolean
local function _register_lsp_auto_command(client_config, file_types, root_indicators, enabled)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = file_types,
        callback = function()
            if enabled ~= nil and not enabled() then return end
            _start_lsp_server(client_config, root_indicators)
        end,
    })
end

---@param lsp_definition ez_lsp._LSPDefinition
local function _register_lsp_server(lsp_definition)
    _register_lsp_auto_command(
        lsp_definition.client_config,
        lsp_definition.filetypes,
        lsp_definition.root_indicators,
        lsp_definition.enabled
    )
    _G.ez_lsp__registered_lsp_definitions[lsp_definition.name] = lsp_definition
end

---@param server ez_lsp.config.LSPDefinition | string | lspconfig.Config
local function _setup_server(server)
    local server_internal_lsp_definition = require("ez_lsp.config").get_lsp_definition(server)

    if server_internal_lsp_definition == nil then
        ---@type string
        local error_str = "Failed to get lsp definition for: "

        if type(server) == "table" then
            error_str = error_str .. "\n" .. vim.inspect(server)
        else
            error_str = error_str .. "`" .. server .. "`"
        end
        vim.notify(error_str, vim.log.levels.ERROR)
        return
    end

    _register_lsp_server(server_internal_lsp_definition)
end

---@param info table[integer, true]
---@return ez_lsp.lsp.BufferInfo[]
local function _get_attached_buffers_list(info)
    ---@type ez_lsp.lsp.BufferInfo[]
    local res = {}

    for buf_no, _ in pairs(info) do
        ---@type ez_lsp.lsp.BufferInfo
        local buff_info = {
            buffer_id = buf_no,
            buffer_name = vim.api.nvim_buf_get_name(buf_no),
        }

        table.insert(res, buff_info)
    end

    return res
end

---@param client vim.lsp.Client
function LSPModule.restart_server(client)
    local old_client = client

    local client_config = old_client.config
    local attached_buffers = client.attached_buffers

    old_client.stop()
    vim.notify("Successfully stopped '" .. client_config.name .. "'LSP client.", vim.log.levels.INFO)

    local new_client_id = vim.lsp.start(client_config)
    if new_client_id == nil then
        vim.notify("Failed to re-start '" .. client_config.name .. "' LSP client.", vim.log.levels.ERROR)
        return
    end

    for bufnr, _ in pairs(attached_buffers) do
        local attached_to_buffer = vim.lsp.buf_attach_client(bufnr, new_client_id)
        if not attached_to_buffer then
            vim.notify(
                "Failed to re-attache '"
                    .. client_config.name
                    .. "' LSP client to buffer "
                    .. bufnr
                    .. ". \n Aborting restart.",
                vim.log.levels.ERROR
            )
            return
        end
    end

    vim.notify("Successfully restarted '" .. client_config.name .. "'LSP client.", vim.log.levels.INFO)
end

---@param client vim.lsp.Client
function LSPModule.stop_server(client)
    client.stop()
    vim.notify("Successfully stopped '" .. client.name .. "'LSP client.", vim.log.levels.INFO)
end

---@param servers (ez_lsp.config.LSPDefinition | string | lspconfig.Config)[]
function LSPModule.setup(servers)
    for _, server in ipairs(servers) do
        _setup_server(server)
    end
end

---@return ez_lsp.lsp.ServerInfo[]
function LSPModule.list_servers()
    local all_clients = vim.lsp.get_clients()
    ---@type table[string, true]
    local active_clients = {}

    ---@type ez_lsp.lsp.ServerInfo[]
    local res = {}

    for _, client in ipairs(all_clients) do
        ---@type ez_lsp.lsp.ServerInfo
        local client_info = {
            lsp_definition = _G.ez_lsp__registered_lsp_definitions[client.name],
            active_client_info = {
                lsp_config = client.config,
                attached_buffer_ids = _get_attached_buffers_list(client.attached_buffers),
            },
        }
        table.insert(res, client_info)

        if client_info.lsp_definition ~= nil then active_clients[client.name] = true end
    end

    for name, lsp_definition in pairs(_G.ez_lsp__registered_lsp_definitions) do
        if active_clients[name] == nil then
            ---@type ez_lsp.lsp.ServerInfo
            local client_info = {
                lsp_definition = lsp_definition,
                active_client_info = nil,
            }
            table.insert(res, client_info)
        end
    end

    return res
end
return LSPModule
