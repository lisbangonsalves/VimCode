-- ~/.config/nvim/lua/plugins/look.lua
-- Reproduces the visual aesthetic: solarized-osaka colorscheme (dark background),
-- bufferline top tabs with diagnostic badges, lualine bottom statusline.

return {

  ------------------------------------------------------------------
  -- 1. Colorscheme (craftzdog's own plugin)
  ------------------------------------------------------------------
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
      },
    },
  },

  ------------------------------------------------------------------
  -- 2. Top tab bar with modified-dot + diagnostic badges
  ------------------------------------------------------------------
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "slant",
        always_show_bufferline = true,
      },
    },
  },

  ------------------------------------------------------------------
  -- 3. Bottom statusline (mode / branch / path / diagnostics / progress / time)
  ------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "solarized_dark",
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { { "filename", path = 1, symbols = { modified = " ●" } } },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
          "encoding",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location", { "os.date('%H:%M')", icon = "" } },
      },
    },
  },
}
