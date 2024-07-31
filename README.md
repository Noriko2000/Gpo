--[[ 
    This script has been licensed using Luarmor
    Luarmor v3.8b, Lua whitelisting system
    https://luarmor.net/
]]

local a="This file is licensed with Luarmor. You must use the actual loadstring to execute this script. Do not run this file directly. Always use the loadstring."
local b="ae7b9d07f101b2053c3d5ec6a4a869e8"
if lrm_load_script then 
    lrm_load_script(b)
    while wait(1) do end
end

local c="https://api.luarmor.net/files/v3/l/"..b..".lua"
is_from_loader={Mode="fastload"}
local d=0.03

l_fastload_enabled=function(e)
    if e=="flush" then
        wait(d)
        d=d+2
        local f, g
        local h, i = pcall(function()
            g = game:HttpGet(c)
            pcall(writefile, b.."-cache.lua", "-- "..a.."\n\n if not is_from_loader then warn('Use the loadstring, do not run this directly') return end;\n "..g)
            wait(0.1)
            f = loadstring(g)
        end)
        if not h or not f then
            pcall(writefile, "lrm-err-loader-log-httpresp.txt", tostring(g))
            warn("Error while executing loader. Err:"..tostring(i).." See lrm-err-loader-log-httpresp.txt in your workspace.")
            return
        end
        f(is_from_loader)
    end
    if e=="rl" then
        pcall(writefile, b.."-cache.lua", "recache required")
        wait(0.2)
        pcall(delfile, b.."-cache.lua")
    end
end

local j
local k, l = pcall(function()
    j = readfile(b.."-cache.lua")
    if (not j) or (#j < 5) then
        j = nil
        return
    end
    j = loadstring(j)
end)
if not k or not j then
    l_fastload_enabled("flush")
    return
end
j(is_from_loader)

-- Your UI script starts here

-- Create ScreenGui and Frame for UI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyScreenGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
frame.Parent = screenGui

local startButton = Instance.new("TextButton")
startButton.Name = "StartButton"
startButton.Size = UDim2.new(0, 250, 0, 50)
startButton.Position = UDim2.new(0, 25, 0, 30)
startButton.Text = "Start AutoFarm"
startButton.BackgroundColor3 = Color3.new(0.3, 0.7, 0.3)
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.TextScaled = true
startButton.Parent = frame

local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Size = UDim2.new(0, 250, 0, 50)
stopButton.Position = UDim2.new(0, 25, 0, 100)
stopButton.Text = "Stop AutoFarm"
stopButton.BackgroundColor3 = Color3.new(0.7, 0.3, 0.3)
stopButton.TextColor3 = Color3.new(1, 1, 1)
stopButton.TextScaled = true
stopButton.Parent = frame

-- Function to teleport player to a specified position
local function Teleport(position)
    if player and player.Character and player.Character.PrimaryPart then
        player.Character:SetPrimaryPartCFrame(CFrame.new(position))
    end
end

-- Function to equip an item with a specified name
local function EquipItem(itemName)
    local item = player.Backpack:FindFirstChild(itemName) or player.Character:FindFirstChild(itemName)
    if item and item:IsA("Tool") then
        player.Character.Humanoid:EquipTool(item)
    end
end

-- Function to start the auto-farm process
local function StartAutoFarm()
    _G.AutoFarm = true
    while _G.AutoFarm do
        local target = game.Workspace:FindFirstChild("TargetMob")
        if target and (target:IsA("Model") or target:IsA("Part")) then
            Teleport(target.Position)
            EquipItem("Sword") -- Adjust item name as needed
            task.wait(1) -- Wait 1 second
        else
            Teleport(Vector3.new(0, 0, 0)) -- Backup position
        end
        task.wait(1)
    end
end

-- Function to stop the auto-farm process
local function StopAutoFarm()
    _G.AutoFarm = false
end

-- Connect buttons to functions
startButton.MouseButton1Click:Connect(StartAutoFarm)
stopButton.MouseButton1Click:Connect(StopAutoFarm)
