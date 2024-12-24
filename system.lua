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

function system:init()
  local directory_path = system:get_path() .. '/wo'

  if os.execute('ls ' .. directory_path) ~= 0 then
    print('Directory does not exist... Creating it.')
    os.execute('mkdir ' .. directory_path)
  end

  system.path = directory_path

  return directory_path
end

-- Git installation functions
function system:install_git_window()
  os.execute('curl -o git-install.exe https://github.com/git-for-windows/git/releases/latest/download/Git-x64.exe && git-install.exe /SILENT /DIR="C:\\Git" && setx PATH "%PATH%;C:\\Git\\bin" && git --version')
end

function system:install_git_debian()
  os.execute('sudo apt update && sudo apt install git -y && git --version')
end

function system:install_git_fedora()
  os.execute('sudo dnf install git -y && git --version')
end

function system:install_git_arch()
  os.execute('sudo pacman -S git --noconfirm && git --version')
end

function system:install_git_macos()
  os.execute('xcode-select --install && git --version')
end

-- GitHub CLI installation functions
function system:install_gh_window()
  os.execute('winget install --id GitHub.cli -e')
end

function system:install_gh_debian()
  os.execute('type -p curl >/dev/null || sudo apt install curl -y && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && sudo apt update && sudo apt install gh -y')
end

function system:install_gh_fedora()
  os.execute('sudo dnf install dnf-plugins-core -y && sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo && sudo dnf install gh -y')
end

function system:install_gh_arch()
  os.execute('sudo pacman -S github-cli --noconfirm')
end

function system:install_gh_macos()
  os.execute('brew install gh')
end

-- GitLab CLI (glab) installation functions
function system:install_glab_window()
  os.execute('winget install --id GitLab.gitlab-cli -e')
end

function system:install_glab_debian()
  os.execute('sudo apt update && sudo apt install -y curl && curl -s https://packages.gitlab.com/install/repositories/cli/gitlab-cli/script.deb.sh | sudo bash && sudo apt install -y gitlab-cli')
end

function system:install_glab_fedora()
  os.execute('sudo dnf install -y curl && curl -s https://packages.gitlab.com/install/repositories/cli/gitlab-cli/script.rpm.sh | sudo bash && sudo dnf install -y gitlab-cli')
end

function system:install_glab_arch()
  os.execute('sudo pacman -S glab --noconfirm')
end

function system:install_glab_macos()
  os.execute('brew install glab')
end

-- General installation function
function system:install_tool(tool, os)
  if tool == 'git' then
    if     os == 'windows' then system:install_git_window()
    elseif os == 'debian'  then system:install_git_debian()
    elseif os == 'fedora'  then system:install_git_fedora()
    elseif os == 'arch'    then system:install_git_arch()
    elseif os == 'macos'   then system:install_git_macos()
    end
  elseif tool == 'gh' then
    if     os == 'windows' then system:install_gh_window()
    elseif os == 'debian'  then system:install_gh_debian()
    elseif os == 'fedora'  then system:install_gh_fedora()
    elseif os == 'arch'    then system:install_gh_arch()
    elseif os == 'macos'   then system:install_gh_macos()
    end
  elseif tool == 'glab' then
    if     os == 'windows' then system:install_glab_window()
    elseif os == 'debian'  then system:install_glab_debian()
    elseif os == 'fedora'  then system:install_glab_fedora()
    elseif os == 'arch'    then system:install_glab_arch()
    elseif os == 'macos'   then system:install_glab_macos()
    end
  end
end

function system:check_up()
  local system_os = system:get_os()
  print('Detected operating system: ' .. system_os)

  --[[ Check and install Git
  if os.execute('git --version') ~= 0 then
    print('Git not found... Installing Git...')
    system:install_tool('git', system_os)
  end

  -- Check and install GitHub CLI
  if os.execute('gh --version') ~= 0 then
    print('GitHub CLI not found... Installing GitHub CLI...')
    system:install_tool('gh', system_os)
  end

  -- Check and install GitLab CLI (optional)
  if os.execute('glab --version') ~= 0 then
    print('GitLab CLI not found... Installing GitLab CLI...')
    system:install_tool('glab', system_os)
  end
  ]]
end

return system
