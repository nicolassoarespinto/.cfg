local M = {}

-- Global flag to track active Python LSP(default: pylsp)
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
    vim.lsp.enable(prev_lsp, false)
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

function M.create_commands()
  vim.api.nvim_create_user_command("TogglePythonLsp", function()
    M.toggle_python_lsp()
  end, { desc = "Toggle between pylsp and basedpyright" })

  vim.api.nvim_create_user_command("LSPRestart", function()
      vim.iter(vim.lsp.get_clients()):each(function(client) client:stop() end)
      M.start_servers()
    end,
    { desc = "Force restart all LSP clients" }
  )
end

function M.lsp_servers()
  local servers = {
    r_language_server = true,
    bashls = true,
    ts_ls = true,
    markdown_oxide = true,
    pylsp = false,
    ty = true,
    ruff = true,
    basedpyright = false,
    lua_ls = true,
  }

  return servers
end

function M.start_servers()
  local servers = M.lsp_servers()
  for name, enabled in pairs(servers) do
    if enabled then
        vim.lsp.enable(name)
    end
  end
end

-- User commands for LSP toggles
function M.setup()
  local capabilities = M.make_capabilities()

  local servers = M.lsp_servers()

  local servers_to_install = {
    "lua-language-server",
    "bash-language-server",
    "stylua"
  }

  require("mason").setup()
  require("mason-tool-installer").setup {
    ensure_installed = servers_to_install
  }

  for name, enabled in pairs(servers) do
    vim.lsp.config(name, {capabilities = capabilities})
    if enabled then
        -- vim.notify(string.format("enabled %s", name))
        vim.lsp.enable(name)
    end
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

      if client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
      end

      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
      vim.keymap.set("n", "[w", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", { buffer = bufnr })
      vim.keymap.set("n", "<leader>vd", "<cmd>lua vim.diagnostic.open_float()<CR>", { buffer = bufnr })
      vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.jump({count=1})<CR>", { buffer = bufnr })
      vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.jump({count=-1})<CR>", { buffer = bufnr })
      vim.keymap.set("n", "<leader>[a", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = bufnr })
      vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = bufnr })
      vim.keymap.set("i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = bufnr })
      vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<CR>",
        { buffer = bufnr })
      if pcall(require, "namu.namu_symbols") then
        vim.keymap.set("n", "<leader>sn", function() require("namu.namu_symbols").show() end,
          { buffer = bufnr, desc = "Symbols (Document)" })

        vim.keymap.set("n", "<leader>sd", function() require("namu.namu_diagnostics").show() end,
          { buffer = bufnr, desc = "Symbols (Document)" })
      end
    end,
  })

  vim.g.diagnostics_active = false
  vim.diagnostic.enable(false)

  local function toggle_diagnostics()
    if vim.g.diagnostics_active then
      vim.g.diagnostics_active = false
      vim.diagnostic.enable(false)
    else
      vim.g.diagnostics_active = true
      vim.diagnostic.enable(true)
    end
  end

  vim.keymap.set("n", "<leader>xd", toggle_diagnostics,
    { noremap = true, silent = true, desc = "Toggle vim diagnostics" })
  vim.keymap.set("n", "<leader>bf", ":lua vim.lsp.buf.format()<CR>", { desc = "Format buffer" })

  -- Set global capabilities for all LSP servers
  -- vim.lsp.config("*", {
  --   capabilities = capabilities,
  -- })
  --

  M.create_commands()
end

return M
