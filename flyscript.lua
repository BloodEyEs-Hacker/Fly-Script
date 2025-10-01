-- Advanced Multi-Function Menu for Roblox - FIXED VERSION
local Player = game:GetService("Players").LocalPlayer
local Character = Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Variables
local flying = false
local flySpeed = 50
local bodyVelocity
local speedHackEnabled = false
local highJumpEnabled = false
local espEnabled = false
local killAuraEnabled = false
local currentTab = "Main"
local minimized = false
local dragging = false
local dragInput, dragStart, startPos

-- Replication fix for character respawn
local function setupCharacter()
    Character = Player.Character
    if Character then
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        Humanoid = Character:WaitForChild("Humanoid")
        
        -- Reapply effects if they were enabled
        if speedHackEnabled then
            Humanoid.WalkSpeed = walkSpeed
        end
        if highJumpEnabled then
            Humanoid.JumpPower = jumpPower
        end
        if flying then
            toggleFly(false) -- Turn off flight on respawn
        end
    end
end

Player.CharacterAdded:Connect(setupCharacter)

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedMenuGUI"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Window (HORIZONTAL)
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 600, 0, 350) -- Wider, less tall
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
TitleText.Text = "ADVANCED MENU v2.0"
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

-- Tabs Container (Horizontal layout)
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(1, -20, 0, 35)
TabsContainer.Position = UDim2.new(0, 10, 0, 35)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = MainWindow

-- Tab Buttons
local tabs = {"Main", "Movement", "Visual", "Combat", "TP"}
local tabFrames = {}

for i, tabName in ipairs(tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Tab"
    TabButton.Size = UDim2.new(1/#tabs, -5, 1, 0)
    TabButton.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 12
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Parent = TabsContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
end

-- Content Area (Wider for horizontal layout)
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -20, 1, -80)
ContentArea.Position = UDim2.new(0, 10, 0, 75)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainWindow

-- Function to create section
local function createSection(parent, name, yPosition)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, 0, 0, 20)
    section.Position = UDim2.new(0, 0, 0, yPosition)
    section.BackgroundTransparency = 1
    section.Text = name
    section.TextColor3 = Color3.fromRGB(0, 200, 255)
    section.TextSize = 14
    section.Font = Enum.Font.GothamBold
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Parent = parent
    return section
end

-- Function to create toggle button
local function createToggle(parent, name, yPosition, defaultState)
    local toggle = Instance.new("TextButton")
    toggle.Name = name
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.Position = UDim2.new(0, 0, 0, yPosition)
    toggle.BackgroundColor3 = defaultState and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 60, 60)
    toggle.Text = name .. ": " .. (defaultState and "ON" or "OFF")
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggle
    
    return toggle
end

-- Function to create slider
local function createSlider(parent, label, yPosition, min, max, default)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.Position = UDim2.new(0, 0, 0, yPosition)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, 0, 0, 20)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label .. ": " .. default
    labelText.TextColor3 = Color3.fromRGB(200, 200, 200)
    labelText.TextSize = 12
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = sliderFrame
    
    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0.2, 0, 0, 25)
    minusBtn.Position = UDim2.new(0, 0, 0, 25)
    minusBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minusBtn.TextSize = 16
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.Parent = sliderFrame
    
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Size = UDim2.new(0.6, 0, 0, 25)
    valueDisplay.Position = UDim2.new(0.2, 0, 0, 25)
    valueDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    valueDisplay.Text = tostring(default)
    valueDisplay.TextColor3 = Color3.fromRGB(0, 200, 255)
    valueDisplay.TextSize = 14
    valueDisplay.Font = Enum.Font.GothamBold
    valueDisplay.Parent = sliderFrame
    
    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0.2, 0, 0, 25)
    plusBtn.Position = UDim2.new(0.8, 0, 0, 25)
    plusBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    plusBtn.TextSize = 16
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.Parent = sliderFrame
    
    -- Apply corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = minusBtn
    corner:Clone().Parent = valueDisplay
    corner:Clone().Parent = plusBtn
    
    return {
        frame = sliderFrame,
        label = labelText,
        minus = minusBtn,
        value = valueDisplay,
        plus = plusBtn,
        current = default,
        min = min,
        max = max
    }
end

-- Create tab contents with horizontal layout
for i, tabName in ipairs(tabs) do
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = tabName .. "Tab"
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = i == 1
    tabFrame.Parent = ContentArea
    tabFrames[tabName] = tabFrame
end

-- MAIN TAB
local MainTab = tabFrames.Main
createSection(MainTab, "QUICK ACTIONS", 0)
local KillAllBtn = createToggle(MainTab, "KILL ALL", 25, false)
local KillAuraBtn = createToggle(MainTab, "KILL AURA", 60, false)

-- MOVEMENT TAB
local MovementTab = tabFrames.Movement
createSection(MovementTab, "FLIGHT", 0)
local FlyToggle = createToggle(MovementTab, "FLY", 25, false)
local FlySlider = createSlider(MovementTab, "Fly Speed", 60, 10, 200, 50)

createSection(MovementTab, "SPEED", 120)
local SpeedToggle = createToggle(MovementTab, "SPEED HACK", 145, false)
local SpeedSlider = createSlider(MovementTab, "Walk Speed", 180, 16, 100, 16)

createSection(MovementTab, "JUMP", 240)
local JumpToggle = createToggle(MovementTab, "HIGH JUMP", 265, false)
local JumpSlider = createSlider(MovementTab, "Jump Power", 300, 50, 200, 50)

-- VISUAL TAB
local VisualTab = tabFrames.Visual
createSection(VisualTab, "ESP SETTINGS", 0)
local ESPToggle = createToggle(VisualTab, "ESP", 25, false)
local TracersToggle = createToggle(VisualTab, "TRACERS", 60, false)

createSection(VisualTab, "COLORS", 105)
-- Color buttons in horizontal layout
local colors = {
    {Name = "RED", Color = Color3.fromRGB(255, 0, 0)},
    {Name = "GREEN", Color = Color3.fromRGB(0, 255, 0)},
    {Name = "BLUE", Color = Color3.fromRGB(0, 100, 255)},
    {Name = "YELLOW", Color = Color3.fromRGB(255, 255, 0)}
}

for i, colorInfo in ipairs(colors) do
    local ColorButton = Instance.new("TextButton")
    ColorButton.Name = colorInfo.Name .. "Color"
    ColorButton.Size = UDim2.new(0.23, 0, 0, 25)
    ColorButton.Position = UDim2.new((i-1)*0.25, 0, 0, 130)
    ColorButton.BackgroundColor3 = colorInfo.Color
    ColorButton.Text = colorInfo.Name
    ColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorButton.TextSize = 10
    ColorButton.Font = Enum.Font.GothamBold
    ColorButton.Parent = VisualTab
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = ColorButton
end

-- COMBAT TAB
local CombatTab = tabFrames.Combat
createSection(CombatTab, "COMBAT SETTINGS", 0)
local KillAuraCombatBtn = createToggle(CombatTab, "KILL AURA", 25, false)
local KillAuraRangeSlider = createSlider(CombatTab, "Aura Range", 60, 5, 50, 15)

-- TP TAB
local TPTab = tabFrames.TP
createSection(TPTab, "TELEPORT", 0)

-- Player list for TP
local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, 0, 1, -40)
playerScroll.Position = UDim2.new(0, 0, 0, 25)
playerScroll.BackgroundTransparency = 1
playerScroll.ScrollBarThickness = 6
playerScroll.Parent = TPTab

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Parent = playerScroll

-- VARIABLES
local walkSpeed = 16
local jumpPower = 50
local espColor = Color3.fromRGB(255, 0, 0)
local tracersEnabled = false
local killAuraRange = 15
local espHighlights = {}
local tracerLines = {}
local killAuraConnection

-- FIXED ESP SYSTEM
local function updateESP()
    -- Clear existing ESP
    for player, highlight in pairs(espHighlights) do
        if highlight then
            highlight:Destroy()
        end
    end
    for player, line in pairs(tracerLines) do
        if line then
            line:Destroy()
        end
    end
    espHighlights = {}
    tracerLines = {}
    
    if not espEnabled then return end
    
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= Player then
            -- Create ESP for existing characters
            if player.Character then
                createESPForPlayer(player)
            end
            
            -- Listen for new characters
            player.CharacterAdded:Connect(function(char)
                if espEnabled then
                    wait(0.5) -- Wait for character to load
                    createESPForPlayer(player)
                end
            end)
        end
    end
end

local function createESPForPlayer(player)
    if not player.Character then return end
    
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
        tracer.ZIndex = 1
        tracer.Parent = ScreenGui
        
        -- Store both line and connection
        tracerLines[player] = {
            line = tracer,
            connection = game:GetService("RunService").RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and Character and HumanoidRootPart then
                    local rootPart = player.Character.HumanoidRootPart
                    tracer.Visible = true
                    tracer.From = Vector3.new(0, 0, 0) -- Camera position doesn't work well on mobile
                    tracer.To = rootPart.Position
                else
                    tracer.Visible = false
                end
            end)
        }
    end
    
    -- Handle character removal
    player.CharacterRemoving:Connect(function()
        if espHighlights[player] then
            espHighlights[player]:Destroy()
            espHighlights[player] = nil
        end
        if tracerLines[player] then
            tracerLines[player].connection:Disconnect()
            tracerLines[player].line:Destroy()
            tracerLines[player] = nil
        end
    end)
end

-- FIXED KILL AURA
local function killAura()
    if not killAuraEnabled or not Character then return end
    
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = player.Character.HumanoidRootPart
            local distance = (HumanoidRootPart.Position - targetRoot.Position).Magnitude
            
            if distance <= killAuraRange then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid.Health = 0
                end
            end
        end
    end
end

-- FIXED KILL ALL with Teleport
local function killAll()
    local players = game:GetService("Players"):GetPlayers()
    local validPlayers = {}
    
    -- Collect valid targets
    for _, player in pairs(players) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("Humanoid") then
            table.insert(validPlayers, player)
        end
    end
    
    -- Teleport and kill each player
    for _, player in pairs(validPlayers) do
        local targetRoot = player.Character.HumanoidRootPart
        if targetRoot then
            -- Save current position
            local savedPosition = HumanoidRootPart.Position
            
            -- Teleport to player
            HumanoidRootPart.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 3, 0))
            wait(0.2)
            
            -- Kill player
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
            
            -- Wait a bit and return to original position
            wait(0.5)
            HumanoidRootPart.CFrame = CFrame.new(savedPosition)
            wait(0.5)
        end
    end
end

-- FIXED FLY with respawn support
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

local function toggleFly(state)
    if state ~= nil then
        flying = state
    else
        flying = not flying
    end
    
    if flying and HumanoidRootPart then
        createBodyVelocity()
        Humanoid.PlatformStand = true
        
        FlyToggle.Text = "FLY: ON"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        
        -- Flight loop
        local flightLoop
        flightLoop = game:GetService("RunService").Heartbeat:Connect(function()
            if not flying or not bodyVelocity or not bodyVelocity.Parent or not Character then
                flightLoop:Disconnect()
                return
            end
            local camera = workspace.CurrentCamera
            bodyVelocity.Velocity = camera.CFrame.LookVector * flySpeed
        end)
        
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        if Humanoid then
            Humanoid.PlatformStand = false
        end
        
        FlyToggle.Text = "FLY: OFF"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end

-- FIXED Movement functions with respawn support
local function toggleSpeedHack()
    speedHackEnabled = not speedHackEnabled
    
    if speedHackEnabled and Humanoid then
        Humanoid.WalkSpeed = walkSpeed
        SpeedToggle.Text = "SPEED HACK: ON"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        if Humanoid then
            Humanoid.WalkSpeed = 16
        end
        SpeedToggle.Text = "SPEED HACK: OFF"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end

local function toggleHighJump()
    highJumpEnabled = not highJumpEnabled
    
    if highJumpEnabled and Humanoid then
        Humanoid.JumpPower = jumpPower
        JumpToggle.Text = "HIGH JUMP: ON"
        JumpToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        if Humanoid then
            Humanoid.JumpPower = 50
        end
        JumpToggle.Text = "HIGH JUMP: OFF"
        JumpToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end

-- FIXED ESP Toggle
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
    TracersToggle.Text = "TRACERS: " .. (tracersEnabled and "ON" or "OFF")
    TracersToggle.BackgroundColor3 = tracersEnabled and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 60, 60)
    
    if espEnabled then
        updateESP()
    end
end

-- FIXED KILL AURA Toggle
local function toggleKillAura()
    killAuraEnabled = not killAuraEnabled
    
    if killAuraEnabled then
        KillAuraBtn.Text = "KILL AURA: ON"
        KillAuraBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        KillAuraCombatBtn.Text = "KILL AURA: ON"
        KillAuraCombatBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        
        killAuraConnection = game:GetService("RunService").Heartbeat:Connect(killAura)
    else
        KillAuraBtn.Text = "KILL AURA: OFF"
        KillAuraBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        KillAuraCombatBtn.Text = "KILL AURA: OFF"
        KillAuraCombatBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        
        if killAuraConnection then
            killAuraConnection:Disconnect()
        end
    end
end

-- TELEPORT FUNCTIONS
local function updatePlayerList()
    playerScroll:ClearAllChildren()
    
    local players = game:GetService("Players"):GetPlayers()
    for i, player in pairs(players) do
        if player ~= Player then
            local playerBtn = Instance.new("TextButton")
            playerBtn.Size = UDim2.new(1, -10, 0, 30)
            playerBtn.Position = UDim2.new(0, 5, 0, (i-1)*35)
            playerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            playerBtn.Text = player.Name
            playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerBtn.TextSize = 12
            playerBtn.Font = Enum.Font.Gotham
            playerBtn.Parent = playerScroll
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = playerBtn
            
            playerBtn.MouseButton1Click:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                end
            end)
        end
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

-- FIXED MINIMIZE (only hides background)
local function toggleMinimize()
    minimized = not minimized
    if minimized then
        -- Only hide the background, keep buttons visible
        MainWindow.BackgroundTransparency = 1
        MainWindow.BorderSizePixel = 0
        TitleBar.BackgroundTransparency = 1
        MinimizeButton.Text = "+"
    else
        MainWindow.BackgroundTransparency = 0
        MainWindow.BorderSizePixel = 2
        TitleBar.BackgroundTransparency = 0.3
        MinimizeButton.Text = "_"
    end
end

-- TAB SWITCHING
local function switchTab(tabName)
    currentTab = tabName
    
    -- Hide all tabs
    for name, frame in pairs(tabFrames) do
        frame.Visible = false
    end
    
    -- Show selected tab
    if tabFrames[tabName] then
        tabFrames[tabName].Visible = true
    end
    
    -- Update player list for TP tab
    if tabName == "TP" then
        updatePlayerList()
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
KillAllBtn.MouseButton1Click:Connect(killAll)
KillAuraBtn.MouseButton1Click:Connect(toggleKillAura)
KillAuraCombatBtn.MouseButton1Click:Connect(toggleKillAura)
FlyToggle.MouseButton1Click:Connect(toggleFly)
SpeedToggle.MouseButton1Click:Connect(toggleSpeedHack)
JumpToggle.MouseButton1Click:Connect(toggleHighJump)
ESPToggle.MouseButton1Click:Connect(toggleESP)
TracersToggle.MouseButton1Click:Connect(toggleTracers)

-- Slider controls
FlySlider.minus.MouseButton1Click:Connect(function()
    flySpeed = math.max(FlySlider.min, flySpeed - 10)
    FlySlider.value.Text = tostring(flySpeed)
    FlySlider.label.Text = "Fly Speed: " .. flySpeed
end)

FlySlider.plus.MouseButton1Click:Connect(function()
    flySpeed = math.min(FlySlider.max, flySpeed + 10)
    FlySlider.value.Text = tostring(flySpeed)
    FlySlider.label.Text = "Fly Speed: " .. flySpeed
end)

SpeedSlider.minus.MouseButton1Click:Connect(function()
    walkSpeed = math.max(SpeedSlider.min, walkSpeed - 5)
    SpeedSlider.value.Text = tostring(walkSpeed)
    SpeedSlider.label.Text = "Walk Speed: " .. walkSpeed
    if speedHackEnabled and Humanoid then
        Humanoid.WalkSpeed = walkSpeed
    end
end)

SpeedSlider.plus.MouseButton1Click:Connect(function()
    walkSpeed = math.min(SpeedSlider.max, walkSpeed + 5)
    SpeedSlider.value.Text = tostring(walkSpeed)
    SpeedSlider.label.Text = "Walk Speed: " .. walkSpeed
    if speedHackEnabled and Humanoid then
        Humanoid.WalkSpeed = walkSpeed
    end
end)

JumpSlider.minus.MouseButton1Click:Connect(function()
    jumpPower = math.max(JumpSlider.min, jumpPower - 10)
    JumpSlider.value.Text = tostring(jumpPower)
    JumpSlider.label.Text = "Jump Power: " .. jumpPower
    if highJumpEnabled and Humanoid then
        Humanoid.JumpPower = jumpPower
    end
end)

JumpSlider.plus.MouseButton1Click:Connect(function()
    jumpPower = math.min(JumpSlider.max, jumpPower + 10)
    JumpSlider.value.Text = tostring(jumpPower)
    JumpSlider.label.Text = "Jump Power: " .. jumpPower
    if highJumpEnabled and Humanoid then
        Humanoid.JumpPower = jumpPower
    end
end)

KillAuraRangeSlider.minus.MouseButton1Click:Connect(function()
    killAuraRange = math.max(KillAuraRangeSlider.min, killAuraRange - 5)
    KillAuraRangeSlider.value.Text = tostring(killAuraRange)
    KillAuraRangeSlider.label.Text = "Aura Range: " .. killAuraRange
end)

KillAuraRangeSlider.plus.MouseButton1Click:Connect(function()
    killAuraRange = math.min(KillAuraRangeSlider.max, killAuraRange + 5)
    KillAuraRangeSlider.value.Text = tostring(killAuraRange)
    KillAuraRangeSlider.label.Text = "Aura Range: " .. killAuraRange
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

-- Auto-update player list
game:GetService("Players").PlayerAdded:Connect(updatePlayerList)
game:GetService("Players").PlayerRemoving:Connect(updatePlayerList)

-- Notify user
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Advanced Menu v2.0 Loaded",
    Text = "All fixes applied! Horizontal layout.",
    Duration = 5
})
