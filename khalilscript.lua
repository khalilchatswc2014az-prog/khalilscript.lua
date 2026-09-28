-- ================================================================================
-- سكربت خليل | Khalil Script - الإصدار 3.0 (النسخة النهائية)
-- ================================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

if _G.KhalilCleanup then
    pcall(function() _G.KhalilCleanup() end)
end

local Connections = {}
local function bind(signal, callback)
    local conn = signal:Connect(callback)
    table.insert(Connections, conn)
    return conn
end

pcall(function()
    local oldGui = game.CoreGui:FindFirstChild("KhalilScript")
    if oldGui then oldGui:Destroy() end
end)

local State = {
    fly = false, infJump = false, speed = false, jump = false,
    ghost = false, god = false, hitbox = false, esp = false, espBox = false,
    espNames = true, espDist = true, espHp = false, espMorph = false,
    espSpeed = false, espArrow = false, espClosest = false, espAlert = false,
    espList = false, espMap = false, fov = false, zoom = false, freecam = false,
    noshake = false, items = false, coll = false, autoScan = true,
    wpShow = false, fullbright = false
}

local Values = {
    speed = 16, jumpPower = 50, hitboxSize = 5, espRange = 500,
    fov = 70, zoom = 400, scanInterval = 3, uiScale = 1.0, uiTransparency = 0
}

local FlyBV = nil
local FlyBG = nil
local FlyUp = false
local FlyDown = false
local GiantHitboxPart = nil
local ESPObjects = {}
local ESPHidden = false
local FreecamData = { yaw = 0, pitch = 0, pos = Vector3.new() }
local Waypoints = {}
local SavedLocation = nil
local FinderItems = {}
local FinderCoins = {}
local ScanNow = false
local IsMinimized = false
local IsAlive = true
local SAVE_FILE = "KhalilSettings.json"
local CanSave = (writefile and readfile and isfile and delfile) and true or false
local UISetters = {}

local function getChar() return LocalPlayer.Character end
local function getHum()
    local c = getChar()
    if not c then return nil end
    return c:FindFirstChildOfClass("Humanoid")
end
local function getRoot()
    local c = getChar()
    if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart")
end
local function otherHum(c)
    if not c then return nil end
    return c:FindFirstChildOfClass("Humanoid") or c:FindFirstChild("Humanoid")
end
local function otherRoot(c)
    if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart
        or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
        or c:FindFirstChildWhichIsA("BasePart")
end
local function getSafeParent()
    if gethui then
        local ok, res = pcall(gethui)
        if ok and res then return res end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local Colors = {
    Navy = Color3.fromRGB(7, 12, 30),
    Panel = Color3.fromRGB(10, 18, 40),
    Blue = Color3.fromRGB(0, 140, 255),
    Green = Color3.fromRGB(0, 220, 100),
    Purple = Color3.fromRGB(150, 60, 255),
    Red = Color3.fromRGB(255, 40, 70),
    Cyan = Color3.fromRGB(0, 200, 255),
    Orange = Color3.fromRGB(255, 170, 0),
    White = Color3.new(1, 1, 1),
    Black = Color3.fromRGB(0, 0, 0)
}

local function addCorner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = r or UDim.new(0, 10)
    return c
end
local function addStroke(p, col, t)
    local s = Instance.new("UIStroke", p)
    s.Color = col
    s.Thickness = t or 2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end
local function createFrame(p, pos, size, bg)
    local f = Instance.new("Frame", p)
    f.Position = pos
    f.Size = size
    if bg then f.BackgroundColor3 = bg else f.BackgroundTransparency = 1 end
    f.BorderSizePixel = 0
    return f
end
local function createLabel(p, text, sz, pos, size, col)
    local l = Instance.new("TextLabel", p)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.GothamBold
    l.TextSize = sz
    l.TextColor3 = col or Colors.White
    l.Position = pos
    l.Size = size
    l.BorderSizePixel = 0
    return l
end
local function createButton(p, text, sz, pos, size, bg, col)
    local b = Instance.new("TextButton", p)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = sz
    b.TextColor3 = col or Colors.White
    b.BackgroundColor3 = bg or Colors.Panel
    b.AutoButtonColor = true
    b.BorderSizePixel = 0
    b.Position = pos
    b.Size = size
    return b
end
local function createTextBox(p, text, sz, pos, size, bg, borderCol)
    local tb = Instance.new("TextBox", p)
    tb.Position = pos
    tb.Size = size
    tb.BackgroundColor3 = bg or Color3.fromRGB(6, 12, 30)
    tb.BorderSizePixel = 0
    tb.Font = Enum.Font.GothamBold
    tb.TextSize = sz or 16
    tb.TextColor3 = Colors.White
    tb.Text = text or ""
    tb.ClearTextOnFocus = false
    addCorner(tb, UDim.new(0, 8))
    if borderCol then addStroke(tb, borderCol, 1.5) end
    return tb
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhalilScript"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = getSafeParent()

local MainFrame = createFrame(ScreenGui, UDim2.new(0.5, 0, 0.5, 0), UDim2.fromOffset(500, 440), Colors.Navy)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Active = true
addCorner(MainFrame, UDim.new(0, 18))
addStroke(MainFrame, Colors.Blue, 3)

local MainGradient = Instance.new("UIGradient", MainFrame)
MainGradient.Rotation = 90
MainGradient.Color = ColorSequence.new(Color3.fromRGB(12, 22, 52), Color3.fromRGB(5, 9, 24))

local UIScaleInstance = Instance.new("UIScale", MainFrame)

do
    local dragging = false
    local dragStart = nil
    local startPos = nil
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local target = input.Target
            if target and (target:IsA("TextButton") or target:IsA("ImageButton") 
                or target:IsA("TextBox")) then
                return
            end
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    bind(UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    bind(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local Crown = createLabel(MainFrame, "👑", 46, UDim2.new(0.5, -30, 0, -38), UDim2.fromOffset(60, 50), Color3.fromRGB(80, 190, 255))
Crown.ZIndex = 5
createLabel(MainFrame, "سكربت خليل", 36, UDim2.new(0, 130, 0, 14), UDim2.fromOffset(330, 50), Color3.fromRGB(190, 235, 255))
createLabel(MainFrame, "كل ما تحتاجه في مكان واحد", 15, UDim2.new(0, 130, 0, 62), UDim2.fromOffset(330, 22), Colors.Cyan)

local CloseButton = createButton(MainFrame, "✕", 22, UDim2.new(1, -54, 0, 14), UDim2.fromOffset(40, 40), Color3.fromRGB(12, 22, 52))
addCorner(CloseButton, UDim.new(0, 12))
addStroke(CloseButton, Colors.Blue, 2)

local MinimizeButton = createButton(MainFrame, "-", 22, UDim2.new(1, -100, 0, 14), UDim2.fromOffset(40, 40), Color3.fromRGB(12, 22, 52))
addCorner(MinimizeButton, UDim.new(0, 12))
addStroke(MinimizeButton, Colors.Blue, 2)

local AvatarImage = ""
pcall(function()
    AvatarImage = Players:GetUserThumbnailAsync(LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)

local AvatarFrame = createFrame(MainFrame, UDim2.fromOffset(16, 20), UDim2.fromOffset(92, 92), Color3.fromRGB(20, 30, 60))
addCorner(AvatarFrame, UDim.new(1, 0))
addStroke(AvatarFrame, Colors.Cyan, 3)
local AvatarImageLabel = Instance.new("ImageLabel", AvatarFrame)
AvatarImageLabel.Size = UDim2.fromScale(1, 1)
AvatarImageLabel.BackgroundTransparency = 1
AvatarImageLabel.Image = AvatarImage
AvatarImageLabel.BorderSizePixel = 0
addCorner(AvatarImageLabel, UDim.new(1, 0))

local Signature = createLabel(MainFrame, "By 👑\nخليل!", 20, UDim2.fromOffset(12, 366), UDim2.fromOffset(100, 68), Colors.Cyan)
Signature.Font = Enum.Font.SourceSansItalic
Signature.TextWrapped = true

local ContentPanel = createFrame(MainFrame, UDim2.fromOffset(122, 96), UDim2.new(1, -134, 1, -110), Colors.Panel)
addCorner(ContentPanel, UDim.new(0, 14))
addStroke(ContentPanel, Colors.Blue, 2)

local function makeScrollPage()
    local sp = Instance.new("ScrollingFrame", ContentPanel)
    sp.BackgroundTransparency = 1
    sp.BorderSizePixel = 0
    sp.Size = UDim2.fromScale(1, 1)
    sp.ScrollBarThickness = 4
    sp.Active = true
    sp.CanvasSize = UDim2.new(0, 0, 0, 0)
    sp.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sp.Visible = false
    local lay = Instance.new("UIListLayout", sp)
    lay.Padding = UDim.new(0, 6)
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", sp)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    return sp
end

local HomePage = makeScrollPage()
local ESPPage = makeScrollPage()
local CameraPage = makeScrollPage()
local WorldPage = makeScrollPage()
local SettingsPage = makeScrollPage()
local InfoPage = makeScrollPage()

local orderCounter = 0
local function nextOrder() orderCounter = orderCounter + 1 return orderCounter end

local function makeRow(page, h, color, icon, name)
    local hh = math.min(h, 48)
    local row = createFrame(page, UDim2.fromOffset(0, 0), UDim2.new(1, -20, 0, h), Color3.fromRGB(11, 16, 36))
    row.LayoutOrder = nextOrder()
    addCorner(row, UDim.new(0, 12))
    addStroke(row, color, 2)
    createLabel(row, icon, 26, UDim2.fromOffset(10, 0), UDim2.fromOffset(50, hh))
    local nl = createLabel(row, name, 18, UDim2.new(0, 64, 0, 0), UDim2.new(1, -140, 0, hh))
    nl.TextWrapped = true
    return row, nl
end

local function makeSwitch(row, color, callback, initial)
    local hh = math.min(row.Size.Y.Offset, 48)
    local offColor = Color3.fromRGB(60, 60, 75)
    local sw = createButton(row, "", 14, UDim2.new(1, -70, 0, (hh - 30) / 2), UDim2.fromOffset(58, 30), offColor)
    sw.AutoButtonColor = false
    addCorner(sw, UDim.new(1, 0))
    local knob = createFrame(sw, UDim2.new(0, 3, 0.5, -12), UDim2.fromOffset(24, 24), Colors.White)
    addCorner(knob, UDim.new(1, 0))
    local isOn = false
    if initial then
        isOn = true
        sw.BackgroundColor3 = color
        knob.Position = UDim2.new(1, -27, 0.5, -12)
    end
    local function apply(v)
        isOn = v
        sw.BackgroundColor3 = isOn and color or offColor
        knob:TweenPosition(isOn and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12), "Out", "Quad", 0.15, true)
        callback(isOn)
    end
    sw.MouseButton1Click:Connect(function() apply(not isOn) end)
    return function(v) if v ~= isOn then apply(v) end end
end

-- 1. الطيران
local FlyButtonsFrame = createFrame(ScreenGui, UDim2.new(1, -80, 0.5, -65), UDim2.fromOffset(60, 130))
FlyButtonsFrame.Visible = false
local function createFlyButton(text, y, isUp)
    local b = createButton(FlyButtonsFrame, text, 26, UDim2.fromOffset(0, y), UDim2.fromOffset(60, 60), Colors.Green)
    b.BackgroundTransparency = 0.2
    addCorner(b, UDim.new(1, 0))
    b.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            if isUp then FlyUp = true else FlyDown = true end
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            if isUp then FlyUp = false else FlyDown = false end
        end
    end)
end
createFlyButton("▲", 0, true)
createFlyButton("▼", 70, false)

local function stopFly()
    if FlyBV then FlyBV:Destroy() FlyBV = nil end
    if FlyBG then FlyBG:Destroy() FlyBG = nil end
    local h = getHum()
    if h then h.PlatformStand = false end
end

local setFly = makeSwitch(makeRow(HomePage, 48, Colors.Green, "🪽", "الطيران"), Colors.Green, function(on)
    State.fly = on
    FlyButtonsFrame.Visible = on or State.freecam
    if not on then stopFly() end
end)
UISetters["fly"] = setFly
bind(RunService.RenderStepped, function()
    if not State.fly then return end
    if State.ghost then return end
    local r, h = getRoot(), getHum()
    if not (r and h) then return end
    if not FlyBV or FlyBV.Parent ~= r then
        stopFly()
        FlyBV = Instance.new("BodyVelocity", r)
        FlyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        FlyBG = Instance.new("BodyGyro", r)
        FlyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        FlyBG.P = 9e4
    end
    h.PlatformStand = true
    local fs = 60
    local dir = h.MoveDirection * fs
    if FlyUp then dir = dir + Vector3.new(0, fs, 0) end
    if FlyDown then dir = dir - Vector3.new(0, fs, 0) end
    FlyBV.Velocity = dir
    FlyBG.CFrame = workspace.CurrentCamera.CFrame
end)

-- 2. قفز لا نهائي
local setInfJump = makeSwitch(makeRow(HomePage, 48, Colors.Purple, "♾️", "قفز لا نهائي"), Colors.Purple, function(on)
    State.infJump = on
end)
UISetters["infJump"] = setInfJump
bind(UserInputService.JumpRequest, function()
    if State.infJump then
        local h = getHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- 3. السرعة
local SpeedRow = makeRow(HomePage, 92, Colors.Red, "🏃", "السرعة")
local setSpeedSwitch = makeSwitch(SpeedRow, Colors.Red, function(on)
    State.speed = on
    if not on then
        local h = getHum()
        if h then h.WalkSpeed = 16 end
    end
end)
UISetters["speed"] = setSpeedSwitch
createFrame(SpeedRow, UDim2.fromOffset(0, 48), UDim2.new(1, 0, 0, 2), Colors.Red)
local SpeedMinus = createButton(SpeedRow, "−", 24, UDim2.fromOffset(10, 54), UDim2.fromOffset(38, 32), Color3.fromRGB(12, 22, 52))
addCorner(SpeedMinus, UDim.new(0, 8))
addStroke(SpeedMinus, Colors.Blue, 2)
local SpeedPlus = createButton(SpeedRow, "+", 24, UDim2.fromOffset(236, 54), UDim2.fromOffset(38, 32), Color3.fromRGB(12, 22, 52))
addCorner(SpeedPlus, UDim.new(0, 8))
addStroke(SpeedPlus, Colors.Blue, 2)
local SpeedInput = createTextBox(SpeedRow, "10", 20, UDim2.fromOffset(282, 54), UDim2.fromOffset(52, 32), Color3.fromRGB(11, 16, 36), Colors.Red)
local SpeedHit = createFrame(SpeedRow, UDim2.fromOffset(56, 54), UDim2.fromOffset(172, 24))
SpeedHit.Active = true
local SpeedBar = createFrame(SpeedHit, UDim2.new(0, 0, 0.5, -3), UDim2.new(1, 0, 0, 6), Color3.fromRGB(30, 50, 100))
addCorner(SpeedBar, UDim.new(1, 0))
local SpeedFill = createFrame(SpeedBar, UDim2.fromScale(0, 0), UDim2.fromScale(0, 1), Colors.Blue)
addCorner(SpeedFill, UDim.new(1, 0))
local SpeedHandle = createFrame(SpeedBar, UDim2.new(0, -9, 0.5, -9), UDim2.fromOffset(18, 18), Colors.White)
addCorner(SpeedHandle, UDim.new(1, 0))
createLabel(SpeedRow, "10", 12, UDim2.fromOffset(56, 72), UDim2.fromOffset(30, 14), Color3.fromRGB(200, 220, 255)).TextXAlignment = Enum.TextXAlignment.Left
createLabel(SpeedRow, "75", 12, UDim2.fromOffset(198, 72), UDim2.fromOffset(30, 14), Color3.fromRGB(200, 220, 255)).TextXAlignment = Enum.TextXAlignment.Right
local function setSpeed(v)
    Values.speed = math.clamp(math.floor(v + 0.5), 10, 75)
    local a = (Values.speed - 10) / 65
    SpeedFill.Size = UDim2.new(a, 0, 1, 0)
    SpeedHandle.Position = UDim2.new(a, -9, 0.5, -9)
    SpeedInput.Text = tostring(Values.speed)
end
setSpeed(10)
SpeedInput.FocusLost:Connect(function()
    local n = tonumber(SpeedInput.Text)
    setSpeed(n or Values.speed)
end)
SpeedMinus.MouseButton1Click:Connect(function() setSpeed(Values.speed - 1) end)
SpeedPlus.MouseButton1Click:Connect(function() setSpeed(Values.speed + 1) end)
local speedDragging = false
local function speedFromX(x)
    setSpeed(10 + math.clamp((x - SpeedHit.AbsolutePosition.X) / SpeedHit.AbsoluteSize.X, 0, 1) * 65)
end
SpeedHit.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = true
        speedFromX(i.Position.X)
    end
end)
bind(UserInputService.InputChanged, function(i)
    if speedDragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
        speedFromX(i.Position.X)
    end
end)
bind(UserInputService.InputEnded, function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = false
    end
end)
bind(RunService.Heartbeat, function()
    if State.speed and not State.freecam and not State.ghost then
        local h = getHum()
        if h then h.WalkSpeed = Values.speed end
    end
end)

-- 4. قوة القفز (تم إصلاح مكان الكتابة)
local JumpRow = makeRow(HomePage, 48, Colors.Green, "🦘", "قوة القفز")
local JumpInput = createTextBox(JumpRow, tostring(Values.jumpPower), 16, UDim2.new(1, -140, 0, 9), UDim2.fromOffset(58, 30), Color3.fromRGB(6, 12, 30), Colors.Green)
local setJumpSwitch = makeSwitch(JumpRow, Colors.Green, function(on)
    State.jump = on
    if not on then
        local h = getHum()
        if h then h.JumpPower = 50 end
    end
end)
UISetters["jump"] = setJumpSwitch
JumpInput.FocusLost:Connect(function()
    local n = tonumber(JumpInput.Text)
    if n then Values.jumpPower = math.clamp(n, 50, 300) end
    JumpInput.Text = tostring(Values.jumpPower)
end)
bind(RunService.Heartbeat, function()
    if State.jump then
        local h = getHum()
        if h then
            h.UseJumpPower = true
            h.JumpPower = Values.jumpPower
        end
    end
end)

-- 5. التخفي (لا يرونك أحد)
local setGhost = makeSwitch(makeRow(HomePage, 48, Colors.Purple, "👻", "التخفي (لا يرونك أحد)"), Colors.Purple, function(on)
    State.ghost = on
    if not on and getChar() then
        for _, p in ipairs(getChar():GetDescendants()) do
            if p:IsA("BasePart") then
                p.Transparency = 0
                p.CanCollide = true
            end
        end
    end
end)
UISetters["ghost"] = setGhost
bind(RunService.Heartbeat, function()
    if State.ghost and getChar() then
        for _, p in ipairs(getChar():GetDescendants()) do
            if p:IsA("BasePart") then
                p.Transparency = 1 -- شفافية كاملة
                p.CanCollide = true -- الحفاظ على التصادم حتى لا تسقط
            end
        end
    end
end)

-- 6. عدم الموت
local setGod = makeSwitch(makeRow(HomePage, 48, Colors.Green, "🛡️", "عدم الموت"), Colors.Green, function(on)
    State.god = on
    if not on and getChar() then
        local h = getHum()
        if h then h.MaxHealth = 100 end
    end
end)
UISetters["god"] = setGod
bind(RunService.Heartbeat, function()
    if State.god and getChar() then
        local h = getHum()
        if h then 
            h.MaxHealth = 1000000
            h.Health = h.MaxHealth
        end
    end
end)

-- 7. الهيتبوكس العملاق
local function removeGiantHitbox()
    if GiantHitboxPart then
        GiantHitboxPart:Destroy()
        GiantHitboxPart = nil
    end
end

local setHitbox = makeSwitch(makeRow(HomePage, 48, Colors.Orange, "👹", "هيتبوكس عملاق"), Colors.Orange, function(on)
    State.hitbox = on
    if not on then removeGiantHitbox() end
end)
UISetters["hitbox"] = setHitbox

bind(RunService.Heartbeat, function()
    if State.hitbox then
        local r = getRoot()
        if r then
            if not GiantHitboxPart or not GiantHitboxPart.Parent then
                GiantHitboxPart = Instance.new("Part")
                GiantHitboxPart.Name = "GiantHitbox"
                GiantHitboxPart.Size = Vector3.new(Values.hitboxSize, Values.hitboxSize, Values.hitboxSize)
                GiantHitboxPart.Transparency = 0.5
                GiantHitboxPart.CanCollide = false
                GiantHitboxPart.Massless = true
                GiantHitboxPart.Color = Colors.Red
                GiantHitboxPart.Parent = getChar()
                
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = r
                weld.Part1 = GiantHitboxPart
                weld.Parent = GiantHitboxPart
            else
                GiantHitboxPart.Size = Vector3.new(Values.hitboxSize, Values.hitboxSize, Values.hitboxSize)
                GiantHitboxPart.CFrame = r.CFrame
            end
        end
    else
        removeGiantHitbox()
    end
end)

-- ================================================================================
-- تبويب الكاشف
-- ================================================================================
local mapFrame = createFrame(ScreenGui, UDim2.new(1, -170, 0, 70), UDim2.fromOffset(150, 150), Color3.fromRGB(6, 12, 30))
mapFrame.BackgroundTransparency = 0.25
mapFrame.ClipsDescendants = true
mapFrame.Visible = false
addCorner(mapFrame, UDim.new(1, 0))
addStroke(mapFrame, Colors.Blue, 2)
local meDot = createFrame(mapFrame, UDim2.new(0.5, -4, 0.5, -4), UDim2.fromOffset(8, 8), Colors.White)
addCorner(meDot, UDim.new(1, 0))
local nearbyLabel = createLabel(ScreenGui, "", 14, UDim2.new(0, 10, 0, 120), UDim2.fromOffset(210, 96), Colors.White)
nearbyLabel.BackgroundTransparency = 0.4
nearbyLabel.BackgroundColor3 = Colors.Black
nearbyLabel.TextXAlignment = Enum.TextXAlignment.Left
nearbyLabel.TextYAlignment = Enum.TextYAlignment.Top
nearbyLabel.Visible = false
addCorner(nearbyLabel, UDim.new(0, 8))
local alertLabel = createLabel(ScreenGui, "", 20, UDim2.new(0.5, -160, 0, 70), UDim2.fromOffset(320, 36), Color3.fromRGB(255, 90, 90))
alertLabel.BackgroundTransparency = 0.3
alertLabel.BackgroundColor3 = Colors.Black
alertLabel.Visible = false
addCorner(alertLabel, UDim.new(0, 10))
local eyeButton = createButton(ScreenGui, "👁️", 22, UDim2.new(0, 10, 0.5, -22), UDim2.fromOffset(44, 44), Color3.fromRGB(12, 22, 52))
addCorner(eyeButton, UDim.new(1, 0))
addStroke(eyeButton, Colors.Orange, 2)
eyeButton.Visible = false
eyeButton.MouseButton1Click:Connect(function()
    ESPHidden = not ESPHidden
    eyeButton.BackgroundTransparency = ESPHidden and 0.7 or 0
end)

local function clearESP(plr)
    local o = ESPObjects[plr]
    if o then
        for _, i in pairs(o) do pcall(function() i:Destroy() end) end
        ESPObjects[plr] = nil
    end
end
local function hideESP(o)
    o.highlight.Enabled = false
    o.box.Enabled = false
    o.billboard.Enabled = false
    o.arrow.Visible = false
    o.arrowText.Visible = false
    o.dot.Visible = false
end
local function addESP(plr)
    if plr == LocalPlayer then return end
    clearESP(plr)
    local c = plr.Character
    local r = otherRoot(c)
    if not r then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Colors.Orange
    highlight.OutlineColor = Colors.White
    highlight.FillTransparency = 0.6
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = c
    local box = Instance.new("BillboardGui")
    box.Size = UDim2.new(4, 0, 6, 0)
    box.AlwaysOnTop = true
    box.Adornee = r
    box.Parent = r
    local boxFrame = Instance.new("Frame", box)
    boxFrame.Size = UDim2.fromScale(1, 1)
    boxFrame.BackgroundTransparency = 1
    local boxStroke = Instance.new("UIStroke", boxFrame)
    boxStroke.Color = Colors.Orange
    boxStroke.Thickness = 1.5
    local hpBg = Instance.new("Frame", box)
    hpBg.Size = UDim2.new(0.1, 0, 1, 0)
    hpBg.Position = UDim2.new(-0.16, 0, 0, 0)
    hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    hpBg.BorderSizePixel = 0
    local hpFill = Instance.new("Frame", hpBg)
    hpFill.AnchorPoint = Vector2.new(0, 1)
    hpFill.Position = UDim2.fromScale(0, 1)
    hpFill.Size = UDim2.fromScale(1, 1)
    hpFill.BackgroundColor3 = Colors.Green
    hpFill.BorderSizePixel = 0
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.fromOffset(170, 58)
    bb.StudsOffset = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = r
    bb.Parent = r
    local nameLabel = Instance.new("TextLabel", bb)
    nameLabel.Size = UDim2.fromScale(1, 1)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextColor3 = Colors.Orange
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = plr.DisplayName
    local arrow = Instance.new("TextLabel", ScreenGui)
    arrow.Size = UDim2.fromOffset(34, 34)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Text = ">"
    arrow.Font = Enum.Font.GothamBlack
    arrow.TextSize = 34
    arrow.TextColor3 = Colors.Orange
    arrow.TextStrokeTransparency = 0
    arrow.Visible = false
    local arrowText = Instance.new("TextLabel", ScreenGui)
    arrowText.Size = UDim2.fromOffset(70, 14)
    arrowText.AnchorPoint = Vector2.new(0.5, 0.5)
    arrowText.BackgroundTransparency = 1
    arrowText.Font = Enum.Font.GothamBold
    arrowText.TextSize = 12
    arrowText.TextColor3 = Colors.White
    arrowText.TextStrokeTransparency = 0
    arrowText.Visible = false
    local dot = createFrame(mapFrame, UDim2.fromOffset(0, 0), UDim2.fromOffset(6, 6), Colors.Orange)
    addCorner(dot, UDim.new(1, 0))
    dot.Visible = false
    ESPObjects[plr] = {
        highlight = highlight, box = box, billboard = bb,
        arrow = arrow, arrowText = arrowText, dot = dot,
        boxFrame = boxFrame, hpBg = hpBg, hpFill = hpFill,
        nameLabel = nameLabel, stroke = boxStroke
    }
end

local function watchPlayer(plr)
    if plr == LocalPlayer then return end
    bind(plr.CharacterAdded, function(char)
        if State.esp then
            task.wait(0.5)
            if not otherRoot(char) then task.wait(1.5) end
            addESP(plr)
        end
    end)
end
for _, plr in ipairs(Players:GetPlayers()) do watchPlayer(plr) end
bind(Players.PlayerAdded, function(plr)
    watchPlayer(plr)
    if State.esp and plr.Character then addESP(plr) end
end)
bind(Players.PlayerRemoving, function(plr) clearESP(plr) end)

local MORPH_KEYS = {"morph", "animal", "creature", "form", "skin", "costume", "disguise", "species"}
local function hasKey(n)
    n = tostring(n):lower()
    for _, k in ipairs(MORPH_KEYS) do
        if n:find(k, 1, true) then return true end
    end
    return false
end
local function getMorph(plr)
    local c = plr.Character
    if not c then return nil end
    local bm = nil
    for _, h in ipairs({c, plr}) do
        for k, v in pairs(h:GetAttributes()) do
            if hasKey(k) then
                if type(v) == "string" and v ~= "" then return v end
                if type(v) == "boolean" then bm = v end
            end
        end
        for _, d in ipairs(h:GetDescendants()) do
            if d:IsA("ValueBase") and hasKey(d.Name) then
                if d:IsA("StringValue") and d.Value ~= "" then return d.Value end
                if d:IsA("ObjectValue") and d.Value then return d.Value.Name end
                if d:IsA("BoolValue") then bm = d.Value end
            end
        end
    end
    for _, d in ipairs(c:GetDescendants()) do
        if d:IsA("Model") and not d:IsA("Accessory") and not d:IsA("Tool") then return d.Name end
    end
    if c.Name ~= plr.Name and c.Name ~= plr.DisplayName then return c.Name end
    if bm == true then return "متحول" end
    if bm == false then return "غير متحول" end
    return nil
end

local setESP = makeSwitch(makeRow(ESPPage, 48, Colors.Orange, "👁️", "كاشف اماكن الاعبين"), Colors.Orange, function(on)
    State.esp = on
    eyeButton.Visible = on
    for _, p in ipairs(Players:GetPlayers()) do
        if on then addESP(p) else clearESP(p) end
    end
end)
UISetters["esp"] = setESP

local function addESPRow(color, icon, name, key, init)
    local row = makeRow(ESPPage, 40, color, icon, name)
    local setter = makeSwitch(row, color, function(on) State[key] = on end, init)
    UISetters["esp_" .. key] = setter
end
addESPRow(Colors.Blue, "🔲", "مربع حول اللاعب", "espBox", false)
addESPRow(Colors.Cyan, "🏷️", "أسماء اللاعبين", "espNames", true)
addESPRow(Colors.Cyan, "📏", "المسافة", "espDist", true)
addESPRow(Colors.Red, "❤️", "شريط الصحة", "espHp", false)
addESPRow(Colors.Purple, "🧬", "كشف التحول", "espMorph", false)
addESPRow(Colors.Green, "⚡", "عداد سرعة اللاعب", "espSpeed", false)
addESPRow(Colors.Blue, "🧭", "سهم اتجاه خارج الشاشة", "espArrow", false)
addESPRow(Colors.Red, "🎯", "تحديد أقرب لاعب", "espClosest", false)
addESPRow(Colors.Orange, "🔔", "تنبيه عند اقتراب لاعب", "espAlert", false)
addESPRow(Colors.Blue, "📊", "قائمة اللاعبين القريبين", "espList", false)
addESPRow(Colors.Green, "🗺️", "خريطة مصغرة", "espMap", false)

local RangeRow = makeRow(ESPPage, 40, Colors.Blue, "🚪", "نطاق الكشف (متر)")
local RangeInput = createTextBox(RangeRow, "500", 16, UDim2.new(1, -70, 0, 5), UDim2.fromOffset(58, 30), Color3.fromRGB(6, 12, 30), Colors.Blue)
RangeInput.FocusLost:Connect(function()
    local n = tonumber(RangeInput.Text)
    if n then Values.espRange = math.clamp(math.floor(n), 100, 100000) end
    RangeInput.Text = tostring(Values.espRange)
end)

local espAcc = 0
bind(RunService.RenderStepped, function(dt)
    local active = State.esp and not ESPHidden
    mapFrame.Visible = active and State.espMap
    nearbyLabel.Visible = active and State.espList
    alertLabel.Visible = false
    if not active then
        for _, o in pairs(ESPObjects) do hideESP(o) end
        return
    end
    local myRoot = getRoot()
    if not myRoot then return end
    espAcc += dt
    local doText = espAcc >= 0.15
    if doText then espAcc = 0 end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    local list = {}
    for plr, o in pairs(ESPObjects) do
        local c = plr.Character
        local r = otherRoot(c)
        local h = otherHum(c)
        if r and h and r.Parent then
            local d = (r.Position - myRoot.Position).Magnitude
            if d <= Values.espRange then
                table.insert(list, {plr = plr, o = o, r = r, h = h, d = d})
            else
                hideESP(o)
            end
        else
            hideESP(o)
        end
    end
    table.sort(list, function(a, b) return a.d < b.d end)
    local closest = list[1]
    local look = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
    if look.Magnitude < 0.01 then look = Vector3.new(0, 0, -1) end
    look = look.Unit
    local right = Vector3.new(-look.Z, 0, look.X)
    for _, e in ipairs(list) do
        local o, r, h, d = e.o, e.r, e.h, e.d
        local isC = State.espClosest and e == closest
        local col = isC and Colors.Red or Colors.Orange
        o.highlight.Enabled = true
        o.highlight.FillColor = col
        o.stroke.Color = col
        o.nameLabel.TextColor3 = col
        if h.MaxHealth >= h.Health then
            o.hpMax = h.MaxHealth
        else
            o.hpMax = math.max(o.hpMax or h.MaxHealth, h.Health)
        end
        o.box.Enabled = State.espBox or State.espHp
        o.boxFrame.Visible = State.espBox
        o.hpBg.Visible = State.espHp
        if State.espHp then
            local fr = math.clamp(h.Health / o.hpMax, 0, 1)
            o.hpFill.Size = UDim2.fromScale(1, fr)
            o.hpFill.BackgroundColor3 = Color3.fromHSV(fr * 0.33, 1, 1)
        end
        o.billboard.Enabled = State.espNames or State.espDist or State.espMorph or State.espSpeed or State.espHp
        if doText and o.billboard.Enabled then
            local parts, ex = {}, {}
            if State.espNames then parts[#parts + 1] = e.plr.DisplayName end
            if State.espDist then ex[#ex + 1] = "[" .. math.floor(d) .. "m]" end
            if State.espHp then ex[#ex + 1] = "❤️" .. math.floor(o.hpMax) .. "/" .. math.floor(h.Health) end
            if State.espSpeed then
                local v = r.AssemblyLinearVelocity
                ex[#ex + 1] = "⚡" .. math.floor(Vector3.new(v.X, 0, v.Z).Magnitude)
            end
            if #ex > 0 then parts[#parts + 1] = table.concat(ex, " ") end
            if State.espMorph then
                if os.clock() - (o.morphT or 0) > 1 then
                    o.morph = getMorph(e.plr)
                    o.morphT = os.clock()
                end
                parts[#parts + 1] = "🧬 " .. (o.morph or "عادي")
            end
            o.nameLabel.Text = table.concat(parts, "\n")
        end
        o.arrow.Visible = false
        o.arrowText.Visible = false
        if State.espArrow then
            local v, os = cam:WorldToViewportPoint(r.Position)
            if not os then
                local center = vp / 2
                local dir = Vector2.new(v.X, v.Y) - center
                if v.Z < 0 then dir = -dir end
                if dir.Magnitude < 1 then dir = Vector2.new(0, -1) end
                local u = dir.Unit
                local rx, ry = vp.X / 2 - 50, vp.Y / 2 - 50
                local k = 1 / math.max(math.abs(u.X) / rx, math.abs(u.Y) / ry)
                local pt = center + u * k
                o.arrow.Position = UDim2.fromOffset(pt.X, pt.Y)
                o.arrow.Rotation = math.deg(math.atan2(u.Y, u.X))
                o.arrow.TextColor3 = col
                o.arrow.Visible = true
                o.arrowText.Position = UDim2.fromOffset(pt.X, pt.Y + 22)
                o.arrowText.Text = math.floor(d) .. "m"
                o.arrowText.Visible = true
            end
        end
        o.dot.Visible = State.espMap
        if State.espMap then
            local rel = r.Position - myRoot.Position
            local mx, my = rel:Dot(right), -rel:Dot(look)
            local range, half = 150, 75
            local px, py = mx / range * half, my / range * half
            local m = math.sqrt(px * px + py * py)
            if m > half - 6 then px, py = px / m * (half - 6), py / m * (half - 6) end
            o.dot.Position = UDim2.new(0.5, px - 3, 0.5, py - 3)
            o.dot.BackgroundColor3 = col
        end
    end
    if State.espList and doText then
        local t = {}
        for i = 1, math.min(5, #list) do
            t[i] = i .. ") " .. list[i].plr.DisplayName .. "  [" .. math.floor(list[i].d) .. "m]"
        end
        nearbyLabel.Text = #t > 0 and table.concat(t, "\n") or "لا يوجد لاعبين قريبين"
    end
    if State.espAlert and closest and closest.d <= 40 then
        alertLabel.Text = "⚠️ " .. closest.plr.DisplayName .. " قريب [" .. math.floor(closest.d) .. "m]"
        alertLabel.Visible = true
    end
end)

-- ================================================================================
-- تبويب الكاميرا
-- ================================================================================
local FOVRow = makeRow(CameraPage, 40, Colors.Blue, "🔭", "زاوية الرؤية")
local FOVInput = createTextBox(FOVRow, tostring(Values.fov), 16, UDim2.new(1, -140, 0, 5), UDim2.fromOffset(58, 30), Color3.fromRGB(6, 12, 30), Colors.Blue)
local setFOV = makeSwitch(FOVRow, Colors.Blue, function(on)
    State.fov = on
    if not on then
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = 70 end
    end
end)
UISetters["fov"] = setFOV
FOVInput.FocusLost:Connect(function()
    local n = tonumber(FOVInput.Text)
    if n then Values.fov = math.clamp(n, 50, 120) end
    FOVInput.Text = tostring(Values.fov)
end)
bind(RunService.RenderStepped, function()
    if State.fov then
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = Values.fov end
    end
end)

local ZoomRow = makeRow(CameraPage, 40, Colors.Cyan, "🔍", "تكبير مفتوح")
local ZoomInput = createTextBox(ZoomRow, tostring(Values.zoom), 16, UDim2.new(1, -140, 0, 5), UDim2.fromOffset(58, 30), Color3.fromRGB(6, 12, 30), Colors.Cyan)
local zoomOrig = nil
local function applyZoom(on)
    if on then
        if not zoomOrig then
            zoomOrig = {LocalPlayer.CameraMaxZoomDistance, LocalPlayer.CameraMinZoomDistance}
        end
        LocalPlayer.CameraMaxZoomDistance = Values.zoom
        LocalPlayer.CameraMinZoomDistance = 0.5
    elseif zoomOrig then
        LocalPlayer.CameraMinZoomDistance = zoomOrig[2]
        LocalPlayer.CameraMaxZoomDistance = zoomOrig[1]
        zoomOrig = nil
    end
end
local setZoom = makeSwitch(ZoomRow, Colors.Cyan, function(on)
    State.zoom = on
    applyZoom(on)
end)
UISetters["zoom"] = setZoom
ZoomInput.FocusLost:Connect(function()
    local n = tonumber(ZoomInput.Text)
    if n then Values.zoom = math.clamp(n, 20, 2000) end
    ZoomInput.Text = tostring(Values.zoom)
    if State.zoom then applyZoom(true) end
end)

local function setFreecam(on)
    local cam = workspace.CurrentCamera
    if not cam then return end
    State.freecam = on
    FlyButtonsFrame.Visible = on or State.fly
    local h = getHum()
    if on then
        local cf = cam.CFrame
        local rx, ry = cf:ToOrientation()
        FreecamData.pitch, FreecamData.yaw, FreecamData.pos = rx, ry, cf.Position
        cam.CameraType = Enum.CameraType.Scriptable
    else
        cam.CameraType = Enum.CameraType.Custom
        if h then
            cam.CameraSubject = h
            h.WalkSpeed = State.speed and Values.speed or 16
        end
    end
end
local FreecamRow = makeRow(CameraPage, 40, Colors.Purple, "🎬", "كاميرا حرة")
local setFreecamSwitch = makeSwitch(FreecamRow, Colors.Purple, setFreecam)
UISetters["freecam"] = setFreecamSwitch
bind(RunService.RenderStepped, function(dt)
    if not State.freecam then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local h = getHum()
    if h then h.WalkSpeed = 0 end
    local md = h and h.MoveDirection or Vector3.new()
    local sp = 45 * dt
    local up = ((FlyUp and 1 or 0) - (FlyDown and 1 or 0)) * sp
    FreecamData.pos = FreecamData.pos + md * sp + Vector3.new(0, up, 0)
    cam.CFrame = CFrame.new(FreecamData.pos) * CFrame.fromOrientation(FreecamData.pitch, FreecamData.yaw, 0)
end)
bind(UserInputService.InputChanged, function(i, gp)
    if not State.freecam or gp then return end
    if i.UserInputType == Enum.UserInputType.Touch
        or (i.UserInputType == Enum.UserInputType.MouseMovement
            and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
        FreecamData.yaw = FreecamData.yaw - i.Delta.X * 0.006
        FreecamData.pitch = math.clamp(FreecamData.pitch - i.Delta.Y * 0.006, -1.5, 1.5)
    end
end)

local NoShakeRow = makeRow(CameraPage, 40, Colors.Cyan, "📳", "منع اهتزاز الكاميرا")
local setNoShake = makeSwitch(NoShakeRow, Colors.Cyan, function(on) State.noshake = on end)
UISetters["noshake"] = setNoShake
bind(RunService.RenderStepped, function()
    if State.noshake then
        local h = getHum()
        if h then h.CameraOffset = Vector3.new() end
    end
end)

-- ================================================================================
-- تبويب العالم
-- ================================================================================
local markerLayer = createFrame(ScreenGui, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1))
markerLayer.ZIndex = -5
local markerPools = {}
local function renderMarkers(id, entries, col)
    local pool = markerPools[id]
    if not pool then pool = {} markerPools[id] = pool end
    local used = 0
    local myRoot = getRoot()
    if entries and myRoot then
        local cam = workspace.CurrentCamera
        for _, e in ipairs(entries) do
            local pos = e.pos or (e.part and e.part.Parent and e.part.Position)
            if pos then
                local v, os = cam:WorldToViewportPoint(pos)
                if os then
                    used += 1
                    local m = pool[used]
                    if not m then
                        m = Instance.new("TextLabel", markerLayer)
                        m.Size = UDim2.fromOffset(130, 32)
                        m.AnchorPoint = Vector2.new(0.5, 0.5)
                        m.BackgroundTransparency = 1
                        m.Font = Enum.Font.GothamBold
                        m.TextSize = 12
                        m.TextStrokeTransparency = 0
                        pool[used] = m
                    end
                    m.Position = UDim2.fromOffset(v.X, v.Y)
                    m.Text = e.text .. "\n[" .. math.floor((pos - myRoot.Position).Magnitude) .. "m]"
                    m.TextColor3 = col
                    m.Visible = true
                end
            end
        end
    end
    for i = used + 1, #pool do pool[i].Visible = false end
end
bind(RunService.RenderStepped, function()
    renderMarkers("items", State.items and FinderItems or nil, Colors.Orange)
    renderMarkers("coins", State.coll and FinderCoins or nil, Colors.Green)
    renderMarkers("wp", State.wpShow and Waypoints or nil, Colors.Cyan)
end)
local COLLECTIBLE_KEYS = {"coin", "gem", "orb", "collect", "pickup", "cash", "star", "crystal", "egg", "candy", "diamond", "token", "fruit", "chest"}
task.spawn(function()
    while IsAlive do
        if State.items or State.coll then
            local wI, wC = State.items, State.coll
            local items, coins = {}, {}
            local ds = workspace:GetDescendants()
            for i, d in ipairs(ds) do
                if wI then
                    if d:IsA("Tool") and not Players:GetPlayerFromCharacter(d.Parent) then
                        local h = d:FindFirstChild("Handle")
                        if h and h:IsA("BasePart") then
                            items[#items + 1] = {part = h, text = d.Name}
                        end
                    elseif d:IsA("ProximityPrompt") and d.Parent and d.Parent:IsA("BasePart") then
                        local t = d.ObjectText ~= "" and d.ObjectText or d.Parent.Name
                        items[#items + 1] = {part = d.Parent, text = t}
                    end
                end
                if wC and d:IsA("BasePart") then
                    local nl = d.Name:lower()
                    for _, k in ipairs(COLLECTIBLE_KEYS) do
                        if nl:find(k, 1, true) then
                            coins[#coins + 1] = {part = d, text = d.Name}
                            break
                        end
                    end
                end
                if i % 2000 == 0 then task.wait() end
            end
            local myRoot = getRoot()
            local function trim(l)
                if myRoot then
                    table.sort(l, function(a, b)
                        return (a.part.Position - myRoot.Position).Magnitude
                            < (b.part.Position - myRoot.Position).Magnitude
                    end)
                end
                while #l > 40 do table.remove(l) end
            end
            trim(items)
            trim(coins)
            FinderItems = items
            FinderCoins = coins
        end
        local w = 0
        while IsAlive and (w < Values.scanInterval or not State.autoScan) and not ScanNow do
            task.wait(0.25)
            w += 0.25
        end
        ScanNow = false
    end
end)
local ItemsRow = makeRow(WorldPage, 40, Colors.Orange, "🎁", "كاشف العناصر")
local setItems = makeSwitch(ItemsRow, Colors.Orange, function(on)
    State.items = on
    ScanNow = true
end)
UISetters["items"] = setItems
local CollRow = makeRow(WorldPage, 40, Colors.Green, "💎", "كاشف الجوائز والعملات")
local setColl = makeSwitch(CollRow, Colors.Green, function(on)
    State.coll = on
    ScanNow = true
end)
UISetters["coll"] = setColl
local AutoScanRow = makeRow(WorldPage, 40, Colors.Cyan, "🔁", "التحديث التلقائي للكاشف")
local AutoScanInput = createTextBox(AutoScanRow, tostring(Values.scanInterval), 16, UDim2.new(1, -140, 0, 5), UDim2.fromOffset(58, 30), Color3.fromRGB(6, 12, 30), Colors.Cyan)
local setAutoScan = makeSwitch(AutoScanRow, Colors.Cyan, function(on) State.autoScan = on end, true)
UISetters["autoScan"] = setAutoScan
AutoScanInput.FocusLost:Connect(function()
    local n = tonumber(AutoScanInput.Text)
    if n then Values.scanInterval = math.clamp(n, 1, 30) end
    AutoScanInput.Text = tostring(Values.scanInterval)
end)
local ScanButton = createButton(AutoScanRow, "🔄", 16, UDim2.new(1, -136, 0, 5), UDim2.fromOffset(30, 30), Color3.fromRGB(18, 55, 130))
addCorner(ScanButton, UDim.new(0, 8))
ScanButton.MouseButton1Click:Connect(function() ScanNow = true end)
local saveLocRow = createFrame(WorldPage, UDim2.new(0, 10, 0, 0), UDim2.new(1, -20, 0, 40), Color3.fromRGB(11, 16, 36))
saveLocRow.LayoutOrder = nextOrder()
addCorner(saveLocRow, UDim.new(0, 12))
addStroke(saveLocRow, Colors.Blue, 2)
local saveLocBtn = createButton(saveLocRow, "💾 حفظ الموقع", 14, UDim2.new(0, 4, 0, 4), UDim2.new(0.5, -6, 1, -8), Color3.fromRGB(18, 55, 130))
addCorner(saveLocBtn, UDim.new(0, 8))
local loadLocBtn = createButton(saveLocRow, "↩️ استرجاع الموقع", 14, UDim2.new(0.5, 2, 0, 4), UDim2.new(0.5, -6, 1, -8), Color3.fromRGB(18, 55, 130))
addCorner(loadLocBtn, UDim.new(0, 8))
saveLocBtn.MouseButton1Click:Connect(function()
    local r = getRoot()
    if r then SavedLocation = r.CFrame end
end)
loadLocBtn.MouseButton1Click:Connect(function()
    local r = getRoot()
    if r and SavedLocation then r.CFrame = SavedLocation end
end)
local WpShowRow = makeRow(WorldPage, 40, Colors.Cyan, "📍", "إظهار النقاط على الشاشة")
local setWpShow = makeSwitch(WpShowRow, Colors.Cyan, function(on) State.wpShow = on end)
UISetters["wpShow"] = setWpShow
local wpAddRow = createFrame(WorldPage, UDim2.new(0, 10, 0, 0), UDim2.new(1, -20, 0, 40), Color3.fromRGB(11, 16, 36))
wpAddRow.LayoutOrder = nextOrder()
addCorner(wpAddRow, UDim.new(0, 12))
addStroke(wpAddRow, Colors.Green, 2)
local wpAddBtn = createButton(wpAddRow, "➕ إضافة نقطة هنا", 16, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), Color3.fromRGB(11, 16, 36))
addCorner(wpAddBtn, UDim.new(0, 12))
local wpCount = 0
wpAddBtn.MouseButton1Click:Connect(function()
    local r = getRoot()
    if r then
        wpCount += 1
        table.insert(Waypoints, {pos = r.Position, text = "نقطة " .. wpCount})
    end
end)
local FbRow = makeRow(WorldPage, 40, Colors.Orange, "☀️", "إضاءة كاملة")
local setFullbright = makeSwitch(FbRow, Colors.Orange, function(on)
    State.fullbright = on
    if on then
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
    else
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    end
end)
UISetters["fullbright"] = setFullbright

-- ================================================================================
-- تبويب الإعدادات
-- ================================================================================
local ScaleRow = makeRow(SettingsPage, 100, Colors.Blue, "📐", "حجم القائمة")
local ScaleLabel = createLabel(ScaleRow, "100%", 20, UDim2.new(0.5, -35, 0, 56), UDim2.fromOffset(70, 34))
local function setScale(v)
    Values.uiScale = math.clamp(math.floor(v * 10 + 0.5) / 10, 0.6, 1.4)
    UIScaleInstance.Scale = Values.uiScale
    ScaleLabel.Text = math.floor(Values.uiScale * 100 + 0.5) .. "%"
end
local ScaleMinusBtn = createButton(ScaleRow, "−", 24, UDim2.new(0.5, -100, 0, 56), UDim2.fromOffset(44, 34), Color3.fromRGB(12, 22, 52))
addCorner(ScaleMinusBtn, UDim.new(0, 8))
addStroke(ScaleMinusBtn, Colors.Blue, 2)
ScaleMinusBtn.MouseButton1Click:Connect(function() setScale(Values.uiScale - 0.1) end)
local ScalePlusBtn = createButton(ScaleRow, "+", 24, UDim2.new(0.5, 56, 0, 56), UDim2.fromOffset(44, 34), Color3.fromRGB(12, 22, 52))
addCorner(ScalePlusBtn, UDim.new(0, 8))
addStroke(ScalePlusBtn, Colors.Blue, 2)
ScalePlusBtn.MouseButton1Click:Connect(function() setScale(Values.uiScale + 0.1) end)
local HBRow = makeRow(SettingsPage, 48, Colors.Orange, "👹", "حجم الهيتبوكس")
local HBInput = createTextBox(HBRow, tostring(Values.hitboxSize), 16, UDim2.new(1, -70, 0, 9), UDim2.fromOffset(58, 30), Color3.fromRGB(6, 12, 30), Colors.Orange)
HBInput.FocusLost:Connect(function()
    local n = tonumber(HBInput.Text)
    if n then Values.hitboxSize = math.clamp(n, 1, 100) end
    HBInput.Text = tostring(Values.hitboxSize)
end)
local TranspRow = makeRow(SettingsPage, 48, Colors.Cyan, "💧", "شفافية الواجهة")
local TranspInput = createTextBox(TranspRow, tostring(Values.uiTransparency), 16, UDim2.new(1, -70, 0, 9), UDim2.fromOffset(58, 30), Color3.fromRGB(6, 12, 30), Colors.Cyan)
TranspInput.FocusLost:Connect(function()
    local n = tonumber(TranspInput.Text)
    if n then
        Values.uiTransparency = math.clamp(n, 0, 90) / 100
        MainFrame.BackgroundTransparency = Values.uiTransparency
    end
    TranspInput.Text = tostring(math.floor(Values.uiTransparency * 100))
end)
local SaveRow = makeRow(SettingsPage, 48, Colors.Green, "💾", "حفظ الإعدادات")
local SaveStatusLabel = createLabel(SaveRow, "اضغط حفظ أو استرجاع", 12, UDim2.new(1, -130, 0, 0), UDim2.fromOffset(120, 48), Color3.fromRGB(200, 200, 200))
SaveStatusLabel.TextXAlignment = Enum.TextXAlignment.Right
local SaveBtn = createButton(SaveRow, "حفظ", 14, UDim2.fromOffset(10, 9), UDim2.fromOffset(60, 30), Color3.fromRGB(18, 100, 50))
addCorner(SaveBtn, UDim.new(0, 8))
local LoadBtn = createButton(SaveRow, "استرجاع", 14, UDim2.fromOffset(80, 9), UDim2.fromOffset(70, 30), Color3.fromRGB(18, 55, 130))
addCorner(LoadBtn, UDim.new(0, 8))
local ClearBtn = createButton(SaveRow, "مسح", 14, UDim2.fromOffset(160, 9), UDim2.fromOffset(50, 30), Color3.fromRGB(90, 20, 30))
addCorner(ClearBtn, UDim.new(0, 8))
SaveBtn.MouseButton1Click:Connect(function()
    if not CanSave then SaveStatusLabel.Text = "غير مدعوم" return end
    local data = {State = State, Values = Values}
    local ok, enc = pcall(function() return HttpService:JSONEncode(data) end)
    if ok then
        pcall(function() writefile(SAVE_FILE, enc) end)
        SaveStatusLabel.Text = "✅ تم الحفظ"
        SaveStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.delay(2, function()
            SaveStatusLabel.Text = "اضغط حفظ أو استرجاع"
            SaveStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end)
    else
        SaveStatusLabel.Text = "❌ فشل"
        SaveStatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)
LoadBtn.MouseButton1Click:Connect(function()
    if not CanSave then SaveStatusLabel.Text = "غير مدعوم" return end
    if not isfile(SAVE_FILE) then SaveStatusLabel.Text = "لا يوجد محفوظات" return end
    local ok, content = pcall(function() return readfile(SAVE_FILE) end)
    if not ok or not content then return end
    local ok2, decoded = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or not decoded then return end
    if decoded.State then
        for k, v in pairs(decoded.State) do
            if State[k] ~= nil then
                State[k] = v
                if UISetters[k] then UISetters[k](v) end
            end
        end
    end
    if decoded.Values then
        for k, v in pairs(decoded.Values) do
            if Values[k] ~= nil then Values[k] = v end
        end
    end
    SaveStatusLabel.Text = "✅ تم الاسترجاع"
    SaveStatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    task.delay(2, function()
        SaveStatusLabel.Text = "اضغط حفظ أو استرجاع"
        SaveStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
end)
ClearBtn.MouseButton1Click:Connect(function()
    if not CanSave then return end
    pcall(function() delfile(SAVE_FILE) end)
    SaveStatusLabel.Text = "🗑️ تم المسح"
    SaveStatusLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
    task.delay(2, function()
        SaveStatusLabel.Text = "اضغط حفظ أو استرجاع"
        SaveStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
end)
local ResetRow = makeRow(SettingsPage, 48, Colors.Red, "🔄", "إعادة الشخصية")
local ResetBtn = createButton(ResetRow, "🔄", 16, UDim2.new(1, -70, 0, 9), UDim2.fromOffset(58, 30), Color3.fromRGB(90, 20, 30))
addCorner(ResetBtn, UDim.new(0, 8))
local resetArmed = false
ResetBtn.MouseButton1Click:Connect(function()
    if not resetArmed then
        resetArmed = true
        ResetBtn.Text = "تأكيد؟"
        task.delay(3, function()
            resetArmed = false
            ResetBtn.Text = "🔄"
        end)
    else
        resetArmed = false
        ResetBtn.Text = "🔄"
        local h = getHum()
        if h then h.Health = 0 end
    end
end)

-- ================================================================================
-- تبويب المعلومات
-- ================================================================================
local InfoBox = createFrame(InfoPage, UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 56), Color3.fromRGB(11, 16, 36))
addCorner(InfoBox, UDim.new(0, 12))
addStroke(InfoBox, Colors.Blue, 2)
local InfoTitle = createLabel(InfoBox, "هذا السكربت تم تصميمه لاجل حمد بكيفي", 17, UDim2.fromOffset(10, 0), UDim2.new(1, -20, 1, 0), Color3.fromRGB(190, 235, 255))
InfoTitle.TextWrapped = true
local StatsBox = createFrame(InfoPage, UDim2.new(0, 10, 0, 74), UDim2.new(1, -20, 0, 236), Color3.fromRGB(11, 16, 36))
addCorner(StatsBox, UDim.new(0, 12))
addStroke(StatsBox, Colors.Cyan, 2)
local StatsLabel = createLabel(StatsBox, "", 15, UDim2.fromOffset(10, 6), UDim2.new(1, -20, 1, -12), Colors.White)
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.TextYAlignment = Enum.TextYAlignment.Top
StatsLabel.TextWrapped = true
local fpsN, fpsT = 0, 0
bind(RunService.RenderStepped, function(dt)
    fpsN += 1
    fpsT += dt
    if fpsT >= 0.5 then
        local fps = math.floor(fpsN / fpsT + 0.5)
        fpsN, fpsT = 0, 0
        if InfoPage.Visible then
            local ping = 0
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
            end)
            local h, r = getHum(), getRoot()
            local sp = 0
            if r then
                local v = r.AssemblyLinearVelocity
                sp = math.floor(Vector3.new(v.X, 0, v.Z).Magnitude)
            end
            local okM, morph = pcall(getMorph, LocalPlayer)
            local pos = r and (math.floor(r.Position.X) .. ", " .. math.floor(r.Position.Y) .. ", " .. math.floor(r.Position.Z)) or "-"
            StatsLabel.Text = "الإطارات: " .. fps
                .. "\nزمن الاستجابة: " .. ping .. " ميث"
                .. "\nسرعة الشخصية: " .. sp
                .. "\nعدد اللاعبين: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
                .. "\nالشخصية: " .. LocalPlayer.DisplayName
                .. "\nالدم: " .. (h and (math.floor(h.Health) .. "/" .. math.floor(h.MaxHealth)) or "-")
                .. "\nالمورف: " .. ((okM and morph) or "عادي")
                .. "\nالموقع: " .. pos
                .. "\n\nاختصارات: RightShift (إخفاء/إظهار)، RightCtrl+1..5 (تفعيل سريع)"
        end
    end
end)

-- ================================================================================
-- القائمة الجانبية
-- ================================================================================
local TabList = {}
local function showPage(page)
    for _, t in ipairs(TabList) do
        local active = t.page == page
        t.page.Visible = active
        t.btn.BackgroundColor3 = active and Color3.fromRGB(18, 55, 130) or Colors.Navy
        t.stroke.Transparency = active and 0 or 1
    end
end
local function makeTab(text, y, page)
    local b = createButton(MainFrame, text, 15, UDim2.fromOffset(10, y), UDim2.fromOffset(104, 36), Colors.Navy, Color3.fromRGB(150, 220, 255))
    addCorner(b, UDim.new(0, 10))
    local s = addStroke(b, Colors.Blue, 2)
    table.insert(TabList, {btn = b, page = page, stroke = s})
    b.MouseButton1Click:Connect(function() showPage(page) end)
end
makeTab("🏠 الرئيسية", 120, HomePage)
makeTab("👁️ الكاشف", 160, ESPPage)
makeTab("🎥 الكاميرا", 200, CameraPage)
makeTab("🌍 العالم", 240, WorldPage)
makeTab("⚙️ الإعدادات", 280, SettingsPage)
makeTab("ℹ️ معلومات", 320, InfoPage)
showPage(HomePage)

-- ================================================================================
-- الزر العائم
-- ================================================================================
local FloatingButton = Instance.new("ImageButton", ScreenGui)
FloatingButton.Size = UDim2.fromOffset(80, 80)
FloatingButton.Position = UDim2.new(0, 30, 0.35, 0)
FloatingButton.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
FloatingButton.Image = AvatarImage
FloatingButton.AutoButtonColor = false
FloatingButton.Visible = false
FloatingButton.BorderSizePixel = 0
addCorner(FloatingButton, UDim.new(1, 0))
addStroke(FloatingButton, Colors.Blue, 5)
local FloatCrown = createLabel(FloatingButton, "👑", 26, UDim2.new(1, -36, 0, -16), UDim2.fromOffset(34, 30), Color3.fromRGB(80, 190, 255))
FloatCrown.ZIndex = 3
local fDrag, fStart, fOrigin, fMoved = false, nil, nil, false
local function isPress(i)
    return i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1
end
FloatingButton.InputBegan:Connect(function(i)
    if isPress(i) then
        fDrag = true
        fStart = i.Position
        fOrigin = FloatingButton.Position
        fMoved = false
    end
end)
bind(UserInputService.InputChanged, function(i)
    if fDrag and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
        local dx = i.Position.X - fStart.X
        local dy = i.Position.Y - fStart.Y
        if math.abs(dx) + math.abs(dy) > 10 then fMoved = true end
        if fMoved then
            FloatingButton.Position = UDim2.new(fOrigin.X.Scale, fOrigin.X.Offset + dx, fOrigin.Y.Scale, fOrigin.Y.Offset + dy)
        end
    end
end)
bind(UserInputService.InputEnded, function(i)
    if fDrag and isPress(i) then
        fDrag = false
        if not fMoved then
            FloatingButton.Visible = false
            MainFrame.Visible = true
        end
    end
end)
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingButton.Visible = true
end)
MinimizeButton.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        MainFrame.Size = UDim2.new(0, 500, 0, 80)
        ContentPanel.Visible = false
        for _, t in ipairs(TabList) do t.btn.Visible = false end
        Signature.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 500, 0, 440)
        ContentPanel.Visible = true
        for _, t in ipairs(TabList) do t.btn.Visible = true end
        Signature.Visible = true
    end
end)
bind(UserInputService.InputBegan, function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        local show = not MainFrame.Visible
        MainFrame.Visible = show
        FloatingButton.Visible = not show
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
        if i.KeyCode == Enum.KeyCode.One then
            State.noclip = not State.noclip
            if UISetters["noclip"] then UISetters["noclip"](State.noclip) end
        elseif i.KeyCode == Enum.KeyCode.Two then
            State.fly = not State.fly
            if UISetters["fly"] then UISetters["fly"](State.fly) end
        elseif i.KeyCode == Enum.KeyCode.Three then
            State.infJump = not State.infJump
            if UISetters["infJump"] then UISetters["infJump"](State.infJump) end
        elseif i.KeyCode == Enum.KeyCode.Four then
            State.speed = not State.speed
            if UISetters["speed"] then UISetters["speed"](State.speed) end
        elseif i.KeyCode == Enum.KeyCode.Five then
            State.esp = not State.esp
            if UISetters["esp"] then UISetters["esp"](State.esp) end
        end
    end
end)
_G.KhalilCleanup = function()
    IsAlive = false
    for _, c in ipairs(Connections) do
        pcall(function() c:Disconnect() end)
    end
    Connections = {}
    State.fly = false
    State.infJump = false
    State.speed = false
    State.esp = false
    State.freecam = false
    State.hitbox = false
    State.god = false
    State.ghost = false
    removeGiantHitbox()
    stopFly()
    if State.zoom then applyZoom(false) end
    if State.fov then
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = 70 end
    end
    for plr in pairs(ESPObjects) do clearESP(plr) end
    local h = getHum()
    if h then h.WalkSpeed = 16 end
    pcall(function() ScreenGui:Destroy() end)
end
print("=====================================================")
print("  سكربت خليل | Khalil Script v3.0")
print("  by خليل 👑")
print("  تم تحميل السكربت بنجاح!")
print("  اضغط RightShift لإخفاء/إظهار الواجهة")
print("=====================================================")
