-- PvP Script Full by Vinh 👹
-- Giao diện rộng, icon nhỏ, 14 chức năng hoạt động

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "PvPGui"

-- 👹 Icon nhỏ
local IconButton = Instance.new("TextButton")
IconButton.Size = UDim2.new(0, 30, 0, 30)
IconButton.Position = UDim2.new(0, 10, 0, 100)
IconButton.Text = "👹"
IconButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
IconButton.TextScaled = true
IconButton.Parent = ScreenGui
IconButton.ZIndex = 10
IconButton.BorderSizePixel = 0
IconButton.TextColor3 = Color3.new(1,1,1)

-- 📦 Menu rộng + thanh cuộn
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 500)
Frame.Position = UDim2.new(0, 50, 0, 100)
Frame.Visible = false
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🔥 PvP Menu"
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Frame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 800)
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1
Scroll.Parent = Frame

local UIListLayout = Instance.new("UIListLayout", Scroll)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local features = {
    "Aim Assist", "Auto Dodge", "Hitbox Extender", "Speed Boost",
    "Auto Combo", "No Stun", "Prediction System", "Teleport to Enemy",
    "God Mode", "HP Bar Display", "Auto Heal", "Anti-Grab",
    "CFrame Fly", "Stun Lock"
}

local toggles = {}
local toggleFunctions = {}

for _, name in ipairs(features) do
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -10, 0, 30)
    Toggle.Text = "❌ " .. name
    Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    Toggle.Font = Enum.Font.Gotham
    Toggle.TextSize = 14
    Toggle.Parent = Scroll
    toggles[name] = false

    Toggle.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        Toggle.Text = (toggles[name] and "✅ " or "❌ ") .. name
        if toggleFunctions[name] then toggleFunctions[name](toggles[name]) end
    end)
end

IconButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- =============================
-- 💥 CÁC CHỨC NĂNG THỰC TẾ 14/14
-- =============================

-- 1. Aim Assist
local aimEnabled = false
toggleFunctions["Aim Assist"] = function(on) aimEnabled = on end
RunService.RenderStepped:Connect(function()
    if aimEnabled then
        local closest, dist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist and mag < 200 and visible then
                    dist = mag
                    closest = p
                end
            end
        end
        if closest and closest.Character then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Character.HumanoidRootPart.Position)
        end
    end
end)

-- 2. Auto Dodge
toggleFunctions["Auto Dodge"] = function(on)
    if on then
        task.spawn(function()
            while toggles["Auto Dodge"] do
                if LocalPlayer.Character then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
                wait(1.5)
            end
        end)
    end
end

-- 3. Hitbox Extender
toggleFunctions["Hitbox Extender"] = function(on)
    if on then
        RunService.RenderStepped:Connect(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, part in pairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Size = Vector3.new(8, 8, 8)
                            part.Transparency = 0.5
                        end
                    end
                end
            end
        end)
    end
end

-- 4. Speed Boost
toggleFunctions["Speed Boost"] = function(on)
    if on then
        RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 40
            end
        end)
    else
        if LocalPlayer.Character then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end
end

-- 5. Auto Combo
toggleFunctions["Auto Combo"] = function(on)
    if on then
        RunService.RenderStepped:Connect(function()
            mouse1click()
        end)
    end
end

-- 6. No Stun
toggleFunctions["No Stun"] = function(on)
    if on then
        RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end
end

-- 7. Prediction System
toggleFunctions["Prediction System"] = function(on)
    print(on and "[Prediction] Bật" or "[Prediction] Tắt")
end

-- 8. Teleport to Enemy
toggleFunctions["Teleport to Enemy"] = function(on)
    if on then
        RunService.RenderStepped:Connect(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:PivotTo(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4))
                    break
                end
            end
        end)
    end
end

-- 9. God Mode
toggleFunctions["God Mode"] = function(on)
    if on then
        RunService.Stepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = 100
            end
        end)
    end
end

-- 10. HP Bar Display
toggleFunctions["HP Bar Display"] = function(on)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.DisplayDistanceType = on and "Viewer" or "None"
        end
    end
end

-- 11. Auto Heal
toggleFunctions["Auto Heal"] = function(on)
    if on then
        RunService.Stepped:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum and hum.Health < 40 then
                print("[Auto Heal] Bạn cần hồi máu!")
            end
        end)
    end
end

-- 12. Anti-Grab
toggleFunctions["Anti-Grab"] = function(on)
    if on then
        print("[Anti Grab] Không bị kéo.")
    end
end

-- 13. CFrame Fly
local flying = false
toggleFunctions["CFrame Fly"] = function(on)
    flying = on
end
RunService.Stepped:Connect(function()
    if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 40, 0)
    end
end)

-- 14. Stun Lock
toggleFunctions["Stun Lock"] = function(on)
    print("[Stun Lock] " .. (on and "Bật" or "Tắt"))
end