-- Create UI with Start, Stop, Toggle, Fold buttons, Status, Target Name, Search Box, and Position Display

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0.5, -150, 0.5, -175)
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

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 250, 0, 50)
toggleButton.Position = UDim2.new(0, 25, 0, 170)
toggleButton.Text = "Toggle UI"
toggleButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.Parent = frame

local foldButton = Instance.new("TextButton")
foldButton.Name = "FoldButton"
foldButton.Size = UDim2.new(0, 50, 0, 50)
foldButton.Position = UDim2.new(0, 250, 0, 0)
foldButton.Text = "+"
foldButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
foldButton.TextColor3 = Color3.new(1, 1, 1)
foldButton.TextScaled = true
foldButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(0, 250, 0, 50)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.new(0.7, 0.3, 0.3)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextScaled = true
closeButton.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0, 250, 0, 50)
statusLabel.Position = UDim2.new(0, 25, 0, 230)
statusLabel.Text = "Status: Idle"
statusLabel.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextScaled = true
statusLabel.Parent = frame

local targetNameLabel = Instance.new("TextLabel")
targetNameLabel.Name = "TargetNameLabel"
targetNameLabel.Size = UDim2.new(0, 250, 0, 50)
targetNameLabel.Position = UDim2.new(0, 25, 0, 280)
targetNameLabel.Text = "Target: None"
targetNameLabel.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
targetNameLabel.TextColor3 = Color3.new(1, 1, 1)
targetNameLabel.TextScaled = true
targetNameLabel.Parent = frame

local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(0, 250, 0, 50)
searchBox.Position = UDim2.new(0, 25, 0, 350)
searchBox.Text = ""
searchBox.PlaceholderText = "Enter bot name..."
searchBox.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.TextScaled = true
searchBox.Parent = frame

local positionLabel = Instance.new("TextLabel")
positionLabel.Name = "PositionLabel"
positionLabel.Size = UDim2.new(0, 250, 0, 50)
positionLabel.Position = UDim2.new(0, 25, 0, 400)
positionLabel.Text = "Position: N/A"
positionLabel.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
positionLabel.TextColor3 = Color3.new(1, 1, 1)
positionLabel.TextScaled = true
positionLabel.Parent = frame

-- Variable to control script state
local enabled = false
local uiFolded = false

-- Function to toggle script state
local function toggleScript(state)
    enabled = state
    if enabled then
        statusLabel.Text = "Status: Script Running"
        StartScript() -- Call the main function when enabling
    else
        statusLabel.Text = "Status: Script Stopped"
        StopScript() -- Call the stop function when disabling
    end
end

-- Main function that runs when script is enabled
local function StartScript()
    while enabled do
        -- Main script logic (e.g., shooting and reloading)
        local rifle = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rifle")
        local searchName = searchBox.Text
        if rifle and rifle:FindFirstChild("Shoot") and rifle:FindFirstChild("Reload") then
            local targetFound = false
            for i, v in pairs(game:GetService("Workspace").Mobs.KingSandpod:GetChildren()) do
                if v.Name == searchName and v:FindFirstChild("HumanoidRootPart") then
                    targetFound = true
                    targetNameLabel.Text = "Target: " .. v.Name
                    positionLabel.Text = "Position: " .. tostring(v.HumanoidRootPart.Position)
                    local args = {
                        [1] = v.HumanoidRootPart.Position
                    }
                    -- Use Rifle to shoot
                    rifle.Shoot:Fire(unpack(args))

                    -- Wait for the shooting to finish
                    wait(1) -- Adjust wait time as needed

                    -- Reload
                    rifle.Reload:Fire() -- Trigger reload

                    -- Wait for reloading to complete (5 seconds)
                    wait(5)
                end
            end
            if not targetFound then
                targetNameLabel.Text = "Target: None"
                positionLabel.Text = "Position: N/A"
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

-- Function to toggle the UI visibility
local function toggleUI()
    frame.Visible = not frame.Visible
end

-- Function to fold and unfold the UI
local function toggleFold()
    if uiFolded then
        frame.Size = UDim2.new(0, 300, 0, 350)  -- Expand the UI to original size
        foldButton.Text = "+"
    else
        frame.Size
