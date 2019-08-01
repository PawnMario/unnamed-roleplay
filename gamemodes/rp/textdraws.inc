stock CheckTextDrawString(const string[])
{
	for(new znak = 0; znak < strlen(string); znak++)
	{
		if(string[znak] == '~')
		{
			if((string[znak+1] == 'r' || string[znak+1] == 'g' || string[znak+1] == 'b' || string[znak+1] == 'w' || string[znak+1] == 'l' || string[znak+1] == 'p' || string[znak+1] == 'n') && string[znak+2] == '~')
			{
				if(string[znak+2] == '~') znak += 2;
			}
		else return 0;
		}
	}
	return 1;
}

stock DestroyPlayerTextDraws(playerid)
{
	DestroyPlayerProgressBar(playerid, pInfo[playerid][player_health_bar]);
	PlayerTextDrawDestroy(playerid, ZoneName[playerid]);
	PlayerTextDrawDestroy(playerid, GroupDutyTag[playerid]);
	PlayerTextDrawDestroy(playerid, WhiteScreen[playerid]);
	PlayerTextDrawDestroy(playerid, TextDrawSanNews[playerid]);

	for(new i=0;i<5;i++)
	{
		PlayerTextDrawDestroy(playerid, GroupsListRow[playerid][i]);
	}

	for(new i=0;i<5;i++)
	{
		PlayerTextDrawDestroy(playerid, GroupsListStaticButtons[playerid][i][0]);
		PlayerTextDrawDestroy(playerid, GroupsListStaticButtons[playerid][i][1]);
		PlayerTextDrawDestroy(playerid, GroupsListStaticButtons[playerid][i][2]);
		PlayerTextDrawDestroy(playerid, GroupsListStaticButtons[playerid][i][3]);
		PlayerTextDrawDestroy(playerid, GroupsListStaticButtons[playerid][i][4]);
	}

}

stock CreateZoneTextDraw(playerid)
{
	if(pInfo[playerid][player_widescreen])
	{
		ZoneName[playerid] = CreatePlayerTextDraw(playerid, 548.000000, 80.000000, "_");
		PlayerTextDrawBackgroundColor(playerid, ZoneName[playerid], 255);
		PlayerTextDrawFont(playerid, ZoneName[playerid], 3);
		PlayerTextDrawLetterSize(playerid, ZoneName[playerid], 0.310000, 1.000000);
		PlayerTextDrawColor(playerid, ZoneName[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ZoneName[playerid], 1);
		PlayerTextDrawSetProportional(playerid, ZoneName[playerid], 1);
	}
	else
	{
		ZoneName[playerid] = CreatePlayerTextDraw(playerid, 500.000000, 98.000000, "_");
		PlayerTextDrawBackgroundColor(playerid, ZoneName[playerid], 255);
		PlayerTextDrawFont(playerid, ZoneName[playerid], 3);
		PlayerTextDrawLetterSize(playerid, ZoneName[playerid], 0.310000, 1.000000);
		PlayerTextDrawColor(playerid, ZoneName[playerid], -1);
		PlayerTextDrawSetOutline(playerid, ZoneName[playerid], 1);
		PlayerTextDrawSetProportional(playerid, ZoneName[playerid], 1);
	}
}

stock CreatePlayerTextdraws(playerid)
{	
	CreateGroupPlayerTextdraws(playerid);

	RouletteNumber[playerid] = CreatePlayerTextDraw(playerid, 38.333538, 146.429687, "24");
	PlayerTextDrawLetterSize(playerid, RouletteNumber[playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, RouletteNumber[playerid], 2);
	PlayerTextDrawColor(playerid, RouletteNumber[playerid], -1);
	PlayerTextDrawSetShadow(playerid, RouletteNumber[playerid], 0);
	PlayerTextDrawSetOutline(playerid, RouletteNumber[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, RouletteNumber[playerid], 51);
	PlayerTextDrawFont(playerid, RouletteNumber[playerid], 3);
	PlayerTextDrawSetProportional(playerid, RouletteNumber[playerid], 1);

	GroupDutyTag[playerid] = CreatePlayerTextDraw(playerid, 8.000000, 428.000000, "GOV");
	PlayerTextDrawBackgroundColor(playerid, GroupDutyTag[playerid], 255);
	PlayerTextDrawFont(playerid, GroupDutyTag[playerid], 1);
	PlayerTextDrawLetterSize(playerid, GroupDutyTag[playerid], 0.230000, 0.899999);
	PlayerTextDrawColor(playerid, GroupDutyTag[playerid], -1);
	PlayerTextDrawSetOutline(playerid, GroupDutyTag[playerid], 1);
	PlayerTextDrawSetProportional(playerid, GroupDutyTag[playerid], 1);

	WhiteScreen[playerid] = CreatePlayerTextDraw(playerid, -20.000000, 0.000000, "_" ); 
 	PlayerTextDrawUseBox(playerid, WhiteScreen[playerid], 1 );
 	PlayerTextDrawBoxColor(playerid, WhiteScreen[playerid], 0xFFFFFFFF );
 	PlayerTextDrawAlignment(playerid, WhiteScreen[playerid], 0 );
 	PlayerTextDrawBackgroundColor(playerid, WhiteScreen[playerid], 0xFFFFFFFF );
 	PlayerTextDrawFont(playerid, WhiteScreen[playerid], 3 );
 	PlayerTextDrawLetterSize(playerid, WhiteScreen[playerid], 1.000000, 52.200000 );
 	PlayerTextDrawColor(playerid, WhiteScreen[playerid], 0xFFFFFFFF );

    TextDrawSanNews[playerid] = CreatePlayerTextDraw(playerid, -1.000000,438.000000, "_~w~Uzyj komendy ~y~/radio~w~ aby wybrac radiostacje.");
    PlayerTextDrawUseBox(playerid, TextDrawSanNews[playerid],1);
    PlayerTextDrawBoxColor(playerid, TextDrawSanNews[playerid],25);
    PlayerTextDrawTextSize(playerid, TextDrawSanNews[playerid],640.000000,0.000000);
    PlayerTextDrawAlignment(playerid, TextDrawSanNews[playerid],0);
    PlayerTextDrawBackgroundColor(playerid, TextDrawSanNews[playerid],0x000000ff);
    PlayerTextDrawFont(playerid, TextDrawSanNews[playerid],1);
    PlayerTextDrawLetterSize(playerid, TextDrawSanNews[playerid],0.199999,1.000000);
    PlayerTextDrawColor(playerid, TextDrawSanNews[playerid],0xffffffff);
    PlayerTextDrawSetOutline(playerid, TextDrawSanNews[playerid],1);
    PlayerTextDrawSetProportional(playerid, TextDrawSanNews[playerid],1);
    PlayerTextDrawSetShadow(playerid, TextDrawSanNews[playerid],1);
}

stock CreateTextdraws()
{	
	CreateGroupStaticTextdraws();

	Serverlogo = TextDrawCreate(203.666717, 119.051826, "mdl-2000:mp_shop_floor2");
	TextDrawLetterSize(Serverlogo, 0.000000, 0.000000);
	TextDrawTextSize(Serverlogo, 73.333374, 77.985221);
	TextDrawAlignment(Serverlogo, 1);
	TextDrawColor(Serverlogo, -1);
	TextDrawSetShadow(Serverlogo, 0);
	TextDrawSetOutline(Serverlogo, 0);
	TextDrawFont(Serverlogo, 4);

	Textdraw2 = TextDrawCreate(578.000000, 5.000000, "~y~san~w~-andreas.~y~pl~n~~w~20.20.2017");
    TextDrawAlignment(Textdraw2, 2);
    TextDrawBackgroundColor(Textdraw2, 100);
    TextDrawFont(Textdraw2, 3);
    TextDrawLetterSize(Textdraw2, 0.330000, 1.100000);
    TextDrawColor(Textdraw2, -1);
    TextDrawSetOutline(Textdraw2, 1);
    TextDrawSetProportional(Textdraw2, 1);

    RouletteBlack = TextDrawCreate(57.999942, 136.888854, "LD_ROUL:roulbla");
	TextDrawLetterSize(RouletteBlack, 0.000000, 0.000000);
	TextDrawTextSize(RouletteBlack, -41.333339, 49.777782);
	TextDrawAlignment(RouletteBlack, 1);
	TextDrawColor(RouletteBlack, -1);
	TextDrawSetShadow(RouletteBlack, 0);
	TextDrawSetOutline(RouletteBlack, 0);
	TextDrawFont(RouletteBlack, 4);

	RouletteRed = TextDrawCreate(57.999942, 136.888854, "LD_ROUL:roulred");
	TextDrawLetterSize(RouletteRed, 0.000000, 0.000000);
	TextDrawTextSize(RouletteRed, -41.333339, 49.777782);
	TextDrawAlignment(RouletteRed, 1);
	TextDrawColor(RouletteRed, -1);
	TextDrawSetShadow(RouletteRed, 0);
	TextDrawSetOutline(RouletteRed, 0);
	TextDrawFont(RouletteRed, 4);

	RouletteGreen = TextDrawCreate(57.999942, 136.888854, "LD_ROUL:roulgre");
	TextDrawLetterSize(RouletteGreen, 0.000000, 0.000000);
	TextDrawTextSize(RouletteGreen, -41.333339, 49.777782);
	TextDrawAlignment(RouletteGreen, 1);
	TextDrawColor(RouletteGreen, -1);
	TextDrawSetShadow(RouletteGreen, 0);
	TextDrawSetOutline(RouletteGreen, 0);
	TextDrawFont(RouletteGreen, 4);

	vehicleInfo = TextDrawCreate(438.000000, 366.000000, "Aby uruchomic silnik, wcisnij ~y~LCTRL~w~.~n~Klawisz ~y~LMB ~w~odpala swiatla.");
	TextDrawBackgroundColor(vehicleInfo, 255);
	TextDrawFont(vehicleInfo, 1);
	TextDrawLetterSize(vehicleInfo, 0.220000, 0.899999);
	TextDrawColor(vehicleInfo, -1);
	TextDrawSetOutline(vehicleInfo, 0);
	TextDrawSetProportional(vehicleInfo, 1);
	TextDrawSetShadow(vehicleInfo, 1);
	TextDrawUseBox(vehicleInfo, 1);
	TextDrawBoxColor(vehicleInfo, 128);
	TextDrawTextSize(vehicleInfo, 611.000000, 0.000000);

	TextPenalty = TextDrawCreate(12.000000, 287.000000, " ");
	TextDrawBackgroundColor(TextPenalty, 255);
	TextDrawFont(TextPenalty, 1);
	TextDrawLetterSize(TextPenalty,0.280000, 1.200000);
	TextDrawColor(TextPenalty, -1);
	TextDrawSetOutline(TextPenalty, 1);
	TextDrawSetProportional(TextPenalty, 1);

	TextDrawScreenShot = TextDrawCreate(-20.000000,2.000000,"|");
	TextDrawUseBox(TextDrawScreenShot,1);
	TextDrawBoxColor(TextDrawScreenShot,0x000000ff);
	TextDrawTextSize(TextDrawScreenShot,660.000000,22.000000);
	TextDrawAlignment(TextDrawScreenShot,0);
	TextDrawBackgroundColor(TextDrawScreenShot,0x000000ff);
	TextDrawFont(TextDrawScreenShot,3);
	TextDrawLetterSize(TextDrawScreenShot,1.000000,52.200000);
	TextDrawColor(TextDrawScreenShot,0x000000ff);
	TextDrawSetOutline(TextDrawScreenShot,1);
	TextDrawSetProportional(TextDrawScreenShot,1);
	TextDrawSetShadow(TextDrawScreenShot,1);

	BodBackground = TextDrawCreate(185.000091, 109.096382, "mdl-2096:book_back");
	TextDrawLetterSize(BodBackground, 0.000000, 0.000000);
	TextDrawTextSize(BodBackground, 265.999938, 270.044555);
	TextDrawAlignment(BodBackground, 1);
	TextDrawColor(BodBackground, -1);
	TextDrawSetShadow(BodBackground, 0);
	TextDrawSetOutline(BodBackground, 0);
	TextDrawFont(BodBackground, 4);

	for(new pp;pp<MAX_PLAYERS;pp++)
	{
		DoorInfo[pp] = TextDrawCreate(510.000000, 325.000000, "~n~");
        TextDrawAlignment(DoorInfo[pp], 2);
        TextDrawBackgroundColor(DoorInfo[pp], 2083701910);
        TextDrawFont(DoorInfo[pp], 1);
        TextDrawLetterSize(DoorInfo[pp], 0.219996, 1.199977);
        TextDrawColor(DoorInfo[pp], -1);
        TextDrawSetOutline(DoorInfo[pp], 0);
        TextDrawSetProportional(DoorInfo[pp], 1);
        TextDrawSetShadow(DoorInfo[pp], 0);
        TextDrawUseBox(DoorInfo[pp], 1);
        TextDrawBoxColor(DoorInfo[pp], 100);
        TextDrawTextSize(DoorInfo[pp], 0.000000, 171.000000);

		Tutorial[pp] = TextDrawCreate(449.999969, 131.496368, "~n~");
		TextDrawLetterSize(Tutorial[pp], 0.209997, 1.000000);
		TextDrawTextSize(Tutorial[pp], 620.666687, 269.214904);
		TextDrawAlignment(Tutorial[pp], 1);
		TextDrawColor(Tutorial[pp], -1);
		TextDrawUseBox(Tutorial[pp], true);
		TextDrawBoxColor(Tutorial[pp], 100);
		TextDrawSetShadow(Tutorial[pp], 0);
		TextDrawSetOutline(Tutorial[pp], -1);
		TextDrawBackgroundColor(Tutorial[pp], 255);
		TextDrawFont(Tutorial[pp], 1);
		TextDrawSetProportional(Tutorial[pp], 1);

		DashBoardPane[pp] = TextDrawCreate(202.000000, 340.000000, "~n~");
		TextDrawAlignment(DashBoardPane[pp], 2);
		TextDrawBackgroundColor(DashBoardPane[pp], 255);
		TextDrawFont(DashBoardPane[pp], 1);
		TextDrawLetterSize(DashBoardPane[pp], 0.500000, 14.000000);
		TextDrawColor(DashBoardPane[pp], -1);
		TextDrawSetOutline(DashBoardPane[pp], 0);
		TextDrawSetProportional(DashBoardPane[pp], 1);
		TextDrawSetShadow(DashBoardPane[pp], 1);
		TextDrawUseBox(DashBoardPane[pp], 1);
		TextDrawBoxColor(DashBoardPane[pp], 0x9E9EAD20);
		TextDrawTextSize(DashBoardPane[pp], 730.000000, -950.000000);

		DashBoardPane2[pp] = TextDrawCreate(152.000000, 349.000000, "Sluzba: ~b~grupa                    ~y~Ganton Gym (UID: 249)~n~~n~~w~Rozpoczeto: ~g~14:24               ~w~Tytul: ~r~Lider");
		TextDrawBackgroundColor(DashBoardPane2[pp], 255);
		TextDrawFont(DashBoardPane2[pp], 1);
		TextDrawLetterSize(DashBoardPane2[pp], 0.290000, 1.000000);
		TextDrawColor(DashBoardPane2[pp], -1);
		TextDrawSetOutline(DashBoardPane2[pp], 1);
		TextDrawSetProportional(DashBoardPane2[pp], 1);

		Dashboard[pp] = TextDrawCreate(320.000000, 300.000000, "");
		TextDrawAlignment(Dashboard[pp], 2);
		TextDrawBackgroundColor(Dashboard[pp], 255);
		TextDrawFont(Dashboard[pp], 1);
		TextDrawLetterSize(Dashboard[pp], 0.290000, 0.899999);
		TextDrawColor(Dashboard[pp], -1);
		TextDrawSetOutline(Dashboard[pp], 1);
		TextDrawSetProportional(Dashboard[pp], 1);
	}
}

stock CreateGroupPlayerTextdraws(playerid)
{
	new Float:baseY = 183.0;
	for(new i=0;i<5;i++)
	{
		GroupsListRow[playerid][i] = CreatePlayerTextDraw(playerid, 104.000000, baseY+(i*14), "1       Pig Pen (669)");
		PlayerTextDrawBackgroundColor(playerid, GroupsListRow[playerid][i], 255);
		PlayerTextDrawFont(playerid, GroupsListRow[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, GroupsListRow[playerid][i], 0.290000, 1.000000);
		PlayerTextDrawColor(playerid, GroupsListRow[playerid][i], -1);
		PlayerTextDrawSetOutline(playerid, GroupsListRow[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, GroupsListRow[playerid][i], 1);
		PlayerTextDrawUseBox(playerid, GroupsListRow[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, GroupsListRow[playerid][i], 112);
		PlayerTextDrawTextSize(playerid, GroupsListRow[playerid][i], 537.000000, 0.000000);
	}
	
	baseY = 184.0;
	for(new i=0;i<5;i++)
	{
		GroupsListStaticButtons[playerid][i][0] = CreatePlayerTextDraw(playerid, 344.000000, baseY+(playerid, i*14), "Info");
		PlayerTextDrawAlignment(playerid, GroupsListStaticButtons[playerid][i][0], 2);
		PlayerTextDrawBackgroundColor(playerid, GroupsListStaticButtons[playerid][i][0], 255);
		PlayerTextDrawFont(playerid, GroupsListStaticButtons[playerid][i][0], 1);
		PlayerTextDrawLetterSize(playerid, GroupsListStaticButtons[playerid][i][0], 0.190000, 0.799999);
		PlayerTextDrawColor(playerid, GroupsListStaticButtons[playerid][i][0], -1);
		PlayerTextDrawSetOutline(playerid, GroupsListStaticButtons[playerid][i][0], 1);
		PlayerTextDrawSetProportional(playerid, GroupsListStaticButtons[playerid][i][0], 1);
		PlayerTextDrawUseBox(playerid, GroupsListStaticButtons[playerid][i][0], 1);
		PlayerTextDrawBoxColor(playerid, GroupsListStaticButtons[playerid][i][0], 112);
		PlayerTextDrawTextSize(playerid, GroupsListStaticButtons[playerid][i][0], 12.0, 36.0);
		PlayerTextDrawSetSelectable(playerid, GroupsListStaticButtons[playerid][i][0], 1);

		GroupsListStaticButtons[playerid][i][1] = CreatePlayerTextDraw(playerid, 387.000000, baseY+(playerid, i*14), "Pojazdy");
		PlayerTextDrawAlignment(playerid, GroupsListStaticButtons[playerid][i][1], 2);
		PlayerTextDrawBackgroundColor(playerid, GroupsListStaticButtons[playerid][i][1], 255);
		PlayerTextDrawFont(playerid, GroupsListStaticButtons[playerid][i][1], 1);
		PlayerTextDrawLetterSize(playerid, GroupsListStaticButtons[playerid][i][1], 0.190000, 0.799999);
		PlayerTextDrawColor(playerid, GroupsListStaticButtons[playerid][i][1], -1);
		PlayerTextDrawSetOutline(playerid, GroupsListStaticButtons[playerid][i][1], 1);
		PlayerTextDrawSetProportional(playerid, GroupsListStaticButtons[playerid][i][1], 1);
		PlayerTextDrawUseBox(playerid, GroupsListStaticButtons[playerid][i][1], 1);
		PlayerTextDrawBoxColor(playerid, GroupsListStaticButtons[playerid][i][1], 112);
		PlayerTextDrawTextSize(playerid, GroupsListStaticButtons[playerid][i][1], 10.0, 36.0);
		PlayerTextDrawSetSelectable(playerid, GroupsListStaticButtons[playerid][i][1], 1);

		GroupsListStaticButtons[playerid][i][2] = CreatePlayerTextDraw(playerid, 430.000000, baseY+(playerid, i*14), "Duty");
		PlayerTextDrawAlignment(playerid, GroupsListStaticButtons[playerid][i][2], 2);
		PlayerTextDrawBackgroundColor(playerid, GroupsListStaticButtons[playerid][i][2], 255);
		PlayerTextDrawFont(playerid, GroupsListStaticButtons[playerid][i][2], 1);
		PlayerTextDrawLetterSize(playerid, GroupsListStaticButtons[playerid][i][2], 0.190000, 0.799999);
		PlayerTextDrawColor(playerid, GroupsListStaticButtons[playerid][i][2], -1);
		PlayerTextDrawSetOutline(playerid, GroupsListStaticButtons[playerid][i][2], 1);
		PlayerTextDrawSetProportional(playerid, GroupsListStaticButtons[playerid][i][2], 1);
		PlayerTextDrawUseBox(playerid, GroupsListStaticButtons[playerid][i][2], 1);
		PlayerTextDrawBoxColor(playerid, GroupsListStaticButtons[playerid][i][2], 112);
		PlayerTextDrawTextSize(playerid, GroupsListStaticButtons[playerid][i][2], 10.0, 36.0);
		PlayerTextDrawSetSelectable(playerid, GroupsListStaticButtons[playerid][i][2], 1);

		GroupsListStaticButtons[playerid][i][3] = CreatePlayerTextDraw(playerid, 473.000000, baseY+(playerid, i*14), "Magazyn");
		PlayerTextDrawAlignment(playerid, GroupsListStaticButtons[playerid][i][3], 2);
		PlayerTextDrawBackgroundColor(playerid, GroupsListStaticButtons[playerid][i][3], 255);
		PlayerTextDrawFont(playerid, GroupsListStaticButtons[playerid][i][3], 1);
		PlayerTextDrawLetterSize(playerid, GroupsListStaticButtons[playerid][i][3], 0.190000, 0.799999);
		PlayerTextDrawColor(playerid, GroupsListStaticButtons[playerid][i][3], -1);
		PlayerTextDrawSetOutline(playerid, GroupsListStaticButtons[playerid][i][3], 1);
		PlayerTextDrawSetProportional(playerid, GroupsListStaticButtons[playerid][i][3], 1);
		PlayerTextDrawUseBox(playerid, GroupsListStaticButtons[playerid][i][3], 1);
		PlayerTextDrawBoxColor(playerid, GroupsListStaticButtons[playerid][i][3], 112);
		PlayerTextDrawTextSize(playerid, GroupsListStaticButtons[playerid][i][3], 10.0, 36.0);
		PlayerTextDrawSetSelectable(playerid, GroupsListStaticButtons[playerid][i][3], 1);

		GroupsListStaticButtons[playerid][i][4] = CreatePlayerTextDraw(playerid, 516.000000, baseY+(playerid, i*14), "Online");
		PlayerTextDrawAlignment(playerid, GroupsListStaticButtons[playerid][i][4], 2);
		PlayerTextDrawBackgroundColor(playerid, GroupsListStaticButtons[playerid][i][4], 255);
		PlayerTextDrawFont(playerid, GroupsListStaticButtons[playerid][i][4], 1);
		PlayerTextDrawLetterSize(playerid, GroupsListStaticButtons[playerid][i][4], 0.190000, 0.799999);
		PlayerTextDrawColor(playerid, GroupsListStaticButtons[playerid][i][4], -1);
		PlayerTextDrawSetOutline(playerid, GroupsListStaticButtons[playerid][i][4], 1);
		PlayerTextDrawSetProportional(playerid, GroupsListStaticButtons[playerid][i][4], 1);
		PlayerTextDrawUseBox(playerid, GroupsListStaticButtons[playerid][i][4], 1);
		PlayerTextDrawBoxColor(playerid, GroupsListStaticButtons[playerid][i][4], 112);
		PlayerTextDrawTextSize(playerid, GroupsListStaticButtons[playerid][i][4], 10.0, 36.0);
		PlayerTextDrawSetSelectable(playerid, GroupsListStaticButtons[playerid][i][4], 1);
	}
}

stock CreateGroupStaticTextdraws()
{
	GroupsListStaticHeader = TextDrawCreate(104.000000, 172.000000, "~y~SLOT           NAZWA GRUPY                                          OPCJE");
	TextDrawBackgroundColor(GroupsListStaticHeader, 255);
	TextDrawFont(GroupsListStaticHeader, 3);
	TextDrawLetterSize(GroupsListStaticHeader, 0.280000, 0.799999);
	TextDrawColor(GroupsListStaticHeader, -1);
	TextDrawSetOutline(GroupsListStaticHeader, 1);
	TextDrawSetProportional(GroupsListStaticHeader, 1);
}

stock CreateBodTextDraws(playerid)
{
	//1
	BodSymbols[playerid][0][symbol_textdraw] = CreatePlayerTextDraw(playerid, 204.333251, 207.822204, "mdl-2096:archeolog");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][0][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][0][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][0][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][0][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][0][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][0][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][0][symbol_textdraw], 4);

	format(BodSymbols[playerid][0][symbol_model], 32, "mdl-2096:archeolog");
	BodSymbols[playerid][0][symbol_pos][0] = 204.333251;
	BodSymbols[playerid][0][symbol_pos][1] = 207.822204;

	//2
	BodSymbols[playerid][1][symbol_textdraw] = CreatePlayerTextDraw(playerid, 204.333328, 265.896301, "mdl-2096:j");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][1][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][1][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][1][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][1][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][1][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][1][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][1][symbol_textdraw], 4);

	format(BodSymbols[playerid][1][symbol_model], 32, "mdl-2096:j");
	BodSymbols[playerid][1][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][1][symbol_pos][1] = 265.896301;

	//3
	BodSymbols[playerid][2][symbol_textdraw] = CreatePlayerTextDraw(playerid, 204.333328, 151.822219, "mdl-2096:q");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][2][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][2][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][2][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][2][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][2][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][2][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][2][symbol_textdraw], 4);

	format(BodSymbols[playerid][2][symbol_model], 32, "mdl-2096:q");
	BodSymbols[playerid][2][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][2][symbol_pos][1] = 265.896301;

	//4
	BodSymbols[playerid][3][symbol_textdraw] = CreatePlayerTextDraw(playerid, 250.999893, 265.896270, "mdl-2096:faraon");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][3][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][3][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][3][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][3][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][3][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][3][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][3][symbol_textdraw], 4);

	format(BodSymbols[playerid][3][symbol_model], 32, "mdl-2096:faraon");
	BodSymbols[playerid][3][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][3][symbol_pos][1] = 265.896301;

	//5
	BodSymbols[playerid][4][symbol_textdraw] = CreatePlayerTextDraw(playerid, 251.000000, 207.822143, "mdl-2096:ptak");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][4][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][4][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][4][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][4][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][4][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][4][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][4][symbol_textdraw], 4);

	format(BodSymbols[playerid][4][symbol_model], 32, "mdl-2096:ptak");
	BodSymbols[playerid][4][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][4][symbol_pos][1] = 265.896301;

	//6
	BodSymbols[playerid][5][symbol_textdraw] = CreatePlayerTextDraw(playerid, 251.000076, 151.822250, "mdl-2096:archeolog");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][5][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][5][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][5][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][5][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][5][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][5][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][5][symbol_textdraw], 4);

	format(BodSymbols[playerid][5][symbol_model], 32, "mdl-2096:archeolog");
	BodSymbols[playerid][5][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][5][symbol_pos][1] = 265.896301;

	//7
	BodSymbols[playerid][6][symbol_textdraw] = CreatePlayerTextDraw(playerid, 295.999969, 207.822189, "mdl-2096:book");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][6][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][6][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][6][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][6][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][6][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][6][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][6][symbol_textdraw], 4);

	format(BodSymbols[playerid][6][symbol_model], 32, "mdl-2096:book");
	BodSymbols[playerid][6][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][6][symbol_pos][1] = 265.896301;

	//8
	BodSymbols[playerid][7][symbol_textdraw] = CreatePlayerTextDraw(playerid, 342.666748, 207.822219, "mdl-2096:nasus");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][7][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][7][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][7][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][7][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][7][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][7][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][7][symbol_textdraw], 4);

	format(BodSymbols[playerid][7][symbol_model], 32, "mdl-2096:nasus");
	BodSymbols[playerid][7][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][7][symbol_pos][1] = 265.896301;

	//9
	BodSymbols[playerid][8][symbol_textdraw] = CreatePlayerTextDraw(playerid, 296.000000, 265.896362, "mdl-2096:j");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][8][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][8][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][8][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][8][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][8][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][8][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][8][symbol_textdraw], 4);

	format(BodSymbols[playerid][8][symbol_model], 32, "mdl-2096:j");
	BodSymbols[playerid][8][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][8][symbol_pos][1] = 265.896301;

	//10
	BodSymbols[playerid][9][symbol_textdraw] = CreatePlayerTextDraw(playerid, 295.999908, 153.896301, "mdl-2096:q");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][9][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][9][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][9][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][9][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][9][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][9][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][9][symbol_textdraw], 4);

	format(BodSymbols[playerid][9][symbol_model], 32, "mdl-2096:q");
	BodSymbols[playerid][9][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][9][symbol_pos][1] = 265.896301;

	//11
	BodSymbols[playerid][10][symbol_textdraw] = CreatePlayerTextDraw(playerid, 342.666717, 153.896240, "mdl-2096:k");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][10][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][10][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][10][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][10][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][10][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][10][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][10][symbol_textdraw], 4);

	format(BodSymbols[playerid][10][symbol_model], 32, "mdl-2096:k");
	BodSymbols[playerid][10][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][10][symbol_pos][1] = 265.896301;

	//12
	BodSymbols[playerid][11][symbol_textdraw] = CreatePlayerTextDraw(playerid, 342.666687, 265.896301, "mdl-2096:k");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][11][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][11][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][11][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][11][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][11][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][11][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][11][symbol_textdraw], 4);

	format(BodSymbols[playerid][11][symbol_model], 32, "mdl-2096:k");
	BodSymbols[playerid][11][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][11][symbol_pos][1] = 265.896301;

	//13
	BodSymbols[playerid][12][symbol_textdraw] = CreatePlayerTextDraw(playerid, 389.333343, 153.896301, "mdl-2096:nasus");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][12][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][12][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][12][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][12][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][12][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][12][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][12][symbol_textdraw], 4);

	format(BodSymbols[playerid][12][symbol_model], 32, "mdl-2096:nasus");
	BodSymbols[playerid][12][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][12][symbol_pos][1] = 265.896301;

	//14
	BodSymbols[playerid][13][symbol_textdraw] = CreatePlayerTextDraw(playerid, 389.333282, 209.896224, "mdl-2096:10");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][13][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][13][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][13][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][13][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][13][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][13][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][13][symbol_textdraw], 4);

	format(BodSymbols[playerid][13][symbol_model], 32, "mdl-2096:10");
	BodSymbols[playerid][13][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][13][symbol_pos][1] = 265.896301;

	//15
	BodSymbols[playerid][14][symbol_textdraw] = CreatePlayerTextDraw(playerid, 389.999755, 267.555603, "mdl-2096:10");
	PlayerTextDrawLetterSize(playerid, BodSymbols[playerid][14][symbol_textdraw], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, BodSymbols[playerid][14][symbol_textdraw], 42.333312, 51.851867);
	PlayerTextDrawAlignment(playerid, BodSymbols[playerid][14][symbol_textdraw], 1);
	PlayerTextDrawColor(playerid, BodSymbols[playerid][14][symbol_textdraw], -1);
	PlayerTextDrawSetShadow(playerid, BodSymbols[playerid][14][symbol_textdraw], 0);
	PlayerTextDrawSetOutline(playerid, BodSymbols[playerid][14][symbol_textdraw], 0);
	PlayerTextDrawFont(playerid, BodSymbols[playerid][14][symbol_textdraw], 4);

	format(BodSymbols[playerid][14][symbol_model], 32, "mdl-2096:10");
	BodSymbols[playerid][14][symbol_pos][0] = 204.333328;
	BodSymbols[playerid][14][symbol_pos][1] = 265.896301;

	//
	BodCoinsBank[playerid] = CreatePlayerTextDraw(playerid, 213.333358, 331.851867, "15000");
	PlayerTextDrawLetterSize(playerid, BodCoinsBank[playerid], 0.146999, 0.890667);
	PlayerTextDrawTextSize(playerid, BodCoinsBank[playerid], -19.000007, 57.244438);
	PlayerTextDrawAlignment(playerid, BodCoinsBank[playerid], 1);
	PlayerTextDrawColor(playerid, BodCoinsBank[playerid], -1);
	PlayerTextDrawSetShadow(playerid, BodCoinsBank[playerid], 0);
	PlayerTextDrawSetOutline(playerid, BodCoinsBank[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, BodCoinsBank[playerid], 51);
	PlayerTextDrawFont(playerid, BodCoinsBank[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BodCoinsBank[playerid], 1);

	BodCoinValue[playerid] = CreatePlayerTextDraw(playerid, 207.999908, 355.496429, "0.1");
	PlayerTextDrawLetterSize(playerid, BodCoinValue[playerid], 0.230995, 1.102221);
	PlayerTextDrawAlignment(playerid, BodCoinValue[playerid], 2);
	PlayerTextDrawColor(playerid, BodCoinValue[playerid], -2147483393);
	PlayerTextDrawSetShadow(playerid, BodCoinValue[playerid], 0);
	PlayerTextDrawSetOutline(playerid, BodCoinValue[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, BodCoinValue[playerid], -1);
	PlayerTextDrawFont(playerid, BodCoinValue[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BodCoinValue[playerid], 1);

	BodWin[playerid] = CreatePlayerTextDraw(playerid, 304.333374, 333.096313, "Wygrana: 50000");
	PlayerTextDrawLetterSize(playerid, BodWin[playerid], 0.230333, 1.268149);
	PlayerTextDrawAlignment(playerid, BodWin[playerid], 2);
	PlayerTextDrawColor(playerid, BodWin[playerid], -1);
	PlayerTextDrawSetShadow(playerid, BodWin[playerid], 0);
	PlayerTextDrawSetOutline(playerid, BodWin[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, BodWin[playerid], 51);
	PlayerTextDrawFont(playerid, BodWin[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BodWin[playerid], 1);

	BodCoinsWager[playerid] = CreatePlayerTextDraw(playerid, 261.333312, 356.740783, "5");
	PlayerTextDrawLetterSize(playerid, BodCoinsWager[playerid], 0.178999, 0.948741);
	PlayerTextDrawAlignment(playerid, BodCoinsWager[playerid], 2);
	PlayerTextDrawColor(playerid, BodCoinsWager[playerid], -1);
	PlayerTextDrawSetShadow(playerid, BodCoinsWager[playerid], 0);
	PlayerTextDrawSetOutline(playerid, BodCoinsWager[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, BodCoinsWager[playerid], 51);
	PlayerTextDrawFont(playerid, BodCoinsWager[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BodCoinsWager[playerid], 1);

	BodBet[playerid] = CreatePlayerTextDraw(playerid, 400.999969, 332.266693, "$10");
	PlayerTextDrawLetterSize(playerid, BodBet[playerid], 0.145998, 0.782814);
	PlayerTextDrawAlignment(playerid, BodBet[playerid], 2);
	PlayerTextDrawColor(playerid, BodBet[playerid], -1);
	PlayerTextDrawSetShadow(playerid, BodBet[playerid], 0);
	PlayerTextDrawSetOutline(playerid, BodBet[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, BodBet[playerid], 51);
	PlayerTextDrawFont(playerid, BodBet[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BodBet[playerid], 1);
}