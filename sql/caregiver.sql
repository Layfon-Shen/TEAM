----員工資料表(宗勳)
-- CREATE TABLE employee (
--    emp_id          INT             IDENTITY(1,1)   PRIMARY KEY,         
--    emp_name        NVARCHAR(50)    NOT NULL UNIQUE,                     
--    password        NVARCHAR(255)   NOT NULL,                            
--    email           NVARCHAR(200)   NULL,                                
--    role            NVARCHAR(50)    NOT NULL DEFAULT 'Employee',          
--    is_active        BIT             NOT NULL DEFAULT 1,                 
--    createdAt       DATE       NOT NULL DEFAULT SYSUTCDATETIME(),        
--    updatedAt       DATE       NOT NULL DEFAULT SYSUTCDATETIME(),        
--)

----會員資料表(宗勳)
--CREATE TABLE member (
--      member_id       INT            IDENTITY(1,1)    PRIMARY KEY,
--      member_name       NVARCHAR(50)   NOT NULL,
--      main_phone      VARCHAR(20)    NOT NULL          UNIQUE,
--      gender          BIT            NOT NULL,
--      birthday      DATE           NOT NULL,
--      is_active       BIT                           DEFAULT 1,
--      ban_at          DATE           NULL,
--      ban_reason      NVARCHAR(MAX)  NULL,
--      caregiver_name  NVARCHAR(50)   NULL,
--      caregiver_phone VARCHAR(20)                      UNIQUE,
--      created_at      DATETIME2                     DEFAULT SYSUTCDATETIME(),
--      login_at        DATETIME2                     DEFAULT SYSUTCDATETIME()
--);

-- 照服員基本資料
CREATE TABLE caregiver (
    caregiver_id      INT IDENTITY(1,1) PRIMARY KEY,      -- 照服員ID
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
    updated_at        DATETIME2 DEFAULT SYSDATETIME()     -- 修改時間
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
    status                  VARCHAR(20) NOT NULL DEFAULT 'scheduled', -- 預約狀態
    is_blocked              BIT NOT NULL DEFAULT 0,                   -- 是否為虛擬訂單(0=真實客戶 1=虛擬)
    service_type_id         INT,                                      -- 服務類型ID
    service_location        NVARCHAR(200),                            -- 服務地點
    total_amount            DECIMAL(10,2),                            -- 總金額
    notes                   NVARCHAR(500),                            -- 備註
    block_type              VARCHAR(50),                              -- 虛擬訂單原因
    
    -- 建立者相關欄位
    created_by_type         VARCHAR(20) NOT NULL DEFAULT 'system',    -- 建立者類型
    created_by_member_id    INT NULL,                                 -- 會員ID (當建立者為會員時)
    created_by_employee_id  INT NULL,                                 -- 員工ID (當建立者為員工時)
    
    -- 評分相關欄位
    rating_score            INT NULL,                                 -- 評價分數 (1-5分)
    rating_comment          NVARCHAR(500),                            -- 評語
    rated_at                DATETIME2 NULL,                           -- 評分時間
    is_rated                BIT DEFAULT 0,                            -- 是否已評分
    created_at              DATETIME2 NOT NULL DEFAULT SYSDATETIME(), -- 建立時間 
    cancelled_at            DATETIME2 NULL,                           -- 取消時間
    
	--CONSTRAINT FK_appointment_member 
 --       FOREIGN KEY (member_id) REFERENCES member(member_id),
 --   CONSTRAINT FK_appointment_caregiver 
 --       FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id),
 --   CONSTRAINT FK_appointment_service_type 
 --       FOREIGN KEY (service_type_id) REFERENCES service_type(service_type_id),
 --   CONSTRAINT FK_appointment_created_by_member 
 --       FOREIGN KEY (created_by_member_id) REFERENCES member(member_id),
 --   CONSTRAINT FK_appointment_created_by_employee 
 --       FOREIGN KEY (created_by_employee_id) REFERENCES employee(emp_id),
    
 --   -- 檢查約束
 --   CONSTRAINT chk_appointment_status 
 --       CHECK (status IN ('scheduled', 'completed', 'cancelled')),
 --   CONSTRAINT chk_appointment_block_type 
 --       CHECK (block_type IN ('off-work', 'break', 'training', 'leave', 'unavailable')),
 --   CONSTRAINT chk_appointment_created_by_type 
 --       CHECK (created_by_type IN ('caregiver', 'member', 'employee')),
 --   CONSTRAINT chk_appointment_created_by_logic 
 --       CHECK (
 --           (created_by_type = 'member' AND created_by_member_id IS NOT NULL AND created_by_employee_id IS NULL) OR
 --           (created_by_type = 'employee' AND created_by_employee_id IS NOT NULL AND created_by_member_id IS NULL) 
 --       ),
 --   CONSTRAINT chk_appointment_time_logic 
 --       CHECK (end_time > scheduled_at),
 --   CONSTRAINT chk_appointment_rating_score 
 --       CHECK (rating_score IS NULL OR rating_score BETWEEN 1 AND 5),
 --   CONSTRAINT chk_appointment_rating_logic 
 --       CHECK (
 --           (is_rated = 0 AND rating_score IS NULL AND rated_at IS NULL) OR
 --           (is_rated = 1 AND rating_score IS NOT NULL AND rated_at IS NOT NULL)
 --       )
);


-----測試資料----------------
INSERT INTO caregiver (
    chinese_name, gender, phone, email, experience_years, photo, 
    address, service_area, average_rating, total_ratings, total_points, is_active
) VALUES 
-- 照服員 1
('王美華', 0, '0912345678', 'wang.meihua@email.com', 5, 
 'https://example.com/photos/wang_meihua.jpg', '台北市大安區忠孝東路四段100號', 
 '台北市大安區', 4.5, 120, 540, 1),

-- 照服員 2  
('陳志明', 1, '0923456789', 'chen.zhiming@email.com', 3, 
 'https://example.com/photos/chen_zhiming.jpg', '新北市板橋區中山路二段50號', 
 '新北市板橋區', 4.2, 85, 357, 1),

-- 照服員 3
('李淑芳', 0, '0934567890', 'li.shufang@email.com', 8, 
 'https://example.com/photos/li_shufang.jpg', '台中市西屯區台灣大道三段200號', 
 '台中市西屯區', 4.8, 200, 960, 1),

-- 照服員 4
('張建國', 1, '0945678901', 'zhang.jianguo@email.com', 2, 
 'https://example.com/photos/zhang_jianguo.jpg', '高雄市左營區博愛二路300號', 
 '高雄市左營區', 3.9, 45, 176, 1),

-- 照服員 5
('劉惠玲', 0, '0956789012', 'liu.huiling@email.com', 6, 
 'https://example.com/photos/liu_huiling.jpg', '台南市中西區中正路150號', 
 '台南市中西區', 4.6, 160, 736, 1),

-- 照服員 6
('黃俊傑', 1, '0967890123', 'huang.junjie@email.com', 4, 
 'https://example.com/photos/huang_junjie.jpg', '桃園市中壢區中央路250號', 
 '桃園市中壢區', 4.1, 95, 390, 1),

-- 照服員 7
('吳秀英', 0, '0978901234', 'wu.xiuying@email.com', 7, 
 'https://example.com/photos/wu_xiuying.jpg', '新竹市東區光復路一段180號', 
 '新竹市東區', 4.7, 180, 846, 1),

-- 照服員 8
('林文華', 1, '0989012345', 'lin.wenhua@email.com', 1, 
 'https://example.com/photos/lin_wenhua.jpg', '嘉義市西區民生北路120號', 
 '嘉義市西區', 3.8, 25, 95, 1),

-- 照服員 9
('蔡雅婷', 0, '0990123456', 'cai.yating@email.com', 9, 
 'https://example.com/photos/cai_yating.jpg', '彰化市中正路二段80號', 
 '彰化市', 4.9, 250, 1225, 1),

-- 照服員 10
('鄭大偉', 1, '0901234567', 'zheng.dawei@email.com', 3, 
 'https://example.com/photos/zheng_dawei.jpg', '屏東市中山路350號', 
 '屏東市', 4.0, 70, 280, 1),

-- 照服員 11
('趙美玲', 0, '0912345670', 'zhao.meiling@email.com', 5, 
 'https://example.com/photos/zhao_meiling.jpg', '宜蘭市中山路五段90號', 
 '宜蘭市', 4.3, 110, 473, 1),

-- 照服員 12
('周志豪', 1, '0923456701', 'zhou.zhihao@email.com', 2, 
 'https://example.com/photos/zhou_zhihao.jpg', '花蓮市中正路400號', 
 '花蓮市', 3.7, 35, 130, 1),

-- 照服員 13
('徐慧君', 0, '0934567012', 'xu.huijun@email.com', 6, 
 'https://example.com/photos/xu_huijun.jpg', '台東市中華路一段220號', 
 '台東市', 4.4, 140, 616, 1),

-- 照服員 14
('孫立明', 1, '0945670123', 'sun.liming@email.com', 4, 
 'https://example.com/photos/sun_liming.jpg', '基隆市仁愛區愛一路160號', 
 '基隆市仁愛區', 4.2, 88, 370, 0),

-- 照服員 15
('馬淑華', 0, '0956701234', 'ma.shuhua@email.com', 10, 
 'https://example.com/photos/ma_shuhua.jpg', '苗栗市中正路680號', 
 '苗栗市', 4.8, 300, 1440, 1);
