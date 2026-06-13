local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Smobile X Hub|🍋 Sell Lemons | Free",
    LoadingTitle = "Smobile X Hub loaded! ",
    LoadingSubtitle = "By @2mmlxp",
    ConfigurationSaving = { Enabled = false },
})

local MainTab = Window:CreateTab("Main", 4483362458)

local AutoFruit = false
local AutoBuy = false
local AutoUpgrade = false

-- ================== FIND TYCOON ==================
local LocalPlayer = game.Players.LocalPlayer
local userTycoon = nil

local function findTycoon()
    for _, v in ipairs(workspace:GetChildren()) do
        local owner = v:FindFirstChild("Owner")
        if owner and owner.Value == LocalPlayer then
            userTycoon = v
            return v
        end
    end
    return nil
end

userTycoon = findTycoon()
if not userTycoon then
    Rayfield:Notify({Title = "Error", Content = "Không tìm thấy Tycoon của bạn!", Duration = 5})
end

-- ================== AUTO FRUIT (Full Tree) ==================
local Trees = {}

local function addTree(obj)
    if obj:IsA("Model") and obj.Name == "LemonTree" then
        if not table.find(Trees, obj) then table.insert(Trees, obj) end
    end
end

for _, v in ipairs(workspace:GetDescendants()) do addTree(v) end
workspace.DescendantAdded:Connect(addTree)
workspace.DescendantRemoving:Connect(function(obj) 
    local i = table.find(Trees, obj) if i then table.remove(Trees, i) end 
end)

local function hasFruits(tree)
    for _, d in ipairs(tree:GetDescendants()) do
        if d:IsA("ClickDetector") then return true end
    end
    return false
end

local function collectOneTree(tree)
    if not tree or not tree.Parent then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local root = tree:FindFirstChildWhichIsA("BasePart")
    if root then
        hrp.CFrame = root.CFrame * CFrame.new(0, 8, 0)
        task.wait(0.3)
    end

    local attempts = 0
    while hasFruits(tree) and attempts < 30 and AutoFruit do
        attempts += 1
        for _, d in ipairs(tree:GetDescendants()) do
            if d:IsA("ClickDetector") then
                pcall(function() fireclickdetector(d) end)
            end
        end
        task.wait(0.12)
    end
end

-- ================== AUTO BUY ==================
local function getBuyButtons()
    local buttons = {}
    if not userTycoon then return buttons end
    for _, obj in ipairs(userTycoon:FindFirstChild("Purchases") and userTycoon.Purchases:GetDescendants() or {}) do
        if obj:IsA("Model") then
            local shown = obj:GetAttribute("Shown")
            local purchased = obj:GetAttribute("Purchased")
            if shown and not purchased then
                local button = obj:FindFirstChild("Button") or obj:FindFirstChildWhichIsA("BasePart")
                if button then
                    table.insert(buttons, button)
                end
            end
        end
    end
    return buttons
end

local function doAutoBuy()
    while AutoBuy do
        local buttons = getBuyButtons()
        for _, btn in ipairs(buttons) do
            if AutoBuy then
                pcall(function()
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, btn, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, btn, 1)
                end)
            end
        end
        task.wait(0.8)
    end
end

-- ================== AUTO UPGRADE ==================
local function doAutoUpgrade()
    while AutoUpgrade do
        if userTycoon then
            -- Fire all possible upgrade remotes/buttons
            for _, remote in ipairs(game:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:find("Upgrade") or remote.Name:find("Buy")) then
                    pcall(function() remote:FireServer() end)
                end
            end
            -- Click all upgrade GUI buttons if exist
            for _, gui in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if gui:IsA("TextButton") and (gui.Name:find("Upgrade") or gui.Text:find("Upgrade")) then
                    pcall(function() firesignal(gui.Activated) end)
                end
            end
        end
        task.wait(1.2)
    end
end

-- ================== TOGGLES ==================
MainTab:CreateToggle({
    Name = "🍋 Auto Fruit (Full Tree)",
    CurrentValue = false,
    Callback = function(v) AutoFruit = v end
})

MainTab:CreateToggle({
    Name = "🛒 Auto Buy (Giá đỡ + Stand + All)",
    CurrentValue = false,
    Callback = function(v) 
        AutoBuy = v 
        if v then task.spawn(doAutoBuy) end
    end
})

MainTab:CreateToggle({
    Name = "📈 Auto Upgrade (Xưởng + All Upgrades)",
    CurrentValue = false,
    Callback = function(v) 
        AutoUpgrade = v 
        if v then task.spawn(doAutoUpgrade) end
    end
})

MainTab:CreateButton({Name = "Destroy GUI", Callback = function() Rayfield:Destroy() end})

-- Main Fruit Loop
task.spawn(function()
    while true do
        task.wait(0.4)
        if AutoFruit then
            for _, tree in ipairs(Trees) do
                if AutoFruit then pcall(collectOneTree, tree) end
            end
        end
    end
end)

Rayfield:Notify({Title = "✅ Loaded!", Content = "Auto Fruit + Auto Buy + Auto Upgrade đã sẵn sàng!", Duration = 6})
