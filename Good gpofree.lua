-- Required services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainUI"
screenGui.Parent = localPlayer.PlayerGui

-- Create Toggle Auto-Farm Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleAutoFarmButton"
toggleButton.Size = UDim2.new(0, 150, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "เปิด/ปิด ออโต้ฟาร์ม"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 14
toggleButton.Parent = screenGui

-- Create Lock Target Button
local lockTargetButton = Instance.new("TextButton")
lockTargetButton.Name = "LockTargetButton"
lockTargetButton.Size = UDim2.new(0, 150, 0, 40)
lockTargetButton.Position = UDim2.new(0, 10, 0, 60)
lockTargetButton.BackgroundColor3 = Color3.fromRGB(0, 0, 200)
lockTargetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockTargetButton.Text = "ล็อกเป้าหมาย"
lockTargetButton.Font = Enum.Font.SourceSans
lockTargetButton.TextSize = 14
lockTargetButton.Parent = screenGui

-- Create Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0, 310, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 110)
statusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Text = "สถานะ: พร้อมใช้งาน"
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = screenGui

-- Create Nearest Target Label
local nearestTargetLabel = Instance.new("TextLabel")
nearestTargetLabel.Name = "NearestTargetLabel"
nearestTargetLabel.Size = UDim2.new(0, 310, 0, 30)
nearestTargetLabel.Position = UDim2.new(0, 10, 0, 150)
nearestTargetLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
nearestTargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nearestTargetLabel.Text = "เป้าหมายใกล้เคียง: ไม่มี"
nearestTargetLabel.Font = Enum.Font.SourceSans
nearestTargetLabel.TextSize = 14
nearestTargetLabel.TextXAlignment = Enum.TextXAlignment.Left
nearestTargetLabel.Parent = screenGui

-- Variables
local shootingReady = false
local reloading = false
local autoFarm = false
local lockTarget = false

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
local function shoot()
    if not shootingReady or reloading then
        return
    end
    shootingReady = false

    local nearestPlayer = findNearestPlayer()
    if nearestPlayer then
        statusLabel.Text = "สถานะ: ยิงไปที่เป้าหมาย: " .. nearestPlayer.Name
        -- Add shooting logic here
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
    autoFarm = not autoFarm
    if autoFarm then
        statusLabel.Text = "สถานะ: ออโต้ฟาร์มเปิดใช้งาน"
    else
        statusLabel.Text = "สถานะ: ออโต้ฟาร์มปิดใช้งาน"
    end
end)

-- Lock target
lockTargetButton.MouseButton1Click:Connect(function()
    lockTarget = not lockTarget
    if lockTarget then
        statusLabel.Text = "สถานะ: ล็อกเป้าหมายเปิดใช้งาน"
    else
        statusLabel.Text = "สถานะ: ล็อกเป้าหมายปิดใช้งาน"
    end
end)

-- Auto-Farming Loop
local function autoFarmLoop()
    while autoFarm do
        wait()
        pcall(function()
            -- Step 1: Find bots around the player
            local foundMob = false
            for _, mob in pairs(workspace.Mobs.KingSandpod:GetChildren()) do
                if mob.Name == "Fishman Karate User" and mob:FindFirstChild("HumanoidRootPart") then
                    foundMob = true
                    -- Step 2: Update UI with nearest bot information
                    updateNearestTargetLabel()
                    -- Step 3: Equip tool and teleport to the bot's location
                    EP("Rifle")
                    TP(mob.HumanoidRootPart.CFrame) -- Teleport to the mob's position
                    -- Step 4: Shoot the bot
                    shoot()
                    break -- Stop searching once the target is found
                end
            end

            if not foundMob then
                statusLabel.Text = "สถานะ: ไม่พบบอทที่ต้องการ. รอการสร้างใหม่..."
                wait(5) -- Wait before trying again
            end
        end)
    end
end

-- Start the auto-farming loop
spawn(autoFarmLoop)

-- Handle input from both mouse and touch
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not shootingReady then
            startAiming()
        else
            shoot()
        end
    end
end)
