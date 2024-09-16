---@class  ez_lsp.lsp.BufferInfo
---@field buffer_id integer
---@field buffer_name string

---@class  ez_lsp.lsp.ActiveClientInfo
---@field lsp_config vim.lsp.ClientConfig
---@field attached_buffer_ids ez_lsp.lsp.BufferInfo[]

---@class  ez_lsp.lsp.ServerInfo
---@field lsp_definition ez_lsp._LSPDefinition | nil
---@field active_client_info ez_lsp.lsp.ActiveClientInfo | nil

---@type fun(bufnr: integer) | nil
_G.ez_lsp_set_lsp_keymaps_for_buffer = _G.ez_lsp_set_lsp_keymaps_for_buffer
