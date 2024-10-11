local title_hl_name = "RowTitle"

vim.api.nvim_set_hl(0, title_hl_name, { link = "DiffAdded" })

---@param items string[]
---@return string[]
local function _wrap_items_with_backtick(items)
    ---@type string[]
    local wrapped_items = {}
    for _, elem in ipairs(items) do
        table.insert(wrapped_items, "`" .. elem .. "`")
    end

    return wrapped_items
end

---@param text string
---@return ez_lsp.telescope._AnnotatedText
local function _as_title(text)
    ---@type ez_lsp.telescope._AnnotatedText
    local title = {
        text = text,
        annotations = {
            {
                hl_group = title_hl_name,
                start_col = 0,
                end_col = #text,
            },
        },
    }
    return title
end

---@param entry ez_lsp.telescope.ServerInfoEntry
local function define_preview_function(self, entry)
    local bufnr = self.state.bufnr
    local winid = self.state.winid
    local win_width = vim.api.nvim_win_get_width(winid)

    local server_info = entry.value
    local client_info = server_info.active_client_info
    local lsp_definition = server_info.lsp_definition

    local name = ""
    local command = ""
    ---@type string[] | nil
    local description = nil
    ---@type string[] | nil
    local installation_help = nil
    ---@type string | nil
    local root_directory = nil
    ---@type string[] | nil
    local root_indicators = nil
    ---@type string[] | nil
    local file_types = nil

    if lsp_definition ~= nil then
        name = lsp_definition.name
        command = table.concat(lsp_definition.command, " ")
        if lsp_definition.description ~= nil then
            description = {}
            for line in lsp_definition.description:gmatch("[^\r\n]+") do
                line = line:gsub("^%s+", "")
                table.insert(description, line)
            end
        end

        if lsp_definition.command_installation_help ~= nil then
            installation_help = {}
            for line in lsp_definition.command_installation_help:gmatch("[^\r\n]+") do
                line = line:gsub("^%s+", "")
                table.insert(installation_help, line)
            end
        end

        root_indicators = lsp_definition.root_indicators

        file_types = lsp_definition.filetypes
    end

    if client_info ~= nil then
        local config_name = client_info.lsp_config.name
        if config_name ~= nil then name = config_name end

        local config_cmd = client_info.lsp_config.cmd
        if type(config_cmd) == "table" then command = table.concat(config_cmd, " ") end
        root_directory = client_info.lsp_config.root_dir
    end

    local buffer_content = require("telescope._extensions.ez_lsp.buffer_content"):new(win_width, 17)

    buffer_content:add_row({
        col1 = _as_title("LSP Name:"),
        col2 = name,
    })
    buffer_content:add_row({ col1 = _as_title("Command:"), col2 = command })

    if root_directory ~= nil then
        buffer_content:add_row({ col1 = _as_title("Root directory:"), col2 = root_directory })
    end

    if description ~= nil then
        buffer_content:add_row({ col1 = _as_title("Description:"), col2 = description[1] })
        if #description >= 2 then
            for i = 2, #description do
                buffer_content:add_row({ col1 = "", col2 = description[i] })
            end
        end
    end

    if root_indicators ~= nil then
        buffer_content:add_row({
            col1 = _as_title("Root markers:"),
            col2 = table.concat(_wrap_items_with_backtick(root_indicators), ", "),
        })
    end

    if file_types ~= nil then
        buffer_content:add_row({
            col1 = _as_title("Supported files:"),
            col2 = table.concat(_wrap_items_with_backtick(file_types), ", "),
        })
    end

    if installation_help ~= nil then
        buffer_content:add_line("")
        buffer_content:add_row({ col1 = _as_title("Installation:"), col2 = installation_help[1] })
        if #installation_help >= 2 then
            for i = 2, #installation_help do
                buffer_content:add_row({ col1 = "", col2 = installation_help[i] })
            end
        end
    end

    buffer_content:set_lines_to_buffer(bufnr)
end

local function get_lsp_info_previewer()
    local previewers = require("telescope.previewers")
    return previewers.new_buffer_previewer({
        define_preview = define_preview_function,
    })
end

return get_lsp_info_previewer()
