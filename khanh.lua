
--==================================================
-- NHẬT KHÁNH HUB - STEAL AN EGG
-- Giao diện hồng pastel | Tiếng Việt
-- Kéo thả | Thu nhỏ | Nút nổi | Hai tab
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local ENV = (getgenv and getgenv()) or _G

if ENV.NhatKhanhHubUnload then
    pcall(ENV.NhatKhanhHubUnload)
end

--==================== MÀU SẮC ====================

local BG      = Color3.fromRGB(30, 22, 32)
local BG2     = Color3.fromRGB(43, 31, 46)
local BG3     = Color3.fromRGB(59, 41, 62)
local PINK    = Color3.fromRGB(244, 164, 194)
local PINK2   = Color3.fromRGB(255, 205, 220)
local TEXT    = Color3.fromRGB(255, 243, 248)
local MUTED   = Color3.fromRGB(205, 180, 195)
local RED     = Color3.fromRGB(255, 105, 130)

local QUICK = TweenInfo.new(
    0.18,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

local Connections = {}
local function track(connection)
    table.insert(Connections, connection)
    return connection
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
        CornerRadius = UDim.new(0, radius or 8)
    }, obj)
end

local function animate(obj, info, props)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

--==================== GUI ROOT ====================

local gui = Instance.new("ScreenGui")
gui.Name = "NhatKhanhHub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parented = false

if gethui then
    parented = pcall(function()
        gui.Parent = gethui()
    end)
end

if not parented or not gui.Parent then
    parented = pcall(function()
        gui.Parent = CoreGui
    end)
end

if not parented or not gui.Parent then
    gui.Parent = LP:WaitForChild("PlayerGui")
end

--==================== THÔNG BÁO ====================

local popupHolder = make("Frame", {
    Name = "ThongBao",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 100,
}, gui)

make("UIListLayout", {
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    Padding = UDim.new(0, 8),
}, popupHolder)

make("UIPadding", {
    PaddingTop = UDim.new(0, 12),
}, popupHolder)

local function notify(title, message, duration, isError)
    local color = isError and RED or PINK

    local card = make("Frame", {
        Size = UDim2.new(0, 290, 0, 66),
        BackgroundColor3 = BG2,
        BackgroundTransparency = 0.05,
        ZIndex = 100,
    }, popupHolder)

    round(card, 10)

    make("UIStroke", {
        Color = color,
        Thickness = 1.5,
    }, card)

    make("TextLabel", {
        Size = UDim2.new(1, -20, 0, 24),
        Position = UDim2.new(0, 10, 0, 7),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = color,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101,
    }, card)

    make("TextLabel", {
        Size = UDim2.new(1, -20, 0, 28),
        Position = UDim2.new(0, 10, 0, 32),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = TEXT,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101,
    }, card)

    task.delay(duration or 3, function()
        if card.Parent then
            animate(card, QUICK, {
                BackgroundTransparency = 1
            })
            task.wait(0.2)
            if card.Parent then
                card:Destroy()
            end
        end
    end)
end

--==================== CỬA SỔ CHÍNH ====================

local function getSize()
    local camera = Workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize
        or Vector2.new(400, 700)

    return math.clamp(viewport.X - 24, 290, 460),
           math.clamp(viewport.Y - 80, 350, 520)
end

local W, H = getSize()

local main = make("Frame", {
    Name = "CuaSoChinh",
    Size = UDim2.new(0, W, 0, H),
    Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    Active = true,
    ClipsDescendants = true,
}, gui)

round(main, 14)

local mainStroke = make("UIStroke", {
    Color = PINK,
    Thickness = 2,
}, main)

-- Thanh tiêu đề
local titleBar = make("Frame", {
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = BG2,
    BorderSizePixel = 0,
}, main)

round(titleBar, 14)

make("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = BG2,
    BorderSizePixel = 0,
}, titleBar)

local logo = make("Frame", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(0, 9, 0.5, -15),
    BackgroundColor3 = PINK,
}, titleBar)

round(logo, 9)

make("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "NK",
    TextColor3 = BG,
    TextSize = 14,
    Font = Enum.Font.GothamBlack,
}, logo)

make("TextLabel", {
    Size = UDim2.new(1, -125, 1, 0),
    Position = UDim2.new(0, 47, 0, 0),
    BackgroundTransparency = 1,
    Text = "Nhật Khánh Hub",
    TextColor3 = TEXT,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
}, titleBar)

local function topButton(label, offset)
    local button = make("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, offset, 0, 8),
        BackgroundColor3 = BG3,
        Text = label,
        TextColor3 = TEXT,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
    }, titleBar)

    round(button, 8)

    track(button.MouseEnter:Connect(function()
        animate(button, QUICK, {
            BackgroundColor3 = PINK
        })
    end))

    track(button.MouseLeave:Connect(function()
        animate(button, QUICK, {
            BackgroundColor3 = BG3
        })
    end))

    return button
end

local minButton = topButton("−", -72)
local closeButton = topButton("×", -36)

--==================== KÉO THẢ CỬA SỔ ====================

do
    local dragging = false
    local dragStart
    local startPosition

    track(titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = main.Position

            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end))

    track(UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart

            main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end))
end

--==================== TAB ====================

local tabBar = make("Frame", {
    Size = UDim2.new(1, -16, 0, 36),
    Position = UDim2.new(0, 8, 0, 52),
    BackgroundColor3 = BG2,
}, main)

round(tabBar, 9)

local tabArea = make("Frame", {
    Size = UDim2.new(1, -6, 1, -6),
    Position = UDim2.new(0, 3, 0, 3),
    BackgroundTransparency = 1,
}, tabBar)

local selector = make("Frame", {
    Size = UDim2.new(0.5, -2, 1, 0),
    BackgroundColor3 = PINK,
    ZIndex = 1,
}, tabArea)

round(selector, 7)

local content = make("Frame", {
    Size = UDim2.new(1, -16, 1, -98),
    Position = UDim2.new(0, 8, 0, 94),
    BackgroundTransparency = 1,
}, main)

local tabs = {}
local tabButtons = {}
local currentTab

local function addTab(name, index)
    local button = make("TextButton", {
        Size = UDim2.new(0.5, -2, 1, 0),
        Position = index == 1
            and UDim2.new(0, 0, 0, 0)
            or UDim2.new(0.5, 2, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = TEXT,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        ZIndex = 2,
    }, tabArea)

    local frame = make("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = PINK,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
    }, content)

    make("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, frame)

    make("UIPadding", {
        PaddingBottom = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
    }, frame)

    tabs[name] = frame
    tabButtons[name] = button

    track(button.Activated:Connect(function()
        if currentTab == name then return end

        currentTab = name

        for tabName, tabFrame in pairs(tabs) do
            tabFrame.Visible = tabName == name
        end

        for tabName, tabButton in pairs(tabButtons) do
            tabButton.TextColor3 =
                tabName == name and BG or TEXT
        end

        animate(selector, QUICK, {
            Position = button.Position,
            Size = button.Size,
        })
    end))

    return frame
end

--==================== NÚT HUB ====================

local function addHubButton(parent, label, url)
    local button = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = BG2,
        Text = "",
        AutoButtonColor = false,
    }, parent)

    round(button, 9)

    local stroke = make("UIStroke", {
        Color = PINK,
        Thickness = 1,
        Transparency = 0.5,
    }, button)

    make("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = TEXT,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, button)

    make("TextLabel", {
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = "›",
        TextColor3 = PINK2,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
    }, button)

    track(button.MouseEnter:Connect(function()
        animate(button, QUICK, {
            BackgroundColor3 = BG3
        })
        stroke.Transparency = 0
    end))

    track(button.MouseLeave:Connect(function()
        animate(button, QUICK, {
            BackgroundColor3 = BG2
        })
        stroke.Transparency = 0.5
    end))

    track(button.Activated:Connect(function()
        notify("Nhật Khánh Hub", "Đang tải: " .. label, 3)

        task.spawn(function()
            local ok, err = pcall(function()
                local source = game:HttpGet(url)
                local fn = loadstring(source)

                assert(fn, "Không biên dịch được source")
                fn()
            end)

            if not ok then
                notify(
                    "Không thể chạy " .. label,
                    tostring(err),
                    5,
                    true
                )
            end
        end)
    end))

    return button
end

--==================== DANH SÁCH HUB ====================

local keyless = addTab("Không cần key", 1)
local keyTab = addTab("Có key", 2)

-- Tab không cần key
addHubButton(
    keyless,
    "Hiệu ứng đồ họa",
    "https://raw.githubusercontent.com/robloxscripts2026/simple-shader/refs/heads/main/lua"
)

addHubButton(
    keyless,
    "Miranda Hub",
    "https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/afkk"
)

addHubButton(
    keyless,
    "Pulse Hub",
    "https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua"
)

addHubButton(
    keyless,
    "Lennon Hub",
    "https://raw.githubusercontent.com/lennonxscripts/lennonhubv4/refs/heads/main/stealanegg"
)

addHubButton(
    keyless,
    "Sena Hub",
    "https://raw.githubusercontent.com/ronnei/Ronnie.HTK/refs/heads/main/solixhub-keyless.lua"
)

addHubButton(
    keyless,
    "Chili Hub",
    "https://raw.githubusercontent.com/tienkhanh1/Chilli-Hub-script/refs/heads/main/StealAnEgg"
)

addHubButton(
    keyless,
    "Yokudo Hub",
    "https://raw.githubusercontent.com/ahchlon/stealanegg/refs/heads/main/Loader.lua"
)

addHubButton(
    keyless,
    "Chuyển máy chủ",
    "https://raw.githubusercontent.com/RealBatu20/AI-Scripts-2025/refs/heads/main/LowServerFinderGUI.lua"
)

addHubButton(
    keyless,
    "Chuyển máy chủ V2",
    "https://pastefy.app/YoZocJ8O/raw"
)

-- Tab có key
addHubButton(
    keyTab,
    "Cộng đồng Fyy",
    "https://FyyCommunity.com"
)

addHubButton(
    keyTab,
    "Tsuo Hub",
    "https://raw.githubusercontent.com/Tsuo7/TsuoHub/main/stealanegg"
)

addHubButton(
    keyTab,
    "Limbo Hub",
    "https://limbohub.my.id/loader.lua"
)

addHubButton(
    keyTab,
    "Vortex Hub",
    "https://raw.githubusercontent.com/Israel-Vortex/vortex-x-scripts/refs/heads/main/Official-Vortex-Software/Dev-Project/StealAnEgg.lua"
)

addHubButton(
    keyTab,
    "Neo Hub",
    "https://raw.githubusercontent.com/noehubdev/script/main/scrpit"
)

-- Chọn tab đầu tiên
currentTab = "Không cần key"
tabs[currentTab].Visible = true
tabButtons[currentTab].TextColor3 = BG

--==================== NÚT NỔI ====================

local floating = make("TextButton", {
    Name = "NutNoi",
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 14, 0.5, -25),
    BackgroundColor3 = PINK,
    Text = "NK",
    TextColor3 = BG,
    TextSize = 16,
    Font = Enum.Font.GothamBlack,
    Visible = false,
    ZIndex = 20,
}, gui)

round(floating, 25)

make("UIStroke", {
    Color = PINK2,
    Thickness = 2,
}, floating)

-- Kéo nút nổi
do
    local dragging = false
    local moved = false
    local dragStart
    local startPosition

    track(floating.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPosition = floating.Position

            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end))

    track(UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart

            if delta.Magnitude > 6 then
                moved = true
            end

            floating.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end))

    track(floating.Activated:Connect(function()
        if moved then return end

        floating.Visible = false
        main.Visible = true

        local nw, nh = getSize()
        animate(main, QUICK, {
            Size = UDim2.new(0, nw, 0, nh),
            Position = UDim2.new(
                0.5, -nw / 2,
                0.5, -nh / 2
            ),
        })
    end))
end

--==================== THU NHỎ / ĐÓNG ====================

track(minButton.Activated:Connect(function()
    main.Visible = false
    floating.Visible = true
end))

local function unload()
    for _, connection in ipairs(Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    pcall(function()
        gui:Destroy()
    end)

    ENV.NhatKhanhHubUnload = nil
end

track(closeButton.Activated:Connect(function()
    unload()
end))

-- Hiệu ứng viền hồng nhẹ
task.spawn(function()
    while gui.Parent do
        animate(mainStroke, TweenInfo.new(1.2), {
            Color = PINK2
        })
        task.wait(1.2)

        if not gui.Parent then break end

        animate(mainStroke, TweenInfo.new(1.2), {
            Color = PINK
        })
        task.wait(1.2)
    end
end)

ENV.NhatKhanhHubUnload = unload

notify(
    "Nhật Khánh Hub",
    "Giao diện đã khởi chạy!",
    3
)
