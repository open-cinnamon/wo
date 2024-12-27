local packs = {}

-- Function to parse the file and populate the table
function packs:open(path)
  local file = io.open(path, "r") -- Open the file in read mode
  if not file then
    print("Error: No such file: " .. path)
    return
  end

  local version = 'unknown'
  local servers = {}

  -- Read the file line by line
  for line in file:lines() do
    -- Match and extract the version
    local version_match = line:match("version%s+'(.-)'")
    if version_match then
      version = version_match
    end

    -- Match and extract server URLs inside "servers { }"
    local server_match = line:match("https://[%w%p]+")
    if server_match then
      table.insert(servers, server_match)
    end
  end

  file:close() -- Close the file
  return {version, servers}
end

return packs -- ... I was returning « packages » instead of « packs » ....
