local claude_term = nil

local function toggle_claude()
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
      { "<leader>t1", "<cmd>1ToggleTerm direction=horizontal<CR>", desc = "Terminal 1" },
      { "<leader>t2", "<cmd>2ToggleTerm direction=horizontal<CR>", desc = "Terminal 2" },
      { "<leader>t3", "<cmd>3ToggleTerm direction=horizontal<CR>", desc = "Terminal 3" },
      { "<leader>ac", toggle_claude, desc = "Toggle Claude Code" },
    },
  },
}
