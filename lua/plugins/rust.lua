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
          -- Enable hover actions
          hover_actions = {
            auto_focus = true,
            border = "rounded",
          },
          -- Code lens (show references/implementations inline)
          code_lens = {
            enable = true,
          },
          -- Enable on-type formatting
          on_initialized = function()
            vim.cmd([[
              autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
            ]])
          end,
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- Use LazyVim's default on_attach if available
            local has_lazyvim, lazyvim_lsp = pcall(require, "lazyvim.util.lsp")
            if has_lazyvim and lazyvim_lsp.on_attach then
              lazyvim_lsp.on_attach(client, bufnr)
            end
            
            -- Safely enable inlay hints for Rust files
            vim.defer_fn(function()
              if vim.lsp.inlay_hint and vim.api.nvim_buf_is_valid(bufnr) then
                pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
              end
            end, 100)
            
            -- Enable code lens
            if client.server_capabilities.codeLensProvider then
              vim.lsp.codelens.refresh()
            end
          end,
          capabilities = (function()
            local has_blink, blink = pcall(require, "blink.cmp")
            if has_blink then
              return blink.get_lsp_capabilities()
            end
            
            local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            if has_cmp then
              return cmp_lsp.default_capabilities()
            end
            
            return vim.lsp.protocol.make_client_capabilities()
          end)(),
          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              -- Import settings
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
              -- Cargo settings
              cargo = {
                buildScripts = {
                  enable = true,
                },
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
                features = "all",
                extraEnv = {},
                extraArgs = {},
                target = nil,
              },
              -- Procedural macro support
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              -- Check on save with clippy
              checkOnSave = {
                enable = true,
                command = "clippy",
                extraArgs = { "--all", "--", "-W", "clippy::all" },
                allTargets = true,
              },
              -- Enhanced diagnostics
              diagnostics = {
                enable = true,
                enableExperimental = true,
                disabled = {},
                warningsAsHint = {},
                warningsAsInfo = {},
              },
              -- Completion settings
              completion = {
                addCallParenthesis = true,
                addCallArgumentSnippets = true,
                postfix = {
                  enable = true,
                },
                autoimport = {
                  enable = true,
                },
              },
              -- Type inference improvements
              typeInference = {
                enable = true,
              },
              -- Assist (code actions) settings
              assist = {
                importGranularity = "module",
                importPrefix = "by_self",
                importGroup = true,
                emitMustUse = true,
              },
              -- Lens settings
              lens = {
                enable = true,
                methodReferences = true,
                references = true,
                enumVariantReferences = true,
                implementations = true,
                run = true,
                debug = true,
              },
              -- Hover settings
              hover = {
                actions = {
                  enable = true,
                  implementations = true,
                  references = true,
                  run = true,
                  debug = true,
                },
                documentation = {
                  enable = true,
                },
                links = {
                  enable = true,
                },
              },
              -- Inlay hints - comprehensive IDE-like experience
              inlayHints = {
                bindingModeHints = {
                  enable = true,
                },
                chainingHints = {
                  enable = true,
                },
                closingBraceHints = {
                  enable = true,
                  minLines = 25,
                },
                closureReturnTypeHints = {
                  enable = "with_block",
                },
                discriminantHints = {
                  enable = "fieldless",
                },
                expressionAdjustmentHints = {
                  enable = "never",
                  hideOutsideUnsafe = false,
                  mode = "prefix",
                },
                implicitDrops = {
                  enable = true,
                },
                lifetimeElisionHints = {
                  enable = "skip_trivial",
                  useParameterNames = true,
                },
                maxLength = 25,
                parameterHints = {
                  enable = true,
                },
                reborrowHints = {
                  enable = "never",
                },
                renderColons = true,
                typeHints = {
                  enable = true,
                  hideClosureInitialization = false,
                  hideNamedConstructor = false,
                },
              },
              -- Workspace symbol search
              workspace = {
                symbol = {
                  search = {
                    scope = "workspace_and_dependencies",
                    kind = "all_symbols",
                  },
                },
              },
              -- Semantic tokens for better syntax highlighting
              semanticTokens = {
                enable = true,
              },
              -- Enhanced type information
              typing = {
                autoClosingAngleBrackets = {
                  enable = true,
                },
              },
              -- Call hierarchy
              callHierarchy = {
                enable = true,
              },
              -- Type hierarchy
              typeHierarchy = {
                enable = true,
              },
              -- File watching
              files = {
                watcher = "notify",
                excludeDirs = { ".direnv", "node_modules" },
              },
              -- Notification settings
              notifications = {
                cargoTomlNotFound = true,
              },
              -- Rustfmt settings
              rustfmt = {
                extraArgs = {},
                overrideCommand = nil,
                rangeFormatting = {
                  enable = false,
                },
              },
              -- Join lines behavior
              joinLines = {
                joinElseIf = true,
                removeTrailingComma = true,
                unwrapTrivialBlock = true,
                joinAssignments = true,
              },
              -- Interpret tests
              interpret = {
                tests = true,
              },
              -- Rustc source path
              rustcSource = nil,
            },
          },
        },
        -- DAP configuration for debugging
        dap = {
          -- Will auto-detect codelldb if available
          autoload_configurations = true,
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
