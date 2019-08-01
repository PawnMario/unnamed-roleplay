stock LoadArea(limit[] = "", bool:return_id = false)
{
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM `ipb_areas` %s", limit));
	cache_get_row_count(rows);
	
	new area_id;
	for(new row = 0; row != rows; row++)
	{
		area_id = -1;
		new shape;
		cache_get_value_index_int(row, 1, shape);
		
		new Float:point1[3], Float:point2[3];
		
		new str[100];
		cache_get_value_index(row, 8, str);
		sscanf(str, "p<|>a<f>[3]", point1);
		
		new str2[100];
		cache_get_value_index(row, 9, str2);
		sscanf(str2, "p<|>a<f>[3]", point2);

		new vw;
		cache_get_value_index_int(row, 6, vw);
		
		if( shape == AREA_SHAPE_SQUARE )
		{
			// Tworzymy prostokatna strefe
			new Float:pointes[8];
			pointes[0] = point1[0];
			pointes[1] = point1[1];
			pointes[2] = point1[0];
			pointes[3] = point2[1];
			pointes[4] = point2[0];
			pointes[5] = point2[1];
			pointes[6] = point2[0];
			pointes[7] = point1[1];
			
			area_id = CreateDynamicPolygon(pointes, -FLOAT_INFINITY, FLOAT_INFINITY, 8, vw);
			
			cache_get_value_index_int(row, 5, Area[area_id][area_objects_limit]);
		}
		else if( shape == AREA_SHAPE_CIRCLE )
		{
			new Float:tmp_float;
			cache_get_value_index_float(row, 7, tmp_float);
			// Tworzymy okragla strefe
			area_id = CreateDynamicSphere(point1[0], point1[1], point1[2], tmp_float, vw);
		}
		
		cache_get_value_index_int(row, 0, Area[area_id][area_uid]);
		cache_get_value_index_int(row, 2, Area[area_id][area_type]);
		cache_get_value_index_int(row, 3, Area[area_id][area_owner_type]);
		cache_get_value_index_int(row, 4, Area[area_id][area_owner]);
		cache_get_value_index_int(row, 10, Area[area_id][area_flags]);
		cache_get_value_index(row, 11, Area[area_id][area_audio], 100);
		cache_get_value_index_int(row, 12, Area[area_id][area_price]);
		//cache_get_value_index_int(row, 13, Area[area_id][area_meters]);
		cache_get_value_index_int(row, 14, Area[area_id][area_visible]);
		cache_get_value_index_int(row, 15, Area[area_id][area_attacked]);

		new gid = GetGroupByUid(Area[area_id][area_owner]);

		if(gid != -1)
		{
			if(AreaHasFlag(area_id, AREA_FLAG_BONUS))
			{
				Group[gid][group_bonus] = 1;
			}

			Area[area_id][area_color] = GetGroupColor(gid);

			if(Group[gid][group_type] == GROUP_TYPE_GANG) Area[area_id][area_gzone] = GangZoneCreate(Min(point1[0], point2[0]), Min(point1[1], point2[1]), Max(point1[0], point2[0]), Max(point1[1], point2[1]));
		}
		
		Iter_Add(Areas, area_id);
	}

	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	if( return_id ) return area_id;
	return rows;
}

stock DeleteArea(a_id, bool:from_database = true)
{
	if( from_database ) mysql_tquery(mySQLconnection, sprintf("DELETE FROM `ipb_areas` WHERE `area_uid` = %d", Area[a_id][area_uid]));

	DestroyDynamicArea(a_id);
		
	Iter_Remove(Areas, a_id);
	
	for(new z=0; e_areas:z != e_areas; z++)
    {
		Area[a_id][e_areas:z] = 0;
    }
}

stock AreaCreator(playerid)
{
	if( pInfo[playerid][player_carea_type] == AREA_SHAPE_SQUARE )
	{
		if( pInfo[playerid][player_carea_point2][0] == 0.0 && pInfo[playerid][player_carea_point2][1] == 0.0 && pInfo[playerid][player_carea_point2][2] == 0.0 ) return ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", "Musisz wyznaczyæ dwa punkty tworz¹ce przek¹tn¹.", "OK", "");	
	
		new str[400], a_type, a_ownertype, a_owner;
		
		a_type = AREA_TYPE_NORMAL;
		a_ownertype = AREA_OWNER_TYPE_GLOBAL;
		a_owner = 0;
		

		strcat(str, "INSERT INTO `ipb_areas` (area_uid, area_shape, area_type, area_ownertype, area_owner, area_objects, area_vw, area_size, area_point1, area_point2) ");
		strcat(str, sprintf("VALUES(null, %d, %d, %d, %d, 0, %d, 0.0, '%f|%f|%f', '%f|%f|%f')", AREA_SHAPE_SQUARE, a_type, a_ownertype, a_owner, GetPlayerVirtualWorld(playerid), pInfo[playerid][player_carea_point1][0], pInfo[playerid][player_carea_point1][1], pInfo[playerid][player_carea_point1][2], pInfo[playerid][player_carea_point2][0], pInfo[playerid][player_carea_point2][1], pInfo[playerid][player_carea_point2][2]+1));
		mysql_query(mySQLconnection, str);
		
		new uid = cache_insert_id();
		new a_id = LoadArea(sprintf("WHERE `area_uid` = %d", uid), true);
		
		pInfo[playerid][player_carea_point1][0] = 0.0;
		pInfo[playerid][player_carea_point1][1] = 0.0;
		pInfo[playerid][player_carea_point1][2] = 0.0;
		
		pInfo[playerid][player_carea_point2][0] = 0.0;
		pInfo[playerid][player_carea_point2][1] = 0.0;
		pInfo[playerid][player_carea_point2][2] = 0.0;
		
		if( IsValidDynamic3DTextLabel(pInfo[playerid][player_carea_label][0]) ) DestroyDynamic3DTextLabel(pInfo[playerid][player_carea_label][0]);
		if( IsValidDynamic3DTextLabel(pInfo[playerid][player_carea_label][1]) ) DestroyDynamic3DTextLabel(pInfo[playerid][player_carea_label][1]);
		
		PlayerGangZoneDestroy(playerid, pInfo[playerid][player_carea_zone]);
		
		pInfo[playerid][player_creating_area] = false;
		SendPlayerInformation(playerid, "", 0);
		
		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", sprintf("Pomyœlnie stworzy³eœ prostok¹tn¹ strefê [UID: %d, ID: %d].", uid, a_id), "OK", "");
		
	}
	else if( pInfo[playerid][player_carea_type] == AREA_SHAPE_CIRCLE )
	{
		if( pInfo[playerid][player_carea_point1][0] == 0.0 && pInfo[playerid][player_carea_point1][1] == 0.0 && pInfo[playerid][player_carea_point1][2] == 0.0 ) return ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", "Aby stworzyæ sferyczn¹ strefê musisz wyznaczyæ punkt œrodka sfery.", "OK", "");	
	
		new str[400];
		strcat(str, "INSERT INTO `ipb_areas` (area_uid, area_shape, area_type, area_ownertype, area_owner, area_objects, area_vw, area_size, area_point1, area_point2) ");
		strcat(str, sprintf("VALUES(null, %d, %d, %d, 0, 0, %d, %f, '%f|%f|%f', '')", AREA_SHAPE_CIRCLE, AREA_TYPE_NORMAL, AREA_OWNER_TYPE_GLOBAL, GetPlayerVirtualWorld(playerid), pInfo[playerid][player_carea_size], pInfo[playerid][player_carea_point1][0], pInfo[playerid][player_carea_point1][1], pInfo[playerid][player_carea_point1][2]));
		mysql_query(mySQLconnection, str);
	
		new uid = cache_insert_id();
		new a_id = LoadArea(sprintf("WHERE `area_uid` = %d", uid), true);
		
		pInfo[playerid][player_carea_point1][0] = 0.0;
		pInfo[playerid][player_carea_point1][1] = 0.0;
		pInfo[playerid][player_carea_point1][2] = 0.0;
		
		pInfo[playerid][player_carea_point2][0] = 0.0;
		pInfo[playerid][player_carea_point2][1] = 0.0;
		pInfo[playerid][player_carea_point2][2] = 0.0;
		
		if( IsValidDynamic3DTextLabel(pInfo[playerid][player_carea_label][0]) ) DestroyDynamic3DTextLabel(pInfo[playerid][player_carea_label][0]);
		if( IsValidDynamic3DTextLabel(pInfo[playerid][player_carea_label][1]) ) DestroyDynamic3DTextLabel(pInfo[playerid][player_carea_label][1]);
		
		PlayerGangZoneDestroy(playerid, pInfo[playerid][player_carea_zone]);
		
		pInfo[playerid][player_creating_area] = false;
		SendPlayerInformation(playerid, "", 0);
		
		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", sprintf("Pomyœlnie stworzy³eœ sferyczna strefê [UID: %d, ID: %d].", uid, a_id), "OK", "");
	}
	return 1;
}

stock GetPlayerArea(playerid, type, owner_type = -1)
{
	foreach(new a_id : Areas)
	{
		if( Area[a_id][area_type] == type && IsPlayerInDynamicArea(playerid, a_id) )
		{
			if( owner_type == -1 ) return a_id;
			else if( Area[a_id][area_owner_type] == owner_type ) return a_id;
		}
	}
	return -1;
}

stock GetAreaByUid(a_uid)
{
	foreach(new a_id : Areas)
	{
		if( Area[a_id][area_uid] == a_uid ) return a_id;
	}
	
	return -1;
}

stock CountAreaObjects(playerid, a_id)
{
	new count;
	if(IsPlayerInDynamicArea(playerid, a_id))
	{
		new object_id;
    
	 	for (new player_object = 0; player_object <= MAX_VISIBLE_OBJECTS; player_object++)
	 	{
	    	if(IsValidPlayerObject(playerid, player_object))
	     	{
				object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);
				if(Object[object_id][object_owner_type] == OBJECT_OWNER_TYPE_AREA && Object[object_id][object_owner] == Area[a_id][area_uid]) count++;
	    	}
		}
	}
	
	return count;
}

stock CountAreaLabels(a_id)
{
	new count;
	foreach(new lid : Labels)
	{
		if( Label[Text3D:lid][label_owner_type] == LABEL_OWNER_TYPE_AREA && Label[Text3D:lid][label_owner] == Area[a_id][area_uid] ) count++;
	}
	
	return count;
}

stock CanPlayerEditArea(playerid, a_id)
{
	if( HasCrewFlag(playerid, CREW_FLAG_AREAS) ) return 1;
	
	if( Area[a_id][area_owner_type] == AREA_OWNER_TYPE_GROUP)
	{
		new gid = pInfo[playerid][player_duty_gid];
		if(gid == -1) return 0;

		new slot = GetPlayerDutySlot(playerid);
		if(slot == -1) return 0;
		if( Area[a_id][area_owner] == Group[gid][group_uid] && WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return 1;
	}
	return 0;
}

stock ShowAreaFlags(playerid, a_id)
{
	if(Area[a_id][area_flags] == 0) return 1;
	new flags_list[256];
	new last_line[4];
	new destZone[MAX_ZONE_NAME];
	GetPlayer2DZone(playerid, destZone, MAX_ZONE_NAME);

	format(flags_list, sizeof(flags_list), "Lista flag strefy %d (~y~%s~w~):~n~~n~", Area[a_id][area_uid], destZone);

	if( AreaHasFlag(a_id, AREA_FLAG_CORNER) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~zbyt narkotykow~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_BMX) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~bmx~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_MONITORING) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~monitoring~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_DRIVE) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~drive-thru~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_PLANT) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~sadzenie roslin~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_PARKING) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~ograniczony parking~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_OFFER) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~oferowanie produktow~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_SERWIS) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~serwis pojazdow~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_WORK) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~praca drwala~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_WORK_FORKLIFT) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~praca operatora wozkow~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_WORK_FISH) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~praca rybaka~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_BONUS) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~bonus handlowy~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_OCEAN_DOCK) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~przemyty kontenerowe~n~", flags_list);
	}
	if( AreaHasFlag(a_id, AREA_FLAG_DOCK) )
	{
		format(flags_list, sizeof(flags_list), "%s~y~~>~~w~przemyty motorowka~n~", flags_list);
	}
	format(last_line, sizeof(last_line), "");
	format(flags_list, sizeof(flags_list), "%s %s", flags_list, last_line);
	TextDrawSetString(Tutorial[playerid], flags_list);
	TextDrawShowForPlayer(playerid, Tutorial[playerid]);
	pInfo[playerid][player_info_td_id] = 10;
	return 1;
}

stock PlayerGangZoneCreate(playerid, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
	new idx;
	for (new i = 0; i < MAX_PLAYER_GZ; ++i)
	{
		if(!PlayerGangZoneData[playerid][i][player_GZ_Used]) 
		{
			idx = i;
			break;
		}
	}

	if(idx > MAX_PLAYER_GZ-1) return -1;

	PlayerGangZoneData[playerid][idx][player_GZ_MinX]	= minx;
	PlayerGangZoneData[playerid][idx][player_GZ_MinY]	= miny;
	PlayerGangZoneData[playerid][idx][player_GZ_MaxX]	= maxx;
	PlayerGangZoneData[playerid][idx][player_GZ_MaxY]	= maxy;
	PlayerGangZoneData[playerid][idx][player_GZ_Color]	= PLAYER_GZ_DEFAULT_COLOR;
	PlayerGangZoneData[playerid][idx][player_GZ_Used]	= true;
	PlayerGangZoneData[playerid][idx][player_GZ_Shown]	= false;

	return idx;
}

stock PlayerGangZoneShow(playerid, gangzoneid, color = PLAYER_GZ_DEFAULT_COLOR)
{
	if(!PlayerGangZoneData[playerid][gangzoneid][player_GZ_Used] || gangzoneid > MAX_PLAYER_GZ-1 || gangzoneid < 0) return 0;

	PlayerGangZoneData[playerid][gangzoneid][player_GZ_Color] = color;
	PlayerGangZoneData[playerid][gangzoneid][player_GZ_Shown] = true;
	new abgr_color = (((color << 16) | color & 0xFF00) << 8) | (((color >>> 16) | color & 0xFF0000) >>> 8);

	new BitStream:gz_bs = BS_New();
		
	BS_WriteValue(
		gz_bs,
		PR_UINT16, 1023 - gangzoneid,
		PR_FLOAT, PlayerGangZoneData[playerid][gangzoneid][player_GZ_MinX],
		PR_FLOAT, PlayerGangZoneData[playerid][gangzoneid][player_GZ_MinY],
		PR_FLOAT, PlayerGangZoneData[playerid][gangzoneid][player_GZ_MaxX],
		PR_FLOAT, PlayerGangZoneData[playerid][gangzoneid][player_GZ_MaxY],
		PR_UINT32, abgr_color
	);
		
	BS_RPC(gz_bs, playerid, 0x6C);
	BS_Delete(gz_bs);
	return 1;
}

stock PlayerGangZoneFlash(playerid, gangzoneid, color = PLAYER_GZ_DEFAULT_COLOR)
{
	if(!PlayerGangZoneData[playerid][gangzoneid][player_GZ_Used] || gangzoneid > MAX_PLAYER_GZ-1 || gangzoneid < 0) return 0;

	PlayerGangZoneData[playerid][gangzoneid][player_GZ_Color] = color;
	PlayerGangZoneData[playerid][gangzoneid][player_GZ_Shown] = true;
	new abgr_color = (((color << 16) | color & 0xFF00) << 8) | (((color >>> 16) | color & 0xFF0000) >>> 8);

	new BitStream:gz_bs = BS_New();
	new abgr_color = (((color << 16) | color & 0xFF00) << 8) | (((color >>> 16) | color & 0xFF0000) >>> 8);
	BS_WriteValue(
	        gz_bs,
	        PR_UINT16, 1023 - gangzoneid,
	        PR_UINT32, abgr_color
	    )

	BS_RPC(gz_bs, playerid, 0x79);
	BS_Delete(gz_bs);
	return 1;
}

stock PlayerGangZoneStopFlash(playerid, gangzoneid)
{
	if(!PlayerGangZoneData[playerid][gangzoneid][player_GZ_Used] || 
		!PlayerGangZoneData[playerid][gangzoneid][player_GZ_Shown]) return 0;

	PlayerGangZoneData[playerid][gangzoneid][player_GZ_Shown] = false;
	new BitStream:gz_bs = BS_New();
		
	BS_WriteValue(
		gz_bs,
		PR_UINT16, 1023 - gangzoneid
	);
		
	BS_RPC(gz_bs, playerid, 0x55);
	BS_Delete(gz_bs);
	return 1;
}

stock PlayerGangZoneHide(playerid, gangzoneid)
{
	if(!PlayerGangZoneData[playerid][gangzoneid][player_GZ_Used] || 
		!PlayerGangZoneData[playerid][gangzoneid][player_GZ_Shown]) return 0;

	PlayerGangZoneData[playerid][gangzoneid][player_GZ_Shown] = false;
	new BitStream:gz_bs = BS_New();
		
	BS_WriteValue(
		gz_bs,
		PR_UINT16, 1023 - gangzoneid
	);
		
	BS_RPC(gz_bs, playerid, 0x78);
	BS_Delete(gz_bs);
	return 1;
}

stock PlayerGangZoneDestroy(playerid, gangzoneid)
{
	if(!PlayerGangZoneData[playerid][gangzoneid][player_GZ_Used] || gangzoneid > MAX_PLAYER_GZ-1 || gangzoneid < 0) return 0;
	if(PlayerGangZoneData[playerid][gangzoneid][player_GZ_Shown])
		PlayerGangZoneHide(playerid, gangzoneid);
	PlayerGangZoneData[playerid][gangzoneid][player_GZ_Used]	= false;
	PlayerGangZoneData[playerid][gangzoneid][player_GZ_MinX]	= 0.0;
	PlayerGangZoneData[playerid][gangzoneid][player_GZ_MinY]	= 0.0;
	PlayerGangZoneData[playerid][gangzoneid][player_GZ_MaxX]	= 0.0;
	PlayerGangZoneData[playerid][gangzoneid][player_GZ_MaxY]	= 0.0;
	PlayerGangZoneData[playerid][gangzoneid][player_GZ_Color]	= 0;
	return 1;
}