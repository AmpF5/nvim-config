-- Get capabilities from blink.cmp or fallback to default
local function get_capabilities()
  local has_blink, blink = pcall(require, "blink.cmp")
  if has_blink then
    return blink.get_lsp_capabilities()
  end
  
  local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    return cmp_lsp.default_capabilities()
  end
  
  return vim.lsp.protocol.make_client_capabilities()
end

-- Default on_attach function
local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Enable hover and signature help
  if client.server_capabilities.hoverProvider then
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'LSP Hover' })
  end
  
  if client.server_capabilities.signatureHelpProvider then
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'LSP Signature Help' })
  end

  -- Enable formatting if supported
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = bufnr, desc = 'LSP Format' })
  end
end

local capabilities = get_capabilities()
local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

vim.diagnostic.config({
  virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

-- Format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Auto-enable inlay hints for all LSP-attached buffers (except Rust, handled by rustaceanvim)
local inlay_hint_group = vim.api.nvim_create_augroup("LspInlayHints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = inlay_hint_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Skip rust-analyzer as it's handled by rustaceanvim
    if client and client.name ~= "rust_analyzer" then
      vim.defer_fn(function()
        if vim.lsp.inlay_hint and vim.api.nvim_buf_is_valid(args.buf) then
          pcall(vim.lsp.inlay_hint.enable, true, { bufnr = args.buf })
        end
      end, 100)
    end
  end,
})

-- C# / OmniSharp configuration
lspconfig.omnisharp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { 
    "dotnet", 
    vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp.dll",
    "--languageserver",
    "--hostPID", tostring(vim.fn.getpid())
  },
  enable_import_completion = true,
  organize_imports_on_format = true,
  enable_roslyn_analyzers = true,
  root_dir = util.root_pattern("*.sln", "*.csproj", "omnisharp.json", "function.json"),
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
    MsBuild = {
      LoadProjectsOnDemand = false,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
    },
  },
})

-- HTML language server
lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    html = {
      format = {
        templating = true,
        wrapLineLength = 120,
        wrapAttributes = "auto",
      },
      hover = {
        documentation = true,
        references = true,
      },
    },
  },
})

-- CSS language server
lspconfig.cssls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
})

-- TypeScript/JavaScript language server
lspconfig.ts_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

-- ESLint language server
lspconfig.eslint.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    workingDirectory = { mode = "auto" },
  },
})

-- Emmet language server
lspconfig.emmet_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "razor",
  },
})

