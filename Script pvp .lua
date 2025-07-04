-- Load giao diện Redz UI V2
loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/main/UiREDzV2.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local Window = MakeWindow({
    Hub = {
        Title = "WOKINGLOG 👹",
        Animation = "Youtube: WOKINGLOG 👹"
    },
    Key = {
        KeySystem = false,
        Title = "Key System",
        Description = "",
        KeyLink = "",
        Keys = {"1234"},
        Notifi = {
            Notifications = true,
            CorrectKey = "Running the Script...",
            Incorrectkey = "The key is incorrect",
            CopyKeyLink = "Copied to Clipboard"
        }
    }
})

-- Tabs
local TabFarm = MakeTab({ Name = "Script Farm" })
local TabBoss = MakeTab({ Name = "Boss Hunter 👹" })
local TabPvP = MakeTab({ Name = "PvP" })
local TabSpeed = MakeTab({ Name = "Speed 🚀" })

-- Farm Script
AddButton(TabFarm, {
    Name = "Redz Hub",
    Callback = function()
        local Settings = { JoinTeam = "Pirates", Translator = true }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/main/Source.lua"))(Settings)
    end
})

-- Boss Script
AddButton(TabBoss, {
    Name = "🔥 Bật Script OutFram Boss Bá Đạo",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/levinh888/Script-ver4/main/script%20framboss%20b%C3%A1%20.lua"))()
    end
})

-- PvP Features
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

-- Speed bằng BodyVelocity + WalkSpeed kết hợp
local currentSpeed = 50
local speedBV = nil
local speedEnabled = false
local walkSpeedEnabled = false

AddToggle(TabSpeed, {
    Name = "🚀 Bật Speed Kết Hợp (WalkSpeed + BodyVelocity)",
    Callback = function(state)
        speedEnabled = state
        local hum = Character:FindFirstChildOfClass("Humanoid")
        local hrp = Character:FindFirstChild("HumanoidRootPart")
        if hum then hum.WalkSpeed = state and math.min(currentSpeed, 30) or 16 end

        if state then
            if not speedBV then
                speedBV = Instance.new("BodyVelocity")
                speedBV.MaxForce = Vector3.new(1e5, 0, 1e5)
                speedBV.Velocity = Vector3.zero
                speedBV.P = 10000
                speedBV.Name = "SafeSpeedBV"
                speedBV.Parent = hrp
            end

            RunService.Stepped:Connect(function()
                if speedEnabled and Character and hum then
                    local moveDir = hum.MoveDirection
                    speedBV.Velocity = moveDir * currentSpeed
                elseif speedBV then
                    speedBV.Velocity = Vector3.zero
                end
            end)
        else
            if speedBV then
                speedBV:Destroy()
                speedBV = nil
            end
        end
    end
})

AddSlider(TabSpeed, {
    Name = "⚙️ Tùy chỉnh tốc độ",
    Min = 10,
    Max = 100,
    Default = 50,
    Callback = function(val)
        currentSpeed = val
        local hum = Character:FindFirstChildOfClass("Humanoid")
        if hum and speedEnabled then
            hum.WalkSpeed = math.min(val, 30)
        end
    end
})
