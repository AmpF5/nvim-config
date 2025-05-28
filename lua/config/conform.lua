local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    
    -- C# / .NET
    cs = { "csharpier" },
    
    -- Web languages
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettier" },
    jsonc = { "prettier" },
    
    -- Razor (Blazor)
    razor = { "prettier" },
  },

  -- Enable format on save
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options