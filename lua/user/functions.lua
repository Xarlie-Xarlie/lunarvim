-- ╭──────────────────────────────────────────────────────────╮
-- │ Custom Functions                                         │
-- ╰──────────────────────────────────────────────────────────╯

-- Quick Chat with Copilot
function CustomQuickChat()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, {
      selection = require("CopilotChat.select").buffer
    })
  end
end

-- Custom Generate Pull Request
function CustomGeneratePullRequest()
  local task_link = vim.fn.input("Task link (format: [ERP-111 Task Name](https://linear.com/...)): ")
  local commit_count = vim.fn.input("Number of commits to include: ")

  local pull_request_prompt = [[
Please generate a pull request description based on the changes made in the code.
Use the pull request template structure.
For the '### Issues Resolved' section, include the Linear task link I provided.
Summarize the commits to create a comprehensive PR description.

In the section '### Principais pontos a serem revisados', mark everygthing with an x.
]]

  if task_link ~= "" and commit_count ~= "" then
    require("CopilotChat").ask(
      string.format("%s\n\n### Issues Resolved: %s\n\n", pull_request_prompt, task_link),
      {
        context = { string.format("system:`git log -n %s`", commit_count), "file:`.github/pull_request_template.md`" },
      }
    )
  else
    print("Both task link and number of commits are required.")
  end
end

-- Custom Live Grep
function CustomLiveGrep()
  local include_glob = vim.fn.input("Include Glob (e.g., '*.ex* *.lock*'): ")
  local exclude_glob = vim.fn.input("Exclude Glob (e.g., '*.exs* *.tmp*'): ")

  local glob_pattern = {}

  for pattern in include_glob:gmatch("%S+") do
    table.insert(glob_pattern, pattern)
  end

  for pattern in exclude_glob:gmatch("%S+") do
    table.insert(glob_pattern, "!" .. pattern)
  end
  print("Glob Pattern: " .. vim.inspect(glob_pattern))

  require("telescope.builtin").live_grep({ glob_pattern = glob_pattern })
end

-- Test in Floating Window
local jest_window = nil
local jest_buffer = nil

function ToggleJestFloatingWindow()
  if jest_window and vim.api.nvim_win_is_valid(jest_window) then
    vim.api.nvim_win_close(jest_window, true)
    jest_window = nil
    return
  end

  if not jest_buffer or not vim.api.nvim_buf_is_valid(jest_buffer) then
    jest_buffer = vim.api.nvim_create_buf(false, true)
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
  }
  jest_window = vim.api.nvim_open_win(jest_buffer, true, opts)
end

function RunJestInFloatingWindow(current_file)
  if not jest_window or not vim.api.nvim_win_is_valid(jest_window) then
    ToggleJestFloatingWindow()
  end

  if not jest_buffer or not vim.api.nvim_buf_is_valid(jest_buffer) then
    jest_buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(jest_window, jest_buffer)
  end

  local file_extension = vim.fn.fnamemodify(current_file, ":e")

  local cmd
  if file_extension == "exs" then
    cmd = "mix test " .. current_file
  elseif file_extension == "js" or file_extension == "ts" then
    cmd = "npx jest " .. current_file
  else
    vim.api.nvim_buf_set_lines(jest_buffer, 0, -1, false, { "Unsupported file type: " .. current_file })
    return
  end

  vim.api.nvim_buf_set_lines(jest_buffer, 0, -1, false,
    { "Running tests...", "Current file: " .. current_file, "Command: " .. cmd })

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(jest_buffer, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(jest_buffer, -1, -1, false, data)
      end
    end,
    on_exit = function()
      vim.api.nvim_buf_set_lines(jest_buffer, -1, -1, false, { "", "Test run completed." })
    end,
  })
end
