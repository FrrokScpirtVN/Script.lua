-- SMOBILE X HUB - Sol's RNG Style Cutscene Setup
-- For Roblox Studio testing only

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local VALID_KEY = "Smobile100290"
local LINK_KEY = "https://link4sub.com/ohwRMCDban"
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("SmobileXHub") then
    playerGui.SmobileXHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SmobileXHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true -- Che kín tai thỏ / thanh trạng thái
screenGui.Parent = playerGui

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

-- ═══════════ NỀN ĐEN TUYỆT ĐỐI ═══════════
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0 
local bgStroke = Instance.new("UIStroke") -- Tạo vệt sáng viền màn hình (Sol's RNG Vignette)
bgStroke.Color = Color3.fromRGB(255, 215, 0)
bgStroke.Thickness = 0
bgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
bgStroke.Parent = overlay
overlay.BorderSizePixel = 0
overlay.ZIndex = 1
overlay.Parent = screenGui

-- ═══════════ LÓE SÁNG TRẮNG KHI VÀO GAME ═══════════
local flashFrame = Instance.new("Frame")
flashFrame.Size = UDim2.new(1, 0, 1, 0)
flashFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
flashFrame.BackgroundTransparency = 0
flashFrame.ZIndex = 99
flashFrame.BorderSizePixel = 0
flashFrame.Parent = screenGui
TweenService:Create(flashFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
task.delay(0.5, function() flashFrame:Destroy() end)

-- Kích hoạt viền sáng màn hình từ từ dâng lên giống Sol's RNG
TweenService:Create(bgStroke, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 25}):Play()

-- ═══════════ HIỆU ỨNG SAO BĂNG SOL'S RNG ═══════════
local function createSolsMeteor()
    if not screenGui.Parent then return end
    
    -- Khung chứa sao băng để xử lý góc quay và độ dài đuôi
    local meteorContainer = Instance.new("Frame")
    meteorContainer.Size = UDim2.new(0, 150, 0, 20)
    meteorContainer.BackgroundTransparency = 1
    meteorContainer.AnchorPoint = Vector2.new(0, 0.5)
    meteorContainer.ZIndex = 2
    
    -- Điểm bắt đầu: Bay ngẫu nhiên từ viền phát tán ra ngoài
    local startSide = math.random(1, 2)
    if startSide == 1 then
        meteorContainer.Position = UDim2.new(-0.1, 0, math.random(0, 8) / 10, 0)
        meteorContainer.Rotation = math.random(-15, 35)
    else
        meteorContainer.Position = UDim2.new(math.random(0, 8) / 10, 0, -0.1, 0)
        meteorContainer.Rotation = math.random(35, 75)
    end
    meteorContainer.Parent = screenGui

    -- ĐẦU SAO BĂNG (Phát sáng tròn)
    local head = Instance.new("Frame")
    head.Size = UDim2.new(0, 8, 0, 8)
    head.Position = UDim2.new(1, -8, 0.5, -4)
    head.BackgroundColor3 = Color3.fromRGB(255, 240, 180)
    head.BorderSizePixel = 0
    head.ZIndex = 3
    head.Parent = meteorContainer
    Instance.new("UICorner", head).CornerRadius = UDim.new(1, 0)
    
    local headGlow = Instance.new("UIStroke")
    headGlow.Color = Color3.fromRGB(255, 215, 0)
    headGlow.Thickness = 3
    headGlow.Parent = head

    -- ĐUÔI SAO BĂNG (Vệt dài mờ dần về sau)
    local tail = Instance.new("Frame")
    tail.Size = UDim2.new(1, -8, 0, 4)
    tail.Position = UDim2.new(0, 0, 0.5, -2)
    tail.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    tail.BorderSizePixel = 0
    tail.ZIndex = 2
    tail.Parent = meteorContainer
    
    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),   -- Đuôi mờ tịt
        NumberSequenceKeypoint.new(0.8, 0.2), -- Thân sáng dần
        NumberSequenceKeypoint.new(1, 0)     -- Sát đầu sáng rực
    })
    gradient.Parent = tail

    -- Tính toán điểm đích dựa trên góc bay (Phóng vụt qua màn hình cực nhanh)
    local speed = math.random(4, 8) / 10 -- 0.4s đến 0.8s (Tốc độ Sol's RNG siêu nhanh)
    local rad = math.rad(meteorContainer.Rotation)
    local targetX = meteorContainer.Position.X.Scale + math.cos(rad) * 1.5
    local targetY = meteorContainer.Position.Y.Scale + math.sin(rad) * 1.5

    local tween = TweenService:Create(meteorContainer, TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(targetX, 0, targetY, 0)
    })
    
    -- Làm mờ dần nguyên cụm khi sắp hết vòng đời
    task.delay(speed * 0.6, function()
        if meteorContainer and meteorContainer.Parent then
            TweenService:Create(head, TweenInfo.new(speed * 0.4), {BackgroundTransparency = 1}):Play()
            TweenService:Create(tail, TweenInfo.new(speed * 0.4), {BackgroundTransparency = 1}):Play()
            TweenService:Create(headGlow, TweenInfo.new(speed * 0.4), {Transparency = 1}):Play()
        end
    end)

    tween:Play()
    tween.Completed:Connect(function()
        meteorContainer:Destroy()
    end)
end

-- Vòng lặp sinh sao băng liên tục
task.spawn(function()
    while screenGui.Parent do
        createSolsMeteor()
        task.wait(0.2) -- Tạo nhịp rơi dồn dập
    end
end)

-- ═══════════ KHUNG MENU CHÍNH (CARD) ═══════════
local card = Instance.new("Frame")
card.Size = UDim2.new(0, 400, 0, 0)
card.Position = UDim2.new(0.5, -200, 1.5, 0) 
card.BackgroundColor3 = Color3.fromRGB(28, 16, 5)
card.BorderSizePixel = 0
card.ZIndex = 10
card.Parent = screenGui

Instance.new("UICorner", card).CornerRadius = UDim.new(0, 18)

local cardStroke = Instance.new("UIStroke")
cardStroke.Color = Color3.fromRGB(255, 215, 0)
cardStroke.Thickness = 2
cardStroke.Parent = card

local cardLayout = Instance.new("UIListLayout")
cardLayout.FillDirection = Enum.FillDirection.Vertical
cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
cardLayout.Padding = UDim.new(0, 0)
cardLayout.Parent = card

cardLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    local h = cardLayout.AbsoluteContentSize.Y
    card.Size = UDim2.new(0, 400, 0, h)
    card.Position = UDim2.new(0.5, -200, 0.5, -h / 2)
end)

-- ═══════════ HEADER ═══════════
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 62)
header.BackgroundColor3 = Color3.fromRGB(42, 24, 0)
header.BorderSizePixel = 0
header.LayoutOrder = 1
header.ZIndex = 11
header.Parent = card

Instance.new("UICorner", header).CornerRadius = UDim.new(0, 18)

local hFix = Instance.new("Frame")
hFix.Size = UDim2.new(1, 0, 0.5, 0)
hFix.Position = UDim2.new(0, 0, 0.5, 0)
hFix.BackgroundColor3 = Color3.fromRGB(42, 24, 0)
hFix.BorderSizePixel = 0
hFix.ZIndex = 11
hFix.Parent = header

local hDivider = Instance.new("Frame")
hDivider.Size = UDim2.new(1, 0, 0, 1)
hDivider.Position = UDim2.new(0, 0, 1, -1)
hDivider.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
hDivider.BackgroundTransparency = 0.5
hDivider.BorderSizePixel = 0
hDivider.ZIndex = 12
hDivider.Parent = header

local logoImg = Instance.new("ImageLabel")
logoImg.Size = UDim2.new(0, 38, 0, 38)
logoImg.Position = UDim2.new(0, 14, 0.5, -19)
logoImg.BackgroundTransparency = 1
logoImg.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=81681700892882&width=420&height=420&format=png"
logoImg.ZIndex = 13
logoImg.Parent = header
Instance.new("UICorner", logoImg).CornerRadius = UDim.new(0, 8)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 180, 0, 22)
titleLabel.Position = UDim2.new(0, 60, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SMOBILE X HUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 13
titleLabel.Parent = header

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(0, 200, 0, 14)
subtitleLabel.Position = UDim2.new(0, 60, 0, 34)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "HỆ THỐNG XÁC MINH KEY"
subtitleLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextSize = 9
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.ZIndex = 13
subtitleLabel.Parent = header

local fixLagBtn = Instance.new("TextButton")
fixLagBtn.Size = UDim2.new(0, 78, 0, 26)
fixLagBtn.Position = UDim2.new(1, -170, 0.5, -13)
fixLagBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
fixLagBtn.Text = "⚡ Fix Lag"
fixLagBtn.TextColor3 = Color3.fromRGB(20, 10, 0)
fixLagBtn.Font = Enum.Font.GothamBold
fixLagBtn.TextSize = 11
fixLagBtn.ZIndex = 13
fixLagBtn.Parent = header
Instance.new("UICorner", fixLagBtn).CornerRadius = UDim.new(0, 8)

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 60, 0, 26)
langBtn.Position = UDim2.new(1, -84, 0.5, -13)
langBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 5)
langBtn.Text = "🇻🇳 VIE"
langBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
langBtn.Font = Enum.Font.GothamBold
langBtn.TextSize = 10
langBtn.ZIndex = 13
langBtn.Parent = header
Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 8)
local langStroke = Instance.new("UIStroke")
langStroke.Color = Color3.fromRGB(255, 215, 0)
langStroke.Transparency = 0.5
langStroke.Parent = langBtn

-- ═══════════ BODY ═══════════
local body = Instance.new("Frame")
body.Size = UDim2.new(1, 0, 0, 10)
body.BackgroundTransparency = 1
body.LayoutOrder = 2
body.ZIndex = 11
body.Parent = card

local bodyLayout = Instance.new("UIListLayout")
bodyLayout.FillDirection = Enum.FillDirection.Vertical
bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
bodyLayout.Padding = UDim.new(0, 10)
bodyLayout.Parent = body

local bodyPad = Instance.new("UIPadding")
bodyPad.PaddingLeft = UDim.new(0, 14)
bodyPad.PaddingRight = UDim.new(0, 14)
bodyPad.PaddingTop = UDim.new(0, 14)
bodyPad.PaddingBottom = UDim.new(0, 14)
bodyPad.Parent = body

bodyLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    body.Size = UDim2.new(1, 0, 0, bodyLayout.AbsoluteContentSize.Y + 28)
end)

-- User Card
local userCard = Instance.new("Frame")
userCard.Size = UDim2.new(1, 0, 0, 70)
userCard.BackgroundColor3 = Color3.fromRGB(38, 22, 5)
userCard.BorderSizePixel = 0
userCard.LayoutOrder = 1
userCard.ZIndex = 12
userCard.Parent = body
Instance.new("UICorner", userCard).CornerRadius = UDim.new(0, 12)
local ucStroke = Instance.new("UIStroke")
ucStroke.Color = Color3.fromRGB(255, 215, 0)
ucStroke.Transparency = 0.75
ucStroke.Parent = userCard

local avatarFrame = Instance.new("Frame")
avatarFrame.Size = UDim2.new(0, 52, 0, 52)
avatarFrame.Position = UDim2.new(0, 10, 0.5, -26)
avatarFrame.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
avatarFrame.ZIndex = 13
avatarFrame.Parent = userCard
Instance.new("UICorner", avatarFrame).CornerRadius = UDim.new(1, 0)

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(1, -4, 1, -4)
avatarImg.Position = UDim2.new(0, 2, 0, 2)
avatarImg.BackgroundTransparency = 1
avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
avatarImg.ZIndex = 14
avatarImg.Parent = avatarFrame
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

local usernameLabel = Instance.new("TextLabel")
usernameLabel.Size = UDim2.new(1, -80, 0, 22)
usernameLabel.Position = UDim2.new(0, 72, 0, 14)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = "👤 " .. player.Name
usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
usernameLabel.Font = Enum.Font.GothamBold
usernameLabel.TextSize = 14
usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
usernameLabel.ZIndex = 13
usernameLabel.Parent = userCard

local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -80, 0, 18)
warningLabel.Position = UDim2.new(0, 72, 0, 38)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "⚠ Chỉ dùng thử trên Studio!"
warningLabel.TextColor3 = Color3.fromRGB(255, 100, 50)
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextSize = 10
warningLabel.TextXAlignment = Enum.TextXAlignment.Left
warningLabel.ZIndex = 13
warningLabel.Parent = userCard

-- Key Input Frame
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, 0, 0, 46)
inputFrame.BackgroundColor3 = Color3.fromRGB(22, 13, 3)
inputFrame.BorderSizePixel = 0
inputFrame.LayoutOrder = 2
inputFrame.ZIndex = 12
inputFrame.Parent = body
Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 12)

local inStroke = Instance.new("UIStroke")
inStroke.Color = Color3.fromRGB(255, 215, 0)
inStroke.Transparency = 0.65
inStroke.Parent = inputFrame

local keyIconImg = Instance.new("ImageLabel")
keyIconImg.Size = UDim2.new(0, 22, 0, 22)
keyIconImg.Position = UDim2.new(0, 12, 0.5, -11)
keyIconImg.BackgroundTransparency = 1
keyIconImg.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=89276469240002&width=420&height=420&format=png"
keyIconImg.ZIndex = 13
keyIconImg.Parent = inputFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -50, 1, -10)
keyInput.Position = UDim2.new(0, 44, 0, 5)
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = "Dán Key SMOBILE-... vào đây"
keyInput.PlaceholderColor3 = Color3.fromRGB(120, 100, 60)
keyInput.Text = ""
keyInput.TextColor3 = Color3.fromRGB(255, 240, 200)
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 12
keyInput.TextXAlignment = Enum.TextXAlignment.Left
keyInput.ClearTextOnFocus = false
keyInput.ZIndex = 13
keyInput.Parent = inputFrame

-- ═══ STATUS BAR ═══
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 36)
statusBar.BackgroundColor3 = Color3.fromRGB(50, 35, 0)
statusBar.BorderSizePixel = 0
statusBar.LayoutOrder = 3
statusBar.ZIndex = 12
statusBar.Visible = true
statusBar.Parent = body
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 10)

local sbStroke = Instance.new("UIStroke")
sbStroke.Color = Color3.fromRGB(255, 215, 0)
sbStroke.Transparency = 0.4
sbStroke.Parent = statusBar

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(0, 12, 0.5, -5)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 13
statusDot.Parent = statusBar
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -35, 1, 0)
statusLabel.Position = UDim2.new(0, 28, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔗 Vui lòng vượt link và lấy key!"
statusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.ZIndex = 13
statusLabel.Parent = statusBar

-- Buttons Row
local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, 0, 0, 46)
btnRow.BackgroundTransparency = 1
btnRow.LayoutOrder = 4
btnRow.ZIndex = 12
btnRow.Parent = body

local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(0.38, -5, 1, 0)
getKeyBtn.Position = UDim2.new(0, 0, 0, 0)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(28, 18, 5)
getKeyBtn.Text = "LẤY KEY"
getKeyBtn.TextColor3 = Color3.fromRGB(180, 150, 60)
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.TextSize = 11
getKeyBtn.TextXAlignment = Enum.TextXAlignment.Center
getKeyBtn.ZIndex = 13
getKeyBtn.Parent = btnRow
Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 12)
local gkStroke = Instance.new("UIStroke")
gkStroke.Color = Color3.fromRGB(255, 215, 0)
gkStroke.Transparency = 0.7
gkStroke.Parent = getKeyBtn

local getKeyIcon = Instance.new("ImageLabel")
getKeyIcon.Size = UDim2.new(0, 16, 0, 16)
getKeyIcon.Position = UDim2.new(0, 10, 0.5, -8)
getKeyIcon.BackgroundTransparency = 1
getKeyIcon.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=128455470012743&width=420&height=420&format=png"
getKeyIcon.ZIndex = 14
getKeyIcon.Parent = getKeyBtn

local verifyBtn = Instance.new("TextButton")
verifyBtn.Size = UDim2.new(0.62, -5, 1, 0)
verifyBtn.Position = UDim2.new(0.38, 5, 0, 0)
verifyBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
verifyBtn.Text = "✔ XÁC MINH"
verifyBtn.TextColor3 = Color3.fromRGB(20, 10, 0)
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.TextSize = 13
verifyBtn.TextXAlignment = Enum.TextXAlignment.Center
verifyBtn.ZIndex = 13
verifyBtn.Parent = btnRow
Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 12)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 18)
footer.BackgroundTransparency = 1
footer.Text = "SMOBILE X HUB  •  FOR ROBLOX STUDIO ONLY"
footer.TextColor3 = Color3.fromRGB(80, 60, 30)
footer.Font = Enum.Font.Gotham
footer.TextSize = 9
footer.LayoutOrder = 5
footer.ZIndex = 12
footer.Parent = body

-- ═══════════════════════════
-- CÁC LOGIC HÀM XỬ LÝ
-- ═══════════════════════════
local function setStatus(msg, mode)
    statusBar.Visible = true
    statusLabel.Text = msg

    if mode == "success" then
        statusBar.BackgroundColor3 = Color3.fromRGB(10, 40, 10)
        sbStroke.Color = Color3.fromRGB(60, 255, 100)
        statusDot.BackgroundColor3 = Color3.fromRGB(60, 255, 100)
        statusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
        inStroke.Color = Color3.fromRGB(60, 255, 100)
    elseif mode == "error" then
        statusBar.BackgroundColor3 = Color3.fromRGB(45, 10, 10)
        sbStroke.Color = Color3.fromRGB(255, 60, 60)
        statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        inStroke.Color = Color3.fromRGB(255, 60, 60)
    else
        statusBar.BackgroundColor3 = Color3.fromRGB(50, 35, 0)
        sbStroke.Color = Color3.fromRGB(255, 215, 0)
        statusDot.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        statusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        inStroke.Color = Color3.fromRGB(255, 215, 0)
        inStroke.Transparency = 0.65
    end
end

keyInput:GetPropertyChangedSignal("Text"):Connect(function()
    inStroke.Color = Color3.fromRGB(255, 215, 0)
    inStroke.Transparency = 0.65
    setStatus("🔗 Vui lòng vượt link và lấy key!", "default")
end)

local isVie = true
local lagIsFixed = false

local langs = {
    vi = {
        subtitle    = "HỆ THỐNG XÁC MINH KEY",
        warning     = "⚠ Chỉ dùng thử trên Studio!",
        placeholder = "Dán Key SMOBILE-... vào đây",
        getKey      = "LẤY KEY",
        getKeyDone  = "ĐÃ COPY!",
        verify      = "✔ XÁC MINH",
        fixLag      = "⚡ Fix Lag",
        fixLagDone  = "✅ Đã Fix",
        langBtn     = "🇬🇧 ENG",
        empty       = "Vui lòng nhập key ở ô phía trên!",
        wrong       = "Key sai, vui lòng thử lại!",
        correct     = "Key đúng, đang kích hoạt script!",
        lagFixed    = "✅ Đã tối ưu lag thành công!",
        footer      = "SMOBILE X HUB  •  CHỈ THỬ TRÊN STUDIO",
        defaultMsg  = "🔗 Vui lòng vượt link và lấy key!",
    },
    en = {
        subtitle    = "KEY VERIFICATION SYSTEM",
        warning     = "⚠ For Roblox Studio testing only!",
        placeholder = "Paste Key SMOBILE-... here",
        getKey      = "GET KEY",
        getKeyDone  = "COPIED!",
        verify      = "✔ VERIFY",
        fixLag      = "⚡ Fix Lag",
        fixLagDone  = "✅ Fixed",
        langBtn     = "🇻🇳 VIE",
        empty       = "Please enter your key in the box above!",
        wrong       = "Wrong key, please try again!",
        correct     = "Correct key, activating script!",
        lagFixed    = "✅ Lag optimization applied!",
        footer      = "SMOBILE X HUB  •  FOR ROBLOX STUDIO ONLY",
        defaultMsg  = "🔗 Please bypass the link and get your key!",
    }
}

local function getLang() retur
