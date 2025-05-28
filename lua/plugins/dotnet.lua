return {
    -- Enhanced C# support
    {
        "Hoffs/omnisharp-extended-lsp.nvim",
        ft = { "cs" },
        dependencies = { "neovim/nvim-lspconfig" },
    },

    -- Razor syntax highlighting and support
    {
        "jlcrochet/vim-razor",
        ft = { "razor" },
    },
}