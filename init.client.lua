if not getcustomasset then
  game:GetService('StarterGui'):SetCore("SendNotification",  {
    Title = "Error";
    Text = "Your exploit does not support getcustomasset. Try using Fluxus or Script-Ware.";
    Duration = 5;
  })
end


local function loadCustomAsset(url,filename,reusable)
  local data = game:HttpGet(url)
  writefile(filename,data)

  return getcustomasset(filename,reusable)
end

local icons = loadCustomAsset("https://mollersuite.github.io/surveyor/ClassImages.png","vanillaicons.png",true)
local api = require(game:GetObjects('rbxassetid://4711528349')[1])
local ReflectionMetadata = api.ReflectionMetadata.Classes
local classes = api.APIDump.Classes

local function get (data, class)
  for _,v in pairs(data) do
    if v.Name == class then
      return v
    end
  end
end

local function offset (class)
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
