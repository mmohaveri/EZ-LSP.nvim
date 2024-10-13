# EZ-LSP

**EZ-LSP** is a plugin that helps with managing Neovim's native LSP client.
It provides some basic functionalities like Diagnostic and basic key bindings
out of the box.

It comes with a single command `EZlsp`, all commands provided by this plugin
are defined as subcommands and you can explore them using the Neovim's command
completion.

In addition to the command, it also provides a Telescope extension that helps
you list registered and active LSPs as well as showing their status,
configuration, attached buffers, etc. You can also stop/restart active LSP
clients from it.

## Installation

Simply add the plugin using the plugin manager that you use. If using Lazy:

```lua
{
  "mmohaveri/EZ-LSP.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim", --- Only if you want the telescope integration
  },
  opts = {
    servers = {
      "lua",                -- load config from `ez_lsp/server_configurations/lua.lua`,
      "lspconfig.jsonls",   -- load config from `lspconfig/configs/jsonls.lua`,
      {                     -- config based on EZ-LSP's config format
        ez_lsp_config_version = "1.0.0",
        name = "toml",
        filetypes = { "toml" },
        root_indicators = {".git"},
        command = {
          "taplo",
          "lsp",
          "stdio",
        },
        single_file_support = true,
        description = "Provides language server support for TOML files.",
        command_installation_help = "cargo install --features lsp --locked taplo-cli"
      },
      {                     -- config based on lspconfig's config format
        default_config = {
          cmd = { 'vscode-html-language-server', '--stdio' },
          filetypes = { 'html', 'templ' },
          root_dir = util.root_pattern('package.json', '.git'),
          single_file_support = true,
          settings = {},
          init_options = {
            provideFormatter = true,
            embeddedLanguages = { css = true, javascript = true },
            configurationSection = { 'html', 'css', 'javascript' },
          },
        },
        docs = {
          description = "`vscode-html-language-server`"
        },
      }
    },
  },
}
```

## Configuration

EZ-LSP has a slightly different configuration format for the servers, but it also
accepts the lspconfig format as well. Like lspconfig, EZ-LSP comes with a set of
pre-defined server configurations, you can reference them by name. If you have
lspconfig installed, you can also reference any server configuration defined there
the same way, just add `lspconfig.` to the name of the config defined in lspconfig.

If you want to add your own config, you can either use the configuration format
defined in [ez_lsp.config.LSPDefinition](./lua/ez_lsp/config/types.lua) or use
the same configuration format that lspconfig configurations are defined in.

## Telescope integration

If registered with Telescope, this module provides a `ez_lsp` picker.
