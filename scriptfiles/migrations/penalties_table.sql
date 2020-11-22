CREATE TABLE IF NOT EXISTS `myrp_penalties` (
  `penalty_uid` int(11) NOT NULL AUTO_INCREMENT,
  `penalty_owner` int(11) NOT NULL,
  `penalty_giver` int(11) NOT NULL,
  `penalty_type` smallint(3) NOT NULL,
  `penalty_extraid` int(11) NOT NULL,
  `penalty_reason` varchar(128) NOT NULL,
  `penalty_date` int(11) NOT NULL,
  `penalty_end` int(11) NOT NULL,
  `penalty_deactivate` int(11) NOT NULL,

  PRIMARY KEY (`penalty_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
