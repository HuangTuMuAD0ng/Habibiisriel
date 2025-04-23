if typeof(boostfps) ~= "boolean" then
    warn("⚠️ Bạn chưa khai báo biến boostfps = true hoặc false trước khi chạy script.")
    return
end

local plr = game.Players.LocalPlayer
local ws = game.Workspace
local lighting = game.Lighting

local boosted = false
local boostGui = nil

local function restore()
    if boostGui then
        boostGui:Destroy()
        boostGui = nil
    end
    print("🔄 Đã tắt Boost FPS. Khôi phục mặc định.")
end

local function boost()
    local handledInstances = {}

    local function isCharacter(model)
        return model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart")
    end

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
        end
    end

    for _, v in pairs(game:GetDescendants()) do
        handleInstance(v)
    end

    ws.DescendantAdded:Connect(handleInstance)
    game.DescendantAdded:Connect(handleInstance)
    lighting.DescendantAdded:Connect(handleInstance)

    for _, obj in pairs(ws:GetChildren()) do
        if (obj:IsA("Model") or obj:IsA("Folder")) and not isCharacter(obj) then
            obj:Destroy()
        end
    end

    pcall(function()
        game:GetService("UserSettings").GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)

    boostGui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
    boostGui.IgnoreGuiInset = true
    local white = Instance.new("Frame", boostGui)
    white.Size = UDim2.new(1, 0, 1, 0)
    white.BackgroundColor3 = Color3.new(1, 1, 1)

    task.delay(10, function()
        if boostGui then boostGui:Destroy() end
    end)

    print("✅ Boost FPS đã được bật.")
end

-- Kích hoạt
if boostfps then
    if not boosted then
        boosted = true
        boost()
    end
else
    if boosted then
        boosted = false
        restore()
    end
end
