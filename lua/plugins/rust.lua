return {
  {
    "saecki/crates.nvim",           -- version pop-ups & upgrades in Cargo.toml
    event = { "BufRead Cargo.toml" },
    config = true,
  },
  {
    "mrcjkb/rustaceanvim",          -- fork of rust-tools with inlay hints, etc.
    version = "^4",
    ft = { "rust" },
    dependencies = { "williamboman/mason.nvim" },
  },
}
