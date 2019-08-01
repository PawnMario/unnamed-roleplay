#define CONFIG_FILEPATH "srp/config.ini"
#define LOG_PLAYER "srp/logs/player.log"
#define LOG_VEHICLE "srp/logs/vehicle.log"

native gpci (playerid, serial [], len);
native SendClientCheck(clientid, actionid, arg1= 0x00000000, arg2= 0x0000, bytes= 0x0004); // int32, int8, int32, int16, int16
native PB_RegisterBot(name[]);

#define chrtoupper(%1) \
		(((%1) > 0x60 && (%1) <= 0x7A) ? ((%1) ^ 0x20) : (%1))

#define VC2SA4SAMP_VWORLD 94
new MySQL:mySQLconnection;
new baseurl[] = "https://san-andreas.pl/modele";
new last_radio;

#undef MAX_PLAYERS
#define MAX_PLAYERS 700

#define MAX_SPAWNS 50
new Iterator:GlobalSpawns<MAX_SPAWNS>;

#define MAX_REMOVES 200
new Iterator:RemoveObjects<MAX_REMOVES>;

#define MAX_ROULETTE_FIELDS 50
new Iterator:RouletteFields<MAX_ROULETTE_FIELDS>;

#define MAX_GROUPS 1000
#define MAX_GROUP_WORKERS 50
new Iterator:Groups<MAX_GROUPS>;
new Iterator:DeletedGroups<MAX_GROUPS>;

#undef MAX_OBJECTS
#define MAX_OBJECTS 100000

#define MAX_NPCS	700
new Iterator:Actors<MAX_ACTORS>;
new Iterator:NPCs<MAX_NPCS>;

#define MAX_VISIBLE_OBJECTS	2000

#define MAX_DOORS 950
new Iterator:Doors<MAX_DOORS>;

#define MAX_PLACES 100
new Iterator:Places<MAX_PLACES>;

#define MAX_AREAS 2500
#define MAX_PLAYER_GZ 100
#define PLAYER_GZ_DEFAULT_COLOR 0xFFFFFFAA
new Iterator:Areas<MAX_AREAS>;

#define MAX_GANGWARS 100

new Iterator:GangWars<MAX_GANGWARS>;

#define MAX_VISIBLE_LABELS 200
#define MAX_LABELS 1000
new Iterator:Labels<MAX_LABELS>;

new Iterator:Vehicles<MAX_VEHICLES>;

new Iterator:PlayerSpawns[MAX_PLAYERS]<25>;
new Iterator:PlayerZones[MAX_PLAYERS]<MAX_GANG_ZONES>;

#define MAX_ANIMATIONS	300
new Iterator:Anims<MAX_ANIMATIONS>;

#define MAX_ITEMS	1000
new Iterator:Items<MAX_ITEMS>;

#define MAX_PLAYER_ITEMS 100
new Iterator:PlayerItems[MAX_PLAYERS]<MAX_PLAYER_ITEMS>;

#define MAX_ROBBERIES	20
new Iterator:Robberies<MAX_ROBBERIES>;

#define MAX_FIRE_SOURCES 35
new Iterator:FireSources<MAX_FIRE_SOURCES>;

#define MAX_PRODUCTS 1000
new Iterator:Products<MAX_PRODUCTS>;

#define MAX_RACE_CP  64
new Float:RaceCheckpoint[MAX_RACE_CP][4];

new Iterator:SlotPlayers<MAX_PLAYERS>;

#define MAX_SKINS	300
#define MAX_ACCESS	150

#define FIRE_SPREAD_DELAY	120

#define MAX_CREDIT_VALUE 60000

#define DebugText(%0) for(new i = strlen(%0) - 1; i >= 0; i--)\
if(%0[i] == '%')\
%0[i] = '#'

#define opis  "{adc7e7}{ffffff} "wersja" {adc7e7}: {ffffff}"
#define wersja   "SA:RP"
#define guiopis  "{adc7e7}{ffffff} "wersja" {adc7e7}» {ffffff}"

new WorldTime;
new WorldWeather;
new timer_minutes;

//Statki
new liberty_ship;
new asian_ship;

//Sterowiec
new space_ship;

//Dropy
new drop = -1;
new plane_object, box_object, para_object;

// Aktorzy
new ArmDealer;
new bot_taken;

enum _:E_PLAYER_GZ_DATA
{
	Float:player_GZ_MinX,
	Float:player_GZ_MinY,
	Float:player_GZ_MaxX,
	Float:player_GZ_MaxY,
	player_GZ_Color,
	bool:player_GZ_Used,
	bool:player_GZ_Shown
}

new PlayerGangZoneData[MAX_PLAYERS][MAX_PLAYER_GZ][E_PLAYER_GZ_DATA];

// Enumator produktow

enum eProducts
{
	product_id,
	product_name[40],
	product_type,
	product_price,
	product_owner,
	product_value1,
	product_value2,
	product_model,
	product_extra,
	product_group,
	product_limit,
	product_limit_used,
	product_player
}

new Product[MAX_PRODUCTS][eProducts];

// Enumerator sesji
enum e_session_info
{
	session_id,
	session_start_time,
	session_state
}
new sInfo[MAX_PLAYERS][e_session_info];

// Enumerator ustawien
enum e_settings
{
	setting_mysql_hostname[20],
	setting_mysql_username[20],
	setting_mysql_password[30],
	setting_mysql_database[15],
}
new Setting[e_settings];

// Enumerator konta globalnego
enum e_global_account_info
{
	bool:global_logged,
	bool:global_registered,
	global_id,
	global_bad_pass,
	global_join_time,
	global_name[MAX_PLAYER_NAME+1],
	global_password[80],
	global_ip[20],
	global_premium_time,
	global_game_points,
	global_admin_perm,
	global_ban
}
new gInfo[MAX_PLAYERS][e_global_account_info];


// Enumerator gracza
enum e_players_info
{
	player_id,
	player_name[MAX_PLAYER_NAME+1],
	player_duty_tmp[MAX_PLAYER_NAME+1],
	player_ip[20],
	player_last_veh,
	player_seat,
	player_online_time,
	player_afk_time,
	player_mute_time,
	player_last_join,
	player_last_activity,
	Text3D:player_label,
	Text3D:player_description_label,
	player_description[128],
	player_status[5],
	bool:player_freezed,
	bool:player_admin_duty,
	player_admin_duty_start,
	player_admin_duty_afk_time,

	bool:player_synced,
	player_update_tick,
	player_ammo,
	player_carshare,
	Float:player_velocity[3],
	 
	bool:player_group_list_showed,

	player_hours,
	player_minutes,

	player_drunk,
	
	player_sex,
	player_age,

	Float:player_strength,
	player_capacity,

	player_job,
	player_working,
	player_carry,
	player_cutting_tree,

	player_fishing,
	
	player_job_cash,
	player_last_work,
	Float:player_weapon_skill,
	player_shooting,

	player_documents,
	
	player_taken_damage,
	
	bool:player_phone_call_started,
	player_phone_caller,
	player_phone_receiver,
	player_phone_object_index,
	
	bool:player_looped_anim,
	player_loading_door,
	
	player_bw,
	player_bw_end_time,
	Float:player_health,
	bool:player_health_changed,

	PlayerBar:player_health_bar,

	Float:player_armour,
	bool:player_armour_changed,
	
	player_money,
	player_bank_number,
	player_editor,
	player_bank_money,
	player_last_creator,
	player_last_bullet,
	player_achievements,
	
	Float:player_quit_pos[4],
	player_quit_vw,
	player_quit_int,
	player_quit_time,
	
	player_onduty_afk,
	
	player_flash,
	
	bool:player_logged,
	bool:player_afk,
	bool:player_belt,
	player_spawned,
	player_skin,
	player_last_skin,
	player_spawn,
	player_spawn_type,
	
	player_tog,
	player_last_pm_playerid,
	
	// tworzenie stref
	bool:player_creating_area,
	Float:player_carea_point1[3],
	Float:player_carea_point2[3],
	Text3D:player_carea_label[2],
	player_carea_zone,
	player_lookup_zone,
	player_carea_type,
	Float:player_carea_size,
	player_music_zone,
	
	bool:player_lookup_area,
	
	player_left_area_time,
	
	// anty weapon
	bool:player_modified_weapon,
	
	// czat grup
	player_last_group_slot_chat,
	
	// item proto
	bool:player_items_proto_create,
	player_items_proto_create_id,

	player_gps,
	
	player_held_weapon,
	
	// obiekty
	player_edited_object,
	bool:player_edited_object_no_action,
	Float:player_edited_object_pos[6],
	
	// esel
	player_esel_edited_label,
	player_esel_edited_object,
	
	player_vehicle_target,
	
	player_dialog_tmp1,
	player_dialog_tmp2,
	Float:player_dialog_tmp3,
	player_dialog_tmp4,
	player_dialog_tmp5,
	player_dialog_tmp[64],
	player_info_td_id,

	player_fixprice,
	bool:player_can_spray,

	player_entering_vehicle,
	player_occupied_vehicle,
	player_robbery,
	player_robbery_lobby,
	player_rob_stage,
	player_rob_time,
	player_radio,
	player_active,

	player_panic,

	player_aj,

	// sklep z ciuchami
	bool:player_skin_changing,
	player_skin_id,
	bool:player_access_changing,
	player_access_id,

	//ladunki wybuchowe
	player_bomb_planting,
	player_bomb_car,
	player_bomb,

	player_walking_anim,
	player_walking_lib[16],
	player_walking_name[24],

	// anty cheat 
	player_cheat_warns,
	player_airbrk_warns,
	Float:player_cheat_pos[3],

	// Taxi
	player_taxi_veh,
	player_taxi_pay,
	player_taxi_price,
	player_taxi_passenger,

	// mieszkania
	player_renting,

	player_last_sms,

	//granatnik
	player_howitzer,

	player_area,
	player_polygon,
	player_dealing,

	player_jbl_circle,
	player_jbl_object,

	player_gym_carnet,
	player_gym,
	bool:player_training,
	player_can_train,
	player_gym_count,
	player_gym_object,
	player_supple,

	player_fight_training,
	player_fight_progress,

	player_interview,

	player_flags,

	player_repair_car,
	player_repair_time,

	player_montage_car,
	player_montage_time,
	player_montage_comp,

	player_spraying_car,
	player_spraying_time,
	player_spraying_color,
	player_spraying_color2,
	player_spraying,

	player_spec,

	player_phone_model,

	player_repairing,
	player_tuning,

	player_freeze,

	player_fight_style,

	player_duty_gid,
	Cache:player_cache,

	player_truck,

	player_item_price,

	player_extra_status[32],

	player_event,
	player_tut_step,
	player_arrest,
	player_death,
	player_killer,
	player_demolition,
	player_production,
	player_production_type,
	player_production_object,

	player_planting,
	player_planting_area,
	player_planting_vehicle,
	player_planting_type,
	player_planting_seeds,

	player_race_point,
	player_race_phase,
	player_race_checkpoints,
	player_race_count,

	player_crime_records,

	player_shot_anim,

	player_serial[128],
	player_parachute,
	player_ignore,
	player_last_spray,

	player_bus_stop,
	player_bus_object,
	player_bus_destination,
	player_bus_time,
	player_bus_zone[MAX_ZONE_NAME],
	player_bus_destzone[MAX_ZONE_NAME],
	player_bus_price,
	player_bus_ride,
	player_last_bus,

	player_y_flood,
	player_custom_edit,
	player_door_text,
	player_session,
	player_screenshot,
	player_widescreen,

	player_roulette_object,
	player_roulette_selector,
	player_roulette_field,
	player_roulette_bet,
	player_roulette_timer,
	player_roulette_owner,
	
	player_commands,
	player_smuggle,
	player_smuggle_cp,

	player_vattach_object,
	player_vattach_vehicle,
	player_checkpoint,
	player_gta_tick,
	player_gta_hits,

	player_slot_machine,
	player_slot_spin,

	player_sobfox_time,
	player_sobfox_warns,
	player_last_tab,

	player_radio_channel
}
new pInfo[MAX_PLAYERS][e_players_info];

// Enumerator spawnow gracza
enum e_player_spawns
{
	spawn_uid,
	spawn_door,
	spawn_perm
}
new pSpawn[MAX_PLAYERS][25][e_player_spawns];

// Enumerator grupy gracza
enum e_player_groups
{
	pg_id,
	pg_rank_title[32],
	pg_rank_skin,
	pg_rank_payment,
	pg_rank_perm,
	pg_duty_start,
	pg_duty_time,
	pg_payday_count,
	bool:pg_duty
}
new pGroup[MAX_PLAYERS][5][e_player_groups];

// Enumerator ostatnich obrazen
enum e_player_injuries
{
	injury_id,
	injury_damage,
	injury_bodypart,
	injury_weapon,
	injury_time
}
new pInjury[MAX_PLAYERS][10][e_player_injuries];

// Enumerator napadow
enum e_robberies
{
	robbery_uid,
	robbery_place,
	robbery_name[60],
	robbery_requirements,
	robbery_level,
	robbery_timestamp,
	robbery_actors_state,
	robbery_notification,
	robbery_actors,
	robbery_aimed_actors
}
new Robbery[MAX_ROBBERIES][e_robberies];

// Enumerator aktorow
enum e_actors
{
	actor_uid,
	actor_skin,
	Float:actor_pos[4],
	actor_type,
	actor_animation,
	actor_action,
	actor_vw,
	actor_aimed,
	actor_damaged,
	actor_owner,
	Text3D:actor_label
}
new Actor[MAX_ACTORS][e_actors];

// Enumerator NPC
enum e_npcs
{
	npc_uid,
	npc_skin,
	Float:npc_pos[4],
	npc_type,
	npc_weapon,
	npc_vw,
	npc_aimed,
	npc_area,
	npc_owner
}
new NPC[MAX_NPCS][e_npcs];


// Enumerator globalnych spawnow
enum e_global_spawns
{
	gspawn_id,
	Float:gspawn_pos[4],
	gspawn_type
}
new GlobalSpawn[MAX_SPAWNS][e_global_spawns];

// Enumerator od usuwania obiektow
enum e_remove_objects
{
	remove_uid,
	Float:remove_pos[4],
	remove_model
}
new RemoveObject[MAX_REMOVES][e_remove_objects];

// Enumerator grup
enum e_groups
{
	group_uid,
	group_parent_uid,
	group_type,
	group_flags,
	group_color[12],
	group_product,
	group_name[64],
	group_tag[15],
	group_bank_money,
	group_capital,
	group_tribute,
	group_last_tribute,
	group_tributers,
	bool:group_chat,
	group_radio_text[128],
	group_radio_sender[MAX_PLAYER_NAME+1],
	group_activity_points,
	group_advert_time,
	group_news_type,
	group_temp,
	group_level,
	group_last_tax,
	group_creator,
	group_sms_number,
	group_sms_cost,
	group_last_smuggle,
	group_last_take,
	group_bonus
}
new Group[MAX_GROUPS][e_groups];

// Enumerator obiektów
enum e_objects
{
	object_uid,
	object_model,
	object_type,
	object_owner_type,
	object_owner,
	object_vw,
	Float:object_pos[6],
	Float:object_stream_distance,
	Float:object_gate_pos[6],
	object_gate,
	Text3D:object_label,
	
	bool:object_is_edited,
	bool:object_can_be_used,

	object_gate_opened,
	object_date,
	object_area,
	object_textured,
	object_logs,
	object_robbed
}
new Object[MAX_OBJECTS][e_objects];

//Enumator sklepow
enum e_places
{
	place_uid,
	Float:place_pos[3],
	place_type,
	place_world
}
new Place[MAX_PLACES][e_places];

//Enumator pickupow stalych
enum e_pickups
{
	pickup_type,
	pickup_extra[2]
}
new Pickup[MAX_DOORS][e_pickups];

// Enumerator drzwi
enum e_doors
{
	door_uid,
	door_type,
	door_owner_type,
	door_owner,
	door_name[40],
	door_audio[100],
	bool:door_closed,
	
	bool:door_auto_closing,
	bool:door_car_crosing,
	
	door_payment,
	door_price,

	Float:door_pos[4],
	door_vw,
	door_int,
	
	Float:door_spawn_pos[4],
	door_spawn_vw,
	door_spawn_int,
	door_objects_limit,
	
	door_rentable,
	door_rent,

	door_map_icon,

	door_time,
	door_access,
	door_destroyed,
	door_demolition,
	Float:door_size_points[3],
	door_burned,
	door_loaded,
	door_load_tick
}
new Door[MAX_DOORS][e_doors];

// Enumatory pozarow
enum e_fires
{
	bool:fire_is_burning,
	fire_map_icon
}
new Fire[e_fires];

enum e_fire_sources
{
	fs_start_time,
	Float:fs_health,
	Text3D:fs_label,
	Float:fs_pos[3],
	fs_object,
	fs_door
}
new FireSource[MAX_FIRE_SOURCES][e_fire_sources];

// Enumerator stref
enum e_areas
{
	area_uid,
	area_type,
	area_owner_type,
	area_owner,
	area_objects_limit,
	area_audio[100],
	
	area_last_info,
	area_price,
	area_flags,
	area_color,
	area_gzone,
	bool:area_visible,
	area_attacked
}
new Area[MAX_AREAS][e_areas];

// Enumerator walk o strefy
enum e_gangwars
{
	war_attacker,
	war_defender,
	war_area,
	war_start,
	war_end,
	war_def_points,
	war_attack_points,
	war_def_gid,
	war_at_gid
}
new GangWar[MAX_GANGWARS][e_gangwars];

// Enumerator labeli
enum e_labels
{
	label_uid,
	label_owner,
	label_owner_type,
	label_color,
	label_vw,
	Float:label_draw,
	Float:label_pos[3]
}
new Label[Text3D:MAX_LABELS][e_labels];

// Enumerator pojazdow
enum e_vehicles
{
	vehicle_uid,
	vehicle_model,
	vehicle_owner_type,
	vehicle_owner,
	vehicle_color[2],
	vehicle_paintjob,
	Float:vehicle_park[4],
	vehicle_park_world,
	vehicle_park_interior,
	Text3D:vehicle_description,
	vehicle_has_description,
	Float:vehicle_health,
	bool:vehicle_destroyed,
	Float:vehicle_mileage,
	vehicle_driver,
	vehicle_interior,
	vehicle_register[10],
	vehicle_registered,
	vehicle_occupants,
	vehicle_streaming,
	vehicle_stream[128],
	bool:vehicle_locked,
	bool:vehicle_damaged,
	vehicle_last_used,
	
	Float:vehicle_last_pos[3],
	vehicle_log_object[10],
	vehicle_fish_object,
	vehicle_trash,
	
	vehicle_last_fuel_td,
	
	// Zniszczenia wizualne
	vehicle_damage[4],
	
	vehicle_map_icon,
	
	// Wypadki
	Float:vehicle_last_vector_length,
	
	// Paliwo
	vehicle_fuel_type,
	Float:vehicle_fuel_current,
	vehicle_fuel_max,
	
	// Accessories
	vehicle_accessories,
	
	// Status
	vehicle_state,
	vehicle_state_time,
	vehicle_state_end,
	Text3D:vehicle_state_label,
	
	bool:vehicle_engine,
	bool:vehicle_engine_starting,
	bool:vehicle_lights,
	bool:vehicle_siren,
	bool:vehicle_boot,
	bool:vehicle_bonnet,

	bool:vehicle_win_driver,
	bool:vehicle_win_pp,
	bool:vehicle_win_lt,
	bool:vehicle_win_pt,

	// blokada na kolo 

	vehicle_blocked,
	vehicle_block_reason[32],

	// Tuning
	vehicle_component[14],

	vehicle_siren_object,
	vehicle_elm,

	Text3D:vehicle_sign,
	vehicle_has_sign,
	vehicle_listen
}
new Vehicle[MAX_VEHICLES][e_vehicles];

#define ROULETTE_FLAG_RED 		1
#define ROULETTE_FLAG_BLACK		2
#define ROULETTE_FLAG_EVEN		4
#define ROULETTE_FLAG_ODD		8
#define ROULETTE_FLAG_1ST12		16
#define ROULETTE_FLAG_2ND12		32
#define ROULETTE_FLAG_3RD12		64
#define ROULETTE_FLAG_1TO18		128
#define ROULETTE_FLAG_19TO36	256

#define ROULETTE_COLOR_GREEN	1
#define ROULETTE_COLOR_RED		2
#define ROULETTE_COLOR_BLACK	3

enum e_factorydata
{
    FactoryName[64],
	Float: FactoryX,
	Float: FactoryY,
	Float: FactoryZ,
	FactoryCurrent,
	FactoryCP,
	Text3D: FactoryLabel
}

new FactoryData[][e_factorydata] = 
{
    {"Los Santos", 2081.2795,-2026.8479,13.5589},
	{"Las Venturas", 981.711303, 2168.738769, 10.820312},
	{"San Fierro", -1044.592895, -606.348876, 32.007812}
};

new FactoryIcons[MAX_PLAYERS][sizeof(FactoryData)];

enum pAirDropPoints
{
	Float:airX,
	Float:airY,
	Float:airZ,
}
new AirDropPoints[6][pAirDropPoints] =
{
	{3412.6584,-1785.6873,2.0089},
	{3129.7378,-566.1061,2.0089},
	{3282.8582,-2661.3982,2.0089},
	{420.6215,-2511.5723,0.4533},
	{246.4110,373.7864,0.5148},
	{3063.4751,994.9214,1.5023}
};

enum bodReels
{
	PlayerText:symbol_textdraw,
	symbol_model[32],
	Float:symbol_pos[2]
}
new BodSymbols[MAX_PLAYERS][15][bodReels];

enum rulFields
{
	field_id,
	field_number,
	field_name[32],
	Float:field_x,
	Float:field_y,
	field_flag,
	field_multiplier
}
new RouletteField[][rulFields] =
{
	{1, -1, "1 do 18", -0.36, -0.66, ROULETTE_FLAG_1TO18, 2},
	{2, -1, "Parzyste", -0.07, -0.66, ROULETTE_FLAG_EVEN, 2},
	{3, -1, "Czerwone", 0.25, -0.66, ROULETTE_FLAG_RED, 2},
	{4, -1, "Czarne", 0.57, -0.66, ROULETTE_FLAG_BLACK, 2},
	{5, -1, "Nieparzyste", 0.84, -0.66, ROULETTE_FLAG_ODD, 2},
	{6, -1, "19 do 36", 1.06, -0.66, ROULETTE_FLAG_19TO36, 2},
	{7, -1, "1st 12", -0.22, -0.41, ROULETTE_FLAG_1ST12, 3},
	{8, -1, "2nd 12", 0.38, -0.41, ROULETTE_FLAG_2ND12, 3},
	{9, -1, "3rd 12", 1.03, -0.41, ROULETTE_FLAG_3RD12, 3},
	{10, 0, "Zero", -0.60, 0.07, 0, 35},
	{11, 1, "Jeden", -0.45, -0.17, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_RED+ROULETTE_FLAG_ODD, 35},
	{12, 2, "Dwa", -0.45, 0.09, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_EVEN, 35},
	{13, 3, "Trzy", 0.45, 0.31, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_RED+ROULETTE_FLAG_ODD, 35},
	{14, 4, "Cztery", 0.23, -0.16, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_EVEN, 35},
	{15, 5, "Piec", 0.28, 0.07, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_RED+ROULETTE_FLAG_ODD, 35},
	{16, 6, "Szesc", 0.28, 0.27, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_EVEN, 35},
	{17, 7, "Siedem", 0.15, -0.14, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_RED+ROULETTE_FLAG_ODD, 35},
	{18, 8, "Osiem", 0.14, 0.05, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_EVEN, 35},
	{19, 9, "Dziewiec", 0.12, 0.32, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_RED+ROULETTE_FLAG_ODD, 35},
	{20, 10, "Dziesiec", -0.01, -0.16, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_EVEN, 35},
	{21, 11, "Jedenascie", -0.03, 0.02, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_ODD, 35},
	{22, 12, "Dwanascie", -0.01, 0.34, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_1ST12+ROULETTE_FLAG_RED+ROULETTE_FLAG_EVEN, 35},
	{23, 13, "Trzynascie", 0.83, -0.18, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_ODD, 35},
	{24, 14, "Czternascie", 0.82, 0.06, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_RED+ROULETTE_FLAG_EVEN, 35},
	{25, 15, "Pietnascie", 0.83, 0.33, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_ODD, 35},
	{26, 16, "Szesnascie", 0.68, -0.18, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_RED+ROULETTE_FLAG_EVEN, 35},
	{27, 17, "Siedemnascie", 0.68, 0.09, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_ODD, 35},
	{28, 18, "Osiemnascie", 0.71, 0.30, ROULETTE_FLAG_1TO18+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_RED+ROULETTE_FLAG_EVEN, 35},
	{29, 19, "Dziewietnascie", 0.53, -0.15, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_RED+ROULETTE_FLAG_ODD, 35},
	{30, 20, "Dwadziescia", 0.55, 0.08, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_EVEN, 35},
	{31, 21, "Dwadziescia jeden", 0.53, 0.31, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_RED+ROULETTE_FLAG_ODD, 35},
	{32, 22, "Dwadziescia dwa", 0.39, -0.16, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_EVEN, 35},
	{33, 23, "Dwadziescia trzy", 0.38, 0.06, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_RED+ROULETTE_FLAG_ODD, 35},
	{34, 24, "Dwadziescia cztery", 0.38, 0.33, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_2ND12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_EVEN, 35},
	{35, 25, "Dwadziescia piec", 0.22, -0.16, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_RED+ROULETTE_FLAG_ODD, 35},
	{36, 26, "Dwadziescia szesc", 0.23, 0.07, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_EVEN, 35},
	{37, 27, "Dwadziescia siedem", 0.22, 0.31, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_RED+ROULETTE_FLAG_ODD, 35},
	{38, 28, "Dwadziescia osiem", 0.06, -0.16, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_EVEN, 35},
	{39, 29, "Dwadziescia dziewiec",0.07, 0.08, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_ODD, 35},
	{40, 30, "Trzydziesci", 0.07, 0.33, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_RED+ROULETTE_FLAG_EVEN, 35},
	{41, 31, "Trzydziesci jeden", 0.90, -0.17, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_ODD, 35},
	{42, 32, "Trzydziesci dwa", 0.91, 0.06, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_RED+ROULETTE_FLAG_EVEN, 35},
	{43, 33, "Trzydziesci trzy", -0.07, 0.31, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_ODD, 35},
	{44, 34, "Trzydziesci cztery", 0.75, -0.17, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_RED+ROULETTE_FLAG_EVEN, 35},
	{45, 35, "Trzydziesci piec", 0.74, 0.08, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_BLACK+ROULETTE_FLAG_ODD, 35},
	{46, 36, "Trzydziesci szesc", 0.75, 0.30, ROULETTE_FLAG_19TO36+ROULETTE_FLAG_3RD12+ROULETTE_FLAG_RED+ROULETTE_FLAG_EVEN, 35}
};

enum vehAttach
{
	_vehModel,
	Float:_attPos
}
 
/*new attInfo[212][vehAttach] =
{
	{400, 0.85},
	{401, 0.8},
	{402, 0.79},
	{403, 2.15},
	{404, -1.0},
	{405, 0.73},
	{406, -1.0},
	{407, -1.0},
	{408, -1.0},
	{409, 0.8},
	{410, 0.899999},
	{411, 0.699999},
	{412, 0.699999},
	{413, 1.149999},
	{414, 2.4},
	{415, 0.61},
	{416, -1.0},
	{417, -1.0},
	{418, 1.1},
	{419, 0.699999},
	{420, -1.0},
	{421, 0.699999},
	{422, -1.0},
	{423, -1.0},
	{424, -1.0},
	{425, -1.0},
	{426, 0.85},
	{427, -1.0},
	{428, 1.6},
	{429, -1.0},
	{430, -1.0},
	{431, -1.0},
	{432, -1.0},
	{433, -1.0},
	{434, 0.8},
	{435, -1.0},
	{436, 0.8},
	{437, -1.0},
	{438, -1.0},
	{439, -1.0},
	{440, 1.269999},
	{441, -1.0},
	{442, 0.92},
	{443, -1.0},
	{444, -1.0},
	{445, 0.86},
	{446, -1.0},
	{447, -1.0},
	{448, -1.0},
	{449, -1.0},
	{450, -1.0},
	{451, 0.569999},
	{452, -1.0},
	{453, -1.0},
	{454, -1.0},
	{455, -1.0},
	{456, -1.0},
	{457, -1.0},
	{458, 0.759999},
	{459, -1.0},
	{460, -1.0},
	{461, -1.0},
	{462, -1.0},
	{463, -1.0},
	{464, -1.0},
	{465, -1.0},
	{466, 0.86},
	{467, 0.86},
	{468, -1.0},
	{469, -1.0},
	{470, 1.1},
	{471, -1.0},
	{472, -1.0},
	{473, -1.0},
	{474, 0.839999},
	{475, 0.699999},
	{476, -1.0},
	{477, 0.699999},
	{478, -1.0},
	{479, 1.0},
	{480, -1.0},
	{481, -1.0},
	{482, 1.0},
	{483, 1.049999},
	{484, -1.0},
	{485, -1.0},
	{486, -1.0},
	{487, -1.0},
	{488, -1.0},
	{489, 1.1},
	{490, -1.0},
	{491, 0.699999},
	{492, 0.87},
	{493, -1.0},
	{494, 0.74},
	{495, 1.039999},
	{496, 0.839999},
	{497, -1.0},
	{498, -1.0},
	{499, -1.0},
	{500, 1.0},
	{501, -1.0},
	{502, -1.0},
	{503, -1.0},
	{504, 0.899999},
	{505, -1.0},
	{506, -1.0},
	{507, 0.81},
	{508, -1.0},
	{509, -1.0},
	{510, -1.0},
	{511, -1.0},
	{512, -1.0},
	{513, -1.0},
	{514, 1.549999},
	{515, 1.47},
	{516, 0.86},
	{517, 0.86},
	{518, 0.699999},
	{519, -1.0},
	{520, -1.0},
	{521, -1.0},
	{522, -1.0},
	{523, -1.0},
	{524, -1.0},
	{525, -1.0},
	{526, 0.68},
	{527, 0.85},
	{528, 1.1},
	{529, 0.92},
	{530, -1.0},
	{531, -1.0},
	{532, -1.0},
	{533, -1.0},
	{534, 0.649999},
	{535, -1.0},
	{536, -1.0},
	{537, -1.0},
	{538, -1.0},
	{539, -1.0},
	{540, 0.73},
	{541, 0.639999},
	{542, 0.85},
	{543, -1.0},
	{544, -1.0},
	{545, 0.769999},
	{546, 0.85},
	{547, 0.899999},
	{548, -1.0},
	{549, 0.709999},
	{550, 0.74},
	{551, 0.899999},
	{552, -1.0},
	{553, -1.0},
	{554, -1.0},
	{555, -1.0},
	{556, -1.0},
	{557, -1.0},
	{558, 0.87},
	{559, 0.759999},
	{560, 0.87},
	{561, 0.87},
	{562, 0.8},
	{563, -1.0},
	{564, -1.0},
	{565, 0.699999},
	{566, 0.85},
	{567, -1.0},
	{568, -1.0},
	{569, -1.0},
	{570, -1.0},
	{571, -1.0},
	{572, -1.0},
	{573, -1.0},
	{574, -1.0},
	{575, -1.0},
	{576, 0.899999},
	{577, -1.0},
	{578, -1.0},
	{579, 1.24},
	{580, 1.059999},
	{581, -1.0},
	{582, -1.0},
	{583, -1.0},
	{584, -1.0},
	{585, 1.0},
	{586, -1.0},
	{587, 0.73},
	{588, -1.0},
	{589, 1.1},
	{590, -1.0},
	{591, -1.0},
	{592, -1.0},
	{593, -1.0},
	{594, -1.0},
	{595, -1.0},
	{596, -1.0},
	{597, -1.0},
	{598, -1.0},
	{599, -1.0},
	{600, -1.0},
	{601, -1.0},
	{602, 0.709999},
	{603, 0.68},
	{604, -1.0},
	{605, -1.0},
	{606, -1.0},
	{607, -1.0},
	{608, -1.0},
	{609, -1.0},
	{610, -1.0},
	{611, -1.0}
};*/

//Enumerator przedmiotow
enum e_items
{
	// Basic data
	item_uid,
	item_name[40],
	item_type,
	item_value1,
	item_value2,
	item_used,
	item_created,
	
	// Owner data
	item_owner_type,
	item_owner,
	item_group,
	
	// Storage data
	item_price,
	item_count,
	
	// Ground data
	item_object,
	item_model,
	Float:item_x,
	Float:item_y,
	Float:item_z,
	Float:item_rx,
	Float:item_ry,
	Float:item_rz,
	item_world,
	item_interior,

	item_extraid,
	item_weight
}
new Item[MAX_ITEMS][e_items];

enum e_player_items
{
	player_item_uid,
	player_item_name[40],
	player_item_type,
	player_item_value1,
	player_item_value2,
	player_item_used,
	player_item_created,
	player_item_extraid,
	player_item_weight,
	player_item_model,
	Float:player_item_condition,
	player_item_group
}
new PlayerItem[MAX_PLAYERS][MAX_PLAYER_ITEMS][e_player_items];

//Enumerator broni gracza
enum e_player_weapons
{
	pw_itemid,
	pw_id,
	pw_ammo,
	pw_object_index
}
new pWeapon[MAX_PLAYERS][13][e_player_weapons];

enum attached_object_data
{
	ao_model,
	ao_bone,
	Float:ao_x,
	Float:ao_y,
	Float:ao_z,
	Float:ao_rx,
	Float:ao_ry,
	Float:ao_rz,
	Float:ao_sx,
	Float:ao_sy,
	Float:ao_sz,
	bool:ao_inserted
}

new ao[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][attached_object_data];

enum e_player_offer
{
	offer_sellerid,
	offer_buyerid,
	offer_type,
	bool:offer_accepted,
	offer_price,
	offer_extraid,
	offer_start
}
new pOffer[MAX_PLAYERS][e_player_offer];

enum e_player_global
{
	glo_id,
	glo_name[MAX_PLAYER_NAME],
	glo_score,
	glo_ban,
	glo_perm,
	glo_premium,
	glo_bad_pass,
	glo_block
}
new pGlobal[MAX_PLAYERS][e_player_global];

//Sklep z ciuchami
enum e_skins 
{
	skin_uid,
	skin_model,
	skin_price,
	skin_name[32]
}
new ClothSkin[MAX_SKINS][e_skins];

enum e_access 
{
	access_uid,
	access_model,
	access_price,
	Float:access_pos[6],
	access_name[40],
	access_bone,
	access_category
}
new ClothAccess[MAX_ACCESS][e_access];

new connect_timer[MAX_PLAYERS];

new job_pickup;
new gov_pickup;

new MessageString[128];

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_RED 0xAA3333AA
#define COLOR_DARK_RED 0xB00000FF
#define COLOR_LIGHTER_RED 0xFF3C3CFF
#define COLOR_LIGHTER_GREEN 0xD6EE76FF
#define COLOR_GREEN 0x33AA33FF
#define COLOR_GOLD 0xFCAD43FF
#define COLOR_LIGHT_PURPLE 0x9B91ECFF
#define COLOR_PINK  0xB58ADAFF
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_SAMP 0xA9C4E4FF
#define COLOR_TURQUE 0x00E7EBFF
#define COLOR_YELLOW 0xFFE229FF
#define COLOR_LIGHTER_ORANGE 0xFF8C55FF
#define COLOR_CAR_STATE 0x29A6D6FF
#define COLOR_GUI_BLUE	"{ADC7E7}"

#define SendFormattedClientMessage(%0,%1,%2,%3) (format(MessageString, sizeof(MessageString), %2, %3), SendClientMessage(%0, %1, MessageString))
			   
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define HOLDING(%0) ((newkeys & (%0)) == (%0))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define strtoupper(%0) for(new l = strlen(%0) - 1; l >= 0; l--) %0[l] = toupper(%0[l])

stock _PutPlayerInVehicle(playerid, vehicleid, seat)
{
	pInfo[playerid][player_entering_vehicle] = vehicleid;
	PutPlayerInVehicle(playerid, vehicleid, seat);
}

#define PutPlayerInVehicle(%0,%1,%2) _PutPlayerInVehicle(%0,%1,%2)

stock _SetVehicleHealth(vehicleid, Float:health)
{
	Vehicle[vehicleid][vehicle_health] = health;
	SetVehicleHealth(vehicleid, health);
}
#define SetVehicleHealth(%0,%1) _SetVehicleHealth(%0,%1)

stock _LinkVehicleToInterior(vehicleid, interior)
{
	Vehicle[vehicleid][vehicle_interior] = interior;
	LinkVehicleToInterior(vehicleid, interior);
}
#define LinkVehicleToInterior(%0,%1) _LinkVehicleToInterior(%0,%1)

stock _SetVehiclePos(vehicleid, Float:x, Float:y, Float:z)
{
	SetVehiclePos(vehicleid, x, y, z+1.0);
	SetVehicleVelocity(vehicleid, 0, 0, -1.0);
}
#define SetVehiclePos(%0,%1,%2,%3) _SetVehiclePos(%0,%1,%2,%3)


stock GetPlayerWeaponAmmo(playerid,weaponid)
{
	new wd[2][13];
	for(new i; i<13; i++) GetPlayerWeaponData(playerid,i,wd[0][i],wd[1][i]);
	for(new i; i<13; i++)
	{
		
		if(weaponid == wd[0][i]) return wd[1][i];
	}
	return 0;
}
stock SetPlayerMoney(playerid, money)
{
	pInfo[playerid][player_money] = money;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, pInfo[playerid][player_money]);
}
stock RP_PLUS_SetPlayerPos(playerid, Float:xx, Float:yy, Float:zz)
{
	SetPlayerPos(playerid, xx,yy,zz);
	GetPlayerPos(playerid, pInfo[playerid][player_cheat_pos][0] , pInfo[playerid][player_cheat_pos][1], pInfo[playerid][player_cheat_pos][2]);
	return 1;
}
stock _GivePlayerMoney(playerid, money)
{
	pInfo[playerid][player_money] += money;
	GivePlayerMoney(playerid, pInfo[playerid][player_money] - GetPlayerMoney(playerid));
	
	mysql_query(mySQLconnection, sprintf("UPDATE `ipb_characters` SET `char_cash` = %d WHERE `char_uid` = %d", pInfo[playerid][player_money], pInfo[playerid][player_id]));
}
#define GivePlayerMoney(%0,%1) _GivePlayerMoney(%0,%1)

stock _SetPlayerSkin(playerid, skinid)
{
	if(!IsValidSkin(skinid)) skinid = 1;
	SetPlayerSkin(playerid, skinid);
}
#define SetPlayerSkin(%0,%1) _SetPlayerSkin(%0,%1)

/*stock _SetPlayerVirtualWorld(playerid, vw)
{
	OnPlayerVirtualWorldChange(playerid, vw);
	SetPlayerVirtualWorld(playerid, vw);
}
#define SetPlayerVirtualWorld(%0,%1) _SetPlayerVirtualWorld(%0, %1)*/

/*stock _SetPlayerHealth(playerid, health)
{
	pInfo[playerid][player_health_changed] = true;
	pInfo[playerid][player_health] = float(health);
	SetPlayerHealth(playerid, 9999);

	if(float(health) > 60.0 && float(health) <= 100.0)
	{
		SetPlayerProgressBarColour(playerid, pInfo[playerid][player_health_bar], COLOR_GREEN);
	}

	if(float(health) > 20.0 && float(health) <= 60.0)
	{
		SetPlayerProgressBarColour(playerid, pInfo[playerid][player_health_bar], COLOR_LIGHTER_ORANGE);
	}

	if(float(health) <= 20.0)
	{
		SetPlayerProgressBarColour(playerid, pInfo[playerid][player_health_bar], 0xFF1C1CFF);
	}

	SetPlayerProgressBarValue(playerid, pInfo[playerid][player_health_bar], pInfo[playerid][player_health]);
}
#define SetPlayerHealth(%0,%1) _SetPlayerHealth(%0, %1)*/

/*stock _SetPlayerArmour(playerid, armour)
{
	pInfo[playerid][player_armour_changed] = true;
	pInfo[playerid][player_armour] = float(armour);
	SetPlayerArmour(playerid, floatround(pInfo[playerid][player_armour]));
}
#define SetPlayerArmour(%0,%1) _SetPlayerArmour(%0, %1)

stock _TogglePlayerControllable(playerid, toggle)
{
	pInfo[playerid][player_freezed] = !toggle;
	TogglePlayerControllable(playerid, toggle);
}
#define TogglePlayerControllable(%0,%1) _TogglePlayerControllable(%0, %1)*/

stock extended_SendClientMessage(playerid, color, message[], length = sizeof message)
{	
	if( strlen(message) > 134 ) //144
	{
		new last_whitespace = -1, line[100];
		for(new i;i < strlen(message); i++)
		{
			if( i > 60 && message[i] == ' ' ) last_whitespace = i;
			
			if( i > 80 )
			{
				new colored;
				if( last_whitespace == -1 ) strmid(line, message, 0, 80);
				else strmid(line, message, 0, last_whitespace);
				
				SendClientMessage(playerid, color, sprintf("%s ...", line));

				if( strfind(line, "{B58ADA}", true) != -1 && strfind(line, "{E6E6E6}", true) == -1 ) colored = 1;
				
				if( last_whitespace == -1 ) strmid(line, message, 80, length);
				else strmid(line, message, last_whitespace, length);
				
				if( colored)
				{
					SendClientMessage(playerid, 0xB58ADAFF, sprintf("... %s", line));
				}
				else
				{
					SendClientMessage(playerid, color, sprintf("... %s", line));
				}
				
				break;
			}			
		}
	}
	else SendClientMessage(playerid, color, message);

	return 1;
}
#define SendClientMessage(%0,%1,%2) extended_SendClientMessage(%0,%1,%2)

#define HasCrewFlag(%0,%1) ((pGlobal[%0][glo_perm] & (%1)) == (%1))
#define GroupHasFlag(%0,%1) ((Group[%0][group_flags] & (%1)) == (%1))
#define DoorHasAccess(%0,%1) ((Door[%0][door_access] & (%1)) == (%1))
#define AreaHasFlag(%0,%1) ((Area[%0][area_flags] & (%1)) == (%1))
#define WorkerHasFlag(%0,%1,%2) ((pGroup[%0][%1][pg_rank_perm] & (%2)) == (%2))
#define PlayerHasTog(%0,%1) ((pInfo[%0][player_tog] & (%1)) == (%1))
#define VehicleHasAccessory(%0,%1) ((Vehicle[%0][vehicle_accessories] & (%1)) == (%1))
#define PlayerHasDocument(%0,%1) ((pInfo[%0][player_documents] & (%1)) == (%1))
#define PlayerHasFlag(%0,%1) ((pInfo[%0][player_flags] & (%1)) == (%1))
#define PlayerHasAchievement(%0,%1) ((pInfo[%0][player_achievements] & (%1)) == (%1))
#define RobberyHasRequirement(%0,%1) ((Robbery[%0][robbery_requirements] & (%1)) == (%1))

new Text:Dashboard[MAX_PLAYERS];
new Text:DashBoardPane[MAX_PLAYERS];
new Text:DashBoardPane2[MAX_PLAYERS];
new Text:DoorInfo[MAX_PLAYERS];
new Text:TextDrawScreenShot;
new Text:BodBackground;

new Text:Tutorial[MAX_PLAYERS];

new Text:vehicleInfo;
new Text:GroupsListStaticHeader;
new Text:TextPenalty;
new Text:Textdraw2;

new PlayerText:TextDrawSanNews[MAX_PLAYERS];
new PlayerText:GroupsListStaticButtons[MAX_PLAYERS][5][5];
new PlayerText:GroupsListRow[MAX_PLAYERS][5];
new PlayerText:GroupDutyTag[MAX_PLAYERS];
new PlayerText:ZoneName[MAX_PLAYERS];
new PlayerText:WhiteScreen[MAX_PLAYERS];

new PlayerText:BodCoinsBank[MAX_PLAYERS];
new PlayerText:BodCoinValue[MAX_PLAYERS];
new PlayerText:BodWin[MAX_PLAYERS];
new PlayerText:BodCoinsWager[MAX_PLAYERS];
new PlayerText:BodBet[MAX_PLAYERS];

new Text:Serverlogo;
new Text:RouletteRed;
new Text:RouletteBlack;
new Text:RouletteGreen;

new PlayerText:RouletteNumber[MAX_PLAYERS];

new amount_players_in_door[MAX_PLAYERS];

//Osiagniecia
#define ACHIEV_NOOB		1
#define ACHIEV_50H		2
#define ACHIEV_500H 	4
#define ACHIEV_1000H 	8
#define ACHIEV_LEADER	16
#define ACHIEV_BLEADER	32
#define ACHIEV_CAREER	64
#define ACHIEV_RICH		128
#define ACHIEV_CARS		256
#define ACHIEV_BILLION	512
#define ACHIEV_WORKER	1024
#define ACHIEV_DRIVER	2048
#define ACHIEV_RACE		4096
#define ACHIEV_FIRSTCAR 8192
#define ACHIEV_STRONG   16384
#define ACHIEV_GYM      32768
#define ACHIEV_ADDICT	65536
#define ACHIEV_ITEM		131072
#define ACHIEV_ROBBER	262144
#define ACHIEV_BANDIT	524288

//Typy kar
#define PUNISH_KICK         0
#define PUNISH_BAN 			1
#define PUNISH_AJ         	2
#define PUNISH_BLOCK   		3
#define PUNISH_WARN         4
#define PUNISH_GAME_SCORE	5
#define PUNISH_BLOCK_VEH	6
#define PUNISH_BLOCK_RUN	7
#define PUNISH_BLOCK_OOC	8
#define PUNISH_BLOCK_DMG	9

#define BLOCK_BAN	1
#define BLOCK_OOC   2
#define BLOCK_RUN   4
#define BLOCK_DMG   8
#define BLOCK_VEH   16

//Obiekty uzywalne
#define OBJECT_ATM 2942
#define OBJECT_CRACK 2144
#define OBJECT_PETROL 3465
#define OBJECT_DUMB	2915
#define OBJECT_TREE 657
#define OBJECT_FISH 19630
#define OBJECT_PUNCHBAG -2098
#define OBJECT_BUSSTOP	1257
#define OBJECT_OPEN_SAFE 19618
#define OBJECT_SAFE_DOOR 19619
#define OBJECT_CASH_REG 2941
#define OBJECT_ROB_DOORS -2045
#define OBJECT_ROULETTE_TABLE 1978
#define OBJECT_LAB -2027
#define OBJECT_PHONEBOOTH 1216
#define OBJECT_JBL	-2043
#define OBJECT_BANK_VAULT -20411
#define OBJECT_TYPE_ROB_CASH 1550
#define OBJECT_FORKLIFT_BOX 1558
#define OBJECT_CONTAINER	2975
#define OBJECT_DICE_TABLE	1824

//Aktorzy
#define ACTOR_TYPE_PED	0
#define ACTOR_TYPE_FISHER 1
#define ACTOR_TYPE_LUMBERJACK 2
#define ACTOR_TYPE_ARMDEALER 3
#define ACTOR_TYPE_ROBBERY	4

//Typy produkcji
#define PRODUCTION_TYPE_METH	1
#define PRODUCTION_TYPE_AMPH	2
#define PRODUCTION_TYPE_CRACK	3

//Napady - wymagania
#define REQUIREMENT_GUN		1
#define REQUIREMENT_SQUAD	2
#define REQUIREMENT_CAR		4
#define REQUIREMENT_TOOLS	8
#define REQUIREMENT_BOMB	16
#define REQUIREMENT_BIGSQUAD 32

//Napady - poziomy trudnosci
#define ROBBERY_LEVEL_EASY		1
#define ROBBERY_LEVEL_MEDIUM 	2
#define ROBBERY_LEVEL_HARD		3
#define ROBBERY_LEVEL_HARDCORE	4

//Napady - stany aktorow
#define ACTOR_STATE_ALIVE		1
#define ACTOR_STATE_SCARED		2
#define ACTOR_STATE_DEAD		3

//Kredyty
#define CREDIT_TYPE_PROPERTY	1
#define CREDIT_TYPE_VEHICLE		2

//Napady - stage rabowania
#define STAGE_CRACKING	1
#define STAGE_OPENING	2
#define STAGE_ROBBING	3
#define STAGE_DOOR		4
#define STAGE_PLANTING	5
#define STAGE_CASH_REG	6

//Blokady
#define OBJECT_BLOCKADE1 19834
#define OBJECT_BLOCKADE2 1949
#define OBJECT_BLOCKADE3 1427
#define OBJECT_BLOCKADE4 1424
#define OBJECT_BLOCKADE5 1423
#define OBJECT_BLOCKADE6 1459
#define OBJECT_BLOCKADE7 1237
#define OBJECT_BLOCKADE8 3091
#define OBJECT_BLOCKADE9 3578
#define OBJECT_BLOCKADE10 1425
#define OBJECT_BLOCKADE11 18728

#define GetObjectModel(%0) \
  Streamer_GetIntData(STREAMER_TYPE_OBJECT, %0, E_STREAMER_MODEL_ID)

#define LABEL_DESCRIPTION 		 0xBBACCFDD
#define LABEL_NICK_NORMAL_COLOR  0xFFFFFFB3
#define LABEL_NICK_DAMAGED_COLOR 0xFF0000B3
#define LABEL_NICK_PREMIUM_COLOR 0xFFCC14B3

#define HEX_COLOR_LIGHTER_RED "{FF3C3C}"
#define HEX_COLOR_LIGHTER_GREEN "{D6EE76}"
#define HEX_COLOR_LIGHTER_BLUE "{0098D9}"
#define HEX_COLOR_LIGHTER_YELLOW "{F2E200}"
#define HEX_COLOR_GOLD "{FCAD43}"
#define HEX_COLOR_RED "{AA3333}"
#define HEX_COLOR_GREEN "{199908}"
#define HEX_COLOR_GREY "{AFAFAF}"
#define HEX_COLOR_WHITE "{FFFFFF}"
#define HEX_COLOR_BROWN "{965701}"
#define HEX_COLOR_SAMP "{A9C4E4}"
#define HEX_COLOR_CREW_GM "{345E21}"
#define HEX_COLOR_CREW_ADMIN "{3399CC}"
#define HEX_COLOR_CREW_ADMIN_ROOT "{FF1F1F}"
#define HEX_COLOR_VICE "{CE2DC9}"

//Typy pogody
#define WEATHER_TYPE_SUNNY	1
#define WEATHER_TYPE_RAINY	2

//Typy sklepów
#define PLACE_TYPE_BANK			1
#define PLACE_TYPE_HOTEL		2
#define PLACE_TYPE_SHOP			3
#define PLACE_TYPE_VICTIM		4
#define PLACE_TYPE_PHARMACY		5
#define PLACE_TYPE_CARDEALER	6
#define PLACE_TYPE_AMMUNATION	7
#define PLACE_TYPE_TOOLSHOP		8

//Poziomy ekipy
#define CREW_FLAG_GM 			1
#define CREW_FLAG_ADMIN 		2
#define CREW_FLAG_ADMIN_ROOT 	4
#define CREW_FLAG_DOORS 		8
#define CREW_FLAG_VEHICLES		16
#define CREW_FLAG_GROUPS 		32
#define CREW_FLAG_AREAS 		64
#define CREW_FLAG_EDITOR 		128
#define CREW_FLAG_ITEMS 		256

//Flagi postaci
#define PLAYER_FLAG_BMX			1
#define PLAYER_FLAG_ORDER		2
#define PLAYER_FLAG_PRESIDENT	4

//Typy produktów
#define PRODUCT_OWNER_GASTRONOMY 1
#define PRODUCT_OWNER_LSPD 		 2
#define PRODUCT_OWNER_CRIME 	 3
#define PRODUCT_OWNER_GYM   	 4
#define PRODUCT_OWNER_WORKSHOP   5
#define PRODUCT_OWNER_SHOP       6
#define PRODUCT_OWNER_PHARMACY   7
#define PRODUCT_OWNER_GOLF   	 8
#define PRODUCT_OWNER_SECURITY   9
#define PRODUCT_OWNER_ERU    	10
#define PRODUCT_OWNER_MAFBOT     11
#define PRODUCT_OWNER_SNEWS      12
#define PRODUCT_OWNER_VICTIM	 13
#define PRODUCT_OWNER_AMMUNATION 14
#define PRODUCT_OWNER_TOOLSHOP   15
#define PRODUCT_OWNER_LIBERTY	 16
#define PRODUCT_OWNER_ASIAN		 17

//Prox types
#define PROX_LOCAL 0
#define PROX_SHOUT 1
#define PROX_QUIET 2
#define PROX_ME 3
#define PROX_DO 4
#define PROX_LOCAL_L 5
#define PROX_OOC 6
#define PROX_RADIO 7
#define PROX_PHONE 8
#define PROX_MEGAPHONE	9
#define PROX_SERWERME	10

#define QS_TIME 6000

//Spawny 
#define SPAWN_TYPE_HOUSE			1
#define SPAWN_TYPE_HOTEL			2
#define SPAWN_TYPE_GLOBAL			3

//Animacje
#define ANIM_TYPE_BW 1
#define ANIM_TYPE_CARBW 2

enum sAnimData
{
	aUID,
	
	aCommand[32],
	aLib[32],
	aName[32],
	
	Float:aSpeed,
	
	aOpt1,
	aOpt2,
	aOpt3,
	aOpt4,
	aOpt5,
	
	aAction
}
new AnimInfo[MAX_ANIMATIONS][sAnimData];

//Statusy
#define AFK_TIME 3 // w sekundach
#define PLAYER_STATUS_AFK 			1
#define PLAYER_STATUS_BELT 			2
#define PLAYER_STATUS_HELMET		3
#define PLAYER_STATUS_NEW_CHAR 		4
#define PLAYER_STATUS_BW 			5
#define PLAYER_STATUS_DRUNK 		6
#define PLAYER_STATUS_DEALING 		7
#define PLAYER_STATUS_MUSCULAR		8
#define PLAYER_STATUS_SPORT			9
#define PLAYER_STATUS_WEED			10
#define PLAYER_STATUS_NEW			11
#define PLAYER_STATUS_FAT			12
#define PLAYER_STATUS_DRUGS			13
#define PLAYER_STATUS_ADDICTED		14
#define PLAYER_STATUS_REKAWICZKI 	15
#define PLAYER_STATUS_ARMOUR		16
#define PLAYER_STATUS_JAIL   		17
#define PLAYER_STATUS_EXTRA		 	18

//Edytory obiektów
#define OBJECT_EDITOR_SAMP			0
#define OBJECT_EDITOR_CUSTOM		1

//Sesje
#define SESSION_STATE_NONE 0
#define SESSION_STATE_ALREADY_LOGGED 1
#define SESSION_STATE_ABORT 2
#define SESSION_STATE_BAD_PASS 3
#define SESSION_STATE_NORMAL 4
#define SESSION_STATE_LOGIN_TIMEOUT 5

#define SESSION_TYPE_LOGIN 1
#define SESSION_TYPE_DUTY 2
#define SESSION_TYPE_ADMIN_DUTY 3

//Togi
#define TOG_W 			1
#define TOG_G1 			2
#define TOG_G2 			4
#define TOG_G3 			8
#define TOG_G4 			16
#define TOG_G5 			32
#define TOG_HUD	 		64

//Silownia
#define GYM_BIKE	1
#define GYM_TREAM	2
#define GYM_BENCH	3
#define GYM_DUMB	4

//Obiekty
#define OBJECT_TYPE_NORMAL 		1
#define OBJECT_TYPE_BLOCKADE	2
#define OBJECT_TYPE_ROBBERY		3
#define OBJECT_TYPE_TRASH		4
#define OBJECT_TYPE_BOX			5
#define OBJECT_TYPE_PLANT		6

#define OBJECT_OWNER_TYPE_GLOBAL 1
#define OBJECT_OWNER_TYPE_DOOR 2
#define OBJECT_OWNER_TYPE_AREA 3

//Drzwi
#define DOOR_TYPE_NORMAL 1
#define DOOR_TYPE_HOUSE	 2

#define DOOR_OWNER_TYPE_GLOBAL 1
#define DOOR_OWNER_TYPE_PLAYER 2
#define DOOR_OWNER_TYPE_GROUP 3

#define DOOR_ACCESS_CAMERA	1 //kamery
#define DOOR_ACCESS_ALARM	2 //alarm
#define DOOR_ACCESS_FIRE_SPRINKLER	4 //zraszacze przeciwpozarowe
#define DOOR_ACCESS_LAB_UPGRADES	8 //ulepszona produkcja
#define DOOR_ACCESS_METHLAB	16 //sprzet do produkcji mety
#define DOOR_ACCESS_AMPHLAB	32 //sprzet do produkcji amfy
#define DOOR_ACCESS_CRACKLAB 64 //sprzet do produkcji cracku

//Czesci ciala

#define BODY_PART_TORSO 	3
#define BODY_PART_GROIN		4
#define BODY_PART_LEFT_ARM	5
#define BODY_PART_RIGHT_ARM	6
#define BODY_PART_LEFT_LEG	7
#define BODY_PART_RIGHT_LEG	8
#define BODY_PART_HEAD		9

//Strefy
#define AREA_SHAPE_SQUARE 1
#define AREA_SHAPE_CIRCLE 2
#define AREA_SHAPE_CUBOID 3

#define AREA_TYPE_NORMAL 	 1
#define AREA_TYPE_BOOMBOX	 2
#define AREA_TYPE_ARMDEALER	 3
#define AREA_TYPE_FIRE		 4
#define AREA_TYPE_GUARD_NPC	 5

#define AREA_TYPE_BLOCKADE	28

#define AREA_OWNER_TYPE_GLOBAL 	1
#define AREA_OWNER_TYPE_GROUP 	2
#define AREA_OWNER_TYPE_DOOR	3

//Flagi stref 
#define AREA_FLAG_CORNER		1
#define AREA_FLAG_BMX			2
#define AREA_FLAG_MONITORING	4
#define AREA_FLAG_PLANT			8
#define AREA_FLAG_PARKING		16
#define AREA_FLAG_OFFER			32
#define AREA_FLAG_DRIVE			64
#define AREA_FLAG_WORK			128
#define AREA_FLAG_SERWIS		256
#define AREA_FLAG_WORK_FISH		512
#define AREA_FLAG_LS			1024
#define AREA_FLAG_WORK_FORKLIFT	2048
#define AREA_FLAG_BONUS			4096
#define AREA_FLAG_OCEAN_DOCK	8192
#define AREA_FLAG_DOCK 			16384	

// 3d teksty
#define LABEL_OWNER_TYPE_GLOBAL 1
#define LABEL_OWNER_TYPE_DOOR 2
#define LABEL_OWNER_TYPE_AREA 3

//Flagi grup
#define GROUP_FLAG_IC 				1
#define GROUP_FLAG_OOC 				2
#define GROUP_FLAG_COLORED			4
#define GROUP_FLAG_DEP 				8
#define GROUP_FLAG_DUTY 			16
#define GROUP_FLAG_KEEP 			32
#define GROUP_FLAG_BLOCKADE 		64
#define GROUP_FLAG_WEAPON_FLAG 		128
#define GROUP_FLAG_911 				256
#define GROUP_FLAG_RACES 			512
#define GROUP_FLAG_BOT	 			1024
#define GROUP_FLAG_MASK 			2048
#define GROUP_FLAG_TAKE 			4096 
#define GROUP_FLAG_SEARCH 			8192 
#define GROUP_FLAG_CUFFS 			16384
#define GROUP_FLAG_PRYING			32768
#define GROUP_FLAG_MEDIC			65536
#define GROUP_FLAG_PAINTJOB			131072
#define GROUP_FLAG_BUSINESS			262144

//Flagi pracownikow
#define WORKER_FLAG_CHAT 1
#define WORKER_FLAG_DOORS 2
#define WORKER_FLAG_VEHICLES 4
#define WORKER_FLAG_OFFER 8
#define WORKER_FLAG_ORDER 16
#define WORKER_FLAG_LEADER 32
#define WORKER_FLAG_MANAGER 64

//Typy grup
#define GROUP_TYPE_NONE	0
#define GROUP_TYPE_LSPD 1
#define GROUP_TYPE_MEDIC 2
#define GROUP_TYPE_SN 3
#define GROUP_TYPE_SECURITY 4
#define GROUP_TYPE_GANG 5
#define GROUP_TYPE_PETROL 6
#define GROUP_TYPE_GASTRO 7
#define GROUP_TYPE_TAXI 8
#define GROUP_TYPE_WORKSHOP 9
#define GROUP_TYPE_GYM	10
#define GROUP_TYPE_GOV	11
#define GROUP_TYPE_FARM	12
#define GROUP_TYPE_CASINO 13

new GroupTypes[][30] = {
	"Nieokreslony",
	"Porzadkowa",
	"Medyczno pozarowa",
	"Radiostacja",
	"Firma ochroniarska",
	"Organizacja przestepcza",
	"Stacja benzynowa",
	"Gastronomia",
	"Taxi",
	"Warsztat",
	"Silownia",
	"Rzad",
	"Farma",
	"Kasyno"
};

new GroupDefaultFlags[] = {
	GROUP_FLAG_OOC + GROUP_FLAG_DUTY,
	GROUP_FLAG_IC + GROUP_FLAG_OOC + GROUP_FLAG_COLORED + GROUP_FLAG_KEEP + GROUP_FLAG_DEP + GROUP_FLAG_BLOCKADE + GROUP_FLAG_911 + GROUP_FLAG_SEARCH + GROUP_FLAG_CUFFS+ GROUP_FLAG_PRYING, // Porzadkowa
	GROUP_FLAG_IC + GROUP_FLAG_OOC + GROUP_FLAG_COLORED + GROUP_FLAG_911 + GROUP_FLAG_DEP + GROUP_FLAG_BLOCKADE + GROUP_FLAG_MEDIC, // Medycy
	GROUP_FLAG_IC + GROUP_FLAG_OOC + GROUP_FLAG_BUSINESS, // SN
	GROUP_FLAG_OOC + GROUP_FLAG_CUFFS + GROUP_FLAG_SEARCH + GROUP_FLAG_BUSINESS, // Ochrona
	GROUP_FLAG_OOC + GROUP_FLAG_SEARCH + GROUP_FLAG_BOT + GROUP_FLAG_TAKE + GROUP_FLAG_RACES + GROUP_FLAG_MASK, // Przestepcza
	GROUP_FLAG_OOC + GROUP_FLAG_BUSINESS, // Stacja benzynowa
	GROUP_FLAG_OOC + GROUP_FLAG_DUTY + GROUP_FLAG_BUSINESS, // Gastronomia
	GROUP_FLAG_OOC + GROUP_FLAG_BUSINESS, // Taxi
	GROUP_FLAG_OOC + GROUP_FLAG_DUTY + GROUP_FLAG_BUSINESS + GROUP_FLAG_PAINTJOB, // Warsztat
	GROUP_FLAG_OOC + GROUP_FLAG_DUTY + GROUP_FLAG_BUSINESS, // silownia
	GROUP_FLAG_OOC, // rzad
	GROUP_FLAG_OOC + GROUP_FLAG_BUSINESS, // farma
	GROUP_FLAG_OOC + GROUP_FLAG_BUSINESS, // kasyno
};

#define ACTION_TYPE_OFFER 		1
#define ACTION_TYPE_DEPOSIT	 	2
#define ACTION_TYPE_WITHDRAW 	3

// Pojazdy
#define VEHICLE_OWNER_TYPE_PLAYER 1
#define VEHICLE_OWNER_TYPE_GROUP 2
#define VEHICLE_OWNER_TYPE_JOB	 3

#define VEHICLE_FUEL_TYPE_BENZYNA 1
#define VEHICLE_FUEL_TYPE_GAZ 2
#define VEHICLE_FUEL_TYPE_DIESEL 3
#define VEHICLE_FUEL_TYPE_LOTNICZE 4

#define VEHICLE_ACCESSORY_IMMOBILISER 1
#define VEHICLE_ACCESSORY_ALARM 2
#define VEHICLE_ACCESSORY_AUDIO 4
#define VEHICLE_ACCESSORY_SIREN	8

#define BENZYNA_MULTIPLIER 1.9
#define GAZ_MULTIPLIER 1.3
#define DIESEL_MULTIPLIER 1.1
#define LOTNICZE_MULTIPLIER 3.0

#define FUEL_DRAIN_INCREASE_MILEAGE_CAP 10000

new VehicleFuelTypes[5][20] =
{
	"Brak",
	"Benzyna",
	"Gaz",
	"Ropa",
	"Paliwo lotnicze"
};

new Float:gFerrisCageOffsets[10][3]={{0.0699,0.0600,-11.7500},{-6.9100,-0.0899,-9.5000},{11.1600,0.0000,-3.6300},{-11.1600,-0.0399,3.6499},{-6.9100,-0.0899,9.4799},{0.0699,0.0600,11.7500},{6.9599,0.0100,-9.5000},{-11.1600,-0.0399,-3.6300},{11.1600,0.0000,3.6499},{7.0399,-0.0200,9.3600}},
	FerrisWheelObjects[12],
	Float:FerrisWheelAngle=0.0,
	FerrisWheelAlternate=0;

#define forEx(%0,%1) for(new %1=0;%1<%0;%1++)

// Przedmioty
#define ITEM_OWNER_TYPE_GROUND 1
#define ITEM_OWNER_TYPE_PLAYER 2
#define ITEM_OWNER_TYPE_DOOR 3
#define ITEM_OWNER_TYPE_VEHICLE 4
#define ITEM_OWNER_TYPE_ITEM 5
#define ITEM_OWNER_TYPE_GROUP	6

#define WEAPON_TYPE_MELEE 1
#define WEAPON_TYPE_SHORT 2
#define WEAPON_TYPE_LONG 3
#define WEAPON_TYPE_GRENADE 4
#define WEAPON_TYPE_SPECIAL 5

#define ITEM_TYPE_WEAPON 		1	// Bron (value1 = model broni, value2 = amunicja)
#define ITEM_TYPE_AMMO 			2	// Amunicja (value1 = typ broni, value2 = ilosc amunicji)
#define ITEM_TYPE_MASKA 		3	// Maska
#define ITEM_TYPE_PHONE 		4	// Telefon (value1 = numer telefonu)
#define ITEM_TYPE_WATCH 		5	// Zegarek
#define ITEM_TYPE_FOOD      	6   // Jedzenie (value1 = ilosc hp)
#define ITEM_TYPE_CIGGY     	7   // Papierosy (value1 = ilosc sztuk)
#define ITEM_TYPE_CUBE      	8   // Kostka do gry
#define ITEM_TYPE_CLOTH     	9   // Ubranie (value1 = id skinu)
#define ITEM_TYPE_CANISTER  	10  // Karnister (value1 = ilosc paliwa, value2 = typ paliwa)
#define ITEM_TYPE_SUPLEMENT		11  // Odzywka (value 1 = czynnik mnozenia podstawowej sily (0,02) )
#define ITEM_TYPE_MOLOTOV		12  // Podpalanie interioru (value 1 = uid drzwi, value 2 = uid grupy)
#define ITEM_TYPE_DEMOLITION	13  // Demolka lokalu
#define ITEM_TYPE_TOOLBOX		14  // Skrzynka z narzedziami (value 1 = ile ma miec HP po naprawie)
#define ITEM_TYPE_LINE      	15  // Lina holownicza
#define ITEM_TYPE_GRENADE		16  // Granat (value 1 = typ granatu)
#define ITEM_TYPE_NOTEBOOK  	17  // Notes (value1 = ilosc karteczek)
#define ITEM_TYPE_CHIT      	18  // Karteczka (value1 = uid wpisu w bazie)
#define ITEM_TYPE_TUNING    	19  // Czesc tuningu (value1 = id komponentu)
#define ITEM_TYPE_ROB_BOMBEL	20  // Do obrabiania sejfow i otwierania drzwi pancernych (value 1 = 1(elektronika), 2 (bomba))
#define ITEM_TYPE_ROB_TOOLS		21  // Narzedzia do obrabiania kas fiskalnych
#define ITEM_TYPE_ROB_CASH		22  // Lup z napadu (value 1 = ilosc kasy, value 2 = uid drzwi z ktorych skradziono)
#define ITEM_TYPE_BAG       	23  // Torba
#define ITEM_TYPE_DRINK     	24  // Napoj (value1 = special_action (20 - piwo, 22 - wino, 23 - sprunk))
#define ITEM_TYPE_DRUG      	25  // Narkotyk (value1 = typ narkotyku, value2 = pozostale)
#define ITEM_TYPE_JBL      		26  // Glosnik bt 
#define ITEM_TYPE_VATTACH		27  // Obiekt przyczepialny pojazdu
#define ITEM_TYPE_DOOR_ACCESS	29  // Akcesoria dla drzwi (value 1 = typ akcesoria)
#define ITEM_TYPE_ATTACH    	30  // Obiekt przyczepialny (value1 = kosc, value2 = nie dotykac bo to index, skrypt sam to ustawia)
#define ITEM_TYPE_ACCESS    	31  // Akcesoria do pojazdu (value1 = typ akcesoria)
#define ITEM_TYPE_PLATE     	32  // Plyta (value1 = UID wpisu w bazie)
#define ITEM_TYPE_PREMIUM		33  // Usluga premium (value1 = typ uslugi)

#define ITEM_TYPE_ARMOUR    	35  // Kamizelka kuloodporna (value1 = ilosc kamizelki)
#define ITEM_TYPE_GLOVES    	36  // Rekawiczki
#define ITEM_TYPE_CORPSE    	37  // Zwloki (value1 = UID zabojcy, value2 = typ zabojstwa)

#define ITEM_TYPE_GOLF_CARNET	48  // Karnet do gry w golfa
#define ITEM_TYPE_DILDO_CHAINSAW	49 // Pila do ciecia drewna w pracy dorywczej
#define ITEM_TYPE_HOWITZER		50   // Granatnik (value 1 = ilosc strzalow)

#define ITEM_TYPE_BOMB     		53 // Bomba
#define ITEM_TYPE_LEK			54 // Lek z apteki
#define ITEM_TYPE_GYM_KARNET	55 // Karnet na silownie

#define ITEM_TYPE_CHEMISTRY		57 // Srodki chemiczne do produkcji narkotykow (value 1 = 1(meta), 2(amfa) )

#define ITEM_TYPE_SEED			59 // Nasiona (value1 = typ nasiona, value2 = ilosc)

#define ITEM_TYPE_EMPTY_PLATE 	65 // Czysta plyta
#define ITEM_TYPE_ROPE          66 // Sznur

#define DRUG_TYPE_COCAINE		1
#define DRUG_TYPE_CRACK			2
#define DRUG_TYPE_WEED			3
#define DRUG_TYPE_AMFA			4
#define DRUG_TYPE_METH			5
#define DRUG_TYPE_HEROINE		6
#define DRUG_TYPE_EXTASY		7
#define DRUG_TYPE_HASH			8
#define DRUG_TYPE_LSD			9

#define SEED_TYPE_TOBBACO	1
#define SEED_TYPE_WEED		2
#define SEED_TYPE_VEGGIES	3
#define SEED_TYPE_POTATOS	4
#define SEED_TYPE_OPIUM		5

#define OBJECT_OPIUM	869
#define OBJECT_TOBACCO	855
#define OBJECT_VEGGIES  761
#define OBJECT_POTATOS	866
#define OBJECT_WEED 	19473

#define GRENADE_TYPE_FLASH		1
#define GRENADE_TYPE_SMOKE		2
#define GRENADE_TYPE_BANG		3

#define PREMIUM_TYPE_SILVERPACC		1
#define PREMIUM_TYPE_GOLDPACC		2
#define PREMIUM_TYPE_OBJECTS		3
#define PREMIUM_TYPE_AREAOBJECTS	4
#define PREMIUM_TYPE_STICKER		5
#define PREMIUM_TYPE_PERSONAL30		6
#define PREMIUM_TYPE_PERSONAL90		7
#define PREMIUM_TYPE_CHARBLOCK		8
	
// Oferty
#define OFFER_TYPE_VCARD 	1
#define OFFER_TYPE_DOCUMENT 2
#define OFFER_TYPE_YO		3
#define OFFER_TYPE_ITEM		4
#define OFFER_TYPE_TAXI		5
#define OFFER_TYPE_PRODUCT	6
#define OFFER_TYPE_REPAIR	7
#define OFFER_TYPE_MONTAGE	8
#define OFFER_TYPE_REFUEL	9
#define OFFER_TYPE_DOOR		10
#define OFFER_TYPE_VEHICLE	11
#define OFFER_TYPE_TRIBUTE	12
#define OFFER_TYPE_MANDAT	13
#define OFFER_TYPE_ACCESS 	14 
#define OFFER_TYPE_GYM 		15 
#define OFFER_TYPE_RESPRAY	16
#define OFFER_TYPE_PAINTJOB	17
#define OFFER_TYPE_INTERVIEW 18
#define OFFER_TYPE_MEDIC 19
#define OFFER_TYPE_ADVERTISE 20
#define OFFER_TYPE_DOOR_ACCESS	21
#define OFFER_TYPE_RP 22
#define OFFER_TYPE_PASS	23
#define OFFER_TYPE_TOW  24
#define OFFER_TYPE_GYM_FIGHT 25
#define OFFER_TYPE_INVITE	26
#define OFFER_TYPE_CARSHARE	27

//Salon aut 
#define CATEGORY_THREEDOORS	1
#define CATEGORY_FIVEDOORS	2
#define CATEGORY_TRUCKS		3
#define CATEGORY_PLANES		4
#define CATEGORY_BOATS		5
#define CATEGORY_SPORT		6
#define CATEGORY_BIKES		7
#define CATEGORY_PREMIUM	8

//Dokumenty
#define DOCUMENT_ID 	1
#define DOCUMENT_DRIVE 	2
#define DOCUMENT_WEAPON	4
#define DOCUMENT_METRIC	8

//Pickupy
#define PICKUP_TYPE_JOB		1
#define PICKUP_TYPE_CASH	2
#define PICKUP_TYPE_DOOR	3
#define PICKUP_TYPE_GOV		4
#define PICKUP_TYPE_ROBBERY 5
#define PICKUP_TYPE_DROP	6

//Prace 
#define WORK_TYPE_LUMBERJACK	1
#define WORK_TYPE_FISHER		2
#define WORK_TYPE_FORKLIFT		3
#define WORK_TYPE_TRASHMAN		4
#define WORK_TYPE_TRUCKER		5

//Attache 
#define ATTACH_SLOT_ADDON_ONE	1
#define ATTACH_SLOT_ADDON_TWO	2
#define ATTACH_SLOT_ADDON_THREE	3	
#define ATTACH_SLOT_WEAPONTH	4
#define ATTACH_SLOT_WEAPON		5
#define ATTACH_SLOT_WEAPONT		6
#define ATTACH_SLOT_GYM1		7
#define ATTACH_SLOT_GYM2		8
#define ATTACH_SLOT_VICTIM		9

#define ACCESS_CAT_GLASSES		1
#define ACCESS_CAT_HATS			2
#define ACCESS_CAT_OTHERS		3
#define ACCESS_CAT_WATCHES		4

#define MAX_VEHICLE_ATTACHMENTS 2

// -----------------------------------------------

#define DIALOG_INFO 1
#define DIALOG_LOGIN 2
#define DIALOG_LOGIN_NO_ACCOUNT 3
#define DIALOG_GIVE_CREW 4

#define DIALOG_DRZWI 6
#define DIALOG_DRZWI_NAME 7
#define DIALOG_DRZWI_SPAWN 8
#define DIALOG_DRZWI_SPAWN_COORDS 9
#define DIALOG_DRZWI_AUDIO 10
#define DIALOG_DRZWI_PAYMENT 11

#define DIALOG_ADRZWI_PICKUP 12
#define DIALOG_ADRZWI_CHANGE_INTERIOR 13
#define DIALOG_DRZWI_OBJECTS_LIMIT 14

#define DG_DRZWI_NAME 1
#define DG_DRZWI_SPAWN 2
#define DG_DRZWI_SPAWN_COORDS 3
#define DG_DRZWI_AUDIO 4
#define DG_DRZWI_SCHOWEK 5
#define DG_DRZWI_SURFACE 6
#define DG_DRZWI_PAYMENT 7
#define DG_DRZWI_CARS 8
#define DG_DRZWI_CLOSING 9
#define DG_DRZWI_CLEAR 10
#define DG_DRZWI_TIME 11
#define DG_DRZWI_FIX  12
#define DG_DRZWI_FIX_BURN 13
#define DG_DRZWI_CAMERA	14
#define DG_DRZWI_BUY	15
#define DG_DRZWI_CREATE	16
#define DG_DRZWI_ASSIGN	17
#define DG_DRZWI_UNSIGN	18

#define DG_AREA_INFO 	1
#define DG_AREA_TAKE 	2
#define DG_AREA_VISIBLE 3
#define DG_AREA_OBJECTS 4
#define DG_AREA_TAKEA	5

#define DG_DRZWI_CHANGE_INTERIOR_PREV 1
#define DG_DRZWI_CHANGE_INTERIOR_NEXT 2
#define DG_DRZWI_CHANGE_INTERIOR_ROW 3

#define DIALOG_AGRUPA_TYP 15

#define DIALOG_CHAR_DESCRIPTION 16
#define DIALOG_CHAR_DESCRIPTION_ADD 17

#define DG_CHAR_DESC_OLD 1
#define DG_CHAR_DESC_ADD 2
#define DG_CHAR_DESC_DELETE 3

#define DG_ANIMS 1

#define DIALOG_PLAYER_VEHICLES 18
#define DIALOG_GROUP_VEHICLES 19
#define DIALOG_PLAYER_VEHICLE_PANEL 20
#define DG_PLAYER_VEHICLE_PANEL_LIGHTS 	1
#define DG_PLAYER_VEHICLE_PANEL_BOOT 	2
#define DG_PLAYER_VEHICLE_PANEL_BONNET  3
#define DG_PLAYER_VEHICLE_PANEL_WIN_DRIVER	4
#define DG_PLAYER_VEHICLE_PANEL_WIN_PP	5
#define DG_PLAYER_VEHICLE_PANEL_WIN_LT	6
#define DG_PLAYER_VEHICLE_PANEL_WIN_PT	7

#define DIALOG_PLAYER_ITEMS 21
#define DG_ITEMS_ITEM_ROW 1

#define DIALOG_ITEM_MORE 22

#define DG_ITEMS_MORE_INFO	1
#define DG_ITEMS_MORE_DROPG 2
#define DG_ITEMS_MORE_SELL 3
#define DG_ITEMS_MORE_PUT_IN_DOOR 4
#define DG_ITEMS_MORE_PUT_IN_STORAGE 5
#define DG_ITEMS_MORE_PUT_IN_BAG	6
#define DG_ITEMS_MORE_DELETE	7
#define DG_ITEMS_MORE_EDIT		8
#define DG_ITEMS_MORE_CONNECT	9

#define DG_PRODS_ITEM_ROW 1
#define DG_PRODS_SALON	  1

#define DIALOG_ITEMS_PICKUP 23
#define DG_ITEMS_PICKUP_ROW 1

#define DIALOG_USE_AMMO 24

#define DIALOG_PHONE 25
#define DG_PHONE_CALL 1
#define DG_PHONE_SMS 2
#define DG_PHONE_CONTACTS 3
#define DG_PHONE_ADD_CONTACT 4
#define DG_PHONE_TURNOFF 5
#define DG_PHONE_VCARD 6

#define DIALOG_PHONE_SMS_NUMBER 26
#define DIALOG_PHONE_SMS_TEXT 27

#define DIALOG_PHONE_CONTACTS 28
#define DG_PHONE_CONTACTS_BASE 1
#define DG_PHONE_CONTACTS_ROW 2

#define DIALOG_PHONE_VCARD 29
#define DIALOG_PHONE_CONTACTS_ROW 30
#define DIALOG_PHONE_CONTACTS_ROW_NAME 31

#define DIALOG_PHONE_CALL_NUMBER 32

#define DIALOG_WORKS 33
#define DIALOG_DOCUMENTS 34
#define DIALOG_PAYMENT 35

#define DIALOG_CBELL 36
#define DIALOG_DRUGS_LIST	37
#define DIALOG_EMMET	38
#define DIALOG_MUSIC_MACHINE	39
#define DIALOG_SHOP_LIST	40
#define DIALOG_BANKOMAT	41
#define DIALOG_AS 		42

#define DIALOG_BANK_DEPOSIT	43
#define DIALOG_BANK_WITHDRAW 44
#define DIALOG_BANK_PRZELEW	45

#define DIALOG_WHISPER			46
#define DIALOG_ACCEPT_TRAVEL     47
#define DIALOG_ANIMATIONS		 48
#define DIALOG_911			     49

#define DIALOG_FOOD_TRANSFORM20	 50
#define DIALOG_FOOD_TRANSFORM40	 51
#define DIALOG_FOOD_TRANSFORM60	 52

#define DIALOG_HURTOWNIA_LEGAL   53
#define DIALOG_HURTOWNIA_FOOD	 54
#define DIALOG_SALON			 55
#define DIALOG_SALON_SELL		 56
#define DIALOG_SALON_FIVEDOOR	 57
#define DIALOG_SALON_TRUCKS		 58
#define DIALOG_SALON_LOWRIDERS		 59
#define DIALOG_SALON_BOATS		 	60
#define DIALOG_SALON_SAMOLOTY	 	61
#define DIALOG_SALON_BIKES		 	62
#define DIALOG_SALON_OTHERS		 	63
#define DIALOG_HURTOWNIA_ILLEGAL	64
#define DIALOG_SALON_COLOR			65
#define DIALOG_HURTOWNIA_ILLEGAL_ADD	66
#define DIALOG_HURTOWNIA_ILLEGAL_COUNT	67
#define DIALOG_HURTOWNIA_RACE		68
#define DIALOG_GOLF_SHOP			69
#define DIALOG_SEX_SHOP				70
#define DIALOG_PRO_SHOP				71
#define DIALOG_ITEMS_OFFER			72
#define DIALOG_HELP					73
#define DIALOG_PHARMACY				74
#define DIALOG_STATS				75
#define DIALOG_WALKING_ANIM			76
#define DIALOG_BANK_NUMER			77
#define DIALOG_GYM					78
#define DIALOG_USE_DRUG				79
#define DIALOG_GROUP_MAGAZYN		80
#define DIALOG_GROUP_MAGAZYN_ID		81
#define DIALOG_PUTTING_ITEM			82
#define DIALOG_SAFE					83
#define DIALOG_SAFE_WITHDRAW		84
#define DIALOG_SAFE_DEPOSIT			85
#define DIALOG_FACTORY_PRODUCTS		86
#define DIALOG_HURTOWNIA_ADD  		87
#define DIALOG_ARMDEALER			88
#define DIALOG_WEAZEL				89
#define DIALOG_TAXICALL				90
#define DIALOG_ITEMS_OFFER_PRICE	91
#define DIALOG_HURTOWNIA_LSPD		92
#define DIALOG_PAKOWANIE			93
#define DIALOG_SYNDYKAT				94
#define DIALOG_LOCATION				96
#define DIALOG_HURTOWNIA_SECURITY	97
#define DIALOG_USE_BAG				98
#define DIALOG_TAKE_BAG				99
#define DIALOG_HURTOWNIA_ADDPROD	101
#define DIALOG_HOTELS				102
#define DIALOG_HORSEBET				103
#define DIALOG_HORSEBET_AMOUNT		104
#define DIALOG_CD_LINK    			105
#define DIALOG_AREA_FLAGS			106
#define DIALOG_ADMIN_FLAGS			107
#define DIALOG_DRZWI_TIME			108
#define DIALOG_DRZWI_CLEAR			109
#define DIALOG_GROUP_FLAGS			110
#define DIALOG_PHONE_ADD_CONTACT	111
#define DIALOG_HURTOWNIA_ADDPROD_COUNT	112
#define DIALOG_MDC					113
#define DIALOG_MDC_FIND_PERSON		114
#define DIALOG_MDC_FIND_VEHICLE		115
#define DIALOG_CLOTH				116
#define DIALOG_CLOTH_ACC			117
#define DIALOG_ADD_ACC				118
#define DIALOG_SPAWN  				119
#define DIALOG_SCHOWEK_TAKE			120
#define DIALOG_TRIBUTE_MENU			121
#define DIALOG_MDC_ADD_APB			122
#define DIALOG_MDC_REMOVE_APB		123
#define DIALOG_TUNE 				124
#define DIALOG_LUMBERJACK 			125
#define DIALOG_GIVE_FLAG			126
#define DIALOG_PHONE_CALL_GROUP 	127
#define DIALOG_CALL_GROUP 			128
#define DIALOG_FINGERPRINTS			129
#define DIALOG_SPAWN_CHOICE			130
#define DIALOG_AUTO_FIX				131
#define DIALOG_MDC_ADD 				132
#define DIALOG_PLAYER_INTERACTION	133
#define DIALOG_VEHICLE_INTERACTION	134
#define DIALOG_DRZWI_CREATE			135
#define DIALOG_DRZWI_CREATE_CONFIRM	136
#define DIALOG_AREA 				137
#define DIALOG_OFFER 				138
#define DIALOG_GRENADE				139
#define DIALOG_NAMECHANGE			140
#define DIALOG_RADIOSTATIONS		141
#define DIALOG_ROBBERY				142
#define DIALOG_ROBBERY_START		143
#define DIALOG_GROUP_CREATOR		144
#define DIALOG_GROUP_NAME			145
#define DIALOG_GROUP_PRODUCTS		146
#define DIALOG_DRZWI_ASSIGN			147
#define DIALOG_GOV 					148
#define DIALOG_GOV_CREATOR			149
#define DIALOG_GOV_TAXES			150
#define DIALOG_GOV_CREATE			151
#define DIALOG_GOV_NAME				152
#define DIALOG_TAKE 				153
#define DIALOG_INTERACTION 			154
#define DIALOG_BANK_CREDIT			155
#define DIALOG_BANK_TAKE_CREDIT		156
#define DIALOG_ROULETTE_WAGER		157
#define DIALOG_SMUGGLING			158
#define DIALOG_ADRZWI_OWN_PICKUP	159
#define DIALOG_SMUGGLE_CONFIRM		160
#define DIALOG_GROUP_INFO			161
#define DIALOG_CK 					162
#define DIALOG_SMS_COST				163
#define DIALOG_CONNECT_DRUGS		164
#define DIALOG_WHEELBLOCK			165
	
#define DG_INTERACTION_CUFF 1
#define DG_INTERACTION_KEEP 2
#define DG_INTERACTION_TAKE 3
#define DG_INTERACTION_TAKELIC 4
#define DG_INTERACTION_FREE 5
#define DG_INTERACTION_TIE 6
#define DG_INTERACTION_HEAL 7
#define DG_INTERACTION_VCARD 8
#define DG_INTERACTION_INVITE	9
#define DG_INTERACTION_KILL	10
#define DG_INTERACTION_BUS	11
#define DG_INTERACTION_BANK	12