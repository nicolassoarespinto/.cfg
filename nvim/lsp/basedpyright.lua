---@type vim.lsp.Config
return {
    cmd = { 'uvx', '--from=basedpyright', '--', 'basedpyright-langserver', '--stdio' },
    root_markers = {
        'uv.lock',
        '.venv',
        '.git',
        'pyproject.toml',
    },
    filetypes = { 'python' },
    settings = {
        basedpyright = {
            verboseOutput = true,
            disableOrganizeImports = true,
            typeCheckingMode = 'basic',
            analysis = {
                typeCheckingMode = 'basic',
                diagnosticMode = 'openFilesOnly',
                diagnosticSeverityOverrides = {
                    reportMissingTypeStubs=false,
                    reportPrivateImportUsage=false,
                    reportUnusedImports = false,
                    reportUnusedVariable = false,
                    -- NEW:
                    reportUnknownParameterType = false,
                    reportUnknownMemberType = false,
                    reportUnknownVariableType = false,
                    reportUnknownArgumentType = false,
                    reportUnknownLambdaType = false,
                    reportAttributeAccessIssue = false,
                    -- reportUnusedClass = "warning",
                    -- reportUnusedFunction = "warning",
                    -- reportUndefinedVariable = false, -- ruff handles this with F822
                    reportOptionalMemberAcess=false,
                    reportOptionalSubscript=false,
                },
                inlayHints = {
                    variableTypes = true,
                    -- callArgumentNames = true,
                    functionReturnTypes = true,
                    genericTypes = true,
                },
            },
        },
    },
}
