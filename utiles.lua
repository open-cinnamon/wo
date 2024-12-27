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

-- Todo
-- Add more utiles ...

return utiles
