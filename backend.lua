local system = require('system')
local backend = {}
backend.__index = backend

function backend:install_gh(name)
  local result_name = os.tmpname()
  print('File: ' .. result_name)
  local servers = {}

  local command = string.format(
    'gh api "search/repositories?q=%s" --paginate --jq \'.items[] | .full_name + " : " + (.stargazers_count|tostring) + " : " + .description\' > %s',
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
    end

    --io.write('Choose a server: ')
    --local server = io.read("n")
  end
end

backend:install_gh('xang')

return backend -- RTS medieval
