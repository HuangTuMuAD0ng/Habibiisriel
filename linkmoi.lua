local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Đường dẫn file tổng hợp config
local configFilePath = "order_configs.json"

-- Hàm tải toàn bộ configs
local function loadConfigs()
    if isfile(configFilePath) then
        local fileContent = readfile(configFilePath)
        local configData = HttpService:JSONDecode(fileContent)
        return configData
    end
    return {}
end

-- Hàm lưu toàn bộ configs
local function saveConfigs(configData)
    writefile(configFilePath, HttpService:JSONEncode(configData))
end

-- Hàm lấy config của người chơi
local function getPlayerConfig(username)
    local configs = loadConfigs()
    return configs[username] or { order = "[Trống]" }
end

-- Hàm cập nhật config của người chơi
local function setPlayerConfig(username, newConfig)
    local configs = loadConfigs()
    configs[username] = newConfig
    saveConfigs(configs)
end

-- Tạo GUI
local MainScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ServerTimeLabel = Instance.new("TextLabel")
local OrderLabel = Instance.new("TextLabel")
local PlayerNameLabel = Instance.new("TextLabel")
local ClearButton = Instance.new("TextButton")
local SettingsButton = Instance.new("TextButton")
local UICornerMain = Instance.new("UICorner")

-- Thêm GUI chính vào PlayerGui
MainScreenGui.Parent = player:WaitForChild("PlayerGui")
MainScreenGui.Enabled = true

-- Thiết lập MainFrame
MainFrame.Size = UDim2.new(0, 400, 0, 80)
MainFrame.Position = UDim2.new(0.5, -200, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainScreenGui

UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

-- Hiển thị thời gian chạy script
ServerTimeLabel.Text = "Thời gian chạy: 00:00"
ServerTimeLabel.Size = UDim2.new(1, -10, 0.2, 0)
ServerTimeLabel.Position = UDim2.new(0, 0, 0.1, 0)
ServerTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ServerTimeLabel.Font = Enum.Font.Roboto
ServerTimeLabel.TextScaled = true
ServerTimeLabel.BackgroundTransparency = 1
ServerTimeLabel.Parent = MainFrame

local injectStartTime = os.time()
spawn(function()
    while true do
        local elapsedTime = os.time() - injectStartTime
        local minutes = math.floor(elapsedTime / 60)
        local seconds = elapsedTime % 60
        ServerTimeLabel.Text = string.format("Thời gian chạy: %02d:%02d", minutes, seconds)
        wait(1)
    end
end)

-- Hiển thị đơn hàng
local username = player.Name
local configData = getPlayerConfig(username)
OrderLabel.Text = "Đơn hàng: " .. (configData.order or "[Trống]")
OrderLabel.Size = UDim2.new(1, -10, 0.2, 0)
OrderLabel.Position = UDim2.new(0, 0, 0.35, 0)
OrderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OrderLabel.Font = Enum.Font.Roboto
OrderLabel.TextScaled = true
OrderLabel.BackgroundTransparency = 1
OrderLabel.Parent = MainFrame

-- Hiển thị tên người chơi (ẩn 4 ký tự cuối)
local visibleUsername = string.sub(username, 1, #username - 4) .. "****"
PlayerNameLabel.Text = "Tên người chơi: " .. visibleUsername
PlayerNameLabel.Size = UDim2.new(1, -10, 0.2, 0)
PlayerNameLabel.Position = UDim2.new(0, 0, 0.6, 0)
PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameLabel.Font = Enum.Font.Roboto
PlayerNameLabel.TextScaled = true
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Parent = MainFrame

-- Nút xóa đơn hàng
ClearButton.Size = UDim2.new(0.15, 0, 0.4, 0)
ClearButton.Position = UDim2.new(0.85, 0, 0.6, 0)
ClearButton.Text = "Xóa"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.Font = Enum.Font.GothamBold
ClearButton.TextScaled = true
ClearButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ClearButton.Parent = MainFrame

ClearButton.MouseButton1Click:Connect(function()
    setPlayerConfig(username, { order = "[Trống]" })
    OrderLabel.Text = "Đơn hàng: [Trống]"
    print("Đã xóa thông tin đơn hàng của tài khoản: " .. username)
end)

-- Nút mở cửa sổ chỉnh sửa
SettingsButton.Size = UDim2.new(0.1, 0, 0.4, 0)
SettingsButton.Position = UDim2.new(0, 10, 0.6, 0)
SettingsButton.Text = "⚙️"
SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsButton.Font = Enum.Font.GothamBold
SettingsButton.TextScaled = true
SettingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SettingsButton.Parent = MainFrame

-- Tạo cửa sổ chỉnh sửa config
local ConfigWindow = Instance.new("Frame")
local OrderInputBox = Instance.new("TextBox")
local DoneButton = Instance.new("TextButton")
local UICornerConfig = Instance.new("UICorner")

ConfigWindow.Size = UDim2.new(0, 350, 0, 150)
ConfigWindow.Position = UDim2.new(0.5, -175, 0.5, -75)
ConfigWindow.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
OrderInputBox.Font = Enum.Font.Roboto
OrderInputBox.TextScaled = true
OrderInputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OrderInputBox.Parent = ConfigWindow

DoneButton.Size = UDim2.new(0.3, 0, 0.3, 0)
DoneButton.Position = UDim2.new(0.35, 0, 0.7, 0)
DoneButton.Text = "Xong"
DoneButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DoneButton.Font = Enum.Font.GothamBold
DoneButton.TextScaled = true
DoneButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
DoneButton.Parent = ConfigWindow

-- Hiển thị cửa sổ chỉnh sửa khi nhấn nút cài đặt
SettingsButton.MouseButton1Click:Connect(function()
    ConfigWindow.Visible = true
end)

-- Lưu chỉnh sửa và tắt cửa sổ
DoneButton.MouseButton1Click:Connect(function()
    local newOrder = OrderInputBox.Text
    if newOrder ~= "" then
        OrderLabel.Text = "Đơn hàng: " .. newOrder
        setPlayerConfig(username, { order = newOrder })
        print("Đã lưu chỉnh sửa đơn hàng cho tài khoản: " .. username)
    end
    ConfigWindow.Visible = false
end)