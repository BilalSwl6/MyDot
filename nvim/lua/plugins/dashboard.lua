return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Required for icons
  config = function()
    local dashboard = require("dashboard")

    local quotes = {
      "🚀 Keep pushing forward!",
      "💡 Stay curious, keep learning.",
      "🎯 Focus on progress, not perfection.",
      "🔥 Code, debug, repeat!",
      "🌟 Great things take time.",
      "🎶 Debugging is like tuning an instrument.",
      "📖 Read the error, it’s your best friend.",
      "🔧 Fix one bug, learn two things!",
    }

    local DashboardAPI = {}

    function DashboardAPI.update_footer()
      dashboard.setup({
        theme = "hyper",
        config = {
          header = {
            "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
            "████╗  ██║██║   ██║██║████╗ ████║",
            "██╔██╗ ██║██║   ██║██║██╔████╔██║",
            "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
          },
          shortcut = {
            { desc = "  Find File", group = "@string", action = "Telescope find_files", key = "f" },
            { desc = "  Recent Files", group = "@variable", action = "Telescope oldfiles", key = "o" },
            { desc = "  Find Text", group = "@label", action = "Telescope live_grep", key = "g" },
            { desc = "  Quit", group = "@macro", action = "qa", key = "q" },
          },
          footer = { quotes[math.random(#quotes)] }, -- Random quote
        },
      })
    end

    DashboardAPI.update_footer()
    _G.DashboardAPI = DashboardAPI
  end,
}
