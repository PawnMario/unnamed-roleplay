CREATE TABLE IF NOT EXISTS `myrp_char_groups` (
  `char_uid` int(11) NOT NULL,
  `group_belongs` int(11) NOT NULL,
  `group_perm` int(11) NOT NULL,
  `group_title` varchar(32) NOT NULL,
  `group_payment` int(11) NOT NULL,
  `group_skin` int(11) NOT NULL,
  `char_joined` int(11) NOT NULL,

  CONSTRAINT `FK_BELONG_TO` FOREIGN KEY (`group_belongs`) REFERENCES `myrp_game_groups` (`group_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;