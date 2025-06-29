-- // WOKINGLOG 👹 - Auto Boss Farm GUI FULL
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "WOKINGLOG_GUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 280)
Frame.Position = UDim2.new(0, 20, 0.5, -140)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.3
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 0, 85)
UIStroke.Transparency = 0.3

local Shadow = Instance.new("ImageLabel", Frame)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)

local title = Instance.new("TextLabel", Frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "👹 WOKINGLOG 👹"
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(255, 0, 85)
title.TextStrokeTransparency = 0.5
title.TextScaled = true

local Container = Instance.new("Frame", Frame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", Container)
UIListLayout.Padding = UDim.new(0, 6)

local toggles = {
    teleport = false,
    autoAttack = false,
    aim = false,
    spin = false
}

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

-- Find Boss
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

-- Health GUI
local healthLabel = Instance.new("TextLabel", ScreenGui)
healthLabel.Size = UDim2.new(0, 200, 0, 30)
healthLabel.Position = UDim2.new(0, 20, 0, 30)
healthLabel.BackgroundTransparency = 1
healthLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
healthLabel.TextStrokeTransparency = 0.5
healthLabel.Font = Enum.Font.GothamBold
healthLabel.TextScaled = true
healthLabel.Text = "Máu Boss: Chưa phát hiện"

-- Auto Pick Items
function pickupItemsAround(position, radius)
    for _, v in pairs(Workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Part") or v:IsA("Model")) and v:IsDescendantOf(Workspace) then
            if v:FindFirstChild("TouchInterest") or v:IsA("Tool") then
                local pos = v.Position or (v:IsA("Model") and v:GetModelCFrame().p)
                if pos and (pos - position).Magnitude <= radius then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                    wait()
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
                end
            end
        end
    end
end

-- Theo dõi boss chết và loot
spawn(function()
    while wait(0.5) do
        if targetBoss and targetBoss:FindFirstChild("Humanoid") then
            if targetBoss.Humanoid.Health <= 0 then
                wait(1)
                pickupItemsAround(targetBoss.HumanoidRootPart.Position, 15)
                targetBoss = nil
            end
        end
    end
end)

-- Nút: Teleport Boss
createToggle("teleport", function(state)
    if state then
        spawn(function()
            while toggles.teleport do
                local boss = findBoss()
                if boss then
                    targetBoss = boss
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
                wait(1)
            end
        end)
    end
end)

-- Auto Attack
createToggle("autoAttack", function(state)
    if state then
        spawn(function()
            while toggles.autoAttack do
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
                wait(0.25)
            end
        end)
    end
end)

-- Aim Boss
createToggle("aim", function(state)
    if state then
        spawn(function()
            while toggles.aim do
                if targetBoss and targetBoss:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local cf = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, targetBoss.HumanoidRootPart.Position)
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.Angles(0, cf.LookVector:Angle(Vector3.new(0, 0, -1)), 0)
                end
                wait()
            end
        end)
    end
end)

-- Quay quanh boss
createToggle("spin", function(state)
    if state then
        spawn(function()
            local angle = 0
            while toggles.spin do
                if targetBoss and targetBoss:FindFirstChild("HumanoidRootPart") then
                    local radius = 23
                    angle = angle + math.rad(50)
                    local x = math.cos(angle) * radius
                    local z = math.sin(angle) * radius
                    local newPos = targetBoss.HumanoidRootPart.Position + Vector3.new(x, 3, z)
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(newPos, targetBoss.HumanoidRootPart.Position)
                end
                wait()
            end
        end)
    end
end)

-- Cập nhật máu boss
spawn(function()
    while wait(0.3) do
        if targetBoss and targetBoss:FindFirstChild("Humanoid") then
            healthLabel.Text = "Máu Boss: " .. math.floor(targetBoss.Humanoid.Health)
        else
            healthLabel.Text = "Máu Boss: Không phát hiện"
        end
    end
end)
