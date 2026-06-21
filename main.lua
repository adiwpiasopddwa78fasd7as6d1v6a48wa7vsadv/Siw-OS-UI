local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local TextService      = game:GetService("TextService")
local RunService       = game:GetService("RunService")

local SiwOSLibrary = {}
SiwOSLibrary.__index = SiwOSLibrary

local IsMobile    = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local Camera      = workspace.CurrentCamera
local Viewport    = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
local IsSmallScreen = Viewport.X < 700

SiwOSLibrary.Themes = {
    Dark = {
        Background = Color3.fromRGB(28, 28, 33),
        Header     = Color3.fromRGB(20, 20, 24),
        TabBar     = Color3.fromRGB(22, 22, 26),
        Section    = Color3.fromRGB(36, 36, 42),
        Accent     = Color3.fromRGB(90, 120, 240),
        Text       = Color3.fromRGB(235, 235, 235),
        SubText    = Color3.fromRGB(160, 160, 170),
        ElementBg  = Color3.fromRGB(58, 58, 68),
        Stroke     = Color3.fromRGB(70, 70, 80),
        Danger     = Color3.fromRGB(235, 90, 90),
        Shadow     = Color3.fromRGB(0, 0, 0),
        LabelColor    = Color3.fromRGB(255, 255, 255),
        LabelStroke   = Color3.fromRGB(0, 0, 0),
        IsLight = false,
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 248),
        Header     = Color3.fromRGB(230, 230, 235),
        TabBar     = Color3.fromRGB(235, 235, 240),
        Section    = Color3.fromRGB(255, 255, 255),
        Accent     = Color3.fromRGB(70, 110, 235),
        Text       = Color3.fromRGB(30, 30, 35),
        SubText    = Color3.fromRGB(80, 80, 90),
        ElementBg  = Color3.fromRGB(210, 210, 220),
        Stroke     = Color3.fromRGB(180, 180, 195),
        Danger     = Color3.fromRGB(220, 70, 70),
        Shadow     = Color3.fromRGB(0, 0, 0),
        LabelColor    = Color3.fromRGB(20, 20, 25),
        LabelStroke   = Color3.fromRGB(255, 255, 255),
        IsLight = true,
    },
    Ocean = {
        Background = Color3.fromRGB(15, 28, 38),
        Header     = Color3.fromRGB(10, 20, 28),
        TabBar     = Color3.fromRGB(12, 24, 32),
        Section    = Color3.fromRGB(20, 38, 50),
        Accent     = Color3.fromRGB(60, 190, 220),
        Text       = Color3.fromRGB(225, 245, 250),
        SubText    = Color3.fromRGB(140, 175, 185),
        ElementBg  = Color3.fromRGB(34, 64, 82),
        Stroke     = Color3.fromRGB(48, 82, 102),
        Danger     = Color3.fromRGB(235, 100, 100),
        Shadow     = Color3.fromRGB(0, 0, 0),
        LabelColor    = Color3.fromRGB(255, 255, 255),
        LabelStroke   = Color3.fromRGB(0, 0, 0),
        IsLight = false,
    },
    Purple = {
        Background = Color3.fromRGB(26, 22, 38),
        Header     = Color3.fromRGB(18, 15, 28),
        TabBar     = Color3.fromRGB(20, 17, 30),
        Section    = Color3.fromRGB(36, 30, 50),
        Accent     = Color3.fromRGB(165, 110, 245),
        Text       = Color3.fromRGB(235, 230, 245),
        SubText    = Color3.fromRGB(165, 155, 180),
        ElementBg  = Color3.fromRGB(58, 48, 78),
        Stroke     = Color3.fromRGB(74, 62, 96),
        Danger     = Color3.fromRGB(240, 95, 130),
        Shadow     = Color3.fromRGB(0, 0, 0),
        LabelColor    = Color3.fromRGB(255, 255, 255),
        LabelStroke   = Color3.fromRGB(0, 0, 0),
        IsLight = false,
    },
    Sunset = {
        Background = Color3.fromRGB(32, 22, 24),
        Header     = Color3.fromRGB(22, 15, 17),
        TabBar     = Color3.fromRGB(25, 17, 19),
        Section    = Color3.fromRGB(44, 28, 30),
        Accent     = Color3.fromRGB(245, 130, 80),
        Text       = Color3.fromRGB(245, 230, 225),
        SubText    = Color3.fromRGB(180, 150, 145),
        ElementBg  = Color3.fromRGB(68, 44, 47),
        Stroke     = Color3.fromRGB(86, 56, 60),
        Danger     = Color3.fromRGB(235, 90, 90),
        Shadow     = Color3.fromRGB(0, 0, 0),
        LabelColor    = Color3.fromRGB(255, 255, 255),
        LabelStroke   = Color3.fromRGB(0, 0, 0),
        IsLight = false,
    },
    Mint = {
        Background = Color3.fromRGB(20, 30, 28),
        Header     = Color3.fromRGB(14, 22, 20),
        TabBar     = Color3.fromRGB(16, 24, 22),
        Section    = Color3.fromRGB(28, 42, 38),
        Accent     = Color3.fromRGB(80, 220, 170),
        Text       = Color3.fromRGB(225, 245, 238),
        SubText    = Color3.fromRGB(150, 180, 170),
        ElementBg  = Color3.fromRGB(42, 64, 58),
        Stroke     = Color3.fromRGB(56, 82, 74),
        Danger     = Color3.fromRGB(240, 100, 100),
        Shadow     = Color3.fromRGB(0, 0, 0),
        LabelColor    = Color3.fromRGB(255, 255, 255),
        LabelStroke   = Color3.fromRGB(0, 0, 0),
        IsLight = false,
    },
}

function SiwOSLibrary:RegisterTheme(name, t) SiwOSLibrary.Themes[name] = t end

local function new(class, props)
    local inst = Instance.new(class)
    local ok = pcall(function() return inst.BorderSizePixel end)
    if ok and (not props or props.BorderSizePixel == nil) then
        inst.BorderSizePixel = 0
    end
    for k, v in pairs(props or {}) do inst[k] = v end
    return inst
end

local function corner(parent, r)
    return new("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = parent })
end

local function uiStroke(parent, color, thickness)
    return new("UIStroke", {
        Color = color or Color3.fromRGB(60,60,66),
        Thickness = thickness or 1,
        Parent = parent,
    })
end

local function gradient(parent, rot, t0, t1)
    return new("UIGradient", {
        Rotation = rot or 90,
        Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, t0 or 0),
            NumberSequenceKeypoint.new(1, t1 or 0.15),
        }),
        Parent = parent,
    })
end

local function initTextStroke(inst, thickness)
    inst.TextColor3 = Color3.fromRGB(255,255,255)
    new("UIStroke", {
        Color = Color3.fromRGB(0,0,0),
        Thickness = thickness or 1.5,
        Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
        Parent = inst,
    })
end

local EASE_SMOOTH = TweenInfo.new(0.28, Enum.EasingStyle.Quint,  Enum.EasingDirection.Out)
local EASE_FAST   = TweenInfo.new(0.15, Enum.EasingStyle.Quad,   Enum.EasingDirection.Out)
local EASE_POP    = TweenInfo.new(0.35, Enum.EasingStyle.Back,   Enum.EasingDirection.Out)

local function tween(obj, props, info)
    local t = TweenService:Create(obj, info or EASE_SMOOTH, props)
    t:Play(); return t
end

local function makeDraggable(topbar, frame)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local d = input.Position - dragStart
            tween(frame, { Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )}, EASE_FAST)
        end
    end)
end

local SaveConfig = {}
SaveConfig._data = {}

local function jsonEncode(t)
    local function enc(v)
        local tp = type(v)
        if tp == "string" then
            return '"' .. v:gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n','\\n') .. '"'
        elseif tp == "number" then
            return tostring(v)
        elseif tp == "boolean" then
            return v and "true" or "false"
        elseif tp == "table" then
            local isArr = (#v > 0)
            if isArr then
                local parts = {}
                for _, vv in ipairs(v) do parts[#parts+1] = enc(vv) end
                return "[" .. table.concat(parts,",") .. "]"
            else
                local parts = {}
                for k2, vv in pairs(v) do
                    parts[#parts+1] = '"'..tostring(k2)..'":'..enc(vv)
                end
                return "{" .. table.concat(parts,",") .. "}"
            end
        end
        return "null"
    end
    return enc(t)
end

local function jsonDecode(s)
    if not s or s == "" then return {} end
    s = s:gsub("null","false")
    local fn, err = loadstring("return " .. s)
    if fn then
        local ok2, result = pcall(fn)
        if ok2 and type(result) == "table" then return result end
    end
    return {}
end

function SaveConfig:Load(filename)
    if not filename then return {} end
    self._file = filename
    if readfile then
        local ok, data = pcall(readfile, self._file)
        if ok and data and data ~= "" then
            self._data = jsonDecode(data)
        end
    end
    return self._data
end

function SaveConfig:Save()
    if writefile and self._file then
        pcall(writefile, self._file, jsonEncode(self._data))
    end
end

function SaveConfig:Get(key, default)
    local v = self._data[key]
    if v == nil then return default end
    return v
end

function SaveConfig:Set(key, value)
    self._data[key] = value
    self:Save()
end


function SiwOSLibrary:CreateWindow(config)
    config = config or {}
    local title     = config.Title or "Siw OS"
    local saveFile  = config.SaveFile or "SiwOS_Config.json"
    
    SaveConfig:Load(saveFile)
    
    local themeName = SaveConfig:Get("theme", config.Theme or "Dark")
    local CurrentTheme = SiwOSLibrary.Themes[themeName] or SiwOSLibrary.Themes.Dark

    local defaultSize = IsSmallScreen
        and UDim2.new(0.92, 0, 0.62, 0)
        or  UDim2.new(0, 520, 0, 380)
    local size = config.Size or defaultSize

    local ScreenGui = new("ScreenGui", {
        Name            = "SiwOSLibrary_" .. title,
        ResetOnSpawn    = false,
        IgnoreGuiInset  = true,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        Parent = (gethui and gethui()) or Players.LocalPlayer:WaitForChild("PlayerGui"),
    })

    local ShadowLayer = new("Frame", {
        BackgroundTransparency = 1,
        Size   = UDim2.new(1,0,1,0),
        ZIndex = 1,
        Parent = ScreenGui,
    })

    local Main = new("Frame", {
        Name                = "Main",
        Size                = UDim2.new(size.X.Scale, size.X.Offset, 0, 0),
        Position            = UDim2.new(0.5,0,0.5,0),
        AnchorPoint         = Vector2.new(0.5,0.5),
        BackgroundColor3    = CurrentTheme.Background,
        BackgroundTransparency = 1,
        ClipsDescendants    = true,
        ZIndex              = 2,
        Parent              = ScreenGui,
    })
    corner(Main, 12)
    local mainStroke = uiStroke(Main, CurrentTheme.Stroke, 1)
    mainStroke.Transparency = 0.2

    local mainShadow = new("Frame", {
        BackgroundColor3       = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.15,
        AnchorPoint            = Vector2.new(0.5,0.5),
        ZIndex                 = 1,
        Parent                 = ShadowLayer,
    })
    corner(mainShadow, 12)

    local function syncShadow()
        mainShadow.Size     = Main.Size
        mainShadow.Position = UDim2.new(
            Main.Position.X.Scale, Main.Position.X.Offset,
            Main.Position.Y.Scale, Main.Position.Y.Offset + 6
        )
    end
    Main:GetPropertyChangedSignal("Size"):Connect(syncShadow)
    Main:GetPropertyChangedSignal("Position"):Connect(syncShadow)
    syncShadow()

    gradient(Main, 90, 0.0, 0.15)

    local HEADER_H = IsMobile and 44 or 38
    local TABBAR_H = IsMobile and 56 or 48

    local Header = new("Frame", {
        Name             = "Header",
        Size             = UDim2.new(1,0,0,HEADER_H),
        BackgroundColor3 = CurrentTheme.Header,
        ZIndex           = 3,
        Parent           = Main,
    })
    corner(Header, 12)
    local HeaderFiller = new("Frame", {
        Size             = UDim2.new(1,0,0,12),
        Position         = UDim2.new(0,0,1,-12),
        BackgroundColor3 = CurrentTheme.Header,
        ZIndex           = 3,
        Parent           = Header,
    })
    gradient(Header, 90, 0.0, 0.2)

    local TitleLabel = new("TextLabel", {
        Text             = title,
        Font             = Enum.Font.GothamBold,
        TextSize         = IsMobile and 17 or 16,
        TextColor3       = CurrentTheme.LabelColor,
        BackgroundTransparency = 1,
        Size             = UDim2.new(0, 60, 1, 0),
        Position         = UDim2.new(0, 14, 0, 0),
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 4,
        Parent           = Header,
    })
    initTextStroke(TitleLabel, 1.25)

    local HeaderSep = new("Frame", {
        BackgroundColor3 = CurrentTheme.Stroke,
        Size             = UDim2.new(0, 1, 0, HEADER_H - 16),
        AnchorPoint      = Vector2.new(0, 0.5),
        Position         = UDim2.new(0, 75, 0.5, 0),
        ZIndex           = 4,
        Parent           = Header,
    })

    local LocalPlayer = Players.LocalPlayer
    local pUserId = LocalPlayer and LocalPlayer.UserId or 1
    local pDisplayName = LocalPlayer and LocalPlayer.DisplayName or "Guest"
    local pUsername = LocalPlayer and ("@" .. LocalPlayer.Name) or "@guest"
    local pAvatar = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    pcall(function()
        pAvatar = Players:GetUserThumbnailAsync(pUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)

    local ProfileContainer = new("Frame", {
        BackgroundTransparency = 1,
        Size             = UDim2.new(0, 150, 1, 0),
        Position         = UDim2.new(0, 86, 0, 0),
        ZIndex           = 4,
        Parent           = Header,
    })

    local AvatarImg = new("ImageLabel", {
        Image            = pAvatar,
        BackgroundColor3 = CurrentTheme.ElementBg,
        Size             = UDim2.new(0, HEADER_H - 14, 0, HEADER_H - 14),
        AnchorPoint      = Vector2.new(0, 0.5),
        Position         = UDim2.new(0, 0, 0.5, 0),
        ZIndex           = 5,
        Parent           = ProfileContainer,
    })
    corner(AvatarImg, math.floor((HEADER_H - 14)/2))
    local avatarStroke = uiStroke(AvatarImg, CurrentTheme.Stroke, 1.5)

    local DisplayNameLbl = new("TextLabel", {
        Text             = pDisplayName,
        Font             = Enum.Font.GothamBold,
        TextSize         = IsMobile and 13 or 12,
        TextColor3       = CurrentTheme.LabelColor,
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, -(HEADER_H - 4), 0, 14),
        Position         = UDim2.new(0, HEADER_H - 4, 0.5, -13),
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextYAlignment   = Enum.TextYAlignment.Bottom,
        ZIndex           = 5,
        Parent           = ProfileContainer,
    })
    initTextStroke(DisplayNameLbl, 1.1)

    local UsernameLbl = new("TextLabel", {
        Text             = pUsername,
        Font             = Enum.Font.GothamMedium,
        TextSize         = IsMobile and 11 or 10,
        TextColor3       = CurrentTheme.SubText,
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, -(HEADER_H - 4), 0, 14),
        Position         = UDim2.new(0, HEADER_H - 4, 0.5, 1),
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextYAlignment   = Enum.TextYAlignment.Top,
        ZIndex           = 5,
        Parent           = ProfileContainer,
    })
    initTextStroke(UsernameLbl, 1)

    local BTN_SIZE = IsMobile and 30 or 26

    local CloseBtn = new("TextButton", {
        Text             = "X",
        Font             = Enum.Font.GothamBold,
        TextSize         = IsMobile and 15 or 13,
        TextColor3       = CurrentTheme.LabelColor,
        BackgroundColor3 = CurrentTheme.ElementBg,
        AutoButtonColor  = false,
        Size             = UDim2.new(0,BTN_SIZE,0,BTN_SIZE),
        Position         = UDim2.new(1,-BTN_SIZE-10,0.5,-BTN_SIZE/2),
        ZIndex           = 4,
        Parent           = Header,
    })
    corner(CloseBtn, 8)
    initTextStroke(CloseBtn, 1.1)

    local MinimizeBtn = new("TextButton", {
        Text             = "—",
        Font             = Enum.Font.GothamBold,
        TextSize         = IsMobile and 15 or 13,
        TextColor3       = CurrentTheme.LabelColor,
        BackgroundColor3 = CurrentTheme.ElementBg,
        AutoButtonColor  = false,
        AnchorPoint      = Vector2.new(0.5,0.5),
        Size             = UDim2.new(0,BTN_SIZE,0,BTN_SIZE),
        Position         = UDim2.new(1,-(BTN_SIZE*2)-16+BTN_SIZE/2,0.5,0),
        ZIndex           = 4,
        Parent           = Header,
    })
    corner(MinimizeBtn, 8)
    initTextStroke(MinimizeBtn, 1.1)

    makeDraggable(Header, Main)

    local BUBBLE_H      = IsMobile and 46 or 40
    local BUBBLE_MARGIN = 8

    local ReopenBtn = new("TextButton", {
        Text             = "",
        AutoButtonColor  = false,
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        Size             = UDim2.new(0,BUBBLE_H,0,BUBBLE_H),
        AnchorPoint      = Vector2.new(1,0),
        Position         = UDim2.new(1,-BUBBLE_MARGIN,0,BUBBLE_MARGIN),
        Visible          = false,
        ClipsDescendants = true,
        ZIndex           = 50,
        Parent           = ScreenGui,
    })
    corner(ReopenBtn, math.floor(BUBBLE_H/2))
    uiStroke(ReopenBtn, CurrentTheme.Accent, 1.5)
    gradient(ReopenBtn, 90, 0.0, 0.2)

    local ReopenLabel = new("TextLabel", {
        Text             = "Siw OS",
        Font             = Enum.Font.GothamBold,
        TextSize         = IsMobile and 15 or 13,
        TextColor3       = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        Size             = UDim2.new(1,0,1,0),
        TextXAlignment   = Enum.TextXAlignment.Center,
        TextYAlignment   = Enum.TextYAlignment.Center,
        ZIndex           = 51,
        Parent           = ReopenBtn,
    })
    initTextStroke(ReopenLabel, 1.1)

    local ReopenImage = new("ImageLabel", {
        BackgroundTransparency = 1,
        Image       = "",
        Visible     = false,
        Size        = UDim2.new(1,-6,1,-6),
        Position    = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        ScaleType   = Enum.ScaleType.Fit,
        ZIndex      = 51,
        Parent      = ReopenBtn,
    })
    corner(ReopenImage, math.floor(BUBBLE_H/2))

    local function resizeBubble()
        if not ReopenLabel.Visible then return end
        local tw = TextService:GetTextSize(
            ReopenLabel.Text, ReopenLabel.TextSize, ReopenLabel.Font, Vector2.new(1000,BUBBLE_H)
        ).X
        ReopenBtn.Size = UDim2.new(0, math.max(BUBBLE_H, tw+(IsMobile and 26 or 22)), 0, BUBBLE_H)
    end

    local ReopenBtnAPI = {}
    function ReopenBtnAPI:SetText(t) ReopenLabel.Text=t or "Siw OS"; ReopenLabel.Visible=true; ReopenImage.Visible=false; resizeBubble() end
    function ReopenBtnAPI:SetImage(id) ReopenImage.Image=id or ""; ReopenImage.Visible=true; ReopenLabel.Visible=false; ReopenBtn.Size=UDim2.new(0,BUBBLE_H,0,BUBBLE_H) end
    resizeBubble()

    local PageHolder = new("Frame", {
        Size             = UDim2.new(1,0,1,-(HEADER_H+TABBAR_H)),
        Position         = UDim2.new(0,0,0,HEADER_H),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex           = 2,
        Parent           = Main,
    })

    local TabBar = new("ScrollingFrame", {
        Size                = UDim2.new(1,0,0,TABBAR_H),
        Position            = UDim2.new(0,0,1,-TABBAR_H),
        BackgroundColor3    = CurrentTheme.TabBar,
        ClipsDescendants    = true,
        ScrollingDirection  = Enum.ScrollingDirection.X,
        ScrollBarThickness  = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        CanvasSize          = UDim2.new(0,0,0,0),
        ElasticBehavior     = Enum.ElasticBehavior.WhenScrollable,
        ZIndex              = 3,
        Parent              = Main,
    })
    gradient(TabBar, 90, 0.0, 0.15)

    local TabBarContent = new("Frame", {
        Size             = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        ZIndex           = 3,
        Parent           = TabBar,
    })
    new("UIPadding", { PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6), PaddingTop=UDim.new(0,11), PaddingBottom=UDim.new(0,6), Parent=TabBarContent })
    new("UIListLayout", {
        FillDirection       = Enum.FillDirection.Horizontal,
        Padding             = UDim.new(0,6),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment   = Enum.VerticalAlignment.Center,
        SortOrder           = Enum.SortOrder.LayoutOrder,
        Parent              = TabBarContent,
    })

    local ScrollTrack = new("Frame", {
        Size             = UDim2.new(1,-12,0,3),
        Position         = UDim2.new(0,6,1,-TABBAR_H+2),
        BackgroundColor3 = CurrentTheme.Stroke,
        BackgroundTransparency = 0.3,
        ZIndex           = 6,
        Parent           = Main,
    })
    corner(ScrollTrack, 2)
    local ScrollThumb = new("TextButton", {
        Text             = "",
        AutoButtonColor  = false,
        Size             = UDim2.new(1,0,1,0),
        BackgroundColor3 = CurrentTheme.Accent,
        ZIndex           = 7,
        Parent           = ScrollTrack,
    })
    corner(ScrollThumb, 2)
    local ScrollThumbHit = new("Frame", {
        BackgroundTransparency = 1,
        Size        = UDim2.new(1,0,0,IsMobile and 22 or 14),
        AnchorPoint = Vector2.new(0,0.5),
        Position    = UDim2.new(0,0,0.5,0),
        ZIndex      = 7,
        Parent      = ScrollThumb,
    })

    local function updateScrollThumb()
        local cw = TabBar.CanvasSize.X.Offset
        local vw = TabBar.AbsoluteSize.X
        if cw <= vw or cw <= 0 then ScrollTrack.Visible=false; return end
        ScrollTrack.Visible = true
        local ts = math.clamp(vw/cw, 0.12, 1)
        local ps = math.clamp(TabBar.CanvasPosition.X/(cw-vw), 0, 1)
        tween(ScrollThumb, { Size=UDim2.new(ts,0,1,0), Position=UDim2.new((1-ts)*ps,0,0,0) }, EASE_FAST)
    end
    TabBar:GetPropertyChangedSignal("CanvasPosition"):Connect(updateScrollThumb)
    TabBar:GetPropertyChangedSignal("CanvasSize"):Connect(updateScrollThumb)
    TabBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScrollThumb)
    task.defer(updateScrollThumb)

    do
        local tdrag, tdragX, tcanX = false, 0, 0
        ScrollThumbHit.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                tdrag=true; tdragX=i.Position.X; tcanX=TabBar.CanvasPosition.X
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if tdrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local cw=TabBar.CanvasSize.X.Offset; local vw=TabBar.AbsoluteSize.X
                local tw=ScrollTrack.AbsoluteSize.X; local sw=ScrollThumb.AbsoluteSize.X
                local max=math.max(cw-vw,0); if max<=0 then return end
                TabBar.CanvasPosition = Vector2.new(math.clamp(tcanX+((i.Position.X-tdragX)/math.max(tw-sw,1))*max,0,max),0)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then tdrag=false end
        end)
        ScrollTrack.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                local cw=TabBar.CanvasSize.X.Offset; local vw=TabBar.AbsoluteSize.X
                local max=math.max(cw-vw,0); if max<=0 then return end
                local rel=math.clamp((i.Position.X-ScrollTrack.AbsolutePosition.X)/ScrollTrack.AbsoluteSize.X,0,1)
                TabBar:TweenCanvasPosition(Vector2.new(rel*max,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quint,0.2,true)
            end
        end)
    end

    local Window = setmetatable({},{__index={}})
    Window.ScreenGui        = ScreenGui
    Window.Main             = Main
    Window.Header           = Header
    Window.TabBar           = TabBar
    Window.PageHolder       = PageHolder
    Window.Tabs             = {}
    Window._firstTab        = true
    Window._themed          = {}
    Window._textInsts       = {}
    Window._minimized       = false
    Window._fullSize        = size
    Window.CurrentTheme     = CurrentTheme
    Window.CurrentThemeName = themeName
    Window.ReopenBubble     = ReopenBtnAPI
    Window._showBubbleOnClose = SaveConfig:Get("showBubble", true)
    Window._keybind         = nil
    Window._keybindHidden   = false
    Window.SaveConfig       = SaveConfig

    local function trackText(inst, strokeThick)
        table.insert(Window._textInsts, { inst=inst, thick=strokeThick or 1.5 })
    end

    function Window:_track(inst, mapTbl)
        local entry = { inst=inst, map=mapTbl }
        table.insert(self._themed, entry)
        return entry
    end

    function Window:SetTheme(name)
        local theme = SiwOSLibrary.Themes[name]
        if not theme then warn("[SiwOSLibrary] Theme not found: "..tostring(name)); return end
        self.CurrentTheme     = theme
        self.CurrentThemeName = name
        SaveConfig:Set("theme", name)

        for _, entry in ipairs(self._themed) do
            if entry.inst and entry.inst.Parent then
                local props = {}
                for prop, key in pairs(entry.map) do props[prop] = theme[key] end
                tween(entry.inst, props, EASE_SMOOTH)
            end
        end

        for _, ti in ipairs(self._textInsts) do
            if ti.inst and ti.inst.Parent then
                tween(ti.inst, { TextColor3 = theme.LabelColor }, EASE_SMOOTH)
                for _, ch in ipairs(ti.inst:GetChildren()) do
                    if ch:IsA("UIStroke") then
                        tween(ch, { Color = theme.LabelStroke }, EASE_SMOOTH)
                    end
                end
            end
        end

        HeaderFiller.BackgroundColor3 = theme.Header
    end

    local function makeText(class, props, strokeThick)
        local inst = new(class, props)
        initTextStroke(inst, strokeThick or 1.5)
        trackText(inst, strokeThick or 1.5)
        return inst
    end

    Window:_track(Main,        { BackgroundColor3 = "Background" })
    Window:_track(mainStroke,  { Color = "Stroke" })
    Window:_track(Header,      { BackgroundColor3 = "Header" })
    Window:_track(TabBar,      { BackgroundColor3 = "TabBar" })
    Window:_track(ScrollTrack, { BackgroundColor3 = "Stroke" })
    Window:_track(ScrollThumb, { BackgroundColor3 = "Accent" })
    Window:_track(CloseBtn,    { BackgroundColor3 = "ElementBg" })
    Window:_track(MinimizeBtn, { BackgroundColor3 = "ElementBg" })
    
    Window:_track(HeaderSep,    { BackgroundColor3 = "Stroke" })
    Window:_track(AvatarImg,    { BackgroundColor3 = "ElementBg" })
    Window:_track(avatarStroke, { Color = "Stroke" })
    Window:_track(UsernameLbl,  { TextColor3 = "SubText" })
    
    local unStroke = UsernameLbl:FindFirstChildOfClass("UIStroke")
    if unStroke then Window:_track(unStroke, { Color = "LabelStroke" }) end

    trackText(TitleLabel, 1.25)
    trackText(CloseBtn, 1.1)
    trackText(MinimizeBtn, 1.1)
    trackText(DisplayNameLbl, 1.1)

    task.defer(function()
        tween(Main, { Size=size, BackgroundTransparency=0 }, EASE_POP)
    end)

    local RESIZE_GRIP = IsMobile and 22 or 16
    local MIN_W, MIN_H = 280, HEADER_H + TABBAR_H + 80

    local function makeResizeHandle(cName, anchor, px, py, sw, sh)
        local Handle = new("Frame", {
            Name            = "Resize_"..cName,
            BackgroundTransparency = 1,
            AnchorPoint     = anchor,
            Size            = UDim2.new(0,RESIZE_GRIP,0,RESIZE_GRIP),
            Position        = UDim2.new(px,0,py,0),
            ZIndex          = 10,
            Parent          = Main,
        })
        local Dot = new("Frame", {
            BackgroundColor3    = Color3.fromRGB(255,255,255),
            BackgroundTransparency = 0.55,
            AnchorPoint         = Vector2.new(0.5,0.5),
            Size                = UDim2.new(0,6,0,6),
            Position            = UDim2.new(0.5,0,0.5,0),
            ZIndex              = 10,
            Parent              = Handle,
        })
        corner(Dot, 3)
        local drag, sIP, sSz, sPo = false
        Handle.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                if Window._minimized then return end
                drag=true; sIP=i.Position; sSz=Main.Size; sPo=Main.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local dx=i.Position.X-sIP.X; local dy=i.Position.Y-sIP.Y
                local nw=math.max(sSz.X.Offset+sw*dx,MIN_W); local nh=math.max(sSz.Y.Offset+sh*dy,MIN_H)
                local adx=(nw-sSz.X.Offset)*sw; local ady=(nh-sSz.Y.Offset)*sh
                Main.Size=UDim2.new(sSz.X.Scale,nw,sSz.Y.Scale,nh)
                Main.Position=UDim2.new(sPo.X.Scale,sPo.X.Offset+adx/2,sPo.Y.Scale,sPo.Y.Offset+ady/2)
                Window._fullSize=Main.Size
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
        end)
        return Handle
    end
    makeResizeHandle("BottomLeft",  Vector2.new(0,1), 0, 1, -1, 1)
    makeResizeHandle("BottomRight", Vector2.new(1,1), 1, 1,  1, 1)

    function Window:ToggleMinimize()
        self._minimized = not self._minimized
        if self._minimized then
            self._fullSize = Main.Size
            PageHolder.Visible = false; TabBar.Visible = false
            tween(Main, { Size=UDim2.new(self._fullSize.X.Scale,self._fullSize.X.Offset,0,HEADER_H) }, EASE_SMOOTH)
            tween(MinimizeBtn, { Rotation=180 }, EASE_FAST)
        else
            tween(Main, { Size=self._fullSize }, EASE_SMOOTH)
            tween(MinimizeBtn, { Rotation=0 }, EASE_FAST)
            task.delay(EASE_SMOOTH.Time*0.6, function()
                PageHolder.Visible=true; TabBar.Visible=true
            end)
        end
    end
    MinimizeBtn.MouseButton1Click:Connect(function() Window:ToggleMinimize() end)

    function Window:Close()
        tween(Main, { Size=UDim2.new(Main.Size.X.Scale,Main.Size.X.Offset,0,0), BackgroundTransparency=1 }, EASE_SMOOTH)
        task.delay(0.28, function()
            Main.Visible=false; mainShadow.Visible=false
            if self._showBubbleOnClose then
                local ts=ReopenBtn.Size
                ReopenBtn.Visible=true; ReopenBtn.Size=UDim2.new(0,0,0,0)
                tween(ReopenBtn, { Size=ts }, EASE_POP)
            end
        end)
    end
    CloseBtn.MouseButton1Click:Connect(function() Window:Close() end)

    function Window:Open()
        Main.Visible=true; mainShadow.Visible=true
        self._minimized=true; MinimizeBtn.Rotation=180
        PageHolder.Visible=false; TabBar.Visible=false
        Main.Size = UDim2.new(self._fullSize.X.Scale,self._fullSize.X.Offset,0,0)
        local bs=ReopenBtn.Size
        tween(ReopenBtn, { Size=UDim2.new(0,0,0,0) }, EASE_FAST)
        task.delay(0.15, function() ReopenBtn.Visible=false; ReopenBtn.Size=bs end)
        
        local HEADER_H = IsMobile and 44 or 38
        tween(Main, { Size=UDim2.new(self._fullSize.X.Scale,self._fullSize.X.Offset,0,HEADER_H), BackgroundTransparency=0 }, EASE_POP)
    end
    ReopenBtn.MouseButton1Click:Connect(function() Window:Open() end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if Window._keybind and input.KeyCode == Window._keybind then
            Window._keybindHidden = not Window._keybindHidden
            if Window._keybindHidden then
                Main.Visible=false; mainShadow.Visible=false; ReopenBtn.Visible=false
            else
                Main.Visible=true; mainShadow.Visible=true
                if not Window._minimized then
                    Window:ToggleMinimize()
                end
            end
        end
    end)

    function Window:Toggle()
        if Main.Visible then Window:Close() else Window:Open() end
    end
    
    function Window:Destroy() ScreenGui:Destroy() end

    function Window:CreateTab(name, icon)
        local TabButton = new("TextButton", {
            Name             = name,
            Text             = (icon and (icon.."  ") or "")..name,
            Font             = Enum.Font.GothamMedium,
            TextSize         = 13,
            TextColor3       = CurrentTheme.LabelColor,
            BackgroundColor3 = CurrentTheme.ElementBg,
            AutoButtonColor  = false,
            AutomaticSize    = Enum.AutomaticSize.X,
            Size             = UDim2.new(0,IsMobile and 100 or 110,1,0),
            LayoutOrder      = #Window.Tabs + 1,
            ZIndex           = 3,
            Parent           = TabBarContent,
        })
        corner(TabButton, 10)
        new("UIPadding", { PaddingLeft=UDim.new(0,14), PaddingRight=UDim.new(0,14), Parent=TabButton })
        gradient(TabButton, 90, 0.0, 0.15)
        initTextStroke(TabButton, 1.1)
        trackText(TabButton, 1.1)
        Window:_track(TabButton, { BackgroundColor3="ElementBg" })

        local Page = new("ScrollingFrame", {
            Name                = name.."_Page",
            Size                = UDim2.new(1,-16,1,-12),
            Position            = UDim2.new(0,8,0,6),
            BackgroundTransparency = 1,
            CanvasSize          = UDim2.new(0,0,0,0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness  = IsMobile and 3 or 4,
            ScrollBarImageColor3 = CurrentTheme.Accent,
            ScrollingDirection  = Enum.ScrollingDirection.Y,
            Visible             = false,
            ZIndex              = 2,
            Parent              = PageHolder,
        })
        Window:_track(Page, { ScrollBarImageColor3="Accent" })
        new("UIListLayout", { Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder, Parent=Page })

        local Tab = setmetatable({ Button=TabButton, Page=Page }, { __index={} })

        local function selectTab()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible=false
                t.Page.Position=UDim2.new(0,8,0,6)
                tween(t.Button, { BackgroundColor3=Window.CurrentTheme.ElementBg }, EASE_FAST)
            end
            Page.Visible=true
            Page.Position=UDim2.new(0,8,0,16)
            tween(Page, { Position=UDim2.new(0,8,0,6) }, EASE_SMOOTH)
            
            tween(TabButton, { BackgroundColor3=Color3.fromRGB(35, 35, 40) }, EASE_FAST)
            
            local bp=TabButton.AbsolutePosition.X-TabBar.AbsolutePosition.X
            local br=bp+TabButton.AbsoluteSize.X
            local vl=TabBar.CanvasPosition.X; local vr=vl+TabBar.AbsoluteSize.X
            if bp<vl then TabBar:TweenCanvasPosition(Vector2.new(math.max(bp-12,0),0),Enum.EasingDirection.Out,Enum.EasingStyle.Quint,0.25,true)
            elseif br>vr then TabBar:TweenCanvasPosition(Vector2.new(br-TabBar.AbsoluteSize.X+12,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quint,0.25,true) end
        end
        TabButton.MouseButton1Click:Connect(selectTab)
        if Window._firstTab then Window._firstTab=false; selectTab() end

        function Tab:CreateSection(sectionName)
            local SF = new("Frame", {
                Name             = sectionName,
                Size             = UDim2.new(1,0,0,36),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundColor3 = Window.CurrentTheme.Section,
                ZIndex           = 2,
                Parent           = Page,
            })
            corner(SF, 10)
            local secStroke = uiStroke(SF, Window.CurrentTheme.Stroke, 1)
            secStroke.Transparency = 0.3
            gradient(SF, 90, 0.0, 0.1)
            Window:_track(SF, { BackgroundColor3="Section" })
            Window:_track(secStroke, { Color="Stroke" })

            local titleLbl = new("TextLabel", {
                Text             = sectionName,
                Font             = Enum.Font.GothamBold,
                TextSize         = 14,
                TextColor3       = Window.CurrentTheme.LabelColor,
                BackgroundTransparency = 1,
                Size             = UDim2.new(1,-16,0,30),
                Position         = UDim2.new(0,10,0,4),
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 2,
                Parent           = SF,
            })
            initTextStroke(titleLbl, 1.1)
            trackText(titleLbl, 1.1)

            local Content = new("Frame", {
                Size             = UDim2.new(1,-16,0,0),
                Position         = UDim2.new(0,8,0,34),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ZIndex           = 2,
                Parent           = SF,
            })
            new("UIListLayout", { Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder, Parent=Content })
            new("UIPadding", { PaddingBottom=UDim.new(0,10), Parent=Content })

            local Section = setmetatable({ Frame=SF, Content=Content }, { __index={} })
            local ELEM_H = IsMobile and 38 or 32

            function Section:AddButton(opt)
                opt = opt or {}
                local Btn = new("TextButton", {
                    Text             = opt.Text or "Button",
                    Font             = Enum.Font.GothamMedium,
                    TextSize         = 13,
                    TextColor3       = Window.CurrentTheme.LabelColor,
                    BackgroundColor3 = Window.CurrentTheme.ElementBg,
                    AutoButtonColor  = false,
                    Size             = UDim2.new(1,0,0,ELEM_H),
                    ZIndex           = 2,
                    Parent           = Content,
                })
                corner(Btn, 8); gradient(Btn,90,0,0.15)
                initTextStroke(Btn, 1.1); trackText(Btn, 1.1)
                Window:_track(Btn, { BackgroundColor3="ElementBg" })

                Btn.MouseButton1Click:Connect(function()
                    tween(Btn,{BackgroundColor3=Window.CurrentTheme.Accent},EASE_FAST)
                    task.delay(0.12,function() tween(Btn,{BackgroundColor3=Window.CurrentTheme.ElementBg},EASE_SMOOTH) end)
                    if opt.Callback then pcall(opt.Callback) end
                end)
                return Btn
            end

            function Section:AddToggle(opt)
                opt = opt or {}
                local key   = opt.SaveKey
                local state = key and SaveConfig:Get(key, opt.Default ~= nil and opt.Default or false)
                              or (opt.Default ~= nil and opt.Default or false)

                local Holder = new("TextButton", {
                    Text="", AutoButtonColor=false,
                    BackgroundColor3=Window.CurrentTheme.ElementBg,
                    Size=UDim2.new(1,0,0,ELEM_H), ZIndex=2, Parent=Content,
                })
                corner(Holder,8); gradient(Holder,90,0,0.15)
                Window:_track(Holder,{BackgroundColor3="ElementBg"})

                local lbl = new("TextLabel", {
                    Text=opt.Text or "Toggle", Font=Enum.Font.GothamMedium, TextSize=13,
                    TextColor3=Window.CurrentTheme.LabelColor,
                    BackgroundTransparency=1, Size=UDim2.new(1,-56,1,0),
                    Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left, ZIndex=2, Parent=Holder,
                })
                initTextStroke(lbl,1.1); trackText(lbl,1.1)

                local Switch = new("Frame", {
                    Size=UDim2.new(0,40,0,20), Position=UDim2.new(1,-50,0.5,-10),
                    BackgroundColor3 = state and Window.CurrentTheme.Accent or Window.CurrentTheme.Stroke,
                    ZIndex=2, Parent=Holder,
                })
                corner(Switch,10)
                
                local strokeToggle = uiStroke(Switch, Color3.fromRGB(0,0,0), 2)
                strokeToggle.Transparency = state and 0 or 1
                
                local Dot = new("TextLabel", {
                    Text = "▶",
                    Font = Enum.Font.GothamBlack,
                    TextSize = 14,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0,16,0,16),
                    Position = state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8),
                    ZIndex=3, Parent=Switch,
                })
                Window:_track(Switch,{ BackgroundColor3 = state and "Accent" or "Stroke" })

                local api = {}
                local function setState(v, fire)
                    state = v
                    Window:_track(Switch,{ BackgroundColor3 = v and "Accent" or "Stroke" })
                    tween(Switch,{BackgroundColor3 = v and Window.CurrentTheme.Accent or Window.CurrentTheme.Stroke},EASE_SMOOTH)
                    tween(Dot,{Position = v and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)},EASE_POP)
                    tween(strokeToggle, {Transparency = v and 0 or 1}, EASE_SMOOTH)
                    if key then SaveConfig:Set(key,v) end
                    if fire and opt.Callback then pcall(opt.Callback,v) end
                end
                Holder.MouseButton1Click:Connect(function() setState(not state,true) end)
                if opt.Callback and state then task.defer(function() pcall(opt.Callback,state) end) end

                api.Set = function(_,v) setState(v,true) end
                api.Get = function() return state end
                return api
            end

            function Section:AddSlider(opt)
                opt = opt or {}
                local min = opt.Min or 0; local max = opt.Max or 100
                local key = opt.SaveKey
                local value = key and SaveConfig:Get(key, opt.Default or min) or (opt.Default or min)
                value = math.clamp(value, min, max)

                local Holder = new("Frame", {
                    BackgroundColor3=Window.CurrentTheme.ElementBg,
                    Size=UDim2.new(1,0,0,IsMobile and 52 or 46), ZIndex=2, Parent=Content,
                })
                corner(Holder,8); gradient(Holder,90,0,0.15)
                Window:_track(Holder,{BackgroundColor3="ElementBg"})

                local lbl = new("TextLabel", {
                    Text=opt.Text or "Slider", Font=Enum.Font.GothamMedium, TextSize=13,
                    TextColor3=Window.CurrentTheme.LabelColor,
                    BackgroundTransparency=1, Size=UDim2.new(1,-60,0,20),
                    Position=UDim2.new(0,10,0,4), TextXAlignment=Enum.TextXAlignment.Left, ZIndex=2, Parent=Holder,
                })
                initTextStroke(lbl,1.1); trackText(lbl,1.1)

                local ValLbl = new("TextLabel", {
                    Text=tostring(value), Font=Enum.Font.GothamBold, TextSize=13,
                    TextColor3=Window.CurrentTheme.LabelColor,
                    BackgroundTransparency=1, Size=UDim2.new(0,50,0,20),
                    Position=UDim2.new(1,-55,0,4), TextXAlignment=Enum.TextXAlignment.Right, ZIndex=2, Parent=Holder,
                })
                initTextStroke(ValLbl,1.1); trackText(ValLbl,1.1)

                local Track = new("Frame", {
                    Size=UDim2.new(1,-20,0,IsMobile and 10 or 6),
                    Position=UDim2.new(0,10,0,IsMobile and 34 or 30),
                    BackgroundColor3=Window.CurrentTheme.Stroke, ZIndex=2, Parent=Holder,
                })
                corner(Track,5); Window:_track(Track,{BackgroundColor3="Stroke"})

                local Fill = new("Frame", {
                    Size=UDim2.new((value-min)/(max-min),0,1,0),
                    BackgroundColor3=Window.CurrentTheme.Accent, ZIndex=2, Parent=Track,
                })
                corner(Fill,5); Window:_track(Fill,{BackgroundColor3="Accent"})

                local Knob = new("Frame", {
                    Size=UDim2.new(0,IsMobile and 20 or 14,0,IsMobile and 20 or 14),
                    AnchorPoint=Vector2.new(0.5,0.5),
                    Position=UDim2.new((value-min)/(max-min),0,0.5,0),
                    BackgroundColor3=Color3.fromRGB(255,255,255), ZIndex=3, Parent=Track,
                })
                corner(Knob,10); uiStroke(Knob,Window.CurrentTheme.Accent,2)

                local dragging = false
                local function updateX(x, fire)
                    local rel=math.clamp((x-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1)
                    value=math.floor(min+(max-min)*rel+0.5)
                    local rr=(value-min)/(max-min)
                    tween(Fill,{Size=UDim2.new(rr,0,1,0)},EASE_FAST)
                    tween(Knob,{Position=UDim2.new(rr,0,0.5,0)},EASE_FAST)
                    ValLbl.Text=tostring(value)
                    if key then SaveConfig:Set(key,value) end
                    if fire~=false and opt.Callback then pcall(opt.Callback,value) end
                end

                local function bd(i) dragging=true; updateX(i.Position.X) end
                Track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then bd(i) end end)
                Knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then bd(i) end end)
                UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then updateX(i.Position.X) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)

                if opt.Callback and value~=(opt.Default or min) then
                    task.defer(function() pcall(opt.Callback,value) end)
                end

                return {
                    Set = function(_,v) updateX(Track.AbsolutePosition.X+((math.clamp(v,min,max)-min)/(max-min))*Track.AbsoluteSize.X,false) end,
                    Get = function() return value end,
                }
            end

            function Section:AddDropdown(opt)
                opt = opt or {}
                local options = opt.Options or {}
                local key     = opt.SaveKey
                local selected = key and SaveConfig:Get(key, opt.Default or options[1]) or (opt.Default or options[1])
                local open = false

                local Holder = new("Frame", {
                    BackgroundColor3=Window.CurrentTheme.ElementBg,
                    Size=UDim2.new(1,0,0,ELEM_H), ClipsDescendants=true, ZIndex=2, Parent=Content,
                })
                corner(Holder,8); gradient(Holder,90,0,0.15)
                Window:_track(Holder,{BackgroundColor3="ElementBg"})

                local MainBtn = new("TextButton", {
                    Text="", AutoButtonColor=false, BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,ELEM_H), ZIndex=2, Parent=Holder,
                })
                local lbl = new("TextLabel", {
                    Text=opt.Text or "Dropdown", Font=Enum.Font.GothamMedium, TextSize=13,
                    TextColor3=Window.CurrentTheme.LabelColor,
                    BackgroundTransparency=1, Size=UDim2.new(0.5,0,0,ELEM_H),
                    Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left, ZIndex=2, Parent=Holder,
                })
                initTextStroke(lbl,1.1); trackText(lbl,1.1)

                local SelLbl = new("TextLabel", {
                    Text=tostring(selected or ""), Font=Enum.Font.GothamBold, TextSize=13,
                    TextColor3=Window.CurrentTheme.LabelColor,
                    BackgroundTransparency=1, Size=UDim2.new(0.45,-10,0,ELEM_H),
                    Position=UDim2.new(0.55,0,0,0), TextXAlignment=Enum.TextXAlignment.Right, ZIndex=2, Parent=Holder,
                })
                initTextStroke(SelLbl,1.1); trackText(SelLbl,1.1)

                local ListFrame = new("Frame", {
                    BackgroundTransparency=1, Size=UDim2.new(1,0,0,0),
                    Position=UDim2.new(0,0,0,ELEM_H+2), AutomaticSize=Enum.AutomaticSize.Y,
                    ZIndex=2, Parent=Holder,
                })
                new("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,Parent=ListFrame})

                local function rebuildList()
                    for _,c in ipairs(ListFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    for _,optName in ipairs(options) do
                        local oh=IsMobile and 34 or 26
                        local OB=new("TextButton",{
                            Text=tostring(optName), Font=Enum.Font.GothamMedium, TextSize=12,
                            TextColor3=Window.CurrentTheme.LabelColor,
                            BackgroundColor3=Window.CurrentTheme.Section,
                            AutoButtonColor=false, Size=UDim2.new(1,0,0,oh), ZIndex=2, Parent=ListFrame,
                        })
                        corner(OB,6); initTextStroke(OB,1); trackText(OB,1)
                        Window:_track(OB,{BackgroundColor3="Section"})
                        OB.MouseButton1Click:Connect(function()
                            selected=optName; SelLbl.Text=tostring(optName)
                            if key then SaveConfig:Set(key,optName) end
                            if opt.Callback then pcall(opt.Callback,optName) end
                        end)
                    end
                end
                rebuildList()

                MainBtn.MouseButton1Click:Connect(function()
                    open=not open
                    local oh=IsMobile and 34 or 26
                    tween(Holder,{Size=UDim2.new(1,0,0, open and ELEM_H+4+(#options*(oh+4)) or ELEM_H)},EASE_SMOOTH)
                end)

                if opt.Callback and selected then
                    task.defer(function() pcall(opt.Callback,selected) end)
                end

                return {
                    Set     = function(_,v) selected=v; SelLbl.Text=tostring(v) end,
                    Get     = function() return selected end,
                    Refresh = function(_,newOpts) options=newOpts; rebuildList() end,
                }
            end

            function Section:AddLabel(opt)
                opt = opt or {}
                local Lbl = new("TextLabel", {
                    Text=opt.Text or "", Font=Enum.Font.GothamMedium, TextSize=13,
                    TextColor3=Window.CurrentTheme.LabelColor,
                    BackgroundTransparency=1, TextWrapped=true,
                    Size=UDim2.new(1,0,0,20), AutomaticSize=Enum.AutomaticSize.Y,
                    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=2, Parent=Content,
                })
                initTextStroke(Lbl,1); trackText(Lbl,1)
                return { Set=function(_,t) Lbl.Text=t end }
            end

            function Section:AddKeybind(opt)
                opt = opt or {}
                local listening = false
                local savedKey = SaveConfig:Get("keybind_"..( opt.SaveKey or opt.Text or "default"), nil)
                if savedKey then
                    local kc = Enum.KeyCode[savedKey]
                    if kc then Window._keybind = kc end
                end

                local Holder = new("TextButton", {
                    Text="", AutoButtonColor=false,
                    BackgroundColor3=Window.CurrentTheme.ElementBg,
                    Size=UDim2.new(1,0,0,ELEM_H), ZIndex=2, Parent=Content,
                })
                corner(Holder,8); gradient(Holder,90,0,0.15)
                Window:_track(Holder,{BackgroundColor3="ElementBg"})

                local lbl = new("TextLabel", {
                    Text=opt.Text or "Keybind", Font=Enum.Font.GothamMedium, TextSize=13,
                    TextColor3=Window.CurrentTheme.LabelColor,
                    BackgroundTransparency=1, Size=UDim2.new(0.6,0,1,0),
                    Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left, ZIndex=2, Parent=Holder,
                })
                initTextStroke(lbl,1.1); trackText(lbl,1.1)

                local KeyBtn = new("TextButton", {
                    Text = Window._keybind and tostring(Window._keybind.Name) or "Unbound",
                    Font=Enum.Font.GothamBold, TextSize=12,
                    TextColor3=Window.CurrentTheme.LabelColor,
                    BackgroundColor3=Window.CurrentTheme.Section,
                    AutoButtonColor=false,
                    Size=UDim2.new(0,90,0,ELEM_H-8),
                    AnchorPoint=Vector2.new(1,0.5),
                    Position=UDim2.new(1,-8,0.5,0),
                    ZIndex=3, Parent=Holder,
                })
                corner(KeyBtn,6); initTextStroke(KeyBtn,1); trackText(KeyBtn,1)
                Window:_track(KeyBtn,{BackgroundColor3="Section"})
                Window._keybindLabel = KeyBtn

                local function setListen(v)
                    listening=v
                    if v then
                        KeyBtn.Text="Press any key..."
                        tween(KeyBtn,{BackgroundColor3=Window.CurrentTheme.Accent},EASE_FAST)
                    else
                        tween(KeyBtn,{BackgroundColor3=Window.CurrentTheme.Section},EASE_FAST)
                    end
                end
                KeyBtn.MouseButton1Click:Connect(function() setListen(true) end)
                Holder.MouseButton1Click:Connect(function() setListen(true) end)

                UserInputService.InputBegan:Connect(function(i,gp)
                    if not listening then return end
                    if i.UserInputType~=Enum.UserInputType.Keyboard then return end
                    if i.KeyCode==Enum.KeyCode.Escape then
                        Window._keybind=nil; KeyBtn.Text="Unbound"; setListen(false)
                        SaveConfig:Set("keybind_"..(opt.SaveKey or opt.Text or "default"), nil)
                        return
                    end
                    Window._keybind=i.KeyCode
                    KeyBtn.Text=tostring(i.KeyCode.Name)
                    SaveConfig:Set("keybind_"..(opt.SaveKey or opt.Text or "default"), i.KeyCode.Name)
                    setListen(false)
                    if opt.Callback then pcall(opt.Callback,i.KeyCode) end
                end)

                return {
                    GetKey = function() return Window._keybind end,
                    SetKey = function(_,kc) Window._keybind=kc; KeyBtn.Text=kc and tostring(kc.Name) or "Unbound" end,
                }
            end

            return Section
        end

        Window.Tabs[name] = Tab
        return Tab
    end

    if themeName ~= (config.Theme or "Dark") then
        task.defer(function() Window:SetTheme(themeName) end)
    end

    return Window
end

-- สิ่งที่สำคัญที่สุดในการทำ Library: ต้อง Return ค่าที่ถูกสร้างไว้ใน Table ออกไปให้สคริปต์อื่นดึงไปใช้ได้
return SiwOSLibrary
