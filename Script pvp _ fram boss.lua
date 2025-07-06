-- ✅ WOKINGLOG UI FULL (PvP + Fram Boss)
-- Bản quyền 👹 WOKINGLOG

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Giao diện chính
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "WOKINGLOG_UI"

-- Icon mở menu 👹
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 35, 0, 35)
toggleButton.Position = UDim2.new(0, 10, 0.5, -150)
toggleButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
toggleButton.Text = "👹"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 18

-- Main frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 400)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "WOKINGLOG UI 👹"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Nút X đóng
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14

-- Tabs + nội dung
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(0, 100, 1, -40)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -100, 1, -40)
contentFrame.Position = UDim2.new(0, 100, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local tabs = {}

local function createTab(name)
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = name

    local frame = Instance.new("Frame", contentFrame)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false

    btn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do tab.Frame.Visible = false end
        frame.Visible = true
    end)

    table.insert(tabs, {Button = btn, Frame = frame})
    return frame
end

local function addButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 35)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
end

-- 🔥 Fram Boss Tab
local framTab = createTab("Fram Boss")
addButton(framTab, "Bật Fram Boss", function()
    local npc
    local function getNearestNPC()
        local nearest, dist = nil, math.huge
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChildOfClass("Humanoid") and model ~= Character then
                local d = (HRP.Position - model.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = model
                end
            end
        end
        return nearest
    end

    npc = getNearestNPC()
    if not npc then warn("Không tìm thấy NPC") return end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5, 0, 1e5)
    bv.P = 1e5
    bv.Velocity = Vector3.zero
    bv.Parent = HRP

    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bg.P = 1e5
    bg.CFrame = HRP.CFrame
    bg.Parent = HRP

    local hpText = Instance.new("TextLabel", screenGui)
    hpText.Size = UDim2.new(0.3, 0, 0.03, 0)
    hpText.Position = UDim2.new(0.35, 0, 0.05, 0)
    hpText.TextColor3 = Color3.new(1,1,1)
    hpText.BackgroundTransparency = 1
    hpText.TextScaled = true

    local angle = 0
    RunService.RenderStepped:Connect(function()
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            angle += 0.03
            local target = npc.HumanoidRootPart.Position + Vector3.new(math.cos(angle)*23, 0, math.sin(angle)*23)
            local dir = (target - HRP.Position).Unit * 50
            bv.Velocity = Vector3.new(dir.X, 0, dir.Z)
            bg.CFrame = CFrame.new(HRP.Position, Vector3.new(npc.HumanoidRootPart.Position.X, HRP.Position.Y, npc.HumanoidRootPart.Position.Z))

            local hum = npc:FindFirstChildOfClass("Humanoid")
            if hum then
                hpText.Text = string.format("👹 %s | HP: %.0f / %.0f", npc.Name, hum.Health, hum.MaxHealth)
            end
        end
    end)

    task.spawn(function()
        while true do
            if Humanoid and Humanoid.Health > 0 then
                Humanoid.Jump = true
                local tool = Character:FindFirstChildOfClass("Tool")
                if tool then pcall(function() tool:Activate() end) end
            end
            task.wait(1.5)
        end
    end)
end)

-- ⚔️ PvP Tab
local pvpTab = createTab("PvP")

addButton(pvpTab, "Đánh nhanh", function()
    task.spawn(function()
        while true do
            local tool = Character:FindFirstChildOfClass("Tool")
            if tool then
                for _ = 1, 8 do
                    pcall(function() tool:Activate() end)
                end
            end
            task.wait(0.1)
        end
    end)
end)

addButton(pvpTab, "Tự đánh khi cầm vũ khí", function()
    task.spawn(function()
        while true do
            local tool = Character:FindFirstChildOfClass("Tool")
            if tool then pcall(function() tool:Activate() end) end
            task.wait(0.4)
        end
    end)
end)

addButton(pvpTab, "Tự gửi /report", function()
    StarterGui:SetCore("ChatMakeSystemMessage", { Text = "/report"; Color = Color3.fromRGB(255,255,0); })
end)

addButton(pvpTab, "Thoát Game", function()
    LocalPlayer:Kick("WOKINGLOG: Auto logout")
end)

addButton(pvpTab, "Hiện Hitbox vũ khí", function()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        local part = tool:FindFirstChildWhichIsA("BasePart")
        if part then
            local box = Instance.new("SelectionBox", part)
            box.Adornee = part
            box.LineThickness = 0.05
            box.SurfaceTransparency = 0.4
            box.Color3 = Color3.fromRGB(255, 0, 0)
        end
    end
end)

-- Mở menu
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Mở tab Fram Boss mặc định
tabs[1].Frame.Visible = true
