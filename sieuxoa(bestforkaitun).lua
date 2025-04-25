local Players = game:GetService("Players")

-- Làm gọn NPC và Người chơi, xóa animation và hành vi
local function minimalizeCharacter(char)
	if not char or not char:IsA("Model") then return end

	-- Xoá phụ kiện, quần áo, và body color
	for _, item in ipairs(char:GetChildren()) do
		if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") then
			item:Destroy()
		end
	end

	-- Xóa animation (cả animation controller và script)
	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("Animator") or obj:IsA("AnimationController") or obj:IsA("Animation") then
			obj:Destroy()
		end
	end

	-- Xóa hành vi (AI scripts, các script điều khiển NPC/Player)
	for _, script in ipairs(char:GetDescendants()) do
		if script:IsA("Script") or script:IsA("LocalScript") then
			script:Destroy()
		end
	end

	-- Làm trơn các phần cơ thể, bỏ phụ kiện và giảm chi tiết
	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			part.Material = Enum.Material.SmoothPlastic
			part.Color = Color3.fromRGB(128, 128, 128) -- Màu xám
			part.Transparency = 1 -- Ẩn NPC và người chơi hoàn toàn (hoặc để Transparency = 0 để nhân vật có thể nhìn thấy nhưng ít chi tiết)
		end
	end
end

-- Quét NPC và người chơi
local function cleanAllCharacters()
	for _, char in ipairs(workspace:GetDescendants()) do
		if char:IsA("Model") then
			local humanoid = char:FindFirstChild("Humanoid")
			if humanoid then
				if Players:GetPlayerFromCharacter(char) then
					-- Làm gọn người chơi
					minimalizeCharacter(char)
				else
					-- Làm gọn NPC
					minimalizeCharacter(char)
				end
			end
		end
	end
end

-- Lặp lại để xử lý NPC và người chơi mới
while task.wait(3) do
	pcall(cleanAllCharacters)
end
