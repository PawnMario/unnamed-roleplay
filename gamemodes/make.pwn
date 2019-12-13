
    if(AreaData[aFlags] & A_FLAG_MISSION)
    {
        if(MissionData[playerid][mUID] != 0 && MissionData[playerid][mVictim] == AreaData[aUID])
        {
	    	new mission_uid = MissionData[playerid][mUID], mission_type = MissionData[playerid][mType],
	     		mission_leader = GetMissionLeader(mission_uid);

			if(MissionData[playerid][mDate] + MissionData[playerid][mTime] < gettime())
			{
				foreach(new i : MissionPlayer[mission_leader])
				{
					TD_ShowHint(i, HINT_NONE, 15, "Czas wykonania zadania zostal ~r~przekroczony~w~. Niestety ~r~nie udalo ~w~sie go prawidlowo wykonac.");

					DisablePlayerCheckpoint(i);
					PlayerCache[i][pCheckpoint] = CHECKPOINT_NONE;
				}
				DeleteMission(mission_uid);
			    return 1;
			}

			if(MissionData[playerid][mMembers] > 0)
			{
				new count_members;
			    foreach(new i : MissionPlayer[mission_leader])
			    {
       				if(PlayerToPlayer(10.0, i, playerid))
			        {
						count_members ++;
      				}
		    	}
			    if(count_members < MissionData[playerid][mMembers])
			    {
					TD_ShowSmallInfo(playerid, 5, "Zaczekaj, az wszyscy ~y~czlonkowie ~w~zadania pojawia sie na ~r~miejscu~w~.");
     				return 1;
		    	}
			}
	  		if(mission_type == MISSION_SMUGGLE)
	    	{
				// Przyjazd na miejsce
	   			if(MissionData[playerid][mLevel] == 0)
	      		{
					if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
					{
	    				TD_ShowSmallInfo(playerid, 5, "Musicie w to miejsce wjechac ~r~pojazdem ~w~dostawczym.");
					    return 1;
					}
					new vehid = GetPlayerVehicleID(playerid);
					if(!IsVehicleVan(vehid))
					{
	    				TD_ShowSmallInfo(playerid, 5, "Ten pojazd ~r~nie jest ~w~pojazdem dostawczym (np. Rumpo).");
					    return 1;
					}
					new object_id, crates = 0,
						Float:PosX, Float:PosY, Float:PosZ, virtual_world = GetPlayerVirtualWorld(playerid);

					GetPlayerPos(playerid, PosX, PosY, PosZ);

					new ObjectData[MAX_VIS_OBJECTS],
						count_objects = Streamer_GetNearbyItems(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, ObjectData, MAX_VIS_OBJECTS, 200.0, virtual_world);

					for (new object = 0; object < count_objects; object++)
					{
						object_id = ObjectData[object];
						if(GetObjectModel(object_id) == OBJECT_SMUGGLE_CRATE)
						{
							GetDynamicObjectPos(object_id, PosX, PosY, PosZ);
		 					foreach(new i : MissionPlayer[mission_leader])
							{
			    				SetPlayerMapIcon(i, crates, PosX, PosY, PosZ, 56, 0);
			    				if(!Streamer_IsInArrayData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_PLAYER_ID, i))	Streamer_AppendArrayData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_PLAYER_ID, i);
							}
							crates ++;
						}
					}

					foreach(new i : MissionPlayer[mission_leader])
					{
	    				MissionData[i][mLevel] = 1;

						MissionData[i][mPoints] = 0;
						MissionData[i][mNeedPoints] = crates;

						MissionData[i][mValue][0] = vehid;
		    			MissionData[i][mValue][1] = gettime();

		    			TD_ShowHint(i, HINT_NONE, 0, "Musicie teraz zapakowac ~y~towar ~w~na busa. Na minimapie pokazano miejsca, w ktorych znajduja sie ~r~skrzynki~w~.~n~~n~Podejdz do skrzynki i wcisnij klawisz ~y~Y~w~, by ja podniesc.~n~~n~Zapakowane towary: %d~n~Pozostalo: %d", MissionData[i][mPoints], MissionData[i][mNeedPoints]);
					}
					return 1;
				}
    		}
		}
    }
    
    
    
stock GetRandomAreaID(flags)
{
	new areaid = INVALID_AREA_ID, AreaData[sAreaData],
		count_areas = Streamer_GetUpperBound(STREAMER_TYPE_AREA);

	new Areas[100], areas;
	for (new area = 0; area <= count_areas; area++)
	{
 		if(IsValidDynamicArea(area))
   		{
   			Streamer_GetArrayData(STREAMER_TYPE_AREA, area, E_STREAMER_EXTRA_ID, AreaData);
   			if(AreaData[aFlags] & flags)
   			{
		    	Areas[areas] = area;
		    	areas ++;

		    	if(areas >= 100)    break;
			}
	    }
	}
	if(areas > 0)	areaid = Areas[random(areas)];
	
	return areaid;
}

public OnPlayerStartMission(playerid, mission_uid)
{
	if(MissionData[playerid][mUID] != 0)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie wykonujesz ju¿ jakieœ zadanie.");
	    return 1;
	}

	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(MissionData[i][mUID] == mission_uid)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ktoœ aktualnie wykonuje to zadanie.");
	            return 1;
	        }
	    }
	}

	new group_id = MissionData[playerid][mGroup], count_members;
	if(MissionData[playerid][mMembers] > 0)
	{
	    foreach(new i : Player)
	    {
			if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
			{
			    if(PlayerCache[i][pDuty][DUTY_GROUP] == group_id)
			    {
					if(PlayerToPlayer(10.0, i, playerid))
					{
						count_members ++;
						Iter_Add(MissionPlayer[playerid], i);
					}
			    }
			}
	    }
	    if(count_members < MissionData[playerid][mMembers])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Do rozpoczêcia tego zadania potrzebujesz %d osób.\nOsoby te musz¹ znajdowaæ siê w pobli¿u Ciebie bêd¹c na s³u¿bie tej samej grupy.", MissionData[playerid][mMembers]);
			Iter_Clear(MissionPlayer[playerid]);
			return 1;
	    }

	    new list_members[128];

	    // Rozpoczynamy zadanie wszystkim
		foreach(new i : MissionPlayer[playerid])
		{
  			MissionData[i][mUID] = mission_uid;
			MissionData[i][mType] = MissionData[playerid][mType];

			MissionData[i][mVictim] = MissionData[playerid][mVictim];
			MissionData[i][mMembers] = MissionData[playerid][mMembers];

			MissionData[i][mAward] = MissionData[playerid][mAward];

			MissionData[i][mDate] = MissionData[playerid][mDate];
			MissionData[i][mTime] = MissionData[playerid][mTime];

			MissionData[i][mGroup] = MissionData[playerid][mGroup];
			MissionData[i][mLeader] = false;

			SetPlayerMarkerForPlayer(playerid, i, GroupData[group_id][gColor]);
			SetPlayerMarkerForPlayer(i, playerid, GroupData[group_id][gColor]);

			format(list_members, sizeof(list_members), "%s~n~~y~%s (%d)", list_members, PlayerName(i), i);
			TD_ShowHint(i, HINT_NONE, 0, "~p~%s ~w~rozpoczal nowe ~g~zadanie. ~w~Lista czlonkow:~n~~n~%s~n~~n~~w~Podazajcie za ~r~znacznikami~w~, by otrzymywac dalsze ~b~wskazowki ~w~dotyczace zadania.", PlayerName(playerid), list_members);
		}

		// Przywódca
		MissionData[playerid][mLeader] = true;
	}

	new mission_type = MissionData[playerid][mType], time = gettime();

	// Zg³oszenie
	if(mission_type == MISSION_NOTIFICATION)
	{
	    if(MissionData[playerid][mDate] + MissionData[playerid][mTime] < time)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "To zadanie przedawni³o siê.");
	        DeleteMission(mission_uid);
	        return 1;
	    }
		new giveplayer_id = GetPlayerID(MissionData[playerid][mVictim]);
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "To zadanie przedawni³o siê.");
		    DeleteMission(mission_uid);
		    return 1;
		}
		new Float:posX, Float:posY, Float:posZ;
		GetPlayerPos(giveplayer_id, posX, posY, posZ);

		SetPlayerCheckpoint(playerid, posX, posY, posZ, 2.0);
		PlayerCache[playerid][pCheckpoint] = CHECKPOINT_MISSION;

		TD_ShowHint(giveplayer_id, HINT_NONE, 5, "Gracz ~y~%s ~w~zaakceptowal Twoje zgloszenie i juz do Ciebie jedzie.~n~~n~Czekaj tutaj cierpliwie.", PlayerName(playerid));
		TD_ShowHint(playerid, HINT_NONE, 5, "Zaakceptowales zgloszenie od ~y~%s~w~.~n~~n~Udaj sie do ~r~zaznaczonego ~w~na mapie punktu.", PlayerName(giveplayer_id));

		DeleteMission(mission_uid);
		return 1;
	}

	// Pal¹cy budynek
	if(mission_type == MISSION_FIRE_BUILD)
	{
	    if(MissionData[playerid][mVictim] == 0)
	    {
	        new doorid = GetRandomDoorID(OWNER_NONE), DoorData[sDoorInfo];
	        Streamer_GetArrayData(STREAMER_TYPE_PICKUP, doorid, E_STREAMER_EXTRA_ID, DoorData);

			new Float:PosX, Float:PosY, Float:PosZ,
				virtual_world, interior_id;

			Streamer_GetItemPos(STREAMER_TYPE_PICKUP, doorid, PosX, PosY, PosZ);

			virtual_world = Streamer_GetIntData(STREAMER_TYPE_PICKUP, doorid, E_STREAMER_WORLD_ID);
			interior_id = Streamer_GetIntData(STREAMER_TYPE_PICKUP, doorid, E_STREAMER_INTERIOR_ID);

			DoorData[dFireData][FIRE_OBJECT] = CreateDynamicObject(18690, PosX, PosY, PosZ - 2.0, 0.0, 0.0, 0.0, virtual_world, interior_id, -1, MAX_DRAW_DISTANCE);
			DoorData[dFireData][FIRE_LABEL] = _:CreateDynamic3DTextLabel("Ten budynek stan¹³ w p³omieniach!\nSzacowane zniszczenia: 0%", 0x33AA33FF, PosX, PosY, PosZ + 0.3, 15.0);

			foreach(new i : Player)
			{
	  			if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	   			{
	     			if(GetPlayerDoorID(i) == doorid)
	        		{
	          			SendClientMessage(i, COLOR_DO, "** W tym budynku z niewiadomych przyczyn wybucha po¿ar. Wszyscy powinni zacz¹æ siê ewakuowaæ. **");
			        }
			    }
			}

			CreateExplosion(PosX, PosY, PosZ, 1, 10.0);

			DoorData[dFireData][FIRE_TIME] = 1;
			Streamer_SetArrayData(STREAMER_TYPE_PICKUP, doorid, E_STREAMER_EXTRA_ID, DoorData);

			foreach(new i : MissionPlayer[playerid])    MissionData[i][mVictim] = DoorData[dUID];
	    }
	    else
	    {
   			// Budynek podpalony
   			if(MissionData[playerid][mDate] + MissionData[playerid][mTime] < time)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "To zadanie przedawni³o siê.");
		        DeleteMission(mission_uid);
		        return 1;
			}
	    }
		new doorid = GetDoorID(MissionData[playerid][mVictim]), Float:door_enter[3];
  		Streamer_GetItemPos(STREAMER_TYPE_PICKUP, doorid, door_enter[0], door_enter[1], door_enter[2]);

		foreach(new i : MissionPlayer[playerid])
		{
  			ShowPlayerInfoDialog(i, D_TYPE_INFO, "Na mapie zaznaczono punkt, w którym prawdopodobnie p³onie budynek.\nUdaj siê tam razem z dru¿yn¹, by otrzymywaæ dalsze wskazówki.\n\n\t\tNagroda: $%d\n\t\tCzas: %dh %dm", MissionData[playerid][mAward], MissionData[playerid][mTime] / 3600, MissionData[playerid][mTime] / 60 % 60);

			SetPlayerCheckpoint(i, door_enter[0], door_enter[1], door_enter[2], 5.0);
			PlayerCache[i][pCheckpoint] = CHECKPOINT_MISSION;
		}
	    return 1;
	}

	if(mission_type == MISSION_SMUGGLE)
	{
	    new areaid = (MissionData[playerid][mVictim] != 0) ? GetAreaID(MissionData[playerid][mVictim]) : GetRandomAreaID(A_FLAG_MISSION);
	    if(areaid == INVALID_AREA_ID)
	    {
	    	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "To zadanie przedawni³o siê.");
		    DeleteMission(mission_uid);
	        return 1;
	    }
	    new AreaData[sAreaData];
	    Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, AreaData);

		foreach(new i : MissionPlayer[playerid])
		{
  			ShowPlayerInfoDialog(i, D_TYPE_INFO, "Dostañcie siê w strefê, któr¹ zaznaczono na mapie.\nNa miejscu dostaniecie wskazówki odnoœnie przemytu.\n\n\t\tNagroda: $%d\n\t\tCzas: %dh %dm", MissionData[playerid][mAward], MissionData[playerid][mTime] / 3600, MissionData[playerid][mTime] / 60 % 60);

		   	GangZoneShowForPlayer(i, AreaData[aExtraID], COLOR_GREEN);
			GangZoneFlashForPlayer(i, AreaData[aExtraID], COLOR_RED);
		}
	    return 1;
	}
	return 1;
}
