local system = require('system')
local backend = {} -- For the front end ... 
backend.__index = backend

--[[
  Idea is to have files which contains some servers. 
  These servers had links to servers into them.
  The « update » argument will ping all of these servers, to update them.
]]

function backend:update(name)

end

function backend:install(name)

end

return backend -- RTS medieval
