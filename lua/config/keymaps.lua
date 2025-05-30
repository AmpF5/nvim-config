-- shorthand
local map = vim.keymap.set

-- normal-mode QoL
map("n", ";", ":", { desc = "CMD enter command mode" })

-- insert-mode escape
map("i", "jk", "<ESC>")

-- delete previous word
map("i", "<A-BS>", "<C-w>", { desc = "Delete previous word" })
map("i", "<M-BS>", "<C-w>", { desc = "Delete previous word (mac term)" })

-- LSP code actions
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code actions" })

-- Quick-save with Ctrl-S in normal, insert & visual modes
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- insert-mode Ctrl+H/J/K/L → move cursor
map("i", "<C-h>", "<Left>",  { desc = "Move left"  })
map("i", "<C-j>", "<Down>",  { desc = "Move down"  })
map("i", "<C-k>", "<Up>",    { desc = "Move up"    })
map("i", "<C-l>", "<Right>", { desc = "Move right" })

-- In insert mode, Ctrl-Q → start of line; Ctrl-E → end of line
map("i", "<C-q>", "<C-o>^", { desc = "Insert: jump to first non-blank" })
map("i", "<C-e>", "<C-o>$", { desc = "Insert: jump to end of line" })

-- Undo with Ctrl-Z
map({ "n", "i", "v" }, "<C-z>", function()
  -- in insert mode we need to drop back to normal to undo
  if vim.fn.mode() == "i" then
    return vim.api.nvim_replace_termcodes("<C-o>u", true, false, true)
  else
    return "u"
  end
end, { expr = true, desc = "Undo" })

-- Redo with Ctrl-Shift-Z
map({ "n", "i", "v" }, "<C-S-z>", function()
  if vim.fn.mode() == "i" then
    return vim.api.nvim_replace_termcodes("<C-o><C-r>", true, false, true)
  else
    return "<C-r>"
  end
end, { expr = true, desc = "Redo" })

-- Toggle native LSP inlay hints (Neovim ≥0.10 / 0.11+)
map("n", "<leader>ih", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  
  -- Skip toggle for Rust files (handled by rustaceanvim)
  if filetype == "rust" then
    return
  end
  
  -- check if hints are currently enabled for this buffer
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  -- flip the state
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end, { desc = "Toggle inlay hints" })

-- Toggle LSP references with telescope
map("n", "<leader>gr", function()
  require("telescope.builtin").lsp_references({
    prompt_title = "LSP References",
    include_declaration = false, -- omit the declaration itself if you want
  })
end, { desc = "Go to LSP References" })

-- Web development specific keymaps ----------------------------------------

-- Format document
map("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format document" })

-- Package.json version management (if package-info is loaded)
map("n", "<leader>ns", function()
  if pcall(require, "package-info") then
    require("package-info").show()
  end
end, { desc = "Show package versions" })

map("n", "<leader>nc", function()
  if pcall(require, "package-info") then
    require("package-info").hide()
  end
end, { desc = "Hide package versions" })

map("n", "<leader>nu", function()
  if pcall(require, "package-info") then
    require("package-info").update()
  end
end, { desc = "Update package" })

map("n", "<leader>nd", function()
  if pcall(require, "package-info") then
    require("package-info").delete()
  end
end, { desc = "Delete package" })

map("n", "<leader>ni", function()
  if pcall(require, "package-info") then
    require("package-info").install()
  end
end, { desc = "Install package" })

map("n", "<leader>np", function()
  if pcall(require, "package-info") then
    require("package-info").change_version()
  end
end, { desc = "Change package version" })

-- Rust development specific keymaps ----------------------------------------
-- These will only work when rustaceanvim is loaded and in Rust files

map("n", "<leader>rr", function()
  if vim.fn.exists(':RustLsp') == 2 then
    vim.cmd.RustLsp('run')
  end
end, { desc = "Rust: Run current target" })

map("n", "<leader>rd", function()
  if vim.fn.exists(':RustLsp') == 2 then
    vim.cmd.RustLsp('debuggables')
  end
end, { desc = "Rust: Debug current target" })

map("n", "<leader>rt", function()
  if vim.fn.exists(':RustLsp') == 2 then
    vim.cmd.RustLsp('testables')
  end
end, { desc = "Rust: Run tests" })

map("n", "<leader>re", function()
  if vim.fn.exists(':RustLsp') == 2 then
    vim.cmd.RustLsp('explainError')
  end
end, { desc = "Rust: Explain error" })

map("n", "<leader>rm", function()
  if vim.fn.exists(':RustLsp') == 2 then
    vim.cmd.RustLsp('expandMacro')
  end
end, { desc = "Rust: Expand macro" })

map("n", "<leader>rc", function()
  if vim.fn.exists(':RustLsp') == 2 then
    vim.cmd.RustLsp('openCargo')
  end
end, { desc = "Rust: Open Cargo.toml" })

map("n", "<leader>rp", function()
  if vim.fn.exists(':RustLsp') == 2 then
    vim.cmd.RustLsp('parentModule')
  end
end, { desc = "Rust: Go to parent module" })

map("n", "<leader>rj", function()
  if vim.fn.exists(':RustLsp') == 2 then
    vim.cmd.RustLsp('joinLines')
  end
end, { desc = "Rust: Join lines" })

map("n", "<leader>ra", function()
  if vim.fn.exists(':RustLsp') == 2 then
    vim.cmd.RustLsp('codeAction')
  end
end, { desc = "Rust: Code actions" })

-- Toggle inlay hints specifically for Rust
map("n", "<leader>rh", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  
  if filetype == "rust" then
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  end
end, { desc = "Rust: Toggle inlay hints" })

-- Crates.nvim keymaps for Cargo.toml
map("n", "<leader>ct", function()
  if pcall(require, "crates") then
    require("crates").toggle()
  end
end, { desc = "Crates: Toggle" })

map("n", "<leader>cr", function()
  if pcall(require, "crates") then
    require("crates").reload()
  end
end, { desc = "Crates: Reload" })

map("n", "<leader>cv", function()
  if pcall(require, "crates") then
    require("crates").show_versions_popup()
  end
end, { desc = "Crates: Show versions" })

map("n", "<leader>cf", function()
  if pcall(require, "crates") then
    require("crates").show_features_popup()
  end
end, { desc = "Crates: Show features" })

map("n", "<leader>cd", function()
  if pcall(require, "crates") then
    require("crates").show_dependencies_popup()
  end
end, { desc = "Crates: Show dependencies" })

map("n", "<leader>cu", function()
  if pcall(require, "crates") then
    require("crates").update_crate()
  end
end, { desc = "Crates: Update crate" })

map("v", "<leader>cu", function()
  if pcall(require, "crates") then
    require("crates").update_crates()
  end
end, { desc = "Crates: Update selected crates" })

map("n", "<leader>ca", function()
  if pcall(require, "crates") then
    require("crates").update_all_crates()
  end
end, { desc = "Crates: Update all crates" })

map("n", "<leader>cU", function()
  if pcall(require, "crates") then
    require("crates").upgrade_crate()
  end
end, { desc = "Crates: Upgrade crate" })

map("v", "<leader>cU", function()
  if pcall(require, "crates") then
    require("crates").upgrade_crates()
  end
end, { desc = "Crates: Upgrade selected crates" })

map("n", "<leader>cA", function()
  if pcall(require, "crates") then
    require("crates").upgrade_all_crates()
  end
end, { desc = "Crates: Upgrade all crates" })
