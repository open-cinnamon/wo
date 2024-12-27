local fs = require('filesystem')
local sys = require('sys')

local system = {
  path = '',
}

system.__index = system

function system:get_path()
  local os_name = sys.get_os()
  local home = os.getenv("HOME")

  if os_name and os_name:find("Windows") then
    return os.getenv("APPDATA")
  elseif home then
    if io.popen("uname -s"):read("*l") == "Darwin" then
      return home .. "/Library/Application Support"
    else
      return home --.. "/.config"
    end
  else
    return nil
  end
end

function system:create_dir(path)
  os.execute('mkdir ' .. path)
end

function system:init()
  local directory_path = system:get_path() .. '/wo'

  if os.execute('ls ' .. directory_path) ~= 0 then
    print('Directory does not exist... Creating it.')
    os.execute('mkdir ' .. directory_path)
  end

  system.path = directory_path

  return directory_path
end

function system:check_up()
  local system_os = system:get_os()
  print('Detected operating system: ' .. system_os)
end

print(sys:get_os())

return system

--[[
  todo  
  Recode this....
]]