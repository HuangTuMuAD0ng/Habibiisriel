print("Script Made By Koha")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

boostfps = boostfps or false -- Bật/tắt boost FPS từ bên ngoài
local HIDE_LEADERBOARD = true -- Bật/tắt ẩn leaderboard
-- Function to hide last 10 characters of player name
local function hidePlayerName(name)
    if #name <= 10 then
        return string.sub(name, 1, 1) .. string.rep("*", #name - 1)
    else
        return string.sub(name, 1, #name - 10) .. string.rep("*", 10)
    end
end
-- Ẩn leaderboard
local function hideLeaderboard()
    local function applyCover(parent)
        if not parent then return end
        
        -- Xóa cover cũ nếu có
        local oldCover = parent:FindFirstChild("LeaderboardCover")
        if oldCover then oldCover:Destroy() end

        -- Tạo cover mới
        local cover = Instance.new("Frame")
        cover.Name = "LeaderboardCover"
        cover.Size = UDim2.new(1, 0, 1, 0)
        cover.Position = UDim2.new(0, 0, 0, 0)
        cover.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        cover.BackgroundTransparency = 0.3
        cover.BorderSizePixel = 0
        cover.ZIndex = 1000
        
        -- Góc bo tròn
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = cover
        
        -- Hiệu ứng bóng
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Image = "rbxassetid://1316045217"
        shadow.ImageColor3 = Color3.new(0, 0, 0)
        shadow.ImageTransparency = 0.5
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.Size = UDim2.new(1, 10, 1, 10)
        shadow.Position = UDim2.new(0, -5, 0, -5)
        shadow.BackgroundTransparency = 1
        shadow.ZIndex = cover.ZIndex - 1
        shadow.Parent = cover
        
        -- Thông báo
        local label = Instance.new("TextLabel")
        label.Text = "LEADERBOARD\n(Đã được ẩn)"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextWrapped = true
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0.9, 0, 0.9, 0)
        label.Position = UDim2.new(0.05, 0, 0.05, 0)
        label.ZIndex = cover.ZIndex + 1
        label.Parent = cover
        
        cover.Parent = parent
    end

    -- Tìm leaderboard ở các vị trí khác nhau
    local leaderboard = game:GetService("CoreGui"):FindFirstChild("LeaderboardGui") or
                      game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("LeaderboardGui")

    if leaderboard then
        applyCover(leaderboard)
    end

    -- Theo dõi nếu leaderboard được thêm sau
    game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(function(child)
        if child.Name == "LeaderboardGui" and HIDE_LEADERBOARD then
            task.wait(1) -- Đợi leaderboard khởi tạo xong
            applyCover(child)
        end
    end)
end

-- Bật chế độ ẩn leaderboard nếu được kích hoạt
if HIDE_LEADERBOARD then
    hideLeaderboard()
end

--- IMPROVED NOTIFICATION SYSTEM ---
local notificationActive = {}
local notificationOffset = 0
local notificationSpacing = 100

local function createNotifier()
    local NotifyGui = Instance.new("ScreenGui")
    NotifyGui.Name = "KohaNotifier_" .. math.random(10000,99999)
    NotifyGui.Parent = game:GetService("CoreGui")
    NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    NotifyGui.ResetOnSpawn = false

    local function notify(title, text, duration, buttons)
        duration = duration or (buttons and nil or 5)
        
        -- Create notification frame
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification_" .. math.random(10000,99999)
        Notification.Parent = NotifyGui
        Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        Notification.BackgroundTransparency = 0.2
        Notification.BorderSizePixel = 0
        Notification.Position = UDim2.new(1, 30, 1, -120 - notificationOffset)
        Notification.Size = buttons and UDim2.new(0, 200, 0, 100) or UDim2.new(0, 220, 0, 80)
        Notification.ZIndex = 1000 + #notificationActive * 10
        
        -- Update offset for next notification
        notificationOffset = notificationOffset + notificationSpacing
        
        -- Add to active notifications
        table.insert(notificationActive, Notification)
        
        -- Corner radius
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = Notification
        
        -- Shadow
        local Shadow = Instance.new("ImageLabel")
        Shadow.Name = "Shadow"
        Shadow.Image = "rbxassetid://1316045217"
        Shadow.ImageColor3 = Color3.new(0, 0, 0)
        Shadow.ImageTransparency = 0.7
        Shadow.ScaleType = Enum.ScaleType.Slice
        Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        Shadow.Size = UDim2.new(1, 14, 1, 14)
        Shadow.Position = UDim2.new(0, -7, 0, -7)
        Shadow.BackgroundTransparency = 1
        Shadow.Parent = Notification
        Shadow.ZIndex = Notification.ZIndex - 1
        
        -- Title
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.Parent = Notification
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0, 15, 0, 10)
        TitleLabel.Size = UDim2.new(1, -30, 0, 24)
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Text = string.upper(title)
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.TextSize = 16
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.ZIndex = Notification.ZIndex + 1
        
        -- Text content
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "Text"
        TextLabel.Parent = Notification
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.new(0, 15, 0, 40)
        TextLabel.Size = UDim2.new(1, -30, buttons and 0.4 or 1, buttons and -50 or -50)
        TextLabel.Font = Enum.Font.GothamMedium
        TextLabel.Text = text
        TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        TextLabel.TextSize = 14
        TextLabel.TextWrapped = true
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.ZIndex = Notification.ZIndex + 1
        
        -- Buttons
        if buttons then
            local buttonFrame = Instance.new("Frame")
            buttonFrame.BackgroundTransparency = 1
            buttonFrame.Size = UDim2.new(1, -20, 0.3, 0)
            buttonFrame.Position = UDim2.new(0, 10, 0.65, 0)
            buttonFrame.Parent = Notification
            buttonFrame.ZIndex = Notification.ZIndex + 1
            
            for i, btn in pairs(buttons) do
                local button = Instance.new("TextButton")
                button.Name = "Btn_" .. btn.text
                button.Text = btn.text
                button.Size = UDim2.new(0.45, 0, 1, -6)
                button.Position = UDim2.new((i-1)*0.5 + 0.025, 0, 0, 3)
                button.BackgroundColor3 = btn.color or Color3.fromRGB(40, 40, 50)
                button.BackgroundTransparency = 0.2
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.Font = Enum.Font.GothamBold
                button.TextSize = 13
                button.Parent = buttonFrame
                button.ZIndex = Notification.ZIndex + 2
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 8)
                buttonCorner.Parent = button
                
                button.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.1,
                        Size = UDim2.new(0.46, 0, 1.05, -4)
                    }):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.2,
                        Size = UDim2.new(0.45, 0, 1, -6)
                    }):Play()
                end)
                
                button.MouseButton1Click:Connect(function()
                    btn.callback()
                    if not duration then
                        local hideTween = TweenService:Create(Notification, TweenInfo.new(0.3), {
                            Position = UDim2.new(1, 30, 1, Notification.Position.Y.Offset)
                        })
                        hideTween:Play()
                        hideTween.Completed:Wait()
                        
                        -- Remove from active notifications
                        for i, v in ipairs(notificationActive) do
                            if v == Notification then
                                table.remove(notificationActive, i)
                                break
                            end
                        end
                        
                        -- Recalculate offsets for remaining notifications
                        notificationOffset = 0
                        for i, notif in ipairs(notificationActive) do
                            notif.Position = UDim2.new(1, -220, 1, -120 - notificationOffset)
                            notificationOffset = notificationOffset + notificationSpacing
                        end
                        
                        Notification:Destroy()
                    end
                end)
            end
        end
        
        -- Show animation
        local showTween = TweenService:Create(Notification, TweenInfo.new(0.3), {
            Position = UDim2.new(1, -220, 1, Notification.Position.Y.Offset)
        })
        showTween:Play()
        
        -- Auto close after duration
        if duration then
            task.delay(duration, function()
                local hideTween = TweenService:Create(Notification, TweenInfo.new(0.3), {
                    Position = UDim2.new(1, 30, 1, Notification.Position.Y.Offset),
                    BackgroundTransparency = 0.5
                })
                hideTween:Play()
                hideTween.Completed:Wait()
                
                -- Remove from active notifications
                for i, v in ipairs(notificationActive) do
                    if v == Notification then
                        table.remove(notificationActive, i)
                        break
                    end
                end
                
                -- Recalculate offsets for remaining notifications
                notificationOffset = 0
                for i, notif in ipairs(notificationActive) do
                    notif.Position = UDim2.new(1, -220, 1, -120 - notificationOffset)
                    notificationOffset = notificationOffset + notificationSpacing
                end
                
                Notification:Destroy()
            end)
        end
    end
    return notify
end

local notify = createNotifier()

--- CONFIG SAVING SYSTEM ---
local function getConfigFilePath()
    return "KohaOrderConfig_" .. player.UserId .. ".json"
end

local function loadConfigs()
    local defaultData = { order = "[Empty]", history = {} }
    
    if not isfile or not writefile then 
        print("File system not available, using default config")
        return defaultData
    end
    
    local filePath = getConfigFilePath()
    
    if not isfile(filePath) then
        print("Config file not found, creating new one")
        return defaultData
    end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(filePath))
    end)
    
    if not success or type(data) ~= "table" then
        warn("Invalid config file, using default")
        return defaultData
    end
    
    data.order = data.order or "[Empty]"
    data.history = data.history or {}
    
    print("Loaded config:", HttpService:JSONEncode(data))
    return data
end

local function saveConfigs(data)
    if not data or type(data) ~= "table" then
        warn("Invalid data to save:", data)
        return false
    end
    
    if not writefile then
        warn("File system not available")
        return false
    end
    
    data.order = data.order or "[Empty]"
    data.history = data.history or {}
    
    local success, err = pcall(function()
        writefile(getConfigFilePath(), HttpService:JSONEncode(data))
    end)
    
    if not success then
        warn("Failed to save config:", err)
        return false
    end
    
    print("Config saved successfully")
    return true
end

--- MAIN UI (WITH DRAGGABLE FEATURE) ---
local MainScreenGui = Instance.new("ScreenGui")
MainScreenGui.Name = "OrderSystemGUI"
MainScreenGui.Parent = player:WaitForChild("PlayerGui")
MainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 90)
MainFrame.Position = UDim2.new(0.5, -190, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainScreenGui
MainFrame.ZIndex = 10

-- Make frame draggable
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- UI styling
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 70)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Parent = MainFrame
shadow.ZIndex = MainFrame.ZIndex - 1

--- PLAYER AVATAR ---
local AvatarFrame = Instance.new("Frame")
AvatarFrame.Name = "PlayerAvatar"
AvatarFrame.Parent = MainFrame
AvatarFrame.BackgroundTransparency = 1
AvatarFrame.Position = UDim2.new(0, 15, 0.5, -20)
AvatarFrame.Size = UDim2.new(0, 40, 0, 40)
AvatarFrame.ZIndex = MainFrame.ZIndex + 1

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
AvatarImage.Parent = AvatarFrame
AvatarImage.BackgroundTransparency = 1
AvatarImage.Size = UDim2.new(1, 0, 1, 0)
AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"
AvatarImage.ZIndex = AvatarFrame.ZIndex

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = Color3.fromRGB(0, 180, 255)
AvatarStroke.Thickness = 2
AvatarStroke.Parent = AvatarImage

--- TEXT CONTAINER ---
local TextContainer = Instance.new("Frame")
TextContainer.Name = "TextContainer"
TextContainer.Parent = MainFrame
TextContainer.BackgroundTransparency = 1
TextContainer.Size = UDim2.new(0.65, 0, 0.8, 0)
TextContainer.Position = UDim2.new(0.15, 40, 0.1, 0)
TextContainer.ZIndex = MainFrame.ZIndex + 1

--- ORDER LABEL ---
local configData = loadConfigs()
local OrderLabel = Instance.new("TextLabel")
OrderLabel.Name = "OrderLabel"
OrderLabel.Text = configData and configData.order or "[Empty]"
OrderLabel.Size = UDim2.new(1, 0, 0.6, 0)
OrderLabel.Position = UDim2.new(0, 0, 0, 0)
OrderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OrderLabel.Font = Enum.Font.GothamBold
OrderLabel.TextSize = 24
OrderLabel.BackgroundTransparency = 1
OrderLabel.TextXAlignment = Enum.TextXAlignment.Left
OrderLabel.TextYAlignment = Enum.TextYAlignment.Bottom
OrderLabel.Parent = TextContainer
OrderLabel.ZIndex = TextContainer.ZIndex + 1

--- PLAYER NAME ---
local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Name = "PlayerNameLabel"
PlayerNameLabel.Text = hidePlayerName(player.Name) -- Apply name hiding here
PlayerNameLabel.Size = UDim2.new(1, 0, 0.4, 0)
PlayerNameLabel.Position = UDim2.new(0, 0, 0.6, 0)
PlayerNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
PlayerNameLabel.Font = Enum.Font.Gotham
PlayerNameLabel.TextSize = 18
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerNameLabel.TextYAlignment = Enum.TextYAlignment.Top
PlayerNameLabel.Parent = TextContainer
PlayerNameLabel.ZIndex = TextContainer.ZIndex + 1

--- MANAGE BUTTON ---
local ManageButton = Instance.new("TextButton")
ManageButton.Size = UDim2.new(0, 40, 0, 40)
ManageButton.Position = UDim2.new(1, -50, 0.5, -20)
ManageButton.Text = "⋮"
ManageButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ManageButton.Font = Enum.Font.GothamBold
ManageButton.TextSize = 24
ManageButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ManageButton.BackgroundTransparency = 0.2
ManageButton.AutoButtonColor = false
ManageButton.Parent = MainFrame
ManageButton.ZIndex = MainFrame.ZIndex + 1

local ManageCorner = Instance.new("UICorner")
ManageCorner.CornerRadius = UDim.new(0, 8)
ManageCorner.Parent = ManageButton

-- Hover effects
ManageButton.MouseEnter:Connect(function()
    TweenService:Create(ManageButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
end)

ManageButton.MouseLeave:Connect(function()
    TweenService:Create(ManageButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
end)

--- CONFIG WINDOW ---
local function createConfigWindow()
    local ConfigWindow = Instance.new("Frame")
    ConfigWindow.Name = "ConfigWindow"
    ConfigWindow.Size = UDim2.new(0, 320, 0, 220)
    ConfigWindow.Position = UDim2.new(0.5, -160, 0.5, -110)
    ConfigWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ConfigWindow.BackgroundTransparency = 0.2
    ConfigWindow.BorderSizePixel = 0
    ConfigWindow.Parent = MainScreenGui
    ConfigWindow.ZIndex = 100

    -- Make config window draggable
    local draggingConfig
    local dragInputConfig
    local dragStartConfig
    local startPosConfig

    local function updateConfigInput(input)
        local delta = input.Position - dragStartConfig
        ConfigWindow.Position = UDim2.new(startPosConfig.X.Scale, startPosConfig.X.Offset + delta.X, startPosConfig.Y.Scale, startPosConfig.Y.Offset + delta.Y)
    end

    ConfigWindow.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingConfig = true
            dragStartConfig = input.Position
            startPosConfig = ConfigWindow.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingConfig = false
                end
            end)
        end
    end)

    ConfigWindow.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInputConfig = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInputConfig and draggingConfig then
            updateConfigInput(input)
        end
    end)

    -- UI styling
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = ConfigWindow

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(60, 60, 70)
    UIStroke.Thickness = 2
    UIStroke.Parent = ConfigWindow

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Parent = ConfigWindow
    shadow.ZIndex = ConfigWindow.ZIndex - 1

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "Edit Your Order"
    TitleLabel.Size = UDim2.new(1, -40, 0, 30)
    TitleLabel.Position = UDim2.new(0, 20, 0, 15)
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = ConfigWindow
    TitleLabel.ZIndex = ConfigWindow.ZIndex + 1

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Text = "×"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -40, 0, 10)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 20
    CloseButton.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    CloseButton.BackgroundTransparency = 0.2
    CloseButton.Parent = ConfigWindow
    CloseButton.ZIndex = ConfigWindow.ZIndex + 1

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        ConfigWindow:Destroy()
    end)

    -- Order input box
    local OrderInputBox = Instance.new("TextBox")
    OrderInputBox.PlaceholderText = "Enter your order here..."
    OrderInputBox.Text = configData and configData.order or ""
    OrderInputBox.Size = UDim2.new(0.85, 0, 0.3, 0)
    OrderInputBox.Position = UDim2.new(0.075, 0, 0.25, 0)
    OrderInputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    OrderInputBox.BackgroundTransparency = 0.2
    OrderInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    OrderInputBox.Font = Enum.Font.Gotham
    OrderInputBox.TextSize = 14
    OrderInputBox.TextWrapped = true
    OrderInputBox.ClearTextOnFocus = false
    OrderInputBox.Parent = ConfigWindow
    OrderInputBox.ZIndex = ConfigWindow.ZIndex + 1

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = OrderInputBox

    -- Save button
    local SaveButton = Instance.new("TextButton")
    SaveButton.Text = "SAVE"
    SaveButton.Size = UDim2.new(0.6, 0, 0.15, 0)
    SaveButton.Position = UDim2.new(0.2, 0, 0.65, 0)
    SaveButton.BackgroundColor3 = Color3.fromRGB(30, 80, 100)
    SaveButton.BackgroundTransparency = 0.2
    SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveButton.Font = Enum.Font.GothamBold
    SaveButton.TextSize = 14
    SaveButton.Parent = ConfigWindow
    SaveButton.ZIndex = ConfigWindow.ZIndex + 1

    local SaveCorner = Instance.new("UICorner")
    SaveCorner.CornerRadius = UDim.new(0, 6)
    SaveCorner.Parent = SaveButton

    -- Save button hover effects
    SaveButton.MouseEnter:Connect(function()
        TweenService:Create(SaveButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
    end)

    SaveButton.MouseLeave:Connect(function()
        TweenService:Create(SaveButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)

    -- Save order
    SaveButton.MouseButton1Click:Connect(function()
        local newOrder = OrderInputBox.Text
        if newOrder ~= "" then
            if not configData then
                configData = { order = "[Empty]", history = {} }
            end
            
            table.insert(configData.history, configData.order)
            configData.order = newOrder
            
            if saveConfigs(configData) then
                OrderLabel.Text = newOrder
                ConfigWindow:Destroy()
                notify("Success", "Order saved!", 2)
            else
                notify("Error", "Failed to save order", 2)
            end
        else
            notify("Warning", "Order cannot be empty!", 2)
        end
    end)

    -- Boost FPS toggle
    local function playStartupSound()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://7585147578"
        sound.Volume = 0.7
        sound.Parent = game:GetService("SoundService")
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
    
    local function enableBoost()
        playStartupSound()
        
        local function isCharacter(model)
            return model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart")
        end
        
        local function handleInstance(v)
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
            end
        end
        
        local function cleanCharacter(char)
            char:WaitForChild("HumanoidRootPart", 5)
            task.wait(0.5)
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
        
        local function globalBoost()
            for _, v in pairs(game:GetDescendants()) do
                handleInstance(v)
            end
            
            for _, obj in pairs(workspace:GetChildren()) do
                if (obj:IsA("Model") or obj:IsA("Folder")) and not isCharacter(obj) then
                    local n = obj.Name:lower()
                    if n:find("tree") or n:find("cloud") or n:find("building")
                    or n:find("island") or n:find("sea") or n:find("water")
                    or n:find("rock") or n:find("structure") or n:find("ship") then
                        obj:Destroy()
                    end
                end
            end
            
            pcall(function()
                game:GetService("UserSettings").GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
            end)
            
            pcall(function()
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            end)
        end
        
        -- Kích hoạt boost
        game.DescendantAdded:Connect(handleInstance)
        workspace.DescendantAdded:Connect(handleInstance)
        game.Lighting.DescendantAdded:Connect(handleInstance)
        
        local plr = game.Players.LocalPlayer
        if plr.Character then cleanCharacter(plr.Character) end
        plr.CharacterAdded:Connect(cleanCharacter)
        
        globalBoost()
    end
    
    -- Tự động bật boost FPS nếu được kích hoạt
    if boostfps then
        enableBoost()
        task.spawn(function()
            local notify = createNotifier()
            notify("Boost FPS", "Đã bật chế độ tiết kiệm hiệu năng!", 3)
        end)
    end
    
    --- ORDER MANAGEMENT ---
local function showOrderManagement()
    notify("Order Management", "Manage your current order", nil, {
        {
            text = "Edit",
            color = Color3.fromRGB(30, 80, 100),
            callback = function()
                createConfigWindow()
            end
        },
        {
            text = "Delete",
            color = Color3.fromRGB(80, 30, 30),
            callback = function()
                notify("Confirm Delete", "Are you sure?", nil, {
                    {
                        text = "Yes",
                        color = Color3.fromRGB(80, 30, 30),
                        callback = function()
                            configData = configData or { order = "[Empty]", history = {} }
                            configData.order = ""
                            if saveConfigs(configData) then
                                OrderLabel.Text = "No order set"
                                notify("Info", "Order deleted", 2)
                            else
                                notify("Error", "Failed to delete order", 2)
                            end
                        end
                    },
                    {
                        text = "No",
                        color = Color3.fromRGB(60, 60, 70),
                        callback = function() end
                    }
                })
            end
        }
    })
end

-- Connect manage button
ManageButton.MouseButton1Click:Connect(showOrderManagement)

-- Startup notification
notify("System", "Order system loaded - Click ⋮ to manage", 3)
