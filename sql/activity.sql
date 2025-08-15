-- [主表]
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
    image				NVARCHAR(255)					    -- 活動圖片
);

select * from Activity;
drop table Activity;

--[活動預約表]
CREATE TABLE activity_registration (
    id 					INT PRIMARY KEY IDENTITY(1,1),	    -- 自動遞增
    activity_id 		INT ,			  				    -- 活動id
    member_id			BIGINT ,						    -- 會員id
    num					INT,							    -- 報名人數(可大於1)
    scheduled_at		DATETIME ,							-- 預約的時間
    status				VARCHAR,							-- 預約狀況

);
-- 活動預約表 → 活動表、會員表
	ALTER TABLE activity_registration
	ADD CONSTRAINT FK_activity_registration_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

	ALTER TABLE activity_registration
	ADD CONSTRAINT FK_activity_registration_member
	FOREIGN KEY (member_id) REFERENCES member(id);

-- [活動標籤表]
CREATE TABLE activity_tag (
    id 					INT PRIMARY KEY IDENTITY(1,1),	    -- 自動遞增
    name 				NVARCHAR(50),                       -- 標籤名稱

);

-- [活動標籤連接表]
CREATE TABLE act_tag (
    activity_id 		INT,		  					    -- 活動id
    tag_id 				INT,                	            -- 標籤id
);
-- 活動標籤連接表 → 活動表、標籤表
	ALTER TABLE act_tag
	ADD CONSTRAINT FK_act_tag_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

	ALTER TABLE act_tag
	ADD CONSTRAINT FK_act_tag_activity_tag
	FOREIGN KEY (tag_id) REFERENCES activity_tag(id);


--[活動照片表]
CREATE TABLE activity_photo (
    id 					INT PRIMARY KEY IDENTITY(1,1),	    -- 自動遞增
    activity_id 		INT,		  						-- 活動id
    photo_url			NVARCHAR(255),						-- 照片路徑
    uploaded			DATETIME,							-- 照片上傳時間
);
-- 活動照片表 → 活動表
	ALTER TABLE activity_photo
	ADD CONSTRAINT FK_activity_photo_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

--[主辦方更新內容表-歷史活動]
CREATE TABLE activity_organizer (
    id              		INT PRIMARY KEY IDENTITY(1,1),	    -- 自動遞增
    activity_id 			INT ,			  					-- 活動id
    title        			NVARCHAR(100) NOT NULL,             -- 介紹標題
    content         		NVARCHAR(MAX) NOT NULL,       	    -- 介紹內容
    published_at    		DATETIME2     NOT NULL,   			-- 上傳時間
);
-- 活動主辦方更新表 → 活動表
	ALTER TABLE activity_organizer
	ADD CONSTRAINT FK_activity_organizer_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

--[活動留言表]
CREATE TABLE activity_comment (
    id              		INT PRIMARY KEY IDENTITY(1,1),	    -- 自動遞增
    activity_id 			INT ,			  					-- 活動id
    member_id				BIGINT ,							-- 會員id
    comment					NVARCHAR(MAX),						-- 留言內容
    rating					TINYINT NULL,						-- 星等評分
    created_at				DATETIME2,							-- 留言時間，預設系統時間
);
-- 活動留言表 → 活動表、會員表
	ALTER TABLE activity_comment
	ADD CONSTRAINT FK_activity_comment_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

	ALTER TABLE activity_comment
	ADD CONSTRAINT FK_activity_comment_member
	FOREIGN KEY (member_id) REFERENCES member(id);
