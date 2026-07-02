local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Frrok Hub | Trolling",
   LoadingTitle = "Welcome to Frrok hub",
   LoadingSubtitle = "by @Frrok",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
   Theme = "Ruby" -- Activate the legendary Red-Black theme of c00lkid
})

local MovementTab = Window:CreateTab("Movement System", 4483362458)
local TrollTab = Window:CreateTab("Trolling", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ==========================================
-- [MOVEMENT SYSTEM]
-- ==========================================
local noclipEnabled, flyEnabled, speedEnabled, infJumpEnabled = false, false, false, false
local flySpeed, speedValue = 50, 16
local bv, bg

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

local function updateFly()
    if flyEnabled then
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        local hrp = LocalPlayer.Character.HumanoidRootPart
        bv = Instance.new("BodyVelocity") bv.MaxForce = Vector3.new(1e9, 1e9, 1e9) bv.Parent = hrp
        bg = Instance.new("BodyGyro") bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9) bg.Parent = hrp
        task.spawn(function()
            while flyEnabled and hrp and bv and bg do
                local camera = workspace.CurrentCamera
                local moveDir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
                bv.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.new(0,0,0)
                bg.CFrame = camera.CFrame
                task.wait()
            end
        end)
    else
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
    end
end

task.spawn(function()
    while true do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            if speedEnabled then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
            elseif LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed == speedValue then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
        end
        task.wait(0.1)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Movement Tab UI
MovementTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) noclipEnabled = v end})
MovementTab:CreateToggle({Name = "Enable Fly", CurrentValue = false, Callback = function(v) flyEnabled = v updateFly() end})
MovementTab:CreateInput({Name = "Fly Speed", PlaceholderText = "50", Callback = function(t) flySpeed = tonumber(t) or 50 end})
MovementTab:CreateToggle({Name = "Enable WalkSpeed", CurrentValue = false, Callback = function(v) speedEnabled = v end})
MovementTab:CreateInput({Name = "Walk Speed", PlaceholderText = "16", Callback = function(t) speedValue = tonumber(t) or 16 end})
MovementTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) infJumpEnabled = v end})


-- ==========================================
-- [TROLLING]
-- ==========================================
local touchFlingEnabled = false
local flingBav
local spamEnabled = false
local spamMessage = "c00lkid is taking over this game! 🔴⬛"
local spamDelay = 2

local spamSlapEnabled = false
local selectedSlapTool = "NormalSlap"
local slapCooldown = 0.05 

-- Auto Slap Loop based on retrieved Remote
task.spawn(function()
    while true do
        if spamSlapEnabled then
            local char = LocalPlayer.Character
            local backpack = LocalPlayer.Backpack
            local remote = nil
            
            if char and char:FindFirstChild(selectedSlapTool) and char[selectedSlapTool]:FindFirstChild("Remote") then
                remote = char[selectedSlapTool].Remote
            elseif backpack and backpack:FindFirstChild(selectedSlapTool) and backpack[selectedSlapTool]:FindFirstChild("Remote") then
                remote = backpack[selectedSlapTool].Remote
            end
            
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer()
            end
        end
        task.wait(slapCooldown)
    end
end)

-- FE Touch Fling Loop (Lock Y axis to prevent self-destruction)
RunService.Heartbeat:Connect(function()
    if touchFlingEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
        
        if not flingBav or flingBav.Parent ~= hrp then
            flingBav = Instance.new("BodyAngularVelocity")
            flingBav.Name = "c00lkidFlingAura"
            flingBav.MaxTorque = Vector3.new(0, math.huge, 0) 
            flingBav.P = 500000
            flingBav.Parent = hrp
        end
        flingBav.AngularVelocity = Vector3.new(0, 95000, 0)
        
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = false end
        end
    else
        if flingBav then flingBav:Destroy() flingBav = nil end
    end
end)

-- Chat Spammer Logic
local function sendChat(text)
    local chatService = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chatService and chatService:FindFirstChild("SayMessageRequest") then
        chatService.SayMessageRequest:FireServer(text, "All")
    else
        local textChatService = game:GetService("TextChatService")
        if textChatService and textChatService.ChatInputBarConfiguration and textChatService.ChatInputBarConfiguration.TargetTextChannel then
            textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(text)
        end
    end
end

task.spawn(function()
    while true do if spamEnabled then sendChat(spamMessage) task.wait(spamDelay) else task.wait(0.5) end end
end)


-- TROLLING & AUTO SLAP UI
TrollTab:CreateSection("--- AUTO SLAP SYSTEM ---")

TrollTab:CreateToggle({
   Name = "Enable Spam Slap",
   CurrentValue = false,
   Callback = function(Value) spamSlapEnabled = Value end,
})

TrollTab:CreateDropdown({
   Name = "Select Target Glove/Hand",
   Options = {"NormalSlap", "GreenHand"},
   CurrentOption = {"NormalSlap"},
   Callback = function(Option)
      if type(Option) == "table" then selectedSlapTool = Option[1] else selectedSlapTool = Option end
   end,
})

TrollTab:CreateInput({
   Name = "Slap Delay (Enter seconds)",
   PlaceholderText = "0.05",
   RemoveTextAfterFocusLoss = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num and num > 0 then
          slapCooldown = num
      else
          Rayfield:Notify({Title = "System Error", Content = "Please enter a valid number of seconds!", Duration = 2})
      end
   end,
})

TrollTab:CreateSection("--- ULTIMATE ---")

TrollTab:CreateToggle({
   Name = "FE Touch Fling (Touch to vanish)",
   CurrentValue = false,
   Callback = function(Value) touchFlingEnabled = Value end,
})

TrollTab:CreateSection("--- TROLLING UTILITIES ---")

TrollTab:CreateSlider({
   Name = "World Gravity",
   Min = 0, Max = 196.2, CurrentValue = 196.2, Flag = "GravitySlider",
   Callback = function(Value) workspace.Gravity = Value end,
})

TrollTab:CreateButton({
   Name = "Get Teleport Tool (Click TP)",
   Callback = function()
      local mouse = LocalPlayer:GetMouse()
      local tool = Instance.new("Tool")
      tool.Name = "c00lkid Teleporter"
      tool.RequiresHandle = false
      tool.Activated:Connect(function()
          if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
              LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p) + Vector3.new(0, 3, 0)
          end
      end)
      tool.Parent = LocalPlayer.Backpack
      Rayfield:Notify({Title = "Success", Content = "Added c00lkid TP Tool!", Duration = 2})
   end,
})

TrollTab:CreateSection("--- CHAT SPAMMER ---")
TrollTab:CreateToggle({Name = "Enable Auto Chat Spam", CurrentValue = false, Callback = function(v) spamEnabled = v end})
TrollTab:CreateInput({Name = "Spam Message Content", PlaceholderText = "c00lkid is taking over this game! 🔴⬛", Callback = function(t) if t and t ~= "" then spamMessage = t end end})
TrollTab:CreateInput({Name = "Chat Delay (Seconds)", PlaceholderText = "2", Callback = function(t) local n = tonumber(t) if n then spamDelay = n end end})

Rayfield:Notify({
   Title = "c00lkid panel v2 activated!",
   Content = "UI changed to chaotic red and black.",
   Duration = 5,
})
