CREATE TABLE IF NOT EXISTS `myrp_directory` (
  `directory_uid` int(11) NOT NULL AUTO_INCREMENT,
  `directory_owner` int(11) NOT NULL,
  `directory_giver` int(11) NOT NULL,
  `directory_reason` varchar(128) NOT NULL,
  `directory_pdp` int(11) NOT NULL,
  `directory_date` datetime NOT NULL,

  PRIMARY KEY (`directory_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;