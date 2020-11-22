CREATE TABLE IF NOT EXISTS `myrp_contacts` (
  `contact_uid` int(11) NOT NULL AUTO_INCREMENT,
  `contact_number` int(11) NOT NULL,
  `contact_name` varchar(24) NOT NULL,
  `contact_owner` int(11) NOT NULL,

  PRIMARY KEY (`contact_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
