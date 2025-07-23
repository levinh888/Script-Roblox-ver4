--// 👹 Script by Vinh | Bản quyền: WOKINGLOG 👹

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- SETTINGS
local BossName = "NPC2"
local Radius = 21.30
local Speed = 2.90

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "WOKINGLOG_GUI"

local openBtn = Instance.new("TextButton", gui)
openBtn.Text = "👹"
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0, 200)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.FredokaOne
openBtn.TextScaled = true
openBtn.ZIndex = 10

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0.5, -150, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(42, 163, 108)
frame.Visible = false
frame.Draggable = true
frame.Active = true

local title = Instance.new("TextLabel", frame)
title.Text = "👹 WOKINGLOG MENU 👹"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true

local btnRotate = Instance.new("TextButton", frame)
btnRotate.Text = "Quay Quanh NPC2"
btnRotate.Size = UDim2.new(1, -20, 0, 40)
btnRotate.Position = UDim2.new(0, 10, 0, 60)
btnRotate.BackgroundColor3 = Color3.fromRGB(0, 140, 90)
btnRotate.TextColor3 = Color3.fromRGB(255, 255, 255)
btnRotate.Font = Enum.Font.GothamBold
btnRotate.TextScaled = true

local btnAttack = Instance.new("TextButton", frame)
btnAttack.Text = "Tự Đánh Khi Cầm Vũ Khí"
btnAttack.Size = UDim2.new(1, -20, 0, 40)
btnAttack.Position = UDim2.new(0, 10, 0, 110)
btnAttack.BackgroundColor3 = Color3.fromRGB(0, 140, 90)
btnAttack.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAttack.Font = Enum.Font.GothamBold
btnAttack.TextScaled = true

local hpLabel = Instance.new("TextLabel", frame)
hpLabel.Text = "Máu Boss: Chưa xác định"
hpLabel.Size = UDim2.new(1, -20, 0, 40)
hpLabel.Position = UDim2.new(0, 10, 0, 160)
hpLabel.BackgroundColor3 = Color3.fromRGB(20, 100, 50)
hpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hpLabel.Font = Enum.Font.Gotham
hpLabel.TextScaled = true

-- TOGGLES
local rotating = false
local autoAttack = false
local angle = 0

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

btnRotate.MouseButton1Click:Connect(function()
	rotating = not rotating
	btnRotate.Text = rotating and "Đang quay quanh Boss" or "Quay Quanh NPC2"
end)

btnAttack.MouseButton1Click:Connect(function()
	autoAttack = not autoAttack
	btnAttack.Text = autoAttack and "Đang Tự Đánh" or "Tự Đánh Khi Cầm Vũ Khí"
end)

-- QUAY QUANH BOSS
RunService.RenderStepped:Connect(function(dt)
	if rotating then
		local boss = workspace:FindFirstChild(BossName)
		local char = LocalPlayer.Character
		if boss and char and char:FindFirstChild("HumanoidRootPart") then
			angle += dt * Speed
			local x = math.cos(angle) * Radius
			local z = math.sin(angle) * Radius
			char:MoveTo(boss.Position + Vector3.new(x, 0, z))
		end
	end
end)

-- TỰ ĐÁNH
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
			hpLabel.Text = "Máu Boss: " .. hp .. " / " .. maxHp
		else
			hpLabel.Text = "Máu Boss: Chưa xác định"
		end
	end
end)
