local system = require('system')

local wo = {}

--[[
  args:
  help : Show help
  install <PACKAGE> : Will install package
  update <PACKAGE?> : Will update package, else, all packages
  
]]

function wo:handle_argv()
  
end

function wo:main()
  -- First of all, we need to check git.
  system:check_up()
  print('Home: ' .. system:init())
  wo:handle_argv()
end

wo:main()

return wo