CREATE TABLE IF NOT EXISTS `myrp_newspapers` (
  `newspaper_uid` int(11) NOT NULL AUTO_INCREMENT,
  `newspaper_title` varchar(32) NOT NULL,
  `newspaper_text` text NOT NULL,

  PRIMARY KEY (`newspaper_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;