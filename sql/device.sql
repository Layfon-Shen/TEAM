-- device_category�]���������^
CREATE TABLE devicecategory (
    id INT IDENTITY(1,1) PRIMARY KEY,      -- PK�G�����ߤ@�ѧO�A�y����
    name NVARCHAR(255) NOT NULL,           -- NOT NULL�G�����������W��
    category_id INT                        -- �ƧǥμƦr�]�D�����^
);

-- device�]����ӫ~��^
CREATE TABLE device (
    id INT IDENTITY(1,1) PRIMARY KEY,          -- PK�G�ӫ~�ߤ@�ѧO�A�y����
    name NVARCHAR(255) NOT NULL,               -- NOT NULL�G�ӫ~�������W��
    sku NVARCHAR(50),                          -- SKU�]�D�����^
    unit_price DECIMAL(10,2) NOT NULL,         -- NOT NULL�G�U��/��ܥ��Ƴ��
    inventory INT,                             -- �w�s�]�D�����^
    description NVARCHAR(MAX),                 -- �y�z�]�D�����^
    image NVARCHAR(255),                       -- �Ϥ����|�]�D�����^
    is_online BIT NOT NULL,                    -- NOT NULL�G�O�_�W�[����]1/0�^
    category_id INT,                           -- FK �ؼ����]���U��~��^
    created_by_emp_id INT,                     -- FK �ؼ����]���U��~��^
    created_at DATETIME2 DEFAULT SYSDATETIME(),-- DEFAULT�G�۰ʱa�J�إ߮ɶ�
    CONSTRAINT fk_device_category
        FOREIGN KEY (category_id)              -- FK�G�����s�b�ʬ���
        REFERENCES devicecategory(id),
    CONSTRAINT fk_device_created_by
        FOREIGN KEY (created_by_emp_id)        -- FK�G�W�[���u�s�b�ʬ���
        REFERENCES employee(emp_id)
);

-- address�]�|������a�}�^
CREATE TABLE address (
    id INT IDENTITY(1,1) PRIMARY KEY,          -- PK�G�a�}�ߤ@�ѧO�A�y����
    member_id INT NOT NULL,                    -- NOT NULL�G�a�}�������ݬY�|��
    recipient NVARCHAR(100) NOT NULL,          -- NOT NULL�G����H�m�W����
    phone NVARCHAR(20) NOT NULL,               -- NOT NULL�G�q�ܥ���
    postal_code NVARCHAR(10) NOT NULL,         -- NOT NULL�G�l���ϸ�����
    address_line1 NVARCHAR(255) NOT NULL,      -- NOT NULL�G�D�n�a�}����
    address_line2 NVARCHAR(255),               -- �ɥR�a�}�]�D�����^
    is_default BIT NOT NULL DEFAULT 0,         -- NOT NULL+DEFAULT�G�w�]�Ȭ�0
    created_at DATETIME2 DEFAULT SYSDATETIME(),-- DEFAULT�G�۰ʱa�J�إ߮ɶ�
    CONSTRAINT fk_address_member
        FOREIGN KEY (member_id)                -- FK�G�|���s�b�ʬ���
        REFERENCES member(member_id)
);

-- cart�]�ʪ����D��^
CREATE TABLE cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,     -- PK�G�ʪ����ߤ@�ѧO�A�y����
    member_id INT NULL,                        -- �|��ID�A�i��NULL�N��X��
    guest_token NVARCHAR(100) NULL,            -- �X���ѧOtoken
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),  -- NOT NULL+DEFAULT
    CONSTRAINT fk_cart_member
        FOREIGN KEY (member_id)                -- FK�G�|���s�b�ʬ����]�|�����^
        REFERENCES member(member_id),
    CONSTRAINT uq_cart_member_guest
        UNIQUE (member_id, guest_token)        -- UNIQUE�G����(member_id, guest_token)
                                               -- �|���]guest_token=NULL�^�ȯ঳�@��
                                               -- �X�ȡ]member_id=NULL�^�Htoken�ߤ@
);

-- cart_item�]�ʪ������ء^
CREATE TABLE cart_item (
    cart_id INT NOT NULL,                      -- NOT NULL�G���ݬY�ʪ���
    device_id INT NOT NULL,                    -- NOT NULL�G�����Y�ӫ~
    quantity INT NOT NULL,                     -- NOT NULL�G�ƶq����
    added_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(), -- NOT NULL+DEFAULT
    CONSTRAINT pk_cart_item
        PRIMARY KEY (cart_id, device_id),      -- PK�]�ƦX�^�G�P�@���P�@�ӫ~�Ȥ@��
    CONSTRAINT fk_cartitem_cart
        FOREIGN KEY (cart_id)                  -- FK�G�ʪ����s�b�ʬ���
        REFERENCES cart(cart_id),
    CONSTRAINT fk_cartitem_device
        FOREIGN KEY (device_id)                -- FK�G�ӫ~�s�b�ʬ���
        REFERENCES device(id)
);

-- orders�]�q��D��^
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,          -- PK�G�q��ߤ@�ѧO�A�y����
    order_no NVARCHAR(30) NOT NULL UNIQUE,     -- NOT NULL+UNIQUE�G��~�ߤ@�s��
    member_id INT NOT NULL,                    -- NOT NULL�G�U��̥���
    address_id INT NOT NULL,                   -- NOT NULL�G�H�e�a�}����
    status NVARCHAR(20) NOT NULL DEFAULT 'PENDING', -- NOT NULL+DEFAULT
    total_amount DECIMAL(10,2) NOT NULL,       -- NOT NULL�G�`���B����
    payment_method NVARCHAR(20),               -- ��I�覡�]�D�����^
    payment_status NVARCHAR(20) NOT NULL DEFAULT 'PENDING', -- NOT NULL+DEFAULT
    transaction_no NVARCHAR(50),               -- ���y����s���]�D�����^
    paid_at DATETIME2,                         -- �I�ڧ����ɶ��]�D�����^
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(), -- NOT NULL+DEFAULT
    CONSTRAINT fk_order_member
        FOREIGN KEY (member_id)                -- FK�G�|���s�b�ʬ���
        REFERENCES member(member_id),
    CONSTRAINT fk_order_address
        FOREIGN KEY (address_id)               -- FK�G�a�}�s�b�ʬ���
        REFERENCES address(id),
    CONSTRAINT chk_order_status
        CHECK (status IN                      -- CHECK�G�q�檬�A���w�M��
              ('PENDING','SHIPPED','CANCELLED','COMPLETED','RETURNED')),
    CONSTRAINT chk_payment_status
        CHECK (payment_status IN              -- CHECK�G�I�ڪ��A���w�M��
              ('PENDING','PAID','FAILED','REFUNDED'))
);

-- order_item�]�q����ӡ^
CREATE TABLE order_item (
    order_id INT NOT NULL,                      -- NOT NULL�G���ݬY�q��
    device_id INT NOT NULL,                     -- NOT NULL�G�����Y�ӫ~
    unit_price DECIMAL(10,2) NOT NULL,          -- NOT NULL�G�U��ɳ����w
    quantity INT NOT NULL,                      -- NOT NULL�G�ƶq����
    CONSTRAINT pk_order_item
        PRIMARY KEY (order_id, device_id),      -- PK�]�ƦX�^�G�C���q���P�ӫ~�Ȥ@�C
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (order_id)                  -- FK�G�q��s�b�ʬ���
        REFERENCES orders(id),
    CONSTRAINT fk_orderitem_device
        FOREIGN KEY (device_id)                 -- FK�G�ӫ~�s�b�ʬ���
        REFERENCES device(id)
);


--========= ���J��������]devicecategory�^=========
INSERT INTO devicecategory (name, category_id)
VALUES 
(N'����', 1),
(N'���', 2),
(N'�U�澹', 3),
(N'�~����', 4),
(N'�q�ʧ�', 5),
(N'�K�ִ�', 6),
(N'��ԧ�', 7),
(N'�@��', 8),
(N'�N�B��', 9),
(N'�����', 10);

--========= ���J����ӫ~�]device�^=========
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'�ѤH�U����', N'CA-001', 562.00, 30, N'���ƵξA��`�[�����֡A��_���y�O�@�����`�C', N'device-3-1756439196572.webp', 1, 2, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'��q�����Y���', N'CA-002', 850.00, 20, N'��q������A�]�p�̵u�i���Ǩ��62�����C', N'device-4-1756439260316.webp', 1, 2, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'�зǧU�澹', N'WK-001', 1500.00, 10, N'�U�澹�O�@�ئb�B��ɥi�H���H�伵�ëO�����饭�Ū��˸m�A�@�Ǧ~����z�B�L�}���K���H�h�ݭn�Ψ�U�澹�C', N'device-5-1756371269735.png', 1, 3, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'�~����', N'BS-001', 1200.00, 18, N'�㦳���Ʈy�ȩM�ߤ�A�H���U�ϥΪ̦b�~���ɺ������ũMí�w�C', N'device-6-1756371335728.png', 1, 4, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'�q�ʷ��@��', N'BD-001', 35000.00, 2, N'�q�ʧɯ���ھڻݨD��ǽվ�A���ѧ�������������C', N'device-7-1756371402403.png', 1, 5, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'�K�ִ�', N'PC-001', 2000.00, 8, N'�����K�ִȡA�t�ߤ�', N'device-8-1756371527139.webp', 1, 6, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'��ԧ�', N'AM-001', 5000.00, 6, N'���ȽH��ԧɡA�C��������', N'device-9-1756439327399.jpg', 1, 7, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'�@��', N'SP-001', 2000.00, 15, N'���U�樫', N'device-10-1756439348145.png', 1, 8, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'�N�B��', N'SC-001', 12005.00, 24, N'�A�X�ݭn�b��~���ɶ����ʪ����̡C', N'device-11-1756439363441.png', 1, 9, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'�q�ʲ����', N'TL-001', 18000.00, 3, N'�i�Ӹ� 150 ����A��K���@�̾ާ@', N'device-12-1756371739800.webp', 1, 10, 1, '2025-08-27 20:40:00.0824838');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'���', N'CA-017', 800.00, 18, N'���U����', N'device-1002-1756371205986.png', 1, 2, 1, '2025-08-28 16:53:25.9609679');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'�u�ǹq�ʧ�', N'SKU115', 600.00, 30, N'���}���@��B�|������O�٨����B�|�q���ɭ��B�i�վ�ɩ��}�[', N'device-1003-1756439299983.png', 1, 5, NULL, '2025-08-28 16:58:06.5266535');
INSERT INTO device (name, sku, unit_price, inventory, description, image, is_online, category_id, created_by_emp_id, created_at) VALUES (N'���ջ���', N'SKU6755', 999.00, 10, N'�o�O���եΪ����㻡���C', N'device-1005-1756446375242.webp', 1, 1, 1, '2025-08-29 13:46:15.2219533');

--========= ���J address =========
INSERT INTO address (member_id, recipient, phone, postal_code, address_line1, address_line2, is_default)
VALUES
(2005, N'���}', '0985784765', '100', N'�x�_�������Ϥ��R��2��', NULL, 1);

SELECT * FROM devicecategory;
SELECT * FROM device

SELECT * FROM address;
SELECT * FROM cart;
SELECT * FROM cart_item;

SELECT * FROM orders;
SELECT * FROM order_item ;