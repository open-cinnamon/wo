local system = require('system')
local backend = {}
backend.__index = backend

function backend:compare(name, real)
  name = tostring(name)
  real = tostring(real)

  local max = math.min(string.len(name), string.len(real))
  local i = 1
  local failures = 0

  while i <= max do
    if string.sub(name, i, i) ~= string.sub(real, i, i) then
      failures = failures + 1
    end
    i = i + 1
  end

  return failures
end


function backend:install_gh(name)
  local result_name = os.tmpname()
  print('File: ' .. result_name .. '\nSearching for ' .. name .. '...')
  local servers = {}

  local command = string.format(
    'gh api "search/repositories?q=%s" --paginate --jq \'.items[] | .full_name + " : " + .name + " : " + (.stargazers_count|tostring)\' > %s',
    name, result_name
  )

  print(command)

  os.execute(command)

  local file = io.open(result_name, "r")
  if not file then
    print('Unable to open file: ' .. result_name)
  else
    local line = file:read()
    local i = 0

    while line ~= nil do
      print(tostring(i) .. ': ' .. line)
      line = file:read()
      i = i + 1
      table.insert(servers, line)
    end

    io.write('Choose a server: ')
    local server = tonumber(io.read())
  end
end

backend:install_gh('open-cinnamon')

return backend -- RTS medieval
