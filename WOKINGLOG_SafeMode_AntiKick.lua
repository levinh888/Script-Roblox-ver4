local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "WOKINGLOG_SAFE"

-- Icon 👹 Button
local IconButton = Instance.new("TextButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0, 20, 1, -70)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Text = "👹"
IconButton.TextScaled = true
IconButton.Font = Enum.Font.GothamBlack
IconButton.TextColor3 = Color3.fromRGB(255, 0, 85)
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(0, 12)

-- Main GUI Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 300)
Frame.Position = UDim2.new(0.5, -120, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.3
Frame.Visible = false
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", Frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "👹 WOKINGLOG 👹"
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(255, 0, 85)
title.TextStrokeTransparency = 0.5
title.TextScaled = true

local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "✖"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextScaled = true
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 85)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local Container = Instance.new("Frame", Frame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", Container)
UIListLayout.Padding = UDim.new(0, 6)

local toggles = { teleport=false, autoAttack=false, aim=false, spin=false }
local targetBoss = nil

function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Text = "[OFF] " .. name
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255, 0, 85)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        btn.Text = (toggles[name] and "[ON] " or "[OFF] ") .. name
        callback(toggles[name])
    end)
end

function findBoss()
    for _, model in pairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model ~= LocalPlayer.Character then
            if model.Humanoid.Health > 0 then
                return model
            end
        end
    end
    return nil
end

local healthLabel = Instance.new("TextLabel", ScreenGui)
healthLabel.Size = UDim2.new(0, 200, 0, 30)
healthLabel.Position = UDim2.new(0.5, -100, 0, 20)
healthLabel.BackgroundTransparency = 1
healthLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
healthLabel.TextStrokeTransparency = 0.5
healthLabel.Font = Enum.Font.GothamBold
healthLabel.TextScaled = true
healthLabel.Text = "Máu Boss: Chưa phát hiện"

function pickupItemsAround(pos, radius)
    for _, v in pairs(Workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Part") or v:IsA("Model")) and v:IsDescendantOf(Workspace) then
            if v:FindFirstChild("TouchInterest") or v:IsA("Tool") then
                local p = v.Position or (v:IsA("Model") and v:GetModelCFrame().p)
                if p and (p - pos).Magnitude <= radius then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                    wait(0.5)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
                end
            end
        end
    end
end

spawn(function()
    while wait(1.5) do
        if targetBoss and targetBoss:FindFirstChild("Humanoid") then
            if targetBoss.Humanoid.Health <= 0 then
                wait(2)
                pickupItemsAround(targetBoss.HumanoidRootPart.Position, 15)
                targetBoss = nil
            end
        end
    end
end)

createToggle("teleport", function(state)
    if state then
        spawn(function()
            while toggles.teleport do
                local boss = findBoss()
                if boss then
                    targetBoss = boss
                    LocalPlayer.Character:WaitForChild("Humanoid"):MoveTo(boss.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
                end
                wait(math.random(2, 3))
            end
        end)
    end
end)

createToggle("autoAttack", function(state)
    if state then
        spawn(function()
            while toggles.autoAttack do
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                wait(0.6)
            end
        end)
    end
end)

createToggle("aim", function(state)
    if state then
        spawn(function()
            while toggles.aim do
                if targetBoss and targetBoss:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local cf = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, targetBoss.HumanoidRootPart.Position)
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.Angles(0, cf.LookVector:Angle(Vector3.new(0, 0, -1)), 0)
                end
                wait(0.5)
            end
        end)
    end
end)

-- ✅ SPIN QUAY MƯỢT - BÁN KÍNH 23 - TỐC ĐỘ 50
createToggle("spin", function(state)
    if state then
        spawn(function()
            local angle = 0
            local speed = 50
            local radius = 23
            while toggles.spin do
                if targetBoss and targetBoss:FindFirstChild("HumanoidRootPart") then
                    angle = angle + math.rad(speed)
                    local x = math.cos(angle) * radius
                    local z = math.sin(angle) * radius
                    local pos = targetBoss.HumanoidRootPart.Position + Vector3.new(x, 3, z)
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(pos, targetBoss.HumanoidRootPart.Position)
                end
                wait(0.03)
            end
        end)
    end
end)

spawn(function()
    while wait(0.5) do
        if targetBoss and targetBoss:FindFirstChild("Humanoid") then
            healthLabel.Text = "Máu Boss: " .. math.floor(targetBoss.Humanoid.Health)
        else
            healthLabel.Text = "Máu Boss: Không phát hiện"
        end
    end
end)

IconButton.MouseButton1Click:Connect(function()
    Frame.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)
