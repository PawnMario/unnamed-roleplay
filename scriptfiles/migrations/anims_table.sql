CREATE TABLE IF NOT EXISTS `myrp_anim` (
  `anim_uid` int(11) NOT NULL AUTO_INCREMENT,
  `anim_command` varchar(12) NOT NULL,
  `anim_lib` varchar(16) NOT NULL,
  `anim_name` varchar(24) NOT NULL,
  `anim_speed` float NOT NULL,
  `anim_opt1` int(11) NOT NULL,
  `anim_opt2` int(11) NOT NULL,
  `anim_opt3` int(11) NOT NULL,
  `anim_opt4` int(11) NOT NULL,
  `anim_opt5` int(11) NOT NULL,
  `anim_action` int(11) NOT NULL DEFAULT 0,

  PRIMARY KEY (`anim_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;