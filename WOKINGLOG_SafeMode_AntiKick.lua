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

-- // GUI chính
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AutoBossUI"

-- // Nút mở menu
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
Frame.Size = UDim2.new(0, 240, 0, 230)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.1
Frame.Visible = false
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", Frame)
title.Text = "👹 MENU AUTO BOSS 👹"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18

-- // Nút chức năng
local ToggleAutoAttack = Instance.new("TextButton", Frame)
ToggleAutoAttack.Text = "⚔️ Tự đánh khi cầm vũ khí"
ToggleAutoAttack.Size = UDim2.new(1, -20, 0, 30)
ToggleAutoAttack.Position = UDim2.new(0, 10, 0, 40)
ToggleAutoAttack.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ToggleAutoAttack.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAutoAttack.Font = Enum.Font.Gotham
ToggleAutoAttack.TextSize = 14

local ToggleFollowBoss = Instance.new("TextButton", Frame)
ToggleFollowBoss.Text = "🚀 Tới gần Human Boss"
ToggleFollowBoss.Size = UDim2.new(1, -20, 0, 30)
ToggleFollowBoss.Position = UDim2.new(0, 10, 0, 80)
ToggleFollowBoss.BackgroundColor3 = Color3.fromRGB(70, 50, 90)
ToggleFollowBoss.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFollowBoss.Font = Enum.Font.Gotham
ToggleFollowBoss.TextSize = 14

local ToggleShowHP = Instance.new("TextButton", Frame)
ToggleShowHP.Text = "❤️ Hiển thị máu Boss"
ToggleShowHP.Size = UDim2.new(1, -20, 0, 30)
ToggleShowHP.Position = UDim2.new(0, 10, 0, 120)
ToggleShowHP.BackgroundColor3 = Color3.fromRGB(90, 60, 80)
ToggleShowHP.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleShowHP.Font = Enum.Font.Gotham
ToggleShowHP.TextSize = 14

local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16

-- // Góc hiển thị máu
local BossHPLabel = Instance.new("TextLabel", ScreenGui)
BossHPLabel.Size = UDim2.new(0, 240, 0, 30)
BossHPLabel.Position = UDim2.new(1, -260, 0, 10)
BossHPLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BossHPLabel.BackgroundTransparency = 0.4
BossHPLabel.TextColor3 = Color3.new(1, 0, 0)
BossHPLabel.TextScaled = true
BossHPLabel.Font = Enum.Font.GothamBold
BossHPLabel.Text = ""
BossHPLabel.Visible = false

-- // Biến điều khiển
local attacking = false
local followBoss = false
local showHP = false
local bossTarget = nil

-- // Tìm Human Boss gần
local function getNearestBoss(radius)
	local closest, dist = nil, radius
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj ~= Character then
			local d = (HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
			if d < dist then
				closest = obj
				dist = d
			end
		end
	end
	return closest
end

-- // Auto attack
coroutine.wrap(function()
	while true do wait(0.2)
		if attacking then
			local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
			if tool then pcall(function() tool:Activate() end) end
		end
	end
end)()

-- // Theo dõi & cập nhật liên tục
RunService.RenderStepped:Connect(function()
	if followBoss then
		bossTarget = getNearestBoss(100)
		if bossTarget and bossTarget:FindFirstChild("HumanoidRootPart") then
			HumanoidRootPart.CFrame = bossTarget.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
		end
	end

	if showHP then
		bossTarget = getNearestBoss(100)
		if bossTarget and bossTarget:FindFirstChild("Humanoid") then
			local hp = math.floor(bossTarget.Humanoid.Health)
			local maxHp = math.floor(bossTarget.Humanoid.MaxHealth)
			BossHPLabel.Text = "👹 Boss HP: " .. hp .. " / " .. maxHp
			BossHPLabel.Visible = true
		else
			BossHPLabel.Text = "Không thấy Boss"
			BossHPLabel.Visible = true
		end
	else
		BossHPLabel.Visible = false
	end
end)

-- // Nút
ToggleAutoAttack.MouseButton1Click:Connect(function()
	attacking = not attacking
	ToggleAutoAttack.Text = attacking and "⚔️ Đang tự đánh..." or "⚔️ Tự đánh khi cầm vũ khí"
end)

ToggleFollowBoss.MouseButton1Click:Connect(function()
	followBoss = not followBoss
	ToggleFollowBoss.Text = followBoss and "🚀 Đang tới gần Boss..." or "🚀 Tới gần Human Boss"
end)

ToggleShowHP.MouseButton1Click:Connect(function()
	showHP = not showHP
	ToggleShowHP.Text = showHP and "❤️ Đang hiển thị máu Boss" or "❤️ Hiển thị máu Boss"
end)

CloseBtn.MouseButton1Click:Connect(function()
	Frame.Visible = false
end)

OpenBtn.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)
