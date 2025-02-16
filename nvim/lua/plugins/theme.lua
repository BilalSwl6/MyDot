return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local vscode = require('vscode')
      vscode.setup({
        style = 'dark', -- Default style
        transparent = false, -- Set true if you want transparency
        italic_comments = true,
      })
      vim.cmd("colorscheme vscode") -- Apply theme
    end
  }
}
