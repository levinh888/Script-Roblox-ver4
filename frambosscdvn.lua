-- FULL SCRIPT: Spin quanh NPC + Auto Attack khi cầm vũ khí, giao diện đẹp, icon 👹, nút X đóng menu

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptMenu"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not screenGui.Parent then screenGui.Parent = lp:WaitForChild("PlayerGui") end

-- ICON 👹
local iconBtn = Instance.new("TextButton", screenGui)
iconBtn.Size = UDim2.new(0, 40, 0, 40)
iconBtn.Position = UDim2.new(0, 10, 0.5, -20)
iconBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
iconBtn.Text = "👹"
iconBtn.Font = Enum.Font.GothamBlack
iconBtn.TextColor3 = Color3.new(1,1,1)
iconBtn.TextSize = 24
iconBtn.BorderSizePixel = 0

-- MENU
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
frame.BorderSizePixel = 0
frame.Visible = false
Instance.new("UICorner", frame)
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(200, 100, 255)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 WOKINGLOG MENU 🔥"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

-- ✖️ Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn)

-- Toggle Creator
local y = 50
local function createToggle(name, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = name .. ": OFF"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.BorderSizePixel = 0
	y += 35

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = name .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)
end

-- Logic
local spinEnabled = false
local attackEnabled = false
local angle = 0
local radius = 22
local speed = 50

-- Tìm NPC
local function getClosestNPC()
	local closest, dist = nil, math.huge
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(v) then
			if v:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
				local d = (v.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
				if d < dist then
					dist = d
					closest = v
				end
			end
		end
	end
	return closest
end

-- Quay quanh NPC
rs.RenderStepped:Connect(function(dt)
	if spinEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
		local npc = getClosestNPC()
		if npc and npc:FindFirstChild("HumanoidRootPart") then
			angle += dt * speed
			local pos = npc.HumanoidRootPart.Position + Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
			lp.Character:MoveTo(pos)
		end
	end
end)

-- Tự đánh đúng chuẩn
spawn(function()
	while true do wait(0.3)
		if attackEnabled and lp.Character then
			local tool = lp.Character:FindFirstChildOfClass("Tool")
			if tool and tool:FindFirstChild("Handle") then
				pcall(function()
					tool:Activate()
				end)
			end
		end
	end
end)

-- Toggle
createToggle("Spin NPC", function(state) spinEnabled = state end)
createToggle("Auto Attack", function(state) attackEnabled = state end)

-- Sự kiện đóng/mở menu
iconBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	TweenService:Create(frame, TweenInfo.new(0.25), {
		BackgroundColor3 = frame.Visible and Color3.fromRGB(50,50,70) or Color3.fromRGB(30,30,30)
	}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)
