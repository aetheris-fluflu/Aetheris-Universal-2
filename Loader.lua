-- Variables
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local gui = Instance.new("ScreenGui", player.PlayerGui)
local mainFrame = Instance.new("Frame", gui)
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
local minimizeButton = Instance.new("ImageButton", gui)  -- Minimize button is now outside the mainFrame
local roundCorner = Instance.new("UICorner")
local flyEnabled = false
local noclipEnabled = false
local espEnabled = false
local speedHackEnabled = false
local jumpPowerEnabled = false
local infiniteJumpEnabled = false
local customSpeed = 50 -- Default speed value
local customJumpPower = 100 -- Default jump power value
local highlights = {} -- Store highlights for ESP cleanup

-- GUI Setup
gui.Name = "CustomGUI"
gui.ResetOnSpawn = false

mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Active = true
mainFrame.Draggable = true  -- Make the frame draggable
roundCorner.CornerRadius = UDim.new(0, 12)
roundCorner.Parent = mainFrame

scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.ScrollBarThickness = 8
roundCorner:Clone().Parent = scrollFrame

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Aetheris Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.TextAlignment = Enum.TextAlignment.Center
title.Font = Enum.Font.SourceSansBold

-- Minimize Button (Outside Frame)
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(0.5, -15, 0, 10)  -- Positioning outside the frame at the top
minimizeButton.Image = "http://www.roblox.com/asset/?id=108802284870895"
minimizeButton.BackgroundTransparency = 1
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Round Elements Function
local function createRoundElement(className, parent, size, position, color)
    local element = Instance.new(className, parent)
    element.Size = size
    element.Position = position
    element.BackgroundColor3 = color
    roundCorner:Clone().Parent = element
    return element
end

-- Add Buttons and Features (All white text and standard color)
local features = {
    {name = "Fly", color = Color3.fromRGB(255, 255, 255)},
    {name = "Noclip", color = Color3.fromRGB(255, 255, 255)},
    {name = "ESP", color = Color3.fromRGB(255, 255, 255)},
    {name = "Speed Hack", color = Color3.fromRGB(255, 255, 255)},
    {name = "Jump Power", color = Color3.fromRGB(255, 255, 255)},
    {name = "Infinite Jump", color = Color3.fromRGB(255, 255, 255)}
}

local buttonHeight = 40
local padding = 10

for i, feature in ipairs(features) do
    local button = createRoundElement("TextButton", scrollFrame, UDim2.new(1, -20, 0, buttonHeight), UDim2.new(0, 10, 0, (buttonHeight + padding) * (i - 1)), feature.color)
    button.Text = feature.name
    button.TextColor3 = Color3.new(1, 1, 1)  -- Set white text color
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Keep the button background dark

    button.MouseButton1Click:Connect(function()
        if feature.name == "Fly" then
            flyEnabled = not flyEnabled
            button.Text = flyEnabled and "Fly ✔" or "Fly"
            button.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
        elseif feature.name == "Noclip" then
            noclipEnabled = not noclipEnabled
            button.Text = noclipEnabled and "Noclip ✔" or "Noclip"
            button.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
        elseif feature.name == "ESP" then
            espEnabled = not espEnabled
            button.Text = espEnabled and "ESP ✔" or "ESP"
            button.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
        elseif feature.name == "Speed Hack" then
            speedHackEnabled = not speedHackEnabled
            button.Text = speedHackEnabled and "Speed Hack ✔" or "Speed Hack"
            button.BackgroundColor3 = speedHackEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
        elseif feature.name == "Jump Power" then
            jumpPowerEnabled = not jumpPowerEnabled
            button.Text = jumpPowerEnabled and "Jump Power ✔" or "Jump Power"
            button.BackgroundColor3 = jumpPowerEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
        elseif feature.name == "Infinite Jump" then
            infiniteJumpEnabled = not infiniteJumpEnabled
            button.Text = infiniteJumpEnabled and "Infinite Jump ✔" or "Infinite Jump"
            button.BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
        end
    end)
end

-- Add TextBoxes for Custom Speed and Jump Power
local speedTextBox = createRoundElement("TextBox", scrollFrame, UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, (buttonHeight + padding) * #features + padding), Color3.fromRGB(50, 50, 50))
speedTextBox.PlaceholderText = "Enter Speed (Default: 50)"
speedTextBox.TextColor3 = Color3.new(1, 1, 1)
speedTextBox.Font = Enum.Font.SourceSans
speedTextBox.TextSize = 16
speedTextBox.FocusLost:Connect(function()
    local newSpeed = tonumber(speedTextBox.Text)
    if newSpeed and newSpeed > 0 then
        customSpeed = newSpeed
    else
        speedTextBox.Text = "Invalid Speed"
    end
end)

local jumpPowerTextBox = createRoundElement("TextBox", scrollFrame, UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, (buttonHeight + padding) * #features + padding + 40), Color3.fromRGB(50, 50, 50))
jumpPowerTextBox.PlaceholderText = "Enter Jump Power (Default: 100)"
jumpPowerTextBox.TextColor3 = Color3.new(1, 1, 1)
jumpPowerTextBox.Font = Enum.Font.SourceSans
jumpPowerTextBox.TextSize = 16
jumpPowerTextBox.FocusLost:Connect(function()
    local newJumpPower = tonumber(jumpPowerTextBox.Text)
    if newJumpPower and newJumpPower > 0 then
        customJumpPower = newJumpPower
    else
        jumpPowerTextBox.Text = "Invalid Jump Power"
    end
end)

-- Main Loop for Features
runService.RenderStepped:Connect(function()
    fly()
    noclip()
    esp()
    speedHack()
    jumpPower()
    infiniteJump()
end)

-- Fly Function
local function fly()
    if flyEnabled then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
            local bodyVelocity = player.Character:FindFirstChild("BodyVelocity")
            if not bodyVelocity then
                bodyVelocity = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
                bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            bodyVelocity.Velocity = Vector3.new(mouse.Hit.lookVector.X * customSpeed, 0, mouse.Hit.lookVector.Z * customSpeed)
        end
    else
        local bodyVelocity = player.Character:FindFirstChild("BodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end

-- Noclip Function
local function noclip()
    if noclipEnabled then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ESP Function
local function esp()
    if espEnabled then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character then
                local highlight = Instance.new("Highlight", plr.Character)
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                table.insert(highlights, highlight)
            end
        end
    end
end

-- Speed Hack Function
local function speedHack()
    if speedHackEnabled then
        player.Character.Humanoid.WalkSpeed = customSpeed
    else
        player.Character.Humanoid.WalkSpeed = 16
    end
end

-- Jump Power Function
local function jumpPower()
    if jumpPowerEnabled then
        player.Character.Humanoid.JumpPower = customJumpPower
    else
        player.Character.Humanoid.JumpPower = 50
    end
end

-- Infinite Jump Function
local function infiniteJump()
    if infiniteJumpEnabled then
        userInputService.JumpRequest:Connect(function()
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end
