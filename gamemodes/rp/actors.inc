stock LoadActors()
{
	Code_ExTimer_Begin(LoadActor);
	
	new loaded = LoadActor();
	
	ArmDealer = CreateDynamicActor(6, 0, 0, 0, 353.0);
	Iter_Add(Actors, ArmDealer);
	Actor[ArmDealer][actor_type] = ACTOR_TYPE_ARMDEALER;	

	printf("Wczytano aktorow [wczytanych: %d] [czas: %d ms]", loaded, Code_ExTimer_End(LoadActor));
}

stock GetClosestActorType(playerid, a_type)
{
	new Float:x, Float:y, Float:z;

	foreach(new a_id: Actors)
	{
		if(Actor[a_id][actor_type] == a_type )
		{
			GetDynamicActorPos(a_id, x, y, z);
			if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return a_id;
		}
	}

	return INVALID_STREAMER_ID;
}

stock LoadActor(limit[] = "", bool:return_id = false)
{
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, sprintf("SELECT * FROM ipb_actors %s", limit));  
	cache_get_row_count(rows);
	
	new a_id, tmp_skin, Float:tmp_x, Float:tmp_y, Float:tmp_z, Float:tmp_a;
	
	for(new row = 0; row != rows; row++)
	{
		cache_get_value_index_int(row, 1, tmp_skin);
		cache_get_value_index_float(row, 2, tmp_x);
		cache_get_value_index_float(row, 3, tmp_y);
		cache_get_value_index_float(row, 4, tmp_z);
		cache_get_value_index_float(row, 5, tmp_a);
		a_id = CreateDynamicActor(tmp_skin, tmp_x, tmp_y, tmp_z, tmp_a);
		
		Iter_Add(Actors, a_id);	
		
		cache_get_value_index_int(row, 0, Actor[a_id][actor_uid]);
		cache_get_value_index_int(row, 1, Actor[a_id][actor_skin]);

		Actor[a_id][actor_pos][0] = tmp_x;
		Actor[a_id][actor_pos][1] = tmp_y;
		Actor[a_id][actor_pos][2] = tmp_z;
		Actor[a_id][actor_pos][3] = tmp_a;

		cache_get_value_index_int(row, 6, Actor[a_id][actor_type]);
		cache_get_value_index_int(row, 7, Actor[a_id][actor_animation]);
		cache_get_value_index_int(row, 8, Actor[a_id][actor_action]);
		cache_get_value_index_int(row, 9, Actor[a_id][actor_vw]);
		cache_get_value_index_int(row, 10, Actor[a_id][actor_owner]);

		SetDynamicActorVirtualWorld(a_id, Actor[a_id][actor_vw]);

		if(Actor[a_id][actor_type] == ACTOR_TYPE_ROBBERY)
		{
			SetDynamicActorInvulnerable(a_id, 0);
		}

		Actor[a_id][actor_label] = CreateDynamic3DTextLabel(sprintf("Bot (%d)", a_id), COLOR_SAMP, tmp_x, tmp_y, tmp_z + 1.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Actor[a_id][actor_vw]);

		foreach(new anim_id: Anims)
		{
			if(AnimInfo[anim_id][aUID] == Actor[a_id][actor_animation])
        	{
        	    ApplyDynamicActorAnimation(a_id, AnimInfo[anim_id][aLib], AnimInfo[anim_id][aName], AnimInfo[anim_id][aSpeed], AnimInfo[anim_id][aOpt1], AnimInfo[anim_id][aOpt2], AnimInfo[anim_id][aOpt3], AnimInfo[anim_id][aOpt4], AnimInfo[anim_id][aOpt5]);
        	}
		}
	}
	
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	if( return_id ) return a_id;
	return rows;
}
