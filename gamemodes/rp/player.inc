stock OnPlayerLoginHere(playerid)
{
	pInfo[playerid][player_cache] = mysql_query(mySQLconnection, sprintf("SELECT * FROM ipb_characters WHERE `char_uid` = %d LIMIT 1", pInfo[playerid][player_id]));

	cache_get_value_index_int(0, 3, pInfo[playerid][player_hours]);
	cache_get_value_index_int(0, 4, pInfo[playerid][player_minutes]);
	cache_get_value_index_int(0, 5, pInfo[playerid][player_money]);
	cache_get_value_index_int(0, 6, pInfo[playerid][player_bank_money]);
	cache_get_value_index_int(0, 7, pInfo[playerid][player_bank_number]);
	cache_get_value_index_int(0, 8, pInfo[playerid][player_skin]);
	cache_get_value_index_float(0, 9, pInfo[playerid][player_health]);
	cache_get_value_index_int(0, 10, pInfo[playerid][player_sex]);
	cache_get_value_index_int(0, 11, pInfo[playerid][player_age]);
	cache_get_value_index_float(0, 12, pInfo[playerid][player_quit_pos][0]);
	cache_get_value_index_float(0, 13, pInfo[playerid][player_quit_pos][1]);
	cache_get_value_index_float(0, 14, pInfo[playerid][player_quit_pos][2]);
	cache_get_value_index_float(0, 15, pInfo[playerid][player_quit_pos][3]);
	cache_get_value_index_int(0, 16, pInfo[playerid][player_quit_vw]);
	cache_get_value_index_int(0, 17, pInfo[playerid][player_quit_int]);
	cache_get_value_index_int(0, 18, pInfo[playerid][player_quit_time]);
	cache_get_value_index_float(0, 19, pInfo[playerid][player_strength]);
	cache_get_value_index_int(0, 20, pInfo[playerid][player_bw]);
	cache_get_value_index_int(0, 21, pInfo[playerid][player_aj]);
	cache_get_value_index_int(0, 22, pInfo[playerid][player_job]);
	cache_get_value_index_int(0, 23, pInfo[playerid][player_documents]);
	cache_get_value_index_int(0, 24, pInfo[playerid][player_fight_style]);
	cache_get_value_index_int(0, 25, pInfo[playerid][player_active]);
	cache_get_value_index_int(0, 26, pInfo[playerid][player_walking_anim]);
	cache_get_value_index(0, 27, pInfo[playerid][player_walking_lib], 16);
 	cache_get_value_index(0, 28, pInfo[playerid][player_walking_name], 24);
 	cache_get_value_index_int(0, 29, pInfo[playerid][player_renting]);
 	cache_get_value_index_int(0, 30, pInfo[playerid][player_spawn]);
 	cache_get_value_index_int(0, 31, pInfo[playerid][player_spawn_type]);
 	cache_get_value_index_float(0, 32, pInfo[playerid][player_weapon_skill]);
	cache_get_value_index(0, 33, pInfo[playerid][player_extra_status], 32);
	cache_get_value_index_int(0, 34, pInfo[playerid][player_arrest]);
	cache_get_value_index_int(0, 35, pInfo[playerid][player_last_creator]);
	cache_get_value_index_int(0, 36, pInfo[playerid][player_gym_carnet]);
	cache_get_value_index_int(0, 37, pInfo[playerid][player_last_work]);
	cache_get_value_index_int(0, 38, pInfo[playerid][player_flags]);
	cache_get_value_index_int(0, 39, pInfo[playerid][player_editor]);
	cache_get_value_index_int(0, 40, pInfo[playerid][player_achievements]);
	cache_get_value_index_int(0, 41, pInfo[playerid][player_widescreen]);

	if(pInfo[playerid][player_widescreen])
	{
   		pInfo[playerid][player_health_bar] = CreatePlayerProgressBar(playerid, 583, 56.0, 38.0, 0.1, COLOR_GREEN);
   	}
   	else
   	{
   		pInfo[playerid][player_health_bar] = CreatePlayerProgressBar(playerid, 548, 68.5, 62.5, 5.5, COLOR_GREEN);
   	}
   	
   	TextDrawHideForPlayer(playerid, Serverlogo);
	ShowPlayerProgressBar(playerid, pInfo[playerid][player_health_bar]);

	CreateZoneTextDraw(playerid);

	pInfo[playerid][player_online_time] = pInfo[playerid][player_hours] * 3600 + pInfo[playerid][player_minutes] * 60;
	if( pInfo[playerid][player_bw] > 0 ) pInfo[playerid][player_bw_end_time] = pInfo[playerid][player_bw] + gettime();  

	if(pInfo[playerid][player_active] == 1)
	{
		for(new i;i<50;i++) SendClientMessage(playerid, -1, " ");
		SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Twoja postaæ jest zablokowana, zajrzyj w swój profil na forum w celu sprawdzenia szczegó³ów.");
		Kick(playerid);
		return 1;
	}
	
	for(new w = 0; (w < 10) && (w != 7 && w != 8 && w != 9); w++) SetPlayerSkillLevel(playerid, w, 1);

	if(pInfo[playerid][player_weapon_skill] > 1)
	{
		//new wlevel = floatround(pInfo[playerid][player_weapon_skill]);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 999);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 999);
	}

	new country[128];
	GetPlayerCountry(playerid, country);

	/*if( strfind(country, "Anonymous") != -1 )
	{
		//
	}
	else
	{
		BanAc(playerid, -1, "VPN/Proxy detected");
		return 1;
	}*/

	if( strfind(country, "Poland") != -1 )
	{
		//
	}
	else
	{
		foreach(new play: Player)
		{
			if(pInfo[play][player_admin_duty] == true)
			{
				SendClientMessage(play, COLOR_GOLD, sprintf("%s (%d): %s.", pInfo[playerid][player_name], playerid, country));
			}
		}
	}
	
	UpdatePlayerLabel(playerid);
	SetPlayerMoney(playerid, pInfo[playerid][player_money]);
	SetPlayerScore(playerid, pGlobal[playerid][glo_score]);
	SetPVarInt(playerid, "AnimHitPlayerGun", 0);

	Attach3DTextLabelToPlayer(pInfo[playerid][player_label], playerid, 0.0, 0.0, 0.2);
	AttachPlayerStatuses(playerid);

	pInfo[playerid][player_capacity] = floatround(pInfo[playerid][player_strength], floatround_floor)*400;
	pInfo[playerid][player_last_join] = gettime();
	pInfo[playerid][player_last_skin] = pInfo[playerid][player_skin];

	mysql_tquery(mySQLconnection, sprintf("INSERT INTO `ipb_logged_players` (char_uid, user_id, seen) VALUES (%d, %d, %d)", pInfo[playerid][player_id], pGlobal[playerid][glo_id], pInfo[playerid][player_last_join]));
	mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_characters` SET char_online = 1 WHERE char_uid = %d", pInfo[playerid][player_id]));
	
	new IP[16];
	GetPlayerIp(playerid, IP, sizeof(IP));
	mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_game_sessions` (session_uid, session_type, session_ip, session_owner, session_start) VALUES (null, %d, '%s', %d, %d)", SESSION_TYPE_LOGIN, IP, pInfo[playerid][player_id], gettime()));
	pInfo[playerid][player_session] = cache_insert_id();

	scrp_SpawnPlayer(playerid, false);
	TogglePlayerSpectating(playerid, 0);
	
	pInfo[playerid][player_logged] = true;

	new groupsLoaded = LoadPlayerGroupData(playerid);
	new itemsLoaded  = LoadPlayerItemData(playerid);

	UpdatePlayerColor(playerid);

	SetPlayerFightingStyle(playerid, pInfo[playerid][player_fight_style]);
	
	//PlayerTextDrawShow(playerid, ZoneName[playerid]);
	PlayerTextDrawShow(playerid, TextDrawSanNews[playerid]);
	TextDrawHideForPlayer(playerid, Tutorial[playerid]);

	ShowPlayerZones(playerid);
	SetPlayerRadio(playerid);

	SendFormattedClientMessage(playerid, COLOR_GREY, "Witaj %s (GID: %d). Zalogowano na postaæ %s (UID: %d). Mi³ej gry!", pGlobal[playerid][glo_name], pGlobal[playerid][glo_id], pInfo[playerid][player_name], pInfo[playerid][player_id], playerid);  
	logprintf(LOG_PLAYER, "[load] Wczytano dane postaci %s (UID: %d). [Grupy: %d] [Przedmioty: %d]", pInfo[playerid][player_name], pInfo[playerid][player_id], groupsLoaded, itemsLoaded);
	
	if(pGlobal[playerid][glo_premium] != 0 && pGlobal[playerid][glo_premium] < gettime())
	{
		mysql_tquery(mySQLconnection, sprintf("UPDATE core_members SET member_premium_time = 0 WHERE member_id = %d", pGlobal[playerid][glo_id]));
		SendClientMessage(playerid, COLOR_GOLD, "Czas twojego konta premium dobieg³ koñca, dziêkujemy za wspomaganie serwera.");
		pGlobal[playerid][glo_premium] = 0;
	}
	
	EnablePlayerCameraTarget(playerid, 1);

	cache_delete(pInfo[playerid][player_cache]);
	return 1;
}

stock IsValidSkin(skinid)
{
	switch(skinid)
	{
		case 0: return 0;
		case 74: return 0;
	}

	if(skinid > 311 && skinid < 25000) return 0;

	return 1;
}

stock SetPlayerRadio(playerid)
{
	if(!Iter_Contains(Groups, last_radio)) return 1;
	if(Group[last_radio][group_type] != GROUP_TYPE_SN) return 1;
	pInfo[playerid][player_radio] = last_radio;

	if(strlen(Group[last_radio][group_radio_text]))
	{
		switch(Group[last_radio][group_news_type])
		{
			case 1:
			{
				PlayerTextDrawSetString(playerid, TextDrawSanNews[playerid], sprintf("_~w~%s ~>~ ~y~%s~w~ ~>~ %s", Group[last_radio][group_name], Group[last_radio][group_radio_sender], Group[last_radio][group_radio_text]));
			}
			case 2:
			{
				PlayerTextDrawSetString(playerid, TextDrawSanNews[playerid], sprintf("_~w~%s ~>~ ~g~~h~Reklama~w~ ~>~ %s", Group[last_radio][group_name], Group[last_radio][group_radio_text]));
			}
			case 3:
			{
				PlayerTextDrawSetString(playerid, TextDrawSanNews[playerid], sprintf("_~w~%s ~p~LIVE ~>~ ~y~%s~w~ ~>~ %s", Group[last_radio][group_name], Group[last_radio][group_radio_sender], Group[last_radio][group_radio_text]));
			}
		}
	}
	else
	{
		PlayerTextDrawSetString(playerid, TextDrawSanNews[playerid], sprintf("_~w~%s ~>~ Aktualnie nic nie jest nadawane w tej stacji.", Group[last_radio][group_name]));
	}

	return 1;
}

stock ShowPlayerZones(playerid)
{
	if(!IsPlayerInGang(playerid)) return 1;

	foreach(new a_id: Areas)
	{
		if(Area[a_id][area_type] != AREA_TYPE_NORMAL) continue;
		if(Area[a_id][area_visible] == false) continue;
		if(Area[a_id][area_owner_type] == AREA_OWNER_TYPE_GROUP)
		{
			new a_owner = GetGroupByUid(Area[a_id][area_owner]);
			if(a_owner != -1)
			{
				if(Group[a_owner][group_type] == GROUP_TYPE_GANG)
				{
					if(Area[a_id][area_gzone] > 0)
					{
						new first = GetGroupColor(a_owner);
						new color = (first & 0xFFFFFF80);
						GangZoneShowForPlayer(playerid, Area[a_id][area_gzone], color);
						Iter_Add(PlayerZones[playerid], Area[a_id][area_gzone]);
					}
				}
			}
		}
	}

	return 1;
}

stock HidePlayerZones(playerid)
{
	foreach(new zoneid: PlayerZones[playerid])
	{
		GangZoneHideForPlayer(playerid, zoneid);
		new next;
	    Iter_SafeRemove(PlayerZones[playerid], zoneid, next);
	    zoneid = next;
	}
}

stock IsGlobalLogged(playerid)
{
	foreach(new p: Player)
	{
		if(pGlobal[playerid][glo_id] == pGlobal[p][glo_id] && gInfo[p][global_logged]) return 1;
	}

	return 0;
}

stock LoadPlayerItemData(playerid)
{
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT item_uid, item_type, item_value1, item_value2, item_used, item_extraid, item_weight, item_model, item_name, item_condition FROM ipb_items WHERE item_ownertype = %d AND item_owner = %d", ITEM_OWNER_TYPE_PLAYER, pInfo[playerid][player_id]));
	cache_get_row_count(rows);

	new i_id = -1;
	
	for(new row = 0; row != rows; row++)
	{
		i_id = Iter_Free(PlayerItems[playerid]);
		Iter_Add(PlayerItems[playerid], i_id);

		cache_get_value_index_int(row, 0, PlayerItem[playerid][i_id][player_item_uid]);
		cache_get_value_index_int(row, 1, PlayerItem[playerid][i_id][player_item_type]);
		cache_get_value_index_int(row, 2, PlayerItem[playerid][i_id][player_item_value1]);
		cache_get_value_index_int(row, 3, PlayerItem[playerid][i_id][player_item_value2]);
		cache_get_value_index_int(row, 4, PlayerItem[playerid][i_id][player_item_used]);
		cache_get_value_index_int(row, 5, PlayerItem[playerid][i_id][player_item_extraid]);
		cache_get_value_index_int(row, 6, PlayerItem[playerid][i_id][player_item_weight]);
		cache_get_value_index_int(row, 7, PlayerItem[playerid][i_id][player_item_model]);
		cache_get_value_index_float(row, 9, PlayerItem[playerid][i_id][player_item_condition]);
		cache_get_value_index(row, 8, PlayerItem[playerid][i_id][player_item_name], 40);
	}

	SetupPlayerCapacity(playerid);
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	return rows;
}

stock AddAchievement(playerid, achiev_bit, achiev_score)
{
	mysql_tquery(mySQLconnection, sprintf("INSERT INTO ipb_char_achievements (achiev_score, achiev_bit, achiev_owner, achiev_date) VALUES (%d, %d, %d, %d)", achiev_score, achiev_bit, pInfo[playerid][player_id], gettime()));
	
	pInfo[playerid][player_achievements] += achiev_bit;
	mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_achievements = %d WHERE char_uid = %d", pInfo[playerid][player_achievements], pInfo[playerid][player_id]));

	pGlobal[playerid][glo_score] += achiev_score;
	SetPlayerScore(playerid, pGlobal[playerid][glo_score]);

	switch(achiev_bit)
	{
		case ACHIEV_NOOB: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Œwie¿ak - jedna godzina na postaci (%d GS).", achiev_score));
		case ACHIEV_50H: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Nowicjusz - 50 godzin na postaci (%d GS).", achiev_score));
		case ACHIEV_500H: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Maniak - 500 godzin na postaci (%d GS).", achiev_score));
		case ACHIEV_1000H: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Sta³y bywalec - 1000 godzin na postaci (%d GS).", achiev_score));
		case ACHIEV_LEADER: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Dyktator - za³ó¿ organizacje przestêpcz¹ (%d GS).", achiev_score));
		case ACHIEV_BLEADER: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Biznesmen - za³ó¿ w³asny biznes (%d GS).", achiev_score));
		case ACHIEV_CAREER: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Kariera - zatrudnij siê w pierwszym przedsiêbiorstwie (%d GS).", achiev_score));
		case ACHIEV_RICH: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Bogacz - zgromadŸ $50.000 na koncie bankowym (%d GS).", achiev_score));
		case ACHIEV_CARS: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Kolekcjoner - stañ siê w³aœcicielem szeœciu pojazdów (%d GS).", achiev_score));
		case ACHIEV_BILLION: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Milioner - pierwszy milion na koncie bankowym (%d GS).", achiev_score));
		case ACHIEV_WORKER: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Wzorowy pracownik - odbierz pierwsz¹ wyp³¹tê (%d GS).", achiev_score));
		case ACHIEV_DRIVER: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Niezawodny kierowca - 10000km przebiegu w jednym pojeŸdzie (%d GS).", achiev_score));
		case ACHIEV_RACE: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Driver - weŸ udzia³ w wyœcigu (%d GS).", achiev_score));
		case ACHIEV_FIRSTCAR: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Pierwszy pojazd - zakup swoje pierwsze cztery kó³ka (%d GS).", achiev_score));
		case ACHIEV_STRONG: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Strongman - nabij 100 procent si³y na pakerni (%d GS).", achiev_score));
		case ACHIEV_GYM: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Si³acz - pierwsze kroki na pakerni, nabij 25 procent si³y (%d GS).", achiev_score));
		case ACHIEV_ADDICT: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Narkoman - za¿yj narkotyk (%d GS).", achiev_score));
		case ACHIEV_ITEM: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Miruœ - sprzedaj innemu graczowi pierwszy przedmiot (%d GS).", achiev_score));
		case ACHIEV_ROBBER: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Rabuœ - dokonaj pierwszego skoku (%d GS).", achiev_score));
		case ACHIEV_BANDIT: SendClientMessage(playerid, COLOR_GOLD, sprintf("Odblokowano osi¹gniêcie: Bandyta - wyl¹duj w areszcie policyjnym (%d GS).", achiev_score));
	}
}

stock InteractionKey(playerid)
{
	new targetid = GetPlayerCameraTargetPlayer(playerid);

	if(targetid != INVALID_PLAYER_ID)
	{
		DynamicGui_Init(playerid);

		DynamicGui_SetDialogValue(playerid, targetid);

		new interaction_list[256];
		format(interaction_list, sizeof(interaction_list), "1. Podaj rêkê\n2. Poca³uj\n3. Zbij pi¹tke\n4. SprawdŸ obra¿enia");

		for(new i=0;i<4;i++)
		{
			DynamicGui_AddBlankRow(playerid);
		}

		if( GetPlayerUsedItem(playerid, ITEM_TYPE_PHONE) != -1 )
		{
			format(interaction_list, sizeof(interaction_list), "%s\n5. Wyœlij vCard", interaction_list);
			DynamicGui_AddRow(playerid, DG_INTERACTION_VCARD);
		}

		new gid = pInfo[playerid][player_duty_gid];

		if(gid == -1) return ShowPlayerDialog(playerid, DIALOG_PLAYER_INTERACTION, DIALOG_STYLE_LIST, sprintf("Interakcja z graczem %s:", pInfo[targetid][player_name]), interaction_list, "Wybierz", "WyjdŸ");

		if(GroupHasFlag(gid, GROUP_FLAG_CUFFS))
		{
			DynamicGui_AddRow(playerid, DG_INTERACTION_CUFF);	
			format(interaction_list, sizeof(interaction_list), "%s\n6. Skuj", interaction_list);
		}

		if(GroupHasFlag(gid, GROUP_FLAG_KEEP) && GetPlayerVirtualWorld(playerid) != 0)
		{
			DynamicGui_AddRow(playerid, DG_INTERACTION_KEEP);	
			format(interaction_list, sizeof(interaction_list), "%s\n7. Przetrzymaj", interaction_list);
		}

		switch(Group[gid][group_type])
		{
			case GROUP_TYPE_LSPD: 
			{
				DynamicGui_AddRow(playerid, DG_INTERACTION_TAKE);
				DynamicGui_AddRow(playerid, DG_INTERACTION_TAKELIC);
				format(interaction_list, sizeof(interaction_list), "%s\n8. Zabierz przedmiot\n9. Zabierz prawo jazdy", interaction_list);
			}
			case GROUP_TYPE_GANG: 
			{
				DynamicGui_AddRow(playerid, DG_INTERACTION_TIE);	
				format(interaction_list, sizeof(interaction_list), "%s\n8. Zwi¹¿", interaction_list);

				if(IsPlayerLeadingTarget(playerid, targetid, gid) && pInfo[targetid][player_bw] > 0)
				{
					format(interaction_list, sizeof(interaction_list), "%s\n9. Zabij", interaction_list);
					DynamicGui_AddRow(playerid, DG_INTERACTION_KILL);
				}
			}
			case GROUP_TYPE_MEDIC: 
			{
				DynamicGui_AddRow(playerid, DG_INTERACTION_HEAL);	
				format(interaction_list, sizeof(interaction_list), "%s\n8. Ulecz", interaction_list);
			}
		}

    	new slot = GetPlayerGroupSlot(playerid, gid);

    	if(slot != -1)
    	{
    		if( WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) )
    		{
    			format(interaction_list, sizeof(interaction_list), "%s\n10. Zatrudnij w %s", interaction_list, Group[gid][group_name]);
    			DynamicGui_AddRow(playerid, DG_INTERACTION_INVITE);
    		}
    	}

		ShowPlayerDialog(playerid, DIALOG_PLAYER_INTERACTION, DIALOG_STYLE_LIST, sprintf("Interakcja z graczem %s:", pInfo[targetid][player_name]), interaction_list, "Wybierz", "WyjdŸ");
		return 1;
	}

	targetid = GetPlayerCameraTargetVehicle(playerid);

	if(targetid != INVALID_VEHICLE_ID)
	{
		DynamicGui_Init(playerid);

		DynamicGui_SetDialogValue(playerid, targetid);

		for(new i=0;i<3;i++)
		{
			DynamicGui_AddBlankRow(playerid);
		}

		new interaction_list[128];
		format(interaction_list, sizeof(interaction_list), "1. %s pojazd\n", (Vehicle[targetid][vehicle_locked]==true) ? ("Otwórz") : ("Zamknij"));
		format(interaction_list, sizeof(interaction_list), "%s2. %s maske\n", interaction_list, (Vehicle[targetid][vehicle_bonnet]==true) ? ("Zamknij") : ("Otwórz"));
		format(interaction_list, sizeof(interaction_list), "%s3. %s baga¿nik\n", interaction_list, (Vehicle[targetid][vehicle_boot]==true) ? ("Zamknij") : ("Otwórz"));

		ShowPlayerDialog(playerid, DIALOG_VEHICLE_INTERACTION, DIALOG_STYLE_LIST, sprintf("Interakcja z pojazdem %s:", VehicleNames[Vehicle[targetid][vehicle_model]-400]), interaction_list, "Wybierz", "WyjdŸ");
		return 1;
	}

	new interact_list[150];
	format(interact_list, sizeof(interact_list), "1. Przedmioty w okolicy\n2. Informacje o strefie");

	targetid = GetPlayerCameraTargetDynObject(playerid);

	if(IsValidDynamicObject(targetid))
	{
		DynamicGui_Init(playerid);

		for(new i=0;i<2;i++)
		{
			DynamicGui_AddBlankRow(playerid);
		}

		switch(Object[targetid][object_model])
		{
			case OBJECT_ATM:
			{
				format(interact_list, sizeof(interact_list), "%s\n3. Skorzystaj z bankomatu", interact_list);
				DynamicGui_AddRow(playerid, DG_INTERACTION_BANK);
			}
			case OBJECT_BUSSTOP: 
			{
				format(interact_list, sizeof(interact_list), "%s\n3. Skorzystaj z autobusu", interact_list);
				DynamicGui_AddRow(playerid, DG_INTERACTION_BUS);
			}
		}
	}

	ShowPlayerDialog(playerid, DIALOG_INTERACTION, DIALOG_STYLE_LIST, "Interakcja z otoczeniem", interact_list, "Wybierz", "WyjdŸ");

	return 0;
}

stock IsPlayerLeadingTarget(playerid, targetid, gid)
{
	new slot = GetPlayerGroupSlot(playerid, gid);
	if(slot == -1) return 0;

	slot = GetPlayerGroupSlot(targetid, gid);
	if(slot == -1) return 0;
	if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return 0;

	return 1;
}

stock EncountDamage(playerid, Float:amount, bodypart, weaponid)
{
	new damage_id = GetFreeDamageId(playerid);
	pInjury[playerid][damage_id][injury_id] = damage_id;
	pInjury[playerid][damage_id][injury_damage] = floatround(amount);
	pInjury[playerid][damage_id][injury_bodypart] = bodypart;
	pInjury[playerid][damage_id][injury_weapon] = weaponid;
	pInjury[playerid][damage_id][injury_time] = gettime();
}

stock GetFreeDamageId(playerid)
{
	new damage_id;
	for(new b = 1; b < 10; b++)
	{
		if(pInjury[playerid][b][injury_id] == 0)
		{
			damage_id = b;
			break;
		}
	}
	return damage_id;
}

stock GetClientSkin(playerid)
{
	new customskin = GetPlayerCustomSkin(playerid);
	if(customskin != 0) return customskin;
	else return GetPlayerSkin(playerid);
}

stock HasPlayerProductionClothes(playerid)
{
	switch(GetPlayerSkin(playerid))
	{
		case 143: return 1;
		case 144: return 1;
		case 145: return 1;
		case 146: return 1;
	}

	return 0;
}

stock IsPlayerInSouthCentral(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	if(x >= 1810 && x <= 2966 && y >= -2149 && y <= -917)
	{
	    return 1;
	}
	
	return 0;
}

stock SetupPlayerCapacity(playerid)
{
	pInfo[playerid][player_capacity] = floatround(pInfo[playerid][player_strength], floatround_round) * 600;

	foreach (new item : PlayerItems[playerid])
	{
		pInfo[playerid][player_capacity] -= PlayerItem[playerid][item][player_item_weight];
		
	}
}

stock AttachPlayerStatuses(playerid)
{
	if(pGlobal[playerid][glo_score] < 30)
	{
		AddPlayerStatus(playerid, PLAYER_STATUS_NEW);
	}

	if(pInfo[playerid][player_hours] < 1)
	{
		AddPlayerStatus(playerid, PLAYER_STATUS_NEW_CHAR);
	}

	if(pInfo[playerid][player_strength] > 60)
	{
		AddPlayerStatus(playerid, PLAYER_STATUS_SPORT);
	}

	if(pInfo[playerid][player_strength] > 80)
	{
		AddPlayerStatus(playerid, PLAYER_STATUS_MUSCULAR);
		RemovePlayerStatus(playerid, PLAYER_STATUS_SPORT);
	}

	if(strlen(pInfo[playerid][player_extra_status]) > 1)
	{
		AddPlayerStatus(playerid, PLAYER_STATUS_EXTRA);
	}
}

stock SetPlayerLookAt(playerid, Float:x, Float:y)
{
	new Float:Px, Float:Py, Float: Pa;
	GetPlayerPos(playerid, Px, Py, Pa);
	Pa = floatabs(atan((y-Py)/(x-Px)));
	if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
	else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
	else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
	Pa = floatsub(Pa, 90.0);
	if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
	SetPlayerFacingAngle(playerid, Pa);
}

stock GetPlayerByUid(p_uid)
{
	foreach(new p : Player)
	{
		if( pInfo[p][player_id] == p_uid ) return p;
	}
	
	return -1;
}

stock ShowPlayerPayment(playerid)
{	
	ShowPlayerDialog(playerid, DIALOG_PAYMENT, DIALOG_STYLE_LIST, "Sposób p³atnoœci", "Gotówka\nKarta kredytowa", "Wybierz", "Anuluj");
}

stock OnPlayerPaymentResponse(playerid, type, response)
{
	OnPlayerOfferFinish(playerid, type, response);
	return 1;
}

stock AddPlayerBankMoney(playerid, amount)
{
	pInfo[playerid][player_bank_money] += amount;
	
	mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_bankcash` = %d WHERE `char_uid` = %d", pInfo[playerid][player_bank_money], pInfo[playerid][player_id]));
}

stock GetPlayerSpawnSlot(playerid, spawnid)
{
	for(new i;i<5;i++)
	{
		if( pSpawn[playerid][i][spawn_uid] == spawnid ) return i;
	}
	return -1;
}

stock RefreshPlayer(playerid)
{
	new Float:pos[3];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	RP_PLUS_SetPlayerPos(playerid, pos[0]+0.05, pos[1]+0.05, pos[2]);
}

stock LoadPlayerSpawnData(playerid)
{
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM ipb_char_spawns WHERE `spawn_owner` = %d LIMIT 25", pInfo[playerid][player_id]));
	cache_get_row_count(rows);
	
	for(new row = 0; row != rows; row++)
	{	
		new spawn_id = Iter_Free(PlayerSpawns[playerid]);
		cache_get_value_index_int(row, 0, pSpawn[playerid][spawn_id][spawn_uid]);			
		cache_get_value_index_int(row, 1, pSpawn[playerid][spawn_id][spawn_door]);
		cache_get_value_index_int(row, 2, pSpawn[playerid][spawn_id][spawn_perm]);
		Iter_Add(PlayerSpawns[playerid], spawn_id);
	}

	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	return rows;
}

stock LoadPlayerGroupData(playerid)
{
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM ipb_char_groups WHERE `char_uid` = %d LIMIT 5", pInfo[playerid][player_id]));
	cache_get_row_count(rows);
	
	if(rows)
	{
		for(new row = 0; row != rows; row++)
		{		
			new uid;
			cache_get_value_index_int(row, 2, uid);
			pGroup[playerid][row][pg_id] = GetGroupByUid(uid);
			
			cache_get_value_index_int(row, 3, pGroup[playerid][row][pg_rank_perm]);
			cache_get_value_index(row, 4, pGroup[playerid][row][pg_rank_title], 32);
			cache_get_value_index_int(row, 5, pGroup[playerid][row][pg_rank_payment]);
			cache_get_value_index_int(row, 6, pGroup[playerid][row][pg_rank_skin]);
			cache_get_value_index_int(row, 8, pGroup[playerid][row][pg_payday_count]);
			cache_get_value_index_int(row, 9, pGroup[playerid][row][pg_duty_time]);
		}
	}

	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	return rows;
}

stock SendPlayerInformation(playerid, text[], showTime = 2000)
{
	pInfo[playerid][player_info_td_id]++;

	TextDrawHideForPlayer(playerid, Tutorial[playerid]);

	if( showTime > 0 )
	{
		new str[300];
		format(str, sizeof(str), "~w~%s", text);
		
		TextDrawSetString(Tutorial[playerid], str);
		TextDrawShowForPlayer(playerid, Tutorial[playerid]);

		pInfo[playerid][player_info_td_id] = showTime/1000;
	}
	else HideInformationTextdraw(playerid, pInfo[playerid][player_info_td_id]);
	
	return 1;
}

stock IsPlayerVip(playerid)
{
	if( pGlobal[playerid][glo_premium] > 0 ) return 1;
	
	return 0;
}

stock GetPlayerNameByUid(uid, string[25])
{
	new Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT `char_name` FROM `ipb_characters` WHERE `char_uid` = %d", uid));
	
	if(cache_num_rows()) cache_get_value_index(0, 0, string);

	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	return true;
}

stock IsPlayerCrimeOwner(playerid)
{
	foreach(new gid: Groups)
	{
		if(Group[gid][group_creator] == pInfo[playerid][player_id]) return 1;
	}

	return 0;
}

stock static Callback_IsVehicleInPoint(vehicleid, Float:range, Float:x, Float:y, Float:z)
{
    new
        Float:fX,
        Float:fY,
        Float:fZ
    ;
 
    GetVehiclePos(vehicleid, fX, fY, fZ);
 
    fX -= x;
    fY -= y;
    fZ -= z;
 
    return ((fX * fX) + (fY * fY) + (fZ * fZ)) < (range * range);
}

stock IsPlayerSprayingVehicle(playerid, vehicleid)
{
	new
	    index = GetPlayerAnimationIndex(playerid),
		Float:x,
		Float:y,
		Float:z,
		Float:a
	;

	if(IsVehicleStreamedIn(vehicleid, playerid))
	{
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		x += 2.0 * floatsin(-a, degrees);
		y += 2.0 * floatcos(-a, degrees);

		if(Callback_IsVehicleInPoint(vehicleid, 2.0, x, y, z))
		{
			if(pInfo[playerid][player_can_spray] == false) return 0;
			return (1160 <= index <= 1163) || index == 1167 || index == 640;
		}
	}

	return 0;
}

stock GetPlayerGender(playerid)
{
	new gender[10];
	if(pInfo[playerid][player_sex] == 0) format(gender, sizeof(gender), "Kobieta");
	else if(pInfo[playerid][player_sex] == 1) format(gender, sizeof(gender), "Mê¿czyzna");
	return gender;
}

stock GetPlayerJob(playerid)
{
	new praca[20];
	if(pInfo[playerid][player_job] == 0) format(praca, sizeof(praca), "Brak");
	else if(pInfo[playerid][player_job] == 1) format(praca, sizeof(praca), "Drwal");
	else if(pInfo[playerid][player_job] == 2) format(praca, sizeof(praca), "Rybak");
    else if(pInfo[playerid][player_job] == 3) format(praca, sizeof(praca), "Operator wózka");
    else if(pInfo[playerid][player_job] == 4) format(praca, sizeof(praca), "Œmieciarz");
    else if(pInfo[playerid][player_job] == 5) format(praca, sizeof(praca), "Kierowca");
    return praca;
}

stock OnPlayerVirtualWorldChange(playerid, vw)
{
	new d_id = GetDoorByUid(vw);
	
	if( d_id == -1 ) StopAudioStreamForPlayer(playerid);
	else
	{
		if( isnull(Door[d_id][door_audio]) ) StopAudioStreamForPlayer(playerid);
		else
		{
			PlayAudioStreamForPlayer(playerid, Door[d_id][door_audio], 0);
		}
	}
}

stock GetSpawnByUid(spawnuid)
{
	foreach(new spawn_id : GlobalSpawns)
	{
		if(GlobalSpawn[spawn_id][gspawn_id] == spawnuid) return spawn_id;
	}

	return -1;
}

stock scrp_SpawnPlayer(playerid, bool:withSpawn = true)
{
	if( pInfo[playerid][player_bw] > 0 ) return scrp_SpawnPlayerWithBW(playerid, withSpawn);

	if( pInfo[playerid][player_aj] > 0) return scrp_SpawnPlayerInAJ(playerid, withSpawn);

	new time_away = gettime() - pInfo[playerid][player_quit_time];
	if( time_away < QS_TIME )
	{
		SetSpawnInfo(playerid, 255, pInfo[playerid][player_last_skin], pInfo[playerid][player_quit_pos][0], pInfo[playerid][player_quit_pos][1], pInfo[playerid][player_quit_pos][2], pInfo[playerid][player_quit_pos][3], 0, 0, 0, 0, 0, 0);
		mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_posx`='0.0', `char_posy`='0.0', `char_posz`='0.0', `char_posa`='0.0', `char_world`=0, `char_interior`=0, `char_quittime`=0 WHERE `char_uid`=%d", pInfo[playerid][player_id]));
		SendFormattedClientMessage(playerid, COLOR_GREEN, "Twoja pozycja zosta³a przywrócona [czas od wyjœcia z gry: %d min %d s].", floatround(time_away/60, floatround_floor), time_away%60);
		SetPlayerVirtualWorld(playerid, pInfo[playerid][player_quit_vw]);
		SetPlayerInterior(playerid, pInfo[playerid][player_quit_int]);
	}
	else
	{
		if( pInfo[playerid][player_spawn_type] == SPAWN_TYPE_HOUSE) return scrp_SpawnPlayerInHouse(playerid, withSpawn);
		if( pInfo[playerid][player_spawn_type] == SPAWN_TYPE_HOTEL) return scrp_SpawnPlayerInHouse(playerid, withSpawn);
		
		if( !Iter_Count(GlobalSpawns) )
		{
			SendGuiInformation(playerid, ""guiopis"Informacja", "Serwer nie wczyta³ globalnych spawnów, powiadom administracje.");
			Kick(playerid);
		}
		else
		{
			new r_gspawn = Iter_Random(GlobalSpawns);

			if(r_gspawn == -1) return SendGuiInformation(playerid, ""guiopis"Informacja", "Serwer nie wczyta³ globalnych spawnów, powiadom administracje.");

			SetSpawnInfo(playerid, 255, pInfo[playerid][player_skin], GlobalSpawn[r_gspawn][gspawn_pos][0], GlobalSpawn[r_gspawn][gspawn_pos][1], GlobalSpawn[r_gspawn][gspawn_pos][2], GlobalSpawn[r_gspawn][gspawn_pos][3], 0, 0, 0, 0, 0, 0 );
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
		}	
	}
	SetCameraBehindPlayer(playerid);

	if( withSpawn ) SpawnPlayer(playerid);
	
	return 1;
}

stock UpdatePlayerInterior(playerid)
{
	if(GetPlayerVirtualWorld(playerid) != 0)
	{
		new d_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
		if(d_id != -1)
		{
			if(Door[d_id][door_loaded]) return 1;

			new already_loading;
			foreach(new p: Player)
			{
				if(pInfo[p][player_loading_door] == d_id) already_loading = true;
			}

			if(!already_loading)
			{
				pInfo[playerid][player_loading_door] = d_id; 
				mysql_pquery(mySQLconnection, sprintf("SELECT ipb_objects.*, ipb_materials.* FROM ipb_objects LEFT JOIN ipb_materials on ipb_objects.object_uid = ipb_materials.material_owner WHERE ipb_objects.object_world = %d ORDER BY ipb_objects.object_uid ASC", Door[d_id][door_uid]), "OnPlayerLoadDoor", "dd", playerid, d_id);
				TextDrawSetString(Tutorial[playerid], "Trwa wczytywanie ~y~wnetrza~w~...");
				TextDrawShowForPlayer(playerid, Tutorial[playerid]);
				TogglePlayerControllable(playerid, false);
			}
			else
			{
				SetSpawnInfo(playerid, 255, pInfo[playerid][player_last_skin], Door[d_id][door_pos][0], Door[d_id][door_pos][1], Door[d_id][door_pos][2], 0.0, 0, 0, 0, 0, 0, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
			}
		}
	}

	return 1;
}

stock scrp_SpawnPlayerInHouse(playerid, bool:withSpawn = true)
{
	new d_id = GetDoorByUid(pInfo[playerid][player_spawn]);
	if(d_id == -1)
	{
		SendClientMessage(playerid, COLOR_GOLD, "Drzwi w których mieszka³eœ zosta³y usuniête, spawn zosta³ zresetowany.");
		new gspawns = Iter_Random(GlobalSpawns);
		if(gspawns == -1) return printf("[ERROR] Array out of bounds, player.inc 660");
		SetSpawnInfo(playerid, 255, pInfo[playerid][player_skin], GlobalSpawn[gspawns][gspawn_pos][0], GlobalSpawn[gspawns][gspawn_pos][1], GlobalSpawn[gspawns][gspawn_pos][2], 0, 0, 0, 0, 0, 0, 0 );
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_spawn = 0, char_spawn_type = 3 WHERE char_uid = %d", pInfo[playerid][player_id]));

		if( withSpawn ) SpawnPlayer(playerid);	
		return 1;
	}

	if(!Door[d_id][door_loaded])
	{
 		//UpdatePlayerInterior(playerid);
 		SetSpawnInfo(playerid, 255, pInfo[playerid][player_skin], Door[d_id][door_pos][0], Door[d_id][door_pos][1], Door[d_id][door_pos][2], 0, 0, 0, 0, 0, 0, 0 );
		SetPlayerVirtualWorld(playerid, Door[d_id][door_vw]);
		SetPlayerInterior(playerid, Door[d_id][door_int]);
	}
	else
	{
		SetSpawnInfo(playerid, 255, pInfo[playerid][player_skin], Door[d_id][door_spawn_pos][0], Door[d_id][door_spawn_pos][1], Door[d_id][door_spawn_pos][2], 0, 0, 0, 0, 0, 0, 0 );
		SetPlayerVirtualWorld(playerid, Door[d_id][door_spawn_vw]);
		SetPlayerInterior(playerid, Door[d_id][door_spawn_int]);
	}

	if( withSpawn ) SpawnPlayer(playerid);	
	return 1;
}

stock scrp_SpawnPlayerWithBW(playerid, bool:withSpawn = true)
{
	AddPlayerStatus(playerid, PLAYER_STATUS_BW);
	// Spawn player
	SetSpawnInfo(playerid, 1, pInfo[playerid][player_last_skin], pInfo[playerid][player_quit_pos][0], pInfo[playerid][player_quit_pos][1], pInfo[playerid][player_quit_pos][2]-0.2, pInfo[playerid][player_quit_pos][3], 0, 0, 0, 0, 0, 0);
	SetPlayerHealth(playerid, 19);
	TogglePlayerControllable(playerid, 0);
	
	if( withSpawn ) SpawnPlayer(playerid);	
	return 1;
}

stock scrp_SpawnPlayerInAJ(playerid, bool:withSpawn = true)
{
	SetSpawnInfo(playerid, 1, pInfo[playerid][player_skin], 154.0880,-1951.6383,47.8750, 0, 0, 0, 0, 0, 0, 0);
	SetPlayerVirtualWorld(playerid, 1000+playerid);
	if( withSpawn ) SpawnPlayer(playerid);	
	return 1;
}

stock SavePlayer(playerid)
{
	if( pInfo[playerid][player_bw] > 0 && pInfo[playerid][player_bw_end_time] > gettime() )
	{
		pInfo[playerid][player_bw] = pInfo[playerid][player_bw_end_time] - gettime();
	}
	mysql_tquery(mySQLconnection, sprintf("UPDATE `core_members` SET `member_game_points` = %d WHERE `member_id` = %d", pGlobal[playerid][glo_score], pGlobal[playerid][glo_id]));
	mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_hours` = %d, `char_minutes` = %d, `char_health` = '%f', `char_bw` = %d, `char_strength` = '%f', `char_skill` = '%f' WHERE `char_uid` = %d", pInfo[playerid][player_hours], pInfo[playerid][player_minutes], pInfo[playerid][player_health], pInfo[playerid][player_bw], pInfo[playerid][player_strength], pInfo[playerid][player_weapon_skill], pInfo[playerid][player_id]));
	mysql_tquery(mySQLconnection, sprintf("DELETE FROM `ipb_logged_players` WHERE `char_uid` = %d", pInfo[playerid][player_id]));
	
	logprintf(LOG_PLAYER, "[save] Zapisywanie gracza %s (UID: %d)", pInfo[playerid][player_name], pInfo[playerid][player_id]);
}

stock UpdatePlayerColor(playerid)
{	
	if( !pInfo[playerid][player_logged] )
	{
		SetPlayerColor(playerid, 0x00000000);
		return;
	}
	
	if( IsPlayerVip(playerid) ) SetPlayerColor(playerid, 0xFFFFFF80);
	else SetPlayerColor(playerid, 0xADADAD80);
}

stock PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}

stock UpdatePlayerLabel(playerid)
{
	new nick_part[40], status_part[256], f_label[256];
	
	if( GetPlayerUsedItem(playerid, ITEM_TYPE_MASKA) > -1 ) format(nick_part, sizeof(nick_part), "%s", pInfo[playerid][player_name]);	
	else format(nick_part, sizeof(nick_part), "%s (%d)", pInfo[playerid][player_name], playerid);
	SetPlayerName(playerid, pInfo[playerid][player_name]);
	strreplace(pInfo[playerid][player_name], '_', ' ');	
	strreplace(nick_part, '_', ' ');	
	
	// Format status
	sortIntegers( pInfo[playerid][player_status], 0, 5 );
	new comma[5], status_count, last_status;
	for(new s; s < 5; s++)
	{
		if( pInfo[playerid][player_status][s] > 0 )
		{
			status_count += 1;
			last_status = s;
		}
	}
	for(new i; i < 5; i++)
	{
		if( pInfo[playerid][player_status][i] > 0 )
		{
			format(comma, 5, "");
			if( status_count > 1 && last_status != i ) format(comma, 5, ", ");
						
			switch( pInfo[playerid][player_status][i] )
			{
				case PLAYER_STATUS_AFK:
				{
					new afkHour, afkMinute, temp;
					TimestampToDate(pInfo[playerid][player_last_activity], temp, temp, temp, afkHour, afkMinute, temp, 1);
					
					if( afkHour == 24 ) afkHour = 0;
					format(status_part, sizeof(status_part), "%sAFK od %02d:%02d%s", status_part, afkHour+1, afkMinute, comma);
				}
				
				case PLAYER_STATUS_BELT:
				{
					format(status_part, sizeof(status_part), "%spasy%s", status_part, comma);
				}
				case PLAYER_STATUS_HELMET:
				{
					format(status_part, sizeof(status_part), "%skask%s", status_part, comma);
				}
				case PLAYER_STATUS_JAIL:
    			{
    				if(pInfo[playerid][player_sex] == 0)
    				{
     					format(status_part, sizeof(status_part), "%sprzetrzymywana%s", status_part, comma);
     				}
     				else
     				{
     					format(status_part, sizeof(status_part), "%sprzetrzymywany%s", status_part, comma);
     				}
    			}
				case PLAYER_STATUS_EXTRA:
    			{
     				format(status_part, sizeof(status_part), "%s%s%s", status_part, pInfo[playerid][player_extra_status], comma);
    			}	
               	case PLAYER_STATUS_NEW:
				{
					format(status_part, sizeof(status_part), "%snowy gracz%s", status_part, comma);
				}
				case PLAYER_STATUS_NEW_CHAR:
				{
					format(status_part, sizeof(status_part), "%snowa postaæ%s", status_part, comma);
				}
				case PLAYER_STATUS_BW:
				{
					if(pInfo[playerid][player_sex] == 0)
					{
						format(status_part, sizeof(status_part), "%snieprzytomna%s", status_part, comma);
					}
					else
					{
						format(status_part, sizeof(status_part), "%snieprzytomny%s", status_part, comma);
					}
				}
				
				case PLAYER_STATUS_DEALING:
				{
					format(status_part, sizeof(status_part), "%shandluje%s", status_part, comma);
				}
				case PLAYER_STATUS_DRUNK:
				{
					if(pInfo[playerid][player_sex] == 0)
					{
						format(status_part, sizeof(status_part), "%spijana%s", status_part, comma);
					}
					else
					{
						format(status_part, sizeof(status_part), "%spijany%s", status_part, comma);
					}
				}
				case PLAYER_STATUS_SPORT:
				{
					if(pInfo[playerid][player_sex] == 0)
					{
						format(status_part, sizeof(status_part), "%swysportowana%s", status_part, comma);
					}
					else
					{
						format(status_part, sizeof(status_part), "%swysportowany%s", status_part, comma);
					}
				}
				case PLAYER_STATUS_MUSCULAR:
				{
					if(pInfo[playerid][player_sex] == 0)
					{
						format(status_part, sizeof(status_part), "%sumiêœniona%s", status_part, comma);
					}
					else
					{
						format(status_part, sizeof(status_part), "%smuskularny%s", status_part, comma);
					}
				}
				case PLAYER_STATUS_DRUGS:
				{
					if(pInfo[playerid][player_sex] == 0)
					{
						format(status_part, sizeof(status_part), "%snaæpana%s", status_part, comma);
					}
					else
					{
						format(status_part, sizeof(status_part), "%snaæpany%s", status_part, comma);
					}
				}
				case PLAYER_STATUS_WEED:
				{
					if(pInfo[playerid][player_sex] == 0)
					{
						format(status_part, sizeof(status_part), "%szjarana%s", status_part, comma);
					}
					else
					{
						format(status_part, sizeof(status_part), "%szjarany%s", status_part, comma);
					}
				}
				case PLAYER_STATUS_REKAWICZKI:
				{
					format(status_part, sizeof(status_part), "%srêkawiczki%s", status_part, comma);
				}
				case PLAYER_STATUS_ARMOUR:
				{
					format(status_part, sizeof(status_part), "%skamizelka%s", status_part, comma);
				}
			}
		}
	}
	
	if( status_count > 0 ) format(status_part, sizeof(status_part), "(%s)", status_part);

	if( isnull(status_part) ) format(f_label, sizeof(f_label), "%s", nick_part);
	else format(f_label, sizeof(f_label), "%s\n%s", nick_part, status_part);
	
	if( pInfo[playerid][player_taken_damage] > 0 ) Update3DTextLabelText(pInfo[playerid][player_label], LABEL_NICK_DAMAGED_COLOR, f_label);
	else
	{
		new slot = GetPlayerDutySlot(playerid);
		if( slot > -1 )
		{
			new gid = pGroup[playerid][slot][pg_id];
			if( GroupHasFlag(gid, GROUP_FLAG_COLORED) )
			{
				new first = GetGroupColor(gid);
				new color = (first & 0xFFFFFFFF);
				Update3DTextLabelText(pInfo[playerid][player_label], color, f_label);
			}
			else if(pGlobal[playerid][glo_premium] == 1){Update3DTextLabelText(pInfo[playerid][player_label], LABEL_NICK_PREMIUM_COLOR, f_label);}else{Update3DTextLabelText(pInfo[playerid][player_label], LABEL_NICK_NORMAL_COLOR, f_label);}
		}
		else if(pGlobal[playerid][glo_premium] == 1){Update3DTextLabelText(pInfo[playerid][player_label], LABEL_NICK_PREMIUM_COLOR, f_label);}else{Update3DTextLabelText(pInfo[playerid][player_label], LABEL_NICK_NORMAL_COLOR, f_label);}
	}
}

stock AddPlayerStatus(playerid, type)
{
	new free_slot = -1;
	for(new s; s < 5; s++)
	{
		if( pInfo[playerid][player_status][s] == 0 && free_slot == -1 ) free_slot = s;
		if( pInfo[playerid][player_status][s] == type ) return;
	}
	
	if( free_slot == -1 ) return;
	
	pInfo[playerid][player_status][free_slot] = type;
	UpdatePlayerLabel(playerid);
}

stock RemovePlayerStatus(playerid, type)
{
	for(new s; s < 5; s++)
	{
		if( pInfo[playerid][player_status][s] == 0 ) continue;	
		if( pInfo[playerid][player_status][s] == type ) pInfo[playerid][player_status][s] = 0;
	}	
	UpdatePlayerLabel(playerid);
}

stock ApplyCommandAnim(playerid, alias[])
{
	if( !strcmp(alias, "/", true) )		return SendClientMessage(playerid, COLOR_GREY, "Informacja: Nieprawid³owe znaki w animacji.");
	if( !strcmp(alias, "%", true) )		return SendClientMessage(playerid, COLOR_GREY, "Informacja: Nieprawid³owe znaki w animacji.");
	if( !strcmp(alias, "$", true) )		return SendClientMessage(playerid, COLOR_GREY, "Informacja: Nieprawid³owe znaki w animacji.");
	if( !strcmp(alias, "#", true) )		return SendClientMessage(playerid, COLOR_GREY, "Informacja: Nieprawid³owe znaki w animacji.");
	if( !strcmp(alias, "!", true) )		return SendClientMessage(playerid, COLOR_GREY, "Informacja: Nieprawid³owe znaki w animacji.");
	if( !strcmp(alias, "@", true) )		return SendClientMessage(playerid, COLOR_GREY, "Informacja: Nieprawid³owe znaki w animacji.");
	if( !strcmp(alias, "*", true) )		return SendClientMessage(playerid, COLOR_GREY, "Informacja: Nieprawid³owe znaki w animacji.");
	if( !strcmp(alias, "(", true) )		return SendClientMessage(playerid, COLOR_GREY, "Informacja: Nieprawid³owe znaki w animacji.");
	if( !strcmp(alias, ")", true) )		return SendClientMessage(playerid, COLOR_GREY, "Informacja: Nieprawid³owe znaki w animacji.");

	if(pInfo[playerid][player_bw] == 0)
	{
		mysql_query(sprintf("SELECT * FROM `ipb_anim` WHERE `anim_command` = '%s'", alias));
		mysql_store_result();
		
		if( mysql_num_rows() == 1 )
		{
			new anim_action = mysql_fetch_field_int("anim_action");
			
			if( anim_action > 0 )
			{
				SetPlayerSpecialAction(playerid, anim_action);
			}
			else
			{
				new anim_lib[20], anim_name[20];
				mysql_fetch_field("anim_lib", anim_lib);
				mysql_fetch_field("anim_name", anim_name);
				
				pInfo[playerid][player_looped_anim] = true;
				
				ApplyAnimation(playerid, anim_lib, anim_name, mysql_fetch_field_float("anim_speed"), mysql_fetch_field_int("anim_opt1"), mysql_fetch_field_int("anim_opt2"), mysql_fetch_field_int("anim_opt3"), mysql_fetch_field_int("anim_opt4"), mysql_fetch_field_int("anim_opt5"), 1);	
			}
		}
		else
		{
			PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
		}
		
		mysql_free_result();
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Masz BW, nie mo¿esz u¿ywaæ animacji.");
	}
	return 1;
}

stock FreezePlayer(playerid, time = 1000)
{
	TogglePlayerControllable(playerid, 0);
	pInfo[playerid][player_freeze] = time/1000;
}


stock CleanGlobalData(playerid)
{
	for(new z=0; e_global_account_info:z != e_global_account_info; z++)
    {
		gInfo[playerid][e_global_account_info:z] = 0;
    }
    for(new z=0; e_player_global:z != e_player_global; z++)
    {
		pGlobal[playerid][e_player_global:z] = 0;
    }
    for(new z=0; e_session_info:z != e_session_info; z++)
    {
		sInfo[playerid][e_session_info:z] = 0;
    }
}

stock GetPlayerFreeAttachSlot(playerid)
{
	if(IsPlayerVip(playerid))
	{
	    for(new i;i<3;i++)
	    {
			if( !IsPlayerAttachedObjectSlotUsed(playerid, i) ) return i;
	    }
	}
	else
	{
		for(new i;i<4;i++)
	    {
			if( !IsPlayerAttachedObjectSlotUsed(playerid, i) ) return i;
	    }
	}
	
    return -1;
}

stock GetPlayerEditorAngle(playerid)
{
	new Float:angle;
	GetPlayerFacingAngle(playerid, angle);

	if(angle >= 0 && angle <= 45) return 0;
	if(angle > 45 && angle <= 90) return 90;
	if(angle >= 90 && angle <= 135) return 90;
	if(angle > 135 && angle <= 180) return 180;
	if(angle >= 180 && angle <= 225) return 180;
	if(angle > 225 && angle <= 270) return 270;
	if(angle >= 270 && angle <= 310) return 270;
	if(angle > 270 && angle <= 0) return 0;
	return 0;
}

stock GetPlayerAoSlot(playerid, weaponmodel)
{
	for(new i=4 ;i <7;i++)
	{
		if( ao[playerid][i][ao_inserted] == true && ao[playerid][i][ao_model] == weaponmodel ) return i;
	}
    return -1;
}

stock GetPlayerFreeWeaponAttachSlot(playerid)
{
	for(new i=4 ;i <7;i++)
	{
		if( !IsPlayerAttachedObjectSlotUsed(playerid, i) ) return i;
	}
    return -1;
}

stock GetPlayerWeaponAttachSlot(playerid, weaponid, weaponmodel)
{
	for(new i=4 ;i <7;i++)
	{
		if( IsPlayerAttachedObjectSlotUsed(playerid, i) && WeaponVisualModel[weaponid] == weaponmodel ) return i;
	}
    return -1;
}

stock IsPlayerCop(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(GetPlayerSkin(playerid)== 281 || 
		GetPlayerSkin(playerid)== 265 ||
		GetPlayerSkin(playerid)== 266 ||
		GetPlayerSkin(playerid)== 267 ||
		GetPlayerSkin(playerid)== 280 ||
		GetPlayerSkin(playerid)== 282 ||
		GetPlayerSkin(playerid)== 283 ||
		GetPlayerSkin(playerid)== 284 ||
		GetPlayerSkin(playerid)== 285 ||
		GetPlayerSkin(playerid)== 286 ||
		GetPlayerSkin(playerid)== 288) 
		{
			return 1;
		}
 	}
	return 0;
}

stock GetClosestPlayer(playerid)
{
	foreach(new targetid: Player)
	{
		if(targetid != playerid && GetDistanceBetweenPlayers(playerid, targetid) <= 2.0) return targetid;
	}
	return INVALID_PLAYER_ID;
}

stock CleanPlayerDamages(playerid)
{
	for(new y;y<10;y++)
	{
		pInjury[playerid][y][injury_id] = 0;
	}
}

stock CleanPlayerData(playerid)
{
	new Text3D:tmp_label = pInfo[playerid][player_label];
	new Text3D:tmp_label2 = pInfo[playerid][player_description_label];
	
	for(new z=0; e_players_info:z != e_players_info; z++)
    {
		pInfo[playerid][e_players_info:z] = 0;
    }
	
	for(new x=0; e_player_offer:x != e_player_offer; x++)
	{
		pOffer[playerid][e_player_offer:x] = 0;
	}
	
	for(new y;y<13;y++)
	{
		pWeapon[playerid][y][pw_itemid] = -1;
		pWeapon[playerid][y][pw_id] = -1;
		pWeapon[playerid][y][pw_ammo] = -1;
		pWeapon[playerid][y][pw_object_index] = -1;
	}

	CleanPlayerDamages(playerid);
	
	pInfo[playerid][player_gym_carnet] = 10;
	pInfo[playerid][player_label] = tmp_label;
	pInfo[playerid][player_description_label] = tmp_label2;
	pInfo[playerid][player_entering_vehicle] = -1;
	pInfo[playerid][player_occupied_vehicle] = -1;
	pInfo[playerid][player_vehicle_target] = -1;
	pInfo[playerid][player_last_pm_playerid] = INVALID_PLAYER_ID;
	pInfo[playerid][player_last_group_slot_chat] = -1;
	pInfo[playerid][player_duty_gid] = -1;
	pInfo[playerid][player_phone_caller] = INVALID_PLAYER_ID;
	pInfo[playerid][player_phone_receiver] = INVALID_PLAYER_ID;
	pInfo[playerid][player_phone_object_index] = -1;
	pInfo[playerid][player_spec] = INVALID_PLAYER_ID;
	pInfo[playerid][player_taxi_veh] = INVALID_VEHICLE_ID;
	pInfo[playerid][player_interview] = -1;
	pInfo[playerid][player_edited_object] = -1;
	pInfo[playerid][player_robbery] = -1;
	pInfo[playerid][player_jbl_object] = INVALID_STREAMER_ID;
	pInfo[playerid][player_roulette_object] = INVALID_STREAMER_ID;
	pInfo[playerid][player_roulette_selector] = INVALID_STREAMER_ID;
	pInfo[playerid][player_taxi_passenger] = INVALID_PLAYER_ID;

	pInfo[playerid][player_spraying_car] = INVALID_VEHICLE_ID;
	pInfo[playerid][player_repair_car] = INVALID_VEHICLE_ID;
	pInfo[playerid][player_montage_car] = INVALID_VEHICLE_ID;
	pInfo[playerid][player_bomb_car] = INVALID_VEHICLE_ID;
	pInfo[playerid][player_phone_model] = 330;
	pInfo[playerid][player_bus_object] = INVALID_STREAMER_ID;
	pInfo[playerid][player_vattach_object] = INVALID_STREAMER_ID;
	pInfo[playerid][player_vattach_vehicle] = INVALID_VEHICLE_ID;

	for(new i;i<5;i++) CleanPlayerGroup(playerid, i, false);
}

stock CleanPlayerGroup(playerid, slot, bool:do_reload = true)
{
	for(new z=0; e_player_groups:z != e_player_groups; z++)
    {
		pGroup[playerid][slot][e_player_groups:z] = 0;
    }
	
	pGroup[playerid][slot][pg_id] = -1;
	pGroup[playerid][slot][pg_rank_skin] = -1;
	
	if( do_reload )
	{
		ReloadPlayerGroupData(playerid);
	}
}

stock ReloadPlayerGroupData(playerid)
{
	for(new i;i<4;i++)
	{
		if( pGroup[playerid][i][pg_id] == -1 )
		{
			if( pGroup[playerid][i+1][pg_id] != -1 )
			{
				pGroup[playerid][i][pg_id] = pGroup[playerid][i+1][pg_id];
				
				pGroup[playerid][i][pg_rank_skin] = pGroup[playerid][i+1][pg_rank_skin];
				pGroup[playerid][i][pg_rank_payment] = pGroup[playerid][i+1][pg_rank_payment];
				pGroup[playerid][i][pg_rank_perm] = pGroup[playerid][i+1][pg_rank_perm];
				pGroup[playerid][i][pg_duty_start] = pGroup[playerid][i+1][pg_duty_start];
				pGroup[playerid][i][pg_duty] = pGroup[playerid][i+1][pg_duty];
				pGroup[playerid][i][pg_duty_time] = pGroup[playerid][i+1][pg_duty_time];
				pGroup[playerid][i][pg_payday_count] = pGroup[playerid][i+1][pg_payday_count];
				
				strcopy(pGroup[playerid][i][pg_rank_title], pGroup[playerid][i+1][pg_rank_title], 32);
				
				CleanPlayerGroup(playerid, i+1, false);
			}
		}
	}
}

stock HidePlayerDialog(playerid)
{
	ShowPlayerDialog(playerid,-1,0,"","","","");
}

stock SellDrug(playerid, price, itemid)
{
	new a_id = pInfo[playerid][player_area];
	new taxed = false;
	new tax_gid;

	if(Area[a_id][area_owner_type] == AREA_OWNER_TYPE_GROUP)
	{
		new gid = GetGroupByUid(Area[a_id][area_owner]);
		if(gid != -1)
		{
			if(Group[gid][group_type] == GROUP_TYPE_GANG)
			{
				if(GetPlayerGroupSlot(playerid, gid) == -1)
				{
					taxed = true;
					tax_gid = gid;
				}
			}
		}
	}

	if(PlayerItem[playerid][itemid][player_item_value2] == 1)
	{
		DeleteItem(itemid, true, playerid);

		if(taxed)
		{
			new tax_price = floatround(price *0.05);
			GiveGroupMoney(tax_gid, tax_price);
			price = price-tax_price;
			GivePlayerMoney(playerid, price);

			new str[64];
			format(str, sizeof(str), "~w~Udalo ci sie sprzedac dzialke towaru. Otrzymujesz ~g~$%d~w~.~n~Z racji tego, ze handlujesz na strefie nalezacej do organizacji, odprowadzono dla nich ~g~$%d~w~.", price, tax_price);
			SendPlayerInformation(playerid, str, 5000);
		}
		else 
		{
			GivePlayerMoney(playerid, price);
			
			new str[64];
			format(str, sizeof(str), "~w~Udalo ci sie sprzedac dzialke towaru. Otrzymujesz ~g~$%d~w~.", price);
			SendPlayerInformation(playerid, str, 5000);
		}

		RemovePlayerStatus(playerid, PLAYER_STATUS_DEALING);
		pInfo[playerid][player_dialog_tmp4] = 0;
		pInfo[playerid][player_dialog_tmp5] = -1;
		ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4, 0, 0, 0, 0, 0, 0);
		ProxMessage(playerid, "Pomiêdzy nim, a klientem dosz³o do wymiany towaru.", PROX_DO);
		SetPlayerChatBubble(playerid, sprintf("* %s poda³ jakiœ przedmiot swojemu rozmówcy.", pInfo[playerid][player_name]), 0xBAA9CDFF, 7.0, 6000);
	}
	else if(PlayerItem[playerid][itemid][player_item_value2] > 1)
	{
		PlayerItem[playerid][itemid][player_item_value2]--;
		PlayerItem[playerid][itemid][player_item_weight] = PlayerItem[playerid][itemid][player_item_value2];

		pInfo[playerid][player_capacity] += PlayerItem[playerid][itemid][player_item_weight];
		mysql_query(mySQLconnection, sprintf("UPDATE ipb_items SET item_value2 = %d, item_weight = %d WHERE item_uid = %d AND item_owner = %d", PlayerItem[playerid][itemid][player_item_value2], PlayerItem[playerid][itemid][player_item_value2], PlayerItem[playerid][itemid][player_item_uid], pInfo[playerid][player_id]));
		
		if(cache_affected_rows())
		{
			if(taxed)
			{
				new tax_price = floatround(price *0.05);
				GiveGroupMoney(tax_gid, tax_price);
				price = price-tax_price;
				GivePlayerMoney(playerid, price);

				new str[64];
				format(str, sizeof(str), "~w~Udalo ci sie sprzedac dzialke towaru. Otrzymujesz ~g~$%d~w~.~n~Z racji tego, ze handlujesz na strefie nalezacej do organizacji, odprowadzono dla nich ~g~$%d~w~.", price, tax_price);
				SendPlayerInformation(playerid, str, 5000);
			}
			else 
			{
				GivePlayerMoney(playerid, price);
				
				new str[64];
				format(str, sizeof(str), "~w~Udalo ci sie sprzedac dzialke towaru. Otrzymujesz ~g~$%d~w~.", price);
				SendPlayerInformation(playerid, str, 5000);
			}

			RemovePlayerStatus(playerid, PLAYER_STATUS_DEALING);
			ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4, 0, 0, 0, 0, 0, 0);
			ProxMessage(playerid, "Pomiêdzy nim, a klientem dosz³o do wymiany towaru.", PROX_DO);
			SetPlayerChatBubble(playerid, sprintf("* %s poda³ jakiœ przedmiot swojemu rozmówcy.", pInfo[playerid][player_name]), 0xBAA9CDFF, 7.0, 6000);
			pInfo[playerid][player_dialog_tmp5] = -1;
			pInfo[playerid][player_dialog_tmp4] = 0;
		}
	}
	return 1;
}

stock UpdatePlayerBWTextdraw(playerid)
{
	new bstring[50], Float:TimeInMin = floatdiv((pInfo[playerid][player_bw_end_time] - gettime()), 60);
	format(bstring, sizeof(bstring), "~w~koniec ~y~bw~w~: ~y~%d ~w~min.", floatround(TimeInMin, floatround_ceil));	
	GameTextForPlayer(playerid,  bstring, 5000, 1);
}

task PlayerLoop[1000]()
{
	if(DeletePenalty != -1)
    {
        DeletePenalty--;
	  	if(DeletePenalty < 1)
 		{
   			TextDrawHideForAll(TextPenalty);
		   	DeletePenalty = -1;
	  	}
	}

	foreach(new playerid : Player)
	{
		/*if(pInfo[playerid][player_update_tick] > 0 && pInfo[playerid][player_synced] == false)
		{
			KickAc(playerid, -1, "Desynchronizacja");
			continue;
		}*/

		if(IsPlayerPBot(playerid)) continue;

		if(pInfo[playerid][player_race_phase] == 3)
		{
			switch(pInfo[playerid][player_race_count])
			{
				case 1:
				{
				    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
				    GameTextForPlayer(playerid, "~g~START", 5000, 3);
		   			TogglePlayerControllable(playerid, 1);
		   			pInfo[playerid][player_race_count]--;
				}
				case 2:
				{
				    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
				    GameTextForPlayer(playerid, "~w~1", 5000, 3);
				    pInfo[playerid][player_race_count]--;
				}
				case 3:
				{
				    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
				    GameTextForPlayer(playerid, "~y~2", 5000, 3);
				    pInfo[playerid][player_race_count]--;
				}
				case 4:
				{
				    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
					GameTextForPlayer(playerid, "~r~3!", 5000, 3);
				    pInfo[playerid][player_race_count]--;
				}
			}
		}

		if( pInfo[playerid][player_logged] )
		{
			if(pInfo[playerid][player_last_bullet])
			{
				pInfo[playerid][player_last_bullet] = false;
			}

			if( gettime() - pInfo[playerid][player_last_activity] >= AFK_TIME && !pInfo[playerid][player_afk] )
			{
				AddPlayerStatus(playerid, PLAYER_STATUS_AFK);
				pInfo[playerid][player_afk] = true;
			}

			if(GetPlayerVirtualWorld(playerid) == 0)
			{
				if(GetPlayerAnimationIndex(playerid) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
				{
					new animlib[32];
			        new animname[32];
			        GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
			       	if(!strcmp(animlib, "PED", true)) 
			       	{
			       		if( strfind(animname, "run", true) != -1)
			       		{
			       			if(!CA_IsPlayerOnSurface(playerid) && GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID && pInfo[playerid][player_hours] < 1 && pGlobal[playerid][glo_score] < 100)
			       			{
			       				pInfo[playerid][player_airbrk_warns]++;
			       			}
			       		}
			       	}

			       	/*if(!strcmp(animlib, "SWIM", true)) 
			       	{
			       		if(!CA_IsPlayerInWater(playerid))
			       		{
			       			AdminJail(playerid, -1, "Flyhack", 30);
			       		}
			       	}*/
				}

				if(pInfo[playerid][player_airbrk_warns] == 4 && pGlobal[playerid][glo_perm] == 0 && GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID)
				{
					AdminJail(playerid, -1, "Airbreak onfoot", 30);
					pInfo[playerid][player_airbrk_warns] = 0;
				}

				/*new zone[MAX_ZONE_NAME];
				GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
				if(strlen(zone) > 2)
				{
					PlayerTextDrawSetString(playerid, ZoneName[playerid], zone);
				}*/
			}

			if(pInfo[playerid][player_info_td_id] > 0)
			{
				pInfo[playerid][player_info_td_id]--;

				if(pInfo[playerid][player_info_td_id] == 0)
				{
					TextDrawHideForPlayer(playerid, Tutorial[playerid]);
					pInfo[playerid][player_info_td_id] = 0;
				}
			}

			if( pInfo[playerid][player_bus_ride] && pInfo[playerid][player_bus_time] > 0)
			{
				pInfo[playerid][player_bus_time]--;
				TogglePlayerControllable(playerid, false);
				
				if(pInfo[playerid][player_bus_time] == 0)
				{
					new Float:x, Float:y, Float:z;
					GetDynamicObjectPos(pInfo[playerid][player_bus_destination], x, y, z);

					SetPlayerPos(playerid, x, y, z);
					SetCameraBehindPlayer(playerid);
					TogglePlayerControllable(playerid, true);
					PlayerPlaySound(playerid, 1098, 0.0, 0.0, 0.0);
					PlayerPlaySound(playerid, 1147, 0.0, 0.0, 0.0);
					pInfo[playerid][player_bus_ride] = false;
				}
			}

			if(GetPlayerTargetDynamicActor(playerid) != INVALID_STREAMER_ID && GetPlayerWeapon(playerid) > 20)
			{
				new actorid = GetPlayerTargetDynamicActor(playerid);

				if(Actor[actorid][actor_type] == ACTOR_TYPE_ROBBERY)
				{
					new r_id = GetRobberyByUid(Actor[actorid][actor_owner]);

					if(r_id != -1)
					{
						if(pInfo[playerid][player_robbery] == r_id && !Actor[actorid][actor_aimed])
						{
							ApplyDynamicActorAnimation(actorid, "ROB_BANK", "SHP_HandsUp_Scr", 4.0, 0, 1, 1, 1, 1);
							Robbery[r_id][robbery_aimed_actors]++;
							Actor[actorid][actor_aimed] = true;
						}
					}
				}
			}

			if( pInfo[playerid][player_door_text] > 0)
			{
				pInfo[playerid][player_door_text]--;
				if(pInfo[playerid][player_door_text] == 0)
				{
					HidePlayerDoorTextdraw(playerid);
					pInfo[playerid][player_door_text] = 0;
				}
			}

			if( pInfo[playerid][player_freeze] > 0)
			{
				pInfo[playerid][player_freeze]--;
				if(pInfo[playerid][player_freeze] == 0)
				{
					TogglePlayerControllable(playerid, 1);
					pInfo[playerid][player_freeze] = 0;
				}
			}

			if(pInfo[playerid][player_commands] >= 20)
			{
				BanAc(playerid, -1, 30, "Mass spam");
				continue;
			}

			pInfo[playerid][player_commands] = 0;

			if(GetPlayerSurfingVehicleID(playerid) != INVALID_VEHICLE_ID)
			{
				new surf = GetPlayerSurfingVehicleID(playerid);
				if(Vehicle[surf][vehicle_model] == 481 || Vehicle[surf][vehicle_model] == 509 || Vehicle[surf][vehicle_model] == 510)
				{
					if(pInfo[playerid][player_admin_duty] == false)
					{
						new Float:PPos[3];
						GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
    					SetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]+4);
    					SendGuiInformation(playerid, "Informacja", "Je¿d¿enie na kierownicy roweru jest zakazane.");
					}
				}
			}

			if(!pInfo[playerid][player_drunk] && GetPlayerDrunkLevel(playerid) >= 5000)
			{
				AddPlayerStatus(playerid, PLAYER_STATUS_DRUNK);
				pInfo[playerid][player_drunk] = true;
			}

			if(pInfo[playerid][player_gps] > 0)
			{
				foreach(new police: Player)
				{
					if(pInfo[police][player_gps] > 0)
					{
						new Float:x, Float:y, Float:z;
						GetPlayerPos(police, x, y, z);
						SetPlayerMapIcon(playerid, police, x, y, z, 30, 0);
					}
				}
			}

			if(pInfo[playerid][player_rob_time] > 1)
			{
				pInfo[playerid][player_rob_time]--;

				switch(pInfo[playerid][player_rob_stage])
				{
					case STAGE_CRACKING:
					{
						TextDrawSetString(DoorInfo[playerid], sprintf("Wlamywanie do ~y~sejfu~w~ w toku.~n~Pozostaly czas: ~y~%ds~n~Wcisnij ~r~SPACJE~w~ aby przerwac.", pInfo[playerid][player_rob_time]));
					}
					case STAGE_OPENING:
					{
						TextDrawSetString(DoorInfo[playerid], sprintf("Otwieranie ~r~sejfu~w~ w toku.~n~Pozostaly czas: ~y~%ds~n~Wcisnij ~r~SPACJE~w~ aby przerwac.", pInfo[playerid][player_rob_time]));
					}
					case STAGE_ROBBING:
					{
						TextDrawSetString(DoorInfo[playerid], sprintf("Pobieranie gotowki z ~g~sejfu~w~ w toku.~n~Pozostaly czas: ~y~%ds~n~Wcisnij ~r~SPACJE~w~ aby przerwac.", pInfo[playerid][player_rob_time]));
					}
					case STAGE_DOOR:
					{
						TextDrawSetString(DoorInfo[playerid], sprintf("Otwieranie ~r~drzwi~w~ w toku.~n~Pozostaly czas: ~y~%ds~n~Wcisnij ~r~SPACJE~w~ aby przerwac.", pInfo[playerid][player_rob_time]));
					}
					case STAGE_PLANTING:
					{
						TextDrawSetString(DoorInfo[playerid], sprintf("Podkladanie ~r~bomby~w~ w toku.~n~Pozostaly czas: ~y~%ds~n~Wcisnij ~r~SPACJE~w~ aby przerwac.", pInfo[playerid][player_rob_time]));
					}
					case STAGE_CASH_REG:
					{
						TextDrawSetString(DoorInfo[playerid], sprintf("Otwieranie ~r~kasy~w~ w toku.~n~Pozostaly czas: ~y~%ds~n~Wcisnij ~r~SPACJE~w~ aby przerwac.", pInfo[playerid][player_rob_time]));
					}
				}
			}

			if(pInfo[playerid][player_rob_time] == 1)
			{
				switch(pInfo[playerid][player_rob_stage])
				{
					case STAGE_CRACKING:
					{
						new Float:x, Float:y, Float:z;
						pInfo[playerid][player_rob_time] = 4;
						pInfo[playerid][player_rob_stage] = STAGE_OPENING;
						ApplyAnimation(playerid, "ROB_BANK", "CAT_Safe_Open", 4.0, 0, 0, 0, 0, 0, 1);
						PlayerPlaySound(playerid, 21001, 0, 0, 0);

						GetPlayerPos(playerid, x, y, z);

						new d_id = GetDoorByUid(Robbery[pInfo[playerid][player_robbery]][robbery_place]);
						if(!Robbery[pInfo[playerid][player_robbery]][robbery_notification])
						{
							if(d_id != -1 ) SendRobberyMessage(pInfo[playerid][player_robbery], d_id);
						}

						foreach(new p: Player)
						{
							if(GetPlayerVirtualWorld(p) == GetPlayerVirtualWorld(playerid))
							{
								PlayerPlaySound(p, 14800, x, y, z+2);
							}
						}
					}
					case STAGE_OPENING:
					{
						pInfo[playerid][player_rob_time] = 60;
						pInfo[playerid][player_rob_stage] = STAGE_ROBBING;
						ApplyAnimation(playerid, "ROB_BANK", "CAT_Safe_Rob", 4.0, 1, 0, 0, 0, 0, 1);
						PlayerPlaySound(playerid, 25602, 0, 0, 0);
						
						new g_id = GetClosestObjectType(playerid, OBJECT_SAFE_DOOR);
					    if(g_id != INVALID_STREAMER_ID)
					    {
					    	MoveDynamicObject(g_id, Object[g_id][object_gate_pos][0], Object[g_id][object_gate_pos][1], Object[g_id][object_gate_pos][2], 2.0, Object[g_id][object_gate_pos][3], Object[g_id][object_gate_pos][4], Object[g_id][object_gate_pos][5]);
					    }

					    cmd_ame(playerid, "otworzy³ drzwi sejfu.");
					}
					case STAGE_ROBBING:
					{
						new safe_cash = 2550+random(3250);

						Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_ROB_CASH, 11745, safe_cash, Robbery[pInfo[playerid][player_robbery]][robbery_place], "£up z napadu");
						GameTextForPlayer(playerid, sprintf("~w~Skradziono ~g~~h~~h~$%d", safe_cash), 5000, 1);
						PlayerPlaySound(playerid, 30803, 0, 0, 0);
						pInfo[playerid][player_rob_time] = 0;
						pInfo[playerid][player_rob_stage] = 0;
						TogglePlayerControllable(playerid, 1);
						ClearAnimations(playerid);
						TextDrawHideForPlayer(playerid, DoorInfo[playerid]);

						new g_id = GetClosestObjectType(playerid, OBJECT_OPEN_SAFE);
					    if(g_id != INVALID_STREAMER_ID) Object[g_id][object_robbed] = true;
					}

					case STAGE_PLANTING:
					{
						new safe_door = GetClosestObjectType(playerid, OBJECT_SAFE_DOOR);
					    if(safe_door != INVALID_STREAMER_ID)
					    {
					    	new Float:x, Float:y, Float:z;
					    	pInfo[playerid][player_rob_time] = 0;
					    	pInfo[playerid][player_rob_stage] = 0;
					    	TogglePlayerControllable(playerid, 1);
					    	ClearAnimations(playerid);
					    	TextDrawHideForPlayer(playerid, DoorInfo[playerid]);
					    	defer ExplodeObject[10000](safe_door);
						    GameTextForPlayer(playerid, "~w~Wybuch za ~r~~h~10 ~w~sekund", 4000, 1);
						    GetPlayerPos(playerid, x, y, z);
						    
						    new g_id = GetClosestObjectType(playerid, OBJECT_OPEN_SAFE);
					    	if(g_id != INVALID_STREAMER_ID) Object[g_id][object_robbed] = true;

						    new d_id = GetDoorByUid(Robbery[pInfo[playerid][player_robbery]][robbery_place]);
							if(!Robbery[pInfo[playerid][player_robbery]][robbery_notification])
							{
								if(d_id != -1 ) SendRobberyMessage(pInfo[playerid][player_robbery], d_id);
							}

							foreach(new p: Player)
							{
								if(GetPlayerVirtualWorld(p) == GetPlayerVirtualWorld(playerid))
								{
									PlayerPlaySound(p, 14800, x, y, z+2);
								}
							}
						}
					}

					case STAGE_CASH_REG:
					{
						new scash = 950+random(1000);
						new safe = GetClosestObjectType(playerid, OBJECT_CASH_REG);
					    if(safe != INVALID_STREAMER_ID)
					    {
					    	Object[safe][object_robbed] = true;
					    	Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_ROB_CASH, 11745, scash, Robbery[pInfo[playerid][player_robbery]][robbery_place], "Torba z ³upem");
					    }

					    pInfo[playerid][player_rob_time] = 0;
				    	pInfo[playerid][player_rob_stage] = 0;
				    	TogglePlayerControllable(playerid, 1);
				    	ClearAnimations(playerid);
				    	TextDrawHideForPlayer(playerid, DoorInfo[playerid]);
					    GameTextForPlayer(playerid, sprintf("~w~Skradziono ~g~~h~~h~$%d", scash), 5000, 1);
					}

					case STAGE_DOOR:
					{
						new g_id = GetClosestObjectType(playerid, OBJECT_ROB_DOORS);
						if(g_id == INVALID_STREAMER_ID) g_id = GetClosestObjectType(playerid, OBJECT_BANK_VAULT);
						if(g_id != INVALID_STREAMER_ID)
						{
							MoveDynamicObject(g_id, Object[g_id][object_gate_pos][0], Object[g_id][object_gate_pos][1], Object[g_id][object_gate_pos][2], 2.0, Object[g_id][object_gate_pos][3], Object[g_id][object_gate_pos][4], Object[g_id][object_gate_pos][5]);
							Object[g_id][object_gate_opened] = true;
						}

						cmd_ame(playerid, "otworzy³ drzwi pancerne.");

						pInfo[playerid][player_rob_time] = 0;
						pInfo[playerid][player_rob_stage] = 0;
						TogglePlayerControllable(playerid, 1);
						ClearAnimations(playerid);
						TextDrawHideForPlayer(playerid, DoorInfo[playerid]);
					}
				}
			}

			if(pInfo[playerid][player_planting] > 0 && IsPlayerInDynamicArea(playerid, pInfo[playerid][player_planting_area]))
			{
				new vid = GetVehicleByUid(pInfo[playerid][player_planting_vehicle]);
				new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_SEED);		
				new model;	
				new owner_type = OBJECT_OWNER_TYPE_AREA;
				new owner = Area[pInfo[playerid][player_planting_area]][area_uid];
				new harvest_time = gettime()+24*3600;

				if(IsValidVehicle(vid) && itemid != -1)
				{
					pInfo[playerid][player_planting] --;
					TextDrawSetString(Tutorial[playerid], sprintf("~w~Trwa proces sadzenia roslin.~n~Pozostaly czas: ~y~%ds~n~~w~Pozostale nasiona: ~y~%d", pInfo[playerid][player_planting], pInfo[playerid][player_planting_seeds]));
					TextDrawShowForPlayer(playerid, Tutorial[playerid]);

					if(pInfo[playerid][player_planting] % 15 == 0 && pInfo[playerid][player_planting_seeds] > 0)
					{
						pInfo[playerid][player_planting_seeds] --;
						new Float:x, Float:y, Float:z;
						GetVehiclePos(vid, x, y, z);

						TextDrawHideForPlayer(playerid, Tutorial[playerid]);
						if(PlayerItem[playerid][itemid][player_item_value2] > 1)
						{
							PlayerItem[playerid][itemid][player_item_value2] --;
							mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_items SET item_value2 = %d WHERE item_uid = %d", PlayerItem[playerid][itemid][player_item_value2], PlayerItem[playerid][itemid][player_item_uid]));

							if(pInfo[playerid][player_planting_seeds] < 1) PlayerItem[playerid][itemid][player_item_used] = false;
						}
						else
						{
							DeleteItem(itemid, true, playerid);
						}
						switch(pInfo[playerid][player_planting_type])
						{
							case SEED_TYPE_TOBBACO:
							{
								model = OBJECT_TOBACCO;
								mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz, object_date) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f, %d)", OBJECT_TYPE_PLANT, owner_type, owner, model, GetPlayerVirtualWorld(playerid), x, y, z, harvest_time));
								new uid = cache_insert_id();
								LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
							}
							case SEED_TYPE_WEED:
							{
								model = OBJECT_WEED;
								mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz, object_date) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f, %d)", OBJECT_TYPE_PLANT, owner_type, owner, model, GetPlayerVirtualWorld(playerid), x, y, z, harvest_time));
								new uid = cache_insert_id();
								LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
							}
							case SEED_TYPE_POTATOS:
							{
								model = OBJECT_POTATOS;
								mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz, object_date) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f, %d)", OBJECT_TYPE_PLANT, owner_type, owner, model, GetPlayerVirtualWorld(playerid), x, y, z, harvest_time));
								new uid = cache_insert_id();
								LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
							}
							case SEED_TYPE_OPIUM:
							{
								model = OBJECT_OPIUM;
								mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz, object_date) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f, %d)", OBJECT_TYPE_PLANT, owner_type, owner, model, GetPlayerVirtualWorld(playerid), x, y, z, harvest_time));
								new uid = cache_insert_id();
								LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
							}
							case SEED_TYPE_VEGGIES:
							{
								model = OBJECT_VEGGIES;
								mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz, object_date) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f, %d)", OBJECT_TYPE_PLANT, owner_type, owner, model, GetPlayerVirtualWorld(playerid), x, y, z, harvest_time));
								new uid = cache_insert_id();
								LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
							}
						}
					}
				}
				else if(GetPlayerWeapon(playerid) == 6 && itemid != -1)
				{
					pInfo[playerid][player_planting] --;
					TextDrawSetString(Tutorial[playerid], sprintf("~w~Trwa proces sadzenia roslin.~n~Pozostaly czas: ~y~%ds", pInfo[playerid][player_planting]));
					TextDrawShowForPlayer(playerid, Tutorial[playerid]);

					new Float:x, Float:y, Float:z;
					GetPlayerPos(playerid, x, y, z);
					
					if(pInfo[playerid][player_planting] < 1)
					{
						TextDrawHideForPlayer(playerid, Tutorial[playerid]);
						switch(pInfo[playerid][player_planting_type])
						{
							case SEED_TYPE_TOBBACO:
							{
								model = OBJECT_TOBACCO;
								mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz, object_date) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f, %d)", OBJECT_TYPE_PLANT, owner_type, owner, model, GetPlayerVirtualWorld(playerid), x, y, z, harvest_time));
								new uid = cache_insert_id();
								LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
							}
							case SEED_TYPE_WEED:
							{
								model = OBJECT_WEED;
								mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz, object_date) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f, %d)", OBJECT_TYPE_PLANT, owner_type, owner, model, GetPlayerVirtualWorld(playerid), x, y, z, harvest_time));
								new uid = cache_insert_id();
								LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
							}
							case SEED_TYPE_POTATOS:
							{
								model = OBJECT_POTATOS;
								mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz, object_date) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f, %d)", OBJECT_TYPE_PLANT, owner_type, owner, model, GetPlayerVirtualWorld(playerid), x, y, z, harvest_time));
								new uid = cache_insert_id();
								LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
							}
							case SEED_TYPE_OPIUM:
							{
								model = OBJECT_OPIUM;
								mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz, object_date) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f, %d)", OBJECT_TYPE_PLANT, owner_type, owner, model, GetPlayerVirtualWorld(playerid), x, y, z, harvest_time));
								new uid = cache_insert_id();
								LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
							}
							case SEED_TYPE_VEGGIES:
							{
								model = OBJECT_VEGGIES;
								mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz, object_date) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f, %d)", OBJECT_TYPE_PLANT, owner_type, owner, model, GetPlayerVirtualWorld(playerid), x, y, z, harvest_time));
								new uid = cache_insert_id();
								LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
							}
						}

						if(PlayerItem[playerid][itemid][player_item_value2] > 1)
						{
							PlayerItem[playerid][itemid][player_item_value2] --;
							mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_items SET item_value2 = %d WHERE item_uid = %d", PlayerItem[playerid][itemid][player_item_value2], PlayerItem[playerid][itemid][player_item_uid]));
						}
						else
						{
							DeleteItem(itemid, true, playerid);
						}
						
						ClearAnimations(playerid, 1);
						new skind = GetClientSkin(playerid);
						SetPlayerSkin(playerid, skind);
					}
				}
			}

			if(pInfo[playerid][player_production] > 0 && IsValidDynamicObject(pInfo[playerid][player_production_object]) && GetPlayerVirtualWorld(playerid) == Object[pInfo[playerid][player_production_object]][object_vw])
			{
				new Float:x, Float:y, Float:z;
				GetDynamicObjectPos(pInfo[playerid][player_production_object], x, y, z);

				if(IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z))
				{
					pInfo[playerid][player_production] --;

					if(!HasPlayerProductionClothes(playerid) && pInfo[playerid][player_health] > 20) SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health]) -1);

					switch(pInfo[playerid][player_production_type])
					{
						case PRODUCTION_TYPE_METH:
						{
							TextDrawSetString(Tutorial[playerid], sprintf("~w~Trwa proces produkcji metaamfetaminy.~n~Pozostaly czas: ~y~%ds", pInfo[playerid][player_production]));
							TextDrawShowForPlayer(playerid, Tutorial[playerid]);

							if(pInfo[playerid][player_production] < 1)
							{
								new rand_amount = 8+random(3);
								SendGuiInformation(playerid, "Informacja", sprintf("Proces tworzenia narkotyku zosta³ zakoñczony.\nUda³o ci siê wyprodukowaæ %d gram.", rand_amount));
								Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_DRUG, 1575, DRUG_TYPE_METH, rand_amount, "Metaamfetamina");
								TextDrawHideForPlayer(playerid, Tutorial[playerid]);
								pInfo[playerid][player_production] = false;
							}
						}
						case PRODUCTION_TYPE_AMPH:
						{
							TextDrawSetString(Tutorial[playerid], sprintf("~w~Trwa proces produkcji amfetaminy.~n~Pozostaly czas: ~y~%ds", pInfo[playerid][player_production]));
							TextDrawShowForPlayer(playerid, Tutorial[playerid]);

							if(pInfo[playerid][player_production] < 1)
							{
								new rand_amount = 8+random(3);
								SendGuiInformation(playerid, "Informacja", sprintf("Proces tworzenia narkotyku zosta³ zakoñczony.\nUda³o ci siê wyprodukowaæ %d gram.", rand_amount));
								Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_DRUG, 1575, DRUG_TYPE_AMFA, rand_amount, "Amfetamina");
								TextDrawHideForPlayer(playerid, Tutorial[playerid]);
								pInfo[playerid][player_production] = false;
							}
						}
						case PRODUCTION_TYPE_CRACK:
						{
							TextDrawSetString(Tutorial[playerid], sprintf("~w~Trwa proces produkcji cracku.~n~Pozostaly czas: ~y~%ds", pInfo[playerid][player_production]));
							TextDrawShowForPlayer(playerid, Tutorial[playerid]);

							if(pInfo[playerid][player_production] < 1)
							{
								new rand_amount = 3 + random(1);
								SendGuiInformation(playerid, "Informacja", sprintf("Proces tworzenia narkotyku zosta³ zakoñczony.\nUda³o ci siê wyprodukowaæ %d gram.", rand_amount));
								Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_DRUG, 1575, DRUG_TYPE_CRACK, rand_amount, "Crack");
								TextDrawHideForPlayer(playerid, Tutorial[playerid]);
								pInfo[playerid][player_production] = false;
							}
						}
					}
				}
			}
			if(pInfo[playerid][player_dealing] > 0)
			{
				if(!pInfo[playerid][player_afk] && pInfo[playerid][player_bw] == 0 && GetPlayerVirtualWorld(playerid) == 0 && !IsPlayerInAnyVehicle(playerid))
				{
					pInfo[playerid][player_dealing] --;
					TextDrawSetString(Tutorial[playerid], sprintf("~w~Oczekiwanie na klienta.~n~Pozostaly czas: ~y~%ds", pInfo[playerid][player_dealing]));
					TextDrawShowForPlayer(playerid, Tutorial[playerid]);

					if(pInfo[playerid][player_dealing] < 1)
					{
						new type, itemid;
						itemid = pInfo[playerid][player_dialog_tmp4];
						type = PlayerItem[playerid][itemid][player_item_value1];
						new drug_price;

						switch(type)
						{
							case DRUG_TYPE_COCAINE:
							{
								drug_price = 250 + random(35);
							}
							case DRUG_TYPE_CRACK:
							{
								drug_price = 105 + random(15);
							}
							case DRUG_TYPE_HEROINE:
							{
								drug_price = 140 + random(35);
							}
							case DRUG_TYPE_AMFA:
							{
								drug_price = 120 + random(20);
							}
							case DRUG_TYPE_WEED:
							{
								drug_price = 75 + random(15);
							}
							case DRUG_TYPE_METH:
							{
								drug_price = 180 + random(20);
							}
							case DRUG_TYPE_EXTASY:
							{
								drug_price = 90 + random(15);
							}
							case DRUG_TYPE_HASH:
							{
								drug_price =  80 + random(15);
							}
							case DRUG_TYPE_LSD:
							{
								drug_price = 110+random(25);
							}
						}

						pInfo[playerid][player_dialog_tmp4] = 0;
						TextDrawHideForPlayer(playerid, Tutorial[playerid]);
						
						SellDrug(playerid, drug_price, itemid);
						pInfo[playerid][player_dealing] = false;
					}
				}
			}

			if(pInfo[playerid][player_bomb_car] != INVALID_VEHICLE_ID && pInfo[playerid][player_bomb_planting] != 0 )
			{
	  			new vehid = pInfo[playerid][player_bomb_car], Float:VehX, Float:VehY, Float:VehZ, str[64];
		    	GetVehiclePos(vehid, VehX, VehY, VehZ);
				if(IsPlayerInRangeOfPoint(playerid, 4.0, VehX, VehY, VehZ))
				{
	   				pInfo[playerid][player_bomb] --;

					format(str, sizeof(str), "~n~~n~~n~~n~~n~~n~~n~~g~Pozosta³o: ~w~%d sekund.", pInfo[playerid][player_bomb]);
					GameTextForPlayer(playerid, str, 1000, 3);

					if(pInfo[playerid][player_bomb] <= 0)
					{
					    SendGuiInformation(playerid, "Informacja", "Gratulacje, monta¿ ³adunku wybuchowego dobieg³ koñca!\nMo¿esz go teraz zdetonowaæ za pomoc¹ /ladunek detonuj!");
	  					pInfo[playerid][player_bomb] = 0;
	  					pInfo[playerid][player_bomb_planting] = 0;
					}
				}
			}

			if(pInfo[playerid][player_repair_car] != INVALID_VEHICLE_ID && pInfo[playerid][player_repairing] == 1)
			{
				new vehid = pInfo[playerid][player_repair_car], Float:VehX, Float:VehY, Float:VehZ;
				new string[64], str[32];
			    GetVehiclePos(vehid, VehX, VehY, VehZ);
			    if(IsPlayerInRangeOfPoint(playerid, 4.0, VehX, VehY, VehZ))
			    {
					if(!Vehicle[vehid][vehicle_engine] || IsVehicleBike(vehid))
					{
						format(str, sizeof(str), "Pojazd w trakcie naprawy (%ds)", pInfo[playerid][player_repair_time]);
						format(string, sizeof(string), "~w~Pozostalo: ~y~%d ~w~sekund do konca naprawy.", pInfo[playerid][player_repair_time]);

				        pInfo[playerid][player_repair_time] --;

				        UpdateDynamic3DTextLabelText(Vehicle[vehid][vehicle_state_label], COLOR_CAR_STATE, str);
				        TextDrawSetString(Tutorial[playerid], string);
				        TextDrawShowForPlayer(playerid, Tutorial[playerid]);

	  					if(pInfo[playerid][player_repair_time] <= 0)
	  					{
	  						new price = pInfo[playerid][player_fixprice];
	  						
	  					   	Vehicle[vehid][vehicle_damage][0] = 0;
	  					    Vehicle[vehid][vehicle_damage][1] = 0;
	  					    Vehicle[vehid][vehicle_damage][2] = 0;
	  					    Vehicle[vehid][vehicle_damage][3] = 0;

  					    	Vehicle[vehid][vehicle_health] = 1500.00;
  					    	SetVehicleHealth(vehid, 1500);
	  					    
	  					    Vehicle[vehid][vehicle_destroyed] = false;

	  					    UpdateVehicleDamageStatus(vehid, Vehicle[vehid][vehicle_damage][0], Vehicle[vehid][vehicle_damage][1], Vehicle[vehid][vehicle_damage][2], Vehicle[vehid][vehicle_damage][3]);

	  					    new visual_damage[32];
							format(visual_damage, sizeof(visual_damage), "%d %d %d %d", Vehicle[vehid][vehicle_damage][0], Vehicle[vehid][vehicle_damage][1], Vehicle[vehid][vehicle_damage][2], Vehicle[vehid][vehicle_damage][3]);
	  					    mysql_query(mySQLconnection, sprintf("UPDATE ipb_vehicles SET vehicle_health = '%f', vehicle_visual= '%s' WHERE vehicle_uid = %d", Vehicle[vehid][vehicle_health], visual_damage, Vehicle[vehid][vehicle_uid]));

	  					    SendGuiInformation(playerid,"Informacja", "Sukces! Naprawa pojazdu dobieg³a koñca!\nWszystkie uszkodzenia pojazdu zosta³y naprawione.");

	  					    new gid = pInfo[playerid][player_duty_gid];
	  					    if(gid != -1)
	  					    {
	  					    	if(Group[gid][group_type] == GROUP_TYPE_WORKSHOP)
	  					    	{
	  					    		if(price >= 20)
	  					    		{
	  					    			GiveGroupMoney(gid, price-20);
	  					    			GivePlayerMoney(playerid, 20);
	  					    		}
	  					    		else
	  					    		{
	  					    			GiveGroupMoney(gid, price);
	  					    		}
	  					    	}
	  					    }
	  					    else
	  					    {
	  					    	GivePlayerMoney(playerid, price);
	  					    }

							pInfo[playerid][player_repair_car] = INVALID_VEHICLE_ID;
							pInfo[playerid][player_repair_time] = 0;
							TextDrawHideForPlayer(playerid, Tutorial[playerid]);
							UpdateDynamic3DTextLabelText(Vehicle[vehid][vehicle_state_label], COLOR_CAR_STATE, "");
							pInfo[playerid][player_repairing]=0;
						}
					}
					else
					{
					    GameTextForPlayer(playerid, "~w~Silnik pojazdu musi byc ~y~zgaszony~w~!", 1000, 3);
					}
			    }
			}

			if(pInfo[playerid][player_montage_car] != INVALID_VEHICLE_ID && pInfo[playerid][player_tuning] == 2)
            {
                new vehid = pInfo[playerid][player_montage_car], Float:VehX, Float:VehY, Float:VehZ;
                new string[64], str[32];
                GetVehiclePos(vehid, VehX, VehY, VehZ);
                if(IsPlayerInRangeOfPoint(playerid, 4.0, VehX, VehY, VehZ))
                {
                    if(!Vehicle[vehid][vehicle_engine])
                    {
                        format(str, sizeof(str), "Trwa monta¿ komponentu (%ds)", pInfo[playerid][player_montage_time]);
                        format(string, sizeof(string), "~w~Pozostalo: ~y~%d ~w~sekund do konca montazu.", pInfo[playerid][player_montage_time]);
 
                        pInfo[playerid][player_montage_time] --;
 
                        UpdateDynamic3DTextLabelText(Vehicle[vehid][vehicle_state_label], COLOR_CAR_STATE, str);
                        TextDrawSetString(Tutorial[playerid], string);
                        TextDrawShowForPlayer(playerid, Tutorial[playerid]);
 
                        if(pInfo[playerid][player_montage_time] <= 0)
                        {
                            new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_ACCESS);
                            new compid = pInfo[playerid][player_montage_comp];
 
                            Vehicle[vehid][vehicle_accessories] += compid;
                           
                            mysql_query(mySQLconnection, sprintf("UPDATE ipb_vehicles SET vehicle_access = '%d' WHERE vehicle_uid = %d", Vehicle[vehid][vehicle_accessories], Vehicle[vehid][vehicle_uid]));
 
                            SendGuiInformation(playerid,"Informacja", "Sukces! Komponent zosta³ zamontowany w pojeŸdzie.");
 
                            pInfo[playerid][player_montage_car] = INVALID_VEHICLE_ID;
                            pInfo[playerid][player_montage_time] = 0;
 
                            DeleteItem(itemid, true, playerid);
 
                            TextDrawHideForPlayer(playerid, Tutorial[playerid]);
                            UpdateDynamic3DTextLabelText(Vehicle[vehid][vehicle_state_label], COLOR_CAR_STATE, "");
                            pInfo[playerid][player_tuning] = 0;
                        }
                    }
                    else
                    {
                        GameTextForPlayer(playerid, "~w~Silnik pojazdu musi byc ~y~zgaszony~w~!", 1000, 3);
                    }
                }
            }

			if(pInfo[playerid][player_montage_car] != INVALID_VEHICLE_ID && pInfo[playerid][player_tuning] == 1)
			{
				new vehid = pInfo[playerid][player_montage_car], Float:VehX, Float:VehY, Float:VehZ;
				new string[64], str[32];
			    GetVehiclePos(vehid, VehX, VehY, VehZ);
			    if(IsPlayerInRangeOfPoint(playerid, 4.0, VehX, VehY, VehZ))
			    {
					if(!Vehicle[vehid][vehicle_engine])
					{
						format(str, sizeof(str), "Pojazd w trakcie tuningu (%ds)", pInfo[playerid][player_montage_time]);
						format(string, sizeof(string), "~w~Pozostalo: ~y~%d ~w~sekund do konca montazu.", pInfo[playerid][player_montage_time]);

				        pInfo[playerid][player_montage_time] --;

				        UpdateDynamic3DTextLabelText(Vehicle[vehid][vehicle_state_label], COLOR_CAR_STATE, str);
				        TextDrawSetString(Tutorial[playerid], string);
				        TextDrawShowForPlayer(playerid, Tutorial[playerid]);

	  					if(pInfo[playerid][player_montage_time] <= 0)
	  					{
	  						new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_TUNING);
	  						new compid = pInfo[playerid][player_montage_comp];

	  						srp_AddVehicleComponent(vehid, compid);

	  						new comp0 = Vehicle[vehid][vehicle_component][0];
	  						new comp1 = Vehicle[vehid][vehicle_component][1];
	  						new comp2 = Vehicle[vehid][vehicle_component][2];
	  						new comp3 = Vehicle[vehid][vehicle_component][3];
	  						new comp4 = Vehicle[vehid][vehicle_component][4];
	  						new comp5 = Vehicle[vehid][vehicle_component][5];
	  						new comp6 = Vehicle[vehid][vehicle_component][6];
	  						new comp7 = Vehicle[vehid][vehicle_component][7];
	  						new comp8 = Vehicle[vehid][vehicle_component][8];
	  						new comp9 = Vehicle[vehid][vehicle_component][9];
	  						new comp10 = Vehicle[vehid][vehicle_component][10];
	  						new comp11 = Vehicle[vehid][vehicle_component][11];
	  						new comp12 = Vehicle[vehid][vehicle_component][12];
	  						new comp13 = Vehicle[vehid][vehicle_component][13];
	  						
	  					    new visual_tuning[128];
							format(visual_tuning, sizeof(visual_tuning), "%d %d %d %d %d %d %d %d %d %d %d %d %d %d", comp0, comp1, comp2, comp3, comp4, comp5, comp6, comp7,comp8, comp9, comp10, comp11, comp12, comp13);
	  					    mysql_query(mySQLconnection, sprintf("UPDATE ipb_vehicles SET vehicle_component = '%s' WHERE vehicle_uid = %d", visual_tuning, Vehicle[vehid][vehicle_uid]));

	  					    SendGuiInformation(playerid,"Informacja", "Sukces! Komponent zosta³ zamontowany w pojeŸdzie.");

							pInfo[playerid][player_montage_car] = INVALID_VEHICLE_ID;
							pInfo[playerid][player_montage_time] = 0;
							DeleteItem(itemid, true, playerid);
							TextDrawHideForPlayer(playerid, Tutorial[playerid]);
							UpdateDynamic3DTextLabelText(Vehicle[vehid][vehicle_state_label], COLOR_CAR_STATE, "");
							pInfo[playerid][player_tuning] = 0;
						}
					}
					else
					{
					    GameTextForPlayer(playerid, "~w~Silnik pojazdu musi byc ~y~zgaszony~w~!", 1000, 3);
					}
			    }
			}

			if(pInfo[playerid][player_spraying_car] != INVALID_VEHICLE_ID && pInfo[playerid][player_spraying] == 1)
			{
				new vehid = pInfo[playerid][player_spraying_car], Float:VehX, Float:VehY, Float:VehZ;
				new str[42];
			    GetVehiclePos(vehid, VehX, VehY, VehZ);
			    if(IsPlayerInRangeOfPoint(playerid, 4.0, VehX, VehY, VehZ))
			    {
					if(!Vehicle[vehid][vehicle_engine])
					{
						if(IsPlayerSprayingVehicle(playerid, vehid))
						{
							new spraytime = pInfo[playerid][player_spraying_time];
							format(str, sizeof(str), "Pojazd w trakcie lakierowania (%d%%)", spraytime);

							new tmp, ammo;
							GetPlayerWeaponData(playerid, 9, tmp, ammo);
							if(ammo != pInfo[playerid][player_last_spray])
							{
								pInfo[playerid][player_last_spray] = ammo;
						        pInfo[playerid][player_spraying_time] += 2;

						        UpdateDynamic3DTextLabelText(Vehicle[vehid][vehicle_state_label], COLOR_CAR_STATE, str);

			  					if(pInfo[playerid][player_spraying_time] >= 100)
			  					{
			  						new color1 = pInfo[playerid][player_spraying_color];
			  						new color2 = pInfo[playerid][player_spraying_color2];

			  						ChangeVehicleColor(vehid, color1, color2);

			  					    mysql_query(mySQLconnection, sprintf("UPDATE ipb_vehicles SET vehicle_color1 = '%d', vehicle_color2 = '%d' WHERE vehicle_uid = %d", color1, color2, Vehicle[vehid][vehicle_uid]));

			  					    SendGuiInformation(playerid,"Informacja", "Sukces! Pojazd zosta³ przemalowany.");

									pInfo[playerid][player_spraying_car] = INVALID_VEHICLE_ID;
									pInfo[playerid][player_spraying_time] = 0;

									UpdateDynamic3DTextLabelText(Vehicle[vehid][vehicle_state_label], COLOR_CAR_STATE, "");
									pInfo[playerid][player_spraying] = 0;
								}
							}
						}
					}
					else
					{
					    GameTextForPlayer(playerid, "~w~Silnik pojazdu musi byc ~y~zgaszony~w~!", 1000, 3);
					}
			    }
			}

			if(pInfo[playerid][player_spraying_car] != INVALID_VEHICLE_ID && pInfo[playerid][player_spraying] == 2)
			{
				new vehid = pInfo[playerid][player_spraying_car], Float:VehX, Float:VehY, Float:VehZ;
				new str[42];
			    GetVehiclePos(vehid, VehX, VehY, VehZ);
			    if(IsPlayerInRangeOfPoint(playerid, 4.0, VehX, VehY, VehZ))
			    {
					if(!Vehicle[vehid][vehicle_engine])
					{
						if(IsPlayerSprayingVehicle(playerid, vehid))
						{
							new spraytime = pInfo[playerid][player_spraying_time];
							format(str, sizeof(str), "Pojazd w trakcie malowania (%d%%)", spraytime);
							
					        pInfo[playerid][player_spraying_time] += 2;        	
					       
					        UpdateDynamic3DTextLabelText(Vehicle[vehid][vehicle_state_label], COLOR_CAR_STATE, str);

		  					if(pInfo[playerid][player_spraying_time] >= 100)
		  					{
		  						new color1 = pInfo[playerid][player_spraying_color];

		  						ChangeVehiclePaintjob(vehid, color1);

		  					    mysql_query(mySQLconnection, sprintf("UPDATE ipb_vehicles SET vehicle_paintjob = '%d' WHERE vehicle_uid = '%d'", color1, Vehicle[vehid][vehicle_uid]));

		  					    SendGuiInformation(playerid,"Informacja", "Sukces! Paintjob na³o¿ony.");

								pInfo[playerid][player_spraying_car] = INVALID_VEHICLE_ID;
								pInfo[playerid][player_spraying_time] = 0;

								UpdateDynamic3DTextLabelText(Vehicle[vehid][vehicle_state_label], COLOR_CAR_STATE, "");
								pInfo[playerid][player_spraying] = 0;
							}
						}
					}
					else
					{
					    GameTextForPlayer(playerid, "~w~Silnik pojazdu musi byc ~y~zgaszony~w~!", 1000, 3);
					}
			    }
			}
			
			if( pInfo[playerid][player_taken_damage] > 0 && gettime() - pInfo[playerid][player_taken_damage] >= 2 )
			{
				pInfo[playerid][player_taken_damage] = 0;
				UpdatePlayerLabel(playerid);
			}

			if( pInfo[playerid][player_roulette_timer] > 0)
			{
				pInfo[playerid][player_roulette_timer] -= 1;

				TextDrawHideForPlayer(playerid, RouletteGreen);
				TextDrawHideForPlayer(playerid, RouletteBlack);
				TextDrawHideForPlayer(playerid, RouletteRed);

				new random_number = random(37);
				new background_color = GetNumberColor(random_number);

				switch(background_color)
				{
					case ROULETTE_COLOR_GREEN: TextDrawShowForPlayer(playerid, RouletteGreen);
					case ROULETTE_COLOR_RED: TextDrawShowForPlayer(playerid, RouletteRed);
					case ROULETTE_COLOR_BLACK: TextDrawShowForPlayer(playerid, RouletteBlack);
				}

				PlayerTextDrawSetString(playerid, RouletteNumber[playerid], sprintf("%d", random_number));
				PlayerTextDrawShow(playerid, RouletteNumber[playerid]);

				if(pInfo[playerid][player_roulette_timer] == 1)
				{
					new Float:x, Float:y, Float:z;
					GetDynamicObjectPos(pInfo[playerid][player_roulette_object], x, y, z);
					PlayerPlaySound(playerid, 33403, x, y, z);
					
					CheckRouletteWinnings(playerid, pInfo[playerid][player_roulette_bet], random_number, pInfo[playerid][player_roulette_field]);

					//pInfo[playerid][player_roulette_object] = INVALID_STREAMER_ID;
					//pInfo[playerid][player_roulette_bet] = 0;
					//pInfo[playerid][player_roulette_field] = 0;

					//if(IsValidDynamicObject(pInfo[playerid][player_roulette_selector])) DestroyDynamicObject(pInfo[playerid][player_roulette_selector]);

					defer HideRouletteTextdraws[2000](playerid);

					//pInfo[playerid][player_roulette_timer] = 0;
				}
			}

			if( pInfo[playerid][player_flash] > 0)
			{
				pInfo[playerid][player_flash] -= 1;

				switch(pInfo[playerid][player_flash])
				{
					case 10: 
					{
						PlayerTextDrawColor(playerid, WhiteScreen[playerid], 0xFFFFFFCC);
						PlayerTextDrawBoxColor(playerid, WhiteScreen[playerid], 0xFFFFFFCC);
					}
					case 9:	
					{
						PlayerTextDrawColor(playerid, WhiteScreen[playerid], 0xFFFFFFBB);
						PlayerTextDrawBoxColor(playerid, WhiteScreen[playerid], 0xFFFFFFBB);
					}
					case 8: 
					{
						PlayerTextDrawColor(playerid, WhiteScreen[playerid], 0xFFFFFFAA);
						PlayerTextDrawBoxColor(playerid, WhiteScreen[playerid], 0xFFFFFFAA);
					}
					case 7: 
					{
						PlayerTextDrawColor(playerid, WhiteScreen[playerid], 0xFFFFFF99);
						PlayerTextDrawBoxColor(playerid, WhiteScreen[playerid], 0xFFFFFF99);
					}
					case 6: 
					{
						PlayerTextDrawColor(playerid, WhiteScreen[playerid], 0xFFFFFF88);
						PlayerTextDrawBoxColor(playerid, WhiteScreen[playerid], 0xFFFFFF88);
					}
					case 5: 
					{
						PlayerTextDrawColor(playerid, WhiteScreen[playerid], 0xFFFFFF77);
						PlayerTextDrawBoxColor(playerid, WhiteScreen[playerid], 0xFFFFFF77);
					}
					case 4:
					{
						PlayerTextDrawColor(playerid, WhiteScreen[playerid], 0xFFFFFF66);
						PlayerTextDrawBoxColor(playerid, WhiteScreen[playerid], 0xFFFFFF66);
					} 
					case 3: 
					{
						PlayerTextDrawColor(playerid, WhiteScreen[playerid], 0xFFFFFF55);
						PlayerTextDrawBoxColor(playerid, WhiteScreen[playerid], 0xFFFFFF55);
					}
					case 2: 
					{
						PlayerTextDrawColor(playerid, WhiteScreen[playerid], 0xFFFFFF33);
						PlayerTextDrawBoxColor(playerid, WhiteScreen[playerid], 0xFFFFFF33);
					}
					case 1:
					{
						PlayerTextDrawHide(playerid, WhiteScreen[playerid]);
						pInfo[playerid][player_flash] = 0;
						continue;
					}
				}

				PlayerTextDrawHide(playerid, WhiteScreen[playerid]);
				PlayerTextDrawShow(playerid, WhiteScreen[playerid]);
			}

			if(pInfo[playerid][player_fight_training])
			{
				new object_id = pInfo[playerid][player_gym_object];
				new Float:x, Float:y, Float:z;
				new anim_id = GetPlayerAnimationIndex(playerid);

				GetDynamicObjectPos(object_id, x, y, z);

				if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z) && object_id > 0)
				{
					new Keys,ud,lr;
		    		GetPlayerKeys(playerid,Keys,ud,lr);

		    		if(Keys == 144)
		    		{
		    			new fight_style = GetPlayerFightingStyle(playerid);

		    			switch(fight_style)
		    			{
		    				case FIGHT_STYLE_BOXING:
		    				{
		    					if(anim_id == 473 || anim_id == 474)
			    				{
			    					if(pInfo[playerid][player_fight_progress] >= 100)
			    					{
			    						pInfo[playerid][player_fight_style] = FIGHT_STYLE_BOXING;
			    						mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_fightstyle = %d WHERE char_uid = %d", FIGHT_STYLE_BOXING, pInfo[playerid][player_id]));
			    						SendClientMessage(playerid, COLOR_GOLD, "Gratulacje, trening zakoñczony. Nowy styl walki zosta³ dodany.");
			    						pInfo[playerid][player_gym_object] = 0;
			    						pInfo[playerid][player_fight_training] = false;
			    					}
			    					else
			    					{
			    						pInfo[playerid][player_fight_progress] += 2;
				    					TextDrawSetString(Tutorial[playerid], sprintf("Proces treningu: ~y~%d~w~%%", pInfo[playerid][player_fight_progress]));
				    					TextDrawShowForPlayer(playerid, Tutorial[playerid]);
			    					}
			    				}
		    				}
		    				case FIGHT_STYLE_KUNGFU:
		    				{
		    					if(anim_id == 483 || anim_id == 484)
		    					{
		    						if(pInfo[playerid][player_fight_progress] >= 100)
			    					{
			    						pInfo[playerid][player_fight_style] = FIGHT_STYLE_KUNGFU;
			    						mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_fightstyle = %d WHERE char_uid = %d", FIGHT_STYLE_KUNGFU, pInfo[playerid][player_id]));
			    						SendClientMessage(playerid, COLOR_GOLD, "Gratulacje, trening zakoñczony. Nowy styl walki zosta³ dodany.");
			    						pInfo[playerid][player_gym_object] = 0;
			    						pInfo[playerid][player_fight_training] = false;
			    					}
			    					else
			    					{
			    						pInfo[playerid][player_fight_progress] += 2;
				    					TextDrawSetString(Tutorial[playerid], sprintf("Proces treningu: ~y~%d~w~%%", pInfo[playerid][player_fight_progress]));
				    					TextDrawShowForPlayer(playerid, Tutorial[playerid]);
			    					}
		    					}
		    				}
		    				case FIGHT_STYLE_KNEEHEAD:
		    				{
		    					if(anim_id == 495)
		    					{
		    						if(pInfo[playerid][player_fight_progress] >= 100)
			    					{
			    						pInfo[playerid][player_fight_style] = FIGHT_STYLE_KNEEHEAD;
			    						mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_fightstyle = %d WHERE char_uid = %d", FIGHT_STYLE_KNEEHEAD, pInfo[playerid][player_id]));
			    						SendClientMessage(playerid, COLOR_GOLD, "Gratulacje, trening zakoñczony. Nowy styl walki zosta³ dodany.");
			    						pInfo[playerid][player_gym_object] = 0;
			    						pInfo[playerid][player_fight_training] = false;
			    					}
			    					else
			    					{
		    							pInfo[playerid][player_fight_progress] += 2;
				    					TextDrawSetString(Tutorial[playerid], sprintf("Proces treningu: ~y~%d~w~%%", pInfo[playerid][player_fight_progress]));
				    					TextDrawShowForPlayer(playerid, Tutorial[playerid]);
		    						}
		    					}
		    				}
		    			}
		    		}
				}
			}
			
			if( pInfo[playerid][player_bw] > 0 )
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0, 2488.5620,-1666.8640,13.8757))
				{
					SetPlayerPos(playerid, pInfo[playerid][player_quit_pos][0], pInfo[playerid][player_quit_pos][1], pInfo[playerid][player_quit_pos][2]);
				}
				if( pInfo[playerid][player_bw_end_time] <= gettime() )
				{
					// koniec bw
					pInfo[playerid][player_bw] = 0;
					pInfo[playerid][player_bw_end_time] = 0;
					mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_bw` = 0 WHERE `char_uid` = %d", pInfo[playerid][player_id]));
					
					RemovePlayerStatus(playerid, PLAYER_STATUS_BW);
					SetPlayerHealth(playerid, 20);
					TogglePlayerControllable(playerid, 1);
					SetCameraBehindPlayer(playerid);
					ClearAnimations(playerid);
					new skin = GetClientSkin(playerid);
					SetPlayerSkin(playerid, skin);
					SetPlayerChatBubble(playerid, "", -1, 7.0, 5);
				}
				else
				{
					// update textdrawu
					UpdatePlayerBWTextdraw(playerid);
				}
			}
			
			if(pInfo[playerid][player_bw] > 0)
			{
				if(GetPlayerSpeed(playerid) > 2)
				{
					TogglePlayerControllable(playerid, false);
					pInfo[playerid][player_cheat_warns]++;
				}
			}

			if((GetPlayerWeapon(playerid) ==38 ||GetPlayerWeapon(playerid) ==37 || GetPlayerWeapon(playerid) ==36 || GetPlayerWeapon(playerid) ==39 || GetPlayerWeapon(playerid) ==35 || GetPlayerWeapon(playerid) ==16) && pInfo[playerid][player_admin_duty] == false)
			{
				new String[64];
				format(String, sizeof(String), "Restricted weap (w: %d)", GetPlayerWeapon(playerid));
	    		BanAc(playerid, -1, 30, String);
	    		continue;
			}

			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				BanAc(playerid, -1, 30, "Jetpack");
				continue;
			}

			if( pInfo[playerid][player_cheat_warns]>3 && !IsPlayerInAnyVehicle(playerid))
			{
				KickAc(playerid, -1, "Unfreeze");
				continue;
			}
			
			/*if( pInfo[playerid][player_health_changed] ) pInfo[playerid][player_health_changed] = false;
			else
			{
				new Float:health;
				GetPlayerHealth(playerid, health);
				if( health > pInfo[playerid][player_health] ) 
				{
					SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health]));
				}
			}*/

			/*if( pInfo[playerid][player_armour_changed] ) pInfo[playerid][player_armour_changed] = false;
			else
			{
				new Float:armour;
				GetPlayerArmour(playerid, armour);
				if( armour > pInfo[playerid][player_armour] ) 
				{
					SetPlayerArmour(playerid, floatround(pInfo[playerid][player_armour]));
				}
			}*/

			//Speed hack
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER )
			{
				new speeds = GetVehicleSpeed(GetPlayerVehicleID(playerid));
				if(speeds > 300)
				{
					KickAc(playerid, -1, "Speedhack");
					continue;
				}
			}
		}
	}
}