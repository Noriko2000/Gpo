-- Create UI with Start and Stop buttons

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlGui"
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
startButton.Text = "Start Script"
startButton.BackgroundColor3 = Color3.new(0.3, 0.7, 0.3)
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.TextScaled = true
startButton.Parent = frame

local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Size = UDim2.new(0, 250, 0, 50)
stopButton.Position = UDim2.new(0, 25, 0, 100)
stopButton.Text = "Stop Script"
stopButton.BackgroundColor3 = Color3.new(0.7, 0.3, 0.3)
stopButton.TextColor3 = Color3.new(1, 1, 1)
stopButton.TextScaled = true
stopButton.Parent = frame

-- Variable to control script state
local enabled = false

-- Function to toggle script state
local function toggleScript(state)
    enabled = state
    if enabled then
        print("Script Enabled")
        StartScript() -- Call the main function when enabling
    else
        print("Script Disabled")
        StopScript() -- Call the stop function when disabling
    end
end

-- Main function that runs when script is enabled
local function StartScript()
    while enabled do
        -- Main script logic (e.g., shooting and reloading)
        local rifle = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rifle")
        if rifle and rifle:FindFirstChild("Shoot") and rifle:FindFirstChild("Reload") then
            for i, v in pairs(game:GetService("Workspace").Mobs.KingSandpod:GetChildren()) do
                if v.Name == "Fishman Karate User" then
                    local args = {
                        [1] = v.HumanoidRootPart.Position
                    }
                    -- Use Rifle to shoot
                    rifle.Shoot:Fire(unpack(args))

                    -- Wait for the shooting to finish
                    wait(1) -- Adjust wait time as needed

                    -- Reload
                    rifle.Reload:Fire() -- Trigger reload
                end
            end
        else
            warn("Rifle or its functions (Shoot/Reload) not found.")
        end
        wait(1) -- Wait before the next iteration
    end
end

-- Function to stop the script
local function StopScript()
    -- The while loop in StartScript will stop when enabled is false
end

-- Set up button event handlers
startButton.MouseButton1Click:Connect(function()
    toggleScript(true)  -- Enable script
end)

stopButton.MouseButton1Click:Connect(function()
    toggleScript(false) -- Disable script
end)
