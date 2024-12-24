local system = require('system')

local installer = {}
installer.__index = installer

function installer:install_repo(url, path)
  os.execute(string.format('git %s %s', url, path))
end

function installer:install_git_window()
  os.execute('curl -o git-install.exe https://github.com/git-for-windows/git/releases/latest/download/Git-x64.exe\ngit-install.exe /SILENT /DIR="C:\\Git"\nsetx PATH "%PATH%;C:\\Git\bin"\ngit --version')
end

function installer:install_git_debian()
  os.execute('sudo apt update\nsudo apt install git -y\ngit --version')
end

function installer:install_git_fedora()
  os.execute('sudo dnf install git -y')
end

function installer:install_git_arch()
  os.execute('sudo pacman -S git')
end

function installer:install_git_macos()
  os.execute('xcode-select --install\ngit --version')
end

function installer:install_git(os)
  if     os == 'windows' then installer:install_git_window()
  elseif os == 'debian'  then installer:install_git_debian()
  elseif os == 'fedora'  then installer:install_git_fedora()
  elseif os == 'arch'    then installer:install_git_arch()
  elseif os == 'macos'   then installer:install_git_macos()
  end
end

function installer:check_up()
  local system_os = system:get_os()
  print('Detected operating system : ' .. system_os)
  local code = os.execute('git --version')

  if code ~= 0 then
    print('Git not found... Installing...')
    installer:install_git(system_os)
  end
end

return installer