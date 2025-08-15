--Rehabus
CREATE TABLE dbo.rehabus (

bus_id               INT   IDENTITY(1,1)     PRIMARY KEY               NOT NULL,           --車輛流水號
car_dealership       NVARCHAR(100)                                     NOT NULL,           --車行
bus_brand            NVARCHAR(100)                                     NOT NULL,           --汽車廠牌
bus_model            NVARCHAR(100)                                     NOT NULL,           --型號
seat_capacity        INT                                               NOT NULL,           --一般座位
wheelchair_capacity  INT                                               NOT NULL,           --輪椅座位
license_plate        NVARCHAR(20)                                      NOT NULL UNIQUE,    --車牌號碼
);

-- DBCC CHECKIDENT ('dbo.rehabus', RESEED, 0);

ALTER TABLE dbo.rehabus
ADD    status        NVARCHAR(20)        NOT NULL CONSTRAINT DF_rehabus_status DEFAULT N'Active';      --派遣狀態                   

--------------------------------------試算票價------------------------------------------------------                                                            
CREATE TABLE FareZone (                                                                    -- 行政區表
zone_id             INT   IDENTITY(1,1)     PRIMARY KEY               NOT NULL,            -- 區域編號
zone_name           NVARCHAR(200)                                     NOT NULL,            -- 區域名稱
description         NVARCHAR(MAX)                                     NULL                 -- 補充說明
);


CREATE TABLE FarePrice (
price_id            INT    IDENTITY(1,1)    PRIMARY KEY               NOT NULL,            -- 編號
from_zone_id        INT                                               NOT NULL,            -- FK→FareZone(id)
to_zone_id          INT                                               NOT NULL,            -- FK→FareZone(id)
price               INT                    CHECK (price > 0)          NOT NULL,            -- 價格
actual_distance_km  DECIMAL(6,2)          NULL CHECK (actual_distance_km >= 0),            -- 回傳google API公里數"  
price_status        NVARCHAR(20)                  NOT NULL   DEFAULT N'Active',            -- 價格狀態(有時候會調漲)
   
--CONSTRAINT FK_FarePrice_FromZone  FOREIGN KEY(from_zone_id)          REFERENCES FareZone(zone_id),
--CONSTRAINT FK_FarePrice_ToZone    FOREIGN KEY(to_zone_id)            REFERENCES FareZone(zone_id),

);


--------------------------------------預約-------------------------------------------------------------- 

CREATE TABLE Reservation (
id                  BIGINT   IDENTITY(1,1)    PRIMARY KEY             NOT NULL,             -- 編號
member_id           BIGINT                                            NOT NULL,             -- FK→member(id)
bus_id              INT                                               NOT NULL,             -- FK→rehabus(bus_id)，指派車輛
start_zone_id       INT                                               NOT NULL,             -- FK→FareZone(id)，出發位置
end_zone_id         INT                                               NOT NULL,             -- FK→FareZone(id)，到達位置
created_at          DATETIME                 NOT NULL DEFAULT SYSUTCDATETIME(),             -- 訂單建立時間，直接取用目前時間
scheduled_at        DATETIME NOT NULL CHECK (scheduled_at >= SYSUTCDATETIME()),             -- 預約搭車時間
completed_at        DATETIME    CHECK (completed_at >= scheduled_at)      NULL,             -- 訂單完乘時間(由系統或後台更新) 
price               INT                   CHECK (price > 0)           NOT NULL,             -- 價格
reservation_status  NVARCHAR(20)                   NOT NULL  DEFAULT N'Active',             -- 訂單狀態
note                NVARCHAR(255)                                         NULL,             -- 其他備註

--CONSTRAINT FK_Reservation_Member      FOREIGN KEY(member_id)         REFERENCES member(id), --要連接會員的表
--CONSTRAINT FK_Reservation_Bus         FOREIGN KEY(bus_id)            REFERENCES rehabus(bus_id),
--CONSTRAINT FK_Reservation_StartZone   FOREIGN KEY(start_zone_id)     REFERENCES FareZone(zone_id),
--CONSTRAINT FK_Reservation_EndZone     FOREIGN KEY(end_zone_id)       REFERENCES FareZone(zone_id)

);


----------------------------------------評論--------------------------------------------------------------

CREATE TABLE Comment (
comment_id          BIGINT   IDENTITY(1,1)    PRIMARY KEY             NOT NULL,             -- 編號
reservation_id      BIGINT                    UNIQUE                  NOT NULL,             -- FK→Reservation(id)
member_id           BIGINT                                            NOT NULL,             -- FK→member(id)，填寫評論的會員
rating              INT               NOT NULL  CHECK (rating BETWEEN 1 AND 5),             -- 評分，1-5
comment_text        NVARCHAR(MAX)                                         NULL,             -- 評論內容
created_at          DATETIME                 NOT NULL DEFAULT SYSUTCDATETIME(),             -- 評論建立時間

--CONSTRAINT FK_Comment_ReservationId      FOREIGN KEY(reservation_id)     REFERENCES Reservation(id) ON DELETE CASCADE,
--CONSTRAINT FK_Comment_Member             FOREIGN KEY(member_id)          REFERENCES member(id)      ON DELETE CASCADE
);



CREATE TABLE Reply (
reply_id            BIGINT   IDENTITY(1,1)    PRIMARY KEY             NOT NULL,             -- 編號
comment_id          BIGINT                                            NOT NULL,             -- FK→Comment(id)
member_id           BIGINT                                                NULL,             -- FK→member(id)，填寫評論的會員
user_id             BIGINT                                                NULL,             -- FK→Employee(user_ID)
user_reply          NVARCHAR(MAX)                                         NULL,             -- 後台回覆
reply_at            DATETIME                     NULL DEFAULT SYSUTCDATETIME(),             -- 後台回覆時間

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
INSERT INTO FareZone (zone_name) VALUES ('蘆竹區1');
INSERT INTO FareZone (zone_name) VALUES ('中壢區');
INSERT INTO FareZone (zone_name) VALUES ('平鎮區');
INSERT INTO FareZone (zone_name) VALUES ('龜山區');
INSERT INTO FareZone (zone_name) VALUES ('八德區');
INSERT INTO FareZone (zone_name) VALUES ('楊梅區');
INSERT INTO FareZone (zone_name) VALUES ('大溪區');
INSERT INTO FareZone (zone_name) VALUES ('大園區');
INSERT INTO FareZone (zone_name) VALUES ('桃園區');
INSERT INTO FareZone (zone_name) VALUES ('新屋區');
INSERT INTO FareZone (zone_name) VALUES ('觀音區');
INSERT INTO FareZone (zone_name) VALUES ('龍潭區');
INSERT INTO FareZone (zone_name) VALUES ('復興區');

/*FarePrice*/
INSERT INTO FarePrice (from_zone_id, to_zone_id, price, actual_distance_km, price_status) VALUES (1, 3, 450, 14, 'Active');
INSERT INTO FarePrice (from_zone_id, to_zone_id, price, actual_distance_km, price_status) VALUES (1, 3, 900, 14, 'Closed');
INSERT INTO FarePrice (from_zone_id, to_zone_id, price, actual_distance_km, price_status) VALUES (1, 5, 360, 8.7, 'Active');
INSERT INTO FarePrice (from_zone_id, to_zone_id, price, actual_distance_km, price_status) VALUES (3, 3, 200, 5, 'Active');