--// 👹 WOKINGLOG 👹 Menu – Tự động đánh | Quay quanh NPC2 | Hiển thị máu | GUI Xanh
local a=game:GetService("Players")local b=game:GetService("RunService")local c=a.LocalPlayer
local d=game:GetService("VirtualInputManager")local e=false local f=false local g="NPC2"
local h=Instance.new("ScreenGui")local i=Instance.new("Frame")local j=Instance.new("TextButton")
local k=Instance.new("TextLabel")local l=Instance.new("TextButton")local m=Instance.new("TextLabel")

h.Name="👹 WOKINGLOG 👹"h.Parent=game.CoreGui
i.Size=UDim2.new(0,250,0,180)i.Position=UDim2.new(0,20,0.5,-90)
i.BackgroundColor3=Color3.fromRGB(0, 170, 255)i.BackgroundTransparency=0.1
i.BorderSizePixel=0 i.Active=true i.Draggable=true i.Parent=h

k.Text="👹 MENU WOKINGLOG 👹"k.Size=UDim2.new(1,0,0,30)
k.BackgroundColor3=Color3.fromRGB(0,130,220)k.TextColor3=Color3.new(1,1,1)
k.Font=Enum.Font.GothamBold k.TextScaled=true k.Parent=i

j.Text="▶️ Quay quanh NPC"j.Size=UDim2.new(0.9,0,0,40)j.Position=UDim2.new(0.05,0,0.25,0)
j.BackgroundColor3=Color3.fromRGB(0,100,200)j.TextColor3=Color3.new(1,1,1)
j.Font=Enum.Font.GothamBold j.TextScaled=true j.Parent=i

l.Text="⚔️ Tự đánh + Hiển thị máu"l.Size=UDim2.new(0.9,0,0,40)l.Position=UDim2.new(0.05,0,0.55,0)
l.BackgroundColor3=Color3.fromRGB(0,100,200)l.TextColor3=Color3.new(1,1,1)
l.Font=Enum.Font.GothamBold l.TextScaled=true l.Parent=i

m.Text="👹 WOKINGLOG 👹"m.Size=UDim2.new(1,0,0,30)m.Position=UDim2.new(0,0,1,-30)
m.BackgroundColor3=Color3.fromRGB(0,150,250)m.TextColor3=Color3.new(1,1,1)
m.Font=Enum.Font.GothamBold m.TextScaled=true m.Parent=i

--// Quay quanh bằng CFrame
b.RenderStepped:Connect(function()
	if e then
		local n=c.Character if n and n:FindFirstChild("HumanoidRootPart")then
			local o=workspace:FindFirstChild(g)
			if o and o:FindFirstChild("HumanoidRootPart")then
				local p=n.HumanoidRootPart
				local q=(p.Position-o.HumanoidRootPart.Position).Magnitude
				local r=Vector3.new(math.cos(tick())*q,0,math.sin(tick())*q)
				p.CFrame=CFrame.new(o.HumanoidRootPart.Position+r,o.HumanoidRootPart.Position)
			end
		end
	end
end)

--// Tự đánh nếu có vũ khí + hiện máu
b.RenderStepped:Connect(function()
	if f then
		local n=c.Character if n then
			local s=n:FindFirstChildOfClass("Tool")
			if s then
				d:SendMouseButtonEvent(0,0,0,true,game,0)
				wait()
				d:SendMouseButtonEvent(0,0,0,false,game,0)
			end
			local o=workspace:FindFirstChild(g)
			if o and o:FindFirstChild("Humanoid")then
				local t=o.Humanoid
				game.StarterGui:SetCore("ChatMakeSystemMessage",{
					Text="👹 HP BOSS: "..math.floor(t.Health).."/"..math.floor(t.MaxHealth),
					Color=Color3.fromRGB(255,50,50),
					Font=Enum.Font.SourceSansBold,
					FontSize=Enum.FontSize.Size24
				})
			end
		end
	end
end)

--// Bật nút
j.MouseButton1Click:Connect(function()
	e=not e
	j.Text=e and "⏸️ Dừng quay"or"▶️ Quay quanh NPC"
end)
l.MouseButton1Click:Connect(function()
	f=not f
	l.Text=f and "⏸️ Dừng đánh/hiển thị máu"or"⚔️ Tự đánh + Hiển thị máu"
end)