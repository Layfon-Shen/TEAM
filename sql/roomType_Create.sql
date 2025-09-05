
/* 1) �|���]�ժ����^ */
CREATE TABLE member (
    member_id    INT           IDENTITY(1,1) PRIMARY KEY,
    line_user_id NVARCHAR(255) NOT NULL,              -- LINE userId
    member_name  NVARCHAR(100) NOT NULL,
    main_phone   VARCHAR(20)   NULL,                       -- �����ߤ@�A��K�ĤT����ա]����ιL�o�ߤ@���ޡ^
    gender       BIT           NULL,
    birthday     DATE          NULL,
    address      NVARCHAR(100) NULL,
    email        NVARCHAR(200) NULL,                       -- ��ĳ�[�J�A�Q�� email �X��/�q��
    image_path   NVARCHAR(500) NULL,                       -- ��~��ܥ��Y���]�A�aCDN/�W�ǹϡ^
    is_active    BIT           DEFAULT 1,
    ban_reason   NVARCHAR(MAX) NULL,
    created_at   DATE          DEFAULT CAST(SYSUTCDATETIME() AS DATE),  -- ���T�૬
    updated_at   DATETIME2     DEFAULT SYSUTCDATETIME(),
    login_at     DATETIME2     DEFAULT SYSUTCDATETIME()
);

/* 2) �Ы��D�� */
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

/* 3) �S�x�D��]�Ы����ҡ^ */
CREATE TABLE room_features (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(50) NOT NULL UNIQUE
);

/* 4) �Ы��ѯS�x�]�h��h�^ */
INSERT INTO roomtype_feature (roomtype_id, feature_id) VALUES
(1, 3),(1, 4),(2, 1),(2, 3),
(2, 4),(2, 5),(3, 1),(3, 5),
(4, 1),(4, 4),(5, 1),(5, 2),
(5, 3),(5, 4),(5, 5),(8, 1),
(8, 2),(8, 3);

/* 5) �]�I�D��]�W�ߡA���j�Ы��^ */
CREATE TABLE facility (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(100) NOT NULL ,
  description NVARCHAR(500),
  image_path NVARCHAR(255),
  is_available BIT NOT NULL DEFAULT 1,
  created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  updated_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

/* 6) �|�����éЫ��]��t�^ */
CREATE TABLE favorite_room (
  member_id   INT NOT NULL,
  roomtype_id INT NOT NULL,
  created_at  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  PRIMARY KEY (member_id, roomtype_id),
);

/* 7) �w���D��]�e�x��B��x�f�^ */
CREATE TABLE reservation (
  reservation_id  INT IDENTITY(1,1) PRIMARY KEY,
  member_id       INT NULL,                        -- �D�|���]��w���N���\ NULL
  applicant_name  NVARCHAR(50) NULL,               -- �X�ȩm�W�]�� member_id �� NULL�^
  main_phone      VARCHAR(20) NOT NULL,
  roomtype_id     INT NULL,                        -- ���w�Q�ݪ��Ы��]�i��^
  party_size      INT NOT NULL DEFAULT 1,          -- �w���H��(>=1)
  preferred_date  DATE NOT NULL,                   -- ���n���
  time_from       TIME NOT NULL,                   -- ���n�_
  time_to         TIME NOT NULL,                   -- ���n��
  status          TINYINT NOT NULL DEFAULT 0,      -- 0�ݼf,1�w�T�{,2����,3�w����,4����
  note            NVARCHAR(500) NULL,
  created_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  updated_at      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  CONSTRAINT CK_reservation_party_size CHECK (party_size >= 1),
  CONSTRAINT CK_reservation_status CHECK (status IN (0,1,2,3,4)),
  
);

/* 8) �Ы��d���]�t�f�֡A��t�^ */
CREATE TABLE room_comment (
  id          INT IDENTITY(1,1) PRIMARY KEY,
  member_id   INT NOT NULL,
  roomtype_id INT NOT NULL,
  content     NVARCHAR(1000) NOT NULL,
  is_approved BIT NOT NULL DEFAULT 0,              -- 0:�ݼf, 1:�q�L
  admin_reply NVARCHAR(1000) NULL,
  created_at  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

);

/* ��ĳ���ޡ]�[�t����/��x�d�ߡF�i��^ */
CREATE INDEX IX_reservation_created   ON reservation (created_at);
CREATE INDEX IX_reservation_roomtype  ON reservation (roomtype_id, created_at);
CREATE INDEX IX_favorite_room_room    ON favorite_room (roomtype_id);
CREATE INDEX IX_room_comment_room     ON room_comment (roomtype_id);
