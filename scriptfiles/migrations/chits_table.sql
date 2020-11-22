
CREATE TABLE IF NOT EXISTS `myrp_chits` (
  `chit_uid` int(11) NOT NULL AUTO_INCREMENT,
  `chit_desc` varchar(256) NOT NULL,
  `chit_writer` varchar(24) NOT NULL,
  `chit_time` datetime NOT NULL,

  PRIMARY KEY (`chit_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;