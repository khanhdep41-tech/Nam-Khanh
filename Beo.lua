-- BEO | SERVER HOP
-- GUI màu hồng - Một nút chuyển server duy nhất

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local NguoiChoi = Players.LocalPlayer
local MaGame = game.PlaceId

local MauNen = Color3.fromRGB(35, 15, 35)
local MauHong = Color3.fromRGB(255, 65, 170)
local MauHongDam = Color3.fromRGB(180, 35, 110)
local MauChu = Color3.fromRGB(255, 255, 255)

-- GIAO DIỆN
local GiaoDien = Instance.new("ScreenGui")
GiaoDien.Name = "Beo_ServerHop"
GiaoDien.ResetOnSpawn = false

local ok, noiChua = pcall(function()
    if gethui then
        return gethui()
    end
    return game:GetService("CoreGui")
end)

if not ok or not noiChua then
    noiChua = NguoiChoi:WaitForChild("PlayerGui")
end

GiaoDien.Parent = noiChua

-- KHUNG CHÍNH
local Khung = Instance.new("Frame")
Khung.Name = "KhungChinh"
Khung.Parent = GiaoDien
Khung.Size = UDim2.new(0, 300, 0, 175)
Khung.Position = UDim2.new(0.5, -150, 0.5, -87)
Khung.BackgroundColor3 = MauNen
Khung.BorderSizePixel = 0
Khung.Active = true
Khung.Draggable = true

Instance.new("UICorner", Khung).CornerRadius = UDim.new(0, 12)

local Vien = Instance.new("UIStroke", Khung)
Vien.Color = MauHong
Vien.Thickness = 2

-- TIÊU ĐỀ
local TieuDe = Instance.new("TextLabel")
TieuDe.Parent = Khung
TieuDe.Position = UDim2.new(0, 12, 0, 5)
TieuDe.Size = UDim2.new(1, -50, 0, 35)
TieuDe.BackgroundTransparency = 1
TieuDe.Font = Enum.Font.GothamBold
TieuDe.Text = "BEO"
TieuDe.TextColor3 = MauHong
TieuDe.TextSize = 21
TieuDe.TextXAlignment = Enum.TextXAlignment.Left

-- NÚT ĐÓNG
local NutDong = Instance.new("TextButton")
NutDong.Parent = Khung
NutDong.Position = UDim2.new(1, -35, 0, 7)
NutDong.Size = UDim2.new(0, 27, 0, 27)
NutDong.BackgroundColor3 = MauHongDam
NutDong.Text = "X"
NutDong.TextColor3 = MauChu
NutDong.Font = Enum.Font.GothamBold
NutDong.TextSize = 14

Instance.new("UICorner", NutDong).CornerRadius = UDim.new(0, 7)

NutDong.MouseButton1Click:Connect(function()
    GiaoDien:Destroy()
end)

-- SỐ NGƯỜI CHƠI
local NhanNguoi = Instance.new("TextLabel")
NhanNguoi.Parent = Khung
NhanNguoi.Position = UDim2.new(0, 12, 0, 43)
NhanNguoi.Size = UDim2.new(1, -24, 0, 28)
NhanNguoi.BackgroundTransparency = 1
NhanNguoi.Font = Enum.Font.GothamBold
NhanNguoi.Text = "Số người trong server: ..."
NhanNguoi.TextColor3 = Color3.fromRGB(255, 190, 225)
NhanNguoi.TextSize = 13
NhanNguoi.TextXAlignment = Enum.TextXAlignment.Left

-- TRẠNG THÁI
local TrangThai = Instance.new("TextLabel")
TrangThai.Parent = Khung
TrangThai.Position = UDim2.new(0, 12, 0, 71)
TrangThai.Size = UDim2.new(1, -24, 0, 25)
TrangThai.BackgroundTransparency = 1
TrangThai.Font = Enum.Font.Gotham
TrangThai.Text = "Sẵn sàng chuyển server"
TrangThai.TextColor3 = MauChu
TrangThai.TextSize = 11
TrangThai.TextWrapped = true

-- MỘT NÚT CHUYỂN SERVER DUY NHẤT
local NutChuyen = Instance.new("TextButton")
NutChuyen.Parent = Khung
NutChuyen.Position = UDim2.new(0, 12, 0, 105)
NutChuyen.Size = UDim2.new(1, -24, 0, 55)
NutChuyen.BackgroundColor3 = MauHong
NutChuyen.BorderSizePixel = 0
NutChuyen.Font = Enum.Font.GothamBold
NutChuyen.Text = "CHUYỂN SERVER"
NutChuyen.TextColor3 = MauChu
NutChuyen.TextSize = 18

Instance.new("UICorner", NutChuyen).CornerRadius = UDim.new(0, 9)

-- CẬP NHẬT SỐ NGƯỜI CHƠI
task.spawn(function()
    while GiaoDien.Parent do
        NhanNguoi.Text =
            "Số người trong server: " .. #Players:GetPlayers()
        task.wait(1)
    end
end)

-- TÌM SERVER KHÁC
local function TimServer()
    local url =
        "https://games.roblox.com/v1/games/"
        .. MaGame
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

NutChuyen.MouseButton1Click:Connect(function()
    if dangChuyen then
        return
    end

    dangChuyen = true
    NutChuyen.Text = "ĐANG TÌM SERVER..."
    NutChuyen.BackgroundColor3 = MauHongDam
    TrangThai.Text = "Đang tìm server khác..."

    local serverId = TimServer()

    if not serverId then
        TrangThai.Text = "Không tìm được server. Thử lại nhé!"
        NutChuyen.Text = "CHUYỂN SERVER"
        NutChuyen.BackgroundColor3 = MauHong
        dangChuyen = false
        return
    end

    TrangThai.Text = "Đang chuyển sang server mới..."

    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(
            MaGame,
            serverId,
            NguoiChoi
        )
    end)

    if not ok then
        warn("Lỗi chuyển server: " .. tostring(err))
        TrangThai.Text = "Chuyển thất bại. Hãy thử lại!"
        NutChuyen.Text = "CHUYỂN SERVER"
        NutChuyen.BackgroundColor3 = MauHong
        dangChuyen = false
    end
end)

print("BEO Server Hop đã khởi chạy!")
