/*

W³aœcicielem oraz autorem skryptu jest Mariusz Orzechowski (Mario).

W gamemodzie wykorzystane zosta³y najnowsze rozwi¹zania skryptowe, miêdzy innymi:
- zapis i wczytywanie danych na zasadzie dzia³ania ORM'ów,
- zapytania asynchroniczne z u¿yciem y_inline,
- najszybszy system komend (Pawn.CMD)
- multi-dimensional iterators wykorzystane zosta³y m.in do stworzenia systemu przedmiotów per-player,
pojazdów gracza, oraz wielu innych aspektów,
- waga skryptu jest maksymalnie skurczona dziêki technice zachowania danych w tablicach,
- specjalnie do u¿ytecznoœci skryptu i zachowania jego optymalizacji przerobiony zosta³ plugin streamer.so,
- bardzo elastyczny system przedmiotów daj¹cy mo¿liwoœci do manipulacji kilkoma przedmiotami jednym klikniêciem,
jednoczeœnie bêd¹cym bardzo optymalnym narzêdziem,
- zosta³y wykorzystane w pe³ni funkcje pluginu sscanf,
- gamemode jest bardzo czytelny i bardzo ³atwo daje siê edytowaæ,
- wszystko celowo zachowane jest w jednym pliku .pwn dla wygody programisty i przejrzystoœci skryptu,

testowy tekst AAA

doda³em ten tekst i teraz wrzucam na githuba

*/

#include <crashdetect>

#include <YSI\y_va>
#include <YSI\y_timers>
#include <YSI\y_inline>
#include <YSI\y_iterate>

#include <a_samp>
#include <dynamicgui>

//#include <foreach>
#include <streamer>
#include <a_mysql>
#include <Pawn.CMD>
#include <sscanf2>
#include <samp-precise-timers>

#undef MAX_PLAYERS
#undef MAX_VEHICLES

#define INVALID_ITEM_ID     (-1)
#define INVALID_ITEM_TYPE   (-1)
#define INVALID_GROUP_ID    (-1)
#define INVALID_GROUP_TYPE  (-1)
#define INVALID_SLOT_ID     (-1)
#define INVALID_VEH_MODEL   (-1)

// Limits
#define MAX_PLAYERS             10
#define MAX_VEHICLES_SPAWN      5
#define MAX_VEHICLES        	100
#define MAX_ITEM_CACHE         	40
#define MAX_GROUP_SLOTS         4
#define MAX_GROUPS              50
#define MAX_DRAW_DISTANCE   	200.0

// Main config
#define GAMEMODE        "MY-RP"
#define VERSION         "0.0.1"
#define SERVER_NAME     "My RolePlay"
#define WEB_URL         "www.myrp.pl"

// SQL Connect
#define SQL_HOST    	"127.0.0.1"
#define SQL_USER        "root"
#define SQL_DTBS        "roleplay_database"
#define SQL_PASS        ""

//#pragma tabsize 0
//#pragma dynamic 8196

#define GetVehicleName(%0) \
		VehicleModelData[%0 - 400][vName]
		
#define IsPlayerPremium(%0) \
		((PlayerCache[%0][pPremium] > gettime()) ? true : false)

#define IsPlayerAFK(%0) \
		((PlayerCache[%0][pAFK] >= 0) ? true : false)
		
// PremiumLimits
#define FACC_VEHICLES   3
#define FACC_DESC       3
#define FACC_POINTS     10

#define PACC_VEHICLES   6
#define PACC_DESC       6
#define PACC_POINTS     15

// Colors
#define COLOR_WHITE			0xFFFFFFFF
#define COLOR_BLACK         0x000000FF
#define COLOR_BROWN 		0x8F4747FF
#define COLOR_KREM 			0xFF8080FF
#define COLOR_SAY 			0x2986CEFF
#define COLOR_GREY 			0xAFAFAFFF
#define COLOR_SYSGREY 		0xC6BEBDFF
#define COLOR_GREEN 		0x33AA33AA
#define COLOR_RED 			0xAA3333AA
#define COLOR_LIGHTRED      0xFF6347AA
#define COLOR_YELLOW 		0xFFFF00AA
#define COLOR_BLUE 			0x0000BBAA
#define COLOR_LIGHTBLUE 	0x33CCFFFF
#define COLOR_ORANGE 		0xFF9900AA
#define COLOR_DARKRED 		0xAA993333
#define COLOR_GREEN 		0x33AA33AA
#define COLOR_RED 			0xAA3333AA
#define COLOR_YELLOW 		0xFFFF00AA
#define COLOR_PINK 			0xFF66FFAA
#define COLOR_BLUE 			0x0000BBAA
#define COLOR_ORANGE 		0xFF9900AA
#define COLOR_GOLD			0xBD9A28FF
#define COLOR_VIOLET 		0x8000FFFF
#define COLOR_BROWN 		0x8F4747FF
#define COLOR_DARKGREY 		0x808080FF
#define COLOR_BLACK 		0x000000FF
#define COLOR_DARKGREEN 	0x0D731FFF
#define COLOR_DARKBLUE 		0x2010E0FF
#define COLOR_DARKBROWN 	0x530000FF
#define COLOR_DARKVIOLET 	0x400040FF
#define COLOR_DARKYELLOW 	0x808000FF
#define COLOR_DARKPINK 		0x400040FF
#define COLOR_LIGHTGREEN 	0x00FF00FF
#define COLOR_LIGHTPINK 	0xFF80FFFF
#define COLOR_PURPLE     	0xC2A2DAFF
#define COLOR_PURPLE2	    0xE0EA64FF
#define COLOR_AREA          0xD3C27877

#define COLOR_DO       		0x9A9CCDFF
#define COLOR_INFO			0xD7A064FF

#define COLOR_FADE1   		0xE6E6E6E6
#define COLOR_FADE2   		0xC8C8C8C8
#define COLOR_FADE3   		0xAAAAAAAA
#define COLOR_FADE4   		0x8C8C8C8C
#define COLOR_FADE5   		0x6E6E6E6E

#define COLOR_GRAD1   		0xB4B5B7FF
#define COLOR_GRAD2   		0xBFC0C2FF
#define COLOR_GRAD3   		0xCBCCCEFF
#define COLOR_GRAD4   		0xD8D8D8FF
#define COLOR_GRAD5   		0xE3E3E3FF
#define COLOR_GRAD6	  		0xF0F0F0FF

#define COLOR_BUSINESS      0x8A614DFF
#define COLOR_ORG  			0x70B8B8FF
#define COLOR_FACTION       0x8A8AFFFF
#define COLOR_DEPARTMENT    0x3DFF9EFF

#define COLOR_RADIO         0x0077FFFF

#define COLOR_ADMIN         0xEEE8AAFF
#define COLOR_SUPPORT       0x44D6FFFF

#define COLOR_SEND_PW   	0xFFC973FF
#define COLOR_GOT_PW  		0xFDAE33FF

#define COLOR_DESC          0xC2A2DAFF
#define COLOR_CB_RADIO      0xEFF291FF

#define COLOR_NICK          0xC7C7C788
#define COLOR_PUNISH        0x9C9C9CFF

// Dialogs
#define D_NONE          	0
#define D_LOGIN     		1

#define D_ITEM_USE  		2
#define D_ITEM_MANAGE    	3
#define D_ITEM_RAISE    	4
#define D_ITEM_DROP     	5
#define D_ITEM_CHECK    	6
#define D_ITEM_FAVORITE     7
#define D_ITEM_PUT_BAG      8
#define D_ITEM_REMOVE_BAG   9
#define D_ITEM_SEPARATE     10

#define D_VEH_SPAWN         11
#define D_VEH_TARGET        12

// Group types
#define G_TYPE_NONE     		0
#define G_TYPE_24/7     		1
#define G_TYPE_BAR		   		2
#define G_TYPE_GASSTATION   	3
#define G_TYPE_GYM          	4
#define G_TYPE_CARDEALER    	5
#define G_TYPE_TAXI         	6
#define G_TYPE_CLOTHES      	7
#define G_TYPE_WORKSHOP     	8
#define G_TYPE_HOTEL        	9
#define G_TYPE_BANK         	10
#define G_TYPE_SECURITY     	11

#define G_TYPE_POLICE       	12
#define G_TYPE_GOV          	13
#define G_TYPE_MEDICAL      	14
#define G_TYPE_NEWS         	15
#define G_TYPE_ARMY         	16
#define G_TYPE_FIREDEPT     	17
#define G_TYPE_FBI          	18

#define G_TYPE_MAFIA        	19
#define G_TYPE_GANG         	20

#define G_TYPE_FAMILY           21
#define G_TYPE_MOTORS      		22

#define G_TYPE_DRIVING          23
#define G_TYPE_RENTAL           24

#define G_TYPE_COUNT            24

// Group perms
#define G_PERM_CARS       		1
#define G_PERM_DOORS      		2
#define G_PERM_OFFER      		4
#define G_PERM_ORDER      		8
#define G_PERM_CHAT       		16
#define G_PERM_GATE       		32
#define G_PERM_LEADER     		64
#define G_PERM_MAX          	127

// Group flags
#define G_FLAG_IC               1
#define G_FLAG_OOC              2
#define G_FLAG_COLOR            4
#define G_FLAG_DEPARTMENT       8
#define G_FLAG_SPAWN            16
#define G_FLAG_ARREST           32
#define G_FLAG_BLOCADE          64
#define G_FLAG_WEAPONS          128
#define G_FLAG_911              256
#define G_FLAG_RACE             512
#define G_FLAG_LEAVE            1024
#define G_FLAG_TAX              2048
#define G_FLAG_MASK        		4096
#define G_FLAG_TAG              8192
#define G_FLAG_SEARCHING        16384
#define G_FLAG_HANDCUFFS        32768

// ItemTypes
#define ITEM_NONE           	0   // Brak
#define ITEM_WATCH          	1   // Zegarek
#define ITEM_FOOD           	2   // Jedzenie (value1 = iloœæ hp)
#define ITEM_CIGGY          	3   // Papierosy (value1 = iloœæ sztuk)
#define ITEM_CUBE           	4   // Kostka do gry
#define ITEM_CLOTH          	5   // Ubranie (value1 = id skinu)
#define ITEM_WEAPON         	6   // Broñ (value1 = model broni, value2 = amunicja)
#define ITEM_AMMO           	7   // Amunicja (value1 = model broni, value2 = iloœæ amunicji)
#define ITEM_PHONE          	8   // Telefon (value1 = numer telefonu)
#define ITEM_CANISTER       	9   // Karnister (value1 = iloœæ paliwa, value2 = typ paliwa)
#define ITEM_MASK           	10  // Maska
#define ITEM_INHIBITOR      	11  // Paralizator (value2 = iloœæ naboi)
#define ITEM_PAINT          	12  // Lakier (value2 = iloœæ naboi)
#define ITEM_HANDCUFFS      	13  // Kajdanki
#define ITEM_MEGAPHONE      	14  // Megafon
#define ITEM_LINE           	15  // Lina holownicza
#define ITEM_NOTEBOOK       	16  // Notes (value1 = iloœæ karteczek)
#define ITEM_CHIT           	17  // Karteczka (value1 = uid wpisu w bazie)
#define ITEM_TUNING         	18  // Czêœæ tuningu (value1 = id komponentu)
#define ITEM_CHECKBOOK      	19  // Ksia¿eczka czekowa (value1 = iloœæ czeków)
#define ITEM_CHECK          	20  // Czek (value1 = iloœæ pieniêdzy)
#define ITEM_BAG            	21  // Torba
#define ITEM_DRINK          	22  // Napój (value1 = special_action (20 - piwo, 22 - wino, 23 - sprunk))
#define ITEM_VEH_ACCESS         23  // Akcesoria do pojazdu
#define ITEM_DISC               24  // P³yta (value1 = uid wpisu w bazie)
#define ITEM_PLAYER             25  // Odtwarzacz (value1 = uid wpisu w bazie)
#define ITEM_CLOTH_ACCESS       26  // Akcesoria postaci (value1 = uid wpisu w bazie)
#define ITEM_PASS               27  // Karnet (value1 = czas, value2 = uid biznesu)
#define ITEM_CAR_CARD           28  // Karta pojazdu (value1 = model, value2 = w³aœciciel)
#define ITEM_ROLL               29  // Rolki
#define ITEM_MEDICINE           30  // Medykament (value1 = hp)
#define ITEM_DRUG               31  // Narkotyk (value1 = typ narkotyku, value2 = pozosta³e)
#define ITEM_JOINT              32  // Joint (value1 = waga, value2 = jakoœæ [0-3])
#define ITEM_KEYS               33  // Kluczyki (value1 = uid pojazdu)
#define ITEM_GLOVES             34  // Rêkawiczki
#define ITEM_CORPSE             35  // Zw³oki (value1 = uid wpisu w bazie)
#define ITEM_MOLOTOV            36  // Koktajl molotova
#define ITEM_BOOMBOX            37  // Boombox (value1 = uid wpisu w bazie)
#define ITEM_CRAFT              38  // Crafting (value1 = binarka, value2 = typ przedmiotu)
#define ITEM_FLASHLIGHT         39  // Latarka

#define ITEM_COUNT              39  // Liczba typów przedmiotów

// ItemPlaces
#define PLACE_NONE      0
#define PLACE_PLAYER    1
#define PLACE_VEHICLE   2
#define PLACE_BAG       3

// VehicleOwners
#define OWNER_NONE      0
#define OWNER_PLAYER    1
#define OWNER_GROUP     2

// Sessions
#define SESSION_NONE    0
#define SESSION_GAME    1
#define SESSION_AFK   	2
#define SESSION_LOGIN   3
#define SESSION_DUTY    4
#define SESSION_COUNT   5

// Duty
#define DUTY_NONE       0
#define DUTY_ADMIN      1
#define DUTY_GROUP      2
#define DUTY_COUNT      3

// Samouczek
#define HINT_INTRO      1
#define HINT_KEY_NO     2

// InfoDialogTypes
#define D_TYPE_INFO     0
#define D_TYPE_ERROR    1
#define D_TYPE_SUCCESS  2
#define D_TYPE_HELP     3
#define D_TYPE_NO_PERM  4

new second_timer;

new Cache:ground_items_cache[MAX_PLAYERS];

new Iterator:Vehicles<MAX_VEHICLES>;
new Iterator:Groups<MAX_GROUPS>;

new Iterator:PlayerItem[MAX_PLAYERS]<MAX_ITEM_CACHE>;
new Iterator:PlayerGroup[MAX_PLAYERS]<MAX_GROUP_SLOTS>;

new Iterator:CheckedPlayerItem[MAX_PLAYERS]<MAX_ITEM_CACHE>;

enum sPlayer
{
	pUID,
	pGID,
	
	pCharName[32],
	pGlobName[64],
	
	pOnlineTime,
	pSession[SESSION_COUNT],
	
	pCash,
	pBankCash,

	pSkin,
	pHint,
	
	pPremium,
	
	bool: pLogged,
	bool: pSpawned,
	
	pExtra,
	pItemArray[ITEM_COUNT],
	
	bool: pPuttingBag,
	
	bool: pListPlayerGroups,
	
	pLastVehicle,
	
	pSmallTextTime,
	pHintTextTime,
	
	pAFK,
	pAFKTime,
	
	pDuty[DUTY_COUNT],
	
	ORM:pOrm
}
new PlayerCache[MAX_PLAYERS][sPlayer];

enum sVehicle
{
	vUID,
	vGID,
	
	vModel,
	
	Float:vPos[4],
	vCol[2],
	
	vInt,
	vWorld,
	
	vOwnerType,
	vOwner,
	
	Float: vHealth,
	Float: vMileage,
	
	bool: vLocked,
	
	ORM:vOrm
}
new VehicleCache[MAX_VEHICLES][sVehicle];

enum sVehicleModelData
{
	vName[32],
	vMaxSpeed,

	vMaxFuel,
	vMaxPrice
}
new VehicleModelData[212][sVehicleModelData] =
{
	{"Landstalker", 		140, 		70,			0},
	{"Bravura", 			131,		52,			6100},
	{"Buffalo", 			166, 		60,			0},
	{"Linerunner", 			98,  		400,		0},
	{"Pereniel", 			118, 		50,			3300},
	{"Sentinel", 			146, 		52,			12000},
	{"Dumper", 				98,			150,		0},
	{"Firetruck", 			132,		250,		0},
	{"Trashmaster", 		89,			150,		0},
	{"Stretch", 			140,		110,		0},
	{"Manana", 				115,		66,			4000},
	{"Infernus", 			197,		66,			0},
	{"Voodoo", 				150,		52,			0},
	{"Pony", 				98,			80,			0},
	{"Mule", 				94,			120,		0},
	{"Cheetah", 			171,		76,			0},
	{"Ambulance", 			137,		120,		0},
	{"Leviathan", 			399,		408,		0},
	{"Moonbeam", 			103,		80,			0},
	{"Esperanto", 			133,		72,			0},
	{"Taxi", 				129,		80,			0},
	{"Washington", 			137,		82,			0},
	{"Bobcat", 				124,		80,			0},
	{"Mr Whoopee", 			88,			90,			0},
	{"BF Injection", 		120,		30,			0},
	{"Hunter", 				399,		500,		0},
	{"Premier", 			154,		70,			0},
	{"Enforcer", 			147,		120,		0},
	{"Securicar", 			139,		120,		0},
	{"Banshee", 			179,		68,			0},
	{"Predator", 			399,		220,		0},
	{"Bus", 				116,		315,		0},
	{"Rhino", 				84,			1020,		0},
	{"Barracks", 			98,			430,		0},
	{"Hotknife", 			148,		30,			0},
	{"Trailer", 			0,			0,			0},
	{"Previon", 			133,		60,			0},
	{"Coach", 				140,		310,		0},
	{"Cabbie", 				127,		80,			0},
	{"Stallion", 			150,		72,			7900},
	{"Rumpo", 				121,		80,			0},
	{"RC Bandit", 			67,			0,			0},
	{"Romero", 				124,		61,			0},
	{"Packer", 				112,		180,		0},
	{"Monster Truck A", 	98,			162,		0},
	{"Admiral", 			146,		56,			4600},
	{"Squalo", 				399,		101,		0},
	{"Seasparrow", 			399,		140,		0},
	{"Pizzaboy",			162,		7,			0},
	{"Tram", 				399,		0,			0},
	{"Trailer", 			399,		0,			0},
	{"Turismo", 			172,		78,			0},
	{"Speeder", 			399,		111,		0},
	{"Reefer", 				399,		201,		0},
	{"Tropic", 				399,		221,		0},
	{"Flatbed", 			140,		198,		0},
	{"Yankee", 				94,			101,		0},
	{"Caddy", 				84,			15,			0},
	{"Solair", 				140,		70,			0},
	{"Berkleys RC Van",		121,		84,			0},
	{"Skimmer", 			399,		30,			0},
	{"PCJ-600", 			180,		25,			0},
	{"Faggio", 				155,		7,			1800},
	{"Freeway", 			180,		25,			0},
	{"RC Baron", 			399,		0,			0},
	{"RC Raider", 			399,		0,			0},
	{"Glendale", 			131,		71,			0},
	{"Oceanic", 			125,		61,			0},
	{"Sanchez", 			164,		27,			0},
	{"Sparrow", 			399,		50,			0},
	{"Patriot", 			139,		110,		0},
	{"Quad", 				98,			35,			0},
	{"Coastguard", 			399,		110,		0},
	{"Dinghy", 				399,		69,			0},
	{"Hermes", 				133,		70,			0},
	{"Sabre", 				154,		71,			0},
	{"Rustler", 			399,		68,			0},
	{"ZR-350", 				166,		69,			0},
	{"Walton", 				105,		45,			0},
	{"Regina", 				124,		61,			5200},
	{"Comet", 				164,		67,			0},
	{"BMX", 				86,			0,			0},
	{"Burrito", 			139,		96,			0},
	{"Camper", 				109,		75,			0},
	{"Marquis", 			399,		87,			0},
	{"Baggage", 			88,			40,			0},
	{"Dozer", 				56,			141,		0},
	{"Maverick", 			399,		123,		0},
	{"News Chopper", 		399,		121,		0},
	{"Rancher", 			124,		91,			0},
	{"FBI Rancher", 		139,		101,		0},
	{"Virgo", 				132,		81,			0},
	{"Greenwood", 			125,		62,			7100},
	{"Jetmax", 				399,		130,		0},
	{"Hotring", 			191,		99,			0},
	{"Sandking", 			157,		81,			0},
	{"Blista Compact", 		145,		61,			0},
	{"Police Maverick", 	399,		140,		0},
	{"Boxville", 			96,			121,		0},
	{"Benson", 				109,		104,		0},
	{"Mesa", 				125,		71,			0},
	{"RC Goblin", 			399,		0,			0},
	{"Hotring Racer", 		191,		96,			0},
	{"Hotring Racer", 		191,		97,			0},
	{"Bloodring Banger",	154,		91,			0},
	{"Rancher", 			124,		84,			0},
	{"Super GT", 			159,		67,			0},
	{"Elegant", 			148,		81,			0},
	{"Journey", 			96,			133,		0},
	{"Bike", 				93,			0,			650},
	{"Mountain Bike", 		117,		0,			0},
	{"Beagle", 				399,		210,		0},
	{"Cropdust", 			399,		130,		0},
	{"Stunt", 				399,		54,			0},
	{"Tanker", 				107,		300,		0},
	{"RoadTrain", 			126,		300,		0},
	{"Nebula", 				140,		63,			7400},
	{"Majestic", 			140,		64,			0},
	{"Buccaneer", 			146,		67,			0},
	{"Shamal", 				399,		300,		0},
	{"Hydra", 				399,		290,		0},
	{"FCR-900", 			190,		35,			0},
	{"NRG-500", 			200,		35,			0},
	{"HPV1000", 			172,		40,			0},
	{"Cement Truck", 		116,		91,			0},
	{"Tow Truck", 			143,		65,			0},
	{"Fortune", 			140,		63,			0},
	{"Cadrona", 			133,		71,			0},
	{"FBI Truck", 			157,		71,			0},
	{"Willard", 			133,		67,			8000},
	{"Forklift", 			54,			12,			0},
	{"Tractor", 			62,			21,			0},
	{"Combine", 			98,			36,			0},
	{"Feltzer", 			148,		61,			0},
	{"Remington", 			150,		71,			0},
	{"Slamvan", 			140,		85,			0},
	{"Blade", 				154,		69,			0},
	{"Freight", 			399,		0,			0},
	{"Streak", 				399,		0,			0},
	{"Vortex", 				89,			33,			0},
	{"Vincent", 			136,		60,			9600},
	{"Bullet", 				180,		71,			0},
	{"Clover", 				146,		69,			0},
	{"Sadler", 				134,		60,			0},
	{"Firetruck", 			132,		120,		0},
	{"Hustler", 			131,		74,			5500},
	{"Intruder", 			133,		64,			6100},
	{"Primo", 				127,		67,			8600},
	{"Cargobob", 			399,		210,		0},
	{"Tampa", 				136,		71,			0},
	{"Sunrise", 			128,		64,			0},
	{"Merit", 				140,		64,			0},
	{"Utility", 			108,		68,			0},
	{"Nevada", 				399,		330,		0},
	{"Yosemite", 			128,		81,			0},
	{"Windsor", 			141,		61,			0},
	{"Monster Truck B", 	98,			123,		0},
	{"Monster Truck C", 	98,			124,		0},
	{"Uranus", 				139,		61,			0},
	{"Jester", 				158,		63,			0},
	{"Sultan", 				150,		71,			0},
	{"Stratum", 			137,		74,			0},
	{"Elegy", 				158,		66,			0},
	{"Raindance", 			399,		210,		0},
	{"RC Tiger", 			79,			0,			0},
	{"Flash", 				146,		57,			0},
	{"Tahoma",				142,		65,			7800},
	{"Savanna", 			154,		66,			0},
	{"Bandito", 			130,		45,			0},
	{"Freight", 			399,		0,			0},
	{"Trailer", 			399,		0,			0},
	{"Kart", 				83,			10,			0},
	{"Mower", 				54,			10,			0},
	{"Duneride", 			98,			121,		0},
	{"Sweeper", 			53,			21,			0},
	{"Broadway", 			140,		71,			0},
	{"Tornado", 			140,		75,			0},
	{"AT-400", 				399,		900,		0},
	{"DFT-30", 				116,		210,		0},
	{"Huntley", 			140,		85,			0},
	{"Stafford", 			136,		80,			0},
	{"BF-400", 				170,		31,			0},
	{"Newsvan", 			121,		81,			0},
	{"Tug", 				76,			20,			0},
	{"Trailer", 			399,		0,			0},
	{"Emperor", 			136,		64,			0},
	{"Wayfarer", 			175,		30,			0},
	{"Euros", 				147,		66,			0},
	{"Hotdog",				96,			79,			0},
	{"Club", 				145,		59,			0},
	{"Trailer", 			399,		0,			0},
	{"Trailer", 			399,		0,			0},
	{"Andromada", 			399,		0,			0},
	{"Dodo", 				399,		110,		0},
	{"RC Cam", 				54,			0,			0},
	{"Launch",				399,		151,		0},
	{"Police Car",			156,		89,			0},
	{"Police Car", 			156,		89,			0},
	{"Police Car", 			156,		89,			0},
	{"Police Ranger", 		140,		94,			0},
	{"Picador", 			134,		61,			0},
	{"S.W.A.T. Van", 		98,			120,		0},
	{"Alpha", 				150,		61,			0},
	{"Phoenix", 			152,		59,			0},
	{"Glendale Shit", 		131,		91,			0},
	{"Sadler Shit", 		134,		64,			0},
	{"Luggage Trailer", 	399,		0,			0},
	{"Luggage Trailer", 	399,		0,			0},
	{"Stair Trailer", 		399,		0,			0},
	{"Boxville", 			96,			99,			0},
	{"Farm Plow", 			399,		0,			0},
	{"Utility Trailer", 	399,		0,			0}
};

enum sPlayerItem
{
	iUID,
	iName[32],
	
	iValue[2],
	
	iPlace,
	iOwner,
	
	iType,
	
	bool: iUsed,
	bool: iChecked,
	bool: iFavorite,
	
	ORM:iOrm
}
new PlayerItemCache[MAX_PLAYERS][MAX_ITEM_CACHE][sPlayerItem];

enum sItemTypeInfo
{
	iTypeName[32],
	iTypeWeight,

	iTypeObjModel,

	Float:iTypeObjRotX,
	Float:iTypeObjRotY
}
new ItemTypeInfo[][sItemTypeInfo] =
{
	/* nazwa | 	waga | model | rotx | roty   */
	{"Nieokreœlony",	50, 	328,   	90.0,   95.0},
	{"Zegarek",			80, 	2710, 	0.0,  	0.0},
	{"Jedzenie",        160,    2769,   0.0,    0.0},
	{"Papierosy",       10,    	1485,   0.0,    0.0},
	{"Kostka do gry",   10,    	328,   	90.0,   95.0},
	{"Ubranie",         380,    2843,   0.0,    0.0},
	{"Broñ",            0,      0,      0.0,    0.0},
	{"Amunicja",        230,    328,    90.0,   95.0},
	{"Telefon",         120,    330, 	90.0,  	0.0},
	{"Kanister",        240,   	1650,   90.0,   0.0},
	{"Maska",           210,    328, 	90.0,	95.0},
	{"Paralizator",     0,    	0,      0.0,    0.0},
	{"Lakier",          0,    	0,      0.0,    0.0},
	{"Kajdanki",        330,    19418, 	90.0, 	0.0},
	{"Megafon",         260,    328, 	90.0, 	95.0},
	{"Lina",            180,	328, 	90.0, 	95.0},
	{"Notatnik",        60,     2894, 	0.0,  	0.0},
	{"Karteczka",       10,     328, 	90.0, 	95.0},
	{"Tuning",          6800,   328, 	90.0, 	95.0},
	{"Ks. czekowa",     60,     2894, 	0.0,  	0.0},
	{"Czek",            10,     328, 	90.0, 	95.0},
	{"Torba",           90,     2663, 	90.0,  	0.0},
	{"Napój",           520,    328, 	90.0, 	95.0},
	{"Akcesorie", 		1040,   328,    90.0,   95.0},
	{"P³yta",           140,    1961,   90.0,   180.0},
	{"Odtwarzacz",      240,    328,    90.0,   95.0},
	{"Przyczepialny",   210,    328,    90.0,   95.0},
	{"Karnet",          10,     328,    90.0,   95.0},
	{"Karta pojazdu",   10,     328,    90.0,   95.0},
	{"Rolki",           230,    328,    90.0,   95.0},
	{"Medykament",      30,     328,    90.0,   95.0},
	{"U¿ywka",          1,      328,    90.0,   95.0},
	{"Joint",           1,      328,    90.0,   95.0},
	{"Kluczyki",        60,     328,    90.0,   95.0},
	{"Rêkawiczki",      180,    328,    90.0,   95.0},
	{"Zw³oki",          7500,   2060,   0.0,    0.0},
	{"Molotova",        500,    344,    80.0,   0.0},
	{"Boombox",         1350,   2226,   0.0,    0.0},
	{"Craft",           320,    328,    90.0,   0.0},
	{"Latarka",         150,    18641,  90.0,   0.0}
};

enum sGroupCache
{
	gUID,
	gName[32],
	
	gType,
	gCash,
	
	gTag[5],
	
	gColor,
	gFlags,
	
	gOwner,
	
	ORM:gOrm
}
new GroupCache[MAX_GROUPS][sGroupCache];

enum sPlayerGroup
{
	gpUID,
	gpID,

	gpPerm,
	gpTitle[32],

	gpPayment,
	gpSkin,

	bool: gpTogG
}
new PlayerGroup[MAX_PLAYERS][MAX_GROUP_SLOTS][sPlayerGroup];

enum sGroupTypeInfo
{
	gTypeName[24],
	gTypeMaxDotation,

	gTypePrice,
	gTypeFlags
}
new GroupTypeInfo[][sGroupTypeInfo] =
{
	{"Nieokreœlony",			0,		2000,		G_FLAG_OOC | G_FLAG_TAX},
	{"24/7",					100,	5000,		G_FLAG_OOC | G_FLAG_TAX},
	{"Gastronomia",				300,	9000,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},
	{"Stacja benzynowa",		300,	12000,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},
	{"Si³ownia",				300,	7000,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},
	{"Salon samochodowy",		300,	12500,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},
	{"Firma taksówkarska",		300,	12500,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},
	{"Ciucholand",				0,		8000,		G_FLAG_OOC | G_FLAG_TAX},
	{"Warsztat",				300,	10000,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},
	{"Hotel",					150,	5500,		G_FLAG_OOC | G_FLAG_TAX},
	{"Bank",					0,		6000,		G_FLAG_OOC | G_FLAG_TAX},
	{"Ochrona",					300,	11000,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},

	{"Police",					900,	0,			G_FLAG_IC | G_FLAG_OOC | G_FLAG_COLOR | G_FLAG_DEPARTMENT | G_FLAG_ARREST | G_FLAG_BLOCADE | G_FLAG_WEAPONS | G_FLAG_911 | G_FLAG_MASK | G_FLAG_SEARCHING | G_FLAG_HANDCUFFS},
	{"Government",				700,	0,			G_FLAG_IC | G_FLAG_OOC | G_FLAG_COLOR | G_FLAG_DEPARTMENT},
	{"Medical",					1100,	0,			G_FLAG_IC | G_FLAG_OOC | G_FLAG_COLOR | G_FLAG_DEPARTMENT},
	{"San News",				500,	0,			G_FLAG_IC | G_FLAG_OOC | G_FLAG_COLOR},
	{"Armia",					600,	0,			G_FLAG_IC | G_FLAG_OOC | G_FLAG_COLOR | G_FLAG_DEPARTMENT | G_FLAG_ARREST | G_FLAG_BLOCADE | G_FLAG_WEAPONS | G_FLAG_MASK | G_FLAG_SEARCHING | G_FLAG_HANDCUFFS},
	{"Fire Department",			900,	0,			G_FLAG_IC | G_FLAG_OOC | G_FLAG_COLOR | G_FLAG_DEPARTMENT | G_FLAG_BLOCADE},
	{"FBI",						1250,	0,			G_FLAG_IC | G_FLAG_OOC | G_FLAG_COLOR | G_FLAG_DEPARTMENT | G_FLAG_ARREST | G_FLAG_BLOCADE | G_FLAG_WEAPONS | G_FLAG_MASK | G_FLAG_SEARCHING | G_FLAG_HANDCUFFS},

	{"Mafia",					0,		0,			G_FLAG_OOC | G_FLAG_SPAWN | G_FLAG_MASK | G_FLAG_SEARCHING},
	{"Gang",					200,	0,			G_FLAG_OOC | G_FLAG_SPAWN | G_FLAG_MASK | G_FLAG_TAG | G_FLAG_SEARCHING},

	{"Rodzina",                 0,      0,          G_FLAG_OOC | G_FLAG_SPAWN},
	{"Zmotoryzowana",           0,      0,          G_FLAG_OOC | G_FLAG_SPAWN | G_FLAG_RACE},

	{"Szko³a jazdy",            300,    9000,       G_FLAG_OOC | G_FLAG_TAX},
	{"Wypo¿yczalnia",           300,    9800,      	G_FLAG_OOC | G_FLAG_TAX}
};


enum sWeaponInfoData
{
	wModel,
	wWeight
}
new WeaponInfoData[][sWeaponInfoData] =
{
	{0,		0},
	{331,	70},
	{333,	230},
	{334,	190},
	{335,	60},
	{336,	250},
	{337,	290},
	{338,	140},
	{339,	270},
	{341,	3600},
	{321,	140},
	{322,	50},
	{323,	60},
	{324,	90},
	{325,	40},
	{326,	110},
	{342,	80},
	{343,	90},
	{344,	120},
	{0,		0},
	{0,		0},
	{0,		0},
	{346,	460},
	{347,	490},
	{348,	540},
	{349,	2400},
	{350,	2100},
	{351,	2600},
	{352,	890},
	{353,	1900},
	{355,	3200},
	{356,	3600},
	{372,	1100},
	{357,	2500},
	{358,	2900},
	{359,	8600},
	{360,	8300},
	{361,	4900},
	{362,	9400},
	{363,	450},
	{364,	90},
	{365,	480},
	{366,	2600},
	{367,	80},
	{368,	200},
	{369,	200},
	{371,	360}
};

enum sPosData
{
	Float:sPosX,
	Float:sPosY,
	Float:sPosZ,
	Float:sPosA,

	sPosInterior,
	sPosVirtualWorld,
}
new PosInfo[][sPosData] =
{
	{1743.0033,	-1862.8491,	13.5758,	359.7995, 	0, 0},
	{154.1221, 	-1951.9156, 47.8750,	  	0.0, 	0, 0},
	{2233.6584,	-1113.2397,	1050.8828,	 2.7833,  	5, 0}
};

new MySQL:MysqlHandle;

new Text:TD_GroupOption[6][MAX_GROUP_SLOTS];

new PlayerText:TD_SmallInfo[MAX_PLAYERS];
new PlayerText:TD_Hint[MAX_PLAYERS];

new PlayerText:TD_MainGroupTag[MAX_PLAYERS][MAX_GROUP_SLOTS];
new PlayerText:TD_MainGroupName[MAX_PLAYERS][MAX_GROUP_SLOTS];

forward OnSecondTimer();

forward ListPlayerItems(playerid);
forward ListPlayerNearItems(playerid);
forward ListPlayerCheckedItems(playerid);
forward ListPlayerFavoriteItems(playerid);
forward ListPlayerItemsForPlayer(playerid, giveplayer_id);

forward LoadPlayerItems(playerid);
forward LoadPlayerItem(playerid, item_uid);

forward UnloadPlayerItems(playerid);
forward UnloadPlayerItem(playerid, itemid);

forward CreatePlayerItem(playerid, item_name[32], item_type, item_value1, item_value2);
forward DeletePlayerItem(playerid, itemid);

forward OnPlayerUseItem(playerid, itemid);
forward OnPlayerDropItem(playerid, itemid);
forward OnPlayerRaiseItem(playerid, item_uid);

forward ShowPlayerItemInfo(playerid, item_uid);

forward ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5);

forward OnPlayerLogin(playerid);
forward SetPlayerSpawn(playerid);

forward ShowPlayerStatsForPlayer(playerid, giveplayer_id);

forward OnCreateVehicle(modelid, Float:cpos_x, Float:cpos_y, Float:cpos_z, Float:cpos_a, col1, col2);
forward LoadVehicles();
forward LoadVehicle(veh_uid);
forward DeleteVehicle(veh_uid);
forward UnloadVehicle(veh_uid);

forward OnVehicleHealthStatusChange(driverid, vehicleid, Float:health);

forward CreateGroup(group_name[32], group_type);
forward LoadGroups();
forward DeleteGroup(group_id);
forward LoadPlayerGroups(playerid);
forward UnloadPlayerGroups(playerid);
forward ShowPlayerGroupOptions(playerid);
forward HidePlayerGroupOptions(playerid);

forward query_OnLoadPlayerGroups(playerid);
forward query_OnLoadGroups();

forward query_OnLoadVehicle();
forward query_OnLoadVehicles();

forward query_OnLoadPlayerItems(playerid);
forward query_OnListPlayerNearItems(playerid);

forward query_OnListPlayerBagItems(playerid);
forward query_OnListPlayerVehicles(playerid);

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	MysqlHandle = mysql_connect(SQL_HOST, SQL_USER, SQL_PASS, SQL_DTBS);

	Iter_Init(PlayerItem);
	Iter_Init(PlayerGroup);
	Iter_Init(CheckedPlayerItem);
	
	LoadVehicles();
	LoadGroups();

	SetGameModeText(""GAMEMODE" ver. "VERSION"");
	
	mysql_log();
	
	AllowInteriorWeapons(false);
	ShowNameTags(false);

    ShowPlayerMarkers(false);
	EnableStuntBonusForAll(false);

    CreateGlobalTD();
	DisableInteriorEnterExits();
	ManualVehicleEngineAndLights();
	
	second_timer = SetPreciseTimer("OnSecondTimer", 1000, true);
	return 1;
}

public OnGameModeExit()
{
	mysql_close();
	DeletePreciseTimer(second_timer);
	return 1;
}

public OnSecondTimer()
{
	new time, hour, minute, second;
	time = gettime(hour, minute, second);

	foreach(new i : Player)
	{
 		if(PlayerCache[i][pSmallTextTime] && time > PlayerCache[i][pSmallTextTime])
	    {
	        TD_HideSmallInfo(i);
	    }
	    
	    if(PlayerCache[i][pHintTextTime] > 0 && time > PlayerCache[i][pHintTextTime])
	    {
	        TD_HideHint(i);
	    }
	    
		if(!PlayerCache[i][pLogged] && (time - PlayerCache[i][pSession][SESSION_LOGIN]) > 30)
		{
			ShowPlayerInfoDialog(i, D_TYPE_ERROR, "Czas logowania zosta³ przekroczony.\nZostajesz wyrzucony z serwera, spróbuuj ponownie i nastêpnym razem nie zwlekaj!");
			defer OnKickPlayer(i);
			continue;
		}
	    
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        PlayerCache[i][pAFK] ++;
	        if(PlayerCache[i][pAFK] >= 0 && PlayerCache[i][pAFKTime] == 0)
	        {
	            PlayerCache[i][pAFKTime] = time;
	        }
	        
	        if(IsPlayerInAnyVehicle(i))
	        {
	            if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
	            {
	                new vehid = PlayerCache[i][pLastVehicle],
	                    vehicleid = VehicleCache[vehid][vGID], Float:vehHealth;
	                    
					// SILNIK W£¥CZONY
					if(GetVehicleEngineStatus(vehicleid))
					{
						GetVehicleHealth(vehicleid, vehHealth);
						if(vehHealth > VehicleCache[vehid][vHealth])    SetVehicleHealth(vehicleid, VehicleCache[vehid][vHealth]);
						if(vehHealth < VehicleCache[vehid][vHealth])	CallLocalFunction("OnVehicleHealthStatusChange", "ddf", i, vehicleid, vehHealth);
					}
				}
	        }
	    }
	}

	// OnMinuteTimer
	if(second % 60 == 0)
	{
	    
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	for(new session_id = 0; session_id != SESSION_COUNT; session_id++)	PlayerCache[playerid][pSession][session_id] = 0;
	for(new sPlayer:e; e < sPlayer; ++e)					PlayerCache[playerid][e] = 0;

    GetPlayerName(playerid, PlayerCache[playerid][pCharName], 32);
    new ORM:orm_id = PlayerCache[playerid][pOrm] = orm_create("myrp_characters", MysqlHandle);
    
    orm_addvar_int(orm_id, PlayerCache[playerid][pUID], "char_uid");
    orm_addvar_int(orm_id, PlayerCache[playerid][pGID], "char_gid");
    
    orm_addvar_string(orm_id, PlayerCache[playerid][pCharName], 32, "char_name");
    
	orm_addvar_int(orm_id, PlayerCache[playerid][pOnlineTime], "char_time");
	
	orm_addvar_int(orm_id, PlayerCache[playerid][pCash], "char_cash");
	orm_addvar_int(orm_id, PlayerCache[playerid][pBankCash], "char_bankcash");
	
	orm_addvar_int(orm_id, PlayerCache[playerid][pSkin], "char_skin");
	orm_addvar_int(orm_id, PlayerCache[playerid][pHint], "char_hint");
	
    orm_setkey(orm_id, "char_name");
	
	CreateTDForPlayer(playerid);
	
	PlayerCache[playerid][pSession][SESSION_LOGIN] = gettime();
	ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Panel logowania", "Witaj na "SERVER_NAME"!\n\nWprowadŸ poni¿ej has³o do postaci, by rozpocz¹æ grê na naszym serwerze.\nUpewnij siê, ¿e postaæ zosta³a za³o¿ona na naszej stronie "WEB_URL".", "Zaloguj", "Zmieñ nick");
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(!PlayerCache[playerid][pLogged])
	{
	    return 1;
	}
	
	PlayerCache[playerid][pOnlineTime] += (gettime() - PlayerCache[playerid][pSession][SESSION_GAME]) - PlayerCache[playerid][pSession][SESSION_AFK];

	UnloadPlayerItems(playerid);
	UnloadPlayerGroups(playerid);
	
	orm_update(PlayerCache[playerid][pOrm]);
	orm_destroy(PlayerCache[playerid][pOrm]);
	return 1;
}

public OnPlayerLogin(playerid)
{
	new ORM:orm_id = PlayerCache[playerid][pOrm];
	switch(orm_errno(orm_id))
	{
		case ERROR_OK:
	 	{
     		orm_apply_cache(orm_id, 0, 0);
	  		orm_setkey(orm_id, "char_uid");
	  		
	  		PlayerCache[playerid][pLogged] = true;
	  		
	  		PlayerCache[playerid][pSession][SESSION_LOGIN] 	= 0;
	  		PlayerCache[playerid][pSession][SESSION_GAME] 	= gettime();
	  		
	  		PlayerCache[playerid][pAFK] = -3;
	  		
	    	LoadPlayerItems(playerid);
	    	LoadPlayerGroups(playerid);

			SendClientFormatMessage(playerid, COLOR_WHITE, "Zalogowano siê pomyœlnie - %s (UID: %d, GID: %d).", PlayerName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID]);
			
			SetPlayerMoney(playerid, PlayerCache[playerid][pCash]);
			SetPlayerSpawn(playerid);
	    }
	    case ERROR_NO_DATA:
	    {
	    	ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Panel logowania", "Witaj na "SERVER_NAME"!\n\nWprowadŸ poni¿ej has³o do postaci, by rozpocz¹æ grê na naszym serwerze.\nUpewnij siê, ¿e postaæ zosta³a za³o¿ona na naszej stronie "WEB_URL".", "Zaloguj", "Zmieñ nick");
			TD_ShowSmallInfo(playerid, 5, "Postac ~r~nie istnieje ~w~w bazie danych lub wprowadzone haslo jest nieprawidlowe.");
		}
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
    PlayerCache[playerid][pSpawned] = true;
	return 1;
}

public SetPlayerSpawn(playerid)
{
    SetSpawnInfo(playerid, 0, PlayerCache[playerid][pSkin], PosInfo[0][sPosX], PosInfo[0][sPosY], PosInfo[0][sPosZ], PosInfo[0][sPosA], 0, 0, 0, 0, 0, 0);

	SetPlayerInterior(playerid, PosInfo[0][sPosInterior]);
	SetPlayerVirtualWorld(playerid, PosInfo[0][sPosVirtualWorld]);
    
    TD_ShowHint(playerid, HINT_INTRO, -1, "Witaj na ~y~"SERVER_NAME"~w~! To jest samouczek, ktory pomoze Ci zapoznac sie dokladnie z ~b~funkcjonalnosciami ~w~skryptu.~n~~n~Kazda akcja, ktora wykonujesz bedzie monitorowana przez ~y~samouczka~w~, a ten wyswietli Ci najwazniejsze informacje.~n~~n~Wcisnij teraz klawisz ~y~N~w~.");
    
    SpawnPlayer(playerid);
	return 1;
}

public ShowPlayerStatsForPlayer(playerid, giveplayer_id)
{
	new list_stats[512] = "Statystyki\tTytu³", title[64], ip_address[16],
	    hours, minutes, seconds, Float:health;
	    
	GetPlayerIp(playerid, ip_address, sizeof(ip_address));
	GetPlayerHealth(playerid, health);
	
	PlayerOnlineTime(playerid, hours, minutes, seconds);

	format(list_stats, sizeof(list_stats), "%s\n%d:%d\tidentyfikator postaci/globalny", list_stats, PlayerCache[playerid][pUID], PlayerCache[playerid][pGID]);
	format(list_stats, sizeof(list_stats), "%s\n%dh, %dm, %ds\t³¹czny czas gry", list_stats, hours, minutes, seconds);

	format(list_stats, sizeof(list_stats), "%s\n$%d:$%d\tstan portfela/konta bankowego", list_stats, PlayerCache[playerid][pCash], PlayerCache[playerid][pBankCash]);
	format(list_stats, sizeof(list_stats), "%s\n%d\tnumer karty kredytowej", list_stats, 0);
	
	format(list_stats, sizeof(list_stats), "%s\n%.1f\tstan zdrowia", list_stats, health);
	format(list_stats, sizeof(list_stats), "%s\n%d:%d\tskin obecny/ostatni", list_stats, GetPlayerSkin(playerid), GetPlayerSkin(playerid));
	
	
	format(title, sizeof(title), "Statystyki: %s [IP: %s]", PlayerName(playerid), ip_address);
	ShowPlayerDialog(giveplayer_id, D_NONE, DIALOG_STYLE_TABLIST_HEADERS, title, list_stats, "OK", "");
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

cmd:test(playerid, params[])
{
	CallLocalFunction("ShowPlayerGroupOptions", "d", playerid);
	return 1;
}

cmd:test2(playerid, params[])
{
	ShowPlayerStatsForPlayer(playerid, playerid);
	return 1;
}

cmd:pojazd(playerid, params[])
{
	new type[24], varchar[64];
	if(sscanf(params, "s[24]S()[64]", type, varchar))
	{
		new query[256];
		mysql_format(MysqlHandle, query, sizeof(query), "SELECT `veh_uid`, `veh_model` FROM `myrp_vehicles` WHERE veh_ownertype = '%d' AND veh_owner = '%d'", OWNER_PLAYER, PlayerCache[playerid][pUID]);
		mysql_tquery(MysqlHandle, query, "query_OnListPlayerVehicles", "d", playerid);
		return 1;
	}
	
	if(!strcmp(type, "namierz", true) || !strcmp(type, "target", true))
	{
 		new list_vehicles[256] = "Identyfikator\tNazwa pojazdu",
		 	vehicle_counts;
 		
		foreach(new vehid : Vehicles)
		{
			if(VehicleCache[vehid][vOwnerType] == OWNER_PLAYER && VehicleCache[vehid][vOwner] == PlayerCache[playerid][pUID])
		    {
		        vehicle_counts ++;
		        format(list_vehicles, sizeof(list_vehicles), "%s\n%d\t%s", list_vehicles, VehicleCache[vehid][vUID], GetVehicleName(VehicleCache[vehid][vModel]));
			}
	    }
	    if(vehicle_counts > 0)
	    {
	        ShowPlayerDialog(playerid, D_VEH_TARGET, DIALOG_STYLE_TABLIST_HEADERS, "Pojazdy zespawnowane:", list_vehicles, "Namierz", "Anuluj");
	    }
	    else
	    {
	        TD_ShowSmallInfo(playerid, 5, "Nie posiadasz zadnego ~r~zespawnowanego ~w~pojazdu.");
	    }
	    return 1;
	}
	
	if(!strcmp(type, "zaparkuj", true) || !strcmp(type, "parkuj", true))
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowaæ siê w pojeŸdzie jako kierowca, by móc go zaparkowaæ.");
	        return 1;
	    }
	    
	    new vehid = GetVehicleIndex(GetPlayerVehicleID(playerid));
		if(vehid == INVALID_VEHICLE_ID)	return 1;
		
		if(VehicleCache[vehid][vOwnerType] == OWNER_PLAYER && VehicleCache[vehid][vOwner] != PlayerCache[playerid][pUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jesteœ w³aœcicielem tego pojazdu.");
		    return 1;
		}
		
  		if(VehicleCache[vehid][vOwnerType] == OWNER_GROUP && !HavePlayerGroupPerm(playerid, VehicleCache[vehid][vOwner], G_PERM_LEADER))
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jesteœ liderem grupy, do której przypisany jest pojazd.");
     		return 1;
	    }

		new veh_uid = VehicleCache[vehid][vUID], seatid = GetPlayerVehicleSeat(playerid);
		
		GetVehiclePos(VehicleCache[vehid][vGID], VehicleCache[vehid][vPos][0], VehicleCache[vehid][vPos][1], VehicleCache[vehid][vPos][2]);
		GetVehicleZAngle(VehicleCache[vehid][vGID], VehicleCache[vehid][vPos][3]);
		
		VehicleCache[vehid][vInt] 	= GetPlayerInterior(playerid);
		VehicleCache[vehid][vWorld] = GetPlayerVirtualWorld(playerid);
		
		orm_update(VehicleCache[vehid][vOrm]);
		UnloadVehicle(veh_uid);
		
		LoadVehicle(veh_uid);
		defer OnPlayerPutVehicle(playerid, seatid, veh_uid);
		
		TD_ShowSmallInfo(playerid, 5, "Pojazd zostal ~y~zaparkowany ~w~pomyslnie.");
	    return 1;
	}
	
	if(!strcmp(type, "silnik", true))
	{
 		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowaæ siê w pojeŸdzie jako kierowca, by to zrobiæ.");
	        return 1;
	    }
	    
	    new vehicleid = GetPlayerVehicleID(playerid), vehid = GetVehicleIndex(vehicleid);
		if(vehid == INVALID_VEHICLE_ID)	return 1;
		
		if(GetVehicleEngineStatus(vehicleid))
		{
            ChangeVehicleEngineStatus(vehicleid, false);
            TD_ShowSmallInfo(playerid, 0, "Aby uruchomic silnik, wcisnij ~y~~k~~VEHICLE_FIREWEAPON_ALT~~w~ + ~y~~k~~SNEAK_ABOUT~~w~.~n~Klawisz ~y~~k~~VEHICLE_FIREWEAPON~ ~w~kontroluje swiatla w pojezdzie.");
		}
		else
		{
 			if(VehicleCache[vehid][vOwnerType] == OWNER_PLAYER)
			{
			    if(VehicleCache[vehid][vOwner] != PlayerCache[playerid][pUID] && !HavePlayerItemType(playerid, ITEM_KEYS, VehicleCache[vehid][vUID]))
			    {
		 			ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz kluczyków do tego pojazdu.");
					return 1;
				}
			}

	  		if(VehicleCache[vehid][vOwnerType] == OWNER_GROUP && !HavePlayerGroupPerm(playerid, VehicleCache[vehid][vOwner], G_PERM_CARS))
	    	{
	     		ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz kluczyków do tego pojazdu.");
	     		return 1;
		    }
		    
	    	if(VehicleCache[vehid][vHealth] <= 300)
			{
	    		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Silnik w tym pojeŸdzie zosta³ ca³kowicie zniszczony.\nOdholuj pojazd do pobliskiego warsztatu, by go zreperowaæ.");
   				return 1;
			}
		    
 	    	new started_time = 4000 - floatround(VehicleCache[vehid][vHealth]);

 			GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~g~Trwa uruchamianie silnika...", started_time, 3);
 			defer OnVehicleEngineStarted[started_time](vehicleid);
		}
	    return 1;
	}
	return 1;
}
alias:pojazd("v", "veh", "vehicles");

cmd:apojazd(playerid, params[])
{
	new type[24], varchar[64], string[128];
	if(sscanf(params, "s[24]S()[64]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/apojazd [stworz]");
	    return 1;
	}
	
	if(!strcmp(type, "stworz", true) || !strcmp(type, "stwórz", true) || !strcmp(type, "create", true))
	{
	    new veh_model, veh_color1, veh_color2;
	    if(sscanf(varchar, "k<vehicle>dd", veh_model, veh_color1, veh_color2))
	    {
	        ShowTipForPlayer(playerid, "/apojazd stworz [Model/Nazwa pojazdu] [Kolor1] [Kolor2]");
	        return 1;
	    }
	    
     	new Float:PosX, Float:PosY, Float:PosZ, vehid;

        GetPlayerPos(playerid, PosX, PosY, PosZ);
        vehid = OnCreateVehicle(veh_model, PosX, PosY, PosZ, 0.0, veh_color1, veh_color2);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd zosta³ stworzony pomyœlnie (UID: %d).", VehicleCache[vehid][vUID]);
	    return 1;
	}
	
	if(!strcmp(type, "przypisz", true) || !strcmp(type, "assign", true))
	{
		new veh_uid, owner_type[24], varchar2[24];
		if(sscanf(varchar, "ds[24]S()[24]", veh_uid, owner_type, varchar2))
		{
		    ShowTipForPlayer(playerid, "/apojazd przypisz [UID pojazdu] [Typ (gracz, grupa)]");
		    return 1;
		}
		new vehid = GetVehicleID(veh_uid);
		if(vehid == INVALID_VEHICLE_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Pojazd z tym UID nie istnieje b¹dŸ nie zosta³ zespawnowany.");
		    return 1;
		}
  		if(!strcmp(owner_type, "gracz", true) || !strcmp(owner_type, "player", true))
	    {
	        new giveplayer_id;
			if(sscanf(varchar2, "u", giveplayer_id))
			{
			    ShowTipForPlayer(playerid, "/apojazd przypisz %d gracz [ID gracza]", veh_uid);
			    return 1;
			}
			if(giveplayer_id == INVALID_PLAYER_ID)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b³êdne ID gracza.");
			    return 1;
			}
			if(!PlayerCache[giveplayer_id][pLogged])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
			    return 1;
			}
			
			VehicleCache[vehid][vOwnerType] = OWNER_PLAYER;
			VehicleCache[vehid][vOwner] = PlayerCache[giveplayer_id][pUID];
			
			orm_update(VehicleCache[vehid][vOrm]);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd %s (UID: %d) zosta³ przypisany pomyœlnie.\n\nTyp w³aœciciela: gracz\nW³aœciciel: %s (ID: %d, UID: %d).", GetVehicleName(VehicleCache[vehid][vModel]), VehicleCache[vehid][vUID], PlayerName(giveplayer_id), giveplayer_id, PlayerCache[giveplayer_id][pUID]);
			return 1;
		}
		if(!strcmp(owner_type, "grupa", true) || !strcmp(owner_type, "group", true))
		{
		    new group_uid;
		    if(sscanf(varchar2, "d", group_uid))
		    {
		        ShowTipForPlayer(playerid, "/apojazd przypisz %d grupa [UID grupy]", veh_uid);
		        return 1;
		    }
		    new group_id = GetGroupID(group_uid);
 	    	if(group_id == INVALID_GROUP_ID)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b³êdne UID grupy.");
		        return 1;
		    }
		    
			VehicleCache[vehid][vOwnerType] = OWNER_GROUP;
			VehicleCache[vehid][vOwner] = GroupCache[group_id][gUID];

			orm_update(VehicleCache[vehid][vOrm]);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd %s (UID: %d) zosta³ przypisany pomyœlnie.\n\nTyp w³aœciciela: grupa\nW³aœciciel: %s (UID: %d)", GetVehicleName(VehicleCache[vehid][vModel]), VehicleCache[vehid][vUID], GroupCache[group_id][gName], GroupCache[group_id][gUID]);
			return 1;
		}
	    return 1;
	}
	return 1;
}
alias:apojazd("av");

cmd:aprzedmiot(playerid, params[])
{
	new type[24], varchar[64], string[128];
	if(sscanf(params, "s[24]S()[64]", type, varchar))
	{
		ShowTipForPlayer(playerid, "/aprzedmiot [stworz]");
	    return 1;
	}
	
	if(!strcmp(type, "stworz", true) || !strcmp(type, "stwórz", true) || !strcmp(type, "create", true))
	{
	    new item_type, item_value1, item_value2, item_name[32];
	    if(sscanf(varchar, "k<item_type>dds[32]", item_type, item_value1, item_value2, item_name))
	    {
	        ShowTipForPlayer(playerid, "/aprzedmiot stworz [Typ przedmiotu] [Wartoœæ 1] [Wartoœæ 2] [Nazwa przedmiotu]");
	        return 1;
	    }
	    if(item_type == INVALID_ITEM_TYPE)
	    {
            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b³êdny typ przedmiotu.");
	        return 1;
	    }
	    escape_pl(item_name);
	    
     	new itemid = CreatePlayerItem(playerid, item_name, item_type, item_value1, item_value2);
     	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Przedmiot zosta³ pomyœlnie stworzony. Szczegó³y:\n\nNazwa: %s\nTyp: %s\nWartoœci: %d/%d\n\nPrzedmiot pojawi³ siê w Twoim ekwipunku.", item_name, ItemTypeInfo[item_type][iTypeName], item_value1, item_value2);
	    return 1;
	}
	return 1;
}
alias:aprzedmiot("ap");

cmd:przedmiot(playerid, params[])
{
	new type[24], varchar[24], string[128];
	if(sscanf(params, "s[24]S()[24]", type, varchar))
	{
		ListPlayerItems(playerid);
	    return 1;
	}

	if(!strcmp(type, "podnies", true))
	{
	    ListPlayerNearItems(playerid);
	    return 1;
	}

	if(!strcmp(type, "pokaz", true))
	{
 		new giveplayer_id;
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/p pokaz [ID gracza]");
	        return 1;
	    }
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b³êdne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje siê zbyt daleko od Ciebie.");
		   	return 1;
		}
		ListPlayerItemsForPlayer(playerid, giveplayer_id);

 		format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Gotowka gracza ~r~%s~y~: ~g~$%d~y~.", PlayerName(playerid), PlayerCache[playerid][pCash]);
		GameTextForPlayer(giveplayer_id, string, 6000, 3);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pokaza³eœ swoje przedmioty dla gracza %s.", PlayerName(giveplayer_id));

		//printf("[item] %s (UID: %d, GID: %d) pokaza³ swoje przedmioty dla %s (UID: %d, GID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], PlayerRealName(giveplayer_id), PlayerCache[giveplayer_id][pUID], PlayerCache[giveplayer_id][pGID]);
		return 1;
	}
	return 1;
}
alias:przedmiot("p", "ekwipunek");

cmd:ag(playerid, params[])
{
	new type[24], varchar[64];
	if(sscanf(params, "s[24]S()[64]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/ag [stworz]");
	    return 1;
	}
	
	if(!strcmp(type, "stworz", true) || !strcmp(type, "stwórz", true))
	{
	    new group_type, group_name[32];
		if(sscanf(varchar, "k<group_type>s[32]", group_type, group_name))
		{
		    ShowTipForPlayer(playerid, "/ag stworz [Typ grupy] [Nazwa]");
		    return 1;
		}
		if(group_type == INVALID_GROUP_TYPE)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano nieprawid³owy typ grupy.");
		    return 1;
		}
		escape_pl(group_name);
		
		new group_id = CreateGroup(group_name, group_type);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pomyœlnie utworzono grupê %s (UID: %d) typ grupy: %s.", GroupCache[group_id][gName], GroupCache[group_id][gUID], GroupTypeInfo[group_type][gTypeName]);
	    return 1;
	}
	
	if(!strcmp(type, "lider", true) || !strcmp(type, "leader", true))
	{
	    new group_uid, giveplayer_id;
	    if(sscanf(varchar, "du", group_uid, giveplayer_id))
	    {
			ShowTipForPlayer(playerid, "/ag lider [UID grupy] [ID gracza]");
	        return 1;
	    }
	    new group_id = GetGroupID(group_uid);
	    if(group_id == INVALID_GROUP_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b³êdne UID grupy.");
	        return 1;
	    }
    	if(giveplayer_id == INVALID_PLAYER_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b³êdne ID gracza.");
		   	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(IsPlayerInGroup(giveplayer_id, GroupCache[group_id][gUID]) || IsPlayerInGroupChild(playerid, GroupCache[group_id][gUID]))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nale¿y ju¿ do tej grupy lub jej podgrupy.");
		    return 1;
		}
		
		if(Iter_Count(PlayerGroup[playerid]) >= MAX_GROUP_SLOTS)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie posiada ¿adnego wolnego slotu dla grupy.");
		    return 1;
		}
		new group_slot = Iter_Free(PlayerGroup[playerid]);
		Iter_Add(PlayerGroup[playerid], group_slot);
		
		PlayerGroup[giveplayer_id][group_slot][gpUID]	= 	group_uid;
		PlayerGroup[giveplayer_id][group_slot][gpID]	= 	group_id;
		
		PlayerGroup[giveplayer_id][group_slot][gpPerm]  =   G_PERM_MAX;
		
		new query[256];
		mysql_format(MysqlHandle, query, sizeof(query), "INSERT INTO `myrp_char_groups` (char_uid, group_belongs, group_perm) VALUES ('%d', '%d', '%d')", PlayerCache[giveplayer_id][pUID], GroupCache[group_id][gUID], PlayerGroup[giveplayer_id][gpPerm]);
		mysql_query(MysqlHandle, query, false);
		
		ShowPlayerInfoDialog(giveplayer_id, D_TYPE_INFO, "Administrator %s przypisa³ Ci lidera grupy %s (SampID: %d, UID: %d).\nSkorzystaj z komendy /pomoc, by zapoznaæ siê z komendami lidera.", PlayerName(playerid), GroupCache[group_id][gName], group_id, GroupCache[group_id][gUID]);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Gracz %s (ID: %d, UID: %d) otrzyma³ lidera grupy %s (SampID: %d, UID: %d).", PlayerName(giveplayer_id), giveplayer_id, PlayerCache[giveplayer_id][pUID], GroupCache[group_id][gName], group_id, GroupCache[group_id][gUID]);
		return 1;
	}
	
	if(!strcmp(type, "lista", true))
	{
	    new string[256];
	    foreach(new group_id : Groups)
	    {
	        format(string, sizeof(string), "%s\n%d\t%s\t%s", string, GroupCache[group_id][gUID], GroupCache[group_id][gName], GroupCache[group_id][gTag]);
	    }
	    
	    ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_LIST, "Lista grup:", string, "OK", "");
	    return 1;
	}
	
	return 1;
}
alias:ag("agrupa");

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{

    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{

    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(!ispassenger)    PlayerCache[playerid][pLastVehicle] = GetVehicleIndex(vehicleid);
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{

	if(newstate == PLAYER_STATE_DRIVER)
	{
 		new vehicleid = GetPlayerVehicleID(playerid);
	    if(!GetVehicleEngineStatus(vehicleid))
	    {
	        TD_ShowSmallInfo(playerid, 0, "Aby uruchomic silnik, wcisnij ~y~~k~~VEHICLE_FIREWEAPON_ALT~~w~ + ~y~~k~~SNEAK_ABOUT~~w~.~n~Klawisz ~y~~k~~VEHICLE_FIREWEAPON~ ~w~kontroluje swiatla w pojezdzie.");
	    }
	}
	
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
	    new vehicleid = VehicleCache[PlayerCache[playerid][pLastVehicle]][vGID];
		if(!GetVehicleEngineStatus(vehicleid))
		{
		    TD_HideSmallInfo(playerid);
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnVehicleHealthStatusChange(driverid, vehicleid, Float:health)
{
	new vehid = GetVehicleIndex(vehicleid);
	
	if(health <= 300)
	{
		VehicleCache[vehid][vHealth] = 300.0;
		SetVehicleHealth(vehicleid, VehicleCache[vehid][vHealth]);
		
		ChangeVehicleEngineStatus(vehicleid, false);
		
		GameTextForPlayer(driverid, "~n~~n~~n~~r~Silnik jest uszkodzony!", 3000, 3);
		TD_ShowSmallInfo(driverid, 0, "Aby uruchomic silnik, wcisnij ~y~~k~~VEHICLE_FIREWEAPON_ALT~~w~ + ~y~~k~~SNEAK_ABOUT~~w~.~n~Klawisz ~y~~k~~VEHICLE_FIREWEAPON~ ~w~kontroluje swiatla w pojezdzie.");
		return 1;
	}
	
	VehicleCache[vehid][vHealth] = health;
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_NO)
	{
	    // Zamykanie samouczka
	    if(PlayerCache[playerid][pHintTextTime] < 0)
	    {
			TD_HideHint(playerid);
			TD_ShowHint(playerid, HINT_KEY_NO, -1, "Wcisniecie klawisza ~y~N~w~, spowoduje ~r~zamkniecie ~w~tego okna. Niektore samouczki po prostu znikaja po jakims czasie.~n~~n~Ten klawisz sluzy rowniez do otwierania listy ~y~ulubionych ~w~przedmiotow, jednak zeby ja ujrzec, najpierw musisz wybrac przedmioty poprzez ~p~/p~w~.");
		}
		else
		{
	    	ListPlayerFavoriteItems(playerid);
		}
	}
	
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		// Odpalanie silnika
	    if(newkeys == KEY_ACTION + KEY_FIRE)
	    {
  			pc_cmd_pojazd(playerid, "silnik");
  			return 1;
	    }
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(PlayerCache[playerid][pAFK] >= 0)
	{
	    new afk_time = gettime() - PlayerCache[playerid][pAFKTime];
	    
		PlayerCache[playerid][pSession][SESSION_AFK] += afk_time;
		PlayerCache[playerid][pAFKTime] = 0;
		
		new afkhour, afkminute, afksecond;
		PlayerAFKTime(playerid, afkhour, afkminute, afksecond);
		SendClientFormatMessage(playerid, COLOR_WHITE, "W³aœnie wróci³eœ z AFK. £¹cznie afczy³eœ dziœ %dh, %dm, %ds.", afkhour, afkminute, afksecond);
	}
	PlayerCache[playerid][pAFK] = -3;
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == D_LOGIN)
	{
	    if(response)
	    {
	        /*
	        new password[64];
	        if(strlen(inputtext) >= 32 || strlen(inputtext) <= 0)
	        {
				PlayerCache[playerid][pLogTries] --;
				ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Panel logowania", "Witaj na "SERVER_NAME"!\n\nWprowadŸ poni¿ej has³o do postaci, by rozpocz¹æ grê na naszym serwerze.\nUpewnij siê, ¿e postaæ zosta³a za³o¿ona na naszej stronie "WEB_URL".", "Zaloguj", "Zmieñ nick");
				return 1;
			}
			
			mysql_format("SELECT `char_uid`, `char_gid`, `member_premium_time`, `member_game_points` FROM `myrp_characters`, `ipb_members` WHERE BINARY char_name LIKE '%s' AND member_id = char_gid AND members_pass_hash = md5(CONCAT(md5(members_pass_salt), md5('%s'))) LIMIT 1", PlayerCache[playerid][pCharName], password);
			*/
			orm_select(PlayerCache[playerid][pOrm], "OnPlayerLogin", "d", playerid);
	        return 1;
		}
		else
		{
		    return 1;
		}
	}
	
	if(dialogid == D_ITEM_USE)
	{
		 if(response)
		 {
			// Funkcja zaznaczania
			if(listitem == 0)
			{
				ListPlayerCheckedItems(playerid);
				return 1;
		 	}

			// Przedmioty w pobli¿u
			if(listitem == 1)
			{
				ListPlayerNearItems(playerid);
				return 1;
			}

			if(listitem == 2)
			{
				ListPlayerItems(playerid);
				return 1;
			}

			new itemid = DynamicGui_GetDataInt(playerid, listitem);
			OnPlayerUseItem(playerid, itemid);
			return 1;
		}
		else
		{
			if(listitem <= 2)   return 1;

			new itemid = DynamicGui_GetDataInt(playerid, listitem), title[128];
			format(title, sizeof(title), "Opcje przedmiotu: %s (UID: %d)", PlayerItemCache[playerid][itemid][iName], PlayerItemCache[playerid][itemid][iUID]);

			DynamicGui_Init(playerid);
			DynamicGui_SetDialogValue(playerid, itemid);

			ShowPlayerDialog(playerid, D_ITEM_MANAGE, DIALOG_STYLE_TABLIST_HEADERS, title, "*\tAkcja\n01\tOd³ó¿ w pobli¿u\n02\tPoka¿ informacje\n03\tSprzedaj innemu graczowi\n04\tW³ó¿ do przedmiotu\n05\tDodaj do craftingu\n06\tWsadŸ do schowka\n07\tOddaj innemu graczowi za darmo\n08\tRozdziel przedmiot\n09\tDodaj do ulubionych", "Wybierz", "Wróæ");
			return 1;
		}
	}

	if(dialogid == D_ITEM_MANAGE)
	{
		if(response)
		{
		    new itemid = DynamicGui_GetDialogValue(playerid);
			switch(listitem)
			{
			    case 0:
			    {
					OnPlayerDropItem(playerid, itemid);
			    }
			    case 1:
			    {
			        ShowPlayerItemInfo(playerid, PlayerItemCache[playerid][itemid][iUID]);
			    }
			    case 2:
			    {

			    }
			    case 3:
			    {
			        if(PlayerItemCache[playerid][itemid][iType] == ITEM_BAG)
			        {
			            new format_input[48];

						DynamicGui_Init(playerid);
						
						DynamicGui_AddRow(playerid, D_ITEM_USE, 0);
			            DynamicGui_AddRow(playerid, D_ITEM_USE, 0);
			            DynamicGui_AddRow(playerid, D_ITEM_USE, 0);
			            
			            DynamicGui_AddRow(playerid, D_ITEM_USE, itemid);
			            
			            format(format_input, sizeof(format_input), "%d\t%s", PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName]);
			            CallLocalFunction("OnDialogResponse", "dddds", playerid, D_ITEM_USE, 0, 3, format_input);

			            TD_ShowSmallInfo(playerid, 5, "Nie mozesz ~r~wlozyc ~w~tego przedmiotu.");
			            return 1;
			        }
			        new list_bags[512] = "Identyfikator\tNazwa przedmiotu", item_count;
					foreach(new i : PlayerItem[playerid])
					{
					    if(PlayerItemCache[playerid][i][iUID])
					    {
					        if(PlayerItemCache[playerid][i][iType] == ITEM_BAG)
					        {
					            item_count ++;
								format(list_bags, sizeof(list_bags), "%s\n%d\t%s", list_bags, PlayerItemCache[playerid][i][iUID], PlayerItemCache[playerid][i][iName]);

							}
					    }
					}

					if(item_count > 0)
					{
	    				ShowPlayerDialog(playerid, D_ITEM_PUT_BAG, DIALOG_STYLE_TABLIST_HEADERS, "W³ó¿ do przedmiotu:", list_bags, "W³ó¿", "Wróæ");
					}
					else
					{
		   				TD_ShowSmallInfo(playerid, 5, "Nie posiadasz ~r~zadnych ~w~przedmiotow do ktorych mozna cos wlozyc.");
					}
			    }
			    case 4:
			    {

			    }
			    case 5:
			    {

			    }
			    case 6:
			    {

			    }
			    case 7:
			    {
			        if(PlayerItemCache[playerid][itemid][iType] != ITEM_CIGGY && PlayerItemCache[playerid][itemid][iType] != ITEM_DRUG)
			        {
           				new format_input[48];
			            format(format_input, sizeof(format_input), "%d\t%s", PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName]);
			            CallLocalFunction("OnDialogResponse", "dddds", playerid, D_ITEM_USE, 0, 3, format_input);

			            TD_ShowSmallInfo(playerid, 5, "Nie mozesz ~r~rozdzielic ~w~tego przedmiotu.");
			            return 1;
			        }

			        ShowPlayerDialog(playerid, D_ITEM_SEPARATE, DIALOG_STYLE_INPUT, "Rozdziel przedmiot", "WprowadŸ poni¿ej ile sztuk chcesz pozyskaæ z tego przedmiotu.\nPo poprawnie wykonanej akcji przedmiot zostanie podzielony.", "Rozdziel", "Wróæ");
			    }
			    case 8:
			    {
			        if(PlayerItemCache[playerid][itemid][iFavorite])
			        {
			            PlayerItemCache[playerid][itemid][iFavorite] = false;
			            TD_ShowSmallInfo(playerid, 5, "Przedmiot ~y~%s (%d) ~w~zostal ~r~usuniety ~w~z ulubionych.", PlayerItemCache[playerid][itemid][iName], PlayerItemCache[playerid][itemid][iUID]);
			        }
			        else
			        {
			            PlayerItemCache[playerid][itemid][iFavorite] = true;
						TD_ShowSmallInfo(playerid, 5, "Przedmiot ~y~%s (%d) ~w~zostal ~g~dodany ~w~do ulubionych.~n~Klawisz ~p~~k~~CONVERSATION_NO~~w~, wyswietli menu szybkiego uzywania przedmiotow.", PlayerItemCache[playerid][itemid][iName], PlayerItemCache[playerid][itemid][iUID]);
			        }
			        CallLocalFunction("ListPlayerItems", "d", playerid);
			        orm_update(PlayerItemCache[playerid][itemid][iOrm]);
			    }
			}
		    return 1;
		}
		else
		{
      		CallLocalFunction("ListPlayerItems", "d", playerid);
		    return 1;
		}
	}
	
	if(dialogid == D_ITEM_RAISE)
	{
	    if(response)
	    {
	        // Podnieœ zaznaczone
	        if(listitem == 0)
	        {
	            return 1;
	        }
	        
	        if(listitem == 1)   return 1;
	    
	        new item_uid = DynamicGui_GetDataInt(playerid, listitem);
	        if(strval(inputtext) != item_uid)   return 1;
	        
        	new list_items[1024], item_name[32], rows;
        	format(list_items, sizeof(list_items), "Identyfikator\t*\tNazwa przedmiotu\n» Podnieœ\n---\n");

			DynamicGui_Init(playerid);

			DynamicGui_AddRow(playerid, D_ITEM_RAISE, 0);
			DynamicGui_AddRow(playerid, D_ITEM_RAISE, 0);

			cache_set_active(ground_items_cache[playerid]);

		    cache_get_row_count(rows);
			for(new row = 0; row != rows; row++)
			{
				cache_get_value_index_int(row, 0, item_uid);
				cache_get_value_index(row, 1, item_name, 32);

				if(Iter_Contains(CheckedPlayerItem[playerid], item_uid))
				{
					format(list_items, sizeof(list_items), "%s\n%d\t[X]\t%s", list_items, item_uid, item_name);
				}
				else
				{
				    format(list_items, sizeof(list_items), "%s\n%d\t[ ]\t%s", list_items, item_uid, item_name);
				}
				DynamicGui_AddRow(playerid, D_ITEM_RAISE, item_uid);
			}
			cache_unset_active();
	        
	        Iter_Add(CheckedPlayerItem[playerid], item_uid);
			ShowPlayerDialog(playerid, D_ITEM_RAISE, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty znajduj¹ce siê w pobli¿u:", list_items, "Zaznacz", "Anuluj");

			//OnPlayerRaiseItem(playerid, item_uid);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	
	if(dialogid == D_ITEM_CHECK)
	{
	    if(response)
    	{
    	    if(PlayerCache[playerid][pPuttingBag])
    	    {
    	        new bag_item_id = PlayerCache[playerid][pItemArray][ITEM_BAG] = GetPlayerItemID(playerid, strval(inputtext));
				if(!Iter_Contains(PlayerItem[playerid], bag_item_id))
    	        {
    	            return 1;
				}
				
				if(PlayerItemCache[playerid][bag_item_id][iType] != ITEM_BAG)
				{
				    return 1;
				}
    	        
    	        listitem = 2;
				goto putting_bag;
				
				return 1;
    	    }
    	
    	    if(listitem == 0)
    	    {
    	        CallLocalFunction("ListPlayerCheckedItems", "d", playerid);
    	        return 1;
    	    }
	    
	        if(listitem <= 5)
	        {
	            new checked_items, last_itemid = INVALID_ITEM_ID;
	            foreach(new itemid : PlayerItem[playerid])
	            {
	                //printf("%d,%s,%d", PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName], itemid);
	            
	                if(PlayerItemCache[playerid][itemid][iChecked])
	                {
	                    checked_items ++;
	                    
	                    // £¥CZENIE PRZEDMIOTÓW
	                    if(listitem == 5)
	                    {
							if(last_itemid != INVALID_ITEM_ID)
       						{
								if(PlayerItemCache[playerid][itemid][iType] != PlayerItemCache[playerid][last_itemid][iType] || PlayerItemCache[playerid][itemid][iValue][1] != PlayerItemCache[playerid][last_itemid][iValue][1])
								{
								    CallLocalFunction("ListPlayerCheckedItems", "d", playerid);
				    				TD_ShowSmallInfo(playerid, 5, "Do ~y~polaczenia ~w~przedmiotow musisz ~g~zaznaczyc ~w~tylko tego samego typu.");
								    return 1;
								}
							}
							last_itemid = itemid;
	                    }
	                }
	            }
	            
	            if(checked_items < 2)
	            {
	                CallLocalFunction("ListPlayerCheckedItems", "d", playerid);
	                TD_ShowSmallInfo(playerid, 5, "Musisz ~g~zaznaczyc ~w~przynajmniej ~y~dwa ~w~przedmioty, by nimi manipulowac.");
	                return 1;
	            }
	            
	            if(listitem == 5)
	            {
	                if(PlayerItemCache[playerid][last_itemid][iType] != ITEM_CIGGY && PlayerItemCache[playerid][last_itemid][iType] != ITEM_DRUG)
	                {
	                    ListPlayerCheckedItems(playerid);
	                    TD_ShowSmallInfo(playerid, 5, "Nie mozesz ~y~polaczyc ~w~ze soba tego typu przedmiotow.");
	                    return 1;
	                }
	            }
	        
				new main_query[2048], query[128], string_lenght, next_player_item, bag_item_id,
     				Float:PosX, Float:PosY, Float:PosZ, Float:PosA, virtual_world, interior_id;
					
				new items_list_info[512];
				
				switch(listitem)
				{
				    case 1:
				    {
				        if(IsPlayerInAnyVehicle(playerid))
				        {
				            new vehid = GetVehicleIndex(GetPlayerVehicleID(playerid)), veh_uid = VehicleCache[vehid][vUID];
				            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
				            
							format(main_query, sizeof(main_query), "UPDATE `myrp_items` SET item_place = '%d', item_owner = '%d' WHERE ", PLACE_VEHICLE, veh_uid);
							format(items_list_info, sizeof(items_list_info), "Przedmioty od³o¿one w pojeŸdzie %s (UID: %d):\n", GetVehicleName(VehicleCache[vehid][vModel]), veh_uid);
				        }
				        else
				        {
	  						GetPlayerPos(playerid, PosX, PosY, PosZ);
							GetPlayerFacingAngle(playerid, PosA);

							virtual_world = GetPlayerVirtualWorld(playerid);
							interior_id = GetPlayerInterior(playerid);

					        ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);

							format(main_query, sizeof(main_query), "UPDATE `myrp_items` SET item_place = '%d', item_owner = '0', item_posx = '%f', item_posy = '%f', item_posz = '%f', item_world = '%d', item_interior = '%d' WHERE ", PLACE_NONE, PosX, PosY, PosZ, virtual_world, interior_id);
	                        format(items_list_info, sizeof(items_list_info), "Przedmioty zosta³y od³o¿one w pobli¿u:\n");
						}
					}
					case 2:
					{
					    if(!PlayerCache[playerid][pPuttingBag])
					    {
	  						new list_bags[512] = "Identyfikator\tNazwa przedmiotu", item_count;
							foreach(new i : PlayerItem[playerid])
							{
							    if(PlayerItemCache[playerid][i][iType] == ITEM_BAG)
							    {
							        item_count ++;
							        format(list_bags, sizeof(list_bags), "%s\n%d\t%s", list_bags, PlayerItemCache[playerid][i][iUID], PlayerItemCache[playerid][i][iName]);
								}
							}

							if(item_count > 0)
							{
							    ShowPlayerDialog(playerid, D_ITEM_CHECK, DIALOG_STYLE_TABLIST_HEADERS, "W³ó¿ do przedmiotu:", list_bags, "W³ó¿", "Wróæ");
								PlayerCache[playerid][pPuttingBag] = true;
							}
							else
							{
							    TD_ShowSmallInfo(playerid, 5, "Nie posiadasz ~r~zadnych ~w~przedmiotow do ktorych mozna cos wlozyc.");
							}
							return 1;
						}
						
						putting_bag:
						bag_item_id = PlayerCache[playerid][pItemArray][ITEM_BAG];

						format(main_query, sizeof(main_query), "UPDATE `myrp_items` SET item_place = '%d', item_owner = '%d' WHERE ", PLACE_BAG, PlayerItemCache[playerid][bag_item_id][iUID]);
                        format(items_list_info, sizeof(items_list_info), "Przedmioty zosta³y w³o¿one do przedmiotu %s (UID: %d):\n", PlayerItemCache[playerid][bag_item_id][iName], PlayerItemCache[playerid][bag_item_id][iUID]);
                        
                        PlayerCache[playerid][pPuttingBag] = false;
					}
					case 5:
					{
					    new item_name[32];
					    strmid(item_name, PlayerItemCache[playerid][last_itemid][iName], 0, 32, 32);
					    
					    format(main_query, sizeof(main_query), "DELETE FROM `myrp_items` WHERE ");
					    last_itemid = CreatePlayerItem(playerid, item_name, PlayerItemCache[playerid][last_itemid][iType], 0, PlayerItemCache[playerid][last_itemid][iValue][1]);

                    	format(items_list_info, sizeof(items_list_info), "Przedmioty zosta³y po³¹czone tworz¹c %s (UID: %d):\n", PlayerItemCache[playerid][last_itemid][iName], PlayerItemCache[playerid][last_itemid][iUID]);
					}
				}
	            string_lenght = strlen(main_query);
	            
	            new object_id;
             	foreach(new itemid : PlayerItem[playerid])
	            {
	                if(PlayerItemCache[playerid][itemid][iChecked])
	                {
	                    format(query, sizeof(query), "item_uid = %d", PlayerItemCache[playerid][itemid][iUID]);
						if(strlen(main_query) > string_lenght)
						{
							if(strlen(main_query) + strlen(query) < sizeof(main_query))
   				    		{
				   				strcat(main_query, " OR ", sizeof(main_query));
							}
							else
							{
					    		strcat(main_query, ";", sizeof(main_query));
					    		mysql_query(MysqlHandle, main_query);

					    		strdel(main_query, string_lenght, strlen(main_query));
							}
						}
						strcat(main_query, query, sizeof(main_query));
						
						if(listitem == 1)
						{
						    if(!IsPlayerInAnyVehicle(playerid))
						    {
    							object_id = CreateDynamicObject(2843, PosX + random(2), PosY - random(2), PosZ - 1.0, 0.0, 0.0, -PosA, virtual_world, -1, -1);

								Streamer_SetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID, (PlayerItemCache[playerid][itemid][iUID] * -1));
								Streamer_UpdateEx(playerid, PosX, PosY, PosZ, virtual_world, interior_id, STREAMER_TYPE_OBJECT);
							}
						}
						
						if(listitem == 2)
						{
						    PlayerItemCache[playerid][bag_item_id][iValue][0] += GetPlayerItemWeight(playerid, itemid);
						}
						
						if(listitem == 5)
						{
						    PlayerItemCache[playerid][last_itemid][iValue][0] += PlayerItemCache[playerid][itemid][iValue][0];
						}
						
						format(items_list_info, sizeof(items_list_info), "%s\n• %s (%d)", items_list_info, PlayerItemCache[playerid][itemid][iName], PlayerItemCache[playerid][itemid][iUID]);

                        UnloadPlayerItem(playerid, itemid);
						Iter_SafeRemove(PlayerItem[playerid], itemid, next_player_item);
						
						printf("Iter_SafeRemove(PlayerItem[playerid], %d);", itemid);
						itemid = next_player_item;
						
						
	                }
	            }

	            if(listitem == 2)
	            {
	                orm_update(PlayerItemCache[playerid][bag_item_id][iOrm]);
	            }
	            
	            if(listitem == 5)
	            {
	                orm_update(PlayerItemCache[playerid][last_itemid][iOrm]);
	            }
	            
	            mysql_query(MysqlHandle, main_query);
	            ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Informacja", items_list_info, "OK", "");
	            return 1;
	        }
	    
			new itemid = DynamicGui_GetDataInt(playerid, listitem);
			if(PlayerItemCache[playerid][itemid][iChecked])
			{
				PlayerItemCache[playerid][itemid][iChecked] = false;
				TD_ShowSmallInfo(playerid, 3, "Przedmiot zostal ~r~odznaczony~w~.");
			}
			else
			{
				PlayerItemCache[playerid][itemid][iChecked] = true;
				TD_ShowSmallInfo(playerid, 3, "Przedmiot zostal ~g~zaznaczony~w~.");
			}
			CallLocalFunction("ListPlayerCheckedItems", "d", playerid);
	        return 1;
	    }
	    else
	    {
	        new callback[24];
	        if(PlayerCache[playerid][pPuttingBag])
	        {
	        	PlayerCache[playerid][pPuttingBag] = false;
	        	callback = "ListPlayerCheckedItems";
			}
	        else
			{
       			callback = "ListPlayerItems";
			}
			CallLocalFunction(callback, "d", playerid);
	        return 1;
	    }
	}
	
	if(dialogid == D_ITEM_FAVORITE)
	{
	    if(response)
	    {
			new itemid = strval(inputtext);
			OnPlayerUseItem(playerid, itemid);
	        return 1;
	    }
	    else
	    {
			return 1;
	    }
	}
	
	if(dialogid == D_ITEM_PUT_BAG)
	{
	    if(response)
	    {
	        new itemid = PlayerCache[playerid][pItemArray][ITEM_NONE],
				bag_item_uid = strval(inputtext), bag_item_id = GetPlayerItemID(playerid, bag_item_uid);

			if(!Iter_Contains(PlayerItem[playerid], itemid))    return 1;
			
			PlayerItemCache[playerid][itemid][iPlace] = PLACE_BAG;
			PlayerItemCache[playerid][itemid][iOwner] = bag_item_uid;
			
			PlayerItemCache[playerid][bag_item_id][iValue][0] += GetPlayerItemWeight(playerid, itemid);
			
			orm_update(PlayerItemCache[playerid][itemid][iOrm]);
			orm_update(PlayerItemCache[playerid][bag_item_id][iOrm]);
			
			TD_ShowSmallInfo(playerid, 5, "Przedmiot ~y~%s (%d) ~w~zostal wlozony do ~y~%s (%d)~w~ pomyslnie.", PlayerItemCache[playerid][itemid][iName], PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][bag_item_id][iName], PlayerItemCache[playerid][bag_item_id][iUID]);
			
			Iter_Remove(PlayerItem[playerid], itemid);
			UnloadPlayerItem(playerid, itemid);
			
   			CallLocalFunction("ListPlayerItems", "d", playerid);
	        return 1;
	    }
	    else
	    {
	        new itemid = PlayerCache[playerid][pItemArray][ITEM_NONE], format_input[48];
	        
	        format(format_input, sizeof(format_input), "%d\t%s", PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName]);
			CallLocalFunction("OnDialogResponse", "dddds", playerid, D_ITEM_USE, 0, 3, format_input);
	        return 1;
	    }
	}
	
	if(dialogid == D_ITEM_REMOVE_BAG)
	{
	    if(response)
	    {
     		new item_uid = strval(inputtext), bag_item_id = PlayerCache[playerid][pItemArray][ITEM_BAG], query[256];
			if(!Iter_Contains(PlayerItem[playerid], bag_item_id))
			{
			    return 1;
			}
			mysql_format(MysqlHandle, query, sizeof(query), "UPDATE `myrp_items` SET item_place = '%d', item_owner = '%d' WHERE item_place = '%d' AND item_owner = '%d' AND item_uid = '%d' LIMIT 1", PLACE_PLAYER, PlayerCache[playerid][pUID], PLACE_BAG, PlayerItemCache[playerid][bag_item_id][iUID], item_uid);
			new Cache:cache_id = mysql_query(MysqlHandle, query, true);

			if(cache_affected_rows() <= 0)
			{
		    	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tego przedmiotu ju¿ tutaj nie ma.");
		    	return 1;
			}
			
			cache_delete(cache_id);
			
			new itemid = LoadPlayerItem(playerid, item_uid);
			TD_ShowSmallInfo(playerid, 5, "Przedmiot zostal ~g~pomyslnie ~w~wyjety.");

			PlayerItemCache[playerid][bag_item_id][iValue][0] -= GetPlayerItemWeight(playerid, itemid);
			orm_update(PlayerItemCache[playerid][bag_item_id][iOrm]);
			
   			CallLocalFunction("ListPlayerItems", "d", playerid);
			return 1;
	    }
	    else
	    {
	        CallLocalFunction("ListPlayerItems", "d", playerid);
	        return 1;
	    }
	}
	
	if(dialogid == D_ITEM_SEPARATE)
	{
	    if(response)
	    {
	        new itemid = PlayerCache[playerid][pItemArray][ITEM_NONE],
				item_count = strval(inputtext);
				
			if(!Iter_Contains(PlayerItem[playerid], itemid))	return 1;
	        if(item_count <= 0 || item_count >= PlayerItemCache[playerid][itemid][iValue][0])
	        {
	            ShowPlayerDialog(playerid, D_ITEM_SEPARATE, DIALOG_STYLE_INPUT, "Rozdziel przedmiot", "WprowadŸ poni¿ej ile sztuk chcesz pozyskaæ z tego przedmiotu.\nPo poprawnie wykonanej akcji przedmiot zostanie podzielony.", "Rozdziel", "Wróæ");
				TD_ShowSmallInfo(playerid, 5, "Nie mozesz ~r~pozyskac ~w~tylu sztuk z tego przedmiotu.");
	            return 1;
			}
			new item_name[32];
			
			strmid(item_name, PlayerItemCache[playerid][itemid][iName], 0, 32, 32);
			CreatePlayerItem(playerid, item_name, PlayerItemCache[playerid][itemid][iType], item_count, PlayerItemCache[playerid][itemid][iValue][1]);

			PlayerItemCache[playerid][itemid][iValue][0] -= item_count;
			orm_update(PlayerItemCache[playerid][itemid][iOrm]);

			CallLocalFunction("ListPlayerItems", "d", playerid);
			TD_ShowSmallInfo(playerid, 5, "Przedmiot ~y~%s (%d) ~w~zostal ~g~pomyslnie ~w~rozdzielony.", PlayerItemCache[playerid][itemid][iName], PlayerItemCache[playerid][itemid][iUID]);
		   	return 1;
	    }
	    else
	    {
     		new itemid = PlayerCache[playerid][pItemArray][ITEM_NONE], format_input[48];

	        format(format_input, sizeof(format_input), "%d\t%s", PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName]);
			CallLocalFunction("OnDialogResponse", "dddds", playerid, D_ITEM_USE, 0, 3, format_input);
	        return 1;
	    }
	}
	
	if(dialogid == D_VEH_SPAWN)
	{
	    if(response)
	    {
	        new veh_uid = strval(inputtext), veh_name[32],
				vehid = GetVehicleID(veh_uid);

			sscanf(inputtext, "ds[32]", veh_uid, veh_name);
	        if(vehid == INVALID_VEHICLE_ID)
	        {
				if(GetPlayerVehiclesCount(playerid) >= ((IsPlayerPremium(playerid)) ? PACC_VEHICLES : FACC_VEHICLES))
				{
					ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Masz ju¿ zespawnowan¹ maksymaln¹ iloœæ pojazdów, odspawnuj jakiœ pojazd.");
				    return 1;
				}
	        
	            vehid = LoadVehicle(veh_uid);
				TD_ShowSmallInfo(playerid, 5, "Pojazd (UID: %d) zostal pomyslnie ~g~zespawnowany~w~.", veh_uid);
	        }
	        else
	        {
	            TD_ShowSmallInfo(playerid, 5, "Pojazd (UID: %d) zostal pomyslnie ~r~odspawnowany~w~.", veh_uid);

				orm_update(VehicleCache[vehid][vOrm]);
				UnloadVehicle(veh_uid);
	        }
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_VEH_TARGET)
	{
	    if(response)
	    {
     		new veh_uid = strval(inputtext), vehid = GetVehicleID(veh_uid),
     		    Float:VehPosX, Float:VehPosY, Float:VehPosZ;
     		    
	        GetVehiclePos(VehicleCache[vehid][vGID], VehPosX, VehPosY, VehPosZ);
	        SetPlayerCheckpoint(playerid, VehPosX, VehPosY, VehPosZ, 5.0);
	        
	        //PlayerCache[playerid][pCheckpoint] = CHECKPOINT_VEHICLE;

	        TD_ShowSmallInfo(playerid, 5, "Pojazd ~y~%s ~w~(UID: %d) zostal ~r~namierzony~w~.~n~Komenda ~b~/v namierz ~w~anuluje namierzanie.", GetVehicleName(VehicleCache[vehid][vModel]), VehicleCache[vehid][vUID]);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	// Okno opcji grup
	if(PlayerCache[playerid][pListPlayerGroups])
	{
		if(clickedid != Text:INVALID_TEXT_DRAW)
		{
			for(new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
			{
				for(new group_option = 0; group_option < 6; group_option++)
				{
					if(TD_GroupOption[group_option][group_slot] == clickedid)
					{
					    new option[24];
					    switch(group_option)
					    {
					        case 0: option = "info";
					        case 1: option = "magazyn";
					        case 2:
					        {
					            option = "sluzba";
					            PlayerCache[playerid][pDuty][DUTY_GROUP] = PlayerGroup[playerid][group_slot][gpID];
					        }
					        case 3: option = "pojazdy";
					        case 4: option = "online";
					        case 5: option = "zadania";
					    }

					    // pc_cmd_grupa(playerid, option);
					    new string[64], group_id = PlayerGroup[playerid][group_slot][gpID];
					    format(string, sizeof(string), "Klikn¹³eœ na %s dla grupy %s [UID: %d]", option, GroupCache[group_id][gName], PlayerGroup[playerid][group_slot][gpUID]);
						SendClientMessage(playerid, COLOR_RED, string);
					}
				}
			}
		}
		CallLocalFunction("HidePlayerGroupOptions", "d", playerid);
	}
	return 0;
}

//  --- [ITEMS MODULE]  --- //
stock GetPlayerItemID(playerid, item_uid)
{
	new itemid = INVALID_ITEM_ID;
	foreach(new i : PlayerItem[playerid])
	{
	    if(PlayerItemCache[playerid][i][iUID] == item_uid)
	    {
	        itemid = i;
	        break;
	    }
	}
	return itemid;
}

stock GetItemOwner(item_uid)
{
	new item_owner = INVALID_PLAYER_ID, itemid = INVALID_ITEM_ID;
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
			itemid = GetPlayerItemID(i, item_uid);
			if(itemid != INVALID_ITEM_ID)
			{
				item_owner = i;
		    	break;
			}
		}
	}
	return item_owner;
}

stock HavePlayerItemUID(playerid, item_uid)
{
	new bool: got_item;
	foreach(new itemid : PlayerItem[playerid])
	{
		if(PlayerItemCache[playerid][itemid][iUID] == item_uid)
		{
		    got_item = true;
		    break;
		}
	}
	return got_item;
}

stock HavePlayerItemType(playerid, item_type, value1 = 0, value2 = 0)
{
	new bool: got_item;
	foreach(new itemid : PlayerItem[playerid])
	{
	    if(PlayerItemCache[playerid][itemid][iType] == item_type)
	    {
			if(value1 != 0 && PlayerItemCache[playerid][itemid][iValue][0] != value1) continue;
			if(value2 != 0 && PlayerItemCache[playerid][itemid][iValue][1] != value2) continue;
			
	        got_item = true;
	        break;
		}
	}
	return got_item;
}

stock GetPlayerItemWeight(playerid, itemid)
{
	new item_weight = 0,
	    item_value1 = PlayerItemCache[playerid][itemid][iValue][0], item_type = PlayerItemCache[playerid][itemid][iType];

	switch(item_type)
	{
	    case ITEM_WEAPON, ITEM_PAINT, ITEM_INHIBITOR:
	    {
	        item_weight = WeaponInfoData[item_value1][wWeight];
	    }
	    case ITEM_BAG, ITEM_CIGGY:
	    {
	        item_weight = ItemTypeInfo[item_type][iTypeWeight] + item_value1;
	    }
	    case ITEM_CANISTER:
	    {
	        item_weight = ItemTypeInfo[item_type][iTypeWeight] + item_value1 * 800;
	    }
	    default:
	    {
	        item_weight = ItemTypeInfo[item_type][iTypeWeight];
	    }
	}
	return item_weight;
}

public LoadPlayerItems(playerid)
{
	new query[256];
    mysql_format(MysqlHandle, query, sizeof(query), "SELECT `item_uid`, `item_name`, `item_value1`, `item_value2`, `item_place`, `item_owner`, `item_type`, `item_favorite` FROM `myrp_items` WHERE item_place = %d AND item_owner = %d", PLACE_PLAYER, PlayerCache[playerid][pUID]);
    mysql_tquery(MysqlHandle, query, "query_OnLoadPlayerItems", "d", playerid);
	return 1;
}

public UnloadPlayerItems(playerid)
{
	foreach(new itemid : PlayerItem[playerid])
	{
	    orm_destroy(PlayerItemCache[playerid][itemid][iOrm]);
	    for(new sPlayerItem:e; e < sPlayerItem; ++e)	PlayerItemCache[playerid][itemid][e] = 0;
	}
	Iter_Clear(PlayerItem[playerid]);
	return 1;
}

public LoadPlayerItem(playerid, item_uid)
{
 	new itemid = Iter_Free(PlayerItem[playerid]),
	 	ORM:orm_id = PlayerItemCache[playerid][itemid][iOrm] = orm_create("myrp_items", MysqlHandle);

	PlayerItemCache[playerid][itemid][iUID] = item_uid;

	orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iUID], "item_uid");
	orm_addvar_string(orm_id, PlayerItemCache[playerid][itemid][iName], 32, "item_name");

	orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iValue][0], "item_value1");
	orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iValue][1], "item_value2");

	orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iPlace], "item_place");
	orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iOwner], "item_owner");

	orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iType], "item_type");
	orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iFavorite], "item_favorite");
	
	orm_setkey(orm_id, "item_uid");
	orm_select(orm_id);
	
	Iter_Add(PlayerItem[playerid], itemid);
	
	return itemid;
}

public UnloadPlayerItem(playerid, itemid)
{
	orm_destroy(PlayerItemCache[playerid][itemid][iOrm]);
	for(new sPlayerItem:e; e < sPlayerItem; ++e)	PlayerItemCache[playerid][itemid][e] = 0;
	return 1;
}

public ListPlayerItems(playerid)
{
	new list_items[2048], item_count = Iter_Count(PlayerItem[playerid]), item_weight, item_weight_sum;
	format(list_items, sizeof(list_items), "UID\tNazwa przedmiotu\tWaga\n \t» Funkcja zaznaczania\n \t» Przedmioty w pobli¿u\n---\n");
	
	DynamicGui_Init(playerid);
	
	DynamicGui_AddRow(playerid, D_ITEM_USE, 0);
	DynamicGui_AddRow(playerid, D_ITEM_USE, 0);
	DynamicGui_AddRow(playerid, D_ITEM_USE, 0);
	
	if(item_count > 0)
	{
		foreach(new itemid : PlayerItem[playerid])
		{
		    if(PlayerItemCache[playerid][itemid][iUID])
		    {
		    	item_weight = GetPlayerItemWeight(playerid, itemid);
		    	if(PlayerItemCache[playerid][itemid][iUsed])
		    	{
					format(list_items, sizeof(list_items), "%s\n{FFFFFF}%d\t{C0C0C0}%s\t%dg", list_items, PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName], item_weight);
				}
				else
				{
	   			 	format(list_items, sizeof(list_items), "%s\n{C0C0C0}%d\t{C0C0C0}%s\t%dg", list_items, PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName], item_weight);
				}

				item_weight_sum += item_weight;
				DynamicGui_AddRow(playerid, D_ITEM_USE, itemid);
	  		}
		}
		new title[256];

		format(title, sizeof(title), "Lista Twoich przedmiotów [iloœæ: %d | suma wag: %dg]", item_count, item_weight_sum);
		ShowPlayerDialog(playerid, D_ITEM_USE, DIALOG_STYLE_TABLIST_HEADERS, title, list_items, "U¿yj", "Opcje...");
	}
	else
	{
        TD_ShowSmallInfo(playerid, 5, "Nie posiadasz ~r~zadnych ~w~przedmiotow w ekwipunku.");
	}
	return 1;
}

public ListPlayerNearItems(playerid)
{
	new main_query[2048], query[256], item_uid;
	format(main_query, sizeof(main_query), "SELECT `item_uid`, `item_name` FROM `myrp_items` WHERE ");
	
	Iter_Clear(CheckedPlayerItem[playerid]);
	
	if(!IsPlayerInAnyVehicle(playerid))
	{
		new object_id = INVALID_OBJECT_ID, Float:distance,
			Float:PosX, Float:PosY, Float:PosZ;
			
		GetPlayerPos(playerid, PosX, PosY, PosZ);
		for (new player_object = 0; player_object <= MAX_OBJECTS; player_object++)
		{
	   	 	if(IsValidPlayerObject(playerid, player_object))
	    	{
	        	object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);
	        	Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, object_id, distance);
	        	
	        	if(distance <= 3.0)
				{
				    if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID) > 0)
				    {
				        continue;
				    }
				
				    item_uid = (Streamer_GetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID) * -1);
       				format(query, sizeof(query), "item_uid = %d", item_uid);

   					if(strlen(main_query) > 64)
   					{
   				    	if(strlen(main_query) + strlen(query) < sizeof(main_query))
   				    	{
				   			strcat(main_query, " OR ", sizeof(main_query));
						}
						else
						{
					    	strcat(main_query, ";", sizeof(main_query));
						}
					}
			  		strcat(main_query, query, sizeof(main_query));
				}
	        }
	    }
	    
	    if(!item_uid)
	    {
	        TD_ShowSmallInfo(playerid, 5, "Nie znaleziono ~r~zadnych ~w~przedmiotow w poblizu.");
	        return 1;
	    }
	    

	}
	else
	{
	    // LIST VEHICLE ITEMS
	    new vehid = GetVehicleIndex(GetPlayerVehicleID(playerid)), veh_uid = VehicleCache[vehid][vUID];
	    if(VehicleCache[vehid][vOwnerType] == OWNER_PLAYER)
	    {
	        if(VehicleCache[vehid][vOwner] != PlayerCache[playerid][pUID])
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo¿esz podnosiæ przedmiotów z tego pojazdu.");
	            return 1;
	        }
	    }
	    

		format(query, sizeof(query), "item_place = '%d' AND item_owner = '%d'", PLACE_VEHICLE, veh_uid);
		strcat(main_query, query, sizeof(main_query));
	}
	
   	mysql_tquery(MysqlHandle, main_query, "query_OnListPlayerNearItems", "d", playerid);
	return 1;
}

public ListPlayerCheckedItems(playerid)
{
	new list_items[2048], items_to_check;
	format(list_items, sizeof(list_items), "Zaznaczone przedmioty:\n{C0C0C0} • 1 - Od³ó¿ w pobli¿u\n{C0C0C0} • 2 - W³ó¿ do przedmiotu\n{C0C0C0} • 3 - Schowaj do schowka\n{C0C0C0} • 4 - Dodaj do craftingu\n{C0C0C0} • 5 - Po³¹cz ze sob¹\n---\n");
	
	DynamicGui_Init(playerid);
	
	DynamicGui_AddRow(playerid, D_ITEM_CHECK, 0);
	DynamicGui_AddRow(playerid, D_ITEM_CHECK, 0);
	DynamicGui_AddRow(playerid, D_ITEM_CHECK, 0);
	DynamicGui_AddRow(playerid, D_ITEM_CHECK, 0);
	DynamicGui_AddRow(playerid, D_ITEM_CHECK, 0);
	DynamicGui_AddRow(playerid, D_ITEM_CHECK, 0);
    DynamicGui_AddRow(playerid, D_ITEM_CHECK, 0);
	
	foreach(new itemid : PlayerItem[playerid])
	{
	    if(PlayerItemCache[playerid][itemid][iUID])
	    {
		    if(!PlayerItemCache[playerid][itemid][iUsed] && PlayerItemCache[playerid][itemid][iType] != ITEM_BAG)
		    {
		        if(PlayerItemCache[playerid][itemid][iChecked])
		        {
		            format(list_items, sizeof(list_items), "%s\n%d\t[X]\t%s", list_items, PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName]);
		        }
		        else
		        {
		            format(list_items, sizeof(list_items), "%s\n%d\t[ ]\t%s", list_items, PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName]);
		        }
				items_to_check ++;
				DynamicGui_AddRow(playerid, D_ITEM_CHECK, itemid);
		    }
		}
	}
	
	if(items_to_check > 0)
	{
		ShowPlayerDialog(playerid, D_ITEM_CHECK, DIALOG_STYLE_LIST, "Przedmioty » Funkcja zaznaczania", list_items, "Zaznacz", "Wróæ");
	}
	else
	{
     	CallLocalFunction("ListPlayerItems", "d", playerid);
	    TD_ShowSmallInfo(playerid, 5, "Nie posiadasz ~r~zadnych ~w~przedmiotow mozliwych do zaznaczenia.");
	}
	PlayerCache[playerid][pPuttingBag] = false;
	return 1;
}


public ListPlayerFavoriteItems(playerid)
{
	new list_favorite_items[512] = "*\tIdentyfikator\tNazwa przedmiotu", favorite_items_counts;
	foreach(new itemid : PlayerItem[playerid])
	{
	    if(PlayerItemCache[playerid][itemid][iUID])
	    {
	        if(PlayerItemCache[playerid][itemid][iFavorite])
	        {
	     		if(PlayerItemCache[playerid][itemid][iUsed])
	     		{
	             	format(list_favorite_items, sizeof(list_favorite_items), "%s\n{000000}%d\t{FFFFFF}%d\t{FFFFFF}%s", list_favorite_items, itemid, PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName]);
				}
				else
				{
	   				format(list_favorite_items, sizeof(list_favorite_items), "%s\n{000000}%d\t{C0C0C0}%d\t{C0C0C0}%s", list_favorite_items, itemid, PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName]);
				}
				favorite_items_counts ++;
			}
	    }
	}
	
	if(favorite_items_counts > 0)
	{
	    ShowPlayerDialog(playerid, D_ITEM_FAVORITE, DIALOG_STYLE_TABLIST_HEADERS, "Lista ulubionych przedmiotów:", list_favorite_items, "U¿yj", "Zamknij");
	}
	else
	{
	    TD_ShowSmallInfo(playerid, 5, "Nie dodales ~r~zadnego ~w~przedmiotu do ulubionych.");
	}
	return 1;
}

public ListPlayerItemsForPlayer(playerid, giveplayer_id)
{
	new list_items[1024] = "UID\tNazwa przedmiotu\tWaga\tWartoœci", item_count = Iter_Count(PlayerItem[playerid]);
	foreach(new itemid : PlayerItem[playerid])
	{
	    if(PlayerItemCache[playerid][itemid][iUID])
	    {
	        format(list_items, sizeof(list_items), "%s\n%d\t%s\t%dg\t%d/%d", list_items, PlayerItemCache[playerid][itemid][iUID], PlayerItemCache[playerid][itemid][iName], GetPlayerItemWeight(playerid, itemid), PlayerItemCache[playerid][itemid][iValue][0], PlayerItemCache[playerid][itemid][iValue][1]);
	    }
	}
	
	if(item_count > 0)
	{
	    new title[64];
	    format(title, sizeof(title), "Przedmioty nale¿¹ce do %s (UID: %d)", PlayerName(playerid), PlayerCache[playerid][pUID]);

		ShowPlayerDialog(giveplayer_id, D_NONE, DIALOG_STYLE_TABLIST_HEADERS, title, list_items, "OK", "");
	}
	else
	{
	    TD_ShowSmallInfo(giveplayer_id, 5, "Ten gracz nie posiada ~r~zadnych ~w~przedmiotow.");
	}
	return 1;
}

public CreatePlayerItem(playerid, item_name[32], item_type, item_value1, item_value2)
{
	new itemid = INVALID_ITEM_ID;

	itemid = Iter_Free(PlayerItem[playerid]);
	strmid(PlayerItemCache[playerid][itemid][iName], item_name, 0, 32, 32);
	
	PlayerItemCache[playerid][itemid][iValue][0] = item_value1;
	PlayerItemCache[playerid][itemid][iValue][1] = item_value2;

	PlayerItemCache[playerid][itemid][iType] = item_type;

	PlayerItemCache[playerid][itemid][iPlace] = PLACE_PLAYER;
	PlayerItemCache[playerid][itemid][iOwner] = PlayerCache[playerid][pUID];
	
	new ORM:orm_id = PlayerItemCache[playerid][itemid][iOrm] = orm_create("myrp_items", MysqlHandle);
    
    orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iUID], "item_uid");
    orm_addvar_string(orm_id, PlayerItemCache[playerid][itemid][iName], 32, "item_name");
    
    orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iValue][0], "item_value1");
    orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iValue][1], "item_value2");
    
    orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iType], "item_type");
    
    orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iPlace], "item_place");
    orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iOwner], "item_owner");
    
    orm_setkey(orm_id, "item_uid");
    orm_insert(orm_id);
    
    Iter_Add(PlayerItem[playerid], itemid);
    
	return itemid;
}

public DeletePlayerItem(playerid, itemid)
{
	orm_delete(PlayerItemCache[playerid][itemid][iOrm]);
	Iter_Remove(PlayerItem[playerid], itemid);
	return 1;
}

public OnPlayerUseItem(playerid, itemid)
{
	if(!Iter_Contains(PlayerItem[playerid], itemid))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo¿esz u¿yæ tego przedmiotu.");
	    return 1;
	}
	
	new item_type = PlayerItemCache[playerid][itemid][iType], string[256];

	if(item_type == ITEM_WATCH)
	{
		new hour, minute, second;
		gettime(hour, minute, second);

		format(string, sizeof(string), "~w~Godzina: ~y~~h~%02d:%02d:%02d", hour, minute, second);
		GameTextForPlayer(playerid, string, 5000, 1);

		format(string, sizeof(string), "* %s spogl¹da na zegarek.", PlayerName(playerid));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

		ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 0, 0, 0, 0, 1);
	    return 1;
	}
	
	if(item_type == ITEM_FOOD)
	{
	
	    return 1;
	}
	
	if(item_type == ITEM_CIGGY)
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
  		PlayerItemCache[playerid][itemid][iValue][0] --;
  		
  		if(PlayerItemCache[playerid][itemid][iValue][0] <= 0)
		{
            DeletePlayerItem(playerid, itemid);
            return 1;
		}
		orm_update(PlayerItemCache[playerid][itemid][iOrm]);
	    return 1;
	}
	
	if(item_type == ITEM_CUBE)
	{
		new rand = 1 + random(PlayerItemCache[playerid][itemid][iValue][0]);

		format(string, sizeof(string), "* %s wyrzuci³ %d oczek na %d.", PlayerName(playerid), rand, PlayerItemCache[playerid][itemid][iValue][0]);
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	    return 1;
	}
	
	if(item_type == ITEM_BAG)
	{
	    new query[256];
	    
	    mysql_format(MysqlHandle, query, sizeof(query), "SELECT `item_uid`, `item_name` FROM `myrp_items` WHERE item_place = '%d' AND item_owner = '%d'", PLACE_BAG, PlayerItemCache[playerid][itemid][iUID]);
		mysql_tquery(MysqlHandle, query, "query_OnListPlayerBagItems", "d", playerid);
		
		PlayerCache[playerid][pItemArray][ITEM_BAG] = itemid;
	    return 1;
	}
	
	return 1;
}

public OnPlayerDropItem(playerid, itemid)
{
	new string[256];
	if(PlayerItemCache[playerid][itemid][iUsed])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo¿esz od³o¿yæ tego przedmiotu.");
	    return 1;
	}

	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    new Float:PosX, Float:PosY, Float:PosZ, Float:PosA, query[512],
	        virtual_world = GetPlayerVirtualWorld(playerid), interior_id = GetPlayerInterior(playerid);

		GetPlayerPos(playerid, PosX, PosY, PosZ);
		GetPlayerFacingAngle(playerid, PosA);

		format(string, sizeof(string), "* %s odk³ada przedmiot na ziemiê.", PlayerName(playerid));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);

		mysql_format(MysqlHandle, query, sizeof(query), "UPDATE `myrp_items` SET item_place = '%d', item_owner = '0', item_posx = '%f', item_posy = '%f', item_posz = '%f', item_interior = '%d', item_world = '%d' WHERE item_uid = '%d' LIMIT 1", PLACE_NONE, PosX, PosY, PosZ, interior_id, virtual_world, PlayerItemCache[playerid][itemid][iUID]);
		mysql_query(MysqlHandle, query, false);

		new object_id, item_type = PlayerItemCache[playerid][itemid][iType];
		if(item_type == ITEM_WEAPON || item_type == ITEM_PAINT || item_type == ITEM_INHIBITOR)
		{
		    object_id = CreateDynamicObject(WeaponInfoData[PlayerItemCache[playerid][itemid][iValue][0]][wModel], PosX, PosY, PosZ - 1.0, 80.0, 0.0, -PosA, virtual_world, -1, -1, MAX_DRAW_DISTANCE);
		}
		else if(item_type == ITEM_TUNING)
		{
  			object_id = CreateDynamicObject(PlayerItemCache[playerid][itemid][iValue][0], PosX + random(2), PosY + random(2), PosZ - 0.5, 0.0, 0.0, -PosA, virtual_world, -1, -1, MAX_DRAW_DISTANCE);
		}
		else
		{
		    object_id = CreateDynamicObject(ItemTypeInfo[item_type][iTypeObjModel], PosX, PosY, PosZ - 1.0, ItemTypeInfo[item_type][iTypeObjRotX], ItemTypeInfo[item_type][iTypeObjRotY], -PosA, virtual_world, -1, -1, MAX_DRAW_DISTANCE);
		}

		Streamer_SetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID, (PlayerItemCache[playerid][itemid][iUID] * -1));
		Streamer_UpdateEx(playerid, PosX, PosY, PosZ, virtual_world, interior_id, STREAMER_TYPE_OBJECT);

		// printf("[%d][item] %s (UID: %d, GID: %d) od³o¿y³ przedmiot %s (UID: %d) na ziemiê (PosX: %.3f, PosY: %.3f, PosZ: %.3f, InteriorID: %d, WorldID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], ItemCache[itemid][iName], ItemCache[itemid][iUID], PosX, PosY, PosZ, interior_id, virtual_world);

		UnloadPlayerItem(playerid, itemid);
		Iter_Remove(PlayerItem[playerid], itemid);
		return 1;
	}
	
	if(IsPlayerInAnyVehicle(playerid))
	{
	    new	vehid = GetVehicleIndex(GetPlayerVehicleID(playerid)), veh_uid = VehicleCache[vehid][vUID], query[256];
		mysql_format(MysqlHandle, query, sizeof(query), "UPDATE `myrp_items` SET item_place = '%d', item_owner = '%d' WHERE item_uid = '%d' LIMIT 1", PLACE_VEHICLE, veh_uid, PlayerItemCache[playerid][itemid][iUID]);

   		format(string, sizeof(string), "* %s odk³ada przedmiot w pojeŸdzie.", PlayerName(playerid));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);

		//printf("[item] %s (UID: %d, GID: %d) od³o¿y³ przedmiot %s (UID: %d) w pojeŸdzie (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], ItemCache[itemid][iName], ItemCache[itemid][iUID], CarInfo[vehid][cUID]);

		UnloadPlayerItem(playerid, itemid);
		Iter_Remove(PlayerItem[playerid], itemid);
	    return 1;
	}
	return 1;
}

public OnPlayerRaiseItem(playerid, item_uid)
{
	if(GetItemOwner(item_uid) != INVALID_PLAYER_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tego przedmiotu ju¿ tutaj nie ma.");
	    return 1;
	}
	
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    new query[256];
		mysql_format(MysqlHandle, query, sizeof(query), "UPDATE `myrp_items` SET item_place = '%d', item_owner = '%d' WHERE item_place = '%d' AND item_owner = '0' AND item_uid = '%d' LIMIT 1", PLACE_PLAYER, PlayerCache[playerid][pUID], PLACE_NONE, item_uid);
	    new Cache:cache_id = mysql_query(MysqlHandle, query, true);
	
		if(cache_affected_rows() <= 0)
		{
	    	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tego przedmiotu ju¿ tutaj nie ma.");
	    	return 1;
		}
		cache_delete(cache_id);
	
		new object_id, object_extra_id = (item_uid * -1);
		for (new player_object = 0; player_object <= MAX_OBJECTS; player_object++)
		{
 			if(IsValidPlayerObject(playerid, player_object))
 			{
				object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);
				if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID) == object_extra_id)
  				{
					DestroyDynamicObject(object_id);
					break;
				}
			}
		}
	}
	else
	{
	    new vehid = GetVehicleIndex(GetPlayerVehicleID(playerid)), veh_uid = VehicleCache[vehid][vUID];
	    mysql_format(MysqlHandle, "UPDATE `myrp_items` SET item_place = '%d', item_owner = '%d' WHERE item_place = '%d' AND item_owner = '%d' AND item_uid = '%d' LIMIT 1", PLACE_PLAYER, PlayerCache[playerid][pUID], PLACE_VEHICLE, veh_uid, item_uid);

		if(cache_affected_rows() <= 0)
		{
	    	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tego przedmiotu ju¿ tutaj nie ma.");
	    	return 1;
		}
	}

	LoadPlayerItem(playerid, item_uid);
	return 1;
}

public ShowPlayerItemInfo(playerid, item_uid)
{
	new owner_id = GetItemOwner(item_uid);
	if(owner_id == INVALID_PLAYER_ID)
	{
	    return 1;
	}
	new itemid = GetPlayerItemID(owner_id, item_uid),
		list_info[512], title[64],
	    item_type = PlayerItemCache[owner_id][itemid][iType];

	format(list_info, sizeof(list_info), "Identyfikator:\t\t%d\n", PlayerItemCache[owner_id][itemid][iUID]);
    format(list_info, sizeof(list_info), "%sTyp:\t\t\t%s\n\n", list_info, ItemTypeInfo[item_type][iTypeName]);
    
    if(owner_id != playerid)
    {
    	format(list_info, sizeof(list_info), "%sW³aœciciel:\t\t%s (%d)\n\n", list_info, PlayerName(owner_id), PlayerCache[owner_id][pUID]);
	}
	
	if(PlayerItemCache[owner_id][itemid][iUsed])
	{
	    format(list_info, sizeof(list_info), "%sStatus:\t\t\tW u¿yciu\n", list_info);
	}
	else
	{
		format(list_info, sizeof(list_info), "%sStatus:\t\t\tNieaktywny\n", list_info);
	}

	format(list_info, sizeof(list_info), "%sWaga:\t\t\t%dg\n\n", list_info, GetPlayerItemWeight(owner_id, itemid));

	format(list_info, sizeof(list_info), "%sW³aœciwoœæ 1:\t\t%d\n", list_info, PlayerItemCache[owner_id][itemid][iValue][0]);
	format(list_info, sizeof(list_info), "%sW³aœciwoœæ 2:\t\t%d\n\n", list_info, PlayerItemCache[owner_id][itemid][iValue][1]);

	//format(list_info, sizeof(list_info), "%sGrupa:\t\t\t%d\n", list_info, PlayerItemCache[owner_id][itemid][iGroup]);

	format(title, sizeof(title), "Informacje » %s", PlayerItemCache[owner_id][itemid][iName]);
	ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, title, list_info, "OK", "");
	return 1;
}

//  --- [VEHICLES MODULE]  --- //
stock GetVehicleID(veh_uid)
{
	new vehid = INVALID_VEHICLE_ID;
	foreach(new v : Vehicles)
	{
	    if(VehicleCache[v][vUID] == veh_uid)
	    {
	        vehid = v;
	        break;
	    }
	}
	return vehid;
}

stock GetVehicleUID(vehid)
{
	new veh_uid;
	foreach(new v : Vehicles)
	{
	    if(VehicleCache[v][vGID] == vehid)
	    {
	        veh_uid = VehicleCache[v][vUID];
	        break;
	    }
	}
	return veh_uid;
}

stock GetVehicleIndex(vehid)
{
	new index;
	foreach(new v : Vehicles)
	{
	    if(VehicleCache[v][vGID] == vehid)
	    {
	        index = v;
	        break;
	    }
	}
	return index;
}

stock GetPlayerVehiclesCount(playerid)
{
	new vehicles_count;
	foreach(new vehid : Vehicles)
	{
	    if(VehicleCache[vehid][vOwnerType] == OWNER_PLAYER && VehicleCache[vehid][vOwner] == PlayerCache[playerid][pUID])
	    {
			vehicles_count ++;
	    }
	}

	return vehicles_count;
}

public OnCreateVehicle(modelid, Float:cpos_x, Float:cpos_y, Float:cpos_z, Float:cpos_a, col1, col2)
{
	new vehid = Iter_Free(Vehicles), vehicleid;
	VehicleCache[vehid][vModel] = modelid;

	VehicleCache[vehid][vPos][0] = cpos_x;
	VehicleCache[vehid][vPos][1] = cpos_y;
	VehicleCache[vehid][vPos][2] = cpos_z;
	VehicleCache[vehid][vPos][3] = cpos_a;

	VehicleCache[vehid][vCol][0] = col1;
	VehicleCache[vehid][vCol][1] = col2;
	
	VehicleCache[vehid][vHealth] = 1000.0;

	new ORM:orm_id = VehicleCache[vehid][vOrm] = orm_create("myrp_vehicles", MysqlHandle);

	orm_addvar_int(orm_id, VehicleCache[vehid][vUID], "veh_uid");
	orm_addvar_int(orm_id, VehicleCache[vehid][vModel], "veh_model");

	orm_addvar_float(orm_id, VehicleCache[vehid][vPos][0], "veh_posx");
	orm_addvar_float(orm_id, VehicleCache[vehid][vPos][1], "veh_posy");
	orm_addvar_float(orm_id, VehicleCache[vehid][vPos][2], "veh_posz");
	orm_addvar_float(orm_id, VehicleCache[vehid][vPos][3], "veh_posa");

	orm_addvar_int(orm_id, VehicleCache[vehid][vCol][0], "veh_col1");
	orm_addvar_int(orm_id, VehicleCache[vehid][vCol][1], "veh_col2");

	orm_addvar_int(orm_id, VehicleCache[vehid][vInt], "veh_int");
	orm_addvar_int(orm_id, VehicleCache[vehid][vWorld], "veh_world");

	orm_addvar_int(orm_id, VehicleCache[vehid][vOwnerType], "veh_ownertype");
	orm_addvar_int(orm_id, VehicleCache[vehid][vOwner], "veh_owner");
	
	orm_addvar_float(orm_id, VehicleCache[vehid][vHealth], "veh_health");
	orm_addvar_float(orm_id, VehicleCache[vehid][vMileage], "veh_mileage");

    orm_setkey(orm_id, "veh_uid");
	orm_insert(orm_id);

	Iter_Add(Vehicles, vehid);

    vehicleid = VehicleCache[vehid][vGID] = CreateVehicle(modelid, cpos_x, cpos_y, cpos_z, cpos_a, col1, col2, 3600);

	ChangeVehicleEngineStatus(vehicleid, false);
	return vehid;
}

public DeleteVehicle(veh_uid)
{
	new vehid = GetVehicleID(veh_uid);

	DestroyVehicle(VehicleCache[vehid][vGID]);
	orm_delete(VehicleCache[vehid][vOrm]);

	Iter_Remove(Vehicles, vehid);
	return 1;
}

public LoadVehicles()
{
	new query[256];

	mysql_format(MysqlHandle, query, sizeof(query), "SELECT * FROM `myrp_vehicles` WHERE veh_ownertype <> %d", OWNER_PLAYER);
	mysql_tquery(MysqlHandle, query, "query_OnLoadVehicles", "");
	return 1;
}

public LoadVehicle(veh_uid)
{
	new query[256];

	mysql_format(MysqlHandle, query, sizeof(query), "SELECT * FROM `myrp_vehicles` WHERE veh_uid = '%d' LIMIT 1", veh_uid);
	mysql_tquery(MysqlHandle, query, "query_OnLoadVehicle", "");
	
	new vehid = GetVehicleID(veh_uid);
	return vehid;
}

public UnloadVehicle(veh_uid)
{
	new vehid = GetVehicleID(veh_uid);
	
	DestroyVehicle(VehicleCache[vehid][vGID]);
	orm_destroy(VehicleCache[vehid][vOrm]);
	
	for(new sVehicle:e; e < sVehicle; ++e)  VehicleCache[vehid][e] = 0;
	Iter_Remove(Vehicles, vehid);
	return 1;
}

//  --- [GROUPS MODULE]  --- //
stock GetGroupID(group_uid)
{
	new group_id = INVALID_GROUP_ID;
	foreach(new g : Groups)
	{
	    if(GroupCache[g][gUID] == group_uid)
	    {
	        group_id = g;
	        break;
	    }
	}
	return group_id;
}

stock GetPlayerGroupID(playerid, group_uid)
{
	new group_id = INVALID_GROUP_ID;
	foreach(new slot : PlayerGroup[playerid])
	{
	    if(PlayerGroup[playerid][slot][gpUID] == group_uid)
	    {
			group_id = PlayerGroup[playerid][slot][gpID];
			break;
	    }
	}
	return group_id;
}

stock IsPlayerInGroup(playerid, group_uid)
{
	foreach(new slot : PlayerGroup[playerid])
	{
	    if(PlayerGroup[playerid][slot][gpUID] == group_uid)
	    {
	        return true;
	    }
	}
	return false;
}

stock IsPlayerInGroupChild(playerid, group_uid)
{
	new group_id;
	foreach(new slot : PlayerGroup[playerid])
	{
	    if(PlayerGroup[playerid][slot][gpUID])
	    {
	        group_id = PlayerGroup[playerid][slot][gpID];
	        if(GroupCache[group_id][gOwner] == group_uid)
	        {
	            return true;
	        }
	    }
	}
	return false;
}

stock GetPlayerGroupSlot(playerid, group_uid)
{
	new group_slot = INVALID_SLOT_ID;
	foreach(new slot : PlayerGroup[playerid])
	{
	    if(PlayerGroup[playerid][slot][gpUID] == group_uid)
	    {
			group_slot = slot;
			break;
	    }
	}
	return group_slot;
}

stock IsPlayerInGroupType(playerid, group_type)
{
	new group_id;
	foreach(new slot : PlayerGroup[playerid])
	{
	    if(PlayerGroup[playerid][slot][gpUID])
	    {
			group_id = PlayerGroup[playerid][slot][gpID];
			if(GroupCache[group_id][gType] == group_type)
			{
				return true;
			}
	    }
	}
	return false;
}

stock IsPlayerInAnyGroup(playerid)
{
	if(Iter_Count(PlayerGroup[playerid]) <= 0)
	{
	    return false;
	}
	return true;
}

stock HavePlayerGroupPerm(playerid, group_uid, permission)
{
	new group_id = GetGroupID(group_uid), group_slot;
	if(GroupCache[group_id][gOwner])
	{
	    if(IsPlayerInGroup(playerid, GroupCache[group_id][gOwner]))
	    {
	        group_slot = GetPlayerGroupSlot(playerid, GroupCache[group_id][gOwner]);
	        if(PlayerGroup[playerid][group_slot][gpPerm] & permission)
	        {
	            return true;
	        }
	    }
	}
	
 	if(IsPlayerInGroup(playerid, group_uid))
 	{
  		group_slot = GetPlayerGroupSlot(playerid, group_uid);
    	if(PlayerGroup[playerid][group_slot][gpPerm] & permission)
     	{
      		return true;
        }
	}
	return false;
}

public CreateGroup(group_name[32], group_type)
{
	new group_id = Iter_Free(Groups);
	
	strmid(GroupCache[group_id][gName], group_name, 0, strlen(group_name), 32);
	strmid(GroupCache[group_id][gTag], "NONE", 0, 5, 5);
	
	GroupCache[group_id][gType] = group_type;
	GroupCache[group_id][gColor] = COLOR_WHITE;

	new ORM:orm_id = GroupCache[group_id][gOrm] = orm_create("myrp_groups", MysqlHandle);
	
	orm_addvar_int(orm_id, GroupCache[group_id][gUID], "group_uid");
	orm_addvar_string(orm_id, GroupCache[group_id][gName], 32, "group_name");
	
	orm_addvar_int(orm_id, GroupCache[group_id][gType], "group_type");
	orm_addvar_int(orm_id, GroupCache[group_id][gCash], "group_cash");
	
	orm_addvar_string(orm_id, GroupCache[group_id][gTag], 5, "group_tag");
	
	orm_addvar_int(orm_id, GroupCache[group_id][gColor], "group_color");
	orm_addvar_int(orm_id, GroupCache[group_id][gFlags], "group_flags");
	
	orm_addvar_int(orm_id, GroupCache[group_id][gOwner], "group_owner");
	
	orm_setkey(orm_id, "group_uid");
	orm_insert(orm_id);
	
	Iter_Add(Groups, group_id);
	return group_id;
}

public LoadGroups()
{
	mysql_tquery(MysqlHandle, "SELECT * FROM `myrp_groups`", "query_OnLoadGroups", "");
	return 1;
}

public DeleteGroup(group_id)
{
	new slot, query[128];
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(IsPlayerInGroup(i, GroupCache[group_id][gUID]))
	        {
	            slot = GetPlayerGroupSlot(i, GroupCache[group_id][gUID]);
	            for(new sPlayerGroup:e; e < sPlayerGroup; ++e)					PlayerGroup[i][slot][e] = 0;
	        }
	    }
	}
	mysql_format(MysqlHandle, query, sizeof(query), "DELETE FROM `myrp_char_groups` WHERE group_belongs = '%d'", GroupCache[group_id][gUID]);
	mysql_query(MysqlHandle, query);

	orm_delete(GroupCache[group_id][gOrm]);
	Iter_Remove(Groups, group_id);
	return 1;
}

public LoadPlayerGroups(playerid)
{
	new query[256];

	mysql_format(MysqlHandle, query, sizeof(query), "SELECT `group_uid`, `group_perm`, `group_title`, `group_payment`, `group_skin`, `group_tag`, `group_color`, `group_flags` FROM `myrp_groups`, `myrp_char_groups` WHERE myrp_groups.group_uid = myrp_char_groups.group_belongs AND char_uid = '%d' LIMIT %d", PlayerCache[playerid][pUID], MAX_GROUP_SLOTS);
	mysql_tquery(MysqlHandle, query, "query_OnLoadPlayerGroups", "d", playerid);
	return 1;
}

public UnloadPlayerGroups(playerid)
{
	foreach(new group_slot : PlayerGroup[playerid])
	{
	    for(new sPlayerGroup:e; e < sPlayerGroup; ++e)	PlayerGroup[playerid][group_slot][e] = 0;
	}
	Iter_Clear(PlayerGroup[playerid]);
	return 1;
}

public ShowPlayerGroupOptions(playerid)
{
	new string[256], group_id;
	foreach(new slot : PlayerGroup[playerid])
	{
		group_id = PlayerGroup[playerid][slot][gpID];
		
		if(PlayerCache[playerid][pDuty][DUTY_GROUP] == group_id)
		{
	    	format(string, sizeof(string), "~>~ %s ~o~~n~~n~~n~~n~~n~~n~~n~", GroupCache[group_id][gTag]);
		}
		else
		{
            format(string, sizeof(string), "~>~ %s ~n~~n~~n~~n~~n~~n~~n~", GroupCache[group_id][gTag]);
		}
		PlayerTextDrawSetString(playerid, TD_MainGroupTag[playerid][slot], string);
		PlayerTextDrawColor(playerid, TD_MainGroupTag[playerid][slot], GroupCache[group_id][gColor]);

		format(string, sizeof(string), "%s (%d)", GroupCache[group_id][gName], GroupCache[group_id][gUID]);
		PlayerTextDrawSetString(playerid, TD_MainGroupName[playerid][slot], string);

		PlayerTextDrawShow(playerid, TD_MainGroupTag[playerid][slot]);
		PlayerTextDrawShow(playerid, TD_MainGroupName[playerid][slot]);

		for(new group_option = 0; group_option != 6; group_option++)	TextDrawShowForPlayer(playerid, TD_GroupOption[group_option][slot]);
	}
	SelectTextDraw(playerid, COLOR_GREEN);
	PlayerCache[playerid][pListPlayerGroups] = true;
	return 1;
}

public HidePlayerGroupOptions(playerid)
{
	foreach(new slot : PlayerGroup[playerid])
	{
		PlayerTextDrawHide(playerid, TD_MainGroupTag[playerid][slot]);
		PlayerTextDrawHide(playerid, TD_MainGroupName[playerid][slot]);
		
		for(new group_option = 0; group_option != 6; group_option++)	TextDrawHideForPlayer(playerid, TD_GroupOption[group_option][slot]);
	}
	CancelSelectTextDraw(playerid);
	PlayerCache[playerid][pListPlayerGroups] = false;
	return 1;
}

public ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5)
{
	new	Float:PosX, Float:PosY, Float:PosZ,
		WorldID, WorldID2;

	WorldID = GetPlayerVirtualWorld(playerid);
	GetPlayerPos(playerid, PosX, PosY, PosZ);

	if(strfind(string, "(radio)", true) == -1)	SendClientMessage(playerid, col1, string);

	if(IsPlayerInAnyVehicle(playerid) && col1 == COLOR_FADE1)
	{
	    new vehid = GetPlayerVehicleID(playerid);

		/*
		if(CarInfo[vehid][cGlass])
	    {
	    */
	   		foreach(new i : Player)
			{
				if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
				{
				    if(i != playerid)
				    {
				        if(GetPlayerVehicleID(i) == vehid)
				        {
				            SendClientMessage(i, col1, string);
				        }
					}
				}
			}
	    /*}
	    else
	    {
	        goto normal_chat;
	    }*/
	}
	else
	{
	    normal_chat:

		foreach(new i : Player)
		{
			if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
			{
			    if(i != playerid)
			    {
					WorldID2 = GetPlayerVirtualWorld(i);

					/*
					if(PlayerCache[i][pBW] && col1 != COLOR_PURPLE && col1 != COLOR_DO ||
					WorldID != WorldID2 ||
					col1 == COLOR_GREY && !PlayerCache[i][pOOC] ||
					IsPlayerInAnyVehicle(i) && CarInfo[GetPlayerVehicleID(i)][cGlass] && col1 == COLOR_FADE1) continue;
					*/
					
					if(IsPlayerInRangeOfPoint(i, radi/16, PosX, PosY, PosZ))
					{
						SendClientMessage(i, col1, string);
					}
					else if(IsPlayerInRangeOfPoint(i, radi/8, PosX, PosY, PosZ))
					{
						SendClientMessage(i, col2, string);
					}
					else if(IsPlayerInRangeOfPoint(i, radi/4, PosX, PosY, PosZ))
					{
						SendClientMessage(i, col3, string);
					}
					else if(IsPlayerInRangeOfPoint(i, radi/2, PosX, PosY, PosZ))
					{
						SendClientMessage(i, col4, string);
					}
					else if(IsPlayerInRangeOfPoint(i, radi, PosX, PosY, PosZ))
					{
						SendClientMessage(i, col5, string);
					}
				}
			}
		}
	}
	return 1;
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
	printf("ERROR [%d]: %s (%s) \"%s\"", errorid, error, callback, query);
	return 1;
}

stock PlayerName(playerid)
{
	new pos, name[MAX_PLAYER_NAME];
	strmid(name, PlayerCache[playerid][pCharName], 0, strlen(PlayerCache[playerid][pCharName]), 24);

	pos = strfind(name, "_", true);
	while(pos != -1)
	{
		name[pos] = ' ';
		pos = strfind(name, "_", true);
	}
	return name;
}

stock PlayerOnlineTime(playerid, &hours, &minutes, &seconds)
{
	new timestamp = PlayerCache[playerid][pOnlineTime] + (gettime() - PlayerCache[playerid][pSession][SESSION_GAME]) - PlayerCache[playerid][pSession][SESSION_AFK];
	
	hours = floatround(timestamp / 3600, floatround_floor);
	minutes = floatround(timestamp / 60, floatround_floor) % 60;
	seconds = timestamp % 60;
	
	return timestamp;
}

stock PlayerAFKTime(playerid, &hours, &minutes, &seconds)
{
	new timestamp = PlayerCache[playerid][pSession][SESSION_AFK];
	
	hours = floatround(timestamp / 3600, floatround_floor);
	minutes = floatround(timestamp / 60, floatround_floor) % 60;
	seconds = timestamp % 60;
	
	return timestamp;
}

stock mysql_query_format(mysql_handle, format_query[], va_args<>)
{
	new query[512];

	va_format(query, sizeof(query), format_query, va_start<2>);
	mysql_query(mysql_handle, query);
	return 1;
}

stock SendClientFormatMessage(playerid, color, formatDesc[], va_args<>)
{
	new string[256];
	va_format(string, sizeof(string), formatDesc, va_start<3>);

	SendClientMessage(playerid, color, string);
	return 1;
}

stock ShowPlayerInfoDialog(playerid, dialog_type, desc[], va_args<>)
{
	new string_desc[512], title[64];
	va_format(string_desc, sizeof(string_desc), desc, va_start<3>);

	switch(dialog_type)
	{
	    case D_TYPE_INFO:   	title = "Informacja";
	    case D_TYPE_ERROR:  	title = "Wyst¹pi³ b³¹d!";
	    case D_TYPE_SUCCESS:    title = "Powodzenie";
	    case D_TYPE_HELP:   	title = "Pomoc";
	    case D_TYPE_NO_PERM:    title = "Brak uprawnieñ";
	}
	
	ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, title, string_desc, "OK", "");
	return 1;
}

stock ShowTipForPlayer(playerid, tipDesc[], va_args<>)
{
	new string[256];
	va_format(string, sizeof(string), tipDesc, va_start<2>);

	format(string, sizeof(string), "Tip: %s", string);
	SendClientMessage(playerid, COLOR_GREY, string);
	return 1;
}

stock TD_ShowSmallInfo(playerid, showTime = 5, infoString[], va_args<>)
{
	new string[512];
	va_format(string, sizeof(string), infoString, va_start<3>);

	PlayerTextDrawSetString(playerid, PlayerText:TD_SmallInfo[playerid], string);
	PlayerTextDrawShow(playerid, PlayerText:TD_SmallInfo[playerid]);

	PlayerCache[playerid][pSmallTextTime] = (showTime > 0) ? (gettime() + showTime) : 0;
	return 1;
}

stock TD_HideSmallInfo(playerid)
{
	PlayerTextDrawHide(playerid, PlayerText:TD_SmallInfo[playerid]);
	PlayerCache[playerid][pSmallTextTime] = 0;
	return 1;
}

stock TD_ShowHint(playerid, hintType, showTime = -1, infoString[], va_args<>)
{
	if(PlayerCache[playerid][pHint] & hintType) return 1;
	
	new string[1024];
	va_format(string, sizeof(string), infoString, va_start<3>);

	PlayerTextDrawSetString(playerid, PlayerText:TD_Hint[playerid], string);
	PlayerTextDrawShow(playerid, PlayerText:TD_Hint[playerid]);

	PlayerCache[playerid][pHintTextTime] = (showTime > -1) ? (gettime() + showTime) : -1;
	PlayerCache[playerid][pHint] += hintType;
	return 1;
}

stock TD_HideHint(playerid)
{
	PlayerTextDrawHide(playerid, PlayerText:TD_Hint[playerid]);
	PlayerCache[playerid][pHintTextTime] = 0;
	return 1;
}


stock CreateTDForPlayer(playerid)
{
    TD_SmallInfo[playerid] = CreatePlayerTextDraw(playerid, 150.000000, 360.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, TD_SmallInfo[playerid], 255);
	PlayerTextDrawFont(playerid, TD_SmallInfo[playerid], 1);
	PlayerTextDrawLetterSize(playerid, TD_SmallInfo[playerid], 0.290000, 1.699999);
	PlayerTextDrawColor(playerid, TD_SmallInfo[playerid], -1);
	PlayerTextDrawSetOutline(playerid, TD_SmallInfo[playerid], 0);
	PlayerTextDrawSetProportional(playerid, TD_SmallInfo[playerid], 1);
	PlayerTextDrawSetShadow(playerid, TD_SmallInfo[playerid], 1);
	PlayerTextDrawUseBox(playerid, TD_SmallInfo[playerid], 1);
	PlayerTextDrawBoxColor(playerid, TD_SmallInfo[playerid], 0);
	PlayerTextDrawTextSize(playerid, TD_SmallInfo[playerid], 500.000000, 0.000000);
	
	TD_Hint[playerid] = CreatePlayerTextDraw(playerid, 450.000000, 120.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, TD_Hint[playerid], 255);
	PlayerTextDrawFont(playerid, TD_Hint[playerid], 1);
	PlayerTextDrawLetterSize(playerid, TD_Hint[playerid], 0.280000, 1.500000);
	PlayerTextDrawColor(playerid, TD_Hint[playerid], -1);
	PlayerTextDrawSetOutline(playerid, TD_Hint[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TD_Hint[playerid], 1);
	PlayerTextDrawUseBox(playerid, TD_Hint[playerid], 1);
	PlayerTextDrawBoxColor(playerid, TD_Hint[playerid], 68);
	PlayerTextDrawTextSize(playerid, TD_Hint[playerid], 607.000000, 170.000000);
	
	new Float:posX, Float:posY;
	for(new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
	{
	    posX = 190.000000;
		posY = 130.000000;
	    
		if(group_slot == 1) posX += 130.000000;
		if(group_slot == 2) posY += 110.000000;
		if(group_slot == 3)
		{
			posX += 130.000000;
			posY += 110.000000;
		}

		TD_MainGroupTag[playerid][group_slot] = CreatePlayerTextDraw(playerid, posX, posY, "_");
		TD_MainGroupName[playerid][group_slot] = CreatePlayerTextDraw(playerid, posX + 2.0, posY + 16.0, "_");

		PlayerTextDrawBackgroundColor(playerid, TD_MainGroupTag[playerid][group_slot], 255);
		PlayerTextDrawFont(playerid, TD_MainGroupTag[playerid][group_slot], 1);
		PlayerTextDrawLetterSize(playerid, TD_MainGroupTag[playerid][group_slot], 0.410000, 1.500000);
		PlayerTextDrawColor(playerid, TD_MainGroupTag[playerid][group_slot], -1);
		PlayerTextDrawSetOutline(playerid, TD_MainGroupTag[playerid][group_slot], 1);
		PlayerTextDrawSetProportional(playerid, TD_MainGroupTag[playerid][group_slot], 1);
		PlayerTextDrawUseBox(playerid, TD_MainGroupTag[playerid][group_slot], 1);
		PlayerTextDrawBoxColor(playerid, TD_MainGroupTag[playerid][group_slot], 68);
		
		if(group_slot == 1 || group_slot == 3)
		{
			PlayerTextDrawTextSize(playerid, TD_MainGroupTag[playerid][group_slot], 440.000000, 150.000000);
		}
		else
		{
		    PlayerTextDrawTextSize(playerid, TD_MainGroupTag[playerid][group_slot], 310.000000, 150.000000);
		}
		
		PlayerTextDrawBackgroundColor(playerid, TD_MainGroupName[playerid][group_slot], 255);
		PlayerTextDrawFont(playerid, TD_MainGroupName[playerid][group_slot], 1);
		PlayerTextDrawLetterSize(playerid, TD_MainGroupName[playerid][group_slot], 0.200000, 1.000000);
		PlayerTextDrawColor(playerid, TD_MainGroupName[playerid][group_slot], -1);
		PlayerTextDrawSetOutline(playerid, TD_MainGroupName[playerid][group_slot], 0);
		PlayerTextDrawSetProportional(playerid, TD_MainGroupName[playerid][group_slot], 1);
		PlayerTextDrawSetShadow(playerid, TD_MainGroupName[playerid][group_slot], 1);
	}

	return 1;
}

stock CreateGlobalTD()
{
	new Float:posX, Float:posY;
	for(new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
	{
	    posX = 225.0;
	    posY = 167.0;
	    
	    if(group_slot == 2 || group_slot == 3)	posY += 110.0;
	    if(group_slot == 1 || group_slot == 3)	posX = 355.0;
		
		TD_GroupOption[0][group_slot] = TextDrawCreate(posX, posY, "INFO");
		TD_GroupOption[1][group_slot] = TextDrawCreate(posX, posY + 20.0, "Magazyn");
		TD_GroupOption[2][group_slot] = TextDrawCreate(posX, posY + 40.0, "Sluzba");

		TD_GroupOption[3][group_slot] = TextDrawCreate(posX + 50.0, posY, "Pojazdy");
		TD_GroupOption[4][group_slot] = TextDrawCreate(posX + 50.0, posY + 20.0, "Online");
		TD_GroupOption[5][group_slot] = TextDrawCreate(posX + 50.0, posY + 40.0, "Zadania");
		
		for(new group_option = 0; group_option < 6; group_option++)
		{
			TextDrawAlignment(TD_GroupOption[group_option][group_slot], 2);
			TextDrawBackgroundColor(TD_GroupOption[group_option][group_slot], 255);
			TextDrawFont(TD_GroupOption[group_option][group_slot], 1);
			TextDrawLetterSize(TD_GroupOption[group_option][group_slot], 0.250000, 1.199999);
			TextDrawColor(TD_GroupOption[group_option][group_slot], -1);
			TextDrawSetOutline(TD_GroupOption[group_option][group_slot], 1);
			TextDrawSetProportional(TD_GroupOption[group_option][group_slot], 1);
			TextDrawUseBox(TD_GroupOption[group_option][group_slot], 1);
			TextDrawBoxColor(TD_GroupOption[group_option][group_slot], 136);
			TextDrawTextSize(TD_GroupOption[group_option][group_slot], 10.000000, 40.000000);
			TextDrawSetSelectable(TD_GroupOption[group_option][group_slot], true);
		}
	}
	return 1;
}

stock PlayerToPlayer(Float:radi, playerid, targetid)
{
	if(GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
	{
	    return 0;
	}

	new Float:posx, Float:posy, Float:posz,
		Float:oldposx, Float:oldposy, Float:oldposz,
		Float:tempposx, Float:tempposy, Float:tempposz;

	GetPlayerPos(playerid, oldposx, oldposy, oldposz);

	GetPlayerPos(targetid, posx, posy, posz);
	tempposx = (oldposx -posx);
	tempposy = (oldposy -posy);
	tempposz = (oldposz -posz);

 	if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
	{
		return 1;
	}
	return 0;
}

stock SetPlayerMoney(playerid, money)
{
	if(money < 0)   money = 0;
	
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, money);
	return 1;
}

stock escape_pl(name[])
{
    for(new i = 0; name[i] != 0; i++)
    {
	    if(name[i] == 'œ') name[i] = 's';
	    else if(name[i] == 'ê') name[i] = 'e';
	    else if(name[i] == 'ó') name[i] = 'o';
	    else if(name[i] == '¹') name[i] = 'a';
	    else if(name[i] == '³') name[i] = 'l';
	    else if(name[i] == '¿') name[i] = 'z';
	    else if(name[i] == 'Ÿ') name[i] = 'z';
	    else if(name[i] == 'æ') name[i] = 'c';
	    else if(name[i] == 'ñ') name[i] = 'n';
	    else if(name[i] == 'Œ') name[i] = 'S';
	    else if(name[i] == 'Ê') name[i] = 'E';
	    else if(name[i] == 'Ó') name[i] = 'O';
	    else if(name[i] == '¥') name[i] = 'A';
	    else if(name[i] == '£') name[i] = 'L';
	    else if(name[i] == '¯') name[i] = 'Z';
	    else if(name[i] == '') name[i] = 'Z';
	    else if(name[i] == 'Æ') name[i] = 'C';
	    else if(name[i] == 'Ñ') name[i] = 'N';
    }
}

stock ChangeVehicleEngineStatus(vehicleid, toggle)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, toggle, lights, false, doors, bonnet, boot, objective);
	return toggle;
}

stock GetVehicleEngineStatus(vehicleid)
{
	new bool: engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return engine;
}

stock SetVehicleLock(vehicleid, toggle)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, false, toggle, bonnet, boot, objective);
	return toggle;
}

stock ChangeVehicleLightsStatus(vehicleid, toggle)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, toggle, alarm, doors, bonnet, boot, objective);
	return toggle;
}

stock GetVehicleLightsStatus(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return lights;
}

stock ChangeVehicleBonnetStatus(vehicleid, toggle)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, toggle, boot, objective);
	return toggle;
}

stock GetVehicleBonnetStatus(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return bonnet;
}

stock ChangeVehicleBootStatus(vehicleid, toggle)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, toggle, objective);
	return toggle;
}

stock GetVehicleBootStatus(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return boot;
}

stock ChangeVehicleAlarmStatus(vehicleid, toggle)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, toggle, doors, bonnet, boot, objective);
	return toggle;
}

stock GetVehicleAlarmStatus(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return alarm;
}

stock GetVehicleDriver(vehicleid)
{
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
			if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
			{
			    if(GetPlayerVehicleID(i) == vehicleid)
			    {
			        return i;
			    }
			}
		}
	}
	return INVALID_PLAYER_ID;
}

SSCANF:vehicle(string[])
{
	new veh_model = INVALID_VEH_MODEL;
	if ('0' <= string[0] <= '9')
	{
		new
			ret = strval(string);
		if (400 <= ret <= 611)
		{
			return ret;
		}
	}
	for(new i = 0; i < sizeof(VehicleModelData); i++)
	{
		if(!strcmp(string, VehicleModelData[i][vName], true))
		{
			veh_model = i + 400;
			break;
		}
	}
	return veh_model;
}

SSCANF:item_type(string[])
{
	new item_type = INVALID_ITEM_TYPE;
	if ('0' <= string[0] <= '9')
	{
		new
			ret = strval(string);
		if (0 <= ret <= ITEM_COUNT)
		{
			return ret;
		}
	}
	for(new i = 0; i < sizeof(ItemTypeInfo); i++)
	{
		if(!strcmp(string, ItemTypeInfo[i][iTypeName], true))
		{
			item_type = i;
			break;
		}
	}
	return item_type;
}

SSCANF:group_type(string[])
{
	new group_type = INVALID_GROUP_TYPE;
	if ('0' <= string[0] <= '9')
	{
		new
			ret = strval(string);
		if (0 <= ret <= G_TYPE_COUNT)
		{
			return ret;
		}
	}
	for(new i = 0; i < sizeof(GroupTypeInfo); i++)
	{
		if(!strcmp(string, GroupTypeInfo[i][gTypeName], true))
		{
			group_type = i;
			break;
		}
	}
	return group_type;
}


public query_OnLoadPlayerGroups(playerid)
{
	new rows, group_slot, group_id;
	
	cache_get_row_count(rows);
	for(new row = 0; row != rows; row++)
	{
 		group_slot = Iter_Free(PlayerGroup[playerid]);
   		
   		cache_get_value_index_int(row, 0, group_id);

		if(group_id == INVALID_GROUP_ID)    continue;

		PlayerGroup[playerid][group_slot][gpUID] = GroupCache[group_id][gUID];
		cache_get_value_index_int(row, 1, PlayerGroup[playerid][group_slot][gpPerm]);
		
		cache_get_value_index(row, 2, PlayerGroup[playerid][group_slot][gpTitle], 32);
		
		cache_get_value_index_int(row, 3, PlayerGroup[playerid][group_slot][gpPayment]);
		cache_get_value_index_int(row, 4, PlayerGroup[playerid][group_slot][gpSkin]);

        cache_get_value_index(row, 5, GroupCache[group_id][gTag], 5);

        cache_get_value_index_int(row, 6, GroupCache[group_id][gColor]);
        cache_get_value_index_int(row, 7, GroupCache[group_id][gFlags]);

		PlayerGroup[playerid][group_slot][gpID] = group_id;
		Iter_Add(PlayerGroup[playerid], group_slot);
	}
	return rows;
}

public query_OnLoadGroups()
{
	new rows, group_id, ORM:orm_id;
	cache_get_row_count(rows);
	
	for(new row = 0; row != rows; row++)
	{
 		group_id = Iter_Free(Groups);
   		orm_id = GroupCache[group_id][gOrm] = orm_create("myrp_groups", MysqlHandle);

		orm_addvar_int(orm_id, GroupCache[group_id][gUID], "group_uid");
		orm_addvar_string(orm_id, GroupCache[group_id][gName], 32, "group_name");

		orm_addvar_int(orm_id, GroupCache[group_id][gType], "group_type");
		orm_addvar_int(orm_id, GroupCache[group_id][gCash], "group_cash");

		orm_addvar_string(orm_id, GroupCache[group_id][gTag], 5, "group_tag");

		orm_addvar_int(orm_id, GroupCache[group_id][gColor], "group_color");
		orm_addvar_int(orm_id, GroupCache[group_id][gFlags], "group_flags");

		orm_addvar_int(orm_id, GroupCache[group_id][gOwner], "group_owner");

		orm_setkey(orm_id, "group_uid");
		orm_apply_cache(orm_id, row, 0);

		Iter_Add(Groups, group_id);

		printf("ORM_ID: %d, ID: %d, UID: %d, NAME: %s", orm_id, group_id, GroupCache[group_id][gUID], GroupCache[group_id][gName]);
	}
	return rows;
}

public query_OnLoadVehicle()
{
	new query[256], vehid = INVALID_VEHICLE_ID, vehicleid;
	
 	vehid = Iter_Free(Vehicles);
 	new ORM:orm_id = VehicleCache[vehid][vOrm] = orm_create("myrp_vehicles", MysqlHandle);

	orm_addvar_int(orm_id, VehicleCache[vehid][vUID], "veh_uid");
	orm_addvar_int(orm_id, VehicleCache[vehid][vModel], "veh_model");

	orm_addvar_float(orm_id, VehicleCache[vehid][vPos][0], "veh_posx");
	orm_addvar_float(orm_id, VehicleCache[vehid][vPos][1], "veh_posy");
	orm_addvar_float(orm_id, VehicleCache[vehid][vPos][2], "veh_posz");
	orm_addvar_float(orm_id, VehicleCache[vehid][vPos][3], "veh_posa");

	orm_addvar_int(orm_id, VehicleCache[vehid][vCol][0], "veh_col1");
	orm_addvar_int(orm_id, VehicleCache[vehid][vCol][1], "veh_col2");

	orm_addvar_int(orm_id, VehicleCache[vehid][vInt], "veh_int");
	orm_addvar_int(orm_id, VehicleCache[vehid][vWorld], "veh_world");

	orm_addvar_int(orm_id, VehicleCache[vehid][vOwnerType], "veh_ownertype");
	orm_addvar_int(orm_id, VehicleCache[vehid][vOwner], "veh_owner");

	orm_addvar_float(orm_id, VehicleCache[vehid][vHealth], "veh_health");
	orm_addvar_float(orm_id, VehicleCache[vehid][vMileage], "veh_mileage");

	orm_setkey(orm_id, "veh_uid");
	orm_apply_cache(orm_id, 0, 0);

	Iter_Add(Vehicles, vehid);
	vehicleid = VehicleCache[vehid][vGID] = CreateVehicle(VehicleCache[vehid][vModel], VehicleCache[vehid][vPos][0], VehicleCache[vehid][vPos][1], VehicleCache[vehid][vPos][2], VehicleCache[vehid][vPos][3], VehicleCache[vehid][vCol][0], VehicleCache[vehid][vCol][1], 3600);

	SetVehicleHealth(vehicleid, VehicleCache[vehid][vHealth]);
	ChangeVehicleEngineStatus(VehicleCache[vehid][vGID], false);
	return vehid;
}

public query_OnLoadVehicles()
{
	new rows, vehid, ORM:orm_id, vehicleid;
	cache_get_row_count(rows);
	
	for(new row = 0; row != rows; row++)
	{
 		vehid = Iter_Free(Vehicles);
 		orm_id = VehicleCache[vehid][vOrm] = orm_create("myrp_vehicles", MysqlHandle);

		orm_addvar_int(orm_id, VehicleCache[vehid][vUID], "veh_uid");
		orm_addvar_int(orm_id, VehicleCache[vehid][vModel], "veh_model");

		orm_addvar_float(orm_id, VehicleCache[vehid][vPos][0], "veh_posx");
		orm_addvar_float(orm_id, VehicleCache[vehid][vPos][1], "veh_posy");
		orm_addvar_float(orm_id, VehicleCache[vehid][vPos][2], "veh_posz");
		orm_addvar_float(orm_id, VehicleCache[vehid][vPos][3], "veh_posa");

		orm_addvar_int(orm_id, VehicleCache[vehid][vCol][0], "veh_col1");
		orm_addvar_int(orm_id, VehicleCache[vehid][vCol][1], "veh_col2");

		orm_addvar_int(orm_id, VehicleCache[vehid][vInt], "veh_int");
		orm_addvar_int(orm_id, VehicleCache[vehid][vWorld], "veh_world");

		orm_addvar_int(orm_id, VehicleCache[vehid][vOwnerType], "veh_ownertype");
		orm_addvar_int(orm_id, VehicleCache[vehid][vOwner], "veh_owner");

		orm_addvar_float(orm_id, VehicleCache[vehid][vHealth], "veh_health");
		orm_addvar_float(orm_id, VehicleCache[vehid][vMileage], "veh_mileage");

		orm_setkey(orm_id, "veh_uid");
		orm_apply_cache(orm_id, row, 0);

		Iter_Add(Vehicles, vehid);

		printf("ORM_ID: %d, ID: %d, UID: %d, MODEL: %d", orm_id, vehid, VehicleCache[vehid][vUID], VehicleCache[vehid][vModel]);
		vehicleid = VehicleCache[vehid][vGID] = CreateVehicle(VehicleCache[vehid][vModel], VehicleCache[vehid][vPos][0], VehicleCache[vehid][vPos][1], VehicleCache[vehid][vPos][2], VehicleCache[vehid][vPos][3], VehicleCache[vehid][vCol][0], VehicleCache[vehid][vCol][1], 3600);

		SetVehicleHealth(vehicleid, VehicleCache[vehid][vHealth]);
		ChangeVehicleEngineStatus(VehicleCache[vehid][vGID], false);
	}
	return rows;
}

public query_OnLoadPlayerItems(playerid)
{
	new rows, itemid, ORM:orm_id;
	cache_get_row_count(rows);
	
	if(rows > 0)
	{
		for(new row = 0; row != rows; row++)
		{
			itemid = Iter_Free(PlayerItem[playerid]);
			orm_id = PlayerItemCache[playerid][itemid][iOrm] = orm_create("myrp_items", MysqlHandle);

			orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iUID], "item_uid");
			orm_addvar_string(orm_id, PlayerItemCache[playerid][itemid][iName], 32, "item_name");

			orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iValue][0], "item_value1");
			orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iValue][1], "item_value2");

			orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iPlace], "item_place");
			orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iOwner], "item_owner");

			orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iType], "item_type");
			orm_addvar_int(orm_id, PlayerItemCache[playerid][itemid][iFavorite], "item_favorite");

			orm_setkey(orm_id, "item_uid");
			orm_apply_cache(orm_id, row, 0);

			Iter_Add(PlayerItem[playerid], itemid);
		}
	}
	return rows;
}

public query_OnListPlayerNearItems(playerid)
{
	new list_items[1024], item_uid, item_name[32], rows;
	format(list_items, sizeof(list_items), "Identyfikator\t*\tNazwa przedmiotu\n» Podnieœ\n---\n");
		
	DynamicGui_Init(playerid);
	
	DynamicGui_AddRow(playerid, D_ITEM_RAISE, 0);
	DynamicGui_AddRow(playerid, D_ITEM_RAISE, 0);
		
    cache_get_row_count(rows);
	for(new row = 0; row != rows; row++)
	{
		cache_get_value_index_int(row, 0, item_uid);
		cache_get_value_index(row, 1, item_name, 32);

		if(Iter_Contains(CheckedPlayerItem[playerid], item_uid))
		{
			format(list_items, sizeof(list_items), "%s\n%d\t[X]\t%s", list_items, item_uid, item_name);
		}
		else
		{
			format(list_items, sizeof(list_items), "%s\n%d\t[ ]\t%s", list_items, item_uid, item_name);
		}
		DynamicGui_AddRow(playerid, D_ITEM_RAISE, item_uid);
	}
	
	ground_items_cache[playerid] = cache_save();
	ShowPlayerDialog(playerid, D_ITEM_RAISE, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty znajduj¹ce siê w pobli¿u:", list_items, "Podnieœ", "Anuluj");
	return rows;
}

public query_OnListPlayerBagItems(playerid)
{
	new rows, list_items[512] = "Identyfikator\tNazwa przedmiotu", item_uid, item_name[32];

    cache_get_row_count(rows);
	for(new row = 0; row != rows; row++)
	{
		cache_get_value_index_int(row, 0, item_uid);
		cache_get_value_index(row, 1, item_name);

		format(list_items, sizeof(list_items), "%s\n%d\t\t%s", list_items, item_uid, item_name);
	}
	if(rows > 0)
	{
		ShowPlayerDialog(playerid, D_ITEM_REMOVE_BAG, DIALOG_STYLE_TABLIST_HEADERS, "Znaleziono przedmioty:", list_items, "Wyjmij", "Wróæ");
	}
	else
	{
		CallLocalFunction("ListPlayerItems", "d", playerid);
		TD_ShowSmallInfo(playerid, 5, "Nie znaleziono ~r~zadnych ~w~przedmiotow.");
	}
	return rows;
}

public query_OnListPlayerVehicles(playerid)
{
	new list_vehicles[256] = "Identyfikator\tNazwa pojazdu",
		veh_uid, veh_model, rows = cache_num_rows();

	if(rows > 0)
	{
		for(new row = 0; row != rows; row++)
		{
			cache_get_value_index_int(row, 0, veh_uid);
			cache_get_value_index_int(row, 1, veh_model);

			format(list_vehicles, sizeof(list_vehicles), "%s\n%d\t%s", list_vehicles, veh_uid, GetVehicleName(veh_model));
		}

		ShowPlayerDialog(playerid, D_VEH_SPAWN, DIALOG_STYLE_TABLIST_HEADERS, "Lista Twoich pojazdów:", list_vehicles, "(Un)spawn", "Anuluj");
	}
	else
	{
		TD_ShowSmallInfo(playerid, 5, "Nie posiadasz ~r~zadnych ~w~pojazdow.");
	}
	return rows;
}

// SIMPLE TIMERS
timer OnKickPlayer[50](playerid)
{
	Kick(playerid);
	return 1;
}

timer OnPlayerPutVehicle[100](playerid, seatid, veh_uid)
{
	new vehid = GetVehicleID(veh_uid);
	PutPlayerInVehicle(playerid, VehicleCache[vehid][vGID], seatid);
	return 1;
}

timer OnVehicleEngineStarted[1000](vehicleid)
{
	new playerid = GetVehicleDriver(vehicleid),
		vehid = GetVehicleIndex(vehicleid);
		
	if(playerid == INVALID_PLAYER_ID)
	{
	    return 1;
	}
	if(GetVehicleEngineStatus(vehicleid))
	{
	    return 1;
	}
	/*
	if(VehicleCache[vehid][vFuel] <= 0)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W tym pojeŸdzie nie ma paliwa.\nZatankuj pojazd, aby móc odpaliæ silnik.");
	    return 1;
	}
	*/
	ChangeVehicleEngineStatus(vehicleid, true);
	TD_ShowSmallInfo(playerid, 3, "Silnik zostal ~g~uruchomiony ~w~pomyslnie.");

	//printf("[cars][%d][char][%d] %s (UID: %d, GID: %d) odpalil silnik pojazdu %s (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], GetVehicleName(CarInfo[vehicleid][cModel]), CarInfo[vehicleid][cUID]);
	return 1;
}
