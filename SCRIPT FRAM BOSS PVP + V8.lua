--// 👹 Script Full Menu by Vinh | Bản quyền: WOKINGLOG 👹

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- SETTINGS
local BossName = "NPC2"
local Radius = 22.22
local Speed = 2.90

-- UI MENU
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "WOKINGLOG_GUI"

local OpenButton = Instance.new("TextButton", ScreenGui)
OpenButton.Text = "👹"
OpenButton.Size = UDim2.new(0, 40, 0, 40)
OpenButton.Position = UDim2.new(0, 10, 0, 200)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextScaled = true
OpenButton.Font = Enum.Font.FredokaOne
OpenButton.Name = "OpenBtn"
OpenButton.BackgroundTransparency = 0.1
OpenButton.ZIndex = 10

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 220)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(42, 163, 108)
MainFrame.Visible = false
MainFrame.Name = "MainUI"
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "👹 WOKINGLOG MENU 👹"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextScaled = true

local ToggleRotation = Instance.new("TextButton", MainFrame)
ToggleRotation.Text = "Quay Quanh NPC2"
ToggleRotation.Size = UDim2.new(1, -20, 0, 40)
ToggleRotation.Position = UDim2.new(0, 10, 0, 60)
ToggleRotation.BackgroundColor3 = Color3.fromRGB(0, 140, 90)
ToggleRotation.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleRotation.Font = Enum.Font.GothamBold
ToggleRotation.TextScaled = true

local ToggleAutoAttack = Instance.new("TextButton", MainFrame)
ToggleAutoAttack.Text = "Tự Đánh Khi Cầm Vũ Khí"
ToggleAutoAttack.Size = UDim2.new(1, -20, 0, 40)
ToggleAutoAttack.Position = UDim2.new(0, 10, 0, 110)
ToggleAutoAttack.BackgroundColor3 = Color3.fromRGB(0, 140, 90)
ToggleAutoAttack.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAutoAttack.Font = Enum.Font.GothamBold
ToggleAutoAttack.TextScaled = true

local BossHPLabel = Instance.new("TextLabel", MainFrame)
BossHPLabel.Text = "Máu Boss: Chưa xác định"
BossHPLabel.Size = UDim2.new(1, -20, 0, 40)
BossHPLabel.Position = UDim2.new(0, 10, 0, 160)
BossHPLabel.BackgroundColor3 = Color3.fromRGB(20, 100, 50)
BossHPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BossHPLabel.Font = Enum.Font.Gotham
BossHPLabel.TextScaled = true

-- TOGGLE LOGIC
local rotating = false
local autoAttack = false
local angle = 0

OpenButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

ToggleRotation.MouseButton1Click:Connect(function()
	rotating = not rotating
	ToggleRotation.Text = rotating and "Đang quay quanh Boss" or "Quay Quanh NPC2"
end)

ToggleAutoAttack.MouseButton1Click:Connect(function()
	autoAttack = not autoAttack
	ToggleAutoAttack.Text = autoAttack and "Đang Tự Đánh" or "Tự Đánh Khi Cầm Vũ Khí"
end)

-- AUTO ROTATE
RunService.RenderStepped:Connect(function(dt)
	if rotating then
		local boss = workspace:FindFirstChild(BossName)
		local character = LocalPlayer.Character
		if boss and character and character:FindFirstChild("HumanoidRootPart") then
			angle += dt * Speed
			local x = math.cos(angle) * Radius
			local z = math.sin(angle) * Radius
			character:MoveTo(boss.Position + Vector3.new(x, 0, z))
		end
	end
end)

-- AUTO ATTACK
task.spawn(function()
	while true do
		task.wait(0.3)
		if autoAttack then
			local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
			if tool then
				VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
				VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
			end
		end
	end
end)

-- HIỂN THỊ MÁU BOSS
task.spawn(function()
	while true do
		task.wait(0.5)
		local boss = workspace:FindFirstChild(BossName)
		if boss and boss:FindFirstChild("Humanoid") then
			local hp = math.floor(boss.Humanoid.Health)
			local maxHp = math.floor(boss.Humanoid.MaxHealth)
			BossHPLabel.Text = "Máu Boss: " .. hp .. "/" .. maxHp
		else
			BossHPLabel.Text = "Máu Boss: Chưa xác định"
		end
	end
end)
