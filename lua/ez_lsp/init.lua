local EZLSP = {}

---@param config ez_lsp.config.Config
function EZLSP.setup(config)
    require("ez_lsp.diagnostics").setup(config.diagnostics or {})
    require("ez_lsp.lsp").setup(config.servers)
    require("ez_lsp.command").setup()
end

return EZLSP
