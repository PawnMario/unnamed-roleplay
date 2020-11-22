CREATE TABLE IF NOT EXISTS `myrp_group_missions` (
  `mission_uid` int(11) NOT NULL AUTO_INCREMENT,
  `mission_type` smallint(3) NOT NULL,
  `mission_owner` int(11) NOT NULL,
  `mission_extraid` int(11) NOT NULL,
  `mission_desc` varchar(256) NOT NULL,
  `mission_victim` int(11) NOT NULL,
  `mission_members` int(11) NOT NULL,
  `mission_awart` int(11) NOT NULL,
  `mission_date` int(11) NOT NULL,
  `mission_limit` int(11) NOT NULL,
  `mission_time` int(11) NOT NULL,

  PRIMARY KEY (`mission_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
