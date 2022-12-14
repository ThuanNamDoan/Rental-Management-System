USE [master]
GO
/****** Object:  Database [QuanLyThueBanNha]    Script Date: 21/03/2021 7:24:54 CH ******/
CREATE DATABASE [QuanLyThueBanNha]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QuanLyThueBanNha', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\QuanLyThueBanNha.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QuanLyThueBanNha_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\QuanLyThueBanNha_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [QuanLyThueBanNha] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuanLyThueBanNha].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuanLyThueBanNha] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuanLyThueBanNha] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuanLyThueBanNha] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QuanLyThueBanNha] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuanLyThueBanNha] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET RECOVERY FULL 
GO
ALTER DATABASE [QuanLyThueBanNha] SET  MULTI_USER 
GO
ALTER DATABASE [QuanLyThueBanNha] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuanLyThueBanNha] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QuanLyThueBanNha] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QuanLyThueBanNha] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [QuanLyThueBanNha] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'QuanLyThueBanNha', N'ON'
GO
ALTER DATABASE [QuanLyThueBanNha] SET QUERY_STORE = OFF
GO
USE [QuanLyThueBanNha]
GO
/****** Object:  Table [dbo].[BaiDang]    Script Date: 21/03/2021 7:24:54 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BaiDang](
	[MaBaiDang] [char](10) NOT NULL,
	[NgayDang] [date] NULL,
	[NgayHetHan] [date] NULL,
	[MaNha] [char](10) NULL,
	[LuotXemBaiDang] [int] NULL,
	[MaChuNha] [char](10) NULL,
 CONSTRAINT [PK_BaiDang] PRIMARY KEY CLUSTERED 
(
	[MaBaiDang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChiNhanh]    Script Date: 21/03/2021 7:24:54 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiNhanh](
	[MaChiNhanh] [char](10) NOT NULL,
	[SDT] [char](10) NULL,
	[FAX] [char](15) NULL,
	[Duong] [nvarchar](20) NULL,
	[Quan] [nvarchar](10) NULL,
	[KhuVuc] [nvarchar](10) NULL,
	[ThanhPho] [nvarchar](10) NULL,
 CONSTRAINT [PK_ChiNhanh] PRIMARY KEY CLUSTERED 
(
	[MaChiNhanh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChuNha]    Script Date: 21/03/2021 7:24:54 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChuNha](
	[MaChuNha] [char](10) NOT NULL,
	[Ten] [nvarchar](40) NOT NULL,
	[SDT] [char](10) NULL,
	[DiaChi] [nvarchar](100) NULL,
 CONSTRAINT [PK_ChuNha] PRIMARY KEY CLUSTERED 
(
	[MaChuNha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gia]    Script Date: 21/03/2021 7:24:54 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gia](
	[MaGia] [char](10) NOT NULL,
	[LoaiGia] [nchar](5) NULL,
	[GiaBan] [int] NULL,
	[GiaThue] [int] NULL,
	[DieuKienChuNha] [nvarchar](100) NULL,
 CONSTRAINT [PK_Gia] PRIMARY KEY CLUSTERED 
(
	[MaGia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KhachHang]    Script Date: 21/03/2021 7:24:54 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhachHang](
	[MaKH] [char](10) NOT NULL,
	[Ten] [nvarchar](40) NOT NULL,
	[DiaChi] [nvarchar](60) NULL,
	[SDT] [char](10) NULL,
	[TieuChi] [nvarchar](100) NULL,
	[MaChiNhanh] [char](10) NULL,
	[MaNhanVien] [char](10) NULL,
 CONSTRAINT [PK_KhachHang] PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoaiNha]    Script Date: 21/03/2021 7:24:54 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoaiNha](
	[MaLoaiNha] [char](10) NOT NULL,
	[TenLoaiNha] [nvarchar](40) NOT NULL,
 CONSTRAINT [PK_LoaiNha] PRIMARY KEY CLUSTERED 
(
	[MaLoaiNha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Nha]    Script Date: 21/03/2021 7:24:54 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nha](
	[MaNha] [char](10) NOT NULL,
	[SoLuongPhong] [int] NULL,
	[SoLuotXem] [int] NULL,
	[TinhTrang] [nvarchar](40) NULL,
	[Duong] [nvarchar](20) NULL,
	[Quan] [nvarchar](10) NULL,
	[ThanhPho] [nvarchar](10) NULL,
	[KhuVuc] [nvarchar](10) NULL,
	[MaGia] [char](10) NULL,
	[MaChuNha] [char](10) NULL,
	[MaNhanVien] [char](10) NULL,
	[MaChiNhanh] [char](10) NULL,
	[MaLoaiNha] [char](10) NULL,
 CONSTRAINT [PK_Nha] PRIMARY KEY CLUSTERED 
(
	[MaNha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 21/03/2021 7:24:54 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhanVien](
	[MaNhanVien] [char](10) NOT NULL,
	[Ten] [nvarchar](40) NOT NULL,
	[NgaySinh] [date] NULL,
	[GioiTinh] [nvarchar](5) NULL,
	[Luong] [int] NULL,
	[DiaChi] [nvarchar](60) NULL,
	[SDT] [char](10) NULL,
	[MaChiNhanh] [char](10) NULL,
 CONSTRAINT [PK_NhanVien] PRIMARY KEY CLUSTERED 
(
	[MaNhanVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ThongTinLuotXem]    Script Date: 21/03/2021 7:24:54 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThongTinLuotXem](
	[MaKH] [char](10) NOT NULL,
	[MaNha] [char](10) NOT NULL,
	[NhanXet] [nvarchar](100) NULL,
	[NgayXem] [date] NULL,
 CONSTRAINT [PK_ThongTinLuotXem] PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC,
	[MaNha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ThongTinYeuCauKH]    Script Date: 21/03/2021 7:24:54 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThongTinYeuCauKH](
	[MaKH] [char](10) NOT NULL,
	[MaLoaiNha] [char](10) NOT NULL,
 CONSTRAINT [PK_ThongTinYeuCauKH] PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC,
	[MaLoaiNha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BaiDang]  WITH CHECK ADD  CONSTRAINT [FK_BaiDang_ChuNha] FOREIGN KEY([MaChuNha])
REFERENCES [dbo].[ChuNha] ([MaChuNha])
GO
ALTER TABLE [dbo].[BaiDang] CHECK CONSTRAINT [FK_BaiDang_ChuNha]
GO
ALTER TABLE [dbo].[BaiDang]  WITH CHECK ADD  CONSTRAINT [FK_BaiDang_Nha] FOREIGN KEY([MaNha])
REFERENCES [dbo].[Nha] ([MaNha])
GO
ALTER TABLE [dbo].[BaiDang] CHECK CONSTRAINT [FK_BaiDang_Nha]
GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [FK_KhachHang_ChiNhanh] FOREIGN KEY([MaChiNhanh])
REFERENCES [dbo].[ChiNhanh] ([MaChiNhanh])
GO
ALTER TABLE [dbo].[KhachHang] CHECK CONSTRAINT [FK_KhachHang_ChiNhanh]
GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [FK_KhachHang_NhanVien] FOREIGN KEY([MaNhanVien])
REFERENCES [dbo].[NhanVien] ([MaNhanVien])
GO
ALTER TABLE [dbo].[KhachHang] CHECK CONSTRAINT [FK_KhachHang_NhanVien]
GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [FK_KhachHang_NhanVien1] FOREIGN KEY([MaNhanVien])
REFERENCES [dbo].[NhanVien] ([MaNhanVien])
GO
ALTER TABLE [dbo].[KhachHang] CHECK CONSTRAINT [FK_KhachHang_NhanVien1]
GO
ALTER TABLE [dbo].[Nha]  WITH CHECK ADD  CONSTRAINT [FK_Nha_ChiNhanh] FOREIGN KEY([MaChiNhanh])
REFERENCES [dbo].[ChiNhanh] ([MaChiNhanh])
GO
ALTER TABLE [dbo].[Nha] CHECK CONSTRAINT [FK_Nha_ChiNhanh]
GO
ALTER TABLE [dbo].[Nha]  WITH CHECK ADD  CONSTRAINT [FK_Nha_ChuNha] FOREIGN KEY([MaChuNha])
REFERENCES [dbo].[ChuNha] ([MaChuNha])
GO
ALTER TABLE [dbo].[Nha] CHECK CONSTRAINT [FK_Nha_ChuNha]
GO
ALTER TABLE [dbo].[Nha]  WITH CHECK ADD  CONSTRAINT [FK_Nha_Gia] FOREIGN KEY([MaGia])
REFERENCES [dbo].[Gia] ([MaGia])
GO
ALTER TABLE [dbo].[Nha] CHECK CONSTRAINT [FK_Nha_Gia]
GO
ALTER TABLE [dbo].[Nha]  WITH CHECK ADD  CONSTRAINT [FK_Nha_LoaiNha] FOREIGN KEY([MaLoaiNha])
REFERENCES [dbo].[LoaiNha] ([MaLoaiNha])
GO
ALTER TABLE [dbo].[Nha] CHECK CONSTRAINT [FK_Nha_LoaiNha]
GO
ALTER TABLE [dbo].[Nha]  WITH CHECK ADD  CONSTRAINT [FK_Nha_NhanVien] FOREIGN KEY([MaNhanVien])
REFERENCES [dbo].[NhanVien] ([MaNhanVien])
GO
ALTER TABLE [dbo].[Nha] CHECK CONSTRAINT [FK_Nha_NhanVien]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [FK_NhanVien_ChiNhanh] FOREIGN KEY([MaChiNhanh])
REFERENCES [dbo].[ChiNhanh] ([MaChiNhanh])
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [FK_NhanVien_ChiNhanh]
GO
ALTER TABLE [dbo].[ThongTinLuotXem]  WITH CHECK ADD  CONSTRAINT [FK_ThongTinLuotXem_KhachHang] FOREIGN KEY([MaKH])
REFERENCES [dbo].[KhachHang] ([MaKH])
GO
ALTER TABLE [dbo].[ThongTinLuotXem] CHECK CONSTRAINT [FK_ThongTinLuotXem_KhachHang]
GO
ALTER TABLE [dbo].[ThongTinLuotXem]  WITH CHECK ADD  CONSTRAINT [FK_ThongTinLuotXem_Nha] FOREIGN KEY([MaNha])
REFERENCES [dbo].[Nha] ([MaNha])
GO
ALTER TABLE [dbo].[ThongTinLuotXem] CHECK CONSTRAINT [FK_ThongTinLuotXem_Nha]
GO
ALTER TABLE [dbo].[ThongTinYeuCauKH]  WITH CHECK ADD  CONSTRAINT [FK_ThongTinYeuCauKH_KhachHang] FOREIGN KEY([MaKH])
REFERENCES [dbo].[KhachHang] ([MaKH])
GO
ALTER TABLE [dbo].[ThongTinYeuCauKH] CHECK CONSTRAINT [FK_ThongTinYeuCauKH_KhachHang]
GO
ALTER TABLE [dbo].[ThongTinYeuCauKH]  WITH CHECK ADD  CONSTRAINT [FK_ThongTinYeuCauKH_LoaiNha] FOREIGN KEY([MaLoaiNha])
REFERENCES [dbo].[LoaiNha] ([MaLoaiNha])
GO
ALTER TABLE [dbo].[ThongTinYeuCauKH] CHECK CONSTRAINT [FK_ThongTinYeuCauKH_LoaiNha]
GO
ALTER TABLE [dbo].[BaiDang]  WITH CHECK ADD  CONSTRAINT [CK_BaiDang] CHECK  (([NgayDang]<[NgayHetHan]))
GO
ALTER TABLE [dbo].[BaiDang] CHECK CONSTRAINT [CK_BaiDang]
GO
ALTER TABLE [dbo].[BaiDang]  WITH CHECK ADD  CONSTRAINT [CK_BaiDang_1] CHECK  (([NgayDang]<=getdate()))
GO
ALTER TABLE [dbo].[BaiDang] CHECK CONSTRAINT [CK_BaiDang_1]
GO
ALTER TABLE [dbo].[BaiDang]  WITH CHECK ADD  CONSTRAINT [CK_BaiDang_2] CHECK  (([NgayHetHan]>=getdate()))
GO
ALTER TABLE [dbo].[BaiDang] CHECK CONSTRAINT [CK_BaiDang_2]
GO
ALTER TABLE [dbo].[Gia]  WITH CHECK ADD  CONSTRAINT [CK_Gia] CHECK  (([LoaiGia]=N'Bán' OR [LoaiGia]=N'Thuê'))
GO
ALTER TABLE [dbo].[Gia] CHECK CONSTRAINT [CK_Gia]
GO
ALTER TABLE [dbo].[Gia]  WITH CHECK ADD  CONSTRAINT [CK_Gia_1] CHECK  (([GiaThue]>(0)))
GO
ALTER TABLE [dbo].[Gia] CHECK CONSTRAINT [CK_Gia_1]
GO
ALTER TABLE [dbo].[Gia]  WITH CHECK ADD  CONSTRAINT [CK_Gia_2] CHECK  (([GiaBan]>(0)))
GO
ALTER TABLE [dbo].[Gia] CHECK CONSTRAINT [CK_Gia_2]
GO
ALTER TABLE [dbo].[Nha]  WITH CHECK ADD  CONSTRAINT [CK_Nha] CHECK  (([SoLuongPhong]>(0)))
GO
ALTER TABLE [dbo].[Nha] CHECK CONSTRAINT [CK_Nha]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [CK_NhanVien] CHECK  (([GioiTinh]=N'Nữ' OR [GioiTinh]='Nam'))
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [CK_NhanVien]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [CK_NhanVien_1] CHECK  (([Luong]>=(1000000)))
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [CK_NhanVien_1]
GO
/****** Object:  Trigger [dbo].[inserupdate]    Script Date: 21/03/2021 7:24:54 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[inserupdate]
   ON [dbo].[Gia]
   AFTER INSERT,UPDATE
AS 
BEGIN
    SET NOCOUNT ON;
    -- Insert statements for trigger here

    declare @value nvarchar(10)

    select @value=LoaiGia from inserted

    if @value = N'Thuê'
    begin
        update gia
        set GiaBan=NUll, DieuKienChuNha = NULL
    end
	else if @value = N'Bán'
	begin
        update gia
        set GiaThue=NUll
    end
END
GO
ALTER TABLE [dbo].[Gia] ENABLE TRIGGER [inserupdate]
GO
USE [master]
GO
ALTER DATABASE [QuanLyThueBanNha] SET  READ_WRITE 
GO


