new Float: LogAttachOffsets[10][4] = 
{
    {-0.223, -1.089, -0.230, -90.399},
	{-0.056, -1.091, -0.230, 90.399},
	{0.116, -1.092, -0.230, -90.399},
	{0.293, -1.088, -0.230, 90.399},
	{-0.123, -1.089, -0.099, -90.399},
	{0.043, -1.090, -0.099, 90.399},
	{0.216, -1.092, -0.099, -90.399},
	{-0.033, -1.090, 0.029, -90.399},
	{0.153, -1.089, 0.029, 90.399},
	{0.066, -1.091, 0.150, -90.399}
};

timer Tree_Cut[5000](playerid, object_id)
{
	if(!pInfo[playerid][player_cutting_tree]) return 1;
	new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
	GetDynamicObjectPos(object_id, x, y, z);
	GetDynamicObjectRot(object_id, rx, ry, rz);
	MoveDynamicObject(object_id, x, y, z + 0.03, 0.025, rx, ry -80.0, rz);
	pInfo[playerid][player_cutting_tree] = false;
	new skin = GetClientSkin(playerid);
	SetPlayerSkin(playerid, skin);
	TogglePlayerControllable(playerid, 0);
	TogglePlayerControllable(playerid, 1);
	return 1;
}

timer Fish_Get[5000](playerid, veh)
{
	if(!pInfo[playerid][player_fishing]) return 1;

	if(random(2) == 1)
	{
		Vehicle[veh][vehicle_fish_object] += 1;
		SendClientMessage(playerid, COLOR_GOLD, sprintf("Ryba zosta³a za³adowana do kutra. Pozosta³o miejsca na ryby: %d/10", 10-Vehicle[veh][vehicle_fish_object]));

		pInfo[playerid][player_fishing] = false;
	}
	else
	{
		SendGuiInformation(playerid, "Informacja", "Nie uda³o siê z³apaæ ryby, próbuj ponownie.");
	}

	return 1;
}

stock GetVehicleLogCount(vehicleid)
{
	if(GetVehicleModel(vehicleid) == 0) return 0;
	new count;
	for(new i; i < 10; i++) if(IsValidDynamicObject(Vehicle[vehicleid][vehicle_log_object][i])) count++;
	return count;
}

stock GetVehicleFishCount(vehicleid)
{
	return Vehicle[vehicleid][vehicle_fish_object];
}

stock GetClosestTrashObject(playerid)
{
	new object_id,
    	Float:prevdist = 2.0, OID = INVALID_STREAMER_ID, Float:PosX, Float:PosY, Float:PosZ, Float:dist;
    
	GetPlayerPos(playerid, PosX, PosY, PosZ);
 	for (new player_object = 0; player_object <= MAX_VISIBLE_OBJECTS; player_object++)
 	{
    	if(IsValidPlayerObject(playerid, player_object))
     	{
			object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);

        	if(Object[object_id][object_type] == OBJECT_TYPE_TRASH)
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

stock LoadTrashFactories()
{
	new label[128];
	for(new i; i < sizeof(FactoryData); i++)
	{
	    format(label, sizeof(label), "Sk³adowisko odpadów - %s\n\n{FFFFFF}Iloœæ odpadów: {F39C12}0", FactoryData[i][FactoryName]);
		FactoryData[i][FactoryLabel] = CreateDynamic3DTextLabel(label, COLOR_GOLD, FactoryData[i][FactoryX], FactoryData[i][FactoryY], FactoryData[i][FactoryZ] + 0.5, 15.0, .testlos = 1);
		FactoryData[i][FactoryCP] = CreateDynamicCP(FactoryData[i][FactoryX], FactoryData[i][FactoryY], FactoryData[i][FactoryZ], 6.0);
	}
}

stock ResetTrashmasterIcons(playerid)
{
	for(new i; i < sizeof(FactoryData); i++)
	{
		TogglePlayerDynamicCP(playerid, FactoryData[i][FactoryCP], 0);
		FactoryIcons[playerid][i] = -1;
	}
}