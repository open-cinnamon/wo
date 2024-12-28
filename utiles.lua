local utiles = {}
utiles.__index = utiles

function utiles:compare(name, real)
  name = tostring(name)
  real = tostring(real)

  local max = math.min(string.len(name), string.len(real))
  local i = 1
  local failures = 0

  while i <= max do
    if string.sub(name, i, i) ~= string.sub(real, i, i) then
      failures = failures + 1
    end
    i = i + 1
  end

  failures = failures + math.max(string.len(name), string.len(real)) - math.min(string.len(name), string.len(real))

  return failures
end

function utiles:compare_letters(name, real)
  return utiles:compare(tostring(name):lower(), tostring(real):lower())
end


-- wys-prog/open-cinnamon-host : open-cinnamon-host : 1
--                               ^^^^^^^^^^^^^^^^^^
--                                the name !!! 
function utiles:get_ghserver_name(line)
  -- Ensure the input is a string
  line = tostring(line)

  -- Match the part between "--" and the first " : "
  local name = string.match(line, "/([^:]+) :")

  return name
end


-- Todo
-- Add more utiles ...

return utiles
