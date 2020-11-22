CREATE TABLE IF NOT EXISTS `myrp_game_groups` (
  `group_uid` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(32) NOT NULL,
  `group_type` smallint(3) NOT NULL,
  `group_cash` int(11) NOT NULL,
  `group_capital` int(11) NOT NULL,
  `group_dotation` int(11) NOT NULL,
  `group_tag` varchar(4) NOT NULL DEFAULT 'NONE',
  `group_advertise` varchar(128) NOT NULL DEFAULT '',
  `group_color` varchar(12) NOT NULL DEFAULT 'FFFFFFFF',
  `group_flags` int(11) NOT NULL,
  `group_value1` int(11) NOT NULL,
  `group_value2` int(11) NOT NULL,
  `group_owner` int(11) NOT NULL,
  `group_date` int(11) NOT NULL,
  `group_last_tax` int(11) NOT NULL,

  PRIMARY KEY (`group_uid`)
  ) ENGINE = InnoDB;