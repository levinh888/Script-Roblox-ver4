-- 📌 Auto Attack + Spin around NPC2 | Obfuscated Version 🧪

local R, P, L = game:GetService("RunService"), game:GetService("Players"), game:GetService("UserInputService")
local plr, chr = P.LocalPlayer, P.LocalPlayer.Character or P.LocalPlayer.CharacterAdded:Wait()
local h = chr:WaitForChild("HumanoidRootPart")
local r, s = 18.9, 1.87

local a = 0
local function G()
    local c, d = nil, math.huge
    for _, m in pairs(workspace:GetDescendants()) do
        if m:IsA("Model") and m.Name == "NPC2" and m:FindFirstChild("HumanoidRootPart") then
            local dis = (m.HumanoidRootPart.Position - h.Position).Magnitude
            if dis < d then c, d = m, dis end
        end
    end
    return c
end

local function A()
    local t = tick()
    while task.wait(0.08) do
        if not plr.Character then continue end
        local tool = plr.Character:FindFirstChildOfClass("Tool")
        if tool then
            local act = tool:FindFirstChild("Activate")
            if act and typeof(act) == "Function" then
                act:Invoke()
            else
                tool:Activate()
            end
        end
    end
end

task.spawn(A)

R.RenderStepped:Connect(function(d)
    local n = G()
    if n then
        a += s * d
        local X, Z = math.cos(a) * r, math.sin(a) * r
        local p = n.HumanoidRootPart.Position
        h.CFrame = CFrame.new(p + Vector3.new(X, 0, Z), p)
    end
end)