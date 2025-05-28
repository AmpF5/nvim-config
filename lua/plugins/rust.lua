return {
  {
    "saecki/crates.nvim",           -- version pop-ups & upgrades in Cargo.toml
    event = { "BufRead Cargo.toml" },
    config = true,
  },
}
