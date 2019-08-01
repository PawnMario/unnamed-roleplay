stock LoadDoor(limit[] = "", bool:return_id = false)
{
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM ipb_doors %s", limit));  
	cache_get_row_count(rows);
	
	new d_id;
	
	for(new row = 0; row != rows; row++)
	{
		new Float:tmp_x, Float:tmp_y, Float:tmp_z, tmp_model, tmp_vw, tmp_int;
		cache_get_value_index_int(row, 17, tmp_model);
		cache_get_value_index_float(row, 5, tmp_x);
		cache_get_value_index_float(row, 6, tmp_y);
		cache_get_value_index_float(row, 7, tmp_z);
		cache_get_value_index_int(row, 9, tmp_vw);
		cache_get_value_index_int(row, 10, tmp_int);

		d_id = CreateDynamicPickup(tmp_model, 2, tmp_x, tmp_y, tmp_z, tmp_vw, tmp_int, -1, 200.0);

		Iter_Add(Doors, d_id);	
		
		cache_get_value_index(row, 2, Door[d_id][door_name], 40);
		cache_get_value_index(row, 23, Door[d_id][door_audio], 100);

		cache_get_value_index_int(row, 0, Door[d_id][door_uid]);
		cache_get_value_index_int(row, 1, Door[d_id][door_type]);
		cache_get_value_index_int(row, 3, Door[d_id][door_owner_type]);
		cache_get_value_index_int(row, 4, Door[d_id][door_owner]);
		cache_get_value_index_int(row, 22, Door[d_id][door_objects_limit]);

		new tmp_closing, tmp_car_cros;
		cache_get_value_index_int(row, 19, tmp_closing);
		cache_get_value_index_int(row, 20, tmp_car_cros);
		Door[d_id][door_auto_closing] = !!tmp_closing;
		Door[d_id][door_car_crosing] = !!tmp_car_cros;
		cache_get_value_index_int(row, 21, Door[d_id][door_payment]);

		Door[d_id][door_pos][0] = tmp_x;
		Door[d_id][door_pos][1] = tmp_y;
		Door[d_id][door_pos][2] = tmp_z;
		cache_get_value_index_float(row, 8, Door[d_id][door_pos][3]);

		Door[d_id][door_vw] = tmp_vw;
		Door[d_id][door_int] = tmp_int;
		cache_get_value_index_float(row, 11, Door[d_id][door_spawn_pos][0]);
		cache_get_value_index_float(row, 12, Door[d_id][door_spawn_pos][1]);
		cache_get_value_index_float(row, 13, Door[d_id][door_spawn_pos][2]);
		cache_get_value_index_float(row, 14, Door[d_id][door_spawn_pos][3]);

		cache_get_value_index_int(row, 15, Door[d_id][door_spawn_vw]);

		if( Door[d_id][door_spawn_vw] == -1 ) Door[d_id][door_spawn_vw] = Door[d_id][door_uid];
		cache_get_value_index_int(row, 16, Door[d_id][door_spawn_int]);

		cache_get_value_index_int(row, 24, Door[d_id][door_rentable]);
		cache_get_value_index_int(row, 25, Door[d_id][door_rent]);
		cache_get_value_index_int(row, 27, Door[d_id][door_price]);
		cache_get_value_index_int(row, 28, Door[d_id][door_time]);
		cache_get_value_index_int(row, 29, Door[d_id][door_access]);
		cache_get_value_index_int(row, 30, Door[d_id][door_destroyed]);
		cache_get_value_index_int(row, 31, Door[d_id][door_burned]);
		//cache_get_value_index_int(row, 31, Door[d_id][door_meters]);

		switch(Door[d_id][door_owner_type])
		{
			case DOOR_OWNER_TYPE_GROUP:
			{
				new gid = GetGroupByUid(Door[d_id][door_owner]);
				if(gid != -1)
				{ 
					if(GroupHasFlag(gid, GROUP_FLAG_BUSINESS))	Streamer_SetIntData(STREAMER_TYPE_PICKUP, d_id, E_STREAMER_MODEL_ID, 1272);
					if(GroupHasFlag(gid, GROUP_FLAG_BOT))		Streamer_SetIntData(STREAMER_TYPE_PICKUP, d_id, E_STREAMER_MODEL_ID, 19522);
				}
				else
				{
					printf("Drzwi %s (%d) sa podpisane pod niestniejaca grupe. Skasowac lub wystawic na sprzedaz.", Door[d_id][door_name], Door[d_id][door_uid]);
				}
			}
			case DOOR_OWNER_TYPE_PLAYER:
			{
				Streamer_SetIntData(STREAMER_TYPE_PICKUP, d_id, E_STREAMER_MODEL_ID, 19523);

				//Checking owner activity
				mysql_tquery(mySQLconnection, sprintf("SELECT session_start FROM ipb_game_sessions WHERE session_type = %d AND session_owner = %d ORDER BY session_uid DESC LIMIT 1", SESSION_TYPE_LOGIN, Door[d_id][door_owner]), "DeleteInactiveDoor", "d", d_id);
			}
			case DOOR_OWNER_TYPE_GLOBAL:
			{
				if(tmp_model != 1275 && tmp_model != 1277 && tmp_model != 1274) Streamer_SetIntData(STREAMER_TYPE_PICKUP, d_id, E_STREAMER_MODEL_ID, 19524);
			}
		}

		if(Door[d_id][door_price] > 0 && Door[d_id][door_owner_type] == DOOR_OWNER_TYPE_GLOBAL) Streamer_SetIntData(STREAMER_TYPE_PICKUP, d_id, E_STREAMER_MODEL_ID, 1273);

		Pickup[d_id][pickup_type] = PICKUP_TYPE_DOOR;
		
		new map_model;
		cache_get_value_index_int(row, 18, map_model);
		if( map_model != -1 )
		{
			Door[d_id][door_map_icon] = CreateDynamicMapIcon(Door[d_id][door_pos][0], Door[d_id][door_pos][1], Door[d_id][door_pos][2], map_model, 0, Door[d_id][door_vw], Door[d_id][door_int]);
		}
		
		Door[d_id][door_closed] = Door[d_id][door_auto_closing];
	}

	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	if( return_id ) return d_id;
	return rows;
}

forward DeleteInactiveDoor(d_id);
public DeleteInactiveDoor(d_id)
{
	new rows;
	cache_get_row_count(rows);

	if(rows)
	{
		new session_time;
		if(session_time + 30*86400 > gettime())
		{
			new areas_array[20];
			new polygon_price;
			GetDynamicAreasForPoint(Door[d_id][door_pos][0], Door[d_id][door_pos][1],Door[d_id][door_pos][2], areas_array);

			for(new row = 0; row != sizeof(areas_array); row++)
			{
				if(Iter_Contains(Areas, areas_array[row]))
				{
					if(Area[areas_array[row]][area_type] == AREA_TYPE_NORMAL) polygon_price = Area[areas_array[row]][area_price];
				}
			}

			if(polygon_price > 0)
			{
				printf("Drzwi %s (%d) zostaly wystawione na sprzedaz za $%d z powodu braku aktywnosci ownera od 30 dni.", Door[d_id][door_name], Door[d_id][door_uid], polygon_price);
				Door[d_id][door_owner_type] = DOOR_OWNER_TYPE_GLOBAL;
				Door[d_id][door_owner] = 0;
				Door[d_id][door_price] = polygon_price;
				Streamer_SetIntData(STREAMER_TYPE_PICKUP, d_id, E_STREAMER_MODEL_ID, 1273);
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_doors SET door_owner = 0, door_ownertype = %d, door_price = %d WHERE door_uid = %d", DOOR_OWNER_TYPE_GLOBAL, polygon_price, Door[d_id][door_uid]));
			}
			else
			{
				printf("Drzwi %s (%d) powinny zostac wystawione na sprzedaz z powodu braku aktywnosci ownera ale ich strefa jest nie wyceniona.", Door[d_id][door_name], Door[d_id][door_uid]);
			}
		}
	}

	return 1;
}

stock DeleteDoor(d_id, bool:from_mysql = true)
{	
	if( from_mysql ) 
	{
		mysql_tquery(mySQLconnection, sprintf("DELETE FROM `ipb_doors` WHERE `door_uid` = %d", Door[d_id][door_uid]));
		mysql_tquery(mySQLconnection, sprintf("DELETE FROM `ipb_areas` WHERE `area_ownertype` = %d AND `area_owner` = %d", AREA_OWNER_TYPE_DOOR, Door[d_id][door_uid]));
	}
	Iter_Remove(Doors, d_id);
	
	DestroyDynamicPickup(d_id);
	
	if( IsValidDynamicMapIcon(Door[d_id][door_map_icon]) ) DestroyDynamicMapIcon(Door[d_id][door_map_icon]);
	
	for(new z=0; e_doors:z != e_doors; z++)
    {
		Door[d_id][e_doors:z] = 0;
    }
}

forward OnPlayerLoadDoor(playerid, d_id);
public OnPlayerLoadDoor(playerid, d_id)
{
	Code_ExTimer_Begin(OnPlayerLoadDoor);
	if(pInfo[playerid][player_robbery] != -1)
	{
		if(Door[d_id][door_uid] == Robbery[pInfo[playerid][player_robbery]][robbery_place])
		{
			if(!PlayerHasAchievement(playerid, ACHIEV_ROBBER)) AddAchievement(playerid, ACHIEV_ROBBER, 200);
		}
	}

	new rows, lastGameID, lastID, currentID, bool:created, loaded_objects;
	cache_get_row_count(rows);

	if(rows)
	{
		for(new row = 0; row != rows; row++)
		{
			cache_get_value_index_int(row, 0, currentID);

			if(currentID != lastID) created = false;
    		
		    if(!created) 
		    {
		    	new model, vw, owner, owner_type;

				cache_get_value_index_int(row, 6, model);
				cache_get_value_index_int(row, 7, vw);
				cache_get_value_index_int(row, 3, owner);
				cache_get_value_index_int(row, 2, owner_type);
					
				if( owner_type == 0 ) continue;

				new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
				cache_get_value_index_float(row, 8, x);
				cache_get_value_index_float(row, 9, y);
				cache_get_value_index_float(row, 10, z);
				cache_get_value_index_float(row, 11, rx);
				cache_get_value_index_float(row, 12, ry);
				cache_get_value_index_float(row, 13, rz);

		        lastGameID = CreateDynamicObject(model, x, y, z, rx, ry, rz, vw, -1, -1, 200.0);
		        if(!Door[d_id][door_loaded]) Door[d_id][door_loaded] = true;
		        loaded_objects ++;

		        for(new oz=0; e_objects:oz != e_objects; oz++)
				{
					Object[lastGameID][e_objects:oz] = 0;
				}

				new oid = lastGameID;
				new Float:dd;
				cache_get_value_index_float(row, 5, dd);

				if(vw == 94)
				{
					dd *= 2.0;
					Streamer_SetFloatData(STREAMER_TYPE_OBJECT, oid, E_STREAMER_STREAM_DISTANCE, dd+50.0);
					Streamer_SetFloatData(STREAMER_TYPE_OBJECT, oid, E_STREAMER_DRAW_DISTANCE, dd);
				}

				if (dd < 1) dd = 200.0;
				
				new hadfarawaymodel;
				cache_get_value_index_int(row, 23, hadfarawaymodel);

				if(hadfarawaymodel) 
				{
			   		Streamer_SetFloatData(STREAMER_TYPE_OBJECT, oid, E_STREAMER_STREAM_DISTANCE, 1000.0 + dd + 50.0);
					Streamer_SetFloatData(STREAMER_TYPE_OBJECT, oid, E_STREAMER_DRAW_DISTANCE, 1000.0 + dd);
				}
				
				cache_get_value_index_int(row, 0, Object[oid][object_uid]);
				new otype;
				cache_get_value_index_int(row, 1, otype);
				
				Object[oid][object_owner_type] = owner_type;
				Object[oid][object_owner] = owner;
				
				switch( Object[oid][object_owner_type] )
				{
					case OBJECT_OWNER_TYPE_AREA:
					{
						new a_id = GetAreaByUid(owner);
						if( a_id == -1 )
						{
							DeleteObject(oid, false);
							continue;
						}
					}
					
					case OBJECT_OWNER_TYPE_DOOR:
					{
						if(otype != OBJECT_TYPE_ROBBERY)
						{
							new do_id = GetDoorByUid(owner);
							if( do_id == -1 )
							{
								DeleteObject(oid, false);
								continue;
							}
						}
					}
				}

				Streamer_SetIntData(STREAMER_TYPE_OBJECT, oid, E_STREAMER_EXTRA_ID, Object[oid][object_uid]);

				Object[oid][object_vw] = vw;
				Object[oid][object_model] = model;
				Object[oid][object_stream_distance] = 300.0;
				Object[oid][object_type] = otype;
				Object[oid][object_gate_opened] = false;
				cache_get_value_index_int(row, 20, Object[oid][object_gate]);

				cache_get_value_index_float(row, 14, Object[oid][object_gate_pos][0]);
				cache_get_value_index_float(row, 15, Object[oid][object_gate_pos][1]);
				cache_get_value_index_float(row, 16, Object[oid][object_gate_pos][2]);
				cache_get_value_index_float(row, 17, Object[oid][object_gate_pos][3]);
				cache_get_value_index_float(row, 18, Object[oid][object_gate_pos][4]);
				cache_get_value_index_float(row, 19, Object[oid][object_gate_pos][5]);

				Object[oid][object_pos][0] = x;
				Object[oid][object_pos][1] = y;
				Object[oid][object_pos][2] = z;

				Object[oid][object_pos][3] = rx;
				Object[oid][object_pos][4] = ry;
				Object[oid][object_pos][5] = rz;

				cache_get_value_index_int(row, 24, Object[oid][object_textured]);

				Object[oid][object_logs] = 5;

		        created = true;
		       	lastID = currentID;
		    }

		    new trans[100];
			cache_get_value_index(row, 26, trans);

			if(strlen(trans))
			{
	    		new type, data[100];
				if( !sscanf(trans, "p<^>ds[100]", type, data) )
				{
					switch(type)
					{
						case 0:
						{
							new index, color[16], mmodel, txd_name[32], texture_name[32];
							sscanf(data, "p<:>ds[16]ds[32]s[32]", index, color, mmodel, txd_name, texture_name);
							format(color, 16, "0x%s", color);

							if( !strcmp(color, "0x000000") ) SetDynamicObjectMaterial(lastGameID, index, mmodel, txd_name, texture_name, 0);
							else SetDynamicObjectMaterial(lastGameID, index, mmodel, txd_name, texture_name, HexToInt(color));
						}
						
						case 1:
						{
							new index, msize, fsize, bold, fcolor[16], bcolor[16], align, font[32], text[100];
							sscanf(data, "p<:>dddds[16]s[16]ds[32] s[50]", index, msize, fsize, bold, fcolor, bcolor, align, font, text);
							format(fcolor, 16, "0x%s", fcolor);
							
							if( strcmp(bcolor, "000000") != 0 ) format(bcolor, 16, "0x%s", bcolor);
							
							for(new y=0;y<text[y];y++)
							{
								if(text[y] == '|')
								{
									strdel(text, y, y+1);
									strins(text, "\n", y);
								}
							}
							
							strreplace(text, '(', '{');
							strreplace(text, ')', '}');
							
							if( strcmp(bcolor, "000000") != 0 ) SetDynamicObjectMaterialText(lastGameID, index, text, msize, font, fsize, bold, HexToInt(fcolor), HexToInt(bcolor), align);
							else SetDynamicObjectMaterialText(lastGameID, index, text, msize, font, fsize, bold, HexToInt(fcolor), 0, align);
						}
					}
				}
			}
		}
	}

	printf("Wczytano obiekty dla drzwi UID %d [wczytanych: %d] [czas: %d ms]", Door[d_id][door_uid], loaded_objects, cache_get_query_exec_time()+Code_ExTimer_End(OnPlayerLoadDoor));

	RP_PLUS_SetPlayerPos(playerid, Door[d_id][door_spawn_pos][0], Door[d_id][door_spawn_pos][1], Door[d_id][door_spawn_pos][2]);
	SetPlayerFacingAngle(playerid, Door[d_id][door_spawn_pos][3]);
	
	SetCameraBehindPlayer(playerid);
	
	SetPlayerVirtualWorld(playerid, Door[d_id][door_spawn_vw]);
	SetPlayerInterior(playerid, Door[d_id][door_spawn_int]);
	SetPlayerTime(playerid, Door[d_id][door_time], 0);
	SetPlayerWeather(playerid, 0);

	TextDrawHideForPlayer(playerid, Tutorial[playerid]);
	TogglePlayerControllable(playerid, true);
	pInfo[playerid][player_loading_door] = -1;
	Door[d_id][door_loaded] = true;
	return 1;
}

stock OnPlayerEnterDoor(playerid, d_id)
{
	if(pInfo[playerid][player_robbery] != -1)
	{
		if(Door[d_id][door_uid] == Robbery[pInfo[playerid][player_robbery]][robbery_place])
		{
			if(!PlayerHasAchievement(playerid, ACHIEV_ROBBER)) AddAchievement(playerid, ACHIEV_ROBBER, 200);
		}
	}

	FreezePlayer(playerid, 2000);
	RP_PLUS_SetPlayerPos(playerid, Door[d_id][door_spawn_pos][0], Door[d_id][door_spawn_pos][1], Door[d_id][door_spawn_pos][2]);
	SetPlayerFacingAngle(playerid, Door[d_id][door_spawn_pos][3]);
	
	SetCameraBehindPlayer(playerid);
	
	SetPlayerVirtualWorld(playerid, Door[d_id][door_spawn_vw]);
	SetPlayerInterior(playerid, Door[d_id][door_spawn_int]);
	SetPlayerTime(playerid, Door[d_id][door_time], 0);
	SetPlayerWeather(playerid, 0);
	return 1;
}

stock OnPlayerExitDoor(playerid, ds_id)
{
	if( Door[ds_id][door_closed] ) return SendClientMessage(playerid, COLOR_GREY, "Ten budynek jest zamkniêty.");

	FreezePlayer(playerid, 2500);

	RP_PLUS_SetPlayerPos(playerid, Door[ds_id][door_pos][0], Door[ds_id][door_pos][1], Door[ds_id][door_pos][2]);
	SetPlayerFacingAngle(playerid, Door[ds_id][door_pos][3]+180.0);

	SetCameraBehindPlayer(playerid);

	SetPlayerVirtualWorld(playerid, Door[ds_id][door_vw]);
	SetPlayerInterior(playerid, Door[ds_id][door_int]);
	SetPlayerTime(playerid, WorldTime+2, 0);
	SetPlayerWeather(playerid, WorldWeather);

	new slot = GetPlayerDutySlot(playerid);

	if(slot != -1)
	{
		new grid = pInfo[playerid][player_duty_gid];
		if( GroupHasFlag(grid, GROUP_FLAG_DUTY) )
		{
			cmd_g(playerid, sprintf("%d duty", slot+1));
		}
	}
	return 1;
}

stock GetDoorByUid(uid)
{
	foreach(new d_id : Doors)
	{
		if( Door[d_id][door_uid] == uid ) return d_id;
	}
	
	return -1;
}

stock HasPlayerBuilding(playerid)
{
	new count;
	foreach(new d_id : Doors)
	{
		if(Door[d_id][door_owner_type] == DOOR_OWNER_TYPE_PLAYER && Door[d_id][door_owner] == pInfo[playerid][player_id])
		{
			count++;
		}
	}

	return count;
}

stock HasPlayerBuildingInArea(playerid)
{
	new count;
	foreach(new d_id : Doors)
	{
		if(Door[d_id][door_owner_type] == DOOR_OWNER_TYPE_PLAYER && Door[d_id][door_owner] == pInfo[playerid][player_id])
		{
			if(IsPointInDynamicArea(pInfo[playerid][player_area], Door[d_id][door_pos][0], Door[d_id][door_pos][1], Door[d_id][door_pos][2])) count++;
		}
	}

	return count;
}

stock CanPlayerUseDoor(playerid, d_id)
{
	if( HasCrewFlag(playerid, CREW_FLAG_DOORS) ) return 1;
	
	switch( Door[d_id][door_owner_type] )
	{
		case DOOR_OWNER_TYPE_PLAYER:
		{
			if( Door[d_id][door_owner] == pInfo[playerid][player_id] ) return 1;
			if( Door[d_id][door_uid] == pInfo[playerid][player_spawn]) return 1;
		}
		
		case DOOR_OWNER_TYPE_GROUP:
		{
			new gid = GetGroupByUid(Door[d_id][door_owner]);
			
			new slot = GetPlayerGroupSlot(playerid, gid);
			if( slot > -1 ) 
			{
				if( WorkerHasFlag(playerid, slot, WORKER_FLAG_DOORS) ) return 1;
			}
		}
	}
	
	return 0;
}

stock CanPlayerEditDoor(playerid, d_id)
{
	if(HasCrewFlag(playerid, CREW_FLAG_DOORS) ) return 1;
	if(d_id == -1) return 0;
	switch( Door[d_id][door_owner_type] )
	{
		case DOOR_OWNER_TYPE_PLAYER:
		{
			if( Door[d_id][door_owner] == pInfo[playerid][player_id] ) return 1;
		}
		
		case DOOR_OWNER_TYPE_GROUP:
		{
			new gid = GetGroupByUid(Door[d_id][door_owner]);
			
			new slot = GetPlayerGroupSlot(playerid, gid);
			if( slot > -1 ) 
			{
				if( WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return 1;
			}
		}
	}
	return 0;
}

stock GetPlayerDoorEntrance(playerid)
{
	new d_id = -1;

	foreach(new d : Doors)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]) && GetPlayerVirtualWorld(playerid) == Door[d][door_vw])
		{
			d_id = d;
		}
	}

	return d_id;
}

stock CountDoorObjects(d_id)
{
	new count, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT object_uid FROM ipb_objects WHERE object_ownertype = %d AND object_owner = %d", OBJECT_OWNER_TYPE_DOOR, Door[d_id][door_uid]));
	
	new rows;
	cache_get_row_count(rows);
	count = rows;

	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	
	return count;
}

stock CountDoorLabels(d_id)
{
	new count;
	foreach(new lid : Labels)
	{
		if( Label[Text3D:lid][label_owner_type] == LABEL_OWNER_TYPE_DOOR && Label[Text3D:lid][label_owner] == Door[d_id][door_uid] ) count++;
	}
	
	return count;
}

stock ShowPlayerDoorTextdraw(playerid, d_id)
{
	new header[64], all[256];
	if( !HasCrewFlag(playerid, CREW_FLAG_DOORS) )
	{
		if( Door[d_id][door_payment] > 0 && !Door[d_id][door_closed] ) format(header, sizeof(header), "%s (~g~$%d~w~)", Door[d_id][door_name], Door[d_id][door_payment]);
		else if( Door[d_id][door_payment] == 0 ) format(header, sizeof(header), "%s", Door[d_id][door_name]);
	}
	else
	{
		if( Door[d_id][door_payment] > 0 && !Door[d_id][door_closed] ) format(header, sizeof(header), "%s ~y~(%d)~w~ (~g~$%d~w~)", Door[d_id][door_name], d_id, Door[d_id][door_payment]);
		else if( Door[d_id][door_payment] == 0 ) format(header, sizeof(header), "%s (%d)", Door[d_id][door_name], d_id);
	}
	amount_players_in_door[playerid]=0;
	foreach(new p : Player)
	{
		if( GetPlayerVirtualWorld(p) == Door[d_id][door_spawn_vw] && Door[d_id][door_spawn_vw] != 0)
		{
			amount_players_in_door[playerid]++;
		}
	}
	if( Door[d_id][door_closed] ) format(all, sizeof(all), "%s~n~~n~~w~DRZWI~r~ ZAMKNIETE~n~_", header);
	else format(all, sizeof(all), "%s~n~~n~~y~Aby wejsc do srodka, nacisnij jednoczesnie ~n~~w~[LALT + SPACJA]~n~~n~~w~%d osob w srodku", header, amount_players_in_door[playerid]);
	
	pInfo[playerid][player_door_text] = 5;
	TextDrawSetString(DoorInfo[playerid], all);
	TextDrawShowForPlayer(playerid, DoorInfo[playerid]);
}

stock HidePlayerDoorTextdraw(playerid)
{
	TextDrawHideForPlayer(playerid, DoorInfo[playerid]);
	//pInfo[playerid][player_pickup] = -1;
}

stock DoorsDefaultInteriorsList(playerid, d_id, page=1)
{
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, "SELECT COUNT(*) as count FROM `ipb_default_interiors`");
	cache_get_row_count(rows);

	new count;
	cache_get_value_index_int(0, 0, count);
	new all_rows = count;
	
	new header[64], Float:pp = all_rows / 20;
	format(header, sizeof(header), "Zmiana wnêtrza drzwi (%d/%d)", page, floatround(pp, floatround_ceil));
	
	pInfo[playerid][player_dialog_tmp1] = page;
	
	DynamicGui_Init(playerid);
	DynamicGui_SetDialogValue(playerid, d_id);
	
	new str[800];
	
	if( page > 1 )
	{
		format(str, sizeof(str), "%s"HEX_COLOR_SAMP"<<< Poprzednia strona\n  \n", str);
		DynamicGui_AddRow(playerid, DG_DRZWI_CHANGE_INTERIOR_PREV);
		
		DynamicGui_AddBlankRow(playerid);
	}
	
	if( page == 1 )
	{
		format(str, sizeof(str), "%s0.\tBrak (w³asne obiekty)\n", str);
		DynamicGui_AddRow(playerid, DG_DRZWI_CHANGE_INTERIOR_ROW, -1);
	}
	
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT name, id FROM `ipb_default_interiors` LIMIT %d, 20", (page-1)*20));
	cache_get_row_count(rows);
	
	new tmp_str[60], tmpid;
	
	for(new row = 0; row != rows; row++)
	{
		cache_get_value_index(row, 0, tmp_str);
		cache_get_value_index_int(row, 1, tmpid);
		
		format(str, sizeof(str), "%s%d.\t%s\n", str, (row+1)+((page-1)*20), tmp_str);
		DynamicGui_AddRow(playerid, DG_DRZWI_CHANGE_INTERIOR_ROW, tmpid);
	}
	
	if( all_rows > (page*20) )
	{
		format(str, sizeof(str), "%s"HEX_COLOR_SAMP"\t\t\t\t\t\t\t   Nastêpna strona >>>\n", str);
		DynamicGui_AddRow(playerid, DG_DRZWI_CHANGE_INTERIOR_NEXT);
	}
	
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	ShowPlayerDialog(playerid, DIALOG_ADRZWI_CHANGE_INTERIOR, DIALOG_STYLE_LIST, header, str, "Wybierz", "Wróæ");
	
	return 1;
}
