-- 👹 WOKINGLOG - FULL GUI PVP TOOL 👹
-- BY WOKINGLOG | YOUTUBE: https://www.youtube.com/@binoscript1

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "WOKINGLOG_GUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.3, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(1, 0, 0)
frame.ClipsDescendants = true

spawn(function()
    while true do
        TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(math.random(10,40),0,math.random(10,40))}):Play()
        wait(0.4)
    end
end)

-- Icon hình ảnh 👹 bên trái logo
local iconImg = Instance.new("ImageLabel", frame)
iconImg.Size = UDim2.new(0, 25, 0, 25)
iconImg.Position = UDim2.new(0, 5, 0, 5)
iconImg.BackgroundTransparency = 1
iconImg.Image = "rbxassetid://12157258056" -- Icon 👹 WOKINGLOG

-- Logo chữ bên phải icon
local logo = Instance.new("TextLabel", frame)
logo.Size = UDim2.new(1, -40, 0, 30)
logo.Position = UDim2.new(0, 35, 0, 5)
logo.Text = "WOKINGLOG PVP MENU"
logo.TextColor3 = Color3.new(1,1,1)
logo.BackgroundTransparency = 1
logo.Font = Enum.Font.GothamBold
logo.TextSize = 18

-- YouTube Button (gọn gàng góc dưới phải menu)
local yt = Instance.new("ImageButton", frame)
yt.Size = UDim2.new(0, 25, 0, 25)
yt.Position = UDim2.new(1, -30, 1, -30)
yt.Image = "rbxassetid://12022282029"
yt.BackgroundTransparency = 1
yt.MouseButton1Click:Connect(function()
    setclipboard("https://www.youtube.com/@binoscript1")
    print("🔗 Đã sao chép link YouTube")
end)

-- Nút đóng menu ❌
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "❌"
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Tab Buttons
local tabs = {"⚙️ TỐI ƯU", "🎯 PVP", "📈 FPS"}
local tabFrames = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 120, 0, 25)
    btn.Position = UDim2.new(0, (i-1)*130+5, 0, 40)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)

    local tab = Instance.new("Frame", frame)
    tab.Size = UDim2.new(1, -10, 1, -80)
    tab.Position = UDim2.new(0, 5, 0, 70)
    tab.BackgroundTransparency = 1
    tab.Visible = (i == 1)
    tabFrames[name] = tab

    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(tabFrames) do v.Visible = false end
        tab.Visible = true
    end)
end

-- ⚙️ Tab TỐI ƯU
local optimizeTab = tabFrames["⚙️ TỐI ƯU"]
local btnFixLag = Instance.new("TextButton", optimizeTab)
btnFixLag.Size = UDim2.new(0, 200, 0, 30)
btnFixLag.Position = UDim2.new(0, 10, 0, 10)
btnFixLag.Text = "🧹 FIX LAG (TỐI ƯU FPS)"
btnFixLag.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
btnFixLag.TextColor3 = Color3.new(1,1,1)
btnFixLag.Font = Enum.Font.Gotham
btnFixLag.TextSize = 14
btnFixLag.MouseButton1Click:Connect(function()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 0
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
            if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
        end
    end)
    print("✅ Đã bật FIX LAG")
end)

-- 🎯 Tab PVP
local pvpTab = tabFrames["🎯 PVP"]
local hitbox = Instance.new("TextButton", pvpTab)
hitbox.Size = UDim2.new(0, 200, 0, 30)
hitbox.Position = UDim2.new(0, 10, 0, 10)
hitbox.Text = "📦 Tăng HITBOX"
hitbox.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
hitbox.TextColor3 = Color3.new(1,1,1)
hitbox.Font = Enum.Font.Gotham
hitbox.TextSize = 14
hitbox.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            tool.Handle.Size = Vector3.new(5,5,5)
        end
    end
end)

local speed = Instance.new("TextButton", pvpTab)
speed.Size = UDim2.new(0, 200, 0, 30)
speed.Position = UDim2.new(0, 10, 0, 50)
speed.Text = "⚡ Speed Frame"
speed.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
speed.TextColor3 = Color3.new(1,1,1)
speed.Font = Enum.Font.Gotham
speed.TextSize = 14
speed.MouseButton1Click:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 100 end
end)

local spin = Instance.new("TextButton", pvpTab)
spin.Size = UDim2.new(0, 200, 0, 30)
spin.Position = UDim2.new(0, 10, 0, 90)
spin.Text = "🔄 Quay Nhân Vật"
spin.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
spin.TextColor3 = Color3.new(1,1,1)
spin.Font = Enum.Font.Gotham
spin.TextSize = 14
local spinning = false
spin.MouseButton1Click:Connect(function()
    spinning = not spinning
end)
RunService.RenderStepped:Connect(function()
    if spinning and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(5), 0)
    end
end)

-- 📈 Tab FPS
local fpsTab = tabFrames["📈 FPS"]
local fpsLabel = Instance.new("TextLabel", fpsTab)
fpsLabel.Size = UDim2.new(0, 300, 0, 30)
fpsLabel.Position = UDim2.new(0, 10, 0, 10)
fpsLabel.Text = "FPS: ..."
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.Font = Enum.Font.Code
fpsLabel.TextSize = 14
fpsLabel.BackgroundTransparency = 1

local last = tick()
local frames = 0
RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - last >= 1 then
        fpsLabel.Text = "FPS: " .. frames
        frames = 0
        last = tick()
    end
end)

-- Kéo GUI
local dragToggle, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
RunService.Heartbeat:Connect(function()
    if dragToggle and dragInput then
        local delta = dragInput.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
