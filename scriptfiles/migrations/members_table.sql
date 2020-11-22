CREATE TABLE IF NOT EXISTS `core_members` (
  `member_id` bigint(200) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `member_group_id` smallint(5) NOT NULL DEFAULT 0,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `joined` int(10) NOT NULL DEFAULT 0,
  `ip_address` varchar(46) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `skin` smallint(5) DEFAULT NULL,
  `warn_level` int(10) DEFAULT NULL,
  `warn_lastwarn` int(10) NOT NULL DEFAULT 0,
  `language` mediumint(7) DEFAULT NULL,
  `restrict_post` int(10) NOT NULL DEFAULT 0,
  `bday_day` int(10) DEFAULT NULL,
  `bday_month` int(10) DEFAULT NULL,
  `bday_year` int(10) DEFAULT NULL,
  `msg_count_new` int(10) NOT NULL DEFAULT 0,
  `msg_count_total` int(10) NOT NULL DEFAULT 0,
  `msg_count_reset` int(10) NOT NULL DEFAULT 0,
  `msg_show_notification` int(10) NOT NULL DEFAULT 0,
  `last_visit` int(10) DEFAULT 0,
  `last_activity` int(10) DEFAULT 0,
  `mod_posts` int(10) NOT NULL DEFAULT 0,
  `auto_track` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `temp_ban` int(10) DEFAULT 0,
  `mgroup_others` varchar(245) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `members_seo_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `members_cache` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `failed_logins` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `failed_login_count` smallint(5) NOT NULL DEFAULT 0,
  `members_profile_views` int(10) NOT NULL DEFAULT 0,
  `members_pass_hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `members_pass_salt` varchar(22) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `members_bitoptions` int(10) NOT NULL DEFAULT 0,
  `members_day_posts` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0,0',
  `notification_cnt` mediumint(7) NOT NULL DEFAULT 0,
  `pp_last_visitors` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pp_main_photo` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pp_main_width` int(10) DEFAULT NULL,
  `pp_main_height` int(10) DEFAULT NULL,
  `pp_thumb_photo` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pp_thumb_width` int(10) DEFAULT NULL,
  `pp_thumb_height` int(10) DEFAULT NULL,
  `pp_setting_count_comments` int(10) DEFAULT NULL,
  `pp_reputation_points` int(10) DEFAULT NULL,
  `pp_photo_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signature` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pconversation_filters` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pp_customization` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timezone` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pp_cover_photo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `profilesync` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profilesync_lastsync` int(10) NOT NULL DEFAULT 0 COMMENT 'Indicates the last time any profile sync service was ran',
  `allow_admin_mails` bit(1) DEFAULT NULL,
  `members_bitoptions2` int(10) NOT NULL DEFAULT 0,
  `create_menu` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Cached contents of the "Create" drop down menu.',
  `members_disable_pm` tinyint(3) NOT NULL DEFAULT 0 COMMENT '0 - not disabled, 1 - disabled, member can re-enable, 2 - disabled',
  `marked_site_read` int(10) DEFAULT 0,
  `pp_cover_offset` int(10) NOT NULL DEFAULT 0,
  `acp_language` mediumint(7) DEFAULT NULL,
  `member_title` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `member_posts` mediumint(7) NOT NULL DEFAULT 0,
  `member_last_post` int(10) DEFAULT NULL,
  `member_streams` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo_last_update` int(10) DEFAULT NULL,
  `mfa_details` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `failed_mfa_attempts` smallint(5) DEFAULT 0 COMMENT 'Number of times tried and failed MFA',
  `permission_array` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'A cache of the clubs and social groups that the member is in',
  `completed` bit(1) NOT NULL COMMENT 'Whether the account is completed or not',
PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;