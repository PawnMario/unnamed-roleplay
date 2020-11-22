CREATE TABLE IF NOT EXISTS `myrp_materials` (
  `material_uid` int(11) NOT NULL AUTO_INCREMENT,
  `material_owner` int(11) NOT NULL,
  `material_texture` varchar(256) NOT NULL,
  `material_index` int(11) NOT NULL,

  PRIMARY KEY (`material_uid`),
  CONSTRAINT `FK_MATERIAL_OWNER` FOREIGN KEY (`material_owner`) REFERENCES `myrp_objects` (`object_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;