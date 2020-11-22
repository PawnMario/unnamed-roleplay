CREATE TABLE IF NOT EXISTS `myrp_races_route` (
  `route_uid` int(11) NOT NULL AUTO_INCREMENT,
  `route_owner` int(11) NOT NULL,
  `route_cpx` float NOT NULL,
  `route_cpy` float NOT NULL,
  `route_cpz` float NOT NULL,

  PRIMARY KEY (`route_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;