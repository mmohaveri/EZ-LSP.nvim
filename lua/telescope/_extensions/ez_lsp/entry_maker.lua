local active_icon = ""
local inactive_icon = ""
local active_LSP_client_marker_hl_name = "ActiveLSPClientMarker"
local inactive_LSP_client_marker_hl_name = "InactiveLSPClientMarker"

vim.api.nvim_set_hl(0, active_LSP_client_marker_hl_name, { link = "DiffAdded" })
vim.api.nvim_set_hl(0, inactive_LSP_client_marker_hl_name, { link = "Error" })

local _entry_display_template = require("telescope.pickers.entry_display").create({
    separator = " ",
    items = {
        { width = 1 },
        { remaining = true },
    },
})

---@param entry ez_lsp.telescope.ServerInfoEntry
local function _entry_display(entry)
    local server_info = entry.value
    local active_marker = inactive_icon
    local active_marker_hl = inactive_LSP_client_marker_hl_name
    local server_name = ""

    if server_info.active_client_info ~= nil then
        active_marker = active_icon
        active_marker_hl = active_LSP_client_marker_hl_name
        server_name = server_info.active_client_info.lsp_config.name
    end

    if server_info.lsp_definition ~= nil then server_name = server_info.lsp_definition.name end

    return _entry_display_template({
        { active_marker, active_marker_hl },
        server_name,
    })
end
---@param entry ez_lsp.lsp.ServerInfo
---@return ez_lsp.telescope.ServerInfoEntry
local function server_info_entry_maker(entry)
    ---@type ez_lsp.telescope.ServerInfoEntry
    local telescope_entry = {
        value = entry,
        display = _entry_display,
        ordinal = entry.lsp_definition.name,
    }

    return telescope_entry
end

return server_info_entry_maker
