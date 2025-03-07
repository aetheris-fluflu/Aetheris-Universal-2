local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local mainFrame = Instance.new("Frame")
local minimizeButton = Instance.new("TextButton")
local button1 = Instance.new("TextButton")  -- Fly button
local button2 = Instance.new("TextButton")  -- Noclip button
local button3 = Instance.new("TextButton")  -- ESP button
local titleLabel = Instance.new("TextLabel")
local clockLabel = Instance.new("TextLabel")

-- Fly Variables
local flying = false
local flySpeed = 50
local flyBodyVelocity
local bodyGyro

-- Noclip Variables
local noclip = false

-- ESP Variables
local espEnabled = false

-- UI Styling
screenGui.Name = "AetherisHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 100, 0, 100)
minimizeButton.Position = UDim2.new(0, 10, 0, 10)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 36
minimizeButton.Parent = screenGui

titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 400, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Aetheris Hub"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
titleLabel.TextSize = 24
titleLabel.TextAlign = Enum.TextAnchor.MiddleCenter
titleLabel.Parent = mainFrame

clockLabel.Name = "ClockLabel"
clockLabel.Size = UDim2.new(0, 200, 0, 30)
clockLabel.Position = UDim2.new(0, 0, 1, -30)
clockLabel.BackgroundTransparency = 1
clockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
clockLabel.TextSize = 18
clockLabel.Text = ""
clockLabel.Parent = mainFrame

button1.Name = "Button1"  -- Fly Button
button1.Size = UDim2.new(0, 100, 0, 50)
button1.Position = UDim2.new(0, 10, 0, 40)
button1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button1.Text = "Fly Off"
button1.TextColor3 = Color3.fromRGB(255, 255, 255)
button1.TextSize = 18
button1.Parent = mainFrame

button2.Name = "Button2"  -- Noclip Button
button2.Size = UDim2.new(0, 100, 0, 50)
button2.Position = UDim2.new(0, 120, 0, 40)
button2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button2.Text = "Noclip Off"
button2.TextColor3 = Color3.fromRGB(255, 255, 255)
button2.TextSize = 18
button2.Parent = mainFrame

button3.Name = "Button3"  -- ESP Button
button3.Size = UDim2.new(0, 100, 0, 50)
button3.Position = UDim2.new(0, 230, 0, 40)
button3.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button3.Text = "ESP Off"
button3.TextColor3 = Color3.fromRGB(255, 255, 255)
button3.TextSize = 18
button3.Parent = mainFrame

-- Function to update clock
local function updateClock()
    local time = os.date("%I:%M:%S %p")
    clockLabel.Text = "Clock: " .. time
end

-- Toggle button colors and states
local function toggleButtonColor(button, action)
    if action == "on" then
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        button.Text = button.Name .. " On"
    else
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        button.Text = button.Name .. " Off"
    end
end

-- Fly Function
local function startFlying()
    flying = true
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = player.Character.HumanoidRootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.CFrame = player.Character.HumanoidRootPart.CFrame
    bodyGyro.Parent = player.Character.HumanoidRootPart

    player.Character.Humanoid.PlatformStand = true
end

local function stopFlying()
    flying = false
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
    end
    if bodyGyro then
        bodyGyro:Destroy()
    end
    player.Character.Humanoid.PlatformStand = false
end

-- Noclip Function
local function toggleNoclip()
    noclip = not noclip
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclip
        end
    end
end

-- ESP Function
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player then
                local espPart = Instance.new("Part")
                espPart.Size = Vector3.new(2, 2, 2)
                espPart.Anchored = true
                espPart.CanCollide = false
                espPart.BrickColor = BrickColor.new("Bright red")
                espPart.Material = Enum.Material.Neon
                espPart.Parent = game.Workspace

                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Parent = espPart
                billboardGui.Adornee = espPart
                billboardGui.Size = UDim2.new(0, 50, 0, 50)

                local textLabel = Instance.new("TextLabel")
                textLabel.Parent = billboardGui
                textLabel.Text = otherPlayer.Name
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.BackgroundTransparency = 1
            end
        end
    else
        for _, part in pairs(workspace:GetChildren()) do
            if part:FindFirstChild("ESP_Tag") then
                part:Destroy()
            end
        end
    end
end

-- Minimize/Restore the frame
local frameMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    if frameMinimized then
        mainFrame.Visible = true
        minimizeButton.Text = "-"
        frameMinimized = false
    else
        mainFrame.Visible = false
        minimizeButton.Text = "+"
        frameMinimized = true
    end
end)

-- Draggable frame and minimize button
local function makeDraggable(frame, button)
    local dragging, dragInput, mousePos, offset = false, nil, nil, nil

    local function update(input)
        local delta = input.Position - mousePos
        frame.Position = UDim2.new(frame.Position.X.Scale, offset.X + delta.X, frame.Position.Y.Scale, offset.Y + delta.Y)
    end

    local function inputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            offset = Vector2.new(frame.Position.X.Offset, frame.Position.Y.Offset)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end

    local function inputChanged(input)
        if dragging then
            update(input)
        end
    end

    button.InputBegan:Connect(inputBegan)
    button.InputChanged:Connect(inputChanged)
    frame.InputBegan:Connect(inputBegan)
    frame.InputChanged:Connect(inputChanged)
end

makeDraggable(mainFrame, minimizeButton)

-- Button functionality for Fly, Noclip, and ESP
button1.MouseButton1Click:Connect(function()
    if flying then
        stopFlying()
        toggleButtonColor(button1, "off")
    else
        startFlying()
        toggleButtonColor(button1, "on")
    end
end)

button2.MouseButton1Click:Connect(function()
    toggleNoclip()
    toggleButtonColor(button2, noclip and "on" or "off")
end)

button3.MouseButton1Click:Connect(function()
    toggleESP()
    toggleButtonColor(button3, espEnabled and "on" or "off")
end)

-- Update the clock every second
while true do
    updateClock()
    wait(1)
end
