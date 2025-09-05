CREATE TABLE member (
    member_id    INT           IDENTITY(1,1) PRIMARY KEY,
    line_user_id NVARCHAR(255) NOT NULL,              -- LINE userId
    member_name  NVARCHAR(100) NOT NULL,
    main_phone   VARCHAR(20)   NULL,                       
    gender       BIT           NULL,
    birthday     DATE          NULL,
    address      NVARCHAR(100) NULL,
    email        NVARCHAR(200) NULL,                      
    image_path   NVARCHAR(500) NULL,                      
    is_active    BIT           DEFAULT 1,
    ban_reason   NVARCHAR(MAX) NULL,
    created_at   DATE          DEFAULT CAST(SYSUTCDATETIME() AS DATE),  
    updated_at   DATETIME2     DEFAULT SYSUTCDATETIME(),
    login_at     DATETIME2     DEFAULT SYSUTCDATETIME()
);


CREATE TABLE employee (
      emp_id          INT             IDENTITY(1,1)  PRIMARY KEY,
      emp_name        NVARCHAR(50)    NOT NULL UNIQUE,
      password        NVARCHAR(255)   NOT NULL,
      email           NVARCHAR(200)   NOT NULL UNIQUE,
      is_active       BIT             NOT NULL DEFAULT 1,
      image_path      NVARCHAR(255)   NULL,
      describe        NVARCHAR(500)   NULL,
      created_at      DATE            NOT NULL DEFAULT SYSUTCDATETIME(),
      updated_at      DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
);

CREATE TABLE emp_role (
    role_id   INT   IDENTITY(1,1)  PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL UNIQUE,
);

CREATE TABLE emp_has_role (
    emp_id   INT NOT NULL,
    role_id  INT NOT NULL,
    PRIMARY KEY (emp_id, role_id),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES emp_role(role_id) ON DELETE CASCADE
);

CREATE TABLE pwdReset (
      id INT IDENTITY(1,1) PRIMARY KEY,
      emp_id INT NOT NULL,
      code CHAR(6) NOT NULL,
      expires_at DATETIME2 NOT NULL,
      used BIT NOT NULL DEFAULT 0
);

SELECT * from employee
DROP TABLE employee

-- 測試資料 員工登入 帳號: test1@gmail.com 密碼 123456
-- 1. 插入 3 種角色
INSERT INTO emp_role (role_name)
VALUES 
  ('ROLE_ADMIN'),
  ('ROLE_EMPLOYEE'),
  ('ROLE_MANAGER');

-- 2. 插入員工資料 
INSERT INTO employee (emp_name, password, email, is_active, image_path, describe)
VALUES
(N'Ryan', N'$2a$10$rkVDwHUZBMf8BjmswGMJTe0GxnmzCoIR/TFBkGBX83pW2wNse2lVu', N'test1@gmail.com', 1, N'/images/emp1.png', N'Alice Test5'),

(N'李小帥', N'$2a$10$rkVDwHUZBMf8BjmswGMJTe0GxnmzCoIR/TFBkGBX83pW2wNse2lVu', N'ryanshiun0@gmail.com', 1, N'/images/emp2.png', N'修改測試'),

(N'carol', N'$2a$12$kebR9FEdWqdkxlomsnezZuZt2881tXPORANkUg4IsqZ/tLbMXv6UWy', N'a0968399426@gmail.com', 1, N'/images/emp3.png', N'可進行驗證碼寄送'),

(N'李冰冰', N'$2a$12$kebR9FEdWqdkxlomsnezZuZt2881tXPORANkUg4IsqZ/tLbMXv6UWy', N'test4@gmail.com', 1, N'/images/emp4.png', '新來的菜鳥'),

(N'李大帥', N'$2a$12$kebR9FEdWqdkxlomsnezZuZt2881tXPORANkUg4IsqZ/tLbMXv6UWy', N'test5@gmail.com', 1, N'/images/emp5.png', N'Alice 負責前端開發'),

(N'李一', N'$2a$12$kebR9FEdWqdkxlomsnezZuZt2881tXPORANkUg4IsqZ/tLbMXv6UWy', N'test6@gmail.com', 1, N'/images/emp6.png', N'Bob 負責後端服務'),

(N'john', N'$2a$12$kebR9FEdWqdkxlomsnezZuZt2881tXPORANkUg4IsqZ/tLbMXv6UWy', N'test9@gmail.com', 1, N'/images/emp7.png', '老練工程師'),

(N'Euf', N'$2a$12$kebR9FEdWqdkxlomsnezZuZt2881tXPORANkUg4IsqZ/tLbMXv6UWy', N'test11@gmail.com', 1, N'/images/emp8.png', '技術顧問'),

(N'Bad Guys', N'$2a$12$kebR9FEdWqdkxlomsnezZuZt2881tXPORANkUg4IsqZ/tLbMXv6UWy', N'tset@gmail.com', 0, N'/images/emp8.png', '個性很奇特');



-- 3. 建立員工與角色的對應
INSERT INTO emp_has_role (emp_id, role_id)
VALUES
  (1, 1),   -- alice → Admin + Manager
  (1, 2),
  (2, 2),   -- bob   → Manager
  (3, 3);   -- carol → Employee


