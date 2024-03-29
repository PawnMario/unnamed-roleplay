#if defined __dynamicgui
	#endinput
#endif
#define __dynamicgui

//  DynamicGui v2.0 by Tomasz Ptak (promsters) //
// native DynamicGui_Init()
// native DynamicGui_AddBlankRow()
// native DynamicGui_AddRow(value, additional_data_int=0)
// native DynamicGui_FreeRow() -- internal use
// native DynamicGui_GetValue(listitem)
// native DynamicGui_GetDataInt(listitem)


#define DYNAMIC_GUI_MAX_ROWS 200 // Max rows in gui

#define DG_NO_ACTION 0  // Value of no action row
#define INVALID_ROW_VALUE -198744124 // Do not touch

enum e_dynamic_gui_row
{
	value,
	additional_data_int,
}
new dynamic_gui[MAX_PLAYERS][DYNAMIC_GUI_MAX_ROWS][e_dynamic_gui_row];

new dynamic_gui_value[MAX_PLAYERS] = {-1, ...};

stock DynamicGui_Init(playerid)
{
	for(new i; i < DYNAMIC_GUI_MAX_ROWS; i++)
	{
		dynamic_gui[playerid][i][value] = INVALID_ROW_VALUE;
		dynamic_gui[playerid][i][additional_data_int] = 0;
	}
	
	dynamic_gui_value[playerid] = -1;
}

stock DynamicGui_SetDialogValue(playerid, d_value)
{
	dynamic_gui_value[playerid] = d_value;
}

stock DynamicGui_GetDialogValue(playerid)
{
	return dynamic_gui_value[playerid];
}

stock DynamicGui_FreeRow(playerid)
{
	for(new i; i < DYNAMIC_GUI_MAX_ROWS; i++)
	{
		if( dynamic_gui[playerid][i][value] == INVALID_ROW_VALUE )
		{
			return i;
		}
	}
	
	return -1;
}

stock DynamicGui_AddRow(playerid, dg_value, dg_additional_data_int = 0)
{
	new first_free_row = DynamicGui_FreeRow(playerid);
	if( first_free_row == -1 ) return;

	dynamic_gui[playerid][first_free_row][value] = dg_value;
	dynamic_gui[playerid][first_free_row][additional_data_int] = dg_additional_data_int;
}

stock DynamicGui_AddBlankRow(playerid)
{
	new first_free_row = DynamicGui_FreeRow(playerid);
	if( first_free_row == -1 ) return;

	dynamic_gui[playerid][first_free_row][value] = DG_NO_ACTION;
}

stock DynamicGui_GetValue(playerid, listitem)
{
	if( listitem > DYNAMIC_GUI_MAX_ROWS-1 ) return 0;
	
	return dynamic_gui[playerid][listitem][value];
}

stock DynamicGui_GetDataInt(playerid, listitem)
{
	if( listitem > DYNAMIC_GUI_MAX_ROWS-1 ) return 0;
	
	return dynamic_gui[playerid][listitem][additional_data_int];
}