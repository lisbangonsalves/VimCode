local claude_term = nil

-- toggleterm can't open a split while a floating window (e.g. the Snacks explorer) is focused
local function leave_float()
  if vim.fn.win_gettype() ~= "popup" then return end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.fn.win_gettype(win) == "" then return vim.api.nvim_set_current_win(win) end
  end
end

local function toggle_term(n)
  return function()
    leave_float()
    vim.cmd(n .. "ToggleTerm direction=horizontal")
  end
end

local function toggle_claude()
  leave_float()
  local Terminal = require("toggleterm.terminal").Terminal
  if not claude_term then
    claude_term = Terminal:new({
      cmd = "claude",
      count = 99,
      direction = "vertical",
      close_on_exit = false,
      on_open = function()
        vim.cmd("wincmd L")
        vim.cmd("vertical resize 70")
        vim.cmd("setlocal winfixwidth")
      end,
    })
  end
  claude_term:toggle()
end

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "horizontal",
      size = 15,
      start_in_insert = true,
      persist_size = true,
      on_open = function()
        vim.cmd("wincmd J")
        vim.cmd("resize 15")
      end,
    },
    keys = {
      { "<leader>t1", toggle_term(1), desc = "Terminal 1" },
      { "<leader>t2", toggle_term(2), desc = "Terminal 2" },
      { "<leader>t3", toggle_term(3), desc = "Terminal 3" },
      { "<leader>ac", toggle_claude, desc = "Toggle Claude Code" },
    },
  },
}
