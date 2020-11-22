CREATE TABLE IF NOT EXISTS `myrp_radio_channels` (
  `channel_uid` int(11) NOT NULL AUTO_INCREMENT,
  `channel_canal` int(11) NOT NULL,
  `channel_ownertype` smallint(3) NOT NULL,
  `channel_owner` int(11) NOT NULL,
  `channel_password` varchar(64) NOT NULL,

  PRIMARY KEY (`channel_uid`),
  INDEX `owners` (`channel_ownertype`, `channel_owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;