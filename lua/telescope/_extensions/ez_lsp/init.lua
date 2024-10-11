return require("telescope").register_extension({
    exports = {
        ez_lsp = require("telescope._extensions.ez_lsp.picker"),
    },
})
