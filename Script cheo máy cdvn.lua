--// Anti-AFK GUI Toggle Script by Vinh
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Tạo GUI nhỏ
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "AntiAFKGui"
ScreenGui.Parent = game.CoreGui

ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 140, 0, 35)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Text = "Anti-AFK: OFF"

-- Biến điều khiển
local AntiAFK_Enabled = false
local Connection
local DelaySeconds = 5 -- Thời gian đợi trước khi treo máy

-- Bật/tắt khi nhấn nút
ToggleButton.MouseButton1Click:Connect(function()
    AntiAFK_Enabled = not AntiAFK_Enabled
    
    if AntiAFK_Enabled then
        ToggleButton.Text = "Đợi " .. DelaySeconds .. "s..."
        
        -- Đếm ngược
        for i = DelaySeconds, 1, -1 do
            ToggleButton.Text = "Bắt đầu sau: " .. i .. "s"
            wait(1)
        end
        
        ToggleButton.Text = "Anti-AFK: ON"

        Connection = LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    else
        ToggleButton.Text = "Anti-AFK: OFF"
        if Connection then
            Connection:Disconnect()
        end
    end
end)