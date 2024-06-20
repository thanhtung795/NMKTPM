-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Võ Thanh Tùng>
-- Create date: <Create 10/10/2023,,>
-- Description:	<ASM 2,,>
-- =============================================
select * from NguoiDung
-- tao proc them nguoi dung 
if OBJECT_ID('ThemNguoiDung', 'P') is not null
	drop proc ThemNguoiDung
go
CREATE PROCEDURE ThemNguoiDung
    @MaND INT,
    @tenND NVARCHAR(50),
    @GT NVARCHAR(3),
    @DThoai VARCHAR(20),
    @dchi NVARCHAR(50),
    @email VARCHAR(50)
AS
BEGIN
    IF (@MaND IS NULL OR @tenND IS NULL OR @GT IS NULL OR @DThoai IS NULL OR 
		@dchi IS NULL OR @email IS NULL)
    BEGIN
        PRINT 'Hãy nhập đầy đủ thông tin.';
        RETURN;
    END
    ELSE
    BEGIN
        INSERT INTO NguoiDung VALUES 
		(@MaND, @tenND, @GT, @DThoai, @dchi, @email);
        PRINT 'Dữ liệu đã được chèn thành công vào bảng NguoiDung.';
    END
END
	go
EXEC ThemNguoiDung @MaND = 11, @tenND = N'Võ Thanh Tùng', @GT = N'Nam', 
	@DThoai = N'0123456789', @dchi = N'123 Long an', @email = N'email@example.com';
go

-- tao proc nhà trọ
IF OBJECT_ID('ThemNhatro', 'P') IS NOT NULL
    DROP PROCEDURE ThemNhatro;
GO
CREATE PROCEDURE ThemNhatro
    @MaNhaTro INT,
    @MaLoaiNha INT,
    @DienTich REAL,
    @GiaPhong MONEY,
    @DiaChi NVARCHAR(50),
    @MoTaPhongTro NVARCHAR(50),
    @NgayDang DATE,
    @NguoiLienHe INT
AS
BEGIN
    IF (@MaNhaTro IS NULL OR @MaLoaiNha IS NULL OR @DienTich IS NULL OR @GiaPhong IS NULL OR 
        @DiaChi IS NULL OR @MoTaPhongTro IS NULL OR @NgayDang IS NULL OR @NguoiLienHe IS NULL)
    BEGIN
        PRINT 'Hãy nhập đầy đủ thông tin.';
        RETURN;
    END
    INSERT INTO NhaTro
    VALUES (@MaNhaTro, @MaLoaiNha, @DienTich, @GiaPhong,
			@DiaChi, @MoTaPhongTro, @NgayDang, @NguoiLienHe 
        );
    
    PRINT 'Dữ liệu đã được chèn thành công.';
END

-- Gọi thủ tục để chèn dữ liệu vào bảng NhaTro
EXEC ThemNhatro 
     12, 
     1, 
    60.0, 
    5000000, 
    N'123 Đường Lê văn quới, Quận 1, TP.HCM', 
     N'Căn hộ cao cấp', 
     '2023-09-20', 
     1;
go
-- tao proc danh gia
select * from DanhGia
if OBJECT_ID('ThemDanhGia', 'P') is not null
	drop proc ThemDanhGia
go
CREATE PROCEDURE ThemDanhGia
    @MaNT INT,
    @NguoiDG INT,
    @DanhGia NVARCHAR(10),
    @NoiDungDG NVARCHAR(50)
AS
BEGIN
    IF (@MaNT IS NULL OR @NguoiDG IS NULL OR @DanhGia IS NULL OR @NoiDungDG IS NULL)
    BEGIN
        PRINT 'Hãy nhập đầy đủ thông tin.';
        RETURN;
    END
    ELSE
    BEGIN
        INSERT INTO DanhGia VALUES (@MaNT, @NguoiDG, @DanhGia, @NoiDungDG);
        PRINT 'Dữ liệu đã được chèn thành công vào bảng DanhGia.';
    END
END
exec ThemDanhGia  @MaNT = 12,@NguoiDG = 2, @DanhGia ='like', @NoiDungDG = N'Nha dep';
go
select * from DanhGia
-- tao proc cac cau truy van 
if OBJECT_ID('TruyVanNT', 'P') is not null
	drop proc TruyVanNT
go
create proc TruyVanNT
@MaNT int
as 
begin 
	IF EXISTS (SELECT 1 FROM NhaTro WHERE MaNhaTro = @MaNT)
		begin
			select  N'Nhà cho thuê tại: ' + nt.DiaChi as N'Nơi cho thuê ',
		replace (CAST(dientich as nvarchar(50)),'.',',') + 'm2' as N'Diện tích',
		REPLACE(left(CONVERT(nvarchar,GiaPhong,1),
		LEN(CONVERT(nvarchar,GiaPhong,1))-3),'.',',') + ' VND' as N'Tiền trọ',
		MoTaPhongTro,
		CONVERT (nvarchar,NgayDang,105),
				case 
					when GioiTinh = N'Nam' then N'A ' + TenNguoiDung
					when GioiTinh = N'Nữ' then N'C ' + TenNguoiDung
					end AS TenNguoiDung,
			nd.DienThoai as N'Số liên lạc',
			nd.DiaChi as N'Địa chỉ liên lạc '
 			from NhaTro nt
			inner join NguoiDung nd on  nt.NguoiLienHe = nd.MaNguoiDung
			where MaNhaTro = @MaNT

 		end
end
go
exec TruyVanNT 4;
 go
 select DienTich from NhaTro
 SELECT * FROM NHATRO
 -- Viết một hàm có các tham số đầu vào tương ứng với tất cả các cột của bảng
CREATE FUNCTION Fn_TimKiemNguoiDung(
    @TenND NVARCHAR(50),
    @GioiTinh NVARCHAR(3),
    @DienThoai NVARCHAR(20),
    @DiaChi NVARCHAR(50),
    @Email NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM NGUOIDUNG
    WHERE
        ( @TenND IS NULL OR TenNguoiDung = @TenND )
        AND ( @GioiTinh IS NULL OR GioiTinh = @GioiTinh )
        AND ( @DienThoai IS NULL OR DienThoai = @DienThoai )
        AND ( @DiaChi IS NULL OR DiaChi = @DiaChi )
        AND ( @Email IS NULL OR Email = @Email )
);

SELECT * FROM Fn_TimKiemNguoiDung('Quang', N'Nam', N'0987654321', N'456 Đường Bình trị đông,
									Quận 2, TP.HCM', N'quang@example.com');
go
 
CREATE OR ALTER FUNCTION dbo.TinhSoLuongLike
(
    @MaNhaTro INT
)
RETURNS INT
AS
BEGIN
    DECLARE @SoLuongLike INT;
	
    SELECT @SoLuongLike = COUNT(DanhGia) 
    FROM DanhGia dg
    WHERE dg.MaNhaTro = @MaNhaTro AND DanhGia = 'Like';
	
    RETURN @SoLuongLike;
END;
GO
DECLARE @SoLuongLike INT;
SET @SoLuongLike = dbo.TinhSoLuongLike(3) 
SELECT @SoLuongLike AS SoLuongLike  
go

CREATE OR ALTER FUNCTION dbo.TinhSoLuongDislike
(
    @MaNhaTro INT
)
RETURNS INT
AS
BEGIN
    DECLARE @SoLuongDislike INT;

    SELECT @SoLuongDislike = COUNT(DanhGia) 
    FROM DanhGia 
    WHERE MaNhaTro = @MaNhaTro AND DanhGia = 'Dislike';

    RETURN @SoLuongDislike;
END;
GO 
select *  from DanhGia
DECLARE @SoLuongDisLike INT;
SET @SoLuongDisLike = dbo.TinhSoLuongDislike(1) 
SELECT @SoLuongDisLike AS SoLuongDisLike  
go
--========================
-- Tạo một View lưu thông tin của TOP 10 nhà trọ có số người dùng 
-- LIKE nhiều nhất gồm
CREATE OR ALTER VIEW Top10NhaTroLiked
AS
select top 10
	dbo.TinhSoLuongLike(MaNhaTro) as 'Tong so luot like',
    nt.DienTich, nt.GiaPhong, nt.MoTaPhongTro,
    nt.NgayDang, nd.TenNguoiDung AS TenNguoiLienHe, nd.DiaChi,
    nd.DienThoai, nd.Email
from NhaTro nt
inner join NguoiDung nd on nt.NguoiLienHe = nd.MaNguoiDung
order by 'Tong so luot like' desc

select * from Top10NhaTroLiked
--==========
-- Viết một Stored Procedure nhận tham số đầu vào là mã nhà trọ
--(cột khóa chính của bảng NHATRO). 
--SP này trả về tập kết quả gồm các thông tin sau:
go
create or alter proc HienThithongtin_danhgia_nhatro
	@MaNt  int 
as
begin
	select nt.MaNhaTro,nd.TenNguoiDung as 'Ten nguoi danh gia',
	dg.DanhGia as 'trang thai', dg.NoiDungDanhGia
	from NhaTro nt
	inner join NguoiDung nd on nt.NguoiLienHe = nd.MaNguoiDung
	inner join danhgia dg  on nt.MaNhaTro = dg.MaNhaTro
	where nt.MaNhaTro = @MaNt
end
go

exec HienThithongtin_danhgia_nhatro 15;
go
--==========================
--Viết một SP nhận một tham số đầu vào kiểu int là số lượng DISLIKE. SP này thực hiện
--thao tác xóa thông tin của các nhà trọ và thông tin đánh giá của chúng, nếu tổng số lượng
--DISLIKE tương ứng với nhà trọ này lớn hơn giá trị tham số được truyền vào.
--Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu khi một thao tác
--xóa thực hiện không thành công

create or alter proc XoaThonTinNhaTro 
@SLDislike int
as 
begin try 
	if exists (select MaNhaTro 
	from NhaTro 
	where dbo.TinhSoLuongDislike(MaNhaTro)>=@SLDislike)
		begin tran
			delete from DanhGia where MaNhaTro in (select MaNhaTro from NhaTro)
			delete from NhaTro where MaNhaTro in (select MaNhaTro from NhaTro)
			print N'Đã xóa thanh công'
		commit tran
end try
begin catch
	rollback tran 
	print N'Xóa thất bại'
end catch 

exec XoaThonTinNhaTro 3
go

select * 
	from NhaTro 
	where NgayDang between '2023-09-20' and '2023-09-20'
	go

create or alter proc NhaTroTuNgayDang  
@TuNgay date , @DenNgay date 
as 
begin try 
	if exists (select MaNhaTro 
	from NhaTro 
	where NgayDang between @TuNgay and @DenNgay)
		begin tran
			delete from DanhGia where MaNhaTro in (select MaNhaTro from NhaTro)
			delete from NhaTro where MaNhaTro in (select MaNhaTro from NhaTro)
			print N'Đã xóa thanh công'
		commit tran
end try
begin catch
	rollback tran 
	print N'Xóa thất bại'
end catch 
go
exec NhaTroTuNgayDang '2023-09-20','2023-09-20'
go
-- ==================
-- Tạo Trigger ràng buộc khi thêm, 
-- sửa thông tin nhà trọ phải thỏa mãn các điều kiện sau:
--Diện tích phòng >=8 (m2)
-- Giá phòng >=0

create or alter trigger RangBuoc_dientich_giaphong
on nhatro
for insert,update
as 
begin
	IF EXISTS (
        SELECT GiaPhong,DienTich
        FROM inserted
        WHERE (DienTich >= 8 AND GiaPhong >= 0)
		)
		begin
			print N'thong tin da duoc them vao '
		end
	else 
		begin
			print N'Thông tin nhà trọ không hợp lệ. 
			Diện tích phòng phải >= 8 (m2) và giá phòng phải >= 0.';
        ROLLBACK TRANSACTION;
		end
end
go
update NhaTro 
set DienTich = -67.6
where MaNhaTro = 15;
go
-- Tạo Trigger để khi xóa thông tin người dùng
-- Nếu có các đánh giá của người dùng đó thì xóa cả đánh giá
-- Nếu có thông tin liên hệ của người dùng đó trong nhà trọ thì sửa thông tin liên hệ
-- sang người dùng khác hoặc để trống thông tin liên hệ

--================================
CREATE OR ALTER TRIGGER Tr_Xoa_thong_tin_nguoi_dung
ON NguoiDung
INSTEAD OF DELETE 
AS 
BEGIN
    -- Xóa các đánh giá của người dùng đó
    DELETE FROM DanhGia WHERE MaNguoiDanhGia IN (SELECT MaNguoiDung FROM deleted);

    -- Cập nhật thông tin liên hệ trong bảng NhaTro
    UPDATE NhaTro 
    SET NguoiLienHe = 
        CASE 
            WHEN NguoiLienHe IN (SELECT MaNguoiDung FROM deleted) THEN 
                (SELECT TOP 1 MaNguoiDung 
					FROM NguoiDung 
					WHERE MaNguoiDung NOT IN (SELECT MaNguoiDung 
												FROM deleted))
            ELSE 
                NULL
        END
    WHERE NguoiLienHe IN (SELECT MaNguoiDung FROM deleted);

    -- Xóa người dùng
    DELETE FROM NguoiDung WHERE MaNguoiDung IN (SELECT MaNguoiDung FROM deleted);
END


DELETE FROM NguoiDung WHERE MaNguoiDung = 15;



