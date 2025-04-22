-- Database keymaps
local opts = { noremap = true, silent = true }

-- Simple command mappings
vim.keymap.set('n', '<leader>db', ':DBUIToggle<CR>', vim.tbl_extend('force', opts, { desc = "Toggle Database UI panel" }))
vim.keymap.set('n', '<leader>df', ':DBUIFindBuffer<CR>', vim.tbl_extend('force', opts, { desc = "Find database buffer" }))
vim.keymap.set('n', '<leader>dr', ':DBUIRenameBuffer<CR>', vim.tbl_extend('force', opts, { desc = "Rename database buffer" }))
vim.keymap.set('n', '<leader>dq', ':DBUILastQueryInfo<CR>', vim.tbl_extend('force', opts, { desc = "Show last query info" }))

-- Add database connection
vim.keymap.set('n', '<leader>da', function()
  vim.ui.input({ prompt = "Connection name: " }, function(name)
    if not name or name == "" then return end
    vim.ui.input({ prompt = "Database URL: " }, function(url)
      if not url or url == "" then return end
      vim.g.dbs = vim.g.dbs or {}
      vim.g.dbs[name] = { url = url }
      vim.cmd('DBUIToggle')
      print("Added connection: " .. name)
    end)
  end)
end, { desc = "Add database connection" })

-- Save connection globally
vim.keymap.set('n', '<leader>ds', function()
  vim.ui.input({ prompt = "Connection name: " }, function(name)
    if not name or name == "" then return end
    vim.ui.input({ prompt = "Database URL: " }, function(url)
      if not url or url == "" then return end
      _G.db_save_connection(name, url)
    end)
  end)
end, { desc = "Save database connection" })

-- Quick open SQLite database
vim.keymap.set('n', '<leader>dS', function()
  vim.ui.input({ prompt = "SQLite database path: " }, function(path)
    if not path or path == "" then return end
    path = vim.fn.expand(path)
    local url = "sqlite:" .. path
    vim.cmd('DB ' .. url)
  end)
end, { desc = "Open SQLite database" })

-- Laravel connection
vim.keymap.set('n', '<leader>dl', function()
  local dbs = vim.g.dbs or {}
  if dbs["laravel_mysql"] then
    vim.cmd('DB ' .. dbs["laravel_mysql"].url)
  elseif dbs["laravel_pgsql"] then
    vim.cmd('DB ' .. dbs["laravel_pgsql"].url)
  elseif dbs["laravel_sqlite"] then
    vim.cmd('DB ' .. dbs["laravel_sqlite"].url)
  else
    print("No Laravel database connection found in .env")
  end
end, { desc = "Connect to Laravel DB" })

-- List connections
vim.keymap.set('n', '<leader>dL', function()
  print("\nAvailable Database Connections:")
  if vim.g.dbs then
    for name, _ in pairs(vim.g.dbs) do
      print("- " .. name)
    end
  else
    print("No connections defined")
  end
end, { desc = "List database connections" })

-- Execute SQL against selected connection
vim.keymap.set('n', '<leader>de', function()
  local connections = {}
  if vim.g.dbs then
    for name, _ in pairs(vim.g.dbs) do
      table.insert(connections, name)
    end
    table.sort(connections)
  end

  if #connections == 0 then
    print("No database connections available")
    return
  end

  vim.ui.select(connections, {
    prompt = "Select database connection:",
  }, function(selected)
    if selected then
      vim.cmd('DB ' .. vim.g.dbs[selected].url)
    end
  end)
end, { desc = "Execute SQL against connection" })
