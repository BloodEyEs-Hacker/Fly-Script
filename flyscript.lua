-- Fly Script with GUI
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Fly variables
local flying = false
local flySpeed = 50
local bodyVelocity
local flightConnection

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGUI"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderColor3 = Color3.fromRGB(0, 100, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Parent = ScreenGui

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
Title.BackgroundTransparency = 0.5
Title.Text = "FLIGHT CONTROL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Title Corner
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: DISABLED"
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Speed Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, -20, 0, 25)
SpeedLabel.Position = UDim2.new(0, 10, 0, 75)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
SpeedLabel.TextSize = 14
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MainFrame

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.9, 0, 0, 35)
ToggleButton.Position = UDim2.new(0.05, 0, 0, 110)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleButton.Text = "ENABLE FLIGHT"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = MainFrame

-- Toggle Button Corner
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

-- Speed Controls Frame
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 40)
SpeedFrame.Position = UDim2.new(0.05, 0, 0, 155)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpeedFrame.BackgroundTransparency = 0.5
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Parent = MainFrame

-- Speed Frame Corner
local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = SpeedFrame

-- Decrease Speed Button
local DecreaseButton = Instance.new("TextButton")
DecreaseButton.Name = "DecreaseButton"
DecreaseButton.Size = UDim2.new(0.3, 0, 0.8, 0)
DecreaseButton.Position = UDim2.new(0.05, 0, 0.1, 0)
DecreaseButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
DecreaseButton.Text = "-"
DecreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseButton.TextSize = 18
DecreaseButton.Font = Enum.Font.GothamBold
DecreaseButton.Parent = SpeedFrame

-- Increase Speed Button
local IncreaseButton = Instance.new("TextButton")
IncreaseButton.Name = "IncreaseButton"
IncreaseButton.Size = UDim2.new(0.3, 0, 0.8, 0)
IncreaseButton.Position = UDim2.new(0.65, 0, 0.1, 0)
IncreaseButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
IncreaseButton.Text = "+"
IncreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseButton.TextSize = 18
IncreaseButton.Font = Enum.Font.GothamBold
IncreaseButton.Parent = SpeedFrame

-- Speed Display
local SpeedDisplay = Instance.new("TextLabel")
SpeedDisplay.Name = "SpeedDisplay"
SpeedDisplay.Size = UDim2.new(0.3, 0, 0.8, 0)
SpeedDisplay.Position = UDim2.new(0.35, 0, 0.1, 0)
SpeedDisplay.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SpeedDisplay.Text = "50"
SpeedDisplay.TextColor3 = Color3.fromRGB(0, 200, 255)
SpeedDisplay.TextSize = 16
SpeedDisplay.Font = Enum.Font.GothamBold
SpeedDisplay.Parent = SpeedFrame

-- Button corners
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 4)
ButtonCorner.Parent = DecreaseButton
ButtonCorner:Clone().Parent = IncreaseButton

local DisplayCorner = Instance.new("UICorner")
DisplayCorner.CornerRadius = UDim.new(0, 4)
DisplayCorner.Parent = SpeedDisplay

-- Fly functions
local function createBodyVelocity()
    if bodyVelocity and bodyVelocity.Parent then
        bodyVelocity:Destroy()
    end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyBodyVelocity"
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = HumanoidRootPart
end

local function updateFlightControls()
    if flightConnection then
        flightConnection:Disconnect()
    end
    
    flightConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not flying or not bodyVelocity or not bodyVelocity.Parent then
            return
        end
        
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- Forward/Backward (W/S)
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        
        -- Left/Right (A/D)
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        
        -- Up/Down (Space/Shift)
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection + Vector3.new(0, -1, 0)
        end
        
        -- Normalize and apply speed
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * flySpeed
        end
        
        bodyVelocity.Velocity = moveDirection
    end)
end

local function toggleFly()
    flying = not flying
    
    if flying then
        createBodyVelocity()
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        Humanoid.PlatformStand = true
        updateFlightControls()
        
        -- Update GUI
        StatusLabel.Text = "Status: ENABLED"
        StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
        ToggleButton.Text = "DISABLE FLIGHT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        if flightConnection then
            flightConnection:Disconnect()
        end
        Humanoid.PlatformStand = false
        
        -- Update GUI
        StatusLabel.Text = "Status: DISABLED"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        ToggleButton.Text = "ENABLE FLIGHT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end

local function updateSpeed(change)
    flySpeed = math.clamp(flySpeed + change, 10, 200)
    SpeedLabel.Text = "Speed: " .. flySpeed
    SpeedDisplay.Text = tostring(flySpeed)
end

-- Connect events
ToggleButton.MouseButton1Click:Connect(toggleFly)
DecreaseButton.MouseButton1Click:Connect(function()
    updateSpeed(-10)
end)
IncreaseButton.MouseButton1Click:Connect(function()
    updateSpeed(10)
end)

-- Key bind (F key to toggle)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

-- Notify user
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fly Script Loaded",
    Text = "GUI created! Press F to toggle flight",
    Duration = 5
})
