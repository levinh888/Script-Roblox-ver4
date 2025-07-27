local HhiKzlEu = game:GetService("Players")
local DbLHKDlo = game:GetService("RunService")
local IWOwfbgt = HhiKzlEu.LocalPlayer
local RHmHiIJJ = IWOwfbgt.Character or IWOwfbgt.CharacterAdded:Wait()
local WVZlhXIe = RHmHiIJJ:WaitForChild("HumanoidRootPart")

IWOwfbgt.CharacterAdded:Connect(function(char)
RHmHiIJJ = char
WVZlhXIe = char:WaitForChild("HumanoidRootPart")
end)

local FdeGtDaP = Instance.new("ScreenGui", game.CoreGui)
FdeGtDaP.Name = "KeyGUI"

local hNpYHtvn = Instance.new("Frame", FdeGtDaP)
hNpYHtvn.Size = UDim2.new(0, 300, 0, 160)
hNpYHtvn.Position = UDim2.new(0.5, -150, 0.5, -80)
hNpYHtvn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
hNpYHtvn.BorderSizePixel = 0

local FVHKHbkM = Instance.new("TextLabel", hNpYHtvn)
FVHKHbkM.Size = UDim2.new(1, 0, 0, 30)
FVHKHbkM.Text = "🔐 Nhập Key để mở GUI"
FVHKHbkM.TextColor3 = Color3.new(1,1,1)
FVHKHbkM.BackgroundTransparency = 1
FVHKHbkM.Font = Enum.Font.GothamBold
FVHKHbkM.TextSize = 16

local VMOYvagN = Instance.new("TextBox", hNpYHtvn)
VMOYvagN.Size = UDim2.new(1, -40, 0, 30)
VMOYvagN.Position = UDim2.new(0, 20, 0, 50)
VMOYvagN.PlaceholderText = "Nhập key tại đây..."
VMOYvagN.TextColor3 = Color3.new(1,1,1)
VMOYvagN.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
VMOYvagN.Font = Enum.Font.Gotham
VMOYvagN.TextSize = 14

local QkAwxdIV = Instance.new("TextButton", hNpYHtvn)
QkAwxdIV.Size = UDim2.new(1, -40, 0, 30)
QkAwxdIV.Position = UDim2.new(0, 20, 0, 100)
QkAwxdIV.Text = "✅ Xác nhận"
QkAwxdIV.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
QkAwxdIV.TextColor3 = Color3.new(1,1,1)
QkAwxdIV.Font = Enum.Font.GothamBold
QkAwxdIV.TextSize = 14

local ijrMwEvE = Instance.new("ScreenGui")
ijrMwEvE.Name = "CircleRotateGUI"
ijrMwEvE.Enabled = false

local ibsaYIQc = Instance.new("TextButton", ijrMwEvE)
ibsaYIQc.Size = UDim2.new(0, 200, 0, 40)
ibsaYIQc.Position = UDim2.new(0, 20, 0.5, -100)
ibsaYIQc.Text = "▶️ Quay Vòng Tròn"
ibsaYIQc.BackgroundColor3 = Color3.fromRGB(50, 70, 120)
ibsaYIQc.TextColor3 = Color3.new(1, 1, 1)
ibsaYIQc.Font = Enum.Font.GothamBold
ibsaYIQc.TextSize = 14

local ZoOHJPPF = Instance.new("TextBox", ijrMwEvE)
ZoOHJPPF.Size = UDim2.new(0, 200, 0, 30)
ZoOHJPPF.Position = UDim2.new(0, 20, 0.5, -60)
ZoOHJPPF.Text = "3"
ZoOHJPPF.PlaceholderText = "Tốc độ góc (rad/s)"
ZoOHJPPF.TextColor3 = Color3.new(1, 1, 1)
ZoOHJPPF.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
ZoOHJPPF.ClearTextOnFocus = false

local qmhTxBvo = Instance.new("TextBox", ijrMwEvE)
qmhTxBvo.Size = UDim2.new(0, 200, 0, 30)
qmhTxBvo.Position = UDim2.new(0, 20, 0.5, -20)
qmhTxBvo.Text = "21"
qmhTxBvo.PlaceholderText = "Bán kính quay"
qmhTxBvo.TextColor3 = Color3.new(1, 1, 1)
qmhTxBvo.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
qmhTxBvo.ClearTextOnFocus = false

local DHJwqWEq = Instance.new("TextLabel", ijrMwEvE)
DHJwqWEq.Size = UDim2.new(0, 220, 0, 30)
DHJwqWEq.Position = UDim2.new(1, -240, 0, 20)
DHJwqWEq.AnchorPoint = Vector2.new(0, 0)
DHJwqWEq.Text = "Máu Boss: Đang tìm..."
DHJwqWEq.TextColor3 = Color3.fromRGB(255, 80, 80)
DHJwqWEq.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DHJwqWEq.Font = Enum.Font.GothamBold
DHJwqWEq.TextSize = 14
DHJwqWEq.TextXAlignment = Enum.TextXAlignment.Left
DHJwqWEq.BorderSizePixel = 0

local eQSTrIOx = "NPC2"
local WhgPVTNW = tonumber(qmhTxBvo.Text) or 21
local qrGPTfLI = tonumber(ZoOHJPPF.Text) or 3
local NcaHRAFY = 65

local SatqARZZ = nil
local ccFRfAJy = false
local lwbzyReB = 0
local UkXwqYpB = nil
local JbHZFdHA = 0
local EvEhTRef = 0.3

local function pDyFAHzy()
for _, obj in pairs(workspace:GetDescendants()) do
if obj:IsA("Model") and obj.Name == eQSTrIOx and obj:FindFirstChild("HumanoidRootPart") then
return obj
end
end
return nil
end

local CszYSBgN = Instance.new("BodyVelocity")
CszYSBgN.Name = "VelocityMover"
CszYSBgN.MaxForce = Vector3.new(1e6, 0, 1e6)
CszYSBgN.P = 1500
CszYSBgN.Velocity = Vector3.zero

local function ZDrybyHO()
local twfjgBfn = RHmHiIJJ:FindFirstChildOfClass("Tool")
if twfjgBfn and tick() - JbHZFdHA > EvEhTRef then
JbHZFdHA = tick()
coroutine.wrap(function()
pcall(function() twfjgBfn:Activate() end)
end)()
end
end

local lhLcmFje = 0
local OeWcalWS = 0.2

DbLHKDlo.RenderStepped:Connect(function(EaGywFTu)
if ccFRfAJy and WVZlhXIe then
lhLcmFje += EaGywFTu
if lhLcmFje >= OeWcalWS then
lhLcmFje = 0
if SatqARZZ and SatqARZZ:FindFirstChild("HumanoidRootPart") then
UkXwqYpB = SatqARZZ.HumanoidRootPart.Position
end
end

lwbzyReB += qrGPTfLI * EaGywFTu
local x = math.cos(lwbzyReB) * WhgPVTNW
local z = math.sin(lwbzyReB) * WhgPVTNW
local gxFgdCVn = UkXwqYpB + Vector3.new(x, 0, z)

local current = WVZlhXIe.Position
local vdoqhRvT = (gxFgdCVn - current).Unit
local WNXMaDpn = vdoqhRvT * NcaHRAFY
CszYSBgN.Velocity = Vector3.new(WNXMaDpn.X, 0, WNXMaDpn.Z)

if SatqARZZ and SatqARZZ:FindFirstChild("HumanoidRootPart") then
local FUimlQbJ = SatqARZZ.HumanoidRootPart.Position + Vector3.new(0, 1.5, 0)
WVZlhXIe.CFrame = CFrame.new(WVZlhXIe.Position, FUimlQbJ)
ZDrybyHO()
end

if SatqARZZ and SatqARZZ:FindFirstChild("Humanoid") then
local zFdpYrWm = SatqARZZ.Humanoid.Health
local mhcKDEyu = SatqARZZ.Humanoid.MaxHealth
DHJwqWEq.Text = string.format("Máu Boss: %d / %d", zFdpYrWm, mhcKDEyu)
else
DHJwqWEq.Text = "Máu Boss: Đang tìm..."
end

else
CszYSBgN.Velocity = Vector3.zero
DHJwqWEq.Text = "Máu Boss: Đang tìm..."
end

end)

ibsaYIQc.MouseButton1Click:Connect(function()
qrGPTfLI = tonumber(ZoOHJPPF.Text) or qrGPTfLI
WhgPVTNW = tonumber(qmhTxBvo.Text) or WhgPVTNW
ccFRfAJy = not ccFRfAJy

if ccFRfAJy then
SatqARZZ = pDyFAHzy()
if SatqARZZ then
UkXwqYpB = SatqARZZ.HumanoidRootPart.Position
ibsaYIQc.Text = "⏸ Đang quay quanh Boss..."
ibsaYIQc.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
CszYSBgN.Parent = WVZlhXIe
else
ibsaYIQc.Text = "❌ Không tìm thấy " .. eQSTrIOx
ccFRfAJy = false
end
else
ibsaYIQc.Text = "▶️ Quay Vòng Tròn"
ibsaYIQc.BackgroundColor3 = Color3.fromRGB(50, 70, 120)
CszYSBgN.Velocity = Vector3.zero
CszYSBgN.Parent = nil
end

end)

QkAwxdIV.MouseButton1Click:Connect(function()
if VMOYvagN.Text == "free188y" then
FdeGtDaP:Destroy()
ijrMwEvE.Parent = game.CoreGui
ijrMwEvE.Enabled = true
else
FVHKHbkM.Text = "❌ Sai key! Vui lòng thử lại."
FVHKHbkM.TextColor3 = Color3.fromRGB(255, 80, 80)
end
end)

