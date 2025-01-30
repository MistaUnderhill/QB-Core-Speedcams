CREATE TABLE IF NOT EXISTS speedtrapLB (
  UID bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  name varchar(50) NOT NULL,
  trapid int(11) NOT NULL,
  speed float NOT NULL,
  PRIMARY KEY (UID) -- Defining UID as primary key here
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;