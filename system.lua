local system = {}
system.__index = system

function system:get_os()
  -- Identifier l'OS
  local os_name = os.getenv("OS") -- Fonctionne pour Windows
  if os_name and os_name:find("Windows") then
    return 'windows'
  else
    -- Identifier Linux ou MacOS
    local uname = io.popen("uname -s"):read("*l") -- Exécute "uname -s" pour obtenir le nom du système
    if uname == "Linux" then
      -- Vérifier la distribution Linux
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

function system:init()
  local directory_path = system:get_path() .. '/wo'

  if os.execute('ls ' .. directory_path) ~= 0 then
    print('directory does not exits...')
    os.execute('mkdir ' .. directory_path)
  end

  return directory_path
end

return system