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
local ReflectionMetadata = game:GetService('HttpService'):JSONDecode(game:HttpGet('https://mollersuite.github.io/surveyor/reflection.json', true))[1].Classes
local classes = game:GetService('HttpService'):JSONDecode(game:HttpGet('https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/API-Dump.json', true)).Classes

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

local gui = game:GetObjects('rbxassetid://6887517279')[1]
gui.Name = game:GetService('HttpService'):GenerateGUID()
gui.Parent = game:GetService('CoreGui')

local entry = gui.Entry
entry.Parent = nil
entry.icon.Image = icons

for _,v in pairs(game:GetChildren()) do
  local entry = entry:Clone()
  entry.name.Text = v.Name
  entry.icon.ImageRectOffset = Vector2.new(offset(v.ClassName), 0) * 16
  entry.Parent = gui.Main
end
