
--========================================================
-- NHẬT KHÁNH HUB | PINK SHADER EDITION
-- Graphics | Chili Hub | Server Hop | Re-execute
--========================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ENV = (getgenv and getgenv()) or _G

-- URL
local HUB_URL =
    "https://raw.githubusercontent.com/khanhdep41-tech/Nam-Khanh/refs/heads/main/khanh.lua"

local CHILI_URL =
    "https://raw.githubusercontent.com/tienkhanh1/Chilli-Hub-script/refs/heads/main/StealAnEgg"

local HOP_URL =
    "https://raw.githubusercontent.com/khanhdep41-tech/chuyen-sv/refs/heads/main/chuyen%20sv.lua"

-- DỌN BẢN CŨ
if ENV.NK_PinkShader_Unload then
    pcall(ENV.NK_PinkShader_Unload)
end

local connections = {}
local alive = true

local function track(c)
    table.insert(connections, c)
    return c
end

local function make(className, props, parent)
    local obj = Instance.new(className)
    for key, value in pairs(props) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius or 10)
    }, obj)
end

-- MÀU HỒNG PASTEL
local BG = Color3.fromRGB(35, 24, 38)
local BG2 = Color3.fromRGB(49, 33, 52)
local BG3 = Color3.fromRGB(65, 43, 67)
local PINK = Color3.fromRGB(244, 164, 194)
local PINK2 = Color3.fromRGB(255, 211, 226)
local WHITE = Color3.fromRGB(255, 245, 249)
local MUTED = Color3.fromRGB(211, 185, 201)

-- LƯU ÁNH SÁNG BAN ĐẦU
local original = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ColorShift_Top = Lighting.ColorShift_Top,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    GlobalShadows = Lighting.GlobalShadows,
    FogColor = Lighting.FogColor,
    FogEnd = Lighting.FogEnd,
    ExposureCompensation = Lighting.ExposureCompensation,
}

local originalEffects = {}

for _, obj in ipairs(Lighting:GetChildren()) do
    if obj:IsA("PostEffect") then
        originalEffects[obj] = obj.Enabled
    end
end

-- GUI ROOT
local oldGui = playerGui:FindFirstChild("NhatKhanhPinkShader")
if oldGui then
    oldGui:Destroy()
end

local gui = make("ScreenGui", {
    Name = "NhatKhanhPinkShader",
    ResetOnSpawn = false,
    DisplayOrder = 1000,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local function button(parent, text, position, size, color)
    local b = make("TextButton", {
        Position = position,
        Size = size,
        BackgroundColor3 = color or BG2,
        Text = text,
        TextColor3 = WHITE,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = true,
    }, parent)

    round(b, 9)

    make("UIStroke", {
        Color = PINK,
        Thickness = 1,
        Transparency = 0.5,
    }, b)

    return b
end

-- TỰ CHẠY LẠI SAU TELEPORT
local function queueReexecute()
    local queueFn =
        queue_on_teleport
        or queueonteleport
        or queueteleport

    if type(queueFn) ~= "function" then
        warn("[Nhật Khánh Hub] Executor không hỗ trợ queue-on-teleport.")
        return false
    end

    local code = string.format(
        'task.wait(3); loadstring(game:HttpGet(%q))()',
        HUB_URL
    )

    local ok, err = pcall(queueFn, code)

    if not ok then
        warn("[Nhật Khánh Hub] Queue lỗi: " .. tostring(err))
        return false
    end

    return true
end

-- TẢI SCRIPT NGOÀI
local function runExternal(url, label)
    task.spawn(function()
        local ok, err = pcall(function()
            local source = game:HttpGet(url)
            assert(type(source) == "string" and #source > 0,
                "Source rỗng")

            local fn, compileError = loadstring(source)
            assert(fn, compileError or "Không biên dịch được")

            fn()
        end)

        if not ok then
            warn("[Nhật Khánh Hub] " .. label .. ": " .. tostring(err))
        end
    end)
end

-- MENU HUB
local hub = make("Frame", {
    Name = "MenuHub",
    Size = UDim2.fromOffset(390, 420),
    Position = UDim2.new(1, -410, 0.5, -210),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    Active = true,
}, gui)

round(hub, 16)

make("UIStroke", {
    Color = PINK,
    Thickness = 2,
}, hub)

local hubTitle = make("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = BG2,
    Active = true,
}, hub)

round(hubTitle, 15)

make("TextLabel", {
    Size = UDim2.new(1, -105, 1, 0),
    Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1,
    Text = "♡ Nhật Khánh Hub",
    TextColor3 = WHITE,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, hubTitle)

local hideHub = button(
    hubTitle, "−",
    UDim2.new(1, -72, 0, 9),
    UDim2.fromOffset(29, 29)
)

local closeHub = button(
    hubTitle, "×",
    UDim2.new(1, -37, 0, 9),
    UDim2.fromOffset(29, 29)
)

local hubContent = make("ScrollingFrame", {
    Size = UDim2.new(1, -20, 1, -65),
    Position = UDim2.fromOffset(10, 57),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = PINK,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(0, 0, 0, 0),
}, hub)

make("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, hubContent)

local function addHubButton(label, callback)
    local b = button(
        hubContent,
        "   " .. label .. "   ›",
        UDim2.new(),
        UDim2.new(1, -5, 0, 43)
    )

    b.TextXAlignment = Enum.TextXAlignment.Left

    track(b.Activated:Connect(function()
        if alive then
            callback()
        end
    end))

    return b
end

-- MENU ĐỒ HỌA
local shader = make("Frame", {
    Name = "MenuDoHoa",
    Size = UDim2.fromOffset(270, 370),
    Position = UDim2.new(0, 18, 0.5, -185),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    Active = true,
}, gui)

round(shader, 14)

make("UIStroke", {
    Color = PINK,
    Thickness = 2,
}, shader)

local shaderTitle = make("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = BG2,
    Active = true,
}, shader)

round(shaderTitle, 13)

make("TextLabel", {
    Size = UDim2.new(1, -80, 1, 0),
    Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1,
    Text = "♡ ĐỒ HỌA",
    TextColor3 = PINK2,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, shaderTitle)

local hideShader = button(
    shaderTitle, "−",
    UDim2.new(1, -68, 0, 9),
    UDim2.fromOffset(29, 29)
)

local closeShader = button(
    shaderTitle, "×",
    UDim2.new(1, -34, 0, 9),
    UDim2.fromOffset(29, 29)
)

make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 24),
    Position = UDim2.fromOffset(10, 52),
    BackgroundTransparency = 1,
    Text = "CHỌN CHẾ ĐỘ ÁNH SÁNG",
    TextColor3 = MUTED,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
}, shader)

local modes = make("ScrollingFrame", {
    Size = UDim2.new(1, -18, 1, -88),
    Position = UDim2.fromOffset(9, 80),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = PINK,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(0, 0, 0, 0),
}, shader)

make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, modes)

make("UIPadding", {
    PaddingBottom = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 4),
}, modes)

local presets = {
    {
        name = "Ban ngày",
        time = 14,
        brightness = 2,
        ambient = Color3.fromRGB(150, 150, 150),
        outdoor = Color3.fromRGB(180, 180, 180),
        fog = Color3.fromRGB(200, 220, 255),
    },
    {
        name = "Hoàng hôn",
        time = 17.8,
        brightness = 2,
        ambient = Color3.fromRGB(150, 100, 100),
        outdoor = Color3.fromRGB(210, 125, 100),
        fog = Color3.fromRGB(255, 170, 130),
    },
    {
        name = "Ban đêm",
        time = 0,
        brightness = 1,
        ambient = Color3.fromRGB(45, 50, 90),
        outdoor = Color3.fromRGB(35, 40, 75),
        fog = Color3.fromRGB(35, 45, 80),
    },
    {
        name = "Nhiều mây",
        time = 12,
        brightness = 1.5,
        ambient = Color3.fromRGB(125, 125, 135),
        outdoor = Color3.fromRGB(145, 145, 155),
        fog = Color3.fromRGB(165, 170, 180),
    },
    {
        name = "Bờ biển",
        time = 13,
        brightness = 2,
        ambient = Color3.fromRGB(130, 175, 190),
        outdoor = Color3.fromRGB(165, 205, 220),
        fog = Color3.fromRGB(140, 210, 235),
    },
}

local function applyPreset(preset)
    Lighting.ClockTime = preset.time
    Lighting.Brightness = preset.brightness
    Lighting.Ambient = preset.ambient
    Lighting.OutdoorAmbient = preset.outdoor
    Lighting.FogColor = preset.fog
    Lighting.FogEnd = 100000
end

for _, preset in ipairs(presets) do
    local b = button(
        modes,
        preset.name,
        UDim2.new(),
        UDim2.new(1, -5, 0, 43)
    )

    track(b.Activated:Connect(function()
        applyPreset(preset)

        for _, child in ipairs(modes:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = BG2
                child.TextColor3 = WHITE
            end
        end

        b.BackgroundColor3 = PINK
        b.TextColor3 = BG
    end))
end

local restore = button(
    modes,
    "Khôi phục mặc định",
    UDim2.new(),
    UDim2.new(1, -5, 0, 43)
)

track(restore.Activated:Connect(function()
    for key, value in pairs(original) do
        pcall(function()
            Lighting[key] = value
        end)
    end

    for object, enabled in pairs(originalEffects) do
        pcall(function()
            if object.Parent then
                object.Enabled = enabled
            end
        end)
    end

    for _, child in ipairs(modes:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = BG2
            child.TextColor3 = WHITE
        end
    end
end))

-- NÚT NỔI NK
local floating = button(
    gui,
    "NK",
    UDim2.new(0, 15, 0.5, -25),
    UDim2.fromOffset(50, 50),
    PINK
)

floating.TextColor3 = BG
floating.TextSize = 17
floating.Visible = false
round(floating, 25)

-- HUB BUTTONS
addHubButton("Hiệu ứng đồ họa", function()
    shader.Visible = true
end)

addHubButton("Chili Hub", function()
    runExternal(CHILI_URL, "Chili Hub")
end)

addHubButton("Chuyển máy chủ", function()
    -- Xếp hàng tải lại trước khi gọi script chuyển server.
    queueReexecute()
    runExternal(HOP_URL, "Chuyển máy chủ")
end)

-- ẨN / HIỆN MENU
local function hideAll()
    hub.Visible = false
    shader.Visible = false
    floating.Visible = true
end

local function showAll()
    hub.Visible = true
    shader.Visible = true
    floating.Visible = false
end

track(hideHub.Activated:Connect(hideAll))
track(hideShader.Activated:Connect(hideAll))
track(floating.Activated:Connect(showAll))

track(closeHub.Activated:Connect(function()
    hub.Visible = false
    if not shader.Visible then
        floating.Visible = true
    end
end))

track(closeShader.Activated:Connect(function()
    shader.Visible = false
    if not hub.Visible then
        floating.Visible = true
    end
end))

-- KÉO THẢ MENU
local function makeDraggable(frame, handle)
    local dragging = false
    local startPosition
    local startPointer

    track(handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPosition = frame.Position
            startPointer = input.Position
        end
    end))

    track(UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - startPointer

            frame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end))

    track(UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
end

makeDraggable(hub, hubTitle)
makeDraggable(shader, shaderTitle)

-- DỌN KẾT NỐI
local function unload()
    if not alive then return end
    alive = false

    for _, connection in ipairs(connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    pcall(function()
        gui:Destroy()
    end)

    ENV.NK_PinkShader_Unload = nil
end

track(closeHub.Activated:Connect(unload))
track(closeShader.Activated:Connect(unload))

ENV.NK_PinkShader_Unload = unload

print("[Nhật Khánh Hub] Đã khởi chạy.")
