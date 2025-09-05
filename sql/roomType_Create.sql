
/* 1) 會員（組長版） */
CREATE TABLE member (
    member_id    INT           IDENTITY(1,1) PRIMARY KEY,
    line_user_id NVARCHAR(255) NOT NULL,              -- LINE userId
    member_name  NVARCHAR(100) NOT NULL,
    main_phone   VARCHAR(20)   NULL,                       -- 先不唯一，方便第三方測試（之後用過濾唯一索引）
    gender       BIT           NULL,
    birthday     DATE          NULL,
    address      NVARCHAR(100) NULL,
    email        NVARCHAR(200) NULL,                       -- 建議加入，利於 email 合併/通知
    image_path   NVARCHAR(500) NULL,                       -- 對外顯示用頭像（你家CDN/上傳圖）
    is_active    BIT           DEFAULT 1,
    ban_reason   NVARCHAR(MAX) NULL,
    created_at   DATE          DEFAULT CAST(SYSUTCDATETIME() AS DATE),  -- 明確轉型
    updated_at   DATETIME2     DEFAULT SYSUTCDATETIME(),
    login_at     DATETIME2     DEFAULT SYSUTCDATETIME()
);

/* 2) 房型主表 */
CREATE TABLE roomtype (
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(50) NOT NULL,
  price INT NOT NULL,
  capacity INT NOT NULL,
  description NVARCHAR(255),
  image_path NVARCHAR(255),
  is_available BIT DEFAULT 1,
  admin_note NVARCHAR(255),
  created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME2
);

/* 3) 特徵主表（房型標籤） */
CREATE TABLE room_features (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(50) NOT NULL UNIQUE
);

/* 4) 房型×特徵（多對多） */
INSERT INTO roomtype_feature (roomtype_id, feature_id) VALUES
(1, 3),(1, 4),(2, 1),(2, 3),
(2, 4),(2, 5),(3, 1),(3, 5),
(4, 1),(4, 4),(5, 1),(5, 2),
(5, 3),(5, 4),(5, 5),(8, 1),
(8, 2),(8, 3);

/* 5) 設施主表（獨立，不綁房型） */
CREATE TABLE facility (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(100) NOT NULL ,
  description NVARCHAR(500),
  image_path NVARCHAR(255),
  is_available BIT NOT NULL DEFAULT 1,
  created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  updated_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

/* 6) 會員收藏房型（選配） */
CREATE TABLE favorite_room (
  member_id   INT NOT NULL,
  roomtype_id INT NOT NULL,
  created_at  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  PRIMARY KEY (member_id, roomtype_id),
);

/* 7) 預約主表（前台填、後台審） */
CREATE TABLE reservation (
  reservation_id  INT IDENTITY(1,1) PRIMARY KEY,
  member_id       INT NULL,                        -- 非會員也能預約就允許 NULL
  applicant_name  NVARCHAR(50) NULL,               -- 訪客姓名（當 member_id 為 NULL）
  main_phone      VARCHAR(20) NOT NULL,
  roomtype_id     INT NULL,                        -- 指定想看的房型（可選）
  party_size      INT NOT NULL DEFAULT 1,          -- 預約人數(>=1)
  preferred_date  DATE NOT NULL,                   -- 偏好日期
  time_from       TIME NOT NULL,                   -- 偏好起
  time_to         TIME NOT NULL,                   -- 偏好迄
  status          TINYINT NOT NULL DEFAULT 0,      -- 0待審,1已確認,2取消,3已完成,4未到
  note            NVARCHAR(500) NULL,
  created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  updated_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  CONSTRAINT CK_reservation_party_size CHECK (party_size >= 1),
  CONSTRAINT CK_reservation_status CHECK (status IN (0,1,2,3,4)),
  
);

/* 8) 房型留言（含審核，選配） */
CREATE TABLE room_comment (
  id          INT IDENTITY(1,1) PRIMARY KEY,
  member_id   INT NOT NULL,
  roomtype_id INT NOT NULL,
  content     NVARCHAR(1000) NOT NULL,
  is_approved BIT NOT NULL DEFAULT 0,              -- 0:待審, 1:通過
  admin_reply NVARCHAR(1000) NULL,
  created_at  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

);

/* 建議索引（加速報表/後台查詢；可選） */
CREATE INDEX IX_reservation_created   ON reservation (created_at);
CREATE INDEX IX_reservation_roomtype  ON reservation (roomtype_id, created_at);
CREATE INDEX IX_favorite_room_room    ON favorite_room (roomtype_id);
CREATE INDEX IX_room_comment_room     ON room_comment (roomtype_id);
