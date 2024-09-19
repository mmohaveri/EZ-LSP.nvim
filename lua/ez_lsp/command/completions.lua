local CompletionsModule = {}

---@param sub_string string
---@return fun(string) boolean
local function _match_client_name(sub_string)
    ---@param client vim.lsp.Client
    ---@return boolean
    local function _match(client) return client.name:find(sub_string) ~= nil end

    return _match
end

---@param client vim.lsp.Client
---@return string
local function _extract_name(client) return client.name end

---@param arg_lead string
---@param cmdline string
---@param cursor_position integer
---@return string[]
function CompletionsModule.lsp_name(arg_lead, cmdline, cursor_position)
    local res = vim.iter(vim.lsp.get_clients()):filter(_match_client_name(arg_lead)):map(_extract_name):totable()
    return res
end

---@param subcommands table<string, ez_lsp.lsp.Subcommand>
---@param arg_lead string
---@param cmdline string
---@param cursor_position integer
---@return string[]
function CompletionsModule.subcommands(subcommands, arg_lead, cmdline, cursor_position)
    -- Get the subcommand.
    local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*EZlsp[!]*%s(%S+)%s(.*)$")
    if subcmd_key and subcmd_arg_lead and subcommands[subcmd_key] and subcommands[subcmd_key].complete then
        -- The subcommand has completions. Return them.
        return subcommands[subcmd_key].complete(subcmd_arg_lead, cmdline, cursor_position)
    end

    -- Check if cmdline is a subcommand
    if cmdline:match("^['<,'>]*EZlsp[!]*%s+%w*$") then
        -- Filter subcommands that match
        local subcommand_keys = vim.tbl_keys(subcommands)
        return vim.iter(subcommand_keys):filter(function(key) return key:find(arg_lead) ~= nil end):totable()
    end

    return {}
end

return CompletionsModule
