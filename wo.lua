local system = require('system')

local wo = {}

--[[
  args:
  help : Show help
  install <PACKAGE> : Will install package
  update <PACKAGE?> : Will update package, else, all packages
]]

function wo:handle_argv(path)
  for a in ipairs(arg) do
    if a == 'install' then
      -- todo
    end
  end
end

function wo:main()
  -- First of all, we need to check git.
  system:check_up()
  local path = system:init()
  print('Home: ' .. path)
  wo:handle_argv(path)
end

wo:main()

return wo