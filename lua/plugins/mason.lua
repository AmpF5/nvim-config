return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Rust
        -- "rust-analyzer",
        
        -- C# / .NET
        -- "omnisharp",            -- C# LSP server
        "csharpier",            -- C# formatter
        "netcoredbg",           -- .NET debugger
        
        -- Web languages
        "html-lsp",             -- HTML LSP
        "css-lsp",              -- CSS LSP
        "emmet-ls",             -- Emmet for HTML/CSS
        "typescript-language-server", -- TypeScript/JavaScript LSP
        "eslint-lsp",           -- ESLint LSP
        
        -- Formatters
        "prettier",             -- HTML, CSS, JS, JSON formatter
        "prettierd",            -- Faster prettier daemon
        "eslint_d",             -- Faster ESLint daemon
        
        -- Additional tools
        "stylua",               -- Lua formatter (handy if you hack on NvChad)
        "codelldb",             -- Debug adapter
        "js-debug-adapter",  
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    opts = {}
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
      run_on_start = true,
    },
  }
