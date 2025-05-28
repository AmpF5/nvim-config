-- Rust toolchain & IDE goodies for NvChad (Lazy)
return {
  -- ---------------------------------------------------------------------------
  -- -- 1. Make Mason grab rust-analyzer, CodeLLDB, etc.
  -- ---------------------------------------------------------------------------
  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     opts.ensure_installed = opts.ensure_installed or {}
  --     vim.list_extend(opts.ensure_installed, {
  --       "rust_analyzer", -- LSP server
  --       "codelldb",      -- Debug adapter
  --       "stylua",        -- Lua formatter (handy if you hack on NvChad)
  --     })
  --   end,
  -- },
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   opts = function(_, opts)
  --     opts.ensure_installed = opts.ensure_installed or {}
  --     vim.list_extend(opts.ensure_installed, { "rust_analyzer" })
  --   end,
  -- },

  ---------------------------------------------------------------------------
  -- 2. rust-analyzer settings
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    ft = { "rust" },
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo       = { allFeatures = true },
              checkOnSave = { command = "clippy" },
              diagnostics = { enable = true },
            },
          },
        },
      }
    },
  },

  ---------------------------------------------------------------------------
  -- 3. Extra Rust-centric plugins
  ---------------------------------------------------------------------------
  {
    "saecki/crates.nvim",           -- version pop-ups & upgrades in Cargo.toml
    event = { "BufRead Cargo.toml" },
    config = true,
  },
  {
    "mrcjkb/rustaceanvim",          -- fork of rust-tools with inlay hints, etc.
    version = "^4",
    ft = { "rust" },
    dependencies = { "williamboman/mason.nvim" },
  },
}
