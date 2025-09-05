SELECT * FROM caregiver;
SELECT * FROM service_type;
SELECT * FROM caregiver_appointment;
SELECT * FROM member;

SELECT caregiver_id, average_rating, total_ratings, total_points 
FROM caregiver 
WHERE caregiver_id = 1;

-- 照服員基本資料
CREATE TABLE caregiver (
    caregiver_id      INT IDENTITY(1000,1) PRIMARY KEY,      -- 照服員ID
    chinese_name      NVARCHAR(100) NOT NULL,             -- 中文姓名
    gender            BIT NOT NULL,                       -- 性別 (0=女性, 1=男性)
    phone             VARCHAR(20) NOT NULL UNIQUE,        -- 連絡電話
    email             NVARCHAR(100) NOT NULL,             -- 電子信箱
    experience_years  INT NOT NULL,                       -- 服務年資
    photo             NVARCHAR(500),                      -- 大頭貼
    address           NVARCHAR(200),                      -- 居住地址
    service_area      NVARCHAR(100),                      -- 服務區域
    average_rating    DECIMAL(3,2) DEFAULT 0,             -- 評價
    total_ratings     INT DEFAULT 0,                      -- 總評價次數
    total_points      INT DEFAULT 0,                      -- 總得分
    is_active         BIT DEFAULT 1,                      -- 是否在職(1=在職, 0=離職)
    created_at        DATETIME2 DEFAULT SYSDATETIME(),    -- 創立時間
    updated_at        DATETIME2 DEFAULT SYSDATETIME(),    -- 修改時間
	self_introduction NVARCHAR(1000) NULL,                -- 自我介紹 
);

-- 服務類型收費表
CREATE TABLE service_type (
    service_type_id   INT IDENTITY(1,1) PRIMARY KEY,      -- 服務類型ID
    service_name      NVARCHAR(100) NOT NULL,             -- 服務類型名稱
    hourly_rate       INT NOT NULL,                       -- 每小時費用
    description       NVARCHAR(500) NOT NULL,             -- 服務說明
    is_active         BIT DEFAULT 1,                      -- 是否啟用
    created_at        DATETIME2 DEFAULT SYSDATETIME(),    -- 建立時間
    updated_at        DATETIME2 DEFAULT SYSDATETIME()     -- 修改時間
);

-- 預約表 (包含評分資料)
CREATE TABLE caregiver_appointment (
    id                      BIGINT IDENTITY(1,1) PRIMARY KEY,         -- 預約單號ID
    member_id               INT,                                      -- 會員ID
    caregiver_id            INT NOT NULL,                             -- 照服員ID
    scheduled_at            DATETIME2 NOT NULL,                       -- 預約開始時間
    end_time                DATETIME2 NOT NULL,                       -- 預約結束時間
    status                  VARCHAR(20) NOT NULL DEFAULT 'pending',   -- 預約狀態
    is_blocked              BIT NOT NULL DEFAULT 0,                   -- 是否為虛擬訂單(0=真實客戶 1=虛擬)
    service_type_id         INT,                                      -- 服務類型ID
    service_location        NVARCHAR(200),                            -- 服務地點
    total_amount            DECIMAL(10,2),                            -- 總金額
    notes                   NVARCHAR(1000),                            -- 備註
    block_type              VARCHAR(50),                              -- 虛擬訂單原因
    
    -- 評分相關欄位
    rating_score            INT NULL,                                 -- 評價分數 (1-5分)
    rating_comment          NVARCHAR(500),                            -- 評語
    rated_at                DATETIME2 NULL,                           -- 評分時間
    is_rated                BIT DEFAULT 0,                            -- 是否已評分
    created_at              DATETIME2 NOT NULL DEFAULT SYSDATETIME(), -- 建立時間 
    cancelled_at            DATETIME2 NULL,                           -- 取消時間
    
	CONSTRAINT FK_appointment_member 
        FOREIGN KEY (member_id) REFERENCES member(member_id),
    CONSTRAINT FK_appointment_caregiver 
        FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id),
    CONSTRAINT FK_appointment_service_type 
        FOREIGN KEY (service_type_id) REFERENCES service_type(service_type_id),

    
    -- 檢查約束
    CONSTRAINT chk_appointment_status 
        CHECK (status IN ('pending','approved','rejected', 'completed', 'cancelled')),
    CONSTRAINT chk_appointment_block_type 
        CHECK (block_type IN ('off-work', 'break', 'training', 'leave', 'unavailable')),
    CONSTRAINT chk_appointment_time_logic 
        CHECK (end_time > scheduled_at),
    CONSTRAINT chk_appointment_rating_score 
        CHECK (rating_score IS NULL OR rating_score BETWEEN 1 AND 5),
    CONSTRAINT chk_appointment_rating_logic 
        CHECK (
            (is_rated = 0 AND rating_score IS NULL AND rated_at IS NULL) OR
            (is_rated = 1 AND rating_score IS NOT NULL AND rated_at IS NOT NULL)
        )
);


-----測試資料----------------
INSERT INTO caregiver (chinese_name, gender, phone, email, experience_years, photo, address, service_area, average_rating, total_ratings, total_points, is_active, created_at, updated_at, self_introduction) VALUES (N'王美華', 0, '0912345678', N'wang.meihua@email.com', 5, N'/images/caregiver/caregiver_photo/caregiver01.png', N'桃園市桃園區中正路200號', N'桃園區', 4.50, 120, 540, 1, '2025-08-28 19:12:29.2887210', '2025-08-29 17:21:18.2289537', N'我具備專業技能，能協助復健與日常照護，熱心可靠。');
INSERT INTO caregiver (chinese_name, gender, phone, email, experience_years, photo, address, service_area, average_rating, total_ratings, total_points, is_active, created_at, updated_at, self_introduction) VALUES (N'陳志明', 1, '0923456789', N'chen.zhiming@email.com', 3, N'/images/caregiver/caregiver_photo/caregiver02.png', N'桃園市中壢區環中東路300號', N'中壢區', 4.20, 85, 357, 1, '2025-08-28 19:12:29.2887210', '2025-08-29 17:21:31.0718226', N'我重視人與人間溫暖互動，專注於長者心理與身體需求。');
INSERT INTO caregiver (chinese_name, gender, phone, email, experience_years, photo, address, service_area, average_rating, total_ratings, total_points, is_active, created_at, updated_at, self_introduction) VALUES (N'李淑芳', 0, '0934567890', N'li.shufang@email.com', 8, N'/images/caregiver/caregiver_photo/caregiver03.png', N'桃園市平鎮區復興路120號', N'平鎮區', 4.80, 201, 964, 1, '2025-08-28 19:12:29.2887210', '2025-08-29 17:13:55.6159876', N'多年經驗累積專業，提供安全貼心的日常照顧與陪伴。');
INSERT INTO caregiver (chinese_name, gender, phone, email, experience_years, photo, address, service_area, average_rating, total_ratings, total_points, is_active, created_at, updated_at, self_introduction) VALUES (N'張建國', 1, '0945678901', N'zhang.jianguo@email.com', 2, N'/images/caregiver/caregiver_photo/caregiver04.png', N'桃園市龜山區文化一路88號', N'龜山區', 3.90, 45, 176, 1, '2025-08-28 19:12:29.2887210', '2025-08-28 19:12:29.2887210', N'以耐心與責任感為本，希望帶給長者安心與信任的服務。');
INSERT INTO caregiver (chinese_name, gender, phone, email, experience_years, photo, address, service_area, average_rating, total_ratings, total_points, is_active, created_at, updated_at, self_introduction) VALUES (N'劉惠玲', 0, '0956789012', N'liu.huiling@email.com', 6, N'/images/caregiver/caregiver_photo/caregiver05.png', N'桃園市八德區介壽路150號', N'八德區', 4.60, 160, 736, 1, '2025-08-28 19:12:29.2887210', '2025-08-28 19:12:29.2887210', N'我樂於協助日常生活，細心體貼，讓家屬能更放心。');
INSERT INTO caregiver (chinese_name, gender, phone, email, experience_years, photo, address, service_area, average_rating, total_ratings, total_points, is_active, created_at, updated_at, self_introduction) VALUES (N'黃俊傑', 1, '0967890123', N'huang.junjie@email.com', 4, N'/images/caregiver/caregiver_photo/caregiver06.png', N'桃園市蘆竹區南崁路250號', N'蘆竹區', 4.10, 95, 390, 1, '2025-08-28 19:12:29.2887210', '2025-08-28 19:12:29.2887210', N'我具備專業技能，能協助復健與日常照護，熱心可靠。');
INSERT INTO caregiver (chinese_name, gender, phone, email, experience_years, photo, address, service_area, average_rating, total_ratings, total_points, is_active, created_at, updated_at, self_introduction) VALUES (N'吳秀英', 0, '0978901234', N'wu.xiuying@email.com', 7, N'/images/caregiver/caregiver_photo/caregiver07.png', N'桃園市大溪區員林路180號', N'大溪區', 4.70, 180, 846, 1, '2025-08-28 19:12:29.2887210', '2025-08-28 19:12:29.2887210', N'我重視人與人間溫暖互動，專注於長者心理與身體需求。');
INSERT INTO caregiver (chinese_name, gender, phone, email, experience_years, photo, address, service_area, average_rating, total_ratings, total_points, is_active, created_at, updated_at, self_introduction) VALUES (N'林文華', 1, '0989012345', N'lin.wenhua@email.com', 1, N'/images/caregiver/caregiver_photo/caregiver08.png', N'桃園市楊梅區光華街120號', N'楊梅區', 3.80, 25, 95, 1, '2025-08-28 19:12:29.2887210', '2025-08-28 19:12:29.2887210', N'初入行但充滿熱忱，用心學習，希望帶來最好的照護。');
INSERT INTO caregiver (chinese_name, gender, phone, email, experience_years, photo, address, service_area, average_rating, total_ratings, total_points, is_active, created_at, updated_at, self_introduction) VALUES (N'吳麗雲', 0, '0934567891', N'test2@example.com', 1, N'/images/caregiver/caregiver_photo/caregiver10.png', N'桃園市中壢區中山路200號', N'新屋區', 4.00, 1, 4, 1, '2025-08-29 13:55:18.1212985', '2025-08-29 13:58:32.6614754', N'這是測試用自我介紹');


 -- 插入5服務類型測試資料
INSERT INTO service_type (
    service_name, hourly_rate, description, is_active
) VALUES 
-- 服務類型 1: 基礎照護
('基礎生活照護', 300, '協助長者日常生活起居，包含用餐協助、個人衛生清潔、穿衣換裝、基本活動協助等服務', 1),

-- 服務類型 2: 醫療照護  
('醫療照護服務', 450, '提供基礎醫療照護，包含血壓血糖監測、用藥提醒、傷口護理、復健協助等專業照護服務', 1),

-- 服務類型 3: 家事服務
('居家清潔服務', 250, '協助環境清潔整理，包含房間清掃、衣物整理、簡單家事處理、環境維護等服務', 1),

-- 服務類型 4: 陪伴服務
('陪伴關懷服務', 280, '提供情感支持與陪伴，包含聊天談話、休閒活動陪伴、外出購物協助、社交互動等服務', 1),

-- 服務類型 5: 專業照護
('專業護理照護', 550, '提供專業護理服務，包含管路護理、呼吸照護、特殊醫療設備操作、重症照護等高專業度服務', 1);


