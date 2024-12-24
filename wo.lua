local installer = require('installer')
local system = require('system')

local wo = {}

function wo:handle_argv()

end

local function get_a_vector_2(a, b)
  return {a, b}
end

function wo:main()
  -- First of all, we need to check git.
  installer:check_up()
  print('Home: ' .. system:init())
  wo:handle_argv()
end

wo:main()

return wo