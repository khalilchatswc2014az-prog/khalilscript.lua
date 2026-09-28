-- سكربت خليل | Khalil Script
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer

-- تنظيف نسخة قديمة
if _G.KhalilCleanup then pcall(_G.KhalilCleanup) end
local conns = {}
local function bind(signal, fn) local c = signal:Connect(fn); table.insert(conns, c); return c end

local parent = (gethui and gethui()) or game:GetService("CoreGui")
local gui = Instance.new("ScreenGui")
gui.Name = "KhalilScript"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parent

-- إعدادات الحفظ
local SAVE_FILE = "KhalilSettings.json"
local canSave = (writefile and readfile and isfile and delfile) and true or false
local uiSet = {} -- لتخزين دوال التحديث الخاصة بالأزرار

-- إضافة god و ghost إلى الجدول
local state = {noclip = false, fly = false, inf = false, speed = false, esp = false, spec = false, hbx = false, items = false, coll = false, wpShow = false, fov = false, zoom = false, free = false, noshake = false, jump = false, god = false, ghost = false}
local speedValue = 10
local flyUp, flyDown = false, false

local function char() return player.Character end
local function hum() local c = char(); return c and c:FindFirstChildOfClass("Humanoid") end
local function root() local c = char(); return c and c:FindFirstChild("HumanoidRootPart") end
local function otherHum(c) if not c then return nil end return c:FindFirstChildOfClass("Humanoid") or c:FindFirstChild("Humanoid") end
local function otherRoot(c)
	if not c then return nil end
	return c:FindFirstChild("HumanoidRootPart")
		or c.PrimaryPart
		or c:FindFirstChild("Torso")
		or c:FindFirstChild("UpperTorso")
		or c:FindFirstChildWhichIsA("BasePart")
end

-- ألوان
local NAVY   = Color3.fromRGB(7, 12, 30)
local PANEL  = Color3.fromRGB(10, 18, 40)
local BLUE   = Color3.fromRGB(0, 140, 255)
local GREEN  = Color3.fromRGB(0, 220, 100)
local PURPLE = Color3.fromRGB(150, 60, 255)
local RED    = Color3.fromRGB(255, 40, 70)
local CYAN   = Color3.fromRGB(0, 200, 255)
local ORANGE = Color3.fromRGB(255, 170, 0)
local WHITE  = Color3.new(1, 1, 1)

-- أدوات
local function corner(o, r) local c = Instance.new("UICorner", o); c.CornerRadius = r or UDim.new(0, 10); return c end
local function stroke(o, col, t) local s = Instance.new("UIStroke", o); s.Color = col; s.Thickness = t or 2; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; return s end
local function frame(p, pos, size, bg)
	local f = Instance.new("Frame", p)
	f.Position, f.Size = pos, size
	if bg then f.BackgroundColor3 = bg else f.BackgroundTransparency = 1 end
	f.BorderSizePixel = 0
	return f
end
local function label(p, text, size, pos, sz, col)
	local l = Instance.new("TextLabel", p)
	l.BackgroundTransparency = 1
	l.Text = text
	l.Font = Enum.Font.GothamBold
	l.TextSize = size
	l.TextColor3 = col or WHITE
	l.Position, l.Size = pos, sz
	return l
end
local function button(p, text, size, pos, sz, bg, col)
	local b = Instance.new("TextButton", p)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = size
	b.TextColor3 = col or WHITE
	b.BackgroundColor3 = bg or PANEL
	b.AutoButtonColor = true
	b.BorderSizePixel = 0
	b.Position, b.Size = pos, sz
	return b
end

-- صورة الحساب
local avatarImg = ""
pcall(function()
	avatarImg = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)

-- ========== النافذة الرئيسية ==========
local main = frame(gui, UDim2.new(0.5, 0, 0.5, 0), UDim2.fromOffset(500, 440), NAVY)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Active = true
corner(main, UDim.new(0, 18))
stroke(main, BLUE, 3)
local grad = Instance.new("UIGradient", main)
grad.Rotation = 90
grad.Color = ColorSequence.new(Color3.fromRGB(12, 22, 52), Color3.fromRGB(5, 9, 24))
local uiScale = Instance.new("UIScale", main)

-- سحب النافذة
do
	local dragging, dragStart, startPos = false, nil, nil
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging, dragStart, startPos = true, i.Position, main.Position
		end
	end)
	bind(UIS.InputChanged, function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
			local delta = i.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	bind(UIS.InputEnded, function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

local crown = label(main, "👑", 46, UDim2.new(0.5, -30, 0, -38), UDim2.fromOffset(60, 50), Color3.fromRGB(80, 190, 255))
crown.ZIndex = 5

-- العنوان
label(main, "سكربت خليل", 36, UDim2.new(0, 130, 0, 14), UDim2.fromOffset(330, 50), Color3.fromRGB(190, 235, 255))
label(main, "كل ما تحتاجه في مكان واحد", 15, UDim2.new(0, 130, 0, 62), UDim2.fromOffset(330, 22), CYAN)

-- زر الإغلاق
local close = button(main, "✕", 22, UDim2.new(1, -54, 0, 14), UDim2.fromOffset(40, 40), Color3.fromRGB(12, 22, 52))
corner(close, UDim.new(0, 12)); stroke(close, BLUE, 2)

-- الصورة الشخصية
local av = frame(main, UDim2.fromOffset(16, 20), UDim2.fromOffset(92, 92), Color3.fromRGB(20, 30, 60))
corner(av, UDim.new(1, 0)); stroke(av, CYAN, 3)
local avImg = Instance.new("ImageLabel", av)
avImg.Size = UDim2.fromScale(1, 1)
avImg.BackgroundTransparency = 1
avImg.Image = avatarImg
corner(avImg, UDim.new(1, 0))

-- التوقيع
local sig = label(main, "By 👑\nخليل!", 20, UDim2.fromOffset(12, 366), UDim2.fromOffset(100, 68), CYAN)
sig.Font = Enum.Font.SourceSansItalic
sig.TextWrapped = true

-- لوحة المحتوى
local panel = frame(main, UDim2.fromOffset(122, 96), UDim2.new(1, -134, 1, -110), PANEL)
corner(panel, UDim.new(0, 14)); stroke(panel, BLUE, 2)

local function makePage()
	local f = frame(panel, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1))
	f.Visible = false
	return f
end
local homePage, settingsPage, infoPage = makePage(), makePage(), makePage()

local espPage = Instance.new("ScrollingFrame", panel)
espPage.BackgroundTransparency = 1
espPage.BorderSizePixel = 0
espPage.Size = UDim2.fromScale(1, 1)
espPage.ScrollBarThickness = 4
espPage.Active = true
espPage.CanvasSize = UDim2.new(0, 0, 0, 0)
espPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
espPage.Visible = false
do
	local lay = Instance.new("UIListLayout", espPage)
	lay.Padding = UDim.new(0, 6)
	lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	local pad = Instance.new("UIPadding", espPage)
	pad.PaddingTop = UDim.new(0, 8)
	pad.PaddingBottom = UDim.new(0, 8)
end

-- صف بحدود ملونة
local function makeRow(page, y, h, color, icon, name)
	local hh = math.min(h, 48)
	local row = frame(page, UDim2.new(0, 10, 0, y), UDim2.new(1, -20, 0, h), Color3.fromRGB(11, 16, 36))
	corner(row, UDim.new(0, 12)); stroke(row, color, 2)
	label(row, icon, 26, UDim2.fromOffset(10, 0), UDim2.fromOffset(50, hh))
	local nl = label(row, name, 18, UDim2.new(0, 64, 0, 0), UDim2.new(1, -140, 0, hh))
	nl.TextWrapped = true
	return row, nl
end

local function makeSwitch(row, color, callback, initial)
	local hh = math.min(row.Size.Y.Offset, 48)
	local OFFC = Color3.fromRGB(60, 60, 75)
	local sw = button(row, "", 14, UDim2.new(1, -70, 0, (hh - 30) / 2), UDim2.fromOffset(58, 30), OFFC)
	sw.AutoButtonColor = false
	corner(sw, UDim.new(1, 0))
	local knob = frame(sw, UDim2.new(0, 3, 0.5, -12), UDim2.fromOffset(24, 24), WHITE)
	corner(knob, UDim.new(1, 0))
	local on = false
	if initial then
		on = true
		sw.BackgroundColor3 = color
		knob.Position = UDim2.new(1, -27, 0.5, -12)
	end
	local function apply(v)
		on = v
		sw.BackgroundColor3 = on and color or OFFC
		knob:TweenPosition(on and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12), "Out", "Quad", 0.15, true)
		callback(on)
	end
	sw.MouseButton1Click:Connect(function() apply(not on) end)
	return function(v) if v ~= on then apply(v) end end
end

-- ========== عبور الجدران ==========
local setNoclip = makeSwitch(makeRow(homePage, 8, 48, BLUE, "🧱", "عبور الجدران"), BLUE, function(on) state.noclip = on end)
uiSet["noclip"] = setNoclip
bind(RS.Stepped, function()
	if state.noclip and char() then
		for _, p in ipairs(char():GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end
end)

-- ========== الطيران ==========
local bv, bg
local flyBtns = frame(gui, UDim2.new(1, -80, 0.5, -65), UDim2.fromOffset(60, 130))
flyBtns.Visible = false
local function flyButton(text, y, isUp)
	local b = button(flyBtns, text, 26, UDim2.fromOffset(0, y), UDim2.fromOffset(60, 60), GREEN)
	b.BackgroundTransparency = 0.2
	corner(b, UDim.new(1, 0))
	b.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			if isUp then flyUp = true else flyDown = true end
		end
	end)
	b.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			if isUp then flyUp = false else flyDown = false end
		end
	end)
end
flyButton("▲", 0, true)
flyButton("▼", 70, false)

local function stopFly()
	if bv then bv:Destroy() bv = nil end
	if bg then bg:Destroy() bg = nil end
	local h = hum()
	if h then h.PlatformStand = false end
end

local setFly = makeSwitch(makeRow(homePage, 62, 48, GREEN, "🪽", "الطيران"), GREEN, function(on)
	state.fly = on
	flyBtns.Visible = on or state.free
	if not on then stopFly() end
end)
uiSet["fly"] = setFly
bind(RS.RenderStepped, function()
	if not state.fly or state.ghost then return end
	local r, h = root(), hum()
	if not (r and h) then return end
	if not bv or bv.Parent ~= r then
		stopFly()
		bv = Instance.new("BodyVelocity", r)
		bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		bg = Instance.new("BodyGyro", r)
		bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
		bg.P = 9e4
	end
	h.PlatformStand = true
	local flySpeed = 60
	local dir = h.MoveDirection * flySpeed
	if flyUp then dir += Vector3.new(0, flySpeed, 0) end
	if flyDown then dir -= Vector3.new(0, flySpeed, 0) end
	bv.Velocity = dir
	bg.CFrame = workspace.CurrentCamera.CFrame
end)

-- ========== قفز لا نهائي ==========
local setInf = makeSwitch(makeRow(homePage, 116, 48, PURPLE, "♾️", "قفز لا نهائي"), PURPLE, function(on) state.inf = on end)
uiSet["inf"] = setInf
bind(UIS.JumpRequest, function()
	if state.inf then
		local h = hum()
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- ========== كاشف اماكن الاعبين (ESP) ==========
local opt = {box = false, names = true, dist = true, hp = false, morph = false, speed = false, arrow = false, closest = false, alert = false, list = false, map = false}
local espRange = 500
local espHidden = false
local espObjs = {}

-- عناصر الشاشة
local mapFrame = frame(gui, UDim2.new(1, -170, 0, 70), UDim2.fromOffset(150, 150), Color3.fromRGB(6, 12, 30))
mapFrame.BackgroundTransparency = 0.25
mapFrame.ClipsDescendants = true
mapFrame.Visible = false
corner(mapFrame, UDim.new(1, 0)); stroke(mapFrame, BLUE, 2)
local meDot = frame(mapFrame, UDim2.new(0.5, -4, 0.5, -4), UDim2.fromOffset(8, 8), WHITE)
corner(meDot, UDim.new(1, 0))

local nearbyLbl = label(gui, "", 14, UDim2.new(0, 10, 0, 120), UDim2.fromOffset(210, 96), WHITE)
nearbyLbl.BackgroundTransparency = 0.4
nearbyLbl.BackgroundColor3 = Color3.new(0, 0, 0)
nearbyLbl.TextXAlignment = Enum.TextXAlignment.Left
nearbyLbl.TextYAlignment = Enum.TextYAlignment.Top
nearbyLbl.Visible = false
corner(nearbyLbl, UDim.new(0, 8))

local alertLbl = label(gui, "", 20, UDim2.new(0.5, -160, 0, 70), UDim2.fromOffset(320, 36), Color3.fromRGB(255, 90, 90))
alertLbl.BackgroundTransparency = 0.3
alertLbl.BackgroundColor3 = Color3.new(0, 0, 0)
alertLbl.Visible = false
corner(alertLbl, UDim.new(0, 10))

local eyeBtn = button(gui, "👁️", 22, UDim2.new(0, 10, 0.5, -22), UDim2.fromOffset(44, 44), Color3.fromRGB(12, 22, 52))
corner(eyeBtn, UDim.new(1, 0)); stroke(eyeBtn, ORANGE, 2)
eyeBtn.Visible = false
eyeBtn.MouseButton1Click:Connect(function()
	espHidden = not espHidden
	eyeBtn.BackgroundTransparency = espHidden and 0.7 or 0
end)

local function clearESP(plr)
	local o = espObjs[plr]
	if o then
		for _, i in pairs(o) do pcall(function() i:Destroy() end) end
		espObjs[plr] = nil
	end
end
local function hideESP(o)
	o.hl.Enabled = false
	o.box.Enabled = false
	o.bb.Enabled = false
	o.arrow.Visible = false
	o.arrowTxt.Visible = false
	o.dot.Visible = false
end

local function addESP(plr)
	if plr == player then return end
	clearESP(plr)
	local c = plr.Character
	local r = otherRoot(c)
	if not r then return end

	local hl = Instance.new("Highlight")
	hl.FillColor = ORANGE
	hl.OutlineColor = WHITE
	hl.FillTransparency = 0.6
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = c

	-- مربع + شريط الصحة
	local box = Instance.new("BillboardGui")
	box.Size = UDim2.new(4, 0, 6, 0)
	box.AlwaysOnTop = true
	box.Adornee = r
	box.Parent = r
	local boxFrame = Instance.new("Frame", box)
	boxFrame.Size = UDim2.fromScale(1, 1)
	boxFrame.BackgroundTransparency = 1
	local bs = Instance.new("UIStroke", boxFrame)
	bs.Color = ORANGE
	bs.Thickness = 1.5
	local hpBg = Instance.new("Frame", box)
	hpBg.Size = UDim2.new(0.1, 0, 1, 0)
	hpBg.Position = UDim2.new(-0.16, 0, 0, 0)
	hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	hpBg.BorderSizePixel = 0
	local hpFill = Instance.new("Frame", hpBg)
	hpFill.AnchorPoint = Vector2.new(0, 1)
	hpFill.Position = UDim2.fromScale(0, 1)
	hpFill.Size = UDim2.fromScale(1, 1)
	hpFill.BackgroundColor3 = GREEN
	hpFill.BorderSizePixel = 0

	-- نص فوق اللاعب
	local bb = Instance.new("BillboardGui")
	bb.Size = UDim2.fromOffset(170, 58)
	bb.StudsOffset = Vector3.new(0, 4, 0)
	bb.AlwaysOnTop = true
	bb.Adornee = r
	bb.Parent = r
	local lbl = Instance.new("TextLabel", bb)
	lbl.Size = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 13
	lbl.TextColor3 = ORANGE
	lbl.TextStrokeTransparency = 0
	lbl.Text = plr.DisplayName

	-- سهم خارج الشاشة
	local arrow = Instance.new("TextLabel", gui)
	arrow.Size = UDim2.fromOffset(34, 34)
	arrow.AnchorPoint = Vector2.new(0.5, 0.5)
	arrow.BackgroundTransparency = 1
	arrow.Text = ">"
	arrow.Font = Enum.Font.GothamBlack
	arrow.TextSize = 34
	arrow.TextColor3 = ORANGE
	arrow.TextStrokeTransparency = 0
	arrow.Visible = false
	local arrowTxt = Instance.new("TextLabel", gui)
	arrowTxt.Size = UDim2.fromOffset(70, 14)
	arrowTxt.AnchorPoint = Vector2.new(0.5, 0.5)
	arrowTxt.BackgroundTransparency = 1
	arrowTxt.Font = Enum.Font.GothamBold
	arrowTxt.TextSize = 12
	arrowTxt.TextColor3 = WHITE
	arrowTxt.TextStrokeTransparency = 0
	arrowTxt.Visible = false

	-- نقطة الخريطة
	local dot = frame(mapFrame, UDim2.fromOffset(0, 0), UDim2.fromOffset(6, 6), ORANGE)
	corner(dot, UDim.new(1, 0))
	dot.Visible = false

	espObjs[plr] = {hl = hl, box = box, bb = bb, arrow = arrow, arrowTxt = arrowTxt, dot = dot, boxFrame = boxFrame, hpBg = hpBg, hpFill = hpFill, lbl = lbl, stroke = bs}
end

local function watchPlayer(plr)
	if plr == player then return end
	bind(plr.CharacterAdded, function(c)
		if state.esp then
			task.wait(0.5)
			if not otherRoot(c) then task.wait(1.5) end
			addESP(plr)
		end
	end)
end
for _, p in ipairs(Players:GetPlayers()) do watchPlayer(p) end
bind(Players.PlayerAdded, function(p)
	watchPlayer(p)
	if state.esp and p.Character then addESP(p) end
end)

-- كشف الـ Morph
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
	local boolMorph = nil
	for _, holder in ipairs({c, plr}) do
		for k, v in pairs(holder:GetAttributes()) do
			if hasKey(k) then
				if type(v) == "string" and v ~= "" then return v end
				if type(v) == "boolean" then boolMorph = v end
			end
		end
		for _, d in ipairs(holder:GetDescendants()) do
			if d:IsA("ValueBase") and hasKey(d.Name) then
				if d:IsA("StringValue") and d.Value ~= "" then return d.Value end
				if d:IsA("ObjectValue") and d.Value then return d.Value.Name end
				if d:IsA("BoolValue") then boolMorph = d.Value end
			end
		end
	end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("Model") and not d:IsA("Accessory") and not d:IsA("Tool") then return d.Name end
	end
	if c.Name ~= plr.Name and c.Name ~= plr.DisplayName then return c.Name end
	if boolMorph == true then return "متحول (الاسم غير معروف)" end
	if boolMorph == false then return "غير متحول" end
	return nil
end

-- ---- صفحة الكاشف ----
local espOrder = 0
local function espRow(color, icon, name, h)
	espOrder += 1
	local row = makeRow(espPage, 0, h or 40, color, icon, name)
	row.LayoutOrder = espOrder
	return row
end

local setEsp = makeSwitch(espRow(ORANGE, "👁️", "كاشف اماكن الاعبين", 48), ORANGE, function(on)
	state.esp = on
	eyeBtn.Visible = on
	for _, p in ipairs(Players:GetPlayers()) do
		if on then addESP(p) else clearESP(p) end
	end
end)
uiSet["esp"] = setEsp

local function optRow(color, icon, name, key)
	local setter = makeSwitch(espRow(color, icon, name), color, function(on) opt[key] = on end, opt[key])
	uiSet["esp_" .. key] = setter
end
optRow(BLUE,   "🔲", "مربع حول اللاعب", "box")
optRow(CYAN,   "🏷️", "أسماء اللاعبين", "names")
optRow(CYAN,   "📏", "المسافة", "dist")
optRow(RED,    "❤️", "شريط الصحة", "hp")
optRow(PURPLE, "🧬", "كشف التحول", "morph")
optRow(GREEN,  "⚡", "عداد سرعة اللاعب", "speed")
optRow(BLUE,   "🧭", "سهم اتجاه خارج الشاشة", "arrow")
optRow(RED,    "🎯", "تحديد أقرب لاعب", "closest")
optRow(ORANGE, "🔔", "تنبيه عند اقتراب لاعب", "alert")
optRow(BLUE,   "📊", "قائمة اللاعبين القريبين", "list")
optRow(GREEN,  "🗺️", "خريطة مصغرة", "map")

-- نطاق الكشف
local zRow = espRow(BLUE, "🚪", "نطاق الكشف (متر)")
local zBox = Instance.new("TextBox", zRow)
zBox.Position, zBox.Size = UDim2.new(1, -70, 0, 5), UDim2.fromOffset(58, 30)
zBox.BackgroundColor3 = Color3.fromRGB(6, 12, 30)
zBox.BorderSizePixel = 0
zBox.Font = Enum.Font.GothamBold
zBox.TextSize = 16
zBox.TextColor3 = WHITE
zBox.Text = "500"
corner(zBox, UDim.new(0, 8)); stroke(zBox, BLUE, 1.5)
zBox.FocusLost:Connect(function()
	local n = tonumber(zBox.Text)
	if n then espRange = math.clamp(math.floor(n), 20, 100000) end
	zBox.Text = tostring(espRange)
end)

-- Spectate
local specList, specIdx, specTarget = {}, 0, nil
local specName
local function stepSpec(delta)
	specList = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then table.insert(specList, p) end
	end
	table.sort(specList, function(a, b) return a.Name < b.Name end)
	if #specList == 0 then
		specTarget = nil
		specName.Text = "لا يوجد لاعبين"
		return
	end
	specIdx = ((specIdx - 1 + delta) % #specList) + 1
	specTarget = specList[specIdx]
	specName.Text = specTarget.DisplayName
end
local function restoreCamera()
	local h = hum()
	if h then workspace.CurrentCamera.CameraSubject = h end
end
makeSwitch(espRow(PURPLE, "🎥", "متابعة لاعب"), PURPLE, function(on)
	state.spec = on
	if on and not specTarget then stepSpec(1) end
	if not on then restoreCamera() end
end)
local specRow = frame(espPage, UDim2.new(0, 10, 0, 0), UDim2.new(1, -20, 0, 40), Color3.fromRGB(11, 16, 36))
espOrder += 1
specRow.LayoutOrder = espOrder
corner(specRow, UDim.new(0, 12)); stroke(specRow, PURPLE, 2)
specName = label(specRow, "اختر لاعب", 16, UDim2.new(0, 50, 0, 0), UDim2.new(1, -100, 1, 0))
local prevB = button(specRow, "◀", 18, UDim2.fromOffset(8, 4), UDim2.fromOffset(38, 32), Color3.fromRGB(12, 22, 52))
local nextB = button(specRow, "▶", 18, UDim2.new(1, -46, 0, 4), UDim2.fromOffset(38, 32), Color3.fromRGB(12, 22, 52))
corner(prevB, UDim.new(0, 8)); corner(nextB, UDim.new(0, 8))
prevB.MouseButton1Click:Connect(function() stepSpec(-1) end)
nextB.MouseButton1Click:Connect(function() stepSpec(1) end)

bind(Players.PlayerRemoving, function(p)
	clearESP(p)
	if specTarget == p then
		specTarget = nil
		specName.Text = "اللاعب خرج"
		if state.spec then restoreCamera() end
	end
end)
bind(RS.RenderStepped, function()
	if state.spec and specTarget then
		local c = specTarget.Character
		local h = otherHum(c)
		local cam = workspace.CurrentCamera
		if h and cam and cam.CameraSubject ~= h then cam.CameraSubject = h end
	end
end)

-- ---- الحلقة الرئيسية للكاشف ----
local espAcc = 0
bind(RS.RenderStepped, function(dt)
	local active = state.esp and not espHidden
	mapFrame.Visible = active and opt.map
	nearbyLbl.Visible = active and opt.list
	alertLbl.Visible = false
	if not active then
		for _, o in pairs(espObjs) do hideESP(o) end
		return
	end
	local myR = root()
	if not myR then return end

	espAcc += dt
	local doText = espAcc >= 0.15
	if doText then espAcc = 0 end

	local cam = workspace.CurrentCamera
	if not cam then return end
	local vp = cam.ViewportSize
	local list = {}
	for plr, o in pairs(espObjs) do
		local c = plr.Character
		local r = otherRoot(c)
		local h = otherHum(c)
		if r and h and r.Parent then
			local d = (r.Position - myR.Position).Magnitude
			if d <= espRange then
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
		local isClosest = opt.closest and e == closest
		local col = isClosest and RED or ORANGE
		o.hl.Enabled = true
		o.hl.FillColor = col
		o.stroke.Color = col
		o.lbl.TextColor3 = col

		if h.MaxHealth >= h.Health then
			o.hpMax = h.MaxHealth
		else
			o.hpMax = math.max(o.hpMax or h.MaxHealth, h.Health)
		end

		o.box.Enabled = opt.box or opt.hp
		o.boxFrame.Visible = opt.box
		o.hpBg.Visible = opt.hp
		if opt.hp then
			local frac = math.clamp(h.Health / o.hpMax, 0, 1)
			o.hpFill.Size = UDim2.fromScale(1, frac)
			o.hpFill.BackgroundColor3 = Color3.fromHSV(frac * 0.33, 1, 1)
		end

		o.bb.Enabled = opt.names or opt.dist or opt.morph or opt.speed or opt.hp
		if doText and o.bb.Enabled then
			local parts, ex = {}, {}
			if opt.names then parts[#parts + 1] = e.plr.DisplayName end
			if opt.dist then ex[#ex + 1] = "[" .. math.floor(d) .. "m]" end
			if opt.hp then ex[#ex + 1] = "❤️" .. math.floor(o.hpMax) .. "/" .. math.floor(h.Health) end
			if opt.speed then
				local v = r.AssemblyLinearVelocity
				ex[#ex + 1] = "⚡" .. math.floor(Vector3.new(v.X, 0, v.Z).Magnitude)
			end
			if #ex > 0 then parts[#parts + 1] = table.concat(ex, " ") end
			if opt.morph then
				if os.clock() - (o.morphT or 0) > 1 then
					o.morph = getMorph(e.plr)
					o.morphT = os.clock()
				end
				parts[#parts + 1] = "🧬 " .. (o.morph or "عادي")
			end
			o.lbl.Text = table.concat(parts, "\n")
		end

		o.arrow.Visible = false
		o.arrowTxt.Visible = false
		if opt.arrow then
			local v, onScreen = cam:WorldToViewportPoint(r.Position)
			if not onScreen then
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
				o.arrowTxt.Position = UDim2.fromOffset(pt.X, pt.Y + 22)
				o.arrowTxt.Text = math.floor(d) .. "m"
				o.arrowTxt.Visible = true
			end
		end

		o.dot.Visible = opt.map
		if opt.map then
			local rel = r.Position - myR.Position
			local mx, my = rel:Dot(right), -rel:Dot(look)
			local range, half = 150, 75
			local px, py = mx / range * half, my / range * half
			local m = math.sqrt(px * px + py * py)
			if m > half - 6 then px, py = px / m * (half - 6), py / m * (half - 6) end
			o.dot.Position = UDim2.new(0.5, px - 3, 0.5, py - 3)
			o.dot.BackgroundColor3 = col
		end
	end

	if opt.list and doText then
		local t = {}
		for i = 1, math.min(5, #list) do
			t[i] = i .. ") " .. list[i].plr.DisplayName .. "  [" .. math.floor(list[i].d) .. "m]"
		end
		nearbyLbl.Text = #t > 0 and table.concat(t, "\n") or "لا يوجد لاعبين قريبين"
	end

	if opt.alert and closest and closest.d <= 40 then
		alertLbl.Text = "⚠️ " .. closest.plr.DisplayName .. " قريب [" .. math.floor(closest.d) .. "m]"
		alertLbl.Visible = true
	end
end)

-- ========== السرعة ==========
local speedRow = makeRow(homePage, 170, 92, RED, "🏃", "السرعة")
local setSpeedSw = makeSwitch(speedRow, RED, function(on)
	state.speed = on
	if not on then
		local h = hum()
		if h then h.WalkSpeed = 16 end
	end
end)
uiSet["speed"] = setSpeedSw
frame(speedRow, UDim2.fromOffset(0, 48), UDim2.new(1, 0, 0, 2), RED)

local minus = button(speedRow, "−", 24, UDim2.fromOffset(10, 54), UDim2.fromOffset(38, 32), Color3.fromRGB(12, 22, 52))
corner(minus, UDim.new(0, 8)); stroke(minus, BLUE, 2)
local plus = button(speedRow, "+", 24, UDim2.fromOffset(236, 54), UDim2.fromOffset(38, 32), Color3.fromRGB(12, 22, 52))
corner(plus, UDim.new(0, 8)); stroke(plus, BLUE, 2)

local valueBox = Instance.new("TextBox", speedRow)
valueBox.Position, valueBox.Size = UDim2.fromOffset(282, 54), UDim2.fromOffset(52, 32)
valueBox.BackgroundColor3 = Color3.fromRGB(11, 16, 36)
valueBox.BorderSizePixel = 0
valueBox.Font = Enum.Font.GothamBold
valueBox.TextSize = 20
valueBox.TextColor3 = WHITE
valueBox.Text = "10"
valueBox.ClearTextOnFocus = true
valueBox.TextEditable = true
corner(valueBox, UDim.new(0, 8)); stroke(valueBox, RED, 2)

local hit = frame(speedRow, UDim2.fromOffset(56, 54), UDim2.fromOffset(172, 24))
hit.Active = true
local bar = frame(hit, UDim2.new(0, 0, 0.5, -3), UDim2.new(1, 0, 0, 6), Color3.fromRGB(30, 50, 100))
corner(bar, UDim.new(1, 0))
local fill = frame(bar, UDim2.fromScale(0, 0), UDim2.fromScale(0, 1), BLUE)
corner(fill, UDim.new(1, 0))
local handle = frame(bar, UDim2.new(0, -9, 0.5, -9), UDim2.fromOffset(18, 18), WHITE)
corner(handle, UDim.new(1, 0))
label(speedRow, "10", 12, UDim2.fromOffset(56, 72), UDim2.fromOffset(30, 14), Color3.fromRGB(200, 220, 255)).TextXAlignment = Enum.TextXAlignment.Left
label(speedRow, "75", 12, UDim2.fromOffset(198, 72), UDim2.fromOffset(30, 14), Color3.fromRGB(200, 220, 255)).TextXAlignment = Enum.TextXAlignment.Right

local function setSpeed(v)
	speedValue = math.clamp(math.floor(v + 0.5), 10, 75)
	local a = (speedValue - 10) / 65
	fill.Size = UDim2.new(a, 0, 1, 0)
	handle.Position = UDim2.new(a, -9, 0.5, -9)
	valueBox.Text = tostring(speedValue)
end
setSpeed(10)
valueBox.FocusLost:Connect(function()
	local n = tonumber(valueBox.Text)
	setSpeed(n or speedValue)
end)
minus.MouseButton1Click:Connect(function() setSpeed(speedValue - 1) end)
plus.MouseButton1Click:Connect(function() setSpeed(speedValue + 1) end)

local dragging = false
local function fromX(x)
	setSpeed(10 + math.clamp((x - hit.AbsolutePosition.X) / hit.AbsoluteSize.X, 0, 1) * 65)
end
hit.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		fromX(i.Position.X)
	end
end)
bind(UIS.InputChanged, function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
		fromX(i.Position.X)
	end
end)
bind(UIS.InputEnded, function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
bind(RS.Heartbeat, function()
	if state.speed and not state.free and not state.ghost then
		local h = hum()
		if h then h.WalkSpeed = speedValue end
	end
end)

-- ========== هيتبوكس عملاق (لشخصيتك أنت فقط) ==========
local hbMult = 5
local hbOrig = {}
local function hbRestorePart(part, o)
	pcall(function()
		part.Size = o.Size
		part.Transparency = o.Transparency
		part.CanCollide = o.CanCollide
		part.Massless = o.Massless
	end)
end
local function hbRestoreAll()
	for part, o in pairs(hbOrig) do
		hbRestorePart(part, o)
		hbOrig[part] = nil
	end
end

local setHbx = makeSwitch(makeRow(homePage, 270, 48, ORANGE, "👹", "هيتبوكس عملاق"), ORANGE, function(on)
	state.hbx = on
	if not on then hbRestoreAll() end
end)
uiSet["hbx"] = setHbx

local hbT = 0
bind(RS.Heartbeat, function(dt)
	hbT += dt
	if hbT < 0.2 then return end
	hbT = 0
	for part, o in pairs(hbOrig) do
		if not (state.hbx and part.Parent) then
			hbRestorePart(part, o)
			hbOrig[part] = nil
		end
	end
	if not state.hbx then return end
	
	local r = root()
	if r then
		local o = hbOrig[r]
		if not o then
			o = {Size = r.Size, Transparency = r.Transparency, CanCollide = r.CanCollide, Massless = r.Massless}
			hbOrig[r] = o
		end
		local target = o.Size * hbMult
		if r.Size ~= target then r.Size = target end
		r.Transparency = 0.5
		r.CanCollide = false
		r.Massless = true
	end
end)

local hbRow = makeRow(settingsPage, 118, 48, ORANGE, "👹", "حجم الهيتبوكس")
local hbBox = Instance.new("TextBox", hbRow)
hbBox.Position, hbBox.Size = UDim2.new(1, -70, 0, 9), UDim2.fromOffset(58, 30)
hbBox.BackgroundColor3 = Color3.fromRGB(6, 12, 30)
hbBox.BorderSizePixel = 0
hbBox.Font = Enum.Font.GothamBold
hbBox.TextSize = 16
hbBox.TextColor3 = WHITE
hbBox.Text = tostring(hbMult)
corner(hbBox, UDim.new(0, 8)); stroke(hbBox, ORANGE, 1.5)
hbBox.FocusLost:Connect(function()
	local n = tonumber(hbBox.Text)
	if n then hbMult = math.clamp(n, 1, 15) end
	hbBox.Text = tostring(hbMult)
end)

-- ========== صفحات جديدة ==========
local alive = true

local function makeScrollPage()
	local sp = Instance.new("ScrollingFrame", panel)
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
	local order = 0
	return sp, function() order += 1; return order end
end
local camPage, camOrder = makeScrollPage()
local worldPage, worldOrder = makeScrollPage()

local function pageRow(page, orderFn, color, icon, name, h)
	local row, nl = makeRow(page, 0, h or 40, color, icon, name)
	row.LayoutOrder = orderFn()
	return row, nl
end
local function inputBox(row, text, color, y)
	local tb = Instance.new("TextBox", row)
	tb.Position, tb.Size = UDim2.new(1, -140, 0, y or 5), UDim2.fromOffset(58, 30)
	tb.BackgroundColor3 = Color3.fromRGB(6, 12, 30)
	tb.BorderSizePixel = 0
	tb.Font = Enum.Font.GothamBold
	tb.TextSize = 16
	tb.TextColor3 = WHITE
	tb.Text = text
	corner(tb, UDim.new(0, 8)); stroke(tb, color, 1.5)
	return tb
end
local function twoBtnRow(page, orderFn, color, t1, f1, t2, f2)
	local row = frame(page, UDim2.new(), UDim2.new(1, -20, 0, 40), Color3.fromRGB(11, 16, 36))
	row.LayoutOrder = orderFn()
	corner(row, UDim.new(0, 12)); stroke(row, color, 2)
	local b1 = button(row, t1, 14, UDim2.new(0, 4, 0, 4), UDim2.new(0.5, -6, 1, -8), Color3.fromRGB(18, 55, 130))
	local b2 = button(row, t2, 14, UDim2.new(0.5, 2, 0, 4), UDim2.new(0.5, -6, 1, -8), Color3.fromRGB(18, 55, 130))
	corner(b1, UDim.new(0, 8)); corner(b2, UDim.new(0, 8))
	b1.MouseButton1Click:Connect(f1)
	b2.MouseButton1Click:Connect(f2)
end

-- ---------- قوة القفز (الرئيسية) ----------
local jumpValue = 100
local jRow, jNl = makeRow(homePage, 326, 48, GREEN, "🦘", "قوة القفز")
jNl.Size = UDim2.new(1, -215, 0, 48)
local jBox = inputBox(jRow, tostring(jumpValue), GREEN, 9)
local setJump = makeSwitch(jRow, GREEN, function(on)
	state.jump = on
	if not on then
		local h = hum()
		if h then h.JumpPower = 50 end
	end
end)
uiSet["jump"] = setJump
jBox.FocusLost:Connect(function()
	local n = tonumber(jBox.Text)
	if n then jumpValue = math.clamp(n, 50, 300) end
	jBox.Text = tostring(jumpValue)
end)
bind(RS.Heartbeat, function()
	if state.jump then
		local h = hum()
		if h then
			h.UseJumpPower = true
			h.JumpPower = jumpValue
		end
	end
end)

-- ========== عدم الموت ==========
local setGod = makeSwitch(makeRow(homePage, 382, 48, GREEN, "🛡️", "عدم الموت"), GREEN, function(on) state.god = on end)
uiSet["god"] = setGod
bind(RS.Heartbeat, function()
	if state.god and char() then
		local h = hum()
		if h then h.Health = h.MaxHealth end
	end
end)

-- ========== وضع الشبح ==========
local setGhost = makeSwitch(makeRow(homePage, 438, 48, PURPLE, "👻", "وضع الشبح"), PURPLE, function(on) 
    state.ghost = on 
    if not on and char() then
        for _, p in ipairs(char():GetDescendants()) do
            if p:IsA("BasePart") then
                p.Transparency = 0
                p.CanCollide = true
            end
        end
    end
end)
uiSet["ghost"] = setGhost
bind(RS.Heartbeat, function()
	if state.ghost and char() then
		local h = hum()
		if h then h.WalkSpeed = 0 end
		for _, p in ipairs(char():GetDescendants()) do
			if p:IsA("BasePart") then
				p.Transparency = 0.7
				p.CanCollide = false
			end
		end
	end
end)

-- ---------- إعادة الشخصية (الإعدادات) ----------
local rstRow = makeRow(settingsPage, 176, 48, RED, "🔄", "إعادة الشخصية")
local rstBtn = button(rstRow, "🔄", 16, UDim2.new(1, -70, 0, 9), UDim2.fromOffset(58, 30), Color3.fromRGB(90, 20, 30))
corner(rstBtn, UDim.new(0, 8))
local rstArmed = false
rstBtn.MouseButton1Click:Connect(function()
	if not rstArmed then
		rstArmed = true
		rstBtn.Text = "تأكيد؟"
		task.delay(3, function()
			rstArmed = false
			rstBtn.Text = "🔄"
		end)
	else
		rstArmed = false
		rstBtn.Text = "🔄"
		local h = hum()
		if h then h.Health = 0 end
	end
end)

-- ========== [إضافة جديدة] حفظ واسترجاع الإعدادات ==========
local saveRow = makeRow(settingsPage, 234, 48, GREEN, "💾", "حفظ الإعدادات")
local saveBtn = button(saveRow, "حفظ", 14, UDim2.fromOffset(10, 9), UDim2.fromOffset(60, 30), Color3.fromRGB(18, 100, 50))
local loadBtn = button(saveRow, "استرجاع", 14, UDim2.fromOffset(80, 9), UDim2.fromOffset(70, 30), Color3.fromRGB(18, 55, 130))
local clearBtn = button(saveRow, "مسح", 14, UDim2.fromOffset(160, 9), UDim2.fromOffset(50, 30), Color3.fromRGB(90, 20, 30))
local statusLbl = label(saveRow, "اضغط حفظ أو استرجاع", 12, UDim2.new(1, -130, 0, 0), UDim2.fromOffset(120, 48), Color3.fromRGB(200, 200, 200))
statusLbl.TextXAlignment = Enum.TextXAlignment.Right
corner(saveBtn, UDim.new(0, 8)); corner(loadBtn, UDim.new(0, 8)); corner(clearBtn, UDim.new(0, 8))

saveBtn.MouseButton1Click:Connect(function()
	if not canSave then statusLbl.Text = "غير مدعوم"; return end
	local data = {
		state = state,
		opt = opt,
		speedValue = speedValue,
		jumpValue = jumpValue,
		espRange = espRange,
		hbMult = hbMult,
		fovValue = fovValue,
		zoomValue = zoomValue
	}
	local success, encoded = pcall(function() return HS:JSONEncode(data) end)
	if success then
		pcall(function() writefile(SAVE_FILE, encoded) end)
		statusLbl.Text = "✅ تم الحفظ"
		statusLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
		task.delay(2, function() statusLbl.Text = "اضغط حفظ أو استرجاع" statusLbl.TextColor3 = Color3.fromRGB(200, 200, 200) end)
	else
		statusLbl.Text = "❌ فشل الحفظ"
		statusLbl.TextColor3 = Color3.fromRGB(255, 50, 50)
	end
end)

loadBtn.MouseButton1Click:Connect(function()
	if not canSave then statusLbl.Text = "غير مدعوم"; return end
	if not isfile(SAVE_FILE) then statusLbl.Text = "لا يوجد محفوظات"; return end
	local success, content = pcall(function() return readfile(SAVE_FILE) end)
	if not success or not content then return end
	local success2, decoded = pcall(function() return HS:JSONDecode(content) end)
	if not success2 or not decoded then return end
	
	if decoded.state then
		for k, v in pairs(decoded.state) do
			if state[k] ~= nil then
				state[k] = v
				if uiSet[k] then uiSet[k](v) end
			end
		end
	end
	if decoded.opt then
		for k, v in pairs(decoded.opt) do
			if opt[k] ~= nil then
				opt[k] = v
				if uiSet["esp_" .. k] then uiSet["esp_" .. k](v) end
			end
		end
	end
	if decoded.speedValue then setSpeed(decoded.speedValue) end
	if decoded.jumpValue then jumpValue = decoded.jumpValue; jBox.Text = tostring(jumpValue) end
	if decoded.espRange then espRange = decoded.espRange; zBox.Text = tostring(espRange) end
	if decoded.hbMult then hbMult = decoded.hbMult; hbBox.Text = tostring(hbMult) end
	if decoded.fovValue then fovValue = decoded.fovValue; fovBox.Text = tostring(fovValue) end
	if decoded.zoomValue then zoomValue = decoded.zoomValue; zoomBox.Text = tostring(zoomValue) end
	
	statusLbl.Text = "✅ تم الاسترجاع"
	statusLbl.TextColor3 = Color3.fromRGB(0, 200, 255)
	task.delay(2, function() statusLbl.Text = "اضغط حفظ أو استرجاع" statusLbl.TextColor3 = Color3.fromRGB(200, 200, 200) end)
end)

clearBtn.MouseButton1Click:Connect(function()
	if not canSave then return end
	pcall(function() delfile(SAVE_FILE) end)
	statusLbl.Text = "🗑️ تم المسح"
	statusLbl.TextColor3 = Color3.fromRGB(255, 170, 0)
	task.delay(2, function() statusLbl.Text = "اضغط حفظ أو استرجاع" statusLbl.TextColor3 = Color3.fromRGB(200, 200, 200) end)
end)

-- ---------- الكاميرا ----------
-- FOV
local fovValue = 70
local fovRow, fovNl = pageRow(camPage, camOrder, BLUE, "🔭", "زاوية الرؤية")
fovNl.Size = UDim2.new(1, -215, 0, 40)
local fovBox = inputBox(fovRow, tostring(fovValue), BLUE)
local setFov = makeSwitch(fovRow, BLUE, function(on)
	state.fov = on
	if not on then local c = workspace.CurrentCamera; if c then c.FieldOfView = 70 end end
end)
uiSet["fov"] = setFov
fovBox.FocusLost:Connect(function()
	local n = tonumber(fovBox.Text)
	if n then fovValue = math.clamp(n, 50, 120) end
	fovBox.Text = tostring(fovValue)
end)
bind(RS.RenderStepped, function()
	if state.fov then local c = workspace.CurrentCamera; if c then c.FieldOfView = fovValue end end
end)

-- Zoom
local zoomValue = 400
local zoomOrig = nil
local function applyZoom(on)
	if on then
		if not zoomOrig then zoomOrig = {player.CameraMaxZoomDistance, player.CameraMinZoomDistance} end
		player.CameraMaxZoomDistance = zoomValue
		player.CameraMinZoomDistance = 0.5
	elseif zoomOrig then
		player.CameraMinZoomDistance = zoomOrig[2]
		player.CameraMaxZoomDistance = zoomOrig[1]
		zoomOrig = nil
	end
end
local zoomRow, zoomNl = pageRow(camPage, camOrder, CYAN, "🔍", "تكبير مفتوح")
zoomNl.Size = UDim2.new(1, -215, 0, 40)
local zoomBox = inputBox(zoomRow, tostring(zoomValue), CYAN)
local setZoom = makeSwitch(zoomRow, CYAN, function(on)
	state.zoom = on
	applyZoom(on)
end)
uiSet["zoom"] = setZoom
zoomBox.FocusLost:Connect(function()
	local n = tonumber(zoomBox.Text)
	if n then zoomValue = math.clamp(n, 20, 2000) end
	zoomBox.Text = tostring(zoomValue)
	if state.zoom then applyZoom(true) end
end)

-- كاميرا حرة
local free = {yaw = 0, pitch = 0, pos = Vector3.new()}
local function setFreeCam(on)
	local cam = workspace.CurrentCamera
	if not cam then return end
	state.free = on
	flyBtns.Visible = on or state.fly
	local h = hum()
	if on then
		local cf = cam.CFrame
		local rx, ry = cf:ToOrientation()
		free.pitch, free.yaw, free.pos = rx, ry, cf.Position
		cam.CameraType = Enum.CameraType.Scriptable
	else
		cam.CameraType = Enum.CameraType.Custom
		if h then
			cam.CameraSubject = h
			h.WalkSpeed = state.speed and speedValue or 16
		end
	end
end
local setFree = makeSwitch(pageRow(camPage, camOrder, PURPLE, "🎬", "كاميرا حرة"), PURPLE, setFreeCam)
uiSet["free"] = setFree
bind(RS.RenderStepped, function(dt)
	if not state.free then return end
	local cam = workspace.CurrentCamera
	if not cam then return end
	local h = hum()
	if h then h.WalkSpeed = 0 end
	local md = h and h.MoveDirection or Vector3.new()
	local spd = 45 * dt
	local up = ((flyUp and 1 or 0) - (flyDown and 1 or 0)) * spd
	free.pos = free.pos + md * spd + Vector3.new(0, up, 0)
	cam.CFrame = CFrame.new(free.pos) * CFrame.fromOrientation(free.pitch, free.yaw, 0)
end)
bind(UIS.InputChanged, function(i, gp)
	if not state.free or gp then return end
	if i.UserInputType == Enum.UserInputType.Touch
		or (i.UserInputType == Enum.UserInputType.MouseMovement and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
		free.yaw = free.yaw - i.Delta.X * 0.006
		free.pitch = math.clamp(free.pitch - i.Delta.Y * 0.006, -1.5, 1.5)
	end
end)

-- منع اهتزاز الكاميرا
local setNoshake = makeSwitch(pageRow(camPage, camOrder, CYAN, "📳", "منع اهتزاز الكاميرا"), CYAN, function(on) state.noshake = on end)
uiSet["noshake"] = setNoshake
bind(RS.RenderStepped, function()
	if state.noshake then
		local h = hum()
		if h then h.CameraOffset = Vector3.new() end
	end
end)

-- ---------- العالم: علامات على الشاشة ----------
local markLayer = frame(gui, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1))
markLayer.ZIndex = -5
local markPools = {}
local function renderMarkers(id, entries, color)
	local pool = markPools[id]
	if not pool then pool = {}; markPools[id] = pool end
	local used = 0
	local myR = root()
	if entries and myR then
		local cam = workspace.CurrentCamera
		for _, e in ipairs(entries) do
			local pos = e.pos or (e.part and e.part.Parent and e.part.Position)
			if pos then
				local v, onScreen = cam:WorldToViewportPoint(pos)
				if onScreen then
					used += 1
					local l = pool[used]
					if not l then
						l = Instance.new("TextLabel", markLayer)
						l.Size = UDim2.fromOffset(130, 32)
						l.AnchorPoint = Vector2.new(0.5, 0.5)
						l.BackgroundTransparency = 1
						l.Font = Enum.Font.GothamBold
						l.TextSize = 12
						l.TextStrokeTransparency = 0
						pool[used] = l
					end
					l.Position = UDim2.fromOffset(v.X, v.Y)
					l.Text = e.text .. "\n[" .. math.floor((pos - myR.Position).Magnitude) .. "m]"
					l.TextColor3 = color
					l.Visible = true
				end
			end
		end
	end
	for i = used + 1, #pool do pool[i].Visible = false end
end

local wps = {}
local finderItems, finderColl = {}, {}
local scanNow = false
local autoScan = true
local scanInterval = 3
bind(RS.RenderStepped, function()
	renderMarkers("item", state.items and finderItems or nil, ORANGE)
	renderMarkers("coll", state.coll and finderColl or nil, GREEN)
	renderMarkers("wp", state.wpShow and wps or nil, CYAN)
end)

-- البحث عن العناصر
local COLL_KEYS = {"coin", "gem", "orb", "collect", "pickup", "cash", "star", "crystal", "egg", "candy", "diamond", "token", "fruit", "chest"}
task.spawn(function()
	while alive do
		if state.items or state.coll then
			local wantI, wantC = state.items, state.coll
			local items, coll = {}, {}
			local desc = workspace:GetDescendants()
			for i, d in ipairs(desc) do
				if wantI then
					if d:IsA("Tool") and not Players:GetPlayerFromCharacter(d.Parent) then
						local h = d:FindFirstChild("Handle")
						if h and h:IsA("BasePart") then items[#items + 1] = {part = h, text = d.Name} end
					elseif d:IsA("ProximityPrompt") and d.Parent and d.Parent:IsA("BasePart") then
						local t = d.ObjectText ~= "" and d.ObjectText or d.Parent.Name
						items[#items + 1] = {part = d.Parent, text = t}
					end
				end
				if wantC and d:IsA("BasePart") then
					local n = d.Name:lower()
					for _, k in ipairs(COLL_KEYS) do
						if n:find(k, 1, true) then
							coll[#coll + 1] = {part = d, text = d.Name}
							break
						end
					end
				end
				if i % 2000 == 0 then task.wait() end
			end
			local myR = root()
			local function trim(list)
				if myR then
					table.sort(list, function(a, b)
						return (a.part.Position - myR.Position).Magnitude < (b.part.Position - myR.Position).Magnitude
					end)
				end
				while #list > 40 do table.remove(list) end
			end
			trim(items); trim(coll)
			finderItems, finderColl = items, coll
		end
		local waited = 0
		while alive and (waited < scanInterval or not autoScan) and not scanNow do
			task.wait(0.25)
			waited += 0.25
		end
		scanNow = false
	end
end)

local setItems = makeSwitch(pageRow(worldPage, worldOrder, ORANGE, "🎁", "كاشف العناصر"), ORANGE, function(on)
	state.items = on
	scanNow = true
end)
uiSet["items"] = setItems

local setColl = makeSwitch(pageRow(worldPage, worldOrder, GREEN, "💎", "كاشف الجوائز والعملات"), GREEN, function(on)
	state.coll = on
	scanNow = true
end)
uiSet["coll"] = setColl

-- التحديث التلقائي للكاشف
local scanRow, scanNl = pageRow(worldPage, worldOrder, CYAN, "🔁", "التحديث التلقائي للكاشف")
scanNl.Size = UDim2.new(1, -215, 0, 40)
local scanBox = inputBox(scanRow, tostring(scanInterval), CYAN)
local setAuto = makeSwitch(scanRow, CYAN, function(on) autoScan = on end, true)
uiSet["auto"] = setAuto
scanBox.FocusLost:Connect(function()
	local n = tonumber(scanBox.Text)
	if n then scanInterval = math.clamp(n, 1, 30) end
	scanBox.Text = tostring(scanInterval)
end)
local scanBtn = button(scanRow, "🔄", 16, UDim2.new(1, -136, 0, 5), UDim2.fromOffset(30, 30), Color3.fromRGB(18, 55, 130))
corner(scanBtn, UDim.new(0, 8))
scanBtn.MouseButton1Click:Connect(function() scanNow = true end)


-- حفظ / استرجاع الموقع
local savedCF = nil
twoBtnRow(worldPage, worldOrder, BLUE, "💾 حفظ الموقع", function()
	local r = root()
	if r then savedCF = r.CFrame end
end, "↩️ استرجاع الموقع", function()
	local r = root()
	if r and savedCF then r.CFrame = savedCF end
end)

-- النقاط (Waypoints)
local setWp = makeSwitch(pageRow(worldPage, worldOrder, CYAN, "📍", "إظهار النقاط على الشاشة"), CYAN, function(on) state.wpShow = on end)
uiSet["wp"] = setWp

local wpCount = 0
local function addWaypointRow(wp)
	local row = frame(worldPage, UDim2.new(), UDim2.new(1, -20, 0, 40), Color3.fromRGB(11, 16, 36))
	row.LayoutOrder = worldOrder()
	corner(row, UDim.new(0, 12)); stroke(row, CYAN, 2)
	label(row, wp.text, 15, UDim2.new(0, 96, 0, 0), UDim2.new(1, -150, 1, 0))
	local go = button(row, "انتقال", 14, UDim2.fromOffset(8, 5), UDim2.fromOffset(80, 30), Color3.fromRGB(18, 55, 130))
	corner(go, UDim.new(0, 8))
	local del = button(row, "🗑", 16, UDim2.new(1, -46, 0, 5), UDim2.fromOffset(38, 30), Color3.fromRGB(90, 20, 30))
	corner(del, UDim.new(0, 8))
	go.MouseButton1Click:Connect(function()
		local r = root()
		if r then r.CFrame = CFrame.new(wp.pos + Vector3.new(0, 3, 0)) end
	end)
	del.MouseButton1Click:Connect(function()
		local idx = table.find(wps, wp)
		if idx then table.remove(wps, idx) end
		row:Destroy()
	end)
end
local addRow = frame(worldPage, UDim2.new(), UDim2.new(1, -20, 0, 40), Color3.fromRGB(11, 16, 36))
addRow.LayoutOrder = worldOrder()
corner(addRow, UDim.new(0, 12)); stroke(addRow, GREEN, 2)
local addBtn = button(addRow, "➕ إضافة نقطة هنا", 16, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), Color3.fromRGB(11, 16, 36))
corner(addBtn, UDim.new(0, 12))
addBtn.MouseButton1Click:Connect(function()
	local r = root()
	if r then
		wpCount += 1
		local wp = {pos = r.Position, text = "نقطة " .. wpCount}
		table.insert(wps, wp)
		addWaypointRow(wp)
	end
end)

local function resetExtras()
	alive = false
	if state.free then setFreeCam(false) end
	if state.fov then local c = workspace.CurrentCamera; if c then c.FieldOfView = 70 end end
	state.fov, state.noshake, state.jump, state.items, state.coll, state.wpShow = false, false, false, false, false, false
	applyZoom(false)
	local h = hum()
	if h then h.JumpPower = 50 end
end

-- ========== FPS / Ping في الإعدادات ==========
local perfRow = makeRow(settingsPage, 292, 48, CYAN, "📶", "الإطارات وزمن الاستجابة")
local perfLbl = label(perfRow, "-- / --", 15, UDim2.new(1, -140, 0, 0), UDim2.fromOffset(120, 48), WHITE)
local perfFpsN, perfFpsT = 0, 0
bind(RS.RenderStepped, function(dt)
	perfFpsN += 1
	perfFpsT += dt
	if perfFpsT >= 0.5 then
		local fps = math.floor(perfFpsN / perfFpsT + 0.5)
		perfFpsN, perfFpsT = 0, 0
		if settingsPage.Visible then
			local ping = 0
			pcall(function()
				ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
			end)
			perfLbl.Text = "الإطارات: " .. fps .. "\nزمن الاستجابة: " .. ping .. " مي‌ث"
		end
	end
end)

-- ========== الإعدادات: حجم القائمة ==========
local sRow = makeRow(settingsPage, 10, 100, BLUE, "📐", "حجم القائمة")
local scaleValue = 1
local scaleLbl = label(sRow, "100%", 20, UDim2.new(0.5, -35, 0, 56), UDim2.fromOffset(70, 34))
local function setScale(v)
	scaleValue = math.clamp(math.floor(v * 10 + 0.5) / 10, 0.6, 1.4)
	uiScale.Scale = scaleValue
	scaleLbl.Text = math.floor(scaleValue * 100 + 0.5) .. "%"
end
local function scaleBtn(text, xOff, delta)
	local b = button(sRow, text, 24, UDim2.new(0.5, xOff, 0, 56), UDim2.fromOffset(44, 34), Color3.fromRGB(12, 22, 52))
	corner(b, UDim.new(0, 8)); stroke(b, BLUE, 2)
	b.MouseButton1Click:Connect(function() setScale(scaleValue + delta) end)
end
scaleBtn("−", -100, -0.1)
scaleBtn("+", 56, 0.1)

-- ========== المعلومات ==========
local iRow = frame(infoPage, UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 56), Color3.fromRGB(11, 16, 36))
corner(iRow, UDim.new(0, 12)); stroke(iRow, BLUE, 2)
local infoLbl = label(iRow, "هذا السكربت تم تصميمه لاجل حمد بكيفي", 17, UDim2.fromOffset(10, 0), UDim2.new(1, -20, 1, 0), Color3.fromRGB(190, 235, 255))
infoLbl.TextWrapped = true

local statsRow = frame(infoPage, UDim2.new(0, 10, 0, 74), UDim2.new(1, -20, 0, 236), Color3.fromRGB(11, 16, 36))
corner(statsRow, UDim.new(0, 12)); stroke(statsRow, CYAN, 2)
local statsLbl = label(statsRow, "", 15, UDim2.fromOffset(10, 6), UDim2.new(1, -20, 1, -12), WHITE)
statsLbl.TextXAlignment = Enum.TextXAlignment.Left
statsLbl.TextYAlignment = Enum.TextYAlignment.Top
statsLbl.TextWrapped = true
local fpsN, fpsT = 0, 0
bind(RS.RenderStepped, function(dt)
	fpsN += 1
	fpsT += dt
	if fpsT >= 0.5 then
		local fps = math.floor(fpsN / fpsT + 0.5)
		fpsN, fpsT = 0, 0
		if infoPage.Visible then
			local ping = 0
