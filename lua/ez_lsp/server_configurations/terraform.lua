local _SERVER_NAME = "terraform-ls"
local _AUTO_COMMAND_GROUP_NAME = _SERVER_NAME .. "_augroup"

---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = _SERVER_NAME,
    filetypes = { "terraform", "terraform-vars" },
    root_indicators = {
        ".terraform",
        ".git",
    },
    command = {
        "terraform-ls",
        "serve",
    },
    single_file_support = false,
    lifecycle_handlers = {
        on_init = function()
            local augroup_id = vim.api.nvim_create_augroup(_AUTO_COMMAND_GROUP_NAME, {
                clear = false,
            })

            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                group = augroup_id,
                pattern = { "*.tf", "*.tfvars" },
                callback = function() vim.lsp.buf.format() end,
            })
        end,
        on_exit = function() vim.api.nvim_del_augroup_by_name(_AUTO_COMMAND_GROUP_NAME) end,
    },

    description = "Provides language server support for terraform files.",
    command_installation_help = [[
        `terraform-ls` can be installed using brew:

        ```bash
        brew install hashicorp/tap/terraform-ls
        ```

        On linux systems it can be installed from official packages published by HashiCorp. For more information
        checkout [Official Packaging Guide](https://www.hashicorp.com/official-packaging-guide).
    ]],
}

return Module
