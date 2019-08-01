task MinuteTimer[60000]()
{	
  	new hour, minute, second;
	gettime(hour, minute, second);

	// Ustawiamy czas 
	WorldTime = hour;

	// Generowanie bonusowych dotacji dla firm
	if (hour == 3 && minute == 55)
	{
		printf("[SARP SETTINGS] Generowanie ustawien na kolejny dzien.");
		SendClientMessageToAll(COLOR_LIGHTER_RED, "San Andreas Roleplay: Generowanie ustawieñ na dzieñ kolejny. Mog¹ wyst¹piæ opóŸnienia.");

		//Wykres zarobkow
		foreach (new g : Groups)
		{
			mysql_tquery(mySQLconnection, sprintf("INSERT INTO ipb_group_charts (chart_group, chart_income, chart_timestamp) VALUES (%d, %d, %d)", Group[g][group_uid], Group[g][group_bank_money], gettime()));
		}
		
		mysql_query(mySQLconnection, "UPDATE ipb_game_groups SET group_dotation = 300 WHERE group_flags & 262144");
		mysql_query(mySQLconnection, "UPDATE ipb_char_groups JOIN ipb_game_groups ON ipb_char_groups.group_belongs = ipb_game_groups.group_uid  SET ipb_char_groups.group_payment = ipb_game_groups.group_dotation WHERE ipb_char_groups.group_payment > ipb_game_groups.group_dotation");

		new rows, Cache:tmp_cache;
		tmp_cache = mysql_query(mySQLconnection, "SELECT group_uid FROM ipb_game_groups WHERE group_activity > 0 AND group_flags & 262144 ORDER BY group_activity DESC");
		cache_get_row_count(rows);

		if(rows)
		{
			new guid;

			for(new row = 0; row != rows; row++)
			{
				if(row < 5)
				{
					cache_get_value_index_int(row, 0, guid);
					mysql_query(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_dotation = group_dotation + 100 WHERE group_uid = %d", guid), false);
					mysql_query(mySQLconnection, sprintf("UPDATE ipb_char_groups SET group_payment = group_payment + 100 WHERE group_belongs = %d", guid), false);
				}

				if(row >= 5 && row < 10)
				{
					cache_get_value_index_int(row, 0, guid);
					mysql_query(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_dotation = group_dotation + 50 WHERE group_uid = %d", guid), false);
					mysql_query(mySQLconnection, sprintf("UPDATE ipb_char_groups SET group_payment = group_payment + 50 WHERE group_belongs = %d", guid), false);
				}
				
			}
		}

		if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	}

	// Restart serwera
	if (hour == 4 && minute == 00)
	{
		SendClientMessageToAll(COLOR_LIGHTER_RED, "San Andreas Roleplay: Automatyczny restart serwera - 04:00.");
		
		foreach(new playerid: Player)
		{
			Kick(playerid);
		}

		//Mo¿e æwiczyæ
		mysql_query(mySQLconnection, "UPDATE ipb_characters SET char_training = 10");

		//Reset punktów aktywnoœci
		mysql_query(mySQLconnection, "UPDATE ipb_game_groups SET group_activity = 0");

		//Reset blokad 
		mysql_query(mySQLconnection, "DELETE FROM ipb_objects WHERE object_type = 2");

		//Reset wyp³at
		mysql_query(mySQLconnection, "UPDATE ipb_char_groups SET group_payday = 0, group_time = 0");

		defer RestartServer[5000]();
	}

	//Gangwars
	foreach(new warid: GangWars)
	{
		if(gettime() > GangWar[warid][war_end])
		{
			GangWarEnd(warid);

			new next;
		    Iter_SafeRemove(GangWars, warid, next);
		    warid = next;
		}
	}

	// Pozary here 
	foreach(new fsid: FireSources)
	{
		if(FireSource[fsid][fs_door] > 0)
		{
			if( DoorHasAccess(FireSource[fsid][fs_door], DOOR_ACCESS_FIRE_SPRINKLER) )
			{
				if(FireSource[fsid][fs_health] <= 25.0)
				{
					new str[10];
					FireSource[fsid][fs_health] += 5.0;
					format(str, sizeof(str), "%.2f%%", FireSource[fsid][fs_health]);
					UpdateDynamic3DTextLabelText(FireSource[fsid][fs_label], 0xF07800FF, str);

					if(FireSource[fsid][fs_health] == 30.0)
					{
						new d_id = FireSource[fsid][fs_door];
						Door[d_id][door_burned] = 30;
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_doors SET door_burned = 30 WHERE door_uid = %d", Door[d_id][door_uid]));
						StopFireSource(fsid);
						StopFire();
					}
				}
			}
			else
			{
				if(FireSource[fsid][fs_health] <= 90.0)
				{
					new str[10];
					FireSource[fsid][fs_health] += 10.0;
					format(str, sizeof(str), "%.2f%%", FireSource[fsid][fs_health]);
					UpdateDynamic3DTextLabelText(FireSource[fsid][fs_label], 0xF07800FF, str);

					if(FireSource[fsid][fs_health] > 9)
					{
						new d_id = FireSource[fsid][fs_door];
						Door[d_id][door_burned] = floatround(FireSource[fsid][fs_health]);
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_doors SET door_burned = %d WHERE door_uid = %d", Door[d_id][door_burned], Door[d_id][door_uid]));
					}
					else if(FireSource[fsid][fs_health] > 99)
					{
						new d_id = FireSource[fsid][fs_door];
						Door[d_id][door_burned] = 100;
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_doors SET door_burned = 100 WHERE door_uid = %d", Door[d_id][door_uid]));
						StopFireSource(fsid);
						StopFire();
					}
				}
			}
		}
	}

	foreach(new playerid : Player)
	{
		// Ustawiamy godzine dla gracza 
		if(GetPlayerVirtualWorld(playerid) == 0)
		{
			SetPlayerTime(playerid, WorldTime+2, 0);
		}

		// Niszczenie interioru
		if(pInfo[playerid][player_demolition] > 0)
		{
			if(GetPlayerVirtualWorld(playerid) == pInfo[playerid][player_demolition])
			{
				new d_id = GetDoorByUid(pInfo[playerid][player_demolition]);

				if(Door[d_id][door_demolition] <= 90)
				{
					Door[d_id][door_demolition] += 10;

					TextDrawSetString(Tutorial[playerid], sprintf("Niszczenie ~p~wnetrza~w~ w toku.~n~Aktualny stan zniszczen: ~r~~h~~h~%d%%~n~~w~Kazda minuta to 10 procent zniszczen.", Door[d_id][door_demolition]));
					TextDrawShowForPlayer(playerid, Tutorial[playerid]);

					if(Door[d_id][door_demolition] >= 100)
					{
						SendClientMessage(playerid, COLOR_GOLD, "Wnêtrze, które demolowa³eœ zosta³o zniszczone w stu procentach, wymaga teraz ca³kowitego remontu.");
						Door[d_id][door_destroyed] = 100;
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_doors SET door_destroyed = 100 WHERE door_uid = %d", Door[d_id][door_uid]));
						TextDrawHideForPlayer(playerid, Tutorial[playerid]);
						pInfo[playerid][player_demolition] = 0;
					}
				}
			}
			else if(GetPlayerVirtualWorld(playerid) == 0)
			{
				new d_id = GetDoorByUid(pInfo[playerid][player_demolition]);
				SendClientMessage(playerid, COLOR_GOLD, sprintf("Wnêtrze, które demolowa³eœ zosta³o zniszczone w %d procentach, wymaga teraz remontu.", Door[d_id][door_demolition]));
				Door[d_id][door_destroyed] = Door[d_id][door_demolition];
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_doors SET door_destroyed = %d WHERE door_uid = %d", Door[d_id][door_demolition], Door[d_id][door_uid]));
				TextDrawHideForPlayer(playerid, Tutorial[playerid]);
				pInfo[playerid][player_demolition] = 0;
			}
		}

		// Silownia
		if(pInfo[playerid][player_training] == true)
		{
			if(pInfo[playerid][player_gym_carnet] > 0)
			{
				new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_GYM_KARNET);
				if(itemid != -1)
				{
					if(pInfo[playerid][player_health] >= 10)
					{
						SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health])-1);
					}

					PlayerItem[playerid][itemid][player_item_value1] --;
					mysql_query(mySQLconnection, sprintf("UPDATE ipb_items SET item_value1 = %d WHERE item_uid = %d", PlayerItem[playerid][itemid][player_item_value1], PlayerItem[playerid][itemid][player_item_uid]));
				}

				pInfo[playerid][player_gym_carnet]--;
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_training = %d WHERE char_uid = %d", pInfo[playerid][player_gym_carnet], pInfo[playerid][player_id]));
			}
		}

		// Sprawdzamy czy mo¿e wyjœæ z paki 
		if(pInfo[playerid][player_arrest] > 0)
        {
            if(pInfo[playerid][player_arrest] < gettime())
            {
                mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_spawn = 0, char_spawn_type = 1, char_arrest = 0 WHERE char_uid = %d", pInfo[playerid][player_id]));
                SendGuiInformation(playerid, "Informacja", "Czas twojej odsiadki dobieg³ koñca.");
 				RemovePlayerStatus(playerid, PLAYER_STATUS_JAIL); 
 				pInfo[playerid][player_arrest] = 0;       
 			}
        }

		// Poprawiamy ostatni skin 
		pInfo[playerid][player_last_skin] = GetPlayerSkin(playerid);

		// Sprawdzamy czy mo¿e wyjœæ z AJ
		if(pInfo[playerid][player_aj] > 0)
		{
			if(pInfo[playerid][player_aj] == 1)
			{
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_aj = 0 WHERE char_uid = %d", pInfo[playerid][player_id]));
				SetPlayerVirtualWorld(playerid, 0);
				scrp_SpawnPlayer(playerid, true);
				pInfo[playerid][player_aj] = 0;
			}
			else
			{
				pInfo[playerid][player_aj]--;
				GameTextForPlayer(playerid,  sprintf("~w~koniec ~y~aj~w~: ~y~%d ~w~min.", pInfo[playerid][player_aj]), 5000, 1);
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_aj = %d WHERE char_uid = %d", pInfo[playerid][player_aj], pInfo[playerid][player_id]));
			}
		}

		// Naliczamy czas gry i sluzby
		if( pInfo[playerid][player_afk] == false )
		{
			pInfo[playerid][player_minutes] ++;

			if(pInfo[playerid][player_minutes] == 30)
			{
				if(pInfo[playerid][player_health] >= 10)
				{
					SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health])-2);
				}
			}

		    if(pInfo[playerid][player_minutes] > 59)
		    {
		    	pInfo[playerid][player_hours] ++;
		    	GivePlayerMoney(playerid, 50);
		    	SendPlayerInformation(playerid, "Otrzymujesz ~g~~h~$50~w~ za przegrana godzine.", 5000);

		    	if(pInfo[playerid][player_hours] == 1 && !PlayerHasAchievement(playerid, ACHIEV_NOOB)) AddAchievement(playerid, ACHIEV_NOOB, 50);
		    	if(pInfo[playerid][player_hours] == 50 && !PlayerHasAchievement(playerid, ACHIEV_50H)) AddAchievement(playerid, ACHIEV_50H, 500);
		    	if(pInfo[playerid][player_hours] == 500 && !PlayerHasAchievement(playerid, ACHIEV_500H)) AddAchievement(playerid, ACHIEV_500H, 1000);
		    	if(pInfo[playerid][player_hours] == 1000 && !PlayerHasAchievement(playerid, ACHIEV_1000H)) AddAchievement(playerid, ACHIEV_1000H, 2500);

		    	pInfo[playerid][player_minutes] =0;
		    	
				if(IsPlayerVip(playerid))
				{
					pGlobal[playerid][glo_score] += 20;
				}
				else							
				{
					pGlobal[playerid][glo_score] += 10;
				}
				
		    	SetPlayerScore(playerid, pGlobal[playerid][glo_score]);
			}

			if(pInfo[playerid][player_duty_gid] != -1)
			{
				new slot = GetPlayerDutySlot(playerid);
				if(slot != -1)
				{
					//if(pGroup[playerid][slot][pg_duty_time] < 60)
					//{
					pGroup[playerid][slot][pg_duty_time]++;
					//}

					if(pGroup[playerid][slot][pg_duty_time] >= 20 && pGroup[playerid][slot][pg_payday_count] < 3 && pGroup[playerid][slot][pg_rank_payment] > 0)
					{
						new payday;
						if(GroupHasFlag(pInfo[playerid][player_duty_gid], GROUP_FLAG_BUSINESS))
						{
							switch(pGroup[playerid][slot][pg_payday_count])
							{
								case 0:
								{
									payday = pGroup[playerid][slot][pg_rank_payment];
								}
								case 1:
								{
									new Float:pay_percent = pGroup[playerid][slot][pg_rank_payment]*0.30;
									payday = pGroup[playerid][slot][pg_rank_payment]-floatround(pay_percent);
								}
								case 2:
								{
									new Float:pay_percent = pGroup[playerid][slot][pg_rank_payment]*0.60;
									payday = pGroup[playerid][slot][pg_rank_payment]-floatround(pay_percent);
								}
							}

							if(Group[pInfo[playerid][player_duty_gid]][group_bonus] > 0)
							{
								new Float:pay_percent = payday*0.10;
								payday = payday + floatround(pay_percent);
								SendClientMessage(playerid, COLOR_YELLOW, sprintf("> (SMS) [755] Bank: Wyp³ata wp³ynê³a na konto. Wartoœæ: $%d (z bonusem handlowym).", payday));
							}
							else
							{
								SendClientMessage(playerid, COLOR_YELLOW, sprintf("> (SMS) [755] Bank: Wyp³ata wp³ynê³a na konto. Wartoœæ: $%d.", payday));
							}

							pGroup[playerid][slot][pg_payday_count]++;
							pGroup[playerid][slot][pg_duty_time] = 0;

							pInfo[playerid][player_bank_money] += payday;
							mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_bankcash = char_bankcash + %d WHERE char_uid = %d", payday, pInfo[playerid][player_id]));

							if(pInfo[playerid][player_health] >= 10)
							{
								SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health])-3);
							}

							if(!PlayerHasAchievement(playerid, ACHIEV_WORKER)) AddAchievement(playerid, ACHIEV_WORKER, 50);

							cmd_g(playerid, sprintf("%d duty", slot+1));
						}
						else
						{
							if(pGroup[playerid][slot][pg_payday_count] < 1)
							{
								payday = pGroup[playerid][slot][pg_rank_payment];
								pGroup[playerid][slot][pg_payday_count]++;
								pGroup[playerid][slot][pg_duty_time] = 0;

								SendClientMessage(playerid, COLOR_YELLOW, sprintf("> (SMS) [755] Bank: Wyp³ata wp³ynê³a na konto. Wartoœæ: $%d.", payday));
								pInfo[playerid][player_bank_money] += payday;
								mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_bankcash = char_bankcash + %d WHERE char_uid = %d", payday, pInfo[playerid][player_id]));

								cmd_g(playerid, sprintf("%d duty", slot+1));

								if(!PlayerHasAchievement(playerid, ACHIEV_WORKER)) AddAchievement(playerid, ACHIEV_WORKER, 50);

								if(pInfo[playerid][player_health] >= 10)
								{
									SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health])-3);
								}
							}
						}
					}
				}
			}
		}
	}

	timer_minutes += 1;

	if(timer_minutes == 60)
	{
		switch(random(2))
		{
			case 0: //Statek liberty wplywa, azjatycki wyplywa
			{
				if(IsValidDynamicObject(liberty_ship)) MoveDynamicObject(liberty_ship, 2647.89, -2278.95, 18.34, 10.0, 0.0, 0.0, 0.0);
				defer SetShipOldPosition[20000](asian_ship);
				//todo zaladuj kontenery w ondynamicobjectmoved
				//todo usun stare kontenery w timerze
				foreach(new playerid: Player)
				{
					new Float:x, Float:y, Float:z;
					GetDynamicObjectPos(asian_ship, x, y, z);
					if(IsPlayerInRangeOfPoint(playerid, 20.0, x, y, z)) SendClientMessage(playerid, 0x9B91ECFF, "** Statek handlowy Hanjin Lines odp³ywa za 20 sekund.");
				}
			}
			case 1: //Statek azjatycki wplywa, liberty wyplywa
			{
				if(IsValidDynamicObject(asian_ship)) MoveDynamicObject(asian_ship, 2551.52, -2683.04, 22.90, 10.0, 0.0, 0.0, 90.0);
				defer SetShipOldPosition[20000](liberty_ship);
				foreach(new playerid : Player)
				{
					new Float:x, Float:y, Float:z;
					GetDynamicObjectPos(liberty_ship, x, y, z);
					if(IsPlayerInRangeOfPoint(playerid, 20.0, x, y, z)) SendClientMessage(playerid, 0x9B91ECFF, "** Statek handlowy Chartered Libertine Lines odp³ywa za 20 sekund.");
				}
			}
		}

		SpreadFire();
		SetupFires();
		timer_minutes = 0;
	}

	return 1;
}

task SlotTimer[500]()
{
	foreach(new playerid: SlotPlayers)
	{
		if(pInfo[playerid][player_slot_spin])
		{
			for(new i=0;i<15;i++)
			{
				PlayerTextDrawHide(playerid, BodSymbols[playerid][i][symbol_textdraw]);
				new rands = random(15);
				PlayerTextDrawSetString(playerid, BodSymbols[playerid][i][symbol_textdraw], BodSymbols[playerid][rands][symbol_model]);
				PlayerTextDrawShow(playerid, BodSymbols[playerid][i][symbol_textdraw]);
			}
		}
	}
}

timer SetShipOldPosition[1000](oid)
{
	MoveDynamicObject(oid, Object[oid][object_pos][0], Object[oid][object_pos][1], Object[oid][object_pos][2], 10.0, Object[oid][object_pos][3], Object[oid][object_pos][4], Object[oid][object_pos][5]);
	//todo usun kontenery
}

timer DropCocaine[7000](Float:x, Float:y, Float:z)
{
	new Float:angle = 90.0;

	plane_object = CreateObject(1681, x + (300.0 * -floatsin(-angle, degrees)), y + (300.0 * -floatcos(-angle, degrees)), z + 75.0, 0.0, 0.0, angle);
	new time = MoveObject(plane_object, x + (300.0 * floatsin(-angle, degrees)), y + (300.0 * floatcos(-angle, degrees)), z + 75.0, 60.0);
    
    new alltime = floatround(time / 2.5);

    defer MakeDrop[alltime](x, y, z);
	
	new playerd = GetPlayerByUid(drop);
	if(IsPlayerConnected(playerd)) SendClientMessage(playerd, COLOR_YELLOW, "> (SMS) [Nieznany numer] Pilot: Zbli¿am siê do celu.");
    return 1;
}

timer MakeDrop[1000](Float:dropx, Float:dropy, Float:dropz)
{
	new Float: plx, Float: ply, Float: plz;
	GetObjectPos(plane_object, plx, ply, plz);
	
	box_object = CreateObject(2975, plx, ply, plz - 15.0, 0.0, 0.0, 0.0);
	para_object = CreateObject(18849, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
 	SetObjectMaterial(para_object, 2, 19478, "signsurf", "sign", 0xFFFFFFFF);
	AttachObjectToObject(para_object, box_object, 0.0, -0.05, 7.5, 0.0, 0.0, 0.0);
	MoveObject(box_object, dropx, dropy, dropz, 8.0);

	new playerd = GetPlayerByUid(drop);
	if(IsPlayerConnected(playerd))
	{
		SendClientMessage(playerd, COLOR_YELLOW, "> (SMS) [Nieznany numer] Pilot: Przesy³ka zrzucona."); 
		TextDrawHideForPlayer(playerd, Tutorial[playerd]);
	}

    return 1;
}

timer Msel[1000](playerid, oid)
{
	cmd_mselid(playerid, sprintf("%d", oid));
}

timer UnfreezePlayer[1000](playerid)
{
	TogglePlayerControllable(playerid, 1);
}

timer ExplodeObject[1000](objectid)
{
	new Float:x, Float:y, Float:z;
	GetDynamicObjectPos(objectid, x, y, z);
	CreateExplosion(x, y, z, 12, 10.0);

	if(Object[objectid][object_model] == OBJECT_SAFE_DOOR)
	{
		GetXYInBackOfObject(objectid, x, y, 1.0);
		new cash_pickup = CreateDynamicPickup(1212, 1, x, y, z, Object[objectid][object_vw]);
		Pickup[cash_pickup][pickup_type] = PICKUP_TYPE_CASH;
		Pickup[cash_pickup][pickup_extra][0] = 1550+random(1500);
		Pickup[cash_pickup][pickup_extra][1] = Object[objectid][object_owner];
	}

	DeleteObject(objectid, false);
}

timer StopSmoking[1000](objectid)
{
	DestroyDynamicObject(objectid);
}

timer StartTraining[1000](playerid)
{
	SetPlayerAttachedObject(playerid, ATTACH_SLOT_GYM1, 3072, 5); // lewa reka
	SetPlayerAttachedObject(playerid, ATTACH_SLOT_GYM2, 3071, 6); // prawa reka

	new LocalLabel[170];
	format(LocalLabel,sizeof(LocalLabel),"~w~Wciskaj ~y~strzalki ~u~ ~d~ ~w~ aby wyciskac.~n~~n~Wycisniecia: ~y~%d~n~~w~Sila: ~y~%.2f%%~n~~w~Czas karnetu: ~y~%dmin~n~~n~~w~Uzyj ponownie /trenuj by zakonczyc.", pInfo[playerid][player_gym_count], pInfo[playerid][player_strength], pInfo[playerid][player_gym_carnet]);
	TextDrawSetString(Tutorial[playerid], LocalLabel);
	TextDrawShowForPlayer(playerid, Tutorial[playerid]);
	
	pInfo[playerid][player_training] = true;
}


timer ResetDumb[2000](playerid, type)
{
	if(type == 1)
	{
		pInfo[playerid][player_can_train] = 2;
	}
	else if(type == 2)
	{
		pInfo[playerid][player_can_train] = 1;
	}
}

timer RefreshActorAnim[1000](actorid)
{
	ClearDynamicActorAnimations(actorid);
}

timer AnimHitPlayer[15000](playerid)
{
	if(pInfo[playerid][player_bw] > 0) return 1;
    SetPVarInt(playerid, "AnimHitPlayerGun", 0);
    ClearAnimations(playerid);
    SetPlayerDrunkLevel(playerid, 2500);
    return 1;
}

timer HideActor[540000](actorid, vid)
{
	ActorProx(actorid, "Marcus Bradford", "odje¿d¿a z miejsca spotkania.", PROX_ME);
    SetDynamicActorPos(actorid, 2154.9539,-2697.7468,17.8828);
    DeleteVehicle(vid);
    
	foreach(new a: Areas)
	{
		if(Area[a][area_type] == AREA_TYPE_ARMDEALER)
		{
			DestroyDynamicArea(a);
			for(new z=0; e_areas:z != e_areas; z++)
		    {
				Area[a][e_areas:z] = 0;
		    }
		    new next;
		    Iter_SafeRemove(Areas, a, next);
		    a = next;
		}
	}
}

timer EndCall[3000](playerid)
{
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
}

timer KickPlayer[3000](playerid)
{
	Kick(playerid);
}

forward WelcomeTimer(playerid);
public WelcomeTimer(playerid)
{
    return KickAc(playerid, -1, "Przekroczony czas logowania");
}

timer HideInformationTextdraw[100](playerid, information_id)
{
	if( pInfo[playerid][player_info_td_id] == information_id )
	{
		TextDrawHideForPlayer(playerid, Tutorial[playerid]);
		pInfo[playerid][player_info_td_id] = 0;
	}
}

timer ApplyAnim[1000](playerid, type, weapon)
{
	switch( type )
	{
		case ANIM_TYPE_CARBW:
		{
			new vehid = GetPlayerVehicleID(playerid);
			new vmodelid = GetVehicleModel(vehid);
			new seat = GetPlayerVehicleSeat(playerid);

			switch(vmodelid)
			{
				case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471:
				{
					new Float:vx, Float:vy, Float:vz;
					GetVehicleVelocity(vehid, vx, vy, vz);
					if (vx*vx + vy*vy + vz*vz >= 0.4)
					{
						ApplyAnimation(playerid,"PED","BIKE_fallR", 4.1, 0, 0, 0, 1, 1, 1);
					}
					else
					{
						ApplyAnimation(playerid,"PED","BIKE_fall_off", 4.1, 0, 0, 0, 1, 1, 1);
					}
				}

				default:
				{
					if (seat & 1)
					{
						ApplyAnimation(playerid,"PED","CAR_dead_LHS", 4.1, 0, 1, 1, 1, 1, 1);
					}
					else
					{
						ApplyAnimation(playerid,"PED","CAR_dead_RHS", 4.1, 0, 1, 1, 1, 1, 1);
					}
				}
			}
		}
		case ANIM_TYPE_BW:
		{
			switch(weapon)
			{
				case 0: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 0, 0, 1, 0, 1);
				default: ApplyAnimation(playerid,"CRACK","crckdeth2", 4.1, 0, 1, 1, 1, 0);
			}	
		}
	}
}

timer HideGroupDutyPane[100](playerid)
{
	TextDrawHideForPlayer(playerid, DashBoardPane[playerid]);
	TextDrawHideForPlayer(playerid, DashBoardPane2[playerid]);
}

timer RestartServer[100]()
{
	SendRconCommand("exit");
}

timer VehicleEngineStart[1000](playerid, vehicleid)
{
	TextDrawHideForPlayer(playerid, vehicleInfo);
	
	Vehicle[vehicleid][vehicle_engine_starting] = false;
	Vehicle[vehicleid][vehicle_engine] = true;
	
	GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Silnik ~y~odpalony",3500,3);
	UpdateVehicleVisuals(vehicleid);
}

timer DeliverProduct[540000](gid, prod_id, count)
{
	new prod_name[40];
    format(prod_name, sizeof(prod_name), "%s", Product[prod_id][product_name]);

	Item_Create(ITEM_OWNER_TYPE_GROUP, Group[gid][group_uid], Product[prod_id][product_type], Product[prod_id][product_model], Product[prod_id][product_value1], Product[prod_id][product_value2], prod_name, Product[prod_id][product_extra], count);

	foreach(new pid : Player)
	{
		new slot = GetPlayerGroupSlot(pid, gid);
		if( slot != -1 )
		{
			if( WorkerHasFlag(pid, slot, WORKER_FLAG_ORDER) )
			{
				SendClientMessage(pid, COLOR_YELLOW, "> (SMS) [333] Hurtownia: Do magazynu grupy dostarczono zamówione produkty.");
			}
		}
	}

	return 1;
}

timer DestroyQuitText[15000](Text3D:textid)
{
	DestroyDynamic3DTextLabel(Text3D:textid);
}

timer PreloadAllAnimLibs[200](playerid)
{
	PreloadAnimLib(playerid,"BOMBER");
   	PreloadAnimLib(playerid,"RAPPING");
    PreloadAnimLib(playerid,"SHOP");
   	PreloadAnimLib(playerid,"BEACH");
   	PreloadAnimLib(playerid,"SMOKING");
	PreloadAnimLib(playerid,"RYDER");
	PreloadAnimLib(playerid,"PLAYIDLES");
	PreloadAnimLib(playerid,"POOL");
	PreloadAnimLib(playerid,"DANCING");
	PreloadAnimLib(playerid,"LOWRIDER");
	PreloadAnimLib(playerid,"INT_SHOP");
	PreloadAnimLib(playerid,"wuzi");
	PreloadAnimLib(playerid,"CRIB");
	PreloadAnimLib(playerid,"POLICE");
	PreloadAnimLib(playerid,"GRAVEYARD");
	PreloadAnimLib(playerid,"FIGHT_D");
    PreloadAnimLib(playerid,"ON_LOOKERS");
	PreloadAnimLib(playerid,"RIOT");
	PreloadAnimLib(playerid,"GANGS");
    PreloadAnimLib(playerid,"DEALER");
	PreloadAnimLib(playerid,"VENDING");
	PreloadAnimLib(playerid,"HEIST9");
	PreloadAnimLib(playerid,"CRACK");
	PreloadAnimLib(playerid,"SPRAYCAN");
	PreloadAnimLib(playerid,"JST_BUISNESS");
	PreloadAnimLib(playerid,"PAULNMAC");
	PreloadAnimLib(playerid,"GRENADE");
	PreloadAnimLib(playerid,"WAYFARER");
	PreloadAnimLib(playerid,"INT_OFFICE");
	PreloadAnimLib(playerid,"ROB_BANK");
	PreloadAnimLib(playerid,"STRIP");
	PreloadAnimLib(playerid,"GHANDS");
	PreloadAnimLib(playerid,"PARK");
	PreloadAnimLib(playerid,"CAR");
	PreloadAnimLib(playerid,"CARRY");
	PreloadAnimLib(playerid,"KISSING");
	PreloadAnimLib(playerid,"MISC");
	PreloadAnimLib(playerid,"OTB");
	PreloadAnimLib(playerid,"COP_AMBIENT");
	PreloadAnimLib(playerid,"MEDIC");
	PreloadAnimLib(playerid,"INT_HOUSE");
	PreloadAnimLib(playerid,"FOOD");
	PreloadAnimLib(playerid,"PED");
	PreloadAnimLib(playerid,"SWEET");
	PreloadAnimLib(playerid,"KNIFE");
	PreloadAnimLib(playerid,"CASINO");
	PreloadAnimLib(playerid,"AIRPORT");
	PreloadAnimLib(playerid,"Attractors");
	PreloadAnimLib(playerid,"BAR");
	PreloadAnimLib(playerid,"BASEBALL");
	PreloadAnimLib(playerid,"BD_FIRE");
	PreloadAnimLib(playerid,"benchpress");
	PreloadAnimLib(playerid,"BF_injection");
	PreloadAnimLib(playerid,"BLOWJOBZ");
	PreloadAnimLib(playerid,"BOX");
	PreloadAnimLib(playerid,"BSKTBALL");
	PreloadAnimLib(playerid,"BUDDY");
	PreloadAnimLib(playerid,"CAMERA");
	PreloadAnimLib(playerid,"DAM_JUMP");
	PreloadAnimLib(playerid,"FAT");
}