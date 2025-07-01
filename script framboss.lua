--// Dịch vụ Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

--// Cấu hình quay quanh boss
local radius = 23
local speed = math.rad(50) -- 50 độ/giây
local angle = 0
local selectedBoss = nil

--// GUI đơn giản hiển thị
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AutoBossUI"
screenGui.ResetOnSpawn = false

--// Label máu Boss ở giữa
local bossHpLabelCenter = Instance.new("TextLabel", screenGui)
bossHpLabelCenter.Size = UDim2.new(0, 300, 0, 30)
bossHpLabelCenter.Position = UDim2.new(0.5, -150, 0, 30)
bossHpLabelCenter.BackgroundTransparency = 0.4
bossHpLabelCenter.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bossHpLabelCenter.TextColor3 = Color3.fromRGB(0, 255, 0)
bossHpLabelCenter.Font = Enum.Font.GothamBold
bossHpLabelCenter.TextSize = 20
bossHpLabelCenter.Text = "💥 Máu Boss: ???"
bossHpLabelCenter.BorderSizePixel = 0

--// Label máu Boss góc phải
local bossHpLabelCorner = Instance.new("TextLabel", screenGui)
bossHpLabelCorner.Size = UDim2.new(0, 250, 0, 30)
bossHpLabelCorner.Position = UDim2.new(1, -260, 0, 20)
bossHpLabelCorner.BackgroundTransparency = 0.4
bossHpLabelCorner.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
bossHpLabelCorner.TextColor3 = Color3.fromRGB(255, 50, 50)
bossHpLabelCorner.Font = Enum.Font.GothamBold
bossHpLabelCorner.TextSize = 18
bossHpLabelCorner.Text = "💔 Boss: Đang tìm gần nhất..."
bossHpLabelCorner.TextXAlignment = Enum.TextXAlignment.Right
bossHpLabelCorner.BorderSizePixel = 0

--// Hàm tìm boss gần nhất
local function getClosestBoss()
	local closest = nil
	local shortest = math.huge

	for _, model in pairs(workspace:GetDescendants()) do
		if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
			if model ~= Character then
				local distance = (HRP.Position - model.HumanoidRootPart.Position).Magnitude
				if distance < shortest then
					shortest = distance
					closest = model
				end
			end
		end
	end

	return closest
end

--// Cập nhật boss gần nhất mỗi vài giây
task.spawn(function()
	while true do
		selectedBoss = getClosestBoss()
		wait(2)
	end
end)

--// Vòng lặp chính: quay + attack + gim tâm
RunService.RenderStepped:Connect(function(dt)
	if selectedBoss and selectedBoss:FindFirstChild("HumanoidRootPart") and selectedBoss:FindFirstChild("Humanoid") and selectedBoss.Humanoid.Health > 0 then
		-- Hiển thị máu boss
		local hp = math.floor(selectedBoss.Humanoid.Health)
		local max = math.floor(selectedBoss.Humanoid.MaxHealth)
		bossHpLabelCenter.Text = "💥 Máu Boss: " .. hp .. " / " .. max
		bossHpLabelCorner.Text = "💔 " .. selectedBoss.Name .. ": " .. hp .. " / " .. max

		-- Quay quanh + gim tâm
		angle = angle + speed * dt
		local bossPos = selectedBoss.HumanoidRootPart.Position
		local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
		local targetPos = bossPos + offset
		HRP.CFrame = CFrame.new(targetPos, bossPos)

		-- Auto attack
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
	else
		bossHpLabelCenter.Text = "⚠️ Không tìm thấy Boss hợp lệ!"
		bossHpLabelCorner.Text = "⚠️ Boss: Không tồn tại hoặc đã chết"
	end
end)