local ConfigModule = {}

---@param inp string
---@param prefix string
---@return boolean
local function _starts_with(inp, prefix) return string.sub(inp, 1, string.len(prefix)) == prefix end

---@param config_name string
---@return  ez_lsp.config.LSPDefinition |  lspconfig.Config | nil
local function _load_config_from_name(config_name)
    local LSPCONFIG_PREFIX = "lspconfig."
    ---@type ez_lsp.config.LSPDefinition | lspconfig.Config
    local loaded_config

    ---@type boolean
    local success
    if _starts_with(config_name, LSPCONFIG_PREFIX) then
        local lspconfig_name = string.gsub(config_name, LSPCONFIG_PREFIX, "")
        success, loaded_config = pcall(require, "lspconfig.server_configurations." .. lspconfig_name)
    else
        success, loaded_config = pcall(require, "ez_lsp.server_definitions." .. config_name)
    end

    if not success then return nil end

    return loaded_config
end

---@param user_config ez_lsp.config.LSPDefinition | string | lspconfig.Config
---@return ez_lsp._LSPDefinition | nil
function ConfigModule.get_lsp_definition(user_config)
    ---@type ez_lsp.config.LSPDefinition | lspconfig.Config
    local loaded_config

    if type(user_config) == "string" then
        local loaded_config_res = _load_config_from_name(user_config)
        if loaded_config_res == nil then return nil end

        loaded_config = loaded_config_res
    else
        loaded_config = user_config
    end

    if type(loaded_config) ~= "table" then
        vim.notify("Invalid config type, expected `table` got `" .. type(loaded_config) .. "`.", vim.log.levels.ERROR)
        return nil
    end

    local validators = require("ez_lsp.config.validators")
    local convertors = require("ez_lsp.config.convertors")
    if loaded_config.ez_lsp_config_version then
        ---@cast loaded_config ez_lsp.config.LSPDefinition
        if not validators.validate_lsp_definition(loaded_config) then
            vim.notify("Invalid LSP Definition", vim.log.levels.ERROR)
            return nil
        end

        return convertors.convert_to_lsp_definition_to_internal_lsp_definition(loaded_config)
    else
        ---@cast loaded_config lspconfig.Config
        if not validators.validate_lspconfig_config(loaded_config) then
            vim.notify("Invalid lspconfig Config", vim.log.levels.ERROR)
            return nil
        end

        return convertors.convert_to_lspconfig_to_internal_lsp_definition(loaded_config)
    end
end
return ConfigModule
