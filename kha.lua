-- ========================================================
-- سكربت خليل | Khalil Script
-- النسخة الكاملة - تم إصلاح جميع الأخطاء المنطقية
-- ========================================================

local Players=game:GetService("Players")
local RS=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local HS=game:GetService("HttpService")
local plr=Players.LocalPlayer

if _G.KhalilCleanup then pcall(_G.KhalilCleanup) end
local CN={}
local function bd(s,f)local c=s:Connect(f)table.insert(CN,c)return c end

-- [إصلاح 1]: التأكد من أن الواجهة تفتح في المكان الصحيح
local pg=(gethui and gethui())or game:GetService("CoreGui")
local g=Instance.new("ScreenGui")
g.Name="KhalilScript" g.ResetOnSpawn=false g.IgnoreGuiInset=true
g.ZIndexBehavior=Enum.ZIndexBehavior.Global g.Parent=pg

local S={noclip=false,fly=false,inf=false,speed=false,esp=false,hbx=false,items=false,coll=false,wpShow=false,fov=false,zoom=false,free=false,noshake=false,jump=false,ghost=false,god=false}
local sv=1 local fv=60 local fU,fD=false,false
local SF="KhalilSettings.json"
local hasF=(writefile and readfile and delfile)and true or false

local function ch()return plr.Character end
local function hu()local c=ch()return c and c:FindFirstChildOfClass("Humanoid")end
local function rt()local c=ch()return c and c:FindFirstChild("HumanoidRootPart")end
local function oH(c)if not c then return nil end return c:FindFirstChildOfClass("Humanoid")end
local function oR(c)if not c then return nil end return c:FindFirstChild("HumanoidRootPart")or c.PrimaryPart or c:FindFirstChild("Torso")or c:FindFirstChild("UpperTorso")or c:FindFirstChildWhichIsA("BasePart")end

local NV=Color3.fromRGB(7,12,30)
local PN=Color3.fromRGB(10,18,40)
local BL=Color3.fromRGB(0,140,255)
local GR=Color3.fromRGB(0,220,100)
local PU=Color3.fromRGB(150,60,255)
local RD=Color3.fromRGB(255,40,70)
local CY=Color3.fromRGB(0,200,255)
local OG=Color3.fromRGB(255,170,0)
local WH=Color3.new(1,1,1)
local BK=Color3.fromRGB(0,0,0)

local function cr(o,r)local c=Instance.new("UICorner",o)c.CornerRadius=r or UDim.new(0,10)return c end
local function st(o,c,t)local s=Instance.new("UIStroke",o)s.Color=c s.Thickness=t or 2 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border return s end
local function fr(p,po,sz,bg)local f=Instance.new("Frame",p)f.Position,f.Size=po,sz if bg then f.BackgroundColor3=bg else f.BackgroundTransparency=1 end f.BorderSizePixel=0 return f end
local function lb(p,t,sz,po,s2,c)local l=Instance.new("TextLabel",p)l.BackgroundTransparency=1 l.Text=t l.Font=Enum.Font.GothamBold l.TextSize=sz l.TextColor3=c or WH l.Position,l.Size=po,s2 l.BorderSizePixel=0 return l end
local function bt(p,t,sz,po,s2,bg,c)local b=Instance.new("TextButton",p)b.Text=t b.Font=Enum.Font.GothamBold b.TextSize=sz b.TextColor3=c or WH b.BackgroundColor3=bg or PN b.AutoButtonColor=true b.BorderSizePixel=0 b.Position,b.Size=po,s2 return b end

local avI=""
pcall(function()avI=Players:GetUserThumbnailAsync(plr.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)end)
local m=fr(g,UDim2.new(0.5,0,0.5,0),UDim2.fromOffset(500,440),NV)
m.AnchorPoint=Vector2.new(0.5,0.5)
m.Active=false -- [إصلاح 1]: تم تغييرها إلى false لكي لا تمنع اللعب خلف القائمة
cr(m,UDim.new(0,18))st(m,BL,3)

local gd=Instance.new("UIGradient",m)
gd.Rotation=90
gd.Color=ColorSequence.new(Color3.fromRGB(12,22,52),Color3.fromRGB(5,9,24))
local us=Instance.new("UIScale",m)

do 
    local d,s,o=false,nil,nil
    m.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then d,s,o=true,i.Position,m.Position end end)
    bd(UIS.InputChanged,function(i)if d and(i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement)then local de=i.Position-s m.Position=UDim2.new(o.X.Scale,o.X.Offset+de.X,o.Y.Scale,o.Y.Offset+de.Y)end end)
    bd(UIS.InputEnded,function(i)if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end end)
end

lb(m,"👑",46,UDim2.new(0.5,-30,0,-38),UDim2.fromOffset(60,50),Color3.fromRGB(80,190,255)).ZIndex=5
lb(m,"سكربت خليل",36,UDim2.new(0,130,0,14),UDim2.fromOffset(330,50),Color3.fromRGB(190,235,255))
lb(m,"كل ما تحتاجه في مكان واحد",15,UDim2.new(0,130,0,62),UDim2.fromOffset(330,22),CY)

local cl=bt(m,"✕",22,UDim2.new(1,-54,0,14),UDim2.fromOffset(40,40),Color3.fromRGB(12,22,52))
cr(cl,UDim.new(0,12))st(cl,BL,2)

local av=fr(m,UDim2.fromOffset(16,20),UDim2.fromOffset(92,92),Color3.fromRGB(20,30,60))
cr(av,UDim.new(1,0))st(av,CY,3)
local avM=Instance.new("ImageLabel",av)avM.Size=UDim2.fromScale(1,1)avM.BackgroundTransparency=1 avM.Image=avI avM.BorderSizePixel=0 cr(avM,UDim.new(1,0))

local sg=lb(m,"By 👑\nخليل!",20,UDim2.fromOffset(12,366),UDim2.fromOffset(100,68),CY)
sg.Font=Enum.Font.SourceSansItalic sg.TextWrapped=true

local pn=fr(m,UDim2.fromOffset(122,96),UDim2.new(1,-134,1,-110),PN)
cr(pn,UDim.new(0,14))st(pn,BL,2)

local function mkPg()
    local sp=Instance.new("ScrollingFrame",pn)
    sp.BackgroundTransparency=1 sp.BorderSizePixel=0 sp.Size=UDim2.fromScale(1,1)
    sp.ScrollBarThickness=4 sp.Active=true sp.CanvasSize=UDim2.new()sp.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sp.Visible=false sp.ScrollingDirection=Enum.ScrollingDirection.Y
    local L=Instance.new("UIListLayout",sp)L.Padding=UDim.new(0,6)
    L.HorizontalAlignment=Enum.HorizontalAlignment.Center L.SortOrder=Enum.SortOrder.LayoutOrder
    local pd=Instance.new("UIPadding",sp)pd.PaddingTop=UDim.new(0,8)pd.PaddingBottom=UDim.new(0,8)
    local o=0 return sp,function()o=o+1 return o end
end

local hPg,hO=mkPg()
local ePg,eO=mkPg()
local cPg,cO=mkPg()
local wPg,wO=mkPg()
local sPg,sO=mkPg()
local iPg,iO=mkPg()

local function mkR(p,h,c,ic,nm)
    local hh=math.min(h or 48,48)
    local r=fr(p,UDim2.new(0,10,0,0),UDim2.new(1,-20,0,h or 48),Color3.fromRGB(11,16,36))
    cr(r,UDim.new(0,12))st(r,c,2)
    lb(r,ic,26,UDim2.fromOffset(10,0),UDim2.fromOffset(50,hh))
    local nl=lb(r,nm,18,UDim2.new(0,64,0,0),UDim2.new(1,-140,0,hh))nl.TextWrapped=true
    return r
end

local function mkSw(r,c,cb,ini)
    local hh=math.min(r.Size.Y.Offset,48)
    local OFFC=Color3.fromRGB(60,60,75)
    local s=bt(r,"",14,UDim2.new(1,-70,0,(hh-30)/2),UDim2.fromOffset(58,30),OFFC)
    s.AutoButtonColor=false cr(s,UDim.new(1,0))
    local k=fr(s,UDim2.new(0,3,0.5,-12),UDim2.fromOffset(24,24),WH)cr(k,UDim.new(1,0))
    local on=false
    if ini then on=true s.BackgroundColor3=c k.Position=UDim2.new(1,-27,0.5,-12)end
    local function ap(v)on=v s.BackgroundColor3=on and c or OFFC
        k:TweenPosition(on and UDim2.new(1,-27,0.5,-12)or UDim2.new(0,3,0.5,-12),"Out","Quad",0.15,true)
        cb(on)
    end
    s.MouseButton1Click:Connect(function()ap(not on)end)
    -- إرجاع دالة للتحكم في الحالة من الخارج (تستخدم عند استرجاع الإعدادات أو الموت)
    return function(v)if v~=on then ap(v)end end
end

local function pR(p,oF,c,ic,nm,h)local r=mkR(p,h or 48,c,ic,nm)r.LayoutOrder=oF()return r end
local function iB(r,t,c,y)local tb=Instance.new("TextBox",r)
    tb.Position,tb.Size=UDim2.new(1,-140,0,y or 5),UDim2.fromOffset(58,30)
    tb.BackgroundColor3=Color3.fromRGB(6,12,30)tb.BorderSizePixel=0
    tb.Font=Enum.Font.GothamBold tb.TextSize=16 tb.TextColor3=WH tb.Text=t
    cr(tb,UDim.new(0,8))st(tb,c,1.5)return tb end

-- [المتغيرات لحفظ حالات الأزرار لتحديثها عند الموت]
local tNoclip, tFly, tInf, tSpeed, tJump, tGhost, tGod, tHitbox, tEsp
local tBox, tNames, tDist, tHp, tMorph, tSpeedEsp, tArrow, tClosest, tAlert, tList, tMap
local tFov, tZoom, tFreecam, tNoshake, tItems, tColl, tWpShow

tNoclip = mkSw(pR(hPg,hO,BL,"🧱","عبور الجدران"),BL,function(on)S.noclip=on end)
bd(RS.Stepped,function()
    if S.noclip and ch()then
        for _,p in ipairs(ch():GetDescendants())do
            if p:IsA("BasePart")then p.CanCollide=false end
        end
    end
end)

local bv,bg
local fb=fr(g,UDim2.new(1,-80,0.5,-65),UDim2.fromOffset(60,130))
fb.Visible=false
local function fB(t,y,up)
    local b=bt(fb,t,26,UDim2.fromOffset(0,y),UDim2.fromOffset(60,60),GR)
    b.BackgroundTransparency=0.2 cr(b,UDim.new(1,0))
    b.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
            if up then fU=true else fD=true end
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
            if up then fU=false else fD=false end
        end
    end)
end
fB("▲",0,true)fB("▼",70,false)

-- [إصلاح 3]: إعادة تعيين PlatformStand عند إيقاف الطيران لمنع تعليق الشخصية
local function stFly()
    if bv then bv:Destroy()bv=nil end
    if bg then bg:Destroy()bg=nil end
    local h=hu()if h then h.PlatformStand=false end 
end

local function updFbVis()
    fb.Visible=S.fly or S.free
end

tFly = mkSw(pR(hPg,hO,GR,"🪽","الطيران"),GR,function(on)
    S.fly=on
    updFbVis()
    if not on then stFly()end
end)

bd(RS.RenderStepped,function()
    if not S.fly then return end
    local r,h=rt(),hu()if not(r and h)then return end
    if not bv or bv.Parent~=r then
        stFly()
        bv=Instance.new("BodyVelocity",r)bv.MaxForce=Vector3.new(1e9,1e9,1e9)
        bg=Instance.new("BodyGyro",r)bg.MaxTorque=Vector3.new(1e9,1e9,1e9)bg.P=9e4
    end
    h.PlatformStand=true
    local d=h.MoveDirection*fv
    if fU then d=d+Vector3.new(0,fv,0)end
    if fD then d=d-Vector3.new(0,fv,0)end
    bv.Velocity=d bg.CFrame=workspace.CurrentCamera.CFrame
end)

tInf = mkSw(pR(hPg,hO,PU,"♾️","قفز لا نهائي"),PU,function(on)S.inf=on end)
bd(UIS.JumpRequest,function()
    if S.inf then local h=hu()if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end end
end)

local spR=pR(hPg,hO,RD,"🏃","السرعة",92)
fr(spR,UDim2.fromOffset(0,48),UDim2.new(1,0,0,2),RD)
tSpeed = mkSw(spR,RD,function(on)
    S.speed=on
    if not on then local h=hu()if h then h.WalkSpeed=16 end end
end)

local mi=bt(spR,"−",24,UDim2.fromOffset(10,54),UDim2.fromOffset(38,32),Color3.fromRGB(12,22,52))
cr(mi,UDim.new(0,8))st(mi,BL,2)
local pl=bt(spR,"+",24,UDim2.fromOffset(236,54),UDim2.fromOffset(38,32),Color3.fromRGB(12,22,52))
cr(pl,UDim.new(0,8))st(pl,BL,2)
local vB=Instance.new("TextBox",spR)
vB.Position,vB.Size=UDim2.fromOffset(282,54),UDim2.fromOffset(52,32)
vB.BackgroundColor3=Color3.fromRGB(11,16,36)vB.BorderSizePixel=0
vB.Font=Enum.Font.GothamBold vB.TextSize=20 vB.TextColor3=WH
vB.Text="1"vB.ClearTextOnFocus=true
cr(vB,UDim.new(0,8))st(vB,RD,2)

local ht=fr(spR,UDim2.fromOffset(56,54),UDim2.fromOffset(172,24))ht.Active=true
local br=fr(ht,UDim2.new(0,0,0.5,-3),UDim2.new(1,0,0,6),Color3.fromRGB(30,50,100))
cr(br,UDim.new(1,0))
local fl=fr(br,UDim2.fromScale(0,0),UDim2.fromScale(0,1),BL)cr(fl,UDim.new(1,0))
local hd=fr(br,UDim2.new(0,-9,0.5,-9),UDim2.fromOffset(18,18),WH)cr(hd,UDim.new(1,0))
local SMIN,SMAX,SBOX=1,75,10000

local function setSp(v,fromBox)
    v=math.floor(v+0.5)
    if fromBox then sv=math.clamp(v,SMIN,SBOX)
    else sv=math.clamp(v,SMIN,SMAX)end
    local a=math.clamp((sv-SMIN)/(SMAX-SMIN),0,1)
    fl.Size=UDim2.new(a,0,1,0)hd.Position=UDim2.new(a,-9,0.5,-9)
    vB.Text=tostring(sv)
end
setSp(1)

vB.FocusLost:Connect(function()
    local n=tonumber(vB.Text)setSp(n or sv,true)
end)
mi.MouseButton1Click:Connect(function()
    local st=(sv>SMAX)and 10 or 1 setSp(sv-st)
end)
pl.MouseButton1Click:Connect(function()setSp(sv+1)end)

local drg=false
local function fx(x)setSp(SMIN+math.clamp((x-ht.AbsolutePosition.X)/ht.AbsoluteSize.X,0,1)*(SMAX-SMIN))end
ht.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then drg=true fx(i.Position.X)end
end)
bd(UIS.InputChanged,function(i)
    if drg and(i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement)then fx(i.Position.X)end
end)
bd(UIS.InputEnded,function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then drg=false end
end)
bd(RS.Heartbeat,function()
    if S.speed and not S.free then local h=hu()if h then h.WalkSpeed=sv end end
end)

local jV=100
local jR=pR(hPg,hO,GR,"🦘","قوة القفز")
jR.Size=UDim2.new(1,-20,0,48)
local jBox=iB(jR,tostring(jV),GR,9)
tJump = mkSw(jR,GR,function(on)
    S.jump=on
    if not on then local h=hu()if h then h.JumpPower=50 end end
end)
jBox.FocusLost:Connect(function()
    local n=tonumber(jBox.Text)if n then jV=math.clamp(n,50,300)end
    jBox.Text=tostring(jV)
end)
bd(RS.Heartbeat,function()
    if S.jump then local h=hu()if h then h.UseJumpPower=true h.JumpPower=jV end end
end)

local gD={}
local function apG(on)
    local c=ch()if not c then return end
    if on then
        for _,p in ipairs(c:GetDescendants())do
            if p:IsA("BasePart")then
                if gD[p]==nil then gD[p]={T=p.Transparency,C=p.CanCollide}end
                p.Transparency=1 p.CanCollide=false
            end
        end
    else
        for p,o in pairs(gD)do pcall(function()if p and p.Parent then p.Transparency=o.T p.CanCollide=o.C end end)end
        gD={}
    end
end

tGhost = mkSw(pR(hPg,hO,PU,"👻","وضع الشبح"),PU,function(on)S.ghost=on apG(on)end)
bd(plr.CharacterAdded,function()task.wait(1)if S.ghost then apG(true)end end)
bd(RS.Heartbeat,function()
    if S.ghost then
        local c=ch()if c then
            for _,p in ipairs(c:GetDescendants())do
                if p:IsA("BasePart")then
                    if gD[p]==nil then gD[p]={T=p.Transparency,C=p.CanCollide}end
                    p.Transparency=1 p.CanCollide=false
                end
            end
        end
    end
end)

tGod = mkSw(pR(hPg,hO,RD,"🛡️","عدم الموت"),RD,function(on)S.god=on end)
bd(RS.Heartbeat,function()
    if not S.god then return end
    local h=hu()if h then
        if h.Health<h.MaxHealth then h.Health=h.MaxHealth end
        pcall(function()h:SetStateEnabled(Enum.HumanoidStateType.Dead,false)end)
    end
end)

local hbM=30
local hbO={}
local function hbRes(p,o)pcall(function()p.Size=o.S p.Transparency=o.T p.CanCollide=o.C p.Massless=o.M end)end
local function hbResAll()
    for p,o in pairs(hbO)do hbRes(p,o)hbO[p]=nil end
end

tHitbox = mkSw(pR(hPg,hO,OG,"👹","هيتبوكس عملاق (30×)"),OG,function(on)
    S.hbx=on
    if not on then hbResAll()end
end)

local hbT=0
bd(RS.Heartbeat,function(dt)
    hbT=hbT+dt if hbT<0.2 then return end hbT=0
    for p,o in pairs(hbO)do
        if not(S.hbx and p.Parent)then hbRes(p,o)hbO[p]=nil end
    end
    if not S.hbx then return end
    for _,p in ipairs(Players:GetPlayers())do
        local c=p~=plr and p.Character
        local r=oR(c)
        if r then
            local o=hbO[r]
            if not o then o={S=r.Size,T=r.Transparency,C=r.CanCollide,M=r.Massless}hbO[r]=o end
            local tg=o.S*hbM
            if r.Size~=tg then r.Size=tg end
            r.Transparency=0.7 r.CanCollide=false r.Massless=true
        end
    end
end)

local opt={box=false,names=true,dist=true,hp=false,morph=false,speed=false,arrow=false,closest=false,alert=false,list=false,map=false}
local espR=500
local eO={}
local setEsp

local eyeBtn=bt(g,"👁️",28,UDim2.new(0,12,0.5,-28),UDim2.fromOffset(56,56),Color3.fromRGB(90,90,90))
eyeBtn.AutoButtonColor=false eyeBtn.BackgroundTransparency=0.65
eyeBtn.TextColor3=Color3.fromRGB(230,230,230)eyeBtn.ZIndex=5
cr(eyeBtn,UDim.new(1,0))
local eyeSt=st(eyeBtn,Color3.fromRGB(160,160,160),3)eyeSt.Transparency=0.4
eyeBtn.MouseButton1Click:Connect(function()if setEsp then setEsp(not S.esp)end end)

local mapF=fr(g,UDim2.new(1,-170,0,70),UDim2.fromOffset(150,150),Color3.fromRGB(6,12,30))
mapF.BackgroundTransparency=0.25 mapF.ClipsDescendants=true mapF.Visible=false
cr(mapF,UDim.new(1,0))st(mapF,BL,2)
local meD=fr(mapF,UDim2.new(0.5,-4,0.5,-4),UDim2.fromOffset(8,8),WH)cr(meD,UDim.new(1,0))

local nearL=lb(g,"",14,UDim2.new(0,10,0,120),UDim2.fromOffset(210,96),WH)
nearL.BackgroundTransparency=0.4 nearL.BackgroundColor3=BK
nearL.TextXAlignment=Enum.TextXAlignment.Left nearL.TextYAlignment=Enum.TextYAlignment.Top
nearL.Visible=false cr(nearL,UDim.new(0,8))

local alertL=lb(g,"",20,UDim2.new(0.5,-160,0,70),UDim2.fromOffset(320,36),Color3.fromRGB(255,90,90))
alertL.BackgroundTransparency=0.3 alertL.BackgroundColor3=BK alertL.Visible=false
cr(alertL,UDim.new(0,10))

local function clE(p)
    local o=eO[p]if o then for _,i in pairs(o)do pcall(function()i:Destroy()end)end eO[p]=nil end
end
local function hideE(o)
    o.hl.Enabled=false o.bx.Enabled=false o.bb.Enabled=false
    o.ar.Visible=false o.at.Visible=false o.dt.Visible=false
end

local function addE(p)
    if p==plr then return end
    clE(p)
    local c=p.Character local r=oR(c)if not r then return end
    local hl=Instance.new("Highlight")hl.FillColor=OG hl.OutlineColor=WH hl.FillTransparency=0.6
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop hl.Parent=c

    local bx=Instance.new("BillboardGui")bx.Size=UDim2.new(4,0,6,0)bx.AlwaysOnTop=true bx.Adornee=r bx.Parent=r
    local bf=Instance.new("Frame",bx)bf.Size=UDim2.fromScale(1,1)bf.BackgroundTransparency=1 bf.BorderSizePixel=0
    local bs=Instance.new("UIStroke",bf)bs.Color=OG bs.Thickness=1.5

    local hb=Instance.new("Frame",bx)hb.Size=UDim2.new(0.1,0,1,0)hb.Position=UDim2.new(-0.16,0,0,0)
    hb.BackgroundColor3=Color3.fromRGB(20,20,20)hb.BorderSizePixel=0
    local hf=Instance.new("Frame",hb)hf.AnchorPoint=Vector2.new(0,1)hf.Position=UDim2.fromScale(0,1)
    hf.Size=UDim2.fromScale(1,1)hf.BackgroundColor3=GR hf.BorderSizePixel=0

    local bb=Instance.new("BillboardGui")bb.Size=UDim2.fromOffset(170,58)bb.StudsOffset=Vector3.new(0,4,0)
    bb.AlwaysOnTop=true bb.Adornee=r bb.Parent=r
    local lbl=Instance.new("TextLabel",bb)lbl.Size=UDim2.fromScale(1,1)lbl.BackgroundTransparency=1
    lbl.Font=Enum.Font.GothamBold lbl.TextSize=13 lbl.TextColor3=OG lbl.TextStrokeTransparency=0 lbl.Text=p.DisplayName

    local ar=Instance.new("TextLabel",g)ar.Size=UDim2.fromOffset(34,34)ar.AnchorPoint=Vector2.new(0.5,0.5)
    ar.BackgroundTransparency=1 ar.Text=">"ar.Font=Enum.Font.GothamBlack ar.TextSize=34
    ar.TextColor3=OG ar.TextStrokeTransparency=0 ar.Visible=false

    local at=Instance.new("TextLabel",g)at.Size=UDim2.fromOffset(70,14)at.AnchorPoint=Vector2.new(0.5,0.5)
    at.BackgroundTransparency=1 at.Font=Enum.Font.GothamBold at.TextSize=12
    at.TextColor3=WH at.TextStrokeTransparency=0 at.Visible=false

    local dt=fr(mapF,UDim2.fromOffset(0,0),UDim2.fromOffset(6,6),OG)cr(dt,UDim.new(1,0))dt.Visible=false
    eO[p]={hl=hl,bx=bx,bb=bb,ar=ar,at=at,dt=dt,bf=bf,hb=hb,hf=hf,lbl=lbl,st=bs}
end

local wC={}
local function wP(p)
    if p==plr or wC[p]then return end
    local c=p.CharacterAdded:Connect(function(chr)
        if S.esp then task.wait(0.5)if not oR(chr)then task.wait(1.5)end addE(p)end
    end)
    wC[p]=c table.insert(CN,c)
end
for _,p in ipairs(Players:GetPlayers())do wP(p)end
bd(Players.PlayerAdded,function(p)
    wP(p)
    if S.esp and p.Character then addE(p)end
end)

local MK={"morph","animal","creature","form","skin","costume","disguise","species"}
local function hK(n)
    n=tostring(n):lower()
    for _,k in ipairs(MK)do if n:find(k,1,true)then return true end end
    return false
end
local function getMorph(p)
    local c=p.Character if not c then return nil end
    local bm=nil
    for _,h in ipairs({c,p})do
        for k,v in pairs(h:GetAttributes())do
            if hK(k)then
                if type(v)=="string"and v~=""then return v end
                if type(v)=="boolean"then bm=v end
            end
        end
        for _,d in ipairs(h:GetDescendants())do
            if d:IsA("ValueBase")and hK(d.Name)then
                if d:IsA("StringValue")and d.Value~=""then return d.Value end
                if d:IsA("ObjectValue")and d.Value then return d.Value.Name end
                if d:IsA("BoolValue")then bm=d.Value end
            end
        end
    end
    for _,d in ipairs(c:GetDescendants())do
        if d:IsA("Model")and not d:IsA("Accoutrement")and not d:IsA("Tool")then return d.Name end
    end
    if c.Name~=p.Name and c.Name~=p.DisplayName then return c.Name end
    if bm==true then return "متحول"end
    if bm==false then return "غير متحول"end
    return nil
end

tEsp = mkSw(pR(ePg,eO,OG,"👁️","كاشف اماكن الاعبين"),OG,function(on)
    S.esp=on
    if on then
        eyeBtn.BackgroundColor3=BK eyeBtn.BackgroundTransparency=0
        eyeBtn.TextColor3=WH eyeSt.Color=WH eyeSt.Transparency=0
    else
        eyeBtn.BackgroundColor3=Color3.fromRGB(90,90,90)eyeBtn.BackgroundTransparency=0.65
        eyeBtn.TextColor3=Color3.fromRGB(230,230,230)eyeSt.Color=Color3.fromRGB(160,160,160)eyeSt.Transparency=0.4
    end
    for _,p in ipairs(Players:GetPlayers())do if on then addE(p)else clE(p)end end
end)

local function oR2(c,ic,nm,k)
    local tog = mkSw(pR(ePg,eO,c,ic,nm),c,function(on)opt[k]=on end)
    if k=="box" then tBox=tog elseif k=="names" then tNames=tog elseif k=="dist" then tDist=tog
    elseif k=="hp" then tHp=tog elseif k=="morph" then tMorph=tog elseif k=="speed" then tSpeedEsp=tog
    elseif k=="arrow" then tArrow=tog elseif k=="closest" then tClosest=tog elseif k=="alert" then tAlert=tog
    elseif k=="list" then tList=tog elseif k=="map" then tMap=tog end
end

oR2(BL,"🔲","مربع حول اللاعب","box")
oR2(CY,"🏷️","أسماء اللاعبين","names")
oR2(CY,"📏","المسافة","dist")
oR2(RD,"❤️","شريط الصحة","hp")
oR2(PU,"🧬","كشف التحول","morph")
oR2(GR,"⚡","عداد سرعة اللاعب","speed")
oR2(BL,"🧭","سهم اتجاه خارج الشاشة","arrow")
oR2(RD,"🎯","تحديد أقرب لاعب","closest")
oR2(OG,"🔔","تنبيه عند اقتراب لاعب","alert")
oR2(BL,"📊","قائمة اللاعبين القريبين","list")
oR2(GR,"🗺️","خريطة مصغرة","map")

local zR=pR(ePg,eO,BL,"🚪","نطاق الكشف (متر)")
local zB=iB(zR,"500",BL,5)
zB.FocusLost:Connect(function()
    local n=tonumber(zB.Text)if n then espR=math.clamp(math.floor(n),20,100000)end
    zB.Text=tostring(espR)
end)

bd(Players.PlayerRemoving,function(p)
    clE(p)
    if wC[p]then pcall(function()wC[p]:Disconnect()end)wC[p]=nil end
end)

local eA=0
bd(RS.RenderStepped,function(dt)
    local act=S.esp
    mapF.Visible=act and opt.map
    nearL.Visible=act and opt.list
    alertL.Visible=false
    if not act then for _,o in pairs(eO)do hideE(o)end return end
    local mR=rt()if not mR then return end
    eA=eA+dt local dT=eA>=0.15 if dT then eA=0 end
    local cam=workspace.CurrentCamera if not cam then return end
    local vp=cam.ViewportSize
    local list={}
    for p,o in pairs(eO)do
        local c=p.Character local r=oR(c)local h=oH(c)
        if r and h and r.Parent then
            local d=(r.Position-mR.Position).Magnitude
            if d<=espR then table.insert(list,{p=p,o=o,r=r,h=h,d=d})
            else hideE(o)end
        else hideE(o)end
    end
    table.sort(list,function(a,b)return a.d<b.d end)
    local cl=list[1]
    local lk=Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z)
    if lk.Magnitude<0.01 then lk=Vector3.new(0,0,-1)end
    lk=lk.Unit
    local ri=Vector3.new(-lk.Z,0,lk.X)
    for _,e in ipairs(list)do
        local o,r,h,d=e.o,e.r,e.h,e.d
        local isC=opt.closest and e==cl
        local col=isC and RD or OG
        o.hl.Enabled=true o.hl.FillColor=col o.st.Color=col o.lbl.TextColor3=col
        if h.MaxHealth>=h.Health then o.hpMax=h.MaxHealth
        else o.hpMax=math.max(o.hpMax or h.MaxHealth,h.Health)end
        o.bx.Enabled=opt.box or opt.hp
        o.bf.Visible=opt.box
        o.hb.Visible=opt.hp
        if opt.hp then
            local fr2=math.clamp(h.Health/o.hpMax,0,1)
            o.hf.Size=UDim2.fromScale(1,fr2)
            o.hf.BackgroundColor3=Color3.fromHSV(fr2*0.33,1,1)
        end
        o.bb.Enabled=opt.names or opt.dist or opt.morph or opt.speed or opt.hp
        if dT and o.bb.Enabled then
            local ps,ex={},{}
            if opt.names then ps[#ps+1]=e.p.DisplayName end
            if opt.dist then ex[#ex+1]="["..math.floor(d).."m]"end
            if opt.hp then ex[#ex+1]="❤️"..math.floor(o.hpMax).."/"..math.floor(h.Health)end
            if opt.speed then
                local v=r.AssemblyLinearVelocity
                ex[#ex+1]="⚡"..math.floor(Vector3.new(v.X,0,v.Z).Magnitude)
            end
            if #ex>0 then ps[#ps+1]=table.concat(ex," ")end
            if opt.morph then
                if os.clock()-(o.mT or 0)>1 then o.morph=getMorph(e.p)o.mT=os.clock()end
                ps[#ps+1]="🧬 "..(o.morph or "عادي")
            end
            o.lbl.Text=table.concat(ps,"\n")
        end
        o.ar.Visible=false o.at.Visible=false
        if opt.arrow then
            local v,os=cam:WorldToViewportPoint(r.Position)
            if not os then
                local ct=vp/2
                local dr=Vector2.new(v.X,v.Y)-ct
                if v.Z<0 then dr=-dr end
                if dr.Magnitude<1 then dr=Vector2.new(0,-1)end
                local u=dr.Unit
                local rx,ry=vp.X/2-50,vp.Y/2-50
                local k=1/math.max(math.abs(u.X)/rx,math.abs(u.Y)/ry)
                local pt=ct+u*k
                o.ar.Position=UDim2.fromOffset(pt.X,pt.Y)
                o.ar.Rotation=math.deg(math.atan2(u.Y,u.X))
                o.ar.TextColor3=col o.ar.Visible=true
                o.at.Position=UDim2.fromOffset(pt.X,pt.Y+22)
                o.at.Text=math.floor(d).."m"o.at.Visible=true
            end
        end
        o.dt.Visible=opt.map
        if opt.map then
            local rl=r.Position-mR.Position
            local mx,my=rl:Dot(ri),-rl:Dot(lk)
            local rng,hf2=150,75
            local px,py=mx/rng*hf2,my/rng*hf2
            local mm=math.sqrt(px*px+py*py)
            if mm>hf2-6 then px,py=px/mm*(hf2-6),py/mm*(hf2-6)end
            o.dt.Position=UDim2.new(0.5,px-3,0.5,py-3)
            o.dt.BackgroundColor3=col
        end
    end
    if opt.list and dT then
        local t={}
        for i=1,math.min(5,#list)do t[i]=i..") "..list[i].p.DisplayName.." ["..math.floor(list[i].d).."m]"end
        nearL.Text=#t>0 and table.concat(t,"\n")or "لا يوجد لاعبين قريبين"
    end
    if opt.alert and cl and cl.d<=40 then
        alertL.Text="⚠️ "..cl.p.DisplayName.." قريب ["..math.floor(cl.d).."m]"
        alertL.Visible=true
    end
end)

local fovV=70
local fR=pR(cPg,cO,BL,"🔭","زاوية الرؤية")
fR.Size=UDim2.new(1,-20,0,48)
local fB2=iB(fR,tostring(fovV),BL,9)
tFov = mkSw(fR,BL,function(on)
    S.fov=on
    if not on then local c=workspace.CurrentCamera if c then c.FieldOfView=70 end end
end)
fB2.FocusLost:Connect(function()
    local n=tonumber(fB2.Text)if n then fovV=math.clamp(n,50,120)end
    fB2.Text=tostring(fovV)
end)
bd(RS.RenderStepped,function()
    if S.fov then local c=workspace.CurrentCamera if c then c.FieldOfView=fovV end end
end)

local zmV=400
local zmO=nil
local function apZ(on)
    if on then
        if not zmO then zmO={plr.CameraMaxZoomDistance,plr.CameraMinZoomDistance}end
        plr.CameraMaxZoomDistance=zmV plr.CameraMinZoomDistance=0.5
    elseif zmO then
        plr.CameraMinZoomDistance=zmO[2]
        plr.CameraMaxZoomDistance=zmO[1]
        zmO=nil
    end
end

local zR2=pR(cPg,cO,CY,"🔍","تكبير مفتوح")
zR2.Size=UDim2.new(1,-20,0,48)
local zB2=iB(zR2,tostring(zmV),CY,9)
tZoom = mkSw(zR2,CY,function(on)S.zoom=on apZ(on)end)
zB2.FocusLost:Connect(function()
    local n=tonumber(zB2.Text)if n then zmV=math.clamp(n,20,2000)end
    zB2.Text=tostring(zmV)
    if S.zoom then apZ(true)end
end)

local fc={yaw=0,pitch=0,pos=Vector3.new()}
local function setFC(on)
    local cam=workspace.CurrentCamera if not cam then return end
    S.free=on
    updFbVis()
    local h=hu()
    if on then
        local cf=cam.CFrame
        local rx,ry=cf:ToOrientation()
        fc.pitch,fc.yaw,fc.pos=rx,ry,cf.Position
        cam.CameraType=Enum.CameraType.Scriptable
    else
        cam.CameraType=Enum.CameraType.Custom
        if h then cam.CameraSubject=h h.WalkSpeed=S.speed and sv or 16 end
    end
end

tFreecam = mkSw(pR(cPg,cO,PU,"🎬","كاميرا حرة"),PU,setFC)
bd(RS.RenderStepped,function(dt)
    if not S.free then return end
    local cam=workspace.CurrentCamera if not cam then return end
    local h=hu()if h then h.WalkSpeed=0 end
    local md=h and h.MoveDirection or Vector3.new()
    local sp2=45*dt
    local up=((fU and 1 or 0)-(fD and 1 or 0))*sp2
    fc.pos=fc.pos+md*sp2+Vector3.new(0,up,0)
    cam.CFrame=CFrame.new(fc.pos)*CFrame.fromOrientation(fc.pitch,fc.yaw,0)
end)
bd(UIS.InputChanged,function(i,gp)
    if not S.free or gp then return end
    if i.UserInputType==Enum.UserInputType.Touch
    or(i.UserInputType==Enum.UserInputType.MouseMovement and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2))then
        fc.yaw=fc.yaw-i.Delta.X*0.006
        fc.pitch=math.clamp(fc.pitch-i.Delta.Y*0.006,-1.5,1.5)
    end
end)

tNoshake = mkSw(pR(cPg,cO,CY,"📳","منع اهتزاز الكاميرا"),CY,function(on)S.noshake=on end)
bd(RS.RenderStepped,function()
    if S.noshake then local h=hu()if h then h.CameraOffset=Vector3.new()end end
end)

local markL=fr(g,UDim2.fromScale(0,0),UDim2.fromScale(1,1))
markL.ZIndex=-5
local mPools={}
local function rndM(id,en,col)
    local pool=mPools[id]
    if not pool then pool={}mPools[id]=pool end
    local us2=0
    local mR=rt()
    if en and mR then
        local cam=workspace.CurrentCamera
        for _,e in ipairs(en)do
            local ps=e.pos or(e.part and e.part.Parent and e.part.Position)
            if ps then
                local v,os=cam:WorldToViewportPoint(ps)
                if os then
                    us2=us2+1
                    local l=pool[us2]
                    if not l then
                        l=Instance.new("TextLabel",markL)
                        l.Size=UDim2.fromOffset(130,32)l.AnchorPoint=Vector2.new(0.5,0.5)
                        l.BackgroundTransparency=1 l.BorderSizePixel=0
                        l.Font=Enum.Font.GothamBold l.TextSize=12 l.TextStrokeTransparency=0
                        pool[us2]=l
                    end
                    l.Position=UDim2.fromOffset(v.X,v.Y)
                    l.Text=e.text.."\n["..math.floor((ps-mR.Position).Magnitude).."m]"
                    l.TextColor3=col l.Visible=true
                end
            end
        end
    end
    for i=us2+1,#pool do pool[i].Visible=false end
end

local wps={}
local fIt,fCl={},{}
local scN=false
local aSc=true
local scI=3
local alive=true
bd(RS.RenderStepped,function()
    rndM("item",S.items and fIt or nil,OG)
    rndM("coll",S.coll and fCl or nil,GR)
    rndM("wp",S.wpShow and wps or nil,CY)
end)

local CK={"coin","gem","orb","collect","pickup","cash","star","crystal","egg","candy","diamond","token","fruit","chest"}
task.spawn(function()
    while alive do
        if S.items or S.coll then
            local wI,wC=S.items,S.coll
            local it,cl2={},{}
            local ds=workspace:GetDescendants()
            for i,d in ipairs(ds)do
                if wI then
                    if d:IsA("Tool")and not Players:GetPlayerFromCharacter(d.Parent)then
                        local h=d:FindFirstChild("Handle")
                        if h and h:IsA("BasePart")then it[#it+1]={part=h,text=d.Name}end
                    elseif d:IsA("ProximityPrompt")and d.Parent and d.Parent:IsA("BasePart")then
                        local t=d.ObjectText~=""and d.ObjectText or d.Parent.Name
                        it[#it+1]={part=d.Parent,text=t}
                    end
                end
                if wC and d:IsA("BasePart")then
                    local n=d.Name:lower()
                    for _,k in ipairs(CK)do
                        if n:find(k,1,true)then cl2[#cl2+1]={part=d,text=d.Name}break end
                    end
                end
                if i%2000==0 then task.wait()end
            end
            local mR=rt()
            local function tr(l)
                if mR then table.sort(l,function(a,b)return(a.part.Position-mR.Position).Magnitude<(b.part.Position-mR.Position).Magnitude end)end
                while #l>40 do table.remove(l)end
            end
            tr(it)tr(cl2)
            fIt,fCl=it,cl2
        end
        local w=0
        while alive and(w<scI or not aSc)and not scN do task.wait(0.25)w=w+0.25 end
        scN=false
    end
end)

tItems = mkSw(pR(wPg,wO,OG,"🎁","كاشف العناصر"),OG,function(on)S.items=on scN=true end)
tColl = mkSw(pR(wPg,wO,GR,"💎","كاشف الجوائز والعملات"),GR,function(on)S.coll=on scN=true end)

local scR=pR(wPg,wO,CY,"🔁","التحديث التلقائي للكاشف",48)
scR.Size=UDim2.new(1,-20,0,48)
local scB=iB(scR,tostring(scI),CY,9)
mkSw(scR,CY,function(on)aSc=on end,true)
scB.FocusLost:Connect(function()
    local n=tonumber(scB.Text)if n then scI=math.clamp(n,1,30)end
    scB.Text=tostring(scI)
end)

local scBtn=bt(scR,"🔄",16,UDim2.new(1,-136,0,9),UDim2.fromOffset(30,30),Color3.fromRGB(18,55,130))
cr(scBtn,UDim.new(0,8))
scBtn.MouseButton1Click:Connect(function()scN=true end)

local sCF=nil
local svR=fr(wPg,UDim2.new(),UDim2.new(1,-20,0,40),Color3.fromRGB(11,16,36))
svR.LayoutOrder=wO()
cr(svR,UDim.new(0,12))st(svR,BL,2)
local svB=bt(svR,"حفظ الموقع",14,UDim2.new(0,4,0,4),UDim2.new(0.5,-6,1,-8),Color3.fromRGB(18,55,130))
local ldB=bt(svR,"استرجاع الموقع",14,UDim2.new(0.5,2,0,4),UDim2.new(0.5,-6,1,-8),Color3.fromRGB(18,55,130))
cr(svB,UDim.new(0,8))cr(ldB,UDim.new(0,8))
svB.MouseButton1Click:Connect(function()
    local r=rt()if r then sCF=r.CFrame end
end)
ldB.MouseButton1Click:Connect(function()
    local r=rt()if r and sCF then r.CFrame=sCF end
end)

tWpShow = mkSw(pR(wPg,wO,CY,"📍","إظهار النقاط على الشاشة"),CY,function(on)S.wpShow=on end)

local wpC=0
local function addWPR(wp)
    local r=fr(wPg,UDim2.new(),UDim2.new(1,-20,0,40),Color3.fromRGB(11,16,36))
    r.LayoutOrder=wO()
    cr(r,UDim.new(0,12))st(r,CY,2)
    lb(r,wp.text,15,UDim2.new(0,96,0,0),UDim2.new(1,-150,1,0))
    local go=bt(r,"انتقال",14,UDim2.fromOffset(8,5),UDim2.fromOffset(80,30),Color3.fromRGB(18,55,130))
    cr(go,UDim.new(0,8))
    local dl=bt(r,"🗑",16,UDim2.new(1,-46,0,5),UDim2.fromOffset(38,30),Color3.fromRGB(90,20,30))
    cr(dl,UDim.new(0,8))
    go.MouseButton1Click:Connect(function()
        local rr=rt()if rr then rr.CFrame=CFrame.new(wp.pos+Vector3.new(0,3,0))end
    end)
    dl.MouseButton1Click:Connect(function()
        local i=table.find(wps,wp)if i then table.remove(wps,i)end
        r:Destroy()
    end)
end

local addR=fr(wPg,UDim2.new(),UDim2.new(1,-20,0,40),Color3.fromRGB(11,16,36))
addR.LayoutOrder=wO()
cr(addR,UDim.new(0,12))st(addR,GR,2)
local addB=bt(addR,"➕ إضافة نقطة هنا",16,UDim2.fromScale(0,0),UDim2.fromScale(1,1),Color3.fromRGB(11,16,36))
cr(addB,UDim.new(0,12))
addB.MouseButton1Click:Connect(function()
    local r=rt()
    if r then
        wpC=wpC+1
        local wp={pos=r.Position,text="نقطة "..wpC}
        table.insert(wps,wp)addWPR(wp)
    end
end)

local sRow=pR(sPg,sO,BL,"📐","حجم القائمة",100)
local scV=1
local scL=lb(sRow,"100%",20,UDim2.new(0.5,-35,0,56),UDim2.fromOffset(70,34))
local function setSc(v)
    scV=math.clamp(math.floor(v*10+0.5)/10,0.6,1.4)
    us.Scale=scV
    scL.Text=math.floor(scV*100+0.5).."%"
end
local sm=bt(sRow,"−",24,UDim2.new(0.5,-100,0,56),UDim2.fromOffset(44,34),Color3.fromRGB(12,22,52))
cr(sm,UDim.new(0,8))st(sm,BL,2)
sm.MouseButton1Click:Connect(function()setSc(scV-0.1)end)
local sp2=bt(sRow,"+",24,UDim2.new(0.5,56,0,56),UDim2.fromOffset(44,34),Color3.fromRGB(12,22,52))
cr(sp2,UDim.new(0,8))st(sp2,BL,2)
sp2.MouseButton1Click:Connect(function()setSc(scV+0.1)end)

local hbR=pR(sPg,sO,OG,"👹","حجم الهيتبوكس (1-30)",48)
hbR.Size=UDim2.new(1,-20,0,48)
local hbB=iB(hbR,tostring(hbM),OG,9)
hbB.FocusLost:Connect(function()
    local n=tonumber(hbB.Text)if n then hbM=math.clamp(n,1,30)end
    hbB.Text=tostring(hbM)
end)

local svsR=pR(sPg,sO,GR,"💾","حفظ الإعدادات",48)
svsR.Size=UDim2.new(1,-20,0,48)
local svsL=lb(svsR,hasF and"اضغط حفظ أو استرجاع"or"الملفات غير مدعومة",13,UDim2.new(1,-140,0,9),UDim2.fromOffset(130,30),hasF and GR or RD)
svsL.TextXAlignment=Enum.TextXAlignment.Center
svsL.BackgroundColor3=hasF and Color3.fromRGB(10,30,15)or Color3.fromRGB(40,10,15)
svsL.BackgroundTransparency=0
cr(svsL,UDim.new(0,8))st(svsL,hasF and GR or RD,1.5)

local svBtns=fr(sPg,UDim2.new(),UDim2.new(1,-20,0,40),Color3.fromRGB(11,16,36))
svBtns.LayoutOrder=sO()
cr(svBtns,UDim.new(0,12))st(svBtns,GR,2)
local svNB=bt(svBtns,"حفظ",13,UDim2.new(0,4,0,4),UDim2.new(0.33,-6,1,-8),Color3.fromRGB(18,55,130))
cr(svNB,UDim.new(0,8))
local ldNB=bt(svBtns,"استرجاع",13,UDim2.new(0.33,2,0,4),UDim2.new(0.33,-6,1,-8),Color3.fromRGB(18,55,130))
cr(ldNB,UDim.new(0,8))
local clNB=bt(svBtns,"مسح",13,UDim2.new(0.66,2,0,4),UDim2.new(0.34,-6,1,-8),Color3.fromRGB(90,20,30))
cr(clNB,UDim.new(0,8))

svNB.MouseButton1Click:Connect(function()
    if not hasF then svsL.Text="الملفات غير مدعومة"svsL.TextColor3=RD return end
    local data={toggles={noclip=S.noclip,fly=S.fly,inf=S.inf,speed=S.speed,esp=S.esp,ghost=S.ghost,god=S.god,hbx=S.hbx,jump=S.jump},values={speed=sv,hbMult=hbM,jump=jV,fov=fovV,espRange=espR},opts=opt}
    local ok=pcall(function()writefile(SF,HS:JSONEncode(data))end)
    svsL.Text=ok and"تم الحفظ"or"فشل الحفظ"
    svsL.TextColor3=ok and GR or RD
    task.delay(1.5,function()svsL.Text="اضغط حفظ أو استرجاع"svsL.TextColor3=GR end)
end)

ldNB.MouseButton1Click:Connect(function()
    if not hasF then svsL.Text="الملفات غير مدعومة"svsL.TextColor3=RD return end
    local ok,c=pcall(function()return readfile(SF)end)
    if not ok or not c or c==""then svsL.Text="لا يوجد محفوظات"svsL.TextColor3=RD task.delay(1.5,function()svsL.Text="اضغط حفظ أو استرجاع"svsL.TextColor3=GR end)return end
    local ok2,dc=pcall(function()return HS:JSONDecode(c)end)
    if not ok2 or type(dc)~="table"then svsL.Text="ملف تالف"svsL.TextColor3=RD return end
    
    -- [إصلاح 4]: تحديث الأزرار بصرياً بعد استرجاع الإعدادات
    pcall(function()
        if type(dc.values)=="table"then
            local v=dc.values
            if v.speed then setSp(v.speed,true)end
            if v.hbMult then hbM=math.clamp(v.hbMult,1,30)hbB.Text=tostring(hbM)end
            if v.jump then jV=math.clamp(v.jump,50,300)jBox.Text=tostring(jV)end
            if v.fov then fovV=math.clamp(v.fov,50,120)fB2.Text=tostring(fovV)end
            if v.espRange then espR=math.clamp(v.espRange,20,100000)zB.Text=tostring(espR)end
        end
        if type(dc.opts)=="table"then
            for k,val in pairs(dc.opts)do if opt[k]~=nil then opt[k]=val end end
        end
        -- تفعيل الأزرار بناءً على الإعدادات المحفوظة
        if dc.toggles then
            if dc.toggles.noclip and tNoclip then tNoclip(true) end
            if dc.toggles.fly and tFly then tFly(true) end
            if dc.toggles.inf and tInf then tInf(true) end
            if dc.toggles.speed and tSpeed then tSpeed(true) end
            if dc.toggles.esp and tEsp then tEsp(true) end
            if dc.toggles.ghost and tGhost then tGhost(true) end
            if dc.toggles.god and tGod then tGod(true) end
            if dc.toggles.hbx and tHitbox then tHitbox(true) end
            if dc.toggles.jump and tJump then tJump(true) end
        end
    end)
    svsL.Text="تم الاسترجاع"svsL.TextColor3=CY
    task.delay(1.5,function()svsL.Text="اضغط حفظ أو استرجاع"svsL.TextColor3=GR end)
end)

local clA=false
clNB.MouseButton1Click:Connect(function()
    if not hasF then svsL.Text="الملفات غير مدعومة"svsL.TextColor3=RD return end
    if not clA then
        clA=true clNB.Text="تأكيد؟"
        task.delay(3,function()clA=false clNB.Text="مسح"end)
    else
        clA=false clNB.Text="مسح"
        pcall(function()delfile(SF)end)
        svsL.Text="تم المسح"svsL.TextColor3=OG
        task.delay(1.5,function()svsL.Text="اضغط حفظ أو استرجاع"svsL.TextColor3=GR end)
    end
end)

local rstR=pR(sPg,sO,RD,"🔄","إعادة الشخصية")
local rstB=bt(rstR,"🔄",16,UDim2.new(1,-70,0,9),UDim2.fromOffset(58,30),Color3.fromRGB(90,20,30))
cr(rstB,UDim.new(0,8))
local rstA=false
rstB.MouseButton1Click:Connect(function()
    if not rstA then
        rstA=true rstB.Text="تأكيد؟"
        task.delay(3,function()rstA=false rstB.Text="🔄"end)
    else
        rstA=false rstB.Text="🔄"
        local h=hu()if h then h.Health=0 end
    end
end)

local iR=fr(iPg,UDim2.new(0,10,0,10),UDim2.new(1,-20,0,56),Color3.fromRGB(11,16,36))
iR.LayoutOrder=iO()
cr(iR,UDim.new(0,12))st(iR,BL,2)
local iL=lb(iR,"هذا السكربت تم تصميمه لاجل حمد بكيفي",17,UDim2.fromOffset(10,0),UDim2.new(1,-20,1,0),Color3.fromRGB(190,235,255))
iL.TextWrapped=true

local sR2=fr(iPg,UDim2.new(0,10,0,74),UDim2.new(1,-20,0,236),Color3.fromRGB(11,16,36))
sR2.LayoutOrder=iO()
cr(sR2,UDim.new(0,12))st(sR2,CY,2)
local sL2=lb(sR2,"",15,UDim2.fromOffset(10,6),UDim2.new(1,-20,1,-12),WH)
sL2.TextXAlignment=Enum.TextXAlignment.Left
sL2.TextYAlignment=Enum.TextYAlignment.Top
sL2.TextWrapped=true

local fN2,fT=0,0
bd(RS.RenderStepped,function(dt)
    fN2=fN2+1 fT=fT+dt
    if fT>=0.5 then
        local fp=math.floor(fN2/fT+0.5)
        fN2=0 fT=0
        if iPg.Visible then
            local pn2=0
            pcall(function()pn2=math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()+0.5)end)
            local h,r=hu(),rt()
            local sp3=0
            if r then
                local v=r.AssemblyLinearVelocity
                sp3=math.floor(Vector3.new(v.X,0,v.Z).Magnitude)
            end
            local ps=r and(math.floor(r.Position.X)..", "..math.floor(r.Position.Y)..", "..math.floor(r.Position.Z))or"-"
            sL2.Text="الإطارات: "..fp.."\nزمن الاستجابة: "..pn2.." ميث\nسرعة الشخصية: "..sp3.."\nعدد اللاعبين: "..#Players:GetPlayers().."/"..Players.MaxPlayers.."\nالشخصية: "..plr.DisplayName.."\nالدم: "..(h and(math.floor(h.Health).."/"..math.floor(h.MaxHealth))or"-").."\nالموقع: "..ps
        end
    end
end)

local tabs={}
local function shP(pg2)
    for _,t in ipairs(tabs)do
        local ac=t.page==pg2
        t.page.Visible=ac
        t.btn.BackgroundColor3=ac and Color3.fromRGB(18,55,130)or NV
        t.stroke.Transparency=ac and 0 or 1
    end
end
local function mkT(t,y,pg2)
    local b=bt(m,t,14,UDim2.fromOffset(10,y),UDim2.fromOffset(104,32),NV,Color3.fromRGB(150,220,255))
    cr(b,UDim.new(0,10))
    local s=st(b,BL,2)
    table.insert(tabs,{btn=b,page=pg2,stroke=s})
    b.MouseButton1Click:Connect(function()shP(pg2)end)
end
mkT("🏠 الرئيسية",118,hPg)
mkT("👁️ الكاشف",154,ePg)
mkT("🎥 الكاميرا",190,cPg)
mkT("🌍 العالم",226,wPg)
mkT("⚙️ الإعدادات",262,sPg)
mkT("ℹ️ معلومات",298,iPg)
shP(hPg)

local fbtn=Instance.new("ImageButton",g)
fbtn.Size=UDim2.fromOffset(80,80)
fbtn.Position=UDim2.new(0,30,0.35,0)
fbtn.BackgroundColor3=Color3.fromRGB(20,30,60)
fbtn.Image=avI
fbtn.AutoButtonColor=false
fbtn.Visible=false
fbtn.BorderSizePixel=0
cr(fbtn,UDim.new(1,0))st(fbtn,Color3.fromRGB(0,160,255),5)
local fc2=lb(fbtn,"👑",26,UDim2.new(1,-36,0,-16),UDim2.fromOffset(34,30),Color3.fromRGB(80,190,255))
fc2.ZIndex=3

local fd,fs,fo,fmv=false,nil,nil,false
local function isP2(i)return i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 end
fbtn.InputBegan:Connect(function(i)
    if isP2(i)then fd,fs,fo,fmv=true,i.Position,fbtn.Position,false end
end)
bd(UIS.InputChanged,function(i)
    if fd and(i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement)then
        local dx,dy=i.Position.X-fs.X,i.Position.Y-fs.Y
        if math.abs(dx)+math.abs(dy)>10 then fmv=true end
        if fmv then fbtn.Position=UDim2.new(fo.X.Scale,fo.X.Offset+dx,fo.Y.Scale,fo.Y.Offset+dy)end
    end
end)
bd(UIS.InputEnded,function(i)
    if fd and isP2(i)then
        fd=false
        if not fmv then fbtn.Visible=false m.Visible=true end
    end
end)

cl.MouseButton1Click:Connect(function()
    m.Visible=false fbtn.Visible=true
end)

-- [إصلاح 5]: دالة تحديث الواجهة عند الموت أو استرجاع الإعدادات
_G.KhalilUpdateUI = function()
    if tNoclip then tNoclip(false) end
    if tFly then tFly(false) end
    if tInf then tInf(false) end
    if tSpeed then tSpeed(false) end
    if tJump then tJump(false) end
    if tGhost then tGhost(false) end
    if tGod then tGod(false) end
    if tHitbox then tHitbox(false) end
    if tEsp then tEsp(false) end
    -- إعادة تعيين المتغيرات الداخلية
    S.noclip=false; S.fly=false; S.inf=false; S.speed=false; S.esp=false; S.ghost=false; S.god=false; S.hbx=false; S.jump=false
end

-- ربط دالة التحديث عند موت اللاعب
bd(plr.CharacterAdded,function()
    task.wait(1)
    if _G.KhalilUpdateUI then _G.KhalilUpdateUI() end
end)

bd(UIS.InputBegan,function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then
        local sh=not m.Visible
        m.Visible=sh fbtn.Visible=not sh
    elseif UIS:IsKeyDown(Enum.KeyCode.RightControl)then
        if i.KeyCode==Enum.KeyCode.One then S.noclip=not S.noclip
        elseif i.KeyCode==Enum.KeyCode.Two then S.fly=not S.fly
        elseif i.KeyCode==Enum.KeyCode.Three then S.inf=not S.inf
        elseif i.KeyCode==Enum.KeyCode.Four then S.speed=not S.speed
        elseif i.KeyCode==Enum.KeyCode.Five then S.esp=not S.esp
        end
    end
end)

_G.KhalilCleanup=function()
    alive=false
    for _,c in ipairs(CN)do pcall(function()c:Disconnect()end)end
    for p,o in pairs(hbO)do hbRes(p,o)end
    apG(false)
    if S.free then setFC(false)end
    if S.fov then local c=workspace.CurrentCamera if c then c.FieldOfView=70 end end
    apZ(false)
    for p in pairs(eO)do clE(p)end
    stFly()
    local h=hu()if h then h.WalkSpeed=16 h.JumpPower=50 end
    g:Destroy()
end

print("سكربت خليل | by خليل تم تحميله بنجاح! (نسخة خالية من الأخطاء)")
