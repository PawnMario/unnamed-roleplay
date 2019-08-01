stock GetRobberyLevel(rid)
{
	new tmp_name[40];

	switch(Robbery[rid][robbery_level])
	{
		case ROBBERY_LEVEL_EASY: format(tmp_name, sizeof(tmp_name), "{D6EE76}£atwy");
		case ROBBERY_LEVEL_MEDIUM: format(tmp_name, sizeof(tmp_name), "{F2E200}Œredni");
		case ROBBERY_LEVEL_HARD: format(tmp_name, sizeof(tmp_name), "{FF3C3C}Trudny");
		case ROBBERY_LEVEL_HARDCORE: format(tmp_name, sizeof(tmp_name), "{AA3333}Hardcore");
	}

	return tmp_name;
}

stock GetRobberyByUid(uid)
{
	foreach(new r_id : Robberies)
	{
		if( Robbery[r_id][robbery_uid] == uid ) return r_id;
	}
	return -1;
}

stock GetRobberyByPlace(doorid)
{
	foreach(new r_id : Robberies)
	{
		if( Robbery[r_id][robbery_place] == Door[doorid][door_uid] ) return r_id;
	}
	return -1;
}

stock LoadRobberies()
{
	Code_ExTimer_Begin(LoadRobberies);
	new rows, Cache:tmp_cache;
	tmp_cache = mysql_query(mySQLconnection, "SELECT * FROM ipb_robberies ORDER BY robbery_level DESC");  
	cache_get_row_count(rows);

	for(new row = 0; row != rows; row++)
	{
		new i = Iter_Free(Robberies);

		cache_get_value_index_int(row, 0, Robbery[i][robbery_uid]);
		cache_get_value_index_int(row, 1, Robbery[i][robbery_place]);
		cache_get_value_index(row, 2, Robbery[i][robbery_name], 60);
		cache_get_value_index_int(row, 3, Robbery[i][robbery_requirements]);
		cache_get_value_index_int(row, 4, Robbery[i][robbery_level]);
		cache_get_value_index_int(row, 5, Robbery[i][robbery_timestamp]);

		Robbery[i][robbery_actors] = CountRobberyActors(i);
		
		Iter_Add(Robberies, i);
	}
	
	if(cache_is_valid(tmp_cache)) cache_delete(tmp_cache);
	printf("Wczytano napady [wczytanych: %d] [czas: %d ms]", rows, Code_ExTimer_End(LoadRobberies));
}

stock CountRobberyActors(rid)
{
	new count;
	foreach(new a_id: Actors)
	{
		if(Actor[a_id][actor_type] == ACTOR_TYPE_ROBBERY && Actor[a_id][actor_owner] == Robbery[rid][robbery_uid]) count++;
	}

	return count;
}