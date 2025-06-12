return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Go
        "gopls",                -- Go language server
        "goimports",            -- Go import organizer and formatter
        "gofumpt",              -- Stricter gofmt
        "golines",              -- Go line length formatter
        "golangci-lint",        -- Go linter
        "delve",                -- Go debugger
        "gotests",              -- Go test generator
        "gomodifytags",         -- Go struct tag modifier
        "impl",                 -- Go interface implementation generator
        
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
    opts = function()
    local Keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- stylua: ignore
    vim.list_extend(Keys, {
      { "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
      { "gd", "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>", desc = "Goto Definition" },
      { "gr", "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>", desc = "References" },
      { "gy", "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Definition" },
    })
  end,
  },
  {
    "folke/todo-comments.nvim",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>st", function() require("todo-comments.fzf").todo() end, desc = "Todo" },
      { "<leader>sT", function () require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
      run_on_start = true,
    },
  }
