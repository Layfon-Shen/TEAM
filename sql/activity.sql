-- [�D��]
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
    image				NVARCHAR(255)					    -- ���ʹϤ�
);

select * from Activity;
drop table Activity;

--[���ʹw����]
CREATE TABLE activity_registration (
    id 					INT PRIMARY KEY IDENTITY(1,1),	    -- �۰ʻ��W
    activity_id 		INT ,			  				    -- ����id
    member_id			BIGINT ,						    -- �|��id
    num					INT,							    -- ���W�H��(�i�j��1)
    scheduled_at		DATETIME ,							-- �w�����ɶ�
    status				VARCHAR,							-- �w�����p

);
-- ���ʹw���� �� ���ʪ�B�|����
	ALTER TABLE activity_registration
	ADD CONSTRAINT FK_activity_registration_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

	ALTER TABLE activity_registration
	ADD CONSTRAINT FK_activity_registration_member
	FOREIGN KEY (member_id) REFERENCES member(id);

-- [���ʼ��Ҫ�]
CREATE TABLE activity_tag (
    id 					INT PRIMARY KEY IDENTITY(1,1),	    -- �۰ʻ��W
    name 				NVARCHAR(50),                       -- ���ҦW��

);

-- [���ʼ��ҳs����]
CREATE TABLE act_tag (
    activity_id 		INT,		  					    -- ����id
    tag_id 				INT,                	            -- ����id
);
-- ���ʼ��ҳs���� �� ���ʪ�B���Ҫ�
	ALTER TABLE act_tag
	ADD CONSTRAINT FK_act_tag_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

	ALTER TABLE act_tag
	ADD CONSTRAINT FK_act_tag_activity_tag
	FOREIGN KEY (tag_id) REFERENCES activity_tag(id);


--[���ʷӤ���]
CREATE TABLE activity_photo (
    id 					INT PRIMARY KEY IDENTITY(1,1),	    -- �۰ʻ��W
    activity_id 		INT,		  						-- ����id
    photo_url			NVARCHAR(255),						-- �Ӥ����|
    uploaded			DATETIME,							-- �Ӥ��W�Ǯɶ�
);
-- ���ʷӤ��� �� ���ʪ�
	ALTER TABLE activity_photo
	ADD CONSTRAINT FK_activity_photo_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

--[�D����s���e��-���v����]
CREATE TABLE activity_organizer (
    id              		INT PRIMARY KEY IDENTITY(1,1),	    -- �۰ʻ��W
    activity_id 			INT ,			  					-- ����id
    title        			NVARCHAR(100) NOT NULL,             -- ���м��D
    content         		NVARCHAR(MAX) NOT NULL,       	    -- ���Ф��e
    published_at    		DATETIME2     NOT NULL,   			-- �W�Ǯɶ�
);
-- ���ʥD����s�� �� ���ʪ�
	ALTER TABLE activity_organizer
	ADD CONSTRAINT FK_activity_organizer_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

--[���ʯd����]
CREATE TABLE activity_comment (
    id              		INT PRIMARY KEY IDENTITY(1,1),	    -- �۰ʻ��W
    activity_id 			INT ,			  					-- ����id
    member_id				BIGINT ,							-- �|��id
    comment					NVARCHAR(MAX),						-- �d�����e
    rating					TINYINT NULL,						-- �P������
    created_at				DATETIME2,							-- �d���ɶ��A�w�]�t�ήɶ�
);
-- ���ʯd���� �� ���ʪ�B�|����
	ALTER TABLE activity_comment
	ADD CONSTRAINT FK_activity_comment_activity
	FOREIGN KEY (activity_id) REFERENCES activity(id);

	ALTER TABLE activity_comment
	ADD CONSTRAINT FK_activity_comment_member
	FOREIGN KEY (member_id) REFERENCES member(id);
