local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Đường dẫn file tổng hợp config
local configFilePath = "order_configs.json"

-- Hàm tải toàn bộ configs
local function loadConfigs()
    if isfile(configFilePath) then
        local fileContent = readfile(configFilePath)
        local status, configData = pcall(function()
            return HttpService:JSONDecode(fileContent)
        end)
        if status then
            return configData
        else
            warn("Lỗi đọc file config:", configData)
        end
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
    if not configs[username] then
        createConfigWindow(username) -- Gọi cửa sổ nhập config nếu không tìm thấy
    end
    return configs[username] or { order = "[Trống]" }
end

-- Hàm cập nhật config của người chơi
local function setPlayerConfig(username, newConfig)
    local configs = loadConfigs()
    configs[username] = newConfig
    saveConfigs(configs)
end

-- Tạo giao diện chính (UI)
local MainScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ServerTimeLabel = Instance.new("TextLabel")
local OrderLabel = Instance.new("TextLabel")
local PlayerNameLabel = Instance.new("TextLabel")
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

-- Đếm thời gian chạy script
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
-- Hàm tạo cửa sổ nhập config
local function createConfigWindow(username)
    local ConfigWindow = Instance.new("Frame")
    local OrderInputBox = Instance.new("TextBox")
    local SaveButton = Instance.new("TextButton")
    local UICornerConfig = Instance.new("UICorner")

    ConfigWindow.Size = UDim2.new(0, 350, 0, 150)
    ConfigWindow.Position = UDim2.new(0.5, -175, 0.5, -75)
    ConfigWindow.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ConfigWindow.BackgroundTransparency = 0.5
    ConfigWindow.BorderSizePixel = 0
    ConfigWindow.Parent = MainScreenGui -- Thêm cửa sổ nhập vào GUI chính

    UICornerConfig.CornerRadius = UDim.new(0, 10)
    UICornerConfig.Parent = ConfigWindow

    OrderInputBox.Size = UDim2.new(0.8, 0, 0.4, 0)
    OrderInputBox.Position = UDim2.new(0.1, 0, 0.2, 0)
    OrderInputBox.PlaceholderText = "Nhập đơn hàng mới..."
    OrderInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    OrderInputBox.Font = Enum.Font.Roboto
    OrderInputBox.TextScaled = true
    OrderInputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OrderInputBox.Parent = ConfigWindow

    SaveButton.Size = UDim2.new(0.3, 0, 0.3, 0)
    SaveButton.Position = UDim2.new(0.35, 0, 0.7, 0)
    SaveButton.Text = "Lưu"
    SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveButton.Font = Enum.Font.GothamBold
    SaveButton.TextScaled = true
    SaveButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
    SaveButton.Parent = ConfigWindow

    -- Xử lý sự kiện khi nhấn nút Lưu
    SaveButton.MouseButton1Click:Connect(function()
        local newOrder = OrderInputBox.Text
        if newOrder ~= "" then
            -- Cập nhật config và hiển thị UI chính
            setPlayerConfig(username, { order = newOrder })
            OrderLabel.Text = "Đơn hàng: " .. newOrder
            print("Đã lưu đơn hàng mới cho tài khoản: " .. username)
        end
        -- Ẩn cửa sổ nhập config
        ConfigWindow:Destroy()

        -- Hiển thị lại UI chính
        MainScreenGui.Enabled = true
    end)

    -- Ẩn UI chính khi hiển thị cửa sổ nhập config
    MainScreenGui.Enabled = false
end

-- Hiển thị thông tin đơn hàng
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

-- Nút xóa đơn hàng
local ClearButton = Instance.new("TextButton")
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

-- Nút chỉnh sửa đơn hàng
local SettingsButton = Instance.new("TextButton")
SettingsButton.Size = UDim2.new(0.1, 0, 0.4, 0)
SettingsButton.Position = UDim2.new(0, 10, 0.6, 0)
SettingsButton.Text = "⚙️"
SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsButton.Font = Enum.Font.GothamBold
SettingsButton.TextScaled = true
SettingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SettingsButton.Parent = MainFrame

-- Hiển thị cửa sổ chỉnh sửa khi nhấn nút
SettingsButton.MouseButton1Click:Connect(function()
    createConfigWindow(username)
end)
