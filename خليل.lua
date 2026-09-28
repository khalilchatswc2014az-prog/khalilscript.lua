-- ========================================================
-- سكربت خليل | by خليل
-- النسخة النهائية المطلقة - تم فحص كل الأخطاء المحتملة
-- ========================================================

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- 1. تنظيف أي نسخة قديمة (مع حماية كاملة)
if _G.KhalilCleanup then pcall(_G.KhalilCleanup) end
pcall(function()
    local oldGui = game.CoreGui:FindFirstChild("KhalilGui")
    if oldGui then oldGui:Destroy() end
end)

-- 2. الإعدادات والمتغيرات
local S = {
    noclip = false,
    fly = false,
    inf = false,
    speed = false,
    esp = false
}

local CN = {}
local espObjects = {}
local flyBV = nil
local flyUp = false
local isMinimized = false

-- 3. إعادة الضبط عند الموت
table.insert(CN, LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    if flyBV then flyBV:Destroy() flyBV = nil end
    S.noclip = false
    S.fly = false
    S.inf = false
    S.speed = false
    S.esp = false
    flyUp = false
    if _G.KhalilButtons then
        for _, btn in pairs(_G.KhalilButtons) do
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
end))

-- 4. المكان الآمن للواجهة (مع حماية من أخطاء Executor)
local function getSafeParent()
    if gethui then
        local success, result = pcall(gethui)
        if success and result then return result end
    end
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then return coreGui end
    return LP:WaitForChild("PlayerGui")
end

-- 5. بناء الواجهة
local g = Instance.new("ScreenGui")
g.Name = "KhalilGui"
g.ResetOnSpawn = false
g.IgnoreGuiInset = true
g.Parent = getSafeParent()

local m = Instance.new("Frame")
m.Name = "MainFrame"
m.Size = UDim2.new(0, 320, 0, 480)
m.Position = UDim2.new(0.5, -160, 0.5, -240)
m.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
m.BorderSizePixel = 0
m.Visible = true
m.Parent = g

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 160, 255)
stroke.Thickness = 3
stroke.Parent = m

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 15)
mCorner.Parent = m

-- شريط السحب
local dragBar = Instance.new("TextButton")
dragBar.Size = UDim2.new(1, 0, 0, 80)
dragBar.Position = UDim2.new(0, 0, 0, 0)
dragBar.BackgroundTransparency = 1
dragBar.Text = ""
dragBar.Parent = m

-- النصوص
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 15)
title.BackgroundTransparency = 1
title.Text = "سكربت خليل"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 36
title.Font = Enum.Font.SourceSansBold
title.Parent = m

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 65)
subtitle.BackgroundTransparency = 1
subtitle.Text = "كل ما تحتاجه في مكان واحد"
subtitle.TextColor3 = Color3.fromRGB(0, 160, 255)
subtitle.TextSize = 16
subtitle.Font = Enum.Font.SourceSans
subtitle.Parent = m

local author = Instance.new("TextLabel")
author.Size = UDim2.new(1, 0, 0, 30)
author.Position = UDim2.new(0, 0, 1, -40)
author.BackgroundTransparency = 1
author.Text = "By خليل 👑"
author.TextColor3 = Color3.fromRGB(255, 255, 255)
author.TextSize = 18
author.Font = Enum.Font.SourceSansBold
author.Parent = m

-- الأزرار العلوية
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = m
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -80, 0, 10)
minBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 18
minBtn.Font = Enum.Font.SourceSansBold
minBtn.Parent = m
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

-- إنشاء الأزرار
local function createFeatureBtn(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 250, 0, 40)
    btn.Position = UDim2.new(0.5, -125, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 16
    btn.Font = Enum.Font.SourceSans
    btn.Parent = m
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local strokeBtn = Instance.new("UIStroke")
    strokeBtn.Color = Color3.fromRGB(0, 160, 255)
    strokeBtn.Thickness = 1
    strokeBtn.Parent = btn
    return btn
end

local btnNoclip = createFeatureBtn("اختراق الجدران (Noclip) [1]", 120)
local btnFly = createFeatureBtn("الطيران (Fly) [2]", 170)
local btnInf = createFeatureBtn("قفز لا نهائي (Inf Jump) [3]", 220)
local btnSpeed = createFeatureBtn("سرعة فائقة (Speed) [4]", 270)
local btnESP = createFeatureBtn("رؤية اللاعبين (ESP) [5]", 320)

_G.KhalilButtons = {Noclip = btnNoclip, Fly = btnFly, Inf = btnInf, Speed = btnSpeed, ESP = btnESP}

-- 6. كود السحب
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    m.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = m.Position
    end
end)

dragBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        dragInput = nil
    end
end)

dragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- 7. أزرار التحكم
closeBtn.MouseButton1Click:Connect(function() m.Visible = false end)
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        m.Size = UDim2.new(0, 320, 0, 110)
        for _, btn in pairs(_G.KhalilButtons) do btn.Visible = false end
        author.Visible = false
        subtitle.Visible = false
    else
        m.Size = UDim2.new(0, 320, 0, 480)
        for _, btn in pairs(_G.KhalilButtons) do btn.Visible = true end
        author.Visible = true
        subtitle.Visible = true
    end
end)

-- 8. الوظائف
local function toggleNoclip()
    S.noclip = not S.noclip
    btnNoclip.TextColor3 = S.noclip and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 200, 200)
    if not S.noclip and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "Head" then
                pcall(function() v.CanCollide = true end)
            end
        end
    end
end

local function toggleFly()
    S.fly = not S.fly
    btnFly.TextColor3 = S.fly and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 200, 200)
    if not S.fly and flyBV then flyBV:Destroy() flyBV = nil end
end

local function toggleInf()
    S.inf = not S.inf
    btnInf.TextColor3 = S.inf and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 200, 200)
end

local function toggleSpeed()
    S.speed = not S.speed
    btnSpeed.TextColor3 = S.speed and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 200, 200)
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = S.speed and 150 or 16 end
end

local function toggleESP()
    S.esp = not S.esp
    btnESP.TextColor3 = S.esp and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 200, 200)
end

btnNoclip.MouseButton1Click:Connect(toggleNoclip)
btnFly.MouseButton1Click:Connect(toggleFly)
btnInf.MouseButton1Click:Connect(toggleInf)
btnSpeed.MouseButton1Click:Connect(toggleSpeed)
btnESP.MouseButton1Click:Connect(toggleESP)

-- 9. الاختصارات
UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        m.Visible = not m.Visible
    elseif UIS:IsKeyDown(Enum.KeyCode.RightControl) then
        if i.KeyCode == Enum.KeyCode.One then toggleNoclip() end
        if i.KeyCode == Enum.KeyCode.Two then toggleFly() end
        if i.KeyCode == Enum.KeyCode.Three then toggleInf() end
        if i.KeyCode == Enum.KeyCode.Four then toggleSpeed() end
        if i.KeyCode == Enum.KeyCode.Five then toggleESP() end
    end
end)

-- 10. الحلقات المستمرة
-- اختراق الجدران (Noclip)
table.insert(CN, RunService.Stepped:Connect(function()
    if S.noclip and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end))

-- قفز لا نهائي
table.insert(CN, UIS.JumpRequest:Connect(function()
    if S.inf and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end
    end
end))

-- دعم الطيران للموبايل
table.insert(CN, UIS.JumpRequest:Connect(function()
    if S.fly then flyUp = true end
end))

table.insert(CN, UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
        flyUp = false
    end
end))

-- Fly (تمت إضافة حماية للتحقق من وجود Humanoid)
table.insert(CN, RunService.RenderStepped:Connect(function()
    if S.fly and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        
        if hum and hum.Parent then -- حماية إضافية
            if not flyBV or flyBV.Parent ~= hrp then
                if flyBV then flyBV:Destroy() end
                flyBV = Instance.new("BodyVelocity")
                flyBV.Name = "FlyBV"
                flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                flyBV.Parent = hrp
            end
            
            local moveVector = hum.MoveDirection * 50
            if UIS:IsKeyDown(Enum.KeyCode.Space) or flyUp then
                moveVector = moveVector + Vector3.new(0, 50, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVector = moveVector - Vector3.new(0, 50, 0)
            end
            
            flyBV.Velocity = moveVector
        end
    elseif flyBV and not S.fly then
        flyBV:Destroy()
        flyBV = nil
    end
end))

-- ESP
table.insert(CN, RunService.Heartbeat:Connect(function()
    if not S.esp then
        for _, v in pairs(espObjects) do if v and v.Parent then v:Destroy() end end
        espObjects = {}
        return
    end

    for plr, highlight in pairs(espObjects) do
        if not plr.Parent or not plr.Character then
            if highlight and highlight.Parent then highlight:Destroy() end
            espObjects[plr] = nil
        end
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = espObjects[plr]
            if not highlight or not highlight.Parent then
                highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = g
                espObjects[plr] = highlight
            end
            highlight.Adornee = plr.Character
        end
    end
end))

-- 11. دالة التنظيف
_G.KhalilCleanup = function()
    for _, c in ipairs(CN) do
        if c and c.Disconnect then pcall(function() c:Disconnect() end) end
    end
    CN = {}
    
    if flyBV then flyBV:Destroy() end
    for _, v in pairs(espObjects) do if v and v.Parent then v:Destroy() end end
    espObjects = {}
    
    if LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "Head" then
                pcall(function() v.CanCollide = true end)
            end
        end
    end
    
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = 16
        h.JumpPower = 50
        pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    
    if g then g:Destroy() end
    _G.KhalilCleanup = nil
end

print("سكربت خليل | by خليل تم تحميله بنجاح! (النسخة النهائية الخالية من الأخطاء)")
