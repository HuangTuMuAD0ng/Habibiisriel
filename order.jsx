local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local username = player.Name
local configFilePath = username .. "_order_config.json"

-- Hàm tải thông tin từ file config
local function loadConfig()
    if isfile(configFilePath) then
        local fileContent = readfile(configFilePath)
        local configData = HttpService:JSONDecode(fileContent)
        return configData
    end
    return nil
end

-- Hàm lưu thông tin vào file config
local function saveConfig(order)
    writefile(configFilePath, HttpService:JSONEncode({ order = order }))
    print("Đã lưu đơn hàng:", order)
end

-- Tạo UI chính
local MainScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local OrderLabel = Instance.new("TextLabel")
local PlayerNameLabel = Instance.new("TextLabel")
local UICornerMain = Instance.new("UICorner")

MainScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Thiết lập MainFrame
MainFrame.Size = UDim2.new(0, 450, 0, 160)
MainFrame.Position = UDim2.new(0.5, -225, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainScreenGui

UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

-- Hiển thị đơn hàng
OrderLabel.Text = "Đơn hàng: [Trống]"
OrderLabel.Size = UDim2.new(1, -10, 0.6, 0)
OrderLabel.Position = UDim2.new(0, 0, 0, 0)
OrderLabel.TextColor3 = Color3.fromRGB(255, 223, 0)
OrderLabel.Font = Enum.Font.GothamBold
OrderLabel.TextScaled = true
OrderLabel.BackgroundTransparency = 1
OrderLabel.Parent = MainFrame

-- Hiển thị tên người chơi (ẩn 6 ký tự cuối)
local visibleUsername = string.sub(username, 1, #username - 6) .. "******"
PlayerNameLabel.Text = "Tên người chơi: " .. visibleUsername
PlayerNameLabel.Size = UDim2.new(1, -10, 0.4, 0)
PlayerNameLabel.Position = UDim2.new(0, 0, 0.6, 0)
PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameLabel.Font = Enum.Font.Gotham
PlayerNameLabel.TextScaled = true
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Parent = MainFrame

-- Load config khi rejoin
local configData = loadConfig()
if configData and configData.order then
    OrderLabel.Text = "Đơn hàng: " .. configData.order
end

-- Tạo UI nhập đơn hàng (xuất hiện khi nhấn vào bánh răng ⚙️)
local ConfigWindow = Instance.new("Frame")
local OrderInputBox = Instance.new("TextBox")
local DoneButton = Instance.new("TextButton")
local UICornerConfig = Instance.new("UICorner")

ConfigWindow.Size = UDim2.new(0, 350, 0, 150)
ConfigWindow.Position = UDim2.new(0.5, -175, 0.5, -75)
ConfigWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ConfigWindow.BackgroundTransparency = 0.5
ConfigWindow.BorderSizePixel = 0
ConfigWindow.Visible = false
ConfigWindow.Parent = MainScreenGui

UICornerConfig.CornerRadius = UDim.new(0, 10)
UICornerConfig.Parent = ConfigWindow

OrderInputBox.Size = UDim2.new(0.8, 0, 0.4, 0)
OrderInputBox.Position = UDim2.new(0.1, 0, 0.2, 0)
OrderInputBox.PlaceholderText = "Nhập chỉnh sửa đơn hàng..."
OrderInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
OrderInputBox.Font = Enum.Font.Gotham
OrderInputBox.TextScaled = true
OrderInputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OrderInputBox.Parent = ConfigWindow

DoneButton.Size = UDim2.new(0.3, 0, 0.3, 0)
DoneButton.Position = UDim2.new(0.35, 0, 0.7, 0)
DoneButton.Text = "✅"
DoneButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DoneButton.Font = Enum.Font.GothamBold
DoneButton.TextScaled = true
DoneButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
DoneButton.Parent = ConfigWindow

DoneButton.MouseButton1Click:Connect(function()
    local newOrder = OrderInputBox.Text
    if newOrder ~= "" then
        OrderLabel.Text = "Đơn hàng: " .. newOrder
        saveConfig(newOrder)
    end
    ConfigWindow.Visible = false
end)
-- Tạo UI stat
local StatScreenGui = Instance.new("ScreenGui")
local StatFrame = Instance.new("Frame")
local FPSLabel = Instance.new("TextLabel")
local ServerTimeLabel = Instance.new("TextLabel")
local ConfigButton = Instance.new("TextButton")
local DeleteButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")
local UICornerStat = Instance.new("UICorner")

StatScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Thiết lập StatFrame
StatFrame.Size = UDim2.new(0, 250, 0, 180)
StatFrame.Position = UDim2.new(0.9, -260, 0.4, 0)
StatFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatFrame.BackgroundTransparency = 0.4
StatFrame.BorderSizePixel = 0
StatFrame.Parent = StatScreenGui

UICornerStat.CornerRadius = UDim.new(0, 10)
UICornerStat.Parent = StatFrame

-- Hiển thị FPS
FPSLabel.Text = "FPS: Calculating..."
FPSLabel.Size = UDim2.new(1, -10, 0.25, 0)
FPSLabel.Position = UDim2.new(0, 0, 0, 0)
FPSLabel.TextColor3 = Color3.fromRGB(255, 223, 0)
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextScaled = true
FPSLabel.BackgroundTransparency = 1
FPSLabel.Parent = StatFrame

-- Hiển thị thời gian server
ServerTimeLabel.Text = "Thời gian: 00:00"
ServerTimeLabel.Size = UDim2.new(1, -10, 0.25, 0)
ServerTimeLabel.Position = UDim2.new(0, 0, 0.25, 0)
ServerTimeLabel.TextColor3 = Color3.fromRGB(255, 223, 0)
ServerTimeLabel.Font = Enum.Font.Gotham
ServerTimeLabel.TextScaled = true
ServerTimeLabel.BackgroundTransparency = 1
ServerTimeLabel.Parent = StatFrame

-- Nút Config (⚙️)
ConfigButton.Size = UDim2.new(0.2, -5, 0.2, -5)
ConfigButton.Position = UDim2.new(0, 5, 0.8, -5) -- Góc dưới bên trái
ConfigButton.Text = "⚙️"
ConfigButton.TextColor3 = Color3.fromRGB(255, 223, 0)
ConfigButton.Font = Enum.Font.GothamBold
ConfigButton.TextScaled = true
ConfigButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ConfigButton.BackgroundTransparency = 0.4
ConfigButton.Parent = StatFrame

ConfigButton.MouseButton1Click:Connect(function()
    ConfigWindow.Visible = true
end)

-- Nút Delete (🗑️)
DeleteButton.Size = UDim2.new(0.2, -5, 0.2, -5)
DeleteButton.Position = UDim2.new(0.8, -5, 0.8, -5) -- Góc dưới bên phải
DeleteButton.Text = "🗑️"
DeleteButton.TextColor3 = Color3.fromRGB(255, 223, 0)
DeleteButton.Font = Enum.Font.GothamBold
DeleteButton.TextScaled = true
DeleteButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DeleteButton.BackgroundTransparency = 0.4
DeleteButton.Parent = StatFrame

DeleteButton.MouseButton1Click:Connect(function()
    if isfile(configFilePath) then
        delfile(configFilePath)
        OrderLabel.Text = "Đơn hàng: [Trống]"
    end
end)

-- Nút Toggle (Ẩn UI stat, vẫn giữ lại nút hiển thị ở góc trên bên phải)
ToggleButton.Size = UDim2.new(0.2, -5, 0.2, -5)
ToggleButton.Position = UDim2.new(1, -50, -0.2, 10) -- Luôn cố định trên màn hình
ToggleButton.Text = "Ẩn"
ToggleButton.TextColor3 = Color3.fromRGB(255, 223, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextScaled = true
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.BackgroundTransparency = 0.4
ToggleButton.Parent = StatScreenGui

ToggleButton.MouseButton1Click:Connect(function()
    if StatFrame.Visible then
        StatFrame.Visible = false
        ToggleButton.Text = "Hiện"
    else
        StatFrame.Visible = true
        ToggleButton.Text = "Ẩn"
    end
end)

-- Cập nhật FPS
spawn(function()
    while true do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        FPSLabel.Text = "FPS: " .. fps
        wait(0.5)
    end
end)

-- Cập nhật thời gian server
local injectStartTime = os.time()
spawn(function()
    while true do
        local elapsedTime = os.time() - injectStartTime
        local minutes = math.floor(elapsedTime / 60)
        local seconds = elapsedTime % 60
        ServerTimeLabel.Text = string.format("Thời gian: %02d:%02d", minutes, seconds)
        wait(1)
    end
end)

-- Kéo thả StatFrame
local dragging = false
local dragInput, dragStart, startPos

StatFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = StatFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

StatFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        StatFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
