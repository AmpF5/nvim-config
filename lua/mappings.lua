require "nvchad.mappings"

-- ~/.config/nvim/lua/custom/mappings.lua

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

-- In insert mode, Ctrl-A → start of line; Ctrl-E → end of line
map("i", "<C-a>", "<C-o>^", { desc = "Insert: jump to first non-blank" })
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
  local bufnr   = vim.api.nvim_get_current_buf()
  -- check if hints are currently enabled for this buffer
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  -- flip the state
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end, { desc = "Toggle inlay hints" })
