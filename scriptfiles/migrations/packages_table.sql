CREATE TABLE `myrp_packages` (
  `package_uid` int(11) NOT NULL AUTO_INCREMENT,
  `package_dooruid` int(11) NOT NULL,
  `package_item_name` varchar(32) NOT NULL,
  `package_item_type` smallint(3) NOT NULL,
  `package_item_value1` int(11) NOT NULL,
  `package_item_value2` int(11) NOT NULL,
  `package_item_count` int(11) NOT NULL,
  `package_type` smallint(2) NOT NULL,

  PRIMARY KEY (`package_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;