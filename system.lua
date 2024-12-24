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

function system:install_repo(url, path)
  os.execute(string.format('git %s %s', url, path))
end

function system:install_git_window()
  os.execute('curl -o git-install.exe https://github.com/git-for-windows/git/releases/latest/download/Git-x64.exe\ngit-install.exe /SILENT /DIR="C:\\Git"\nsetx PATH "%PATH%;C:\\Git\bin"\ngit --version')
end

function system:install_git_debian()
  os.execute('sudo apt update\nsudo apt install git -y\ngit --version')
end

function system:install_git_fedora()
  os.execute('sudo dnf install git -y')
end

function system:install_git_arch()
  os.execute('sudo pacman -S git')
end

function system:install_git_macos()
  os.execute('xcode-select --install\ngit --version')
end

function system:install_git(os)
  if     os == 'windows' then system:install_git_window()
  elseif os == 'debian'  then system:install_git_debian()
  elseif os == 'fedora'  then system:install_git_fedora()
  elseif os == 'arch'    then system:install_git_arch()
  elseif os == 'macos'   then system:install_git_macos()
  end
end

function system:check_up()
  local system_os = system:get_os()
  print('Detected operating system : ' .. system_os)
  local code = os.execute('git --version')

  if code ~= 0 then
    print('Git not found... Installing...')
    system:install_git(system_os)
  end
end

return system