local CommandModule = {}

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

---@param command_lead  string
---@return string[]
local function _lsp_name_completion(command_lead)
    local res = vim.iter(vim.lsp.get_clients()):filter(_match_client_name(command_lead)):map(_extract_name):totable()
    vim.notify(vim.inspect(res))
    return res
end

---@type table<string, ez_lsp.lsp.Subcommand>
local subcommand_tbl = {
    info = {
        -- "lspconfig.ui.lspinfo"
        --  desc = "Displays attached, active, and configured language servers",
        impl = function(args, opts) vim.print(vim.inspect(require("ez_lsp.lsp").list_servers())) end,
    },
    stop = {
        impl = function(args, opts)
            local server_name = args[1]

            local clients = vim.lsp.get_clients({ name = server_name })

            for _, client in ipairs(clients) do
                client.stop()
            end
        end,
        complete = _lsp_name_completion,
    },
    restart = {
        impl = function(args, opts)
            local ez_lsp_module = require("ez_lsp.lsp")
            local server_name = args[1]

            local clients = vim.lsp.get_clients({ name = server_name })

            for _, client in ipairs(clients) do
                ez_lsp_module.restart_server(client)
            end
        end,
        complete = _lsp_name_completion,
    },
}

---@param opts table :h lua-guide-commands-create
local function ez_lsp_main_command(opts)
    local fargs = opts.fargs
    local subcommand_key = fargs[1]
    -- Get the subcommand's arguments, if any
    local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
    local subcommand = subcommand_tbl[subcommand_key]
    if not subcommand then
        vim.notify("EZlsp: Unknown command: " .. subcommand_key, vim.log.levels.ERROR)
        return
    end
    -- Invoke the subcommand
    subcommand.impl(args, opts)
end

function CommandModule.setup()
    vim.api.nvim_create_user_command("EZlsp", ez_lsp_main_command, {
        nargs = "+",
        desc = "EZ LSP's main command. All other commands are implemented as subcommand. Use subcommand completions to discover",
        complete = function(arg_lead, cmdline, _)
            -- Get the subcommand.
            local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*EZlsp[!]*%s(%S+)%s(.*)$")
            vim.notify(subcmd_key or "nil")
            vim.notify(vim.inspect(subcmd_arg_lead) or "nil")
            if
                subcmd_key
                and subcmd_arg_lead
                and subcommand_tbl[subcmd_key]
                and subcommand_tbl[subcmd_key].complete
            then
                -- The subcommand has completions. Return them.
                return subcommand_tbl[subcmd_key].complete(subcmd_arg_lead)
            end
            -- Check if cmdline is a subcommand
            if cmdline:match("^['<,'>]*EZlsp[!]*%s+%w*$") then
                -- Filter subcommands that match
                local subcommand_keys = vim.tbl_keys(subcommand_tbl)
                return vim.iter(subcommand_keys):filter(function(key) return key:find(arg_lead) ~= nil end):totable()
            end
        end,
        bang = false, -- If you want to support ! modifiers
    })
end

return CommandModule
