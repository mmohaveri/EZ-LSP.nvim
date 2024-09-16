local ConfigTypes = {}

---@enum (key) ez_lsp.LifeCycleEvent
ConfigTypes.LifeCycleEvent = {
    on_new_config = 1,
    on_attach = 2,
    on_error = 3,
    before_init = 4,
    on_init = 5,
    on_exit = 6,
}

---@class  ez_lsp.config.Config
---@field servers (ez_lsp.config.LSPDefinition | string | lspconfig.Config)[]
---@field diagnostics? ez_lsp.config.Diagnostics

---@class  ez_lsp.config.LSPDefinition
---@field ez_lsp_config_version string
---@field name string
---@field description? string
---@field filetypes string[]
---@field root_indicators? string[]
---@field command string[]
---@field command_installation_help? string
---@field single_file_support? boolean
---@field settings? table
---@field lifecycle_handlers? table<ez_lsp.LifeCycleEvent, elem_or_list<function>>
---@field init_options? table
---@field event_handlers? ez_lsp.config.EventHandler[]
---@field user_commands? ez_lsp.config.Command[]
---@field enabled? fun(): boolean

---@class  ez_lsp.config.EventHandler
---@field event_name string
---@field callback function

---@class  ez_lsp.config.Command
---@field name string
---@field description? string
---@field callback function

---@class  ez_lsp.config.Diagnostics
---@field signs? ez_lsp.config.DiagnosticSigns

---@class  ez_lsp.config.DiagnosticSigns
---@field info? ez_lsp.config.DiagnosticSign
---@field hint? ez_lsp.config.DiagnosticSign
---@field warning? ez_lsp.config.DiagnosticSign
---@field error? ez_lsp.config.DiagnosticSign

---@class  ez_lsp.config.DiagnosticSign
---@field sign? string

---@class  ez_lsp._LSPDefinition: ez_lsp.config.LSPDefinition
---@field client_config vim.lsp.ClientConfig
---@field root_indicators string[]
---@field single_file_support boolean
---@field enabled? fun(): boolean
---- @field on_new_config? function
---- @field autostart? boolean
---- @field package _on_attach? fun(client: vim.lsp.Client, bufnr: integer)

---@comment  based on the lspconfig.Config class defined in lspconfig/config.lua
---@class lspconfig.Config : vim.lsp.ClientConfig
---@field enabled? boolean
---@field single_file_support? boolean
---@field filetypes? string[]
---@field filetype? string
---@field on_new_config? function
---@field autostart? boolean
---@field package _on_attach? fun(client: vim.lsp.Client, bufnr: integer)
---@field root_dir? string|fun(filename: string, bufnr: number)

return ConfigTypes
