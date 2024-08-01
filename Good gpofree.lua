-- Required services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- Create UI
local screenGui = Instance.new("ScreenGui", localPlayer.PlayerGui)
screenGui.Name = "MainUI"

-- Create Player UI Frame
local playerFrame = Instance.new("Frame", screenGui)
playerFrame.Name = "PlayerFrame"
playerFrame.Size = UDim2.new(0, 200, 0, 200)
playerFrame.Position = UDim2.new(0, 10, 0, 10)
playerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Create Bot UI Frame
local botFrame = Instance.new("Frame", screenGui)
botFrame.Name = "BotFrame"
botFrame.Size = UDim2.new(0, 200, 0, 200)
botFrame.Position = UDim2.new(0, 220, 0, 10)
botFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Create Toggle Auto-Farm Button
local toggleButton = Instance.new("TextButton", playerFrame)
toggleButton.Name = "ToggleAutoFarmButton"
toggleButton.Size = UDim2.new(0, 150, 0, 40)
toggleButton.Position = UDim2.new(0, 25, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "เปิด/ปิด ออโต้ฟาร์ม"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 14

-- Create Lock Target Button
local lockTargetButton = Instance.new("TextButton", playerFrame)
lockTargetButton.Name = "LockTargetButton"
lockTargetButton.Size = UDim2.new(0, 150, 0, 40)
lockTargetButton.Position = UDim2.new(0, 25, 0, 60)
lockTargetButton.BackgroundColor3 = Color3.fromRGB(0, 0, 200)
lockTargetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockTargetButton.Text = "ล็อกเป้าหมาย"
lockTargetButton.Font = Enum.Font.SourceSans
lockTargetButton.TextSize = 14

-- Create Status Label
local statusLabel = Instance.new("TextLabel", playerFrame)
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0, 180, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 110)
statusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Text = "สถานะ: พร้อมใช้งาน"
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Create Nearest Target Label
local nearestTargetLabel = Instance.new("TextLabel", botFrame)
nearestTargetLabel.Name = "NearestTargetLabel"
nearestTargetLabel.Size = UDim2.new(0, 180, 0, 30)
nearestTargetLabel.Position = UDim2.new(0, 10, 0, 10)
nearestTargetLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
nearestTargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nearestTargetLabel.Text = "เป้าหมายใกล้เคียง: ไม่มี"
nearestTargetLabel.Font = Enum.Font.SourceSans
nearestTargetLabel.TextSize = 14
nearestTargetLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Variables
local shootingReady, reloading, autoFarm, lockTarget, debounce = false, false, false, false, false

-- Functions
local function findNearestPlayer()
    local closest, minDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
            if dist < minDist then minDist, closest = dist, p end
        end
    end
    return closest
end

local function findBotsAround()
    local bots = {}
    for _, mob in pairs(workspace.Mobs.KingSandpod:GetChildren()) do
        if mob.Name == "Fishman Karate User" and mob:FindFirstChild("HumanoidRootPart") then
            if (mob.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude <= 50 then
                table.insert(bots, mob)
            end
        end
    end
    return bots
end

local function updateNearestTargetLabel()
    local bots = findBotsAround()
    nearestTargetLabel.Text = "เป้าหมายใกล้เคียง: " .. (#bots > 0 and "มี " .. #bots .. " ตัว" or "ไม่มี")
end

local function startAiming()
    if not reloading then
        shootingReady = true
        statusLabel.Text = "สถานะ: ตั้งท่าพร้อมยิง..."
    end
end

local function shoot(target)
    if shootingReady and not reloading then
        shootingReady = false
        local tool = localPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            tool.Handle.CFrame = CFrame.new(tool.Handle.Position, target.Position)
            tool.Handle.Fire:Play()
        end
        reload()
    else
        statusLabel.Text = "สถานะ: ไม่พบเป้าหมายที่จะยิง."
    end
end

local function reload()
    reloading = true
    statusLabel.Text = "สถานะ: กำลังรีโหลด..."
    wait(2)
    reloading = false
    statusLabel.Text = "สถานะ: รีโหลดเสร็จสิ้น."
end

local function TP(position)
    localPlayer.Character.HumanoidRootPart.CFrame = position
end

local function EP(toolName)
    local tool = localPlayer.Backpack:FindFirstChild(toolName)
    if tool then
        localPlayer.Character.Humanoid:EquipTool(tool)
    end
end

-- UI Button Connections
toggleButton.MouseButton1Click:Connect(function()
    if debounce then return end
    debounce = true
    autoFarm = not autoFarm
    if autoFarm then
        statusLabel.Text = "สถานะ: ออโต้ฟาร์มเปิดใช้งาน"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        spawn(autoFarmLoop)
    else
        statusLabel.Text = "สถานะ: ออโต้ฟาร์มปิดใช้งาน"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
    wait(0.5)
    debounce = false
end)

lockTargetButton.MouseButton1Click:Connect(function()
    if debounce then return end
    debounce = true
    lockTarget = not lockTarget
    statusLabel.Text = lockTarget and "สถานะ: ล็อกเป้าหมายเปิดใช้งาน" or "สถานะ: ล็อกเป้าหมายปิดใช้งาน"
    lockTargetButton.BackgroundColor3 = lockTarget and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    wait(0.5)
    debounce = false
end)

local function autoFarmLoop()
    while autoFarm do
        wait(1)
        pcall(function()
            local bots = findBotsAround()
            if #bots > 0 then
                local nearest = findNearestPlayer()
                if nearest then
                    shoot(nearest.HumanoidRootPart.Position)
                end
            end
        end)
        updateNearestTargetLabel()
    end
end
