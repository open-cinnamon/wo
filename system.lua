local system = {
  path = ''
}

system.__index = system

function system:get_os()
  -- Identify the OS
  local os_name = os.getenv("OS") -- Works for Windows
  if os_name and os_name:find("Windows") then
    return 'windows'
  else
    -- Identify Linux or macOS
    local uname = io.popen("uname -s"):read("*l") -- Execute "uname -s" to get the system name
    if uname == "Linux" then
      -- Check Linux distribution
      local distro = io.popen("cat /etc/os-release | grep '^ID='"):read("*l")
      if distro:find("debian") or distro:find("ubuntu") or distro:find("mint") then
        return 'debian'
      elseif distro:find("fedora") or distro:find("rhel") then
        return 'fedora'
      elseif distro:find("arch") then
        return 'arch'
      else
        return 'debian'
      end
    elseif uname == "Darwin" then
      return 'macos'
    else
      return 'debian/ubuntu'
    end
  end
end

function system:get_path()
  local os_name = os.getenv("OS")
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

return system
