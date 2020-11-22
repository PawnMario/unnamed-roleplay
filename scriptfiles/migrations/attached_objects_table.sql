CREATE TABLE IF NOT EXISTS `myrp_attached_objects` (
  `attach_uid` int(11) NOT NULL AUTO_INCREMENT,
  `attach_model` int(11) NOT NULL,
  `attach_bone` smallint(3) NOT NULL,
  `attach_x` float NOT NULL,
  `attach_y` float NOT NULL,
  `attach_z` float NOT NULL,
  `attach_rx` float NOT NULL,
  `attach_ry` float NOT NULL,
  `attach_rz` float NOT NULL,
  `attach_sx` float NOT NULL,
  `attach_sy` float NOT NULL,
  `attach_sz` float NOT NULL,
  `attach_owner` int(11) NOT NULL,
  `access_name` varchar(32) NOT NULL,
  `access_price` int(11) NOT NULL,

  PRIMARY KEY (`attach_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;