-- ╭──────────────────────────────────────────────────────────╮
-- │ Key Mappings                                             │
-- ╰──────────────────────────────────────────────────────────╯

-- Custom KeyMappings
lvim.builtin.which_key.mappings["s"].T = { ":lua CustomLiveGrep()<CR>", "Custom Live Grep" }
lvim.builtin.which_key.mappings["t"] = {
  name = "Quick Test",
  t = { ":lua RunJestInFloatingWindow(vim.fn.expand('%'))<CR>", mode = "n", "Run Jest in floating window" },
  f = { ":lua ToggleJestFloatingWindow()<CR>", mode = "n", "Toggle Jest floating window" },
}
lvim.builtin.which_key.mappings["f"] = { "<cmd>Telescope find_files<CR>", "Find files" }
lvim.builtin.which_key.mappings["z"] = {
  name = "CopilotChat",
  c = { ":CopilotChat<CR>", mode = "n", "Chat with Copilot" },
  q = { ":lua CustomQuickChat()<CR>", mode = "n", "Quick Chat with Copilot" },
  e = { ":CopilotChatExplain<CR>", mode = "v", "Explain Code" },
  r = { ":CopilotChatReview<CR>", mode = "v", "Review Code" },
  f = { ":CopilotChatFix<CR>", mode = "v", "Fix Code Issues" },
  o = { ":CopilotChatOptimize<CR>", mode = "v", "Optimize Code" },
  d = { ":CopilotChatDocs<CR>", mode = "v", "Generate Docs" },
  t = { ":CopilotChatTests<CR>", mode = "v", "Generate Tests" },
  m = { ":CopilotChatCommit<CR>", mode = "n", "Generate Commit Message" },
  n = { ":CopilotChatRename<CR>", mode = "v", "Rename the variable" },
  s = { ":CopilotChatSave ", mode = "n", "Save the history" },
  l = { ":CopilotChatLoad ", mode = "n", "Load the history" },
}
