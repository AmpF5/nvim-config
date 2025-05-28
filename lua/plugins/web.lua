return {
  -- Auto tag closing for HTML/JSX
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "typescript", "jsx", "tsx", "vue", "xml", "razor" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,          -- Auto close tags
          enable_rename = true,         -- Auto rename pairs of tags
          enable_close_on_slash = false -- Auto close on trailing </
        },
      })
    end,
  },

  -- Better HTML/CSS/JS snippets
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascript", "typescript", "jsx", "tsx", "vue", "razor" },
    config = function()
      vim.g.user_emmet_leader_key = "<C-e>"
      vim.g.user_emmet_settings = {
        razor = {
          extends = "html",
        },
      }
    end,
  },

  -- Package.json version lens
  {
    "vuki656/package-info.nvim",
    ft = { "json" },
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup({
        colors = {
          up_to_date = "#3C4048",   -- already up to date
          outdated = "#fc514e",     -- needs update
        },
        icons = {
          enable = true,
          style = {
            up_to_date = "|  ",      -- Icon for up to date dependencies
            outdated = "|  ",        -- Icon for outdated dependencies
          },
        },
        autostart = true,           -- Whether to autostart when opening package.json
        hide_up_to_date = false,    -- Hide up to date versions
        hide_unstable_versions = false, -- Hide unstable versions from version list
      })
    end,
  },
}