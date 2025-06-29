-- // Cấu hình cơ bản
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- // Tạo GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AutoCombatUI"

-- // Nút mở
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 100, 0, 30)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -100)
OpenBtn.Text = "🛠 Mở MENU"
OpenBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = Enum.Font.Gotham
OpenBtn.TextSize = 14

-- // Khung menu
local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.7, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 220, 0, 240)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.1
Frame.Visible = false
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", Frame)
title.Text = "✨ MENU AUTO ✨"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 20

-- Các nút
local ToggleAutoAttack = Instance.new("TextButton", Frame)
ToggleAutoAttack.Text = "Tự đánh khi cầm vũ khí"
ToggleAutoAttack.Size = UDim2.new(1, -20, 0, 30)
ToggleAutoAttack.Position = UDim2.new(0, 10, 0, 40)
ToggleAutoAttack.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ToggleAutoAttack.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAutoAttack.Font = Enum.Font.Gotham
ToggleAutoAttack.TextSize = 14

local ToggleBossAttack = Instance.new("TextButton", Frame)
ToggleBossAttack.Text = "Quay quanh Human Boss"
ToggleBossAttack.Size = UDim2.new(1, -20, 0, 30)
ToggleBossAttack.Position = UDim2.new(0, 10, 0, 80)
ToggleBossAttack.BackgroundColor3 = Color3.fromRGB(70, 50, 80)
ToggleBossAttack.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBossAttack.Font = Enum.Font.Gotham
ToggleBossAttack.TextSize = 14

local ToggleShowHP = Instance.new("TextButton", Frame)
ToggleShowHP.Text = "Hiển thị máu Human"
ToggleShowHP.Size = UDim2.new(1, -20, 0, 30)
ToggleShowHP.Position = UDim2.new(0, 10, 0, 120)
ToggleShowHP.BackgroundColor3 = Color3.fromRGB(90, 70, 80)
ToggleShowHP.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleShowHP.Font = Enum.Font.Gotham
ToggleShowHP.TextSize = 14

local AutoTPButton = Instance.new("TextButton", Frame)
AutoTPButton.Text = "Dịch chuyển tới Human gần"
AutoTPButton.Size = UDim2.new(1, -20, 0, 30)
AutoTPButton.Position = UDim2.new(0, 10, 0, 160)
AutoTPButton.BackgroundColor3 = Color3.fromRGB(100, 60, 80)
AutoTPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoTPButton.Font = Enum.Font.Gotham
AutoTPButton.TextSize = 14

local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16

-- Hiển thị máu góc
local HumanHealthLabel = Instance.new("TextLabel", ScreenGui)
HumanHealthLabel.Size = UDim2.new(0, 200, 0, 30)
HumanHealthLabel.Position = UDim2.new(0, 10, 0, 10)
HumanHealthLabel.BackgroundTransparency = 0.3
HumanHealthLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HumanHealthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
HumanHealthLabel.Font = Enum.Font.GothamBold
HumanHealthLabel.TextSize = 14
HumanHealthLabel.Visible = false

-- // Biến điều khiển
local rotating = false
local attacking = false
local showHP = false
local autoTP = false
local bossTarget = nil
local humanTarget = nil

-- // Tìm Human gần
local function getNearestBoss(radius)
	local closest, distance = nil, radius
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj ~= Character then
			local dist = (HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
			if dist < distance then
				closest = obj
				distance = dist
			end
		end
	end
	return closest
end

-- // Quay quanh boss
local speed = 70
local radius = 23

RunService.RenderStepped:Connect(function()
	if rotating and bossTarget and bossTarget:FindFirstChild("HumanoidRootPart") then
		local npcPos = bossTarget.HumanoidRootPart.Position
		local time = tick() * speed
		local x = math.cos(time) * radius
		local z = math.sin(time) * radius
		local targetPos = npcPos + Vector3.new(x, 0, z)
		HumanoidRootPart.CFrame = CFrame.new(targetPos, npcPos)
	end

	if autoTP then
		humanTarget = getNearestBoss(100)
		if humanTarget and humanTarget:FindFirstChild("HumanoidRootPart") then
			HumanoidRootPart.CFrame = humanTarget.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
		end
	end

	if showHP then
		humanTarget = getNearestBoss(100)
		if humanTarget and humanTarget:FindFirstChild("Humanoid") then
			local hp = humanTarget.Humanoid.Health
			local maxHp = humanTarget.Humanoid.MaxHealth
			HumanHealthLabel.Text = string.format("💓 Human HP: %d / %d", hp, maxHp)
			HumanHealthLabel.Visible = true
		else
			HumanHealthLabel.Text = "Không thấy Human"
		end
	else
		HumanHealthLabel.Visible = false
	end
end)

-- // Auto attack tool
coroutine.wrap(function()
	while true do
		wait(0.2)
		if attacking then
			local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
			if tool then
				pcall(function()
					tool:Activate()
				end)
			end
		end
	end
end)()

-- // Bật quay quanh boss
ToggleBossAttack.MouseButton1Click:Connect(function()
	rotating = not rotating
	if rotating then
		bossTarget = getNearestBoss(100)
		if bossTarget then
			ToggleBossAttack.Text = "Đang quay quanh Boss..."
		else
			ToggleBossAttack.Text = "Không tìm thấy Boss"
			rotating = false
		end
	else
		ToggleBossAttack.Text = "Quay quanh Human Boss"
		bossTarget = nil
	end
end)

-- // Bật tự đánh
ToggleAutoAttack.MouseButton1Click:Connect(function()
	attacking = not attacking
	ToggleAutoAttack.Text = attacking and "Đang tự đánh..." or "Tự đánh khi cầm vũ khí"
end)

-- // Bật hiển thị máu
ToggleShowHP.MouseButton1Click:Connect(function()
	showHP = not showHP
	ToggleShowHP.Text = showHP and "Đang hiển thị máu Human" or "Hiển thị máu Human"
end)

-- // Dịch chuyển tới Human
AutoTPButton.MouseButton1Click:Connect(function()
	autoTP = not autoTP
	AutoTPButton.Text = autoTP and "Đang dịch chuyển..." or "Dịch chuyển tới Human gần"
end)

-- // Đóng/mở menu
CloseBtn.MouseButton1Click:Connect(function()
	Frame.Visible = false
end)

OpenBtn.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)
