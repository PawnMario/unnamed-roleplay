CREATE TABLE IF NOT EXISTS `myrp_3dlabels` (
  `label_uid` int(11) NOT NULL AUTO_INCREMENT,
  `label_desc` varchar(256) NOT NULL,
  `label_color` varchar(24) NOT NULL,
  `label_posx` float NOT NULL,
  `label_posy` float NOT NULL,
  `label_posz` float NOT NULL,
  `label_drawdist` float NOT NULL,
  `label_world` int(11) NOT NULL,
  `label_interior` int(11) NOT NULL,

  PRIMARY KEY (`label_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
