-- Load giao diện Redz UI V2
loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/main/UiREDzV2.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Tạo Window chính
local Window = MakeWindow({
    Hub = {
        Title = "WOKINGLOG 👹",
        Animation = "Youtube: WOKINGLOG 👹"
    },
    Key = {
        KeySystem = false
    }
})

-- Tabs
local TabFarm = MakeTab({ Name = "Script Farm" })
local TabBoss = MakeTab({ Name = "Boss Hunter 👹" })
local TabPvP = MakeTab({ Name = "PvP" })

-- FARM
AddButton(TabFarm, {
    Name = "Redz Hub",
    Callback = function()
        local Settings = { JoinTeam = "Pirates", Translator = true }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/main/Source.lua"))(Settings)
    end
})

-- BOSS
AddButton(TabBoss, {
    Name = "🔥 Bật Script OutFram Boss Bá Đạo",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/levinh888/Script-ver4/main/script%20framboss%20b%C3%A1%20.lua"))()
    end
})

-- PvP: Đánh Nhanh
AddToggle(TabPvP, {
    Name = "💥 Đánh Nhanh Times Pro (Sửa lỗi aim/ngã)",
    Callback = function(state)
        _G.fastAttackFixed = state
        if state then
            task.spawn(function()
                while _G.fastAttackFixed do
                    local tool = Character and Character:FindFirstChildOfClass("Tool")
                    if tool then
                        for _ = 1, 8 do
                            pcall(function() tool:Activate() end)
                        end
                    end
                    wait(0.05)
                end
            end)
        end
    end
})

-- PvP: Aim Nhẹ
AddToggle(TabPvP, {
    Name = "🎯 Aim Nhẹ Vào Kẻ Địch (Không xoay ngã)",
    Callback = function(state)
        _G.aimAssist = state
        if state then
            task.spawn(function()
                while _G.aimAssist do
                    local nearest = nil
                    local shortest = math.huge
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if dist < shortest and dist < 25 then
                                shortest = dist
                                nearest = player.Character.HumanoidRootPart
                            end
                        end
                    end
                    if nearest then
                        local myHRP = Character and Character:FindFirstChild("HumanoidRootPart")
                        if myHRP then
                            myHRP.CFrame = CFrame.new(myHRP.Position, Vector3.new(nearest.Position.X, myHRP.Position.Y, nearest.Position.Z))
                        end
                    end
                    wait(0.15)
                end
            end)
        end
    end
})

-- PvP: Hiển thị máu địch
local enemyHealthGuiEnabled = false
local healthGui = Instance.new("ScreenGui", game.CoreGui)
healthGui.Name = "EnemyHealthDisplay"
healthGui.ResetOnSpawn = false

local healthLabel = Instance.new("TextLabel", healthGui)
healthLabel.Size = UDim2.new(0, 200, 0, 30)
healthLabel.Position = UDim2.new(0.8, 0, 0.05, 0)
healthLabel.BackgroundTransparency = 0.4
healthLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
healthLabel.TextScaled = true
healthLabel.Text = ""
healthLabel.Visible = false
healthLabel.Font = Enum.Font.GothamBold

AddToggle(TabPvP, {
    Name = "❤️ Hiển thị máu kẻ địch ở góc màn",
    Callback = function(state)
        enemyHealthGuiEnabled = state
        healthLabel.Visible = state

        if state then
            task.spawn(function()
                while enemyHealthGuiEnabled do
                    local nearest = nil
                    local shortest = math.huge
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                            local dist = (Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if dist < shortest and dist < 25 then
                                shortest = dist
                                nearest = player
                            end
                        end
                    end

                    if nearest and nearest.Character:FindFirstChild("Humanoid") then
                        local hp = nearest.Character.Humanoid.Health
                        local maxhp = nearest.Character.Humanoid.MaxHealth
                        healthLabel.Text = "👹 Máu địch: " .. math.floor(hp) .. " / " .. math.floor(maxhp)
                    else
                        healthLabel.Text = "👹 Không có địch gần"
                    end

                    wait(0.2)
                end
                healthLabel.Visible = false
                healthLabel.Text = ""
            end)
        end
    end
})

-- GUI Speed bằng CFrame
local UIS = game:GetService("UserInputService")
local speedValue = 5
local isSpeeding = false

local SpeedGui = Instance.new("ScreenGui")
SpeedGui.Name = "SpeedGui"
SpeedGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
SpeedGui.ResetOnSpawn = false

local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(0, 140, 0, 50)
SpeedFrame.Position = UDim2.new(0, 200, 0, 200)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedFrame.Active = true
SpeedFrame.Draggable = true
SpeedFrame.Parent = SpeedGui

local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Size = UDim2.new(1, 0, 1, 0)
SpeedToggle.Text = "🚀 Speed: OFF"
SpeedToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggle.Font = Enum.Font.GothamBold
SpeedToggle.TextSize = 18
SpeedToggle.Parent = SpeedFrame

SpeedToggle.MouseButton1Click:Connect(function()
	isSpeeding = not isSpeeding
	SpeedToggle.Text = isSpeeding and "🚀 Speed: ON" or "🚀 Speed: OFF"
end)

RunService.Heartbeat:Connect(function()
	if isSpeeding then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
			local hrp = char.HumanoidRootPart
			local moveDir = char.Humanoid.MoveDirection
			if moveDir.Magnitude > 0 then
				hrp.CFrame = hrp.CFrame + moveDir * speedValue
			end
		end
	end
end)

-- Hitbox GUI
local HitboxGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
HitboxGui.Name = "HitboxGui"
HitboxGui.ResetOnSpawn = false

local HitboxFrame = Instance.new("Frame")
HitboxFrame.Size = UDim2.new(0, 160, 0, 90)
HitboxFrame.Position = UDim2.new(0, 370, 0, 200)
HitboxFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
HitboxFrame.Active = true
HitboxFrame.Draggable = true
HitboxFrame.Parent = HitboxGui

local HitboxLabel = Instance.new("TextLabel")
HitboxLabel.Size = UDim2.new(1, 0, 0.4, 0)
HitboxLabel.Position = UDim2.new(0, 0, 0, 0)
HitboxLabel.BackgroundTransparency = 1
HitboxLabel.Text = "Hitbox Size: 5"
HitboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxLabel.Font = Enum.Font.GothamBold
HitboxLabel.TextSize = 18
HitboxLabel.Parent = HitboxFrame

local PlusButton = Instance.new("TextButton")
PlusButton.Size = UDim2.new(0.5, 0, 0.3, 0)
PlusButton.Position = UDim2.new(0, 0, 0.5, 0)
PlusButton.Text = "+"
PlusButton.Font = Enum.Font.GothamBold
PlusButton.TextSize = 22
PlusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlusButton.Parent = HitboxFrame

local MinusButton = Instance.new("TextButton")
MinusButton.Size = UDim2.new(0.5, 0, 0.3, 0)
MinusButton.Position = UDim2.new(0.5, 0, 0.5, 0)
MinusButton.Text = "-"
MinusButton.Font = Enum.Font.GothamBold
MinusButton.TextSize = 22
MinusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinusButton.Parent = HitboxFrame

local currentSize = 5
local hitboxPart = nil

local function updateHitbox()
	if hitboxPart then hitboxPart:Destroy() end
	hitboxPart = nil
	local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
	if tool and tool:FindFirstChild("Handle") then
		local handle = tool:FindFirstChild("Handle")
		local hb = Instance.new("BoxHandleAdornment")
		hb.Adornee = handle
		hb.Size = Vector3.new(currentSize, currentSize, currentSize)
		hb.Color3 = Color3.fromRGB(255, 0, 0)
		hb.AlwaysOnTop = true
		hb.ZIndex = 10
		hb.Transparency = 0.5
		hb.Name = "HitboxDisplay"
		hb.Parent = handle
		hitboxPart = hb
	end
end

PlusButton.MouseButton1Click:Connect(function()
	currentSize = math.min(currentSize + 1, 20)
	HitboxLabel.Text = "Hitbox Size: " .. currentSize
	updateHitbox()
end)

MinusButton.MouseButton1Click:Connect(function()
	currentSize = math.max(currentSize - 1, 1)
	HitboxLabel.Text = "Hitbox Size: " .. currentSize
	updateHitbox()
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	char.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then
			wait(0.1)
			updateHitbox()
		end
	end)
end)

if LocalPlayer.Character then
	LocalPlayer.Character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then
			wait(0.1)
			updateHitbox()
		end
	end)
end