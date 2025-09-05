-- ���ʥD��
CREATE TABLE activity (
    id 					INT PRIMARY KEY IDENTITY(1,1),	    -- �۰ʻ��W     
    name 				NVARCHAR(100) NOT NULL,		        -- ���ʦW��	       
    category 			NVARCHAR(50),                       -- ���ʤ���
    limit 				INT,							    -- �i���W�H��     
    [current] 			INT,							    -- �ثe���W�H��       
    date 				DATE NOT NULL,					    -- ���ʤ��
    [end]				DATE NOT NULL,					    -- ���ʵ������
    time 				NVARCHAR(20),					    -- ���ʮɶ�
    registration_start	DATE NOT NULL,					    -- ���W�}�l���
    registration_end	DATE NOT NULL,					    -- ���W�������
    location 			NVARCHAR(100),                      -- �W�Ҧa�I
    latitude 			DECIMAL(10,6) NOT NULL,			    -- �g��
    longitude 			DECIMAL(10,6) NOT NULL,			    -- �n��
    instructor 			NVARCHAR(100),                      -- �½ҦѮv
    status 				BIT DEFAULT 1,                      -- ���A�]�p�G1 = �i���W�B0 = �w�B���^
    description 		NVARCHAR(MAX),                      -- ���ʻ���
    image				NVARCHAR(MAX)					    -- ���ʹϤ�
);

-- ���ʹw����
CREATE TABLE activity_registration (
    id 					INT PRIMARY KEY IDENTITY(1,1),	    -- �۰ʻ��W
    activity_id 		INT ,			  				    -- ����id
    member_id			INT ,						    -- �|��id
    num					INT,							    -- ���W�H��(�i�j��1)
    scheduled_at		DATETIME2 ,							-- �w�����ɶ�
    status				NVARCHAR(50),							-- �w�����p
);

-- ������
CREATE TABLE activity_category (
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(50) NOT NULL UNIQUE,
  is_active BIT NOT NULL DEFAULT 1
);

DROP TABLE activity_registration
select * from activity_registration;
drop table activity_registration;

-- ���ʹw���� �� ����(�|����)
	ALTER TABLE activity_registration
	ADD CONSTRAINT FK_activity_registration_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

	ALTER TABLE activity_registration
	ADD CONSTRAINT FK_activity_registration_member
	FOREIGN KEY (member_id) REFERENCES member(id);



DROP TABLE activity
SELECT * FROM activity_category
-- ���ո��
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'�e�Y�ѳX', N'�i��', 20, 5, '2025-09-10', '2025-09-10', N'09:00-11:00', '2025-08-20', '2025-09-05', N'�x�_���H�q�Ϫ��Ϥ���', 25.033964, 121.564468, N'���Ѯv', 0, N'�A�X���̰��i������', N'/images/calligraphy.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'���֮�C�αd', N'�αd', 15, 6, '2025-09-18', '2025-09-18', N'14:00-16:00', '2025-08-25', '2025-08-30', N'�s�_���s���ѤH���ʤ���', 25.000000, 121.000000, N'���u�p�i', 1, N'�P�i�H�ڤ��ʻP���O�E������C����', N'/images/game.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'���N�ѳX', N'�i��', 30, 12, '2025-09-25', '2025-09-25', N'10:00-12:00', '2025-08-21', '2025-09-22', N'��饫���c�ϹϮ��]', 24.957123, 121.225789, N'�����L�p�j', 1, N'���[�j�e�a���@�~', N'/images/art.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'�ЧA�w�X�@��n��', N'�ҵ{', 30, 0, '2025-09-05', '2025-09-05', N'09:00-17:00', '2025-08-26', '2025-09-04', N'�x�_���H�q�ϪQ����100��', 25.033000, 121.565400, N'���j��', 1, N'�@�a�w���U�a���C', N'/images/tea.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'�Ѫk�Ͱʻ�', N'�ҵ{', 30, 0, '2025-09-30', '2025-09-30', N'09:00-17:00', '2025-08-27', '2025-09-05', N'�x�_���H�q�ϪQ����101��', 25.000000, 15.000000, N'���j��', 1, N'�i�{�n�����N�b�Ѫk�j��', N'/images/pen.jpg');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'�@�_�ӧ��R', N'�ҵ{', 30, 0, '2025-08-29', '2025-08-29', N'09:00-17:00', '2025-08-29', '2025-09-04', N'�x�_���H�q�ϪQ����100��', 25.033000, 121.565400, N'���j��', 1, N'���U�R�бо�', N'/images/dance.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'�X�۹�', N'�ҵ{', 20, 0, '2025-09-15', '2025-09-15', N'09:00-11:00', '2025-09-01', '2025-09-14', N'�x�_���H�q�ϪQ����110��', 25.047800, 121.531900, N'���Ѯv', 1, N'�оɥ��T�o��', N'/images/choir.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'���z������о�', N'�ҵ{', 30, 0, '2025-08-30', '2025-08-30', N'09:00-17:00', '2025-08-30', '2025-09-05', N'�x�_���H�q�ϪQ����100��', 25.033000, 121.565400, N'������', 1, N'��X�������Ӥ�', N'/images/phone_photo.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'���d���y', N'���y', 30, 0, '2025-08-30', '2025-08-30', N'09:00-17:00', '2025-08-30', '2025-09-05', N'�x�_���H�q�ϪQ����100��', 25.033000, 121.565400, N'���', 1, N'���鰷�d�̭��n', N'/images/healthy.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'�N�L��', N'�ҵ{', 30, 0, '2025-08-30', '2025-08-30', N'09:00-17:00', '2025-08-30', '2025-09-05', N'�x�_���H�q�ϪQ����100��', 25.033000, 121.565400, N'���p�L', 1, N'�դ@�ӷn�u�ֹ�', N'/images/music.png');
INSERT INTO activity (name, category, [limit], [current], [date], [end], [time], registration_start, registration_end, location, latitude, longitude, instructor, status, description, image) VALUES (N'������', N'�ҵ{', 30, 0, '2025-08-30', '2025-08-30', N'09:00-17:00', '2025-08-30', '2025-09-05', N'�x�_���H�q�ϪQ����100��', 25.033000, 121.565400, N'����', 1, N'�Y��Ӫ�����', N'/images/gardening.png');

-- ��l�ơ]���ƶ]�]���|���ƶ�^
INSERT INTO activity_category(name)
SELECT N'�ҵ{' WHERE NOT EXISTS (SELECT 1 FROM activity_category WHERE name=N'�ҵ{');

INSERT INTO activity_category(name)
SELECT N'�i��' WHERE NOT EXISTS (SELECT 1 FROM activity_category WHERE name=N'�i��');

INSERT INTO activity_category(name)
SELECT N'�αd' WHERE NOT EXISTS (SELECT 1 FROM activity_category WHERE name=N'�αd');

INSERT INTO activity_category(name)
SELECT N'���y' WHERE NOT EXISTS (SELECT 1 FROM activity_category WHERE name=N'���y');