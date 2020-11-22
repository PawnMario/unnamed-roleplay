CREATE TABLE IF NOT EXISTS `myrp_areas` (
  `area_uid` int(11) NOT NULL AUTO_INCREMENT,
  `area_ownertype` smallint(3) NOT NULL,
  `area_owner` int(11) NOT NULL,
  `area_vw` int(11) NOT NULL,
  `area_point1` varchar(128) NOT NULL,
  `area_point2` varchar(128) NOT NULL,
  `area_flags` int(11) NOT NULL,
  `area_audio` varchar(128) NOT NULL,

  PRIMARY KEY (`area_uid`),
  INDEX `owners` (`area_ownertype`, `area_owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;