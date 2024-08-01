-- Load external script for additional functionalities
loadstring(game:HttpGet("https://raw.githubusercontent.com/Noriko2000/Gpo/Lua/Good%20gpofree.lua"))()

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Local player
local localPlayer = Players.LocalPlayer

-- Create Remote Events and Functions (done only once)
local espEvent = Instance.new("RemoteEvent", ReplicatedStorage)
espEvent.Name = "ESPEvent"

local aimbotEvent = Instance.new("RemoteEvent", ReplicatedStorage)
aimbotEvent.Name = "AimbotEvent"

local autoFarmEvent = Instance.new("RemoteEvent", ReplicatedStorage)
autoFarmEvent.Name = "AutoFarmEvent"

local checkStatusFunction = Instance.new("RemoteFunction", ReplicatedStorage)
checkStatusFunction.Name = "CheckStatusFunction"

-- Setup UI using Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Lib/main/source.lua"))()
local Window = Library.CreateLib("My Script Hub", "Ocean")

-- ESP Tab
local ESP = Window:NewTab("ESP")
local ESPSection = ESP:NewSection("ESP Settings")
ESPSection:NewToggle("Enable ESP", "Toggle ESP", function(state)
    espEvent:FireServer(state)
end)

-- Aimbot Tab
local Aimbot = Window:NewTab("Aimbot")
local AimbotSection = Aimbot:NewSection("Aimbot Settings")
AimbotSection:NewToggle("Enable Aimbot", "Toggle Aimbot", function(state)
    aimbotEvent:FireServer(state)
end)

-- Auto-Farm Tab
local AutoFarm = Window:NewTab("Auto-Farm")
local AutoFarmSection = AutoFarm:NewSection("Auto-Farm Settings")
AutoFarmSection:NewToggle("Enable Auto-Farm", "Toggle Auto-Farm", function(state)
    autoFarmEvent:FireServer(state)
end)

-- ESP Function
local function drawESP()
    local status = checkStatusFunction:InvokeServer()
    if not status.espEnabled then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local position = character.HumanoidRootPart.Position
                local box = Drawing.new("Square")
                box.Position = Vector2.new(position.X, position.Y)
                box.Size = Vector2.new(50, 50)
                box.Color = Color3.new(1, 0, 0)
                box.Visible = true
            end
        end
    end
end

-- Aimbot Function
local function aimbot()
    local status = checkStatusFunction:InvokeServer()
    if not status.aimbotEnabled then return end

    local mouse = localPlayer:GetMouse()
    local closestPlayer
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = (character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    if closestPlayer then
        mouse.Hit = closestPlayer.Character.HumanoidRootPart.CFrame
    end
end

-- Auto-Farm Function
local function autoFarm()
    local status = checkStatusFunction:InvokeServer()
    if not status.autoFarmEnabled then return end

    local target = game:GetService("Workspace"):FindFirstChild("FarmTarget")
    if target then
        localPlayer.Character:MoveTo(target.Position)
    end
end

-- Error Checking Function
local function checkForErrors()
    if not game then
        warn("Game service not found")
    end

    if not game:GetService("Players") then
        warn("Players service not found")
    end

    if not localPlayer then
        warn("Local player not found")
    end
end

-- Check for errors
checkForErrors()

-- Run Functions Every Frame
RunService.RenderStepped:Connect(function()
    drawESP()
    aimbot()
    autoFarm()
end)
