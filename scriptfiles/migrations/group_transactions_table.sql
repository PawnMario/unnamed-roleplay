CREATE TABLE `myrp_group_transactions` (
  `transaction_uid` int(11) NOT NULL AUTO_INCREMENT,
  `transaction_owner` int(11) NOT NULL,
  `transaction_type` smallint(3) NOT NULL,
  `transaction_group` int(11) NOT NULL,
  `transaction_price` int(11) NOT NULL,
  `transaction_value` int(11) NOT NULL,
  `transaction_extraid` int(11) NOT NULL,
  `transaction_date` int(11) NOT NULL,

  PRIMARY KEY (`transaction_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;