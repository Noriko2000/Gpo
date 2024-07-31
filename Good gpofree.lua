-- Create UI
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(1, 0, 0, 50)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = "Toggle UI"

local startButton = Instance.new("TextButton", frame)
startButton.Size = UDim2.new(1, 0, 0, 50)
startButton.Position = UDim2.new(0, 0, 0, 50)
startButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
startButton.Text = "Start Script"

local isScriptRunning = false

-- Toggle UI visibility
toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Start/Stop script
startButton.MouseButton1Click:Connect(function()
    isScriptRunning = not isScriptRunning
    startButton.Text = isScriptRunning and "Stop Script" or "Start Script"

    if isScriptRunning then
        while isScriptRunning do
            for _, v in pairs(game:GetService("Workspace").Mobs.KingSandpod:GetChildren()) do
                if v.Name == "Fishman Karate" then
                    local args = {[1] = v.HumanoidRootPart.CFrame}
                    local rifle = player.Character:FindFirstChild("Rifle")
                    if rifle then
                        rifle.Event:FireServer(unpack(args))
                        if rifle:FindFirstChild("Reload") then
                            rifle.Reload:FireServer()
                        end
                    end
                end
            end
            wait(1) -- Adjust as needed
        end
    end
end)
