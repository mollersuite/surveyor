local api = require(script.MainModule)--require(game:GetObjects('rbxassetid://4711528349')[1])
local ReflectionMetadata = api.ReflectionMetadata.Classes
local classes = api.APIDump.Classes

local function get (data, class)
  for _,v in pairs(data) do
    if v.Name == class then
      return v
    end
  end
end

local function offset(class)
  local reflection = get(ReflectionMetadata,class)
  if reflection.ExplorerImageIndex then
    return reflection.ExplorerImageIndex
  end
  while not reflection.ExplorerImageIndex do
    local dump = get(classes, class)
    if dump.Superclass == '<<<ROOT>>>' then
      return 0
    end
    reflection = get(ReflectionMetadata,dump.Superclass)
  end
  return 0
end

print(offset('TextLabel'))
