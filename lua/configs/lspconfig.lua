local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities
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


-- Auto-enable inlay hints for all LSP-attached buffers
local inlay_hint_group = vim.api.nvim_create_augroup("LspInlayHints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = inlay_hint_group,
  callback = function(args)
    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

