local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    c = { "clang-format" },
    cpp = { "clang-format" },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

require("conform").setup(options)
