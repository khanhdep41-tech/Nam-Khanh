
--==================================================
-- NHẬT KHÁNH HUB | PINK EDITION
-- Chili Hub Vịt Hổ V3 | Server Hop | Simple Shader
-- FPS Ultra Boost | Draggable GUI | Floating NK
--==================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ENV = (getgenv and getgenv()) or _G
local LocalPlayer = Players.LocalPlayer

-- LINKS
local HUB_URL =
    "https://raw.githubusercontent.com/khanhdep41-tech/Nam-Khanh/refs/heads/main/khanh.lua"

local CHILI_URL =
    "https://apexhubeditor.vercel.app/api/raw?name=6bzPiAYUA0ekyyvhOhxpPobkK643_chilli-hub-vit-ho-v3"

local HOP_URL =
    "https://raw.githubusercontent.com/khanhdep41-tech/chuyen-sv/refs/heads/main/chuyen%20sv.lua"

local GRAPHICS_URL =
    "https://raw.githubusercontent.com/p0e1/1/refs/heads/main/SimpleShader.lua"

-- CLEAN OLD GUI
if ENV.NK_PinkHub_Unload then
    pcall(ENV.NK_PinkHub_Unload)
end

pcall(function()
    local old = CoreGui:FindFirstChild("NhatKhanhHub")
    if old then old:Destroy() end
end)

-- COLORS
local PINK = Color3.fromRGB(255, 105, 180)
local DARK_PINK = Color3.fromRGB(190, 55, 125)
local PALE_PINK = Color3.fromRGB(255, 220, 238)
local WHITE = Color3.fromRGB(255, 255, 255)
local DARK = Color3.fromRGB(35, 25, 40)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NhatKhanhHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentOK = pcall(function()
    gui.Parent = CoreGui
end)

if not parentOK then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function addCorner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
end

local function addStroke(obj)
    local s = Instance.new("UIStroke")
    s.Color = PINK
    s.Thickness = 1.5
    s.Parent = obj
end

-- MAIN WINDOW
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.fromOffset(285, 285)
main.Position = UDim2.new(0.5, -142, 0.5, -142)
main.BackgroundColor3 = DARK
main.BorderSizePixel = 0
main.Parent = gui
addCorner(main, 14)
addStroke(main)

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 43)
header.BackgroundColor3 = DARK_PINK
header.BorderSizePixel = 0
header.Parent = main
addCorner(header, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -78, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ NHẬT KHÁNH HUB"
title.TextColor3 = WHITE
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(28, 28)
minimize.Position = UDim2.new(1, -64, 0, 7)
minimize.BackgroundColor3 = PALE_PINK
minimize.Text = "—"
minimize.TextColor3 = DARK_PINK
minimize.TextSize = 18
minimize.Font = Enum.Font.GothamBold
minimize.Parent = header
addCorner(minimize, 8)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(28, 28)
close.Position = UDim2.new(1, -32, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(255, 75, 100)
close.Text = "×"
close.TextColor3 = WHITE
close.TextSize = 20
close.Font = Enum.Font.GothamBold
close.Parent = header
addCorner(close, 8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 22)
status.Position = UDim2.fromOffset(10, 47)
status.BackgroundTransparency = 1
status.Text = "Chọn chức năng bạn muốn sử dụng"
status.TextColor3 = PALE_PINK
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.Parent = main

-- EXTERNAL SCRIPT LOADER
local function runExternal(url, label)
    status.Text = "Đang tải " .. label .. "..."

    task.spawn(function()
        local ok, err = pcall(function()
            local response = game:HttpGet(url)
            assert(type(response) == "string" and #response > 0,
                "Không nhận được mã script")

            local fn, compileErr = loadstring(response)
            assert(fn, compileErr or "Không biên dịch được script")
            fn()
        end)

        if ok then
            status.Text = label .. " đã được khởi chạy"
        else
            status.Text = "Lỗi tải " .. label
            warn("[NhatKhanhHub] " .. tostring(err))
        end
    end)
end

-- QUEUE RE-EXECUTE AFTER TELEPORT
local function queueReexecute()
    local queueFn =
        ENV.queue_on_teleport
        or ENV.queueonteleport
        or ENV.queueteleport
        or queue_on_teleport
        or queueonteleport
        or queueteleport

    if type(queueFn) ~= "function" then
        warn("[NhatKhanhHub] Executor không hỗ trợ queue_on_teleport")
        return false
    end

    local code = string.format(
        'task.wait(4); loadstring(game:HttpGet(%q))()',
        HUB_URL
    )

    local ok, err = pcall(queueFn, code)
    if not ok then
        warn("[NhatKhanhHub] Queue thất bại: " .. tostring(err))
        return false
    end

    return true
end

-- BUTTON CREATOR
local function makeButton(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -24, 0, 38)
    b.Position = UDim2.fromOffset(12, y)
    b.BackgroundColor3 = PINK
    b.Text = text
    b.TextColor3 = WHITE
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = true
    b.Parent = main
    addCorner(b, 9)

    b.MouseButton1Click:Connect(callback)

    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {
            BackgroundColor3 = DARK_PINK
        }):Play()
    end)

    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {
            BackgroundColor3 = PINK
        }):Play()
    end)

    return b
end

-- CHILI HUB
makeButton("🔥  Chili Hub Vịt Hổ V3", 75, function()
    runExternal(CHILI_URL, "Chili Hub")
end)

-- SERVER HOP
makeButton("🌐  Chuyển máy chủ", 119, function()
    queueReexecute()
    runExternal(HOP_URL, "Chuyển máy chủ")
end)

-- ORIGINAL GRAPHICS SCRIPT
makeButton("🌈  Load Script Đồ Họa", 163, function()
    runExternal(GRAPHICS_URL, "Script đồ họa")
end)

-- FPS ULTRA BOOST
local fpsEnabled = false
local saved = {
    parts = {},
    lighting = {},
    effects = {},
    terrainDecoration = nil,
    quality = nil
}

local function saveLightingProperty(property)
    if saved.lighting[property] == nil then
        local ok, value = pcall(function()
            return Lighting[property]
        end)
        if ok then
            saved.lighting[property] = value
        end
    end
end

local function saveAndDisableEffect(obj)
    if obj:IsA("PostEffect") or obj:IsA("ParticleEmitter")
        or obj:IsA("Trail") or obj:IsA("Beam")
        or obj:IsA("Fire") or obj:IsA("Smoke")
        or obj:IsA("Sparkles") or obj:IsA("Clouds") then

        if saved.effects[obj] == nil then
            saved.effects[obj] = obj.Enabled
        end

        pcall(function()
            obj.Enabled = false
        end)
    elseif obj:IsA("Atmosphere") then
        if saved.effects[obj] == nil then
            saved.effects[obj] = {
                Density = obj.Density,
                Haze = obj.Haze,
                Glare = obj.Glare
            }
        end

        pcall(function()
            obj.Density = 0
            obj.Haze = 0
            obj.Glare = 0
        end)
    end
end

local function enableFPSBoost()
    saveLightingProperty("GlobalShadows")
    saveLightingProperty("FogEnd")
    saveLightingProperty("EnvironmentDiffuseScale")
    saveLightingProperty("EnvironmentSpecularScale")

    saved.terrainDecoration = Workspace.Terrain.Decoration

    pcall(function()
        saved.quality = settings().Rendering.QualityLevel
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    for _, obj in ipairs(Lighting:GetDescendants()) do
        saveAndDisableEffect(obj)
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if saved.parts[obj] == nil then
                saved.parts[obj] = {
                    Material = obj.Material,
                    Reflectance = obj.Reflectance
                }
            end

            pcall(function()
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end)
        else
            saveAndDisableEffect(obj)
        end
    end

    pcall(function()
        Workspace.Terrain.Decoration = false
    end)
end

local function disableFPSBoost()
    for property, value in pairs(saved.lighting) do
        pcall(function()
            Lighting[property] = value
        end)
    end

    for obj, old in pairs(saved.parts) do
        if obj and obj.Parent then
            pcall(function()
                obj.Material = old.Material
                obj.Reflectance = old.Reflectance
            end)
        end
    end

    for obj, old in pairs(saved.effects) do
        if obj and obj.Parent then
            pcall(function()
                if type(old) == "table" then
                    obj.Density = old.Density
                    obj.Haze = old.Haze
                    obj.Glare = old.Glare
                else
                    obj.Enabled = old
                end
            end)
        end
    end

    if saved.terrainDecoration ~= nil then
        pcall(function()
            Workspace.Terrain.Decoration = saved.terrainDecoration
        end)
    end

    if saved.quality ~= nil then
        pcall(function()
            settings().Rendering.QualityLevel = saved.quality
        end)
    end

    saved.parts = {}
    saved.effects = {}
    saved.lighting = {}
    saved.terrainDecoration = nil
    saved.quality = nil
end

local fpsButton = makeButton("🚀  FPS ULTRA BOOST: OFF", 207, function()
    fpsEnabled = not fpsEnabled

    if fpsEnabled then
        local ok, err = pcall(enableFPSBoost)

        if ok then
            fpsButton.Text = "🚀  FPS ULTRA BOOST: ON"
            status.Text = "Đã bật giảm hiệu ứng đồ họa"
        else
            fpsEnabled = false
            status.Text = "Không bật được FPS Boost"
            warn("[NhatKhanhHub] FPS Boost: " .. tostring(err))
        end
    else
        local ok, err = pcall(disableFPSBoost)

        fpsButton.Text = "🚀  FPS ULTRA BOOST: OFF"
        status.Text = ok and "Đã khôi phục thiết lập đã lưu"
            or "Có lỗi khi khôi phục đồ họa"

        if not ok then
            warn("[NhatKhanhHub] Restore: " .. tostring(err))
        end
    end
end)

-- DRAG WINDOW
local dragging = false
local dragInput
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

-- FLOATING NK ICON
local floating = Instance.new("TextButton")
floating.Name = "NKFloating"
floating.Size = UDim2.fromOffset(48, 48)
floating.Position = UDim2.new(0, 18, 0.45, 0)
floating.BackgroundColor3 = DARK_PINK
floating.Text = "NK"
floating.TextColor3 = WHITE
floating.TextSize = 17
floating.Font = Enum.Font.GothamBold
floating.Visible = false
floating.Parent = gui
addCorner(floating, 24)
addStroke(floating)

floating.MouseButton1Click:Connect(function()
    main.Visible = true
    floating.Visible = false
end)

minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    floating.Visible = true
end)

-- CLEANUP
local function unload()
    if fpsEnabled then
        pcall(disableFPSBoost)
    end

    pcall(function()
        gui:Destroy()
    end)

    ENV.NK_PinkHub_Unload = nil
end

close.MouseButton1Click:Connect(unload)
ENV.NK_PinkHub_Unload = unload

print("[NhatKhanhHub] Loaded successfully")
