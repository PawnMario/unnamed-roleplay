CREATE TABLE IF NOT EXISTS `myrp_products` (
  `product_uid` int(11) NOT NULL AUTO_INCREMENT,
  `product_name` varchar(32) NOT NULL,
  `product_type` int(11) NOT NULL,
  `product_owner` int(11) NOT NULL,
  `product_price` int(11) NOT NULL,
  `product_value1` int(11) NOT NULL,
  `product_value2` int(11) NOT NULL,
  `product_count` int(11) NOT NULL,
  `product_max_price` int(11) NOT NULL,

  PRIMARY KEY (`product_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;