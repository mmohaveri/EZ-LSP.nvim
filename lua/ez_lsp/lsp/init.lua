local LSPModule = {}

local lsp_module = require("ez_lsp.lsp.lsp")

LSPModule.restart_server = lsp_module.restart_server
LSPModule.stop_server = lsp_module.stop_server
LSPModule.list_servers = lsp_module.list_servers
LSPModule.setup = lsp_module.setup

return LSPModule
