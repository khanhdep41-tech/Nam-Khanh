-- ⚡ TAM TRỤ GUI | RAINBOW SERVER HOP ⚡
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
-- MÀU SẮC
local MauNen = Color3.fromRGB(20, 15, 35)
local MauKhung = Color3.fromRGB(35, 25, 55)
local MauChu = Color3.fromRGB(255, 255, 255)
-- GIAO DIỆN
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TamTru_GUI"
ScreenGui.ResetOnSpawn = false
local ok, noiChua = pcall(function()
    if gethui then
        return gethui()
    end
    return game:GetService("CoreGui")
end)
if not ok or not noiChua then
    noiChua = LocalPlayer:WaitForChild("PlayerGui")
end
ScreenGui.Parent = noiChua
-- KHUNG CHÍNH
local MainFrame = Instance.new("Frame")
MainFrame.Name = "KhungChinh"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = MauNen
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -115)
MainFrame.Size = UDim2.new(0, 300, 0, 230)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius =
    UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(255, 0, 100)
Stroke.Thickness = 2.5
-- TIÊU ĐỀ
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -40, 0, 38)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundColor3 = MauKhung
Title.BackgroundTransparency = 0
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ TAM TRỤ ⚡"
Title.TextColor3 = MauChu
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
-- NÚT ĐÓNG
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Position = UDim2.new(1, -32, 0, 5)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 55)
CloseBtn.BorderSizePixel = 0
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = MauChu
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius =
    UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
-- SỐ NGƯỜI CHƠI
local NowLabel = Instance.new("TextLabel", MainFrame)
NowLabel.Position = UDim2.new(0, 12, 0, 45)
NowLabel.Size = UDim2.new(1, -24, 0, 24)
NowLabel.BackgroundTransparency = 1
NowLabel.Font = Enum.Font.GothamBold
NowLabel.TextXAlignment = Enum.TextXAlignment.Left
NowLabel.TextColor3 = Color3.fromRGB(120, 220, 255)
NowLabel.TextSize = 13
NowLabel.Text = "👥 Người chơi: ..."
-- TRẠNG THÁI
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Position = UDim2.new(0, 12, 0, 72)
StatusLabel.Size = UDim2.new(1, -24, 0, 32)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextColor3 = Color3.fromRGB(220, 220, 235)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.Text = "⚡ Sẵn sàng chuyển server"
-- NGƯỠNG NGƯỜI CHƠI
local MaxLabel = Instance.new("TextLabel", MainFrame)
MaxLabel.Position = UDim2.new(0, 12, 0, 108)
MaxLabel.Size = UDim2.new(1, -24, 0, 18)
MaxLabel.BackgroundTransparency = 1
MaxLabel.Font = Enum.Font.Gotham
MaxLabel.TextXAlignment = Enum.TextXAlignment.Left
MaxLabel.TextColor3 = Color3.fromRGB(190, 190, 210)
MaxLabel.TextSize = 11
MaxLabel.Text = "Tự động chuyển khi số người lớn hơn:"
local MaxBox = Instance.new("TextBox", MainFrame)
MaxBox.Position = UDim2.new(0, 12, 0, 128)
MaxBox.Size = UDim2.new(1, -24, 0, 27)
MaxBox.BackgroundColor3 = MauKhung
MaxBox.BorderSizePixel = 0
MaxBox.Font = Enum.Font.GothamBold
MaxBox.Text = "1"
MaxBox.TextColor3 = MauChu
MaxBox.TextSize = 14
MaxBox.ClearTextOnFocus = false
Instance.new("UICorner", MaxBox).CornerRadius =
    UDim.new(0, 6)
-- HÀM TẠO NÚT
local function TaoNut(ten, viTri, kichThuoc, mau)
    local nut = Instance.new("TextButton", MainFrame)
    nut.Position = viTri
    nut.Size = kichThuoc
    nut.BackgroundColor3 = mau
    nut.BorderSizePixel = 0
    nut.Font = Enum.Font.GothamBold
    nut.Text = ten
    nut.TextColor3 = MauChu
    nut.TextSize = 12
    Instance.new("UICorner", nut).CornerRadius =
        UDim.new(0, 7)
    return nut
end
-- NÚT CHUYỂN SERVER
local HopBtn = TaoNut(
    "⚡ HOP SERVER ⚡",
    UDim2.new(0, 12, 0, 165),
    UDim2.new(0, 130, 0, 48),
    Color3.fromRGB(140, 40, 200)
)
-- NÚT TỰ ĐỘNG
local AutoBtn = TaoNut(
    "TỰ ĐỘNG: TẮT",
    UDim2.new(0, 150, 0, 165),
    UDim2.new(0, 138, 0, 48),
    Color3.fromRGB(45, 90, 130)
)
-- HIỆU ỨNG CẦU VỒNG
task.spawn(function()
    local hue = 0
    while ScreenGui.Parent do
        hue = (hue + 0.005) % 1
        local mau = Color3.fromHSV(hue, 1, 1)
        Stroke.Color = mau
        Title.BackgroundColor3 = mau
        HopBtn.BackgroundColor3 = mau
        task.wait(0.03)
    end
end)
-- CẬP NHẬT SỐ NGƯỜI CHƠI
task.spawn(function()
    while ScreenGui.Parent do
        NowLabel.Text =
            "👥 Người chơi hiện tại: "
            .. #Players:GetPlayers()
        task.wait(1)
    end
end)
-- TÌM SERVER KHÁC
local function TimServer()
    local url =
        "https://games.roblox.com/v1/games/"
        .. PlaceId
        .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, raw = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not raw or raw == "" then
        return nil
    end
    local docDuLieu, data = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if not docDuLieu or not data or not data.data then
        return nil
    end
    local danhSach = {}
    for _, server in ipairs(data.data) do
        if server.id
            and server.id ~= game.JobId
            and server.playing < server.maxPlayers then
            table.insert(danhSach, server.id)
        end
    end
    if #danhSach == 0 then
        return nil
    end
    return danhSach[math.random(1, #danhSach)]
end
-- CHUYỂN SERVER
local dangChuyen = false
local function HopServer(boQuaNguong)
    if dangChuyen then
        return false
    end
    local nguong = math.max(
        1,
        math.floor(tonumber(MaxBox.Text) or 1)
    )
    local soNguoi = #Players:GetPlayers()
    if not boQuaNguong and soNguoi <= nguong then
        StatusLabel.Text =
            "✓ Server hiện tại đã đạt điều kiện."
        return false
    end
    dangChuyen = true
    StatusLabel.Text = "⚡ Đang tìm server..."
    HopBtn.Text = "ĐANG TÌM..."
    local serverId = TimServer()
    if not serverId then
        StatusLabel.Text =
            "Không tìm thấy server. Hãy thử lại."
        HopBtn.Text = "⚡ HOP SERVER ⚡"
        dangChuyen = false
        return false
    end
    StatusLabel.Text = "⚡ Đang chuyển server..."
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(
            PlaceId,
            serverId,
            LocalPlayer
        )
    end)
    if not ok then
        warn("Lỗi chuyển server: " .. tostring(err))
        StatusLabel.Text = "Chuyển thất bại. Thử lại nhé!"
        HopBtn.Text = "⚡ HOP SERVER ⚡"
        dangChuyen = false
        return false
    end
    return true
end
HopBtn.MouseButton1Click:Connect(function()
    HopServer(true)
end)
-- TỰ ĐỘNG CHUYỂN SERVER
local autoEnabled = false
AutoBtn.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    if autoEnabled then
        AutoBtn.Text = "TỰ ĐỘNG: BẬT"
        task.spawn(function()
            while autoEnabled and ScreenGui.Parent do
                if not dangChuyen then
                    local nguong = math.max(
                        1,
                        math.floor(tonumber(MaxBox.Text) or 1)
                    )
                    if #Players:GetPlayers() > nguong then
                        HopServer(false)
                    else
                        StatusLabel.Text =
                            "✓ Server đã đạt điều kiện."
                    end
                end
                task.wait(5)
            end
        end)
    else
        AutoBtn.Text = "TỰ ĐỘNG: TẮT"
        StatusLabel.Text = "Đã tắt tự động chuyển server."
    end
end)
print("⚡ TAM TRỤ GUI đã khởi chạy!")
