/*
	San Andreas Roleplay

	Data uko�czenia obecnej wersji: 07.07.2019

	Autor: Raydex
	Wszelkie prawa zastrze�one.
	Autor zastrzega sobie prawo do rozpowszechniania zawarto�ci oraz samego pliku.
*/

// Include
#include <a_samp>
#include <pawnbots>
#include <dini>
#include <a_mysql>
#include <bcrypt>
#include <streamer>
#include <ColAndreas>
#include <Pawn.RakNet>
#include <timestamptodate>
#include <sscanf2>
#include <kickfix>
#include <sprintf>
#include <YSI\y_iterate>
#include <YSI\y_timers>
#include <zones>
#include <progress>
#include <zcmd>
#include <FCNPC>
#include <sv-weap>
#include <i_quat>
#include <geoip>
#include <timerfix>

#pragma tabsize 0
#pragma dynamic 8196

// Moduly
#include "rp/color_management.inc"
#include "rp/config.inc"
#include <weapon-config>
#include "rp/code_timer.inc"
#include "rp/misc.inc"
#include "rp/dynamicgui.inc"
#include "rp/penalties.inc"
#include "rp/functions.inc"
#include "rp/areas.inc"
#include "rp/groups.inc"
#include "rp/vehicles.inc"
#include "rp/offers.inc"
#include "rp/items.inc"
#include "rp/labels.inc"
#include "rp/player.inc"
#include "rp/textdraws.inc"
#include "rp/gym.inc"
#include "rp/objects.inc"
#include "rp/acmd.inc"
#include "rp/cmd.inc"
#include "rp/materials.inc"
#include "rp/timers.inc"
#include "rp/doors.inc"
#include "rp/fires.inc"
#include "rp/actors.inc"
#include "rp/products.inc"
#include "rp/works.inc"
#include "rp/special_places.inc"
#include "rp/gangwars.inc"
#include "rp/robberies.inc"
#include "rp/threaded_queries.inc"
#include "rp/casino.inc"
#include "rp/npcs.inc"

main() {}

public OnGameModeInit()
{
	AddAll_VC2SA_Models();
	//SendRconCommand("password nologinallowed");
	AddPlayerClass(299,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
    Code_ExTimer_Begin(GameModeInit);

    CA_Init();

    SetVehiclePassengerDamage(true);
    //SetDisableSyncBugs(true);
    SetCustomVendingMachines(false);
    SetDamageFeed(false);
    SetDamageSounds(0, 0);
    SetServerWeaponsDamage();
    ReplacePaynSprayGates();
    SetCustomArmourRules(false, false);

    ShowPlayerMarkers(0);
    ShowNameTags(0);
    DisableInteriorEnterExits();
    EnableStuntBonusForAll(0);
    ManualVehicleEngineAndLights();
    
    Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, MAX_VISIBLE_OBJECTS); 

    Iter_Init(PlayerItems);
    Iter_Init(PlayerSpawns); 
    Iter_Init(PlayerZones); 

    CreateTextdraws();

    LoadConfiguration();
    if( !ConnectMysql() ) return 1;

    LoadGlobalSpawns();
    LoadRemoveObjects();
    LoadGroups();
    LoadAreas();
    LoadDoors();
    LoadLabels();
    LoadObjects();
    LoadVehicles();
    LoadItems();
    LoadAnims();
    LoadActors();
    LoadProducts();
    LoadMaterials();
    LoadSpecialPlaces();
    LoadSkins();
    LoadAccess();
    LoadGangWars();
    LoadRobberies();
    LoadRouletteSettings();
    LoadTrashFactories();
    DestroyDeletedGroups();
    DestroyGroupsWithUnpaidTax();

    mysql_query(mySQLconnection, "DELETE FROM `ipb_logged_players`");
    mysql_query(mySQLconnection, "UPDATE `ipb_characters` SET char_online = 0");

    MoveDynamicObject(space_ship, 508.8699,-916.9603,210.8788, 8.0, 0.0, 0.0, -106.5);

    printf("SARP uruchomiony [czas: %d ms]", Code_ExTimer_End(GameModeInit));
    //defer OpenServerForPlayers[60000]();
    return 1;
}

public OnGameModeExit()
{	
	foreach(new v : Vehicles)
	{
		SaveVehicle(v);
	}
	
	mysql_close(mySQLconnection);
	return 1;
}

public OnIncomingConnection(playerid, ip_address[], port)
{
	SetPlayerColor(playerid, 0x00000000);
	/*if(IsPlayerNPC(playerid)) return 1;
	if( strfind(ip_address, "127.0.0", true) != -1) return 1;
	format(pInfo[playerid][player_ip], 20, "%s", ip_address);

	new count;
	foreach(new p: Player)
	{
		if( !strcmp(pInfo[p][player_ip], ip_address) ) count++;
	}

	if(count > 3)
	{
		printf("[SARP CONNECTIONS] Blocking IP %s for 1 minute. (Too many connections from this IP).", ip_address);
		BlockIpAddress(ip_address, 60*1000);
		return 0;
	}
    */
	return 1;
}

public OnPlayerConnect(playerid)
{
	if( IsPlayerNPC(playerid) )
	{
		NPC[playerid][npc_aimed] = -1;
		return 1;
	}

	SetPlayerVirtualWorld(playerid, playerid+900);
	SetPlayerColor(playerid, 0x00000000);

	ResetPlayerWeapons(playerid);
	ResetPlayerWeapons(playerid);

	CleanGlobalData(playerid);
	CleanPlayerData(playerid);

	CreatePlayerTextdraws(playerid);

	TextDrawShowForPlayer(playerid, Textdraw2);

	TogglePlayerSpectating(playerid, 1);

	GetPlayerName(playerid, pInfo[playerid][player_name], 60);
	pInfo[playerid][player_name][0] = chrtoupper(pInfo[playerid][player_name][0]);
	strreplace(pInfo[playerid][player_name], '_', ' ');

	/*new name_escaped[MAX_PLAYER_NAME+1];
	strcopy(name_escaped, pInfo[playerid][player_name], MAX_PLAYER_NAME+1);
	strreplace(name_escaped, ' ', '_');*/

	new serial[128];
	gpci(playerid, serial, sizeof(serial));

	format(pInfo[playerid][player_serial], sizeof(serial), "%s", serial);

	RemoveBuildingsForPlayer(playerid);
	ResetTrashmasterIcons(playerid);
   
    for(new i = 1; i < 40; i++)
    {
        SendClientMessage(playerid, -1, " ");
    }

    return 1;
}

public OnIncomingPacket(playerid, packetid, BitStream:bs)
{
    new onFootData[PR_OnFootSync];

    BS_IgnoreBits(bs, 8);
    BS_ReadOnFootSync(bs, onFootData);

    if(IsPlayerConnected(playerid))
    {
    	if(pInfo[playerid][player_logged] && pInfo[playerid][player_hours] < 1 && pGlobal[playerid][glo_score] < 500)
    	{
    		if(onFootData[PR_velocity][0] != 0 && onFootData[PR_velocity][1] != 0)
    		{
    			if(onFootData[PR_velocity][0] == floatabs(pInfo[playerid][player_velocity][0] ) && onFootData[PR_velocity][1] == floatabs(pInfo[playerid][player_velocity][1]) && onFootData[PR_velocity][0] != pInfo[playerid][player_velocity][0])
    			{
					if(GetPlayerCameraTargetPlayer(playerid) != INVALID_PLAYER_ID)
					{
						BanAc(playerid, -1, 90, "Johny project");
					}
    			}

	    		pInfo[playerid][player_velocity][0] = onFootData[PR_velocity][0];
    			pInfo[playerid][player_velocity][1] = onFootData[PR_velocity][1];
    			pInfo[playerid][player_velocity][2] = onFootData[PR_velocity][2];
    		}

    		//printf("Velocity %s: %f, %f, %f", pInfo[playerid][player_name], pInfo[playerid][player_velocity][0], pInfo[playerid][player_velocity][1], pInfo[playerid][player_velocity][2]);
    	}
    }
	return 1;
}

public OnOutcomingRPC(playerid, rpcid, BitStream:bs)
{
	//if(debug_mode) printf("Outcoming RPC for player %s: %d", pInfo[playerid][player_name], rpcid);
	return 1;
}

public OnIncomingRPC(playerid, rpcid, BitStream:bs)
{
	//if(debug_mode) printf("Incoming RPC for player %s: %d", pInfo[playerid][player_name], rpcid);
	if(rpcid == 155)
	{
		if(pInfo[playerid][player_sobfox_time] != 0 && !IsPlayerPBot(playerid))
		{
			if(pInfo[playerid][player_sobfox_warns] > 1 && pInfo[playerid][player_hours] < 1)
			{
				if(pInfo[playerid][player_last_tab] < gettime()-10 ) KickAc(playerid, -1, "s0beit"); 
				return 1;
			} 
			if(gettime()-5 == pInfo[playerid][player_sobfox_time]) pInfo[playerid][player_sobfox_warns] ++; 
			if(gettime()-6 == pInfo[playerid][player_sobfox_time]) pInfo[playerid][player_sobfox_warns] ++; 
		}
		pInfo[playerid][player_sobfox_time] = gettime();
 	}
	return 1;
}

public OnPlayerFinishedDownloading(playerid, virtualworld)
{
	if(!pInfo[playerid][player_logged])
	{
		new random_camera = random(6);
		switch(random_camera)
		{
			case 0: //Ocean Docks
			{
				TextDrawSetString(Tutorial[playerid], "Ciekawostka~n~~n~Kontrolujac strefy w rejonie ~y~Ocean Docks~w~ zyskujesz dostep do specjalnych przywileji takich jak ~p~przemyt kontenerowcami~w~.~n~~n~Znajdziesz tutaj takze az ~y~dwie~w~ prace dorywcze.");
				InterpolateCameraPos(playerid, 2396.604248, -2321.955566, 60.792907, 2547.703613, -2271.560546, 26.370052, 10000);
				InterpolateCameraLookAt(playerid, 2400.980957, -2324.287353, 60.154834, 2552.284912, -2269.588378, 26.019557, 8000);
			}
			case 1: //Aleja gwiazd
			{
				TextDrawSetString(Tutorial[playerid], "Ciekawostka~n~~n~Kontrolujac strefy handlowe takie jak ~y~Aleja Gwiazd~w~ zyskujesz dostep do specjalnych bonusow z tytulu prowadzenia tam biznesu.");
				InterpolateCameraPos(playerid, 1262.023803, -1159.407836, 45.056510, 1151.232421, -1162.264648, 51.271228, 10000);
				InterpolateCameraLookAt(playerid, 1258.338134, -1156.042236, 44.758514, 1147.483886, -1158.984741, 50.834293, 8000);
			}
			case 2: //Farm
			{
				TextDrawSetString(Tutorial[playerid], "Ciekawostka~n~~n~Kontrolujac strefy farm takie jak ~y~Flint Range~w~ zyskujesz dostep do sadzenia roslin na ich terenie.");
				InterpolateCameraPos(playerid, -332.208618, -1255.102172, 64.629562, -342.446594, -1481.180786, 36.048023, 10000);
				InterpolateCameraLookAt(playerid, -335.767364, -1258.422363, 63.484169, -344.963043, -1476.861694, 36.164127, 8000);
			}
			case 3: //State prison
			{
				TextDrawSetString(Tutorial[playerid], "Ciekawostka~n~~n~W rejonach ~y~Blueberry~w~ znajduje sie San Andreas State Prison. Uwazaj by tam nie trafic!");
				InterpolateCameraPos(playerid, 90.8786,-492.7114,40.7959, -6.9435,-390.9464,40.7959, 10000);
				InterpolateCameraLookAt(playerid, -31.2681,-394.6642,37.8951, -35.9695,-340.6124,37.8951, 8000);
			}
			case 4: //The Panopticon
			{
				TextDrawSetString(Tutorial[playerid], "Ciekawostka skryptowa~n~~n~W rejonach ~y~The Panopticon~w~ znajduja sie tartaki, w ktorych podjac mozesz prace dorywcza.");
				InterpolateCameraPos(playerid, -347.775939, 44.285602, 90.114624, -598.752990, -148.294067, 87.018424, 10000);
				InterpolateCameraLookAt(playerid, -351.470855, 40.917465, 90.057319, -594.500671, -150.905029, 86.701194, 8000);
			}
			case 5: //South Central
			{
				TextDrawSetString(Tutorial[playerid], "Ciekawostka~n~~n~Kontrolujac strefy w South Central takie jak ~y~Idlewood~w~ twoja organizacja otrzymuje procent od kazdego sprzedanego narkotyku.");
				InterpolateCameraPos(playerid, 2053.236083, -1877.590209, 35.590507, 2189.810546, -1763.355590, 19.287530, 10000);
				InterpolateCameraLookAt(playerid, 2056.047607, -1873.456298, 35.513935, 2186.731445, -1759.428100, 18.979919, 8000);
			}
		}

		TextDrawShowForPlayer(playerid, Tutorial[playerid]);

		new name_escaped[MAX_PLAYER_NAME+1];
		strcopy(name_escaped, pInfo[playerid][player_name], MAX_PLAYER_NAME+1);
		strreplace(name_escaped, ' ', '_');

		mysql_tquery(mySQLconnection, sprintf("SELECT ch.char_uid, ch.char_gid, m.name, m.member_id, m.members_pass_hash, m.member_game_points, m.member_game_admin_perm, m.member_premium_time FROM ipb_characters ch INNER JOIN core_members m ON ch.char_gid = m.member_id WHERE ch.char_name = '%s'", name_escaped), "OnPlayerGlobalCheck", "d", playerid);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if( IsPlayerNPC(playerid) ) return 1;
	mysql_query(mySQLconnection, sprintf("DELETE FROM `ipb_logged_players` WHERE `char_uid` = %d", pInfo[playerid][player_id]));
	Update3DTextLabelText(pInfo[playerid][player_description_label], LABEL_DESCRIPTION, "");
	KillTimer(connect_timer[playerid]);
	if( !pInfo[playerid][player_logged] ) return 1;

	format(pInfo[playerid][player_ip], 20, "");
	SavePlayer(playerid);

	HidePlayerZones(playerid);

	DestroyPlayerTextDraws(playerid);

	if(IsValidVehicle(pInfo[playerid][player_vehicle_target]))
	{
		if(IsValidDynamicMapIcon(Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_map_icon]))
		{
			Streamer_RemoveArrayData(STREAMER_TYPE_MAP_ICON, Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_map_icon], E_STREAMER_PLAYER_ID, playerid);			
			Streamer_UpdateEx(playerid, Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][0], Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][1], Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][2]);
		}
	}

	if(reason == 0)
	{
		new
		Float:x,
		Float:y,
		Float:z,
		Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
	
		mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_online`='0', `char_posx`='%f', `char_posy`='%f', `char_posz`='%f', `char_posa`='%f', `char_world`=%d, `char_interior`=%d, `char_quittime`=%d WHERE `char_uid`=%d", x, y, z, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), gettime(), pInfo[playerid][player_id]));

		new vdd = GetPlayerVehicleID(playerid);
		if(vdd != INVALID_VEHICLE_ID)
		{
			if(!IsVehicleBike(vdd))
			{
				if(GetPlayerVehicleSeat(playerid) == 0)
				{
					Vehicle[vdd][vehicle_engine] = false;
					UpdateVehicleVisuals(vdd);
				}
			}
		}
	}

	EnablePlayerCameraTarget(playerid, 0);

	mysql_query(mySQLconnection, sprintf("UPDATE `ipb_game_sessions` SET `session_end` = %d, `session_owner` = %d WHERE `session_uid` = %d", gettime(), pInfo[playerid][player_id], pInfo[playerid][player_session]));
	
	if(reason == 1 || reason == 2)
	{
		mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_online`='0' WHERE `char_uid`= %d", pInfo[playerid][player_id]));
	}

	if( IsValidDynamicObject(pInfo[playerid][player_edited_object]) )
	{
		OnPlayerEditDynamicObject(playerid, pInfo[playerid][player_edited_object], EDIT_RESPONSE_CANCEL, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	}

	if( pInfo[playerid][player_creating_area] )
	{
		if( IsValidDynamic3DTextLabel(pInfo[playerid][player_carea_label][0]) ) DestroyDynamic3DTextLabel(pInfo[playerid][player_carea_label][0]);
		if( IsValidDynamic3DTextLabel(pInfo[playerid][player_carea_label][1]) ) DestroyDynamic3DTextLabel(pInfo[playerid][player_carea_label][1]);
		
		PlayerGangZoneDestroy(playerid, pInfo[playerid][player_carea_zone]);
	}

	if( IsValidDynamicObject(pInfo[playerid][player_bus_object]))
	{
		DestroyDynamicObject(pInfo[playerid][player_bus_object]);
		pInfo[playerid][player_bus_object] = INVALID_STREAMER_ID;
	}

	if( IsValidDynamicObject(pInfo[playerid][player_roulette_selector]))
	{
		DestroyDynamicObject(pInfo[playerid][player_roulette_selector]);
		pInfo[playerid][player_roulette_selector] = INVALID_STREAMER_ID;
	}

	if(IsValidDynamicObject(pInfo[playerid][player_jbl_object]))
	{
		DestroyDynamicObject(pInfo[playerid][player_jbl_object]);
		pInfo[playerid][player_jbl_object] = INVALID_STREAMER_ID;
	}

	if(IsValidDynamicArea(pInfo[playerid][player_jbl_circle]))
	{
		format(Area[pInfo[playerid][player_jbl_circle]][area_audio], 100, "-");
		DestroyDynamicArea(pInfo[playerid][player_jbl_circle]);
	}

	if(pInfo[playerid][player_taxi_veh] != INVALID_VEHICLE_ID)
 	{
  		new driverid = GetVehicleDriver(pInfo[playerid][player_taxi_veh]), price = pInfo[playerid][player_taxi_pay];

		if(price > 0)
  		{
			price = price > pInfo[playerid][player_money] ? pInfo[playerid][player_money] : price;

			GivePlayerMoney(playerid, -price);

			new gid = pInfo[playerid][player_duty_gid];
			if(gid != -1)
			{
				if(price >= 20)
				{
					GiveGroupMoney(gid, price-10);
					GivePlayerMoney(driverid, 10);
				}
				else
				{
					GiveGroupMoney(gid, price);
				}
			}
		}
		pInfo[driverid][player_taxi_passenger] = INVALID_PLAYER_ID;
	}

	if( pOffer[playerid][offer_type] > 0 )
	{
		if( pOffer[playerid][offer_sellerid] == INVALID_PLAYER_ID )
		{
			new buyerid = pOffer[playerid][offer_buyerid];
			if(buyerid != INVALID_PLAYER_ID)
			{
				for(new x=0; e_player_offer:x != e_player_offer; x++)
				{
					pOffer[buyerid][e_player_offer:x] = 0;
				}
				SendGuiInformation(buyerid, ""guiopis"Powiadomienie", "Gracz, kt�ry sk�ada� Ci oferte opu�ci� serwer.");
			}
		}
		else OnPlayerOfferResponse(playerid, 0);
	}

	if( pInfo[playerid][player_phone_call_started] )
	{
		if( pInfo[playerid][player_phone_caller] == INVALID_PLAYER_ID )
		{
			new targetid = -1;
			if( pInfo[playerid][player_phone_caller] == INVALID_PLAYER_ID ) targetid = pInfo[playerid][player_phone_receiver];
			else targetid = pInfo[playerid][player_phone_caller];
			
			SendClientMessage(targetid, COLOR_YELLOW, "Rozmowa przerwana.");
			pInfo[targetid][player_phone_call_started] = false;
			pInfo[targetid][player_phone_receiver] = INVALID_PLAYER_ID;
			pInfo[targetid][player_phone_caller] = INVALID_PLAYER_ID;
			
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			SetPlayerSpecialAction(targetid, SPECIAL_ACTION_STOPUSECELLPHONE);
			if( pInfo[playerid][player_phone_object_index] > -1 ) RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
			if( pInfo[targetid][player_phone_object_index] > -1 ) RemovePlayerAttachedObject(targetid, pInfo[targetid][player_phone_object_index]);
		}
	}
	else
	{
		if( pInfo[playerid][player_phone_caller] == INVALID_PLAYER_ID && pInfo[playerid][player_phone_receiver] != INVALID_PLAYER_ID )
		{
			new targetid = -1;
			if( pInfo[playerid][player_phone_caller] == INVALID_PLAYER_ID ) targetid = pInfo[playerid][player_phone_receiver];
			else targetid = pInfo[playerid][player_phone_caller];
			
			SendClientMessage(targetid, COLOR_YELLOW, "Rozmowa przerwana.");
			pInfo[targetid][player_phone_call_started] = false;
			pInfo[targetid][player_phone_receiver] = INVALID_PLAYER_ID;
			pInfo[targetid][player_phone_caller] = INVALID_PLAYER_ID;
			
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			SetPlayerSpecialAction(targetid, SPECIAL_ACTION_STOPUSECELLPHONE);
			if( pInfo[playerid][player_phone_object_index] > -1 ) RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
			if( pInfo[targetid][player_phone_object_index] > -1 ) RemovePlayerAttachedObject(targetid, pInfo[targetid][player_phone_object_index]);
		}
	}

	if( pInfo[playerid][player_lookup_area] )
	{
		cmd_astrefa(playerid, "podglad");
	}
	
	if( pInfo[playerid][player_admin_duty] )
	{
		cmd_duty(playerid, "");
	}

	for (new i = 0; i < MAX_PLAYER_GZ; ++i) PlayerGangZoneData[playerid][i][player_GZ_Used] = false;

	new slot = GetPlayerDutySlot(playerid);
	if( slot > -1 )
	{
		cmd_g(playerid, sprintf("%d duty", slot+1));
	}

	for(new i;i<13;i++)
	{
		if( pWeapon[playerid][i][pw_itemid] > -1 ) Item_Use(pWeapon[playerid][i][pw_itemid], playerid);
	}

	for(new item;item<MAX_PLAYER_ITEMS;item++)
	{
		if( PlayerItem[playerid][item][player_item_uid] < 1 ) continue;
		
		DeleteItem(item, false, playerid);
	}

	new Text3D:EndLabel, str[64], left_reason[32];
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	switch(reason)
	{
		case 0:
		{
			format(left_reason, sizeof(left_reason), "timeout");
		}
		case 1:
		{
			format(left_reason, sizeof(left_reason), "/q");
		}
		case 2:
		{
			format(left_reason, sizeof(left_reason), "/qs");
		}
	}

	format(str, sizeof(str), "(( %s - %s ))", pInfo[playerid][player_name], left_reason);
	EndLabel = CreateDynamic3DTextLabel(str, COLOR_GREY, x, y, z, 25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);
	defer DestroyQuitText[15000](EndLabel);

	return 1;
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
	switch(errorid)
	{
		case CR_SERVER_GONE_ERROR:
		{
			printf("[MySQL error] MySQL server gone.");
		}
		case ER_SYNTAX_ERROR:
		{
			printf("[MySQL error]: Syntax error: %s", query);
		}
		case CR_SERVER_LOST:
		{
			printf("[MySQL error] MySQL server lost.");
		}
	}
	return 1;
}

public OnVehicleSirenStateChange(playerid, vehicleid, newstate)
{
	if(newstate)
	{
		Vehicle[vehicleid][vehicle_elm] = 1;
	}
	else
	{
		new panels, doors, lights, tires;
        GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
        UpdateVehicleDamageStatus(vehicleid, panels, doors, 0, tires);
		Vehicle[vehicleid][vehicle_elm] = 0;
	}
	return 1;
}

stock OnPlayerWeaponChange(playerid, newweapon, oldweapon)
{
	if( oldweapon > -1 )
	{
		new slot = GetWeaponSlot(oldweapon), wid, wammo;
		GetPlayerWeaponData(playerid, slot, wid, wammo);

		if( pWeapon[playerid][slot][pw_itemid] > -1 && wid > 0 && wammo == 0 )
		{
			new itemid = pWeapon[playerid][slot][pw_itemid];
			if( PlayerItem[playerid][itemid][player_item_used] )
			{
				pWeapon[playerid][slot][pw_ammo] = 0;
				Item_Use(pWeapon[playerid][slot][pw_itemid], playerid);
			}
		}
	}
	
	new wslot;
	if( newweapon > 1 )
	{
		wslot = GetWeaponSlot(newweapon);
		if( pWeapon[playerid][wslot][pw_object_index] > -1 )
		{
			RemovePlayerAttachedObject(playerid, pWeapon[playerid][wslot][pw_object_index]);
			pWeapon[playerid][wslot][pw_object_index] = -1;
		}
	}
	
	if( oldweapon > -1 )
	{
		wslot = GetWeaponSlot(oldweapon);
		if( pWeapon[playerid][wslot][pw_id] != oldweapon ) return 1;
		if( pWeapon[playerid][wslot][pw_id] != oldweapon ) return 1;
		if( WeaponVisualModel[oldweapon] > -1 )
		{
			new itemid = pWeapon[playerid][wslot][pw_itemid], ow = oldweapon;

			new ao_id = GetPlayerAoSlot(playerid, WeaponVisualModel[oldweapon]);
			if( ao_id == -1 )
			{
				new freeid = GetPlayerFreeWeaponAttachSlot(playerid);
				if(freeid == -1) return 1;

				if( Item[itemid][item_group] > 0 ) SetPlayerAttachedObject(playerid, freeid, WeaponVisualModel[ow], WeaponVisualBone[ow], FWeaponVisualPos[ow][0], FWeaponVisualPos[ow][1], FWeaponVisualPos[ow][2], FWeaponVisualPos[ow][3], FWeaponVisualPos[ow][4], FWeaponVisualPos[ow][5], FWeaponVisualPos[ow][6], FWeaponVisualPos[ow][7], FWeaponVisualPos[ow][8]);
				else SetPlayerAttachedObject(playerid, freeid, WeaponVisualModel[ow], WeaponVisualBone[ow], WeaponVisualPos[ow][0], WeaponVisualPos[ow][1], WeaponVisualPos[ow][2], WeaponVisualPos[ow][3], WeaponVisualPos[ow][4], WeaponVisualPos[ow][5], WeaponVisualPos[ow][6], WeaponVisualPos[ow][7], WeaponVisualPos[ow][8]);
				pWeapon[playerid][wslot][pw_object_index] = freeid;
				return 1;
			}
			else
			{
				SetPlayerAttachedObject(playerid, ao_id, WeaponVisualModel[ow], WeaponVisualBone[ow], ao[playerid][ao_id][ao_x], ao[playerid][ao_id][ao_y], ao[playerid][ao_id][ao_z], ao[playerid][ao_id][ao_rx], ao[playerid][ao_id][ao_ry], ao[playerid][ao_id][ao_rz]);
				pWeapon[playerid][wslot][pw_object_index] = ao_id;
			}
		}
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if( IsPlayerNPC(playerid) ) return 1;

	/*if(gettime() > pInfo[playerid][player_update_tick]) 
   	{ 
		static current_weapon, current_ammo; 
		    
		pInfo[playerid][player_update_tick] = gettime() + 2; 

		GetPlayerWeaponData(playerid, 0, current_weapon, current_ammo); 

		pInfo[playerid][player_synced] = (current_ammo != pInfo[playerid][player_ammo]); 

		SetPlayerAmmo(playerid, current_weapon, !current_ammo); 

		pInfo[playerid][player_ammo] = !current_ammo; 
   	}*/

	if(GetPlayerCameraMode(playerid) == 53)  
    {  
        new Float:kLibPos[3];  
        GetPlayerCameraPos(playerid, kLibPos[0], kLibPos[1], kLibPos[2]); 
        if ( kLibPos[2] < -50000.0 || kLibPos[2] > 50000.0 )  
        {  
            KickAc(playerid, -1, "Invalid aim data");  
            return 0;  
        }  
    }

    if(GetPlayerCameraMode(playerid) == 55)
    {
    	if(GetPlayerWeapon(playerid) == 24) SetPlayerArmedWeapon(playerid, 0);
    }

    if(pInfo[playerid][player_editor] == OBJECT_EDITOR_CUSTOM && IsValidDynamicObject(pInfo[playerid][player_edited_object]) && pInfo[playerid][player_custom_edit])
    {
    	RotateCustomObject(playerid);
    }

	if(IsValidDynamicObject(pInfo[playerid][player_roulette_selector]))
	{
		if(IsValidDynamicObject(pInfo[playerid][player_roulette_object]))
		{
			new Float:x, Float:y, Float:z;
			GetDynamicObjectPos(pInfo[playerid][player_roulette_object], x, y, z);

			new current_field = pInfo[playerid][player_roulette_field];
			new keysa, uda, lra;
			GetPlayerKeys(playerid, keysa, uda, lra);

		    if(lra == KEY_LEFT)
		    {
		    	if(pInfo[playerid][player_roulette_timer] > 0) return SendGuiInformation(playerid, "Informacja", "Nie mo�esz obstawia� w trakcie losowania.");
		    	new field_idd = Iter_Prev(RouletteFields, current_field);

		    	if(field_idd < 50)
		    	{
			    	SetDynamicObjectPos(pInfo[playerid][player_roulette_selector], x+RouletteField[field_idd][field_x], y+RouletteField[field_idd][field_y], z-0.162);
			    	Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

			    	TextDrawSetString(Tutorial[playerid], sprintf("Aktualny wybor: ~y~%s (stawka x%d)~n~~w~Uzywaj klawiszy ~<~~>~, aby poruszac~n~zoltym selektorem.~n~~n~Nacisnij ~g~SHIFT~w~, aby obstawic.~n~~b~~r~SPACJA~w~, aby wyjsc z gry.", RouletteField[field_idd][field_name], RouletteField[field_idd][field_multiplier]));
					TextDrawShowForPlayer(playerid, Tutorial[playerid]);
					pInfo[playerid][player_roulette_field] = field_idd;
				}
		    }
		    else if(lra == KEY_RIGHT)
		    {
		    	if(pInfo[playerid][player_roulette_timer] > 0) return SendGuiInformation(playerid, "Informacja", "Nie mo�esz obstawia� w trakcie losowania.");
		    	new field_idd = Iter_Next(RouletteFields, current_field);

		    	if(field_idd < 50)
		    	{
			    	SetDynamicObjectPos(pInfo[playerid][player_roulette_selector], x+RouletteField[field_idd][field_x], y+RouletteField[field_idd][field_y], z-0.162);
			    	Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

			    	TextDrawSetString(Tutorial[playerid], sprintf("Aktualny wybor: ~y~%s (stawka x%d)~n~~w~Uzywaj klawiszy ~<~~>~, aby poruszac~n~zoltym selektorem.~n~~n~Nacisnij ~g~SHIFT~w~, aby obstawic.~n~~b~~r~SPACJA~w~, aby wyjsc z gry.", RouletteField[field_idd][field_name], RouletteField[field_idd][field_multiplier]));
					TextDrawShowForPlayer(playerid, Tutorial[playerid]);
					pInfo[playerid][player_roulette_field] = field_idd;
				}
		    }
		}
	}
    
    if(pInfo[playerid][player_bus_stop])
    {
    	new keysa, uda, lra, Float:x, Float:y, Float:z;

		GetPlayerKeys(playerid, keysa, uda, lra);
		GetDynamicObjectPos(pInfo[playerid][player_bus_object], x, y, z);

		if(uda == KEY_UP)
		{
			MoveDynamicObject(pInfo[playerid][player_bus_object], x, y+70, z, 100.0);

			AttachCameraToDynamicObject(playerid, pInfo[playerid][player_bus_object]);
		}
	    else if(uda == KEY_DOWN)
	    {
	    	MoveDynamicObject(pInfo[playerid][player_bus_object], x, y-70, z, 100.0);

	    	AttachCameraToDynamicObject(playerid, pInfo[playerid][player_bus_object]);
	    }

	    if(lra == KEY_LEFT)
	    {
	    	MoveDynamicObject(pInfo[playerid][player_bus_object], x-70, y, z, 100.0);

	    	AttachCameraToDynamicObject(playerid, pInfo[playerid][player_bus_object]);
	    }
	    else if(lra == KEY_RIGHT)
	    {
	    	MoveDynamicObject(pInfo[playerid][player_bus_object], x+70, y, z, 100.0);

	    	AttachCameraToDynamicObject(playerid, pInfo[playerid][player_bus_object]);
	    }

	    pInfo[playerid][player_last_bus] = GetTickCount();
    }   

    if(pGlobal[playerid][glo_block] & BLOCK_RUN)
    {
    	if(GetPlayerSpeed(playerid) > 1)
    	{
    		new keysa, uda, lra;
			GetPlayerKeys(playerid, keysa, uda, lra);
			if(!(keysa & KEY_WALK))
			{
	    		new skin = GetClientSkin(playerid);
	    		SetPlayerSkin(playerid, skin);
	    		TogglePlayerControllable(playerid, 0);
	    		TogglePlayerControllable(playerid, 1);
	    	}
    	}
    }

	if(pInfo[playerid][player_skin_changing] == true)
    {
		new Keys, ud, lr;
  		GetPlayerKeys(playerid, Keys, ud, lr);
        if(lr < 0 || lr > 0)
        {
            new action = lr < 0 ? 1 : -1,
				uid = pInfo[playerid][player_skin_id],
				str[ 20 ];

            uid = uid + action < 0 ? MAX_SKINS - 1: (uid + action >= MAX_SKINS ? 0: uid + action);

            if(ClothSkin[uid][skin_model] != 0)
            {
	            pInfo[playerid][player_skin_id] = uid;
	            SetPlayerSkin(playerid, ClothSkin[uid][skin_model]);

			    if(ClothSkin[uid][skin_price] <= pInfo[playerid][player_money])
					format(str, sizeof str, "~g~$%d", ClothSkin[uid][skin_price]);
				else
					format(str, sizeof str, "~r~$%d", ClothSkin[uid][skin_price]);
	            GameTextForPlayer(playerid, str, 2000, 6);
	        }
	        else
	        {
	        	return 1;
	        }
		}
	}

	if(pInfo[playerid][player_access_changing] == true)
    {
		new Keys, ud, lr;
  		GetPlayerKeys(playerid, Keys, ud, lr);
        if(lr < 0 || lr > 0)
        {
            new action = lr < 0 ? 1 : -1,
				uid = pInfo[playerid][player_access_id],
				str[ 20 ];

            uid = uid + action < 0 ? MAX_ACCESS - 1: (uid + action >= MAX_ACCESS ? 0: uid + action);

            if(ClothAccess[uid][access_model] != 0)
            {
	            pInfo[playerid][player_access_id] = uid;
	            RemovePlayerAttachedObject(playerid, ATTACH_SLOT_VICTIM);
	            SetPlayerAttachedObject(playerid, ATTACH_SLOT_VICTIM, ClothAccess[uid][access_model], ClothAccess[uid][access_bone], ClothAccess[uid][access_pos][0], ClothAccess[uid][access_pos][1], ClothAccess[uid][access_pos][2], ClothAccess[uid][access_pos][3], ClothAccess[uid][access_pos][4],ClothAccess[uid][access_pos][5]);

			    if(ClothAccess[uid][access_price] <= pInfo[playerid][player_money])
					format(str, sizeof str, "~g~$%d", ClothAccess[uid][access_price]);
				else
					format(str, sizeof str, "~r~$%d", ClothAccess[uid][access_price]);
	            GameTextForPlayer(playerid, str, 2000, 6);
	        }
	        else
	        {
	        	return 1;
	        }
		}
	}

	if(pInfo[playerid][player_training] == true)
	{
		new Keys,ud,lr;
    	GetPlayerKeys(playerid,Keys,ud,lr);

    	if(ud == KEY_UP)
    	{
    		if(pInfo[playerid][player_can_train] == 1 && pInfo[playerid][player_strength] < 100.0)
    		{
    			UseGymDumb(playerid);
    		}
    	}
    	else if(ud == KEY_DOWN)
    	{
    		if(pInfo[playerid][player_can_train] == 2)
    		{
				LeaveDumb(playerid);
    		}
    	}
	}

	// Gaszenie pozaru
	if(GetPlayerWeapon(playerid) == 42)
	{
		new newkeys,l,u;
		GetPlayerKeys(playerid, newkeys, l, u);
		if(HOLDING(KEY_FIRE))
		{
			new Float:pos[3];
			foreach(new fsid : FireSources)	
			{
				GetDynamicObjectPos(FireSource[fsid][fs_object], pos[0], pos[1], pos[2]);
				if(!IsPlayerInRangeOfPoint(playerid, 4, pos[0], pos[1], pos[2])) continue;
				
				if(PlayerFaces(playerid, pos[0], pos[1], pos[2], 3.0))
				{
					if(FireSource[fsid][fs_health]>0)
					{
						new str[10];
						FireSource[fsid][fs_health] -= 0.1;
						format(str, sizeof(str), "%.2f%%", FireSource[fsid][fs_health]);
						UpdateDynamic3DTextLabelText(FireSource[fsid][fs_label], 0xF07800FF, str);
					}
					else
					{
						StopFireSource(fsid);
					}
				}
			}
		}
	}

	// Malowanie furki
	if(GetPlayerWeapon(playerid) == 41)
	{
		new newkeys,l,u;
		GetPlayerKeys(playerid, newkeys, l, u);
		if(HOLDING(KEY_FIRE))
		{
			pInfo[playerid][player_can_spray] = true;
		}
	}

	if( pInfo[playerid][player_logged] )
	{
		new wid = GetPlayerWeapon(playerid);
		if( pInfo[playerid][player_held_weapon] != wid )
		{
			OnPlayerWeaponChange(playerid, wid, pInfo[playerid][player_held_weapon]);
			pInfo[playerid][player_held_weapon] = wid;
		}
	
		if( pInfo[playerid][player_afk] )
		{
			RemovePlayerStatus(playerid, PLAYER_STATUS_AFK);
			
			pInfo[playerid][player_afk_time] += gettime() - pInfo[playerid][player_last_activity];
			
			if( GetPlayerDutySlot(playerid) > -1 ) pInfo[playerid][player_onduty_afk] += gettime() - pInfo[playerid][player_last_activity]; 
			if( pInfo[playerid][player_admin_duty] ) pInfo[playerid][player_admin_duty_afk_time] += gettime() - pInfo[playerid][player_last_activity];
			
			pInfo[playerid][player_afk] = false;
		}
		
		pInfo[playerid][player_last_activity] = gettime();
	}
	return 1;
}

/*public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if(IsPlayerNPC(playerid)) return 0;
	return 1;
}*/

public FCNPC_OnGiveDamage(npcid, damagedid, Float:amount, weaponid, bodypart)
{
	if(IsPlayerConnected(damagedid))
	{
		SetPlayerHealth(damagedid, floatround(pInfo[damagedid][player_health] - amount));
	}
	return 1;
}

public OnPlayerGiveDamageDynamicActor(playerid, actorid, Float:amount, weaponid, bodypart)
{
	if(!Actor[actorid][actor_damaged] && pInfo[playerid][player_robbery] != -1)
	{
		ApplyDynamicActorAnimation(actorid, "PED", "KO_shot_stom", 4.1,0,0,0,1,0);
		Robbery[pInfo[playerid][player_robbery]][robbery_aimed_actors]++;
		Actor[actorid][actor_damaged] = true;

		if(Actor[actorid][actor_type] == ACTOR_TYPE_ROBBERY && pInfo[playerid][player_robbery] != -1)
		{
			new Float:x, Float:y, Float:z;
			GetDynamicActorPos(actorid, x, y, z);
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
	return 1;
}

public OnPlayerPrepareDeath(playerid, animlib[32], animname[32], &anim_lock, &respawn_time)
{
	TogglePlayerControllable(playerid, false);
	for(new i;i<13;i++)
	{
		if( pWeapon[playerid][i][pw_itemid] > -1 ) Item_Use(pWeapon[playerid][i][pw_itemid], playerid);
	}

	new killerid = pInfo[playerid][player_killer];
	if(killerid != INVALID_PLAYER_ID)
	{
		new warid = CheckWarGroups(killerid, playerid);
		if( Iter_Contains(GangWars, warid) )
		{
			pInfo[playerid][player_bw] = 1800;
		}
		else
		{
			if(IsBulletWeapon(pInfo[playerid][player_death]))pInfo[playerid][player_bw] = 900;
		}

		pInfo[playerid][player_bw_end_time] = pInfo[playerid][player_bw] + gettime();  
	}
	return 1;
}

public OnPlayerDeathFinished(playerid, bool:cancelable)
{
	new
		Float:x,
		Float:y,
		Float:z,
		Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	pInfo[playerid][player_bw] = 300;
	pInfo[playerid][player_quit_pos][0] = x;
	pInfo[playerid][player_quit_pos][1] = y;
	pInfo[playerid][player_quit_pos][2] = z;
	pInfo[playerid][player_quit_pos][3] = a;
	pInfo[playerid][player_quit_vw] = GetPlayerVirtualWorld(playerid);
	pInfo[playerid][player_quit_int] = GetPlayerInterior(playerid);
	pInfo[playerid][player_health] = 5.0;
	pInfo[playerid][player_last_skin] = GetClientSkin(playerid);

	SetPlayerCameraPos(playerid, pInfo[playerid][player_quit_pos][0], pInfo[playerid][player_quit_pos][1], pInfo[playerid][player_quit_pos][2] + 6.0);
	SetPlayerCameraLookAt(playerid, pInfo[playerid][player_quit_pos][0], pInfo[playerid][player_quit_pos][1], pInfo[playerid][player_quit_pos][2], CAMERA_MOVE);
	SetPlayerHealth(playerid, 5);
	AddPlayerStatus(playerid, PLAYER_STATUS_BW);
	SetPlayerChatBubble(playerid, "((Aby sprawdzi� obra�enia postaci wci�nij klawisz interakcji (Y).))", COLOR_LIGHTER_RED, 7.0, 300000);

	mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_bw`=%d, `char_posx`='%f', `char_posy`='%f', `char_posz`='%f', `char_posa`='%f', `char_world`=%d, `char_interior`=%d WHERE `char_uid`=%d", pInfo[playerid][player_bw], x, y, z, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), pInfo[playerid][player_id]));
	return 0;
}

public OnPlayerDamageDone(playerid, Float:amount, issuerid, weapon, bodypart)
{
	if(issuerid != INVALID_PLAYER_ID)
	{
		printf("[DMG] %s (%d) zadal %f DMG graczowi %s (%d) z broni %d.", pInfo[issuerid][player_name], pInfo[issuerid][player_id], amount, pInfo[playerid][player_name], pInfo[playerid][player_id], weapon);
	}
	else
	{
		new weapon_name[32];
		GetWeaponName(weapon, weapon_name);
		printf("[selfDMG] %s (%d) otrzymal %f DMG, powod: %s.", pInfo[playerid][player_name], pInfo[playerid][player_id], amount, weapon_name);
	}

	new armor = GetPlayerUsedItem(playerid, ITEM_TYPE_ARMOUR);

	if(armor != -1)
	{
		if(PlayerItem[playerid][armor][player_item_value1] < 1)
		{
			Item_Use(armor, playerid);
		}
	}

	if(pInfo[playerid][player_armour] > 0) 
	{
		pInfo[playerid][player_armour] -= amount;

		if(armor != -1) PlayerItem[playerid][armor][player_item_value1] = floatround(pInfo[playerid][player_armour]);
	}
	else
	{
		pInfo[playerid][player_health] -= amount;
	}
	
	SetPlayerProgressBarValue(playerid, pInfo[playerid][player_health_bar], pInfo[playerid][player_health]);

	if(pInfo[playerid][player_health] > 60.0 && pInfo[playerid][player_health] <= 100.0)
	{
		SetPlayerProgressBarColour(playerid, pInfo[playerid][player_health_bar], COLOR_GREEN);
	}

	if(pInfo[playerid][player_health] > 20.0 && pInfo[playerid][player_health] <= 60.0)
	{
		SetPlayerProgressBarColour(playerid, pInfo[playerid][player_health_bar], COLOR_LIGHTER_ORANGE);
	}

	if(pInfo[playerid][player_health] <= 20.0)
	{
		SetPlayerProgressBarColour(playerid, pInfo[playerid][player_health_bar], 0xFF1C1CFF);
	}
	return 1;
}

public OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart)
{
	if( IsPlayerNPC(playerid) ) return 0;
	if( !pInfo[playerid][player_logged] ) return 0;
	if( pInfo[playerid][player_bw] > 0 ) return 0;
	if( pInfo[playerid][player_admin_duty] == true) return 0;
	if(pInfo[playerid][player_freeze]) return 0;
	if(weapon == WEAPON_FLOWER || weapon == WEAPON_DILDO || weapon == WEAPON_SHOVEL) return 0;

	if(issuerid != INVALID_PLAYER_ID)
	{
		if( pGlobal[issuerid][glo_block] & BLOCK_DMG) return 0;
		if( pGlobal[issuerid][glo_score] < 10) 
		{
			SendGuiInformation(issuerid, "Informacja", "Jeste� nowym graczem.\nDo czasu przegrania 1h nie mo�esz wdawa� si� w b�jki.\nTw�j przeciwnik nie traci HP.");
			return 0;
		}

		if(GetPVarInt(issuerid, "taser") == 1 && GetPlayerWeapon(issuerid) == 22)
		{
			ApplyAnimation(playerid,"CRACK","crckdeth2", 4.1, 0, 1, 1, 1, 0);
			defer AnimHitPlayer[15000](playerid);
			return 0;
		}

		//death
		if(pInfo[playerid][player_health]-amount < 1 && !pInfo[playerid][player_bw])
		{
			pInfo[playerid][player_death] = weapon;
			
			pInfo[playerid][player_killer] = issuerid;
			new warid = CheckWarGroups(issuerid, playerid);
			if( Iter_Contains(GangWars, warid) )
			{
				new area_id = GetAreaByUid(GangWar[warid][war_area]);
				if(area_id != -1)
				{
					if(IsPlayerInDynamicArea(playerid, area_id))
					{
						SetWarScore(issuerid, warid, 50);
						if(GetPlayerGroupSlot(playerid, GangWar[warid][war_at_gid]) != -1)
						{
							if(random(5) == 3)  CharacterKill(playerid, -1, "Ofiara walki o teren");
						}
					}
				}
			}
		}
		
	}

	new weaponid = weapon;
	
	pInfo[playerid][player_taken_damage] = gettime();

	UpdatePlayerLabel(playerid);
	EncountDamage(playerid, amount, bodypart, weaponid);

	if(issuerid != INVALID_PLAYER_ID)
	{
		if(weapon == 0 || weapon == WEAPON_BRASSKNUCKLE)
		{
			if(pInfo[issuerid][player_strength] > 50.0 && pInfo[issuerid][player_strength] < 60.0) amount += 1.0;
			if(pInfo[issuerid][player_strength] > 60.0 && pInfo[issuerid][player_strength] < 80.0) amount += 1.5;
			if(pInfo[issuerid][player_strength] > 80.0 && pInfo[issuerid][player_strength] < 95.0) amount += 2.0;
			if(pInfo[issuerid][player_strength] > 95.0) amount += 2.5;
		}

    	new String[64];
		new slot = GetWeaponSlot(weaponid);

    	if(slot != -1)
    	{
		    if(GetPlayerWeapon(issuerid) != 0 && pWeapon[issuerid][slot][pw_itemid] == -1 && pInfo[issuerid][player_parachute] == 0 && !pInfo[playerid][player_last_bullet])
		    {
		    	format(String, sizeof(String), "Invalid weapon damage (w: %d)", weaponid);
		    	KickAc(issuerid, -1, String);
		    	return 0;
		    }

			if(GetPlayerVehicleSeat(issuerid) == 1 || GetPlayerVehicleSeat(issuerid) == 2 || GetPlayerVehicleSeat(issuerid) == 3)
			{
				if(pWeapon[issuerid][slot][pw_itemid] == -1 )
				{
		    		format(String, sizeof(String), "No item DB (w: %d, seat: %d)", weaponid, GetPlayerVehicleSeat(issuerid));
					KickAc(issuerid, -1, String);
					return 0;
				}
			}
		}	
	}
	return 1;
}

/*public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	if( IsPlayerNPC(playerid) ) return 0;
	if( !pInfo[playerid][player_logged] ) return 0;
	if( pInfo[playerid][player_bw] > 0 ) return 0;
	if( pInfo[playerid][player_admin_duty] == true) return 0;

	if(issuerid != INVALID_PLAYER_ID)
	{
		if( pGlobal[issuerid][glo_block] & BLOCK_DMG) return 0;
		if( pGlobal[issuerid][glo_score] < 10) 
		{
			SendGuiInformation(issuerid, "Informacja", "Jeste� nowym graczem.\nDo czasu przegrania 1h nie mo�esz wdawa� si� w b�jki.\nTw�j przeciwnik nie traci HP.");
			return 0;
		}
	}
	
	pInfo[playerid][player_taken_damage] = gettime();

	UpdatePlayerLabel(playerid);

	EncountDamage(playerid, amount, bodypart, weaponid);

	if(issuerid != INVALID_PLAYER_ID)
	{
    	new String[64];
		new slot = GetWeaponSlot(weaponid);

    	if(slot != -1)
    	{
		    if(GetPlayerWeapon(issuerid) != 0 && pWeapon[issuerid][slot][pw_itemid] == -1 && pInfo[issuerid][player_parachute] == 0 && !pInfo[playerid][player_last_bullet])
		    {
		    	format(String, sizeof(String), "Invalid weapon damage (w: %d)", weaponid);
		    	KickAc(issuerid, -1, String);
		    	return 0;
		    }

			if(GetPlayerVehicleSeat(issuerid) == 1 || GetPlayerVehicleSeat(issuerid) == 2 || GetPlayerVehicleSeat(issuerid) == 3)
			{
				if(pWeapon[issuerid][slot][pw_itemid] == -1 )
				{
		    		format(String, sizeof(String), "No item DB (w: %d, seat: %d)", weaponid, GetPlayerVehicleSeat(issuerid));
					KickAc(issuerid, -1, String);
					return 0;
				}
			}
		}	
	}

	if(amount >= pInfo[playerid][player_health])
	{
		for(new i;i<13;i++)
		{
			if( pWeapon[playerid][i][pw_itemid] > -1 ) 
			{
				new itemid = pWeapon[playerid][i][pw_itemid];
				Item_Use(pWeapon[playerid][i][pw_itemid], playerid);
				Item_Drop(itemid, playerid, false);
			}
		}
		
		if( pInfo[playerid][player_bw] == 0 )
		{
			pInfo[playerid][player_bw] = 300;
			pInfo[playerid][player_bw_end_time] = pInfo[playerid][player_bw] + gettime();  
			SetPVarInt(playerid, "AnimHitPlayerGun", 0);
		}
		
		new
			Float:x,
			Float:y,
			Float:z,
			Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
				
		mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_bw`=%d, `char_posx`='%f', `char_posy`='%f', `char_posz`='%f', `char_posa`='%f', `char_world`=%d, `char_interior`=%d WHERE `char_uid`=%d", pInfo[playerid][player_bw], x, y, z, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), pInfo[playerid][player_id]));
		
		pInfo[playerid][player_quit_pos][0] = x;
		pInfo[playerid][player_quit_pos][1] = y;
		pInfo[playerid][player_quit_pos][2] = z;
		pInfo[playerid][player_quit_pos][3] = a;
		pInfo[playerid][player_quit_vw] = GetPlayerVirtualWorld(playerid);
		pInfo[playerid][player_quit_int] = GetPlayerInterior(playerid);
		pInfo[playerid][player_health] = 5.0;
		pInfo[playerid][player_death] = weaponid;

		if(issuerid != INVALID_PLAYER_ID)
		{
			pInfo[playerid][player_killer] = issuerid;
			new warid = CheckWarGroups(issuerid, playerid);
			if( Iter_Contains(GangWars, warid) ) SetWarScore(issuerid, warid, 50);
		}

		SetPlayerCameraPos(playerid, pInfo[playerid][player_quit_pos][0], pInfo[playerid][player_quit_pos][1], pInfo[playerid][player_quit_pos][2] + 6.0);
		SetPlayerCameraLookAt(playerid, pInfo[playerid][player_quit_pos][0], pInfo[playerid][player_quit_pos][1], pInfo[playerid][player_quit_pos][2]);
		SetPlayerHealth(playerid, 5);
		TogglePlayerControllable(playerid, false);
		AddPlayerStatus(playerid, PLAYER_STATUS_BW);
		SetPlayerChatBubble(playerid, "((Aby sprawdzi� obra�enia postaci wci�nij klawisz interakcji (Y).))", COLOR_LIGHTER_RED, 7.0, 300000);

		if(IsPlayerInAnyVehicle(playerid))
		{
			defer ApplyAnim[500](playerid, ANIM_TYPE_CARBW, weaponid);
		}
		else
		{
			defer ApplyAnim[500](playerid, ANIM_TYPE_BW, weaponid);
		}
		return 0;
	}

	if(GetPVarInt(issuerid, "taser") == 1)
	{
		ApplyAnimation(playerid,"CRACK","crckdeth2", 4.1, 0, 1, 1, 1, 0);
		defer AnimHitPlayer[15000](playerid);
	}

	if( pInfo[playerid][player_armour] > 0 && GetPlayerWeapon(issuerid) !=0 )
	{
		new armor = GetPlayerUsedItem(playerid, ITEM_TYPE_ARMOUR);
		new Float:Armour;
		GetPlayerArmour(playerid, Armour);

		switch(bodypart)
		{
			case BODY_PART_TORSO:
			{
				PlayerItem[playerid][armor][player_item_value1] -= 25;
				SetPlayerArmour(playerid, floatround(Armour) - 25);
			}
			case BODY_PART_GROIN:
			{
				PlayerItem[playerid][armor][player_item_value1] -= 30;
				SetPlayerArmour(playerid, floatround(Armour) - 30);
			}
			case BODY_PART_LEFT_ARM:
			{
				PlayerItem[playerid][armor][player_item_value1] -= 35;
				SetPlayerArmour(playerid, floatround(Armour) - 35);
			}
			case BODY_PART_RIGHT_ARM:
			{
				PlayerItem[playerid][armor][player_item_value1] -= 35;
				SetPlayerArmour(playerid, floatround(Armour) - 35);
			}
			case BODY_PART_HEAD:
			{
				PlayerItem[playerid][armor][player_item_value1] -= 25;
				SetPlayerArmour(playerid, floatround(Armour) - 25);
			}
			case BODY_PART_LEFT_LEG:
			{
				PlayerItem[playerid][armor][player_item_value1] -= 40;
				SetPlayerArmour(playerid, floatround(Armour) - 40);
			}
			case BODY_PART_RIGHT_LEG:
			{
				PlayerItem[playerid][armor][player_item_value1] -= 40;
				SetPlayerArmour(playerid, floatround(Armour) - 40);
			}
		}

		if(PlayerItem[playerid][armor][player_item_value1] < 1)
		{
			Item_Use(armor, playerid);
		}

		pInfo[playerid][player_health] += amount;
		SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health]));
	}
	
	if( (pInfo[playerid][player_health] - amount) <= 0.0 )
	{
		if( issuerid != INVALID_PLAYER_ID )
		{
			pInfo[playerid][player_bw] = 60 * 5;
		}
		else pInfo[playerid][player_bw] = 60 * 2;
		
		pInfo[playerid][player_bw_end_time] = pInfo[playerid][player_bw] + gettime();  
		
		SetPlayerHealth(playerid, 5);
	}
	else SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health] - amount));
	
	// Animacja postrza�u 	
	if(pInfo[playerid][player_bw] == 0 && amount > 5.0 && issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) != 0 && pInfo[playerid][player_health] < 80 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(GetPVarInt(playerid, "AnimHitPlayerGun") == 1) return 1;
		SetPVarInt(playerid, "AnimHitPlayerGun", 1);
		defer AnimHitPlayer[15000](playerid);

		switch(bodypart)
		{
			case BODY_PART_TORSO:
			{
				ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.1,0,0,0,1,0);
			}
			case BODY_PART_GROIN:
			{
				ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.1,0,0,0,1,0);
			}
			case BODY_PART_LEFT_ARM:
			{
				ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.1,0,0,0,1,0);
			}
			case BODY_PART_RIGHT_ARM:
			{
				ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.1,0,0,0,1,0);
			}
			case BODY_PART_HEAD:
			{
				ApplyAnimation(playerid, "PED", "KO_shot_face",4.1,0,0,0,1,0);
			}
			case BODY_PART_LEFT_LEG:
			{
				ApplyAnimation(playerid, "CRACK","crckdeth2", 4.1,0,0,0,1,0);
			}
			case BODY_PART_RIGHT_LEG:
			{
				ApplyAnimation(playerid, "CRACK","crckdeth2", 4.1,0,0,0,1,0);
			}
		}
	}
	return 0;
}*/

public OnPlayerDeath(playerid, killerid, reason)
{	
	if(IsPlayerNPC(playerid)) return 1;

	RemovePlayerFromVehicle(playerid);
	pInfo[playerid][player_last_skin] = GetClientSkin(playerid);

	for(new i;i<13;i++)
	{
		if( pWeapon[playerid][i][pw_itemid] > -1 ) Item_Use(pWeapon[playerid][i][pw_itemid], playerid);
	}

	if( pInfo[playerid][player_bw] == 0 )
	{
		SetPVarInt(playerid, "AnimHitPlayerGun", 0);
		pInfo[playerid][player_bw] = 300;
		pInfo[playerid][player_bw_end_time] = pInfo[playerid][player_bw] + gettime();
		TogglePlayerControllable(playerid, 0);
	}
	
	new
		Float:x,
		Float:y,
		Float:z,
		Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
			
	mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_bw`=%d, `char_posx`='%f', `char_posy`='%f', `char_posz`='%f', `char_posa`='%f', `char_world`=%d, `char_interior`=%d WHERE `char_uid`=%d", pInfo[playerid][player_bw], x, y, z, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), pInfo[playerid][player_id]));
	
	pInfo[playerid][player_quit_pos][0] = x;
	pInfo[playerid][player_quit_pos][1] = y;
	pInfo[playerid][player_quit_pos][2] = z;
	pInfo[playerid][player_quit_pos][3] = a;
	pInfo[playerid][player_quit_vw] = GetPlayerVirtualWorld(playerid);
	pInfo[playerid][player_quit_int] = GetPlayerInterior(playerid);
	pInfo[playerid][player_health] = 5.0;
	pInfo[playerid][player_death] = reason;
	pInfo[playerid][player_killer] = killerid;
	
	SetPlayerChatBubble(playerid, "((Aby sprawdzi� obra�enia postaci wci�nij klawisz interakcji (Y).))", COLOR_LIGHTER_RED, 7.0, 300000);

	scrp_SpawnPlayer(playerid);
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	ShowPlayerDialog(playerid, DIALOG_WHISPER, DIALOG_STYLE_INPUT, "Prywatna wiadomo��", sprintf("Podaj tre�� wiadomo�ci, kt�r� chcesz wys�a� do %s.", pInfo[clickedplayerid][player_name]), "Wy�lij", "Anuluj");
	pInfo[playerid][player_dialog_tmp1] = clickedplayerid;
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(pInfo[playerid][player_admin_duty] == true)
	{
		CA_FindZ_For2DCoord(fX, fY, fZ);
		SetPlayerPos(playerid, fX, fY, fZ+1);
	}
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if( pInfo[playerid][player_group_list_showed] )
	{
		HideGroupsList(playerid);
	}
    return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	switch(Pickup[pickupid][pickup_type])
	{
		case PICKUP_TYPE_JOB:
		{
			DynamicGui_Init(playerid);
			
			DynamicGui_AddRow(playerid, WORK_TYPE_LUMBERJACK);
			DynamicGui_AddRow(playerid, WORK_TYPE_FISHER);
			DynamicGui_AddRow(playerid, WORK_TYPE_FORKLIFT);
			DynamicGui_AddRow(playerid, WORK_TYPE_TRASHMAN);
			
			ShowPlayerDialog(playerid, DIALOG_WORKS, DIALOG_STYLE_TABLIST_HEADERS, ""guiopis"Dost�pne prace dorywcze:", "Stanowisko\tWymagania\tLokalizacja\nPracownik tartaku\tbrak\tThe Panopticon\nRybak\tbrak\tEast Beach\nOperator w�zka wid�owego\tbrak\tOcean Docks\nKierowca �mieciarki\tprawo jazdy\tWillowfield", "Wybierz", "Zamknij");
		}

		case PICKUP_TYPE_GOV:
		{
			ShowPlayerDialog(playerid, DIALOG_GOV, DIALOG_STYLE_LIST, "Urz�d miasta Los Santos", "1. Za�� w�asne przedsi�biorstwo\n2. Op�a� podatek dla przedsi�biorc�w ($5000)\n3. Wyr�b dokument", "OK", "Anuluj");
		}

		case PICKUP_TYPE_CASH:
		{
			if(pInfo[playerid][player_robbery] != -1)
			{
				Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_ROB_CASH, 11745, Pickup[pickupid][pickup_extra][0], Pickup[pickupid][pickup_extra][1], "Torba z �upem");
				GameTextForPlayer(playerid, sprintf("~w~Skradziono ~g~~h~~h~$%d", Pickup[pickupid][pickup_extra][0]), 5000, 1);
				DestroyDynamicPickup(pickupid);
			}
		}

		case PICKUP_TYPE_DOOR:
		{
			ShowPlayerDoorTextdraw(playerid, pickupid);

			if(Door[pickupid][door_rentable] == 1)
			{
				SendPlayerInformation(playerid, sprintf("~w~Mieszkanie na wynajem.~n~Cena: ~p~$%d~w~~n~/~p~drzwi wynajmij", Door[pickupid][door_rent]), 4000);
			}

			if(Door[pickupid][door_price] > 0)
			{
				SendPlayerInformation(playerid, sprintf("~w~Drzwi na sprzedaz.~n~Cena: ~p~$%d~w~~n~/~p~drzwi kup", Door[pickupid][door_price]), 4000);
			}
		}

		case PICKUP_TYPE_DROP:
		{
			switch(random(3))
			{
				case 0:
				{
					Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_DRUG, 1575, DRUG_TYPE_LSD, 100, "LSD");
					SendGuiInformation(playerid, "Informacja", "Przesy�ka zosta�a zebrana (100g LSD).");
				}
				case 1:
				{
					for(new i=0;i<5;i++) Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_WEAPON, 357, WEAPON_RIFLE, 25, "Rifle");
					for(new i=0;i<5;i++) Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_WEAPON, 347, WEAPON_SILENCED, 25, "Silenced Pistol");
					SendGuiInformation(playerid, "Informacja", "Przesy�ka zosta�a zebrana (5x rifle i 5x silencer).");
				}
				case 2:
				{
					for(new i=0;i<5;i++) Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_WEAPON, 350, WEAPON_SAWEDOFF, 25, "Obrzyn");
					Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_WEAPON, 344, WEAPON_MOLTOV, 1, "Molotov");
					SendGuiInformation(playerid, "Informacja", "Przesy�ka zosta�a zebrana (5x sawnoff i 1 molotov).");
				}
			}

			if(random(20) == 1) Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_WEAPON, 339, WEAPON_KATANA, 1, "Katana");
			DestroyDynamicPickup(pickupid);
		}
	}
	
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if( pInfo[playerid][player_group_list_showed] )
	{
		for(new i=0;i<5;i++)
		{
			if( playertextid == GroupsListStaticButtons[playerid][i][0] ) cmd_g(playerid, sprintf("%d info", i+1));
			else if( playertextid == GroupsListStaticButtons[playerid][i][1] ) cmd_g(playerid, sprintf("%d pojazdy", i+1));
			else if( playertextid == GroupsListStaticButtons[playerid][i][2] ) cmd_g(playerid, sprintf("%d duty", i+1));
			else if( playertextid == GroupsListStaticButtons[playerid][i][3] ) cmd_g(playerid, sprintf("%d magazyn", i+1));
			else if( playertextid == GroupsListStaticButtons[playerid][i][4] ) cmd_g(playerid, sprintf("%d online", i+1));
		}
	
		HideGroupsList(playerid);
	}
    return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	if( Object[objectid][object_uid] == 0 && !pInfo[playerid][player_esel_edited_label]) return 1;
	pInfo[playerid][player_edited_object_no_action] = true;
	if( !CanPlayerEditObject(playerid, objectid) )
	{
		SendClientMessage(playerid, COLOR_GREY, "Nie masz uprawnie� do edycji tego obiektu.");
		EditDynamicObject(playerid, objectid);
		CancelEdit(playerid);
		return 1;
	}
	if( IsObjectEdited(objectid) ) return SendClientMessage(playerid, COLOR_GREY, "Ten obiekt jest ju� edytowany przez kogo� innego."), EditDynamicObject(playerid, objectid), CancelEdit(playerid);
	pInfo[playerid][player_edited_object_no_action] = false;
	
	EditDynamicObject(playerid, objectid);
	Object[objectid][object_is_edited] = true;
	pInfo[playerid][player_edited_object] = objectid;
	
	GetDynamicObjectPos(objectid, pInfo[playerid][player_edited_object_pos][0], pInfo[playerid][player_edited_object_pos][1], pInfo[playerid][player_edited_object_pos][2]);
	GetDynamicObjectRot(objectid, pInfo[playerid][player_edited_object_pos][3], pInfo[playerid][player_edited_object_pos][4], pInfo[playerid][player_edited_object_pos][5]);
	
	Object[objectid][object_pos][0] = pInfo[playerid][player_edited_object_pos][0];
	Object[objectid][object_pos][1] = pInfo[playerid][player_edited_object_pos][1];
	Object[objectid][object_pos][2] = pInfo[playerid][player_edited_object_pos][2];
	Object[objectid][object_pos][3] = pInfo[playerid][player_edited_object_pos][3];
	Object[objectid][object_pos][4] = pInfo[playerid][player_edited_object_pos][4];
	Object[objectid][object_pos][5] = pInfo[playerid][player_edited_object_pos][5];
	
	UpdateObjectInfoTextdraw(playerid, objectid);
	TextDrawShowForPlayer(playerid, Dashboard[playerid]);
    return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if( !IsValidDynamicObject(objectid) ) return 1;

	if(pInfo[playerid][player_vattach_object] == objectid)
	{
		if( response == EDIT_RESPONSE_FINAL )
		{
			if(GetPlayerVehicleID(playerid) != pInfo[playerid][player_vattach_vehicle])
			{
				SendGuiInformation(playerid, "Informacja", "Nie znajdujesz si� w poje�dzie!\nEdycja zosta�a anulowana.");
				DestroyDynamicObject(objectid);
				pInfo[playerid][player_vattach_object] = INVALID_STREAMER_ID;
				pInfo[playerid][player_vattach_vehicle] = INVALID_VEHICLE_ID;
				TextDrawHideForPlayer(playerid, Tutorial[playerid]);
				return 1;
			}

			SendGuiInformation(playerid, "Informacja", "Obiekt przyczepialny zosta� pomy�lnie zapisany.");
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
		
			if(IsValidVehicle(pInfo[playerid][player_vattach_vehicle]))
			{
				SendGuiInformation(playerid, "Informacja", "Obiekt przyczepialny zosta� pomy�lnie zapisany.");
				ReattachDynamicObject(objectid, pInfo[playerid][player_vattach_vehicle]);
				mysql_tquery(mySQLconnection, sprintf("SELECT vattach_uid FROM ipb_vehicle_attachments WHERE vattach_owner = %d AND vattach_model = %d LIMIT 1", Vehicle[pInfo[playerid][player_vattach_vehicle]][vehicle_uid], GetObjectModel(objectid)), "OnPlayerEditVehicleAttachedObj", "ddd", playerid, objectid, Vehicle[pInfo[playerid][player_vattach_vehicle]][vehicle_uid]);
				DeleteItem(pInfo[playerid][player_dialog_tmp1], true, playerid);
				
				pInfo[playerid][player_vattach_object] = INVALID_STREAMER_ID;
				pInfo[playerid][player_vattach_vehicle] = INVALID_VEHICLE_ID;
				pInfo[playerid][player_dialog_tmp1] = 0;
			}
			else
			{
				SendGuiInformation(playerid, "Informacja", "Obiekt nie m�g� zosta� zapisany poniewa� pojazd zosta� odspawnowany lub usuni�ty.");
				DestroyDynamicObject(objectid);
				pInfo[playerid][player_vattach_object] = INVALID_STREAMER_ID;
				pInfo[playerid][player_vattach_vehicle] = INVALID_VEHICLE_ID;
			}

			TextDrawHideForPlayer(playerid, Tutorial[playerid]);
		}

		if( response == EDIT_RESPONSE_CANCEL )
		{
			SendGuiInformation(playerid, "Informacja", "Anulowa�e� edycje obiektu przyczepialnego.");
			DestroyDynamicObject(objectid);
			pInfo[playerid][player_vattach_object] = INVALID_STREAMER_ID;
			pInfo[playerid][player_vattach_vehicle] = INVALID_VEHICLE_ID;
		}

		return 1;
	}

	if( Object[objectid][object_uid] == 0 && !pInfo[playerid][player_esel_edited_label]) return 1;
	
	if( pInfo[playerid][player_edited_object_no_action] )
	{
		pInfo[playerid][player_edited_object_no_action] = false;
		return 1;
	}
	
	if( objectid == pInfo[playerid][player_esel_edited_object] && pInfo[playerid][player_esel_edited_label] > 0 )
	{
		if( response == EDIT_RESPONSE_FINAL )
		{
			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_3dlabels` SET `label_posx` = %f, `label_posy` = %f, `label_posz` = %f WHERE `label_uid` = %d", x, y, z, pInfo[playerid][player_esel_edited_label]));
			
			new l_id = LoadLabel(sprintf("WHERE `label_uid` = %d", pInfo[playerid][player_esel_edited_label]), true);
			
			SendGuiInformation(playerid, ""guiopis"Powiadomienie", sprintf("Zmieni�e� pozycje tekstu 3d [UID: %d, ID: %d].", Label[Text3D:l_id][label_uid], l_id));

		}
		
		if( response == EDIT_RESPONSE_CANCEL )
		{
			SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Edycja obiektu anulowana. Powr�ci� on na swoje miejsce.");
			
			LoadLabel(sprintf("WHERE `label_uid` = %d", pInfo[playerid][player_esel_edited_label]));
		}
		
		if( response == EDIT_RESPONSE_CANCEL || response == EDIT_RESPONSE_FINAL )
		{
			DestroyDynamicObject(objectid);
			
			pInfo[playerid][player_esel_edited_label] = 0;
			pInfo[playerid][player_esel_edited_object] = -1;
			
			SendPlayerInformation(playerid, "", 0);
			
			TextDrawHideForPlayer(playerid, Dashboard[playerid]);
		}
		return 1;
	}
	
	if( response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL )
	{
		new o_id = pInfo[playerid][player_edited_object];
		TextDrawHideForPlayer(playerid, Dashboard[playerid]);
		if(o_id == -1) return 1;
		Object[o_id][object_is_edited] = false;
		pInfo[playerid][player_edited_object] = -1;
	}
	
	if( response == EDIT_RESPONSE_CANCEL )
	{
		SetDynamicObjectPos(objectid, pInfo[playerid][player_edited_object_pos][0], pInfo[playerid][player_edited_object_pos][1], pInfo[playerid][player_edited_object_pos][2]);
		SetDynamicObjectRot(objectid, pInfo[playerid][player_edited_object_pos][3], pInfo[playerid][player_edited_object_pos][4], pInfo[playerid][player_edited_object_pos][5]);
		
		if(Object[objectid][object_gate] == 0)
		{
			new str[400];
			strcat(str, sprintf("UPDATE `ipb_objects` SET `object_posx` = %f, `object_posy` = %f, `object_posz` = %f,", pInfo[playerid][player_edited_object_pos][0], pInfo[playerid][player_edited_object_pos][1], pInfo[playerid][player_edited_object_pos][2]));
			strcat(str, sprintf(" `object_rotx` = %f, `object_roty` = %f, `object_rotz` = %f WHERE `object_uid` = %d", pInfo[playerid][player_edited_object_pos][3], pInfo[playerid][player_edited_object_pos][4], pInfo[playerid][player_edited_object_pos][5], Object[objectid][object_uid]));
			mysql_query(mySQLconnection, str);
		}
	}
	
	if( response == EDIT_RESPONSE_FINAL )
	{		
		if( Object[objectid][object_owner_type] == OBJECT_OWNER_TYPE_AREA )
		{
			if( !IsPointInDynamicArea(GetAreaByUid(Object[objectid][object_owner]), x, y, z) )
			{
				pInfo[playerid][player_edited_object] = -1;
				Object[objectid][object_is_edited] = false;
				
				SetDynamicObjectPos(objectid, pInfo[playerid][player_edited_object_pos][0], pInfo[playerid][player_edited_object_pos][1], pInfo[playerid][player_edited_object_pos][2]);
				SetDynamicObjectRot(objectid, pInfo[playerid][player_edited_object_pos][3], pInfo[playerid][player_edited_object_pos][4], pInfo[playerid][player_edited_object_pos][5]);
				
				SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Obiekt, kt�ry chcesz zapisa� wykracza poza wyznaczon� strefe.\nJego pozycja powr�ci�a do miejsca z przed edycji.");
				
				return 1;
			}
		}
	
		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);

		mysql_query(mySQLconnection, sprintf("UPDATE `ipb_objects` SET `object_posx` = %f, `object_posy` = %f, `object_posz` = %f, `object_rotx` = %f, `object_roty` = %f, `object_rotz` = %f WHERE `object_uid` = %d", x, y, z, rx, ry, rz, Object[objectid][object_uid]));
		
		new uid = Object[objectid][object_uid];
		DeleteObject(objectid, false);
		
		LoadObject(sprintf("WHERE `object_uid` = %d", uid), true);
		RefreshPlayer(playerid);
	}
	else if( response == EDIT_RESPONSE_UPDATE )
	{
		Object[objectid][object_pos][0] = x;
		Object[objectid][object_pos][1] = y;
		Object[objectid][object_pos][2] = z;
		Object[objectid][object_pos][3] = rx;
		Object[objectid][object_pos][4] = ry;
		Object[objectid][object_pos][5] = rz;
		
		UpdateObjectInfoTextdraw(playerid, objectid);
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if( text[0] == '.' && text[1] != ' ' )
	{
		if(GetPVarInt(playerid, "AnimHitPlayerGun")==1)
		{
			if( strfind(text, "/me", true) == -1 && strcmp(text, "/admins") != 0 && strcmp(text, "/akceptujsmierc") != 0 && strcmp(text, "/a") != 0 && strfind(text, "/do", true) == -1 && strfind(text, "/w", true) == -1 && strfind(text, "/bw", true) == -1 && strfind(text, "/report", true) == -1 && strfind(text, "/b", true) == -1 && strfind(text, "/p", true) == -1 )
			{
				ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Podczas animacji po postrzale, nie mo�esz u�y� animacji.", "Akceptuj", "");
				return 0;
			}
		}
		
		if(pInfo[playerid][player_bw] != 0)
		{
			SendGuiInformation(playerid, "Informacja", "Nie mo�esz u�ywa� animacji podczas BW.");
			return 0;
		}

		new bool: found = false;
	    foreach(new anim_id: Anims)
	    {
			if(!isnull(AnimInfo[anim_id][aCommand]))
			{
	        	if(!strcmp(text, AnimInfo[anim_id][aCommand], true))
	        	{
	        	    if(AnimInfo[anim_id][aAction] == 0)
	        	    {
	        	    	ApplyAnimation(playerid, AnimInfo[anim_id][aLib], AnimInfo[anim_id][aName], AnimInfo[anim_id][aSpeed], AnimInfo[anim_id][aOpt1], AnimInfo[anim_id][aOpt2], AnimInfo[anim_id][aOpt3], AnimInfo[anim_id][aOpt4], AnimInfo[anim_id][aOpt5], 1);
					}
					else
					{
	                    SetPlayerSpecialAction(playerid, AnimInfo[anim_id][aAction]);
					}
					pInfo[playerid][player_looped_anim] = true;
					found = true;
	        	}
	        }
	    }
		if(!found) PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
		
		return 0;
	}
	
	if( text[0] == '@' && strlen(text) > 3)
	{
		if(pGlobal[playerid][glo_block] & BLOCK_OOC)
		{
			SendGuiInformation(playerid, "Informacja", "Posiadasz aktywn� blokad� czatu OOC.");
			return 0;
		}

		new input[128], slot;
		if( text[1] != ' ' && text[2] == ' ' )
		{
			sscanf(text, "'@'ds[128]", slot, input);
			if(isnull(input)) return 0;
			if( slot >= 1 && slot <= 5 )
			{
				SendGroupOOC(playerid, slot, input);
			}
		}
		return 0;
	}
	
	if( text[0] == '!' && strlen(text) > 3)
	{
		new input[128], slot;
		if( text[1] != ' ' && text[2] == ' ' )
		{
			sscanf(text, "'!'ds[128]", slot, input);
			if(isnull(input)) return 0;
			if( slot >= 1 && slot <= 5 )
			{
				SendGroupIC(playerid, slot, input);
			}
		}
		return 0;
	}

	if( pInfo[playerid][player_bw] > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Twoja posta� jest aktualnie nieprzytomna, musisz odczeka� a� powr�ci do normalnego stanu.\nObecnie u�ywanie komend jest ograniczone.\nWyj�tkiem s� komendy: /akceptujsmierc, /me, /do, /w, /p.", "OK", "");
		return 0;
	}
	
	if( !strcmp(text, ":D", true) || !strcmp(text, ";D", true)  )
	{
		cmd_ame(playerid, "�mieje si�.");
		return 0;
	}

	if( !strcmp(text, ":O", true) || !strcmp(text, ";o", true) )
	{
		cmd_ame(playerid, "robi zdziwion� min�.");
		return 0;
	}
	
	if( !strcmp(text, ":)", true) || !strcmp(text, ";)", true) )
	{
		cmd_ame(playerid, "u�miecha si�.");
		return 0;
	}

	if( !strcmp(text, ":(", true) || !strcmp(text, ";(", true) )
	{
		cmd_ame(playerid, "robi smutn� mine.");
		return 0;
	}

	if( !strcmp(text, ":/", true) || !strcmp(text, ";/", true) )
	{
		cmd_ame(playerid, "krzywi si�.");
		return 0;
	} 

	if( !strcmp(text, ":P", true) || !strcmp(text, ";P", true) )
	{
		cmd_ame(playerid, "wystawia j�zyk.");
		return 0;
	}

	if( !strcmp(text, ":*", true) || !strcmp(text, ";*", true) )
	{
		cmd_ame(playerid, "posy�a buziaka.");
		return 0;
	}	
	
	if( pInfo[playerid][player_phone_call_started] )
	{
		ProxMessage(playerid, text, PROX_PHONE);	
		return 0;
	}

	if( pInfo[playerid][player_interview] > -1 )
	{
		new gid = pInfo[playerid][player_interview];

		sscanf(pInfo[playerid][player_name], "s[32]", Group[gid][group_radio_sender]);
		sscanf(text, "s[128]", Group[gid][group_radio_text]);
		Group[gid][group_news_type] = 3;

		foreach(new p: Player)
		{
			if(pInfo[p][player_radio] == gid)
			{
				PlayerTextDrawSetString(p, TextDrawSanNews[p], sprintf("_~w~%s~p~LIVE ~>~ ~y~%s~w~ ~>~ %s", Group[gid][group_name], pInfo[playerid][player_name], Group[gid][group_radio_text]));
			}
		}

		last_radio = gid;
		ProxMessage(playerid, text, PROX_LOCAL);
		return 0;
	}
	
	if(pGlobal[playerid][glo_block] & BLOCK_OOC)
	{
		if( strfind(text, "((", true) != -1 && strfind(text, "))", true) != -1 )
		{
			AdminJail(playerid, -1, "Omijanie blokady czatu OOC", 10);
			return 0;
		}
	}

	if( strfind(text, "!!", true) != -1)
	{
		ProxMessage(playerid, text, PROX_SHOUT, true);
		return 0;
	}

	ProxMessage(playerid, text, PROX_LOCAL);
	
	return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_ACTION) pInfo[playerid][player_last_tab] = gettime();
	if(pInfo[playerid][player_race_phase] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	 	if(newkeys & KEY_FIRE)
	  	{
			if(pInfo[playerid][player_race_point] < MAX_RACE_CP - 1)
			{
			    new vehicleid = GetPlayerVehicleID(playerid);
   				new checkpoint = pInfo[playerid][player_race_point], string[250];
       			GetVehiclePos(vehicleid, RaceCheckpoint[checkpoint][0], RaceCheckpoint[checkpoint][1], RaceCheckpoint[checkpoint][2]);

				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~w~Checkpoint ~y~dodany", 3000, 3);
				pInfo[playerid][player_race_point] ++;

				format(string, sizeof(string), "Rozpoczales ~y~proces ~w~tworzenia wyscigu.~w~~n~~n~~y~~k~~VEHICLE_FIREWEAPON~ ~w~- ustawianie checkpointa~n~~y~SPACE ~w~- ustalanie linii mety~n~~n~Checkpointy: ~y~%d/%d", pInfo[playerid][player_race_point], MAX_RACE_CP);

				TextDrawSetString(Tutorial[playerid], string);
				TextDrawShowForPlayer(playerid, Tutorial[playerid]);
			}
			else
			{
   				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~r~Limit checkpointow przekroczony! Ustal linie mety!", 3000, 3);
			}

			return 1;
   		}

		if(newkeys & KEY_HANDBRAKE)
  		{
  			if(pInfo[playerid][player_race_point] <= 2)
	    	{
      			GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~r~Musza byc conajmniej 3 checkpointy!", 3000, 3);
	        	return 1;
		    }
		    new vehicleid=GetPlayerVehicleID(playerid);
      		new checkpoint = pInfo[playerid][player_race_point];
        	GetVehiclePos(vehicleid, RaceCheckpoint[checkpoint][0], RaceCheckpoint[checkpoint][1], RaceCheckpoint[checkpoint][2]);

			GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~w~Linia mety ~y~ustawiona", 3000, 3);
			pInfo[playerid][player_race_phase] = 2;

			pInfo[playerid][player_race_checkpoints] = pInfo[playerid][player_race_point];

			SendPlayerInformation(playerid, "Postawiles ~y~linie mety~w~. Teraz zapros uczestnikow przez ~y~/wyscig zapros~w~.~n~~n~~y~/wyscig start ~w~rozpoczyna wyscig.", 6000);

			return 1;
		}
	}

	new vidd = GetPlayerVehicleID(playerid);

	// Rowerek
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new model = GetVehicleModel(vidd);
		if(model == 509 || model == 510 || model == 481)
  		{
  		    if(newkeys & KEY_ACTION)
			{
				new a_id = pInfo[playerid][player_area];
				if(a_id < 1 || !AreaHasFlag(a_id, AREA_FLAG_BMX))
				{
					if(!PlayerHasFlag(playerid, PLAYER_FLAG_BMX))
					{
	                	ClearAnimations(playerid);
	                	SendPlayerInformation(playerid, "~w~W tej strefie skakanie rowerem jest ~y~zablokowane~w~.", 5000);
	                }
				}
			}
		}
	}

	if(IsValidDynamicObject(pInfo[playerid][player_roulette_selector]))
	{
		if(newkeys & KEY_SPRINT)
		{
			if(pInfo[playerid][player_roulette_timer] > 0) return SendGuiInformation(playerid, "Informacja", "Nie mo�esz anulowa� w trakcie losowania.");
			pInfo[playerid][player_roulette_object] = INVALID_STREAMER_ID;
			pInfo[playerid][player_roulette_field] = 0;
			TogglePlayerControllable(playerid, true);
			SetCameraBehindPlayer(playerid);
			TextDrawHideForPlayer(playerid, Tutorial[playerid]);
			DestroyDynamicObject(pInfo[playerid][player_roulette_selector]);
			pInfo[playerid][player_roulette_selector] = INVALID_STREAMER_ID;
		}
		if(newkeys & KEY_JUMP)
		{
			if(pInfo[playerid][player_roulette_timer] > 0) return SendGuiInformation(playerid, "Informacja", "Nie mo�esz obstawia� w trakcie losowania.");
			if(pInfo[playerid][player_roulette_bet] > 0) return SendGuiInformation(playerid, "Informacja", "Na ten moment (faza test�w) mo�liwe jest obstawienie tylko jednego pola.");
			ShowPlayerDialog(playerid, DIALOG_ROULETTE_WAGER, DIALOG_STYLE_INPUT, "Ruletka", "Podaj ilo�� got�wki jak� chcesz obstawi� na te pole.", "Kr��", "Anuluj");
		}

	}

	if(pInfo[playerid][player_rob_time] > 1)
	{
		if(newkeys & KEY_SPRINT)
		{
			pInfo[playerid][player_rob_time] = 0;
	    	pInfo[playerid][player_rob_stage] = 0;
	    	TogglePlayerControllable(playerid, 1);
	    	ClearAnimations(playerid);
	    	TextDrawHideForPlayer(playerid, DoorInfo[playerid]);
	    	SendGuiInformation(playerid, "Informacja", "Przerwano czynno�ci rabunkowe.");
		}
	}

	if(pInfo[playerid][player_bus_stop])
	{
		if(oldkeys & KEY_SECONDARY_ATTACK)
		{
			if(pInfo[playerid][player_last_bus] + 100 > GetTickCount())
			{
				new object_id = GetClosestBusStop(playerid);

				if(object_id == INVALID_STREAMER_ID) return SendGuiInformation(playerid, "Informacja", "Brak przystank�w autobusowych w okolicy. Szukaj dalej.");
				if(object_id == pInfo[playerid][player_bus_stop]) return SendGuiInformation(playerid, "Informacja", "Brak przystank�w autobusowych w okolicy. Szukaj dalej.");

				new Float:x, Float:y, Float:z;
				GetDynamicObjectPos(object_id, x, y, z);

				SetPlayerCameraPos(playerid, x, y, 171.767776);
				SetPlayerCameraLookAt(playerid, x, y+45, z);

				new Float:startX, Float:startY, Float:startZ;
				GetDynamicObjectPos(pInfo[playerid][player_bus_stop], startX, startY, startZ);

				new Float:distance = floatround(floatsqroot((startX - x) * (startX - x) + (startY - y) * (startY - y)));

				pInfo[playerid][player_bus_destination] = object_id;
		        pInfo[playerid][player_bus_time] = floatround(distance, floatround_floor) / 10;
		        pInfo[playerid][player_bus_price] = floatround(distance, floatround_floor) / 25;

		        GetPlayer2DZone(playerid, pInfo[playerid][player_bus_destzone], MAX_ZONE_NAME);

				new string[128];

				format(string, sizeof(string), "Przejazd z dzielnicy %s do %s.\n\nCzas przejazdu: %ds\nKoszt: $%d\n\nNa pewno chcesz si� uda� w te miejsce?", pInfo[playerid][player_bus_zone], pInfo[playerid][player_bus_destzone], pInfo[playerid][player_bus_time], pInfo[playerid][player_bus_price]);
		        ShowPlayerDialog(playerid, DIALOG_ACCEPT_TRAVEL, DIALOG_STYLE_MSGBOX, "Przejazd autobusem", string, "Jed�", "Anuluj");
				
				return 1;
			}
		}

		else if(newkeys & KEY_JUMP)
		{
			TogglePlayerSpectating(playerid, false);
			new Float:x, Float:y, Float:z;
			GetDynamicObjectPos(pInfo[playerid][player_bus_stop], x, y, z);

			SetPlayerPos(playerid, x, y, z);
			SetCameraBehindPlayer(playerid);
			TextDrawHideForPlayer(playerid, Tutorial[playerid]);
			TogglePlayerControllable(playerid, true);
			DestroyDynamicObject(pInfo[playerid][player_bus_object]);
			pInfo[playerid][player_bus_object] = INVALID_STREAMER_ID;
			pInfo[playerid][player_bus_stop] = false;
		}
	}

	//Okno informacyjne
	if(newkeys & KEY_NO)
	{
		TextDrawHideForPlayer(playerid, Tutorial[playerid]);
	}

	if( IsValidDynamicObject(pInfo[playerid][player_edited_object]) && pInfo[playerid][player_editor] == OBJECT_EDITOR_CUSTOM )
	{
		if(newkeys & KEY_FIRE)
		{
			if(!pInfo[playerid][player_custom_edit])
			{
				ApplyAnimation(playerid, "CRACK", "crckidle1", 4.1, 1, 0, 0, 0, 0);
				pInfo[playerid][player_custom_edit] = true;
			}
			else
			{
				new skin = GetClientSkin(playerid);
				SetPlayerSkin(playerid, skin);
				TogglePlayerControllable(playerid, false);
				TogglePlayerControllable(playerid, true);
				pInfo[playerid][player_custom_edit] = false;
			}
		}
	}

	//Praca rybaka
	if(pInfo[playerid][player_working] == WORK_TYPE_FISHER)
	{
		if(newkeys & KEY_YES)
		{
			if(pInfo[playerid][player_job] == WORK_TYPE_FISHER )
			{
				if(pInfo[playerid][player_carry] ==  WORK_TYPE_FISHER)
				{
					new Fisher = GetClosestActorType(playerid, ACTOR_TYPE_FISHER);

					if(Fisher != INVALID_STREAMER_ID)
					{
						new cash = 4+random(2);
						pInfo[playerid][player_job_cash] += cash;
						SendClientMessage(playerid, COLOR_GOLD, sprintf("Dodano $%d do zarobk�w z pracy dorywczej. Wyp�ate mo�esz odebra� w banku. Obecny stan: $%d/$350", cash, pInfo[playerid][player_job_cash]));
						RemovePlayerAttachedObject(playerid, 7);
						RemovePlayerAttachedObject(playerid, 8);
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
						new randd = random(4);
						switch(randd)
						{
							case 0: ActorProx(Fisher, "Richard Bait", "No no, ca�kiem �adny okaz.", PROX_LOCAL);
							case 1: ActorProx(Fisher, "Richard Bait", "Niez�a! Podobno na wsch�d od dok�w dobrze bior�.", PROX_LOCAL);
							case 2: ActorProx(Fisher, "Richard Bait", "Potrzebuje troche wi�cej, ta japo�ska knajpka z Market zam�wi�a 50kg dorsza.", PROX_LOCAL);
							case 3: ActorProx(Fisher, "Richard Bait", "B�dzie z niej niez�e sushi.", PROX_LOCAL);
						}
						pInfo[playerid][player_carry] = 0;
					}
				}
				else
				{
					new veh = GetNearestVehicle(playerid);
					if(veh > -1)
					{
						if(Vehicle[veh][vehicle_model] == 453)
						{
							new Float:xx, Float:yy, Float:zz;
							GetVehicleBoot(veh, xx, yy, zz);
							if(!IsPlayerInRangeOfPoint(playerid, 3.0, xx, yy, zz)) return 1;

							if(GetVehicleFishCount(veh) < 1) return SendClientMessage(playerid, COLOR_GREY, "Tip: W tym kutrze nie ma �adnych ryb.");

							Vehicle[veh][vehicle_fish_object] -= 1;

							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
							SetPlayerAttachedObject(playerid, 7, 19630, 6, 0.024000, 0.052000, -0.199000);
							SetPlayerAttachedObject(playerid, 8, 1355, 6, -0.024000, 0.193000, -0.240999, -114.300041, 0.000000, 78.000000);
							pInfo[playerid][player_carry] = WORK_TYPE_FISHER;
						}
					}
				}
			}
		}

		if(newkeys & KEY_FIRE)
		{
			if(pInfo[playerid][player_job] == WORK_TYPE_FISHER )
			{
				new vid = GetPlayerVehicleID(playerid);
				if(vid != INVALID_VEHICLE_ID)
				{
					if(Vehicle[vid][vehicle_model] == 453)
					{
						if(CA_IsPlayerNearWater(playerid))
						{
							if(GetVehicleFishCount(GetPlayerVehicleID(playerid)) >= 10)
							{
								SendClientMessage(playerid, COLOR_GREY, "Tip: Nie mo�esz za�adowa� wi�cej ryb na kuter. Udaj si� do portu sprzeda� towar.");
								return 1;
							}

							/*if(Object[object_id][object_logs] < 1)
							{
								DeleteObject(object_id, false);
								return 1;
							}*/
							
							SendClientMessage(playerid, COLOR_GOLD, "Trwa po��w ryb, prosze czeka�.");

							defer Fish_Get[5000](playerid, GetPlayerVehicleID(playerid));
							pInfo[playerid][player_fishing] = true;
							//Object[object_id][object_logs]--;
						}
					}
				}
			}
		}
	}

	//Praca �mieciarza
	if(pInfo[playerid][player_working] == WORK_TYPE_TRASHMAN)
	{
		if(newkeys & KEY_YES)
		{
			if(pInfo[playerid][player_job] == WORK_TYPE_TRASHMAN )
			{
				new v_id = pInfo[playerid][player_last_veh];
				if(GetVehicleModel(v_id) != 408) return SendGuiInformation(playerid,  "Informacja", "Twoim ostatnim pojazdem musi by� �mieciarka.");
	
				new trash_id = GetClosestTrashObject(playerid);
				if(trash_id == INVALID_STREAMER_ID) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz si� w pobli�u �mietnika.");

				if(pInfo[playerid][player_carry] == WORK_TYPE_TRASHMAN) return SendGuiInformation(playerid, "Informacja", "Masz ju� w r�ce jaki� worek z odpadami.");
		
				if(Object[trash_id][object_logs] < 1) return SendGuiInformation(playerid, "Informacja", "Brak odpad�w w �mietniku.");

				new Float: x, Float: y, Float: z;
			    GetVehicleBoot(v_id, x, y, z);
			    if(GetPlayerDistanceFromPoint(playerid, x, y, z) >= 30.0) return SendGuiInformation(playerid, "Informacja", "Twoja �mieciarka nie znajduje si� w pobli�u.");

				Object[trash_id][object_logs]--;
				//KillTimer(Object[trash_id][object_timer]);
			   // Object[trash_id][object_timer] = SetTimerEx("FillTrash", REFILL_TIME * 1000, false, "i", id);
				pInfo[playerid][player_checkpoint] = CreateDynamicCP(x, y, z, 3.0, .playerid = playerid);
				pInfo[playerid][player_carry] = WORK_TYPE_TRASHMAN;

				ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0);
				SetPlayerAttachedObject(playerid, ATTACH_SLOT_GYM1, 1264, 6, 0.222, 0.024, 0.128, 1.90, -90.0, 0.0, 0.5,0.5, 0.5);
				Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Object[trash_id][object_label], E_STREAMER_COLOR, (Object[trash_id][object_logs] == 0) ? 0xE74C3CFF : 0xF39C12FF);
			}
		}
	}

	//Praca widlakiem
	if(pInfo[playerid][player_working] == WORK_TYPE_FORKLIFT)
	{
		if(newkeys & KEY_YES)
		{
			if(pInfo[playerid][player_job] == WORK_TYPE_FORKLIFT )
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
				{
					new veh = GetPlayerVehicleID(playerid);
					if(GetVehicleModel(veh) == 530)
					{
						if(IsValidDynamicObject(Vehicle[veh][vehicle_log_object][0]))
						{
							new box_id = GetClosestObjectType(playerid, OBJECT_CONTAINER);
							if(box_id != INVALID_STREAMER_ID)
							{
								if(IsValidDynamicObject(Vehicle[veh][vehicle_log_object][0])) DestroyDynamicObject(Vehicle[veh][vehicle_log_object][0]);
								Vehicle[veh][vehicle_log_object][0] = INVALID_STREAMER_ID;
								new cash = 5 + random(8);
								pInfo[playerid][player_job_cash] += cash;
								SendClientMessage(playerid, COLOR_GOLD, sprintf("Dodano $%d do zarobk�w z pracy dorywczej. Wyp�ate mo�esz odebra� w banku. Obecny stan: $%d/$350", cash, pInfo[playerid][player_job_cash]));
							}
						}
						else
						{
							//todo dodac tu support dla paczek przemycanych
							new box_id = GetClosestObjectType(playerid, OBJECT_FORKLIFT_BOX);
							if(box_id != INVALID_STREAMER_ID)
							{
								if(Object[box_id][object_logs] > 1) Object[box_id][object_logs]--;
								if(Object[box_id][object_logs] <= 1) DeleteObject(box_id, false);

								new Float:x, Float:y, Float:z;
								GetVehiclePos(veh, x, y, z);
								Vehicle[veh][vehicle_log_object][0] = CreateDynamicObject(OBJECT_FORKLIFT_BOX, x, y, z+2.0, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid));
								AttachDynamicObjectToVehicle(Vehicle[veh][vehicle_log_object][0], veh, 0.000000,0.599999,0.449999,0.000000,0.000000,0.000000); 
							}
						}
					}
				}
			}
		}
	}

	//Praca drwala
	if(pInfo[playerid][player_working] == WORK_TYPE_LUMBERJACK)
	{
		if(newkeys & KEY_YES)
		{
			if(pInfo[playerid][player_job] == WORK_TYPE_LUMBERJACK )
			{
				if(pInfo[playerid][player_carry] == WORK_TYPE_LUMBERJACK)
				{
					new Lumberjack = GetClosestActorType(playerid, ACTOR_TYPE_LUMBERJACK);

					if(Lumberjack != INVALID_STREAMER_ID)
					{
						new cash = 5 + random(10);
						pInfo[playerid][player_job_cash] += cash;
						SendClientMessage(playerid, COLOR_GOLD, sprintf("Dodano $%d do zarobk�w z pracy dorywczej. Wyp�ate mo�esz odebra� w banku. Obecny stan: $%d/$350", cash, pInfo[playerid][player_job_cash]));
						RemovePlayerAttachedObject(playerid, 7);
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
						pInfo[playerid][player_carry] = 0;
					}
					else
					{
						new veh = GetNearestVehicle(playerid);
						if(veh > -1)
						{
							if(Vehicle[veh][vehicle_model] == 422)
							{
								new Float:xx, Float:yy, Float:zz;
								GetVehicleBoot(veh, xx, yy, zz);
								if(!IsPlayerInRangeOfPoint(playerid, 3.0, xx, yy, zz)) return 1;
								if(GetVehicleLogCount(veh) >= 10)
								{
									SendClientMessage(playerid, COLOR_GREY, "Tip: Nie mo�esz za�adowa� wi�cej drewna.");
									RemovePlayerAttachedObject(playerid, 7);
									SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
									pInfo[playerid][player_carry] = 0;
									return 1;
								}

								for(new i; i < 10; i++)
						    	{
						    	    if(!IsValidDynamicObject(Vehicle[veh][vehicle_log_object][i]))
						    	    {
						    	        Vehicle[veh][vehicle_log_object][i] = CreateDynamicObject(19793, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
						    			AttachDynamicObjectToVehicle(Vehicle[veh][vehicle_log_object][i], veh, LogAttachOffsets[i][0], LogAttachOffsets[i][1], LogAttachOffsets[i][2], 0.0, 0.0, LogAttachOffsets[i][3]);
						    			break;
						    	    }
						    	}

						    	RemovePlayerAttachedObject(playerid, 7);
								SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
								pInfo[playerid][player_carry] = 0;
							}
						}
					}
				}
				else
				{
					new object_id = GetClosestObjectType(playerid, OBJECT_TREE);

					if(object_id != INVALID_STREAMER_ID)
					{
						new Float:rx, Float:ry, Float:rz;
						GetDynamicObjectRot(object_id, rx, ry, rz);
						if(ry == -80.0)
						{
							if(Object[object_id][object_logs] < 1) return SendClientMessage(playerid, COLOR_GREY, "Wszystkie kawa�ki tego drzewa zosta�y ju� zabrane.");
							pInfo[playerid][player_carry] =  WORK_TYPE_LUMBERJACK;
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
							SetPlayerAttachedObject(playerid, 7, 19793, 6, 0.077999, 0.043999, -0.170999, -13.799953, 79.70, 0.0);
							Object[object_id][object_logs]--;
						}
					}
					else
					{
						new veh = GetNearestVehicle(playerid);
						if(veh > -1)
						{
							new Float:x, Float:y, Float:z;
							GetVehicleBoot(veh, x, y, z);
							if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return 1;
							if(GetVehicleLogCount(veh) < 1) return SendClientMessage(playerid, COLOR_GREY, "Tip: W tym poje�dzie nie ma �adnego drewna.");

							for(new i = (10 - 1); i >= 0; i--)
					    	{
					    	    if(IsValidDynamicObject(Vehicle[veh][vehicle_log_object][i]))
					    	    {
					    	        DestroyDynamicObject(Vehicle[veh][vehicle_log_object][i]);
					    	        Vehicle[veh][vehicle_log_object][i] = INVALID_STREAMER_ID;
					    			break;
					    	    }
					    	}

							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
							SetPlayerAttachedObject(playerid, 7, 19793, 6, 0.077999, 0.043999, -0.170999, -13.799953, 79.70, 0.0);
							pInfo[playerid][player_carry] = WORK_TYPE_LUMBERJACK;
						}
					}
				}
			}
		}

		if(newkeys & KEY_FIRE)
		{
			if(pInfo[playerid][player_job] == WORK_TYPE_LUMBERJACK )
			{
				if(IsPlayerAttachedObjectSlotUsed(playerid, 8) && !pInfo[playerid][player_cutting_tree])
				{
					new object_id = GetClosestObjectType(playerid, OBJECT_TREE);
					if(object_id != INVALID_STREAMER_ID)
					{
						new Float:rx, Float:ry, Float:rz;
						GetDynamicObjectRot(object_id, rx, ry, rz);

						if(ry == 0)
						{
							new Float:x, Float:y, Float:z;
							GetDynamicObjectPos(object_id, x, y, z);
							SetPlayerLookAt(playerid, x, y);
							defer Tree_Cut[5000](playerid, object_id);
							ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 1, 0, 0, 1, 0, 1);
							pInfo[playerid][player_cutting_tree] = true;
						}
					}
				}
			}
		}
	}

	//Klawisz interakcji
	if(newkeys & KEY_YES && pInfo[playerid][player_working] < 1)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			if(pInfo[playerid][player_robbery] != -1)
			{
				new rob_obj = GetClosestObjectType(playerid, OBJECT_TYPE_ROB_CASH);
				if(rob_obj != INVALID_STREAMER_ID)
				{
					if(Object[rob_obj][object_owner] == Robbery[pInfo[playerid][player_robbery]][robbery_uid])
					{
						if(IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_GYM1))  return 1;
						DeleteObject(rob_obj, false);
						SetPlayerAttachedObject(playerid, ATTACH_SLOT_GYM1, 11745, 1, 0.103999, -0.244999, 0.0, -94.5, 171.6, -36.8);
						ApplyAnimation(playerid, "BAR", "Barserve_give", 4.0, 0, 0, 0, 0, 0, 1);
						new safe_cash = 2550+random(3250);

						Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_ROB_CASH, 11745, safe_cash, Robbery[pInfo[playerid][player_robbery]][robbery_place], "�up z napadu");
						GameTextForPlayer(playerid, sprintf("~w~Skradziono ~g~~h~~h~$%d", safe_cash), 5000, 1);
						return 1;
					}
				}
			}
			if(pInfo[playerid][player_y_flood] + 2 < gettime())
			{
				if(InteractionKey(playerid)) pInfo[playerid][player_y_flood] = gettime();
			}
			else
			{
				SendPlayerInformation(playerid, "~w~Odczekaj ~y~dwie sekundy~w~ przed ponownym uzyciem tej funkcji.", 6000);
			}
		}

		new a_id = pInfo[playerid][player_area];
		if(a_id > 0)
		{
			if(AreaHasFlag(a_id, AREA_FLAG_DRIVE))
			{
				if(!IsAnyGastroOpen())
				{
					ShowPlayerDialog(playerid, DIALOG_CBELL, DIALOG_STYLE_TABLIST_HEADERS, "Drive Thru", "Menu\tCena\nWielki zestaw\t$30\nDu�y zestaw\t$20\nMa�y zestaw\t$15\nZestaw sa�atkowy\t$21", "Wybierz", "Zamknij");
				}
			}
		}	
	}

	//Spec
	if(pInfo[playerid][player_spec] != INVALID_PLAYER_ID)
 	{
  		if(newkeys == KEY_SPRINT) // spacja id+1
	  	{
	  		new id = pInfo[playerid][player_spec];
	  		return cmd_spec(playerid, sprintf("%d", Iter_Next(Player, id)));
	  	}
	  	else if(newkeys == KEY_WALK) // lalt id-1
	  	{
	  		new id = pInfo[playerid][player_spec];
	  		return cmd_spec(playerid, sprintf("%d", Iter_Prev(Player, id)));
	  	} 
	  	else if(newkeys == KEY_JUMP) // odswiezanie jesli wejdzie do intku, wsiadzie do auta
        {
            return cmd_spec(playerid, sprintf("%d", pInfo[playerid][player_spec]));
        }
 	}

 	// Malowanie furki
	if(GetPlayerWeapon(playerid) == 41)
	{
		if(RELEASED(KEY_FIRE))
		{
			pInfo[playerid][player_can_spray] = false;
		}
	}

 	//Animacja chodzenia
	if(pInfo[playerid][player_walking_anim] && !pInfo[playerid][player_custom_edit])
	{
		if(newkeys & KEY_WALK )
		{
			if(GetPVarInt(playerid, "AnimHitPlayerGun")==1) return 1;
			ApplyAnimation(playerid, pInfo[playerid][player_walking_lib], pInfo[playerid][player_walking_name], 4.1, 1, 1, 1, 1, 1, 0);
            pInfo[playerid][player_looped_anim] = true;
		}
		else if(oldkeys & KEY_WALK)
		{
			if(GetPVarInt(playerid, "AnimHitPlayerGun")==1) return 1;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0);
			pInfo[playerid][player_looped_anim] = false;
		}
	}

	//Wy��czenie animacji
	if(newkeys & KEY_FIRE)
	{
		if(pInfo[playerid][player_looped_anim] == true)
		{
			pInfo[playerid][player_looped_anim] = false;
		}
	}

	//Victim
	if(newkeys & KEY_JUMP)
	{
	    if(pInfo[playerid][player_skin_changing])
	    {
			TogglePlayerControllable(playerid, true);
			pInfo[playerid][player_skin_changing] = false;
			GameTextForPlayer(playerid, "_", 0, 6);
			TextDrawHideForPlayer(playerid, Tutorial[playerid]);
			
			SetCameraBehindPlayer(playerid);
			SetPlayerSkin(playerid, pInfo[playerid][player_skin]);
			
			return 1;
		}

		if(pInfo[playerid][player_access_changing])
	    {
			TogglePlayerControllable(playerid, true);
			pInfo[playerid][player_access_changing] = false;
			GameTextForPlayer(playerid, "_", 0, 6);
			TextDrawHideForPlayer(playerid, Tutorial[playerid]);
			
			SetCameraBehindPlayer(playerid);
			RemovePlayerAttachedObject(playerid, ATTACH_SLOT_VICTIM);
			
			return 1;
		}
	}

    // Victim
    if(pInfo[playerid][player_skin_changing])
    {
    	if(newkeys & KEY_SECONDARY_ATTACK)
    	{
	        new skin_id = pInfo[playerid][player_skin_id];
	        if(pInfo[playerid][player_money] < ClothSkin[skin_id][skin_price])
	        {
				ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Nie sta� Ci� na zakup tego ubrania.", "OK", "");
	            return 1;
	        }
	        GivePlayerMoney(playerid, -ClothSkin[skin_id][skin_price]);
	        
	        new skin_nam[40];
	        sscanf(ClothSkin[skin_id][skin_name], "s[40]", skin_nam);
	        Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_CLOTH, 2384, ClothSkin[skin_id][skin_model], 0, skin_nam);

			SetCameraBehindPlayer(playerid);
			SetPlayerSkin(playerid, pInfo[playerid][player_skin]);
			
			TogglePlayerControllable(playerid, true);
			pInfo[playerid][player_skin_changing] = false;
			
			TextDrawHideForPlayer(playerid, Tutorial[playerid]);

	       	SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Wybrane ubranie zosta�o zakupione.\nPrzedmiot zosta� dodany do Twojego ekwipunku.");
			return 1;
		}
    }

    if(pInfo[playerid][player_access_changing])
    {
    	if(newkeys & KEY_SECONDARY_ATTACK)
    	{
	        new access_id = pInfo[playerid][player_access_id];
	        if(pInfo[playerid][player_money] < ClothAccess[access_id][access_price])
	        {
				ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Nie sta� Ci� na zakup tego ubrania.", "OK", "");
	            return 1;
	        }
	        GivePlayerMoney(playerid, -ClothAccess[access_id][access_price]);
	        
	        new access_nam[40];
	        sscanf(ClothAccess[access_id][access_name], "s[40]", access_nam);
	        Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_ATTACH, ClothAccess[access_id][access_model], ClothAccess[access_id][access_bone], 0, access_nam);

			SetCameraBehindPlayer(playerid);
			RemovePlayerAttachedObject(playerid, ATTACH_SLOT_VICTIM);
			
			TogglePlayerControllable(playerid, true);
			pInfo[playerid][player_access_changing] = false;
			
			TextDrawHideForPlayer(playerid, Tutorial[playerid]);

	       	SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Wybrany dodatek zakupiony.\nPrzedmiot zosta� dodany do Twojego ekwipunku.");
			return 1;
		}
    }

    //Silnik
	if( IsPlayerInAnyVehicle(playerid) )
	{
		new vid = GetPlayerVehicleID(playerid);
		if( !CanPlayerUseVehicle(playerid, vid) ) return 1;
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER ) return 1;

		if( PRESSED(KEY_ACTION)  )
		{
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
				if( Vehicle[vid][vehicle_state] > 0 ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Na tym poje�dzie przeprowadzana jest aktualnie jaka� akcja. Aby go odpali� poczekaj do jej uko�czenia.");
				
				if( Vehicle[vid][vehicle_destroyed] == true)
				{
					RemovePlayerFromVehicle(playerid);
					SendGuiInformation(playerid, ""guiopis"Informacja", "Ten pojazd jest ca�kowicie zniszczony, silnik nie nadaje sie do odpalenia.");
					return 1;
				}

				if( Vehicle[vid][vehicle_blocked] != 0)
				{
					ShowPlayerDialog(playerid, DIALOG_WHEELBLOCK, DIALOG_STYLE_MSGBOX, "Blokada na ko�o", sprintf("Ten pojazd posiada blokad� na ko�o.\nPow�d: %s, kwota: $%d", Vehicle[vid][vehicle_block_reason], Vehicle[vid][vehicle_blocked]), "Zap�a�", "Anuluj");
					return 1;
				}
				if( Vehicle[vid][vehicle_fuel_current] == 0.0 ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "W baku tego pojazdu nie ma paliwa.");

				if( Vehicle[vid][vehicle_health] < 400.0)
				{
					new erand = random(3);

					if(erand == 1) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Silnik nie odpali� za pierwszym razem z powodu uszkodze�.\nSpr�buj ponownie.");
				}

				Vehicle[vid][vehicle_engine_starting] = true;

				defer VehicleEngineStart[2000](playerid, vid);

				GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Uruchamianie ~y~silnika~w~...",2000,3);
			}

			return 1;
		}
		else if( PRESSED(KEY_FIRE) )
		{
			if( Vehicle[vid][vehicle_lights] )
			{
				// Gaszenie swiatel
				Vehicle[vid][vehicle_lights] = false;

				UpdateVehicleVisuals(vid);
			}
			else
			{
				// Odpalanie swiatel
				Vehicle[vid][vehicle_lights] = true;

				UpdateVehicleVisuals(vid);
			}

			return 1;
		}
	}
	else
	{
		if( PRESSED(KEY_SECONDARY_ATTACK) || PRESSED(KEY_HANDBRAKE) )
		{
			if( pInfo[playerid][player_looped_anim] == true ) 
			{
				if(GetPVarInt(playerid, "AnimHitPlayerGun")==1) return 1;
				new skin = GetClientSkin(playerid);
				SetPlayerSkin(playerid, skin);
				TogglePlayerControllable(playerid, 0);
				TogglePlayerControllable(playerid, 1);
				pInfo[playerid][player_looped_anim] = false;
			}
		}
		if( PRESSED( KEY_SPRINT | KEY_WALK ) )
		{
			new vir = GetPlayerVirtualWorld(playerid);
			new d_id = -1;
			new ds_id = -1;

			foreach(new d : Doors)
			{
				if(vir == Door[d][door_vw] && IsPlayerInRangeOfPoint(playerid, 3.0,  Door[d][door_pos][0],  Door[d][door_pos][1], Door[d][door_pos][2]))
				{
					d_id = d;
				}
				else if(vir == Door[d][door_spawn_vw] && IsPlayerInRangeOfPoint(playerid, 3.0,  Door[d][door_spawn_pos][0],  Door[d][door_spawn_pos][1], Door[d][door_spawn_pos][2]))
				{
					ds_id = d;
				}
			}

			if( ds_id != -1 )
			{
				OnPlayerExitDoor(playerid, ds_id);
				return 1;
			}
			else if( d_id != -1 )
			{
				if( Door[d_id][door_destroyed])	return SendClientMessage(playerid, COLOR_GREY, "Te drzwi s� zniszczone.");
				if( Door[d_id][door_burned])	return SendClientMessage(playerid, COLOR_GREY, "Te drzwi s� spalone.");
				if( Door[d_id][door_closed] ) return GameTextForPlayer(playerid, "~w~Drzwi ~r~zamkniete", 2500, 3);

				if( Door[d_id][door_payment] > 0 )
				{
					if( Door[d_id][door_payment] > pInfo[playerid][player_money] ) return SendClientMessage(playerid, COLOR_GREY, "Nie masz wystarczaj�cej ilo�ci got�wki, aby wej�� do budynku.");
					
					new g_uid = Door[d_id][door_owner];
					new gid = GetGroupByUid(g_uid);
					if(gid == -1 ) return SendClientMessage(playerid, COLOR_GREY, "Te drzwi nie s� podpisane pod grup�, op�ata nie mo�e by� pobierana.");
					
					if(pInfo[playerid][player_hours] >= 1)
					{
						GivePlayerMoney(playerid, -Door[d_id][door_payment]);
						GiveGroupMoney(gid, Door[d_id][door_payment]);
					}
				}

				if(Door[d_id][door_loaded]) return OnPlayerEnterDoor(playerid, d_id);
				//if(Door[d_id][door_spawn_int] > 0 && Door[d_id][door_objects_limit == 0) return OnPlayerEnterDoor(playerid, d_id);

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
					SendPlayerInformation(playerid, "Ktos inny wczytuje to wnetrze, poczekaj na zaladowanie.", 4000);
				}
				return 1;
			}
			
		}
		if( pInfo[playerid][player_creating_area] )
		{
			if( PRESSED(KEY_HANDBRAKE) )
			{
				if( pInfo[playerid][player_carea_point1][0] == 0.0 && pInfo[playerid][player_carea_point1][1] == 0.0 && pInfo[playerid][player_carea_point1][2] == 0.0 )
				{
					GetPlayerPos(playerid, pInfo[playerid][player_carea_point1][0], pInfo[playerid][player_carea_point1][1], pInfo[playerid][player_carea_point1][2]);
					
					pInfo[playerid][player_carea_label][0] = CreateDynamic3DTextLabel(sprintf("Punkt pierwszy\n(%f, %f, %f)", pInfo[playerid][player_carea_point1][0], pInfo[playerid][player_carea_point1][1], pInfo[playerid][player_carea_point1][2]), COLOR_LIGHTER_RED, pInfo[playerid][player_carea_point1][0], pInfo[playerid][player_carea_point1][1], pInfo[playerid][player_carea_point1][2], 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
					
					ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Utworzy�e� pierwszy punkt strefy.", "OK", "");
				}
				else if( pInfo[playerid][player_carea_point2][0] == 0.0 && pInfo[playerid][player_carea_point2][1] == 0.0 && pInfo[playerid][player_carea_point2][2] == 0.0 )
				{
					GetPlayerPos(playerid, pInfo[playerid][player_carea_point2][0], pInfo[playerid][player_carea_point2][1], pInfo[playerid][player_carea_point2][2]);
					
					pInfo[playerid][player_carea_label][1] = CreateDynamic3DTextLabel(sprintf("Punkt drugi\n(%f, %f, %f)", pInfo[playerid][player_carea_point2][0], pInfo[playerid][player_carea_point2][1], pInfo[playerid][player_carea_point2][2]), COLOR_LIGHTER_RED, pInfo[playerid][player_carea_point2][0], pInfo[playerid][player_carea_point2][1], pInfo[playerid][player_carea_point2][2], 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
					
					pInfo[playerid][player_carea_zone] = PlayerGangZoneCreate(playerid, Min(pInfo[playerid][player_carea_point1][0], pInfo[playerid][player_carea_point2][0]), Min(pInfo[playerid][player_carea_point1][1], pInfo[playerid][player_carea_point2][1]), Max(pInfo[playerid][player_carea_point1][0], pInfo[playerid][player_carea_point2][0]), Max(pInfo[playerid][player_carea_point1][1], pInfo[playerid][player_carea_point2][1]));
					PlayerGangZoneShow(playerid, pInfo[playerid][player_carea_zone], 0xFF3C3C80);
									
					ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Utworzy�e� drugi punkt strefy.", "OK", "");
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Punkty zaznaczone, aby usun�� ostatni wci�nij SHIFT lub wpisz ponownie /strefa stworz aby utworzy� strefe.", "OK", "");
				}
			}
			
			if( PRESSED(KEY_FIRE) )
			{
				if( pInfo[playerid][player_carea_point2][0] != 0.0 && pInfo[playerid][player_carea_point2][1] != 0.0 && pInfo[playerid][player_carea_point2][2] != 0.0 )
				{
					pInfo[playerid][player_carea_point2][0] = 0.0;
					pInfo[playerid][player_carea_point2][1] = 0.0;
					pInfo[playerid][player_carea_point2][2] = 0.0;
					
					if( IsValidDynamic3DTextLabel(pInfo[playerid][player_carea_label][1]) ) DestroyDynamic3DTextLabel(pInfo[playerid][player_carea_label][1]);
					
					PlayerGangZoneDestroy(playerid, pInfo[playerid][player_carea_zone]);

					ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Usun��e� drugi punkt strefy.", "OK", "");
				}
				else if( pInfo[playerid][player_carea_point1][0] != 0.0 && pInfo[playerid][player_carea_point1][1] != 0.0 && pInfo[playerid][player_carea_point1][2] != 0.0 )
				{
					pInfo[playerid][player_carea_point1][0] = 0.0;
					pInfo[playerid][player_carea_point1][1] = 0.0;
					pInfo[playerid][player_carea_point1][2] = 0.0;
					
					if( IsValidDynamic3DTextLabel(pInfo[playerid][player_carea_label][0]) ) DestroyDynamic3DTextLabel(pInfo[playerid][player_carea_label][0]);
					
					ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Usun��e� pierwszy punkt strefy.", "OK", "");
				}
			}
			
			/*if( PRESSED(KEY_SECONDARY_ATTACK) && pInfo[playerid][player_surface_edit] )
			{
				if(GetPlayerVirtualWorld(playerid) == 0) return 1;
				AreaCreator(playerid);
			}*/

			if( PRESSED(KEY_WALK | KEY_SPRINT) )
			{
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
				
				ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Tryb tworzenia strefy zosta� wy��czony.", "OK", "");
	
				SendPlayerInformation(playerid, "", 0);
			}
		}
	}
	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if( strfind(cmdtext, "|", true) != -1)
	{
		SendGuiInformation(playerid, "Wyst�pi� b��d", "Wykryto niedozwolone znaki.");
		return 0;
	}

	if( !pInfo[playerid][player_logged] ) return 0;

	if( pInfo[playerid][player_bw] > 0 )
	{
		if( strfind(cmdtext, "/me", true) == -1 && strcmp(cmdtext, "/admins") != 0 && strcmp(cmdtext, "/akceptujsmierc") != 0 && strcmp(cmdtext, "/as") != 0 && strcmp(cmdtext, "/a") != 0 && strfind(cmdtext, "/do", true) == -1 && strfind(cmdtext, "/w", true) == -1 && strfind(cmdtext, "/bw", true) == -1 && strfind(cmdtext, "/report", true) == -1 && strfind(cmdtext, "/b", true) == -1)
		{
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Twoja posta� jest aktualnie nieprzytomna, musisz odczeka� a� powr�ci do normalnego stanu!\nObecnie u�ywanie komend i rozmawianie masz zablokowane.\nWyj�tkiem s� komendy: /akceptujsmierc, /me, /do, /w, /p.", "OK", "");
			return 0;
		}
	}

	if( pInfo[playerid][player_aj] > 0 )
	{
		if( strcmp(cmdtext, "/admins") != 0 && strcmp(cmdtext, "/a") != 0 && strfind(cmdtext, "/w", true) == -1 && strfind(cmdtext, "/aj", true) == -1 && strfind(cmdtext, "/report", true) == -1 && strfind(cmdtext, "/b", true) == -1)
		{
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Powiadomienie", "Twoja posta� znajduje si� w admin jailu.\nU�ywanie wi�kszo�ci komend jest tutaj niedost�pne.", "OK", "");
			return 0;
		}
	}	
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	pInfo[playerid][player_commands]++;
	if( !success ) return PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
	printf("[CMD] %s - %s", pInfo[playerid][player_name], cmdtext);
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	pInfo[playerid][player_race_point] ++;
	PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
	new checkpoint = pInfo[playerid][player_race_point];

	if(!PlayerHasAchievement(playerid, ACHIEV_RACE)) AddAchievement(playerid, ACHIEV_RACE, 250);

	if(checkpoint < pInfo[playerid][player_race_checkpoints])
	{
	    SetPlayerRaceCheckpoint(playerid, 0, RaceCheckpoint[checkpoint][0], RaceCheckpoint[checkpoint][1], RaceCheckpoint[checkpoint][2], RaceCheckpoint[checkpoint + 1][0], RaceCheckpoint[checkpoint + 1][1], RaceCheckpoint[checkpoint + 1][2], 5.0);
	}
	else
	{
		SetPlayerRaceCheckpoint(playerid, 1, RaceCheckpoint[checkpoint][0], RaceCheckpoint[checkpoint][1], RaceCheckpoint[checkpoint][2], 0.0, 0.0, 0.0, 5.0);
	}

	if(checkpoint > pInfo[playerid][player_race_checkpoints])
	{
	    new string[128];
	    format(string, sizeof(string), "~w~Wyscig dobiegl konca!~n~~y~Zwyciezca jest ~g~%s", pInfo[playerid][player_name]);

		foreach(new p: Player)
	    {
	        if(pInfo[p][player_logged])
	        {
	            if(pInfo[p][player_race_phase] == 3)
	            {
	                GameTextForPlayer(p, string, 5000, 3);
	                DisablePlayerRaceCheckpoint(p);

	                pInfo[p][player_race_phase] = 0;
	                pInfo[p][player_race_point] = 0;

	                pInfo[p][player_race_checkpoints] = 0;
	            }
	        }
	    }
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(pInfo[playerid][player_panic]) DisablePlayerCheckpoint(playerid);
	if(pInfo[playerid][player_robbery] != -1)
	{
		DisablePlayerCheckpoint(playerid);
		SendPlayerInformation(playerid, "Obezwladnij ~y~zakladnikow~w~, a nastepnie uzyj ~y~przedmiotow~w~, ktore przygotowales do napadu aby okrasc sejfy/kasy.~n~~n~Sejf zazwyczaj jest ukryty za pancernymi drzwiami, do ich otwarcia potrzebna jest bomba lub elektronika.~n~~n~Uwazaj na uzbrojonych straznikow!", 35000);
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(checkpointid == pInfo[playerid][player_smuggle_cp])
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

		TextDrawSetString(Tutorial[playerid], "Przesylka zostanie zrzucona z samolotu lada moment.~n~Patrz ~y~w gore~w~ aby wiedziec gdzie spadnie.");
		TextDrawShowForPlayer(playerid, Tutorial[playerid]);

		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		defer DropCocaine[7000](x+2, y+5, z);

		if(IsValidDynamicCP(pInfo[playerid][player_smuggle_cp])) DestroyDynamicCP(pInfo[playerid][player_smuggle_cp]);
		return 1;
	}

	if(checkpointid == pInfo[playerid][player_checkpoint])
	{
	    if(pInfo[playerid][player_carry] != WORK_TYPE_TRASHMAN) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz worka z odpadami.");
	 
	    new vehicleid = pInfo[playerid][player_last_veh];
	    if(Vehicle[vehicleid][vehicle_trash] >= 10) return SendGuiInformation(playerid, "Informacja", "Ten pojazd jest ju� pe�ny. Udaj sie do sk�adowiska.");

	    Vehicle[vehicleid][vehicle_trash]++;
		ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0);
		
		if(10 - Vehicle[vehicleid][vehicle_trash] > 0)
		{
			new string[256];
			format(string, sizeof(string), "Za�adowano worek o warto�ci $6 do �mieciarki. Roz�aduj si� na wysypisku aby pobra� pieni�dze.\nMo�esz za�adowa� jeszcze %d work�w do tego pojazdu.", 10 - Vehicle[vehicleid][vehicle_trash]);
			SendGuiInformation(playerid, "Informacja", string);
		}
		else
		{
			SendGuiInformation(playerid, "Informacja", "Za�adowano worek o warto�ci $6 do �mieciarki. Roz�aduj si� na wysypisku aby pobra� pieni�dze.");
		}
		
		if(IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_GYM1)) RemovePlayerAttachedObject(playerid, ATTACH_SLOT_GYM1);
		if(IsValidDynamicCP(pInfo[playerid][player_checkpoint])) DestroyDynamicCP(pInfo[playerid][player_checkpoint]);
		pInfo[playerid][player_carry] = 0;
		return 1;
	}

    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		for(new i; i < sizeof(FactoryData); i++)
		{
		    if(checkpointid == FactoryData[i][FactoryCP])
		    {
		    	new vehicleid = GetPlayerVehicleID(playerid);

		    	new cash = 6 * Vehicle[vehicleid][vehicle_trash];
				pInfo[playerid][player_job_cash] += cash;

		        new string[128];
		        format(string, sizeof(string), "Dodano $%d do zarobk�w z pracy dorywczej. Wyp�ate mo�esz odebra� w banku. Obecny stan: $%d/$350", cash, pInfo[playerid][player_job_cash]);  
		        SendClientMessage(playerid, COLOR_GOLD, string);

		        FactoryData[i][FactoryCurrent] += Vehicle[vehicleid][vehicle_trash];
		        Vehicle[vehicleid][vehicle_trash] = 0;
                format(string, sizeof(string), "Sk�adowisko odpad�w - %s\n\n{FFFFFF}Ilo�� odpad�w: {F39C12}%d", FactoryData[i][FactoryName], FactoryData[i][FactoryCurrent]);
                UpdateDynamic3DTextLabelText(FactoryData[i][FactoryLabel], COLOR_GOLD, string);
                
		        for(new x; x < sizeof(FactoryData); x++)
				{
				    if(IsValidDynamicMapIcon(FactoryIcons[playerid][x]))
				    {
				        DestroyDynamicMapIcon(FactoryIcons[playerid][x]);
				        FactoryIcons[playerid][x] = -1;
				    }

					TogglePlayerDynamicCP(playerid, FactoryData[x][FactoryCP], 0);
				}

		        break;
		    }
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(pGlobal[playerid][glo_score] < 50)
	{
		if(GetVehicleDriver(vehicleid) == INVALID_PLAYER_ID)
		{
			ClearAnimations(playerid);
			SendGuiInformation(playerid, "Informacja", "Poni�ej godziny online mo�esz wsiada� tylko do pojazd�w w kt�rych jest kierowca.");
			return 1;
		}
	}

	if(GetPVarInt(playerid, "AnimHitPlayerGun") == 1 )
	{
		pInfo[playerid][player_looped_anim] = true;
		GameTextForPlayer(playerid, "~r~Postac jest postrzelona~n~Wchodzenie do pojazdow zabronione.", 2000, 3);
		SetPVarInt(playerid, "AnimHitPlayerGun", 1);
		ApplyAnimation(playerid, "PED", "KO_shot_face", 4.1,0,0,0,1,0);
		return 1;
	}

	if( Vehicle[vehicleid][vehicle_locked] )
	{
		ClearAnimations(playerid, 1);
		GameTextForPlayer(playerid, "~w~Pojazd jest ~r~zamkniety", 2500, 3);
		return 1;
	}

	if(pInfo[playerid][player_vehicle_target] == vehicleid)
	{
		Streamer_RemoveArrayData(STREAMER_TYPE_MAP_ICON, Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_map_icon], E_STREAMER_PLAYER_ID, playerid);			
		Streamer_UpdateEx(playerid, Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][0], Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][1], Vehicle[pInfo[playerid][player_vehicle_target]][vehicle_last_pos][2]);
	}

	/*if(pInfo[playerid][player_job] == WORK_TYPE_TRUCKER)
	{
		if( Vehicle[vehicleid][vehicle_model] == 403)
		{
			SendPlayerInformation(playerid, "~w~Doczep przyczepe do ciezarowki i wpisz /truck.", 6000);
		}
	}*/

	if( Vehicle[vehicleid][vehicle_destroyed] && !ispassenger )
	{
		ClearAnimations(playerid, 1);
		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Pojazd ca�kowicie zniszczony", "Tw�j pojazd jest ca�kowicie zniszczony.\nAby zaakceptowa� ofert� naprawy b�dziesz musia� siedzie� w �rodku jako pasa�er.", "Zamknij", "");	
		return 1;
	}

	pInfo[playerid][player_entering_vehicle] = vehicleid;
	
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    StopAudioStreamForPlayer(playerid);
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if( (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) && (oldstate != PLAYER_STATE_DRIVER && oldstate != PLAYER_STATE_PASSENGER) )
	{
		if( pInfo[playerid][player_entering_vehicle] != GetPlayerVehicleID(playerid) )
		{
			KickAc(playerid, -1, "Nieautoryzowane wejscie");
		}
		else
		{
			pInfo[playerid][player_entering_vehicle] = -1;
			
			new vid = GetPlayerVehicleID(playerid);
			pInfo[playerid][player_occupied_vehicle] = vid;
			Vehicle[vid][vehicle_occupants] += 1;
			Vehicle[vid][vehicle_last_used] = gettime();
			pInfo[playerid][player_parachute] = 1;
			pInfo[playerid][player_last_veh] = vid;

			// Wylaczamy namierzanie
			if( pInfo[playerid][player_vehicle_target] == vid )
			{
				Streamer_RemoveArrayData(STREAMER_TYPE_MAP_ICON, Vehicle[vid][vehicle_map_icon], E_STREAMER_PLAYER_ID, playerid);
				Streamer_UpdateEx(playerid, Vehicle[vid][vehicle_last_pos][0], Vehicle[vid][vehicle_last_pos][1], Vehicle[vid][vehicle_last_pos][2]);

				pInfo[playerid][player_vehicle_target] = -1;
				SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Namierzanie pojazdu zosta�o wy��czone.");
			}
			
			// Uruchamiamy stream
            if(Vehicle[vid][vehicle_streaming] == 1)
		    {
		    	PlayAudioStreamForPlayer(playerid, Vehicle[vid][vehicle_stream]);
		    }

		    if( newstate == PLAYER_STATE_PASSENGER)
		    {
		    	if(GetPlayerWeapon(playerid) == 24 ) SetPlayerArmedWeapon(playerid, 0);
		    }
		    
			if( newstate == PLAYER_STATE_DRIVER )
			{
				//Anty DB z kierowcy
				if(GetPlayerWeapon(playerid) == 28 || GetPlayerWeapon(playerid) == 29 || GetPlayerWeapon(playerid) == 32 )
				{
					SetPlayerArmedWeapon(playerid, 0);
				}

				//Sprawdzamy czy nie ma blokady
				if(pGlobal[playerid][glo_block] & BLOCK_VEH)
			    {
		    		ClearAnimations(playerid);
		    		SendGuiInformation(playerid, "Informacja", "Posiadasz aktywn� blokad� prowadzenia pojazd�w.");
		    		return 1;
			    }

				// Sprawdzamy czy ma uprawnienia
				if( Vehicle[vid][vehicle_owner_type] == VEHICLE_OWNER_TYPE_GROUP && !CanPlayerUseVehicle(playerid, vid))
				{
					SendGuiInformation(playerid, ""guiopis"", "Nie posiadasz uprawnie� do prowadzenia tego pojazdu.");
					ClearAnimations(playerid);
					return 1;	
				}

				if(Vehicle[vid][vehicle_owner_type] == VEHICLE_OWNER_TYPE_GROUP)
				{
					new fuel = floatround(Vehicle[vid][vehicle_fuel_current]);
					logprintf(LOG_VEHICLE, "[ENTER %d] [GROUP %d], player: %s, current hp: %0.2f, fuel: %d", Vehicle[vid][vehicle_uid], Vehicle[vid][vehicle_owner], pInfo[playerid][player_name], Vehicle[vid][vehicle_health], fuel);
				}

				// Ustawiamy kierowce
				Vehicle[vid][vehicle_driver] = playerid;

				// Rowerki
				new model = GetVehicleModel(vid);
		  		if(model == 509 || model == 510 || model == 481) return 1;

				// Sprawdzamy czy silnik nie jest juz czasem odpalony
				if( !Vehicle[vid][vehicle_engine] && CanPlayerUseVehicle(playerid, vid) ) TextDrawShowForPlayer(playerid, vehicleInfo);

				//Praca �mieciarki
				if(model == 408 && Vehicle[vid][vehicle_owner_type] == VEHICLE_OWNER_TYPE_JOB)
				{
					if(pInfo[playerid][player_job] == WORK_TYPE_TRASHMAN)
					{
						if(pInfo[playerid][player_job_cash] >= 350)
						{
							SendGuiInformation(playerid, "Informacja", "Wyczerpa�e� dzienny limit zarobk�w z pracy dorywczej ($350).\nZapraszamy ponownie jutro.");
							RemovePlayerFromVehicle(playerid);
							return 1;
						}

						TextDrawSetString(Tutorial[playerid], "~y~Y~w~ - podnoszenie smieci~n~~y~Wejscie w checkpoint~w~ - zaladowanie~n~~y~Wjazd w checkpoint~w~ - rozladowanie smieciarki");
						TextDrawShowForPlayer(playerid, Tutorial[playerid]);

					    if(Vehicle[vid][vehicle_trash] > 0) 
					    {
					        new stringy[128];
					        format(stringy, sizeof(stringy), "Ten pojazd posiada {F39C12}%d {FCAD43}work�w z odpadami o warto�ci {2ECC71}$%d.", Vehicle[vid][vehicle_trash], Vehicle[vid][vehicle_trash]*6);
							SendClientMessage(playerid, COLOR_GOLD, stringy);
							SendClientMessage(playerid, COLOR_GOLD, "Mo�esz je sprzeda� na sk�adowiskach odpad�w, kt�re zaznaczono na mapie ikon� ci�ar�wki.");

							for(new i; i < sizeof(FactoryData); i++)
							{
							    FactoryIcons[playerid][i] = CreateDynamicMapIcon(FactoryData[i][FactoryX], FactoryData[i][FactoryY], FactoryData[i][FactoryZ], 51, 0, _, _, playerid, 8000.0, MAPICON_GLOBAL);
								TogglePlayerDynamicCP(playerid, FactoryData[i][FactoryCP], 1);
							}
					    }
					    else
					    {
					        SendClientMessage(playerid, COLOR_GOLD, "Zbieraj odpady ze �mietnik�w znalezionych na trasie. S� one oznaczone tekstem 3d.");
					    }

					    pInfo[playerid][player_working] = WORK_TYPE_TRASHMAN;
					}
					else
					{
						RemovePlayerFromVehicle(playerid);
						SendGuiInformation(playerid, "Informacja", "Nie jeste� kierowc� �mieciarki.\nAby zmieni� swoj� prac� dorywcz� udaj si� pod City Hall na Pershing Square.");
					}
				}
			}
		}
	}
	if( oldstate == PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_DRIVER )
	{
		new vid = GetPlayerVehicleID(playerid);
		if(Vehicle[vid][vehicle_owner_type] == VEHICLE_OWNER_TYPE_GROUP)
		{
			new fuel = floatround(Vehicle[vid][vehicle_fuel_current]);
			logprintf(LOG_VEHICLE, "[EXIT %d] [GROUP %d], player: %s, current hp: %0.2f, fuel: %d", Vehicle[vid][vehicle_uid], Vehicle[vid][vehicle_owner], pInfo[playerid][player_name], Vehicle[vid][vehicle_health], fuel);
		}
		
		TextDrawHideForPlayer(playerid, vehicleInfo);
        StopAudioStreamForPlayer(playerid);

        for(new i; i < sizeof(FactoryData); i++)
		{
		    if(IsValidDynamicMapIcon(FactoryIcons[playerid][i]))
		    {
		        DestroyDynamicMapIcon(FactoryIcons[playerid][i]);
		        FactoryIcons[playerid][i] = -1;
		    }

			TogglePlayerDynamicCP(playerid, FactoryData[i][FactoryCP], 0);
		}
	}

	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
		// Je�li kierowca taks�wki wysi�dzie
		if(pInfo[playerid][player_taxi_passenger] != INVALID_PLAYER_ID)
		{
			new passenger_id = pInfo[playerid][player_taxi_passenger], price = pInfo[passenger_id][player_taxi_pay];

			if(price > 0)
			{
				price = price > pInfo[playerid][player_money] ? pInfo[playerid][player_money] : price;

				GivePlayerMoney(passenger_id, -price);

				new gid = pInfo[playerid][player_duty_gid];
				if(gid != -1)
				{
					if(price >= 20)
					{
						GiveGroupMoney(gid, price-10);
						GivePlayerMoney(playerid, 10);
					}
					else
					{
						GiveGroupMoney(gid, price);
					}
				}

				ShowPlayerDialog(passenger_id, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Informacja", sprintf("Zap�aci�e� $%d za przejazd taks�wk�.", price), "OK", "");
			}

			pInfo[playerid][player_taxi_passenger] = INVALID_PLAYER_ID;

			pInfo[passenger_id][player_taxi_veh] = INVALID_VEHICLE_ID;
			pInfo[passenger_id][player_taxi_pay] = 0;
			pInfo[passenger_id][player_taxi_price] = 0;
		}
	}

	if(oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_ONFOOT)
	{
		if(pInfo[playerid][player_taxi_veh] != INVALID_VEHICLE_ID)
		{
			new driver = GetVehicleDriver(pInfo[playerid][player_taxi_veh]), price = pInfo[playerid][player_taxi_pay];
			if(driver != INVALID_PLAYER_ID)
			{
				price = price > pInfo[playerid][player_money] ? pInfo[playerid][player_money] : price;

				if(price > 0)
				{
					GivePlayerMoney(playerid, -price);
					new gid = pInfo[driver][player_duty_gid];
					if(gid != -1)
					{
						if(price >= 20)
						{
							GiveGroupMoney(gid, price-10);
							GivePlayerMoney(driver, 10);
						}
						else
						{
							GiveGroupMoney(gid, price);
						}

						SendGuiInformation(playerid, "Informacja", sprintf("Zap�aci�e� %d za przejazd taks�wk�.", price));

						pInfo[driver][player_taxi_passenger] = INVALID_PLAYER_ID;

						pInfo[playerid][player_taxi_veh] = INVALID_VEHICLE_ID;
						pInfo[playerid][player_taxi_pay] = 0;
						pInfo[playerid][player_taxi_price] = 0;
		 			}
				}
			}
		}
	}

	if( newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		if(pInfo[playerid][player_hours] < 1 && pInfo[playerid][player_duty_gid] == -1)
		{
			new vid = GetPlayerVehicleID(playerid);
			if(GetVehicleDriver(vid) == INVALID_PLAYER_ID || GetVehicleDriver(vid) == playerid)
			{
				new Float:x, Float:y, Float:z;
				GetVehiclePos(vid, x, y, z);
				SetPlayerPos(playerid, x, y, z+2.5);
				//KickAc(playerid, -1, "Nieautoryzowane wejscie (force, 0h)");
			}
		}
	}
	
	if( (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) && newstate != PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_PASSENGER )
	{
		if(pInfo[playerid][player_occupied_vehicle] != -1)
		{
			Vehicle[pInfo[playerid][player_occupied_vehicle]][vehicle_occupants] -= 1;
		}

		pInfo[playerid][player_occupied_vehicle] = -1;

		StopAudioStreamForPlayer(playerid);

		if( pInfo[playerid][player_belt] )
		{
			RemovePlayerStatus(playerid, PLAYER_STATUS_BELT);
			pInfo[playerid][player_belt] = false;
			
			SendPlayerInformation(playerid, "~w~Wyszedles z auta nie odpinajac ~r~pasow~w~. Musisz odczekac 2 sekundy.", 3000);
			TogglePlayerControllable(playerid, 0);
			pInfo[playerid][player_freeze] = 2;
		}
	}
	
	return 1;
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z)
{
	/*if(GetVehicleDistanceFromPoint(vehicleid, Vehicle[vehicleid][vehicle_last_pos][0], Vehicle[vehicleid][vehicle_last_pos][1], Vehicle[vehicleid][vehicle_last_pos][2]) < 20)
	{
		if(GetVehicleDistanceFromPoint(vehicleid, Vehicle[vehicleid][vehicle_last_pos][0], Vehicle[vehicleid][vehicle_last_pos][1], Vehicle[vehicleid][vehicle_last_pos][2]) > 5)
		{
	    	SetVehiclePos(vehicleid, Vehicle[vehicleid][vehicle_last_pos][0], Vehicle[vehicleid][vehicle_last_pos][1], Vehicle[vehicleid][vehicle_last_pos][2]);
	    }
	}*/

	if(GetTickDiff(GetTickCount(), pInfo[playerid][player_gta_tick]) > 1000)
	{
		pInfo[playerid][player_gta_tick] = GetTickCount();
		OnPlayerUpdateVehicle(playerid, vehicleid);
	}
    return 0;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
    return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
    return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
    switch(componentid)
    {
        case 1008..1010: 
        {
        	if(IsPlayerInInvalidNosVehicle(playerid))
        	{
        		RemoveVehicleComponent(vehicleid, componentid);
        		BanAc(playerid, -1, 14, sprintf("Invalid NOS (compid:%d, vid: %d)", componentid, vehicleid));
        	}
        }
    }
    if(!IsComponentidCompatible(GetVehicleModel(vehicleid), componentid))
    {
    	RemoveVehicleComponent(vehicleid, componentid);
    	BanAc(playerid, -1, 14, sprintf("Invalid component (compid:%d, vid: %d)", componentid, vehicleid));
    }

    BanAc(playerid, -1, 14, "Force mod shop tune");
    return 0;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    BanAc(playerid, -1, 14, "Force paintjob");
    DeleteVehicle(vehicleid, false);
    return 0;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	BanAc(playerid, -1, 14, "Force color change");
    DeleteVehicle(vehicleid, false);
    return 0;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{	
	new Float:carhp;
	GetVehicleHealth(vehicleid, carhp);

	if(Vehicle[vehicleid][vehicle_owner_type] == VEHICLE_OWNER_TYPE_GROUP)
	{
		logprintf(LOG_VEHICLE, "[DAMAGE %d] [GROUP %d], player: %s, current hp: %0.2f", Vehicle[vehicleid][vehicle_uid], Vehicle[vehicleid][vehicle_owner], pInfo[playerid][player_name], carhp);
	}

	Vehicle[vehicleid][vehicle_damaged] = true;

	if(carhp > 900.0)
	{
		Vehicle[vehicleid][vehicle_damage][0] = 0;
		Vehicle[vehicleid][vehicle_damage][1] = 0;
		Vehicle[vehicleid][vehicle_damage][2] = 0;
		Vehicle[vehicleid][vehicle_damage][3] = 0;
		UpdateVehicleDamageStatus(vehicleid, Vehicle[vehicleid][vehicle_damage][0], Vehicle[vehicleid][vehicle_damage][1], Vehicle[vehicleid][vehicle_damage][2], Vehicle[vehicleid][vehicle_damage][3]);
	}

    return 1;
}

public OnVehicleSpawn(vehicleid)
{
	for(new i; i < 10; i++)
	{
	    if(IsValidDynamicObject(Vehicle[vehicleid][vehicle_log_object][i]))
	    {
	    	DestroyDynamicObject(Vehicle[vehicleid][vehicle_log_object][i]);
	        Vehicle[vehicleid][vehicle_log_object][i] = INVALID_STREAMER_ID;
	    }
	}

	if(Vehicle[vehicleid][vehicle_owner_type] == VEHICLE_OWNER_TYPE_JOB)
	{
		SetVehicleHealth(vehicleid, 1000.0);
		Vehicle[vehicleid][vehicle_damage][0] = 0;
		Vehicle[vehicleid][vehicle_damage][1] = 0;
		Vehicle[vehicleid][vehicle_damage][2] = 0;
		Vehicle[vehicleid][vehicle_damage][3] = 0;
		Vehicle[vehicleid][vehicle_fuel_current] = 40.0;
		RepairVehicle(vehicleid);
		SaveVehicle(vehicleid);

		LoadVehicle(sprintf("WHERE `vehicle_uid` = %d", Vehicle[vehicleid][vehicle_uid]), true);
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	if(killerid != INVALID_PLAYER_ID)
	{
		logprintf(LOG_VEHICLE, "[DAMAGE %d] [GROUP %d], player: %s, TOTAL DESTROYED.", Vehicle[vehicleid][vehicle_uid], Vehicle[vehicleid][vehicle_owner], pInfo[killerid][player_name]);
	}

	if(Vehicle[vehicleid][vehicle_damaged] == false && Vehicle[vehicleid][vehicle_occupants] == 0 && Vehicle[vehicleid][vehicle_last_used] == 0)
	{
		if(killerid != INVALID_PLAYER_ID)
		{
			//KickAc(killerid, -1, "Vehicle killer");
			Vehicle[vehicleid][vehicle_health] = 1500.0;
			SetVehicleHealth(vehicleid, 1500);
			return 1;
		}
	}

	for(new i; i < 10; i++)
	{
	    if(IsValidDynamicObject(Vehicle[vehicleid][vehicle_log_object][i]))
	    {
	    	DestroyDynamicObject(Vehicle[vehicleid][vehicle_log_object][i]);
	        Vehicle[vehicleid][vehicle_log_object][i] = INVALID_STREAMER_ID;
	    }
	}

	/*GetVehiclePos(vehicleid, Vehicle[vehicleid][vehicle_park][0], Vehicle[vehicleid][vehicle_park][1], Vehicle[vehicleid][vehicle_park][2]);
	GetVehicleZAngle(vehicleid, Vehicle[vehicleid][vehicle_park][3]);
	Vehicle[vehicleid][vehicle_park_world] = GetVehicleVirtualWorld(vehicleid);
	Vehicle[vehicleid][vehicle_park_interior] = Vehicle[vehicleid][vehicle_interior];
					
	mysql_query(mySQLconnection, sprintf("UPDATE `ipb_vehicles` SET `vehicle_posx` = %f, `vehicle_posy` = %f, `vehicle_posz` = %f, `vehicle_posa` = %f, `vehicle_world` = %d, `vehicle_interior` = %d WHERE `vehicle_uid` = %d", Vehicle[vid][vehicle_park][0], Vehicle[vid][vehicle_park][1], Vehicle[vid][vehicle_park][2], Vehicle[vid][vehicle_park][3], Vehicle[vid][vehicle_park_world], Vehicle[vid][vehicle_park_interior], Vehicle[vid][vehicle_uid]));

	new v_uid = Vehicle[vehicleid][vehicle_uid];

	LoadVehicle(sprintf("WHERE `vehicle_uid` = %d", v_uid), true);*/

	Vehicle[vehicleid][vehicle_destroyed] = true;
	DeleteVehicle(vehicleid, false);
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    return 1;
}

public OnPlayerSpawn(playerid)
{
	if( IsPlayerNPC(playerid) )
	{
		return 1;
	}
	
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	Update3DTextLabelText(pInfo[playerid][player_description_label], LABEL_DESCRIPTION, "");

	pInfo[playerid][player_spawned] = 1;
	pInfo[playerid][player_bomb_car] = INVALID_VEHICLE_ID;
	pInfo[playerid][player_repair_car] = INVALID_VEHICLE_ID;
	pInfo[playerid][player_montage_car] = INVALID_VEHICLE_ID;

	//SetPlayerTeam(playerid, 10);

	defer PreloadAllAnimLibs[2000](playerid);
	
	// BW
	if( pInfo[playerid][player_bw] > 0 )
	{
		TogglePlayerControllable(playerid, 0);

		SetPlayerHealth(playerid, 20);
		
		SetPlayerVirtualWorld(playerid, pInfo[playerid][player_quit_vw]);
		SetPlayerInterior(playerid, pInfo[playerid][player_quit_int]);

		SetPlayerCameraPos(playerid, pInfo[playerid][player_quit_pos][0], pInfo[playerid][player_quit_pos][1], pInfo[playerid][player_quit_pos][2] + 6.0);
		SetPlayerCameraLookAt(playerid, pInfo[playerid][player_quit_pos][0], pInfo[playerid][player_quit_pos][1], pInfo[playerid][player_quit_pos][2]);
		
		TogglePlayerControllable(playerid, 0);

		SetPlayerSkin(playerid, pInfo[playerid][player_last_skin]);
		SetPlayerPos(playerid, pInfo[playerid][player_quit_pos][0],  pInfo[playerid][player_quit_pos][1],  pInfo[playerid][player_quit_pos][2]);

		defer ApplyAnim[2000](playerid, ANIM_TYPE_BW, 0);
		
		UpdatePlayerBWTextdraw(playerid);
	}
	else
	{
		new health = floatround(pInfo[playerid][player_health]);
		if( health == 0 ) health = 5;
		SetPlayerHealth(playerid, health);
		FreezePlayer(playerid, 3000);
	}

	if(pInfo[playerid][player_aj] > 0)
	{
		RP_PLUS_SetPlayerPos(playerid, 154.0880,-1951.6383,47.8750);
		SetPlayerVirtualWorld(playerid, pInfo[playerid][player_id]);
	}

	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(IsPlayerNPC(playerid))
	{
		return 1;
	}

	if(pInfo[playerid][player_bus_stop])
	{
		return 1;
	}

	if(Area[areaid][area_uid] == 572)
	{
		new hour, minute, temp;
		gettime(hour, minute, temp);

		if(hour == 21 && minute > 36) PlayAudioStreamForPlayer(playerid, "https://san-andreas.pl/uploads/music/barka.mp3", 2233.9849, -1333.3167, 23.9816, 20.0, 1);
	}

	if(Area[areaid][area_type] == AREA_TYPE_BOOMBOX)
	{
		if( strcmp(Area[areaid][area_audio], "-", true) )
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			Streamer_GetFloatData(STREAMER_TYPE_AREA, areaid, E_STREAMER_X, x);
			Streamer_GetFloatData(STREAMER_TYPE_AREA, areaid, E_STREAMER_Y, y);
			PlayAudioStreamForPlayer(playerid, Area[areaid][area_audio], x, y, z, 8.0, 1);
			return 1;
		}
	}

	pInfo[playerid][player_area] = areaid;

	if(AreaHasFlag(areaid, AREA_FLAG_LS))
	{
		new vid = GetPlayerVehicleID(playerid);
		if(vid != INVALID_VEHICLE_ID)
		{
			if(Vehicle[vid][vehicle_owner_type] == VEHICLE_OWNER_TYPE_JOB && (Vehicle[vid][vehicle_owner] == WORK_TYPE_FORKLIFT || Vehicle[vid][vehicle_owner] == WORK_TYPE_LUMBERJACK) )
			{
				CarUnspawn(playerid, vid, -1, "Job vehicle abuse");
			}
		}
	}

	if(AreaHasFlag(areaid, AREA_FLAG_SERWIS))
	{
		/*if(!IsAnyWorkshopOpen())
		{
			SendPlayerInformation(playerid, "~w~Aby wykonac interakcje ze strefa wcisnij klawisz ~y~Y~w~.", 4000);
		}*/
	}

	if(AreaHasFlag(areaid, AREA_FLAG_DRIVE))
	{
		if(!IsAnyGastroOpen())
		{
			SendPlayerInformation(playerid, "~w~Aby wykonac interakcje ze strefa wcisnij klawisz ~y~Y~w~.", 4000);
		}
		else
		{
			SendPlayerInformation(playerid, "~w~Drive thru niedostepne. Sa czynne lokale ~y~gastronomii~w~.", 4000);
		}
	}
	
	if(AreaHasFlag(areaid, AREA_FLAG_WORK))
	{
		if(pInfo[playerid][player_job] == WORK_TYPE_LUMBERJACK)
		{
			pInfo[playerid][player_working] = WORK_TYPE_LUMBERJACK;
			TextDrawSetString(Tutorial[playerid], "~y~Y~w~ - przenoszenie drewna~n~~y~LPM~w~ - ciecie drzewa~n~~y~Y~w~ - sprzedaz u bota");
			TextDrawShowForPlayer(playerid, Tutorial[playerid]);
		}
	}

	if(AreaHasFlag(areaid, AREA_FLAG_WORK_FORKLIFT))
	{
		if(pInfo[playerid][player_job] == WORK_TYPE_FORKLIFT)
		{
			pInfo[playerid][player_working] = WORK_TYPE_FORKLIFT;
			TextDrawSetString(Tutorial[playerid], "Klawisz ~y~Y~w~ - podnoszenie/opuszczanie ladunku~n~~n~Laduj pudla znalezione w kontenerach na statku i zawoz je do naczep ciezarowek.");
			TextDrawShowForPlayer(playerid, Tutorial[playerid]);
		}
	}

	if(AreaHasFlag(areaid, AREA_FLAG_WORK_FISH))
	{
		if(pInfo[playerid][player_job] == WORK_TYPE_FISHER)
		{
			pInfo[playerid][player_working] = WORK_TYPE_FISHER;
			TextDrawSetString(Tutorial[playerid], "~y~Y~w~ - przenoszenie ryb~n~~y~LPM~w~ - polow ryb~n~~y~Y~w~ - sprzedaz u bota~n~~n~Aby rozpoczac polow musisz znajdowac sie w kutrze na wodzie.");
			TextDrawShowForPlayer(playerid, Tutorial[playerid]);
		}
	}

	switch( Area[areaid][area_type] )
	{
		case AREA_TYPE_NORMAL:
		{
			pInfo[playerid][player_polygon] = areaid;
			if( strcmp(Area[areaid][area_audio], "-", true) )
			{
				PlayAudioStreamForPlayer(playerid, Area[areaid][area_audio]);
			}
		}

		case AREA_TYPE_GUARD_NPC:
		{
			new npcid = GetNPCByArea(areaid);
			if(npcid != -1)
			{
				if(NPC[npcid][npc_aimed] != playerid)
				{
					FCNPC_AimAtPlayer(npcid, playerid, .shoot = true);
					NPC[npcid][npc_aimed] = playerid;
				}
			}
		}

		case AREA_TYPE_FIRE:
		{
			if( IsPlayerInAnyGroup(playerid) )
			{
				new gid = pInfo[playerid][player_duty_gid];
				if(gid == -1) return 1;

				if( Group[gid][group_flags] & GROUP_FLAG_MEDIC)
				{
					SetPVarInt(playerid, "fire", areaid);
				}
			}
		}

		case AREA_TYPE_ARMDEALER:
		{
			ApplyDynamicActorAnimation(ArmDealer, "DEALER", "DEALER_IDLE_01", 4.1, 0, 0, 0, 1, 0);

			if(IsPlayerCop(playerid))
			{
				ActorProx(ArmDealer, "Marcus Bradford", "Nie b�d� z tob� rozmawia�.", PROX_LOCAL);
				return 1;
			}
			else
			{
				new gid = pInfo[playerid][player_duty_gid];
				if(gid == -1)
				{
					if(PlayerHasFlag(playerid, PLAYER_FLAG_ORDER) )
					{
						new loss = random(3);
						switch(loss)
						{
							case 0:
							{
								ActorProx(ArmDealer, "Marcus Bradford", "Zajrzyj do samochodu, mo�e co� Cie zainteresuje.", PROX_LOCAL);
							}
							case 1:
							{
								ActorProx(ArmDealer, "Marcus Bradford", "Za�atwmy to szybko, nie mam ca�ego dnia.", PROX_LOCAL);
							}
							case 2:
							{
								ActorProx(ArmDealer, "Marcus Bradford", "Torba le�y na tylnym siedzeniu.", PROX_LOCAL);
							}
						}

						new string[1024], count;
		                DynamicGui_Init(playerid);

		                format(string, sizeof(string), "%sProdukt\tCena\tLimit\n", string);

		                foreach (new prod: Products)
		                {
		                    if( Product[prod][product_player] != pInfo[playerid][player_id] ) continue;

		                    format(string, sizeof(string), "%s %s\t$%d\t%d/%d \n", string, Product[prod][product_name], Product[prod][product_price], Product[prod][product_limit_used], Product[prod][product_limit]);
		                    DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
		                    count++;
		                }
		                if( count == 0 ) SendGuiInformation(playerid, "Informacja", "Ten bot nie posiada dodanych produkt�w dla twojej postaci.");
		                else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ILLEGAL_ADD, DIALOG_STYLE_TABLIST_HEADERS, "Marcus Bradford - oferta", string, "Kup", "Wyjd�");
					}

					return 1;
				}
				
				if(GroupHasFlag(gid, GROUP_FLAG_BOT) )
				{
					new slot = GetPlayerDutySlot(playerid);
					if(slot == -1) return 1;
					if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_ORDER) ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnie� do zamawiania.");
					
					new loss = random(3);

					switch(loss)
					{
						case 0:
						{
							ActorProx(ArmDealer, "Marcus Bradford", "Zajrzyj do samochodu, mo�e co� Cie zainteresuje.", PROX_LOCAL);
						}
						case 1:
						{
							ActorProx(ArmDealer, "Marcus Bradford", "Za�atwmy to szybko, nie mam ca�ego dnia.", PROX_LOCAL);
						}
						case 2:
						{
							ActorProx(ArmDealer, "Marcus Bradford", "Torba le�y na tylnym siedzeniu.", PROX_LOCAL);
						}
					}
					new string[1024], count;
	                DynamicGui_Init(playerid);

	                format(string, sizeof(string), "%sProdukt\tCena\tLimit tygodniowy\n", string);

	                foreach (new prod: Products)
	                {
	                    if( Product[prod][product_group] != Group[gid][group_uid] ) continue;

	                    format(string, sizeof(string), "%s %s\t$%d\t%d/%d \n", string, Product[prod][product_name], Product[prod][product_price], Product[prod][product_limit_used], Product[prod][product_limit]);
	                    DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                    count++;
	                }
	                if( count == 0 ) SendGuiInformation(playerid, "Informacja", "Ten bot nie posiada dodanych produkt�w.");
	                else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ILLEGAL_ADD, DIALOG_STYLE_TABLIST_HEADERS, "Marcus Bradford - oferta", string, "Kup", "Wyjd�");
				}
			}
		}
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(IsPlayerNPC(playerid)) return 1;

	if(pInfo[playerid][player_bus_stop]) return 1;

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	new ar_id[5];
	GetDynamicAreasForPoint(x, y, z, ar_id);
	
	pInfo[playerid][player_area] = ar_id[0];

	if(pInfo[playerid][player_dealing])
	{
		SendPlayerInformation(playerid, "Opusciles strefe ~y~handlu~w~, zakonczono poszukiwanie klientow.", 5000);
		RemovePlayerStatus(playerid, PLAYER_STATUS_DEALING);
		TextDrawHideForPlayer(playerid, Tutorial[playerid]);
		pInfo[playerid][player_dealing] = false;
		pInfo[playerid][player_dialog_tmp5] = -1;
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

	if(AreaHasFlag(areaid, AREA_FLAG_WORK) || AreaHasFlag(areaid, AREA_FLAG_WORK_FISH))
	{
		pInfo[playerid][player_working] = 0;
		TextDrawHideForPlayer(playerid, Tutorial[playerid]);
	}

	switch( Area[areaid][area_type] )
	{
		case AREA_TYPE_FIRE:
		{
			SetPVarInt(playerid, "fire", 0);
		}

		case AREA_TYPE_GUARD_NPC:
		{
			new npcid = GetNPCByArea(areaid);
			if(npcid != -1)
			{
				FCNPC_StopAim(npcid);
				if(NPC[npcid][npc_aimed] == playerid) NPC[npcid][npc_aimed] = -1;
			}
		}

		case AREA_TYPE_NORMAL, AREA_TYPE_BOOMBOX:
		{
			if( strcmp(Area[areaid][area_audio], "-", true) )
			{
				StopAudioStreamForPlayer(playerid);
			}
		}
	}
	return 1;
}

public OnDynamicObjectMoved(objectid)
{
	if(objectid == space_ship)
    {
    	SetDynamicObjectPos(objectid, Object[objectid][object_pos][0], Object[objectid][object_pos][1], Object[objectid][object_pos][2]);
    	MoveDynamicObject(objectid, 508.8699,-916.9603,210.8788, 8.0, 0.0, 0.0, -106.5);
    }

	if(Object[objectid][object_uid] == 18401 || Object[objectid][object_uid] == 18579)
	{
		new Float:x, Float:y, Float:z;
		GetDynamicObjectPos(objectid, x, y, z);

		new a_id[10];
		GetDynamicAreasForPoint(x, y, z, a_id);

	    if( IsValidDynamicArea(a_id[0]))
	    {
    		foreach(new p : Player)
			{
				if( IsPlayerInRangeOfPoint(p, 90.0, x, y, z) )
				{
					if(Object[objectid][object_uid] == 18401) SendClientMessage(p, 0x9B91ECFF, "** Statek handlowy Chartered Liberty Lines wp�yn�� w�a�nie do jednej ze stref Ocean Docks.");
					if(Object[objectid][object_uid] == 18579) SendClientMessage(p, 0x9B91ECFF, "** Statek handlowy Hanjin Lines wp�yn�� w�a�nie do jednej ze stref Ocean Docks.");
					new Float:apoints[8];
					GetDynamicPolygonPoints(a_id[0], apoints, 8);

					pInfo[p][player_lookup_zone] = PlayerGangZoneCreate(p, Min(apoints[0], apoints[4]), Min(apoints[1], apoints[3]), Max(apoints[0], apoints[4]), Max(apoints[1], apoints[3]));
					PlayerGangZoneShow(p, pInfo[p][player_lookup_zone], 0xFF3C3C80);
				}
			}
	    }
	}
	return 1;
}

public OnObjectMoved(objectid)
{
	if(objectid == FerrisWheelObjects[10]) SetTimer("RotateFerrisWheel", 3000, false);
	if(objectid == plane_object) DestroyObject(plane_object);   
    
	if(objectid == box_object)
	{
        new Float:x, Float:y, Float:z;
       
        GetObjectPos(objectid, x, y, z);

        new drop_pickup;
       	drop_pickup = CreateDynamicPickup(1575, 19, x, y, z + 0.15);
       	Pickup[drop_pickup][pickup_type] = PICKUP_TYPE_DROP;
        
        DestroyObject(para_object);
        DestroyObject(box_object);
        drop = -1;
    }

	return 1;
}

forward RotateFerrisWheel();
public RotateFerrisWheel()
{
	FerrisWheelAngle+=36;
	if(FerrisWheelAngle>=360)FerrisWheelAngle=0;
	if(FerrisWheelAlternate)FerrisWheelAlternate=0;
	else FerrisWheelAlternate=1;
	new Float:FerrisWheelModZPos=0.0;
	if(FerrisWheelAlternate)FerrisWheelModZPos=0.05;
	MoveObject(FerrisWheelObjects[10],389.7734,-2028.4688,22.0+FerrisWheelModZPos, 0.005, 0, FerrisWheelAngle,90);
}

public OnPlayerShootDynamicObject(playerid, weaponid, objectid, Float:x, Float:y, Float:z)
{
	//new wslot = GetWeaponSlot(weaponid);
	//pWeapon[playerid][wslot][pw_ammo] -= 1;

	if(weaponid == 25 && Object[objectid][object_gate] && Object[objectid][object_model] != OBJECT_ROB_DOORS && Object[objectid][object_model] != OBJECT_SAFE_DOOR)
	{
		if(!Object[objectid][object_gate_opened])
        {
            DeleteObject(objectid, false);
            GameTextForPlayer(playerid, "~w~Drzwi ~r~zniszczone", 2500, 3);
        }
	}

	if(pInfo[playerid][player_robbery] != -1)
	{
		if(Object[objectid][object_model] == OBJECT_CASH_REG && Object[objectid][object_owner] == Robbery[pInfo[playerid][player_robbery]][robbery_uid] && !Object[objectid][object_robbed])
		{
			if(Robbery[pInfo[playerid][player_robbery]][robbery_actors] > Robbery[pInfo[playerid][player_robbery]][robbery_aimed_actors]) return SendGuiInformation(playerid, "Informacja", "Najpierw obezw�adnij zak�adnik�w.");
			if(GetPlayerDistanceFromPoint(playerid, Object[objectid][object_pos][0], Object[objectid][object_pos][1], Object[objectid][object_pos][2]) > 5.0) return 1;
			new Float:a, Float:xx, Float:yy, Float:zz, Float:tmp, smoke;
			GetDynamicObjectRot(objectid, tmp, tmp, a);
			a = a+180.0;
			smoke = CreateDynamicObject(18703, Object[objectid][object_pos][0] - (0.15 * floatsin(-a, degrees)), Object[objectid][object_pos][1] - (0.15 * floatcos(-a, degrees)), Object[objectid][object_pos][2] - 1.65, 0.0, 0.0, 0.0, Object[objectid][object_vw], -1, -1, 200.0);
			defer StopSmoking[20000](smoke);
			Object[objectid][object_robbed] = true;
			
			GetPlayerPos(playerid, tmp, tmp, zz);

			GetXYInFrontOfObject(objectid, xx, yy, 1.0);
			new cash_pickup = CreateDynamicPickup(1212, 1, xx, yy, zz, Object[objectid][object_vw]);
			Pickup[cash_pickup][pickup_type] = PICKUP_TYPE_CASH;
			Pickup[cash_pickup][pickup_extra][0] = 550+random(550);
			Pickup[cash_pickup][pickup_extra][1] = Object[objectid][object_owner];
		}
	}

	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	new String[64];
	if( hittype != BULLET_HIT_TYPE_NONE )
	{
		/*if( !( -20.0 <= fX <= 20.0 ) || !( -20.0 <= fY <= 20.0 ) || !( -20.0 <= fZ <= 20.0 ) )
		{
		    KickAc(playerid, -1, "Invalid bullet data");
            return 0; 
		}*/
	 	if( !( -1000.0 <= fX <= 1000.0 ) || !( -1000.0 <= fY <= 1000.0 ) || !( -1000.0 <= fZ <= 1000.0 ) )
        {
            KickAc(playerid, -1, "Invalid bullet data (second)");
            return 0; 
        }
	}

	new wslot = GetWeaponSlot(weaponid);

	if(!IsPlayerInAnyVehicle(playerid))
    {
	    if(pWeapon[playerid][wslot][pw_itemid] == -1)
	    {
	    	format(String, sizeof(String), "No item shot (w: %d)", weaponid);
	    	KickAc(playerid, -1, String);
	    	return 0;
	    }
	}

	if( hittype == BULLET_HIT_TYPE_VEHICLE )
	{
		Vehicle[hitid][vehicle_damaged] = true;
	}

	if(weaponid == 38 || weaponid == 37 || weaponid == 36 || weaponid == 39 || weaponid == 35)
    {
    	format(String, sizeof(String), "Restricted weap shot (w: %d)", weaponid);
    	BanAc(playerid, -1, 30, String);
		return 0;
    }
	
	pWeapon[playerid][wslot][pw_ammo] -= 1;

	switch(weaponid)
	{
		case 22: PlayerItem[playerid][pWeapon[playerid][wslot][pw_itemid]][player_item_condition] -= 0.10;
		case 23: PlayerItem[playerid][pWeapon[playerid][wslot][pw_itemid]][player_item_condition] -= 0.10;
		case 24: PlayerItem[playerid][pWeapon[playerid][wslot][pw_itemid]][player_item_condition] -= 0.14;
		case 28: PlayerItem[playerid][pWeapon[playerid][wslot][pw_itemid]][player_item_condition] -= 0.18;
		case 29: PlayerItem[playerid][pWeapon[playerid][wslot][pw_itemid]][player_item_condition] -= 0.20;
		case 30: PlayerItem[playerid][pWeapon[playerid][wslot][pw_itemid]][player_item_condition] -= 0.03;
		case 31: PlayerItem[playerid][pWeapon[playerid][wslot][pw_itemid]][player_item_condition] -= 0.02; 
		case 32: PlayerItem[playerid][pWeapon[playerid][wslot][pw_itemid]][player_item_condition] -= 0.14; 
		case 33: PlayerItem[playerid][pWeapon[playerid][wslot][pw_itemid]][player_item_condition] -= 0.72; 
		default: PlayerItem[playerid][pWeapon[playerid][wslot][pw_itemid]][player_item_condition] -= 0.50; 
	}

	if( PlayerItem[playerid][pWeapon[playerid][wslot][pw_itemid]][player_item_condition] <= 0)
	{
		Item_Use(pWeapon[playerid][wslot][pw_itemid], playerid);
		GameTextForPlayer(playerid, "~w~bron ~r~zniszczona", 3000, 6);
		pInfo[playerid][player_last_bullet] = true;
		return 1;
	}
	
	if( pWeapon[playerid][wslot][pw_ammo] == 0 )
	{
		Item_Use(pWeapon[playerid][wslot][pw_itemid], playerid);
		pInfo[playerid][player_last_bullet] = true;
		return 1;
	}

	if(GetPVarInt(playerid, "taser") == 1)
	{
		ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.0, 0, 0, 0, 0, 0, 1);
	}

	if( pInfo[playerid][player_howitzer] > 0 )
	{
    	CreateExplosion(fX, fY, fZ, 12, 1); 
    	pInfo[playerid][player_howitzer]--;
    }

    new a_id = pInfo[playerid][player_area];

    if( a_id != -1 && GetPlayerVirtualWorld(playerid) == 0 && !IsPlayerInPD(playerid))
    {
    	if(Area[a_id][area_type] == AREA_TYPE_NORMAL && AreaHasFlag(a_id, AREA_FLAG_MONITORING))
    	{
	    	if(gettime() > Area[a_id][area_last_info] + 600)
	    	{
	    		Area[a_id][area_last_info] = gettime();
	    		foreach(new p : Player)
				{
					if( IsPlayerInAnyGroup(p) )
					{
						new gidd = pInfo[p][player_duty_gid];
						if(gidd != -1)
						{
							if( Group[gidd][group_type] == GROUP_TYPE_LSPD)
							{
								SendClientMessage(p, COLOR_GOLD, sprintf("Centrala 911: zg�oszono strza�y w strefie %d. Zosta�a ona oznaczona na radarze.", Area[a_id][area_uid]));
								new Float:apoints[8];
								GetDynamicPolygonPoints(a_id, apoints, 8);

								pInfo[p][player_lookup_zone] = PlayerGangZoneCreate(p, Min(apoints[0], apoints[4]), Min(apoints[1], apoints[3]), Max(apoints[0], apoints[4]), Max(apoints[1], apoints[3]));
								PlayerGangZoneShow(p, pInfo[p][player_lookup_zone], 0xFF3C3C80);
							}
						}
					}
				}
	    	}
	    }
    }
    pInfo[playerid][player_weapon_skill] += 0.25;
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if(response)
    {
    	if(fOffsetX > 1 || fOffsetY > 1 || fOffsetZ > 1)
    	{
    		SendGuiInformation(playerid, "Informacja", "Odsun��e� obiekt zbyt daleko od postaci.");
    		RemovePlayerAttachedObject(playerid, index);
    		return 1;
    	}

    	if(fScaleX > 2 || fScaleY > 2 || fScaleZ > 2)
    	{
    		SendGuiInformation(playerid, "Informacja", "Przekroczy�e� granice skali.");
    		RemovePlayerAttachedObject(playerid, index);
    		return 1;
    	}

    	if(index == 4 || index == 5 || index == 6)
    	{
    		SendPlayerInformation(playerid, "Schowaj i wyjmij przedmiot ponownie aby wczytac nowe ustawienia pozycji obiektu.", 4000);
    	}

		RemovePlayerAttachedObject(playerid, index);
		SetPlayerAttachedObject(playerid, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);
        
		ao[playerid][index][ao_x] = fOffsetX;
        ao[playerid][index][ao_y] = fOffsetY;
        ao[playerid][index][ao_z] = fOffsetZ;
        ao[playerid][index][ao_rx] = fRotX;
        ao[playerid][index][ao_ry] = fRotY;
        ao[playerid][index][ao_rz] = fRotZ;
        ao[playerid][index][ao_sx] = fScaleX;
        ao[playerid][index][ao_sy] = fScaleY;
        ao[playerid][index][ao_sz] = fScaleZ;

        if(ao[playerid][index][ao_inserted] == false)
        {
        	mysql_query(mySQLconnection, sprintf("INSERT INTO ipb_attached_objects (attach_uid, attach_owner, attach_index, attach_model, attach_bone, attach_x, attach_y, attach_z, attach_rx, attach_ry, attach_rz, attach_sx, attach_sy, attach_sz) VALUES (null, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f')", pInfo[playerid][player_id], index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ));
        }
        else
        {
        	mysql_query(mySQLconnection, sprintf("UPDATE ipb_attached_objects SET attach_x = '%f', attach_y = '%f', attach_z = '%f', attach_rx = '%f', attach_ry = '%f', attach_rz = '%f', attach_sx = '%f', attach_sy = '%f', attach_sz = '%f' WHERE attach_owner = %d AND attach_model = %d", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, pInfo[playerid][player_id], modelid ));
        }
    }
    return 1;
}

forward OnPasswordChecked(playerid);
public OnPasswordChecked(playerid)
{
    new bool:match = bcrypt_is_equal();

    if( match == true )
	{
		if(IsGlobalLogged(playerid))
		{
			SendClientMessage(playerid, COLOR_LIGHTER_RED, "Kto� jest ju� zalogowany na tym koncie globalnym.");
			Kick(playerid);
			return 1;
		}

		gInfo[playerid][global_logged] = true;
		OnPlayerLoginHere(playerid);
	}
	else
	{
		pGlobal[playerid][glo_bad_pass] += 1;

		if( pGlobal[playerid][glo_bad_pass] >= 3 )
		{
			SendClientMessage(playerid, COLOR_LIGHTER_RED, "Zosta�e� wyrzucony z powodu zbyt wielu niepoprawnych pr�b logowania.");
			Kick(playerid);
			return 1;
		}

		new bad_pass_info[60];
		if( pGlobal[playerid][glo_bad_pass] > 0 ) format(bad_pass_info, sizeof(bad_pass_info), "\nPodano niepoprawne has�o. Pozosta�e pr�by: {ADC7E7}%d", 3-pGlobal[playerid][glo_bad_pass]);

		new string[512];
	    format(string, sizeof(string), "{EBEF6B}Witaj na San Andreas Roleplay!\n\n");
	    format(string, sizeof(string), "%s{A9C4E4}Do��czy�e� na serwer jako {ffffff}%s.\n\n", string, pInfo[playerid][player_name]);
	    format(string, sizeof(string), "%s{A9C4E4}1.    Posta� nale�y do Ciebie? Zaloguj si� na swoje konto podaj�c swoje has�o z forum.\n2.    Wprowadzi�e� niepoprawny nick? Zmie� go.\n3.    Nie posiadasz konta na forum? Zarejestruj si� na san-andreas.pl\n\n%s", string, bad_pass_info);
	    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, ""guiopis"Logowanie do gry", string, "Zaloguj", "Zmie� nick");
	}

    return 1;
}

public OnPlayerRequestDownload(playerid, type, crc)
{
	new fullurl[256+1];
	new dlfilename[64+1];
	new foundfilename=0;
	
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(type == DOWNLOAD_REQUEST_TEXTURE_FILE) 
	{
		TextDrawSetString(Tutorial[playerid], sprintf("Pobieranie plikow w toku.~n~Pamietaj by nie minimalizowac gry do czasu ukonczenia pobierania~n~~n~Aktualny plik: ~y~txd %d", crc));
		foundfilename = FindTextureFileNameFromCRC(crc,dlfilename,64);
	}
	else if(type == DOWNLOAD_REQUEST_MODEL_FILE) 
	{
		TextDrawSetString(Tutorial[playerid], sprintf("Pobieranie plikow w toku.~n~Pamietaj by nie minimalizowac gry do czasu ukonczenia pobierania~n~~n~Aktualny plik: ~y~dff %d", crc));
	    foundfilename = FindModelFileNameFromCRC(crc,dlfilename,64);
	}

	if(foundfilename) 
	{
		TextDrawShowForPlayer(playerid, Tutorial[playerid]);
	    format(fullurl,256,"%s/%s",baseurl,dlfilename);
	    RedirectDownload(playerid,fullurl);
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if( strfind(inputtext, "|", true) != -1) return SendGuiInformation(playerid, "Wyst�pi� b��d", "Wykryto niedozwolone znaki.");

	if(dialogid != DIALOG_LOGIN)
	{
		printf("[DIAL] %s (UID: %d, GID: %d): [%s] (%d, %d, %d)", pInfo[playerid][player_name], pInfo[playerid][player_id], pGlobal[playerid][glo_id], inputtext, playerid, dialogid, response);
	}
	
	DebugText(inputtext);

	switch( dialogid )
	{
		case DIALOG_LOGIN:
		{
			if( !response ) return Kick(playerid);

			if( isnull(inputtext) || strlen(inputtext) < 5 )
			{
				pGlobal[playerid][glo_bad_pass] += 1;

				if( pGlobal[playerid][glo_bad_pass] >= 3 )
				{
					SendClientMessage(playerid, COLOR_LIGHTER_RED, "Zosta�e� wyrzucony z powodu zbyt wielu niepoprawnych pr�b logowania.");
					Kick(playerid);
					return 1;
				}

				new bad_pass_info[60];
				if( pGlobal[playerid][glo_bad_pass] > 0 ) format(bad_pass_info, sizeof(bad_pass_info), "\nPodano niepoprawne has�o. Pozosta�e pr�by: {ADC7E7}%d", 3-pGlobal[playerid][glo_bad_pass]);
				
				new string[512];
			    format(string, sizeof(string), "{EBEF6B}Witaj na San Andreas Roleplay!\n\n");
			    format(string, sizeof(string), "%s{A9C4E4}Do��czy�e� na serwer jako {ffffff}%s.\n\n", string, pInfo[playerid][player_name]);
			    format(string, sizeof(string), "%s{A9C4E4}1.    Posta� nale�y do Ciebie? Zaloguj si� na swoje konto podaj�c swoje has�o z forum.\n2.    Wprowadzi�e� niepoprawny nick? Zmie� go.\n3.    Nie posiadasz konta na forum? Zarejestruj si� na san-andreas.pl\n\n%s", string, bad_pass_info);
			    return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, ""guiopis"Logowanie do gry", string, "Zaloguj", "Zmie� nick");
			}

			mysql_escape_string(inputtext, inputtext, 256);

			bcrypt_check(inputtext, gInfo[playerid][global_password], "OnPasswordChecked", "d", playerid);
		}

		case DIALOG_OFFER:
		{
			if( response ) OnPlayerOfferResponse(playerid, 1);
			else OnPlayerOfferResponse(playerid, 0);
		}

		case DIALOG_GROUP_INFO:
		{
			if( !response ) return 1;
			switch(listitem)
			{
				case 6: 
				{
					ShowPlayerDialog(playerid, DIALOG_SMS_COST, DIALOG_STYLE_INPUT, "Koszt SMS", "Wprowad� koszt SMSa premium dla twojej grupy.", "OK", "Anuluj");
				}
			}
		}

		case DIALOG_SMS_COST:
		{
			if( !response ) return 1;
			new gid = DynamicGui_GetDialogValue(playerid);
			new smscost;
			if(sscanf(inputtext, "d", smscost)) return ShowPlayerDialog(playerid, DIALOG_SMS_COST, DIALOG_STYLE_INPUT, "Koszt SMS", "Wprowad� koszt SMSa premium dla twojej grupy.", "OK", "Anuluj");
			if(smscost < 0 || smscost > 100) return ShowPlayerDialog(playerid, DIALOG_SMS_COST, DIALOG_STYLE_INPUT, "Koszt SMS", "Wprowad� koszt SMSa premium dla twojej grupy.\n\nPrzedzia� kwot to od $1 do $100.", "OK", "Anuluj");
			Group[gid][group_sms_cost] = smscost;
			SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Ustalono cene smsa premium.");
		}

		case DIALOG_NAMECHANGE:
		{
			if(!response) return Kick(playerid);
			if(strlen(inputtext) < 3 || strlen(inputtext) > 60)
			{
				ShowPlayerDialog(playerid, DIALOG_NAMECHANGE, DIALOG_STYLE_INPUT, ""guiopis"Zmiana nicku", "{D6EE76}W polu poni�ej wpisz nowy nick postaci, na kt�r� chcesz si� zalogowa�.\n\n{A9C4E4}Poprzednio poda�e� nieprawid�owy nick.\nPami�taj o pod�odze mi�dzy imieniem, a nazwiskiem!", "Zmie� nick", "Wyjd�");
				return 1;
			}

			SetPlayerName(playerid, inputtext);
			OnPlayerDisconnect(playerid, 0);
			OnPlayerConnect(playerid);
			OnPlayerFinishedDownloading(playerid, GetPlayerVirtualWorld(playerid));
		}

		case DIALOG_LOGIN_NO_ACCOUNT:
		{
			if(!response) return Kick(playerid);

			ShowPlayerDialog(playerid, DIALOG_NAMECHANGE, DIALOG_STYLE_INPUT, ""guiopis"Zmiana nicku", "{D6EE76}W polu poni�ej wpisz nowy nick postaci, na kt�r� chcesz si� zalogowa�.\n\n{A9C4E4}Pami�taj o pod�odze mi�dzy imieniem, a nazwiskiem!", "Zmie� nick", "Wyjd�");
		}

		case DIALOG_AREA:
		{
			PlayerGangZoneHide(playerid, pInfo[playerid][player_lookup_zone]);
			PlayerGangZoneDestroy(playerid, pInfo[playerid][player_lookup_zone]);

			if(!response) return 1;

			new a_id = DynamicGui_GetDialogValue(playerid);
			
			switch( DynamicGui_GetValue(playerid, listitem) )
			{
				case DG_AREA_INFO:
				{
					if(Area[a_id][area_owner_type] == AREA_OWNER_TYPE_GROUP)
					{
						new gid = GetGroupByUid(Area[a_id][area_owner]);
						if(gid == -1) return 1;
						new area_info[100];
						format(area_info, sizeof(area_info), "W�a�ciciel strefy: %s\nCena budynk�w na tej strefie: $%d", Group[gid][group_name], Area[a_id][area_price]);
						ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_TABLIST, sprintf("Informacje o strefie UID %d", Area[a_id][area_uid]), area_info, "OK", "");
						ShowAreaFlags(playerid, a_id);
					}
					else
					{
						new area_info[80];
						format(area_info, sizeof(area_info), "W�a�ciciel strefy: brak\nCena budynk�w na tej strefie: $%d", Area[a_id][area_price]);
						ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, sprintf("Informacje o strefie UID %d", Area[a_id][area_uid]), area_info, "OK", "");
						ShowAreaFlags(playerid, a_id);
					}
				}

				case DG_AREA_TAKEA:
				{
					SendGuiInformation(playerid, "Informacja", "Ju� w najbli�szej aktualizacji - przejmowanie stref przez aktywno��.");
				}

				case DG_AREA_TAKE:
				{
					if(Area[a_id][area_owner_type] == AREA_OWNER_TYPE_GLOBAL)
					{
						new slot = GetPlayerDutySlot(playerid);
						if(slot == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz si� na s�u�bie �adnej grupy.");

						new owner = pInfo[playerid][player_duty_gid];
						if(owner == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz si� na s�u�bie �adnej grupy.");

						if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_LEADER) ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnie� lidera.");

						if(Group[owner][group_type] == GROUP_TYPE_LSPD || Group[owner][group_type] == GROUP_TYPE_MEDIC || Group[owner][group_type] == GROUP_TYPE_GOV ) return SendGuiInformation(playerid, "Informacja", "Grupa na kt�rej jeste� s�u�bie nie mo�e przejmowa� stref.");
						
						new weektime =  Group[owner][group_last_take]+604800;
						if(weektime > gettime()) return SendGuiInformation(playerid, "Informacja", "Nie min�o 7 dni od ostatniego przej�cia.");

						new door_count;

						foreach(new d_id: Doors)
						{
							if(Door[d_id][door_owner_type] != DOOR_OWNER_TYPE_GROUP) continue;
							if(IsPointInDynamicArea(a_id, Door[d_id][door_pos][0], Door[d_id][door_pos][1], Door[d_id][door_pos][2]) && Door[d_id][door_owner] == Group[owner][group_uid])
							{
								door_count++;
							}
						}

						if(Group[owner][group_temp])
						{
							if(door_count < 1) return SendGuiInformation(playerid, "Informacja", "Aby przej�� stref� w procesie tworzenia grupy, twoja grupa musi posiada� budynek w jej obszarze.");
						}
						else
						{
							if(door_count < 2) return SendGuiInformation(playerid, "Informacja", "Aby przej�� neutraln� stref�, twoja grupa musi posiada� minimum dwa budynki w jej obszarze.");
						}

						Area[a_id][area_owner_type] = AREA_OWNER_TYPE_GROUP;
						Area[a_id][area_owner] = Group[owner][group_uid];

						mysql_query(mySQLconnection, sprintf("UPDATE ipb_areas SET area_owner = %d, area_ownertype = %d WHERE area_uid = %d", Area[a_id][area_owner], AREA_OWNER_TYPE_GROUP, Area[a_id][area_uid]));

						SendGuiInformation(playerid, "Informacja", sprintf("Gratulacje, twoja grupa przej�a neutraln� stref� o UID %d. U�yj /area aby ni� zarz�dza�.", Area[a_id][area_uid]));
						Group[owner][group_last_take] = gettime();
						mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_last_take = %d WHERE group_uid = %d", Group[owner][group_last_take], Group[owner][group_uid]));
						
						if(Group[owner][group_type] == GROUP_TYPE_GANG)
						{
							AddBonusProduct(owner);
						}
					}

					else if(Area[a_id][area_owner_type] == AREA_OWNER_TYPE_GROUP)
					{
						new gid = GetGroupByUid(Area[a_id][area_owner]);
						if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Grupa pod kt�r� podpisana jest ta strefa nie istnieje. Zg�o� to do administracji.");

						new slot = GetPlayerDutySlot(playerid);
						if(slot == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz si� na s�u�bie �adnej grupy.");

						new owner = pInfo[playerid][player_duty_gid];
						if(owner == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz si� na s�u�bie �adnej grupy.");

						if( !WorkerHasFlag(playerid, slot, WORKER_FLAG_ORDER) ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnie� lidera.");

						if(Group[owner][group_type] != GROUP_TYPE_GANG) return SendGuiInformation(playerid, "Informacja", "Grupa na kt�rej jeste� s�u�bie nie jest przest�pcz�.");

						if(GroupHasFlag(gid, GROUP_FLAG_BUSINESS))
						{
							new rows, Cache:tmp_cache;
							tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT group_uid FROM ipb_game_groups WHERE group_tributers = %d", Group[owner][group_uid]));
							cache_get_row_count(rows);

							if(rows < 2) 
							{
								SendGuiInformation(playerid, "Informacja", "Aby przej�� stref� nale��c� do biznesu, musisz kontrolowa� co najmniej dwa biznesy w jej w obszarze.");
								if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
								return 1;
							}

							new business_id[50];
							new door_count;

							for(new row = 0; row != rows; row++)
							{
								cache_get_value_index_int(row, 0, business_id[row]);
							}

							if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);

							foreach(new d_id : Doors)
							{
								if(Door[d_id][door_owner_type] != DOOR_OWNER_TYPE_GROUP) continue;
								if(!IsPointInDynamicArea(a_id, Door[d_id][door_pos][0], Door[d_id][door_pos][1], Door[d_id][door_pos][2])) continue;

								for(new row = 0; row != rows; row++)
								{
									if(Door[d_id][door_owner] == business_id[row]) door_count++;
								}
							}

							if(door_count < 2 ) return SendGuiInformation(playerid, "Informacja", "Aby przej�� stref� nale��c� do biznesu, twoja organizacja musi kontrolowa� co najmniej dwa biznesy w jej w obszarze.");

							Area[a_id][area_owner] = Group[owner][group_uid];

							mysql_query(mySQLconnection, sprintf("UPDATE ipb_areas SET area_owner = %d WHERE area_uid = %d", Area[a_id][area_owner], Area[a_id][area_uid]));

							SendGuiInformation(playerid, "Informacja", sprintf("Gratulacje, twoja grupa przej�a stref� nale��c� do biznesu %s. U�yj /area aby ni� zarz�dza�.", Group[gid][group_name]));
							Group[owner][group_last_take] = gettime();
							mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_last_take = %d WHERE group_uid = %d", Group[owner][group_last_take], Group[owner][group_uid]));
							
							AddBonusProduct(owner);
							return 1;
						}

						if(Group[gid][group_type] == GROUP_TYPE_GANG)
						{
							if(Area[a_id][area_attacked] == 1) return SendGuiInformation(playerid, "Informacja", "Ta strefa jest ju� przez kogo� atakowana.");

							if(IsGroupAtackedByGroup(gid, owner)) return SendGuiInformation(playerid, "Informacja", "Ta grupa jest ju� atakowana przez jedn� z twoich grup.");
							if(GroupVsGroupCheck(owner, gid)) return SendGuiInformation(playerid, "Informacja", "Ta grupa zaatakowa�a jedn� z twoich stref. Najpierw j� obro�.");
							
							new gr1, gr2, gr3;

							if(GetGroupAttackers(gid, gr1, gr2, gr3) > 2)
							{
								SendGuiInformation(playerid, "Informacja", sprintf("Ta grupa jest ju� atakowana przez 3 inne:\n%s\n%s\n%s\n\nPoczekaj na zako�czenie przynajmniej jednej z tych walk.", Group[gr1][group_name], Group[gr2][group_name], Group[gr3][group_name]));
								return 1;
							}

							if(GetAttacksCount(owner) > 2) return SendGuiInformation(playerid, "Informacja", "Jeste� w trakcie walki o 3 inne strefy.\nPoczekaj na zako�czenie przynajmniej jednej z nich.");

							if(GetGangMembersOnline(gid) < 3) return SendGuiInformation(playerid, "Informacja", "Minimum 3 osoby z przeciwnej grupy musz� przebywa� w grze.");

							new weektimes =  Group[owner][group_last_take]+604800;
							if(weektimes > gettime()) return SendGuiInformation(playerid, "Informacja", "Nie min�o 7 dni od ostatniego przej�cia.");
							
							new Cache:tmp_cache;
							tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT group_created FROM ipb_game_groups WHERE group_uid = %d", Group[gid][group_uid]));
							new g_created;
							cache_get_value_index_int(0, 0, g_created);
							if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);

							new temp, ghour, gminute, gday, gmonth;
							new weektime = g_created +604800;
							TimestampToDate(weektime, temp, gmonth, gday, ghour, gminute, temp, 1);

							if(weektime > gettime()) return SendGuiInformation(playerid, "Informacja", sprintf("Organizacja, kt�r� pr�bujesz zaatakowa�, nie przetrwa�a jeszcze tygodnia.\nB�dziesz m�g� zaatakowa� t� stref� dnia %02d.%02d o %02d:%02d.", gday, gmonth, ghour, gminute));

							if(owner == gid) return SendGuiInformation(playerid, "Informacja", "Co ty odpierdalasz?");
							GangWar_Init(playerid, owner, gid, a_id);
							return 1;
						}

						SendGuiInformation(playerid, "Informacja", "Tej strefy nie mo�na przej��. Nale�y ona do grupy publicznej.");
					}
				}

				case DG_AREA_VISIBLE:
				{
					if(Area[a_id][area_visible])
					{
						SendGuiInformation(playerid, "Informacja", "Twoja strefa b�dzie teraz niewidoczna na minimapie.");
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_areas SET area_visible = 0 WHERE area_uid = %d", Area[a_id][area_uid]));
						Area[a_id][area_visible] = false;

						foreach(new p: Player)
						{
							HidePlayerZones(playerid);
							ShowPlayerZones(playerid);
						}
					}
					else
					{
						SendGuiInformation(playerid, "Informacja", "Twoja strefa b�dzie teraz widoczna na minimapie.");
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_areas SET area_visible = 1 WHERE area_uid = %d", Area[a_id][area_uid]));
						Area[a_id][area_visible] = true;

						foreach(new p: Player)
						{
							HidePlayerZones(playerid);
							ShowPlayerZones(playerid);
						}
					}
				}
			}
			
		}

		case DIALOG_RADIOSTATIONS:
		{
			if(!response) return 1;

			new dg_value = DynamicGui_GetValue(playerid, listitem);

			pInfo[playerid][player_radio] = dg_value;
			SendGuiInformation(playerid, "Informacja", sprintf("Radiostacja zosta�a zmieniona. Aktualnie s�uchasz: %s.", Group[dg_value][group_name]));

			if(strlen(Group[dg_value][group_radio_text]))
			{
				switch(Group[dg_value][group_news_type])
				{
					case 1:
					{
						PlayerTextDrawSetString(playerid, TextDrawSanNews[playerid], sprintf("_~w~%s ~>~ ~y~%s~w~ ~>~ %s", Group[dg_value][group_name], Group[dg_value][group_radio_sender], Group[dg_value][group_radio_text]));
					}
					case 2:
					{
						PlayerTextDrawSetString(playerid, TextDrawSanNews[playerid], sprintf("_~w~%s ~>~ ~g~~h~Reklama~w~ ~>~ %s", Group[dg_value][group_name], Group[dg_value][group_radio_text]));
					}
					case 3:
					{
						PlayerTextDrawSetString(playerid, TextDrawSanNews[playerid], sprintf("_~w~%s ~p~LIVE ~>~ ~y~%s~w~ ~>~ %s", Group[dg_value][group_name], Group[dg_value][group_radio_sender], Group[dg_value][group_radio_text]));
					}
				}
			}
			else
			{
				PlayerTextDrawSetString(playerid, TextDrawSanNews[playerid], sprintf("_~w~%s ~>~ Aktualnie nic nie jest nadawane w tej stacji.", Group[dg_value][group_name]));
			}
		}

		case DIALOG_ROBBERY:
		{
			if(!response) return 1;
			new requirements_list[300];
			new dg_value = DynamicGui_GetValue(playerid, listitem);
			DynamicGui_SetDialogValue(playerid, dg_value);

			format(requirements_list, sizeof(requirements_list), "{D6EE76}Poni�ej wy�wietlone zosta�y wymagania do napadu na %s.\nAby sprawdzi� czy je spe�niasz wci�nij button Start.{A9C4E4}\n\n", Robbery[dg_value][robbery_name]);

			if(RobberyHasRequirement(dg_value, REQUIREMENT_GUN)) format(requirements_list, sizeof(requirements_list), "%s- bro� palna\n", requirements_list);
			if(RobberyHasRequirement(dg_value, REQUIREMENT_SQUAD)) format(requirements_list, sizeof(requirements_list), "%s- minimum 2 osoby\n", requirements_list);
			if(RobberyHasRequirement(dg_value, REQUIREMENT_BIGSQUAD)) format(requirements_list, sizeof(requirements_list), "%s- minimum 4 osoby\n", requirements_list);
			if(RobberyHasRequirement(dg_value, REQUIREMENT_CAR)) format(requirements_list, sizeof(requirements_list), "%s- samoch�d\n", requirements_list);
			if(RobberyHasRequirement(dg_value, REQUIREMENT_TOOLS)) format(requirements_list, sizeof(requirements_list), "%s- narz�dzia w�amaniowe\n", requirements_list);
			if(RobberyHasRequirement(dg_value, REQUIREMENT_BOMB)) format(requirements_list, sizeof(requirements_list), "%s- materia�y wybuchowe lub elektronika\n", requirements_list);

			ShowPlayerDialog(playerid, DIALOG_ROBBERY_START, DIALOG_STYLE_MSGBOX, "Planowanie napadu", requirements_list, "Start", "Anuluj");
		}

		case DIALOG_ROBBERY_START:
		{
			if(!response) return 1;
			if(pInfo[playerid][player_robbery] != -1) return SendGuiInformation(playerid, "Informacja", "Bierzesz ju� udzia� w jakim� napadzie.");
			
			new dg_value = DynamicGui_GetDialogValue(playerid);

			if(gettime() < Robbery[dg_value][robbery_timestamp]+ 3*86400) return SendGuiInformation(playerid, "Informacja", "Ten obiekt zosta� ju� napadni�ty w ci�gu ostatnich trzech dni.");

			if(RobberyHasRequirement(dg_value, REQUIREMENT_GUN))
			{
				if(HasPlayerWeapon(playerid) == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz przy sobie broni palnej, kt�ra jest wymagana do tego napadu.");
			}

			if(RobberyHasRequirement(dg_value, REQUIREMENT_CAR))
			{
				if(!IsPlayerInAnyVehicle(playerid)) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz si� w samochodzie, kt�ry jest wymagany do tego napadu.");
				new vid = GetPlayerVehicleID(playerid);
				if(vid == INVALID_VEHICLE_ID) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz si� w samochodzie, kt�ry jest wymagany do tego napadu.");

				if(!CanPlayerUseVehicle(playerid, vid)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz uprawnie� do korzystania z pojazdu w kt�rym si� znajdujesz.");
			}

			if(RobberyHasRequirement(dg_value, REQUIREMENT_BOMB))
			{
				if(HasPlayerItem(ITEM_TYPE_ROB_BOMBEL, playerid) == -1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz przy sobie elektroniki lub materia��w wybuchowych, kt�re s� wymagane do tego napadu.");
			}

			new squad_count;

			foreach(new squad: Player)
			{
				if(GetPlayerVehicleID(squad) == GetPlayerVehicleID(playerid)) squad_count++;
			}

			if(RobberyHasRequirement(dg_value, REQUIREMENT_SQUAD))
			{
				if(squad_count < 2) return SendGuiInformation(playerid, "Informacja", "Do tego napadu wymagane s� minimum dwie osoby (��cznie z tob�). Musz� one znajdowa� si� w twoim poje�dzie.");
			}

			if(RobberyHasRequirement(dg_value, REQUIREMENT_BIGSQUAD))
			{
				if(squad_count < 4) return SendGuiInformation(playerid, "Informacja", "Do tego napadu wymagane s� minimum cztery osoby ��cznie z tob�). Musz� one znajdowa� si� w twoim poje�dzie.");
			}

			if(RobberyHasRequirement(dg_value, REQUIREMENT_TOOLS))
			{
				if(HasPlayerItem(ITEM_TYPE_ROB_TOOLS, playerid) == -1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz przy sobie narz�dzi w�amaniowych, kt�re s� wymagane do tego napadu.");
			}

			pInfo[playerid][player_robbery] = dg_value;
			SendGuiInformation(playerid, "Informacja", sprintf("Rozpocz�to napad na %s.\nNa mapie zaznaczono jego pozycje.", Robbery[dg_value][robbery_name]));
			
			new d_id = GetDoorByUid(Robbery[dg_value][robbery_place]);
			if(d_id != -1)
			{
				SetPlayerCheckpoint(playerid, Door[d_id][door_pos][0], Door[d_id][door_pos][1], Door[d_id][door_pos][2], 2.0);
			}

			foreach(new squad: Player)
			{
				if(GetPlayerVehicleID(squad) == GetPlayerVehicleID(playerid) && squad != playerid)
				{
					pInfo[squad][player_robbery] = dg_value;
					SendGuiInformation(squad, "Informacja", sprintf("Zosta�e� w��czony do napadu na %s jako pasa�er tego pojazdu.\nNa mapie zaznaczono jego pozycje.", Robbery[dg_value][robbery_name]));

					if(d_id != -1)
					{
						SetPlayerCheckpoint(squad, Door[d_id][door_pos][0], Door[d_id][door_pos][1], Door[d_id][door_pos][2], 2.0);
					}
				}
			}

			mysql_tquery(mySQLconnection, sprintf("SELECT * FROM ipb_npcs WHERE npc_owner = %d AND npc_type = %d", Robbery[dg_value][robbery_uid], ACTOR_TYPE_ROBBERY), "LoadRobberyBots", "");
			mysql_tquery(mySQLconnection, sprintf("SELECT * FROM ipb_objects WHERE object_type = %d AND object_world = %d AND object_model IN (19618, 2941, 1550)", OBJECT_TYPE_ROBBERY, Robbery[dg_value][robbery_place]), "LoadRobberyArrows", "");

			Robbery[dg_value][robbery_timestamp] = gettime();
			mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_robberies SET robbery_timestamp = %d WHERE robbery_uid = %d", gettime(), Robbery[dg_value][robbery_uid]));
		}

		case DIALOG_GRENADE:
		{
			if(!response) return 1;

			new did = pInfo[playerid][player_dialog_tmp2];

			if(Door[did][door_closed]) return SendGuiInformation(playerid, "Informacja", "Te drzwi s� zamkni�te.");

			new Float:firstRange, Float:secRange;

			switch(pInfo[playerid][player_dialog_tmp1])
			{
				case GRENADE_TYPE_FLASH: ProxMessage(playerid, "wrzuci� przez drzwi granat b�yskowy.", PROX_SERWERME);
				case GRENADE_TYPE_BANG: ProxMessage(playerid, "wrzuci� przez drzwi granat hukowy.", PROX_SERWERME);
				case GRENADE_TYPE_SMOKE:
				{
					new smoke = CreateDynamicObject(18715, Door[did][door_spawn_pos][0], Door[did][door_spawn_pos][1], Door[did][door_spawn_pos][2], 0, 0, 0, Door[did][door_spawn_vw]);
					ProxMessage(playerid, "wrzuci� przez drzwi granat dymny.", PROX_SERWERME);
					defer StopSmoking[10000](smoke);
				}
			}

			switch(listitem)
			{
				case 0:
				{
					firstRange = 2.0;
					secRange = 20.0;
				}
				case 1:
				{
					firstRange = 0;
					secRange = 7.0;
				}
			}

			foreach(new act: Actors)
			{
				if(GetDynamicActorVirtualWorld(act) != Door[did][door_spawn_vw]) continue;

				switch(pInfo[playerid][player_dialog_tmp1])
				{
					case GRENADE_TYPE_FLASH:
					{
						ApplyDynamicActorAnimation(act, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0);
						defer RefreshActorAnim[10000](act);
					}
					case GRENADE_TYPE_BANG:
					{
						ApplyDynamicActorAnimation(act, "CRACK","crckdeth2", 4.1, 0, 0, 0, 1, 0);
						defer RefreshActorAnim[10000](act);
					}
					case GRENADE_TYPE_SMOKE:
					{
						ApplyDynamicActorAnimation(act, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0);
						defer RefreshActorAnim[5000](act);
					}
				}
			}

			foreach(new p: Player)
			{
				if(GetPlayerVirtualWorld(p) != Door[did][door_spawn_vw]) continue;
				if(GetPlayerDistanceFromPoint(p, Door[did][door_spawn_pos][0], Door[did][door_spawn_pos][1], Door[did][door_spawn_pos][2]) > firstRange && GetPlayerDistanceFromPoint(p, Door[did][door_spawn_pos][0], Door[did][door_spawn_pos][1], Door[did][door_spawn_pos][2]) < secRange)
				{
					switch(pInfo[playerid][player_dialog_tmp1])
					{
						case GRENADE_TYPE_FLASH:
						{
							SendClientMessage(p, 0x9B91ECFF, sprintf("** Do pomieszczenia wpad� granat b�yskowy. (( %s ))", Door[did][door_name]));
							PlayerPlaySound(p, 14402, 0.0, 0.0, 0.0);
							
							pInfo[p][player_flash] = 11;
							PlayerTextDrawShow(p, WhiteScreen[p]);

							ApplyAnimation(p, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
							SetPVarInt(p, "AnimHitPlayerGun", 1);
							defer AnimHitPlayer[10000](p);
						}
						case GRENADE_TYPE_BANG:
						{
							SendClientMessage(p, 0x9B91ECFF, sprintf("** Do pomieszczenia wpad� granat hukowy. (( %s ))", Door[did][door_name]));
							PlayerPlaySound(p, 14402, 0.0, 0.0, 0.0);

							if(pInfo[p][player_bw] == 0)
							{
								ApplyAnimation(p, "CRACK","crckdeth2", 4.1,0,0,0,1,0);
								SetPVarInt(p, "AnimHitPlayerGun", 1);
								defer AnimHitPlayer[15000](p);

								SetPlayerHealth(p, floatround(pInfo[p][player_health])-20);
							}
						}
						case GRENADE_TYPE_SMOKE:
						{
							SendClientMessage(p, 0x9B91ECFF, sprintf("** Do pomieszczenia wpad� granat dymny. (( %s ))", Door[did][door_name]));
							PlayerPlaySound(p, 14402, 0.0, 0.0, 0.0);
							ApplyAnimation(p, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
							SetPVarInt(p, "AnimHitPlayerGun", 1);
							defer AnimHitPlayer[5000](p);
						}
					}

					DeleteItem(pInfo[playerid][player_dialog_tmp4], true, playerid);
				}
			}
		}

		case DIALOG_INTERACTION:
		{
			if(!response) return 1;

			switch(listitem)
			{
				case 0: return cmd_p(playerid, "podnies");
				case 1: return cmd_area(playerid, "");
			}

			new dg_value = DynamicGui_GetValue(playerid, listitem);
			switch(dg_value)
			{
				case DG_INTERACTION_BANK: return cmd_bankomat(playerid, "");
				case DG_INTERACTION_BUS: return cmd_bus(playerid, "");
			}
		}

		case DIALOG_PLAYER_INTERACTION:
		{
			if(!response) return 1;

			new targetid = DynamicGui_GetDialogValue(playerid);
			if(!IsPlayerConnected(targetid)) return 1;

			switch(listitem)
			{
				case 0: return cmd_yo(playerid, sprintf("%d 6", targetid));
				case 1: return cmd_kiss(playerid, sprintf("%d 3", targetid));
				case 2: return cmd_yo(playerid, sprintf("%d 1", targetid));
				case 3: return cmd_obrazenia(playerid, sprintf("%d", targetid));
			}

			new dg_value = DynamicGui_GetValue(playerid, listitem);

			switch(dg_value)
			{
				case DG_INTERACTION_VCARD: return cmd_o(playerid, sprintf("vcard %d", targetid));
				case DG_INTERACTION_CUFF: return cmd_skuj(playerid, sprintf("%d", targetid));
				case DG_INTERACTION_KEEP: return SendGuiInformation(playerid, "Informacja", "tu bedzie okno od przetrzymywania");
				case DG_INTERACTION_TAKE: return cmd_zabierz(playerid, sprintf("%d", targetid));
				case DG_INTERACTION_TAKELIC: return cmd_zabierz(playerid, sprintf("prawko %d", targetid));
				case DG_INTERACTION_TIE: return cmd_zwiaz(playerid, sprintf("%d", targetid));
				case DG_INTERACTION_HEAL: return cmd_ulecz(playerid, sprintf("%d", targetid));
				case DG_INTERACTION_KILL:
				{
					if(pInfo[targetid][player_hours] >= 5)
					{
						CharacterKill(targetid, -1, "Zabity przez swojego lidera");
					}
					else
					{
						SendGuiInformation(playerid, "Informacja", "Ten gracz nie przegra� jeszcze 5 godzin.");
					}
				}
				case DG_INTERACTION_INVITE:
				{
					new slot = GetPlayerDutySlot(playerid);
					if(slot != -1)
					{
						return cmd_g(playerid, sprintf("%d zapros %d", slot+1, targetid));
					}
				}
			}
		}

		case DIALOG_VEHICLE_INTERACTION:
		{
			if(!response) return 1;

			new targetid = DynamicGui_GetDialogValue(playerid);
			if( !Iter_Contains(Vehicles, targetid) ) return 1;

			switch(listitem)
			{
				case 0: return cmd_v(playerid, sprintf("z", targetid));
				case 1: return cmd_maska(playerid, "");
				case 2: return cmd_bagaznik(playerid, "");
			}
		}

		case DIALOG_SALON_SELL:
		{
			if(!response) return 1;

			new dg_value = DynamicGui_GetValue(playerid, listitem), dg_data = DynamicGui_GetDataInt(playerid, listitem);
			if(dg_value == DG_PRODS_SALON)
			{
				new Cache:tmp_cache, price, category;
				new model= dg_data;
				tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT dealer_price, dealer_fueltype, dealer_category FROM ipb_veh_dealer WHERE dealer_model = %d", model));

				cache_get_value_index_int(0, 0, price);
				//cache_get_value_index_int(0, 1, fueltype);
				cache_get_value_index_int(0, 2, category);

				if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
				if(pInfo[playerid][player_money] < price)
				{
					SendGuiInformation(playerid, "Informacja", "Nie posiadasz wystarczaj�cej ilo�ci got�wki na zakup tego pojazdu.");
					return 1;
				}

				if(category == CATEGORY_PREMIUM)
				{
					//mysql_tquery(mySQLconnection, sprintf("UPDATE core_members SET game_unique_vehicle = 0 WHERE member_id = %d", pGlobal[playerid][glo_id]));
				}

				GivePlayerMoney(playerid, -price);

				new color = random(44);
				
				if(model == 511 || model == 519 || model == 593 || model == 512 || model == 553 || model == 487 || model == 563)
	            {
	                mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_vehicles` (vehicle_uid, vehicle_model, vehicle_posx, vehicle_posy, vehicle_posz, vehicle_posa, vehicle_world, vehicle_interior, vehicle_color1, vehicle_color2, vehicle_owner, vehicle_ownertype, vehicle_fuel) VALUES (null, %d, %f, %f, %f, %f, %d, %d, %d, %d, %d, %d, %f)", model, 1938.9546,-2271.0830,13.1125, 176.0897, 0, 0, color, 1, pInfo[playerid][player_id], VEHICLE_OWNER_TYPE_PLAYER, 5.0));
	                new uid = cache_insert_id();

	                new vid = LoadVehicle(sprintf("WHERE `vehicle_uid` = %d", uid), true);

	                SendGuiInformation(playerid, ""guiopis"Powiadomienie", sprintf("Zakupi�e� pojazd lataj�cy - %s [UID: %d, ID: %d].\nJej pozycja zosta�a zaznaczona na mapie.", VehicleNames[model-400], uid, vid));
	                cmd_v(playerid, sprintf("namierz %d", Vehicle[vid][vehicle_uid]));
	                return 1;
	            }

	            if(model == 446 || model == 452 || model == 453 || model == 454 || model == 473 || model == 484 || model == 493)
	            {
	                mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_vehicles` (vehicle_uid, vehicle_model, vehicle_posx, vehicle_posy, vehicle_posz, vehicle_posa, vehicle_world, vehicle_interior, vehicle_color1, vehicle_color2, vehicle_owner, vehicle_ownertype, vehicle_fuel) VALUES (null, %d, %f, %f, %f, %f, %d, %d, %d, %d, %d, %d, %f)", model, 733.0229,-1502.7858,-0.6217, 176.0897, 0, 0, color, 1, pInfo[playerid][player_id], VEHICLE_OWNER_TYPE_PLAYER, 5.0));
	                new uid = cache_insert_id();

	                new vid = LoadVehicle(sprintf("WHERE `vehicle_uid` = %d", uid), true);

	                SendGuiInformation(playerid, ""guiopis"Powiadomienie", sprintf("Zakupi�e� ��d� - %s [UID: %d, ID: %d].\nJej pozycja zosta�a zaznaczona na mapie.", VehicleNames[model-400], uid, vid));
	                cmd_v(playerid, sprintf("namierz %d", Vehicle[vid][vehicle_uid]));
	                return 1;
	            }

	            new Float:sX, Float:sY, Float:sZ, Float:sA;

	            switch(random(4))
	            {
	            	case 0:
	            	{
	            		sX = 1262.4377;
	            		sY = -1795.4430;
	            		sZ = 13.4183;
	            		sA = 174.84;
	            	}
	            	case 1:
	            	{
	            		sX = 829.7265;
	            		sY = -1211.4872;
	            		sZ = 16.9766;
	            		sA = 199.5065;
	            	}
	            	case 2:
	            	{
	            		sX = 876.3837;
	            		sY = -1271.4150;
	            		sZ = 14.72;
	            		sA = 11.11;
	            	}
	            	case 3:
	            	{
	            		sX = 864.0846;
	            		sY = -1245.2332;
	            		sZ = 14.8807;
	            		sA = 259.4263;
	            	}
	            }

	            mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_vehicles` (vehicle_uid, vehicle_model, vehicle_posx, vehicle_posy, vehicle_posz, vehicle_posa, vehicle_world, vehicle_interior, vehicle_color1, vehicle_color2, vehicle_owner, vehicle_ownertype, vehicle_fuel) VALUES (null, %d, %f, %f, %f, %f, %d, %d, %d, %d, %d, %d, %f)", model, sX, sY, sZ, sA, 0, 0, color, 1, pInfo[playerid][player_id], VEHICLE_OWNER_TYPE_PLAYER, 5.0));
	            new uid = cache_insert_id();
	            new vid = LoadVehicle(sprintf("WHERE `vehicle_uid` = %d", uid), true);

	            SendGuiInformation(playerid, ""guiopis"Powiadomienie", sprintf("Zakupi�e� pojazd %s [UID: %d, ID: %d].\nJego pozycja zosta�a oznaczona na mapie.", VehicleNames[model-400], uid, vid));
	            cmd_v(playerid, sprintf("namierz %d", Vehicle[vid][vehicle_uid]));
			}
		}

		case DIALOG_LUMBERJACK:
		{
			if(!response) return 1;

			if(pInfo[playerid][player_money]<150)
			{
				SendGuiInformation(playerid, "Informacja", "Nie posiadasz wystarczaj�cej ilo�ci got�wki.");
			}
			else
			{
				GivePlayerMoney(playerid,-150);
				Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_DILDO_CHAINSAW, 361, 9, 1, "Pi�a �a�cuchowa");
				SendGuiInformation(playerid, "Informacja", "Przedmiot zosta� nabyty i dodany do ekwipunku.");
			}
		}

		case DIALOG_SALON:
		{
			if(!response) return 1;
			switch(listitem)
			{
				//Trzydrzwiowe
				case 0:
				{
					ListDealership(playerid, CATEGORY_THREEDOORS, "Pojazdy trzydrzwiowe");
				}

				//Pi�ciodrzwiowe
				case 1:
				{
					ListDealership(playerid, CATEGORY_FIVEDOORS, "Pojazdy pi�ciodrzwiowe");
				}

				//Ci�arowe
				case 2:
				{
					ListDealership(playerid, CATEGORY_TRUCKS, "Pojazdy ci�arowe");
				}

				//Jedno�lady
				case 3:
				{
					ListDealership(playerid, CATEGORY_BIKES, "Jedno�lady");
				}

				//Sportowe
				case 4:
				{
					ListDealership(playerid, CATEGORY_SPORT, "Pojazdy sportowe");
				}

				//�odzie
				case 5:
				{
					ListDealership(playerid, CATEGORY_BOATS, "�odzie");
				}

				//Lataj�ce
				case 6:
				{
					ListDealership(playerid, CATEGORY_PLANES, "Pojazdy lataj�ce");
				}

				//Premium
				case 7:
				{
					if(IsPlayerVip(playerid))
					{
						ListDealership(playerid, CATEGORY_PREMIUM, "Pojazdy premium");
					}
					else
					{
						SendGuiInformation(playerid, "Informacja", "Nie posiadasz wykupionej us�ugi unikalnego pojazdu.");
					}
				}
			}
		}

		case DIALOG_CLOTH:
		{
			if(!response) return 1;

			switch(listitem)
			{
				case 0:
				{
					new Float:PosX, Float:PosY, Float:PosZ;
					GetPlayerPos(playerid, PosX, PosY, PosZ);

					GetXYInFrontOfPlayer(playerid, PosX, PosY, 4.0);
					SetPlayerCameraPos(playerid, PosX, PosY, PosZ + 0.30);

					GetPlayerPos(playerid, PosX, PosY, PosZ);
					SetPlayerCameraLookAt(playerid, PosX, PosY, PosZ);

					TogglePlayerControllable(playerid, false);

					pInfo[playerid][player_skin_changing] = true;
					pInfo[playerid][player_skin_id] = 0;

					TextDrawSetString(Tutorial[playerid], "~w~Wybor ubrania ~w~klawisze ~y~~<~ ~>~~n~~k~~PED_JUMPING~ ~w~- anuluje wybor~n~~y~~k~~VEHICLE_ENTER_EXIT~ ~w~- zakup ubrania");
					TextDrawShowForPlayer(playerid, Tutorial[playerid]);
				}
				case 1:
				{
					new Float:PosX, Float:PosY, Float:PosZ;
					GetPlayerPos(playerid, PosX, PosY, PosZ);

					GetXYInFrontOfPlayer(playerid, PosX, PosY, 4.0);
					SetPlayerCameraPos(playerid, PosX, PosY, PosZ + 0.30);

					GetPlayerPos(playerid, PosX, PosY, PosZ);
					SetPlayerCameraLookAt(playerid, PosX, PosY, PosZ);

					TogglePlayerControllable(playerid, false);

					pInfo[playerid][player_access_changing] = true;
					pInfo[playerid][player_access_id] = 0;

					TextDrawSetString(Tutorial[playerid], "~w~Wybor akcesorii ~w~klawisze ~y~~<~ ~>~~n~~k~~PED_JUMPING~ ~w~- anuluje wybor~n~~y~~k~~VEHICLE_ENTER_EXIT~ ~w~- zakup dodatku");
					TextDrawShowForPlayer(playerid, Tutorial[playerid]);
				}
			}
		}

		case DIALOG_MDC:
		{
			if(!response) return 1;
			switch(listitem)
			{
				//Znajdz osobe
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_MDC_FIND_PERSON, DIALOG_STYLE_INPUT, "MDC - find person", "Wpisz imie i nazwisko gracza kt�rego dane chcesz wyszuka�:", "Znajd�", "Wyjd�");
				}
				//Baza DMV
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_MDC_FIND_VEHICLE, DIALOG_STYLE_INPUT, "MDC - DMV database", "Wpisz tablice rejestracyjn� pojazdu, kt�ry chcia�by� wyszuka�:", "Znajd�", "Wyjd�");
				}
				//Zobacz poszukiwanych
				case 2:
				{
					new rows, Cache:tmp_cache, wanted_list[2048];
					tmp_cache = mysql_query(mySQLconnection, "SELECT record_owner, record_reason FROM ipb_crime_records");
					cache_get_row_count(rows);

					if(rows)
					{
						for(new row = 0; row != rows; row++)
						{
							new record_owner[64], record_reason[128];

							cache_get_value_index(row, 0, record_owner);
							cache_get_value_index(row, 1, record_reason);
							
							format(wanted_list, sizeof(wanted_list), "%s%s\t%s\n", wanted_list, record_owner, record_reason);
						}

						format(wanted_list, sizeof(wanted_list), "Poszukiwany\tPow�d\n%s", wanted_list);
						ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_TABLIST_HEADERS, "MDC - crime records", wanted_list, "OK", "");
					}
					else
					{
						SendGuiInformation(playerid, "MDC - crime records", "Brak poszukiwanych w bazie danych.");
					}

					if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
				}
				//Nadaj APB
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_MDC_ADD_APB, DIALOG_STYLE_INPUT, "MDC - add APB", "Wpisz numer rejestracyjny lub imie i nazwisko poszukiwanego.", "Dodaj", "");
				}
				//Anuluj APB
				case 4:
				{
					ShowPlayerDialog(playerid, DIALOG_MDC_REMOVE_APB, DIALOG_STYLE_INPUT, "MDC - remove APB", "Wpisz numer rejestracyjny lub imie i nazwisko poszukiwanego.", "Usu�", "");
				}
				case 5:
				{
					cmd_pb(playerid, "");
				}
			}
		}

		case DIALOG_MDC_ADD_APB:
		{
			if(!response) return 1;

			if(strlen(inputtext) < 4 || strlen(inputtext) > 60)
			{
				SendGuiInformation(playerid, "MDC - add APB", "Nieprawid�owa ilo�� znak�w. Minimum 4, max 60.");
				return 1;
			}

			format(pInfo[playerid][player_dialog_tmp], 64, inputtext);

			ShowPlayerDialog(playerid, DIALOG_MDC_ADD, DIALOG_STYLE_INPUT, "MDC - add APB", "Podaj pow�d dodaania wpisu.", "Dodaj", "Anuluj");
		}

		case DIALOG_MDC_ADD:
		{
			if(!response) return 1;

			if(strlen(inputtext) < 4 || strlen(inputtext) > 60)
			{
				SendGuiInformation(playerid, "MDC - add APB", "Nieprawid�owa ilo�� znak�w. Minimum 4, max 60.");
				return 1;
			}

			mysql_escape_string(inputtext, inputtext, 64);
			mysql_escape_string(pInfo[playerid][player_dialog_tmp], pInfo[playerid][player_dialog_tmp], 64);

			mysql_tquery(mySQLconnection, sprintf("INSERT INTO ipb_crime_records (record_owner, record_reason) VALUES ('%s', '%s')", pInfo[playerid][player_dialog_tmp], inputtext));

			SendGuiInformation(playerid, "Informacja", "Wpis zosta� dodany.");
		}

		case DIALOG_MDC_REMOVE_APB:
		{
			if(!response) return 1;
			if(strval(inputtext) > 32) return ShowPlayerDialog(playerid, DIALOG_MDC_REMOVE_APB, DIALOG_STYLE_INPUT, "MDC - remove APB", "Wpisz numer rejestracyjny lub imie i nazwisko poszukiwanego.", "Usu�", "");
			mysql_escape_string(inputtext, inputtext, 64);
			mysql_tquery(mySQLconnection, sprintf("DELETE FROM ipb_crime_records WHERE record_owner = '%s'", inputtext));
			SendGuiInformation(playerid, "Informacja", "Wpis zosta� usuni�ty.");
		}

		case DIALOG_MDC_FIND_PERSON:
		{
			if(!response) return 1;

			new rows, Cache:tmp_cache, suspect[MAX_PLAYER_NAME+1];

			if(strlen(inputtext) < 4)
			{
				SendGuiInformation(playerid, "MDC - find person", "Podano zbyt ma�o znak�w.");
				return 1;
			}

			mysql_escape_string(inputtext, suspect, 256);
			tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT char_birth, char_documents, char_spawn, char_spawn_type, char_uid FROM ipb_characters WHERE `char_name` = '%s' LIMIT 1", suspect));
			cache_get_row_count(rows);

			if(rows)
			{
				new adress[40], list_mdc[768], list_cars[256];

				strreplace(suspect, '_', ' ');

				new age, doc, door, spawntype, jail, mdc_records, driver, driverlic[5];
				cache_get_value_index_int(0, 0, age);
				cache_get_value_index_int(0, 1, doc);
				cache_get_value_index_int(0, 2, door);
				cache_get_value_index_int(0, 3, spawntype);
				cache_get_value_index_int(0, 4, driver);

				age = 2016 - age;
				jail = 0;
				mdc_records = 0;

				if(spawntype > 2 && spawntype <=4)
				{
					new d_id = GetDoorByUid(door);
					if(d_id != -1)
					{
						format(adress, sizeof(adress), "%s", Door[d_id][door_name]);
					}
				}
				else
				{
					format(adress, sizeof(adress), "brak");
				}

				if((doc & DOCUMENT_DRIVE))
				{
					format(driverlic, sizeof(driverlic), "tak");
				}	
				else
				{
					format(driverlic, sizeof(driverlic), "brak");
				}

				if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);

				new carrows, Cache:car_cache;
				car_cache = mysql_query(mySQLconnection, sprintf("SELECT vehicle_model, vehicle_register FROM ipb_vehicles WHERE `vehicle_ownertype` = '1' AND `vehicle_owner` = '%d' ", driver));
				cache_get_row_count(carrows);

				if(carrows)
				{
					for(new row = 0; row != carrows; row++)
					{
						new register[10];
						new model;
						cache_get_value_index_int(row, 0, model);
						cache_get_value_index(row, 1, register);
						format(list_cars, sizeof(list_cars), "%s~g~~h~%s~w~ - %s~n~", list_cars, VehicleNames[model-400], register);
					}
				}
				else
				{
					format(list_cars, sizeof(list_cars), "~g~~h~ brak~w~~n~");
				}

				if(cache_is_valid(car_cache)) cache_delete(car_cache);
				format(list_mdc, sizeof(list_mdc), "~p~Mobile~w~ Data Computer~n~~n~Imie i nazwisko: %s~n~Wiek: %d~n~Adres: %s~n~Ilosc odsiadek: %d~n~Ilosc wpisow: %d~n~Prawo jazdy: %s~n~~n~~b~~h~Pojazdy:~n~%s", suspect, age, adress, jail, mdc_records, driverlic, list_cars);
				TextDrawSetString(Tutorial[playerid], list_mdc);
				TextDrawShowForPlayer(playerid, Tutorial[playerid]);
			}
			else
			{
				SendGuiInformation(playerid, "MDC - find person", "Nie znaleziono danych dotycz�cych tego imienia i nazwiska.");
			}
		}

		case DIALOG_MDC_FIND_VEHICLE:
		{
			if(!response) return 1;

			new rows, Cache:tmp_cache, register[10];

			if(strlen(inputtext) < 2 || strlen(inputtext) >= 10)
			{
				SendGuiInformation(playerid, "MDC - find vehicle", "Nieprawid�owa ilo�� znak�w.");
				return 1;
			}

			mysql_escape_string(inputtext, register, 256);
			tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT vehicle_model, vehicle_color1, vehicle_color2, vehicle_ownertype, vehicle_owner FROM ipb_vehicles WHERE `vehicle_register` = '%s' LIMIT 1", register));
			cache_get_row_count(rows);

			if(rows)
			{
				new list_mdc[768], ownerdata[64];
				new model, color1, color2, ownertype, owner, wanted[32];

				cache_get_value_index_int(0, 0, model);
				cache_get_value_index_int(0, 1, color1);
				cache_get_value_index_int(0, 2, color2);
				cache_get_value_index_int(0, 3, ownertype);
				cache_get_value_index_int(0, 4, owner);

				if(ownertype != 0)
				{
					if(ownertype == VEHICLE_OWNER_TYPE_GROUP)
					{
						new gid = GetGroupByUid(owner);
						if(gid == -1) return format(ownerdata, sizeof(ownerdata), "brak");
						format(ownerdata, sizeof(ownerdata), "%s", Group[gid][group_name]);
					}
					else if(ownertype == VEHICLE_OWNER_TYPE_PLAYER)
					{
						new prows, Cache:pcache, ownername[32];
						pcache = mysql_query(mySQLconnection, sprintf("SELECT char_name FROM ipb_characters WHERE char_uid = '%d' LIMIT 1", owner));
						cache_get_row_count(prows);

						if(prows)
						{
							cache_get_value_index(0, 0, ownername);
							format(ownerdata, sizeof(ownerdata), "%s", ownername);
						}
						else
						{
							format(ownerdata, sizeof(ownerdata), "brak");
						}

						if(cache_is_valid(pcache)) cache_delete(pcache);
					}
				}
				else
				{
					format(ownerdata, sizeof(ownerdata), "brak");
				}

				format(wanted, sizeof(wanted), "nie");
				format(list_mdc, sizeof(list_mdc), "~p~Mobile~w~ Data Computer~n~~n~Model pojazdu: %s~n~Kolory: %d/%d~n~Wlasciciel: %s~n~Poszukiwany: %s", VehicleNames[model-400], color1, color2, ownerdata, wanted);
				TextDrawSetString(Tutorial[playerid], list_mdc);
				TextDrawShowForPlayer(playerid, Tutorial[playerid]);
			}
			else
			{
				SendGuiInformation(playerid, "MDC - find vehicle", "Nie znaleziono danych dotycz�cych tych tablic.");
			}

			if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
		}

		case DIALOG_WHEELBLOCK:
		{
			if(!response) return 1;
			new vid = GetPlayerVehicleID(playerid);
			if(vid == INVALID_VEHICLE_ID) return 1;

			new amount = Vehicle[vid][vehicle_blocked];
			if(amount)
			{
				if(pInfo[playerid][player_money] < amount) return  SendGuiInformation(playerid, "Informacja", "Nie posiadasz wystarczaj�cej ilo�ci got�wki.");
				Vehicle[vid][vehicle_blocked] = 0;
				mysql_query(mySQLconnection, sprintf("UPDATE `ipb_vehicles` SET `vehicle_blockwheel` = 0 WHERE `vehicle_uid` = %d", Vehicle[vid][vehicle_uid]));
				GivePlayerMoney(playerid, -amount);
				SendGuiInformation(playerid, "Informacja", "Blokada zosta�a pomy�lnie zdj�ta.");
			}
		}

		case DIALOG_WHISPER:
		{
			if(!response) return 1;
			if(!strlen(inputtext)) return SendGuiInformation(playerid, "Informacja", "Wiadomo�� nie mo�e by� pusta.");
			if(strlen(inputtext) > 120) return SendGuiInformation(playerid, "Informacja", "Przekroczono dozwolon� ilo�� znak�w.");
			
			new clickedid = pInfo[playerid][player_dialog_tmp1];
			pInfo[playerid][player_dialog_tmp1] = 0;
			return cmd_whisper(playerid, sprintf("%d %s",  clickedid, inputtext));
		}
		
		case DIALOG_SPAWN_CHOICE:
		{
			if(!response) return 1;
			new d_id = DynamicGui_GetValue(playerid, listitem);
			if(d_id < 0) return SendGuiInformation(playerid, "Informacja", "Wyst�pi� problem z twoimi drzwiami, zg�o� to do administracji.");
			pInfo[playerid][player_spawn] = Door[d_id][door_uid];
			pInfo[playerid][player_spawn_type] = SPAWN_TYPE_HOUSE;
			mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_spawn = %d, char_spawn_type = %d WHERE char_uid = %d", Door[d_id][door_uid], SPAWN_TYPE_HOUSE, pInfo[playerid][player_id]));
			SendGuiInformation(playerid, "Informacja", sprintf("Pomy�lnie ustawiono nowy spawn.\nOd teraz b�dziesz spawnowa� si� w drzwiach %s.", Door[d_id][door_name]));
		}

		case DIALOG_STATS:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 16:
				{
					new rows, Cache:tmp_cache, list_anims[256];
					tmp_cache = mysql_query(mySQLconnection, "SELECT anim_command, anim_uid FROM ipb_anim WHERE anim_command LIKE '.idz%' ORDER BY `anim_command` ASC");
					
					cache_get_row_count(rows);
					
					DynamicGui_Init(playerid);					
					format(list_anims, sizeof(list_anims), "> Wy��cz animacje chodzenia\n");
					DynamicGui_AddBlankRow(playerid);

					for(new row = 0; row != rows; row++)
					{
						new tmp[30], uid;
						cache_get_value_index_int(row, 1, uid);
						cache_get_value_index(row, 0, tmp);
						
						format(list_anims, sizeof(list_anims), "%s%s\n", list_anims, tmp);
						DynamicGui_AddRow(playerid, uid);
					}

					if(strlen(list_anims) > 0)
					{
						ShowPlayerDialog(playerid, DIALOG_WALKING_ANIM, DIALOG_STYLE_LIST, "Wyb�r animacji chodzenia", list_anims, "Wybierz", "Anuluj");
					}
					else
					{
						SendGuiInformation(playerid, "Informacja", "Nie znaleziono �adnych animacji chodzenia.");
					}

					if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
					return 1;
				}
				case 17:
				{
					switch(pInfo[playerid][player_editor])
					{
						case OBJECT_EDITOR_CUSTOM:
						{
							pInfo[playerid][player_editor] = OBJECT_EDITOR_SAMP;
							mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_editor = %d WHERE char_uid = %d", OBJECT_EDITOR_SAMP, pInfo[playerid][player_id]));
							SendGuiInformation(playerid, "Informacja", "Edytor obiekt�w zosta� zmieniony na domy�lny (SAMP).");
						}
						case OBJECT_EDITOR_SAMP:
						{
							pInfo[playerid][player_editor] = OBJECT_EDITOR_CUSTOM;
							mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_editor = %d WHERE char_uid = %d", OBJECT_EDITOR_CUSTOM, pInfo[playerid][player_id]));
							SendGuiInformation(playerid, "Informacja", "Edytor obiekt�w zosta� zmieniony na customowy (klawisze).");
						}
					}
				}
				case 18:
				{
					if(pInfo[playerid][player_widescreen])
					{
						SendGuiInformation(playerid, "Informacja", "Wide screen fix mode zosta� wy��czony.\nPrzeloguj si� (/login) aby prze�adowa� textdrawy.");
						pInfo[playerid][player_widescreen] = 0;
						mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_widescreen = 0 WHERE char_uid = %d", pInfo[playerid][player_id]));
					}
					else
					{
						SetPlayerProgressBarWidth(playerid, pInfo[playerid][player_health_bar], 38.0);
						SetPlayerProgressBarHeight(playerid, pInfo[playerid][player_health_bar], 0.1);
						SetPlayerProgressBarPos(playerid, pInfo[playerid][player_health_bar], 583.0, 56.0);
						SetPlayerProgressBarValue(playerid, pInfo[playerid][player_health_bar], pInfo[playerid][player_health]);

						/*PlayerTextDrawDestroy(playerid, ZoneName[playerid]);

						ZoneName[playerid] = CreatePlayerTextDraw(playerid, 548, 80, "Idlewood");
						PlayerTextDrawBackgroundColor(playerid, ZoneName[playerid], 255);
						PlayerTextDrawFont(playerid, ZoneName[playerid], 3);
						PlayerTextDrawLetterSize(playerid, ZoneName[playerid], 0.310000, 1.0);
						PlayerTextDrawColor(playerid, ZoneName[playerid], -1);
						PlayerTextDrawSetOutline(playerid, ZoneName[playerid], 1);
						PlayerTextDrawSetProportional(playerid, ZoneName[playerid], 1);

						PlayerTextDrawShow(playerid, ZoneName[playerid]);*/

						SendGuiInformation(playerid, "Informacja", "Wide screen fix mode zosta� uruchomiony i zapisany.\nOd teraz przy ka�dym logowaniu twoje textdrawy b�d� mia�y pozycje odpowiedni� do modyfikacji.");
						pInfo[playerid][player_widescreen] = 1;
						mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_widescreen = 1 WHERE char_uid = %d", pInfo[playerid][player_id]));
					}
				}
				case 19:
				{
					mysql_tquery(mySQLconnection, sprintf("SELECT * FROM ipb_char_spawns WHERE spawn_owner = %d", pInfo[playerid][player_id]), "OnPlayerListSpawns", "d", playerid);
				}
				case 20:
				{
					ShowPlayerDialog(playerid, DIALOG_GROUP_CREATOR, DIALOG_STYLE_MSGBOX, "Kreator organizacji", "Zanim za�o�ysz grup� przest�pcz�, upewnij si�, �e spe�niasz poni�sze wymagania:\n\n{D6EE76}- 500GS\n- 10h na postaci\n- 1 budynek w neutralnej strefie\n- 5 member�w", "Za��", "Anuluj");
				}
			}
		}

		case DIALOG_GOV:
		{
			if(!response) return 1;

			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_GOV_CREATOR, DIALOG_STYLE_MSGBOX, "Kreator biznesu", "Zanim za�o�ysz w�asny biznes upewnij si�, �e spe�niasz poni�sze wymagania:\n\n{D6EE76}- 500GS\n- 20h na postaci\n- budynek\n- $9500 - koszt za�o�enia firmy", "Za��", "Anuluj");
				}
				case 1:
				{
					if(pInfo[playerid][player_duty_gid] == -1) return SendGuiInformation(playerid, "Informacja", "Aby op�aci� podatek za prowadzenie firmy, wejd� na s�u�b� grupy.");
					new gid = pInfo[playerid][player_duty_gid];

					if(!GroupHasFlag(gid, GROUP_FLAG_BUSINESS)) return SendGuiInformation(playerid, "Informacja", "Grupa na kt�rej jeste� s�u�bie nie jest biznesem.\nNie musisz p�aci� za ni� podatku.");

					if(gettime() - Group[gid][group_last_tax] < 2160000)
					{
						new next_tax = Group[gid][group_last_tax] + 30*86400;
						new taxyear, taxmonth, taxday, temp;
						TimestampToDate(next_tax, taxyear, taxmonth, taxday, temp, temp, temp, 1);
						SendGuiInformation(playerid, "Informacja", sprintf("Podatek mo�esz op�aci� tylko w ci�gu ostatnich pi�ciu dni do terminu jego up�ywu.\nTermin up�ywu: %02d/%02d/%d", taxday, taxmonth, taxyear));
						return 1;
					}

					if(pInfo[playerid][player_money] < 5000) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz przy sobie odpowiedniej ilo�ci got�wki ($5000).");
					GivePlayerMoney(playerid, -5000);
					Group[gid][group_last_tax] = gettime();
					mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_last_tax = %d WHERE group_uid = %d", Group[gid][group_last_tax], Group[gid][group_uid]));

					SendGuiInformation(playerid, "Informacja", "Podatek zosta� pomy�lnie op�acony na miesi�c.\nNast�pny mo�esz op�aci� za 25 dni.\n\nPodatki mog� op�aca� dowolni memberzy grupy.");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_DOCUMENTS, DIALOG_STYLE_TABLIST, "Wybierz dokument", "1. Dow�d osobisty\t$50\n2. Prawo jazdy\t$150", "Wyr�b", "Anuluj");
				}
			}
		}

		case DIALOG_GOV_CREATOR:
		{
			if(!response) return 1;
			if(pGlobal[playerid][glo_score] < 500) return SendGuiInformation(playerid, "Informacja", "Aby za�o�y� biznes wymagane jest 500 game score.");
			if(pInfo[playerid][player_hours] < 20) return SendGuiInformation(playerid, "Informacja", "Twoja posta� nie przegra�a jeszcze 20h.");
			if(HasPlayerBuilding(playerid) < 1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz �adnego budynku podpisanego pod swoj� posta�.\nJest on wymagany do za�o�enia grupy.");
			if(pInfo[playerid][player_last_creator] + 7*86400 > gettime()) return SendGuiInformation(playerid, "Informacja", "Zak�ada�e� ju� grup� w tym tygodniu.");
			if(pInfo[playerid][player_bank_money] < 9500) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz $9500 na swoim koncie bankowym.");

			ShowPlayerDialog(playerid, DIALOG_GOV_CREATE, DIALOG_STYLE_TABLIST_HEADERS, "Wybierz typ dzia�alno�ci", "Typ biznesu\tKoszt licencji\n1. Gastronomia\t$8000\n2. Radiostacja\t$10000\n3. Warsztat\t$8000\n4. Si�ownia\t$8000\n5. Firma ochroniarska\t$12000\n6. Firma taks�wkarska\t$10000\nKasyno\t$30000", "Za��", "Anuluj");
		}

		case DIALOG_GOV_CREATE:
		{
			if(!response) return 1;

			new g_type, cost;

			switch(listitem)
			{
				case 0:
				{
					g_type = 7;
					cost = 8000;
				}
				case 1: 
				{
					g_type = 3;
					cost = 10000;
				}
				case 2:
				{
					g_type = 9;
					cost = 8000;
				}
				case 3:
				{
					g_type = 10;
					cost = 8000;
				}
				case 4:
				{
					g_type = 4;
					cost = 12000;
				}
				case 5:
				{
					g_type = 8;
					cost = 10000;
				}
				case 6:
				{
					g_type = GROUP_TYPE_CASINO;
					cost = 30000;
				}
			}

			if(pInfo[playerid][player_bank_money] < cost) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz odpowiedniej ilo�ci got�wki na swoim koncie bankowym.");

			pInfo[playerid][player_dialog_tmp1] = g_type;
			pInfo[playerid][player_dialog_tmp2] = cost;
			ShowPlayerDialog(playerid, DIALOG_GOV_NAME, DIALOG_STYLE_INPUT, "Kreator biznesu", "Podaj nazw� dla swojej grupy.\nPami�taj, �e nie mo�na b�dzie jej zmieni�.", "Za��", "Anuluj");
		}

		case DIALOG_GOV_NAME:
		{
			if(!response) return 1;
			if(strlen(inputtext) > 60 || !strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_GOV_NAME, DIALOG_STYLE_INPUT, "Kreator biznesu", "Podaj nazw� dla swojej grupy.\nPami�taj, �e nie mo�na b�dzie jej zmieni�.", "Za��", "Anuluj");

			new name[64];
			format(name, sizeof(name), "%s", inputtext);

			new free_slot = GetPlayerGroupFreeSlot(playerid);
			if( free_slot == -1 ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz wolnego slota grupy.");

			new found;
			foreach(new g_id: Groups)
			{
				if( !strcmp(Group[g_id][group_name], name) ) found = 1;
			}

			if(found)
			{
				SendGuiInformation(playerid, "Informacja", "Na serwerze istnieje ju� grupa o takiej nazwie.");
				return 1;
			}

			mysql_escape_string(name, name);
			mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_game_groups` (group_uid, group_name, group_tag, group_created, group_type, group_creator, group_last_tax) VALUES (null, '%s', 'TAG', %d, %d, %d, %d)", name, gettime(), pInfo[playerid][player_dialog_tmp1], pInfo[playerid][player_id], gettime()));
			
			new gid = Iter_Free(Groups);

			if( cache_insert_id() )
			{
				Iter_Add(Groups, gid);
				
				Group[gid][group_uid] = cache_insert_id();
				Group[gid][group_bank_money] = 0;
				Group[gid][group_temp] = 0;
				Group[gid][group_type] = pInfo[playerid][player_dialog_tmp1];
				Group[gid][group_last_tax] = gettime();
				Group[gid][group_creator] = pInfo[playerid][player_id];
				Group[gid][group_flags] = GroupDefaultFlags[pInfo[playerid][player_dialog_tmp1]];
				Group[gid][group_color] = 0xFFFFFFFF;
				
				strcopy(Group[gid][group_name], name);
			}

			mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_char_groups` (char_uid, group_belongs, group_perm) VALUES (%d, %d, %d)", pInfo[playerid][player_id], Group[gid][group_uid], 63));
			
			pGroup[playerid][free_slot][pg_id] = gid;
			pGroup[playerid][free_slot][pg_rank_perm] = 63;
			SendPlayerInformation(playerid, sprintf("Utworzono grupe ~y~%s~w~.~n~Pamietaj o oplacaniu comiesiecznego podatku, aby nie zostala skasowana. W panelu na forum ustaw dla niej tag oraz kolor.", Group[gid][group_name]), 20000);

			mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_last_creator = %d WHERE char_uid = %d", gettime(), pInfo[playerid][player_id]));
			pInfo[playerid][player_last_creator] = gettime();

			pInfo[playerid][player_dialog_tmp1] = 0;
			AddPlayerBankMoney(playerid, pInfo[playerid][player_dialog_tmp2]);
			pInfo[playerid][player_dialog_tmp2] = 0;
			if(!PlayerHasAchievement(playerid, ACHIEV_BLEADER)) AddAchievement(playerid, ACHIEV_BLEADER, 500);
		}

		case DIALOG_GROUP_CREATOR:
		{
			if(!response) return 1;
			if(pGlobal[playerid][glo_score] < 500) return SendGuiInformation(playerid, "Informacja", "Aby za�o�y� organizacje przest�pcz� wymagane jest 500 game score.");
			if(pInfo[playerid][player_hours] < 10) return SendGuiInformation(playerid, "Informacja", "Twoja posta� nie przegra�a jeszcze 10h.");

			if(!IsPlayerInAnyVehicle(playerid)) return SendGuiInformation(playerid, "Informacja", "Do za�o�enia organizacji przest�pczej wymagany jest jeden pojazd.\nWsi�d� do niego zanim spr�bujesz ponownie.");
			new vid = GetPlayerVehicleID(playerid);
			if(!IsValidVehicle(vid)) return SendGuiInformation(playerid, "Informacja", "Do za�o�enia organizacji przest�pczej wymagany jest jeden pojazd.\nWsi�d� do niego zanim spr�bujesz ponownie.");
			if(Vehicle[vid][vehicle_owner_type] != VEHICLE_OWNER_TYPE_PLAYER) return SendGuiInformation(playerid, "Informacja", "Do za�o�enia organizacji przest�pczej wymagany jest jeden pojazd.\nTen nie nale�y do ciebie.");
			if(Vehicle[vid][vehicle_owner] != pInfo[playerid][player_id]) return SendGuiInformation(playerid, "Informacja", "Do za�o�enia organizacji przest�pczej wymagany jest jeden pojazd.\nTen nie nale�y do ciebie.");
			if(IsVehicleBike(vid)) return SendGuiInformation(playerid, "Informacja", "Pojazd nie mo�e by� skuterem/rowerem.");

			if(!IsValidDynamicArea(pInfo[playerid][player_area])) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz si� w �adnej strefie.\nUdaj si� do strefy, w kt�rej masz zamiar za�o�y� grup�.");
			if(Area[pInfo[playerid][player_area]][area_owner_type] != AREA_OWNER_TYPE_GLOBAL) return SendGuiInformation(playerid, "Informacja", "Strefa w kt�rej si� znajdujesz nie jest neutralna, nie mo�esz za�o�y� tutaj grupy.");
			if(HasPlayerBuildingInArea(playerid) < 1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz budynku w strefie, w kt�rej si� znajdujesz.\nJest on wymagany do przej�cia strefy, a co za tym idzie za�o�enia grupy.");
			if(IsPlayerCrimeOwner(playerid)) return SendGuiInformation(playerid, "Informacja", "Jeste� ju� ownerem grupy przest�pczej.");
			if(pInfo[playerid][player_last_creator] + 7*86400 > gettime()) return SendGuiInformation(playerid, "Informacja", "Zak�ada�e� ju� grup� w tym tygodniu.");
			
			pInfo[playerid][player_dialog_tmp1] = vid;
			
			ShowPlayerDialog(playerid, DIALOG_GROUP_NAME, DIALOG_STYLE_INPUT, "Kreator organizacji", "Podaj nazw� dla swojej grupy.\nPami�taj, �e nie mo�na b�dzie jej zmieni�.", "Za��", "Anuluj");
		}

		case DIALOG_GROUP_NAME:
		{
			if(!response) return 1;
			if(strlen(inputtext) > 60 || !strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_GROUP_NAME, DIALOG_STYLE_INPUT, "Kreator organizacji", "Podaj nazw� dla swojej grupy. Pami�taj, �e nie mo�na b�dzie jej zmieni�.", "Za��", "Anuluj");

			new name[64];
			format(name, sizeof(name), "%s", inputtext);

			new free_slot = GetPlayerGroupFreeSlot(playerid);
			if( free_slot == -1 ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz wolnego slota grupy.");

			new found;
			foreach(new g_id: Groups)
			{
				if( !strcmp(Group[g_id][group_name], name) ) found = 1;
			}

			if(found)
			{
				SendGuiInformation(playerid, "Informacja", "Na serwerze istnieje ju� grupa o takiej nazwie.");
				return 1;
			}

			mysql_escape_string(name, name);
			mysql_query(mySQLconnection, sprintf("INSERT INTO `ipb_game_groups` (group_uid, group_name, group_tag, group_created, group_temp, group_creator) VALUES (null, '%s', 'TAG', %d, 1, %d)", name, gettime(), pInfo[playerid][player_id]));
			
			new gid = Iter_Free(Groups);

			if( cache_insert_id() )
			{
				Iter_Add(Groups, gid);
				
				Group[gid][group_uid] = cache_insert_id();
				Group[gid][group_bank_money] = 0;
				Group[gid][group_temp] = 1;
				Group[gid][group_creator] = pInfo[playerid][player_id];
				Group[gid][group_color] = 0xFFFFFFFF;
				
				strcopy(Group[gid][group_tag], "TAG");
				strcopy(Group[gid][group_name], name);
			}
			
			if(IsValidVehicle(pInfo[playerid][player_dialog_tmp1]))
			{
				new vid = pInfo[playerid][player_dialog_tmp1];

				Vehicle[vid][vehicle_owner_type] = VEHICLE_OWNER_TYPE_GROUP;
				Vehicle[vid][vehicle_owner] = Group[gid][group_uid];
				mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_vehicles SET vehicle_owner = %d, vehicle_ownertype = %d WHERE vehicle_uid = %d", Vehicle[vid][vehicle_owner], Vehicle[vid][vehicle_owner_type], Vehicle[vid][vehicle_uid]));
				pInfo[playerid][player_dialog_tmp1] = 0;
			}

			mysql_tquery(mySQLconnection, sprintf("INSERT INTO `ipb_char_groups` (char_uid, group_belongs, group_perm) VALUES (%d, %d, %d)", pInfo[playerid][player_id], Group[gid][group_uid], 63));
			
			pGroup[playerid][free_slot][pg_id] = gid;
			pGroup[playerid][free_slot][pg_rank_perm] = 63;
			SendPlayerInformation(playerid, sprintf("Utworzono grupe ~y~%s~w~.\n\nAby grupa nie zostala skasowana po restarcie serwera, przyjmij do niej przynajmniej ~y~5 osob~w~ oraz zdobadz ~g~~h~strefe~w~. Przypisano takze podstawowe produkty, ktore pojawia sie po akceptacji.", Group[gid][group_name]), 20000);

			mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_last_creator = %d WHERE char_uid = %d", gettime(), pInfo[playerid][player_id]));
			pInfo[playerid][player_last_creator] = gettime();

			new str[500];

			strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
			strcat(str, sprintf("VALUES (%d, 'MDMA', 40, 7, 1, 1575, %d, 150)", ITEM_TYPE_DRUG, Group[gid][group_uid]));
			mysql_tquery(mySQLconnection, str);

			format(str, sizeof(str), "");
			strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
			strcat(str, sprintf("VALUES (%d, 'Glock 19', 950, 22, 40, 346, %d, 10)", ITEM_TYPE_WEAPON, Group[gid][group_uid]));
			mysql_tquery(mySQLconnection, str);

			format(str, sizeof(str), "");
			strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
			strcat(str, sprintf("VALUES (%d, 'Amunicja (bron krotka)', 420, 2, 40, 19995, %d, 15)", ITEM_TYPE_AMMO, Group[gid][group_uid]));
			mysql_tquery(mySQLconnection, str);

			format(str, sizeof(str), "");
			strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
			strcat(str, sprintf("VALUES (%d, 'Pseudoefedryna', 140, 1, 1, 1575, %d, 40)", ITEM_TYPE_CHEMISTRY, Group[gid][group_uid]));
			mysql_tquery(mySQLconnection, str);

			format(str, sizeof(str), "");
			strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
			strcat(str, sprintf("VALUES (%d, 'Fenyloaceton', 80, 2, 1, 1575, %d, 40)", ITEM_TYPE_CHEMISTRY, Group[gid][group_uid]));
			mysql_tquery(mySQLconnection, str);

			format(str, sizeof(str), "");
			strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
			strcat(str, sprintf("VALUES (%d, 'Sprzet laboratoryjny (meta)', 12500, 16, 1, 1575, %d, 1)", ITEM_TYPE_DOOR_ACCESS, Group[gid][group_uid]));
			mysql_tquery(mySQLconnection, str);

			format(str, sizeof(str), "");
			strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
			strcat(str, sprintf("VALUES (%d, 'Sprzet laboratoryjny (amfetamina)', 7500, 32, 1, 1575, %d, 1)", ITEM_TYPE_DOOR_ACCESS, Group[gid][group_uid]));
			mysql_tquery(mySQLconnection, str);

			format(str, sizeof(str), "");
			strcat(str, "INSERT INTO ipb_products (product_type, product_name, product_price, product_value1, product_value2, product_model, product_group, product_limit_count) ");
			strcat(str, sprintf("VALUES (%d, 'Sprzet laboratoryjny (crack)', 5000, 64, 1, 1575, %d, 1)", ITEM_TYPE_DOOR_ACCESS, Group[gid][group_uid]));
			mysql_tquery(mySQLconnection, str);

			if(!PlayerHasAchievement(playerid, ACHIEV_LEADER)) AddAchievement(playerid, ACHIEV_LEADER, 500);
		}

		case DIALOG_WALKING_ANIM:
		{
			if(response)
		    {
		    	if(listitem == 0)
		    	{
		    		SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Animacja chodzenia zosta�a wy��czona.");

					pInfo[playerid][player_walking_anim]=0;
					mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_walking_anim = 0 WHERE char_uid = %d", pInfo[playerid][player_id]));
					return 1;
		    	}

		        new anim_uid = DynamicGui_GetValue(playerid, listitem), rows, Cache:tmp_cache;
		        tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM `ipb_anim` WHERE `anim_uid` = '%d'", anim_uid));
				cache_get_row_count(rows);
				
				if(rows)
				{
					cache_get_value_index_int(0, 0, pInfo[playerid][player_walking_anim]);
					cache_get_value_index(0, 2, pInfo[playerid][player_walking_lib], 32);
					cache_get_value_index(0, 3, pInfo[playerid][player_walking_name], 32);
					SendPlayerInformation(playerid, "~w~Animacja chodzenia zostala ~p~wybrana~w~.");
					mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_walking_anim` = %d, `char_walking_lib` = '%s', `char_walking_name`= '%s'  WHERE `char_uid` = %d", pInfo[playerid][player_walking_anim], pInfo[playerid][player_walking_lib], pInfo[playerid][player_walking_name], pInfo[playerid][player_id]));
				}
				else
				{
					PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
				}

				if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
		        return 1;
		    }
		    else
		    {
		        return 1;
		    }
		}
		
		case DIALOG_HELP:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0:
				{
					SendGuiInformation(playerid,""guiopis"Jak zacz��", "Witaj. Wygl�da na to, �e potrzebujesz informacji odno�nie rozgrywki.\n\nNiedaleko znajduje si� przystanek. Mo�esz go u�y�, by dojecha� np. do centrum lub urz�du.\nD�ugo�� podr�y zale�na jest od d�ugo�ci do pokonania. Je�eli wolisz u�ywa� taks�wek, kup telefon w sklepie 24/7.");
				}
				case 1:
				{
					new dialog_help[512];
					format(dialog_help, sizeof(dialog_help), "%s Pami�taj, �e RolePlay polega na odgrywaniu realnego �ycia postaci, kt�r� stworzy�e�(a�).\n1. Wyobra� sobie, �e jeste� aktorem, kt�ry gra t� posta� w serialu. Na tym polega RolePlay.\n", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%s 2. Aktor nie wie wszystkiego o postaci i jej wirtualnym �wiecie. Zna te� innych aktor�w (graczy), kt�rzy graj� inne postacie.\n", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%s 3. Posta� NIE wie wszystkiego tego, co aktor, i nie zna wszystkich pozosta�ych postaci. Ona poprostu �yje w mie�cie.\n", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%s 4. Wy - gracze/aktorzy - i wszystko, co wiecie lub piszecie mi�dzy sob�, to informacje OOC. Realny �wiat to jest OOC.\n", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%s 5. Gdy wypowiadasz si� jako posta� (do innej wirtualnej postaci), b�d� wykonujesz ni� jak�� czynno��, robisz to IC.\n", dialog_help);
					
					return SendGuiInformation(playerid,""guiopis"OOC i IC", dialog_help);
				}
				case 2:
				{
					new dialog_help[512];
					format(dialog_help, sizeof(dialog_help), "%s 1. /me (opis czynno�ci), /do (opis otoczenia), /w (wiadomo��), /re (odpowied�), /k(rzycz), /s(zept), /stats, /p (przedmioty), /g (grupy)\n", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%s 2. /v (pojazdy), /o (oferty), /drzwi /b, /drzwi, /plac, /tankuj, /przejazd, /bank, /tog, /pokaz\n", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%s 3. /kup, /akceptujsmierc, /a, /pomoc, /anim(acje) /drzwi zamknij, /opis, /wyrzuc.", dialog_help);
					
					return SendGuiInformation(playerid,""guiopis"Podstawowe Komendy", dialog_help);
				}
				case 3:
				{
					new dialog_help[512];
					format(dialog_help, sizeof(dialog_help), "%sNa naszym serwerze, animacje (jak ka�da inna funkcja) s� zarz�dzane dynamiczne\ni administracja mo�e modyfikowa� ich zestaw bezpo�rednio na serwerze.\nWraz z wprowadzeniem tego systemu, zmieni� si� troche spos�b u�ywania animacji.\n\n", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%sS� dwie drogi, by u�y� animacji. Mo�esz wybra� j� z listy (/anim) lub wpisa� w okno czatu wybran� metod�.\n*\t.animacja\n\n", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%sZatem wpisanie '.idz2' to to samo, co wybranie jej z listy. To od Ciebie zale�y, kt�ry spos�b wybierzesz.", dialog_help);
					SendGuiInformation(playerid,""guiopis"Animacje", dialog_help);
					
				}
				case 4:
				{
					return SendGuiInformation(playerid,""guiopis"Pojazdy", "Na naszym serwerze mo�esz posiada� dowoln� ilo�� pojazd�w. Wpisz /v, aby zespawnowa� lub odspawnowa� dowolny z pojazd�w.\n\n!!U�yj /v namierz, gdy nie widzisz swojego pojazdu. Pozwoli Ci to zlokalizowa� go, ustawiaj�c\nczerwony marker na mapie.");
				}
				case 5:
				{
					return SendGuiInformation(playerid,""guiopis"Przedmioty", "Przedmioty mo�na zakupi� od innych graczy, w ich firmach lub sklepach 24/7.\nAby wylistowa� posiadane przedmioty u�yj komendy /p.\nZ jej pomoc� mo�esz podnosi� przedmioty znajduj�ce si� na ziemi.");
				}
				case 6:
				{
					return SendGuiInformation(playerid,""guiopis"Oferty", "Oferty umo�liwiaj� sk�adanie graczom ofert us�ug. Dzi�ki nim masz pewno��, �e gracz zap�aci\nza dan� us�ug�. Wpisz /o, aby sprawdzi� jakie mo�esz sk�ada� oferty lub /o [us�uga] [gracz] [dodatkowe parametry], by z�o�y� ofert�.");
				}
				case 7:
				{
					new dialog_help[512];
					format(dialog_help, sizeof(dialog_help), "%sListy Twoich grup (i sloty): /g\n*\tWypowiedzi poprzedza si� komend� /r(In Character) /ro(Out Of Character).\n", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%s*\tKomenda /r(adio) odpowiada za czat grupy In Character, u�ywasz tej komendy aby przekaza� informacje ze �wiata gry!\n\n", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%s*\tKomenda /ro(adio) odpowiada za czat grupy Out Of Character, czyli u�yjesz tej komendy aby przekaza� informacje po za �wiatem gry!\n\n", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%s/ro 1 Cze��! - Napisze wiadomo�� OOC do ca�ej grupy w slocie 1.", dialog_help);
					format(dialog_help, sizeof(dialog_help), "%s/r 2 Cze��! - Napisze wiadomo�� IC do ca�ej grupy w slocie 2.", dialog_help);
					
					return SendGuiInformation(playerid,""guiopis"Czaty grupowe", dialog_help);
					
				}
				case 8:
				{
					new dialog_help[512];
					format(dialog_help, sizeof(dialog_help), "%s /mc (Dodawanie), /md (Usuwanie) /msel (Edytowanie) /msave (Zapisywanie)\n", dialog_help);
					
					return SendGuiInformation(playerid,""guiopis"System Obiekt�w", dialog_help);
				}
				case 9:
				{
					switch(pInfo[playerid][player_job])
					{
						case WORK_TYPE_TRASHMAN: return SendGuiInformation(playerid,""guiopis"Kierowca �mieciarki", "�mieciarki oraz siedzib� firmy znajdziesz na sk�adowisku Willowfield, okolice El Corony i dok�w.\nPozosta�e kroki zostan� wy�wietlone na ekranie podczas pracy.");
						case WORK_TYPE_FISHER: return SendGuiInformation(playerid,""guiopis"Rybak", "Udaj si� na du�y pomost w dzielnicy East Beach.\nPozosta�e kroki zostan� wy�wietlone na ekranie podczas pracy.");
						case WORK_TYPE_LUMBERJACK: return SendGuiInformation(playerid,""guiopis"Pracownik tartaku", "Tartaki znajduj� si� w The Panopticon, na serpentynie z Blueberry do San Fierro.\nPozosta�e kroki zostan� wy�wietlone na ekranie podczas pracy.");
						case WORK_TYPE_FORKLIFT: return SendGuiInformation(playerid,""guiopis"Operator w�zka", "W�zki wid�owe znajdziesz w dw�ch miejscach w dokach.\nPozosta�e kroki zostan� wy�wietlone na ekranie podczas pracy.");
						case WORK_TYPE_TRUCKER: return SendGuiInformation(playerid,""guiopis"Kierowca ci�ar�wki", "Ci�ar�wki oraz punkt cargo znajduje si� w dokach (Ocean Docks).\nPozosta�e kroki zostan� wy�wietlone na ekranie podczas pracy.");
						default: return SendGuiInformation(playerid,""guiopis"Brak pracy", "Nie posiadasz pracy dorywczej.\nMo�esz j� podj�� pod urz�dem na Pershing Square.");
					}
				}
			}
		}

		case DIALOG_WEAZEL:
		{
			new zgloszenie[MAX_PLAYERS];
			new number = pInfo[playerid][player_dialog_tmp1];
			if( !response )
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				return 1;
			}

			if(strlen(inputtext) < 4)
			{
				SendGuiInformation(playerid, "Informacja", "Zbyt kr�tka tre�� zg�oszenia.");
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				return 1;
			}

			if(strlen(inputtext) > 110)
			{
				SendGuiInformation(playerid, "Informacja", "Zbyt d�uga tre�� zg�oszenia.");
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				return 1;
			}

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);

			ProxMessage(playerid, inputtext, PROX_PHONE);

			foreach(new p : Player)
			{
				if(pInfo[p][player_duty_gid] >= 0)
				{
					if(Group[pInfo[p][player_duty_gid]][group_type] == GROUP_TYPE_SN)
					{
						zgloszenie[p]=1;
					}
				}
				if(zgloszenie[p]==1)
				{
					SendFormattedClientMessage(p, COLOR_GOLD, "Zg�oszenie od s�uchacza [%d]: %s", number, inputtext);
					zgloszenie[p]=0;
				}
			}
		}

		case DIALOG_ACCEPT_TRAVEL:
		{
			if(response)
		    {
	  			new price = pInfo[playerid][player_bus_price];
				if(pInfo[playerid][player_money] < price)
				{
					SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz wystarczaj�cej ilo�ci got�wki.");
					TogglePlayerSpectating(playerid, false);
					new Float:x, Float:y, Float:z;
					GetDynamicObjectPos(pInfo[playerid][player_bus_stop], x, y, z);

					SetPlayerPos(playerid, x, y, z);
					SetCameraBehindPlayer(playerid);
					TextDrawHideForPlayer(playerid, Tutorial[playerid]);
					TogglePlayerControllable(playerid, true);
					if(IsValidDynamicObject(pInfo[playerid][player_bus_object])) DestroyDynamicObject(pInfo[playerid][player_bus_object]);
					pInfo[playerid][player_bus_object] = INVALID_STREAMER_ID;
					pInfo[playerid][player_bus_stop] = false;
					return 1;
				}

				TextDrawHideForPlayer(playerid, Tutorial[playerid]);

				GivePlayerMoney(playerid, -price);
				
				TogglePlayerSpectating(playerid, false);
				PlayerPlaySound(playerid, 1076, 0.0, 0.0, 0.0);

				SetCameraBehindPlayer(playerid);
				if(IsValidDynamicObject(pInfo[playerid][player_bus_object])) DestroyDynamicObject(pInfo[playerid][player_bus_object]);

				new Float:x, Float:y, Float:z;
				GetDynamicObjectPos(pInfo[playerid][player_bus_stop], x, y, z);
				SetPlayerPos(playerid, x, y, z-10);

				new traveltime = pInfo[playerid][player_bus_time]*1000;

				new Float:destX, Float:destY, Float:destZ;
				GetDynamicObjectPos(pInfo[playerid][player_bus_destination], destX, destY, destZ);

				new Float:rot, Float:tmp;

				GetDynamicObjectRot(pInfo[playerid][player_bus_destination], tmp, tmp, rot);

				InterpolateCameraPos(playerid, x-4, y-4, z+80, destX, destY, destZ, traveltime);

				if(y > destY) //south
				{
					InterpolateCameraLookAt(playerid, x-4, y+180, z+80, destX, destY, destZ, traveltime);
				}
				else if(y < destY) //north
				{
					InterpolateCameraLookAt(playerid, x-4, y, z+80, destX, destY, destZ, traveltime);
				}


				pInfo[playerid][player_bus_stop] = false;
				pInfo[playerid][player_bus_ride] = true;

				ProxMessage(playerid, sprintf("odjecha� autobusem w kierunku %s.", pInfo[playerid][player_bus_destzone]), PROX_SERWERME);

				TogglePlayerControllable(playerid, false);

		        return 1;
		    }
		    else
		    {
				pInfo[playerid][player_bus_time] = 0;
				pInfo[playerid][player_bus_price] = 0;

				TogglePlayerSpectating(playerid, false);
				new Float:x, Float:y, Float:z;
				GetDynamicObjectPos(pInfo[playerid][player_bus_stop], x, y, z);

				SetPlayerPos(playerid, x, y, z);
				SetCameraBehindPlayer(playerid);
				TextDrawHideForPlayer(playerid, Tutorial[playerid]);
				TogglePlayerControllable(playerid, true);
				if(IsValidDynamicObject(pInfo[playerid][player_bus_object])) DestroyDynamicObject(pInfo[playerid][player_bus_object]);
				pInfo[playerid][player_bus_object] = INVALID_STREAMER_ID;
				pInfo[playerid][player_bus_stop] = false;
		        return 1;
		    }
		}

		case DIALOG_CBELL:
		{
			if(!response)
			{
				return 1;
			}
			else if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						if(pInfo[playerid][player_money]<30)
		                {
	                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz wystarczaj�cej ilo�ci got�wki.");
	                        return 1;
		                }
						GivePlayerMoney(playerid, -30);
						if(pInfo[playerid][player_health] <= 40)
						{
							pInfo[playerid][player_health]+=60;
						}
						else
						{
							pInfo[playerid][player_health]= 100;
						}

						SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health]));
						ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Drive-thru", "Zakupi�e� jedzenie, twoje HP zosta�o uzupe�nione.", "Okej", "");
					}
					case 1:
					{
						if(pInfo[playerid][player_money]<20)
		                {
	                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz wystarczaj�cej ilo�ci got�wki.");
	                        return 1;
		                }
						GivePlayerMoney(playerid, -20);
						if(pInfo[playerid][player_health] <= 60)
						{
							pInfo[playerid][player_health]+=40;
						}
						else
						{
							pInfo[playerid][player_health]= 100;
						}
						
						SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health]));
						ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Drive-thru", "Zakupi�e� jedzenie, twoje HP zosta�o uzupe�nione.", "Okej", "");
					}
					case 2:
					{
						if(pInfo[playerid][player_money]<15)
		                {
	                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz wystarczaj�cej ilo�ci got�wki.");
	                        return 1;
		                }
						GivePlayerMoney(playerid, -15);
						if(pInfo[playerid][player_health] <= 75)
						{
							pInfo[playerid][player_health]+=25;
						}
						else
						{
							pInfo[playerid][player_health]= 100;
						}
						
						SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health]));
						ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Drive-thru", "Zakupi�e� jedzenie, twoje HP zosta�o uzupe�nione.", "Okej", "");
					}
					case 3:
					{
						if(pInfo[playerid][player_money]<21)
		                {
	                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz wystarczaj�cej ilo�ci got�wki.");
	                        return 1;
		                }
						GivePlayerMoney(playerid, -21);
						if(pInfo[playerid][player_health] <= 55)
						{
							pInfo[playerid][player_health] += 45;
						}
						else
						{
							pInfo[playerid][player_health]= 100;
						}
						
						SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health]));
						ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, ""guiopis"Drive-thru", "Zakupi�e� jedzenie, twoje HP zosta�o uzupe�nione.", "Okej", "");
					}
				}
			}
		}

		case DIALOG_ANIMATIONS:
		{
			if(response)
		    {
		    	if(GetPVarInt(playerid, "AnimHitPlayerGun") == 1) return 1;
	    	 	new dg_value = DynamicGui_GetValue(playerid, listitem), dg_data = DynamicGui_GetDataInt(playerid, listitem);

            	if( dg_value == DG_ANIMS )
            	{
			        new anim_id = dg_data;
			        
			        if(!AnimInfo[anim_id][aAction])
			        {
			        	ApplyAnimation(playerid, AnimInfo[anim_id][aLib], AnimInfo[anim_id][aName], AnimInfo[anim_id][aSpeed], AnimInfo[anim_id][aOpt1], AnimInfo[anim_id][aOpt2], AnimInfo[anim_id][aOpt3], AnimInfo[anim_id][aOpt4], AnimInfo[anim_id][aOpt5], 1);
					}
					else
					{
					    SetPlayerSpecialAction(playerid, AnimInfo[anim_id][aAction]);
					}

					pInfo[playerid][player_looped_anim]= true;
				}
		    }
		    else
		    {
		        return 1;
		    }
		}

		case DIALOG_AS:
		{
			if( !response ) return 1;

			CharacterKill(playerid, playerid, "Smierc");
			return 1;
		}

		case DIALOG_BANKOMAT:
		{
			if( !response ) return 1;

			switch(listitem)
			{
				case 0:
				{
					new str[78];
					format(str, sizeof(str), "Stan twojego konta wynosi: $%d.\nNumer twojego konta to: %d.", pInfo[playerid][player_bank_money], pInfo[playerid][player_bank_number]);
					ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Konto bankowe", str, "OK", "");

					if(!PlayerHasAchievement(playerid, ACHIEV_RICH) && pInfo[playerid][player_bank_money] >= 50000) AddAchievement(playerid, ACHIEV_RICH, 1000);
					if(!PlayerHasAchievement(playerid, ACHIEV_BILLION) && pInfo[playerid][player_bank_money] >= 1000000) AddAchievement(playerid, ACHIEV_BILLION, 10000);
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "Wp�ata got�wki", "Podaj ilo�� got�wki do wp�aty na konto.", "OK", "");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT, "Wyp�ata got�wki", "Podaj ilo�� got�wki do wyp�aty.", "OK", "");
				}
				case 3:
				{
					if(pInfo[playerid][player_hours] < 1) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Przelewy dost�pne s� po przegraniu godziny na serwerze.");
					ShowPlayerDialog(playerid, DIALOG_BANK_PRZELEW, DIALOG_STYLE_INPUT, "Przelew", "Podaj kwot�, kt�r� chcia�by� przela�.", "Dalej", "Wyjd�");
				}
				case 4:
				{
					if(pInfo[playerid][player_job] == 0) return SendGuiInformation(playerid, "Informacja", "Nie jeste� zatrudniony w �adnej pracy dorywczej.");
					if(pInfo[playerid][player_job_cash] <= 0) return SendGuiInformation(playerid, "Informacja", "Nie zarobi�e� �adnych pieni�dzy w pracy dorywczej.");
					if(gettime() < pInfo[playerid][player_last_work] + 12*3600 )
					{
						new nextpay = pInfo[playerid][player_last_work] + 12*3600;
						new payHour, payMinute, temp;

						TimestampToDate(nextpay, temp, temp, temp, payHour, payMinute, temp, 1);

						if(payHour == 24)
						{
							SendGuiInformation(playerid, "Informacja", sprintf("Payday zosta� ju� dzisiaj pobrany.\nNast�pny mo�esz odebra� o 01:%02d.", payMinute));
						}
						else
						{
							SendGuiInformation(playerid, "Informacja", sprintf("Payday zosta� ju� dzisiaj pobrany.\nNast�pny mo�esz odebra� o %02d:%02d.", payHour+1, payMinute));
						}
						return 1;
					}

					if(pInfo[playerid][player_job_cash] <= 350)
					{
						new string[128];
						GivePlayerMoney(playerid, pInfo[playerid][player_job_cash]);
						format(string, sizeof(string), "~p~Bank~w~ - wyplata~n~~n~Praca dorywcza - $%d", pInfo[playerid][player_job_cash]);
						SendPlayerInformation(playerid, string, 10000);
						pInfo[playerid][player_last_work] = gettime();
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_last_work = %d WHERE char_uid = %d", gettime(), pInfo[playerid][player_id]));
					}
					else if(pInfo[playerid][player_job_cash] > 350)
					{
						GivePlayerMoney(playerid, 350);
						SendPlayerInformation(playerid, "~p~Bank~w~ - wyplata~n~~n~Praca dorywcza - $350", 10000);
						pInfo[playerid][player_last_work] = gettime();
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_last_work = %d WHERE char_uid = %d", gettime(), pInfo[playerid][player_id]));
					}
				}
				/*case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_BANK_CREDIT, DIALOG_STYLE_LIST, "Oferta kredytowa", "1. We� kredyt na nieruchomo��\n2. We� kredyt na pojazd\n3. Sp�a� kredyt\n4. Historia kredyt�w", "Dalej", "Wyjd�");
				}*/
			}
		}

		case DIALOG_BANK_PRZELEW:
		{
			if( !response ) return 1;

			new kwota = strval(inputtext);
			if(kwota <= 0) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie mo�esz przela� takiej kwoty.");
			if(kwota > pInfo[playerid][player_bank_money]) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie masz na tyle pieni�dzy w banku.");

			DynamicGui_Init(playerid);
			DynamicGui_SetDialogValue(playerid, kwota);
			ShowPlayerDialog(playerid, DIALOG_BANK_NUMER, DIALOG_STYLE_INPUT, "Przelew", "Podaj numer konta na kt�ry chcesz przela� pieni�dze.", "Przelej", "Wyjd�");
		}

		case DIALOG_BANK_TAKE_CREDIT:
		{
			if( !response ) return 1;

			new cred_type = DynamicGui_GetDialogValue(playerid);
			new amount = strval(inputtext);

			if(amount < 0 || amount > MAX_CREDIT_VALUE)
			{
				DynamicGui_Init(playerid);
				ShowPlayerDialog(playerid, DIALOG_BANK_TAKE_CREDIT, DIALOG_STYLE_INPUT, "Oferta kredytowa", "Podaj kwot� kredytu.\nMaksymalnie mo�esz zad�u�y� si� na $20000.", "We�", "Wyjd�");
				DynamicGui_SetDialogValue(playerid, cred_type);
				return 1;
			}

			switch(cred_type)
			{
				case 1:
				{
					mysql_tquery(mySQLconnection, sprintf("SELECT credit_created, credit_value FROM ipb_credits WHERE credit_owner = %d AND credit_type = %d", pInfo[playerid][player_id], CREDIT_TYPE_PROPERTY), "OnPlayerCheckCreditStatus", "d", playerid);
					//kredyt na nieruchomo��
				}
				case 2:
				{
					//kredyt na pojazd
					mysql_tquery(mySQLconnection, sprintf("SELECT credit_created, credit_value FROM ipb_credits WHERE credit_owner = %d AND credit_type = %d", pInfo[playerid][player_id], CREDIT_TYPE_VEHICLE), "OnPlayerCheckCreditStatus", "d", playerid);
				}
			}

		}

		case DIALOG_BANK_NUMER:
		{
			if( !response ) return 1;

			if(pInfo[playerid][player_hours] < 2) return SendGuiInformation(playerid, "Informacja", "Przelewy s� dost�pne po przegraniu dw�ch godzin.");
			new numer = strval(inputtext);
			new uid = -1;
			new rows, Cache:tmp_cache;

			tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT char_uid FROM ipb_characters WHERE char_banknumb = %d", numer));
			cache_get_row_count(rows);

			if(rows)
			{
				cache_get_value_index_int(0, 0, uid);

				if(uid == -1)
				{
					SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Wprowadzono niepoprawny numer konta.");
					return 1;
				}

				if(uid == pInfo[playerid][player_id])
				{
					SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie mo�esz przela� pieni�dzy na swoje w�asne konto.");
					return 1;
				}

				new kwota = DynamicGui_GetDialogValue(playerid);

				new player = GetPlayerByUid(uid);

				if(player == -1)
				{
					pInfo[playerid][player_bank_money] -= kwota;
					mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_bankcash = char_bankcash - %d WHERE char_uid = %d", kwota, pInfo[playerid][player_id]));

					mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_bankcash = char_bankcash + %d WHERE char_uid = %d", kwota, uid));
				}
				else
				{
					pInfo[playerid][player_bank_money] -= kwota;
					pInfo[player][player_bank_money] += kwota;

					SendClientMessage(player, COLOR_YELLOW, sprintf("> (SMS) [755] Bank: Zaksi�gowano now� wp�at� na koncie z numeru %d. Warto��: $%d.", pInfo[playerid][player_bank_number], kwota));
					mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_bankcash = char_bankcash + %d WHERE char_uid = %d", kwota, uid));
					mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_characters SET char_bankcash = char_bankcash - %d WHERE char_uid = %d", kwota, pInfo[playerid][player_id]));
				}

				SendGuiInformation(playerid, "Bank", sprintf("Przelew o warto�ci $%d na numer konta %d zosta� wykonany pomy�lnie.", kwota, numer));
			}
			else
			{
				SendGuiInformation(playerid, "Bank", "Niepoprawny numer konta.");
			}

			if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
		}

		case DIALOG_BANK_DEPOSIT:
		{
			if( !response ) return 1;

			new money=strval(inputtext);

			if(money<0) return KickAc(playerid, -1, "Bug abusing try (negative value)");


			if(pInfo[playerid][player_money]<money)
			{
				SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz takiej ilo�ci got�wki.");
			}
			else
			{
				pInfo[playerid][player_bank_money]+=money;
				GivePlayerMoney(playerid,-money);
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_bankcash = %d WHERE char_uid = %d", pInfo[playerid][player_bank_money], pInfo[playerid][player_id]));
				SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Pomy�lnie wp�aci�e� got�wk� na konto.");
			}
		}

		case DIALOG_BANK_WITHDRAW:
		{
			if( !response ) return 1;

			new money=strval(inputtext);

			if(money<0)
			{
				KickAc(playerid, -1, "Bug abusing try (negative value)");
				return 1;
			}

			if(pInfo[playerid][player_bank_money]<money)
			{
				SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz tyle pieni�dzy na koncie.");
			}
			else
			{
				pInfo[playerid][player_bank_money]-=money;
				GivePlayerMoney(playerid,money);
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_bankcash = %d WHERE char_uid = %d", pInfo[playerid][player_bank_money], pInfo[playerid][player_id]));
				SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Pomy�lnie wyp�aci�e� got�wk� z konta.");
			}
		}

		case DIALOG_GIVE_CREW:
		{
			if( !response ) return 1;

			new targetid = DynamicGui_GetDialogValue(playerid);
			if( !IsPlayerConnected(targetid) || !pInfo[targetid][player_logged] ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Gracz o podanym id nie jest zalogowany.");

			new flag = DynamicGui_GetValue(playerid, listitem);

			if( HasCrewFlag(targetid, flag) )
			{
				// usuwamy flage
				pGlobal[targetid][glo_perm] -= flag;
			}
			else
			{
				// dodajemy flage
				if( flag == CREW_FLAG_GM || flag == CREW_FLAG_ADMIN || flag == CREW_FLAG_ADMIN_ROOT )
				{
					if( HasCrewFlag(targetid, CREW_FLAG_GM) || HasCrewFlag(targetid, CREW_FLAG_ADMIN) || HasCrewFlag(targetid, CREW_FLAG_ADMIN_ROOT) )
					{
						return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Ta osoba posiada ju� rang�, najpierw j� zdejmij.");
					}
				}

				pGlobal[targetid][glo_perm] += flag;
			}

			mysql_query(mySQLconnection, sprintf("UPDATE `core_members` SET `member_game_admin_perm` = %d WHERE `member_id` = %d", pGlobal[targetid][glo_perm], pGlobal[targetid][glo_id]));


			return cmd_aflags(playerid, sprintf("%d", targetid));
		}

		case DIALOG_GIVE_FLAG:
		{
			if( !response ) return 1;

			new targetid = DynamicGui_GetDialogValue(playerid);
			if( !IsPlayerConnected(targetid) || !pInfo[targetid][player_logged] ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Gracz o podanym id nie jest zalogowany.");

			new flag = DynamicGui_GetValue(playerid, listitem);

			if( PlayerHasFlag(targetid, flag) )
			{
				// usuwamy flage
				pInfo[targetid][player_flags] -= flag;
			}
			else
			{
				pInfo[targetid][player_flags] += flag;
			}

			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_flags` = %d WHERE `char_uid` = %d", pInfo[targetid][player_flags], pInfo[targetid][player_id]));


			return cmd_pflags(playerid, sprintf("%d", targetid));
		}

		case DIALOG_AREA_FLAGS:
		{
			if( !response ) return 1;

			new a_id = DynamicGui_GetDialogValue(playerid);

			new flag = DynamicGui_GetValue(playerid, listitem);

			if( AreaHasFlag(a_id, flag) )
			{
				// usuwamy flage
				Area[a_id][area_flags] -= flag;
			}
			else
			{
				// dodajemy flage
				Area[a_id][area_flags] += flag;
			}

			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_areas` SET `area_flags` = %d WHERE `area_uid` = %d", Area[a_id][area_flags], Area[a_id][area_uid]));


			return cmd_astrefa(playerid, sprintf("flagi %d", a_id));
		}

		case DIALOG_GROUP_FLAGS:
		{
			if( !response ) return 1;

			new g_id = DynamicGui_GetDialogValue(playerid);

			new flag = DynamicGui_GetValue(playerid, listitem);

			if( GroupHasFlag(g_id, flag) )
			{
				// usuwamy flage
				Group[g_id][group_flags] -= flag;
			}
			else
			{
				// dodajemy flage
				Group[g_id][group_flags] += flag;
			}

			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_game_groups` SET `group_flags` = %d WHERE `group_uid` = %d", Group[g_id][group_flags], Group[g_id][group_uid]));


			return cmd_agrupa(playerid, sprintf("flagi %d", Group[g_id][group_uid]));
		}

		case DIALOG_DRZWI:
		{
			TextDrawHideForPlayer(playerid, Tutorial[playerid]);

			if( !response )
			{
				return 1;
			}

			new d_id = DynamicGui_GetDialogValue(playerid);

			switch( DynamicGui_GetValue(playerid, listitem) )
			{
				case DG_DRZWI_CREATE:
				{
					new a_id = pInfo[playerid][player_area];
					if(a_id < 1) return 1;
					
					new warning[150];
					format(warning, sizeof(warning), ""HEX_COLOR_LIGHTER_RED"Uwaga: Tworzenie budynk�w w miejscach, w kt�rych na wej�ciu nie ma drzwi,\nb�dzie karane skasowaniem budynku bez zwrotu pieni�dzy.");
					ShowPlayerDialog(playerid, DIALOG_DRZWI_CREATE, DIALOG_STYLE_INPUT, "Kreator drzwi", sprintf("Cena twojego budynku wynosi� b�dzie $%d.\n\nWpisz POTWIERDZAM aby wstawi� drzwi.\n%s", Area[a_id][area_price], warning), "OK", "Anuluj");
				}
				case DG_DRZWI_NAME:
				{
					pInfo[playerid][player_dialog_tmp1] = d_id;

					ShowPlayerDialog(playerid, DIALOG_DRZWI_NAME, DIALOG_STYLE_INPUT, "Zmiana nazwy drzwi", "Podaj now� nazw� dla swoich drzwi:", "Zmie�", "Zamknij");
				}

				case DG_DRZWI_SPAWN:
				{
					pInfo[playerid][player_dialog_tmp1] = d_id;

					ShowPlayerDialog(playerid, DIALOG_DRZWI_SPAWN, DIALOG_STYLE_MSGBOX, "Zmiana wewn�trznej pozycji drzwi", "Na pewno chcesz zmieni� pozycje wewn�trzn� drzwi na t� w kt�rej sie aktualnie znajdujesz?", "Zmie�", "Zamknij");
				}

				case DG_DRZWI_SPAWN_COORDS:
				{
					pInfo[playerid][player_dialog_tmp1] = d_id;

					ShowPlayerDialog(playerid, DIALOG_DRZWI_SPAWN_COORDS, DIALOG_STYLE_INPUT, "Zmiana wewn�trznej pozycji drzwi", "W poni�szym polu podaj pozycje x,y,z,a odzielaj�c je przecinkami:", "Zmie�", "Zamknij");
				}

				case DG_DRZWI_AUDIO:
				{
					pInfo[playerid][player_dialog_tmp1] = d_id;

					ShowPlayerDialog(playerid, DIALOG_DRZWI_AUDIO, DIALOG_STYLE_INPUT, "Zmiana �cie�ki audio", "W poni�szym polu podaj �cie�ke do pliku lub streamu radia (pozostaw pole puste, aby wy��czy� muzyk�):", "Zmie�", "Zamknij");
				}

				case DG_DRZWI_PAYMENT:
				{
					pInfo[playerid][player_dialog_tmp1] = d_id;

					ShowPlayerDialog(playerid, DIALOG_DRZWI_PAYMENT, DIALOG_STYLE_INPUT, "Oplata za wejscie", "Podaj kwot� op�aty za wejscie:", "Zmie�", "Zamknij");
				}

				case DG_DRZWI_TIME:
				{
					pInfo[playerid][player_dialog_tmp1] = d_id;

					ShowPlayerDialog(playerid, DIALOG_DRZWI_TIME, DIALOG_STYLE_INPUT, "Zmiana godziny w interiorze", "Podaj godzin� jak� chcesz ustawi�:", "Zmie�", "Zamknij");
				}

				case DG_DRZWI_CLEAR:
				{
					pInfo[playerid][player_dialog_tmp1] = d_id;

					ShowPlayerDialog(playerid, DIALOG_DRZWI_CLEAR, DIALOG_STYLE_INPUT, "Kasowanie interioru", "Czy na pewno chcesz usun�� wszystkie obiekty w drzwiach?\nWpisz TAK aby zatwierdzi�.", "Zatwierd�", "Zamknij");
				}

				case DG_DRZWI_CARS:
				{
					Door[d_id][door_car_crosing] = !Door[d_id][door_car_crosing];
					mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_garage` = %d WHERE `door_uid` = %d", Door[d_id][door_car_crosing], Door[d_id][door_uid]));

					return cmd_drzwi(playerid, "opcje");
				}

				case DG_DRZWI_CLOSING:
				{
					Door[d_id][door_auto_closing] = !Door[d_id][door_auto_closing];
					mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_lock` = %d WHERE `door_uid` = %d", Door[d_id][door_auto_closing], Door[d_id][door_uid]));

					return cmd_drzwi(playerid, "opcje");
				}

				case DG_DRZWI_ASSIGN:
				{
					if(!IsPlayerInAnyGroup(playerid)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz �adnej grupy.");
					
					new list_groups[120];
					DynamicGui_Init(playerid);
					pInfo[playerid][player_dialog_tmp1] = d_id;

					for(new i=0;i<5;i++)
					{
						new gid = pGroup[playerid][i][pg_id];
						if( gid != -1 )
						{
							format(list_groups, sizeof(list_groups), "%s%d. %s (%d)\n", list_groups, i+1, Group[gid][group_name], Group[gid][group_uid]);
							DynamicGui_AddRow(playerid, gid);
						}
					}

					ShowPlayerDialog(playerid, DIALOG_DRZWI_ASSIGN, DIALOG_STYLE_LIST, "Wybierz nowego ownera drzwi", list_groups, "Przypisz", "Anuluj");
				}

				case DG_DRZWI_UNSIGN:
				{
					mysql_query(mySQLconnection, sprintf("UPDATE ipb_doors SET door_ownertype = %d, door_owner = %d WHERE door_uid = %d", DOOR_OWNER_TYPE_PLAYER, pInfo[playerid][player_id], Door[d_id][door_uid]));
					Door[d_id][door_owner] = pInfo[playerid][player_id];
					Door[d_id][door_owner_type] = DOOR_OWNER_TYPE_PLAYER;
					SendGuiInformation(playerid, "Informacja", "Pomy�lnie odpisano budynek od grupy.\nNale�y od teraz do twojej postaci.");
				}

				case DG_DRZWI_BUY:
				{
					new item = HasPlayerItemWithValue(ITEM_TYPE_PREMIUM, playerid, PREMIUM_TYPE_OBJECTS);
					if(item == -1)
					{
						SendGuiInformation(playerid, "Informacja", "Nie posiadasz przy sobie przedmiotu z obiektami do drzwi.");
						return 1;
					}
					
					new objects = PlayerItem[playerid][item][player_item_value2];
					Door[d_id][door_objects_limit] += objects;
					DeleteItem(item, true, playerid);
					mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_objects` = %d WHERE `door_uid` = %d", Door[d_id][door_objects_limit], Door[d_id][door_uid]));
					SendGuiInformation(playerid, "Informacja", sprintf("Pomy�lnie do�adowano %d obiekt�w.", objects));
				}

				case DG_DRZWI_FIX_BURN:
				{
					new price = Door[d_id][door_burned] * 50;
					if(price > pInfo[playerid][player_money]) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz wystarczaj�cej ilo�ci got�wki.");

					Door[d_id][door_burned] = 0;
					GivePlayerMoney(playerid, -price);

					mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_burned` = 0 WHERE `door_uid` = %d", Door[d_id][door_uid]));

					return cmd_drzwi(playerid, "opcje");
				}

				case DG_DRZWI_FIX:
				{
					new price = Door[d_id][door_destroyed] * 25;
					if(price > pInfo[playerid][player_money]) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz wystarczaj�cej ilo�ci got�wki.");

					Door[d_id][door_destroyed] = 0;
					GivePlayerMoney(playerid, -price);

					mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_destroyed` = 0 WHERE `door_uid` = %d", Door[d_id][door_uid]));

					return cmd_drzwi(playerid, "opcje");
				}

				case DG_DRZWI_CAMERA:
				{
					new rows, Cache:tmp_cache, list_suspects[256];
					tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT camera_suspects FROM ipb_game_cameras WHERE camera_door = %d", Door[d_id][door_uid]));
			    	cache_get_row_count(rows);

			    	if(!rows)
		    		{
		    			SendGuiInformation(playerid, "Informacja", "Kamery nie zarejestrowa�y �adnych podejrzanych zachowa�.");
		    			if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
		    			return 1;
		    		}

			    	cache_get_value_index(0, 0, list_suspects);

			    	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);

			    	if(strlen(list_suspects))
			    	{
			    		ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Sprawcy szk�d:", list_suspects, "OK", "");
			    	}
				}

				case DG_DRZWI_SCHOWEK:
				{
					new rows, Cache:tmp_cache, header[32], bag_item_uid, bag_item_name[40], list_items[1024];
					tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT item_uid, item_name FROM ipb_items WHERE item_owner = %d AND item_ownertype = %d", Door[d_id][door_uid], ITEM_OWNER_TYPE_DOOR));
			    	cache_get_row_count(rows);

			    	for(new row = 0; row != rows; row++)
					{
						cache_get_value_index_int(row, 0, bag_item_uid);
		   				cache_get_value_index(row, 1, bag_item_name, 40);

						format(list_items, sizeof(list_items), "%s\n%d\t%s", list_items, bag_item_uid, bag_item_name);
					}

					format(header, sizeof(header), "UID\tNazwa\n");

					if(strlen(list_items))
					{
						format(list_items, sizeof(list_items), "%s%s", header, list_items);
						ShowPlayerDialog(playerid, DIALOG_SCHOWEK_TAKE, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty w schowku:", list_items, "Wyjmij", "Anuluj");
			      	}
			       	else
			       	{
			        	SendGuiInformation(playerid, ""guiopis"Informacja", "W tych drzwiach nie ma �adnego przedmiotu.");
					}

					if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
				}
			}
		}

		case DIALOG_DRZWI_ASSIGN:
		{
			if( !response ) return 1;

			new d_id = pInfo[playerid][player_dialog_tmp1];
			new gid = DynamicGui_GetValue(playerid, listitem);

			Door[d_id][door_owner_type] = DOOR_OWNER_TYPE_GROUP;
			Door[d_id][door_owner] = Group[gid][group_uid];

			mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_doors SET door_ownertype = %d, door_owner = %d WHERE door_uid = %d", Door[d_id][door_owner_type], Door[d_id][door_owner], Door[d_id][door_uid]));

			SendGuiInformation(playerid, ""guiopis"Informacja", sprintf("Drzwi zosta�y pomy�lnie przypisane pod grup� %s.", Group[gid][group_name]));
		}

		case DIALOG_CK:
		{
			if( !response ) return 1;

			if( !strcmp(inputtext, "POTWIERDZAM") )
			{
				new itemid = DynamicGui_GetDialogValue(playerid);
				DeleteItem(itemid, true, playerid);
				SendGuiInformation(playerid, ""guiopis"Informacja", sprintf("Posta� %s zosta�a zablokowana.", pInfo[playerid][player_name]));
				mysql_query(mySQLconnection, sprintf("UPDATE ipb_characters SET char_active = 1 WHERE char_uid = %d", pInfo[playerid][player_id]));
				Kick(playerid);
			}
		}

		case DIALOG_DRZWI_CREATE:
		{
			if( !response ) return 1;

			new a_id = pInfo[playerid][player_area];
			if(a_id < 1) return 1;

			if(!CA_IsPlayerBlocked(playerid, 3, -3)) return SendGuiInformation(playerid, "Informacja", "Nie uda�o si� wykry� budynku.\nUpewnij si�, �e stoisz pod budynkiem, twarz� do �ciany.\nNie mo�esz sta� dalej ni� 3m od �ciany.");
			
			if( !strcmp(inputtext, "POTWIERDZAM") )
			{
				new price = Area[a_id][area_price];

				if(price < 0) return 1;

				if(pInfo[playerid][player_money] < price) return SendGuiInformation(playerid, "Informacja", sprintf("Nie posiadasz przy sobie $%d w got�wce.", price));

				pInfo[playerid][player_dialog_tmp1] = price;

				ShowPlayerDialog(playerid, DIALOG_DRZWI_CREATE_CONFIRM, DIALOG_STYLE_MSGBOX, "Kreator drzwi", sprintf("Czy aby na pewno chcesz utworzy� ten budynek? ($%d)", price), "Tak", "Nie");
			}
		}

		case DIALOG_DRZWI_CREATE_CONFIRM:
		{
			if( !response ) return 1;
			new a_id = pInfo[playerid][player_area];
			if(a_id < 1) return 1;
			
			new price = pInfo[playerid][player_dialog_tmp1];

			GivePlayerMoney(playerid, -price);

			new Float:pPos[4];
			GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
			GetPlayerFacingAngle(playerid, pPos[3]);

			new objects = 50;

			if(IsPlayerVip(playerid)) objects = 100;

			new str[420];
			strcat(str, "INSERT INTO ipb_doors (door_uid, door_owner, door_ownertype, door_name, door_type, door_pickupid, door_enterx, door_entery, door_enterz, door_entera, door_entervw, door_enterint, door_exitx, door_exity, door_exitz, door_exita, door_price, door_objects) ");
			strcat(str, sprintf("VALUES (null, %d, %d, 'Nowy Budynek', 1, 1239, %f, %f, %f, %f, %d, %d, %f, %f, %f, %f, %d, %d)", pInfo[playerid][player_id], DOOR_OWNER_TYPE_PLAYER, pPos[0], pPos[1], pPos[2], pPos[3], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), pPos[0], pPos[1], pPos[2], pPos[3], 0, objects));
			
			mysql_query(mySQLconnection, str);
			new uid = cache_insert_id();
			
			new did = LoadDoor(sprintf("WHERE `door_uid` = %d", uid), true);

			SendGuiInformation(playerid, "Informacja", sprintf("Budynek zosta� pomy�lnie utworzony. [UID: %d, ID: %d]", uid, did));
		}

		case DIALOG_DRZWI_NAME:
		{
			if( !response ) return cmd_drzwi(playerid, "opcje");

			if( strlen(inputtext) < 6 ) return ShowPlayerDialog(playerid, DIALOG_DRZWI_NAME, DIALOG_STYLE_INPUT, "Zmiana nazwy drzwi", "Podaj nowa nazwe dla tych drzwi:\n\n"HEX_COLOR_LIGHTER_RED"Minimum 6 znakow.", "Gotowe", "Zamknij");
			if( strlen(inputtext) > 30 ) return ShowPlayerDialog(playerid, DIALOG_DRZWI_NAME, DIALOG_STYLE_INPUT, "Zmiana nazwy drzwi", "Podaj nowa nazwe dla tych drzwi:\n\n"HEX_COLOR_LIGHTER_RED"Maksymalnie 30 znak�w.", "Gotowe", "Zamknij");
			if( strfind(inputtext, "~~") != -1 ) return ShowPlayerDialog(playerid, DIALOG_DRZWI_NAME, DIALOG_STYLE_INPUT, "Zmiana nazwy drzwi", "Podaj nowa nazwe dla tych drzwi:\n\n"HEX_COLOR_LIGHTER_RED"Nazwa zawiera niepoprawne znaki.", "Gotowe", "Zamknij");

			new d_id = pInfo[playerid][player_dialog_tmp1];

			mysql_escape_string(inputtext, inputtext, 256);
			mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_name` = '%s' WHERE `door_uid` = %d", inputtext, Door[d_id][door_uid]));

			strcopy(Door[d_id][door_name], inputtext, 30);

			SendFormattedClientMessage(playerid, COLOR_GREY, "Nazwa drzwi zosta�a zmieniona na: %s.", inputtext);
			cmd_drzwi(playerid, "opcje");
		}

		case DIALOG_DRZWI_SPAWN:
		{
			if( !response ) return cmd_drzwi(playerid, "opcje");

			new d_id = pInfo[playerid][player_dialog_tmp1];

			GetPlayerPos(playerid, Door[d_id][door_spawn_pos][0],Door[d_id][door_spawn_pos][1], Door[d_id][door_spawn_pos][2]);
			GetPlayerFacingAngle(playerid, Door[d_id][door_spawn_pos][3]);

			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_exitx` = %f, `door_exity` = %f, `door_exitz` = %f, `door_exita` = %f WHERE `door_uid` = %d", Door[d_id][door_spawn_pos][0], Door[d_id][door_spawn_pos][1], Door[d_id][door_spawn_pos][2], Door[d_id][door_spawn_pos][3], Door[d_id][door_uid]));

			SendClientMessage(playerid, COLOR_GOLD, "Zmieniono pozycje wewn�trzn� drzwi.");

			return cmd_drzwi(playerid, "opcje");
		}

		case DIALOG_DRZWI_SPAWN_COORDS:
		{
			if( !response ) return cmd_drzwi(playerid, "opcje");

			new d_id = pInfo[playerid][player_dialog_tmp1];

			if( sscanf(inputtext, "p<,>a<f>[4]", Door[d_id][door_spawn_pos]) ) return ShowPlayerDialog(playerid, DIALOG_DRZWI_SPAWN_COORDS, DIALOG_STYLE_INPUT, "Zmiana wewn�trznej pozycji drzwi (koordynaty)", "W poni�szym polu podaj pozycj� x,y,z,a odzielaj�c poszczeg�lne koordynaty przecinkami:\n\n"HEX_COLOR_LIGHTER_RED"Podane dane maj� z�y format.", "Zmie�", "Zamknij");

			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_exitx` = %f, `door_exity` = %f, `door_exitz` = %f, `door_exita` = %f WHERE `door_uid` = %d", Door[d_id][door_spawn_pos][0], Door[d_id][door_spawn_pos][1], Door[d_id][door_spawn_pos][2], Door[d_id][door_spawn_pos][3], Door[d_id][door_uid]));

			SendClientMessage(playerid, COLOR_GOLD, "Wewn�trzna pozycja drzwi zosta�a zmieniona.");

			return cmd_drzwi(playerid, "opcje");
		}

		case DIALOG_DRZWI_AUDIO:
		{
			if( !response ) return cmd_drzwi(playerid, "opcje");

			new d_id = pInfo[playerid][player_dialog_tmp1];

			if( strlen(inputtext) < 3 )
			{
				SendClientMessage(playerid, COLOR_GOLD, "Audio stream zosta� wstrzymany.");
				Door[d_id][door_audio] = EOS;
				mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_audiourl` = '-' WHERE `door_uid` = %d", Door[d_id][door_uid]));
				StopAudioStreamForPlayer(playerid);
				return 1;
			}

			sscanf(inputtext, "s[100]", Door[d_id][door_audio]);

			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_audiourl` = '%s' WHERE `door_uid` = %d", Door[d_id][door_audio], Door[d_id][door_uid]));

			SendClientMessage(playerid, COLOR_GOLD, "Ĺ’cie�ka audio zosta�a pomy�lnie zmieniona.");

			foreach(new p : Player)
			{
				if( GetPlayerVirtualWorld(p) == Door[d_id][door_spawn_vw] )
				{
					if( !isnull(Door[d_id][door_audio]) ) PlayAudioStreamForPlayer(p, Door[d_id][door_audio], 0);
					else StopAudioStreamForPlayer(p);
				}
			}

			return cmd_drzwi(playerid, "opcje");
		}

		case DIALOG_DRZWI_PAYMENT:
		{
			if( !response ) return cmd_drzwi(playerid, "opcje");

			new payment;
			if( sscanf(inputtext, "d", payment) ) return ShowPlayerDialog(playerid, DIALOG_DRZWI_PAYMENT, DIALOG_STYLE_INPUT, "Zmiana oplaty za wej�cie", "Podaj ilo�� dolarow za wej�cie:\n\nPoprzednio podales niepoprawna kwote.", "Zmien", "Zamknij");
			if( payment < 0 || payment > 100) return ShowPlayerDialog(playerid, DIALOG_DRZWI_PAYMENT, DIALOG_STYLE_INPUT, "Zmiana oplaty za wej�cie", "Podaj ilo�� dolar�w za wejscie:\n\nPoprzednio poda�e� niepoprawna kwote - dozwolony zakres od 1 do 100.", "Zmien", "Zamknij");

			new d_id = pInfo[playerid][player_dialog_tmp1];

			Door[d_id][door_payment] = payment;
			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_enterpay` = %d WHERE `door_uid` = %d", Door[d_id][door_payment], Door[d_id][door_uid]));

			return cmd_drzwi(playerid, "opcje");
		}

		case DIALOG_DRZWI_TIME:
		{
			if( !response ) return cmd_drzwi(playerid, "opcje");

			new time;
			if( sscanf(inputtext, "d", time) ) return ShowPlayerDialog(playerid, DIALOG_DRZWI_PAYMENT, DIALOG_STYLE_INPUT, "Zmiana godziny w interiorze", "Podaj godzin� jak� chcesz ustawi�.\n\nPoprzednio poda�e� niepoprawn�.", "Zmie�", "Zamknij");
			if( time > 24 ) return ShowPlayerDialog(playerid, DIALOG_DRZWI_PAYMENT, DIALOG_STYLE_INPUT, "Zmiana godziny w interiorze", "Podaj godzin� jak� chcesz ustawi�.\n\nPoprzednio poda�e� niepoprawn�.", "Zmie�", "Zamknij");
			if(time == 0) time = 24;

			new d_id = pInfo[playerid][player_dialog_tmp1];

			Door[d_id][door_time] = time;
			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_time` = %d WHERE `door_uid` = %d", Door[d_id][door_time], Door[d_id][door_uid]));

			SendClientMessage(playerid, COLOR_GOLD, "Godzina w interiorze zosta�a zmieniona, wejd� ponownie do drzwi.");

			return cmd_drzwi(playerid, "opcje");
		}

		case DIALOG_DRZWI_CLEAR:
		{
			if( !response ) return cmd_drzwi(playerid, "opcje");
			if(GetPlayerVirtualWorld(playerid) == 0 ) return SendGuiInformation(playerid, "Informacja", "Akcja niedozwolona w virtual world 0.");
			
			if( !strcmp(inputtext, "TAK", true) )
			{ 
				new d_id = pInfo[playerid][player_dialog_tmp1];
				new o_id = INVALID_STREAMER_ID;

			 	for (new player_object = 0; player_object <= MAX_VISIBLE_OBJECTS; player_object++)
				{
					if(IsValidPlayerObject(playerid, player_object))
					{
						o_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);
						if( Object[o_id][object_owner_type] != OBJECT_OWNER_TYPE_DOOR ) continue;
						if( Object[o_id][object_owner] == Door[d_id][door_uid] )
						{
							DestroyDynamicObject(o_id);

							for(new z=0; e_objects:z != e_objects; z++)
							{
						  		Object[o_id][e_objects:z] = 0;
						    }
						}
					}
				}

				mysql_query(mySQLconnection, sprintf("DELETE FROM `ipb_objects` WHERE `object_ownertype` = %d AND object_owner = %d", OBJECT_OWNER_TYPE_DOOR, Door[d_id][door_uid]));
				SendClientMessage(playerid, COLOR_GOLD, "Interior zosta� pomy�lnie skasowany, nie b�dzie ju� mo�liwo�ci jego przywr�cenia.");
			}
			return cmd_drzwi(playerid, "opcje");
		}

		case DIALOG_ADRZWI_CHANGE_INTERIOR:
		{
			new d_id = DynamicGui_GetDialogValue(playerid);

			if( !response ) return 1;

			switch( DynamicGui_GetValue(playerid, listitem) )
			{
				case DG_DRZWI_CHANGE_INTERIOR_PREV:
				{
					DoorsDefaultInteriorsList(playerid, d_id, pInfo[playerid][player_dialog_tmp1]-1);
				}

				case DG_DRZWI_CHANGE_INTERIOR_NEXT:
				{
					DoorsDefaultInteriorsList(playerid, d_id, pInfo[playerid][player_dialog_tmp1]+1);
				}

				case DG_DRZWI_CHANGE_INTERIOR_ROW:
				{
					foreach(new p : Player)
					{
						if( GetPlayerVirtualWorld(p) == Door[d_id][door_spawn_vw] )
						{
							SetPlayerVirtualWorld(p, Door[d_id][door_vw]);
							SetPlayerInterior(p, Door[d_id][door_int]);

							RP_PLUS_SetPlayerPos(p, Door[d_id][door_pos][0], Door[d_id][door_pos][1], Door[d_id][door_pos][2]);
							SetPlayerFacingAngle(p, Door[d_id][door_pos][3]);

							SendClientMessage(p, COLOR_LIGHTER_RED, "Drzwi, w ktorych si� znajdowa�e� zosta�y zmienione przez administratora. zosta�e� przeniesiony do ich wej�cia.");
						}
					}

					if( DynamicGui_GetDataInt(playerid, listitem) == -1 )
					{
						Door[d_id][door_spawn_int] = 0;
						Door[d_id][door_spawn_pos][0] = Door[d_id][door_pos][0];
						Door[d_id][door_spawn_pos][1] = Door[d_id][door_pos][1];
						Door[d_id][door_spawn_pos][2] = Door[d_id][door_pos][2];
						Door[d_id][door_spawn_pos][3] = Door[d_id][door_pos][3];
					}
					else
					{
						new Cache:tmp_cache;
						tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT interior, x, y, z, a FROM `ipb_default_interiors` WHERE `id` = %d", DynamicGui_GetDataInt(playerid, listitem)));

						cache_get_value_index_int(0, 0, Door[d_id][door_spawn_int]);
						cache_get_value_index_float(0, 1, Door[d_id][door_spawn_pos][0]);
						cache_get_value_index_float(0, 2, Door[d_id][door_spawn_pos][1]);
						cache_get_value_index_float(0, 3, Door[d_id][door_spawn_pos][2]);
						cache_get_value_index_float(0, 4, Door[d_id][door_spawn_pos][3]);

						if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
					}

					mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_exitint` = %d, `door_exitx` = %f, `door_exity` = %f, `door_exitz` = %f, `door_exita` = %f WHERE `door_uid` = %d", Door[d_id][door_spawn_int], Door[d_id][door_spawn_pos][0], Door[d_id][door_spawn_pos][1], Door[d_id][door_spawn_pos][2], Door[d_id][door_spawn_pos][3], Door[d_id][door_uid]));

					SendFormattedClientMessage(playerid, COLOR_GOLD, "Interior drzwi zosta� pomy�lnie zmieniony [INTERIOR: %d, UID: %d, ID: %d].", Door[d_id][door_spawn_int], Door[d_id][door_uid], d_id);
				}
			}
		}

		case DIALOG_ADRZWI_PICKUP:
		{
			if( !response ) return 1;

			new d_id = DynamicGui_GetDialogValue(playerid);
			new d_pickup = DynamicGui_GetDataInt(playerid, listitem);

			if(d_pickup == 7777)
			{
				ShowPlayerDialog(playerid, DIALOG_ADRZWI_OWN_PICKUP, DIALOG_STYLE_INPUT, "Zmiana pickupa drzwi", "Podaj model pickupa do zmiany.", "Zmie�", "Anuluj");
				return 1;
			}

			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_pickupid` = %d WHERE `door_uid` = %d", d_pickup, Door[d_id][door_uid]));

			new uid = Door[d_id][door_uid];
			DeleteDoor(d_id, false);

			new did = LoadDoor(sprintf("WHERE `door_uid` = %d", uid), true);
			SendFormattedClientMessage(playerid, COLOR_GOLD, "Pickup drzwi zosta� pomy�lnie zmieniony. [PICKUP: %d, UID: %d, ID: %d]", d_pickup, uid, did);
		}

		case DIALOG_ADRZWI_OWN_PICKUP:
		{
			if( !response ) return 1;
			new d_id = DynamicGui_GetDialogValue(playerid);
			new d_pickup = strval(inputtext);
			if(!IsValidObjectModel(d_pickup)) return ShowPlayerDialog(playerid, DIALOG_ADRZWI_OWN_PICKUP, DIALOG_STYLE_INPUT, "Zmiana pickupa drzwi", "Podaj model pickupa do zmiany.", "Zmie�", "Anuluj");

			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_doors` SET `door_pickupid` = %d WHERE `door_uid` = %d", d_pickup, Door[d_id][door_uid]));

			new uid = Door[d_id][door_uid];
			DeleteDoor(d_id, false);

			new did = LoadDoor(sprintf("WHERE `door_uid` = %d", uid), true);
			SendFormattedClientMessage(playerid, COLOR_GOLD, "Pickup drzwi zosta� pomy�lnie zmieniony. [PICKUP: %d, UID: %d, ID: %d]", d_pickup, uid, did);
		}

		case DIALOG_AGRUPA_TYP:
		{
			if( !response ) return 1;

			new gid = DynamicGui_GetDialogValue(playerid), type = DynamicGui_GetDataInt(playerid, listitem);

			Group[gid][group_type] = type;
			Group[gid][group_flags] = GroupDefaultFlags[type];

			mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_game_groups` SET `group_type` = %d, `group_flags` = %d WHERE `group_uid` = %d", Group[gid][group_type], Group[gid][group_flags], Group[gid][group_uid]));

			SendGuiInformation(playerid, ""guiopis"Powiadomienie", sprintf("Zmieni�e� typ oraz domy�lne flagi grupy [TYP: %d, FLAG: %d, UID: %d, ID: %d].", Group[gid][group_type], Group[gid][group_flags], Group[gid][group_uid], gid));
		}

		case DIALOG_ADMIN_FLAGS:
		{
			if(!response) return 1;
			new str[600];

			new targetid = DynamicGui_GetValue(playerid, listitem);

			if( !IsPlayerConnected(targetid) ) return 1;
			if( !pInfo[targetid][player_logged] ) return 1;

			if(HasCrewFlag(targetid, CREW_FLAG_ADMIN_ROOT))
			{
				format(str, sizeof(str), "%sZale�y nam na szybkiej komunikacji, dlatego udost�pniamy Tobie posiadane przez administratora %s uprawnienia.\nJe�eli na poni�szej li�cie nie widzisz uprawnie�, dzi�ki kt�rym m�g�by� otrzyma� pomoc, skontaktuj si� z pozosta�ymi cz�onkami ekipy dost�pnymi na /a.\n\nUprawnienia administratora %s:\n", str, pInfo[targetid][player_name], pInfo[targetid][player_name]);
			}

			if(HasCrewFlag(targetid, CREW_FLAG_ADMIN))
			{
				format(str, sizeof(str), "%sZale�y nam na szybkiej komunikacji, dlatego udost�pniamy Tobie posiadane przez supportera %s uprawnienia.\nJe�eli na poni�szej li�cie nie widzisz uprawnie�, dzi�ki kt�rym m�g�by� otrzyma� pomoc, skontaktuj si� z pozosta�ymi cz�onkami ekipy dost�pnymi na /a.\n\nUprawnienia supportera %s:\n", str, pInfo[targetid][player_name], pInfo[targetid][player_name]);
			}

			if(HasCrewFlag(targetid, CREW_FLAG_DOORS))
			{
				format(str, sizeof(str), "%sZarz�dzanie drzwiami\n", str);
			}

			if(HasCrewFlag(targetid, CREW_FLAG_VEHICLES))
			{
				format(str, sizeof(str), "%sZarz�dzanie pojazdami\n", str);
			}

			if(HasCrewFlag(targetid, CREW_FLAG_GROUPS))
			{
				format(str, sizeof(str), "%sZarz�dzanie grupami\n", str);
			}

			if(HasCrewFlag(targetid, CREW_FLAG_AREAS))
			{
				format(str, sizeof(str), "%sZarz�dzanie strefami\n", str);
			}
			
			if(HasCrewFlag(targetid, CREW_FLAG_EDITOR))
			{
				format(str, sizeof(str), "%sZarz�dzanie obiektami i etykietami 3d\n", str);
			}

			if(HasCrewFlag(targetid, CREW_FLAG_ITEMS))
			{
				format(str, sizeof(str), "%sZarz�dzanie przedmiotami\n", str);
			}
			
			if(HasCrewFlag(targetid, CREW_FLAG_ADMIN_ROOT))
			{
				ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, sprintf("Flagi administratora %s", pInfo[targetid][player_name]), str, "Zamknij", "");
			}

			if(HasCrewFlag(targetid, CREW_FLAG_ADMIN))
			{
				ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, sprintf("Flagi supportera %s", pInfo[targetid][player_name]), str, "Zamknij", "");
			}
		}

		case DIALOG_CHAR_DESCRIPTION:
		{
			if( response == 0 ) return 1;
			new dg_value = DynamicGui_GetValue(playerid, listitem);

			if( dg_value == DG_CHAR_DESC_DELETE )
			{
				Update3DTextLabelText(pInfo[playerid][player_description_label], LABEL_DESCRIPTION, "");
				pInfo[playerid][player_description][0] = EOS;
				SendGuiInformation(playerid, "Informacja", "Tw�j aktualny opis zosta� usuni�ty.");
			}
			else if( dg_value == DG_CHAR_DESC_ADD)
			{
				ShowPlayerDialog(playerid, DIALOG_CHAR_DESCRIPTION_ADD, DIALOG_STYLE_INPUT, "Opis postaci", "Poni�ej wpisz opis, kt�ry chcesz ustawi�. (max. 110 znak�w)", "Ustaw", "Zamknij");
			}
			else if( dg_value == DG_CHAR_DESC_OLD )
			{
				new Cache:tmp_cache;
				tmp_cache = mysql_query(mySQLconnection ,sprintf("SELECT * FROM `ipb_descriptions` WHERE `uid` = %d", DynamicGui_GetDataInt(playerid, listitem)));

				new oldDesc[256];
				cache_get_value_index(0, 1, oldDesc);

				mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_descriptions` SET `last_used` = '%d' WHERE `uid`='%d'", gettime(), DynamicGui_GetDataInt(playerid, listitem)));

				strcopy(pInfo[playerid][player_description], oldDesc);

				Attach3DTextLabelToPlayer(pInfo[playerid][player_description_label], playerid, 0.0, 0.0, -0.7);
				Update3DTextLabelText(pInfo[playerid][player_description_label], LABEL_DESCRIPTION, BreakLines(oldDesc, "\n", 32));
				SendGuiInformation(playerid, "Informacja", "Tw�j aktualny opis zosta� zmieniony.");

				if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
			}
		}

		case DIALOG_CHAR_DESCRIPTION_ADD:
		{
			if( response == 0 ) return cmd_opis(playerid, "");

			if(strlen(inputtext) > 110) return SendGuiInformation(playerid, "Informacja", "Zbyt du�a ilo�� znak�w.");

			new inputOpis[256], Cache:tmp_cache;
			strcopy(inputOpis, inputtext, 256);

			mysql_escape_string(inputOpis, inputOpis, 128);
			tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM `ipb_descriptions` WHERE `text`='%s' AND `owner`='%d'", inputOpis, pInfo[playerid][player_id]));

			if( cache_num_rows() )
			{
				new descUid;
				cache_get_value_index_int(0, 0, descUid);

				mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_descriptions` SET `last_used`='%d' WHERE `uid`='%d'", gettime(), descUid));
			}
			else
			{
				mysql_tquery(mySQLconnection, sprintf("INSERT INTO `ipb_descriptions` (uid, owner, text, last_used) VALUES (null, '%d', '%s', '%d')", pInfo[playerid][player_id], inputOpis, gettime()));
			}

			strcopy(pInfo[playerid][player_description], inputOpis);

			Attach3DTextLabelToPlayer(pInfo[playerid][player_description_label], playerid, 0.0, 0.0, -0.7);
			Update3DTextLabelText(pInfo[playerid][player_description_label], LABEL_DESCRIPTION, BreakLines(inputOpis, "\n", 32));
			SendGuiInformation(playerid, "Informacja", "Tw�j aktualny opis zosta� zmieniony.");
			if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
		}

		case DIALOG_GROUP_MAGAZYN:
		{
			new dg_value = DynamicGui_GetValue(playerid, listitem), dg_data = DynamicGui_GetDataInt(playerid, listitem);
			if( !response)
			{
				TextDrawHideForPlayer(playerid, Tutorial[playerid]);
				return 1;
			}

			if( response && dg_value == DG_ITEMS_ITEM_ROW )
			{
				TextDrawHideForPlayer(playerid, Tutorial[playerid]);
				DynamicGui_Init(playerid);
				DynamicGui_SetDialogValue(playerid, dg_data);
				ShowPlayerDialog(playerid, DIALOG_GROUP_MAGAZYN_ID, DIALOG_STYLE_INPUT, "Oferowanie produktu", "Podaj ID gracza kt�remu chcesz sprzeda� produkt.", "Oferuj", "Anuluj");
			}
		}


		case DIALOG_GROUP_MAGAZYN_ID:
		{
			if( !response ) return 1;

			new customerid = strval(inputtext);
			new itemid = DynamicGui_GetDialogValue(playerid);
			new gid = pInfo[playerid][player_duty_gid];
			if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz si� na s�u�bie grupy.");

			if(!IsPlayerConnected(customerid)) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Gracza o podanym id nie ma na serwerze.");
			if( !pInfo[customerid][player_logged] ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Gracza o podanym id nie ma na serwerze.");

			new Float:dist;
			dist = GetDistanceBetweenPlayers(playerid, customerid);
			if(dist>3.0) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Ten gracz znajduje sie zbyt daleko.");

			if(GetPlayerVirtualWorld(playerid) == 0)
			{
				new a_id = pInfo[playerid][player_area];
				if(a_id > 0)
				{
					if( !AreaHasFlag(a_id, AREA_FLAG_OFFER) ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Ta strefa nie posiada flagi umo�liwiaj�cej oferowanie w niej produkt�w."); 
					if(Area[a_id][area_owner_type] != AREA_OWNER_TYPE_GROUP) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Ta strefa nie nale�y do Ciebie lub nie jeste� na s�u�bie grupy mog�cej tu handlowa�.");
				    if(Area[a_id][area_owner] != Group[gid][group_uid]) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Ta strefa nie nale�y do Ciebie lub nie jeste� na s�u�bie grupy mog�cej tu handlowa�.");

				    new resp = SetOffer(playerid, customerid, OFFER_TYPE_PRODUCT, Item[itemid][item_price], itemid);
				    if( resp ) ShowPlayerOffer(customerid, playerid, "Produkt", sprintf("%s [%d]", Item[pOffer[customerid][offer_extraid]][item_name], Item[pOffer[customerid][offer_extraid]][item_uid]), Item[pOffer[customerid][offer_extraid]][item_price]);
				}
				else
				{
					SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie znajdujesz si� w strefie grupy z flag� do oferowania produkt�w.");
				}
			}
			else
			{
				new d_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
				if (d_id != -1)
				{
					if(Door[d_id][door_owner_type] != DOOR_OWNER_TYPE_GROUP) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Te drzwi nie s� przypisane pod �adn� grup�."); 
					if(Door[d_id][door_owner] != Group[gid][group_uid]) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Te drzwi nie s� przypisane pod twoj� grup� lub nie jeste� na jej s�u�bie.");

					new resp = SetOffer(playerid, customerid, OFFER_TYPE_PRODUCT, Item[itemid][item_price], itemid);
				    if( resp ) ShowPlayerOffer(customerid, playerid, "Produkt", sprintf("%s [%d]", Item[pOffer[customerid][offer_extraid]][item_name], Item[pOffer[customerid][offer_extraid]][item_uid]), Item[pOffer[customerid][offer_extraid]][item_price]);
				}
			}
		}

		case DIALOG_GROUP_VEHICLES:
		{
			if( !response ) return 1;

			new v_uid = DynamicGui_GetValue(playerid, listitem), vid = GetVehicleByUid(v_uid);
			if( vid != INVALID_VEHICLE_ID )
			{
				DeleteVehicle(vid);
				GameTextForPlayer(playerid, "~w~pojazd ~r~odspawnowany", 3000, 6);
			}
			else
			{
				LoadVehicle(sprintf("WHERE `vehicle_uid` = %d", v_uid), true);

				GameTextForPlayer(playerid, "~w~pojazd ~g~zespawnowany", 3000, 6);
			}
		}

		case DIALOG_PLAYER_VEHICLES:
		{
			if( !response ) return 1;

			new v_uid = DynamicGui_GetValue(playerid, listitem), vid = GetVehicleByUid(v_uid);
			if( vid != INVALID_VEHICLE_ID )
			{
				DeleteVehicle(vid);
				GameTextForPlayer(playerid, "~w~pojazd ~r~odspawnowany", 3000, 6);
			}
			else
			{
				new count = 0;
				foreach(new v_id : Vehicles)
				{
					if( Vehicle[v_id][vehicle_owner_type] == VEHICLE_OWNER_TYPE_PLAYER && Vehicle[v_id][vehicle_owner] == pInfo[playerid][player_id] ) count++;
				}

				if( IsPlayerVip(playerid) && count >= 5 ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie mozesz zespawnowa� wi�cej ni� 5 pojazd�w.");
				else if( !IsPlayerVip(playerid) && count >= 2 ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie mozesz zespawnowa� wi�cej ni� 2 pojazd�w. Konto premium zwi�ksza ten limit o 3.");

				LoadVehicle(sprintf("WHERE `vehicle_uid` = %d", v_uid), true);

				GameTextForPlayer(playerid, "~w~pojazd ~g~zespawnowany", 3000, 6);
			}
		}

		case DIALOG_TUNE:
		{
			if( !response ) return 1;
			new vid = GetPlayerVehicleID(playerid);
			if(vid == INVALID_VEHICLE_ID) return 1;
			new componentid = DynamicGui_GetValue(playerid, listitem);
			new slot = GetVehicleComponentType(componentid);
			if(slot != -1)
			{
			    Vehicle[vid][vehicle_component][slot] = 0;
			    RemoveVehicleComponent(vid , componentid);

			    new comp0 = Vehicle[vid][vehicle_component][0];
				new comp1 = Vehicle[vid][vehicle_component][1];
				new comp2 = Vehicle[vid][vehicle_component][2];
				new comp3 = Vehicle[vid][vehicle_component][3];
				new comp4 = Vehicle[vid][vehicle_component][4];
				new comp5 = Vehicle[vid][vehicle_component][5];
				new comp6 = Vehicle[vid][vehicle_component][6];
				new comp7 = Vehicle[vid][vehicle_component][7];
				new comp8 = Vehicle[vid][vehicle_component][8];
				new comp9 = Vehicle[vid][vehicle_component][9];
				new comp10 = Vehicle[vid][vehicle_component][10];
				new comp11 = Vehicle[vid][vehicle_component][11];
				new comp12 = Vehicle[vid][vehicle_component][12];
				new comp13 = Vehicle[vid][vehicle_component][13];

			    new visual_tuning[128];
				format(visual_tuning, sizeof(visual_tuning), "%d %d %d %d %d %d %d %d %d %d %d %d %d %d", comp0, comp1, comp2, comp3, comp4, comp5, comp6, comp7,comp8, comp9, comp10, comp11, comp12, comp13);
		    	mysql_query(mySQLconnection, sprintf("UPDATE ipb_vehicles SET vehicle_component = '%s' WHERE vehicle_uid = %d", visual_tuning, Vehicle[vid][vehicle_uid]));

		    	new it_name[40];
		    	format(it_name, sizeof(it_name), "%s", GetComponentName(componentid));

		    	Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_TUNING, componentid, componentid, 0, it_name);
		    	SendGuiInformation(playerid, "Informacja", "Komponent zosta� pomy�lnie wymontowany.");
			}
		}

		case DIALOG_PLAYER_VEHICLE_PANEL:
		{
			if( !response ) return 1;

			new vid = GetPlayerVehicleID(playerid);
			if( vid == INVALID_VEHICLE_ID ) return 1;

			new selected = DynamicGui_GetValue(playerid, listitem);

			switch( selected )
			{
				case DG_PLAYER_VEHICLE_PANEL_LIGHTS:
				{
					Vehicle[vid][vehicle_lights] = !Vehicle[vid][vehicle_lights];
				}

				case DG_PLAYER_VEHICLE_PANEL_BOOT:
				{
					Vehicle[vid][vehicle_boot] = !Vehicle[vid][vehicle_boot];
				}

				case DG_PLAYER_VEHICLE_PANEL_BONNET:
				{
					Vehicle[vid][vehicle_bonnet] = !Vehicle[vid][vehicle_bonnet];
				}

				case DG_PLAYER_VEHICLE_PANEL_WIN_DRIVER:
				{
					Vehicle[vid][vehicle_win_driver] = !Vehicle[vid][vehicle_win_driver];
				}

				case DG_PLAYER_VEHICLE_PANEL_WIN_PP:
				{
					Vehicle[vid][vehicle_win_pp] = !Vehicle[vid][vehicle_win_pp];
				}

				case DG_PLAYER_VEHICLE_PANEL_WIN_LT:
				{
					Vehicle[vid][vehicle_win_lt] = !Vehicle[vid][vehicle_win_lt];
				}

				case DG_PLAYER_VEHICLE_PANEL_WIN_PT:
				{
					Vehicle[vid][vehicle_win_pt] = !Vehicle[vid][vehicle_win_pt];
				}
			}

			if( selected == DG_PLAYER_VEHICLE_PANEL_LIGHTS || selected == DG_PLAYER_VEHICLE_PANEL_BONNET || selected == DG_PLAYER_VEHICLE_PANEL_BOOT ) UpdateVehicleVisuals(vid);
			else if( selected == DG_PLAYER_VEHICLE_PANEL_WIN_DRIVER || selected == DG_PLAYER_VEHICLE_PANEL_WIN_PP || selected == DG_PLAYER_VEHICLE_PANEL_WIN_LT || selected == DG_PLAYER_VEHICLE_PANEL_WIN_PT ) UpdateWindowVisuals(vid);

			cmd_pojazd(playerid, "");
		}

		case DIALOG_TAKE_BAG:
		{
			if( response)
			{
				new iuid = strval(inputtext);
				if(iuid == -1) return 1;

				new bagid = DynamicGui_GetDialogValue(playerid);
				if(bagid == -1) return 1;

				ProxMessage(playerid, "wyjmuje przedmiot z torby.", PROX_SERWERME);
				mysql_query(mySQLconnection, sprintf("UPDATE `ipb_items` SET `item_ownertype` = %d, `item_owner` = %d WHERE `item_uid` = %d", ITEM_OWNER_TYPE_PLAYER, pInfo[playerid][player_id], iuid));
				new itemid = LoadPlayerItem(playerid, sprintf("WHERE `item_uid` = %d", iuid), true);
				if(itemid != -1) PlayerItem[playerid][bagid][player_item_weight] -= PlayerItem[playerid][itemid][player_item_weight];
			}

			else if( !response ) return 1;
		}

		case DIALOG_PLAYER_ITEMS:
		{
			new dg_value = DynamicGui_GetValue(playerid, listitem), dg_data = DynamicGui_GetDataInt(playerid, listitem);
			if( !response && dg_value == DG_NO_ACTION ) return 1;

			if( response && dg_value == DG_ITEMS_ITEM_ROW )
			{
				Item_Use(dg_data, playerid);
			}

			if( !response && dg_value == DG_ITEMS_ITEM_ROW )
			{
				new itemid = dg_data;

				DynamicGui_Init(playerid);
				new string[200];

				format(string, sizeof(string), "%s01\tInformacje o przedmiocie\n", string);
				DynamicGui_AddRow(playerid, DG_ITEMS_MORE_INFO, itemid);

				if( IsPlayerInAnyVehicle(playerid) ) format(string, sizeof(string), "%s02\tOd�� przedmiot do pojazdu\n", string);
				else format(string, sizeof(string), "%s02\tOd�� przedmiot na ziemie\n", string);

				DynamicGui_AddRow(playerid, DG_ITEMS_MORE_DROPG, itemid);

				format(string, sizeof(string), "%s03\tOferuj innemu graczowi\n", string);
				DynamicGui_AddRow(playerid, DG_ITEMS_MORE_SELL, itemid);

				format(string, sizeof(string), "%s04\tW�� do torby\n", string);
				DynamicGui_AddRow(playerid, DG_ITEMS_MORE_PUT_IN_BAG, itemid);

				format(string, sizeof(string), "%s05\tZniszcz przedmiot\n", string);
				DynamicGui_AddRow(playerid, DG_ITEMS_MORE_DELETE, itemid);

				format(string, sizeof(string), "%s06\tEdytuj pozycje obiektu\n", string);
				DynamicGui_AddRow(playerid, DG_ITEMS_MORE_EDIT, itemid);

				format(string, sizeof(string), "%s07\tPo��cz\n", string);
				DynamicGui_AddRow(playerid, DG_ITEMS_MORE_CONNECT, itemid);

				if( GetPlayerVirtualWorld(playerid) > 0 )
				{
					new d_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
					if( d_id > -1 )
					{
						if( CanPlayerUseDoor(playerid, d_id) )
						{
							format(string, sizeof(string), "%s07\tW�� do schowka\n", string);
							DynamicGui_AddRow(playerid, DG_ITEMS_MORE_PUT_IN_DOOR, itemid);

							format(string, sizeof(string), "%s08\tW�� do magazynu\n", string);
							DynamicGui_AddRow(playerid, DG_ITEMS_MORE_PUT_IN_STORAGE, itemid);
						}
					}
				}

				ShowPlayerDialog(playerid, DIALOG_ITEM_MORE, DIALOG_STYLE_LIST, sprintf("%s [UID: %d] Opcje", PlayerItem[playerid][itemid][player_item_name], PlayerItem[playerid][itemid][player_item_uid]), string, "Wybierz", "Zamknij");
			}
		}

		case DIALOG_ITEM_MORE:
		{
			new dg_value = DynamicGui_GetValue(playerid, listitem), itemid = DynamicGui_GetDataInt(playerid, listitem);
			if( !response ) return 1;

			if( dg_value == DG_ITEMS_MORE_DROPG )
			{
				Item_Drop(itemid, playerid);
			}

			if( dg_value == DG_ITEMS_MORE_INFO)
			{
				new header[64], info[128];

				format(header, sizeof(header), "Informacje o: %s", PlayerItem[playerid][itemid][player_item_name]);
				format(info, sizeof(info), "UID:\t%d\nValue1:\t%d\nValue2:\t%d\nTyp:\t%d\nExtra id:\t%d\nModel:\t%d", PlayerItem[playerid][itemid][player_item_uid], PlayerItem[playerid][itemid][player_item_value1], PlayerItem[playerid][itemid][player_item_value2], PlayerItem[playerid][itemid][player_item_type], PlayerItem[playerid][itemid][player_item_extraid], PlayerItem[playerid][itemid][player_item_model]);
				
				if(PlayerItem[playerid][itemid][player_item_type] == ITEM_TYPE_WEAPON)
				{
					format(info, sizeof(info), "%s\nStan:\t%0.2f%%", info, PlayerItem[playerid][itemid][player_item_condition]);
				}

				ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_TABLIST, header, info, "OK", "");
			}


			if( dg_value == DG_ITEMS_MORE_SELL )
			{
				if( !response ) return 1;
				pInfo[playerid][player_dialog_tmp1] = itemid;
				if(PlayerItem[playerid][itemid][player_item_uid] == pInfo[playerid][player_dialog_tmp5]) return SendGuiInformation(playerid, "Informacja", "Pr�bowa bugowania, wys�ano informacje do administracji.");

				ShowPlayerDialog(playerid, DIALOG_ITEMS_OFFER_PRICE, DIALOG_STYLE_INPUT, "Oferowanie przedmiotu", "Podaj cene za jak� chcesz oferowa� przedmiot.", "Oferuj", "Zamknij");
			}

			if( dg_value == DG_ITEMS_MORE_PUT_IN_DOOR )
			{
				if(PlayerItem[playerid][itemid][player_item_used]) return SendGuiInformation(playerid, "Informacja", "Ten przedmiot jest w u�yciu.");

				new d_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
				if( d_id > -1 )
				{
					ProxMessage(playerid, "wk�ada przedmiot do schowka.", PROX_SERWERME);

					mysql_query(mySQLconnection, sprintf("UPDATE `ipb_items` SET `item_ownertype` = %d, `item_owner` = %d WHERE `item_uid` = %d", ITEM_OWNER_TYPE_DOOR, Door[d_id][door_uid], PlayerItem[playerid][itemid][player_item_uid]));

					DeleteItem(itemid, false, playerid);
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
				}
			}

			if( dg_value == DG_ITEMS_MORE_PUT_IN_BAG )
			{	
				if(PlayerItem[playerid][itemid][player_item_used]) return SendGuiInformation(playerid, "Informacja", "Ten przedmiot jest w u�yciu.");
				DynamicGui_Init(playerid);
				DynamicGui_SetDialogValue(playerid, itemid);
				new count, string[200];
				foreach(new item : PlayerItems[playerid])
				{
					if( PlayerItem[playerid][item][player_item_type] == ITEM_TYPE_BAG )
					{
						format(string, sizeof(string), "%s%d\t\t%s\n", string, PlayerItem[playerid][item][player_item_uid], PlayerItem[playerid][item][player_item_name]);
						DynamicGui_AddRow(playerid, item);
						count++;
					}
				}
				
				if( count == 0 ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz torby w ekwipunku.");
				else ShowPlayerDialog(playerid, DIALOG_USE_BAG, DIALOG_STYLE_LIST, "Wybierz do kt�rej torby chcesz w�ozy� przedmiot:", string, "Wybierz", "Zamknij");
			}

			if( dg_value == DG_ITEMS_MORE_DELETE )
			{	
				if(PlayerItem[playerid][itemid][player_item_type] != ITEM_TYPE_CORPSE && PlayerItem[playerid][itemid][player_item_type] != ITEM_TYPE_DRUG && PlayerItem[playerid][itemid][player_item_type] != ITEM_TYPE_WEAPON && PlayerItem[playerid][itemid][player_item_type] != ITEM_TYPE_BAG)
				{
					DynamicGui_Init(playerid);
					DynamicGui_SetDialogValue(playerid, itemid);
					SendGuiInformation(playerid, ""guiopis"Powiadomienie","Przedmiot zosta� zniszczony");
					ProxMessage(playerid, sprintf("niszczy przedmiot %s.", PlayerItem[playerid][itemid][player_item_name]), PROX_SERWERME);
					pInfo[playerid][player_capacity] += PlayerItem[playerid][itemid][player_item_weight];
					DeleteItem(itemid, true, playerid);
				}
				else
				{
					if(HasCrewFlag(playerid, CREW_FLAG_ADMIN_ROOT) )
					{
						DynamicGui_Init(playerid);
						DynamicGui_SetDialogValue(playerid, itemid);
						SendGuiInformation(playerid, ""guiopis"Powiadomienie","Przedmiot zosta� zniszczony");
						ProxMessage(playerid, sprintf("niszczy przedmiot %s.", PlayerItem[playerid][itemid][player_item_name]), PROX_SERWERME);
						pInfo[playerid][player_capacity] += PlayerItem[playerid][itemid][player_item_weight];
						DeleteItem(itemid, true, playerid);
						return 1;
					}

					SendGuiInformation(playerid, "Informacja", "Nie mo�esz zniszczy� przedmiotu o tym typie.");
				}
			}

			if( dg_value == DG_ITEMS_MORE_EDIT )
			{	
				if(PlayerItem[playerid][itemid][player_item_type] != ITEM_TYPE_WEAPON) return SendGuiInformation(playerid, ""guiopis"Powiadomienie","Edytowa� mo�esz jedynie obiekty przyczepialne broni.\nNie posiadasz takowego na sobie.");
				
				new weaponm = PlayerItem[playerid][itemid][player_item_model];
				new weaponi = PlayerItem[playerid][itemid][player_item_value1];

				new slot = GetPlayerWeaponAttachSlot(playerid, weaponi, weaponm);

				if(slot == -1) return SendGuiInformation(playerid, ""guiopis"Powiadomienie","Edytowa� mo�esz jedynie obiekty przyczepialne broni.\nNie posiadasz takowego na sobie.");

				EditAttachedObject(playerid, slot);
			}

			if( dg_value == DG_ITEMS_MORE_CONNECT)
			{	
				if(pInfo[playerid][player_dealing] > 0) return SendGuiInformation(playerid, ""guiopis"Powiadomienie","Akcja niedozwolona w trakcie handlu.");
				if(PlayerItem[playerid][itemid][player_item_type] != ITEM_TYPE_DRUG) return SendGuiInformation(playerid, ""guiopis"Powiadomienie","��czy� mo�esz jedynie narkotyki.");
				
				DynamicGui_Init(playerid);
				DynamicGui_SetDialogValue(playerid, itemid);
				new count, string[200];
				foreach(new item : PlayerItems[playerid])
				{
					if( PlayerItem[playerid][item][player_item_type] == ITEM_TYPE_DRUG && PlayerItem[playerid][itemid][player_item_value1] == PlayerItem[playerid][item][player_item_value1] && itemid != item )
					{
						format(string, sizeof(string), "%s%d\t\t%s\n", string, PlayerItem[playerid][item][player_item_uid], PlayerItem[playerid][item][player_item_name]);
						DynamicGui_AddRow(playerid, item);
						count++;
					}
				}
				if( count == 0 ) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie posiadasz �adnych innych narkotyk�w.");
				else ShowPlayerDialog(playerid, DIALOG_CONNECT_DRUGS, DIALOG_STYLE_LIST, "Wybierz przedmiot do zestackowania:", string, "Wybierz", "Zamknij");
			}

			if( dg_value == DG_ITEMS_MORE_PUT_IN_STORAGE )
			{
				new d_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
				if( d_id > -1 )
				{
					if(Door[d_id][door_owner_type] == DOOR_OWNER_TYPE_GROUP)
					{
						DynamicGui_Init(playerid);
						DynamicGui_SetDialogValue(playerid, itemid);

						ShowPlayerDialog(playerid, DIALOG_PUTTING_ITEM, DIALOG_STYLE_INPUT, "Magazynowanie przedmiotu", "Podaj kwot� za jak� chcesz sprzedawa� produkt.", "W�o�", "Anuluj");
					}
					else
					{
						SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Te drzwi nie s� podpisane pod grup�.");
					}
				}
			}
		}

		case DIALOG_CONNECT_DRUGS:
		{
			if( !response ) return 1;
			new baseid = DynamicGui_GetDialogValue(playerid), itemid = DynamicGui_GetValue(playerid, listitem);

			if(!Iter_Contains(PlayerItems[playerid], baseid) || !Iter_Contains(PlayerItems[playerid], itemid)) return 1;

			PlayerItem[playerid][itemid][player_item_value2] += PlayerItem[playerid][baseid][player_item_value2];
			PlayerItem[playerid][itemid][player_item_weight] += PlayerItem[playerid][baseid][player_item_weight];
			mysql_query(mySQLconnection, sprintf("UPDATE ipb_items SET item_value2 = %d WHERE item_uid = %d", PlayerItem[playerid][itemid][player_item_value2], PlayerItem[playerid][itemid][player_item_uid]), false);

			DeleteItem(baseid, true, playerid);
			SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Przedmiot po��czony.");
		}

		case DIALOG_PUTTING_ITEM:
		{
			if( !response ) return 1;

			new itemid = DynamicGui_GetDialogValue(playerid);
			new d_id = GetDoorByUid(GetPlayerVirtualWorld(playerid));
			new price = strval(inputtext);

			new uid = PlayerItem[playerid][itemid][player_item_uid];

			if(PlayerItem[playerid][itemid][player_item_used]) return SendGuiInformation(playerid, "Informacja", "Ten przedmiot jest w u�yciu.");
			if(price <= 0) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Cena nie moze by� ujemna i wynosi� zero.");

			DeleteItem(itemid, false, playerid);

			ProxMessage(playerid, "wk�ada przedmiot do magazynu.", PROX_SERWERME);

			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_items` SET `item_ownertype` = %d, `item_owner` = %d, `item_price` = %d, `item_count` = '1' WHERE `item_uid` = %d", ITEM_OWNER_TYPE_GROUP, Door[d_id][door_owner], price, uid));

			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
		}

		case DIALOG_ITEMS_PICKUP:
		{
			new dg_value = DynamicGui_GetValue(playerid, listitem), itemuid = DynamicGui_GetDataInt(playerid, listitem);
			if( !response ) return 1;

			if( dg_value == DG_ITEMS_PICKUP_ROW )
			{
				Item_Pickup(itemuid, playerid);
			}
		}

		case DIALOG_SCHOWEK_TAKE:
		{
			if( !response ) return 1;
			new itemuid = strval(inputtext);

			Item_Pickup(itemuid, playerid);
		}

		case DIALOG_USE_BAG:
		{
			if( !response ) return 1;

			new itemid = DynamicGui_GetDialogValue(playerid), bagid = DynamicGui_GetValue(playerid, listitem);

			if(PlayerItem[playerid][itemid][player_item_type]  == ITEM_TYPE_BAG) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie mo�esz w�o�y� torby do torby.");

			PlayerItem[playerid][bagid][player_item_weight] += PlayerItem[playerid][itemid][player_item_weight];
			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_items` SET `item_ownertype` = %d, `item_owner` = %d WHERE `item_uid` = %d", ITEM_OWNER_TYPE_ITEM, PlayerItem[playerid][bagid][player_item_uid], PlayerItem[playerid][itemid][player_item_uid]));
			DeleteItem(itemid, false, playerid);

			ProxMessage(playerid, "wk�ada przedmiot do torby.", PROX_SERWERME);
		}

		case DIALOG_USE_AMMO:
		{
			if( !response ) return 1;

			new ammoid = DynamicGui_GetDialogValue(playerid), itemid = DynamicGui_GetValue(playerid, listitem);

			PlayerItem[playerid][itemid][player_item_value2] += PlayerItem[playerid][ammoid][player_item_value2];
			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_items` SET `item_value2` = %d WHERE `item_uid` = %d", PlayerItem[playerid][itemid][player_item_value2], PlayerItem[playerid][itemid][player_item_uid]));

			SendGuiInformation(playerid, ""guiopis"Powiadomienie", sprintf("Za�adowano %d naboi do broni %s [UID: %d].", PlayerItem[playerid][ammoid][player_item_value2], PlayerItem[playerid][itemid][player_item_name], PlayerItem[playerid][itemid][player_item_uid]));

			DeleteItem(ammoid, true, playerid);
		}

		case DIALOG_TAKE:
		{
			if( !response ) return 1;

			new item = DynamicGui_GetValue(playerid, listitem);
			new targetid = DynamicGui_GetDialogValue(playerid);

			if(IsPlayerConnected(targetid))
			{
				if(!Iter_Contains(PlayerItems[targetid], item)) return 1;

				if(PlayerItem[targetid][item][player_item_used])
				{
					Item_Use(item, playerid);
				}

				new gid = pInfo[playerid][player_duty_gid];
				if (gid == - 1) return SendGuiInformation(playerid, "Informacja", "Nie jeste� na s�u�bie grupy.");

				if(GroupHasFlag(gid, GROUP_FLAG_911))
				{
					mysql_query(mySQLconnection, sprintf("UPDATE ipb_items SET item_ownertype = %d, item_owner = 5 WHERE item_uid = %d", ITEM_OWNER_TYPE_GROUP, PlayerItem[targetid][item][player_item_uid]));

					SendGuiInformation(playerid, "Informacja", sprintf("Przedmiot %s zosta� dodany do ekwipunku.", PlayerItem[targetid][item][player_item_name]));
					SendClientMessage(targetid, COLOR_LIGHTER_GREEN, sprintf("Funkcjonariusz %s zarekwirowa� ci przedmiot %s.", pInfo[playerid][player_name], PlayerItem[targetid][item][player_item_name]));

					//new iuid = PlayerItem[targetid][item][player_item_uid];
					DeleteItem(item, false, targetid);
					//LoadPlayerItem(playerid, sprintf("WHERE `item_uid` = %d", iuid), true);
				}
				else
				{
					mysql_query(mySQLconnection, sprintf("UPDATE ipb_items SET item_owner = %d WHERE item_uid = %d", pInfo[playerid][player_id], PlayerItem[targetid][item][player_item_uid]));
					
					SendGuiInformation(playerid, "Informacja", sprintf("Przedmiot %s zosta� dodany do ekwipunku.", PlayerItem[targetid][item][player_item_name]));
					SendClientMessage(targetid, COLOR_LIGHTER_GREEN, sprintf("Gracz %s zabra� ci przedmiot %s.", pInfo[playerid][player_name], PlayerItem[targetid][item][player_item_name]));

					new iuid = PlayerItem[targetid][item][player_item_uid];
					DeleteItem(item, false, targetid);
					LoadPlayerItem(playerid, sprintf("WHERE `item_uid` = %d", iuid), true);
				}

				ProxMessage(playerid, sprintf("zabra� przedmiot %s.", pInfo[targetid][player_name]), PROX_SERWERME);
			}
		}

		case DIALOG_USE_DRUG:
		{
			if( !response ) return 1;

			new itemid = DynamicGui_GetDialogValue(playerid);
			new str[40];
			new type = PlayerItem[playerid][itemid][player_item_value1];

			switch(listitem)
			{
				case 0: // Uzywanie narkotyku
				{
					format(str, sizeof(str), "za�ywa %s", PlayerItem[playerid][itemid][player_item_name]);
					ProxMessage(playerid, str, PROX_SERWERME);

					if(PlayerItem[playerid][itemid][player_item_value2] == 1)
					{
						DeleteItem(itemid, true, playerid);
					}
					else
					{
						PlayerItem[playerid][itemid][player_item_value2]--;
						PlayerItem[playerid][itemid][player_item_weight] = PlayerItem[playerid][itemid][player_item_value2];
						mysql_query(mySQLconnection, sprintf("UPDATE ipb_items SET item_value2 = %d, item_weight = %d WHERE item_uid = %d", PlayerItem[playerid][itemid][player_item_value2], PlayerItem[playerid][itemid][player_item_weight], PlayerItem[playerid][itemid][player_item_uid]));
					}

					if(!PlayerHasAchievement(playerid, ACHIEV_ADDICT)) AddAchievement(playerid, ACHIEV_ADDICT, 50);

					if(pInfo[playerid][player_health] > 10)
					{
						SetPlayerHealth(playerid, floatround(pInfo[playerid][player_health])-10);
					}

					switch(type)
					{
						case DRUG_TYPE_COCAINE:
						{
							AddPlayerStatus(playerid, PLAYER_STATUS_DRUGS);
						}
						case DRUG_TYPE_CRACK:
						{
							AddPlayerStatus(playerid, PLAYER_STATUS_DRUGS);
							//Efekt here
						}
						case DRUG_TYPE_AMFA:
						{
							AddPlayerStatus(playerid, PLAYER_STATUS_DRUGS);
							//Efekt here
						}
						case DRUG_TYPE_HEROINE:
						{
							AddPlayerStatus(playerid, PLAYER_STATUS_DRUGS);
							//Efekt here
						}
						case DRUG_TYPE_WEED:
						{
							AddPlayerStatus(playerid, PLAYER_STATUS_WEED);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
						}
						case DRUG_TYPE_METH:
						{
							AddPlayerStatus(playerid, PLAYER_STATUS_DRUGS);
							//Efekt here
						}
						case DRUG_TYPE_EXTASY:
						{
							AddPlayerStatus(playerid, PLAYER_STATUS_DRUGS);
							//Efekt here
						}
					}
				}
				case 1:
				{
					new aid = pInfo[playerid][player_area];
					if(aid == -1) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie znajdujesz si� w strefie handlu.");
					if(!AreaHasFlag(aid, AREA_FLAG_CORNER)) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie znajdujesz si� w strefie handlu.");
					if(pInfo[playerid][player_dealing] > 0) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Jeste� ju� w trakcie handlu, poczekaj a� obecny towar si� sprzeda.");

					new p_count;
					foreach(new pid: Player)
					{
						if(pInfo[pid][player_dealing] > 0 && pInfo[pid][player_area] == pInfo[playerid][player_area])
						{
							p_count++;
						}
					}

					if(p_count >= 2) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Ta strefa handlu jest pe�na, poszukaj jakiej� wolnej.\nLimit to dwie osoby na jedn� stref�.");

					if(PlayerItem[playerid][itemid][player_item_value2] <= 0)
					{
						SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nieprawid�owe value narkotyku, nie mo�na rozpocz�� handlu.");
						DeleteItem(itemid, true, playerid);
						return 1;
					} 
					
					if(IsValidDrugType(playerid, itemid))
					{
						pInfo[playerid][player_dealing] = 120;
						pInfo[playerid][player_dialog_tmp4] = itemid;
						pInfo[playerid][player_dialog_tmp5] = PlayerItem[playerid][itemid][player_item_uid];

						TextDrawSetString(Tutorial[playerid], sprintf("~w~Oczekiwanie na klienta.~n~Pozostaly czas: ~y~%ds", pInfo[playerid][player_dealing]));
						TextDrawShowForPlayer(playerid, Tutorial[playerid]);

						AddPlayerStatus(playerid, PLAYER_STATUS_DEALING);
						ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_02", 4.1, 0, 0, 0, 1, 0, 0);
						pInfo[playerid][player_looped_anim] = true;
					}
					else
					{
						SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nieprawid�owy typ narkotyku, nie mo�na rozpocz�� handlu.");
						return 1;
					}
				}
				case 2:
				{
					DynamicGui_Init(playerid);
					DynamicGui_SetDialogValue(playerid, itemid);
					ShowPlayerDialog(playerid, DIALOG_PAKOWANIE, DIALOG_STYLE_INPUT, "Dzielenie narkotyku", "Podaj ile gram�w chcesz mie� w jednej porcji.", "Dziel", "Anuluj");
				}
				case 3:
				{
					if(PlayerItem[playerid][itemid][player_item_value1] != DRUG_TYPE_COCAINE) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Crack mo�na ugotowa� jedynie z kokainy.");
					new object_id = GetClosestObjectType(playerid, OBJECT_CRACK);
					if(object_id == INVALID_STREAMER_ID) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie znajdujesz si� obok kuchenki.");

					DeleteItem(itemid, true, playerid);
					Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_DRUG, 1575, DRUG_TYPE_CRACK, 3, "Crack");

					SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Pomy�lnie ugotowano 3 gramy cracku z 1 grama kokainy.");
				}
			}
		}

		case DIALOG_FINGERPRINTS:
		{
			if( !response ) return 1;

			new finger = strval(inputtext);
			new name[MAX_PLAYER_NAME+1], str[64];
			GetPlayerNameByUid(finger, name);
			
			format(str, sizeof(str), "Odcisk nale�y do gracza %s.", name);
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Wyniki badania", str, "OK", "");
		}

		case DIALOG_PAKOWANIE:
		{
			if( !response ) return 1;
			if(isnull(inputtext)) return 1;
			new itemid = DynamicGui_GetDialogValue(playerid);
			new ilosc = strval(inputtext);
			if( strfind(inputtext, ",", true) != -1 || strfind(inputtext, ".", true) != -1 ) return SendGuiInformation(playerid, "Informacja", "Liczba musi by� ca�kowita");

			if(ilosc >= PlayerItem[playerid][itemid][player_item_value2]) return 1;
			if(ilosc < 1) return 1;

			new second = PlayerItem[playerid][itemid][player_item_value2] - ilosc;
			if(second < 1) return 1;

			new string[40];
			format(string, sizeof(string), "%s", PlayerItem[playerid][itemid][player_item_name]);
			new drugtype = PlayerItem[playerid][itemid][player_item_value1];

			Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_DRUG, 1575, drugtype, ilosc, string);

			Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_DRUG, 1575, drugtype, second, string);

			SendGuiInformation(playerid, "Informacja", "Przedmiot zosta� pomy�lnie podzielony.");
			DeleteItem(itemid, true, playerid);
		}

		case DIALOG_PHONE:
		{
			if( !response ) return 1;

			new dg_value = DynamicGui_GetValue(playerid, listitem), itemid = DynamicGui_GetDialogValue(playerid);

			if( dg_value == DG_PHONE_TURNOFF )
			{
				PlayerItem[playerid][itemid][player_item_used] = false;
				mysql_query(mySQLconnection, sprintf("UPDATE `ipb_items` SET `item_used` = 0 WHERE `item_uid` = %d", PlayerItem[playerid][itemid][player_item_uid]));

				GameTextForPlayer(playerid, "~w~Telefon ~r~wylaczony", 3000, 3);
			}
			else if( dg_value == DG_PHONE_CALL )
			{
				ShowPlayerDialog(playerid, DIALOG_PHONE_CALL_NUMBER, DIALOG_STYLE_INPUT, "Wybieranie numeru", "Podaj numer telefonu z kt�rym chcesz si� po��czy�:", "Dalej", "Zamknij");
			}
			else if( dg_value == DG_PHONE_SMS )
			{
				ShowPlayerDialog(playerid, DIALOG_PHONE_SMS_NUMBER, DIALOG_STYLE_INPUT, "Wysy�anie SMS", "Podaj numer telefonu na kt�ry chcesz wys�ac sms:", "Dalej", "Zamknij");
			}
			else if( dg_value == DG_PHONE_CONTACTS )
			{
				DynamicGui_Init(playerid);
				new string[1024];

				format(string, sizeof(string), "%s911\tNumer alarmowy\n", string);
				DynamicGui_AddRow(playerid, DG_PHONE_CONTACTS_BASE, 911);

				format(string, sizeof(string), "%s444\tWeazel News\n", string);
				DynamicGui_AddRow(playerid, DG_PHONE_CONTACTS_BASE, 444);

				format(string, sizeof(string), "%s333\tHurtownia\n", string);
				DynamicGui_AddRow(playerid, DG_PHONE_CONTACTS_BASE, 333);

				format(string, sizeof(string), "%s---\tBiznesy\n", string);
				DynamicGui_AddRow(playerid, DG_PHONE_CONTACTS_BASE, 668);

				format(string, sizeof(string), "%s-----\n", string);
				DynamicGui_AddBlankRow(playerid);

				new rows, Cache:tmp_cache;
				tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM `ipb_contacts` WHERE `contact_owner` = %d AND `contact_deleted` = 0", PlayerItem[playerid][itemid][player_item_uid]));
				cache_get_row_count(rows);

				if( !rows ) SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Brak zapisanych kontakt�w.");
				else
				{
				  	for(new row = 0; row != rows; row++)
					{
						new tmp[MAX_PLAYER_NAME+1], tmpid, tmpsmth;
						cache_get_value_index_int(row, 0, tmpid);
						cache_get_value_index_int(row, 1, tmpsmth);
						cache_get_value_index(row, 2, tmp);

						format(string, sizeof(string), "%s%d\t%s\n", string, tmpsmth, tmp);
						DynamicGui_AddRow(playerid, DG_PHONE_CONTACTS_ROW, tmpid);
					}
				}

				if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);

				ShowPlayerDialog(playerid, DIALOG_PHONE_CONTACTS, DIALOG_STYLE_LIST, sprintf("%s [%d]: Kontakty", PlayerItem[playerid][itemid][player_item_name], PlayerItem[playerid][itemid][player_item_value1]), string, "Wybierz", "Zamknij");
			}
			else if( dg_value == DG_PHONE_ADD_CONTACT )
			{
				ShowPlayerDialog(playerid, DIALOG_PHONE_ADD_CONTACT, DIALOG_STYLE_INPUT, sprintf("%s [%d]: Dodawanie kontaktu", PlayerItem[playerid][itemid][player_item_name], PlayerItem[playerid][itemid][player_item_value1]), "Wpisz numer telefonu, kt�ry chcesz doda� do kontakt�w.", "Dodaj", "Zamknij");
			}
			else if( dg_value == DG_PHONE_VCARD )
			{
				DynamicGui_Init(playerid);
				new string[1024], count;

				new Float:p_pos[3];
				GetPlayerPos(playerid, p_pos[0], p_pos[1], p_pos[2]);

				foreach(new p : Player)
				{
					if( !pInfo[p][player_logged] ) continue;
					if( pInfo[p][player_spec] != INVALID_PLAYER_ID) continue;
					if( p == playerid ) continue;
					if( GetPlayerDistanceFromPoint(p, p_pos[0], p_pos[1], p_pos[2]) <= 10.0 )
					{
						if( GetPlayerUsedItem(playerid, ITEM_TYPE_MASKA) > -1 ) format(string, sizeof(string), "%s##\t\t%s\n", string, pInfo[p][player_name]);
						else format(string, sizeof(string), "%s%d\t\t%s\n", string, p, pInfo[p][player_name]);

						DynamicGui_AddRow(playerid, p);
						count++;
					}
				}

				if( count == 0 ) SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Brak os�b w okolicy.");
				else ShowPlayerDialog(playerid, DIALOG_PHONE_VCARD, DIALOG_STYLE_LIST, "Osoby w okolicy:", string, "Wy�lij", "Zamknij");
			}
		}

		case DIALOG_PHONE_SMS_NUMBER:
		{
			if( !response ) return 1;

			new number;
			if( sscanf(inputtext, "d", number) ) return ShowPlayerDialog(playerid, DIALOG_PHONE_SMS_NUMBER, DIALOG_STYLE_INPUT, "Wysylanie SMS", "Podaj numer na kt�ry chcesz wysla� SMS:\n\n"HEX_COLOR_LIGHTER_RED"Niepoprawny numer.", "Dalej", "Zamknij");

			pInfo[playerid][player_dialog_tmp1] = number;

			ShowPlayerDialog(playerid, DIALOG_PHONE_SMS_TEXT, DIALOG_STYLE_INPUT, "Wysy�anie SMS", "Podaj tre�� SMSa:", "Wy�lij", "Zamknij");
		}

		case DIALOG_PHONE_SMS_TEXT:
		{
			if( !response ) return 1;

			if( isnull(inputtext) ) return ShowPlayerDialog(playerid, DIALOG_PHONE_SMS_TEXT, DIALOG_STYLE_INPUT, "Wysy�anie SMS", "Podaj tre�� wiadomo�ci SMS:\n\n"HEX_COLOR_LIGHTER_RED"Tresc smsa musi cos zawierac.", "Wyslij", "Zamknij");

			cmd_sms(playerid, sprintf("%d %s", pInfo[playerid][player_dialog_tmp1], inputtext));
		}

		case DIALOG_PHONE_CALL_NUMBER:
		{
			if( !response) return 1;
			new number;
			if( sscanf(inputtext, "d", number) ) return ShowPlayerDialog(playerid, DIALOG_PHONE_CALL_NUMBER, DIALOG_STYLE_INPUT, "Wybieranie numeru", "Podaj numer telefonu na kt�ry chcesz zadzwoni�:\n\n"HEX_COLOR_LIGHTER_RED"Niepoprawny numner.", "Dalej", "Zamknij");

			cmd_call(playerid, sprintf("%d", number));
		}

		case DIALOG_PHONE_CONTACTS:
		{
			if( !response ) return 1;

			new dg_value = DynamicGui_GetValue(playerid, listitem), dg_data = DynamicGui_GetDataInt(playerid, listitem);

			if( dg_value == DG_PHONE_CONTACTS_BASE )
			{
				if(dg_data == 668)
				{
					new list_business[1024];
					DynamicGui_Init(playerid);
					foreach(new gid: Groups)
					{
						if( !GroupHasFlag(gid, GROUP_FLAG_BUSINESS) ) continue;
						new count = CountGroupPlayers(gid);
						if(count == 0) continue;

						format(list_business, sizeof(list_business), "%s\n%s\t%d", list_business, Group[gid][group_name], count);
						DynamicGui_AddRow(playerid, gid);
					}

					if(!strlen(list_business)) return SendGuiInformation(playerid, "Informacja", "Brak aktywnych biznes�w.");

					format(list_business, sizeof(list_business), "Nazwa biznesu\tAktywni pracownicy\n%s", list_business);
					ShowPlayerDialog(playerid, DIALOG_PHONE_CALL_GROUP, DIALOG_STYLE_TABLIST_HEADERS, "Aktywne biznesy", list_business, "Zadzwo�", "Anuluj");
				}
				else
				{
					cmd_call(playerid, sprintf("%d", dg_data));
				}
			}
			else if( dg_value == DG_PHONE_CONTACTS_ROW )
			{
				new Cache:tmp_cache;
				tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT contact_name, contact_number FROM `ipb_contacts` WHERE `contact_uid` = %d", dg_data));
				
				new number;

				new tmp[MAX_PLAYER_NAME+1];
				if(cache_num_rows()) 
				{
					cache_get_value_index(0, 0, tmp);
					cache_get_value_index_int(0, 1, number);
				}

				pInfo[playerid][player_dialog_tmp1] = dg_data;
				if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
				ShowPlayerDialog(playerid, DIALOG_PHONE_CONTACTS_ROW, DIALOG_STYLE_LIST, sprintf("Kontakt %s [%d]", tmp, number), "01\tZadzwon\n02\tSMS\n03\tEdytuj nazwe kontaktu\n04\tUsun kontakt", "Wybierz", "Zamknij");
			}
		}

		case DIALOG_PHONE_CALL_GROUP:
		{
			if( !response ) return 1;

			new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_PHONE);
			if( itemid == -1 ) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz w��czonego telefonu.");
			
			new gid = DynamicGui_GetValue(playerid, listitem);

			ShowPlayerDialog(playerid, DIALOG_CALL_GROUP, DIALOG_STYLE_INPUT, "Po��czenie z biznesem:", "Podaj tre�� zam�wienia:", "OK", "");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			pInfo[playerid][player_dialog_tmp1] = PlayerItem[playerid][itemid][player_item_value1];
			pInfo[playerid][player_dialog_tmp2] = gid;
		}

		case DIALOG_CALL_GROUP:
		{
			if( !response )
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				return 1;
			}

			if(strlen(inputtext) < 4)
			{
				SendGuiInformation(playerid, "Informacja", "Zbyt kr�tka tre�� zg�oszenia.");
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				return 1;
			}

			if(strlen(inputtext) > 110)
			{
				SendGuiInformation(playerid, "Informacja", "Zbyt d�uga tre�� zg�oszenia.");
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				return 1;
			}

			new number = pInfo[playerid][player_dialog_tmp1];
			new gid = pInfo[playerid][player_dialog_tmp2];

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);

			ProxMessage(playerid, inputtext, PROX_PHONE);

			foreach(new p : Player)
			{
				if(pInfo[p][player_duty_gid] == gid)
				{
					SendClientMessage(p, COLOR_GOLD, sprintf("[Zam�wienie od %d]: %s", number, inputtext));
				}
			}
		}

		case DIALOG_911:
		{
			new zgloszenie[MAX_PLAYERS];
			new number = pInfo[playerid][player_dialog_tmp1];

			if( !response )
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				return 1;
			}

			if(strlen(inputtext) < 4)
			{
				SendGuiInformation(playerid, "Informacja", "Zbyt kr�tka tre�� zg�oszenia.");
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				return 1;
			}

			if(strlen(inputtext) > 110)
			{
				SendGuiInformation(playerid, "Informacja", "Zbyt d�uga tre�� zg�oszenia.");
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				return 1;
			}

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);

			ProxMessage(playerid, inputtext, PROX_PHONE);

			foreach(new p : Player)
			{
				if(pInfo[p][player_duty_gid] != -1)
				{
					if(Group[pInfo[p][player_duty_gid]][group_flags] & GROUP_FLAG_DEP)
					{
						zgloszenie[p]=1;
					}
				}
				if(zgloszenie[p]==1)
				{
					SendFormattedClientMessage(p, COLOR_LIGHTER_RED, "[Centrala 911] Zg�oszenie od %d: %s", number, inputtext);
					zgloszenie[p]=0;
				}
			}
		}

		case DIALOG_PHONE_VCARD:
		{
			if( !response ) return 1;

			new targetid = DynamicGui_GetValue(playerid, listitem);

			if( !IsPlayerConnected(targetid) ) return 1;
			if( !pInfo[targetid][player_logged] ) return 1;

			new resp = SetOffer(playerid, targetid, OFFER_TYPE_VCARD, 0, GetPlayerUsedItem(playerid, ITEM_TYPE_PHONE));

			if( resp ) ShowPlayerOffer(targetid, playerid, "vCard", sprintf("%s [%d]", pInfo[playerid][player_name], PlayerItem[playerid][pOffer[playerid][offer_extraid]][player_item_value1]), 0);
		}

		case DIALOG_ITEMS_OFFER:
		{
			if( !response ) return 1;

			new targetid = DynamicGui_GetValue(playerid, listitem);
			new itemid = pInfo[playerid][player_dialog_tmp1];
			new price = pInfo[playerid][player_item_price];
			if(price < 0) return SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Niepoprawna cena.");
			if(pInfo[playerid][player_hours] < 1) return SendGuiInformation(playerid, "Informacja", "Oferowanie przedmiot�w zablokowane (do godziny online).");

			if( !IsPlayerConnected(targetid) ) return 1;
			if( !pInfo[targetid][player_logged] ) return 1;

			new resp = SetOffer(playerid, targetid, OFFER_TYPE_ITEM, price, itemid);

			if(PlayerItem[playerid][itemid][player_item_type] == ITEM_TYPE_WEAPON)
			{
				if( resp ) ShowPlayerOffer(targetid, playerid, "Przedmiot", sprintf("%s [%d] [Stan: %0.2f%%]", PlayerItem[playerid][pOffer[targetid][offer_extraid]][player_item_name], PlayerItem[playerid][pOffer[targetid][offer_extraid]][player_item_uid], PlayerItem[playerid][pOffer[targetid][offer_extraid]][player_item_condition]), price);	
			}
			else
			{
				if( resp ) ShowPlayerOffer(targetid, playerid, "Przedmiot", sprintf("%s [%d]", PlayerItem[playerid][pOffer[targetid][offer_extraid]][player_item_name], PlayerItem[playerid][pOffer[targetid][offer_extraid]][player_item_uid]), price);	
			}
		}

		case DIALOG_ITEMS_OFFER_PRICE:
		{
			if( !response ) return 1;
			new price = strval(inputtext);
			DynamicGui_Init(playerid);

			new string[1024], count;
			pInfo[playerid][player_item_price] = price;

			new Float:p_pos[3];
			GetPlayerPos(playerid, p_pos[0], p_pos[1], p_pos[2]);
			foreach(new p : Player)
			{
				if( !pInfo[p][player_logged] ) continue;
				if( p == playerid ) continue;
				if( pInfo[p][player_spec] != INVALID_PLAYER_ID) continue;
				if( GetPlayerDistanceFromPoint(p, p_pos[0], p_pos[1], p_pos[2]) <= 10.0 )
				{
					if( GetPlayerUsedItem(playerid, ITEM_TYPE_MASKA) > -1 ) format(string, sizeof(string), "%s##\t\t%s\n", string, pInfo[p][player_name]);
					else format(string, sizeof(string), "%s%d\t\t%s\n", string, p, pInfo[p][player_name]);

					DynamicGui_AddRow(playerid, p);
					count++;
				}
			}

			if( count == 0 ) SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Brak os�b w okolicy.");
			else ShowPlayerDialog(playerid, DIALOG_ITEMS_OFFER, DIALOG_STYLE_LIST, "Osoby w okolicy:", string, "Oferuj", "Zamknij");
		}

		case DIALOG_PHONE_CONTACTS_ROW:
		{
			if( !response )
			{
				DynamicGui_Init(playerid);
				DynamicGui_SetDialogValue(playerid, GetPlayerUsedItem(playerid, ITEM_TYPE_PHONE));

				DynamicGui_AddRow(playerid, DG_PHONE_CONTACTS);
				OnDialogResponse(playerid, DIALOG_PHONE, 1, 0, "");

				return 1;
			}

			if( listitem == 0 )
			{
				new Cache:tmp_cache;
				tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT contact_number FROM `ipb_contacts` WHERE `contact_uid` = %d", pInfo[playerid][player_dialog_tmp1]));

				new number;
				cache_get_value_index_int(0, 0, number);
				if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
				cmd_call(playerid, sprintf("%d", number));
			}
			else if( listitem == 1 )
			{
				new Cache:tmp_cache;
				tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT contact_number FROM `ipb_contacts` WHERE `contact_uid` = %d", pInfo[playerid][player_dialog_tmp1]));

				cache_get_value_index_int(0, 0, pInfo[playerid][player_dialog_tmp1]);
				ShowPlayerDialog(playerid, DIALOG_PHONE_SMS_TEXT, DIALOG_STYLE_INPUT, "Wysy�anie SMS", "Podaj tre�� SMSa:", "Wy�lij", "Zamknij");
				if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
			}
			else if( listitem == 2 )
			{
				ShowPlayerDialog(playerid, DIALOG_PHONE_CONTACTS_ROW_NAME, DIALOG_STYLE_INPUT, "Zmiana nazwy kontaktu", "Wpisz now� nazwe kontaktu (maksymalnie 24 znaki):", "Gotowe", "Zamknij");
			}
			else
			{
				mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_contacts` SET `contact_deleted` = 1 WHERE `contact_uid` = %d", pInfo[playerid][player_dialog_tmp1]));
				SendPlayerInformation(playerid, "Kontakt zostal ~r~usuniety~w~.", 5000);

				DynamicGui_Init(playerid);
				DynamicGui_SetDialogValue(playerid, GetPlayerUsedItem(playerid, ITEM_TYPE_PHONE));

				DynamicGui_AddRow(playerid, DG_PHONE_CONTACTS);
				OnDialogResponse(playerid, DIALOG_PHONE, 1, 0, "");
			}
		}

		case DIALOG_PHONE_CONTACTS_ROW_NAME:
		{
			if( !response )
			{
				DynamicGui_Init(playerid);

				DynamicGui_AddRow(playerid, DG_PHONE_CONTACTS_ROW, pInfo[playerid][player_dialog_tmp1]);
				OnDialogResponse(playerid, DIALOG_PHONE_CONTACTS, 1, 0, "");
				return 1;
			}

			if( strlen(inputtext) < 2 ) return ShowPlayerDialog(playerid, DIALOG_PHONE_CONTACTS_ROW_NAME, DIALOG_STYLE_INPUT, "Zmiana nazwy kontaktu", "Wpisz now� nazwe kontaktu (maksymalnie 24 znaki):\n\n"HEX_COLOR_LIGHTER_RED"Podana nazwa jest zbyt kr�tka.", "Gotowe", "Zamknij");
			if( strlen(inputtext) > 24 ) return ShowPlayerDialog(playerid, DIALOG_PHONE_CONTACTS_ROW_NAME, DIALOG_STYLE_INPUT, "Zmiana nazwy kontaktu", "Wpisz now� nazwe kontaktu (maksymalnie 24 znaki):\n\n"HEX_COLOR_LIGHTER_RED"Podana nazwa jest za dluga.", "Gotowe", "Zamknij");
			mysql_escape_string(inputtext, inputtext, 256);

			mysql_tquery(mySQLconnection, sprintf("UPDATE `ipb_contacts` SET `contact_name` = '%s' WHERE `contact_uid` = %d", inputtext, pInfo[playerid][player_dialog_tmp1]));
			SendPlayerInformation(playerid, "Nazwa kontaktu zostala ~y~zmieniona~w~.", 5000);

			DynamicGui_Init(playerid);

			DynamicGui_AddRow(playerid, DG_PHONE_CONTACTS_ROW, pInfo[playerid][player_dialog_tmp1]);
			OnDialogResponse(playerid, DIALOG_PHONE_CONTACTS, 1, 0, "");
		}

		case DIALOG_PHONE_ADD_CONTACT:
		{
			if( !response )	return 1;
			
			if( strlen(inputtext) < 4 ) return ShowPlayerDialog(playerid, DIALOG_PHONE_ADD_CONTACT, DIALOG_STYLE_INPUT, "Dodawanie kontaktu", "Wpisz numer telefonu, kt�ry chcesz doda� do kontakt�w:\n\n"HEX_COLOR_LIGHTER_RED"Podany numer jest zbyt kr�tki.", "Dodaj", "Zamknij");
			if( strlen(inputtext) > 7 ) return ShowPlayerDialog(playerid, DIALOG_PHONE_ADD_CONTACT, DIALOG_STYLE_INPUT, "Dodawanie kontaktu", "Wpisz numer telefonu, kt�ry chcesz doda� do kontakt�w:\n\n"HEX_COLOR_LIGHTER_RED"Podany numer jest zbyt d�ugi.", "Dodaj", "Zamknij");

			new itemid = GetPlayerUsedItem(playerid, ITEM_TYPE_PHONE);

			if(itemid == - 1) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz w��czonego telefonu.");

			mysql_escape_string(inputtext, inputtext, 256);

			mysql_tquery(mySQLconnection, sprintf("INSERT INTO `ipb_contacts` VALUES (null, %d, 'Nowy kontakt', %d, 0)", strval(inputtext), PlayerItem[playerid][itemid][player_item_uid]));

			SendPlayerInformation(playerid, "Kontakt zostal ~y~dodany~w~.", 5000);

			return 1;
		}

		case DIALOG_WORKS:
		{
			if( !response ) return 1;

			new wvalue = DynamicGui_GetValue(playerid, listitem);

			if(wvalue == WORK_TYPE_TRASHMAN)
			{
				if(!(pInfo[playerid][player_documents] & DOCUMENT_DRIVE)) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz prawa jazdy.");
			}

			pInfo[playerid][player_job] = wvalue;

			mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_job` = %d WHERE `char_uid` = %d", pInfo[playerid][player_job], pInfo[playerid][player_id]));

			SendClientMessage(playerid, COLOR_GOLD, "Praca dorywcza zosta�a wybrana, u�yj /pomoc by sprawdzi� dost�pne komendy.");
		}

		case DIALOG_DOCUMENTS:
		{
			if( !response ) return 1;

			switch( listitem )
			{
				case 0:
				{
					if(pInfo[playerid][player_documents] & DOCUMENT_ID) return SendGuiInformation(playerid, "Informacja", "Posiadasz ju� dow�d osobisty.");
					new resp = SetOffer(INVALID_PLAYER_ID, playerid, OFFER_TYPE_DOCUMENT, 50, DOCUMENT_ID);

					if( resp ) ShowPlayerOffer(playerid, INVALID_PLAYER_ID, "Dokument", "Dowod osobisty", 50);
				}

				case 1:
				{
					if(pInfo[playerid][player_documents] & DOCUMENT_DRIVE) return SendGuiInformation(playerid, "Informacja", "Posiadasz ju� prawo jazdy.");
					new resp = SetOffer(INVALID_PLAYER_ID, playerid, OFFER_TYPE_DOCUMENT, 150, DOCUMENT_DRIVE);

					if( resp ) ShowPlayerOffer(playerid, INVALID_PLAYER_ID, "Dokument", "Prawo jazdy", 150);
				}
			}
		}

		case DIALOG_PAYMENT:
		{
			if( !response ) return OnPlayerPaymentResponse(playerid, 0, 0);

			if( listitem == 1 )
			{
				new price = pOffer[playerid][offer_price];
				if( pInfo[playerid][player_bank_number] == 0 )
				{
					SendPlayerInformation(playerid, "Nie posiadasz ~r~konta~w~ w banku.", 4000);
					return ShowPlayerDialog(playerid, DIALOG_PAYMENT, DIALOG_STYLE_LIST, ""guiopis"Spos�b p�atno�ci", "Got�wka\nKarta kredytowa", "Wybierz", "Anuluj");
				}

				if( pInfo[playerid][player_bank_money] < price )
				{
					SendPlayerInformation(playerid, "Nie posiadasz wystarczajacej ilosci ~r~pieniedzy~w~ na koncie.", 4000);
					return ShowPlayerDialog(playerid, DIALOG_PAYMENT, DIALOG_STYLE_LIST, ""guiopis"Spos�b p�atno�ci", "Got�wka\nKarta kredytowa", "Wybierz", "Anuluj");
				}

				AddPlayerBankMoney(playerid, -price);

				OnPlayerPaymentResponse(playerid, 1, 1);
			}
			else
			{
				if( pInfo[playerid][player_money] < pOffer[playerid][offer_price] )
				{
					SendPlayerInformation(playerid, "Nie posiadasz wystarczajacej ilosci ~r~pieniedzy~w~ przy sobie.", 4000);
					return ShowPlayerDialog(playerid, DIALOG_PAYMENT, DIALOG_STYLE_LIST, ""guiopis"Spos�b p�atno�ci", "Got�wka\nKarta kredytowa", "Wybierz", "Anuluj");
				}

				GivePlayerMoney(playerid, -pOffer[playerid][offer_price]);

				OnPlayerPaymentResponse(playerid, 0, 1);
			}
		}

		case DIALOG_SMUGGLE_CONFIRM:
		{
			if( !response )
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
				return 1;
			}

			//stworz obiekty paczek
			//insert do shipments
			SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: �adujemy tw�j kontener, oczekuj na przyp�yni�cie statku w dokach.");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
			SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");

			//textdraw informacyjny co ma robic
		}

		case DIALOG_SMUGGLING:
		{
			if( !response )
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
				return 1;
			} 

			switch(listitem)
			{
				case 0:
				{
					new gid = pInfo[playerid][player_duty_gid];
					if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie znajdujesz si� na s�u�bie grupy przest�pczej.");
					//sprawdz czy ma strefe w ocean docks
					new Float:x, Float:y, Float:z, a_ids[10];
					GetPlayerPos(playerid, x, y, z);
					GetDynamicAreasForPoint(x, y, z, a_ids);

					if(!IsValidDynamicArea(a_ids[0]))
					{
						SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: Potrzebuje kogo� z dost�pem do Ocean Docks, tam sk�d dzwonisz czego� takiego nie ma.");
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
						SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
						return 1;
					}

					if(Area[a_ids[0]][area_owner_type] != AREA_OWNER_TYPE_GROUP || Area[a_ids[0]][area_owner] != Group[gid][group_uid] || !AreaHasFlag(a_ids[0], AREA_FLAG_OCEAN_DOCK))
					{
						SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: Potrzebuje kogo� z dost�pem do Ocean Docks, tam sk�d dzwonisz czego� takiego nie ma lub nie nale�y do ciebie.");
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
						SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
						return 1;
					}

					ProxMessage(playerid, "Potrzebuje za�adowa� co� do kontener�w.", PROX_PHONE);
					SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: Przesy�am ci nazwe statku, kt�ry najszybciej wyp�ynie.");

					//sprawdz ktory statek jest na morzu
					GetDynamicObjectPos(liberty_ship, x, y, z);
					if(x == 2647.89 && y == -2278.95 && z == 18.34)
					{
						//liberty jest w porcie, asia na morzu
						ShowPlayerDialog(playerid, DIALOG_SMUGGLE_CONFIRM, DIALOG_STYLE_MSGBOX, "Potwierdzenie przemytu", "Statek Hanjin Lines jest gotowy do za�adunku.\nKoszt kontenera: $45000\n\nCzy chcesz rozpocz�� przemyt?", "Potwierd�", "Anuluj");
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_SMUGGLE_CONFIRM, DIALOG_STYLE_MSGBOX, "Potwierdzenie przemytu", "Statek Libertine Chartered Lines jest gotowy do za�adunku.\nKoszt kontenera: $48000\n\nCzy chcesz rozpocz�� przemyt?", "Potwierd�", "Anuluj");
					}
				}
				case 1:
				{
					//motoruwa
					new gid = pInfo[playerid][player_duty_gid];
					if(gid != -1)
					{
						if(pInfo[playerid][player_money] < 6000) return SendGuiInformation(playerid, "Informacja", "Koszt przemytu to $6000, nie posiadasz przy sobie takiej got�wki.");

						new Float:x, Float:y, Float:z, a_ids[10];
						GetPlayerPos(playerid, x, y, z);
						GetDynamicAreasForPoint(x, y, z, a_ids);

						if(!IsValidDynamicArea(a_ids[0]))
						{
							SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: Potrzebuje kogo� z dost�pem do doku lub molo, tam sk�d dzwonisz czego� takiego nie ma.");
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
							SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
							return 1;
						}

						if(Area[a_ids[0]][area_owner_type] != AREA_OWNER_TYPE_GROUP || Area[a_ids[0]][area_owner] != Group[gid][group_uid] || !AreaHasFlag(a_ids[0], AREA_FLAG_DOCK))
						{
							SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: Potrzebuje kogo� z dost�pem do doku lub molo, tam sk�d dzwonisz czego� takiego nie ma lub nie nale�y do ciebie.");
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
							SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
							return 1;
						}

						if(drop != -1) return SendGuiInformation(playerid, "Informacja", "Kto� u�ywa przemytu w tym momencie, poczekaj a� sko�czy.");

						Group[gid][group_last_smuggle] = gettime();
						mysql_tquery(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_last_smuggle = %d WHERE group_uid = %d", gettime(), Group[gid][group_uid]));

						GivePlayerMoney(playerid, -6000);

						drop = pInfo[playerid][player_id];
						new air_id = random(6);
						pInfo[playerid][player_smuggle_cp] = CreateDynamicCP(AirDropPoints[air_id][airX], AirDropPoints[air_id][airY], AirDropPoints[air_id][airZ], 10.0, 0, .playerid = playerid, .streamdistance = 5000);

						//TogglePlayerDynamicCP(playerid, pInfo[playerid][player_smuggle_cp], 1);

						TextDrawSetString(Tutorial[playerid], "Udaj sie do checkpointu oznaczonego na mapie aby odebrac przesylke.~n~Pamietaj by uzyc do tego ~y~lodzi~w~.");
						TextDrawShowForPlayer(playerid, Tutorial[playerid]);

						SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: Przesy�am Ci wsp�rz�dne zrzutu.");
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
						SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
					}
				}	
			}
		}

		case DIALOG_HURTOWNIA_ILLEGAL:
		{
			if( !response )
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
				return 1;
			} 

			switch(listitem)
			{
				case 0:
				{
					ProxMessage(playerid, "Co powiesz na Market?", PROX_PHONE);
					SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: B�de czeka� przy nowym Verona Mall, zau�ek - przyjed� w ci�gu 15 minut.");
					SetDynamicActorPos(ArmDealer, 1081.0221,-1667.5089,13.6265);
					SetDynamicActorFacingAngle(ArmDealer, 301.9660);
					SetDynamicActorVirtualWorld(ArmDealer, 0);

					foreach(new a: Areas)
					{
						if(Area[a][area_type] == AREA_TYPE_ARMDEALER)
						{
							DestroyDynamicArea(a);
							for(new z=0; e_areas:z != e_areas; z++)
						    {
								Area[a][e_areas:z] = 0;
						    }
						}
					}

					new a_id = CreateDynamicCircle(1081.0221,-1667.5089, 2.0, 0, 0);
					Area[a_id][area_type] = AREA_TYPE_ARMDEALER;
					Iter_Add(Areas, a_id);

					new vid = LoadVehicle("WHERE `vehicle_uid` = 265", true);

					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
					SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
					defer HideActor[540000](ArmDealer, vid);
				}
				case 1:
				{
					ProxMessage(playerid, "Co powiesz na Rodeo?", PROX_PHONE);
					SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: B�de czeka� w zau�ku przy W.Broadway. Przyjed� w ci�gu 15 minut.");
					SetDynamicActorPos(ArmDealer, 417.2747,-1301.9274,15.0030);
					SetDynamicActorFacingAngle(ArmDealer, 62.54);
					SetDynamicActorVirtualWorld(ArmDealer, 0);

					foreach(new a: Areas)
					{
						if(Area[a][area_type] == AREA_TYPE_ARMDEALER)
						{
							DestroyDynamicArea(a);
							for(new z=0; e_areas:z != e_areas; z++)
						    {
								Area[a][e_areas:z] = 0;
						    }
						}
					}

					new a_id = CreateDynamicCircle(417.2747,-1301.9274, 2.0, 0, 0);
					Area[a_id][area_type] = AREA_TYPE_ARMDEALER;
					Iter_Add(Areas, a_id);

					new vid = LoadVehicle("WHERE `vehicle_uid` = 265", true);

					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
					SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
					defer HideActor[540000](ArmDealer, vid);
				}	
				case 2:
				{
					ProxMessage(playerid, "Co powiesz na Willowfield?", PROX_PHONE);
					SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: B�de czeka� w zau�ku przy mo�cie i Cluckin Bell. Przyjed� w ci�gu 15 minut.");

					SetDynamicActorPos(ArmDealer, 2460.1780,-1901.0322,13.5469);
					SetDynamicActorFacingAngle(ArmDealer, 19.0);
					SetDynamicActorVirtualWorld(ArmDealer, 0);

					foreach(new a: Areas)
					{
						if(Area[a][area_type] == AREA_TYPE_ARMDEALER)
						{
							DestroyDynamicArea(a);
							for(new z=0; e_areas:z != e_areas; z++)
						    {
								Area[a][e_areas:z] = 0;
						    }
						}
					}

					new a_id = CreateDynamicCircle(2460.1780,-1901.0322, 2.0, 0, 0);
					Area[a_id][area_type] = AREA_TYPE_ARMDEALER;
					Iter_Add(Areas, a_id);

					new vid = LoadVehicle("WHERE `vehicle_uid` = 267", true);

					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
					SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
					defer HideActor[540000](ArmDealer, vid);
				}
				case 3:
				{
					ProxMessage(playerid, "Co powiesz na East Los Santos?", PROX_PHONE);
					SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: B�de czeka� na parkingu podziemnym. Przyjed� w ci�gu 15 minut.");
					SetDynamicActorPos(ArmDealer, 2350.1462,-1237.8739,22.5000);
					SetDynamicActorFacingAngle(ArmDealer, 85.0);
					SetDynamicActorVirtualWorld(ArmDealer, 0);

					foreach(new a: Areas)
					{
						if(Area[a][area_type] == AREA_TYPE_ARMDEALER)
						{
							DestroyDynamicArea(a);
							for(new z=0; e_areas:z != e_areas; z++)
						    {
								Area[a][e_areas:z] = 0;
						    }
						}
					}

					new a_id = CreateDynamicCircle(2350.1462,-1237.8739, 2.0, 0, 0);
					Area[a_id][area_type] = AREA_TYPE_ARMDEALER;
					Iter_Add(Areas, a_id);

					new vid = LoadVehicle("WHERE `vehicle_uid` = 268", true);

					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
					SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
					defer HideActor[540000](ArmDealer, vid);
				}
				case 4:
				{
					ProxMessage(playerid, "Co powiesz na Ocean Docks?", PROX_PHONE);
					SendClientMessage(playerid, COLOR_YELLOW, "[Telefon]: B�de czeka� na terenie zak�ad�w od strony Willowfield. Przyjed� w ci�gu 15 minut.");
					SetDynamicActorPos(ArmDealer, 2526.9031,-2121.0110,13.5538);
					SetDynamicActorFacingAngle(ArmDealer, 227.0870);
					SetDynamicActorVirtualWorld(ArmDealer, 0);

					foreach(new a: Areas)
					{
						if(Area[a][area_type] == AREA_TYPE_ARMDEALER)
						{
							DestroyDynamicArea(a);
							for(new z=0; e_areas:z != e_areas; z++)
						    {
								Area[a][e_areas:z] = 0;
						    }
						}
					}

					new a_id = CreateDynamicCircle(2526.9031,-2121.0110, 2.0, 0, 0);
					Area[a_id][area_type] = AREA_TYPE_ARMDEALER;
					Iter_Add(Areas, a_id);

					new vid = LoadVehicle("WHERE `vehicle_uid` = 266", true);

					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
					SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zako�czona.");
					defer HideActor[540000](ArmDealer, vid);
				}
			}

			bot_taken = gettime() + 900;
		}

		case DIALOG_HURTOWNIA_LEGAL:
		{
			if( !response )
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
				return 1;
			}

			new gid = pInfo[playerid][player_duty_gid];
			if(gid == -1) return SendGuiInformation(playerid, "Informacja", "Nie jeste� na s�u�bie grupy.");

			switch(listitem)
			{
				case 0: // Gastronomia
                {
                    if(IsPlayerInAnyGroup(playerid))
                    {
                        if(Group[gid][group_type] == GROUP_TYPE_GASTRO)
                        {
                            new string[1224], count;
                            DynamicGui_Init(playerid);

                            format(string, sizeof(string), "%sProdukt\tCena\n", string);

                            foreach (new prod: Products)
                            {
                                if( Product[prod][product_owner] == PRODUCT_OWNER_GASTRONOMY )
                                {
	                                format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }

	                            if( Product[prod][product_group] == Group[gid][group_uid])
	                            {
	                            	format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }
                            }

                            if( count == 0 ) 
                            {
                            	SendGuiInformation(playerid, "Informacja", "Ten typ grupy nie posiada produkt�w dodanych do hurtowni. Powiadom administracje.");
                            	RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                            }
                            else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADDPROD, DIALOG_STYLE_TABLIST_HEADERS, "Hurtownia gastronomiczna", string, "Kup", "Wyjd�");
                        }
                        else
                        {
                            SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Obecnie nie znajdujesz si� na s�u�bie grupy, kt�ra ma dost�p do tej kategorii\nWejd� na duty owej grupy i spr�buj ponownie!");
                            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                        }

                    }
                    else
                    {
                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie przynale�ysz do �adnej grupy.");
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                    }
                }
				case 1: // Warsztat
                {
                    if(IsPlayerInAnyGroup(playerid))
                    {
                        if(Group[gid][group_type] == GROUP_TYPE_WORKSHOP)
                        {
                            new string[1024], count;
                            DynamicGui_Init(playerid);

                            format(string, sizeof(string), "%sProdukt\tCena\n", string);

                            foreach (new prod: Products)
                            {
                                if( Product[prod][product_owner] == PRODUCT_OWNER_WORKSHOP )
                                {
	                                format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }

	                            if( Product[prod][product_group] == Group[gid][group_uid])
	                            {
	                            	format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }
                            }

                            if( count == 0 ) 
                            {
                            	SendGuiInformation(playerid, "Informacja", "Ten typ grupy nie posiada produkt�w dodanych do hurtowni. Powiadom administracje.");
                            	RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                            }
                            else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADDPROD, DIALOG_STYLE_TABLIST_HEADERS, "Hurtownia warsztatu", string, "Kup", "Wyjd�");
                        }
                        else
                        {
                            SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Obecnie nie znajdujesz si� na s�u�bie grupy, kt�ra ma dost�p do tej kategorii\nWejd� na duty owej grupy i spr�buj ponownie!");
                            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                        }

                    }
                    else
                    {
                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie przynale�ysz do �adnej grupy.");
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                    }
                }

				case 2: // Porzadkowe
                {
                    if(IsPlayerInAnyGroup(playerid))
                    {
                        if(Group[gid][group_type] == GROUP_TYPE_LSPD)
                        {
                            new string[1024], count;
                            DynamicGui_Init(playerid);

                            format(string, sizeof(string), "%sProdukt\tCena\n", string);

                            foreach (new prod: Products)
                            {
                                if( Product[prod][product_owner] == PRODUCT_OWNER_LSPD )
                                {
	                                format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }

	                            if( Product[prod][product_group] == Group[gid][group_uid])
	                            {
	                            	format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }
                            }

                            if( count == 0 ) 
                            {
                            	SendGuiInformation(playerid, "Informacja", "Ten typ grupy nie posiada produkt�w dodanych do hurtowni. Powiadom administracje.");
                            	RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                            }
                            else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADDPROD, DIALOG_STYLE_TABLIST_HEADERS, "Hurtownia LSPD", string, "Kup", "Wyjd�");
                        }
                        else
                        {
                            SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Obecnie nie znajdujesz si� na s�u�bie grupy, kt�ra ma dost�p do tej kategorii\nWejd� na duty owej grupy i spr�buj ponownie!");
                            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                        }

                    }
                    else
                    {
                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie przynale�ysz do �adnej grupy.");
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                    }
                }
                case 3: // Weazel
                {
                    if(IsPlayerInAnyGroup(playerid))
                    {
                        if(Group[gid][group_type] == GROUP_TYPE_SN)
                        {
                            new string[1024], count;
                            DynamicGui_Init(playerid);

                            format(string, sizeof(string), "%sProdukt\tCena\n", string);

                            foreach (new prod: Products)
                            {
                                if( Product[prod][product_owner] == PRODUCT_OWNER_SNEWS )
                                {
	                                format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }

	                            if( Product[prod][product_group] == Group[gid][group_uid])
	                            {
	                            	format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }
                            }

                            if( count == 0 ) 
                            {
                            	SendGuiInformation(playerid, "Informacja", "Ten typ grupy nie posiada produkt�w dodanych do hurtowni. Powiadom administracje.");
                            	RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                            }
                            else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADDPROD, DIALOG_STYLE_TABLIST_HEADERS, "Hurtownia Weazel", string, "Kup", "Wyjd�");
                        }
                        else
                        {
                            SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Obecnie nie znajdujesz si� na s�u�bie grupy, kt�ra ma dost�p do tej kategorii\nWejd� na duty owej grupy i spr�buj ponownie!");
                            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                        }

                    }
                    else
                    {
                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie przynale�ysz do �adnej grupy.");
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                    }
                }
                case 4: // Ochrona
                {
                    if(IsPlayerInAnyGroup(playerid))
                    {
                        if(Group[gid][group_type] == GROUP_TYPE_SECURITY)
                        {
                            new string[1024], count;
                            DynamicGui_Init(playerid);

                            format(string, sizeof(string), "%sProdukt\tCena\n", string);

                            foreach (new prod: Products)
                            {
                                if( Product[prod][product_owner] == PRODUCT_OWNER_SECURITY )
                                {
	                                format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }

	                            if( Product[prod][product_group] == Group[gid][group_uid])
	                            {
	                            	format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }
                            }

                            if( count == 0 ) 
                            {
                            	SendGuiInformation(playerid, "Informacja", "Ten typ grupy nie posiada produkt�w dodanych do hurtowni. Powiadom administracje.");
                            	RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                            }
                            else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADDPROD, DIALOG_STYLE_TABLIST_HEADERS, "Hurtownia ochroniarska", string, "Kup", "Wyjd�");
                        }
                        else
                        {
                            SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Obecnie nie znajdujesz si� na s�u�bie grupy, kt�ra ma dost�p do tej kategorii\nWejd� na duty owej grupy i spr�buj ponownie!");
                            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                        }

                    }
                    else
                    {
                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie przynale�ysz do �adnej grupy.");
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                    }
                }
                case 5: // Silownia
                {
                    if(IsPlayerInAnyGroup(playerid))
                    {
                        if(Group[gid][group_type] == GROUP_TYPE_GYM)
                        {
                            new string[1024], count;
                            DynamicGui_Init(playerid);

                            format(string, sizeof(string), "%sProdukt\tCena\n", string);

                            foreach (new prod: Products)
                            {
                                if( Product[prod][product_owner] == PRODUCT_OWNER_GYM )
                                {
	                                format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }

	                            if( Product[prod][product_group] == Group[gid][group_uid])
	                            {
	                            	format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }
                            }

                            if( count == 0 ) 
                            {
                            	SendGuiInformation(playerid, "Informacja", "Ten typ grupy nie posiada produkt�w dodanych do hurtowni. Powiadom administracje.");
                            	RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                            }
                            else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADDPROD, DIALOG_STYLE_TABLIST_HEADERS, "Hurtownia si�ownii", string, "Kup", "Wyjd�");
                        }
                        else
                        {
                            SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Obecnie nie znajdujesz si� na s�u�bie grupy, kt�ra ma dost�p do tej kategorii\nWejd� na duty owej grupy i spr�buj ponownie!");
                            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                        }

                    }
                    else
                    {
                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie przynale�ysz do �adnej grupy.");
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                    }
                }
                case 6: // Przest�pcze
                {
                    if(IsPlayerInAnyGroup(playerid))
                    {
                        if(Group[gid][group_type] == GROUP_TYPE_GANG)
                        {
                            new string[1024], count;
                            DynamicGui_Init(playerid);

                            format(string, sizeof(string), "%sProdukt\tCena\n", string);

                            foreach (new prod: Products)
                            {
                                if( Product[prod][product_owner] != PRODUCT_OWNER_CRIME ) continue;

                                format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
                                count++;
                            }

                            if( count == 0 ) 
                            {
                            	SendGuiInformation(playerid, "Informacja", "Ten typ grupy nie posiada produkt�w dodanych do hurtowni. Powiadom administracje.");
                            	RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                            }
                            else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADDPROD, DIALOG_STYLE_TABLIST_HEADERS, "Hurtownia przest�pczych", string, "Kup", "Wyjd�");
                        }
                        else
                        {
                            SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Obecnie nie znajdujesz si� na s�u�bie grupy, kt�ra ma dost�p do tej kategorii\nWejd� na duty owej grupy i spr�buj ponownie!");
                            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                        }

                    }
                    else
                    {
                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie przynale�ysz do �adnej grupy.");
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                    }
                }
                case 7: // ERU
                {
                    if(IsPlayerInAnyGroup(playerid))
                    {
                        if(Group[gid][group_type] == GROUP_TYPE_MEDIC)
                        {
                            new string[1024], count;
                            DynamicGui_Init(playerid);

                            format(string, sizeof(string), "%sProdukt\tCena\n", string);

                            foreach (new prod: Products)
                            {
                                if( Product[prod][product_owner] == PRODUCT_OWNER_ERU )
                                {
	                                format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }

	                            if( Product[prod][product_group] == Group[gid][group_uid])
	                            {
	                            	format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }
                            }

                            if( count == 0 ) 
                            {
                            	SendGuiInformation(playerid, "Informacja", "Ten typ grupy nie posiada produkt�w dodanych do hurtowni. Powiadom administracje.");
                            	RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                            }
                            else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADDPROD, DIALOG_STYLE_TABLIST_HEADERS, "Hurtownia si�ownii", string, "Kup", "Wyjd�");
                        }
                        else
                        {
                            SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Obecnie nie znajdujesz si� na s�u�bie grupy, kt�ra ma dost�p do tej kategorii\nWejd� na duty owej grupy i spr�buj ponownie!");
                            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                        }

                    }
                    else
                    {
                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie przynale�ysz do �adnej grupy.");
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                    }
                }	
                case 8: // Nieokre�lone
                {
                    if(IsPlayerInAnyGroup(playerid))
                    {
                        if(Group[gid][group_type] == GROUP_TYPE_NONE)
                        {
                            new string[1024], count;
                            DynamicGui_Init(playerid);

                            format(string, sizeof(string), "%sProdukt\tCena\n", string);

                            foreach (new prod: Products)
                            {
	                            if( Product[prod][product_group] == Group[gid][group_uid])
	                            {
	                            	format(string, sizeof(string), "%s %s\t$%d \n", string, Product[prod][product_name], Product[prod][product_price]);
	                                DynamicGui_AddRow(playerid, DG_PRODS_ITEM_ROW, prod);
	                                count++;
	                            }
                            }

                            if( count == 0 ) 
                            {
                            	SendGuiInformation(playerid, "Informacja", "Ten typ grupy nie posiada produkt�w dodanych do hurtowni. Powiadom administracje.");
                            	RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                            }
                            else ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADDPROD, DIALOG_STYLE_TABLIST_HEADERS, "Hurtownia - nieokre�lone", string, "Kup", "Wyjd�");
                        }
                        else
                        {
                            SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Obecnie nie znajdujesz si� na s�u�bie grupy, kt�ra ma dost�p do tej kategorii\nWejd� na duty owej grupy i spr�buj ponownie!");
                            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                        }

                    }
                    else
                    {
                        SendGuiInformation(playerid, ""guiopis"Powiadomienie", "Nie przynale�ysz do �adnej grupy.");
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                    }
                }							
			}
		}

		case DIALOG_HURTOWNIA_ADD:
        {
            new dg_value = DynamicGui_GetValue(playerid, listitem), dg_data = DynamicGui_GetDataInt(playerid, listitem);
            if( !response ) return 1;

            if( response && dg_value == DG_PRODS_ITEM_ROW )
            {
                new prod_id = dg_data;
                new prod_name[40];
                format(prod_name, sizeof(prod_name), "%s", Product[prod_id][product_name]);

                if(pInfo[playerid][player_money] < Product[prod_id][product_price]) return SendGuiInformation(playerid, "Informacja", "Nie posiadasz tyle got�wki przy sobie.");

                GivePlayerMoney(playerid,-Product[prod_id][product_price]);
                new iid = Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, Product[prod_id][product_type], Product[prod_id][product_model], Product[prod_id][product_value1], Product[prod_id][product_value2], prod_name);
                if(Product[prod_id][product_extra] > 0)
                {
	                PlayerItem[playerid][iid][player_item_extraid] = Product[prod_id][product_extra];
	                mysql_query(mySQLconnection, sprintf("UPDATE ipb_items SET item_extraid = %d WHERE item_uid =%d", PlayerItem[playerid][iid][player_item_extraid], PlayerItem[playerid][iid][player_item_uid]));
	            }
                SendGuiInformation(playerid, "Informacja", "Produkt zosta� dodany do ekwipunku.");
            }
        }

        case DIALOG_HURTOWNIA_ADDPROD_COUNT:
        {
            if( !response )
            {
            	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
            	return 1;
            }

            new dg_value = pInfo[playerid][player_dialog_tmp1];
            new dg_data = pInfo[playerid][player_dialog_tmp2];

            if( response && dg_value == DG_PRODS_ITEM_ROW )
            {
                new count = strval(inputtext);
            	new prod_id = dg_data;
                
                new gid = pInfo[playerid][player_duty_gid];
                if(gid == -1 )
                {
                	SendGuiInformation(playerid, "Informacja", "B��d, niepoprawne ID s�u�by grupy.");
                	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
					return 1;
				}

                if(Group[gid][group_capital] < Product[prod_id][product_price]*count)
                {
                	SendGuiInformation(playerid, "Informacja", "Nie posiadasz tyle got�wki w kapitale grupy.");
                	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
                	return 1;
                }

                GiveGroupCapital(gid, -Product[prod_id][product_price]*count);
               	
               	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
               	RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
               	defer DeliverProduct[540000](gid, prod_id, count);
                SendGuiInformation(playerid, "Informacja", "Produkt zosta� zam�wiony, w ci�gu 10 minut zostanie dostarczony do magazynu grupy.");
            }
        }

        case DIALOG_ROULETTE_WAGER:
        {
        	if( response )
            {
            	new wager;
				if( sscanf(inputtext, "d", wager) ) return ShowPlayerDialog(playerid, DIALOG_ROULETTE_WAGER, DIALOG_STYLE_INPUT, "Ruletka", "Podaj ilo�� got�wki jak� chcesz obstawi� na te pole.", "Kr��", "Anuluj");
				if( wager <= 0 ) return ShowPlayerDialog(playerid, DIALOG_ROULETTE_WAGER, DIALOG_STYLE_INPUT, "Ruletka", "Podaj ilo�� got�wki jak� chcesz obstawi� na te pole.", "Kr��", "Anuluj");
				if(pInfo[playerid][player_money] < wager)
				{
					SendGuiInformation(playerid, "Informacja", "Nie posiadasz wystarczaj�cej ilo�ci got�wki.");
					/*pInfo[playerid][player_roulette_object] = INVALID_STREAMER_ID;
					pInfo[playerid][player_roulette_field] = 0;
					TogglePlayerControllable(playerid, true);
					SetCameraBehindPlayer(playerid);
					TextDrawHideForPlayer(playerid, Tutorial[playerid]);
					if(IsValidDynamicObject(pInfo[playerid][player_roulette_selector])) DestroyDynamicObject(pInfo[playerid][player_roulette_selector]);
					pInfo[playerid][player_roulette_selector] = INVALID_STREAMER_ID;*/
					return 1;
				}

				new d_owner = pInfo[playerid][player_roulette_owner];
				if(Group[d_owner][group_capital] < wager*36)
				{
					SendGuiInformation(playerid, "Informacja", "Tego kasyna nie sta� na tak� stawk�.");
					return 1;
				}

				GivePlayerMoney(playerid, -wager);
				GiveGroupMoney(d_owner, wager);
				new Float:x, Float:y, Float:z;
				GetDynamicObjectPos(pInfo[playerid][player_roulette_object], x, y, z);

				PlayerPlaySound(playerid, 33400, x, y, z);

				pInfo[playerid][player_roulette_bet] = wager;
				pInfo[playerid][player_roulette_timer] = 4;

				new choosen_field = pInfo[playerid][player_roulette_field];

				TextDrawSetString(Tutorial[playerid], sprintf("Losowanie liczby:~n~~n~~n~~n~~n~~n~Mozliwa wygrana: ~g~~h~$%d~n~~w~Stawka: ~y~$%d", pInfo[playerid][player_roulette_bet]*RouletteField[choosen_field][field_multiplier] ,pInfo[playerid][player_roulette_bet]));
				TextDrawShowForPlayer(playerid, Tutorial[playerid]);

				TextDrawShowForPlayer(playerid, RouletteGreen);
				PlayerTextDrawSetString(playerid, RouletteNumber[playerid], "?");
				PlayerTextDrawShow(playerid, RouletteNumber[playerid]);
            }
            else
            {
            	pInfo[playerid][player_roulette_object] = INVALID_STREAMER_ID;
				pInfo[playerid][player_roulette_field] = 0;
				TogglePlayerControllable(playerid, true);
				SetCameraBehindPlayer(playerid);
				TextDrawHideForPlayer(playerid, Tutorial[playerid]);
				pInfo[playerid][player_roulette_selector] = INVALID_STREAMER_ID;
            }
        }

        case DIALOG_HURTOWNIA_ADDPROD:
        {
            new dg_value = DynamicGui_GetValue(playerid, listitem), dg_data = DynamicGui_GetDataInt(playerid, listitem);
            if( !response )
            {
            	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
            	return 1;
            }

            pInfo[playerid][player_dialog_tmp1] = dg_value;
            pInfo[playerid][player_dialog_tmp2] = dg_data;
            
            ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ADDPROD_COUNT, DIALOG_STYLE_INPUT, "Hurtownia", "Podaj ilo�� sztuk zamawianego produktu:", "Zam�w", "Wyjd�");
        }

        case DIALOG_HURTOWNIA_ILLEGAL_ADD:
        {
            new dg_value = DynamicGui_GetValue(playerid, listitem), dg_data = DynamicGui_GetDataInt(playerid, listitem);
            if( !response )
            {
            	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
            	return 1;
            }

            pInfo[playerid][player_dialog_tmp1] = dg_value;
            pInfo[playerid][player_dialog_tmp2] = dg_data;

            ShowPlayerDialog(playerid, DIALOG_HURTOWNIA_ILLEGAL_COUNT, DIALOG_STYLE_INPUT, "Marcus Bradford - oferta", "Podaj ilo�� sztuk odbieranego produktu:", "Kup", "Wyjd�");
        }

        case DIALOG_HURTOWNIA_ILLEGAL_COUNT:
        {
            if( !response )
            {
            	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
            	return 1;
            }
            new dg_value = pInfo[playerid][player_dialog_tmp1];
            new dg_data = pInfo[playerid][player_dialog_tmp2];

            if( dg_value == DG_PRODS_ITEM_ROW )
            {
            	new count = strval(inputtext);
            	new prod_id = dg_data;

        	 	if(count <= 0) return SendGuiInformation(playerid, "Informacja", "Nieprawid�owa ilo�� wybranego produktu.");

        	 	if(pInfo[playerid][player_money] < Product[prod_id][product_price] * count)
        	 	{
        	 		SendGuiInformation(playerid, "Informacja", "Nie posiadasz tyle got�wki przy sobie.");
	            	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
	            	return 1;
        	 	}

        	 	if(Product[prod_id][product_limit_used] == Product[prod_id][product_limit])
        	 	{
        	 		SendGuiInformation(playerid, "Informacja", "Tygodniowy limit zosta� osi�gni�ty.");
        	 		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
	            	return 1;
	            }

        	 	if(count + Product[prod_id][product_limit_used] > Product[prod_id][product_limit])
        	 	{
        	 		SendGuiInformation(playerid, "Informacja", "Ta ilo�� przekracza wasz tygodniowy limit.");
        	 		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid, pInfo[playerid][player_phone_object_index]);
	            	return 1;
	            }

        	 	new prod_name[40];
            	format(prod_name, sizeof(prod_name), "%s", Product[prod_id][product_name]);

            	GivePlayerMoney(playerid, -Product[prod_id][product_price]*count);

            	if(Product[prod_id][product_type] == ITEM_TYPE_DRUG)
            	{
            		Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, Product[prod_id][product_type], Product[prod_id][product_model], Product[prod_id][product_value1], count, prod_name);
            	}
            	else
            	{
	            	for(new c;c<count;c++)
	            	{
	        			Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, Product[prod_id][product_type], Product[prod_id][product_model], Product[prod_id][product_value1], Product[prod_id][product_value2], prod_name);
	            	}
	            }
	            
            	Product[prod_id][product_limit_used] += count;
            	mysql_query(mySQLconnection, sprintf("UPDATE ipb_products SET product_limit_used = %d WHERE product_uid = %d", Product[prod_id][product_limit_used], Product[prod_id][product_id]));
            	SendGuiInformation(playerid, "Informacja", "Transakcja zosta�a przeprowadzona pomy�lnie.");
            }
        }
		
      	case DIALOG_CD_LINK:
        {
            if( !response ) return 1;

            new link[256], query[400];
            strmid(link, inputtext, 0, 256);
            
            new itemid = DynamicGui_GetDialogValue(playerid);

            new cdid = Item_Create(ITEM_OWNER_TYPE_PLAYER, playerid, ITEM_TYPE_PLATE, 1962, 0, 0, "Plyta audio CD");
            mysql_format(mySQLconnection, query, sizeof(query), "INSERT INTO ipb_cds (`cd_uid`,`cd_link`,`cd_item`) VALUES (null, '%e', %d)", link, PlayerItem[playerid][cdid][player_item_uid]);

            mysql_query(mySQLconnection, query);
            new val1 = cache_insert_id();

            mysql_query(mySQLconnection, sprintf("UPDATE ipb_items SET item_value1 = %d  WHERE item_uid = %d", val1, PlayerItem[playerid][cdid][player_item_uid]));
            PlayerItem[playerid][cdid][player_item_value1] = val1;

            SendGuiInformation(playerid, "Informacja", "Pomy�lnie utworzono p�yte audio.");
            DeleteItem(itemid, true, playerid);
        }
	}
	return 1;
}
