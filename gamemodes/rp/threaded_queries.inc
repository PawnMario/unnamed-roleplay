forward OnPlayerListGroundItems(playerid, itemplace);
public OnPlayerListGroundItems(playerid, itemplace)
{
	new rows, ground_item_uid, ground_item_name[40], list_items[600];
   	cache_get_row_count(rows);
   	
	for(new row = 0; row != rows; row++)
	{
		cache_get_value_index_int(row, 0, ground_item_uid);
		cache_get_value_index(row, 1, ground_item_name, 40);

		format(list_items, sizeof(list_items), "%s\n%d\t%s", list_items, ground_item_uid, ground_item_name);
		DynamicGui_AddRow(playerid, DG_ITEMS_PICKUP_ROW, ground_item_uid);
	}
	
	if(strlen(list_items) > 0)
	{
		switch(itemplace)
		{
			case 1: ShowPlayerDialog(playerid, DIALOG_ITEMS_PICKUP, DIALOG_STYLE_LIST, "Przedmioty w pobli¿u:", list_items, "Podnieœ", "Anuluj");
			case 2: ShowPlayerDialog(playerid, DIALOG_ITEMS_PICKUP, DIALOG_STYLE_LIST, "Przedmioty w pojeŸdzie", list_items, "Podnieœ", "Anuluj");
		}
  	}
   	else
   	{
    	SendGuiInformation(playerid, "Informacja", "Brak przedmiotów w pobli¿u.");
	}
}

forward OnPlayerEditVehicleAttachedObj(playerid, objectid, vehicleuid);
public OnPlayerEditVehicleAttachedObj(playerid, objectid, vehicleuid)
{
	new rows, vattachuid;
	cache_get_row_count(rows);

	new Float:a[3], Float:ar[3];
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_ATTACH_OFFSET_X, a[0]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_ATTACH_OFFSET_Y, a[1]);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_ATTACH_OFFSET_Z, a[2]);

    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_ATTACH_R_X, ar[0]);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_ATTACH_R_Y, ar[1]);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_ATTACH_R_Z, ar[2]);

	if(rows)
	{
		cache_get_value_index_int(0, 0, vattachuid);
		mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_vehicle_attachments SET vattach_x = '%f', vattach_y = '%f', vattach_z = '%f', vattach_rx = '%f', vattach_ry = '%f', vattach_rz = '%f' WHERE vattach_uid = %d", a[0],a[1],a[2],ar[0],ar[1],ar[2], vattachuid));
	}
	else
	{
		mysql_tquery(mySQLconnection, sprintf("INSERT INTO ipb_vehicle_attachments (vattach_owner, vattach_model, vattach_x, vattach_y, vattach_z, vattach_rx, vattach_ry, vattach_rz) VALUES (%d, %d, '%f', '%f','%f','%f','%f','%f')", vehicleuid, GetObjectModel(objectid),a[0],a[1],a[2],ar[0],ar[1],ar[2]));
	}

	return 1;
}

forward LoadRobberyArrows();
public LoadRobberyArrows()
{
	new rows;
	cache_get_row_count(rows);

	if(rows)
	{
		for(new row = 0; row != rows; row++)
		{
			new Float:x, Float:y, Float:z, vw;
			cache_get_value_index_float(row, 8, x);
			cache_get_value_index_float(row, 9, y);
			cache_get_value_index_float(row, 10, z);
			cache_get_value_index_int(row, 7, vw);

			new pickupid = CreateDynamicPickup(19134, 1, x, y, z+1.0, vw);
			Pickup[pickupid][pickup_type] = PICKUP_TYPE_ROBBERY;
		}
	}
	return 1;
}

forward LoadRobberyBots();
public LoadRobberyBots()
{
	new rows;
	cache_get_row_count(rows);

	if(rows)
	{
		for(new row = 0; row != rows; row++)
		{
			new name[MAX_PLAYER_NAME + 1];
			format(name, sizeof(name), "Bot_%d", row);
			new npcid = FCNPC_Create(name);
			if (npcid == INVALID_PLAYER_ID) continue;

			cache_get_value_index_int(row, 0, NPC[npcid][npc_uid]);
			cache_get_value_index_int(row, 1, NPC[npcid][npc_type]);
			cache_get_value_index_int(row, 2, NPC[npcid][npc_owner]);
			cache_get_value_index_int(row, 3, NPC[npcid][npc_skin]);
			cache_get_value_index_int(row, 4, NPC[npcid][npc_weapon]);
			cache_get_value_index_float(row, 5, NPC[npcid][npc_pos][0]);
			cache_get_value_index_float(row, 6, NPC[npcid][npc_pos][1]);
			cache_get_value_index_float(row, 7, NPC[npcid][npc_pos][2]);
			cache_get_value_index_float(row, 8, NPC[npcid][npc_pos][3]);
			cache_get_value_index_int(row, 9, NPC[npcid][npc_vw]);
			FCNPC_Spawn(npcid, NPC[npcid][npc_skin], NPC[npcid][npc_pos][0], NPC[npcid][npc_pos][1], NPC[npcid][npc_pos][2]);
			FCNPC_SetAngle(npcid, NPC[npcid][npc_pos][3]);
			FCNPC_SetVirtualWorld(npcid, NPC[npcid][npc_vw]);
			FCNPC_SetWeapon(npcid, NPC[npcid][npc_weapon]);
			FCNPC_UseInfiniteAmmo(npcid, true);
			FCNPC_SetWeaponSkillLevel(npcid, WEAPONSKILL_PISTOL, 100);

			NPC[npcid][npc_area] = CreateDynamicCircle(NPC[npcid][npc_pos][0], NPC[npcid][npc_pos][1], 16.0, NPC[npcid][npc_vw]);
			Area[NPC[npcid][npc_area]][area_type] = AREA_TYPE_GUARD_NPC;

			Iter_Add(NPCs, npcid);
		}
	}
	return 1;
}

forward OnPlayerListSpawns(playerid);
public OnPlayerListSpawns(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz ¿adnych spawnów do wyboru.\nMusisz zostaæ do nich dodany poprzez komende /dom zapros.");

	new d_uid, spawn_list[300];
	DynamicGui_Init(playerid);

	for(new row = 0; row != rows; row++)
	{
		cache_get_value_index_int(row, 1, d_uid);

		new d_id = GetDoorByUid(d_uid);
		if(d_id != -1)
		{
			format(spawn_list, sizeof(spawn_list), "%s\n%s", spawn_list, Door[d_id][door_name]);
			DynamicGui_AddRow(playerid, d_id);
		}

		ShowPlayerDialog(playerid, DIALOG_SPAWN_CHOICE, DIALOG_STYLE_LIST, "Lista twoich spawnów", spawn_list, "Wybierz", "Anuluj");
	}
	return 1;
}

forward OnPlayerGlobalCheck(playerid);
public OnPlayerGlobalCheck(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if( !rows )
    {
    	TextDrawShowForPlayer(playerid, Serverlogo);

        new string[312];
        format(string, sizeof(string), "Witaj na "COLOR_GUI_BLUE"San Andreas Roleplay, serwerze o wielkich mo¿liwoœciach\nNiestety nie odnaleziono postaci na któr¹ próbujesz siê zalogowaæ!\n"COLOR_GUI_BLUE"Aby stworzyæ postaæ odwiedŸ nasz¹ strone internetow¹ san-andreas.pl!");
        ShowPlayerDialog(playerid, DIALOG_LOGIN_NO_ACCOUNT, DIALOG_STYLE_MSGBOX, ""guiopis"Nie znaleziono postaci!", string, "Zmieñ nick", "WyjdŸ" );
        return 1;
    }
    else
    {
    	cache_get_value_index(0, 4, gInfo[playerid][global_password], 80);
		cache_get_value_index(0, 2, gInfo[playerid][global_name], MAX_PLAYER_NAME+1);
		cache_get_value_index(0, 2, pGlobal[playerid][glo_name], MAX_PLAYER_NAME+1);
		
		cache_get_value_index_int(0, 0, pInfo[playerid][player_id]);
		cache_get_value_index_int(0, 3, gInfo[playerid][global_id]);

		cache_get_value_index_int(0, 1, pGlobal[playerid][glo_id]);
		cache_get_value_index_int(0, 5, pGlobal[playerid][glo_score]);
		cache_get_value_index_int(0, 6, pGlobal[playerid][glo_perm]);
		cache_get_value_index_int(0, 7, pGlobal[playerid][glo_premium]);

		LoadGlobalPenalties(playerid);
		TextDrawShowForPlayer(playerid, Serverlogo);

    	new string[512];
	    format(string, sizeof(string), "{EBEF6B}Witaj na San Andreas Roleplay!\n\n");
	    format(string, sizeof(string), "%s{A9C4E4}Do³¹czy³eœ na serwer jako {ffffff}%s.\n\n", string, pInfo[playerid][player_name]);
	    format(string, sizeof(string), "%s{A9C4E4}1.    Postaæ nale¿y do Ciebie? Zaloguj siê na swoje konto podaj¹c swoje has³o z forum.\n2.    Wprowadzi³eœ niepoprawny nick? Zmieñ go.\n3.    Nie posiadasz konta na forum? Zarejestruj siê na san-andreas.pl", string);
	    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, ""guiopis"Logowanie do gry", string, "Zaloguj", "Zmieñ nick");
    }
  	return 1;
}

forward OnPlayerListDealerShip(playerid, category, header[]);
public OnPlayerListDealerShip(playerid, category, header[])
{
	new list_vehicles[1024], rows;
	cache_get_row_count(rows);

	DynamicGui_Init(playerid);
	for(new row = 0; row != rows; row++)
	{
		new model, price;
		cache_get_value_index_int(row, 2, model);
		cache_get_value_index_int(row, 3, price);

		format(list_vehicles, sizeof(list_vehicles), "%s %s\t$%d\n", list_vehicles, VehicleNames[model-400], price);
		DynamicGui_AddRow(playerid, DG_PRODS_SALON, model);  
	}

	if(strlen(list_vehicles))
	{
		ShowPlayerDialog(playerid, DIALOG_SALON_SELL, DIALOG_STYLE_TABLIST, header, list_vehicles, "Kup", "WyjdŸ");
	}
	else
	{
		SendGuiInformation(playerid, header, "Brak pojazdów dodanych do tej kategorii.");
	}
}

forward OnPlayerCheckCreditStatus(playerid);
public OnPlayerCheckCreditStatus(playerid)
{
	new rows, list_credits[300];
	cache_get_row_count(rows);

	if(rows)
	{
		for(new row = 0; row != rows; row++)
		{
			new credit_created, credit_value, temp;
			cache_get_value_index_int(row, 0, credit_created);

			new cmonth, cday, chour, cminute;
			TimestampToDate(credit_created, temp, cmonth, cday, chour, cminute, temp, 1);

			cache_get_value_index_int(row, 1, credit_value);

			format(list_credits, sizeof(list_credits), "$%d\t%02d.%02d %d:%02d\n%s", credit_value, cday, cmonth, chour, cminute, list_credits);
		}

		format(list_credits, sizeof(list_credits), "Do sp³aty\tData podjêcia\n%s\n_\nAktualnie posiadasz aktywne kredyty widoczne powy¿ej.\nSp³aæ je aby wzi¹æ kolejny.", list_credits);
		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_TABLIST_HEADERS, "Lista twoich kredytów", list_credits, "OK", "");
		return 1;
	}

	//todo: daj mu kredyta
	return 1;
}
