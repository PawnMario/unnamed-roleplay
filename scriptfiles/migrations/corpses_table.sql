CREATE TABLE IF NOT EXISTS `myrp_corpses` (
  `corpse_uid` int(11) NOT NULL AUTO_INCREMENT,
  `corpse_owner` int(11) NOT NULL,
  `corpse_death` smallint(2) NOT NULL,
  `corpse_weapon` int(11) NOT NULL,
  `corpse_body` int(11) NOT NULL,
  `corpse_actor` int(11) NOT NULL,
  `corpse_date` int(11) NOT NULL,

  PRIMARY KEY (`corpse_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;