if not getcustomasset and not getsynasset then
  game:GetService('StarterGui'):SetCore("SendNotification",  {
    Title = "Error";
    Text = "Your exploit does not support getcustomasset/getsynasset. Try using Script-Ware, Fluxus, or Synapse X.";
    Duration = 5;
  })
end


local function loadCustomAsset(url,filename,reusable)
  local data = game:HttpGet(url)
  writefile(filename,data)

  return (getcustomasset or getsynasset)(filename,reusable)
end

local icons = loadCustomAsset("https://mollersuite.github.io/surveyor/ClassImages.png","vanillaicons.png",true)
local ReflectionMetadata = game:GetService('HttpService'):JSONDecode(game:HttpGet('https://mollersuite.github.io/surveyor/reflection.json', true))
local classes = game:GetService('HttpService'):JSONDecode(game:HttpGet('https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/API-Dump.json', true)).Classes

local function get (data, class)
  for _,v in pairs(data) do
    if v.Name == class then
      return v
    end
  end
end

local function offset (class)
  local reflection = ReflectionMetadata[class]
  if reflection and reflection.ExplorerImageIndex then
    return reflection.ExplorerImageIndex
  end
  while not (reflection or {}).ExplorerImageIndex do
    local dump = get(classes, class)
    if not dump then
    	return 0
    end
    wait()
    if dump.Superclass == 'Instance' then
    	return (ReflectionMetadata[dump.Superclass] or {}).ExplorerImageIndex or 0
    end
    if dump.Superclass == '<<<ROOT>>>' then
      return 0
    end
    reflection = ReflectionMetadata[dump.Superclass]
  end
  return 0
end

local gui = game:GetObjects('rbxassetid://6887517279')[1]
gui.Name = game:GetService('HttpService'):GenerateGUID()
gui.Parent = game:GetService('CoreGui')
gui.Main.ClipsDescendants = true

local entry = gui.Entry
entry.Parent = nil
entry.icon.Image = icons

local function addto (v, parent)
	local entry = entry:Clone()
	entry.name.Text = v.Name
	entry.Visible = true
	entry.icon.ImageRectOffset = Vector2.new(offset(v.ClassName), 0) * 16
	entry.Parent = parent
	v:GetPropertyChangedSignal('Name'):Connect(function ()
		entry.name.Text = v.Name
	end)
end

for _,v in pairs(game:GetChildren()) do
  coroutine.wrap(function ()
	addto(v,gui.Main)
  end)()
end
