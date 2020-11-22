CREATE TABLE IF NOT EXISTS `myrp_actors` (
  `actor_uid` int(11) NOT NULL AUTO_INCREMENT,
  `actor_name` varchar(32) NOT NULL,
  `actor_skin` int(11) NOT NULL,
  `actor_x` float NOT NULL,
  `actor_y` float NOT NULL,
  `actor_z` float NOT NULL,
  `actor_r` int(11) NOT NULL,
  `actor_type` smallint(3) NOT NULL,
  `actor_anim` int(11) NOT NULL,
  `actor_vw` int(11) NOT NULL,
  `actor_interior` int(11) NOT NULL,
  `actor_text` varchar(128) NOT NULL,

  PRIMARY KEY (`actor_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;