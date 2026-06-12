-- [[ BLOX FRUITS MONITORING UI WITH FIX IMAGE - CENTERED & FULL OVERLAY ]] --
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa bản cũ nếu có để tránh trùng lặp khi chạy lại
if PlayerGui:FindFirstChild("BloxFruitsMonitorFixed") then
    PlayerGui.BloxFruitsMonitorFixed:Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsMonitorFixed"
ScreenGui.ResetOnSpawn = false
-- FIX: Bật cái này lên để nền đen tràn ra toàn bộ màn hình, không bị sọc xanh 2 bên như trong ảnh 1000002612.jpg
ScreenGui.IgnoreGuiInset = true 
ScreenGui.Parent = PlayerGui

-- [[ NỀN ĐEN TUYỀN PHỦ TUYỆT ĐỐI TOÀN MÀN HÌNH ]] --
local Overlay = Instance.new("Frame")
Overlay.Name = "DarkOverlay"
Overlay.Size = UDim2.new(1, 0, 1, 0) -- Kéo dãn đầy đủ 100% màn hình
Overlay.Position = UDim2.new(0, 0, 0, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0 -- Đen kịt hoàn toàn che sạch map game
Overlay.BorderSizePixel = 0
Overlay.Active = true
Overlay.Parent = ScreenGui

-- Main Frame (BẢN ĐẸP NHẤT - ĐÃ CĂN GIỮA & KHÓA DI CHUYỂN)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 220)
-- Sử dụng AnchorPoint và Position 0.5 để đưa khung vào GIỮA màn hình tuyệt đối
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
-- Đã xóa hoàn toàn MainFrame.Draggable để menu không thể bị bấm di chuyển đi chỗ khác
MainFrame.Parent = Overlay 

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "SCRIPT MONITOR"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local Line = Instance.new("Frame")
Line.Size = UDim2.new(0.95, 0, 0, 1)
Line.Position = UDim2.new(0.025, 0, 0, 35)
Line.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- [[ THE BIG IMAGE BOX - ĐÃ FIX LỖI TỐI ẢNH ]] --
local ImageBox = Instance.new("ImageLabel")
ImageBox.Name = "CustomImage"
ImageBox.Size = UDim2.new(0, 120, 0, 120)
ImageBox.Position = UDim2.new(0.04, 0, 0, 48)
ImageBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ImageBox.BorderSizePixel = 0
ImageBox.ScaleType = Enum.ScaleType.Fit
ImageBox.Parent = MainFrame

local ImageCorner = Instance.new("UICorner")
ImageCorner.CornerRadius = UDim.new(0, 8)
ImageCorner.Parent = ImageBox

-- Hàm tự động chuyển đổi Decal ID sang Image ID để không bị tối thui
task.spawn(function()
    local rawId = "107503863299177"
    local success, assetId = pcall(function()
        return ContentProvider:GetTemporaryId("rbxassetid://" .. rawId)
    end)
    
    if success and assetId then
        ImageBox.Image = assetId
    else
        ImageBox.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. rawId .. "&width=420&height=420&format=png"
    end
end)

-- Helper function to create Text Labels
local function createLabel(name, position, text, color)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = UDim2.new(0, 200, 0, 22)
    label.Position = position
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(240, 240, 240)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = MainFrame
    return label
end

local function formatNumber(value)
    return tostring(value):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

-- Info Labels (Bố cục chữ thoáng đẹp theo ý bạn)
local LevelLabel    = createLabel("LevelLabel",    UDim2.new(0.42, 0, 0, 45), "Level: Loading...")
local MeleeLabel    = createLabel("MeleeLabel",    UDim2.new(0.42, 0, 0, 67), "Melee: Loading...")
local DefenseLabel  = createLabel("DefenseLabel",  UDim2.new(0.42, 0, 0, 89), "Defense: Loading...")
local BeliLabel     = createLabel("BeliLabel",     UDim2.new(0.42, 0, 0, 111), "Beli: Loading...", Color3.fromRGB(100, 255, 100))
local FragLabel     = createLabel("FragLabel",     UDim2.new(0.42, 0, 0, 133), "Fragments: Loading...", Color3.fromRGB(255, 100, 255))
local RuntimeLabel  = createLabel("RuntimeLabel",  UDim2.new(0.04, 0, 0, 185), "Runtime: 00:00:00", Color3.fromRGB(0, 170, 255))

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, mins, secs)
end

local Data = LocalPlayer:WaitForChild("Data")
local Stats = LocalPlayer:WaitForChild("Data"):WaitForChild("Stats")

local function updateAllData()
    local levelVal = Data:FindFirstChild("Level") and Data.Level.Value or 0
    local meleeVal = Stats:FindFirstChild("Melee") and Stats.Melee.Level.Value or 0
    local defenseVal = Stats:FindFirstChild("Defense") and Stats.Defense.Level.Value or 0
    local beliVal = Data:FindFirstChild("Beli") and Data.Beli.Value or 0
    local fragVal = Data:FindFirstChild("Fragments") and Data.Fragments.Value or 0
    
    LevelLabel.Text = "Level: " .. formatNumber(levelVal)
    MeleeLabel.Text = "Melee Stats: " .. formatNumber(meleeVal)
    DefenseLabel.Text = "Defense Stats: " .. formatNumber(defenseVal)
    BeliLabel.Text = "Beli: $" .. formatNumber(beliVal)
    FragLabel.Text = "Fragments: " .. formatNumber(fragVal)
end

updateAllData()
if Data:FindFirstChild("Level") then Data.Level.Changed:Connect(updateAllData) end
if Stats:FindFirstChild("Melee") then Stats.Melee.Level.Changed:Connect(updateAllData) end
if Stats:FindFirstChild("Defense") then Stats.Defense.Level.Changed:Connect(updateAllData) end
if Data:FindFirstChild("Beli") then Data.Beli.Changed:Connect(updateAllData) end
if Data:FindFirstChild("Fragments") then Data.Fragments.Changed:Connect(updateAllData) end

local startTime = os.time()
task.spawn(function()
    while task.wait(1) do
        local elapsedTime = os.time() - startTime
        RuntimeLabel.Text = "Runtime: " .. formatTime(elapsedTime)
    end
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/FrrokScpirtVN/Script.lua/refs/heads/main/Neji.lua"))()
