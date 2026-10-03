-- ~/.config/nvim/lua/plugins/notebook.lua
-- Inline images need a terminal with the Kitty graphics protocol: Kitty, WezTerm, or Ghostty.
-- Elsewhere (Terminal.app, iTerm2, ...) image.nvim is skipped and molten shows text output only.

local has_kitty_graphics = vim.env.KITTY_WINDOW_ID ~= nil
  or vim.env.TERM_PROGRAM == "ghostty"
  or vim.env.TERM_PROGRAM == "WezTerm"

return {

  ------------------------------------------------------------------
  -- 1. Jupyter kernel execution inside Neovim buffers
  ------------------------------------------------------------------
  {
    "benlubas/molten-nvim",
    lazy = false,
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    dependencies = { "3rd/image.nvim" },
    init = function()
      vim.g.molten_image_provider = has_kitty_graphics and "image.nvim" or "none"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
    end,
    keys = {
      { "<leader>mi", ":MoltenInit<CR>", desc = "Molten: Init kernel" },
      { "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "Molten: Evaluate operator" },
      { "<leader>ml", ":MoltenEvaluateLine<CR>", desc = "Molten: Evaluate line" },
      { "<leader>mr", ":MoltenReevaluateCell<CR>", desc = "Molten: Re-eval cell" },
      { "<leader>mc", ":MoltenReevaluateAll<CR>", desc = "Molten: Re-eval all cells" },
      { "<leader>md", ":MoltenDelete<CR>", desc = "Molten: Delete cell" },
      { "<leader>mh", ":MoltenHideOutput<CR>", desc = "Molten: Hide output" },
      {
        "<leader>mv",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        mode = "v",
        desc = "Molten: Evaluate visual selection",
      },
    },
  },

  ------------------------------------------------------------------
  -- 2. Inline image rendering (plots, charts) via Kitty graphics protocol
  ------------------------------------------------------------------
  {
    "3rd/image.nvim",
    cond = has_kitty_graphics,
    opts = {
      backend = "kitty",
      -- don't fetch remote images (e.g. README badges) just because a markdown file was opened
      integrations = { markdown = { download_remote_images = false } },
      max_width = 100,
      max_height = 30,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  ------------------------------------------------------------------
  -- 3. .ipynb <-> .py/.md pairing so git diffs stay clean
  ------------------------------------------------------------------
  {
    "GCBallesteros/jupytext.nvim",
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
    lazy = false,
  },

  ------------------------------------------------------------------
  -- 4. Pretty markdown/code-block rendering for notebook cells
  ------------------------------------------------------------------
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {
      code = { sign = false, width = "block", right_pad = 1 },
      heading = { sign = false },
    },
  },

  ------------------------------------------------------------------
  -- 5. Python-specific LSP/lint (ML/quant workloads)
  ------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        ruff = {},
      },
    },
  },

  ------------------------------------------------------------------
  -- 6. REPL-driven development for quick iteration outside notebooks
  ------------------------------------------------------------------
  {
    "Vigemus/iron.nvim",
    config = function()
      require("iron.core").setup({
        config = {
          repl_definition = {
            python = { command = { "ipython", "--no-autoindent" } },
          },
          repl_open_cmd = require("iron.view").right(80),
        },
        keymaps = {
          send_motion = "<leader>rc",
          visual_send = "<leader>rc",
          send_line = "<leader>rl",
        },
      })
    end,
  },
}
