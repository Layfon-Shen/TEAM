--Rehabus
CREATE TABLE dbo.rehabus (

bus_id               INT   IDENTITY(1,1)     PRIMARY KEY               NOT NULL,           --�����y����
car_dealership       NVARCHAR(100)                                     NOT NULL,           --����
bus_brand            NVARCHAR(100)                                     NOT NULL,           --�T���t�P
bus_model            NVARCHAR(100)                                     NOT NULL,           --����
seat_capacity        INT                                               NOT NULL,           --�@��y��
wheelchair_capacity  INT                                               NOT NULL,           --���Ȯy��
license_plate        NVARCHAR(20)                                      NOT NULL UNIQUE,    --���P���X
);

-- DBCC CHECKIDENT ('dbo.rehabus', RESEED, 0);

ALTER TABLE dbo.rehabus
ADD    status        NVARCHAR(20)        NOT NULL CONSTRAINT DF_rehabus_status DEFAULT N'Active';      --�������A                   

--------------------------------------�պⲼ��------------------------------------------------------                                                            
CREATE TABLE FareZone (                                                                    -- ��F�Ϫ�
zone_id             INT   IDENTITY(1,1)     PRIMARY KEY               NOT NULL,            -- �ϰ�s��
zone_name           NVARCHAR(200)                                     NOT NULL,            -- �ϰ�W��
description         NVARCHAR(MAX)                                     NULL                 -- �ɥR����
);


CREATE TABLE FarePrice (
price_id            INT    IDENTITY(1,1)    PRIMARY KEY               NOT NULL,            -- �s��
from_zone_id        INT                                               NOT NULL,            -- FK��FareZone(id)
to_zone_id          INT                                               NOT NULL,            -- FK��FareZone(id)
price               INT                    CHECK (price > 0)          NOT NULL,            -- ����
actual_distance_km  DECIMAL(6,2)          NULL CHECK (actual_distance_km >= 0),            -- �^��google API������"  
price_status        NVARCHAR(20)                  NOT NULL   DEFAULT N'Active',            -- ���檬�A(���ɭԷ|�պ�)
   
--CONSTRAINT FK_FarePrice_FromZone  FOREIGN KEY(from_zone_id)          REFERENCES FareZone(zone_id),
--CONSTRAINT FK_FarePrice_ToZone    FOREIGN KEY(to_zone_id)            REFERENCES FareZone(zone_id),

);


--------------------------------------�w��-------------------------------------------------------------- 

CREATE TABLE Reservation (
id                  BIGINT   IDENTITY(1,1)    PRIMARY KEY             NOT NULL,             -- �s��
member_id           BIGINT                                            NOT NULL,             -- FK��member(id)
bus_id              INT                                               NOT NULL,             -- FK��rehabus(bus_id)�A��������
start_zone_id       INT                                               NOT NULL,             -- FK��FareZone(id)�A�X�o��m
end_zone_id         INT                                               NOT NULL,             -- FK��FareZone(id)�A��F��m
created_at          DATETIME                 NOT NULL DEFAULT SYSUTCDATETIME(),             -- �q��إ߮ɶ��A�������Υثe�ɶ�
scheduled_at        DATETIME NOT NULL CHECK (scheduled_at >= SYSUTCDATETIME()),             -- �w���f���ɶ�
completed_at        DATETIME    CHECK (completed_at >= scheduled_at)      NULL,             -- �q�槹���ɶ�(�Ѩt�ΩΫ�x��s) 
price               INT                   CHECK (price > 0)           NOT NULL,             -- ����
reservation_status  NVARCHAR(20)                   NOT NULL  DEFAULT N'Active',             -- �q�檬�A
note                NVARCHAR(255)                                         NULL,             -- ��L�Ƶ�

--CONSTRAINT FK_Reservation_Member      FOREIGN KEY(member_id)         REFERENCES member(id), --�n�s���|������
--CONSTRAINT FK_Reservation_Bus         FOREIGN KEY(bus_id)            REFERENCES rehabus(bus_id),
--CONSTRAINT FK_Reservation_StartZone   FOREIGN KEY(start_zone_id)     REFERENCES FareZone(zone_id),
--CONSTRAINT FK_Reservation_EndZone     FOREIGN KEY(end_zone_id)       REFERENCES FareZone(zone_id)

);


----------------------------------------����--------------------------------------------------------------

CREATE TABLE Comment (
comment_id          BIGINT   IDENTITY(1,1)    PRIMARY KEY             NOT NULL,             -- �s��
reservation_id      BIGINT                    UNIQUE                  NOT NULL,             -- FK��Reservation(id)
member_id           BIGINT                                            NOT NULL,             -- FK��member(id)�A��g���ת��|��
rating              INT               NOT NULL  CHECK (rating BETWEEN 1 AND 5),             -- �����A1-5
comment_text        NVARCHAR(MAX)                                         NULL,             -- ���פ��e
created_at          DATETIME                 NOT NULL DEFAULT SYSUTCDATETIME(),             -- ���׫إ߮ɶ�

--CONSTRAINT FK_Comment_ReservationId      FOREIGN KEY(reservation_id)     REFERENCES Reservation(id) ON DELETE CASCADE,
--CONSTRAINT FK_Comment_Member             FOREIGN KEY(member_id)          REFERENCES member(id)      ON DELETE CASCADE
);



CREATE TABLE Reply (
reply_id            BIGINT   IDENTITY(1,1)    PRIMARY KEY             NOT NULL,             -- �s��
comment_id          BIGINT                                            NOT NULL,             -- FK��Comment(id)
member_id           BIGINT                                                NULL,             -- FK��member(id)�A��g���ת��|��
user_id             BIGINT                                                NULL,             -- FK��Employee(user_ID)
user_reply          NVARCHAR(MAX)                                         NULL,             -- ��x�^��
reply_at            DATETIME                     NULL DEFAULT SYSUTCDATETIME(),             -- ��x�^�Юɶ�

--CONSTRAINT FK_Reply_CommentId           FOREIGN KEY(comment_id)         REFERENCES Comment(id) ON DELETE CASCADE,
--CONSTRAINT FK_Reply_Member              FOREIGN KEY(member_id)          REFERENCES member(id)  ON DELETE CASCADE, 
--CONSTRAINT FK_Reply_Employee            FOREIGN KEY(user_id)            REFERENCES employee(user_ID)  ON DELETE CASCADE, 

--CONSTRAINT CK_Reply_ExactlyOneUser CHECK((member_id IS NOT NULL AND user_id IS NULL) OR ( member_id IS NULL AND user_id IS NOT NULL))
);

/*Rehabus*/
INSERT INTO rehabus (car_dealership, bus_brand, bus_model, seat_capacity, wheelchair_capacity, license_plate)
VALUES
  ('Taipei Motors',  'Toyota',    'Coaster', 20, 2, 'AB-1234'),
  ('Kaohsiung Auto', 'Ford',      'Transit', 18, 3, 'AC-2345'),
  ('Taichung Wheels','Mercedes',  'Sprinter',15, 4, 'AD-3456'),
  ('Tainan Vehicle', 'Nissan',    'Civilian',12, 1, 'AE-4567'),
  ('Hualien Mobility','Volkswagen','Crafter',16, 2, 'AF-5678');

   /*FareZone*/
INSERT INTO FareZone (zone_name) VALUES ('Ī�˰�1');
INSERT INTO FareZone (zone_name) VALUES ('���c��');
INSERT INTO FareZone (zone_name) VALUES ('�����');
INSERT INTO FareZone (zone_name) VALUES ('�t�s��');
INSERT INTO FareZone (zone_name) VALUES ('�K�w��');
INSERT INTO FareZone (zone_name) VALUES ('������');
INSERT INTO FareZone (zone_name) VALUES ('�j�˰�');
INSERT INTO FareZone (zone_name) VALUES ('�j���');
INSERT INTO FareZone (zone_name) VALUES ('����');
INSERT INTO FareZone (zone_name) VALUES ('�s�ΰ�');
INSERT INTO FareZone (zone_name) VALUES ('�[����');
INSERT INTO FareZone (zone_name) VALUES ('�s���');
INSERT INTO FareZone (zone_name) VALUES ('�_����');

/*FarePrice*/
INSERT INTO FarePrice (from_zone_id, to_zone_id, price, actual_distance_km, price_status) VALUES (1, 3, 450, 14, 'Active');
INSERT INTO FarePrice (from_zone_id, to_zone_id, price, actual_distance_km, price_status) VALUES (1, 3, 900, 14, 'Closed');
INSERT INTO FarePrice (from_zone_id, to_zone_id, price, actual_distance_km, price_status) VALUES (1, 5, 360, 8.7, 'Active');
INSERT INTO FarePrice (from_zone_id, to_zone_id, price, actual_distance_km, price_status) VALUES (3, 3, 200, 5, 'Active');