new DeletePenalty = 0;

stock LoadGlobalPenalties(playerid)
{
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT penalty_type FROM ipb_penalties WHERE penalty_user_global_id = %d AND (penalty_expire > %d OR penalty_expire = 0)", pGlobal[playerid][glo_id], gettime()));
	cache_get_row_count(rows);

	for(new row = 0; row != rows; row++)
	{
		new penalty_type;
		cache_get_value_index_int(row, 0, penalty_type);

		switch(penalty_type)
		{
			case PUNISH_BAN: 	   pGlobal[playerid][glo_block] += BLOCK_BAN;
			case PUNISH_BLOCK_VEH: pGlobal[playerid][glo_block] += BLOCK_VEH;
			case PUNISH_BLOCK_RUN: pGlobal[playerid][glo_block] += BLOCK_RUN;
			case PUNISH_BLOCK_DMG: pGlobal[playerid][glo_block] += BLOCK_DMG;
			case PUNISH_BLOCK_OOC: pGlobal[playerid][glo_block] += BLOCK_OOC;
		}
	}

	if(pGlobal[playerid][glo_block] & BLOCK_BAN)
	{
		SendClientMessage(playerid, COLOR_LIGHTER_RED, "Twoje konto jest zbanowane. SzczegÛ≥y sprawdzisz w kartotece kar na swoim profilu forum.");
		Kick(playerid);
		return 1;
	}

	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	return 1;
}

stock AddPlayerPunishLog(playerid, giveplayer_id, punish_type, reason[], extraid = 0, time = 0)
{
	if(!pInfo[playerid][player_logged]) return 1;
    mysql_escape_string(reason, reason, 128, mySQLconnection);
	if(giveplayer_id == -1)
 	{
 	   	mysql_tquery(mySQLconnection, sprintf("INSERT INTO `ipb_penalties` (`penalty_user_char_id`, `penalty_user_global_id`, `penalty_admin_global_id`, `penalty_expire`, `penalty_type`, `penalty_dateline`, `penalty_reason`) VALUES ('%d', '%d', '-1', '0', '%d', %d, '%s')", pInfo[playerid][player_id], pGlobal[playerid][glo_id], punish_type, gettime(), reason));
	}
	else
	{
		if(extraid == 0)
		{
 			mysql_tquery(mySQLconnection, sprintf("INSERT INTO `ipb_penalties` (`penalty_user_char_id`, `penalty_user_global_id`, `penalty_admin_global_id`, `penalty_expire`, `penalty_type`, `penalty_dateline`, `penalty_reason`) VALUES ('%d', '%d', '%d', '%d', '%d', %d, '%s')", pInfo[playerid][player_id], pGlobal[playerid][glo_id], pGlobal[giveplayer_id][glo_id], time, punish_type, gettime(), reason));
 		}
 		else
 		{
 			mysql_tquery(mySQLconnection, sprintf("INSERT INTO `ipb_penalties` (`penalty_user_char_id`, `penalty_user_global_id`, `penalty_admin_global_id`, `penalty_expire`, `penalty_type`, `penalty_dateline`, `penalty_reason`, `penalty_extraid`) VALUES ('%d', '%d', '%d', '0', '%d', %d, '%s', '%d')", pInfo[playerid][player_id], pGlobal[playerid][glo_id], pGlobal[giveplayer_id][glo_id], punish_type, gettime(), reason, extraid));
 		}
	}
	return 1;
}

stock KickAc(playerid, giveplayer_id, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == -1 && pGlobal[playerid][glo_perm]) return 1;
	new string[200], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);
	
	format(string, sizeof(string), "~r~Kick~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", giver_name, pInfo[playerid][player_name], reason);
	
	SendFormattedClientMessage(playerid, COLOR_DARK_RED, "> Otrzymujesz karÍ (Kick) od %s. PowÛd %s.", giver_name, reason);

	TextDrawSetString(TextPenalty, string);

	TextDrawShowForAll(TextPenalty);

	Kick(playerid);
	AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_KICK, reason);
	DeletePenalty = 8;
	return 1;
}

stock CarUnspawn(playerid, vehicleid, giveplayer_id, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(vehicleid == INVALID_VEHICLE_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[200], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);
	
	format(string, sizeof(string), "~r~Vehicle UnSpawn~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", giver_name, pInfo[playerid][player_name], reason);
	
	TextDrawSetString(TextPenalty, string);

	new uid = Vehicle[vehicleid][vehicle_uid];
	ClearAnimations(playerid);
	DeleteVehicle(vehicleid, false);
	LoadVehicle(sprintf("WHERE `vehicle_uid` = %d", uid), true);
	
	AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_WARN, reason);
	DeletePenalty = 8;
	return 1;
}

stock Warn(playerid, giveplayer_id, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[200], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);
	
	format(string, sizeof(string), "~r~Warn~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", giver_name, pInfo[playerid][player_name], reason);

	SendFormattedClientMessage(playerid, COLOR_DARK_RED, "> Otrzymujesz karÍ (Warn) od %s. PowÛd %s.", giver_name, reason);
	
	TextDrawSetString(TextPenalty, string);

	TextDrawShowForAll(TextPenalty);

	AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_WARN, reason);
	DeletePenalty = 8;
	return 1;
}

stock Block(playerid, giveplayer_id, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[220], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);
	
	format(string, sizeof(string), "~r~Blokada Postaci~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", giver_name, pInfo[playerid][player_name], reason);
	
	SendFormattedClientMessage(playerid, COLOR_DARK_RED, "> Otrzymujesz karÍ (Blokada postaci) od %s. PowÛd %s.", giver_name, reason);

	TextDrawSetString(TextPenalty, string);

	TextDrawShowForAll(TextPenalty);
	
	mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_active` = 1 WHERE `char_uid` = %d", pInfo[playerid][player_id]));
	DeletePenalty = 8;
	AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_BLOCK, reason);
	Kick(playerid);
	return 1;
}

stock BlockVeh(playerid, giveplayer_id, time, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[220], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);

	if(time == 0)
	{
		if(pGlobal[playerid][glo_block] & BLOCK_VEH)
		{
			mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_penalties` SET `penalty_expire` = %d, penalty_deactivated_by = %d WHERE `penalty_user_global_id` = %d AND `penalty_type` = %d AND `penalty_expire` < %d", pGlobal[playerid][glo_id], gettime(), pGlobal[giveplayer_id][glo_id], PUNISH_BLOCK_VEH, gettime()));
			SendClientMessage(giveplayer_id, COLOR_GOLD, sprintf("Blokada prowadzenia pojazdÛw gracza %s zosta≥a pomyúnie zdjÍta.", pInfo[playerid][player_name]));
			SendClientMessage(playerid, COLOR_GOLD, sprintf("Administrator %s zdjπ≥ twojπ blokade prowadzenia pojazdÛw.", pInfo[giveplayer_id][player_name]));
			pGlobal[playerid][glo_block] -= BLOCK_VEH;
		}
		return 1;
	}
	
	format(string, sizeof(string), "~r~Blokada prowadzenia pojazdow (%d dni)~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", time,giver_name, pInfo[playerid][player_name], reason);

	SendFormattedClientMessage(playerid, COLOR_DARK_RED, "> Otrzymujesz karÍ (Blokada pojazdÛw) od %s. PowÛd %s.", giver_name, reason);

	TextDrawSetString(TextPenalty, string);

	TextDrawShowForAll(TextPenalty);

	DeletePenalty = 8;
	AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_BLOCK_VEH, reason, 0, gettime() + time*86400);
	if(!(pGlobal[playerid][glo_block] & BLOCK_VEH)) pGlobal[playerid][glo_block] += BLOCK_VEH;
	return 1;
}

stock BlockRun(playerid, giveplayer_id, time, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[220], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);

	if(time == 0)
	{
		if(pGlobal[playerid][glo_block] & BLOCK_RUN)
		{
			mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_penalties` SET `penalty_expire` = %d, penalty_deactivated_by = %d WHERE `penalty_user_global_id` = %d AND `penalty_type` = %d AND `penalty_expire` < %d", pGlobal[playerid][glo_id], gettime(), pGlobal[giveplayer_id][glo_id], PUNISH_BLOCK_RUN, gettime()));
			SendClientMessage(giveplayer_id, COLOR_GOLD, sprintf("Blokada biegania gracza %s zosta≥a pomyúlnie zdjÍta.", pInfo[playerid][player_name]));
			SendClientMessage(playerid, COLOR_GOLD, sprintf("Administrator %s zdjπ≥ twojπ blokade biegania.", pInfo[giveplayer_id][player_name]));
			pGlobal[playerid][glo_block] -= BLOCK_RUN;
		}
		return 1;
	}
	
	format(string, sizeof(string), "~r~Blokada biegania (%d dni)~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s",time, giver_name, pInfo[playerid][player_name], reason);
	
	SendFormattedClientMessage(playerid, COLOR_DARK_RED, "> Otrzymujesz karÍ (Blokada biegania) od %s. PowÛd %s.", giver_name, reason);

	TextDrawSetString(TextPenalty, string);

	TextDrawShowForAll(TextPenalty);

	DeletePenalty = 8;
	AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_BLOCK_RUN, reason, 0, gettime() + time*86400);
	if(!(pGlobal[playerid][glo_block] & BLOCK_RUN)) pGlobal[playerid][glo_block] += BLOCK_RUN;
	return 1;
}

stock BlockDmg(playerid, giveplayer_id, time, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[220], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);

	if(time == 0)
	{
		if(pGlobal[playerid][glo_block] & BLOCK_DMG)
		{
			mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_penalties` SET `penalty_expire` = %d, penalty_deactivated_by = %d WHERE `penalty_user_global_id` = %d AND `penalty_type` = %d AND `penalty_expire` < %d", pGlobal[playerid][glo_id], gettime(), pGlobal[giveplayer_id][glo_id], PUNISH_BLOCK_DMG, gettime()));
			SendClientMessage(giveplayer_id, COLOR_GOLD, sprintf("Blokada zadawania obraøeÒ %s zosta≥a pomyúlnie zdjÍta.", pInfo[playerid][player_name]));
			SendClientMessage(playerid, COLOR_GOLD, sprintf("Administrator %s zdjπ≥ twojπ blokade zadawania obraøeÒ.", pInfo[giveplayer_id][player_name]));
			pGlobal[playerid][glo_block] -= BLOCK_DMG;
		}
		return 1;
	}
	
	format(string, sizeof(string), "~r~Blokada zabierania dmg (%d dni)~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", time,giver_name, pInfo[playerid][player_name], reason);
	
	SendFormattedClientMessage(playerid, COLOR_DARK_RED, "> Otrzymujesz karÍ (Blokada obraøeÒ) od %s. PowÛd %s.", giver_name, reason);

	TextDrawSetString(TextPenalty, string);

	TextDrawShowForAll(TextPenalty);

	DeletePenalty = 8;
	AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_BLOCK_DMG, reason, 0, gettime() + time*86400);
	if(!(pGlobal[playerid][glo_block] & BLOCK_DMG)) pGlobal[playerid][glo_block] += BLOCK_DMG;
	return 1;
}

stock BlockOoc(playerid, giveplayer_id, time, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[220], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);

	if(time == 0)
	{
		if(pGlobal[playerid][glo_block] & BLOCK_OOC)
		{
			mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_penalties` SET `penalty_expire` = %d, penalty_deactivated_by = %d WHERE `penalty_user_global_id` = %d AND `penalty_type` = %d AND `penalty_expire` < %d", pGlobal[playerid][glo_id], gettime(), pGlobal[giveplayer_id][glo_id], PUNISH_BLOCK_OOC, gettime()));
			SendClientMessage(giveplayer_id, COLOR_GOLD, sprintf("Blokada czatu OOC %s zosta≥a pomyúlnie zdjÍta.", pInfo[playerid][player_name]));
			SendClientMessage(playerid, COLOR_GOLD, sprintf("Administrator %s zdjπ≥ twojπ blokade czatu OOC.", pInfo[giveplayer_id][player_name]));
			pGlobal[playerid][glo_block] -= BLOCK_OOC;
		}
		return 1;
	}
	
	format(string, sizeof(string), "~r~Blokada czatu OOC (%d dni)~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", time,giver_name, pInfo[playerid][player_name], reason);
	
	TextDrawSetString(TextPenalty, string);

	SendFormattedClientMessage(playerid, COLOR_DARK_RED, "> Otrzymujesz karÍ (Blokada OOC) od %s. PowÛd %s.", giver_name, reason);

	TextDrawShowForAll(TextPenalty);

	DeletePenalty = 8;
	AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_BLOCK_OOC, reason, 0, gettime() + time*86400);
	if(!(pGlobal[playerid][glo_block] & BLOCK_OOC)) pGlobal[playerid][glo_block] += BLOCK_OOC;
	return 1;
}

stock Score(playerid, giveplayer_id, score, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[220], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);

	if(score < 0)
	{
		format(string, sizeof(string), "~r~~h~Game Score (%d)~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", score,giver_name, pInfo[playerid][player_name], reason);
	}
	else
	{
		format(string, sizeof(string), "~b~~h~~h~Game Score (%d)~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", score,giver_name, pInfo[playerid][player_name], reason);
	}
	
	TextDrawSetString(TextPenalty, string);

	TextDrawShowForAll(TextPenalty);

	pGlobal[playerid][glo_score] += score;
	SetPlayerScore(playerid, pGlobal[playerid][glo_score]);

	AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_GAME_SCORE, reason, score);
	
	mysql_tquery(mySQLconnection, sprintf("UPDATE `core_members` SET `member_game_points` = %d WHERE `member_id` = %d", pGlobal[playerid][glo_score], pGlobal[playerid][glo_id]));
	DeletePenalty = 8;
	return 1;
}

stock CharacterKill(playerid, giveplayer_id, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[220], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);
	
	format(string, sizeof(string), "~r~Blokada Postaci~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", giver_name, pInfo[playerid][player_name], reason);
	
	SendFormattedClientMessage(playerid, COLOR_DARK_RED, "> Otrzymujesz karÍ (Character kill) od %s. PowÛd %s.", giver_name, reason);

	TextDrawSetString(TextPenalty, string);

	TextDrawShowForAll(TextPenalty);

	mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_active` = 1 WHERE `char_uid` = %d", pInfo[playerid][player_id]));
	DeletePenalty = 8;

	for(new item;item<MAX_PLAYER_ITEMS;item++)
	{
		if(PlayerItem[playerid][item][player_item_uid] > 0 && !PlayerItem[playerid][item][player_item_used])
		{
			Item_Drop(item, playerid, false);
		}
	}

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	z = floatadd(z, -0.973339);

	AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_BLOCK, reason);

	new i_name[40];
    format(i_name, sizeof(i_name), "%s", pInfo[playerid][player_name]);

	new iid = Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_CORPSE, 19944, pInfo[playerid][player_killer], pInfo[playerid][player_death], i_name);
	mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_items` SET `item_ownertype` = '1', `item_world` = '%d', `item_posx` = '%f', `item_posy` = '%f', `item_posz` = '%f' WHERE `item_uid` = %d", GetPlayerVirtualWorld(playerid), x, y, z, PlayerItem[playerid][iid][player_item_uid]));
	
	new uid  = PlayerItem[playerid][iid][player_item_uid];
	DeleteItem(iid, false, playerid);

	LoadItem(sprintf("WHERE `item_uid` = %d", uid), false, true);

	Kick(playerid);
	return 1;
}

stock BanWithIp(playerid, giveplayer_id, time, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[200], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);
	
	if(time == 0)
	{
		format(string, sizeof(string), "~r~Ban~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", giver_name, pInfo[playerid][player_name], reason);
	}
	else
	{
		format(string, sizeof(string), "~r~Ban (%d dni)~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", time, giver_name, pInfo[playerid][player_name], reason);
	}
	
	SendFormattedClientMessage(playerid, COLOR_DARK_RED, "> Otrzymujesz karÍ (Ban) od %s. PowÛd %s.", giver_name, reason);

	TextDrawSetString(TextPenalty, string);

	TextDrawShowForAll(TextPenalty);

	DeletePenalty = 8;

	if(time == 0)
	{
		AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_BAN, reason);
	}
	else
	{
		AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_BAN, reason, 0, gettime() + time*86400);
	}

	Ban(playerid);
	return 1;
}


stock BanAc(playerid, giveplayer_id, time, reason[])
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[200], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);
	
	if(time == 0)
	{
		format(string, sizeof(string), "~r~Ban~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", giver_name, pInfo[playerid][player_name], reason);
	}
	else
	{
		format(string, sizeof(string), "~r~Ban (%d dni)~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s", time, giver_name, pInfo[playerid][player_name], reason);
	}
	
	SendFormattedClientMessage(playerid, COLOR_DARK_RED, "> Otrzymujesz karÍ (Ban) od %s. PowÛd %s.", giver_name, reason);

	TextDrawSetString(TextPenalty, string);

	TextDrawShowForAll(TextPenalty);

	DeletePenalty = 8;

	if(time == 0)
	{
		AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_BAN, reason);
	}
	else
	{
		AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_BAN, reason, 0, gettime() + time*86400);
	}

	Kick(playerid);
	return 1;
}

stock AdminJail(playerid, giveplayer_id, reason[], time)
{
	if(playerid == INVALID_PLAYER_ID) return 1;
	if(giveplayer_id == INVALID_PLAYER_ID) return 1;
	new string[200], giver_name[24];
	if(giveplayer_id == -1) strmid(giver_name, "System", 0, 6, 24);
	else                    strmid(giver_name, pInfo[giveplayer_id][player_name], 0, strlen(pInfo[giveplayer_id][player_name]), 24);
	
	EscapePL(reason);

	if(time == 0)
	{
	    SendFormattedClientMessage(playerid, COLOR_LIGHTER_RED, "%s wypuúci≥ CiÍ z Admin Jaila z powodem: %s.", giver_name, reason);
	    SendFormattedClientMessage(giveplayer_id, COLOR_LIGHTER_RED, "Wypuúci≥eú %s z AJ.", pInfo[playerid][player_name]);
	    SetPlayerPos(playerid, 1721.98, -1719.12, 13.5349);
	    mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_aj = 0 WHERE char_uid = %d", pInfo[playerid][player_id]));
	    pInfo[playerid][player_aj] = 0;
	    SetPlayerVirtualWorld(playerid, 0);
		return 1;
	}
	
	format(string, sizeof(string), "~r~AdminJail (%d min)~n~~w~Nadawca: %s~n~~w~Odbiorca: %s~n~~y~Powod: %s",time,giver_name, pInfo[playerid][player_name], reason);
	
	TextDrawSetString(TextPenalty, string);

	TextDrawShowForAll(TextPenalty);

	SendFormattedClientMessage(playerid, COLOR_DARK_RED, "> Otrzymujesz karÍ (AdminJail) od %s. PowÛd %s.", giver_name, reason);
	
	pInfo[playerid][player_aj]=time;

	mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_aj = %d WHERE char_uid = %d", pInfo[playerid][player_aj], pInfo[playerid][player_id]));
	SetPlayerPos(playerid, 154.0880, -1951.6383, 47.8750);
	SetPlayerVirtualWorld(playerid, pInfo[playerid][player_id]);
	AddPlayerPunishLog(playerid, giveplayer_id, PUNISH_AJ, reason, time);
	DeletePenalty = 8;
	return 1;
}

stock EscapePL(name[])
{
    for(new i = 0; name[i] != 0; i++)
    {
	    if(name[i] == 'ú') name[i] = 's';
	    else if(name[i] == 'Í') name[i] = 'e';
	    else if(name[i] == 'Û') name[i] = 'o';
	    else if(name[i] == 'π') name[i] = 'a';
	    else if(name[i] == '≥') name[i] = 'l';
	    else if(name[i] == 'ø') name[i] = 'z';
	    else if(name[i] == 'ü') name[i] = 'z';
	    else if(name[i] == 'Ê') name[i] = 'c';
	    else if(name[i] == 'Ò') name[i] = 'n';
	    else if(name[i] == 'ú') name[i] = 'S';
	    else if(name[i] == ' ') name[i] = 'E';
	    else if(name[i] == '”') name[i] = 'O';
	    else if(name[i] == '•') name[i] = 'A';
	    else if(name[i] == '£') name[i] = 'L';
	    else if(name[i] == 'Ø') name[i] = 'Z';
	    else if(name[i] == 'è') name[i] = 'Z';
	    else if(name[i] == '∆') name[i] = 'C';
	    else if(name[i] == '—') name[i] = 'N';
	    //else if(name[i] == ' ') name[i] = '_';
    }
}
