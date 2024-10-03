local _SERVER_NAME = "tex-language-server"

local tex_helpers = require("ez_lsp.server_configurations.tex_helpers"):new(_SERVER_NAME)

---@type ez_lsp.config.LSPDefinition
local Module = {
    ez_lsp_config_version = "1.0.0",
    name = _SERVER_NAME,
    filetypes = {
        "bib",
        "plaintex",
        "tex",
    },

    root_indicators = {
        ".git",
        ".latexmkrc",
    },
    command = {
        "texlab",
    },
    single_file_support = true,
    settings = {
        texlab = {
            rootDirectory = nil,
            build = {
                executable = "latexmk",
                args = { "-xelatex", "-interaction=nonstopmode", "-synctex=1", "%f" },
                onSave = false,
                forwardSearchAfter = false,
            },
            auxDirectory = ".",
            forwardSearch = {
                executable = nil,
                args = {},
            },
            chktex = {
                onOpenAndSave = false,
                onEdit = false,
            },
            diagnosticsDelay = 300,
            latexFormatter = "latexindent",
            latexindent = {
                ["local"] = nil, -- local is a reserved keyword
                modifyLineBreaks = false,
            },
            bibtexFormatter = "texlab",
            formatterLineLength = 120,
        },
    },
    user_commands = {
        {
            name = "TexlabBuild",
            description = "Build the current buffer",
            callback = function() tex_helpers:buf_build() end,
        },
        {
            name = "TexlabForward",
            description = "Forward search from current position",
            callback = function() tex_helpers:buf_search() end,
        },
    },
    description = "Provides language server support for TeX and LaTeX files.",
    command_installation_help = [[
        [TexLab](https://github.com/latex-lsp/texlab).
        which can installed from its github page.

        It also relies on latexindent, chktex, and latexmk all of
        which are a part of the `texlive-full` package on debian.
    ]],
}

return Module
