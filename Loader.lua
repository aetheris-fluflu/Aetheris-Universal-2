-- Variables
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local gui = Instance.new("ScreenGui", player.PlayerGui)
local mainFrame = Instance.new("Frame", gui)
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
local minimizeButton = Instance.new("ImageButton", mainFrame)
local roundCorner = Instance.new("UICorner")
local flyEnabled = false
local noclipEnabled = false
local espEnabled = false
local speedHackEnabled = false
local jumpPowerEnabled = false
local infiniteJumpEnabled = false
local customSpeed = 50 -- Default speed value
local customJumpPower = 100 -- Default jump power value

-- GUI Setup
gui.Name = "CustomGUI"
gui.ResetOnSpawn = false

mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Active = true
mainFrame.Draggable = true
roundCorner.CornerRadius = UDim.new(0, 12)
roundCorner.Parent = mainFrame

scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.ScrollBarThickness = 8
roundCorner:Clone().Parent = scrollFrame

minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -40, 0, 10)
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

-- Add Buttons and Features
local features = {
    {name = "Fly", color = Color3.fromRGB(0, 170, 255)},
    {name = "Noclip", color = Color3.fromRGB(255, 85, 0)},
    {name = "ESP", color = Color3.fromRGB(255, 0, 0)},
    {name = "Speed Hack", color = Color3.fromRGB(0, 255, 0)},
    {name = "Jump Power", color = Color3.fromRGB(255, 255, 0)},
    {name = "Infinite Jump", color = Color3.fromRGB(255, 0, 255)}
}

local buttonHeight = 40
local padding = 10

for i, feature in ipairs(features) do
    local button = createRoundElement("TextButton", scrollFrame, UDim2.new(1, -20, 0, buttonHeight), UDim2.new(0, 10, 0, (buttonHeight + padding) * (i - 1)), feature.color)
    button.Text = feature.name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18

    button.MouseButton1Click:Connect(function()
        if feature.name == "Fly" then
            flyEnabled = not flyEnabled
            button.Text = flyEnabled and "Fly ✔" or "Fly"
            button.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 255, 0) or feature.color
        elseif feature.name == "Noclip" then
            noclipEnabled = not noclipEnabled
            button.Text = noclipEnabled and "Noclip ✔" or "Noclip"
            button.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 255, 0) or feature.color
        elseif feature.name == "ESP" then
            espEnabled = not espEnabled
            button.Text = espEnabled and "ESP ✔" or "ESP"
            button.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 0) or feature.color
        elseif feature.name == "Speed Hack" then
            speedHackEnabled = not speedHackEnabled
            button.Text = speedHackEnabled and "Speed Hack ✔" or "Speed Hack"
            button.BackgroundColor3 = speedHackEnabled and Color3.fromRGB(0, 255, 0) or feature.color
        elseif feature.name == "Jump Power" then
            jumpPowerEnabled = not jumpPowerEnabled
            button.Text = jumpPowerEnabled and "Jump Power ✔" or "Jump Power"
            button.BackgroundColor3 = jumpPowerEnabled and Color3.fromRGB(0, 255, 0) or feature.color
        elseif feature.name == "Infinite Jump" then
            infiniteJumpEnabled = not infiniteJumpEnabled
            button.Text = infiniteJumpEnabled and "Infinite Jump ✔" or "Infinite Jump"
            button.BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(0, 255, 0) or feature.color
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

-- Fly Function
local function fly()
    if flyEnabled then
        local bodyVelocity = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.Velocity = Vector3.new(mouse.Hit.lookVector.X * 50, 0, mouse.Hit.lookVector.Z * 50)
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
    end
end

-- ESP Function
local function esp()
    if espEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local highlight = Instance.new("Highlight", player.Character)
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(1, 1, 1)
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

-- Main Loop
runService.RenderStepped:Connect(function()
    fly()
    noclip()
    esp()
    speedHack()
    jumpPower()
    infiniteJump()
end)
