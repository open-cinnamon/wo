local utiles = require('utiles')

local gh = {}
gh.__index = gh

function gh:install(name, tmp)
  local command = string.format(
    'gh api "search/repositories?q=%s" --paginate --jq \'.items[] | .full_name + " : " + .name + " : " + (.stargazers_count|tostring)\' > %s',
    name, tmp
  )

  print(command)

  os.execute(command)
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
  gh:execute(name, tmp)
  local first = gh:get_list(tmp)
  local second = gh:parse_list(name, first)

  

end

return gh