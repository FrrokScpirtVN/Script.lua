-- ✅ MENU TRỢ NĂNG: ĐỔI SANG Ô NHẬP TỐC ĐỘ CHỐNG KẸT CHO MOBILE

repeat task.wait() until game:IsLoaded()

-- 🟢 Nút mở menu chính (Kích thước lớn 60x60)
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ImageButton.Size = UDim2.new(0, 60, 0, 60)
ImageButton.Draggable = true
ImageButton.Image = "http://www.roblox.com/asset/?id=91347148253026"

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ImageButton

-- 🟣 Giao diện Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 🪟 Cửa sổ chính
local Window = Fluent:CreateWindow({
    Title = "trợ năng",               
    SubTitle = "Mobile Features",              
    TabWidth = 157,
    Size = UDim2.fromOffset(580, 340), 
    Acrylic = true,
    Theme = "Dark",                    
    MinimizeKey = Enum.KeyCode.End
})

-- 🛠 Logic Bật/Tắt Menu khi bấm nút hình tròn
ImageButton.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

-- 📑 1 Tab duy nhất
local Tabs = {
    TroNang = Window:AddTab({ Title = "Tính Năng" })
}
Window:SelectTab(1)

-- ⚙️ BIẾN CẤU HÌNH HỆ THỐNG
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local FlyEnabled = false
local FlySpeed = 50
local SpeedEnabled = false
local WalkSpeedValue = 16

-- 🔵 CHỨC NĂNG SPEED (CHẠY NHANH)
Tabs.TroNang:AddToggle("SpeedToggle", {
    Title = "Bật/Tắt Chạy Nhanh (Speed)",
    Default = false,
    Callback = function(Value)
        SpeedEnabled = Value
    end
})

-- Ô nhập số tốc độ chạy (Thay thế thanh trượt bị kẹt)
Tabs.TroNang:AddInput("SpeedInput", {
    Title = "Nhập tốc độ chạy",
    Description = "Mặc định game là 16 (Chỉ nhập số)",
    Default = "16",
    Placeholder = "Ví dụ: 100",
    Numeric = true, -- Chỉ cho phép nhập số
    Finished = false, -- Nhận giá trị liên tục khi gõ xong
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            WalkSpeedValue = num
        end
    end
})

-- Vòng lặp khóa tốc độ chạy liên tục
RunService.Stepped:Connect(function()
    if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = WalkSpeedValue
    end
end)


-- 🔴 CHỨC NĂNG FLY (BAY)
local ControlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
local Camera = workspace.CurrentCamera

Tabs.TroNang:AddToggle("FlyToggle", {
    Title = "Bật/Tắt Bay (Fly)",
    Default = false,
    Callback = function(Value)
        FlyEnabled = Value
        
        if FlyEnabled then
            task.spawn(function()
                local Character = LocalPlayer.Character
                local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                
                if not RootPart or not Humanoid then return end
                
                local BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                BodyVelocity.Parent = RootPart
                
                while FlyEnabled and Character and RootPart and Humanoid.Parent do
                    local MoveDirection = ControlModule:GetMoveVector()
                    local CameraDirection = Camera.CFrame
                    
                    local NewVelocity = Vector3.new(0, 0, 0)
                    
                    if MoveDirection.Z ~= 0 then
                        NewVelocity = NewVelocity + (CameraDirection.LookVector * -MoveDirection.Z)
                    end
                    if MoveDirection.X ~= 0 then
                        NewVelocity = NewVelocity + (CameraDirection.RightVector * MoveDirection.X)
                    end
                    
                    BodyVelocity.Velocity = NewVelocity * FlySpeed
                    
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        BodyVelocity.Velocity = BodyVelocity.Velocity + Vector3.new(0, FlySpeed, 0)
                    end
                    
                    task.wait()
                end
                
                if BodyVelocity then BodyVelocity:Destroy() end
            end)
        end
    end
})

-- Ô nhập số tốc độ bay
Tabs.TroNang:AddInput("FlyInput", {
    Title = "Nhập tốc độ bay",
    Description = "Mặc định nên để từ 50 - 150 (Chỉ nhập số)",
    Default = "50",
    Placeholder = "Ví dụ: 80",
    Numeric = true, -- Chỉ cho phép nhập số
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            FlySpeed = num
        end
    end
})
