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
  local selected = 0
  local found = 0
  for server in ipairs(list) do
    found = found + 1
    local mismatches = utiles:compare(server, name)

    if mismatches / name.len() > 0.5 then
      selected = selected + 1
    end
  end
end

function gh:call(name, tmp)
  gh:execute(name, tmp)

end

return gh