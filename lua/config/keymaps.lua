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

-- In insert mode, Ctrl-Q → start of line; Ctrl-E → end of line
map("i", "<C-q>", "<C-o>^", { desc = "Insert: jump to first non-blank" })
map("i", "<C-e>", "<C-o>$", { desc = "Insert: jump to end of line" })

