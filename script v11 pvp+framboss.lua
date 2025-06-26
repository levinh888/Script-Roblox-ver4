-- WOKINGLOG HUB V11 – Full Hoàn Chỉnh + Tự Đánh Khi Cầm Vũ Khí

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- ImpactUI
local ImpactUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/NeverJar/ImpactUI/main/ImpactUI.lua"))()
local Window = ImpactUI:Create("👹 WOKINGLOG HUB", "by WOKINGLOG")

-- Tabs
local Main = Window:Tab("⚙ Main", true)
local Combat = Window:Tab("🗡 Combat")
local Visual = Window:Tab("🎨 Visual")
local Aimbot = Window:Tab("🎯 Aimbot")

-- Main Tab
Main:Label("👤 Người chơi: " .. Player.Name)
Main:Label("🆔 ID: " .. Player.UserId)

-- Combat Tab
local speedAnimation = false
Combat:Toggle("⚡ Speed Tay (Tăng Animation)", function(v)
    speedAnimation = v
end)

RunService.Heartbeat:Connect(function()
    if speedAnimation and Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildWhichIsA("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(100)
            end
        end
    end
end)

Combat:Button("🧠 Auto Equip Tool", function()
    local tool = Player.Backpack:FindFirstChildOfClass("Tool")
    if tool then tool.Parent = Player.Character end
end)

local hitboxReal = false
Combat:Toggle("📏 Hitbox THẬT (13,13,13)", function(v)
    hitboxReal = v
end)

RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local part = plr.Character.HumanoidRootPart
            if hitboxReal then
                part.Size = Vector3.new(13, 13, 13)
                part.Transparency = 0.85
                part.Material = Enum.Material.ForceField
                part.CanCollide = false
            else
                part.Size = Vector3.new(2, 2, 1)
                part.Transparency = 1
                part.Material = Enum.Material.Plastic
            end
        end
    end
end)

-- 🔁 Tự đánh khi cầm tool
local autoHitOnly = false
Combat:Toggle("🔁 Tự Đánh Khi Cầm Vũ Khí", function(v)
    autoHitOnly = v
end)

RunService.Heartbeat:Connect(function()
    if autoHitOnly and Player.Character then
        local tool = Player.Character:FindFirstChildOfClass("Tool")
        if tool then pcall(function() tool:Activate() end) end
    end
end)

-- 🔄 Auto Đánh + Quay quanh Boss + Góc camera
local autoAttack = false
Combat:Toggle("🔄 Auto Đánh + Quay Boss Sát", function(v)
    autoAttack = v
end)

RunService.Heartbeat:Connect(function()
    if autoAttack and Player.Character then
        local tool = Player.Character:FindFirstChildOfClass("Tool")
        if tool then pcall(function() tool:Activate() end) end
    end
end)

RunService.RenderStepped:Connect(function()
    if autoAttack and Player.Character then
        local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local closest, dist = nil, math.huge
        for _, npc in pairs(workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                local d = (npc.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < dist and d <= 23 then
                    closest = npc.HumanoidRootPart
                    dist = d
                end
            end
        end

        if closest then
            local offsetDir = (closest.Position - hrp.Position).Unit * 1.5
            hrp.CFrame = CFrame.new(closest.Position - offsetDir, closest.Position)

            workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            workspace.CurrentCamera.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 6, 12), closest.Position)
        end
    else
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end)

-- ❤️ Hiển thị máu NPC
local showHP = false
Combat:Toggle("❤️ Hiển thị máu NPC", function(v)
    showHP = v
end)

RunService.RenderStepped:Connect(function()
    if showHP then
        for _, npc in pairs(workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("Head") then
                local hum = npc.Humanoid
                if not npc.Head:FindFirstChild("HP_GUI") then
                    local bg = Instance.new("BillboardGui", npc.Head)
                    bg.Name = "HP_GUI"
                    bg.Size = UDim2.new(0, 100, 0, 20)
                    bg.StudsOffset = Vector3.new(0, 2.5, 0)
                    bg.AlwaysOnTop = true
                    local bar = Instance.new("Frame", bg)
                    bar.Size = UDim2.new(1, 0, 1, 0)
                    bar.BackgroundColor3 = Color3.new(1, 0, 0)
                    bar.Name = "Bar"
                    local txt = Instance.new("TextLabel", bg)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.new(1, 1, 1)
                    txt.Font = Enum.Font.GothamBold
                    txt.TextSize = 14
                    txt.Name = "HPText"
                end
                local gui = npc.Head:FindFirstChild("HP_GUI")
                local bar = gui.Bar
                local txt = gui.HPText
                local pct = hum.Health / hum.MaxHealth
                bar.Size = UDim2.new(pct, 0, 1, 0)
                txt.Text = math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth)
            end
        end
    else
        for _, npc in pairs(workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("Head") then
                local gui = npc.Head:FindFirstChild("HP_GUI")
                if gui then gui:Destroy() end
            end
        end
    end
end)

-- Visual
Visual:Button("🪫 Giảm 30% Đồ Hoạ", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 0.1
        end
    end
end)

-- Aimbot Tab
local aim = false
Aimbot:Toggle("🎯 Aim Nhẹ (Camera)", function(v)
    aim = v
end)

RunService.RenderStepped:Connect(function()
    if aim then
        local cam = workspace.CurrentCamera
        local closest, dist = nil, math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
                local pos, onScreen = cam:WorldToScreenPoint(plr.Character.Head.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < dist and mag < 150 then
                        closest = plr.Character.Head
                        dist = mag
                    end
                end
            end
        end
        if closest then
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, closest.Position), 0.1)
        end
    end
end)

-- 👹 ICON bật menu
local icon = Instance.new("ScreenGui")
local btn = Instance.new("TextButton")
icon.Name = "WOK_Icon"
icon.Parent = game.CoreGui
btn.Parent = icon
btn.Size = UDim2.new(0, 45, 0, 45)
btn.Position = UDim2.new(0, 10, 0.5, -20)
btn.Text = "👹"
btn.TextSize = 30
btn.Font = Enum.Font.GothamBold
btn.TextColor3 = Color3.fromRGB(255, 0, 0)
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
btn.BorderSizePixel = 0
btn.AutoButtonColor = true
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    ImpactUI:Toggle()
end)

print("✅ WOKINGLOG HUB V11 – Full Chức Năng + Tự Đánh Khi Cầm Tool + Camera Boss Fix")