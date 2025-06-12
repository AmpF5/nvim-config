return {
  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    dependencies = { "nvim-telescope/telescope.nvim" },

    keys = {
      {
        "<leader>ca",
        function()
          require("actions-preview").code_actions()
        end,
        desc = "LSP code actions (preview)",
        mode = { "n", "v" },
      },
    },

    opts = {
      diff = { ctxlen = 3 },
      backend = { "telescope", "nui" },
    },
  },
}
