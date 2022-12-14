USE [QuanLyThueBanNha]
GO
/****** Object:  StoredProcedure [dbo].[CapNhatBaiDang]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------- STORED PROCEDURE 2 : CẬP NHẬT BÀI ĐĂNG ----------
CREATE procedure [dbo].[CapNhatBaiDang]
	@maBaiDang char(10),
	@ngayHetHan date,
	@maNha char(10),
	@luotXemBaiDang int,
	@error nvarchar(100) out
as
begin tran
	-- Kiểm tra bài đăng có tồn tại không
	declare @isBaiDang int
	exec @isBaiDang = KiemTraBaiDangTonTai @maBaiDang
	if (@isBaiDang = 0)
	begin
		Set @error = N'Lỗi: Bài đăng không tồn tại'
		raiserror('Lỗi: Bài đăng không tồn tại', 0, 0)
		rollback tran
		return 
	end

	-- Kiểm tra nhà
	if(LEN(ISNULL(@maNha, '')) = 0)
	begin
		set @maNha = (select MaNha from BaiDang where MaNha = @maNha)
	end
	else
	begin
		declare @isNha int
		exec @isNha = KiemTraNhaTonTai @maNha
		if (@isNha = 0)
		begin
			Set @error = N'Lỗi: Nhà không tồn tại'
			raiserror('Lỗi: Nhà không tồn tại', 0, 0)
			rollback tran
			return 
		end	
	end

	declare @maChuNha char(10);
	set @maChuNha = (select MaChuNha from Nha where MaNha = @maNha)

	-- Update
	update BaiDang
	set NgayHetHan = @ngayHetHan, MaNha = @maNha, 
		LuotXemBaiDang = @luotXemBaiDang, MaChuNha = @maChuNha
	where MaBaiDang = @maBaiDang

	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi : Không thể cập nhật'
		raiserror('Lỗi : Không thể cập nhật', 0, 0)
		rollback	
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[CapNhatChuNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- DEMO DIRTY READ 03

--------- TRANSACTION 1 : CẬP NHẬT THÔNG TIN CHỦ NHÀ ---------- 
create procedure [dbo].[CapNhatChuNha]
	@maChuNha char(10),
	@ten nvarchar(40) = null,
	@sdt char(10) = null,
	@diaChi nvarchar(60) = null,	
	@error nvarchar(100) out
as
begin tran
	-- Kiểm tra chủ nhà có tồn tại không
	declare @isChuNha int
	exec @isChuNha = KiemTraChuNhaTonTai @maChuNha
	if (@isChuNha = 0)
	begin
		set @error = N'Chủ nhà không tồn tại'
		raiserror(N'Chủ nhà không tồn tại', 0, 0)
		rollback tran
		return
	end

	-- Kiểm tra tên
	if(LEN(ISNULL(@ten, '')) = 0)
	begin
		set @ten = (select Ten from ChuNha where MaChuNha = @maChuNha)
	end

	-- Kiểm tra sdt
	if(LEN(ISNULL(@sdt, '')) = 0)
	begin
		set @sdt = (select SDT from ChuNha where MaChuNha = @maChuNha)
	end

	-- Kiểm tra địa chỉ
	if(LEN(ISNULL(@diaChi, '')) = 0)
	begin
		set @diaChi = (select DiaChi from ChuNha where MaChuNha = @maChuNha)
	end

	-- Update
	update ChuNha
	set Ten = @ten, SDT = @sdt, DiaChi = @diaChi
	where MaChuNha = @maChuNha

	-- Cố tình rollback để demo Diry Read
	waitfor delay '00:00:10'
	rollback tran
	print 'Rollback !!!!!'
	return

	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi : Không thể cập nhật'
		raiserror('Lỗi : Không thể cập nhật', 0, 0)
		rollback	
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[CapNhatGiaBan]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CapNhatGiaBan]
	@maNha char(10),
	@giaThem money
as
begin tran
	
	-- select lấy mã giá
	declare @maGia char(10)
	set @maGia = (Select MaGia from Nha with (updlock) where MaNha = @maNha)
	--set @maGia = (Select MaGia from Nha where MaNha = @maNha)

	--select lấy giá bán của nhà
	declare @gia money
	set @gia = (Select GiaBan from Gia where MaGia = @maGia)

	--Waitfor Delay '00:00:5'

	--tính giá cập nhật
	set @gia = @gia + @giaThem

	--update thông tin giá bán
	update Gia set  GiaBan = @gia where MaGia = @maGia

	print(@gia)

commit tran
GO
/****** Object:  StoredProcedure [dbo].[CapNhatGiaThue]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CapNhatGiaThue]
	@maNha char(10),
	@giaThem money
as
begin tran
	
	-- select lấy mã giá
	declare @maGia char(10)
	set @maGia = (Select MaGia from Nha with (updlock) where MaNha = @maNha)
	--set @maGia = (Select MaGia from Nha where MaNha = @maNha)

	--select lấy giá bán của nhà
	declare @gia money
	set @gia = (Select GiaThue from Gia where MaGia = @maGia)

	--Waitfor Delay '00:00:5'

	--tính giá cập nhật
	set @gia = @gia + @giaThem

	--update thông tin giá bán
	update Gia set  GiaThue = @gia where MaGia = @maGia

	print(@gia)

commit tran
GO
/****** Object:  StoredProcedure [dbo].[CapNhatLuongNhanVien]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CapNhatLuongNhanVien]
	@maNhanVien char(10),
	@luongThem money
as
begin tran
	
	declare @luong money
	--lấy mức lương của nhân viên
	--set @luong = (Select Luong from NhanVien with (updlock) where MaNhanVien = @maNhanVien)
	set @luong = (Select Luong from NhanVien where MaNhanVien = @maNhanVien)

	--delay
	--Waitfor Delay '00:00:5'

	--tính mức lương sau khi tăng thêm
	set @luong = @luong + @luongThem


	--update mức lương hiện tại
	update NhanVien set  Luong = @luong where MaNhanVien = @maNhanVien

	print(@luong)

commit tran
GO
/****** Object:  StoredProcedure [dbo].[CapNhatNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------- STORED PROCEDURE 1 : CẬP NHẬT NHÀ ----------
create procedure [dbo].[CapNhatNha]
	@maNha char(10),
	@soLuongPhong int,
	@tinhTrang nvarchar(40), 
	@duong nvarchar(20),
	@quan nvarchar(20),
	@thanhPho nvarchar(20),
	@khuVuc nvarchar(20),
	@maGia char(10),
	@maChuNha char(10),
	@maNhanVien char(10),
	@maChiNhanh char(10),
	@maLoaiNha char(10),
	@error nvarchar(100) out
as
begin tran
	-- Kiểm tra nhà có tồn tại không
	declare @isNha int
	exec @isNha = KiemTraNhaTonTai @maNha
	if (@isNha = 0)
	begin
		set @error = N'Nhà không tồn tại'
		raiserror(N'Nhà không tồn tại', 0, 0)
		rollback tran
		return
	end

	-- Kiểm tra số lượng phòng
	if(LEN(ISNULL(@soLuongPhong, '')) = 0)
	begin
		set @soLuongPhong = (select SoLuongPhong from Nha where MaNha = @maNha)
	end

	-- Kiểm tra tình trạng
	if(LEN(ISNULL(@tinhTrang, '')) = 0)
	begin
		set @tinhTrang = (select TinhTrang from Nha where MaNha = @maNha)
	end

	-- Kiểm tra đường
	if(LEN(ISNULL(@duong, '')) = 0)
	begin
		set @duong = (select Duong from Nha where MaNha = @maNha)
	end

	-- Kiểm tra quận
	if(LEN(ISNULL(@quan, '')) = 0)
	begin
		set @quan = (select Quan from Nha where MaNha = @maNha)
	end

	-- Kiểm tra thành phố
	if(LEN(ISNULL(@thanhPho, '')) = 0)
	begin
		set @thanhPho = (select ThanhPho from Nha where MaNha = @maNha)
	end

	-- Kiểm tra khu vực
	if(LEN(ISNULL(@khuVuc, '')) = 0)
	begin
		set @khuVuc = (select KhuVuc from Nha where MaNha = @maNha)
	end

	-- Kiểm tra giá
	if(LEN(ISNULL(@maGia, '')) = 0)
	begin
		set @maGia = (select MaGia from Nha where MaNha = @maNha)
	end
	else 
	begin
		declare @isGia int
		exec @isGia = KiemTraGiaTonTai @maGia
		if (@isGia = 0)
		begin
			set @error = N'Giá không tồn tại'
			raiserror(N'Giá không tồn tại', 0, 0)
			rollback tran
			return
		end
	end

	-- Kiểm tra chủ nhà
	if(LEN(ISNULL(@maChuNha, '')) = 0)
	begin
		set @maChuNha = (select MaChuNha from Nha where MaNha = @maNha)
	end
	else 
	begin
		declare @isChuNha int
		exec @isChuNha = KiemTraChuNhaTonTai @maChuNha
		if (@isChuNha = 0)
		begin
			set @error = N'Chủ nhà không tồn tại'
			raiserror(N'Chủ nhà không tồn tại', 0, 0)
			rollback tran
			return
		end
	end

	-- Kiểm tra nhân viên
	if(LEN(ISNULL(@maNhanVien, '')) = 0)
	begin
		set @maNhanVien = (select MaNhanVien from Nha where MaNha = @maNha)
	end
	else 
	begin
		declare @isNV int
		exec @isNV = KiemTraNhanVienTonTai @maNhanVien
		if (@isNV = 0)
		begin
			set @error = N'Nhân viên không tồn tại'
			raiserror(N'Nhân viên không tồn tại', 0, 0)
			rollback tran
			return
		end
	end

	-- Kiểm tra chi nhánh
	if(LEN(ISNULL(@maChiNhanh, '')) = 0)
	begin
		set @maChiNhanh = (select MaChiNhanh from Nha where MaNha = @maNha)
	end
	else 
	begin
		declare @isChiNhanh int
		exec @isChiNhanh = KiemTraChiNhanhTonTai @maChiNhanh
		if (@isChiNhanh = 0)
		begin
			set @error = N'Chi nhánh không tồn tại'
			raiserror(N'Chi nhánh không tồn tại', 0, 0)
			rollback tran
			return
		end
	end

	-- Kiểm tra loại nhà
	if(LEN(ISNULL(@maLoaiNha, '')) = 0)
	begin
		set @maLoaiNha = (select MaLoaiNha from Nha where MaNha = @maNha)
	end
	else 
	begin
		declare @isLoaiNha int
		exec @isLoaiNha = KiemTraLoaiNhaTonTai @maLoaiNha
		if (@isLoaiNha = 0)
		begin
			set @error = N'Loại nhà không tồn tại'
			raiserror(N'Loại nhà không tồn tại', 0, 0)
			rollback tran
			return
		end
	end

	-- Update
	update Nha
	set SoLuongPhong = @soLuongPhong, TinhTrang = @tinhTrang, Duong = @duong,
		Quan = @quan, ThanhPho = @thanhPho, KhuVuc = @khuVuc, MaGia = @maGia, 
		MaChuNha = @maChuNha, MaNhanVien = @maNhanVien, MaChiNhanh = @maChiNhanh, MaLoaiNha = @maLoaiNha
	where MaNha = @maNha

	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi : Không thể cập nhật nhà'
		raiserror('Lỗi : Không thể cập nhật nhà', 0, 0)
		rollback	
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[CapNhatNhanVien]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[CapNhatNhanVien]
	@maNhanVien char(10),
	@ten nvarchar(40),
	@ngaySinh date,
	@gioiTinh nvarchar(5),
	@luong int,
	@diaChi nvarchar(60),
	@SDT char(10),
	@maChiNhanh char(10),
	@error nvarchar(100) out
as
begin tran
	
	--kiểm tra nhân viên có tồn tại
	declare @isNhanVien int
	exec @isNhanVien = KiemTraNhanVienTonTai @maNhanVien

	if (@isNhanVien = 0)
	begin
		set @error = N'Không thể cập nhật'
		rollback
	end
	else
	begin
		--Update tên nhân viên
		if(LEN(ISNULL(@ten, '')) <> 0)
		begin
			update NhanVien set Ten = @ten where MaNhanVien = @maNhanVien
		end

		--Update tên ngay sinh
		if(LEN(ISNULL(@ngaySinh, '')) <> 0)
		begin
			update NhanVien set NgaySinh = @ngaySinh where MaNhanVien = @maNhanVien
		end

		--Update tên gioi tinh
		if(LEN(ISNULL(@gioiTinh, '')) <> 0)
		begin
			update NhanVien set GioiTinh = @gioiTinh where MaNhanVien = @maNhanVien
		end
		
		--Update tên luong
		if( @luong >= 1000000)
		begin
			update NhanVien set Luong = @luong where MaNhanVien = @maNhanVien
		end
		else
		begin
			set @error = N'Không thể cập nhật'
			raiserror('Lỗi : Không thể cập nhà', 0, 0)
		end

		--Update tên dia chi
		if(LEN(ISNULL(@diaChi, '')) <> 0)
		begin
			update NhanVien set DiaChi = @diaChi where MaNhanVien = @maNhanVien
		end

		--Update tên SDT
		if(LEN(ISNULL(@SDT, '')) <> 0)
		begin
			update NhanVien set SDT = @SDT where MaNhanVien = @maNhanVien
		end

		--Kiểm tra chi nhánh có tồn tại
		declare @isChiNhanh int
		exec @isChiNhanh = KiemTraChiNhanhTonTai @maChiNhanh

		if (LEN(ISNULL(@maChiNhanh, '')) = 0 or @isNhanVien = 0)
		begin
			set @error = N'Chi nhánh không hợp lệ'
			raiserror(N'Không thể cập nhật nhà', 0, 0)
		end
		else
		begin
			update NhanVien set MaChiNhanh = @maChiNhanh where MaNhanVien = @maNhanVien
		end
	end

	if (@@ERROR <> 0)
		begin
			raiserror('Lỗi : Không thể cập nhà', 0, 0)
			rollback
		end
	else
		begin
			set @error = N'Cập nhật thành công'
		end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[CapNhatSoLuotXemNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---- Cập nhật số lượt xem nhà (Trong bảng Nhà)
create procedure [dbo].[CapNhatSoLuotXemNha]
	@maNha char(10)
as
begin tran
	declare @soLuotXem int;
	set @soLuotXem = (select count(*) from ThongTinLuotXem where ThongTinLuotXem.MaNha = @maNha)
	update Nha
	set SoLuotXem = @soLuotXem
	where MaNha = @maNha
commit tran
GO
/****** Object:  StoredProcedure [dbo].[CapNhatThongTinLuotXem]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- DEMO DIRTY READ

--------- TRANSACTION 1 : CẬP NHẬT THÔNG TIN LƯỢT XEM ---------- 
CREATE procedure [dbo].[CapNhatThongTinLuotXem]
	@maKH char(10),
	@maNha char(10),
	@nhanXet nvarchar(100) = null,
	@ngayXem date = null,
	@error nvarchar(100) out
as
begin tran
	-- Kiểm tra khách hàng có tồn tại không
	if (len(isnull(@maKH, '')) <> 0)
	begin
		declare @isKH int
		exec @isKH = KiemTraKhachHangTonTai @maKH
		if (@isKH = 0)
		begin
			set @error = N'Lỗi: Khách hàng không tồn tại'
			raiserror(N'Lỗi: Khách hàng không tồn tại', 0, 0)
			rollback tran
			return
		end
	end

	-- Kiểm tra nhà có tồn tại không
	if (len(isnull(@maNha, '')) <> 0)
	begin
		declare @isNha int
		exec @isNha = KiemTraNhaTonTai @maNha
		if (@isNha = 0)
		begin
			set @error = N'Lỗi: Nhà không tồn tại'
			raiserror(N'Lỗi: Nhà không tồn tại', 0, 0)
			rollback tran
			return
		end
	end

	-- Kiểm tra ngày xem
	if(@ngayXem is NULL)
	begin
		set @ngayXem = (select NgayXem from ThongTinLuotXem where MaKH = @maKH and MaNha = @maNha)
	end
	
	-- Kiểm tra nhận xét
	if(LEN(ISNULL(@nhanXet, '')) = 0)
	begin
		set @nhanXet = (select NhanXet from ThongTinLuotXem where MaKH = @maKH and MaNha = @maNha)
	end

	-- Update
	update ThongTinLuotXem
	set NhanXet = @nhanXet, NgayXem = @ngayXem
	where MaKH = @maKH and MaNha = @maNha

	-- Cố tình rollback để demo Diry Read
	waitfor delay '00:00:10'
	rollback tran
	print 'Rollback !!!!!'
	return

	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi: Không thể cập nhật'
		raiserror('Lỗi: Không thể cập nhật', 0, 0)
		rollback	
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[KiemTraBaiDangTonTai]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------- KIỂM TRA SỰ TỒN TẠI CỦA BÀI ĐĂNG ----------
create procedure [dbo].[KiemTraBaiDangTonTai]
	@maBaiDang char(10)
as
begin
	if exists (select MaBaiDang from BaiDang where MaBaiDang = @maBaiDang)
	begin
		return 1
	end
	else
	begin
		return 0
	end	
end
GO
/****** Object:  StoredProcedure [dbo].[KiemTraChiNhanhTonTai]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Kiểm tra sự tồn tại của chi nhánh
CREATE procedure [dbo].[KiemTraChiNhanhTonTai]
@maChiNhanh char(10)
as
begin
	if (LEN(ISNULL(@maChiNhanh, '')) = 0)
		begin
			return 0
		end

	if exists (select MaChiNhanh from ChiNhanh where MaChiNhanh = @maChiNhanh)
	begin
		return 1
	end
	else
	begin
		return 0
	end	
end
GO
/****** Object:  StoredProcedure [dbo].[KiemTraChuNhaTonTai]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------- KIỂM TRA SỰ TỒN TẠI CỦA CHỦ NHÀ ----------
create procedure [dbo].[KiemTraChuNhaTonTai]
@maChuNha char(10)
as
begin
	if exists (select MaChuNha from ChuNha where MaChuNha = @maChuNha)
	begin
		return 1
	end
	else
	begin
		return 0
	end	
end
GO
/****** Object:  StoredProcedure [dbo].[KiemTraGiaTonTai]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------- KIỂM TRA SỰ TỒN TẠI CỦA GIÁ ----------
create procedure [dbo].[KiemTraGiaTonTai]
@maGia char(10)
as
begin
	if exists (select MaGia from Gia where MaGia = @maGia)
	begin
		return 1
	end
	else
	begin
		return 0
	end	
end
GO
/****** Object:  StoredProcedure [dbo].[KiemTraKhachHangTonTai]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[KiemTraKhachHangTonTai]
@maKH char(10)
as
begin
	if exists (select MaKH from KhachHang where MaKH = @maKH)
	begin
		return 1
	end
	else
	begin
		return 0
	end	
end
GO
/****** Object:  StoredProcedure [dbo].[KiemTraLoaiNhaTonTai]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------- KIỂM TRA SỰ TỒN TẠI CỦA LOẠI NHÀ ----------
create procedure [dbo].[KiemTraLoaiNhaTonTai]
@maLoaiNha char(10)
as
begin
	if exists (select MaLoaiNha from LoaiNha where MaLoaiNha = @maLoaiNha)
	begin
		return 1
	end
	else
	begin
		return 0
	end	
end
GO
/****** Object:  StoredProcedure [dbo].[KiemTraNhanVienTonTai]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[KiemTraNhanVienTonTai]
@maNhanVien char(10)
as
begin
	if exists (select MaNhanVien from NhanVien where MaNhanVien = @maNhanVien)
	begin
		return 1
	end
	else
	begin
		return 0
	end	
end
GO
/****** Object:  StoredProcedure [dbo].[KiemTraNhaTonTai]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------- KIỂM TRA SỰ TỒN TẠI CỦA NHÀ ----------
create procedure [dbo].[KiemTraNhaTonTai]
	@maNha char(10)
as
begin
	if exists (select MaNha from Nha where MaNha = @maNha)
	begin
		return 1
	end
	else
	begin
		return 0
	end	
end
GO
/****** Object:  StoredProcedure [dbo].[TaoMaBaiDang]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----------------------------------------------- BÀI ĐĂNG ---------------------------------------------

---------- TẠO MÃ BÀI ĐĂNG ----------
create procedure [dbo].[TaoMaBaiDang] 
	@maBaiDang char(10) out
as
begin
	declare @lastMaBaiDang char(10)
	set @lastMaBaiDang = (select TOP 1 MaBaiDang from BaiDang order by MaBaiDang desc)

	if (@lastMaBaiDang is null)
	begin
		set @maBaiDang = 'topic_0'
		return
	end
	else
	begin
		declare @lastIndex int
		set @lastIndex = cast(substring(@lastMaBaiDang, 7, (select len(@lastMaBaiDang)) - 6) as int)
		set @maBaiDang = 'topic_' + cast((@lastIndex + 1) as char(10))
	end
end
GO
/****** Object:  StoredProcedure [dbo].[TaoMaChiNhanh]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[TaoMaChiNhanh]
	@maChiNhanh char(10) out
as
begin
	declare @lastMaChiNhanh char(10)
	set @lastMaChiNhanh = (select TOP 1 MaChiNhanh from ChiNhanh order by MaChiNhanh desc)
	if (@lastMaChiNhanh is null)
	begin
		set @maChiNhanh = 'ag_0'
		return
	end
	else
	begin
		declare @lastIndex int
		set @lastIndex = cast(substring(@lastMaChiNhanh, 4, len(@lastMaChiNhanh) - 3) as int)
		--set @lastIndex = @lastIndex + 1
		set @maChiNhanh = 'ag_' + cast((@lastIndex + 1) as char(10))
	end
end
GO
/****** Object:  StoredProcedure [dbo].[TaoMaChuNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------- CHỦ NHÀ ---------------------------------------------

---------- TẠO MÃ CHỦ NHÀ ----------
create procedure [dbo].[TaoMaChuNha]
	@maChuNha char(10) out
as
begin
	declare @lastMaChuNha char(10)
	set @lastMaChuNha = (select TOP 1 MaChuNha from ChuNha order by MaChuNha desc)

	if (@lastMaChuNha is null)
	begin
		set @maChuNha = 'own_0'
		return
	end
	else
	begin
		declare @lastIndex int
		set @lastIndex = cast(substring(@lastMaChuNha, 5, (select len(@lastMaChuNha)) - 4) as int)
		set @maChuNha = 'own_' + cast((@lastIndex + 1) as char(10))
	end
end
GO
/****** Object:  StoredProcedure [dbo].[TaoMaGia]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----------------------------------------------- GIÁ ---------------------------------------------

---------- TẠO MÃ GIÁ ----------
create procedure [dbo].[TaoMaGia]
	@maGia char(10) out
as
begin
	declare @lastMaGia char(10)
	set @lastMaGia = (select TOP 1 MaGia from Gia order by MaGia desc)

	if (@lastMaGia is null)
	begin
		set @maGia = 'price_0'
		return
	end
	else
	begin
		declare @lastIndex int
		set @lastIndex = cast(substring(@lastMaGia, 7, (select len(@lastMaGia)) - 6) as int)
		set @maGia = 'price_' + cast((@lastIndex + 1) as char(10))
	end
end
GO
/****** Object:  StoredProcedure [dbo].[TaoMaKhachHang]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------- TẠO MÃ KHÁCH HÀNG ----------
CREATE procedure [dbo].[TaoMaKhachHang]
	@maKH char(10) out
as
begin
	declare @lastMaKH char(10)
	set @lastMaKH = (select TOP 1 MaKH from KhachHang order by MaKH desc)

	if (@lastMaKH is null)
	begin
		set @maKH = 'cli_0'
		return
	end
	else
	begin
		declare @lastIndex int
		set @lastIndex = cast(substring(@lastMaKH, 5, (select len(@lastMaKH)) - 4) as int)
		set @maKH = 'cli_' + cast((@lastIndex + 1) as char(10))
	end
end
GO
/****** Object:  StoredProcedure [dbo].[TaoMaLoaiNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------- TẠO MÃ LOẠI NHÀ ----------
create procedure [dbo].[TaoMaLoaiNha]
	@maLoaiNha char(10) out
as
begin
	declare @lastMaLoaiNha char(10)
	set @lastMaLoaiNha = (select TOP 1 MaLoaiNha from LoaiNha order by MaLoaiNha desc)

	if (@lastMaLoaiNha is null)
	begin
		set @maLoaiNha = 'tyho_0'
		return
	end
	else
	begin
		declare @lastIndex int
		set @lastIndex = cast(substring(@lastMaLoaiNha, 6, (select len(@lastMaLoaiNha)) - 5) as int)
		set @maLoaiNha = 'tyho_' + cast((@lastIndex + 1) as char(10))
	end
end
GO
/****** Object:  StoredProcedure [dbo].[TaoMaNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----------------------------------------------- NHÀ ---------------------------------------------

---------- TẠO MÃ NHÀ ----------
create procedure [dbo].[TaoMaNha] 
	@maNha char(10) out
as
begin
	declare @lastMaNha char(10)
	set @lastMaNha = (select TOP 1 MaNha from Nha order by MaNha desc)

	if (@lastMaNha is null)
	begin
		set @maNha = 'ho_0'
		return
	end
	else
	begin
		declare @lastIndex int
		set @lastIndex = cast(substring(@lastMaNha, 4, (select len(@lastMaNha)) - 3) as int)
		set @maNha = 'ho_' + cast((@lastIndex + 1) as char(10))
	end
end
GO
/****** Object:  StoredProcedure [dbo].[TaoMaNhanVien]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------- TẠO MÃ NHÂN VIÊN ----------
CREATE procedure [dbo].[TaoMaNhanVien] 
	@maNV char(10) out
as
begin
	declare @lastMaNV char(10)
	set @lastMaNV = (select TOP 1 MaNhanVien from NhanVien order by MaNhanVien desc)

	if (@lastMaNV is null)
	begin
		set @maNV = 'emp_0'
		return
	end
	else
	begin
		declare @lastIndex int
		set @lastIndex = cast(substring(@lastMaNV, 5, (select len(@lastMaNV)) - 4) as int)
		--set @lastIndex = @lastIndex + 1
		set @maNV = 'emp_' + cast((@lastIndex + 1) as char(10))
	end
end
GO
/****** Object:  StoredProcedure [dbo].[ThemBaiDang]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------- THÊM BÀI ĐĂNG ----------
CREATE procedure [dbo].[ThemBaiDang]
	@ngayHetHan date,
	@maNha char(10),
	@luotXemBaiDang int,
	@error nvarchar(50) out
as
begin tran
	-- Kiểm tra sự tồn tại của nhà (maNha)
	declare @isNha int
	exec @isNha = KiemTraNhaTonTai @maNha
	if (@isNha = 0)
	begin
		set @error = N'Lỗi: Mã nhà không tồn tại.'
		raiserror(N'Lỗi: Mã nhà không tồn tại', 0, 0)
		rollback tran
		return
	end

	declare @maBaiDang char(10);
	exec TaoMaBaiDang @maBaiDang out

	declare @ngayDang date;
	set @ngayDang = GETDATE()

	declare @maChuNha char(10);
	set @maChuNha = (select MaChuNha from Nha where MaNha = @maNha)

	-- Thêm bài đăng
	insert into BaiDang(MaBaiDang, NgayDang, NgayHetHan, MaNha, LuotXemBaiDang, MaChuNha)
	values
	(@maBaiDang, @ngayDang, @ngayHetHan, @maNha, @luotXemBaiDang, @maChuNha)	
		
	if (@@ERROR <> 0)
	begin
		Set @error = 'Lỗi: Thêm bài đăng'
		raiserror(N'Lỗi: Thêm bài đăng', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThemChiNhanh]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[ThemChiNhanh]
	@sdt char(10),
	@fax char(10),
	@duong nvarchar(20),
	@quan nvarchar(20),
	@khuVuc nvarchar(20),
	@thanhPho nvarchar(20),
	@error nvarchar(100) out
as
begin tran
	declare @maChiNhanh char(10)
	exec TaoMaChiNhanh @maChiNhanh out

	insert into ChiNhanh
	values (@maChiNhanh, @sdt, @fax, @duong, @quan, @khuVuc, @thanhPho)
	
	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi: Thêm chi nhánh'
		raiserror(N'Lỗi: Thêm chi nhánh', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThemChuNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------- THÊM CHỦ NHÀ ----------
create procedure [dbo].[ThemChuNha]
	@ten nvarchar(40),
	@sdt char(10),
	@diaChi nvarchar(100),
	@error nvarchar(50) out
as
begin tran
	declare @maChuNha char(10);
	exec TaoMaChuNha @maChuNha out

	-- Thêm chủ nhà
	insert into ChuNha(MaChuNha, Ten, SDT, DiaChi)
	values
	(@maChuNha, @ten, @sdt, @diaChi)	
		
	if (@@ERROR <> 0)
	begin
		Set @error = 'Lỗi: Thêm chủ nhà'
		raiserror(N'Lỗi: Thêm chủ nhà', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThemGia]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------- THÊM GÍA ----------
CREATE procedure [dbo].[ThemGia]
	@loaiGia nvarchar(5),
	@gia money,
	@dieuKienChuNha nvarchar(100),
	@error nvarchar(50) out
as
begin tran
	declare @maGia char(10);
	exec TaoMaGia @maGia out
	declare @giaBan money;
	declare @giaThue money;

	-- Kiểm tra loại giá 
	if (@loaiGia = N'Thuê')
	begin
		set @giaBan = null
		set @dieuKienChuNha = null
		set @giaThue = @gia
	end
	else if (@loaiGia = N'Bán')
	begin
		set @giaThue = null
		set @giaBan = @gia
	end
	else
	begin
		set @error = N'Lỗi: Loại giá không hợp lệ'
		raiserror(N'Lỗi: Loại giá không hợp lệ', 0, 0)
		rollback tran
		return
	end

	print @giaBan
	print @giaThue
	-- Thêm giá
	insert into Gia(MaGia, LoaiGia, GiaBan, GiaThue, DieuKienChuNha)
	values
	(@maGia, @loaiGia, @giaBan, @giaThue, @dieuKienChuNha)	
		
	if (@@ERROR <> 0)
	begin
		Set @error = 'Lỗi: Thêm giá'
		raiserror(N'Lỗi: Thêm giá', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThemKhachHang]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------- THÊM KHÁCH HÀNG ----------
create procedure [dbo].[ThemKhachHang]
	@ten nvarchar(50),
	@diaChi nvarchar(50),
	@sdt varchar(20),
	@tieuChi nvarchar(100),
	@maChiNhanh char(10),
	@maNhanVien char(10),
	@error nvarchar(50) out
as
begin tran
	-- Kiểm tra sự tồn tại của chi nhánh (maChiNhanh)
	declare @isChiNhanh int
	exec @isChiNhanh = KiemTraChiNhanhTonTai @maChiNhanh
	if (@isChiNhanh = 0)
	begin
		set @error = N'Lỗi: Mã chi nhánh không tồn tại.'
		raiserror(N'Lỗi: Mã chi nhánh không tồn tại', 0, 0)
		rollback tran
		return
	end

	-- Kiểm tra sự tồn tại của nhân viên (maNhanVien)
	declare @isNhanVien int
	exec @isNhanVien = KiemTraNhanVienTonTai @maNhanVien
	if (@isNhanVien = 0)
	begin
		set @error = N'Lỗi: Mã nhân viên không tồn tại.'
		raiserror(N'Lỗi: Mã nhân viên không tồn tại', 0, 0)
		rollback tran
		return
	end

	declare @maKhachHang char(10);
	exec TaoMaKhachHang @maKhachHang out

	-- Thêm khách hàng
	insert into KhachHang(MaKH, Ten, DiaChi, SDT, TieuChi, MaChiNhanh, MaNhanVien)
	values
	(@MaKhachHang, @ten, @DiaChi, @sdt, @tieuChi, @maChiNhanh, @maNhanVien)	
		
	if (@@ERROR <> 0)
	begin
		Set @error = 'Lỗi: Thêm khách hàng.'
		raiserror(N'Lỗi: Thêm khách hàng', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThemLoaiNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------- THÊM LOẠI NHÀ ----------
create procedure [dbo].[ThemLoaiNha]
	@tenLoaiNha nvarchar(40),
	@error nvarchar(50) out
as
begin tran
	declare @maLoaiNha char(10);
	exec TaoMaLoaiNha @maLoaiNha out

	-- Thêm loại nhà
	insert into LoaiNha(MaLoaiNha, TenLoaiNha)
	values
	(@maLoaiNha, @tenLoaiNha)	
		
	if (@@ERROR <> 0)
	begin
		Set @error = 'Lỗi: Thêm loại nhà'
		raiserror(N'Lỗi: Thêm loại nhà', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThemNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------- THÊM NHÀ ----------
create procedure [dbo].[ThemNha]
	@soLuongPhong int,
	@tinhTrang nvarchar(40),
	@duong nvarchar(20),
	@quan nvarchar(20),
	@thanhPho nvarchar(20),
	@khuVuc nvarchar(20),
	@maGia char(10),
	@maChuNha char(10),
	@maNhanVien char(10),
	@maChiNhanh char(10),
	@maLoaiNha char(10),
	@error nvarchar(50) out
as
begin tran
	-- Kiểm tra sự tồn tại của giá (maGia)
	declare @isGia int
	exec @isGia = KiemTraGiaTonTai @maGia
	if (@isGia = 0)
	begin
		set @error = N'Lỗi: Mã giá không tồn tại.'
		raiserror(N'Lỗi: Mã giá không tồn tại', 0, 0)
		rollback tran
		return
	end

	-- Kiểm tra sự tồn tại của chủ nhà (maChuNha)
	declare @isChuNha int
	exec @isChuNha = KiemTraChuNhaTonTai @maChuNha
	if (@isChuNha = 0)
	begin
		set @error = N'Lỗi: Mã chủ nhà không tồn tại.'
		raiserror(N'Lỗi: Mã chủ nhà không tồn tại', 0, 0)
		rollback tran
		return
	end

	-- Kiểm tra sự tồn tại của nhân viên (maNhanVien)
	declare @isNhanVien int
	exec @isNhanVien = KiemTraNhanVienTonTai @maNhanVien
	if (@isNhanVien = 0)
	begin
		set @error = N'Lỗi: Mã nhân viên không tồn tại.'
		raiserror(N'Lỗi: Mã nhân viên không tồn tại', 0, 0)
		rollback tran
		return
	end

	-- Kiểm tra sự tồn tại của chi nhánh (maChiNhanh)
	declare @isChiNhanh int
	exec @isChiNhanh = KiemTraChiNhanhTonTai @maChiNhanh
	if (@isNhanVien = 0)
	begin
		set @error = N'Lỗi: Mã chi nhánh không tồn tại.'
		raiserror(N'Lỗi: Mã chi nhánh không tồn tại', 0, 0)
		rollback tran
		return
	end

	-- Kiểm tra sự tồn tại của loại nhà (maLoaiNha)
	declare @isLoaiNha int
	exec @isLoaiNha = KiemTraLoaiNhaTonTai @maLoaiNha
	if (@isLoaiNha = 0)
	begin
		set @error = N'Lỗi: Mã loại nhà không tồn tại.'
		raiserror(N'Lỗi: Mã loại nhà không tồn tại', 0, 0)
		rollback tran
		return
	end

	declare @maNha char(10);
	exec TaoMaNha @maNha out

	-- Thêm nhà
	insert into Nha(MaNha, SoLuongPhong, TinhTrang, Duong, Quan, ThanhPho, KhuVuc, MaGia, MaChuNha, MaNhanVien, MaChiNhanh, MaLoaiNha)
	values
	(@maNha, @soLuongPhong, @tinhTrang, @duong, @quan, @thanhPho, @khuVuc, @maGia, @maChuNha, @maNhanVien, @maChiNhanh, @maLoaiNha)	
		
	if (@@ERROR <> 0)
	begin
		Set @error = 'Lỗi: Thêm nhà'
		raiserror(N'Lỗi: Thêm nhà', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThemNhanVien]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Thêm nhân viên
CREATE procedure [dbo].[ThemNhanVien]
	@ten nvarchar(50),
	@ngaySinh date,
	@gioitinh nvarchar(5),
	@luong int,
	@DiaChi nvarchar(50),
	@sdt varchar(20),
	@maChiNhanh char(50),
	@error varchar(50) out
as
begin tran
	-- Kiểm tra sự tồn tại của chi nhánh (maChiNhanh)
	declare @kiemTraChiNhanh int
	exec @kiemTraChiNhanh = KiemTraChiNhanhTonTai @maChiNhanh
	if (@kiemTraChiNhanh = 0)
	begin
		set @error = N'Lỗi: Mã chi nhánh không tồn tại.'
		raiserror(N'Lỗi: Mã chi nhánh không tồn tại', 0, 0)
		rollback tran
		return
	end

	declare @maNhanVien char(10);
	exec TaoMaNhanVien @maNhanVien out

	-- Thêm nhân viên
	insert into NhanVien(MaNhanVien, Ten, NgaySinh, GioiTinh, Luong, DiaChi, SDT, MaChiNhanh)
	values
	(@maNhanVien, @ten, @ngaysinh, @gioitinh, @luong, @DiaChi, @sdt, @maChiNhanh)	
		
	if (@@ERROR <> 0)
	begin
		Set @error = 'Lỗi: Thêm nhân viên.'
		raiserror(N'Lỗi: Thêm nhân viên', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThemThongTinLuotXem]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[ThemThongTinLuotXem]
	@maKH char(10),
	@maNha char(10),
	@nhanXet nvarchar(100),
	@ngayXem date,
	@error varchar(50) out
as
begin tran
	-- Kiểm tra sự tồn tại của khách hàng
	declare @kiemTraKH int
	exec @kiemTraKH = KiemTraKhachHangTonTai @maKH
	if (@kiemTraKH = 0)
	begin
		set @error = N'Mã khách hàng không tồn tại.'
		rollback tran
		return
	end

	-- Thêm thông tin lượt xem
	insert into ThongTinLuotXem(MaKH, MaNha, NhanXet, NgayXem)
	values
	(@maKH, @maNha, @nhanXet, @ngayXem)	
		
	if (@@ERROR <> 0)
	begin
		Set @error = 'Lỗi: Thêm thông tin lượt xem.'
		rollback tran
		return
	end
	else
	begin
		exec capNhatSoLuotXemNha 
			@maNha = @maNha
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThemThongTinYeuCauKH]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------- THÊM THÔNG TIN YÊU CẦU KH ----------
create procedure [dbo].[ThemThongTinYeuCauKH]
	@maKH char(10),
	@maLoaiNha char(10),
	@error varchar(50) out
as
begin tran
	-- Kiểm tra sự tồn tại của khách hàng
	declare @isKH int
	exec @isKH = KiemTraKhachHangTonTai @maKH
	if (@isKH = 0)
	begin
		set @error = N'Mã khách hàng không tồn tại.'
		rollback tran
		return
	end

	-- Kiểm tra sự tồn tại của loại nhà
	declare @isLoaiNha int
	exec @isLoaiNha = KiemTraLoaiNhaTonTai @maLoaiNha
	if (@isLoaiNha = 0)
	begin
		set @error = N'Mã loại nhà không tồn tại.'
		rollback tran
		return
	end

	-- Thêm thông tin yêu cầu KH
	insert into ThongTinYeuCauKH(MaKH, MaLoaiNha)
	values
	(@maKH, @maLoaiNha)	
		
	if (@@ERROR <> 0)
	begin
		Set @error = 'Lỗi: Thêm thông tin lượt xem.'
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThongTinBaiDang]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[ThongTinBaiDang]
	@soLuong int out
as
begin tran
	--đếm số lượng chi nhánh
	set @soLuong = (select count(MaBaiDang) from BaiDang)

	--hiển thị thông tin chi nhánh
	select * from BaiDang

commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThongTinChiNhanh]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ThongTinChiNhanh]
	@soLuong int out
as
begin tran
	--đếm số lượng chi nhánh
	set @soLuong = (select count(MaChiNhanh) from ChiNhanh)

	--hiển thị thông tin chi nhánh
	select * from ChiNhanh

commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThongTinChuNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ThongTinChuNha]
	@soLuong int out
as
begin tran
	--đếm số lượng chủ nhà
	set @soLuong = (select count(MaChuNha) from ChuNha)

	--hiển thị thông tin chi nhánh
	select * from ChuNha

commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThongTinNhaTheoGiaBan]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ThongTinNhaTheoGiaBan]
	@giaBan money,
	@soLuong int out
as
begin tran

	SET TRAN ISOLATION LEVEL Serializable
	
	--đếm số lượng nhà có giá bán < @giaBan
	set @soLuong = (select count(MaNha) from Nha join Gia on Nha.MaGia = Gia.MaGia where Gia.GiaBan < @giaBan)

	Waitfor Delay '00:00:5'

	--hiển thị thông tin nhà hợp lệ
	select * from Nha join Gia on Nha.MaGia = Gia.MaGia where Gia.GiaBan < @giaBan

commit tran
GO
/****** Object:  StoredProcedure [dbo].[ThongTinNhaTheoGiaThue]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ThongTinNhaTheoGiaThue]
	@giaThue money,
	@soLuong int out
as
begin tran
	--SET TRAN ISOLATION LEVEL Serializable
	--đếm số lượng nhà có giá bán < @giaBan
	set @soLuong = (select count(MaNha) from Nha join Gia on Nha.MaGia = Gia.MaGia where Gia.GiaThue < @giaThue)
	
	Waitfor Delay '00:00:5'
	
	--hiển thị thông tin nhà hợp lệ
	select * from Nha join Gia on Nha.MaGia = Gia.MaGia where Gia.GiaThue < @giaThue

commit tran
GO
/****** Object:  StoredProcedure [dbo].[XemDanhSachYeuCauKhachHangDoNhanVienPhuTrach]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- DEMO PHANTOM 03

---------- STORED PROCEDURE 1 : XEM THÔNG TIN LƯỢT XEM CỦA NHÀ DO NHÂN VIÊN PHỤ TRÁCH ----------
create procedure [dbo].[XemDanhSachYeuCauKhachHangDoNhanVienPhuTrach]
	@maNV char(10), 
	@error varchar(50) out
as
begin tran
	-- Kiểm tra nhân viên có tồn tại không
	declare @isNV int
	exec @isNV = KiemTraNhanVienTonTai @maNV
	if (@isNV = 0)
	begin
		Set @error = N'Lỗi: Nhân viên không tồn tại'
		raiserror('Lỗi: Nhân viên không tồn tại', 0, 0)
		rollback tran
		return 
	end
	
	-- select
	select * from ThongTinYeuCauKH
	where MaKH in (Select MaKH from KhachHang where MaNhanVien = @maNV)
	waitfor delay '00:00:10'

	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi: Lấy thông tin yêu cầu khách hàng'
		raiserror(N'Lỗi: Lấy thông tin yêu cầu khách hàng', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[XemLoaiNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- DEMO PHANTOM 03

---------- STORED PROCEDURE 1 : XEM LOẠI NHÀ ----------
create procedure [dbo].[XemLoaiNha]
	@error varchar(50) out
as
begin tran
	-- select
	select * from LoaiNha
	waitfor delay '00:00:10'

	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi: Lấy thông tin loại nhà'
		raiserror(N'Lỗi: Lấy thông tin loại nhà', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[XemThongTinBaiDang]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------- STORED PROCEDURE 1 : XEM THÔNG TIN BÀI ĐĂNG  ----------
CREATE procedure [dbo].[XemThongTinBaiDang]
	@maBaiDang char(10), 
	@error varchar(50) out
as
begin tran
	-- Kiểm tra bài đăng có tồn tại không
	declare @isBaiDang int
	exec @isBaiDang = KiemTraBaiDangTonTai @maBaiDang
	if (@isBaiDang = 0)
	begin
		Set @error = N'Lỗi: Bài đăng không tồn tại'
		raiserror('Lỗi: Bài đăng không tồn tại', 0, 0)
		rollback tran
		return 
	end
	
	Select * from BaiDang where MaBaiDang = @maBaiDang
	waitfor delay '00:00:10'

	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi: Lấy thông tin bài đăng'
		raiserror(N'Lỗi: Lấy thông tin bài đăng', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[XemThongTinChuNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- DEMO DIRTY READ 03

---------- TRANSACTION 2 : XEM THÔNG TIN CHỦ NHÀ ----------
create procedure [dbo].[XemThongTinChuNha]
	@maChuNha char(10), 
	@error varchar(50) out
as
begin tran
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	-- Kiểm tra chủ nhà có tồn tại không
	declare @isChuNha int
	exec @isChuNha = KiemTraChuNhaTonTai @maChuNha
	if (@isChuNha = 0)
	begin
		Set @error = N'Lỗi: Chủ nhà không tồn tại'
		raiserror('Lỗi: Chủ nhà không tồn tại', 0, 0)
		rollback tran
		return 
	end
	
	Select * from ChuNha where MaChuNha = @maChuNha
	
	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi: Lấy thông tin chủ nhà'
		raiserror(N'Lỗi: Lấy thông tin chủ nhà', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[XemThongTinLuotXem]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- DEMO DIRTY READ

---------- TRANSACTION 2 : XEM THÔNG TIN LƯỢT XEM ----------
CREATE procedure [dbo].[XemThongTinLuotXem] 
	@maKH char(10), 
	@maNha char(10),
	@error varchar(50) out
as
begin tran
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	-- Kiểm tra khách hàng có tồn tại không
	declare @isKH int
	exec @isKH = KiemTraKhachHangTonTai @maKH
	if (@isKH = 0)
	begin
		Set @error = N'Lỗi: Khách hàng không tồn tại'
		raiserror('Lỗi: Khách hàng không tồn tại', 0, 0)
		rollback tran
		return 
	end

	-- Kiểm tra nhà có tồn tại không
	declare @isNha int
	exec @isNha = KiemTraNhaTonTai @maNha
	if (@isNha = 0)
	begin
		Set @error = N'Lỗi: Nhà không tồn tại'
		raiserror('Lỗi: Nhà không tồn tại', 0, 0)
		rollback tran
		return 
	end
	
	Select * from ThongTinLuotXem where MaKH = @maKH and MaNha = @maNha
	
	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi: Lấy thông tin lượt xem'
		raiserror(N'Lỗi: Lấy thông tin lượt xem', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[XemThongTinLuotXemCuaNhaDoNhanVienPhuTrach]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------- STORED PROCEDURE 1 : XEM THÔNG TIN LƯỢT XEM CỦA NHÀ DO NHÂN VIÊN PHỤ TRÁCH ----------
CREATE procedure [dbo].[XemThongTinLuotXemCuaNhaDoNhanVienPhuTrach]
	@maNV char(10), 
	@error varchar(50) out
as
begin tran
	-- Kiểm tra nhân viên có tồn tại không
	declare @isNV int
	exec @isNV = KiemTraNhanVienTonTai @maNV
	if (@isNV = 0)
	begin
		Set @error = N'Lỗi: Nhân viên không tồn tại'
		raiserror('Lỗi: Nhân viên không tồn tại', 0, 0)
		rollback tran
		return 
	end
	
	-- select
	select * from ThongTinLuotXem
	where MaNha in (Select MaNha from Nha where MaNhanVien = @maNV)
	waitfor delay '00:00:10'

	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi: Lấy thông tin lượt xem'
		raiserror(N'Lỗi: Lấy thông tin lượt xem', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[XemThongTinNhaGiaToiDa]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- DEMO UNREPEATABLE READ 02

---------- STORED PROCEDURE 1 : XEM NHÀ CÓ GIÁ TỐI ĐA ----------
create procedure [dbo].[XemThongTinNhaGiaToiDa]
	@gia money,
	@loaiGia nvarchar(5),
	@error varchar(50) out
as
begin tran
	-- select
	if (@loaiGia = N'Thuê')
	begin
		select * from Nha
		where MaGia in (Select MaGia from Gia where LoaiGia = @loaiGia and GiaThue <= @gia)
	end
	else if (@loaiGia = N'Bán')
	begin
		select * from Nha
		where MaGia in (Select MaGia from Gia where LoaiGia = @loaiGia and GiaBan <= @gia)
	end

	waitfor delay '00:00:10'

	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi: Lấy thông tin nhà'
		raiserror(N'Lỗi: Lấy thông tin nhà', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[XemThongTinNhanVienTheoLuong]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[XemThongTinNhanVienTheoLuong]
	@mucLuong money,
	@soLuong int out
as

begin tran
	SET TRAN ISOLATION LEVEL Serializable
	--đếm số lượng nhân viên
	set @soLuong = (select count(MaNhanVien) from NhanVien where NhanVien.Luong > @mucLuong)

	Waitfor Delay '00:00:5'

	--hiển thị thông tin nhân viên
	select * from NhanVien where NhanVien.Luong > @mucLuong

commit tran
GO
/****** Object:  StoredProcedure [dbo].[XemThongTinNhaTheoLoaiNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- DEMO PHANTOM 02

---------- STORED PROCEDURE 1 : XEM THÔNG TIN NHÀ THEO LOẠI NHÀ ----------
create procedure [dbo].[XemThongTinNhaTheoLoaiNha]
	@maLoaiNha char(10), 
	@error varchar(50) out
as
begin tran
	-- Kiểm tra loại nhà có tồn tại không
	declare @isLoaiNha int
	exec @isLoaiNha = KiemTraLoaiNhaTonTai @maLoaiNha
	if (@isLoaiNha = 0)
	begin
		Set @error = N'Lỗi: Loại nhà không tồn tại'
		raiserror('Lỗi: Loại nhà không tồn tại', 0, 0)
		rollback tran
		return 
	end
	
	-- select
	select * from Nha
	where MaLoaiNha = @maLoaiNha
	waitfor delay '00:00:10'

	if (@@ERROR <> 0)
	begin
		set @error = N'Lỗi: Lấy thông tin nhà theo loại nhà'
		raiserror(N'Lỗi: Lấy thông tin nhà theo loại nhà', 0, 0)
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[XoaBaiDang]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[XoaBaiDang]
	@maBaiDang char(10)
as
begin tran
		
	delete BaiDang where MaBaiDang = @maBaiDang

commit tran
GO
/****** Object:  StoredProcedure [dbo].[XoaThongTinLuotXem]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- DEMO UNREPEATABLE READ 02

---------- STORED PROCEDURE 2 : XÓA THÔNG TIN LƯỢT XEM ----------
create procedure [dbo].[XoaThongTinLuotXem]
	@maKH char(10),
	@maNha char(10),
	@error nvarchar(100) out
as
begin tran
	-- Kiểm tra khách hàng và nhà có tồn tại không
	if not exists (select MaKH, MaNha from ThongTinLuotXem where MaKH = @maKH and MaNha = @maNha)
	begin
		set @error = N'Lỗi: Khách hàng và nhà không tồn tại'
		raiserror(N'Lỗi: Khách hàng và nhànkhông tồn tại', 0, 0)
		rollback tran
		return
	end

	-- Thực hiện xóa thông tin lượt xem
	delete ThongTinLuotXem where MaKH = @maKH and MaNha = @maNha
	if (@@ERROR <> 0)
	begin 
		set @error = N'Lỗi: Xóa thông tin lượt xem'
		rollback tran
		return
	end
commit tran
GO
/****** Object:  StoredProcedure [dbo].[XoaThongTinNha]    Script Date: 11/05/2021 10:42:12 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[XoaThongTinNha]
	@maNha char(10)
as
begin tran

	--xóa thông tin lượt xem
	delete ThongTinLuotXem where MaNha = @maNha

	--xóa bài đăng của nhà
	delete BaiDang where MaNha = @maNha

	--xóa thông tin trong bảng nhà
	delete Nha where MaNha = @maNha

commit tran
GO
