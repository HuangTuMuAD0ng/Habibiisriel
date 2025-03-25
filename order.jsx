local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
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
local ConfigButton = Instance.new("TextButton")
local DeleteButton = Instance.new("TextButton")
local UICornerMain = Instance.new("UICorner")

MainScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Thiết lập MainFrame
MainFrame.Size = UDim2.new(0, 680, 0, 150) -- Tăng chiều ngang lên 680 và chiều dọc lên 150
MainFrame.Position = UDim2.new(0.5, -340, 0, -5) -- Dịch sát mép trên hơn (-5 offset)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainScreenGui

UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

-- Hiển thị đơn hàng
OrderLabel.Text = "Đơn hàng: [Trống]"
OrderLabel.Size = UDim2.new(1, -10, 0.4, 0)
OrderLabel.Position = UDim2.new(0.5, 0, 0.2, 0) -- Căn giữa dọc và ngang
OrderLabel.AnchorPoint = Vector2.new(0.5, 0.5)
OrderLabel.TextColor3 = Color3.fromRGB(255, 223, 0)
OrderLabel.Font = Enum.Font.GothamBold
OrderLabel.TextScaled = true
OrderLabel.BackgroundTransparency = 1
OrderLabel.Parent = MainFrame

-- Hiển thị tên người chơi (ẩn 6 ký tự cuối)
local visibleUsername = string.sub(username, 1, #username - 6) .. "******"
PlayerNameLabel.Text = "Tên người chơi: " .. visibleUsername
PlayerNameLabel.Size = UDim2.new(1, -10, 0.3, 0)
PlayerNameLabel.Position = UDim2.new(0.5, 0, 0.6, 0) -- Căn giữa dọc và ngang
PlayerNameLabel.AnchorPoint = Vector2.new(0.5, 0.5)
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

-- Nút Config (Thay đổi đơn hàng)
ConfigButton.Size = UDim2.new(0.3, -10, 0.3, -10)
ConfigButton.Position = UDim2.new(1, -10, 1, -10) -- Góc dưới bên phải của MainFrame
ConfigButton.AnchorPoint = Vector2.new(1, 1)
ConfigButton.Text = "⚙️ Thay đổi"
ConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigButton.Font = Enum.Font.GothamBold
ConfigButton.TextScaled = true
ConfigButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ConfigButton.BackgroundTransparency = 0.4
ConfigButton.Parent = MainFrame

ConfigButton.MouseButton1Click:Connect(function()
    local ConfigWindow = Instance.new("Frame")
    local OrderInputBox = Instance.new("TextBox")
    local DoneButton = Instance.new("TextButton")
    local UICornerConfig = Instance.new("UICorner")

    ConfigWindow.Size = UDim2.new(0, 350, 0, 150)
    ConfigWindow.Position = UDim2.new(0.5, -175, 0.5, -75)
    ConfigWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ConfigWindow.BackgroundTransparency = 0.5
    ConfigWindow.BorderSizePixel = 0
    ConfigWindow.Parent = MainScreenGui

    UICornerConfig.CornerRadius = UDim.new(0, 10)
    UICornerConfig.Parent = ConfigWindow

    OrderInputBox.Size = UDim2.new(0.8, 0, 0.4, 0)
    OrderInputBox.Position = UDim2.new(0.5, 0, 0.4, 0) -- Căn giữa
    OrderInputBox.AnchorPoint = Vector2.new(0.5, 0.5)
    OrderInputBox.PlaceholderText = "Nhập đơn hàng mới..."
    OrderInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    OrderInputBox.Font = Enum.Font.Gotham
    OrderInputBox.TextScaled = true
    OrderInputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OrderInputBox.Parent = ConfigWindow

    DoneButton.Size = UDim2.new(0.3, 0, 0.3, 0)
    DoneButton.Position = UDim2.new(0.5, 0, 0.85, 0)
    DoneButton.AnchorPoint = Vector2.new(0.5, 0.5)
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
        ConfigWindow:Destroy()
    end)
end)

-- Nút Delete (Xóa đơn hàng)
DeleteButton.Size = UDim2.new(0.3, -10, 0.3, -10)
DeleteButton.Position = UDim2.new(0, 10, 1, -10) -- Góc dưới bên trái của MainFrame
DeleteButton.AnchorPoint = Vector2.new(0, 1)
DeleteButton.Text = "🗑️ Xóa"
DeleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteButton.Font = Enum.Font.GothamBold
DeleteButton.TextScaled = true
DeleteButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DeleteButton.BackgroundTransparency = 0.4
DeleteButton.Parent = MainFrame

DeleteButton.MouseButton1Click:Connect(function()
    if isfile(configFilePath) then
        delfile(configFilePath)
        OrderLabel.Text = "Đơn hàng: [Trống]"
        print("Đã xóa đơn hàng.")
    else
        print("Không tìm thấy đơn hàng để xóa.")
    end
end)
