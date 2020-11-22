CREATE TABLE IF NOT EXISTS `myrp_order_category` (
  `category_uid` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(32) NOT NULL,

  PRIMARY KEY (`category_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
