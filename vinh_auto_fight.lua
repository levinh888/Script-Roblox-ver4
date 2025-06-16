
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ========== GUI SETUP ==========
local gui = Instance.new("ScreenGui", CoreGui)
gui.ResetOnSpawn = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 10, 0.5, -25)
openBtn.Text = "🗿"
openBtn.TextScaled = true
openBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 240, 0, 240)
mainFrame.Position = UDim2.new(0, 70, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true

local function addToggle(name, yPos, callback)
local btn = Instance.new("TextButton", mainFrame)
btn.Size = UDim2.new(0.9, 0, 0, 30)
btn.Position = UDim2.new(0.05, 0, 0, yPos)
btn.Text = "OFF - " .. name
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
btn.TextColor3 = Color3.new(1,1,1)

local state = false  
btn.MouseButton1Click:Connect(function()  
	state = not state  
	btn.Text = (state and "ON  - " or "OFF - ") .. name  
	callback(state)  
end)
end

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0.2, 0, 0, 30)
closeBtn.Position = UDim2.new(0.75, 0, 0, 5)
closeBtn.Text = "❌"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)

-- Open/Close menu
openBtn.MouseButton1Click:Connect(function()
mainFrame.Visible = not mainFrame.Visible
end)
closeBtn.MouseButton1Click:Connect(function()
mainFrame.Visible = false
end)

-- ========== SCRIPT 1: TĂNG TỐC ĐÁNH ==========
local attackSpeedConnection
addToggle("Tăng tốc đánh", 40, function(state)
if state then
attackSpeedConnection = RunService.Heartbeat:Connect(function()
local h = character:FindFirstChild("Humanoid")
if h then
for _, a in pairs(h:GetPlayingAnimationTracks()) do
pcall(function() a:AdjustSpeed(5) end)
end
end
end)
else
if attackSpeedConnection then attackSpeedConnection:Disconnect() end
end
end)

-- ========== SCRIPT 2: TỰ ĐÁNH KHI CẦM VŨ KHÍ ==========
local autoAttackLoop
addToggle("Tự đánh khi cầm vũ khí", 80, function(state)
if state then
autoAttackLoop = true
task.spawn(function()
while autoAttackLoop do
local tool = character:FindFirstChildOfClass("Tool")
if tool then pcall(function() tool:Activate() end) end
wait(0.2)
end
end)
else
autoAttackLoop = false
end
end)

-- ========== SCRIPT 3: XOAY QUANH ENEMY GẦN ==========
local rotateLoop
addToggle("Xoay quanh kẻ địch", 120, function(state)
if state then
rotateLoop = true
task.spawn(function()
local radius, speed = 21, 50
local angle = 0
local function getEnemy()
local closest, dist = nil, math.huge
local hrp = character:FindFirstChild("HumanoidRootPart")
if not hrp then return end
for _, obj in pairs(workspace:GetDescendants()) do
if obj:IsA("Model") and obj ~= character and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
if obj.Humanoid.Health > 0 then
local d = (hrp.Position - obj.HumanoidRootPart.Position).Magnitude
if d < dist then
dist = d
closest = obj
end
end
end
end
return closest
end

while rotateLoop do  
			local hrp = character:FindFirstChild("HumanoidRootPart")  
			local enemy = getEnemy()  
			if hrp and enemy and enemy:FindFirstChild("HumanoidRootPart") then  
				angle += speed * RunService.Heartbeat:Wait()  
				local offset = Vector3.new(math.cos(angle)*radius, 0, math.sin(angle)*radius)  
				hrp.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + offset, enemy.HumanoidRootPart.Position)  
			else wait(0.2) end  
		end  
	end)  
else  
	rotateLoop = false  
end
end)

-- ========== SCRIPT 4: HITBOX 🗿 QUANH NGƯỜI ==========
local hitboxActive = false
local heads = {}

addToggle("Hitbox 🗿 quanh người", 160, function(state)
if state and #heads == 0 then
local count, radius = 12, 12
for i = 1, count do
local part = Instance.new("Part")
part.Anchored = true
part.CanCollide = false
part.Size = Vector3.new(1,1,1)
part.Transparency = 1
part.Parent = workspace

local gui = Instance.new("BillboardGui", part)  
		gui.Size = UDim2.new(2, 0, 2, 0)  
		gui.AlwaysOnTop = true  

		local lbl = Instance.new("TextLabel", gui)  
		lbl.Size = UDim2.new(1,0,1,0)  
		lbl.Text = "🗿"  
		lbl.BackgroundTransparency = 1  
		lbl.TextTransparency = 0.4  
		lbl.TextScaled = true  
		lbl.TextColor3 = Color3.fromRGB(255, 255, 255)  

		table.insert(heads, part)  
	end  

	hitboxActive = true  
	task.spawn(function()  
		while hitboxActive do  
			local hrp = character:FindFirstChild("HumanoidRootPart")  
			if hrp then  
				for i, icon in pairs(heads) do  
					local angle = math.rad((i / #heads) * 360 + tick() * 50)  
					local offset = Vector3.new(math.cos(angle)*radius, 2, math.sin(angle)*radius)  
					icon.Position = hrp.Position + offset  
				end  
			end  
			RunService.Heartbeat:Wait()  
		end  
	end)  

	task.spawn(function()  
		while hitboxActive do  
			for _, obj in pairs(workspace:GetDescendants()) do  
				if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj ~= character then  
					for _, icon in pairs(heads) do  
						if (icon.Position - obj.HumanoidRootPart.Position).Magnitude <= 3 then  
							obj.Humanoid:TakeDamage(5)  
						end  
					end  
				end  
			end  
			wait(0.2)  
		end  
	end)  

else  
	hitboxActive = false  
	for _, h in pairs(heads) do  
		h:Destroy()  
	end  
	heads = {}  
end
end)
