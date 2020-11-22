CREATE TABLE IF NOT EXISTS `myrp_orders` (
  `order_uid` int(11) NOT NULL AUTO_INCREMENT,
  `order_name` varchar(32) NOT NULL,
  `order_price` int(11) NOT NULL,
  `order_owner` int(11) NOT NULL,
  `order_extraid` int(11) NOT NULL,
  `order_cat` int(11) NOT NULL,
  `order_item_type` smallint(3) NOT NULL,
  `order_item_value1` int(11) NOT NULL,
  `order_item_value2` int(11) NOT NULL,
  `order_type` smallint(2) NOT NULL,
  `order_limit` int(11) NOT NULL,
  `order_time_limit` int(11) NOT NULL,

  PRIMARY KEY (`order_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;