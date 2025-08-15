use seniorscare;

CREATE TABLE roomtype (
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(50) NOT NULL,
  price INT NOT NULL,
  capacity INT NOT NULL,
  description NVARCHAR(255),
  image_path NVARCHAR(255),
  is_available BIT DEFAULT 1,
  admin_note NVARCHAR(255),
  created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME2
);

CREATE TABLE room_features (
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(50) NOT NULL
);

CREATE TABLE roomtype_feature_mapping (
  roomtype_id INT NOT NULL,
  feature_id INT NOT NULL,
  PRIMARY KEY (roomtype_id, feature_id),
  FOREIGN KEY (roomtype_id) REFERENCES roomtype(id),
  FOREIGN KEY (feature_id) REFERENCES room_features(id)
);

CREATE TABLE facility (
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(50) NOT NULL,
  description NVARCHAR(255),
  image_path NVARCHAR(255),
  is_available BIT DEFAULT 1
);

CREATE TABLE favorite_room (
  member_id INT NOT NULL,
  roomtype_id INT NOT NULL,
  created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
  PRIMARY KEY (member_id, roomtype_id),
  FOREIGN KEY (roomtype_id) REFERENCES roomtype(id)
);

