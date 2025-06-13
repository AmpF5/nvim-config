-- Golang plugin configuration for Neovim
return {
  -- Install Go development plugins
  {
    "fatih/vim-go",
    ft = { "go" },
    build = ":GoUpdateBinaries",
    config = function()
      -- Optional: Enable goimports on save
      vim.g.go_fmt_command = "goimports"
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go", "gomod" },
    config = function()
      require("go").setup({
        lsp_cfg = true, -- use go.nvim's default LSP config
        lsp_inlay_hints = {
          enable = true,
        },
        lsp_keymaps = true,
        lsp_codelens = true,
        dap_debug = true,
      })z
  },
}
