-- config/database-keymaps.lua
-- Enhanced Database keymaps with improved SQLite support
-- Last updated: April 2025

  -- Basic UI mappings with descriptive help
  vim.keymap.set('n', '<leader>db', ':DBUIToggle<CR>', vim.tbl_extend('force', opts, { desc = "Toggle Database UI panel" }))
  vim.keymap.set('n', '<leader>df', ':DBUIFindBuffer<CR>', vim.tbl_extend('force', opts, { desc = "Find database buffer" }))
  vim.keymap.set('n', '<leader>dr', ':DBUIRenameBuffer<CR>', vim.tbl_extend('force', opts, { desc = "Rename database buffer" }))
  vim.keymap.set('n', '<leader>dq', ':DBUILastQueryInfo<CR>', vim.tbl_extend('force', opts, { desc = "Show last query info" }))

  -- Add database connection with improved input handling
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

  -- Enhanced SQLite handling - Quick open SQLite database
  vim.keymap.set('n', '<leader>dS', function()
    -- Get file path using vim.ui.input with path completion
    vim.ui.input({ 
      prompt = "SQLite database path: ",
      completion = "file",
      default = vim.fn.getcwd() .. "/",
    }, function(path)
      if not path or path == "" then return end
      
      -- Expand path (handle ~ and other shell expansions)
      path = vim.fn.expand(path)
      
      -- Check if file exists
      if vim.fn.filereadable(path) == 0 and not path:match("%.sqlite$") and not path:match("%.db$") and not path:match("%.sqlite3$") then
        -- Ask if user wants to append extension
        vim.ui.select({
          "Use path as-is",
          "Add .sqlite extension",
          "Add .db extension",
          "Cancel"
        }, {
          prompt = "File doesn't exist or doesn't have SQLite extension:",
        }, function(selected)
          if selected == "Add .sqlite extension" then
            path = path .. ".sqlite"
          elseif selected == "Add .db extension" then
            path = path .. ".db"
          elseif selected == "Cancel" then
            return
          end
          
          local url = "sqlite:" .. path
          vim.cmd('DB ' .. url)
          
          -- Save as connection for easy access later
          vim.g.dbs = vim.g.dbs or {}
          local db_name = vim.fn.fnamemodify(path, ":t:r") -- Get filename without extension
          vim.g.dbs["sqlite_" .. db_name] = { url = url }
          print("Connected to SQLite database: " .. path)
        end)
      else
        -- File exists or has correct extension, open directly
        local url = "sqlite:" .. path
        vim.cmd('DB ' .. url)
        
        -- Save as connection for easy access later
        vim.g.dbs = vim.g.dbs or {}
        local db_name = vim.fn.fnamemodify(path, ":t:r") -- Get filename without extension
        vim.g.dbs["sqlite_" .. db_name] = { url = url }
        print("Connected to SQLite database: " .. path)
      end
    end)
  end, { desc = "Open SQLite database" })

  -- Laravel connection with improved detection
  vim.keymap.set('n', '<leader>dl', function()
    local dbs = vim.g.dbs or {}
    
    -- Try to find Laravel connection in order of preference
    local connection_types = {"laravel_mysql", "laravel_pgsql", "laravel_sqlite"}
    local found = false
    
    for _, conn_type in ipairs(connection_types) do
      if dbs[conn_type] then
        vim.cmd('DB ' .. dbs[conn_type].url)
        print("Connected to Laravel " .. conn_type:gsub("laravel_", "") .. " database")
        found = true
        break
      end
    end
    
    if not found then
      -- If no connection found, look for .env file and try to connect
      local env_file = vim.fn.getcwd() .. "/.env"
      if vim.fn.filereadable(env_file) == 1 then
        print("Scanning Laravel .env file for database connection...")
        -- Trigger a config reload to parse the .env file
        vim.cmd("lua require('plugins.dadbod')")
        -- Try connections again after reload
        vim.defer_fn(function()
          vim.cmd('<leader>dl')
        end, 200)
      else
        print("No Laravel database connection found in .env")
      end
    end
  end, { desc = "Connect to Laravel DB" })

  -- List connections with improved formatting
  vim.keymap.set('n', '<leader>dL', function()
    local dbs = vim.g.dbs or {}
    local count = 0
    
    print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("Available Database Connections:")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    -- Sort connections by name
    local names = {}
    for name, _ in pairs(dbs) do
      table.insert(names, name)
    end
    table.sort(names)
    
    -- Group connections by type
    local grouped = {
      sqlite = {},
      mysql = {},
      postgres = {},
      other = {}
    }
    
    for _, name in ipairs(names) do
      local url = dbs[name].url
      count = count + 1
      
      -- Categorize by DB type
      if url:match("^sqlite:") then
        table.insert(grouped.sqlite, {name = name, url = url})
      elseif url:match("^mysql:") then
        table.insert(grouped.mysql, {name = name, url = url})
      elseif url:match("^postgresql:") then
        table.insert(grouped.postgres, {name = name, url = url})
      else
        table.insert(grouped.other, {name = name, url = url})
      end
    end
    
    -- Print by groups
    local function print_group(title, items)
      if #items > 0 then
        print("\n" .. title .. ":")
        for _, item in ipairs(items) do
          -- Format URL to hide passwords
          local safe_url = item.url:gsub(":[^:@/]+@", ":***@")
          print("  • " .. item.name .. " (" .. safe_url .. ")")
        end
      end
    end
    
    print_group("SQLite Databases", grouped.sqlite)
    print_group("MySQL Databases", grouped.mysql)
    print_group("PostgreSQL Databases", grouped.postgres)
    print_group("Other Connections", grouped.other)
    
    if count == 0 then
      print("  No connections defined")
      print("\nTip: Use <leader>da to add a connection")
    end
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
  end, { desc = "List database connections" })

  -- Execute SQL against selected connection with improved UI
  vim.keymap.set('n', '<leader>de', function()
    local connections = {}
    local dbs = vim.g.dbs or {}
    
    if dbs then
      for name, config in pairs(dbs) do
        table.insert(connections, {name = name, url = config.url})
      end
      table.sort(connections, function(a, b) return a.name < b.name end)
    end

    if #connections == 0 then
      print("No database connections available")
      return
    end

    -- Format connection names with type information
    local display_items = {}
    for _, conn in ipairs(connections) do
      local db_type = "unknown"
      if conn.url:match("^sqlite:") then
        db_type = "SQLite"
      elseif conn.url:match("^mysql:") then
        db_type = "MySQL"
      elseif conn.url:match("^postgresql:") then
        db_type = "PostgreSQL"
      end
      
      -- Get filename for SQLite DBs
      local display = conn.name
      if db_type == "SQLite" then
        local path = conn.url:gsub("^sqlite:", "")
        local filename = vim.fn.fnamemodify(path, ":t")
        display = conn.name .. " (" .. filename .. ")"
      end
      
      table.insert(display_items, string.format("[%s] %s", db_type, display))
    end

    vim.ui.select(display_items, {
      prompt = "Select database connection:",
    }, function(selected, idx)
      if selected and idx and connections[idx] then
        vim.cmd('DB ' .. connections[idx].url)
      end
    end)
  end, { desc = "Execute SQL against connection" })

  -- New mapping: Query SQLite tables
  vim.keymap.set('n', '<leader>dt', function()
    local file_path = vim.fn.expand("%:p")
    if file_path:match("%.db$") or file_path:match("%.sqlite$") or file_path:match("%.sqlite3$") then
      -- This is a SQLite file, query its tables
      local url = "sqlite:" .. file_path
      vim.cmd('DB ' .. url .. ' .tables')
    else
      -- Check if we're in a DB buffer
      if vim.bo.filetype == "sql" then
        vim.cmd('DBUIFindBuffer')
      else
        print("Not a SQLite file or SQL buffer")
      end
    end
  end, { desc = "Show tables in SQLite database" })

  -- New mapping: Export SQL results to buffer
  vim.keymap.set('n', '<leader>do', function()
    -- Select a connection first
    local connections = {}
    local dbs = vim.g.dbs or {}
    
    if dbs then
      for name, config in pairs(dbs) do
        table.insert(connections, {name = name, url = config.url})
      end
      table.sort(connections, function(a, b) return a.name < b.name end)
    end

    if #connections == 0 then
      print("No database connections available")
      return
    end

    -- Format connection names with type information
    local display_items = {}
    for _, conn in ipairs(connections) do
      local db_type = "unknown"
      if conn.url:match("^sqlite:") then
        db_type = "SQLite"
      elseif conn.url:match("^mysql:") then
        db_type = "MySQL"
      elseif conn.url:match("^postgresql:") then
        db_type = "PostgreSQL"
      end
      
      table.insert(display_items, string.format("[%s] %s", db_type, conn.name))
    end

    vim.ui.select(display_items, {
      prompt = "Select database connection:",
    }, function(selected, idx)
      if selected and idx and connections[idx] then
        -- Now get SQL query
        vim.ui.input({
          prompt = "SQL query: ",
          default = "SELECT * FROM ",
        }, function(query)
          if query and query ~= "" then
            -- Create new buffer for results
            vim.cmd('enew')
            vim.bo.buftype = 'nofile'
            vim.bo.filetype = 'sql'
            vim.api.nvim_buf_set_name(0, 'SQL Results - ' .. connections[idx].name)
            
            -- Execute query and put results in buffer
            vim.cmd('put =db_execute("' .. connections[idx].url .. '", "' .. query:gsub('"', '\\"') .. '")')
            vim.cmd('normal! ggdd') -- Remove first empty line
            print("Query executed on " .. connections[idx].name)
          end
        end)
      end
    end)
  end, { desc = "Run SQL query and output to buffer" })

