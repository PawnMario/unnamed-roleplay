CREATE TABLE IF NOT EXISTS `myrp_bans` (
  `ban_uid` int(11) NOT NULL AUTO_INCREMENT,
  `ban_owner` int(11) NOT NULL,
  `ban_ip` varchar(24) NOT NULL,
  `ban_reason` varchar(128) NOT NULL,
  `ban_filter` int(11) NOT NULL,

  PRIMARY KEY (`ban_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;