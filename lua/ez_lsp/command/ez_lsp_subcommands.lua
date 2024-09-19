local completions = require("ez_lsp.command.completions")

---@type table<string, ez_lsp.lsp.Subcommand>
local ez_lsp_subcommands = {
    info = {
        impl = function(args, opts) vim.print(vim.inspect(require("ez_lsp.lsp").list_servers())) end,
    },
    stop = {
        impl = function(args, opts)
            local server_name = args[1]
            if server_name == nil then
                vim.notify("Missing required argument (server name).", vim.log.levels.ERROR)
                vim.api.nvim_err_writeln("Missing required argument (server name).")
                return
            end
            local clients = vim.lsp.get_clients({ name = server_name })

            for _, client in ipairs(clients) do
                client.stop()
            end
        end,
        complete = completions.lsp_name,
    },
    restart = {
        impl = function(args, opts)
            local ez_lsp_module = require("ez_lsp.lsp")
            local server_name = args[1]
            if server_name == nil then
                vim.notify("Missing required argument (server name).", vim.log.levels.ERROR)
                vim.api.nvim_err_writeln("Missing required argument (server name).")
                return
            end
            local clients = vim.lsp.get_clients({ name = server_name })

            for _, client in ipairs(clients) do
                ez_lsp_module.restart_server(client)
            end
        end,
        complete = completions.lsp_name,
    },
}

return ez_lsp_subcommands
