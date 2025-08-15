--device_category�]���������^
CREATE TABLE devicecategory (
    id INT IDENTITY(1,1) PRIMARY KEY,          -- �����D��
    name NVARCHAR(255) NOT NULL,               -- �����W��
    category_id    INT                  -- �����ƧǥμƦr�A�Ʀr�V�p�V�e��
	);


--device�]����ӫ~��^
CREATE TABLE device (
    id INT IDENTITY(1,1) PRIMARY KEY,              -- �ӫ~�D��
    name NVARCHAR(255) NOT NULL,                   -- �ӫ~�W��
    sku NVARCHAR(50),                              -- �ӫ~�f���]SKU�^
  unit_price DECIMAL(10,2) NOT NULL,                     -- ���
    inventory INT,                                 -- �w�s�ƶq
    description NVARCHAR(MAX),                     -- �ӫ~�y�z
    image NVARCHAR(255),                           -- �Ϥ����|�]�Ȧs URL ���ɦW�^
   is_online BIT NOT NULL ,                              -- �O�_�W�[�]1�G�W�[�A0�G�U�[�^
    category_id INT,                               -- ���� ID�]FK �� DeviceCategory.id�^
    created_by_emp_id INT,                         -- �W�[�H�� ID�]FK �� employee.emp_id�^
    created_at DATETIME2 DEFAULT SYSDATETIME(),    -- �O���إ߮ɶ��]�۰ʱa�J�^

   -- �~������G���V������
    CONSTRAINT fk_device_category FOREIGN KEY (category_id)
        REFERENCES devicecategory(id),

    -- �~������G���V���u��]�W�[�H�^
    CONSTRAINT fk_device_created_by FOREIGN KEY (created_by_emp_id)
        REFERENCES employee(emp_id)
);

select* from device

select* from devicecategory