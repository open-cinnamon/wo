local utiles = require('utiles')

local gh = {}
gh.__index = gh

function gh:get_servers(name, tmp)
  local cmd = string.format(
    'gh api "search/repositories?q=%s" --paginate --jq \'.items[] | .full_name + " : " + .name + " : " + (.stargazers_count|tostring)\' > %s',
    name, tmp)

  print(cmd)

  os.execute(cmd)
end

function gh:install(server, output)
  local cmd = string.format('gh repos clone %s %s', server, output)
  print(cmd)
  os.execute(cmd)
end

function gh:get_list(tmp)
  local servers = {}

  local file = io.open(tmp, "r")

  if not file then
    print('Unable to open file: ' .. tmp)
  else
    local line = file:read()
    local i = 0

    while line ~= nil do
      i = i + 1
      table.insert(servers, line)
      line = file:read()
    end
  end

  if file then file:close() end

  return servers
end

function gh:parse_list(name, list)
  local selected = {}
  local ignored = 0

  for _, server in ipairs(list) do
    local server_name = utiles:get_ghserver_name(server)
    local mismatches = utiles:compare(server_name, name)

    if mismatches / #name < 0.7 then -- Use `#name` for string length
      table.insert(selected, server)
    else
      ignored = ignored + 1
    end
  end

  print('Ignored: ' .. tostring(ignored))

  return selected
end


function gh:call(name, tmp)
  gh:get_servers(name, tmp)
  local servers = gh:parse_list(name, gh:get_list(tmp))

  for index, value in ipairs(servers) do
    print(string.format('[%s]: %s', tostring(index), value))
  end

  io.write('Choose a server: ')
  local server = tonumber(io.read())
end

return gh

--[[ 
  todo
    - Threading installation
  * - Files (HOME/wo/servers)
  * - Cache 
]]