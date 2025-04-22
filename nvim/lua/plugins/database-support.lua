-- plugins/dadbod.lua
-- Database integration setup for Neovim
-- Created By Antropic - Claude.ai

return {
  -- Main database plugin that provides SQL integration
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod", -- Core database functionality
      "kristijanhusak/vim-dadbod-completion", -- For completion integration
    },
    config = function()
      -- Database UI configuration
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. '/db_ui'
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = 'right'
      vim.g.db_ui_winwidth = 40
      
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
            -- Try to use lua-cjson if available
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
      
      -- Set up completion for SQL files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {"sql", "mysql", "plsql"},
        callback = function()
          local has_cmp, cmp = pcall(require, 'cmp')
          if has_cmp then
            cmp.setup.buffer({
              sources = {
                { name = 'vim-dadbod-completion' },
                { name = 'buffer' },
              }
            })
          end
        end
      })
    end,
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIRenameBuffer",
      "DBUIFindBuffer",
      "DBUILastQueryInfo",
    },
  },
  
  -- SQLite specific plugin for better SQLite support
  {
    "kkharji/sqlite.lua",
    lazy = true,
  },
}
