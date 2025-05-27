require "nvchad.autocmds"

local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.lua",
    callback = function() vim.cmd("PackerCompile") end,
  })
end

return M