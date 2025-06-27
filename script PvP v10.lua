-- WOKINGLOG 👹 MENU FULL | Bản chính chủ | Có nút 👹 bật/tắt GUI | Tab PvP / Fix Lag

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- MAIN GUI HOLDER
local mainGui = Instance.new("ScreenGui", game.CoreGui)
mainGui.Name = "WOKINGLOG_MAIN"

-- 👹 ICON BẬT/TẮT GÓC MÀN HÌNH
local toggleIcon = Instance.new("TextButton", mainGui)
toggleIcon.Size = UDim2.new(0, 40, 0, 40)
toggleIcon.Position = UDim2.new(0, 10, 0, 10)
toggleIcon.Text = "👹"
toggleIcon.TextScaled = true
toggleIcon.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
toggleIcon.TextColor3 = Color3.new(1, 0, 0)
toggleIcon.Font = Enum.Font.Fantasy

-- MENU FRAME ẨN HIỆN
local frame = Instance.new("Frame", mainGui)
frame.Size = UDim2.new(0, 330, 0, 310)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 2
frame.Visible = false

toggleIcon.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- TITLE + CLOSE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "👹 WOKINGLOG MENU 👹"
title.TextColor3 = Color3.new(1, 0, 0)
title.Font = Enum.Font.Fantasy
title.TextScaled = true
title.BackgroundTransparency = 1

local close = Instance.new("TextButton", frame)
close.Text = "❌"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- TAB SYSTEM
local currentTab = "PvP"
local function switchTab(tab)
	currentTab = tab
	for _,v in pairs(frame:GetChildren()) do
		if v:IsA("TextButton") and v.Name:find("btn_") then
			v.Visible = (v.Name:find(tab) ~= nil)
		end
	end
end

-- TAB BUTTONS
local btnPvP = Instance.new("TextButton", frame)
btnPvP.Text = "⚔️ PvP"
btnPvP.Position = UDim2.new(0, 10, 0, 40)
btnPvP.Size = UDim2.new(0, 100, 0, 25)
btnPvP.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btnPvP.TextColor3 = Color3.new(1, 1, 1)
btnPvP.MouseButton1Click:Connect(function() switchTab("PvP") end)

local btnLag = Instance.new("TextButton", frame)
btnLag.Text = "🧹 Fix Lag"
btnLag.Position = UDim2.new(0, 120, 0, 40)
btnLag.Size = UDim2.new(0, 100, 0, 25)
btnLag.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btnLag.TextColor3 = Color3.new(1, 1, 1)
btnLag.MouseButton1Click:Connect(function() switchTab("Lag") end)

-- FUNCTION TẠO BUTTON
local function createToggle(name, ypos, tabName, callback)
	local state = false
	local btn = Instance.new("TextButton", frame)
	btn.Name = "btn_" .. tabName .. "_" .. name
	btn.Text = "🔴 " .. name
	btn.Size = UDim2.new(0.9, 0, 0, 30)
	btn.Position = UDim2.new(0.05, 0, 0, ypos)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Visible = (tabName == "PvP")

	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = (state and "🟢 " or "🔴 ") .. name
		callback(state)
	end)
end

-- PVP TOGGLES
createToggle("Hitbox vũ khí", 80, "PvP", function(on)
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
end)

createToggle("Tự đánh khi cầm vũ khí", 120, "PvP", function(on)
	if on then
		task.spawn(function()
			while on do
				local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
				if tool then tool:Activate() end
				task.wait(0.1)
			end
		end)
	end
end)

createToggle("Aim nhẹ vào gần nhất", 160, "PvP", function(on)
	if on then
		RunService:BindToRenderStep("aim", 300, function()
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
				cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, to), 0.05)
			end
		end)
	else
		RunService:UnbindFromRenderStep("aim")
	end
end)

createToggle("Hiển thị số máu kẻ địch", 200, "PvP", function(on)
	if on then
		task.spawn(function()
			while on do
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") then
						local head = p.Character:FindFirstChild("Head")
						if head and not head:FindFirstChild("HP_TAG") then
							local tag = Instance.new("BillboardGui", head)
							tag.Name = "HP_TAG"
							tag.Size = UDim2.new(0,100,0,40)
							tag.Adornee = head
							tag.AlwaysOnTop = true
							local text = Instance.new("TextLabel", tag)
							text.Size = UDim2.new(1,0,1,0)
							text.BackgroundTransparency = 1
							text.TextColor3 = Color3.new(1,0,0)
							text.Font = Enum.Font.SourceSansBold
							text.TextScaled = true
							task.spawn(function()
								while tag.Parent and on do
									text.Text = tostring(math.floor(p.Character.Humanoid.Health)) .. " HP"
									task.wait(0.2)
								end
							end)
						end
					end
				end
				task.wait(1)
			end
		end)
	else
		for _, p in pairs(Players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("Head") then
				local t = p.Character.Head:FindFirstChild("HP_TAG")
				if t then t:Destroy() end
			end
		end
	end
end)

createToggle("Speed chạy (40)", 240, "PvP", function(on)
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if on then
		local bv = Instance.new("BodyVelocity", hrp)
		bv.Name = "WOK_SPEED"
		bv.MaxForce = Vector3.new(1e9,0,1e9)
		RunService.Heartbeat:Connect(function()
			if bv and bv.Parent then
				bv.Velocity = lp.Character:FindFirstChildOfClass("Humanoid").MoveDirection * 40
			end
		end)
	else
		local b = hrp:FindFirstChild("WOK_SPEED")
		if b then b:Destroy() end
	end
end)

-- FIX LAG TOGGLES
createToggle("Giảm 30% đồ họa", 80, "Lag", function(on)
	if on then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic; v.Reflectance = 0 end
			if v:IsA("Decal") then v.Transparency = 0.5 end
		end
	end
end)

createToggle("Hiển thị FPS", 120, "Lag", function(on)
	if on then
		local fpsGui = Instance.new("TextLabel", mainGui)
		fpsGui.Name = "FPS"
		fpsGui.Size = UDim2.new(0,120,0,25)
		fpsGui.Position = UDim2.new(0,5,0,55)
		fpsGui.TextColor3 = Color3.new(0,1,0)
		fpsGui.BackgroundTransparency = 1
		fpsGui.Font = Enum.Font.Code
		fpsGui.TextScaled = true

		local last = tick()
		RunService.RenderStepped:Connect(function()
			local dt = tick()-last
			last = tick()
			if fpsGui and fpsGui.Parent then
				fpsGui.Text = "FPS: "..math.floor(1/dt)
			end
		end)
	else
		if mainGui:FindFirstChild("FPS") then mainGui.FPS:Destroy() end
	end
end)

-- Mặc định bật PvP tab
switchTab("PvP")