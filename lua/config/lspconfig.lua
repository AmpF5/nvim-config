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
  severity_sort = true,
})

-- Format on save
do
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = "*",
    callback = function()
      vim.lsp.buf.format({ async = false })
    end,
  })
end

-- Auto-enable inlay hints for all LSP-attached buffers (except Rust, handled by rustaceanvim)
do
  local inlay_hint_group = vim.api.nvim_create_augroup("LspInlayHints", {})
  vim.api.nvim_create_autocmd("LspAttach", {
    group = inlay_hint_group,
    callback = function(args)
      if vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end
    end,
  })
end

for server, config in pairs(servers) do
  config.on_attach = on_attach
  config.capabilities = capabilities
  lspconfig[server].setup(config)
end

