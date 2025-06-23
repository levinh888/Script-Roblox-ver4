-- FULL SCRIPT MENU WOKINGLOG + ESP + AURA + CFrame SPEED + SLIDER + AUTO TOOL + HITBOX HEAD
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

-- GUI chính
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "WOKINGLOG_PvPMenu"

-- Frame menu
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 320, 0, 500)
frame.Position = UDim2.new(0.5, -160, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Visible = false

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
title.Text = "👹 WOKINGLOG PvP MENU 👹"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 20

-- Nút X để đóng
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✖"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

-- Nút 👹 bật menu
local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0.5, -20)
openBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
openBtn.Text = "👹"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.FredokaOne
openBtn.TextSize = 24
openBtn.ZIndex = 10
openBtn.Visible = true

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
end)

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.K then
		frame.Visible = not frame.Visible
	end
end)

local y = 50
local function createToggle(name, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
	btn.BorderSizePixel = 1
	btn.Text = name .. ": OFF"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	y = y + 40

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = name .. ": " .. (state and "ON ✅" or "OFF ❌")
		callback(state)
	end)
end

-- ESP
createToggle("ESP", function(on)
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= lp and p.Character then
			local h = p.Character:FindFirstChild("ESPHighlight")
			if on then
				if not h then
					h = Instance.new("Highlight", p.Character)
					h.Name = "ESPHighlight"
					h.FillColor = Color3.fromRGB(255, 0, 0)
				end
			else
				if h then h:Destroy() end
			end
		end
	end
end)

-- Auto Aim fix
createToggle("Auto Aim", function(on)
	if on then
		rs:BindToRenderStep("WOKINGLOG_Aim", Enum.RenderPriority.Camera.Value + 1, function()
			local closest, dist = nil, 100
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local d = (p.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
					if d < dist then
						dist = d
						closest = p
					end
				end
			end
			if closest and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
				local root = lp.Character.HumanoidRootPart
				local targetPos = Vector3.new(
					closest.Character.HumanoidRootPart.Position.X,
					root.Position.Y,
					closest.Character.HumanoidRootPart.Position.Z
				)
				root.CFrame = CFrame.new(root.Position, targetPos)
			end
		end)
	else
		rs:UnbindFromRenderStep("WOKINGLOG_Aim")
	end
end)

-- Kill Aura
createToggle("Kill Aura", function(on)
	if on then
		_G._killAura = true
		spawn(function()
			while _G._killAura do wait(0.2)
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
						if (p.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude < 15 then
							pcall(function()
								game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(p)
							end)
						end
					end
				end
			end
		end)
	else
		_G._killAura = false
	end
end)

-- Hitbox Head
createToggle("Hitbox Head", function(on)
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
			local head = p.Character.Head
			if on then
				head.Size = Vector3.new(5, 5, 5)
				head.Transparency = 0.8
				head.Material = Enum.Material.ForceField
				head.BrickColor = BrickColor.new("Pastel yellow")
			else
				head.Size = Vector3.new(2, 1, 1)
				head.Transparency = 0
				head.Material = Enum.Material.Plastic
			end
		end
	end
end)

-- Auto Tool Attack
createToggle("Auto Tool", function(on)
	if on then
		_G._autoAttack = true
		spawn(function()
			while _G._autoAttack do wait(0.2)
				local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
				if tool then pcall(function() tool:Activate() end) end
			end
		end)
	else
		_G._autoAttack = false
	end
end)

-- CFrame Speed Control
local cframeSpeed = 1
local cframeRunning = false
createToggle("CFrame Speed", function(on)
	cframeRunning = on
end)

rs.Heartbeat:Connect(function()
	if cframeRunning and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChild("Humanoid") then
		local dir = lp.Character.Humanoid.MoveDirection
		lp.Character:TranslateBy(dir * cframeSpeed)
	end
end)

-- Slider tăng giảm speed
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Position = UDim2.new(0, 10, 0, y)
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedLabel.Text = "CFrame Speed: " .. cframeSpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 15
y = y + 35

local upBtn = Instance.new("TextButton", frame)
upBtn.Position = UDim2.new(0, 10, 0, y)
upBtn.Size = UDim2.new(0, 140, 0, 30)
upBtn.Text = "+ Tăng"
upBtn.BackgroundColor3 = Color3.fromRGB(50, 80, 50)
upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
upBtn.Font = Enum.Font.GothamBold
upBtn.TextSize = 14

local downBtn = Instance.new("TextButton", frame)
downBtn.Position = UDim2.new(0, 170, 0, y)
downBtn.Size = UDim2.new(0, 140, 0, 30)
downBtn.Text = "- Giảm"
downBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 50)
downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
downBtn.Font = Enum.Font.GothamBold
downBtn.TextSize = 14
y = y + 35

upBtn.Parent = frame
downBtn.Parent = frame

local function applySpeed(val)
	cframeSpeed = math.clamp(cframeSpeed + val, 0.5, 5)
	speedLabel.Text = "CFrame Speed: " .. tostring(cframeSpeed)
end

upBtn.MouseButton1Click:Connect(function()
	applySpeed(0.2)
end)

downBtn.MouseButton1Click:Connect(function()
	applySpeed(-0.2)
end)

print("✅ WOKINGLOG FULL PvP MENU LOADED")
