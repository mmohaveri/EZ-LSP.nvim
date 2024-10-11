local server_info_entry_maker = require("telescope._extensions.ez_lsp.entry_maker")
local server_info_previewer = require("telescope._extensions.ez_lsp.previewer")

---@param prompt_bufnr integer

---@param opts? table
local function get_lsp_list_picker(opts)
    opts = opts or {}

    local finders = require("telescope.finders")
    local pickers = require("telescope.pickers")
    local sorters = require("telescope.sorters")

    return pickers
        .new(opts, {
            prompt_title = "EZ LSP - LSP list",
            finder = finders.new_table({
                results = require("ez_lsp.lsp").list_servers(),
                entry_maker = server_info_entry_maker,
            }),
            previewer = server_info_previewer,
            sorter = sorters.get_generic_fuzzy_sorter(),
            attach_mappings = function(_, map)
                map("i", "<CR>", function(prompt_bufnr)
                    local action_state = require("telescope.actions.state")
                    local actions = require("telescope.actions")

                    ---@type ez_lsp.telescope.ServerInfoEntry
                    local selection = action_state.get_selected_entry()

                    local client_info = selection.value.active_client_info
                    if client_info == nil then return end
                    vim.ui.select({ "Restart", "Stop" }, {
                        prompt = "Choose an action for " .. (client_info.lsp_config.name or nil) .. " LSP:",
                    }, function(choice)
                        if choice == nil then return end
                        local clients = vim.lsp.get_clients({ name = client_info.lsp_config.name })
                        for _, client in ipairs(clients) do
                            if choice == "Restart" then require("ez_lsp.lsp").restart_server(client) end
                            if choice == "Stop" then require("ez_lsp.lsp").stop_server(client) end
                        end
                    end)
                end)
                return true
            end,
        })
        :find()
end

return get_lsp_list_picker
