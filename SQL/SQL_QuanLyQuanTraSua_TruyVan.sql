USE QuanLyQuanTraSua
GO

--1.Tạo ràng buộc toàn vẹn--
--Dùng Check Constraint viết ràng buộc kiểm tra giá các món trà sữa lớn hơn hoặc bằng 20.000đ--
ALTER TABLE MON
ADD CONSTRAINT CHECK_GIA CHECK (GIA >= 20000)

--Dùng Unique Constraint viết ràng buộc kiểm tra duy nhất tên các món trà sữa--
ALTER TABLE MON
ADD CONSTRAINT CHECK_TENMON UNIQUE (TENMON)

--Dùng Default Constraint viết ràng buộc giá trị mặc định cho các cột: SOLUONG có giá trị mặc định là 0--
ALTER TABLE CHITIETHOADON
ADD CONSTRAINT DF_CHITIETHOADON_SOLUONG DEFAULT 0 FOR SOLUONG

--Viết trigger kiểm tra khi thêm thông tin nhân viên thì nhân viên này có đủ tuổi lao động không--
CREATE TRIGGER KT_NGAYSINH ON NHANVIEN
FOR INSERT, UPDATE
AS
	IF( YEAR(GETDATE()) - (SELECT YEAR(NGAYSINH) FROM inserted)) >= 18
		COMMIT TRAN
	ELSE 
		BEGIN
			PRINT N'KHONG DU TUOI LAO DONG !'
			ROLLBACK TRAN
		END

--2.Thêm thông tin--
--Update thông tin món trà sữa--
SELECT * FROM MON
INSERT INTO MON
VALUES
('TS_0000006',N'Trà Ô Long Đào',33000)

--Update thông tin nhân viên. Cho biết nhân viên này có đủ tuổi hay không?--
SELECT * FROM NHANVIEN
INSERT INTO NHANVIEN
VALUES
('NV_0000006',N'Nguyễn Văn W','100000000111',N'Vũng Tàu','0800000001','6/6/2015','6/6/2022',5000000)

--3.Các câu truy vấn--
--Danh sách thông tin các nhân viên mang họ Nguyễn--
SELECT *
FROM NHANVIEN
WHERE HOTEN LIKE N'Nguyễn%'

--Cho biết những bàn chưa gọi món--
SELECT BAN.MABAN, BAN.TENBAN, MAHD, MANV, NGAYHD, TONGTIEN, DATHANHTOAN
FROM BAN LEFT JOIN HOADON ON HOADON.MABAN = BAN.MABAN
WHERE MAHD IS NULL

--Cho biết nhân viên có mức lương cao nhất--
SELECT TOP 1*
FROM NHANVIEN
ORDER BY LUONG DESC

--Cho biết 3 nhân viên có mức lương cao nhất xếp từ cao xuống thấp--
SELECT TOP 3*
FROM NHANVIEN
ORDER BY LUONG DESC

--Danh sách các nhân viện có địa chỉ ở Vũng Tàu--
SELECT *
FROM NHANVIEN
WHERE DIACHI = N'Vũng Tàu'

--Cho biết các bàn trong quán trà sữa đã gọi món bao nhiêu lần--
SELECT HOADON.MABAN, TENBAN, COUNT(HOADON.MAHD) AS GOIMON
FROM HOADON JOIN BAN ON HOADON.MABAN = BAN.MABAN
GROUP BY HOADON.MABAN, TENBAN