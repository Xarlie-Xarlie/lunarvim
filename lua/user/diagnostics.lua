-- ╭──────────────────────────────────────────────────────────╮
-- │ Diagnostics Configuration                                │
-- ╰──────────────────────────────────────────────────────────╯

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  float = {
    border = "single",
    format = function(diagnostic)
      local source = diagnostic.source or "Unknown source"
      local code = diagnostic.code or
          (diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code) or "No code"
      return string.format(
        "%s (%s) [%s]",
        diagnostic.message,
        source,
        code
      )
    end,
  },
})
