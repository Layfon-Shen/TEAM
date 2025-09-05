-- 活動主表
CREATE TABLE activity (
    id 					INT PRIMARY KEY IDENTITY(1,1),	    -- 自動遞增     
    name 				NVARCHAR(100) NOT NULL,		        -- 活動名稱	       
    category 			NVARCHAR(50),                       -- 活動分類
    limit 				INT,							    -- 可報名人數     
    [current] 			INT,							    -- 目前報名人數       
    date 				DATE NOT NULL,					    -- 活動日期
    [end]				DATE NOT NULL,					    -- 活動結束日期
    time 				NVARCHAR(20),					    -- 活動時間
    registration_start	DATE NOT NULL,					    -- 報名開始日期
    registration_end	DATE NOT NULL,					    -- 報名結束日期
    location 			NVARCHAR(100),                      -- 上課地點
    latitude 			DECIMAL(10,6) NOT NULL,			    -- 經度
    longitude 			DECIMAL(10,6) NOT NULL,			    -- 緯度
    instructor 			NVARCHAR(100),                      -- 授課老師
    status 				BIT DEFAULT 1,                      -- 狀態（如：1 = 可報名、0 = 已額滿）
    description 		NVARCHAR(MAX),                      -- 活動說明
    image				NVARCHAR(MAX)					    -- 活動圖片
);

-- 活動預約表
CREATE TABLE activity_registration (
    id 					INT PRIMARY KEY IDENTITY(1,1),	    -- 自動遞增
    activity_id 		INT ,			  				    -- 活動id
    member_id			INT ,						    -- 會員id
    num					INT,							    -- 報名人數(可大於1)
    scheduled_at		DATETIME2 ,							-- 預約的時間
    status				NVARCHAR(50),							-- 預約狀況
);

-- 分類表
CREATE TABLE activity_category (
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(50) NOT NULL UNIQUE,
  is_active BIT NOT NULL DEFAULT 1
);

DROP TABLE activity_registration
select * from activity_registration;
drop table activity_registration;

-- 活動預約表 → 約束(會員表)
	ALTER TABLE activity_registration
	ADD CONSTRAINT FK_activity_registration_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

	ALTER TABLE activity_registration
	ADD CONSTRAINT FK_activity_registration_member
	FOREIGN KEY (member_id) REFERENCES member(id);



DROP TABLE activity
SELECT * FROM activity_category
-- 測試資料
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'畫廊參訪', N'展覽', 20, 5, '2025-09-10', '2025-09-10', N'09:00-11:00', '2025-08-20', '2025-09-05', N'台北市信義區社區中心', 25.033964, 121.564468, N'王老師', 0, N'適合長者培養文藝氣息', N'/images/calligraphy.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'樂齡桌遊團康', N'團康', 15, 6, '2025-09-18', '2025-09-18', N'14:00-16:00', '2025-08-25', '2025-08-30', N'新北市新店老人活動中心', 25.000000, 121.000000, N'社工小張', 1, N'促進人際互動與腦力激盪的桌遊活動', N'/images/game.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'藝術參訪', N'展覽', 30, 12, '2025-09-25', '2025-09-25', N'10:00-12:00', '2025-08-21', '2025-09-22', N'桃園市中壢區圖書館', 24.957123, 121.225789, N'導覽林小姐', 1, N'參觀大畫家的作品', N'/images/art.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'教你泡出一手好茶', N'課程', 30, 0, '2025-09-05', '2025-09-05', N'09:00-17:00', '2025-08-26', '2025-09-04', N'台北市信義區松仁路100號', 25.033000, 121.565400, N'李大帥', 1, N'一家泡茶萬家香。', N'/images/tea.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'書法生動說', N'課程', 30, 0, '2025-09-30', '2025-09-30', N'09:00-17:00', '2025-08-27', '2025-09-05', N'台北市信義區松仁路101號', 25.000000, 15.000000, N'李大帥', 1, N'展現好手藝就在書法大賽', N'/images/pen.jpg');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'一起來尬舞', N'課程', 30, 0, '2025-08-29', '2025-08-29', N'09:00-17:00', '2025-08-29', '2025-09-04', N'台北市信義區松仁路100號', 25.033000, 121.565400, N'李大帥', 1, N'民俗舞蹈教學', N'/images/dance.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'合唱團', N'課程', 20, 0, '2025-09-15', '2025-09-15', N'09:00-11:00', '2025-09-01', '2025-09-14', N'台北市信義區松仁路110號', 25.047800, 121.531900, N'王老師', 1, N'教導正確發音', N'/images/choir.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'智慧型手機教學', N'課程', 30, 0, '2025-08-30', '2025-08-30', N'09:00-17:00', '2025-08-30', '2025-09-05', N'台北市信義區松仁路100號', 25.033000, 121.565400, N'王老闆', 1, N'拍出美美的照片', N'/images/phone_photo.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'健康講座', N'講座', 30, 0, '2025-08-30', '2025-08-30', N'09:00-17:00', '2025-08-30', '2025-09-05', N'台北市信義區松仁路100號', 25.033000, 121.565400, N'毛哥', 1, N'身體健康最重要', N'/images/healthy.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'吉他課', N'課程', 30, 0, '2025-08-30', '2025-08-30', N'09:00-17:00', '2025-08-30', '2025-09-05', N'台北市信義區松仁路100號', 25.033000, 121.565400, N'李小兵', 1, N'組一個搖滾樂團', N'/images/music.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'園藝課', N'課程', 30, 0, '2025-08-30', '2025-08-30', N'09:00-17:00', '2025-08-30', '2025-09-05', N'台北市信義區松仁路100號', 25.033000, 121.565400, N'勳哥', 1, N'欣賞植物的美', N'/images/gardening.png');

-- 初始化（重複跑也不會重複塞）
INSERT INTO activity_category(name)
SELECT N'課程' WHERE NOT EXISTS (SELECT 1 FROM activity_category WHERE name=N'課程');

INSERT INTO activity_category(name)
SELECT N'展覽' WHERE NOT EXISTS (SELECT 1 FROM activity_category WHERE name=N'展覽');

INSERT INTO activity_category(name)
SELECT N'團康' WHERE NOT EXISTS (SELECT 1 FROM activity_category WHERE name=N'團康');

INSERT INTO activity_category(name)
SELECT N'講座' WHERE NOT EXISTS (SELECT 1 FROM activity_category WHERE name=N'講座');