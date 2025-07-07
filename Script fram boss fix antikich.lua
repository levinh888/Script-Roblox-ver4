-- 👹 WOKINGLOG PRO - GUI Fram Boss Fly CFrame + Auto Hit + HP Display

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local radius = 21
local flySpeed = 0.15
local attackDelay = 0.2
local autoFarm = false

-- 🌡️ GUI Hiển thị máu boss
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "WOKINGLOG_FramUI"

local bossLabel = Instance.new("TextLabel", screenGui)
bossLabel.Size = UDim2.new(0, 300, 0, 30)
bossLabel.Position = UDim2.new(0.5, -150, 0, 20)
bossLabel.BackgroundTransparency = 0.3
bossLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
bossLabel.TextColor3 = Color3.new(1, 0, 0)
bossLabel.Font = Enum.Font.GothamBold
bossLabel.TextScaled = true
bossLabel.Visible = false

-- 🔘 GUI Bật/Tắt Fram Boss
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 150, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 60)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
toggleButton.Text = "🔴 Fram Boss: OFF"

-- 👉 Hàm tìm boss/NPC gần nhất
local function getNearestTarget()
	local nearest, minDist = nil, math.huge
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
			local n = v.Name:lower()
			if (n:find("boss") or n:find("npc") or n:find("human")) and v.Humanoid.Health > 0 then
				local dist = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
				if dist < minDist then
					minDist = dist
					nearest = v
				end
			end
		end
	end
	return nearest
end

-- ✈️ Fly mượt + quay mặt vào boss
local function smoothMove(toPos, lookAt)
	local cf = CFrame.lookAt(toPos, lookAt)
	local tween = TweenService:Create(hrp, TweenInfo.new(0.1), {CFrame = cf})
	tween:Play()
end

-- 📦 Luồng Fram Boss
local function startFramBoss()
	spawn(function()
		while autoFarm do
			local target = getNearestTarget()
			if target then
				bossLabel.Visible = true
				local hum = target:FindFirstChildOfClass("Humanoid")
				local angle = 0
				while target and hum and hum.Health > 0 and target:FindFirstChild("HumanoidRootPart") and autoFarm do
					local pos = target.HumanoidRootPart.Position
					angle = angle + flySpeed
					local x = math.cos(angle) * radius
					local z = math.sin(angle) * radius
					local dest = pos + Vector3.new(x, 4, z)
					smoothMove(dest, pos)
					bossLabel.Text = string.format("👹 %s | 💖 %.0f / %.0f", target.Name, hum.Health, hum.MaxHealth)
					wait(0.1)
				end
			else
				bossLabel.Visible = false
				wait(1)
			end
		end
	end)

	-- 🥊 Auto đánh
	spawn(function()
		while autoFarm do
			pcall(function()
				local tool = lp.Character:FindFirstChildOfClass("Tool")
				if tool then tool:Activate() end
			end)
			wait(attackDelay)
		end
	end)
end

-- 🎛️ Toggle GUI
toggleButton.MouseButton1Click:Connect(function()
	autoFarm = not autoFarm
	if autoFarm then
		toggleButton.Text = "🟢 Fram Boss: ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		startFramBoss()
	else
		toggleButton.Text = "🔴 Fram Boss: OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		bossLabel.Visible = false
	end
end)