CREATE TABLE IF NOT EXISTS `myrp_game_skins` (
  `skin_id` int(11) NOT NULL,
  `skin_name` varchar(32) NOT NULL,
  `skin_price` int(11) NOT NULL,
  `skin_group` int(11) NOT NULL,
  `skin_extraid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;