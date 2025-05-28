return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_formatter =
        "<author> • <author_time:%Y-%m-%d> • <summary>",
      signs = {
        add          = { text = "▏" },
        change       = { text = "▏" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▏" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set
        -- Navigation
        map("n", "]c", gs.next_hunk,  { buffer = bufnr, desc = "Next hunk" })
        map("n", "[c", gs.prev_hunk,  { buffer = bufnr, desc = "Prev hunk" })
        -- Stage / reset
        map({ "n", "v" }, "<leader>hs", gs.stage_hunk,
            { buffer = bufnr, desc = "Stage hunk" })
        map({ "n", "v" }, "<leader>hr", gs.reset_hunk,
            { buffer = bufnr, desc = "Reset hunk" })
        -- Preview
        map("n", "<leader>hp", gs.preview_hunk_inline,
            { buffer = bufnr, desc = "Preview hunk" })
      end,
    },
  },
}
