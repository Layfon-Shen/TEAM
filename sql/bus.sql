--Rehabus
CREATE TABLE rehabus (

bus_id               INT   IDENTITY(1,1)     PRIMARY KEY               NOT NULL,           --�����y����
car_dealership       NVARCHAR(100)                                     NOT NULL,           --����
bus_brand            NVARCHAR(100)                                     NOT NULL,           --�T���t�P
bus_model            NVARCHAR(100)                                     NOT NULL,           --����
seat_capacity        INT                                               NOT NULL,           --�@��y��
wheelchair_capacity  INT                                               NOT NULL,           --���Ȯy��
license_plate        NVARCHAR(20)               UNIQUE                 NOT NULL,           --���P���X
);

--DBCC CHECKIDENT ('dbo.rehabus', RESEED, 0);

ALTER TABLE rehabus
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
   
);


--------------------------------------�w��-------------------------------------------------------------- 

CREATE TABLE BusReservation (
id                  INT   IDENTITY(1,1)    PRIMARY KEY                NOT NULL,             -- �s��
member_id           INT                                               NOT NULL,             -- FK��member(id)
bus_id              INT                                               NOT NULL,             -- FK��rehabus(bus_id)�A��������
start_zone_id       INT                                                   NULL,             -- FK��FareZone(id)�A�X�o��m
end_zone_id         INT                                                   NULL,             -- FK��FareZone(id)�A��F��m
created_at          DATETIME                                          NOT NULL,             -- �q��إ߮ɶ��A�������Υثe�ɶ�
scheduled_at        DATETIME                                          NOT NULL,             -- �w���f���ɶ�
completed_at        DATETIME                                              NULL,             -- �q�槹���ɶ�(�Ѩt�ΩΫ�x��s) 
price               INT                   CHECK (price > 0)           NOT NULL,             -- ����
reservation_status  NVARCHAR(20)                   NOT NULL  DEFAULT N'Active',             -- �q�檬�A
note                NVARCHAR(255)                                         NULL              -- ��L�Ƶ�
);

ALTER TABLE BusReservation
ADD    start_address       NVARCHAR(MAX)                               NOT NULL,            -- �_�I�a�}
       end_address         NVARCHAR(MAX)                               NOT NULL,            -- ���I�a�}  
       start_lat           DECIMAL(9,6)                                    NULL,            -- �_�I�n��
       start_lng           DECIMAL(9,6)                                    NULL,            -- �_�I�g�� 
       end_lat             DECIMAL(9,6)                                    NULL,            -- ���I�n��
       end_lng             DECIMAL(9,6)                                    NULL,            -- ���I�g�� 
       distance_meters     INT                                             NULL;            -- �Z��(����)


/*Rehabus*/
INSERT INTO rehabus (car_dealership, bus_brand, bus_model, seat_capacity, wheelchair_capacity, license_plate) VALUES
  -- �j���]�y��14�A����6�^
  ('�����ȹB',               'Isuzu',          'Journey K',           12, 6, 'WAC-0172'),
  ('���ȹB',               'Isuzu',          'Gala Mio',            12, 5, 'WCA-4033'),
  ('���c�ȹB',               'Scania',         'Touring',             13, 6, 'WCB-8891'),
  ('�֭ۥ�q�ѥ��������q',   'Hino',           'Liesse II',           10, 5, 'WAD-0953'),
  ('�ͳq�ѥ��������q',       'Volvo',          '9700',                14, 6, 'WBA-2045'),

  -- �����]�y��8�A����5�^
  ('�ͳq�ѥ��������q',       'Ford',           'Transita',            4, 4, 'WDC-5124'),
  ('�֭ۥ�q�ѥ��������q',   'Volkswagen',     'Crafter',             4, 3, 'WDA-3308'),
  ('�֭ۥ�q�ѥ��������q',   'Nissan',         'Civilian',            6, 5, 'WBD-6612'),
  ('�@���p�Ȩ���������q', 'Mitsubishi',     'Fuso Rosa',           8, 5, 'WCC-7459'),
  ('�@���p�Ȩ���������q', 'Toyota',         'Coaster',             8, 5, 'WEJ-4421'),

  -- �p���]�y��2�A����1�^
  ('�@���p�Ȩ���������q', 'Ford',           'Transit',             2, 1, 'WEF-0109'),
  ('�@���p�Ȩ���������q', 'Ford',           'Kombi-Limited',       2, 1, 'WER-9051'),
  ('�ͳq�ѥ��������q',       'Volkswagen',     'T6.1 Caravelle',      1, 1, 'WEM-7834'),
  ('�ͳq�ѥ��������q',       'Hyundai',        'STARIA',              2, 1, 'WEZ-3017'),
  ('�֭ۥ�q�ѥ��������q',   'Ford',           'Kombi-Trend',         2, 1, 'WEP-2256');


SELECT * FROM rehabus
SELECT * FROM BusReservation
