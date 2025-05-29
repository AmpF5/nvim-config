-- Rust-specific keymaps and configuration
local bufnr = vim.api.nvim_get_current_buf()

-- Wait for rustaceanvim to be fully loaded
vim.defer_fn(function()
  -- Only set keymaps if RustLsp command is available
  if vim.fn.exists(':RustLsp') == 2 then
    -- Rustaceanvim keymaps
    vim.keymap.set(
      "n", 
      "<leader>a", 
      function()
        vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
      end,
      { silent = true, buffer = bufnr, desc = "Rust code actions" }
    )

    vim.keymap.set(
      "n", 
      "K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
      function()
        vim.cmd.RustLsp({'hover', 'actions'})
      end,
      { silent = true, buffer = bufnr, desc = "Rust hover actions" }
    )

    -- Additional rust-specific keymaps
    vim.keymap.set(
      "n",
      "<leader>rr",
      function()
        vim.cmd.RustLsp('run')
      end,
      { silent = true, buffer = bufnr, desc = "Rust run" }
    )

    vim.keymap.set(
      "n",
      "<leader>rd",
      function()
        vim.cmd.RustLsp('debuggables')
      end,
      { silent = true, buffer = bufnr, desc = "Rust debuggables" }
    )

    vim.keymap.set(
      "n",
      "<leader>rt",
      function()
        vim.cmd.RustLsp('testables')
      end,
      { silent = true, buffer = bufnr, desc = "Rust testables" }
    )

    vim.keymap.set(
      "n",
      "<leader>rm",
      function()
        vim.cmd.RustLsp('expandMacro')
      end,
      { silent = true, buffer = bufnr, desc = "Rust expand macro" }
    )
  end
end, 200)
