--// 👑 Script Full Menu by Vinh (mật khẩu: CHUCMUNG1KFLO)

local password = "CHUCMUNG1KFLO"
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- UI Nhập mật khẩu
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PasswordUI"

local pwFrame = Instance.new("Frame", gui)
pwFrame.Size = UDim2.new(0, 300, 0, 160)
pwFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
pwFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
pwFrame.BackgroundTransparency = 0.1
pwFrame.BorderSizePixel = 0
local pwCorner = Instance.new("UICorner", pwFrame)

local pwText = Instance.new("TextBox", pwFrame)
pwText.PlaceholderText = "MẬT KHẨU:"
pwText.Size = UDim2.new(0.8, 0, 0.3, 0)
pwText.Position = UDim2.new(0.1, 0, 0.2, 0)
pwText.TextScaled = true
pwText.ClearTextOnFocus = false
pwText.Text = ""
pwText.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
pwText.TextColor3 = Color3.fromRGB(255, 255, 255)
local pwCorner2 = Instance.new("UICorner", pwText)

local pwButton = Instance.new("TextButton", pwFrame)
pwButton.Text = "[ XÁC NHẬN ]"
pwButton.Size = UDim2.new(0.8, 0, 0.3, 0)
pwButton.Position = UDim2.new(0.1, 0, 0.6, 0)
pwButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
pwButton.TextScaled = true
local pwCorner3 = Instance.new("UICorner", pwButton)

pwButton.MouseButton1Click:Connect(function()
	if pwText.Text == password then
		gui:Destroy()
		loadMainUI()
	else
		pwButton.Text = "SAI MẬT KHẨU!"
	end
end)

-- HÀM CHÍNH
function loadMainUI()
	local gui = Instance.new("ScreenGui", CoreGui)
	gui.Name = "VinhMainMenu"

	local menuFrame = Instance.new("Frame", gui)
	menuFrame.Size = UDim2.new(0, 230, 0, 350)
	menuFrame.Position = UDim2.new(0, 10, 0.5, -175)
	menuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	menuFrame.BackgroundTransparency = 0.05
	local corner = Instance.new("UICorner", menuFrame)

	local layout = Instance.new("UIListLayout", menuFrame)
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local function createButton(txt, callback)
		local btn = Instance.new("TextButton", menuFrame)
		btn.Size = UDim2.new(0.9, 0, 0, 35)
		btn.Text = txt
		btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
		btn.TextColor3 = Color3.new(1,1,1)
		btn.TextScaled = true
		local round = Instance.new("UICorner", btn)
		btn.MouseButton1Click:Connect(callback)
	end

	-- TỰ NHẢY
	local autoJump = false
	createButton("TỰ NHẢY", function()
		autoJump = not autoJump
		while autoJump do
			wait(1)
			pcall(function()
				Player.Character.Humanoid.Jump = true
			end)
		end
	end)

	-- TỰ NHẢY LIÊN TỤC
	local rapidJump = false
	createButton("TỰ NHẢY LIÊN TỤC", function()
		rapidJump = not rapidJump
		while rapidJump do
			wait(0.1)
			pcall(function()
				Player.Character.Humanoid.Jump = true
			end)
		end
	end)

	-- TỰ ĐÁNH
	local autoClick = false
	createButton("TỰ ĐÁNH", function()
		autoClick = not autoClick
		while autoClick do
			wait(0.1)
			mouse1click()
		end
	end)

	-- TỰ ĐÁNH KHI CẦM VŨ KHÍ
	local autoAttackTool = false
	createButton("TỰ ĐÁNH CÓ VŨ KHÍ", function()
		autoAttackTool = not autoAttackTool
		while autoAttackTool do
			wait(0.1)
			local tool = Player.Character:FindFirstChildOfClass("Tool")
			if tool then
				mouse1click()
			end
		end
	end)

	-- PC MODE
	createButton("PC – NHÌN NHƯ PC", function()
		Player.CameraMaxZoomDistance = 120
		Player.CameraMinZoomDistance = 5
	end)

	-- HIỂN THỊ MÁU NGƯỜI CHƠI
	createButton("HIỂN THỊ MÁU", function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local head = p.Character:FindFirstChild("Head")
				if head then
					local gui = Instance.new("BillboardGui", head)
					gui.Size = UDim2.new(5, 0, 1, 0)
					gui.Adornee = head
					gui.AlwaysOnTop = true

					local label = Instance.new("TextLabel", gui)
					label.Size = UDim2.new(1, 0, 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Color3.new(1, 0, 0)
					label.TextScaled = true
					game:GetService("RunService").Heartbeat:Connect(function()
						if p.Character and p.Character:FindFirstChild("Humanoid") then
							label.Text = "❤️ "..math.floor(p.Character.Humanoid.Health)
						end
					end)
				end
			end
		end
	end)

	-- ESP TOÀN SERVER
	createButton("ESP TOÀN SERVER", function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local head = p.Character:FindFirstChild("Head")
				if head then
					local gui = Instance.new("BillboardGui", head)
					gui.Size = UDim2.new(5, 0, 1, 0)
					gui.Adornee = head
					gui.AlwaysOnTop = true

					local label = Instance.new("TextLabel", gui)
					label.Size = UDim2.new(1, 0, 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Color3.fromRGB(0, 255, 0)
					label.TextScaled = true
					label.Text = p.Name
				end
			end
		end
	end)

	-- ICON bật/tắt
	local icon = Instance.new("TextButton", gui)
	icon.Size = UDim2.new(0, 40, 0, 40)
	icon.Position = UDim2.new(0, 5, 0, 5)
	icon.Text = "👾"
	icon.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	local icorner = Instance.new("UICorner", icon)

	icon.MouseButton1Click:Connect(function()
		menuFrame.Visible = not menuFrame.Visible
	end)
end
