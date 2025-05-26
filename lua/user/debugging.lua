-- ╭──────────────────────────────────────────────────────────╮
-- │ Debugging Configuration                                  │
-- ╰──────────────────────────────────────────────────────────╯

vim.g.dap_virtual_text = true
local dap = require("dap")

-- JavaScript/TypeScript debug adapter
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
  }
}

-- Chrome debug adapter
dap.adapters["pwa-chrome"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
  }
}
