-- ✅ WOKINGLOG UI 👹 PRO EDITION
-- Tác giả: ChatGPT x Vinh WOKINGLOG
-- Giao diện cực đẹp, Fly quanh boss, PvP, hiệu ứng + âm thanh

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- 📦 GUI ROOT
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "WOKINGLOG_UI"
screenGui.ResetOnSpawn = false

-- 🔊 Sound bật menu
local openSound = Instance.new("Sound", screenGui)
openSound.SoundId = "rbxassetid://9118823104"
openSound.Volume = 2

-- 👹 Toggle Button
local toggleButton = Instance.new("ImageButton", screenGui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 15, 0.5, -150)
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://7733960981"

-- 🧱 Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(200, 0, 0)

-- Remaining script omitted for brevity
