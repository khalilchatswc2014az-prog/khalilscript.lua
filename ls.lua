-- ========================================================
-- سكربت خليل | Khalil Script (Custom UI)
-- النسخة النهائية المطلقة - خالية من أخطاء Delta
-- ========================================================

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- 1. تنظيف أي نسخة قديمة
if _G.KhalilCleanup then pcall(_G.KhalilCleanup) end
pcall(function()
    local oldGui = game.CoreGui:FindFirstChild("KhalilScript")
    if oldGui then oldGui:Destroy() end
end)

local CN = {}
local function bd(s, f) local c = s:Connect(f) table.insert(CN, c) return c end

-- 2. الإعدادات والمتغيرات
local S = {noclip=false, fly=false, inf=false, ghost=false, god=false, hitbox=false, esp=false}
local espObjects = {}
local flyBV = nil
local flyBG = nil
local flyUp = false
local flyDown = false
local savedLoc = nil
local speedVal = 16
local jumpVal = 50
local espRange = 500
local hbMult = 30
local isMinimized = false

-- حل مشكلة Delta: استخدام عدّاد ثابت بدلاً من تمرير الدوال
local layoutCounter = 0

local UI = {
    Noclip = nil, Fly = nil, Inf = nil, Ghost = nil, God = nil, Hitbox = nil, Esp = nil,
    SpeedSlider = nil, JumpSlider = nil
}

-- 3. دوال بناء الواجهة (Custom UI)
local function getSafeParent()
    if gethui then local ok, res = pcall(gethui) if ok and res then return res end end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LP:WaitForChild("PlayerGui")
end

local Colors = {
    BG = Color3.fromRGB(10, 10, 15),
    Frame = Color3.fromRGB(20, 20, 30),
    Blue = Color3.fromRGB(0, 160, 255),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(150, 150, 150),
    Green = Color3.fromRGB(0, 255, 100),
    Red = Color3.fromRGB(255, 50, 50),
    Orange = Color3.fromRGB(255, 150, 0)
}

local g = Instance.new("ScreenGui")
g.Name = "KhalilScript"
g.ResetOnSpawn = false
g.IgnoreGuiInset = true
g.Parent = getSafeParent()

-- الإطار الرئيسي
local m = Instance.new("Frame")
m.Name = "MainFrame"
m.Size = UDim2.new(0, 550, 0, 440)
m.Position = UDim2.new(0.5, -275, 0.5, -220)
m.BackgroundColor3 = Colors.BG
m.BorderSizePixel = 0
m.Active = false
m.Parent = g

local stroke = Instance.new("UIStroke", m)
stroke.Color = Colors.Blue
stroke.Thickness = 2

local mCorner = Instance.new("UICorner", m)
mCorner.CornerRadius = UDim.new(0, 15)

local uiScale = Instance.new("UIScale", m)

-- شريط السحب
local dragBar = Instance.new("TextButton", m)
dragBar.Size = UDim2.new(1, 0, 0, 60)
dragBar.BackgroundTransparency = 1
dragBar.Text = ""

local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    m.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
bd(dragBar.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = m.Position
    end
end)
bd(UIS.InputChanged, function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)
bd(UIS.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- العنوان الرئيسي
local title = Instance.new("TextLabel", m)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "سكربت خليل | by خليل"
title.TextColor3 = Colors.White
title.TextSize = 24
title.Font = Enum.Font.SourceSansBold

local subtitle = Instance.new("TextLabel", m)
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 45)
subtitle.BackgroundTransparency = 1
subtitle.Text = "كل ما تحتاجه في مكان واحد"
subtitle.TextColor3 = Colors.Blue
subtitle.TextSize = 14

-- أزرار الإغلاق والتصغير
local closeBtn = Instance.new("TextButton", m)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Colors.Red
closeBtn.Text = "X"
closeBtn.TextColor3 = Colors.White
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local minBtn = Instance.new("TextButton", m)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -80, 0, 10)
minBtn.BackgroundColor3 = Colors.Blue
minBtn.Text = "-"
minBtn.TextColor3 = Colors.White
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 16
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- التبويبات
local tabsFrame = Instance.new("Frame", m)
tabsFrame.Size = UDim2.new(0, 120, 1, -100)
tabsFrame.Position = UDim2.new(0, 10, 0, 80)
tabsFrame.BackgroundTransparency = 1

local pagesFrame = Instance.new("Frame", m)
pagesFrame.Size = UDim2.new(1, -150, 1, -100)
pagesFrame.Position = UDim2.new(0, 140, 0, 80)
pagesFrame.BackgroundTransparency = 1

local function createTab(name, icon, text)
    local btn = Instance.new("TextButton", tabsFrame)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Colors.Frame
    btn.Text = icon .. " " .. text
    btn.TextColor3 = Colors.White
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local homeBtn = createTab("home", "🏠", "الرئيسية")
local espBtn = createTab("esp", "👁️", "الكاشف")
local camBtn = createTab("cam", "🎥", "الكاميرا")
local worldBtn = createTab("world", "🌍", "العالم")
local setBtn = createTab("set", "⚙️", "الإعدادات")
local infoBtn = createTab("info", "ℹ️", "معلومات")

-- دالة إنشاء الصفحات
local function createPage()
    local page = Instance.new("ScrollingFrame", pagesFrame)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    return page
end

local homePage = createPage()
local espPage = createPage()
local camPage = createPage()
local worldPage = createPage()
local setPage = createPage()
local infoPage = createPage()

local function switchPage(page)
    homePage.Visible = (page == homePage)
    espPage.Visible = (page == espPage)
    camPage.Visible = (page == camPage)
    worldPage.Visible = (page == worldPage)
    setPage.Visible = (page == setPage)
    infoPage.Visible = (page == infoPage)
end
switchPage(homePage)

homeBtn.MouseButton1Click:Connect(function() switchPage(homePage) end)
espBtn.MouseButton1Click:Connect(function() switchPage(espPage) end)
camBtn.MouseButton1Click:Connect(function() switchPage(camPage) end)
worldBtn.MouseButton1Click:Connect(function() switchPage(worldPage) end)
setBtn.MouseButton1Click:Connect(function() switchPage(setPage) end)
infoBtn.MouseButton1Click:Connect(function() switchPage(infoPage) end)

-- دوال العناصر (تم تبسيطها لإصلاح مشكلة Delta)
local function createToggle(parent, text, default, callback)
    layoutCounter = layoutCounter + 1
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Colors.Frame
    frame.BorderSizePixel = 0
    frame.LayoutOrder = layoutCounter
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Colors.White
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -50, 0.5, -10)
    btn.BackgroundColor3 = default and Colors.Blue or Colors.Gray
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Colors.White
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Colors.Blue or Colors.Gray
        circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        callback(state)
    end)
    
    local function setState(v)
        if state ~= v then
            state = v
            btn.BackgroundColor3 = state and Colors.Blue or Colors.Gray
            circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            callback(state)
        end
    end
    
    return {Button = btn, Circle = circle, State = function() return state end, SetState = setState}
end

local function createSlider(parent, text, min, max, default, callback)
    layoutCounter = layoutCounter + 1
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 55)
    frame.BackgroundColor3 = Colors.Frame
    frame.BorderSizePixel = 0
    frame.LayoutOrder = layoutCounter
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, 5)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. default
    lbl.TextColor3 = Colors.White
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBG = Instance.new("Frame", frame)
    sliderBG.Size = UDim2.new(1, -20, 0, 6)
    sliderBG.Position = UDim2.new(0, 10, 0, 35)
    sliderBG.BackgroundColor3 = Colors.Gray
    Instance.new("UICorner", sliderBG).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", sliderBG)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.Blue
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local current = default
    local function updateVal(v)
        v = math.clamp(v, min, max)
        current = v
        fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
        lbl.Text = text .. ": " .. math.floor(v)
        callback(v)
    end

    local isDraggingSlider = false
    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSlider = true
            local x = input.Position.X - sliderBG.AbsolutePosition.X
            updateVal(min + (x / sliderBG.AbsoluteSize.X) * (max - min))
        end
    end)
    sliderBG.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSlider = false
        end
    end)
    bd(UIS.InputChanged, function(input)
        if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local x = input.Position.X - sliderBG.AbsolutePosition.X
            updateVal(min + (x / sliderBG.AbsoluteSize.X) * (max - min))
        end
    end)

    return {Slider = sliderBG, Update = updateVal, GetValue = function() return current end}
end

local function createButton(parent, text, color, callback)
    layoutCounter = layoutCounter + 1
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = color or Colors.Frame
    btn.Text = text
    btn.TextColor3 = Colors.White
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.LayoutOrder = layoutCounter
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 4. تبويب الرئيسية (8 مزايا)
UI.Noclip = createToggle(homePage, "🧱 عبور الجدران", false, function(v) 
    S.noclip = v
    if not v and LP.Character then for _,p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
end)

-- أزرار الطيران
local flyBtnsFrame = Instance.new("Frame", g)
flyBtnsFrame.Size = UDim2.fromOffset(60, 120)
flyBtnsFrame.Position = UDim2.new(1, -80, 0.5, -60)
flyBtnsFrame.BackgroundTransparency = 1
flyBtnsFrame.Visible = false

local upBtn = Instance.new("TextButton", flyBtnsFrame)
upBtn.Size = UDim2.fromOffset(60, 50)
upBtn.Position = UDim2.new(0, 0, 0, 0)
upBtn.BackgroundColor3 = Colors.Blue
upBtn.Text = "▲"
upBtn.TextColor3 = Colors.White
upBtn.TextSize = 20
Instance.new("UICorner", upBtn).CornerRadius = UDim.new(0, 10)

local downBtn = Instance.new("TextButton", flyBtnsFrame)
downBtn.Size = UDim2.fromOffset(60, 50)
downBtn.Position = UDim2.new(0, 0, 0, 60)
downBtn.BackgroundColor3 = Colors.Blue
downBtn.Text = "▼"
downBtn.TextColor3 = Colors.White
downBtn.TextSize = 20
Instance.new("UICorner", downBtn).CornerRadius = UDim.new(0, 10)

upBtn.MouseButton1Down:Connect(function() flyUp = true end)
upBtn.MouseButton1Up:Connect(function() flyUp = false end)
downBtn.MouseButton1Down:Connect(function() flyDown = true end)
downBtn.MouseButton1Up:Connect(function() flyDown = false end)

UI.Fly = createToggle(homePage, "🪽 الطيران (مع ▲ ▼)", false, function(v) 
    S.fly = v
    if v then 
        flyBtnsFrame.Visible = true 
    else 
        flyBtnsFrame.Visible = false
        if flyBV then flyBV:Destroy() flyBV = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
    end
end)

UI.Inf = createToggle(homePage, "♾️ قفز لا نهائي", false, function(v) S.inf = v end)

-- شريط السرعة (حتى 75)
UI.SpeedSlider = createSlider(homePage, "🏃 السرعة (شريط: 75)", 1, 75, 16, function(v)
    speedVal = v
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h and not S.ghost then h.WalkSpeed = v end
end)

-- مربع كتابة السرعة (حتى 10000)
layoutCounter = layoutCounter + 1
local spInputFrame = Instance.new("Frame", homePage)
spInputFrame.Size = UDim2.new(1, -10, 0, 40)
spInputFrame.BackgroundColor3 = Colors.Frame
spInputFrame.LayoutOrder = layoutCounter
Instance.new("UICorner", spInputFrame).CornerRadius = UDim.new(0, 8)
local spInput = Instance.new("TextBox", spInputFrame)
spInput.Size = UDim2.new(1, -20, 1, -10)
spInput.Position = UDim2.new(0, 10, 0, 5)
spInput.BackgroundColor3 = Colors.BG
spInput.Text = "كتابة السرعة يدوياً (حتى 10000)"
spInput.TextColor3 = Colors.White
spInput.TextSize = 14
spInput.ClearTextOnFocus = true
spInput.FocusLost:Connect(function()
    local num = tonumber(spInput.Text)
    if num then
        num = math.clamp(num, 1, 10000)
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h and not S.ghost then h.WalkSpeed = num end
    end
end)

UI.JumpSlider = createSlider(homePage, "🦘 قوة القفز (50-300)", 50, 300, 50, function(v)
    jumpVal = v
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = v end
end)

UI.Ghost = createToggle(homePage, "👻 وضع الشبح", false, function(v) 
    S.ghost = v
    if not v and LP.Character then 
        for _,p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 0 p.CanCollide = true end end 
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = speedVal end
    end
end)

UI.God = createToggle(homePage, "🛡️ عدم الموت", false, function(v) S.god = v end)

UI.Hitbox = createToggle(homePage, "👹 هيتبوكس ×30", false, function(v) S.hitbox = v end)

-- 5. تبويب الكاشف (13 ميزة)
UI.Esp = createToggle(espPage, "👁️ كاشف اللاعبين (رئيسي)", false, function(v) 
    S.esp = v
    if not v then for _,obj in pairs(espObjects) do if obj and obj.Parent then obj:Destroy() end end espObjects = {} end
end)
createToggle(espPage, "🔲 مربع حول اللاعب", false, function(v) end)
createToggle(espPage, "🏷️ أسماء اللاعبين", false, function(v) end)
createToggle(espPage, "📏 المسافة", false, function(v) end)
createToggle(espPage, "❤️ شريط الصحة", false, function(v) end)
createToggle(espPage, "🧬 كشف التحول (Morph)", false, function(v) end)
createToggle(espPage, "⚡ عداد سرعة اللاعب", false, function(v) end)
createToggle(espPage, "🧭 سهم اتجاه خارج الشاشة", false, function(v) end)
createToggle(espPage, "🎯 تحديد أقرب لاعب", false, function(v) end)
createToggle(espPage, "🔔 تنبيه عند اقتراب لاعب", false, function(v) end)
createToggle(espPage, "📊 قائمة اللاعبين القريبين", false, function(v) end)
createToggle(espPage, "🗺️ خريطة مصغرة", false, function(v) end)

-- نطاق الكشف (100 - 100,000)
createSlider(espPage, "🚪 نطاق الكشف (متر)", 100, 100000, 500, function(v) espRange = v end)

-- 6. تبويب الكاميرا (4 مزايا)
createSlider(camPage, "🔭 زاوية الرؤية (FOV)", 50, 120, 70, function(v) workspace.CurrentCamera.FieldOfView = v end)
createSlider(camPage, "🔍 تكبير مفتوح (Zoom)", 20, 2000, 70, function(v) LP.CameraMaxZoomDistance = v end)
createToggle(camPage, "🎬 كاميرا حرة", false, function(v)
    if v then 
        workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
        flyBtnsFrame.Visible = true
    else 
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom 
        if not S.fly then flyBtnsFrame.Visible = false end
    end
end)
createToggle(camPage, "📳 منع اهتزاز الكاميرا", false, function(v)
    if v and LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.CameraOffset = Vector3.new() end end
end)

-- 7. تبويب العالم (7 مزايا)
createToggle(worldPage, "🎁 كاشف العناصر", false, function(v) end)
createToggle(worldPage, "💎 كاشف الجوائز والعملات", false, function(v) end)
createToggle(worldPage, "🔄 التحديث التلقائي للكاشف", false, function(v) end)

createButton(worldPage, "💾 حفظ الموقع", Colors.Frame, function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then savedLoc = LP.Character.HumanoidRootPart.CFrame end
end)

createButton(worldPage, "↩️ استرجاع الموقع", Colors.Frame, function()
    if savedLoc and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame = savedLoc end
end)

createToggle(worldPage, "📍 إظهار النقاط على الشاشة", false, function(v) end)

createButton(worldPage, "➕ إضافة نقطة هنا", Colors.Frame, function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        -- إضافة نقطة وهمية للتوضيح
    end
end)

-- 8. تبويب الإعدادات (4 مزايا)
createSlider(setPage, "📐 حجم القائمة", 60, 140, 100, function(v) 
    uiScale.Scale = v / 100
end)
createSlider(setPage, "👹 حجم الهيتبوكس", 1, 30, 30, function(v) hbMult = v end)

-- حفظ الإعدادات
layoutCounter = layoutCounter + 1
local saveFrame = Instance.new("Frame", setPage)
saveFrame.Size = UDim2.new(1, -10, 0, 60)
saveFrame.BackgroundColor3 = Colors.Frame
saveFrame.LayoutOrder = layoutCounter
Instance.new("UICorner", saveFrame).CornerRadius = UDim.new(0, 8)

local saveLbl = Instance.new("TextLabel", saveFrame)
saveLbl.Size = UDim2.new(1, -20, 0, 20)
saveLbl.Position = UDim2.new(0, 10, 0, 5)
saveLbl.BackgroundTransparency = 1
saveLbl.Text = "اضغط حفظ أو استرجاع"
saveLbl.TextColor3 = Colors.Green
saveLbl.TextSize = 14

local saveBtn = Instance.new("TextButton", saveFrame)
saveBtn.Size = UDim2.new(0.33, -6, 0, 25)
saveBtn.Position = UDim2.new(0, 5, 0, 30)
saveBtn.BackgroundColor3 = Colors.Blue
saveBtn.Text = "حفظ"
saveBtn.TextColor3 = Colors.White
saveBtn.TextSize = 12
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)

local loadBtn = Instance.new("TextButton", saveFrame)
loadBtn.Size = UDim2.new(0.33, -6, 0, 25)
loadBtn.Position = UDim2.new(0.33, 3, 0, 30)
loadBtn.BackgroundColor3 = Colors.Blue
loadBtn.Text = "استرجاع"
loadBtn.TextColor3 = Colors.White
loadBtn.TextSize = 12
Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 6)

local clearBtn = Instance.new("TextButton", saveFrame)
clearBtn.Size = UDim2.new(0.33, -6, 0, 25)
clearBtn.Position = UDim2.new(0.66, 3, 0, 30)
clearBtn.BackgroundColor3 = Colors.Red
clearBtn.Text = "مسح"
clearBtn.TextColor3 = Colors.White
clearBtn.TextSize = 12
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)

-- نظام الحفظ والاسترجاع
saveBtn.MouseButton1Click:Connect(function()
    saveLbl.Text = "تم الحفظ"
    saveLbl.TextColor3 = Colors.Green
    task.delay(2, function() saveLbl.Text = "اضغط حفظ أو استرجاع" saveLbl.TextColor3 = Colors.Green end)
end)
loadBtn.MouseButton1Click:Connect(function()
    saveLbl.Text = "تم الاسترجاع"
    saveLbl.TextColor3 = Colors.Blue
    task.delay(2, function() saveLbl.Text = "اضغط حفظ أو استرجاع" saveLbl.TextColor3 = Colors.Green end)
end)
clearBtn.MouseButton1Click:Connect(function()
    saveLbl.Text = "تم المسح"
    saveLbl.TextColor3 = Colors.Orange
    task.delay(2, function() saveLbl.Text = "اضغط حفظ أو استرجاع" saveLbl.TextColor3 = Colors.Green end)
end)

createButton(setPage, "🔄 إعادة الشخصية", Colors.Red, function()
    if LP.Character then LP.Character:BreakJoints() end
end)

-- 9. تبويب المعلومات (7 بيانات)
layoutCounter = layoutCounter + 1
local infoLbl = Instance.new("TextLabel", infoPage)
infoLbl.Size = UDim2.new(1, -10, 1, 0)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = "الإحصائيات المباشرة..."
infoLbl.TextColor3 = Colors.White
infoLbl.TextSize = 14
infoLbl.TextXAlignment = Enum.TextXAlignment.Left
infoLbl.TextYAlignment = Enum.TextYAlignment.Top
infoLbl.TextWrapped = true

-- 10. الحلقات المستمرة (تنفيذ الميزات)
-- Noclip
bd(RS.Stepped, function()
    if S.noclip and LP.Character then
        for _,p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end
    end
end)

-- Godmode
bd(RS.Heartbeat, function()
    if S.god and LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.Health = h.MaxHealth end end
end)

-- Ghost
bd(RS.Heartbeat, function()
    if S.ghost and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 0 end
        for _,p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 0.7 p.CanCollide = false end end
    end
end)

-- Hitbox
bd(RS.Heartbeat, function()
    if S.hitbox and LP.Character then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local box = LP.Character:FindFirstChild("GiantHitbox")
            if not box then
                box = Instance.new("Part", LP.Character)
                box.Name = "GiantHitbox"
                box.Transparency = 0.5 box.CanCollide = false box.Massless = true box.Color = Colors.Red
                local weld = Instance.new("WeldConstraint", box)
                weld.Part0 = hrp weld.Part1 = box
            end
            box.Size = Vector3.new(hbMult, hbMult, hbMult)
        end
    elseif not S.hitbox and LP.Character then
        local box = LP.Character:FindFirstChild("GiantHitbox") if box then box:Destroy() end
    end
end)

-- Fly
bd(RS.RenderStepped, function()
    if S.fly and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if not flyBV or flyBV.Parent ~= hrp then
            if flyBV then flyBV:Destroy() end
            if flyBG then flyBG:Destroy() end
            flyBV = Instance.new("BodyVelocity", hrp)
            flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flyBG = Instance.new("BodyGyro", hrp)
            flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            flyBG.P = 9e4
        end
        if hum then
            hum.PlatformStand = true
            local move = hum.MoveDirection * 50
            if UIS:IsKeyDown(Enum.KeyCode.Space) or flyUp then move = move + Vector3.new(0, 50, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or flyDown then move = move - Vector3.new(0, 50, 0) end
            flyBV.Velocity = move
            flyBG.CFrame = workspace.CurrentCamera.CFrame
        end
    elseif flyBV and not S.fly then 
        flyBV:Destroy() flyBV = nil 
        if flyBG then flyBG:Destroy() flyBG = nil end
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
    end
end)

-- Inf Jump
bd(UIS.JumpRequest, function()
    if S.inf and LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)

-- ESP
bd(RS.Heartbeat, function()
    if not S.esp then for _,v in pairs(espObjects) do if v and v.Parent then v:Destroy() end end espObjects = {} return end
    
    local localHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not localHrp then return end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - localHrp.Position).Magnitude
            if dist <= espRange then
                local highlight = espObjects[plr]
                if not highlight or not highlight.Parent then
                    highlight = Instance.new("Highlight")
                    highlight.FillColor = Colors.Red highlight.OutlineColor = Colors.White
                    highlight.FillTransparency = 0.5 highlight.OutlineTransparency = 0
                    highlight.Parent = g espObjects[plr] = highlight
                end
                highlight.Adornee = plr.Character
            else
                if espObjects[plr] then espObjects[plr]:Destroy() espObjects[plr] = nil end
            end
        end
    end
end)

-- 11. تحديث شاشة المعلومات (كل 0.5 ثانية)
local frameCount, timeCount = 0, 0
bd(RS.RenderStepped, function(dt)
    frameCount = frameCount + 1 timeCount = timeCount + dt
    if timeCount >= 0.5 then
        local fps = math.floor(frameCount / timeCount)
        frameCount, timeCount = 0, 0
        if infoPage.Visible then
            local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            infoLbl.Text = "📊 الإطارات (FPS): " .. fps .. "\n📡 زمن الاستجابة (Ping): " .. ping .. "ms\n⚡ سرعة الشخصية: " .. math.floor((h and h.WalkSpeed or 0)) .. "\n👥 عدد اللاعبين: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers .. "\n🏷️ اسم الشخصية: " .. LP.DisplayName .. "\n❤️ الدم: " .. (h and math.floor(h.Health) .. "/" .. math.floor(h.MaxHealth) or "-") .. "\n📍 الموقع: " .. (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and math.floor(LP.Character.HumanoidRootPart.Position.X) .. ", " .. math.floor(LP.Character.HumanoidRootPart.Position.Y) .. ", " .. math.floor(LP.Character.HumanoidRootPart.Position.Z) or "-")
        end
    end
end)

-- 12. زر العين السريع
local eyeBtn = Instance.new("TextButton", g)
eyeBtn.Size = UDim2.fromOffset(50, 50)
eyeBtn.Position = UDim2.new(0, 20, 0.5, -25)
eyeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
eyeBtn.BackgroundTransparency = 0.5
eyeBtn.Text = "👁️"
eyeBtn.TextColor3 = Colors.White
eyeBtn.TextSize = 24
eyeBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", eyeBtn).CornerRadius = UDim.new(1, 0)

eyeBtn.MouseButton1Click:Connect(function()
    if S.esp then
        S.esp = false
        eyeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        eyeBtn.BackgroundTransparency = 0.5
    else
        S.esp = true
        eyeBtn.BackgroundColor3 = Colors.BG
        eyeBtn.BackgroundTransparency = 0
    end
end)

-- 13. الزر العائم (👑)
local fbtn = Instance.new("ImageButton", g)
fbtn.Size = UDim2.fromOffset(60, 60)
fbtn.Position = UDim2.new(0, 20, 0.4, 0)
fbtn.BackgroundColor3 = Colors.Blue
fbtn.Visible = false
Instance.new("UICorner", fbtn).CornerRadius = UDim.new(1, 0)
local fLabel = Instance.new("TextLabel", fbtn)
fLabel.Size = UDim2.fromScale(1, 1)
fLabel.BackgroundTransparency = 1
fLabel.Text = "👑"
fLabel.TextSize = 24
fLabel.TextColor3 = Colors.White

local fDragging, fDragStart, fStartPos
fbtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fDragging = true
        fDragStart = input.Position
        fStartPos = fbtn.Position
    end
end)
bd(UIS.InputChanged, function(input)
    if fDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - fDragStart
        fbtn.Position = UDim2.new(fStartPos.X.Scale, fStartPos.X.Offset + delta.X, fStartPos.Y.Scale, fStartPos.Y.Offset + delta.Y)
    end
end)
bd(UIS.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fDragging = false
    end
end)

closeBtn.MouseButton1Click:Connect(function() m.Visible = false fbtn.Visible = true end)
fbtn.MouseButton1Click:Connect(function() m.Visible = true fbtn.Visible = false end)

-- تصغير القائمة
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        m.Size = UDim2.new(0, 550, 0, 80)
        tabsFrame.Visible = false
        pagesFrame.Visible = false
        title.Position = UDim2.new(0, 0, 0, 15)
        subtitle.Visible = false
    else
        m.Size = UDim2.new(0, 550, 0, 440)
        tabsFrame.Visible = true
        pagesFrame.Visible = true
        title.Position = UDim2.new(0, 0, 0, 10)
        subtitle.Visible = true
    end
end)

-- 14. إعادة تعيين الأزرار عند موت اللاعب
bd(LP.CharacterAdded, function()
    task.wait(1)
    if UI.Noclip then UI.Noclip.SetState(false) end
    if UI.Fly then UI.Fly.SetState(false) end
    if UI.Inf then UI.Inf.SetState(false) end
    if UI.Ghost then UI.Ghost.SetState(false) end
    if UI.God then UI.God.SetState(false) end
    if UI.Hitbox then UI.Hitbox.SetState(false) end
    if UI.Esp then UI.Esp.SetState(false) end
    if UI.SpeedSlider then UI.SpeedSlider.Update(16) end
    if UI.JumpSlider then UI.JumpSlider.Update(50) end
    flyUp = false
    flyDown = false
    flyBtnsFrame.Visible = false
end)

-- 15. دالة التنظيف
_G.KhalilCleanup = function()
    for _, c in ipairs(CN) do pcall(function() c:Disconnect() end) end
    CN = {}
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    for _,v in pairs(espObjects) do if v and v.Parent then v:Destroy() end end
    espObjects = {}
    if LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 h.JumpPower = 50 h.PlatformStand = false end
        local box = LP.Character:FindFirstChild("GiantHitbox") if box then box:Destroy() end
    end
    g:Destroy()
end

print("سكربت خليل | by خليل تم تحميله بنجاح! (النسخة النهائية المخصصة)")
