local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- LINK CONFIGURATION
local LinkScript = "https://raw.githubusercontent.com/YOUR_SCRIPT_LINK_HERE/main/script.lua"
local DiscordLink = "https://discord.gg/your-discord-link-here"

-- KEY SYSTEM VARIABLES
local TimerStarted = false
local TimerFinished = false
local CurrentValidKey = "" -- This variable will store the random key generated after 75s

-- RANDOM KEY GENERATION FUNCTION (16 characters: uppercase, lowercase, numbers)
local function GenerateRandomKey()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local randomString = "KeyFree_"
    
    -- Create a random seed based on real time to prevent duplication
    math.randomseed(tick()) 
    
    for i = 1, 16 do
        local randIndex = math.random(1, #chars)
        randomString = randomString .. string.sub(chars, randIndex, randIndex)
    end
    return randomString
end

local Window = Rayfield:CreateWindow({
   Name = "Frrok Hub | Key System",
   LoadingTitle = "Frrok Hub is Loading...",
   LoadingSubtitle = "by Gz_Frrok",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "FrrokHub",
      FileName = "Config"
   },
   Theme = "Default", -- Đã chuyển sang Default (Theme màu đen/tối)
})

-- HOME TAB
local HomeTab = Window:CreateTab("Home", 4483362456)

HomeTab:CreateSection("Introduction")
HomeTab:CreateParagraph({Title = "Welcome to Frrok Hub!", Content = "We are committed to providing the highest quality scripts for your experience."})
HomeTab:CreateParagraph({Title = "Feedback", Content = "If you encounter any errors or are dissatisfied, please contact Gz_Frrok directly on Instagram for support."})

HomeTab:CreateSection("Community")
HomeTab:CreateButton({
   Name = "Copy Discord Link",
   Callback = function()
      setclipboard(DiscordLink)
      Rayfield:Notify({Title = "Copied", Content = "Discord link copied to clipboard!", Duration = 3})
   end
})

-- KEY SYSTEM TAB 
local KeyTab = Window:CreateTab("Key System", 11385220614)
local InputKey = ""

KeyTab:CreateSection("Authentication & Activation")

KeyTab:CreateInput({
   Name = "Enter your Key",
   PlaceholderText = "Enter your key here...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      InputKey = Text
   end
})

KeyTab:CreateButton({
   Name = "Check Key",
   Callback = function()
      -- Compare the user input key with the generated random key
      if InputKey == CurrentValidKey and CurrentValidKey ~= "" then
         Rayfield:Notify({
            Title = "Correct Key!",
            Content = "Loading Script...",
            Duration = 5,
            Image = 4483362456
         })

         local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FrrokScpirtVN/Script.lua/refs/heads/main/Gojito.lua"))()
         end)

         if not success then
            Rayfield:Notify({Title = "Error", Content = "Cannot run script: " .. tostring(err), Duration = 5})
         end
         
      else
         Rayfield:Notify({
            Title = "Invalid Key!",
            Content = "Please check your key and try again.",
            Duration = 5,
            Image = 4483362456
         })
      end
   end
})

-- GET KEY TAB 
local GetKeyTab = Window:CreateTab("Get Key", 4483362456)
local TimerLabel = GetKeyTab:CreateLabel("Click get key to receive the key!")

GetKeyTab:CreateSection("Key Generator")
GetKeyTab:CreateButton({
    Name = "Get key",
    Callback = function()
        if TimerStarted then 
            Rayfield:Notify({Title = "Notice", Content = "Key generation has already started!", Duration = 3})
            return 
        end
        
        TimerStarted = true
        
        task.spawn(function()
            for i = 75, 0, -1 do
                TimerLabel:Set("Time: " .. i .. "s")
                task.wait(1)
            end
            
            -- AFTER 75 SECONDS, GENERATE AND SAVE THE RANDOM KEY
            CurrentValidKey = GenerateRandomKey()
            
            TimerLabel:Set("Done! You can now copy the Key.")
            TimerFinished = true
        end)
    end
})

GetKeyTab:CreateButton({
    Name = "Copy Key",
    Callback = function()
        if TimerFinished then
            setclipboard(CurrentValidKey) -- Copy the newly generated random key to clipboard
            Rayfield:Notify({Title = "Success", Content = "Key copied to clipboard!", Duration = 5})
        else
            Rayfield:Notify({Title = "Not Finished", Content = "Please wait for the 75-second countdown to finish!", Duration = 5})
        end
    end
})
