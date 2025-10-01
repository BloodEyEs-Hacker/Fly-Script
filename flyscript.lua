-- Advanced Multi-Function Menu for Roblox
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Variables
local flying = false
local flySpeed = 50
local bodyVelocity
local speedHackEnabled = false
local highJumpEnabled = false
local espEnabled = false
local currentTab = "Main"
local minimized = false
local dragging = false
local dragInput, dragStart, startPos

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedMenuGUI"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 350, 0, 400)
MainWindow.Position = UDim2.new(0, 10, 0, 10)
MainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainWindow.BorderColor3 = Color3.fromRGB(0, 100, 255)
MainWindow.BorderSizePixel = 2
MainWindow.Parent = ScreenGui

-- Window Corner
local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 8)
WindowCorner.Parent = MainWindow

-- Title Bar (for dragging)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
TitleBar.BackgroundTransparency = 0.3
TitleBar.Parent = MainWindow

-- Title Bar Corner
local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 8)
TitleBarCorner.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "ADVANCED MENU"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 20)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 20)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

-- Button Corners
local SmallCorner = Instance.new("UICorner")
SmallCorner.CornerRadius = UDim.new(0, 4)
SmallCorner.Parent = MinimizeButton
SmallCorner:Clone().Parent = CloseButton

-- Tabs Container
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(1, 0, 0, 40)
TabsContainer.Position = UDim2.new(0, 0, 0, 30)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = MainWindow

-- Tab Buttons
local tabs = {"Main", "Movement", "Visual", "Combat"}

for i, tabName in ipairs(tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Tab"
    TabButton.Size = UDim2.new(1/#tabs, 0, 1, 0)
    TabButton.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 12
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Parent = TabsContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 4)
    TabCorner.Parent = TabButton
end

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -20, 1, -80)
ContentArea.Position = UDim2.new(0, 10, 0, 75)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainWindow

-- MAIN TAB CONTENT
local MainTab = Instance.new("Frame")
MainTab.Name = "MainTab"
MainTab.Size = UDim2.new(1, 0, 1, 0)
MainTab.BackgroundTransparency = 1
MainTab.Visible = true
MainTab.Parent = ContentArea

-- Quick Actions
local QuickActions = Instance.new("TextLabel")
QuickActions.Size = UDim2.new(1, 0, 0, 25)
QuickActions.Position = UDim2.new(0, 0, 0, 0)
QuickActions.BackgroundTransparency = 1
QuickActions.Text = "QUICK ACTIONS"
QuickActions.TextColor3 = Color3.fromRGB(0, 200, 255)
QuickActions.TextSize = 14
QuickActions.Font = Enum.Font.GothamBold
QuickActions.TextXAlignment = Enum.TextXAlignment.Left
QuickActions.Parent = MainTab

-- Kill All Button (Prison Life Version)
local KillAllButton = Instance.new("TextButton")
KillAllButton.Name = "KillAllButton"
KillAllButton.Size = UDim2.new(1, 0, 0, 35)
KillAllButton.Position = UDim2.new(0, 0, 0, 30)
KillAllButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
KillAllButton.Text = "KILL ALL (PRISON LIFE)"
KillAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAllButton.TextSize = 14
KillAllButton.Font = Enum.Font.GothamBold
KillAllButton.Parent = MainTab

-- MOVEMENT TAB CONTENT
local MovementTab = Instance.new("Frame")
MovementTab.Name = "MovementTab"
MovementTab.Size = UDim2.new(1, 0, 1, 0)
MovementTab.BackgroundTransparency = 1
MovementTab.Visible = false
MovementTab.Parent = ContentArea

-- Fly Section
local FlySection = Instance.new("TextLabel")
FlySection.Size = UDim2.new(1, 0, 0, 25)
FlySection.Position = UDim2.new(0, 0, 0, 0)
FlySection.BackgroundTransparency = 1
FlySection.Text = "FLY"
FlySection.TextColor3 = Color3.fromRGB(0, 200, 255)
FlySection.TextSize = 14
FlySection.Font = Enum.Font.GothamBold
FlySection.TextXAlignment = Enum.TextXAlignment.Left
FlySection.Parent = MovementTab

local FlyToggle = Instance.new("TextButton")
FlyToggle.Name = "FlyToggle"
FlyToggle.Size = UDim2.new(1, 0, 0, 35)
FlyToggle.Position = UDim2.new(0, 0, 0, 30)
FlyToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
FlyToggle.Text = "FLY: OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.TextSize = 14
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.Parent = MovementTab

-- Fly Speed Controls
local FlySpeedLabel = Instance.new("TextLabel")
FlySpeedLabel.Size = UDim2.new(1, 0, 0, 20)
FlySpeedLabel.Position = UDim2.new(0, 0, 0, 75)
FlySpeedLabel.BackgroundTransparency = 1
FlySpeedLabel.Text = "Fly Speed: 50"
FlySpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FlySpeedLabel.TextSize = 12
FlySpeedLabel.Font = Enum.Font.Gotham
FlySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
FlySpeedLabel.Parent = MovementTab

local FlySpeedMinus = Instance.new("TextButton")
FlySpeedMinus.Size = UDim2.new(0.2, 0, 0, 25)
FlySpeedMinus.Position = UDim2.new(0, 0, 0, 100)
FlySpeedMinus.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
FlySpeedMinus.Text = "-"
FlySpeedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
FlySpeedMinus.TextSize = 16
FlySpeedMinus.Font = Enum.Font.GothamBold
FlySpeedMinus.Parent = MovementTab

local FlySpeedValue = Instance.new("TextLabel")
FlySpeedValue.Size = UDim2.new(0.6, 0, 0, 25)
FlySpeedValue.Position = UDim2.new(0.2, 0, 0, 100)
FlySpeedValue.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
FlySpeedValue.Text = "50"
FlySpeedValue.TextColor3 = Color3.fromRGB(0, 200, 255)
FlySpeedValue.TextSize = 14
FlySpeedValue.Font = Enum.Font.GothamBold
FlySpeedValue.Parent = MovementTab

local FlySpeedPlus = Instance.new("TextButton")
FlySpeedPlus.Size = UDim2.new(0.2, 0, 0, 25)
FlySpeedPlus.Position = UDim2.new(0.8, 0, 0, 100)
FlySpeedPlus.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
FlySpeedPlus.Text = "+"
FlySpeedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
FlySpeedPlus.TextSize = 16
FlySpeedPlus.Font = Enum.Font.GothamBold
FlySpeedPlus.Parent = MovementTab

-- Speed Hack Section
local SpeedSection = Instance.new("TextLabel")
SpeedSection.Size = UDim2.new(1, 0, 0, 25)
SpeedSection.Position = UDim2.new(0, 0, 0, 140)
SpeedSection.BackgroundTransparency = 1
SpeedSection.Text = "SPEED HACK"
SpeedSection.TextColor3 = Color3.fromRGB(0, 200, 255)
SpeedSection.TextSize = 14
SpeedSection.Font = Enum.Font.GothamBold
SpeedSection.TextXAlignment = Enum.TextXAlignment.Left
SpeedSection.Parent = MovementTab

local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Name = "SpeedToggle"
SpeedToggle.Size = UDim2.new(1, 0, 0, 35)
SpeedToggle.Position = UDim2.new(0, 0, 0, 170)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
SpeedToggle.Text = "SPEED HACK: OFF"
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggle.TextSize = 14
SpeedToggle.Font = Enum.Font.GothamBold
SpeedToggle.Parent = MovementTab

-- Speed Value Controls
local SpeedValueLabel = Instance.new("TextLabel")
SpeedValueLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedValueLabel.Position = UDim2.new(0, 0, 0, 215)
SpeedValueLabel.BackgroundTransparency = 1
SpeedValueLabel.Text = "Walk Speed: 16"
SpeedValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedValueLabel.TextSize = 12
SpeedValueLabel.Font = Enum.Font.Gotham
SpeedValueLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedValueLabel.Parent = MovementTab

local SpeedValueMinus = Instance.new("TextButton")
SpeedValueMinus.Size = UDim2.new(0.2, 0, 0, 25)
SpeedValueMinus.Position = UDim2.new(0, 0, 0, 240)
SpeedValueMinus.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
SpeedValueMinus.Text = "-"
SpeedValueMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValueMinus.TextSize = 16
SpeedValueMinus.Font = Enum.Font.GothamBold
SpeedValueMinus.Parent = MovementTab

local SpeedValueDisplay = Instance.new("TextLabel")
SpeedValueDisplay.Size = UDim2.new(0.6, 0, 0, 25)
SpeedValueDisplay.Position = UDim2.new(0.2, 0, 0, 240)
SpeedValueDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
SpeedValueDisplay.Text = "16"
SpeedValueDisplay.TextColor3 = Color3.fromRGB(0, 200, 255)
SpeedValueDisplay.TextSize = 14
SpeedValueDisplay.Font = Enum.Font.GothamBold
SpeedValueDisplay.Parent = MovementTab

local SpeedValuePlus = Instance.new("TextButton")
SpeedValuePlus.Size = UDim2.new(0.2, 0, 0, 25)
SpeedValuePlus.Position = UDim2.new(0.8, 0, 0, 240)
SpeedValuePlus.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
SpeedValuePlus.Text = "+"
SpeedValuePlus.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValuePlus.TextSize = 16
SpeedValuePlus.Font = Enum.Font.GothamBold
SpeedValuePlus.Parent = MovementTab

-- High Jump Section
local JumpSection = Instance.new("TextLabel")
JumpSection.Size = UDim2.new(1, 0, 0, 25)
JumpSection.Position = UDim2.new(0, 0, 0, 280)
JumpSection.BackgroundTransparency = 1
JumpSection.Text = "HIGH JUMP"
JumpSection.TextColor3 = Color3.fromRGB(0, 200, 255)
JumpSection.TextSize = 14
JumpSection.Font = Enum.Font.GothamBold
JumpSection.TextXAlignment = Enum.TextXAlignment.Left
JumpSection.Parent = MovementTab

local JumpToggle = Instance.new("TextButton")
JumpToggle.Name = "JumpToggle"
JumpToggle.Size = UDim2.new(1, 0, 0, 35)
JumpToggle.Position = UDim2.new(0, 0, 0, 310)
JumpToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
JumpToggle.Text = "HIGH JUMP: OFF"
JumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpToggle.TextSize = 14
JumpToggle.Font = Enum.Font.GothamBold
JumpToggle.Parent = MovementTab

-- Jump Power Controls
local JumpPowerLabel = Instance.new("TextLabel")
JumpPowerLabel.Size = UDim2.new(1, 0, 0, 20)
JumpPowerLabel.Position = UDim2.new(0, 0, 0, 355)
JumpPowerLabel.BackgroundTransparency = 1
JumpPowerLabel.Text = "Jump Power: 50"
JumpPowerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
JumpPowerLabel.TextSize = 12
JumpPowerLabel.Font = Enum.Font.Gotham
JumpPowerLabel.TextXAlignment = Enum.TextXAlignment.Left
JumpPowerLabel.Parent = MovementTab

local JumpPowerMinus = Instance.new("TextButton")
JumpPowerMinus.Size = UDim2.new(0.2, 0, 0, 25)
JumpPowerMinus.Position = UDim2.new(0, 0, 0, 380)
JumpPowerMinus.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
JumpPowerMinus.Text = "-"
JumpPowerMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpPowerMinus.TextSize = 16
JumpPowerMinus.Font = Enum.Font.GothamBold
JumpPowerMinus.Parent = MovementTab

local JumpPowerDisplay = Instance.new("TextLabel")
JumpPowerDisplay.Size = UDim2.new(0.6, 0, 0, 25)
JumpPowerDisplay.Position = UDim2.new(0.2, 0, 0, 380)
JumpPowerDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
JumpPowerDisplay.Text = "50"
JumpPowerDisplay.TextColor3 = Color3.fromRGB(0, 200, 255)
JumpPowerDisplay.TextSize = 14
JumpPowerDisplay.Font = Enum.Font.GothamBold
JumpPowerDisplay.Parent = MovementTab

local JumpPowerPlus = Instance.new("TextButton")
JumpPowerPlus.Size = UDim2.new(0.2, 0, 0, 25)
JumpPowerPlus.Position = UDim2.new(0.8, 0, 0, 380)
JumpPowerPlus.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
JumpPowerPlus.Text = "+"
JumpPowerPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpPowerPlus.TextSize = 16
JumpPowerPlus.Font = Enum.Font.GothamBold
JumpPowerPlus.Parent = MovementTab

-- VISUAL TAB CONTENT
local VisualTab = Instance.new("Frame")
VisualTab.Name = "VisualTab"
VisualTab.Size = UDim2.new(1, 0, 1, 0)
VisualTab.BackgroundTransparency = 1
VisualTab.Visible = false
VisualTab.Parent = ContentArea

-- ESP Section
local ESPSection = Instance.new("TextLabel")
ESPSection.Size = UDim2.new(1, 0, 0, 25)
ESPSection.Position = UDim2.new(0, 0, 0, 0)
ESPSection.BackgroundTransparency = 1
ESPSection.Text = "ESP SETTINGS"
ESPSection.TextColor3 = Color3.fromRGB(0, 200, 255)
ESPSection.TextSize = 14
ESPSection.Font = Enum.Font.GothamBold
ESPSection.TextXAlignment = Enum.TextXAlignment.Left
ESPSection.Parent = VisualTab

local ESPToggle = Instance.new("TextButton")
ESPToggle.Name = "ESPToggle"
ESPToggle.Size = UDim2.new(1, 0, 0, 35)
ESPToggle.Position = UDim2.new(0, 0, 0, 30)
ESPToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ESPToggle.Text = "ESP: OFF"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.TextSize = 14
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.Parent = VisualTab

-- Tracers Toggle
local TracersToggle = Instance.new("TextButton")
TracersToggle.Name = "TracersToggle"
TracersToggle.Size = UDim2.new(1, 0, 0, 35)
TracersToggle.Position = UDim2.new(0, 0, 0, 75)
TracersToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
TracersToggle.Text = "TRACERS: OFF"
TracersToggle.TextColor3 = Color3.fromRGB(255, 80, 80)
TracersToggle.TextSize = 14
TracersToggle.Font = Enum.Font.GothamBold
TracersToggle.Parent = VisualTab

-- ESP Color Selection
local ColorSection = Instance.new("TextLabel")
ColorSection.Size = UDim2.new(1, 0, 0, 25)
ColorSection.Position = UDim2.new(0, 0, 0, 120)
ColorSection.BackgroundTransparency = 1
ColorSection.Text = "ESP COLOR"
ColorSection.TextColor3 = Color3.fromRGB(0, 200, 255)
ColorSection.TextSize = 14
ColorSection.Font = Enum.Font.GothamBold
ColorSection.TextXAlignment = Enum.TextXAlignment.Left
ColorSection.Parent = VisualTab

local colors = {
    {Name = "RED", Color = Color3.fromRGB(255, 0, 0)},
    {Name = "GREEN", Color = Color3.fromRGB(0, 255, 0)},
    {Name = "BLUE", Color = Color3.fromRGB(0, 100, 255)},
    {Name = "YELLOW", Color = Color3.fromRGB(255, 255, 0)}
}

for i, colorInfo in ipairs(colors) do
    local ColorButton = Instance.new("TextButton")
    ColorButton.Name = colorInfo.Name .. "Color"
    ColorButton.Size = UDim2.new(0.48, 0, 0, 30)
    ColorButton.Position = UDim2.new((i-1)%2 * 0.5, 0, 0, 150 + math.floor((i-1)/2)*35)
    ColorButton.BackgroundColor3 = colorInfo.Color
    ColorButton.Text = colorInfo.Name
    ColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorButton.TextSize = 12
    ColorButton.Font = Enum.Font.GothamBold
    ColorButton.Parent = VisualTab
end

-- COMBAT TAB CONTENT
local CombatTab = Instance.new("Frame")
CombatTab.Name = "CombatTab"
CombatTab.Size = UDim2.new(1, 0, 1, 0)
CombatTab.BackgroundTransparency = 1
CombatTab.Visible = false
CombatTab.Parent = ContentArea

-- Apply corners to all buttons
local function applyCorner(button)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
end

applyCorner(FlyToggle)
applyCorner(FlySpeedMinus)
applyCorner(FlySpeedValue)
applyCorner(FlySpeedPlus)
applyCorner(SpeedToggle)
applyCorner(SpeedValueMinus)
applyCorner(SpeedValueDisplay)
applyCorner(SpeedValuePlus)
applyCorner(JumpToggle)
applyCorner(JumpPowerMinus)
applyCorner(JumpPowerDisplay)
applyCorner(JumpPowerPlus)
applyCorner(ESPToggle)
applyCorner(TracersToggle)
applyCorner(KillAllButton)

for i, colorInfo in ipairs(colors) do
    applyCorner(VisualTab:FindFirstChild(colorInfo.Name .. "Color"))
end

-- VARIABLES FOR FUNCTIONS
local walkSpeed = 16
local jumpPower = 50
local espColor = Color3.fromRGB(255, 0, 0)
local tracersEnabled = false
local espHighlights = {}
local tracerLines = {}

-- FUNCTION: KILL ALL (Prison Life Version)
local function prisonLifeKillAll()
    local players = game:GetService("Players"):GetPlayers()
    local killed = 0
    
    for _, player in pairs(players) do
        if player ~= Player and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
            
            if humanoid and tool then
                -- Simulate weapon hit
                humanoid:TakeDamage(100)
                killed = killed + 1
            end
        end
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Prison Life Kill All",
        Text = "Attempted to kill " .. killed .. " players",
        Duration = 3
    })
end

-- FUNCTION: FLY
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
        
        FlyToggle.Text = "FLY: ON"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        
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
        
        FlyToggle.Text = "FLY: OFF"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end

-- FUNCTION: SPEED HACK
local function toggleSpeedHack()
    speedHackEnabled = not speedHackEnabled
    
    if speedHackEnabled then
        Humanoid.WalkSpeed = walkSpeed
        SpeedToggle.Text = "SPEED HACK: ON"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        Humanoid.WalkSpeed = 16
        SpeedToggle.Text = "SPEED HACK: OFF"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end

-- FUNCTION: HIGH JUMP
local function toggleHighJump()
    highJumpEnabled = not highJumpEnabled
    
    if highJumpEnabled then
        Humanoid.JumpPower = jumpPower
        JumpToggle.Text = "HIGH JUMP: ON"
        JumpToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        Humanoid.JumpPower = 50
        JumpToggle.Text = "HIGH JUMP: OFF"
        JumpToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end

-- FUNCTION: ESP
local function updateESP()
    -- Clear existing ESP
    for _, highlight in pairs(espHighlights) do
        highlight:Destroy()
    end
    for _, line in pairs(tracerLines) do
        line:Destroy()
    end
    espHighlights = {}
    tracerLines = {}
    
    if espEnabled then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= Player and player.Character then
                -- Create Highlight
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.FillColor = espColor
                highlight.OutlineColor = espColor
                highlight.FillTransparency = 0.3
                highlight.OutlineTransparency = 0
                highlight.Parent = player.Character
                espHighlights[player] = highlight
                
                -- Create Tracer if enabled
                if tracersEnabled then
                    local tracer = Instance.new("Line")
                    tracer.Name = "ESP_Tracer"
                    tracer.Color = espColor
                    tracer.Thickness = 2
                    tracer.Parent = game:GetService("CoreGui")
                    tracerLines[player] = tracer
                    
                    -- Update tracer position
                    game:GetService("RunService").RenderStepped:Connect(function()
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local rootPart = player.Character.HumanoidRootPart
                            local camera = workspace.CurrentCamera
                            tracer.From = camera.CFrame.Position
                            tracer.To = rootPart.Position
                        end
                    end)
                end
            end
        end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        ESPToggle.Text = "ESP: ON"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        updateESP()
    else
        ESPToggle.Text = "ESP: OFF"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        updateESP()
    end
end

local function toggleTracers()
    tracersEnabled = not tracersEnabled
    
    if tracersEnabled then
        TracersToggle.Text = "TRACERS: ON"
        TracersToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        TracersToggle.Text = "TRACERS: OFF"
        TracersToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
    
    if espEnabled then
        updateESP()
    end
end

-- WINDOW DRAGGING
local function updateInput(input)
    local delta = input.Position - dragStart
    MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainWindow.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- MINIMIZE FUNCTION
local function toggleMinimize()
    minimized = not minimized
    if minimized then
        MainWindow.Size = UDim2.new(0, 350, 0, 30)
        MinimizeButton.Text = "+"
    else
        MainWindow.Size = UDim2.new(0, 350, 0, 400)
        MinimizeButton.Text = "_"
    end
end

-- TAB SWITCHING
local function switchTab(tabName)
    currentTab = tabName
    
    -- Hide all tabs
    MainTab.Visible = false
    MovementTab.Visible = false
    VisualTab.Visible = false
    CombatTab.Visible = false
    
    -- Show selected tab
    if tabName == "Main" then
        MainTab.Visible = true
    elseif tabName == "Movement" then
        MovementTab.Visible = true
    elseif tabName == "Visual" then
        VisualTab.Visible = true
    elseif tabName == "Combat" then
        CombatTab.Visible = true
    end
    
    -- Update tab buttons
    for _, tab in ipairs(tabs) do
        local tabButton = TabsContainer:FindFirstChild(tab .. "Tab")
        if tabButton then
            if tab == tabName then
                tabButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
                tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end
end

-- CONNECT EVENTS
MinimizeButton.MouseButton1Click:Connect(toggleMinimize)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab buttons
for _, tabName in ipairs(tabs) do
    local tabButton = TabsContainer:FindFirstChild(tabName .. "Tab")
    if tabButton then
        tabButton.MouseButton1Click:Connect(function()
            switchTab(tabName)
        end)
    end
end

-- Function buttons
KillAllButton.MouseButton1Click:Connect(prisonLifeKillAll)
FlyToggle.MouseButton1Click:Connect(toggleFly)
SpeedToggle.MouseButton1Click:Connect(toggleSpeedHack)
JumpToggle.MouseButton1Click:Connect(toggleHighJump)
ESPToggle.MouseButton1Click:Connect(toggleESP)
TracersToggle.MouseButton1Click:Connect(toggleTracers)

-- Speed controls
FlySpeedMinus.MouseButton1Click:Connect(function()
    flySpeed = math.max(10, flySpeed - 10)
    FlySpeedValue.Text = tostring(flySpeed)
    FlySpeedLabel.Text = "Fly Speed: " .. flySpeed
end)

FlySpeedPlus.MouseButton1Click:Connect(function()
    flySpeed = math.min(200, flySpeed + 10)
    FlySpeedValue.Text = tostring(flySpeed)
    FlySpeedLabel.Text = "Fly Speed: " .. flySpeed
end)

SpeedValueMinus.MouseButton1Click:Connect(function()
    walkSpeed = math.max(16, walkSpeed - 5)
    SpeedValueDisplay.Text = tostring(walkSpeed)
    SpeedValueLabel.Text = "Walk Speed: " .. walkSpeed
    if speedHackEnabled then
        Humanoid.WalkSpeed = walkSpeed
    end
end)

SpeedValuePlus.MouseButton1Click:Connect(function()
    walkSpeed = math.min(100, walkSpeed + 5)
    SpeedValueDisplay.Text = tostring(walkSpeed)
    SpeedValueLabel.Text = "Walk Speed: " .. walkSpeed
    if speedHackEnabled then
        Humanoid.WalkSpeed = walkSpeed
    end
end)

JumpPowerMinus.MouseButton1Click:Connect(function()
    jumpPower = math.max(50, jumpPower - 10)
    JumpPowerDisplay.Text = tostring(jumpPower)
    JumpPowerLabel.Text = "Jump Power: " .. jumpPower
    if highJumpEnabled then
        Humanoid.JumpPower = jumpPower
    end
end)

JumpPowerPlus.MouseButton1Click:Connect(function()
    jumpPower = math.min(200, jumpPower + 10)
    JumpPowerDisplay.Text = tostring(jumpPower)
    JumpPowerLabel.Text = "Jump Power: " .. jumpPower
    if highJumpEnabled then
        Humanoid.JumpPower = jumpPower
    end
end)

-- Color buttons
for _, colorInfo in ipairs(colors) do
    local colorButton = VisualTab:FindFirstChild(colorInfo.Name .. "Color")
    if colorButton then
        colorButton.MouseButton1Click:Connect(function()
            espColor = colorInfo.Color
            if espEnabled then
                updateESP()
            end
        end)
    end
end

-- Initial setup
switchTab("Main")

-- Notify user
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Advanced Menu Loaded",
    Text = "4 tabs with drag & minimize!",
    Duration = 5
})
