return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				-- Go
				"gopls", -- Go language server
				"goimports", -- Go import organizer and formatter
				"gofumpt", -- Stricter gofmt
				"golines", -- Go line length formatter
				"golangci-lint", -- Go linter
				"delve", -- Go debugger
				"gotests", -- Go test generator
				"gomodifytags", -- Go struct tag modifier
				"impl", -- Go interface implementation generator

				-- Rust
				-- "rust-analyzer",

				-- C# / .NET
				-- "omnisharp",            -- C# LSP server
				"csharpier", -- C# formatter
				"netcoredbg", -- .NET debugger

				-- Web languages
				"html-lsp", -- HTML LSP
				"css-lsp", -- CSS LSP
				"emmet-ls", -- Emmet for HTML/CSS
				"typescript-language-server", -- TypeScript/JavaScript LSP
				"eslint-lsp", -- ESLint LSP

				-- Formatters
				"prettier", -- HTML, CSS, JS, JSON formatter
				"prettierd", -- Faster prettier daemon
				"eslint_d", -- Faster ESLint daemon

				-- Additional tools
				"stylua", -- Lua formatter (handy if you hack on NvChad)
				"codelldb", -- Debug adapter
				"js-debug-adapter",
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {},
	},
	{ -- ① your existing LSP setup + CodeLens hookup
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			------------------------------------------------------------------
			-- keep your FzfLua keymaps exactly as before
			------------------------------------------------------------------
			local Keys = require("lazyvim.plugins.lsp.keymaps").get()
			vim.list_extend(Keys, {
				{ "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
				{ "gd", "<cmd>FzfLua lsp_definitions     jump1=true ignore_current_line=true<cr>", desc = "Goto Definition" },
				{ "gr", "<cmd>FzfLua lsp_references     jump1=true ignore_current_line=true<cr>", desc = "References" },
				{ "gy", "<cmd>FzfLua lsp_typedefs       jump1=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Def" },
			})

			------------------------------------------------------------------
			-- CodeLens auto-refresh
			------------------------------------------------------------------
			local previous_on_attach = opts.on_attach
			opts.on_attach = function(client, bufnr)
				if previous_on_attach then
					previous_on_attach(client, bufnr)
				end

				-- only if the server supports CodeLens
				if client.server_capabilities.codeLensProvider then
					local group = vim.api.nvim_create_augroup("LspCodeLens_" .. bufnr, { clear = true })
					vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
						group = group,
						buffer = bufnr,
						callback = vim.lsp.codelens.refresh,
					})
					vim.lsp.codelens.refresh() -- first run
				end
			end

			------------------------------------------------------------------
			-- OPTIONAL: enable lens in language-server settings
			------------------------------------------------------------------
			opts.servers = opts.servers or {}
			opts.servers.lua_ls =
				vim.tbl_deep_extend("force", opts.servers.lua_ls or {}, { settings = { Lua = { codeLens = { enable = true } } } })
			opts.servers.rust_analyzer = vim.tbl_deep_extend(
				"force",
				opts.servers.rust_analyzer or {},
				{ settings = { ["rust-analyzer"] = { lens = { enable = true } } } }
			)
		end,
	},

	{ -- ② thin wrapper that actually draws the counts
		"VidocqH/lsp-lens.nvim",
		event = "LspAttach", -- load lazily when an LSP attaches
		opts = { enable = true }, -- default config is fine; tweak if you like
	},
	{
		"folke/todo-comments.nvim",
		optional = true,
	-- stylua: ignore
	keys = {
		{ "<leader>st", function() require("todo-comments.fzf").todo() end,                                           desc = "Todo" },
		{ "<leader>sT", function() require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } }) end,  desc = "Todo/Fix/Fixme" },
	},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		run_on_start = true,
	},
}
