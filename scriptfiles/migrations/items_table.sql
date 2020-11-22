CREATE TABLE IF NOT EXISTS `myrp_items` (
  `item_uid` int(11) NOT NULL AUTO_INCREMENT,
  `item_name` varchar(32) NOT NULL,
  `item_value1` int(11) NOT NULL,
  `item_value2` int(11) NOT NULL,
  `item_ownertype` smallint(3) NOT NULL,
  `item_owner` int(11) NOT NULL,
  `item_vehuid` int(11) NOT NULL,
  `item_posx` float NOT NULL,
  `item_posy` float NOT NULL,
  `item_posz` float NOT NULL,
  `item_world` int(11) NOT NULL,
  `item_interior` int(11) NOT NULL,
  `item_type` int(11) NOT NULL,
  `item_favorite` tinyint(1) NOT NULL DEFAULT 0,
  `item_group` int(11) NOT NULL,
  `item_used` tinyint(1) NOT NULL DEFAULT 0,

  PRIMARY KEY (`item_uid`),
  INDEX `owners` (`item_owner`, `item_ownertype`),
  CONSTRAINT `FK_VEHICLE_TUNING` FOREIGN KEY (`item_vehuid`) REFERENCES `myrp_vehicles` (`vehicle_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
