--device_category（輔具分類表）
CREATE TABLE devicecategory (
    id INT IDENTITY(1,1) PRIMARY KEY,          -- 分類主鍵
    name NVARCHAR(255) NOT NULL,               -- 分類名稱
    category_id    INT                  -- 分類排序用數字，數字越小越前面
	);


--device（輔具商品表）
CREATE TABLE device (
    id INT IDENTITY(1,1) PRIMARY KEY,              -- 商品主鍵
    name NVARCHAR(255) NOT NULL,                   -- 商品名稱
    sku NVARCHAR(50),                              -- 商品貨號（SKU）
  unit_price DECIMAL(10,2) NOT NULL,                     -- 單價
    inventory INT,                                 -- 庫存數量
    description NVARCHAR(MAX),                     -- 商品描述
    image NVARCHAR(255),                           -- 圖片路徑（僅存 URL 或檔名）
   is_online BIT NOT NULL ,                              -- 是否上架（1：上架，0：下架）
    category_id INT,                               -- 分類 ID（FK → DeviceCategory.id）
    created_by_emp_id INT,                         -- 上架人員 ID（FK → employee.emp_id）
    created_at DATETIME2 DEFAULT SYSDATETIME(),    -- 記錄建立時間（自動帶入）

   -- 外鍵約束：指向分類表
    CONSTRAINT fk_device_category FOREIGN KEY (category_id)
        REFERENCES devicecategory(id),

    -- 外鍵約束：指向員工表（上架人）
    CONSTRAINT fk_device_created_by FOREIGN KEY (created_by_emp_id)
        REFERENCES employee(emp_id)
);

select* from device

select* from devicecategory