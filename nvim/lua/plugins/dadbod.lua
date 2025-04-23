-- plugins/dadbod.lua
-- Enhanced database integration for Neovim with improved SQLite support and keymappings
-- Last updated: April 2025

return {
  -- Main database plugin that provides SQL integration
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",             -- Core database functionality
      "kristijanhusak/vim-dadbod-completion", -- For SQL completion
      "jsborjesson/vim-uppercase-sql", -- Auto-uppercase SQL keywords
      "pbogut/vim-dadbod-ssh",        -- SSH support for remote databases
      "tami5/sqlite.lua",             -- Better SQLite support
    },
    config = function()
      -- Direct mapping function without requiring utils
      local map = vim.keymap.set
      
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      -- Database UI Configuration
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      
      -- Set up UI preferences
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. '/db_ui'
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = 'right'
      vim.g.db_ui_winwidth = 40
      
      -- Auto-connect to the last used database
      vim.g.db_ui_auto_execute_table_helpers = 1
      
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      -- Database Helpers and Query Templates
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      
      -- Enhanced helpers for different database types
      vim.g.db_ui_table_helpers = {
        sqlite = {
          List = 'SELECT name FROM sqlite_master WHERE type="table" ORDER BY name',
          Schema = [[SELECT sql FROM sqlite_master WHERE type="table" AND name="{table}"]],
          Indexes = [[SELECT name, sql FROM sqlite_master WHERE type="index" AND tbl_name="{table}"]],
          Foreign_Keys = [[PRAGMA foreign_key_list('{table}')]],
          Primary_Keys = [[PRAGMA table_info('{table}')]],
          Count = [[SELECT count(*) FROM "{table}"]],
          Sample = [[SELECT * FROM "{table}" LIMIT 10]],
        },
        mysql = {
          List = 'SHOW TABLES',
          Schema = 'DESCRIBE {table}',
          Indexes = 'SHOW INDEX FROM {table}',
          Foreign_Keys = [[SELECT 
            COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
          FROM 
            INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
          WHERE 
            TABLE_NAME = '{table}' 
            AND REFERENCED_TABLE_SCHEMA IS NOT NULL]],
          Primary_Keys = [[SHOW KEYS FROM {table} WHERE Key_name = 'PRIMARY']],
          Count = [[SELECT count(*) FROM `{table}`]],
          Sample = [[SELECT * FROM `{table}` LIMIT 10]],
        },
        postgresql = {
          List = [[SELECT table_name FROM information_schema.tables WHERE table_schema = current_schema() ORDER BY table_name]],
          Schema = [[SELECT 
            column_name, data_type, is_nullable, column_default
          FROM 
            information_schema.columns 
          WHERE 
            table_name = '{table}' 
          ORDER BY 
            ordinal_position]],
          Indexes = [[SELECT
            indexname, indexdef
          FROM
            pg_indexes
          WHERE
            tablename = '{table}']],
          Foreign_Keys = [[SELECT
            kcu.column_name,
            ccu.table_name AS foreign_table_name,
            ccu.column_name AS foreign_column_name
          FROM
            information_schema.table_constraints AS tc
            JOIN information_schema.key_column_usage AS kcu
              ON tc.constraint_name = kcu.constraint_name
            JOIN information_schema.constraint_column_usage AS ccu
              ON ccu.constraint_name = tc.constraint_name
          WHERE
            tc.constraint_type = 'FOREIGN KEY' AND tc.table_name = '{table}']],
          Primary_Keys = [[SELECT
            kcu.column_name
          FROM
            information_schema.table_constraints AS tc
            JOIN information_schema.key_column_usage AS kcu
              ON tc.constraint_name = kcu.constraint_name
          WHERE
            tc.constraint_type = 'PRIMARY KEY' AND tc.table_name = '{table}']],
          Count = [[SELECT count(*) FROM "{table}"]],
          Sample = [[SELECT * FROM "{table}" LIMIT 10]],
        }
      }
      
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      -- Connection Management
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      
      -- Function to parse Laravel-style .env file
      local function parse_laravel_env()
        local env_file = vim.fn.getcwd() .. "/.env"
        local connections = {}
        
        if vim.fn.filereadable(env_file) == 1 then
          local lines = vim.fn.readfile(env_file)
          
          -- Default values
          local db_connection = "mysql"
          local db_host = "127.0.0.1"
          local db_port = "3306"
          local db_database = ""
          local db_username = "root"
          local db_password = ""
          
          -- Read specific Laravel DB variables
          for _, line in ipairs(lines) do
            if line:match("^[^#]") and line:match("=") then
              local name, value = line:match("([^=]+)=(.*)")
              if name and value then
                -- Remove quotes if present
                value = value:gsub("^\"(.*)\"$", "%1")
                value = value:gsub("^'(.*)'$", "%1")
                name = name:gsub("%s+$", "")
                
                -- Extract DB connection details
                if name == "DB_CONNECTION" then db_connection = value
                elseif name == "DB_HOST" then db_host = value
                elseif name == "DB_PORT" then db_port = value
                elseif name == "DB_DATABASE" then db_database = value
                elseif name == "DB_USERNAME" then db_username = value
                elseif name == "DB_PASSWORD" then db_password = value
                elseif name == "DATABASE_URL" then
                  -- Also handle single URL format
                  connections["env_url"] = { url = value }
                end
              end
            end
          end
          
          -- Create connection string for Laravel DB
          if db_database ~= "" then
            local conn_string = ""
            
            -- Format the connection string based on the database type
            if db_connection == "mysql" then
              conn_string = string.format(
                "mysql://%s:%s@%s:%s/%s",
                db_username, db_password, db_host, db_port, db_database
              )
            elseif db_connection == "pgsql" then
              conn_string = string.format(
                "postgresql://%s:%s@%s:%s/%s",
                db_username, db_password, db_host, db_port, db_database
              )
            elseif db_connection == "sqlite" then
              -- For SQLite, handle relative and absolute paths
              if db_database:sub(1,1) ~= "/" then
                -- Relative path - assume from project root
                db_database = vim.fn.getcwd() .. "/" .. db_database
              end
              conn_string = "sqlite:" .. db_database
            end
            
            if conn_string ~= "" then
              connections["laravel_" .. db_connection] = { url = conn_string }
            end
          end
        end
        
        return connections
      end
      
      -- Load saved connections from JSON
      local function load_saved_connections()
        local connections = {}
        local save_file = vim.fn.stdpath("data") .. '/db_ui/saved_connections.json'
        
        if vim.fn.filereadable(save_file) == 1 then
          local content = vim.fn.readfile(save_file)
          local json_str = table.concat(content, "\n")
          
          -- Parse JSON (requires Neovim 0.7+ for vim.json)
          if vim.json then
            local ok, parsed = pcall(vim.json.decode, json_str)
            if ok then
              connections = parsed
            end
          else
            -- Fallback for older Neovim versions
            local has_cjson, cjson = pcall(require, 'cjson')
            if has_cjson then
              local ok, parsed = pcall(cjson.decode, json_str)
              if ok then
                connections = parsed
              end
            end
          end
        end
        
        return connections
      end
      
      -- Save a connection for later use
      _G.db_save_connection = function(name, url)
        local save_file = vim.fn.stdpath("data") .. '/db_ui/saved_connections.json'
        local connections = load_saved_connections()
        
        -- Add new connection
        connections[name] = { url = url }
        
        -- Ensure directory exists
        vim.fn.mkdir(vim.fn.stdpath("data") .. '/db_ui', 'p')
        
        -- Save to file
        local json_str
        if vim.json then
          json_str = vim.json.encode(connections)
        else
          -- Fallback for older Neovim versions
          local has_cjson, cjson = pcall(require, 'cjson')
          if has_cjson then
            json_str = cjson.encode(connections)
          else
            -- Very simple JSON encoding fallback
            json_str = "{"
            for k, v in pairs(connections) do
              json_str = json_str .. string.format('"%s":{"url":"%s"},', k, v.url)
            end
            json_str = json_str:sub(1, -2) .. "}" -- Remove last comma and close
          end
        end
        
        if json_str then
          vim.fn.writefile({json_str}, save_file)
          -- Refresh g.dbs
          vim.g.dbs = vim.tbl_extend("force", vim.g.dbs or {}, connections)
          print("Connection '" .. name .. "' saved")
        end
      end
      
      -- Initialize connections from both sources
      local env_connections = parse_laravel_env()
      local saved_connections = load_saved_connections()
      
      -- Combine connections from all sources
      vim.g.dbs = vim.tbl_extend("force", env_connections, saved_connections)
      
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      -- SQL Completion Setup
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      
      -- Set up completion for SQL files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {"sql", "mysql", "plsql"},
        callback = function()
          -- Set up cmp completion if available
          local has_cmp, cmp = pcall(require, 'cmp')
          if has_cmp then
            cmp.setup.buffer({
              sources = {
                { name = 'vim-dadbod-completion', priority = 1000 },
                { name = 'buffer', priority = 500 },
              }
            })
          end
          
          -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          -- SQL Keybindings
          -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          
          -- Buffer-specific keymaps for SQL files
          -- Execute current SQL query (under cursor)
          map('n', '<leader>de', ':DB<CR>', { buffer = true, desc = "Execute SQL (under cursor)" })
          
          -- Execute visual selection
          map('v', '<leader>de', ':DB<CR>', { buffer = true, desc = "Execute selected SQL" })
          
          -- Format SQL query
          map('n', '<leader>df', function()
            -- Use a formatter if available (e.g., sqlfluff, sql-formatter)
            local formatters = { "sqlfluff", "sql-formatter", "pgformat" }
            local formatter_found = false
            
            for _, formatter in ipairs(formatters) do
              if vim.fn.executable(formatter) == 1 then
                vim.cmd(':%!' .. formatter .. ' format -')
                formatter_found = true
                break
              end
            end
            
            if not formatter_found then
              -- Fallback to basic formatting using Vim's built-in formatting
              vim.cmd(':%s/,\\s*/,\\r  /g') -- Put each column on a new line
              vim.cmd(':%s/SELECT\\s*/SELECT\\r  /g') -- Format SELECT
              vim.cmd(':%s/FROM\\s*/\\rFROM\\r  /g') -- Format FROM
              vim.cmd(':%s/WHERE\\s*/\\rWHERE\\r  /g') -- Format WHERE
              vim.cmd(':%s/\\(AND\\|OR\\)\\s*/\\r  \\1 /g') -- Format AND/OR
              vim.cmd(':%s/\\(GROUP BY\\|ORDER BY\\|HAVING\\)\\s*/\\r\\1\\r  /g') -- Format GROUP BY, etc.
              vim.cmd(':%s/INNER JOIN\\s*/\\rINNER JOIN /g') -- Format INNER JOIN
              vim.cmd(':%s/\\(LEFT\\|RIGHT\\) JOIN\\s*/\\r\\1 JOIN /g') -- Format LEFT/RIGHT JOIN
            end
          end, { buffer = true, desc = "Format SQL query" })
          
          -- Save query to a file
          map('n', '<leader>ds', function()
            local query = vim.fn.expand("<cWORD>")
            local filename = vim.fn.input("Save query as: ", "", "file")
            if filename ~= "" then
              local dir = vim.fn.fnamemodify(filename, ":h")
              if dir ~= "." and vim.fn.isdirectory(dir) == 0 then
                vim.fn.mkdir(dir, "p")
              end
              vim.fn.writefile(vim.split(query, "\n"), filename)
              print("Query saved to " .. filename)
            end
          end, { buffer = true, desc = "Save query to file" })
          
          -- Show table schema
          map('n', '<leader>dt', function()
            local table_name = vim.fn.expand("<cWORD>"):gsub("`", ""):gsub('"', '')
            vim.cmd('DBUIFindBuffer')
            vim.fn.feedkeys("/" .. table_name .. "\\<CR>", "n")
            vim.fn.feedkeys("\\<CR>", "n") -- Open the table
          end, { buffer = true, desc = "Show table schema" })
          
          -- Uppercase SQL keywords (automatic or manual toggling)
          map('n', '<leader>du', ':call uppercase#sqlToggle()<CR>', { buffer = true, desc = "Toggle SQL uppercase" })
          
          -- Explain query plan
          map('n', '<leader>dx', function()
            -- Get the database type
            local db_url = vim.b.db or vim.g.db
            local db_type = db_url and db_url:match("^([^:]+):") or ""
            
            -- Get the current query (either selection or under cursor)
            local query
            local mode = vim.fn.mode()
            if mode == 'v' or mode == 'V' then
              -- Get visual selection
              local start_pos = vim.fn.getpos("'<")
              local end_pos = vim.fn.getpos("'>")
              local lines = vim.fn.getline(start_pos[2], end_pos[2])
              if #lines > 0 then
                lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
                lines[1] = string.sub(lines[1], start_pos[3])
              end
              query = table.concat(lines, "\n")
            else
              -- Get the query under cursor
              query = vim.fn.expand("<cWORD>")
            end
            
            -- Add the appropriate EXPLAIN prefix based on the database type
            local explain_query
            if db_type == "sqlite" then
              explain_query = "EXPLAIN QUERY PLAN " .. query
            elseif db_type == "postgresql" then
              explain_query = "EXPLAIN ANALYZE " .. query
            elseif db_type == "mysql" then
              explain_query = "EXPLAIN " .. query
            else
              explain_query = "EXPLAIN " .. query -- Default fallback
            end
            
            -- Execute the explain query
            vim.cmd('DB ' .. explain_query)
          end, { buffer = true, desc = "Explain query plan" })
        end
      })
      
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      -- Global Keybindings
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      
      -- Global keymaps for database operations
      -- Toggle the database UI sidebar
      map('n', '<leader>db', ':DBUIToggle<CR>', { desc = "Toggle DB UI sidebar" })
      
      -- Focus the database UI sidebar
      map('n', '<leader>df', ':DBUIFindBuffer<CR>', { desc = "Focus DB UI sidebar" })
      
      -- Add a new database connection
      map('n', '<leader>da', ':DBUIAddConnection<CR>', { desc = "Add new DB connection" })
      
      -- Show last query info
      map('n', '<leader>dl', ':DBUILastQueryInfo<CR>', { desc = "Show last query info" })
      
      -- Rename the current DB buffer
      map('n', '<leader>dr', ':DBUIRenameBuffer<CR>', { desc = "Rename DB buffer" })
      
      -- Save the current connection
      map('n', '<leader>ds', function()
        local name = vim.fn.input("Connection name: ")
        local url = vim.fn.input("Connection URL: ")
        if name ~= "" and url ~= "" then
          _G.db_save_connection(name, url)
        end
      end, { desc = "Save DB connection" })
      
      -- Connect to SQLite database
      map('n', '<leader>dq', function()
        local file = vim.fn.input("SQLite database path: ", "", "file")
        if file ~= "" then
          -- Make sure the file path is absolute
          if not vim.fn.fnamemodify(file, ":p") then
            file = vim.fn.fnamemodify(file, ":p")
          end
          
          -- Create a proper database URL with sqlite: prefix
          local db_url = "sqlite:" .. file
          
          -- Set the database connection
          vim.g.db = db_url
          
          -- Execute the command safely
          vim.schedule(function()
            vim.cmd("DB " .. db_url)
            print("Connected to SQLite database: " .. file)
          end)
        end
      end, { desc = "Connect to SQLite database" })
      
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      -- Auto-detect SQLite files
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      
      vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
        pattern = {"*.db", "*.sqlite", "*.sqlite3"},
        callback = function()
          -- Set filetype to sql
          vim.bo.filetype = "sql"
          
          -- Get the full path of the file
          local file_path = vim.fn.expand("%:p")
          
          -- Automatically open database connection
          if file_path and file_path ~= "" then
            local sqlite_url = "sqlite:" .. file_path
            vim.schedule(function()
              vim.cmd('DB ' .. sqlite_url)
            end)
          end
        end
      })
      
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      -- Helper Commands
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      
      -- Create user commands for database operations
      vim.api.nvim_create_user_command('DBSaveConnection', function(opts)
        local name = opts.args
        if name == "" then
          name = vim.fn.input("Connection name: ")
        end
        local url = vim.b.db or vim.g.db
        if url and name ~= "" then
          _G.db_save_connection(name, url)
        else
          print("No active connection or invalid name")
        end
      end, { nargs = '?', desc = "Save current DB connection" })
      
      vim.api.nvim_create_user_command('DBConnectLaravel', function()
        local connections = parse_laravel_env()
        if vim.tbl_isempty(connections) then
          print("No Laravel connections found in .env file")
          return
        end
        
        local conn_names = {}
        for name, _ in pairs(connections) do
          table.insert(conn_names, name)
        end
        
        if #conn_names == 1 then
          -- If only one connection, use it directly
          local conn = connections[conn_names[1]]
          vim.cmd('DB ' .. conn.url)
        else
          -- Let user choose from multiple connections
          vim.ui.select(conn_names, {
            prompt = "Select Laravel connection:",
          }, function(choice)
            if choice then
              local conn = connections[choice]
              vim.cmd('DB ' .. conn.url)
            end
          end)
        end
      end, { desc = "Connect to Laravel database" })
      
      -- Custom command for executing common SQL queries
      vim.api.nvim_create_user_command('DBQuery', function(opts)
        local query_type = opts.args
        local current_table = vim.fn.expand("<cWORD>"):gsub("`", ""):gsub('"', '')
        
        local queries = {
          count = "SELECT COUNT(*) FROM " .. current_table,
          schema = "PRAGMA table_info(" .. current_table .. ")",
          sample = "SELECT * FROM " .. current_table .. " LIMIT 10",
          indexes = "PRAGMA index_list(" .. current_table .. ")",
          tables = "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
        }
        
        local query = queries[query_type]
        if query then
          vim.cmd('DB ' .. query)
        else
          print("Unknown query type: " .. query_type)
        end
      end, { nargs = 1, complete = function()
        return { "count", "schema", "sample", "indexes", "tables" }
      end, desc = "Execute common SQL queries" })
    end,
    -- Load on SQL files or database commands
    event = {
      "FileType sql,mysql,plsql",
      "BufReadPre *.db,*.sqlite,*.sqlite3",
    },
    cmd = {
      "DB",
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIRenameBuffer",
      "DBUIFindBuffer",
      "DBUILastQueryInfo",
      "DBQuery",
      "DBSaveConnection",
      "DBConnectLaravel",
    },
    -- Add which-key setup for better discoverable commands
    keys = {
      { "<leader>db", desc = "Database (toggle UI)" },
      { "<leader>da", desc = "Database (add connection)" },
      { "<leader>dq", desc = "Database (SQLite quick connect)" },
    },
  },
}
