local plr = game.Players.LocalPlayer
local ws = game.Workspace
local lighting = game.Lighting
-- Kiểm tra model là nhân vật hoặc NPC
local function isCharacter(model)
	return model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart")
end

-- Danh sách các đối tượng đã xử lý
local handledInstances = {}

-- Xử lý đối tượng khi vừa được thêm vào
local function handleInstance(v)
	if handledInstances[v] then return end
	handledInstances[v] = true

	if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Explosion")
	or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Beam")
	or v:IsA("Highlight") or v:IsA("SelectionBox")
	or v:IsA("BillboardGui") or v:IsA("SurfaceGui")
	or v:IsA("Decal") or v:IsA("Texture") then
		v:Destroy()
	elseif v:IsA("Sound") then
		v.Volume = 0
	elseif v:IsA("BasePart") and not isCharacter(v.Parent) then
		v.Material = Enum.Material.SmoothPlastic
		v.Transparency = 1
		v.CanCollide = false
	elseif v:IsA("Animator") then
		for _, track in pairs(v:GetPlayingAnimationTracks()) do
			track:Stop()
		end
	elseif v:IsA("Animation") or v:IsA("AnimationController") then
		v:Destroy()
	elseif v:IsA("Script") and v.Name == "Animate" then
		v:Destroy()
	end
end

-- Màn hình trắng toàn bộ
local function createWhiteScreen()
	local screenGui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
	screenGui.IgnoreGuiInset = true

	local whiteFrame = Instance.new("Frame")
	whiteFrame.Size = UDim2.new(1, 0, 1, 0)
	whiteFrame.Position = UDim2.new(0, 0, 0, 0)
	whiteFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	whiteFrame.BackgroundTransparency = 0
	whiteFrame.BorderSizePixel = 0
	whiteFrame.Parent = screenGui

end

-- Làm sạch giao diện
local function hideUI()
	for _, gui in pairs(plr.PlayerGui:GetChildren()) do
		if gui:IsA("ScreenGui") then
			gui.Enabled = false
		end
	end
end

-- Làm sạch ánh sáng
local function cleanLighting()
	for _, v in pairs(lighting:GetChildren()) do
		if not v:IsA("Sky") then
			v:Destroy()
		end
	end
	lighting.FogEnd = 1e10
	lighting.GlobalShadows = false
	lighting.Brightness = 0
end

-- Tối giản camera
local function cleanCamera()
	local cam = workspace.CurrentCamera
	if cam then
		cam.FieldOfView = 70
		cam:ClearAllChildren()
	end
end

-- Xóa mô hình không cần thiết
local function cleanEnvironment()
	for _, obj in pairs(ws:GetChildren()) do
		if (obj:IsA("Model") or obj:IsA("Folder")) and not isCharacter(obj) then
			local n = obj.Name:lower()
			if n:find("tree") or n:find("cloud") or n:find("building")
			or n:find("island") or n:find("sea") or n:find("water")
			or n:find("rock") or n:find("structure") or n:find("ship") then
				obj:Destroy()
			end
		end
	end
end

-- Tối ưu nhân vật
local function cleanCharacter(char)
	if not char then return end
	local animate = char:FindFirstChild("Animate")
	if animate then animate:Destroy() end

	local humanoid = char:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if animator then
			for _, track in pairs(animator:GetPlayingAnimationTracks()) do
				track:Stop()
			end
		end
	end

	for _, v in pairs(char:GetDescendants()) do
		if v:IsA("Animation") or v:IsA("AnimationController")
		or v:IsA("Decal") or v:IsA("Texture") then
			v:Destroy()
		end
	end
end

-- Theo dõi object mới
game.DescendantAdded:Connect(handleInstance)
ws.DescendantAdded:Connect(handleInstance)
lighting.DescendantAdded:Connect(handleInstance)

-- Hàm chính
local function globalBoost()
	-- Hạ chất lượng
	pcall(function()
		game:GetService("UserSettings").GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
	end)

	-- Dọn dẹp
	for _, v in pairs(game:GetDescendants()) do
		handleInstance(v)
	end
	cleanEnvironment()
	hideUI()
	cleanLighting()
	cleanCamera()
	createWhiteScreen()
end

-- Khởi động nếu bật boostfps
if boostfps then
	globalBoost()
	if plr.Character then cleanCharacter(plr.Character) end
	plr.CharacterAdded:Connect(cleanCharacter)
	print("✅ Boost FPS đã bật!")
else
	print("⚠️ Boost FPS đang tắt.")
end
