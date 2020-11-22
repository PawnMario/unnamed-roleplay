CREATE TABLE IF NOT EXISTS `myrp_game_sessions` (
  `session_uid` int(11) NOT NULL AUTO_INCREMENT,
  `session_owner` int(11) NOT NULL,
  `session_type` smallint(3) NOT NULL,
  `session_start` int(11) NOT NULL,
  `session_end` int(11) NOT NULL,
  `session_ip` varchar(24) NOT NULL,

  PRIMARY KEY (`session_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;