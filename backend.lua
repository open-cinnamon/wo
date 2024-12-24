local system = require('system')
local math = require('math')
local backend = {}
backend.__index = backend

function backend:install(name)
  local result_name = name .. '-search_result-' .. tostring(math.random(0, 90))
  local file = io.open(name, "a")
  local servers = {}

  os.execute(string.format('git search repos %s > %s', name, result_name))

  if not file then
    print('Unable to open file: ' .. name)
  else
    for line in file:lines() do
      print('Server found: ' .. line)
      table.insert(servers, line)
    end
  end

end

backend:install('wys')

return backend -- RTS medieval