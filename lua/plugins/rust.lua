return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
          -- Add any tools configuration here if needed
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- Safely enable inlay hints for Rust files
            vim.defer_fn(function()
              if vim.lsp.inlay_hint and vim.api.nvim_buf_is_valid(bufnr) then
                pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
              end
            end, 100)
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              cargo = { 
                allFeatures = true 
              },
              checkOnSave = { 
                command = "clippy" 
              },
              diagnostics = { 
                enable = true 
              },
              inlayHints = {
                bindingModeHints = { enable = false },
                closureReturnTypeHints = { enable = "with_block" },
                lifetimeElisionHints = { enable = "skip_trivial" },
                parameterHints = { enable = false },
                typeHints = { enable = true },
                maxLength = 25,
              },
            },
          },
        },
        -- DAP configuration
        dap = {
          -- Will auto-detect codelldb if available
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",           -- version pop-ups & upgrades in Cargo.toml
    event = { "BufRead Cargo.toml" },
    config = true,
  },
}
