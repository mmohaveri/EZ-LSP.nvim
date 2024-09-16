local DiagnosticsModule = {}

---@param inp string
---@param prefix string
---@return boolean
local function _starts_with(inp, prefix) return string.sub(inp, 1, string.len(prefix)) == prefix end

---@param bufnr? integer
---@return boolean
local function _should_diagnostics_be_disabled(bufnr)
    if bufnr == nil then return true end

    local buf_infos = vim.fn.getbufinfo(bufnr)
    if #buf_infos == 0 then return true end

    local buf_info = buf_infos[1]

    if buf_info.name == nil or buf_info.name == "" or _starts_with(buf_info.name, "term://") then return true end

    return false
end

---param namespace integer
---param bufnr integer
---return boolean | vim.diagnostic.Opts.VirtualText
local function _get_virtual_text_config(namespace, bufnr)
    if _should_diagnostics_be_disabled(bufnr) then return false end

    return {}
end

---param namespace integer
---param bufnr integer
---return boolean | vim.diagnostic.Opts.Signs
local function _get_signs_config(namespace, bufnr)
    if _should_diagnostics_be_disabled(bufnr) then return false end

    return {
        -- active = signs,
    }
end

---param namespace integer
---param bufnr integer
---return boolean | vim.diagnostic.Opts.Underline
local function _get_underline_config(namespace, bufnr)
    if _should_diagnostics_be_disabled(bufnr) then return false end

    return {}
end

---@param config ez_lsp.config.Diagnostics
---@return ez_lsp.config.Diagnostics
local function _fill_defaults(config)
    return vim.tbl_deep_extend("keep", config, {
        signs = {
            error = {
                name = "DiagnosticSignError",
                sign = "",
            },
            hint = {
                name = "DiagnosticSignHint",
                sign = "",
            },
            info = {
                name = "DiagnosticSignInfo",
                sign = "",
            },
            warning = {
                name = "DiagnosticSignWarn",
                sign = "",
            },
        },
    })
end

---@param config ez_lsp.config.Diagnostics
local function _register_diagnostic_signs(config)
    local filled_config = _fill_defaults(config)

    for _, sign in ipairs(filled_config.signs) do
        vim.fn.sign_define(sign.name, {
            text = sign.sign,
            texthl = sign.name,
            -- numhl = "",
        })
    end
end

local function _configure_diagnostics()
    ---@type vim.diagnostic.Opts
    local diagnostic_config = {
        virtual_text = _get_virtual_text_config,
        signs = _get_signs_config,
        update_in_insert = true,
        underline = _get_underline_config,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = true,
            header = "",
            prefix = "",
        },
    }
    vim.diagnostic.config(diagnostic_config)
end

local function _configure_diagnostic_handlers()
    local handlers = vim.lsp.handlers
    local handler_config = {
        border = "rounded",
    }
    handlers["textDocument/hover"] = vim.lsp.with(handlers.hover, handler_config)
    handlers["textDocument/signatureHelp"] = vim.lsp.with(handlers.signature_help, handler_config)
end

---@param config ez_lsp.config.Diagnostics
function DiagnosticsModule.setup(config)
    _register_diagnostic_signs(config)
    _configure_diagnostics()
    _configure_diagnostic_handlers()
end

return DiagnosticsModule
