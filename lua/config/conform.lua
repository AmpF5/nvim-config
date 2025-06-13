local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    
    -- Rust
    rust = { "rustfmt" },

    -- Go
    go = { "gofmt", "goimports", stop_after_first = true },
  },

  -- Enable format on save
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options