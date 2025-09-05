-- device_category（輔具分類表）
CREATE TABLE devicecategory (
    id INT IDENTITY(1,1) PRIMARY KEY,      -- PK：分類唯一識別，流水號
    name NVARCHAR(255) NOT NULL,           -- NOT NULL：分類必須有名稱
    category_id INT                        -- 排序用數字（非約束）
);

-- device（輔具商品表）
CREATE TABLE device (
    id INT IDENTITY(1,1) PRIMARY KEY,          -- PK：商品唯一識別，流水號
    name NVARCHAR(255) NOT NULL,               -- NOT NULL：商品必須有名稱
    sku NVARCHAR(50),                          -- SKU（非約束）
    unit_price DECIMAL(10,2) NOT NULL,         -- NOT NULL：下單/顯示必備單價
    inventory INT,                             -- 庫存（非約束）
    description NVARCHAR(MAX),                 -- 描述（非約束）
    image NVARCHAR(255),                       -- 圖片路徑（非約束）
    is_online BIT NOT NULL,                    -- NOT NULL：是否上架必填（1/0）
    category_id INT,                           -- FK 目標欄位（見下方外鍵）
    created_by_emp_id INT,                     -- FK 目標欄位（見下方外鍵）
    created_at DATETIME2 DEFAULT SYSDATETIME(),-- DEFAULT：自動帶入建立時間
    CONSTRAINT fk_device_category
        FOREIGN KEY (category_id)              -- FK：分類存在性約束
        REFERENCES devicecategory(id),
    CONSTRAINT fk_device_created_by
        FOREIGN KEY (created_by_emp_id)        -- FK：上架員工存在性約束
        REFERENCES employee(emp_id)
);

-- address（會員收件地址）
CREATE TABLE address (
    id INT IDENTITY(1,1) PRIMARY KEY,          -- PK：地址唯一識別，流水號
    member_id INT NOT NULL,                    -- NOT NULL：地址必需隸屬某會員
    recipient NVARCHAR(100) NOT NULL,          -- NOT NULL：收件人姓名必填
    phone NVARCHAR(20) NOT NULL,               -- NOT NULL：電話必填
    postal_code NVARCHAR(10) NOT NULL,         -- NOT NULL：郵遞區號必填
    address_line1 NVARCHAR(255) NOT NULL,      -- NOT NULL：主要地址必填
    address_line2 NVARCHAR(255),               -- 補充地址（非約束）
    is_default BIT NOT NULL DEFAULT 0,         -- NOT NULL+DEFAULT：預設值為0
    created_at DATETIME2 DEFAULT SYSDATETIME(),-- DEFAULT：自動帶入建立時間
    CONSTRAINT fk_address_member
        FOREIGN KEY (member_id)                -- FK：會員存在性約束
        REFERENCES member(member_id)
);

-- cart（購物車主表）
CREATE TABLE cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,     -- PK：購物車唯一識別，流水號
    member_id INT NULL,                        -- 會員ID，可為NULL代表訪客
    guest_token NVARCHAR(100) NULL,            -- 訪客識別token
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),  -- NOT NULL+DEFAULT
    CONSTRAINT fk_cart_member
        FOREIGN KEY (member_id)                -- FK：會員存在性約束（會員車）
        REFERENCES member(member_id),
    CONSTRAINT uq_cart_member_guest
        UNIQUE (member_id, guest_token)        -- UNIQUE：限制(member_id, guest_token)
                                               -- 會員（guest_token=NULL）僅能有一筆
                                               -- 訪客（member_id=NULL）以token唯一
);

-- cart_item（購物車項目）
CREATE TABLE cart_item (
    cart_id INT NOT NULL,                      -- NOT NULL：必屬某購物車
    device_id INT NOT NULL,                    -- NOT NULL：必為某商品
    quantity INT NOT NULL,                     -- NOT NULL：數量必填
    added_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(), -- NOT NULL+DEFAULT
    CONSTRAINT pk_cart_item
        PRIMARY KEY (cart_id, device_id),      -- PK（複合）：同一車同一商品僅一筆
    CONSTRAINT fk_cartitem_cart
        FOREIGN KEY (cart_id)                  -- FK：購物車存在性約束
        REFERENCES cart(cart_id),
    CONSTRAINT fk_cartitem_device
        FOREIGN KEY (device_id)                -- FK：商品存在性約束
        REFERENCES device(id)
);

-- orders（訂單主表）
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,          -- PK：訂單唯一識別，流水號
    order_no NVARCHAR(30) NOT NULL UNIQUE,     -- NOT NULL+UNIQUE：對外唯一編號
    member_id INT NOT NULL,                    -- NOT NULL：下單者必填
    address_id INT NOT NULL,                   -- NOT NULL：寄送地址必填
    status NVARCHAR(20) NOT NULL DEFAULT 'PENDING', -- NOT NULL+DEFAULT
    total_amount DECIMAL(10,2) NOT NULL,       -- NOT NULL：總金額必填
    payment_method NVARCHAR(20),               -- 支付方式（非約束）
    payment_status NVARCHAR(20) NOT NULL DEFAULT 'PENDING', -- NOT NULL+DEFAULT
    transaction_no NVARCHAR(50),               -- 金流交易編號（非約束）
    paid_at DATETIME2,                         -- 付款完成時間（非約束）
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(), -- NOT NULL+DEFAULT
    CONSTRAINT fk_order_member
        FOREIGN KEY (member_id)                -- FK：會員存在性約束
        REFERENCES member(member_id),
    CONSTRAINT fk_order_address
        FOREIGN KEY (address_id)               -- FK：地址存在性約束
        REFERENCES address(id),
    CONSTRAINT chk_order_status
        CHECK (status IN                      -- CHECK：訂單狀態限定清單
              ('PENDING','SHIPPED','CANCELLED','COMPLETED','RETURNED')),
    CONSTRAINT chk_payment_status
        CHECK (payment_status IN              -- CHECK：付款狀態限定清單
              ('PENDING','PAID','FAILED','REFUNDED'))
);

-- order_item（訂單明細）
CREATE TABLE order_item (
    order_id INT NOT NULL,                      -- NOT NULL：必屬某訂單
    device_id INT NOT NULL,                     -- NOT NULL：必為某商品
    unit_price DECIMAL(10,2) NOT NULL,          -- NOT NULL：下單時單價鎖定
    quantity INT NOT NULL,                      -- NOT NULL：數量必填
    CONSTRAINT pk_order_item
        PRIMARY KEY (order_id, device_id),      -- PK（複合）：每筆訂單對同商品僅一列
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (order_id)                  -- FK：訂單存在性約束
        REFERENCES orders(id),
    CONSTRAINT fk_orderitem_device
        FOREIGN KEY (device_id)                 -- FK：商品存在性約束
        REFERENCES device(id)
);


--========= 插入輔具分類（devicecategory）=========
INSERT INTO devicecategory (name, category_id)
VALUES 
(N'輪椅', 1),
(N'拐杖', 2),
(N'助行器', 3),
(N'洗澡椅', 4),
(N'電動床', 5),
(N'便盆椅', 6),
(N'氣墊床', 7),
(N'護具', 8),
(N'代步車', 9),
(N'移位機', 10);

--========= 插入輔具商品（device）=========
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'老人助行拐杖', N'CA-001', 562.00, 30, N'防滑舒適手柄久握不累，減震底座保護膝關節。', N'device-3-1756439196572.webp', 1, 2, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'兩段式伸縮拐杖', N'CA-002', 850.00, 20, N'兩段式手杖，設計最短可收納到約62公分。', N'device-4-1756439260316.webp', 1, 2, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'標準助行器', N'WK-001', 1500.00, 10, N'助行器是一種在步行時可以讓人支撐並保持身體平衡的裝置，一些年老體弱、腿腳不便的人士需要用到助行器。', N'device-5-1756371269735.png', 1, 3, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'洗澡椅', N'BS-001', 1200.00, 18, N'具有防滑座椅和扶手，以幫助使用者在洗澡時維持平衡和穩定。', N'device-6-1756371335728.png', 1, 4, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'電動照護床', N'BD-001', 35000.00, 2, N'電動床能夠根據需求精準調整，提供完美的坐臥體驗。', N'device-7-1756371402403.png', 1, 5, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'便盆椅', N'PC-001', 2000.00, 8, N'附輪便盆椅，含扶手', N'device-8-1756371527139.webp', 1, 6, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'氣墊床', N'AM-001', 5000.00, 6, N'防褥瘡氣墊床，低噪音幫浦', N'device-9-1756439327399.jpg', 1, 7, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'護具', N'SP-001', 2000.00, 15, N'輔助行走', N'device-10-1756439348145.png', 1, 8, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'代步車', N'SC-001', 12005.00, 24, N'適合需要在戶外長時間移動的長者。', N'device-11-1756439363441.png', 1, 9, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'電動移位機', N'TL-001', 18000.00, 3, N'可承載 150 公斤，方便照護者操作', N'device-12-1756371739800.webp', 1, 10, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'拐杖', N'CA-017', 800.00, 18, N'輔助走路', N'device-1002-1756371205986.png', 1, 2, 1, '2025-08-28 16:53:25.9609679');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'工學電動床', N'SKU115', 600.00, 30, N'雙開式護欄、四個雙踏板煞車輪、四段式床面、可調整床底腳架', N'device-1003-1756439299983.png', 1, 5, NULL, '2025-08-28 16:58:06.5266535');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'測試輔具', N'SKU6755', 999.00, 10, N'這是測試用的輔具說明。', N'device-1005-1756446375242.webp', 1, 1, 1, '2025-08-29 13:46:15.2219533');

--========= 插入 address =========
INSERT INTO address (member_id, recipient, phone, postal_code, address_line1, address_line2, is_default)
VALUES
(2005, N'珊迪', '0985784765', '100', N'台北市中正區仁愛路2號', NULL, 1);

SELECT * FROM devicecategory;
SELECT * FROM device

SELECT * FROM address;
SELECT * FROM cart;
SELECT * FROM cart_item;

SELECT * FROM orders;
SELECT * FROM order_item ;