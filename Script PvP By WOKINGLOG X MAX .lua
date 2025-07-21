--[[👑 BY VINH - SCRIPT ĐÃ RỐI]]
local __𝕍 = "CHUCMUNG1KFLO"
local g=game
local s=g:GetService("Players")
local l=s.LocalPlayer
local c=g:GetService("CoreGui")

local function 🧠(a,b)
	local d=Instance.new(a)
	for i,v in pairs(b) do d[i]=v end
	return d
end

local 💀=🧠("ScreenGui",{Name="UI_",Parent=c})
local 🪟=🧠("Frame",{Parent=💀,Size=UDim2.new(0,300,0,150),Position=UDim2.new(0.5,-150,0.5,-75),BackgroundColor3=Color3.fromRGB(30,30,30)})
🧠("UICorner",{Parent=🪟})
local 🔐=🧠("TextBox",{Parent=🪟,Text="",PlaceholderText="MẬT KHẨU:",Size=UDim2.new(0.8,0,0.3,0),Position=UDim2.new(0.1,0,0.2,0),TextScaled=true,ClearTextOnFocus=false,BackgroundColor3=Color3.fromRGB(50,50,50),TextColor3=Color3.fromRGB(255,255,255)})
🧠("UICorner",{Parent=🔐})
local 🆗=🧠("TextButton",{Parent=🪟,Text="[ XÁC NHẬN ]",Size=UDim2.new(0.8,0,0.3,0),Position=UDim2.new(0.1,0,0.6,0),BackgroundColor3=Color3.fromRGB(0,170,255),TextScaled=true})
🧠("UICorner",{Parent=🆗})

🆗.MouseButton1Click:Connect(function()
	if 🔐.Text==__𝕍 then
		💀:Destroy()
		load🧠()
	else
		🆗.Text="SAI MẬT KHẨU!"
	end
end)

function load🧠()
	local 🧊=🧠("ScreenGui",{Parent=c,Name="🧊Main"})
	local 📦=🧠("Frame",{Parent=🧊,Size=UDim2.new(0,230,0,350),Position=UDim2.new(0,10,0.5,-175),BackgroundColor3=Color3.fromRGB(40,40,40)})
	🧠("UICorner",{Parent=📦})
	local 📚=🧠("UIListLayout",{Parent=📦,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center})

	local function 🧩(txt,f)
		local b=🧠("TextButton",{Parent=📦,Text=txt,Size=UDim2.new(0.9,0,0,35),BackgroundColor3=Color3.fromRGB(70,130,180),TextColor3=Color3.new(1,1,1),TextScaled=true})
		🧠("UICorner",{Parent=b})
		b.MouseButton1Click:Connect(f)
	end

	local ⚡,🌪,🎯,🔫=false,false,false,false

	🧩("TỰ NHẢY",function()
		⚡=not ⚡
		while ⚡ do wait(1)
			pcall(function()l.Character.Humanoid.Jump=true end)
		end
	end)

	🧩("TỰ NHẢY LIÊN TỤC",function()
		🌪=not 🌪
		while 🌪 do wait(0.1)
			pcall(function()l.Character.Humanoid.Jump=true end)
		end
	end)

	🧩("TỰ ĐÁNH",function()
		🎯=not 🎯
		while 🎯 do wait(0.1)
			mouse1click()
		end
	end)

	🧩("TỰ ĐÁNH CÓ VŨ KHÍ",function()
		🔫=not 🔫
		while 🔫 do wait(0.1)
			local t=l.Character and l.Character:FindFirstChildOfClass("Tool")
			if t then mouse1click() end
		end
	end)

	🧩("PC – NHÌN NHƯ PC",function()
		l.CameraMaxZoomDistance=100
		l.CameraMinZoomDistance=5
	end)

	🧩("HIỂN THỊ MÁU",function()
		for _,p in pairs(s:GetPlayers()) do
			if p~=l and p.Character then
				local h=p.Character:FindFirstChild("Head")
				if h then
					local b=🧠("BillboardGui",{Parent=h,Size=UDim2.new(5,0,1,0),Adornee=h,AlwaysOnTop=true})
					local t=🧠("TextLabel",{Parent=b,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,TextColor3=Color3.new(1,0,0),TextScaled=true})
					game:GetService("RunService").Heartbeat:Connect(function()
						if p.Character and p.Character:FindFirstChild("Humanoid") then
							t.Text="❤️ "..math.floor(p.Character.Humanoid.Health)
						end
					end)
				end
			end
		end
	end)

	🧩("ESP TOÀN SERVER",function()
		for _,p in pairs(s:GetPlayers()) do
			if p~=l and p.Character then
				local h=p.Character:FindFirstChild("Head")
				if h then
					local b=🧠("BillboardGui",{Parent=h,Size=UDim2.new(5,0,1,0),Adornee=h,AlwaysOnTop=true})
					local t=🧠("TextLabel",{Parent=b,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,TextColor3=Color3.fromRGB(0,255,0),TextScaled=true,Text=p.Name})
				end
			end
		end
	end)

	local 👾=🧠("TextButton",{Parent=🧊,Text="👾",Size=UDim2.new(0,40,0,40),Position=UDim2.new(0,5,0,5),BackgroundColor3=Color3.fromRGB(100,100,100)})
	🧠("UICorner",{Parent=👾})
	👾.MouseButton1Click:Connect(function()
		📦.Visible=not 📦.Visible
	end)
end