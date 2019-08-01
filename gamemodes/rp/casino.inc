stock LoadRouletteSettings()
{
	Code_ExTimer_Begin(LoadRouletteSettings);

	for(new i = 0; i < sizeof(RouletteField); i++)
	{
		Iter_Add(RouletteFields, i);
	}

	printf("Wczytano ustawienia ruletki [wczytanych pol: %d] [czas %d ms]", Iter_Count(RouletteFields), Code_ExTimer_End(LoadRouletteSettings));
}

stock CheckRouletteWinnings(playerid, roulette_bet, roulette_number, choosen_field)
{
	new number_id = -1;

	foreach (new nr : RouletteFields)
	{
		if( RouletteField[nr][field_number] == roulette_number ) number_id = nr;
	}

	new win_amount;

	if( RouletteField[choosen_field][field_number] == roulette_number )
	{
		//trafil w konkretna liczbe
		win_amount = roulette_bet*RouletteField[choosen_field][field_multiplier];
	}

	if(number_id != -1)
	{
		//trafienia flagowe
		if(RouletteField[choosen_field][field_id] == 1 && RouletteField[number_id][field_flag] & ROULETTE_FLAG_1TO18) win_amount = roulette_bet * RouletteField[choosen_field][field_multiplier]; //1 do 18
		if(RouletteField[choosen_field][field_id] == 2 && RouletteField[number_id][field_flag] & ROULETTE_FLAG_EVEN) win_amount = roulette_bet * RouletteField[choosen_field][field_multiplier]; //Parzyste
		if(RouletteField[choosen_field][field_id] == 3 && RouletteField[number_id][field_flag] & ROULETTE_FLAG_RED) win_amount = roulette_bet * RouletteField[choosen_field][field_multiplier]; //Czerwone
		if(RouletteField[choosen_field][field_id] == 4 && RouletteField[number_id][field_flag] & ROULETTE_FLAG_BLACK) win_amount = roulette_bet * RouletteField[choosen_field][field_multiplier]; //Czarne	
		if(RouletteField[choosen_field][field_id] == 5 && RouletteField[number_id][field_flag] & ROULETTE_FLAG_ODD) win_amount = roulette_bet * RouletteField[choosen_field][field_multiplier]; //Nieparzyste
		if(RouletteField[choosen_field][field_id] == 6 && RouletteField[number_id][field_flag] & ROULETTE_FLAG_19TO36) win_amount = roulette_bet * RouletteField[choosen_field][field_multiplier]; //19 do 36
		if(RouletteField[choosen_field][field_id] == 7 && RouletteField[number_id][field_flag] & ROULETTE_FLAG_1ST12) win_amount = roulette_bet * RouletteField[choosen_field][field_multiplier]; //1st 12
		if(RouletteField[choosen_field][field_id] == 8 && RouletteField[number_id][field_flag] & ROULETTE_FLAG_2ND12) win_amount = roulette_bet * RouletteField[choosen_field][field_multiplier]; //2nd 12
		if(RouletteField[choosen_field][field_id] == 9 && RouletteField[number_id][field_flag] & ROULETTE_FLAG_3RD12) win_amount = roulette_bet * RouletteField[choosen_field][field_multiplier]; //3rd 12
	}

	if(win_amount > 0)
	{
		GameTextForPlayer(playerid,  "Wygrana", 3000, 6);
		GivePlayerMoney(playerid, win_amount);
		GiveGroupCapital(pInfo[playerid][player_roulette_owner], -win_amount);	
	}
	else
	{
		GameTextForPlayer(playerid,  "Przegrana", 3000, 6);	
	}
	return 1;
}

stock GetNumberColor(field_num)
{
	switch(field_num)
	{
		case 0: return ROULETTE_COLOR_GREEN;
		case 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36: return ROULETTE_COLOR_RED;
		case 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35: return ROULETTE_COLOR_BLACK;
	}

	return 0;
}

timer HideRouletteTextdraws[1000](playerid)
{
	TogglePlayerControllable(playerid, true);
	SetCameraBehindPlayer(playerid);
	
	TextDrawHideForPlayer(playerid, RouletteGreen);
	TextDrawHideForPlayer(playerid, RouletteBlack);
	TextDrawHideForPlayer(playerid, RouletteRed);

	PlayerTextDrawHide(playerid, RouletteNumber[playerid]);
	TextDrawHideForPlayer(playerid, Tutorial[playerid]);

	pInfo[playerid][player_roulette_object] = INVALID_STREAMER_ID;
	pInfo[playerid][player_roulette_bet] = 0;
	pInfo[playerid][player_roulette_field] = 0;

	if(IsValidDynamicObject(pInfo[playerid][player_roulette_selector])) DestroyDynamicObject(pInfo[playerid][player_roulette_selector]);
	pInfo[playerid][player_roulette_selector] = INVALID_STREAMER_ID;

	pInfo[playerid][player_roulette_timer] = 0;
}