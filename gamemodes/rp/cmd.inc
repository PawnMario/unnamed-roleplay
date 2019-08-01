COMMAND:vmat(playerid, params[])
{
	if( !IsValidDynamicObject(pInfo[playerid][player_vattach_object]) ) return SendGuiInformation(playerid, "Wyst¹pi³ b³¹d", "Nie edytujesz ¿adnego obiektu.");
	if( strfind(params, "|", true) != -1) return SendGuiInformation(playerid, "Wyst¹pi³ b³¹d", "Wykryto niedozwolone znaki.");
	new sub_cmd, param[100];
	if( sscanf(params, "d S()[150]", sub_cmd, param) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /vmat [0-1] (parametry)");
	
	switch(sub_cmd)
	{
		// tekstury
		case 0:
		{
			new index, color, model, txd_name[64], texture_name[64];
			if( sscanf(param, "dxds[64]s[64]", index, color, model, txd_name, texture_name) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /mmat 0 [Index (0-15)] [Kolor (ARGB)] [Model] [Txdname] [Texturename]");
			if( index < 0 || index > 15 ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /vmat 0 [Index (0-15)] [Kolor (ARGB)] [Model] [Txdname] [Texturename]");
			if(strlen(texture_name) > 30) return SendGuiInformation(playerid, "Informacja", "Zbyt d³ugi tekst tekstury.");
			if(strlen(txd_name) > 30) return SendGuiInformation(playerid, "Informacja", "Zbyt d³ugi tekst nazwy txd.");
			
			new o_id = pInfo[playerid][player_vattach_object];
			SetDynamicObjectMaterial(o_id, index, model, txd_name, texture_name, color);
			Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
		}
		
		// napisy
		case 1:
		{
			new index, msize, fsize, bold, fcolor, bcolor, align, font[32], text[128];
			if( sscanf(param, "ddddxxds[32]s[128]", index, msize, fsize, bold, fcolor, bcolor, align, font, text) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /mmat 1 [index (0-15)] [Matsize (10-140) [Fontsize (24-255)] [Bold] [Fontcol] [Backcol] [Align (0-2)] [Font] [Txt]");
			if( index < 0 || index > 15 ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /vmat 1 [index (0-15)] [Matsize (10-140) [Fontsize (24-255)] [Bold] [Fontcol] [Backcol] [Align (0-2)] [Font] [Txt]");
			if(strlen(text) > 50) return SendGuiInformation(playerid, "Informacja", "Zbyt d³ugi tekst.");
			if(strlen(font) > 10) return SendGuiInformation(playerid, "Informacja", "Zbyt d³ugi tekst czcionki.");
			if( strfind(text, ":", true) != -1 || strfind(text, "^", true) != -1 ) return SendGuiInformation(playerid, "Informacja", "Nie mozesz uzywaæ znaków ^ oraz :.");

			new o_id = pInfo[playerid][player_vattach_object];
			SetDynamicObjectMaterialText(o_id, index, text, msize, font, fsize, bold, fcolor, bcolor, align);
			Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
		}
	}
	
	return 1;
}

COMMAND:r(playerid, params[])
{
	if(!pInfo[playerid][player_radio_channel])
	{
		new channel_id;
		if( sscanf(params, "d", channel_id) )
		{
			SendClientMessage(playerid, COLOR_GREY, "Tip: /r [kana³]");
			return 1;
		}

		if(channel_id < 1 && channel_id > 1000) return SendClientMessage(playerid, COLOR_GREY, "Tip: /r [kana³ od 1 do 1000]");
		if(!IsPlayerInPD(playerid) && channel_id <= 100) return SendGuiInformation(playerid, "Informacja", "Kana³y od 1 do 100 s¹ zarezerwowane dla s³u¿b publicznych.");

		pInfo[playerid][player_radio_channel] = channel_id;
		SendGuiInformation(playerid, "Informacja", "Kana³ zosta³ ustawiony.");
	}
	else
	{
		new channel_id;
		if( !sscanf(params, "d", channel_id) )
		{
			pInfo[playerid][player_radio_channel] = channel_id;
			SendGuiInformation(playerid, "Informacja", "Kana³ zosta³ zmieniony.");
			return 1;
		}

		new channel_text[250];
		if( !sscanf(params, "s[250]", channel_text) )
		{
			ProxMessage(playerid, channel_text, PROX_RADIO);
			foreach(new p: Player)
			{
				if(pInfo[playerid][player_radio_channel] == pInfo[p][player_radio_channel])
				{
					SendClientMessage(p, COLOR_LIGHTER_ORANGE, sprintf("[R:%d] [%s]: %s", pInfo[playerid][player_radio_channel], pInfo[playerid][player_name], channel_text));
				}
			}
		}
	}
	return 1;
}

COMMAND:slots(playerid, params[])
{
	TextDrawShowForPlayer(playerid, BodBackground); //tlo
	CreateBodTextDraws(playerid); // symbole i napisy

	for(new i=0;i<15;i++)
	{
		PlayerTextDrawShow(playerid, BodSymbols[playerid][i][symbol_textdraw]);
	}

	PlayerTextDrawShow(playerid, BodBet[playerid]);
	PlayerTextDrawShow(playerid, BodCoinsWager[playerid]);
	PlayerTextDrawShow(playerid, BodWin[playerid]);
	PlayerTextDrawShow(playerid, BodCoinValue[playerid]);
	PlayerTextDrawShow(playerid, BodCoinsBank[playerid]);

	Iter_Add(SlotPlayers, playerid);
	pInfo[playerid][player_slot_spin] = true;

	return 1;
}

COMMAND:produkcja(playerid, params[])
{
	if(pInfo[playerid][player_production] > 0) return SendGuiInformation(playerid, "Informacja", "Jesteœ ju¿ w trakcie produkcji.");
	new gid = pInfo[playerid][player_duty_gid];
	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie organizacji przestêpczej.");
	if(Group[gid][group_type] != GROUP_TYPE_GANG) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie organizacji przestêpczej.");

	new object_id = GetClosestObjectType(playerid, OBJECT_LAB);

	if(object_id == INVALID_STREAMER_ID) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê przy obiekcie sprzêtu laboratoryjnego.\nJego id to -2027.");
	
	new d_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
	if(d_id == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach ze sprzêtem laboratoryjnym.\nZakupiæ mo¿na go u bota organizacyjnego.");

	if(Door[d_id][door_owner_type] != DOOR_OWNER_TYPE_GROUP) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach grupowych lub jesteœ na z³ej s³u¿bie.");
	if(Door[d_id][door_owner] != Group[gid][group_uid]) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach grupowych lub jesteœ na z³ej s³u¿bie.");
	
	new Float:x, Float:y, Float:z;
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP, d_id, E_STREAMER_X, x);
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP, d_id, E_STREAMER_Y, y);
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP, d_id, E_STREAMER_Z, z);

	new area_ids[5];
	GetDynamicAreasForPoint(x, y, z, area_ids);

	if(Area[area_ids[0]][area_owner_type] != AREA_OWNER_TYPE_GROUP) return SendGuiInformation(playerid, "Informacja", "Ten budynek nie znajduje siê w strefie nale¿¹cej do twojej organizacji.");
	if(Area[area_ids[0]][area_owner] != Group[gid][group_uid]) return SendGuiInformation(playerid, "Informacja", "Ten budynek nie znajduje siê w strefie nale¿¹cej do twojej organizacji.");

	new shorter_time;
	if(DoorHasAccess(d_id, DOOR_ACCESS_LAB_UPGRADES)) shorter_time = true;

	if(DoorHasAccess(d_id, DOOR_ACCESS_METHLAB))
	{
		//SprawdŸ czy posiada materia³y, jeœli ma to od razu wyjebaæ
		new itemid = HasPlayerItemWithValue(ITEM_TYPE_CHEMISTRY, playerid, 1);
		if(itemid == -1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz pseudoefedryny, która jest wymaganym sk³adnikiem do produkcji metaamfetaminy.");

		DeleteItem(itemid, true, playerid);

		//Czas produkcji - 5 minut
		pInfo[playerid][player_production] = 300;
		pInfo[playerid][player_production_type] = PRODUCTION_TYPE_METH;
		if(shorter_time) pInfo[playerid][player_production] -= 60;

		SendGuiInformation(playerid, "Informacja", "Rozpoczêto produkcje metaamfetaminy.\nW lewej czêœci ekranu uruchomiono odliczanie do jej koñca.");
		pInfo[playerid][player_production_object] = object_id;
		return 1;
	}

	if(DoorHasAccess(d_id, DOOR_ACCESS_AMPHLAB))
	{
		//SprawdŸ czy posiada materia³y, jeœli ma to od razu wyjebaæ
		new itemid = HasPlayerItemWithValue(ITEM_TYPE_CHEMISTRY, playerid, 2);
		if(itemid == -1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz fenyloacetonu, który jest wymaganym sk³adnikiem do produkcji amfetaminy.");

		DeleteItem(itemid, true, playerid);

		//Czas produkcji - 4 minuty
		pInfo[playerid][player_production] = 240;
		pInfo[playerid][player_production_type] = PRODUCTION_TYPE_AMPH;
		if(shorter_time) pInfo[playerid][player_production] -= 60;

		SendGuiInformation(playerid, "Informacja", "Rozpoczêto produkcje amfetaminy.\nW lewej czêœci ekranu uruchomiono odliczanie do jej koñca.");
		pInfo[playerid][player_production_object] = object_id;
		return 1;
	}

	if(DoorHasAccess(d_id, DOOR_ACCESS_CRACKLAB))
	{
		//SprawdŸ czy posiada kokaine, jeœli ma to od razu j¹ skasuj
		new itemid = HasPlayerItemWithValue(ITEM_TYPE_DRUG, playerid, DRUG_TYPE_COCAINE);
		if(itemid == -1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz kokainy, która jest podstaw¹ do wytworzenia cracku.");
		
		//Skasuj ca³y item lub pobierz 1g jesli jest zbite w kostke
		if(PlayerItem[playerid][itemid][player_item_value2] == 1)
		{
			DeleteItem(itemid, true, playerid);
			//Czas produkcji - 4 minuty
			pInfo[playerid][player_production] = 200;
			pInfo[playerid][player_production_type] = PRODUCTION_TYPE_CRACK;

			SendGuiInformation(playerid, "Informacja", "Rozpoczêto produkcje cracku.\nW lewej czêœci ekranu uruchomiono odliczanie do jej koñca.");
			pInfo[playerid][player_production_object] = object_id;
		}
		else if(PlayerItem[playerid][itemid][player_item_value2] > 1)
		{
			PlayerItem[playerid][itemid][player_item_value2]--;
			PlayerItem[playerid][itemid][player_item_weight] = PlayerItem[playerid][itemid][player_item_value2];

			pInfo[playerid][player_capacity] += PlayerItem[playerid][itemid][player_item_weight];
			mysql_query(mySQLconnection, sprintf("UPDATE ipb_items SET item_value2 = %d, item_weight = %d WHERE item_uid = %d AND item_owner = %d", PlayerItem[playerid][itemid][player_item_value2], PlayerItem[playerid][itemid][player_item_value2], PlayerItem[playerid][itemid][player_item_uid], pInfo[playerid][player_id]));
			if(cache_affected_rows())
			{
				//Czas produkcji - 4 minuty
				pInfo[playerid][player_production] = 240;
				if(shorter_time) pInfo[playerid][player_production] -= 60;

				SendGuiInformation(playerid, "Informacja", "Rozpoczêto produkcje cracku.\nW prawej czêœci ekranu uruchomiono odliczanie do jej koñca.");
				pInfo[playerid][player_production_object] = object_id;
			}
		}
		return 1;
	}

	SendGuiInformation(playerid, "Informacja", "Te drzwi nie posiadaj¹ zamontowanego ¿adnego sprzêtu laboratoryjnego.\nNabyæ mo¿na go u bota organizacyjnego.");
	return 1;
}

COMMAND:soundtest(playerid, params[])
{
	new sound_id;
	if( sscanf(params, "d", sound_id) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /soundtest [soundid]");
		return 1;
	}

	PlayerPlaySound(playerid, sound_id, 0.0, 0.0, 0.0);
	return 1;
}

COMMAND:ruletka(playerid, params[])
{
	if(pInfo[playerid][player_hours] < 1) return SendGuiInformation(playerid, "Informacja", "Nie mo¿esz graæ w kasynie nie maj¹c przegranej godziny online.");

	new d_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
	if(d_id == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w kasynie.");
	if(Door[d_id][door_owner_type] != DOOR_OWNER_TYPE_GROUP) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w kasynie.");
	new d_owner = GetGroupByUid(Door[d_id][door_owner]);
	if(d_owner == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w kasynie.");

	if(Group[d_owner][group_type] != GROUP_TYPE_CASINO) return SendGuiInformation(playerid, "Informacja", "Te drzwi nie s¹ podpisane pod ¿adne kasyno.");

	new object_id = GetClosestObjectType(playerid, OBJECT_ROULETTE_TABLE);

	if(object_id == INVALID_STREAMER_ID) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê przy stole z ruletk¹.");

	new table_taken;
	foreach(new p: Player)
	{
		if(pInfo[p][player_roulette_object] == object_id)
		{
			SendGuiInformation(playerid, "Informacja", "Ktoœ aktualnie gra przy tym stole, poczekaj na swoj¹ kolej.");
			table_taken = true;
			break;
		}
	}

	if(table_taken) return 1;

	new Float:rx, Float:ry, Float:rz;
	GetDynamicObjectRot(object_id, rx, ry, rz);

	if(rx == 0 && ry == 0 && rz == 90.0)
	{
		new Float:x, Float:y, Float:z;
		GetDynamicObjectPos(object_id, x, y, z);

		TogglePlayerControllable(playerid, false);

		pInfo[playerid][player_roulette_object] = object_id;
		pInfo[playerid][player_roulette_owner] = d_owner;
		pInfo[playerid][player_roulette_selector]  = CreateDynamicObject(2992, x-0.36, y-0.66, z-0.162, rx, ry, rz, GetPlayerVirtualWorld(playerid));
		Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
		pInfo[playerid][player_roulette_field] = Iter_First(RouletteFields);

		SetPlayerCameraPos(playerid, x+1.78, y-2.20256, z+1.89);
		SetPlayerCameraLookAt(playerid, x, y, z, CAMERA_MOVE);

		new current_field = pInfo[playerid][player_roulette_field];

		TextDrawSetString(Tutorial[playerid], sprintf("Aktualny wybor: ~y~%s (stawka x%d)~n~~w~Uzywaj klawiszy ~<~~>~, aby poruszac~n~zoltym selektorem.~n~~n~Nacisnij ~g~SHIFT~w~, aby obstawic.~n~~b~~r~SPACJA~w~, aby wyjsc z gry.", RouletteField[current_field][field_name], RouletteField[current_field][field_multiplier]));
		TextDrawShowForPlayer(playerid, Tutorial[playerid]);
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Ten stó³ z ruletk¹ nie ma prawid³owej rotacji (90 stopni).");
	}
	return 1;
}

COMMAND:screenshot(playerid, params[])
{
	if(pInfo[playerid][player_screenshot])
	{
		TextDrawHideForPlayer(playerid, TextDrawScreenShot);
	} 
	else 
	{
		TextDrawShowForPlayer(playerid, TextDrawScreenShot);
	}

	pInfo[playerid][player_screenshot] = !pInfo[playerid][player_screenshot];
	return 1;
}

COMMAND:radio(playerid, params[])
{
	new radio_list[200];

	DynamicGui_Init(playerid);

	foreach(new r_id: Groups)
	{
		if(Group[r_id][group_type] == GROUP_TYPE_SN)
		{
			format(radio_list, sizeof(radio_list), "%s\n%s\t%d\n", radio_list, Group[r_id][group_name], GetListenersCount(r_id));
			DynamicGui_AddRow(playerid, r_id);
		}
	}

	if(strlen(radio_list))
	{
		format(radio_list, sizeof(radio_list), "Radiostacja\tIloœæ s³uchaczy\n%s", radio_list);
		ShowPlayerDialog(playerid, DIALOG_RADIOSTATIONS, DIALOG_STYLE_TABLIST_HEADERS, "Lista radiostacji", radio_list, "S³uchaj", "Anuluj");
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Na serwerze nie istnieje ¿adna radiostacja.");
	}
	return 1;
}

COMMAND:napad(playerid, params[])
{
	if(pInfo[playerid][player_robbery] != -1) return SendGuiInformation(playerid, "Informacja", "Bierzesz ju¿ udzia³ w jakimœ napadzie.");
	new gid = pInfo[playerid][player_duty_gid];
	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie ¿adnej grupy.");
	if(Group[gid][group_type] != GROUP_TYPE_GANG) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie organizacji przestêpczej.");
	if(!SherifsOnline()) return SendGuiInformation(playerid, "Informacja", "Aby zainicjowaæ napad, na s³u¿bie musz¹ byæ cz³onkowie LSPD.");

	new robbery_list[450];

	DynamicGui_Init(playerid);

	foreach(new r_id: Robberies)
	{
		format(robbery_list, sizeof(robbery_list), "%s\n%s\t%s\n", robbery_list, Robbery[r_id][robbery_name], GetRobberyLevel(r_id));
		DynamicGui_AddRow(playerid, r_id);
	}

	if(strlen(robbery_list))
	{
		format(robbery_list, sizeof(robbery_list), "Cel\tPoziom trudnoœci\n%s", robbery_list);
		ShowPlayerDialog(playerid, DIALOG_ROBBERY, DIALOG_STYLE_TABLIST_HEADERS, "Planowanie napadu", robbery_list, "Wymagania", "Anuluj");
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Na serwer nie zosta³y wczytane ¿adne napady.");
	}
	return 1;
}

COMMAND:walki(playerid, params[])
{
	new gid = pInfo[playerid][player_duty_gid];
	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie ¿adnej grupy.");
	if(Group[gid][group_type] != GROUP_TYPE_GANG) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie organizacji przestêpczej.");

	new war_list[350], header[60];

	foreach(new warid: GangWars)
	{
		if(GangWar[warid][war_attacker] == Group[gid][group_uid])
		{
			format(war_list, sizeof(war_list), "%s\n"HEX_COLOR_LIGHTER_GREEN"ATAK"HEX_COLOR_WHITE"\t%s\t%d\t%d", war_list, Group[GangWar[warid][war_def_gid]][group_name], GangWar[warid][war_attack_points], GangWar[warid][war_def_points]);
		}
		if(GangWar[warid][war_defender] == Group[gid][group_uid])
		{
			format(war_list, sizeof(war_list), "%s\n"HEX_COLOR_LIGHTER_YELLOW"OBRONA"HEX_COLOR_WHITE"\t%s\t%d\t%d", war_list, Group[GangWar[warid][war_at_gid]][group_name], GangWar[warid][war_def_points], GangWar[warid][war_attack_points]);
		}
	}

	if(strlen(war_list))
	{
		format(header, sizeof(header), "Twój status\tGrupa\tTwoje punkty\tPunkty przeciwnika");
		format(war_list, sizeof(war_list), "%s\n%s", header, war_list);
		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Walki grupy %s", Group[gid][group_name]), war_list, "OK", "");
	}
	else
	{	
		SendGuiInformation(playerid, "Informacja", "Grupa na której jesteœ s³u¿bie nie toczy obecnie ¿adnych walk.");
	}
	return 1;
}

COMMAND:area(playerid, params[])
{	
	if(pInfo[playerid][player_area] < 1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnej strefie.");
	if(Area[pInfo[playerid][player_area]][area_type] != AREA_TYPE_NORMAL) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnej strefie.");
	if(GetPlayerVirtualWorld(playerid) != 0) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnej strefie.");

	new a_id = pInfo[playerid][player_area];
	if(a_id == -1) return 1;

	new Float:apoints[8];
	GetDynamicPolygonPoints(a_id, apoints, 8);

	pInfo[playerid][player_lookup_zone] = PlayerGangZoneCreate(playerid, Min(apoints[0], apoints[4]), Min(apoints[1], apoints[3]), Max(apoints[0], apoints[4]), Max(apoints[1], apoints[3]));

	PlayerGangZoneShow(playerid, pInfo[playerid][player_lookup_zone], PLAYER_GZ_DEFAULT_COLOR);

	DynamicGui_Init(playerid);
	DynamicGui_SetDialogValue(playerid, a_id);

	ShowAreaFlags(playerid, a_id);
	
	switch(Area[a_id][area_owner_type])
	{
		case AREA_OWNER_TYPE_GLOBAL:
		{	
			DynamicGui_AddRow(playerid, DG_AREA_INFO);
			DynamicGui_AddRow(playerid, DG_AREA_TAKE);
			DynamicGui_AddRow(playerid, DG_AREA_TAKEA);
			ShowPlayerDialog(playerid, DIALOG_AREA, DIALOG_STYLE_LIST, sprintf("Strefa neutralna (UID %d, SAMPID %d)", Area[a_id][area_uid], a_id), "1. Wyœwietl informacje\n2. Przejmij strefê (tryb standardowy)\n3. Przejmij strefê (tryb aktywnoœci)", "OK", "Anuluj");
		}

		case AREA_OWNER_TYPE_GROUP:
		{
			if(!CanPlayerEditArea(playerid, a_id))
			{
				DynamicGui_AddRow(playerid, DG_AREA_INFO);
				DynamicGui_AddRow(playerid, DG_AREA_TAKE);
				ShowPlayerDialog(playerid, DIALOG_AREA, DIALOG_STYLE_LIST, sprintf("Strefa grupowa (UID %d, SAMPID %d)", Area[a_id][area_uid], a_id), "1. Wyœwietl informacje\n2. Przejmij strefê", "OK", "Anuluj");
				return 1;
			}

			DynamicGui_AddRow(playerid, DG_AREA_INFO);
			DynamicGui_AddRow(playerid, DG_AREA_VISIBLE);

			new area_options[180];
			format(area_options, sizeof(area_options), "1. Wyœwietl informacje o strefie\n2. Zmieñ widocznoœæ na mapie\n3. Przypisz obiekty do stworzenia (%d przypisanych)", Area[a_id][area_objects_limit]);
			ShowPlayerDialog(playerid, DIALOG_AREA, DIALOG_STYLE_LIST, sprintf("Strefa grupowa (UID %d, SAMPID %d)", Area[a_id][area_uid], a_id), area_options, "OK", "Anuluj");
		}
	}

	return 1;
}

COMMAND:bus(playerid, params[])
{
    if(IsAnyTaxiOnDuty()) return SendGuiInformation(playerid, "Informacja", "W tej chwili na s³u¿bie jest conajmniej jedna firma taksówkarska, busy w takiej sytuacji s¹ wy³¹czone.");

	if(GetPlayerVirtualWorld(playerid) != 0) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na przystanku autobusowym.");

	new object_id = GetClosestObjectType(playerid, OBJECT_BUSSTOP);

	if(object_id == INVALID_STREAMER_ID) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na przystanku autobusowym.");

	SetPlayerFacingAngle(playerid, 0);

	new Float:x, Float:y, Float:z;
	GetDynamicObjectPos(object_id, x, y, z);

	TogglePlayerControllable(playerid, false);
	SetPlayerPos(playerid, x, y, z-10);

	pInfo[playerid][player_bus_stop] = object_id;
	pInfo[playerid][player_bus_object] = CreateDynamicObject(3003, x, y, 171.767776, 0, 0, 0);
	TogglePlayerSpectating(playerid, true);

	new Float:xx, Float:yy, Float:zz;
	GetDynamicObjectPos(pInfo[playerid][player_bus_object], xx, yy, zz);

	SetPlayerCameraPos(playerid, xx, yy, zz);
	SetPlayerCameraLookAt(playerid, x, y+45, z);

	GetPlayer2DZone(playerid, pInfo[playerid][player_bus_zone], MAX_ZONE_NAME);

	AttachCameraToDynamicObject(playerid, pInfo[playerid][player_bus_object]);

	TextDrawSetString(Tutorial[playerid], "Wskaz nam, gdzie chcesz dojechac.~n~Uzyj klawiszy ~u~~d~~<~~>~, aby poruszac sie~n~po mapie.~n~Nacisnij ~g~ENTER~w~, aby znalezc najblizszy przystanek.~n~~b~~r~SHIFT~w~ aby powrocic na przystanek.");
	TextDrawShowForPlayer(playerid, Tutorial[playerid]);

	return 1;
}

COMMAND:zbadaj(playerid, params[])
{
	new gid = pInfo[playerid][player_duty_gid];
	if(gid == - 1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy porz¹dkowej.");
	if(!GroupHasFlag(gid, GROUP_FLAG_911)) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy porz¹dkowej.");

	new sub_cmd[20], rest[64];
	
	if( sscanf(params, "s[32]S()[80]", sub_cmd, rest) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /zbadaj [odciski]");
		return 1;
	}
	else
	{
		if( !strcmp(sub_cmd, "odciski") )
		{
			new item, rows, Cache:tmp_cache;
			if(sscanf(rest, "d", item)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /zbadaj odciski [uid przedmiotu]");
			new itemid = GetItemByUid(item, playerid);
			if(itemid == -1) return SendClientMessage(playerid, COLOR_GREY, "Tip: /zbadaj odciski [uid przedmiotu]");
			if(!Iter_Contains(PlayerItems[playerid], itemid)) return SendGuiInformation(playerid, "Informacja", "Niepoprawne UID przedmiotu.");

			tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT finger_person FROM ipb_fingerprints WHERE finger_owner = %d LIMIT 15", item));
			cache_get_row_count(rows);

			new list_prints[128], last_print;

			for(new row = 0; row != rows; row++)
			{
				new printowner;
				cache_get_value_index_int(row, 0, printowner);
				if(printowner == last_print) continue;
				last_print = printowner;
				format(list_prints, sizeof(list_prints), "%s\n%d", list_prints, printowner);
			}

			if(strlen(list_prints))
			{
				format(list_prints, sizeof(list_prints), "DNA w³aœciciela odcisku:\n%s", list_prints);
				ShowPlayerDialog(playerid, DIALOG_FINGERPRINTS, DIALOG_STYLE_TABLIST_HEADERS, "Ostatnie odciski palców", list_prints, "Badaj", "WyjdŸ");
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", "Brak odcisków palców na tym przedmiocie.");
			}

			if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
		}
	}
	return 1;
}

COMMAND:gov(playerid, params[])
{
	if(!PlayerHasFlag(playerid, PLAYER_FLAG_PRESIDENT)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz flagi burmistrza.");

	new rows, Cache:tmp_cache;

	tmp_cache = mysql_query(mySQLconnection, "SELECT group_uid, group_name, group_activity FROM ipb_game_groups WHERE group_activity > 0 ORDER BY group_activity DESC");
	cache_get_row_count(rows);

	if(rows)
	{
		new list_groups[1500];

		for(new row = 0; row != rows; row++)
		{
			new tmp[64], tmpf, tmps;
			cache_get_value_index_int(row, 0, tmpf);
			cache_get_value_index(row, 1, tmp);
			cache_get_value_index_int(row, 2, tmps);
			format(list_groups, sizeof(list_groups), "%s\n%d\t%s\t%d", list_groups, tmpf, tmp, tmps);
		}

		if(strlen(list_groups))
		{
			format(list_groups, sizeof(list_groups), "UID\tNazwa\tPunkty aktywnoœci\n%s", list_groups);
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_TABLIST_HEADERS, "Ranking aktywnoœci", list_groups, "OK", "");
		}
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Brak grup z nabitymi punktami aktywnoœci dzisiejszego dnia.");
	}

	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	return 1;
}

COMMAND:dotacja(playerid, params[])
{
	if(!PlayerHasFlag(playerid, PLAYER_FLAG_PRESIDENT)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz flagi burmistrza.");

	new targetguid, amount;
	if( sscanf(params, "dd", targetguid, amount) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /dotacja [uid grupy] [kwota]");

	if(amount < 0 || amount > 300) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");

	new targetgid = GetGroupByUid(targetguid);
	if(targetgid == -1) return SendGuiInformation(playerid, "Informacja", "Niepoprawne UID grupy.");

	new gov = GetGroupByUid(6);
	if(gov != -1) 
	{
		if(Group[gov][group_capital] < amount) return SendGuiInformation(playerid, "Informacja", "Rz¹d nie posiada takiego kapita³u.");
		GiveGroupCapital(gov, -amount);
	}

	mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_capital = group_capital + %d WHERE group_uid = %d", amount, targetguid));
	Group[targetgid][group_capital] += amount;
	SendGuiInformation(playerid, "Informacja", sprintf("Pomyœlnie wp³acono $%d dotacji na kapita³ grupy %s.", amount, Group[targetgid][group_name]));

	return 1;
}

COMMAND:ignoruj(playerid, params[])
{
	new targetid;
	if( sscanf(params, "u", targetid) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ignoruj [id gracza/czêœæ nicku]");

	if( !IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ignoruj [id gracza/czêœæ nicku]");
	if( !pInfo[targetid][player_logged]) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ignoruj [id gracza/czêœæ nicku]");

	if(pInfo[playerid][player_ignore] == pGlobal[targetid][glo_id])
	{
		SendClientMessage(playerid, COLOR_GOLD, sprintf("Funkcja ignorowania gracza %s zosta³a wy³¹czona.", pInfo[targetid][player_name]));
		pInfo[playerid][player_ignore] = INVALID_PLAYER_ID;
	}
	else
	{
		SendClientMessage(playerid, COLOR_GOLD, sprintf("Funkcja ignorowania gracza %s zosta³a w³¹czona.", pInfo[targetid][player_name]));
		pInfo[playerid][player_ignore] = pGlobal[targetid][glo_id];
	}
	return 1;
}

COMMAND:cennik(playerid, params[])
{
	if(GetPlayerVirtualWorld(playerid) == 0) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnym biznesie.");
	new did = GetDoorByUid(GetPlayerVirtualWorld(playerid));
	if(did == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnym biznesie.");
	if(Door[did][door_owner_type] != DOOR_OWNER_TYPE_GROUP) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnym biznesie.");

	new gid = GetGroupByUid(Door[did][door_owner]);
	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnym biznesie.");
	if( !GroupHasFlag(gid, GROUP_FLAG_BUSINESS) ) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnym biznesie.");

	new list_items[512];

	foreach(new itemid: Items)
	{
		if(Item[itemid][item_owner_type] != ITEM_OWNER_TYPE_GROUP) continue;
		if(Item[itemid][item_owner] != Door[did][door_owner]) continue;

		format(list_items, sizeof(list_items), "%s\n%s\t$%d", list_items, Item[itemid][item_name], Item[itemid][item_price]);
	}

	if(strlen(list_items))
	{
		format(list_items, sizeof(list_items), "Produkt\tCena\n%s", list_items);
		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Oferta biznesu %s", Group[gid][group_name]), list_items, "OK", "");
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Ten biznes nie posiada produktów w swojej ofercie.");
	}
	return 1;
}

COMMAND:wyrzuc(playerid, params[])
{
	new targetid;
	if( sscanf(params, "u", targetid) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /wyrzuc [id gracza/czêœæ nicku]");

	if( !IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /wyrzuc [id gracza/czêœæ nicku]");
	if( !pInfo[targetid][player_logged]) return SendClientMessage(playerid, COLOR_GREY, "Tip: /wyrzuc [id gracza/czêœæ nicku]");

	if(GetPlayerVehicleID(playerid) == 0) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnym pojeŸdzie.");
	if(GetPlayerVehicleID(playerid) != GetPlayerVehicleID(targetid)) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie siedzi w twoim samochodzie.");
	if(GetPlayerVehicleSeat(playerid) != 0) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ kierowc¹ samochodu.");

	RemovePlayerFromVehicle(targetid);
	SendGuiInformation(targetid, "Informacja", "Zosta³eœ wyrzucony z pojazdu.");
	return 1;
}


COMMAND:pass(playerid, params[])
{
	new targetid, action[40];
	if( sscanf(params, "u", targetid) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /pass [id gracza/czêœæ nicku]");

	if( !IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /pass [id gracza/czêœæ nicku]");
	if( !pInfo[targetid][player_logged]) return SendClientMessage(playerid, COLOR_GREY, "Tip: /pass [id gracza/czêœæ nicku]");

	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz papierosa/napoju.");

	new Float:dist;
	dist = GetDistanceBetweenPlayers(playerid, targetid);
	if(dist > 3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");

	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_SMOKE_CIGGY)
	{
		format(action, sizeof(action), "Palenie");
	}
	else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DRINK_BEER || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DRINK_WINE || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DRINK_SPRUNK)
	{
		format(action, sizeof(action), "Picie");
	}

	if(strlen(action))
	{
		new resp = SetOffer(playerid, targetid, OFFER_TYPE_PASS, 0, GetPlayerSpecialAction(playerid));
    	if( resp ) ShowPlayerOffer(targetid, playerid, "Pass", action, 0);
    }
    else
    {
    	SendGuiInformation(playerid, "Informacja", "Nie posiadasz papierosa/napoju.");
    }
	return 1;
}

COMMAND:haracz(playerid, params[])
{
	new sub_cmd[20], rest[64];
	if( sscanf(params, "s[32]S()[80]", sub_cmd, rest) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /haracz [plac/opcje]");

	if( !strcmp(sub_cmd, "plac") )
	{	
		new gid = pInfo[playerid][player_duty_gid];
		if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie ¿adnej grupy.");
		new slot = GetPlayerDutySlot(playerid);
		if(slot == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie ¿adnej grupy.");

		if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnieñ do p³acenia haraczy w tym biznesie.");
		new targetid, price;
		if(sscanf(rest, "d", targetid, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /haracz plac [id gracza] [kwota]");
		if( !IsPlayerConnected(targetid) ) return SendGuiInformation(playerid, "Informacja", "Gracza o podanym id nie ma na serwerze.");
		if( !pInfo[targetid][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Gracz o podanym id nie jest zalogowany.");
		
		new tgid = pInfo[targetid][player_duty_gid];
		new Float:dist;
		dist = GetDistanceBetweenPlayers(playerid, targetid);
		if(dist>3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz jest za daleko.");

		if(!GroupHasFlag(tgid, GROUP_FLAG_BUSINESS)) return SendGuiInformation(playerid, "Informacja", "Tylko biznesy mog¹ p³aciæ haracze.");
        if(price <= 0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
        if(price > Group[gid][group_tribute]) return SendGuiInformation(playerid, "Informacja", "Ten biznes nie posiada odpowiedniego kapita³u przeznaczanego na haracz.");
        if(Group[gid][group_tributers] != Group[tgid][group_uid]) return SendGuiInformation(playerid, "Informacja", "Ta organizacja przestêpcza nie ma pod sob¹ twojego biznesu.");

        if(tgid == -1) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie jest na s³u¿bie organizacji przestêpczej.");
        if(Group[tgid][group_type] != GROUP_TYPE_GANG) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie jest na s³u¿bie organizacji przestêpczej.");

        new tslot = GetPlayerDutySlot(targetid);
        if(slot == -1) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie jest na s³u¿bie organizacji przestêpczej.");

        if( !WorkerHasFlag(targetid, tslot, WORKER_FLAG_OFFER) ) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie posiada uprawnieñ do ofert.");

        if(gettime() < Group[gid][group_last_tribute] + 168*3600 )
		{
			new nextpay = Group[gid][group_last_tribute] + 168*3600;
			new payHour, payMinute, payMonth, payDay, temp;

			TimestampToDate(nextpay, temp, payMonth, payDay, payHour, payMinute, temp, 1);
			if(payHour == 25)
			{
				SendGuiInformation(playerid, "Informacja", sprintf("Haracz z tej grupy by³ ju¿ w tym tygodniu pobrany.\nNastêpny mo¿esz pobraæ: %02d/%02d : 01:%02d.", payDay, payMonth, payHour, payMinute));
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", sprintf("Haracz z tej grupy by³ ju¿ w tym tygodniu pobrany.\nNastêpny mo¿esz pobraæ: %02d/%02d : %02d:%02d.", payDay, payMonth, payHour+1, payMinute));
			}
			return 1;
		}

        Group[gid][group_tribute] -= price;
        GivePlayerMoney(targetid, price);
        Group[gid][group_last_tribute] = gettime();

        mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_last_tribute = %d WHERE group_uid = %d", Group[gid][group_last_tribute], Group[gid][group_uid]));
	}
	else if( !strcmp(sub_cmd, "opcje") )
	{	
		new gid = pInfo[playerid][player_duty_gid];
		if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie ¿adnej grupy.");
		new slot = GetPlayerDutySlot(playerid);
		if(slot == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie ¿adnej grupy.");
		if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnieñ lidera.");
		if(Group[gid][group_type] != GROUP_TYPE_GANG) return SendGuiInformation(playerid, "Informacja", "Grupa na której jesteœ s³u¿bie nie mo¿e œci¹gaæ haraczy.");

		new list_tributes[256], rows, Cache:tmp_cache;
		tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT group_uid, group_name, group_tribute FROM ipb_game_groups WHERE group_tributers = %d", Group[gid][group_uid]));
		cache_get_row_count(rows);

		for(new row = 0; row != rows; row++)
		{
			new tmp[64], tmpid, tmpcash;
			cache_get_value_index(row, 1, tmp);
			cache_get_value_index_int(row, 0, tmpid);
			cache_get_value_index_int(row, 2, tmpcash);
			format(list_tributes, sizeof(list_tributes), "%s\n%d\t%s\t$%d", list_tributes, tmpid, tmp, tmpcash);
		}

		if(strlen(list_tributes))
		{
			format(list_tributes, sizeof(list_tributes), "UID:\tNazwa:\tBud¿et\n%s", list_tributes);
			ShowPlayerDialog(playerid, DIALOG_TRIBUTE_MENU, DIALOG_STYLE_TABLIST_HEADERS, "Lista œci¹ganych haraczy", list_tributes, "Wybierz", "Anuluj");
			new str[256];
			format(str, sizeof(str), "Lista, ktora wyswietlono zawiera wszystie biznesy jakie kontroluje twoja organizacja. Pole budzet odpowiada stanowi gotowki na haracze, ktora mozesz pobrac.~n~Aktualnie kontrolujesz: ~g~~h~%d~w~ biznesow.", rows);
			TextDrawSetString(Tutorial[playerid], str);
			TextDrawShowForPlayer(playerid, Tutorial[playerid]);
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "Twoja grupa nie pobiera ¿adnych haraczy.");
		}

		if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	}
	return 1;
}

COMMAND:gps(playerid, params[])
{
	new gid = pInfo[playerid][player_duty_gid];
    if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tej komendy.");
    if(!IsPlayerInAnyVehicle(playerid)) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnym pojeŸdzie.");

    if( Group[gid][group_type] == GROUP_TYPE_LSPD )
    {
    	if(pInfo[playerid][player_gps] == 0)
    	{
			pInfo[playerid][player_gps] = 1;
			SendGuiInformation(playerid, "Informacja", "GPS w³¹czony.");

			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);

			foreach(new police: Player)
			{
				if(pInfo[police][player_gps] == 1)
				{
					SetPlayerMapIcon(police, playerid, x, y, z, 30, 0);
				}
			}
		}
		else
		{
			pInfo[playerid][player_gps] = 0;
			SendGuiInformation(playerid, "Informacja", "GPS wy³¹czony.");

			for(new c;c<90;c++)
			{
				RemovePlayerMapIcon(playerid, c);
			}
		}
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tej komendy.");
	}
	return 1;
}

COMMAND:wywiad(playerid, params[])
{
	new gid = pInfo[playerid][player_duty_gid];
    if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tej komendy.");

    if( Group[gid][group_type] == GROUP_TYPE_SN )
    {
		new targetid;
		if( sscanf(params, "u", targetid) )
		{
			if(pInfo[playerid][player_interview] > -1)
			{
				foreach(new target: Player)
				{
					if(pInfo[target][player_interview] == pInfo[playerid][player_interview] && target != playerid)
					{
						pInfo[target][player_interview] = -1;
						SendClientMessage(target, COLOR_GOLD, "Wywiad zosta³ zakoñczony przez reportera.");
					}
				}

				pInfo[playerid][player_interview] = -1;
				SendClientMessage(playerid, COLOR_GOLD, "Wywiad zosta³ zakoñczony.");
			}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "Tip: /wywiad [id gracza/czêœæ nicku]");
			}
		}
		else
		{
			if(!IsPlayerConnected(targetid) || targetid==playerid) return SendClientMessage(playerid, COLOR_GREY, "Tip: Niepoprawne ID gracza.");
			if(!pInfo[targetid][player_logged]) return SendClientMessage(playerid, COLOR_GREY, "Tip: Niepoprawne ID gracza.");
			new Float:dist;
			dist = GetDistanceBetweenPlayers(playerid, targetid);
			if(dist > 3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");

			new resp = SetOffer(playerid, targetid, OFFER_TYPE_INTERVIEW, 0, 0);
	        if( resp ) ShowPlayerOffer(targetid, playerid, "Wywiad", "Wywiad na zywo", 0);
		}
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tej komendy.");
	}
	return 1;
}

COMMAND:trenuj(playerid, params[])
{
	new sub_cmd[20];
	
	if( sscanf(params, "s[32]", sub_cmd) )
	{
		if(pInfo[playerid][player_training] == false)
		{
			SendClientMessage(playerid, COLOR_GREY, "Tip: /trenuj [hantle]");
		}
		else
		{
			ApplyAnimation(playerid, "freeweights", "gym_free_putdown", 1, 0, 0, 0, 1, 0, 1 );
			SetCameraBehindPlayer(playerid);
			
			RemovePlayerAttachedObject(playerid, ATTACH_SLOT_GYM1);
			RemovePlayerAttachedObject(playerid, ATTACH_SLOT_GYM2);

			Object[pInfo[playerid][player_gym_object]][object_can_be_used] = false;

			pInfo[playerid][player_training] = false;
			TextDrawHideForPlayer(playerid, Tutorial[playerid]);
			FreezePlayer(playerid, 1000);
			mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_strength = '%f' WHERE char_uid = %d", pInfo[playerid][player_strength], pInfo[playerid][player_id]));
		}
		return 1;
	}
	else
	{
		if( !strcmp(sub_cmd, "hantle") )
		{
			if(pInfo[playerid][player_training] == true)
			{
				SendGuiInformation(playerid, "Informacja", "Jesteœ ju¿ w trakcie treningu, u¿yj /trenuj aby go zakoñczyæ.");
				return 1;
			}

			if( pInfo[playerid][player_gym_carnet] == 0)
			{
				SendGuiInformation(playerid, "Informacja", "Odby³eœ ju¿ dzisiaj trening.\nNastêpny mo¿esz wykonaæ jutro.");
				return 1;
			}

			new object_id = GetClosestObjectType(playerid, OBJECT_DUMB);

			if(object_id == INVALID_STREAMER_ID)
			{
				SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê przy hantlach.");
				return 1;
			}	

			if(GetPlayerUsedItem(playerid, ITEM_TYPE_GYM_KARNET ) == -1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz u¿ytego karnetu.");
			
			new did = GetDoorByUid(GetPlayerVirtualWorld(playerid));

			if(did == -1)
			{
				SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w si³owni.");
				return 1;
			}
			else
			{
				if(Door[did][door_owner_type] != DOOR_OWNER_TYPE_GROUP) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w si³owni w której kupi³eœ karnet.");
				if(pInfo[playerid][player_gym] != Door[did][door_owner]) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w si³owni w której kupi³eœ karnet.");
				if(Object[object_id][object_can_be_used] == true) return SendGuiInformation(playerid, "Informacja", "Ktoœ aktualnie æwiczy tymi hantlami.");

				SetPlayerPos(playerid, Object[object_id][object_pos][0]-1, Object[object_id][object_pos][1], Object[object_id][object_pos][2]+1);
				SetPlayerFacingAngle( playerid, Object[object_id][object_pos][3]);
				ApplyAnimation(playerid, "Freeweights", "gym_free_pickup", 1, 0, 0, 0, 1, 0, 1);

				SetPlayerCameraPos(playerid, Object[object_id][object_pos][0]+2.3, Object[object_id][object_pos][1], Object[object_id][object_pos][2]+0.3 );
				SetPlayerCameraLookAt( playerid, Object[object_id][object_pos][0], Object[object_id][object_pos][1], Object[object_id][object_pos][2]+0.5);

				Object[object_id][object_can_be_used] = false;
				pInfo[playerid][player_can_train] = 1;

				defer StartTraining[2500](playerid);
			}
		}
	}
	return 1;
}

COMMAND:opis(playerid, params[])
{
	DynamicGui_Init(playerid);
	new string[1000];
	
	if( !isnull(pInfo[playerid][player_description]) )
	{
		new str[256];
		strcopy(str, pInfo[playerid][player_description], 256);
		strdel(str, 48, 256);
		format(string, sizeof(string), "%s» Aktualny opis: {9A9CCD}%s...\n", string, str);
		DynamicGui_AddRow(playerid, DG_NO_ACTION);
		
		format(string, sizeof(string), "%s» Usuñ opis\n", string);
		DynamicGui_AddRow(playerid, DG_CHAR_DESC_DELETE);
	}
	else
	{
		format(string, sizeof(string), "%s» Ustaw opis\n", string);
		DynamicGui_AddRow(playerid, DG_CHAR_DESC_ADD);
	}

	format(string, sizeof(string), "%s\t\t\n", string);
	DynamicGui_AddBlankRow(playerid);
	format(string, sizeof(string), "%s{A9C4E4}10 ostatnich opisów:\n", string);
	DynamicGui_AddBlankRow(playerid);

	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT uid, text FROM `ipb_descriptions` WHERE `owner` = %d ORDER BY `last_used` DESC LIMIT 10", pInfo[playerid][player_id]));
	cache_get_row_count(rows);
	
	if( rows )
	{
		for(new row = 0; row != rows; row++)
		{
			new tmpText[256], tmpid;
			cache_get_value_index_int(row, 0, tmpid);
			cache_get_value_index(row, 1, tmpText);
			strdel(tmpText, 64, 256);
			format(string, sizeof(string), "%s  %d.   %s...\n", string, row+1, tmpText);
			DynamicGui_AddRow(playerid, DG_CHAR_DESC_OLD, tmpid);
		}
	}
	else 
	{
		format(string, sizeof(string), "%s  Brak zapisanych opisów\n", string);
		DynamicGui_AddBlankRow(playerid);
	}

	ShowPlayerDialog(playerid, DIALOG_CHAR_DESCRIPTION, DIALOG_STYLE_LIST, ""guiopis"Panel opisu postaci", string, "Wybierz", "Zamknij");
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	return 1;
}

COMMAND:salon(playerid, params[])
{
	if(!IsPlayerInCarDealer(playerid))
	{
		SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w salonie samochodowym.");
		return 1;
	}

	ShowPlayerDialog(playerid, DIALOG_SALON, DIALOG_STYLE_TABLIST_HEADERS, "Salon pojazdów", "Kategoria\tCeny\nTrzydrzwiowe\tod $1800\nPiêciodrzwiowe\tod $1500\nCiê¿arowe\tod $4000\nJednoœlady\tod $300\nSportowe\tod $15000\n£odzie\tod $4000\nLataj¹ce\tod $60000\nPremium\tod $7500", "Wybierz", "WyjdŸ");
	return 1;
}

COMMAND:serial(playerid, params[])
{
	SendGuiInformation(playerid, "Serial", sprintf("%s", pInfo[playerid][player_serial]));
	return 1;
}

COMMAND:mdc(playerid, params[])
{
	new gid = pInfo[playerid][player_duty_gid];
	if (gid == - 1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do centrum danych.");

	if(!IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerVirtualWorld(playerid) == 0) return SendGuiInformation(playerid, "Informacja", "Dostêp do MDC mo¿liwy jest tylko w pojazdach i budynkach.");
		return SendGuiInformation(playerid, "Informacja", "Dostêp do MDC mo¿liwy jest tylko w pojazdach i budynkach.");
	} 

	if(!GroupHasFlag(gid, GROUP_FLAG_911)) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do centrum danych.");
	ShowPlayerDialog(playerid, DIALOG_MDC, DIALOG_STYLE_LIST, "Mobile Data Computer", "1. ZnajdŸ osobê\n2. Baza DMV\n3. Lista poszukiwanych\n4. Nadaj APB\n5. Anuluj APB\n6. Panic Button", "Wybierz", "WyjdŸ");
	return 1;
}

COMMAND:bankomat(playerid, params[])
{
	new object_id = GetClosestObjectType(playerid, OBJECT_ATM);

	if(object_id == INVALID_STREAMER_ID)
	{
		SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê przy bankomacie.");
		return 1;
	}	

	ShowPlayerDialog(playerid, DIALOG_BANKOMAT ,DIALOG_STYLE_LIST, "Bankomat","1. Stan konta\n2. Wp³ata gotówki\n3. Wyp³ata gotówki", "Wybierz","Wyjdz");
	ApplyAnimation(playerid, "PED", "ATM", 4.0, 0, 0, 0, 0, 0, true);
	return 1;
}

COMMAND:obrazenia(playerid, params[])
{
	new targetid;

	if( sscanf(params, "u", targetid) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /obrazenia [playerid]");

	new list_injuries[500], header[40], gunname[32], time;

	for(new i=0;i<10;i++)
	{
		if( pInjury[targetid][i][injury_id] > 0 )
		{
			time = (gettime() - pInjury[targetid][i][injury_time])/60;
			GetWeaponName(pInjury[targetid][i][injury_weapon], gunname, sizeof(gunname));
			if(pInjury[targetid][i][injury_weapon] == 0) format(gunname, sizeof(gunname), "piêœæ");

			format(list_injuries, sizeof(list_injuries), "%s%d dmg z broni %s w %s %dmin temu\n", list_injuries, pInjury[targetid][i][injury_damage], gunname, GetBodyPartName(pInjury[targetid][i][injury_bodypart]), time);
		}
	}

	if(strlen(list_injuries) > 0)
	{
		format(header, sizeof(header), "Obra¿enia gracza %s", pInfo[targetid][player_name]);
		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, header, list_injuries, "OK", "");
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Ten gracz nie dozna³ ¿adnych obra¿eñ w ostatnim czasie.");
	}
	
	return 1;
}

COMMAND:zabierz(playerid, params[])
{
	new gid = pInfo[playerid][player_duty_gid];
	if (gid == - 1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z flag¹ do zabierania.");
	if(!GroupHasFlag(gid, GROUP_FLAG_TAKE)) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z flag¹ do zabierania.");

	new sub_cmd[20], rest[64], targetid;
	
	if( sscanf(params, "s[32]S()[80]", sub_cmd, rest) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /zabierz [id gracza] {iloœæ gotówki}");
		return 1;
	}
	else
	{
		if( !strcmp(sub_cmd, "prawko") )
		{
			if(!GroupHasFlag(gid, GROUP_FLAG_911)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnieñ do zabieranie prawa jazdy.");
			if(sscanf(rest, "d", targetid)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /zabierz prawko [id gracza]");
			if(!IsPlayerConnected(targetid)||targetid==playerid) return SendClientMessage(playerid, COLOR_GREY, "Tip: Niepoprawne ID gracza.");

			if(GetDistanceBetweenPlayers(playerid, targetid) > 3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");

			pInfo[targetid][player_documents] -= DOCUMENT_DRIVE;
			mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_documents = %d WHERE char_uid = %d", pInfo[targetid][player_documents], pInfo[targetid][player_id]));

			SendGuiInformation(playerid, "Informacja", sprintf("Odebra³eœ prawo jazdy graczowi %s.", pInfo[targetid][player_name]));
			SendClientMessage(targetid, COLOR_LIGHTER_GREEN, sprintf("Gracz %s odebra³ ci prawo jazdy.", pInfo[playerid][player_name]));
			return 1;
		}

		if(sscanf(sub_cmd, "d", targetid)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /zabierz [id gracza] {iloœæ gotówki}");
		if(!IsPlayerConnected(targetid)||targetid==playerid) return SendClientMessage(playerid, COLOR_GREY, "Tip: Niepoprawne ID gracza.");

		if(GetDistanceBetweenPlayers(playerid, targetid) > 3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");
		if(pInfo[targetid][player_bw] == 0) return SendGuiInformation(playerid, "Informacja", "Ten gracz jest przytomny.");

		new a_id = pInfo[playerid][player_area];

		if(!GroupHasFlag(gid, GROUP_FLAG_911) )
		{
			if(a_id == -1) return SendGuiInformation(playerid, "Informacja", "Strefa w której siê znajdujesz nie nale¿y do twojej grupy.");
			if(Area[a_id][area_owner] != Group[gid][group_uid]) return SendGuiInformation(playerid, "Informacja", "Strefa w której siê znajdujesz nie nale¿y do twojej grupy.");
		}

		new amount; 

		if(!sscanf(rest, "d", amount) && !GroupHasFlag(gid, GROUP_FLAG_911) )
		{
			if(amount <= 0) return 1;
			if(amount > pInfo[targetid][player_money]) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie posiada takiej iloœci gotówki.");

			GivePlayerMoney(targetid, -amount);
			GivePlayerMoney(playerid, amount);

			SendGuiInformation(playerid, "Informacja", sprintf("Odebra³eœ graczowi %s $%d.", pInfo[targetid][player_name], amount));
			SendClientMessage(targetid, COLOR_LIGHTER_GREEN, sprintf("Gracz %s odebra³ ci $%d.", pInfo[playerid][player_name], amount));

			return 1;
		}

		new count, string[1024], header[64];
		
		DynamicGui_Init(playerid);
		
		format(string, sizeof(string), "%sNazwa\tWaga\tUID\n", string);
		format(header, sizeof(header), "Lista przedmiotów %s ($%d)", pInfo[targetid][player_name], pInfo[targetid][player_money]);

		DynamicGui_SetDialogValue(playerid, targetid);

		foreach (new item : PlayerItems[targetid])
		{
			new prefix[16]; 
			if( PlayerItem[targetid][item][player_item_used] ) prefix = "{D6EE76}";

			format(string, sizeof(string), "%s %s%s\t%dg\t%d\n", string, prefix, PlayerItem[targetid][item][player_item_name],PlayerItem[targetid][item][player_item_weight], PlayerItem[targetid][item][player_item_uid]);
			DynamicGui_AddRow(playerid, item);	
			count++;
		}
		
		if( count == 0 ) SendGuiInformation(playerid, "Informacja", sprintf("Ten gracz nie posiada przy sobie ¿adnych przedmiotów\nGotówka: $%d.", pInfo[targetid][player_money]));
		else ShowPlayerDialog(playerid, DIALOG_TAKE, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Zabierz", "Anuluj");
	}
	return 1;
}

COMMAND:audio(playerid, params[])
{
	SendGuiInformation(playerid, "Informacja", "Strumieñ audio zosta³ wy³¹czony.");
    StopAudioStreamForPlayer(playerid);
    return 1;
}

COMMAND:silnik(playerid, params[])
{
    new vid = GetPlayerVehicleID(playerid);
    if(vid == INVALID_VEHICLE_ID) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnym pojeŸdzie.");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ kierowc¹ pojazdu");
    if( !CanPlayerUseVehicle(playerid, vid) ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnieñ do odpalenia tego pojazdu.");
    if( Vehicle[vid][vehicle_engine] )
    {
        new model = GetVehicleModel(vid);
        if(model == 509 || model == 510 || model == 481)
        {
            return 1;
        }

        // Gaszenie silnika
        if( CanPlayerUseVehicle(playerid, vid) ) TextDrawShowForPlayer(playerid, vehicleInfo);
        Vehicle[vid][vehicle_engine] = false;
        SaveVehicle(vid);
        UpdateVehicleVisuals(vid);
    }
    else
    {
        new model = GetVehicleModel(vid);
        if(model == 509 || model == 510 || model == 481)
        {
            return 1;
        }
        
        // Odpalanie silnika
        if( Vehicle[vid][vehicle_state] > 0 ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Na tym pojeŸdzie przeprowadzana jest aktualnie jakaœ akcja. Aby go odpaliæ poczekaj do jej ukoñczenia.");
        if( Vehicle[vid][vehicle_destroyed] == true)
		{
			RemovePlayerFromVehicle(playerid);
			SendGuiInformation(playerid, "Informacja", "Ten pojazd jest ca³kowicie zniszczony, silnik nie nadaje sie do odpalenia.");
			return 1;
		}
        if( Vehicle[vid][vehicle_blocked] != 0) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", sprintf("Ten pojazd posiada blokadê na ko³o.\nPowód: %s, kwota: $%d", Vehicle[vid][vehicle_block_reason], Vehicle[vid][vehicle_blocked]));
        if( Vehicle[vid][vehicle_fuel_current] == 0.0 ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "W baku tego pojazdu nie ma paliwa.");

        Vehicle[vid][vehicle_engine_starting] = true;

        defer VehicleEngineStart[2000](playerid, vid);

        GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Uruchamianie ~y~silnika~w~...",2000,3);
    }
    return 1;
}

COMMAND:wyscig(playerid, params[])
{
	new gid = pInfo[playerid][player_duty_gid];
	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do wyœcigów.");
	if(!GroupHasFlag(gid, GROUP_FLAG_RACES)) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do wyœcigów.");

	new type[32], varchar[32], string[220];
	if(sscanf(params, "s[32]S()[32]", type, varchar))
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /wyscig [stworz/zapros/wypros/start/zakoncz]");
	    return 1;
	}
	if(!strcmp(type, "stworz", true))
	{
	    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    {
	        SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w pojeŸdzie.");
	        return 1;
	    }
	    if(pInfo[playerid][player_race_phase])
	    {
	       	SendGuiInformation(playerid, "Informacja", "Aktualnie tworzysz ju¿ jakiœ wyœcig.");
	        return 1;
	    }

	    foreach(new p: Player)
	    {
	        if(pInfo[p][player_logged])
	        {
	            if(pInfo[p][player_race_phase])
	            {
	               	SendGuiInformation(playerid, "Informacja", "Obecnie trwa ju¿ jakiœ wyœcig.");
	                return 1;
	            }
	        }
	    }
	    format(string, sizeof(string), "Rozpoczales ~y~proces ~w~tworzenia wyscigu~w~~n~~n~~y~~k~~VEHICLE_FIREWEAPON~ ~w~- ustawianie checkpointa~n~~y~SPACE ~w~- ustalanie linii mety~n~~n~Checkpointy: ~y~%d/%d", pInfo[playerid][player_race_point], MAX_RACE_CP);

		TextDrawSetString(Tutorial[playerid], string);
		TextDrawShowForPlayer(playerid, Tutorial[playerid]);

		pInfo[playerid][player_race_phase] = 1;
		pInfo[playerid][player_race_point] = 0;

		SendGuiInformation(playerid, "Informacja", "Rozpoczêto proces tworzenia wyœcigu.");
	    return 1;
	}
	if(!strcmp(type, "zapros", true))
	{
	    if(pInfo[playerid][player_race_phase] != 2)
	    {
	        SendGuiInformation(playerid, "Informacja", "Nie mo¿esz teraz zapraszaæ rywali.");
	        return 1;
	    }
	    new giveplayer_id;
		if(sscanf(varchar, "d", giveplayer_id))
		{
		    SendClientMessage(playerid, COLOR_GREY, "Tip: /wyscig zapros [ID gracza]");
		    return 1;
		}
  		if(giveplayer_id == playerid)
    	{
     		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", "Nie mo¿esz zaprosiæ do wyœcigu samego siebie.", "Okej", "");
       		return 1;
     	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
   			return 1;
		}
		if(pInfo[giveplayer_id][player_race_phase])
		{
		    SendGuiInformation(playerid, "Informacja", "Ten gracz bierze ju¿ udzia³ w wyœcigu.");
		    return 1;
		}
		pInfo[giveplayer_id][player_race_phase] = 2;
		pInfo[giveplayer_id][player_race_point] = 0;

		pInfo[giveplayer_id][player_race_checkpoints] = pInfo[playerid][player_race_checkpoints];

		format(string, sizeof(string), "Gracz %s zosta³ zaproszony do wyœcigu.", pInfo[giveplayer_id][player_name]);
		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", string, "Okej", "");

		format(string, sizeof(string), "Gracz %s zaprosi³ Ciê do wyœcigu.", pInfo[playerid][player_name]);
		ShowPlayerDialog(giveplayer_id, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", string, "Okej", "");
	    return 1;
	}
	if(!strcmp(type, "wypros", true))
	{
 		if(pInfo[playerid][player_race_phase] != 2)
	    {
	        ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", "Nie mo¿esz teraz wypraszaæ rywali.", "Okej", "");
	        return 1;
	    }
	    new giveplayer_id;
		if(sscanf(varchar, "d", giveplayer_id))
		{
		    SendClientMessage(playerid, COLOR_GREY, "Tip: /wyscig wypros [ID gracza]");
		    return 1;
		}
  		if(giveplayer_id == playerid)
    	{
     		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", "Nie mo¿esz zaprosiæ do wyœcigu siebie.", "Okej", "");
       		return 1;
     	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", "Podano b³êdne ID gracza.", "Okej", "");
   			return 1;
		}
		if(!pInfo[giveplayer_id][player_logged])
		{
  			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", "Gracz o podanym ID nie jest zalogowany.", "Okej", "");
	    	return 1;
		}
		if(!pInfo[giveplayer_id][player_race_phase])
		{
		    ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", "Ten gracz nie bierze udzia³u w ¿adnym wyœcigu.", "Okej", "");
		    return 1;
		}
		pInfo[giveplayer_id][player_race_phase] = 0;
		pInfo[giveplayer_id][player_race_point] = 0;

		pInfo[giveplayer_id][player_race_checkpoints] = 0;

		format(string, sizeof(string), "Gracz %s zosta³ wyproszony z wyœcigu.", pInfo[giveplayer_id][player_name]);
		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", string, "Okej", "");

		format(string, sizeof(string), "Gracz %s wyprosi³ Ciê z wyœcigu.", pInfo[playerid][player_name]);
		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", string, "Okej", "");
	    return 1;
	}
	if(!strcmp(type, "start", true))
	{
	    if(pInfo[playerid][player_race_phase] != 2)
	    {
	        ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", "Nie mo¿esz teraz rozpocz¹æ wyœcigu.", "Okej", "");
	        return 1;
	    }

	    foreach(new p: Player)
	    {
            if(pInfo[p][player_race_phase] == 2)
            {
               	pInfo[p][player_race_count] = 4;
    			pInfo[p][player_race_phase] = 3;
			    pInfo[p][player_race_point] = 0;
			    TogglePlayerControllable(p, 0);

				SetPlayerRaceCheckpoint(p, 0, RaceCheckpoint[0][0], RaceCheckpoint[0][1], RaceCheckpoint[0][2], RaceCheckpoint[1][0], RaceCheckpoint[1][1], RaceCheckpoint[1][2], 5.0);
			}
		}
		return 1;
	}
	if(!strcmp(type, "zakoncz", true))
	{
	    if(pInfo[playerid][player_race_phase] != 2)
	    {
	        ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", "Nie mo¿esz teraz zakoñczyæ wyœcigu.", "Okej", "");
	        return 1;
	    }

	    foreach(new p: Player)
	    {
	        if(pInfo[p][player_logged])
	        {
	            if(pInfo[p][player_race_phase] != 0)
	            {
	                DisablePlayerRaceCheckpoint(p);

	                pInfo[p][player_race_phase] = 0;
	                pInfo[p][player_race_point] = 0;

	                pInfo[p][player_race_checkpoints] = 0;
	            }
	        }
	    }

	    SendGuiInformation(playerid, "Informacja", "Wyœcig zosta³ zakoñczony.");
	}
	return 1;
}

COMMAND:zwiaz(playerid, params[])
{
    new target;
    if(sscanf(params, "d", target))
    {
        SendClientMessage(playerid, COLOR_GREY, "Tip: /zwiaz [id gracza]");
        return 1;
    }
 
    if( !pInfo[target][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
    if( playerid == target) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
 
    if(GetPlayerUsedItem(playerid, ITEM_TYPE_ROPE) == -1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz w u¿yciu sznura.");
 
    new Float:dist;
    dist = GetDistanceBetweenPlayers(playerid, target);
 
    if(dist>3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz jest za daleko.");
 
    if(GetPlayerSpecialAction(target) == SPECIAL_ACTION_CUFFED)
    {
        SetPlayerSpecialAction(target, SPECIAL_ACTION_NONE);
        SendGuiInformation(playerid, "Informacja", "Gracz zosta³ rozwi¹zany.");
    }
    else
    {
        SetPlayerSpecialAction(target, SPECIAL_ACTION_CUFFED);
        SendGuiInformation(playerid, "Informacja", "Gracz zosta³ zwi¹zany.");
    }
 
    return 1;
}

COMMAND:as(playerid, params[])
{
	return ClearAnimations(playerid);
}

/*COMMAND:r(playerid, params[])
{
	new slot, text[128];
	if(sscanf(params, "ds[128]", slot, text)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /r [slot] [text]");
	if(slot > 5 || slot < 1) return SendClientMessage(playerid, COLOR_GREY, "Tip: /r [slot] [text]");

	SendGroupIC(playerid, slot, text);
	return 1;
}*/

COMMAND:lider(playerid, params[])
{
	new sub_cmd[40], param[150];
	new slot = GetPlayerDutySlot(playerid);
	if(slot == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie ¿adnej grupy.");
	if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ liderem grupy na której jesteœ s³u¿bie.");
	new gid = pInfo[playerid][player_duty_gid];
	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie ¿adnej grupy.");

	if( sscanf(params, "s[40] S()[150]", sub_cmd, param) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /lider [cena/tag]");

	if( !strcmp(sub_cmd, "cena") )
	{	
		new price, id;
		if( sscanf(param, "dd", id, price) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /lider cena [uid produktu] [cena]");

		if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy przypisanej pod ten produkt.");
		new prod_id = GetGroupItemByUid(id);
		if(prod_id == -1) return SendGuiInformation(playerid, "Informacja", "Niepoprawne UID produktu.");
		if(Item[prod_id][item_owner_type] != ITEM_OWNER_TYPE_GROUP) return SendGuiInformation(playerid, "Informacja", "Niepoprawne UID produktu.");
		if(Item[prod_id][item_owner] != Group[gid][group_uid]) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy przypisanej pod ten produkt.");
		if(!WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return SendGuiInformation(playerid, "Informacja", "Brak uprawnieñ do edycji cen produktów.");
		if(price < 0 ) return SendGuiInformation(playerid, "Informacja", "Nieprawid³owa cena.");
		Item[prod_id][item_price] = price;

		mysql_query(mySQLconnection, sprintf("UPDATE `ipb_items` SET `item_price` = '%d' WHERE `item_uid` = %d", price, Item[prod_id][item_uid]));
		SendGuiInformation(playerid, "Informacja", "Cena produktu zosta³a pomyœlnie edytowana.");
	}
	else if( !strcmp(sub_cmd, "tag") )
	{
		new tag[6];
		if( sscanf(param, "s[6]", tag) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /lider tag [tag grupy (max 6 znaków)]");
		mysql_query(mySQLconnection, sprintf("UPDATE `ipb_game_groups` SET `group_tag` = '%s' WHERE `group_uid` = %d", tag, Group[gid][group_uid]));
		SendGuiInformation(playerid, "Informacja", "Tag grupy zmieniony.");
	}
	else if( !strcmp(sub_cmd, "kolor") )
	{
		new color[16];
		if( sscanf(param, "s[16]",  color) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /lider kolor [HEX]");
		if(!ishex(color))  return SendClientMessage(playerid, COLOR_GREY, "Tip: /lider kolor [HEX]");
		
		format(color, sizeof(color), "0x%sDD", color);
		mysql_query(mySQLconnection, sprintf("UPDATE `ipb_game_groups` SET `group_color` = '%d' WHERE `group_uid` = %d", hexstring(color), Group[gid][group_uid]));
		SendGuiInformation(playerid, "Informacja", "Kolor grupy zosta³ zmieniony.");
	}
	return 1;
}

COMMAND:ro(playerid, params[])
{
	new slot, text[128];
	if(sscanf(params, "ds[128]", slot, text)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ro [slot] [text]");
	if(slot > 5 || slot < 1) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ro [slot] [text]");
	SendGroupOOC(playerid, slot, text);
	return 1;
}

COMMAND:pokaz(playerid, params[])
{
	new id, text[64];
	if(sscanf(params, "s[64]d", text, id)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /pokaz [prawko/dowod] [id gracza]");
	if( !IsPlayerConnected(id) ) return SendGuiInformation(playerid, "Informacja", "Gracza o podanym id nie ma na serwerze.");
	if( !pInfo[id][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Gracz o podanym id nie jest zalogowany.");
	new Float:dist;
	dist = GetDistanceBetweenPlayers(playerid, id);
	if(dist>3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz jest za daleko.");

	if( !strcmp(text, "prawko") )
	{	
		if(!(pInfo[playerid][player_documents] & DOCUMENT_DRIVE)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz prawa jazdy.");
		SendGuiInformation(id, "Prawo jazdy", sprintf("Imie i nazwisko: %s\nData urodzenia: %d", pInfo[playerid][player_name], pInfo[playerid][player_age]));
		ProxMessage(playerid, sprintf("pokazuje prawo jazdy %s.", pInfo[id][player_name]), PROX_SERWERME);
	}
	else if( !strcmp(text, "dowod") )
	{	
		if(!(pInfo[playerid][player_documents] & DOCUMENT_ID)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz dowodu osobistego.");
		SendGuiInformation(id, "Dowod osobisty", sprintf("Imie i nazwisko: %s\nData urodzenia: %d", pInfo[playerid][player_name], pInfo[playerid][player_age]));
		ProxMessage(playerid, sprintf("pokazuje dowod osobisty %s.", pInfo[id][player_name]), PROX_SERWERME);
	}
	else if( !strcmp(text, "odznaka") )
	{	
		new gid = GetGroupByUid(5);
		if(pInfo[playerid][player_duty_gid] != gid ) return SendGuiInformation(playerid, "Informacja", "Nie jestes na sluzbie LSPD.");
		SendGuiInformation(id, "Odznaka funkcjonariusza", sprintf("Imie i nazwisko: %s\nData urodzenia: %d", pInfo[playerid][player_name], pInfo[playerid][player_age]));
		ProxMessage(playerid, sprintf("pokazuje odznake %s.", pInfo[id][player_name]), PROX_SERWERME);
	}
	else if( !strcmp(text, "licencja") )
	{	
		if(!(pInfo[playerid][player_documents] & DOCUMENT_WEAPON)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz licencji na broñ.");
		SendGuiInformation(id, "Licencja na broñ", sprintf("Imie i nazwisko: %s\nData urodzenia: %d", pInfo[playerid][player_name], pInfo[playerid][player_age]));
		ProxMessage(playerid, sprintf("pokazuje licencje na broñ %s.", pInfo[id][player_name]), PROX_SERWERME);
	}
	return 1;
}

/*COMMAND:truck(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, -74.2711,-1131.7954,1.6705))
	{
		SendGuiInformation(playerid, "Informacja", "Nie znajdujesz sie w bazie truckerów, zostala ona oznaczona na mapie.");
		SetPlayerMapIcon(playerid, 13, -74.2711,-1131.7954,1.6705, 0, 0xFF0000AA, MAPICON_GLOBAL);
		return 1;
	}
	if(pInfo[playerid][player_job] == WORK_TYPE_TRUCKER) 
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(!IsTrailerAttachedToVehicle(vehicleid))
			{
			   SendGuiInformation(playerid, "Informacja", "Ten pojazd nie posiada przyczepy, doczep ja.");
			   return 1;
			}
			pInfo[playerid][player_truck]=1;
			SendPlayerInformation(playerid, "Praca rozpoczeta, dowiez towar na miejsce (~y~czerwony checkpoint~w~).", 8000);
			new randomss;
	        randomss = random(sizeof(TruckPoints));
	        SetPlayerCheckpoint(playerid, TruckPoints[randomss][0], TruckPoints[randomss][1], TruckPoints[randomss][2], 5.0);
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "Nie siedzisz w pojezdzie.");
		}
	}
	return 1;
}*/

//todo odblokowac
/*COMMAND:kogut(playerid, params[])
{
	new gid = pInfo[playerid][player_duty_gid];
	if(gid == -1)
	{
		SendGuiInformation(playerid, "Informacja", "Nie jesteœ na duty ¿adnej grupy.");
		return 1;
	}
    if(!(Group[gid][group_flags] & GROUP_FLAG_SEARCH))
    {
	  	SendGuiInformation(playerid, "Informacja", "Brak uprawnieñ do u¿ywania komendy lub nie jesteœ na s³u¿bie grupy.");
    	return 1;
    }
    new vid = GetPlayerVehicleID(playerid);
    if(vid == INVALID_VEHICLE_ID) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz sie w ¿adnym pojeŸdzie.");
    if(Vehicle[vid][vehicle_owner] != Group[gid][group_uid]) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz sie w pojeŸdzie podpisanym pod grupê na której jesteœ s³u¿bie.");

    if(Vehicle[vid][vehicle_siren] == false)
    {
		Vehicle[vid][vehicle_siren_object] = CreateDynamicObject(18646, 10.0, 10.0, 10.0, 0, 0, 0);
	 	AttachDynamicObjectToVehicle(Vehicle[vid][vehicle_siren_object], vid, -0.0, -0.39, attInfo[GetVehicleModel(vid) - 400][_attPos], 0.0, 0.0, 0.0);
	 	Vehicle[vid][vehicle_siren] = true;
	}
	else
	{
		DestroyDynamicObject(Vehicle[vid][vehicle_siren_object]);
		Vehicle[vid][vehicle_siren_object] = INVALID_STREAMER_ID;
		Vehicle[vid][vehicle_siren] = false;
	}
 	return 1;
}*/

COMMAND:przeszukaj(playerid, params[])
{
	new gid = pInfo[playerid][player_duty_gid];

	if(gid == -1)
	{
		SendGuiInformation(playerid, "Informacja", "Nie jestes na duty zadnej grupy.");
		return 1;
	}
	
    if( !GroupHasFlag(gid, GROUP_FLAG_SEARCH) )
    {
	  	SendGuiInformation(playerid, "Informacja", "Brak uprawnieñ do u¿ywania komendy lub nie jesteœ na s³u¿bie grupy.");
    	return 1;
    }
    else
    {
    	new id;
    	if(sscanf(params, "d", id)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /przeszukaj [id gracza]");
    	if( (!IsPlayerConnected(id) || !pInfo[id][player_logged]) ) return SendClientMessage(playerid, COLOR_GREY, "Ten gracz nie jest zalogowany.");

    	new Float:dist;
		dist = GetDistanceBetweenPlayers(playerid, id);

		if(dist>3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz jest za daleko.");

		new count, string[1024];

		ProxMessage(playerid, sprintf("przeszukuje %s.", pInfo[id][player_name]), PROX_ME);
		
		DynamicGui_Init(playerid);
		
		format(string, sizeof(string), "%s{C0C0C0}Przedmioty znajduj¹ce siê przy graczu: (%d$)\n", string, pInfo[id][player_money]);
		DynamicGui_AddBlankRow(playerid);
		
		foreach (new item : PlayerItems[id])
		{
			new prefix[10]; 
			if( PlayerItem[id][item][player_item_used] ) prefix = "{CFFD66}";
			
			format(string, sizeof(string), "%s %s%s\t\t%d %d  (%d:%d)\n", string, prefix, PlayerItem[id][item][player_item_name], PlayerItem[id][item][player_item_uid], PlayerItem[id][item][player_item_type], PlayerItem[id][item][player_item_value1], PlayerItem[id][item][player_item_value2]);
			DynamicGui_AddRow(playerid, DG_ITEMS_ITEM_ROW, item);	
			count++;
		}
		
		if( count == 0 ) SendGuiInformation(playerid, "Informacja", "Ten gracz nie posiada przedmiotów.");
		else ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, "Przedmioty gracza", string, "Okej", "WyjdŸ");

    }
	return 1;
}

COMMAND:news(playerid, params[])
{
	new gid = pInfo[playerid][player_duty_gid];
    new text[170];
    if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tej komendy.");

    if( Group[gid][group_type] == GROUP_TYPE_SN )
    {
		if(sscanf(params, "s[150]", text))
		{
			foreach(new p: Player)
			{
				if(pInfo[p][player_radio] == gid)
				{
					PlayerTextDrawSetString(p, TextDrawSanNews[p], sprintf("_~w~%s ~>~ Aktualnie nic nie jest nadawane w tej stacji.", Group[gid][group_name]));
				}
			}
		 	SendClientMessage(playerid, COLOR_GREY, "Tip: /news [wiadomoœæ]");
		 	return 1;
		}
		
		if(!CheckTextDrawString(text)) return SendGuiInformation(playerid, "Informacja", "W tej wiadomoœci nie mog¹ znajdowaæ siê dwie ~ obok siebie.");

		EscapePL(text);

		sscanf(text, "s[128]", Group[gid][group_radio_text]);
		sscanf(pInfo[playerid][player_name], "s[32]", Group[gid][group_radio_sender]);
		
		Group[gid][group_news_type] = 1;

		foreach(new p: Player)
		{
			if(pInfo[p][player_radio] == gid)
			{
				PlayerTextDrawSetString(p, TextDrawSanNews[p], sprintf("_~w~%s ~>~ ~y~%s~w~ ~>~ %s", Group[gid][group_name], pInfo[playerid][player_name], Group[gid][group_radio_text]));
			}
		}

		last_radio = gid;
		
    } 
    else 
    {
    	SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tej komendy.");
    }
	return 1;
}

COMMAND:reklama(playerid, params[])
{
	new gid = pInfo[playerid][player_duty_gid];
    new text[170];
    if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tej komendy.");

    if( Group[gid][group_type] == GROUP_TYPE_SN )
    {
		if(sscanf(params, "s[150]", text))
		{
			foreach(new p: Player)
			{
				if(pInfo[p][player_radio] == gid)
				{
					PlayerTextDrawSetString(p, TextDrawSanNews[p], sprintf("_~w~%s ~>~ Aktualnie nic nie jest nadawane w tej stacji.", Group[gid][group_name]));
				}
			}
		 	SendClientMessage(playerid, COLOR_GREY, "Tip: /reklama [wiadomoœæ]");
		 	return 1;
		}
		
		if(!CheckTextDrawString(text)) return SendGuiInformation(playerid, "Informacja", "W tej wiadomoœci nie mog¹ znajdowaæ siê dwie ~ obok siebie.");
		if(Group[gid][group_advert_time] != 0 && Group[gid][group_advert_time] > gettime()) return SendGuiInformation(playerid, "Informacja", "Od czasu ostatniej reklamy nie minê³o 20 sekund.");
		
		EscapePL(text);
		sscanf(text, "s[128]", Group[gid][group_radio_text]);

		Group[gid][group_advert_time] = gettime() + 20;
		Group[gid][group_news_type] = 2;

		foreach(new p: Player)
		{
			if(pInfo[p][player_radio] == gid)
			{
				PlayerTextDrawSetString(p, TextDrawSanNews[p], sprintf("_~w~%s ~>~ ~g~~h~Reklama~w~ ~>~ %s", Group[gid][group_name], Group[gid][group_radio_text]));
			}
		}

		last_radio = gid;
		
    } 
    else 
    {
    	SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tej komendy.");
    }
	return 1;
}

COMMAND:id(playerid, params[])
{
	new nick[24], list_players[256];
    if(sscanf(params, "s[24]", nick))
	{
        SendClientMessage(playerid, COLOR_GREY, "Tip: /id [nick]");
		return 1;
    }
	if(strlen(nick) < 3)
	{
		SendGuiInformation(playerid, "Informacja", "Musisz podaæ conajmniej 3 litery nicku.");
		return 1;
	}

	foreach(new i: Player)
   	{
   		if(pInfo[i][player_admin_duty]) continue;

   	    new name[24];
		GetPlayerName(i, name, sizeof(name));
        if(strfind(name, nick, true) >= 0)
		{
			if( GetPlayerUsedItem(i, ITEM_TYPE_MASKA) > -1 ) format(list_players, sizeof(list_players), "%s\n%s", list_players, pInfo[i][player_name]);
			else format(list_players, sizeof(list_players), "%s\n%d\t%s", list_players, i, pInfo[i][player_name]);
		}
    }
    
	if(strlen(list_players))
	{
	    ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, "Wyniki wyszukiwania:", list_players, "Okej", "Zamknij");
	}
	else
	{
	    SendGuiInformation(playerid, "Informacja", "B³¹d, nie znaleziono ¿adnego gracza spe³niaj¹cego kryteria.");
	}
    return 1;
}

COMMAND:ame(playerid, params[])
{
	new text[128], str[174];
	if( sscanf(params, "s[128]", text) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /ame [tekst]");
		return 1;
	}
	else
	{
		format(str, sizeof(str), "* %s %s", pInfo[playerid][player_name], text);
		SetPlayerChatBubble(playerid, str, 0xBAA9CDFF, 7.0, 6000);
		SendClientMessage(playerid, 0xB58ADAFF, str);
	}
	return 1;
}

COMMAND:wyjdz(playerid, params[])
{
	new ds_id = -1;

	foreach(new d : Doors)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_spawn_pos][0],  Door[d][door_spawn_pos][1], Door[d][door_spawn_pos][2]) && GetPlayerVirtualWorld(playerid) == Door[d][door_spawn_vw])
		{
			ds_id = d;
		}
	}
	
	if( ds_id != -1 )
	{
		if( Door[ds_id][door_closed] ) return SendClientMessage(playerid, COLOR_GREY, "Te drzwi s¹ zamkniête.");
		
		FreezePlayer(playerid, 2500);
		
		RP_PLUS_SetPlayerPos(playerid, Door[ds_id][door_pos][0], Door[ds_id][door_pos][1], Door[ds_id][door_pos][2]);
		SetPlayerFacingAngle(playerid, Door[ds_id][door_pos][3]);
		
		SetCameraBehindPlayer(playerid);
		
		SetPlayerVirtualWorld(playerid, Door[ds_id][door_vw]);
		SetPlayerInterior(playerid, Door[ds_id][door_int]);
	}
	return 1;
}

COMMAND:wejdz(playerid, params[])
{
	new d_id = -1;

	foreach(new d : Doors)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]) && GetPlayerVirtualWorld(playerid) == Door[d][door_vw])
		{
			d_id = d;
		}
	}
	
	if( d_id != -1 )
	{

		if( Door[d_id][door_closed] ) return SendClientMessage(playerid, COLOR_GREY, "Te drzwi s¹ zamkniête.");
		
		if( Door[d_id][door_payment] > 0 )
		{
			if( Door[d_id][door_payment] > pInfo[playerid][player_money] ) return SendClientMessage(playerid, COLOR_GREY, "Nie masz wystarczajacej iloœci gotówki, aby wejœæ do budynku.");
			
			GivePlayerMoney(playerid, -Door[d_id][door_payment]);
			new gid = Door[d_id][door_owner];
			if(gid == -1) return 1;
			Group[gid][group_bank_money] += Door[d_id][door_payment];
		}
		
		FreezePlayer(playerid, 2500);
		
		RP_PLUS_SetPlayerPos(playerid, Door[d_id][door_spawn_pos][0], Door[d_id][door_spawn_pos][1], Door[d_id][door_spawn_pos][2]);
		SetPlayerFacingAngle(playerid, Door[d_id][door_spawn_pos][3]);
		
		SetCameraBehindPlayer(playerid);
		
		SetPlayerVirtualWorld(playerid, Door[d_id][door_spawn_vw]);
		SetPlayerInterior(playerid, Door[d_id][door_spawn_int]);
	}
	return 1;
}

COMMAND:d(playerid, params[]) 
{
	new text[128];
	new gid = pInfo[playerid][player_duty_gid];

	if(gid == -1)
	{
		SendGuiInformation(playerid, "Informacja", "Aby móc korzystaæ z tego czatu musisz znajdowaæ siê na s³u¿bie grupy.");
		return 1;
	}

	if(!(Group[gid][group_flags] & GROUP_FLAG_DEP))
	{
		SendGuiInformation(playerid, "Informacja", "Grupa, na której s³u¿bie aktualnie przebywasz, nie posiada uprawnieñ do czatu departamentowego.");
		return 1;
	}

	if( sscanf(params, "s[128]", text) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /d [tekst]");
		return 1;
	}
	else
	{
		new tag[15];
		tag = GetGroupTag(pInfo[playerid][player_duty_gid]);

		foreach(new pid : Player)
		{
			if(pInfo[pid][player_duty_gid] > 0)
			{
				if(Group[pInfo[pid][player_duty_gid]][group_flags] & GROUP_FLAG_DEP)
				{
					SendClientMessage(pid, COLOR_LIGHTER_RED, sprintf("[%s] %s (radio dep.): %s", tag, pInfo[playerid][player_name], text));
				}
			}
		}
		ProxMessage(playerid, text, PROX_RADIO);
	}
	return 1;
}

COMMAND:dom(playerid, params[])
{
	new sub_cmd[20], rest[64], id, price;
	if( sscanf(params, "s[32]S()[80]", sub_cmd, rest) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /dom [zapros, wypros, sprzedaj]");
		return 1;
	}
	else
	{
		if( !strcmp(sub_cmd, "zapros") )
		{	
			if(sscanf(rest, "d", id)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /dom zapros [id gracza]");
			if( !pInfo[id][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

			new d_id = -1;

			foreach(new d : Doors)
			{
				if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]))
				{
					d_id = d;
				}
				else if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_spawn_pos][0],  Door[d][door_spawn_pos][1], Door[d][door_spawn_pos][2]) && GetPlayerVirtualWorld(playerid) == Door[d][door_spawn_vw])
				{
					d_id = d;
				}
			}
			
			if( d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz w ¿adnych drzwiach.");
			

			if( !CanPlayerEditDoor(playerid, d_id) ) return SendClientMessage(playerid, COLOR_GREY, "Ten dom nie nale¿y do ciebie.");
			if(GetDistanceBetweenPlayers(playerid, id) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");

			pInfo[id][player_spawn] = Door[d_id][door_uid];
			pInfo[id][player_spawn_type] = SPAWN_TYPE_HOUSE;
			mysql_query(mySQLconnection, sprintf("INSERT INTO ipb_char_spawns (spawn_door, spawn_owner) VALUES (%d, %d)", Door[d_id][door_uid], pInfo[id][player_id]));
			mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_spawn = %d, char_spawn_type = %d WHERE char_uid = %d", pInfo[id][player_spawn], pInfo[id][player_spawn_type], pInfo[id][player_id]));
			SendGuiInformation(id, "Informacja",sprintf("Gracz %s zaprosi³ cie do swojego domu.", pInfo[playerid][player_name]));
			SendGuiInformation(playerid, "Informacja", "Pomyœlnie ustawiono spawn.");
		}
		else if( !strcmp(sub_cmd, "spawn") )
		{
			return cmd_dom(playerid, sprintf("zapros %d", playerid));
		}
		else if( !strcmp(sub_cmd, "wypros") )
		{		
			if(sscanf(rest, "d", id)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /dom zapros [id gracza]");
			if( !pInfo[id][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

			new d_id = -1;

			foreach(new d : Doors)
			{
				if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]))
				{
					d_id = d;
				}
				else if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_spawn_pos][0],  Door[d][door_spawn_pos][1], Door[d][door_spawn_pos][2]) && GetPlayerVirtualWorld(playerid) == Door[d][door_spawn_vw])
				{
					d_id = d;
				}
			}
			
			if( d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz w ¿adnych drzwiach.");

			if( !CanPlayerEditDoor(playerid, d_id) ) return SendClientMessage(playerid, COLOR_GREY, "Ten dom nie nale¿y do ciebie.");

			pInfo[id][player_spawn] = 0;
			pInfo[id][player_spawn_type] = 3;
			mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_spawn = 0, char_spawn_type = 3 WHERE char_uid = %d", pInfo[id][player_id]));
			mysql_query(mySQLconnection, sprintf("DELETE FROM ipb_char_spawns WHERE spawn_door = %d AND spawn_owner = %d", Door[d_id][door_uid], pInfo[id][player_id]));

			SendGuiInformation(playerid, "Informacja", "Gracz zosta³ pomyœlnie wyproszony z domu.");
			SendPlayerInformation(id, sprintf("~w~Gracz ~p~%s~w~ wyprosil cie ze swojego domu.", pInfo[playerid][player_name]), 6000);
		}
		else if( !strcmp(sub_cmd, "sprzedaj") )
		{		
			if(sscanf(rest, "dd", id, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /dom sprzedaj [id gracza, cena]");
			if( !pInfo[id][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

			new d_id = -1;

			foreach(new d : Doors)
			{
				if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]))
				{
					d_id = d;
				}
				else if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_spawn_pos][0],  Door[d][door_spawn_pos][1], Door[d][door_spawn_pos][2]))
				{
					d_id = d;
				}
			}
			
			if( d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz w ¿adnych drzwiach.");

			if(Door[d_id][door_owner_type] != DOOR_OWNER_TYPE_PLAYER) return SendClientMessage(playerid, COLOR_GREY, "Te drzwi nie s¹ domem.");

			if( !CanPlayerEditDoor(playerid, d_id) ) return SendClientMessage(playerid, COLOR_GREY, "Ten dom nie nale¿y do ciebie.");

			if(price < 0) return SendGuiInformation(playerid, "Informacja", "Cena nie mo¿e byæ ujemna.");

			new resp = SetOffer(playerid, id, OFFER_TYPE_DOOR, price, d_id);
		    if( resp ) ShowPlayerOffer(id, playerid, "Drzwi", sprintf("Drzwi: %s", Door[pOffer[id][offer_extraid]][door_name]), price);
		}
	}
	return 1;
}

COMMAND:bank(playerid, params[])
{
	if(IsPlayerInBank(playerid))
	{
		if(pInfo[playerid][player_bank_number] == 0)
		{
			new numer[32];
			format(numer, sizeof(numer), "%c%c%c%c%d", randomNumber(), randomNumber(), randomNumber(), randomNumber(), pInfo[playerid][player_id]);
			new nr = strval(numer);
	        
	        pInfo[playerid][player_bank_number] = nr;

			SendGuiInformation(playerid, "Bank", sprintf("To twoja pierwsza wizyta w banku.\nTwój numer konta to od teraz %d.", nr));
			mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_banknumb = %d WHERE char_uid = %d", nr, pInfo[playerid][player_id]));
			return 1;
		}

		ShowPlayerDialog(playerid, DIALOG_BANKOMAT ,DIALOG_STYLE_LIST, "Bank","1. Stan konta\n2. Wp³ata gotowki\n3. Wyp³ata gotowki\n4. Wykonaj przelew\n5. Odbierz wyp³atê (praca dorywcza)","Wybierz","Wyjdz");
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w banku.");
	}
	return 1;
}

COMMAND:hotel(playerid, params[])
{
	new sub_cmd[20], rest[64], nr;
	if( sscanf(params, "s[32]S()[80]", sub_cmd, rest) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /hotel [zamelduj, wymelduj, wejdz, wyjdz, zapros, wypros]");
		return 1;
	}
	else
	{
		if( !strcmp(sub_cmd, "zamelduj") )
		{
			if(IsPlayerInMotel(playerid))
			{
				if(pInfo[playerid][player_money]<20)
				{
					SendGuiInformation(playerid, "Informacja", "Nie staæ cie na wynajem pokoju. Kosztuje to $20.");
					return 1;
				}
				pInfo[playerid][player_spawn] = GetPlayerVirtualWorld(playerid);
				pInfo[playerid][player_spawn_type] = SPAWN_TYPE_HOTEL;
				
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_spawn = %d, char_spawn_type = %d WHERE char_uid = %d", pInfo[playerid][player_spawn], pInfo[playerid][player_spawn_type], pInfo[playerid][player_id]));
				
				GivePlayerMoney(playerid, -20);
				SendGuiInformation(playerid, "Informacja", sprintf("Zameldowa³eœ siê w hotelu. Twój numer pokoju to %d.\nPobrano za to op³ate w wysokoœci 20 dolarów.", pInfo[playerid][player_id]));
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w hotelu/motelu.");
			}
		}
		else if( !strcmp(sub_cmd, "wymelduj") )
		{
			if(IsPlayerInMotel(playerid))
			{
				pInfo[playerid][player_spawn] = 0;
				pInfo[playerid][player_spawn_type] = 3;
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_spawn = 0, char_spawn_type = 3 WHERE char_uid = %d", pInfo[playerid][player_id]));
				SendGuiInformation(playerid, "Informacja", "Wymeldowa³eœ siê z hotelu.");
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w hotelu/motelu.");
			}
		}
		else if( !strcmp(sub_cmd, "wejdz") )
		{
			if(IsPlayerInMotel(playerid))
			{
				if(sscanf(rest, "d", nr)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /hotel wejdz [numer pokoju]");
				if(nr != pInfo[playerid][player_id]) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID pokoju.");

				RP_PLUS_SetPlayerPos(playerid, 266.6632, 305.1765, 999.1484);
				SetPlayerInterior(playerid, 2);
				SetPlayerVirtualWorld(playerid, pInfo[playerid][player_id]);
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w hotelu/motelu.");
			}
		}
		else if( !strcmp(sub_cmd, "wyjdz") )
		{
			if(GetPlayerVirtualWorld(playerid) != pInfo[playerid][player_id]) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w pokoju hotelowym.");

			new vw = pInfo[playerid][player_spawn];
			new d_id = GetDoorByUid(vw);
			if(d_id == -1) return SendGuiInformation(playerid, "Informacja", "[Captiva] Spawn bug (cmd hotel). Door not exist.");

			if(IsPlayerInRangeOfPoint(playerid, 15.0, 266.6632, 305.1765, 999.1484) && GetPlayerInterior(playerid) == 2)
			{
				SetPlayerPos(playerid, Door[d_id][door_spawn_pos][0],Door[d_id][door_spawn_pos][1],Door[d_id][door_spawn_pos][2]);
				SetPlayerInterior(playerid, Door[d_id][door_spawn_int]);
				SetPlayerVirtualWorld(playerid, vw);
			}
		}
		else if( !strcmp(sub_cmd, "zapros") )
		{
			if(GetPlayerVirtualWorld(playerid) != pInfo[playerid][player_id]) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w pokoju hotelowym.");
			new targetid;
			if(sscanf(rest, "d", targetid)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /hotel zapros [id gracza]");
			if(!IsPlayerConnected(targetid)) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje siê w tym hotelu.");
			if(GetPlayerVirtualWorld(targetid) != pInfo[playerid][player_spawn]) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje siê w tym hotelu.");

			SetPlayerPos(targetid, 266.6632, 305.1765, 999.1484);
			SetPlayerVirtualWorld(targetid, pInfo[playerid][player_id]);
			SetPlayerInterior(targetid, 2);
			SendGuiInformation(playerid, "Informacja", "Gracz zosta³ zaproszony do pokoju hotelowego.");
			SendGuiInformation(targetid, "Informacja", sprintf("Gracz %s zaprosi³ Cie do pokoju hotelowego.", pInfo[playerid][player_name]));
		}
		else if( !strcmp(sub_cmd, "wypros") )
		{
			if(GetPlayerVirtualWorld(playerid) != pInfo[playerid][player_id]) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w pokoju hotelowym.");
			new targetid;
			if(sscanf(rest, "d", targetid)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /hotel zapros [id gracza]");
			if(!IsPlayerConnected(targetid)) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje siê w tym pokoju.");
			if(GetPlayerVirtualWorld(targetid) != pInfo[playerid][player_id]) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje siê w tym pokoju.");

			new vw = pInfo[playerid][player_spawn];
			new d_id = GetDoorByUid(vw);
			if(d_id == -1) return SendGuiInformation(playerid, "Informacja", "[Captiva] Spawn bug (cmd hotel). Door not exist.");

			if(IsPlayerInRangeOfPoint(targetid, 15.0, 266.6632, 305.1765, 999.1484) && GetPlayerInterior(targetid) == 2)
			{
				SetPlayerPos(targetid, Door[d_id][door_spawn_pos][0],Door[d_id][door_spawn_pos][1],Door[d_id][door_spawn_pos][2]);
				SetPlayerInterior(targetid, Door[d_id][door_spawn_int]);
				SetPlayerVirtualWorld(targetid, vw);
			}

			SendGuiInformation(playerid, "Informacja", "Gracz zosta³ wyproszony z pokoju hotelowego.");
			SendGuiInformation(targetid, "Informacja", sprintf("Gracz %s wyprosi³ Cie ze swojego pokoju hotelowego.", pInfo[playerid][player_name]));
		}
	}
	return 1;
}

COMMAND:mgate(playerid, params[])
{
    if( !IsValidDynamicObject(pInfo[playerid][player_edited_object]) ) return SendGuiInformation(playerid, "Informacja", "Nie edytujesz ¿adnego obiektu.");

    new o_id = pInfo[playerid][player_edited_object];
    if(o_id == INVALID_STREAMER_ID) return SendGuiInformation(playerid, "Informacja", "Nie edytujesz ¿adnego obiektu.");

    new option;
   
    if( sscanf(params, "d", option) )
	{
	    SendGuiInformation(playerid, "Informacja", "Obiekt zosta³ przemieniony w bramê.");
	 
	    new uid = Object[o_id][object_uid];
	 
	    mysql_query(mySQLconnection, sprintf("UPDATE `ipb_objects` SET object_gate = '1', object_gatex = '%f', object_gatey = '%f', object_gatez = '%f', object_gaterotx = '%f', object_gateroty = '%f', object_gaterotz = '%f' WHERE object_uid = %d", Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2], Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5], uid));

	    CancelEdit(playerid);
	    Object[o_id][object_is_edited] = false;
	    pInfo[playerid][player_edited_object] = -1;
	    TextDrawHideForPlayer(playerid, Dashboard[playerid]);
	 
	    RefreshPlayer(playerid);
	 
	    DeleteObject(o_id, false);
	    LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
	}
	else
	{
		if(option == 0)
		{
			SendGuiInformation(playerid, "Informacja", "Obiekt zosta³ wy³¹czony z funkcji bramy.");
	 
		    new uid = Object[o_id][object_uid];
		 
		    mysql_query(mySQLconnection, sprintf("UPDATE `ipb_objects` SET object_gate = '0' WHERE object_uid = %d", uid));

		    CancelEdit(playerid);
		    Object[o_id][object_is_edited] = false;
		    pInfo[playerid][player_edited_object] = -1;
		    TextDrawHideForPlayer(playerid, Dashboard[playerid]);
		 
		    RefreshPlayer(playerid);
		 
		    DeleteObject(o_id, false);
		    LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
		}
	}
    return 1;
}
 
COMMAND:brama(playerid, params[])
{
    new g_id = INVALID_STREAMER_ID;

    if(GetPlayerVirtualWorld(playerid) == 0)
    {
    	g_id = GetClosestZeroGate(playerid);
    }
    else
    {
    	g_id = GetClosestGate(playerid);
    }
 	
	if(g_id == INVALID_STREAMER_ID) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w pobli¿u ¿adnej bramy.");

    if(CanPlayerUseObject(playerid, g_id))
    {
        if(!Object[g_id][object_gate_opened])
        {
            MoveDynamicObject(g_id, Object[g_id][object_gate_pos][0], Object[g_id][object_gate_pos][1], Object[g_id][object_gate_pos][2], 2.0, Object[g_id][object_gate_pos][3], Object[g_id][object_gate_pos][4], Object[g_id][object_gate_pos][5]);
            GameTextForPlayer(playerid, "~w~Brama ~g~otwarta", 2500, 3);
            Object[g_id][object_gate_opened] = true;
        }
        else
        {
            MoveDynamicObject(g_id, Object[g_id][object_pos][0], Object[g_id][object_pos][1], Object[g_id][object_pos][2], 2.0, Object[g_id][object_pos][3], Object[g_id][object_pos][4], Object[g_id][object_pos][5]);
            GameTextForPlayer(playerid, "~w~Brama ~r~zamknieta", 2500, 3);
            Object[g_id][object_gate_opened] = false;
        }
    }
    else
    {
        SendGuiInformation(playerid, "Informacja", "Brak uprawnieñ do u¿ywania tej bramy.");
    }
    return 1;
}

COMMAND:przejazd(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnym pojeŸdzie.");
	new d_id = -1;

	foreach(new d : Doors)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]))
		{
			d_id = d;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_spawn_pos][0],  Door[d][door_spawn_pos][1], Door[d][door_spawn_pos][2]))
		{
			d_id = d;
		}
	}
	
	if( d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz w ¿adnych drzwiach.");

	if(Door[d_id][door_car_crosing] == false) return SendGuiInformation(playerid, "Informacja", "Te drzwi maj¹ wy³¹czony przejazd dla pojazdów.");

	if( Door[d_id][door_closed] )
	{
		SendGuiInformation(playerid, "Informacja", "Nie mo¿esz wjechaæ do zamkniêtych drzwi.");
		return 1;
	}
	else
	{
		if(Door[d_id][door_payment]>pInfo[playerid][player_money]) return SendGuiInformation(playerid, "Informacja", "Nie masz pieniêdzy na op³ate za wejœcie.");
		FreezePlayer(playerid, 2500);

		if(GetPlayerVirtualWorld(playerid)== Door[d_id][door_vw])
		{
			new vid = GetPlayerVehicleID(playerid);
			FreezePlayer(playerid, 3000);

			SetVehicleZAngle(vid, Door[d_id][door_spawn_pos][3]);
			SetVehicleVirtualWorld(vid, Door[d_id][door_spawn_vw]);
			SetVehiclePos(vid, Door[d_id][door_spawn_pos][0], Door[d_id][door_spawn_pos][1], Door[d_id][door_spawn_pos][2]);
			LinkVehicleToInterior(vid, Door[d_id][door_spawn_int]);

			foreach(new p: Player)
			{
				if(GetPlayerVehicleID(p) == vid)
				{
					SetPlayerVirtualWorld(p, Door[d_id][door_spawn_vw]);
					SetPlayerInterior(p, Door[d_id][door_spawn_int]);
					SetPlayerTime(p, Door[d_id][door_time], 0);
					//PutPlayerInVehicle(playerid, vid, 0);

					//RP_PLUS_SetPlayerPos(playerid, Door[d_id][door_spawn_pos][0], Door[d_id][door_spawn_pos][1], Door[d_id][door_spawn_pos][2]);
				}
			}

			if(Door[d_id][door_payment]>0)
			{
				if(pInfo[playerid][player_hours] >= 1)
				{
					new gid = GetGroupByUid(Door[d_id][door_owner]);
					if(gid != -1)
					{
						GivePlayerMoney(playerid,-Door[d_id][door_payment]);
						GiveGroupMoney(gid, Door[d_id][door_payment]);
					}
				}
			}
		}
		else if(GetPlayerVirtualWorld(playerid) == Door[d_id][door_spawn_vw])
		{
			new vid = GetPlayerVehicleID(playerid);

			SetVehicleZAngle(vid, Door[d_id][door_pos][3]);
			SetVehicleVirtualWorld(vid, Door[d_id][door_vw]);
			SetVehiclePos(vid, Door[d_id][door_pos][0], Door[d_id][door_pos][1], Door[d_id][door_pos][2]);
			LinkVehicleToInterior(vid, Door[d_id][door_int]);

			foreach(new p: Player)
			{
				if(GetPlayerVehicleID(p) == vid)
				{
					//RP_PLUS_SetPlayerPos(p, Door[d_id][door_pos][0], Door[d_id][door_pos][1], Door[d_id][door_pos][2]);
					SetPlayerVirtualWorld(p, Door[d_id][door_vw]);
					SetPlayerInterior(p, Door[d_id][door_int]);
					SetPlayerTime(p, WorldTime, 0);
					//PutPlayerInVehicle(playerid, vid, 0);
				}
			}

			new slot = GetPlayerDutySlot(playerid);

			if(slot != -1)
			{
				new grid = pInfo[playerid][player_duty_gid];
				if( GroupHasFlag(grid, GROUP_FLAG_DUTY) )
				{
					cmd_g(playerid, sprintf("%d duty", slot+1));
				}
			}
		}
	}
	return 1;
}

COMMAND:time(playerid, params[])
{
	return cmd_zegarek(playerid,params);
}

COMMAND:czas(playerid, params[]) 
{
	return cmd_zegarek(playerid, params);
}

COMMAND:zegarek(playerid, params[])
{
	new item = HasPlayerItem(ITEM_TYPE_WATCH, playerid);
	if (item == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz przy sobie zegarka.");
	new str[64];
	new h,m,s;	gettime(h,m,s);
	ProxMessage(playerid, sprintf("spogl¹da na %s.", PlayerItem[playerid][item][player_item_name]), PROX_SERWERME);
	ApplyAnimation(playerid,"COP_AMBIENT","Coplook_watch",4.1,0,0,0,0,0,1);
	format(str, sizeof(str), "~w~Godzina: ~y~%02d~w~:~y~%02d~w~:~y~%02d", h+2, m, s);
	GameTextForPlayer(playerid, str, 5000, 1);
	return 1;
}

COMMAND:kostka(playerid, params[])
{
	new item = HasPlayerItem(ITEM_TYPE_CUBE, playerid);
	if (item == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz przy sobie kostki.");
	Item_Use(item, playerid);
	return 1;
}

COMMAND:report(playerid, params[]) 
{
	return cmd_raport(playerid, params);
}

COMMAND:raport(playerid, params[])
{
	new id, text[70], str[128];

	if( sscanf(params, "ds[70]", id, text) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /raport [id] [powod]");
		return 1;
	}

	if(!IsPlayerConnected(id)) return SendGuiInformation(playerid, "Informacja", "Niepoprawne id gracza.");
	if( !pInfo[id][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

	// Info dla gracza

	SendGuiInformation(playerid, "Informacja", "Raport zosta³ wys³any, oczekuj na reakcje administracji.");

	// Formatujemy raport

	format(str, sizeof(str), "Raport od %s (%d) na %s (%d), powód: %s.", pInfo[playerid][player_name], playerid, pInfo[id][player_name], id, text);

	// Wysylamy raport do tych ktorzy sa na duty

	foreach(new p : Player)
	{
		if(pInfo[p][player_admin_duty]==true)
		{
			SendClientMessage(p, COLOR_LIGHTER_RED, str);
		}
	}
	return 1;
}

COMMAND:o(playerid, params[])
{
	return cmd_oferuj(playerid, params);
}

COMMAND:oferuj(playerid, params[])
{
    new sub_cmd[20], rest[64], playa, price, compid, clr1, clr2;
    if( sscanf(params, "s[32]S()[80]", sub_cmd, rest) )
    {
        SendClientMessage(playerid, COLOR_GREY, "Tip: /o(feruj) [vcard, produkt, naprawe, tankowanie, przejazd, montaz, pojazd, komponent, dokument, autowypozycz]");
        return 1;
    }
    else
    {
        if( !strcmp(sub_cmd, "naprawe") )
        {
            new gid = pInfo[playerid][player_duty_gid];
           	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");
           	if(Group[gid][group_type] != GROUP_TYPE_WORKSHOP) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");
            if(sscanf(rest, "dd", playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o naprawe [id gracza] [robocizna]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
            if(pInfo[playerid][player_repairing] > 0) return SendGuiInformation(playerid, "Informacja", "Naprawiasz ju¿ jakiœ pojazd.");

            if(GetPlayerVirtualWorld(playerid) == 0)
            {
	            new areaid = pInfo[playerid][player_area];
	            if(areaid == -1)
	            {
	            	SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w strefie z flag¹ napraw.");
	            	return 1;
	            }
	            if(!AreaHasFlag(areaid, AREA_FLAG_SERWIS))
	            {
	            	SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w strefie z flag¹ napraw.");
	            	return 1;
	            }
	        }
	        else
	        {
	        	new doorid = GetDoorByUid(GetPlayerVirtualWorld(playerid));
	        	if (doorid == -1)
	        	{
        			SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach warsztatu.");
	            	return 1;
	        	}
	        }

            if(GetDistanceBetweenPlayers(playerid, playa) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");
            if(!IsPlayerInAnyVehicle(playa)) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje siê w pojeŸdzie.");
            if(Vehicle[GetPlayerVehicleID(playa)][vehicle_health] >= 1500.0) return SendGuiInformation(playerid, ""guiopis"Informacja", "Ten pojazd nie wymaga naprawy.");
 
            new model = Vehicle[GetPlayerVehicleID(playa)][vehicle_model];
         	if(price < 0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
 
            new secprice = 1500 - floatround(Vehicle[GetPlayerVehicleID(playa)][vehicle_health], floatround_ceil);
 
            new allprice = price+secprice;
 
            new resp = SetOffer(playerid, playa, OFFER_TYPE_REPAIR, allprice, GetPlayerVehicleID(playa));
            if( resp ) ShowPlayerOffer(playa, playerid, "Naprawa", sprintf("Naprawa pojazdu %s (Robocizna %d)", VehicleNames[model-400], price), allprice);
            pInfo[playerid][player_fixprice] = price;
        }
        else if( !strcmp(sub_cmd, "holowanie") )
        {
            if(sscanf(rest, "dd", playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o holowanie [id gracza] [cena]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 6.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");

 			if(GetPlayerVehicleID(playerid) == INVALID_VEHICLE_ID) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w pojeŸdzie.");
 			if(GetPlayerVehicleID(playa) == INVALID_VEHICLE_ID) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje siê w ¿adnym pojeŸdzie");
 			if(GetPlayerVehicleID(playa) == GetPlayerVehicleID(playerid)) return SendGuiInformation(playerid, "Informacja", "Nie mo¿esz holowaæ pojazd w którym siedzisz.");
 			if(GetPlayerState(playa) != PLAYER_STATE_PASSENGER) return SendGuiInformation(playerid, "Informacja", "Ten gracz musi byæ na fotelu pasa¿era.");
 			if(!CanPlayerUseVehicle(playa, GetPlayerVehicleID(playa))) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie posiada uprawnieñ do u¿ywania tego pojazdu.");
 			if(price < 0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
 			if( GetPlayerUsedItem(playerid, ITEM_TYPE_LINE) == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz w u¿yciu liny holowniczej.");
            new resp = SetOffer(playerid, playa, OFFER_TYPE_TOW, 0, GetPlayerVehicleID(playa));
            if( resp ) ShowPlayerOffer(playa, playerid, "Holowanie", sprintf("Holowanie od %s", pInfo[playerid][player_name]), 0);
        }
        else if( !strcmp(sub_cmd, "autowypozycz") )
        {
            if(sscanf(rest, "dd", playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o autowypozycz [id gracza] [cena]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 6.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");

            new vid = GetPlayerVehicleID(playerid);
 			if(vid == INVALID_VEHICLE_ID) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w pojeŸdzie.");
 			if(!CanPlayerEditVehicle(playerid, vid)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnieñ do wypo¿yczania tego pojazdu.");

 			if(price < 0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
  			
            new resp = SetOffer(playerid, playa, OFFER_TYPE_CARSHARE, price, vid);
            if( resp ) ShowPlayerOffer(playa, playerid, "Wypozyczenie pojazdu", sprintf("Wypozyczenie pojazdu %s", VehicleNames[Vehicle[vid][vehicle_model]-400]), price);
        }
        else if( !strcmp(sub_cmd, "haracz") )
        {
        	new gid = pInfo[playerid][player_duty_gid];
        	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Komenda dostêpna tylko dla osób na s³u¿bie org. przestêpczej.");
        	if(Group[gid][group_type] != GROUP_TYPE_GANG) return SendGuiInformation(playerid, "Informacja", "Komenda dostêpna tylko dla osób na s³u¿bie org. przestêpczej.");
        	new slot = GetPlayerDutySlot(playerid);
        	if(slot == -1) return SendGuiInformation(playerid, "Informacja", "Komenda dostêpna tylko dla osób na s³u¿bie org. przestêpczej.");
        	if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_OFFER) ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnieñ do sk³adania ofert.");

            if(sscanf(rest, "dd", playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o haracz [id gracza] [kwota haraczu]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");

            new tslot = GetPlayerDutySlot(playa);
            if(tslot == -1) return SendGuiInformation(playerid, "Informacja", "Gracz któremu chcesz z³o¿yæ oferte nie znajduje sie na s³u¿bie ¿adnej grupy.");

            if( !WorkerHasFlag(playa, tslot, WORKER_FLAG_LEADER) ) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie posiada uprawnieñ lidera.");
            new targetgid = pInfo[playa][player_duty_gid];
            if(targetgid == -1) return 1;
            if(!GroupHasFlag(targetgid, GROUP_FLAG_BUSINESS)) return SendGuiInformation(playerid, "Informacja", "Tylko biznesy mog¹ p³aciæ haracze.");

            if(Group[targetgid][group_tributers] == Group[gid][group_uid]) return SendGuiInformation(playerid, "Informacja", "Œci¹gasz ju¿ haracz z tej grupy.");

            if(price < 0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
 
            new resp = SetOffer(playerid, playa, OFFER_TYPE_TRIBUTE, 0, Group[gid][group_uid]);
            if( resp ) ShowPlayerOffer(playa, playerid, "Haracz", sprintf("Haracz od %s", Group[gid][group_name]), 0);
        }
        else if( !strcmp(sub_cmd, "reklama") )
        {
        	new gid = pInfo[playerid][player_duty_gid];
        	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Komenda dostêpna tylko dla osób na s³u¿bie Weazel News.");
        	if(Group[gid][group_type] != GROUP_TYPE_SN) return SendGuiInformation(playerid, "Informacja", "Komenda dostêpna tylko dla osób na s³u¿bie Weazel News.");

            if(sscanf(rest, "dd", playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o reklama [id gracza] [cena]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");

            if(price < 0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
 
            new resp = SetOffer(playerid, playa, OFFER_TYPE_ADVERTISE, price);
            if( resp ) ShowPlayerOffer(playa, playerid, "Reklama", "Reklama w Weazel News", price);
        }
        else if( !strcmp(sub_cmd, "rp") )
        {
        	new text[64];
        	new gid = pInfo[playerid][player_duty_gid];
        	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Komenda dostêpna tylko dla osób na s³u¿bie dowolnej rgupy.");

            if(sscanf(rest, "dds[64]", playa, price, text)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o rp [id gracza] [cena] [us³uga]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(strlen(text) > 60) return SendGuiInformation(playerid, "Informacja", "Nazwa us³ugi mo¿e mieæ maksymalnie 60 znaków.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");

            if(price < 0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
 
            new resp = SetOffer(playerid, playa, OFFER_TYPE_RP, price);
            if( resp ) ShowPlayerOffer(playa, playerid, "Usluga RP", text, price);
        }
        else if( !strcmp(sub_cmd, "montaz") )
        {
           	new gid = pInfo[playerid][player_duty_gid];
           	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");
           	if(Group[gid][group_type] != GROUP_TYPE_WORKSHOP) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");
            if(sscanf(rest, "dd", playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o montaz [id gracza] [robocizna]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");
            if(!IsPlayerInAnyVehicle(playa)) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje siê w pojeŸdzie.");

            new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_TUNING);
            if(GetPlayerUsedItem(playerid, ITEM_TYPE_TUNING) == -1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz w u¿yciu przedmiotu komponentu.");

            new vid = GetPlayerVehicleID(playa);
            new model = GetVehicleModel(vid);

 			if(!IsComponentidCompatible(model, PlayerItem[playerid][itemid][player_item_value1])) return SendGuiInformation(playerid, "Informacja", "Ten komponent nie pasuje do tego pojazdu.");

            new resp = SetOffer(playerid, playa, OFFER_TYPE_MONTAGE, price, PlayerItem[playerid][itemid][player_item_value1]);
            if( resp ) ShowPlayerOffer(playa, playerid, "Montaz", sprintf("Montaz komponentu %s", PlayerItem[playerid][itemid][player_item_name]), price);
        }
        else if( !strcmp(sub_cmd, "lakierowanie") )
        {
            new gid = pInfo[playerid][player_duty_gid];
           	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");
           	if(Group[gid][group_type] != GROUP_TYPE_WORKSHOP) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");
            if(sscanf(rest, "dddd", playa, price, clr1, clr2)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o lakierowanie [id gracza] [robocizna] [kolor1] [kolor2]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
        
            if(GetDistanceBetweenPlayers(playerid, playa) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje sie zbyt daleko.");
            if(!IsPlayerInAnyVehicle(playa)) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje siê w pojeŸdzie.");
            new vid = GetPlayerVehicleID(playa);
 
            new resp = SetOffer(playerid, playa, OFFER_TYPE_RESPRAY, price, clr2);
            if( resp ) ShowPlayerOffer(playa, playerid, "Lakierowanie", sprintf("Lakierowanie %s (kolory %d, %d)", VehicleNames[Vehicle[vid][vehicle_model]-400], clr1, clr2), price);

            pInfo[playerid][player_spraying_color] = clr1;
        }
        else if( !strcmp(sub_cmd, "paintjob") )
        {
            new gid = pInfo[playerid][player_duty_gid];
           	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");
           	if(Group[gid][group_type] != GROUP_TYPE_WORKSHOP) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");

           	if( !GroupHasFlag(gid, GROUP_FLAG_PAINTJOB) ) return SendGuiInformation(playerid, "Informacja", "Twój warsztat nie posiada flagi do tworzenia paintjobów.");

            if(sscanf(rest, "ddd", playa, price, clr1)) 
            {
            	SendClientMessage(playerid, COLOR_GREY, "Tip: /o paintjob [id gracza] [robocizna] [typ (0-3)]");
            	SendClientMessage(playerid, COLOR_GREY, "Tip: Typ 3 usuwa paintjob.");
            	return 1;
            }

            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje sie zbyt daleko.");
            if(!IsPlayerInAnyVehicle(playa)) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje sie w pojezdzie.");
            if(clr1 <0 || clr1 >3) return SendGuiInformation(playerid, "Informacja", "Niepoprawny typ paintjobu.");

            new vid = GetPlayerVehicleID(playa);
 
            new resp = SetOffer(playerid, playa, OFFER_TYPE_PAINTJOB, price, clr1);
            if( resp ) ShowPlayerOffer(playa, playerid, "Paintjob", sprintf("Paintjob dla %s (typ %d)", VehicleNames[Vehicle[vid][vehicle_model]-400], clr1), price);
        }
        else if( !strcmp(sub_cmd, "komponent") )
        {
            new gid = pInfo[playerid][player_duty_gid];
           	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");
           	if(Group[gid][group_type] != GROUP_TYPE_WORKSHOP) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");

            if(sscanf(rest, "ddd", compid, playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o komponent [uid przedmiotu] [id gracza] [robocizna]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje sie zbyt daleko.");
            if(!IsPlayerInAnyVehicle(playa)) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje sie w pojezdzie.");
            if(GetPlayerUsedItem(playerid, ITEM_TYPE_ACCESS) == -1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz w u¿yciu przedmiotu komponentu.");
 
            new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_ACCESS);
            if(PlayerItem[playerid][itemid][player_item_uid] != compid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne UID przedmiotu (komponentu).");
 
            new resp = SetOffer(playerid, playa, OFFER_TYPE_ACCESS, price, PlayerItem[playerid][itemid][player_item_value1]);
            if( resp ) ShowPlayerOffer(playa, playerid, "Montaz", sprintf("Montaz komponentu %s", PlayerItem[playerid][itemid][player_item_name]), price);
        }
        else if( !strcmp(sub_cmd, "zamontuj") )
        {
           	new gid = pInfo[playerid][player_duty_gid];
           	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie firmy ochroniarskiej.");
           	if(Group[gid][group_type] != GROUP_TYPE_SECURITY) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie firmy ochroniarskiej.");
            if(sscanf(rest, "dd", playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o zamontuj [id gracza] [robocizna]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");

            if(GetPlayerVirtualWorld(playerid) == 0) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnych drzwiach.");

            new d_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
            if(d_id == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnych drzwiach.");

            new targetgid = pInfo[playa][player_duty_gid];
            if(targetgid == -1) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje siê na s³u¿bie ¿adnej grupy.");

            if(Door[d_id][door_owner_type] != DOOR_OWNER_TYPE_GROUP) return SendGuiInformation(playerid, "Informacja", "Akcesoria mo¿na montowaæ jedynie do drzwi podpisanych pod grupe.");
            if(Door[d_id][door_owner] != Group[targetgid][group_uid]) return SendGuiInformation(playerid, "Informacja", "Te drzwi nie nale¿¹ do grupy na której ten gracz jest s³u¿bie.");

            new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_DOOR_ACCESS);
            if(GetPlayerUsedItem(playerid, ITEM_TYPE_DOOR_ACCESS) == -1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz w u¿yciu przedmiotu komponentu drzwi.");

           if( DoorHasAccess(d_id, PlayerItem[playerid][itemid][player_item_value1]) ) return SendGuiInformation(playerid, "Informacja", "Te drzwi maj¹ ju¿ zamontowany ten komponent.");
 
            new resp = SetOffer(playerid, playa, OFFER_TYPE_DOOR_ACCESS, price, itemid);
            if( resp ) ShowPlayerOffer(playa, playerid, "Montaz do drzwi", sprintf("Montaz %s", PlayerItem[playerid][itemid][player_item_name]), price);
        }
        else if( !strcmp(sub_cmd, "dokument") )
        {
        	new gid = pInfo[playerid][player_duty_gid];
        	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy maj¹cej mo¿liwoœæ wydawania dokumentów.");

        	new slot = GetPlayerGroupSlot(playerid, gid);
        	if(slot == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy maj¹cej mo¿liwoœæ wydawania dokumentów.");

        	if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_OFFER) ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnieñ do sk³adania ofert.");

            if(sscanf(rest, "dd", compid, playa))
            {
            	SendClientMessage(playerid, COLOR_GREY, "Tip: /o dokument [typ] [id gracza]");
            	SendPlayerInformation(playerid, "~w~Typy dokumentow:~n~~p~1~w~ - licencja na bron~n~~p~2~w~ - prawo jazdy~n~~p~3~w~ - metryka", 6000);
            	return 1;
            }

            if(compid <1 || compid > 3)
            {
            	SendClientMessage(playerid, COLOR_GREY, "Tip: /o dokument [typ] [id gracza]");
            	SendPlayerInformation(playerid, "~w~Typy dokumentow:~n~~p~1~w~ - licencja na bron~n~~p~2~w~ - prawo jazdy~n~~p~3~w~ - metryka", 6000);
            	return 1;
            }

            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            
            if(GetDistanceBetweenPlayers(playerid, playa) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");
 	
 			if(compid == 1)
 			{
 				if(Group[gid][group_type] != GROUP_TYPE_LSPD)
 				{
 					SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie LSSD.");
 					return 1;
 				}

 				if(!WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER)) return SendGuiInformation(playerid, "Informacja", "Tylko liderzy mog¹ wydawaæ licencje na broñ.");

 				if(GetPlayerVirtualWorld(playerid) == 0)
	            {
		            SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach urzêdu.");
		            return 1;
		        }
		        else
		        {
		        	new doorid = GetDoorByUid(GetPlayerVirtualWorld(playerid));

		        	if (doorid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach LSSD.");

		        	new govid = GetGroupByUid(Door[doorid][door_owner]);
		        	if(govid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach LSSD.");

		        	if(Group[govid][group_type] != GROUP_TYPE_LSPD)
		        	{
		        		SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach LSSD.");
		            	return 1;
		        	}
		        }

	           	new resp = SetOffer(playerid, playa, OFFER_TYPE_DOCUMENT, 500, DOCUMENT_WEAPON);
				if( resp ) ShowPlayerOffer(playa, playerid, "Dokument", "Licencja na bron", 500);
			}
			else if(compid ==2)
			{
				if(Group[gid][group_type] != GROUP_TYPE_GOV)
 				{
 					SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy rz¹dowej.");
 					return 1;
 				}

 				if(GetPlayerVirtualWorld(playerid) == 0)
	            {
		            SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach urzêdu.");
		            return 1;
		        }
		        else
		        {
		        	new doorid = GetDoorByUid(GetPlayerVirtualWorld(playerid));

		        	if (doorid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach urzêdu.");

		        	new govid = GetGroupByUid(Door[doorid][door_owner]);
		        	if(govid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach urzêdu.");
		        	
		        	if(Group[govid][group_type] != GROUP_TYPE_GOV)
		        	{
		        		SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach urzêdu.");
		            	return 1;
		        	}
		        }

				new resp = SetOffer(playerid, playa, OFFER_TYPE_DOCUMENT, 150, DOCUMENT_DRIVE);
				if( resp ) ShowPlayerOffer(playa, playerid, "Dokument", "Prawo jazdy", 150);
			}
			else if(compid == 3)
			{
				if(Group[gid][group_type] != GROUP_TYPE_MEDIC)
 				{
 					SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy rz¹dowej.");
 					return 1;
 				}

 				if(GetPlayerVirtualWorld(playerid) == 0)
	            {
		            SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach urzêdu.");
		            return 1;
		        }
		        else
		        {
		        	new doorid = GetDoorByUid(GetPlayerVirtualWorld(playerid));

		        	if (doorid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach szpitala.");

		        	new govid = GetGroupByUid(Door[doorid][door_owner]);
		        	if(govid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach szpitala.");
		        	
		        	if(Group[govid][group_type] != GROUP_TYPE_MEDIC)
		        	{
		        		SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w drzwiach szpitala.");
		            	return 1;
		        	}
		        }

				new resp = SetOffer(playerid, playa, OFFER_TYPE_DOCUMENT, 150, DOCUMENT_METRIC);
				if( resp ) ShowPlayerOffer(playa, playerid, "Dokument", "Metryka", 150);
			}
        }
        else if( !strcmp(sub_cmd, "pojazd") )
        {
            if(sscanf(rest, "dd", playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o pojazd [id gracza] [cena]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 4.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");
            if(!IsPlayerInAnyVehicle(playerid)) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w pojeŸdzie.");
 
            new vehicleid = GetPlayerVehicleID(playerid);
 
            if( Vehicle[vehicleid][vehicle_owner_type] == VEHICLE_OWNER_TYPE_PLAYER )
            {
                if( Vehicle[vehicleid][vehicle_owner] == pInfo[playerid][player_id] )
                {
                    new model = Vehicle[vehicleid][vehicle_model];
                    new resp = SetOffer(playerid, playa, OFFER_TYPE_VEHICLE, price, vehicleid);
                    if( resp ) ShowPlayerOffer(playa, playerid, "Pojazd", sprintf("Sprzedaz pojazdu %s", VehicleNames[model-400]), price);
                }
                else
                {
                    SendGuiInformation(playerid, "Informacja", "Ten pojazd nie nale¿y do Ciebie.");
                }
            }
            else
            {
                SendGuiInformation(playerid, "Informacja", "Ten pojazd nie nalezy do Ciebie.");
            }
        }
        else if( !strcmp(sub_cmd, "tankowanie") )
        {
            new count, secprice;
            new gid = pInfo[playerid][player_duty_gid];
           	if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");
           	if(Group[gid][group_type] != GROUP_TYPE_WORKSHOP) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê na s³u¿bie warsztatu.");

            new object_id = GetClosestObjectType(playerid, OBJECT_PETROL);

			if(object_id == INVALID_STREAMER_ID)
			{
				SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê przy dystrybutorze paliwa.");
				return 1;
			}	

            if(sscanf(rest, "ddd", playa, count, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o tankowanie [id gracza] [ilosc] [robocizna]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
            if(count<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna ilosc paliwa.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje sie zbyt daleko.");

            if(!IsPlayerInAnyVehicle(playa)) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie znajduje siê w pojeŸdzie.");
 
            new vid = GetPlayerVehicleID(playa);
 
            if(count + floatround(Vehicle[vid][vehicle_fuel_current], floatround_ceil) > VehicleFuelMax[GetVehicleModel(vid)-400])
            {
                SendGuiInformation(playerid, "Informacja", "Ten bak nie pomieœci tyle paliwa.");
                return 1;
            }
 			
 			switch( Vehicle[vid][vehicle_fuel_type] )
			{
				case VEHICLE_FUEL_TYPE_BENZYNA:
				{
					secprice = count*3;
				}
				
				case VEHICLE_FUEL_TYPE_DIESEL:
				{
					secprice = count*2;
				}

				case VEHICLE_FUEL_TYPE_LOTNICZE:
				{
					secprice = count*8;
				}
			}
 
            new allprice = price+secprice;
            
            pInfo[playerid][player_dialog_tmp1] = price;
 
            new resp = SetOffer(playerid, playa, OFFER_TYPE_REFUEL, allprice, count);
            if( resp ) ShowPlayerOffer(playa, playerid, "Tankowanie", sprintf("Zatankowanie %d litrow (Robocizna %d)", count, price), allprice);
        }
        else if( !strcmp(sub_cmd, "przejazd") )
        {
            if(sscanf(rest, "dd", playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o przejazd [id] [cena za 100m]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(!IsPlayerInAnyVehicle(playerid)) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w taksówce.");
            if(IsPlayerConnected(pInfo[playerid][player_taxi_passenger])) return SendGuiInformation(playerid, "Informacja", "Wieziesz ju¿ jakiegoœ pasa¿era.");
            if(price > 20) return SendGuiInformation(playerid, "Informacja", "Limit ceny wynosi 20 dolarów za 100m.");
            if(pInfo[playa][player_money] < price*2) return SendGuiInformation(playerid, "Informacja", "Tego gracza nie stac nawet na 200m przejazdu.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje sie zbyt daleko.");
            if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
 
            new gid = pInfo[playerid][player_duty_gid];
 			if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do firmy taksówkarskiej lub nie jesteœ na jej slu¿bie.");

            if(Group[gid][group_type] == GROUP_TYPE_TAXI)
            {
                new resp = SetOffer(playerid, playa, OFFER_TYPE_TAXI, price, GetPlayerVehicleID(playerid));
                if( resp ) ShowPlayerOffer(playa, playerid, "Przejazd taxi", sprintf("Przejazd taxi (%d/km)", price), 0);
                return 1;
            }
            SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do firmy taksówkarskiej lub nie jesteœ na jej s³u¿bie.");
        }
        else if( !strcmp(sub_cmd, "leczenie") )
        {
            if(sscanf(rest, "dd", playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o leczenie [id] [cena]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje siê zbyt daleko.");
            if(price < 0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
 
            new gid = pInfo[playerid][player_duty_gid];
 			if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do ERU lub nie jesteœ na s³u¿bie.");

            if(Group[gid][group_type] == GROUP_TYPE_MEDIC || Group[gid][group_type] == GROUP_TYPE_LSPD)
            {
                new resp = SetOffer(playerid, playa, OFFER_TYPE_MEDIC, price);
                if( resp ) ShowPlayerOffer(playa, playerid, "Leczenie", "Odnowienie HP", price);
                return 1;
            }
            SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do s³u¿b medycznych/porz¹dkowych lub nie jesteœ na s³u¿bie.");
        }
        else if( !strcmp(sub_cmd, "vcard") )
        {
            if(sscanf(rest, "d", playa)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o vcard [id gracza]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( pInfo[playa][player_spec] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, "Ten gracz znajduje sie zbyt daleko.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje sie zbyt daleko.");

            new resp = SetOffer(playerid, playa, OFFER_TYPE_VCARD, 0, GetPlayerUsedItem(playerid, ITEM_TYPE_PHONE));

            if( resp ) ShowPlayerOffer(playa, playerid, "vCard", sprintf("vCard %s [%d]", pInfo[playerid][player_name], Item[pOffer[playa][offer_extraid]][item_value1]), 0);
        }
        else if( !strcmp(sub_cmd, "produkt") )
        {
            new slot = GetPlayerDutySlot(playerid);
            if(slot == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie ¿adnej grupy.");

            cmd_g(playerid, sprintf("%d magazyn", slot+1));
        }
        else if( !strcmp(sub_cmd, "karnet") )
        {
            if(sscanf(rest, "dd", playa, price)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /o karnet [id] [cena]");
            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(price < 50) return SendGuiInformation(playerid, "Informacja", "Minimalna cena karnetu to $50.");

            if(GetDistanceBetweenPlayers(playerid, playa) > 3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje sie zbyt daleko.");
            if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
 
            new gid = pInfo[playerid][player_duty_gid];
            if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do si³owni lub nie jesteœ na jej slu¿bie.");
 
            if(Group[gid][group_type] == GROUP_TYPE_GYM)
            {
                new resp = SetOffer(playerid, playa, OFFER_TYPE_GYM, price, 0);
                if( resp ) ShowPlayerOffer(playa, playerid, "Zakup karnetu", sprintf("Karnet (10 minut) od %s", pInfo[playerid][player_name]), price);
            }
            else
            {
                SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do si³owni lub nie jesteœ na jej slu¿bie.");
            }
        }
        else if( !strcmp(sub_cmd, "sztukiwalki") )
        {
        	new styl;
            if(sscanf(rest, "ddd", playa, styl, price))
            {
            	SendClientMessage(playerid, COLOR_GREY, "Tip: /o sztukiwalki [id] [styl] [cena]");
            	SendClientMessage(playerid, COLOR_GREY, "Tip: Style: 5 - box, 6 - kung fu, 7 - kneehead, 16 - uliczny");
            	return 1;
            }

            if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
            if(price < 500) return SendGuiInformation(playerid, "Informacja", "Minimalna cena karnetu to $500.");

            new Float:dist;
            dist = GetDistanceBetweenPlayers(playerid, playa);
            if(dist>3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz znajduje sie zbyt daleko.");
            if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
 
            new gid = pInfo[playerid][player_duty_gid];
            if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do si³owni lub nie jesteœ na jej s³u¿bie.");
 	
            if(Group[gid][group_type] == GROUP_TYPE_GYM)
            {
            	if(styl != 5 && styl != 6 && styl != 7 && styl != 16) return SendGuiInformation(playerid, "Informacja", "Niepoprawny styl walki.");

            	new object_id = GetClosestObjectType(playerid, OBJECT_PUNCHBAG);

				if(object_id == INVALID_STREAMER_ID)
				{
					SendGuiInformation(playerid, "Informacja", "W pobli¿u nie ma ¿adnego worka treningowego.");
					return 1;
				}

				pInfo[playa][player_gym_object] = object_id;

                new resp = SetOffer(playerid, playa, OFFER_TYPE_GYM_FIGHT, price, styl);
                if( resp ) ShowPlayerOffer(playa, playerid, "Trening sztuk walki", sprintf("Trening od %s", pInfo[playerid][player_name]), price);
            }
            else
            {
                SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do si³owni lub nie jesteœ na jej s³u¿bie.");
            }
        }
    }
    return 1;
}

COMMAND:sprobuj(playerid, params[])
{
	new text[128], string[160];
	if(sscanf(params, "s[128]", text))
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /sprobuj [akcja]");
		return 1;
	}
	new loss = random(2);
	new
			Float:x,
			Float:y,
			Float:z,
			vw = GetPlayerVirtualWorld(playerid),
			int = GetPlayerInterior(playerid);
			
	GetPlayerPos(playerid, x, y, z);
	
	switch(loss)
	{
		case 0:
		{
			if(pInfo[playerid][player_sex] == 0)
			{
				format(string, sizeof(string), "*** %s zawiod³a próbuj¹c %s.", pInfo[playerid][player_name], text);
			}
			else
			{
				format(string, sizeof(string), "*** %s zawiód³ próbuj¹c %s.", pInfo[playerid][player_name], text);
			}

			foreach(new p : Player)
			{
				if( !pInfo[p][player_logged] ) continue;
				if( GetPlayerVirtualWorld(p) != vw || GetPlayerInterior(p) != int ) continue;
				new Float:distance = GetPlayerDistanceFromPoint(p, x, y, z);
				if( distance > 12.0 ) continue;
				SendClientMessage(p, 0xB58ADAFF, string);
			}
		}
		case 1:
		{
			if(pInfo[playerid][player_sex] == 0)
			{
				format(string, sizeof(string), "*** %s odnios³a sukces probuj¹c %s.", pInfo[playerid][player_name], text);
			}
			else
			{
				format(string, sizeof(string), "*** %s odniós³ sukces probuj¹c %s.", pInfo[playerid][player_name], text);
			}

			foreach(new p : Player)
			{
				if( !pInfo[p][player_logged] ) continue;
				if( GetPlayerVirtualWorld(p) != vw || GetPlayerInterior(p) != int ) continue;
				new Float:distance = GetPlayerDistanceFromPoint(p, x, y, z);
				if( distance > 12.0 ) continue;
				SendClientMessage(p, 0xB58ADAFF, string);
			}
		}
	}
	return 1;
}

COMMAND:bagaznik(playerid, params[])
{
	new vid = GetNearestPlayerVehicle(playerid);
	if (vid == -1) return SendGuiInformation(playerid, "Informacja", "Nie stoisz przy ¿adnym pojezdzie lub nie masz uprawnieñ do zarz¹dzania nim.");
	Vehicle[vid][vehicle_boot] = !Vehicle[vid][vehicle_boot];
	UpdateVehicleVisuals(vid);
	return 1;
}

COMMAND:maska(playerid, params[])
{
	new vid = GetNearestPlayerVehicle(playerid);
	if (vid == -1) return SendGuiInformation(playerid, "Informacja", "Nie stoisz przy ¿adnym pojeŸdzie lub nie masz uprawnieñ do zarz¹dzania nim.");
	Vehicle[vid][vehicle_bonnet] = !Vehicle[vid][vehicle_bonnet];
	UpdateVehicleVisuals(vid);
	return 1;
}

COMMAND:ladunek(playerid, params[])
{
	new sub[80],rest[80];
	if(sscanf(params, "s[80]S()[80]", sub, rest)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ladunek [podloz, detonuj]");
	if(!strcmp(sub, "podloz", true))
	{
		if( GetPlayerUsedItem(playerid, ITEM_TYPE_BOMB) == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz w uzyciu ladunkow wybuchowych.");
	   
		new vid = GetNearestVehicle(playerid);
		if( vid == -1 ) return SendGuiInformation(playerid, "Informacja", "Brak pojazdów w okolicy.");

		ApplyAnimation(playerid, "CAR", "Fixn_Car_Loop", 4.1, 0, 1, 1, 1, 0, true);
		pInfo[playerid][player_bomb_car]=vid;
		pInfo[playerid][player_bomb]=20;
		pInfo[playerid][player_bomb_planting] = 1;
		SendPlayerInformation(playerid, "~w~Rozpoczales proces podkladania ladunku ~y~wybuchowego~w~.~n~~n~Odczekaj 20 sekund, po czym odejdz na bezpieczna odleglosc i uzyj komendy ~y~/ladunek detonuj~w~.");
		return 1;
	}
	else if(!strcmp(sub, "detonuj", true))
	{
		if(pInfo[playerid][player_bomb_car] == INVALID_VEHICLE_ID)
		{
			SendGuiInformation(playerid, "Informacja", "Nie podlo¿y³eœ ¿adnego ³adunku.");
			return 1;
		}

		new Float:Pos[3];
		GetVehiclePos(pInfo[playerid][player_bomb_car], Pos[0],Pos[1],Pos[2]);
		CreateExplosion(Pos[0],Pos[1],Pos[2], 3, 30.0); // JEB
		Vehicle[pInfo[playerid][player_bomb_car]][vehicle_health] = 25.0;
		SetVehicleHealth(pInfo[playerid][player_bomb_car], 25.0);
		SendPlayerInformation(playerid, "~w~Pojazd zostal pomyslnie ~y~wysadzony~w~.");
		
		foreach(new p : Player)
		{
			if(GetPlayerVehicleID(p) == pInfo[playerid][player_bomb_car])
			{
				SendClientMessage(p, COLOR_LIGHTER_RED, "Zgin¹³eœ w wyniku wybuchu ³adunku wybuchowego w twoim aucie.");
				CharacterKill(p, -1, "Wybuch ladunku");
				continue;
			}
		}

		pInfo[playerid][player_bomb_car] = INVALID_VEHICLE_ID;
		return 1;
	}
	else SendClientMessage(playerid, COLOR_GREY, "Tip: /ladunek [podloz, detonuj]");
	return 1;
}

COMMAND:ulecz(playerid, params[])
{
	new target;
	if(sscanf(params, "d", target))
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /ulecz [id gracza]");
		return 1;
	}

	if( !IsPlayerConnected(target) ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
	if( !pInfo[target][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

	if( GetDistanceBetweenPlayers(playerid, target) > 3.0) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w pobli¿u tego gracza.");

	if(IsPlayerInAnyGroup(playerid))
	{
		new gid = pInfo[playerid][player_duty_gid];
		if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do LSFD lub nie jesteœ na s³u¿bie tej grupy.");

		if(Group[gid][group_type] == GROUP_TYPE_MEDIC)
		{
			if(pInfo[target][player_bw]>0)
			{
				SetPlayerHealth(target, 20);
				pInfo[target][player_bw]=0;
				ClearAnimations(target);
				GameTextForPlayer(target,"-",1,1);
				TogglePlayerControllable(target, 1);
				SetCameraBehindPlayer(target);
				SendGuiInformation(playerid, "Informacja", "Gracz zosta³ uleczony.");
				RemovePlayerStatus(target, PLAYER_STATUS_BW);
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", "Ten gracz nie ma BW.");
			}
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do LSFD lub nie jesteœ na s³u¿bie tej grupy.");
		}
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do ¿adnej grupy.");
	}
	return 1;
}

COMMAND:odblokuj(playerid, params[])
{
	new target, money, text[32];
	if(sscanf(params, "d", target, money, text))
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /odblokuj [id pojazdu]");
		return 1;
	}

	if( target == INVALID_VEHICLE_ID ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID pojazdu.");

	if(IsPlayerInAnyGroup(playerid))
	{
		new gid = pInfo[playerid][player_duty_gid];

		if(gid == -1)
		{
			SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie ¿adnej grupy.");
			return 1;
		}

		if(Group[gid][group_type] != GROUP_TYPE_LSPD)
		{
			SendGuiInformation(playerid, "Informacja", "Nie jesteœ na slu¿bie grupy z flag¹ do blokowania kó³.");
			return 1;
		}

		new Float:x, Float:y, Float:z;
		GetVehiclePos(target, x, y, z);
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z)) return SendGuiInformation(playerid, "Informacja", "Nie stoisz przy tym pojeŸdzie.");

		if(Vehicle[target][vehicle_blocked] > 0)
		{
			Vehicle[target][vehicle_blocked] = 0;
			SendGuiInformation(playerid, "Informacja", "Ko³o zosta³o odblokowane.");
			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_vehicles` SET `vehicle_blockwheel` = 0 WHERE `vehicle_uid` = %d", Vehicle[target][vehicle_uid]));
		}
		else
		{
			SendGuiInformation(playerid, "Informacja",  "Ten pojazd nie posiada blokady na ko³o.");
		}
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do ¿adnej grupy.");
	}
	return 1;
}

COMMAND:blokuj(playerid, params[])
{
	new target, money, text[32];
	if(sscanf(params, "dds[32]", target, money, text))
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /blokuj [id pojazdu] [kwota] [powod (max 32 znaki)]");
		return 1;
	}

	if( target == INVALID_VEHICLE_ID ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID pojazdu.");

	if(IsPlayerInAnyGroup(playerid))
	{
		new gid = pInfo[playerid][player_duty_gid];

		if(gid == -1)
		{
			SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie ¿adnej grupy.");
			return 1;
		}

		if(Group[gid][group_type] != GROUP_TYPE_LSPD)
		{
			SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z flag¹ do blokowania.");
			return 1;
		}

		if(money < 0 || money > 5000)
		{
			SendGuiInformation(playerid, "Informacja", "Minimalna kwota to 1, a maksymalna to 5000.");
			return 1;
		}

		new Float:x, Float:y, Float:z;
		GetVehiclePos(target, x, y, z);
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z)) return SendGuiInformation(playerid, "Informacja", "Nie stoisz przy tym pojeŸdzie.");

		if(Vehicle[target][vehicle_blocked] == 0)
		{
			Vehicle[target][vehicle_blocked] = money;
			Vehicle[target][vehicle_engine] = false;
			UpdateVehicleVisuals(target);

			if(strlen(text) > 32) return SendGuiInformation(playerid, "Informacja", "Maksymalna liczba znaków w powodzie blokady to 32.");
			mysql_escape_string(text, text, 32);
			sscanf(text, "s[32]", Vehicle[target][vehicle_block_reason]);
			logprintf(LOG_PLAYER, "[BLOCKADE] %s na³o¿y³ blokadê na ko³o pojazdu UID %d", pInfo[playerid][player_name], Vehicle[target][vehicle_uid]);
			SendGuiInformation(playerid, "Informacja", sprintf("Zablokowa³eœ ko³o w pojeŸdzie. (ID: %d, kwota: $%d, powod: %s)", target, money, text));
			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_vehicles` SET `vehicle_blockwheel` = %d, `vehicle_block_reason` = '%s' WHERE `vehicle_uid` = %d", Vehicle[target][vehicle_blocked], text, Vehicle[target][vehicle_uid]));
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", sprintf("Ten pojazd posiada ju¿ blokadê na ko³o. (Powód: %s, kwota: $%d)", Vehicle[target][vehicle_block_reason], Vehicle[target][vehicle_blocked]));
		}
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do ¿adnej grupy.");
	}
	return 1;
}

COMMAND:m(playerid, params[])
{
	new tekst[128];
	if(sscanf(params, "s[128]", tekst))
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /m [tekst]");
		return 1;
	}

	new gid = pInfo[playerid][player_duty_gid];

	if(gid == -1)
	{
		SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy.");
		return 1;
	}

	if(Group[gid][group_type] == GROUP_TYPE_LSPD)
	{
		ProxMessage(playerid, tekst, PROX_MEGAPHONE);
		return 1;
	}

	if(Group[gid][group_type] == GROUP_TYPE_SN)
	{
		ProxMessage(playerid, tekst, PROX_MEGAPHONE);
		return 1;
	}
	return SendGuiInformation(playerid, "Informacja", "Nie jestes na sluzbie LSPD lub SN.");
}


COMMAND:hak(playerid, params[])
{
	new vid;
	new v = GetPlayerVehicleID(playerid);
	if(sscanf(params, "d", vid))
	{
		if(GetPVarInt(playerid, "holowanie") == 0)
		{
			SendClientMessage(playerid, COLOR_GREY, "Tip: /hak [id pojazdu z /dl]");
			return 1;
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "Zakoñczy³es holowanie pojazdu.");
			DetachTrailerFromVehicle(v);
			SetPVarInt(playerid, "holowanie", 0);
			return 1;
		}
	}

	if(v == INVALID_VEHICLE_ID) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz sie w zadnym pojezdzie.");

	new model = GetVehicleModel(v);
	if(model != 525 && model != 531 ) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w pojeŸdzie do holowania.");
	
	new Float:vehiclePos[3];
	GetVehiclePos(vid, vehiclePos[0], vehiclePos[1], vehiclePos[2]);

	if(GetPlayerDistanceFromPoint(playerid, vehiclePos[0], vehiclePos[1], vehiclePos[2]) > 8.0)
	{
		SendGuiInformation(playerid, "Informacja", "Pojazd znajduje siê zbyt daleko od holownika.");
		return 1;
	}

	SetPVarInt(playerid, "holowanie", 1);
	AttachTrailerToVehicle(vid, v);
	return 1;
}

COMMAND:areszt(playerid, params[])
{
    new target, time;
    if(sscanf(params, "dd", target, time))
    {
        SendClientMessage(playerid, COLOR_GREY, "Tip: /areszt [id gracza] [czas w godzinach]");
        return 1;
    }
 
    if( !pInfo[target][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
    if( playerid == target) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
 
    new gid = pInfo[playerid][player_duty_gid];
 
    if(gid == -1)
    {
        SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy LSPD.");
        return 1;
    }
 
    if(Group[gid][group_type] != GROUP_TYPE_LSPD)
    {
        SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy LSPD.");
        return 1;
    }
 
    if(GetDistanceBetweenPlayers(playerid, target) > 5.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz jest za daleko.");
 
    if(time < 0) return SendGuiInformation(playerid, "Informacja", "Niepoprawny czas aresztu.");
 
    if(time == 0)
    {
        SendGuiInformation(playerid, "Informacja", "Gracz zosta³ wypuszczony z wiêzienia.");
        SendGuiInformation(target, "Informacja", "Zosta³eœ zwolniony z aresztu.");
       	RemovePlayerStatus(target, PLAYER_STATUS_JAIL);
        mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_spawn = 0, char_spawn_type = 1, char_arrest = 0 WHERE char_uid = %d", pInfo[target][player_id]));
        pInfo[target][player_arrest]= 0;
        return 1;
    }
 
    new d_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
 
 	if(d_id == -1) return SendGuiInformation(playerid, "Informacja", "Nie wykryto tutaj ¿adnych poprawnych drzwi.");

    pInfo[target][player_spawn] = Door[d_id][door_uid];
    pInfo[target][player_spawn_type] = SPAWN_TYPE_HOUSE;
    pInfo[target][player_arrest] = 3600*time+gettime();
    AddPlayerStatus(target, PLAYER_STATUS_JAIL);
    mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_spawn = %d, char_spawn_type = %d, char_arrest = %d WHERE char_uid = %d", pInfo[target][player_spawn], pInfo[target][player_spawn_type], 3600*time+gettime(), pInfo[target][player_id]));
 
    SendGuiInformation(playerid, "Informacja", "Gracz zosta³ pomyœlnie wtr¹cony do aresztu.");
    SendGuiInformation(target, "Informacja",sprintf("Gracz %s aresztowa³ cie.", pInfo[playerid][player_name]));

    if(!PlayerHasAchievement(target, ACHIEV_BANDIT)) AddAchievement(target, ACHIEV_BANDIT, 100);
 
    return 1;
}

COMMAND:skuj(playerid, params[])
{
	new target;
	if(sscanf(params, "d", target))
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /skuj [id gracza]");
		return 1;
	}

	if(!IsPlayerConnected(target)) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
	if( !pInfo[target][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
	if( playerid == target) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

	new gid = pInfo[playerid][player_duty_gid];

	if(gid == -1)
	{
		SendGuiInformation(playerid, "Informacja", "Nie jestes na sluzbie grupy z flaga do skuwania.");
		return 1;
	}

	if(!(Group[gid][group_flags] & GROUP_FLAG_CUFFS))
	{
		SendGuiInformation(playerid, "Informacja", "Nie jestes na sluzbie grupy z flaga do skuwania.");
		return 1;
	}

	if(GetDistanceBetweenPlayers(playerid, target) > 3.0) return SendGuiInformation(playerid, "Informacja", "Ten gracz jest za daleko.");

	if(GetPlayerSpecialAction(target) == SPECIAL_ACTION_CUFFED)
	{
		SetPlayerSpecialAction(target, SPECIAL_ACTION_NONE);
		SendGuiInformation(playerid, "Informacja", "Gracz zostal rozkuty.");
	}
	else
	{
		SetPlayerSpecialAction(target, SPECIAL_ACTION_CUFFED);
		SendGuiInformation(playerid, "Informacja", "Gracz zostal skuty.");
	}

	return 1;
}

COMMAND:tankuj(playerid, params[])
{
	new sub_cmd[20], rest[64];
	if( sscanf(params, "s[32]S()[80]", sub_cmd, rest) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /tankuj [kanister/pojazd] [iloœæ litrów]");
		return 1;
	}
	else
	{
		if( !strcmp(sub_cmd, "pojazd") )
		{
			new amount;
			if(sscanf(rest, "d", amount))
			{
				SendClientMessage(playerid, COLOR_GREY, "Tip: /tankuj pojazd [iloœæ litrów]");
				return 1;
			}
		  
		    new object_id = GetClosestObjectType(playerid, OBJECT_PETROL);

			if(object_id == INVALID_STREAMER_ID)
			{
				SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê przy dystrybutorze paliwa.");
				return 1;
			}	

			if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendGuiInformation(playerid, "Informacja", "Musisz wysi¹œæ z pojazdu aby go zatankowaæ.");

			new vid = GetNearestVehicle(playerid);
			if (vid == -1) return SendGuiInformation(playerid, "Informacja", "Znajdujesz siê zbyt daleko od jakiegokolwiek pojazdu.");

			if(amount<0) return SendGuiInformation(playerid, "Informacja", "Poda³eœ ujemn¹ iloœæ litrów.");

			new actual = floatround(Vehicle[vid][vehicle_fuel_current], floatround_ceil) + amount;
			new maximum = VehicleFuelMax[GetVehicleModel(vid)-400];

			if(actual > maximum)
			{
				SendGuiInformation(playerid, "Informacja", "Bak tego pojazdu nie jest w stanie zmieœciæ wiêcej paliwa.");
				return 1;
			}

			new price;

			switch( Vehicle[vid][vehicle_fuel_type] )
			{
				case VEHICLE_FUEL_TYPE_BENZYNA:
				{
					price = amount*3;
				}
				
				case VEHICLE_FUEL_TYPE_DIESEL:
				{
					price = amount*2;
				}

				case VEHICLE_FUEL_TYPE_LOTNICZE:
				{
					price = amount*10;
				}
			}
			
			new gid = pInfo[playerid][player_duty_gid];

			if(gid != -1 && Vehicle[vid][vehicle_owner_type] == VEHICLE_OWNER_TYPE_GROUP && Vehicle[vid][vehicle_owner] == gid)
			{
				if(Group[gid][group_capital] < price) return SendGuiInformation(playerid, "Informacja", "W kapitale grupy na której jesteœ s³u¿bie nie ma takiej kwoty.");
				GiveGroupCapital(gid, -price);

				Vehicle[vid][vehicle_fuel_current] += float(amount);
				ApplyAnimation(playerid, "INT_HOUSE", "wash_up",4.1, 0, 0, 0, 0, 0, 1);
				cmd_ame(playerid, "wsuwa w¹¿ do baku tankuj¹c pojazd.");
				SendGuiInformation(playerid, "Informacja", "Pojazd zosta³ pomyœlnie zatankowany. Pieni¹dze potr¹cono z kapita³u grupy.");
				return 1;
			}

			if(price > pInfo[playerid][player_money]) return SendGuiInformation(playerid, "Informacja", "Nie masz wystarczaj¹cej iloœci gotówki.");
			GivePlayerMoney(playerid,-price);

			SendGuiInformation(playerid, "Informacja", "Pojazd zosta³ pomyœlnie zatankowany.");

			Vehicle[vid][vehicle_fuel_current] += float(amount);
			ApplyAnimation(playerid, "INT_HOUSE", "wash_up",4.1, 0, 0, 0, 0, 0, 1);
			cmd_ame(playerid, "wsuwa w¹¿ do baku tankuj¹c pojazd.");
		}
		else if( !strcmp(sub_cmd, "kanister") )
		{
			new item = HasPlayerItem(ITEM_TYPE_CANISTER, playerid);
			if (item == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz przy sobie kanistra.");

			new amount;
			if(sscanf(rest, "d", amount))
			{
				SendClientMessage(playerid, COLOR_GREY, "Tip: /tankuj kanister [iloœæ litrów]");
				return 1;
			}
		  
		    new object_id = GetClosestObjectType(playerid, OBJECT_PETROL);

			if(object_id == INVALID_STREAMER_ID)
			{
				SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê przy dystrybutorze paliwa.");
				return 1;
			}

			if(amount < 0) return SendGuiInformation(playerid, "Informacja", "Poda³eœ ujemn¹ iloœæ litrów.");

			new maximum = 20;

			if(amount + PlayerItem[playerid][item][player_item_value1] > maximum)
			{
				SendGuiInformation(playerid, "Informacja", "Bak tego pojazdu nie jest w stanie zmieœciæ wiêcej paliwa.");
				return 1;
			}	

			new price;

			switch(PlayerItem[playerid][item][player_item_value2])
			{
				case VEHICLE_FUEL_TYPE_BENZYNA:
				{
					price = amount*3;
				}
				
				case VEHICLE_FUEL_TYPE_DIESEL:
				{
					price = amount*2;
				}

				case VEHICLE_FUEL_TYPE_LOTNICZE:
				{
					price = amount*10;
				}
			}

			if(pInfo[playerid][player_money] < price) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz wystarczaj¹cej iloœci gotówki.");

			ApplyAnimation(playerid, "INT_HOUSE", "wash_up",4.1, 0, 0, 0, 0, 0, 1);
			cmd_ame(playerid, "wsuwa w¹¿ do kanistra tankuj¹c go.");
			PlayerItem[playerid][item][player_item_value1] += amount;
			GivePlayerMoney(playerid, -price);
			mysql_query(mySQLconnection, sprintf("UPDATE ipb_items SET item_value1 = %d WHERE item_uid = %d", PlayerItem[playerid][item][player_item_value1], PlayerItem[playerid][item][player_item_uid]));
		}
	}
	return 1;
}

COMMAND:yo(playerid, params[])
{
	new targetid, type;
	if(sscanf(params, "ud", targetid, type))
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /yo [ID gracza] [1-6]");
		return 1;
	}

	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Niepoprawne ID gracza.");
	if( pInfo[targetid][player_spec] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, "Ten gracz znajduje siê zbyt daleko.");

	if(GetDistanceBetweenPlayers(playerid, targetid) > 5.0) return SendClientMessage(playerid, COLOR_GREY, "Ten gracz znajduje siê zbyt daleko.");

	if(type < 1 || type > 6)
	{
		SendGuiInformation(playerid, "Informacja", "Wprowadzono nieprawid³owy typ przywitania (1-6).");
		return 1;
	}

	if( !IsPlayerConnected(targetid) ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
	if( !pInfo[targetid][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

	new resp = SetOffer(playerid, targetid, OFFER_TYPE_YO, 0, type);

	if( resp ) ShowPlayerOffer(targetid, playerid, "Przywitanie", sprintf("Przywitanie od %s", pInfo[playerid][player_name]), 0);

	return 1;
}

COMMAND:kiss(playerid, params[])
{
	new targetid, type;
	if(sscanf(params, "ud", targetid, type))
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /kiss [ID gracza] [1-3]");
		return 1;
	}

	if(GetDistanceBetweenPlayers(playerid, targetid) > 5.0)
	{
		SendGuiInformation(playerid, "Informacja", "Ten gracz jest zbyt daleko od Ciebie.");
		return 1;
	}

	if(type < 1 || type > 3)
	{
		SendGuiInformation(playerid, "Informacja", "Wprowadzono nieprawid³owy typ poca³unku (1-3).");
		return 1;
	}

	if( !IsPlayerConnected(targetid) ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
	if( !pInfo[targetid][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");

	new resp = SetOffer(playerid, targetid, OFFER_TYPE_YO, 0, type+6);

	if( resp ) ShowPlayerOffer(targetid, playerid, "Pocalunek", sprintf("Pocalunek od %s", pInfo[playerid][player_name]), 0);

	return 1;
}

COMMAND:stats(playerid, params[])
{
	new giveplayer_id;

	if(!HasCrewFlag(playerid, CREW_FLAG_GM) && !HasCrewFlag(playerid, CREW_FLAG_ADMIN) && !HasCrewFlag(playerid, CREW_FLAG_ADMIN_ROOT))
	{
		ShowPlayerStats(playerid, playerid);
		return 1;
	}

	if(sscanf(params, "d", giveplayer_id))
	{
		ShowPlayerStats(playerid, playerid);
		return 1;
	} 

	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
		return 1;
	}

	if(!IsPlayerConnected(giveplayer_id))
	{
		SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
		return 1;
	}

	if(!PlayerHasAchievement(playerid, ACHIEV_STRONG) && pInfo[playerid][player_strength] >= 100) AddAchievement(playerid, ACHIEV_STRONG, 500);
	if(!PlayerHasAchievement(playerid, ACHIEV_GYM) && pInfo[playerid][player_strength] >= 25) AddAchievement(playerid, ACHIEV_GYM, 200);
	
	ShowPlayerStats(playerid, giveplayer_id);
	return 1;
}

COMMAND:ubranie(playerid, params[])
{
	if (IsPlayerInVictim(playerid))
	{
		ShowPlayerDialog(playerid, DIALOG_CLOTH, DIALOG_STYLE_LIST, "Sklep z ubraniami", "1. Ubrania\n2. Akcesoria", "Wybierz", "WyjdŸ");
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w sklepie odzie¿owym.");
	}
	return 1;
}

COMMAND:kask(playerid, params[])
{
	return cmd_pasy(playerid, params);
}

COMMAND:pasy(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		new model = GetVehicleModel(vehicleid);

		if(!pInfo[playerid][player_belt])
		{
			if(model == 509 || model == 510 || model == 481 || model == 461 || model == 462 || model == 463 || model == 468 || model == 521 || model == 522 || model == 523 || model == 581 || model == 586)
			{
				AddPlayerStatus(playerid, PLAYER_STATUS_HELMET);
				SendPlayerInformation(playerid, "~w~Kask zostaly~y~ zalozony~w~.", 2500);
			}
			else
			{
				AddPlayerStatus(playerid, PLAYER_STATUS_BELT);
				SendPlayerInformation(playerid, "~w~Pasy zostaly~y~ zapiete~w~.", 2500);
			}

			pInfo[playerid][player_belt]=true;
		}
		else
		{
			if(model == 509 || model == 510 || model == 481 || model == 461 || model == 462 || model == 463 || model == 468 || model == 521 || model == 522 || model == 523 || model == 581 || model == 586)
			{
				RemovePlayerStatus(playerid, PLAYER_STATUS_HELMET);
				SendPlayerInformation(playerid, "~w~Kask zostal~r~ zdjety~w~.", 2500);
			}
			else
			{
				RemovePlayerStatus(playerid, PLAYER_STATUS_BELT);
				SendPlayerInformation(playerid, "~w~Pasy zostaly~r~ odpiete~w~.", 2500);
			}

			pInfo[playerid][player_belt]=false;
		}
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Nie znajdujesz sie w ¿adnym pojeŸdzie.");
	}
	return 1;
}

COMMAND:zapukaj(playerid, params[])
{
	new d_id = -1;

	foreach(new d : Doors)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]))
		{
			d_id = d;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_spawn_pos][0],  Door[d][door_spawn_pos][1], Door[d][door_spawn_pos][2]))
		{
			d_id = d;
		}
	}
	
	if( d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz w ¿adnych drzwiach.");
	
	ProxMessage(playerid, "puka do drzwi.", PROX_ME);

	foreach(new p : Player)
	{
		if(GetPlayerVirtualWorld(p) == Door[d_id][door_spawn_vw] && Door[d_id][door_spawn_vw] != 0)
		{
			SendClientMessage(p, 0x9B91ECFF, "** S³ychaæ pukanie do drzwi.");
		}
	}
	return 1;
}

COMMAND:ddo(playerid, params[])
{
	new tekst[128];
	if(sscanf(params, "s[128]", tekst) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ddo [tekst]");

	new d_id = GetPlayerDoorEntrance(playerid);
	
	if(d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz przy ¿adnych drzwiach.");
	
	foreach(new p : Player)
	{
		if(GetPlayerVirtualWorld(p) == Door[d_id][door_spawn_vw] && Door[d_id][door_spawn_vw] != 0)
		{
			SendClientMessage(p, 0x9B91ECFF, sprintf("** %s (( %s ))", tekst, pInfo[playerid][player_name]));
		}
	}

	ProxMessage(playerid, sprintf("%s", tekst), PROX_DO);
	return 1;
}

COMMAND:dk(playerid, params[])
{
	new tekst[128];
	if(sscanf(params, "s[128]", tekst) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /dk [tekst]");

	new d_id = GetPlayerDoorEntrance(playerid);
	
	if(d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz przy ¿adnych drzwiach.");
	
	foreach(new p : Player)
	{
		if(GetPlayerVirtualWorld(p) == Door[d_id][door_spawn_vw] && Door[d_id][door_spawn_vw] != 0)
		{
			SendClientMessage(p, 0x888888FF, sprintf("%s krzyczy: %s", pInfo[playerid][player_name], tekst));
		}
	}

	ProxMessage(playerid, sprintf("%s", tekst), PROX_SHOUT);
	return 1;
}

COMMAND:wywaz(playerid, params[])
{
	new playercanpry[MAX_PLAYERS];
	new gid = pInfo[playerid][player_duty_gid];
	if(gid == -1) return SendClientMessage(playerid, COLOR_GREY, "Musisz byæ na slu¿bie grupy, która ma uprawnienia do wywa¿ania drzwi.");

	if(IsPlayerInAnyGroup(playerid))
	{
		if(Group[gid][group_flags] & GROUP_FLAG_PRYING)
		{
			playercanpry[playerid]=1;
		}
	}

	if(playercanpry[playerid]==1)
	{
		new d_id = -1;

		foreach(new d : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]))
			{
				d_id = d;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_spawn_pos][0],  Door[d][door_spawn_pos][1], Door[d][door_spawn_pos][2]))
			{
				d_id = d;
			}
		}
		
		if( d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz w ¿adnych drzwiach.");

		if(!Door[d_id][door_closed])
		{
			SendGuiInformation(playerid, "Informacja", "Nie mo¿esz wywa¿yæ otwartych drzwi.");
			return 1;
		}
		
		if( Door[d_id][door_closed] )
		{
			Door[d_id][door_closed] = false;
		}

		ProxMessage(playerid, "wywa¿a drzwi od budynku.", PROX_SERWERME);
		playercanpry[playerid]=0;
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREY, "Musisz byæ na slu¿bie grupy, która ma uprawnienia do wywa¿ania drzwi.");
	}
	return 1;
}

COMMAND:akceptujsmierc(playerid, params[])
{
	if(pInfo[playerid][player_hours]<5) return SendGuiInformation(playerid, "Informacja", "Nie mozesz usmiercic postaci maj¹cej mniej ni¿ 5h online.");
	if(pInfo[playerid][player_bw] > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_AS, DIALOG_STYLE_MSGBOX, "Uœmiercanie postaci", "Jesteœ pewny, ¿e chcesz uœmiercic swoj¹ postaæ?\nProces ten jest nieodwracalny.", "Tak", "Nie");
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Aby uœmierciæ postaæ, musi byæ ona nieprzytomna.");
	}
	return 1;
}

COMMAND:kup(playerid, params[])
{
    if(IsPlayerInStore(playerid))
    {
        new string[1024], count;
        DynamicGui_Init(playerid);
 
        format(string, sizeof(string), "%sProdukt\tCena\n", string);
 
        foreach (new prod: Products)
        {
            if( Product[prod][product_owner] != PRODUCT_OWNER_SHOP ) continue;
 
 
            format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
            DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);  
            count++;
        }
 
        if( count == 0 ) SendGuiInformation(playerid, "Informacja", "Ten sklep nie posiada produktów.");
        else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADD, DIALOG_STYLE_TABLIST_HEADERS, "Sklep 24/7", string, "Kup", "Wyjdz");
    }
    else if(IsPlayerInAmmunation(playerid))
    {
    	if(!(pInfo[playerid][player_documents] & DOCUMENT_WEAPON)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz licencji na broñ.");
    	new string[1024], count;
        DynamicGui_Init(playerid);
 
        format(string, sizeof(string), "%sBroñ\tCena\n", string);
 
        foreach (new prod: Products)
        {
            if( Product[prod][product_owner] != PRODUCT_OWNER_AMMUNATION ) continue;
 
 
            format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
            DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);  
            count++;
        }
 
        if( count == 0 ) SendGuiInformation(playerid, "Informacja", "Ten sklep nie posiada produktów.");
        else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADD, DIALOG_STYLE_TABLIST_HEADERS, "Ammunation", string, "Kup", "Wyjdz");

    }
    else if(IsPlayerInToolShop(playerid))
    {
    	new string[1024], count;
        DynamicGui_Init(playerid);
 
        format(string, sizeof(string), "%sProdukt\tCena\n", string);
 
        foreach (new prod: Products)
        {
            if( Product[prod][product_owner] != PRODUCT_OWNER_TOOLSHOP ) continue;
 
 
            format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
            DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);  
            count++;
        }
 
        if( count == 0 ) SendGuiInformation(playerid, "Informacja", "Ten sklep nie posiada produktów.");
        else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADD, DIALOG_STYLE_TABLIST_HEADERS, "Sklep z narzêdziami", string, "Kup", "Wyjdz");
    }
    else if(IsPlayerInPharmacy(playerid))
    {
    	//if(IsAnyFirefighterOnline()) return SendGuiInformation(playerid, "Informacja", "Na s³u¿bie s¹ pracownicy ERU, w tym przypadku apteki automatyczne nie s¹ dostepne.");
        new string[1024], count;
        DynamicGui_Init(playerid);
 
        format(string, sizeof(string), "%sProdukt\tCena\n", string);
 
        foreach (new prod: Products)
        {
            if( Product[prod][product_owner] != PRODUCT_OWNER_PHARMACY ) continue;
 
            format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
            DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);  
            count++;
        }
 
        if( count == 0 ) SendGuiInformation(playerid, "Informacja", "Ta apteka nie posiada produktów.");
        else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADD, DIALOG_STYLE_TABLIST_HEADERS, "Apteka", string, "Kup", "Wyjdz");
    }
    else
    {
        SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnym sklepie.");
    }
    return 1;
}

COMMAND:admins(playerid, params[])
{
	return cmd_a(playerid, params);
}

COMMAND:a(playerid, params[])
{
	new sub_cmd[128];
	if( sscanf(params, "s[128]", sub_cmd) )
	{
		new count, str[800];
	    DynamicGui_Init(playerid);
		foreach(new p : Player)
		{
			if( pInfo[p][player_admin_duty] )
			{
				if( HasCrewFlag(p, CREW_FLAG_GM) ) format(str, sizeof(str), "%s%d\tGM\t%s%s\n", str, p, HEX_COLOR_CREW_GM, pInfo[p][player_name]);
				if( HasCrewFlag(p, CREW_FLAG_ADMIN) ) format(str, sizeof(str), "%s%d\tSupport\t%s%s\n", str, p, HEX_COLOR_CREW_ADMIN, pInfo[p][player_name]);
				if( HasCrewFlag(p, CREW_FLAG_ADMIN_ROOT) ) format(str, sizeof(str), "%s%d\tAdmin\t%s%s\n", str, p, HEX_COLOR_CREW_ADMIN_ROOT, pInfo[p][player_name]);				
				count++;
	            DynamicGui_AddRow(playerid, p);
			}
			else
			{
				if( pGlobal[playerid][glo_perm] != 0)
				{
					if( HasCrewFlag(p, CREW_FLAG_GM) ) format(str, sizeof(str), "%s%d\tGM off duty\t%s%s\n", str, p, HEX_COLOR_CREW_GM, pGlobal[p][glo_name]);
					if( HasCrewFlag(p, CREW_FLAG_ADMIN) ) format(str, sizeof(str), "%s%d\tSupport off duty\t%s%s\n", str, p, HEX_COLOR_CREW_ADMIN, pGlobal[p][glo_name]);
					if( HasCrewFlag(p, CREW_FLAG_ADMIN_ROOT) ) format(str, sizeof(str), "%s%d\tAdmin off duty\t%s%s\n", str, p, HEX_COLOR_CREW_ADMIN_ROOT, pGlobal[p][glo_name]);				
					count++;
		            DynamicGui_AddRow(playerid, p);
				}
			}
		}
		
		if( !count ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Aktualnie nikogo z ekipy nie ma on-line.\nZapraszamy na san-andreas.pl gdzie znajdziesz du¿o pomocnych informacji.");
		
		format(str, sizeof(str), "ID\tPozycja\tNickname\n%s", str);
		ShowPlayerDialog(playerid, DIALOG_ADMIN_FLAGS, DIALOG_STYLE_TABLIST_HEADERS, "Administratorzy na serwerze:", str, "Flagi", "Zamknij");
	}
	else
	{
		if( !HasCrewFlag(playerid, CREW_FLAG_GM) && !HasCrewFlag(playerid, CREW_FLAG_ADMIN) && !HasCrewFlag(playerid, CREW_FLAG_ADMIN_ROOT) ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie masz uprawnieñ do korzystania z tej komendy.");
		cmd_ac(playerid, sub_cmd);
	}
	return 1;
}

COMMAND:pay(playerid, params[])
{
	return cmd_plac(playerid,params);
}

COMMAND:plac(playerid, params[])
{
	new targetid, amount;
	if( sscanf(params, "dd", targetid, amount) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /plac [id gracza] [iloœæ]");
	if( amount <= 0 ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /plac [id gracza] [iloœæ]");
	if( targetid == playerid ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /plac [id gracza] [iloœæ]");
	if( !IsPlayerConnected(targetid) ) return SendClientMessage(playerid, COLOR_GREY, "Gracz o podanym id nie jest pod³¹czony.");
	if( !pInfo[targetid][player_logged] ) return SendClientMessage(playerid, COLOR_GREY, "Gracz o podanym id nie jest zalogowany.");
	if( pInfo[targetid][player_spec] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, "Ten gracz kogoœ specuje.");
	if( pInfo[playerid][player_money] < amount ) return SendClientMessage(playerid, COLOR_GREY, "Nie masz tyle pieniêdzy.");
	if( pInfo[playerid][player_hours] < 1) return SendClientMessage(playerid, COLOR_GREY, "Potrzebujesz mieæ przegran¹ godzinê aby u¿yæ komendy /plac.");

	new Float:dist;
	dist = GetDistanceBetweenPlayers(playerid, targetid);

	if(dist>5.0)
	{
		SendGuiInformation(playerid, "Informacja", "Ten gracz jest za daleko.");
		return 1;
	}

	GivePlayerMoney(playerid, -amount);
	GivePlayerMoney(targetid, amount);

	ProxMessage(playerid, sprintf("podaje trochê gotówki %s.", pInfo[targetid][player_name]), PROX_SERWERME);
	
	SendFormattedClientMessage(playerid, COLOR_TURQUE, "Poda³eœ graczowi %s (%d) $%d pieniêdzy.", pInfo[targetid][player_name], targetid, amount);
	SendFormattedClientMessage(targetid, COLOR_TURQUE, "Gracz %s (%d) poda³ Ci $%d pieniêdzy.", pInfo[playerid][player_name], playerid, amount);

	if(pInfo[playerid][player_hours] < 20 || pInfo[targetid][player_hours] < 20)
	{
		foreach(new p: Player)
		{
			if(pInfo[p][player_admin_duty])
			{
				SendClientMessage(p, COLOR_SAMP, sprintf("[PAY] %s (UID: %d, %dh) poda³ $%d dla %s (UID %d, %dh)", pInfo[playerid][player_name], pInfo[playerid][player_id], pInfo[playerid][player_hours], amount, pInfo[targetid][player_name], pInfo[targetid][player_id], pInfo[targetid][player_hours]));
			}
		}
	}

	logprintf(LOG_PLAYER, "[PAY] %s (UID: %d) podal %d graczowi %s (UID %d)", pInfo[playerid][player_name], pInfo[playerid][player_id], amount, pInfo[targetid][player_name], pInfo[targetid][player_id]);
	
	return 1;
}

COMMAND:anim(playerid, params[])
{
	return cmd_anims(playerid, params);
}

COMMAND:anims(playerid, params[])
{
	new list_anims[3000];
	DynamicGui_Init(playerid);
	foreach(new anim_id: Anims)
	{
	    format(list_anims, sizeof(list_anims), "%s\n%s", list_anims, AnimInfo[anim_id][aCommand]);
		DynamicGui_AddRow(playerid, DG_ANIMS, anim_id);
	}

	if(strlen(list_anims))
	{
	    ShowPlayerDialog(playerid, DIALOG_ANIMATIONS, DIALOG_STYLE_LIST, "Lista animacji:", list_anims, "Start", "Zamknij");
	}
	else
	{
	    ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", "Nie znaleziono ¿adnych animacji.", "Okej", "");
	}
	return 1;
}

COMMAND:g(playerid, params[])
{
	return cmd_grupy(playerid, params);
}

COMMAND:grupy(playerid, params[])
{
	if( !IsPlayerInAnyGroup(playerid) ) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ cz³onkiem ¿adnej grupy.");
	
	new slot, sub_cmd[20], param[60];
	if( sscanf(params, "dS()[20] S()[60]", slot, sub_cmd, param) )
	{
		if(pInfo[playerid][player_group_list_showed] == false)
		{
			ShowPlayerGroups(playerid);
		}
		else
		{
			HideGroupsList(playerid);
		}

		SendClientMessage(playerid, COLOR_GREY, "Tip: /g {slot} [info, online, duty, przebierz, zapros, wypros, wplac, wyplac, pojazdy, respawn, magazyn]");
		return 1;
	}
	else
	{
		slot -= 1;
		if( slot < 0 || slot > 4 ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /g {slot} [info, online, duty, przebierz, zapros, wypros, wplac, wyplac, pojazdy, respawn, magazyn]");
		if( pGroup[playerid][slot][pg_id] == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /g {slot (1-5)} [info, online, duty, przebierz, zapros, wypros, wplac, wyplac, pojazdy, respawn, magazyn]");
		if( isnull(sub_cmd) ) return SendClientMessage(playerid, COLOR_GREY, sprintf("Tip: /g %d [info, online, duty, przebierz, zapros, wypros, wplac, wyplac, pojazdy, respawn, magazyn]", slot+1));
		
		new gid = pGroup[playerid][slot][pg_id];
		
		if( !strcmp(sub_cmd, "info") )
		{
			new str[300];
			
			format(str, sizeof(str), "%sTyp:\t\t\t%s\n", str, GroupTypes[Group[gid][group_type]]);
			format(str, sizeof(str), "%sBud¿et:\t\t\t$%d\n", str, Group[gid][group_bank_money]);
			format(str, sizeof(str), "%sKapita³:\t\t\t$%d\n", str, Group[gid][group_capital]);
			format(str, sizeof(str), "%sPunkty aktywnoœci:\t%s%d\n", str, ((Group[gid][group_activity_points] >= 1000) ? (HEX_COLOR_LIGHTER_GREEN) : (HEX_COLOR_LIGHTER_RED)), Group[gid][group_activity_points]);
			format(str, sizeof(str), "%sDotacja:\t\t$%d\n", str, GetGroupDotation(gid));

			if(Group[gid][group_type] == GROUP_TYPE_SN)
			{
				DynamicGui_Init(playerid);
				DynamicGui_SetDialogValue(playerid, gid);
				format(str, sizeof(str), "%sNumer SMS:\t\t%d\n", str, Group[gid][group_sms_number]);
				format(str, sizeof(str), "%sKoszt SMS:\t\t%d\n", str, Group[gid][group_sms_cost]);
			}
			
			if(GroupHasFlag(gid, GROUP_FLAG_BUSINESS))
			{
				format(str, sizeof(str), "%sNa haracz:\t\t$%d\n", str, Group[gid][group_tribute]);
			}
			
			new temp, gmonth, gday;
			TimestampToDate(Group[gid][group_last_tax], temp, gmonth, gday, temp, temp, temp, 1);
			format(str, sizeof(str), "%sOstatni podatek:\t%02d.%02d\n", str, gday, gmonth);
			if( Group[gid][group_parent_uid] > 0 ) format(str, sizeof(str), "%sNadrzêdna:\t\t%s (UID: %d)\n", str, Group[GetGroupByUid(Group[gid][group_parent_uid])][group_name], Group[gid][group_parent_uid]);
			new dslot = GetPlayerDutySlot(playerid);
			if( dslot > -1 && pGroup[playerid][dslot][pg_id] == gid ) 
			{
				format(str, sizeof(str), "%sCzas s³u¿by:\t\t%dmin\n", str, pGroup[playerid][dslot][pg_duty_time]);
			}
			format(str, sizeof(str), "%sSkrót:\t\t\t%s\n", str, GetGroupTag(gid));
				
			ShowPlayerDialog(playerid, DIALOG_GROUP_INFO, DIALOG_STYLE_LIST, sprintf("%s (UID: %d) » Informacje", Group[gid][group_name], Group[gid][group_uid]), str, "OK", "");
		}
		else if( !strcmp(sub_cmd, "pojazdy") || !strcmp(sub_cmd, "v")  )
		{
			if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_VEHICLES) ) return PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);

			new str[600], rows, Cache:tmp_cache;
			
			tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT vehicle_uid, vehicle_model FROM `ipb_vehicles` WHERE `vehicle_ownertype` = %d AND `vehicle_owner` = %d", VEHICLE_OWNER_TYPE_GROUP, Group[gid][group_uid]));
			cache_get_row_count(rows);
			
			if( !rows ) SendGuiInformation(playerid, "Informacja", "Ta grupa nie posiada przypisanych pojazdów.");
			else
			{
				DynamicGui_Init(playerid);
				for(new row = 0; row != rows; row++)
				{
					new uid, model;
					cache_get_value_index_int(row, 0, uid);
					cache_get_value_index_int(row, 1, model);
					
					format(str, sizeof(str), "%s%s%d\t\t%s\n", str, ((GetVehicleByUid(uid) != INVALID_VEHICLE_ID) ? (HEX_COLOR_GREEN) : (HEX_COLOR_WHITE)), uid, VehicleNames[model-400]);
					DynamicGui_AddRow(playerid, uid);
				}
			
				ShowPlayerDialog(playerid, DIALOG_GROUP_VEHICLES, DIALOG_STYLE_LIST, sprintf("Pojazdy nale¿¹ce do grupy %s:", Group[gid][group_name]), str, "(Un)Spawn", "Zamknij");
			}

			if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);

		}
		else if( !strcmp(sub_cmd, "czat") )
		{
			if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);	

			if(Group[gid][group_chat] == false)
			{
				SendClientMessage(playerid, COLOR_GOLD, sprintf("Czat dla grupy %s zosta³ wy³¹czony.", Group[gid][group_name]));
				Group[gid][group_chat] = true;
			}
			else
			{
				SendClientMessage(playerid, COLOR_GOLD, sprintf("Czat dla grupy %s zosta³ w³¹czony.", Group[gid][group_name]));
				Group[gid][group_chat] = false;
			}
		}
		else if( !strcmp(sub_cmd, "respawn") )
		{
			if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
			
			new count, str[95];
			foreach(new vid : Vehicles)
			{
				if( Vehicle[vid][vehicle_owner_type] == VEHICLE_OWNER_TYPE_GROUP && Vehicle[vid][vehicle_owner] == Group[gid][group_uid] )
				{
					if( IsVehicleOccupied(vid) ) continue;
					
					SetVehiclePos(vid, Vehicle[vid][vehicle_park][0], Vehicle[vid][vehicle_park][1], Vehicle[vid][vehicle_park][2]-1.1);
					SetVehicleZAngle(vid, Vehicle[vid][vehicle_park][3]);
					SetVehicleVirtualWorld(vid, Vehicle[vid][vehicle_park_world]);
					LinkVehicleToInterior(vid, Vehicle[vid][vehicle_park_interior]);
					Vehicle[vid][vehicle_locked] = true;
					Vehicle[vid][vehicle_engine] = false;
					UpdateVehicleVisuals(vid);
					count++;
				}
			}

			format(str, sizeof(str), "[Grupa %s]: %s wykona³ respawn nieu¿ywanych pojazdów grupowych.", GetGroupTag(gid), pInfo[playerid][player_name]);

			foreach(new p: Player)
			{
				if( GetPlayerGroupSlot(p, gid) != -1 )
				{
					SendClientMessage(p, COLOR_GOLD, str);
				}
			}
			
			SendGuiInformation(playerid, "Informacja", sprintf("Zrespawnowano %d pojazdów w grupie %s.", count, Group[gid][group_name]));
		}
		else if( !strcmp(sub_cmd, "duty") )
		{
			new dslot = GetPlayerDutySlot(playerid);
			if( dslot != -1 && pGroup[playerid][dslot][pg_id] != gid ) return SendGuiInformation(playerid, "Informacja", sprintf("Jesteœ na s³u¿bie innej grupy. U¿yj /g %d duty aby z niej zejœæ.", dslot+1));
			if( pGroup[playerid][slot][pg_duty] )
			{
				pGroup[playerid][slot][pg_duty] = false;
				
				new duty_time = gettime() - pGroup[playerid][slot][pg_duty_start] - pInfo[playerid][player_onduty_afk];
				new color = GetGroupColor(gid);

				new activity = floatround(duty_time/60, floatround_floor)*10;
				Group[gid][group_activity_points] += activity;

				activity = activity/10;

				if(Group[gid][group_tributers] > 0)
				{
					if(Group[gid][group_tribute] < 3500 && activity > 0)
					{
						Group[gid][group_tribute] += 5*activity;
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_tribute = %d, group_activity = %d WHERE group_uid = %d", Group[gid][group_tribute], Group[gid][group_activity_points], Group[gid][group_uid]));
					}
				}
				else
				{
					mysql_query(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_activity = %d WHERE group_uid = %d", Group[gid][group_activity_points], Group[gid][group_uid]));
				}

				SendFormattedClientMessage(playerid, color, "Zakoñczy³eœ s³u¿bê grupy %s (UID: %d). Czas spêdzony na duty: %d minut.", Group[gid][group_name], Group[gid][group_uid], floatround(duty_time/60, floatround_ceil));
				pInfo[playerid][player_onduty_afk] = 0;
				
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_char_groups SET group_time = %d, group_payday = %d WHERE char_uid = %d AND group_belongs = %d", pGroup[playerid][slot][pg_duty_time], pGroup[playerid][slot][pg_payday_count], pInfo[playerid][player_id], Group[pInfo[playerid][player_duty_gid]][group_uid]));
				UpdatePlayerLabel(playerid);
				
				PlayerTextDrawHide(playerid, GroupDutyTag[playerid]);
				pInfo[playerid][player_duty_gid] = -1;
			}
			else
			{
                if( GroupHasFlag(gid, GROUP_FLAG_DUTY) )
                {
                    if(GetPlayerVirtualWorld(playerid) == 0)
                    {
                        new area = pInfo[playerid][player_area];
                        if(area < 1) return SendGuiInformation(playerid, "Informacja", "Ta grupa posiada flagê ograniczonej s³u¿by, nie mo¿esz tutaj u¿yæ tej komendy.");
                        if(Area[area][area_owner_type] != AREA_OWNER_TYPE_GROUP ) return SendGuiInformation(playerid, "Informacja", "Ta grupa posiada flagê ograniczonej s³u¿by, nie mo¿esz tutaj u¿yæ tej komendy.");
                        if(Area[area][area_owner] != Group[gid][group_uid] ) return SendGuiInformation(playerid, "Informacja", "Ta grupa posiada flagê ograniczonej s³u¿by, nie mo¿esz tutaj u¿yæ tej komendy.");
                    }
                    else
                    {
                        new door = GetDoorByUid(GetPlayerVirtualWorld(playerid));
                        if(door == -1) return SendGuiInformation(playerid, "Informacja", "Ta grupa posiada flagê ograniczonej s³u¿by, nie mo¿esz wiêc u¿yæ tej komendy w drzwiach kogoœ innego.");
                        if(Door[door][door_owner_type] != DOOR_OWNER_TYPE_GROUP) return SendGuiInformation(playerid, "Informacja", "Ta grupa posiada flagê ograniczonej s³u¿by, nie mo¿esz wiêc u¿yæ tej komendy w drzwiach kogoœ innego.");
                        if(Door[door][door_owner] != Group[gid][group_uid]) return SendGuiInformation(playerid, "Informacja", "Ta grupa posiada flagê ograniczonej s³u¿by, nie mo¿esz wiêc u¿yæ tej komendy w drzwiach kogoœ innego.");
                    }
                }
                
                if(pGroup[playerid][slot][pg_payday_count] > 2) SendGuiInformation(playerid, "Informacja", "Pobra³eœ ju¿ dzisiaj maksymaln¹ iloœæ wyp³at w tej grupie.\n"HEX_COLOR_LIGHTER_RED"Ta s³uzba bêdzie nieodp³atna.");

				new color = GetGroupColor(gid);
				SendFormattedClientMessage(playerid, color, "Wszed³eœ na s³u¿bê grupy %s (UID: %d). Aby zejœæ wpisz ponownie /g %d duty.", Group[gid][group_name], Group[gid][group_uid], slot+1);
				pGroup[playerid][slot][pg_duty] = true;
				pGroup[playerid][slot][pg_duty_start] = gettime();

                if( GetGroupDotation(gid) > 0 )
                {
                	if(pGroup[playerid][slot][pg_rank_payment] < 1) SendClientMessage(playerid, COLOR_LIGHTER_RED, "Ostrze¿enie. Twoja postaæ nie posiada ustawionej wyp³aty. Jeœli lider j¹ ustawi³ - przeloguj siê.");
                }
				PlayerTextDrawBackgroundColor(playerid, GroupDutyTag[playerid], color);
				PlayerTextDrawSetString(playerid, GroupDutyTag[playerid], GetGroupTag(gid));
				PlayerTextDrawShow(playerid, GroupDutyTag[playerid]);

				pInfo[playerid][player_duty_gid] = gid;

				UpdatePlayerLabel(playerid);
			}
		}
		else if( !strcmp(sub_cmd, "magazyn") )
		{
			if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_OFFER) ) return PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
			
			new list_items[600], header[64];

			DynamicGui_Init(playerid);
			format(header, sizeof(header), "UID\tNazwa\tCena\tIloœæ\n");

			foreach(new itemid : Items)
			{
				if( Item[itemid][item_count] == 0 ) continue;
				
				if( Item[itemid][item_owner_type] == ITEM_OWNER_TYPE_GROUP && Item[itemid][item_owner] == Group[gid][group_uid] )
				{
					format(list_items, sizeof(list_items), "%s %d\t\t%s\t\t%d\t\t%d\n", list_items, Item[itemid][item_uid], Item[itemid][item_name], Item[itemid][item_price], Item[itemid][item_count]);
					DynamicGui_AddRow(playerid, DG_ITEMS_ITEM_ROW, itemid);
				}
			}
			
			if( strlen(list_items) )
			{
				if( WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) )
				{
					TextDrawSetString(Tutorial[playerid], "~w~Wyswietlono liste produktow grupy. Posiadasz uprawnienia lidera, co za tym idzie mozesz zmieniac ~b~~h~~h~ceny produktow~w~ poprzez /lider cena.");
					TextDrawShowForPlayer(playerid, Tutorial[playerid]);
				}
				format(list_items, sizeof(list_items), "%s%s", header, list_items);
				ShowPlayerDialog(playerid, DIALOG_GROUP_MAGAZYN, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Produkty grupy %s [UID: %d]:", Group[gid][group_name], Group[gid][group_uid]), list_items, "Oferuj", "Zamknij");
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", "Ta grupa nie posiada produktów w magazynie.");
			}
		}
		else if( !strcmp(sub_cmd, "przebierz") )
		{
			new rows, Cache:tmp_cache;
			tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT group_skin FROM ipb_char_groups WHERE `char_uid` = %d AND group_belongs = %d", pInfo[playerid][player_id], Group[gid][group_uid]));
			cache_get_row_count(rows);

			new skin;
			cache_get_value_index_int(0, 0, skin);

			if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);

			if(!IsValidSkin(skin)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz ustalonego skinu grupowego.");
			if(Group[gid][group_type] != GROUP_TYPE_LSPD && !CheckCopSkin(skin)) return SendGuiInformation(playerid, "Informacja", "Twoja grupa nie posiada typu porz¹dkowej.\nNie mo¿esz u¿ywaæ skinów policyjnych.");
			
			SetPlayerSkin(playerid, skin);
			pInfo[playerid][player_skin] = skin;
		}
		else if( !strcmp(sub_cmd, "online") )
		{
			new str[600], pslot;
			foreach(new p : Player)
			{
				pslot = GetPlayerGroupSlot(p, gid);
				if( pslot > -1 )
				{
					if( pGroup[p][pslot][pg_duty] ) format(str, sizeof(str), "%s"HEX_COLOR_GREEN"%d\t\t%s\n", str, p, pInfo[p][player_name]);
					else format(str, sizeof(str), "%s%d\t\t%s\n", str, p, pInfo[p][player_name]);
				}
			}
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, sprintf("%s (UID: %d) » Memberzy online", Group[gid][group_name], Group[gid][group_uid]), str, "OK", "");
		}
		else if( !strcmp(sub_cmd, "zapros") )
		{
			if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_MANAGER) && !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
			
			new targetid;
			if( sscanf(param, "d", targetid) ) return SendClientMessage(playerid, COLOR_GREY, sprintf("Tip: /(g)rupa %d zapros [id gracza]", slot+1));
			if( targetid == playerid ) return SendGuiInformation(playerid, "Informacja", "Nie mo¿esz zaproszaæ samego siebie.");

			if( !IsPlayerConnected(targetid) ) return SendGuiInformation(playerid, "Informacja", "Gracz o podanym id nie jest online.");
			if( !pInfo[targetid][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Gracz o podanym id nie jest zalogowany.");
			if( GetPlayerGroupSlot(targetid, gid) > -1 ) return SendGuiInformation(playerid, "Informacja", "Gracz o podanym id jest juz w tej grupie.");			
			new free_slot = GetPlayerGroupFreeSlot(targetid);
			if( free_slot == -1 ) return SendGuiInformation(playerid, "Informacja", "Gracz o podanym id nie ma wolnych slotów.");

			new resp = SetOffer(playerid, targetid, OFFER_TYPE_INVITE, 0, gid);
		    if( resp ) ShowPlayerOffer(targetid, playerid, "Zaproszenie do grupy", sprintf("%s", Group[gid][group_name]), 0);
		}
		else if( !strcmp(sub_cmd, "wypros") )
		{
			if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_MANAGER) && !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
			
			new targetid;
			if( sscanf(param, "d", targetid) ) return SendClientMessage(playerid, COLOR_GREY, sprintf("Tip: /(g)rupa %d wypros [id gracza]", slot+1));
			if( targetid == playerid ) return SendGuiInformation(playerid, "Informacja", "Nie mozesz wyprosiæ samego siebie.");
			if( !IsPlayerConnected(targetid) ) return SendGuiInformation(playerid, ""guiopis" Wyst¹pi³ b³¹d!", "Niestety nie odnaleziono gracza o tym ID!\nGracz o tym ID nie znajduje siê aktualnie w grze!");
			if( !pInfo[targetid][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Gracz o podanym id nie jest zalogowany.");
			
			new pslot = GetPlayerGroupSlot(targetid, gid);
			if( pslot == -1 ) return SendGuiInformation(playerid, "Informacja", "Gracz o podanym id nie jest w tej grupie.");

			if(pGroup[targetid][pslot][pg_payday_count] > 0) return SendGuiInformation(playerid, "Informacja", "Ten gracz nie mo¿e opuœciæ grupy, poniewa¿ pobiera³ dzisiejsz¹ wyp³atê.");
			
			mysql_query(mySQLconnection, sprintf("DELETE FROM `ipb_char_groups` WHERE `char_uid` = %d AND `group_belongs` = %d", pInfo[targetid][player_id], Group[gid][group_uid]));
			
			if( pGroup[targetid][pslot][pg_duty] )
			{
				PlayerTextDrawHide(targetid, GroupDutyTag[playerid]);
				if(Group[pslot][group_type] == GROUP_TYPE_LSPD || Group[pslot][group_type] == GROUP_TYPE_MEDIC || Group[pslot][group_type] == GROUP_TYPE_SN)
				UpdatePlayerLabel(targetid);

			}	
			pInfo[targetid][player_onduty_afk] = 0;
			pInfo[targetid][player_duty_gid] = 0;

			CleanPlayerGroup(targetid, pslot);
			
			SendGuiInformation(playerid, "Informacja", sprintf("Wyprosi³eœ gracza %s z grupy %s (UID: %d).", pInfo[targetid][player_name], Group[gid][group_name], Group[gid][group_uid]));
			SendGuiInformation(targetid, "Informacja", sprintf("%s wyprosi³ Cie z grupy %s (UID: %d).", pInfo[playerid][player_name], Group[gid][group_name], Group[gid][group_uid]));
		}
		else if( !strcmp(sub_cmd, "opusc") )
		{
			new pslot = GetPlayerGroupSlot(playerid, gid);
			if( pslot == -1 ) return SendGuiInformation(playerid, "Informacja", "Brak grupy na tym slocie.");

			if(pGroup[playerid][pslot][pg_payday_count] > 0) return SendGuiInformation(playerid, "Informacja", "Nie mo¿e opuœciæ tej grupy, poniewa¿ pobra³eœ dzisiejsz¹ wyp³atê.");
			
			mysql_query(mySQLconnection, sprintf("DELETE FROM `ipb_char_groups` WHERE `char_uid` = %d AND `group_belongs` = %d", pInfo[playerid][player_id], Group[gid][group_uid]));
			
			if( pGroup[playerid][pslot][pg_duty] ) PlayerTextDrawHide(playerid, GroupDutyTag[playerid]);
			
			CleanPlayerGroup(playerid, pslot);
			
			SendGuiInformation(playerid, "Informacja", sprintf("Opuœci³eœ grupe %s (UID: %d).", Group[gid][group_name], Group[gid][group_uid]));
		}
		else if( !strcmp(sub_cmd, "wplac") )
		{
			if(!IsPlayerInBank(playerid)) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w banku.");
			new amount;
			if( sscanf(param, "d", amount) ) return SendClientMessage(playerid, COLOR_GREY, sprintf("Tip: /(g)rupa %d wplac [kwota]", slot+1));
			if( amount < 0 ) return SendClientMessage(playerid, COLOR_GREY, sprintf("Tip: /(g)rupa %d wplac [kwota]", slot+1));
			if( pInfo[playerid][player_money] < amount ) return SendGuiInformation(playerid, "Informacja", "Nie masz tyle pieniêdzy przy sobie.");
			
			GivePlayerMoney(playerid, -amount);
			GiveGroupCapital(gid, amount);
			mysql_tquery(mySQLconnection, sprintf("INSERT INTO ipb_group_actions (action_value, action_group, action_sender, action_date, action_type) VALUES (%d, %d, %d, %d, %d)", amount, Group[gid][group_uid], pInfo[playerid][player_id], gettime(), ACTION_TYPE_DEPOSIT));
			
			SendGuiInformation(playerid, "Informacja", sprintf("Wp³aci³eœ $%d na kapita³ grupy %s (UID: %d).", amount, Group[gid][group_name], Group[gid][group_uid]));
		}
		else if( !strcmp(sub_cmd, "wyplac") )
		{
			if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
			
			new amount;
			if( sscanf(param, "d", amount) ) return SendClientMessage(playerid, COLOR_GREY, sprintf("Tip: /(g)rupa %d wyplac [kwota]", slot+1));
			if( amount < 0 ) return SendClientMessage(playerid, COLOR_GREY, sprintf("Tip: /(g)rupa %d wyplac [kwota]", slot+1));
			if( Group[gid][group_bank_money] < amount ) return SendGuiInformation(playerid, "Informacja", "Ta grupa nie posiada takiego bud¿etu.");
			
			GivePlayerMoney(playerid, amount);
			GiveGroupMoney(gid, -amount);
			mysql_tquery(mySQLconnection, sprintf("INSERT INTO ipb_group_actions (action_value, action_group, action_sender, action_date, action_type) VALUES (%d, %d, %d, %d, %d)", amount, Group[gid][group_uid], pInfo[playerid][player_id], gettime(), ACTION_TYPE_WITHDRAW));
			
			SendGuiInformation(playerid, "Informacja", sprintf("Wyp³aci³eœ $%d z bud¿etu grupy %s (UID: %d).", amount, Group[gid][group_name], Group[gid][group_uid]));
		}
		else return SendClientMessage(playerid, COLOR_GREY, sprintf("Tip: /g %d [info, online, duty, przebierz, zapros, wypros, wplac, wyplac, pojazdy, respawn, magazyn]", slot+1));
	}
	return 1;
}

COMMAND:pb(playerid, params[])
{	
	new gid = pInfo[playerid][player_duty_gid];

	if(gid == -1)
	{
		SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy porz¹dkowej");
		return 1;
	}

	if(!GroupHasFlag(gid, GROUP_FLAG_911))
	{
		SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy porz¹dkowej");
		return 1;
	}

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	foreach(new i: Player)
	{
		new group_id_fix = pInfo[i][player_duty_gid];
		if(group_id_fix == -1) continue;

		if(group_id_fix == gid)
		{
			DisablePlayerCheckpoint(i);
			SendClientMessage(i, 0xFF6347AA, sprintf("PANIC BUTTON: %s. Pozycja zosta³a oznaczona na minimapie", pInfo[playerid][player_name]));
			SetPlayerCheckpoint(i, x, y, z, 3.0);
			pInfo[i][player_panic] = 1;
		}
	}
	
	return 1;
}

COMMAND:mandat(playerid, params[])
{	
	new gid = pInfo[playerid][player_duty_gid];

	if(gid == -1)
	{
		SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie LSSD.");
		return 1;
	}

	if(Group[gid][group_type] != GROUP_TYPE_LSPD)
	{
		SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie LSSD.");
		return 1;
	}

	new playa, price, powod[64];
	if( sscanf(params, "dds[64]", playa, price, powod) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /mandat [id] [koszt] [powód]");
	}
	else
	{
		if(!IsPlayerConnected(playa)||playa==playerid) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
		if( !pInfo[playa][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Niepoprawne ID gracza.");
		if(price<0) return SendGuiInformation(playerid, "Informacja", "Niepoprawna kwota.");
		new resp = SetOffer(playerid, playa, OFFER_TYPE_MANDAT, price, 0);

		if( resp ) ShowPlayerOffer(playa, playerid, "Mandat", sprintf("Mandat koszt %d~n~Powod: %s", price, powod), price);
	}
	return 1;
}
// ---- Obiekty ---- //

COMMAND:blokada(playerid, params[])
{	
	new gid = pInfo[playerid][player_duty_gid];
	new owner = 0;
	new owner_type = OBJECT_OWNER_TYPE_GLOBAL;

	if(gid == -1)
	{
		SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z flag¹ do stawiania blokad.");
		return 1;
	}

	if(!(Group[gid][group_flags] & GROUP_FLAG_BLOCKADE))
	{
		SendGuiInformation(playerid, "Informacja", "Grupa na której jesteœ s³u¿bie nie posiada flagi do stawiania blokad.");
		return 1;
	}

	new model;
	if( sscanf(params, "d", model) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Tip: /blokada [model]");
		TextDrawSetString(Tutorial[playerid], "Modele ~p~blokad~w~:~n~19834, 1949, 1427, 1424, 1423, 1459, 1237, 3091, 3578. 1425, 18728(flara), 1997(nosze)~n~Klawisz ~p~N~w~ zamyka to okno.");
		TextDrawShowForPlayer(playerid, Tutorial[playerid]);
	}
	else
	{
		if( model < 0 ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /blokada [model]");
		if(!IsValidBlockadeModel(model)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /blokada [model]");
		
		new Float:o_pos[3];
		GetPointInAngleOfPlayer(playerid, o_pos[0], o_pos[1], o_pos[2], 3.0, 0.0);
		
		mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f)", OBJECT_TYPE_BLOCKADE, owner_type, owner, model, GetPlayerVirtualWorld(playerid), o_pos[0], o_pos[1], o_pos[2]));

		new uid = cache_insert_id(), oid = LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
		
		RefreshPlayer(playerid);

		EditDynamicObject(playerid, oid);
	}
	return 1;
}

COMMAND:oc(playerid, params[])
{
	return cmd_mc(playerid, params);
}

COMMAND:mc(playerid, params[])
{	
	new owner = -1, owner_type = -1;
	GetObjectDataForPlayer(playerid, owner, owner_type);
	
	if( owner_type == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do tworzenia obiektu w tym miejscu.");

	if( HasCrewFlag(playerid, CREW_FLAG_EDITOR) && GetPlayerVirtualWorld(playerid) == 0)
	{
		owner_type = OBJECT_OWNER_TYPE_GLOBAL;
	}
		
	if( owner_type == OBJECT_OWNER_TYPE_DOOR )
	{
		new d_id = GetDoorByUid(owner);
		if( CountDoorObjects(d_id) >= Door[d_id][door_objects_limit] ) return SendGuiInformation(playerid, "Informacja", "Te drzwi osi¹gnê³y limit obiektów.");
	}
	
	if( owner_type == OBJECT_OWNER_TYPE_AREA )
	{
		new a_id = GetAreaByUid(owner);
		if( CountAreaObjects(playerid, a_id) >= Area[a_id][area_objects_limit] ) return SendGuiInformation(playerid, "Informacja", "Ta strefa osi¹gnê³a limit obiektów.");
	}

	new model;
	if( sscanf(params, "d", model) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /mc [model]");
	if(!IsValidObjectModel(model)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /mc [model]");

	if(model == OBJECT_ATM || model == OBJECT_BUSSTOP || model == OBJECT_ROB_DOORS)
	{
		if( !HasCrewFlag(playerid, CREW_FLAG_EDITOR) )
		{
			SendClientMessage(playerid, COLOR_GREY, "Tip: /mc [model]");
			return 1;
		}
	}
	
	new Float:o_pos[3];
	GetPointInAngleOfPlayer(playerid, o_pos[0], o_pos[1], o_pos[2], 3.0, 0.0);
	
	mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz) VALUES (null, %d, %d, %d, 0, %d, %d, %f, %f, %f)", OBJECT_TYPE_NORMAL, owner_type, owner, model, GetPlayerVirtualWorld(playerid), o_pos[0], o_pos[1], o_pos[2]));

	new uid = cache_insert_id(), oid = LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
	
	//RefreshPlayer(playerid);
	Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
	
	switch( owner_type )
	{
		case OBJECT_OWNER_TYPE_GLOBAL:
		{
			SendPlayerInformation(playerid, sprintf("Stworzyles ~y~obiekt globalny~w~ (UID: %d, ID: %d, MODEL: %d).", uid, oid, model), 4000);
		}
		
		case OBJECT_OWNER_TYPE_DOOR:
		{
			SendPlayerInformation(playerid, sprintf("Stworzyles ~y~obiekt drzwi~w~ (UID: %d, ID: %d, MODEL: %d).", uid, oid, model), 4000);
		}
		
		case OBJECT_OWNER_TYPE_AREA:
		{
			SendPlayerInformation(playerid, sprintf("Stworzyles ~y~obiekt strefowy~w~ (UID: %d, ID: %d, MODEL: %d).", uid, oid, model), 4000);
		}
	}

	if(pInfo[playerid][player_editor] == OBJECT_EDITOR_CUSTOM)
	{
		cmd_mselid(playerid, sprintf("%d", oid));
	}

	return 1;
}

COMMAND:getvw(playerid, params[])
{	
	if(pInfo[playerid][player_admin_duty] == true)
	{
		new id;
    	if(sscanf(params, "d", id))
    	{
    		SendGuiInformation(playerid, "Informacja", sprintf("Twój virtualworld to %d.", GetPlayerVirtualWorld(playerid)));
    	}
		else
		{
			if( !IsPlayerConnected(id) ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Gracza o podanym id nie ma na serwerze.");
			SendGuiInformation(playerid, "Informacja", sprintf("World gracza o ID %d to %d.", id, GetPlayerVirtualWorld(id)));
		}
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", sprintf("Twój virtualworld to %d.", GetPlayerVirtualWorld(playerid)));
	}
	return 1;
}

COMMAND:osel(playerid, params[])
{
	return cmd_msel(playerid, params);
}

COMMAND:msel(playerid, params[])
{
	new model;
	if( sscanf(params, "d", model) )
	{
		if(pInfo[playerid][player_editor] == OBJECT_EDITOR_SAMP)
		{
			SelectObject(playerid);
		}
		else
		{
			if(pInfo[playerid][player_edited_object] != -1) return SendGuiInformation(playerid, "Informacja", "Aktualnie edytujesz ju¿ jakiœ obiekt.\nU¿yj /msave aby zakoñczyæ edycje.");
			new o_id = SelectCustomObject(playerid);
			if(o_id == INVALID_STREAMER_ID) return SendPlayerInformation(playerid, "W poblizu nie znajduje sie zaden obiekt, ktory moglbys edytowac.", 4000);
			if( Object[o_id][object_uid] == 0) return SendPlayerInformation(playerid, "W poblizu nie znajduje sie zaden obiekt, ktory moglbys edytowac.", 4000);

			Object[o_id][object_is_edited] = true;
			pInfo[playerid][player_edited_object] = o_id;

			GetDynamicObjectPos(o_id, pInfo[playerid][player_edited_object_pos][0], pInfo[playerid][player_edited_object_pos][1], pInfo[playerid][player_edited_object_pos][2]);
			GetDynamicObjectRot(o_id, pInfo[playerid][player_edited_object_pos][3], pInfo[playerid][player_edited_object_pos][4], pInfo[playerid][player_edited_object_pos][5]);
			
			Object[o_id][object_pos][0] = pInfo[playerid][player_edited_object_pos][0];
			Object[o_id][object_pos][1] = pInfo[playerid][player_edited_object_pos][1];
			Object[o_id][object_pos][2] = pInfo[playerid][player_edited_object_pos][2];
			Object[o_id][object_pos][3] = pInfo[playerid][player_edited_object_pos][3];
			Object[o_id][object_pos][4] = pInfo[playerid][player_edited_object_pos][4];
			Object[o_id][object_pos][5] = pInfo[playerid][player_edited_object_pos][5];
			
			UpdateObjectInfoTextdraw(playerid, o_id);
			TextDrawShowForPlayer(playerid, Dashboard[playerid]);

			ApplyAnimation(playerid, "CRACK", "crckidle1", 4.1, 1, 0, 0, 0, 0);
			pInfo[playerid][player_custom_edit] = true;
		}
	}
	else
	{
		new pretend_id;
		
		if(pInfo[playerid][player_editor] == OBJECT_EDITOR_SAMP)
		{
			pretend_id = GetClosestObjectType(playerid, model);
		}
		else
		{
			pretend_id = GetClosestCustomModel(playerid, model);
		}
		
		if( pretend_id == INVALID_STREAMER_ID ) return SendPlayerInformation(playerid, "W poblizu nie znajduje sie zaden obiekt o tym ~r~~h~modelu~w~, ktory moglbys edytowac.", 4000);

		if(!CanPlayerEditObject(playerid, pretend_id)) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do edytowania obiektu o podanym id.");

		if( IsObjectEdited(pretend_id) )  return SendGuiInformation(playerid, "Informacja", "Obiekt o podanym id jest ju¿ edytowany przez kogoœ innego.");
		
		new o_id = pretend_id;

		if(pInfo[playerid][player_editor] == OBJECT_EDITOR_SAMP)
		{
			EditDynamicObject(playerid, o_id);
		}
		else
		{
			ApplyAnimation(playerid, "CRACK", "crckidle1", 4.1, 1, 0, 0, 0, 0);
			pInfo[playerid][player_custom_edit] = true;
		}

		Object[o_id][object_is_edited] = true;
		pInfo[playerid][player_edited_object] = o_id;

		GetDynamicObjectPos(o_id, pInfo[playerid][player_edited_object_pos][0], pInfo[playerid][player_edited_object_pos][1], pInfo[playerid][player_edited_object_pos][2]);
		GetDynamicObjectRot(o_id, pInfo[playerid][player_edited_object_pos][3], pInfo[playerid][player_edited_object_pos][4], pInfo[playerid][player_edited_object_pos][5]);
		
		Object[o_id][object_pos][0] = pInfo[playerid][player_edited_object_pos][0];
		Object[o_id][object_pos][1] = pInfo[playerid][player_edited_object_pos][1];
		Object[o_id][object_pos][2] = pInfo[playerid][player_edited_object_pos][2];
		Object[o_id][object_pos][3] = pInfo[playerid][player_edited_object_pos][3];
		Object[o_id][object_pos][4] = pInfo[playerid][player_edited_object_pos][4];
		Object[o_id][object_pos][5] = pInfo[playerid][player_edited_object_pos][5];
		
		UpdateObjectInfoTextdraw(playerid, o_id);
		TextDrawShowForPlayer(playerid, Dashboard[playerid]);
	}
	
	return 1;
}

COMMAND:mselid(playerid, params[])
{
	new o_id;
	if( sscanf(params, "d", o_id) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /mselid [id obiektu]");

	if( !IsValidDynamicObject(o_id) ) return SendGuiInformation(playerid, "Informacja", "Obiekt o podanym id nie istnieje.");
	if( GetPlayerDistanceToObject(playerid, o_id) > 40.0 ) return SendGuiInformation(playerid, "Informacja", "Obiekt o podanym id znajduje siê za daleko Ciebie.");
	
	if( !CanPlayerEditObject(playerid, o_id) ) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do edytowania obiektu o podanym id.");
	if( IsObjectEdited(o_id) ) return SendGuiInformation(playerid, "Informacja", "Obiekt o podanym id jest ju¿ edytowany przez kogoœ innego.");
	
	if(pInfo[playerid][player_editor] == OBJECT_EDITOR_SAMP)
	{
		EditDynamicObject(playerid, o_id);
	}
	else
	{
		ApplyAnimation(playerid, "CRACK", "crckidle1", 4.1, 1, 0, 0, 0, 0);
		pInfo[playerid][player_custom_edit] = true;
	}
	
	Object[o_id][object_is_edited] = true;
	pInfo[playerid][player_edited_object] = o_id;

	// Pobieramy sobie poczatkowa pozycje obiektu w razie jakiegos bledu
	GetDynamicObjectPos(o_id, pInfo[playerid][player_edited_object_pos][0], pInfo[playerid][player_edited_object_pos][1], pInfo[playerid][player_edited_object_pos][2]);
	GetDynamicObjectRot(o_id, pInfo[playerid][player_edited_object_pos][3], pInfo[playerid][player_edited_object_pos][4], pInfo[playerid][player_edited_object_pos][5]);
	
	Object[o_id][object_pos][0] = pInfo[playerid][player_edited_object_pos][0];
	Object[o_id][object_pos][1] = pInfo[playerid][player_edited_object_pos][1];
	Object[o_id][object_pos][2] = pInfo[playerid][player_edited_object_pos][2];
	Object[o_id][object_pos][3] = pInfo[playerid][player_edited_object_pos][3];
	Object[o_id][object_pos][4] = pInfo[playerid][player_edited_object_pos][4];
	Object[o_id][object_pos][5] = pInfo[playerid][player_edited_object_pos][5];
	
	UpdateObjectInfoTextdraw(playerid, o_id);
	TextDrawShowForPlayer(playerid, Dashboard[playerid]);
	return 1;
}

COMMAND:odel(playerid, params[])
{
	return cmd_mdel(playerid, params);
}

COMMAND:md(playerid, params[])
{
	return cmd_mdel(playerid, params);
}

COMMAND:mdel(playerid, params[])
{
	if( !IsValidDynamicObject(pInfo[playerid][player_edited_object]) ) return SendGuiInformation(playerid, "Informacja", "Nie edytujesz ¿adnego obiektu.");
	
	SendPlayerInformation(playerid, sprintf("Pomyslnie usunieto ~y~obiekt~w~ (UID: %d i ID: %d).", Object[pInfo[playerid][player_edited_object]][object_uid], pInfo[playerid][player_edited_object]), 4000);
		
	DeleteObject(pInfo[playerid][player_edited_object]);

	if(pInfo[playerid][player_editor] == OBJECT_EDITOR_SAMP)
	{
		CancelEdit(playerid);
	}
	
	if(Object[pInfo[playerid][player_edited_object]][object_area] !=0)
	{
		DestroyDynamicArea(Object[pInfo[playerid][player_edited_object]][object_area]);
	}
	
	pInfo[playerid][player_edited_object] = -1;
	pInfo[playerid][player_custom_edit] = false;
	RefreshPlayer(playerid);
	TextDrawHideForPlayer(playerid, Dashboard[playerid]);
	return 1;
}

COMMAND:msave(playerid, params[])
{
	if(pInfo[playerid][player_editor] != OBJECT_EDITOR_CUSTOM) return SendGuiInformation(playerid, "Informacja", "Nie zaznaczy³eœ ¿adnego obiektu customowym edytorem.");
	if( !IsValidDynamicObject(pInfo[playerid][player_edited_object])) return SendGuiInformation(playerid, "Informacja", "Nie zaznaczy³eœ ¿adnego obiektu customowym edytorem.");
	
	SendPlayerInformation(playerid, sprintf("Pomyslnie zapisano ~g~obiekt~w~ (UID: %d i ID: %d).", Object[pInfo[playerid][player_edited_object]][object_uid], pInfo[playerid][player_edited_object]), 4000);
	
	new o_id = pInfo[playerid][player_edited_object];

	Object[o_id][object_is_edited] = false;

	new str[400];
	strcat(str, sprintf("UPDATE `ipb_objects` SET `object_posx` = %f, `object_posy` = %f, `object_posz` = %f,", Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]));
	strcat(str, sprintf(" `object_rotx` = %f, `object_roty` = %f, `object_rotz` = %f WHERE `object_uid` = %d", Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5], Object[o_id][object_uid]));
	mysql_query(mySQLconnection, str);

	pInfo[playerid][player_edited_object] = -1;
	pInfo[playerid][player_custom_edit] = false;

	TextDrawHideForPlayer(playerid, Dashboard[playerid]);
	RefreshPlayer(playerid);
	return 1;
}

COMMAND:ocopy(playerid, params[])
{
	return cmd_mkopia(playerid,params);
}

COMMAND:mk(playerid, params[])
{
	return cmd_mkopia(playerid,params);
}

COMMAND:mcopy(playerid, params[])
{
	return cmd_mkopia(playerid,params);
}

COMMAND:mkopia(playerid, params[])
{
	if( !IsValidDynamicObject(pInfo[playerid][player_edited_object]) ) return SendGuiInformation(playerid, "Informacja", "Nie edytujesz zadnego obiektu.");
	
	new owner = -1, owner_type = -1;
	GetObjectDataForPlayer(playerid, owner, owner_type);

	if( HasCrewFlag(playerid, CREW_FLAG_ADMIN_ROOT) )
	{
		owner_type = OBJECT_OWNER_TYPE_GLOBAL;
	}

	if( owner_type == OBJECT_OWNER_TYPE_AREA )
	{
		new a_id = GetAreaByUid(owner);
		if( CountAreaObjects(playerid, a_id) >= Area[a_id][area_objects_limit] ) return SendGuiInformation(playerid, "Informacja", "Ta strefa osi¹gnê³a swój limit obiektów.");
	}

	if( owner_type == OBJECT_OWNER_TYPE_DOOR )
	{
		new d_id = GetDoorByUid(owner);
		if(d_id != -1)
		{
			if(CountDoorObjects(d_id) >= Door[d_id][door_objects_limit]) return SendGuiInformation(playerid, "Informacja", "Te drzwi osi¹gnê³y swój limit obiektów.");
		}
	}

	SendPlayerInformation(playerid, sprintf("Pomyslnie skopiowano ~y~obiekt~w~ (UID: %d i ID: %d).", Object[pInfo[playerid][player_edited_object]][object_uid], pInfo[playerid][player_edited_object]), 4000);

	new o_id = pInfo[playerid][player_edited_object];
	//new index;

	new Float:o_pos[6];

	GetDynamicObjectPos(o_id, o_pos[0], o_pos[1], o_pos[2]);
	GetDynamicObjectRot(o_id, o_pos[3], o_pos[4], o_pos[5]);

	mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_objects` (object_uid, object_type, object_ownertype, object_owner, object_map, object_model, object_world, object_posx, object_posy, object_posz) VALUES (null, %d, %d, %d, 0, %d, %d, '%f', '%f', '%f')", OBJECT_TYPE_NORMAL, Object[o_id][object_owner_type], Object[o_id][object_owner], Object[o_id][object_model], GetPlayerVirtualWorld(playerid), o_pos[0], o_pos[1], o_pos[2]));
	new uid = cache_insert_id();
	mysql_query(mySQLconnection, sprintf("UPDATE ipb_objects SET object_rotx = '%f', object_roty = '%f', object_rotz = '%f' WHERE object_uid = %d", o_pos[3], o_pos[4], o_pos[5], uid));
	
	/*if(Object[o_id][object_textured] > 0)
	{
		new rows, Cache:tmp_cache;
		tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM ipb_materials WHERE material_owner = %d", Object[o_id][object_uid]));
		cache_get_row_count(rows);

		if(rows)
		{
			for(new row = 0; row != rows; row++)
			{
				cache_get_value_index(row, 1, material);
				cache_get_value_index_int(row, 3, index);
				mysql_query(mySQLconnection, sprintf("INSERT INTO ipb_materials (material_id, material_texture, material_owner, material_index) VALUES (null, '%s', %d, %d)", material, uid, index));
			}
		}
		if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	}*/

	new oid = LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);

	new mid[16], txdname[16][64], tname[16][64], clr[16], material_str[100], query[250];
	for(new indexx; indexx < 16; indexx++)
	{
		if(IsDynamicObjectMaterialUsed(o_id, indexx))
		{
			GetDynamicObjectMaterial(o_id, indexx, mid[indexx], txdname[indexx], tname[indexx], clr[indexx], 64, 64);
			SetDynamicObjectMaterial(oid, indexx, mid[indexx], txdname[indexx], tname[indexx], clr[indexx]);

			format(material_str, sizeof(material_str), "0^%d:%06x:%d:%s:%s", indexx, clr[indexx], mid[indexx], txdname[indexx], tname[indexx]);
			mysql_format(mySQLconnection, query, sizeof(query), "INSERT INTO ipb_materials (material_texture, material_owner, material_index) VALUES ('%s', %d, %d)", material_str, uid, indexx);
			mysql_tquery(mySQLconnection, query);
		}

		if(IsDynamicObjectMaterialTextUsed(o_id, indexx))
		{
			//todo support for texts
		}
	}

	CancelEdit(playerid);

	RefreshPlayer(playerid);
	TextDrawHideForPlayer(playerid, Dashboard[playerid]);
	defer Msel[1000](playerid, oid);
	return 1;
}

COMMAND:omat(playerid, params[])
{
	return cmd_mmat(playerid,params);
}

COMMAND:mmat(playerid, params[])
{
	if( !IsValidDynamicObject(pInfo[playerid][player_edited_object]) ) return SendGuiInformation(playerid, "Wyst¹pi³ b³¹d", "Nie edytujesz ¿adnego obiektu.");
	if( strfind(params, "|", true) != -1) return SendGuiInformation(playerid, "Wyst¹pi³ b³¹d", "Wykryto niedozwolone znaki.");
	new sub_cmd, param[100];
	if( sscanf(params, "d S()[150]", sub_cmd, param) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /mmat [0-1] (parametry)");
	
	switch(sub_cmd)
	{
		// tekstury
		case 0:
		{
			new index, color, model, txd_name[64], texture_name[64];
			if( sscanf(param, "dxds[64]s[64]", index, color, model, txd_name, texture_name) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /mmat 0 [Index (0-15)] [Kolor (ARGB)] [Model] [Txdname] [Texturename]");
			if( index < 0 || index > 15 ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /mmat 0 [Index (0-15)] [Kolor (ARGB)] [Model] [Txdname] [Texturename]");
			if(strlen(texture_name) > 30) return SendGuiInformation(playerid, "Informacja", "Zbyt d³ugi tekst tekstury.");
			if(strlen(txd_name) > 30) return SendGuiInformation(playerid, "Informacja", "Zbyt d³ugi tekst nazwy txd.");

			mysql_escape_string(texture_name, texture_name, 64);
			mysql_escape_string(txd_name, txd_name, 64);
			
			new o_id = pInfo[playerid][player_edited_object], rows, Cache:tmp_cache;

			tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM ipb_materials WHERE material_owner = %d AND material_index = %d LIMIT 1", Object[o_id][object_uid], index));
			cache_get_row_count(rows);

			if( rows )
			{
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_materials SET material_texture = '0^%d:%06x:%d:%s:%s' WHERE material_owner = %d AND material_index = %d", index, color, model, txd_name, texture_name, Object[o_id][object_uid], index));
			}
			else
			{
				mysql_query(mySQLconnection, sprintf("INSERT INTO ipb_materials SET material_texture = '0^%d:%06x:%d:%s:%s', material_owner = %d, material_index = %d", index, color, model, txd_name, texture_name, Object[o_id][object_uid], index));
			}
			
			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_objects` SET `object_textured` = 1, `object_posx` = %f, `object_posy` = %f, `object_posz` = %f, `object_rotx` = %f, `object_roty` = %f, `object_rotz` = %f WHERE `object_uid` = %d", Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2], Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5], Object[pInfo[playerid][player_edited_object]][object_uid]));
			
			pInfo[playerid][player_edited_object_no_action] = true;
			CancelEdit(playerid);
			
			new uid = Object[o_id][object_uid];
			
			pInfo[playerid][player_edited_object] = -1;
			Object[o_id][object_is_edited] = false;
			
			TextDrawHideForPlayer(playerid, Dashboard[playerid]);
			
			DeleteObject(o_id, false);
			new oid = LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
			
			RefreshPlayer(playerid);

			if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
			
			cmd_mselid(playerid, sprintf("%d", oid));
		}
		
		// napisy
		case 1:
		{
			new index, msize, fsize, bold, fcolor, bcolor, align, font[32], text[128];
			if( sscanf(param, "ddddxxds[32]s[128]", index, msize, fsize, bold, fcolor, bcolor, align, font, text) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /mmat 1 [index (0-15)] [Matsize (10-140) [Fontsize (24-255)] [Bold] [Fontcol] [Backcol] [Align (0-2)] [Font] [Txt]");
			if( index < 0 || index > 15 ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /mmat 1 [index (0-15)] [Matsize (10-140) [Fontsize (24-255)] [Bold] [Fontcol] [Backcol] [Align (0-2)] [Font] [Txt]");
			if(strlen(text) > 50) return SendGuiInformation(playerid, "Informacja", "Zbyt d³ugi tekst.");
			if(strlen(font) > 10) return SendGuiInformation(playerid, "Informacja", "Zbyt d³ugi tekst czcionki.");
			if( strfind(text, ":", true) != -1 || strfind(text, "^", true) != -1 ) return SendGuiInformation(playerid, "Informacja", "Nie mozesz uzywaæ znaków ^ oraz :.");
			
			mysql_escape_string(font, font, 32);
			mysql_escape_string(text, text, 128);

			new o_id = pInfo[playerid][player_edited_object], rows, Cache:tmp_cache;

			tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM ipb_materials WHERE material_owner = %d AND material_index = %d LIMIT 1", Object[o_id][object_uid], index));
			cache_get_row_count(rows);

			if( rows )
			{
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_materials SET material_texture = '1^%d:%d:%d:%d:%06x:%06x:%d:%s:%s' WHERE material_owner = %d AND material_index = %d", index, msize, fsize, bold, fcolor, bcolor, align, font, text, Object[o_id][object_uid], index));
			}
			else
			{
				mysql_query(mySQLconnection, sprintf("INSERT INTO ipb_materials SET material_texture = '1^%d:%d:%d:%d:%06x:%06x:%d:%s:%s', material_owner = %d, material_index = %d",index, msize, fsize, bold, fcolor, bcolor, align, font, text, Object[o_id][object_uid], index));
			}
			
			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_objects` SET `object_textured` = 1, `object_posx` = %f, `object_posy` = %f, `object_posz` = %f, `object_rotx` = %f, `object_roty` = %f, `object_rotz` = %f WHERE `object_uid` = %d", Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2], Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5], Object[pInfo[playerid][player_edited_object]][object_uid]));
			
			pInfo[playerid][player_edited_object_no_action] = true;
			CancelEdit(playerid);
			
			new uid = Object[o_id][object_uid];
			
			pInfo[playerid][player_edited_object] = -1;
			Object[o_id][object_is_edited] = false;
			
			TextDrawHideForPlayer(playerid, Dashboard[playerid]);
			
			DeleteObject(o_id, false);
			new oid = LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
			
			RefreshPlayer(playerid);

			if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
			
			cmd_mselid(playerid, sprintf("%d", oid));
		}
	}
	
	return 1;
}

COMMAND:rx(playerid, params[])
{
	if( !IsValidDynamicObject(pInfo[playerid][player_edited_object]) ) return SendGuiInformation(playerid, "Informacja", "Nie edytujesz ¿adnego obiektu.");
	
	new Float:rxs;
	if( sscanf(params, "f", rxs) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /rx [iloœæ stopni]");
	
	new o_id = pInfo[playerid][player_edited_object];
	
	SetDynamicObjectRot(pInfo[playerid][player_edited_object], 360.0-rxs, Object[o_id][object_pos][4], Object[o_id][object_pos][5]);

	if(pInfo[playerid][player_editor] == OBJECT_EDITOR_CUSTOM)
	{
		new Float:temp, Float:x;
		GetDynamicObjectRot(o_id, x, temp, temp);
		Object[o_id][object_pos][3] = x;
		return 1;
	}

	OnPlayerEditDynamicObject(playerid, pInfo[playerid][player_edited_object], EDIT_RESPONSE_UPDATE, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2], 360.0-rxs, Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
	pInfo[playerid][player_edited_object_no_action] = true;
	
	CancelEdit(playerid);
	EditDynamicObject(playerid, pInfo[playerid][player_edited_object]);

	return 1;
}

COMMAND:ry(playerid, params[])
{
	if( !IsValidDynamicObject(pInfo[playerid][player_edited_object]) ) return SendGuiInformation(playerid, "Informacja", "Nie edytujesz ¿adnego obiektu.");
	
	new Float:rys;
	if( sscanf(params, "f", rys) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ry [iloœæ stopni]");
	
	new o_id = pInfo[playerid][player_edited_object];
	
	SetDynamicObjectRot(pInfo[playerid][player_edited_object],  Object[o_id][object_pos][3], 360.0-rys, Object[o_id][object_pos][5]);

	if(pInfo[playerid][player_editor] == OBJECT_EDITOR_CUSTOM)
	{
		new Float:temp, Float:y;
		GetDynamicObjectRot(o_id, temp, y, temp);
		Object[o_id][object_pos][4] = y;
		return 1;
	}
	
	OnPlayerEditDynamicObject(playerid, pInfo[playerid][player_edited_object], EDIT_RESPONSE_UPDATE, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2], Object[o_id][object_pos][3], 360.0-rys, Object[o_id][object_pos][5]);
	pInfo[playerid][player_edited_object_no_action] = true;
	
	CancelEdit(playerid);
	EditDynamicObject(playerid, pInfo[playerid][player_edited_object]);
	
	return 1;
}

COMMAND:rz(playerid, params[])
{
	if( !IsValidDynamicObject(pInfo[playerid][player_edited_object]) ) return SendGuiInformation(playerid, "Informacja", "Nie edytujesz ¿adnego obiektu.");
	
	new Float:rzs;
	if( sscanf(params, "f", rzs) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /rz [iloœæ stopni]");
	
	new o_id = pInfo[playerid][player_edited_object];
	
	SetDynamicObjectRot(pInfo[playerid][player_edited_object],  Object[o_id][object_pos][3], Object[o_id][object_pos][4], 360.0-rzs);

	if(pInfo[playerid][player_editor] == OBJECT_EDITOR_CUSTOM)
	{
		new Float:temp, Float:z;
		GetDynamicObjectRot(o_id, temp, temp, z);
		Object[o_id][object_pos][5] = z;
		return 1;
	}
	
	OnPlayerEditDynamicObject(playerid, pInfo[playerid][player_edited_object], EDIT_RESPONSE_UPDATE, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2], Object[o_id][object_pos][3], Object[o_id][object_pos][4], 360.0-rzs);
	pInfo[playerid][player_edited_object_no_action] = true;
	
	CancelEdit(playerid);
	EditDynamicObject(playerid, pInfo[playerid][player_edited_object]);
	
	return 1;
}

COMMAND:oz(playerid, params[])
{
	if( !IsValidDynamicObject(pInfo[playerid][player_edited_object]) ) return SendGuiInformation(playerid, "Informacja", "Nie edytujesz ¿adnego obiektu.");
	
	new Float:pzs;
	if( sscanf(params, "f", pzs) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /oz [iloœæ stopni]");
	
	new o_id = pInfo[playerid][player_edited_object];
	
	SetDynamicObjectPos(pInfo[playerid][player_edited_object],  Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]+pzs);

	if(pInfo[playerid][player_editor] == OBJECT_EDITOR_CUSTOM)
	{
		new Float:temp, Float:z;
		GetDynamicObjectPos(o_id, temp, temp, z);
		Object[o_id][object_pos][2] = z;
		return 1;
	}
	
	OnPlayerEditDynamicObject(playerid, pInfo[playerid][player_edited_object], EDIT_RESPONSE_UPDATE, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]+pzs, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
	return 1;
}

COMMAND:ox(playerid, params[])
{
	if( !IsValidDynamicObject(pInfo[playerid][player_edited_object]) ) return SendGuiInformation(playerid, "Informacja", "Nie edytujesz ¿adnego obiektu.");
	
	new Float:pzs;
	if( sscanf(params, "f", pzs) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ox [iloœæ stopni]");
	
	new o_id = pInfo[playerid][player_edited_object];
	
	SetDynamicObjectPos(pInfo[playerid][player_edited_object],  Object[o_id][object_pos][0]+pzs, Object[o_id][object_pos][1], Object[o_id][object_pos][2]);

	if(pInfo[playerid][player_editor] == OBJECT_EDITOR_CUSTOM)
	{
		new Float:temp, Float:x;
		GetDynamicObjectPos(o_id, x, temp, temp);
		Object[o_id][object_pos][0] = x;
		return 1;
	}
	
	OnPlayerEditDynamicObject(playerid, pInfo[playerid][player_edited_object], EDIT_RESPONSE_UPDATE, Object[o_id][object_pos][0]+pzs, Object[o_id][object_pos][1], Object[o_id][object_pos][2], Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
	return 1;
}

COMMAND:oy(playerid, params[])
{
	if( !IsValidDynamicObject(pInfo[playerid][player_edited_object]) ) return SendGuiInformation(playerid, "Informacja", "Nie edytujesz ¿adnego obiektu.");
	
	new Float:pzs;
	if( sscanf(params, "f", pzs) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /oy [iloœæ stopni]");
	
	new o_id = pInfo[playerid][player_edited_object];
	
	SetDynamicObjectPos(pInfo[playerid][player_edited_object],  Object[o_id][object_pos][0], Object[o_id][object_pos][1]+pzs, Object[o_id][object_pos][2]);

	if(pInfo[playerid][player_editor] == OBJECT_EDITOR_CUSTOM)
	{
		new Float:temp, Float:y;
		GetDynamicObjectPos(o_id, temp, y, temp);
		Object[o_id][object_pos][1] = y;
		return 1;
	}
	
	OnPlayerEditDynamicObject(playerid, pInfo[playerid][player_edited_object], EDIT_RESPONSE_UPDATE, Object[o_id][object_pos][0], Object[o_id][object_pos][1]+pzs, Object[o_id][object_pos][2], Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
	return 1;
}

// ---- 3d teksty ---- //
COMMAND:ec(playerid, params[])
{
	new owner = -1, owner_type = -1;
	GetLabelDataForPlayer(playerid, owner, owner_type);
	
	if( owner_type == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do tworzenia 3d textów w tym miejscu.");
	
	if( owner_type == LABEL_OWNER_TYPE_DOOR )
	{
		new d_id = GetDoorByUid(owner), count = CountDoorLabels(d_id);
		
		if( !HasCrewFlag(playerid, CREW_FLAG_EDITOR) )
		{
			if( IsPlayerVip(playerid) && count >= 5 ) return SendGuiInformation(playerid, "Informacja", "Posiadaj¹c konto premium mo¿esz stworzyæ maksymalnie 5 3d textow w ka¿dych drzwiach.");
			else if( !IsPlayerVip(playerid) && count >= 1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadaj¹c konta premium mo¿esz stworzyæ maksymalnie 1 3d text w ka¿dych drzwiach.");
		}
	}
	
	if( owner_type == LABEL_OWNER_TYPE_AREA )
	{
		new a_id = GetAreaByUid(owner), count = CountAreaLabels(a_id);
		
		if( !HasCrewFlag(playerid, CREW_FLAG_EDITOR) )
		{
			if( IsPlayerVip(playerid) && count >= 3 ) return SendGuiInformation(playerid, "Informacja", "Posiadaj¹c konto premium mo¿esz stworzyæ maksymalnie 5 3d textow w ka¿dej strefie.");
			else if( !IsPlayerVip(playerid) && count >= 1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadaj¹c konta premium mo¿esz stworzyæ maksymalnie 1 3d text w ka¿dej strefie.");
		}
	}
	
	new Float:distance, text[256];
	if( sscanf(params, "fs[256]", distance, text) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ec [dystans rysowania] [tekst]");
	if(strlen(text) > 120) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ec [dystans rysowania] [tekst]");
	if( distance <= 0.0 ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /ec [dystans rysowania] [tekst]");
	
	new Float:p_pos[3];
	GetPointInAngleOfPlayer(playerid, p_pos[0], p_pos[1], p_pos[2], 2.0, 0.0);
	mysql_escape_string(text, text, 256);
	mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_3dlabels` (label_uid, label_owner, label_ownertype, label_desc, label_color, label_posx, label_posy, label_posz, label_drawdist, label_world, label_interior) VALUES (null, %d, %d, '%s', '%s', %f, %f, %f, %f, %d, %d)", owner, owner_type, text, "FFFFFF", p_pos[0], p_pos[1], p_pos[2], distance, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)));
	
	new uid = cache_insert_id(), lid = LoadLabel(sprintf("WHERE `label_uid` = %d", uid), true);
	
	SendGuiInformation(playerid, "Informacja", sprintf("Utworzono 3d text [UID: %d, ID: %d].", uid, lid));
	
	return 1;
}

COMMAND:esel(playerid, params[])
{
	new l_id = GetClosestLabel(playerid);
	if( l_id == INVALID_3DTEXT_ID ) return SendPlayerInformation(playerid, "W poblizu nie ma zadnego 3d textu.", 4000);
	
	new string[200], text[15];
	GetDynamic3DTextLabelText(Text3D:l_id, string);			
	str_replace("\\n", "\n", string, text);
	string[0] = EOS;

	format(string, sizeof(string), "%d. 3dtext '%s...'~n~", Label[Text3D:l_id][label_uid], text);
	format(string, sizeof(string), "%s~y~Owner: ~w~%d:%d    ~y~Kolor: ~w~%06x    ~y~Draw: ~w~%.1f~n~", string, Label[Text3D:l_id][label_owner_type], Label[Text3D:l_id][label_owner], Label[Text3D:l_id][label_color], Label[Text3D:l_id][label_draw]);
	format(string, sizeof(string), "%s~n~~r~X: ~w~%.2f   ~r~Y: ~w~%.2f    ~r~Z: ~w~%.2f", string, Label[Text3D:l_id][label_pos][0], Label[Text3D:l_id][label_pos][1], Label[Text3D:l_id][label_pos][2]);
	
	TextDrawSetString(Dashboard[playerid], string);
	TextDrawShowForPlayer(playerid, Dashboard[playerid]);
	
	pInfo[playerid][player_esel_edited_label] = Label[Text3D:l_id][label_uid];

	pInfo[playerid][player_esel_edited_object] = CreateDynamicObject(1455, Label[Text3D:l_id][label_pos][0], Label[Text3D:l_id][label_pos][1], Label[Text3D:l_id][label_pos][2], 0.0, 0.0, 0.0, -1, -1, playerid, 50.0);
	EditDynamicObject(playerid, pInfo[playerid][player_esel_edited_object]);
	
	SendPlayerInformation(playerid, "~w~Edytuj obiekt aby ustalic pozycje ~y~3d textu", 10000);
	
	DeleteLabel(l_id, false);
	
	return 1;
}

COMMAND:edel(playerid, params[])
{
	if( !IsValidDynamicObject(pInfo[playerid][player_esel_edited_object]) ) return SendGuiInformation(playerid, "Informacja", "Nie edytujesz ¿adnego 3d textu.");
	
	SendGuiInformation(playerid, "Informacja", sprintf("Pomyslnie usunales 3d text [UID: %d].", pInfo[playerid][player_esel_edited_label]));

	mysql_query(mySQLconnection, sprintf("DELETE FROM `ipb_3dlabels` WHERE `label_uid` = %d", pInfo[playerid][player_esel_edited_label]));
	pInfo[playerid][player_esel_edited_label] = 0;
	
	DestroyDynamicObject(pInfo[playerid][player_esel_edited_object]);
	pInfo[playerid][player_esel_edited_object] = -1;
	
	SendPlayerInformation(playerid, "", 0);
	TextDrawHideForPlayer(playerid, Dashboard[playerid]);
	
	CancelEdit(playerid);
	return 1;
}

COMMAND:k(playerid, params[])
{
	if( isnull(params) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /(k)rzyk [tekst]");
	
	ProxMessage(playerid, params, PROX_SHOUT);
	return 1;
}

COMMAND:s(playerid, params[])
{
	return cmd_k(playerid, params);
}

COMMAND:c(playerid, params[])
{
	if( isnull(params) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /(c)icho [tekst]");
	
	ProxMessage(playerid, params, PROX_QUIET);
	return 1;
}

COMMAND:me(playerid, params[])
{
	if( isnull(params) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /me [czynnoœæ]");
	
	ProxMessage(playerid, params, PROX_ME);
	return 1;
}

COMMAND:do(playerid, params[])
{
	if( isnull(params) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /do [czynnoœæ]");
	
	ProxMessage(playerid, params, PROX_DO);
	return 1;
}

COMMAND:w(playerid, params[])
{
	return cmd_whisper(playerid, params);
}

COMMAND:pm(playerid, params[])
{
	return cmd_whisper(playerid, params);
}

COMMAND:whisper(playerid, params[])
{
	new targetid, message[180];
	if( sscanf(params, "ds[180]", targetid, message) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /(w)hisper [id gracza] [tekst]");
	if( isnull(message) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /(w)hisper [id gracza] [tekst]");
	if( !IsPlayerConnected(targetid) ) return SendGuiInformation(playerid, ""guiopis" Wyst¹pi³ b³¹d!", "Niestety nie odnaleziono gracza o tym ID!\nGracz o tym ID nie znajduje siê aktualnie w grze!");
	if( IsPlayerPBot(targetid) ) return SendGuiInformation(playerid, "Informacja", "Gracz o podanym id ma zablokowane wiadomoœci.");
	if( !pInfo[targetid][player_logged] ) return SendGuiInformation(playerid, "Informacja", "Gracz o podanym id nie jest zalogowany.");
	if( targetid == playerid ) return SendGuiInformation(playerid, "Informacja", "Nie mo¿esz pisaæ sam do siebie.");
	if(pGlobal[playerid][glo_block] & BLOCK_OOC) return SendGuiInformation(playerid, "Informacja", "Posiadasz aktywn¹ blokadê czatu OOC.");

	if(pInfo[playerid][player_admin_duty] == false)
	{
		if( PlayerHasTog(targetid, TOG_W) ) return SendGuiInformation(playerid, "Informacja", "Gracz o podanym id ma zablokowane wiadomoœci.");
	}
	
	if( pInfo[playerid][player_bw] > 0 && (!HasCrewFlag(targetid, CREW_FLAG_GM) && !HasCrewFlag(targetid, CREW_FLAG_ADMIN) && !HasCrewFlag(targetid, CREW_FLAG_ADMIN_ROOT)) ) return SendGuiInformation(playerid, "Informacja", "Podczas bw mozesz wysy³aæ wiadomoœci tylko do administratorów.");

	if(pInfo[playerid][player_admin_duty] == false)
	{
		if(pInfo[targetid][player_ignore] == pGlobal[playerid][glo_id]) return SendGuiInformation(playerid, "Informacja", "Ten gracz zablokowa³ wiadomoœci od Ciebie.");
	}

	if(strlen(message)>75)
	{
		new lineend[76], String[200];
	    format(lineend, sizeof(lineend), message);
	    strdel(lineend, 76, strlen(lineend));

    	format(String, sizeof(String),"(( > %s (%d): %s ... ))", pInfo[targetid][player_name], targetid, lineend);
		SendClientMessage(playerid, 0xFFCB73FF, String);

		format(String, sizeof(String),"(( %s (%d): %s ... ))", pInfo[playerid][player_name], playerid, lineend);
		SendClientMessage(targetid, 0xFFAE31FF, String);

		strdel(message, 0, 75);
		format(String, sizeof(String),"(( ... %s ))", message);
		SendClientMessage(playerid, 0xFFCB73FF, String);
		format(String, sizeof(String),"(( ... %s ))", message);
		SendClientMessage(targetid, 0xFFAE31FF, String);
	}
	else
	{
		if( GetPlayerUsedItem(targetid, ITEM_TYPE_MASKA) > -1 ) SendClientMessage(playerid, 0xFFCB73FF, sprintf("(( > %s: %s ))", pInfo[targetid][player_name], message));
		else SendFormattedClientMessage(playerid, 0xFFCB73FF, "(( > %s (%d): %s ))", pInfo[targetid][player_name], targetid, message);
		
		pInfo[targetid][player_last_pm_playerid] = playerid;
		if( GetPlayerUsedItem(playerid, ITEM_TYPE_MASKA) > -1 ) SendClientMessage(targetid, 0xFFAE31FF, sprintf("(( %s: %s ))", pInfo[playerid][player_name], message));
		else SendFormattedClientMessage(targetid, 0xFFAE31FF, "(( %s (%d): %s ))", pInfo[playerid][player_name], playerid, message);
	}

	pInfo[targetid][player_last_pm_playerid] = playerid;
	pInfo[playerid][player_last_pm_playerid] = targetid;
	
	if( pInfo[targetid][player_afk] )
	{
		new afkHour, afkMinute, temp;
		TimestampToDate(pInfo[targetid][player_last_activity], temp, temp, temp, afkHour, afkMinute, temp, 1);
		
		if( afkHour == 24 ) afkHour = 0;
		SendPlayerInformation(playerid, sprintf("Gracz do ktorego piszesz jest ~y~AFK~w~ od %02d:%02d", afkHour+1, afkMinute), 4000);
	}
	
	return 1;
}

COMMAND:tog(playerid, params[])
{
	if( !strcmp(params, "w") )
	{
		if( PlayerHasTog(playerid, TOG_W) )
		{
			pInfo[playerid][player_tog] -= TOG_W;
			SendGuiInformation(playerid, "Informacja", "Odblokowa³eœ mo¿liwoœæ wys³ania do Ciebie prywatnych wiadomoœci.");
		}
		else
		{
			pInfo[playerid][player_tog] += TOG_W;
			SendGuiInformation(playerid, "Informacja", "Zablokowa³eœ mo¿liwoœæ wys³ania do Ciebie prywatnych wiadomoœci.");
		}
	}
	else if( !strcmp(params, "g1") )
	{
		if( PlayerHasTog(playerid, TOG_G1) )
		{
			pInfo[playerid][player_tog] -= TOG_G1;
			SendGuiInformation(playerid, "Informacja", "Odblokowa³eœ wyœwietlanie czatu grupy na 1 slocie.");
		}
		else
		{
			pInfo[playerid][player_tog] += TOG_G1;
			SendGuiInformation(playerid, "Informacja", "Zablokowa³eœ wyœwietlanie czatu grupy na 1 slocie.");
		}
	}
	else if( !strcmp(params, "g2") )
	{
		if( PlayerHasTog(playerid, TOG_G2) )
		{
			pInfo[playerid][player_tog] -= TOG_G2;
			SendGuiInformation(playerid, "Informacja", "Odblokowa³eœ wyœwietlanie czatu grupy na 2 slocie.");
		}
		else
		{
			pInfo[playerid][player_tog] += TOG_G2;
			SendGuiInformation(playerid, "Informacja", "Zablokowa³eœ wyœwietlanie czatu grupy na 2 slocie.");
		}
	}
	else if( !strcmp(params, "g3") )
	{
		if( PlayerHasTog(playerid, TOG_G3) )
		{
			pInfo[playerid][player_tog] -= TOG_G3;
			SendGuiInformation(playerid, "Informacja", "Odblokowa³eœ wyœwietlanie czatu grupy na 3 slocie.");
		}
		else
		{
			pInfo[playerid][player_tog] += TOG_G3;
			SendGuiInformation(playerid, "Informacja", "Zablokowa³eœ wyœwietlanie czatu grupy na 3 slocie.");
		}
	}
	else if( !strcmp(params, "g4") )
	{
		if( PlayerHasTog(playerid, TOG_G4) )
		{
			pInfo[playerid][player_tog] -= TOG_G4;
			SendGuiInformation(playerid, "Informacja", "Odblokowa³eœ wyœwietlanie czatu grupy na 4 slocie.");
		}
		else
		{
			pInfo[playerid][player_tog] += TOG_G4;
			SendGuiInformation(playerid, "Informacja", "Zablokowa³eœ wyœwietlanie czatu grupy na 4 slocie.");
		}
	}
	else if( !strcmp(params, "g5") )
	{
		if( PlayerHasTog(playerid, TOG_G5) )
		{
			pInfo[playerid][player_tog] -= TOG_G5;
			SendGuiInformation(playerid, "Informacja", "Odblokowa³eœ wyœwietlanie czatu grupy na 5 slocie.");
		}
		else
		{
			pInfo[playerid][player_tog] += TOG_G5;
			SendGuiInformation(playerid, "Informacja", "Zablokowa³eœ wyœwietlanie czatu grupy na 5 slocie.");
		}
	}
	else if( !strcmp(params, "hud") )
	{
		if( PlayerHasTog(playerid, TOG_HUD) )
		{
			pInfo[playerid][player_tog] -= TOG_HUD;
			PlayerTextDrawShow(playerid, TextDrawSanNews[playerid]);			
			SendGuiInformation(playerid, "Informacja", "Odblokowa³eœ wyœwietlanie textdrawów.");
		}
		else
		{
			pInfo[playerid][player_tog] += TOG_HUD;
			SendGuiInformation(playerid, "Informacja", "Zablokowaleœ wyœwietlanie textdrawów.");

			PlayerTextDrawHide(playerid, TextDrawSanNews[playerid]);
			PlayerTextDrawHide(playerid, GroupDutyTag[playerid]);
		}
	}
	else return SendClientMessage(playerid, COLOR_GREY, "Tip: /tog [w/hud/g [slot]]");
	return 1;
}

COMMAND:re(playerid, params[])
{
	if( isnull(params) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /re [tekst]");
	if( !IsPlayerConnected(pInfo[playerid][player_last_pm_playerid]) ) return SendClientMessage(playerid, COLOR_GREY, "Gracz wyszed³ z serwera.");
	if( !pInfo[pInfo[playerid][player_last_pm_playerid]][player_logged] ) return SendClientMessage(playerid, COLOR_GREY, "Gracz nie jest zalogowany.");
	
	cmd_w(playerid, sprintf("%d %s", pInfo[playerid][player_last_pm_playerid], params));
	return 1;
}

COMMAND:resms(playerid, params[])
{
	if( isnull(params) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /resms [tekst]");
	if( !IsPlayerConnected(pInfo[playerid][player_last_sms])) return SendClientMessage(playerid, COLOR_GREY, "Gracz wyszed³ z serwera.");
	if( !pInfo[pInfo[playerid][player_last_sms]][player_logged] ) return SendClientMessage(playerid, COLOR_GREY, "Gracz nie jest zalogowany.");
	
	cmd_sms(playerid, sprintf("%d %s", pInfo[playerid][player_last_sms], params));
	return 1;
}

COMMAND:qs(playerid, params[])
{
	new
		Float:x,
		Float:y,
		Float:z,
		Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	
	mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_posx`='%f', `char_posy`='%f', `char_posz`='%f', `char_posa`='%f', `char_world`=%d, `char_interior`=%d, `char_quittime`=%d WHERE `char_uid`=%d", x, y, z, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), gettime(), pInfo[playerid][player_id]));
	Kick(playerid);
	return 1;
}

COMMAND:login(playerid, params[])
{
	new targetid;

	if(sscanf(params, "d", targetid)) targetid = playerid;
	if( !HasCrewFlag(playerid, CREW_FLAG_GM) && !HasCrewFlag(playerid, CREW_FLAG_ADMIN) && !HasCrewFlag(playerid, CREW_FLAG_ADMIN_ROOT) ) targetid = playerid;
	TextDrawHideForPlayer(targetid, Tutorial[targetid]);
	
	new
		Float:x,
		Float:y,
		Float:z,
		Float:a;
	GetPlayerPos(targetid, x, y, z);
	GetPlayerFacingAngle(targetid, a);
		
	mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_posx`='%f', `char_posy`='%f', `char_posz`='%f', `char_posa`='%f', `char_world`=%d, `char_interior`=%d, `char_quittime`=%d  WHERE `char_uid`=%d", x, y, z, a, GetPlayerVirtualWorld(targetid), GetPlayerInterior(targetid), gettime(), pInfo[targetid][player_id]));
	OnPlayerDisconnect(targetid, 0);
	OnPlayerConnect(targetid);

	return 1;
}

COMMAND:l(playerid, params[])
{
	if( isnull(params) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /l [tekst]");
	ProxMessage(playerid, params, PROX_LOCAL_L);
	return 1;
}

COMMAND:b(playerid, params[])
{
	if(pGlobal[playerid][glo_block] & BLOCK_OOC) return SendGuiInformation(playerid, "Informacja", "Posiadasz aktywn¹ blokadê czatu OOC.");
	if( isnull(params) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /b [tekst]");

	ProxMessage(playerid, params, PROX_OOC);
	return 1;
}

COMMAND:zamknij(playerid, params[])
{
	return cmd_drzwi(playerid, "zamknij");
}

COMMAND:drzwi(playerid, params[])
{
	new sub_cmd[40], param[150];	
	if( sscanf(params, "s[40] S()[150]", sub_cmd, param) )
	{
		//SendClientMessage(playerid, COLOR_GREY, "Tip: /drzwi [zamknij/opcje/wynajmij/wymelduj]");
		return cmd_drzwi(playerid, "opcje");
	}
	
	if( !strcmp(sub_cmd, "zamknij") || !strcmp(sub_cmd, "z")  )
	{
		new d_id = -1;

		foreach(new d : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]) && GetPlayerVirtualWorld(playerid) == Door[d][door_vw])
			{
				d_id = d;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0,  Door[d][door_spawn_pos][0],  Door[d][door_spawn_pos][1], Door[d][door_spawn_pos][2]) && GetPlayerVirtualWorld(playerid) == Door[d][door_spawn_vw])
			{
				d_id = d;
			}
		}
		
		if( d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz w ¿adnych drzwiach.");

		if(Door[d_id][door_rentable] == 0)
		{
			if( !CanPlayerUseDoor(playerid, d_id) && !HasCrewFlag(playerid, CREW_FLAG_ADMIN) ) return SendClientMessage(playerid, COLOR_GREY, "Nie posiadasz uprawnieñ do u¿ywania tych drzwi.");
			
			if( Door[d_id][door_closed] )
			{
                GameTextForPlayer(playerid, "~w~drzwi ~g~otwarte", 3000, 6);
				Door[d_id][door_closed] = false;
			}
			else
			{
				GameTextForPlayer(playerid, "~w~drzwi ~r~zamkniete", 3000, 6);
				Door[d_id][door_closed] = true;
			}
			
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		}
		else
		{
			if(pInfo[playerid][player_renting] == Door[d_id][door_uid] || HasCrewFlag(playerid, CREW_FLAG_ADMIN_ROOT))
			{
				if( Door[d_id][door_closed] )
				{
                    GameTextForPlayer(playerid, "~w~drzwi ~g~otwarte", 3000, 6);
					Door[d_id][door_closed] = false;
				}
				else
				{
                    GameTextForPlayer(playerid, "~w~drzwi ~r~zamkniete", 3000, 6);
					Door[d_id][door_closed] = true;
				}

				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", "Nie jesteœ najemc¹ tego mieszkania.");
			}
		}
	}

	else if( !strcmp(sub_cmd, "kup") )
	{
		new d_id = -1;

		foreach(new d : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]))
			{
				d_id = d;
			}
		}
		
		if( d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz w ¿adnych drzwiach.");

		if(Door[d_id][door_price] > 0)
		{
			if(pInfo[playerid][player_money] >= Door[d_id][door_price])
			{
				GivePlayerMoney(playerid, -Door[d_id][door_price]);

				Door[d_id][door_price] = 0;
				Door[d_id][door_owner] = pInfo[playerid][player_id];
				Door[d_id][door_owner_type] = DOOR_OWNER_TYPE_PLAYER;
				SendGuiInformation(playerid, "Informacja", "Zakupi³eœ drzwi.\nU¿yj komendy /drzwi aby nimi zarz¹dzaæ.");
				Streamer_SetIntData(STREAMER_TYPE_PICKUP, d_id, E_STREAMER_MODEL_ID, 19523);
				mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_price`= 0, door_owner = %d, door_ownertype = %d  WHERE `door_uid` = %d", pInfo[playerid][player_id], DOOR_OWNER_TYPE_PLAYER ,Door[d_id][door_uid]));
			}
			else 
			{
				SendGuiInformation(playerid, "Informacja", "Nie posiadasz przy sobie odpowiedniej iloœci gotówki.");
			}
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "Te drzwi nie s¹ na sprzeda¿.");
		}
	}

	else if( !strcmp(sub_cmd, "wynajmij") )
	{
		new d_id = -1;

		foreach(new d : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]))
			{
				d_id = d;
			}
		}
		
		if( d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz w ¿adnych drzwiach.");

		if(IsPlayerInAnyGroup(playerid))
		{
			if(Door[d_id][door_rentable] == 1)
			{
				if(Door[d_id][door_rent] < pInfo[playerid][player_money])
				{
					Door[d_id][door_rentable] = 2;
					GivePlayerMoney(playerid, -Door[d_id][door_rent]);
					pInfo[playerid][player_renting] = Door[d_id][door_uid];
					SendGuiInformation(playerid, "Informacja", "Wynaj¹³eœ mieszkanie, op³ata bedzie pobierana przy ka¿dej wyp³acie.\nPierwsza zosta³a pobrana ju¿ teraz.");
					mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_renting`= %d  WHERE `char_uid` = %d", Door[d_id][door_uid], pInfo[playerid][player_id]));
					mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_rentable`= 2  WHERE `door_uid` = %d", Door[d_id][door_uid]));
				}
				else 
				{
					SendGuiInformation(playerid, "Informacja", "Nie posiadasz przy sobie odpowiedniej iloœci gotówki.");
				}
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", "To mieszkanie nie jest na wynajem.");
			}
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "Nie mo¿esz wynaj¹æ mieszkania nie maj¹c Ÿród³a dochodu (grup).");
		}
	}

	else if( !strcmp(sub_cmd, "wymelduj") )
	{
		new d_id = -1;

		foreach(new d : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]))
			{
				d_id = d;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_spawn_pos][0],  Door[d][door_spawn_pos][1], Door[d][door_spawn_pos][2]))
			{
				d_id = d;
			}
		}
		
		if( d_id == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Nie stoisz w ¿adnych drzwiach.");

		if(Door[d_id][door_rentable]==2)
		{
			if(Door[d_id][door_uid] == pInfo[playerid][player_renting])
			{
				Door[d_id][door_rentable]=1;
				pInfo[playerid][player_renting]=0;
				SendGuiInformation(playerid, "Informacja", "Zwolni³eœ mieszkanie.");
				mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_renting`= 0  WHERE `char_uid` = %d", pInfo[playerid][player_id]));
				mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_rentable`= 1  WHERE `door_uid` = %d", Door[d_id][door_uid]));
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", "Nie jesteœ najemc¹ tego mieszkania.");
			}
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "To mieszkanie nie ma opcji wynajêcia, nie mozesz na nim u¿ywaæ tej komendy.");
		}
	}

	else if( !strcmp(sub_cmd, "opcje") )
	{
		new header[80], str[500];

		new d_id = -1;
		new ds_id = -1;

		foreach(new d : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]))
			{
				d_id = d;
			}
		}
		
		if( d_id == -1 ) 
		{
			ds_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
			
			if(ds_id == - 1)
			{
				new a_id = pInfo[playerid][player_area];
				if(a_id > 0 )
				{
					if(Area[a_id][area_price] <= 0) return SendGuiInformation(playerid, "Informacja", "Ta strefa nie posiada wyceny.");
					
					DynamicGui_Init(playerid);
					DynamicGui_AddRow(playerid, DG_DRZWI_CREATE);
					format(str, sizeof(str), "01\tStwórz nowy budynek ($%d)\n", Area[a_id][area_price]);
					ShowPlayerDialog(playerid, DIALOG_DRZWI, DIALOG_STYLE_LIST, "Kreator drzwi", str, "OK", "Anuluj");
				}
				else
				{
					SendGuiInformation(playerid, "Informacja", "Nie znajdujesz siê w ¿adnej strefie.");
				}
				return 1;
			}

			d_id = ds_id;
		}

		
		if(Door[d_id][door_rentable] == 0)
		{
			if( !CanPlayerEditDoor(playerid, d_id) ) return SendClientMessage(playerid, COLOR_GREY, "Nie masz uprawnieñ do edycji tych drzwi.");

			format(header, sizeof(header), "Drzwi %d (%s; SampID: %d)", Door[d_id][door_uid], Door[d_id][door_name], d_id);
			
			DynamicGui_Init(playerid);
			DynamicGui_SetDialogValue(playerid, d_id);
					
			format(str, sizeof(str), "%s01\tZmieñ wyœwietlan¹ nazwê\n", str);
			DynamicGui_AddRow(playerid, DG_DRZWI_NAME);	
			
			if( GetPlayerVirtualWorld(playerid) == Door[d_id][door_vw] )
			{			
				format(str, sizeof(str), "%s02\tEdytuj pozycje wewnêtrzn¹ (koordynaty)\n", str);
				DynamicGui_AddRow(playerid, DG_DRZWI_SPAWN_COORDS);
			}
			
			format(str, sizeof(str), "%s03\tUstaw muzykê\n", str);
			DynamicGui_AddRow(playerid, DG_DRZWI_AUDIO);
	
			
			if( GetPlayerVirtualWorld(playerid) == Door[d_id][door_spawn_vw] )
			{
				format(str, sizeof(str), "%s05\tSchowek\n", str);
				DynamicGui_AddRow(playerid, DG_DRZWI_SCHOWEK);	

				format(str, sizeof(str), "%s06\tEdytuj wymiary wnêtrza\n", str);
				DynamicGui_AddRow(playerid, DG_DRZWI_SURFACE);

				format(str, sizeof(str), "%s07\tEdytuj wewnêtrzn¹ pozycje\n", str);
				DynamicGui_AddRow(playerid, DG_DRZWI_SPAWN);

				format(str, sizeof(str), "%s08\tSkasuj interior (czyszczenie obiektów)\n", str);
            	DynamicGui_AddRow(playerid, DG_DRZWI_CLEAR);
			}

            format(str, sizeof(str), "%s09\tZmieñ godzinê\n", str);
            DynamicGui_AddRow(playerid, DG_DRZWI_TIME);  
			
			format(str, sizeof(str), "%s10\tOp³ata za wejœcie\n", str);
			DynamicGui_AddRow(playerid, DG_DRZWI_PAYMENT);
			
			format(str, sizeof(str), "%s11\tW(y)³¹cz przejazd pojazdami\n", str);
			DynamicGui_AddRow(playerid, DG_DRZWI_CARS);
			
			format(str, sizeof(str), "%s12\tZamykanie po restarcie\n", str);
			DynamicGui_AddRow(playerid, DG_DRZWI_CLOSING);

			format(str, sizeof(str), "%s13\tPrzypisz obiekty do stworzenia (%d przypisanych)\n", str, Door[d_id][door_objects_limit]);
			DynamicGui_AddRow(playerid, DG_DRZWI_BUY);

			if(Door[d_id][door_owner_type] == DOOR_OWNER_TYPE_PLAYER)
			{
				format(str, sizeof(str), "%s14\tPrzypisz pod grupê\n", str);
				DynamicGui_AddRow(playerid, DG_DRZWI_ASSIGN);
			}

			if(Door[d_id][door_owner_type] == DOOR_OWNER_TYPE_GROUP )
			{
				new gid = GetGroupByUid(Door[d_id][door_owner]);
				if(gid != -1)
				{
					if(Group[gid][group_creator] == pInfo[playerid][player_id])
					{
						format(str, sizeof(str), "%s14\tOdpisz od grupy\n", str);
						DynamicGui_AddRow(playerid, DG_DRZWI_UNSIGN);
					}
				}
			}

			if(Door[d_id][door_burned] > 0)
			{
				new price = Door[d_id][door_burned] *50;
				format(str, sizeof(str), "%s15\tNapraw zniszczenia - $%d\n", str, price);
				DynamicGui_AddRow(playerid, DG_DRZWI_FIX_BURN);
			}
			else if(Door[d_id][door_destroyed] > 0)
			{
				new price = Door[d_id][door_destroyed] * 25;
				format(str, sizeof(str), "%s15\tNapraw zniszczenia - $%d\n", str, price);
				DynamicGui_AddRow(playerid, DG_DRZWI_FIX);
			}

			if( DoorHasAccess(d_id, DOOR_ACCESS_CAMERA) )
			{
				format(str, sizeof(str), "%s16\tPrzejrzyj nagrania z kamer\n", str);
				DynamicGui_AddRow(playerid, DG_DRZWI_CAMERA);
			}
		}
		else
		{
			format(header, sizeof(header), "Drzwi %d (%s; SampID: %d)", Door[d_id][door_uid], Door[d_id][door_name], d_id);
		
			DynamicGui_Init(playerid);
			DynamicGui_SetDialogValue(playerid, d_id);
					
			format(str, sizeof(str), "%s01\tZmieñ wyœwietlan¹ nazwê\n", str);
			DynamicGui_AddRow(playerid, DG_DRZWI_NAME);	

			format(str, sizeof(str), "%s02\tUstaw muzykê\n", str);
			DynamicGui_AddRow(playerid, DG_DRZWI_AUDIO);
		}

		new owner_str[80];
		switch( Door[d_id][door_owner_type] )
		{
			case DOOR_OWNER_TYPE_GLOBAL:
			{
				format(owner_str, sizeof(owner_str), "globalne");
			}
			
			case DOOR_OWNER_TYPE_PLAYER:
			{			
				new name[MAX_PLAYER_NAME+1];
				GetPlayerNameByUid(Door[d_id][door_owner], name);
				
				format(owner_str, sizeof(owner_str), "gracz: %s", name);
			}
			
			case DOOR_OWNER_TYPE_GROUP:
			{			
				new gid = GetGroupByUid(Door[d_id][door_owner]);
				if(gid != -1)
				{
					format(owner_str, sizeof(owner_str), "grupa: %s", Group[gid][group_name]);
				}
			}
		}

		if(Door[d_id][door_rentable]!=0)
		{
			format(owner_str, sizeof(owner_str), "wynajem");
		}
		
		new string[540];
		format(string, sizeof(string), "Drzwi UID %d - %s~n~~n~~y~Owner: ~w~%d:%d(%s)~n~~y~Obiektow:~w~ %d/%d~n~", Door[d_id][door_uid], Door[d_id][door_name], Door[d_id][door_owner_type], Door[d_id][door_owner], owner_str, CountDoorObjects(d_id), Door[d_id][door_objects_limit]);
		format(string, sizeof(string), "%s~n~~y~Oplata za wejscie: ~w~$%d~n~~y~Przejazd: ~w~%s~n~~y~Zamykanie: ~w~%s", string, Door[d_id][door_payment], ((Door[d_id][door_car_crosing]) ? ("Tak") : ("Nie")), ((Door[d_id][door_auto_closing]) ? ("Tak") : ("Nie")));
		format(string, sizeof(string), "%s~n~~n~~b~~h~~h~VW:~w~ %d~n~~b~~h~~h~INT: ~w~%d", string, Door[d_id][door_spawn_vw], Door[d_id][door_spawn_int]);

		if(Door[d_id][door_access] != 0)
		{
			format(string, sizeof(string), "%s~n~~n~~r~~h~~h~Dodatki:~w~", string, Door[d_id][door_spawn_vw], Door[d_id][door_spawn_int]);

			if(DoorHasAccess(d_id, DOOR_ACCESS_CAMERA)) format(string, sizeof(string), "%s~n~- kamery", string);
			if(DoorHasAccess(d_id, DOOR_ACCESS_ALARM)) format(string, sizeof(string), "%s~n~- alarm", string);
			if(DoorHasAccess(d_id, DOOR_ACCESS_FIRE_SPRINKLER)) format(string, sizeof(string), "%s~n~- zraszacze przeciwpozarowe", string);
			if(DoorHasAccess(d_id, DOOR_ACCESS_METHLAB)) format(string, sizeof(string), "%s~n~- sprzet produkcyjny (meta)", string);
			if(DoorHasAccess(d_id, DOOR_ACCESS_AMPHLAB)) format(string, sizeof(string), "%s~n~- sprzet produkcyjny (amfetamina)", string);
			if(DoorHasAccess(d_id, DOOR_ACCESS_CRACKLAB)) format(string, sizeof(string), "%s~n~- sprzet produkcyjny (crack)", string);
			if(DoorHasAccess(d_id, DOOR_ACCESS_LAB_UPGRADES)) format(string, sizeof(string), "%s~n~- ulepszenie laboratorium", string);
		}

		
		TextDrawSetString(Tutorial[playerid], string);
		TextDrawShowForPlayer(playerid, Tutorial[playerid]);
		
		ShowPlayerDialog(playerid, DIALOG_DRZWI, DIALOG_STYLE_LIST, header, str, "Wybierz", "Zamknij");
	}
	else return SendClientMessage(playerid, COLOR_GREY, "Tip: /drzwi [zamknij/opcje]");
	return 1;
}

COMMAND:z(playerid, params[])
{
	return cmd_tel(playerid, "zakoncz");
}

COMMAND:od(playerid, params[])
{
	return cmd_tel(playerid, "odbierz");
}

COMMAND:tel(playerid, params[])
{
	new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_PHONE);
	if( itemid == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz w³¹czonego telefonu.");
	
	new sub_cmd[40], param[150];
	sscanf(params, "s[40] S()[150]", sub_cmd, param);
	
	if( isnull(params) )
	{
		DynamicGui_Init(playerid);
		DynamicGui_SetDialogValue(playerid, itemid);
		
		new str[150];
		
		format(str, sizeof(str), "%s01\tWybierz numer\n", str);
		DynamicGui_AddRow(playerid, DG_PHONE_CALL);
		
		format(str, sizeof(str), "%s02\tNapisz SMS\n", str);
		DynamicGui_AddRow(playerid, DG_PHONE_SMS);
		
		format(str, sizeof(str), "%s03\tKontakty\n", str);
		DynamicGui_AddRow(playerid, DG_PHONE_CONTACTS);

		format(str, sizeof(str), "%s04\tDodaj kontakt\n", str);
		DynamicGui_AddRow(playerid, DG_PHONE_ADD_CONTACT);
		
		format(str, sizeof(str), "%s05\tWyœlij vCard\n", str);
		DynamicGui_AddRow(playerid, DG_PHONE_VCARD);
		
		format(str, sizeof(str), "%s06\tWy³¹cz telefon\n", str);
		DynamicGui_AddRow(playerid, DG_PHONE_TURNOFF);
		
		new th, tmin, tsek;
		gettime(th, tmin, tsek);
		
		ShowPlayerDialog(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, sprintf("%s [%d] [%02d:%02d:%02d]", PlayerItem[playerid][itemid][player_item_name], PlayerItem[playerid][itemid][player_item_value1], th, tmin, tsek), str, "Wybierz", "Anuluj");
	}
	else
	{
		if( !strcmp(sub_cmd, "odbierz") || !strcmp(sub_cmd, "o") )
		{
			if( pInfo[playerid][player_phone_caller] != INVALID_PLAYER_ID && !pInfo[playerid][player_phone_call_started] )
			{
				// Odbieramy polaczenie
				SendClientMessage(playerid, COLOR_YELLOW, "Odebrano telefon. Aby zakonczyæ rozmowe u¿yj komendy /tel zakoncz.");
				SendClientMessage(pInfo[playerid][player_phone_caller], COLOR_YELLOW, "Rozmówca odebra³ telefon. Aby zakoñczyæ rozmowe u¿yj komendy /tel zakoncz.");
				pInfo[playerid][player_phone_call_started] = true;
				pInfo[pInfo[playerid][player_phone_caller]][player_phone_call_started] = true;
				
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	
				pInfo[playerid][player_phone_object_index] = GetPlayerFreeAttachSlot(playerid);
				if( pInfo[playerid][player_phone_object_index] > -1 ) SetPlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index], 330, 6);
			}
		}
		else if( !strcmp(sub_cmd, "zakoncz") || !strcmp(sub_cmd, "z") )
		{
			if( pInfo[playerid][player_phone_call_started] )
			{
				SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zakoñczona.");
				pInfo[playerid][player_phone_call_started] = false;
				
				new targetid = -1;
				if( pInfo[playerid][player_phone_caller] == INVALID_PLAYER_ID ) targetid = pInfo[playerid][player_phone_receiver];
				else targetid = pInfo[playerid][player_phone_caller];
				
				pInfo[playerid][player_phone_receiver] = INVALID_PLAYER_ID;
				pInfo[playerid][player_phone_caller] = INVALID_PLAYER_ID;
				
				SendClientMessage(targetid, COLOR_YELLOW, "Rozmowa zakoñczona.");
				pInfo[targetid][player_phone_call_started] = false;
				pInfo[targetid][player_phone_receiver] = INVALID_PLAYER_ID;
				pInfo[targetid][player_phone_caller] = INVALID_PLAYER_ID;
				
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				SetPlayerSpecialAction(targetid, SPECIAL_ACTION_STOPUSECELLPHONE);
				if( pInfo[playerid][player_phone_object_index] > -1 ) RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				if( pInfo[targetid][player_phone_object_index] > -1 ) RemovePlayerAttachedObject(targetid, pInfo[targetid][player_phone_object_index]);
			}
			else if( !pInfo[playerid][player_phone_call_started] && pInfo[playerid][player_phone_caller] != INVALID_PLAYER_ID )
			{
				// odrzuca polaczenie odbiorca
				SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zakoñczona.");
				pInfo[playerid][player_phone_call_started] = false;
				
				new targetid = -1;
				if( pInfo[playerid][player_phone_caller] == INVALID_PLAYER_ID ) targetid = pInfo[playerid][player_phone_receiver];
				else targetid = pInfo[playerid][player_phone_caller];
				
				pInfo[playerid][player_phone_receiver] = INVALID_PLAYER_ID;
				pInfo[playerid][player_phone_caller] = INVALID_PLAYER_ID;
				
				SendClientMessage(targetid, COLOR_YELLOW, "Sygna³ zajêtoœci...");
				pInfo[targetid][player_phone_call_started] = false;
				pInfo[targetid][player_phone_receiver] = INVALID_PLAYER_ID;
				pInfo[targetid][player_phone_caller] = INVALID_PLAYER_ID;
				
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				SetPlayerSpecialAction(targetid, SPECIAL_ACTION_STOPUSECELLPHONE);
				if( pInfo[playerid][player_phone_object_index] > -1 ) RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				if( pInfo[targetid][player_phone_object_index] > -1 ) RemovePlayerAttachedObject(targetid, pInfo[targetid][player_phone_object_index]);
			}
			else if( !pInfo[playerid][player_phone_call_started] && pInfo[playerid][player_phone_caller] == INVALID_PLAYER_ID )
			{			
				new targetid = -1;
				if( pInfo[playerid][player_phone_caller] == INVALID_PLAYER_ID ) targetid = pInfo[playerid][player_phone_receiver];
				else targetid = pInfo[playerid][player_phone_caller];

				if(targetid == -1 || targetid > 999) return 1;

				// przerywa polaczenie dzwoniacy
				SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zakoñczona.");
				pInfo[playerid][player_phone_call_started] = false;

				pInfo[playerid][player_phone_receiver] = INVALID_PLAYER_ID;
				pInfo[playerid][player_phone_caller] = INVALID_PLAYER_ID;
				
				SendClientMessage(targetid, COLOR_YELLOW, "Po³¹czenie przerwane.");
				pInfo[targetid][player_phone_call_started] = false;
				pInfo[targetid][player_phone_receiver] = INVALID_PLAYER_ID;
				pInfo[targetid][player_phone_caller] = INVALID_PLAYER_ID;
				
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				SetPlayerSpecialAction(targetid, SPECIAL_ACTION_STOPUSECELLPHONE);
				if( pInfo[playerid][player_phone_object_index] > -1 ) RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				if( pInfo[targetid][player_phone_object_index] > -1 ) RemovePlayerAttachedObject(targetid, pInfo[targetid][player_phone_object_index]);
			}
		}
	}
	return 1;
}

COMMAND:sms(playerid, params[])
{
	new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_PHONE);
	if( itemid == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz w³¹czonego telefonu.");
	
	new number, text[128];
	if( sscanf(params, "ds[128]", number, text) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /sms [numer telefonu] [treœæ]");
	if( number == Item[itemid][item_value1] ) return SendGuiInformation(playerid, "Informacja", "Nie mo¿esz wys³ac SMS do samego siebie.");

	//Sms Premium
	if(number >= 300 && number < 400)
	{
		new gid = GetGroupByPremiumNumber(number);

		if(gid != -1)
		{
			if(pInfo[playerid][player_money] < Group[gid][group_sms_cost]) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz tyle gotówki.");

			GivePlayerMoney(playerid, -Group[gid][group_sms_cost]);
			GiveGroupMoney(gid, Group[gid][group_sms_cost]);

			foreach(new p: Player)
			{
				if(GetPlayerGroupSlot(p, gid) != -1) 
				{
					SendFormattedClientMessage(p, COLOR_YELLOW, "(SMS PREMIUM) [%d]: %s", PlayerItem[playerid][itemid][player_item_value1], text);
				}
			}

		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "Ten numer SMS premium jest nieaktywny.");
		}

		return 1;
	}
	
	new targetid = GetPlayerByPhone(number);
	if( targetid == INVALID_PLAYER_ID ) return SendGuiInformation(playerid, "Informacja", "Taki numer telefonu nie istnieje.");
	new item = GetPlayerUsedItem(targetid, ITEM_TYPE_PHONE);
	if( item == -1 ) return SendGuiInformation(playerid, "Informacja", "Telefon o podanym numerze jest wy³¹czony.");
	
	new tmp_name[MAX_PLAYER_NAME+1], rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT contact_name FROM `ipb_contacts` WHERE `contact_owner` = %d AND `contact_number` = %d AND `contact_deleted` = 0", PlayerItem[targetid][itemid][player_item_uid], PlayerItem[playerid][itemid][player_item_value1]));	
	cache_get_row_count(rows);
	
	if( rows )
	{
		cache_get_value_index(0, 0, tmp_name);
		SendFormattedClientMessage(targetid, COLOR_YELLOW, "(SMS) [%d] %s: %s", PlayerItem[playerid][itemid][player_item_value1], tmp_name, text);
	}
	else
	{
		SendFormattedClientMessage(targetid, COLOR_YELLOW, "(SMS) %d: %s", PlayerItem[playerid][itemid][player_item_value1], text);
	}

	ProxMessage(playerid, "wysy³a SMSa.", PROX_ME);
	ProxMessage(targetid, "otrzyma³ SMSa.", PROX_ME);
	pInfo[targetid][player_last_sms] = playerid;
	
	new Float:p_pos[3];
	GetPlayerPos(targetid, p_pos[0], p_pos[1], p_pos[2]);

	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT contact_name FROM `ipb_contacts` WHERE `contact_owner` = %d AND `contact_number` = %d AND `contact_deleted` = 0", PlayerItem[playerid][itemid][player_item_uid], PlayerItem[targetid][item][player_item_value1]));	
	cache_get_row_count(rows);
	
	if( rows )
	{
		cache_get_value_index(0, 0, tmp_name);
		SendFormattedClientMessage(playerid, COLOR_YELLOW, "> (SMS) [%d] %s: %s", PlayerItem[targetid][item][player_item_value1], tmp_name, text);
	}
	else
	{
		SendFormattedClientMessage(playerid, COLOR_YELLOW, "> (SMS) %d: %s", PlayerItem[targetid][item][player_item_value1], text);
	}

	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	
	return 1;
}

COMMAND:call(playerid, params[])
{
	if( pInfo[playerid][player_phone_receiver] != INVALID_PLAYER_ID || pInfo[playerid][player_phone_caller] != INVALID_PLAYER_ID ) return SendGuiInformation(playerid, "Informacja", "Prowadzisz juz rozmowe.");

	new number;
	if( sscanf(params, "d", number) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /call [numer telefonu]");

	if( number == 555 ) // Hurtownia przestêpczych
	{
		new object_id = GetClosestObjectType(playerid, OBJECT_PHONEBOOTH);
		if(object_id == INVALID_STREAMER_ID) return SendGuiInformation(playerid, "Informacja", "Na ten numer mo¿esz zadzwoniæ tylko z budki telefonicznej.");

		if(IsPlayerInAnyGroup(playerid))
		{
			new slot = GetPlayerDutySlot(playerid), gid = pInfo[playerid][player_duty_gid];
			if(slot == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tego kontaktu.");
			if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tego kontaktu.");
			if( !GroupHasFlag(gid, GROUP_FLAG_BOT)) return SendGuiInformation(playerid, "Informacja", "Grupa na której jesteœ s³u¿bie nie posiada flagi do korzystania z tego kontaktu.");
			if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ liderem grupy na której jesteœ s³u¿bie, nie mo¿esz korzystaæ z tego kontaktu.");
			if(bot_taken > gettime()) return SendGuiInformation(playerid, "Informacja", "Dostawca jest teraz zajêty, spróbuj w przeci¹gu 15 minut.");

			SendClientMessage(playerid, COLOR_YELLOW, "Rozmówca odebra³ telefon.");
			SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: Mam teraz chwilê, gdzie chcesz siê spotkaæ?");
			ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ILLEGAL, DIALOG_STYLE_LIST, "Wybierz rejon spotkania", "Market\nRodeo\nWillowfield\nEast LS\nOcean Docks", "Wybierz", "WyjdŸ");

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			pInfo[playerid][player_phone_object_index] = GetPlayerFreeAttachSlot(playerid);
			if( pInfo[playerid][player_phone_object_index] > -1 ) SetPlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index], 330, 6);
			return 1;
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do ¿adnej grupy.");
			return 1;
		}
	}

	if( number == 666 ) // Przemyt
	{
		new object_id = GetClosestObjectType(playerid, OBJECT_PHONEBOOTH);
		if(object_id == INVALID_STREAMER_ID) return SendGuiInformation(playerid, "Informacja", "Na ten numer mo¿esz zadzwoniæ tylko z budki telefonicznej.");

		if(IsPlayerInAnyGroup(playerid))
		{
			new slot = GetPlayerDutySlot(playerid), gid = pInfo[playerid][player_duty_gid];
			if(slot == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tego kontaktu.");
			if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do tego kontaktu.");
			if( !GroupHasFlag(gid, GROUP_FLAG_BOT)) return SendGuiInformation(playerid, "Informacja", "Grupa na której jesteœ s³u¿bie nie posiada flagi do korzystania z tego kontaktu.");
			if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ liderem grupy na której jesteœ s³u¿bie, nie mo¿esz korzystaæ z tego kontaktu.");
			if(gettime() < Group[gid][group_last_smuggle]+ 5*86400) return SendGuiInformation(playerid, "Informacja", "Twoja grupa wykonywa³a ju¿ przemyt w tym tygodniu.");

			SendClientMessage(playerid, COLOR_YELLOW, "Rozmówca odebra³ telefon.");
			SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: Jak tam, organizujemy jakiœ transport?");
			ShowPlayerDialog(playerid, DIALOG_SMUGGLING, DIALOG_STYLE_LIST, "Wybierz typ przemytu", "Przemyt kontenerowcem\nPrzemyt ³odzi¹", "Wybierz", "WyjdŸ");

			new str[800];
			format(str, sizeof(str), "Produkty w kontenerach ~y~Chartered Libertine Lines:~w~~n~");
			format(str, sizeof(str), "%s-Kokaina (500g)~n~-AK47 (15 sztuk)~n~-Combat Shotgun~n~-Granatnik~n~-Granat (dymny/flash/smoke)~n~Koszt: $48000~n~~n~", str);
			format(str, sizeof(str), "%sProdukty w kontenerach ~y~Hanjin Lines:~w~~n~", str);
			format(str, sizeof(str), "%s-Heroina (600g)~n~-M4A1 (10 sztuk)~n~-Combat Shotgun~n~-Amunicja do broni dlugiej (25 sztuk)~n~Koszt: $45000~n~~n~", str);
			format(str, sizeof(str), "%sProdukty przemycane lodzia:~w~~n~", str);
			format(str, sizeof(str), "%s-Silenced pistol (5 sztuk)~n~-Rifle (5 sztuk)~n~-Obrzyn (5 sztuk)~n~-Molotov~n~Koszt: $6000~n~", str);

			TextDrawSetString(Tutorial[playerid], str);
			TextDrawShowForPlayer(playerid, Tutorial[playerid]);

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			pInfo[playerid][player_phone_object_index] = GetPlayerFreeAttachSlot(playerid);
			if( pInfo[playerid][player_phone_object_index] > -1 ) SetPlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index], 330, 6);
			return 1;
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do ¿adnej grupy.");
			return 1;
		}
	}


	new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_PHONE);
	if( itemid == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz w³¹czonego telefonu.");
	
	if(strval(params) < 3) return SendGuiInformation(playerid, "Informacja", "Telefon o podanym numerze jest wy³¹czony lub nie istnieje.");

	if( number == PlayerItem[playerid][itemid][player_item_value1] ) return SendGuiInformation(playerid, "Informacja", "Nie mo¿esz zadzwoniæ na swój numer.");
	
	if( number == 911) // Centrala PD
	{
		ShowPlayerDialog(playerid, DIALOG_911, DIALOG_STYLE_INPUT, "Numer alarmowy (centrala):", "Podaj treœæ zg³oszenia:", "OK", "");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		pInfo[playerid][player_dialog_tmp1] = PlayerItem[playerid][itemid][player_item_value1];
		pInfo[playerid][player_phone_object_index] = GetPlayerFreeAttachSlot(playerid);
		if( pInfo[playerid][player_phone_object_index] > -1 ) SetPlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index], 330, 6);
		return 1;
	}

	if( number == 444) // Weazel
	{
		ShowPlayerDialog(playerid, DIALOG_WEAZEL, DIALOG_STYLE_INPUT, "Centrala Weazel:", "Podaj treœæ zg³oszenia:", "OK", "");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		pInfo[playerid][player_dialog_tmp1] = PlayerItem[playerid][itemid][player_item_value1];
		pInfo[playerid][player_phone_object_index] = GetPlayerFreeAttachSlot(playerid);
		if( pInfo[playerid][player_phone_object_index] > -1 ) SetPlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index], 330, 6);
		return 1;
	}

	if( number == 333 ) // Hurtownia
	{
		if(IsPlayerInAnyGroup(playerid))
		{
			new slot = GetPlayerDutySlot(playerid);
			if(slot==-1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie grupy z dostêpem do hurtowni.");
			if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_ORDER) ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnieñ do zamawiania.");

			new list[128];
			format(list, sizeof(list), "1. Gastronomia\n2. Warsztat\n3. Porz¹dkowe\n4. Radio\n5. Ochrona\n6. Si³ownia\n7. Przestêpcze\n8. ERU\n.9. Nieokreœlone");
			ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_LEGAL, DIALOG_STYLE_LIST, "Hurtownia", list, "Wybierz", "WyjdŸ");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			pInfo[playerid][player_phone_object_index] = GetPlayerFreeAttachSlot(playerid);
			if( pInfo[playerid][player_phone_object_index] > -1 ) SetPlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index], 330, 6);
			return 1;
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "Nie nale¿ysz do ¿adnej grupy.");
			return 1;
		}
	}

	new targetid = GetPlayerByPhone(number);
	new item = GetPlayerUsedItem(targetid, ITEM_TYPE_PHONE);
	if( targetid == INVALID_PLAYER_ID ) return SendGuiInformation(playerid, "Informacja", "Telefon o podanym numerze jest wy³¹czony lub nie istnieje.");
	if( item == -1 ) return SendGuiInformation(playerid, "Informacja", "Telefon o podanym numerze jest wy³¹czony lub nie istnieje.");
	
	if( pInfo[targetid][player_phone_receiver] != INVALID_PLAYER_ID || pInfo[targetid][player_phone_caller] != INVALID_PLAYER_ID ) return SendClientMessage(playerid, COLOR_GREY, "Nie mo¿na po³aczyæ siê z wybranym numerem.");
	
	pInfo[targetid][player_phone_caller] = playerid;
	pInfo[targetid][player_phone_receiver] = INVALID_PLAYER_ID;
	
	pInfo[playerid][player_phone_receiver] = targetid;
	pInfo[playerid][player_phone_caller] = INVALID_PLAYER_ID;

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	
	pInfo[playerid][player_phone_object_index] = GetPlayerFreeAttachSlot(playerid);
	if( pInfo[playerid][player_phone_object_index] > -1 ) SetPlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index], 330, 6);

	ProxMessage(targetid, sprintf("Telefon %s zaczyna dzwoniæ.", pInfo[targetid][player_name]), PROX_DO);

	new tmp_name[MAX_PLAYER_NAME+1], rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT contact_name FROM `ipb_contacts` WHERE `contact_owner` = %d AND `contact_number` = %d AND `contact_deleted` = 0", PlayerItem[targetid][item][player_item_uid], PlayerItem[playerid][itemid][player_item_value1]));	
	cache_get_row_count(rows);
	
	if( rows )
	{
		cache_get_value_index(0, 0, tmp_name);
		SendFormattedClientMessage(targetid, COLOR_YELLOW, "Po³¹czenie przychodz¹ce od %s (%d). Wpisz /tel odbierz aby odebraæ lub /tel zakoncz aby odrzuciæ po³¹czenie.", tmp_name, PlayerItem[playerid][itemid][player_item_value1]);
	}
	else
	{
		SendFormattedClientMessage(targetid, COLOR_YELLOW, "Po³¹czenie przychodz¹ce od %d. Wpisz /tel odbierz aby odebraæ lub /tel zakoncz aby odrzuciæ po³¹czenie.", PlayerItem[playerid][itemid][player_item_value1]);
	}
	
	SendClientMessage(playerid, COLOR_YELLOW, "Sygna³ wybierania...");
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	
	return 1;
}

COMMAND:praca(playerid, params[])
{
	if( pInfo[playerid][player_job] == 0 ) return SendGuiInformation(playerid, "Informacja", "Nie masz ¿adnej pracy dorywczej. Aby podj¹c takow¹ udaj siê pod City Hall na Pershing Square.");
	
	new sub_cmd[40], param[150];
	sscanf(params, "s[40] S()[150]", sub_cmd, param);
	
	if( isnull(params) )
	{
		if(pInfo[playerid][player_job] == WORK_TYPE_LUMBERJACK)
		{
			new Lumberjack = GetClosestActorType(playerid, ACTOR_TYPE_LUMBERJACK);

			if(Lumberjack != INVALID_STREAMER_ID)
			{
				ShowPlayerDialog(playerid, DIALOG_LUMBERJACK, DIALOG_STYLE_TABLIST_HEADERS, "Pracownik tartaku", "Produkt\tCena\nPi³a ³añcuchowa\t$150", "Kup", "WyjdŸ");
			}
		}

		SendClientMessage(playerid, COLOR_GREY, "Tip: /praca opusc");
	}
	else
	{
		if( !strcmp(sub_cmd, "opusc") )
		{
			pInfo[playerid][player_job] = 0;
			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_job` = 0 WHERE `char_uid` = %d", pInfo[playerid][player_id]));
			
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 1495.9677,-1749.3802,15.4453))
			{
				DynamicGui_Init(playerid);
			
				DynamicGui_AddRow(playerid, WORK_TYPE_LUMBERJACK);
				DynamicGui_AddRow(playerid, WORK_TYPE_FISHER);
				DynamicGui_AddRow(playerid, WORK_TYPE_FORKLIFT);
				DynamicGui_AddRow(playerid, WORK_TYPE_TRASHMAN);
				
				ShowPlayerDialog(playerid, DIALOG_WORKS, DIALOG_STYLE_TABLIST_HEADERS, ""guiopis"Dostêpne prace dorywcze:", "Stanowisko\tWymagania\tLokalizacja\nPracownik tartaku\tPrawo jazdy\tThe Panopticon\nRybak\tbrak\tEast Beach\nOperator wózka wid³owego\tbrak\tOcean Docks\nKierowca œmieciarki\tPrawo jazdy\tWillowfield", "Wybierz", "Zamknij");
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", "Opuœci³eœ swoj¹ pracê dorywcza. Mo¿esz teraz podj¹æ inn¹.");
			}
		}
	}
	
	return 1;
}

COMMAND:v(playerid, params[])
{
	return cmd_pojazd(playerid, params);
}

COMMAND:pojazd(playerid, params[])
{	
	if( IsPlayerInAnyVehicle(playerid) )
	{
		new vid = GetPlayerVehicleID(playerid);
		
		new sub_cmd[40], param[150];
		sscanf(params, "s[40] S()[150]", sub_cmd, param);
		
		if( isnull(sub_cmd) )
		{
			// Sprawdzamy czy jest kierowca
			if( GetPlayerVehicleSeat(playerid) != 0 ) return 1;
			
			// Wyswietlamy panel pojazdu
			if( !CanPlayerUseVehicle(playerid, vid) ) return SendClientMessage(playerid, COLOR_GREY, "Brak uprawnieñ do u¿ywania tego pojazdu.");
			
			new header[80];
			format(header, sizeof(header), "%s (UID: %d, ID: %d)", VehicleNames[Vehicle[vid][vehicle_model]-400], Vehicle[vid][vehicle_uid], vid);
			
			DynamicGui_Init(playerid);
			
			new str[600];			
			format(str, sizeof(str), "%sMaska:\t%s\n", str, (Vehicle[vid][vehicle_bonnet]==false) ? (""HEX_COLOR_LIGHTER_RED"[Zamkniêta]") : (""HEX_COLOR_LIGHTER_GREEN"[Otwarta]"));
			DynamicGui_AddRow(playerid, DG_PLAYER_VEHICLE_PANEL_BONNET);
			format(str, sizeof(str), "%sBaga¿nik:\t%s\n", str, (Vehicle[vid][vehicle_boot]==false) ? (""HEX_COLOR_LIGHTER_RED"[Zamkniêty]") : (""HEX_COLOR_LIGHTER_GREEN"[Otwarty]"));
			DynamicGui_AddRow(playerid, DG_PLAYER_VEHICLE_PANEL_BOOT);
			format(str, sizeof(str), "%sŒwiat³a:\t%s\n", str, (Vehicle[vid][vehicle_lights]==false) ? (""HEX_COLOR_LIGHTER_RED"[Wy³¹czone]") : (""HEX_COLOR_LIGHTER_GREEN"[W³¹czone]"));
			DynamicGui_AddRow(playerid, DG_PLAYER_VEHICLE_PANEL_LIGHTS);
			format(str, sizeof(str), "%sSzyba kierowcy:\t%s\n", str, (Vehicle[vid][vehicle_win_driver]==true) ? (""HEX_COLOR_LIGHTER_RED"[Zamkniêta]") : (""HEX_COLOR_LIGHTER_GREEN"[Otwarta]"));
			DynamicGui_AddRow(playerid, DG_PLAYER_VEHICLE_PANEL_WIN_DRIVER);
			format(str, sizeof(str), "%sSzyba pasa¿era:\t%s\n", str, (Vehicle[vid][vehicle_win_pp]==true) ? (""HEX_COLOR_LIGHTER_RED"[Zamkniêta]") : (""HEX_COLOR_LIGHTER_GREEN"[Otwarta]"));
			DynamicGui_AddRow(playerid, DG_PLAYER_VEHICLE_PANEL_WIN_PP);
			format(str, sizeof(str), "%sSzyba lewa tylna:\t%s\n", str, (Vehicle[vid][vehicle_win_lt]==true) ? (""HEX_COLOR_LIGHTER_RED"[Zamkniêta]") : (""HEX_COLOR_LIGHTER_GREEN"[Otwarta]"));
			DynamicGui_AddRow(playerid, DG_PLAYER_VEHICLE_PANEL_WIN_LT);
			format(str, sizeof(str), "%sSzyba prawa tylna:\t%s\n", str, (Vehicle[vid][vehicle_win_pt]==true) ? (""HEX_COLOR_LIGHTER_RED"[Zamkniêta]") : (""HEX_COLOR_LIGHTER_GREEN"[Otwarta]"));
			DynamicGui_AddRow(playerid, DG_PLAYER_VEHICLE_PANEL_WIN_PT);
			
			ShowPlayerDialog(playerid, DIALOG_PLAYER_VEHICLE_PANEL, DIALOG_STYLE_TABLIST, header, str, "Wybierz", "Zamknij");
		}
		else
		{
			if( !strcmp(sub_cmd, "fix") )
			{
				if( !HasCrewFlag(playerid, CREW_FLAG_VEHICLES) ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie masz uprawnieñ do korzystania z tej komendy.");
				
				SetVehicleHealth(vid, 1500.0);

				Vehicle[vid][vehicle_destroyed] = false; 
				Vehicle[vid][vehicle_damage][0] = 0;
				Vehicle[vid][vehicle_damage][1] = 0;
				Vehicle[vid][vehicle_damage][2] = 0;
				Vehicle[vid][vehicle_damage][3] = 0;

				UpdateVehicleDamageStatus(vid, Vehicle[vid][vehicle_damage][0], Vehicle[vid][vehicle_damage][1], Vehicle[vid][vehicle_damage][2], Vehicle[vid][vehicle_damage][3]);

				SaveVehicle(vid);
				
				SendClientMessage(playerid, COLOR_GOLD, sprintf("Naprawi³eœ pojazd %s [UID: %d, ID: %d].", VehicleNames[GetVehicleModel(vid)-400], Vehicle[vid][vehicle_uid], vid));
				
				logprintf(LOG_VEHICLE, "[/av fix] [VUID: %d, PUID: %d, PGID: %d]", Vehicle[vid][vehicle_uid], pInfo[playerid][player_id], gInfo[playerid][global_id]);
			}

			if( !strcmp(sub_cmd, "zaparkuj", false) )
			{
				// Sprawdzamy czy jest kierowca
				if( GetPlayerVehicleSeat(playerid) != 0 ) return 1;
			
				if( !CanPlayerEditVehicle(playerid, vid) ) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do przeparkowania tego pojazdu.");

				new a_id = pInfo[playerid][player_area];
				if(a_id > 0 )
				{
					if(AreaHasFlag(a_id, AREA_FLAG_PARKING))
					{
						SendGuiInformation(playerid, "Informacja", "Ta strefa posiada flagê ograniczonego parkowania, nie mo¿esz tutaj u¿yæ tej komendy.");
						return 1;
					}
				}
				
				new Float:vehiclePos[4];
				GetVehiclePos(vid, vehiclePos[0], vehiclePos[1], vehiclePos[2]);
				GetVehicleZAngle(vid, vehiclePos[3]);
				new rows, Cache:tmp_cache;

				tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM `ipb_vehicles` WHERE `vehicle_posx` >= %f AND `vehicle_posx` <= %f AND `vehicle_posy` >= %f AND `vehicle_posy` <= %f AND `vehicle_world` = %d AND `vehicle_interior` = %d AND `vehicle_uid` <> %d", vehiclePos[0]-2.0, vehiclePos[0]+2.0, vehiclePos[1]-2.0, vehiclePos[1]+2.0, GetVehicleVirtualWorld(vid), Vehicle[vid][vehicle_interior], Vehicle[vid][vehicle_uid]));
				cache_get_row_count(rows);
				
				if( rows > 0 )
				{
					SendGuiInformation(playerid, "Informacja", "W tym miejscu jest ju¿ zaparkowany inny pojazd.");
					
				}
				else
				{
					GetVehiclePos(vid, Vehicle[vid][vehicle_park][0], Vehicle[vid][vehicle_park][1], Vehicle[vid][vehicle_park][2]);
					GetVehicleZAngle(vid, Vehicle[vid][vehicle_park][3]);
					Vehicle[vid][vehicle_park_world] = GetVehicleVirtualWorld(vid);
					Vehicle[vid][vehicle_park_interior] = Vehicle[vid][vehicle_interior];
					
					mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_vehicles` SET `vehicle_posx` = %f, `vehicle_posy` = %f, `vehicle_posz` = %f, `vehicle_posa` = %f, `vehicle_world` = %d, `vehicle_interior` = %d WHERE `vehicle_uid` = %d", Vehicle[vid][vehicle_park][0], Vehicle[vid][vehicle_park][1], Vehicle[vid][vehicle_park][2], Vehicle[vid][vehicle_park][3], Vehicle[vid][vehicle_park_world], Vehicle[vid][vehicle_park_interior], Vehicle[vid][vehicle_uid]));
					
					SendGuiInformation(playerid, "Informacja", sprintf("Pojazd %s (UID: %d) zosta³ zaparkowany.", VehicleNames[Vehicle[vid][vehicle_model]-400], Vehicle[vid][vehicle_uid], vid));
				}

				if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
			}

			if( !strcmp(sub_cmd, "z") || !strcmp(sub_cmd, "zamknij")  )
			{
				if( !CanPlayerUseVehicle(playerid, vid) ) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do u¿ywania tego pojazdu.");
				
				if( Vehicle[vid][vehicle_locked] )
				{
					Vehicle[vid][vehicle_locked] = false;
					GameTextForPlayer(playerid, "~w~pojazd ~g~otwarty", 3000, 6);
				}
				else
				{
					Vehicle[vid][vehicle_locked] = true;
					GameTextForPlayer(playerid, "~w~pojazd ~r~zamkniety", 3000, 6);
				}
				
				if( !VehicleHasAccessory(vid, VEHICLE_ACCESSORY_ALARM) )
				{
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				}
				else
				{
					ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}

			if( !strcmp(sub_cmd, "tuning") )
			{
				if( !CanPlayerUseVehicle(playerid, vid) ) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do u¿ywania tego pojazdu.");
				new tune_list[450];
				DynamicGui_Init(playerid);

				for (new j = 0; j < 14; ++j)
		   		{
					new componentid = GetVehicleComponentInSlot(vid, j);
		  			if (componentid != 0 && componentid == (Vehicle[vid][vehicle_component][j] + 999))
		        	{
		        		format(tune_list, sizeof(tune_list), "%s\n%s", tune_list, GetComponentName(componentid));
		        		DynamicGui_AddRow(playerid, componentid);
			        }
			    }

			    if(strlen(tune_list))
			    {
			    	ShowPlayerDialog(playerid, DIALOG_TUNE, DIALOG_STYLE_LIST, "Tuning pojazdu", tune_list, "Wyjmij", "Anuluj");
			    }
			    else
			    {
			    	SendGuiInformation(playerid, "Informacja", "Ten samochód nie posiada ¿adnych zamontowanych czêœci.");
			    }
			}
			else if( !strcmp(sub_cmd, "opis") )
			{
				if( !CanPlayerUseVehicle(playerid, vid) ) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do u¿ywania tego pojazdu.");
				if( isnull(param) && !Vehicle[vid][vehicle_has_description] ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /v opis [tekst]");
				else if( isnull(param) && Vehicle[vid][vehicle_has_description] )
				{
					UpdateDynamic3DTextLabelText(Vehicle[vid][vehicle_description], LABEL_DESCRIPTION, "");
					Vehicle[vid][vehicle_has_description] = false;
					SendGuiInformation(playerid, "Informacja", sprintf("Usun¹³eœ opis swojego pojazdu %s [UID: %d].", VehicleNames[GetVehicleModel(vid)-400], Vehicle[vid][vehicle_uid]));
					return 1;
				}
				
				UpdateDynamic3DTextLabelText(Vehicle[vid][vehicle_description], LABEL_DESCRIPTION, BreakLines(param, "\n", 32));
				Vehicle[vid][vehicle_has_description] = true;
				SendGuiInformation(playerid, "Informacja", sprintf("Ustawi³eœ opis swojego pojazdu %s [UID: %d].", VehicleNames[GetVehicleModel(vid)-400], Vehicle[vid][vehicle_uid]));
			}
			else if( !strcmp(sub_cmd, "sign") )
			{
				if( !CanPlayerUseVehicle(playerid, vid) ) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do u¿ywania tego pojazdu.");
				new gid = pInfo[playerid][player_duty_gid];
				if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jesteœ na s³u¿bie ¿adnej grupy.");
				if(!GroupHasFlag(gid, GROUP_FLAG_911)) return SendGuiInformation(playerid, "Informacja", "Grupa na której s³u¿bie jesteœ nie posiada uprawnieñ do u¿ywania tej komendy.");
				new slot = GetPlayerDutySlot(playerid);
				if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_VEHICLES) ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnieñ do pojazdów.");

				if( isnull(param) && !Vehicle[vid][vehicle_has_sign] ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /v sign [tekst]");
				else if( isnull(param) && Vehicle[vid][vehicle_has_sign] )
				{
					UpdateDynamic3DTextLabelText(Vehicle[vid][vehicle_sign], COLOR_WHITE, "");
					Vehicle[vid][vehicle_has_sign] = false;
					SendGuiInformation(playerid, "Informacja", sprintf("Usun¹³eœ car sign z pojazdu %s [UID: %d].", VehicleNames[GetVehicleModel(vid)-400], Vehicle[vid][vehicle_uid]));
					return 1;
				}
				
				UpdateDynamic3DTextLabelText(Vehicle[vid][vehicle_sign], COLOR_WHITE, BreakLines(param, "\n", 32));
				Vehicle[vid][vehicle_has_sign] = true;
				SendGuiInformation(playerid, "Informacja", sprintf("Ustawi³eœ car sign pojazdu %s [UID: %d].", VehicleNames[GetVehicleModel(vid)-400], Vehicle[vid][vehicle_uid]));
			}
			else if( !strcmp(sub_cmd, "przypisz") )
			{
				if( !CanPlayerUseVehicle(playerid, vid) ) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do u¿ywania tego pojazdu.");
				new gslot;
				if( sscanf(param, "d", gslot) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /v przypisz [slot grupy (1-5)]");
				if( gslot < 1 || gslot > 5 ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /v przypisz [slot grupy (1-5)]");
				if( pGroup[playerid][gslot-1][pg_id] == -1 ) return SendGuiInformation(playerid, "Informacja", "Brak grupy na tym slocie.");
				
				new gid = pGroup[playerid][gslot-1][pg_id];
				Vehicle[vid][vehicle_owner_type] = VEHICLE_OWNER_TYPE_GROUP;
				Vehicle[vid][vehicle_owner] = Group[gid][group_uid];
				mysql_query(mySQLconnection, sprintf("UPDATE `ipb_vehicles` SET `vehicle_ownertype` = %d, `vehicle_owner` = %d WHERE `vehicle_uid` = %d", VEHICLE_OWNER_TYPE_GROUP, Group[gid][group_uid], Vehicle[vid][vehicle_uid]));
				
				SendGuiInformation(playerid, "Informacja", sprintf("Podpisa³eœ swój pojazd %s [UID: %d] na grupe %s [UID: %d].", VehicleNames[GetVehicleModel(vid)-400], Vehicle[vid][vehicle_uid], Group[gid][group_name], Group[gid][group_uid]));
			}
			else if( !strcmp(sub_cmd, "info") )
			{
				if( !CanPlayerUseVehicle(playerid, vid) ) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do u¿ywania tego pojazdu.");
				
				new str[600], owner_str[40], access_str[32];

				switch( Vehicle[vid][vehicle_owner_type] )
				{
					case VEHICLE_OWNER_TYPE_PLAYER:
					{			
						new name[MAX_PLAYER_NAME+1];
						GetPlayerNameByUid(Vehicle[vid][vehicle_owner], name);
						
						format(owner_str, sizeof(owner_str), "%s", name);
					}
					
					case VEHICLE_OWNER_TYPE_GROUP:
					{			
						new gid = GetGroupByUid(Vehicle[vid][vehicle_owner]);
						format(owner_str, sizeof(owner_str), "%s", Group[gid][group_name]);
					}

					case VEHICLE_OWNER_TYPE_JOB:
					{			
						format(owner_str, sizeof(owner_str), "praca; %d", Vehicle[vid][vehicle_owner]);
					}
				}

				if(VehicleHasAccessory(vid, VEHICLE_ACCESSORY_IMMOBILISER))
				{
					format(access_str, sizeof(access_str), "immobiliser ");
				}

				if(VehicleHasAccessory(vid, VEHICLE_ACCESSORY_ALARM))
				{
					format(access_str, sizeof(access_str), "%salarm ", access_str);
				}

				if(VehicleHasAccessory(vid, VEHICLE_ACCESSORY_AUDIO))
				{
					format(access_str, sizeof(access_str), "%sradio", access_str);
				}

				if(Vehicle[vid][vehicle_accessories] == 0)
				{
					format(access_str, sizeof(access_str), "brak");
				}

				if(!PlayerHasAchievement(playerid, ACHIEV_DRIVER) && Vehicle[vid][vehicle_mileage] >= 10000) AddAchievement(playerid, ACHIEV_DRIVER, 1000);

				format(str, sizeof(str), "Pojazd UID %d - %s~n~~n~~y~Owner: ~w~%d:%d (%s)~n~~y~Kolory:~w~ %d:%d~n~", Vehicle[vid][vehicle_uid], VehicleNames[GetVehicleModel(vid)-400], Vehicle[vid][vehicle_owner_type], Vehicle[vid][vehicle_owner], owner_str, Vehicle[vid][vehicle_color][0], Vehicle[vid][vehicle_color][1]);
				format(str, sizeof(str), "%s~n~~y~Paliwo: ~w~%d/%d~n~~y~Rodzaj paliwa: ~w~%s~n~~y~Stan: ~w~%.1fHP", str, floatround(Vehicle[vid][vehicle_fuel_current], floatround_ceil), VehicleFuelMax[GetVehicleModel(vid)-400], VehicleFuelTypes[Vehicle[vid][vehicle_fuel_type]], Vehicle[vid][vehicle_health]);
				format(str, sizeof(str), "%s~n~~n~~b~~h~~h~Przebieg:~w~ %dkm~n~~b~~h~~h~Pojemnosc silnika: ~w~%.1f cm3", str, floatround(Vehicle[vid][vehicle_mileage], floatround_floor), VehicleEngineCapacity[GetVehicleModel(vid)-400]*1000);
				format(str, sizeof(str), "%s~n~~n~~p~Akcesoria:~w~ %s~n~~n~Klawisz ~p~N~w~ zamyka to okno.", str, access_str);
				
				TextDrawSetString(Tutorial[playerid], str);
				TextDrawShowForPlayer(playerid, Tutorial[playerid]);
			}
		}
	}
	else
	{
		new sub_cmd[40], param[150];
		sscanf(params, "s[40] S()[150]", sub_cmd, param);
		
		if( isnull(sub_cmd) )
		{
			SendClientMessage(playerid, COLOR_GREY, "Tip: /v [namierz, zaparkuj, tuning, przypisz, zamknij, info, opis]");
			
			new str[400], rows, Cache:tmp_cache;

			tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT vehicle_uid, vehicle_model FROM `ipb_vehicles` WHERE `vehicle_ownertype` = %d AND `vehicle_owner` = %d", VEHICLE_OWNER_TYPE_PLAYER, pInfo[playerid][player_id]));
			cache_get_row_count(rows);
			
			if( !rows ) SendGuiInformation(playerid, "Informacja", "Nie posiadasz ¿adnych pojazdów.");
			else
			{
				if(!PlayerHasAchievement(playerid, ACHIEV_FIRSTCAR)) AddAchievement(playerid, ACHIEV_FIRSTCAR, 350);
				DynamicGui_Init(playerid);
				for(new row = 0; row != rows; row++)
				{
					new uid, model;
					cache_get_value_index_int(row, 0, uid);
					cache_get_value_index_int(row, 1, model);

					// Wszystkie pojazdy gracza dodajemy do listy
					format(str, sizeof(str), "%s%s%d\t\t%s\n", str, ((GetVehicleByUid(uid) != INVALID_VEHICLE_ID) ? (HEX_COLOR_GREEN) : (HEX_COLOR_WHITE)), uid, VehicleNames[model-400]);
					DynamicGui_AddRow(playerid, uid);
				}
			
				ShowPlayerDialog(playerid, DIALOG_PLAYER_VEHICLES, DIALOG_STYLE_LIST, ""guiopis"Lista Twoich pojazdów:", str, "(Un)spawn", "Zamknij");
				if(!PlayerHasAchievement(playerid, ACHIEV_CARS) && rows >= 6) AddAchievement(playerid, ACHIEV_CARS, 1500);
			}

			if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
		}
		else
		{
			if( !strcmp(sub_cmd, "z") || !strcmp(sub_cmd, "zamknij")  )
			{
				new v_id = GetNearestPlayerVehicle(playerid);
				if( v_id == -1 ) return SendGuiInformation(playerid, "Informacja", "Brak pojazdów w pobli¿u lub brak uprawnieñ.");
				
				if( Vehicle[v_id][vehicle_locked] )
				{
					Vehicle[v_id][vehicle_locked] = false;
					GameTextForPlayer(playerid, "~w~pojazd ~g~otwarty", 3000, 6);
				}
				else
				{
					Vehicle[v_id][vehicle_locked] = true;
					GameTextForPlayer(playerid, "~w~pojazd ~r~zamkniety", 3000, 6);
				}
				
				if( !VehicleHasAccessory(v_id, VEHICLE_ACCESSORY_ALARM) )
				{
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				}
				else
				{
					foreach(new p : Player)
					{
						if( GetPlayerDistanceFromPoint(p, Vehicle[v_id][vehicle_last_pos][0], Vehicle[v_id][vehicle_last_pos][1], Vehicle[v_id][vehicle_last_pos][2]) <= 20.0 ) PlayAudioStreamForPlayer(p, "http://iphonegu.com/wp-content/uploads/2012/09/car_lock.mp3", Vehicle[v_id][vehicle_last_pos][0], Vehicle[v_id][vehicle_last_pos][1], Vehicle[v_id][vehicle_last_pos][2], 20.0, 1);
					}
					
					ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}

			else if( !strcmp(sub_cmd, "fix") )
			{
				if( !HasCrewFlag(playerid, CREW_FLAG_VEHICLES) ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie masz uprawnieñ do korzystania z tej komendy.");
				new vid;

				if( sscanf(param, "d", vid) )
				{
					vid = GetNearestVehicle(playerid);
					if( vid == -1 ) return SendGuiInformation(playerid, "Informacja", "Brak pojazdów w pobli¿u.");
					
					SetVehicleHealth(vid, 1500.0);

					Vehicle[vid][vehicle_destroyed] = false; 
					Vehicle[vid][vehicle_damage][0] = 0;
					Vehicle[vid][vehicle_damage][1] = 0;
					Vehicle[vid][vehicle_damage][2] = 0;
					Vehicle[vid][vehicle_damage][3] = 0;

					UpdateVehicleDamageStatus(vid, Vehicle[vid][vehicle_damage][0], Vehicle[vid][vehicle_damage][1], Vehicle[vid][vehicle_damage][2], Vehicle[vid][vehicle_damage][3]);

					SaveVehicle(vid);
					
					SendClientMessage(playerid, COLOR_GOLD, sprintf("Naprawi³eœ pojazd %s [UID: %d, ID: %d].", VehicleNames[GetVehicleModel(vid)-400], Vehicle[vid][vehicle_uid], vid));
					
					logprintf(LOG_VEHICLE, "[/av fix] [VUID: %d, PUID: %d, PGID: %d]", Vehicle[vid][vehicle_uid], pInfo[playerid][player_id], gInfo[playerid][global_id]);
				}
				else
				{
					if( !Iter_Contains(Vehicles, vid) ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Pojazd o podanym id nie istnieje.");

					SetVehicleHealth(vid, 1500.0);

					Vehicle[vid][vehicle_destroyed] = false; 
					Vehicle[vid][vehicle_damage][0] = 0;
					Vehicle[vid][vehicle_damage][1] = 0;
					Vehicle[vid][vehicle_damage][2] = 0;
					Vehicle[vid][vehicle_damage][3] = 0;

					UpdateVehicleDamageStatus(vid, Vehicle[vid][vehicle_damage][0], Vehicle[vid][vehicle_damage][1], Vehicle[vid][vehicle_damage][2], Vehicle[vid][vehicle_damage][3]);

					SaveVehicle(vid);
					
					SendClientMessage(playerid, COLOR_GOLD, sprintf("Naprawi³eœ pojazd %s [UID: %d, ID: %d].", VehicleNames[GetVehicleModel(vid)-400], Vehicle[vid][vehicle_uid], vid));
					
					logprintf(LOG_VEHICLE, "[/av fix] [VUID: %d, PUID: %d, PGID: %d]", Vehicle[vid][vehicle_uid], pInfo[playerid][player_id], gInfo[playerid][global_id]);
				}
			}

			else if( !strcmp(sub_cmd, "namierz", false) )
			{
				new v_uid;
				if( sscanf(param, "d", v_uid) )
				{
					if( pInfo[playerid][player_vehicle_target] > -1 )
					{
						Streamer_RemoveArrayData(STREAMER_TYPE_MAP_ICON, Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_map_icon], E_STREAMER_PLAYER_ID, playerid);
						Streamer_UpdateEx(playerid, Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][0], Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][1], Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][2]);
						
						SendClientMessage(playerid, COLOR_GOLD, "Namierzanie pojazdu zosta³o wy³¹czone.");
						pInfo[playerid][player_vehicle_target] = -1;
					}
					else
					{
						SendClientMessage(playerid, COLOR_GREY, "Tip: /v namierz [uid pojazdu]");
					}
					return 1;
				}
				
				new vid = GetVehicleByUid(v_uid);
				if( vid == INVALID_VEHICLE_ID ) return SendGuiInformation(playerid, "Informacja", "Pojazd o podanym uid nie istnieje lub nie jest zespawnowany.");
				
				if( !CanPlayerUseVehicle(playerid, vid) ) return SendGuiInformation(playerid, "Informacja", "Nie masz uprawnieñ do u¿ywania tego pojazdu.");
				
				// Jesli juz jakies namierzanie jest wlaczone to je wylaczamy
				if( pInfo[playerid][player_vehicle_target] > -1 )
				{
					Streamer_RemoveArrayData(STREAMER_TYPE_MAP_ICON, Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_map_icon], E_STREAMER_PLAYER_ID, playerid);
					
					Streamer_UpdateEx(playerid, Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][0], Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][1], Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][2]);
				}
				
				pInfo[playerid][player_vehicle_target] = vid;
				Streamer_AppendArrayData(STREAMER_TYPE_MAP_ICON, Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_map_icon], E_STREAMER_PLAYER_ID, playerid);
				
				Streamer_UpdateEx(playerid, Vehicle[vid][vehicle_last_pos][0], Vehicle[vid][vehicle_last_pos][1], Vehicle[vid][vehicle_last_pos][2]);
				
				new other_vw[60];
				if( GetVehicleVirtualWorld(vid) > 0 ) format(other_vw, sizeof(other_vw), "\n\n"HEX_COLOR_LIGHTER_RED"Ten pojazd znajduje siê w innym vw  (%d).", GetVehicleVirtualWorld(vid));
				
				SendGuiInformation(playerid, "Informacja", sprintf("Pojazd zosta³ oznaczony na radarze.\nAby wy³aczyæ namierzanie wejdŸ do pojazdu lub wpisz /v namierz off.%s", other_vw));
				return 1;	
			}
		}
	}
	return 1;
}


COMMAND:u(playerid, params[])
{
	return cmd_przedmioty(playerid, params);
}

COMMAND:p(playerid, params[])
{
	return cmd_przedmioty(playerid, params);
}

COMMAND:przedmioty(playerid, params[])
{
	if( isnull(params) )
	{
		ListPlayerItems(playerid);
	}
	else
	{
		new sub_cmd[40], param[128];
		sscanf(params, "s[40] S()[128]", sub_cmd, param);
		
		if( !strcmp(sub_cmd, "podnies") || !strcmp(sub_cmd, "p")  )
		{
			ListPlayerGroundItems(playerid);
			return 1;
		}

		else if( !strcmp(sub_cmd, "zabierz") )
		{
			if(!HasCrewFlag(playerid, CREW_FLAG_GM) && !HasCrewFlag(playerid, CREW_FLAG_ADMIN) && !HasCrewFlag(playerid, CREW_FLAG_ADMIN_ROOT)) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz uprawnieñ do korzystania z tej komendy.");
			new item, itemid, targetid;
			if(sscanf(param, "dd", targetid, item)) return SendClientMessage(playerid, COLOR_GREY, "Tip: /p zabierz [id gracza] [uid przedmiotu]");
			if(!IsPlayerConnected(targetid)||targetid==playerid) return SendClientMessage(playerid, COLOR_GREY, "Tip: Niepoprawne ID gracza.");

			itemid = GetItemByTargetUid(item, targetid);
			if(itemid == -1) return SendGuiInformation(playerid, "Informacja", "Niepoprawne UID przedmiotu.");
			if(!Iter_Contains(PlayerItems[targetid], itemid)) return SendGuiInformation(playerid, "Informacja", "Niepoprawne UID przedmiotu.");

			pInfo[playerid][player_capacity] += PlayerItem[targetid][itemid][player_item_weight];
			pInfo[targetid][player_capacity] -= PlayerItem[targetid][itemid][player_item_weight];

			if(PlayerItem[targetid][itemid][player_item_used])
			{
				SendGuiInformation(playerid, "Informacja", "Ten przedmiot jest w u¿yciu.");
				return 1;
			}

			mysql_query(mySQLconnection, sprintf("UPDATE ipb_items SET item_owner = %d WHERE item_uid = %d", pInfo[playerid][player_id], item));

			SendGuiInformation(playerid, "Informacja", sprintf("Odebra³eœ przedmiot %s (UID %d) graczowi %s.", PlayerItem[targetid][itemid][player_item_name], item, pInfo[targetid][player_name]));
			SendGuiInformation(targetid, "Informacja", sprintf("Administrator %s odebra³ ci przedmiot %s (UID %d).", pInfo[playerid][player_name], PlayerItem[targetid][itemid][player_item_name], item));

			DeleteItem(itemid, false, targetid);
			LoadPlayerItem(playerid, sprintf("WHERE `item_uid` = %d", item), true);
			return 1;
		}

		else if( !strcmp(sub_cmd, "lista") )
		{
			if(!HasCrewFlag(playerid, CREW_FLAG_GM) && !HasCrewFlag(playerid, CREW_FLAG_ADMIN) && !HasCrewFlag(playerid, CREW_FLAG_ADMIN_ROOT)) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz uprawnieñ do korzystania z tej komendy.");
			new player;
			if(	sscanf(param, "d", player) ) return SendClientMessage(playerid, COLOR_GREY, "Tip: /p lista [id gracza]");
			if(!IsPlayerConnected(player)) return SendClientMessage(playerid, COLOR_GREY, "Tip: Niepoprawne id gracza.");
			
			new count, string[1024], header[64];
			
			format(string, sizeof(string), "%sNazwa\tWaga\tUID\n", string);
			format(header, sizeof(header), "Lista przedmiotów %s", pInfo[player][player_name]);

			foreach (new item : PlayerItems[player])
			{
				new prefix[10]; 
				if( PlayerItem[player][item][player_item_used] ) prefix = "{CFFD66}";

				format(string, sizeof(string), "%s %s%s\t%dg\t%d\n", string, prefix, PlayerItem[player][item][player_item_name], PlayerItem[player][item][player_item_weight], PlayerItem[player][item][player_item_uid]);
				count++;
			}
		
			if( count == 0 ) SendGuiInformation(playerid, "Informacja", "Ten gracz nie posiada przedmiotów.");
			else ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_TABLIST_HEADERS, header, string, "OK", "");
			return 1;
		}

		Item_FastUsage(playerid, sub_cmd, param);
	}
	
	return 1;
}

COMMAND:pomoc(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, ""guiopis"Szukasz pomocy?", "{ffffff}» Co i jak?\n{ffffff}» Out Of Character i In Character\n{ffffff}» Podstawowe komendy\n{ffffff}» Animacje\n{ffffff}» Pojazdy\n{ffffff}» Przedmioty\n{ffffff}» Oferty\n{ffffff}» Czaty grupowe\n{ffffff}» System Obiektow\n{ffffff}» Prace dorywcze", "Wybierz", "Anuluj");
	return 1;
}
