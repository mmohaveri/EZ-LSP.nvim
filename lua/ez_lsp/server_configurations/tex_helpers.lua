local TexHelpersModule = {}
TexHelpersModule.__index = TexHelpersModule

---@class TexHelpersModule
---@field _SERVER_NAME string

---@param server_name string
function TexHelpersModule:new(server_name)
    local instance = setmetatable({}, TexHelpersModule)
    instance._SERVER_NAME = server_name
    return instance
end

local texlab_build_status = {
    [0] = "Success",
    [1] = "Error",
    [2] = "Failure",
    [3] = "Cancelled",
}

local texlab_forward_status = {
    [0] = "Success",
    [1] = "Error",
    [2] = "Failure",
    [3] = "Unconfigured",
}

local function _get_params_for_texlab_lsp()
    local bufnr = vim.api.nvim_get_current_buf()
    local pos = vim.api.nvim_win_get_cursor(0)
    local params = {
        textDocument = {
            uri = vim.uri_from_bufnr(bufnr),
        },
        position = {
            line = pos[1] - 1,
            character = pos[2],
        },
    }

    return params
end

---@param status_table table<integer, string>
---@param operation_title string
---@return fun(err?: lsp.ResponseError, result: any)
local function _get_async_response_handler(status_table, operation_title)
    ---@param err? lsp.ResponseError
    ---@param result any
    local function handler(err, result)
        if err == nil then
            vim.notify(operation_title .. " " .. status_table[result.status], vim.log.levels.INFO)
            return
        end

        vim.notify(err.message, vim.log.levels.ERROR)
    end

    return handler
end

---@param self TexHelpersModule
---@return vim.lsp.Client | nil
local function _get_tex_client(self)
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({
        bufnr = bufnr,
        name = self._SERVER_NAME,
    })
    if clients == nil or #clients == 0 then
        vim.notify(
            "Failed to get the `" .. self._SERVER_NAME .. "` client on buffer `" .. bufnr("`."),
            vim.log.levels.ERROR
        )
        return nil
    end

    local tex_client = clients[1]
    return tex_client
end

function TexHelpersModule:buf_build()
    if getmetatable(self) ~= TexHelpersModule then
        vim.notify(
            "buf_build() must be called on an instance. There's an error in EZlsp's tex config.",
            vim.log.levels.ERROR
        )
        return
    end

    vim.notify("Building using TexLab ...", vim.log.levels.INFO)
    local texlab_client = _get_tex_client(self)
    if texlab_client == nil then
        vim.notify("Failed to get the TexLab client", vim.log.levels.ERROR)
        return
    end

    texlab_client.request(
        "textDocument/build",
        _get_params_for_texlab_lsp(),
        _get_async_response_handler(texlab_build_status, "Build"),
        0
    )
end

function TexHelpersModule:buf_search()
    if getmetatable(self) ~= TexHelpersModule then
        vim.notify(
            "buf_build() must be called on an instance. There's an error in EZlsp's tex config.",
            vim.log.levels.ERROR
        )
        return
    end

    vim.notify("Searching using TexLab ...", vim.log.levels.INFO)
    local texlab_client = _get_tex_client(self)
    if texlab_client == nil then
        vim.notify("Failed to get the TexLab client", vim.log.levels.ERROR)
        return
    end

    texlab_client.request(
        "textDocument/forwardSearch",
        _get_params_for_texlab_lsp(),
        _get_async_response_handler(texlab_forward_status, "Search"),
        0
    )
end

return TexHelpersModule
