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

-- ���ո��
-- 1. ���J 3 �ب���
INSERT INTO emp_role (role_name)
VALUES 
  ('ROLE_ADMIN'),
  ('ROLE_EMPLOYEE'),
  ('ROLE_MANAGER');

-- 2. ���J 3 ����u�]��l���ĥιw�]�ȡ^�w�]�K�X 123456
INSERT INTO employee (emp_name, password, email, image_path, describe)
VALUES
  ('alice',   '$2a$10$ncv2xzeO8gEjsJXLwbqh3uHfdYQ6eLLc5AYq1NI8J0BWp9KjsiVdW',   'test1@gmail.com',   '/images/alice.png',   'Alice �t�d�e�ݶ}�o'),
  ('bob',     '$2a$10$ncv2xzeO8gEjsJXLwbqh3uHfdYQ6eLLc5AYq1NI8J0BWp9KjsiVdW',    'test2@gmail.com',     '/images/2.png',     'Bob �t�d��ݪA��'),
  ('carol',   '$2a$10$ncv2xzeO8gEjsJXLwbqh3uHfdYQ6eLLc5AYq1NI8J0BWp9KjsiVdW',     'test3@gmail.com',   '/images/3.png',   'Carol �t�d���ջP���p');

-- 3. �إ߭��u�P���⪺����
INSERT INTO emp_has_role (emp_id, role_id)
VALUES
  (1, 1),   -- alice �� Admin + Manager
  (1, 2),
  (2, 2),   -- bob   �� Manager
  (3, 3);   -- carol �� Employee


-- �|���Ψ�
CREATE TABLE emp_log (
     id          BIGINT      IDENTITY(1,1) PRIMARY KEY,
     emp_name    NVARCHAR(50)    NOT NULL UNIQUE,
     action      VARCHAR(50) NOT NULL,
     target_name NVARCHAR(50)    NOT NULL UNIQUE,
     created_at  DATETIME2   NOT NULL DEFAULT SYSUTCDATETIME()
);


CREATE TABLE member (
      member_id       INT            IDENTITY(1,1)    PRIMARY KEY,
      member_name       NVARCHAR(50)   NOT NULL,
      main_phone      VARCHAR(20)    NOT NULL          UNIQUE,
      gender          BIT            NOT NULL,
      birthday      DATE           NOT NULL,
      is_active       BIT                           DEFAULT 1,
      ban_at          DATE           NULL,
      ban_reason      NVARCHAR(MAX)  NULL,
      caregiver_name  NVARCHAR(50)   NULL,
      caregiver_phone VARCHAR(20)                      UNIQUE,
      created_at      DATETIME2                     DEFAULT SYSUTCDATETIME(),
      login_at        DATETIME2                     DEFAULT SYSUTCDATETIME()
);

CREATE TABLE phone_verification (
      id            BIGINT       IDENTITY(1,1)    PRIMARY KEY,
      member_id     INT          NOT NULL,
      otp_code      CHAR(6)      NOT NULL,
      expires_at    DATETIME2    NOT NULL,
      is_used       BIT                        DEFAULT 0,
);

