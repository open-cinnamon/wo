local utiles = require('utiles')

local gh = {}
gh.__index = gh

function gh:get_servers(name, tmp)
  os.execute(string.format(
    'gh api "search/repositories?q=%s" --paginate --jq \'.items[] | .full_name + " : " + .name + " : " + (.stargazers_count|tostring)\' > %s',
    name, tmp))
end

function gh:install(server, output)
  os.execute(string.format('gh repos clone %s %s', server, output))
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
    end
  end
end

function gh:parse_list(name, list)
  local selected = {}

  for server in ipairs(list) do
    local mismatches = utiles:compare(server, name)

    if mismatches / name.len() < 0.5 then
      table.insert(selected, server)
    end
  end

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
