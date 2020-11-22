CREATE TABLE IF NOT EXISTS `myrp_characters` ( 
    `char_uid` INT NOT NULL AUTO_INCREMENT , 
    `char_gid` INT NOT NULL , 
    `char_name` VARCHAR(24) NOT NULL , 
    `char_hours` INT(11) NOT NULL , 
    `char_minutes` SMALLINT(3) NOT NULL , 
    `char_cash` INT(11) NOT NULL , 
    `char_bankcash` INT(11) NOT NULL , 
    `char_banknumb` INT(11) NOT NULL , 
    `char_skin` INT(11) NOT NULL , 
    `char_health` FLOAT NOT NULL DEFAULT 100 , 
    `char_sex` TINYINT(1) NOT NULL DEFAULT '0' , 
    `char_birth` SMALLINT(5) NOT NULL , 
    `char_posx` FLOAT NOT NULL , 
    `char_posy` FLOAT NOT NULL , 
    `char_posz` FLOAT NOT NULL , 
    `char_posa` FLOAT NOT NULL , 
    `char_world` INT(11) NOT NULL ,
    `char_interior` INT(11) NOT NULL , 
    `block` MEDIUMINT(6) NOT NULL , 
    `char_quittime` INT(11) NOT NULL , 
    `char_arrest` INT(11) NOT NULL , 
    `char_pdp` SMALLINT(3) NOT NULL , 
    `char_strength` INT NOT NULL DEFAULT '3500' , 
    `char_depend` FLOAT(0) NOT NULL , 
    `char_bw` INT(11) NOT NULL , 
    `char_aj` INT(11) NOT NULL , 
    `char_house` INT(11) NOT NULL , 
    `char_job` SMALLINT(2) NOT NULL , 
    `char_documents` SMALLINT(4) NOT NULL , 
    `char_achievements` INT(11) NOT NULL , 
    `char_talkstyle` INT(0) NOT NULL , 
    `char_walkstyle` INT(0) NOT NULL DEFAULT '-1', 
    `char_fightstyle` SMALLINT(3) NOT NULL DEFAULT '15' , 
    `char_ooc` TINYINT(1) NOT NULL DEFAULT '1' , 
    `char_lastskin` INT(11) NOT NULL , 
    `char_lastpay` INT(11) NOT NULL , 
    `char_hint` INT(11) NOT NULL , 
    
    PRIMARY KEY (`char_uid`)
) ENGINE = InnoDB;