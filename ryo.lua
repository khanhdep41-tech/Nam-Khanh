-- RYO | HOP
-- Giao diện màu hồng - Một nút duy nhất
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local NguoiChoi = Players.LocalPlayer
local MaGame = game.PlaceId
local MauNen = Color3.fromRGB(35, 15, 35)
local MauHong = Color3.fromRGB(255, 70, 170)
local MauChu = Color3.fromRGB(255, 255, 255)
-- GIAO DIỆN
local GiaoDien = Instance.new("ScreenGui")
GiaoDien.Name = "RYO"
GiaoDien.ResetOnSpawn = false
local thanhCong, noiChua = pcall(function()
    if gethui then
        return gethui()
    end
    return game:GetService("CoreGui")
end)
if thanhCong and noiChua then
    GiaoDien.Parent = noiChua
else
    GiaoDien.Parent = NguoiChoi:WaitForChild("PlayerGui")
end
local Khung = Instance.new("Frame", GiaoDien)
Khung.Name = "KhungChinh"
Khung.Size = UDim2.new(0, 220, 0, 125)
Khung.Position = UDim2.new(0.5, -110, 0.5, -62)
Khung.BackgroundColor3 = MauNen
Khung.BorderSizePixel = 0
Khung.Active = true
Khung.Draggable = true
Instance.new("UICorner", Khung).CornerRadius = UDim.new(0, 12)
local Vien = Instance.new("UIStroke", Khung)
Vien.Color = MauHong
Vien.Thickness = 2
-- TIÊU ĐỀ
local TieuDe = Instance.new("TextLabel", Khung)
TieuDe.Size = UDim2.new(1, -40, 0, 38)
TieuDe.Position = UDim2.new(0, 10, 0, 0)
TieuDe.BackgroundTransparency = 1
TieuDe.Font = Enum.Font.GothamBold
TieuDe.Text = "RYO"
TieuDe.TextColor3 = MauHong
TieuDe.TextSize = 20
TieuDe.TextXAlignment = Enum.TextXAlignment.Left
-- NÚT ĐÓNG
local NutDong = Instance.new("TextButton", Khung)
NutDong.Size = UDim2.new(0, 28, 0, 28)
NutDong.Position = UDim2.new(1, -33, 0, 5)
NutDong.BackgroundColor3 = Color3.fromRGB(100, 30, 65)
NutDong.Text = "X"
NutDong.TextColor3 = MauChu
NutDong.Font = Enum.Font.GothamBold
NutDong.TextSize = 13
Instance.new("UICorner", NutDong).CornerRadius = UDim.new(0, 7)
-- TRẠNG THÁI
local TrangThai = Instance.new("TextLabel", Khung)
TrangThai.Size = UDim2.new(1, -20, 0, 22)
TrangThai.Position = UDim2.new(0, 10, 0, 38)
TrangThai.BackgroundTransparency = 1
TrangThai.Font = Enum.Font.Gotham
TrangThai.Text = "Sẵn sàng"
TrangThai.TextColor3 = MauChu
TrangThai.TextSize = 12
-- MỘT NÚT HOP DUY NHẤT
local NutHop = Instance.new("TextButton", Khung)
NutHop.Name = "NutHop"
NutHop.Size = UDim2.new(1, -20, 0, 48)
NutHop.Position = UDim2.new(0, 10, 0, 68)
NutHop.BackgroundColor3 = MauHong
NutHop.BorderSizePixel = 0
NutHop.Font = Enum.Font.GothamBold
NutHop.Text = "HOP"
NutHop.TextColor3 = MauChu
NutHop.TextSize = 18
Instance.new("UICorner", NutHop).CornerRadius = UDim.new(0, 9)
-- TÌM SERVER KHÁC
local dangHop = false
local function TimServer()
    local url = "https://games.roblox.com/v1/games/"
        .. MaGame
        .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, noiDung = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not noiDung then
        return nil
    end
    local docDuLieu, duLieu = pcall(function()
        return HttpService:JSONDecode(noiDung)
    end)
    if not docDuLieu or not duLieu or not duLieu.data then
        return nil
    end
    local danhSach = {}
    for _, server in ipairs(duLieu.data) do
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
NutHop.MouseButton1Click:Connect(function()
    if dangHop then
        return
    end
    dangHop = true
    NutHop.Text = "ĐANG TÌM..."
    TrangThai.Text = "Đang tìm server khác..."
    local maServer = TimServer()
    if not maServer then
        TrangThai.Text = "Không tìm thấy server"
        NutHop.Text = "HOP"
        dangHop = false
        return
    end
    TrangThai.Text = "Đang chuyển server..."
    local ok, loi = pcall(function()
        TeleportService:TeleportToPlaceInstance(
            MaGame,
            maServer,
            NguoiChoi
        )
    end)
    if not ok then
        warn("Lỗi chuyển server: " .. tostring(loi))
        TrangThai.Text = "Chuyển thất bại, thử lại"
        NutHop.Text = "HOP"
        dangHop = false
    end
end)
NutDong.MouseButton1Click:Connect(function()
    GiaoDien:Destroy()
end)
print("RYO đã khởi chạy")
