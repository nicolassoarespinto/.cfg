local M = {}

-- Global flag to track active Python LSP (default: pylsp)
_G.active_python_lsp = _G.active_python_lsp or "pylsp"

function M.make_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

    capabilities.textDocument.formatting = {
        dynamicRegistration = false,
    }

    capabilities.textDocument.semanticTokens.augmentsSyntaxTokens = false
    capabilities.textDocument.codeAction.disabledSupport = true

    capabilities.textDocument.completion.completionItem = {
        contextSupport = true,
        snippetSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        },
        labelDetailsSupport = true,
        documentationFormat = { "markdown", "plaintext" },
    }

    -- send actions with hover request
    capabilities.experimental = {
        hoverActions = true,
        hoverRange = true,
        serverStatusNotification = true,
        -- snippetTextEdit = true, -- not supported yet
        codeActionGroup = true,
        ssr = true,
        commands = {
            "rust-analyzer.runSingle",
            "rust-analyzer.debugSingle",
            "rust-analyzer.showReferences",
            "rust-analyzer.gotoLocation",
            "editor.action.triggerParameterHints",
        },
    }
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities, true)

    if pcall(require, "cmp_nvim_lsp") then
        local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities = vim.tbl_deep_extend("force", {}, capabilities, cmp_capabilities)
    end

    return capabilities
end

--- Toggle between pylsp and basedpyright for Python files
function M.toggle_python_lsp()
    -- Determine which LSP to enable next
    local next_lsp = _G.active_python_lsp == "pylsp" and "basedpyright" or "pylsp"
    local prev_lsp = _G.active_python_lsp

    -- Get current buffer
    local bufnr = vim.api.nvim_get_current_buf()

    -- Stop the current Python LSP clients
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
        if client.name == "pylsp" or client.name == "basedpyright" then
            vim.lsp.stop_client(client.id)
        end
    end

    -- Update the global flag
    _G.active_python_lsp = next_lsp

    -- Enable the new LSP after a short delay
    vim.defer_fn(function()
        vim.lsp.enable(next_lsp)
        vim.notify(
            string.format("Switched from %s to %s", prev_lsp, next_lsp),
            vim.log.levels.INFO
        )
    end, 100)
end

--- Toggle BasedPyright typeCheckingMode and inlay hints
function M.toggle_basedpyright_settings()
    -- Get the LSP client for basedpyright
    local client = vim.lsp.get_clients({ name = "basedpyright" })[1]
    if not client then
        vim.notify("BasedPyright LSP is not active", vim.log.levels.WARN)
        return
    end

    -- Ensure settings structure exists
    if not client.config.settings then
        client.config.settings = {}
    end
    if not client.config.settings.basedpyright then
        client.config.settings.basedpyright = {}
    end
    if not client.config.settings.basedpyright.analysis then
        client.config.settings.basedpyright.analysis = {}
    end

    -- Get analysis settings
    local analysis = client.config.settings.basedpyright.analysis

    -- Toggle the typeCheckingMode
    if analysis.typeCheckingMode == "basic" then
        analysis.typeCheckingMode = "recommended"
    else
        analysis.typeCheckingMode = "basic"
    end

    -- Initialize inlayHints if it doesn't exist
    if not analysis.inlayHints then
        analysis.inlayHints = {
            variableTypes = true,
            functionReturnTypes = true,
            callArgumentNames = true
        }
    end

    -- Toggle the inlayHints settings
    local hints = analysis.inlayHints
    hints.variableTypes = not hints.variableTypes
    hints.functionReturnTypes = not hints.functionReturnTypes
    hints.callArgumentNames = not hints.callArgumentNames

    -- Restart the LSP to apply changes
    vim.lsp.stop_client(client.id)
    vim.defer_fn(function()
        vim.cmd("LspStart basedpyright")
        vim.notify(
            "BasedPyright restarted with typeCheckingMode: "
            .. analysis.typeCheckingMode
            .. "\nInlay Hints: "
            .. (hints.variableTypes and "enabled" or "disabled")
        )
    end, 100)
end

-- User commands for LSP toggles
function M.setup()
    vim.api.nvim_create_user_command("TogglePythonLsp", function()
        M.toggle_python_lsp()
    end, { desc = "Toggle between pylsp and basedpyright" })

    vim.api.nvim_create_user_command("ToggleBasedPyrightSettings", function()
        M.toggle_basedpyright_settings()
    end, { desc = "Toggle BasedPyright type checking mode and inlay hints" })


    vim.api.nvim_create_autocmd('FileType', {
        pattern = {
            "python"
        },
        callback = function(event)
            local bo = vim.bo[event.buf]
            local lsp = require("custom.lsp")
            vim.keymap.set("n", "<leader>ut", function() lsp.toggle_basedpyright_settings() end,
                { desc = "Toggle BasedPyright Settings", buffer = event.buf, silent = true })
        end
    })
end

return M
