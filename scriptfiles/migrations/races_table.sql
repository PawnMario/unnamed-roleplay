
CREATE TABLE IF NOT EXISTS `myrp_races` (
  `race_uid` int(11) NOT NULL AUTO_INCREMENT,
  `race_title` varchar(64) NOT NULL,
  `race_owner` int(11) NOT NULL,

  PRIMARY KEY (`race_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;