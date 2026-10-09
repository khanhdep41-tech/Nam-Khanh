-- NAM KHÁNH HUB | SERVER HOP
-- Giao diện xanh nước biển - Việt hóa
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local NguoiChoi = Players.LocalPlayer
local MaGame = game.PlaceId
local MauNen = Color3.fromRGB(15, 25, 45)
local MauKhung = Color3.fromRGB(25, 45, 75)
local MauXanh = Color3.fromRGB(0, 140, 255)
local MauChu = Color3.fromRGB(255, 255, 255)
-- GIAO DIỆN
local GiaoDien = Instance.new("ScreenGui")
GiaoDien.Name = "NamKhanhHub"
GiaoDien.ResetOnSpawn = false
if gethui then
    GiaoDien.Parent = gethui()
else
    GiaoDien.Parent = game:GetService("CoreGui")
end
local Khung = Instance.new("Frame")
Khung.Parent = GiaoDien
Khung.BackgroundColor3 = MauNen
Khung.BorderSizePixel = 0
Khung.Position = UDim2.new(0.5, -150, 0.5, -115)
Khung.Size = UDim2.new(0, 300, 0, 230)
Khung.Active = true
Khung.Draggable = true
Instance.new("UICorner", Khung).CornerRadius = UDim.new(0, 10)
local Vien = Instance.new("UIStroke", Khung)
Vien.Color = MauXanh
Vien.Thickness = 2
local TieuDe = Instance.new("TextLabel", Khung)
TieuDe.Size = UDim2.new(1, -35, 0, 38)
TieuDe.Position = UDim2.new(0, 8, 0, 0)
TieuDe.BackgroundTransparency = 1
TieuDe.Font = Enum.Font.GothamBold
TieuDe.Text = "NAM KHÁNH HUB"
TieuDe.TextColor3 = MauChu
TieuDe.TextSize = 17
TieuDe.TextXAlignment = Enum.TextXAlignment.Left
local Dong = Instance.new("TextButton", Khung)
Dong.Size = UDim2.new(0, 30, 0, 30)
Dong.Position = UDim2.new(1, -34, 0, 4)
Dong.BackgroundColor3 = Color3.fromRGB(180, 45, 55)
Dong.Text = "X"
Dong.TextColor3 = MauChu
Dong.Font = Enum.Font.GothamBold
Dong.TextSize = 14
Instance.new("UICorner", Dong).CornerRadius = UDim.new(0, 6)
Dong.MouseButton1Click:Connect(function()
    GiaoDien:Destroy()
end)
local NguoiLabel = Instance.new("TextLabel", Khung)
NguoiLabel.Position = UDim2.new(0, 12, 0, 45)
NguoiLabel.Size = UDim2.new(1, -24, 0, 24)
NguoiLabel.BackgroundTransparency = 1
NguoiLabel.Font = Enum.Font.GothamBold
NguoiLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
NguoiLabel.TextSize = 13
NguoiLabel.TextXAlignment = Enum.TextXAlignment.Left
NguoiLabel.Text = "Người chơi hiện tại: ..."
local TrangThai = Instance.new("TextLabel", Khung)
TrangThai.Position = UDim2.new(0, 12, 0, 72)
TrangThai.Size = UDim2.new(1, -24, 0, 35)
TrangThai.BackgroundTransparency = 1
TrangThai.Font = Enum.Font.Gotham
TrangThai.TextColor3 = MauChu
TrangThai.TextSize = 12
TrangThai.TextWrapped = true
TrangThai.TextXAlignment = Enum.TextXAlignment.Left
TrangThai.Text = "Sẵn sàng chuyển máy chủ."
local NhanNguong = Instance.new("TextLabel", Khung)
NhanNguong.Position = UDim2.new(0, 12, 0, 111)
NhanNguong.Size = UDim2.new(1, -24, 0, 20)
NhanNguong.BackgroundTransparency = 1
NhanNguong.Font = Enum.Font.Gotham
NhanNguong.Text = "Chuyển khi số người chơi lớn hơn:"
NhanNguong.TextColor3 = Color3.fromRGB(190, 210, 230)
NhanNguong.TextSize = 12
NhanNguong.TextXAlignment = Enum.TextXAlignment.Left
local ONhap = Instance.new("TextBox", Khung)
ONhap.Position = UDim2.new(0, 12, 0, 134)
ONhap.Size = UDim2.new(1, -24, 0, 28)
ONhap.BackgroundColor3 = MauKhung
ONhap.BorderSizePixel = 0
ONhap.Font = Enum.Font.GothamBold
ONhap.Text = "1"
ONhap.TextColor3 = MauChu
ONhap.TextSize = 14
ONhap.ClearTextOnFocus = false
Instance.new("UICorner", ONhap).CornerRadius = UDim.new(0, 6)
local function TaoNut(ten, viTri, kichThuoc, mau)
    local nut = Instance.new("TextButton", Khung)
    nut.Position = viTri
    nut.Size = kichThuoc
    nut.BackgroundColor3 = mau
    nut.BorderSizePixel = 0
    nut.Font = Enum.Font.GothamBold
    nut.Text = ten
    nut.TextColor3 = MauChu
    nut.TextSize = 12
    Instance.new("UICorner", nut).CornerRadius = UDim.new(0, 7)
    return nut
end
local NutChuyen = TaoNut(
    "CHUYỂN NGAY",
    UDim2.new(0, 12, 0, 174),
    UDim2.new(0, 130, 0, 43),
    MauXanh
)
local NutTuDong = TaoNut(
    "TỰ ĐỘNG: TẮT",
    UDim2.new(0, 150, 0, 174),
    UDim2.new(0, 138, 0, 43),
    Color3.fromRGB(35, 115, 75)
)
-- CẬP NHẬT SỐ NGƯỜI CHƠI
task.spawn(function()
    while GiaoDien.Parent do
        NguoiLabel.Text =
            "Người chơi hiện tại: " .. #Players:GetPlayers()
        task.wait(1)
    end
end)
-- TÌM MÁY CHỦ KHÁC
local function TimMayChu()
    local url = "https://games.roblox.com/v1/games/"
        .. MaGame
        .. "/servers/Public?sortOrder=Asc&limit=100"
    local thanhCong, noiDung = pcall(function()
        return game:HttpGet(url)
    end)
    if not thanhCong or not noiDung then
        return nil
    end
    local docDuLieu, duLieu = pcall(function()
        return HttpService:JSONDecode(noiDung)
    end)
    if not docDuLieu or not duLieu.data then
        return nil
    end
    local danhSach = {}
    for _, mayChu in ipairs(duLieu.data) do
        if mayChu.id
            and mayChu.id ~= game.JobId
            and mayChu.playing < mayChu.maxPlayers then
            table.insert(danhSach, mayChu.id)
        end
    end
    if #danhSach == 0 then
        return nil
    end
    return danhSach[math.random(1, #danhSach)]
end
local dangChuyen = false
local function ChuyenMayChu(boQuaNguong)
    if dangChuyen then
        return false
    end
    local nguong = math.max(
        1,
        math.floor(tonumber(ONhap.Text) or 1)
    )
    local soNguoi = #Players:GetPlayers()
    if not boQuaNguong and soNguoi <= nguong then
        TrangThai.Text = "Máy chủ hiện tại đã đạt điều kiện."
        return false
    end
    dangChuyen = true
    TrangThai.Text = "Đang tìm máy chủ khác..."
    local maMayChu = TimMayChu()
    if not maMayChu then
        TrangThai.Text = "Không tìm được máy chủ phù hợp."
        dangChuyen = false
        return false
    end
    TrangThai.Text = "Đang chuyển sang máy chủ mới..."
    local thanhCong, loi = pcall(function()
        TeleportService:TeleportToPlaceInstance(
            MaGame,
            maMayChu,
            NguoiChoi
        )
    end)
    if not thanhCong then
        TrangThai.Text = "Chuyển máy chủ thất bại."
        dangChuyen = false
        warn("Lỗi chuyển máy chủ: " .. tostring(loi))
        return false
    end
    return true
end
-- NÚT CHUYỂN NGAY
NutChuyen.MouseButton1Click:Connect(function()
    ChuyenMayChu(true)
end)
-- TỰ ĐỘNG CHUYỂN MÁY CHỦ
local tuDong = false
NutTuDong.MouseButton1Click:Connect(function()
    tuDong = not tuDong
    if tuDong then
        NutTuDong.Text = "TỰ ĐỘNG: BẬT"
        NutTuDong.BackgroundColor3 =
            Color3.fromRGB(180, 65, 65)
        task.spawn(function()
            while tuDong and GiaoDien.Parent do
                if not dangChuyen then
                    local nguong = math.max(
                        1,
                        math.floor(tonumber(ONhap.Text) or 1)
                    )
                    if #Players:GetPlayers() > nguong then
                        ChuyenMayChu(false)
                    else
                        TrangThai.Text =
                            "Đang ở máy chủ đạt điều kiện."
                    end
                end
                task.wait(5)
            end
        end)
    else
        NutTuDong.Text = "TỰ ĐỘNG: TẮT"
        NutTuDong.BackgroundColor3 =
            Color3.fromRGB(35, 115, 75)
        TrangThai.Text = "Đã tắt tự động chuyển máy chủ."
    end
end)
print("Nam Khánh Hub đã khởi chạy.")
