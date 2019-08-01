stock LoadLabel(limit[] = "", bool:return_id = false)
{
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM `ipb_3dlabels` %s", limit));  
	cache_get_row_count(rows);
	
	new Text3D:label_id, text[200], st[20];
	
	for(new row = 0; row != rows; row++)
	{
		cache_get_value_index(row, 3, text);
		
		cache_get_value_index(row, 4, st);
		format(st, sizeof(st), "0x%sFF", st);
		
		new color = HexToInt(st);

		new Float:x, Float:y, Float:z, Float:draw, vw, int;

		cache_get_value_index_float(row, 5, x);
		cache_get_value_index_float(row, 6, y);
		cache_get_value_index_float(row, 7, z);
		cache_get_value_index_float(row, 8, draw);
		cache_get_value_index_int(row, 9, vw);
		cache_get_value_index_int(row, 10, int);
		
		label_id = CreateDynamic3DTextLabel(LabelFormatText(text), color, x, y, z, draw, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, int);
		
		Label[label_id][label_color] = color;

		Label[label_id][label_pos][0] = x;
		Label[label_id][label_pos][1] = y;
		Label[label_id][label_pos][2] = z;
		Label[label_id][label_vw] = vw;
		Label[label_id][label_draw] = draw;
		
		cache_get_value_index_int(row, 0, Label[label_id][label_uid]);
		cache_get_value_index_int(row, 1, Label[label_id][label_owner]);
		cache_get_value_index_int(row, 2, Label[label_id][label_owner_type]);
		
		Iter_Add(Labels, _:label_id);
		
		foreach(new p : Player)
		{
			if( Label[label_id][label_vw]  != GetPlayerVirtualWorld(p) ) continue;
			
			Streamer_UpdateEx(p, Label[label_id][label_pos][0], Label[label_id][label_pos][1], Label[label_id][label_pos][2], Label[label_id][label_vw], -1);
		}
	}

	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	if( return_id ) return _:label_id;
	return rows;
}

stock DeleteLabel(l_id, bool:from_database = true)
{
	if( from_database ) mysql_tquery(mySQLconnection, sprintf("DELETE FROM `ipb_3dlabels` WHERE `label_uid` = %d", Label[Text3D:l_id][label_uid]));
		
	DestroyDynamic3DTextLabel(Text3D:l_id);
	
	Iter_Remove(Labels, l_id);
	
	for(new z=0; e_labels:z != e_labels; z++)
	{
		Label[Text3D:l_id][e_labels:z] = 0;
	}
	return 1;
}

stock GetLabelDataForPlayer(playerid, &owner, &owner_type)
{
	if( GetPlayerVirtualWorld(playerid) == 0 )
	{
		if( HasCrewFlag(playerid, CREW_FLAG_EDITOR) )
		{
			owner = 0;
			owner_type = LABEL_OWNER_TYPE_GLOBAL;
			
			return 1;
		}
		
		new a_id = GetPlayerArea(playerid, AREA_TYPE_NORMAL);
		if( a_id != -1 )
		{
			if( CanPlayerEditArea(playerid, a_id) )
			{
				owner = Area[a_id][area_uid];
				owner_type = LABEL_OWNER_TYPE_AREA;
			}
		}
	}
	else
	{
		new d_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
		
		if( d_id == -1 ) return 1;
		if( Door[d_id][door_type] != DOOR_TYPE_NORMAL ) return 1;
		
		if( HasCrewFlag(playerid, CREW_FLAG_EDITOR) )
		{
			owner = Door[d_id][door_uid];
			owner_type = LABEL_OWNER_TYPE_DOOR;
			
			return 1;
		}
		
		if( CanPlayerEditDoor(playerid, d_id) )
		{
			owner = Door[d_id][door_uid];
			owner_type = LABEL_OWNER_TYPE_DOOR;
			
			return 1;
		}
	}
	return 1;
}

stock _:LabelFormatText(text[], length = sizeof text)
{
	new tmpd[200];
	strcopy(tmpd, text, length);
	
	for(new y=0;y<tmpd[y];y++)
	{
		if(tmpd[y] == '|')
		{
			strdel(tmpd, y, y+1);
			strins(tmpd, "\n", y);
		}
	}
					
	strreplace(tmpd, '(', '{');
	strreplace(tmpd, ')', '}');
	return tmpd;
}

stock CanPlayerEditLabel(playerid, l_id)
{
	if( HasCrewFlag(playerid, CREW_FLAG_EDITOR) ) return 1;
	
	switch( Label[Text3D:l_id][label_owner_type] )
	{	
		case LABEL_OWNER_TYPE_DOOR:
		{
			if( CanPlayerEditDoor(playerid, GetDoorByUid(Label[Text3D:l_id][label_owner])) ) return 1;
		}
		
		case LABEL_OWNER_TYPE_AREA:
		{
			if( CanPlayerEditArea(playerid, GetAreaByUid(Label[Text3D:l_id][label_owner])) ) return 1;
		}
	}
	return 0;
}

stock Float:GetPlayerDistanceTo3DTextLabel(playerid, Text3D:label_id)
{
	if( !IsValidDynamic3DTextLabel(label_id) ) return 1000.0;
	
	return GetPlayerDistanceFromPoint(playerid, Label[label_id][label_pos][0], Label[label_id][label_pos][1], Label[label_id][label_pos][2]);
}

stock GetClosestLabel(playerid)
{
	new label_id,
    	Float:prevdist = 5.0, LabelID = INVALID_3DTEXT_ID, Float:PosX, Float:PosY, Float:PosZ, Float:dist;

    GetPlayerPos(playerid, PosX, PosY, PosZ);

    for (new player_text = 0; player_text <= MAX_VISIBLE_LABELS; player_text++)
 	{
    	if(player_text != INVALID_3DTEXT_ID)
     	{
			label_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_3D_TEXT_LABEL, player_text);

			if(Label[Text3D:label_id][label_uid])
			{
				//if(Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_ATTACHED_PLAYER) == INVALID_PLAYER_ID && Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_ATTACHED_VEHICLE) == INVALID_VEHICLE_ID)
				//{
					if( !CanPlayerEditLabel(playerid, label_id) ) continue;
					Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_3D_TEXT_LABEL, label_id, dist);
					if((dist < prevdist))
					{
		    			prevdist = dist;
		 				LabelID = label_id;
					}
	         	//}
	        }
    	}
	}
	return LabelID;
}
