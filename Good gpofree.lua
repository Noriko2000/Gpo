-- Required services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainUI"
screenGui.Parent = localPlayer.PlayerGui

-- Create Player UI Frame
local playerFrame = Instance.new("Frame")
playerFrame.Name = "PlayerFrame"
playerFrame.Size = UDim2.new(0, 200, 0, 200)
playerFrame.Position = UDim2.new(0, 10, 0, 10)
playerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerFrame.Parent = screenGui

-- Create Bot UI Frame
local botFrame = Instance.new("Frame")
botFrame.Name = "BotFrame"
botFrame.Size = UDim2.new(0, 200, 0, 200)
botFrame.Position = UDim2.new(0, 220, 0, 10)
botFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
botFrame.Parent = screenGui

-- Create Toggle Auto-Farm Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleAutoFarmButton"
toggleButton.Size = UDim2.new(0, 150, 0, 40)
toggleButton.Position = UDim2.new(0, 25, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "เปิด/ปิด ออโต้ฟาร์ม"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 14
toggleButton.Parent = playerFrame

-- Create Lock Target Button
local lockTargetButton = Instance.new("TextButton")
lockTargetButton.Name = "LockTargetButton"
lockTargetButton.Size = UDim2.new(0, 150, 0, 40)
lockTargetButton.Position = UDim2.new(0, 25, 0, 60)
lockTargetButton.BackgroundColor3 = Color3.fromRGB(0, 0, 200)
lockTargetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockTargetButton.Text = "ล็อกเป้าหมาย"
lockTargetButton.Font = Enum.Font.SourceSans
lockTargetButton.TextSize = 14
lockTargetButton.Parent = playerFrame

-- Create Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0, 180, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 110)
statusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Text = "สถานะ: พร้อมใช้งาน"
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = playerFrame

-- Create Nearest Target Label
local nearestTargetLabel = Instance.new("TextLabel")
nearestTargetLabel.Name = "NearestTargetLabel"
nearestTargetLabel.Size = UDim2.new(0, 180, 0, 30)
nearestTargetLabel.Position = UDim2.new(0, 10, 0, 10)
nearestTargetLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
nearestTargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nearestTargetLabel.Text = "เป้าหมายใกล้เคียง: ไม่มี"
nearestTargetLabel.Font = Enum.Font.SourceSans
nearestTargetLabel.TextSize = 14
nearestTargetLabel.TextXAlignment = Enum.TextXAlignment.Left
nearestTargetLabel.Parent = botFrame

-- Variables
local shootingReady = false
local reloading = false
local autoFarm = false
local lockTarget = false
local debounce = false

-- Function to find the nearest player
local function findNearestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
            
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    
    return closestPlayer
end

-- Function to find bots around the player
local function findBotsAround()
    local foundBots = {}
    local searchRadius = 50 -- Adjust this radius as needed

    for _, mob in pairs(workspace.Mobs.KingSandpod:GetChildren()) do
        if mob.Name == "Fishman Karate User" and mob:FindFirstChild("HumanoidRootPart") then
            local distance = (mob.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance <= searchRadius then
                table.insert(foundBots, mob)
            end
        end
    end

    return foundBots
end

-- Function to update the UI with the nearest bot information
local function updateNearestTargetLabel()
    local bots = findBotsAround()
    if #bots > 0 then
        nearestTargetLabel.Text = "เป้าหมายใกล้เคียง: มี " .. #bots .. " ตัว"
    else
        nearestTargetLabel.Text = "เป้าหมายใกล้เคียง: ไม่มี"
    end
end

-- Function to start aiming
local function startAiming()
    if reloading then
        return
    end
    shootingReady = true
    statusLabel.Text = "สถานะ: ตั้งท่าพร้อมยิง..."
end

-- Function to shoot
local function shoot(target)
    if not shootingReady or reloading then
        return
    end
    shootingReady = false

    if target then
        statusLabel.Text = "สถานะ: ยิงไปที่เป้าหมาย"
        -- Add shooting logic here, for example:
        local tool = localPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            local handle = tool.Handle
            handle.CFrame = CFrame.new(handle.Position, target.Position)
            handle.Fire:Play() -- This line assumes the tool has a Fire method or sound, adjust as needed
        end
        reload()
    else
        statusLabel.Text = "สถานะ: ไม่พบเป้าหมายที่จะยิง."
    end
end

-- Function to reload
local function reload()
    reloading = true
    statusLabel.Text = "สถานะ: กำลังรีโหลด..."
    wait(2) -- Simulate reload time
    reloading = false
    statusLabel.Text = "สถานะ: รีโหลดเสร็จสิ้น."
end

-- Function to teleport to a given position
local function TP(position)
    localPlayer.Character.HumanoidRootPart.CFrame = position
end

-- Function to equip a tool
local function EP(toolName)
    local tool = localPlayer.Backpack:FindFirstChild(toolName)
    if tool then
        localPlayer.Character.Humanoid:EquipTool(tool)
    end
end

-- Toggle auto-farming
toggleButton.MouseButton1Click:Connect(function()
    if debounce then return end
    debounce = true

    autoFarm = not autoFarm
    if autoFarm then
        statusLabel.Text = "สถานะ: ออโต้ฟาร์มเปิดใช้งาน"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        spawn(autoFarmLoop) -- Start the auto-farming loop
    else
        statusLabel.Text = "สถานะ: ออโต้ฟาร์มปิดใช้งาน"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end

    wait(0.5) -- Debounce delay
    debounce = false
end)

-- Lock target
lockTargetButton.MouseButton1Click:Connect(function()
    if debounce then return end
    debounce = true

    lockTarget = not lockTarget
    if lockTarget then
        statusLabel.Text = "สถานะ: ล็อกเป้าหมายเปิดใช้งาน"
        lockTargetButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        statusLabel.Text = "สถานะ: ล็อกเป้าหมายปิดใช้งาน"
        lockTargetButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end

    wait(0.5) -- Debounce delay
    debounce = false
end)

-- Auto-Farming Loop
local function autoFarmLoop()
    while autoFarm do
        wait(1) -- Add a delay to avoid high CPU usage
        pcall(function()
            -- Step 1: Find bots around the player
            local foundMob = false
