-- Find more schemas here: https://www.schemastore.org/json/
return {
    {
        description = "TypeScript compiler configuration file",
        fileMatch = {
            "tsconfig.json",
            "tsconfig.*.json",
        },
        url = "https://json.schemastore.org/tsconfig.json",
    },
    {
        description = "Babel configuration",
        fileMatch = {
            ".babelrc.json",
            ".babelrc",
            "babel.config.json",
        },
        url = "https://json.schemastore.org/babelrc.json",
    },
    {
        description = "ESLint config",
        fileMatch = {
            ".eslintrc.json",
            ".eslintrc",
        },
        url = "https://json.schemastore.org/eslintrc.json",
    },
    {
        description = "Bucklescript config",
        fileMatch = {
            "bsconfig.json",
        },
        url = "https://raw.githubusercontent.com/rescript-lang/rescript-compiler/8.2.0/docs/docson/build-schema.json",
    },
    {
        description = "Prettier config",
        fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json",
        },
        url = "https://json.schemastore.org/prettierrc",
    },
    {
        description = "Stylelint config",
        fileMatch = {
            ".stylelintrc",
            ".stylelintrc.json",
            "stylelint.config.json",
        },
        url = "https://json.schemastore.org/stylelintrc",
    },
    {
        description = "Json schema for properties json file for a GitHub Workflow template",
        fileMatch = {
            ".github/workflow-templates/**.properties.json",
        },
        url = "https://json.schemastore.org/github-workflow-template-properties.json",
    },
    {
        description = "golangci-lint configuration file",
        fileMatch = {
            ".golangci.toml",
            ".golangci.json",
        },
        url = "https://json.schemastore.org/golangci-lint.json",
    },
    {
        description = "NPM configuration file",
        fileMatch = {
            "package.json",
        },
        url = "https://json.schemastore.org/package.json",
    },
    {
        description = "OpenAPI 3.0 specification",
        fileMatch = {
            "openapi.json",
            "openapi.yaml",
            "openapi.yml",
            "*.openapi.3.0.json",
            "*.openapi.3.0.yaml",
            "*.openapi.3.0.yml",
        },
        url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.json",
    },
    {
        description = "OpenAPI 3.1 specification",
        fileMatch = {
            "*.openapi.3.1.json",
            "*.openapi.3.1.yaml",
            "*.openapi.3.1.yml",
        },
        url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json",
    },
}
