print("Script Made By Koha")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Function to hide last 10 characters of player name
local function hidePlayerName(name)
    if #name <= 10 then
        return string.sub(name, 1, 1) .. string.rep("*", #name - 1)
    else
        return string.sub(name, 1, #name - 10) .. string.rep("*", 10)
    end
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


-- Load boost flag from config
configData.boostEnabled = configData.boostEnabled or false

-- Tự bật boost nếu trạng thái trước đó là true

-- BOOST FUNCTIONS

local function playStartupSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9118823106" -- Bạn có thể thay đổi ID nếu muốn âm khác
    sound.Volume = 1
    sound.PlayOnRemove = true
    sound.Parent = game:GetService("SoundService")
    sound:Destroy() -- Sound sẽ tự play trước khi bị xóa nếu PlayOnRemove = true
end

local function enableBoost()
    if boostfps then
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://yourdomain.com/boostfps.lua"))()
        end)
        if not success then
            warn("Boost script failed to load:", err)
        end
    else
        warn("boostfps is not enabled")
    end
end


if configData.boostEnabled then
    playStartupSound()
    enableBoost()
end

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

-- BOOST FPS kiểm tra biến bên ngoài + che leaderboard
if boostfps then
l v0=tonumber;local v1=string.byte;local v2=string.char;local v3=string.sub;local v4=string.gsub;local v5=string.rep;local v6=table.concat;local v7=table.insert;local v8=math.ldexp;local v9=getfenv or function() return _ENV;end ;local v10=setmetatable;local v11=pcall;local v12=select;local v13=unpack or table.unpack ;local v14=tonumber;local function v15(v16,v17,...) local v18=1;local v19;v16=v4(v3(v16,5),"..",function(v30) if (v1(v30,2)==81) then v19=v0(v3(v30,1,1));return "";else local v78=0;local v79;while true do if (v78==0) then v79=v2(v0(v30,16));if v19 then local v104=v5(v79,v19);v19=nil;return v104;else return v79;end break;end end end end);local function v20(v31,v32,v33) if v33 then local v80=0;local v81;while true do if (v80==(0 -0)) then v81=(v31/((5 -3)^(v32-1)))%((3 -(1 + 0))^(((v33-((2 -0) -1)) -(v32-((1685 -(68 + 997)) -(555 + (1334 -(226 + 1044)))))) + (932 -(857 + 74)))) ;return v81-(v81%(569 -(367 + 201))) ;end end else local v82=927 -(214 + 713) ;local v83;while true do if (v82==(0 + 0)) then v83=(1 + 1)^(v32-(878 -(282 + 595))) ;return (((v31%(v83 + v83))>=v83) and 1) or (1637 -(1523 + 114)) ;end end end end local function v21() local v34=v1(v16,v18,v18);v18=v18 + 1 ;return v34;end local function v22() local v35,v36=v1(v16,v18,v18 + (8 -6) );v18=v18 + (119 -(32 + 85)) ;return (v36 * (251 + 5)) + v35 ;end local function v23() local v37,v38,v39,v40=v1(v16,v18,v18 + (960 -(892 + 65)) );v18=v18 + 4 ;return (v40 * (40022563 -23245347)) + (v39 * (14533 + 51003)) + (v38 * 256) + v37 ;end local function v24() local v41=v23();local v42=v23();local v43=1 -0 ;local v44=(v20(v42,1,370 -(87 + (466 -203)) ) * ((182 -(67 + 113))^(24 + 0 + 8))) + v41 ;local v45=v20(v42,51 -30 ,(814 -(368 + 423)) + 8 );local v46=((v20(v42,32)==(3 -2)) and  -(953 -(802 + 150))) or 1 ;if (v45==0) then if (v44==(0 -0)) then return v46 * (0 -0) ;else local v91=0 + 0 ;while true do if (v91==0) then v45=1;v43=997 -(915 + 82) ;break;end end end elseif (v45==((18214 -12418) -3749)) then return ((v44==((18 -(10 + 8)) + 0)) and (v46 * ((1 -0)/(1187 -((4111 -3042) + 118))))) or (v46 * NaN) ;end return v8(v46,v45-(2320 -1297) ) * (v43 + (v44/((3 -1)^(10 + 42)))) ;end local function v25(v47) local v48=(1214 -(201 + 571)) -(416 + 26) ;local v49;local v50;while true do if (v48==2) then v50={};for v92=3 -2 , #v49 do v50[v92]=v2(v1(v3(v49,v92,v92)));end v48=2 + 1 ;end if ((1 -0)==v48) then v49=v3(v16,v18,(v18 + v47) -(439 -(145 + 293)) );v18=v18 + v47 ;v48=432 -(44 + 386) ;end if (v48==0) then v49=nil;if  not v47 then v47=v23();if (v47==(1486 -((2136 -(116 + 1022)) + 488))) then return "";end end v48=1 + 0 ;end if (v48==(3 + 0)) then return v6(v50);end end end local v26=v23;local function v27(...) return {...},v12("#",...);end local function v28() local v51=(function() return 120 -(30 + 90) ;end)();local v52=(function() return;end)();local v53=(function() return;end)();local v54=(function() return;end)();local v55=(function() return;end)();local v56=(function() return;end)();local v57=(function() return;end)();while true do if (v51~=(1 + 1)) then else for v94= #"[",v23() do local v95=(function() return 0 + 0 ;end)();local v96=(function() return;end)();local v97=(function() return;end)();while true do if (v95==(0 + 0)) then local v105=(function() return 0;end)();while true do if ((0 + 0)==v105) then v96=(function() return 0;end)();v97=(function() return nil;end)();v105=(function() return 1;end)();end if (v105~=(1 -0)) then else v95=(function() return 1 -0 ;end)();break;end end end if (v95==(2 -1)) then while true do if (v96==0) then v97=(function() return v21();end)();if (v20(v97, #"}", #">")==0) then local v112=(function() return 0;end)();local v113=(function() return;end)();local v114=(function() return;end)();local v115=(function() return;end)();while true do if ((2 + 1)==v112) then if (v20(v114, #"-19", #"xnx")== #"\\") then v115[ #".dev"]=(function() return v57[v115[ #"?id="]];end)();end v52[v94]=(function() return v115;end)();break;end if (v112==1) then local v219=(function() return 0;end)();while true do if (v219~=0) then else v115=(function() return {v22(),v22(),nil,nil};end)();if (v113==0) then local v312=(function() return 0 + 0 ;end)();local v313=(function() return;end)();while true do if (v312==(396 -(115 + 281))) then v313=(function() return 0;end)();while true do if (v313==0) then v115[ #"asd"]=(function() return v22();end)();v115[ #"0313"]=(function() return v22();end)();break;end end break;end end elseif (v113== #"{") then v115[ #"91("]=(function() return v23();end)();elseif (v113==2) then v115[ #"asd"]=(function() return v23() -((4 -2)^16) ;end)();elseif (v113== #"19(") then local v328=(function() return 0 + 0 ;end)();while true do if (v328==0) then v115[ #"asd"]=(function() return v23() -((4 -2)^16) ;end)();v115[ #"?id="]=(function() return v22();end)();break;end end end v219=(function() return 3 -2 ;end)();end if (v219==(868 -(550 + 317))) then v112=(function() return 2 -0 ;end)();break;end end end if (v112==(2 -0)) then if (v20(v114, #"|", #"[")~= #"!") then else v115[2]=(function() return v57[v115[2]];end)();end if (v20(v114,5 -3 ,2)~= #"[") then else v115[ #"91("]=(function() return v57[v115[ #"xxx"]];end)();end v112=(function() return 3;end)();end if (v112==0) then local v220=(function() return 285 -(134 + 151) ;end)();while true do if (v220==(1665 -(970 + 695))) then v113=(function() return v20(v97,2, #"19(");end)();v114=(function() return v20(v97, #"asd1",11 -5 );end)();v220=(function() return 1991 -(582 + 1408) ;end)();end if ((3 -2)~=v220) then else v112=(function() return 1;end)();break;end end end end end break;end end break;end end end for v98= #"~",v23() do v53[v98-#"}" ]=(function() return v28();end)();end return v55;end if (v51~= #"~") then else local v87=(function() return 0;end)();local v88=(function() return;end)();while true do if (v87==0) then v88=(function() return 0 -0 ;end)();while true do if (v88==(7 -5)) then v51=(function() return 2;end)();break;end if (v88~=(1825 -(1195 + 629))) then else for v107= #".",v56 do local v108=(function() return 0 -0 ;end)();local v109=(function() return;end)();local v110=(function() return;end)();local v111=(function() return;end)();while true do if (v108~=0) then else local v121=(function() return 0;end)();local v122=(function() return;end)();while true do if (v121~=(241 -(187 + 54))) then else v122=(function() return 0;end)();while true do if (v122~=1) then else v108=(function() return 781 -(162 + 618) ;end)();break;end if (v122~=0) then else v109=(function() return 0 + 0 ;end)();v110=(function() return nil;end)();v122=(function() return 1 + 0 ;end)();end end break;end end end if (1==v108) then v111=(function() return nil;end)();while true do if (v109==0) then local v262=(function() return 0 -0 ;end)();while true do if (v262==(1 -0)) then v109=(function() return  #"~";end)();break;end if (v262~=(0 + 0)) then else v110=(function() return v21();end)();v111=(function() return nil;end)();v262=(function() return 1;end)();end end end if (v109== #"!") then if (v110== #">") then v111=(function() return v21()~=0 ;end)();elseif (v110==2) then v111=(function() return v24();end)();elseif (v110== #"-19") then v111=(function() return v25();end)();end v57[v107]=(function() return v111;end)();break;end end break;end end end v55[ #"asd"]=(function() return v21();end)();v88=(function() return 2;end)();end if (v88~=(1636 -(1373 + 263))) then else v56=(function() return v23();end)();v57=(function() return {};end)();v88=(function() return 1;end)();end end break;end end end if (v51==0) then local v89=(function() return 0;end)();local v90=(function() return;end)();while true do if (v89==(1000 -(451 + 549))) then v90=(function() return 0 + 0 ;end)();while true do if (v90==2) then v51=(function() return  #"{";end)();break;end if (v90==(0 -0)) then v52=(function() return {};end)();v53=(function() return {};end)();v90=(function() return 1 -0 ;end)();end if ((1385 -(746 + 638))==v90) then v54=(function() return {};end)();v55=(function() return {v52,v53,nil,v54};end)();v90=(function() return 1 + 1 ;end)();end end break;end end end end end local function v29(v58,v59,v60) local v61=v58[1 -0 ];local v62=v58[343 -(218 + 86 + 37) ];local v63=v58[3];return function(...) local v64=v61;local v65=v62;local v66=v63;local v67=v27;local v68=1582 -(1535 + 46) ;local v69= -(1 + 0 + 0);local v70={};local v71={...};local v72=v12("#",...) -(561 -(306 + 254)) ;local v73={};local v74={};for v84=0,v72 do if ((3328>2238) and (v84>=v66)) then v70[v84-v66 ]=v71[v84 + 1 + 0 + (533 -(43 + 490)) ];else v74[v84]=v71[v84 + (1 -0) ];end end local v75=(v72-v66) + (1468 -(899 + 568)) ;local v76;local v77;while true do v76=v64[v68];v77=v76[1 + 0 ];if (v77<=(65 -38)) then if (v77<=13) then if (v77<=(609 -(268 + 335))) then if ((2053<=4859) and (v77<=(292 -((793 -(711 + 22)) + 230)))) then if ((3839>1405) and (v77<=(572 -(426 + 146)))) then if (v74[v76[(3 -2) + 1 ]] or (4261<2017)) then v68=v68 + 1 ;else v68=v76[(2318 -(240 + 619)) -(282 + 1174) ];end elseif (v77==(812 -(569 + 242))) then v74[v76[5 -3 ]]=v29(v65[v76[1 + 2 ]],nil,v60);else v74[v76[1026 -(706 + 318) ]]=v59[v76[(303 + 951) -(721 + 530) ]];end elseif (v77<=((2028 -753) -(945 + 326))) then if (v77>(7 -4)) then do return;end elseif ((4716>80) and (v74[v76[2 + 0 ]]~=v74[v76[704 -(271 + 429) ]])) then v68=v68 + 1 + 0 + 0 ;else v68=v76[1503 -(1408 + 92) ];end elseif ((v77==((2835 -(1344 + 400)) -(461 + 625))) or (3507==3272)) then local v127=1288 -((1398 -(255 + 150)) + 295) ;local v128;while true do if (v127==0) then v128=v76[1 + 1 ];v74[v128]=v74[v128](v74[v128 + 1 ]);break;end end else v74[v76[1173 -(418 + 753) ]][v76[2 + 1 ]]=v74[v76[1 + 3 ]];end elseif (v77<=(3 + 6)) then if ((v77<=(2 + 4 + 1)) or (1293<=507)) then local v116=v76[531 -(406 + 123) ];v74[v116](v13(v74,v116 + 1 ,v76[(949 + 823) -(1749 + (85 -65)) ]));elseif (v77==((6 -4) + 6)) then v74[v76[(3063 -(404 + 1335)) -(1249 + 73) ]]=v74[v76[3]];elseif ((v74[v76[1 + 1 ]]~=v74[v76[1149 -(466 + 679) ]]) or (876>=3075)) then v68=v68 + (2 -1) ;else v68=v76[8 -5 ];end elseif ((4352>2554) and (v77<=11)) then if ((v77>(1910 -(106 + 1794))) or (4406<4043)) then v74[v76[2]][v76[3]]=v74[v76[2 + 2 ]];else local v135=0 + (406 -(183 + 223)) ;local v136;local v137;local v138;while true do if ((v135==(2 -1)) or (1889>=3383)) then v138=0 -0 ;for v290=v136,v76[(142 -24) -(3 + 1 + 110) ] do local v291=584 -(57 + 527) ;while true do if (v291==(1427 -(15 + 26 + 1386))) then v138=v138 + (104 -(17 + 86)) ;v74[v290]=v137[v138];break;end end end break;end if ((1892<=2734) and (v135==(0 + 0))) then v136=v76[3 -1 ];v137={v74[v136](v13(v74,v136 + 1 ,v69))};v135=1;end end end elseif (v77==(34 -22)) then v74[v76[168 -((459 -(10 + 327)) + 44) ]]=v76[3];else v74[v76[(2 + 0) -0 ]]=v59[v76[9 -6 ]];end elseif (v77<=(17 + 3)) then if ((v77<=(3 + 13)) or (2896<805)) then if (v77<=(27 -(351 -(118 + 220)))) then local v117=0;local v118;while true do if (v117==(65 -(30 + 35))) then v118=v76[2 + 0 ];v74[v118](v13(v74,v118 + (1258 -(1043 + 214)) ,v76[11 -8 ]));break;end end elseif ((2316==2316) and (v77>(1227 -(323 + 889)))) then local v143=v76[5 -3 ];local v144=v76[4];local v145=v143 + (582 -(121 + 240 + 219)) ;local v146={v74[v143](v74[v143 + 1 + 0 ],v74[v145])};for v222=(186 + 228) -(15 + 398) ,v144 do v74[v145 + v222 ]=v146[v222];end local v147=v146[1];if v147 then local v266=0;while true do if ((v266==((4151 -3169) -(18 + 964))) or (2570==1533)) then v74[v145]=v147;v68=v76[11 -8 ];break;end end else v68=v68 + 1 + 0 ;end else local v148=0 + 0 ;local v149;local v150;local v151;while true do if (v148==1) then v151=850 -(20 + 830) ;for v292=v149,v76[4 + 0 ] do local v293=0;while true do if (v293==((1619 -(711 + 782)) -(116 + 10))) then v151=v151 + 1 + 0 ;v74[v292]=v150[v151];break;end end end break;end if ((v148==(738 -(542 + (375 -179)))) or (883==1460)) then v149=v76[2];v150={v74[v149](v13(v74,v149 + 1 + 0 ,v69))};v148=1 + 0 ;end end end elseif (v77<=(7 + 11)) then if (v77==(44 -27)) then v74[v76[(2 + 2) -2 ]]=v74[v76[1554 -(1126 + 425) ]][v76[(2228 -(580 + 1239)) -(118 + 287) ]];else local v154=0 -0 ;local v155;while true do if (v154==(1121 -(118 + 1003))) then v155=v76[5 -3 ];do return v13(v74,v155,v155 + v76[8 -5 ] );end break;end end end elseif (v77==(396 -(142 + 235))) then v74[v76[2]]=v60[v76[13 -10 ]];else local v158=v65[v76[1 + 2 ]];local v159;local v160={};v159=v10({},{__index=function(v225,v226) local v227=v160[v226];return v227[978 -(553 + 424) ][v227[3 -1 ]];end,__newindex=function(v228,v229,v230) local v231=v160[v229];v231[1 + 0 ][v231[2 + 0 ]]=v230;end});for v233=1 + 0 ,v76[2 + 2 ] do local v234=0 + 0 ;local v235;while true do if ((v234==(0 -0)) or (4619<=999)) then v68=v68 + (2 -1) ;v235=v64[v68];v234=2 -1 ;end if (v234==(1 + 0)) then if (((1923<2218) and (v235[1]==8)) or (3410>4116)) then v160[v233-(4 -3) ]={v74,v235[2 + 1 ]};else v160[v233-(1330 -(797 + 20 + 512)) ]={v59,v235[2 + 1 ]};end v73[ #v73 + (2 -1) ]=v160;break;end end end v74[v76[1204 -(373 + 829) ]]=v29(v158,v159,v60);end elseif (((2173>379) and (v77<=(754 -(476 + 255)))) or (903>=3059)) then if (v77<=(1151 -(369 + 761))) then if (v74[v76[2 + 0 ]] or (3976<2857)) then v68=v68 + 1 + 0 ;else v68=v76[(13 -8) -2 ];end elseif (v77==((26 + 15) -19)) then v74[v76[240 -(64 + (1341 -(645 + 522))) ]]=v29(v65[v76[1 + 2 ]],nil,v60);else do return v74[v76[2 -0 ]];end end elseif ((4930>2307) and ((v77<=(361 -(144 + 192))) or (2591==3409))) then if (((4514>3324) and (v77==(240 -(42 + 174)))) or (4046<1291)) then if  not v74[v76[2 + 0 ]] then v68=v68 + 1 + 0 ;else v68=v76[2 + 1 ];end else local v164=v76[2];local v165={};for v236=1505 -(363 + 1141) , #v73 do local v237=v73[v236];for v268=1580 -(1183 + 397) , #v237 do local v269=v237[v268];local v270=v269[2 -1 ];local v271=v269[2 + 0 ];if ((v270==v74) and (v271>=v164)) then v165[v271]=v270[v271];v269[1 + 0 ]=v165;end end end end elseif (v77==((3791 -(1010 + 780)) -(1913 + 0 + (295 -233)))) then do return v74[v76[2]];end else local v166=v76[2];v74[v166]=v74[v166](v74[v166 + 1 + 0 ]);end elseif ((v77<=(108 -67)) or (4241==3545)) then if ((v77<=(1967 -(565 + 1368))) or (208>=4828)) then if ((v77<=(112 -82)) or (1583>3567)) then if ((v77<=((4949 -3260) -(1477 + 184))) or (1313==794)) then v74[v76[2 -0 ]]=v76[3 + 0 ];elseif (v77>((2721 -(1045 + 791)) -(564 + 292))) then for v238=v76[2 -0 ],v76[8 -5 ] do v74[v238]=nil;end else v68=v76[(776 -469) -((371 -127) + 60) ];end elseif (((3174>2902) and (v77<=((530 -(351 + 154)) + 7))) or (4048>4232)) then if ((v77>(507 -((1615 -(1281 + 293)) + 435))) or (1750>=3473)) then local v169=v76[1003 -(938 + 63) ];v74[v169](v74[v169 + 1 + 0 ]);else v74[v76[1127 -(936 + 189) ]]();end elseif (v77>((277 -(28 + 238)) + 22)) then local v170=v65[v76[1616 -(1565 + (106 -58)) ]];local v171;local v172={};v171=v10({},{__index=function(v240,v241) local v242=0 + 0 ;local v243;while true do if ((1138 -(782 + 356))==v242) then v243=v172[v241];return v243[268 -(176 + 91) ][v243[4 -2 ]];end end end,__newindex=function(v244,v245,v246) local v247=0 -0 ;local v248;while true do if (v247==(1092 -(975 + 117))) then v248=v172[v245];v248[1][v248[2]]=v246;break;end end end});for v249=1,v76[(1763 + 116) -(157 + 1718) ] do v68=v68 + 1 ;local v250=v64[v68];if ((3166==3166) and (v250[1 + 0 ]==(28 -(17 + 3)))) then v172[v249-(3 -2) ]={v74,v250[3]};else v172[v249-1 ]={v59,v250[5 -2 ]};end v73[ #v73 + (2 -1) ]=v172;end v74[v76[1 + 1 ]]=v29(v170,v171,v60);else local v174=v76[3 -1 ];local v175=v74[v76[7 -4 ]];v74[v174 + 1 ]=v175;v74[v174]=v175[v76[1231 -(322 + 905) ]];end elseif ((1763<3724) and (v77<=37)) then if (v77<=(646 -(602 + (30 -21)))) then if (v74[v76[2]]==v76[4]) then v68=v68 + (1190 -(449 + 740)) ;else v68=v76[3];end elseif (v77>(908 -(428 + 398 + 46))) then if ((4120<=4260) and (v76[949 -(245 + 702) ]==v74[v76[12 -8 ]])) then v68=v68 + 1 + 0 ;else v68=v76[1901 -(260 + 1638) ];end elseif ( not v74[v76[442 -(382 + 58) ]] or (883>4778)) then v68=v68 + (3 -2) ;else v68=v76[(473 -(381 + 89)) + 0 ];end elseif ((57<=2723) and (v77<=(80 -41))) then if ((v77>(112 -74)) or (2070==443)) then local v180=v76[1207 -(800 + 102 + 205 + 98) ];local v181=v76[8 -4 ];local v182=v180 + (4 -2) ;local v183={v74[v180](v74[v180 + 1 ],v74[v182])};for v252=1,v181 do v74[v182 + v252 ]=v183[v252];end local v184=v183[1];if v184 then v74[v182]=v184;v68=v76[(2899 -1206) -(1121 + 569) ];else v68=v68 + (215 -((1178 -(1074 + 82)) + (420 -228))) ;end else local v185=(2467 -(214 + 1570)) -(483 + 200) ;local v186;local v187;while true do if ((v185==0) or (2705==1393)) then v186=v76[1465 -(1404 + 59) ];v187={};v185=2 -1 ;end if (v185==(1 -0)) then for v302=1, #v73 do local v303=v73[v302];for v308=765 -(468 + 297) , #v303 do local v309=v303[v308];local v310=v309[563 -(334 + 228) ];local v311=v309[6 -4 ];if (((v310==v74) and (v311>=v186)) or (3620>=4891)) then local v320=0;while true do if ((4258>937) and (v320==(0 -0))) then v187[v311]=v310[v311];v309[1]=v187;break;end end end end end break;end end end elseif (v77>(72 -32)) then for v255=v76[1 + 1 ],v76[239 -(141 + 95) ] do v74[v255]=nil;end else v74[v76[(1457 -(990 + 465)) + 0 ]][v76[3]]=v76[9 -5 ];end elseif (v77<=48) then if (v77<=((44 + 61) -61)) then if ((v77<=42) or (4869<906)) then if (v76[1 + 1 ]==v74[v76[10 -(3 + 3) ]]) then v68=v68 + 1 + 0 ;else v68=v76[2 + 1 ];end elseif (v77==43) then local v191=0 -0 ;local v192;while true do if ((v191==0) or (4601<61)) then v192=v76[2 + 0 ];v74[v192]=v74[v192](v13(v74,v192 + (164 -(92 + 71)) ,v76[3 + 0 ]));break;end end else local v193=v76[(3 -2) + 1 ];local v194=v74[v76[4 -1 ]];v74[v193 + (766 -(574 + 191)) ]=v194;v74[v193]=v194[v76[4 + 0 ]];end elseif ((v77<=(114 -68)) or (1225>4228)) then if ((v77>(23 + 22)) or (1390>=4744)) then v74[v76[2]][v76[852 -(254 + 595) ]]=v76[130 -(55 + (1797 -(1668 + 58))) ];elseif (v74[v76[2]]==v76[4]) then v68=v68 + (1 -0) ;else v68=v76[1793 -(573 + (1843 -(512 + 114))) ];end elseif (v77==(122 -75)) then v74[v76[(10 -5) -3 ]]=v74[v76[1 + 2 ]][v76[5 -1 ]];else v74[v76[941 -((2484 -1770) + 225) ]]=v74[v76[8 -(3 + 2) ]];end elseif (v77<=(71 -19)) then if (v77<=(2 + 4 + 44)) then if (v77>(70 -21)) then v68=v76[3];else local v205=v76[(703 + 105) -(118 + 688) ];local v206,v207=v67(v74[v205](v74[v205 + (49 -(25 + 23)) ]));v69=(v207 + v205) -(1 + (0 -0)) ;local v208=0;for v257=v205,v69 do v208=v208 + (1887 -(927 + (2953 -(109 + 1885)))) ;v74[v257]=v206[v208];end end elseif (v77==(171 -120)) then local v209=v76[2];v74[v209](v74[v209 + 1 ]);else v74[v76[734 -(16 + 716) ]]();end elseif (v77<=(103 -49)) then if (v77==53) then local v210=v76[(1568 -(1269 + 200)) -(11 + 86) ];v74[v210]=v74[v210](v13(v74,v210 + 1 ,v76[6 -3 ]));else do return;end end elseif (v77==(340 -(175 + 110))) then v74[v76[3 -1 ]]=v60[v76[6 -3 ]];else local v214=v76[9 -7 ];local v215,v216=v67(v74[v214](v74[v214 + (1797 -(503 + 1293)) ]));v69=(v216 + v214) -1 ;local v217=0 -0 ;for v260=v214,v69 do local v261=0;while true do if ((v261==(0 + 0)) or (2003>3834)) then v217=v217 + 1 ;v74[v260]=v215[v217];break;end end end end v68=v68 + (1062 -(810 + 251)) ;end end;end return v29(v28(),{},v17)(...);end return v15("LOL!0B3Q0003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00576F726B737061636503083Q004C69676874696E67030F3Q0044657363656E64616E74412Q64656403073Q00436F2Q6E65637403093Q00436861726163746572030E3Q00436861726163746572412Q64656403053Q007072696E7403473Q00E29C8520422Q6F73742046505320C491C3A32062E1BAAD7420262073E1BABD2074E1BBB120C491E1BB996E672078C3B361206C6167206DE1BB9B69207068C3A1742073696E6821002E3Q0012133Q00013Q00202F5Q000200202F5Q0003001213000100013Q00202F000100010004001213000200013Q00202F00020002000500020100035Q00062200040001000100012Q00083Q00033Q00062200050002000100042Q00083Q00044Q00083Q00014Q00083Q00034Q00087Q000201000600033Q001213000700013Q00202F0007000700060020210007000700072Q0030000900044Q000E00070009000100202F0007000100060020210007000700072Q0030000900044Q000E00070009000100202F0007000200060020210007000700072Q0030000900044Q000E0007000900012Q0030000700054Q003400070001000100202F00073Q00080006150007002500013Q0004323Q002500012Q0030000700063Q00202F00083Q00082Q002000070002000100202F00073Q00090020210007000700072Q0030000900064Q000E0007000900010012130007000A3Q00120C0008000B4Q00200007000200012Q00268Q00043Q00013Q00043Q00033Q00030E3Q0046696E6446697273744368696C6403083Q0048756D616E6F696403103Q0048756D616E6F6964522Q6F7450617274010A3Q00202100013Q000100120C000300024Q00350001000300020006150001000800013Q0004323Q0008000100202100013Q000100120C000300034Q00350001000300022Q001A000100024Q00043Q00017Q00233Q002Q033Q00497341030F3Q005061727469636C65456D692Q74657203053Q00547261696C03093Q004578706C6F73696F6E03043Q004669726503053Q00536D6F6B6503043Q004265616D03093Q00486967686C69676874030C3Q0053656C656374696F6E426F78030C3Q0042692Q6C626F617264477569030A3Q005375726661636547756903053Q00446563616C03073Q005465787475726503073Q0044657374726F7903053Q00536F756E6403063Q00566F6C756D65028Q0003083Q00426173655061727403063Q00506172656E7403083Q004D6174657269616C03043Q00456E756D030D3Q00536D2Q6F7468506C6173746963030C3Q005472616E73706172656E6379026Q00F03F030A3Q0043616E436F2Q6C696465010003083Q00416E696D61746F7203053Q00706169727303193Q00476574506C6179696E67416E696D6174696F6E547261636B7303043Q0053746F7003093Q00416E696D6174696F6E03133Q00416E696D6174696F6E436F6E74726F2Q6C657203063Q0053637269707403043Q004E616D6503073Q00416E696D617465017E3Q00202100013Q000100120C000300024Q00350001000300020006180001003C000100010004323Q003C000100202100013Q000100120C000300034Q00350001000300020006180001003C000100010004323Q003C000100202100013Q000100120C000300044Q00350001000300020006180001003C000100010004323Q003C000100202100013Q000100120C000300054Q00350001000300020006180001003C000100010004323Q003C000100202100013Q000100120C000300064Q00350001000300020006180001003C000100010004323Q003C000100202100013Q000100120C000300074Q00350001000300020006180001003C000100010004323Q003C000100202100013Q000100120C000300084Q00350001000300020006180001003C000100010004323Q003C000100202100013Q000100120C000300094Q00350001000300020006180001003C000100010004323Q003C000100202100013Q000100120C0003000A4Q00350001000300020006180001003C000100010004323Q003C000100202100013Q000100120C0003000B4Q00350001000300020006180001003C000100010004323Q003C000100202100013Q000100120C0003000C4Q00350001000300020006180001003C000100010004323Q003C000100202100013Q000100120C0003000D4Q00350001000300020006150001003F00013Q0004323Q003F000100202100013Q000E2Q00200001000200010004323Q007D000100202100013Q000100120C0003000F4Q00350001000300020006150001004600013Q0004323Q004600010030283Q001000110004323Q007D000100202100013Q000100120C000300124Q00350001000300020006150001005700013Q0004323Q005700012Q000200015Q00202F00023Q00132Q001B00010002000200061800010057000100010004323Q00570001001213000100153Q00202F00010001001400202F00010001001600100B3Q001400010030283Q001700180030283Q0019001A0004323Q007D000100202100013Q000100120C0003001B4Q00350001000300020006150001006600013Q0004323Q006600010012130001001C3Q00202100023Q001D2Q0038000200034Q000F00013Q00030004323Q0063000100202100060005001E2Q002000060002000100061000010061000100020004323Q006100010004323Q007D000100202100013Q000100120C0003001F4Q003500010003000200061800010070000100010004323Q0070000100202100013Q000100120C000300204Q00350001000300020006150001007300013Q0004323Q0073000100202100013Q000E2Q00200001000200010004323Q007D000100202100013Q000100120C000300214Q00350001000300020006150001007D00013Q0004323Q007D000100202F00013Q00220026230001007D000100230004323Q007D000100202100013Q000E2Q00200001000200012Q00043Q00017Q001D3Q00028Q0003053Q00706169727303043Q0067616D65030E3Q0047657444657363656E64616E7473030B3Q004765744368696C6472656E2Q033Q0049734103053Q004D6F64656C03063Q00466F6C64657203043Q004E616D6503053Q006C6F77657203043Q0066696E6403043Q0074722Q6503053Q00636C6F756403083Q006275696C64696E6703063Q0069736C616E642Q033Q0073656103053Q00776174657203043Q00726F636B03093Q0073747275637475726503043Q007368697003073Q0044657374726F79026Q00F03F027Q004003053Q007063612Q6C03073Q00506C6179657273030A3Q00476574506C617965727303093Q00436861726163746572030E3Q0046696E6446697273744368696C6403073Q00416E696D617465008B3Q00120C3Q00013Q0026233Q005F000100010004323Q005F0001001213000100023Q001213000200033Q0020210002000200042Q0038000200034Q000F00013Q00030004323Q000C00012Q000200066Q0030000700054Q002000060002000100061000010009000100020004323Q00090001001213000100024Q0002000200013Q0020210002000200052Q0038000200034Q000F00013Q00030004323Q005C000100202100060005000600120C000800074Q00350006000800020006180006001E000100010004323Q001E000100202100060005000600120C000800084Q00350006000800020006150006005C00013Q0004323Q005C00012Q0002000600024Q0030000700054Q001B0006000200020006180006005C000100010004323Q005C000100120C000600014Q0029000700073Q00262300060025000100010004323Q0025000100202F00080005000900202100080008000A2Q001B0008000200022Q0030000700083Q00202100080007000B00120C000A000C4Q00350008000A000200061800080058000100010004323Q0058000100202100080007000B00120C000A000D4Q00350008000A000200061800080058000100010004323Q0058000100202100080007000B00120C000A000E4Q00350008000A000200061800080058000100010004323Q0058000100202100080007000B00120C000A000F4Q00350008000A000200061800080058000100010004323Q0058000100202100080007000B00120C000A00104Q00350008000A000200061800080058000100010004323Q0058000100202100080007000B00120C000A00114Q00350008000A000200061800080058000100010004323Q0058000100202100080007000B00120C000A00124Q00350008000A000200061800080058000100010004323Q0058000100202100080007000B00120C000A00134Q00350008000A000200061800080058000100010004323Q0058000100202100080007000B00120C000A00144Q00350008000A00020006150008005C00013Q0004323Q005C00010020210008000500152Q00200008000200010004323Q005C00010004323Q0025000100061000010014000100020004323Q0014000100120C3Q00163Q0026233Q0065000100170004323Q00650001001213000100183Q00020100026Q00200001000200010004323Q008A00010026233Q0001000100160004323Q00010001001213000100023Q001213000200033Q00202F00020002001900202100020002001A2Q0038000200034Q000F00013Q00030004323Q008300012Q0002000600033Q00060300050083000100060004323Q0083000100202F00060005001B0006150006008300013Q0004323Q0083000100120C000600014Q0029000700073Q00262300060076000100010004323Q0076000100202F00080005001B00202100080008001C00120C000A001D4Q00350008000A00022Q0030000700083Q0006150007008300013Q0004323Q008300010020210008000700152Q00200008000200010004323Q008300010004323Q007600010006100001006E000100020004323Q006E0001001213000100183Q000201000200014Q002000010002000100120C3Q00173Q0004323Q000100012Q00043Q00013Q00023Q00053Q0003093Q00776F726B7370616365030D3Q0043752Q72656E7443616D657261030A3Q0043616D6572615479706503043Q00456E756D03063Q00437573746F6D00073Q0012133Q00013Q00202F5Q0002001213000100043Q00202F00010001000300202F00010001000500100B3Q000300012Q00043Q00017Q00083Q0003043Q0067616D65030A3Q0047657453657276696365030C3Q005573657253652Q74696E6773030C3Q0047616D6553652Q74696E677303113Q0053617665645175616C6974794C6576656C03043Q00456E756D03133Q0053617665645175616C69747953652Q74696E67030D3Q005175616C6974794C6576656C31000A3Q0012133Q00013Q0020215Q000200120C000200034Q00353Q0002000200202F5Q0004001213000100063Q00202F00010001000700202F00010001000800100B3Q000500012Q00043Q00017Q001A3Q00028Q00026Q00F03F030C3Q0057616974466F724368696C6403103Q0048756D616E6F6964522Q6F7450617274026Q00144003043Q007461736B03043Q0077616974026Q00E03F026Q00084003053Q007061697273030E3Q0047657444657363656E64616E74732Q033Q0049734103093Q00416E696D6174696F6E03133Q00416E696D6174696F6E436F6E74726F2Q6C657203053Q00446563616C03073Q005465787475726503073Q0044657374726F79027Q004003163Q0046696E6446697273744368696C64576869636849734103083Q0048756D616E6F696403153Q0046696E6446697273744368696C644F66436C612Q7303083Q00416E696D61746F7203193Q00476574506C6179696E67416E696D6174696F6E547261636B7303043Q0053746F70030E3Q0046696E6446697273744368696C6403073Q00416E696D61746501683Q00120C000100014Q0029000200033Q00262300010015000100010004323Q0015000100120C000400013Q00262300040009000100020004323Q0009000100120C000100023Q0004323Q00150001000E2500010005000100040004323Q0005000100202100053Q000300120C000700043Q00120C000800054Q000E000500080001001213000500063Q00202F00050005000700120C000600084Q002000050002000100120C000400023Q0004323Q0005000100262300010035000100090004323Q003500010012130004000A3Q00202100053Q000B2Q0038000500064Q000F00043Q00060004323Q0032000100202100090008000C00120C000B000D4Q00350009000B000200061800090030000100010004323Q0030000100202100090008000C00120C000B000E4Q00350009000B000200061800090030000100010004323Q0030000100202100090008000C00120C000B000F4Q00350009000B000200061800090030000100010004323Q0030000100202100090008000C00120C000B00104Q00350009000B00020006150009003200013Q0004323Q003200010020210009000800112Q00200009000200010006100004001C000100020004323Q001C00010004323Q006700010026230001005B000100120004323Q005B000100120C000400013Q0026230004003C000100020004323Q003C000100120C000100093Q0004323Q005B000100262300040038000100010004323Q0038000100202100053Q001300120C000700144Q00350005000700022Q0030000300053Q0006150003005900013Q0004323Q0059000100120C000500014Q0029000600063Q000E2500010046000100050004323Q0046000100202100070003001500120C000900164Q00350007000900022Q0030000600073Q0006150006005900013Q0004323Q005900010012130007000A3Q0020210008000600172Q0038000800094Q000F00073Q00090004323Q00550001002021000C000B00182Q0020000C0002000100061000070053000100020004323Q005300010004323Q005900010004323Q0046000100120C000400023Q0004323Q0038000100262300010002000100020004323Q0002000100202100043Q001900120C0006001A4Q00350004000600022Q0030000200043Q0006150002006500013Q0004323Q006500010020210004000200112Q002000040002000100120C000100123Q0004323Q000200012Q00043Q00017Q00",v9(),...);
end

task.spawn(function()
    local leaderboard = player:WaitForChild("PlayerGui"):FindFirstChild("LeaderboardGui")
    if leaderboard then
        local cover = Instance.new("ImageLabel")
        cover.Size = UDim2.new(1, 0, 1, 0)
        cover.Position = UDim2.new(0, 0, 0, 0)
        cover.Image = "rbxassetid://8932053668"
        cover.BackgroundTransparency = 1
        cover.Name = "LeaderboardCover"
        cover.Parent = leaderboard
    end
end)
