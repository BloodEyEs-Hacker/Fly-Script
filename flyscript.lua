-- Multi-Function Menu for Roblox
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Variables for functions
local flying = false
local flySpeed = 50
local bodyVelocity
local speedHackEnabled = false
local highJumpEnabled = false
local espEnabled = false

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MultiMenuGUI"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
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
Title.Text = "MULTI-FUNCTION MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Title Corner
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Function Buttons Container
local ButtonsContainer = Instance.new("Frame")
ButtonsContainer.Name = "ButtonsContainer"
ButtonsContainer.Size = UDim2.new(0.9, 0, 0, 250)
ButtonsContainer.Position = UDim2.new(0.05, 0, 0, 50)
ButtonsContainer.BackgroundTransparency = 1
ButtonsContainer.Parent = MainFrame

-- Function 1: SpeedHack
local SpeedHackButton = Instance.new("TextButton")
SpeedHackButton.Name = "SpeedHackButton"
SpeedHackButton.Size = UDim2.new(1, 0, 0, 40)
SpeedHackButton.Position = UDim2.new(0, 0, 0, 0)
SpeedHackButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
SpeedHackButton.Text = "SPEED HACK: OFF"
SpeedHackButton.TextColor3 = Color3.fromRGB(255, 80, 80)
SpeedHackButton.TextSize = 14
SpeedHackButton.Font = Enum.Font.GothamBold
SpeedHackButton.Parent = ButtonsContainer

-- Function 2: KillAll
local KillAllButton = Instance.new("TextButton")
KillAllButton.Name = "KillAllButton"
KillAllButton.Size = UDim2.new(1, 0, 0, 40)
KillAllButton.Position = UDim2.new(0, 0, 0, 50)
KillAllButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
KillAllButton.Text = "KILL ALL"
KillAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAllButton.TextSize = 14
KillAllButton.Font = Enum.Font.GothamBold
KillAllButton.Parent = ButtonsContainer

-- Function 3: ESP
local ESPButton = Instance.new("TextButton")
ESPButton.Name = "ESPButton"
ESPButton.Size = UDim2.new(1, 0, 0, 40)
ESPButton.Position = UDim2.new(0, 0, 0, 100)
ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ESPButton.Text = "ESP: OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 80, 80)
ESPButton.TextSize = 14
ESPButton.Font = Enum.Font.GothamBold
ESPButton.Parent = ButtonsContainer

-- Function 4: Fly
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyButton"
FlyButton.Size = UDim2.new(1, 0, 0, 40)
FlyButton.Position = UDim2.new(0, 0, 0, 150)
FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
FlyButton.Text = "FLY: OFF"
FlyButton.TextColor3 = Color3.fromRGB(255, 80, 80)
FlyButton.TextSize = 14
FlyButton.Font = Enum.Font.GothamBold
FlyButton.Parent = ButtonsContainer

-- Function 5: HighJump
local HighJumpButton = Instance.new("TextButton")
HighJumpButton.Name = "HighJumpButton"
HighJumpButton.Size = UDim2.new(1, 0, 0, 40)
HighJumpButton.Position = UDim2.new(0, 0, 0, 200)
HighJumpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
HighJumpButton.Text = "HIGH JUMP: OFF"
HighJumpButton.TextColor3 = Color3.fromRGB(255, 80, 80)
HighJumpButton.TextSize = 14
HighJumpButton.Font = Enum.Font.GothamBold
HighJumpButton.Parent = ButtonsContainer

-- Speed Controls Frame (for Fly)
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 40)
SpeedFrame.Position = UDim2.new(0.05, 0, 0, 310)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpeedFrame.BackgroundTransparency = 0.5
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Visible = false
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
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = SpeedHackButton
ButtonCorner:Clone().Parent = KillAllButton
ButtonCorner:Clone().Parent = ESPButton
ButtonCorner:Clone().Parent = FlyButton
ButtonCorner:Clone().Parent = HighJumpButton

local SmallButtonCorner = Instance.new("UICorner")
SmallButtonCorner.CornerRadius = UDim.new(0, 4)
SmallButtonCorner.Parent = DecreaseButton
SmallButtonCorner:Clone().Parent = IncreaseButton

local DisplayCorner = Instance.new("UICorner")
DisplayCorner.CornerRadius = UDim.new(0, 4)
DisplayCorner.Parent = SpeedDisplay

-- FUNCTION 1: SPEED HACK
local function toggleSpeedHack()
    speedHackEnabled = not speedHackEnabled
    
    if speedHackEnabled then
        Humanoid.WalkSpeed = 50
        SpeedHackButton.Text = "SPEED HACK: ON"
        SpeedHackButton.TextColor3 = Color3.fromRGB(80, 255, 80)
        SpeedHackButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    else
        Humanoid.WalkSpeed = 16
        SpeedHackButton.Text = "SPEED HACK: OFF"
        SpeedHackButton.TextColor3 = Color3.fromRGB(255, 80, 80)
        SpeedHackButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end
end

-- FUNCTION 2: KILL ALL
local function killAll()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= Player and player.Character then
            local targetHumanoid = player.Character:FindFirstChild("Humanoid")
            if targetHumanoid then
                targetHumanoid.Health = 0
            end
        end
    end
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Kill All",
        Text = "All players killed!",
        Duration = 3
    })
end

-- FUNCTION 3: ESP
local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        ESPButton.Text = "ESP: ON"
        ESPButton.TextColor3 = Color3.fromRGB(80, 255, 80)
        ESPButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= Player and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                highlight.Parent = player.Character
            end
        end
    else
        ESPButton.Text = "ESP: OFF"
        ESPButton.TextColor3 = Color3.fromRGB(255, 80, 80)
        ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESP_Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

-- FUNCTION 4: FLY
local function createBodyVelocity()
    if bodyVelocity and bodyVelocity.Parent then
        bodyVelocity:Destroy()
    end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyBodyVelocity"
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.Parent = HumanoidRootPart
end

local function toggleFly()
    flying = not flying
    
    if flying then
        createBodyVelocity()
        Humanoid.PlatformStand = true
        
        -- Auto-fly forward
        local camera = workspace.CurrentCamera
        bodyVelocity.Velocity = camera.CFrame.LookVector * flySpeed
        
        FlyButton.Text = "FLY: ON"
        FlyButton.TextColor3 = Color3.fromRGB(80, 255, 80)
        FlyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        SpeedFrame.Visible = true
        
        -- Flight loop
        game:GetService("RunService").Heartbeat:Connect(function()
            if not flying or not bodyVelocity or not bodyVelocity.Parent then return end
            local camera = workspace.CurrentCamera
            bodyVelocity.Velocity = camera.CFrame.LookVector * flySpeed
        end)
        
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        Humanoid.PlatformStand = false
        
        FlyButton.Text = "FLY: OFF"
        FlyButton.TextColor3 = Color3.fromRGB(255, 80, 80)
        FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        SpeedFrame.Visible = false
    end
end

-- FUNCTION 5: HIGH JUMP
local function toggleHighJump()
    highJumpEnabled = not highJumpEnabled
    
    if highJumpEnabled then
        Humanoid.JumpPower = 100
        HighJumpButton.Text = "HIGH JUMP: ON"
        HighJumpButton.TextColor3 = Color3.fromRGB(80, 255, 80)
        HighJumpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    else
        Humanoid.JumpPower = 50
        HighJumpButton.Text = "HIGH JUMP: OFF"
        HighJumpButton.TextColor3 = Color3.fromRGB(255, 80, 80)
        HighJumpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end
end

-- Speed control for fly
local function updateSpeed(change)
    flySpeed = math.clamp(flySpeed + change, 10, 200)
    SpeedDisplay.Text = tostring(flySpeed)
end

-- Connect events
SpeedHackButton.MouseButton1Click:Connect(toggleSpeedHack)
KillAllButton.MouseButton1Click:Connect(killAll)
ESPButton.MouseButton1Click:Connect(toggleESP)
FlyButton.MouseButton1Click:Connect(toggleFly)
HighJumpButton.MouseButton1Click:Connect(toggleHighJump)
DecreaseButton.MouseButton1Click:Connect(function() updateSpeed(-10) end)
IncreaseButton.MouseButton1Click:Connect(function() updateSpeed(10) end)

-- Notify user
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Multi-Function Menu Loaded",
    Text = "5 functions available!",
    Duration = 5
})
