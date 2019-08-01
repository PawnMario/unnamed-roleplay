stock GetClosestObjectType(playerid, object_mod)
{
	new object_id,
    	Float:prevdist = 5.0, OID = INVALID_STREAMER_ID, Float:PosX, Float:PosY, Float:PosZ, Float:dist;
    
    if(pInfo[playerid][player_robbery] != -1) prevdist = 2.0; 
    if(pInfo[playerid][player_working] == WORK_TYPE_FORKLIFT && object_mod == OBJECT_FORKLIFT_BOX) prevdist = 2.0; 
	GetPlayerPos(playerid, PosX, PosY, PosZ);
 	for (new player_object = 0; player_object <= MAX_VISIBLE_OBJECTS; player_object++)
 	{
    	if(IsValidPlayerObject(playerid, player_object))
     	{
			object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);

        	if(GetObjectModel(object_id) == object_mod)
       		{
    			Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, object_id, dist);
    			if((dist < prevdist))
    			{
        			prevdist = dist;
     				OID = object_id;
    			}
         	}
    	}
	}
	return OID;
}

stock GetClosestCustomModel(playerid, object_mod)
{
	new object_id,
    	Float:prevdist = 50.0, OID = INVALID_STREAMER_ID, Float:PosX, Float:PosY, Float:PosZ, Float:dist;
     
	GetPlayerPos(playerid, PosX, PosY, PosZ);
 	for (new player_object = 0; player_object <= MAX_VISIBLE_OBJECTS; player_object++)
 	{
    	if(IsValidPlayerObject(playerid, player_object))
     	{
			object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);

        	if(GetObjectModel(object_id) == object_mod)
       		{
    			Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, object_id, dist);
    			if((dist < prevdist))
    			{
        			prevdist = dist;
     				OID = object_id;
    			}
         	}
    	}
	}
	return OID;
}

stock SelectCustomObject(playerid)
{
	new object_id,
    	Float:prevdist = 30.0, OID = INVALID_STREAMER_ID, Float:PosX, Float:PosY, Float:PosZ, Float:dist;
     
	GetPlayerPos(playerid, PosX, PosY, PosZ);
 	for (new player_object = 0; player_object <= MAX_VISIBLE_OBJECTS; player_object++)
 	{
    	if(IsValidPlayerObject(playerid, player_object))
     	{
			object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);

			if(CanPlayerEditObject(playerid, object_id) && Object[object_id][object_is_edited] == false)
			{
				Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, object_id, dist);
				if((dist < prevdist))
				{
	    			prevdist = dist;
	 				OID = object_id;
				}
			}
    	}
	}
	return OID;
}

stock GetClosestGate(playerid)
{
	new object_id,
    	Float:prevdist = 5.0, OID = INVALID_STREAMER_ID, Float:PosX, Float:PosY, Float:PosZ, Float:dist;
     
	GetPlayerPos(playerid, PosX, PosY, PosZ);
 	for (new player_object = 0; player_object <= MAX_VISIBLE_OBJECTS; player_object++)
 	{
    	if(IsValidPlayerObject(playerid, player_object))
     	{
			object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);

        	if(Object[object_id][object_gate] == 1)
       		{
    			Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, object_id, dist);
    			if((dist < prevdist))
    			{
        			prevdist = dist;
     				OID = object_id;
    			}
         	}
    	}
	}
	return OID;
}

stock GetClosestBusStop(playerid)
{
	new object_id,
    	Float:prevdist = 200.0, OID = INVALID_STREAMER_ID, Float:PosX, Float:PosY, Float:PosZ, Float:dist;
     
	GetPlayerPos(playerid, PosX, PosY, PosZ);
 	for (new player_object = 0; player_object <= MAX_VISIBLE_OBJECTS; player_object++)
 	{
    	if(IsValidPlayerObject(playerid, player_object))
     	{
			object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);

        	if(GetObjectModel(object_id) == OBJECT_BUSSTOP)
       		{
    			Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, object_id, dist);
    			if((dist < prevdist))
    			{
        			prevdist = dist;
     				OID = object_id;
    			}
         	}
    	}
	}
	return OID;
}

stock GetItemObject(playerid, itemuid)
{
	new object_id,
    	Float:prevdist = 5.0, OID = INVALID_STREAMER_ID, Float:PosX, Float:PosY, Float:PosZ, Float:dist;
     
	GetPlayerPos(playerid, PosX, PosY, PosZ);
 	for (new player_object = 0; player_object <= MAX_VISIBLE_OBJECTS; player_object++)
 	{
    	if(IsValidPlayerObject(playerid, player_object))
     	{
			object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);

        	if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID) == itemuid*-1)
       		{
    			Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, object_id, dist);
    			if((dist < prevdist))
    			{
        			prevdist = dist;
     				OID = object_id;
    			}
         	}
    	}
	}
	return OID;
}

stock GetClosestZeroGate(playerid)
{
	new object_id,
    	Float:prevdist = 15.0, OID = INVALID_STREAMER_ID, Float:PosX, Float:PosY, Float:PosZ, Float:dist;
     
	GetPlayerPos(playerid, PosX, PosY, PosZ);
 	for (new player_object = 0; player_object <= MAX_VISIBLE_OBJECTS; player_object++)
 	{
    	if(IsValidPlayerObject(playerid, player_object))
     	{
			object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);

        	if(Object[object_id][object_gate] == 1)
       		{
    			Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, object_id, dist);
    			if((dist < prevdist))
    			{
        			prevdist = dist;
     				OID = object_id;
    			}
         	}
    	}
	}
	return OID;
}

stock LoadObject(limit[] = "", bool:return_id = false)
{
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM ipb_objects %s", limit));  
	cache_get_row_count(rows);

	new oid;
	
	for(new row = 0; row != rows; row++)
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
			
		oid = CreateDynamicObject(model, x, y, z, rx, ry, rz, vw, -1, -1, 200.0);
		
		for(new oz=0; e_objects:oz != e_objects; oz++)
		{
			Object[oid][e_objects:oz] = 0;
		}

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
					new d_id = GetDoorByUid(owner);
					if( d_id == -1 )
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
		cache_get_value_index_int(row, 22, Object[oid][object_date]);

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

		if(Object[oid][object_uid] == 18401) liberty_ship = oid;
		if(Object[oid][object_uid] == 18579) asian_ship = oid;
		if(Object[oid][object_uid] == 18651) space_ship = oid;

		switch(Object[oid][object_type])
		{
			case OBJECT_TYPE_TRASH:
			{
				Object[oid][object_label] = CreateDynamic3DTextLabel("Œmietnik\n{FFFFFF}\nKlawisz Y by zebraæ", 0x2ECC71FF, Object[oid][object_pos][0], Object[oid][object_pos][1], Object[oid][object_pos][2]+1.25, 15.0, .testlos = 1);
			}
			case OBJECT_TYPE_PLANT:
			{
				new temp, ghour, gminute, gday, gmonth;
				TimestampToDate(Object[oid][object_date], temp, gmonth, gday, ghour, gminute, temp, 1);
				switch(Object[oid][object_model])
				{
					case OBJECT_WEED:
					{
						Object[oid][object_label] = CreateDynamic3DTextLabel(sprintf("Marihuana\n{FFFFFF}\nTermin zbiorów: %02d.%02d o %02d:%02d\nKlawisz Y by zebraæ", gday, gmonth, ghour, gminute), 0x2ECC71FF, Object[oid][object_pos][0], Object[oid][object_pos][1], Object[oid][object_pos][2]+1.25, 15.0, .testlos = 1);
					}
					case OBJECT_TOBACCO:
					{
						Object[oid][object_label] = CreateDynamic3DTextLabel(sprintf("Tytoñ\n{FFFFFF}\nTermin zbiorów: %02d.%02d o %02d:%02d\nKlawisz Y by zebraæ", gday, gmonth, ghour, gminute), 0x2ECC71FF, Object[oid][object_pos][0], Object[oid][object_pos][1], Object[oid][object_pos][2]+1.25, 15.0, .testlos = 1);
					}
					case OBJECT_POTATOS:
					{
						Object[oid][object_label] = CreateDynamic3DTextLabel(sprintf("Ziemniaki\n{FFFFFF}\nTermin zbiorów: %02d.%02d o %02d:%02d\nKlawisz Y by zebraæ", gday, gmonth, ghour, gminute), 0x2ECC71FF, Object[oid][object_pos][0], Object[oid][object_pos][1], Object[oid][object_pos][2]+1.25, 15.0, .testlos = 1);
					}
					case OBJECT_OPIUM:
					{
						Object[oid][object_label] = CreateDynamic3DTextLabel(sprintf("Opium\n{FFFFFF}\nTermin zbiorów: %02d.%02d o %02d:%02d\nKlawisz Y by zebraæ", gday, gmonth, ghour, gminute), 0x2ECC71FF,  Object[oid][object_pos][0], Object[oid][object_pos][1], Object[oid][object_pos][2]+1.25, 15.0, .testlos = 1);
					}
					case OBJECT_VEGGIES:
					{
						Object[oid][object_label] = CreateDynamic3DTextLabel(sprintf("Warzywa\n{FFFFFF}\nTermin zbiorów: %02d.%02d o %02d:%02d\nKlawisz Y by zebraæ", gday, gmonth, ghour, gminute), 0x2ECC71FF, Object[oid][object_pos][0], Object[oid][object_pos][1], Object[oid][object_pos][2]+1.25, 15.0, .testlos = 1);
					}
				}
			}
			case OBJECT_TYPE_BOX:
			{
				Object[oid][object_label] = CreateDynamic3DTextLabel("£adunek\n{FFFFFF}\nKlawisz Y by podnieœæ", 0x2ECC71FF, Object[oid][object_pos][0], Object[oid][object_pos][1], Object[oid][object_pos][2]+1.25, 15.0);
			}
		}

		if(Object[oid][object_model] == OBJECT_BUSSTOP)
		{
			Object[oid][object_label] = CreateDynamic3DTextLabel("[[ Aby skorzystaæ z autobusu, wpisz /bus ]]", COLOR_WHITE, Object[oid][object_pos][0], Object[oid][object_pos][1], Object[oid][object_pos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
		}

		if(Object[oid][object_vw] == 0)
		{
			CA_CreateObject(model, x, y, z, rx, ry, rz);
		}
	}
	
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	LoadMaterial(sprintf("WHERE `material_owner` = %d", Object[oid][object_uid]));
	
	if( return_id ) return oid;
	return rows;
}

stock DeleteObject(o_id, bool:from_db = true)
{
	if( from_db )
	{ 
		mysql_tquery(mySQLconnection, sprintf("DELETE FROM `ipb_objects` WHERE `object_uid` = %d", Object[o_id][object_uid]));
		mysql_tquery(mySQLconnection, sprintf("DELETE FROM `ipb_materials` WHERE `material_owner` = %d", Object[o_id][object_uid]));
		
		if(Object[o_id][object_textured] > 0)
		{
			mysql_tquery(mySQLconnection, sprintf("DELETE FROM ipb_materials WHERE material_owner = %d", Object[o_id][object_uid]));
		}
	}

	if(IsValidDynamic3DTextLabel(Object[o_id][object_label]))
	{
		DestroyDynamic3DTextLabel(Object[o_id][object_label]);
	}

	DestroyDynamicObject(o_id);

	for(new z=0; e_objects:z != e_objects; z++)
	{
  		Object[o_id][e_objects:z] = 0;
    }
 	return 1;
}

stock UnattachDynamicObject(objId, veh)
{
    new Float:q[4];
    GetVehicleRotationQuat(veh, q[0], q[1], q[2], q[3]);
    if(!IsValidQuaternion(q)) return; 
    
    new Float:a[3], Float:ar[3];
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objId, E_STREAMER_ATTACH_OFFSET_X, a[0]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objId, E_STREAMER_ATTACH_OFFSET_Y, a[1]);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objId, E_STREAMER_ATTACH_OFFSET_Z, a[2]);

    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objId, E_STREAMER_ATTACH_R_X, ar[0]);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objId, E_STREAMER_ATTACH_R_Y, ar[1]);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objId, E_STREAMER_ATTACH_R_Z, ar[2]);

    VectorRelToAbsQuat(q, a, a); 
    RotationRelToAbsQuat(q, ar, ar); 
    
    new Float:x, Float:y, Float:z;
    GetVehiclePos(veh, x, y, z);
    
    AttachDynamicObjectToVehicle(objId, INVALID_VEHICLE_ID, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    SetDynamicObjectPos(objId, x+a[0], y+a[1], z+a[2]);
    SetDynamicObjectRot(objId, ar[0], ar[1], ar[2]);
}

stock ReattachDynamicObject(objId, veh)
{
    new Float:q[4];
    GetVehicleRotationQuat(veh, q[0], q[1], q[2], q[3]);
    if(!IsValidQuaternion(q)) return INVALID_VEHICLE_ID;
    
    new Float:a[3], Float:ar[3];
    GetDynamicObjectPos(objId, a[0], a[1], a[2]);
    GetDynamicObjectRot(objId, ar[0], ar[1], ar[2]);
    
    new Float:x, Float:y, Float:z;
    GetVehiclePos(veh, x, y, z);
    a[0] -= x;
    a[1] -= y;
    a[2] -= z;
    
    VectorAbsToRelQuat(q, a, a); 
    RotationAbsToRelQuat(q, ar, ar);
    
    AttachDynamicObjectToVehicle(objId, veh, a[0], a[1], a[2], ar[0], ar[1], ar[2]);
    return 1;
}

stock IsValidBlockadeObject(o_id)
{
	if(o_id == INVALID_STREAMER_ID) return 0;
	if(Object[o_id][object_type] != OBJECT_TYPE_BLOCKADE) return 0;

	switch(Object[o_id][object_model])
	{
		case 19834: return 1;
		case 1949: return 1;
		case 1427: return 1;
		case 1424: return 1;
		case 1423: return 1;
		case 1459: return 1;
		case 1237: return 1;
		case 3091: return 1;
		case 3578: return 1;
		case 1425: return 1;
		case 18728: return 1;
		case 1997: return 1;
	}

	return 0;
}

stock IsValidBlockadeModel(model)
{
	switch(model)
	{
		case 19834: return 1;
		case 1949: return 1;
		case 1427: return 1;
		case 1424: return 1;
		case 1423: return 1;
		case 1459: return 1;
		case 1237: return 1;
		case 3091: return 1;
		case 3578: return 1;
		case 1425: return 1;
		case 18728: return 1;
		case 1997: return 1;
	}
	return 0;
}

stock IsObjectEdited(o_id)
{
	if( Object[o_id][object_is_edited] )
	{
		foreach(new p : Player)
		{
			if( pInfo[p][player_edited_object] == o_id ) return 1;
		}
	}
	
	return 0;
}

stock GetObjectDataForPlayer(playerid, &owner, &owner_type)
{
	if( GetPlayerVirtualWorld(playerid) == 0 )
	{
		new a_id = GetPlayerArea(playerid, AREA_TYPE_NORMAL);
		if( a_id != -1 )
		{
			if( CanPlayerEditArea(playerid, a_id) )
			{
				owner = Area[a_id][area_uid];
				owner_type = OBJECT_OWNER_TYPE_AREA;
			}
		}
		else if( HasCrewFlag(playerid, CREW_FLAG_EDITOR) )
		{
			owner = 0;
			owner_type = OBJECT_OWNER_TYPE_GLOBAL;
			
			return 1;
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
			owner_type = OBJECT_OWNER_TYPE_DOOR;
			
			return 1;
		}
		
		if( CanPlayerEditDoor(playerid, d_id) )
		{
			owner = Door[d_id][door_uid];
			owner_type = OBJECT_OWNER_TYPE_DOOR;
			
			return 1;
		}
	}
	return 1;
}

stock CanPlayerEditObject(playerid, o_id)
{
	if( HasCrewFlag(playerid, CREW_FLAG_EDITOR) ) return 1;
	
	switch( Object[o_id][object_owner_type] )
	{	
		case OBJECT_OWNER_TYPE_GLOBAL:
		{
			if(IsValidBlockadeObject(o_id) )
			{
				new gid = pInfo[playerid][player_duty_gid];
				if(gid == -1) return 0;
				if(Group[gid][group_flags] & GROUP_FLAG_BLOCKADE) return 1;
			}
		}

		case OBJECT_OWNER_TYPE_DOOR:
		{
			if( CanPlayerEditDoor(playerid, GetDoorByUid(Object[o_id][object_owner])) ) return 1;
		}
		
		case OBJECT_OWNER_TYPE_AREA:
		{
			if( CanPlayerEditArea(playerid, GetAreaByUid(Object[o_id][object_owner])) ) return 1;
		}
	}
	return 0;
}

stock CanPlayerUseObject(playerid, o_id)
{
	if( HasCrewFlag(playerid, CREW_FLAG_EDITOR) ) return 1;
	
	switch( Object[o_id][object_owner_type] )
	{	
		case OBJECT_OWNER_TYPE_DOOR:
		{
			if( CanPlayerUseDoor(playerid, GetDoorByUid(Object[o_id][object_owner])) ) return 1;
		}
		
		case OBJECT_OWNER_TYPE_AREA:
		{
			new areaa = GetAreaByUid(Object[o_id][object_owner]);
			if (areaa == -1) return 0;

			if(Area[areaa][area_owner_type] == AREA_OWNER_TYPE_GROUP)
			{
				new gid = GetGroupByUid(Area[areaa][area_owner]);
				if(gid == -1) return 0;

				if( GetPlayerGroupSlot(playerid, gid) != -1 ) return 1;
			}
		}
	}
	return 0;
}

stock Float:GetPlayerDistanceToObject(playerid, object_id)
{
	if( !IsValidDynamicObject(object_id) ) return 0.0;
	
	new Float:p_pos[3], Float:distance;
	GetPlayerPos(playerid, p_pos[0], p_pos[1], p_pos[2]);
	
	Streamer_GetDistanceToItem(p_pos[0], p_pos[1], p_pos[2], STREAMER_TYPE_OBJECT, object_id, distance);
	return distance;
}

stock UpdateObjectInfoTextdraw(playerid, o_id)
{
	new string[200];

	switch( Object[o_id][object_owner_type] )
	{
		case OBJECT_OWNER_TYPE_GLOBAL: format(string, sizeof(string), "%d. Obiekt globalny (ID: %d)", Object[o_id][object_uid], o_id);
		case OBJECT_OWNER_TYPE_DOOR: format(string, sizeof(string), "%d. Obiekt drzwi (ID: %d)", Object[o_id][object_uid], o_id);
		case OBJECT_OWNER_TYPE_AREA: format(string, sizeof(string), "%d. Obiekt strefowy (ID: %d)", Object[o_id][object_uid], o_id);
	}

	format(string, sizeof(string), "%s~n~~n~~p~Owner: ~w~%d:%d    ~b~Typ: ~w~%d    Model: %d", string, Object[o_id][object_owner_type], Object[o_id][object_owner], Object[o_id][object_type], Object[o_id][object_model]);	
	format(string, sizeof(string), "%s~n~~r~Pozycja: ~w~%.2f, %.2f, %.2f~n~~r~Rotacja: ~w~%.2f, %.2f, %.2f", string, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2], Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);

	TextDrawSetString(Dashboard[playerid], string);
}

stock RotateCustomObject(playerid)
{
	new keysa, uda, lra;
	GetPlayerKeys(playerid, keysa, uda, lra);

	new o_id = pInfo[playerid][player_edited_object];
	new rot = GetPlayerEditorAngle(playerid);

	switch(rot)
	{
		case 270:
		{
			if(lra > 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][5] += 1.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][5] += 10.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}	

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][1] -= 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][1] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == KEY_JUMP)
				{
					Object[o_id][object_pos][5] += 5.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][1] -= 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(lra < 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][5] -= 1.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][5] -= 10.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][1] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][1] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == KEY_JUMP)
				{
					Object[o_id][object_pos][5] -= 5.0;
					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][1] += 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1],Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(uda > 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][2] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					new Float:down, Float:temp;
					GetDynamicObjectPos(o_id, temp, temp, down);

					Object[o_id][object_pos][2] = down-1;

					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}
				
			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][0] -= 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == KEY_JUMP)
			    {
		   			Object[o_id][object_pos][2] -= 0.1;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][0] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][0] -= 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(uda < 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][2] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][2] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][0] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_JUMP)
			    {
		   			Object[o_id][object_pos][2] += 0.1;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][0] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][0] += 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}
		}
		case 90:
		{
			if(lra > 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][5] += 1.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][5] += 10.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][1] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][1] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == KEY_JUMP)
				{
					Object[o_id][object_pos][5] += 5.0;

					if(Object[o_id][object_pos][5]> 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][1] += 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(lra < 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][5] -= 1.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][5] -= 10.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][1] -= 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][1] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == KEY_JUMP)
				{
					Object[o_id][object_pos][5] -= 5.0;
					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][1] -= 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1],Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(uda > 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][2] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					new Float:down, Float:temp;
					GetDynamicObjectPos(o_id, temp, temp, down);

					Object[o_id][object_pos][2] = down-1;

					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][0] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == KEY_JUMP)
			    {
		   			Object[o_id][object_pos][2] -= 0.1;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][0] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][0] += 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(uda < 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][2] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][2] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][0] -= 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_JUMP)
			    {
		   			Object[o_id][object_pos][2] += 0.1;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][0] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][0] -= 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}
		}

		case 180:
		{
			if(lra > 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][5] += 1.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][5] += 10.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][0] -= 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][0] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == KEY_JUMP)
				{
					Object[o_id][object_pos][5] += 5.0;

					if(Object[o_id][object_pos][5]> 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][0] -= 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(lra < 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][5] -= 1.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][5] -= 10.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][0] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][0] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == KEY_JUMP)
				{
					Object[o_id][object_pos][5] -= 5.0;
					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][0] += 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1],Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(uda > 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][2] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					new Float:down, Float:temp;
					GetDynamicObjectPos(o_id, temp, temp, down);

					Object[o_id][object_pos][2] = down-1;

					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][1] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == KEY_JUMP)
			    {
		   			Object[o_id][object_pos][2] -= 0.1;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][1] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][1] += 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(uda < 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][2] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][2] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][1] -= 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_JUMP)
			    {
		   			Object[o_id][object_pos][2] += 0.1;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][1] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][1] -= 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}
		}

		case 0:
		{
			if(lra > 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][5] += 1.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][5] += 10.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][0] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][0] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == KEY_JUMP)
				{
					Object[o_id][object_pos][5] += 5.0;

					if(Object[o_id][object_pos][5]> 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][0] += 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(lra < 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][5] -= 1.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][5] -= 10.0;

					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][0] -= 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][0] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == KEY_JUMP)
				{
					Object[o_id][object_pos][5] -= 5.0;
					if(Object[o_id][object_pos][5] > 360 && Object[o_id][object_pos][5] <= -360)
					{
						Object[o_id][object_pos][5] = 0.0;
					}
					SetDynamicObjectRot(o_id, Object[o_id][object_pos][3], Object[o_id][object_pos][4], Object[o_id][object_pos][5]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][0] -= 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1],Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(uda > 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][2] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					new Float:down, Float:temp;
					GetDynamicObjectPos(o_id, temp, temp, down);

					Object[o_id][object_pos][2] = down-1;

					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][1] -= 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == KEY_JUMP)
			    {
		   			Object[o_id][object_pos][2] -= 0.1;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][1] -= 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][1] -= 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}

			if(uda < 0)
			{
				if(keysa == 1056)
				{
					Object[o_id][object_pos][2] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				if(keysa == 40)
				{
					Object[o_id][object_pos][2] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_SPRINT)
			    {
		   			Object[o_id][object_pos][1] += 1.0;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

			    if(keysa == KEY_JUMP)
			    {
		   			Object[o_id][object_pos][2] += 0.1;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

		 		if(keysa == 1024)
			    {
		   			Object[o_id][object_pos][1] += 0.01;
					SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
					UpdateObjectInfoTextdraw(playerid, o_id);
					TextDrawShowForPlayer(playerid, Dashboard[playerid]);
					return 1;
				}

				Object[o_id][object_pos][1] += 0.1;
				SetDynamicObjectPos(o_id, Object[o_id][object_pos][0], Object[o_id][object_pos][1], Object[o_id][object_pos][2]);
				UpdateObjectInfoTextdraw(playerid, o_id);
				TextDrawShowForPlayer(playerid, Dashboard[playerid]);
			}
		}
	}
	return 1;
}

stock GetObjectByUid(uid)
{
	for(new o_id = 0; o_id <= Streamer_CountItems(STREAMER_TYPE_OBJECT); o_id++)
	{
		if( Object[o_id][object_uid] == uid ) return o_id;
	}
	return -1;
}

#define OBJECT_EXTRA_TYPE_NONE          		    	(0)
#define OBJECT_EXTRA_TYPE_PLAYER          	            (1)
#define OBJECT_EXTRA_TYPE_VEHICLE          		   		(2)
#define OBJECT_EXTRA_TYPE_OBJECT          		    	(3)
#define OBJECT_EXTRA_TYPE_DYNAMIC_OBJECT                   (4)

static stock GetPosOffset(Float: p_p_x, Float: p_p_y, Float: p_p_z, Float: p_c_x, Float: p_c_y, Float: p_c_z, &Float:p_n_x, &Float:p_n_y, &Float: p_n_z)
{
	p_n_x = (p_p_x > p_c_x) ? (p_p_x - p_c_x) : (p_c_x - p_p_x);
	p_n_y = (p_p_y > p_c_y) ? (p_p_y - p_c_y) : (p_c_y - p_p_y);
	p_n_z = (p_p_z > p_c_z) ? (p_p_z - p_c_z) : (p_c_z - p_p_z);
	return true;
}

stock IsObjectInRangeOfPlayer(playerid, bool: isdynamic, objectid, Float: radius)
{
	if(!isdynamic && !IsValidObject(objectid) || isdynamic && !IsValidDynamicObject(objectid))
	    return 0;
	    
	static
		Float: obj_r_x,
		Float: obj_r_y,
		Float: obj_r_z
	;
	
	if(isdynamic)
		GetDynamicObjectPos(objectid, obj_r_x, obj_r_y, obj_r_z);

	else
		GetObjectPos(objectid, obj_r_x, obj_r_y, obj_r_z);

	return IsPlayerInRangeOfPoint(playerid, radius, obj_r_x, obj_r_y, obj_r_z);
}

stock GetObjectOffsetFromPoint(objectid, bool: isdynamic, Float: cur_x, Float: cur_y, Float: cur_z, &Float: ret_x, &Float: ret_y, &Float: ret_z)
{
	if(!isdynamic && !IsValidObject(objectid) || isdynamic && !IsValidDynamicObject(objectid))
	    return 0;
	    
	static
	    Float: obj_off_comp_x,
	    Float: obj_off_comp_y,
	    Float: obj_off_comp_z
	;
	
	if(isdynamic)
	    GetDynamicObjectPos(objectid, obj_off_comp_x, obj_off_comp_y, obj_off_comp_z);
	    
	else
	    GetObjectPos(objectid, obj_off_comp_x, obj_off_comp_y, obj_off_comp_z);
	    
	return GetPosOffset(cur_x, cur_y, cur_z, obj_off_comp_x, obj_off_comp_y, obj_off_comp_z, ret_x, ret_y, ret_z);
}

stock GetObjectOffset(objectid, bool: isdynamic, extratype, extraid, &Float: obj_off_ret_x, &Float: obj_off_ret_y, &Float: obj_off_ret_z)
{
	if(!isdynamic && !IsValidObject(objectid) || isdynamic && !IsValidDynamicObject(objectid))
	    return 0;

	if(extratype <= OBJECT_EXTRA_TYPE_NONE || extratype > OBJECT_EXTRA_TYPE_DYNAMIC_OBJECT)
	    return 0;

	static
	    Float: obj_off_comp_x,
	    Float: obj_off_comp_y,
	    Float: obj_off_comp_z,

	    Float: obj_off_compto_x,
	    Float: obj_off_compto_y,
	    Float: obj_off_compto_z
	;

	switch(extratype)
	{
		case OBJECT_EXTRA_TYPE_PLAYER:
		{
		    if(!IsPlayerConnected(extraid))
			 return 0;

		    GetObjectPos(objectid, obj_off_comp_x, obj_off_comp_y, obj_off_comp_z);
		    GetPlayerPos(extraid, obj_off_compto_x, obj_off_compto_y, obj_off_compto_z);

		    return GetPosOffset(obj_off_comp_x, obj_off_comp_y, obj_off_comp_z, obj_off_compto_x, obj_off_compto_y, obj_off_compto_z, obj_off_ret_x, obj_off_ret_y, obj_off_ret_z);
		}

		case OBJECT_EXTRA_TYPE_VEHICLE:
		{
			if(!GetVehicleModel(extraid))
			    return 0;

			GetObjectPos(objectid, obj_off_comp_x, obj_off_comp_y, obj_off_comp_z);
			GetVehiclePos(extraid, obj_off_compto_x, obj_off_compto_y, obj_off_compto_z);

			return GetPosOffset(obj_off_comp_x, obj_off_comp_y, obj_off_comp_z, obj_off_compto_x, obj_off_compto_y, obj_off_compto_z, obj_off_ret_x, obj_off_ret_y, obj_off_ret_z);
		}

		case OBJECT_EXTRA_TYPE_OBJECT:
		{
			if(!IsValidObject(extraid))
			    return 0;

			GetObjectPos(objectid, obj_off_comp_x, obj_off_comp_y, obj_off_comp_z);
			GetObjectPos(extraid, obj_off_compto_x, obj_off_compto_y, obj_off_compto_z);

			return GetPosOffset(obj_off_comp_x, obj_off_comp_y, obj_off_comp_z, obj_off_compto_x, obj_off_compto_y, obj_off_compto_z, obj_off_ret_x, obj_off_ret_y, obj_off_ret_z);
		}

		case OBJECT_EXTRA_TYPE_DYNAMIC_OBJECT:
		{
			if(!IsValidDynamicObject(extraid))
			    return 0;

			GetObjectPos(objectid, obj_off_comp_x, obj_off_comp_y, obj_off_comp_z);
			GetDynamicObjectPos(extraid, obj_off_compto_x, obj_off_compto_y, obj_off_compto_z);

			return GetPosOffset(obj_off_comp_x, obj_off_comp_y, obj_off_comp_z, obj_off_compto_x, obj_off_compto_y, obj_off_compto_z, obj_off_ret_x, obj_off_ret_y, obj_off_ret_z);
		}
	}

	return 0;
}

stock ReplacePaynSprayGates()
{
	CreateObject(-1001, 2644.8594, -2039.2344, 14.0391, 0.0, 0.0, 270.0);
    CreateObject(-1002, 1041.3516, -1025.9297, 32.6719, 0.0, 0.0, 90.0);
    CreateObject(-1003, -2716.3516, 217.4766, 5.3828, 0.0, 0.0, 0.0);
    CreateObject(-1004, -1935.8594, 239.5313, 35.3516, 0.0, 0.0, 0.0);
    CreateObject(-1005, 2386.6563, 1043.6016, 11.5938, 0.0, 0.0, 90.0);
    CreateObject(-1006, 2071.4766, -1831.4219, 14.5625, 0.0, 0.0, 0.0);
    CreateObject(-1007, 1024.9844, -1029.3516, 33.1953, 0.0, 0.0, 90.0);
    CreateObject(-1008, 488.2813, -1734.6953, 12.3906, 0.0, 0.0, 90.0);
    CreateObject(-1009, -1904.5313, 277.8984, 42.9531, 0.0, 0.0, 0.0);
    CreateObject(-1010, -2425.7266, 1027.9922, 52.2813, 0.0, 0.0, 90.0);
    CreateObject(-1011, 1968.7422, 2162.4922, 12.0938, 0.0, 0.0, 0.0);
    CreateObject(-1012, 720.0156, -462.5234, 16.8594, 0.0, 0.0, 90.0);
    CreateObject(-1013, -1420.5469, 2591.1563, 57.7422, 0.0, 0.0, 90.0);
    CreateObject(-1013, -100.0000, 1111.4141, 21.6406, 0.0, 0.0, 270.0);
    CreateObject(-1014, 1843.3672, -1856.3203, 13.8750, 0.0, 0.0, 0.0);
    CreateObject(-1014, 2006.0000, 2317.6016, 11.3125, 0.0, 0.0, 270.0);
    CreateObject(-1014, 2006.0000, 2303.7266, 11.3125, 0.0, 0.0, 90.0);
}

stock RemoveBuildingsForPlayer(playerid)
{
	foreach(new r_id : RemoveObjects)
	{
		RemoveBuildingForPlayer(playerid, RemoveObject[r_id][remove_model], RemoveObject[r_id][remove_pos][0], RemoveObject[r_id][remove_pos][1], RemoveObject[r_id][remove_pos][2], RemoveObject[r_id][remove_pos][3]);
	}
	
	//Dystrybutory na stacji idlewood
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1778.4531, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1774.3125, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1771.3438, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1767.2891, 14.1406, 0.25);

	/*//Centrum
	RemoveBuildingForPlayer(playerid, 5945, 988.2734, -1289.6328, 15.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 5784, 988.2734, -1289.6328, 15.3750, 0.25);

	//obiekty na flores (mini centrum)
	RemoveBuildingForPlayer(playerid, 17736, 2362.4609, -1541.8047, 25.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 17737, 2386.6953, -1557.0313, 21.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 17522, 2362.4609, -1541.8047, 25.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 17508, 2386.6953, -1557.0313, 21.7188, 0.25);*/

	//edek w centrun na markecie
	RemoveBuildingForPlayer(playerid, 5951, 958.8203, -1359.8672, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 6002, 931.2266, -1357.3281, 25.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 6003, 954.6875, -1305.7734, 30.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1266, 932.5859, -1363.5156, 21.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1261, 958.3359, -1377.3203, 24.1328, 0.25);
	RemoveBuildingForPlayer(playerid, 1260, 932.5859, -1363.5156, 21.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 5814, 931.2266, -1357.3281, 25.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 1522, 929.3281, -1352.1719, 12.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, 981.8750, -1385.9922, 12.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 948.7656, -1381.1641, 13.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 1267, 958.3359, -1377.3203, 24.1328, 0.25);
	RemoveBuildingForPlayer(playerid, 5813, 958.8203, -1359.8672, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 957.9688, -1336.4531, 13.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 5818, 954.6875, -1305.7734, 30.1406, 0.25);

	//edek chuj wie co 05.07.2019
	RemoveBuildingForPlayer(playerid, 1438, -88.1094, -1598.7188, 1.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -86.5703, -1595.1406, 2.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3173, -93.0938, -1593.5234, 1.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 1462, -93.6797, -1588.0781, 1.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 3174, -75.1719, -1596.3047, 1.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -79.2578, -1593.4688, 1.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -72.4141, -1596.7734, 2.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -74.1875, -1583.9922, 2.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3175, -101.8203, -1577.6875, 1.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 1457, -91.0156, -1576.6250, 3.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -100.8203, -1580.4219, 2.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -93.2109, -1569.4844, 1.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3175, -77.9375, -1581.3125, 1.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 1472, -75.5859, -1581.0703, 2.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 727, -73.8203, -1569.1719, 1.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 3173, -90.6406, -1562.9375, 1.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -77.0625, -1542.6016, 1.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 1457, -71.0000, -1574.0859, 3.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 3175, -64.3828, -1572.2109, 1.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -62.2734, -1569.2891, 1.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -61.6641, -1573.4609, 2.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -56.0625, -1575.6563, 1.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -64.0000, -1550.2578, 2.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3175, -55.2813, -1557.4531, 1.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -56.1563, -1560.4609, 2.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 727, -49.3984, -1560.0078, 1.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 3174, -44.2891, -1561.3125, 1.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -43.7422, -1563.6875, 2.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3173, -67.2344, -1544.2188, 1.5547, 0.25);

	// mod shops
    RemoveBuildingForPlayer(playerid, 5340, 2644.8594, -2039.2344, 14.0391, 1.0);
    RemoveBuildingForPlayer(playerid, 5779, 1041.3516, -1025.9297, 32.6719, 1.0);
    RemoveBuildingForPlayer(playerid, 10575, -2716.3516, 217.4766, 5.3828, 1.0);
    RemoveBuildingForPlayer(playerid, 11313, -1935.8594, 239.5313, 35.3516, 1.0);
    RemoveBuildingForPlayer(playerid, 9093, 2386.6563, 1043.6016, 11.5938, 1.0);

	// pay n sprays
    RemoveBuildingForPlayer(playerid, 5422, 2071.4766, -1831.4219, 14.5625, 1.0);
    RemoveBuildingForPlayer(playerid, 5856, 1024.9844, -1029.3516, 33.1953, 1.0);
    RemoveBuildingForPlayer(playerid, 6400, 488.2813, -1734.6953, 12.3906, 1.0);
    RemoveBuildingForPlayer(playerid, 11319, -1904.5313, 277.8984, 42.9531, 1.0);
    RemoveBuildingForPlayer(playerid, 9625, -2425.7266, 1027.9922, 52.2813, 1.0);
    RemoveBuildingForPlayer(playerid, 7891, 1968.7422, 2162.4922, 12.0938, 1.0);
    RemoveBuildingForPlayer(playerid, 13028, 720.0156, -462.5234, 16.8594, 1.0);
    RemoveBuildingForPlayer(playerid, 3294, -1420.5469, 2591.1563, 57.7422, 1.0);
    RemoveBuildingForPlayer(playerid, 3294, -100.0000, 1111.4141, 21.6406, 1.0);

	// bomb shops
    RemoveBuildingForPlayer(playerid, 5043, 1843.3672, -1856.3203, 13.8750, 1.0);
    RemoveBuildingForPlayer(playerid, 7707, 2006.0000, 2317.6016, 11.3125, 1.0);
    RemoveBuildingForPlayer(playerid, 7709, 2006.0000, 2303.7266, 11.3125, 1.0);

	//East beach little havana
	RemoveBuildingForPlayer(playerid, 17752, 2809.7031, -1616.8203, 18.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 17549, 2809.7031, -1616.8203, 18.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2836.7656, -1643.1328, 10.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 716, 2844.3984, -1609.8984, 10.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 718, 2852.6641, -1599.5781, 10.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 716, 2864.3672, -1594.3672, 10.2891, 0.25);

	//Straz
	RemoveBuildingForPlayer(playerid, 1294, 1812.3047, -1455.5078, 16.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 4606, 1825.0000, -1413.9297, 12.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 4594, 1825.0000, -1413.9297, 12.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 1842.1328, -1406.4375, 15.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 1842.1328, -1431.5859, 15.9141, 0.25);

	//Edek LSPD
	RemoveBuildingForPlayer(playerid, 4226, 1359.2813, -1796.4688, 24.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 1265, 1336.1563, -1844.0156, 12.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1372, 1336.3359, -1842.8516, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 1265, 1336.3750, -1841.5391, 13.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1347.7031, -1856.1484, 17.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 1265, 1337.2578, -1841.8750, 13.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1220, 1340.8906, -1835.3672, 12.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 1230, 1340.1328, -1835.0391, 12.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 1220, 1340.8672, -1834.4844, 12.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1385.2422, -1833.2656, 16.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 1265, 1336.8750, -1818.2266, 12.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1372, 1336.7891, -1816.3047, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 1220, 1338.1250, -1816.5781, 12.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 1230, 1338.0781, -1815.7578, 12.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 1220, 1338.8984, -1816.1641, 12.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 1220, 1342.2734, -1806.2031, 12.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 1230, 1342.6328, -1807.0391, 12.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 1221, 1342.5156, -1805.0703, 12.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1220, 1338.9531, -1796.4297, 12.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 4023, 1359.2813, -1796.4688, 24.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 1230, 1338.9609, -1796.0000, 13.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 1220, 1338.9375, -1795.4609, 12.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 1221, 1338.9688, -1793.7266, 12.9844, 0.25);

	RemoveBuildingForPlayer(playerid, 714, 2490.6172, -1806.5703, 14.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 17765, 2436.2188, -1788.5625, 15.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2500.5391, -1807.8906, 13.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 2496.9766, -1794.3516, 12.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2505.0781, -1821.4219, 13.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2506.7813, -1816.6641, 13.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2507.6797, -1811.5000, 13.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2509.2422, -1806.4375, 13.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2511.2578, -1801.5625, 13.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2513.4922, -1796.7344, 13.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 2517.8672, -1801.7109, 16.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 1311, 2528.6406, -1778.4063, 16.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 2481.6719, -1819.9844, 13.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 616, 2430.3516, -1818.0703, 8.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 2417.7500, -1805.3047, 16.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 17523, 2436.2188, -1788.5625, 15.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2448.9766, -1800.8281, 13.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 616, 2440.9297, -1804.7344, 12.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2469.7578, -1803.4922, 13.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2479.9531, -1797.7031, 13.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 2460.7891, -1795.3438, 12.5781, 0.25);

	//Szkola
	RemoveBuildingForPlayer(playerid, 5221, 2360.7188, -2117.0078, 16.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 5192, 2360.7188, -2117.0078, 16.2578, 0.25);

	//Ganton
	RemoveBuildingForPlayer(playerid, 17614, 2387.8047, -1695.6484, 13.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 17876, 2393.0625, -1677.5234, 20.8203, 0.25);

	//Crystal Gardens
	RemoveBuildingForPlayer(playerid, 3662, 2142.7031, -1657.9297, 17.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 3662, 2164.9375, -1666.3047, 17.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 3662, 2141.8672, -1693.3516, 17.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 3662, 2154.3516, -1713.6641, 17.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 5549, 2137.9844, -1672.5547, 12.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3661, 2141.8672, -1693.3516, 17.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 3661, 2154.3516, -1713.6641, 17.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 5518, 2137.9844, -1672.5547, 12.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3661, 2142.7031, -1657.9297, 17.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 3661, 2164.9375, -1666.3047, 17.5547, 0.25);

	//Plaza skatepark
	RemoveBuildingForPlayer(playerid, 6442, 570.7422, -1868.3438, 1.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 6281, 570.7422, -1868.3438, 1.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 3778, 553.3516, -1875.0000, 4.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3615, 553.3516, -1875.0000, 4.7891, 0.25);

	//Alhambra
	RemoveBuildingForPlayer(playerid, 5544, 1873.7422, -1682.4766, 34.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1524, 1837.6641, -1640.3828, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1537, 1837.4375, -1683.9688, 12.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 1533, 1837.4375, -1683.9531, 12.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 1537, 1837.4375, -1686.9844, 12.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 1533, 1837.4375, -1677.9219, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1537, 1837.4375, -1680.9531, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1533, 1837.4375, -1680.9375, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 5408, 1873.7422, -1682.4766, 34.7969, 0.25);
	
	//Edek east ls
	RemoveBuildingForPlayer(playerid, 17868, 2458.3828, -1532.4375, 22.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 1525, 2462.2656, -1541.4141, 25.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1261, 2445.2031, -1519.3906, 37.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2490.4453, -1585.8672, 20.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2491.8281, -1516.5078, 23.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2495.2656, -1538.0078, 22.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2495.2656, -1553.0781, 22.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 760, 2495.1563, -1549.7500, 23.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2495.2656, -1522.8047, 22.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 760, 2494.2109, -1521.6094, 23.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 760, 2494.0078, -1529.2188, 23.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2510.5625, -1563.4766, 21.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2526.2188, -1581.6406, 20.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2542.1719, -1554.0469, 21.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 616, 2528.7109, -1556.6797, 21.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 616, 2542.2188, -1525.3750, 21.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2539.8047, -1515.9531, 23.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2552.5703, -1550.0234, 20.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2543.4375, -1515.2578, 22.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2563.9609, -1515.3438, 22.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2568.7813, -1511.0547, 20.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2462.3594, -1579.3281, 20.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 17916, 2366.8125, -1537.5391, 39.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2442.9922, -1559.0781, 23.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2451.6641, -1561.5469, 23.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 760, 2446.1563, -1562.2031, 23.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 760, 2467.7969, -1562.2031, 23.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 616, 2469.4141, -1562.1328, 22.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 2459.2656, -1558.7266, 26.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2445.7969, -1543.2578, 21.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 760, 2444.6797, -1542.7813, 23.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2457.0156, -1542.6953, 21.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 2474.1016, -1544.2578, 26.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 760, 2463.7344, -1542.7813, 23.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 17863, 2467.4609, -1538.2500, 27.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 17862, 2458.3828, -1532.4375, 22.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 2482.9297, -1530.5391, 26.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 1267, 2445.2031, -1519.3906, 37.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 2474.6328, -1518.7734, 26.3047, 0.25);

	//edek cos nowego
	RemoveBuildingForPlayer(playerid, 4051, 1371.8203, -1754.8203, 19.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 4191, 1353.2578, -1764.5313, 15.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 4226, 1359.2813, -1796.4688, 24.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 4023, 1359.2813, -1796.4688, 24.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 1372, 1337.6953, -1774.7344, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 1265, 1338.7891, -1775.3203, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1265, 1337.0078, -1773.8672, 13.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 4022, 1353.2578, -1764.5313, 15.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1532, 1353.1328, -1759.6563, 12.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1341.4531, -1755.4844, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1345.7656, -1740.6172, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1335.1953, -1731.7813, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1357.5156, -1732.9375, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 4021, 1371.8203, -1754.8203, 19.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 4050, 1350.7578, -1802.2813, 12.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 4010, 1350.7578, -1802.2813, 12.6953, 0.25);

	//wiezienie
	RemoveBuildingForPlayer(playerid, 13048, -91.5625, -251.5156, 0.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -207.6563, -246.7344, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -196.7188, -246.1641, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -224.5000, -183.9063, 1.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -200.3281, -189.7344, 1.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -200.3281, -189.7344, 3.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -176.6797, -195.3594, 1.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -156.9453, -266.9141, 4.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -149.9141, -324.3438, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 12932, -117.9609, -337.4531, 3.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -149.9141, -324.3438, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 12934, -184.5781, -289.8984, 3.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 12935, -215.9453, -275.7500, 3.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -156.9453, -266.9141, 4.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 12931, -91.5625, -251.5156, 0.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -207.6563, -246.7344, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 13025, -148.9766, -228.5313, 3.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -196.7188, -246.1641, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -176.6797, -195.3594, 1.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -200.3281, -189.7344, 1.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -200.3281, -189.7344, 3.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -224.5000, -183.9063, 1.5313, 0.25);
}

stock IsValidObjectModel(model)
{
	if(model <= -1000) return 1;

	static
		valid_model[] = 
		{
			0b11111111111011111110110111111110, 0b00000000001111111111111111111111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111111111111110000000,
			0b11100001001111111111111111111111, 0b11110111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000001111000000111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111100011111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111011111, 0b11111111111111111111111101111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111100000000000001111111111,
			0b11111111111111111111111111111111, 0b11111111111010111101111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111001111111111111,
			0b11111111111111111111111111111111, 0b10000000000011111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111011111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111101011101111111111, 0b11111111111111111111111111110111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111110011,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111100111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111011110111101111,
			0b10000000000000000000000000000000, 0b00000010000010000000010011111111,
			0b00000000001000000100000000000000, 0b11111111101101100101111000000000,
			0b01110000111111111111111111111011, 0b00000000001111111111111111000000,
			0b10011111110000000000001111001100, 0b11111111101111001100000000011110,
			0b00001110110111111100111111111111, 0b11111111111111111111111111001110,
			0b11111000000011111111111111111111, 0b11111111111111111110111101101011,
			0b01000000000000000111111101110111, 0b11010111111111111111000001111100,
			0b11110011111111111111111001111111, 0b01011111111111111111111111111111,
			0b01111110100001111011111010101011, 0b10001001010101100100001000010000,
			0b10100000000000000001010000101010, 0b00001000001111101010111100100000,
			0b11111111111111111111111010100001, 0b00000000011111111111110101111111,
			0b00001111111111111111110000111100, 0b11011110111111001111011011111011,
			0b11111111111001111111110011001110, 0b11111111111111111111111111111111,
			0b01111111111111111111111110111111, 0b01111000111111111111110111111111,
			0b00011100000000010000000000000111, 0b00001111111100001000000000000000,
			0b10101111001001110111110011111000, 0b01010101010101010110100000101011,
			0b01110111110101011111110100101001, 0b01111111111100101110111011111011,
			0b11111111111111111100101111001000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000000011111111111111111111111, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111000000000000000000000000, 0b00010100101000001111111111111111,
			0b11111111101111011111111111000000, 0b00111111111111111111111100000001,
			0b11110000000000000000000000000000, 0b00000101010101010111111111111111,
			0b11110010110111000011111010000000, 0b11111110111110000111110111010000,
			0b00000000000000011111111111111111, 0b00000000000000000000000000000000,
			0b11111111111111111111111111000000, 0b11111111111111111111111111111111,
			0b11011111111111111111111111111111, 0b00000000000000000000000000000111,
			0b00000000000000000000000000000000, 0b11010111111000000000000000000000,
			0b10110011001000101111111111111111, 0b00011000010111010101011111010111,
			0b11011111111111111111010101111111, 0b11111111111111100000000000000011,
			0b11111111111111111111111111111111, 0b11111111111111111100000101111111,
			0b00000000000000000000000111111111, 0b00011000000001111000000000000000,
			0b11111111111111100111100000000100, 0b11110100011011111111110000000000,
			0b11111110001001111111110000000111, 0b11111111110110000100101010101000,
			0b11111111111111111100000000000000, 0b11111111111111111111111111111111,
			0b11101011111011110011111111111111, 0b11111111111111111111111111111111,
			0b00010001000001111100001111111111, 0b00100000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111101000000000000000000000000,
			0b11110001110101000001111111111111, 0b00000000000001101111010000010010,
			0b11111111111111111111111110000000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11100001111100000111100000000000, 0b11100110011111111101011111111011,
			0b00000000000000000000000100111001, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000100110000101100111111001100,
			0b11111111111110000000000000000000, 0b00000000000001111111111111111111,
			0b11000001111111011100000110000000, 0b00000111111101111111111111111111,
			0b00000000001000011110000111010010, 0b00111000100111110011110000000000,
			0b00111111111110101000001001111110, 0b00000000000000100001111100000000,
			0b11111111111111111111111100000000, 0b01111111111111111111111111111111,
			0b01011100001111111110101111110111, 0b11100010111111100000000000111111,
			0b11011000011000110011100011111001, 0b01100110000011110001100000010000,
			0b00000111100000000000000000000100, 0b00010111111101100011100001101010,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111101111111000000000000000, 0b01111000000111100000000111111111,
			0b00000000011111110111111110111111, 0b11111111111111111111111111111111,
			0b00000000101001101111111111111111, 0b11111111111111111111111111111110,
			0b10100001000000111111111111111111, 0b11111111111111111111111111111011,
			0b00000000000000000000000000000011, 0b00000000000000100000000000000000,
			0b01110001111111010000000000010000, 0b11111101111101100011011111111111,
			0b10000000011111111111110101010111, 0b11011111100000010011001010110111,
			0b11010011101011111111111111111111, 0b10101010000010010000001111111000,
			0b11111000101111100000111110010110, 0b11111111100000000000000000000001,
			0b11111111111111111111111111111111, 0b01111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111101111111111,
			0b11111111111111111111111111111111, 0b00000000000001111111111111111111,
			0b00111000000000010001000000000010, 0b00000000000011100000000000000000,
			0b00000000000000000000100000000000, 0b00000000000000000000000000000000,
			0b11110101000000000000000000000000, 0b00011111111000000101001000000111,
			0b11110000011110100011011101000000, 0b01111110111111111111111111111111,
			0b10101000000111110100101111011100, 0b11111111111111111111110000111010,
			0b00000000000000000000011111111111, 0b11111111111111111111111111111110,
			0b00001000111111111111111111111111, 0b00000000000000000000000000000000,
			0b00001111111110000000001111111101, 0b00111110000001111111101110100000,
			0b00001111111101111100011111000100, 0b11101010111101010011000111110000,
			0b11101010000000000000000111010001, 0b10001110110101100101000001110101,
			0b11000011111010101011111111111111, 0b11010110101111110000000000111111,
			0b00011111111111111111111111010100, 0b11111111111111111111111111111111,
			0b00111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b10000000001111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00000000000000111111111111111111,
			0b00000000000000000000000001000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00011111000000000000000000000000,
			0b00011111111111100111111111111111, 0b00000011111111111111111111111110,
			0b00000000000000000000000000000000, 0b00101100000110000000000000010000,
			0b11100000111110000000001000000000, 0b11111000000000011111111100000000,
			0b11010000111111101011111111111111, 0b11001101010100011100011101000011,
			0b11111111111101010011110011100111, 0b01000000000111111001101111111111,
			0b00000000111010111111110010000111, 0b11111111111000000000001111111111,
			0b11111111111111111111111111111111, 0b11111111111011110111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000000000001100000001111111111, 0b00000000000000000000000000000000,
			0b11100000000000000000000000000000, 0b00000000000000000000000000000001,
			0b11111111111111111111110000010000, 0b00000111111111111111111111111111,
			0b11111111111111111110100000000000, 0b11111111111111111111111110111111,
			0b00000011100001111111111111111111, 0b00000000001100000000000000000000,
			0b01100110001011010000000000000000, 0b11111111111111111111111111111111,
			0b00000111111111111111111111111111, 0b00000000000000000000000011111110,
			0b11111111110100000000000000000000, 0b00000000000000000111111111101011,
			0b01100000000000000000000110011100, 0b11111111111111111111111111101010,
			0b11111100000000000111111111111111, 0b00000000000000000000000001111111,
			0b11101111000000000000000000000000, 0b11111110111111111111111111111111,
			0b11111111111111111111011111111111, 0b11000000001000000000000011011001,
			0b11011111111111111111111111111111, 0b11100000011000000000011111111110,
			0b00000000001111100011111111111111, 0b00011110111111000000000000000000,
			0b11001111111100001001011111110100, 0b00110001110001111000011101011110,
			0b00000000000000000000000001110110, 0b11111111111111111100000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00111111111111111111111111111111,
			0b00000000000000000000000000000000, 0b11000000000000000000000000000000,
			0b00000000000000011111111111111111, 0b11101111111111110100001000000000,
			0b00001010000000001111111111111111, 0b00001100000110011000000000000000,
			0b01010011111111111111111111000000, 0b11000001111111111100000000000100,
			0b11111111111111111111111111111111, 0b11001111110000000000111111111111,
			0b11111111111111111111111111111111, 0b00001111111111111111111111011111,
			0b00000011100000000000111000100000, 0b11111111111111111110000000100000,
			0b11111111111001111111111111111111, 0b11111111111111111111111111111111,
			0b00000000000000000000000011111111, 0b10000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111001111,
			0b00000000000000000111111000001111, 0b00000000000000000000000000000000,
			0b11110111100000000000000000000000, 0b00111111111100001011111111111111,
			0b10110111101010010000000000000000, 0b11010000111111110001011011101010,
			0b10000011100000101101001011010000, 0b11111111111110000100000010111101,
			0b11110011011111110100001100011111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00000000000110011111111111111111,
			0b00001111100000000000000000000000, 0b10000000000000001011111010000000,
			0b11100100000001111000000000000000, 0b00000000000000000000000000000011,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111011,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00001110001111111101111001011011,
			0b00011110011000011100011000111100, 0b11000000001011111111111110010001,
			0b01111111111111111101101111111111, 0b00111111111111111010100001110010,
			0b01111111111000000100000001011000, 0b00000000001110000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000111000000000000000,
			0b01000001000100000011101000000001, 0b11001111100110110000000000111010,
			0b00000000000000000000000000000000, 0b11111000000000000100000000000000,
			0b01000000001000000001111110111111, 0b11111111111011100111000000000000,
			0b11111111111111111111111111111111, 0b00001111111111111111111111111111,
			0b11111111110000000000000000000000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111100001111,
			0b11111111111111111111111111111111, 0b01111111101111011111111111111111,
			0b00100001000000000000000000000010, 0b10110111011001100111011000001000,
			0b00000000001000000000000010000111, 0b10000100000000011000001111100000,
			0b00000000000000000000000000000100, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111111000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11010111111111111111111111111101, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111100000011111111111111111111,
			0b11111111111111111111111111110011, 0b11111111111111111111100011111111,
			0b11111111111111111000000111111111, 0b11111111111111000011111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111110111111111, 0b00000000111101111111111111101111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111100000000000000000,
			0b00000001111111111111111111111111, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111000000011111110111111111, 0b11111111111111111111111111111111,
			0b11111111111111101111111111111111, 0b00000111111111111111111111111111,
			0b00001111111111111111111111111111, 0b01110100111101000100000111110000,
			0b10101000000000000000000000000001, 0b00000000111101000000000000000011,
			0b00000000111111000000000000000000, 0b00001001000111000000000000000000,
			0b00100010100000100000000000000000, 0b11111111111110001100000000100100,
			0b11111111111111111111111111111111, 0b01110000011101100011111001111010,
			0b11111000000000000000000000011110, 0b11000001111101100000111111111111,
			0b00000000011111111111111111101110, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111111111111100000000,
			0b11111110001111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b01010111111111111111111111111111,
			0b01010101010101010101010101010101, 0b01010101000101010101010101010101,
			0b01010101010101010101010101010101, 0b10101010101010000101010101010101,
			0b01111010111111111111111111111010, 0b00000000111010101101100000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b10000000000000111100000000000000,
			0b11110000000000000000000000000101, 0b11111111111111111111111011111111,
			0b11111111111111111111111111111111, 0b11111101101101101100111111100001,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00000000000000000000000000011111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000101011000000000000, 0b01111011000000100000000000100000,
			0b11000011111111010000111111011000, 0b11111011100011110110111001111001,
			0b11001101111111110110000111100111, 0b00000101011110110000000001111110,
			0b11111111111111110000000000000000, 0b11111111110111111111111111111111,
			0b11111111111111111111111111111111, 0b00100011011111111111111111111111,
			0b00000000000000000000000000000001, 0b00000000000000000000000000000000,
			0b11111111000000000000000000000000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000111111111111111111111111111, 0b00000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b00000000001111111111111111111111,
			0b00000000010000000000000000000001, 0b00000011100000000000000000000000,
			0b00000000000000000000001111101010, 0b11111111111111110000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b10111111111111111111111111111111, 0b11111111111111111100111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b01111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111110011111111111, 0b11101111111111111111000111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11110000000001111111111111111111, 0b00001111111111111111111111111111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00100000000000000000000000000000
		};

	if( model >= 15065 && model <= 15999)
	{
		return 1;
	}
	if( model == 7709)
	{
		return 0;
	}
	if( model >= 11682 && model <= 12799)
	{
		return 1;
	}
	if( model >= 18631 && model <= 19999)
	{
		return 1;
	}
	if (model > 19999)
	{
		return 0;
	}
	//spraytags from single player (causing total respect -)
	if(model >= 1525 && model <= 1531)
	{
		return 0;
	}
	model -= 320;
	if (model < 0)
	{
		return 0;
	}
	return (valid_model[model >> 5] & (1 << (model & 0x1F)));
}

new modelflags_flags[68] = {0,2097152,4,2097156,2097284,2097220,2097280,128,68,5,132,2,2048,64,140,2176,2099328,2097348,
196,1,129,8321,192,4100,4096,8192,32896,2162816,2130052,32900,2130048,32768,1048580,32,160,164,2097184,262148,65536,69,
2097157,2180,2097153,130,8196,131072,1024,1028,516,8324,2105476,2105348,12420,4194304,2098180,2098244,6,640,2146436,2113668,
2113540,2113536,2129924,2138244,2138116,2109572,2146308,2101248};
new modelflags_index[68] = {18631,18636,18637,18656,18783,19197,19489,19490,19605,19628,19857,11089,11102,11306,11324,8948,
9099,16013,16448,12800,13116,13273,17978,990,994,17040,1223,1225,1278,1306,1315,1350,1490,1491,1492,1493,1533,14547,14570,
4596,6489,6517,5750,3781,3948,2969,3034,1649,1651,800,881,882,904,2756,3850,3857,13595,8197,620,624,629,649,658,670,693,738,
739,1138};

FindModelIDForFlags(flags)
{
	flags &= 0xFFFFFFDF; // remove the interior flag
	
	new x=0;
	while(x!=68) {
	    if(modelflags_flags[x] == flags) return modelflags_index[x];
	    x++;
	}
	return 19353;
}

//-------------------------------------------------

AddVC2SASimpleObject(flags,newmodelid,dffpath[],txdpath[], global = 0)
{
	if(global == 1)
	{
		AddSimpleModel(-1,FindModelIDForFlags(flags),newmodelid,dffpath,txdpath);
	}
	else
	{
		AddSimpleModel(VC2SA4SAMP_VWORLD,FindModelIDForFlags(flags),newmodelid,dffpath,txdpath);
	}
}

//-------------------------------------------------

AddVC2SASimpleTimed(flags,timeon,timeoff,newmodelid,dffpath[],txdpath[], global = 0)
{
	if(global == 1)
	{
		AddSimpleModelTimed(-1,FindModelIDForFlags(flags),newmodelid,dffpath,txdpath,timeon,timeoff); // wax on/wax off
	}
	else
	{
		AddSimpleModelTimed(VC2SA4SAMP_VWORLD,FindModelIDForFlags(flags),newmodelid,dffpath,txdpath,timeon,timeoff); // wax on/wax off
	}
}

//-------------------------------------------------

AddAll_VC2SA_Models() {
AddVC2SASimpleObject(0,-18000,"vc2sa/dff/ap_tower.dff","vc2sa/txd/ap_buildings2.txd");
AddVC2SASimpleObject(0,-18001,"vc2sa/dff/ap_terminAchek1_01.dff","vc2sa/txd/ap_terminAint.txd");
AddVC2SASimpleObject(0,-18002,"vc2sa/dff/ap_terminAchek1_02.dff","vc2sa/txd/ap_terminAint.txd");
AddVC2SASimpleObject(4,-18003,"vc2sa/dff/ap_gatesA.dff","vc2sa/txd/ap_terminal1boards.txd");
AddVC2SASimpleObject(4,-18004,"vc2sa/dff/ap_gatesB.dff","vc2sa/txd/ap_terminal1boards.txd");
AddVC2SASimpleObject(0,-18005,"vc2sa/dff/ap_terminA_01.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18006,"vc2sa/dff/jump_box108.dff","vc2sa/txd/jumpbox.txd");
AddVC2SASimpleObject(0,-18007,"vc2sa/dff/jump_box112.dff","vc2sa/txd/jumpbox.txd");
AddVC2SASimpleObject(4,-18008,"vc2sa/dff/ap_hangar1_01.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(4,-18009,"vc2sa/dff/apairprtbits01.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(4,-18010,"vc2sa/dff/apairprtbits05.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(4,-18011,"vc2sa/dff/Helipad0.dff","vc2sa/txd/helipad.txd");
AddVC2SASimpleObject(0,-18012,"vc2sa/dff/ap_screens1_01.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18013,"vc2sa/dff/ap_runsign3_01.dff","vc2sa/txd/ap_runsigns1.txd");
AddVC2SASimpleObject(0,-18014,"vc2sa/dff/ap_termsign1_01.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18015,"vc2sa/dff/ap_termsign2_01.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18016,"vc2sa/dff/ap_gatedisp1_01.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18017,"vc2sa/dff/ap_booth1_01.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18018,"vc2sa/dff/ap_booth2_01.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18019,"vc2sa/dff/ap_booth3_01.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18020,"vc2sa/dff/ap_booth1_02.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18021,"vc2sa/dff/ap_runsign6_02.dff","vc2sa/txd/ap_runsigns1.txd");
AddVC2SASimpleObject(0,-18022,"vc2sa/dff/ap_runsign7_03.dff","vc2sa/txd/ap_runsigns1.txd");
AddVC2SASimpleObject(0,-18023,"vc2sa/dff/ap_subfraightback04.dff","vc2sa/txd/subcratesVC.txd");
AddVC2SASimpleObject(0,-18024,"vc2sa/dff/ap_subfraightback02.dff","vc2sa/txd/subcratesVC.txd");
AddVC2SASimpleObject(0,-18025,"vc2sa/dff/ap_subfraightback01.dff","vc2sa/txd/subcratesVC.txd");
AddVC2SASimpleObject(0,-18026,"vc2sa/dff/ap_screens2_01.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18027,"vc2sa/dff/ap_gatedisp1_02.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18028,"vc2sa/dff/jump_box113.dff","vc2sa/txd/jumpbox.txd");
AddVC2SASimpleObject(0,-18029,"vc2sa/dff/jump_box_02.dff","vc2sa/txd/jumpbox.txd");
AddVC2SASimpleObject(0,-18030,"vc2sa/dff/ap_firetrucks.dff","vc2sa/txd/ap_build2.txd");
AddVC2SASimpleObject(0,-18031,"vc2sa/dff/airport_carpark0.dff","vc2sa/txd/ap_carpark3.txd");
AddVC2SASimpleObject(4,-18032,"vc2sa/dff/carparkfence0.dff","vc2sa/txd/ap_roads.txd");
AddVC2SASimpleObject(4,-18033,"vc2sa/dff/ap_roadsigns1_02.dff","vc2sa/txd/ap_build2.txd");
AddVC2SASimpleObject(0,-18034,"vc2sa/dff/ap_steps1_01.dff","vc2sa/txd/airstuff2.txd");
AddVC2SASimpleObject(0,-18035,"vc2sa/dff/ap_trailer_01.dff","vc2sa/txd/luggage.txd");
AddVC2SASimpleObject(0,-18036,"vc2sa/dff/ap_06trailer01.dff","vc2sa/txd/luggage.txd");
AddVC2SASimpleObject(0,-18037,"vc2sa/dff/ap_runsign10_03.dff","vc2sa/txd/ap_runsigns1.txd");
AddVC2SASimpleObject(4,-18038,"vc2sa/dff/ap_roadsigns1_03.dff","vc2sa/txd/ap_build2.txd");
AddVC2SASimpleObject(0,-18039,"vc2sa/dff/ap_concwall1.dff","vc2sa/txd/ap_misc1.txd");
AddVC2SASimpleObject(0,-18040,"vc2sa/dff/ap_freightterminal1.dff","vc2sa/txd/ap_build3.txd");
AddVC2SASimpleObject(0,-18041,"vc2sa/dff/ap_flyingschool1.dff","vc2sa/txd/ap_build3.txd");
AddVC2SASimpleObject(4,-18042,"vc2sa/dff/ap_smallradar1.dff","vc2sa/txd/ap_build4.txd");
AddVC2SASimpleObject(0,-18043,"vc2sa/dff/ap_fuelbay1.dff","vc2sa/txd/ap_fuel1.txd");
AddVC2SASimpleObject(0,-18044,"vc2sa/dff/ap_oiltank1_01.dff","vc2sa/txd/ap_fuel1.txd");
AddVC2SASimpleObject(0,-18045,"vc2sa/dff/ap_oilpipes1.dff","vc2sa/txd/ap_fuel1.txd");
AddVC2SASimpleObject(0,-18046,"vc2sa/dff/ap_flargetank1.dff","vc2sa/txd/ap_fuel2.txd");
AddVC2SASimpleObject(0,-18047,"vc2sa/dff/ap_midtank1.dff","vc2sa/txd/ap_fuel2.txd");
AddVC2SASimpleObject(4,-18048,"vc2sa/dff/ap_fuelshad1.dff","vc2sa/txd/ap_fuel3.txd");
AddVC2SASimpleObject(0,-18049,"vc2sa/dff/jump_box114.dff","vc2sa/txd/jumpbox.txd");
AddVC2SASimpleObject(0,-18050,"vc2sa/dff/jump_box115.dff","vc2sa/txd/jumpbox.txd");
AddVC2SASimpleObject(0,-18051,"vc2sa/dff/ap_hland_01.dff","vc2sa/txd/ap_ground1.txd");
AddVC2SASimpleObject(0,-18052,"vc2sa/dff/ap_hookerinn1.dff","vc2sa/txd/ap_build3.txd");
AddVC2SASimpleObject(0,-18053,"vc2sa/dff/ap_hotroadsect1.dff","vc2sa/txd/ap_roadsect1.txd");
AddVC2SASimpleObject(4,-18054,"vc2sa/dff/ap_boardshad1.dff","vc2sa/txd/ap_terminal1boards.txd");
AddVC2SASimpleObject(4,-18055,"vc2sa/dff/ap_smallhangars1_01.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(4,-18056,"vc2sa/dff/ap_smahangar2_01.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(4,-18057,"vc2sa/dff/apairprtbits07.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(0,-18058,"vc2sa/dff/ap_booth2_03.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18059,"vc2sa/dff/ap_seaplaland1.dff","vc2sa/txd/ap_seasplane.txd");
AddVC2SASimpleObject(0,-18060,"vc2sa/dff/ap_seaplanehanger1.dff","vc2sa/txd/ap_seasplane.txd");
AddVC2SASimpleObject(4,-18061,"vc2sa/dff/ap_termwindows1.dff","vc2sa/txd/ap_termwindows.txd");
AddVC2SASimpleObject(4,-18062,"vc2sa/dff/ap_blastdef_01.dff","vc2sa/txd/ap_newprops1opac.txd");
AddVC2SASimpleObject(4,-18063,"vc2sa/dff/ap_blastdef_03.dff","vc2sa/txd/ap_newprops1opac.txd");
AddVC2SASimpleObject(0,-18064,"vc2sa/dff/air_brway_030.dff","vc2sa/txd/airgrndb.txd");
AddVC2SASimpleObject(0,-18065,"vc2sa/dff/air_brway_31.dff","vc2sa/txd/airgrndb.txd");
AddVC2SASimpleObject(0,-18066,"vc2sa/dff/air_brway_32.dff","vc2sa/txd/airgrndb.txd");
AddVC2SASimpleObject(0,-18067,"vc2sa/dff/air_brway_33.dff","vc2sa/txd/airgrndb.txd");
AddVC2SASimpleObject(0,-18068,"vc2sa/dff/air_brway_34.dff","vc2sa/txd/airgrndb.txd");
AddVC2SASimpleObject(0,-18069,"vc2sa/dff/ap_seahangstuft.dff","vc2sa/txd/ap_seaplanprop.txd");
AddVC2SASimpleObject(0,-18070,"vc2sa/dff/ap_dockstairs1.dff","vc2sa/txd/ap_seaplanprop.txd");
AddVC2SASimpleObject(0,-18071,"vc2sa/dff/ap_seaplanedock1.dff","vc2sa/txd/ap_seaplanprop.txd");
AddVC2SASimpleObject(0,-18072,"vc2sa/dff/ap_transpol1.dff","vc2sa/txd/ap_misc1.txd");
AddVC2SASimpleObject(0,-18073,"vc2sa/dff/ap_kerb1.dff","vc2sa/txd/ap_ci_indus2.txd");
AddVC2SASimpleObject(4,-18074,"vc2sa/dff/ap_smahangar2_02.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(4,-18075,"vc2sa/dff/ap_smahangar2_03.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(4,-18076,"vc2sa/dff/ap_smahangar2_04.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(4,-18077,"vc2sa/dff/ap_smahangar2_05.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(4,-18078,"vc2sa/dff/ap_smahangar2_06.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(4,-18079,"vc2sa/dff/ap_seaplanfence1.dff","vc2sa/txd/ap_seasplane.txd");
AddVC2SASimpleObject(4,-18080,"vc2sa/dff/apairprtbits08.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(0,-18081,"vc2sa/dff/ap_runsigns5_01.dff","vc2sa/txd/ap_runsigns1.txd");
AddVC2SASimpleObject(4,-18082,"vc2sa/dff/ap_hotelpool.dff","vc2sa/txd/ap_build3.txd");
AddVC2SASimpleObject(4,-18083,"vc2sa/dff/ap_seafences.dff","vc2sa/txd/ap_seasplane.txd");
AddVC2SASimpleObject(0,-18084,"vc2sa/dff/ap_rland08.dff","vc2sa/txd/ap_ground1.txd");
AddVC2SASimpleObject(0,-18085,"vc2sa/dff/ap_roadsect1.dff","vc2sa/txd/ap_roadsect1.txd");
AddVC2SASimpleObject(0,-18086,"vc2sa/dff/ap_rland03.dff","vc2sa/txd/ap_viceairport.txd");
AddVC2SASimpleObject(0,-18087,"vc2sa/dff/ap_rland04.dff","vc2sa/txd/ap_viceairport.txd");
AddVC2SASimpleObject(0,-18088,"vc2sa/dff/ap_rland06.dff","vc2sa/txd/ap_viceairport.txd");
AddVC2SASimpleObject(0,-18089,"vc2sa/dff/ap_rland05.dff","vc2sa/txd/ap_viceairport.txd");
AddVC2SASimpleObject(0,-18090,"vc2sa/dff/ap_rland07.dff","vc2sa/txd/ap_viceairport.txd");
AddVC2SASimpleObject(0,-18091,"vc2sa/dff/ap_rland02.dff","vc2sa/txd/ap_viceairport.txd");
AddVC2SASimpleObject(0,-18092,"vc2sa/dff/ap_rland01.dff","vc2sa/txd/ap_viceairport.txd");
AddVC2SASimpleObject(0,-18093,"vc2sa/dff/ap_roadsect2a.dff","vc2sa/txd/ap_roads.txd");
AddVC2SASimpleObject(4,-18094,"vc2sa/dff/ap_wallfence1.dff","vc2sa/txd/ap_roads.txd");
AddVC2SASimpleObject(4,-18095,"vc2sa/dff/ap_wallfence2.dff","vc2sa/txd/ap_roads.txd");
AddVC2SASimpleObject(4,-18096,"vc2sa/dff/ap_wallfence6.dff","vc2sa/txd/ap_roads.txd");
AddVC2SASimpleObject(4,-18097,"vc2sa/dff/ap_barriergate1.dff","vc2sa/txd/ap_checkpoints.txd");
AddVC2SASimpleObject(4,-18098,"vc2sa/dff/ap_barriergate4.dff","vc2sa/txd/ap_checkpoints.txd");
AddVC2SASimpleObject(4,-18099,"vc2sa/dff/ap_barriergate2.dff","vc2sa/txd/ap_checkpoints.txd");
AddVC2SASimpleObject(4,-18100,"vc2sa/dff/ap_wallfence7.dff","vc2sa/txd/ap_roads.txd");
AddVC2SASimpleObject(0,-18101,"vc2sa/dff/ap_gsecurity1.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18102,"vc2sa/dff/ap_gsecurity2.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18103,"vc2sa/dff/ap_security1.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18104,"vc2sa/dff/ap_security2.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(4,-18105,"vc2sa/dff/ap_stairsout04.dff","vc2sa/txd/ap_build2.txd");
AddVC2SASimpleObject(0,-18106,"vc2sa/dff/ap_pots1_01.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18107,"vc2sa/dff/ap_pots2_01.dff","vc2sa/txd/ap_airstuff1.txd");
AddVC2SASimpleObject(0,-18108,"vc2sa/dff/ap_windowstruts.dff","vc2sa/txd/ap_termwindows.txd");
AddVC2SASimpleObject(0,-18109,"vc2sa/dff/ap_termAintfloor1.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18110,"vc2sa/dff/ap_dockwall1.dff","vc2sa/txd/ap_roadsect1.txd");
AddVC2SASimpleObject(4,-18111,"vc2sa/dff/ap_hangar1_04.dff","vc2sa/txd/airport.txd");
AddVC2SASimpleObject(0,-18112,"vc2sa/dff/ap_terminA_roof1.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18113,"vc2sa/dff/ap_terminAgatesA.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18114,"vc2sa/dff/ap_terminAgrflo1.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18115,"vc2sa/dff/ap_terminAgatesB.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18116,"vc2sa/dff/ap_terminAgrflo2.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18117,"vc2sa/dff/ap_terminA_roof2.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18118,"vc2sa/dff/ap_termAintfloor2.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18119,"vc2sa/dff/ap_terminA2_01.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18120,"vc2sa/dff/ap_termAintfloor2b.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18121,"vc2sa/dff/ap_termAintfloor1b.dff","vc2sa/txd/ap_terminal1.txd");
AddVC2SASimpleObject(0,-18122,"vc2sa/dff/ap_newesca_01.dff","vc2sa/txd/ap_clothes.txd");
AddVC2SASimpleObject(4,-18123,"vc2sa/dff/ap_boxjunct1.dff","vc2sa/txd/ap_roads.txd");
AddVC2SASimpleObject(0,-18124,"vc2sa/dff/ap_roadsect2b.dff","vc2sa/txd/ap_roads.txd");
AddVC2SASimpleObject(4,-18125,"vc2sa/dff/ap_newescaGLAS_01.dff","vc2sa/txd/ap_clothes.txd");
AddVC2SASimpleObject(0,-18126,"vc2sa/dff/ap_newesca_02.dff","vc2sa/txd/ap_clothes.txd");
AddVC2SASimpleObject(4,-18127,"vc2sa/dff/ap_newescaGLAS_02.dff","vc2sa/txd/ap_clothes.txd");
AddVC2SASimpleObject(0,-18128,"vc2sa/dff/ap_steps1_02.dff","vc2sa/txd/airstuff2.txd");
AddVC2SASimpleObject(0,-18129,"vc2sa/dff/ap_steps1_03.dff","vc2sa/txd/airstuff2.txd");
AddVC2SASimpleObject(0,-18130,"vc2sa/dff/ap_steps1_04.dff","vc2sa/txd/airstuff2.txd");
AddVC2SASimpleObject(0,-18131,"vc2sa/dff/ap_steps1_05.dff","vc2sa/txd/airstuff2.txd");
AddVC2SASimpleObject(0,-18132,"vc2sa/dff/ap_steps1_06.dff","vc2sa/txd/airstuff2.txd");
AddVC2SASimpleObject(0,-18133,"vc2sa/dff/ap_steps1_07.dff","vc2sa/txd/airstuff2.txd");
AddVC2SASimpleObject(0,-18134,"vc2sa/dff/ap_steps1_08.dff","vc2sa/txd/airstuff2.txd");
AddVC2SASimpleObject(4,-18135,"vc2sa/dff/ap_termwindows1b.dff","vc2sa/txd/ap_termwindows.txd");
AddVC2SASimpleObject(4,-18136,"vc2sa/dff/ap_treeshot1_02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-18137,"vc2sa/dff/ap_planters1_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-18138,"vc2sa/dff/ap_planters2_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-18139,"vc2sa/dff/ap_treesfw1_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(140,6,22,-18140,"vc2sa/dff/ap_termsign1_dy.dff","vc2sa/txd/ap_termwindows.txd");
AddVC2SASimpleTimed(140,22,6,-18141,"vc2sa/dff/ap_termsign1_nt.dff","vc2sa/txd/ap_termwindows.txd");
AddVC2SASimpleObject(0,-18142,"vc2sa/dff/ap_terminalB1.dff","vc2sa/txd/airporterminal.txd");
AddVC2SASimpleObject(0,-18143,"vc2sa/dff/ap_termbbase1.dff","vc2sa/txd/ap_build1.txd");
AddVC2SASimpleObject(0,-18144,"vc2sa/dff/ap_carparkterm1.dff","vc2sa/txd/apcarparkN.txd");
AddVC2SASimpleObject(4,-18145,"vc2sa/dff/ap_smallradar1_02.dff","vc2sa/txd/nairport.txd");
AddVC2SASimpleObject(0,-18146,"vc2sa/dff/mc_shed1.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18147,"vc2sa/dff/mc_tower_01.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18148,"vc2sa/dff/mc_hangar1.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18149,"vc2sa/dff/mc_largebuild.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18150,"vc2sa/dff/mc_wall.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(4,-18151,"vc2sa/dff/mc_fence1.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(4,-18152,"vc2sa/dff/mc_fence3.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(4,-18153,"vc2sa/dff/mc_fence2.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(4,-18154,"vc2sa/dff/mc_fencshad.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(4,-18155,"vc2sa/dff/ap_smallhangars1_02.dff","vc2sa/txd/nairport.txd");
AddVC2SASimpleObject(0,-18156,"vc2sa/dff/mc_shed04.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18157,"vc2sa/dff/mc_assaultcourse1.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18158,"vc2sa/dff/mc_assaultcourse2.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18159,"vc2sa/dff/mc_dirtjump1.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18160,"vc2sa/dff/ap_rland10.dff","vc2sa/txd/apgroundN.txd");
AddVC2SASimpleObject(0,-18161,"vc2sa/dff/ap_rlandnew9.dff","vc2sa/txd/ap_francisland.txd");
AddVC2SASimpleObject(0,-18162,"vc2sa/dff/mc_ground3.dff","vc2sa/txd/ap_francisland.txd");
AddVC2SASimpleObject(0,-18163,"vc2sa/dff/mc_ground1.dff","vc2sa/txd/ap_francisland.txd");
AddVC2SASimpleObject(0,-18164,"vc2sa/dff/mc_ground5.dff","vc2sa/txd/ap_francisland.txd");
AddVC2SASimpleObject(0,-18165,"vc2sa/dff/ap_roadsect4.dff","vc2sa/txd/aproadsN.txd");
AddVC2SASimpleObject(0,-18166,"vc2sa/dff/ap_roadsect3.dff","vc2sa/txd/aproadsN.txd");
AddVC2SASimpleObject(0,-18167,"vc2sa/dff/ap_roadsect5.dff","vc2sa/txd/aproadsN.txd");
AddVC2SASimpleObject(0,-18168,"vc2sa/dff/mc_ground4.dff","vc2sa/txd/ap_francisland.txd");
AddVC2SASimpleObject(4,-18169,"vc2sa/dff/ap_wallfence4.dff","vc2sa/txd/aproadsN.txd");
AddVC2SASimpleObject(4,-18170,"vc2sa/dff/ap_wallfence3.dff","vc2sa/txd/aproadsN.txd");
AddVC2SASimpleObject(0,-18171,"vc2sa/dff/mc_crashbar1.dff","vc2sa/txd/aproadsN.txd");
AddVC2SASimpleObject(0,-18172,"vc2sa/dff/mc_crashbar2.dff","vc2sa/txd/aproadsN.txd");
AddVC2SASimpleObject(4,-18173,"vc2sa/dff/ap_wallfence5.dff","vc2sa/txd/aproadsN.txd");
AddVC2SASimpleObject(0,-18174,"vc2sa/dff/mc_tower_02.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18175,"vc2sa/dff/mc_tower_03.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18176,"vc2sa/dff/mc_camotent1_01.dff","vc2sa/txd/militcompound3.txd");
AddVC2SASimpleObject(0,-18177,"vc2sa/dff/mc_flags1.dff","vc2sa/txd/militcompound3.txd");
AddVC2SASimpleObject(0,-18178,"vc2sa/dff/mc_flags2.dff","vc2sa/txd/militcompound3.txd");
AddVC2SASimpleObject(0,-18179,"vc2sa/dff/mc_kerb_01.dff","vc2sa/txd/apbitsN.txd");
AddVC2SASimpleObject(0,-18180,"vc2sa/dff/mc_wall2.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18181,"vc2sa/dff/mc_wall3.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18182,"vc2sa/dff/mc_overlights1.dff","vc2sa/txd/aproadsN.txd");
AddVC2SASimpleObject(0,-18183,"vc2sa/dff/mc_overlights2.dff","vc2sa/txd/aproadsN.txd");
AddVC2SASimpleObject(4,-18184,"vc2sa/dff/ap_jumbo_BRIDGE.dff","vc2sa/txd/apJumboN.txd");
AddVC2SASimpleObject(0,-18185,"vc2sa/dff/mc_kerb_02.dff","vc2sa/txd/apbitsN.txd");
AddVC2SASimpleObject(36,-18186,"vc2sa/dff/mc_hangarint1.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18187,"vc2sa/dff/mc_camotent1_04.dff","vc2sa/txd/militcompound3.txd");
AddVC2SASimpleObject(0,-18188,"vc2sa/dff/mc_camotent1_05.dff","vc2sa/txd/militcompound3.txd");
AddVC2SASimpleObject(4,-18189,"vc2sa/dff/ap_hangar1_03.dff","vc2sa/txd/nairport.txd");
AddVC2SASimpleObject(4,-18190,"vc2sa/dff/ap_smallhangars1_03.dff","vc2sa/txd/nairport.txd");
AddVC2SASimpleObject(0,-18191,"vc2sa/dff/ap_billboards2.dff","vc2sa/txd/ap_billboard.txd");
AddVC2SASimpleObject(0,-18192,"vc2sa/dff/ap_billboards1.dff","vc2sa/txd/ap_billboard.txd");
AddVC2SASimpleObject(0,-18193,"vc2sa/dff/ap_billboards3.dff","vc2sa/txd/ap_billboard.txd");
AddVC2SASimpleObject(0,-18194,"vc2sa/dff/ap_billboards4.dff","vc2sa/txd/ap_billboard.txd");
AddVC2SASimpleObject(0,-18195,"vc2sa/dff/ap_billboards5.dff","vc2sa/txd/ap_billboard.txd");
AddVC2SASimpleObject(4,-18196,"vc2sa/dff/ap_barriergate3.dff","vc2sa/txd/apchecpointN.txd");
AddVC2SASimpleObject(4,-18197,"vc2sa/dff/ap_stairsout1.dff","vc2sa/txd/nairport.txd");
AddVC2SASimpleObject(4,-18198,"vc2sa/dff/ap_stairsout02.dff","vc2sa/txd/nairport.txd");
AddVC2SASimpleObject(4,-18199,"vc2sa/dff/ap_stairsout03.dff","vc2sa/txd/nairport.txd");
AddVC2SASimpleObject(0,-18200,"vc2sa/dff/mc_ground2.dff","vc2sa/txd/ap_francisland.txd");
AddVC2SASimpleObject(4,-18201,"vc2sa/dff/mc_barrackshad.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18202,"vc2sa/dff/ap_roadsect3b.dff","vc2sa/txd/aproadsN.txd");
AddVC2SASimpleObject(0,-18203,"vc2sa/dff/ap_3dbillb.dff","vc2sa/txd/airsignn.txd");
AddVC2SASimpleObject(0,-18204,"vc2sa/dff/mb_ammobox1.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18205,"vc2sa/dff/mb_ammobox2.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18206,"vc2sa/dff/mb_ammobox3.dff","vc2sa/txd/mcompounda1.txd");
AddVC2SASimpleObject(0,-18207,"vc2sa/dff/ap_stepsn1_01.dff","vc2sa/txd/airstuff2.txd");
AddVC2SASimpleObject(0,-18208,"vc2sa/dff/ap_stepsn1_02.dff","vc2sa/txd/airstuff2.txd");
AddVC2SASimpleObject(4,-18209,"vc2sa/dff/ap_carbush2_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-18210,"vc2sa/dff/mc_treesfw1_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-18211,"vc2sa/dff/mc_treesfw2_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-18212,"vc2sa/dff/mc_treesfw3_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-18213,"vc2sa/dff/LODnetopa0.dff","vc2sa/txd/lod_docks.txd");
AddVC2SASimpleObject(0,-18214,"vc2sa/dff/dk_dockroads01.dff","vc2sa/txd/dockroads.txd");
AddVC2SASimpleObject(16,-18215,"vc2sa/dff/dk_dockroads02.dff","vc2sa/txd/dockroads.txd");
AddVC2SASimpleObject(0,-18216,"vc2sa/dff/dk_dockroads03.dff","vc2sa/txd/dockroads.txd");
AddVC2SASimpleObject(0,-18217,"vc2sa/dff/dk_dockroads04.dff","vc2sa/txd/dockroads.txd");
AddVC2SASimpleObject(0,-18218,"vc2sa/dff/dk_dockroads05.dff","vc2sa/txd/dockroads.txd");
AddVC2SASimpleObject(0,-18219,"vc2sa/dff/dk_dockroads06.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(128,-18220,"vc2sa/dff/docks10.dff","vc2sa/txd/docksVC.txd");
AddVC2SASimpleObject(0,-18221,"vc2sa/dff/docks21.dff","vc2sa/txd/dockgrnd.txd");
AddVC2SASimpleObject(0,-18222,"vc2sa/dff/docks29.dff","vc2sa/txd/dockgrnd.txd");
AddVC2SASimpleObject(4,-18223,"vc2sa/dff/docks30.dff","vc2sa/txd/docfactoriesVC.txd");
AddVC2SASimpleObject(0,-18224,"vc2sa/dff/docks31.dff","vc2sa/txd/docfactoriesVC.txd");
AddVC2SASimpleObject(128,-18225,"vc2sa/dff/docks37.dff","vc2sa/txd/docfactoriesVC.txd");
AddVC2SASimpleObject(128,-18226,"vc2sa/dff/docks40.dff","vc2sa/txd/docfactoriesVC.txd");
AddVC2SASimpleObject(128,-18227,"vc2sa/dff/docks42.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(128,-18228,"vc2sa/dff/docks43.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(0,-18229,"vc2sa/dff/dk_dockroads08.dff","vc2sa/txd/dockroads.txd");
AddVC2SASimpleObject(128,-18230,"vc2sa/dff/docks46.dff","vc2sa/txd/dk_houses.txd");
AddVC2SASimpleObject(128,-18231,"vc2sa/dff/docks47.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(128,-18232,"vc2sa/dff/docks48.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(128,-18233,"vc2sa/dff/docks49.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(128,-18234,"vc2sa/dff/docks50.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(128,-18235,"vc2sa/dff/docks51.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(128,-18236,"vc2sa/dff/docks52.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(128,-18237,"vc2sa/dff/docks53.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(0,-18238,"vc2sa/dff/docks85.dff","vc2sa/txd/dockgrnd.txd");
AddVC2SASimpleObject(128,-18239,"vc2sa/dff/docksprops04.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(132,-18240,"vc2sa/dff/docksprops10.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(128,-18241,"vc2sa/dff/doc_shedbig30.dff","vc2sa/txd/docksb.txd");
AddVC2SASimpleObject(132,-18242,"vc2sa/dff/boatcranelg0.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(132,-18243,"vc2sa/dff/crgoshp010.dff","vc2sa/txd/dock_ships.txd");
AddVC2SASimpleObject(132,-18244,"vc2sa/dff/cranebasea0.dff","vc2sa/txd/cranes1.txd");
AddVC2SASimpleObject(128,-18245,"vc2sa/dff/doc_dockwareold.dff","vc2sa/txd/docfactoriesVC.txd");
AddVC2SASimpleObject(2097280,-18246,"vc2sa/dff/dk_waretank.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(132,-18247,"vc2sa/dff/dockcranescale0.dff","vc2sa/txd/doccrane.txd");
AddVC2SASimpleObject(132,-18248,"vc2sa/dff/doc_crane_cab0.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(196,-18249,"vc2sa/dff/boatcranesm0.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(132,-18250,"vc2sa/dff/dockcranescale01.dff","vc2sa/txd/doccrane.txd");
AddVC2SASimpleObject(132,-18251,"vc2sa/dff/doc_crane_cab01.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(132,-18252,"vc2sa/dff/doc_crane_cab02.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(132,-18253,"vc2sa/dff/doc_crane_cab03.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(132,-18254,"vc2sa/dff/doc_crane_cab04.dff","vc2sa/txd/docfactoriesVC.txd");
AddVC2SASimpleObject(132,-18255,"vc2sa/dff/doc_craneeggs04.dff","vc2sa/txd/doccrane.txd");
AddVC2SASimpleObject(128,-18256,"vc2sa/dff/dkshipment01.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(128,-18257,"vc2sa/dff/dockfuel02.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(132,-18258,"vc2sa/dff/dockfuel07.dff","vc2sa/txd/docfactoriesVC.txd");
AddVC2SASimpleObject(128,-18259,"vc2sa/dff/portcabGAZ06.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(132,-18260,"vc2sa/dff/dk_cargoshp03.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(132,-18261,"vc2sa/dff/dk_cargoshp04.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(132,-18262,"vc2sa/dff/dk_cargoshp05.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18263,"vc2sa/dff/dk_cargoshp10.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18264,"vc2sa/dff/dk_cargoshp12.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18265,"vc2sa/dff/dk_cargoshp24.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18266,"vc2sa/dff/dk_cargoshp25.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(132,-18267,"vc2sa/dff/dk_cargoshp28.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18268,"vc2sa/dff/dk_cargoshp31.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18269,"vc2sa/dff/dk_cargoshp32.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18270,"vc2sa/dff/dk_cargoshp35.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18271,"vc2sa/dff/dk_cargoshp40.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(132,-18272,"vc2sa/dff/dk_cargoshp41.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18273,"vc2sa/dff/dk_cargoshp47.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18274,"vc2sa/dff/dk_cargoshp50.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18275,"vc2sa/dff/dk_cargoshp51.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(132,-18276,"vc2sa/dff/dk_cargoshp53.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18277,"vc2sa/dff/dk_cargoshp54.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18278,"vc2sa/dff/dk_cargoshp64.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18279,"vc2sa/dff/dk_cargoshp66.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18280,"vc2sa/dff/dk_cargoshp70.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18281,"vc2sa/dff/dk_cargoshp71.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18282,"vc2sa/dff/dk_cargoshp72.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18283,"vc2sa/dff/dk_cargoshp73.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18284,"vc2sa/dff/dk_cargoshp76.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(132,-18285,"vc2sa/dff/shipstairs.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18286,"vc2sa/dff/dk_cargoshp95.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18287,"vc2sa/dff/dk_cargoshp100.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(132,-18288,"vc2sa/dff/dockfence.dff","vc2sa/txd/dockfence.txd");
AddVC2SASimpleObject(128,-18289,"vc2sa/dff/dock_camjones.dff","vc2sa/txd/dk_safecrack.txd");
AddVC2SASimpleObject(0,-18290,"vc2sa/dff/dock_grassarea.dff","vc2sa/txd/dockgrnd.txd");
AddVC2SASimpleObject(132,-18291,"vc2sa/dff/docksware01.dff","vc2sa/txd/docksVC.txd");
AddVC2SASimpleObject(128,-18292,"vc2sa/dff/dk_gatebar01.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(132,-18293,"vc2sa/dff/dk_gatebox01.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(132,-18294,"vc2sa/dff/dockgate01.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(132,-18295,"vc2sa/dff/dockgate02.dff","vc2sa/txd/dockfence.txd");
AddVC2SASimpleObject(128,-18296,"vc2sa/dff/docks92.dff","vc2sa/txd/docksVC.txd");
AddVC2SASimpleObject(128,-18297,"vc2sa/dff/docks93.dff","vc2sa/txd/docksVC.txd");
AddVC2SASimpleObject(128,-18298,"vc2sa/dff/docksprops11.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(128,-18299,"vc2sa/dff/docks95.dff","vc2sa/txd/docksVC.txd");
AddVC2SASimpleObject(128,-18300,"vc2sa/dff/dk_gatebar02.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(128,-18301,"vc2sa/dff/docks96.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(128,-18302,"vc2sa/dff/dk_bridgesupp01.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(128,-18303,"vc2sa/dff/dk_bridgesupp03.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(0,-18304,"vc2sa/dff/dk_dockbridge.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(0,-18305,"vc2sa/dff/dk_rail01.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(128,-18306,"vc2sa/dff/dkcargohull2.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18307,"vc2sa/dff/dk_bridgesupp04.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(128,-18308,"vc2sa/dff/dkshipment03.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(128,-18309,"vc2sa/dff/dkshipment05.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(128,-18310,"vc2sa/dff/b_hse_ext.dff","vc2sa/txd/boathouse.txd");
AddVC2SASimpleObject(128,-18311,"vc2sa/dff/b_hse_pier.dff","vc2sa/txd/boathouse.txd");
AddVC2SASimpleObject(128,-18312,"vc2sa/dff/boat_kb1.dff","vc2sa/txd/boathouse.txd");
AddVC2SASimpleObject(160,-18313,"vc2sa/dff/boat_kb2.dff","vc2sa/txd/boathouse.txd");
AddVC2SASimpleObject(128,-18314,"vc2sa/dff/b_hse_interior.dff","vc2sa/txd/boathouse.txd");
AddVC2SASimpleObject(128,-18315,"vc2sa/dff/docks28.dff","vc2sa/txd/docksVC.txd");
AddVC2SASimpleObject(0,-18316,"vc2sa/dff/docks32.dff","vc2sa/txd/docfactoriesVC.txd");
AddVC2SASimpleObject(0,-18317,"vc2sa/dff/dk_rail02.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(0,-18318,"vc2sa/dff/dk_rail03.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(128,-18319,"vc2sa/dff/dk_cargoshp65.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18320,"vc2sa/dff/dk_cargoshp01.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18321,"vc2sa/dff/dk_cargoshp68.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(132,-18322,"vc2sa/dff/dock_props01.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(4,-18323,"vc2sa/dff/dkglue3.dff","vc2sa/txd/dkglue.txd");
AddVC2SASimpleObject(36,-18324,"vc2sa/dff/dkfirtpass2.dff","vc2sa/txd/dkglue.txd");
AddVC2SASimpleObject(132,-18325,"vc2sa/dff/rustship_structure0.dff","vc2sa/txd/dock_ships.txd");
AddVC2SASimpleObject(128,-18326,"vc2sa/dff/docksprops12.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(128,-18327,"vc2sa/dff/docksprops13.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(132,-18328,"vc2sa/dff/dk_shipstair.dff","vc2sa/txd/dkcargoshp.txd", 1);
AddVC2SASimpleObject(128,-18329,"vc2sa/dff/docksprops14.dff","vc2sa/txd/dk_midbuilds.txd");
AddVC2SASimpleObject(0,-18330,"vc2sa/dff/dk_rail04.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(0,-18331,"vc2sa/dff/dk_rail05.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(0,-18332,"vc2sa/dff/dk_rail06.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(0,-18333,"vc2sa/dff/dk_rail07.dff","vc2sa/txd/dock_bridge.txd");
AddVC2SASimpleObject(128,-18334,"vc2sa/dff/dk_camjonesdoor.dff","vc2sa/txd/dk_safecrack.txd");
AddVC2SASimpleObject(128,-18335,"vc2sa/dff/dk_paynspray.dff","vc2sa/txd/docksVC.txd");
AddVC2SASimpleObject(132,-18336,"vc2sa/dff/b_hse_pierfence.dff","vc2sa/txd/dockfence.txd");
AddVC2SASimpleObject(132,-18337,"vc2sa/dff/docksprops15.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(0,-18338,"vc2sa/dff/docks61.dff","vc2sa/txd/dockgrnd.txd");
AddVC2SASimpleObject(0,-18339,"vc2sa/dff/docks60.dff","vc2sa/txd/dockgrnd.txd");
AddVC2SASimpleObject(0,-18340,"vc2sa/dff/docks62.dff","vc2sa/txd/dockgrnd.txd");
AddVC2SASimpleObject(2048,-18341,"vc2sa/dff/dk_bombdoor.dff","vc2sa/txd/docksb.txd");
AddVC2SASimpleObject(128,-18342,"vc2sa/dff/dock_props02.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(128,-18343,"vc2sa/dff/dkcargohull2b.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18344,"vc2sa/dff/dkcargohull2c.dff","vc2sa/txd/dkcargoshp.txd");
AddVC2SASimpleObject(128,-18345,"vc2sa/dff/dk_rdsignsn.dff","vc2sa/txd/dockroads.txd");
AddVC2SASimpleObject(128,-18346,"vc2sa/dff/dk_rdsignsbr.dff","vc2sa/txd/dockroads.txd");
AddVC2SASimpleObject(4,-18347,"vc2sa/dff/dockgrass.dff","vc2sa/txd/dockgrass.txd");
AddVC2SASimpleTimed(132,6,21,-18348,"vc2sa/dff/b_hse_interiorrays.dff","vc2sa/txd/boathouse.txd");
AddVC2SASimpleObject(2048,-18349,"vc2sa/dff/dk_paynspraydoor.dff","vc2sa/txd/docksVC.txd");
AddVC2SASimpleObject(2048,-18350,"vc2sa/dff/dk_waretankdoor1.dff","vc2sa/txd/crateVC.txd");
AddVC2SASimpleObject(128,-18351,"vc2sa/dff/miamiland037.dff","vc2sa/txd/littlhab1.txd");
AddVC2SASimpleObject(0,-18352,"vc2sa/dff/lhroadc4.dff","vc2sa/txd/lh_roads.txd");
AddVC2SASimpleObject(0,-18353,"vc2sa/dff/miamiland039.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-18354,"vc2sa/dff/littlehacoast02.dff","vc2sa/txd/lithablk4.txd");
AddVC2SASimpleObject(128,-18355,"vc2sa/dff/lh_buildingg1.dff","vc2sa/txd/lithablk9.txd");
AddVC2SASimpleObject(128,-18356,"vc2sa/dff/miamiland170.dff","vc2sa/txd/littlehab2.txd");
AddVC2SASimpleObject(128,-18357,"vc2sa/dff/miamiland171.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18358,"vc2sa/dff/miamiland172.dff","vc2sa/txd/litthabg1.txd");
AddVC2SASimpleObject(128,-18359,"vc2sa/dff/miamiland173.dff","vc2sa/txd/litthabg1.txd");
AddVC2SASimpleObject(128,-18360,"vc2sa/dff/miamiland174.dff","vc2sa/txd/littlhablk7.txd");
AddVC2SASimpleObject(0,-18361,"vc2sa/dff/miamiland175.dff","vc2sa/txd/litthablk6.txd");
AddVC2SASimpleObject(0,-18362,"vc2sa/dff/miamiland176.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-18363,"vc2sa/dff/miamiland177.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-18364,"vc2sa/dff/miamiland178.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-18365,"vc2sa/dff/miamiland179.dff","vc2sa/txd/lithablk12.txd");
AddVC2SASimpleObject(128,-18366,"vc2sa/dff/miamiland180.dff","vc2sa/txd/lithablk12.txd");
AddVC2SASimpleObject(128,-18367,"vc2sa/dff/havanahouse01.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18368,"vc2sa/dff/lithavabit01.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18369,"vc2sa/dff/havanahouse02.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18370,"vc2sa/dff/havanahouse03.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18371,"vc2sa/dff/havanahouse04.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18372,"vc2sa/dff/lithavabit03.dff","vc2sa/txd/lhgardens.txd");
AddVC2SASimpleObject(128,-18373,"vc2sa/dff/havanahouse06.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(4,-18374,"vc2sa/dff/lithavabit04.dff","vc2sa/txd/lhgardens.txd");
AddVC2SASimpleObject(128,-18375,"vc2sa/dff/lithavabit05.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18376,"vc2sa/dff/lithavabit06.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18377,"vc2sa/dff/lithavabit07.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18378,"vc2sa/dff/lithavabit08.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18379,"vc2sa/dff/havanahouse07.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18380,"vc2sa/dff/havbit01.dff","vc2sa/txd/lhgardens.txd");
AddVC2SASimpleObject(128,-18381,"vc2sa/dff/fuckedcars03.dff","vc2sa/txd/lhfuckercars.txd");
AddVC2SASimpleObject(128,-18382,"vc2sa/dff/fuckedcars01.dff","vc2sa/txd/lhfuckercars.txd");
AddVC2SASimpleObject(128,-18383,"vc2sa/dff/fuckedcars04.dff","vc2sa/txd/lhfuckercars.txd");
AddVC2SASimpleObject(128,-18384,"vc2sa/dff/fuckedcars02.dff","vc2sa/txd/lhfuckercars.txd");
AddVC2SASimpleObject(128,-18385,"vc2sa/dff/car_fucko03.dff","vc2sa/txd/lhfuckercars.txd");
AddVC2SASimpleObject(128,-18386,"vc2sa/dff/havanahouse09.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18387,"vc2sa/dff/lithavabit09.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18388,"vc2sa/dff/lithavabit10.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18389,"vc2sa/dff/lithavabit11.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18390,"vc2sa/dff/havbit02.dff","vc2sa/txd/lhgardens.txd");
AddVC2SASimpleObject(128,-18391,"vc2sa/dff/havbit03.dff","vc2sa/txd/littlehab2.txd");
AddVC2SASimpleObject(132,-18392,"vc2sa/dff/deli_exterior_front.dff","vc2sa/txd/deliext.txd");
AddVC2SASimpleObject(128,-18393,"vc2sa/dff/deli_interior.dff","vc2sa/txd/deliint.txd");
AddVC2SASimpleObject(128,-18394,"vc2sa/dff/drycleaners.dff","vc2sa/txd/drycleaners.txd");
AddVC2SASimpleObject(164,-18395,"vc2sa/dff/lh_icedoor.dff","vc2sa/txd/lh_taxi.txd");
AddVC2SASimpleObject(160,-18396,"vc2sa/dff/lh_icecream02.dff","vc2sa/txd/lh_taxi.txd");
AddVC2SASimpleObject(128,-18397,"vc2sa/dff/lh_icecream01.dff","vc2sa/txd/lh_taxi.txd");
AddVC2SASimpleObject(132,-18398,"vc2sa/dff/havgangshop.dff","vc2sa/txd/lhgangshop.txd");
AddVC2SASimpleObject(128,-18399,"vc2sa/dff/littleha_police.dff","vc2sa/txd/hav_police.txd");
AddVC2SASimpleObject(132,-18400,"vc2sa/dff/glue_straight01.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(132,-18401,"vc2sa/dff/glue_corner01.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(0,-18402,"vc2sa/dff/littlehabroad.dff","vc2sa/txd/lh_roads.txd");
AddVC2SASimpleObject(0,-18403,"vc2sa/dff/lithavroad3.dff","vc2sa/txd/lh_roads.txd");
AddVC2SASimpleObject(0,-18404,"vc2sa/dff/littlharoadgg2.dff","vc2sa/txd/lh_roads.txd");
AddVC2SASimpleObject(0,-18405,"vc2sa/dff/lhwallbit.dff","vc2sa/txd/hav_health.txd");
AddVC2SASimpleObject(128,-18406,"vc2sa/dff/hospital.dff","vc2sa/txd/hahospital.txd");
AddVC2SASimpleObject(128,-18407,"vc2sa/dff/lhcoastsky1.dff","vc2sa/txd/habuildblok.txd");
AddVC2SASimpleObject(128,-18408,"vc2sa/dff/havhotel.dff","vc2sa/txd/lhhotelbg.txd");
AddVC2SASimpleObject(128,-18409,"vc2sa/dff/havbuild.dff","vc2sa/txd/lithahotel.txd");
AddVC2SASimpleObject(128,-18410,"vc2sa/dff/lithahousebk2.dff","vc2sa/txd/lithablk22.txd");
AddVC2SASimpleObject(160,-18411,"vc2sa/dff/cof_intfloor.dff","vc2sa/txd/cofshopint.txd");
AddVC2SASimpleObject(128,-18412,"vc2sa/dff/cofsho_ext1.dff","vc2sa/txd/coffeshpext.txd");
AddVC2SASimpleObject(160,-18413,"vc2sa/dff/cof_seat.dff","vc2sa/txd/cofshopintdet.txd");
AddVC2SASimpleObject(164,-18414,"vc2sa/dff/cof_extwindw.dff","vc2sa/txd/cofshopwind.txd");
AddVC2SASimpleObject(160,-18415,"vc2sa/dff/cof_shpdetail1.dff","vc2sa/txd/cofshopintdet.txd");
AddVC2SASimpleObject(160,-18416,"vc2sa/dff/cof_bardetail.dff","vc2sa/txd/cofshopintdet.txd");
AddVC2SASimpleObject(160,-18417,"vc2sa/dff/cof_xtremedet.dff","vc2sa/txd/cofshopintdet.txd");
AddVC2SASimpleObject(164,-18418,"vc2sa/dff/cof_shad1.dff","vc2sa/txd/cofshad.txd");
AddVC2SASimpleObject(228,-18419,"vc2sa/dff/cof_shad2.dff","vc2sa/txd/cofshad.txd");
AddVC2SASimpleObject(164,-18420,"vc2sa/dff/cof_shad4.dff","vc2sa/txd/cofshad.txd");
AddVC2SASimpleObject(0,-18421,"vc2sa/dff/lithawaste1.dff","vc2sa/txd/lithawaste.txd");
AddVC2SASimpleObject(0,-18422,"vc2sa/dff/lithawaste2.dff","vc2sa/txd/lithawaste.txd");
AddVC2SASimpleObject(132,-18423,"vc2sa/dff/glue_straight02.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(4,-18424,"vc2sa/dff/lhbasket.dff","vc2sa/txd/havbasketball.txd");
AddVC2SASimpleObject(128,-18425,"vc2sa/dff/fuckedcars05.dff","vc2sa/txd/lhfuckercars.txd");
AddVC2SASimpleObject(128,-18426,"vc2sa/dff/fuckedcars06.dff","vc2sa/txd/lhfuckercars.txd");
AddVC2SASimpleObject(128,-18427,"vc2sa/dff/lhbuild034.dff","vc2sa/txd/lhbuild3.txd");
AddVC2SASimpleObject(0,-18428,"vc2sa/dff/lhgrnda1.dff","vc2sa/txd/lithawaste.txd");
AddVC2SASimpleObject(132,-18429,"vc2sa/dff/lhroofst01.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(132,-18430,"vc2sa/dff/lhparkline2.dff","vc2sa/txd/lhparkline.txd");
AddVC2SASimpleObject(0,-18431,"vc2sa/dff/lihawasteb2.dff","vc2sa/txd/lithawaste.txd");
AddVC2SASimpleObject(0,-18432,"vc2sa/dff/lhavroad1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-18433,"vc2sa/dff/lhavroad2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-18434,"vc2sa/dff/lhcoastsky2.dff","vc2sa/txd/habuildblok.txd");
AddVC2SASimpleObject(128,-18435,"vc2sa/dff/lhroofst02.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(128,-18436,"vc2sa/dff/lhroofst03.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(128,-18437,"vc2sa/dff/lhroofst04.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(128,-18438,"vc2sa/dff/lhroofst07.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(128,-18439,"vc2sa/dff/lhroofst08.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(128,-18440,"vc2sa/dff/lhroofst09.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(128,-18441,"vc2sa/dff/lhroofst10.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(128,-18442,"vc2sa/dff/lhroofst11.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(128,-18443,"vc2sa/dff/lhroofst12.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(0,-18444,"vc2sa/dff/lhroadc1.dff","vc2sa/txd/lh_roads.txd");
AddVC2SASimpleObject(0,-18445,"vc2sa/dff/lhroadc2.dff","vc2sa/txd/lh_roads.txd");
AddVC2SASimpleObject(0,-18446,"vc2sa/dff/lhroadc3.dff","vc2sa/txd/lh_roads.txd");
AddVC2SASimpleObject(128,-18447,"vc2sa/dff/lh_buildingw1.dff","vc2sa/txd/littlhab1.txd");
AddVC2SASimpleObject(128,-18448,"vc2sa/dff/lh_buildingg2.dff","vc2sa/txd/lithablk9.txd");
AddVC2SASimpleObject(128,-18449,"vc2sa/dff/lh_buildingg3.dff","vc2sa/txd/lithablk9.txd");
AddVC2SASimpleObject(164,-18450,"vc2sa/dff/lhdirtpass1.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(132,-18451,"vc2sa/dff/lh2glue.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(196,-18452,"vc2sa/dff/grasspatch.dff","vc2sa/txd/grasspatch.txd");
AddVC2SASimpleObject(132,-18453,"vc2sa/dff/lhglue3.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(164,-18454,"vc2sa/dff/lhdirtpassz.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(164,-18455,"vc2sa/dff/lhddirt.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(196,-18456,"vc2sa/dff/lhgrasspatchg.dff","vc2sa/txd/grasspatch.txd");
AddVC2SASimpleObject(128,-18457,"vc2sa/dff/havanahouse10.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18458,"vc2sa/dff/lithavabit12.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(128,-18459,"vc2sa/dff/havanahouse11.dff","vc2sa/txd/lithahouse.txd");
AddVC2SASimpleObject(132,-18460,"vc2sa/dff/lh2glue01.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(164,-18461,"vc2sa/dff/lhdirtpassax1.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(132,-18462,"vc2sa/dff/lhglue01.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(128,-18463,"vc2sa/dff/lhroofst14.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(128,-18464,"vc2sa/dff/lhroofst16.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(128,-18465,"vc2sa/dff/BillBd04.dff","vc2sa/txd/littlhab1.txd");
AddVC2SASimpleObject(0,-18466,"vc2sa/dff/hav_car_show_out.dff","vc2sa/txd/air_carshow.txd");
AddVC2SASimpleObject(2048,-18467,"vc2sa/dff/hav_garagedoor1.dff","vc2sa/txd/lh_garagebits.txd");
AddVC2SASimpleObject(160,-18468,"vc2sa/dff/hav_car_show_int.dff","vc2sa/txd/hai_carshowint.txd");
AddVC2SASimpleObject(128,-18469,"vc2sa/dff/hav_car_show_out2.dff","vc2sa/txd/lh_garagebits.txd");
AddVC2SASimpleObject(128,-18470,"vc2sa/dff/lhbillboard05xx.dff","vc2sa/txd/lhbillbrd.txd");
AddVC2SASimpleObject(2048,-18471,"vc2sa/dff/lh_showdoor1.dff","vc2sa/txd/lh_garagebits.txd");
AddVC2SASimpleObject(2048,-18472,"vc2sa/dff/lh_showdoor03.dff","vc2sa/txd/lh_garagebits.txd");
AddVC2SASimpleObject(132,-18473,"vc2sa/dff/carshowflags.dff","vc2sa/txd/air_carshow.txd");
AddVC2SASimpleObject(2048,-18474,"vc2sa/dff/hav_garagedoor02.dff","vc2sa/txd/lh_garagebits.txd");
AddVC2SASimpleObject(2048,-18475,"vc2sa/dff/hav_garagedoor03.dff","vc2sa/txd/lh_garagebits.txd");
AddVC2SASimpleObject(2048,-18476,"vc2sa/dff/hav_garagedoor04.dff","vc2sa/txd/lh_garagebits.txd");
AddVC2SASimpleObject(4,-18477,"vc2sa/dff/lh_carshow_windows.dff","vc2sa/txd/hai_carshowint.txd");
AddVC2SASimpleObject(132,-18478,"vc2sa/dff/lh_groundstains.dff","vc2sa/txd/lh_garagebits.txd");
AddVC2SASimpleObject(2097156,-18479,"vc2sa/dff/lha_carfence.dff","vc2sa/txd/air_carshow.txd");
AddVC2SASimpleObject(128,-18480,"vc2sa/dff/lhroofstuffg.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(128,-18481,"vc2sa/dff/lhbacknbit.dff","vc2sa/txd/litthablk6.txd");
AddVC2SASimpleObject(128,-18482,"vc2sa/dff/vrates.dff","vc2sa/txd/lh_taxi.txd");
AddVC2SASimpleObject(128,-18483,"vc2sa/dff/lhsbackbit.dff","vc2sa/txd/lh_taxi.txd");
AddVC2SASimpleObject(132,-18484,"vc2sa/dff/lhroofst17.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(132,-18485,"vc2sa/dff/lhroofst18.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(132,-18486,"vc2sa/dff/lhsteps3.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(0,-18487,"vc2sa/dff/lhcargo.dff","vc2sa/txd/lhalleysect.txd");
AddVC2SASimpleObject(132,-18488,"vc2sa/dff/lhstairs7.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(132,-18489,"vc2sa/dff/lhdirt2s.dff","vc2sa/txd/lhglue.txd");
AddVC2SASimpleObject(0,-18490,"vc2sa/dff/lhblbrd8.dff","vc2sa/txd/lhblbrd8.txd");
AddVC2SASimpleObject(4,-18491,"vc2sa/dff/lhblbrd2.dff","vc2sa/txd/lhblbrd2.txd");
AddVC2SASimpleObject(4,-18492,"vc2sa/dff/lhblbrd1.dff","vc2sa/txd/bilbrd1.txd");
AddVC2SASimpleObject(4,-18493,"vc2sa/dff/lhblbrd3.dff","vc2sa/txd/lhblbrd3.txd");
AddVC2SASimpleObject(2048,-18494,"vc2sa/dff/lhtankdoor.dff","vc2sa/txd/lithablk9.txd");
AddVC2SASimpleObject(128,-18495,"vc2sa/dff/lhroofwee.dff","vc2sa/txd/lhrooft.txd");
AddVC2SASimpleObject(0,-18496,"vc2sa/dff/lhjetty.dff","vc2sa/txd/lhjetty.txd");
AddVC2SASimpleObject(0,-18497,"vc2sa/dff/lharoadab.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-18498,"vc2sa/dff/lh_racemap.dff","vc2sa/txd/lh_racemap.txd");
AddVC2SASimpleObject(128,-18499,"vc2sa/dff/lhbuild1b.dff","vc2sa/txd/littlhablk7.txd");
AddVC2SASimpleObject(0,-18500,"vc2sa/dff/miamiland041.dff","vc2sa/txd/lh_roads.txd");
AddVC2SASimpleObject(0,-18501,"vc2sa/dff/havbackbit.dff","vc2sa/txd/littlehab2.txd");
AddVC2SASimpleObject(4,-18502,"vc2sa/dff/labiggrass.dff","vc2sa/txd/sharedbiggrass.txd");
AddVC2SASimpleObject(4,-18503,"vc2sa/dff/labiggrass01.dff","vc2sa/txd/sharedbiggrass.txd");
AddVC2SASimpleObject(4,-18504,"vc2sa/dff/labiggrass02.dff","vc2sa/txd/sharedbiggrass.txd");
AddVC2SASimpleObject(128,-18505,"vc2sa/dff/signagelh.dff","vc2sa/txd/lhroadsign.txd");
AddVC2SASimpleObject(128,-18506,"vc2sa/dff/lhroofst19.dff","vc2sa/txd/lhrooft2.txd");
AddVC2SASimpleObject(0,-18507,"vc2sa/dff/cofbarbothint.dff","vc2sa/txd/cofintout.txd");
AddVC2SASimpleObject(132,-18508,"vc2sa/dff/littleha_hardwareb.dff","vc2sa/txd/wa_tool2.txd");
AddVC2SASimpleObject(132,-18509,"vc2sa/dff/veged02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-18510,"vc2sa/dff/veged01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-18511,"vc2sa/dff/veged.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-18512,"vc2sa/dff/vegetationb03.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-18513,"vc2sa/dff/lhavnew_bush.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-18514,"vc2sa/dff/vegetationb.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-18515,"vc2sa/dff/vegeha1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-18516,"vc2sa/dff/littleha_hardware.dff","vc2sa/txd/wa_tool2.txd");
AddVC2SASimpleObject(0,-18517,"vc2sa/dff/road_downtown08.dff","vc2sa/txd/dts_roads.txd");
AddVC2SASimpleObject(0,-18518,"vc2sa/dff/road_downtown07.dff","vc2sa/txd/dts_roads.txd");
AddVC2SASimpleObject(0,-18519,"vc2sa/dff/road_downtown06.dff","vc2sa/txd/dts_roads.txd");
AddVC2SASimpleObject(0,-18520,"vc2sa/dff/road_downtown09.dff","vc2sa/txd/dts_roads.txd");
AddVC2SASimpleObject(0,-18521,"vc2sa/dff/doontoon10.dff","vc2sa/txd/dt_sheraton.txd");
AddVC2SASimpleObject(0,-18522,"vc2sa/dff/doontoon13.dff","vc2sa/txd/dts_shops_new1.txd");
AddVC2SASimpleObject(0,-18523,"vc2sa/dff/doontoon14.dff","vc2sa/txd/dt_firestation2.txd");
AddVC2SASimpleObject(0,-18524,"vc2sa/dff/doontoon40.dff","vc2sa/txd/dts_copshop.txd");
AddVC2SASimpleObject(128,-18525,"vc2sa/dff/doontoon41.dff","vc2sa/txd/dt_firestation.txd");
AddVC2SASimpleObject(128,-18526,"vc2sa/dff/doontoon44.dff","vc2sa/txd/dt_firestation.txd");
AddVC2SASimpleObject(0,-18527,"vc2sa/dff/doontoon45.dff","vc2sa/txd/dts_copshop.txd");
AddVC2SASimpleObject(0,-18528,"vc2sa/dff/doontoon72.dff","vc2sa/txd/dts_grassbits.txd");
AddVC2SASimpleObject(0,-18529,"vc2sa/dff/doontoon73.dff","vc2sa/txd/dts_grassbits.txd");
AddVC2SASimpleObject(0,-18530,"vc2sa/dff/doontoon_top05.dff","vc2sa/txd/dt_sheraton.txd");
AddVC2SASimpleObject(0,-18531,"vc2sa/dff/doontoon_top01.dff","vc2sa/txd/dt_firestation.txd");
AddVC2SASimpleObject(0,-18532,"vc2sa/dff/dwnmiamilanda.dff","vc2sa/txd/dts_bikebar_ext.txd");
AddVC2SASimpleObject(0,-18533,"vc2sa/dff/dowbikershop.dff","vc2sa/txd/dts_shops1.txd");
AddVC2SASimpleObject(0,-18534,"vc2sa/dff/dow_pizzaplacedt.dff","vc2sa/txd/dts_shops.txd");
AddVC2SASimpleObject(0,-18535,"vc2sa/dff/recsho_recordshop1.dff","vc2sa/txd/dt_newtest1.txd");
AddVC2SASimpleObject(4,-18536,"vc2sa/dff/gluetest19.dff","vc2sa/txd/dt_firestation.txd");
AddVC2SASimpleObject(4,-18537,"vc2sa/dff/dt_scabby_fence01.dff","vc2sa/txd/dt_firestation.txd");
AddVC2SASimpleObject(4,-18538,"vc2sa/dff/dt_scabby_fence03.dff","vc2sa/txd/dt_firestation.txd");
AddVC2SASimpleObject(4,-18539,"vc2sa/dff/dt_scabby_fence04.dff","vc2sa/txd/dt_firestation.txd");
AddVC2SASimpleObject(4,-18540,"vc2sa/dff/dt_scabby_fence07.dff","vc2sa/txd/dt_firestation.txd");
AddVC2SASimpleObject(4,-18541,"vc2sa/dff/dt_carspaces1.dff","vc2sa/txd/dt_sheraton.txd");
AddVC2SASimpleObject(4,-18542,"vc2sa/dff/dt_carpsaces2.dff","vc2sa/txd/dt_sheraton.txd");
AddVC2SASimpleObject(4,-18543,"vc2sa/dff/dt_carpsaces03.dff","vc2sa/txd/dt_newtest1.txd");
AddVC2SASimpleObject(4,-18544,"vc2sa/dff/dt_carpsaces06.dff","vc2sa/txd/dt_firestation.txd");
AddVC2SASimpleObject(4,-18545,"vc2sa/dff/doontoon_top03.dff","vc2sa/txd/dts_grassbits.txd");
AddVC2SASimpleObject(0,-18546,"vc2sa/dff/doontoon_top04.dff","vc2sa/txd/dt_sheraton.txd");
AddVC2SASimpleObject(0,-18547,"vc2sa/dff/dt_nbeach08.dff","vc2sa/txd/dts_nbeach.txd");
AddVC2SASimpleObject(4,-18548,"vc2sa/dff/dwn_bikerbarfrnt.dff","vc2sa/txd/dts_grassbits.txd");
AddVC2SASimpleObject(0,-18549,"vc2sa/dff/dt_sheraton_fence.dff","vc2sa/txd/dt_sheraton.txd");
AddVC2SASimpleObject(0,-18550,"vc2sa/dff/new_inside.dff","vc2sa/txd/dts_office.txd");
AddVC2SASimpleObject(4,-18551,"vc2sa/dff/dts_offglassa.dff","vc2sa/txd/dts_office.txd");
AddVC2SASimpleObject(4,-18552,"vc2sa/dff/dts_telwire2.dff","vc2sa/txd/dts_roads.txd");
AddVC2SASimpleObject(4,-18553,"vc2sa/dff/dts_telwire1.dff","vc2sa/txd/dts_roads.txd");
AddVC2SASimpleObject(4,-18554,"vc2sa/dff/dts_telwire4.dff","vc2sa/txd/dts_roads.txd");
AddVC2SASimpleObject(0,-18555,"vc2sa/dff/dts_office2.dff","vc2sa/txd/dts_office.txd");
AddVC2SASimpleObject(1028,-18556,"vc2sa/dff/dts_glassplane_a.dff","vc2sa/txd/dts_office.txd");
AddVC2SASimpleObject(0,-18557,"vc2sa/dff/dts_spot_a.dff","vc2sa/txd/dt_CUNT.txd");
AddVC2SASimpleObject(4,-18558,"vc2sa/dff/new_insideb.dff","vc2sa/txd/dts_office.txd");
AddVC2SASimpleObject(1028,-18559,"vc2sa/dff/bikeshop_glass.dff","vc2sa/txd/dts_shops1.txd");
AddVC2SASimpleObject(1028,-18560,"vc2sa/dff/bikeshop_glass2.dff","vc2sa/txd/dts_shops1.txd");
AddVC2SASimpleObject(128,-18561,"vc2sa/dff/doontoon77.dff","vc2sa/txd/dt_firestation.txd");
AddVC2SASimpleObject(0,-18562,"vc2sa/dff/dtn_buildnew1.dff","vc2sa/txd/dts_copshop.txd");
AddVC2SASimpleObject(0,-18563,"vc2sa/dff/dtn_buildnew2.dff","vc2sa/txd/dts_copshop.txd");
AddVC2SASimpleObject(4,-18564,"vc2sa/dff/dts_cop_park.dff","vc2sa/txd/dts_copshop.txd");
AddVC2SASimpleObject(0,-18565,"vc2sa/dff/doontoon74.dff","vc2sa/txd/dt_CUNT2.txd");
AddVC2SASimpleObject(0,-18566,"vc2sa/dff/dt_spotlite_01.dff","vc2sa/txd/dt_CUNT.txd");
AddVC2SASimpleObject(0,-18567,"vc2sa/dff/dtns_kbshop1.dff","vc2sa/txd/dt_shops.txd");
AddVC2SASimpleObject(4,-18568,"vc2sa/dff/dtns_kbshop1b.dff","vc2sa/txd/dt_shops.txd");
AddVC2SASimpleObject(0,-18569,"vc2sa/dff/pharmacy_kb2.dff","vc2sa/txd/dt_newtest1.txd");
AddVC2SASimpleObject(4,-18570,"vc2sa/dff/dispensary_gls.dff","vc2sa/txd/dt_newtest1.txd");
AddVC2SASimpleObject(32,-18571,"vc2sa/dff/bb_roof1_01.dff","vc2sa/txd/bb_barroom.txd");
AddVC2SASimpleObject(36,-18572,"vc2sa/dff/bb_walljunk1_01.dff","vc2sa/txd/bb_barroomtrans.txd");
AddVC2SASimpleObject(36,-18573,"vc2sa/dff/bb_fence1.dff","vc2sa/txd/bb_barroomtrans.txd");
AddVC2SASimpleObject(32,-18574,"vc2sa/dff/bb_pooltable1_01.dff","vc2sa/txd/bb_barroom.txd");
AddVC2SASimpleObject(4,-18575,"vc2sa/dff/dts_tit_stares.dff","vc2sa/txd/dt_CUNT.txd");
AddVC2SASimpleObject(0,-18576,"vc2sa/dff/dw_scuz_kb.dff","vc2sa/txd/hi_cutsafehoos.txd");
AddVC2SASimpleObject(0,-18577,"vc2sa/dff/doontoon73b.dff","vc2sa/txd/dts_grassbits.txd");
AddVC2SASimpleObject(0,-18578,"vc2sa/dff/doontoon72b.dff","vc2sa/txd/dts_grassbits.txd");
AddVC2SASimpleObject(0,-18579,"vc2sa/dff/road_downtown05.dff","vc2sa/txd/dts_roads.txd");
AddVC2SASimpleObject(0,-18580,"vc2sa/dff/road_downtown10.dff","vc2sa/txd/dts_roads.txd");
AddVC2SASimpleObject(0,-18581,"vc2sa/dff/road_downtown_new1.dff","vc2sa/txd/dts_roads.txd");
AddVC2SASimpleObject(0,-18582,"vc2sa/dff/doontoon65.dff","vc2sa/txd/dts_ground.txd");
AddVC2SASimpleObject(0,-18583,"vc2sa/dff/doontoon66.dff","vc2sa/txd/dts_ground.txd");
AddVC2SASimpleObject(0,-18584,"vc2sa/dff/dt_nbeach07.dff","vc2sa/txd/dts_nbeach.txd");
AddVC2SASimpleObject(0,-18585,"vc2sa/dff/doontoon_top02.dff","vc2sa/txd/shipthisgamenow.txd");
AddVC2SASimpleObject(4,-18586,"vc2sa/dff/shopwindows_dts.dff","vc2sa/txd/dt_newtest1.txd");
AddVC2SASimpleObject(0,-18587,"vc2sa/dff/doontoon_shops.dff","vc2sa/txd/dts_shops.txd");
AddVC2SASimpleObject(0,-18588,"vc2sa/dff/doontoon_top08.dff","vc2sa/txd/dt_newtest1.txd");
AddVC2SASimpleObject(0,-18589,"vc2sa/dff/doontoon_top07.dff","vc2sa/txd/dt_newtest2.txd");
AddVC2SASimpleObject(0,-18590,"vc2sa/dff/doontoon16.dff","vc2sa/txd/dt_shops.txd");
AddVC2SASimpleObject(4,-18591,"vc2sa/dff/dts_telwire9.dff","vc2sa/txd/dts_roads.txd");
AddVC2SASimpleTimed(0,19,6,-18592,"vc2sa/dff/dts_nitelites1.dff","vc2sa/txd/dts_nitelites.txd");
AddVC2SASimpleObject(0,-18593,"vc2sa/dff/doontoon23_01.dff","vc2sa/txd/dt_tall_build01.txd");
AddVC2SASimpleObject(0,-18594,"vc2sa/dff/doontoon23_02.dff","vc2sa/txd/dt_tall_build01.txd");
AddVC2SASimpleObject(4,-18595,"vc2sa/dff/dts_offglassb.dff","vc2sa/txd/dts_office.txd");
AddVC2SASimpleObject(0,-18596,"vc2sa/dff/LODntoon22.dff","vc2sa/txd/dt_LOD.txd");
AddVC2SASimpleObject(0,-18597,"vc2sa/dff/doontoon03.dff","vc2sa/txd/dt_cube_build.txd");
AddVC2SASimpleObject(0,-18598,"vc2sa/dff/doontoon04.dff","vc2sa/txd/dt_topshops.txd");
AddVC2SASimpleObject(0,-18599,"vc2sa/dff/doontoon09.dff","vc2sa/txd/dtn_ground.txd");
AddVC2SASimpleObject(0,-18600,"vc2sa/dff/doontoon11.dff","vc2sa/txd/dtn_ground.txd");
AddVC2SASimpleObject(0,-18601,"vc2sa/dff/doontoon18.dff","vc2sa/txd/dt_shops14.txd");
AddVC2SASimpleObject(0,-18602,"vc2sa/dff/doontoon19.dff","vc2sa/txd/dt_shops14.txd");
AddVC2SASimpleObject(0,-18603,"vc2sa/dff/doontoon20.dff","vc2sa/txd/dt_modern1.txd");
AddVC2SASimpleObject(0,-18604,"vc2sa/dff/VCobjs_repair01.dff","vc2sa/txd/dt_shops1.txd");
AddVC2SASimpleObject(0,-18605,"vc2sa/dff/doontoon24.dff","vc2sa/txd/dt_shops18.txd");
AddVC2SASimpleObject(128,-18606,"vc2sa/dff/doontoon25.dff","vc2sa/txd/dt_shops182.txd");
AddVC2SASimpleObject(0,-18607,"vc2sa/dff/doontoon27.dff","vc2sa/txd/dt_shops188.txd");
AddVC2SASimpleObject(0,-18608,"vc2sa/dff/doontoon28.dff","vc2sa/txd/dt_shops180.txd");
AddVC2SASimpleObject(0,-18609,"vc2sa/dff/doontoon29.dff","vc2sa/txd/dt_shops13.txd");
AddVC2SASimpleObject(0,-18610,"vc2sa/dff/doontoon30.dff","vc2sa/txd/dt_topshops1.txd");
AddVC2SASimpleObject(0,-18611,"vc2sa/dff/doontoon31.dff","vc2sa/txd/dt_topshops1100.txd");
AddVC2SASimpleObject(0,-18612,"vc2sa/dff/doontoon32.dff","vc2sa/txd/dt_shops13.txd");
AddVC2SASimpleObject(0,-18613,"vc2sa/dff/doontoon34.dff","vc2sa/txd/dt_hospital.txd");
AddVC2SASimpleObject(0,-18614,"vc2sa/dff/doontoon35.dff","vc2sa/txd/dt_shops130.txd");
AddVC2SASimpleObject(0,-18615,"vc2sa/dff/doontoon36.dff","vc2sa/txd/dt_topshops130.txd");
AddVC2SASimpleObject(0,-18616,"vc2sa/dff/doontoon37.dff","vc2sa/txd/dt_topshops6.txd");
AddVC2SASimpleObject(0,-18617,"vc2sa/dff/doontoon38.dff","vc2sa/txd/dt_topshops5.txd");
AddVC2SASimpleObject(0,-18618,"vc2sa/dff/doontoon47.dff","vc2sa/txd/dt_shops3.txd");
AddVC2SASimpleObject(0,-18619,"vc2sa/dff/doontoon49.dff","vc2sa/txd/dt_shops2.txd");
AddVC2SASimpleObject(0,-18620,"vc2sa/dff/doontoon50.dff","vc2sa/txd/dt_shops3.txd");
AddVC2SASimpleObject(0,-18621,"vc2sa/dff/doontoon51.dff","vc2sa/txd/dt_shops3.txd");
AddVC2SASimpleObject(128,-18622,"vc2sa/dff/doontoon53.dff","vc2sa/txd/dt_VCnews.txd");
AddVC2SASimpleObject(0,-18623,"vc2sa/dff/doontoon54.dff","vc2sa/txd/dt_egg1.txd");
AddVC2SASimpleObject(0,-18624,"vc2sa/dff/doontoon55.dff","vc2sa/txd/dt_shops2.txd");
AddVC2SASimpleObject(0,-18625,"vc2sa/dff/doontoon59.dff","vc2sa/txd/dtn_ground.txd");
AddVC2SASimpleObject(0,-18626,"vc2sa/dff/doontoon61.dff","vc2sa/txd/dtn_ground2.txd");
AddVC2SASimpleObject(0,-18627,"vc2sa/dff/doontoon62.dff","vc2sa/txd/dtn_ground.txd");
AddVC2SASimpleObject(0,-18628,"vc2sa/dff/dt_hotel_waldt.dff","vc2sa/txd/dtn_ground.txd");
AddVC2SASimpleObject(0,-18629,"vc2sa/dff/doontoon67.dff","vc2sa/txd/dtn_ground.txd");
AddVC2SASimpleObject(0,-18630,"vc2sa/dff/doontoon70.dff","vc2sa/txd/dtn_ground.txd");
AddVC2SASimpleObject(0,-18631,"vc2sa/dff/newbuild01.dff","vc2sa/txd/dt_bluebuild.txd");
AddVC2SASimpleObject(36,-18632,"vc2sa/dff/recordingstudio.dff","vc2sa/txd/recstudio.txd");
AddVC2SASimpleObject(36,-18633,"vc2sa/dff/instruments.dff","vc2sa/txd/recstudio2.txd");
AddVC2SASimpleObject(0,-18634,"vc2sa/dff/compound_bits.dff","vc2sa/txd/dt_shops14.txd");
AddVC2SASimpleObject(0,-18635,"vc2sa/dff/dt_compound_esc.dff","vc2sa/txd/dt_shops13.txd");
AddVC2SASimpleObject(4,-18636,"vc2sa/dff/compound_fence.dff","vc2sa/txd/compound_fence.txd");
AddVC2SASimpleObject(0,-18637,"vc2sa/dff/dt_compound_roof.dff","vc2sa/txd/dt_compoundroof.txd");
AddVC2SASimpleObject(0,-18638,"vc2sa/dff/dt_tracktyres_04.dff","vc2sa/txd/dt_ntrack.txd");
AddVC2SASimpleObject(0,-18639,"vc2sa/dff/dt_tracktyres_02.dff","vc2sa/txd/dt_ntrack.txd");
AddVC2SASimpleObject(0,-18640,"vc2sa/dff/dt_tracktyres_05.dff","vc2sa/txd/dt_ntrack.txd");
AddVC2SASimpleObject(0,-18641,"vc2sa/dff/dt_tracktyres_03.dff","vc2sa/txd/dt_ntrack.txd");
AddVC2SASimpleObject(0,-18642,"vc2sa/dff/dt_tracktyres_01.dff","vc2sa/txd/dt_ntrack.txd");
AddVC2SASimpleObject(0,-18643,"vc2sa/dff/dt_tracktyres_06.dff","vc2sa/txd/dt_ntrack.txd");
AddVC2SASimpleObject(4,-18644,"vc2sa/dff/dt_track_flags01.dff","vc2sa/txd/dt_ntrack.txd");
AddVC2SASimpleObject(0,-18645,"vc2sa/dff/test_track.dff","vc2sa/txd/dt_ntrack.txd");
AddVC2SASimpleObject(4,-18646,"vc2sa/dff/dt_carpsaces13.dff","vc2sa/txd/dtn_ground.txd");
AddVC2SASimpleObject(0,-18647,"vc2sa/dff/doontoon_22_b.dff","vc2sa/txd/dt_hole_build.txd");
AddVC2SASimpleObject(4,-18648,"vc2sa/dff/dt_carpsaces14.dff","vc2sa/txd/dtn_ground.txd");
AddVC2SASimpleObject(4,-18649,"vc2sa/dff/veg_gaz.dff","vc2sa/txd/dtn_veg.txd");
AddVC2SASimpleObject(0,-18650,"vc2sa/dff/doontoon63.dff","vc2sa/txd/dtn_ground.txd");
AddVC2SASimpleObject(0,-18651,"vc2sa/dff/doontoon56.dff","vc2sa/txd/dt_scyscrap2.txd");
AddVC2SASimpleObject(0,-18652,"vc2sa/dff/dt_nbeach02.dff","vc2sa/txd/dt_nbeach.txd");
AddVC2SASimpleObject(0,-18653,"vc2sa/dff/doontoon_04_bit2.dff","vc2sa/txd/dt_topshops4.txd");
AddVC2SASimpleObject(0,-18654,"vc2sa/dff/dt_nbeach01.dff","vc2sa/txd/dt_nbeach.txd");
AddVC2SASimpleObject(0,-18655,"vc2sa/dff/dt_nbeach06.dff","vc2sa/txd/dt_nbeach.txd");
AddVC2SASimpleObject(4,-18656,"vc2sa/dff/dt_20_holewall.dff","vc2sa/txd/dt_modern1.txd");
AddVC2SASimpleObject(0,-18657,"vc2sa/dff/newbuild02.dff","vc2sa/txd/dt_modern2.txd");
AddVC2SASimpleObject(0,-18658,"vc2sa/dff/dt_bowlsign.dff","vc2sa/txd/dt_topshops1.txd");
AddVC2SASimpleObject(0,-18659,"vc2sa/dff/dt_marscafe.dff","vc2sa/txd/dt_shops13.txd");
AddVC2SASimpleObject(4,-18660,"vc2sa/dff/dt_carpsaces15.dff","vc2sa/txd/dt_topshops.txd");
AddVC2SASimpleObject(0,-18661,"vc2sa/dff/doontoon58.dff","vc2sa/txd/dt_hospital.txd");
AddVC2SASimpleObject(384,-18662,"vc2sa/dff/doontoon76.dff","vc2sa/txd/dt_bridges.txd");
AddVC2SASimpleObject(0,-18663,"vc2sa/dff/doontoon_newbit.dff","vc2sa/txd/dt_topshops50.txd");
AddVC2SASimpleObject(4,-18664,"vc2sa/dff/xpolytrees1_dt.dff","vc2sa/txd/dtn_veg.txd");
AddVC2SASimpleObject(4,-18665,"vc2sa/dff/xpolytrees3_dt.dff","vc2sa/txd/dtn_veg.txd");
AddVC2SASimpleObject(4,-18666,"vc2sa/dff/xpolytrees2_dt.dff","vc2sa/txd/dtn_veg.txd");
AddVC2SASimpleObject(4,-18667,"vc2sa/dff/xpolytrees4_dt.dff","vc2sa/txd/dtn_veg.txd");
AddVC2SASimpleObject(4,-18668,"vc2sa/dff/dtn_hospital_fence.dff","vc2sa/txd/dt_hospital.txd");
AddVC2SASimpleObject(0,-18669,"vc2sa/dff/dt_stadium_entrance.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(0,-18670,"vc2sa/dff/doontoon_top09.dff","vc2sa/txd/dt_bluebuild.txd");
AddVC2SASimpleObject(0,-18671,"vc2sa/dff/dt_stadiumland_c.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(0,-18672,"vc2sa/dff/dt_stadium_start.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(0,-18673,"vc2sa/dff/dt_stadiumland_a.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(0,-18674,"vc2sa/dff/dt_nbeach03.dff","vc2sa/txd/dt_nbeach.txd");
AddVC2SASimpleObject(0,-18675,"vc2sa/dff/doontoon_top10.dff","vc2sa/txd/dt_modern2.txd");
AddVC2SASimpleObject(0,-18676,"vc2sa/dff/dt_stadiumland_b.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(0,-18677,"vc2sa/dff/doontoon26.dff","vc2sa/txd/dt_shops6.txd");
AddVC2SASimpleObject(0,-18678,"vc2sa/dff/doontoon_top06.dff","vc2sa/txd/dt_shops5.txd");
AddVC2SASimpleObject(0,-18679,"vc2sa/dff/dt_nbeach05.dff","vc2sa/txd/dt_nbeach.txd");
AddVC2SASimpleObject(0,-18680,"vc2sa/dff/doontoon_top_bb.dff","vc2sa/txd/dt_bluebuild.txd");
AddVC2SASimpleObject(0,-18681,"vc2sa/dff/dt_stadiumland_d.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(4,-18682,"vc2sa/dff/dtn_stadspacesA.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(0,-18683,"vc2sa/dff/dt_savedrb.dff","vc2sa/txd/dt_shops13.txd");
AddVC2SASimpleObject(2048,-18684,"vc2sa/dff/dt_savedra.dff","vc2sa/txd/dt_shops13.txd");
AddVC2SASimpleObject(4,-18685,"vc2sa/dff/dtoon62_spaces.dff","vc2sa/txd/dtn_ground.txd");
AddVC2SASimpleObject(2048,-18686,"vc2sa/dff/dt_savedrc.dff","vc2sa/txd/dt_shops13.txd");
AddVC2SASimpleObject(2048,-18687,"vc2sa/dff/dt_savedrd.dff","vc2sa/txd/dt_shops13.txd");
AddVC2SASimpleObject(0,-18688,"vc2sa/dff/dt_roofshit1.dff","vc2sa/txd/dt_shops13.txd");
AddVC2SASimpleObject(4,-18689,"vc2sa/dff/dtn_stadspacesB.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(0,-18690,"vc2sa/dff/road_downtown13.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(0,-18691,"vc2sa/dff/road_downtown04.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(0,-18692,"vc2sa/dff/road_downtown02.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(256,-18693,"vc2sa/dff/road_downtown16.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(0,-18694,"vc2sa/dff/road_downtown03.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(0,-18695,"vc2sa/dff/road_downtown12.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(0,-18696,"vc2sa/dff/road_downtown15.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(0,-18697,"vc2sa/dff/road_downtown17.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(0,-18698,"vc2sa/dff/road_downtown_new2.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(0,-18699,"vc2sa/dff/road_stadiuma.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(0,-18700,"vc2sa/dff/road_downtown11.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(4,-18701,"vc2sa/dff/dtn_cablesa.dff","vc2sa/txd/dtn_cables.txd");
AddVC2SASimpleObject(4,-18702,"vc2sa/dff/dtn_cablesc.dff","vc2sa/txd/dtn_cables.txd");
AddVC2SASimpleObject(4,-18703,"vc2sa/dff/dtn_cablesb.dff","vc2sa/txd/dtn_cables2.txd");
AddVC2SASimpleObject(0,-18704,"vc2sa/dff/road_downtown14.dff","vc2sa/txd/dtn_roads.txd");
AddVC2SASimpleObject(4,-18705,"vc2sa/dff/dtn_cablesd.dff","vc2sa/txd/dtn_cables.txd");
AddVC2SASimpleObject(4,-18706,"vc2sa/dff/dtn_cablesf.dff","vc2sa/txd/dtn_cables.txd");
AddVC2SASimpleObject(4,-18707,"vc2sa/dff/dtn_cablese.dff","vc2sa/txd/dtn_cables.txd");
AddVC2SASimpleObject(1,-18708,"vc2sa/dff/stad_roadb.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(1,-18709,"vc2sa/dff/stad_roadc.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(1,-18710,"vc2sa/dff/stad_roadd.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(1,-18711,"vc2sa/dff/stad_roada.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(4,-18712,"vc2sa/dff/dtn_veg3.dff","vc2sa/txd/dtn_veg.txd");
AddVC2SASimpleObject(4,-18713,"vc2sa/dff/dtn_veg4.dff","vc2sa/txd/dtn_veg.txd");
AddVC2SASimpleObject(4,-18714,"vc2sa/dff/dt_stadium__alfa1.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(4,-18715,"vc2sa/dff/dt_stadiumalfa2.dff","vc2sa/txd/dt_stadium.txd");
AddVC2SASimpleObject(132,-18716,"vc2sa/dff/doontoon25_alfas.dff","vc2sa/txd/dt_shops182.txd");
AddVC2SASimpleObject(4,-18717,"vc2sa/dff/doontoon32_alfa.dff","vc2sa/txd/dt_shops13.txd");
AddVC2SASimpleObject(4,-18718,"vc2sa/dff/dt_compound_alfas.dff","vc2sa/txd/dt_compoundroof.txd");
AddVC2SASimpleObject(0,-18719,"vc2sa/dff/dt_VAJ.dff","vc2sa/txd/dt_cube_build.txd");
AddVC2SASimpleObject(4,-18720,"vc2sa/dff/doontoon66_bushes01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(12,19,6,-18721,"vc2sa/dff/dt_nitelites1.dff","vc2sa/txd/dt_lites.txd");
AddVC2SASimpleTimed(12,19,6,-18722,"vc2sa/dff/dt_nitelites2.dff","vc2sa/txd/dt_lites.txd");
AddVC2SASimpleTimed(12,19,6,-18723,"vc2sa/dff/dt_nitelites3.dff","vc2sa/txd/dt_lites.txd");
AddVC2SASimpleTimed(12,19,6,-18724,"vc2sa/dff/dt_nitelites7.dff","vc2sa/txd/dt_lites.txd");
AddVC2SASimpleTimed(12,19,6,-18725,"vc2sa/dff/dt_nitelites4.dff","vc2sa/txd/dt_lites.txd");
AddVC2SASimpleTimed(12,19,6,-18726,"vc2sa/dff/dt_nitelites5.dff","vc2sa/txd/dt_lites.txd");
AddVC2SASimpleTimed(12,19,6,-18727,"vc2sa/dff/dt_nitelites6.dff","vc2sa/txd/dt_lites.txd");
AddVC2SASimpleTimed(12,19,6,-18728,"vc2sa/dff/dt_nitelites8.dff","vc2sa/txd/dt_lites.txd");
AddVC2SASimpleObject(0,-18729,"vc2sa/dff/doontoon39_01.dff","vc2sa/txd/dt_qbert.txd");
AddVC2SASimpleObject(0,-18730,"vc2sa/dff/doontoon39_02.dff","vc2sa/txd/dt_qbert.txd");
AddVC2SASimpleObject(0,-18731,"vc2sa/dff/doontoon22_01.dff","vc2sa/txd/dt_shops1.txd");
AddVC2SASimpleObject(0,-18732,"vc2sa/dff/doontoon22_02.dff","vc2sa/txd/dt_shops1.txd");
AddVC2SASimpleObject(4,-18733,"vc2sa/dff/doontoon19b.dff","vc2sa/txd/dt_shops14.txd");
AddVC2SASimpleObject(132,-18734,"vc2sa/dff/STGLUE.dff","vc2sa/txd/star4.txd");
AddVC2SASimpleObject(4,-18735,"vc2sa/dff/Rose_Bush01.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(128,-18736,"vc2sa/dff/Mansion2_C_fence.dff","vc2sa/txd/star4.txd");
AddVC2SASimpleObject(128,-18737,"vc2sa/dff/Mansion2_A.dff","vc2sa/txd/stmansion.txd");
AddVC2SASimpleObject(132,-18738,"vc2sa/dff/Boat_houseA.dff","vc2sa/txd/star3.txd");
AddVC2SASimpleObject(4,-18739,"vc2sa/dff/Boat_houseA01.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(0,-18740,"vc2sa/dff/Mansion3_C.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(0,-18741,"vc2sa/dff/st_garden1.dff","vc2sa/txd/star2.txd");
AddVC2SASimpleObject(4,-18742,"vc2sa/dff/StarGate.dff","vc2sa/txd/star2.txd");
AddVC2SASimpleObject(4,-18743,"vc2sa/dff/Stglue01.dff","vc2sa/txd/star2.txd");
AddVC2SASimpleObject(4,-18744,"vc2sa/dff/stpoolwater.dff","vc2sa/txd/starpool.txd");
AddVC2SASimpleObject(4,-18745,"vc2sa/dff/Rose_Bush03.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(4,-18746,"vc2sa/dff/stPOOLw1.dff","vc2sa/txd/transbits2.txd");
AddVC2SASimpleObject(0,-18747,"vc2sa/dff/mansion1gardens.dff","vc2sa/txd/star4.txd");
AddVC2SASimpleObject(0,-18748,"vc2sa/dff/starisland_road6.dff","vc2sa/txd/starroad.txd");
AddVC2SASimpleObject(0,-18749,"vc2sa/dff/starisland_road2.dff","vc2sa/txd/starroad.txd");
AddVC2SASimpleObject(0,-18750,"vc2sa/dff/starisland_road4.dff","vc2sa/txd/starroad.txd");
AddVC2SASimpleObject(0,-18751,"vc2sa/dff/starisland_road1.dff","vc2sa/txd/starroad.txd");
AddVC2SASimpleObject(128,-18752,"vc2sa/dff/boatpole.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(0,-18753,"vc2sa/dff/starisland_road3.dff","vc2sa/txd/starroad.txd");
AddVC2SASimpleObject(0,-18754,"vc2sa/dff/mansion3gardens.dff","vc2sa/txd/star3.txd");
AddVC2SASimpleObject(128,-18755,"vc2sa/dff/Mansion2_B.dff","vc2sa/txd/star3.txd");
AddVC2SASimpleObject(128,-18756,"vc2sa/dff/mansion3a.dff","vc2sa/txd/star4.txd");
AddVC2SASimpleObject(128,-18757,"vc2sa/dff/mansion3_B.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(128,-18758,"vc2sa/dff/mansion1b.dff","vc2sa/txd/star1.txd");
AddVC2SASimpleObject(128,-18759,"vc2sa/dff/Starhouse.dff","vc2sa/txd/star2.txd");
AddVC2SASimpleObject(4,-18760,"vc2sa/dff/stObject23.dff","vc2sa/txd/starpool.txd");
AddVC2SASimpleObject(4,-18761,"vc2sa/dff/stPOOLWATER5.dff","vc2sa/txd/starpool.txd");
AddVC2SASimpleObject(4,-18762,"vc2sa/dff/Stglue06.dff","vc2sa/txd/star2.txd");
AddVC2SASimpleObject(132,-18763,"vc2sa/dff/Stglue07.dff","vc2sa/txd/star4.txd");
AddVC2SASimpleObject(0,-18764,"vc2sa/dff/starladder.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(132,-18765,"vc2sa/dff/Mansion4gate.dff","vc2sa/txd/star1.txd");
AddVC2SASimpleObject(0,-18766,"vc2sa/dff/Man4garagedoors.dff","vc2sa/txd/star1.txd");
AddVC2SASimpleObject(4,-18767,"vc2sa/dff/stPOOLWATER02.dff","vc2sa/txd/starpool.txd");
AddVC2SASimpleObject(128,-18768,"vc2sa/dff/Starrockpool.dff","vc2sa/txd/star1.txd");
AddVC2SASimpleObject(0,-18769,"vc2sa/dff/man4ladderpool01.dff","vc2sa/txd/star1.txd");
AddVC2SASimpleObject(0,-18770,"vc2sa/dff/Mansion1_base.dff","vc2sa/txd/star1.txd");
AddVC2SASimpleObject(128,-18771,"vc2sa/dff/Mansion1_A.dff","vc2sa/txd/star1.txd");
AddVC2SASimpleObject(4,-18772,"vc2sa/dff/gate4.dff","vc2sa/txd/star4.txd");
AddVC2SASimpleObject(0,-18773,"vc2sa/dff/gate5.dff","vc2sa/txd/star4.txd");
AddVC2SASimpleObject(132,-18774,"vc2sa/dff/starbbnet02.dff","vc2sa/txd/starf.txd");
AddVC2SASimpleObject(128,-18775,"vc2sa/dff/Mansion2c.dff","vc2sa/txd/star4.txd");
AddVC2SASimpleObject(4,-18776,"vc2sa/dff/starbridge2.dff","vc2sa/txd/starbridge.txd");
AddVC2SASimpleObject(0,-18777,"vc2sa/dff/starmainwall1.dff","vc2sa/txd/mansionwall.txd");
AddVC2SASimpleObject(0,-18778,"vc2sa/dff/starwallmain2.dff","vc2sa/txd/mansionwall.txd");
AddVC2SASimpleObject(0,-18779,"vc2sa/dff/starwallmain4.dff","vc2sa/txd/mansionwall.txd");
AddVC2SASimpleObject(128,-18780,"vc2sa/dff/sb.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(132,-18781,"vc2sa/dff/starfbed02.dff","vc2sa/txd/starf.txd");
AddVC2SASimpleObject(4,-18782,"vc2sa/dff/starfbed03.dff","vc2sa/txd/starf.txd");
AddVC2SASimpleObject(132,-18783,"vc2sa/dff/starfbed04.dff","vc2sa/txd/starf.txd");
AddVC2SASimpleObject(132,-18784,"vc2sa/dff/starfbed05.dff","vc2sa/txd/starf.txd");
AddVC2SASimpleObject(132,-18785,"vc2sa/dff/starfbed06.dff","vc2sa/txd/starf.txd");
AddVC2SASimpleObject(0,-18786,"vc2sa/dff/pollstaeps1.dff","vc2sa/txd/star2.txd");
AddVC2SASimpleObject(0,-18787,"vc2sa/dff/starbridge2b.dff","vc2sa/txd/starbridge.txd");
AddVC2SASimpleObject(128,-18788,"vc2sa/dff/starwallmain5.dff","vc2sa/txd/mansionwall.txd");
AddVC2SASimpleObject(132,-18789,"vc2sa/dff/comgate2.dff","vc2sa/txd/starroad.txd");
AddVC2SASimpleObject(132,-18790,"vc2sa/dff/comgate1.dff","vc2sa/txd/starroad.txd");
AddVC2SASimpleObject(128,-18791,"vc2sa/dff/comgate03.dff","vc2sa/txd/starroad.txd");
AddVC2SASimpleObject(132,-18792,"vc2sa/dff/STARBLOCKER1.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(132,-18793,"vc2sa/dff/STARBLOCKER02.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(0,-18794,"vc2sa/dff/mansion3gardens2.dff","vc2sa/txd/star3.txd");
AddVC2SASimpleObject(128,-18795,"vc2sa/dff/man1garden_hedge.dff","vc2sa/txd/star4.txd");
AddVC2SASimpleObject(128,-18796,"vc2sa/dff/Man3_base_hedge.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(128,-18797,"vc2sa/dff/man3ghedge.dff","vc2sa/txd/star3.txd");
AddVC2SASimpleObject(128,-18798,"vc2sa/dff/Man1_baseHedge.dff","vc2sa/txd/star1.txd");
AddVC2SASimpleObject(0,-18799,"vc2sa/dff/mansion3_base.dff","vc2sa/txd/star5.txd");
AddVC2SASimpleObject(388,-18800,"vc2sa/dff/LODrtrees1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(388,-18801,"vc2sa/dff/LODrtrees2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(388,-18802,"vc2sa/dff/LODrtrees3.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(388,-18803,"vc2sa/dff/LODrtrees4.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(388,-18804,"vc2sa/dff/LODrtrees5.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-18805,"vc2sa/dff/LODworksramps.dff","vc2sa/txd/LODhaiti.txd");
AddVC2SASimpleObject(128,-18806,"vc2sa/dff/LODtistation.dff","vc2sa/txd/LODhaiti.txd");
AddVC2SASimpleObject(128,-18807,"vc2sa/dff/LODtistation01.dff","vc2sa/txd/LODhaiti.txd");
AddVC2SASimpleObject(0,-18808,"vc2sa/dff/littlehacoast05.dff","vc2sa/txd/sjmh1haitiroad.txd");
AddVC2SASimpleObject(128,-18809,"vc2sa/dff/sjmnd04.dff","vc2sa/txd/lhaith9.txd");
AddVC2SASimpleObject(128,-18810,"vc2sa/dff/drugstoreint.dff","vc2sa/txd/chem2.txd");
AddVC2SASimpleObject(132,-18811,"vc2sa/dff/drugstoreext.dff","vc2sa/txd/chem.txd");
AddVC2SASimpleObject(128,-18812,"vc2sa/dff/bed_shop.dff","vc2sa/txd/bed.txd");
AddVC2SASimpleObject(0,-18813,"vc2sa/dff/litharoada6.dff","vc2sa/txd/sjmh1haitiroad.txd");
AddVC2SASimpleObject(0,-18814,"vc2sa/dff/litharoada9.dff","vc2sa/txd/sjmh1haitiroad.txd");
AddVC2SASimpleObject(0,-18815,"vc2sa/dff/litharoada8.dff","vc2sa/txd/sjmh1haitiroad.txd");
AddVC2SASimpleObject(128,-18816,"vc2sa/dff/lh_haiblockc1.dff","vc2sa/txd/lh_haiblockc1.txd");
AddVC2SASimpleObject(128,-18817,"vc2sa/dff/litlhaitibuilding02.dff","vc2sa/txd/lhaitiblk6f.txd");
AddVC2SASimpleObject(128,-18818,"vc2sa/dff/lh_crushers15.dff","vc2sa/txd/crusherb.txd");
AddVC2SASimpleObject(128,-18819,"vc2sa/dff/lh_hitbuild1a.dff","vc2sa/txd/lhaitiblk6f.txd");
AddVC2SASimpleObject(128,-18820,"vc2sa/dff/pw_printworks.dff","vc2sa/txd/lh_PWbuild1.txd");
AddVC2SASimpleObject(128,-18821,"vc2sa/dff/pw_stairs.dff","vc2sa/txd/lh_PWbuild2.txd");
AddVC2SASimpleObject(128,-18822,"vc2sa/dff/pw_stairbarrier.dff","vc2sa/txd/lh_PWbuild2.txd");
AddVC2SASimpleObject(128,-18823,"vc2sa/dff/pw_backfence1.dff","vc2sa/txd/lh_PWbuild2.txd");
AddVC2SASimpleObject(128,-18824,"vc2sa/dff/pw_bayfence2_01.dff","vc2sa/txd/lh_PWbuild2.txd");
AddVC2SASimpleObject(132,-18825,"vc2sa/dff/pw_staffpark01.dff","vc2sa/txd/lh_PWbuild2.txd");
AddVC2SASimpleObject(128,-18826,"vc2sa/dff/pw_paperroll_01.dff","vc2sa/txd/lh_PWbuild2.txd");
AddVC2SASimpleObject(128,-18827,"vc2sa/dff/litlhaitibuilding09.dff","vc2sa/txd/lhaitiblk6k.txd");
AddVC2SASimpleObject(0,-18828,"vc2sa/dff/haiticent.dff","vc2sa/txd/h_haibloce.txd");
AddVC2SASimpleObject(128,-18829,"vc2sa/dff/lithit14.dff","vc2sa/txd/hai_hoj.txd");
AddVC2SASimpleObject(128,-18830,"vc2sa/dff/hai_houses27.dff","vc2sa/txd/hai_hoj.txd");
AddVC2SASimpleObject(0,-18831,"vc2sa/dff/hibita1.dff","vc2sa/txd/lhaitiblk4sj.txd");
AddVC2SASimpleObject(0,-18832,"vc2sa/dff/sewer2.dff","vc2sa/txd/lhaitiblk4sj.txd");
AddVC2SASimpleObject(0,-18833,"vc2sa/dff/haitiskyt.dff","vc2sa/txd/haitbuildb.txd");
AddVC2SASimpleObject(0,-18834,"vc2sa/dff/haitiroadbuild.dff","vc2sa/txd/haitrdbuilf.txd");
AddVC2SASimpleObject(132,-18835,"vc2sa/dff/haicoast1.dff","vc2sa/txd/sjmhahaitiground.txd");
AddVC2SASimpleObject(128,-18836,"vc2sa/dff/ihaitsnip.dff","vc2sa/txd/ihsnidxc.txd");
AddVC2SASimpleObject(128,-18837,"vc2sa/dff/lh-hitbuild1aa.dff","vc2sa/txd/lhaitiblk6f.txd");
AddVC2SASimpleObject(132,-18838,"vc2sa/dff/stationfence.dff","vc2sa/txd/h_haibloce.txd");
AddVC2SASimpleObject(0,-18839,"vc2sa/dff/HAITI1RD.dff","vc2sa/txd/sjmh1haitiroad.txd");
AddVC2SASimpleObject(128,-18840,"vc2sa/dff/lh_crushers09.dff","vc2sa/txd/crusher2.txd");
AddVC2SASimpleObject(132,-18841,"vc2sa/dff/haicoast2.dff","vc2sa/txd/sjmhahaitiground.txd");
AddVC2SASimpleObject(0,-18842,"vc2sa/dff/sjmcrushju.dff","vc2sa/txd/crusher3.txd");
AddVC2SASimpleObject(128,-18843,"vc2sa/dff/sjmcrushlpo.dff","vc2sa/txd/crusherb.txd");
AddVC2SASimpleObject(128,-18844,"vc2sa/dff/lh_crushers13.dff","vc2sa/txd/crusherb.txd");
AddVC2SASimpleObject(0,-18845,"vc2sa/dff/lh_crushers14.dff","vc2sa/txd/sjmjcrusher4.txd");
AddVC2SASimpleObject(0,-18846,"vc2sa/dff/sjmcrushmnf.dff","vc2sa/txd/ssjmcrusher5.txd");
AddVC2SASimpleObject(128,-18847,"vc2sa/dff/sjmcrushtankr.dff","vc2sa/txd/bitcrusher5.txd");
AddVC2SASimpleObject(132,-18848,"vc2sa/dff/fence01.dff","vc2sa/txd/lh_haiblockc2.txd");
AddVC2SASimpleObject(132,-18849,"vc2sa/dff/haititag.dff","vc2sa/txd/haititag.txd");
AddVC2SASimpleObject(128,-18850,"vc2sa/dff/haitistation01.dff","vc2sa/txd/h_haibloce.txd");
AddVC2SASimpleObject(0,-18851,"vc2sa/dff/htnroadnew.dff","vc2sa/txd/sjmh1haitiroad.txd");
AddVC2SASimpleObject(128,-18852,"vc2sa/dff/lh_crushefuck.dff","vc2sa/txd/crusher1.txd");
AddVC2SASimpleObject(128,-18853,"vc2sa/dff/haiticar08.dff","vc2sa/txd/carwreck.txd");
AddVC2SASimpleObject(128,-18854,"vc2sa/dff/haiticar10.dff","vc2sa/txd/carwreck.txd");
AddVC2SASimpleObject(128,-18855,"vc2sa/dff/haiticar12.dff","vc2sa/txd/carwreck.txd");
AddVC2SASimpleObject(128,-18856,"vc2sa/dff/sjmbigsig.dff","vc2sa/txd/sjmspray.txd");
AddVC2SASimpleObject(128,-18857,"vc2sa/dff/sjmbigsig2.dff","vc2sa/txd/sjmspray.txd");
AddVC2SASimpleObject(132,-18858,"vc2sa/dff/haicoastfirst.dff","vc2sa/txd/sjmhbghaitiground.txd");
AddVC2SASimpleObject(0,-18859,"vc2sa/dff/sjmcoast04.dff","vc2sa/txd/sjmh1haitiroad.txd");
AddVC2SASimpleObject(128,-18860,"vc2sa/dff/litlhaitibuilding07.dff","vc2sa/txd/sjmh5haitiroad.txd");
AddVC2SASimpleObject(0,-18861,"vc2sa/dff/pw_groundplane.dff","vc2sa/txd/lh_PWbuild1grnd.txd");
AddVC2SASimpleObject(128,-18862,"vc2sa/dff/haiwashpaynspray.dff","vc2sa/txd/haiwash.txd");
AddVC2SASimpleObject(2048,-18863,"vc2sa/dff/haiwshpnsdoor.dff","vc2sa/txd/haiwash.txd");
AddVC2SASimpleObject(0,-18864,"vc2sa/dff/roofbit2.dff","vc2sa/txd/roofbit.txd");
AddVC2SASimpleObject(0,-18865,"vc2sa/dff/roofbit07.dff","vc2sa/txd/roofbit.txd");
AddVC2SASimpleObject(0,-18866,"vc2sa/dff/sjmhafinrd.dff","vc2sa/txd/sjmh1haitiroad.txd");
AddVC2SASimpleObject(0,-18867,"vc2sa/dff/grassbitsjm.dff","vc2sa/txd/lhaitiblk4sj.txd");
AddVC2SASimpleObject(32,-18868,"vc2sa/dff/pw_priint.dff","vc2sa/txd/LH_PWInterior.txd");
AddVC2SASimpleObject(32,-18869,"vc2sa/dff/pw_press1_03.dff","vc2sa/txd/LH_PWInterior.txd");
AddVC2SASimpleObject(132,-18870,"vc2sa/dff/scrapgate.dff","vc2sa/txd/crusher3.txd");
AddVC2SASimpleObject(128,-18871,"vc2sa/dff/haiticar13.dff","vc2sa/txd/carwreck.txd");
AddVC2SASimpleObject(128,-18872,"vc2sa/dff/lh_crushers08.dff","vc2sa/txd/lhmachine1m.txd");
AddVC2SASimpleObject(132,-18873,"vc2sa/dff/lh_boxgirdbridge.dff","vc2sa/txd/lh_dockstuff1.txd");
AddVC2SASimpleObject(132,-18874,"vc2sa/dff/lh_dockposts1.dff","vc2sa/txd/lh_dockstuff1.txd");
AddVC2SASimpleObject(132,-18875,"vc2sa/dff/lh_dockposts2.dff","vc2sa/txd/lh_dockstuff1.txd");
AddVC2SASimpleObject(132,-18876,"vc2sa/dff/lh_dockposts3.dff","vc2sa/txd/lh_dockstuff1.txd");
AddVC2SASimpleObject(132,-18877,"vc2sa/dff/lh_pianoshop.dff","vc2sa/txd/sjmhbghaitiground.txd");
AddVC2SASimpleObject(128,-18878,"vc2sa/dff/pw_paperroll_02.dff","vc2sa/txd/lh_PWbuild2.txd");
AddVC2SASimpleObject(128,-18879,"vc2sa/dff/pw_paperroll_03.dff","vc2sa/txd/lh_PWbuild2.txd");
AddVC2SASimpleObject(0,-18880,"vc2sa/dff/printdooor.dff","vc2sa/txd/lh_PWbuild1.txd");
AddVC2SASimpleObject(132,-18881,"vc2sa/dff/sjmgrass2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-18882,"vc2sa/dff/sjmgrass.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-18883,"vc2sa/dff/sjmtionb02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(172,22,5,-18884,"vc2sa/dff/haiwshpspryneon1.dff","vc2sa/txd/haiwash.txd");
AddVC2SASimpleTimed(128,5,22,-18885,"vc2sa/dff/haiwsignday_dy.dff","vc2sa/txd/haiwash.txd");
AddVC2SASimpleTimed(128,22,5,-18886,"vc2sa/dff/haiwsignight_nt.dff","vc2sa/txd/haiwash.txd");
AddVC2SASimpleObject(0,-18887,"vc2sa/dff/sjmcrushbn.dff","vc2sa/txd/sjmbncrusher5.txd");
AddVC2SASimpleObject(0,-18888,"vc2sa/dff/objekt_repair64.dff","vc2sa/txd/hai_hoj.txd");
AddVC2SASimpleObject(0,-18889,"vc2sa/dff/objekt_repair63.dff","vc2sa/txd/hai_hoj.txd");
AddVC2SASimpleObject(0,-18890,"vc2sa/dff/objekt_repair62_1.dff","vc2sa/txd/hai_hoj.txd");
AddVC2SASimpleObject(0,-18891,"vc2sa/dff/objekt_repair62_2.dff","vc2sa/txd/hai_hoj.txd");
AddVC2SASimpleObject(0,-18892,"vc2sa/dff/objekt_repair65_1.dff","vc2sa/txd/hai_hoj.txd");
AddVC2SASimpleObject(0,-18893,"vc2sa/dff/objekt_repair65_2.dff","vc2sa/txd/hai_hoj.txd");
AddVC2SASimpleObject(132,-18894,"vc2sa/dff/tesad06.dff","vc2sa/txd/telephait.txd");
AddVC2SASimpleObject(132,-18895,"vc2sa/dff/tesad06sas.dff","vc2sa/txd/telephait.txd");
AddVC2SASimpleObject(132,-18896,"vc2sa/dff/tesad06ss.dff","vc2sa/txd/telephait.txd");
AddVC2SASimpleObject(0,-18897,"vc2sa/dff/sjmcoast.dff","vc2sa/txd/sjmroadhaitiN.txd");
AddVC2SASimpleObject(0,-18898,"vc2sa/dff/sjmsection.dff","vc2sa/txd/sjmroadhaitiN.txd");
AddVC2SASimpleObject(0,-18899,"vc2sa/dff/sjmcoast08.dff","vc2sa/txd/sjmroadhaitiN.txd");
AddVC2SASimpleObject(0,-18900,"vc2sa/dff/sjmcoast06.dff","vc2sa/txd/sjmroadhaitiN.txd");
AddVC2SASimpleObject(0,-18901,"vc2sa/dff/sjmuilding01.dff","vc2sa/txd/lhaitiblkhuty.txd");
AddVC2SASimpleObject(0,-18902,"vc2sa/dff/lh_phils.dff","vc2sa/txd/philss.txd");
AddVC2SASimpleObject(0,-18903,"vc2sa/dff/litharoada2.dff","vc2sa/txd/sjmroadhaitiN.txd");
AddVC2SASimpleObject(0,-18904,"vc2sa/dff/litharoada3.dff","vc2sa/txd/sjmroadhaitiN.txd");
AddVC2SASimpleObject(0,-18905,"vc2sa/dff/litharoada4.dff","vc2sa/txd/sjmroadhaitiN.txd");
AddVC2SASimpleObject(128,-18906,"vc2sa/dff/lh_crushers10.dff","vc2sa/txd/lhmachine1mn.txd");
AddVC2SASimpleObject(128,-18907,"vc2sa/dff/lh_philsext.dff","vc2sa/txd/philss.txd");
AddVC2SASimpleObject(160,-18908,"vc2sa/dff/lh_philsint.dff","vc2sa/txd/philinter.txd");
AddVC2SASimpleObject(128,-18909,"vc2sa/dff/litlhaitibuilding06.dff","vc2sa/txd/lhaitiblkplat.txd");
AddVC2SASimpleObject(128,-18910,"vc2sa/dff/lh_crushers11.dff","vc2sa/txd/crusherbn.txd");
AddVC2SASimpleObject(128,-18911,"vc2sa/dff/lh_taxifirm02.dff","vc2sa/txd/lhcabbyext.txd");
AddVC2SASimpleObject(160,-18912,"vc2sa/dff/lh_taxifirm01.dff","vc2sa/txd/lhcabby.txd");
AddVC2SASimpleObject(128,-18913,"vc2sa/dff/lh_haiblockc2.dff","vc2sa/txd/lh_haibljki.txd");
AddVC2SASimpleObject(132,-18914,"vc2sa/dff/haitgangshop.dff","vc2sa/txd/gangshop.txd");
AddVC2SASimpleObject(128,-18915,"vc2sa/dff/haitgangshopdoor.dff","vc2sa/txd/gangshop.txd");
AddVC2SASimpleObject(128,-18916,"vc2sa/dff/haitihut3.dff","vc2sa/txd/lhaithutn.txd");
AddVC2SASimpleObject(128,-18917,"vc2sa/dff/haitimall.dff","vc2sa/txd/lhaitiblk1fg.txd");
AddVC2SASimpleObject(128,-18918,"vc2sa/dff/mall2.dff","vc2sa/txd/lhaitiblk1fg.txd");
AddVC2SASimpleObject(128,-18919,"vc2sa/dff/billboard.dff","vc2sa/txd/haitisig.txd");
AddVC2SASimpleObject(128,-18920,"vc2sa/dff/hatsog.dff","vc2sa/txd/lhaiths.txd");
AddVC2SASimpleObject(128,-18921,"vc2sa/dff/haitihut1.dff","vc2sa/txd/lhaithutn.txd");
AddVC2SASimpleObject(128,-18922,"vc2sa/dff/haitihut2.dff","vc2sa/txd/lhaithutn.txd");
AddVC2SASimpleObject(128,-18923,"vc2sa/dff/haitibuilds.dff","vc2sa/txd/haitbuildsea1.txd");
AddVC2SASimpleObject(128,-18924,"vc2sa/dff/haitiskyg.dff","vc2sa/txd/haitbuildsea2.txd");
AddVC2SASimpleObject(132,-18925,"vc2sa/dff/haicoasta2.dff","vc2sa/txd/sjmahaitiground.txd");
AddVC2SASimpleObject(128,-18926,"vc2sa/dff/haitbuildws14.dff","vc2sa/txd/haitbuild41.txd");
AddVC2SASimpleObject(0,-18927,"vc2sa/dff/haicoast3.dff","vc2sa/txd/sjmahaitiground.txd");
AddVC2SASimpleObject(0,-18928,"vc2sa/dff/haicoast4.dff","vc2sa/txd/sjmahaitiground.txd");
AddVC2SASimpleObject(0,-18929,"vc2sa/dff/haicoast5.dff","vc2sa/txd/sjmahaitiground.txd");
AddVC2SASimpleObject(4,-18930,"vc2sa/dff/haigrnda1.dff","vc2sa/txd/sjmahaitiground.txd");
AddVC2SASimpleObject(128,-18931,"vc2sa/dff/havanahouse12.dff","vc2sa/txd/haitiblk1sj.txd");
AddVC2SASimpleObject(0,-18932,"vc2sa/dff/ih-sjmcrush.dff","vc2sa/txd/crusherbn.txd");
AddVC2SASimpleObject(128,-18933,"vc2sa/dff/ih-sjmphil.dff","vc2sa/txd/philss.txd");
AddVC2SASimpleObject(128,-18934,"vc2sa/dff/sjmcrushgate.dff","vc2sa/txd/philss.txd");
AddVC2SASimpleObject(128,-18935,"vc2sa/dff/buildblown.dff","vc2sa/txd/buildinghan.txd");
AddVC2SASimpleObject(0,-18936,"vc2sa/dff/lh_haiblockc3.dff","vc2sa/txd/funhiati.txd");
AddVC2SASimpleObject(132,-18937,"vc2sa/dff/nhaitiplnt14.dff","vc2sa/txd/haitplntn.txd");
AddVC2SASimpleObject(132,-18938,"vc2sa/dff/crocneon.dff","vc2sa/txd/lh_haibljki.txd");
AddVC2SASimpleObject(128,-18939,"vc2sa/dff/hvood01.dff","vc2sa/txd/chairsnstufh.txd");
AddVC2SASimpleObject(128,-18940,"vc2sa/dff/nhvood.dff","vc2sa/txd/chairsnstufh.txd");
AddVC2SASimpleObject(128,-18941,"vc2sa/dff/fffinhaiti.dff","vc2sa/txd/fffinhaiti.txd");
AddVC2SASimpleObject(128,-18942,"vc2sa/dff/sjmmet.dff","vc2sa/txd/lhaiths.txd");
AddVC2SASimpleObject(128,-18943,"vc2sa/dff/sjmmet2.dff","vc2sa/txd/lh_haibljki.txd");
AddVC2SASimpleObject(128,-18944,"vc2sa/dff/miamiland027a.dff","vc2sa/txd/lhaiths.txd");
AddVC2SASimpleObject(128,-18945,"vc2sa/dff/newramp2.dff","vc2sa/txd/newrampn.txd");
AddVC2SASimpleObject(4,-18946,"vc2sa/dff/haitinwire11.dff","vc2sa/txd/haitinwire.txd");
AddVC2SASimpleObject(4,-18947,"vc2sa/dff/haitinwire22.dff","vc2sa/txd/haitinwire.txd");
AddVC2SASimpleObject(128,-18948,"vc2sa/dff/npw_press1_02.dff","vc2sa/txd/lh_PWbuild3.txd");
AddVC2SASimpleObject(0,-18949,"vc2sa/dff/haitroadb.dff","vc2sa/txd/sjmroadhaitiN.txd");
AddVC2SASimpleObject(0,-18950,"vc2sa/dff/haitroada.dff","vc2sa/txd/sjmroadhaitiN.txd");
AddVC2SASimpleObject(0,-18951,"vc2sa/dff/haitroadc.dff","vc2sa/txd/sjmroadhaitiN.txd");
AddVC2SASimpleObject(160,-18952,"vc2sa/dff/hdrugfactorypol.dff","vc2sa/txd/drugfactint.txd");
AddVC2SASimpleObject(0,-18953,"vc2sa/dff/lh_crushers12.dff","vc2sa/txd/crusherbn.txd");
AddVC2SASimpleObject(132,-18954,"vc2sa/dff/nhaitiplnt15.dff","vc2sa/txd/haitplntn.txd");
AddVC2SASimpleObject(128,-18955,"vc2sa/dff/lh_pizzaplace.dff","vc2sa/txd/nbtshops.txd");
AddVC2SASimpleObject(128,-18956,"vc2sa/dff/sjmuilding05.dff","vc2sa/txd/lhaitiblk2.txd");
AddVC2SASimpleObject(0,-18957,"vc2sa/dff/lhaitnewbt.dff","vc2sa/txd/lhaitiblksick.txd");
AddVC2SASimpleObject(0,-18958,"vc2sa/dff/lhaitcut.dff","vc2sa/txd/ihaitcutmf.txd");
AddVC2SASimpleObject(128,-18959,"vc2sa/dff/ihaitwarhus.dff","vc2sa/txd/lhaitiblkplt2.txd");
AddVC2SASimpleObject(4,-18960,"vc2sa/dff/haitinwire23.dff","vc2sa/txd/haitinwire.txd");
AddVC2SASimpleObject(128,-18961,"vc2sa/dff/sjmbigsign.dff","vc2sa/txd/sjmsprayn.txd");
AddVC2SASimpleObject(164,-18962,"vc2sa/dff/hvood.dff","vc2sa/txd/haitcont.txd");
AddVC2SASimpleObject(132,-18963,"vc2sa/dff/hvoodext.dff","vc2sa/txd/haitcontext.txd");
AddVC2SASimpleObject(128,-18964,"vc2sa/dff/sjmbigsign01.dff","vc2sa/txd/sjmsprayn.txd");
AddVC2SASimpleObject(256,-18965,"vc2sa/dff/hai_roadsigns.dff","vc2sa/txd/lhaiths.txd");
AddVC2SASimpleObject(128,-18966,"vc2sa/dff/sjmbigsign02.dff","vc2sa/txd/sjmsprayn.txd");
AddVC2SASimpleObject(128,-18967,"vc2sa/dff/nhaiticar13.dff","vc2sa/txd/ncarwreck.txd");
AddVC2SASimpleObject(132,-18968,"vc2sa/dff/lh_dockpostsN1.dff","vc2sa/txd/lh_dockstuffN1.txd");
AddVC2SASimpleObject(132,-18969,"vc2sa/dff/lh_dockpostsN2.dff","vc2sa/txd/lh_dockstuffN1.txd");
AddVC2SASimpleObject(132,-18970,"vc2sa/dff/lh_dockpostsN3.dff","vc2sa/txd/lh_dockstuffN1.txd");
AddVC2SASimpleObject(132,-18971,"vc2sa/dff/havanahouse12b.dff","vc2sa/txd/haitiblk1sj.txd");
AddVC2SASimpleObject(164,-18972,"vc2sa/dff/hdrugfactoryintb.dff","vc2sa/txd/drugfactint.txd");
AddVC2SASimpleObject(132,-18973,"vc2sa/dff/lh_pizzaplaceb.dff","vc2sa/txd/nbtshops.txd");
AddVC2SASimpleObject(0,-18974,"vc2sa/dff/ci_islandwest.dff","vc2sa/txd/ci_studionew1.txd");
AddVC2SASimpleObject(0,-18975,"vc2sa/dff/ci_studiowall.dff","vc2sa/txd/ci_studionew1.txd");
AddVC2SASimpleObject(128,-18976,"vc2sa/dff/ci_astage.dff","vc2sa/txd/ci_studio2.txd");
AddVC2SASimpleObject(128,-18977,"vc2sa/dff/ci_mansionwall1.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(128,-18978,"vc2sa/dff/ci_watertank.dff","vc2sa/txd/ci_studio5.txd");
AddVC2SASimpleObject(128,-18979,"vc2sa/dff/ci_screening.dff","vc2sa/txd/ci_studio6.txd");
AddVC2SASimpleObject(128,-18980,"vc2sa/dff/ci_screeningstairs.dff","vc2sa/txd/ci_studio6.txd");
AddVC2SASimpleObject(128,-18981,"vc2sa/dff/ci_offices.dff","vc2sa/txd/ci_studio6.txd");
AddVC2SASimpleObject(128,-18982,"vc2sa/dff/ci_gateway.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(128,-18983,"vc2sa/dff/ci_backdrop.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(0,-18984,"vc2sa/dff/ci_industrial1.dff","vc2sa/txd/ci_industrial.txd");
AddVC2SASimpleObject(128,-18985,"vc2sa/dff/ci_screening2.dff","vc2sa/txd/ci_studio6.txd");
AddVC2SASimpleObject(128,-18986,"vc2sa/dff/ci_kerb1.dff","vc2sa/txd/ci_studionew1.txd");
AddVC2SASimpleObject(128,-18987,"vc2sa/dff/ci_fence2.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(128,-18988,"vc2sa/dff/ci_backgateopen.dff","vc2sa/txd/ci_studio4.txd");
AddVC2SASimpleObject(0,-18989,"vc2sa/dff/ci_islandeast.dff","vc2sa/txd/ci_studionew1.txd");
AddVC2SASimpleObject(0,-18990,"vc2sa/dff/ci_islandnorth.dff","vc2sa/txd/ci_studionew1.txd");
AddVC2SASimpleObject(132,-18991,"vc2sa/dff/ci_graf_mansion3.dff","vc2sa/txd/ci_mansion1.txd");
AddVC2SASimpleObject(132,-18992,"vc2sa/dff/ci_graf_mansion1.dff","vc2sa/txd/ci_mansion1.txd");
AddVC2SASimpleObject(132,-18993,"vc2sa/dff/ci_posters.dff","vc2sa/txd/ci_posters.txd");
AddVC2SASimpleObject(132,-18994,"vc2sa/dff/ci_studwallgraf.dff","vc2sa/txd/ci_mansion1.txd");
AddVC2SASimpleObject(132,-18995,"vc2sa/dff/ci_graf_fountain.dff","vc2sa/txd/ci_mansion1.txd");
AddVC2SASimpleObject(128,-18996,"vc2sa/dff/ci_boards1.dff","vc2sa/txd/ci_mansion2.txd");
AddVC2SASimpleObject(128,-18997,"vc2sa/dff/ci_boards2.dff","vc2sa/txd/ci_mansion2.txd");
AddVC2SASimpleObject(132,-18998,"vc2sa/dff/ci_manscourt.dff","vc2sa/txd/ci_island3.txd");
AddVC2SASimpleObject(132,-18999,"vc2sa/dff/ci_poolhouse.dff","vc2sa/txd/ci_island3.txd");
AddVC2SASimpleObject(132,-19000,"vc2sa/dff/ci_poolwall1.dff","vc2sa/txd/ci_island3.txd");
AddVC2SASimpleObject(132,-19001,"vc2sa/dff/ci_poolsteps.dff","vc2sa/txd/ci_island3.txd");
AddVC2SASimpleObject(128,-19002,"vc2sa/dff/ci_jawsramp1.dff","vc2sa/txd/ci_studio3.txd");
AddVC2SASimpleObject(128,-19003,"vc2sa/dff/ci_backlot3.dff","vc2sa/txd/ci_backlot.txd");
AddVC2SASimpleObject(128,-19004,"vc2sa/dff/ci_backlot2.dff","vc2sa/txd/ci_backlot.txd");
AddVC2SASimpleObject(128,-19005,"vc2sa/dff/ci_backlot1.dff","vc2sa/txd/ci_backlot.txd");
AddVC2SASimpleObject(128,-19006,"vc2sa/dff/ci_backlotprops3.dff","vc2sa/txd/ci_pornset.txd");
AddVC2SASimpleObject(128,-19007,"vc2sa/dff/ci_backlotprops2.dff","vc2sa/txd/ci_pornset.txd");
AddVC2SASimpleObject(128,-19008,"vc2sa/dff/ci_backlotprops1.dff","vc2sa/txd/ci_pornset.txd");
AddVC2SASimpleObject(128,-19009,"vc2sa/dff/ci_dstageext.dff","vc2sa/txd/ci_studio3.txd");
AddVC2SASimpleObject(132,-19010,"vc2sa/dff/ci_dirtcorn3.dff","vc2sa/txd/ci_dirtcorn.txd");
AddVC2SASimpleObject(132,-19011,"vc2sa/dff/ci_dirtcorn4.dff","vc2sa/txd/ci_dirtcorn.txd");
AddVC2SASimpleObject(132,-19012,"vc2sa/dff/ci_dirtcorn1.dff","vc2sa/txd/ci_dirtcorn.txd");
AddVC2SASimpleObject(132,-19013,"vc2sa/dff/ci_mans1rail.dff","vc2sa/txd/ci_mansrails.txd");
AddVC2SASimpleObject(132,-19014,"vc2sa/dff/ci_mans2rail1.dff","vc2sa/txd/ci_mansrails.txd");
AddVC2SASimpleObject(132,-19015,"vc2sa/dff/ci_mansion3ballust.dff","vc2sa/txd/ci_ballust.txd");
AddVC2SASimpleObject(132,-19016,"vc2sa/dff/ci_dirtcorn2.dff","vc2sa/txd/ci_dirtcorn.txd");
AddVC2SASimpleObject(164,-19017,"vc2sa/dff/ci_mans1grafint.dff","vc2sa/txd/ci_mansionint1.txd");
AddVC2SASimpleObject(160,-19018,"vc2sa/dff/ci_mans1int.dff","vc2sa/txd/ci_mansionint1.txd");
AddVC2SASimpleObject(160,-19019,"vc2sa/dff/ci_mans1stair1.dff","vc2sa/txd/ci_mansionint1.txd");
AddVC2SASimpleObject(160,-19020,"vc2sa/dff/ci_mans1grndfl.dff","vc2sa/txd/ci_mansionint1.txd");
AddVC2SASimpleObject(160,-19021,"vc2sa/dff/ci_mans1istfl.dff","vc2sa/txd/ci_mansionint1.txd");
AddVC2SASimpleObject(160,-19022,"vc2sa/dff/ci_mans1stair2.dff","vc2sa/txd/ci_mansionint1.txd");
AddVC2SASimpleObject(164,-19023,"vc2sa/dff/ci_mans1rail1.dff","vc2sa/txd/ci_mansionint1.txd");
AddVC2SASimpleObject(160,-19024,"vc2sa/dff/ci_mans1roof.dff","vc2sa/txd/ci_mansionint1.txd");
AddVC2SASimpleObject(132,-19025,"vc2sa/dff/ci_officewindows.dff","vc2sa/txd/ci_studio6.txd");
AddVC2SASimpleObject(160,-19026,"vc2sa/dff/ci_dstage.dff","vc2sa/txd/ci_studio3.txd");
AddVC2SASimpleObject(160,-19027,"vc2sa/dff/ci_pornobed.dff","vc2sa/txd/ci_pornset.txd");
AddVC2SASimpleObject(160,-19028,"vc2sa/dff/ci_pornocarpet.dff","vc2sa/txd/ci_pornset.txd");
AddVC2SASimpleObject(160,-19029,"vc2sa/dff/ci_flatprop02.dff","vc2sa/txd/ci_pornset.txd");
AddVC2SASimpleObject(160,-19030,"vc2sa/dff/ci_camera1_01.dff","vc2sa/txd/ci_filmstuff1.txd");
AddVC2SASimpleObject(164,-19031,"vc2sa/dff/ci_dstageshad.dff","vc2sa/txd/ci_shadcay.txd");
AddVC2SASimpleObject(160,-19032,"vc2sa/dff/ci_pornset1.dff","vc2sa/txd/ci_pornset.txd");
AddVC2SASimpleObject(160,-19033,"vc2sa/dff/ci_flatprop01.dff","vc2sa/txd/ci_pornset.txd");
AddVC2SASimpleObject(160,-19034,"vc2sa/dff/ci_table1_01.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(164,-19035,"vc2sa/dff/ci_setshad1.dff","vc2sa/txd/ci_setstuff2.txd");
AddVC2SASimpleObject(128,-19036,"vc2sa/dff/ci_notice03.dff","vc2sa/txd/ci_filmstuff1.txd");
AddVC2SASimpleObject(160,-19037,"vc2sa/dff/ci_lights1_01.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(164,-19038,"vc2sa/dff/ci_dstudiogantry.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(164,-19039,"vc2sa/dff/ci_dstudlights.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(160,-19040,"vc2sa/dff/ci_lights1_02.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(164,-19041,"vc2sa/dff/ci_dstudganwal.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(128,-19042,"vc2sa/dff/ci_cstage.dff","vc2sa/txd/ci_studio2.txd");
AddVC2SASimpleObject(160,-19043,"vc2sa/dff/ci_cstageint.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(160,-19044,"vc2sa/dff/ci_Acyclorama.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(160,-19045,"vc2sa/dff/ci_shipset.dff","vc2sa/txd/ci_setstuff4.txd");
AddVC2SASimpleObject(160,-19046,"vc2sa/dff/ci_alights1_01.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(160,-19047,"vc2sa/dff/ci_astudlights.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(164,-19048,"vc2sa/dff/ci_astudganwal.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(164,-19049,"vc2sa/dff/ci_astagelights.dff","vc2sa/txd/ci_setstuff4.txd");
AddVC2SASimpleObject(160,-19050,"vc2sa/dff/nt_ladder_01.dff","vc2sa/txd/ci_setstuff4.txd");
AddVC2SASimpleObject(160,-19051,"vc2sa/dff/nt_ladder_02.dff","vc2sa/txd/ci_setstuff4.txd");
AddVC2SASimpleObject(160,-19052,"vc2sa/dff/ci_astageint.dff","vc2sa/txd/ci_studio2.txd");
AddVC2SASimpleObject(160,-19053,"vc2sa/dff/ci_Asteps.dff","vc2sa/txd/ci_setstuff4.txd");
AddVC2SASimpleObject(160,-19054,"vc2sa/dff/ci_astudiogantry.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(128,-19055,"vc2sa/dff/ci_extertank.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(160,-19056,"vc2sa/dff/ci_bcyclorama1.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(160,-19057,"vc2sa/dff/ci_blights1_01.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(164,-19058,"vc2sa/dff/ci_bstudiogantry.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(164,-19059,"vc2sa/dff/ci_bstudlights.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(164,-19060,"vc2sa/dff/ci_bstudganwal.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(128,-19061,"vc2sa/dff/ci_bstage.dff","vc2sa/txd/ci_studio2.txd");
AddVC2SASimpleObject(160,-19062,"vc2sa/dff/ci_bstageint.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(128,-19063,"vc2sa/dff/ci_moonsurface.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(164,-19064,"vc2sa/dff/ci_spaceflag.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(160,-19065,"vc2sa/dff/ci_lander.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(128,-19066,"vc2sa/dff/ci_windmach.dff","vc2sa/txd/ci_studio5.txd");
AddVC2SASimpleObject(132,-19067,"vc2sa/dff/ci_guardhouse1.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(128,-19068,"vc2sa/dff/ci_fountain.dff","vc2sa/txd/ci_mansion1.txd");
AddVC2SASimpleObject(132,-19069,"vc2sa/dff/props_group1.dff","vc2sa/txd/ci_studio5.txd");
AddVC2SASimpleObject(128,-19070,"vc2sa/dff/prop_group3.dff","vc2sa/txd/ci_studio5.txd");
AddVC2SASimpleObject(128,-19071,"vc2sa/dff/prop_group2.dff","vc2sa/txd/ci_studio5.txd");
AddVC2SASimpleObject(132,-19072,"vc2sa/dff/ci_manintstuff.dff","vc2sa/txd/ci_mansion1.txd");
AddVC2SASimpleObject(132,-19073,"vc2sa/dff/ci_gatesopen.dff","vc2sa/txd/ci_studio4.txd");
AddVC2SASimpleObject(128,-19074,"vc2sa/dff/ci_mansion1.dff","vc2sa/txd/ci_mansion1.txd");
AddVC2SASimpleObject(128,-19075,"vc2sa/dff/ci_mansion2.dff","vc2sa/txd/ci_mansion1.txd");
AddVC2SASimpleObject(128,-19076,"vc2sa/dff/ci_mansion3.dff","vc2sa/txd/ci_mansion1.txd");
AddVC2SASimpleObject(128,-19077,"vc2sa/dff/ci_seajetty.dff","vc2sa/txd/ci_studio2.txd");
AddVC2SASimpleObject(132,-19078,"vc2sa/dff/ci_jetygatesopen.dff","vc2sa/txd/ci_studio4.txd");
AddVC2SASimpleObject(132,-19079,"vc2sa/dff/ci_palettes.dff","vc2sa/txd/ci_mansion1.txd");
AddVC2SASimpleObject(164,-19080,"vc2sa/dff/ci_gobo1.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(160,-19081,"vc2sa/dff/ci_pornsetxtra.dff","vc2sa/txd/ci_pornset.txd");
AddVC2SASimpleObject(4,-19082,"vc2sa/dff/ci_stairsout01.dff","vc2sa/txd/ci_studionew1.txd");
AddVC2SASimpleObject(128,-19083,"vc2sa/dff/ci_rdsigns.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(128,-19084,"vc2sa/dff/ci_rdsigns01.dff","vc2sa/txd/ci_island1.txd");
AddVC2SASimpleObject(128,-19085,"vc2sa/dff/ci_tankship.dff","vc2sa/txd/ci_studio5.txd");
AddVC2SASimpleObject(128,-19086,"vc2sa/dff/ci_redhead1_01.dff","vc2sa/txd/ci_redhead.txd");
AddVC2SASimpleObject(160,-19087,"vc2sa/dff/ci_clightdesk.dff","vc2sa/txd/ci_setstuff1.txd");
AddVC2SASimpleObject(132,-19088,"vc2sa/dff/ci_windmach2.dff","vc2sa/txd/ci_studio5.txd");
AddVC2SASimpleObject(132,-19089,"vc2sa/dff/ci_trees1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19090,"vc2sa/dff/ci_planter1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19091,"vc2sa/dff/ci_planter2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19092,"vc2sa/dff/ci_trees02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19093,"vc2sa/dff/ci_busht_02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19094,"vc2sa/dff/ci_trees03.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19095,"vc2sa/dff/ci_busht_04.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19096,"vc2sa/dff/ci_busht_06.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19097,"vc2sa/dff/ci_busht_08.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19098,"vc2sa/dff/ci_trees04.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19099,"vc2sa/dff/ci_busht_11.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19100,"vc2sa/dff/ci_trees05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(132,21,5,-19101,"vc2sa/dff/ci_dstagelight.dff","vc2sa/txd/ci_shadnit.txd");
AddVC2SASimpleTimed(132,21,5,-19102,"vc2sa/dff/ci_astagelight1.dff","vc2sa/txd/ci_shadnit.txd");
AddVC2SASimpleTimed(132,21,5,-19103,"vc2sa/dff/ci_astagelight2.dff","vc2sa/txd/ci_shadnit.txd");
AddVC2SASimpleObject(32,-19104,"vc2sa/dff/mna_table_scrfce.dff","vc2sa/txd/starmansionst.txd");
AddVC2SASimpleObject(32,-19105,"vc2sa/dff/man_cellar1.dff","vc2sa/txd/man_cellar.txd");
AddVC2SASimpleObject(32,-19106,"vc2sa/dff/man_cellar2.dff","vc2sa/txd/man_cellar.txd");
AddVC2SASimpleObject(32,-19107,"vc2sa/dff/man_couch02.dff","vc2sa/txd/starmansionst.txd");
AddVC2SASimpleObject(36,-19108,"vc2sa/dff/man_chandeliers.dff","vc2sa/txd/starmansionst.txd");
AddVC2SASimpleObject(32,-19109,"vc2sa/dff/man_hall_floor.dff","vc2sa/txd/man_hall.txd");
AddVC2SASimpleObject(32,-19110,"vc2sa/dff/man_hall_pillars.dff","vc2sa/txd/man_hall.txd");
AddVC2SASimpleObject(36,-19111,"vc2sa/dff/man_hall_ref.dff","vc2sa/txd/man_hall.txd");
AddVC2SASimpleObject(32,-19112,"vc2sa/dff/man_hall_wall1.dff","vc2sa/txd/man_hall.txd");
AddVC2SASimpleObject(32,-19113,"vc2sa/dff/man_hallway1.dff","vc2sa/txd/man_hall_2.txd");
AddVC2SASimpleObject(32,-19114,"vc2sa/dff/man_hallway2.dff","vc2sa/txd/man_hall_2.txd");
AddVC2SASimpleObject(32,-19115,"vc2sa/dff/man_lights_pool.dff","vc2sa/txd/man_props.txd");
AddVC2SASimpleObject(32,-19116,"vc2sa/dff/man_monitor_base.dff","vc2sa/txd/man_props.txd");
AddVC2SASimpleObject(32,-19117,"vc2sa/dff/man_pool.dff","vc2sa/txd/man_pool2.txd");
AddVC2SASimpleObject(100,-19118,"vc2sa/dff/man_pool_shado1.dff","vc2sa/txd/man_pool_shado.txd");
AddVC2SASimpleObject(36,-19119,"vc2sa/dff/man_pool_water.dff","vc2sa/txd/man_pool1.txd");
AddVC2SASimpleObject(32,-19120,"vc2sa/dff/man_xchandeliers.dff","vc2sa/txd/starmansionst.txd");
AddVC2SASimpleObject(32,-19121,"vc2sa/dff/man_scar_curtains.dff","vc2sa/txd/starmansionst.txd");
AddVC2SASimpleObject(32,-19122,"vc2sa/dff/man_scar_propv.dff","vc2sa/txd/starmansionst.txd");
AddVC2SASimpleObject(32,-19123,"vc2sa/dff/man_scar_props206.dff","vc2sa/txd/starmansionst.txd");
AddVC2SASimpleObject(32,-19124,"vc2sa/dff/man_scrface_walls.dff","vc2sa/txd/man_scarface.txd");
AddVC2SASimpleObject(32,-19125,"vc2sa/dff/man_f_chandelier.dff","vc2sa/txd/starmansionst.txd");
AddVC2SASimpleObject(32,-19126,"vc2sa/dff/man_scrfce_floor1.dff","vc2sa/txd/man_scarface.txd");
AddVC2SASimpleObject(32,-19127,"vc2sa/dff/man_tablkb1.dff","vc2sa/txd/starmansionst.txd");
AddVC2SASimpleObject(32,-19128,"vc2sa/dff/man_scrfce_chstrset.dff","vc2sa/txd/starmansionst.txd");
AddVC2SASimpleObject(36,-19129,"vc2sa/dff/man_wtrftr_wtr1.dff","vc2sa/txd/man_wtr_ftr.txd");
AddVC2SASimpleObject(36,-19130,"vc2sa/dff/man_wtrftr_2.dff","vc2sa/txd/man_wtr_ftr.txd");
AddVC2SASimpleObject(132,-19131,"vc2sa/dff/man_wtrftr_3a.dff","vc2sa/txd/man_wtr_ftr.txd");
AddVC2SASimpleObject(0,-19132,"vc2sa/dff/many_polys.dff","vc2sa/txd/man_grnds_kb.txd");
AddVC2SASimpleObject(0,-19133,"vc2sa/dff/man_wtr_fill.dff","vc2sa/txd/manbackside.txd");
AddVC2SASimpleObject(128,-19134,"vc2sa/dff/man_frntstep.dff","vc2sa/txd/man_grnds_kb.txd");
AddVC2SASimpleObject(132,-19135,"vc2sa/dff/man_wtrftr_2a.dff","vc2sa/txd/man_wtr_ftr.txd");
AddVC2SASimpleObject(0,-19136,"vc2sa/dff/man_hedge1.dff","vc2sa/txd/man_veg_ext.txd");
AddVC2SASimpleObject(0,-19137,"vc2sa/dff/man_grnd5.dff","vc2sa/txd/man_grnds_kb.txd");
AddVC2SASimpleObject(0,-19138,"vc2sa/dff/man_grnd4.dff","vc2sa/txd/man_grnds_kb.txd");
AddVC2SASimpleObject(36,-19139,"vc2sa/dff/man_wtrftr_1a.dff","vc2sa/txd/man_wtr_ftr.txd");
AddVC2SASimpleObject(0,-19140,"vc2sa/dff/man_maze.dff","vc2sa/txd/man_veg_ext.txd");
AddVC2SASimpleObject(0,-19141,"vc2sa/dff/man_grnd6.dff","vc2sa/txd/man_grnds_kb.txd");
AddVC2SASimpleObject(0,-19142,"vc2sa/dff/man_grnd3.dff","vc2sa/txd/man_grnds_kb.txd");
AddVC2SASimpleObject(2097152,-19143,"vc2sa/dff/man_build04.dff","vc2sa/txd/mansion_new.txd");
AddVC2SASimpleObject(2097152,-19144,"vc2sa/dff/man_build01.dff","vc2sa/txd/mansion_new.txd");
AddVC2SASimpleObject(2097152,-19145,"vc2sa/dff/man_build02.dff","vc2sa/txd/mansion_new.txd");
AddVC2SASimpleObject(2097280,-19146,"vc2sa/dff/man_build03.dff","vc2sa/txd/mansion_new.txd");
AddVC2SASimpleObject(2097152,-19147,"vc2sa/dff/man_build05.dff","vc2sa/txd/mansion_new.txd");
AddVC2SASimpleObject(0,-19148,"vc2sa/dff/man_dooropen.dff","vc2sa/txd/mannewdoors.txd");
AddVC2SASimpleObject(4,-19149,"vc2sa/dff/man_build04_fnce.dff","vc2sa/txd/mansion_new.txd");
AddVC2SASimpleObject(128,-19150,"vc2sa/dff/man_backside.dff","vc2sa/txd/man_grnds_kb.txd");
AddVC2SASimpleObject(32,-19151,"vc2sa/dff/man_twr_stairs.dff","vc2sa/txd/man_twr.txd");
AddVC2SASimpleObject(32,-19152,"vc2sa/dff/man_sdr_seating.dff","vc2sa/txd/hi_cutsdrm_3.txd");
AddVC2SASimpleObject(32,-19153,"vc2sa/dff/man_sdr_tvstf.dff","vc2sa/txd/hi_cutsdrm_2.txd");
AddVC2SASimpleObject(32,-19154,"vc2sa/dff/man_sdr_strctur.dff","vc2sa/txd/hi_cutsdrm_1.txd");
AddVC2SASimpleObject(36,-19155,"vc2sa/dff/man_sdr_tables.dff","vc2sa/txd/hi_cutsdrm_2.txd");
AddVC2SASimpleObject(36,-19156,"vc2sa/dff/man_sdr_lamps.dff","vc2sa/txd/hi_cutsdrm_2.txd");
AddVC2SASimpleObject(32,-19157,"vc2sa/dff/man_sdr_tabls.dff","vc2sa/txd/hi_cutsdrm_2.txd");
AddVC2SASimpleObject(36,-19158,"vc2sa/dff/man_sdr_folge.dff","vc2sa/txd/hi_cutsdrm_3.txd");
AddVC2SASimpleObject(32,-19159,"vc2sa/dff/man_sdr_props.dff","vc2sa/txd/hi_cutsdrm_1.txd");
AddVC2SASimpleObject(32,-19160,"vc2sa/dff/man_sdr_rug.dff","vc2sa/txd/hi_cutsdrm_3.txd");
AddVC2SASimpleObject(36,-19161,"vc2sa/dff/man_sidrm_shad.dff","vc2sa/txd/hi_cutrshad.txd");
AddVC2SASimpleObject(4,-19162,"vc2sa/dff/drive_flowers06.dff","vc2sa/txd/manf.txd");
AddVC2SASimpleObject(36,-19163,"vc2sa/dff/scar_winglass.dff","vc2sa/txd/man_scarface.txd");
AddVC2SASimpleObject(32,-19164,"vc2sa/dff/man_safenew.dff","vc2sa/txd/hi_cutsafe.txd");
AddVC2SASimpleObject(36,-19165,"vc2sa/dff/man_safenewmny.dff","vc2sa/txd/hi_cutsafe.txd");
AddVC2SASimpleObject(32,-19166,"vc2sa/dff/man_safenewdr.dff","vc2sa/txd/hi_cutsafe.txd");
AddVC2SASimpleObject(0,-19167,"vc2sa/dff/many_polys2.dff","vc2sa/txd/man_grnds_kb.txd");
AddVC2SASimpleObject(128,-19168,"vc2sa/dff/man_backside2.dff","vc2sa/txd/man_grnds_kb.txd");
AddVC2SASimpleObject(2048,-19169,"vc2sa/dff/man_frntstepGD.dff","vc2sa/txd/man_grnds_kb.txd");
AddVC2SASimpleObject(128,-19170,"vc2sa/dff/manmrgbuild2.dff","vc2sa/txd/star1b.txd");
AddVC2SASimpleObject(4,-19171,"vc2sa/dff/mans_merge03.dff","vc2sa/txd/star1b.txd");
AddVC2SASimpleObject(0,-19172,"vc2sa/dff/manmrgbase1.dff","vc2sa/txd/star1b.txd");
AddVC2SASimpleObject(128,-19173,"vc2sa/dff/manmrgbuild1.dff","vc2sa/txd/star1b.txd");
AddVC2SASimpleObject(0,-19174,"vc2sa/dff/mans_merge07.dff","vc2sa/txd/star1b.txd");
AddVC2SASimpleObject(4,-19175,"vc2sa/dff/mans_merge09.dff","vc2sa/txd/manf.txd");
AddVC2SASimpleObject(0,-19176,"vc2sa/dff/stargatedetail.dff","vc2sa/txd/star1b.txd");
AddVC2SASimpleObject(0,-19177,"vc2sa/dff/man_grnd2.dff","vc2sa/txd/man_grnds_kb.txd");
AddVC2SASimpleObject(37,-19178,"vc2sa/dff/man_scrfashado.dff","vc2sa/txd/hi_cutmanshad.txd");
AddVC2SASimpleObject(132,-19179,"vc2sa/dff/Frame1Damaged.dff","vc2sa/txd/mansion_details2.txd");
AddVC2SASimpleObject(36,-19180,"vc2sa/dff/man_twr_stairsB.dff","vc2sa/txd/man_twr.txd");
AddVC2SASimpleObject(132,-19181,"vc2sa/dff/man_build03_al.dff","vc2sa/txd/mansion_new.txd");
AddVC2SASimpleObject(4,-19182,"vc2sa/dff/man_build02_al.dff","vc2sa/txd/mansion_new.txd");
AddVC2SASimpleObject(4,-19183,"vc2sa/dff/man_build01_al.dff","vc2sa/txd/mansion_new.txd");
AddVC2SASimpleObject(4,-19184,"vc2sa/dff/man_build05_al.dff","vc2sa/txd/mansion_new.txd");
AddVC2SASimpleObject(4,-19185,"vc2sa/dff/mansbushes.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-19186,"vc2sa/dff/mn_treesisl05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-19187,"vc2sa/dff/mansbushes2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(256,-19188,"vc2sa/dff/LODmrgtrees4.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-19189,"vc2sa/dff/washbuild005.dff","vc2sa/txd/newashbuild1.txd");
AddVC2SASimpleObject(128,-19190,"vc2sa/dff/washbuild014.dff","vc2sa/txd/washbuild124.txd");
AddVC2SASimpleObject(128,-19191,"vc2sa/dff/washbuild025.dff","vc2sa/txd/washnewbuild23.txd");
AddVC2SASimpleObject(128,-19192,"vc2sa/dff/wshbuildws07.dff","vc2sa/txd/washnewbuild2.txd");
AddVC2SASimpleObject(128,-19193,"vc2sa/dff/wshbuildws12.dff","vc2sa/txd/washnewbuild23.txd");
AddVC2SASimpleObject(128,-19194,"vc2sa/dff/wash_hosp02.dff","vc2sa/txd/wash_hosp.txd");
AddVC2SASimpleObject(128,-19195,"vc2sa/dff/wshbuildws16.dff","vc2sa/txd/washnewbuild5.txd");
AddVC2SASimpleObject(128,-19196,"vc2sa/dff/wshbuildws20.dff","vc2sa/txd/washbuild44.txd");
AddVC2SASimpleObject(128,-19197,"vc2sa/dff/washbuild062.dff","vc2sa/txd/washnewbuild3.txd");
AddVC2SASimpleObject(128,-19198,"vc2sa/dff/washbuild063.dff","vc2sa/txd/washnewbuild3.txd");
AddVC2SASimpleObject(128,-19199,"vc2sa/dff/washbuild068.dff","vc2sa/txd/washnewbuild21.txd");
AddVC2SASimpleObject(128,-19200,"vc2sa/dff/washbuild071.dff","vc2sa/txd/northbuild.txd");
AddVC2SASimpleObject(128,-19201,"vc2sa/dff/washbuild073.dff","vc2sa/txd/northbuild.txd");
AddVC2SASimpleObject(128,-19202,"vc2sa/dff/washbuild074.dff","vc2sa/txd/northbuild.txd");
AddVC2SASimpleObject(128,-19203,"vc2sa/dff/washbuild075.dff","vc2sa/txd/washnewbuild2.txd");
AddVC2SASimpleObject(0,-19204,"vc2sa/dff/wshnrthroad23.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19205,"vc2sa/dff/wshnrthroad27.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19206,"vc2sa/dff/wshnrthroad25.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19207,"vc2sa/dff/wshnrthroad24.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19208,"vc2sa/dff/wshnrthroad22.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19209,"vc2sa/dff/wshnrthroad18.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19210,"vc2sa/dff/wshnrthroad16.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19211,"vc2sa/dff/wshnrthroad17.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19212,"vc2sa/dff/wshnrthroad19.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19213,"vc2sa/dff/wshnrthroad15.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19214,"vc2sa/dff/wshnrthroad20.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19215,"vc2sa/dff/wshnrthroad21.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19216,"vc2sa/dff/wshbuildws26.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19217,"vc2sa/dff/wsh_roadswsh05.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19218,"vc2sa/dff/wsh_roadswsh04.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19219,"vc2sa/dff/wash_hospgrnd.dff","vc2sa/txd/wash_hosp.txd");
AddVC2SASimpleObject(0,-19220,"vc2sa/dff/wsh_roadswsh01.dff","vc2sa/txd/wash_hosp.txd");
AddVC2SASimpleObject(0,-19221,"vc2sa/dff/wshbuildws30.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19222,"vc2sa/dff/washbuild116.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19223,"vc2sa/dff/wshbuildws31.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19224,"vc2sa/dff/wshbuildws32.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19225,"vc2sa/dff/washbuild119.dff","vc2sa/txd/washbuild120.txd");
AddVC2SASimpleObject(0,-19226,"vc2sa/dff/washbuild120.dff","vc2sa/txd/washbuild120.txd");
AddVC2SASimpleObject(128,-19227,"vc2sa/dff/washbuild184.dff","vc2sa/txd/washnewbuild3.txd");
AddVC2SASimpleObject(128,-19228,"vc2sa/dff/wshbuildws38.dff","vc2sa/txd/washbuild120.txd");
AddVC2SASimpleObject(128,-19229,"vc2sa/dff/washbuild187.dff","vc2sa/txd/washbuild120.txd");
AddVC2SASimpleObject(0,-19230,"vc2sa/dff/wshbuildws40.dff","vc2sa/txd/washnewbuild5.txd");
AddVC2SASimpleObject(128,-19231,"vc2sa/dff/wshbuildws43.dff","vc2sa/txd/washmallnew.txd");
AddVC2SASimpleObject(128,-19232,"vc2sa/dff/washbuild198.dff","vc2sa/txd/washmallpark.txd");
AddVC2SASimpleObject(128,-19233,"vc2sa/dff/washbuild199.dff","vc2sa/txd/washmallnew.txd");
AddVC2SASimpleObject(0,-19234,"vc2sa/dff/washbuild200.dff","vc2sa/txd/washmallnew.txd");
AddVC2SASimpleObject(132,-19235,"vc2sa/dff/wash_pizzaplace.dff","vc2sa/txd/newashbuild1.txd");
AddVC2SASimpleObject(132,-19236,"vc2sa/dff/wash_hospital.dff","vc2sa/txd/wash_hosp.txd");
AddVC2SASimpleObject(128,-19237,"vc2sa/dff/wash_hosp03.dff","vc2sa/txd/wash_hosp.txd");
AddVC2SASimpleObject(128,-19238,"vc2sa/dff/carwashpole3.dff","vc2sa/txd/washnewbuild3.txd");
AddVC2SASimpleObject(128,-19239,"vc2sa/dff/carwashpole1.dff","vc2sa/txd/washnewbuild3.txd");
AddVC2SASimpleObject(0,-19240,"vc2sa/dff/washtooceanrd1.dff","vc2sa/txd/washroads.txd");
AddVC2SASimpleObject(128,-19241,"vc2sa/dff/wash_deco01.dff","vc2sa/txd/washmiamistrip4.txd");
AddVC2SASimpleObject(128,-19242,"vc2sa/dff/wash_deco02.dff","vc2sa/txd/washmiamistrip3.txd");
AddVC2SASimpleObject(128,-19243,"vc2sa/dff/wash_deco03.dff","vc2sa/txd/washmiamistrip2.txd");
AddVC2SASimpleObject(128,-19244,"vc2sa/dff/wash_deco04.dff","vc2sa/txd/washmiamistrip13.txd");
AddVC2SASimpleObject(128,-19245,"vc2sa/dff/wash_deco05.dff","vc2sa/txd/washmiamistrip11.txd");
AddVC2SASimpleObject(132,-19246,"vc2sa/dff/basketballcourt04.dff","vc2sa/txd/washbballcrt.txd");
AddVC2SASimpleObject(128,-19247,"vc2sa/dff/washnewsky1.dff","vc2sa/txd/washsky1.txd");
AddVC2SASimpleObject(128,-19248,"vc2sa/dff/washnewsky3.dff","vc2sa/txd/washsky1.txd");
AddVC2SASimpleObject(128,-19249,"vc2sa/dff/washnewsky2.dff","vc2sa/txd/washsky1.txd");
AddVC2SASimpleObject(128,-19250,"vc2sa/dff/washbuild003.dff","vc2sa/txd/newashbuild1.txd");
AddVC2SASimpleObject(128,-19251,"vc2sa/dff/washbuild072.dff","vc2sa/txd/northbuild.txd");
AddVC2SASimpleObject(128,-19252,"vc2sa/dff/wshbuildws43ins.dff","vc2sa/txd/washmallnew.txd");
AddVC2SASimpleObject(128,-19253,"vc2sa/dff/wash_brdgsup1.dff","vc2sa/txd/bridgeVC.txd");
AddVC2SASimpleObject(132,-19254,"vc2sa/dff/wshtelgrphcabl02.dff","vc2sa/txd/wshtelgrph.txd");
AddVC2SASimpleObject(132,-19255,"vc2sa/dff/wshtelgrphcabl03.dff","vc2sa/txd/wshtelgrph.txd");
AddVC2SASimpleObject(132,-19256,"vc2sa/dff/wshtelgrphcabl04.dff","vc2sa/txd/wshtelgrph.txd");
AddVC2SASimpleObject(132,-19257,"vc2sa/dff/wshtelgrphcabl05.dff","vc2sa/txd/wshtelgrph.txd");
AddVC2SASimpleObject(132,-19258,"vc2sa/dff/basketballcourt05.dff","vc2sa/txd/washbballcrt.txd");
AddVC2SASimpleObject(128,-19259,"vc2sa/dff/wshswimupbar.dff","vc2sa/txd/swimupbar.txd");
AddVC2SASimpleObject(132,-19260,"vc2sa/dff/wshswmupstuf.dff","vc2sa/txd/swimupbar.txd");
AddVC2SASimpleObject(128,-19261,"vc2sa/dff/wshhotelawn1.dff","vc2sa/txd/washnewbuild5.txd");
AddVC2SASimpleObject(132,-19262,"vc2sa/dff/wshhotelwater1.dff","vc2sa/txd/wshbuildws40.txd");
AddVC2SASimpleObject(132,-19263,"vc2sa/dff/washfence1.dff","vc2sa/txd/washfence128.txd");
AddVC2SASimpleObject(132,-19264,"vc2sa/dff/washfence2.dff","vc2sa/txd/washfence128.txd");
AddVC2SASimpleObject(128,-19265,"vc2sa/dff/washawninga1.dff","vc2sa/txd/washnewbuild2.txd");
AddVC2SASimpleObject(128,-19266,"vc2sa/dff/washawning2b.dff","vc2sa/txd/washnewbuild2.txd");
AddVC2SASimpleObject(128,-19267,"vc2sa/dff/wshbuildws19.dff","vc2sa/txd/washnewbuild1.txd");
AddVC2SASimpleObject(128,-19268,"vc2sa/dff/wshbuil19wall.dff","vc2sa/txd/washnewbuild1.txd");
AddVC2SASimpleObject(132,-19269,"vc2sa/dff/woshmallglas1.dff","vc2sa/txd/woshmalglas.txd");
AddVC2SASimpleObject(132,-19270,"vc2sa/dff/woshmallglas2.dff","vc2sa/txd/woshmalglas.txd");
AddVC2SASimpleObject(132,-19271,"vc2sa/dff/woshmalmarkings.dff","vc2sa/txd/wshmolmrk.txd");
AddVC2SASimpleObject(132,-19272,"vc2sa/dff/woshmaldirt1.dff","vc2sa/txd/wshbuildirt.txd");
AddVC2SASimpleObject(0,-19273,"vc2sa/dff/wshnrthroad01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19274,"vc2sa/dff/wshnrthroad02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19275,"vc2sa/dff/wshnrthroad03.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19276,"vc2sa/dff/wshnrthroad04.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19277,"vc2sa/dff/wshnrthroad05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19278,"vc2sa/dff/wshnrthroad06.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19279,"vc2sa/dff/wshnrthroad07.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19280,"vc2sa/dff/wshnrthroad08.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19281,"vc2sa/dff/wshnrthroad09.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19282,"vc2sa/dff/wshnrthroad10.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19283,"vc2sa/dff/wshnrthroad11.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19284,"vc2sa/dff/wshnrthroad12.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19285,"vc2sa/dff/wshnrthroad13.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19286,"vc2sa/dff/wshbuildws312.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19287,"vc2sa/dff/wshbuildws322.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(128,-19288,"vc2sa/dff/wshbuildws09.dff","vc2sa/txd/northbuild.txd");
AddVC2SASimpleObject(0,-19289,"vc2sa/dff/wshmalsign1.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19290,"vc2sa/dff/wshmalsign3.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19291,"vc2sa/dff/wshmalsign2.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19292,"vc2sa/dff/wshmalsign4.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19293,"vc2sa/dff/wshmalsign5.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(132,-19294,"vc2sa/dff/ggsalonsign1.dff","vc2sa/txd/newashbuild1.txd");
AddVC2SASimpleObject(4,-19295,"vc2sa/dff/cokpoolwater.dff","vc2sa/txd/washwater.txd");
AddVC2SASimpleObject(0,-19296,"vc2sa/dff/wshnrthroad28.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19297,"vc2sa/dff/wshbuildws264.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(0,-19298,"vc2sa/dff/wshnrthroad26.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19299,"vc2sa/dff/wshnrthroad14.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-19300,"vc2sa/dff/wshbuildws43ins2.dff","vc2sa/txd/washmallnew.txd");
AddVC2SASimpleObject(128,-19301,"vc2sa/dff/carwashsign1.dff","vc2sa/txd/washnewbuild3.txd");
AddVC2SASimpleObject(0,-19302,"vc2sa/dff/wshnrthpstr1.dff","vc2sa/txd/washnrthpstr1.txd");
AddVC2SASimpleObject(0,-19303,"vc2sa/dff/wshnrthpstr02.dff","vc2sa/txd/washnrthpstr1.txd");
AddVC2SASimpleObject(0,-19304,"vc2sa/dff/wshnrthpstr03.dff","vc2sa/txd/washnrthpstr1.txd");
AddVC2SASimpleObject(0,-19305,"vc2sa/dff/wshnrthpstr05.dff","vc2sa/txd/washnrthpstr1.txd");
AddVC2SASimpleObject(0,-19306,"vc2sa/dff/wshnrthpstr07.dff","vc2sa/txd/washnrthpstr1.txd");
AddVC2SASimpleObject(132,-19307,"vc2sa/dff/washmallwater.dff","vc2sa/txd/washmallnew.txd");
AddVC2SASimpleObject(4,-19308,"vc2sa/dff/wshmoundlaw1.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(4,-19309,"vc2sa/dff/wshbldws26bit.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(128,-19310,"vc2sa/dff/wtn_roadsigns01.dff","vc2sa/txd/washlandb.txd");
AddVC2SASimpleObject(128,-19311,"vc2sa/dff/washpshoutdet.dff","vc2sa/txd/washmallnew.txd");
AddVC2SASimpleObject(0,-19312,"vc2sa/dff/wash_deco042.dff","vc2sa/txd/washmiamistrip13.txd");
AddVC2SASimpleObject(0,-19313,"vc2sa/dff/wash_deco032.dff","vc2sa/txd/washmiamistrip2.txd");
AddVC2SASimpleObject(0,-19314,"vc2sa/dff/wash_deco022.dff","vc2sa/txd/washmiamistrip3.txd");
AddVC2SASimpleObject(0,-19315,"vc2sa/dff/wash_deco012.dff","vc2sa/txd/washmiamistrip4.txd");
AddVC2SASimpleObject(128,-19316,"vc2sa/dff/carwashpole2.dff","vc2sa/txd/washnewbuild3.txd");
AddVC2SASimpleObject(132,-19317,"vc2sa/dff/wshotelveg1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19318,"vc2sa/dff/nrth4veg08.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19319,"vc2sa/dff/nrth4veg09.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19320,"vc2sa/dff/nrth3veg50.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19321,"vc2sa/dff/nrth3veg59.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19322,"vc2sa/dff/nrth7veg09.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19323,"vc2sa/dff/nrth3veg35.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19324,"vc2sa/dff/nrth1veg37.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19325,"vc2sa/dff/washpshoutveg.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19326,"vc2sa/dff/washbuild201.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19327,"vc2sa/dff/washbuild202.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19328,"vc2sa/dff/nrth4veg21.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19329,"vc2sa/dff/nrth4veg212.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19330,"vc2sa/dff/nrth1veg42.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19331,"vc2sa/dff/nrth4veg05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19332,"vc2sa/dff/nrth3veg05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19333,"vc2sa/dff/nrth3veg08.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19334,"vc2sa/dff/nrth3veg16.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19335,"vc2sa/dff/nrth7veg.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19336,"vc2sa/dff/nrth1veg21.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19337,"vc2sa/dff/nrth3veg25.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19338,"vc2sa/dff/washskyplant1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19339,"vc2sa/dff/washskyplant2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(12,22,5,-19340,"vc2sa/dff/wshmallneon.dff","vc2sa/txd/wshneon.txd");
AddVC2SASimpleTimed(12,22,5,-19341,"vc2sa/dff/washgasneon.dff","vc2sa/txd/wshneon.txd");
AddVC2SASimpleTimed(12,22,5,-19342,"vc2sa/dff/washgasneon01.dff","vc2sa/txd/wshneon.txd");
AddVC2SASimpleTimed(12,22,5,-19343,"vc2sa/dff/washgasneon02.dff","vc2sa/txd/wshneon.txd");
AddVC2SASimpleObject(128,-19344,"vc2sa/dff/washgaspump_fix.dff","vc2sa/txd/wshxrefpump.txd");
AddVC2SASimpleTimed(12,22,5,-19345,"vc2sa/dff/washotelneon1.dff","vc2sa/txd/wshneon.txd");
AddVC2SASimpleTimed(12,22,5,-19346,"vc2sa/dff/washbuild025neon.dff","vc2sa/txd/wshneon.txd");
AddVC2SASimpleTimed(12,22,5,-19347,"vc2sa/dff/woshmalneon2.dff","vc2sa/txd/wshneon.txd");
AddVC2SASimpleTimed(12,22,5,-19348,"vc2sa/dff/ggneonsign2.dff","vc2sa/txd/wshneon.txd");
AddVC2SASimpleObject(128,-19349,"vc2sa/dff/wshbuildws02.dff","vc2sa/txd/wshsthbuild1.txd");
AddVC2SASimpleObject(128,-19350,"vc2sa/dff/washbuild013.dff","vc2sa/txd/wshsthbuild1.txd");
AddVC2SASimpleObject(132,-19351,"vc2sa/dff/washbuild015.dff","vc2sa/txd/wash_ammu.txd");
AddVC2SASimpleObject(128,-19352,"vc2sa/dff/wshbuildws03.dff","vc2sa/txd/washbuild13.txd");
AddVC2SASimpleObject(128,-19353,"vc2sa/dff/washbuild017.dff","vc2sa/txd/washbuild15.txd");
AddVC2SASimpleObject(128,-19354,"vc2sa/dff/washbuild018.dff","vc2sa/txd/washbuild43.txd");
AddVC2SASimpleObject(128,-19355,"vc2sa/dff/wshbuildws04.dff","vc2sa/txd/washnewbuild6.txd");
AddVC2SASimpleObject(128,-19356,"vc2sa/dff/washbuild020.dff","vc2sa/txd/washbuild43.txd");
AddVC2SASimpleObject(128,-19357,"vc2sa/dff/washbuild021.dff","vc2sa/txd/washbuild5.txd");
AddVC2SASimpleObject(128,-19358,"vc2sa/dff/wshbuildws05.dff","vc2sa/txd/washnewbuild6.txd");
AddVC2SASimpleObject(128,-19359,"vc2sa/dff/wshbuildws06.dff","vc2sa/txd/swashnwbuild5.txd");
AddVC2SASimpleObject(128,-19360,"vc2sa/dff/wshbuildws08.dff","vc2sa/txd/washbuild6.txd");
AddVC2SASimpleObject(128,-19361,"vc2sa/dff/washbuild030.dff","vc2sa/txd/washrestone.txd");
AddVC2SASimpleObject(128,-19362,"vc2sa/dff/wshbuildws10.dff","vc2sa/txd/washnewbuild25.txd");
AddVC2SASimpleObject(128,-19363,"vc2sa/dff/washbuild033.dff","vc2sa/txd/washbuild5.txd");
AddVC2SASimpleObject(128,-19364,"vc2sa/dff/washbuild039.dff","vc2sa/txd/washnewbuild24.txd");
AddVC2SASimpleObject(128,-19365,"vc2sa/dff/washbuild040.dff","vc2sa/txd/washbuild15.txd");
AddVC2SASimpleObject(128,-19366,"vc2sa/dff/wshbuildws14.dff","vc2sa/txd/washbuild41.txd");
AddVC2SASimpleObject(128,-19367,"vc2sa/dff/wshbuildws17.dff","vc2sa/txd/washotel2.txd");
AddVC2SASimpleObject(128,-19368,"vc2sa/dff/wshbuildws18.dff","vc2sa/txd/washotel2.txd");
AddVC2SASimpleObject(128,-19369,"vc2sa/dff/washbuild050.dff","vc2sa/txd/washnewbuild6.txd");
AddVC2SASimpleObject(128,-19370,"vc2sa/dff/wshbuildws21.dff","vc2sa/txd/swashnwbuild5.txd");
AddVC2SASimpleObject(128,-19371,"vc2sa/dff/washbuild058.dff","vc2sa/txd/washcorn2.txd");
AddVC2SASimpleObject(128,-19372,"vc2sa/dff/wshbuildws22.dff","vc2sa/txd/wslawyers.txd");
AddVC2SASimpleObject(128,-19373,"vc2sa/dff/washbuild066.dff","vc2sa/txd/washnewbuild25.txd");
AddVC2SASimpleObject(128,-19374,"vc2sa/dff/washbuild069.dff","vc2sa/txd/washbuild43.txd");
AddVC2SASimpleObject(128,-19375,"vc2sa/dff/wshbuildws24.dff","vc2sa/txd/wslawyers.txd");
AddVC2SASimpleObject(128,-19376,"vc2sa/dff/wshbuildws25.dff","vc2sa/txd/washnewbuild6.txd");
AddVC2SASimpleObject(0,-19377,"vc2sa/dff/washbuild081.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19378,"vc2sa/dff/str_new01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19379,"vc2sa/dff/wshsthroad02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19380,"vc2sa/dff/wshsthroad03.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19381,"vc2sa/dff/wshsthroad04.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19382,"vc2sa/dff/wshsthroad05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19383,"vc2sa/dff/wshsthroad06.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19384,"vc2sa/dff/wshsthroad07.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19385,"vc2sa/dff/wshsthroad08.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19386,"vc2sa/dff/wshsthroad09.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19387,"vc2sa/dff/wshsthroad10.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19388,"vc2sa/dff/washbuild111.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(4,-19389,"vc2sa/dff/washbuild112.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19390,"vc2sa/dff/wshbuildws29.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19391,"vc2sa/dff/washbuild114.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(4,-19392,"vc2sa/dff/washbuild121.dff","vc2sa/txd/swashlandb.txd");
AddVC2SASimpleObject(0,-19393,"vc2sa/dff/wshbuildws33.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19394,"vc2sa/dff/wshbuildws36.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(0,-19395,"vc2sa/dff/wshbuildws41.dff","vc2sa/txd/swashlandb.txd");
AddVC2SASimpleObject(4,-19396,"vc2sa/dff/washbuild191.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(4,-19397,"vc2sa/dff/washbuild192.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19398,"vc2sa/dff/wshbuildws42.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19399,"vc2sa/dff/washbuild194.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19400,"vc2sa/dff/washbuild195.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(4,-19401,"vc2sa/dff/washbuild203.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19402,"vc2sa/dff/wshbuildws45.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19403,"vc2sa/dff/washbuild206.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19404,"vc2sa/dff/wsh_roadswsh28.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(128,-19405,"vc2sa/dff/washbuild043.dff","vc2sa/txd/washnewbuild24.txd");
AddVC2SASimpleObject(128,-19406,"vc2sa/dff/washbuild210.dff","vc2sa/txd/washnewbuild24.txd");
AddVC2SASimpleObject(0,-19407,"vc2sa/dff/washbuild213.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(0,-19408,"vc2sa/dff/washbuild214.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(0,-19409,"vc2sa/dff/washbuild215.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(0,-19410,"vc2sa/dff/washbuild216.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(0,-19411,"vc2sa/dff/washbuild217.dff","vc2sa/txd/marinacpark.txd");
AddVC2SASimpleObject(128,-19412,"vc2sa/dff/wslawyersfront.dff","vc2sa/txd/wslawyers.txd");
AddVC2SASimpleObject(128,-19413,"vc2sa/dff/wshbuildws2326.dff","vc2sa/txd/swashnwbuild5.txd");
AddVC2SASimpleObject(128,-19414,"vc2sa/dff/wshbuildws23.dff","vc2sa/txd/wshsthbuild1.txd");
AddVC2SASimpleObject(0,-19415,"vc2sa/dff/svehsebuild1.dff","vc2sa/txd/washotel2.txd");
AddVC2SASimpleObject(0,-19416,"vc2sa/dff/washbitsnew04.dff","vc2sa/txd/washbuild41.txd");
AddVC2SASimpleObject(0,-19417,"vc2sa/dff/washbitsnew03.dff","vc2sa/txd/washbuild41.txd");
AddVC2SASimpleObject(0,-19418,"vc2sa/dff/marina1.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(0,-19419,"vc2sa/dff/marina2.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(0,-19420,"vc2sa/dff/marina3.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(2048,-19421,"vc2sa/dff/svegrgedoor.dff","vc2sa/txd/washsfehse.txd");
AddVC2SASimpleObject(128,-19422,"vc2sa/dff/washawning1.dff","vc2sa/txd/washshops1.txd");
AddVC2SASimpleObject(0,-19423,"vc2sa/dff/stiltsville03.dff","vc2sa/txd/stilty.txd");
AddVC2SASimpleObject(0,-19424,"vc2sa/dff/wshbuildws44.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(132,-19425,"vc2sa/dff/wshtelgrphcabl06.dff","vc2sa/txd/swshtelgrph.txd");
AddVC2SASimpleObject(132,-19426,"vc2sa/dff/wshtelgrphcabl01.dff","vc2sa/txd/swshtelgrph.txd");
AddVC2SASimpleObject(132,-19427,"vc2sa/dff/wshtelgrphcabl07.dff","vc2sa/txd/swshtelgrph.txd");
AddVC2SASimpleObject(132,-19428,"vc2sa/dff/wshtelgrphcabl08.dff","vc2sa/txd/swshtelgrph.txd");
AddVC2SASimpleObject(132,-19429,"vc2sa/dff/wshtelgrphcabl09.dff","vc2sa/txd/swshtelgrph.txd");
AddVC2SASimpleObject(132,-19430,"vc2sa/dff/wshtelgrphcabl10.dff","vc2sa/txd/swshtelgrph.txd");
AddVC2SASimpleObject(132,-19431,"vc2sa/dff/wshtelgrphcabl11.dff","vc2sa/txd/swshtelgrph.txd");
AddVC2SASimpleObject(0,-19432,"vc2sa/dff/wshbuildws2329.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(132,-19433,"vc2sa/dff/pierentrance1.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(132,-19434,"vc2sa/dff/pierentrance02.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(4,-19435,"vc2sa/dff/marinafence01.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(4,-19436,"vc2sa/dff/marinafence02.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(4,-19437,"vc2sa/dff/marinafence03.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(4,-19438,"vc2sa/dff/marinafence04.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(4,-19439,"vc2sa/dff/marinafence05.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(132,-19440,"vc2sa/dff/wshtelwter1.dff","vc2sa/txd/swashlandb.txd");
AddVC2SASimpleObject(128,-19441,"vc2sa/dff/washundermall1.dff","vc2sa/txd/wslawyers.txd");
AddVC2SASimpleObject(36,-19442,"vc2sa/dff/washdirtbuild1.dff","vc2sa/txd/washbuild5.txd");
AddVC2SASimpleObject(128,-19443,"vc2sa/dff/wshbuildws13.dff","vc2sa/txd/washbuild6.txd");
AddVC2SASimpleObject(160,-19444,"vc2sa/dff/scarinterior1.dff","vc2sa/txd/scarinterior.txd");
AddVC2SASimpleObject(132,-19445,"vc2sa/dff/wshcrprtstuf1.dff","vc2sa/txd/wshcrprkstuf.txd");
AddVC2SASimpleObject(132,-19446,"vc2sa/dff/washcrprkdirt1.dff","vc2sa/txd/wshcrprkdrt.txd");
AddVC2SASimpleObject(132,-19447,"vc2sa/dff/wshcrprtstuf2.dff","vc2sa/txd/wshcrprkstuf.txd");
AddVC2SASimpleObject(132,-19448,"vc2sa/dff/wshcarprksign.dff","vc2sa/txd/wshcrprkstuf.txd");
AddVC2SASimpleObject(4,-19449,"vc2sa/dff/washrafalpha.dff","vc2sa/txd/washnewbuild25.txd");
AddVC2SASimpleObject(128,-19450,"vc2sa/dff/rafaelsign1.dff","vc2sa/txd/washnewbuild25.txd");
AddVC2SASimpleObject(0,-19451,"vc2sa/dff/wshchurchwal.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19452,"vc2sa/dff/wsgbuildwl97.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19453,"vc2sa/dff/str_new02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19454,"vc2sa/dff/str_new03.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19455,"vc2sa/dff/str_new04.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19456,"vc2sa/dff/wshsthroad14.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19457,"vc2sa/dff/wshsthroad15.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19458,"vc2sa/dff/wshsthroad16.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19459,"vc2sa/dff/wshsthroad17.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19460,"vc2sa/dff/wshsthroad18.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19461,"vc2sa/dff/wshsthroad19.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19462,"vc2sa/dff/wshsthroad20.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19463,"vc2sa/dff/wshsthroad21.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19464,"vc2sa/dff/wshsthroad22.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19465,"vc2sa/dff/wshsthroad23.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19466,"vc2sa/dff/wshsthroad24.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19467,"vc2sa/dff/wshscarland226.dff","vc2sa/txd/swashlandb.txd");
AddVC2SASimpleObject(132,-19468,"vc2sa/dff/strpclubsigns1.dff","vc2sa/txd/strpclbsgns.txd");
AddVC2SASimpleObject(68,-19469,"vc2sa/dff/wshundercrprk27.dff","vc2sa/txd/wshcrprkstuf.txd");
AddVC2SASimpleObject(128,-19470,"vc2sa/dff/washpaynspray.dff","vc2sa/txd/washbuild13.txd");
AddVC2SASimpleObject(2048,-19471,"vc2sa/dff/wshpnsdoor.dff","vc2sa/txd/wshsprayshp.txd");
AddVC2SASimpleObject(0,-19472,"vc2sa/dff/ticketbooth1.dff","vc2sa/txd/marinacpark.txd");
AddVC2SASimpleObject(0,-19473,"vc2sa/dff/wshprkbarrier1.dff","vc2sa/txd/marinacpark.txd");
AddVC2SASimpleObject(128,-19474,"vc2sa/dff/wshprkbarrier2.dff","vc2sa/txd/washcpark2.txd");
AddVC2SASimpleObject(128,-19475,"vc2sa/dff/ticketbooth2.dff","vc2sa/txd/washcpark2.txd");
AddVC2SASimpleObject(0,-19476,"vc2sa/dff/pooladder.dff","vc2sa/txd/swashlandb.txd");
AddVC2SASimpleObject(0,-19477,"vc2sa/dff/divingboard.dff","vc2sa/txd/swashlandb.txd");
AddVC2SASimpleObject(36,-19478,"vc2sa/dff/scarinterblood1.dff","vc2sa/txd/scarinterior.txd");
AddVC2SASimpleObject(132,-19479,"vc2sa/dff/poolwaterwshs.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19480,"vc2sa/dff/pooladder01.dff","vc2sa/txd/swashlandb.txd");
AddVC2SASimpleObject(0,-19481,"vc2sa/dff/wshbuildws28.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19482,"vc2sa/dff/wshbuildws27.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19483,"vc2sa/dff/wshbuildws35.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19484,"vc2sa/dff/wshcokland.dff","vc2sa/txd/wshcoklnd.txd");
AddVC2SASimpleObject(0,-19485,"vc2sa/dff/marinasign2.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(0,-19486,"vc2sa/dff/marinasign1.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(128,-19487,"vc2sa/dff/wshgarage1.dff","vc2sa/txd/wshgarage1.txd");
AddVC2SASimpleObject(128,-19488,"vc2sa/dff/wshgarage02.dff","vc2sa/txd/wshgarage1.txd");
AddVC2SASimpleObject(128,-19489,"vc2sa/dff/wshgarage03.dff","vc2sa/txd/wshgarage1.txd");
AddVC2SASimpleObject(0,-19490,"vc2sa/dff/washbuild0812.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19491,"vc2sa/dff/wshbuildws332.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19492,"vc2sa/dff/marinaplanter1.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(0,-19493,"vc2sa/dff/marinaplanter2.dff","vc2sa/txd/washmarina.txd");
AddVC2SASimpleObject(164,-19494,"vc2sa/dff/washdirtbuild02.dff","vc2sa/txd/swashnwbuild5.txd");
AddVC2SASimpleObject(128,-19495,"vc2sa/dff/wshotelsign35.dff","vc2sa/txd/wshotelsign35.txd");
AddVC2SASimpleObject(132,-19496,"vc2sa/dff/scarbuildglas.dff","vc2sa/txd/washbuild7.txd");
AddVC2SASimpleObject(4,-19497,"vc2sa/dff/washbld195fenc.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(2097152,-19498,"vc2sa/dff/stiltsville05.dff","vc2sa/txd/stilty.txd");
AddVC2SASimpleObject(132,-19499,"vc2sa/dff/washelipad.dff","vc2sa/txd/washrestone.txd");
AddVC2SASimpleObject(0,-19500,"vc2sa/dff/wshsthpstr02.dff","vc2sa/txd/washsthpstr.txd");
AddVC2SASimpleObject(0,-19501,"vc2sa/dff/wshsthpstr03.dff","vc2sa/txd/washsthpstr.txd");
AddVC2SASimpleObject(0,-19502,"vc2sa/dff/wshsthpstr04.dff","vc2sa/txd/washsthpstr.txd");
AddVC2SASimpleObject(0,-19503,"vc2sa/dff/wshsthpstr05.dff","vc2sa/txd/washsthpstr.txd");
AddVC2SASimpleObject(132,-19504,"vc2sa/dff/washfntinwtr.dff","vc2sa/txd/washland.txd");
AddVC2SASimpleObject(0,-19505,"vc2sa/dff/stiltsville1.dff","vc2sa/txd/stilty.txd");
AddVC2SASimpleObject(4,-19506,"vc2sa/dff/ticketbooth1a.dff","vc2sa/txd/marinacpark.txd");
AddVC2SASimpleObject(132,-19507,"vc2sa/dff/washbuild041.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19508,"vc2sa/dff/washvegy241.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19509,"vc2sa/dff/washvegy238.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19510,"vc2sa/dff/washvegy242.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19511,"vc2sa/dff/washvegy237.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19512,"vc2sa/dff/washvegy240.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19513,"vc2sa/dff/washvegy2413.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-19514,"vc2sa/dff/washbuild231.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-19515,"vc2sa/dff/washbuild05067.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19516,"vc2sa/dff/washvegy2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19517,"vc2sa/dff/washvegy3.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-19518,"vc2sa/dff/marinaveg1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-19519,"vc2sa/dff/marinaveg2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-19520,"vc2sa/dff/marinaveg3.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19521,"vc2sa/dff/washvegy239.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(12,22,5,-19522,"vc2sa/dff/wshneon.dff","vc2sa/txd/swshneon.txd");
AddVC2SASimpleTimed(12,22,5,-19523,"vc2sa/dff/washdeconeon1.dff","vc2sa/txd/swshneon.txd");
AddVC2SASimpleTimed(12,22,5,-19524,"vc2sa/dff/wshbuildneon9.dff","vc2sa/txd/swshneon.txd");
AddVC2SASimpleTimed(12,22,5,-19525,"vc2sa/dff/undermallneon.dff","vc2sa/txd/swshneon.txd");
AddVC2SASimpleTimed(12,22,5,-19526,"vc2sa/dff/rafelneonsgn.dff","vc2sa/txd/rafneonsign.txd");
AddVC2SASimpleTimed(12,22,5,-19527,"vc2sa/dff/wshpspryneon1.dff","vc2sa/txd/swshneon.txd");
AddVC2SASimpleTimed(128,5,22,-19528,"vc2sa/dff/wshpnssignday_dy.dff","vc2sa/txd/wshsprayshp.txd");
AddVC2SASimpleTimed(128,22,5,-19529,"vc2sa/dff/wshpnssignight_nt.dff","vc2sa/txd/wshsprayshp.txd");
AddVC2SASimpleTimed(12,22,5,-19530,"vc2sa/dff/newashneon245.dff","vc2sa/txd/swshneon.txd");
AddVC2SASimpleObject(0,-19531,"vc2sa/dff/nbeachroads01.dff","vc2sa/txd/nbeachwgen.txd");
AddVC2SASimpleObject(0,-19532,"vc2sa/dff/nbeachroads02.dff","vc2sa/txd/nbeachwgen.txd");
AddVC2SASimpleObject(0,-19533,"vc2sa/dff/nbeachroads03.dff","vc2sa/txd/nbeachwgen.txd");
AddVC2SASimpleObject(4,-19534,"vc2sa/dff/starbits13.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(128,-19535,"vc2sa/dff/starbits22.dff","vc2sa/txd/starbits22.txd");
AddVC2SASimpleObject(128,-19536,"vc2sa/dff/starbits24.dff","vc2sa/txd/starbits24.txd");
AddVC2SASimpleObject(128,-19537,"vc2sa/dff/starbits17.dff","vc2sa/txd/starbits17.txd");
AddVC2SASimpleObject(128,-19538,"vc2sa/dff/starbits06.dff","vc2sa/txd/starbits06.txd");
AddVC2SASimpleObject(128,-19539,"vc2sa/dff/starbits05.dff","vc2sa/txd/nbeachwgen.txd");
AddVC2SASimpleObject(128,-19540,"vc2sa/dff/const_woodfence30.dff","vc2sa/txd/buildsiteVC.txd");
AddVC2SASimpleObject(128,-19541,"vc2sa/dff/buildingground40.dff","vc2sa/txd/buildsiteVC.txd");
AddVC2SASimpleObject(128,-19542,"vc2sa/dff/buildingground50.dff","vc2sa/txd/buildsiteVC.txd");
AddVC2SASimpleObject(128,-19543,"vc2sa/dff/starbits45.dff","vc2sa/txd/starvillas01.txd");
AddVC2SASimpleObject(128,-19544,"vc2sa/dff/starbits46.dff","vc2sa/txd/starvillas01.txd");
AddVC2SASimpleObject(0,-19545,"vc2sa/dff/nw_nbwroad01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-19546,"vc2sa/dff/starwaterfrnt05.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(128,-19547,"vc2sa/dff/starwaterfrnt06.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(0,-19548,"vc2sa/dff/starwaterfrnt09.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(4,-19549,"vc2sa/dff/starwaterfrnt10.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(4,-19550,"vc2sa/dff/starwaterfrnt11.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(4,-19551,"vc2sa/dff/starwaterfrnt12.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(128,-19552,"vc2sa/dff/nbt_htlpoolbase02.dff","vc2sa/txd/nbt_htlpoolbase.txd");
AddVC2SASimpleObject(0,-19553,"vc2sa/dff/nw_nbwroad04.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-19554,"vc2sa/dff/starblocks02.dff","vc2sa/txd/sta_pinkblock.txd");
AddVC2SASimpleObject(128,-19555,"vc2sa/dff/starblocks03.dff","vc2sa/txd/sta_pinkblock.txd");
AddVC2SASimpleObject(0,-19556,"vc2sa/dff/nw_nbwroad06.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-19557,"vc2sa/dff/starblocks04.dff","vc2sa/txd/starbuildsite.txd");
AddVC2SASimpleObject(4,-19558,"vc2sa/dff/starscaffold_pole.dff","vc2sa/txd/starbuildsite.txd");
AddVC2SASimpleObject(2097280,-19559,"vc2sa/dff/buildingsite2.dff","vc2sa/txd/buildingsite2.txd");
AddVC2SASimpleObject(128,-19560,"vc2sa/dff/starbits49.dff","vc2sa/txd/starbits49.txd");
AddVC2SASimpleObject(128,-19561,"vc2sa/dff/starbits50.dff","vc2sa/txd/starbits50.txd");
AddVC2SASimpleObject(128,-19562,"vc2sa/dff/starbits51.dff","vc2sa/txd/starbits51.txd");
AddVC2SASimpleObject(128,-19563,"vc2sa/dff/starbits52.dff","vc2sa/txd/nbeachwgen.txd");
AddVC2SASimpleObject(128,-19564,"vc2sa/dff/nbeachwjetty01.dff","vc2sa/txd/nbwjetty.txd");
AddVC2SASimpleObject(128,-19565,"vc2sa/dff/starbits54.dff","vc2sa/txd/starvillas01.txd");
AddVC2SASimpleObject(128,-19566,"vc2sa/dff/starbits55.dff","vc2sa/txd/starvillas01.txd");
AddVC2SASimpleObject(128,-19567,"vc2sa/dff/starbits56.dff","vc2sa/txd/starvillas01.txd");
AddVC2SASimpleObject(128,-19568,"vc2sa/dff/starbits57.dff","vc2sa/txd/starvillas01.txd");
AddVC2SASimpleObject(128,-19569,"vc2sa/dff/starbits58.dff","vc2sa/txd/starvillas01.txd");
AddVC2SASimpleObject(128,-19570,"vc2sa/dff/starbits59.dff","vc2sa/txd/starvillas01.txd");
AddVC2SASimpleObject(132,-19571,"vc2sa/dff/nbthotel08fence02.dff","vc2sa/txd/nbthotel08fence.txd");
AddVC2SASimpleObject(128,-19572,"vc2sa/dff/nbthotel10.dff","vc2sa/txd/nbthotel08.txd");
AddVC2SASimpleObject(128,-19573,"vc2sa/dff/nbt_hotel08.dff","vc2sa/txd/nbw_hotel06.txd");
AddVC2SASimpleObject(0,-19574,"vc2sa/dff/stardepot.dff","vc2sa/txd/stardepot.txd");
AddVC2SASimpleObject(128,-19575,"vc2sa/dff/nbt_hotel13.dff","vc2sa/txd/nbw_hotel06.txd");
AddVC2SASimpleObject(128,-19576,"vc2sa/dff/nbt_hotel15.dff","vc2sa/txd/nbw_hotel06.txd");
AddVC2SASimpleObject(4,-19577,"vc2sa/dff/nbt_apartpool01.dff","vc2sa/txd/nbt_apartpool.txd");
AddVC2SASimpleObject(132,-19578,"vc2sa/dff/nbt_apartpool02.dff","vc2sa/txd/nbt_apartpool01.txd");
AddVC2SASimpleObject(132,-19579,"vc2sa/dff/nbt_balcony02.dff","vc2sa/txd/nbw_hotel06balcony.txd");
AddVC2SASimpleObject(132,-19580,"vc2sa/dff/nbt_balcony03.dff","vc2sa/txd/nbw_hotel06balcony.txd");
AddVC2SASimpleObject(132,-19581,"vc2sa/dff/nbt_balcony05.dff","vc2sa/txd/nbw_hotel06balcony.txd");
AddVC2SASimpleObject(128,-19582,"vc2sa/dff/nbt_htlpoolbar01.dff","vc2sa/txd/nbt_htlpoolbar01.txd");
AddVC2SASimpleObject(132,-19583,"vc2sa/dff/nbt_apartpool03.dff","vc2sa/txd/nbt_apartpool.txd");
AddVC2SASimpleObject(132,-19584,"vc2sa/dff/nbt_barfence01.dff","vc2sa/txd/nbt_barfence01.txd");
AddVC2SASimpleObject(128,-19585,"vc2sa/dff/nbt_htlpoolrm01.dff","vc2sa/txd/nbt_htlpoolrm.txd");
AddVC2SASimpleObject(128,-19586,"vc2sa/dff/nbt_htlpoolrm02.dff","vc2sa/txd/nbt_htlpoolrm.txd");
AddVC2SASimpleObject(128,-19587,"vc2sa/dff/nbt_htlpoolbase01.dff","vc2sa/txd/htlpoolbase.txd");
AddVC2SASimpleObject(2097284,-19588,"vc2sa/dff/bldigste1mesh.dff","vc2sa/txd/starbuildsite.txd");
AddVC2SASimpleObject(0,-19589,"vc2sa/dff/nbroofst11.dff","vc2sa/txd/nbrooft.txd");
AddVC2SASimpleObject(4,-19590,"vc2sa/dff/nb2glue.dff","vc2sa/txd/nbglue.txd");
AddVC2SASimpleObject(0,-19591,"vc2sa/dff/nw_nbwroad08.dff","vc2sa/txd/nbwbridge.txd");
AddVC2SASimpleObject(128,-19592,"vc2sa/dff/nbt_htlpoolbase03.dff","vc2sa/txd/htlpoolbase.txd");
AddVC2SASimpleObject(128,-19593,"vc2sa/dff/nbt_htlpoolbase04.dff","vc2sa/txd/nbt_htlpoolbase.txd");
AddVC2SASimpleObject(0,-19594,"vc2sa/dff/nbeachroads09.dff","vc2sa/txd/nbeachwgen.txd");
AddVC2SASimpleObject(4,-19595,"vc2sa/dff/starwaterfrnt09b.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(4,-19596,"vc2sa/dff/starbits13b.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(4,-19597,"vc2sa/dff/starbits13c.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(128,-19598,"vc2sa/dff/nbt_htlpoolbase01b.dff","vc2sa/txd/htlpoolbase.txd");
AddVC2SASimpleObject(128,-19599,"vc2sa/dff/starwaterfrnt07.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(128,-19600,"vc2sa/dff/starwaterfrnt08.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(0,-19601,"vc2sa/dff/nw_nbwroad05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(2097284,-19602,"vc2sa/dff/buldingsite1.dff","vc2sa/txd/starbuildsite.txd");
AddVC2SASimpleObject(0,-19603,"vc2sa/dff/nw_nbwroad07.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19604,"vc2sa/dff/nw_nbwroad03.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19605,"vc2sa/dff/nw_nbwroad02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19606,"vc2sa/dff/nbw_grssypatch.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(0,-19607,"vc2sa/dff/nbw_bridgew.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-19608,"vc2sa/dff/nbt_htlpool01.dff","vc2sa/txd/htlpoolbase.txd");
AddVC2SASimpleObject(128,-19609,"vc2sa/dff/starbl02b.dff","vc2sa/txd/nbw_pinkblock.txd");
AddVC2SASimpleObject(2097280,-19610,"vc2sa/dff/nbeachwjetty02.dff","vc2sa/txd/nbwjetty.txd");
AddVC2SASimpleObject(128,-19611,"vc2sa/dff/starwaterfrnt06b.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(128,-19612,"vc2sa/dff/starwaterfrnt07b.dff","vc2sa/txd/starwaterfrnt01.txd");
AddVC2SASimpleObject(128,-19613,"vc2sa/dff/wash_hardwares.dff","vc2sa/txd/nbwtoolshp5.txd");
AddVC2SASimpleObject(0,-19614,"vc2sa/dff/nbchwbridge.dff","vc2sa/txd/nbwbridge.txd");
AddVC2SASimpleObject(132,-19615,"vc2sa/dff/nbeachbed01.dff","vc2sa/txd/nbw_pinkblock.txd");
AddVC2SASimpleObject(132,-19616,"vc2sa/dff/nbw_bush02.dff","vc2sa/txd/sta_pinkblock.txd");
AddVC2SASimpleObject(2097284,-19617,"vc2sa/dff/bldngst2meshdam.dff","vc2sa/txd/buildingsite2.txd");
AddVC2SASimpleObject(4,-19618,"vc2sa/dff/nbt_htlpiswr01.dff","vc2sa/txd/nbt_htlpoolrm.txd");
AddVC2SASimpleObject(4,-19619,"vc2sa/dff/nbt_htlpiswr02.dff","vc2sa/txd/nbt_htlpoolrm.txd");
AddVC2SASimpleObject(128,-19620,"vc2sa/dff/nbw_roadsigns.dff","vc2sa/txd/buildsiteVC.txd");
AddVC2SASimpleObject(0,-19621,"vc2sa/dff/nbbridgbit2.dff","vc2sa/txd/nbwbridge.txd");
AddVC2SASimpleObject(0,-19622,"vc2sa/dff/nbchwbridgb.dff","vc2sa/txd/nbwbridge.txd");
AddVC2SASimpleObject(4,-19623,"vc2sa/dff/nbeachbed02.dff","vc2sa/txd/nbw_pinkblock.txd");
AddVC2SASimpleObject(132,-19624,"vc2sa/dff/wash_hardwindow.dff","vc2sa/txd/nbwtoolshp5.txd");
AddVC2SASimpleObject(132,-19625,"vc2sa/dff/muck_nbeachw.dff","vc2sa/txd/nbeachwgen.txd");
AddVC2SASimpleObject(4,-19626,"vc2sa/dff/stardepot_FENCE.dff","vc2sa/txd/stardepot.txd");
AddVC2SASimpleObject(4,-19627,"vc2sa/dff/starbits20.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-19628,"vc2sa/dff/nbw_bush01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-19629,"vc2sa/dff/starbitbush.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-19630,"vc2sa/dff/starsbush2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-19631,"vc2sa/dff/nbwbusshy2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(4,22,5,-19632,"vc2sa/dff/nbwneon01.dff","vc2sa/txd/nbt_htlpoolbar01.txd");
AddVC2SASimpleTimed(4,22,5,-19633,"vc2sa/dff/nbwneon02.dff","vc2sa/txd/nbthotel08.txd");
AddVC2SASimpleObject(0,-19634,"vc2sa/dff/nbecland01.dff","vc2sa/txd/nbtecland.txd");
AddVC2SASimpleObject(0,-19635,"vc2sa/dff/nbecland03.dff","vc2sa/txd/nbtecland.txd");
AddVC2SASimpleObject(0,-19636,"vc2sa/dff/nbecland05.dff","vc2sa/txd/nbtecland.txd");
AddVC2SASimpleObject(0,-19637,"vc2sa/dff/nbt_road03.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19638,"vc2sa/dff/nbt_road05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19639,"vc2sa/dff/nbecland09.dff","vc2sa/txd/nbtecland.txd");
AddVC2SASimpleObject(0,-19640,"vc2sa/dff/nbecland11.dff","vc2sa/txd/nbtecland.txd");
AddVC2SASimpleObject(0,-19641,"vc2sa/dff/nbecland12.dff","vc2sa/txd/nbtecland.txd");
AddVC2SASimpleObject(128,-19642,"vc2sa/dff/nbt_mansion01.dff","vc2sa/txd/nbt_mansion01.txd");
AddVC2SASimpleObject(128,-19643,"vc2sa/dff/nbt_mansion02.dff","vc2sa/txd/nbt_mansion02.txd");
AddVC2SASimpleObject(128,-19644,"vc2sa/dff/nbeachbit02.dff","vc2sa/txd/nbtsmallres.txd");
AddVC2SASimpleObject(128,-19645,"vc2sa/dff/nbeachbit03.dff","vc2sa/txd/nbtsmallres.txd");
AddVC2SASimpleObject(128,-19646,"vc2sa/dff/nbtshopfronts01.dff","vc2sa/txd/nbtroofnext.txd");
AddVC2SASimpleObject(128,-19647,"vc2sa/dff/nbeachbit04.dff","vc2sa/txd/nbtrooftop.txd");
AddVC2SASimpleObject(128,-19648,"vc2sa/dff/nbeachbit05.dff","vc2sa/txd/nbtsmallres.txd");
AddVC2SASimpleObject(128,-19649,"vc2sa/dff/nbeachbit06.dff","vc2sa/txd/nbtsmallres.txd");
AddVC2SASimpleObject(128,-19650,"vc2sa/dff/nbt_hotel04.dff","vc2sa/txd/nbt_hotel04.txd");
AddVC2SASimpleObject(128,-19651,"vc2sa/dff/nbt_hotel02.dff","vc2sa/txd/nbt_hotel02.txd");
AddVC2SASimpleObject(128,-19652,"vc2sa/dff/nbt_hotel05.dff","vc2sa/txd/nbt_hotel05.txd");
AddVC2SASimpleObject(128,-19653,"vc2sa/dff/nbt_hotel01.dff","vc2sa/txd/nbt_hotel01.txd");
AddVC2SASimpleObject(128,-19654,"vc2sa/dff/nbt_hotel03.dff","vc2sa/txd/nbt_hotel03.txd");
AddVC2SASimpleObject(128,-19655,"vc2sa/dff/nbt_hotel06.dff","vc2sa/txd/nbt_hotel06.txd");
AddVC2SASimpleObject(128,-19656,"vc2sa/dff/newbuilding01.dff","vc2sa/txd/newbuilding01.txd");
AddVC2SASimpleObject(128,-19657,"vc2sa/dff/nbtshopfronts02.dff","vc2sa/txd/nbtshopfronts02.txd");
AddVC2SASimpleObject(128,-19658,"vc2sa/dff/nbhospgrnd.dff","vc2sa/txd/nbhospital.txd");
AddVC2SASimpleObject(128,-19659,"vc2sa/dff/nbt_rooftopstart.dff","vc2sa/txd/nbtrooftop.txd");
AddVC2SASimpleObject(128,-19660,"vc2sa/dff/plank01.dff","vc2sa/txd/nbtrooftop.txd");
AddVC2SASimpleObject(128,-19661,"vc2sa/dff/plank02.dff","vc2sa/txd/nbtrooftop.txd");
AddVC2SASimpleObject(128,-19662,"vc2sa/dff/nbt_skip.dff","vc2sa/txd/nbtrooftop.txd");
AddVC2SASimpleObject(128,-19663,"vc2sa/dff/nbt_pizzaplace.dff","vc2sa/txd/nbt_pizzaplace.txd");
AddVC2SASimpleObject(0,-19664,"vc2sa/dff/nbt_mansionbase01.dff","vc2sa/txd/nbt_mansionbase01.txd");
AddVC2SASimpleObject(132,-19665,"vc2sa/dff/mansionfence.dff","vc2sa/txd/mansionfence.txd");
AddVC2SASimpleObject(128,-19666,"vc2sa/dff/nbt_mansion03.dff","vc2sa/txd/nbt_mansion03.txd");
AddVC2SASimpleObject(0,-19667,"vc2sa/dff/nbt_mansionbase02.dff","vc2sa/txd/nbt_mansionbase02.txd");
AddVC2SASimpleObject(128,-19668,"vc2sa/dff/nbt_tikiprops01.dff","vc2sa/txd/tikiprops01.txd");
AddVC2SASimpleObject(132,-19669,"vc2sa/dff/nbt_hotel03glass.dff","vc2sa/txd/nbt_hotel03glass.txd");
AddVC2SASimpleObject(128,-19670,"vc2sa/dff/nbt_hotel07.dff","vc2sa/txd/nbt_hotel07.txd");
AddVC2SASimpleObject(132,-19671,"vc2sa/dff/nbt_hotel07fence.dff","vc2sa/txd/nbt_hotel07fence.txd");
AddVC2SASimpleObject(132,-19672,"vc2sa/dff/nubuilding1glass.dff","vc2sa/txd/nubuilding1glass.txd");
AddVC2SASimpleObject(128,-19673,"vc2sa/dff/nbeach_police.dff","vc2sa/txd/nb_police.txd");
AddVC2SASimpleObject(132,-19674,"vc2sa/dff/nbt_hotel06balcony.dff","vc2sa/txd/nbt_hotel06balcony.txd");
AddVC2SASimpleObject(132,-19675,"vc2sa/dff/nbt_mans04balcony.dff","vc2sa/txd/nbt_mans04balcony.txd");
AddVC2SASimpleObject(132,-19676,"vc2sa/dff/nbeachbit03rails.dff","vc2sa/txd/nbeachbit03rails.txd");
AddVC2SASimpleObject(132,-19677,"vc2sa/dff/nbecland12gates.dff","vc2sa/txd/nbecland12gates.txd");
AddVC2SASimpleObject(128,-19678,"vc2sa/dff/nbt_mansion04.dff","vc2sa/txd/nbt_mansion04.txd");
AddVC2SASimpleObject(132,-19679,"vc2sa/dff/nbecland12bball.dff","vc2sa/txd/nbecland12bball.txd");
AddVC2SASimpleObject(0,-19680,"vc2sa/dff/nbroada1.dff","vc2sa/txd/nbtecland.txd");
AddVC2SASimpleObject(132,-19681,"vc2sa/dff/nbt_mnsnwtr02.dff","vc2sa/txd/nbt_mnsnwtr.txd");
AddVC2SASimpleObject(132,-19682,"vc2sa/dff/nbt_mnsnwtr01.dff","vc2sa/txd/nbt_mnsnwtr.txd");
AddVC2SASimpleObject(0,-19683,"vc2sa/dff/nbtroadx.dff","vc2sa/txd/nbtecland.txd");
AddVC2SASimpleObject(0,-19684,"vc2sa/dff/beachbta.dff","vc2sa/txd/nbtecland.txd");
AddVC2SASimpleObject(0,-19685,"vc2sa/dff/nbt_road04.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19686,"vc2sa/dff/nbt_road02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(32,-19687,"vc2sa/dff/jewler_shop.dff","vc2sa/txd/jwlr.txd");
AddVC2SASimpleObject(100,-19688,"vc2sa/dff/jewler_opac_stf.dff","vc2sa/txd/jwlr.txd");
AddVC2SASimpleObject(128,-19689,"vc2sa/dff/nbeachbit04b.dff","vc2sa/txd/nbtrooftop.txd");
AddVC2SASimpleObject(128,-19690,"vc2sa/dff/nbtshopfronts01b.dff","vc2sa/txd/nbtroofnext.txd");
AddVC2SASimpleObject(128,-19691,"vc2sa/dff/nbtgardoor.dff","vc2sa/txd/nbtroofnext.txd");
AddVC2SASimpleObject(0,-19692,"vc2sa/dff/nbt_road01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19693,"vc2sa/dff/nbt_road06.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19694,"vc2sa/dff/nbt_road07.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19695,"vc2sa/dff/nbt_road08.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19696,"vc2sa/dff/nbt_road09.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19697,"vc2sa/dff/nbt_road10.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19698,"vc2sa/dff/nbt_road11.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19699,"vc2sa/dff/nbchbit04bgrd1.dff","vc2sa/txd/nbtrooftop.txd");
AddVC2SASimpleObject(0,-19700,"vc2sa/dff/nbchbit04grd2.dff","vc2sa/txd/nbtrooftop.txd");
AddVC2SASimpleObject(0,-19701,"vc2sa/dff/nbtshpfrts1bgrd.dff","vc2sa/txd/nbtroofnext.txd");
AddVC2SASimpleObject(0,-19702,"vc2sa/dff/nbtshpfrnts1grd.dff","vc2sa/txd/nbtroofnext.txd");
AddVC2SASimpleObject(2048,-19703,"vc2sa/dff/nbtgardoor02.dff","vc2sa/txd/nbt_hotel06.txd");
AddVC2SASimpleObject(0,-19704,"vc2sa/dff/nbecland10.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19705,"vc2sa/dff/nbeachsand1.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19706,"vc2sa/dff/nbeachsand2.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19707,"vc2sa/dff/beachbt.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19708,"vc2sa/dff/beachbtb.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19709,"vc2sa/dff/beachbtb2.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19710,"vc2sa/dff/nbeachsand2b.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-19711,"vc2sa/dff/beachblend05.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-19712,"vc2sa/dff/beachblend06.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-19713,"vc2sa/dff/beachblend07.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(128,-19714,"vc2sa/dff/nbchbtjetty01.dff","vc2sa/txd/nbchbtjetty.txd");
AddVC2SASimpleObject(132,-19715,"vc2sa/dff/newpools.dff","vc2sa/txd/nbt_mnsnwtr.txd");
AddVC2SASimpleObject(128,-19716,"vc2sa/dff/nbchbtjetty02.dff","vc2sa/txd/nbchbtjetty.txd");
AddVC2SASimpleObject(128,-19717,"vc2sa/dff/nbtshopfronts02b.dff","vc2sa/txd/nbtshopfronts02.txd");
AddVC2SASimpleObject(2048,-19718,"vc2sa/dff/nbtgardoor03.dff","vc2sa/txd/nbt_mansionbase01.txd");
AddVC2SASimpleObject(128,-19719,"vc2sa/dff/nbecpaynspray.dff","vc2sa/txd/nbeachpayns.txd");
AddVC2SASimpleObject(2048,-19720,"vc2sa/dff/nbecpnsdoor.dff","vc2sa/txd/nbeachpayns.txd");
AddVC2SASimpleObject(132,-19721,"vc2sa/dff/nbeachwater1.dff","vc2sa/txd/nbt_mnsnwtr.txd");
AddVC2SASimpleObject(128,-19722,"vc2sa/dff/nbec_divingbds.dff","vc2sa/txd/nbecdiving.txd");
AddVC2SASimpleObject(0,-19723,"vc2sa/dff/nbecland014.dff","vc2sa/txd/nbtecland.txd");
AddVC2SASimpleObject(0,-19724,"vc2sa/dff/nbecland013.dff","vc2sa/txd/nbtecland.txd");
AddVC2SASimpleObject(0,-19725,"vc2sa/dff/nbhospgrnd02.dff","vc2sa/txd/nbhospital.txd");
AddVC2SASimpleObject(0,-19726,"vc2sa/dff/nbt_hotel0402.dff","vc2sa/txd/nbt_hotel04.txd");
AddVC2SASimpleObject(0,-19727,"vc2sa/dff/nbt_hotel0702.dff","vc2sa/txd/nbt_hotel07.txd");
AddVC2SASimpleObject(0,-19728,"vc2sa/dff/nbt_mansion0402.dff","vc2sa/txd/nbt_mansion04.txd");
AddVC2SASimpleObject(0,-19729,"vc2sa/dff/nbeach_police02.dff","vc2sa/txd/nb_police.txd");
AddVC2SASimpleObject(0,-19730,"vc2sa/dff/nbt_hotel0602.dff","vc2sa/txd/nbt_hotel06.txd");
AddVC2SASimpleObject(0,-19731,"vc2sa/dff/newbuilding0102.dff","vc2sa/txd/newbuilding01.txd");
AddVC2SASimpleObject(0,-19732,"vc2sa/dff/nbt_hotel0302.dff","vc2sa/txd/nbt_hotel03.txd");
AddVC2SASimpleObject(0,-19733,"vc2sa/dff/nbt_hotel0202.dff","vc2sa/txd/nbt_hotel02.txd");
AddVC2SASimpleObject(0,-19734,"vc2sa/dff/nbt_hotel0102.dff","vc2sa/txd/nbt_hotel01.txd");
AddVC2SASimpleObject(128,-19735,"vc2sa/dff/nbecbtwbrdge.dff","vc2sa/txd/nbecbtwbrdge.txd");
AddVC2SASimpleObject(132,-19736,"vc2sa/dff/nbtshopfronts02win.dff","vc2sa/txd/nbtshopfronts02.txd");
AddVC2SASimpleObject(132,-19737,"vc2sa/dff/nbt_mansiontrees01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19738,"vc2sa/dff/nbt_mansiontrees02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19739,"vc2sa/dff/nbt_hoteltrees01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19740,"vc2sa/dff/nbt_hoteltrees02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19741,"vc2sa/dff/nbt_mansiontrees03.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19742,"vc2sa/dff/nbt_mansiontrees04.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19743,"vc2sa/dff/nbt_mansiontrees05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19744,"vc2sa/dff/nbeachvegy1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19745,"vc2sa/dff/nbeachvegy2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(132,22,5,-19746,"vc2sa/dff/nbechneon2.dff","vc2sa/txd/nbeachneon.txd");
AddVC2SASimpleTimed(132,22,5,-19747,"vc2sa/dff/nbecpnsneon1.dff","vc2sa/txd/nbeachneon.txd");
AddVC2SASimpleTimed(132,22,5,-19748,"vc2sa/dff/nbecnssignday_dy.dff","vc2sa/txd/nbeachpayns.txd");
AddVC2SASimpleTimed(132,22,5,-19749,"vc2sa/dff/nbecnssignight_nt.dff","vc2sa/txd/nbeachpayns.txd");
AddVC2SASimpleObject(0,-19750,"vc2sa/dff/nbmiamiland048.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19751,"vc2sa/dff/nbmiamiland049.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19752,"vc2sa/dff/nbmiamiland050.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19753,"vc2sa/dff/nbmiamiland051.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19754,"vc2sa/dff/nbmiamiland052.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19755,"vc2sa/dff/nbmiamiland053.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19756,"vc2sa/dff/nbmiamiland054.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19757,"vc2sa/dff/nbmiamiland055.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19758,"vc2sa/dff/nbmiamiland057.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19759,"vc2sa/dff/nbmiamiland059.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19760,"vc2sa/dff/nbmiamiland061.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19761,"vc2sa/dff/nbmiamiland068.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(128,-19762,"vc2sa/dff/nbsavehotel.dff","vc2sa/txd/nbsavehotel.txd");
AddVC2SASimpleObject(128,-19763,"vc2sa/dff/nbhotel02.dff","vc2sa/txd/nbhotel02.txd");
AddVC2SASimpleObject(128,-19764,"vc2sa/dff/nbhotel01.dff","vc2sa/txd/nbhotel01.txd");
AddVC2SASimpleObject(128,-19765,"vc2sa/dff/nbhotel03.dff","vc2sa/txd/nbhotel03.txd");
AddVC2SASimpleObject(128,-19766,"vc2sa/dff/nbdecoshop02.dff","vc2sa/txd/nbdecoshop02.txd");
AddVC2SASimpleObject(128,-19767,"vc2sa/dff/nbdecoshop01.dff","vc2sa/txd/nbdecoshop01.txd");
AddVC2SASimpleObject(128,-19768,"vc2sa/dff/nbdecoshop03.dff","vc2sa/txd/nbdecoshop03.txd");
AddVC2SASimpleObject(128,-19769,"vc2sa/dff/nbhotel05.dff","vc2sa/txd/nbhotel05.txd");
AddVC2SASimpleObject(128,-19770,"vc2sa/dff/nbhotel06.dff","vc2sa/txd/nbhotel06.txd");
AddVC2SASimpleObject(128,-19771,"vc2sa/dff/nbhotel04.dff","vc2sa/txd/nbhotel04.txd");
AddVC2SASimpleObject(128,-19772,"vc2sa/dff/nbhotel07.dff","vc2sa/txd/nbhotel07.txd");
AddVC2SASimpleObject(128,-19773,"vc2sa/dff/nbhotel08.dff","vc2sa/txd/nbhotel08.txd");
AddVC2SASimpleObject(0,-19774,"vc2sa/dff/nb_road15.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19775,"vc2sa/dff/nbmiamiland065.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19776,"vc2sa/dff/nbmiamiland063.dff","vc2sa/txd/nbeachgen.txd");
AddVC2SASimpleObject(0,-19777,"vc2sa/dff/nbdecopromnd.dff","vc2sa/txd/nbdecopromnd.txd");
AddVC2SASimpleObject(132,-19778,"vc2sa/dff/nbdecoshplants.dff","vc2sa/txd/nbdecoshop02.txd");
AddVC2SASimpleObject(128,-19779,"vc2sa/dff/mallseats01.dff","vc2sa/txd/nbdecopromnd.txd");
AddVC2SASimpleObject(132,-19780,"vc2sa/dff/nbdcprmndfnc2.dff","vc2sa/txd/nbdcprmndfnc.txd");
AddVC2SASimpleObject(132,-19781,"vc2sa/dff/nbdcprmndfnc1.dff","vc2sa/txd/nbdecopromnd.txd");
AddVC2SASimpleObject(132,-19782,"vc2sa/dff/nbsavhtlglass.dff","vc2sa/txd/nbsavehotel.txd");
AddVC2SASimpleObject(132,-19783,"vc2sa/dff/nbdcoshp01glss.dff","vc2sa/txd/nbdecoshop01.txd");
AddVC2SASimpleObject(0,-19784,"vc2sa/dff/4x4signstop.dff","vc2sa/txd/nbchdrtrack.txd");
AddVC2SASimpleObject(0,-19785,"vc2sa/dff/4x4rockstop.dff","vc2sa/txd/nbchdrtrack.txd");
AddVC2SASimpleObject(32,-19786,"vc2sa/dff/seveneleven.dff","vc2sa/txd/seveneleven.txd");
AddVC2SASimpleObject(32,-19787,"vc2sa/dff/pharmacy_kb1.dff","vc2sa/txd/pharmacyint.txd");
AddVC2SASimpleObject(128,-19788,"vc2sa/dff/shopfronts03.dff","vc2sa/txd/shopfronts03.txd");
AddVC2SASimpleObject(132,-19789,"vc2sa/dff/shpfrnts03rail02.dff","vc2sa/txd/shopfronts03.txd");
AddVC2SASimpleObject(132,-19790,"vc2sa/dff/shpfrnts03rail01.dff","vc2sa/txd/shopfronts03.txd");
AddVC2SASimpleObject(4,-19791,"vc2sa/dff/nbhotel02glss.dff","vc2sa/txd/nbhotel02.txd");
AddVC2SASimpleObject(0,-19792,"vc2sa/dff/nb_road01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19793,"vc2sa/dff/nb_road02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19794,"vc2sa/dff/nb_road03.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19795,"vc2sa/dff/nb_road04.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19796,"vc2sa/dff/nb_road05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19797,"vc2sa/dff/nb_road06.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19798,"vc2sa/dff/nb_road07.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19799,"vc2sa/dff/nb_road08.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19800,"vc2sa/dff/nb_road09.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19801,"vc2sa/dff/nb_road10.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19802,"vc2sa/dff/nb_road11.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19803,"vc2sa/dff/nb_road12.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19804,"vc2sa/dff/nb_road13.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19805,"vc2sa/dff/nb_road14.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19806,"vc2sa/dff/nbroadnew1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-19807,"vc2sa/dff/4x4racecotop.dff","vc2sa/txd/nbchdrtrack.txd");
AddVC2SASimpleObject(0,-19808,"vc2sa/dff/nbeachb.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19809,"vc2sa/dff/nbeachb1.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19810,"vc2sa/dff/4x4racecotop2.dff","vc2sa/txd/nbchdrtrack.txd");
AddVC2SASimpleObject(132,-19811,"vc2sa/dff/beachblend01.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-19812,"vc2sa/dff/beachblend02.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-19813,"vc2sa/dff/beachblend03.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-19814,"vc2sa/dff/beachblend04.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19815,"vc2sa/dff/nbdecopromnd2.dff","vc2sa/txd/nbdecopromnd.txd");
AddVC2SASimpleObject(0,-19816,"vc2sa/dff/ci_nbbridge1.dff","vc2sa/txd/nb_bridge1.txd");
AddVC2SASimpleObject(132,-19817,"vc2sa/dff/ci_nbbridge1fn3.dff","vc2sa/txd/nb_bridge1.txd");
AddVC2SASimpleObject(132,-19818,"vc2sa/dff/ci_nbbridge1fn2.dff","vc2sa/txd/nb_bridge1.txd");
AddVC2SASimpleObject(4,-19819,"vc2sa/dff/nbhtel06shdw.dff","vc2sa/txd/nbhotel06.txd");
AddVC2SASimpleObject(0,-19820,"vc2sa/dff/nbeachrdsign.dff","vc2sa/txd/nbeachrdsign.txd");
AddVC2SASimpleObject(4,-19821,"vc2sa/dff/nbchflw01.dff","vc2sa/txd/nbchflw.txd");
AddVC2SASimpleObject(4,-19822,"vc2sa/dff/nbchflw02.dff","vc2sa/txd/nbchflw.txd");
AddVC2SASimpleObject(0,-19823,"vc2sa/dff/4x4finishline.dff","vc2sa/txd/nbchdrtrack.txd");
AddVC2SASimpleObject(132,-19824,"vc2sa/dff/hoteltrees01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19825,"vc2sa/dff/hoteltrees02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19826,"vc2sa/dff/hoteltrees03.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19827,"vc2sa/dff/malltrees01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19828,"vc2sa/dff/hoteltrees05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19829,"vc2sa/dff/hoteltrees06.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-19830,"vc2sa/dff/gf_tree1_01.dff","vc2sa/txd/gfpalms.txd");
AddVC2SASimpleObject(132,-19831,"vc2sa/dff/gf_tree2_02.dff","vc2sa/txd/gfpalms.txd");
AddVC2SASimpleObject(0,-19832,"vc2sa/dff/gf_smallisland1_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(128,-19833,"vc2sa/dff/gf_flagstees3.dff","vc2sa/txd/gfflag.txd");
AddVC2SASimpleObject(128,-19834,"vc2sa/dff/gf_flagstees4.dff","vc2sa/txd/gfflag.txd");
AddVC2SASimpleObject(0,-19835,"vc2sa/dff/gf_mainisl5_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(132,-19836,"vc2sa/dff/gf_tennisfence.dff","vc2sa/txd/gfflag.txd");
AddVC2SASimpleObject(0,-19837,"vc2sa/dff/gf_northisland1.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19838,"vc2sa/dff/gf_northbridge1.dff","vc2sa/txd/gf_northbridge.txd");
AddVC2SASimpleObject(0,-19839,"vc2sa/dff/gf_smallislebridge1.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(128,-19840,"vc2sa/dff/gf_flagstees2.dff","vc2sa/txd/gfflag.txd");
AddVC2SASimpleObject(128,-19841,"vc2sa/dff/gf_flagstees1.dff","vc2sa/txd/gfflag.txd");
AddVC2SASimpleObject(128,-19842,"vc2sa/dff/gf_drivingrange1.dff","vc2sa/txd/gfnorthisland3.txd");
AddVC2SASimpleObject(132,-19843,"vc2sa/dff/gf_drdivide1_01.dff","vc2sa/txd/gfnorthisland3.txd");
AddVC2SASimpleObject(4,-19844,"vc2sa/dff/gf_hedge1_01.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(4,-19845,"vc2sa/dff/gf_hedge2_01.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(4,-19846,"vc2sa/dff/gf_hedge3_01.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(4,-19847,"vc2sa/dff/gf_hedge5_01.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(0,-19848,"vc2sa/dff/gf_northisland2.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19849,"vc2sa/dff/gf_mainisland3a_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19850,"vc2sa/dff/gf_mainisland2a_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19851,"vc2sa/dff/gf_mainisland1a_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19852,"vc2sa/dff/gf_mainisl2b_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19853,"vc2sa/dff/gf_mainisland1b_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19854,"vc2sa/dff/gf_northisland3.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19855,"vc2sa/dff/gf_mainisland6b_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(128,-19856,"vc2sa/dff/gf_clubhouse1.dff","vc2sa/txd/golf_clubhouse1.txd");
AddVC2SASimpleObject(132,-19857,"vc2sa/dff/gf_picket1_01.dff","vc2sa/txd/golf_clubhouse2.txd");
AddVC2SASimpleObject(128,-19858,"vc2sa/dff/gf_clublight1_01.dff","vc2sa/txd/golf_clubhouse1.txd");
AddVC2SASimpleObject(132,-19859,"vc2sa/dff/gf_stadlight1_02.dff","vc2sa/txd/golf_clubhouse2.txd");
AddVC2SASimpleObject(0,-19860,"vc2sa/dff/gf_mainisland6a_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19861,"vc2sa/dff/gf_mainisl4_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(128,-19862,"vc2sa/dff/nt_security1.dff","vc2sa/txd/golf_clubhouse1.txd");
AddVC2SASimpleObject(0,-19863,"vc2sa/dff/gf_pedbridge3.dff","vc2sa/txd/golf_bridge.txd");
AddVC2SASimpleObject(0,-19864,"vc2sa/dff/golfroad5.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19865,"vc2sa/dff/golfroad3.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19866,"vc2sa/dff/golfroad4.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19867,"vc2sa/dff/golfroad1.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19868,"vc2sa/dff/golfroad7.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19869,"vc2sa/dff/golfroad2.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19870,"vc2sa/dff/nbt_road12_gf.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-19871,"vc2sa/dff/gf_rollerjump.dff","vc2sa/txd/golf_clubhouse1.txd");
AddVC2SASimpleObject(0,-19872,"vc2sa/dff/gf_mainisland3b_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(4,-19873,"vc2sa/dff/gf_golfwall.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(4,-19874,"vc2sa/dff/golf_gatesopen.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(0,-19875,"vc2sa/dff/gf_northisland1b.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19876,"vc2sa/dff/gf_northisland1c.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19877,"vc2sa/dff/gf_mainisland1m_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19878,"vc2sa/dff/gf_mainisland6n_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-19879,"vc2sa/dff/gf_woodbridge1_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(4,-19880,"vc2sa/dff/gf_hedge6_01.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(4,-19881,"vc2sa/dff/gf_hedge4_01.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(256,-19882,"vc2sa/dff/nbecland13_gf.dff","vc2sa/txd/gf_nbtecland.txd");
AddVC2SASimpleObject(128,-19883,"vc2sa/dff/gf_signPlane01.dff","vc2sa/txd/gf_roadblock.txd");
AddVC2SASimpleObject(128,-19884,"vc2sa/dff/gf_flagstees42.dff","vc2sa/txd/gfflag.txd");
AddVC2SASimpleObject(128,-19885,"vc2sa/dff/gf_flagstees43.dff","vc2sa/txd/gfflag.txd");
AddVC2SASimpleObject(132,-19886,"vc2sa/dff/gf_water02.dff","vc2sa/txd/gfwater.txd");
AddVC2SASimpleObject(132,-19887,"vc2sa/dff/gf_water01.dff","vc2sa/txd/gfwater.txd");
AddVC2SASimpleObject(132,-19888,"vc2sa/dff/gf_water03.dff","vc2sa/txd/gfwater.txd");
AddVC2SASimpleObject(128,-19889,"vc2sa/dff/gf_planters2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-19890,"vc2sa/dff/gf_ivy_balcny_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-19891,"vc2sa/dff/gf_ivy_balcny_07.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-19892,"vc2sa/dff/gf_planters4.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(260,-19893,"vc2sa/dff/gf_treesfw1_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(260,-19894,"vc2sa/dff/gf_treesfw2_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(260,-19895,"vc2sa/dff/gf_treesfw3_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(260,-19896,"vc2sa/dff/gf_treesfw5_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(260,-19897,"vc2sa/dff/gf_treesfw4_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,5,21,-19898,"vc2sa/dff/Roosbridge_dt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,5,21,-19899,"vc2sa/dff/Roosbridge1_dt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,5,21,-19900,"vc2sa/dff/Roosbridge2_dt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,5,21,-19901,"vc2sa/dff/Roosbridge3_dt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,5,21,-19902,"vc2sa/dff/Roosbridge4_dt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,5,21,-19903,"vc2sa/dff/Roosbridge5_dt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,5,21,-19904,"vc2sa/dff/Roosbridge6_dt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,5,21,-19905,"vc2sa/dff/Roosbridge07_dt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,21,5,-19906,"vc2sa/dff/Roosbridge_nt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,21,5,-19907,"vc2sa/dff/Roosbridge1_nt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,21,5,-19908,"vc2sa/dff/Roosbridge2_nt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,21,5,-19909,"vc2sa/dff/Roosbridge3_nt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,21,5,-19910,"vc2sa/dff/Roosbridge4_nt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,21,5,-19911,"vc2sa/dff/Roosbridge5_nt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,21,5,-19912,"vc2sa/dff/Roosbridge6_nt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,21,5,-19913,"vc2sa/dff/Roosbridge07_nt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,5,21,-19914,"vc2sa/dff/RoosbrgeStart_r_dt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,21,5,-19915,"vc2sa/dff/RoosbrgeStart_r_nt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,21,5,-19916,"vc2sa/dff/RoosbrgeStartf_nt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleTimed(0,5,21,-19917,"vc2sa/dff/RoosbrgeStartf_dt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleObject(128,-19918,"vc2sa/dff/deco_buildkb09.dff","vc2sa/txd/oceanstrip2.txd");
AddVC2SASimpleObject(128,-19919,"vc2sa/dff/deco_polgrnda12.dff","vc2sa/txd/ocmiamistrip9.txd");
AddVC2SASimpleObject(132,-19920,"vc2sa/dff/deco_polgrnda13.dff","vc2sa/txd/ocmiamistrip9.txd");
AddVC2SASimpleObject(128,-19921,"vc2sa/dff/deco_polgrnda14.dff","vc2sa/txd/ocmiamistrip9.txd");
AddVC2SASimpleObject(128,-19922,"vc2sa/dff/deco_polgrnda16.dff","vc2sa/txd/ocmiamistrip9X.txd");
AddVC2SASimpleObject(128,-19923,"vc2sa/dff/deco_polgrnda17.dff","vc2sa/txd/ocmiamistrip16.txd");
AddVC2SASimpleObject(0,-19924,"vc2sa/dff/od_walkway2.dff","vc2sa/txd/od_lighthouse.txd");
AddVC2SASimpleObject(0,-19925,"vc2sa/dff/od_walkway3.dff","vc2sa/txd/od_lighthouse.txd");
AddVC2SASimpleObject(2097284,-19926,"vc2sa/dff/od_lightext.dff","vc2sa/txd/od_lighthouse.txd");
AddVC2SASimpleObject(132,-19927,"vc2sa/dff/od_northstar.dff","vc2sa/txd/od_bigshops2.txd");
AddVC2SASimpleObject(128,-19928,"vc2sa/dff/od_bphq.dff","vc2sa/txd/od_bphq.txd");
AddVC2SASimpleObject(128,-19929,"vc2sa/dff/od_acne.dff","vc2sa/txd/od_bigshops2.txd");
AddVC2SASimpleObject(128,-19930,"vc2sa/dff/od_bigshops2.dff","vc2sa/txd/od_bigshops2.txd");
AddVC2SASimpleObject(128,-19931,"vc2sa/dff/od_bigshops1.dff","vc2sa/txd/od_bigshops2.txd");
AddVC2SASimpleObject(128,-19932,"vc2sa/dff/od_clevelfence.dff","vc2sa/txd/od_fence.txd");
AddVC2SASimpleObject(128,-19933,"vc2sa/dff/oddoorwayS1.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(132,-19934,"vc2sa/dff/od_cornercrap1.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(132,-19935,"vc2sa/dff/od_cornercrap2.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(132,-19936,"vc2sa/dff/od_cornercrap3.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(196,-19937,"vc2sa/dff/od_tracks08.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(196,-19938,"vc2sa/dff/od_tracks10.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(196,-19939,"vc2sa/dff/od_tracks12.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(196,-19940,"vc2sa/dff/od_tracks14.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19941,"vc2sa/dff/miamiland_kb03.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19942,"vc2sa/dff/miamiland_kb04.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(4,-19943,"vc2sa/dff/beach_bush08s.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(4,-19944,"vc2sa/dff/beach_bush06s.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19945,"vc2sa/dff/miamiland_ws04.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19946,"vc2sa/dff/miamiland_ws04b.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19947,"vc2sa/dff/miamiland_kb02.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(4,-19948,"vc2sa/dff/od_lhland.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19949,"vc2sa/dff/beachlo1.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19950,"vc2sa/dff/miamiland_kb01_dy.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19951,"vc2sa/dff/miamiland_kb01_nt.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19952,"vc2sa/dff/odlowsand2.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19953,"vc2sa/dff/odlowsand1.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-19954,"vc2sa/dff/odhighsandgrs1.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(128,-19955,"vc2sa/dff/oddoorwayS02.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(132,-19956,"vc2sa/dff/beachblend15.dff","vc2sa/txd/ocmiamistrip.txd");
AddVC2SASimpleObject(132,-19957,"vc2sa/dff/beachblend12.dff","vc2sa/txd/ocmiamistrip.txd");
AddVC2SASimpleObject(132,-19958,"vc2sa/dff/beachblend13.dff","vc2sa/txd/ocmiamistrip.txd");
AddVC2SASimpleObject(132,-19959,"vc2sa/dff/beachblend14.dff","vc2sa/txd/ocmiamistrip.txd");
AddVC2SASimpleObject(132,-19960,"vc2sa/dff/beachblend16.dff","vc2sa/txd/ocmiamistrip.txd");
AddVC2SASimpleObject(128,-19961,"vc2sa/dff/od_lightint.dff","vc2sa/txd/od_lighthousein.txd");
AddVC2SASimpleTimed(0,5,20,-19962,"vc2sa/dff/oceanrda06_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,5,20,-19963,"vc2sa/dff/oceanrda05_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,5,20,-19964,"vc2sa/dff/oceanrda04_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,5,20,-19965,"vc2sa/dff/oceanrda03_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(128,5,20,-19966,"vc2sa/dff/od_casagrande_dy.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(128,5,20,-19967,"vc2sa/dff/od_pelican_dy.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(128,5,20,-19968,"vc2sa/dff/od_pelican2_dy.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(128,5,20,-19969,"vc2sa/dff/od_colony_dy.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(128,5,20,-19970,"vc2sa/dff/od_tides3_dy.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(128,5,20,-19971,"vc2sa/dff/od_colony2_dy.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(128,20,5,-19972,"vc2sa/dff/od_colony2_nt.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(128,5,20,-19973,"vc2sa/dff/od_clevelander_dy.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(4,5,21,-19974,"vc2sa/dff/od_alleys1_01_dy.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(128,5,20,-19975,"vc2sa/dff/od_majestic2c_dy.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(4,5,21,-19976,"vc2sa/dff/od_alleys3b_01_dy.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(4,5,21,-19977,"vc2sa/dff/od_alleys2_01_dy.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(0,5,20,-19978,"vc2sa/dff/od_newscafe_dy.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(0,5,20,-19979,"vc2sa/dff/od_oceanrdN1_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(4,5,21,-19980,"vc2sa/dff/od_alleys3_01_dy.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(4,5,21,-19981,"vc2sa/dff/od_alleys1b_01_dy.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(128,20,5,-19982,"vc2sa/dff/od_casagrande_nt.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(128,20,5,-19983,"vc2sa/dff/od_pelican_nt.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(128,20,5,-19984,"vc2sa/dff/od_pelican2_nt.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(128,20,5,-19985,"vc2sa/dff/od_colony_nt.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(132,20,5,-19986,"vc2sa/dff/od_tides3_nt.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(0,21,5,-19987,"vc2sa/dff/od_alleys3_01_nt.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(128,20,5,-19988,"vc2sa/dff/od_clevelander_nt.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(128,20,5,-19989,"vc2sa/dff/od_majestic2c_nt.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(0,20,5,-19990,"vc2sa/dff/od_newscafe_nt.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleTimed(0,20,5,-19991,"vc2sa/dff/od_oceanrdN1_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(4,21,5,-19992,"vc2sa/dff/od_alleys1_01_nt.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(4,21,5,-19993,"vc2sa/dff/od_alleys2_01_nt.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(4,21,5,-19994,"vc2sa/dff/od_alleys1b_01_nt.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(4,21,5,-19995,"vc2sa/dff/od_alleys3b_01_nt.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(172,21,5,-19996,"vc2sa/dff/od_neons3b_nt.dff","vc2sa/txd/od_neons1.txd");
AddVC2SASimpleTimed(172,21,5,-19997,"vc2sa/dff/od_neons2b_nt.dff","vc2sa/txd/od_neons1.txd");
AddVC2SASimpleTimed(0,20,5,-19998,"vc2sa/dff/oceanrda04_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,20,5,-19999,"vc2sa/dff/oceanrda06_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(172,21,5,-20000,"vc2sa/dff/ocdneona_nt.dff","vc2sa/txd/od_neons1.txd");
AddVC2SASimpleTimed(172,21,5,-20001,"vc2sa/dff/ocdneonb_nt.dff","vc2sa/txd/od_neons1.txd");
AddVC2SASimpleTimed(172,21,5,-20002,"vc2sa/dff/od_neonx1.dff","vc2sa/txd/od_neons1.txd");
AddVC2SASimpleTimed(172,21,5,-20003,"vc2sa/dff/od_neonn.dff","vc2sa/txd/od_neons1.txd");
AddVC2SASimpleTimed(0,20,5,-20004,"vc2sa/dff/oceanrda03_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,20,5,-20005,"vc2sa/dff/oceanrda05_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(164,20,5,-20006,"vc2sa/dff/od_fpbarsign.dff","vc2sa/txd/od_hotels1.txd");
AddVC2SASimpleObject(132,-20007,"vc2sa/dff/plants01_vc.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-20008,"vc2sa/dff/plants04.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-20009,"vc2sa/dff/plants05.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-20010,"vc2sa/dff/odrv_bushes.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-20011,"vc2sa/dff/odrv_bushes01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-20012,"vc2sa/dff/plants05b.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-20013,"vc2sa/dff/odNroad05od.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-20014,"vc2sa/dff/oceanroad05.dff","vc2sa/txd/odnroads.txd");
AddVC2SASimpleObject(132,-20015,"vc2sa/dff/deco_polgrnda9.dff","vc2sa/txd/ocmiamistrip7.txd");
AddVC2SASimpleObject(132,-20016,"vc2sa/dff/deco_polgrnda10.dff","vc2sa/txd/ocmiamistrip8.txd");
AddVC2SASimpleObject(196,-20017,"vc2sa/dff/spad_watr1.dff","vc2sa/txd/spad_water.txd");
AddVC2SASimpleObject(196,-20018,"vc2sa/dff/spad_watr2.dff","vc2sa/txd/spad_water.txd");
AddVC2SASimpleObject(228,-20019,"vc2sa/dff/shado_chuf.dff","vc2sa/txd/spad_shado.txd");
AddVC2SASimpleObject(0,-20020,"vc2sa/dff/od_clubback.dff","vc2sa/txd/od_clubback.txd");
AddVC2SASimpleObject(132,-20021,"vc2sa/dff/od_wt.dff","vc2sa/txd/od_watertower.txd");
AddVC2SASimpleObject(132,-20022,"vc2sa/dff/od_wtsign.dff","vc2sa/txd/od_watertower.txd");
AddVC2SASimpleObject(132,-20023,"vc2sa/dff/od_wtshadow.dff","vc2sa/txd/od_watertower.txd");
AddVC2SASimpleObject(132,-20024,"vc2sa/dff/od_wtlegs.dff","vc2sa/txd/od_watertower.txd");
AddVC2SASimpleObject(228,-20025,"vc2sa/dff/oddirtpass1.dff","vc2sa/txd/odnglue.txd");
AddVC2SASimpleObject(132,-20026,"vc2sa/dff/od2glue.dff","vc2sa/txd/odnglue.txd");
AddVC2SASimpleObject(128,-20027,"vc2sa/dff/spad_buildnew.dff","vc2sa/txd/spad_buildnew.txd");
AddVC2SASimpleObject(128,-20028,"vc2sa/dff/sexgarden2.dff","vc2sa/txd/newroof.txd");
AddVC2SASimpleObject(132,-20029,"vc2sa/dff/od_bighotsign.dff","vc2sa/txd/od_bighotel.txd");
AddVC2SASimpleObject(132,-20030,"vc2sa/dff/od_bighotsign01.dff","vc2sa/txd/od_bighotel.txd");
AddVC2SASimpleObject(0,-20031,"vc2sa/dff/bighotelgrnd.dff","vc2sa/txd/ocnmiamistrip.txd");
AddVC2SASimpleObject(128,-20032,"vc2sa/dff/deco_buildkb25.dff","vc2sa/txd/oceanstrip10.txd");
AddVC2SASimpleObject(128,-20033,"vc2sa/dff/odndoorway3.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(128,-20034,"vc2sa/dff/oddoorway.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(128,-20035,"vc2sa/dff/oddoorway2.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(196,-20036,"vc2sa/dff/odndirt4.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(0,-20037,"vc2sa/dff/oceanroad04.dff","vc2sa/txd/odnroads.txd");
AddVC2SASimpleObject(196,-20038,"vc2sa/dff/odndirt1.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(196,-20039,"vc2sa/dff/odndirt2.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(196,-20040,"vc2sa/dff/odndirt3.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(132,-20041,"vc2sa/dff/odnwiret.dff","vc2sa/txd/odnwire.txd");
AddVC2SASimpleObject(0,-20042,"vc2sa/dff/miamiodnroadxa.dff","vc2sa/txd/odnroads.txd");
AddVC2SASimpleObject(128,-20043,"vc2sa/dff/odrroofst02.dff","vc2sa/txd/odnrooft.txd");
AddVC2SASimpleObject(132,-20044,"vc2sa/dff/odrroofst07.dff","vc2sa/txd/odnrooft.txd");
AddVC2SASimpleObject(196,-20045,"vc2sa/dff/od_tracks01.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(196,-20046,"vc2sa/dff/od_tracks03.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(196,-20047,"vc2sa/dff/od_tracks05.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(196,-20048,"vc2sa/dff/od_tracks06.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-20049,"vc2sa/dff/deco_copgrnd.dff","vc2sa/txd/ocmiamistrip12.txd");
AddVC2SASimpleObject(32,-20050,"vc2sa/dff/cop_mainroom.dff","vc2sa/txd/od_cop_interior.txd");
AddVC2SASimpleObject(32,-20051,"vc2sa/dff/cop_entrance.dff","vc2sa/txd/od_cop_interior.txd");
AddVC2SASimpleObject(32,-20052,"vc2sa/dff/cop_processing.dff","vc2sa/txd/od_cop_interior.txd");
AddVC2SASimpleObject(0,-20053,"vc2sa/dff/deco_polbuild.dff","vc2sa/txd/cop_oceandrv.txd");
AddVC2SASimpleObject(32,-20054,"vc2sa/dff/cop_hallway.dff","vc2sa/txd/od_cop_interior.txd");
AddVC2SASimpleObject(32,-20055,"vc2sa/dff/cop_cells.dff","vc2sa/txd/od_cop_interior.txd");
AddVC2SASimpleObject(32,-20056,"vc2sa/dff/od_celldoor1.dff","vc2sa/txd/od_cop_interior.txd");
AddVC2SASimpleObject(32,-20057,"vc2sa/dff/od_celldoor03.dff","vc2sa/txd/od_cop_interior.txd");
AddVC2SASimpleObject(36,-20058,"vc2sa/dff/cop_waterref.dff","vc2sa/txd/od_cop_interior.txd");
AddVC2SASimpleObject(0,-20059,"vc2sa/dff/od_clubdoors.dff","vc2sa/txd/od_clubout.txd");
AddVC2SASimpleObject(0,-20060,"vc2sa/dff/ocndbridge.dff","vc2sa/txd/odnroads.txd");
AddVC2SASimpleObject(0,-20061,"vc2sa/dff/od_bighotpool2.dff","vc2sa/txd/od_bighotpool.txd");
AddVC2SASimpleObject(132,-20062,"vc2sa/dff/od_divingbds.dff","vc2sa/txd/od_bighotpool.txd");
AddVC2SASimpleObject(128,-20063,"vc2sa/dff/od_divingbdsteps.dff","vc2sa/txd/od_bighotpool.txd");
AddVC2SASimpleObject(0,-20064,"vc2sa/dff/od_bighotpool.dff","vc2sa/txd/od_bighotpool.txd");
AddVC2SASimpleObject(132,-20065,"vc2sa/dff/od_bighotcons.dff","vc2sa/txd/od_bighotpool.txd");
AddVC2SASimpleObject(160,-20066,"vc2sa/dff/ph_build_stairs.dff","vc2sa/txd/intstairod.txd");
AddVC2SASimpleObject(128,-20067,"vc2sa/dff/od_chariot.dff","vc2sa/txd/od_chariot.txd");
AddVC2SASimpleObject(0,-20068,"vc2sa/dff/sexpad_grdn_2.dff","vc2sa/txd/spad_main.txd");
AddVC2SASimpleObject(128,-20069,"vc2sa/dff/spad_build2.dff","vc2sa/txd/newspadbuild.txd");
AddVC2SASimpleObject(132,-20070,"vc2sa/dff/spad_water.dff","vc2sa/txd/spad_opac.txd");
AddVC2SASimpleObject(0,-20071,"vc2sa/dff/miamiland_kb10.dff","vc2sa/txd/od_waterwrx.txd");
AddVC2SASimpleObject(0,-20072,"vc2sa/dff/miamiland_kb11.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-20073,"vc2sa/dff/miamiland_kb12.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-20074,"vc2sa/dff/beach_bush02.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-20075,"vc2sa/dff/beach_bush04.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-20076,"vc2sa/dff/miamiland_kb11b.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-20077,"vc2sa/dff/miamiland_kb13.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-20078,"vc2sa/dff/miamiland_kb12b.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-20079,"vc2sa/dff/miamiland_kb10b.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-20080,"vc2sa/dff/beachblend08.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-20081,"vc2sa/dff/beachblend09.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-20082,"vc2sa/dff/beachblend10.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(132,-20083,"vc2sa/dff/beachblend11.dff","vc2sa/txd/shared_beach.txd");
AddVC2SASimpleObject(0,-20084,"vc2sa/dff/odNroad02.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(164,-20085,"vc2sa/dff/cop_pillar_shad.dff","vc2sa/txd/od_cop_interior.txd");
AddVC2SASimpleObject(164,-20086,"vc2sa/dff/cop_pillar_fake.dff","vc2sa/txd/copdoorstuff.txd");
AddVC2SASimpleObject(132,-20087,"vc2sa/dff/odrampbit.dff","vc2sa/txd/odnrooft.txd");
AddVC2SASimpleObject(128,-20088,"vc2sa/dff/deco_polgrnda7.dff","vc2sa/txd/ocmiamistrip5.txd");
AddVC2SASimpleObject(132,-20089,"vc2sa/dff/deco_polgrnda8.dff","vc2sa/txd/ocmiamistrip6.txd");
AddVC2SASimpleObject(132,-20090,"vc2sa/dff/odrroofst06.dff","vc2sa/txd/odnrooft.txd");
AddVC2SASimpleObject(128,-20091,"vc2sa/dff/palettejumpN04.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleObject(0,-20092,"vc2sa/dff/odNroad03od.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(128,-20093,"vc2sa/dff/od_chariotland.dff","vc2sa/txd/od_chariot.txd");
AddVC2SASimpleObject(68,-20094,"vc2sa/dff/od_clubfnce.dff","vc2sa/txd/od_clubback.txd");
AddVC2SASimpleObject(4,-20095,"vc2sa/dff/od_clubdoora.dff","vc2sa/txd/od_clubout.txd");
AddVC2SASimpleTimed(128,5,21,-20096,"vc2sa/dff/od_buildkb23_dy.dff","vc2sa/txd/odnhotelspr.txd");
AddVC2SASimpleTimed(128,21,5,-20097,"vc2sa/dff/od_buildkb23_nt.dff","vc2sa/txd/odnhotelspr.txd");
AddVC2SASimpleTimed(128,21,5,-20098,"vc2sa/dff/od_buildkb27_nt.dff","vc2sa/txd/odnhotelspr.txd");
AddVC2SASimpleTimed(128,5,21,-20099,"vc2sa/dff/deco_buildkb_dy.dff","vc2sa/txd/odnhotelspr.txd");
AddVC2SASimpleTimed(128,5,21,-20100,"vc2sa/dff/deco_buildkb29_dy.dff","vc2sa/txd/odnhotelspr.txd");
AddVC2SASimpleTimed(0,5,21,-20101,"vc2sa/dff/odNroad04od_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,21,5,-20102,"vc2sa/dff/odNroad04od_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,5,21,-20103,"vc2sa/dff/oceanrd1_dy.dff","vc2sa/txd/odnroads.txd");
AddVC2SASimpleTimed(128,21,5,-20104,"vc2sa/dff/od_bighotel_nt.dff","vc2sa/txd/od_bighotel.txd");
AddVC2SASimpleTimed(172,21,5,-20105,"vc2sa/dff/odneontest.dff","vc2sa/txd/odneontest.txd");
AddVC2SASimpleTimed(128,5,21,-20106,"vc2sa/dff/od_buildkb27_dy.dff","vc2sa/txd/odnhotelspr.txd");
AddVC2SASimpleTimed(128,5,21,-20107,"vc2sa/dff/od_buildkb2_dy.dff","vc2sa/txd/odnhotelspr.txd");
AddVC2SASimpleTimed(128,21,5,-20108,"vc2sa/dff/deco_buildkb_nt.dff","vc2sa/txd/odnhotelspr.txd");
AddVC2SASimpleTimed(128,21,5,-20109,"vc2sa/dff/deco_buildkb29_nt.dff","vc2sa/txd/odnhotelspr.txd");
AddVC2SASimpleTimed(172,21,5,-20110,"vc2sa/dff/odn_neonht1a.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(172,21,5,-20111,"vc2sa/dff/od_neona1.dff","vc2sa/txd/odneontest.txd");
AddVC2SASimpleTimed(128,21,5,-20112,"vc2sa/dff/od_buildkb2_nt.dff","vc2sa/txd/odnhotelspr.txd");
AddVC2SASimpleTimed(128,5,21,-20113,"vc2sa/dff/odn_beacon2_dy.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(128,21,5,-20114,"vc2sa/dff/odn_beacon2_nt.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(128,5,21,-20115,"vc2sa/dff/odn_majesticz_dy.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(128,21,5,-20116,"vc2sa/dff/odn_majesticz_nt.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(128,5,21,-20117,"vc2sa/dff/odn_tides2_dy.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(128,21,5,-20118,"vc2sa/dff/odn_tides2_nt.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(128,21,5,-20119,"vc2sa/dff/odn_majestic2x_nt.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(132,5,21,-20120,"vc2sa/dff/odn_colony_dy.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(172,21,5,-20121,"vc2sa/dff/odnneaon1.dff","vc2sa/txd/neonnd.txd");
AddVC2SASimpleTimed(172,21,5,-20122,"vc2sa/dff/odnneaon3.dff","vc2sa/txd/neonnd.txd");
AddVC2SASimpleTimed(172,21,5,-20123,"vc2sa/dff/odnneaon2.dff","vc2sa/txd/neonnd.txd");
AddVC2SASimpleTimed(172,21,5,-20124,"vc2sa/dff/odnneaon4.dff","vc2sa/txd/neonnd.txd");
AddVC2SASimpleTimed(128,21,5,-20125,"vc2sa/dff/odn_majest_nt.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(128,5,21,-20126,"vc2sa/dff/odn_majest_dy.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(128,5,21,-20127,"vc2sa/dff/odn_hotelhot_dy.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(128,21,5,-20128,"vc2sa/dff/odn_hotelhot_nt.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(172,21,5,-20129,"vc2sa/dff/odneontest01.dff","vc2sa/txd/odneontest.txd");
AddVC2SASimpleTimed(0,5,21,-20130,"vc2sa/dff/odalleyground_dy.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(0,21,5,-20131,"vc2sa/dff/odalleyground2_nt.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(0,5,21,-20132,"vc2sa/dff/odalleyground4_dy.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(0,21,5,-20133,"vc2sa/dff/odalleyground5_nt.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(0,5,21,-20134,"vc2sa/dff/odalleyground2_dy.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(0,21,5,-20135,"vc2sa/dff/odalleyground_nt.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(0,21,5,-20136,"vc2sa/dff/odalleyground4_nt.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(0,5,21,-20137,"vc2sa/dff/odalleyground5_dy.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(132,21,5,-20138,"vc2sa/dff/odn_colony_nt.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(0,21,5,-20139,"vc2sa/dff/oceanrd1_nt.dff","vc2sa/txd/odnroads.txd");
AddVC2SASimpleTimed(0,5,21,-20140,"vc2sa/dff/odalleygb_dy.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(0,5,21,-20141,"vc2sa/dff/od_clubout_dy.dff","vc2sa/txd/od_clubout.txd");
AddVC2SASimpleTimed(0,21,5,-20142,"vc2sa/dff/od_clubout_nt.dff","vc2sa/txd/od_clubout.txd");
AddVC2SASimpleTimed(164,5,21,-20143,"vc2sa/dff/od_char_signs_dy.dff","vc2sa/txd/od_chariot.txd");
AddVC2SASimpleTimed(164,21,5,-20144,"vc2sa/dff/od_char_signs_nt.dff","vc2sa/txd/od_chariot.txd");
AddVC2SASimpleTimed(0,5,21,-20145,"vc2sa/dff/odNroad01_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,21,5,-20146,"vc2sa/dff/odNroad01_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,21,5,-20147,"vc2sa/dff/odNroad06_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,5,21,-20148,"vc2sa/dff/odNroad06_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,21,5,-20149,"vc2sa/dff/odnanrod2b_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,5,21,-20150,"vc2sa/dff/odnanrod2b_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,21,5,-20151,"vc2sa/dff/odNroad08_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,5,21,-20152,"vc2sa/dff/odNroad08_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(0,21,5,-20153,"vc2sa/dff/odalleygb_nt.dff","vc2sa/txd/sharedalleyod.txd");
AddVC2SASimpleTimed(128,5,21,-20154,"vc2sa/dff/odn_majestic2x_dy.dff","vc2sa/txd/odnhotelblk.txd");
AddVC2SASimpleTimed(164,21,5,-20155,"vc2sa/dff/od_hotel_windows.dff","vc2sa/txd/od_bighotel.txd");
AddVC2SASimpleTimed(164,21,5,-20156,"vc2sa/dff/od_chariot_lghts01.dff","vc2sa/txd/od_chariot.txd");
AddVC2SASimpleTimed(164,23,1,-20157,"vc2sa/dff/od_chariot_lghts02.dff","vc2sa/txd/od_chariot.txd");
AddVC2SASimpleTimed(128,5,21,-20158,"vc2sa/dff/od_bighotel_dy.dff","vc2sa/txd/od_bighotel.txd");
AddVC2SASimpleTimed(4,5,21,-20159,"vc2sa/dff/od_clubfence_dy.dff","vc2sa/txd/od_clubout.txd");
AddVC2SASimpleTimed(4,21,5,-20160,"vc2sa/dff/od_clubfence_nt.dff","vc2sa/txd/od_clubout.txd");
AddVC2SASimpleObject(196,-20161,"vc2sa/dff/spad_veg1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-20162,"vc2sa/dff/new_bushtest42.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-20163,"vc2sa/dff/odnvegbush1.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-20164,"vc2sa/dff/odnvegbush2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(4,-20165,"vc2sa/dff/odnvegbush2b.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleTimed(44,21,5,-20166,"vc2sa/dff/od_tob01.dff","vc2sa/txd/od_clubout.txd");
AddVC2SASimpleObject(288,-20167,"vc2sa/dff/cdseabed01.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20168,"vc2sa/dff/cdseabed02.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20169,"vc2sa/dff/cdseabed03.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20170,"vc2sa/dff/cdseabed04.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20171,"vc2sa/dff/cdseabed05.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20172,"vc2sa/dff/cdseabed06.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20173,"vc2sa/dff/cdseabed07.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20174,"vc2sa/dff/cdseabed08.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20175,"vc2sa/dff/cdseabed09.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20176,"vc2sa/dff/cdseabed10.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20177,"vc2sa/dff/cdseabed11.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20178,"vc2sa/dff/cdseabed12.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20179,"vc2sa/dff/cdseabed13.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20180,"vc2sa/dff/cdseabed14.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20181,"vc2sa/dff/cdseabed15.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20182,"vc2sa/dff/cdseabed16.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20183,"vc2sa/dff/cdseabed17.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20184,"vc2sa/dff/cdseabed18.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20185,"vc2sa/dff/cdseabed19.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20186,"vc2sa/dff/cdseabed20.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20187,"vc2sa/dff/cdseabed21.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20188,"vc2sa/dff/cdseabed22.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20189,"vc2sa/dff/cdseabed23.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20190,"vc2sa/dff/cdseabed24.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20191,"vc2sa/dff/cdseabed25.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20192,"vc2sa/dff/cdseabed26.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20193,"vc2sa/dff/cdseabed27.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20194,"vc2sa/dff/cdseabed28.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20195,"vc2sa/dff/cdseabed29.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20196,"vc2sa/dff/cdseabed30.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20197,"vc2sa/dff/cdseabed31.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20198,"vc2sa/dff/cdseabed32.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20199,"vc2sa/dff/cdseabed33.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(288,-20200,"vc2sa/dff/cdseaan.dff","vc2sa/txd/seabed_VC.txd");
AddVC2SASimpleObject(128,-20201,"vc2sa/dff/seabedshit1.dff","vc2sa/txd/dock_shipsunder.txd");
AddVC2SASimpleObject(128,-20202,"vc2sa/dff/seabedcars.dff","vc2sa/txd/fuckedcarlh.txd");
AddVC2SASimpleObject(0,-20203,"vc2sa/dff/seacorpse.dff","vc2sa/txd/corpsedrown.txd");
AddVC2SASimpleObject(128,-20204,"vc2sa/dff/seabedshit02.dff","vc2sa/txd/dock_shipsunder.txd");
AddVC2SASimpleObject(128,-20205,"vc2sa/dff/seabedcars04.dff","vc2sa/txd/fuckedcarlh.txd");
AddVC2SASimpleObject(0,-20206,"vc2sa/dff/seacorpse01.dff","vc2sa/txd/corpsedrown.txd");
AddVC2SASimpleObject(128,-20207,"vc2sa/dff/rockpatch03.dff","vc2sa/txd/rocky.txd");
AddVC2SASimpleObject(2097152,-20208,"vc2sa/dff/mlmiamiland056.dff","vc2sa/txd/mall_ground.txd");
AddVC2SASimpleObject(2097152,-20209,"vc2sa/dff/mlmiamiland058.dff","vc2sa/txd/mall_ground.txd");
AddVC2SASimpleObject(2097152,-20210,"vc2sa/dff/mlmiamiland060.dff","vc2sa/txd/mall_ground.txd");
AddVC2SASimpleObject(2097152,-20211,"vc2sa/dff/newmallcp_03.dff","vc2sa/txd/mallcarpark.txd");
AddVC2SASimpleObject(2097280,-20212,"vc2sa/dff/mlmallflag02.dff","vc2sa/txd/mallitems.txd");
AddVC2SASimpleObject(2097280,-20213,"vc2sa/dff/mlmallflag12.dff","vc2sa/txd/mallitems.txd");
AddVC2SASimpleObject(2097280,-20214,"vc2sa/dff/mlmallflag14.dff","vc2sa/txd/mallitems.txd");
AddVC2SASimpleObject(2097312,-20215,"vc2sa/dff/mloven.dff","vc2sa/txd/foodcourt.txd");
AddVC2SASimpleObject(2097312,-20216,"vc2sa/dff/mlobjects_n.dff","vc2sa/txd/mall_props.txd");
AddVC2SASimpleObject(2097284,-20217,"vc2sa/dff/mlmallbush.dff","vc2sa/txd/mallplants.txd");
AddVC2SASimpleObject(2097280,-20218,"vc2sa/dff/mlNpoint02.dff","vc2sa/txd/mallcarpark.txd");
AddVC2SASimpleObject(2097280,-20219,"vc2sa/dff/mlNpoint04.dff","vc2sa/txd/mallcarpark.txd");
AddVC2SASimpleObject(2097280,-20220,"vc2sa/dff/mlNpoint06.dff","vc2sa/txd/mallcarpark.txd");
AddVC2SASimpleObject(2097280,-20221,"vc2sa/dff/mlmallplan02.dff","vc2sa/txd/mallitems.txd");
AddVC2SASimpleObject(2097280,-20222,"vc2sa/dff/mlmallplan04.dff","vc2sa/txd/mallitems.txd");
AddVC2SASimpleObject(2097280,-20223,"vc2sa/dff/mlmallplan05.dff","vc2sa/txd/mallitems.txd");
AddVC2SASimpleObject(2097314,-20224,"vc2sa/dff/mlnorthmallrt.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097314,-20225,"vc2sa/dff/mlnorthmalllft.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097152,-20226,"vc2sa/dff/newmallcp_05.dff","vc2sa/txd/mallcarpark.txd");
AddVC2SASimpleObject(2097152,-20227,"vc2sa/dff/newmallcp_02.dff","vc2sa/txd/mallcarpark.txd");
AddVC2SASimpleObject(2097152,-20228,"vc2sa/dff/newmallcp_04.dff","vc2sa/txd/mallcarpark.txd");
AddVC2SASimpleObject(2097280,-20229,"vc2sa/dff/ml_gap.dff","vc2sa/txd/ml_clothes.txd");
AddVC2SASimpleObject(2097312,-20230,"vc2sa/dff/ml_record.dff","vc2sa/txd/ml_tuneless.txd");
AddVC2SASimpleObject(2097312,-20231,"vc2sa/dff/ml_borders.dff","vc2sa/txd/ml_books.txd");
AddVC2SASimpleObject(2097312,-20232,"vc2sa/dff/ml_jewellers.dff","vc2sa/txd/ml_jewellers.txd");
AddVC2SASimpleObject(2097312,-20233,"vc2sa/dff/ml_tarbrush.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(2097312,-20234,"vc2sa/dff/ml_cofcounter1.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(2097312,-20235,"vc2sa/dff/ml_record3.dff","vc2sa/txd/ml_tuneless.txd");
AddVC2SASimpleObject(2097312,-20236,"vc2sa/dff/ml_coffee_dsk.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(2097312,-20237,"vc2sa/dff/mall_hardware.dff","vc2sa/txd/mall_ammu.txd");
AddVC2SASimpleObject(2097312,-20238,"vc2sa/dff/mall_hardwarebits.dff","vc2sa/txd/mall_ammu.txd");
AddVC2SASimpleObject(2097152,-20239,"vc2sa/dff/newmallcp_01.dff","vc2sa/txd/mallcarpark.txd");
AddVC2SASimpleObject(2097316,-20240,"vc2sa/dff/mall_ammu.dff","vc2sa/txd/mall_ammu.txd");
AddVC2SASimpleObject(2097316,-20241,"vc2sa/dff/mall_ammuwin.dff","vc2sa/txd/mall_ammu.txd");
AddVC2SASimpleObject(2097316,-20242,"vc2sa/dff/ml_coffwinframe01.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(2097316,-20243,"vc2sa/dff/ml_coffwinframe02.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(2097152,-20244,"vc2sa/dff/nmalloutside.dff","vc2sa/txd/mall_VC_FX.txd");
AddVC2SASimpleObject(2097152,-20245,"vc2sa/dff/nbnorthmallext1.dff","vc2sa/txd/mallext.txd");
AddVC2SASimpleObject(2097280,-20246,"vc2sa/dff/mlnorthmalllftex.dff","vc2sa/txd/mallext.txd");
AddVC2SASimpleObject(2097280,-20247,"vc2sa/dff/ml_vegbits05.dff","vc2sa/txd/mall_veg.txd");
AddVC2SASimpleObject(2097280,-20248,"vc2sa/dff/ml_vegbits01.dff","vc2sa/txd/mall_veg.txd");
AddVC2SASimpleObject(2097280,-20249,"vc2sa/dff/ml_vegbits02.dff","vc2sa/txd/mall_veg.txd");
AddVC2SASimpleObject(2097280,-20250,"vc2sa/dff/ml_vegbits03.dff","vc2sa/txd/mall_veg.txd");
AddVC2SASimpleObject(2097316,-20251,"vc2sa/dff/ml_glasslft.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(2097316,-20252,"vc2sa/dff/ml_water.dff","vc2sa/txd/mall_props.txd");
AddVC2SASimpleObject(2097280,-20253,"vc2sa/dff/ml_vegbits04.dff","vc2sa/txd/mall_veg.txd");
AddVC2SASimpleObject(2097312,-20254,"vc2sa/dff/ml_jewelcounter.dff","vc2sa/txd/ml_jewellers.txd");
AddVC2SASimpleObject(2097316,-20255,"vc2sa/dff/ml_water2.dff","vc2sa/txd/mall_props.txd");
AddVC2SASimpleObject(2097312,-20256,"vc2sa/dff/mloven02.dff","vc2sa/txd/foodcourt.txd");
AddVC2SASimpleObject(2097312,-20257,"vc2sa/dff/mlobjects_n02.dff","vc2sa/txd/mall_props.txd");
AddVC2SASimpleObject(2097312,-20258,"vc2sa/dff/mlobjects_n03.dff","vc2sa/txd/mall_props.txd");
AddVC2SASimpleObject(2097312,-20259,"vc2sa/dff/mlobjects_n04.dff","vc2sa/txd/mall_props.txd");
AddVC2SASimpleObject(2097312,-20260,"vc2sa/dff/ml_tartable.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(2097312,-20261,"vc2sa/dff/ml_escl.dff","vc2sa/txd/mall_props.txd");
AddVC2SASimpleObject(2097312,-20262,"vc2sa/dff/mlrecords.dff","vc2sa/txd/ml_tuneless.txd");
AddVC2SASimpleObject(2097312,-20263,"vc2sa/dff/mall_fans.dff","vc2sa/txd/mall_props.txd");
AddVC2SASimpleObject(2097318,-20264,"vc2sa/dff/mlngrnd.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097316,-20265,"vc2sa/dff/mlgrndmidtop.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097318,-20266,"vc2sa/dff/mlgrounds.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097314,-20267,"vc2sa/dff/mallint1.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097312,-20268,"vc2sa/dff/mallint2.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097312,-20269,"vc2sa/dff/mallint3.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097312,-20270,"vc2sa/dff/mallint5.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097312,-20271,"vc2sa/dff/mallint7.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097312,-20272,"vc2sa/dff/mallint8.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097314,-20273,"vc2sa/dff/mallint9.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097312,-20274,"vc2sa/dff/ml_planterbed.dff","vc2sa/txd/mall_props.txd");
AddVC2SASimpleObject(2097316,-20275,"vc2sa/dff/mlmallroof01.dff","vc2sa/txd/mallroof.txd");
AddVC2SASimpleObject(2097312,-20276,"vc2sa/dff/ml_jewelwinframe01.dff","vc2sa/txd/ml_jewellers.txd");
AddVC2SASimpleObject(2097318,-20277,"vc2sa/dff/malllights.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097284,-20278,"vc2sa/dff/mallbushdense.dff","vc2sa/txd/mallplants.txd");
AddVC2SASimpleObject(2097284,-20279,"vc2sa/dff/mallbushs.dff","vc2sa/txd/mallplants.txd");
AddVC2SASimpleObject(2097312,-20280,"vc2sa/dff/mallint5up.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097312,-20281,"vc2sa/dff/mlnorthmalltop.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097152,-20282,"vc2sa/dff/mlmiamiland060b.dff","vc2sa/txd/mall_ground.txd");
AddVC2SASimpleObject(2097318,-20283,"vc2sa/dff/midmallflorre.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097316,-20284,"vc2sa/dff/midmallfloorw.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097316,-20285,"vc2sa/dff/maidmalltopa.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097316,-20286,"vc2sa/dff/ml_jewelglass.dff","vc2sa/txd/ml_jewellers.txd");
AddVC2SASimpleObject(2097316,-20287,"vc2sa/dff/mallint5up_b.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(2097312,-20288,"vc2sa/dff/mlmallroof.dff","vc2sa/txd/mallroof.txd");
AddVC2SASimpleObject(2097316,-20289,"vc2sa/dff/bugsuckfuck.dff","vc2sa/txd/malltotal.txd");
AddVC2SASimpleObject(32,-20290,"vc2sa/dff/hot_room317.dff","vc2sa/txd/hotelroomint.txd");
AddVC2SASimpleObject(32,-20291,"vc2sa/dff/hot_drawers1_01.dff","vc2sa/txd/hotelroomint.txd");
AddVC2SASimpleObject(32,-20292,"vc2sa/dff/hot_bar1_01.dff","vc2sa/txd/hotelroomint.txd");
AddVC2SASimpleObject(32,-20293,"vc2sa/dff/nt_wassily1_02.dff","vc2sa/txd/hotelroomint.txd");
AddVC2SASimpleObject(32,-20294,"vc2sa/dff/nt_couch_1.dff","vc2sa/txd/hotelroomint.txd");
AddVC2SASimpleObject(32,-20295,"vc2sa/dff/nt_bed1_01.dff","vc2sa/txd/hotelroomint.txd");
AddVC2SASimpleObject(164,-20296,"vc2sa/dff/hot_trans1.dff","vc2sa/txd/hot_roomtrans.txd");
AddVC2SASimpleObject(32,-20297,"vc2sa/dff/hot_mags1.dff","vc2sa/txd/hotelroomint.txd");
AddVC2SASimpleObject(36,-20298,"vc2sa/dff/mob_door2.dff","vc2sa/txd/hot_roomtrans.txd");
AddVC2SASimpleObject(32,-20299,"vc2sa/dff/mob_mobroom2.dff","vc2sa/txd/hot_mobint.txd");
AddVC2SASimpleObject(32,-20300,"vc2sa/dff/mob_door3.dff","vc2sa/txd/hot_mobint.txd");
AddVC2SASimpleObject(32,-20301,"vc2sa/dff/mob_detailsb.dff","vc2sa/txd/hot_mobint.txd");
AddVC2SASimpleObject(36,-20302,"vc2sa/dff/ht_veg02_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(32,-20303,"vc2sa/dff/ht_upstairs.dff","vc2sa/txd/hi_cutint1.txd");
AddVC2SASimpleObject(100,-20304,"vc2sa/dff/hotshad1.dff","vc2sa/txd/hi_cuthoomintshad.txd");
AddVC2SASimpleObject(100,-20305,"vc2sa/dff/hotroomfan.dff","vc2sa/txd/hi_cuthoomintshad.txd");
AddVC2SASimpleObject(1060,-20306,"vc2sa/dff/htl_gls_lobby.dff","vc2sa/txd/hi_cuthtlalp.txd");
AddVC2SASimpleObject(36,-20307,"vc2sa/dff/ht_veg04_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(36,-20308,"vc2sa/dff/ht_veg02_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(36,-20309,"vc2sa/dff/ht_veg01_nt.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(32,-20310,"vc2sa/dff/ht_fans_nt.dff","vc2sa/txd/hi_cutintprops.txd");
AddVC2SASimpleObject(32,-20311,"vc2sa/dff/ht_kb_couch1_nt.dff","vc2sa/txd/hi_cutcouch.txd");
AddVC2SASimpleObject(36,-20312,"vc2sa/dff/htl_maintiles_nt.dff","vc2sa/txd/hi_cuthtlalp.txd");
AddVC2SASimpleObject(32,-20313,"vc2sa/dff/htl_lftdoor1_nt.dff","vc2sa/txd/hi_cuthtl4.txd");
AddVC2SASimpleObject(32,-20314,"vc2sa/dff/ht_mainfloor2_nt.dff","vc2sa/txd/hi_cuthtl2.txd");
AddVC2SASimpleObject(1060,-20315,"vc2sa/dff/htl_gls_3_nt.dff","vc2sa/txd/hi_cuthtlalp.txd");
AddVC2SASimpleObject(1060,-20316,"vc2sa/dff/htl_gls_1_nt.dff","vc2sa/txd/hi_cuthtlalp.txd");
AddVC2SASimpleObject(1060,-20317,"vc2sa/dff/htl_gls_2_nt.dff","vc2sa/txd/hi_cuthtlalp.txd");
AddVC2SASimpleObject(36,-20318,"vc2sa/dff/ht_veg04_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(36,-20319,"vc2sa/dff/ht_veg01_dy.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(32,-20320,"vc2sa/dff/ht_fans_dy.dff","vc2sa/txd/hi_cutintprops.txd");
AddVC2SASimpleObject(32,-20321,"vc2sa/dff/ht_kb_couch1_dy.dff","vc2sa/txd/hi_cutcouch.txd");
AddVC2SASimpleObject(164,-20322,"vc2sa/dff/ht_mainfloor_dy.dff","vc2sa/txd/hi_cuthtl2.txd");
AddVC2SASimpleObject(36,-20323,"vc2sa/dff/htl_maintiles_dy.dff","vc2sa/txd/hi_cuthtlalp.txd");
AddVC2SASimpleObject(32,-20324,"vc2sa/dff/htl_lftdoor1_dy.dff","vc2sa/txd/hi_cuthtl4.txd");
AddVC2SASimpleObject(32,-20325,"vc2sa/dff/ht_mainfloor2_dy.dff","vc2sa/txd/hi_cuthtl2.txd");
AddVC2SASimpleObject(1060,-20326,"vc2sa/dff/htl_gls_3_dy.dff","vc2sa/txd/hi_cuthtlalp.txd");
AddVC2SASimpleObject(1060,-20327,"vc2sa/dff/htl_gls_1_dy.dff","vc2sa/txd/hi_cuthtlalp.txd");
AddVC2SASimpleObject(1060,-20328,"vc2sa/dff/htl_gls_2_dy.dff","vc2sa/txd/hi_cuthtlalp.txd");
AddVC2SASimpleObject(32,-20329,"vc2sa/dff/htl_dco_chair03_dy.dff","vc2sa/txd/hi_cuthotel1.txd");
AddVC2SASimpleObject(32,-20330,"vc2sa/dff/htl_dco_chair03_nt.dff","vc2sa/txd/hi_cuthotel1.txd");
AddVC2SASimpleObject(160,-20331,"vc2sa/dff/ht_mainfloor_nt.dff","vc2sa/txd/hi_cuthtl2.txd");
AddVC2SASimpleObject(160,-20332,"vc2sa/dff/clubceilingdome.dff","vc2sa/txd/mainclub2.txd");
AddVC2SASimpleObject(160,-20333,"vc2sa/dff/cl_main_room.dff","vc2sa/txd/hi_cutmaincl.txd");
AddVC2SASimpleObject(164,-20334,"vc2sa/dff/cl_recessedlights1.dff","vc2sa/txd/mainclub2.txd");
AddVC2SASimpleObject(164,-20335,"vc2sa/dff/cl_curtains.dff","vc2sa/txd/hi_cutmaincl.txd");
AddVC2SASimpleObject(160,-20336,"vc2sa/dff/cl_stage.dff","vc2sa/txd/hi_cutmaincl.txd");
AddVC2SASimpleObject(164,-20337,"vc2sa/dff/cl_recessed_flr.dff","vc2sa/txd/mainclub2.txd");
AddVC2SASimpleObject(160,-20338,"vc2sa/dff/cl_spots.dff","vc2sa/txd/mainclub2.txd");
AddVC2SASimpleObject(160,-20339,"vc2sa/dff/cl_tbl_chait_tmp.dff","vc2sa/txd/mainclub2.txd");
AddVC2SASimpleObject(160,-20340,"vc2sa/dff/cl_railing.dff","vc2sa/txd/mainclub2.txd");
AddVC2SASimpleObject(160,-20341,"vc2sa/dff/cl_stage_roof.dff","vc2sa/txd/hi_cutmaincl.txd");
AddVC2SASimpleObject(160,-20342,"vc2sa/dff/cl_mainwalls.dff","vc2sa/txd/hi_cutclwaltst.txd");
AddVC2SASimpleObject(164,-20343,"vc2sa/dff/cl_tblesetsml.dff","vc2sa/txd/hi_cuttblprop.txd");
AddVC2SASimpleObject(128,-20344,"vc2sa/dff/club_exterior02.dff","vc2sa/txd/cl_ext2.txd");
AddVC2SASimpleObject(132,-20345,"vc2sa/dff/club_exterior03.dff","vc2sa/txd/cl_ext2.txd");
AddVC2SASimpleObject(132,-20346,"vc2sa/dff/club_exterior04.dff","vc2sa/txd/cl_ext2.txd");
AddVC2SASimpleObject(132,-20347,"vc2sa/dff/club_exterior05.dff","vc2sa/txd/cl_ext2.txd");
AddVC2SASimpleObject(128,-20348,"vc2sa/dff/club_exterior06.dff","vc2sa/txd/cl_ext2.txd");
AddVC2SASimpleObject(128,-20349,"vc2sa/dff/club_exterior07.dff","vc2sa/txd/cl_ext3.txd");
AddVC2SASimpleObject(132,-20350,"vc2sa/dff/club_exterior08.dff","vc2sa/txd/cl_vegbits.txd");
AddVC2SASimpleObject(132,-20351,"vc2sa/dff/club_exterior09.dff","vc2sa/txd/cl_vegbits.txd");
AddVC2SASimpleObject(128,-20352,"vc2sa/dff/club_exterior10.dff","vc2sa/txd/cl_ext2.txd");
AddVC2SASimpleObject(132,-20353,"vc2sa/dff/club_exterior11.dff","vc2sa/txd/cl_vegbits.txd");
AddVC2SASimpleObject(132,-20354,"vc2sa/dff/club_exterior12.dff","vc2sa/txd/cl_vegbits.txd");
AddVC2SASimpleObject(160,-20355,"vc2sa/dff/cb_CLUBSTAIRS.dff","vc2sa/txd/hi_cutclubbar.txd");
AddVC2SASimpleObject(160,-20356,"vc2sa/dff/cl_bckrm_tablewee.dff","vc2sa/txd/hi_cutcluboffice.txd");
AddVC2SASimpleObject(160,-20357,"vc2sa/dff/cl_bckrm_couchs.dff","vc2sa/txd/hi_cutcluboffice.txd");
AddVC2SASimpleObject(160,-20358,"vc2sa/dff/clubbackroom.dff","vc2sa/txd/hi_cutcluboffice.txd");
AddVC2SASimpleObject(164,-20359,"vc2sa/dff/cl_of_opac.dff","vc2sa/txd/hi_cutclof_opa.txd");
AddVC2SASimpleObject(164,-20360,"vc2sa/dff/cl_coolers.dff","vc2sa/txd/hi_cutclubbar.txd");
AddVC2SASimpleObject(160,-20361,"vc2sa/dff/cl_bar_temp1.dff","vc2sa/txd/hi_cutclubbar.txd");
AddVC2SASimpleObject(164,-20362,"vc2sa/dff/cl_ofs_props.dff","vc2sa/txd/hi_cuttblprop.txd");
AddVC2SASimpleObject(160,-20363,"vc2sa/dff/cl_yachtmdl.dff","vc2sa/txd/cl_yacht.txd");
AddVC2SASimpleObject(164,-20364,"vc2sa/dff/cl_lightsuprts.dff","vc2sa/txd/mainclub2.txd");
AddVC2SASimpleObject(160,-20365,"vc2sa/dff/cl_light_st.dff","vc2sa/txd/hi_cutmaincl.txd");
AddVC2SASimpleObject(160,-20366,"vc2sa/dff/cl_main_roomb.dff","vc2sa/txd/hi_cutmaincl.txd");
AddVC2SASimpleObject(160,-20367,"vc2sa/dff/cl_mainwallsb.dff","vc2sa/txd/hi_cutclwaltst.txd");
AddVC2SASimpleObject(160,-20368,"vc2sa/dff/cl_railingb.dff","vc2sa/txd/mainclub2.txd");
AddVC2SASimpleObject(160,-20369,"vc2sa/dff/cl_tbl_chait_tmpb.dff","vc2sa/txd/mainclub2.txd");
AddVC2SASimpleObject(160,-20370,"vc2sa/dff/cl_main_room12.dff","vc2sa/txd/hi_cutmaincl.txd");
AddVC2SASimpleObject(160,-20371,"vc2sa/dff/cl_main_roomb2.dff","vc2sa/txd/hi_cutmaincl.txd");
AddVC2SASimpleObject(160,-20372,"vc2sa/dff/cl_dancefloor.dff","vc2sa/txd/hi_cutmaincl.txd");
AddVC2SASimpleObject(164,-20373,"vc2sa/dff/cl_tablesetlrg.dff","vc2sa/txd/hi_cuttblprop.txd");
AddVC2SASimpleObject(160,-20374,"vc2sa/dff/cl_bckrm_tble.dff","vc2sa/txd/hi_cutcluboffice.txd");
AddVC2SASimpleObject(128,-20375,"vc2sa/dff/club_exterior01.dff","vc2sa/txd/cl_ext1.txd");
AddVC2SASimpleObject(32,-20376,"vc2sa/dff/bnk_maindr2.dff","vc2sa/txd/hi_cutbnkrecpt.txd", 1);
AddVC2SASimpleObject(32,-20377,"vc2sa/dff/bank_table1.dff","vc2sa/txd/bye_cutbnkcoch.txd");
AddVC2SASimpleObject(36,-20378,"vc2sa/dff/bank_palms02.dff","vc2sa/txd/vegetation.txd", 1);
AddVC2SASimpleObject(36,-20379,"vc2sa/dff/bank_table4.dff","vc2sa/txd/bye_cutbnkcoch.txd", 1);
AddVC2SASimpleObject(32,-20380,"vc2sa/dff/chairthings.dff","vc2sa/txd/bye_cutbnkcoch.txd", 1);
AddVC2SASimpleObject(32,-20381,"vc2sa/dff/bank_vault.dff","vc2sa/txd/hi_cutbnkvault.txd", 1);
AddVC2SASimpleObject(36,-20382,"vc2sa/dff/bank_palms09.dff","vc2sa/txd/vegetation.txd", 1);
AddVC2SASimpleObject(32,-20383,"vc2sa/dff/bank_other_strctr.dff","vc2sa/txd/hi_cutbnkmainnw.txd", 1);
AddVC2SASimpleObject(36,-20384,"vc2sa/dff/bank_table05.dff","vc2sa/txd/bye_cutbnkcoch.txd", 1);
AddVC2SASimpleObject(36,-20385,"vc2sa/dff/kb1_couch06.dff","vc2sa/txd/bye_cutbnkcoch.txd", 1);
AddVC2SASimpleObject(36,-20386,"vc2sa/dff/kb1_couch09.dff","vc2sa/txd/bye_cutbnkcoch.txd", 1);
AddVC2SASimpleObject(32,-20387,"vc2sa/dff/bankstructure4.dff","vc2sa/txd/hi_cutbnkmain3.txd", 1);
AddVC2SASimpleObject(36,-20388,"vc2sa/dff/bank_palms21.dff","vc2sa/txd/vegetation.txd", 1);
AddVC2SASimpleObject(36,-20389,"vc2sa/dff/bank_palms23.dff","vc2sa/txd/vegetation.txd", 1);
AddVC2SASimpleObject(32,-20390,"vc2sa/dff/bankrecept.dff","vc2sa/txd/hi_cutbnkrecpt.txd", 1);
AddVC2SASimpleObject(32,-20391,"vc2sa/dff/bnk_main_rework.dff","vc2sa/txd/hi_cutbnkmainnw.txd", 1);
AddVC2SASimpleObject(32,-20392,"vc2sa/dff/bnk_mainnewref.dff","vc2sa/txd/hi_cutbnkmainnw.txd", 1);
AddVC2SASimpleObject(32,-20393,"vc2sa/dff/bankrecept01.dff","vc2sa/txd/hi_cutbnkrecpt.txd", 1);
AddVC2SASimpleObject(36,-20394,"vc2sa/dff/bank_table10.dff","vc2sa/txd/bye_cutbnkcoch.txd", 1);
AddVC2SASimpleObject(36,-20395,"vc2sa/dff/bank_palms28.dff","vc2sa/txd/vegetation.txd", 1);
AddVC2SASimpleObject(36,-20396,"vc2sa/dff/kb1_couch15.dff","vc2sa/txd/bye_cutbnkcoch.txd", 1);
AddVC2SASimpleObject(32,-20397,"vc2sa/dff/bnk_man_ofc.dff","vc2sa/txd/hi_cutmngof.txd", 1);
AddVC2SASimpleObject(36,-20398,"vc2sa/dff/bank_palms32.dff","vc2sa/txd/vegetation.txd", 1);
AddVC2SASimpleObject(36,-20399,"vc2sa/dff/chairthings2.dff","vc2sa/txd/bye_cutbnkcoch.txd", 1);
AddVC2SASimpleObject(32,-20400,"vc2sa/dff/bank_officedesks1.dff","vc2sa/txd/bye_cutbnkcoch.txd", 1);
AddVC2SASimpleObject(32,-20401,"vc2sa/dff/elevator.dff","vc2sa/txd/hi_cutbnkrecpt.txd", 1);
AddVC2SASimpleObject(36,-20402,"vc2sa/dff/bnk_main_rooflights.dff","vc2sa/txd/hi_cutbnk_alp.txd", 1);
AddVC2SASimpleObject(36,-20403,"vc2sa/dff/bnk_lightsmain.dff","vc2sa/txd/hi_cutbnk_alp.txd", 1);
AddVC2SASimpleObject(36,-20404,"vc2sa/dff/bnk_recp_lites.dff","vc2sa/txd/hi_cutbnk_alp.txd", 1);
AddVC2SASimpleObject(36,-20405,"vc2sa/dff/man_monitors02.dff","vc2sa/txd/bye_cutbnkcoch.txd", 1);
AddVC2SASimpleObject(36,-20406,"vc2sa/dff/bnk_scrty_tbl.dff","vc2sa/txd/bye_cutbnkcoch.txd", 1);
AddVC2SASimpleObject(36,-20407,"vc2sa/dff/bnk_mngr_rf_lights.dff","vc2sa/txd/hi_cutbnk_alp.txd", 1);
AddVC2SASimpleObject(36,-20408,"vc2sa/dff/bnk_main_glass.dff","vc2sa/txd/hi_cutbnk_alp.txd", 1);
AddVC2SASimpleObject(32,-20409,"vc2sa/dff/bnk_mngr_chr.dff","vc2sa/txd/hi_cutbnkchr.txd", 1);
AddVC2SASimpleObject(32,-20410,"vc2sa/dff/bnk_man_ofc01.dff","vc2sa/txd/hi_cutmngof.txd", 1);
AddVC2SASimpleObject(32,-20411,"vc2sa/dff/bnk_valt_door.dff","vc2sa/txd/hi_cutbnkvault.txd", 1);
AddVC2SASimpleObject(32,-20412,"vc2sa/dff/bank_props2.dff","vc2sa/txd/bnk_propy.txd", 1);
AddVC2SASimpleObject(36,-20413,"vc2sa/dff/unrocketed_win1.dff","vc2sa/txd/hi_cutpropy.txd", 1);
AddVC2SASimpleObject(36,-20414,"vc2sa/dff/bnk_dsk_acses.dff","vc2sa/txd/hi_cutpropy.txd", 1);
AddVC2SASimpleObject(32,-20415,"vc2sa/dff/plnt_ref_bnk01.dff","vc2sa/txd/vegetation.txd");
AddVC2SASimpleObject(32,-20416,"vc2sa/dff/plnt_ref_bnk02.dff","vc2sa/txd/vegetation.txd");
AddVC2SASimpleObject(36,-20417,"vc2sa/dff/bnk_dsk_acsesno2.dff","vc2sa/txd/hi_cutpropy.txd", 1);
AddVC2SASimpleObject(32,-20418,"vc2sa/dff/bnk_maindr1.dff","vc2sa/txd/hi_cutbnkrecpt.txd", 1);
AddVC2SASimpleObject(32,-20419,"vc2sa/dff/striplights.dff","vc2sa/txd/striplights.txd");
AddVC2SASimpleObject(32,-20420,"vc2sa/dff/stripinter.dff","vc2sa/txd/wshstripint.txd");
AddVC2SASimpleObject(32,-20421,"vc2sa/dff/stripinterupside.dff","vc2sa/txd/stripinter.txd");
AddVC2SASimpleObject(32,-20422,"vc2sa/dff/stripback.dff","vc2sa/txd/stripback.txd");
AddVC2SASimpleObject(36,-20423,"vc2sa/dff/stripinterfloor.dff","vc2sa/txd/wshstripint.txd");
AddVC2SASimpleObject(132,-20424,"vc2sa/dff/ml_gapdoors.dff","vc2sa/txd/ml_clothes.txd");
AddVC2SASimpleObject(1156,-20425,"vc2sa/dff/ml_gapwindows01.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20426,"vc2sa/dff/ml_gapwindows02.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20427,"vc2sa/dff/ml_gapwindows03.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20428,"vc2sa/dff/ml_gapwindows04.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20429,"vc2sa/dff/ml_gapwindows05.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20430,"vc2sa/dff/ml_gapwindows06.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20431,"vc2sa/dff/ml_gapwindows07.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20432,"vc2sa/dff/ml_gapwindows08.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20433,"vc2sa/dff/ml_gapwindows09.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20434,"vc2sa/dff/ml_gapwindows10.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20435,"vc2sa/dff/ml_gapwindows11.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20436,"vc2sa/dff/ml_gapwindows12.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20437,"vc2sa/dff/ml_coffwin02.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20438,"vc2sa/dff/ml_coffwin01.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20439,"vc2sa/dff/ml_recordwin01.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20440,"vc2sa/dff/ml_recordwin02.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20441,"vc2sa/dff/ml_recordwin03.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20442,"vc2sa/dff/ml_recordwin04.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20443,"vc2sa/dff/ml_recordwin05.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20444,"vc2sa/dff/ml_recordwin06.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(2097312,-20445,"vc2sa/dff/ml_jewelwinframe02.dff","vc2sa/txd/ml_jewellers.txd");
AddVC2SASimpleObject(2097312,-20446,"vc2sa/dff/FIX_mlobjects.dff","vc2sa/txd/mall_props.txd");
AddVC2SASimpleObject(1156,-20447,"vc2sa/dff/ml_jewelwin01.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20448,"vc2sa/dff/ml_jewelwin02.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleObject(1156,-20449,"vc2sa/dff/ml_jewelwin03.dff","vc2sa/txd/ml_coffee.txd");
AddVC2SASimpleTimed(0,5,22,-20450,"vc2sa/dff/xod_leslie_dy.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleTimed(0,5,22,-20451,"vc2sa/dff/xod_starlite_dy.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleTimed(0,5,22,-20452,"vc2sa/dff/xod_majestic_dy.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleTimed(0,5,22,-20453,"vc2sa/dff/xod_beacon_dy.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleTimed(0,5,22,-20454,"vc2sa/dff/xod_macalpin_dy.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleTimed(0,5,22,-20455,"vc2sa/dff/xod_tides_dy.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleTimed(0,22,5,-20456,"vc2sa/dff/xod_leslie_nt.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleTimed(0,22,5,-20457,"vc2sa/dff/xod_starlite_nt.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleTimed(0,22,5,-20458,"vc2sa/dff/xod_majestic_nt.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleTimed(0,22,5,-20459,"vc2sa/dff/xod_beacon_nt.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleTimed(0,22,5,-20460,"vc2sa/dff/xod_macalpin_nt.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleTimed(0,22,5,-20461,"vc2sa/dff/xod_tides_nt.dff","vc2sa/txd/xrefhotels.txd");
AddVC2SASimpleObject(0,-20462,"vc2sa/dff/wshxrefhirise1.dff","vc2sa/txd/wshxrefhirise.txd");
AddVC2SASimpleTimed(0,5,21,-20463,"vc2sa/dff/RoosbrgeStart_r_dt.dff","vc2sa/txd/bwidge.txd");
AddVC2SASimpleObject(384,-20464,"vc2sa/dff/LODfroad3.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(0,-20465,"vc2sa/dff/gf_northbridge1.dff","vc2sa/txd/gf_northbridge.txd");
AddVC2SASimpleObject(0,-20466,"vc2sa/dff/gf_mainisland6a_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(128,-20467,"vc2sa/dff/gf_flagstees2.dff","vc2sa/txd/gfflag.txd");
AddVC2SASimpleObject(4,-20468,"vc2sa/dff/gf_hedge5_01.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(0,-20469,"vc2sa/dff/gf_mainisland2a_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-20470,"vc2sa/dff/gf_northisland2.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(384,-20471,"vc2sa/dff/LODfroad5.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(0,-20472,"vc2sa/dff/gf_mainisland3a_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-20473,"vc2sa/dff/nbt_road12_gf.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-20474,"vc2sa/dff/gf_smallislebridge1.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-20475,"vc2sa/dff/gf_mainisland1a_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(384,-20476,"vc2sa/dff/LODfroad1.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(0,-20477,"vc2sa/dff/gf_pedbridge3.dff","vc2sa/txd/golf_bridge.txd");
AddVC2SASimpleObject(384,-20478,"vc2sa/dff/LOD_road12_gf.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(0,-20479,"vc2sa/dff/gf_northisland1c.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-20480,"vc2sa/dff/gf_mainisland1m_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-20481,"vc2sa/dff/gf_northisland1b.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(0,-20482,"vc2sa/dff/gf_northisland1.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(128,-20483,"vc2sa/dff/gf_ivy_balcny_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-20484,"vc2sa/dff/gf_mainisland6n_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(132,-20485,"vc2sa/dff/gf_tennisfence.dff","vc2sa/txd/gfflag.txd");
AddVC2SASimpleObject(4,-20486,"vc2sa/dff/gf_hedge3_01.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(0,-20487,"vc2sa/dff/gf_mainisland1b_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(4,-20488,"vc2sa/dff/gf_hedge1_01.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(0,-20489,"vc2sa/dff/gf_smallisland1_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(128,-20490,"vc2sa/dff/gf_flagstees3.dff","vc2sa/txd/gfflag.txd");
AddVC2SASimpleObject(4,-20491,"vc2sa/dff/gf_hedge2_01.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(128,-20492,"vc2sa/dff/gf_flagstees4.dff","vc2sa/txd/gfflag.txd");
AddVC2SASimpleObject(132,-20493,"vc2sa/dff/gf_water03.dff","vc2sa/txd/gfwater.txd");
AddVC2SASimpleObject(128,-20494,"vc2sa/dff/nt_security1.dff","vc2sa/txd/golf_clubhouse1.txd");
AddVC2SASimpleObject(132,-20495,"vc2sa/dff/gf_water02.dff","vc2sa/txd/gfwater.txd");
AddVC2SASimpleObject(4,-20496,"vc2sa/dff/golf_gatesclosed.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(4,-20497,"vc2sa/dff/golf_gatesopen.dff","vc2sa/txd/gf_hedge1.txd");
AddVC2SASimpleObject(384,-20498,"vc2sa/dff/LODcland13_gf.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(132,-20499,"vc2sa/dff/gf_tree2_02.dff","vc2sa/txd/gfpalms.txd");
AddVC2SASimpleObject(128,-20500,"vc2sa/dff/gf_ivy_balcny_07.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(132,-20501,"vc2sa/dff/gf_water01.dff","vc2sa/txd/gfwater.txd");
AddVC2SASimpleObject(0,-20502,"vc2sa/dff/gf_mainisl4_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(384,-20503,"vc2sa/dff/LODsmallislebridge1.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(128,-20504,"vc2sa/dff/gf_clublight1_01.dff","vc2sa/txd/golf_clubhouse1.txd");
AddVC2SASimpleObject(0,-20505,"vc2sa/dff/gf_northisland3.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(132,-20506,"vc2sa/dff/gf_stadlight1_02.dff","vc2sa/txd/golf_clubhouse2.txd");
AddVC2SASimpleObject(384,-20507,"vc2sa/dff/LODmainisland6b_01.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(384,-20508,"vc2sa/dff/LODmainisland6a_01.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(384,-20509,"vc2sa/dff/LODmainisl5_01.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(384,-20510,"vc2sa/dff/LODclubhouse1.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(384,-20511,"vc2sa/dff/LODmainisl4_01.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(384,-20512,"vc2sa/dff/LODmainisland1b_01.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(132,-20513,"vc2sa/dff/gf_picket1_01.dff","vc2sa/txd/golf_clubhouse2.txd");
AddVC2SASimpleObject(128,-20514,"vc2sa/dff/gf_clubhouse1.dff","vc2sa/txd/golf_clubhouse1.txd");
AddVC2SASimpleObject(128,-20515,"vc2sa/dff/gf_planters2.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(0,-20516,"vc2sa/dff/gf_mainisland6b_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(384,-20517,"vc2sa/dff/LODmainisland3b_01.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(0,-20518,"vc2sa/dff/gf_mainisl2b_01.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(260,-20519,"vc2sa/dff/gf_treesfw5_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(384,-20520,"vc2sa/dff/LODnorthisland3.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(384,-20521,"vc2sa/dff/LODsmallisland1_01.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(132,-20522,"vc2sa/dff/gf_tree1_01.dff","vc2sa/txd/gfpalms.txd");
AddVC2SASimpleObject(384,-20523,"vc2sa/dff/LODmainisl2b_01.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(384,-20524,"vc2sa/dff/LODmainisland3a_01.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(128,-20525,"vc2sa/dff/gf_planters4.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(260,-20526,"vc2sa/dff/gf_treesfw1_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(384,-20527,"vc2sa/dff/LODnorthisland1.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(260,-20528,"vc2sa/dff/gf_treesfw2_01.dff","vc2sa/txd/GenericVC.txd");
AddVC2SASimpleObject(384,-20529,"vc2sa/dff/LODnorthisland2.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(384,-20530,"vc2sa/dff/LODmainisland1a_01.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(128,-20531,"vc2sa/dff/nt_roadblockGF.dff","vc2sa/txd/gf_roadblock.txd");
AddVC2SASimpleObject(0,-20532,"vc2sa/dff/golfroad5.dff","vc2sa/txd/golf3.txd");
AddVC2SASimpleObject(384,-20533,"vc2sa/dff/LODpedbridge3.dff","vc2sa/txd/gf_LOD.txd");
AddVC2SASimpleObject(0,-20534,"vc2sa/dff/golfroad3.dff","vc2sa/txd/golf3.txd");
}