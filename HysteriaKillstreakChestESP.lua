--// Hysteria Chest ESP - Passcode + Discord Key + Chest Names

-- 1. SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

-- 2. SIMPLE PASSCODE GATE
local ACCESS_CODE = "HYSTERIA"
local DISCORD_INVITE = "https://discord.gg/BZU6G2VWq7"

-- Remove any GUI left behind by an older execution.
local previousMainGui = CoreGui:FindFirstChild("ChestFilterGUI")
if previousMainGui then
    previousMainGui:Destroy()
end

local previousAccessGui = CoreGui:FindFirstChild("HysteriaChestAccess")
if previousAccessGui then
    previousAccessGui:Destroy()
end

local accessGui = Instance.new("ScreenGui")
accessGui.Name = "HysteriaChestAccess"
accessGui.ResetOnSpawn = false
accessGui.Parent = CoreGui

-- Small notification shown when the Discord link is copied.
local toast = Instance.new("Frame")
toast.Size = UDim2.new(0, 260, 0, 38)
toast.Position = UDim2.new(0.5, -130, 0, 28)
toast.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
toast.BorderSizePixel = 1
toast.BorderColor3 = Color3.fromRGB(80, 80, 90)
toast.Visible = false
toast.ZIndex = 20
toast.Parent = accessGui

local toastText = Instance.new("TextLabel")
toastText.Size = UDim2.new(1, -16, 1, 0)
toastText.Position = UDim2.new(0, 8, 0, 0)
toastText.BackgroundTransparency = 1
toastText.Text = ""
toastText.TextColor3 = Color3.fromRGB(255, 255, 255)
toastText.Font = Enum.Font.SourceSansBold
toastText.TextSize = 13
toastText.ZIndex = 21
toastText.Parent = toast

local toastVersion = 0
local function showToast(message, isSuccess)
    toastVersion = toastVersion + 1
    local currentVersion = toastVersion

    toast.BackgroundColor3 = isSuccess
        and Color3.fromRGB(35, 105, 60)
        or Color3.fromRGB(120, 45, 45)
    toastText.Text = message
    toast.Visible = true

    task.delay(2.5, function()
        if currentVersion == toastVersion and toast.Parent then
            toast.Visible = false
        end
    end)
end

local accessFrame = Instance.new("Frame")
accessFrame.Size = UDim2.new(0, 280, 0, 178)
accessFrame.Position = UDim2.new(0.5, -140, 0.5, -89)
accessFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
accessFrame.BorderSizePixel = 2
accessFrame.BorderColor3 = Color3.fromRGB(60, 60, 70)
accessFrame.Active = true
accessFrame.Draggable = true
accessFrame.Parent = accessGui

local accessTitleBar = Instance.new("Frame")
accessTitleBar.Size = UDim2.new(1, 0, 0, 35)
accessTitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
accessTitleBar.BorderSizePixel = 0
accessTitleBar.Parent = accessFrame

local accessTitle = Instance.new("TextLabel")
accessTitle.Size = UDim2.new(1, -16, 1, 0)
accessTitle.Position = UDim2.new(0, 8, 0, 0)
accessTitle.BackgroundTransparency = 1
accessTitle.Text = "Hysteria Chest ESP"
accessTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
accessTitle.TextXAlignment = Enum.TextXAlignment.Left
accessTitle.Font = Enum.Font.SourceSansBold
accessTitle.TextSize = 14
accessTitle.Parent = accessTitleBar

local accessPrompt = Instance.new("TextLabel")
accessPrompt.Size = UDim2.new(1, -20, 0, 20)
accessPrompt.Position = UDim2.new(0, 10, 0, 43)
accessPrompt.BackgroundTransparency = 1
accessPrompt.Text = "Enter passcode to continue"
accessPrompt.TextColor3 = Color3.fromRGB(215, 215, 220)
accessPrompt.TextXAlignment = Enum.TextXAlignment.Left
accessPrompt.Font = Enum.Font.SourceSans
accessPrompt.TextSize = 13
accessPrompt.Parent = accessFrame

local accessBox = Instance.new("TextBox")
accessBox.Size = UDim2.new(1, -20, 0, 30)
accessBox.Position = UDim2.new(0, 10, 0, 67)
accessBox.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
accessBox.BorderSizePixel = 1
accessBox.BorderColor3 = Color3.fromRGB(80, 80, 90)
accessBox.ClearTextOnFocus = false
accessBox.PlaceholderText = "Passcode"
accessBox.Text = ""
accessBox.TextColor3 = Color3.fromRGB(255, 255, 255)
accessBox.PlaceholderColor3 = Color3.fromRGB(145, 145, 155)
accessBox.Font = Enum.Font.SourceSans
accessBox.TextSize = 14
accessBox.Parent = accessFrame

local discordButton = Instance.new("TextButton")
discordButton.Size = UDim2.new(0, 158, 0, 28)
discordButton.Position = UDim2.new(0, 10, 0, 105)
discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordButton.BorderSizePixel = 0
discordButton.Text = "Get Key in Discord"
discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
discordButton.Font = Enum.Font.SourceSansBold
discordButton.TextSize = 13
discordButton.Parent = accessFrame

local unlockButton = Instance.new("TextButton")
unlockButton.Size = UDim2.new(0, 92, 0, 28)
unlockButton.Position = UDim2.new(1, -102, 0, 105)
unlockButton.BackgroundColor3 = Color3.fromRGB(45, 160, 80)
unlockButton.BorderSizePixel = 0
unlockButton.Text = "Unlock"
unlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
unlockButton.Font = Enum.Font.SourceSansBold
unlockButton.TextSize = 13
unlockButton.Parent = accessFrame

local accessStatus = Instance.new("TextLabel")
accessStatus.Size = UDim2.new(1, -20, 0, 28)
accessStatus.Position = UDim2.new(0, 10, 0, 140)
accessStatus.BackgroundTransparency = 1
accessStatus.Text = "Need a key? Press the Discord button."
accessStatus.TextColor3 = Color3.fromRGB(165, 165, 175)
accessStatus.TextXAlignment = Enum.TextXAlignment.Left
accessStatus.Font = Enum.Font.SourceSans
accessStatus.TextSize = 12
accessStatus.Parent = accessFrame

local accessGrantedEvent = Instance.new("BindableEvent")
local accessGranted = false
local submitting = false

local function copyDiscordInvite()
    local copyFunction = setclipboard or toclipboard
    local copied = false

    if copyFunction then
        copied = pcall(copyFunction, DISCORD_INVITE)
    end

    if copied then
        discordButton.Text = "Copied!"
        accessStatus.TextColor3 = Color3.fromRGB(90, 220, 120)
        accessStatus.Text = "Discord link copied to clipboard."
        showToast("Copied to clipboard!", true)

        task.delay(2.5, function()
            if discordButton.Parent then
                discordButton.Text = "Get Key in Discord"
            end
        end)
    else
        accessStatus.TextColor3 = Color3.fromRGB(230, 80, 80)
        accessStatus.Text = "Clipboard is unavailable in this executor."
        showToast("Clipboard unavailable", false)
    end
end

local function submitPasscode()
    if submitting or accessGranted then
        return
    end

    submitting = true

    if accessBox.Text == ACCESS_CODE then
        accessGranted = true
        accessStatus.TextColor3 = Color3.fromRGB(90, 220, 120)
        accessStatus.Text = "Access granted"
        unlockButton.Text = "Unlocked"

        task.delay(0.2, function()
            accessGrantedEvent:Fire()
            if accessGui.Parent then
                accessGui:Destroy()
            end
        end)
    else
        accessStatus.TextColor3 = Color3.fromRGB(230, 80, 80)
        accessStatus.Text = "Incorrect passcode"
        accessBox.Text = ""
        accessBox:CaptureFocus()
        submitting = false
    end
end

discordButton.MouseButton1Click:Connect(copyDiscordInvite)
unlockButton.MouseButton1Click:Connect(submitPasscode)

accessBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        submitPasscode()
    end
end)

accessBox:CaptureFocus()
accessGrantedEvent.Event:Wait()
accessGrantedEvent:Destroy()

-- 3. TRACK DOWN THE CHEST FOLDER
local mainWorkspace = workspace
local nestedWorkspace = mainWorkspace:FindFirstChild("Workspace")
if not nestedWorkspace then
    return
end

local brChests = nestedWorkspace:FindFirstChild("BR_Chests")
if not brChests then
    return
end

-- 4. CONFIGURATION
local DEFAULT_CHEST_TYPES = {
    "CommonChest",
    "UncommonChest",
    "RareChest",
    "EpicChest",
    "LegendaryChest",
}

local CHEST_DISPLAY_NAMES = {
    CommonChest = "Common",
    UncommonChest = "Uncommon",
    RareChest = "Rare",
    EpicChest = "Epic",
    LegendaryChest = "Legendary",
}

local CHEST_COLORS = {
    CommonChest = Color3.fromRGB(105, 105, 115),      -- Grey
    UncommonChest = Color3.fromRGB(45, 160, 80),      -- Green
    RareChest = Color3.fromRGB(45, 105, 220),         -- Blue
    EpicChest = Color3.fromRGB(145, 65, 210),         -- Purple
    LegendaryChest = Color3.fromRGB(235, 135, 35),    -- Orange
}

local DEFAULT_ESP_DISTANCE = 1000 -- Studs. Set to 0 for unlimited distance.
local MAX_ESP_DISTANCE = 100000
local DISTANCE_UPDATE_RATE = 0.20

local ActiveFilters = {}
local TrackedChests = {}
local TrackedChestNames = {}
local ToggleRows = {}

local espDistance = DEFAULT_ESP_DISTANCE
local showChestNames = false
local menuVisible = true
local currentKeybind = Enum.KeyCode.RightShift
local isBindingKey = false

-- 5. CHEST/PLAYER HELPERS
local function getPlayerPosition()
    local character = localPlayer.Character
    if not character then
        return nil
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
        or character.PrimaryPart
        or character:FindFirstChildWhichIsA("BasePart")

    return rootPart and rootPart.Position or nil
end

local function getObjectPosition(object)
    if object:IsA("BasePart") then
        return object.Position
    end

    if object:IsA("Model") then
        local success, pivot = pcall(function()
            return object:GetPivot()
        end)

        if success then
            return pivot.Position
        end

        local part = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart", true)
        return part and part.Position or nil
    end

    return nil
end

local function isWithinDistance(object)
    -- A distance of 0 means unlimited.
    if espDistance <= 0 then
        return true
    end

    local playerPosition = getPlayerPosition()
    local objectPosition = getObjectPosition(object)

    if not playerPosition or not objectPosition then
        return false
    end

    return (playerPosition - objectPosition).Magnitude <= espDistance
end

local function getChestDisplayName(chestName)
    local configuredName = CHEST_DISPLAY_NAMES[chestName]
    if configuredName then
        return configuredName .. " Chest"
    end

    local cleanedName = chestName:gsub("Chest", "")
    if cleanedName == "" then
        cleanedName = chestName
    end

    return cleanedName .. " Chest"
end

local function getChestAdornee(object)
    if object:IsA("BasePart") then
        return object
    end

    if object:IsA("Model") then
        return object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart", true)
    end

    return nil
end

local function getChestColor(chestName)
    local configuredColor = CHEST_COLORS[chestName]
    if configuredColor then
        return configuredColor
    end

    local lowerName = string.lower(chestName)

    if string.find(lowerName, "legend") then
        return Color3.fromRGB(235, 135, 35) -- Orange
    elseif string.find(lowerName, "epic") then
        return Color3.fromRGB(145, 65, 210) -- Purple
    elseif string.find(lowerName, "rare") then
        return Color3.fromRGB(45, 105, 220) -- Blue
    elseif string.find(lowerName, "uncommon") then
        return Color3.fromRGB(45, 160, 80) -- Green
    elseif string.find(lowerName, "common") then
        return Color3.fromRGB(105, 105, 115) -- Grey
    end

    return Color3.fromRGB(0, 200, 220) -- Default Cyan
end

-- 6. ESP MANAGEMENT
local function clearESP(object)
    local trackedHighlight = TrackedChests[object]
    if trackedHighlight then
        trackedHighlight:Destroy()
    end

    local existingHighlight = object:FindFirstChild("ChestESP")
    if existingHighlight and existingHighlight:IsA("Highlight") then
        existingHighlight:Destroy()
    end

    TrackedChests[object] = nil
end

local function clearChestName(object)
    local trackedName = TrackedChestNames[object]
    if trackedName then
        trackedName:Destroy()
    end

    for _, descendant in ipairs(object:GetDescendants()) do
        if descendant:IsA("BillboardGui") and descendant.Name == "ChestNameESP" then
            descendant:Destroy()
        end
    end

    TrackedChestNames[object] = nil
end

local function cleanupLegacyESP(object)
    clearESP(object)
    clearChestName(object)

    -- Removes highlights left behind by older versions that parented the
    -- Highlight to a part inside the chest instead of the chest itself.
    for _, descendant in ipairs(object:GetDescendants()) do
        if descendant:IsA("Highlight") and descendant.Name == "ChestESP" then
            descendant:Destroy()
        end
    end
end

local function shouldShowESP(object)
    if not object.Parent then
        return false
    end

    if not (object:IsA("BasePart") or object:IsA("Model")) then
        return false
    end

    if ActiveFilters[object.Name] == false then
        return false
    end

    return isWithinDistance(object)
end

local function ensureESP(object)
    local highlight = TrackedChests[object]

    if highlight and highlight.Parent then
        highlight.FillColor = getChestColor(object.Name)
        return
    end

    local existingHighlight = object:FindFirstChild("ChestESP")
    if existingHighlight and existingHighlight:IsA("Highlight") then
        TrackedChests[object] = existingHighlight
        existingHighlight.FillColor = getChestColor(object.Name)
        return
    end

    highlight = Instance.new("Highlight")
    highlight.Name = "ChestESP"
    highlight.Adornee = object
    highlight.FillColor = getChestColor(object.Name)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = object

    TrackedChests[object] = highlight
end

local function ensureChestName(object)
    local existingName = TrackedChestNames[object]
    if existingName and existingName.Parent then
        local textLabel = existingName:FindFirstChild("NameLabel")
        if textLabel and textLabel:IsA("TextLabel") then
            textLabel.Text = getChestDisplayName(object.Name)
            textLabel.TextColor3 = getChestColor(object.Name)
        end
        return
    end

    local adornee = getChestAdornee(object)
    if not adornee then
        clearChestName(object)
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ChestNameESP"
    billboard.Adornee = adornee
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.Size = UDim2.new(0, 150, 0, 28)
    billboard.StudsOffsetWorldSpace = Vector3.new(0, 3.5, 0)
    billboard.Parent = adornee

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = getChestDisplayName(object.Name)
    nameLabel.TextColor3 = getChestColor(object.Name)
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 15
    nameLabel.Parent = billboard

    TrackedChestNames[object] = billboard
end

local function refreshChest(object)
    if shouldShowESP(object) then
        ensureESP(object)

        if showChestNames then
            ensureChestName(object)
        else
            clearChestName(object)
        end
    else
        clearESP(object)
        clearChestName(object)
    end
end

local function updateAllChests()
    for _, chest in ipairs(brChests:GetChildren()) do
        refreshChest(chest)
    end
end

-- 7. BUILD THE GUI
local oldGui = CoreGui:FindFirstChild("ChestFilterGUI")
if oldGui then
    oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChestFilterGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 325)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(60, 60, 70)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.65, 0, 1, 0)
titleText.Position = UDim2.new(0, 8, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Hysteria Chest ESP"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 14
titleText.Parent = titleBar

local keybindBtn = Instance.new("TextButton")
keybindBtn.Size = UDim2.new(0.3, 0, 0, 23)
keybindBtn.Position = UDim2.new(0.7, -6, 0, 6)
keybindBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
keybindBtn.BorderSizePixel = 1
keybindBtn.BorderColor3 = Color3.fromRGB(80, 80, 90)
keybindBtn.Text = "[" .. currentKeybind.Name .. "]"
keybindBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
keybindBtn.Font = Enum.Font.SourceSansBold
keybindBtn.TextSize = 12
keybindBtn.Parent = titleBar

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -85)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local watermark = Instance.new("TextButton")
watermark.Size = UDim2.new(1, 0, 0, 30)
watermark.Position = UDim2.new(0, 0, 1, -30)
watermark.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
watermark.BorderSizePixel = 0
watermark.Text = "discord.gg/BZU6G2VWq7"
watermark.TextColor3 = Color3.fromRGB(114, 137, 218)
watermark.Font = Enum.Font.SourceSansBold
watermark.TextSize = 13
watermark.Parent = frame

-- 8. DISTANCE CONTROL
local distanceRow = Instance.new("Frame")
distanceRow.Name = "DistanceRow"
distanceRow.LayoutOrder = 1
distanceRow.Size = UDim2.new(1, -8, 0, 30)
distanceRow.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
distanceRow.BorderSizePixel = 0
distanceRow.Parent = scroll

local distanceLabel = Instance.new("TextLabel")
distanceLabel.Size = UDim2.new(0, 120, 1, 0)
distanceLabel.Position = UDim2.new(0, 7, 0, 0)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "Distance (0 = unlimited)"
distanceLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
distanceLabel.Font = Enum.Font.SourceSans
distanceLabel.TextSize = 12
distanceLabel.Parent = distanceRow

local distanceBox = Instance.new("TextBox")
distanceBox.Size = UDim2.new(0, 78, 0, 22)
distanceBox.Position = UDim2.new(1, -84, 0.5, -11)
distanceBox.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
distanceBox.BorderSizePixel = 1
distanceBox.BorderColor3 = Color3.fromRGB(80, 80, 90)
distanceBox.ClearTextOnFocus = false
distanceBox.Text = tostring(espDistance)
distanceBox.PlaceholderText = "Studs"
distanceBox.TextColor3 = Color3.fromRGB(255, 255, 255)
distanceBox.Font = Enum.Font.SourceSansBold
distanceBox.TextSize = 13
distanceBox.Parent = distanceRow

local function applyDistanceText()
    local value = tonumber(distanceBox.Text)

    if value then
        espDistance = math.clamp(math.floor(value), 0, MAX_ESP_DISTANCE)
    end

    distanceBox.Text = tostring(espDistance)
    updateAllChests()
end

distanceBox.FocusLost:Connect(applyDistanceText)

-- Optional name labels displayed above visible chests.
local namesRow = Instance.new("TextButton")
namesRow.Name = "ChestNamesToggle"
namesRow.LayoutOrder = 2
namesRow.Size = UDim2.new(1, -8, 0, 30)
namesRow.TextColor3 = Color3.fromRGB(255, 255, 255)
namesRow.TextXAlignment = Enum.TextXAlignment.Left
namesRow.Font = Enum.Font.SourceSans
namesRow.TextSize = 14
namesRow.Parent = scroll

local function refreshNamesRow()
    namesRow.BackgroundColor3 = showChestNames
        and Color3.fromRGB(45, 105, 220)
        or Color3.fromRGB(85, 45, 45)
    namesRow.Text = "  Chest Names" .. (showChestNames and " : ON" or " : OFF")
end

refreshNamesRow()

namesRow.MouseButton1Click:Connect(function()
    showChestNames = not showChestNames
    refreshNamesRow()
    updateAllChests()
end)

-- 9. PERMANENT CHEST FILTER ROWS
local fixedOrder = {}
for index, chestName in ipairs(DEFAULT_CHEST_TYPES) do
    fixedOrder[chestName] = index
end

local function createToggleRow(chestName)
    if ToggleRows[chestName] then
        return
    end

    if ActiveFilters[chestName] == nil then
        ActiveFilters[chestName] = true
    end

    local row = Instance.new("TextButton")
    row.Name = chestName .. "Toggle"
    row.LayoutOrder = 10 + (fixedOrder[chestName] or 1000)
    row.Size = UDim2.new(1, -8, 0, 30)
    row.TextColor3 = Color3.fromRGB(255, 255, 255)
    row.TextXAlignment = Enum.TextXAlignment.Left
    row.Font = Enum.Font.SourceSans
    row.TextSize = 14
    row.Parent = scroll

    ToggleRows[chestName] = row

    local function refreshRowAppearance()
        local enabled = ActiveFilters[chestName] == true
        local displayName = CHEST_DISPLAY_NAMES[chestName] or chestName
        local rarityColor = CHEST_COLORS[chestName] or getChestColor(chestName)

        row.BackgroundColor3 = enabled
            and rarityColor
            or Color3.fromRGB(85, 45, 45)
        row.Text = "  " .. displayName .. (enabled and " : ON" or " : OFF")
    end

    refreshRowAppearance()

    row.MouseButton1Click:Connect(function()
        ActiveFilters[chestName] = not ActiveFilters[chestName]
        refreshRowAppearance()
        updateAllChests()
    end)
end

-- Create all five standard rows immediately, even when that rarity currently
-- has no spawned chest. This prevents LegendaryChest (or any other row) from
-- disappearing from the menu.
for _, chestName in ipairs(DEFAULT_CHEST_TYPES) do
    createToggleRow(chestName)
end

-- 10. KEYBIND LOGIC
keybindBtn.MouseButton1Click:Connect(function()
    isBindingKey = true
    keybindBtn.Text = "[...]"
    keybindBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if isBindingKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            currentKeybind = input.KeyCode
            keybindBtn.Text = "[" .. currentKeybind.Name .. "]"
            keybindBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            isBindingKey = false
        end
        return
    end

    if input.KeyCode == currentKeybind then
        menuVisible = not menuVisible
        frame.Visible = menuVisible
    end
end)

-- 11. DISCORD WATERMARK
watermark.MouseButton1Click:Connect(function()
    local fullInviteLink = "https://discord.gg/BZU6G2VWq7"

    if setclipboard then
        setclipboard(fullInviteLink)
        watermark.Text = "Copied Full Path! Paste in Browser"
    elseif toclipboard then
        toclipboard(fullInviteLink)
        watermark.Text = "Copied Full Path! Paste in Browser"
    else
        watermark.Text = "Copy Error - Check Executor Logs"
    end

    task.delay(3, function()
        if watermark.Parent then
            watermark.Text = "discord.gg/BZU6G2VWq7"
        end
    end)
end)

-- 12. INITIAL SCAN + LIVE UPDATES
local function scanForNewRarities()
    for _, chest in ipairs(brChests:GetChildren()) do
        -- Unknown/new chest types still receive their own toggle row.
        createToggleRow(chest.Name)
        cleanupLegacyESP(chest)
        refreshChest(chest)
    end
end

brChests.ChildAdded:Connect(function(chest)
    task.wait(0.2)
    createToggleRow(chest.Name)
    cleanupLegacyESP(chest)
    refreshChest(chest)
end)

brChests.ChildRemoved:Connect(function(chest)
    clearESP(chest)
    clearChestName(chest)
end)

-- Re-check distance as the player moves or chests spawn/despawn.
task.spawn(function()
    local elapsed = 0

    while screenGui.Parent do
        elapsed = elapsed + RunService.Heartbeat:Wait()

        if elapsed >= DISTANCE_UPDATE_RATE then
            elapsed = 0
            updateAllChests()
        end
    end
end)

scanForNewRarities()
