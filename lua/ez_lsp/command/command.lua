local CommandModule = {}

---@type table<string, ez_lsp.lsp.Subcommand>
local _subcommands = {}

---@param opts ez_lsp.command.UserCommandArgs
local function ez_lsp_main_command(opts)
    local fargs = opts.fargs
    if fargs == nil then
        vim.notify("Missing required subcommand.", vim.log.levels.ERROR)
        vim.api.nvim_err_writeln("Missing required subcommand.")
        return
    end

    local subcommand_key = fargs[1]
    local subcommand_args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}

    local subcommand = _subcommands[subcommand_key]
    if not subcommand then
        vim.notify("EZlsp: Unknown command: " .. subcommand_key, vim.log.levels.ERROR)
        return
    end

    subcommand.impl(subcommand_args, opts)
end

---@param subcommands table<string, ez_lsp.lsp.Subcommand>
function CommandModule.add_subcommands(subcommands)
    for command, subcommand in pairs(subcommands) do
        _subcommands[command] = subcommand
    end
end

---@param subcommand_name string
function CommandModule.remove_subcommands(subcommand_name) _subcommands[subcommand_name] = nil end

function CommandModule.setup()
    local completions = require("ez_lsp.command.completions")

    vim.api.nvim_create_user_command("EZlsp", ez_lsp_main_command, {
        nargs = "+",
        desc = "EZ LSP's main command. All other commands are implemented as subcommand. Use subcommand completions to discover",
        complete = function(arg_lead, cmdline, _) return completions.subcommands(_subcommands, arg_lead, cmdline, _) end,
        bang = false,
    })
end

CommandModule.add_subcommands(require("ez_lsp.command.ez_lsp_subcommands"))

return CommandModule
