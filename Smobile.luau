local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Smobile X Hub|SELL LEMONS|By @2mmlxp",
    LoadingTitle = "Smobile X Hub loaded!",
    LoadingSubtitle = "By @2mmlxp",
})

local Tab = Window:CreateTab("Main", 4483362458)

local LocalPlayer = game.Players.LocalPlayer
local userTycoon = nil

local AutoFarmChanh = false
local AutoMua = false
local AutoNangCap = false
local AutoTaiSinh = false

-- Tìm Tycoon
local function findTycoon()
    for _, v in ipairs(workspace:GetChildren()) do
        local owner = v:FindFirstChild("Owner") or v:FindFirstChild("Player")
        if owner and (owner.Value == LocalPlayer or owner.Value == LocalPlayer.Name) then
            userTycoon = v
            return v
        end
    end
    return nil
end
userTycoon = findTycoon()

if not userTycoon then
    Rayfield:Notify({Title = "Lỗi", Content = "Không tìm thấy Tycoon!", Duration = 8})
end

-- ================== AUTO FARM CHANH (ĐÃ CHỈNH THEO YÊU CẦU) ==================
local Trees = {}
local function addTree(obj)
    if obj:IsA("Model") and obj.Name:find("LemonTree") then
        if not table.find(Trees, obj) then table.insert(Trees, obj) end
    end
end
for _, v in ipairs(workspace:GetDescendants()) do addTree(v) end
workspace.DescendantAdded:Connect(addTree)

local function hasFruits(tree)
    for _, desc in ipairs(tree:GetDescendants()) do
        if desc:IsA("ClickDetector") or desc.Name:find("Lemon") or desc.Name:find("Fruit") then
            return true
        end
    end
    return false
end

local function farmOneTree(tree)
    if not tree or not tree.Parent then return end
    if not hasFruits(tree) then return end  -- Chỉ TP đến cây CÓ chanh

    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- TP xuyên qua cây + xuống dưới đất để click trái
    local root = tree:FindFirstChildWhichIsA("BasePart") or tree.PrimaryPart
    if root then
        -- Vị trí xuyên cây + thấp hơn để click trái chanh
        hrp.CFrame = root.CFrame * CFrame.new(0, -3, 0)  -- Xuống dưới đất
        task.wait(0.2)
    end

    -- Thu hoạch mạnh
    for i = 1, 40 do
        if not AutoFarmChanh then break end
        for _, desc in ipairs(tree:GetDescendants()) do
            if desc:IsA("ClickDetector") then
                pcall(function() fireclickdetector(desc) end)
            end
        end
        task.wait(0.05)
    end
end

-- ================== AUTO BUY (Giữ nguyên bản nhanh) ==================
local function doAutoMua()
    while AutoMua and userTycoon do
        for _, rem in ipairs(userTycoon:GetDescendants()) do
            if rem:IsA("RemoteFunction") and (rem.Name:find("Purchase") or rem.Name:find("Buy")) then
                pcall(function() rem:InvokeServer() end)
            end
        end
        for _, obj in ipairs(userTycoon:GetDescendants()) do
            local n = obj.Name:lower()
            if n:find("buy") or n:find("purchase") or n:find("button") then
                if obj:IsA("ClickDetector") then pcall(fireclickdetector, obj)
                elseif obj:IsA("ProximityPrompt") then pcall(fireproximityprompt, obj) end
            end
        end
        task.wait(0.3)
    end
end

-- ================== AUTO NÂNG CẤP & TÁI SINH (Giữ nguyên) ==================
local function doAutoNangCap()
    while AutoNangCap and userTycoon do
        for _, rem in ipairs(userTycoon:GetDescendants()) do
            if rem:IsA("RemoteFunction") and (rem.Name == "Upgrade" or rem.Name:find("Upgrade")) then
                pcall(function() rem:InvokeServer(1) end)
            end
        end
        task.wait(0.7)
    end
end

local function doAutoTaiSinh()
    while AutoTaiSinh do
        for _, rem in ipairs(userTycoon:GetDescendants()) do
            if rem.Name:lower():find("rebirth") or rem.Name:lower():find("evolve") then
                pcall(function()
                    if rem:IsA("RemoteFunction") then rem:InvokeServer() else rem:FireServer() end
                end)
            end
        end
        task.wait(30)
    end
end

-- ================== TOGGLES ==================
Tab:CreateToggle({Name = "🍋 Auto Farm Chanh", CurrentValue = false, Callback = function(v) AutoFarmChanh = v end})

Tab:CreateToggle({Name = "🛒 Auto Buy Từ Xa", CurrentValue = false, Callback = function(v) 
    AutoMua = v 
    if v then task.spawn(doAutoMua) end 
end})

Tab:CreateToggle({Name = "📈 Auto Nâng Cấp Từ Xa", CurrentValue = false, Callback = function(v) 
    AutoNangCap = v 
    if v then task.spawn(doAutoNangCap) end 
end})

Tab:CreateToggle({Name = "♻️ Auto Tái Sinh", CurrentValue = false, Callback = function(v) 
    AutoTaiSinh = v 
    if v then task.spawn(doAutoTaiSinh) end 
end})

Tab:CreateButton({Name = "🔄 Refresh Tycoon", Callback = function() userTycoon = findTycoon() end})
Tab:CreateButton({Name = "Destroy GUI", Callback = function() Rayfield:Destroy() end})

-- Fruit Loop
task.spawn(function()
    while true do
        task.wait(0.4)
        if AutoFarmChanh then
            for _, tree in ipairs(Trees) do
                if AutoFarmChanh then 
                    pcall(farmOneTree, tree) 
                end
            end
        end
    end
end)

Rayfield:Notify({Title = "✅ AUTO FARM CHANH ĐÃ CHỈNH", Content = "Chỉ TP cây có chanh + Xuyên cây xuống dưới click trái. Thử ngay!", Duration = 10})
