-- WOKINGLOG 👹 PvP V3 | FIX FULL - TỐI ƯU - GIẢM LAG + AIM NHẸ

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Name = "WOKINGLOG_GUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = game.CoreGui

-- ICON BẬT/TẮT 👹
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "👹"
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextSize = 22
toggleBtn.TextColor3 = Color3.new(1, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
toggleBtn.Parent = gui

-- FRAME GUI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 500)
frame.Position = UDim2.new(0.5, -180, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 2
frame.Visible = false
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- KÉO FRAME = CHUỘT
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)
frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- NÚT ❌ ĐÓNG
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "❌"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- TIÊU ĐỀ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "👹 WOKINGLOG PvP GUI 👹"
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.new(1, 0.3, 0.3)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Parent = frame

-- TAB
local tabs = {"Combat", "Giảm Lag"}
local currentTab = "Combat"
local tabButtons = {}

local tabHolder = Instance.new("Frame")
tabHolder.Position = UDim2.new(0, 5, 0, 35)
tabHolder.Size = UDim2.new(1, -10, 0, 25)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = frame

for i, tab in ipairs(tabs) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 100, 1, 0)
	btn.Position = UDim2.new(0, (i - 1) * 110, 0, 0)
	btn.Text = tab
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.Parent = tabHolder
	tabButtons[tab] = btn
	btn.MouseButton1Click:Connect(function()
		currentTab = tab
		for _,v in pairs(frame:GetChildren()) do
			if v:IsA("ScrollingFrame") then
				v.Visible = v.Name == "Page"..tab
			end
		end
		for _,v in pairs(tabButtons) do
			v.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end
		btn.BackgroundColor3 = Color3.fromRGB(90, 0, 0)
	end)
end

-- PAGES
local pages = {}
for _, tab in ipairs(tabs) do
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "Page"..tab
	scroll.Position = UDim2.new(0, 5, 0, 65)
	scroll.Size = UDim2.new(1, -10, 1, -70)
	scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	scroll.ScrollBarThickness = 4
	scroll.BorderSizePixel = 0
	scroll.Visible = (tab == currentTab)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 1500)
	scroll.Parent = frame
	Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
	pages[tab] = scroll
end

-- TOGGLE FUNCTION
local function createToggle(text, parent, posY, callback)
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(1, -10, 0, 30)
	toggle.Position = UDim2.new(0, 5, 0, posY)
	toggle.Text = "🔴 " .. text
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 14
	toggle.TextColor3 = Color3.new(1, 1, 1)
	toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	toggle.Parent = parent
	local state = false
	local thread
	toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = (state and "🟢 " or "🔴 ") .. text
		callback(state)
	end)
end

local y = {Combat=0, ["Giảm Lag"] = 0}

-- COMBAT: Hitbox
createToggle("Hitbox vũ khí", pages.Combat, y.Combat, function(on)
	if on then
		local function applyHitbox(tool)
			for _, part in ipairs(tool:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Size = Vector3.new(8,8,8)
					part.Transparency = 0.9
					part.BrickColor = BrickColor.White()
					part.Material = Enum.Material.SmoothPlastic
					part.CanCollide = false
					if not part:FindFirstChildOfClass("SelectionBox") then
						local box = Instance.new("SelectionBox", part)
						box.Adornee = part
						box.Color3 = Color3.new(1,1,0)
					end
				end
			end
		end
		local char = lp.Character or lp.CharacterAdded:Wait()
		for _,v in ipairs(char:GetChildren()) do
			if v:IsA("Tool") then applyHitbox(v) end
		end
		char.ChildAdded:Connect(function(c)
			if c:IsA("Tool") then wait(0.2) applyHitbox(c) end
		end)
	end
end) y.Combat += 35

-- COMBAT: Auto Swing
local autoSwingConn
createToggle("Tự đánh (Auto Swing)", pages.Combat, y.Combat, function(on)
	if autoSwingConn then autoSwingConn:Disconnect() end
	if on then
		autoSwingConn = RunService.Heartbeat:Connect(function()
			local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
			if tool then tool:Activate() end
		end)
	end
end) y.Combat += 35

-- COMBAT: Cam Lock (nhẹ)
createToggle("Aim gần nhất (Cam lock)", pages.Combat, y.Combat, function(on)
	if on then
		RunService:BindToRenderStep("WOKINGLOG_Aim", 300, function()
			local cam = workspace.CurrentCamera
			local closest, dist = nil, math.huge
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local mag = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
					if mag < dist then
						dist = mag
						closest = p
					end
				end
			end
			if closest then
				local dir = (closest.Character.HumanoidRootPart.Position - cam.CFrame.Position).Unit
				local to = cam.CFrame.Position + dir * 100
				cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, to), 0.02)
			end
		end)
	else
		RunService:UnbindFromRenderStep("WOKINGLOG_Aim")
	end
end) y.Combat += 35

-- COMBAT: Speed Hack
local speedConn
createToggle("Speed (vượt chướng ngại)", pages.Combat, y.Combat, function(on)
	if speedConn then speedConn:Disconnect() end
	if on then
		speedConn = RunService.Heartbeat:Connect(function()
			local player = lp
			local char = player and player.Character
			if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
				local moveDir = char.Humanoid.MoveDirection
				if moveDir.Magnitude > 0 then
					char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + moveDir * 5
				end
			end
		end)
	end
end) y.Combat += 35

-- GIẢM LAG: 30% (nhẹ)
createToggle("Giảm 30% đồ họa", pages["Giảm Lag"], y["Giảm Lag"], function(on)
	if on then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Reflectance = 0.1
			end
			if v:IsA("Decal") then
				v.Transparency = 0.2
			end
		end
	end
end) y["Giảm Lag"] += 35

-- GIẢM LAG: 70%
createToggle("Giảm 70% đồ họa", pages["Giảm Lag"], y["Giảm Lag"], function(on)
	if on then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.SmoothPlastic
				v.Reflectance = 0
				v.CastShadow = false
			end
			if v:IsA("Decal") then
				v.Transparency = 0.7
			end
		end
	end
end) y["Giảm Lag"] += 35

-- GIẢM LAG: 100%
createToggle("Giảm 100% đồ họa", pages["Giảm Lag"], y["Giảm Lag"], function(on)
	if on then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.ForceField
				v.Reflectance = 0
				v.Transparency = 1
			end
			if v:IsA("Decal") then
				v.Transparency = 1
			end
		end
	end
end) y["Giảm Lag"] += 35
