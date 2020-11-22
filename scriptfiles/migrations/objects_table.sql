CREATE TABLE IF NOT EXISTS `myrp_objects` (
  `object_uid` int(11) NOT NULL AUTO_INCREMENT,
  `object_model` int(11) NOT NULL,
  `object_world` int(11) NOT NULL,
  `object_interior` int(11) NOT NULL,
  `object_posx` float NOT NULL,
  `object_posy` float NOT NULL,
  `object_posz` float NOT NULL,
  `object_rotx` float NOT NULL,
  `object_roty` float NOT NULL,
  `object_rotz` float NOT NULL,
  `object_gatex` float NOT NULL,
  `object_gatey` float NOT NULL,
  `object_gatez` float NOT NULL,
  `object_gaterotx` float NOT NULL,
  `object_gateroty` float NOT NULL,
  `object_gaterotz` float NOT NULL,
  `object_gate` tinyint(1) NOT NULL,

  PRIMARY KEY (`object_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;