local _SERVER_NAME = "rust"

local function _reload_cargo()
    vim.notify("Reloading Cargo Workspace", vim.log.levels.INFO)
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({
        bufnr = bufnr,
        name = _SERVER_NAME,
    })
    if clients == nil or #clients == 0 then
        vim.notify("Failed to get the `" .. _SERVER_NAME .. "` client on buffer `" .. bufnr("`."), vim.log.levels.ERROR)
        return
    end

    local rust_client = clients[1]
    rust_client.request("rust-analyzer/reloadWorkspace", nil, function(err)
        if err then vim.notify(tostring(err), vim.log.levels.ERROR) end
        vim.notify("Cargo workspace reloaded", vim.log.levels.INFO)
    end, bufnr)
end

---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = _SERVER_NAME,
    filetypes = { "rust" },

    root_indicators = {
        "cargo.toml",
        ".git",
    },
    command = {
        "rust-analyzer",
    },
    user_commands = {
        {
            name = "CargoReload",
            description = "Reload current cargo workspace",
            callback = _reload_cargo,
        },
    },
    description = "Provides language server support for rust files.",
    command_installation_help = [[
        `rust-analyzer` will be installed as part of an standard rust installation.
    ]],
}

return Module
