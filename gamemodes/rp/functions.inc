stock LoadConfiguration()
{
	Code_ExTimer_Begin(LoadConfiguration);
	
	if( !dini_Exists(CONFIG_FILEPATH) ) 
	{
		dini_Create(CONFIG_FILEPATH);
		
		dini_Set(CONFIG_FILEPATH, "mysql_hostname", "127.0.0.1");
		dini_Set(CONFIG_FILEPATH, "mysql_username", "admin");
		dini_Set(CONFIG_FILEPATH, "mysql_password", "password");
		dini_Set(CONFIG_FILEPATH, "mysql_database", "database");
	}
	
	dini_Get(CONFIG_FILEPATH, "mysql_hostname", Setting[setting_mysql_hostname]);
	dini_Get(CONFIG_FILEPATH, "mysql_username", Setting[setting_mysql_username]);
	dini_Get(CONFIG_FILEPATH, "mysql_password", Setting[setting_mysql_password]);
	dini_Get(CONFIG_FILEPATH, "mysql_database", Setting[setting_mysql_database]);

	for(new i;i<MAX_PLAYERS;i++)
    {
        pInfo[i][player_label] = Create3DTextLabel("", 0xFFFFFF60, 0.0, 0.0, 0.0, 12.0, 0, 1);
        pInfo[i][player_description_label] = Create3DTextLabel("", LABEL_DESCRIPTION, 0.0, 0.0, 0.0, 4.0, 0, 1);
    }

    FerrisWheelObjects[10]=CreateObject(18877,389.7734,-2028.4688,22,0,0,90,300);
	FerrisWheelObjects[11]=CreateObject(18878,389.7734,-2028.4688,22,0,0,90,300);
	forEx((sizeof FerrisWheelObjects)-2,x)
	{
		FerrisWheelObjects[x] = CreateObject(18879,389.7734,-2028.4688,22,0,0,90,300);
		AttachObjectToObject(FerrisWheelObjects[x], FerrisWheelObjects[10], gFerrisCageOffsets[x][0], gFerrisCageOffsets[x][1], gFerrisCageOffsets[x][2], 0.0, 0.0, 90, 0);
	}
	
	SetTimer("RotateFerrisWheel", 3000,false);

	new mm[3], str2[64];
	getdate(mm[0], mm[1], mm[2]);
	format(str2, sizeof(str2), "~y~san~w~-andreas.pl~n~%02d.%02d.2019", mm[2], mm[1]);
	TextDrawSetString(Textdraw2, str2);

    job_pickup = CreateDynamicPickup(1210, 2, 1495.9677,-1749.3802,15.4453);
    Pickup[job_pickup][pickup_type] = PICKUP_TYPE_JOB;
	
	gov_pickup = CreateDynamicPickup(1210, 2, 1473.3110,-1766.3378,33.4356, 13);
    Pickup[gov_pickup][pickup_type] = PICKUP_TYPE_GOV;	

	SetGameModeText("SA:RP 1.1");
	
	printf("Wczytano konfiguracje MySQL [czas: %d ms]", Code_ExTimer_End(LoadConfiguration));
}

new LogPrintfStr[200];
#define logprintf(%0,%1,%2) \
						format(LogPrintfStr, 200, %1, %2); \
						_logprintf(%0, LogPrintfStr)

stock _logprintf(const file_name[], const string[])
{
	new File:log = fopen(file_name, io_append);
    if(log)
    {
		new date_time[60], Year, Month, Day, Hour, Minute, Second;
		gettime(Hour, Minute, Second);
		getdate(Year, Month, Day);	
		format(date_time, sizeof(date_time), "[%02d.%02d.%02d, %02d:%02d:%02d] ", Day, Month, Year, Hour, Minute, Second);
		
		fwrite(log, date_time);
        fwrite(log, string);
		fwrite(log, "\r\n");
        fclose(log);
    }
}

stock LoadAnims()
{
	Code_ExTimer_Begin(LoadAnims);
	new rows, Cache:tmp_cache, anim_id;
	tmp_cache = mysql_query(mySQLconnection, "SELECT * FROM `ipb_anim` ORDER BY `anim_command` ASC");
	cache_get_row_count(rows);

	for(new row = 0; row != rows; row++)
	{
		anim_id = Iter_Free(Anims);

		cache_get_value_index_int(row, 0, AnimInfo[anim_id][aUID]);
		cache_get_value_index(row, 1, AnimInfo[anim_id][aCommand], 32);
		cache_get_value_index(row, 2, AnimInfo[anim_id][aLib], 32);
		cache_get_value_index(row, 3, AnimInfo[anim_id][aName], 32);
		cache_get_value_index_float(row, 4, AnimInfo[anim_id][aSpeed]);
		cache_get_value_index_int(row, 5, AnimInfo[anim_id][aOpt1]);
		cache_get_value_index_int(row, 6, AnimInfo[anim_id][aOpt2]);
		cache_get_value_index_int(row, 7, AnimInfo[anim_id][aOpt3]);
		cache_get_value_index_int(row, 8, AnimInfo[anim_id][aOpt4]);
		cache_get_value_index_int(row, 9, AnimInfo[anim_id][aOpt5]);
		cache_get_value_index_int(row, 10, AnimInfo[anim_id][aAction]);

		Iter_Add(Anims, anim_id);
	}
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	printf("Wczytano animacje [wczytanych: %d] [czas %d ms]", Iter_Count(Anims), Code_ExTimer_End(LoadAnims));
	return 1;
}

stock ConnectMysql()
{
	Code_ExTimer_Begin(ConnectMysql);
	
	mySQLconnection = mysql_connect(Setting[setting_mysql_hostname], Setting[setting_mysql_username], Setting[setting_mysql_password], Setting[setting_mysql_database]);
	mysql_log(ERROR);

	if(mysql_errno(mySQLconnection) == 0)
    {
		printf("[MySQL] Polaczono z baza danych %s@%s [czas: %d ms]", Setting[setting_mysql_username], Setting[setting_mysql_hostname], Code_ExTimer_End(ConnectMysql));
		return true;
	}
	else
	{
		printf("[MySQL] Blad MySQL [czas: %d ms]", Code_ExTimer_End(ConnectMysql));
		return false;
	}
}

stock LoadGlobalSpawns()
{
	Code_ExTimer_Begin(LoadGlobalSpawns);
	
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, "SELECT * FROM ipb_gspawns");
	cache_get_row_count(rows);

 	for(new row = 0; row != rows; row++)
	{
		if( row >= MAX_SPAWNS ) break;
		
		cache_get_value_index_int(row, 0, GlobalSpawn[row][gspawn_id]);
		cache_get_value_index_float(row, 1, GlobalSpawn[row][gspawn_pos][0]);
		cache_get_value_index_float(row, 2, GlobalSpawn[row][gspawn_pos][1]);
		cache_get_value_index_float(row, 3, GlobalSpawn[row][gspawn_pos][2]);
		cache_get_value_index_float(row, 4, GlobalSpawn[row][gspawn_pos][3]);
		cache_get_value_index_int(row, 5, GlobalSpawn[row][gspawn_type]);
		
		Iter_Add(GlobalSpawns, row);
	}
	
	printf("Wczytano spawny [wczytanych: %d] [czas: %d ms]", Iter_Count(GlobalSpawns), Code_ExTimer_End(LoadGlobalSpawns));
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
}

stock LoadRemoveObjects()
{
	Code_ExTimer_Begin(LoadRemoveObjects);
	
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, "SELECT * FROM ipb_remove_objects");
	cache_get_row_count(rows);

 	for(new row = 0; row != rows; row++)
	{
		if( row >= MAX_REMOVES ) break;
		
		cache_get_value_index_int(row, 0, RemoveObject[row][remove_uid]);
		cache_get_value_index_int(row, 1, RemoveObject[row][remove_model]);
		cache_get_value_index_float(row, 2, RemoveObject[row][remove_pos][0]);
		cache_get_value_index_float(row, 3, RemoveObject[row][remove_pos][1]);
		cache_get_value_index_float(row, 4, RemoveObject[row][remove_pos][2]);
		cache_get_value_index_float(row, 5, RemoveObject[row][remove_pos][3]);
		
		Iter_Add(RemoveObjects, row);
	}
	
	printf("Wczytano skasowane obiekty mapy [wczytanych: %d] [czas: %d ms]", Iter_Count(RemoveObjects), Code_ExTimer_End(LoadRemoveObjects));
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
}

stock LoadObjects()
{
	Code_ExTimer_Begin(LoadObjects);

	//Static environment packs
	CreateObject(-2053, 2360.72, -2117.01, 16.2578, 0.0, 0.0, 0.0, 300.0); //higschool
	CreateObject(-2055, 2137.98, -1672.55, 12.7734, 0.0, 0.0, 0.0, 350.0); //podloze crystal
	CreateObject(-2056, 570.74, -1868.34, 1.6797, 0.0, 0.0, 0.0, 250.0); //plaza skatepark
	CreateObject(-2058, 1653.94, -1556.61, 19.1406, 0.0, 0.0, 0.0, 140.0); //lampki chinatown
	CreateObject(-2061, 1876.55, -1654.23, 12.05, 0.0, 0.0, 0.0, 350.0); //alhambra podloze

	CreateObject(-2062, 1850.15, -1649.93, 16.9539, 0.0, 0.0, 0.0, 190.0); //alhambra block
	CreateObject(-2062, 1914.84, -1650.16, 16.9539, 0.0, 0.0, 0.0, 190.0); //alhambra block
	CreateObject(-2062, 1883.11, -1650.09, 16.9539, 0.0, 0.0, 0.0, 190.0); //alhambra block
	CreateObject(-2062, 1880.81, -1710.27, 16.9539, 0.0, 0.0, 0.0, 190.0); //alhambra block
	CreateObject(-2062, 1915.93, -1710.38, 16.9539, 0.0, 0.0, 0.0, 190.0); //alhambra block

	CreateObject(-2094, -199.332, -307.306, 7.28336, 0.0, 0.0, 90.0, 490.0); //wiezienie

	//Usuwamy blokady z dnia poprzedniego je�li jakie� zostawili
	mysql_query(mySQLconnection, "DELETE FROM `ipb_objects` WHERE `object_type` = '2' "); 
	
	new loaded = LoadObject("WHERE `object_world` = 0", true);
	
	printf("Wczytano obiekty [wczytanych: %d] [czas: %d ms]", loaded, Code_ExTimer_End(LoadObjects));
}

stock IsBoat(carid)
{
	new Boats[] = { 446, 452, 453, 454, 472, 473, 484, 493 };
  	for(new i = 0; i < sizeof(Boats); i++)
  	{
    	if(GetVehicleModel(carid) == Boats[i]) return 1;
  	}
  	return 0;
}

stock DestroyGroupsWithUnpaidTax()
{
	Code_ExTimer_Begin(DestroyGroupsWithUnpaidTax);

	new deleted_groups;

	for(new gid;gid<MAX_GROUPS;gid++)
	{
		if(GroupHasFlag(gid, GROUP_FLAG_BUSINESS))
		{
			if(Group[gid][group_last_tax] + 31*86400 > gettime())
			{
				printf("[SARP Delete] Deleted group %s (UID %d) - unpaid tax.", Group[gid][group_name], Group[gid][group_uid]);
				DeleteGroup(gid);
				deleted_groups++;
			}
		}
	}

	printf("Skasowano biznesy ktore nie oplacily podatku [skasowanych: %d] [czas: %d ms]", deleted_groups, Code_ExTimer_End(DestroyGroupsWithUnpaidTax));
}

stock DestroyDeletedGroups()
{
	Code_ExTimer_Begin(DestroyDeletedGroups);

	foreach(new gid: DeletedGroups)
	{
		new Cache:tmp_cache, rows;
		tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT DISTINCT c.char_gid FROM ipb_characters c, ipb_char_groups g WHERE g.char_uid = c.char_uid AND g.group_belongs = %d", Group[gid][group_uid])); 
		cache_get_row_count(rows);

		if(rows < 3)
		{
			printf("[SARP Delete] Deleted temp group %s (UID %d) - no 3 members.", Group[gid][group_name], Group[gid][group_uid]);
			DeleteGroup(gid);
			continue;
		}

		tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT area_uid FROM `ipb_areas` WHERE `area_ownertype` = %d AND area_owner = %d", AREA_OWNER_TYPE_GROUP, Group[gid][group_uid])); 
		cache_get_row_count(rows);

		if(!rows)
		{
			printf("[SARP Delete] Deleted temp group %s (UID %d) - no area.", Group[gid][group_name], Group[gid][group_uid]);
			DeleteGroup(gid);
			continue;
		}

		Group[gid][group_type] = GROUP_TYPE_GANG;
		Group[gid][group_flags] = GroupDefaultFlags[GROUP_TYPE_GANG];

		mysql_query(mySQLconnection, sprintf("UPDATE ipb_game_groups SET group_temp = 0, group_type = 5, group_flags = %d WHERE group_uid = %d", Group[gid][group_flags], Group[gid][group_uid]));
		Group[gid][group_temp] = 0;

		if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);

		new next;
	    Iter_SafeRemove(DeletedGroups, gid, next);
	    gid = next;
	}

	printf("Skasowano grupy tymczasowe [skasowanych: %d] [czas: %d ms]", Iter_Count(DeletedGroups), Code_ExTimer_End(DestroyDeletedGroups));
}

stock LoadGroups()
{
	Code_ExTimer_Begin(LoadGroups);
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, "SELECT * FROM `ipb_game_groups` ORDER BY `group_owner` ASC");  
	cache_get_row_count(rows);

	for(new row = 0; row != rows; row++)
	{
		new i = Iter_Free(Groups);

		cache_get_value_index_int(row, 0, Group[i][group_uid]);
		cache_get_value_index(row, 1, Group[i][group_name], 64);
		cache_get_value_index_int(row, 2, Group[i][group_bank_money]);
		cache_get_value_index_int(row, 4, Group[i][group_type]);
		cache_get_value_index_int(row, 6, Group[i][group_tribute]);
		cache_get_value_index_int(row, 7, Group[i][group_tributers]);
		cache_get_value_index(row, 8, Group[i][group_color], 12);
		cache_get_value_index_int(row, 9, Group[i][group_activity_points]);
		cache_get_value_index(row, 10, Group[i][group_tag], 15);
		cache_get_value_index_int(row, 11, Group[i][group_capital]);
		cache_get_value_index_int(row, 12, Group[i][group_flags]);
		cache_get_value_index_int(row, 15, Group[i][group_last_tribute]);
		cache_get_value_index_int(row, 17, Group[i][group_temp]);
		cache_get_value_index_int(row, 18, Group[i][group_level]);
		cache_get_value_index_int(row, 19, Group[i][group_creator]);
		cache_get_value_index_int(row, 20, Group[i][group_last_tax]);
		cache_get_value_index_int(row, 21, Group[i][group_last_smuggle]);
		
		cache_get_value_index_int(row, 23, Group[i][group_last_take]);
		
		if(Group[i][group_type] == GROUP_TYPE_SN)
		{
			Group[i][group_sms_number] = 300+random(99);
			Group[i][group_sms_cost] = 0;
		}

		Iter_Add(Groups, i);

		if(Group[i][group_temp] == 1)
		{
			Iter_Add(DeletedGroups, i);
		}
	}
	
	printf("Wczytano grupy [wczytanych: %d] [czas: %d ms]", Iter_Count(Groups), Code_ExTimer_End(LoadGroups));
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
}

stock LoadDoors()
{
	Code_ExTimer_Begin(LoadDoors);
	
	new loaded = LoadDoor();
	
	printf("Wczytano drzwi [wczytanych: %d] [czas: %d ms]", loaded, Code_ExTimer_End(LoadDoors));
}

stock LoadAreas()
{
	Code_ExTimer_Begin(LoadAreas);
	
	new loaded = LoadArea();
	
	printf("Wczytano strefy [wczytanych: %d] [czas: %d ms]", loaded, Code_ExTimer_End(LoadAreas));
}

stock LoadLabels()
{
	Code_ExTimer_Begin(LoadLabels);
	
	new loaded = LoadLabel();
	
	printf("Wczytano 3d labele [wczytanych: %d] [czas: %d ms]", loaded, Code_ExTimer_End(LoadLabels));
}

stock LoadVehicles()
{
	Code_ExTimer_Begin(LoadVehicles);

	new loaded = LoadVehicle(sprintf("WHERE `vehicle_ownertype` = %d OR  `vehicle_ownertype` = %d", VEHICLE_OWNER_TYPE_GROUP, VEHICLE_OWNER_TYPE_JOB));
	
	printf("Wczytano pojazdy [wczytanych: %d] [czas: %d ms]", loaded, Code_ExTimer_End(LoadVehicles));
}

stock LoadItems()
{
	Code_ExTimer_Begin(LoadItems);

	new loaded = LoadItem(sprintf("WHERE `item_ownertype` = %d OR `item_ownertype` = %d", ITEM_OWNER_TYPE_GROUP, ITEM_OWNER_TYPE_GROUND));
	
	printf("Wczytano przedmioty [wczytanych: %d] [czas: %d ms]", loaded, Code_ExTimer_End(LoadItems));
}

stock LoadMaterials()
{
	Code_ExTimer_Begin(LoadMaterials);

	new loaded = LoadMaterial(.serverstart = 1);
	
	printf("Wczytano tekstury mmat/omat [wczytanych: %d] [czas: %d ms]", loaded, Code_ExTimer_End(LoadMaterials));
}

stock LoadSkins()
{
	Code_ExTimer_Begin(LoadSkins);
	new skinid = 0, rows, Cache:tmp_cache;

	tmp_cache = mysql_query(mySQLconnection, "SELECT * FROM `ipb_game_skins`");
	cache_get_row_count(rows);

	for(new row = 0; row != rows; row++)
	{
	    if(skinid == MAX_SKINS) break;

	    cache_get_value_index_int(row, 0, ClothSkin[skinid][skin_uid]);
     	cache_get_value_index_int(row, 1, ClothSkin[skinid][skin_model]);
     	cache_get_value_index(row, 2, ClothSkin[skinid][skin_name], 32);
      	cache_get_value_index_int(row, 3, ClothSkin[skinid][skin_price]);
	    skinid++;
	}
	printf("Wczytano skiny [wczytanych: %d] [czas: %d ms]", skinid-1, Code_ExTimer_End(LoadSkins));
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
}

stock LoadAccess()
{
	Code_ExTimer_Begin(LoadAccess);
	new accessid = 0, rows, Cache:tmp_cache;

	tmp_cache = mysql_query(mySQLconnection, "SELECT * FROM ipb_attached_objects WHERE attach_category != 0");
	cache_get_row_count(rows);

	for(new row = 0; row != rows; row++)
	{
	    if(accessid == MAX_ACCESS) break;

	    cache_get_value_index_int(row, 0, ClothAccess[accessid][access_uid]);
	    cache_get_value_index_int(row, 3, ClothAccess[accessid][access_model]);
	    cache_get_value_index_int(row, 16, ClothAccess[accessid][access_price]);
	    cache_get_value_index_int(row, 4, ClothAccess[accessid][access_bone]);
	    cache_get_value_index_int(row, 14, ClothAccess[accessid][access_category]);

	    cache_get_value_index_float(row, 5, ClothAccess[accessid][access_pos][0]);
     	cache_get_value_index_float(row, 6, ClothAccess[accessid][access_pos][1]);
      	cache_get_value_index_float(row, 7, ClothAccess[accessid][access_pos][2]);
       	cache_get_value_index_float(row, 8, ClothAccess[accessid][access_pos][3]);
    	cache_get_value_index_float(row, 9, ClothAccess[accessid][access_pos][4]);
 		cache_get_value_index_float(row, 10, ClothAccess[accessid][access_pos][5]);

        cache_get_value_index(row, 15, ClothAccess[accessid][access_name], 40);

	    accessid++;
	}
	printf("Wczytano akcesoria przyczepialne [wczytanych: %d] [czas: %d ms]", accessid-1, Code_ExTimer_End(LoadAccess));
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
}