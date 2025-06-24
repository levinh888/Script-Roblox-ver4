-- WOKINGLOG PvP MENU FINAL V2 - GIAO DIỆN MÀU MÈ + HIỆU ỨNG MỞ + HITBOX TO (ĐÃ FIX)
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

-- GUI chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WOKINGLOG_PvPMenu"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game.CoreGui

-- Gradient nền đẹp
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 255)),
	ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 255, 0))
}
uiGradient.Rotation = 45

-- Frame menu chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 380)
frame.Position = UDim2.new(0.5, -170, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Visible = false
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
uiGradient:Clone().Parent = frame

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(255, 100, 100)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Hiệu ứng mở menu
local openTween = ts:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 340, 0, 380),
	Position = UDim2.new(0.5, -170, 0.5, -190),
	BackgroundTransparency = 0
})

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
title.Text = "👹 WOKINGLOG PvP MENU 👹"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Arcade
title.TextSize = 22
local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 8)

-- Nút X
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✖"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)

-- Nút mở menu
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

-- Hover hiệu ứng
openBtn.MouseEnter:Connect(function()
	local t1 = ts:Create(openBtn, TweenInfo.new(0.1), {Rotation = 10, BackgroundColor3 = Color3.fromRGB(100, 0, 0)})
	local t2 = ts:Create(openBtn, TweenInfo.new(0.1), {Rotation = -10})
	local t3 = ts:Create(openBtn, TweenInfo.new(0.1), {Rotation = 0, BackgroundColor3 = Color3.fromRGB(60, 0, 0)})
	t1:Play()
	t1.Completed:Connect(function()
		t2:Play()
		t2.Completed:Connect(function()
			t3:Play()
		end)
	end)
end)

-- Click nút mở
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	frame.Size = UDim2.new(0, 0, 0, 0)
	openTween:Play()
end)

-- Đóng menu
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

-- Phím K
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.K then
		frame.Visible = not frame.Visible
	end
end)

-- Tạo toggle
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

-- Auto Aim
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

-- Auto Attack
createToggle("Auto Attack", function(on)
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

-- Hitbox To (đã fix lỗi mất đầu)
createToggle("Hitbox To", function(on)
	_G._hitboxOn = on
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
			local head = p.Character.Head
			if on then
				pcall(function()
					head.Size = Vector3.new(10, 10, 10)
					head.Transparency = 0.7
					head.Material = Enum.Material.ForceField
					head.BrickColor = BrickColor.new("Pastel yellow")
					head.CanCollide = false
					local mesh = head:FindFirstChildOfClass("SpecialMesh")
					if mesh then mesh:Destroy() end
				end)
			else
				pcall(function()
					head.Size = Vector3.new(2, 1, 1)
					head.Transparency = 0
					head.Material = Enum.Material.Plastic
					head.CanCollide = true
				end)
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(char)
		if _G._hitboxOn then
			local head = char:WaitForChild("Head", 5)
			if head then
				pcall(function()
					head.Size = Vector3.new(10, 10, 10)
					head.Transparency = 0.7
					head.Material = Enum.Material.ForceField
					head.BrickColor = BrickColor.new("Pastel yellow")
					head.CanCollide = false
					local mesh = head:FindFirstChildOfClass("SpecialMesh")
					if mesh then mesh:Destroy() end
				end)
			end
		end
	end)
end)

print("✅ WOKINGLOG MENU FINAL V2 - GIAO DIỆN MÀU MÈ + HITBOX TO ĐÃ FIX")
