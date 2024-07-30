_G.AutoFarm = true
_G.Item = "Rifle"

local function TP(position)
local player = game.Players.LocalPlayer
if player and player.Character then
player.Character:SetPrimaryPartCFrame(position)
end
end

local function itemequip(itemName)
local player = game.Players.LocalPlayer
local item = player.Character and player.Character:FindFirstChild(itemName)
if item then
item:Activate()
end
end

-- Create a circle to lock target
local function createCircle()
local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local circle = Instance.new("Frame", screenGui)

circle.Size = UDim2.new(0, 100, 0, 100)
circle.Position = UDim2.new(0.5, -50, 0.5, -50)
circle.BackgroundColor3 = Color3.new(1, 0, 0)
circle.BackgroundTransparency = 0.5
circle.BorderSizePixel = 0
circle.ClipsDescendants = true

local innerCircle = Instance.new("Frame", circle)
innerCircle.Size = UDim2.new(1, -10, 1, -10)
innerCircle.Position = UDim2.new(0, 5, 0, 5)
innerCircle.BackgroundColor3 = Color3.new(1, 0, 0)
innerCircle.BackgroundTransparency = 0.5
innerCircle.BorderSizePixel = 0
innerCircle.ZIndex = 2
innerCircle.ClipsDescendants = true
end

createCircle()

spawn(function()
while _G.AutoFarm do
local player = game.Players.LocalPlayer
local rifle = player.Character and player.Character:FindFirstChild("Rifle")
local shootEvent = rifle and rifle:FindFirstChild("Shoot")
local reloadEvent = rifle and rifle:FindFirstChild("Reload")

local mobs = game.Workspace.Mobs:FindFirstChild("Fishman Karate")
if not mobs then
TP(CFrame.new(7376.996, -459.5, 1014.981))
else
for _, mob in pairs(mobs:GetChildren()) do
if mob.Name == "Fishman Karate" then
repeat
local targetPosition = mob.HumanoidRootPart.Position
itemequip(_G.Item)
if shootEvent then
shootEvent:FireServer(targetPosition)
-- Immediately trigger reload after shooting
if reloadEvent then reloadEvent:FireServer() end
end
-- Move character to face the mob, without changing its position
local char = player.Character
local humanoidRootPart = char and char:FindFirstChild("HumanoidRootPart")
if humanoidRootPart then
humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, targetPosition)
end
task.wait(0.1) -- Small delay to avoid spamming
until not _G.AutoFarm or mob.Humanoid.Health < 1
end
end
end
task.wait(0.1)
end
end)

spawn(function()
game:GetService("RunService").Heartbeat:Connect(function()
if _G.AutoFarm then
local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
if humanoid then
setfflag("HumanoidParallelRemoveNoPhysics", "False")
setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate?", "False")
humanoid:ChangeState(11)
end
