/*
				*** DESCRIPTION ***
Autorem skryptu jest Mario. Wszelkie prawa zastrze�one.
G��wnym pomys�odawc� rozwi�za� jest autor we w�asnej osobie.

*/

// Includes
#include <a_samp>
#include <mysql>
#include <zcmd>
#include <md5>
#include <sscanf2>
//#include <foreach>
#include <streamer>
#include <audio>
#include <bcrypt>
//#include <mtime>

#include <YSI\y_va>
#include <YSI\y_timers>
#include <YSI\y_iterate>

// Main config
#define GAMEMODE		"MRP �"
#define VERSION			"0.1"
#define SERVER_NAME 	"Mighty RolePlay"
#define WEB_URL         "www.mighty-rp.pl"

// Database config
#define SQL_HOST        "127.0.0.1"
#define SQL_USER        "mysqladmin"
#define SQL_PASS        "aE#4^h%k9nrg"
#define SQL_DTBS        "samp"
#define SQL_PREF     	"mrp_"

//#pragma tabsize 0
//#pragma dynamic 8196

#define INVALID_GROUP_ID    (-1)
#define INVALID_SLOT_ID 	(-1)
#define INVALID_DOOR_ID     (-1)
#define INVALID_ITEM_ID     (-1)
#define INVALID_AREA_ID     (-1)
#define INVALID_SKIN_ID     (-1)
#define INVALID_ANIM_ID     (-1)
#define INVALID_ACCESS_ID   (-1)
#define INVALID_PRODUCT_ID  (-1)
#define INVALID_PACKAGE_ID  (-1)

#undef MAX_PLAYERS
#undef MAX_VEHICLES

// Limitations
#define MAX_PLAYERS         500
#define MAX_VEHICLES        800
#define MAX_DOORS           800
#define MAX_AREAS           150
#define MAX_ITEM_CACHE      3500
#define MAX_PRODUCTS        1500
#define MAX_ACCESS          200
#define MAX_SKINS           200
#define MAX_ANIMS           200
#define MAX_PACKAGES        100
#define MAX_RACE_CP         200
#define	MAX_DRAW_DISTANCE   100.0

#define MAX_GROUPS          350
#define MAX_GROUP_SLOTS     5

#define ACTIVITY_LIMIT      1000

#define PACC_VEHICLES    	3
#define FACC_VEHICLES   	1

#define PACC_POINTS         15
#define FACC_POINTS         10

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

#define MAKE_COLOUR(%0,%1,%2) \
		((((%0) & 0xFF) << 16) | (((%1) & 0xFF) << 8) | (((%2) & 0xFF) << 0))
		
#define MAKE_COLOUR_AA(%0,%1,%2) \
		((((%0) & 0xFF) << 24) | (((%1) & 0xFF) << 16) | (((%2) & 0xFF) << 8) | 0xAA)
		
#define MAKE_COLOUR_ALPHA(%0,%1,%2,%3) \
 		((((%0) & 0xFF) << 24) | (((%1) & 0xFF) << 16) | (((%2) & 0xFF) << 8) | (((%3) & 0xFF) << 0))

#define chrtoupper(%1) \
        (((%1) > 0x60 && (%1) <= 0x7A) ? ((%1) ^ 0x20) : (%1))

#define chrtolower(%1) \
        (((%1) > 0x40 && (%1) <= 0x5A) ? ((%1) | 0x20) : (%1))

/*#define isnull(%1) \
		((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
*/

#define PRESSED(%0) \
		(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define HOLDING(%0) \
		((newkeys & (%0)) == (%0))
		
#define RELEASED(%0) \
		(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define GetObjectUID(%0) \
		Streamer_GetIntData(STREAMER_TYPE_OBJECT, %0, E_STREAMER_EXTRA_ID)

#define GetObjectModel(%0) \
		Streamer_GetIntData(STREAMER_TYPE_OBJECT, %0, E_STREAMER_MODEL_ID)

#define GetLabelUID(%0) \
		Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL, %0, E_STREAMER_EXTRA_ID)
		
#define GetAreaUID(%0) \
		Streamer_GetIntData(STREAMER_TYPE_AREA, %0, E_STREAMER_EXTRA_ID)

#define GetVehicleName(%0) \
		VehicleModelData[%0 - 400][vName]
		
#define GetVehicleMaxFuel(%0) \
		VehicleModelData[%0 - 400][vMaxFuel]
		
#define GetVehicleMaxSpeed(%0) \
		VehicleModelData[%0 - 400][vMaxSpeed]
		
#define IsPlayerPremium(%0) \
		((PlayerCache[%0][pPremium] > gettime()) ? true : false)

// Typy InfoDialogs
#define D_TYPE_INFO     		0
#define D_TYPE_ERROR    		1
#define D_TYPE_SUCCESS  		2
#define D_TYPE_HELP     		3
#define D_TYPE_NO_PERM  		4

// Typy sesji
#define SESSION_NONE    		0
#define SESSION_LOGIN           1
#define SESSION_GAME            2
#define SESSION_GROUP           3
#define SESSION_ADMIN           4
#define SESSION_AFK             5

// Zapis gracza
#define SAVE_PLAYER_BASIC   	1
#define SAVE_PLAYER_POS     	2
#define SAVE_PLAYER_SETTING     4

// Zapis pojazdu
#define SAVE_VEH_POS        	1
#define SAVE_VEH_ACCESS     	2
#define SAVE_VEH_COUNT      	4
#define SAVE_VEH_THINGS     	8
#define SAVE_VEH_LOCK       	16

// Rodzaje paliw
#define FUEL_TYPE_BENS      	0
#define FUEL_TYPE_GAS       	1
#define FUEL_TYPE_DIESEL    	2

// Zapis drzwi
#define SAVE_DOOR_ENTER     	1
#define SAVE_DOOR_EXIT      	2
#define SAVE_DOOR_THINGS    	4
#define SAVE_DOOR_AUDIO     	8
#define SAVE_DOOR_LOCK      	16

// Typ opcji (groups)
#define GROUP_OPTION_INFO       0
#define GROUP_OPTION_CARS       1
#define GROUP_OPTION_DUTY       2
#define GROUP_OPTION_MAGAZINE   3
#define GROUP_OPTION_ONLINE     4

// Typ opcji (items)
#define ITEM_OPTION_USE         0
#define ITEM_OPTION_DROP        1

// Typy grup
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

// Typy w�a�cicieli
#define OWNER_NONE      		0
#define OWNER_PLAYER    		1
#define OWNER_GROUP     		2

// Uprawnienia (groups)
#define G_PERM_CARS       		1
#define G_PERM_DOORS      		2
#define G_PERM_OFFER      		4
#define G_PERM_ORDER      		8
#define G_PERM_CHAT       		16
#define G_PERM_GATE       		32
#define G_PERM_LEADER     		64
#define G_PERM_MAX          	127

// Uprawnienia (admins)
#define A_PERM_BASIC        	1
#define A_PERM_GROUPS       	2
#define A_PERM_CARS         	4
#define A_PERM_DOORS        	8
#define A_PERM_ITEMS        	16
#define A_PERM_PUNISH       	32
#define A_PERM_AREAS        	64
#define A_PERM_OBJECTS      	128
#define A_PERM_3DTEXTS          256
#define A_PERM_MAX              511

// Miejsce przedmiot�w
#define PLACE_NONE          	0
#define PLACE_PLAYER        	1
#define PLACE_VEHICLE       	2
#define PLACE_BAG           	3
#define PLACE_CRAFT             4
#define PLACE_CLOSET            5

// Typy przedmiot�w
#define ITEM_NONE           	0   // Brak
#define ITEM_WATCH          	1   // Zegarek
#define ITEM_FOOD           	2   // Jedzenie (value1 = ilo�� hp)
#define ITEM_CIGGY          	3   // Papierosy (value1 = ilo�� sztuk)
#define ITEM_CUBE           	4   // Kostka do gry
#define ITEM_CLOTH          	5   // Ubranie (value1 = id skinu)
#define ITEM_WEAPON         	6   // Bro� (value1 = model broni, value2 = amunicja)
#define ITEM_AMMO           	7   // Amunicja (value1 = model broni, value2 = ilo�� amunicji)
#define ITEM_PHONE          	8   // Telefon (value1 = numer telefonu)
#define ITEM_CANISTER       	9   // Karnister (value1 = ilo�� paliwa, value2 = typ paliwa)
#define ITEM_MASK           	10  // Maska
#define ITEM_INHIBITOR      	11  // Paralizator (value2 = ilo�� naboi)
#define ITEM_PAINT          	12  // Lakier (value2 = ilo�� naboi)
#define ITEM_HANDCUFFS      	13  // Kajdanki
#define ITEM_MEGAPHONE      	14  // Megafon
#define ITEM_LINE           	15  // Lina holownicza
#define ITEM_NOTEBOOK       	16  // Notes (value1 = ilo�� karteczek)
#define ITEM_CHIT           	17  // Karteczka (value1 = uid wpisu w bazie)
#define ITEM_TUNING         	18  // Cz�� tuningu (value1 = id komponentu)
#define ITEM_CHECKBOOK      	19  // Ksia�eczka czekowa (value1 = ilo�� czek�w)
#define ITEM_CHECK          	20  // Czek (value1 = ilo�� pieni�dzy)
#define ITEM_BAG            	21  // Torba
#define ITEM_DRINK          	22  // Nap�j (value1 = special_action (20 - piwo, 22 - wino, 23 - sprunk))
#define ITEM_VEH_ACCESS         23  // Akcesoria do pojazdu
#define ITEM_DISC               24  // P�yta (value1 = uid wpisu w bazie)
#define ITEM_PLAYER             25  // Odtwarzacz (value1 = uid wpisu w bazie)
#define ITEM_CLOTH_ACCESS       26  // Akcesoria postaci (value1 = uid wpisu w bazie)
#define ITEM_PASS               27  // Karnet (value1 = czas, value2 = uid biznesu)
#define ITEM_CAR_CARD           28  // Karta pojazdu (value1 = model, value2 = w�a�ciciel)
#define ITEM_ROLL               29  // Rolki
#define ITEM_MEDICINE           30  // Medykament (value1 = hp)
#define ITEM_DRUG               31  // Narkotyk (value1 = typ narkotyku, value2 = pozosta�e)
#define ITEM_JOINT              32  // Joint (value1 = waga, value2 = jako�� [0-3])
#define ITEM_KEYS               33  // Kluczyki (value1 = uid pojazdu)
#define ITEM_GLOVES             34  // R�kawiczki
#define ITEM_CORPSE             35  // Zw�oki (value1 = uid wpisu w bazie)
#define ITEM_MOLOTOV            36  // Koktajl molotova
#define ITEM_BOOMBOX            37  // Boombox (value1 = uid wpisu w bazie)
#define ITEM_CRAFT              38  // Crafting (value1 = binarka, value2 = typ przedmiotu)
#define ITEM_FLASHLIGHT         39  // Latarka

#define ITEM_COUNT              39

// Zapis przedmiot�w
#define SAVE_ITEM_NAME      	1
#define SAVE_ITEM_VALUES    	2
#define SAVE_ITEM_TYPE      	4
#define SAVE_ITEM_OWNER     	8
#define SAVE_ITEM_USED      	16
#define SAVE_ITEM_GROUP         32

// Zapis produkt�w
#define SAVE_PRODUCT_THINGS 1
#define SAVE_PRODUCT_VALUES 2

// Typy list produkt�w
#define PRODUCT_LIST_NONE       1
#define PRODUCT_LIST_OFFER   	2
#define PRODUCT_LIST_BUY     	3
#define PRODUCT_LIST_OPTIONS    4
#define PRODUCT_LIST_PRICE      5

// W�a�ciciel produkt�w
#define PRODUCT_OWNER_NONE      0
#define PRODUCT_OWNER_DOOR      1
#define PRODUCT_OWNER_AREA      2

// Typy ofert
#define OFFER_NONE              0
#define OFFER_ITEM              1
#define OFFER_VEHICLE           2
#define OFFER_PRODUCT           3
#define OFFER_VCARD             4
#define OFFER_DOOR              5
#define OFFER_TOWING            6
#define OFFER_PASSAGE           7
#define OFFER_REFUEL            8
#define OFFER_REPAIR            9
#define OFFER_PAINT             10
#define OFFER_PAINTJOB          11
#define OFFER_MONTAGE           12
#define OFFER_MANDATE           13
#define OFFER_UNBLOCK           14
#define OFFER_DOCUMENT          15
#define OFFER_BUSINESS          16
#define OFFER_REGISTER          17
#define OFFER_HEAL              18
#define OFFER_PASS              19
#define OFFER_WELCOME           20
#define OFFER_ADVERTISE         21
#define OFFER_SALON             22
#define OFFER_TAX               23
#define OFFER_KEYS              24
#define OFFER_STYLE             25
#define OFFER_LESSON           	26

// Rodzaje p�atno�ci
#define PAY_TYPE_NONE           0
#define PAY_TYPE_CASH           1
#define PAY_TYPE_CARD           2

// Specjalne numery
#define NUMBER_NONE             000
#define NUMBER_WHOLESALE        333
#define NUMBER_TAXI             777
#define NUMBER_ALARM            911
#define NUMBER_NEWS             444

// Rodzaje audio
#define AUDIO_NONE              0
#define AUDIO_CALLING           1
#define AUDIO_SMS               2
#define AUDIO_ALARM             3
#define AUDIO_LSPD              4
#define AUDIO_MESSAGE           5
#define AUDIO_ACHIEVE           6

// Sloty obiekt�w
#define SLOT_PHONE              0
#define SLOT_WEAPON             1
#define SLOT_HANDCUFFS          2
#define SLOT_ACCESS_1      		3
#define SLOT_ACCESS_2           4
#define SLOT_ACCESS_3           5
#define SLOT_TRYING             6
#define SLOT_TRAIN              7
#define SLOT_BOOMBOX            8
#define SLOT_FLASHLIGHT         9

// Typy broni
#define WEAPON_TYPE_NONE    	0
#define WEAPON_TYPE_HEAVY   	1
#define WEAPON_TYPE_LIGHT   	2
#define WEAPON_TYPE_MELEE   	3

// Prace dorywcze
#define JOB_NONE        		0
#define JOB_MECHANIC   			1
#define JOB_COURIER             2
#define JOB_SELLER              3

// Akcesoria w poje�dzie
#define VEH_ACCESS_NONE         0
#define VEH_ACCESS_ALARM        1
#define VEH_ACCESS_IMMO         2
#define VEH_ACCESS_AUDIO        4
#define VEH_ACCESS_RADIO        8
#define VEH_ACCESS_DIM          16
#define VEH_ACCESS_GAS          32

// U�ywalne obiekty
#define OBJECT_ATM         	 	2942
#define OBJECT_BENCH        	2629
#define OBJECT_BARBELL      	2915
#define OBJECT_PUNCH_BAG   	 	1985
#define OBJECT_FUELING      	3465
#define OBJECT_BUSSTOP      	1257
#define OBJECT_POOL_TABLE   	2964
#define OBJECT_STOVE            0000
#define OBJECT_BASKET           947
#define OBJECT_CRAFT            14869
#define OBJECT_TAG              18663
#define OBJECT_ECHIDNA          2892
#define OBJECT_FOOD_BOX         1342

// Typy lakierowania
#define SPRAY_TYPE_NONE     	0
#define SPRAY_TYPE_COLORS   	1
#define SPRAY_TYPE_PAINTJOB 	2

// Typy blokad
#define BLOCK_NONE          0
#define BLOCK_CHAR          1
#define BLOCK_VEH           2
#define BLOCK_RUN           4
#define BLOCK_OOC           8

// Typy kar
#define PUNISH_NONE         0
#define PUNISH_WARN         1
#define PUNISH_KICK         2
#define PUNISH_BAN          3
#define PUNISH_BLOCK        4
#define PUNISH_AJ           5

// Dokumenty
#define DOC_NONE            0
#define DOC_PROOF           1
#define DOC_DRIVER          2
#define DOC_SEND            4
#define DOC_SANITY          8

// Typy paczek
#define PACKAGE_NONE   		0
#define PACKAGE_PRODUCT   	1
#define PACKAGE_DRUGS       2
#define PACKAGE_WEAPON      3

// Pozycje
#define MAIN_SPAWN_POS      0
#define ADMIN_JAIL_POS      1
#define HOTEL_SPAWN_POS     2

// Typy checkpoint�w
#define CHECKPOINT_NONE     0
#define CHECKPOINT_VEHICLE  1
#define CHECKPOINT_PACKAGE  2
#define CHECKPOINT_DOOR     3

// Typy narkotyk�w
#define DRUG_NONE           0
#define DRUG_MARIHUANA      1
#define DRUG_COCAINE        2
#define DRUG_HEROIN         3
#define DRUG_AMPHETAMINE    4
#define DRUG_CRACK          5
#define DRUG_CONDITIONER    6

// Rodzaje status�w
#define STATUS_TYPE_NONE    	0
#define STATUS_TYPE_DAZED   	1
#define STATUS_TYPE_DRUNK       2
#define STATUS_TYPE_MUSCLE      4
#define STATUS_TYPE_ROLL        8
#define STATUS_TYPE_MASKED      16
#define STATUS_TYPE_EARPIECE    32
#define STATUS_TYPE_AFK         64
#define STATUS_TYPE_BELTS       128
#define STATUS_TYPE_STONED      256
#define STATUS_TYPE_GLOVES      512

// Rodzaje zgonu
#define DEATH_NONE              0
#define DEATH_OVERDOSAGE        1
#define DEATH_BEATING           2
#define DEATH_SHOOTING          3
#define DEATH_SUICIDE           4

// Po�ar budynku
#define FIRE_TIME               0
#define FIRE_OBJECT             1
#define FIRE_LABEL              2

// Rodzaj craftingu
#define CRAFT_TYPE_NONE			0
#define CRAFT_TYPE_WEAPON		1
#define CRAFT_TYPE_FOOD			2
#define CRAFT_TYPE_DRUGS		3

// Osi�gni�cia
#define ACHIEVE_PLAYER   		1
#define ACHIEVE_MASTER     		2
#define ACHIEVE_LEGEND	      	4
#define ACHIEVE_FIRST_VEH       8
#define ACHIEVE_INTEREST    	16
#define ACHIEVE_AJ              32
#define ACHIEVE_COLLECTOR       64
#define ACHIEVE_MYOMA           128
#define ACHIEVE_HOUSE           256
#define ACHIEVE_DRUGGIE         512
#define ACHIEVE_SAVINGS         1024
#define ACHIEVE_VCARDS          2048
#define ACHIEVE_STYLE           4096
#define ACHIEVE_RICH            8192
#define ACHIEVE_GROUP           16384
#define ACHIEVE_LEADER          32768
#define ACHIEVE_DRIVER          65536
#define ACHIEVE_FAST            131072

// Flagi grup
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

// Typy log�w grup
#define LOG_TYPE_NONE           0
#define LOG_TYPE_OFFER          1
#define LOG_TYPE_DEPOSIT        2
#define LOG_TYPE_WITHDRAW       3
#define LOG_TYPE_ORDER          4

// Typy zawijania
#define WRAP_NONE               0
#define WRAP_AUTO               1
#define WRAP_MANUAL             2

// Dialogs
#define D_NONE      			0
#define D_LOGIN     			1
#define D_STATS                 2
#define D_PERMS                 3
#define D_INTRO                 4

#define D_SEND_PW               5
#define D_PLAYER_LIST           6

#define D_GROUP_TYPE            7

#define D_SPAWN_VEH             8
#define D_TARGET_VEH            9
#define D_ASSIGN_VEH            10
#define D_ASSIGN_VEH_ACCEPT     11
#define D_MANAGE_VEH            12

#define D_DOOR_PICKUP           13
#define D_DOOR_INTERIOR         14
#define D_DOOR_OPTIONS         15
#define D_DOOR_NAME             16
#define D_DOOR_ENTER_PAY        17
#define D_DOOR_ASSIGN           18
#define D_DOOR_ASSIGN_ACCEPT    19
#define D_DOOR_AUDIO            20

#define D_ITEM_PLAYER_LIST      21
#define D_ITEM_OPTIONS          22
#define D_ITEM_OFFER            23
#define D_ITEM_OFFER_PRICE      24
#define D_ITEM_RAISE            25
#define D_ITEM_PUT_BAG          26
#define D_ITEM_REMOVE_BAG       27
#define D_ITEM_REMOVE_CLOSET    28
#define D_ITEM_RELOAD_WEAPON    29
#define D_ITEM_ADD_CHIT         30
#define D_ITEM_WRITE_A_CHECK    31

#define D_PRODUCT_OFFER         32
#define D_PRODUCT_BUY           33
#define D_PRODUCT_SELECT        34
#define D_PRODUCT_OPTIONS       35
#define D_PRODUCT_PRICE         36
#define D_PRODUCT_DELETE        37

#define D_OFFER_SEND            38
#define D_OFFER_PAY_TYPE        39
#define D_OFFER_LIST            40

#define D_PHONE_OPTIONS         41
#define D_PHONE_CALL_NUMBER     42
#define D_PHONE_SMS_NUMBER      43
#define D_PHONE_SEND_SMS        44
#define D_PHONE_SEND_VCARD      45

#define D_CONTACT_LIST          46
#define D_CONTACT_OPTIONS       47
#define D_CONTACT_DELETE        48

#define D_BANK_CREATE_ACCOUNT   49
#define D_BANK_SELECT_OPTIONS   50
#define D_BANK_DEPOSIT          51
#define D_BANK_WITHDRAW         52
#define D_BANK_TRANSFER_NUMBER  53
#define D_BANK_TRANSFER_CASH    54

#define D_DISC_INSERT           55
#define D_DISC_RECORD           56
#define D_DISC_NAME             57

#define D_RADIO_OPTIONS         58
#define D_RADIO_SET_CANAL       59
#define D_RADIO_PASSWORD        60
#define D_RADIO_BUY_CANAL       61
#define D_RADIO_ACCEPT_CANAL    62
#define D_RADIO_CANAL_PASSWORD  63
#define D_RADIO_SET_PASSWORD    64
#define D_RADIO_DELETE_CANAL    65
#define D_RADIO_DELETE_ACCEPT   66
#define D_RADIO_ASSIGN_CANAL    67
#define D_RADIO_ASSIGN_ACCEPT   68

#define D_ROOM_PRICE            69

#define D_TUNING_UNMOUNT        70

#define D_ACCESS_APPLY          71

#define D_CLOTH_TYPE_SELECT     72

#define D_DIRECTORY_LIST        73
#define D_DIRECTORY_ADD         74

#define D_BLOCK_WHEEL           75
#define D_REGISTER_EDIT         76

#define D_PLAY_ANIM             77
#define D_WALK_ANIM             78

#define D_ORDER_CATEGORY        79
#define D_ORDER_PRODUCT         80
#define D_ORDER_COUNT           81
#define D_ORDER_PRICE           82

#define D_BUS_ACCEPT            83

#define D_PACKAGE_GET           84

#define D_WORK_SELECT           85
#define D_WORK_ACCEPT           86

#define D_HELP_MAIN             87

#define D_TAXI_CORP_SELECT      88
#define D_ALARM_SELECT          89

#define D_CALL_TAXI             90
#define D_CALL_ALARM            91
#define D_CALL_NEWS             92

#define D_SALON_CATEGORY        93

#define D_ITEM_CRAFT            94

#define D_RACE_SAVE             95
#define D_RACE_SELECT          	96
#define D_RACE_OPTIONS          97
#define D_RACE_DELETE           98
#define D_RACE_RENAME           99

// Forward's
forward OnPlayerLogin(playerid);
forward SetPlayerSpawn(playerid);
forward OnPlayerPasswordChecked(playerid);

forward OnPlayerSave(playerid, what);
forward UpdatePlayerSession(playerid, session_type, session_extraid);

forward ShowPlayerStatsForPlayer(playerid, giveplayer_id);

forward CreateGroup(GroupName[]);
forward SaveGroup(group_id);
forward DeleteGroup(group_id);
forward LoadGroups();
forward ShowPlayerGroupInfo(playerid, group_id);

forward CreateStaticVehicle(modelid, Float:PosX, Float:PosY, Float:PosZ, Float:PosA, color1, color2, respawn_delay);
forward LoadVehicle(veh_uid);
forward SaveVehicle(vehid, what);
forward DeleteVehicle(vehid);
forward LoadVehicles();
forward ShowPlayerVehicleInfo(playerid, vehid);
forward OnVehicleEngineStarted(vehicleid);

forward CreateDoor(Float:DoorEnterX, Float:DoorEnterY, Float:DoorEnterZ, Float:DoorEnterA, DoorEnterInt, DoorEnterVW, DoorName[]);
forward LoadDoor(door_uid);
forward SaveDoor(doorid, what);
forward DeleteDoor(doorid);
forward LoadDoors();
forward ShowPlayerDoorInfo(playerid, doorid);

forward CreatePlayerItem(playerid, ItemName[], ItemType, ItemValue1, ItemValue2);
forward LoadItemCache(item_uid);
forward SaveItem(itemid, what);
forward DeleteItem(itemid);
forward ShowPlayerItemInfo(playerid, itemid);
forward ListPlayerItems(playerid);

forward ListPlayerNearItems(playerid);
forward ListPlayerItemsForPlayer(playerid, giveplayer_id);
forward ListVehicleItemsForPlayer(vehicleid, playerid);

forward OnPlayerUseItem(playerid, itemid);
forward OnPlayerDropItem(playerid, itemid);

forward OnPlayerRaiseItem(playerid, item_uid);

forward LoadPlayerItems(playerid);
forward UnloadPlayerItems(playerid);

forward CreateArea(Float:AreaMinX, Float:AreaMinY, Float:AreaMaxX, Float:AreaMaxY);
forward LoadArea(area_uid);
forward SaveArea(areaid);
forward DeleteArea(areaid);
forward LoadAreas();

forward CreateDoorProduct(doorid, ProductName[], ProductType, ProductValue1, ProductValue2, ProductPrice, ProductCount);
forward LoadAllProducts();
forward DeleteProduct(product_id);
forward SaveProduct(product_id, what);
forward ListGroupProductsForPlayer(group_id, playerid, list_type);

forward crp_AddObject(ModelID, Float:PosX, Float:PosY, Float:PosZ, Float:RotX, Float:RotY, Float:RotZ, InteriorID, VirtualWorld);
forward SaveObjectPos(object_id);
forward DeleteObject(object_id);
forward LoadAllObjects();

forward Add3DTextLabel(LabelDesc[128], LabelColor, Float:LabelPosX, Float:LabelPosY, Float:LabelPosZ, Float:LabelDrawDistance, LabelWorld, LabelInteriorID);
forward Load3DTextLabels();
forward Destroy3DTextLabel(label_id);
forward Save3DTextLabel(label_id);

forward OnPlayerSendOffer(playerid, customerid, OfferName[], OfferType, OfferValue1, OfferValue2, OfferPrice);

forward OnPlayerAcceptOffer(playerid, offererid);
forward OnPlayerRejectOffer(playerid, offererid);

forward OnPlayerEnterDoor(playerid, doorid);
forward OnPlayerExitDoor(playerid, doorid);

forward LoadAllAccess();
forward LoadAllSkins();
forward LoadAllAnims();
forward LoadAllCorpses();

forward LoadPlayerAccess(playerid);
forward LoadPlayerGroups(playerid);

forward ShowPlayerDirectoryForPlayer(playerid, giveplayer_id);
forward GivePlayerPunish(playerid, giverid, punish_type, punish_reason[], punish_time, punish_extraid);

forward LoadPlayerBans(playerid);

forward CreatePackage(PackageDoorUID, PackageItemName[], PackageItemType, PackageItemValue1, PackageItemValue2, PackageItemNumber, PackageItemPrice, PackageType);
forward LoadPackages();
forward DeletePackage(package_id);

forward AddPlayerPunishLog(playerid, punish_giver, punish_type, punish_extraid, punish_reason[], punish_date, punish_end);
forward ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5);

forward UpdatePlayerStatus(playerid);
forward CreatePlayerCorpse(playerid, killer_uid, weapon_uid);

forward GivePlayerAchievement(playerid, achieve_type);

// New's
new connHandle;

new Text:TextDrawServerLogo;
new Text:TextDrawNews;
new Text:TextDrawGroupOption[MAX_GROUP_SLOTS][5];

new Text:TextDrawPremium;

new PlayerText:TextDrawSmallInfo[MAX_PLAYERS];
new PlayerText:TextDrawLargeInfo[MAX_PLAYERS][2];

new Text:TextDrawGroupsTitle;
new PlayerText:TextDrawGroups[MAX_PLAYERS][MAX_GROUP_SLOTS];

new Text:TextDrawOfferAccept;
new Text:TextDrawOfferReject;

new Text:TextDrawOfferBack;
new PlayerText:TextDrawOfferDesc[MAX_PLAYERS];

new Text:TextDrawPunishTitle;
new Text:TextDrawPunishDesc;

new PlayerText:TextDrawAchieve[MAX_PLAYERS];
new PlayerText:TextDrawRadioCB[MAX_PLAYERS];

new PlayerText:TextDrawDuty[MAX_PLAYERS];

new PunishTime;
new PickupWork;

// Iterators
new Iterator:Groups<MAX_GROUPS>;
new Iterator:Vehicles<MAX_VEHICLES>;

new Iterator:Door<MAX_DOORS>;
new Iterator:Area<MAX_AREAS>;

new Iterator:Item<MAX_ITEM_CACHE>;

new Iterator:Product<MAX_PRODUCTS>;
new Iterator:Access<MAX_ACCESS>;

new Iterator:Skin<MAX_SKINS>;
new Iterator:Anim<MAX_ANIMS>;

new Iterator:Package<MAX_PACKAGES>;

// Enums
enum sPlayer
{
	pUID,
	pGID,
	
	pCharName[32],
	pGlobName[64],
	
	pPassword[128],
	
	pHours,
	pMinutes,
	
	pAdmin,
	pPoints,
	
	pCash,
	pBankCash,
	
	pPhoneNumber,
	pBankNumber,
	
	pNickColor,
	pPremium,
	
	pSkin,
	Float:pHealth,
	
	pSex,
	pBirth,
	
	Float:pPosX,
	Float:pPosY,
	Float:pPosZ,
	
	pVirtualWorld,
	pInteriorID,
	
	pBlock,
	pCrash,
	
	pArrest,
	
	pBW,
	pAJ,
	
	pHouse,
	pJob,
	
	pDocuments,
	pAchievements,
	
	pPDP,
	pWarns,
	
	pLogTries,
	
	pLastVeh,
	pLastW,
	pLastReport,
	pLastSkin,
	pLastMileage,
	pLastKeyUse,
	
	pAFK,
	bool: pOOC,
	
	pDutyGroup,
	pDutyAdmin,
	
	pMainTable,
	pManageItem,
	
	pSmallTextTime,
	pLargeTextTime,
	
	pAchieveInfoTime,
	
	pFreeze,
	
	pMainGroupSlot,
	
	pStrength,
	Float:pDepend,
	
	Float:pMileage,
	
	pAudioHandle,
	pStatus,
	
	pTaxiVeh,
	pTaxiPay,
	pTaxiPrice,
	pTaxiPassenger,
	
	pRepairVeh,
	pRepairTime,
	Text3D:pRepairTag,
	
	pSprayVeh,
	pSprayTime,
	pSprayColor[2],
	pSprayType,
	Text3D:pSprayTag,
	
	pMontageVeh,
	pMontageItem,
	pMontageTime,
	
	pCuffedTo,
	pCallingTo,
	
	pCreatingArea,
	pCurrentArea,
	
	pEditObject,
	pEdit3DText,
	
	bool: pRadioLive,
	pRadioInterview,
	
	pSelectAccess,
	pSelectSkin,
	bool: pSelectTalkStyle,

	pItemWeapon,
	pItemPlayer,
	pItemPass,
	pItemMask,
	pItemBoombox,
	
	bool: pCheckWeapon,
	bool: pCheckPos,
	
	pSearches,
	pSearchTime,
	
	pLesson,
	pLessonTime,
	
	pHealing,
	
	pSpectate,
	pPackage,
	
	pTalkStyle,
	pWalkStyle,
	pFightStyle,
	
	pGymObject,
	pGymRepeat,
	pGymTime,
	
	pBusStart,
	pBusTravel,
	pBusTime,
	pBusPrice,
	bool: pBusRide,
	Float:pBusPosition[3],
	
	pDrugType,
	pDrugLevel,
	pDrugValue1,
	pDrugValue2,
	
	pDeathKiller,
	pDeathWeapon,
	pDeathType,
	
	pBasketObject,
	pBasketBall,
	
	pTaggingObject,
	pTaggingTime,
	
	bool: pRaceCreating,
	pRaceCheckpoints,
	
	bool: pRoll,
	bool: pBelts,
	bool: pGlove,
	bool: pFlashLight,
	
	bool: pLogged,
	bool: pSpawned,
	bool: pBanned,

	pCheckpoint,
	pSession[6],
	
	bool: pTogW,
	bool: pPlayAnim,
	
	Text3D:pNameTag,
	Text3D:pDescTag,
	
	pFirstPersonObject,
	pIgnored[MAX_PLAYERS],
	
	ORM: pOrm
}
new PlayerCache[MAX_PLAYERS][sPlayer];

enum sGroupInfo
{
	gUID,
	gName[32],
	
	gCash,
	gDotation,

	gType,
	gOwner,

	gValue1,
	gValue2,
	
	gColor,
	gActivity,
	
	gTag[5],
	gLastTax,
	
	gFlags,
	gExtraArray[20],
	
	bool: gToggleChat
}
new GroupData[MAX_GROUPS][sGroupInfo];

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
	{"Nieokre�lony",			0,		2000,		G_FLAG_OOC | G_FLAG_TAX},
	{"24/7",					100,	5000,		G_FLAG_OOC | G_FLAG_TAX},
	{"Gastronomia",				300,	9000,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},
	{"Stacja benzynowa",		300,	12000,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},
	{"Si�ownia",				300,	7000,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},
	{"Salon samochodowy",		300,	12500,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},
	{"Firma taks�wkarska",		300,	12500,		G_FLAG_IC | G_FLAG_OOC | G_FLAG_TAX},
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
	
	{"Szko�a jazdy",            300,    9000,       G_FLAG_OOC | G_FLAG_TAX},
	{"Wypo�yczalnia",           300,    9800,      	G_FLAG_OOC | G_FLAG_TAX}
};

enum sCarInfo
{
	cUID,
	cModel,

	Float:cPosX,
	Float:cPosY,
	Float:cPosZ,
	Float:cPosA,
	
	cWorldID,
	cInteriorID,

	cColor1,
	cColor2,
	
	Float:cFuel,
	cFuelType,
	
	Float:cHealth,
	Float:cMileage,
	
	bool: cLocked,
	cVisual[4],
	
	cPaintJob,
	cAccess,

	cBlockWheel,
	cRegister[12],
	
	cOwner,
	cOwnerType,
	
	cDistTicker,
	cSavePoint,
	
	cComponent[14],
	cAudioURL[128],
	
	cRadioCanal,
	bool: cGPS,
	
	cLastUsing,
	bool: cGlass
}
new CarInfo[MAX_VEHICLES][sCarInfo];

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

new FuelTypeName[3][12] = {"Benzyna", "Gaz", "Ropa"};

enum sDoorData
{
	dUID,
	dName[32],
	
	Float:dEnterX,
	Float:dEnterY,
	Float:dEnterZ,
	Float:dEnterA,
	
	dEnterInt,
	dEnterVW,
	
	Float:dExitX,
	Float:dExitY,
	Float:dExitZ,
	Float:dExitA,
	
	dExitInt,
	dExitVW,
	
	bool: dLocked,
	dPickupID,
	
	bool: dGarage,
	
	dOwner,
	dOwnerType,
	
	dAudioURL[128],
	dEnterPay,
	
	dAccess,
	dFireData[3]
}
new DoorCache[MAX_DOORS][sDoorData];

enum sInteriorData
{
	INTERIOR_ID,
	Float:INTERIOR_X,
	Float:INTERIOR_Y,
	Float:INTERIOR_Z,
	Float:INTERIOR_A,
	
	INTERIOR_NAME[32],
	INTERIOR_PRICE
}
new InteriorInfo[][sInteriorData] = {
 	{5, 772.3852,-5.0267,1000.7289,0.6510,			"Ganton Gym", 						8000},
  	{3, 975.1497,-8.8785,1001.1484,92.6761, 		"Brothel", 							9500},
   	{3, 966.9457,-53.1448,1001.1246,91.2287,		"Brothel2", 						12500},
    {3, 834.2611,7.3429,1004.1870,88.4086, 			"Inside Track Betting", 			8000},
    {3, 1038.1899,-3.8097,1001.2845,359.7343, 		"Blastin' Fools Records", 			7500},
    {3, 1212.2024,-26.0924,1000.9531,181.7593,		"The Big Spread Ranch", 			11000},
    {18, 1291.9290,3.7353,1001.0112,180.8917, 		"Warehouse 1", 						35000},
    {1, 1403.9896,4.1124,1000.9089,180.0966, 		"Warehouse 2", 						40000},
    {3, 1525.9994,-10.8667,1002.0971,275.7367, 		"B Dup's Apartment", 				3000},
    {2, 1521.0021,-48.0825,1002.1310,269.8558, 		"B Dup's Crack Palace", 			3000},
    {3, 612.2191,-123.9028,997.9922,266.5704, 		"Wheel Arch Angels", 				8000},
    {3, 520.3263,-9.0747,1001.5653,90.2650, 		"OG Loc's House",					6000},
    {3, 418.7094,-84.0039,1001.8047,0.9642, 		"Barber Shop", 						7500},
    {3, 390.1465,173.8574,1008.3828,87.4451, 		"Planning Department", 				35000},
    {3, 288.7931,167.4812,1007.1719,357.5410, 		"Las Venturas Police Department", 	30000},
    {3, 207.1015,-140.0236,1003.5078,356.9143, 		"Pro-Laps", 						14500},
    {3, -100.4219,-24.6163,1000.7188,356.9143, 		"Sex Shop", 						19000},
    {3, -204.5397,-43.9880,1002.2734,356.9143, 		"Las Venturas Tattoo parlor", 		6500},
    {17, -204.2623,-8.3931,1002.2734,0.0477, 		"Lost San Fierro Tattoo parlor", 	22000},
    {17, -25.7220,-187.8216,1003.5469,5.0760, 		"24/7 (version 1)", 				13000},
    {5, 372.4557,-133.3936,1001.4922,1.6144, 		"Pizza Stack", 						25500},
    {17, 377.2173,-193.1430,1000.6401,0.0477, 		"Rusty Brown's Donuts", 			15000},
    {7, 315.9149,-143.4442,999.6016,1.6144, 		"Ammu-nation", 						19500},
    {5, 227.0982,-8.0044,1002.2109,90.9151, 		"Victim", 							7000},
    {2, 612.6995,-75.5179,997.9922,273.3493, 		"Loco Low Co", 						16000},
    {10, 246.3100,107.7927,1003.2188,2.7954, 		"San Fierro Police Department", 	90000},
    {10, 6.2462,-31.1101,1003.5494,0.0478, 			"24/7 (version 2 - large)", 		25000},
    {7, 773.8416,-78.5067,1000.6623,0.0478, 		"Below The Belt Gymr", 				15000},
    {1, 608.0074,-10.7054,1000.9174,272.1453, 		"Transfenders", 					26000},
    {1, 285.4489,-41.1734,1001.5156,355.6142, 		"Ammu-nation (version 2)", 			21000},
    {1, 203.9385,-50.1884,1001.8047,355.6142,		"SubUrban", 						18500},
    {1, 244.1629,304.8900,999.1484,268.8201, 		"Denise's Bedroom", 				5000},
    {3, 293.0890,309.9762,999.1484,86.1683, 		"Helena's Barn", 					7500},
    {5, 322.1865,302.7020,999.1484,358.1208, 		"Barbara's Love nest", 				40000},
    {2, 1204.9052,-13.4438,1000.9219,2.5557, 		"The Pig Pen (strip club 2)", 		29000},
    {10, 2018.6531,1017.8937,996.8750,87.1330, 		"Four Dragons", 					45000},
    {2, 2455.7131,-1706.5864,1013.5078,357.7831,	"Ryder's house",					14000},
    {1, 2524.6389,-1679.3669,1015.4986,270.1214, 	"Sweet's House", 					13000},
    {3, 2496.0498,-1692.4344,1014.7422,181.4706, 	"The Johnson House", 				32000},
    {10, 362.9743,-74.9267,1001.5078,317.1219, 		"Burger shot", 						15000},
    {1, 2234.0559,1714.0764,1012.3347,180.8439, 	"Caligula's Casino", 				60000},
    {2, 266.8239,304.9771,999.1484,272.9415, 		"Katie's Lovenest",		 			6000},
    {2, 411.5980,-22.9821,1001.8047,358.7722, 		"Barber Shop 2 (Reece's)", 			6500},
    {2, 1.1853,-3.2387,999.4284,87.5718, 			"Angel \"Pine Trailer\"", 			8000},
    {18, -31.1142,-91.6357,1003.5469,356.8922, 		"24/7 (version 3)", 				20000},
    {18, 161.3073,-96.5507,1001.8047,356.8922, 		"Zip", 								6500},
    {3, -2636.7996,1402.7880,906.4609,356.8922, 	"The Pleasure Domes", 				59000},
    {5, 1261.0970,-785.3736,1091.9063,269.3989, 	"Madd Dogg's Mansion", 				220000},
    {2, 2570.7341,-1301.9620,1044.1250,84.9398, 	"Big Smoke's Crack Palace", 		140000},
    {5, 2352.3013,-1180.8904,1027.9766,89.6399, 	"Burning Desire Building", 			2500},
    {1, -2158.6418,642.7681,1052.3750,186.1475, 	"Wu-Zi Mu's", 						28000},
    {10, 422.2926,2536.6521,10.0000,91.8332, 		"Abandoned AC tower", 				7000},
    {14, 254.3687,-41.7188,1002.0308,269.8082, 		"Wardrobe/Changing room", 			1500},
    {14, 204.3125,-168.7386,1000.5234,358.7724, 	"Didier Sachs", 					12000},
    {12, 1133.0537,-15.3457,1000.6797,357.5191, 	"Casino (Redsands West)", 			27000},
    {17, 493.5156,-24.7910,1000.6797,357.5191, 		"Club", 							34500},
    {18, 1726.9481,-1638.5168,20.2233,176.4107, 	"Atrium", 							36000},
    {16, -204.2385,-27.0951,1002.2734,359.6890, 	"Los Santos Tattoo Parlor", 		6500},
    {5, 2233.6138,-1115.0178,1050.8828,359.6890,	"Safe House group 1", 				6500},
    {9, 2317.9077,-1026.6240,1050.2178,3.1357, 		"Safe House group 3", 				43000},
    {10, 2259.6904,-1135.9205,1050.6328,266.9415, 	"Safe House group 4", 				9000},
    {15, 2214.9121,-1150.3807,1025.7969,268.5082, 	"Jefferson Motel", 					39500},
	{1, 2.1403,23.2410,1199.5938,93.0399, 			"Jet Interior", 					20000},
 	{1, 681.6216,-451.8933,-25.6172,166.1660, 		"The Welcome Pump", 				29000},
 	{3, 235.2854,1186.7764,1080.2578,359.9790, 		"Burglary House X1",				0},
  	{2, 225.5707,1240.0643,1082.1406,96.2852, 		"Burglary House X2", 				15000},
   	{1, 223.0885,1287.1864,1082.1406,356.2190, 		"Burglary House X3", 				50000},
	{5, 226.9825,1114.3130,1080.9965,270.0515, 		"Burglary House X4", 				0},
 	{15, 207.5804,-110.9442,1005.1328,358.4124, 	"Binco", 							27500},
  	{15, 295.1391,1473.3719,1080.2578,352.9526, 	"4 Burglary houses", 				6000},
    {12, 446.7587,506.6798,1001.4195,357.4724, 		"Budget Inn Motel Room", 			4500},
    {0, 2305.1001,-16.2089,26.7422,269.7382, 		"Palamino Bank", 					5500},
    {0, 663.0487,-573.6597,16.3359,266.0015, 		"Dillimore Gas Station", 			6800},
    {18, -228.8965,1401.3147,27.7656,266.0015, 		"Lil' Probe Inn", 					13000},
    {2, 446.9469,1397.5585,1084.3047,359.3991, 		"Pair of Burglary Houses", 			25000},
    {5, 226.6049,1114.2588,1080.9945,266.3383, 		"Burglary House X11", 				26000},
    {4, 260.8826,1284.4226,1080.2578,356.8690, 		"Burglary House X12", 				28000},
    {4, 285.7398,-86.2111,1001.5229,0.9424, 		"Ammu-nation (version 3)", 			23000},
    {4, 460.0900,-88.7736,999.5547,88.6766, 		"Jay's Diner", 						13000},
    {4, 300.2214,308.9092,1003.3047,267.5913, 		"Michelle's Love Nest*", 			6000},
    {10, 24.0752,1340.4037,1084.3750,357.5913,	 	"Burglary House X14", 				47500},
    {1, 964.8690,2160.1362,1011.0303,87.4463, 		"Sindacco Abatoir", 				15000},
    {4, 221.7042,1140.5739,1082.6094,355.0121, 		"Burglary House X13", 				12000},
    {12, 2324.4485,-1149.3555,1050.7101,355.0121, 	"Unused Safe House", 				115000},
    {6, 344.0542,305.0782,999.1484,270.3390, 		"Millie's Bedroom", 				4500},
    {12, 412.0997,-54.1158,1001.8984,357.5189, 		"Barber Shop", 						6500},
    {6, 774.1306,-50.3132,1000.5859,356.5555, 		"Cobra Gym", 						29000},
    {6, 246.7376,62.6765,1003.6406,359.6888, 		"Los Santos Police Department", 	80000},
    {4, -260.6812,1456.6299,1084.3672,84.9163, 		"Burglary House X15", 				31000},
    {5, 22.7006,1403.4539,1084.4370,0.0022, 		"Burglary House X16", 				34000},
    {5, 140.4259,1366.3585,1083.8594,354.6754, 		"Burglary House X17", 				105000},
    {3, 1494.4634,1303.9586,1093.2891,358.1221, 	"Bike School", 						15000},
    {6, 234.1510,1064.0935,1084.2117,358.1221, 		"Burglary House X18", 				55000},
    {6, -68.7717,1351.2863,1080.2109,358.1221, 		"Burglary House X19", 				0},
    {6, -2240.6143,137.1421,1035.4141,268.8213, 	"Zero's RC Shop", 					16000},
    {6, 296.8614,-111.8426,1001.5156,355.3021, 		"Ammu-nation (version 4)", 			18500},
    {6, 316.2793,-169.7145,999.6010,355.3021, 		"Ammu-nation (version 5)", 			22000},
    {15, -283.5468,1471.0049,1084.3750,89.3029, 	"Burglary House X20", 				28000},
    {6, 744.3742,1436.4757,1102.7031,356.9153, 		"Fanny Batter's Whore House", 		0},
    {8, 2807.4829,-1174.5416,1025.5703,356.9153, 	"Colonel Furhberger's", 			37000},
    {9, 364.8955,-11.1229,1001.8516,356.9153, 		"Cluckin' Bell", 					5500},
    {1, 2218.2136,-1076.3907,1050.4844,89.0129, 	"The Camel's Toe Safehouse", 		6500},
    {1, 2266.2695,1647.5325,1084.2344,265.7112, 	"Caligula's Roof", 					20000},
    {2, 2237.5891,-1081.4121,1049.0234,357.1820, 	"Old Venturas Strip Casino",		40000},
    {3, -2029.7666,-119.0861,1035.1719,357.1820, 	"Driving School", 					8000},
    {8, 2365.3745,-1135.1105,1050.8750,357.8087, 	"Verdant Bluffs Safehouse", 		25000},
    {10, 1893.7197,1018.2451,31.8828,96.3156, 		"Four Dragons' Janitor's Office", 	40000},
    {11, 502.0814,-68.0179,998.7578,179.9763, 		"Bar", 								30000},
    {8, -42.5038,1405.9224,1084.4297,356.6021, 		"Burglary House X21", 				27500},
    {9, 83.0910,1322.5833,1083.8662,1.6155, 		"Burglary House X22", 				36000},
    {9, 260.7572,1237.4823,1084.2578,1.6155, 		"Burglary House X23", 				30000}
};


new PickupID[9] = {1239, 1274, 1273, 1272, 1240, 1247, 1277, 1275, 1318};

enum sItemData
{
	iUID,
	iName[32],
	
	iValue1,
	iValue2,
	
	iType,
	
	iPlace,
	iOwner,
	
	iGroup,
	bool: iUsed
}
new ItemCache[MAX_ITEM_CACHE][sItemData];

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
	{"Nieokre�lony",	50, 	328,   	90.0,   95.0},
	{"Zegarek",			80, 	2710, 	0.0,  	0.0},
	{"Jedzenie",        160,    2769,   0.0,    0.0},
	{"Papierosy",       30,    	1485,   0.0,    0.0},
	{"Kostka do gry",   10,    	328,   	90.0,   95.0},
	{"Ubranie",         380,    2843,   0.0,    0.0},
	{"Bro�",            0,      0,      0.0,    0.0},
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
	{"Nap�j",           520,    328, 	90.0, 	95.0},
	{"Akcesorie", 		1040,   328,    90.0,   95.0},
	{"P�yta",           140,    1961,   90.0,   180.0},
	{"Odtwarzacz",      240,    328,    90.0,   95.0},
	{"Przyczepialny",   210,    328,    90.0,   95.0},
	{"Karnet",          10,     328,    90.0,   95.0},
	{"Karta pojazdu",   10,     328,    90.0,   95.0},
	{"Rolki",           230,    328,    90.0,   95.0},
	{"Medykament",      30,     328,    90.0,   95.0},
	{"U�ywka",          1,      328,    90.0,   95.0},
	{"Joint",           1,      328,    90.0,   95.0},
	{"Kluczyki",        60,     328,    90.0,   95.0},
	{"R�kawiczki",      180,    328,    90.0,   95.0},
	{"Zw�oki",          7500,   2060,   0.0,    0.0},
	{"Molotova",        500,    344,    80.0,   0.0},
	{"Boombox",         1350,   2226,   0.0,    0.0},
	{"Craft",           320,    328,    90.0,   0.0},
	{"Latarka",         150,    18641,  90.0,   0.0}
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

enum sAreaInfo
{
	aUID,
	
	Float:aMinX,
	Float:aMinY,
	
	Float:aMaxX,
	Float:aMaxY,
	
	aOwnerType,
	aOwner,
	
	aAudioURL[128]
}
new AreaCache[MAX_AREAS][sAreaInfo];

enum sProductData
{
	pUID,

	pName[32],
	pType,

	pValue1,
	pValue2,

	pPrice,
	pCount,
	
	pOwner,
	pMaxPrice
}
new ProductData[MAX_PRODUCTS][sProductData];

enum sOfferData
{
	oCustomerID,
	oType,
	
	oName[32],
	
	oValue1,
	oValue2,
	
	oPrice,
	oPayType
}
new OfferData[MAX_PLAYERS][sOfferData];

enum sOfferTypeInfo
{
	oTypeName[32]
}
new OfferTypeInfo[][sOfferTypeInfo] =
{
	{"Nieokreslona"},
	{"Przedmiot"},
	{"Pojazd"},
	{"Produkt"},
	{"vCard"},
	{"Drzwi"},
	{"Holowanie"},
	{"Przejazd"},
	{"Tankowanie"},
	{"Naprawa"},
	{"Lakierowanie"},
	{"Montaz"},
	{"Mandat"},
	{"Zdjecie blokady"},
	{"Dokument"},
	{"Biznes"},
	{"Rejestracja"},
	{"Leczenie"},
	{"Karnet"},
	{"Powitanie"},
	{"Reklama"},
	{"Nowy pojazd"},
	{"Podatek"},
	{"Kluczyki"},
	{"Styl walki"},
	{"Lekcja jazdy"}
};

enum sAttachAccess
{
	aUID,
	aModel,
	
	aName[32],
	aBone,
	
	Float:aPosX,
	Float:aPosY,
	Float:aPosZ,
	
	Float:aRotX,
	Float:aRotY,
	Float:aRotZ,
	
	Float:aScaleX,
	Float:aScaleY,
	Float:aScaleZ,
	
	aPrice
}
new AccessData[MAX_ACCESS][sAttachAccess];

enum sSkinInfo
{
	sModel,
	
	sName[32],
	sPrice
}
new SkinData[MAX_SKINS][sSkinInfo];

new TalkStyleData[9][3][24] =
{
	{"PED", 	"IDLE_CHAT", 		"Podstawowy"},
	{"GANGS", 	"prtial_gngtlkA",	"Gangster 1"},
	{"GANGS",   "prtial_gngtlkB",	"Gangster 2"},
	{"GANGS",   "prtial_gngtlkC",	"Gangster 3"},
	{"GANGS",   "prtial_gngtlkD",	"Gangster 4"},
	{"GANGS",   "prtial_gngtlkE",	"Gangster 5"},
	{"GANGS",   "prtial_gngtlkF",	"Gangster 6"},
	{"GANGS",   "prtial_gngtlkG",	"Gangster 7"},
	{"GANGS",   "prtial_gngtlkH",	"Gangster 8"}
};

new FightStyleData[4][1][24] =
{
	{"Normalny"},
	{"Box"},
	{"Karate"},
	{"Kick Boxing"}
};

enum sAnimData
{
	aUID,

	aCommand[12],
	aLib[16],
	aName[24],

	Float:aSpeed,

	aOpt1,
	aOpt2,
	aOpt3,
	aOpt4,
	aOpt5,

	aAction
}
new AnimCache[MAX_ANIMS][sAnimData];

enum sOrderData
{
	oUID,
	oName[32],
	
	oCount,
	oPrice
}
new OrderCache[MAX_PLAYERS][sOrderData];

enum sPackageData
{
	pUID,
	pDoorUID,

	pItemName[32],
	pItemType,

	pItemValue1,
	pItemValue2,

	pItemCount,
	pItemPrice,
	
	pType,
	pDistance
}
new PackageCache[MAX_PACKAGES][sPackageData];

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

new Float:SalonSpawnPos[3][4] =
{
	{901.3408, -1208.8365, 16.8620, 178.8416},
	{866.7073, -1209.3844, 16.8687, 176.9288},
	{830.8945, -1208.5759, 16.8481, 177.3645}
};

enum sStatusData
{
	sName[32],
	sType
}
new StatusInfo[][sStatusData] =
{
	{"nieprzytomny",    STATUS_TYPE_DAZED},
	{"pijany",          STATUS_TYPE_DRUNK},
	{"muskularny",      STATUS_TYPE_MUSCLE},
	{"rolki",           STATUS_TYPE_ROLL},
	{"zakryta twarz",   STATUS_TYPE_MASKED},
	{"s�ucha muzyki",   STATUS_TYPE_EARPIECE},
	{"AFK od:",         STATUS_TYPE_AFK},
	{"zapi�te pasy",    STATUS_TYPE_BELTS},
	{"na�pany",         STATUS_TYPE_STONED},
	{"r�kawice",        STATUS_TYPE_GLOVES}
};

new DeathTypeData[5][32] =
{
	{"Nieokre�lone"},
	{"Przedawkowanie"},
	{"Pobicie"},
	{"Postrzelenie"},
	{"Samob�jstwo"}
};

enum sAchieveData
{
	aName[32],
	aType,
	
	aPoints
}
new AchieveInfo[18][sAchieveData] =
{
	{"Staly gracz",     		ACHIEVE_PLAYER,     25},
	{"Mistrz gry",      		ACHIEVE_MASTER,     100},
	{"Legenda",         		ACHIEVE_LEGEND,     800},
	{"Pierwszy pojazd", 		ACHIEVE_FIRST_VEH,  50},
	{"Dobry interes",   		ACHIEVE_INTEREST,   220},
	{"Widoki z latarni",    	ACHIEVE_AJ,         -50},
	{"Kolekcjoner",         	ACHIEVE_COLLECTOR,  500},
	{"Miesniak",            	ACHIEVE_MYOMA,      300},
	{"Wlasne cztery katy",  	ACHIEVE_HOUSE,      200},
	{"Narkoman",            	ACHIEVE_DRUGGIE,    150},
	{"Pierwsze oszczednosci",   ACHIEVE_SAVINGS,    80},
	{"Znana twarz",             ACHIEVE_VCARDS,     50},
	{"Nowy styl",               ACHIEVE_STYLE,      1000},
	{"Bogacz",                  ACHIEVE_RICH,       2500},
	{"Nowy czlonek",            ACHIEVE_GROUP,      35},
	{"Przywodca",               ACHIEVE_LEADER,     150},
	{"Kierowca",                ACHIEVE_DRIVER,     450},
	{"Szybka jazda",            ACHIEVE_FAST,       200}
};

enum sRaceData
{
	rOwner,
	rStart,
	
	Float:rCPX[MAX_RACE_CP],
	Float:rCPY[MAX_RACE_CP],
	Float:rCPZ[MAX_RACE_CP],
	
	rPoint,
	rTime,
	
 	rPosition
}
new RaceInfo[MAX_PLAYERS][sRaceData];

new BlockadeType[8] = {3578, 1228, 1237, 1425, 978, 979, 2892, 1437};

main()
{
	print("\n--------------------------------------------");
	print(" "GAMEMODE" v"VERSION" --> started");
	print("--------------------------------------------\n");
}


public OnGameModeInit()
{
	new year, month, day;
	getdate(year, month, day);
	
	PickupWork = CreatePickup(1210, 2, 1464.1624, -1749.0228, 15.4453);

	// Connect to database
	//mysql_init(LOG_ALL);
 	connHandle = mysql_connect(SQL_HOST, SQL_USER, SQL_PASS, SQL_DTBS);
	if(connHandle)
	{
	    print("Pomy�lnie po��czono z baz� danych.\n\n----------\nHost: "SQL_HOST"\nUser: "SQL_USER"\nDatabase: "SQL_DTBS"\n----------\n\nRozpoczynam wczytywanie danych...");

		// Wczytywanie
		LoadGroups();
		LoadVehicles();
		
		LoadDoors();
		LoadAreas();
		
		LoadAllProducts();
		LoadAllObjects();
		
		LoadAllAccess();
		LoadAllSkins();
		LoadAllAnims();
		LoadAllCorpses();
		
		LoadPackages();
		Load3DTextLabels();
		
		print("Wczytywanie danych zosta�o zako�czone pomy�lnie.");
	    SetGameModeText(""GAMEMODE" v"VERSION"");
	    
  		//if(!GetServerVarAsBool("testserver"))	mysql_query(connHandle, "DELETE FROM `"SQL_PREF"logged_players`");
	}
	else
	{
	    SetGameModeText(""GAMEMODE" -SQL_ERROR-");
	}

	// Settings
	AllowInteriorWeapons(false);
	ShowNameTags(false);

    ShowPlayerMarkers(false);
	EnableStuntBonusForAll(false);
	
	DisableInteriorEnterExits();
	ManualVehicleEngineAndLights();

	new logo_string[128];
	format(logo_string, sizeof(logo_string), ""SERVER_NAME"~n~~w~~h~ver. "VERSION"   %02d.%02d.%d", day, month, year);

    TextDrawServerLogo = TextDrawCreate(499.000000, 1.000000, logo_string);
	TextDrawBackgroundColor(TextDrawServerLogo, 255);
	TextDrawFont(TextDrawServerLogo, 3);
	TextDrawLetterSize(TextDrawServerLogo, 0.320000, 1.000000);
	TextDrawColor(TextDrawServerLogo, -1347440726);
	TextDrawSetOutline(TextDrawServerLogo, 0);
	TextDrawSetProportional(TextDrawServerLogo, 1);
	TextDrawSetShadow(TextDrawServerLogo, 1);

    TextDrawNews = TextDrawCreate(1.000000, 437.000000, "~y~~h~LSN ~w~~>~ Brak sygnalu nadawania.");
	TextDrawBackgroundColor(TextDrawNews, 255);
	TextDrawFont(TextDrawNews, 1);
	TextDrawLetterSize(TextDrawNews, 0.219999, 1.000000);
	TextDrawColor(TextDrawNews, -1);
	TextDrawSetOutline(TextDrawNews, 1);
	TextDrawSetProportional(TextDrawNews, 1);
	TextDrawUseBox(TextDrawNews, 1);
	TextDrawBoxColor(TextDrawNews, 68);
	TextDrawTextSize(TextDrawNews, 640.000000, 0.000000);
	
	TextDrawPremium = TextDrawCreate(510.000000, 424.800000, "Gracz Premium");
	TextDrawBackgroundColor(TextDrawPremium, COLOR_GOLD);
	TextDrawFont(TextDrawPremium, 2);
	TextDrawLetterSize(TextDrawPremium, 0.300000, 1.000000);
	TextDrawColor(TextDrawPremium, -1);
	TextDrawSetOutline(TextDrawPremium, 1);
	TextDrawSetProportional(TextDrawPremium, 1);
	
	TextDrawGroupsTitle = TextDrawCreate(99.000000, 169.000000, "~y~Slot                  Nazwa Grupy                                                        Opcje");
	TextDrawBackgroundColor(TextDrawGroupsTitle, 255);
	TextDrawFont(TextDrawGroupsTitle, 2);
	TextDrawLetterSize(TextDrawGroupsTitle, 0.210000, 1.199999);
	TextDrawColor(TextDrawGroupsTitle, -1);
	TextDrawSetOutline(TextDrawGroupsTitle, 1);
	TextDrawSetProportional(TextDrawGroupsTitle, 1);

	TextDrawOfferBack = TextDrawCreate(205.000000, 287.000000, "_");
	TextDrawLetterSize(TextDrawOfferBack, 0.500000, 6.299985);
	TextDrawUseBox(TextDrawOfferBack, 1);
	TextDrawBoxColor(TextDrawOfferBack, 68);
	TextDrawTextSize(TextDrawOfferBack, 430.000000, 30.000000);

	TextDrawOfferAccept = TextDrawCreate(353.000000, 328.000000, "Akceptuj");
	TextDrawSetSelectable(TextDrawOfferAccept, true);
	TextDrawAlignment(TextDrawOfferAccept, 2);
	TextDrawLetterSize(TextDrawOfferAccept, 0.200000, 1.000000);
	TextDrawSetOutline(TextDrawOfferAccept, 1);
	TextDrawUseBox(TextDrawOfferAccept, 1);
	TextDrawBoxColor(TextDrawOfferAccept, 102);
	TextDrawTextSize(TextDrawOfferAccept, 10.000000, 37.000000);

	TextDrawOfferReject = TextDrawCreate(396.000000, 328.000000, "Odrzuc");
	TextDrawSetSelectable(TextDrawOfferReject, true);
	TextDrawAlignment(TextDrawOfferReject, 2);
	TextDrawLetterSize(TextDrawOfferReject, 0.200000, 1.000000);
	TextDrawSetOutline(TextDrawOfferReject, 1);
	TextDrawUseBox(TextDrawOfferReject, 1);
	TextDrawBoxColor(TextDrawOfferReject, 102);
	TextDrawTextSize(TextDrawOfferReject, 10.000000, 37.000000);

	TextDrawPunishTitle = TextDrawCreate(100.000000, 250.000000, "_");
	TextDrawAlignment(TextDrawPunishTitle, 2);
	TextDrawBackgroundColor(TextDrawPunishTitle, 255);
	TextDrawFont(TextDrawPunishTitle, 1);
	TextDrawLetterSize(TextDrawPunishTitle, 0.179998, 0.899999);
	TextDrawColor(TextDrawPunishTitle, COLOR_PUNISH);
	TextDrawSetOutline(TextDrawPunishTitle, 1);
	TextDrawSetProportional(TextDrawPunishTitle, 1);
	TextDrawUseBox(TextDrawPunishTitle, 1);
	TextDrawBoxColor(TextDrawPunishTitle, 119);
	TextDrawTextSize(TextDrawPunishTitle, 0.000000, 162.000000);

	TextDrawPunishDesc = TextDrawCreate(19.000000, 261.000000, "_");
	TextDrawBackgroundColor(TextDrawPunishDesc, 255);
	TextDrawFont(TextDrawPunishDesc, 1);
	TextDrawLetterSize(TextDrawPunishDesc, 0.189998, 0.899999);
	TextDrawColor(TextDrawPunishDesc, COLOR_WHITE);
	TextDrawSetProportional(TextDrawPunishDesc, 1);
	TextDrawSetShadow(TextDrawPunishDesc, 1);
	TextDrawUseBox(TextDrawPunishDesc, 1);
	TextDrawBoxColor(TextDrawPunishDesc, 68);
	TextDrawTextSize(TextDrawPunishDesc, 181.000000, 20.000000);

	// P�tla na sloty grup
	for(new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
	{
		TextDrawGroupOption[group_slot][0] = TextDrawCreate(321.000000, 182.000000 + group_slot * 15 + 1.8, "Info");
		TextDrawGroupOption[group_slot][1] = TextDrawCreate(360.000000, 182.000000 + group_slot * 15 + 1.8, "Pojazdy");
		TextDrawGroupOption[group_slot][2] = TextDrawCreate(399.000000, 182.000000 + group_slot * 15 + 1.8, "Sluzba");
		TextDrawGroupOption[group_slot][3] = TextDrawCreate(438.000000, 182.000000 + group_slot * 15 + 1.8, "Magazyn");
		TextDrawGroupOption[group_slot][4] = TextDrawCreate(477.000000, 182.000000 + group_slot * 15 + 1.8, "Online");

		for(new option_id = 0; option_id < 5; option_id++)
		{
  			TextDrawSetSelectable(TextDrawGroupOption[group_slot][option_id], true);
			TextDrawAlignment(TextDrawGroupOption[group_slot][option_id], 2);
			TextDrawLetterSize(TextDrawGroupOption[group_slot][option_id], 0.200000, 0.899999);
			TextDrawSetOutline(TextDrawGroupOption[group_slot][option_id], 1);
			TextDrawBackgroundColor(TextDrawGroupOption[group_slot][option_id], 255);
			TextDrawUseBox(TextDrawGroupOption[group_slot][option_id], 1);
			TextDrawBoxColor(TextDrawGroupOption[group_slot][option_id], 136);
			TextDrawTextSize(TextDrawGroupOption[group_slot][option_id], 10.000000, 35.000000);
		}
	}

	// P�tla na graczy
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
  		PlayerCache[i][pNameTag] = CreateDynamic3DTextLabel(" ", COLOR_NICK, 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 50.0);
		PlayerCache[i][pDescTag] = CreateDynamic3DTextLabel(" ", COLOR_DESC, 0.0, 0.0, 0.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 50.0);
	}
	
	// Pela na grupy
    for (new group_id = 0; group_id < MAX_GROUPS; group_id++)
	{
	    // Usu� za podatki
	    if(GroupData[group_id][gFlags] & G_FLAG_TAX)
	    {
	        if(GroupData[group_id][gLastTax] + (15 * 86000) <= gettime())
	        {
	            // DeleteGroup(group_id);
	        }
	    }
	}
	
	Audio_SetPack("community_pack");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	Audio_DestroyTCPServer();
	mysql_close();
	return 1;
}

task OnMinuteTask[60000]()
{
	new time, hour, minute, second;
	time = gettime(hour, minute, second);

	// Godzina
	static LastHour = 25;

	new NewHour;
	gettime(NewHour);
	if(NewHour > LastHour)
	{
		if(NewHour == 0)
		{
			new year, month, day, logo_string[128];
			getdate(year, month, day);
			
			format(logo_string, sizeof(logo_string), ""SERVER_NAME"~n~~w~~h~ver. "VERSION"   %02d.%02d.%d", day, month, year);
			TextDrawSetString(Text:TextDrawServerLogo, logo_string);
		}
		
		if(NewHour == 4)
		{
			SendRconCommand("gmx");
		}
	}
	LastHour = NewHour;
	
	foreach(new i :Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        // Czas gry
	        if(PlayerCache[i][pAFK] < 0)
	        {
		        PlayerCache[i][pMinutes] ++;
		        if(PlayerCache[i][pMinutes] > 59)
		        {
		            PlayerCache[i][pMinutes] = 0;
		            PlayerCache[i][pHours] ++;
		            
		            PlayerCache[i][pPoints] += (IsPlayerPremium(i) ? PACC_POINTS : FACC_POINTS);
					mysql_query_format("UPDATE `ipb_members` SET member_game_points = '%d' WHERE member_id = '%d' LIMIT 1", PlayerCache[i][pPoints], PlayerCache[i][pGID]);

					SetPlayerScore(i, PlayerCache[i][pPoints]);
					
					if(PlayerCache[i][pHours] >= 10)    GivePlayerAchievement(i, ACHIEVE_PLAYER);
					if(PlayerCache[i][pHours] >= 50)    GivePlayerAchievement(i, ACHIEVE_MASTER);
					if(PlayerCache[i][pHours] >= 100)   GivePlayerAchievement(i, ACHIEVE_LEGEND);
				}
			}
	        
    	    // Animacja BW
		    if(PlayerCache[i][pBW])
		    {
	         	ApplyAnimation(i, "PED", "FLOOR_hit", 4.1, 0, 1, 1, 1, 1, true);
		    }

			// Pod wp�ywem u�ywki
			if(PlayerCache[i][pDrugType] != DRUG_NONE)
			{
				switch(PlayerCache[i][pDrugType])
				{
				    // Marihuana
				    case DRUG_MARIHUANA:
				    {
				        PlayerCache[i][pDrugLevel] --;
				        switch(PlayerCache[i][pDrugLevel])
				        {
				            case 20:    SetPlayerWeather(i, 170);
				            case 15:    SetPlayerWeather(i, -2);
				            case 5:     SetPlayerWeather(i, 10);
				        }

				        if(PlayerCache[i][pDrugLevel] <= 0)
				        {
				            if(GetPlayerSpecialAction(i) != SPECIAL_ACTION_SMOKE_CIGGY)
				            {
					            PlayerCache[i][pDrugType] 	= DRUG_NONE;
					            PlayerCache[i][pDrugLevel] 	= 0;

					            PlayerCache[i][pDrugValue1] = 0;
					            PlayerCache[i][pDrugValue2] = 0;

					            SendClientMessage(i, COLOR_DO, "** Powr�ci�e� do stanu trze�wo�ci, odczuwasz du�e pragnienie i g��d. **");
							}
				        }
				    }

				    // Kokaina, Heroina
				    case DRUG_COCAINE, DRUG_HEROIN:
				    {
				        PlayerCache[i][pDrugLevel] --;
				        if(minute & 2 == 0)	ResetPlayerCamera(i);
				        
				        if(PlayerCache[i][pDrugLevel] <= 0)
				        {
		          			PlayerCache[i][pDrugType] 	= DRUG_NONE;
			            	PlayerCache[i][pDrugLevel] 	= 0;

							PlayerCache[i][pDrugValue1] = 0;
		     				PlayerCache[i][pDrugValue2] = 0;
				        }
				    }
				    
				    // Od�ywka
				    case DRUG_CONDITIONER:
				    {
				        PlayerCache[i][pDrugValue1] --;
				        if(PlayerCache[i][pDrugValue1] <= 0)
				        {
		          			PlayerCache[i][pDrugType] 	= DRUG_NONE;
			            	PlayerCache[i][pDrugLevel] 	= 0;

							PlayerCache[i][pDrugValue1] = 0;
		     				PlayerCache[i][pDrugValue2] = 0;
				        }
				    }
				}
			}
			
			// Uzale�nienie
			if(PlayerCache[i][pDepend] > 25.0)
			{
			    new Float:depend = PlayerCache[i][pDepend],
					drug_level = PlayerCache[i][pDrugLevel];
					
				if(drug_level < depend)
				{
				    if((depend > 25 && depend <= 35 && minute % 55 == 0) || (depend > 35 && depend <= 55 && minute & 45 == 0) || (depend > 55 && depend <= 70 && minute & 35 == 0))
				    {
						if(PlayerCache[i][pHealth] > 10)
						{
						    new Float:get_health = (depend - drug_level) / 10;
  							if(PlayerCache[i][pHealth] - get_health > 10)
         					{
								crp_SetPlayerHealth(i, PlayerCache[i][pHealth] - get_health);
         					}
              				else
				            {
                				crp_SetPlayerHealth(i, 10);
                			}
                			TD_ShowSmallInfo(i, 5, "Twoja postac odczuwa chec zazycia ~b~narkotyku~w~. Pasek ~r~stanu zdrowia ~w~ulegl zmianie z tego powodu.");

							if(depend >= 35)
							{
								new random_number = random(5),
									random_string[128];
									
								switch(random_number)
								{
									case 1: random_string = "** Odczuwasz lekkie duszno�ci. **";
									case 2: random_string = "** Od kilku minut odnosisz wra�enie, �e kto� Ci� �ledzi. **";
									case 3: random_string = "** S�yszysz dziwne odg�osy, zdaj�ce si� m�wi� do Ciebie. **";
									case 4: random_string = "** Masz wra�enie, jakby kto� trzyma� Ci� za r�k�. **";
								}
								SendClientMessage(i, COLOR_DO, random_string);
							}
						}
				    }
				}
			}
	    }
	}
	
	// Wyp�aty
	if(hour == 3 && minute == 30)
	{
	    // Rozdaj wyp�aty (offline)
	    mysql_query_format("UPDATE `"SQL_PREF"characters` SET char_payday = 1 WHERE (SELECT SUM(session_end - (session_start + session_extraid)) FROM `"SQL_PREF"sessions` WHERE session_type = 1 AND session_owner = char_uid AND session_end < %d AND session_start > %d) >= 1800", time, time - 86000);
		mysql_query_format("UPDATE `"SQL_PREF"characters` c, `"SQL_PREF"groups` SET char_bankcash = char_bankcash + (SELECT COALESCE(SUM(group_payment), 0) FROM `"SQL_PREF"char_groups` g, `"SQL_PREF"groups` WHERE c.char_uid = g.char_uid AND group_uid = g.group_belongs AND group_activity >= %d) WHERE char_payday = 1", ACTIVITY_LIMIT);


		// Rozdaj wyp�aty (online)
		new group_id, payment_sum;
  		foreach(new i : Player)
  		{
    		if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
    		{
        		for(new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
        		{
            		if(PlayerGroup[i][group_slot][gpUID])
            		{
                		if(PlayerGroup[i][group_slot][gpPayment])
                		{
                    		group_id = PlayerGroup[i][group_slot][gpID];
                      		if(GroupData[group_id][gActivity] >= ACTIVITY_LIMIT)
                      		{
                         		payment_sum += PlayerGroup[i][group_slot][gpPayment];
							}
						}
					}
				}
		            
	           	if(payment_sum)
				{
  					PlayerCache[i][pBankCash] += payment_sum;
	           		
	            	TD_ShowSmallInfo(i, 5, "Otrzymales wyplate w wysokosci ~g~$%d~w~.~n~Pieniadze zostaly przelane na ~y~konto bankowe~w~.", payment_sum);
					payment_sum = 0;
				}
   			}
		}

		// Zresetuj pkt. aktywno�ci
		foreach(new g : Groups)
		{
  			if(GroupData[g][gUID])
	    	{
      			if(GroupData[g][gActivity] >= ACTIVITY_LIMIT)
	        	{
	        		GroupData[g][gActivity] = 0;
				}
    		}
		}
			
		mysql_query_format("UPDATE `"SQL_PREF"groups`, `"SQL_PREF"characters` SET group_activity = 0, char_payday = 0 WHERE group_activity >= '%d' AND char_payday = 1", ACTIVITY_LIMIT);
	}
	
	foreach(new doorid : Door)
	{
		if(DoorCache[doorid][dFireData][FIRE_TIME])
	 	{
			new string[128], group_id;
			DoorCache[doorid][dFireData][FIRE_TIME] ++;

			foreach(new i : Player)
			{
	  			if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	   			{
	      			if(PlayerCache[i][pDutyGroup])
		       	 	{
						group_id = GetPlayerGroupID(i, PlayerCache[i][pDutyGroup]);
						if(GroupData[group_id][gType] == G_TYPE_FIREDEPT)
						{
							if(GetPlayerDoorID(i) == doorid)
							{
								if(PlayerCache[i][pItemWeapon] != INVALID_ITEM_ID)
								{
									if(GetPlayerWeapon(i) == 42)
									{
									    DoorCache[doorid][dFireData][FIRE_TIME] --;
									}
								}
							}
						}
	     			}
		    	}
			}
   			new color, Float:percent = (float(DoorCache[doorid][dFireData][FIRE_TIME]) / 15.0) * 100, fire_label = DoorCache[doorid][dFireData][FIRE_LABEL];
      		format(string, sizeof(string), "Ten budynek stan�� w p�omieniach!\nSzacowane zniszczenia: %d%", floatround(percent));
      		
      		if(DoorCache[doorid][dFireData][FIRE_TIME] < 5)			color = 0x33AA33FF;
      		else if(DoorCache[doorid][dFireData][FIRE_TIME] >= 5 && DoorCache[doorid][dFireData][FIRE_TIME] < 10)
      		{
			  	color = 0xFF9900FF;
                CreateExplosion(DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ], 9, 5.0);
			}
      		else
	  		{
			  	color = 0xAA3333FF;
			  	CreateExplosion(DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ], 2, 8.0);
			}
			
      		UpdateDynamic3DTextLabelText(Text3D:fire_label, color, string);
      		
      		// Po�ar dobieg� ko�ca
      		if(percent >= 100)
      		{
      		    DoorCache[doorid][dExitX]   = 0.0;
      		    DoorCache[doorid][dExitY]   = 0.0;
      		    DoorCache[doorid][dExitZ]   = 0.0;
      		    DoorCache[doorid][dExitA]   = 0.0;
      		    
      		    DoorCache[doorid][dExitInt] = 0;
      		    DoorCache[doorid][dExitVW]  = 0;
      		    
      		    DestroyDynamicObject(DoorCache[doorid][dFireData][FIRE_OBJECT]);
      		    DestroyDynamic3DTextLabel(Text3D:DoorCache[doorid][dFireData][FIRE_LABEL]);
      		    
      		    DoorCache[doorid][dFireData][FIRE_TIME] = 0;
      		    CreateExplosion(DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ], 6, 8.0);
      		    
      		    SaveDoor(doorid, SAVE_DOOR_EXIT);
      		}
      		else if(percent <= 0)
      		{
  		    	DestroyDynamicObject(DoorCache[doorid][dFireData][FIRE_OBJECT]);
      		    DestroyDynamic3DTextLabel(Text3D:DoorCache[doorid][dFireData][FIRE_LABEL]);
      		    
      		    DoorCache[doorid][dFireData][FIRE_TIME] = 0;
      		}
      		
	  	}
	}
	return 1;
}

task OnSecondTask[1000]()
{
	new hour, minute, second, string[256];
	
	gettime(hour, minute, second);
	SetWorldTime(hour + 1);
	
	if(PunishTime > 0)
	{
	    PunishTime --;
		if(PunishTime <= 0)
		{
		    PunishTime = 0;
		
		    TextDrawHideForAll(Text:TextDrawPunishTitle);
			TextDrawHideForAll(Text:TextDrawPunishDesc);
		}
	}
	
	foreach(new i : Player)
	{
	    if(GetPlayerState(i) == PLAYER_STATE_ONFOOT && !PlayerCache[i][pSpawned])
	    {
            GivePlayerPunish(INVALID_PLAYER_ID, INVALID_PLAYER_ID, PUNISH_KICK, "Spawn bez zalogowania.", 0, 0);
		 	continue;
	    }
	
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        new //anim_id = GetPlayerAnimationIndex(i),
				Float:PosX, Float:PosY, Float:PosZ,
	            Float:Health, status = PlayerCache[i][pStatus];
	            
	        GetPlayerPos(i, PosX, PosY, PosZ);
	        GetPlayerHealth(i, Health);
	        
	        new keysa, uda, lra;
	        GetPlayerKeys(i, keysa, uda, lra);
	    
	        // TextDraw informacyjny
			if(PlayerCache[i][pSmallTextTime])
			{
	        	PlayerCache[i][pSmallTextTime] --;
				if(PlayerCache[i][pSmallTextTime] <= 0)
				{
				    TD_HideSmallInfo(i);
				}
			}
			
			if(PlayerCache[i][pLargeTextTime])
			{
			    PlayerCache[i][pLargeTextTime] --;
			    if(PlayerCache[i][pLargeTextTime] <= 0)
			    {
			        TD_HideLargeInfo(i);
			    }
			}
			
			// TextDraw osi�gni��
			if(PlayerCache[i][pAchieveInfoTime])
			{
	        	PlayerCache[i][pAchieveInfoTime] --;
				if(PlayerCache[i][pAchieveInfoTime] <= 0)
				{
				    PlayerTextDrawHide(i, PlayerText:TextDrawAchieve[i]);
				}
			}
			
			// Czas freeze
			if(PlayerCache[i][pFreeze] > 0)
			{
			    PlayerCache[i][pFreeze] --;
			    if(PlayerCache[i][pFreeze] <= 0)
			    {
					OnPlayerFreeze(i, false, 0);
			    }
			}
			PlayerCache[i][pAFK] ++;
			
			if(Health > PlayerCache[i][pHealth])
			{
		 		SetPlayerHealth(i, PlayerCache[i][pHealth]);
			}

			if(GetPlayerMoney(i) > PlayerCache[i][pCash])
			{
				ResetPlayerMoney(i);
				GivePlayerMoney(i, PlayerCache[i][pCash]);
			}

			if(IsPlayerInAnyVehicle(i))
			{
   				new vehid = GetPlayerVehicleID(i),
					speed = GetPlayerSpeed(i, true), componentid;
					
   				// Anty SpeedHack
				if(speed >= VehicleModelData[CarInfo[vehid][cModel] - 400][vMaxSpeed] + 60)
				{
					GivePlayerPunish(i, INVALID_PLAYER_ID, PUNISH_KICK, "SpeedHack.", 0, 0);
					continue;
				}

				// Kierowca
	   			if(GetPlayerState(i) == PLAYER_STATE_DRIVER || GetPlayerVehicleSeat(i) == 0)
		        {
      				// UnAuthorised
					if(PlayerCache[i][pLastVeh] != vehid)
					{
	 					GivePlayerPunish(i, INVALID_PLAYER_ID, PUNISH_KICK, "Nieautoryzowane wejscie do pojazdu.", 0, 0);
	   					continue;
					}
					
					// Ograniczona pr�dko��
     				if(IsVehicleBike(vehid))
		            {
		                if(speed >= 55)
						{
		                    SetPlayerSpeed(i, 45.0);
		                }
		            }
		        
		            // GPS
		            if(CarInfo[vehid][cGPS])
		            {
	                    for(new icon_id = 0; icon_id < 100; icon_id++) RemovePlayerMapIcon(i, icon_id);

						new icon_id, carid, group_id,
				   		    Float:VehPosX, Float:VehPosY, Float:VehPosZ;

				   		foreach(new playerid : Player)
				   		{
				   		    if(i != playerid)
				   		    {
					   		    if(PlayerCache[playerid][pLogged] && PlayerCache[playerid][pSpawned])
					   		    {
									if(PlayerCache[playerid][pDutyGroup])
									{
									    group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
									    if(GroupData[group_id][gType] == G_TYPE_POLICE)
									    {
						   		            carid = GetPlayerVehicleID(playerid);
						   		            if(CarInfo[carid][cOwnerType] == OWNER_GROUP && CarInfo[carid][cOwner] == PlayerCache[playerid][pDutyGroup])
						   		            {
						   		                GetVehiclePos(carid, VehPosX, VehPosY, VehPosZ);
						   						SetPlayerMapIcon(i, icon_id, VehPosX, VehPosY, VehPosZ, 30, 0, MAPICON_GLOBAL);

						   						icon_id ++;
											}
										}
									}
								}
							}
						}
		            }

					if(GetVehicleEngineStatus(vehid) == 1 && !IsVehicleBike(vehid))
					{
						new Float:last_fuel = CarInfo[vehid][cFuel];

						if(speed < 1)
				    	{
		   					CarInfo[vehid][cFuel] -= 0.005;
				    	}
				    	else if(speed >= 1 && speed <= 40)
				    	{
		    				CarInfo[vehid][cFuel] -= 0.008;
				    	}
				    	else if(speed >= 41 && speed <= 80)
				    	{
		    				CarInfo[vehid][cFuel] -= 0.01;
				    	}
				    	else if(speed >= 81 && speed <= 120)
					   	{
		    				CarInfo[vehid][cFuel] -= 0.015;
				    	}
				    	else if(speed >= 121 && speed <= 150)
				    	{
		    				CarInfo[vehid][cFuel] -= 0.02;
				    	}
				    	else
				    	{
		    				CarInfo[vehid][cFuel] -= 0.03;
				    	}

				    	// Je�li paliwo spadnie o 1 litr, poka� info
	     				if(floatround(CarInfo[vehid][cFuel], floatround_floor) < floatround(last_fuel, floatround_floor))
		        		{
		    				format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~y~Paliwo: ~g~~h~%.0f/%d L", CarInfo[vehid][cFuel], VehicleModelData[CarInfo[vehid][cModel] - 400][vMaxFuel]);
		    				GameTextForPlayer(i, string, 10000, 3);

		    				CarInfo[vehid][cSavePoint] += 5;
						}

						CarInfo[vehid][cDistTicker] += floatround(floatsqroot(floatpower(floatabs(floatsub(PosX, PlayerCache[i][pPosX])), 2)+ floatpower(floatabs(floatsub(PosY, PlayerCache[i][pPosY])), 2)+floatpower(floatabs(floatsub(PosZ, PlayerCache[i][pPosZ])), 2)));

						// Przejecha� 100 metr�w
						if(CarInfo[vehid][cDistTicker] >= 100)
	     				{
	     				    // Taxi
							if(PlayerCache[i][pTaxiPassenger] != INVALID_PLAYER_ID)
							{
								new passenger_id = PlayerCache[i][pTaxiPassenger];
								if(PlayerCache[passenger_id][pCash] > (PlayerCache[passenger_id][pTaxiPay] + PlayerCache[passenger_id][pTaxiPrice]))
								{
								    PlayerCache[passenger_id][pTaxiPay] += PlayerCache[passenger_id][pTaxiPrice];
	   								format(string, sizeof(string), "~w~Koszt: ~g~$%d", PlayerCache[passenger_id][pTaxiPay]);

									GameTextForPlayer(i, string, 5000, 6);
					    			GameTextForPlayer(passenger_id, string, 5000, 6);
								}
								else
								{
				    				GameTextForPlayer(i, "~r~Pasazer nie posiada tyle gotowki", 5000, 6);
								    GameTextForPlayer(passenger_id, "~r~Nie posiadasz tyle gotowki", 5000, 6);
								}
							}

						    // Nalicz przebieg
						    CarInfo[vehid][cMileage] += 0.1;
						    CarInfo[vehid][cDistTicker] = 0;

						    CarInfo[vehid][cSavePoint] += 5;
						    PlayerCache[i][pMileage] += 0.1;
						}

						// Stan techniczny
						GetVehicleHealth(vehid, Health);
						if(Health > CarInfo[vehid][cHealth])
						{
		 					SetVehicleHealth(vehid, CarInfo[vehid][cHealth]);
						}
						if(Health < CarInfo[vehid][cHealth])
						{
						    OnPlayerTakeDamage(i, INVALID_PLAYER_ID, ((CarInfo[vehid][cHealth] - Health) / ((PlayerCache[i][pBelts]) ? 10 : 5)), 0, 0);
		 					GetVehicleHealth(vehid, CarInfo[vehid][cHealth]);
		 					
		 					CarInfo[vehid][cSavePoint] ++;
		 					printf("[cars] Stan pojazdu %s (UID: %d) uleg� zmianie. Kierowca: %s (UID: %d, GID: %d), HP: %.0f/%.0f", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID], PlayerRealName(i), PlayerCache[i][pUID], PlayerCache[i][pGID], Health, CarInfo[vehid][cHealth]);
						}

						// Stan wizualny
						new panels, doors, lights, tires;
						GetVehicleDamageStatus(vehid, panels, doors, lights, tires);

						if(panels < CarInfo[vehid][cVisual][0] || lights < CarInfo[vehid][cVisual][2] || tires < CarInfo[vehid][cVisual][3])
						{
							UpdateVehicleDamageStatus(vehid, CarInfo[vehid][cVisual][0], CarInfo[vehid][cVisual][1], CarInfo[vehid][cVisual][2], CarInfo[vehid][cVisual][3]);
						}
						GetVehicleDamageStatus(vehid, CarInfo[vehid][cVisual][0], CarInfo[vehid][cVisual][1], CarInfo[vehid][cVisual][2], CarInfo[vehid][cVisual][3]);

						if(CarInfo[vehid][cHealth] <= 360 || CarInfo[vehid][cHealth] < 700 && random(150) == 25)
						{
							ChangeVehicleEngineStatus(vehid, false);
							TD_ShowSmallInfo(i, 5, "Silnik w pojezdzie zgasl ze wzgledu na liczne ~r~uszkodzenia ~w~techniczne.");

							CarInfo[vehid][cSavePoint] += 30;
						}

	    				if(CarInfo[vehid][cFuel] <= 0)
				    	{
	                        ChangeVehicleEngineStatus(vehid, false);
							TD_ShowSmallInfo(i, 5, "Silnik w pojezdzie zgasl ze wzgledu na liczne ~r~brak ~w~paliwa.", 5000, 3);

							CarInfo[vehid][cSavePoint] += 30;
				    	}
				    	
				    	// Kolczatki
				    	if(GetPlayerInterior(i) == 0 && GetPlayerVirtualWorld(i) == 0)
				    	{
							new object_id = GetClosestObjectType(i, OBJECT_ECHIDNA);
							if(object_id != INVALID_OBJECT_ID)
							{
			   					CarInfo[vehid][cVisual][3] = 15;
			    				UpdateVehicleDamageStatus(vehid, CarInfo[vehid][cVisual][0], CarInfo[vehid][cVisual][1], CarInfo[vehid][cVisual][2], CarInfo[vehid][cVisual][3]);

								DestroyDynamicObject(object_id);
								TD_ShowSmallInfo(i, 5, "Najechales na ~y~kolczatke~w~!~n~Opony zostaly ~r~przebite~w~.");
							}
						}

	 					// Zapisz statsy
						if(CarInfo[vehid][cSavePoint] >= 70)	SaveVehicle(vehid, SAVE_VEH_COUNT);

						GetVehiclePos(vehid, CarInfo[vehid][cPosX], CarInfo[vehid][cPosY], CarInfo[vehid][cPosZ]);
						GetVehicleZAngle(vehid, CarInfo[vehid][cPosA]);
					}

					// Anty tuning
	  				for (new j = 0; j < 14; ++j)
		   			{
	   					componentid = GetVehicleComponentInSlot(vehid, j);
	     				if (componentid != 0 && componentid != (CarInfo[vehid][cComponent][j] + 999))
	        			{
	      	    			GivePlayerPunish(i, INVALID_PLAYER_ID, PUNISH_BAN, "Proba stuningowania pojazdu.", 365, 0);
							SetVehicleToRespawn(vehid);
	      					continue;
	      				}
			    	}
		        }
			}
	        
 			// Brutally Wounded (bw)
			if(PlayerCache[i][pBW])
			{
			    PlayerCache[i][pBW] --;
				if(PlayerCache[i][pBW] > 1 * 60)
				{
					format(string, sizeof(string), "~w~Koniec ~r~BW~w~: ~y~%d ~w~min.", PlayerCache[i][pBW] / 60);
					GameTextForPlayer(i, string, 1000, 1);
				}
				else
				{
					format(string, sizeof(string), "~w~Koniec ~r~BW~w~: ~y~%d ~w~sek.", PlayerCache[i][pBW]);
					GameTextForPlayer(i, string, 1000, 1);
				}
				
				// Koniec
				if(PlayerCache[i][pBW] <= 0)
				{
					PlayerCache[i][pBW] = 0;
					
					ApplyAnimation(i, "Attractors", "Stepsit_out", 4.0, 0, 1, 1, 0, 1, true);
					OnPlayerFreeze(i, false, 0);

					ResetPlayerCamera(i);
					crp_SetPlayerHealth(i, 20);

					TD_ShowSmallInfo(i, 5, "Ocknales sie, jednak nie jestes ~y~calkiem ~w~na silach.~n~Twoj stan zdrowia ~r~nie jest ~w~idealny, lepiej udaj sie do szpitala.");
					SetPlayerDrunkLevel(i, 5000);
				}
			}
			
			// AdminJail (aj)
			if(PlayerCache[i][pAJ])
			{
			    if(!IsPlayerInRangeOfPoint(i, 5.0, PosInfo[ADMIN_JAIL_POS][sPosX], PosInfo[ADMIN_JAIL_POS][sPosY], PosInfo[ADMIN_JAIL_POS][sPosZ]))
			    {
			        crp_SetPlayerPos(i,  PosInfo[ADMIN_JAIL_POS][sPosX], PosInfo[ADMIN_JAIL_POS][sPosY], PosInfo[ADMIN_JAIL_POS][sPosZ]);
			        
			       	SetPlayerInterior(i, PosInfo[ADMIN_JAIL_POS][sPosInterior]);
					SetPlayerVirtualWorld(i, i + 1000);
			    }

			    PlayerCache[i][pAJ] --;
				if(PlayerCache[i][pAJ] > 1*60)
				{
					format(string, sizeof(string), "~w~Koniec ~r~AJ~w~: ~g~%d ~w~min.", PlayerCache[i][pAJ] / 60);
					GameTextForPlayer(i, string, 1000, 1);
				}
				else
				{
					format(string, sizeof(string), "~w~Koniec ~r~AJ~w~: ~g~%d ~w~sek.", PlayerCache[i][pAJ]);
					GameTextForPlayer(i, string, 1000, 1);
				}
				if(PlayerCache[i][pAJ] <= 0)
				{
					PlayerCache[i][pAJ] = 0;
					SetPlayerSpawn(i);
				}
			}
			
			// Skuty gracz
			if(PlayerCache[i][pCuffedTo] != INVALID_PLAYER_ID)
			{
			    new cuffed_to = PlayerCache[i][pCuffedTo],
			        Float:cuffed_x, Float:cuffed_y, Float:cuffed_z,
			        cuffed_interior, cuffed_world;
			        
				GetPlayerPos(cuffed_to, cuffed_x, cuffed_y, cuffed_z);
				
				cuffed_interior = GetPlayerInterior(cuffed_to);
				cuffed_world = GetPlayerVirtualWorld(cuffed_to);
				
				if(!IsPlayerInAnyVehicle(cuffed_to))
				{
					if(!IsPlayerInRangeOfPoint(i, 5.0, cuffed_x, cuffed_y, cuffed_z))
					{
					    if(IsPlayerInAnyVehicle(i))
					    {
					        RemovePlayerFromVehicle(i);
							OnPlayerFreeze(i, false, 0);
					    }

					    crp_SetPlayerPos(i, cuffed_x + 1, cuffed_y, cuffed_z);

					    SetPlayerInterior(i, cuffed_interior);
					    SetPlayerVirtualWorld(i, cuffed_world);
					}
				}
				else
				{
				    new vehid = GetPlayerVehicleID(cuffed_to),
						seatid = GetFreeVehicleSeat(vehid);
				    
				    if(seatid != INVALID_VEHICLE_ID)
				    {
				        PlayerCache[i][pLastVeh] = vehid;
				        
				        PutPlayerInVehicle(i, vehid, seatid);
						OnPlayerFreeze(i, true, 0);
				    }
				    else
				    {
				        TD_ShowSmallInfo(cuffed_to, 3, "Brak ~r~wolnego miejsca ~w~w pojezdzie.");
				    }
				}
			}
			
			// Przeszukiwanie gracza
			if(PlayerCache[i][pSearches] != INVALID_PLAYER_ID)
			{
			    new searched_player = PlayerCache[i][pSearches];
			    if(PlayerToPlayer(5.0, i, searched_player))
			    {
					PlayerCache[i][pSearchTime] --;

					GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~g~Trwa przeszukiwanie...", 1000, 3);
					if(PlayerCache[i][pSearchTime] <= 0)
					{
					    ListPlayerItemsForPlayer(searched_player, i);

                    	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Gotowka gracza ~r~%s~y~: ~g~$%d~y~.", PlayerName(searched_player), PlayerCache[searched_player][pCash]);
						GameTextForPlayer(i, string, 6000, 3);

					    PlayerCache[i][pSearches] = INVALID_PLAYER_ID;
					    PlayerCache[i][pSearchTime] = 0;
					}
				}
				else
				{
				    PlayerCache[i][pSearches] = INVALID_PLAYER_ID;
				    PlayerCache[i][pSearchTime] = 0;

				    ShowPlayerInfoDialog(i, D_TYPE_ERROR, "Przeszukiwanie gracza zosta�o anulowane.\nPow�d: Gracz znajduje si� zbyt daleko od Ciebie.");
                    GameTextForPlayer(searched_player, "~r~~h~Przeszukiwanie zostalo przerwane.", 4500, 3);
				}
			}
			
			// Leczenie gracza przez medyka
			if(PlayerCache[i][pHealing] != INVALID_PLAYER_ID)
			{
			    new patient_id = PlayerCache[i][pHealing];
			    if(PlayerToPlayer(5.0, i, patient_id))
			    {
			        if(PlayerCache[patient_id][pHealth] + 5.0 < 100.0)
			        {
						crp_SetPlayerHealth(patient_id, PlayerCache[patient_id][pHealth] + 5.0);

						GameTextForPlayer(i, "~n~~n~~n~~n~~n~~g~~h~Proces leczenia trwa...", 3000, 3);
                        GameTextForPlayer(patient_id, "~n~~n~~n~~n~~n~~g~~h~Proces leczenia trwa...", 3000, 3);
					}
			        else
			        {
			            PlayerCache[i][pHealing] = INVALID_PLAYER_ID;
			            crp_SetPlayerHealth(patient_id, 100.0);

			            ShowPlayerInfoDialog(i, D_TYPE_INFO, "Proces leczenia zosta� zako�czony pomy�lnie.");
                        ShowPlayerInfoDialog(patient_id, D_TYPE_INFO, "Proces leczenia zosta� zako�czony pomy�lnie.");
					}
			    }
			    else
			    {
			        PlayerCache[i][pHealing] = INVALID_PLAYER_ID;

					ShowPlayerInfoDialog(i, D_TYPE_ERROR, "Proces leczenia gracza zosta�o anulowane.\nPow�d: Gracz znajduje si� zbyt daleko od Ciebie.");
                    GameTextForPlayer(patient_id, "~r~~h~Leczenie zostalo przerwane.", 4500, 3);
				}
			}
			
			// Trening w si�owni
			if(PlayerCache[i][pItemPass] != INVALID_ITEM_ID)
			{
				PlayerCache[i][pGymTime] --;

				if(PlayerCache[i][pGymTime] > 60)
				{
					format(string, sizeof(string), "~w~Trening: ~y~%d ~w~min", PlayerCache[i][pGymTime] / 60);
					GameTextForPlayer(i, string, 1000, 6);
  				}
				else
				{
					format(string, sizeof(string), "~w~Trening: ~y~%d ~w~sec", PlayerCache[i][pGymTime]);
   					GameTextForPlayer(i, string, 1000, 6);
				}
				
				if(PlayerCache[i][pGymTime] <= 0)
				{
					new object_id = PlayerCache[i][pGymObject],
					    itemid = PlayerCache[i][pItemPass];

					if(object_id != INVALID_OBJECT_ID)
					{
						ClearAnimations(i, true);
		    			PlayerCache[i][pStrength] = PlayerCache[i][pStrength] + (PlayerCache[i][pGymRepeat] / 4);

						PlayerCache[i][pGymObject] 	= INVALID_OBJECT_ID;
		    			PlayerCache[i][pGymRepeat] 	= 0;

						RemovePlayerAttachedObject(i, SLOT_TRAIN);
		    			TD_ShowSmallInfo(i, 3, "Trening zostal ~g~pomyslnie ~w~zakonczony.");
					}
					DeleteItem(itemid);

					PlayerCache[i][pItemPass]    = INVALID_ITEM_ID;
			  		PlayerCache[i][pGymTime]     = 0;
				}
			}
			
			// Naprawa pojazdu
			if(PlayerCache[i][pRepairVeh] != INVALID_VEHICLE_ID)
			{
   				new vehid = PlayerCache[i][pRepairVeh], Float:VehX, Float:VehY, Float:VehZ;
			    GetVehiclePos(vehid, VehX, VehY, VehZ);
			    
			    if(IsPlayerInRangeOfPoint(i, 4.0, VehX, VehY, VehZ))
			    {
					if(GetVehicleEngineStatus(vehid) != 1)
					{
				        PlayerCache[i][pRepairTime] --;
						TD_ShowSmallInfo(i, 0, "Odgrywaj stosowna akcje ~r~RolePlay~w~.~n~Pozostalo do konca: ~y~%d ~w~sekund.", PlayerCache[i][pRepairTime]);
	  					
  						new Text3D:label_id = PlayerCache[i][pRepairTag],
				   			Float:percent = (floatabs((float(PlayerCache[i][pRepairTime]) / 180.0) * 100 - 100));

						format(string, sizeof(string), "Naprawianie w toku...\n -- (%d%%) --", floatround(percent));
						UpdateDynamic3DTextLabelText(Text3D:label_id, COLOR_LIGHTBLUE, string);

	  					if(PlayerCache[i][pRepairTime] <= 0)
	  					{
	  					    CarInfo[vehid][cVisual][0] = 0;
	  					    CarInfo[vehid][cVisual][1] = 0;
	  					    CarInfo[vehid][cVisual][2] = 0;
	  					    CarInfo[vehid][cVisual][3] = 0;

	  					    CarInfo[vehid][cHealth] = 1000;

	  					    RepairVehicle(vehid);
	  					    SetVehicleHealth(vehid, 1000);

                            DestroyDynamic3DTextLabel(Text3D:label_id);

                            printf("[cars] Pojazd %s (UID: %d) zosta� naprawiony. HP: %.0f", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID], CarInfo[vehid][cHealth]);

							PlayerCache[i][pRepairVeh] 	= INVALID_VEHICLE_ID;
							PlayerCache[i][pRepairTime] = 0;

	  					    SaveVehicle(vehid, SAVE_VEH_COUNT);
	  					    TD_ShowSmallInfo(i, 5, "Pojazd zostal ~g~pomyslnie ~w~naprawiony.");
						}
					}
					else
					{
					    GameTextForPlayer(i, "~r~Silnik pojazdu musi byc zgaszony!", 1000, 3);
					}
			    }
			}
			
			// Lakierowanie pojazdu
			if(PlayerCache[i][pSprayVeh] != INVALID_VEHICLE_ID)
			{
			    new vehid = PlayerCache[i][pSprayVeh];
				if(GetDistanceToVehicle(i, vehid) <= 4.0)
				{
					new itemid = PlayerCache[i][pItemWeapon];
					if(itemid != INVALID_ITEM_ID && (keysa & KEY_FIRE) && ItemCache[itemid][iType] == ITEM_PAINT && GetPlayerState(i) == PLAYER_STATE_ONFOOT)
					{
				        if(IsPlayerFacingVehicle(i, vehid))
				        {
				            new weapon_ammo = GetPlayerWeaponAmmo(i, ItemCache[itemid][iValue1]);
				            if(weapon_ammo < ItemCache[itemid][iValue2])
				            {
		  						PlayerCache[i][pSprayTime] -= (ItemCache[itemid][iValue2] - weapon_ammo);
								TD_ShowSmallInfo(i, 0, "Psikaj ~g~lakierem ~w~w strone pojazdu.~n~Pozostala wymagana ilosc: ~y~%d", PlayerCache[i][pSprayTime]);

		  						new Text3D:label_id = PlayerCache[i][pSprayTag],
						   			Float:percent = (floatabs((float(PlayerCache[i][pSprayTime]) / 1800.0) * 100 - 100));

		   						format(string, sizeof(string), "Lakierowanie w toku...\n -- (%d%%) --", floatround(percent));
		   						UpdateDynamic3DTextLabelText(Text3D:label_id, COLOR_LIGHTBLUE, string);

								if(PlayerCache[i][pSprayTime] <= 0)
				 				{
					    			if(PlayerCache[i][pSprayType] == SPRAY_TYPE_COLORS)
				 			    	{
		      							new color1 = PlayerCache[i][pSprayColor][0],
										  	color2 = PlayerCache[i][pSprayColor][1];

										ChangeVehicleColor(vehid, color1, color2);

										CarInfo[vehid][cColor1] = color1;
			  							CarInfo[vehid][cColor2] = color2;

			  							printf("[cars] Kolory pojazdu %s (UID: %d) uleg�y zmianie. Nowe kolory: %d/%d.", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID], CarInfo[vehid][cColor1], CarInfo[vehid][cColor2]);
									}
									else if(PlayerCache[i][pSprayType] == SPRAY_TYPE_PAINTJOB)
									{
					    				new paintjob_id = PlayerCache[i][pSprayColor][0];
									    ChangeVehiclePaintjob(vehid, paintjob_id);

									    CarInfo[vehid][cPaintJob] = paintjob_id;
									    printf("[cars] Paintjob pojazdu %s (UID: %d) uleg� zmianie. Nowy paintjob: %d.", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID], CarInfo[vehid][cPaintJob]);
									}

   									PlayerCache[i][pSprayVeh] 			= INVALID_VEHICLE_ID;

									PlayerCache[i][pSprayColor][0] 		= 0;
		    						PlayerCache[i][pSprayColor][1] 		= 0;

									PlayerCache[i][pSprayTime] 			= 0;
									PlayerCache[i][pSprayType] 			= SPRAY_TYPE_NONE;

									DestroyDynamic3DTextLabel(Text3D:label_id);

									SaveVehicle(vehid, SAVE_VEH_ACCESS);
									TD_ShowSmallInfo(i, 5, "Pojazd zostal ~g~pomyslnie ~w~przemalowany.");
								}
							}
						}
						else
						{
			    			GameTextForPlayer(i, "~r~Psikaj w strone pojazdu.", 1000, 3);
						}
					}
				}
				else
				{
				    GameTextForPlayer(i, "~r~Jestes zbyt daleko od pojazdu.", 1000, 3);
				}
			}
			
			// Montowanie cz�ci
			if(PlayerCache[i][pMontageVeh] != INVALID_VEHICLE_ID)
			{
			    new vehid = PlayerCache[i][pMontageVeh];
			    
				if(GetDistanceToVehicle(i, vehid) <= 4.0)
				{
				    PlayerCache[i][pMontageTime] --;

   					format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~g~Pozostalo: ~w~%d sekund.", PlayerCache[i][pMontageTime]);
  					GameTextForPlayer(i, string, 1000, 3);

  					if(PlayerCache[i][pMontageTime] <= 0)
  					{
  					    new itemid = PlayerCache[i][pMontageItem];

  					    // Komponent tuningu
  					    if(ItemCache[itemid][iType] == ITEM_TUNING)
  					    {
							mysql_query_format("UPDATE `"SQL_PREF"items` SET item_place = '-1', item_owner = '0', item_vehuid = '%d' WHERE item_uid = '%d' LIMIT 1", CarInfo[vehid][cUID], ItemCache[itemid][iUID]);
	  					    crp_AddVehicleComponent(vehid, ItemCache[itemid][iValue1]);
	  					    
	  					    printf("[cars] W poje�dzie %s (UID: %d) zosta� zamontowany komponent %s (UID: %d).", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID], ItemCache[itemid][iName], ItemCache[itemid][iUID]);
	  					    ClearItemCache(itemid);
						}

						// Akcesoria (alarm, immobiliser, sprz�t audio [...])
						if(ItemCache[itemid][iType] == ITEM_VEH_ACCESS)
						{
						    CarInfo[vehid][cAccess] += ItemCache[itemid][iValue1];
						    if(ItemCache[itemid][iValue1] & VEH_ACCESS_GAS)	CarInfo[vehid][cFuelType] = FUEL_TYPE_GAS;
						    
						    SaveVehicle(vehid, SAVE_VEH_ACCESS);

							printf("[cars] W poje�dzie %s (UID: %d) zosta�o zamontowane akcesorie %s (UID: %d).", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID], ItemCache[itemid][iName], ItemCache[itemid][iUID]);
						    DeleteItem(itemid);
						}
						
						PlayerCache[i][pMontageVeh] 	= INVALID_VEHICLE_ID;
		    			PlayerCache[i][pMontageTime] 	= 0;

						PlayerCache[i][pMontageItem] 	= 0;
   						ShowPlayerInfoDialog(i, D_TYPE_SUCCESS, "Cz�� zosta�a pomy�lnie zamontowana.");
  					}
				}
			}
			
			// Przejazd busem
			if(PlayerCache[i][pBusRide])
			{
   				PlayerCache[i][pBusTime] --;
			    if(PlayerCache[i][pBusTime] <= 0)
			    {
			        new object_id = PlayerCache[i][pBusTravel],
			            Float:oPosX, Float:oPosY, Float:oPosZ;
			            
					GetDynamicObjectPos(object_id, oPosX, oPosY, oPosZ);
					crp_SetPlayerPos(i, oPosX, oPosY, oPosZ);

					SetPlayerInterior(i, 0);
					SetPlayerVirtualWorld(i, 0);

					ResetPlayerCamera(i);
					OnPlayerFreeze(i, false, 0);
					
					PlayerPlaySound(i, 1098, 0.0, 0.0, 0.0);
					PlayerPlaySound(i, 1147, 0.0, 0.0, 0.0);

					PlayerCache[i][pBusStart] 	= INVALID_OBJECT_ID;
					PlayerCache[i][pBusTravel] 	= INVALID_OBJECT_ID;
					
					PlayerCache[i][pBusRide]    = false;
				}
			}
			
			// Tagowanie
			if(PlayerCache[i][pTaggingObject] != INVALID_OBJECT_ID)
			{
			    new object_id = PlayerCache[i][pTaggingObject], Float:distance;
			    Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, object_id, distance);

			    if(distance <= 3.0)
				{
    				new itemid = PlayerCache[i][pItemWeapon];
					if(itemid != INVALID_ITEM_ID && (keysa & KEY_FIRE) && ItemCache[itemid][iType] == ITEM_WEAPON && ItemCache[itemid][iValue1] == 41 && GetPlayerState(i) == PLAYER_STATE_ONFOOT)
					{
     					if(IsPlayerFacingObject(i, object_id))
		        		{
				            new weapon_ammo = GetPlayerWeaponAmmo(i, ItemCache[itemid][iValue1]);
				            if(weapon_ammo < ItemCache[itemid][iValue2])
				            {
              					PlayerCache[i][pTaggingTime] -= (ItemCache[itemid][iValue2] - weapon_ammo);
              					TD_ShowSmallInfo(i, 0, "Psikaj w strone ~g~znacznika~w~, zeby malowac.~n~Pozostala wymagana ilosc: ~y~%d", PlayerCache[i][pTaggingTime]);

								if(PlayerCache[i][pTaggingTime] <= 0)
        						{
									new group_id = PlayerCache[i][pMainTable];

									PlayerCache[i][pTaggingObject] 	= INVALID_OBJECT_ID;
         							PlayerCache[i][pTaggingTime]    = 0;
         							
									format(string, sizeof(string), "{%06x}%s", GroupData[group_id][gColor] >>> 8, GroupData[group_id][gTag]);
									mysql_query_format("UPDATE `"SQL_PREF"objects` SET object_material = '1 0 60 40 1 %x 0 1 times %s' WHERE object_uid = '%d' LIMIT 1", COLOR_WHITE, string, GetObjectUID(object_id));

									SetDynamicObjectMaterialText(object_id, 0, string, 60, "Times", 40, 1, COLOR_WHITE, 0, 1);
									TD_ShowSmallInfo(i, 5, "Tagowanie zostalo ~g~pomyslnie ~w~zakonczone.");
								}
					        }
						}
					}
				}
				else
				{
					PlayerCache[i][pTaggingObject] 	= INVALID_OBJECT_ID;
					PlayerCache[i][pTaggingTime]    = 0;

					TD_ShowSmallInfo(i, 3, "Tagowanie zostalo ~r~anulowane~w~.");
				}
			}
			
			// Nauka jazdy
			if(PlayerCache[i][pLesson] != INVALID_GROUP_ID)
			{
				PlayerCache[i][pLessonTime] --;
				if(PlayerCache[i][pLessonTime] > 60)
				{
					format(string, sizeof(string), "~w~Nauka jazdy: ~y~%d ~w~min", PlayerCache[i][pLessonTime] / 60);
					GameTextForPlayer(i, string, 1000, 6);
  				}
				else
				{
					format(string, sizeof(string), "~w~Nauka jazdy: ~y~%d ~w~sec", PlayerCache[i][pLessonTime]);
   					GameTextForPlayer(i, string, 1000, 6);
				}
				
				if(PlayerCache[i][pLessonTime] <= 0)
				{
				    new group_id = PlayerCache[i][pLesson], vehid = GetPlayerVehicleID(i);
				    if(vehid != INVALID_VEHICLE_ID)
				    {
				        if(CarInfo[vehid][cOwnerType] == OWNER_GROUP && CarInfo[vehid][cOwner] == GroupData[group_id][gUID])
				        {
				            PlayerCache[i][pLesson] = INVALID_GROUP_ID;
				            PlayerCache[i][pLessonTime] = 0;
				        
				            RemovePlayerFromVehicle(i);
				            TD_ShowSmallInfo(i, 3, "Kurs nauki jazdy dobiegl ~r~konca~w~.");
				        }
				    }
				}
			}
			
			// Paczki
			if(PlayerCache[i][pPackage] != INVALID_PACKAGE_ID)
			{
			    if(PlayerCache[i][pCheckpoint] != CHECKPOINT_PACKAGE && PlayerCache[i][pCheckpoint] != CHECKPOINT_DOOR)
			    {
     				PlayerCache[i][pCheckpoint] 	= CHECKPOINT_NONE;
					PlayerCache[i][pPackage]	 	= INVALID_PACKAGE_ID;

					TD_ShowSmallInfo(i, 3, "Dostarczanie paczki zostalo ~r~anulowane~w~.");
			    }
			}
			
   			if(PlayerCache[i][pCheckWeapon])
      		{
			    // Zapis amunicji
        		if(PlayerCache[i][pItemWeapon] != INVALID_ITEM_ID)
		        {
       				new itemid = PlayerCache[i][pItemWeapon],
						weapon_id = ItemCache[itemid][iValue1], weapon_ammo;

					if(weapon_id > 15 && weapon_id < 44)
					{
 						weapon_ammo = GetPlayerWeaponAmmo(i, weapon_id);
						if(weapon_ammo > ItemCache[itemid][iValue2])
						{
						    format(string, sizeof(string), "AmmoCheat (%d/%d).", weapon_ammo, ItemCache[itemid][iValue2]);
							GivePlayerPunish(i, INVALID_PLAYER_ID, PUNISH_BAN, string, 30, 0);
							continue;
						}

						if(weapon_ammo < ItemCache[itemid][iValue2])
						{
							ItemCache[itemid][iValue2] = weapon_ammo;
						}

						if(GetPlayerWeaponState(i) == WEAPONSTATE_NO_BULLETS)
						{
						    if(ItemCache[itemid][iValue2] <= 0)
						    {
								ResetPlayerWeaponsEx(i);
								PlayerCache[i][pCheckWeapon] = false;

								ItemCache[itemid][iValue2] = 0;
								ItemCache[itemid][iUsed] = false;

								SaveItem(itemid, SAVE_ITEM_VALUES);

								PlayerCache[i][pItemWeapon] = INVALID_ITEM_ID;
								RemovePlayerAttachedObject(i, SLOT_WEAPON);
							}
						}
					}
				}
			}
			
			// Boombox
			if(PlayerCache[i][pItemBoombox] != INVALID_ITEM_ID)
			{
          		foreach(new playerid : Player)
				{
				    if(PlayerCache[playerid][pLogged] && PlayerCache[playerid][pSpawned])
				    {
	 					if(playerid != i)
	   					{
							if(PlayerCache[playerid][pCurrentArea] == PlayerCache[i][pCurrentArea])
							{
								Audio_Set3DPosition(playerid, PlayerCache[playerid][pAudioHandle], PlayerCache[i][pPosX], PlayerCache[i][pPosY], PlayerCache[i][pPosZ], 15.0);
							}
						}
					}
			    }
			}
			
			if(!(PlayerCache[i][pAdmin] & A_PERM_BASIC))
			{
				// Anty WeaponHack
				if(PlayerCache[i][pCheckWeapon])
				{
				    if(!PlayerCache[i][pBW])
				    {
					    if(PlayerCache[i][pItemWeapon] != INVALID_ITEM_ID)
					    {
					        if(GetPlayerWeaponID(i) > 0 && GetPlayerWeaponID(i) < 46)
					        {
					            new itemid = PlayerCache[i][pItemWeapon];
					            if(GetPlayerWeaponID(i) != ItemCache[itemid][iValue1])
					            {
		 							new weapon_id = GetPlayerWeaponID(i), weapon_name[32];
			    					GetWeaponName(weapon_id, weapon_name, sizeof(weapon_name));

									format(string, sizeof(string), "WeaponHack (weapID: %d, weapName: %s).", weapon_id, weapon_name);
									GivePlayerPunish(i, INVALID_PLAYER_ID, PUNISH_BAN, string, 365, 0);
									continue;
								}
							}
						}
						else
						{
	     					if(GetPlayerWeaponID(i) > 0 && GetPlayerWeaponID(i) < 46)
					        {
					            new bool: weapon_found;
					            foreach(new itemid : Item)
					            {
					                if(ItemCache[itemid][iPlace] == PLACE_PLAYER && ItemCache[itemid][iOwner] == PlayerCache[i][pUID])
					                {
						                if(ItemCache[itemid][iType] == ITEM_WEAPON || ItemCache[itemid][iType] == ITEM_INHIBITOR || ItemCache[itemid][iType] == ITEM_PAINT)
						                {
											if(ItemCache[itemid][iValue1] == GetPlayerWeaponID(i))
											{
											    weapon_found = true;
											    break;
											}
						                }
									}
					            }
					        
					            if(weapon_found == false)
					            {
									new weapon_id = GetPlayerWeaponID(i), weapon_name[32];
			    					GetWeaponName(weapon_id, weapon_name, sizeof(weapon_name));

									format(string, sizeof(string), "WeaponHack (weapID: %d, weapName: %s).", weapon_id, weapon_name);
									GivePlayerPunish(i, INVALID_PLAYER_ID, PUNISH_BAN, string, 365, 0);
									continue;
								}
					        }
						}
					}
				}

				// Anty UnFreeze
				if(PlayerCache[i][pFreeze] == -1)
				{
				    if(GetPlayerState(i) != PLAYER_STATE_PASSENGER)
				    {
						if(!IsPlayerInRangeOfPoint(i, 2.5, PlayerCache[i][pPosX], PlayerCache[i][pPosY], PlayerCache[i][pPosZ]))
						{
						    if(GetPlayerSpeed(i, true) >= 5 && PlayerCache[i][pCheckPos])
						    {
						        if(uda > 0 || uda < 0 || lra > 0 || lra < 0)
						        {
							        GivePlayerPunish(i, INVALID_PLAYER_ID, PUNISH_KICK, "UnFreeze.", 0, 0);
									continue;
								}
						    }
						}
					}
				}

				// Anty JetPack
				if(GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK)
				{
					GivePlayerPunish(i, INVALID_PLAYER_ID, PUNISH_BAN, "JetPack.", 365, 0);
					continue;
				}

				// Anty SpectateHack
				if(GetPlayerState(i) == PLAYER_STATE_SPECTATING && PlayerCache[i][pSpectate] == INVALID_PLAYER_ID)
				{
				    GivePlayerPunish(i, INVALID_PLAYER_ID, PUNISH_KICK, "SpectateHack.", 0, 0);
					continue;
				}
			}
	        
	        PlayerCache[i][pPosX] = PosX;
	        PlayerCache[i][pPosY] = PosY;
	        PlayerCache[i][pPosZ] = PosZ;
	        
	        if(!PlayerCache[i][pCheckWeapon])	PlayerCache[i][pCheckWeapon] = true;
	        if(!PlayerCache[i][pCheckPos])   	PlayerCache[i][pCheckPos] = true;
	        
			PlayerCache[i][pStatus] = GetPlayerStatus(i);
	        if(PlayerCache[i][pStatus] != status)	UpdatePlayerStatus(i);
	    }
	}
	return 1;
}

timer KillTalkingAnimation[1000](playerid)
{
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

timer OnDestroyReasonLabel[1000](label_id)
{
	DestroyDynamic3DTextLabel(Text3D:label_id);
	return 1;
}

timer OnVehicleEngineStarted[1000](vehicleid)
{
	new playerid = GetVehicleDriver(vehicleid);
	if(playerid == INVALID_PLAYER_ID)
	{
	    return 1;
	}
	if(GetVehicleEngineStatus(vehicleid) == 1)
	{
	    return 1;
	}
	if(CarInfo[vehicleid][cFuel] <= 0)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W tym poje�dzie nie ma paliwa.\nZatankuj pojazd, aby m�c odpali� silnik.");
	    return 1;
	}
	ChangeVehicleEngineStatus(vehicleid, true);
	TD_ShowSmallInfo(playerid, 3, "Silnik zostal ~g~uruchomiony ~w~pomyslnie.");
	
	printf("[cars] %s (UID: %d, GID: %d) odpali� silnik pojazdu %s (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], GetVehicleName(CarInfo[vehicleid][cModel]), CarInfo[vehicleid][cUID]);
	return 1;
}

timer OnResetPlayerNameTagColor[1000](playerid)
{
    Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pNameTag], E_STREAMER_COLOR, PlayerCache[playerid][pNickColor]);
	return 1;
}

timer OnToggleVehicleAlarm[1000](vehicleid)
{
	if(GetVehicleAlarmStatus(vehicleid) == 1)	ChangeVehicleAlarmStatus(vehicleid, false);
	return 1;
}

timer OnKickPlayer[50](playerid)
{
	Kick(playerid);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(PlayerCache[playerid][pLogged])
	{
	    SpawnPlayer(playerid);
	    return 1;
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	// Zeruj cache
	PlayerCache[playerid][pUID] 					= 0;
	PlayerCache[playerid][pGID] 					= 0;
	
	PlayerCache[playerid][pHours]           		= 0;
	PlayerCache[playerid][pMinutes]         		= 0;
	
	PlayerCache[playerid][pAdmin]       			= 0;
	PlayerCache[playerid][pPoints]                  = 0;
	
	PlayerCache[playerid][pCash]            		= 0;
	PlayerCache[playerid][pBankCash]        		= 0;
	
	PlayerCache[playerid][pPhoneNumber]             = 0;
	PlayerCache[playerid][pBankNumber]              = 0;
	
	PlayerCache[playerid][pNickColor]				= COLOR_BLACK;
	PlayerCache[playerid][pPremium]     			= 0;
	
	PlayerCache[playerid][pSkin]        			= 0;
	PlayerCache[playerid][pHealth]      			= 0;
	
	PlayerCache[playerid][pSex]         			= 0;
	PlayerCache[playerid][pBirth]       			= 0;
	
	PlayerCache[playerid][pPosX]            		= 0.0;
	PlayerCache[playerid][pPosY]            		= 0.0;
	PlayerCache[playerid][pPosZ]           	 		= 0.0;
	
	PlayerCache[playerid][pVirtualWorld]    		= 0;
	PlayerCache[playerid][pInteriorID]      		= 0;
	
	PlayerCache[playerid][pBlock]           		= 0;
	PlayerCache[playerid][pCrash]          	 		= 0;
	
	PlayerCache[playerid][pArrest]                  = 0;
	
	PlayerCache[playerid][pBW]                      = 0;
	PlayerCache[playerid][pAJ]                      = 0;
	
	PlayerCache[playerid][pHouse]                   = 0;
	PlayerCache[playerid][pJob]                     = JOB_NONE;
	
	PlayerCache[playerid][pDocuments]               = 0;
	
	PlayerCache[playerid][pPDP]                     = 0;
	PlayerCache[playerid][pWarns]                   = 0;
	
	PlayerCache[playerid][pStrength]                = 3500;
	PlayerCache[playerid][pDepend]                  = 0.0;
	
	PlayerCache[playerid][pAudioHandle]             = 0;
	PlayerCache[playerid][pStatus]                  = 0;
	
	PlayerCache[playerid][pTaxiVeh]                 = INVALID_VEHICLE_ID;
	PlayerCache[playerid][pTaxiPay]                 = 0;
	PlayerCache[playerid][pTaxiPrice]               = 0;
	PlayerCache[playerid][pTaxiPassenger]           = INVALID_PLAYER_ID;
	
	PlayerCache[playerid][pRepairVeh]               = INVALID_VEHICLE_ID;
	PlayerCache[playerid][pRepairTime]              = 0;
	
	PlayerCache[playerid][pSprayVeh]                = INVALID_VEHICLE_ID;
	PlayerCache[playerid][pSprayTime]               = 0;
	PlayerCache[playerid][pSprayColor][0]           = 0;
	PlayerCache[playerid][pSprayColor][1]           = 0;
	PlayerCache[playerid][pSprayType]               = SPRAY_TYPE_NONE;
	
	PlayerCache[playerid][pMontageVeh]              = INVALID_VEHICLE_ID;
	PlayerCache[playerid][pMontageItem]             = 0;
	PlayerCache[playerid][pMontageTime]             = 0;
	
	PlayerCache[playerid][pCuffedTo]                = INVALID_PLAYER_ID;
	PlayerCache[playerid][pCallingTo]               = INVALID_PLAYER_ID;
	
	PlayerCache[playerid][pCreatingArea]            = INVALID_AREA_ID;
	PlayerCache[playerid][pCurrentArea]             = INVALID_AREA_ID;
	
	PlayerCache[playerid][pEditObject]              = INVALID_OBJECT_ID;
	PlayerCache[playerid][pEdit3DText]              = INVALID_3DTEXT_ID;
	
	PlayerCache[playerid][pRadioLive]               = false;
	PlayerCache[playerid][pRadioInterview]          = INVALID_PLAYER_ID;
	
	PlayerCache[playerid][pSelectAccess]            = INVALID_ACCESS_ID;
	PlayerCache[playerid][pSelectSkin]              = INVALID_SKIN_ID;
	PlayerCache[playerid][pSelectTalkStyle]         = false;
	
	PlayerCache[playerid][pItemWeapon]              = INVALID_ITEM_ID;
	PlayerCache[playerid][pItemPlayer]              = INVALID_ITEM_ID;
	PlayerCache[playerid][pItemPass]                = INVALID_ITEM_ID;
	PlayerCache[playerid][pItemMask]                = INVALID_ITEM_ID;
	PlayerCache[playerid][pItemBoombox]             = INVALID_ITEM_ID;
	
	PlayerCache[playerid][pCheckWeapon]             = false;
	PlayerCache[playerid][pCheckPos]             	= false;
	
	PlayerCache[playerid][pSearches]                = INVALID_PLAYER_ID;
	PlayerCache[playerid][pSearchTime]            	= 0;
	
	PlayerCache[playerid][pLesson]                  = INVALID_GROUP_ID;
	PlayerCache[playerid][pLessonTime]              = 0;
	
	PlayerCache[playerid][pHealing]                 = INVALID_PLAYER_ID;
	
	PlayerCache[playerid][pSpectate]                = INVALID_PLAYER_ID;
	PlayerCache[playerid][pPackage]                 = INVALID_PACKAGE_ID;
	
	PlayerCache[playerid][pTalkStyle]               = 0;
	PlayerCache[playerid][pWalkStyle]               = 0;
	PlayerCache[playerid][pFightStyle]              = 0;
	
	PlayerCache[playerid][pGymObject]               = INVALID_OBJECT_ID;
	PlayerCache[playerid][pGymRepeat]               = 0;
	PlayerCache[playerid][pGymTime]                 = 0;

	PlayerCache[playerid][pBusStart]                = INVALID_OBJECT_ID;
	PlayerCache[playerid][pBusTravel]               = INVALID_OBJECT_ID;
	PlayerCache[playerid][pBusTime]                 = 0;
	PlayerCache[playerid][pBusPrice]                = 0;
	PlayerCache[playerid][pBusRide]                 = false;
	
	PlayerCache[playerid][pDrugType]                = DRUG_NONE;
	PlayerCache[playerid][pDrugLevel]               = 0;
	
	PlayerCache[playerid][pDrugValue1]              = 0;
	PlayerCache[playerid][pDrugValue2]              = 0;
	
	PlayerCache[playerid][pDeathKiller]             = 0;
	PlayerCache[playerid][pDeathWeapon]             = 0;
	PlayerCache[playerid][pDeathType]               = 0;
	
	PlayerCache[playerid][pBasketObject]            = INVALID_OBJECT_ID;
	PlayerCache[playerid][pBasketBall]              = INVALID_OBJECT_ID;
	
	PlayerCache[playerid][pTaggingObject]           = INVALID_OBJECT_ID;
	PlayerCache[playerid][pTaggingTime]             = 0;
	
	PlayerCache[playerid][pRaceCreating]            = false;
	PlayerCache[playerid][pRaceCheckpoints]         = 0;
	
	PlayerCache[playerid][pLogTries]        		= 3;
	
	PlayerCache[playerid][pLastVeh]                 = INVALID_VEHICLE_ID;
	PlayerCache[playerid][pLastW]                   = INVALID_PLAYER_ID;
	PlayerCache[playerid][pLastReport]              = 0;
	PlayerCache[playerid][pLastMileage]             = 0;
	
	PlayerCache[playerid][pAFK]                     = -5;
	PlayerCache[playerid][pOOC]                     = true;
	
	PlayerCache[playerid][pDutyGroup]       		= 0;
	PlayerCache[playerid][pDutyAdmin]       		= 0;
	
	PlayerCache[playerid][pMainTable]       		= 0;
	PlayerCache[playerid][pManageItem]              = 0;
	
	PlayerCache[playerid][pSmallTextTime]    		= 0;
	PlayerCache[playerid][pLargeTextTime]           = 0;
	
	PlayerCache[playerid][pAchieveInfoTime]         = 0;
	
	PlayerCache[playerid][pFreeze]                  = 0;
	
	PlayerCache[playerid][pMainGroupSlot]           = INVALID_SLOT_ID;
	
	PlayerCache[playerid][pRoll]                    = false;
	PlayerCache[playerid][pBelts]                   = false;
	PlayerCache[playerid][pGlove]                   = false;
	PlayerCache[playerid][pFlashLight]              = false;
	
	PlayerCache[playerid][pLogged]      			= false;
	PlayerCache[playerid][pSpawned]     			= false;
	PlayerCache[playerid][pBanned]                  = false;

 	PlayerCache[playerid][pCheckpoint]              = CHECKPOINT_NONE;
	
	PlayerCache[playerid][pTogW]                    = false;
	
	PlayerCache[playerid][pSession][SESSION_GAME] 	= 0;
	PlayerCache[playerid][pSession][SESSION_GROUP]  = 0;
	PlayerCache[playerid][pSession][SESSION_ADMIN]  = 0;
	PlayerCache[playerid][pSession][SESSION_AFK]    = 0;
	
	PlayerCache[playerid][pFirstPersonObject]       = INVALID_OBJECT_ID;
	
	// Wyczy�� sloty grup
	for (new slot = 0; slot < MAX_GROUP_SLOTS; slot++)
	{
		PlayerGroup[playerid][slot][gpUID] 		= 0;
		PlayerGroup[playerid][slot][gpID] 		= 0;

		PlayerGroup[playerid][slot][gpPerm]		= 0;

		PlayerGroup[playerid][slot][gpPayment]	= 0;
		PlayerGroup[playerid][slot][gpSkin]    	= 0;
		
		PlayerGroup[playerid][slot][gpTogG]     = false;
	}
	
	OfferData[playerid][oCustomerID] 			= INVALID_PLAYER_ID;
	OfferData[playerid][oType] 					= 0;

	OfferData[playerid][oValue1] 				= 0;
	OfferData[playerid][oValue2] 				= 0;

	OfferData[playerid][oPrice] 				= 0;
	OfferData[playerid][oPayType] 				= PAY_TYPE_NONE;
	
	RaceInfo[playerid][rOwner]                  = INVALID_PLAYER_ID;
	RaceInfo[playerid][rStart]                  = 0;

	RaceInfo[playerid][rPoint]                  = 0;
	RaceInfo[playerid][rTime]                   = 0;
	
	RaceInfo[playerid][rPosition]               = 0;
	
	TD_CreateForPlayer(playerid);
	
	SetPlayerVirtualWorld(playerid, playerid + 1000);
	SetPlayerColor(playerid, PlayerCache[playerid][pNickColor]);
	
	// Ignorowanie
	for (new i = 0; i < MAX_PLAYERS; i++)	PlayerCache[playerid][pIgnored][i] = false;
	
	strmid(PlayerCache[playerid][pCharName], PlayerOriginalName(playerid), 0, MAX_PLAYER_NAME);
	new ORM:orm_id = PlayerCache[playerid][pOrm] = orm_create(""SQL_PREF"characters");
	
	orm_addvar_int(orm_id, PlayerCache[playerid][pUID], "char_uid");
	orm_addvar_int(orm_id, PlayerCache[playerid][pGID], "char_gid");

	orm_addvar_string(orm_id, PlayerCache[playerid][pCharName], 32, "char_name");

    orm_addvar_int(orm_id, PlayerCache[playerid][pHours], "char_hours");
	orm_addvar_int(orm_id, PlayerCache[playerid][pMinutes], "char_minutes");

	orm_addvar_int(orm_id, PlayerCache[playerid][pCash], "char_cash");
    orm_addvar_int(orm_id, PlayerCache[playerid][pBankCash], "char_bankcash");

    orm_addvar_int(orm_id, PlayerCache[playerid][pBankNumber], "char_banknumber");

    orm_addvar_int(orm_id, PlayerCache[playerid][pSkin], "char_skin");
    orm_addvar_float(orm_id, PlayerCache[playerid][pHealth], "char_health");

    orm_addvar_int(orm_id, PlayerCache[playerid][pSex], "char_sex");
    orm_addvar_int(orm_id, PlayerCache[playerid][pBirth], "char_birth");

    orm_addvar_float(orm_id, PlayerCache[playerid][pPosX], "char_posx");
    orm_addvar_float(orm_id, PlayerCache[playerid][pPosY], "char_posy");
    orm_addvar_float(orm_id, PlayerCache[playerid][pPosZ], "char_posz");

    orm_addvar_int(orm_id, PlayerCache[playerid][pVirtualWorld], "char_world");
    orm_addvar_int(orm_id, PlayerCache[playerid][pInteriorID], "char_interior");

    orm_addvar_int(orm_id, PlayerCache[playerid][pBlock], "char_block");
    orm_addvar_int(orm_id, PlayerCache[playerid][pCrash], "char_crash");
    orm_addvar_int(orm_id, PlayerCache[playerid][pArrest], "char_arrest");

    orm_addvar_int(orm_id, PlayerCache[playerid][pStrength], "char_strength");
    orm_addvar_float(orm_id, PlayerCache[playerid][pDepend], "char_depend");

    orm_addvar_int(orm_id, PlayerCache[playerid][pBW], "char_bw");
    orm_addvar_int(orm_id, PlayerCache[playerid][pAJ], "char_aj");

    orm_addvar_int(orm_id, PlayerCache[playerid][pHouse], "char_house");
    orm_addvar_int(orm_id, PlayerCache[playerid][pJob], "char_job");

    orm_addvar_int(orm_id, PlayerCache[playerid][pDocuments], "char_documents");
    orm_addvar_int(orm_id, PlayerCache[playerid][pAchievements], "char_achieve");

    orm_addvar_int(orm_id, PlayerCache[playerid][pTalkStyle], "char_talkstyle");
    orm_addvar_int(orm_id, PlayerCache[playerid][pWalkStyle], "char_walkstyle");
    orm_addvar_int(orm_id, PlayerCache[playerid][pFightStyle], "char_fightstyle");

    orm_addvar_int(orm_id, PlayerCache[playerid][pOOC], "char_ooc");
    orm_addvar_int(orm_id, PlayerCache[playerid][pLastSkin], "char_lastskin");

    orm_addvar_float(orm_id, PlayerCache[playerid][pMileage], "char_mileage");
    orm_setkey(orm_id, "char_name");
    
    orm_select(orm_id, "OnPlayerLogin", "d", playerid);
	return 1;
}

public OnPlayerLogin(playerid)
{
	new ORM:orm_id = PlayerCache[playerid][pOrm];
	switch(orm_errno(orm_id))
	{
 		case ERROR_OK:
 		{
 		    new Cache:login_password, query[256];
 		    
 		    orm_apply_cache(orm_id, 0);
 		    orm_setkey(orm_id, "char_uid");
 		    
 		    format(query, sizeof(query), "SELECT `members_pass_hash` FROM `core_members` WHERE member_id = '%d' LIMIT 1", PlayerCache[playerid][pGID]);
 			login_password = mysql_query(connHandle, query);
 			
			cache_get_row(0, 0, PlayerCache[playerid][pPassword], connHandle, 128);
			cache_delete(login_password);
			
            PlayerCache[playerid][pSession][SESSION_LOGIN] = gettime();
			
			ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Panel logowania", "Witaj na "SERVER_NAME"!\n\nWprowad� poni�ej has�o do postaci, by rozpocz�� gr� na naszym serwerze.\nUpewnij si�, �e posta� zosta�a za�o�ona na naszej stronie "WEB_URL".", "Zaloguj", "Zmie� nick");

		}
 	 	case ERROR_NO_DATA:
  		{
            ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Panel logowania", "Witaj na "SERVER_NAME"!\n\nWprowad� poni�ej has�o do postaci, by rozpocz�� gr� na naszym serwerze.\nUpewnij si�, �e posta� zosta�a za�o�ona na naszej stronie "WEB_URL".", "Zaloguj", "Zmie� nick");
            TD_ShowSmallInfo(playerid, 5, "Postac ~r~nie istnieje ~w~w bazie danych lub wprowadzone haslo jest nieprawidlowe.");
		}
	}
	return 1;
}

public OnPlayerPasswordChecked(playerid)
{
	new bool:match = bcrypt_is_equal();
	
	if(match == true)
	{
	    new string[256];
		LoadPlayerBans(playerid);

		// Je�li zbanowany
		if(PlayerCache[playerid][pBanned])
		{
		    return 1;
		}

		// Je�li zablokowane konto
		if(PlayerCache[playerid][pBlock] & BLOCK_CHAR)
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Ta posta� zosta�a zablokowana, pow�d znajdziesz w panelu na stronie.\nZa�� now� lub ubiegaj si� o odblokowanie poprzedniej.");
		    defer OnKickPlayer(playerid);
		    return 1;
		}

		if(PlayerCache[playerid][pPremium] > gettime())
	 	{
			SetPlayerColor(playerid, COLOR_WHITE);
			TextDrawShowForPlayer(playerid, TextDrawPremium);
		}
		else
		{
			SetPlayerColor(playerid, COLOR_NICK);
		}

		SetPlayerScore(playerid, PlayerCache[playerid][pPoints]);
	    PlayerCache[playerid][pNickColor] = COLOR_NICK;

		format(string, sizeof(string), "%s (%d)", PlayerName(playerid), playerid);
		UpdateDynamic3DTextLabelText(Text3D:PlayerCache[playerid][pNameTag], PlayerCache[playerid][pNickColor], string);

		Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pNameTag], E_STREAMER_ATTACHED_PLAYER, playerid);

		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pNameTag], E_STREAMER_Z, 0.15);
		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pNameTag], E_STREAMER_DRAW_DISTANCE, 15.0);

		UpdateDynamic3DTextLabelText(Text3D:PlayerCache[playerid][pDescTag], COLOR_PURPLE, " ");

		Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pDescTag], E_STREAMER_ATTACHED_PLAYER, playerid);
		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pDescTag], E_STREAMER_DRAW_DISTANCE, 10.0);

	    ResetPlayerWeaponsEx(playerid);

		SetPlayerFightingStyle(playerid, PlayerCache[playerid][pFightStyle]);
		for(new w = 0; (w < 10) && (w != 7 && w != 8 && w != 9); w++)	SetPlayerSkillLevel(playerid, w, 1);

	    LoadPlayerGroups(playerid);
		LoadPlayerItems(playerid);

		TextDrawShowForPlayer(playerid, Text:TextDrawServerLogo);
		TextDrawShowForPlayer(playerid, Text:TextDrawNews);

	    ClearPlayerChat(playerid);
		SendClientFormatMessage(playerid, COLOR_WHITE, "Witaj, {AFAFAF}%s (GID: %d){FFFFFF}. Zosta�e� zalogowany na posta� {AFAFAF}%s (UID: %d){FFFFFF}. �yczymy mi�ej gry!", PlayerCache[playerid][pGlobName], PlayerCache[playerid][pGID], PlayerName(playerid), PlayerCache[playerid][pUID]);

		TogglePlayerSpectating(playerid, false);
		SetSpawnInfo(playerid, 0, 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);

		SpawnPlayer(playerid);
		
	    PlayerCache[playerid][pLogged] = true;

		PlayerCache[playerid][pSession][SESSION_LOGIN] 	= 0;
		PlayerCache[playerid][pSession][SESSION_GAME] 	= gettime();

		PlayerCache[playerid][pAFK] = -3;

		//gpci(playerid, string, sizeof(string));
	 	printf("[part] %s (UID: %d, GID: %d, SERIAL: %s) zalogowa� si� pomy�lnie (%d/3).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], string, PlayerCache[pLogTries]);

		PlayerCache[playerid][pSession][SESSION_GAME] = gettime();
	   	mysql_query_format("INSERT INTO `"SQL_PREF"logged_players` VALUES ('%d', '%d', '%d')", PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], PlayerCache[playerid][pSession][SESSION_GAME]);

		// 24/7 Pershing Square
		RemoveBuildingForPlayer(playerid, 4051, 1371.8203, -1754.8203, 19.0469, 0.25);
		RemoveBuildingForPlayer(playerid, 4191, 1353.2578, -1764.5313, 15.5938, 0.25);
		RemoveBuildingForPlayer(playerid, 4022, 1353.2578, -1764.5313, 15.5938, 0.25);
		RemoveBuildingForPlayer(playerid, 1532, 1353.1328, -1759.6563, 12.5000, 0.25);
		RemoveBuildingForPlayer(playerid, 4021, 1371.8203, -1754.8203, 19.0469, 0.25);

		// Bloki SC
		RemoveBuildingForPlayer(playerid, 3562, 2326.6094, -1712.1641, 15.3047, 0.25);
		RemoveBuildingForPlayer(playerid, 3559, 2384.9453, -1708.7656, 15.5078, 0.25);
		RemoveBuildingForPlayer(playerid, 17935, 2401.2656, -1708.3828, 14.9766, 0.25);
		RemoveBuildingForPlayer(playerid, 3582, 2326.6094, -1712.1641, 15.3047, 0.25);
		RemoveBuildingForPlayer(playerid, 3558, 2384.9453, -1708.7656, 15.5078, 0.25);
		RemoveBuildingForPlayer(playerid, 17934, 2401.2656, -1708.3828, 14.9766, 0.25);

		// Idlewood
		RemoveBuildingForPlayer(playerid, 1412, 1917.3203, -1797.4219, 13.8125, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1912.0547, -1797.4219, 13.8125, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1906.7734, -1797.4219, 13.8125, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1927.8516, -1797.4219, 13.8125, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1922.5859, -1797.4219, 13.8125, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1938.3906, -1797.4219, 13.8125, 0.25);

		// Bloki
		RemoveBuildingForPlayer(playerid, 4226, 1359.2813, -1796.4688, 24.3438, 0.25);
		RemoveBuildingForPlayer(playerid, 4023, 1359.2813, -1796.4688, 24.3438, 0.25);

		// Dystrybutory Idlewood
		RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1778.4531, 14.1406, 0.25);
	 	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1774.3125, 14.1406, 0.25);
	 	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1771.3438, 14.1406, 0.25);
	 	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1767.2891, 14.1406, 0.25);

		// Unity Station
		RemoveBuildingForPlayer(playerid, 4025, 1777.8359, -1773.9063, 12.5234, 0.25);
		RemoveBuildingForPlayer(playerid, 4215, 1777.5547, -1775.0391, 36.7500, 0.25);
		RemoveBuildingForPlayer(playerid, 4019, 1777.8359, -1773.9063, 12.5234, 0.25);
	}
	else
	{
 		ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Panel logowania", "Witaj na "SERVER_NAME"!\n\nWprowad� poni�ej has�o do postaci, by rozpocz�� gr� na naszym serwerze.\nUpewnij si�, �e posta� zosta�a za�o�ona na naszej stronie "WEB_URL".", "Zaloguj", "Zmie� nick");
 		TD_ShowSmallInfo(playerid, 5, "Postac ~r~nie istnieje ~w~w bazie danych lub wprowadzone haslo jest nieprawidlowe.");
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    ResetPlayerWeaponsEx(playerid);
	if(!PlayerCache[playerid][pLogged])
	{
	    return 1;
	}
	
	new string[256], virtual_world, interior_id,
		Float:PosX, Float:PosY, Float:PosZ;
		
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	
	virtual_world = GetPlayerVirtualWorld(playerid);
	interior_id = GetPlayerInterior(playerid);
	
	switch(reason)
	{
	    case 0:
	    {
	    	format(string, sizeof(string), "(( %s - timeout ))", PlayerRealName(playerid));
			GetPlayerPos(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]);

			PlayerCache[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
			PlayerCache[playerid][pInteriorID] = GetPlayerInterior(playerid);

			PlayerCache[playerid][pCrash] = gettime();
			OnPlayerSave(playerid, SAVE_PLAYER_POS);
	    }
	    case 1: format(string, sizeof(string), "(( %s - /q ))", PlayerRealName(playerid));
	}
	
	new Text3D:reason_label = CreateDynamic3DTextLabel(string, 0xB4B5B788, PosX, PosY, PosZ + 0.3, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, virtual_world, interior_id);
	defer OnDestroyReasonLabel[15000](_:reason_label);
	
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
     		// Oferta
	        if(OfferData[i][oCustomerID] == playerid)
	        {
	            OnPlayerRejectOffer(playerid, i);
	        }
	        
	        // Je�li skuty
	        if(PlayerCache[i][pCuffedTo] == playerid)
	        {
	            PlayerCache[i][pCuffedTo] = INVALID_PLAYER_ID;
	        }
	        
	        // Je�li rozmawia
	        if(PlayerCache[i][pCallingTo] == playerid)
	        {
      			PlayerCache[i][pCallingTo] = INVALID_PLAYER_ID;

				SetPlayerSpecialAction(i, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(i, SLOT_PHONE);

				SendClientMessage(i, COLOR_YELLOW, "Rozmowa zosta�a pomy�lnie zako�czona.");
	        }
	        
	        // Kierowca taxi
	        if(PlayerCache[playerid][pTaxiPassenger] == i)
	        {
				new price = PlayerCache[i][pTaxiPay];
				if(price > 0 && PlayerCache[i][pCash] >= price)
				{
 					new group_cash = floatround(0.90 * price),
						playercash = floatround(0.10 * price);

		    		crp_GivePlayerMoney(i, -price);
		      		crp_GivePlayerMoney(playerid, playercash);

					new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);

		   			GroupData[group_id][gCash] += group_cash;
					SaveGroup(group_id);
				}
	        }
	    }
	}
	
	new doorid = GetPlayerDoorID(playerid);
	if(doorid == INVALID_DOOR_ID)
	{
		new	Float:DoorDistance,
			Float:LastDistance = 8000.0;
			
		foreach(new d : Door)
		{
		    if(DoorCache[d][dEnterVW] == 0)
		    {
	  			if((DoorCache[d][dOwnerType] == OWNER_PLAYER && DoorCache[d][dOwner] == PlayerCache[playerid][pUID]))
	  			{
	          		DoorDistance = GetPlayerDistanceToPoint(playerid, DoorCache[d][dEnterX], DoorCache[d][dEnterY]);

					if((DoorDistance < LastDistance))
					{
						LastDistance = DoorDistance;
						PlayerCache[playerid][pHouse] = DoorCache[d][dUID];
					}
				}
				else if(DoorCache[d][dOwnerType] == OWNER_GROUP)
				{
				    if(IsPlayerInGroup(playerid, DoorCache[d][dOwner]))
				    {
				        if((GroupData[GetPlayerGroupID(playerid, DoorCache[d][dOwner])][gFlags] & G_FLAG_SPAWN) && (PlayerGroup[playerid][GetPlayerGroupSlot(playerid, DoorCache[d][dOwner])][gpPerm] & G_PERM_DOORS))
						{
			   				DoorDistance = GetPlayerDistanceToPoint(playerid, DoorCache[d][dEnterX], DoorCache[d][dEnterY]);

							if((DoorDistance < LastDistance))
							{
								LastDistance = DoorDistance;
								PlayerCache[playerid][pHouse] = DoorCache[d][dUID];
							}
						}
				    }
				}
			}
		}
	}
	else
	{
		if((DoorCache[doorid][dOwnerType] == OWNER_PLAYER && DoorCache[doorid][dOwner] == PlayerCache[playerid][pUID]))
		{
			PlayerCache[playerid][pHouse] = DoorCache[doorid][dUID];
		}
		else if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
		{
  			if(IsPlayerInGroup(playerid, DoorCache[doorid][dOwner]))
	    	{
				if((GroupData[GetPlayerGroupID(playerid, DoorCache[doorid][dOwner])][gFlags] & G_FLAG_SPAWN) && (PlayerGroup[playerid][GetPlayerGroupSlot(playerid, DoorCache[doorid][dOwner])][gpPerm] & G_PERM_DOORS))
				{
    				PlayerCache[playerid][pHouse] = DoorCache[doorid][dUID];
				}
    		}
		}
	}
	
	// Ostatni pojazd
	if(PlayerCache[playerid][pLastVeh] != INVALID_VEHICLE_ID)
	{
	    new vehid = PlayerCache[playerid][pLastVeh];
	    if(Iter_Contains(Vehicles, vehid))
	    {
	        new driverid = GetVehicleDriver(vehid);
		    if(driverid == INVALID_PLAYER_ID || driverid == playerid)
		    {
				CarInfo[vehid][cLocked] = true;
	  			SetVehicleLock(vehid, CarInfo[vehid][cLocked]);

                CarInfo[vehid][cLastUsing] = gettime();
				ChangeVehicleEngineStatus(vehid, false);
		    }
			SaveVehicle(vehid, SAVE_VEH_COUNT | SAVE_VEH_LOCK);
		}
		
		// GPS
		if(CarInfo[vehid][cGPS])	for(new icon_id = 0; icon_id < 100; icon_id++) RemovePlayerMapIcon(playerid, icon_id);
 	}
 	
 	// Pasa�er w taxi
 	if(PlayerCache[playerid][pTaxiVeh] != INVALID_VEHICLE_ID)
 	{
		new driverid = GetVehicleDriver(PlayerCache[playerid][pTaxiVeh]),
			price = PlayerCache[playerid][pTaxiPay];

		if(price > 0 && PlayerCache[playerid][pCash] >= price)
  		{
  			new group_cash = floatround(0.90 * price),
				playercash = floatround(0.10 * price);

    		crp_GivePlayerMoney(playerid, -price);
      		crp_GivePlayerMoney(driverid, playercash);

			new group_id = GetPlayerGroupID(driverid, PlayerCache[driverid][pDutyGroup]);

   			GroupData[group_id][gCash] += group_cash;
			SaveGroup(group_id);

			ShowPlayerInfoDialog(driverid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\nNa konto grupy dodano: $%d", playercash, group_cash);
		}
		
		PlayerCache[driverid][pTaxiPassenger] = INVALID_PLAYER_ID;
 	}
 	
	// Zako�cz transmisje na �ywo
	if(PlayerCache[playerid][pRadioLive])	TextDrawSetString(Text:TextDrawNews, "~y~~h~LSN ~w~~>~ Brak sygnalu nadawania.");

	// Zako�cz wywiad
	if(PlayerCache[playerid][pRadioInterview] != INVALID_PLAYER_ID)
	{
	    new interviewer_id = PlayerCache[playerid][pRadioInterview];
		PlayerCache[interviewer_id][pRadioInterview] = INVALID_PLAYER_ID;
		
		TextDrawSetString(Text:TextDrawNews, "~y~~h~LSN ~w~~>~ Brak sygnalu nadawania.");
		ShowPlayerInfoDialog(interviewer_id, D_TYPE_INFO, "Wywiad zosta� zako�czony.");
	}
	
	// 3dTekst naprawy
	if(PlayerCache[playerid][pRepairVeh] != INVALID_VEHICLE_ID)
	{
	    DestroyDynamic3DTextLabel(Text3D:PlayerCache[playerid][pRepairTag]);
	}
	
	// 3dTekst lakierowania
	if(PlayerCache[playerid][pSprayVeh] != INVALID_VEHICLE_ID)
	{
	    DestroyDynamic3DTextLabel(Text3D:PlayerCache[playerid][pSprayTag]);
	}
 	
 	// Zapisz amunicj�
 	if(PlayerCache[playerid][pItemWeapon] != INVALID_ITEM_ID)
 	{
		new itemid = PlayerCache[playerid][pItemWeapon];
		SaveItem(itemid, SAVE_ITEM_VALUES);
 	}
 	
 	// Zapisz karnet
 	if(PlayerCache[playerid][pItemPass] != INVALID_ITEM_ID)
 	{
 	    new itemid = PlayerCache[playerid][pItemPass];
 	    ItemCache[itemid][iValue1] = PlayerCache[playerid][pGymTime] / 60;
 	    
 	    SaveItem(itemid, SAVE_ITEM_VALUES);
 	}
 	
 	// Maska
 	if(PlayerCache[playerid][pItemMask] != INVALID_ITEM_ID)
 	{
 	    new itemid = PlayerCache[playerid][pItemMask];
		ItemCache[itemid][iValue1] --;
		
		if(ItemCache[itemid][iValue1] > 0)	SaveItem(itemid, SAVE_ITEM_VALUES);
		else								DeleteItem(itemid);
 	}
 	
 	// Boombox
 	if(PlayerCache[playerid][pItemBoombox] != INVALID_ITEM_ID)
 	{
		new areaid = PlayerCache[playerid][pCurrentArea];
		foreach(new i : Player)
		{
			if(i != playerid)
   			{
				if(PlayerCache[i][pCurrentArea] == areaid)
				{
	   				Audio_Stop(i, PlayerCache[playerid][pAudioHandle]);
				    PlayerCache[i][pAudioHandle] = 0;
				}
			}
		}
		strmid(AreaCache[areaid][aAudioURL], "", 0, 0, 64);
 	}
 	
 	// Kosz
 	if(PlayerCache[playerid][pBasketObject] != INVALID_OBJECT_ID)
 	{
 	    new object_id = PlayerCache[playerid][pBasketBall];
 	    DestroyDynamicObject(object_id);
 	}

	mysql_query_format("DELETE FROM `"SQL_PREF"logged_players` WHERE char_uid = '%d'", PlayerCache[playerid][pUID]);
    UnloadPlayerItems(playerid);

	// Aktualizuj sesje
	if(PlayerCache[playerid][pDutyAdmin])
	{
	    UpdatePlayerSession(playerid, SESSION_ADMIN, 0);
	}
	
	if(PlayerCache[playerid][pDutyGroup])
	{
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]),
			group_activity = (floatround((gettime() - PlayerCache[playerid][pSession][SESSION_GROUP]) / 60)) * 3;

		GroupData[group_id][gActivity] += group_activity;
		SaveGroup(group_id);
	
	    UpdatePlayerSession(playerid, SESSION_GROUP, PlayerCache[playerid][pDutyGroup]);
	}
	
	UpdatePlayerSession(playerid, SESSION_GAME, PlayerCache[playerid][pSession][SESSION_AFK]);
	OnPlayerSave(playerid, SAVE_PLAYER_BASIC);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(!PlayerCache[playerid][pLogged])
	{
		Kick(playerid);
	    return 1;
	}
	SetPlayerSpawn(playerid);
	LoadPlayerAccess(playerid);

	ResetPlayerWeaponsEx(playerid);
	PreloadPlayerAnimLib(playerid);
	return 1;
}

public SetPlayerSpawn(playerid)
{
	SetPlayerMoney(playerid, PlayerCache[playerid][pCash]);
	SetPlayerHealth(playerid, PlayerCache[playerid][pHealth]);
	
	SetPlayerSkin(playerid, (PlayerCache[playerid][pLastSkin] != 0) ? PlayerCache[playerid][pLastSkin] : PlayerCache[playerid][pSkin]);
	
	// Podgl�d
	if(PlayerCache[playerid][pSpectate] != INVALID_PLAYER_ID)
	{
	    TogglePlayerSpectating(playerid, false);
		crp_SetPlayerPos(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]);

		SetPlayerVirtualWorld(playerid, PlayerCache[playerid][pVirtualWorld]);
		SetPlayerInterior(playerid, PlayerCache[playerid][pInteriorID]);

		ResetPlayerCamera(playerid);
		OnPlayerFreeze(playerid, true, 3);

		PlayerCache[playerid][pSpectate] = INVALID_PLAYER_ID;
		TD_ShowSmallInfo(playerid, 3, "Podglad gracza zostal ~r~anulowany~w~.");
	    return 1;
	}
	
	// AdminJail
	if(PlayerCache[playerid][pAJ])
	{
		crp_SetPlayerPos(playerid, PosInfo[ADMIN_JAIL_POS][sPosX], PosInfo[ADMIN_JAIL_POS][sPosY], PosInfo[ADMIN_JAIL_POS][sPosZ]);

		SetPlayerInterior(playerid, PosInfo[ADMIN_JAIL_POS][sPosInterior]);
		SetPlayerVirtualWorld(playerid, playerid + 1000);
		
		ResetPlayerCamera(playerid);
	    return 1;
	}
	
	// BrutallyWounded
	if(PlayerCache[playerid][pBW] != 0)
	{
		crp_SetPlayerPos(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ] - 0.25);
		ApplyAnimation(playerid, "PED", "FLOOR_hit", 4.1, 0, 1, 1, 1, 1, true);
		
		SetPlayerVirtualWorld(playerid, PlayerCache[playerid][pVirtualWorld]);
		SetPlayerInterior(playerid, PlayerCache[playerid][pInteriorID]);
		
		OnPlayerFreeze(playerid, true, 0);

		SetPlayerCameraPos(playerid, PlayerCache[playerid][pPosX] + 3, PlayerCache[playerid][pPosY] + 4, PlayerCache[playerid][pPosZ] + 7);
		SetPlayerCameraLookAt(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ], CAMERA_CUT);
		return 1;
	}

	// Przywracanie pozycji
	if(PlayerCache[playerid][pCrash] != 0)
	{
	    if(PlayerCache[playerid][pCrash] + 600 <= gettime())
	    {
	        PlayerCache[playerid][pCrash] = 0;
	        TD_ShowSmallInfo(playerid, 10, "Minelo ponad ~r~10 minut ~w~od ostatniego zapisania pozycji. Zostales ~y~przywrocony ~w~na spawn wlasciwy.");
	        
	        SetPlayerSpawn(playerid);
	        return 1;
	    }
 		crp_SetPlayerPos(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]);

		SetPlayerVirtualWorld(playerid, PlayerCache[playerid][pVirtualWorld]);
		SetPlayerInterior(playerid, PlayerCache[playerid][pInteriorID]);
		
		PlayerCache[playerid][pCrash] = 0;
		OnPlayerFreeze(playerid, true, 3);
		
		ResetPlayerCamera(playerid);
		return 1;
	}
	
	// Areszt
	if(PlayerCache[playerid][pArrest] != 0)
	{
	    if(PlayerCache[playerid][pArrest] <= gettime())
	    {
	        PlayerCache[playerid][pArrest] = 0;
	        TD_ShowSmallInfo(playerid, 10, "Odsiadka w ~r~areszcie ~w~dobiegla konca. Zostales ~y~przywrocony ~w~na spawn wlasciwy.");
	        
	        SetPlayerSpawn(playerid);
	        return 1;
	    }
   		crp_SetPlayerPos(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]);

		SetPlayerVirtualWorld(playerid, PlayerCache[playerid][pVirtualWorld]);
		SetPlayerInterior(playerid, PlayerCache[playerid][pInteriorID]);

        OnPlayerFreeze(playerid, true, 3);
		ResetPlayerCamera(playerid);
		
		new	arrest_hours = floatround((PlayerCache[playerid][pArrest] - gettime()) / 3600, floatround_floor),
		    arrest_minutes = floatround((PlayerCache[playerid][pArrest] - gettime()) / 60, floatround_floor) % 60;
		    
		TD_ShowSmallInfo(playerid, 10, "Powracasz ~r~do punktu ~w~aresztowania!~n~Pozostalo: ~y~%d ~w~godz. ~y~%d ~w~min.", arrest_hours, arrest_minutes);
	    return 1;
	}
	
	// Spawn w domu/hotelu
	if(PlayerCache[playerid][pHouse])
	{
	    new doorid = GetDoorID(PlayerCache[playerid][pHouse]);
	    if(doorid != INVALID_DOOR_ID)
	    {
	        if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
	        {
	        	new group_id = GetGroupID(DoorCache[doorid][dOwner]);
		        if(GroupData[group_id][gType] == G_TYPE_HOTEL)
		        {
          			crp_SetPlayerPos(playerid, PosInfo[HOTEL_SPAWN_POS][sPosX], PosInfo[HOTEL_SPAWN_POS][sPosY], PosInfo[HOTEL_SPAWN_POS][sPosZ]);
          			SetPlayerFacingAngle(playerid, PosInfo[HOTEL_SPAWN_POS][sPosA]);
          			
          			SetPlayerInterior(playerid, PosInfo[HOTEL_SPAWN_POS][sPosInterior]);
          			SetPlayerVirtualWorld(playerid, PlayerCache[playerid][pUID]);
          			
          			ResetPlayerCamera(playerid);
          			TD_ShowSmallInfo(playerid, 5, "Uzyj komendy ~y~/pokoj wyjdz~w~, aby opuscic pokoj.");
          			return 1;
		        }
		        
		        if(!IsPlayerInGroup(playerid, DoorCache[doorid][dOwner]) || !(GroupData[group_id][gFlags] & G_FLAG_SPAWN) || !(PlayerGroup[playerid][GetPlayerGroupSlot(playerid, DoorCache[doorid][dOwner])][gpPerm] & G_PERM_DOORS))
		        {
		            PlayerCache[playerid][pHouse] = 0;
		            SetPlayerSpawn(playerid);
		  			return 1;
		        }
			}
			
			crp_SetPlayerPos(playerid, DoorCache[doorid][dExitX], DoorCache[doorid][dExitY], DoorCache[doorid][dExitZ]);
			SetPlayerFacingAngle(playerid, DoorCache[doorid][dExitA]);

			SetPlayerVirtualWorld(playerid, DoorCache[doorid][dExitVW]);
			SetPlayerInterior(playerid, DoorCache[doorid][dExitInt]);

			OnPlayerFreeze(playerid, true, 3);
			ResetPlayerCamera(playerid);
			return 1;
		}
		else
		{
		    PlayerCache[playerid][pHouse] = 0;
		    SetPlayerSpawn(playerid);
		}
	    return 1;
	}
	
	crp_SetPlayerPos(playerid, PosInfo[MAIN_SPAWN_POS][sPosX], PosInfo[MAIN_SPAWN_POS][sPosY], PosInfo[MAIN_SPAWN_POS][sPosZ]);
	SetPlayerFacingAngle(playerid, PosInfo[MAIN_SPAWN_POS][sPosA]);
	
	SetPlayerInterior(playerid, PosInfo[MAIN_SPAWN_POS][sPosInterior]);
	SetPlayerVirtualWorld(playerid, PosInfo[MAIN_SPAWN_POS][sPosVirtualWorld]);
	
	ResetPlayerCamera(playerid);
	ShowPlayerDialog(playerid, D_INTRO, DIALOG_STYLE_MSGBOX, "Wprowadzenie (1/2)", "Witaj na serwerze "SERVER_NAME"!\n\nNa sam pocz�tek zalecane jest zapoznanie si� z komend� /pomoc,\ndowiesz si� tam wielu ciekawych rzeczy zwi�zanych z tutejsz� rozgrywk�.\n\nJak wida�, pojawi�e� si� na Unity Station, aby jednak dosta�\nsi� do Urz�du b�dziesz musia� wykorzysta� autobus, b�d� taks�wk�.", "Dalej", "Zamknij");
	return 1;
}

public OnPlayerSave(playerid, what)
{
	if(PlayerCache[playerid][pLogged])
	{
	    new query[512], main_query[1024];
	    format(main_query, sizeof(main_query), "UPDATE `"SQL_PREF"characters` SET");
	    
	    if(what & SAVE_PLAYER_BASIC)
	    {
	        // Podstawy (czas gry, skin, pieni�dze, �ycie, block, crash, areszt, si�a, uzale�nienie, bw, aj, praca, dokumenty)
	        format(query, sizeof(query), " char_hours = '%d', char_minutes = '%d', char_cash = '%d', char_bankcash = '%d', char_banknumb = '%d', char_skin = '%d', char_health = '%f', char_crash = '%d', char_arrest = '%d', char_strength = '%d', char_dependence = '%f', char_bw = '%d', char_aj = '%d', char_house = '%d', char_job = '%d', char_documents = '%d', char_lastskin = '%d', char_mileage = '%f'",
	        PlayerCache[playerid][pHours],
	        PlayerCache[playerid][pMinutes],
	        
	        PlayerCache[playerid][pCash],
	        
	        PlayerCache[playerid][pBankCash],
	        PlayerCache[playerid][pBankNumber],
	        
	        PlayerCache[playerid][pSkin],
	        PlayerCache[playerid][pHealth],
	        
			PlayerCache[playerid][pCrash],
			PlayerCache[playerid][pArrest],
			
			PlayerCache[playerid][pStrength],
			PlayerCache[playerid][pDepend],

			PlayerCache[playerid][pBW],
			PlayerCache[playerid][pAJ],

			PlayerCache[playerid][pHouse],
			PlayerCache[playerid][pJob],

			PlayerCache[playerid][pDocuments],
			PlayerCache[playerid][pLastSkin],

			PlayerCache[playerid][pMileage]);
	        
       		if(strlen(main_query) > 32)
			{
	  			strcat(main_query, ",", sizeof(main_query));
			}
			strcat(main_query, query, sizeof(main_query));
	    }
	    
	    if(what & SAVE_PLAYER_POS)
	    {
			// Pozycja (x, y, z, virtual world, interior)
	        format(query, sizeof(query), " char_posx = '%f', char_posy = '%f', char_posz = '%f', char_world = '%d', char_interior = '%d'",
	        PlayerCache[playerid][pPosX],
	        PlayerCache[playerid][pPosY],
	        PlayerCache[playerid][pPosZ],

			PlayerCache[playerid][pVirtualWorld],
			PlayerCache[playerid][pInteriorID]);
	        
       		if(strlen(main_query) > 32)
			{
	  			strcat(main_query, ",", sizeof(main_query));
			}
			strcat(main_query, query, sizeof(main_query));
	    }
	    
	    if(what & SAVE_PLAYER_SETTING)
	    {
  			// Ustawienia (styl rozmowy, animacja chodzenia)
	        format(query, sizeof(query), " char_talkstyle = '%d', char_walkstyle = '%d', char_fightstyle = '%d', char_ooc = '%d'",
			PlayerCache[playerid][pTalkStyle],
			GetAnimUID(PlayerCache[playerid][pWalkStyle]),
			
			PlayerCache[playerid][pFightStyle],
			PlayerCache[playerid][pOOC]);

       		if(strlen(main_query) > 32)
			{
	  			strcat(main_query, ",", sizeof(main_query));
			}
			strcat(main_query, query, sizeof(main_query));
	    }
	    
    	format(query, sizeof(query), " WHERE char_uid = '%d' LIMIT 1", PlayerCache[playerid][pUID]);
		strcat(main_query, query, sizeof(main_query));

		mysql_query(connHandle, main_query);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
	{
	    if(PlayerCache[killerid][pHours] >= 10)
	    {
	    	PlayerCache[playerid][pBW] = 10 * 60;
		}
		else
		{
		    PlayerCache[playerid][pBW] = 5 * 60;
		}
		
		new killer_uid, weapon_uid;
		
		killer_uid = (PlayerCache[killerid][pGlove] == false) ? PlayerCache[killerid][pUID] : 0;
		weapon_uid = (PlayerCache[killerid][pItemWeapon] != INVALID_ITEM_ID) ? ItemCache[PlayerCache[killerid][pItemWeapon]][iUID] : 0;

		PlayerCache[playerid][pDeathKiller] = killer_uid;
		PlayerCache[playerid][pDeathWeapon] = weapon_uid;

		PlayerCache[playerid][pDeathType] 	= (weapon_uid != 0) ? DEATH_SHOOTING : DEATH_BEATING;
	}
	else
	{
	    PlayerCache[playerid][pBW] = 5 * 60;
	    
	    PlayerCache[playerid][pDeathKiller] = 0;
	    PlayerCache[playerid][pDeathWeapon] = 0;
	    
	    PlayerCache[playerid][pDeathType]   = DEATH_SUICIDE;
	}
	
	// Je�li ma bro�
	if(PlayerCache[playerid][pItemWeapon] != INVALID_ITEM_ID)
	{
		new itemid = PlayerCache[playerid][pItemWeapon];

		ItemCache[itemid][iUsed] = false;
		SaveItem(itemid, SAVE_ITEM_VALUES);
		
		ResetPlayerWeaponsEx(playerid);
		PlayerCache[playerid][pItemWeapon] = INVALID_ITEM_ID;

		PlayerCache[playerid][pCheckWeapon] = false;
		RemovePlayerAttachedObject(playerid, SLOT_WEAPON);
	}
	
	PlayerCache[playerid][pInteriorID] = GetPlayerInterior(playerid);
	PlayerCache[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
	
	GetPlayerPos(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]);

	PlayerCache[playerid][pHealth] = 24;
	OnPlayerSave(playerid, SAVE_PLAYER_POS);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	// Komponenty
	for(new i = 0; i < 14; i++)
	{
 		if(CarInfo[vehicleid][cComponent][i] != 0)
   		{
			AddVehicleComponent(vehicleid, CarInfo[vehicleid][cComponent][i] + 999);
   		}
	}
	
	// Nie mo�e wybucha�
    if(CarInfo[vehicleid][cHealth] < 350)	CarInfo[vehicleid][cHealth] = 350;
	SetVehicleLock(vehicleid, CarInfo[vehicleid][cLocked]);
	
	if(!strlen(CarInfo[vehicleid][cRegister]))
	{
	    SetVehicleNumberPlate(vehicleid, " ");
	}
	else
	{
    	SetVehicleNumberPlate(vehicleid, CarInfo[vehicleid][cRegister]);
	}
	SetVehicleVirtualWorld(vehicleid, CarInfo[vehicleid][cWorldID]);
	LinkVehicleToInterior(vehicleid, CarInfo[vehicleid][cInteriorID]);

	SetVehicleHealth(vehicleid, CarInfo[vehicleid][cHealth]);
	UpdateVehicleDamageStatus(vehicleid, CarInfo[vehicleid][cVisual][0], CarInfo[vehicleid][cVisual][1], CarInfo[vehicleid][cVisual][2], CarInfo[vehicleid][cVisual][3]);

	ChangeVehicleColor(vehicleid, CarInfo[vehicleid][cColor1], CarInfo[vehicleid][cColor2]);
	ChangeVehiclePaintjob(vehicleid, CarInfo[vehicleid][cPaintJob]);
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pLastVeh] == vehicleid)
	        {
	            if(i == killerid)
	            {
	                CarInfo[vehicleid][cHealth] = 350;
	                break;
	            }
	        }
	    }
	}
	
	if(killerid != INVALID_PLAYER_ID)
	{
	    printf("[cars] Pojazd %s (UID: %d) zosta� ca�kowicie zniszczony (%.0f HP) przez %s (UID: %d, GID: %d).", GetVehicleName(CarInfo[vehicleid][cModel]), CarInfo[vehicleid][cUID], CarInfo[vehicleid][cHealth], PlayerRealName(killerid), PlayerCache[killerid][pUID], PlayerCache[killerid][pGID]);
	}
	else
	{
	    printf("[cars] Pojazd %s (UID: %d) zosta� ca�kowicie zniszczony (%.0f HP).", GetVehicleName(CarInfo[vehicleid][cModel]), CarInfo[vehicleid][cUID], CarInfo[vehicleid][cHealth]);
	}
	
	CarInfo[vehicleid][cHealth] = CarInfo[vehicleid][cHealth];
	SaveVehicle(vehicleid, SAVE_VEH_COUNT);
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(isnull(text))	return 0;
	if(!PlayerCache[playerid][pLogged] && !PlayerCache[playerid][pSpawned])
	{
	    return 0;
	}

	if(PlayerCache[playerid][pBW] || PlayerCache[playerid][pAJ])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz si� teraz odezwa�.");
	    return 0;
	}
	
	new string[256];
	
	// Grupy - czat OOC
	if(text[0] == '@')
	{
	    new group_slot = INVALID_SLOT_ID, chat_title[128],
			pos = strfind(text, " ", true) + 1;

		strmid(chat_title, text, pos, strlen(text));
  		strdel(text, pos, strlen(text));

	    if(text[1] == '@')
	    {
			if(isnull(chat_title))
			{
			    SendClientMessage(playerid, COLOR_GREY, "Aby pos�ugiwa� si� czatem OOC podgrupy, poprzed� numer slotu znakami @@ a nast�pnie wpisz tre�� wiadomo�ci.");
			    SendClientMessage(playerid, COLOR_GREY, "Przyk�ad: @@1 Witam! Skrypt automatycznie pobiera slot ostatnio u�ywanego czatu, wi�c dalej nie musisz go definiowa�.");
			    return 0;
			}

			if(text[2] != ' ')	group_slot = strval(text[2]) - 1;
			else				group_slot = PlayerCache[playerid][pMainGroupSlot] - 1;

			if(group_slot < 0 || group_slot >= MAX_GROUP_SLOTS)
			{
				GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
	   			return 0;
			}
			if(!PlayerGroup[playerid][group_slot][gpUID])
			{
	  			GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
		    	return 0;
			}
			if(!(PlayerGroup[playerid][group_slot][gpPerm] & G_PERM_CHAT))
			{
			    GameTextForPlayer(playerid, "~r~Brak uprawnien do pisania na czacie.", 3000, 3);
			    return 0;
			}
			new group_id = PlayerGroup[playerid][group_slot][gpID];
			if(!(GroupData[group_id][gFlags] & G_FLAG_OOC))
			{
			    GameTextForPlayer(playerid, "~r~Brak dostepu do tego czatu.", 3000, 3);
			    return 0;
			}
			if(GroupData[group_id][gToggleChat])
			{
			    GameTextForPlayer(playerid, "~r~Czat ~w~OOC ~r~grupy zostal wylaczony.", 3000, 3);
			    return 0;
			}
			if(PlayerGroup[playerid][group_slot][gpTogG])
			{
			    GameTextForPlayer(playerid, "~r~Masz wylaczony czat dla tej grupy.", 3000, 3);
			    return 0;
			}
			chat_title[0] = chrtoupper(chat_title[0]);

			foreach(new i : Player)
			{
				if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
				{
					if(IsPlayerInGroup(i, GroupData[group_id][gUID]))
					{
					    group_slot = GetPlayerGroupSlot(i, GroupData[group_id][gUID]);
					    if(PlayerGroup[i][group_slot][gpTogG])	continue;
					    
					    PlayerCache[i][pMainGroupSlot] = group_slot + 1;
					    
						format(string, sizeof(string), "[@@%d %s]: (( %s [%d]: %s ))", PlayerCache[i][pMainGroupSlot], GroupData[group_id][gTag], PlayerName(playerid), playerid, chat_title);
						SendClientMessage(i, ColorFade(GroupData[group_id][gColor], 7, 10), string);
					}
					else if(GroupData[group_id][gOwner] && IsPlayerInGroup(i, GroupData[group_id][gOwner]))
					{
					    group_slot = GetPlayerGroupSlot(i, GroupData[group_id][gOwner]);
					    if(PlayerGroup[i][group_slot][gpTogG])	continue;
					
         				PlayerCache[i][pMainGroupSlot] = group_slot + 1;

						format(string, sizeof(string), "[@@%d %s]: (( %s [%d]: %s ))", PlayerCache[i][pMainGroupSlot], GroupData[group_id][gTag], PlayerName(playerid), playerid, chat_title);
						SendClientMessage(i, ColorFade(GroupData[group_id][gColor], 7, 10), string);
					}
					else
					{
						for (new slot = 0; slot < MAX_GROUP_SLOTS; slot++)
						{
						    if(PlayerGroup[i][slot][gpUID])
						    {
							    if(GroupData[PlayerGroup[i][slot][gpID]][gOwner] == GroupData[group_id][gUID])
							    {
							        if(!PlayerGroup[i][slot][gpTogG])
							        {
	             						PlayerCache[i][pMainGroupSlot] = slot + 1;

										format(string, sizeof(string), "[@@%d %s]: (( %s [%d]: %s ))", PlayerCache[i][pMainGroupSlot], GroupData[group_id][gTag], PlayerName(playerid), playerid, chat_title);
										SendClientMessage(i, ColorFade(GroupData[group_id][gColor], 7, 10), string);
										break;
									}
								}
							}
						}
					}
				}
			}
	    }
	    else
		{
			if(isnull(chat_title))
			{
			    SendClientMessage(playerid, COLOR_GREY, "Aby pos�ugiwa� si� czatem OOC grupy, poprzed� numer slotu znakiem @ a nast�pnie wpisz tre�� wiadomo�ci.");
			    SendClientMessage(playerid, COLOR_GREY, "Przyk�ad: @1 Witam! Skrypt automatycznie pobiera slot ostatnio u�ywanego czatu, wi�c dalej nie musisz go definiowa�.");
			    return 0;
			}

			if(text[1] != ' ')	group_slot = strval(text[1]) - 1;
			else				group_slot = PlayerCache[playerid][pMainGroupSlot] - 1;

			if(group_slot < 0 || group_slot >= MAX_GROUP_SLOTS)
			{
				GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
	   			return 0;
			}
			if(!PlayerGroup[playerid][group_slot][gpUID])
			{
	  			GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
		    	return 0;
			}
			if(!(PlayerGroup[playerid][group_slot][gpPerm] & G_PERM_CHAT))
			{
			    GameTextForPlayer(playerid, "~r~Brak uprawnien do pisania na czacie.", 3000, 3);
			    return 0;
			}
			new group_id = PlayerGroup[playerid][group_slot][gpID];
			if(!(GroupData[group_id][gFlags] & G_FLAG_OOC))
			{
			    GameTextForPlayer(playerid, "~r~Brak dostepu do tego czatu.", 3000, 3);
			    return 0;
			}
			if(GroupData[group_id][gToggleChat])
			{
			    GameTextForPlayer(playerid, "~r~Czat ~w~OOC ~r~grupy zostal wylaczony.", 3000, 3);
			    return 0;
			}
			if(PlayerGroup[playerid][group_slot][gpTogG])
			{
			    GameTextForPlayer(playerid, "~r~Masz wylaczony czat dla tej grupy.", 3000, 3);
			    return 0;
			}
			chat_title[0] = chrtoupper(chat_title[0]);

			foreach(new i : Player)
			{
				if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
				{
					if(IsPlayerInGroup(i, GroupData[group_id][gUID]))
					{
					    group_slot = GetPlayerGroupSlot(i, GroupData[group_id][gUID]);
					    if(PlayerGroup[i][group_slot][gpTogG])	continue;
					    
	 					PlayerCache[i][pMainGroupSlot] = group_slot + 1;

						format(string, sizeof(string), "[@%d %s]: (( %s [%d]: %s ))", PlayerCache[i][pMainGroupSlot], GroupData[group_id][gTag], PlayerName(playerid), playerid, chat_title);
						SendClientMessage(i, ColorFade(GroupData[group_id][gColor], 7, 10), string);
					}
				}
			}
	    }
		return 0;
	}
	
	// Grupy - czat IC
	if(text[0] == '!')
	{
 		new group_slot = INVALID_SLOT_ID, chat_title[128];
 		new pos = strfind(text, " ", true) + 1;

	    if(text[1] == '!')
	    {
  			strmid(chat_title, text, pos, strlen(text));
	        strdel(text, pos, strlen(text));

			if(isnull(chat_title))
			{
			    SendClientMessage(playerid, COLOR_GREY, "Aby pos�ugiwa� si� czatem IC podgrupy, poprzed� numer slotu znakami !! a nast�pnie wpisz tre�� wiadomo�ci.");
			    SendClientMessage(playerid, COLOR_GREY, "Przyk�ad: !!1 Zg�aszam si�. Skrypt automatycznie pobiera slot ostatnio u�ywanego czatu, wi�c dalej nie musisz go definiowa�.");
			    return 0;
			}

			if(text[2] != ' ')	group_slot = strval(text[2]) - 1;
			else				group_slot = PlayerCache[playerid][pMainGroupSlot] - 1;

			if(group_slot < 0 || group_slot >= 5)
			{
				GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
	   			return 0;
			}
			if(!PlayerGroup[playerid][group_slot][gpUID])
			{
	  			GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
		    	return 0;
			}
			if(!(PlayerGroup[playerid][group_slot][gpPerm] & G_PERM_CHAT))
			{
			    GameTextForPlayer(playerid, "~r~Brak uprawnien do pisania na czacie.", 3000, 3);
			    return 0;
			}
			new group_id = PlayerGroup[playerid][group_slot][gpID];
			if(!(GroupData[group_id][gFlags] & G_FLAG_IC))
			{
			    GameTextForPlayer(playerid, "~r~Brak dostepu do tego czatu.", 3000, 3);
			    return 0;
			}
			chat_title[0] = chrtoupper(chat_title[0]);

			foreach(new i : Player)
			{
				if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
				{
					if(IsPlayerInGroup(i, GroupData[group_id][gUID]))
					{
 						PlayerCache[i][pMainGroupSlot] = GetPlayerGroupSlot(i, GroupData[group_id][gUID]) + 1;

						format(string, sizeof(string), "!!%d ** [%s]: %s: %s **", PlayerCache[i][pMainGroupSlot], GroupData[group_id][gTag], PlayerName(playerid), chat_title);
						SendClientMessage(i, GroupData[group_id][gColor], string);
					}
					else if(GroupData[group_id][gOwner] && IsPlayerInGroup(i, GroupData[group_id][gOwner]))
					{
					    PlayerCache[i][pMainGroupSlot] = GetPlayerGroupSlot(i, GroupData[group_id][gOwner]) + 1;

						format(string, sizeof(string), "!!%d ** [%s]: %s: %s **", PlayerCache[i][pMainGroupSlot], GroupData[group_id][gTag], PlayerName(playerid), chat_title);
						SendClientMessage(i, GroupData[group_id][gColor], string);
					}
					else
					{
						for (new slot = 0; slot < MAX_GROUP_SLOTS; slot++)
						{
						    if(PlayerGroup[i][slot][gpUID])
						    {
							    if(GroupData[PlayerGroup[i][slot][gpID]][gOwner] == GroupData[group_id][gUID])
							    {
	 					    		PlayerCache[i][pMainGroupSlot] = slot + 1;

									format(string, sizeof(string), "!!%d ** [%s]: %s: %s **", PlayerCache[i][pMainGroupSlot], GroupData[group_id][gTag], PlayerName(playerid), chat_title);
									SendClientMessage(i, GroupData[group_id][gColor], string);
									break;
								}
							}
						}
					}
				}
			}
			format(string, sizeof(string), "%s m�wi (radio): %s", PlayerName(playerid), chat_title);
			ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		}
	    else
	    {
  			strmid(chat_title, text, pos, strlen(text));
	        strdel(text, pos, strlen(text));

			if(isnull(chat_title))
			{
			    SendClientMessage(playerid, COLOR_GREY, "Aby pos�ugiwa� si� czatem IC grupy, poprzed� numer slotu znakiem ! a nast�pnie wpisz tre�� wiadomo�ci.");
			    SendClientMessage(playerid, COLOR_GREY, "Przyk�ad: !1 Zg�aszam si�. Skrypt automatycznie pobiera slot ostatnio u�ywanego czatu, wi�c dalej nie musisz go definiowa�.");
			    return 0;
			}

			if(text[1] != ' ')	group_slot = strval(text[1]) - 1;
			else				group_slot = PlayerCache[playerid][pMainGroupSlot] - 1;

			if(group_slot < 0 || group_slot >= 5)
			{
				GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
	   			return 0;
			}
			if(!PlayerGroup[playerid][group_slot][gpUID])
			{
	  			GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
		    	return 0;
			}
			if(!(PlayerGroup[playerid][group_slot][gpPerm] & G_PERM_CHAT))
			{
			    GameTextForPlayer(playerid, "~r~Brak uprawnien do pisania na czacie.", 3000, 3);
			    return 0;
			}
			new group_id = PlayerGroup[playerid][group_slot][gpID];
			if(!(GroupData[group_id][gFlags] & G_FLAG_IC))
			{
			    GameTextForPlayer(playerid, "~r~Brak dostepu do tego czatu.", 3000, 3);
			    return 0;
			}
			chat_title[0] = chrtoupper(chat_title[0]);

			foreach(new i : Player)
			{
				if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
				{
					if(IsPlayerInGroup(i, GroupData[group_id][gUID]))
					{
	 					PlayerCache[i][pMainGroupSlot] = GetPlayerGroupSlot(i, GroupData[group_id][gUID]) + 1;

						format(string, sizeof(string), "!%d ** [%s]: %s: %s **", PlayerCache[i][pMainGroupSlot], GroupData[group_id][gTag], PlayerName(playerid), chat_title);
						SendClientMessage(i, GroupData[group_id][gColor], string);
					}
				}
			}
			format(string, sizeof(string), "%s m�wi (radio): %s", PlayerName(playerid), chat_title);
			ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	    }
		return 0;
	}
	
	if(text[0] == '.')
	{
	    new bool: found = false;
	    foreach(new anim_id : Anim)
	    {
    		if(!strcmp(text, AnimCache[anim_id][aCommand], true))
   			{
 	    		if(AnimCache[anim_id][aAction] == 0)
   	    		{
    	    		ApplyAnimation(playerid, AnimCache[anim_id][aLib], AnimCache[anim_id][aName], AnimCache[anim_id][aSpeed], AnimCache[anim_id][aOpt1], AnimCache[anim_id][aOpt2], AnimCache[anim_id][aOpt3], AnimCache[anim_id][aOpt4], AnimCache[anim_id][aOpt5], true);
				}
				else
				{
    				SetPlayerSpecialAction(playerid, AnimCache[anim_id][aAction]);
				}
				PlayerCache[playerid][pPlayAnim] = true;
				found = true;
	       	}
	    }
		if(!found) PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	    return 0;
	}
	text[0] = chrtoupper(text[0]);
	
	if(PlayerCache[playerid][pCallingTo] != INVALID_PLAYER_ID)
	{
	    if(PlayerCache[playerid][pCallingTo] == NUMBER_WHOLESALE || PlayerCache[playerid][pCallingTo] == NUMBER_TAXI || PlayerCache[playerid][pCallingTo] == NUMBER_ALARM || PlayerCache[playerid][pCallingTo] == NUMBER_NEWS)
	    {
	        return 0;
	    }
	    new called_player = PlayerCache[playerid][pCallingTo];
	    if(!PlayerCache[called_player][pLogged] || !PlayerCache[called_player][pSpawned] || PlayerCache[called_player][pCallingTo] != playerid)
	    {
	        PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;
	        SendClientMessage(playerid, COLOR_YELLOW, "Utracono po��czenie z rozm�wc�.");

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	        RemovePlayerAttachedObject(playerid, SLOT_PHONE);
	        return 0;
	    }
	    format(string, sizeof(string), "[Telefon, %s]: %s", GetSexName(PlayerCache[playerid][pSex]), text);
	    SendClientMessage(called_player, COLOR_YELLOW, string);

   		format(string, sizeof(string), "%s (telefon): %s", PlayerName(playerid), text);
  		ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	    return 0;
	}
	
	if(PlayerCache[playerid][pRadioLive])
	{
		new desc[128];
		memcpy(desc, text, 0, 128 * 4);

		EscapePL(desc);

	    format(string, sizeof(string), "~y~~h~LSN ~>~ ~p~~h~Na zywo - %s: ~w~%s", PlayerName(playerid), FormatTextDrawColors(desc));
	    TextDrawSetString(Text:TextDrawNews, string);
	    return 0;
	}

	if(PlayerCache[playerid][pRadioInterview] != INVALID_PLAYER_ID)
	{
		new desc[128];
		memcpy(desc, text, 0, 128 * 4);

		EscapePL(desc);

		format(string, sizeof(string), "~y~~h~LSN ~>~ ~r~~h~Wywiad - %s: ~w~%s", PlayerName(playerid), FormatTextDrawColors(desc));
		TextDrawSetString(Text:TextDrawNews, string);
		return 0;
	}
	
	if(!strcmp(text, ":D", true) || !strcmp(text, " :D", true) || !strcmp(text, ":D ", true))
	{
	    ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.1, 0, 0, 0, 0, 0, true);
	    
	    format(string, sizeof(string), "* %s �mieje si�.", PlayerName(playerid));
        ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		return 0;
	}
	if(!strcmp(text, ":)", true) || !strcmp(text, " :)", true) || !strcmp(text, ":) ", true))
	{
	    format(string, sizeof(string), "* %s u�miecha si�.", PlayerName(playerid));
        ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		return 0;
	}
	if(!strcmp(text, ":/", true) || !strcmp(text, " :/", true) || !strcmp(text, ":/ ", true))
	{
	    format(string, sizeof(string), "* %s krzywi si�.", PlayerName(playerid));
        ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		return 0;
	}
	if(!strcmp(text, ":O", true) || !strcmp(text, " :O", true) || !strcmp(text, ":O ", true))
	{
	    format(string, sizeof(string), "* %s robi zdziwion� min�.", PlayerName(playerid));
        ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		return 0;
	}
	if(!strcmp(text, ":(", true) || !strcmp(text, " :(", true) || !strcmp(text, ":( ", true))
	{
	    format(string, sizeof(string), "* %s robi smutna min�.", PlayerName(playerid));
        ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		return 0;
	}
	if(!strcmp(text, ":P", true) || !strcmp(text, " :P", true) || !strcmp(text, ":P ", true))
	{
	    format(string, sizeof(string), "* %s wystawia j�zyk.", PlayerName(playerid));
        ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		return 0;
	}
	
	if(strlen(text) < 78)
	{
		format(string, sizeof(string), "%s m�wi: %s", PlayerName(playerid), text);
		ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
 	}
	else
	{
	    new pos = strfind(text, " ", true, strlen(text) / 2);
		if(pos != -1)
		{
  			new text2[64];

  			strmid(text2, text, pos + 1, strlen(text));
			strdel(text, pos, strlen(text));

			format(string, sizeof(string), "%s m�wi: %s...", PlayerName(playerid), text);
      		ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

			format(string, sizeof(string), "...%s", text2);
			ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		}
	}
	
	if(!PlayerCache[playerid][pPlayAnim])
	{
		new talk_style = PlayerCache[playerid][pTalkStyle];

		ApplyAnimation(playerid, TalkStyleData[talk_style][0], TalkStyleData[talk_style][1], 4.1, 0, 1, 1, 1, 1, true);
		defer KillTalkingAnimation[60 * strlen(text)](playerid);
	}
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(success == 0)
	{
		return PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
	}
	else
	{
	    if(!strcmp(cmdtext, "/w", true))
	    {
	        return 1;
	    }
		printf("[cmmd] %s: %s", PlayerRealName(playerid), cmdtext);
		return 1;
	}
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if(!PlayerCache[playerid][pLogged] || !PlayerCache[playerid][pSpawned])
	{
	    return 0;
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new Float:PosX, Float:PosY, Float:PosZ;
	GetPlayerPos(playerid, PosX, PosY, PosZ);

	if(CarInfo[vehicleid][cLocked])
	{
	    crp_SetPlayerPos(playerid, PosX, PosY, PosZ);
	    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~r~Ten pojazd jest zamkniety", 4000, 3);
	    return 1;
	}
	
	if(PlayerCache[playerid][pRoll])
	{
	    crp_SetPlayerPos(playerid, PosX, PosY, PosZ);
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wsi��� do pojazdu maj�c rolki na nogach.");
	    return 1;
	}
	
	if(!ispassenger)
	{
	    if(CarInfo[vehicleid][cOwnerType] == OWNER_GROUP)
	    {
		    if(PlayerCache[playerid][pLesson] != INVALID_GROUP_ID)
		    {
     			new group_id = PlayerCache[playerid][pLesson];
	            if(CarInfo[vehicleid][cOwner] != GroupData[group_id][gUID])
	            {
			        crp_SetPlayerPos(playerid, PosX, PosY, PosZ);
			        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz prowadzi� tego pojazdu.");
	                return 1;
	            }
		    }
		    else
		    {
		   		if(!HavePlayerGroupPerm(playerid, CarInfo[vehicleid][cOwner], G_PERM_CARS))
			    {
			        crp_SetPlayerPos(playerid, PosX, PosY, PosZ);
			        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz prowadzi� tego pojazdu.");
	                return 1;
	            }
		    }
		}
		else
		{
			if(PlayerCache[playerid][pHours] < 5)
			{
	  			crp_SetPlayerPos(playerid, PosX, PosY, PosZ);
	     		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Nie mo�esz wsi��� do pojazdu jako kierowca maj�c mniej ni� 5h gry.");
	     		return 1;
			}
		}
	
		if(CarInfo[vehicleid][cBlockWheel])
  		{
    		crp_SetPlayerPos(playerid, PosX, PosY, PosZ);
      		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Na ko�o pojazdu %s (UID: %d) zosta�a na�o�ona blokada.\nAby zwolni� blokad�, udaj si� na komisariat\ni zapytaj w jaki spos�b mo�na to zrobi�.\n\nKoszt zdj�cia blokady wynosi: $%d", GetVehicleName(CarInfo[vehicleid][cModel]), CarInfo[vehicleid][cUID], CarInfo[vehicleid][cBlockWheel]);
        	return 1;
    	}

		if((PlayerCache[playerid][pBlock] & BLOCK_VEH))
		{
		    crp_SetPlayerPos(playerid, PosX, PosY, PosZ);
		    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Masz na�o�on� blokad� prowadzenia pojazd�w!\n\nSprawd� swoje logi w panelu gry na naszym forum\nmo�esz odczeka� do czasu, gdy kara wyga�nie, lub te� apelowa�.");
		    return 1;
		}
	}
	else
	{
		if(PlayerCache[playerid][pHours] < 5)
  		{
			new driverid = GetVehicleDriver(vehicleid);
			if(driverid == INVALID_PLAYER_ID)
			{
				crp_SetPlayerPos(playerid, PosX, PosY, PosZ);
	       		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Maj�c mniej ni� 5h gry mo�esz wsi��� jako pasa�er tylko do pojazdu, w kt�rym znajduje si� kierowca.");
	  			return 1;
			}
   		}
	}
	
	if(ispassenger)
	{
	    printf("[cars] %s (UID: %d, GID: %d) wsiad� do pojazdu %s (UID: %d) jako pasa�er.", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], GetVehicleName(CarInfo[vehicleid][cModel]), CarInfo[vehicleid][cUID]);
	}
	else
	{
	    printf("[cars] %s (UID: %d, GID: %d) wsiad� do pojazdu %s (UID: %d) jako kierowca.", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], GetVehicleName(CarInfo[vehicleid][cModel]), CarInfo[vehicleid][cUID]);
        PlayerCache[playerid][pLastVeh] = vehicleid;
	}
	
	new engine_status = GetVehicleEngineStatus(vehicleid);
	ChangeVehicleEngineStatus(vehicleid, (IsVehicleBike(vehicleid)) ? 1 : engine_status);
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	// Spectate
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pSpectate] == playerid)
	        {
	            switch(newstate)
	            {
      		    	case 0, 1, 7, 8:
				    {
						PlayerSpectatePlayer(i, playerid);
					}
	    			case 2, 3:
	    			{
						PlayerSpectateVehicle(i , GetPlayerVehicleID(playerid));
					}
		   			case 9:
				    {
				        SetPlayerSpawn(i);
				    }
	            }
	        }
	    }
	}

	// Zespawnowany
	if(newstate == PLAYER_STATE_SPAWNED)
	{
	    if(!PlayerCache[playerid][pSpawned])
	    {
	        if(!PlayerCache[playerid][pLogged])
	        {
	            Kick(playerid);
	            return 1;
	        }
	        PlayerCache[playerid][pSpawned] = true;
	    }
	}

	// Kierowca
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    new vehid = GetPlayerVehicleID(playerid);
	    if(GetVehicleEngineStatus(vehid) != 1)
	    {
	        TD_ShowSmallInfo(playerid, 0, "Aby uruchomic silnik, wcisnij ~y~~k~~VEHICLE_FIREWEAPON_ALT~~w~ + ~y~~k~~SNEAK_ABOUT~~w~.~n~Klawisz ~y~~k~~VEHICLE_FIREWEAPON~ ~w~kontroluje swiatla w pojezdzie.");
	    }
	    
	    if(CarInfo[vehid][cAccess] & VEH_ACCESS_RADIO)
	    {
	        if(CarInfo[vehid][cRadioCanal])
	        {
				new string[64];
				format(string, sizeof(string), "CB radio: (%d) hz", CarInfo[vehid][cRadioCanal]);
				
				PlayerTextDrawSetString(playerid, TextDrawRadioCB[playerid], string);
				PlayerTextDrawShow(playerid, TextDrawRadioCB[playerid]);
	        }
	    }
	    
     	if(PlayerCache[playerid][pLastVeh] != vehid)
      	{
       		GivePlayerPunish(playerid, INVALID_PLAYER_ID, PUNISH_KICK, "Nieautoryzowane wejscie do pojazdu.", 0, 0);
			return 1;
       	}
	}
	
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
	    new vehid = PlayerCache[playerid][pLastVeh];
	    if(GetVehicleEngineStatus(vehid) != 1)
	    {
			TD_HideSmallInfo(playerid);
		}
		
  		if(CarInfo[vehid][cAccess] & VEH_ACCESS_RADIO)
	    {
	        if(CarInfo[vehid][cRadioCanal])
	        {
				PlayerTextDrawHide(playerid, TextDrawRadioCB[playerid]);
	        }
	    }
		
  		// Je�li kierowca taks�wki wysi�dzie
	    if(PlayerCache[playerid][pTaxiPassenger] != INVALID_PLAYER_ID)
	    {
	        new passenger_id = PlayerCache[playerid][pTaxiPassenger],
				price = PlayerCache[passenger_id][pTaxiPay];

	        if(price > 0 && PlayerCache[passenger_id][pCash] >= price)
	        {
      			new group_cash = floatround(0.90 * price),
					playercash = floatround(0.10 * price);

		        crp_GivePlayerMoney(passenger_id, -price);
		        crp_GivePlayerMoney(playerid, playercash);

		        new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);

		        GroupData[group_id][gCash] += group_cash;
		        SaveGroup(group_id);

       			ShowPlayerInfoDialog(passenger_id, D_TYPE_INFO, "Zap�aci�e� $%d za przejazd taks�wk�.", price);
				ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\nNa konto grupy dodano: $%d", playercash, group_cash);
			}

			PlayerCache[passenger_id][pTaxiVeh] 	= INVALID_VEHICLE_ID;
			PlayerCache[passenger_id][pTaxiPay] 	= 0;
			PlayerCache[passenger_id][pTaxiPrice] 	= 0;
			PlayerCache[playerid][pTaxiPassenger] 	= INVALID_PLAYER_ID;
	    }
	    
   		// GPS
		if(CarInfo[vehid][cGPS])	for(new icon_id = 0; icon_id < 100; icon_id++) RemovePlayerMapIcon(playerid, icon_id);
	    
	    // Pasy
		PlayerCache[playerid][pBelts] = false;
	}
	
	if(oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_ONFOOT)
	{
 		// Je�li pasa�er taks�wki wysi�dzie
 		if(PlayerCache[playerid][pTaxiVeh] != INVALID_VEHICLE_ID)
	    {
	        new driverid = GetVehicleDriver(PlayerCache[playerid][pTaxiVeh]),
				price = PlayerCache[playerid][pTaxiPay];

	        if(price > 0 && PlayerCache[playerid][pCash] >= price)
	        {
      			new group_cash = floatround(0.90 * price),
					playercash = floatround(0.10 * price);

		        crp_GivePlayerMoney(playerid, -price);
		        crp_GivePlayerMoney(driverid, playercash);

		        new group_id = GetPlayerGroupID(driverid, PlayerCache[driverid][pDutyGroup]);

		        GroupData[group_id][gCash] += group_cash;
		        SaveGroup(group_id);

       			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Zap�aci�e� $%d za przejazd taks�wk�.", price);
				ShowPlayerInfoDialog(driverid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\nNa konto grupy dodano: $%d", playercash, group_cash);
			}

			PlayerCache[playerid][pTaxiVeh] 		= INVALID_VEHICLE_ID;
			PlayerCache[playerid][pTaxiPay] 		= 0;
			PlayerCache[playerid][pTaxiPrice] 		= 0;
			PlayerCache[driverid][pTaxiPassenger] 	= INVALID_PLAYER_ID;
		}
		
  		// Pasy
		PlayerCache[playerid][pBelts] = false;
	}
	
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
	    new vehid = GetPlayerVehicleID(playerid);
	    if(strlen(CarInfo[vehid][cAudioURL]))
	    {
   			if(PlayerCache[playerid][pItemPlayer] != INVALID_ITEM_ID)
		    {
		        new itemid = PlayerCache[playerid][pItemPlayer];
		        ItemCache[itemid][iUsed] = false;
		    }
		    PlayStreamedAudioForPlayer(playerid, CarInfo[vehid][cAudioURL]);
		}
		
		// Przyciemniona szyba
  		if(CarInfo[vehid][cAccess] & VEH_ACCESS_DIM)
	    {
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pNameTag], E_STREAMER_DRAW_DISTANCE, 5.0);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pDescTag], E_STREAMER_DRAW_DISTANCE, 5.0);
	    }
	    
	    if(PlayerCache[playerid][pAFK] > 0)
	    {
	        GivePlayerPunish(playerid, INVALID_PLAYER_ID, PUNISH_KICK, "Nieautoryzowane wejscie do pojazdu.", 0, 0);
	    }
	}
	
	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
	    new vehid = PlayerCache[playerid][pLastVeh];
	    if(strlen(CarInfo[vehid][cAudioURL]))
	    {
   			new Float:VehPosX, Float:VehPosY, Float:VehPosZ;
			GetVehiclePos(vehid, VehPosX, VehPosY, VehPosZ);
			
	        StopStreamedAudioForPlayer(playerid);
		}
		
		// Przyciemniona szyba
  		if(CarInfo[vehid][cAccess] & VEH_ACCESS_DIM)
	    {
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pNameTag], E_STREAMER_DRAW_DISTANCE, 15.0);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pDescTag], E_STREAMER_DRAW_DISTANCE, 10.0);
	    }
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	switch(PlayerCache[playerid][pCheckpoint])
	{
	    case CHECKPOINT_VEHICLE:
	    {
	        DisablePlayerCheckpoint(playerid);

	        PlayerCache[playerid][pCheckpoint] = CHECKPOINT_NONE;
			TD_ShowSmallInfo(playerid, 3, "Namierzanie zostalo ~r~anulowane~w~.");
		}
	    case CHECKPOINT_PACKAGE:
	    {
	        new package_id = PlayerCache[playerid][pPackage], doorid = GetDoorID(PackageCache[package_id][pDoorUID]);
	        
	        PackageCache[package_id][pDistance] = GetDistanceToDoor(playerid, doorid);
	        ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Wzi��e� paczk� z hurtowni, szczeg�owe dane:\n\nNumer paczki: %d\nW�a�ciciel: %s\n\nAdres: SA %d\nDystans do przebycia: %dm", PackageCache[package_id][pUID], DoorCache[doorid][dName], DoorCache[doorid][dUID], PackageCache[package_id][pDistance]);
	        
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ], 5.0);
			
			PlayerCache[playerid][pCheckpoint] 	= CHECKPOINT_DOOR;
			PlayerCache[playerid][pLastMileage] = floatround(PlayerCache[playerid][pMileage]);
			
			TD_ShowSmallInfo(playerid, 3, "Udaj sie do ~r~wyznaczonego ~w~punktu na mapie.");
	    }
	    case CHECKPOINT_DOOR:
		{
		    new package_id = PlayerCache[playerid][pPackage], doorid = GetDoorID(PackageCache[package_id][pDoorUID]),
		        price = PackageCache[package_id][pDistance] / 100;
		        
		    DisablePlayerCheckpoint(playerid);
		    
   			PlayerCache[playerid][pCheckpoint] 	= CHECKPOINT_NONE;
			PlayerCache[playerid][pPackage]	 	= INVALID_PACKAGE_ID;
		    
		    if(floatround(PlayerCache[playerid][pMileage] - PlayerCache[playerid][pLastMileage]) < float(PackageCache[package_id][pDistance] / 1000))
		    {
				ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie przeby�e� minimalnego dystansu, kurs nie zosta� zaliczony.\nPami�taj, �e dostarcza� paczki mo�esz tylko pojazdem silnikowym!");
				return 1;
		    }
		    
		    CreateDoorProduct(doorid, PackageCache[package_id][pItemName], PackageCache[package_id][pItemType], PackageCache[package_id][pItemValue1], PackageCache[package_id][pItemValue2], PackageCache[package_id][pItemPrice], PackageCache[package_id][pItemCount]);
            if(PackageCache[package_id][pType] == PACKAGE_PRODUCT)	crp_GivePlayerMoney(playerid, price);
            
			DeletePackage(package_id);
			TD_ShowSmallInfo(playerid, 3, "Paczka zostala ~g~dostarczona ~w~pomyslnie.~n~Otrzymales ~y~$%d ~w~do swojego portfela.", price);
		}
	}
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    GameTextForPlayer(playerid, "~r~Musisz byc w pojezdzie jako kierowca!", 3000, 3);
	    return 1;
	}

	RaceInfo[playerid][rPoint] ++;
	new checkpoint = RaceInfo[playerid][rPoint];
	
	if(checkpoint < PlayerCache[playerid][pRaceCheckpoints])
	{
	    SetPlayerRaceCheckpoint(playerid, 0, RaceInfo[playerid][rCPX][checkpoint], RaceInfo[playerid][rCPY][checkpoint], RaceInfo[playerid][rCPZ][checkpoint], RaceInfo[playerid][rCPX][checkpoint + 1], RaceInfo[playerid][rCPY][checkpoint + 1], RaceInfo[playerid][rCPZ][checkpoint + 1], 10.0);
	}
	else
	{
	    SetPlayerRaceCheckpoint(playerid, 1, RaceInfo[playerid][rCPX][checkpoint], RaceInfo[playerid][rCPY][checkpoint], RaceInfo[playerid][rCPZ][checkpoint], 0.0, 0.0, 0.0, 10.0);
	}
	
	/*
	new curr_checkpoint = MAX_RACE_CP,
	    racers_count;
	    
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(RaceInfo[i][rOwner] != INVALID_PLAYER_ID && RaceInfo[i][rOwner] == RaceInfo[playerid][rOwner])
	        {
				checkpoint = RaceInfo[i][rPoint];
				if(checkpoint < curr_checkpoint)
				{
				    curr_checkpoint = checkpoint;
				    RaceInfo[i][rPosition] += 1;
				}
				racers_count ++;
	        }
	    }
	}
	*/
	new time_minutes,
		time_seconds;
		
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(RaceInfo[i][rOwner] != INVALID_PLAYER_ID && RaceInfo[i][rOwner] == RaceInfo[playerid][rOwner])
	        {
	            RaceInfo[i][rTime] = gettime();
	            
    			time_minutes = floatround((RaceInfo[i][rTime] - RaceInfo[i][rStart]) / 60, floatround_floor) % 60;
				time_seconds = floatround((RaceInfo[i][rTime] - RaceInfo[i][rStart]), floatround_floor) % 60;
				
				TD_ShowSmallInfo(i, 0, "Wyscig ~y~trwa ~w~wjezdzaj w ~r~czerwone punkty~w~.~n~Nie opuszczaj swojego pojazdu.~n~~n~Checkpoint: ~y~%d/%d~n~~w~Twoj czas: ~p~~h~%02d:%02d", RaceInfo[i][rPoint], PlayerCache[i][pRaceCheckpoints], time_minutes, time_seconds);
	        }
	    }
	}
	
	
	if(checkpoint > PlayerCache[playerid][pRaceCheckpoints])
	{
		new	race_minutes = floatround((gettime() - RaceInfo[playerid][rStart]) / 60, floatround_floor) % 60,
			race_seconds = floatround((gettime() - RaceInfo[playerid][rStart]), floatround_floor) % 60;

		foreach(new i : Player)
  		{
	      if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	      {
	          if(RaceInfo[i][rOwner] != INVALID_PLAYER_ID && RaceInfo[i][rOwner] == RaceInfo[playerid][rOwner])
	          {
              		DisablePlayerRaceCheckpoint(i);

					RaceInfo[i][rPoint] = 0;
					RaceInfo[i][rStart] = 0;
					
					TD_HideSmallInfo(i);
					TD_ShowLargeInfo(i, 20, "~b~~h~Wyscig dobiegl konca!~n~~n~~w~Zwyciezca: ~g~~h~%s~n~~w~Czas trwania wyscigu: ~y~%02d:%02d", PlayerName(playerid), race_minutes, race_seconds);
				}
     		}
	    }
	    
	    GivePlayerAchievement(playerid, ACHIEVE_FAST);
		return 1;
	}
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

public OnDynamicObjectMoved(objectid)
{
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pBasketBall] == objectid)
	        {
	        	new basket_object_id, string[128],
					Float:oPosX, Float:oPosY, Float:oPosZ,
				    Float:tPosX, Float:tPosY, Float:tPosZ;
	        
	            basket_object_id = PlayerCache[i][pBasketObject];
	            
	            GetDynamicObjectPos(basket_object_id, oPosX, oPosY, oPosZ);
            	GetXYBehindOfObject(basket_object_id, tPosX, tPosY, 0.5);
            	
				if((tPosX < oPosX + 0.5) && (tPosX > oPosX - 0.5) && (tPosY < oPosY + 0.5) && (tPosY > oPosY - 0.5) && (tPosZ < (oPosZ + 2) + 0.5) && (tPosZ > (oPosZ + 2) - 0.5))
				{
				    MoveDynamicObject(objectid, tPosX, tPosY, PlayerCache[i][pPosZ], 10.0);

					format(string, sizeof(string), "* Pi�ka trafia do kosza. (( %s ))", PlayerName(i));
					ProxDetector(10.0, i, string, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO);
				}
				else if((tPosX < oPosX + 2) && (tPosX > oPosX - 2) && (tPosY < oPosY + 2) && (tPosY > oPosY - 2) && (tPosZ < oPosZ + 2) && (tPosZ > oPosZ - 2))
				{
			        MoveDynamicObject(objectid, tPosX + random(5), tPosY + random(5), PlayerCache[i][pPosZ], 10.0);
				}
				return 1;
	        }
	    }
	}
	
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == PickupWork)
	{
	    ShowPlayerDialog(playerid, D_WORK_SELECT, DIALOG_STYLE_LIST, "Dost�pne prace dorywcze:", "1. Mechanik\n2. Kurier\n3. Sprzedawca", "Wybierz", "Anuluj");
	    return 1;
	}

	if(Iter_Contains(Door, pickupid))
	{
	    new doorid = pickupid,
			string[256], lock_text[128], enter_pay[64];
	    
    	if(DoorCache[doorid][dEnterPay])
	  	{
	   		format(enter_pay, sizeof(enter_pay), "~w~~n~Koszt wstepu: ~g~$%d~n~", DoorCache[doorid][dEnterPay]);
	   	}
	    else
	    {
	    	format(enter_pay, sizeof(enter_pay), "_");
	    }
	    if(DoorCache[doorid][dLocked])
	    {
	        format(lock_text, sizeof(lock_text), "~r~~h~Drzwi sa zamkniete");
	    }
	    else
	    {
	    	format(lock_text, sizeof(lock_text), "~y~Aby wejsc, wcisnij jednoczesnie~n~~w~[~b~~h~~h~~k~~SNEAK_ABOUT~ + ~k~~PED_SPRINT~~w~]");
		}
		if(PlayerCache[playerid][pAdmin] & A_PERM_DOORS)
		{
		    format(string, sizeof(string), "%s (%d)~n~%s~n~%s", DoorCache[doorid][dName], doorid, enter_pay, lock_text);
		}
		else
		{
            format(string, sizeof(string), "%s~n~%s~n~%s", DoorCache[doorid][dName], enter_pay, lock_text);
		}
	    TD_ShowDoor(playerid, 5, string);
	}
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
	// Spectate
 	foreach(new i : Player)
  	{
   		if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
     	{
      		if(PlayerCache[i][pSpectate] == playerid)
        	{
         		SetPlayerInterior(i, newinteriorid);
         		SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
         	}
        }
   	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(newkeys == KEY_WALK + KEY_SPRINT)
		{
	        foreach(new doorid : Door)
	        {
				if(IsPlayerInRangeOfPoint(playerid, 2.0, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ]) && GetPlayerVirtualWorld(playerid) == DoorCache[doorid][dEnterVW])
          		{
					OnPlayerEnterDoor(playerid, doorid);
      				break;
  		      	}
     		   	else if(IsPlayerInRangeOfPoint(playerid, 2.0, DoorCache[doorid][dExitX], DoorCache[doorid][dExitY], DoorCache[doorid][dExitZ]) && GetPlayerVirtualWorld(playerid) == DoorCache[doorid][dExitVW])
       		 	{
					OnPlayerExitDoor(playerid, doorid);
					break;
      		  	}
	        }
		}

		// Strefa
		if(PlayerCache[playerid][pCreatingArea] != INVALID_AREA_ID)
		{
		    // PPM
		    if(newkeys & KEY_HANDBRAKE)
		    {
			    new areaid = PlayerCache[playerid][pCreatingArea], Float:PosZ;
			    GetPlayerPos(playerid, AreaCache[areaid][aMaxX], AreaCache[areaid][aMaxY], PosZ);

			    Iter_Remove(Area, areaid);
	            areaid = CreateArea(AreaCache[areaid][aMinX], AreaCache[areaid][aMinY], AreaCache[areaid][aMaxX], AreaCache[areaid][aMaxY]);
	            
	            GangZoneShowForPlayer(playerid, areaid, COLOR_AREA);
	            PlayerCache[playerid][pCreatingArea] = INVALID_AREA_ID;
	            
				ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Strefa (UID: %d) zosta�a pomy�lnie stworzona.\nSkorzystaj z komendy /strefa, by zarz�dza� wybran� stref�.", AreaCache[areaid][aUID]);
			}
			
			if(newkeys & KEY_SECONDARY_ATTACK)
			{
			    new areaid = PlayerCache[playerid][pCreatingArea];
			    
			    Iter_Remove(Area, areaid);
			    PlayerCache[playerid][pCreatingArea] = INVALID_AREA_ID;
			    
			    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Tworzenie strefy zosta�o anulowane.");
			}
		}
		
		// Akcesorie
		if(PlayerCache[playerid][pSelectAccess] != INVALID_ACCESS_ID)
		{
		    // Zatwierd�
		    if(newkeys & KEY_SECONDARY_ATTACK)
		    {
		        new access_id = PlayerCache[playerid][pSelectAccess];
		        if(PlayerCache[playerid][pCash] < AccessData[access_id][aPrice])
		        {
		            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie sta� Ci� na zakup tego akcesoria.");
		            return 1;
		        }
		        crp_GivePlayerMoney(playerid, -AccessData[access_id][aPrice]);
		        OnPlayerSave(playerid, SAVE_PLAYER_BASIC);
		        
       			ResetPlayerCamera(playerid);
				OnPlayerFreeze(playerid, false, 0);
		        
		        RemovePlayerAttachedObject(playerid, SLOT_TRYING);
		        GameTextForPlayer(playerid, "_", 0, 6);
		        
		        new doorid = GetPlayerDoorID(playerid),
					group_id = GetGroupID(DoorCache[doorid][dOwner]), group_activity = AccessData[access_id][aPrice];
		            
				GroupData[group_id][gCash] += floatround(0.3 * AccessData[access_id][aPrice]);
				GroupData[group_id][gActivity] += group_activity;
				
				SaveGroup(group_id);
				PlayerCache[playerid][pSelectAccess] = INVALID_ACCESS_ID;
		        
		        CreatePlayerItem(playerid, AccessData[access_id][aName], ITEM_CLOTH_ACCESS, 0, AccessData[access_id][aUID]);
				TD_ShowSmallInfo(playerid, 3, "Akcesorie zostalo ~y~kupione ~w~pomyslnie.~n~Przedmiot znajdziesz w swoim ~b~ekwipunku~w~.");
		    }
		    
		    // Anuluj
		    if(newkeys & KEY_JUMP)
		    {
		        ResetPlayerCamera(playerid);
				OnPlayerFreeze(playerid, false, 0);
				
    			RemovePlayerAttachedObject(playerid, SLOT_TRYING);
		        GameTextForPlayer(playerid, "_", 0, 6);
				
				PlayerCache[playerid][pSelectAccess] = INVALID_ACCESS_ID;
				TD_ShowSmallInfo(playerid, 3, "Zakup akcesoria zostal ~r~anulowany~w~.");
		    }
		}
		
		// Ubranie
		if(PlayerCache[playerid][pSelectSkin] != INVALID_SKIN_ID)
		{
		    // Zatwierd�
		    if(newkeys & KEY_SECONDARY_ATTACK)
		    {
		        new skin_id = PlayerCache[playerid][pSelectSkin];
		        if(PlayerCache[playerid][pCash] < SkinData[skin_id][sPrice])
		        {
		            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie sta� Ci� na zakup tego ubrania.");
		            return 1;
		        }
		        crp_GivePlayerMoney(playerid, -SkinData[skin_id][sPrice]);
		        OnPlayerSave(playerid, SAVE_PLAYER_BASIC);

       			ResetPlayerCamera(playerid);
				OnPlayerFreeze(playerid, false, 0);

		        GameTextForPlayer(playerid, "_", 0, 6);
		        
		        new doorid = GetPlayerDoorID(playerid),
					group_id = GetGroupID(DoorCache[doorid][dOwner]), group_activity = SkinData[skin_id][sPrice];

				GroupData[group_id][gCash] += floatround(0.3 * SkinData[skin_id][sPrice]);
				GroupData[group_id][gActivity] += group_activity;
				
				SaveGroup(group_id);
				
		        PlayerCache[playerid][pSelectSkin] = INVALID_SKIN_ID;
		        SetPlayerSkin(playerid, PlayerCache[playerid][pSkin]);
		        
		        CreatePlayerItem(playerid, SkinData[skin_id][sName], ITEM_CLOTH, SkinData[skin_id][sModel], 0);
				TD_ShowSmallInfo(playerid, 3, "Ubranie zostalo ~y~kupione ~w~pomyslnie.~n~Przedmiot znajdziesz w swoim ~b~ekwipunku~w~.");
		    }
		    
		    // Anuluj
		    if(newkeys & KEY_JUMP)
		    {
      			ResetPlayerCamera(playerid);
				OnPlayerFreeze(playerid, false, 0);

		        GameTextForPlayer(playerid, "_", 0, 6);
				PlayerCache[playerid][pSelectSkin] = INVALID_SKIN_ID;
				
    			SetPlayerSkin(playerid, PlayerCache[playerid][pSkin]);
				TD_ShowSmallInfo(playerid, 3, "Zakup ubrania zostal ~r~anulowany~w~.");
		    }
		}
		
		// Si�ownia
		if(PlayerCache[playerid][pGymObject] != INVALID_OBJECT_ID)
		{
		    new object_id = PlayerCache[playerid][pGymObject],
		        anim_id = GetPlayerAnimationIndex(playerid);
            
            // �aweczka
		    if(GetObjectModel(object_id) == OBJECT_BENCH)
		    {
		        if(newkeys == KEY_SECONDARY_ATTACK)
				{
		            ApplyAnimation(playerid, "BENCHPRESS", "gym_bp_getoff", 4.0, 0, 0, 0, 0, 0, true);
		            anim_id = GetPlayerAnimationIndex(playerid);
		        }
		    
				switch(anim_id)
				{
				    case 47:
				    {
						if(newkeys == KEY_SPRINT)
						{
						    PlayerCache[playerid][pMainTable] = gettime();
      						ApplyAnimation(playerid, "BENCHPRESS", "gym_bp_up_A", 4.0, 0, 0, 0, 1, 0, true);
						}
				    }
				    case 50:
				    {
						if(oldkeys == KEY_SPRINT)
						{
							ApplyAnimation(playerid, "BENCHPRESS", "gym_bp_down", 4.0, 0, 0, 0, 1, 0, true);
							
							if(PlayerCache[playerid][pMainTable] + 2 <= gettime())
							{
								PlayerCache[playerid][pGymRepeat] ++;
								PlayerCache[playerid][pMainTable] = gettime();
							}
							else													GameTextForPlayer(playerid, "~n~~n~~n~~r~Wyciskaj do konca!", 1000, 3);

							TD_ShowSmallInfo(playerid, 0, "Powtorzenia: ~b~~h~%d~n~~n~Mozesz sprobowac tez ~r~treningu ~w~po uzyciu ~y~odzywek~w~, ktore zakupisz w silowni.", PlayerCache[playerid][pGymRepeat]);
						}
				    }
				    default:
				    {
				        PlayerCache[playerid][pStrength] = (PlayerCache[playerid][pDrugType] == DRUG_CONDITIONER && PlayerCache[playerid][pGymRepeat] > 100) ? PlayerCache[playerid][pStrength] + ((PlayerCache[playerid][pGymRepeat] + PlayerCache[playerid][pDrugValue1]) / 8) : PlayerCache[playerid][pStrength] + (PlayerCache[playerid][pGymRepeat] / 8);
				    
				        PlayerCache[playerid][pGymObject] 	= INVALID_OBJECT_ID;
				        PlayerCache[playerid][pGymRepeat] 	= 0;
				        
				        RemovePlayerAttachedObject(playerid, SLOT_TRAIN);
				        TD_ShowSmallInfo(playerid, 3, "Trening zostal ~g~pomyslnie ~w~zakonczony.");
				    }
				}
		    }

		    // Hantelki
		    if(GetObjectModel(object_id) == OBJECT_BARBELL)
		    {
      			if(newkeys == KEY_SECONDARY_ATTACK)
				{
		            ApplyAnimation(playerid, "FREEWEIGHTS", "gym_free_putdown", 4.0, 0, 0, 0, 0, 0, true);
		            anim_id = GetPlayerAnimationIndex(playerid);
		        }
		    
		        switch(anim_id)
		        {
		            case 571:
		            {
           				if(oldkeys == KEY_SPRINT)
		                {
		                    ApplyAnimation(playerid, "FREEWEIGHTS", "gym_free_down", 4.0, 0, 0, 0, 1, 0, true);
		                    
   							if(PlayerCache[playerid][pMainTable] + 2 <= gettime())
							{
								PlayerCache[playerid][pGymRepeat] ++;
								PlayerCache[playerid][pMainTable] = gettime();
							}
							else													GameTextForPlayer(playerid, "~n~~n~~n~~r~Wyciskaj do konca!", 1000, 3);

							TD_ShowSmallInfo(playerid, 0, "Powtorzenia: ~b~~h~%d~n~~n~Mozesz sprobowac tez ~r~treningu ~w~po uzyciu ~y~odzywek~w~, ktore zakupisz w silowni.", PlayerCache[playerid][pGymRepeat]);
						}
		            }
		            case 573:
		            {
						if(newkeys == KEY_SPRINT)
						{
						    PlayerCache[playerid][pMainTable] = gettime();
      						ApplyAnimation(playerid, "FREEWEIGHTS", "gym_free_B", 4.0, 0, 0, 0, 1, 0, true);
						}
		            }
		            default:
		            {
		                PlayerCache[playerid][pStrength] = (PlayerCache[playerid][pDrugType] == DRUG_CONDITIONER && PlayerCache[playerid][pGymRepeat] > 100) ? PlayerCache[playerid][pStrength] + ((PlayerCache[playerid][pGymRepeat] + PlayerCache[playerid][pDrugValue1]) / 8) : PlayerCache[playerid][pStrength] + (PlayerCache[playerid][pGymRepeat] / 8);
		            
  				        PlayerCache[playerid][pGymObject] 	= INVALID_OBJECT_ID;
				        PlayerCache[playerid][pGymRepeat] 	= 0;

						RemovePlayerAttachedObject(playerid, SLOT_TRAIN);
				        TD_ShowSmallInfo(playerid, 3, "Trening zostal ~g~pomyslnie ~w~zakonczony.");
		            }
		        }
		    }
		}
		
		// Styl rozmowy
		if(PlayerCache[playerid][pSelectTalkStyle])
		{
		    if(newkeys & KEY_SECONDARY_ATTACK)
		    {
		        ResetPlayerCamera(playerid);
		        ClearAnimations(playerid, true);
		        
		        GameTextForPlayer(playerid, "_", 0, 6);
		        OnPlayerFreeze(playerid, false, 0);
		        
		        PlayerCache[playerid][pSelectTalkStyle] = false;
		    
				OnPlayerSave(playerid, SAVE_PLAYER_SETTING);
				TD_ShowSmallInfo(playerid, 3, "Wybrany styl zostal ~g~pomyslnie ~w~zapisany.");
		    }
		}
		
		// Przerywanie animacji
 		if(PlayerCache[playerid][pPlayAnim])
	 	{
	 	    if(newkeys & KEY_HANDBRAKE)
	 	    {
		        PlayerCache[playerid][pPlayAnim] = false;
		    	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, true);
			}
		}
		
		// Animacja chodzenia
		if(PlayerCache[playerid][pWalkStyle] != INVALID_ANIM_ID)
		{
  			if(newkeys & KEY_WALK)
  			{
       			new anim_id = PlayerCache[playerid][pWalkStyle];
       			if(AnimCache[anim_id][aAction])
       			{
       			    SetPlayerSpecialAction(playerid, AnimCache[anim_id][aAction]);
       			}
       			else
       			{
           			ApplyAnimation(playerid, AnimCache[anim_id][aLib], AnimCache[anim_id][aName], AnimCache[anim_id][aSpeed], AnimCache[anim_id][aOpt1], AnimCache[anim_id][aOpt2], AnimCache[anim_id][aOpt3], AnimCache[anim_id][aOpt4], AnimCache[anim_id][aOpt5], true);
				}
				PlayerCache[playerid][pPlayAnim] = true;
			}
		}
		
		// Wyb�r przystanku
		if(PlayerCache[playerid][pBusStart] != INVALID_OBJECT_ID && PlayerCache[playerid][pBusTravel] == INVALID_OBJECT_ID)
		{
		    if(newkeys & KEY_JUMP)
		    {
   				new object_id = GetClosestBusStop(playerid), string[128],
					Float:PosX, Float:PosY, Float:PosZ;
					
				if(object_id != INVALID_OBJECT_ID)
				{
					GetDynamicObjectPos(object_id, PosX, PosY, PosZ);

					SetPlayerCameraPos(playerid, PosX, PosY, PosZ + 30.0);
					SetPlayerCameraLookAt(playerid, PosX, PosY + 2, PosZ, CAMERA_MOVE);

					PlayerCache[playerid][pBusPosition][0] = PosX;
					PlayerCache[playerid][pBusPosition][1] = PosY;
					PlayerCache[playerid][pBusPosition][2] = PosZ;

					crp_SetPlayerPos(playerid, PosX, PosY, PosZ - 80.0);
					PlayerCache[playerid][pBusTravel] = object_id;

					new Float:Distance;
					Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, PlayerCache[playerid][pBusStart], Distance);
						
					PlayerCache[playerid][pBusTime] = floatround(Distance, floatround_floor) / 15;
					PlayerCache[playerid][pBusPrice] = floatround(Distance, floatround_floor) / 20;

					if(PlayerCache[playerid][pHours] < 5)	PlayerCache[playerid][pBusPrice] = 0;
						
 					format(string, sizeof(string), "Przejazd: %d <-> %d\n\nCzas trwania jazdy: %ds\nKoszt przejazdu: $%d\n\nCzy jeste� pewien, �e chcesz si� tutaj uda�?", GetObjectUID(PlayerCache[playerid][pBusStart]), GetObjectUID(PlayerCache[playerid][pBusTravel]), PlayerCache[playerid][pBusTime], PlayerCache[playerid][pBusPrice]);
  					ShowPlayerDialog(playerid, D_BUS_ACCEPT, DIALOG_STYLE_MSGBOX, "Bus", string, "Tak", "Nie");
  					
  					TD_HideSmallInfo(playerid);
				}
		    }
		    
		    if(newkeys & KEY_SECONDARY_ATTACK)
		    {
				new object_id = PlayerCache[playerid][pBusStart],
				    Float:PosX, Float:PosY, Float:PosZ;
				    
				GetDynamicObjectPos(object_id, PosX, PosY, PosZ);
				
				crp_SetPlayerPos(playerid, PosX, PosY, PosZ);
				ResetPlayerCamera(playerid);
				
				PlayerCache[playerid][pBusStart] 	= INVALID_OBJECT_ID;
				PlayerCache[playerid][pBusTravel]   = INVALID_OBJECT_ID;
				
				OnPlayerFreeze(playerid, false, 0);
				TD_ShowSmallInfo(playerid, 3, "Przejazdzka zostala ~r~anulowana~w~.");
		    }
		}
		
		// Jazda na rolkach
		if(PlayerCache[playerid][pRoll])
	    {
	        if(newkeys & KEY_SPRINT)
	        {
	     		if(GetPlayerSpeed(playerid, true) > 5)
	       		{
		        	ApplyAnimation(playerid, "SKATE", "skate_run", 3.0, 1, 1, 1, 1, 1, true);
			        PlayerCache[playerid][pPlayAnim] = true;
				}
			}
			
			if(oldkeys & KEY_SPRINT)
			{
			    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
			}
	    }
	    
	    // Palenie jointa
	    if(PlayerCache[playerid][pDrugType] == DRUG_MARIHUANA)
	    {
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_SMOKE_CIGGY)
			{
			    if(newkeys & KEY_FIRE)
			    {
					if(PlayerCache[playerid][pMainTable] + 3 <= gettime())
					{
					    PlayerCache[playerid][pDrugValue1] --;
					    if(PlayerCache[playerid][pDrugValue1] <= 0)	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
					    
						PlayerCache[playerid][pDrugLevel] ++;
						PlayerCache[playerid][pMainTable] = gettime();
						
						switch(PlayerCache[playerid][pDrugLevel])
						{
						    case 5:
						    {
								SetPlayerWeather(playerid, -2);
								SendClientMessage(playerid, COLOR_DO, "** Odczuwasz znaczne polepszenie nastroju, jeste� w fazie euforii. **");
						    }
						    case 15:
						    {
						        SetPlayerWeather(playerid, 170);
						        SendClientMessage(playerid, COLOR_DO, "** Twoje mi�nie s� rozlu�nione, jeste� lekko rozkojarzony. **");
						    }
						    case 20:
						    {
						        SetPlayerWeather(playerid, -38);
						        SendClientMessage(playerid, COLOR_DO, "** Odczuwasz znaczne pobudzenie wyobra�ni, stajesz si� bardziej wra�liwy. **");
						    }
						    case 30:
						    {
						        SetPlayerWeather(playerid, -15);
						        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
						    
                                ApplyAnimation(playerid, "CRACK" , "crckidle1", 4.1, 1, 0, 0, 1, 15000, true);
                                SendClientMessage(playerid, COLOR_DO, "** Jeste� ca�kowicie rozlu�niony, odczuwasz lekki bezw�ad n�g. **");
						    }
						}
					}
			    }
			}
	    }
	    
	    // Celowanie z broni
	    if(PlayerCache[playerid][pItemWeapon] != INVALID_ITEM_ID)
	    {
	   		if(GetPlayerWeapon(playerid) > 15 && GetPlayerWeapon(playerid) < 43)
			{
			    if(GetPlayerDrunkLevel(playerid) < 2500)
			    {
			        if(PlayerCache[playerid][pStrength] < 5000)
			        {
					    if(newkeys & 128)
						{
							SetPlayerDrunkLevel(playerid, 2500);
						}
						else
						{
							if(oldkeys & 128)
							{
								SetPlayerDrunkLevel(playerid, 0);
							}
						}
					}
				}
			}
	    }
	    
		// Rzuty do kosza
		if(PlayerCache[playerid][pBasketObject] != INVALID_OBJECT_ID)
		{
		    if(newkeys & KEY_HANDBRAKE)
			{
			    new object_id = PlayerCache[playerid][pBasketObject],
			        Float:oPosX, Float:oPosY, Float:oPosZ;
			        
			    GetDynamicObjectPos(object_id, oPosX, oPosY, oPosZ);
			    if(!IsPlayerInRangeOfPoint(playerid, 15.0, oPosX, oPosY, oPosZ))
			    {
  	    			DestroyDynamicObject(PlayerCache[playerid][pBasketBall]);

				    PlayerCache[playerid][pBasketObject] 	= INVALID_OBJECT_ID;
				    PlayerCache[playerid][pBasketBall]      = INVALID_OBJECT_ID;

					TD_ShowSmallInfo(playerid, 3, "Gra w kosza zostala ~r~zakonczona~w~.");
			        return 1;
			    }
			
			    new ball_object_id = PlayerCache[playerid][pBasketBall],
					Float:PosX, Float:PosY, Float:PosZ;
					
				GetPlayerPos(playerid, PosX, PosY, PosZ);
		        ApplyAnimation(playerid, "CAMERA", "camstnd_idleloop", 4.1, 0, 0, 0, 1, 0, true);
		        
		        GetXYInFrontOfPlayer(playerid, PosX, PosY, 0.2);
		        SetDynamicObjectPos(ball_object_id, PosX, PosY, PosZ + 0.3);
		        
		        TD_ShowSmallInfo(playerid, 0, "Wcisnij i przytrzymaj ~g~~k~~PED_FIREWEAPON~~w~, aby rzucic do kosza.~n~Pamietaj zeby dobrze ~y~przymierzyc!");
		    }
		    
		    if(GetPlayerAnimationIndex(playerid) == 239)
		    {
			    if(newkeys & KEY_FIRE)
			    {
					PlayerCache[playerid][pMainTable] = gettime();
			    }

			    if(oldkeys & KEY_FIRE)
			    {
			        new object_id = PlayerCache[playerid][pBasketObject], ball_object_id = PlayerCache[playerid][pBasketBall], Float:distance;
			        Streamer_GetDistanceToItem(PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ], STREAMER_TYPE_OBJECT, object_id, distance);

					new Float:vPosX, Float:vPosY, Float:vPosZ,
					    Float:oPosX, Float:oPosY, Float:oPosZ,
					    Float:tPosX, Float:tPosY, Float:tPosZ;
					
                    GetPlayerCameraFrontVector(playerid, vPosX, vPosY, vPosZ);

					tPosX = (PlayerCache[playerid][pPosX] + floatmul(vPosX, distance));
					tPosY = (PlayerCache[playerid][pPosY] + floatmul(vPosY, distance));
					tPosZ = (PlayerCache[playerid][pPosZ] + floatmul(vPosZ, distance));
					
					GetDynamicObjectPos(object_id, oPosX, oPosY, oPosZ);
					GetXYBehindOfObject(object_id, oPosX, oPosY, 0.5);
					
					MoveDynamicObject(ball_object_id, tPosX, tPosY, tPosZ, 10.0);
					ApplyAnimation(playerid, "BSKTBALL", "BBALL_Jump_Shot", 4.1, 0, 0, 0, 0, 0, true);
			    }
			}
		}
	    return 1;
	}
	
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
 		new vehid = GetPlayerVehicleID(playerid);
 		
		// Skakanie na rowerku
		new model = GetVehicleModel(vehid);
		if(model == 509 || model == 510 || model == 481)
  		{
  		    if(!IsPlayerInRangeOfPoint(playerid, 80.0, 1907.7548, -1402.8784, 13.1844))
  		    {
				if(newkeys & 1)
				{
	                ClearAnimations(playerid);
					TD_ShowSmallInfo(playerid, 5, "~r~Skakanie ~w~na rowerze poza skate parkiem nie jest ~y~dozwolone~w~.");
				}
			}
		}
 		
 		// Odpalanie silnika
	    if(newkeys == KEY_ACTION + KEY_FIRE)
	    {
  			cmd_silnik(playerid, "");
  			return 1;
	    }
	    
		// Zapalanie �wiate�
		if(newkeys & KEY_FIRE)
		{
  			if(GetVehicleLightsStatus(vehid) == 1)
     		{
	    		ChangeVehicleLightsStatus(vehid, false);
       		}
	        else
	        {
                ChangeVehicleLightsStatus(vehid, true);
			}
		}
		
		// Odczepianie holowanego pojazdu
		if(newkeys & KEY_NO)
		{
		    if(IsTrailerAttachedToVehicle(vehid))
		    {
		        DetachTrailerFromVehicle(vehid);
		    }
		}
		
		// Tworzenie wy�cigu
		if(PlayerCache[playerid][pRaceCreating])
		{
		    if(newkeys & KEY_FIRE)
		    {
		        if(RaceInfo[playerid][rPoint] < MAX_RACE_CP - 1)
		        {
		        	new checkpoint = RaceInfo[playerid][rPoint];
			        GetVehiclePos(vehid, RaceInfo[playerid][rCPX][checkpoint], RaceInfo[playerid][rCPY][checkpoint], RaceInfo[playerid][rCPZ][checkpoint]);

					GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~w~Checkpoint ~g~dodany", 3000, 3);
					RaceInfo[playerid][rPoint] ++;
					
					TD_ShowSmallInfo(playerid, 0, "Rozpoczales ~r~proces ~w~tworzenia wyscigu, ~g~legenda~w~:~n~~n~~y~~k~~VEHICLE_FIREWEAPON~ ~w~- stawia checkpoint~n~~y~~k~~VEHICLE_FIREWEAPON_ALT~ ~w~- ustala linie mety~n~~n~Checkpointy: ~y~%d/%d", RaceInfo[playerid][rPoint], MAX_RACE_CP);
		        }
		        else
		        {
		            GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~r~Limit checkpointow przekroczony! Ustal linie mety!", 3000, 3);
		        }
		    }
		    
		    if(newkeys & KEY_ACTION)
		    {
    			if(RaceInfo[playerid][rPoint] <= 2)
				{
			        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~r~Musza byc conajmniej 3 checkpointy!", 3000, 3);
			        return 1;
			    }
		        new checkpoint = RaceInfo[playerid][rPoint];
		        GetVehiclePos(vehid, RaceInfo[playerid][rCPX][checkpoint], RaceInfo[playerid][rCPY][checkpoint], RaceInfo[playerid][rCPZ][checkpoint]);

				PlayerCache[playerid][pRaceCreating] 	= false;
				PlayerCache[playerid][pRaceCheckpoints] = RaceInfo[playerid][rPoint];

                GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~w~Linia mety ~y~ustawiona", 3000, 3);
                TD_ShowSmallInfo(playerid, 10, "Postawiles ~y~linie mety~w~. Mozesz teraz zaprosic rywali do wyscigu komenda ~r~/wyscig zapros~w~.~n~~n~Zeby rozpoczac wyscig wpisz ~y~/wyscig start~w~.~n~Mozesz takze zapisac trase (~p~~h~/wyscig zapisz~w~).");
		    }
		}
		return 1;
	}
	
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
	    if(PlayerCache[playerid][pSpectate] != INVALID_PLAYER_ID)
	    {
	        if(newkeys & KEY_WALK)
	        {
                new spectate_player = Iter_Prev(Player, PlayerCache[playerid][pSpectate]);
                if(!Iter_Contains(Player, spectate_player)) spectate_player = Iter_Last(Player);
                
 				SetPlayerInterior(playerid, GetPlayerInterior(spectate_player));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(spectate_player));
                
				switch(GetPlayerState(spectate_player))
				{
					case 0, 1, 7, 8:	PlayerSpectatePlayer(playerid, spectate_player);
					case 2, 3:			PlayerSpectateVehicle(playerid , GetPlayerVehicleID(spectate_player));
				}
				
                PlayerCache[playerid][pSpectate] = spectate_player;
	        }
	        
	        if(newkeys & KEY_SPRINT)
	        {
         		new spectate_player = Iter_Next(Player, PlayerCache[playerid][pSpectate]);
                if(!Iter_Contains(Player, spectate_player)) spectate_player = Iter_First(Player);

				SetPlayerInterior(playerid, GetPlayerInterior(spectate_player));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(spectate_player));

				switch(GetPlayerState(spectate_player))
				{
					case 0, 1, 7, 8:	PlayerSpectatePlayer(playerid, spectate_player);
					case 2, 3:			PlayerSpectateVehicle(playerid , GetPlayerVehicleID(spectate_player));
				}

                PlayerCache[playerid][pSpectate] = spectate_player;
	        }
	    }
	}
	
	if(PlayerCache[playerid][pFlashLight])
	{
	    if(newkeys & KEY_NO)
	    {
			ApplyAnimation(playerid, "COLT45", "colt45_fire", 4.1, 0, 0, 0, 0, 0, true);
	        //SetPlayerAttachedObject(playerid, 0, 18656, 6, 0.107000, -0.009000, -0.117999, -90.900054, -3.299999, -6.399999, 0.034000, 0.024999, 0.035000);
	    }
	    else if(oldkeys & KEY_YES)
	    {
	        //RemovePlayerAttachedObject(playerid, 0);
	    }
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	if(!success)
	{
		new IP[16];
		foreach(new i : Player)
		{
			if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
			{
			    if(PlayerCache[i][pAdmin] < A_PERM_MAX)
			    {
				    GetPlayerIp(i, IP, sizeof(IP));
				    if(!strcmp(IP, ip, true))
				    {
				        Kick(i);
				        break;
				    }
				}
			}
		}
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	// Przyczep obiekt broni do gracza
	if(PlayerCache[playerid][pItemWeapon] != INVALID_ITEM_ID)
	{
		if(GetPlayerWeapon(playerid) == 0)
		{
  			new itemid = PlayerCache[playerid][pItemWeapon], weapon_id = ItemCache[itemid][iValue1];
			if(!IsPlayerAttachedObjectSlotUsed(playerid, SLOT_WEAPON))
			{
			    switch(GetWeaponType(weapon_id))
			    {
       				case WEAPON_TYPE_LIGHT:
			        {
           				SetPlayerAttachedObject(playerid, SLOT_WEAPON, WeaponInfoData[weapon_id][wModel], 8, 0.0, -0.1, 0.15, -100.0, 0.0, 0.0);
			        }
			        case WEAPON_TYPE_MELEE:
			        {
           				SetPlayerAttachedObject(playerid, SLOT_WEAPON, WeaponInfoData[weapon_id][wModel], 7, 0.0, 0.0, -0.18, 100.0, 45.0, 0.0);
			        }
			        case WEAPON_TYPE_HEAVY:
			        {
           				SetPlayerAttachedObject(playerid, SLOT_WEAPON, WeaponInfoData[weapon_id][wModel], 1, 0.2, -0.125, -0.1, 0.0, 25.0, 180.0);
  			        }
  			    }
			}
		}
		else
		{
  			if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_WEAPON))
    		{
				RemovePlayerAttachedObject(playerid, SLOT_WEAPON);
			}
		}
	}
    // Selektor akcesorii
	if(PlayerCache[playerid][pSelectAccess] != INVALID_ACCESS_ID)
	{
		new keysa, uda, lra, string[64];
		GetPlayerKeys(playerid, keysa, uda, lra);
	
		// Strza�ka w lewo
  		if(lra < 0)
    	{
			new access_id = Iter_Prev(Access, PlayerCache[playerid][pSelectAccess]);
			if(!Iter_Contains(Access, access_id))	access_id = Iter_Last(Access);

			SetPlayerAttachedObject(playerid, SLOT_TRYING, AccessData[access_id][aModel], AccessData[access_id][aBone], AccessData[access_id][aPosX], AccessData[access_id][aPosY], AccessData[access_id][aPosZ], AccessData[access_id][aRotX], AccessData[access_id][aRotY], AccessData[access_id][aRotZ], AccessData[access_id][aScaleX], AccessData[access_id][aScaleY], AccessData[access_id][aScaleZ]);

			format(string, sizeof(string), "$~g~%d", AccessData[access_id][aPrice]);
			GameTextForPlayer(playerid, string, 10000, 6);

			PlayerCache[playerid][pSelectAccess] = access_id;
		}

		// Strza�ka w prawo
   		if(lra > 0)
	    {
  			new access_id = Iter_Next(Access, PlayerCache[playerid][pSelectAccess]);
  			if(!Iter_Contains(Access, access_id))	access_id = Iter_First(Access);

			SetPlayerAttachedObject(playerid, SLOT_TRYING, AccessData[access_id][aModel], AccessData[access_id][aBone], AccessData[access_id][aPosX], AccessData[access_id][aPosY], AccessData[access_id][aPosZ], AccessData[access_id][aRotX], AccessData[access_id][aRotY], AccessData[access_id][aRotZ], AccessData[access_id][aScaleX], AccessData[access_id][aScaleY], AccessData[access_id][aScaleZ]);

			format(string, sizeof(string), "$~g~%d", AccessData[access_id][aPrice]);
			GameTextForPlayer(playerid, string, 10000, 6);

			PlayerCache[playerid][pSelectAccess] = access_id;
   		}
	}

	// Selektor skin�w
	if(PlayerCache[playerid][pSelectSkin] != INVALID_SKIN_ID)
	{
		new keysa, uda, lra, string[64];
		GetPlayerKeys(playerid, keysa, uda, lra);

		// Strza�ka w lewo
  		if(lra < 0)
    	{
     		new skin_id = Iter_Prev(Skin, PlayerCache[playerid][pSelectSkin]);
       		if(!Iter_Contains(Skin, skin_id))   skin_id = Iter_Last(Skin);

			SetPlayerSkin(playerid, SkinData[skin_id][sModel]);

			format(string, sizeof(string), "$~g~%d", SkinData[skin_id][sPrice]);
   			GameTextForPlayer(playerid, string, 10000, 6);

			PlayerCache[playerid][pSelectSkin] = skin_id;
   		}

		// Strza�ka w prawo
	 	if(lra > 0)
		{
			new skin_id = Iter_Next(Skin, PlayerCache[playerid][pSelectSkin]);
			if(!Iter_Contains(Skin, skin_id))   skin_id = Iter_First(Skin);

			SetPlayerSkin(playerid, SkinData[skin_id][sModel]);

			format(string, sizeof(string), "$~g~%d", SkinData[skin_id][sPrice]);
   			GameTextForPlayer(playerid, string, 10000, 6);

			PlayerCache[playerid][pSelectSkin] = skin_id;
   		}
	}

	// Selektor stylu rozmowy
	if(PlayerCache[playerid][pSelectTalkStyle])
	{
		new keysa, uda, lra, string[64];
		GetPlayerKeys(playerid, keysa, uda, lra);

		// Strza�ka w lewo
 		if(lra < 0)
		{
  			PlayerCache[playerid][pTalkStyle] --;
			if(PlayerCache[playerid][pTalkStyle] < 0)  PlayerCache[playerid][pTalkStyle] = sizeof(TalkStyleData) - 1;

			new talk_style = PlayerCache[playerid][pTalkStyle];
			ApplyAnimation(playerid, TalkStyleData[talk_style][0], TalkStyleData[talk_style][1], 4.0, 1, 0, 0, 1, 0, true);

			format(string, sizeof(string), "~y~~h~%s", TalkStyleData[talk_style][2]);
			GameTextForPlayer(playerid, string, 10000, 6);
		}

		// Strza�ka w prawo
  		if(lra > 0)
		{
  			PlayerCache[playerid][pTalkStyle] ++;
	    	if(PlayerCache[playerid][pTalkStyle] >= sizeof(TalkStyleData)) PlayerCache[playerid][pTalkStyle] = 0;

			new talk_style = PlayerCache[playerid][pTalkStyle];
			ApplyAnimation(playerid, TalkStyleData[talk_style][0], TalkStyleData[talk_style][1], 4.0, 1, 0, 0, 1, 0, true);

			format(string, sizeof(string), "~y~~h~%s", TalkStyleData[talk_style][2]);
			GameTextForPlayer(playerid, string, 10000, 6);
		}
	}

	// Wyb�r przystanku
	if(PlayerCache[playerid][pBusStart] != INVALID_OBJECT_ID)
	{
		new keysa, uda, lra;
		GetPlayerKeys(playerid, keysa, uda, lra);

		if(lra != 0 || uda != 0)
		{
			// Strza�ka w lewo
			if(lra < 0)	PlayerCache[playerid][pBusPosition][0] -= 10.0;

			// Strza�ka w prawo
 			if(lra > 0)	PlayerCache[playerid][pBusPosition][0] += 10.0;

			// Strza�ka w g�r�
			if(uda > 0)	PlayerCache[playerid][pBusPosition][1] -= 10.0;

			// Strza�ka w d�
			if(uda < 0)	PlayerCache[playerid][pBusPosition][1] += 10.0;

			SetPlayerCameraPos(playerid, PlayerCache[playerid][pBusPosition][0], PlayerCache[playerid][pBusPosition][1], PlayerCache[playerid][pBusPosition][2] + 60.0);
			SetPlayerCameraLookAt(playerid, PlayerCache[playerid][pBusPosition][0], PlayerCache[playerid][pBusPosition][1] + 2, PlayerCache[playerid][pBusPosition][2]);
		}
	}
	
	// Pozycja 3D Tekstu
	if(PlayerCache[playerid][pEdit3DText] != INVALID_3DTEXT_ID)
	{
		new keysa, uda, lra, label_id = PlayerCache[playerid][pEdit3DText],
			Float:PosX, Float:PosY, Float:PosZ, Float:Multiplier = 0.5;

		GetPlayerKeys(playerid, keysa, uda, lra);

		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_X, PosX);
		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_Y, PosY);
		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_Z, PosZ);

		if((keysa & KEY_WALK))
		{
			Multiplier = 0.1;
		}
		else if((keysa & KEY_SPRINT))
		{
            Multiplier = 1.0;
		}

		if(!(keysa & KEY_JUMP))
		{
			if(uda < 0)
			{
			    Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_Y, PosY - Multiplier);
			}
			else if(uda > 0)
			{
			    Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_Y, PosY + Multiplier);
			}
			else if(lra < 0)
			{
			    Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_X, PosX + Multiplier);
			}
			else if(lra > 0)
			{
			    Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_X, PosX - Multiplier);
			}
		}

		if((keysa & KEY_JUMP))
		{
		    if(uda < 0)
		    {
		        Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_Z, PosZ + Multiplier);
		    }
		    else if(uda > 0)
		    {
		        Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_Z, PosZ - Multiplier);
		    }
		}
		Streamer_Update(playerid);

		SetPlayerCameraPos(playerid, PosX + 3, PosY + 4, PosZ + 4);
		SetPlayerCameraLookAt(playerid, PosX, PosY, PosZ);
	}
	
	if(PlayerCache[playerid][pAFK] > 0)
	{
	    if(PlayerCache[playerid][pDutyAdmin])
	    {
			PlayerCache[playerid][pSession][SESSION_ADMIN] += PlayerCache[playerid][pAFK];
	    }
	    
	    if(PlayerCache[playerid][pDutyGroup])
	    {
	        PlayerCache[playerid][pSession][SESSION_GROUP] += PlayerCache[playerid][pAFK];
	    }
	    
	    PlayerCache[playerid][pSession][SESSION_AFK] += PlayerCache[playerid][pAFK];
	}

	PlayerCache[playerid][pAFK] = -5;
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(!PlayerCache[playerid][pLogged] || !PlayerCache[playerid][pSpawned])
	{
	    return 1;
	}
	
	if(issuerid != INVALID_PLAYER_ID)
	{
		if(PlayerCache[issuerid][pItemWeapon] != INVALID_ITEM_ID)
  		{
    		if(weaponid > 15 && weaponid < 39)
		    {
	 			new itemid = PlayerCache[issuerid][pItemWeapon],
					weapon_id = ItemCache[itemid][iValue1];
					
				if(weaponid == weapon_id)
				{
				    /*
					// Infinite ammo
					new weapon_ammo = GetPlayerWeaponAmmo(issuerid, weapon_id);
					if(IsPlayerAiming(issuerid) && ((ItemCache[itemid][iValue2] - weapon_ammo) > 0))
					{
					*/
					    //ItemCache[itemid][iValue2] = weapon_ammo;
					    if(ItemCache[itemid][iType] == ITEM_INHIBITOR)
					    {
							ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 0, 0, 0, 1, 0, true);
							crp_SetPlayerHealth(playerid, PlayerCache[playerid][pHealth]);

							OnPlayerFreeze(playerid, true, 5);
							TD_ShowSmallInfo(playerid, 3, "Zostales ~r~sparalizowany~w~. Nie mozesz sie ruszyc.");
					        return 1;
					    }
					    if(PlayerCache[playerid][pDrugType] != DRUG_HEROIN)	ApplyAnimation(playerid, "CRACK" , "crckidle1", 4.1, 1, 0, 0, 1, 0, 1);
					/*}
					else
					{
						SendClientMessage(issuerid, COLOR_RED, "Nie u�ywaj InfinityAmmo!");
					    return 1;
					}
					*/
				}
				else
				{
				   	new string[128], weapon_name[32];
					GetWeaponName(weaponid, weapon_name, sizeof(weapon_name));

					format(string, sizeof(string), "WeaponHack (weapID: %d, weapName: %s).", weaponid, weapon_name);
					GivePlayerPunish(issuerid, INVALID_PLAYER_ID, PUNISH_BAN, string, 365, 0);
				}
			}
	    }
	    
	  	if(!weaponid)
	  	{
	  	    new Float:fist_attack = (PlayerCache[issuerid][pDrugType] == DRUG_COCAINE) ? (PlayerCache[issuerid][pStrength] + (PlayerCache[issuerid][pDrugLevel] * 20)) : (PlayerCache[issuerid][pStrength]);
			if(PlayerCache[playerid][pDrugType] != DRUG_NONE)
			{
		 		if(PlayerCache[playerid][pDrugType] == DRUG_MARIHUANA)
				{
					fist_attack += 0.30;
		   		}
		   		
		   		if(PlayerCache[playerid][pDrugType] == DRUG_HEROIN)
		   		{
		   		    // fist_attack -= PlayerCache[playerid][pDrugLevel];
		   		}
			}
			fist_attack = (0.0001 * fist_attack);
			PlayerCache[playerid][pHealth] -= fist_attack;
		}
	}
	PlayerCache[playerid][pHealth] -= amount;
	SetPlayerHealth(playerid, PlayerCache[playerid][pHealth]);
	
	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pNameTag], E_STREAMER_COLOR, 0xFF040088);
	defer OnResetPlayerNameTagColor[500](playerid);
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if(damagedid != INVALID_PLAYER_ID && weaponid != 0)
	{
	    // AntyWeaponHack
	    if(PlayerCache[playerid][pItemWeapon] != INVALID_ITEM_ID)
	    {
	        new itemid = PlayerCache[playerid][pItemWeapon];
	        if(ItemCache[itemid][iValue1] != weaponid)
	        {
				new string[128], weapon_name[32];
				GetWeaponName(weaponid, weapon_name, sizeof(weapon_name));

				format(string, sizeof(string), "WeaponHack (weapID: %d, weapName: %s).", weaponid, weapon_name);
				GivePlayerPunish(playerid, INVALID_PLAYER_ID, PUNISH_BAN, string, 365, 0);
				return 1;
	        }
	    }
	    else
	    {
			new string[128], weapon_name[32];
			GetWeaponName(weaponid, weapon_name, sizeof(weapon_name));

			format(string, sizeof(string), "WeaponHack (weapID: %d, weapName: %s).", weaponid, weapon_name);
			GivePlayerPunish(playerid, INVALID_PLAYER_ID, PUNISH_BAN, string, 365, 0);
	        return 1;
	    }
	}
	return 1;
}


public OnPlayerStreamIn(playerid, forplayerid)
{
	Streamer_Update(forplayerid);
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
	// Anty Crasher
	if(strlen(inputtext))
	{
 		for(new i = 0; inputtext[i] != 0; i++)
		{
			if(inputtext[i] == '%')
			{
				inputtext[i] = '#';
			}
		}
	}

	if(dialogid == D_NONE)
	{
	    if(response)
	    {
	    	return 1;
		}
		else
		{
		    return 1;
		}
	}
	
	if(dialogid == D_LOGIN)
	{
	    if(response)
	    {
	        new password[64];
	        if(strlen(inputtext) >= 32 || strlen(inputtext) <= 0)
	        {
				PlayerCache[playerid][pLogTries] --;
				ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Panel logowania", "Witaj na "SERVER_NAME"!\n\nWprowad� poni�ej has�o do postaci, by rozpocz�� gr� na naszym serwerze.\nUpewnij si�, �e posta� zosta�a za�o�ona na naszej stronie "WEB_URL".", "Zaloguj", "Zmie� nick");

				TD_ShowSmallInfo(playerid, 5, "Postac ~r~nie istnieje ~w~w bazie danych lub wprowadzone haslo jest nieprawidlowe.");
				return 1;
			}
			
			mysql_escape_string(inputtext, password, 64);
			bcrypt_check(password, PlayerCache[playerid][pPassword], "OnPlayerPasswordChecked", "d", playerid);
			return 1;
		}
	    else
	    {
	        /*
	        ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Informacja", "Opuszczasz gr� - zapraszamy ponownie.\n\n\t\t\tEkipa "SERVER_NAME".", "Zamknij", "");
			defer OnKickPlayer(playerid);
			*/
			
			// Tutaj zmiana nicku...
			return 1;
		}
	}
	
    printf("[dial] %s (UID: %d, GID: %d): [%s] (%d, %d, %d)", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], inputtext, playerid, dialogid, response);
	
	if(dialogid == D_STATS)
	{
	    if(response)
	    {
			if(!strval(inputtext) || PlayerCache[playerid][pBW])  return 1;
			new list_item = strval(inputtext);
			
			if(list_item == 1)
			{
  				new Float:PosX, Float:PosY, Float:PosZ, string[64];
				GetPlayerPos(playerid, PosX, PosY, PosZ);

				GetXYInFrontOfPlayer(playerid, PosX, PosY, 3.0);
				SetPlayerCameraPos(playerid, PosX, PosY, PosZ + 1.0);

				GetPlayerPos(playerid, PosX, PosY, PosZ);
				SetPlayerCameraLookAt(playerid, PosX, PosY, PosZ);

				OnPlayerFreeze(playerid, true, 0);
				PlayerCache[playerid][pSelectTalkStyle] = true;

				new talk_style = PlayerCache[playerid][pTalkStyle];
                ApplyAnimation(playerid, TalkStyleData[talk_style][0], TalkStyleData[talk_style][1], 4.0, 1, 0, 0, 1, 0, true);
                
				format(string, sizeof(string), "~y~~h~%s", TalkStyleData[talk_style][2]);
				GameTextForPlayer(playerid, string, 10000, 6);
                
				TD_ShowSmallInfo(playerid, 0, "Wybor stylu ~y~aktywny~w~. Uzywaj strzalek, by poruszac sie miedzy ~b~~h~stylami ~w~rozmowy.~n~~n~Klawisz ~r~~k~~VEHICLE_ENTER_EXIT~ ~w~zapisuje styl.");
				return 1;
			}
			
			if(list_item == 2)
			{
			    if(PlayerCache[playerid][pWalkStyle] != INVALID_ANIM_ID)
			    {
			        PlayerCache[playerid][pWalkStyle] = INVALID_ANIM_ID;
					OnPlayerSave(playerid, SAVE_PLAYER_SETTING);
			        
			        TD_ShowSmallInfo(playerid, 3, "Animacja chodzenia ~r~wylaczona~w~.");
			        return 1;
			    }
			
  				new list_anims[1024];
				foreach(new anim_id : Anim)
				{
				    format(list_anims, sizeof(list_anims), "%s\n%s", list_anims, AnimCache[anim_id][aCommand]);
				}

				if(strlen(list_anims))
				{
				    ShowPlayerDialog(playerid, D_WALK_ANIM, DIALOG_STYLE_LIST, "Lista animacji:", list_anims, "Start", "Zamknij");
				}
				else
				{
				    TD_ShowSmallInfo(playerid, 3, "Nie znaleziono ~r~zadnych ~w~animacji.");
				}
			    return 1;
			}
			
			if(list_item == 3)
			{
			    if(PlayerCache[playerid][pOOC])
			    {
			        PlayerCache[playerid][pOOC] = false;
			        TD_ShowSmallInfo(playerid, 5, "Czat OOC ~r~wylaczony~w~.~n~Wiadomosci na ~y~/b ~w~nie beda juz widoczne na czacie.");
			    }
			    else
			    {
       				PlayerCache[playerid][pOOC] = true;
			        TD_ShowSmallInfo(playerid, 5, "Czat OOC ~g~wlaczony~w~.~n~Wiadomosci na ~y~/b ~w~beda teraz widoczne na czacie.");
			    }
				OnPlayerSave(playerid, SAVE_PLAYER_SETTING);
			    return 1;
			}
			
			if(list_item == 4)
			{
			    if(PlayerCache[playerid][pFirstPersonObject] == INVALID_OBJECT_ID)
			    {
			        new object_id = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0);
					AttachObjectToPlayer(object_id, playerid, 0.0, 0.10, 0.65, 0.0, 0.0, 0.0);

					AttachCameraToObject(playerid, object_id);
					PlayerCache[playerid][pFirstPersonObject] = object_id;
					
					TD_ShowSmallInfo(playerid, 3, "Kamera ~y~FPS ~w~zostala pomyslnie ~g~wlaczona~w~.");
			    }
			    else
			    {
					DestroyObject(PlayerCache[playerid][pFirstPersonObject]);
					PlayerCache[playerid][pFirstPersonObject] = INVALID_OBJECT_ID;
					
					ResetPlayerCamera(playerid);
					TD_ShowSmallInfo(playerid, 3, "Kamera ~y~FPS ~w~zostala pomyslnie ~r~wylaczona~w~.");
			    }
			    return 1;
			}
	        return 1;
	    }
	    else
	    {
			return 1;
		}
	}
	if(dialogid == D_PERMS)
	{
	    if(response)
	    {
	        new giveplayer_id = strval(inputtext), list_perms[256],
				admin_perms = PlayerCache[giveplayer_id][pAdmin];

			format(list_perms, sizeof(list_perms), "{C0C0C0}Uprawnienia administratora %s:{FFFFFF}\n%d", PlayerName(giveplayer_id), admin_perms);
			ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_LIST, "Uprawnienia", list_perms, "OK", "");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_INTRO)
	{
	    if(response)
	    {
	        ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Wprowadzenie (2/2)", "Kiedy dotrzesz ju� na miejsce, na pocz�tek wyr�b niezb�dne do gry dokumenty,\nto wszystko mo�e przyda� Ci si� podczas rozgrywki.\n\nJe�eli zaopatrzysz si� w odpowiednie przedmioty, b�dziesz m�g� przyst�pi�\ndo poszukiwania pracy, dzi�ki kt�rej zarobisz swoje pierwsze pieni�dze.\nMo�esz zrobi� to za pomoc� Urz�du, lub odwiedzaj�c firmy osobi�cie.\n\n�yczymy mi�ej gry na serwerze!", "OK", "");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_SEND_PW)
	{
 		if(response)
	    {
	        new giveplayer_id = PlayerCache[playerid][pMainTable], string[256];
	        inputtext[0] = chrtoupper(inputtext[0]);

	        format(string, sizeof(string), "%d %s", giveplayer_id, inputtext);
	        cmd_w(playerid, string);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_PLAYER_LIST)
	{
		if(response)
		{
		    new clickedplayerid = strval(inputtext);
		    OnPlayerClickPlayer(playerid, clickedplayerid, 0);
		    return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_GROUP_TYPE)
	{
	    if(response)
	    {
	    	new group_id = PlayerCache[playerid][pMainTable], group_type = strval(inputtext) - 1;
	    	
	    	GroupData[group_id][gType] 	= 	group_type;
	    	GroupData[group_id][gFlags] = 	GroupTypeInfo[group_type][gTypeFlags];
	    	
			mysql_query_format("UPDATE `"SQL_PREF"groups` SET group_type = '%d', group_flags = '%d' WHERE group_uid = '%d' LIMIT 1", GroupData[group_id][gType], GroupData[group_id][gFlags], GroupData[group_id][gUID]);
	    	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Typ grupy %s (SampID: %d, UID: %d) zosta� pomy�lnie zmieniony na %s.", GroupData[group_id][gName], group_id, GroupData[group_id][gUID], GroupTypeInfo[GroupData[group_id][gType]][gTypeName]);
			return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_SPAWN_VEH)
	{
	    if(response)
	    {
			new veh_uid, veh_name[32];
			sscanf(inputtext, "ds[32]", veh_uid, veh_name);
			
			new vehid = GetVehicleID(veh_uid);
			
			if(vehid == INVALID_VEHICLE_ID)
			{
			    if(GetPlayerSpawnedVehicles(playerid) >= ((IsPlayerPremium(playerid)) ? PACC_VEHICLES : FACC_VEHICLES))
			    {
			        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Masz ju� zespawnowan� maksymaln� ilo�� pojazd�w, odspawnuj jaki� pojazd.");
					return 1;
			    }
			    
			    vehid = LoadVehicle(veh_uid);
			    
			    TD_ShowSmallInfo(playerid, 3, "Zespawnowano pojazd ~y~%s ~w~(UID: %d).", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID]);
			    printf("[cars] %s (UID: %d, GID: %d) zespawnowa� pojazd %s (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID]);
			}
			else
			{
 				DestroyVehicle(vehid);
				Iter_Remove(Vehicles, vehid);
				
				SaveVehicle(vehid, SAVE_VEH_COUNT);
				
				TD_ShowSmallInfo(playerid, 3, "Odspawnowano pojazd ~y~%s ~w~(UID: %d).", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID]);
				printf("[cars] %s (UID: %d, GID: %d) odspawnowa� pojazd %s (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID]);
			}
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_TARGET_VEH)
	{
	    if(response)
	    {
	        new vehid = strval(inputtext), Float:VehPosX, Float:VehPosY, Float:VehPosZ;
	        GetVehiclePos(vehid, VehPosX, VehPosY, VehPosZ);

	        SetPlayerCheckpoint(playerid, VehPosX, VehPosY, VehPosZ, 5.0);
	        PlayerCache[playerid][pCheckpoint] = CHECKPOINT_VEHICLE;

	        TD_ShowSmallInfo(playerid, 3, "Pojazd ~y~%s ~w~(UID: %d) zostal ~r~namierzony~w~.~n~Komenda ~b~/v namierz ~w~anuluje namierzanie.", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID]);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ASSIGN_VEH)
	{
	    if(response)
	    {
	        new group_slot = strval(inputtext) - 1, vehid = GetPlayerVehicleID(playerid), string[256];
			if(vehid == INVALID_VEHICLE_ID)
  			{
  			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w poje�dzie, kt�ry chcesz przypisa�.");
   				return 1;
    		}
		    if(CarInfo[vehid][cOwnerType] == OWNER_NONE)
		    {
	         	ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego pojazdu.");
		        return 1;
		    }
	   		if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER && CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID])
			{
	            ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego pojazdu.");
				return 1;
			}
			if(CarInfo[vehid][cOwnerType] == OWNER_GROUP)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten pojazd jest ju� przypisany pod grup�.");
			    return 1;
			}
			if(!HavePlayerGroupPerm(playerid, PlayerGroup[playerid][group_slot][gpUID], G_PERM_LEADER))
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz do tego odpowiednich uprawnie�.");
			    return 1;
			}
    		new group_id = PlayerGroup[playerid][group_slot][gpID];
    		PlayerCache[playerid][pMainTable] = group_id;

    		format(string, sizeof(string), "Czy chcesz przypisa� pojazd %s (SampID: %d, UID: %d) pod grup� %s (UID: %d)?", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID], GroupData[group_id][gName], GroupData[group_id][gUID]);
    		ShowPlayerDialog(playerid, D_ASSIGN_VEH_ACCEPT, DIALOG_STYLE_MSGBOX, "Pojazd � Przypisz pod grup�", string, "Tak", "Nie");
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ASSIGN_VEH_ACCEPT)
	{
		if(response)
		{
		    new vehid = GetPlayerVehicleID(playerid);
      		if(vehid == INVALID_VEHICLE_ID)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w poje�dzie, kt�ry chcesz przypisa�.");
	            return 1;
	        }
    	    if(CarInfo[vehid][cOwnerType] == OWNER_NONE)
		    {
	         	ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego pojazdu.");
		        return 1;
		    }
	   		if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER && CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID])
			{
	            ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego pojazdu.");
				return 1;
			}
			if(CarInfo[vehid][cOwnerType] == OWNER_GROUP)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten pojazd jest ju� przypisany pod grup�.");
			    return 1;
			}
			new group_id = PlayerCache[playerid][pMainTable];

	        CarInfo[vehid][cOwnerType] = OWNER_GROUP;
	        CarInfo[vehid][cOwner] = GroupData[group_id][gUID];
	        
			SaveVehicle(vehid, SAVE_VEH_THINGS);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd %s (SampID: %d, UID: %d) zosta� pomy�lnie przypisany pod grupy�.\nPojazd przypisano dla grupy %s (UID: %d).", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID], GroupData[group_id][gName], GroupData[group_id][gUID]);

            printf("[cars] %s (UID: %d, GID: %d) przypisa� pojazd %s (UID: %d) pod grup� %s (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID], GroupData[group_id][gName], GroupData[group_id][gUID]);
			return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_MANAGE_VEH)
	{
	    if(response)
	    {
	        new vehid = GetPlayerVehicleID(playerid);
	        switch(listitem)
	        {
	            case 0:
	            {
	                if(GetVehicleBonnetStatus(vehid) == 1)
	                {
               			ChangeVehicleBonnetStatus(vehid, false);
	                    TD_ShowSmallInfo(playerid, 3, "Maska zostala pomyslnie ~r~zamknieta~w~.");
	                }
	                else
	                {
                 		ChangeVehicleBonnetStatus(vehid, true);
	                    TD_ShowSmallInfo(playerid, 3, "Maska zostala pomyslnie ~g~otwarta~w~.");
	                }
	            }
	            case 1:
	            {
             		if(GetVehicleBootStatus(vehid) == 1)
	                {
              			ChangeVehicleBootStatus(vehid, false);
	                    TD_ShowSmallInfo(playerid, 3, "Bagaznik zostal pomyslnie ~r~zamkniety~w~.");
	                }
	                else
	                {
                 		ChangeVehicleBootStatus(vehid, true);
	                    TD_ShowSmallInfo(playerid, 3, "Bagaznik zostal pomyslnie ~g~otwarty~w~.");
	                }
	            }
	            case 2:
	            {
          			if(GetVehicleLightsStatus(vehid) == 1)
		     		{
			    		ChangeVehicleLightsStatus(vehid, false);
			    		TD_ShowSmallInfo(playerid, 3, "Swiatla zostaly pomyslnie ~r~wylaczone~w~.", 5000, 3);
		       		}
			        else
			        {
		         		ChangeVehicleLightsStatus(vehid, true);
						TD_ShowSmallInfo(playerid, 3, "Swiatla zostaly pomyslnie ~g~wlaczone~w~.", 5000, 3);
					}
	            }
	            case 3:
	            {
	                if(CarInfo[vehid][cGlass])
	                {
	                    CarInfo[vehid][cGlass] = false;
	                    TD_ShowSmallInfo(playerid, 5, "Szyba zostala pomyslnie ~g~otwarta~w~.~n~Czat ~y~bedzie teraz ~w~widoczny poza pojazdem.", 5000, 3);
					}
					else
					{
     					CarInfo[vehid][cGlass] = true;
	                    TD_ShowSmallInfo(playerid, 5, "Szyba zostala pomyslnie ~r~zamknieta~w~.~n~Czat ~y~nie bedzie ~w~widoczny poza pojazdem.", 5000, 3);
					}
	            }
	            case 4:
	            {
             		if(!(CarInfo[vehid][cAccess] & VEH_ACCESS_RADIO))
	                {
	                    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W tym poje�dzie nie zosta�o zamontowane CB radio.");
	                    return 1;
	                }
	                ShowPlayerDialog(playerid, D_RADIO_OPTIONS, DIALOG_STYLE_LIST, "CB radio � Opcje", "1. Ustaw kana�\n2. Wykup kana� na w�asno��\n3. Ustaw has�o dla kana�u\n4. Definitywnie usu� kana�\n5. Przypisz kana� pod grup�", "Wybierz", "Anuluj");
	            }
	            case 5:
	            {
             		if(!strlen(CarInfo[vehid][cRegister]))
	                {
	                    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten pojazd nie zosta� zarejestrowany w urz�dzie miasta.");
	                    return 1;
	                }
	                ShowPlayerDialog(playerid, D_REGISTER_EDIT, DIALOG_STYLE_INPUT, "W�asna rejestracja", "Wprowad� poni�ej tre�� w�asnej rejestracji.\nNapis na rejestracji zostanie zmieniony zgodnie z podana tre�ci�.\n\nIlo�� znak�w w rejestracji nie mo�e przekroczy� 12.", "Zmie�", "Anuluj");
	            }
	        }
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_DOOR_PICKUP)
	{
	    if(response)
	    {
     		new doorid = PlayerCache[playerid][pMainTable], door_uid = DoorCache[doorid][dUID];
     		
			DoorCache[doorid][dPickupID] = PickupID[listitem];
			SaveDoor(doorid, SAVE_DOOR_THINGS);

			DestroyPickup(doorid);
			Iter_Remove(Door, doorid);
			
			doorid = LoadDoor(door_uid);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Model pickupa dla drzwi %s (SampID: %d, UID: %d) zosta� pomy�lnie zmieniony.", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_DOOR_INTERIOR)
	{
	    if(response)
	    {
	        new string[32];

	        format(string, sizeof(string), "interior %d", strval(inputtext));
	        cmd_adrzwi(playerid, string);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_DOOR_OPTIONS)
	{
		if(response)
		{
		    switch(listitem)
		    {
		        case 0:
		        {
		    		ShowPlayerDialog(playerid, D_DOOR_NAME, DIALOG_STYLE_INPUT, "Opcje drzwi � Zmiana nazwy", "Wprowad� now� nazw� dla tych drzwi.\nOwa nazwa b�dzie wy�wietlana po wej�ciu w pickup przed budynkiem.\n\nPoni�ej wypisane s� znaczniki zmieniaj�ce kolor tekstu:\n\n[r] - czerwony\n[g] - zielony\n[p] - r�owy\n[b] - niebieski\n[w] - bia�y\n[h] - rozja�nia kolor", "Zmie�", "Anuluj");
				}
				case 1:
				{
				    ShowPlayerDialog(playerid, D_DOOR_ENTER_PAY, DIALOG_STYLE_INPUT, "Opcje drzwi � Koszt wst�pu", "Wprowad� koszt wst�pu do budynku.\nPieni�dze b�d� przelewane bezpo�rednio na konto w�a�ciciela budynku.", "Ustal", "Anuluj");
				}
				case 2:
				{
				    new doorid = PlayerCache[playerid][pMainTable];
				    if(DoorCache[doorid][dOwnerType] != OWNER_PLAYER)
				    {
				        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz przypisa� tych drzwi.");
				        return 1;
				    }
					new list_groups[256], group_id;
					for (new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
					{
						if(PlayerGroup[playerid][group_slot][gpUID])
			  			{
			  				group_id = PlayerGroup[playerid][group_slot][gpID];
							format(list_groups, sizeof(list_groups), "%s\n%d\t%s (%d)", list_groups, group_slot + 1, GroupData[group_id][gName], GroupData[group_id][gUID]);
			 			}
					}
					ShowPlayerDialog(playerid, D_DOOR_ASSIGN, DIALOG_STYLE_LIST, "SLOT      NAZWA GRUPY", list_groups, "Wybierz", "Anuluj");
				}
				case 3:
				{
    				new doorid = PlayerCache[playerid][pMainTable];
				    if(!strlen(DoorCache[doorid][dAudioURL]))
				    {
				    	ShowPlayerDialog(playerid, D_DOOR_AUDIO, DIALOG_STYLE_INPUT, "Opcje drzwi � Muzyka spoza gry", "Wprowad� link do muzyki lub radia, kt�re us�ysz� wszyscy przebywaj�cy w tym budynku.\nLink nie mo�e przekroczy� 128 znak�w.\n\nUpewnij si�, �e link jest poprawny w innym wypadku muzyka mo�e nie by� s�yszalna.", "Graj", "Anuluj");
					}
					else
					{
				        // Wy��cz muze wszystkim, kt�rzy s� w pomieszczeniu
				        foreach(new i : Player)
				        {
				            if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
				            {
				                if(GetPlayerDoorID(i) == doorid)
				                {
                                    StopAudioStreamForPlayer(i);
								}
							}
						}
					    strmid(DoorCache[doorid][dAudioURL], "", 0, 0);
					    SaveDoor(doorid, SAVE_DOOR_AUDIO);
					    
						ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Muzyka spoza gry dla tego budynku zosta�a wy��czona.\nAby w��czy� muzyk� spoza gry, wybierz t� opcj� ponownie.");
					}
				}
				case 4:
				{
					new doorid = PlayerCache[playerid][pMainTable], group_id = GetGroupID(DoorCache[doorid][dOwner]);
					ListGroupProductsForPlayer(group_id, playerid, PRODUCT_LIST_OPTIONS);
				}
				case 5:
				{
   					new doorid = PlayerCache[playerid][pMainTable], data[512];
					mysql_query_format("SELECT * FROM `"SQL_PREF"objects` WHERE object_world = '%d'", DoorCache[doorid][dUID]);

					mysql_store_result();
					if(mysql_num_rows() > 0)
					{
	    				crp_SetPlayerPos(playerid, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ]);

						SetPlayerInterior(playerid, DoorCache[doorid][dEnterInt]);
						SetPlayerVirtualWorld(playerid, DoorCache[doorid][dEnterVW]);
						
						OnPlayerFreeze(playerid, true, 3);
						
						// Usu� stare obiekty z tego VW (je�li s�)
						new count_objects = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT);
						for (new object_id = 0; object_id <= count_objects; object_id++)
						{
		    				if(IsValidDynamicObject(object_id))
						    {
								if(Streamer_IsInArrayData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_WORLD_ID, DoorCache[doorid][dUID]))
								{
									DestroyDynamicObject(object_id);
						  		}
							}
						}
						
						new object_id, object_uid, object_model,
						    Float:object_pos[3], Float:object_rot[3], Float:object_gate[6],
						    object_world, object_interior, object_material[128];

						// Materials
						new index, color1, color2, modelid, txdname[32], texturename[64],
						    matsize, fontsize, bold, alignment, fonttype[12], text[64];
					
						while(mysql_fetch_row_format(data, "|"))
						{
					     	sscanf(data, "p<|>ddffffffddffffff{d}s[128]", object_uid, object_model, object_pos[0], object_pos[1], object_pos[2], object_rot[0], object_rot[1], object_rot[2], object_world, object_interior, object_gate[0], object_gate[1], object_gate[2], object_gate[3], object_gate[4], object_gate[5], object_material);
							object_id = CreateDynamicObject(object_model, object_pos[0], object_pos[1], object_pos[2], object_rot[0], object_rot[1], object_rot[2], object_world, object_interior, -1, MAX_DRAW_DISTANCE);

							if(!isnull(object_material))
							{
							    if(strval(object_material[0]) == 0)
							    {
									sscanf(object_material, "{d}dxds[32]s[64]", index, color1, modelid, txdname, texturename);
									SetDynamicObjectMaterial(object_id, index, modelid, txdname, texturename, color1);
								}

							    if(strval(object_material[0]) == 1)
							    {
							        sscanf(object_material, "{d}ddddxxds[12]s[64]", index, matsize, fontsize, bold, color1, color2, alignment, fonttype, text);
							        SetDynamicObjectMaterialText(object_id, index, text, matsize, fonttype, fontsize, bold, color1, color2, alignment);
							    }
							    
							    object_material = "";
							}
							Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_X, object_gate[0]);
							Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_Y, object_gate[1]);
							Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_Z, object_gate[2]);

							Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RX, object_gate[3]);
							Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RY, object_gate[4]);
							Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RZ, object_gate[5]);

							Streamer_SetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID, object_uid);
						}
						
						DestroyPickup(doorid);
						Iter_Remove(Door, doorid);

						doorid = LoadDoor(DoorCache[doorid][dUID]);
						ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Wn�trze drzwi %s (SampID: %d, UID: %d) zosta�o pomy�lnie wczytane.", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
					}
					else
					{
					    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wn�trze nie zosta�o za�adowane.\nPrawdopodobnie nie zosta�o wgrane �adne wn�trze.");
					}
					mysql_free_result();
				}
				case 6:
				{
		  			new doorid = PlayerCache[playerid][pMainTable];
					if(!DoorCache[doorid][dGarage])
					{
					    DoorCache[doorid][dGarage] = true;
					    SaveDoor(doorid, SAVE_DOOR_THINGS);

						ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Mo�liwo�� przejazdu samochodem przez drzwi zosta�a w��czona.\n\nOd tej pory b�dziesz m�g� wjecha� dowolnym pojazdem do budynku.\nAby wjecha� pojazdem do budynku skorzystaj z komendy /przejazd.");
					}
					else
					{
	    				DoorCache[doorid][dGarage] = false;
	    				SaveDoor(doorid, SAVE_DOOR_THINGS);

						ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Mo�liwo�� przejazdu samochodem przez drzwi zosta�a wy��czona.");
					}
				}
				case 7:
				{
				    new doorid = PlayerCache[playerid][pMainTable];
				    
				    GetPlayerPos(playerid, DoorCache[doorid][dExitX], DoorCache[doorid][dExitY], DoorCache[doorid][dExitZ]);
				    GetPlayerFacingAngle(playerid, DoorCache[doorid][dExitA]);
				    
				    DoorCache[doorid][dExitInt] = GetPlayerInterior(playerid);
				    
				    SaveDoor(doorid, SAVE_DOOR_EXIT);
				    ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pozycja wyj�cia z drzwi zosta�a pomy�lnie ustalona.\nWyj�cie na zewn�trz znajduje si� teraz w miejscu, kt�rym w�a�nie stoisz.");
				}
				case 8:
				{
  					new doorid = PlayerCache[playerid][pMainTable], string[128],
					  	data[64], list_items[512], item_uid, item_name[32];
					  	
					mysql_query_format("SELECT `item_uid`, `item_name` FROM `"SQL_PREF"items` WHERE item_place = '%d' AND item_owner = '%d'", PLACE_CLOSET, DoorCache[doorid][dUID]);

					mysql_store_result();
					while(mysql_fetch_row_format(data, "|"))
					{
					    sscanf(data, "p<|>ds[32]", item_uid, item_name);
					    format(list_items, sizeof(list_items), "%s\n%d\t%s", list_items, item_uid, item_name);
					}
					mysql_free_result();
					
					if(strlen(list_items))
					{
					    format(string, sizeof(string), "%s (SampID: %d, UID: %d) � Schowek", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
					    ShowPlayerDialog(playerid, D_ITEM_REMOVE_CLOSET, DIALOG_STYLE_LIST, string, list_items, "Wyjmij", "Anuluj");
					}
					else
					{
					    TD_ShowSmallInfo(playerid, 3, "Nie znaleziono ~r~zadnych ~w~przedmiotow.");
					}
				}
			}
			return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_DOOR_NAME)
	{
		if(response)
		{
  			new doorid = PlayerCache[playerid][pMainTable], door_name[32], esc_door_name[64];
	        if(strlen(inputtext) > 32)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podana nazwa przekracza maksymaln� ilo�� znak�w.\nSpr�buj ponownie, wpisuj�c inn� nazw�.");
	            return 1;
	        }
       		strmid(door_name, FormatTextDrawColors(inputtext), 0, strlen(inputtext));
            mysql_real_escape_string(door_name, esc_door_name);
            
			strmid(DoorCache[doorid][dName], esc_door_name, 0, strlen(esc_door_name), 32);
			SaveDoor(doorid, SAVE_DOOR_THINGS);

			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Nazwa drzwi (SampID: %d, UID: %d) zosta�a zmieniona pomy�lnie.\nNowa nazwa drzwi: %s.", doorid, DoorCache[doorid][dUID], door_name);
			return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_DOOR_ENTER_PAY)
	{
	    if(response)
	    {
	        new doorid = PlayerCache[playerid][pMainTable], price = strval(inputtext);
			if(strlen(inputtext) > 3 || price > 100 || price < 0)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.\nMaksymalny koszt wst�pu jaki mo�esz ustali�: $100");
	            return 1;
	        }
	        DoorCache[doorid][dEnterPay] = price;
	        SaveDoor(doorid, SAVE_DOOR_THINGS);

	        if(DoorCache[doorid][dEnterPay])
	        {
				ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS,  "Koszt wst�pu do budynku zosta� zmieniony.\nOp�ata $%d b�dzie pobierana po wej�ciu do �rodka.", DoorCache[doorid][dEnterPay]);
			}
			else
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS,  "Op�ata za wst�p nie b�dzie ju� wi�cej pobierana.");
			}
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_DOOR_ASSIGN)
	{
	    if(response)
	    {
	        new group_slot = strval(inputtext) - 1, doorid = PlayerCache[playerid][pMainTable], string[256];
			if(!HavePlayerGroupPerm(playerid, PlayerGroup[playerid][group_slot][gpUID], G_PERM_LEADER))
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz uprawnie� lidera tej grupy.");
			    return 1;
			}
    		new group_id = PlayerGroup[playerid][group_slot][gpID];
			PlayerCache[playerid][pMainTable] = group_id;

    		format(string, sizeof(string), "Czy chcesz przypisa� budynek %s (SampID: %d, UID: %d) pod grup� %s (UID: %d)?", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID], GroupData[group_id][gName], GroupData[group_id][gUID]);
    		ShowPlayerDialog(playerid, D_DOOR_ASSIGN_ACCEPT, DIALOG_STYLE_MSGBOX, "Opcje drzwi � Przypisz pod grup�", string, "Tak", "Nie");
	        return 1;
	    }
	    else
	    {
	        return 1;
		}
	}
	if(dialogid == D_DOOR_ASSIGN_ACCEPT)
	{
		if(response)
		{
		    new doorid = GetPlayerDoorID(playerid);
      		if(doorid == INVALID_DOOR_ID)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w budynku, kt�ry chcesz przypisa�.");
	            return 1;
	        }
			new group_id = PlayerCache[playerid][pMainTable];

	        DoorCache[doorid][dOwnerType] = OWNER_GROUP;
	        DoorCache[doorid][dOwner] = GroupData[group_id][gUID];

			SaveDoor(doorid, SAVE_DOOR_THINGS);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Budynek %s (SampID: %d, UID: %d) zosta� pomy�lnie przypisany pod grup�.\nBudynek przypisano dla grupy %s (UID: %d).", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID], GroupData[group_id][gName], GroupData[group_id][gUID]);
		    return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_DOOR_AUDIO)
	{
	    if(response)
	    {
	        new doorid = PlayerCache[playerid][pMainTable], audio_url[128];
	        mysql_real_escape_string(inputtext, audio_url);

	        if(strfind(audio_url, "http://", true))
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzony link nie jest poprawny.\nLink powinien rozpoczyna� si� od \"http://\".");
	            return 1;
	        }
	        if(strlen(audio_url) > 128)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzony link do muzyki jest za d�ugi.\nMaksymalnie dopuszczalne jest 128 znak�w.");
	            return 1;
	        }
	        
	        strmid(DoorCache[doorid][dAudioURL], audio_url, 0, strlen(audio_url), 128);
	        SaveDoor(doorid, SAVE_DOOR_AUDIO);

	        // Za��cz muze dla wszystkich, kt�rzy s� w pomieszczeniu
	        foreach(new i : Player)
	        {
	            if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	            {
	                if(GetPlayerDoorID(i) == doorid)
	                {
	           	 		StopStreamedAudioForPlayer(i);
	           	 		PlayStreamedAudioForPlayer(i, DoorCache[doorid][dAudioURL]);
					}
				}
			}

	        ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Link do audio zosta� pomy�lnie wprowadzony.\nMuzyka powinna by� od teraz s�yszalna - je�li nie jest, oznacza to �e link nie jest poprawny.");
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ITEM_PLAYER_LIST)
	{
	    if(!listitem)    return 1;
	    for(new i = 0; inputtext[i] != 0; i++)	if(inputtext[i] == ' ') inputtext[i] = '_';

	    if(response)
	    {
	        new item_uid, itemid;
         	sscanf(inputtext, "{s[32]}dd", item_uid, itemid);

            if(!item_uid)	return 1;
			OnPlayerUseItem(playerid, itemid);
	        return 1;
  		}
	    else
	    {
  			new item_uid, itemid, string[128];
	        sscanf(inputtext, "{s[32]}dd", item_uid, itemid);

			if(!item_uid)	return 1;
            PlayerCache[playerid][pManageItem] = itemid;
			
			format(string, sizeof(string), "Opcje � %s (UID: %d)", ItemCache[itemid][iName], ItemCache[itemid][iUID]);
			ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_LIST, string, "1. Od�� w pobli�u\n2. Informacje og�lne\n3. Sprzedaj innemu graczowi\n4. W�� do przedmiotu\n5. Dodaj do craftingu\n6. Wsad� do schowka", "Wybierz", "Anuluj");
			return 1;
	    }
	}
	if(dialogid == D_ITEM_OPTIONS)
	{
		if(response)
		{
		    new list_item = strval(inputtext),
				itemid = PlayerCache[playerid][pManageItem];
		    
			if(list_item == 1)
   			{
				OnPlayerDropItem(playerid, itemid);
				return 1;
  			}
  			
		    if(list_item == 2)
		    {
      			ShowPlayerItemInfo(playerid, itemid);
      			return 1;
			}
			
			if(list_item == 3)
			{
 				if(ItemCache[itemid][iUsed])
		  		{
		  		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz sprzeda� tego przedmiotu.");
				    return 1;
				}
			
				new list_players[256], string[128];
				foreach(new i : Player)
				{
				    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
				    {
				        if(i != playerid)
				        {
					        if(PlayerToPlayer(5.0, playerid, i))
					        {
					            format(list_players, sizeof(list_players), "%s\n%d\t\t%s", list_players, i, PlayerName(i));
					        }
						}
				    }
				}
				
				if(strlen(list_players))
	            {
	                format(string, sizeof(string), "%s (UID: %d) � Sprzedaj innemu graczowi", ItemCache[itemid][iName], ItemCache[itemid][iUID]);
	                ShowPlayerDialog(playerid, D_ITEM_OFFER, DIALOG_STYLE_LIST, string, list_players, "Wybierz", "Anuluj");
	            }
	            else
	            {
	                ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnych graczy w pobli�u.");
	            }
			    return 1;
			}
			
			if(list_item == 4)
			{
   				if(ItemCache[itemid][iUsed] || ItemCache[itemid][iType] == ITEM_BAG)
       			{
          			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz w�o�y� tego przedmiotu.");
          			return 1;
		        }
			        
				new list_items[256], string[128];
				foreach(new bag_itemid : Item)
				{
    				if(ItemCache[bag_itemid][iUID])
				    {
        				if(ItemCache[bag_itemid][iPlace] == PLACE_PLAYER && ItemCache[bag_itemid][iOwner] == PlayerCache[playerid][pUID])
	       				{
            				if(ItemCache[bag_itemid][iType] == ITEM_BAG)
				            {
                				format(list_items, sizeof(list_items), "%s\n%d\t%s", list_items, ItemCache[bag_itemid][iUID], ItemCache[bag_itemid][iName]);
	           				}
						}
		    		}
				}
				
				if(strlen(list_items))
				{
 					format(string, sizeof(string), "%s (UID: %d) � W�� do przedmiotu", ItemCache[itemid][iName], ItemCache[itemid][iUID]);
				    ShowPlayerDialog(playerid, D_ITEM_PUT_BAG, DIALOG_STYLE_LIST, string, list_items, "W��", "Anuluj");
				}
				else
				{
    				ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz przedmiotu, do kt�rego mo�esz co� w�o�y�.");
				}
				return 1;
			}
			
			if(list_item == 5)
			{
				if(ItemCache[itemid][iType] != ITEM_CRAFT)
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz doda� tego przedmiotu do craftingu.");
				    return 1;
				}
				new object_id = GetClosestObjectType(playerid, OBJECT_CRAFT);
				if(object_id == INVALID_OBJECT_ID)
				{
					ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono obiektu sto�u do craftingu w pobli�u.");
				    return 1;
				}
				new object_uid = GetObjectUID(object_id);
				
				ItemCache[itemid][iPlace] = PLACE_CRAFT;
				ItemCache[itemid][iOwner] = object_uid;
				
				SaveItem(itemid, SAVE_ITEM_OWNER);
				ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Przedmiot %s (UID: %d) zosta� dodany do listy craftingu dla obiektu (UID: %d).\nSkorzystaj z komendy /craft, by wyj�� przedmioty znajduj�ce si� na obiekcie.", ItemCache[itemid][iName], ItemCache[itemid][iUID], object_uid);
				
				ClearItemCache(itemid);
			    return 1;
			}
			
			if(list_item == 6)
			{
				if(ItemCache[itemid][iUsed])
       			{
          			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wsadzi� tego przedmiotu.");
          			return 1;
		        }
			
				new doorid = GetPlayerDoorID(playerid);
		 		if(doorid == INVALID_DOOR_ID)
			    {
			        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku, aby m�c schowa� przedmiot.");
			        return 1;
				}
		   		if(DoorCache[doorid][dOwnerType] == OWNER_NONE)
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie jeste� w�a�cicielem tego budynku.");
				    return 1;
				}
				if(DoorCache[doorid][dOwnerType] == OWNER_PLAYER && DoorCache[doorid][dOwner] != PlayerCache[playerid][pUID])
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie jeste� w�a�cicielem tego budynku.");
				    return 1;
				}
				if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
				{
					if(!HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_LEADER))
					{
					    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie jeste� w�a�cicielem tego budynku.");
					    return 1;
					}
				}
				ItemCache[itemid][iPlace] = PLACE_CLOSET;
				ItemCache[itemid][iOwner] = DoorCache[doorid][dUID];
				
				SaveItem(itemid, SAVE_ITEM_OWNER);
				ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Przedmiot %s (UID: %d) zosta� schowany w schowku drzwi %s (UID: %d).", ItemCache[itemid][iName], ItemCache[itemid][iUID], DoorCache[doorid][dName], DoorCache[doorid][dUID]);
				
				ClearItemCache(itemid);
			    return 1;
			}
		    return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_ITEM_OFFER)
	{
	    if(response)
	    {
	        new string[256], itemid = PlayerCache[playerid][pManageItem];
	        PlayerCache[playerid][pMainTable] = strval(inputtext);
	        
	        format(string, sizeof(string), "Wprowad� poni�ej kwot�, jak� pragniesz otrzyma� za przedmiot %s (UID: %d).", ItemCache[itemid][iName], ItemCache[itemid][iUID]);
			ShowPlayerDialog(playerid, D_ITEM_OFFER_PRICE, DIALOG_STYLE_INPUT, "Sprzeda� przedmiotu � Cena", string, "Oferuj", "Anuluj");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ITEM_OFFER_PRICE)
	{
	    if(response)
	    {
    		new price = strval(inputtext),
				itemid = PlayerCache[playerid][pManageItem], giveplayer_id = PlayerCache[playerid][pMainTable];
				
		    if(price < 0 || strlen(inputtext) > 11)
		    {
		       	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
		        return 1;
		    }
		    OnPlayerSendOffer(playerid, giveplayer_id, ItemCache[itemid][iName], OFFER_ITEM, itemid, 0, price);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ITEM_RAISE)
	{
	    if(response)
	    {
	        if(!strval(inputtext))  return 1;
	        
	        new item_uid = strval(inputtext);
	        OnPlayerRaiseItem(playerid, item_uid);
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
	        if(!strval(inputtext))  return 1;
	    
			new itemid = PlayerCache[playerid][pManageItem], item_uid = strval(inputtext), item_bag_id = GetItemID(item_uid);

			ItemCache[itemid][iPlace] = PLACE_BAG;
			ItemCache[itemid][iOwner] = item_uid;
			
			SaveItem(itemid, SAVE_ITEM_OWNER);
			ItemCache[item_bag_id][iValue1] += GetItemWeight(itemid);

			ClearItemCache(itemid);
			SaveItem(item_bag_id, SAVE_ITEM_VALUES);
			
			ListPlayerItems(playerid);
			GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~w~Przedmiot ~y~wlozony", 3000, 3);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ITEM_REMOVE_BAG)
	{
	    if(response)
	    {
			if(!strval(inputtext))  return 1;
			
	        new item_uid = strval(inputtext), itemid, item_bag_id = PlayerCache[playerid][pManageItem];
	        mysql_query_format("UPDATE `"SQL_PREF"items` SET item_place = '%d', item_owner = '%d' WHERE item_uid = '%d' LIMIT 1", PLACE_PLAYER, PlayerCache[playerid][pUID], item_uid);

	        itemid = LoadItemCache(item_uid);
	        ItemCache[item_bag_id][iValue1] -= GetItemWeight(itemid);
	        
	        SaveItem(item_bag_id, SAVE_ITEM_VALUES);
	        ListPlayerItems(playerid);
	        
	        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~w~Przedmiot ~g~wyjety", 3000, 3);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ITEM_REMOVE_CLOSET)
	{
	    if(response)
	    {
   			if(!strval(inputtext))	return 1;
   			
     		new itemid, item_uid = strval(inputtext);
	        mysql_query_format("UPDATE `"SQL_PREF"items` SET item_place = '%d', item_owner = '%d' WHERE item_uid = '%d' LIMIT 1", PLACE_PLAYER, PlayerCache[playerid][pUID], item_uid);

	        itemid = LoadItemCache(item_uid);
	        ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Przedmiot %s (UID: %d) zosta� wyj�ty.\nPojawi� si� on w Twoim ekwipunku.", ItemCache[itemid][iName], ItemCache[itemid][iUID]);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ITEM_RELOAD_WEAPON)
	{
	    if(response)
	    {
	        new itemid = PlayerCache[playerid][pManageItem],
				item_uid = strval(inputtext), weapon_itemid = GetItemID(item_uid), string[128];
				
 			if(ItemCache[weapon_itemid][iUsed])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz prze�adowa� broni, kt�ra jest w u�yciu.");
			    return 1;
			}
			
			ItemCache[weapon_itemid][iValue2] += ItemCache[itemid][iValue2];
			SaveItem(weapon_itemid, SAVE_ITEM_VALUES);
			
			format(string, sizeof(string), "* %s prze�adowuje %s.", PlayerName(playerid), ItemCache[weapon_itemid][iName]);
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

			ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.0, 0, 0, 0, 0, 0, 1);
			DeleteItem(itemid);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ITEM_ADD_CHIT)
	{
	    if(response)
	    {
     		new itemid = PlayerCache[playerid][pManageItem], chit_desc[128], string[128],
	            chit_uid;

	        if(strlen(inputtext) <= 0)
	        {
         		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Pole tekstowe nie mo�e by� puste!");
	            return 1;
	        }
	        
	        if(strlen(inputtext) > 64)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tekst nie mo�e przekroczy� ci�gu 64 znak�w.");
				return 1;
	        }
	        
			mysql_real_escape_string(inputtext, chit_desc);
			mysql_query_format("INSERT INTO `"SQL_PREF"chits` (`chit_desc`, `chit_writer`, `chit_time`) VALUES ('%s', '%s', NOW())", chit_desc, PlayerName(playerid));

			chit_uid = mysql_insert_id();
			CreatePlayerItem(playerid, "Karteczka", ITEM_CHIT, chit_uid, 0);

			ItemCache[itemid][iValue1] --;
			if(ItemCache[itemid][iValue1] > 0)
			{
			    SaveItem(itemid, SAVE_ITEM_VALUES);
			}
			else
			{
			    DeleteItem(itemid);
			}

			format(string, sizeof(string), "* %s wyrywa karteczk� z notatnika.", PlayerName(playerid));
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Tre�� zosta�a pomy�lnie zapisana na karteczce.\nKarteczka pojawi�a si� w Twoim ekwipunku.");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ITEM_WRITE_A_CHECK)
	{
	    if(response)
	    {
  			new itemid = PlayerCache[playerid][pManageItem], check_price = strval(inputtext), string[128], item_name[32];
			if(strlen(inputtext) > 11 || check_price <= 0 || check_price > PlayerCache[playerid][pBankCash])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
			    return 1;
			}
			
			PlayerCache[playerid][pBankCash] -= check_price;
			OnPlayerSave(playerid, SAVE_PLAYER_BASIC);

			format(item_name, sizeof(item_name), "Czek na $%d", check_price);
            CreatePlayerItem(playerid, item_name, ITEM_CHECK, check_price, 0);

			ItemCache[itemid][iValue1] --;
			if(ItemCache[itemid][iValue1] > 0)
			{
				SaveItem(itemid, SAVE_ITEM_VALUES);
			}
			else
			{
			    DeleteItem(itemid);
			}

 			format(string, sizeof(string), "* %s wypisuje czek na $%d.", PlayerName(playerid), check_price);
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Czek zosta� wypisany pomy�lnie.\nPieni�dze zosta�y pobrane z Twojego konta bankowego i wypisane na czeku.");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_PRODUCT_OFFER)
	{
	    if(response)
	    {
     		new product_uid, product_count, product_price, product_name[32], customerid = PlayerCache[playerid][pMainTable];
	        sscanf(inputtext, "d'x'd'$'ds[32]", product_uid, product_count, product_price, product_name);

			new product_id = GetProductID(product_uid);
			OnPlayerSendOffer(playerid, customerid, product_name, OFFER_PRODUCT, product_id, (PlayerCache[playerid][pDutyGroup]) ? 0 : ProductData[product_id][pOwner], product_price);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_PRODUCT_BUY)
	{
	    if(response)
	    {
	        new product_uid, product_price, product_count, product_name[32],
	            doorid = PlayerCache[playerid][pMainTable];
	        
	        sscanf(inputtext, "d'x'd'$'ds[32]", product_uid, product_count, product_price, product_name);
			
   			if(product_price > PlayerCache[playerid][pCash])
      		{
        		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz takiej ilo�ci got�wki.");
        		return 1;
        	}
        	
       		if(!(PlayerCache[playerid][pAdmin] & A_PERM_ITEMS) && GetPlayerCapacity(playerid) <= 0)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Twoja posta� nie jest w stanie unie�� wi�cej przedmiot�w.");
			    return 1;
			}
			
 			new product_id = GetProductID(product_uid),
			 	itemid;
			 	
 			if(product_id == INVALID_PRODUCT_ID)
 			{
 			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tego produktu nie ma ju� w magazynie.");
 			    return 1;
 			}
 			
   			if(product_price > 0)
      		{
        		new group_cash = floatround(0.90 * product_price),
        		    group_activity = product_price;

				crp_GivePlayerMoney(playerid, -product_price);
				OnPlayerSave(playerid, SAVE_PLAYER_BASIC);

				new group_id = GetGroupID(DoorCache[doorid][dOwner]);
				
				GroupData[group_id][gCash] += group_cash;
				GroupData[group_id][gActivity] += group_activity;
				
				SaveGroup(group_id);
    		}
    		
      		ProductData[product_id][pCount] --;
      		ProductData[product_id][pPrice] = product_price;
      		
        	itemid = CreatePlayerItem(playerid, ProductData[product_id][pName], ProductData[product_id][pType], ProductData[product_id][pValue1], ProductData[product_id][pValue2]);

			ItemCache[itemid][iGroup] = ProductData[product_id][pOwner];
			SaveItem(itemid, SAVE_ITEM_GROUP);

			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Zakupi�e� produkt %s.\nKoszt: $%d\n\nPrzedmiot (UID: %d) pojawi� si� w Twoim ekwipunku.\nSkorzystaj z komendy /p, by wy�wietli� list� posiadanych przedmiot�w.", ProductData[product_id][pName], product_price, ItemCache[itemid][iUID]);
      		
        	if(ProductData[product_id][pCount] <= 0)	DeleteProduct(product_id);
	        else										SaveProduct(product_id, SAVE_PRODUCT_VALUES);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_PRODUCT_SELECT)
	{
	    if(response)
	    {
     		new product_uid = strval(inputtext), product_id = GetProductID(product_uid), string[128];
	        format(string, sizeof(string), "%s (%d, %d) %d szt.", ProductData[product_id][pName], ProductData[product_id][pValue1], ProductData[product_id][pValue2], ProductData[product_id][pCount]);

			ShowPlayerDialog(playerid, D_PRODUCT_OPTIONS, DIALOG_STYLE_LIST, string, "1. Wyjmij produkt\n2. Zmie� cen�\n3. Usu� z magazynu", "Wybierz", "Anuluj");
	        PlayerCache[playerid][pMainTable] = product_id;
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_PRODUCT_OPTIONS)
	{
	    if(response)
	    {
     		new product_id = PlayerCache[playerid][pMainTable], string[256];
     		if(product_id == INVALID_PRODUCT_ID)
     		{
     		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tego produktu nie ma w magazynie.");
     		    return 1;
     		}
     		
	        switch(listitem)
	        {
	            case 0:
	            {
	               	new itemid = CreatePlayerItem(playerid, ProductData[product_id][pName], ProductData[product_id][pType], ProductData[product_id][pValue1], ProductData[product_id][pValue2]);

					ItemCache[itemid][iGroup] = ProductData[product_id][pOwner];
					SaveItem(itemid, SAVE_ITEM_GROUP);

					ProductData[product_id][pCount] --;
					if(ProductData[product_id][pCount] <= 0)	DeleteProduct(product_id);
					else										SaveProduct(product_id, SAVE_PRODUCT_VALUES);

					ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Wyj��e� produkt z magazynu.\nNazwa produktu: %s (%d, %d)\n\nProdukt pojawi� si� w Twoim ekwipunku.", ProductData[product_id][pName], ProductData[product_id][pValue1], ProductData[product_id][pValue2]);
	            }
	            case 1:
				{
				    format(string, sizeof(string), "Wprowad� now� cen�, kt�ra b�dzie pobierana za kupno produktu.\n\nWybra�e� produkt: %s\nCena produktu: $%d/$%d", ProductData[product_id][pName], ProductData[product_id][pPrice], ProductData[product_id][pMaxPrice]);
	                ShowPlayerDialog(playerid, D_PRODUCT_PRICE, DIALOG_STYLE_INPUT, "Zmie� cen� produktu", string, "Zmie�", "Anuluj");
	            }
	            case 2:
	            {
					format(string, sizeof(string), "Czy jeste� pewien, �e chcesz usun�� produkt?\n\nNazwa produktu: %s\nUID: %d", ProductData[product_id][pName], ProductData[product_id][pUID]);
					ShowPlayerDialog(playerid, D_PRODUCT_DELETE, DIALOG_STYLE_MSGBOX, "Usu� produkt z magazynu", string, "Usu�", "Anuluj");
	            }
	        }
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_PRODUCT_PRICE)
	{
	    if(response)
	    {
     		new price = strval(inputtext), product_id = PlayerCache[playerid][pMainTable];
     		if(product_id == INVALID_PRODUCT_ID)
     		{
     		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tego produktu nie ma w magazynie.");
     		    return 1;
     		}
	        if(price < 0 || strlen(inputtext) > 6 || price > ProductData[product_id][pMaxPrice])
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
	            return 1;
	        }
			ProductData[product_id][pPrice] = price;
			SaveProduct(product_id, SAVE_PRODUCT_VALUES);

			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Produkt o nazwie %s kosztuje teraz $%d.", ProductData[product_id][pName], ProductData[product_id][pPrice]);
	        return 1;
	    }
		else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_PRODUCT_DELETE)
	{
	    if(response)
	    {
  			new product_id = PlayerCache[playerid][pMainTable];
   			if(product_id == INVALID_PRODUCT_ID)
     		{
     		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tego produktu nie ma w magazynie.");
     		    return 1;
     		}
     		
			DeleteProduct(product_id);
			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Produkt zosta� ca�kowicie usuni�ty z magazynu.");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_OFFER_SEND)
	{
	    if(response)
	    {
	        new offererid = GetOffererID(playerid);
	        if(OfferData[offererid][oPrice] > 0)
	        {
	            if(PlayerCache[playerid][pBankNumber])
	            {
	                ShowPlayerDialog(playerid, D_OFFER_PAY_TYPE, DIALOG_STYLE_MSGBOX, "Rodzaj p�atno�ci", "Wybierz spos�b zap�aty za dan� ofert�.", "Got�wka", "Karta");
	            }
	            else
	            {
	                OfferData[offererid][oPayType] = PAY_TYPE_CASH;
	                OnPlayerAcceptOffer(playerid, offererid);
	            }
	        }
	        else
	        {
	            OfferData[offererid][oPayType] = PAY_TYPE_CASH;
	            OnPlayerAcceptOffer(playerid, offererid);
	        }
	        return 1;
	    }
	    else
	    {
	        new offererid = GetOffererID(playerid);
	        OnPlayerRejectOffer(playerid, offererid);
	        return 1;
	    }
	}
	if(dialogid == D_OFFER_PAY_TYPE)
	{
	    if(response)
	    {
	        new offererid = GetOffererID(playerid);

	        OfferData[offererid][oPayType] = PAY_TYPE_CASH;
	        OnPlayerAcceptOffer(playerid, offererid);
	        return 1;
	    }
	    else
	    {
     		new offererid = GetOffererID(playerid);

	        OfferData[offererid][oPayType] = PAY_TYPE_CARD;
	        OnPlayerAcceptOffer(playerid, offererid);
	        return 1;
	    }
	}
	if(dialogid == D_OFFER_LIST)
	{
	    if(response)
	    {
     		new offer_name[24];
	        sscanf(inputtext, "'�'s[24]", offer_name);

	        cmd_oferuj(playerid, offer_name);
	        return 1;
	    }
	    else
	    {
			return 1;
	    }
	}
	if(dialogid == D_PHONE_OPTIONS)
	{
	    if(response)
	    {
	        new list_item = strval(inputtext);
	        
	        if(list_item == 1)
	        {
	            ShowPlayerDialog(playerid, D_PHONE_CALL_NUMBER, DIALOG_STYLE_INPUT, "Telefon � Wybierz numer", "Wprowad� numer telefonu kom�rkowego, na kt�ry chcesz zadzwoni�:", "Po��cz", "Anuluj");
	            return 1;
	        }
	        
	        if(list_item == 2)
	        {
	            ShowPlayerDialog(playerid, D_PHONE_SMS_NUMBER, DIALOG_STYLE_INPUT, "Telefon � Wy�lij SMS", "Wprowad� numer telefonu, na kt�ry chcesz wys�a� wiadomo�� SMS:", "Dalej", "Anuluj");
	            return 1;
	        }
	        
	        if(list_item == 3)
	        {
	            new list_players[256];
	            foreach(new i : Player)
	            {
	                if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	                {
	                    if(i != playerid)
	                    {
	                        if(PlayerToPlayer(5.0, playerid, i))
	                        {
	                            format(list_players, sizeof(list_players), "%s\n%d\t\t%s", list_players, i, PlayerName(i));
	                        }
	                    }
	                }
	            }
	            
	            if(strlen(list_players))
	            {
	                ShowPlayerDialog(playerid, D_PHONE_SEND_VCARD, DIALOG_STYLE_LIST, "Telefon � Wy�lij vCard", list_players, "Wybierz", "Anuluj");
	            }
	            else
	            {
	                ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnych graczy w pobli�u.");
	            }
	            return 1;
	        }
	        
	        if(list_item == 4)
	        {
 				new data[128], list_contacts[1024], contacts,
     				contact_number, contact_name[24];

				mysql_query_format("SELECT `contact_number`, `contact_name` FROM `"SQL_PREF"contacts` WHERE contact_owner = '%d'", PlayerCache[playerid][pPhoneNumber]);

				format(list_contacts, sizeof(list_contacts), "911\t\tNumer alarmowy\n333\t\tHurtownia\n777\t\tTaxi\n444\t\tLos Santos News\n-----");
				
				mysql_store_result();
				while(mysql_fetch_row_format(data, "|"))
				{
				    contacts ++;
				
    				sscanf(data, "p<|>ds[24]", contact_number, contact_name);
					format(list_contacts, sizeof(list_contacts), "%s\n%d\t\t%s", list_contacts, contact_number, contact_name);
				}
				mysql_free_result();
				
				if(strlen(list_contacts))
				{
				    if(contacts >= 20)  GivePlayerAchievement(playerid, ACHIEVE_VCARDS);
    				ShowPlayerDialog(playerid, D_CONTACT_LIST, DIALOG_STYLE_LIST, "Kontakty w telefonie", list_contacts, "Wybierz", "Anuluj");
				}
				else
				{
    				ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnych kontakt�w w telefonie.");
				}
	            return 1;
	        }
	        
	        if(list_item == 5)
	        {
 				new itemid = PlayerCache[playerid][pManageItem];

				ItemCache[itemid][iUsed] = false;
				SaveItem(itemid, SAVE_ITEM_USED);

				PlayerCache[playerid][pPhoneNumber] = 0;
				TD_ShowSmallInfo(playerid, 3, "Telefon zostal pomyslnie ~r~wylaczony~w~.");
	            return 1;
	        }
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_PHONE_CALL_NUMBER)
	{
		if(response)
		{
  			new string[12];
		    if(strval(inputtext) <= 0 || strlen(inputtext) > 6)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzony numer telefonu jest nieprawid�owy.");
		        return 1;
			}
			
		    format(string, sizeof(string), "%d", strval(inputtext));
			cmd_tel(playerid, string);
		    return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_PHONE_SMS_NUMBER)
	{
		if(response)
		{
  			new phone_number = strval(inputtext), string[128];
		    if(strval(inputtext) <= 0 || strlen(inputtext) > 6)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzony numer telefonu jest nieprawid�owy.");
		        return 1;
			}
		    PlayerCache[playerid][pMainTable] = phone_number;

   			format(string, sizeof(string), "Wprowad� tre�� wiadomo�ci SMS, kt�ra zostanie wys�ana na numer %d.", phone_number);
     		ShowPlayerDialog(playerid, D_PHONE_SEND_SMS, DIALOG_STYLE_INPUT, "Telefon � Wy�lij SMS", string, "Wy�lij", "Anuluj");
		    return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_PHONE_SEND_SMS)
	{
	    if(response)
	    {
     		new phone_number = PlayerCache[playerid][pMainTable], string[256];
	        format(string, sizeof(string), "%d %s", phone_number, inputtext);

	        cmd_sms(playerid, string);
	        return 1;
	    }
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_PHONE_SEND_VCARD)
	{
	    if(response)
	    {
     		new giveplayer_id = strval(inputtext);
     		if(!PlayerCache[giveplayer_id][pLogged] || !PlayerCache[giveplayer_id][pSpawned])
     		{
     		    return 1;
     		}
     		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
     		{
     		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
     		    return 1;
     		}
	        if(!PlayerCache[giveplayer_id][pPhoneNumber])
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie posiada telefonu w u�yciu.");
	            return 1;
	        }
	        OnPlayerSendOffer(playerid, giveplayer_id, "vCard", OFFER_VCARD, PlayerCache[playerid][pPhoneNumber], 0, 0);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_CONTACT_LIST)
	{
	    if(response)
	    {
	        new phone_number = strval(inputtext);
	        if(!strval(inputtext)) return 1;
	        
	        if(phone_number == NUMBER_WHOLESALE || phone_number == NUMBER_TAXI || phone_number == NUMBER_ALARM || phone_number == NUMBER_NEWS)
	        {
	            cmd_tel(playerid, inputtext);
	            return 1;
	        }
	        new string[128], contact_name[32];
	        sscanf(inputtext, "ds[32]", phone_number, contact_name);
	        
	        PlayerCache[playerid][pMainTable] = phone_number;
	        
	        format(string, sizeof(string), "%s (%d) � Opcje kontaktu", contact_name, phone_number);
	        ShowPlayerDialog(playerid, D_CONTACT_OPTIONS, DIALOG_STYLE_LIST, string, "1. Po��cz\n2. Wy�lij SMS\n3. Usu� kontakt", "Wybierz", "Anuluj");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_CONTACT_OPTIONS)
	{
	    if(response)
	    {
	        new list_items = strval(inputtext), string[128],
	            phone_number = PlayerCache[playerid][pMainTable];
	        
	        if(list_items == 1)
	        {
	            format(string, sizeof(string), "%d", phone_number);
	            cmd_tel(playerid, string);
	            return 1;
	        }
	        
	        if(list_items == 2)
	        {
      			format(string, sizeof(string), "Wprowad� tre�� wiadomo�ci SMS, kt�ra zostanie wys�ana na numer %d.", phone_number);
     			ShowPlayerDialog(playerid, D_PHONE_SEND_SMS, DIALOG_STYLE_INPUT, "Telefon � Wy�lij SMS", string, "Wy�lij", "Anuluj");
	            return 1;
	        }
	        
	        if(list_items == 3)
	        {
	            format(string, sizeof(string), "Jeste� pewien, �e chcesz usun�� kontakt z numerem %d?\nKontakt zostanie nieodwracalnie usuni�ty z ksi��ki telefonicznej.", phone_number);
	            ShowPlayerDialog(playerid, D_CONTACT_DELETE, DIALOG_STYLE_MSGBOX, "Telefon � Usu� kontakt", string, "Tak", "Nie");
	            return 1;
	        }
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_CONTACT_DELETE)
	{
	    if(response)
	    {
     		new phone_number = PlayerCache[playerid][pMainTable];
	        mysql_query_format("DELETE FROM `"SQL_PREF"contacts` WHERE contact_number = '%d' AND contact_owner = '%d' LIMIT 1", phone_number, PlayerCache[playerid][pPhoneNumber]);

			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Kontakt z numerem %d zosta� pomy�lnie usuni�ty z listy kontakt�w.", phone_number);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_BANK_CREATE_ACCOUNT)
	{
	    if(response)
	    {
     		new bank_number = 100000000 + random(999999999);
     		
	        PlayerCache[playerid][pBankNumber] = bank_number;
			OnPlayerSave(playerid, SAVE_PLAYER_BASIC);

	        ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Konto bankowe zosta�o za�o�one pomy�lnie.\nTw�j nowy numer konta: %d.", PlayerCache[playerid][pBankNumber]);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_BANK_SELECT_OPTIONS)
	{
	    if(response)
	    {
     		new string[256];
	        switch(listitem)
	        {
				case 0:
				{
				    if(PlayerCache[playerid][pBankCash] >= 5000) 	GivePlayerAchievement(playerid, ACHIEVE_SAVINGS);
				    if(PlayerCache[playerid][pBankCash] >= 100000)  GivePlayerAchievement(playerid, ACHIEVE_RICH);
				
				    format(string, sizeof(string), "W�a�ciciel:\t\t%s\nNumer konta:\t\t%d\nStan konta:\t\t$%d", PlayerRealName(playerid), PlayerCache[playerid][pBankNumber], PlayerCache[playerid][pBankCash]);
				    ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Konto bankowe", string, "OK", "");
				}
				case 1:
				{
				    ShowPlayerDialog(playerid, D_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "Konto bankowe � Wp�a� got�wk�", "Wprowad� kwot� jak� chcesz wp�aci� na swoje konto bankowe:", "Wp�a�", "Anuluj");
				}
				case 2:
				{
				    ShowPlayerDialog(playerid, D_BANK_WITHDRAW, DIALOG_STYLE_INPUT, "Konto bankowe � Wyp�a� got�wk�", "Wprowad� kwot� jak� chcesz wyp�aci� z konta bankowego:", "Wyp�a�", "Anuluj");
				}
				case 3:
				{
				    if(PlayerCache[playerid][pHours] < 5)
				    {
				        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz dokona� przelewu maj�c na koncie poni�ej 5h gry.");
				        return 1;
				    }
				    ShowPlayerDialog(playerid, D_BANK_TRANSFER_NUMBER, DIALOG_STYLE_INPUT, "Konto bankowe � Dokonaj przelewu", "Wprowad� numer konta bankowego, na kt�ry chcesz przela� got�wk�:", "Dalej", "Anuluj");
				}
	        }
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_BANK_DEPOSIT)
	{
	    if(response)
	    {
			new deposit_cash = strval(inputtext);
			if(strlen(inputtext) > 11 || deposit_cash <= 0 || deposit_cash > PlayerCache[playerid][pCash])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
			    return 1;
			}
   			crp_GivePlayerMoney(playerid, -deposit_cash);
			PlayerCache[playerid][pBankCash] += deposit_cash;

			OnPlayerSave(playerid, SAVE_PLAYER_BASIC);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Na konto bankowe wp�acono kwot� $%d.\nNowy stan konta: $%d", deposit_cash, PlayerCache[playerid][pBankCash]);

			printf("[cash] %s (UID: %d, GID: %d) wp�aci� $%d na swoje konto bankowe (bank: $%d, portfel: $%d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], deposit_cash, PlayerCache[playerid][pBankCash], PlayerCache[playerid][pCash]);
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_BANK_WITHDRAW)
	{
	    if(response)
	    {
  			new withdraw_cash = strval(inputtext);
			if(strlen(inputtext) > 11 || withdraw_cash <= 0 || withdraw_cash > PlayerCache[playerid][pBankCash])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
			    return 1;
			}
			PlayerCache[playerid][pBankCash] -= withdraw_cash;
			crp_GivePlayerMoney(playerid, withdraw_cash);

			OnPlayerSave(playerid, SAVE_PLAYER_BASIC);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Z konta bankowego wyp�acono kwot� $%d.\nNowy stan konta: $%d", withdraw_cash, PlayerCache[playerid][pBankCash]);

            printf("[cash] %s (UID: %d, GID: %d) wyp�aci� $%d ze swojego konta bankowego (bank: $%d, portfel: $%d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], withdraw_cash, PlayerCache[playerid][pBankCash], PlayerCache[playerid][pCash]);
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_BANK_TRANSFER_NUMBER)
	{
	    if(response)
	    {
     		new bank_number = strval(inputtext), data[32],
	            char_uid = -1, char_gid = -1;

	        if(strlen(inputtext) > 9 || strlen(inputtext) < 9)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owy numer konta bankowego.");
	            return 1;
	        }
			mysql_query_format("SELECT `char_uid`, `char_gid` FROM `"SQL_PREF"characters` WHERE char_banknumb = '%d' LIMIT 1", bank_number);

			mysql_store_result();
			if(mysql_fetch_row_format(data, "|"))
			{
			    sscanf(data, "p<|>dd", char_uid, char_gid);
			}
			mysql_free_result();

			if(char_uid == -1 || char_gid == -1)
			{
				ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owy numer konta bankowego.");
				return 1;
			}
			if(char_uid == PlayerCache[playerid][pUID])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz przelewa� pieni�dzy na w�asne konto bankowe.");
			    return 1;
			}
			if(char_gid == PlayerCache[playerid][pGID])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz przelewa� pieni�dzy mi�dzy w�asnymi postaciami!");
			    return 1;
			}
			PlayerCache[playerid][pMainTable] = char_uid;
			ShowPlayerDialog(playerid, D_BANK_TRANSFER_CASH, DIALOG_STYLE_INPUT, "Dokonaj przelewu � Kwota", "Wprowad� kwot�, jak� chcesz przela� na wybrane konto bankowe.\n\nUWAGA!\nGot�wka jest pobierana bezpo�rednio ze stanu konta bankowego, nie z portfela!", "Przelej", "Anuluj");
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_BANK_TRANSFER_CASH)
	{
	    if(response)
	    {
	    	new transfer_cash = strval(inputtext), char_uid = PlayerCache[playerid][pMainTable], giveplayer_id = GetPlayerID(char_uid);
			if(strlen(inputtext) > 11 || transfer_cash <= 0 || transfer_cash > PlayerCache[playerid][pBankCash])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
			    return 1;
			}
			if(giveplayer_id != INVALID_PLAYER_ID && PlayerCache[giveplayer_id][pLogged] && PlayerCache[giveplayer_id][pSpawned])
			{
                PlayerCache[giveplayer_id][pBankCash] += transfer_cash;
                OnPlayerSave(giveplayer_id, SAVE_PLAYER_BASIC);
			}
			else
			{
   				mysql_query_format("UPDATE `"SQL_PREF"characters` SET char_bankcash = char_bankcash + %d WHERE char_uid = '%d' LIMIT 1", transfer_cash, char_uid);
			}
			PlayerCache[playerid][pBankCash] -= transfer_cash;
			OnPlayerSave(playerid, SAVE_PLAYER_BASIC);

			if(transfer_cash >= 10000)  GivePlayerAchievement(playerid, ACHIEVE_INTEREST);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pieni�dze zosta�y pomy�lnie przelane.\nPrzelana ilo�� got�wki: %d\n\nGot�wka zosta�a pobrana z Twojego konta bankowego.", transfer_cash);

            printf("[cash] %s (UID: %d, GID: %d) przela� $%d na konto bankowe gracza (UID: %d) (bank: $%d, portfel: $%d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], transfer_cash, char_uid, PlayerCache[playerid][pBankCash], PlayerCache[playerid][pCash]);
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_DISC_INSERT)
	{
	    if(response)
	    {
     		new itemid = PlayerCache[playerid][pManageItem], item_uid = strval(inputtext), player_itemid = GetItemID(item_uid), string[128];
	        if(ItemCache[player_itemid][iUsed])
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten odtwarzacz jest w u�yciu, przesta� pierw go u�ywa�.");
				return 1;
	        }
	        
 			ItemCache[player_itemid][iValue1] = ItemCache[itemid][iValue1];
	        SaveItem(player_itemid, SAVE_ITEM_VALUES);

			format(string, sizeof(string), "* %s umieszcza p�yt� w odtwarzaczu.", PlayerName(playerid));
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "P�yta zosta�a pomy�lnie umieszczona w odtwarzaczu.\nU�yj tego odtwarzacza, by rozpocz�� s�uchanie muzyki.");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_DISC_RECORD)
	{
	    if(response)
	    {
	    	new itemid = PlayerCache[playerid][pManageItem], audio_url[128],
		        audio_uid;

	        if(strfind(inputtext, "http://", true))
	        {
	            ShowPlayerDialog(playerid, D_DISC_RECORD, DIALOG_STYLE_INPUT, "Czysta p�yta � Nagrywanie", "To jest czysta p�yta, na kt�rej mo�esz nagra� dowolny kawa�ek.\nWklej w pole tekstowe poni�ej link do muzyki, kt�ra ma by� odtwarzana poprzez urz�dzenia.\n\nUpewnij si�, �e link jest poprawny w innym wypadku muzyka mo�e nie by� s�yszalna.\n\nD�ugo�� linku nie mo�e przekroczy� 64 znak�w.\n\n{FF0000}* Link musi rozpoczyna� si� na \"http://\".", "Nagraj", "Anuluj");
				return 1;
	        }
	        if(strlen(inputtext) <= 0)
	        {
	            ShowPlayerDialog(playerid, D_DISC_RECORD, DIALOG_STYLE_INPUT, "Czysta p�yta � Nagrywanie", "To jest czysta p�yta, na kt�rej mo�esz nagra� dowolny kawa�ek.\nWklej w pole tekstowe poni�ej link do muzyki, kt�ra ma by� odtwarzana poprzez urz�dzenia.\n\nUpewnij si�, �e link jest poprawny w innym wypadku muzyka mo�e nie by� s�yszalna.\n\nD�ugo�� linku nie mo�e przekroczy� 64 znak�w.\n\n{FF0000}* Te pole nie mo�e by� puste!", "Nagraj", "Anuluj");
				return 1;
	        }
	        if(strlen(inputtext) > 64)
	        {
	            ShowPlayerDialog(playerid, D_DISC_RECORD, DIALOG_STYLE_INPUT, "Czysta p�yta � Nagrywanie", "To jest czysta p�yta, na kt�rej mo�esz nagra� dowolny kawa�ek.\nWklej w pole tekstowe poni�ej link do muzyki, kt�ra ma by� odtwarzana poprzez urz�dzenia.\n\nUpewnij si�, �e link jest poprawny w innym wypadku muzyka mo�e nie by� s�yszalna.\n\nD�ugo�� linku nie mo�e przekroczy� 64 znak�w.\n\n{FF0000}* Link nie mo�e przekroczy� 64 znak�w!", "Nagraj", "Anuluj");
				return 1;
	        }
	        mysql_real_escape_string(inputtext, audio_url);
			mysql_query_format("INSERT INTO `"SQL_PREF"audiourls` (`audio_url`) VALUES ('%s')", audio_url);

			audio_uid = mysql_insert_id();

			ItemCache[itemid][iValue1] = audio_uid;
			SaveItem(itemid, SAVE_ITEM_VALUES);

			ShowPlayerDialog(playerid, D_DISC_NAME, DIALOG_STYLE_INPUT, "Czysta p�yta � Nagrywanie � Nazwa", "Wprowad� w pole poni�ej nazw� Twojej p�yty, kt�ra b�dzie rozpoznawana w ekwipunku.\n\nNazwa nie mo�e przekroczy� 12 znak�w.", "Nagraj", "Pomi�");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_DISC_NAME)
	{
	    if(response)
	    {
	    	new itemid = PlayerCache[playerid][pManageItem], item_name[24];
	    	
      		if(strlen(inputtext) <= 0)
	        {
	            ShowPlayerDialog(playerid, D_DISC_NAME, DIALOG_STYLE_INPUT, "Czysta p�yta � Nagrywanie � Nazwa", "Wprowad� w pole poni�ej nazw� Twojej p�yty, kt�ra b�dzie rozpoznawana w ekwipunku.\n\nNazwa nie mo�e przekroczy� 12 znak�w.\n\n{FF0000}* Te pole nie mo�e by� puste!", "Nagraj", "Pomi�");
	            return 1;
	        }
	        if(strlen(inputtext) >= 12)
	        {
	            ShowPlayerDialog(playerid, D_DISC_NAME, DIALOG_STYLE_INPUT, "Czysta p�yta � Nagrywanie � Nazwa", "Wprowad� w pole poni�ej nazw� Twojej p�yty, kt�ra b�dzie rozpoznawana w ekwipunku.\n\nNazwa nie mo�e przekroczy� 12 znak�w.\n\n{FF0000}* Nazwa nie mo�e przekroczy� wi�cej ni� 12 znak�w!", "Nagraj", "Pomi�");
	            return 1;
	        }
	        mysql_real_escape_string(inputtext, item_name);
	        
	        format(item_name, sizeof(item_name), "(CD) %s", item_name);
	        strmid(ItemCache[itemid][iName], item_name, 0, strlen(item_name), 32);
	        
	        SaveItem(itemid, SAVE_ITEM_NAME);
	        ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "P�yta zosta�a pomy�lnie nagrana.\nP�yt� nazwa�e� nast�puj�co: %s.\n\nP�yty tej mo�esz ods�ucha� w odtwarzaczu lub za pomoc� sprz�tu audio w poje�dzie.", ItemCache[itemid][iName]);
	        return 1;
	    }
	    else
	    {
	        new itemid = PlayerCache[playerid][pManageItem];
	        
			strmid(ItemCache[itemid][iName], "Plyta", 0, 5, 32);
			SaveItem(itemid, SAVE_ITEM_NAME);
			
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Ustalono domy�ln� nazw� p�yty.\n\nP�yty tej mo�esz ods�ucha� w odtwarzaczu lub za pomoc� sprz�tu audio w poje�dzie.");
	        return 1;
	    }
	}
	if(dialogid == D_RADIO_OPTIONS)
	{
	    if(response)
	    {
     		switch(listitem)
	        {
	            case 0:
	            {
	                ShowPlayerDialog(playerid, D_RADIO_SET_CANAL, DIALOG_STYLE_INPUT, "CB radio � Ustaw kana�", "Wprowad� numer kana�u, z kt�rym pragniesz si� po��czy�:", "Dalej", "Anuluj");
	            }
	            case 1:
	            {
	                ShowPlayerDialog(playerid, D_RADIO_BUY_CANAL, DIALOG_STYLE_INPUT, "CB radio � Wykup kana� na w�asno��", "Wprowad� numer kana�u, jaki zamierzasz zakupi� na w�asno��:", "Dalej", "Anuluj");
	            }
	            case 2:
	            {
	                ShowPlayerDialog(playerid, D_RADIO_CANAL_PASSWORD, DIALOG_STYLE_INPUT, "CB radio � Ustaw has�o dla kana�u", "Wprowad� numer kana�u, dla kt�rego chcesz zmieni� has�o:", "Dalej", "Anuluj");
	            }
	            case 3:
	            {
	                ShowPlayerDialog(playerid, D_RADIO_DELETE_CANAL, DIALOG_STYLE_INPUT, "CB radio � Definitywnie usu� kana�", "Wprowad� numer kana�u, kt�ry chcesz usun��:", "Dalej", "Anuluj");
	            }
	            case 4:
	            {
	                ShowPlayerDialog(playerid, D_RADIO_ASSIGN_CANAL, DIALOG_STYLE_INPUT, "CB radio � Przypisz kana� pod grup�", "Wprowad� numer kana�u, kt�ry chcesz przypisa�:", "Dalej", "Anuluj");
	            }
	        }
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_RADIO_SET_CANAL)
	{
	    if(response)
	    {
	        if(strlen(inputtext) > 11 || strval(inputtext) <= 0)
	        {
             	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dny numer kana�u.");
	            return 1;
	        }
	        new vehid = GetPlayerVehicleID(playerid), radio_canal = strval(inputtext), data[64], string[128],
				channel_ownertype, channel_owner, channel_password[32];

	        mysql_query_format("SELECT `channel_ownertype`, `channel_owner`, `channel_password`  FROM `"SQL_PREF"radio_channels` WHERE channel_canal = '%d' LIMIT 1", radio_canal);

	        mysql_store_result();
	        if(mysql_fetch_row_format(data, "|"))
	        {
	            sscanf(data, "p<|>dds[32]", channel_ownertype, channel_owner, channel_password);
	            if(channel_ownertype == OWNER_PLAYER || (channel_ownertype == OWNER_GROUP && IsPlayerInGroup(playerid, channel_owner)))
	            {
	                if(strlen(channel_password))
					{
					    PlayerCache[playerid][pMainTable] = radio_canal;

					    format(string, sizeof(string), "Wprowad� poni�ej has�o dost�pu dla kana�u %d:", radio_canal);
	                	ShowPlayerDialog(playerid, D_RADIO_PASSWORD, DIALOG_STYLE_INPUT, "Wprowad� has�o", "Wprowad� poni�ej has�o dost�pu dla tego kana�u:", "Po��cz", "Anuluj");
					}
					else
					{
					    SetPlayerVehicleRadioCanal(playerid, vehid, radio_canal);
     					ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pomy�lnie po��czy�e� si� z kana�em %d.\nU�yj komendy /cb, by porozumiewa� si� na kanale z innymi.", radio_canal);
					}
				}
	            else
	            {
                    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie�, by m�c po��czy� si� z tym kana�em.");
	            }
			}
	        else
	        {
	            SetPlayerVehicleRadioCanal(playerid, vehid, radio_canal);
	            ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pomy�lnie po��czy�e� si� z kana�em %d.\nU�yj komendy /cb, by porozumiewa� si� na kanale z innymi.", radio_canal);
			}
	        mysql_free_result();
	        return 1;
	    }
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_RADIO_PASSWORD)
	{
	    if(response)
	    {
	        if(strlen(inputtext) >= 32 || strlen(inputtext) <= 0)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzone has�o jest nieprawid�owe.");
	            return 1;
	        }
	        new vehid = GetPlayerVehicleID(playerid), radio_canal = PlayerCache[playerid][pMainTable], channel_password[128];
	        
            mysql_real_escape_string(inputtext, channel_password);
	        mysql_query_format("SELECT `channel_uid` FROM `"SQL_PREF"radio_channels` WHERE channel_canal = '%d' AND channel_password = '%s' LIMIT 1", radio_canal, channel_password);

			mysql_store_result();
			if(mysql_num_rows() != 0)
			{
			    SetPlayerVehicleRadioCanal(playerid, vehid, radio_canal);
				ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pomy�lnie po��czy�e� si� z kana�em %d.\nU�yj komendy /cb, by porozumiewa� si� na kanale z innymi.", radio_canal);
			}
			else
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzone has�o jest nieprawid�owe.");
			}
			mysql_free_result();
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_RADIO_BUY_CANAL)
	{
	    if(response)
	    {
     		if(strlen(inputtext) > 11 || strval(inputtext) <= 0)
	        {
             	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dny numer kana�u.");
	            return 1;
	        }
	        new radio_canal = strval(inputtext), string[128];
	        mysql_query_format("SELECT `channel_uid` FROM `"SQL_PREF"radio_channels` WHERE channel_canal = '%d' LIMIT 1", radio_canal);

	        mysql_store_result();
	        if(mysql_num_rows() != 0)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten kana� jest niedost�pny.");
	        }
	        else
	        {
	            PlayerCache[playerid][pMainTable] = radio_canal;

	            format(string, sizeof(string), "Czy jeste� pewien, �e chcesz kupi� kana� %d na w�asno��? Koszt: $250.", radio_canal);
	            ShowPlayerDialog(playerid, D_RADIO_ACCEPT_CANAL, DIALOG_STYLE_MSGBOX, "CB radio � Wykup kana� na w�asno��", string, "Tak", "Nie");
	        }
	        mysql_free_result();
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_RADIO_ACCEPT_CANAL)
	{
	    if(response)
	    {
	        if(PlayerCache[playerid][pCash] < 250)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz takiej ilo�ci got�wki.");
	            return 1;
	        }
	        new radio_canal = PlayerCache[playerid][pMainTable];
	        mysql_query_format("INSERT INTO `"SQL_PREF"radio_channels` VALUES ('', '%d', '%d', '%d', '')", radio_canal, OWNER_PLAYER, PlayerCache[playerid][pUID]);

			crp_GivePlayerMoney(playerid, -250);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Wykupi�e� kana� %d na w�asno��. W opcjach CB radio mo�esz nim zarz�dza�.", radio_canal);
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_RADIO_CANAL_PASSWORD)
	{
	    if(response)
	    {
   			if(strlen(inputtext) > 11 || strval(inputtext) <= 0)
	        {
             	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dny numer kana�u.");
	            return 1;
	        }
	        new radio_canal = strval(inputtext), data[32], string[256],
				channel_ownertype, channel_owner;

	        mysql_query_format("SELECT `channel_ownertype`, `channel_owner` FROM `"SQL_PREF"radio_channels` WHERE channel_canal = '%d' LIMIT 1", radio_canal);

	        mysql_store_result();
			if(mysql_fetch_row_format(data, "|"))
			{
				sscanf(data, "p<|>dd", channel_ownertype, channel_owner);
    			if((channel_ownertype == OWNER_PLAYER && channel_owner == PlayerCache[playerid][pUID]) || (channel_ownertype == OWNER_GROUP && HavePlayerGroupPerm(playerid, channel_owner, G_PERM_LEADER)))
	            {
	                PlayerCache[playerid][pMainTable] = radio_canal;

	                format(string, sizeof(string), "Wprowad� poni�ej has�o, jakie chcesz ustawi� dla kana�u %d.\nPuste pole ca�kowicie zdejmuje has�o dla kana�u.\n\nHas�o nie mo�e przekroczy� 32 znak�w.", radio_canal);
	                ShowPlayerDialog(playerid, D_RADIO_SET_PASSWORD, DIALOG_STYLE_INPUT, "CB radio � Ustaw has�o dla kana�u", string, "Ustaw", "Anuluj");
				}
				else
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie masz odpowiednich uprawnie�, by m�c zmieni� has�o dla tego kana�u.");
				}
			}
			else
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie masz odpowiednich uprawnie�, by m�c zmieni� has�o dla tego kana�u.");
			}
	        mysql_free_result();
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_RADIO_SET_PASSWORD)
	{
		if(response)
		{
  			if(strlen(inputtext) >= 32)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wyst�pi� b��d", "Podane has�o jest za d�ugie.");
	            return 1;
	        }
	        new radio_canal = PlayerCache[playerid][pMainTable];

   	        if(strlen(inputtext))
	        {
	            new channel_password[64];
           		mysql_real_escape_string(inputtext, channel_password);

	            mysql_query_format("UPDATE `"SQL_PREF"radio_channels` SET channel_password = '%s' WHERE channel_canal = '%d' LIMIT 1", channel_password, radio_canal);
				ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Has�o dla kana�u %d zosta�o pomy�lnie zmienione.\nNowe has�o: %s", radio_canal, channel_password);
			}
			else
			{
			    mysql_query_format("UPDATE `"SQL_PREF"radio_channels` SET channel_password = '' WHERE channel_canal = '%d' LIMIT 1", radio_canal);
				ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Has�o dla kana�u %d zosta�o pomy�lnie zdj�te.", radio_canal);
			}
			return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_RADIO_DELETE_CANAL)
	{
		if(response)
		{
			if(strlen(inputtext) > 11 || strval(inputtext) <= 0)
	        {
             	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dny numer kana�u.");
	            return 1;
	        }
	        new radio_canal = strval(inputtext), data[32], string[128],
				channel_ownertype, channel_owner;

	        mysql_query_format("SELECT `channel_ownertype`, `channel_owner` FROM `"SQL_PREF"radio_channels` WHERE channel_canal = '%d' LIMIT 1", radio_canal);

	        mysql_store_result();
			if(mysql_fetch_row_format(data, "|"))
			{
				sscanf(data, "p<|>dd", channel_ownertype, channel_owner);
    			if((channel_ownertype == OWNER_PLAYER && channel_owner == PlayerCache[playerid][pUID]) || (channel_ownertype == OWNER_GROUP && HavePlayerGroupPerm(playerid, channel_owner, G_PERM_LEADER)))
	            {
	                PlayerCache[playerid][pMainTable] = radio_canal;

					format(string, sizeof(string), "Czy jeste� pewien, �e chcesz definitywnie usun�� kana� %d?", radio_canal);
					ShowPlayerDialog(playerid, D_RADIO_DELETE_ACCEPT, DIALOG_STYLE_MSGBOX, "CB radio � Definitywnie usu� kana�", string, "Tak", "Nie");
				}
				else
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie�, by m�c usun�� ten kana�.");
				}
			}
			else
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie�, by m�c usun�� ten kana�.");
			}
	        mysql_free_result();
		    return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_RADIO_DELETE_ACCEPT)
	{
	    if(response)
	    {
	        new radio_canal = PlayerCache[playerid][pMainTable];
	        mysql_query_format("DELETE FROM `"SQL_PREF"radio_channels` WHERE channel_canal = '%d' LIMIT 1", radio_canal);
	        
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Kana� %d zosta� definitywnie usuni�ty.", radio_canal);
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_RADIO_ASSIGN_CANAL)
	{
	    if(response)
	    {
  			if(strlen(inputtext) > 11 || strval(inputtext) <= 0)
	        {
             	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dny numer kana�u.");
	            return 1;
	        }
	        new radio_canal = strval(inputtext), data[32],
				channel_ownertype, channel_owner;

	        mysql_query_format("SELECT `channel_ownertype`, `channel_owner` FROM `"SQL_PREF"radio_channels` WHERE channel_canal = '%d' LIMIT 1", radio_canal);

	        mysql_store_result();
			if(mysql_fetch_row_format(data, "|"))
			{
				sscanf(data, "p<|>dd", channel_ownertype, channel_owner);
    			if(channel_ownertype == OWNER_PLAYER && channel_owner == PlayerCache[playerid][pUID])
	            {
	                PlayerCache[playerid][pMainTable] = radio_canal;

					new list_groups[256], group_id;
					for (new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
					{
						if(PlayerGroup[playerid][group_slot][gpUID])
			  			{
			  				group_id = PlayerGroup[playerid][group_slot][gpID];
							format(list_groups, sizeof(list_groups), "%s\n%d\t%s (%d)", list_groups, group_slot + 1, GroupData[group_id][gName], GroupData[group_id][gUID]);
			 			}
					}
					ShowPlayerDialog(playerid, D_RADIO_ASSIGN_ACCEPT, DIALOG_STYLE_LIST, "SLOT      NAZWA GRUPY", list_groups, "Wybierz", "Anuluj");
				}
				else
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie�, by m�c przypisa� ten kana�.");
				}
			}
			else
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie�, by m�c przypisa� ten kana�.");
			}
	        mysql_free_result();
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_RADIO_ASSIGN_ACCEPT)
	{
	    if(response)
	    {
	        new group_slot = strval(inputtext) - 1, radio_canal = PlayerCache[playerid][pMainTable];
			if(group_slot < 0)
			{
			    TD_ShowSmallInfo(playerid, 3, "Przypisywanie kanalu zostalo ~r~anulowane~w~.");
			    return 1;
			}
			new group_id = PlayerGroup[playerid][group_slot][gpID];
			if(!HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_LEADER))
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie� dla tej grupy.");
			    return 1;
			}
			
			mysql_query_format("UPDATE `"SQL_PREF"radio_channels` SET channel_ownertype = '%d', channel_owner = '%d' WHERE channel_canal = '%d' LIMIT 1", OWNER_GROUP, GroupData[group_id][gUID], radio_canal);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Kana� %d zosta� pomy�lnie przypisany pod grup�.\nKana� przypisano dla grupy %s (UID: %d).", radio_canal, GroupData[group_id][gName], GroupData[group_id][gUID]);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ROOM_PRICE)
	{
		if(response)
		{
		    new price = strval(inputtext);
		    if(price < 0 || strlen(inputtext) > 11 || price > 100)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
		        return 1;
		    }
		    new doorid = GetPlayerDoorID(playerid);
		    if(doorid == INVALID_DOOR_ID)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		        return 1;
		    }
		    if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || !HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_LEADER))
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie� do u�ycia tej funkcji.");
		        return 1;
		    }
		    new group_id = GetGroupID(DoorCache[doorid][dOwner]);

			GroupData[group_id][gValue1] = price;
			SaveGroup(group_id);

			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Koszt wynajmu pokoju zosta� pomy�lnie zmieniony.\nNowy koszt za wynajem pokoju wynosi: $%d.", GroupData[group_id][gValue1]);
		    return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_TUNING_UNMOUNT)
	{
	    if(response)
	    {
  			new item_uid, componentid, vehid = GetPlayerVehicleID(playerid);
			sscanf(inputtext, "dd", item_uid, componentid);

			mysql_query_format("UPDATE `"SQL_PREF"items` SET item_place = '%d', item_owner = '%d', item_vehuid = '0' WHERE item_uid = '%d' LIMIT 1", PLACE_PLAYER, PlayerCache[playerid][pUID], item_uid);

			LoadItemCache(item_uid);
			crp_RemoveVehicleComponent(vehid, componentid);

			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Cz�� zosta�a odmontowana pomy�lnie.\nOdmontowan� cz�� znajdziesz w swoim ekwipunku.");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ACCESS_APPLY)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz tego zrobi� siedz�c w poje�dzie.");
	    	return 1;
		}

		new itemid = PlayerCache[playerid][pMainTable],
			slot_index = GetPlayerFreeSlotAccess(playerid);
			
		if(slot_index == INVALID_SLOT_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego wolnego slotu dla akcesoria.");
	    	return 1;
		}

		new data[256], access_uid, access_model, access_bone,
  			Float:access_posx, Float:access_posy, Float:access_posz,
			Float:access_rotx, Float:access_roty, Float:access_rotz,
			Float:access_scalex, Float:access_scaley, Float:access_scalez;
			
		if(ItemCache[itemid][iValue1])			access_uid = ItemCache[itemid][iValue1];
		else if(ItemCache[itemid][iValue2]) 	access_uid = ItemCache[itemid][iValue2];

		mysql_query_format("SELECT `access_model`, `access_bone`, `access_posx`, `access_posy`, `access_posz`, `access_rotx`, `access_roty`, `access_rotz`, `access_scalex`, `access_scaley`, `access_scalez` FROM `"SQL_PREF"access` WHERE access_uid = '%d' LIMIT 1", access_uid);

		mysql_store_result();
		if(mysql_fetch_row_format(data, "|"))
		{
  			sscanf(data, "p<|>ddfffffffff", access_model, access_bone, access_posx, access_posy, access_posz, access_rotx, access_roty, access_rotz, access_scalex, access_scaley, access_scalez);
			SetPlayerAttachedObject(playerid, slot_index, access_model, access_bone, access_posx, access_posy, access_posz, access_rotx, access_roty, access_rotz, access_scalex, access_scaley, access_scalez);
		}
		mysql_free_result();
		
  		ItemCache[itemid][iUsed] = true;
    	SaveItem(itemid, SAVE_ITEM_USED);
	
	    if(response)
	    {
	        TD_ShowSmallInfo(playerid, 3, "Akcesorie zostalo ~g~pomyslnie ~w~zalozone.");
	        return 1;
	    }
	    else
		{
			EditAttachedObject(playerid, slot_index);
			TD_ShowSmallInfo(playerid, 3, "Dopasuj ~y~akcesorie ~w~wzgledem swojego skina.");
	        return 1;
	    }
	}
	if(dialogid == D_CLOTH_TYPE_SELECT)
	{
	    if(response)
	    {
    		new Float:PosX, Float:PosY, Float:PosZ;
			GetPlayerPos(playerid, PosX, PosY, PosZ);
			
			GetXYInFrontOfPlayer(playerid, PosX, PosY, 3.0);
			
			switch(listitem)
			{
			    case 0:
			    {
			        SetPlayerCameraPos(playerid, PosX, PosY, PosZ + 0.5);
			    
			        PlayerCache[playerid][pSelectSkin] = 0;
			        TD_ShowSmallInfo(playerid, 0, "Uzywaj ~y~strzalek~w~, aby wybrac ~g~ubranie~w~.~n~~n~~y~~k~~VEHICLE_ENTER_EXIT~ ~w~- dokonaj zakupu~n~~y~~k~~PED_JUMPING~ ~w~- anuluj zakup");
			    }
			    case 1:
			    {
			        SetPlayerCameraPos(playerid, PosX, PosY, PosZ + 0.7);
			    
			        PlayerCache[playerid][pSelectAccess] = 0;
			        TD_ShowSmallInfo(playerid, 0, "Uzywaj ~y~strzalek~w~, aby wybrac ~g~akcesorie~w~.~n~~n~~y~~k~~VEHICLE_ENTER_EXIT~ ~w~- dokonaj zakupu~n~~y~~k~~PED_JUMPING~ ~w~- anuluj zakup");
			    }
			}
			
			GetPlayerPos(playerid, PosX, PosY, PosZ);
			SetPlayerCameraLookAt(playerid, PosX, PosY, PosZ);

            OnPlayerFreeze(playerid, true, 0);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_DIRECTORY_LIST)
	{
	    if(response)
	    {
			if(!strfind(inputtext, "Dodaj nowy wpis...", true))
			{
				ShowPlayerDialog(playerid, D_DIRECTORY_ADD, DIALOG_STYLE_INPUT, "Kartoteka � Dodaj nowy wpis", "Wprowad� poni�ej tre�� wpisu, kt�ry zostanie dodany do kartoteki tego gracza.\nMaksymalna ilo�� znak�w wynosi: 64.", "Dodaj", "Anuluj");
			    return 1;
			}
			
			new directory_uid;
			if(sscanf(inputtext, "d{s[14]s[24]}", directory_uid))	return 1;
			
			new data[256], string[256], title[64],
				giver_name[32], directory_reason[64], directory_date[32], directory_pdp;
				
			mysql_query_format("SELECT `char_name`, `directory_reason`, `directory_date`, `directory_pdp` FROM `"SQL_PREF"directory`, `"SQL_PREF"characters` WHERE char_uid = directory_giver AND directory_uid = '%d' LIMIT 1", directory_uid);

			mysql_store_result();
			if(mysql_fetch_row_format(data, "|"))
			{
			    sscanf(data, "p<|>s[32]s[64]s[32]d", giver_name, directory_reason, directory_date, directory_pdp);
		    	new pos = strfind(giver_name, "_", true);

				while(pos != -1)	{ giver_name[pos] = ' ';	pos = strfind(giver_name, "_", true); }
			    format(string, sizeof(string), "Funkcjonariusz: %s\nPunkty karne: %d\n\nTre�� wpisu:\n%s\n\nCzas: %s", giver_name, directory_pdp, directory_reason, directory_date);

				format(title, sizeof(title), "Szczeg�y wpisu (identyfikator: %d)", directory_uid);
				ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, title, string, "OK", "");
			}
			else
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono wpisu o danym identyfikatorze.");
			}
			mysql_free_result();
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_DIRECTORY_ADD)
	{
	    if(response)
	    {
     		if(strlen(inputtext) > 64)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podana tre�� przekracza maksymaln� ilo�� znak�w.\nSpr�buj ponownie, wpisuj�c inn� tre��.");
	            return 1;
	        }
	        
	        new directory_owner = PlayerCache[playerid][pMainTable],
	            directory_giver = PlayerCache[playerid][pUID],
	            directory_reason[128], directory_uid;

            mysql_real_escape_string(inputtext, directory_reason);
            mysql_query_format("INSERT INTO `"SQL_PREF"directory` VALUES ('', '%d', '%d', '%s', '0', NOW())", directory_owner, directory_giver, directory_reason);

			directory_uid = mysql_insert_id();
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pomy�lnie dodano nowy wpis do kartoteki.\nIdentyfikator wpisu: %d", directory_uid);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_BLOCK_WHEEL)
	{
	    if(response)
	    {
     		new price = strval(inputtext), vehid = PlayerCache[playerid][pMainTable];
	        if(strlen(inputtext) > 6 || price <= 0 || price > 25000)
	        {
				ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
	            return 1;
	        }
	        CarInfo[vehid][cBlockWheel] = price;

	        CarInfo[vehid][cWorldID] = GetVehicleVirtualWorld(vehid);
	        CarInfo[vehid][cInteriorID] = GetPlayerInterior(playerid);

	        GetVehiclePos(vehid, CarInfo[vehid][cPosX], CarInfo[vehid][cPosY], CarInfo[vehid][cPosZ]);
	        GetVehicleZAngle(vehid, CarInfo[vehid][cPosA]);

			SaveVehicle(vehid, SAVE_VEH_POS | SAVE_VEH_ACCESS);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Blokada na ko�o zosta�a za�o�ona.\n\nZablokowany pojazd: %s\nKoszt zdj�cia blokady: $%d\n\nPojazd zosta� automatycznie zaparkowany w tym miejscu.", GetVehicleName(CarInfo[vehid][cModel]), price);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_REGISTER_EDIT)
	{
	    if(response)
	    {
	        if(strlen(inputtext) > 12)
	        {
        		ShowPlayerDialog(playerid, D_REGISTER_EDIT, DIALOG_STYLE_INPUT, "W�asna rejestracja", "Wprowad� poni�ej tre�� w�asnej rejestracji.\nNapis na rejestracji zostanie zmieniony zgodnie z podana tre�ci�.\n\nIlo�� znak�w w rejestracji nie mo�e przekroczy� 12.\n\n{FF0000}* Podana tre�� nie mo�e przekroczy� liczby 12 znak�w", "Zmie�", "Anuluj");
	            return 1;
	        }
	        if(!strfind(inputtext, "LS", true))
	        {
                ShowPlayerDialog(playerid, D_REGISTER_EDIT, DIALOG_STYLE_INPUT, "W�asna rejestracja", "Wprowad� poni�ej tre�� w�asnej rejestracji.\nNapis na rejestracji zostanie zmieniony zgodnie z podana tre�ci�.\n\nIlo�� znak�w w rejestracji nie mo�e przekroczy� 12.\n\n{FF0000}* Nie mo�esz wpisa� tej tre�ci w rejestracji", "Zmie�", "Anuluj");
	            return 1;
	        }
	        new vehid = GetPlayerVehicleID(playerid),
				register_desc[32];

			if(!strlen(inputtext))		format(register_desc, sizeof(register_desc), "LS%d", CarInfo[vehid][cUID]);
			else						mysql_real_escape_string(inputtext, register_desc);

			strmid(CarInfo[vehid][cRegister], register_desc, 0, strlen(register_desc), 12);

			SaveVehicle(vehid, SAVE_VEH_ACCESS);
         	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Tre�� rejestracji zosta�a pomy�lnie zmodyfikowana.\nZalecany jest respawn pojazdu, by tablice uleg�y zmianie.\n\nTre�� rejestracji: %s", CarInfo[vehid][cRegister]);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_PLAY_ANIM)
	{
	    if(response)
	    {
     		new anim_id = listitem;
	        if(!AnimCache[anim_id][aAction])
	        {
	        	ApplyAnimation(playerid, AnimCache[anim_id][aLib], AnimCache[anim_id][aName], AnimCache[anim_id][aSpeed], AnimCache[anim_id][aOpt1], AnimCache[anim_id][aOpt2], AnimCache[anim_id][aOpt3], AnimCache[anim_id][aOpt4], AnimCache[anim_id][aOpt5], true);
				TD_ShowSmallInfo(playerid, 3, "~g~PPM ~w~anuluje gre animacji.");
			}
			else
			{
			    SetPlayerSpecialAction(playerid, AnimCache[anim_id][aAction]);
				TD_ShowSmallInfo(playerid, 3, "~g~~k~~VEHICLE_ENTER_EXIT~ ~w~anuluje gre animacji.");
			}
			PlayerCache[playerid][pPlayAnim] = true;
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_WALK_ANIM)
	{
	    if(response)
	    {
			new anim_id = listitem;
			
			PlayerCache[playerid][pWalkStyle] = anim_id;
			OnPlayerSave(playerid, SAVE_PLAYER_SETTING);
			
			TD_ShowSmallInfo(playerid, 3, "Animacja chodzenia zostala ~g~pomyslnie ~w~wybrana.~n~Klawisz ~r~~k~~SNEAK_ABOUT~ ~w~aktywuje animacje.");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ORDER_CATEGORY)
	{
	    if(response)
	    {
	        new data[128], doorid = PlayerCache[playerid][pMainTable],
	            list_orders[1024], order_category = strval(inputtext), order_uid, order_name[32], order_price;
			
			new group_id = GetGroupID(DoorCache[doorid][dOwner]);
			mysql_query_format("SELECT `order_uid`, `order_name`, `order_price` FROM `"SQL_PREF"orders` WHERE order_cat = '%d' AND order_owner = '%d' AND order_extraid = '0' OR order_cat = '%d' AND order_owner = '0' AND order_extraid = '%d'", order_category, GroupData[group_id][gType], order_category, GroupData[group_id][gUID]);
			
			mysql_store_result();
			while(mysql_fetch_row_format(data, "|"))
			{
			    sscanf(data, "p<|>ds[32]d", order_uid, order_name, order_price);
			    format(list_orders, sizeof(list_orders), "%s\n%d\t$%d\t%s", list_orders, order_uid, order_price, order_name);
			}
			mysql_free_result();
			
			if(strlen(list_orders))
			{
			    ShowPlayerDialog(playerid, D_ORDER_PRODUCT, DIALOG_STYLE_LIST, "Wybierz produkt:", list_orders, "Wybierz", "Anuluj");
			}
			else
			{
   				TD_ShowSmallInfo(playerid, 3, "Nie posiadasz tutaj ~r~dostepu~w~.");

				PlayerCache[playerid][pMainTable] = 0;
				PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid, SLOT_PHONE);
			}
	        return 1;
	    }
	    else
	    {
	        TD_ShowSmallInfo(playerid, 3, "Zamawianie zostalo ~r~anulowane~w~.");
	    
			PlayerCache[playerid][pMainTable] = 0;
			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);
	        return 1;
	    }
	}
	if(dialogid == D_ORDER_PRODUCT)
	{
	    if(response)
	    {
     		new string[256];
	        sscanf(inputtext, "d'$'ds[32]", OrderCache[playerid][oUID], OrderCache[playerid][oPrice], OrderCache[playerid][oName]);

			format(string, sizeof(string), "Wprowad� poni�ej, ile produkt�w tego typu chcesz zam�wi�.\nJe�eli zamawiasz hurtowo, cena maleje a� o 40%%.\n\nNazwa produktu: %s\nKoszt za sztuk�: $%d", OrderCache[playerid][oName], OrderCache[playerid][oPrice]);
			ShowPlayerDialog(playerid, D_ORDER_COUNT, DIALOG_STYLE_INPUT, "Ilo�� sztuk", string, "Dalej", "Anuluj");
	        return 1;
	    }
	    else
	    {
     		TD_ShowSmallInfo(playerid, 3, "Zamawianie zostalo ~r~anulowane~w~.");

			PlayerCache[playerid][pMainTable] = 0;
			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);
	        return 1;
	    }
	}
	if(dialogid == D_ORDER_COUNT)
	{
	    if(response)
	    {
   			new product_count = strval(inputtext), string[128];
			if(strlen(inputtext) > 11 || product_count <= 0)
			{
				format(string, sizeof(string), "Wprowad� poni�ej, ile produkt�w tego typu chcesz zam�wi�.\nJe�eli zamawiasz hurtowo, cena maleje a� o 40%%.\n\nNazwa produktu: %s\nKoszt za sztuk�: $%d", OrderCache[playerid][oName], OrderCache[playerid][oPrice]);
				ShowPlayerDialog(playerid, D_ORDER_COUNT, DIALOG_STYLE_INPUT, "Ilo�� sztuk", string, "Dalej", "Anuluj");

				TD_ShowSmallInfo(playerid, 3, "Wprowadzono ~r~bledna ~w~ilosc sztuk.");
			    return 1;
			}
			if(PlayerCache[playerid][pCash] < OrderCache[playerid][oPrice] * product_count)
			{
				format(string, sizeof(string), "Wprowad� poni�ej, ile produkt�w tego typu chcesz zam�wi�.\nJe�eli zamawiasz hurtowo, cena maleje a� o 40%%.\n\nNazwa produktu: %s\nKoszt za sztuk�: $%d", OrderCache[playerid][oName], OrderCache[playerid][oPrice]);
				ShowPlayerDialog(playerid, D_ORDER_COUNT, DIALOG_STYLE_INPUT, "Ilo�� sztuk", string, "Dalej", "Anuluj");

				TD_ShowSmallInfo(playerid, 3, "Nie posiadasz tyle ~r~gotowki~w~.");
			    return 1;
			}
			OrderCache[playerid][oCount] = product_count;
			ShowPlayerDialog(playerid, D_ORDER_PRICE, DIALOG_STYLE_INPUT, "Koszt produktu", "Wprowad� oferowan� cen� produktu.\nCena jak� wprowadzisz b�dzie pobierana za zakup produktu w Twojej instytucji.\n\nCena powinna by� wy�sza ni� hurtowa, by� mia� profit z wyprzedanych produkt�w.\nKoszt danego produktu mo�esz zmieni� za pomoc� /drzwi opcje, b�d� w panelu.", "Zam�w", "Anuluj");
	        return 1;
	    }
	    else
	    {
   			TD_ShowSmallInfo(playerid, 3, "Zamawianie zostalo ~r~anulowane~w~.");

			PlayerCache[playerid][pMainTable] = 0;
			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);
	        return 1;
	    }
	}
	if(dialogid == D_ORDER_PRICE)
	{
		if(response)
		{
  			new price = strval(inputtext), doorid = PlayerCache[playerid][pMainTable];
	        if(price <= 0 || strlen(inputtext) >= 10 || price > (OrderCache[playerid][oPrice] + floatround(OrderCache[playerid][oPrice] * 0.8)))
	        {
				ShowPlayerDialog(playerid, D_ORDER_PRICE, DIALOG_STYLE_INPUT, "Koszt produktu", "Wprowad� oferowan� cen� produktu.\nCena jak� wprowadzisz b�dzie pobierana za zakup produktu w Twojej instytucji.\n\nCena powinna by� wy�sza ni� hurtowa, by� mia� profit z wyprzedanych produkt�w.\nKoszt danego produktu mo�esz zmieni� za pomoc� /drzwi opcje, b�d� w panelu.", "Zam�w", "Anuluj");
				TD_ShowSmallInfo(playerid, 3, "Wprowadzono ~r~bledna ~w~cene produktu.");
	            return 1;
	        }
  			new data[24], order_price = OrderCache[playerid][oPrice] * OrderCache[playerid][oCount],
			    order_item_type, order_item_value1, order_item_value2, order_type;

			// Jednak we�miemy mu o 40% mniej got�wki, niech zarobi
			if(OrderCache[playerid][oCount] >= 20)	order_price = floatround(order_price * 0.6);
			mysql_query_format("SELECT `order_item_type`, `order_item_value1`, `order_item_value2`, `order_type` FROM `"SQL_PREF"orders` WHERE order_uid = '%d' LIMIT 1", OrderCache[playerid][oUID]);

			mysql_store_result();
			if(mysql_fetch_row_format(data, "|"))
			{
				sscanf(data, "p<|>dddd", order_item_type, order_item_value1, order_item_value2, order_type);
			}
			mysql_free_result();

			crp_GivePlayerMoney(playerid, -order_price);
			CreatePackage(DoorCache[doorid][dUID], OrderCache[playerid][oName], order_item_type, order_item_value1, order_item_value2, OrderCache[playerid][oCount], price, order_type);

			PlayerCache[playerid][pMainTable] = 0;
			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);
			
			switch(order_type)
			{
			    case PACKAGE_PRODUCT:   ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Z�o�y�e� zam�wienie dla produktu.\n\nZostanie od przywieziony przez jednego z kurier�w.\nAby sprawdzi� zawarto�� magazynu, u�yj komendy /drzwi opcje.");
			    case PACKAGE_DRUGS:     ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Z�o�y�e� zam�wienie dla narkotyku.\n\nSkorzystaj z komendy /hurtownia, by je osobi�cie odebra�.\nMo�esz te� wys�a� jednego z cz�onk�w Twojej grupy.\nAby sprawdzi� zawarto�� magazynu, u�yj komendy /drzwi opcje.");
				case PACKAGE_WEAPON:    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Z�o�y�e� zam�wienie dla broni.\n\nSkorzystaj z komendy /hurtownia, by odebra� bro� osobi�cie.\nMo�esz te� wys�a� jednego z cz�onk�w Twojej grupy.\nAby sprawdzi� zawarto�� magazynu, u�yj komendy /drzwi opcje.");
			}
		    return 1;
		}
		else
		{
			TD_ShowSmallInfo(playerid, 3, "Zamawianie zostalo ~r~anulowane~w~.");

			PlayerCache[playerid][pMainTable] = 0;
			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);
		    return 1;
		}
	}
	if(dialogid == D_BUS_ACCEPT)
	{
	    if(response)
	    {
  			new price = PlayerCache[playerid][pBusPrice];
			if(PlayerCache[playerid][pCash] < price)
			{
			    PlayerCache[playerid][pBusTravel] = INVALID_OBJECT_ID;
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz takiej ilo�ci got�wki.");
			    
			    if(PlayerCache[playerid][pBusStart] == INVALID_OBJECT_ID)   return 1;

				SetPlayerCameraPos(playerid, PlayerCache[playerid][pBusPosition][0], PlayerCache[playerid][pBusPosition][1], PlayerCache[playerid][pBusPosition][2] + 60.0);
				SetPlayerCameraLookAt(playerid, PlayerCache[playerid][pBusPosition][0], PlayerCache[playerid][pBusPosition][1] + 2, PlayerCache[playerid][pBusPosition][2], CAMERA_MOVE);

				TD_ShowSmallInfo(playerid, 0, "Uzywaj klawiszy ~y~strzalek, ~w~by dowolnie zmieniac pozycje widoku z lotu ptaka.~n~~n~~y~~k~~PED_JUMPING~ ~w~- wybierz najblizszy przystanek~n~~y~~k~~VEHICLE_ENTER_EXIT~ ~w~- anuluj przejazdzke");
       			return 1;
			}
			new object_id = PlayerCache[playerid][pBusTravel],
			    Float:PosX, Float:PosY, Float:PosZ, string[128];

			format(string, sizeof(string), "* %s wsiada do autobusu odje�d�aj�cego w stron� przystanku nr %d.", PlayerName(playerid), GetObjectUID(object_id));
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			    
			GetDynamicObjectPos(object_id, PosX, PosY, PosZ);
			    
			crp_GivePlayerMoney(playerid, -price);
			crp_SetPlayerPos(playerid, PosX, PosY, PosZ - 80.0);

			SetPlayerVirtualWorld(playerid, 1000 + playerid);
			SetPlayerInterior(playerid, 1000 + playerid);

			SetPlayerCameraPos(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]);
			SetPlayerCameraLookAt(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]);

			PlayerPlaySound(playerid, 1076, 0.0, 0.0, 0.0);
			PlayerCache[playerid][pBusRide] = true;
	        return 1;
	    }
	    else
	    {
	        PlayerCache[playerid][pBusTravel] = INVALID_OBJECT_ID;
	        if(PlayerCache[playerid][pBusStart] == INVALID_OBJECT_ID)   return 1;
	    
	        SetPlayerCameraPos(playerid, PlayerCache[playerid][pBusPosition][0], PlayerCache[playerid][pBusPosition][1], PlayerCache[playerid][pBusPosition][2] + 60.0);
			SetPlayerCameraLookAt(playerid, PlayerCache[playerid][pBusPosition][0], PlayerCache[playerid][pBusPosition][1] + 2, PlayerCache[playerid][pBusPosition][2], CAMERA_MOVE);

			TD_ShowSmallInfo(playerid, 0, "Uzywaj klawiszy ~y~strzalek, ~w~by dowolnie zmieniac pozycje widoku z lotu ptaka.~n~~n~~y~~k~~PED_JUMPING~ ~w~- wybierz najblizszy przystanek~n~~y~~k~~VEHICLE_ENTER_EXIT~ ~w~- anuluj przejazdzke");
	        return 1;
	    }
	}
	if(dialogid == D_PACKAGE_GET)
	{
	    if(response)
	    {
	        new package_id = GetPackageID(strval(inputtext));
	        foreach(new i : Player)
	        {
	            if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	            {
	                if(PlayerCache[i][pPackage] == package_id)
	                {
	                    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ta paczka jest ju� dostarczana przez %s.", PlayerName(i));
	                    return 1;
	                }
	            }
	        }
	        
	        new Float:pointX, Float:pointY, Float:pointZ;
			switch(PackageCache[package_id][pType])
			{
			    case PACKAGE_PRODUCT:
			    {
					pointX = -1723.5980;
					pointY = -120.0194;
					pointZ = 3.5489;
				}
				case PACKAGE_DRUGS:
				{
				    pointX = 2846.3840;
				    pointY = 983.6556;
				    pointZ = 10.7500;
				}
				case PACKAGE_WEAPON:
				{
				    pointX = -1862.0475;
				    pointY = -144.4339;
				    pointZ = 11.8984;
				}
			}
			PlayerCache[playerid][pCheckpoint] = CHECKPOINT_PACKAGE;
			PlayerCache[playerid][pPackage] = package_id;
			
			SetPlayerCheckpoint(playerid, pointX, pointY, pointZ, 5.0);
			TD_ShowSmallInfo(playerid, 3, "Udaj sie do ~r~wyznaczonego ~w~punktu na mapie.");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_WORK_SELECT)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
					PlayerCache[playerid][pMainTable] = JOB_MECHANIC;
					ShowPlayerDialog(playerid, D_WORK_ACCEPT, DIALOG_STYLE_MSGBOX, "Dorywcza � Mechanik", "Praca mechanika polega na naprawianiu, lakierowaniu, b�d� tankowaniu\npojazd�w. Za ka�d� zaoferowan� us�ug� zarabiasz konkretny procent.\n\nJest to praca dla mi�o�nik�w motoryzacji, aby m�c przelakierowa�\nkomu� pojazd, potrzebowa� b�dziesz do tego lakieru, kt�ry zakupi� mo�esz w jakim� warsztacie.\n\nCzy jeste� pewien �e chcesz podj�� si� tej pracy?", "Tak", "Nie");
	            }
	            case 1:
	            {
	                PlayerCache[playerid][pMainTable] = JOB_COURIER;
             		ShowPlayerDialog(playerid, D_WORK_ACCEPT, DIALOG_STYLE_MSGBOX, "Dorywcza � Kurier", "Praca kuriera polega na rozwo�eniu paczek do poszczeg�lnych\ninstytucji. Za ka�d� paczk� otrzymasz odpowiedni� sum� got�wki.\n\nKurier mo�e uda� si� do hurtowni, a nast�pnie odebra� z niej\npaczk� i dostarczy� pod wskazany na mapie adres.\n\nCzy jeste� pewien �e chcesz podj�� si� tej pracy?", "Tak", "Nie");
	            }
	            case 2:
	            {
	                PlayerCache[playerid][pMainTable] = JOB_SELLER;
	                ShowPlayerDialog(playerid, D_WORK_ACCEPT, DIALOG_STYLE_MSGBOX, "Dorywcza � Sprzedawca", "Praca sprzedawcy polega na handlu �ywno�ci� stoj�c przy budkach.\nZa ka�dy sprzedany produkt otrzymujesz nale�n� prowizj�.\n\nCzy jeste� pewien, �e chcesz podj�� si� tej pracy?", "Tak", "Nie");
	            }
	        }
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_WORK_ACCEPT)
	{
	    if(response)
	    {
	        PlayerCache[playerid][pJob] = PlayerCache[playerid][pMainTable];
	        OnPlayerSave(playerid, SAVE_PLAYER_BASIC);
	        
	        ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Gratulacje! Podj��e� si� nowej pracy dorywczej.\nSkorzystaj z komendy /pomoc, by zobaczy� dodatkowe przywileje.");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_HELP_MAIN)
	{
	    if(response)
	    {
	        new list_item = PlayerCache[playerid][pMainTable];
	        
	        if(!list_item)
	        {
				new help_type[24];
				sscanf(inputtext, "'�'s[24]", help_type);
				
				if(!strcmp(help_type, "Wprowadzenie", true))
				{
        			ShowPlayerDialog(playerid, D_INTRO, DIALOG_STYLE_MSGBOX, "Wprowadzenie (1/2)", "Witaj na serwerze "SERVER_NAME"!\n\nNa sam pocz�tek zalecane jest zapoznanie si� z komend� /pomoc,\ndowiesz si� tam wielu ciekawych rzeczy zwi�zanych z tutejsz� rozgrywk�.\n\nJak wida�, pojawi�e� si� na Unity Station, aby jednak dosta�\nsi� do Urz�du b�dziesz musia� wykorzysta� autobus, b�d� taks�wk�.", "Dalej", "Zamknij");
				    return 1;
				}
				
				if(!strcmp(help_type, "Komendy podstawowe", true))
				{
				    ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Pomoc � Komendy podstawowe", "(/p)rzedmiot, (/o)feruj, (/tel)efon, /sms /stats, (/a)dmins\n/kup, /pokoj, /opis, /bank, /id, /pokaz, /tog, /pay, /tankuj\n(/anim)acje, /wyrzuc, /report, /qs, /przebierz, /bus\n\nRodzaje czat�w:\n(/k)rzycz, /c, /l, /b, /me, /do, /w, /re, /m", "OK", "");
					return 1;
				}
				
				if(!strcmp(help_type, "Pojazd", true))
				{
				    ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Pomoc � Pojazd", "Jak ka�dy szary obywatel miasta, mo�esz posiada� pojazd na w�asno��.\nZakupisz go w salonie samochodowym, lub te� (troch� gorszy) na z�omowisku.\n\nPracownik jednej z firm, zaoferuje Ci pojazd jakiego potrzebujesz,\na po zaakceptowaniu oferty b�dzie on ju� nale�a� do Ciebie.\n\nKomendy dla pojazdu:\n/pojazd [namierz, zaparkuj, tuning, przypisz, zamknij, info, opis]", "OK", "");
				    return 1;
				}
				
				if(!strcmp(help_type, "Ekwipunek", true))
				{
				    ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Pomoc � Ekwipunek", "Aby zarz�dza� swoimi przedmiotami w ekwipunku, u�yj komendy (/p)rzedmioty.\nJest to bardzo prosty interfejs, kt�ry pozwala na szybkie zarz�dzanie nimi.\n\nWybrany przedmiot (w zale�no�ci od rodzaju) mo�esz:\n   � od�o�y�\n   � sprzeda�\n   � z��czy�\n   � roz��czy�\n\nDost�pne komendy dla przedmiot�w:\n/p [lista, podnies, pokaz]", "OK", "");
				    return 1;
				}
				
				if(!strcmp(help_type, "Praca dorywcza", true))
				{
				    ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Pomoc � Praca dorywcza", "Opr�cz pracy w firmach lub organizacjach porz�dkowych, mo�esz r�wnie�\nzarobi� troch� got�wki korzystaj�c z prac dorywczych.\n\nUdaj si� ko�o urz�du miasta, w miejsce tablicy og�osze�,\na z pewno�ci� znajdziesz co� co Ci odpowiada i b�dziesz m�g� zarobi�.\n\nDost�pne prace dorywcze:\n   � mechanik\n   � kurier\n   � sprzedawca\n\nPo wyborze jednej z prac b�dziesz m�g� rozpocz�� zarabianie od zaraz!", "OK", "");
				    return 1;
				}
				
				if(!strcmp(help_type, "Animacje", true))
				{
				    cmd_anim(playerid, "");
				    return 1;
				}
				
				if(!strcmp(help_type, "Dost�pne oferty", true))
				{
				    cmd_oferuj(playerid, "");
				    return 1;
				}
			}
			else
			{
			
			}
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_TAXI_CORP_SELECT)
	{
	    if(response)
	    {
     		new group_id = strval(inputtext), string[256];
			PlayerCache[playerid][pCallingTo] = group_id;

			format(string, sizeof(string), "Dodzwoni�e� si� do %s znajdujacego si� w Los Santos.\nPodaj szczeg�owo miejsce po�o�enia w jakim si� znajdujesz, a my wy�lemy do Ciebie taks�wk�.", GroupData[group_id][gName]);
			ShowPlayerDialog(playerid, D_CALL_TAXI, DIALOG_STYLE_INPUT, "Taxi", string, "Dalej", "Anuluj");
	        return 1;
	    }
	    else
	    {
	        TD_ShowSmallInfo(playerid, 3, "Zamawianie taksowki zostalo ~r~anulowane~w~.");
			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);
	        return 1;
	    }
	}
	if(dialogid == D_ALARM_SELECT)
	{
		if(response)
		{
  			switch(listitem)
	        {
	            case 0:
	            {
	                PlayerCache[playerid][pCallingTo] = 997;
	                ShowPlayerDialog(playerid, D_CALL_ALARM, DIALOG_STYLE_INPUT, "Los Santos Police Department", "Witam, z tej strony dyspozytor Los Santos Police Department, co si� sta�o?\nProsz� szczeg�owo opisa� sytuacje oraz poda� miejsce po�o�enia.", "Dalej", "Anuluj");
	            }
	            case 1:
	            {
	                PlayerCache[playerid][pCallingTo] = 998;
	                ShowPlayerDialog(playerid, D_CALL_ALARM, DIALOG_STYLE_INPUT, "Los Santos Medical Center", "Witam, z tej strony dyspozytor Los Santos Medical Center, co si� sta�o?\nProsz� szczeg�owo opisa� sytuacje oraz poda� miejsce po�o�enia.", "Dalej", "Anuluj");
	            }
	            case 2:
	            {
	                PlayerCache[playerid][pCallingTo] = 999;
	                ShowPlayerDialog(playerid, D_CALL_ALARM, DIALOG_STYLE_INPUT, "Los Santos Fire Department", "Witam, z tej strony dyspozytor Los Santos Fire Department, co si� sta�o?\nProsz� szczeg�owo opisa� sytuacje oraz poda� miejsce po�o�enia.", "Dalej", "Anuluj");
	            }
	        }
		    return 1;
		}
		else
		{
			TD_ShowSmallInfo(playerid, 3, "Zakonczono ~r~polaczenie ~w~z numerem alarmowym.");
			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);
		    return 1;
		}
	}
	if(dialogid == D_CALL_TAXI)
	{
	    if(response)
	    {
  			new string[256], group_id = PlayerCache[playerid][pCallingTo];
			format(string, sizeof(string), "Wzywaj�cy: %d, tre��: %s", PlayerCache[playerid][pPhoneNumber], inputtext);

			foreach(new i : Player)
			{
			    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
			    {
			        if(PlayerCache[i][pDutyGroup] == GroupData[group_id][gUID])
			        {
						SendClientMessage(i, COLOR_GREEN, "Centrala: Do wszystkich jednostek, otrzymali�my wezwanie:");
 						SendClientMessage(i, COLOR_GREEN, string);
					}
			    }
			}
			format(string, sizeof(string), "%s (telefon): %s",  PlayerName(playerid), inputtext);
          	ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);

			SendClientMessage(playerid, COLOR_YELLOW, "Sekretarka: Zg�oszenie zosta�o przyj�te do realizacji, ju� wysy�amy tam jednostk�.");
	        return 1;
	    }
	    else
	    {
     		TD_ShowSmallInfo(playerid, 3, "Zamawianie taksowki zostalo ~r~anulowane~w~.");
			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);
	        return 1;
	    }
	}
	if(dialogid == D_CALL_ALARM)
	{
	    if(response)
	    {
  			new alarm_number = PlayerCache[playerid][pCallingTo], string[256], group_id, group_type;
  			switch(alarm_number)
  			{
				case 997:   group_type = G_TYPE_POLICE;
				case 998:   group_type = G_TYPE_MEDICAL;
				case 999:   group_type = G_TYPE_FIREDEPT;
			}
			
			format(string, sizeof(string), "Zg�aszaj�cy: %d, tre��: %s", PlayerCache[playerid][pPhoneNumber], inputtext);
			foreach(new i : Player)
			{
   				if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
			    {
					if(PlayerCache[i][pDutyGroup])
					{
						group_id = GetPlayerGroupID(i, PlayerCache[i][pDutyGroup]);
      					if(GroupData[group_id][gType] == group_type)
			        	{
							SendClientMessage(i, COLOR_GREEN, "Centrala: Do wszystkich jednostek, otrzymali�my zg�oszenie:");
       						SendClientMessage(i, COLOR_GREEN, string);
						}
					}
				}
			}
			
			format(string, sizeof(string), "%s (telefon): %s",  PlayerName(playerid), inputtext);
          	ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);
	        return 1;
	    }
	    else
	    {
  			TD_ShowSmallInfo(playerid, 3, "Zakonczono ~r~polaczenie ~w~z numerem alarmowym.");
			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);
	        return 1;
	    }
	}
	if(dialogid == D_CALL_NEWS)
	{
	    if(response)
	    {
  			new string[256], header[128], text[256];
			format(header, sizeof(header), "Nowe zg�oszenie od numeru %d (%s):", PlayerCache[playerid][pPhoneNumber], PlayerName(playerid));
            format(text, sizeof(text), "Tre�� zg�oszenia: %s", inputtext);

			new group_id;
			foreach(new i : Player)
			{
			    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
			    {
			        if(PlayerCache[i][pDutyGroup])
			        {
			            group_id = GetPlayerGroupID(i, PlayerCache[i][pDutyGroup]);
			            if(GroupData[group_id][gType] == G_TYPE_NEWS)
			            {
       						SendClientMessage(i, COLOR_GREEN, header);
       						SendClientMessage(i, COLOR_GREEN, text);
			            }
			        }
			    }
			}

			format(string, sizeof(string), "%s (telefon): %s",  PlayerName(playerid), inputtext);
          	ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);

			SendClientMessage(playerid, COLOR_YELLOW, "Sekretarka: Dzi�kujemy za wys�ane zg�oszenie!");
	        return 1;
	    }
	    else
	    {
  			TD_ShowSmallInfo(playerid, 3, "Polacznie z radiostacja zostalo ~r~przerwane~w~.");
			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, SLOT_PHONE);
	        return 1;
	    }
	}
	if(dialogid == D_SALON_CATEGORY)
	{
	    if(response)
	    {
	        new category_uid = strval(inputtext), data[128], veh_list[1024],
	            salon_model, salon_price;
	            
	        mysql_query_format("SELECT `salon_model`, `salon_price` FROM `"SQL_PREF"salon_vehicles` WHERE salon_cat = '%d'", category_uid);
	        
	        mysql_store_result();
	        while(mysql_fetch_row_format(data, "|"))
	        {
	            sscanf(data, "p<|>dd", salon_model, salon_price);

	            if(salon_price < 100000)
	            {
	            	format(veh_list, sizeof(veh_list), "%s\n$%d\t\t%s", veh_list, salon_price, GetVehicleName(salon_model));
				}
				else
				{
				    format(veh_list, sizeof(veh_list), "%s\n$%d\t%s", veh_list, salon_price, GetVehicleName(salon_model));
				}
	        }
	        mysql_free_result();
	        
	        if(strlen(veh_list))
	        {
	            new title[64];
	            format(title, sizeof(title), "Cennik � %s:", inputtext);
	            
	            ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_LIST, title, veh_list, "OK", "");
	        }
	        else
	        {
	            TD_ShowSmallInfo(playerid, 3, "Brak ~r~pojazdow ~w~w wybranej kategorii.");
	        }
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_ITEM_CRAFT)
	{
	    if(response)
	    {
	        new object_uid = PlayerCache[playerid][pMainTable], itemid;
	        if(inputtext[0] != 'W')
	        {
				if(!strval(inputtext))	return 1;
				new item_uid = strval(inputtext);
				
	   			mysql_query_format("UPDATE `"SQL_PREF"items` SET item_place = '%d', item_owner = '%d' WHERE item_uid = '%d' LIMIT 1", PLACE_PLAYER, PlayerCache[playerid][pUID], item_uid);
		        itemid = LoadItemCache(item_uid);
			}
			else
			{
			    if(inputtext[0] == '#')	return 1;
			    new weapon_id = strval(inputtext[1]), item_name[32];
			    mysql_query_format("DELETE FROM `"SQL_PREF"items` WHERE item_place = '%d' AND item_owner = '%d'", PLACE_CRAFT, object_uid);
			    
			    strmid(item_name, inputtext, 5, strlen(inputtext), 32);
                itemid = CreatePlayerItem(playerid, item_name, ITEM_WEAPON, weapon_id, 0);
			}
			
			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Wyj��e� przedmiot %s (UID: %d) z listy craftingu.\nPrzedmiot pojawi� si� w Twoim ekwipunku.", ItemCache[itemid][iName], ItemCache[itemid][iUID]);
			return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_RACE_SAVE)
	{
		if(response)
		{
 			if(!PlayerCache[playerid][pDutyGroup])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
			    return 1;
			}
		    if(strlen(inputtext) > 64 || strlen(inputtext) <= 0)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� nazw� wy�cigu.");
		        return 1;
		    }
		
			new esc_race_title[128];
			mysql_real_escape_string(inputtext, esc_race_title);
			mysql_query_format("INSERT INTO `"SQL_PREF"races` VALUES ('', '%s', '%d')", esc_race_title, PlayerCache[playerid][pDutyGroup]);
			
			new route_owner = mysql_insert_id(), main_query[2048], query[256];
			format(main_query, sizeof(main_query), "INSERT INTO `"SQL_PREF"races_route` VALUES ");
			
			for (new checkpoint = 0; checkpoint <= RaceInfo[playerid][rPoint]; checkpoint++)
			{
       			format(query, sizeof(query), "('',%d,%f,%f,%f)",
				route_owner,
				
   				RaceInfo[playerid][rCPX][checkpoint],
  	 			RaceInfo[playerid][rCPY][checkpoint],
			   	RaceInfo[playerid][rCPZ][checkpoint]);
			   	
   				if(strlen(main_query) > 64)
   				{
   				    if(strlen(main_query) + strlen(query) < sizeof(main_query))
   				    {
				   		strcat(main_query, ",", sizeof(main_query));
					}
					else
					{
					    strcat(main_query, ";", sizeof(main_query));
					    
					    print(main_query);
					    mysql_query(connHandle, main_query);
					    
					    strdel(main_query, 37, strlen(main_query));
					}
				}
			  	strcat(main_query, query, sizeof(main_query));
			}
			
			print(main_query);
			mysql_query(connHandle, main_query);
			
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Wy�cig zosta� pomy�lnie zapisany.\nSkorzystaj z komendy /wyscig wczytaj, by nim zarz�dza�.\n\nWy�cig zosta� podpisany pod grup�, co oznacza\n�e wczyta� go mo�e ka�dy jej cz�onek.");
		    return 1;
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == D_RACE_SELECT)
	{
	    if(response)
	    {
	        new race_uid, race_title[64], string[128];
	        sscanf(inputtext, "ds[64]", race_uid, race_title);
	        
	        PlayerCache[playerid][pMainTable] = race_uid;
	        format(string, sizeof(string), "Wy�cig � %s (UID: %d)", race_title, race_uid);
	        
	        ShowPlayerDialog(playerid, D_RACE_OPTIONS, DIALOG_STYLE_LIST, string, "1. Za�aduj wy�cig\n2. Usu� ca�kowicie\n3. Zmie� nazw�", "Wybierz", "Anuluj");
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_RACE_OPTIONS)
	{
	    if(response)
	    {
			if(PlayerCache[playerid][pRaceCreating])
	    	{
       			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie tworzysz ju� jaki� wy�cig.");
       			return 1;
	    	}
	    	if(RaceInfo[playerid][rStart])
	    	{
       			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie uczestniczysz ju� w jakim� wy�cigu.");
       			return 1;
 			}
 			
			new list_item = strval(inputtext), string[256],
			    race_uid = PlayerCache[playerid][pMainTable];
			
			if(list_item == 1)
			{
 				for (new checkpoint = 0; checkpoint < MAX_RACE_CP; checkpoint++)
				{
				    RaceInfo[playerid][rCPX][checkpoint] = 0.0;
				    RaceInfo[playerid][rCPY][checkpoint] = 0.0;
				    RaceInfo[playerid][rCPZ][checkpoint] = 0.0;
				}
			
			    new data[128], checkpoint;
			    mysql_query_format("SELECT `route_cpx`, `route_cpy`, `route_cpz` FROM `crp_races_route` WHERE route_owner = '%d'", race_uid);
			    
			    mysql_store_result();
			    while(mysql_fetch_row_format(data, "|"))
			    {
			        sscanf(data, "p<|>fff",
					RaceInfo[playerid][rCPX][checkpoint],
					RaceInfo[playerid][rCPY][checkpoint],
					RaceInfo[playerid][rCPZ][checkpoint]);

     				checkpoint ++;
			    }
			    mysql_free_result();
			    
				RaceInfo[playerid][rOwner] = playerid;
				RaceInfo[playerid][rPoint] = 0;
				
				PlayerCache[playerid][pRaceCheckpoints] = checkpoint - 1;
				TD_ShowSmallInfo(playerid, 10, "Wyscig zostal ~g~pomyslnie ~w~zaladowany. Mozesz teraz zaprosic rywali do wyscigu komenda ~r~/wyscig zapros~w~.~n~~n~Zeby rozpoczac wyscig wpisz ~y~/wyscig start~w~.");
			    return 1;
			}
			
			if(list_item == 2)
			{
			    format(string, sizeof(string), "Czy jeste� pewien, �e chcesz usun�� ten wy�cig (UID: %d)?\nTa opcja usunie ca�� zawarto�� bezpowrotnie!", race_uid);
				ShowPlayerDialog(playerid, D_RACE_DELETE, DIALOG_STYLE_MSGBOX, "Wy�cig � Usu� ca�kowicie", string, "Tak", "Nie");
			    return 1;
			}
			
			if(list_item == 3)
			{
				format(string, sizeof(string), "Wprowad� poni�ej now� nazw� dla wy�cigu (UID: %d).\nNazwa nie mo�e przekroczy� 64 znak�w.", race_uid);
				ShowPlayerDialog(playerid, D_RACE_RENAME, DIALOG_STYLE_INPUT, "Wy�cig � Zmie� nazw�", string, "Zmie�", "Anuluj");
				return 1;
			}
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_RACE_DELETE)
	{
	    if(response)
	    {
	        new race_uid = PlayerCache[playerid][pMainTable];
	        
	        mysql_query_format("DELETE FROM `crp_races` WHERE race_uid = '%d' LIMIT 1", race_uid);
	        mysql_query_format("DELETE FROM `crp_races_route` WHERE route_owner = '%d'", race_uid);
	        
	        ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Wy�cig (UID: %d) zosta� ca�kowicie usuni�ty.", race_uid);
	        return 1;
	    }
	    else
	    {
	        return 1;
	    }
	}
	if(dialogid == D_RACE_RENAME)
	{
		if(response)
		{
  			if(strlen(inputtext) > 64 || strlen(inputtext) <= 0)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� nazw� wy�cigu.");
		        return 1;
		    }
		    
   			new race_uid = PlayerCache[playerid][pMainTable], esc_race_title[128];
			mysql_real_escape_string(inputtext, esc_race_title);

			mysql_query_format("UPDATE `crp_races` SET race_title = '%s' WHERE race_uid = '%d' LIMIT 1", esc_race_title, race_uid);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Nazwa wy�cigu (UID: %d) zosta�a pomy�lnie zmieniona.\nNowa nazwa: %s", race_uid, esc_race_title);
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
	if(PlayerCache[playerid][pSpectate] != INVALID_PLAYER_ID)
	{
		new string[12];
		
		format(string, sizeof(string), "%d", clickedplayerid);
		cmd_spec(playerid, string);
		return 1;
	}

	if(!PlayerCache[playerid][pLogged])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wysy�a� prywatnych wiadomo�ci b�d�c niezalogowanym.");
	    return 1;
	}
	if(clickedplayerid == playerid || !PlayerCache[clickedplayerid][pLogged])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wys�a� prywatnej wiadomo�ci do tego gracza.");
	    return 1;
	}
	if((PlayerCache[playerid][pBlock] & BLOCK_OOC) && (PlayerCache[clickedplayerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Twoja posta� ma na�o�on� blokad� czatu OOC.");
	    return 1;
	}
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC) && PlayerCache[clickedplayerid][pTogW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma wy��czone otrzymywanie prywatnych wiadomo�ci.");
	    return 1;
	}
	if(PlayerCache[playerid][pBW] && !PlayerToPlayer(25.0, playerid, clickedplayerid) && (PlayerCache[clickedplayerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podczas stanu nieprzytomno�ci, wiadomo�ci prywatne mo�esz wysy�a� na okre�lon� odleg�o��.");
    	return 1;
	}
	if(PlayerCache[playerid][pAJ])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wysy�a� prywatnych wiadomo�ci w chwili obecnej.");
	    return 1;
	}
	new string[128];
	PlayerCache[playerid][pMainTable] = clickedplayerid;

	format(string, sizeof(string), "Wprowad� tre�� prywatnej wiadomo�ci, kt�ra zostanie wys�ana do gracza %s.", PlayerName(clickedplayerid));
	ShowPlayerDialog(playerid, D_SEND_PW, DIALOG_STYLE_INPUT, "Wysy�anie prywatnej wiadomo�ci", string, "Wy�lij", "Anuluj");
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	new string[128];
	
	// Je�li kliknie na grupowe gui
	for(new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
	{
		if(clickedid == TextDrawGroupOption[group_slot][GROUP_OPTION_INFO])
		{
			format(string, sizeof(string), "%d info", group_slot + 1);
			cmd_g(playerid, string);

			CancelSelectTextDraw(playerid);
		}

		if(clickedid == TextDrawGroupOption[group_slot][GROUP_OPTION_CARS])
		{
			format(string, sizeof(string), "%d pojazdy", group_slot + 1);
			cmd_g(playerid, string);

			CancelSelectTextDraw(playerid);
		}

		if(clickedid == TextDrawGroupOption[group_slot][GROUP_OPTION_DUTY])
		{
			format(string, sizeof(string), "%d duty", group_slot + 1);
			cmd_g(playerid, string);

			CancelSelectTextDraw(playerid);
		}

		if(clickedid == TextDrawGroupOption[group_slot][GROUP_OPTION_MAGAZINE])
		{
			format(string, sizeof(string), "%d magazyn", group_slot + 1);
			cmd_g(playerid, string);

			CancelSelectTextDraw(playerid);
		}

		if(clickedid == TextDrawGroupOption[group_slot][GROUP_OPTION_ONLINE])
		{
			format(string, sizeof(string), "%d online", group_slot + 1);
			cmd_g(playerid, string);

			CancelSelectTextDraw(playerid);
		}

		TextDrawHideForPlayer(playerid, Text:TextDrawGroupsTitle);

		PlayerTextDrawSetString(playerid, PlayerText:TextDrawGroups[playerid][group_slot], "_");
		PlayerTextDrawHide(playerid, PlayerText:TextDrawGroups[playerid][group_slot]);

		for(new option_id = 0; option_id < 5; option_id++)	TextDrawHideForPlayer(playerid, Text:TextDrawGroupOption[group_slot][option_id]);
	}
	
	new offererid = GetOffererID(playerid);
	if(offererid != INVALID_PLAYER_ID)
	{
	    if(clickedid == TextDrawOfferAccept)
	    {
	        if(OfferData[offererid][oPayType] == PAY_TYPE_NONE)
	        {
	     		if(OfferData[offererid][oPrice] > 0)
		        {
		            if(PlayerCache[playerid][pBankNumber])
		            {
	            		ShowPlayerDialog(playerid, D_OFFER_PAY_TYPE, DIALOG_STYLE_MSGBOX, "Rodzaj p�atno�ci", "Wybierz spos�b zap�aty za dan� ofert�.", "Got�wka", "Karta");
	                  	return 1;
					}
		            else
		            {
		                OfferData[offererid][oPayType] = PAY_TYPE_CASH;
		                OnPlayerAcceptOffer(playerid, offererid);
		            }
		        }
		        else
		        {
		            OfferData[offererid][oPayType] = PAY_TYPE_CASH;
		            OnPlayerAcceptOffer(playerid, offererid);
		        }
			}
			else
			{
			    OnPlayerAcceptOffer(playerid, offererid);
			}
	        CancelSelectTextDraw(playerid);
	    }

		if(clickedid == TextDrawOfferReject)
		{
		    OnPlayerRejectOffer(playerid, offererid);
      		CancelSelectTextDraw(playerid);
		}

  		if(_:clickedid == INVALID_TEXT_DRAW)
		{
		    OnPlayerRejectOffer(playerid, offererid);
		}
	}
	return 0;
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	if(response == EDIT_RESPONSE_CANCEL)
	{
	    StopPlayerObject(playerid, objectid);
	    return 1;
	}

	PlayerCache[playerid][pMainTable] = objectid;
    MovePlayerObject(playerid, objectid, fX, fY, fZ, 10.0, fRotX, fRotY, fRotZ);
	return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pEditObject] == objectid)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Kto� aktualnie edytuje ten obiekt.");
	            return 1;
	        }
	    }
	}
	
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_OBJECTS))
	{
	    new areaid = PlayerCache[playerid][pCurrentArea];
	    if(areaid != INVALID_AREA_ID && !IsPointInDynamicArea(areaid, x, y, z))
	    {
     		TD_ShowSmallInfo(playerid, 3, "Ten ~y~obiekt ~w~znajduje sie poza ~r~strefa~w~.");
     		return 1;
		}
	}
	new Float:RotX, Float:RotY, Float:RotZ;
	
	GetDynamicObjectRot(objectid, RotX, RotY, RotZ);
	TD_ShowLargeInfo(playerid, 0, "Model: ~y~%d          ~w~Identyfikator: ~y~%d~n~~n~~b~PX: ~w~%05.1f            ~b~PY: ~w~%05.1f          ~b~PZ: ~w~%05.1f~n~~n~~r~RX: ~w~%05.1f          ~r~RY: ~w~%05.1f         ~r~RZ: ~w~%05.1f", GetObjectModel(objectid), GetObjectUID(objectid), x, y, z, RotX, RotY, RotZ);
	
 	EditDynamicObject(playerid, objectid);
  	PlayerCache[playerid][pEditObject] = objectid;
	return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	switch(response)
	{
		case EDIT_RESPONSE_CANCEL:
	    {
	        ResetDynamicObjectPos(objectid);
			PlayerCache[playerid][pCurrentArea] = INVALID_AREA_ID;
			
	        PlayerCache[playerid][pEditObject] = INVALID_OBJECT_ID;
	        TD_ShowSmallInfo(playerid, 3, "Edycja ~y~obiektu ~w~zostala ~r~zakonczona~w~.~n~Obiekt ~g~powrocil ~w~na swoje miejsce.");
	        
	        TD_HideLargeInfo(playerid);
	    }
	    case EDIT_RESPONSE_FINAL:
		{
			if(!(PlayerCache[playerid][pAdmin] & A_PERM_OBJECTS))
			{
			    new areaid = PlayerCache[playerid][pCurrentArea];
   				if(areaid != INVALID_AREA_ID && !IsPointInDynamicArea(areaid, x, y, z))
       			{
          			ResetDynamicObjectPos(objectid);
          			TD_ShowSmallInfo(playerid, 3, "Ten ~b~obiekt ~w~wykracza poza granice ~r~strefy~w~.");
          			return 1;
		        }
			}
			
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);

			SaveObjectPos(objectid);
			TD_ShowSmallInfo(playerid, 3, "Pozycja ~b~obiektu ~w~zostala ~g~pomyslnie ~w~zapisana.");
			
			PlayerCache[playerid][pCurrentArea] = INVALID_AREA_ID;
			PlayerCache[playerid][pEditObject] = INVALID_OBJECT_ID;
			
			TD_HideLargeInfo(playerid);
	    }
	    case EDIT_RESPONSE_UPDATE:
	    {
	        TD_ShowLargeInfo(playerid, 0, "Model: ~y~%d          ~w~Identyfikator: ~y~%d~n~~n~~b~PX: ~w~%05.1f            ~b~PY: ~w~%05.1f          ~b~PZ: ~w~%05.1f~n~~n~~r~RX: ~w~%05.1f          ~r~RY: ~w~%05.1f         ~r~RZ: ~w~%05.1f", GetObjectModel(objectid), GetObjectUID(objectid), x, y, z, rx, ry, rz);
	    }
	}
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	switch(response)
	{
	    case EDIT_RESPONSE_CANCEL:
	    {
	        new itemid = PlayerCache[playerid][pMainTable];
	        
	        ItemCache[itemid][iUsed] = false;
	        SaveItem(itemid, SAVE_ITEM_USED);
	    
            RemovePlayerAttachedObject(playerid, index);
			TD_ShowSmallInfo(playerid, 3, "Edycja akcesoria zostala ~r~anulowana~w~.");
	    }
	    case EDIT_RESPONSE_FINAL:
	    {
	        new itemid = PlayerCache[playerid][pMainTable];
	        if((fOffsetX > 0.2 || fOffsetX < -0.1) || (fOffsetY > 0.15 || fOffsetY < -0.15) || (fOffsetZ > 0.025 || fOffsetZ < -0.025) || (fScaleX > 1.5 || fScaleX < 0.5) || (fScaleY > 1.5 || fScaleY < 0.5) || (fScaleZ > 1.5 || fScaleZ < 0.5))
	        {
	            if(ItemCache[itemid][iValue1])
	            {
	                // Pobieranie pozycji z bazy wzgl�dem value1
	                new data[256], access_uid = ItemCache[itemid][iValue1],
	                    Float:access_posx, Float:access_posy, Float:access_posz,
	                    Float:access_rotx, Float:access_roty, Float:access_rotz,
	                    Float:access_scalex, Float:access_scaley, Float:access_scalez;
	                    
	                mysql_query_format("SELECT `access_posx`, `access_posy`, `access_posz`, `access_rotx`, `access_roty`, `access_rotz`, `access_scalex`, `access_scaley`, `access_scalez` FROM `"SQL_PREF"access` WHERE access_uid = '%d' LIMIT 1", access_uid);
	                
					mysql_store_result();
					if(mysql_fetch_row_format(data, "|"))
					{
					    sscanf(data, "p<|>fffffffff", access_posx, access_posy, access_posz, access_rotx, access_roty, access_rotz, access_scalex, access_scaley, access_scalez);
					    SetPlayerAttachedObject(playerid, index, modelid, boneid, access_posx, access_posy, access_posz, access_rotx, access_roty, access_rotz, access_scalex, access_scaley, access_scalez);
					}
					mysql_free_result();
				}
				else
				{
				    // Pobieranie pozycji z cache wzgl�dem value2
				    new access_id = GetAccessID(ItemCache[itemid][iValue2]);
				    SetPlayerAttachedObject(playerid, index, modelid, boneid, AccessData[access_id][aPosX], AccessData[access_id][aPosY], AccessData[access_id][aPosZ], AccessData[access_id][aRotX], AccessData[access_id][aRotY], AccessData[access_id][aRotZ], AccessData[access_id][aScaleX], AccessData[access_id][aScaleY], AccessData[access_id][aScaleZ]);
				}
				
				EditAttachedObject(playerid, index);
				TD_ShowSmallInfo(playerid, 5, "Gabaryty ~y~akcesoria ~w~nie sa odpowiednie.~n~Zostal on ~r~przywrocony ~w~na wczesniejsza pozycje.");
				return 1;
	        }
	        
	        // Zapisz pozycj�
	        if(ItemCache[itemid][iValue1])
	        {
	            new access_uid = ItemCache[itemid][iValue1];
	            mysql_query_format("UPDATE `"SQL_PREF"access` SET access_posx = '%f', access_posy = '%f', access_posz = '%f', access_rotx = '%f', access_roty = '%f', access_rotz = '%f', access_scalex = '%f', access_scaley = '%f', access_scalez = '%f' WHERE access_uid = '%d' LIMIT 1", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, access_uid);
			}
	        else
	        {
	            new access_id = GetAccessID(ItemCache[itemid][iValue2]);
	            mysql_query_format("INSERT INTO `"SQL_PREF"access` VALUES ('', '%d', '%s', '%d', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '0', '1')", modelid, AccessData[access_id][aName], boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
	        
	            ItemCache[itemid][iValue1] = mysql_insert_id();
	            ItemCache[itemid][iValue2] = 0;
	            
	            SaveItem(itemid, SAVE_ITEM_VALUES);
	        }
	        TD_ShowSmallInfo(playerid, 3, "Pozycja akcesoria zostala ~g~pomyslnie ~w~zapisana.");
	    }
	}

	return 1;
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat)
{
	if(passenger_seat)
	{
	    return 1;
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return 1;
	}
	
	new Float:vPosX, Float:vPosY, Float:vPosZ;
	GetVehiclePos(vehicleid, vPosX, vPosY, vPosZ);
	
	if(IsPlayerInRangeOfPoint(playerid, 3.0, vPosX, vPosY, vPosZ))
	{
	    if(!(CarInfo[vehicleid][cAccess] & VEH_ACCESS_ALARM))
	    {
	        return 1;
	    }
	    if(!CarInfo[vehicleid][cLocked])
	    {
	        return 1;
	    }
	    if(GetVehicleAlarmStatus(vehicleid) == 1 || GetVehicleEngineStatus(vehicleid) == 1)
	    {
			return 1;
	    }
		new keysa, uda, lra;
		GetPlayerKeys(playerid, keysa, uda, lra);
		
		if(keysa & KEY_FIRE)
		{
			ChangeVehicleAlarmStatus(vehicleid, true);
			defer OnToggleVehicleAlarm[15000](vehicleid);
		}
		return 1;
	}
	return 1;
}


public UpdatePlayerSession(playerid, session_type, session_extraid)
{
	new session_start = PlayerCache[playerid][pSession][session_type], session_end = gettime();
	mysql_query_format("INSERT INTO `"SQL_PREF"sessions` (session_owner, session_extraid, session_type, session_start, session_end) VALUES ('%d', '%d', '%d', '%d', '%d')", PlayerCache[playerid][pUID], session_extraid, session_type, session_start, session_end);
	return 1;
}

public ShowPlayerStatsForPlayer(playerid, giveplayer_id)
{
	new list_stats[1024], string[128], IP[16];
	GetPlayerIp(playerid, IP, sizeof(IP));
		
	format(list_stats, sizeof(list_stats), "Identyfikator\t\t\t%d\n", PlayerCache[playerid][pUID]);
	format(list_stats, sizeof(list_stats), "%sGlobalnie\t\t\t%d\n", list_stats, PlayerCache[playerid][pGID]);
		
	format(list_stats, sizeof(list_stats), "%sCzas gry\t\t\t%dh %dm\n", list_stats, PlayerCache[playerid][pHours], PlayerCache[playerid][pMinutes]);

	if(PlayerCache[playerid][pHealth] <= 40)
	{
		format(list_stats, sizeof(list_stats), "%sZdrowie\t\t\t{FB5006}%.0f%%\n", list_stats, PlayerCache[playerid][pHealth]);
	}
	else
	{
	    format(list_stats, sizeof(list_stats), "%sZdrowie\t\t\t%.0f%%\n", list_stats, PlayerCache[playerid][pHealth]);
	}
	
	format(list_stats, sizeof(list_stats), "%sPortfel\t\t\t\t$%d\n", list_stats, PlayerCache[playerid][pCash]);

	format(list_stats, sizeof(list_stats), "%sBank\t\t\t\t$%d\n", list_stats, PlayerCache[playerid][pBankCash]);
	format(list_stats, sizeof(list_stats), "%sNumer konta\t\t\t%d\n", list_stats, PlayerCache[playerid][pBankNumber]);
	
	format(list_stats, sizeof(list_stats), "%sSkin\t\t\t\t%d\n", list_stats, PlayerCache[playerid][pSkin]);
	
	format(list_stats, sizeof(list_stats), "%sBW\t\t\t\t%dm\n", list_stats, PlayerCache[playerid][pBW] / 60);
	format(list_stats, sizeof(list_stats), "%sAJ\t\t\t\t%dm\n", list_stats, PlayerCache[playerid][pAJ] / 60);
	
	format(list_stats, sizeof(list_stats), "%sSi�a\t\t\t\t%dj\n", list_stats, (PlayerCache[playerid][pDrugType] == DRUG_COCAINE) ? (PlayerCache[playerid][pStrength] + (PlayerCache[playerid][pDrugLevel] * 20)) : (PlayerCache[playerid][pStrength]));
	format(list_stats, sizeof(list_stats), "%sUzale�nienie\t\t\t%.1f\n", list_stats, PlayerCache[playerid][pDepend]);
	
	new doorid = GetPlayerDoorID(playerid);
	if(doorid != INVALID_DOOR_ID)
	{
		format(list_stats, sizeof(list_stats), "%sDrzwi\t\t\t\t%d\n", list_stats, DoorCache[doorid][dUID]);
	}
	else
	{
	    format(list_stats, sizeof(list_stats), "%sDrzwi\t\t\t\t0\n", list_stats);
	}
	
	new areaid = PlayerCache[playerid][pCurrentArea];
	if(areaid != INVALID_AREA_ID)
	{
	    format(list_stats, sizeof(list_stats), "%sStrefa\t\t\t\t%d\n", list_stats, AreaCache[areaid][aUID]);
	}
	else
	{
	    format(list_stats, sizeof(list_stats), "%sStrefa\t\t\t\t0\n", list_stats);
	}
	
	format(list_stats, sizeof(list_stats), "%sPrzejechane\t\t\t%.1fkm\n", list_stats, PlayerCache[playerid][pMileage]);
	
	new fight_style = (PlayerCache[playerid][pFightStyle] != 15) ? (PlayerCache[playerid][pFightStyle] - 4) : 0;
	format(list_stats, sizeof(list_stats), "%sStyl walki\t\t\t%s\n", list_stats, FightStyleData[fight_style][0]);
	
	if(IsPlayerInAnyGroup(playerid))
	{
	    new list_groups[256], group_id;
    	for (new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
		{
		    if(PlayerGroup[playerid][group_slot][gpUID])
		    {
				group_id = PlayerGroup[playerid][group_slot][gpID];
          		format(list_groups, sizeof(list_groups), "%s � Slot %d\t\t\t%s (%d)\n", list_groups, group_slot + 1, GroupData[group_id][gName], GroupData[group_id][gUID]);
		    }
		}
		format(list_stats, sizeof(list_stats), "%sGrupy:\n%s", list_stats, list_groups);
	}
	
	format(list_stats, sizeof(list_stats), "%s-----\n", list_stats);
	
	new talk_style = PlayerCache[playerid][pTalkStyle],
		walk_style = PlayerCache[playerid][pWalkStyle];
		
	format(list_stats, sizeof(list_stats), "%s1\tStyl rozmowy:\t\t%s\n", list_stats, TalkStyleData[talk_style][2]);
	
	if(walk_style == INVALID_ANIM_ID)
	{
		format(list_stats, sizeof(list_stats), "%s2\tAnimacja chodzenia:\tBrak\n", list_stats);
	}
	else
	{
	    format(list_stats, sizeof(list_stats), "%s2\tAnimacja chodzenia:\t%s\n", list_stats, AnimCache[walk_style][aCommand]);
	}
	
	if(PlayerCache[playerid][pOOC])
	{
	    format(list_stats, sizeof(list_stats), "%s3\tCzat OOC:\t\tW��czony\n", list_stats);
	}
	else
	{
	    format(list_stats, sizeof(list_stats), "%s3\tCzat OOC:\t\tWy��czony\n", list_stats);
	}
	
	if(PlayerCache[playerid][pFirstPersonObject] == INVALID_OBJECT_ID)
	{
	    format(list_stats, sizeof(list_stats), "%s4\tKamera FPS:\t\tNie\n", list_stats);
	}
	else
	{
	    format(list_stats, sizeof(list_stats), "%s4\tKamera FPS:\t\tTak\n", list_stats);
	}
	
	if(PlayerCache[giveplayer_id][pStrength] >= 7000) 	GivePlayerAchievement(giveplayer_id, ACHIEVE_MYOMA);
	if(PlayerCache[giveplayer_id][pDepend] >= 45.0)     GivePlayerAchievement(giveplayer_id, ACHIEVE_DRUGGIE);
	if(PlayerCache[giveplayer_id][pMileage] >= 2500)    GivePlayerAchievement(giveplayer_id, ACHIEVE_DRIVER);
	
	format(string, sizeof(string), "Statystyki postaci %s (ID: %d) [IP: %s]", PlayerOriginalName(playerid), playerid, IP);
	ShowPlayerDialog(giveplayer_id, D_STATS, DIALOG_STYLE_LIST, string, list_stats, "OK", "");
	return 1;
}

public CreateGroup(GroupName[])
{
	new group_id, group_uid, group_name[32];

	mysql_real_escape_string(GroupName, group_name);
	mysql_query_format("INSERT INTO `"SQL_PREF"groups` (`group_name`) VALUES ('%s')", group_name);

	group_uid = mysql_insert_id();
	group_id = Iter_Free(Groups);

	GroupData[group_id][gUID] = group_uid;
	strmid(GroupData[group_id][gName], group_name, 0, strlen(group_name), 32);

	GroupData[group_id][gCash] = 0;

	GroupData[group_id][gType] = G_TYPE_NONE;
	GroupData[group_id][gOwner] = OWNER_NONE;

	GroupData[group_id][gValue1] = 0;
	GroupData[group_id][gValue2] = 0;

	GroupData[group_id][gColor] = COLOR_WHITE;
	GroupData[group_id][gActivity] = 0;
	
	strmid(GroupData[group_id][gTag], "NONE", 0, 4, 5);
	GroupData[group_id][gLastTax] = gettime();

	GroupData[group_id][gToggleChat] = false;
	Iter_Add(Groups, group_id);

	return group_id;
}

public SaveGroup(group_id)
{
	mysql_query_format("UPDATE `"SQL_PREF"groups` SET group_name = '%s', group_cash = '%d', group_dotation = '%d', group_owner = '%d', group_value1 = '%d', group_value2 = '%d', group_activity = '%d', group_lasttax = '%d' WHERE group_uid = '%d' LIMIT 1",
	GroupData[group_id][gName],

	GroupData[group_id][gCash],
	GroupData[group_id][gDotation],
	
	GroupData[group_id][gOwner],

	GroupData[group_id][gValue1],
	GroupData[group_id][gValue2],
	
	GroupData[group_id][gActivity],
	GroupData[group_id][gLastTax],

	GroupData[group_id][gUID]);
	return 1;
}

public DeleteGroup(group_id)
{
	mysql_query_format("DELETE FROM `"SQL_PREF"groups` WHERE group_uid = '%d'", GroupData[group_id][gUID]);

	// Zwolnij cz�onk�w
	mysql_query_format("DELETE FROM `"SQL_PREF"char_groups` WHERE group_belongs = '%d'", GroupData[group_id][gUID]);

	new group_slot;
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(IsPlayerInGroup(i, GroupData[group_id][gUID]))
	        {
	            group_slot = GetPlayerGroupSlot(i, GroupData[group_id][gUID]);

	            PlayerGroup[i][group_slot][gpUID] = 0;
	            PlayerGroup[i][group_slot][gpID] = 0;

	            PlayerGroup[i][group_slot][gpPerm] = 0;
	            strmid(PlayerGroup[i][group_slot][gpTitle], "Brak", 0, 4, 32);

				PlayerGroup[i][group_slot][gpPayment] = 0;
				
				if(PlayerCache[i][pDutyGroup] == GroupData[group_id][gUID])
				{
				    PlayerCache[i][pDutyGroup] = 0;
				    PlayerCache[i][pSession][SESSION_GROUP] = 0;
				}
	        }
	    }
	}
	
	// Usu� pojazdy
	for(new vehid = 0; vehid < MAX_VEHICLES; vehid++)
	{
	    if(CarInfo[vehid][cUID])
	    {
	        if(CarInfo[vehid][cOwnerType] == OWNER_GROUP && CarInfo[vehid][cOwner] == GroupData[group_id][gUID])
	        {
				DeleteVehicle(vehid);
	        }
	    }
	}

	// Usu� drzwi
    for(new doorid = 0; doorid < MAX_DOORS; doorid++)
	{
	    if(DoorCache[doorid][dUID])
	    {
	        if(DoorCache[doorid][dOwnerType] == OWNER_GROUP && DoorCache[doorid][dOwner] == GroupData[group_id][gUID])
	        {
	            DeleteDoor(doorid);
	        }
	    }
	}

	// Usu� podgrupy
	if(!GroupData[group_id][gOwner])
	{
	    for(new g = 0; g < MAX_GROUPS; g++)
	    {
	        if(GroupData[g][gUID])
	        {
	            if(GroupData[g][gOwner] == GroupData[group_id][gUID])
	            {
	                DeleteGroup(g);
	            }
	        }
	    }
	}
	GroupData[group_id][gUID] 		= 0;
	GroupData[group_id][gCash] 		= 0;

	GroupData[group_id][gType] 		= G_TYPE_NONE;
	GroupData[group_id][gOwner] 	= OWNER_NONE;

	GroupData[group_id][gValue1] 	= 0;
	GroupData[group_id][gValue2] 	= 0;

	GroupData[group_id][gColor] 	= 0;
	GroupData[group_id][gActivity]  = 0;

	GroupData[group_id][gLastTax]   = 0;
	GroupData[group_id][gFlags]     = 0;
	
	Iter_Remove(Groups, group_id);
	return 1;
}

public LoadGroups()
{
	new group_id, data[128];
	mysql_query(connHandle, "SELECT * FROM `"SQL_PREF"groups`");

	print("[load] Rozpoczynam proces wczytywania wszystkich grup...");

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
		sscanf(data, "p<|>ds[32]ddddddxds[5]dd",
		GroupData[group_id][gUID],
		GroupData[group_id][gName],

		GroupData[group_id][gCash],
		GroupData[group_id][gDotation],

		GroupData[group_id][gType],
		GroupData[group_id][gOwner],

		GroupData[group_id][gValue1],
		GroupData[group_id][gValue2],

		GroupData[group_id][gColor],
		GroupData[group_id][gActivity],
		
		GroupData[group_id][gTag],
		GroupData[group_id][gLastTax],

		GroupData[group_id][gFlags]);

		Iter_Add(Groups, group_id);
		group_id ++;
	}
	mysql_free_result();
	
	printf("[load] Proces wczytywania grup zosta� zako�czony (count: %d).", Iter_Count(Groups));
	return 1;
}

public ShowPlayerGroupInfo(playerid, group_id)
{
	new list_stats[256], string[128];
	format(list_stats, sizeof(list_stats), "Typ grupy:\t\t%s", GroupTypeInfo[GroupData[group_id][gType]][gTypeName]);
    format(list_stats, sizeof(list_stats), "%s\nBud�et:\t\t\t$%d", list_stats, GroupData[group_id][gCash]);
    
    if(GroupData[group_id][gActivity] < ACTIVITY_LIMIT)
    {
    	format(list_stats, sizeof(list_stats), "%s\nPunkty aktywno�ci:\t{FB5006}%d{FFFFFF}", list_stats, GroupData[group_id][gActivity]);
 	}
	else
	{
	    format(list_stats, sizeof(list_stats), "%s\nPunkty aktywno�ci:\t{6BFF54}%d{FFFFFF}", list_stats, GroupData[group_id][gActivity]);
	}

    format(list_stats, sizeof(list_stats), "%s\nDotacja:\t\t$%d", list_stats, GroupData[group_id][gDotation]);

    if(GroupData[group_id][gOwner])
    {
        new group_owner_id = GetGroupID(GroupData[group_id][gOwner]);
		format(list_stats, sizeof(list_stats), "%s\nNadrz�dna:\t\t%s (UID: %d)", list_stats, GroupData[group_owner_id][gName], GroupData[group_owner_id][gUID]);
	}
	
	if(PlayerCache[playerid][pDutyGroup] == GroupData[group_id][gUID])
	{
		new	duty_hours = floatround((gettime() - PlayerCache[playerid][pSession][SESSION_GROUP]) / 3600, floatround_floor),
					duty_minutes = floatround((gettime() - PlayerCache[playerid][pSession][SESSION_GROUP]) / 60, floatround_floor) % 60;
					
	    format(list_stats, sizeof(list_stats), "%s\nCzas s�u�by:\t\t%dh %dm", list_stats, duty_hours, duty_minutes);
	}

	format(list_stats, sizeof(list_stats), "%s\nTag:\t\t\t%s", list_stats, GroupData[group_id][gTag]);
	
	if(GroupData[group_id][gFlags] & G_FLAG_TAX)
	{
 		new time_string[64];
   		//mtime_UnixToDate(time_string, sizeof(time_string), GroupData[group_id][gLastTax] + (7 * 86000));
   		
		strmid(time_string, time_string, 0, 10, 64);
		format(list_stats, sizeof(list_stats), "%s\nPodatek:\t\t%s", list_stats, time_string);
	}

	format(string, sizeof(string), "%s (UID: %d) � Informacje", GroupData[group_id][gName], GroupData[group_id][gUID]);
	ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_LIST, string, list_stats, "OK", "");
	return 1;
}

public LoadPlayerGroups(playerid)
{
	new data[128], group_uid, group_id, group_slot;
	mysql_query_format("SELECT `group_uid`, `group_perm`, `group_title`, `group_payment`, `group_skin`, `group_tag`, `group_color`, `group_flags` FROM `crp_groups`, `crp_char_groups` WHERE crp_groups.group_uid = crp_char_groups.group_belongs AND char_uid = '%d' LIMIT %d", PlayerCache[playerid][pUID], MAX_GROUP_SLOTS);

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
	    sscanf(data, "p<|>d", group_uid);
	    group_id = GetGroupID(group_uid);
	
	    if(group_id == INVALID_GROUP_ID)    continue;
	    
	    sscanf(data, "p<|>dds[32]dds[5]dd",
		PlayerGroup[playerid][group_slot][gpUID],

		PlayerGroup[playerid][group_slot][gpPerm],
		PlayerGroup[playerid][group_slot][gpTitle],

		PlayerGroup[playerid][group_slot][gpPayment],
		PlayerGroup[playerid][group_slot][gpSkin],

		GroupData[group_id][gTag],
		GroupData[group_id][gColor],

		GroupData[group_id][gFlags]);
		
		PlayerGroup[playerid][group_slot][gpID] = group_id;
		group_slot ++;
	}
	mysql_free_result();
	return 1;
}

public CreateStaticVehicle(modelid, Float:PosX, Float:PosY, Float:PosZ, Float:PosA, color1, color2, respawn_delay)
{
	new veh_uid;
	mysql_query_format("INSERT INTO `"SQL_PREF"vehicles` (vehicle_model, vehicle_posx, vehicle_posy, vehicle_posz, vehicle_posa, vehicle_color1, vehicle_color2, vehicle_fuel) VALUES ('%d', '%f', '%f', '%f', '%f', '%d', '%d', '%d')", modelid, PosX, PosY, PosZ, PosA, color1, color2, GetVehicleMaxFuel(modelid));

	veh_uid = mysql_insert_id();
	LoadVehicle(veh_uid);
	
	return veh_uid;
}

public LoadVehicle(veh_uid)
{
	new data[512], vehid = Iter_Free(Vehicles);
	mysql_query_format("SELECT * FROM `crp_vehicles` WHERE vehicle_uid = '%d'", veh_uid);

	mysql_store_result();
	if(mysql_fetch_row_format(data, "|"))
	{
		sscanf(data, "p<|>ddffffddddfdffda<i>[4]ddds[12]dd",
		CarInfo[vehid][cUID],
		CarInfo[vehid][cModel],

		CarInfo[vehid][cPosX],
		CarInfo[vehid][cPosY],
		CarInfo[vehid][cPosZ],
		CarInfo[vehid][cPosA],
		
		CarInfo[vehid][cWorldID],
		CarInfo[vehid][cInteriorID],

		CarInfo[vehid][cColor1],
		CarInfo[vehid][cColor2],

		CarInfo[vehid][cFuel],
		CarInfo[vehid][cFuelType],

		CarInfo[vehid][cHealth],
		CarInfo[vehid][cMileage],

		CarInfo[vehid][cLocked],
		CarInfo[vehid][cVisual],
		
		CarInfo[vehid][cPaintJob],
		CarInfo[vehid][cAccess],
		
		CarInfo[vehid][cBlockWheel],
		CarInfo[vehid][cRegister],

		CarInfo[vehid][cOwner],
		CarInfo[vehid][cOwnerType]);

		Iter_Add(Vehicles, vehid);
		CreateVehicle(CarInfo[vehid][cModel], CarInfo[vehid][cPosX], CarInfo[vehid][cPosY], CarInfo[vehid][cPosZ], CarInfo[vehid][cPosA], CarInfo[vehid][cColor1], CarInfo[vehid][cColor2], 3600);

		// Usu� opis
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if(Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[i][pDescTag], E_STREAMER_ATTACHED_VEHICLE) == vehid)
  			{
  				UpdateDynamic3DTextLabelText(Text3D:PlayerCache[i][pDescTag], COLOR_DESC, " ");
				Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[i][pDescTag], E_STREAMER_ATTACHED_PLAYER, i);
			}
		}
		
		for(new i = 0; i < 14; i++)	CarInfo[vehid][cComponent][i] = 0;
		
		CarInfo[vehid][cDistTicker] = 0;
		CarInfo[vehid][cSavePoint] = 0;
		
		strmid(CarInfo[vehid][cAudioURL], "", 0, 0, 32);
		CarInfo[vehid][cRadioCanal] = 4444;
		
		CarInfo[vehid][cGPS] = false;
		CarInfo[vehid][cLastUsing] = 0;
		
		CarInfo[vehid][cGlass] = false;
		OnVehicleSpawn(vehid);
	}
	else
	{
		vehid = INVALID_VEHICLE_ID;
	}
	mysql_free_result();
	
	if(vehid != INVALID_VEHICLE_ID)
	{
	    new component_id;
		mysql_query_format("SELECT `item_value1` FROM `"SQL_PREF"items` WHERE item_vehuid = '%d'", CarInfo[vehid][cUID]);

		mysql_store_result();
		while(mysql_fetch_row_format(data, "|"))
		{
			sscanf(data, "p<|>d", component_id);
		    crp_AddVehicleComponent(vehid, component_id);
		}
		mysql_free_result();
	}
	
	return vehid;
}

public SaveVehicle(vehid, what)
{
	new main_query[512], query[256];
	format(main_query, sizeof(main_query), "UPDATE `"SQL_PREF"vehicles` SET");
	
	if(what & SAVE_VEH_POS)
	{
	    // Pozycja pojazdu
		format(query, sizeof(query), " vehicle_posx = '%f', vehicle_posy = '%f', vehicle_posz = '%f', vehicle_posa = '%f', vehicle_world = '%d', vehicle_interior = '%d'",
		CarInfo[vehid][cPosX],
		CarInfo[vehid][cPosY],
		CarInfo[vehid][cPosZ],
		CarInfo[vehid][cPosA],

		CarInfo[vehid][cWorldID],
		CarInfo[vehid][cInteriorID]);

		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_VEH_ACCESS)
	{
	    // Akcesoria pojazdu (kolory, rodzaj paliwa, paintjob, akcesoria, blokada na ko�o, rejestracja)
	    format(query, sizeof(query), " vehicle_color1 = '%d', vehicle_color2 = '%d', vehicle_fueltype = '%d', vehicle_paintjob = '%d', vehicle_access = '%d', vehicle_blockwheel = '%d', vehicle_register = '%s'",
	    CarInfo[vehid][cColor1],
	    CarInfo[vehid][cColor2],

		CarInfo[vehid][cFuelType],
		
		CarInfo[vehid][cPaintJob],
		CarInfo[vehid][cAccess],

		CarInfo[vehid][cBlockWheel],
		CarInfo[vehid][cRegister]);

		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_VEH_COUNT)
	{
	    // Liczniki (paliwo, uszk. techniczne, przebieg, uszk. wizualne)
	    format(query, sizeof(query), " vehicle_fuel = '%f', vehicle_health = '%f', vehicle_mileage = '%f', vehicle_visual = '%d %d %d %d'",
	    CarInfo[vehid][cFuel],

		CarInfo[vehid][cHealth],
		CarInfo[vehid][cMileage],

		CarInfo[vehid][cVisual][0],
		CarInfo[vehid][cVisual][1],
		CarInfo[vehid][cVisual][2],
		CarInfo[vehid][cVisual][3]);

		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_VEH_THINGS)
	{
	    // Pozosta�e (model, nazwa, w�a�ciciel)
	    format(query, sizeof(query), " vehicle_model = '%d', vehicle_owner = '%d', vehicle_ownertype = '%d'",
	    CarInfo[vehid][cModel],
		CarInfo[vehid][cOwner],
		CarInfo[vehid][cOwnerType]);

		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_VEH_LOCK)
	{
	    // Zamkni�cie pojazdu
	    format(query, sizeof(query), " vehicle_locked = '%d'",
	    CarInfo[vehid][cLocked]);

		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	
	format(query, sizeof(query), " WHERE vehicle_uid = '%d' LIMIT 1", CarInfo[vehid][cUID]);
	strcat(main_query, query, sizeof(main_query));

	mysql_query(connHandle, main_query);
	CarInfo[vehid][cSavePoint] = 0;
	return 1;
}

public DeleteVehicle(vehid)
{
	mysql_query_format("DELETE FROM `"SQL_PREF"vehicles` WHERE vehicle_uid = '%d'", CarInfo[vehid][cUID]);

	CarInfo[vehid][cUID] = 0;
	CarInfo[vehid][cModel] = 0;

	CarInfo[vehid][cPosX] = 0.0;
	CarInfo[vehid][cPosY] = 0.0;
	CarInfo[vehid][cPosZ] = 0.0;
	CarInfo[vehid][cPosA] = 0.0;

	CarInfo[vehid][cColor1] = 0;
	CarInfo[vehid][cColor2] = 0;

	CarInfo[vehid][cFuel] = 0.0;
	CarInfo[vehid][cFuelType] = 0;
	
	DestroyVehicle(vehid);
	Iter_Remove(Vehicles, vehid);
	return 1;
}

public LoadVehicles()
{
    new vehid, data[256];

	Iter_Add(Vehicles, 0);
	mysql_query_format("SELECT * FROM `"SQL_PREF"vehicles` WHERE vehicle_ownertype <> '%d'", OWNER_PLAYER);

	print("[load] Rozpoczynam proces wczytywania pojazd�w...");

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
		vehid ++;

		sscanf(data, "p<|>ddffffddddfdffda<i>[4]ddds[12]dd",
		CarInfo[vehid][cUID],
		CarInfo[vehid][cModel],

		CarInfo[vehid][cPosX],
		CarInfo[vehid][cPosY],
		CarInfo[vehid][cPosZ],
		CarInfo[vehid][cPosA],
		
		CarInfo[vehid][cWorldID],
		CarInfo[vehid][cInteriorID],

		CarInfo[vehid][cColor1],
		CarInfo[vehid][cColor2],

		CarInfo[vehid][cFuel],
		CarInfo[vehid][cFuelType],
		
		CarInfo[vehid][cHealth],
		CarInfo[vehid][cMileage],
		
		CarInfo[vehid][cLocked],
		CarInfo[vehid][cVisual],
		
		CarInfo[vehid][cPaintJob],
		CarInfo[vehid][cAccess],
		
		CarInfo[vehid][cBlockWheel],
		CarInfo[vehid][cRegister],

		CarInfo[vehid][cOwner],
		CarInfo[vehid][cOwnerType]);
		
		Iter_Add(Vehicles, vehid);
		CreateVehicle(CarInfo[vehid][cModel], CarInfo[vehid][cPosX], CarInfo[vehid][cPosY], CarInfo[vehid][cPosZ], CarInfo[vehid][cPosA], CarInfo[vehid][cColor1], CarInfo[vehid][cColor2], 3600);

		CarInfo[vehid][cDistTicker] = 0;
		CarInfo[vehid][cSavePoint] = 0;

		strmid(CarInfo[vehid][cAudioURL], "", 0, 0, 32);
		CarInfo[vehid][cRadioCanal] = 4444;

        CarInfo[vehid][cGPS] = false;
        CarInfo[vehid][cLastUsing] = 0;
        
        CarInfo[vehid][cGlass] = false;
		OnVehicleSpawn(vehid);
	}
	mysql_free_result();
	
	// Komponenty
	new veh_uid, component_id;
	mysql_query(connHandle, "SELECT `item_vehuid`, `item_value1` FROM `"SQL_PREF"items` WHERE item_vehuid != '0'");

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
		sscanf(data, "p<|>dd", veh_uid, component_id);

		vehid = GetVehicleID(veh_uid);
		if(vehid != INVALID_VEHICLE_ID)
		{
	    	crp_AddVehicleComponent(vehid, component_id);
		}
	}
	mysql_free_result();
	
	printf("[load] Proces wczytywania pojazd�w zosta� zako�czony (count: %d).", Iter_Count(Vehicles));
	return 1;
}

public ShowPlayerVehicleInfo(playerid, vehid)
{
    new list_info[512], string[128];
    
	format(list_info, sizeof(list_info), "Model:\t\t\t%d\n", CarInfo[vehid][cModel]);
	format(list_info, sizeof(list_info), "%sKolory:\t\t\t%d:%d\n", list_info, CarInfo[vehid][cColor1], CarInfo[vehid][cColor2]);
	
	format(list_info, sizeof(list_info), "%sPaliwo:\t\t\t%.0f/%dL\n", list_info, CarInfo[vehid][cFuel], GetVehicleMaxFuel(CarInfo[vehid][cModel]));
	format(list_info, sizeof(list_info), "%sRodzaj paliwa:\t\t%s\n", list_info, FuelTypeName[CarInfo[vehid][cFuelType]]);
	
	if(CarInfo[vehid][cHealth] <= 650)
	{
		format(list_info, sizeof(list_info), "%sStan techniczny:\t{FB5006}%.1f{FFFFFF} HP\n", list_info, CarInfo[vehid][cHealth]);
	}
	else
	{
 		format(list_info, sizeof(list_info), "%sStan techniczny:\t%.1f HP\n", list_info, CarInfo[vehid][cHealth]);
	}
	format(list_info, sizeof(list_info), "%sPrzebieg:\t\t%.0f km\n", list_info, CarInfo[vehid][cMileage]);
	
	switch(CarInfo[vehid][cOwnerType])
	{
	    case OWNER_NONE:
	    {
	        format(list_info, sizeof(list_info), "%sTyp w�a�ciciela:\t\tBrak\n", list_info);
	    }
	    case OWNER_PLAYER:
	    {
	       	format(list_info, sizeof(list_info), "%sTyp w�a�ciciela:\t\tGracz\n", list_info);
			format(list_info, sizeof(list_info), "%sUID gracza:\t\t%d\n", list_info, CarInfo[vehid][cOwner]);
	    }
	    case OWNER_GROUP:
	    {
   			format(list_info, sizeof(list_info), "%sTyp w�a�ciciela:\t\tGrupa\n", list_info);
   			format(list_info, sizeof(list_info), "%sUID grupy:\t\t%d\n", list_info, CarInfo[vehid][cOwner]);
	    }
	}
	
	if(strlen(CarInfo[vehid][cRegister]))
	{
	    format(list_info, sizeof(list_info), "%sRejestracja:\t\t%s\n", list_info, CarInfo[vehid][cRegister]);
	}
	else
	{
	    format(list_info, sizeof(list_info), "%sRejestracja:\t\t-\n", list_info);
	}
	
    format(list_info, sizeof(list_info), "%sMoc (KM):\t\t%d (+0)\n", list_info, GetVehicleMaxSpeed(CarInfo[vehid][cModel]));
	format(list_info, sizeof(list_info), "%s \nParking:\n\t\tX: %.4f\tY: %.4f\tZ: %.4f", list_info, CarInfo[vehid][cPosX], CarInfo[vehid][cPosY], CarInfo[vehid][cPosZ]);
	
	format(string, sizeof(string), "%s (SampID: %d, UID: %d) � Informacje", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID]);
	ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_LIST, string, list_info, "OK", "");
	return 1;
}

public CreateDoor(Float:DoorEnterX, Float:DoorEnterY, Float:DoorEnterZ, Float:DoorEnterA, DoorEnterInt, DoorEnterVW, DoorName[])
{
	new door_uid, door_name[64];

    mysql_real_escape_string(DoorName, door_name);
	mysql_query_format("INSERT INTO `"SQL_PREF"doors` (door_name, door_enterx, door_entery, door_enterz, door_entera, door_enterint, door_entervw) VALUES ('%s', '%f', '%f', '%f', '%f', '%d', '%d')", door_name, DoorEnterX, DoorEnterY, DoorEnterZ, DoorEnterA, DoorEnterInt, DoorEnterVW);

	door_uid = mysql_insert_id();
	LoadDoor(door_uid);

	return door_uid;
}

public LoadDoor(door_uid)
{
	new data[512], doorid = Iter_Free(Door);
	mysql_query_format("SELECT * FROM `"SQL_PREF"doors` WHERE door_uid = '%d' LIMIT 1", door_uid);

	mysql_store_result();
	if(mysql_fetch_row_format(data, "|"))
	{
		sscanf(data, "p<|>ds[32]ffffddffffddddddds[128]d",
		DoorCache[doorid][dUID],
		DoorCache[doorid][dName],
		
		DoorCache[doorid][dEnterX],
		DoorCache[doorid][dEnterY],
		DoorCache[doorid][dEnterZ],
		DoorCache[doorid][dEnterA],
		
		DoorCache[doorid][dEnterInt],
		DoorCache[doorid][dEnterVW],
		
		DoorCache[doorid][dExitX],
		DoorCache[doorid][dExitY],
		DoorCache[doorid][dExitZ],
		DoorCache[doorid][dExitA],
		
		DoorCache[doorid][dExitInt],
		DoorCache[doorid][dExitVW],
		
		DoorCache[doorid][dLocked],
		DoorCache[doorid][dPickupID],
		
		DoorCache[doorid][dGarage],

		DoorCache[doorid][dOwner],
		DoorCache[doorid][dOwnerType],

		DoorCache[doorid][dAudioURL],
		DoorCache[doorid][dEnterPay]);
		
		Iter_Add(Door, doorid);
		CreatePickup(DoorCache[doorid][dPickupID], 2, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ], DoorCache[doorid][dEnterVW]);
	}
	mysql_free_result();
	return doorid;
}

public SaveDoor(doorid, what)
{
 	new query[256], main_query[512];
 	format(main_query, sizeof(main_query), "UPDATE `"SQL_PREF"doors` SET");
 	
	if(what & SAVE_DOOR_ENTER)
	{
	    // Pozycja wej�cia
		format(query, sizeof(query), " door_enterx = '%f', door_entery = '%f', door_enterz = '%f', door_entera = '%f', door_enterint = '%d', door_entervw = '%d'",
		DoorCache[doorid][dEnterX],
		DoorCache[doorid][dEnterY],
		DoorCache[doorid][dEnterZ],
		DoorCache[doorid][dEnterA],
		
		DoorCache[doorid][dEnterInt],
		DoorCache[doorid][dEnterVW]);

		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_DOOR_EXIT)
	{
	    // Pozycja wyj�cia
		format(query, sizeof(query), " door_exitx = '%f', door_exity = '%f', door_exitz = '%f', door_exita = '%f', door_exitint = '%d', door_exitvw = '%d'",
		DoorCache[doorid][dExitX],
		DoorCache[doorid][dExitY],
		DoorCache[doorid][dExitZ],
		DoorCache[doorid][dExitA],
		
		DoorCache[doorid][dExitInt],
		DoorCache[doorid][dExitVW]);

		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_DOOR_THINGS)
	{
	    // Pozosta�e (nazwa, w�a�ciciel, model pickupa, koszt wst�pu, gara�, akcesoria, czas p�oni�cia)
	    format(query, sizeof(query), " door_name = '%s', door_owner = '%d', door_ownertype = '%d', door_pickupid = '%d', door_garage = '%d'",
	    DoorCache[doorid][dName],
	    
	    DoorCache[doorid][dOwner],
	    DoorCache[doorid][dOwnerType],
	    
	    DoorCache[doorid][dPickupID],
		DoorCache[doorid][dGarage]);

		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_DOOR_AUDIO)
	{
		// Link do muzyki spoza gry
	    format(query, sizeof(query), " door_audiourl = '%s'",
	    DoorCache[doorid][dAudioURL]);

   		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_DOOR_LOCK)
	{
	    // Zamkni�cie drzwi
	    format(query, sizeof(query), " door_lock = '%d'",
	    DoorCache[doorid][dLocked]);

		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	
	format(query, sizeof(query), " WHERE door_uid = '%d' LIMIT 1", DoorCache[doorid][dUID]);
	strcat(main_query, query, sizeof(main_query));

	mysql_query(connHandle, main_query);
	return 1;
}

public DeleteDoor(doorid)
{
	mysql_query_format("DELETE FROM `"SQL_PREF"doors` WHERE door_uid = '%d' LIMIT 1", DoorCache[doorid][dUID]);
	
	// Usu� stare obiekty z tego VW (je�li s�)
	new object_counts = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT);
	mysql_query_format("DELETE FROM `"SQL_PREF"objects` WHERE object_world = '%d'", DoorCache[doorid][dUID]);

	for (new object_id = 0; object_id <= object_counts; object_id++)
	{
 		if(IsValidDynamicObject(object_id))
   		{
			if(Streamer_IsInArrayData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_WORLD_ID, DoorCache[doorid][dUID]))
			{
				DestroyDynamicObject(object_id);
	  		}
		}
	}
	
	// Usu� 3d teksty z tych drzwi
	new label_counts = CountDynamic3DTextLabels();
	mysql_query_format("DELETE FROM `"SQL_PREF"3dlabels` WHERE label_world = '%d'", DoorCache[doorid][dUID]);

	for (new label_id = 0; label_id <= label_counts; label_id++)
	{
	    if(IsValidDynamic3DTextLabel(Text3D:label_id))
	    {
			if(Streamer_IsInArrayData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_WORLD_ID, DoorCache[doorid][dUID]))
			{
				DestroyDynamic3DTextLabel(Text3D:label_id);
	  		}
		}
	}
	
	// Wyczy�� magazyn drzwi
	new product_next;
	mysql_query_format("DELETE FROM `"SQL_PREF"products` WHERE product_owner = '%d'", DoorCache[doorid][dUID]);

	foreach(new product_id : Product)
	{
	    if(ProductData[product_id][pUID])
	    {
	        if(ProductData[product_id][pOwner] == DoorCache[doorid][dUID])
	        {
        		ProductData[product_id][pUID] 		= 0;
				ProductData[product_id][pType] 		= 0;

				ProductData[product_id][pValue1] 	= 0;
				ProductData[product_id][pValue2] 	= 0;

				ProductData[product_id][pPrice] 	= 0;
				ProductData[product_id][pCount] 	= 0;

				ProductData[product_id][pOwner] 	= 0;
				
				Iter_SafeRemove(Product, product_id, product_next);
				product_id = product_next;
	        }
	    }
	}
	
	// Usu� zam�wienia do tych drzwi
	new package_next;
	mysql_query_format("DELETE FROM `"SQL_PREF"packages` WHERE package_dooruid = '%d'", DoorCache[doorid][dUID]);

	foreach(new package_id : Package)
	{
	    if(PackageCache[package_id][pUID])
	    {
	        if(PackageCache[package_id][pDoorUID] == DoorCache[doorid][dUID])
	        {
				PackageCache[package_id][pUID]      	= 0;
				PackageCache[package_id][pDoorUID]  	= 0;

				PackageCache[package_id][pItemType] 	= 0;

				PackageCache[package_id][pItemValue1]   = 0;
				PackageCache[package_id][pItemValue2]   = 0;

				PackageCache[package_id][pItemCount]    = 0;
				PackageCache[package_id][pItemPrice]    = 0;

				PackageCache[package_id][pType]         = 0;

				Iter_SafeRemove(Package, package_id, package_next);
				package_id = package_next;
	        }
	    }
	}
	
	DoorCache[doorid][dUID] 					= 0;

	DoorCache[doorid][dEnterX] 					= 0.0;
	DoorCache[doorid][dEnterY] 					= 0.0;
	DoorCache[doorid][dEnterZ] 					= 0.0;
	DoorCache[doorid][dEnterA] 					= 0.0;

	DoorCache[doorid][dEnterInt] 				= 0;
	DoorCache[doorid][dEnterVW] 				= 0;

	DoorCache[doorid][dExitX] 					= 0.0;
	DoorCache[doorid][dExitY] 					= 0.0;
	DoorCache[doorid][dExitZ] 					= 0.0;
	DoorCache[doorid][dExitA] 					= 0.0;

	DoorCache[doorid][dExitInt] 				= 0;
	DoorCache[doorid][dExitVW] 					= 0;

	DoorCache[doorid][dLocked] 					= false;
	DoorCache[doorid][dPickupID] 				= 0;
	
	DoorCache[doorid][dGarage]      			= false;

	DoorCache[doorid][dOwner] 					= 0;
	DoorCache[doorid][dOwnerType] 				= 0;
	
	DoorCache[doorid][dEnterPay] 				= 0;
	
	DoorCache[doorid][dAccess]      			= 0;
	
	DoorCache[doorid][dFireData][FIRE_TIME] 	= 0;
	DoorCache[doorid][dFireData][FIRE_OBJECT]   = _:INVALID_OBJECT_ID;
	DoorCache[doorid][dFireData][FIRE_LABEL]    = _:INVALID_3DTEXT_ID;

	DestroyPickup(doorid);
	Iter_Remove(Door, doorid);
	return 1;
}

public LoadDoors()
{
	new data[512], doorid;
	
	Iter_Add(Door, 0);
	mysql_query(connHandle, "SELECT * FROM `"SQL_PREF"doors`");

	print("[load] Rozpoczynam proces wczytywania wszystkich drzwi...");

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
	    doorid ++;
	
		sscanf(data, "p<|>ds[32]ffffddffffddddddds[128]d",
		DoorCache[doorid][dUID],
		DoorCache[doorid][dName],

		DoorCache[doorid][dEnterX],
		DoorCache[doorid][dEnterY],
		DoorCache[doorid][dEnterZ],
		DoorCache[doorid][dEnterA],

		DoorCache[doorid][dEnterInt],
		DoorCache[doorid][dEnterVW],

		DoorCache[doorid][dExitX],
		DoorCache[doorid][dExitY],
		DoorCache[doorid][dExitZ],
		DoorCache[doorid][dExitA],

		DoorCache[doorid][dExitInt],
		DoorCache[doorid][dExitVW],

		DoorCache[doorid][dLocked],
		DoorCache[doorid][dPickupID],
		
		DoorCache[doorid][dGarage],

		DoorCache[doorid][dOwner],
		DoorCache[doorid][dOwnerType],

		DoorCache[doorid][dAudioURL],
		DoorCache[doorid][dEnterPay]);

		Iter_Add(Door, doorid);
		CreatePickup(DoorCache[doorid][dPickupID], 2, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ], DoorCache[doorid][dEnterVW]);
	}
	mysql_free_result();
	
	printf("[load] Proces wczytywania drzwi zosta� zako�czony (count: %d).", Iter_Count(Door));
	return 1;
}

public ShowPlayerDoorInfo(playerid, doorid)
{
    new list_stats[512], string[128];
	format(list_stats, sizeof(list_stats), "PickupID:\t\t%d\n", DoorCache[doorid][dPickupID]);

	if(DoorCache[doorid][dLocked])
	{
		format(list_stats, sizeof(list_stats), "%sDrzwi:\t\t\t{FB5006}Zamkni�te{FFFFFF}\n", list_stats);
	}
	else
	{
	    format(list_stats, sizeof(list_stats), "%sDrzwi:\t\t\tOtwarte\n", list_stats);
	}

	if(DoorCache[doorid][dOwnerType] == OWNER_NONE)
	{
 		format(list_stats, sizeof(list_stats), "%sTyp w�a�ciciela:\t\tBrak\n", list_stats);
	}
	if(DoorCache[doorid][dOwnerType] == OWNER_PLAYER)
	{
		format(list_stats, sizeof(list_stats), "%sTyp w�a�ciciela:\t\tGracz\n", list_stats);
		format(list_stats, sizeof(list_stats), "%sUID gracza:\t\t%d\n", list_stats, DoorCache[doorid][dOwner]);
	}
	if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
	{
		format(list_stats, sizeof(list_stats), "%sTyp w�a�ciciela:\t\tGrupa\n", list_stats);
		format(list_stats, sizeof(list_stats), "%sUID grupy:\t\t%d\n", list_stats, DoorCache[doorid][dOwner]);
	}
	
	if(DoorCache[doorid][dEnterPay])
	{
	    format(list_stats, sizeof(list_stats), "%sKoszt wst�pu:\t\t$%d\n", list_stats, DoorCache[doorid][dEnterPay]);
	}

	if(strlen(DoorCache[doorid][dAudioURL]))
	{
	    format(list_stats, sizeof(list_stats), "%s \nMuzyka:\n\t\t%s\n", list_stats, DoorCache[doorid][dAudioURL]);
	}

	format(string, sizeof(string), "%s (SampID: %d, UID: %d) � Informacje", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
	ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_LIST, string, list_stats, "OK", "");
	return 1;
}

public CreatePlayerItem(playerid, ItemName[], ItemType, ItemValue1, ItemValue2)
{
    new item_uid, itemid = INVALID_ITEM_ID, item_real_name[32];
	
	if(ItemType == ITEM_PHONE) 		ItemValue1 = 100000 + random(899999);
	if(ItemType == ITEM_INHIBITOR) 	ItemValue1 = 22;
	if(ItemType == ITEM_PAINT) 		ItemValue1 = 41;
	
	mysql_real_escape_string(ItemName, item_real_name);
	mysql_query_format("INSERT INTO `"SQL_PREF"items` (item_name, item_type, item_value1, item_value2, item_place, item_owner) VALUES ('%s', '%d', '%d', '%d', '%d', '%d')", item_real_name, ItemType, ItemValue1, ItemValue2, PLACE_PLAYER, PlayerCache[playerid][pUID]);

	item_uid = mysql_insert_id();
	itemid = Iter_Free(Item);
	
	ItemCache[itemid][iUID] = item_uid;
	strmid(ItemCache[itemid][iName], item_real_name, 0, strlen(item_real_name), 32);
	
	ItemCache[itemid][iValue1] = ItemValue1;
	ItemCache[itemid][iValue2] = ItemValue2;
	
	ItemCache[itemid][iType] = ItemType;
	
	ItemCache[itemid][iPlace] = PLACE_PLAYER;
	ItemCache[itemid][iOwner] = PlayerCache[playerid][pUID];
	
	Iter_Add(Item, itemid);
	printf("[item] %s (UID: %d, GID: %d) otrzyma� przedmiot %s (UID: %d) do ekwipunku.", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], ItemCache[itemid][iName], ItemCache[itemid][iUID]);
	
	return itemid;
}

public LoadItemCache(item_uid)
{
    new data[128], itemid = Iter_Free(Item);
   	mysql_query_format("SELECT `item_uid`, `item_name`, `item_value1`, `item_value2`, `item_type`, `item_place`, `item_owner`, `item_group` FROM `"SQL_PREF"items` WHERE item_uid = '%d' LIMIT 1", item_uid);

	mysql_store_result();
	if(mysql_fetch_row_format(data, "|"))
	{
		sscanf(data, "p<|>ds[32]dddddd",
		ItemCache[itemid][iUID],
		ItemCache[itemid][iName],
		
		ItemCache[itemid][iValue1],
		ItemCache[itemid][iValue2],
		
		ItemCache[itemid][iType],
		
		ItemCache[itemid][iPlace],
		ItemCache[itemid][iOwner],

		ItemCache[itemid][iGroup]);
		Iter_Add(Item, itemid);
	}
	mysql_free_result();
	return itemid;
}

public SaveItem(itemid, what)
{
	new main_query[256], query[128];
	format(main_query, sizeof(main_query), "UPDATE `"SQL_PREF"items` SET");
	
	if(what & SAVE_ITEM_NAME)
	{
 		// Nazwa
		format(query, sizeof(query), " item_name = '%s'",
		ItemCache[itemid][iName]);

		if(strlen(main_query) > 32)
		{
  			strcat(main_query, ",", sizeof(main_query));
		}
		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_ITEM_VALUES)
	{
	    // Warto�ci
		format(query, sizeof(query), " item_value1 = '%d', item_value2 = '%d'",
		ItemCache[itemid][iValue1],
		ItemCache[itemid][iValue2]);

		if(strlen(main_query) > 32)
		{
  			strcat(main_query, ",", sizeof(main_query));
		}
		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_ITEM_TYPE)
	{
	    // Typ
	    format(query, sizeof(query), " item_type = '%d'",
	    ItemCache[itemid][iType]);
	    
   		if(strlen(main_query) > 32)
		{
  			strcat(main_query, ",", sizeof(main_query));
		}
		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_ITEM_OWNER)
	{
	    // W�a�ciciel
 		format(query, sizeof(query), " item_place = '%d', item_owner = '%d'",
	    ItemCache[itemid][iPlace],
		ItemCache[itemid][iOwner]);

   		if(strlen(main_query) > 32)
		{
  			strcat(main_query, ",", sizeof(main_query));
		}
		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_ITEM_USED)
	{
		// W u�yciu
		format(query, sizeof(query), " item_used = '%d'",
		ItemCache[itemid][iUsed]);
		
		if(strlen(main_query) > 32)
		{
  			strcat(main_query, ",", sizeof(main_query));
		}
		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_ITEM_GROUP)
	{
		// Grupa
		format(query, sizeof(query), " item_group = '%d'",
		ItemCache[itemid][iGroup]);

		if(strlen(main_query) > 32)
		{
  			strcat(main_query, ",", sizeof(main_query));
		}
		strcat(main_query, query, sizeof(main_query));
	}
	
	format(query, sizeof(query), " WHERE item_uid = '%d' LIMIT 1", ItemCache[itemid][iUID]);
	strcat(main_query, query, sizeof(main_query));

	mysql_query(connHandle, main_query);
	return 1;
}

public DeleteItem(itemid)
{
	mysql_query_format("DELETE FROM `"SQL_PREF"items` WHERE item_uid = '%d' LIMIT 1", ItemCache[itemid][iUID]);
	ClearItemCache(itemid);
	return 1;
}

public ShowPlayerItemInfo(playerid, itemid)
{
	new list_info[512], title[64],
	    item_type = ItemCache[itemid][iType];
	    
    format(list_info, sizeof(list_info), "Identyfikator:\t\t%d\n", ItemCache[itemid][iUID]);
    format(list_info, sizeof(list_info), "%sTyp:\t\t\t%s\n\n", list_info, ItemTypeInfo[item_type][iTypeName]);

	if(ItemCache[itemid][iUsed])
	{
	    format(list_info, sizeof(list_info), "%sStatus:\t\t\tW u�yciu\n", list_info);
	}
	else
	{
		format(list_info, sizeof(list_info), "%sStatus:\t\t\tNieaktywny\n", list_info);
	}
	
	format(list_info, sizeof(list_info), "%sWaga:\t\t\t%dg\n\n", list_info, GetItemWeight(itemid));

	format(list_info, sizeof(list_info), "%sW�a�ciwo�� 1:\t\t%d\n", list_info, ItemCache[itemid][iValue1]);
	format(list_info, sizeof(list_info), "%sW�a�ciwo�� 2:\t\t%d\n\n", list_info, ItemCache[itemid][iValue2]);
	
	format(list_info, sizeof(list_info), "%sGrupa:\t\t\t%d\n", list_info, ItemCache[itemid][iGroup]);

	format(title, sizeof(title), "Informacje � %s", ItemCache[itemid][iName]);
	ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, title, list_info, "OK", "");
	return 1;
}

public ListPlayerItems(playerid)
{
    new list_items[1024],
		item_count, weight_sum;
    format(list_items, sizeof(list_items), "{C0C0C0} -- Lista posiadanych przedmiot�w:");
		
	foreach(new itemid : Item)
	{
		if(ItemCache[itemid][iUID])
		{
  			if(ItemCache[itemid][iPlace] == PLACE_PLAYER && ItemCache[itemid][iOwner] == PlayerCache[playerid][pUID])
     		{
       			if(ItemCache[itemid][iUsed])
	         	{
		        	format(list_items, sizeof(list_items), "%s\n{AB8333} %s\t\t{000000}%d\t%d\t%dg", list_items, ItemCache[itemid][iName], ItemCache[itemid][iUID], itemid, GetItemWeight(itemid));
           		}
           		else
            	{
        			format(list_items, sizeof(list_items), "%s\n{FFFFFF} %s\t\t{000000}%d\t%d\t%dg", list_items, ItemCache[itemid][iName], ItemCache[itemid][iUID], itemid, GetItemWeight(itemid));
				}
				
				item_count ++;
				weight_sum += GetItemWeight(itemid);
			}
   		}
	}

	if(item_count)
	{
	    new title[128];
	    
	    format(title, sizeof(title), "Przedmioty [ilo��: %d | suma wag: %dg]", item_count, weight_sum);
		ShowPlayerDialog(playerid, D_ITEM_PLAYER_LIST, DIALOG_STYLE_LIST, title, list_items, "U�yj", "Opcje...");
	}
	else
	{
 		TD_ShowSmallInfo(playerid, 3, "Nie posiadasz ~r~zadnych ~w~przedmiotow.");
	}
	return item_count;
}

public ListPlayerItemsForPlayer(playerid, giveplayer_id)
{
	new list_items[1024], item_count, string[128];
	format(list_items, sizeof(list_items), "{C0C0C0}UID\t\tWAGA\t\tNAZWA");

	foreach(new itemid : Item)
	{
	    if(ItemCache[itemid][iUID])
	    {
	        if(ItemCache[itemid][iPlace] == PLACE_PLAYER && ItemCache[itemid][iOwner] == PlayerCache[playerid][pUID])
	        {
	            format(list_items, sizeof(list_items), "%s\n%d\t\t%dg\t\t%s", list_items, ItemCache[itemid][iUID], GetItemWeight(itemid), ItemCache[itemid][iName]);

				item_count ++;
	        }
	    }
	}
	if(item_count)
	{
	    format(string, sizeof(string), "Przedmioty gracza %s:", PlayerName(playerid));
        ShowPlayerDialog(giveplayer_id, D_NONE, DIALOG_STYLE_LIST, string, list_items, "OK", "");
	}
	else
	{
	    TD_ShowSmallInfo(playerid, 3, "Nie znaleziono ~r~zadnych ~w~przedmiotow.");
	}
	return 1;
}

public ListVehicleItemsForPlayer(vehicleid, playerid)
{
    new	item_uid, item_name[32], data[64], list_items[512];
	mysql_query_format("SELECT `item_uid`, `item_name` FROM `"SQL_PREF"items` WHERE item_place = '%d' AND item_owner = '%d'", PLACE_VEHICLE, CarInfo[vehicleid][cUID]);

	mysql_store_result();
   	while(mysql_fetch_row_format(data, "|"))
   	{
     	sscanf(data, "p<|>ds[32]", item_uid, item_name);
     	format(list_items, sizeof(list_items), "%s\n%d\t%s", list_items, item_uid, item_name);
	}
  	mysql_free_result();
  	
  	if(strlen(list_items))
  	{
	  	ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_LIST, "Przedmioty znajduj�ce si� w poje�dzie", list_items, "OK", "");
	}
	else
	{
	    TD_ShowSmallInfo(playerid, 3, "Nie znaleziono ~r~zadnych ~w~przedmiotow w poblizu.");
	}
	return 1;
}

public ListPlayerNearItems(playerid)
{
	new data[64], list_items[512];
	
	if(!IsPlayerInAnyVehicle(playerid))
	{
		new Float:PosX, Float:PosY, Float:PosZ,
			virtual_world = GetPlayerVirtualWorld(playerid), interior_id = GetPlayerInterior(playerid);
			
		GetPlayerPos(playerid, PosX, PosY, PosZ);
		mysql_query_format("SELECT `item_uid`, `item_name` FROM `"SQL_PREF"items` WHERE item_posx < %f + 2 AND item_posx > %f - 2 AND item_posy < %f + 2 AND item_posy > %f - 2 AND item_posz < %f + 2 AND item_posz > %f - 2 AND item_place = '%d' AND item_world = '%d' AND item_interior = '%d'", PosX, PosX, PosY, PosY, PosZ, PosZ, PLACE_NONE, virtual_world, interior_id);
	}
	else
	{
	    new vehid = GetPlayerVehicleID(playerid);
	    if(!(PlayerCache[playerid][pAdmin] & A_PERM_ITEMS))
	    {
	   		if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER && CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID])
			{
				ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz podnosi� przedmiot�w z tego pojazdu.");
				return 1;
			}
			if(CarInfo[vehid][cOwnerType] == OWNER_GROUP)
			{
			    if(!HavePlayerGroupPerm(playerid, CarInfo[vehid][cOwner], G_PERM_CARS))
			    {
	                ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz podnosi� przedmiot�w z tego pojazdu.");
			        return 1;
			    }
			}
		}
		mysql_query_format("SELECT `item_uid`, `item_name` FROM `"SQL_PREF"items` WHERE item_place = '%d' AND item_owner = '%d'", PLACE_VEHICLE, CarInfo[vehid][cUID]);
	}
	
	new	item_uid, item_name[32];

	mysql_store_result();
   	while(mysql_fetch_row_format(data, "|"))
   	{
     	sscanf(data, "p<|>ds[32]", item_uid, item_name);
     	format(list_items, sizeof(list_items), "%s\n%d\t\t%s", list_items, item_uid, item_name);
	}
  	mysql_free_result();
  	if(!strlen(list_items))
  	{
     	TD_ShowSmallInfo(playerid, 3, "Nie znaleziono ~r~zadnych ~w~przedmiotow w poblizu.");
     	return 1;
	}
	ShowPlayerDialog(playerid, D_ITEM_RAISE, DIALOG_STYLE_LIST, "Przedmioty znajduj�ce si� w pobli�u:", list_items, "Podnie�", "Anuluj");
	return 1;
}

public OnPlayerUseItem(playerid, itemid)
{
	if(PlayerCache[playerid][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz u�ywa� przedmiot�w w stanie nieprzytomno�ci.");
	    return 0;
	}
	
	new string[256], item_type = ItemCache[itemid][iType];
	if(item_type == ITEM_NONE)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Ten przedmiot nie posiada �adnego zastosowania.");
	    return 0;
	}
	
	if(item_type == ITEM_WATCH)
	{
		new hour, minute, second;
		gettime(hour, minute, second);

		format(string, sizeof(string), "~w~Godzina: ~p~%02d:%02d:%02d", hour, minute, second);
		GameTextForPlayer(playerid, string, 5000, 1);

		format(string, sizeof(string), "* %s spogl�da na zegarek.", PlayerName(playerid));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

		ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 0, 0, 0, 0, 1);
	    return 1;
	}
	
	if(item_type == ITEM_FOOD)
	{
		if(PlayerCache[playerid][pHealth] > 20)
   		{
			if(PlayerCache[playerid][pHealth] + ItemCache[itemid][iValue1] <= 100)
			{
				new Float:health;
				
				GetPlayerHealth(playerid, health);
				crp_SetPlayerHealth(playerid, health + ItemCache[itemid][iValue1]);
			}
			else
			{
				crp_SetPlayerHealth(playerid, 100);
			}
		}
		else
		{
	    	TD_ShowSmallInfo(playerid, 5, "W tym stanie ~y~jedzenie ~w~nie pomoze Ci odregenerowac ~r~HP~w~.~n~~n~Udaj sie lepiej do ~g~szpitala ~w~nabyc lek.");
		}
		format(string, sizeof(string), "* %s spo�ywa \"%s\".", PlayerName(playerid), ItemCache[itemid][iName]);
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

        ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.0, 0, 0, 0, 0, 0, true);
		DeleteItem(itemid);
	    return 1;
	}
	
	if(item_type == ITEM_CIGGY)
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);

  		ItemCache[itemid][iValue1] --;
  		if(ItemCache[itemid][iValue1] <= 0)
		{
            DeleteItem(itemid);
            return 1;
		}
		SaveItem(itemid, SAVE_ITEM_VALUES);
	    return 1;
	}
	
	if(item_type == ITEM_CUBE)
	{
		new rand = 1 + random(ItemCache[itemid][iValue1]);

		format(string, sizeof(string), "* %s wyrzuci� %d oczek na %d.", PlayerName(playerid), rand, ItemCache[itemid][iValue1]);
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	    return 1;
	}
	
	if(item_type == ITEM_CLOTH)
	{
		if(!ItemCache[itemid][iValue1])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz u�y� tego przedmiotu.");
			return 0;
		}
	    if(ItemCache[itemid][iUsed])
	    {
	        crp_SetPlayerSkin(playerid, ItemCache[itemid][iValue1]);
	        return 1;
	    }
		
		foreach(new i : Item)
		{
  			if(ItemCache[i][iPlace] == PLACE_PLAYER && ItemCache[i][iOwner] == PlayerCache[playerid][pUID])
     		{
			    if(ItemCache[i][iType] == ITEM_CLOTH && ItemCache[i][iUsed])
			    {
					ItemCache[i][iUsed] = false;
					SaveItem(i, SAVE_ITEM_USED);
					break;
				}
			}
		}
		ItemCache[itemid][iUsed] = true;
		SaveItem(itemid, SAVE_ITEM_USED);
		
		crp_SetPlayerSkin(playerid, ItemCache[itemid][iValue1]);
	    return 1;
	}
	
	if(item_type == ITEM_WEAPON || item_type == ITEM_INHIBITOR || item_type == ITEM_PAINT)
	{
		if(IsPlayerInAnyVehicle(playerid))
	    {
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz tego u�y� b�d�c w poje�dzie.");
     		return 0;
	    }
		if(ItemCache[itemid][iValue1] > 15 && ItemCache[itemid][iValue1] < 44 && !ItemCache[itemid][iValue2])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Amunicja w tej broni jest ca�kowicie zu�yta.");
   			return 0;
		}
		if(PlayerCache[playerid][pItemWeapon] != INVALID_ITEM_ID)
		{
		    if(PlayerCache[playerid][pItemWeapon] != itemid)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Najpierw schowaj obecn� bro�, aby m�c wyj�� drug�.");
		        return 0;
		    }
		}
		if(!strfind(ItemCache[itemid][iName], "(F)", true))
		{
		    if(!PlayerCache[playerid][pDutyGroup])
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby u�y� tej broni, musisz by� na s�u�bie grupy z odpowiednimi uprawnieniami.");
		        return 0;
		    }
			new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
			if(!(GroupData[group_id][gFlags] & G_FLAG_WEAPONS))
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
			    return 0;
			}
		}
		if(ItemCache[itemid][iGroup])
		{
			new group_id = GetGroupID(ItemCache[itemid][iGroup]);
			if(group_id != INVALID_GROUP_ID)
			{
				if(!IsPlayerInGroup(playerid, GroupData[group_id][gUID]))
  				{
  					ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ta bro� zosta�a oflagowana specjalnie dla grupy!\nAby u�y� tej broni, musisz by� w grupie %s (UID: %d).", GroupData[group_id][gName], GroupData[group_id][gUID]);
					return 0;
				}
			}
			else
			{
   				ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Ta bro� zosta�a oflagowana specjalnie dla grupy!\nPrzedmiot zostanie usuni�ty, ze wzgl�du na brak mo�liwo�ci jego u�ytkowania (grupa nie istnieje).");
				DeleteItem(itemid);
				return 0;
			}
		}
		
		if(!ItemCache[itemid][iUsed])
		{
		    PlayerCache[playerid][pCheckWeapon] = false;
		
		    PlayerCache[playerid][pItemWeapon] = itemid;
		    GivePlayerWeapon(playerid, ItemCache[itemid][iValue1], ItemCache[itemid][iValue2]);
		    
		    ItemCache[itemid][iUsed] = true;
		}
		else
		{
		    PlayerCache[playerid][pCheckWeapon] = false;
		
		    ResetPlayerWeaponsEx(playerid);
		    PlayerCache[playerid][pItemWeapon] = INVALID_ITEM_ID;
		    
			RemovePlayerAttachedObject(playerid, SLOT_WEAPON);
		    
		    ItemCache[itemid][iUsed] = false;
		    SaveItem(itemid, SAVE_ITEM_VALUES);
		}
	    return 1;
	}
	
	if(item_type == ITEM_AMMO)
	{
	    if(!ItemCache[itemid][iValue1])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten magazynek jest ca�kowicie pusty.");
	        return 0;
	    }
	    
	    new list_items[256];
	    foreach(new weapon_itemid : Item)
	    {
	        if(ItemCache[weapon_itemid][iUID])
	        {
				if(ItemCache[weapon_itemid][iPlace] == PLACE_PLAYER && ItemCache[weapon_itemid][iOwner] == PlayerCache[playerid][pUID])
				{
				    if(ItemCache[weapon_itemid][iType] == ITEM_WEAPON)
				    {
				        if(ItemCache[weapon_itemid][iValue1] == ItemCache[itemid][iValue1])
				        {
				            format(list_items, sizeof(list_items), "%s\n%d\t%d\t%d\t%s", list_items, ItemCache[weapon_itemid][iUID], ItemCache[weapon_itemid][iValue1], ItemCache[weapon_itemid][iValue2], ItemCache[weapon_itemid][iName]);
				        }
				    }
				}
	        }
	    }
	    
	    if(strlen(list_items))
	    {
	        PlayerCache[playerid][pManageItem] = itemid;
	        ShowPlayerDialog(playerid, D_ITEM_RELOAD_WEAPON, DIALOG_STYLE_LIST, "Bronie, kt�re mo�esz prze�adowa�:", list_items, "Prze�aduj", "Anuluj");
	    }
	    else
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz broni, do kt�rej m�g�by� u�y� tej amunicji.");
	    }
	    return 1;
	}
	
	if(item_type == ITEM_PHONE)
	{
	    if(ItemCache[itemid][iUsed])
	    {
	    	new hour, minute, second;
	    	gettime(hour, minute, second);

	        PlayerCache[playerid][pManageItem] = itemid;
	        
   			format(string, sizeof(string), "%s [%d] [%02d:%02d:%02d]", ItemCache[itemid][iName], ItemCache[itemid][iValue1], hour, minute, second);
			ShowPlayerDialog(playerid, D_PHONE_OPTIONS, DIALOG_STYLE_LIST, string, "1. Wybierz numer\n2. Napisz SMS'a\n3. Wy�lij vCard\n4. Kontakty\n5. Wy��cz telefon", "Wybierz", "Anuluj");
	    }
	    else
	    {
	        if(PlayerCache[playerid][pPhoneNumber])
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Mo�esz u�ywa� jednocze�nie tylko jednego telefonu.");
	            return 0;
	        }
	        
	        ItemCache[itemid][iUsed] = true;
	        SaveItem(itemid, SAVE_ITEM_USED);
	        
	        PlayerCache[playerid][pPhoneNumber] = ItemCache[itemid][iValue1];
	        TD_ShowSmallInfo(playerid, 3, "Telefon zostal pomyslnie ~g~wlaczony~w~.");
	    }
	    return 1;
	}
	
	if(item_type == ITEM_CANISTER)
	{
 		if(!ItemCache[itemid][iValue1])
	    {
	        new object_id = GetClosestObjectType(playerid, OBJECT_FUELING);
			if(object_id == INVALID_OBJECT_ID)
			{
    			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten kanister jest ca�kowicie pusty.\nNa stacji benzynowej b�dziesz m�g� go nape�ni�.");
				return 0;
			}
			new bens_type = ItemCache[itemid][iValue2],
			    price;
			
			if(bens_type == FUEL_TYPE_BENS) 			price = floatround(5 * 4.5);
			else if(bens_type == FUEL_TYPE_GAS) 		price = floatround(5 * 2.5);
			else if(bens_type == FUEL_TYPE_DIESEL) 		price = floatround(5 * 4.0);
			
			if(price > PlayerCache[playerid][pCash])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz takiej ilo�ci got�wki.");
			    return 1;
			}
			ItemCache[itemid][iValue1] = 5;
			SaveItem(itemid, SAVE_ITEM_VALUES);
			
			crp_GivePlayerMoney(playerid, -price);
			OnPlayerSave(playerid, SAVE_PLAYER_BASIC);
			
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Uda�o si� pomy�lnie zape�ni� %s (UID: %d).\nObecna ilo�� paliwa: %dL", ItemCache[itemid][iName], ItemCache[itemid][iUID], ItemCache[itemid][iValue1]);
	        return 1;
	    }
	    new vehid = GetClosestVehicle(playerid);
	    if(vehid == INVALID_VEHICLE_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego pojazdu w pobli�u.");
	        return 0;
	    }
	    new max_fuel = GetVehicleMaxFuel(CarInfo[vehid][cModel]);
	    if(floatround(CarInfo[vehid][cFuel]) >= max_fuel)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten pojazd ma pe�ny bak paliwa.");
	        return 0;
	    }
	    if(CarInfo[vehid][cFuelType] != ItemCache[itemid][iValue2])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Rodzaj paliwa w kanistrze nie pasuje do tego w poje�dzie.");
	        return 0;
	    }
	    if(CarInfo[vehid][cFuel] + ItemCache[itemid][iValue1] <= max_fuel)
	    {
     		new item_fuel = ItemCache[itemid][iValue1], Float:Refuel = floatround(CarInfo[vehid][cFuel]) + item_fuel;
         	CarInfo[vehid][cFuel] = Refuel;

         	ItemCache[itemid][iValue1] = 0;
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd %s zosta� pomy�lnie zatankowany.\nZatankowano %d litr�w paliwa.", GetVehicleName(CarInfo[vehid][cModel]), item_fuel);
	    }
	    else
	    {
     		new needfuel = max_fuel - floatround(CarInfo[vehid][cFuel]), Float:Refuel = floatround(CarInfo[vehid][cFuel]) + needfuel;
       		CarInfo[vehid][cFuel] = Refuel;

			ItemCache[itemid][iValue1] = ItemCache[itemid][iValue1] - needfuel;
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd %s zosta� pomy�lnie zatankowany.\nZatankowano %d litr�w paliwa.", GetVehicleName(CarInfo[vehid][cModel]), needfuel);
	    }
	    SaveItem(itemid, SAVE_ITEM_VALUES);
	    
		format(string, sizeof(string), "* %s tankuje pojazd %s za pomoc� kanistra.", PlayerName(playerid), GetVehicleName(CarInfo[vehid][cModel]));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

		ApplyAnimation(playerid, "INT_HOUSE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		SaveVehicle(vehid, SAVE_VEH_COUNT);
	    return 1;
	}
	
	if(item_type == ITEM_MASK)
	{
 		if(!PlayerCache[playerid][pDutyGroup])
   		{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby u�y� tego przedmiotu, musisz by� na s�u�bie grupy z odpowiednimi uprawnieniami.");
       		return 0;
	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(!(GroupData[group_id][gFlags] & G_FLAG_MASK))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
  			return 0;
		}
		if(!ItemCache[itemid][iValue1])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten przedmiot jest ca�kowicie zu�yty.");
		    return 0;
		}
		if(PlayerCache[playerid][pItemMask] != INVALID_ITEM_ID)
		{
			if(PlayerCache[playerid][pItemMask] != itemid)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Masz ju� jak�� mask� w u�yciu.");
			    return 0;
			}
		}
 		new name[MAX_PLAYER_NAME];
	    if(!ItemCache[itemid][iUsed])
	    {
	        ItemCache[itemid][iUsed] = true;
	        PlayerCache[playerid][pItemMask] = itemid;

	 		format(string, sizeof(string), "* %s zak�ada przedmiot %s na twarz.", PlayerName(playerid), ItemCache[itemid][iName]);
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

			format(name, sizeof(name), "Nieznajomy_%s", CharCode(PlayerCache[playerid][pUID]));
			strmid(PlayerCache[playerid][pCharName], name, 0, strlen(name), 32);

			format(string, sizeof(string), "%s", PlayerName(playerid));
			UpdateDynamic3DTextLabelText(Text3D:PlayerCache[playerid][pNameTag], PlayerCache[playerid][pNickColor], string);
		}
		else
		{
		    ItemCache[itemid][iUsed] = false;
      		PlayerCache[playerid][pItemMask] = INVALID_ITEM_ID;

			format(string, sizeof(string), "* %s zdejmuje z twarzy przedmiot %s.", PlayerName(playerid), ItemCache[itemid][iName]);
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

			GetPlayerName(playerid, name, sizeof(name));
			strmid(PlayerCache[playerid][pCharName], name, 0, strlen(name), 32);

			format(string, sizeof(string), "%s (%d)", PlayerName(playerid), playerid);
            UpdateDynamic3DTextLabelText(Text3D:PlayerCache[playerid][pNameTag], PlayerCache[playerid][pNickColor], string);

			ItemCache[itemid][iValue1] --;
			if(ItemCache[itemid][iValue1] > 0)	SaveItem(itemid, SAVE_ITEM_VALUES);
			else								DeleteItem(itemid);
		}
	    return 1;
	}
	
	if(item_type == ITEM_HANDCUFFS)
	{
	    cmd_skuj(playerid, "");
	    return 1;
	}
	
	if(item_type == ITEM_MEGAPHONE)
	{
 		cmd_m(playerid, "");
	    return 1;
	}
	
	if(item_type == ITEM_LINE)
	{
	    cmd_oferuj(playerid, "holowanie");
	    return 1;
	}
	
	if(item_type == ITEM_NOTEBOOK)
	{
		if(ItemCache[itemid][iValue1] <= 0)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W tym notesie brakuje karteczek.");
		    return 0;
		}
		
  		PlayerCache[playerid][pManageItem] = itemid;
  		ShowPlayerDialog(playerid, D_ITEM_ADD_CHIT, DIALOG_STYLE_INPUT, "Notatnik � Karteczka", "Wpisz tre��, kt�ra b�dzie widnie� na karteczce.\nWpisan� tre�� b�dzie m�g� ujrze� ka�dy kto u�yje karteczki.", "OK", "Anuluj");
	    return 1;
	}
	
	if(item_type == ITEM_CHIT)
	{
 		new data[256],
	        chit_uid, chit_desc[128], chit_writer[24], chit_time[24];
	        
	    mysql_query_format("SELECT * FROM `"SQL_PREF"chits` WHERE chit_uid = '%d' LIMIT 1", ItemCache[itemid][iValue1]);

	    mysql_store_result();
		if(mysql_fetch_row_format(data, "|"))
		{
		    sscanf(data, "p<|>ds[128]s[24]s[24]", chit_uid, chit_desc, chit_writer, chit_time);

		    format(string, sizeof(string), "%s\n\n%s,\n%s", WordWrap(chit_desc, WRAP_AUTO), chit_writer, chit_time);
			ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, ItemCache[itemid][iName], string, "OK", "");
		}
	    mysql_free_result();
	    return 1;
	}
	
	if(item_type == ITEM_TUNING)
	{
		return 1;
	}
	
	if(item_type == ITEM_CHECKBOOK)
	{
 		if(PlayerCache[playerid][pHours] < 5)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wypisa� czeku maj�c na koncie poni�ej 5h gry.");
	        return 0;
	    }
	    if(ItemCache[itemid][iValue1] <= 0)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wszystkie czeki zosta�y wykorzystane.");
	        return 0;
	    }
	    
     	PlayerCache[playerid][pManageItem] = itemid;
    	ShowPlayerDialog(playerid, D_ITEM_WRITE_A_CHECK, DIALOG_STYLE_INPUT, "Wypisz czek", "Wprowad� kwot� jak� chcesz wypisa� na czeku.\nKwota jak� wpiszesz, zostanie pobrana z Twojego konta bankowego.", "Wypisz", "Anuluj");
	    return 1;
	}
	
	if(item_type == ITEM_CHECK)
	{
 		if(PlayerCache[playerid][pHours] < 5)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zrealizowa� czeku maj�c na koncie poni�ej 5h gry.");
	        return 0;
	    }
		new doorid = GetPlayerDoorID(playerid);
		if(doorid == INVALID_DOOR_ID)
		{
      		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby zrealizowa� czek, musisz znajdowa� si� w banku.");
		    return 0;
		}
	 	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
	  	{
	   		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby zrealizowa� czek, musisz znajdowa� si� w banku.");
	   		return 0;
	   	}
	   	new group_id = GetGroupID(DoorCache[doorid][dOwner]);
	   	if(GroupData[group_id][gType] != G_TYPE_BANK)
	   	{
	   	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby zrealizowa� czek, musisz znajdowa� si� w banku.");
	   	    return 0;
	   	}
		if(!PlayerCache[playerid][pBankNumber])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz za�o�onego konta bankowego.");
		    return 0;
		}
		PlayerCache[playerid][pBankCash] += ItemCache[itemid][iValue1];
		OnPlayerSave(playerid, SAVE_PLAYER_BASIC);

		format(string, sizeof(string), "* %s realizuje czek na $%d.", PlayerName(playerid), ItemCache[itemid][iValue1]);
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Czek zosta� pomy�lnie zrealizowany.\nNa Twoje konto bankowe przelano $%d.\n\nAktualny stan konta: $%d", ItemCache[itemid][iValue1], PlayerCache[playerid][pBankCash]);
        DeleteItem(itemid);
	    return 1;
	}
	
	if(item_type == ITEM_BAG)
	{
		new data[32], list_items[512], item_uid, item_name[32];
	    mysql_query_format("SELECT `item_uid`, `item_name` FROM `"SQL_PREF"items` WHERE item_place = '%d' AND item_owner = '%d'", PLACE_BAG, ItemCache[itemid][iUID]);

	    mysql_store_result();
		while(mysql_fetch_row_format(data, "|"))
		{
			sscanf(data, "p<|>ds[32]", item_uid, item_name);
			format(list_items, sizeof(list_items), "%s\n%d\t\t%s", list_items, item_uid, item_name);
		}
	    mysql_free_result();
	    if(strlen(list_items))
	    {
	        ShowPlayerDialog(playerid, D_ITEM_REMOVE_BAG, DIALOG_STYLE_LIST, "Znaleziono przedmioty:", list_items, "Wyjmij", "Anuluj");
	    }
	    else
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnych przedmiot�w.");
	    }
	    
	    PlayerCache[playerid][pManageItem] = itemid;
	    return 1;
	}
	
	if(item_type == ITEM_DRINK)
	{
		if(ItemCache[itemid][iValue1] != 20 && ItemCache[itemid][iValue1] != 22 && ItemCache[itemid][iValue1] != 23)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz u�y� tego przedmiotu, prawdopodobnie podane zosta�y b��dne jego warto�ci.");
			return 0;
		}
		
		SetPlayerSpecialAction(playerid, ItemCache[itemid][iValue1]);
        DeleteItem(itemid);
	    return 1;
	}
	
	if(item_type == ITEM_VEH_ACCESS)
	{
	    cmd_oferuj(playerid, "montaz");
	    return 1;
	}
	
	if(item_type == ITEM_DISC)
	{
	    if(ItemCache[itemid][iValue1])
	    {
	        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				new vehid = GetPlayerVehicleID(playerid);
				if(!(CarInfo[vehid][cAccess] & VEH_ACCESS_AUDIO))
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W tym poje�dzie nie zosta� zamontowany sprz�t audio.");
				    return 0;
				}
				
    			new data[128], audio_url[128];
    			mysql_query_format("SELECT `audio_url` FROM `"SQL_PREF"audiourls` WHERE audio_uid = '%d' LIMIT 1", ItemCache[itemid][iValue1]);

				mysql_store_result();
				if(mysql_fetch_row_format(data, "|"))
				{
				    sscanf(data, "p<|>s[128]", audio_url);
				    strmid(CarInfo[vehid][cAudioURL], audio_url, 0, strlen(audio_url), 64);

				    // Za��cz muz� u wszystkich, nie tylko u siebie
				    foreach(new i : Player)
				    {
				        if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
				        {
	           				if(GetPlayerVehicleID(i) == vehid)
	           				{
	           				    if(PlayerCache[i][pItemPlayer] != INVALID_ITEM_ID)
	           				    {
				        			ItemCache[PlayerCache[i][pItemPlayer]][iUsed] = false;
								}
								
	           				    PlayStreamedAudioForPlayer(i, CarInfo[vehid][cAudioURL]);
							}
						}
					}
				}
				mysql_free_result();

				format(string, sizeof(string), "* %s umieszcza p�yt� w radiu.", PlayerName(playerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
				
				TD_ShowSmallInfo(playerid, 5, "Plyta ~y~%s ~w~zostala odtworzona pomyslnie.", ItemCache[itemid][iName]);
	        }
	        else
	        {
	            new list_items[256];
	            PlayerCache[playerid][pManageItem] = itemid;
	            
	            foreach(new i : Item)
	            {
	                if(ItemCache[i][iUID])
	                {
	                    if(ItemCache[i][iPlace] == PLACE_PLAYER && ItemCache[i][iOwner] == PlayerCache[playerid][pUID])
	                    {
	                        if(ItemCache[i][iType] == ITEM_PLAYER || ItemCache[i][iType] == ITEM_BOOMBOX)
	                        {
								format(list_items, sizeof(list_items), "%s\n%d\t\t%s", list_items, ItemCache[i][iUID], ItemCache[i][iName]);
	                        }
	                    }
	                }
	            }
	            
	            if(strlen(list_items))
	            {
	                ShowPlayerDialog(playerid, D_DISC_INSERT, DIALOG_STYLE_LIST, "Dost�pne odtwarzacze:", list_items, "Wybierz", "Anuluj");
	            }
	            else
	            {
					TD_ShowSmallInfo(playerid, 3, "Nie posiadasz ~r~zadnych ~w~odtwarzaczy.");
	            }
	        }
	    }
	    else
	    {
	        PlayerCache[playerid][pManageItem] = itemid;
	        ShowPlayerDialog(playerid, D_DISC_RECORD, DIALOG_STYLE_INPUT, "Czysta p�yta � Nagrywanie", "To jest czysta p�yta, na kt�rej mo�esz nagra� dowolny kawa�ek.\nWklej w pole tekstowe poni�ej link do muzyki, kt�ra ma by� odtwarzana poprzez urz�dzenia.\n\nUpewnij si�, �e link jest poprawny w innym wypadku muzyka mo�e nie by� s�yszalna.\n\nD�ugo�� linku nie mo�e przekroczy� 64 znak�w.", "Nagraj", "Anuluj");
	    }
	    return 1;
	}
	
	if(item_type == ITEM_PLAYER)
	{
		if(!ItemCache[itemid][iValue1])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W tym odtwarzaczu nie ma �adnej p�yty.");
		    return 0;
		}
		if(IsPlayerInAnyVehicle(playerid))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz siedzie� w poje�dzie.");
		    return 0;
		}
		if(PlayerCache[playerid][pItemPlayer] != INVALID_ITEM_ID)
		{
			if(PlayerCache[playerid][pItemPlayer] != itemid)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Korzystasz ju� z jakiego� odtwarzacza.");
			    return 0;
			}
		}
		if(ItemCache[itemid][iUsed])
		{
			StopStreamedAudioForPlayer(playerid);
			
			PlayerCache[playerid][pItemPlayer] = INVALID_ITEM_ID;
			ItemCache[itemid][iUsed] = false;
			
			TD_ShowSmallInfo(playerid, 3, "Odtwarzanie muzyki zostalo ~r~zakonczone~w~.");
		}
		else
		{
			StopStreamedAudioForPlayer(playerid);
			
			PlayerCache[playerid][pItemPlayer] = itemid;
			ItemCache[itemid][iUsed] = true;

   			new data[128], audio_url[128];
			mysql_query_format("SELECT `audio_url` FROM `"SQL_PREF"audiourls` WHERE audio_uid = '%d' LIMIT 1", ItemCache[itemid][iValue1]);

			mysql_store_result();
			if(mysql_fetch_row_format(data, "|"))
			{
   				sscanf(data, "p<|>s[128]", audio_url);
   				PlayStreamedAudioForPlayer(playerid, audio_url);
			}
			mysql_free_result();

			TD_ShowSmallInfo(playerid, 3, "Odtwarzanie muzyki zostalo ~g~rozpoczete~w~.");
		}
	    return 1;
	}
	
	if(item_type == ITEM_CLOTH_ACCESS)
	{
	    if(ItemCache[itemid][iUsed])
	    {
	        ItemCache[itemid][iUsed] = false;
	        SaveItem(itemid, SAVE_ITEM_USED);
	    
	        RemovePlayerAttachedObject(playerid, SLOT_ACCESS_1);
	        RemovePlayerAttachedObject(playerid, SLOT_ACCESS_2);
	        RemovePlayerAttachedObject(playerid, SLOT_ACCESS_3);
	        
			LoadPlayerAccess(playerid);
	    }
	    else
	    {
	        if(!ItemCache[itemid][iValue1] && !ItemCache[itemid][iValue2])
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz u�y� tego przedmiotu, prawdopodobnie podane zosta�y b��dne jego warto�ci.");
	            return 0;
	        }
	    
     		PlayerCache[playerid][pMainTable] = itemid;
       		ShowPlayerDialog(playerid, D_ACCESS_APPLY, DIALOG_STYLE_MSGBOX, "Akcesorie", "Wybierz poni�ej, jak chcia�by� zastosowa� przedmiot:", "Za��", "Dopasuj");
		}
	    return 1;
	}
	
	if(item_type == ITEM_PASS)
	{
	    if(ItemCache[itemid][iUsed])
	    {
			ItemCache[itemid][iUsed] = false;
			ItemCache[itemid][iValue1] = PlayerCache[playerid][pGymTime] / 60;

			SaveItem(itemid, SAVE_ITEM_VALUES);
			
			PlayerCache[playerid][pItemPass]    = INVALID_ITEM_ID;
			PlayerCache[playerid][pGymTime]     = 0;

			new object_id = PlayerCache[playerid][pGymObject];
			if(object_id != INVALID_OBJECT_ID)
			{
				ClearAnimations(playerid, true);
    			PlayerCache[playerid][pStrength] = PlayerCache[playerid][pStrength] + (PlayerCache[playerid][pGymRepeat] / 4);

				PlayerCache[playerid][pGymObject] 	= INVALID_OBJECT_ID;
    			PlayerCache[playerid][pGymRepeat] 	= 0;

				RemovePlayerAttachedObject(playerid, SLOT_TRAIN);
    			TD_ShowSmallInfo(playerid, 3, "Trening zostal ~g~pomyslnie ~w~zakonczony.");
			}
	    }
	    else
	    {
			if(PlayerCache[playerid][pGymTime])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie korzystasz ju� z jakiego� karnetu.");
			    return 0;
			}
			
			new doorid = GetPlayerDoorID(playerid);
			if(doorid == INVALID_DOOR_ID)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z karnetu musisz znajdowa� si� w si�owni.");
			    return 0;
			}
			if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z karnetu musisz znajdowa� si� w si�owni.");
			    return 0;
			}
			new group_id = GetGroupID(DoorCache[doorid][dOwner]);
			if(GroupData[group_id][gType] != G_TYPE_GYM || DoorCache[doorid][dOwner] != ItemCache[itemid][iValue2])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z karnetu musisz znajdowa� si� w si�owni.");
				return 0;
			}
			ItemCache[itemid][iUsed] = true;

			PlayerCache[playerid][pItemPass] = itemid;
			PlayerCache[playerid][pGymTime] = ItemCache[itemid][iValue1] * 60;
			
			TD_ShowSmallInfo(playerid, 3, "Skorzystaj z komendy ~r~/silownia~w~, w poblizu wybranego ~y~obiektu~w~, aby zaczac tening.");
	    }
	    return 1;
	}
	
	if(item_type == ITEM_ROLL)
	{
 		if(!ItemCache[itemid][iUsed])
	    {
	        if(IsPlayerInAnyVehicle(playerid))
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz u�y� tego przedmiotu w poje�dzie.");
	            return 0;
	        }
	        if(PlayerCache[playerid][pRoll])
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Masz ju� obecnie jakie� rolki w u�yciu.");
	            return 0;
	        }
	        if(GetPlayerDoorID(playerid) != INVALID_DOOR_ID)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz je�dzi� na rolkach wewn�trz budynku.");
	            return 0;
	        }
	        ItemCache[itemid][iUsed] = true;
	        PlayerCache[playerid][pRoll] = true;
	        
	        TD_ShowSmallInfo(playerid, 3, "Aby rozpoczac jazde na ~b~rolkach~w~, zacznij ~y~sprintowac~w~.");
	    }
	    else
	    {
     		ItemCache[itemid][iUsed] = false;
	        PlayerCache[playerid][pRoll] = false;

	        ClearAnimations(playerid, true);
	    }
	    SaveItem(itemid, SAVE_ITEM_USED);
	    return 1;
	}
	
	if(item_type == ITEM_MEDICINE)
	{
		if(PlayerCache[playerid][pHealth] < 80)
		{
			if(PlayerCache[playerid][pHealth] + ItemCache[itemid][iValue1] <= 100)
			{
				new Float:health;

				GetPlayerHealth(playerid, health);
				crp_SetPlayerHealth(playerid, health + ItemCache[itemid][iValue1]);
			}
			else
			{
				crp_SetPlayerHealth(playerid, 100);
			}
		}
		else
		{
			TD_ShowSmallInfo(playerid, 5, "Lek nie odregeneruje Ci ~r~paska zdrowia~w~.~n~Udaj sie do ~y~restauracji~w~, by spozyc jedzenie.");
		}
		format(string, sizeof(string), "* %s spo�ywa \"%s\".", PlayerName(playerid), ItemCache[itemid][iName]);
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

		DeleteItem(itemid);
	    return 1;
	}
	
	if(item_type == ITEM_DRUG)
	{
		new drug_type = ItemCache[itemid][iValue1];
		if(PlayerCache[playerid][pDrugType] != DRUG_NONE && PlayerCache[playerid][pDrugType] != drug_type)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Jeste� teraz pod wp�ywem innego narkotyku, u�ycie nast�pnego grozi �mierci�!");
		    return 0;
		}

		switch(drug_type)
		{
		    case DRUG_MARIHUANA:
		    {
      			new joint_quality = random(4) + 1, joint_itemid = CreatePlayerItem(playerid, "Joint", ITEM_JOINT, 1, joint_quality),
      			    quality_name[32];
      			    
      			switch(joint_quality)
      			{
      			    case 1: quality_name = "S�aba";
      			    case 2: quality_name = "�rednia";
      			    case 3: quality_name = "Dobra";
      			    case 4: quality_name = "Wy�mienita";
      			}
      			
		        ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Wykorzystuj�c przedmiot %s (UID: %d) uda�o Ci si� utworzy� przedmiot %s (UID: %d).\nNowy przedmiot powinien pojawi� si� w Twoim ekwipunku.\n\nJako��: %s", ItemCache[itemid][iName], ItemCache[itemid][iUID], ItemCache[joint_itemid][iName], ItemCache[joint_itemid][iUID], quality_name);
		    
		        ItemCache[itemid][iValue2] --;
		        if(ItemCache[itemid][iValue2] <= 0)
		        {
		            DeleteItem(itemid);
		        }
		        else
		        {
		            SaveItem(itemid, SAVE_ITEM_VALUES);
		        }
		        
		        ApplyAnimation(playerid, "BUDDY", "buddy_fire", 4.0, 0, 0, 0, 0, 0, true);
		        
	        	format(string, sizeof(string), "* %s wykorzystuje przedmiot %s w celu utworzenia przedmiotu %s.", PlayerName(playerid), ItemCache[itemid][iName], ItemCache[joint_itemid][iName]);
				ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		    }
		    case DRUG_COCAINE:
		    {
		        new object_id = GetClosestObjectType(playerid, OBJECT_STOVE);
				if(object_id == INVALID_OBJECT_ID)
				{
				    PlayerCache[playerid][pDrugType] = DRUG_COCAINE;
				    PlayerCache[playerid][pDrugLevel] += ItemCache[itemid][iValue2];
				    
					if(PlayerCache[playerid][pDrugLevel] < 75)
					{
					    SendClientMessage(playerid, COLOR_DO, "** Czujesz pobudzenie, Twoje serce zaczyna bi� coraz mocniej. **");
					    TD_ShowSmallInfo(playerid, 5, "Zazyles ~r~narkotyku~w~, Twoja ~y~sila ~w~zostala czasowo zwiekszona!");
					    
	    				format(string, sizeof(string), "* %s za�ywa %s.", PlayerName(playerid), ItemCache[itemid][iName]);
						ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					}
					
					PlayerCache[playerid][pDepend] += (0.1 * ItemCache[itemid][iValue2]);
					DeleteItem(itemid);
				}
				else
				{
					
				}
		    }
		    case DRUG_HEROIN:
		    {
		    	PlayerCache[playerid][pDrugType] = DRUG_HEROIN;
			    PlayerCache[playerid][pDrugLevel] += ItemCache[itemid][iValue2];
			    
				if(PlayerCache[playerid][pDrugLevel] < 75)
				{
					SendClientMessage(playerid, COLOR_DO, "** Doznajesz lekkich drgawek, straci�e� czucie w d�oniach. **");
    				TD_ShowSmallInfo(playerid, 5, "Zazyles ~r~narkotyku~w~, Twoja ~y~wytrzymalosc ~w~zostala czasowo zwiekszona!");
    				
					format(string, sizeof(string), "* %s za�ywa %s.", PlayerName(playerid), ItemCache[itemid][iName]);
					ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
				}
				
				PlayerCache[playerid][pDepend] += (0.2 * ItemCache[itemid][iValue2]);
				DeleteItem(itemid);
		    }
		    case DRUG_AMPHETAMINE:
		    {
		        // DZIALANIE AMFETAMINY (ZWI�KSZANIE SI�Y + WYTRZYMA�O�CI)
		    }
		    case DRUG_CRACK:
		    {
   				if(PlayerCache[playerid][pHealth] + ItemCache[itemid][iValue2] <= 100)
				{
					new Float:health;

					GetPlayerHealth(playerid, health);
					crp_SetPlayerHealth(playerid, health + ItemCache[itemid][iValue2]);
				}
				else
				{
					crp_SetPlayerHealth(playerid, 100);
				}
				
				format(string, sizeof(string), "* %s za�ywa %s.", PlayerName(playerid), ItemCache[itemid][iName]);
				ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		    
		        PlayerCache[playerid][pDepend] += (0.1 * ItemCache[itemid][iValue2]);
		        DeleteItem(itemid);
		    }
		    case DRUG_CONDITIONER:
		    {
		        if(PlayerCache[playerid][pDrugType] == DRUG_CONDITIONER)
		        {
		            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Za�y�e� ju� jednej od�ywki, aby u�y� nast�pnej poprzednia musi przesta� dzia�a�.");
		            return 1;
		        }
		    
		        PlayerCache[playerid][pDrugType] = DRUG_CONDITIONER;
		        PlayerCache[playerid][pDrugValue1] += ItemCache[itemid][iValue2];
		        
          		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Za�y�e� od�ywki wspomagaj�cej wzrost si�y.\nPodczas treningu Twoja si�a powinna wzrasta� troch� szybciej ni� zwykle.\n\nJest to czasowe dzia�anie, dlatego zaleca si� bra� od�ywki przed samym treningiem.");

				format(string, sizeof(string), "* %s za�ywa %s.", PlayerName(playerid), ItemCache[itemid][iName]);
				ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			
				DeleteItem(itemid);
		    }
		}
		
		if(PlayerCache[playerid][pDrugLevel] >= 75)
		{
			PlayerCache[playerid][pBW] = 10 * 60;

			PlayerCache[playerid][pInteriorID] = GetPlayerInterior(playerid);
			PlayerCache[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);

			GetPlayerPos(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]);

			SetPlayerCameraPos(playerid, PlayerCache[playerid][pPosX] + 3, PlayerCache[playerid][pPosY] + 4, PlayerCache[playerid][pPosZ] + 7);
			SetPlayerCameraLookAt(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ], CAMERA_CUT);

			OnPlayerFreeze(playerid, true, 0);
			OnPlayerSave(playerid, SAVE_PLAYER_POS);

			TD_ShowSmallInfo(playerid, 5, "Przesadziles z ~r~uzywkami~w~, straciles przytomnosc.");

			format(string, sizeof(string), "* %s za�ywa %s a nast�pnie upada na ziemie i traci przytomno��.", PlayerName(playerid), ItemCache[itemid][iName]);
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		}
	    return 1;
	}
	
	if(item_type == ITEM_JOINT)
	{
		if(PlayerCache[playerid][pDrugType] != DRUG_NONE && PlayerCache[playerid][pDrugType] != DRUG_MARIHUANA)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Jeste� teraz pod wp�ywem innego narkotyku, u�ycie nast�pnego grozi �mierci�!");
		    return 0;
		}
 		PlayerCache[playerid][pDrugType] = DRUG_MARIHUANA;
	    PlayerCache[playerid][pDrugValue1] = 10 * ItemCache[itemid][iValue2];
	
	    DeleteItem(itemid);
	    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
	    
	    TD_ShowSmallInfo(playerid, 7, "Odpaliles jointa, ~r~wciskaj ~w~rytmicznie klawisz ~y~~k~~PED_FIREWEAPON~~w~, by zazywac narkotyku.~n~~n~Po jakims czasie powinienes ~p~odczuwac ~w~efekty jego zazywania.");
	    return 1;
	}
	
	if(item_type == ITEM_GLOVES)
	{
		if(PlayerCache[playerid][pGlove] && !ItemCache[itemid][iUsed])
	 	{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Obecnie masz ju� za�o�one jakie� r�kawiczki.");
   			return 0;
   		}
	    if(!ItemCache[itemid][iUsed])
	    {
	        ItemCache[itemid][iUsed] = true;
	        PlayerCache[playerid][pGlove] = true;
	        
  			format(string, sizeof(string), "* %s zak�ada %s na d�onie.", PlayerName(playerid), ItemCache[itemid][iName]);
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	    }
	    else
	    {
	        ItemCache[itemid][iUsed] = false;
			PlayerCache[playerid][pGlove] = false;
	    
   			format(string, sizeof(string), "* %s zdejmuje %s z d�oni.", PlayerName(playerid), ItemCache[itemid][iName]);
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	    }
	    return 1;
	}
	
	if(item_type == ITEM_CORPSE)
	{
		if(!PlayerCache[playerid][pDutyGroup])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby u�y� tego przedmiotu, musisz by� na s�u�bie grupy.");
		    return 0;
		}
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_POLICE && GroupData[group_id][gType] != G_TYPE_MEDICAL && GroupData[group_id][gType] != G_TYPE_FBI)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiedniego do�wiadczenia, by m�c zidentyfikowa� zw�oki.");
		    return 0;
		}
		new corpse_uid = ItemCache[itemid][iValue1],
		    data[128], corpse_death, corpse_owner, corpse_killer, corpse_weapon, corpse_date;

		mysql_query_format("SELECT `corpse_death`, `corpse_owner`, `corpse_killer`, `corpse_weapon`, `corpse_date` FROM `"SQL_PREF"corpses` WHERE corpse_uid = '%d' LIMIT 1", corpse_uid);

		mysql_store_result();
		if(mysql_fetch_row_format(data, "|"))
		{
		    sscanf(data, "p<|>ddddd", corpse_death, corpse_owner, corpse_killer, corpse_weapon, corpse_date);
		}
		mysql_free_result();

		switch(GroupData[group_id][gType])
		{
		    case G_TYPE_POLICE, G_TYPE_FBI:
		    {
		        if(corpse_killer)
		        {
					ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Zbieraj�c dowody z cia�a oraz jego otoczenia jeste� w stanie wyj�� DNA zab�jcy: %s.", CharCode(corpse_killer));
				}
				else
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Zab�jcy uda�o si� idealnie zatrze� dowody zbrodni.");
				}
		    }
		    case G_TYPE_MEDICAL:
		    {
		        if(strfind(ItemCache[itemid][iName], "(niezidentyfikowane)", true) != -1)
		        {
  				    new item_name[32];
					format(item_name, sizeof(item_name), "Zwloki (DNA: %s)", CharCode(corpse_owner));
					
					strmid(ItemCache[itemid][iName], item_name, 0, strlen(item_name), 32);
					SaveItem(itemid, SAVE_ITEM_NAME);

					ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Jako medyk, by�e� w stanie zidentyfikowa� zw�oki.\nZw�oki zosta�y pomy�lnie zidentyfikowane (DNA: %s).", CharCode(corpse_owner));
		        }
		        else
				{
  					new corpse_desc[512], time_string[64];
  					
			   		//mtime_UnixToDate(time_string, sizeof(time_string), corpse_date);
					format(corpse_desc, sizeof(corpse_desc), "Dok�adna data zgonu %s.\nPrzyczyna �mierci: %s", time_string, DeathTypeData[corpse_death][0]);

					if(corpse_weapon)
					{
						mysql_query_format("SELECT `item_value1` FROM `"SQL_PREF"items` WHERE item_uid = '%d' LIMIT 1", corpse_weapon);
						mysql_store_result();
						
						new weapon_id = cache_get_row_int(0, 0);
						mysql_free_result();

  						new weapon_type = GetWeaponType(weapon_id), weapon_name[24];
		    			GetWeaponName(weapon_id, weapon_name, 24);

						switch(weapon_type)
						{
							case WEAPON_TYPE_LIGHT:
					        {
								format(corpse_desc, sizeof(corpse_desc), "%s\n\nWida� wyra�nie, �e cia�o zosta�o zranione za pomoc� broni lekkiej.\nBadaj�c �uski znajduj�ce si� przy ciele martwego, poznajesz bro� zab�jcy.", corpse_desc);
							}
					        case WEAPON_TYPE_MELEE:
					        {
					            format(corpse_desc, sizeof(corpse_desc), "%s\n\nWida� wyra�nie, �e cia�o zosta�o zranione za pomoc� broni bia�ej.\nS�dz�c po og�lnych obra�eniach, mo�esz pozna� szczeg�y narz�dzia zbrodni.", corpse_desc);
					        }
					        case WEAPON_TYPE_HEAVY:
					        {
					            format(corpse_desc, sizeof(corpse_desc), "%s\n\nOfiara musia�a zosta� raniona za pomoc� broni ci�kiej.\nBadaj�c �uski znajduj�ce si� przy ciele martwego, poznajesz bro� zab�jcy.", corpse_desc);
		  			        }
						}

						format(corpse_desc, sizeof(corpse_desc), "%s\n\nModel: %d\nNazwa: %s\nNr. identyfikacyjny: %d", corpse_desc, weapon_id, weapon_name, corpse_weapon);
					}
					else
					{
						format(corpse_desc, sizeof(corpse_desc), "%s\n\nObra�enia nie wskazuj� na �aden przyrz�d oraz bro�.", corpse_desc);
					}
					
					ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Badanie zw�ok", corpse_desc, "OK", "");
		        }
		    }
		}
	    return 1;
	}
	
	if(item_type == ITEM_MOLOTOV)
	{
		new doorid = GetPlayerDoorID(playerid);
		if(doorid == INVALID_DOOR_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby m�c u�y� tego przedmiotu, musisz znajdowa� si� w budynku.");
		    return 0;
		}
		if(DoorCache[doorid][dFireData][FIRE_TIME])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten budynek ju� p�onie!");
		    return 0;
		}
	   	new firefighter_count, group_id;
	    foreach(new i : Player)
	    {
     		if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
       		{
         		if(PlayerCache[i][pDutyGroup])
           		{
           		    group_id = GetPlayerGroupID(i, PlayerCache[i][pDutyGroup]);
             		if(GroupData[group_id][gType] == G_TYPE_FIREDEPT)
               		{
                 		firefighter_count ++;
                   		if(firefighter_count >= 5)
	                    {
							break;
        				}
            		}
          		}
       		}
	    }
	    if(firefighter_count < 5)
	    {
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mozesz u�y� tego przedmiotu teraz.");
   			return 1;
 		}
		new Float:PosX, Float:PosY, Float:PosZ;
		GetPlayerPos(playerid, PosX, PosY, PosZ);

		DoorCache[doorid][dFireData][FIRE_OBJECT] = CreateDynamicObject(18690, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ] - 2.0, 0.0, 0.0, 0.0, DoorCache[doorid][dEnterVW], DoorCache[doorid][dEnterInt], -1, MAX_DRAW_DISTANCE);
		DoorCache[doorid][dFireData][FIRE_LABEL] = _:CreateDynamic3DTextLabel("Ten budynek stan�� w p�omieniach!\nSzacowane zniszczenia: 0%", 0x33AA33FF, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ] + 0.3, 15.0);

		foreach(new i : Player)
		{
  			if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
   			{
     			if(GetPlayerDoorID(i) == doorid)
        		{
          			SendClientMessage(i, COLOR_DO, "** W tym budynku z niewiadomych przyczyn wybucha po�ar. Wszyscy powinni zacz�� si� ewakuowa�. **");
		        }
		    }
		}
		GetXYInFrontOfPlayer(playerid, PosX, PosY, 8.0);
		CreateExplosion(PosX, PosY, PosZ, 12, 5.0);

		DoorCache[doorid][dFireData][FIRE_TIME] = 1;
		DeleteItem(itemid);
	    return 1;
	}
	
	if(item_type == ITEM_BOOMBOX)
	{
	    if(!ItemCache[itemid][iValue1])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W tym odtwarzaczu nie ma �adnej p�yty.");
	        return 0;
	    }
   		if(IsPlayerInAnyVehicle(playerid))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz siedzie� w poje�dzie.");
		    return 0;
		}
		if(PlayerCache[playerid][pItemBoombox] != INVALID_ITEM_ID)
		{
			if(PlayerCache[playerid][pItemBoombox] != itemid)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Korzystasz ju� z jakiego� odtwarzacza.");
			    return 0;
			}
		}
	    new areaid = GetPlayerAreaID(playerid);
	    if(areaid == INVALID_AREA_ID)
	    {
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby m�c u�y� tego przedmiotu, musisz znajdowa� si� w strefie.");
       		return 0;
	    }
	    if(AreaCache[areaid][aOwnerType] == OWNER_PLAYER)
	    {
     		if(AreaCache[areaid][aOwner] != PlayerCache[playerid][pUID])
       		{
         		ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tej strefy.");
           		return 0;
	        }
	    }
	    if(AreaCache[areaid][aOwnerType] == OWNER_GROUP)
	    {
     		if(!IsPlayerInGroup(playerid, AreaCache[areaid][aOwner]))
       		{
         		ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tej strefy.");
           		return 0;
	        }
	    }
   		if(ItemCache[itemid][iUsed])
		{
  			areaid = PlayerCache[playerid][pCurrentArea];
       		foreach(new i : Player)
			{
				if(i != playerid)
    			{
					if(GetPlayerAreaID(i) == areaid)
					{
		   				Audio_Stop(i, PlayerCache[playerid][pAudioHandle]);
					    PlayerCache[i][pAudioHandle] = 0;
					}
				}
			}
			strmid(AreaCache[areaid][aAudioURL], "", 0, 0, 64);
			StopStreamedAudioForPlayer(playerid);

			PlayerCache[playerid][pItemBoombox] = INVALID_ITEM_ID;
			ItemCache[itemid][iUsed] = false;

			RemovePlayerAttachedObject(playerid, SLOT_BOOMBOX);
			TD_ShowSmallInfo(playerid, 3, "Odtwarzanie muzyki zostalo ~r~zakonczone~w~.");
		}
		else
		{
  			if(strlen(AreaCache[areaid][aAudioURL]))
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Kto� obecnie korzysta z boomboxa w tej strefie.");
		        return 0;
		    }
			StopStreamedAudioForPlayer(playerid);

			PlayerCache[playerid][pItemBoombox] = itemid;
			ItemCache[itemid][iUsed] = true;

   			new data[128], audio_url[128];
			mysql_query_format("SELECT `audio_url` FROM `"SQL_PREF"audiourls` WHERE audio_uid = '%d' LIMIT 1", ItemCache[itemid][iValue1]);

			mysql_store_result();
			if(mysql_fetch_row_format(data, "|"))
			{
   				sscanf(data, "p<|>s[128]", audio_url);
   				foreach(new i : Player)
   				{
   				    if(i != playerid)
   				    {
   				        if(PlayerCache[i][pCurrentArea] == PlayerCache[playerid][pCurrentArea])
   				        {
   				            PlayerCache[i][pAudioHandle] = Audio_PlayStreamed(i, audio_url);
   				        }
   				    }
   				}
   				
       			PlayStreamedAudioForPlayer(playerid, audio_url);
   				strmid(AreaCache[areaid][aAudioURL], audio_url, 0, strlen(audio_url), 64);
			}
			mysql_free_result();
			
			TD_ShowSmallInfo(playerid, 3, "Odtwarzanie muzyki zostalo ~g~rozpoczete~w~.");
			SetPlayerAttachedObject(playerid, SLOT_BOOMBOX, 2226, 5, 0.369999, 0.000000, 0.024000, 0.000000, -100.100021, 36.100002, 0.849999, 0.721000, 0.902000);
		}
	    return 1;
	}
	
	if(item_type == ITEM_FLASHLIGHT)
	{
	    if(ItemCache[itemid][iUsed])
	    {
	        PlayerCache[playerid][pFlashLight] = false;
	        RemovePlayerAttachedObject(playerid, SLOT_FLASHLIGHT);
	        
	        RemovePlayerAttachedObject(playerid, 0);
	        ItemCache[itemid][iUsed] = false;
	    }
	    else
	    {
	        PlayerCache[playerid][pFlashLight] = true;
	        SetPlayerAttachedObject(playerid, SLOT_FLASHLIGHT, 18641, 6, 0.092000, 0.020000, -0.062999, 0.099999, -10.700075, 0.299999);

	        SetPlayerAttachedObject(playerid, 0, 18656, 6, 0.107000, -0.009000, -0.117999, -90.900054, -3.299999, -6.399999, 0.034000, 0.024999, 0.035000);
            ItemCache[itemid][iUsed] = true;
		}
	    return 1;
	}
	return 1;
}

public OnPlayerDropItem(playerid, itemid)
{
	new string[256];
	if(ItemCache[itemid][iUsed])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz od�o�y� tego przedmiotu.");
	    return 1;
	}
	
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    new Float:PosX, Float:PosY, Float:PosZ, Float:PosA,
	        virtual_world = GetPlayerVirtualWorld(playerid), interior_id = GetPlayerInterior(playerid);
	        
		GetPlayerPos(playerid, PosX, PosY, PosZ);
		GetPlayerFacingAngle(playerid, PosA);
		
		format(string, sizeof(string), "* %s odk�ada przedmiot na ziemi�.", PlayerName(playerid));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
		mysql_query_format("UPDATE `"SQL_PREF"items` SET item_place = '%d', item_posx = '%f', item_posy = '%f', item_posz = '%f', item_interior = '%d', item_world = '%d' WHERE item_uid = '%d' LIMIT 1", PLACE_NONE, PosX, PosY, PosZ, interior_id, virtual_world, ItemCache[itemid][iUID]);

		new object_id, item_type = ItemCache[itemid][iType];
		if(item_type == ITEM_WEAPON || item_type == ITEM_PAINT || item_type == ITEM_INHIBITOR)
		{
		    object_id = CreateDynamicObject(WeaponInfoData[ItemCache[itemid][iValue1]][wModel], PosX, PosY, PosZ - 1.0, 80.0, 0.0, -PosA, virtual_world, -1, -1, MAX_DRAW_DISTANCE);
		}
		else if(ItemCache[itemid][iType] == ITEM_TUNING)
		{
  			object_id = CreateDynamicObject(ItemCache[itemid][iValue1], PosX + random(2), PosY + random(2), PosZ - 0.5, 0.0, 0.0, -PosA, virtual_world, -1, -1, MAX_DRAW_DISTANCE);
		}
		else
		{
		    object_id = CreateDynamicObject(ItemTypeInfo[item_type][iTypeObjModel], PosX, PosY, PosZ - 1.0, ItemTypeInfo[item_type][iTypeObjRotX], ItemTypeInfo[item_type][iTypeObjRotY], -PosA, virtual_world, -1, -1, MAX_DRAW_DISTANCE);
		}
		
		Streamer_SetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID, (ItemCache[itemid][iUID] * -1));
		
		Streamer_Update(playerid);
		printf("[item] %s (UID: %d, GID: %d) od�o�y� przedmiot %s (UID: %d) na ziemi� (PosX: %.3f, PosY: %.3f, PosZ: %.3f, InteriorID: %d, WorldID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], ItemCache[itemid][iName], ItemCache[itemid][iUID], PosX, PosY, PosZ, interior_id, virtual_world);
		
		ClearItemCache(itemid);
		return 1;
	}
	
	if(IsPlayerInAnyVehicle(playerid))
	{
	    new vehid = GetPlayerVehicleID(playerid);
	    mysql_query_format("UPDATE `"SQL_PREF"items` SET item_place = '%d', item_owner = '%d' WHERE item_uid = '%d' LIMIT 1", PLACE_VEHICLE, CarInfo[vehid][cUID], ItemCache[itemid][iUID]);
	    
   		format(string, sizeof(string), "* %s odk�ada przedmiot w poje�dzie.", PlayerName(playerid));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
		
		printf("[item] %s (UID: %d, GID: %d) od�o�y� przedmiot %s (UID: %d) w poje�dzie (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], ItemCache[itemid][iName], ItemCache[itemid][iUID], CarInfo[vehid][cUID]);
		ClearItemCache(itemid);
	    return 1;
	}
	return 1;
}

public OnPlayerRaiseItem(playerid, item_uid)
{
	if(PlayerCache[playerid][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz teraz tego zrobi�.");
		return 1;
	}

	if(!(PlayerCache[playerid][pAdmin] & A_PERM_ITEMS) && GetPlayerCapacity(playerid) <= 0)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Twoja posta� nie jest w stanie unie�� wi�cej przedmiot�w.");
	    return 1;
	}

	new string[256], data[12],
	    item_place;
	    
	mysql_query_format("SELECT `item_place` FROM `"SQL_PREF"items` WHERE item_uid = '%d' LIMIT 1", item_uid);
	
	mysql_store_result();
	if(mysql_fetch_row_format(data, "|"))
	{
	    sscanf(data, "p<|>d", item_place);
	}
	mysql_free_result();

	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && item_place != PLACE_NONE)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tego przedmiotu nie ma w pobli�u.");
		return 1;
	}
	
	if(IsPlayerInAnyVehicle(playerid) && item_place != PLACE_VEHICLE)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tego przedmiotu nie ma w tym poje�dzie.");
	    return 1;
	}
	
	mysql_query_format("UPDATE `"SQL_PREF"items` SET item_place = '%d', item_owner = '%d' WHERE item_uid = '%d' LIMIT 1", PLACE_PLAYER, PlayerCache[playerid][pUID], item_uid);
	if(item_place == PLACE_NONE)
	{
 		new count_objects = Streamer_CountVisibleItems(playerid, STREAMER_TYPE_OBJECT), object_id, object_extra_id = (item_uid * -1);
		for (new player_object = 0; player_object <= count_objects; player_object++)
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
	new itemid = LoadItemCache(item_uid);

	format(string, sizeof(string), "* %s podnosi przedmiot %s.", PlayerName(playerid), ItemCache[itemid][iName]);
	ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
	printf("[item] %s (UID: %d, GID: %d) podni�s� przedmiot %s (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], ItemCache[itemid][iName], ItemCache[itemid][iUID]);
	return 1;
}

public LoadPlayerItems(playerid)
{
	new data[128], itemid;
	mysql_query_format("SELECT `item_uid`, `item_name`, `item_value1`, `item_value2`, `item_type`, `item_place`, `item_owner`, `item_group`, `item_used` FROM `"SQL_PREF"items` WHERE item_place = '%d' AND item_owner = '%d'", PLACE_PLAYER, PlayerCache[playerid][pUID]);

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
		itemid = Iter_Free(Item);

		sscanf(data, "p<|>ds[32]ddddddd",
		ItemCache[itemid][iUID],
		ItemCache[itemid][iName],
		
		ItemCache[itemid][iValue1],
		ItemCache[itemid][iValue2],
		
		ItemCache[itemid][iType],
		
		ItemCache[itemid][iPlace],
		ItemCache[itemid][iOwner],

		ItemCache[itemid][iGroup],
		ItemCache[itemid][iUsed]);
		
		// Je�li w u�yciu
		if(ItemCache[itemid][iUsed])
		{
			// Telefon
			if(ItemCache[itemid][iType] == ITEM_PHONE)
			{
			    PlayerCache[playerid][pPhoneNumber] = ItemCache[itemid][iValue1];
			}
			
			// Rolki
			if(ItemCache[itemid][iType] == ITEM_ROLL)
			{
			    PlayerCache[playerid][pRoll] = true;
			}
		}
		
		Iter_Add(Item, itemid);
	}
	mysql_free_result();
	return 1;
}

public UnloadPlayerItems(playerid)
{
	new item_next;
	foreach(new itemid : Item)
	{
	    if(ItemCache[itemid][iUID])
	    {
	 		if(ItemCache[itemid][iPlace] == PLACE_PLAYER && ItemCache[itemid][iOwner] == PlayerCache[playerid][pUID])
	   		{
	   			ItemCache[itemid][iUID] 	= 0;

				ItemCache[itemid][iValue1] 	= 0;
				ItemCache[itemid][iValue2] 	= 0;

				ItemCache[itemid][iType] 	= 0;

				ItemCache[itemid][iPlace] 	= 0;
				ItemCache[itemid][iOwner] 	= 0;

				ItemCache[itemid][iGroup]   = 0;
				ItemCache[itemid][iUsed] 	= false;

				Iter_SafeRemove(Item, itemid, item_next);
				itemid = item_next;
    		}
		}
	}
	return 1;
}

public CreateArea(Float:AreaMinX, Float:AreaMinY, Float:AreaMaxX, Float:AreaMaxY)
{
	new areaid, area_uid;
	mysql_query_format("INSERT INTO `"SQL_PREF"areas` (area_minx, area_miny, area_maxx, area_maxy) VALUES ('%f', '%f', '%f', '%f')", AreaMinX, AreaMinY, AreaMaxX, AreaMaxY);
	
	area_uid = mysql_insert_id();
	areaid = CreateDynamicRectangle(AreaMinX, AreaMinY, AreaMaxX, AreaMaxY);
	
	AreaCache[areaid][aUID] = area_uid;
	
	AreaCache[areaid][aMinX] = AreaMinX;
	AreaCache[areaid][aMinY] = AreaMinY;
	
	AreaCache[areaid][aMaxX] = AreaMaxX;
	AreaCache[areaid][aMaxY] = AreaMaxY;
	
	AreaCache[areaid][aOwner] = 0;
	AreaCache[areaid][aOwnerType] = OWNER_NONE;
	
	GangZoneCreate(AreaCache[areaid][aMinX], AreaCache[areaid][aMinY], AreaCache[areaid][aMaxX], AreaCache[areaid][aMaxY]);
	Iter_Add(Area, areaid);
	return areaid;
}

public LoadArea(area_uid)
{
	new data[128], areaid = Iter_Free(Area);
	mysql_query_format("SELECT * FROM `"SQL_PREF"areas` WHERE area_uid = '%d' LIMIT 1", area_uid);
	
	mysql_store_result();
	if(mysql_fetch_row_format(data, "|"))
	{
	    sscanf(data, "p<|>dffffdd",
	    AreaCache[areaid][aUID],
	    
	    AreaCache[areaid][aMinX],
	    AreaCache[areaid][aMinY],
	    
	    AreaCache[areaid][aMaxX],
	    AreaCache[areaid][aMaxY],
	    
	    AreaCache[areaid][aOwnerType],
		AreaCache[areaid][aOwner]);
	    
	    CreateDynamicRectangle(AreaCache[areaid][aMinX], AreaCache[areaid][aMinY], AreaCache[areaid][aMaxX], AreaCache[areaid][aMaxY]);
	    GangZoneCreate(AreaCache[areaid][aMinX], AreaCache[areaid][aMinY], AreaCache[areaid][aMaxX], AreaCache[areaid][aMaxY]);
	    
		Iter_Add(Area, areaid);
	}
	mysql_free_result();
	return areaid;
}

public DeleteArea(areaid)
{
	mysql_query_format("DELETE FROM `"SQL_PREF"areas` WHERE area_uid = '%d' LIMIT 1", AreaCache[areaid][aUID]);

	DestroyDynamicArea(areaid);
	GangZoneDestroy(areaid);
	
	Iter_Remove(Area, areaid);
	return 1;
}

public LoadAreas()
{
	new data[128], areaid;
	
	GangZoneCreate(0.0, 0.0, 0.0, 0.0);
	mysql_query(connHandle, "SELECT * FROM `"SQL_PREF"areas`");
	
	print("[load] Rozpoczynam proces wczytywania wszystkich stref...");
	
	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
	    areaid ++;
	
	    sscanf(data, "p<|>dffffdd",
		AreaCache[areaid][aUID],

		AreaCache[areaid][aMinX],
		AreaCache[areaid][aMinY],

		AreaCache[areaid][aMaxX],
		AreaCache[areaid][aMaxY],
		
		AreaCache[areaid][aOwnerType],
		AreaCache[areaid][aOwner]);
	    
	    CreateDynamicRectangle(AreaCache[areaid][aMinX], AreaCache[areaid][aMinY], AreaCache[areaid][aMaxX], AreaCache[areaid][aMaxY]);
	    GangZoneCreate(AreaCache[areaid][aMinX], AreaCache[areaid][aMinY], AreaCache[areaid][aMaxX], AreaCache[areaid][aMaxY]);
	    
		Iter_Add(Area, areaid);
	}
	mysql_free_result();
	
	printf("[load] Proces wczytywania stref zosta� zako�czony (count: %d).", Iter_Count(Area));
	return 1;
}

public SaveArea(areaid)
{
	mysql_query_format("UPDATE `"SQL_PREF"areas` SET area_minx = '%f', area_miny = '%f', area_maxx = '%f', area_maxy = '%f', area_ownertype = '%d', area_owner = '%d' WHERE area_uid = '%d' LIMIT 1",
	AreaCache[areaid][aMinX],
	AreaCache[areaid][aMinY],

	AreaCache[areaid][aMaxX],
	AreaCache[areaid][aMaxY],

	AreaCache[areaid][aOwnerType],
	AreaCache[areaid][aOwner],

	AreaCache[areaid][aUID]);
	return 1;
}

public CreateDoorProduct(doorid, ProductName[], ProductType, ProductValue1, ProductValue2, ProductPrice, ProductCount)
{
	// Sumuj produkt z innymi
	foreach(new product : Product)
	{
	    if(ProductData[product][pUID])
	    {
	        if(ProductData[product][pOwner] == DoorCache[doorid][dUID])
	        {
	            if(ProductData[product][pType] == ProductType && ProductData[product][pPrice] == ProductPrice)
	            {
	                if(!strcmp(ProductData[product][pName], ProductName, true))
	                {
	                    ProductData[product][pCount] += ProductCount;
						SaveProduct(product, SAVE_PRODUCT_VALUES);
	                    return 1;
	                }
	            }
	        }
	    }
	}

    new product_id, product_uid;
	mysql_query_format("INSERT INTO `"SQL_PREF"products` (product_name, product_type, product_value1, product_value2, product_price, product_count, product_owner, product_maxprice) VALUES ('%s', '%d', '%d', '%d', '%d', '%d', '%d', '%d')", ProductName, ProductType, ProductValue1, ProductValue2, ProductPrice, ProductCount, DoorCache[doorid][dOwner], (ProductPrice + floatround(ProductPrice * 0.8)));
	
	product_uid = mysql_insert_id();
	product_id = Iter_Free(Product);
	
	ProductData[product_id][pUID] = product_uid;
	strmid(ProductData[product_id][pName], ProductName, 0, strlen(ProductName), 32);

	ProductData[product_id][pType] = ProductType;

	ProductData[product_id][pValue1] = ProductValue1;
	ProductData[product_id][pValue2] = ProductValue2;

	ProductData[product_id][pPrice] = ProductPrice;

	ProductData[product_id][pCount] = ProductCount;
	ProductData[product_id][pOwner] = DoorCache[doorid][dOwner];
	
	ProductData[product_id][pMaxPrice] = ProductPrice + floatround(ProductPrice * 0.8);
	Iter_Add(Product, product_id);
	
	return product_id;
}

public LoadAllProducts()
{
	new data[128], product_id;
	mysql_query(connHandle, "SELECT * FROM `"SQL_PREF"products`");

	print("[load] Rozpoczynam proces wczytywania produkt�w...");

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
		sscanf(data, "p<|>ds[32]ddddddd",
		ProductData[product_id][pUID],
		
		ProductData[product_id][pName],
		ProductData[product_id][pType],
		
		ProductData[product_id][pValue1],
		ProductData[product_id][pValue2],
		
		ProductData[product_id][pPrice],
		
		ProductData[product_id][pCount],
		ProductData[product_id][pOwner],
		
		ProductData[product_id][pMaxPrice]);
		Iter_Add(Product, product_id);
		
		product_id ++;
	}
	mysql_free_result();
	
	printf("[load] Proces wczytywania produkt�w zosta� zako�czony (count: %d).", Iter_Count(Product));
	return 1;
}

public DeleteProduct(product_id)
{
	mysql_query_format("DELETE FROM `"SQL_PREF"products` WHERE product_uid = '%d' LIMIT 1", ProductData[product_id][pUID]);

	ProductData[product_id][pUID] = 0;
	ProductData[product_id][pType] = 0;

	ProductData[product_id][pValue1] = 0;
	ProductData[product_id][pValue2] = 0;

	ProductData[product_id][pPrice] = 0;
	
	ProductData[product_id][pCount] = 0;
	ProductData[product_id][pOwner] = 0;
	
	Iter_Remove(Product, product_id);
	return 1;
}

public SaveProduct(product_id, what)
{
	new query[256], main_query[256];
	format(main_query, sizeof(main_query), "UPDATE `"SQL_PREF"products` SET");
	
	if(what & SAVE_PRODUCT_THINGS)
	{
	    // Pozosta�e (nazwa, type, owner)
		format(query, sizeof(query), " product_name = '%s', product_type = '%d', product_owner = '%d'",
		ProductData[product_id][pName],
		ProductData[product_id][pType],
		
		ProductData[product_id][pOwner]);

		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	if(what & SAVE_PRODUCT_VALUES)
	{
	    // Warto�ci (warto�� 1, warto�� 2, koszt, ilo��)
	    format(query, sizeof(query), " product_value1 = '%d', product_value2 = '%d', product_price = '%d', product_count = '%d'",
	    ProductData[product_id][pValue1],
	    ProductData[product_id][pValue2],
	    
	    ProductData[product_id][pPrice],
		ProductData[product_id][pCount]);

		if(strlen(main_query) > 32)
		{
		    strcat(main_query, ",", sizeof(main_query));
		}
  		strcat(main_query, query, sizeof(main_query));
	}
	
	format(query, sizeof(query), " WHERE product_uid = '%d' LIMIT 1", ProductData[product_id][pUID]);
	strcat(main_query, query, sizeof(main_query));

	mysql_query(connHandle, main_query);
	return 1;
}

public ListGroupProductsForPlayer(group_id, playerid, list_type)
{
	new data[64], list_products[1024],
        product_uid, product_name[32], product_price, product_count;
        
	mysql_query_format("SELECT `product_uid`, `product_name`, `product_price`, `product_count` FROM `"SQL_PREF"products` WHERE product_owner = '%d'", GroupData[group_id][gUID]);

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
		sscanf(data, "p<|>ds[32]dd", product_uid, product_name, product_price, product_count);
		
		if(list_type == PRODUCT_LIST_PRICE)	format(list_products, sizeof(list_products), "%s\n$%d\t\t%s", list_products, product_price, product_name);
		else								format(list_products, sizeof(list_products), "%s\n%d\tx%d\t$%d\t\t%s", list_products, product_uid, product_count, product_price, product_name);
	}
	mysql_free_result();
	
	if(strlen(list_products))
	{
	    switch(list_type)
	    {
	        case PRODUCT_LIST_NONE:
	        {
	            ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_LIST, "Produkty w magazynie:", list_products, "OK", "");
	        }
	        case PRODUCT_LIST_OFFER:
	        {
	            ShowPlayerDialog(playerid, D_PRODUCT_OFFER, DIALOG_STYLE_LIST, "Oferuj produkt z magazynu:", list_products, "Oferuj", "Anuluj");
	        }
	        case PRODUCT_LIST_BUY:
	        {
	            ShowPlayerDialog(playerid, D_PRODUCT_BUY, DIALOG_STYLE_LIST, "Zakup produkt:", list_products, "Zakup", "Anuluj");
	        }
	        case PRODUCT_LIST_OPTIONS:
	        {
	            ShowPlayerDialog(playerid, D_PRODUCT_SELECT, DIALOG_STYLE_LIST, "Zarz�dzaj produktem:", list_products, "Wybierz", "Anuluj");
	        }
	        case PRODUCT_LIST_PRICE:
	        {
	            ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_LIST, "Cennik:", list_products, "OK", "");
	        }
	    }
	}
	else
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnych produkt�w w magazynie.");
	}
	return 1;
}

public crp_AddObject(ModelID, Float:PosX, Float:PosY, Float:PosZ, Float:RotX, Float:RotY, Float:RotZ, InteriorID, VirtualWorld)
{
	new object_id, object_uid;
	mysql_query_format("INSERT INTO `"SQL_PREF"objects` (`object_model`, `object_posx`, `object_posy`, `object_posz`, `object_rotx`, `object_roty`, `object_rotz`, `object_world`, `object_interior`) VALUES ('%d', '%f', '%f', '%f', '%f', '%f', '%f', '%d', '%d')", ModelID, PosX, PosY, PosZ, RotX, RotY, RotZ, VirtualWorld, InteriorID);

	object_uid = mysql_insert_id();
	object_id = CreateDynamicObject(ModelID, PosX, PosY, PosZ, RotX, RotY, RotZ, VirtualWorld, InteriorID, -1, MAX_DRAW_DISTANCE);

	Streamer_SetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID, object_uid);
	return object_id;
}

public SaveObjectPos(object_id)
{
	new object_uid = GetObjectUID(object_id),
	    Float:PosX, Float:PosY, Float:PosZ,
	    Float:RotX, Float:RotY, Float:RotZ;
	    
	GetDynamicObjectPos(object_id, PosX, PosY, PosZ);
	GetDynamicObjectRot(object_id, RotX, RotY, RotZ);
	
	mysql_query_format("UPDATE `"SQL_PREF"objects` SET object_posx = '%f', object_posy = '%f', object_posz = '%f', object_rotx = '%f', object_roty = '%f', object_rotz = '%f' WHERE object_uid = '%d' LIMIT 1", PosX, PosY, PosZ, RotX, RotY, RotZ, object_uid);
	return 1;
}

public DeleteObject(object_id)
{
	new object_uid = GetObjectUID(object_id);
	mysql_query_format("DELETE FROM `"SQL_PREF"objects` WHERE object_uid = '%d' LIMIT 1", object_uid);
	
	DestroyDynamicObject(object_id);
	return object_uid;
}

public LoadAllObjects()
{
	new data[512], object_id;
	mysql_query(connHandle, "SELECT * FROM `"SQL_PREF"objects`");

	print("[load] Rozpoczynam proces wczytywania wszystkich obiekt�w...");

	new object_uid, object_model,
	    Float:object_pos[3], Float:object_rot[3], Float:object_gate[6],
	    object_world, object_interior, object_material[128];
		
	// Materials
	new index, color1, color2, modelid, txdname[32], texturename[64],
	    matsize, fontsize, bold, alignment, fonttype[12], text[64];

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
     	sscanf(data, "p<|>ddffffffddffffff{d}s[128]", object_uid, object_model, object_pos[0], object_pos[1], object_pos[2], object_rot[0], object_rot[1], object_rot[2], object_world, object_interior, object_gate[0], object_gate[1], object_gate[2], object_gate[3], object_gate[4], object_gate[5], object_material);
		object_id = CreateDynamicObject(object_model, object_pos[0], object_pos[1], object_pos[2], object_rot[0], object_rot[1], object_rot[2], object_world, object_interior, -1, MAX_DRAW_DISTANCE);

		if(!isnull(object_material))
		{
		    if(strval(object_material[0]) == 0)
		    {
				sscanf(object_material, "{d}dxds[32]s[64]", index, color1, modelid, txdname, texturename);
				SetDynamicObjectMaterial(object_id, index, modelid, txdname, texturename, color1);
			}
		    
		    if(strval(object_material[0]) == 1)
		    {
		        sscanf(object_material, "{d}ddddxxds[12]s[64]", index, matsize, fontsize, bold, color1, color2, alignment, fonttype, text);
		        SetDynamicObjectMaterialText(object_id, index, text, matsize, fonttype, fontsize, bold, color1, color2, alignment);

			  }
		    object_material = "";
		}
		Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_X, object_gate[0]);
		Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_Y, object_gate[1]);
		Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_Z, object_gate[2]);
		
		Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RX, object_gate[3]);
		Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RY, object_gate[4]);
		Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RZ, object_gate[5]);
		
		Streamer_SetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID, object_uid);
	}
  	mysql_free_result();
  	
  	printf("[load] Proces wczytywania obiekt�w zosta� zako�czony (count: %d).", Streamer_GetUpperBound(STREAMER_TYPE_OBJECT));
	return 1;
}

public Add3DTextLabel(LabelDesc[128], LabelColor, Float:LabelPosX, Float:LabelPosY, Float:LabelPosZ, Float:LabelDrawDistance, LabelWorld, LabelInteriorID)
{
	new Text3D:label_id, label_uid, label_desc[256];
	mysql_real_escape_string(LabelDesc, label_desc);

	mysql_query_format("INSERT INTO `"SQL_PREF"3dlabels` (`label_desc`, `label_color`, `label_posx`, `label_posy`, `label_posz`, `label_drawdist`, `label_world`, `label_interior`) VALUES ('%s', '%d', '%f', '%f', '%f', '%f', '%d', '%d')", label_desc, LabelColor, LabelPosX, LabelPosY, LabelPosZ, LabelDrawDistance, LabelWorld, LabelInteriorID);
	label_uid = mysql_insert_id();

	label_id = CreateDynamic3DTextLabel(WordWrap(LabelDesc, WRAP_MANUAL), LabelColor, LabelPosX, LabelPosY, LabelPosZ, LabelDrawDistance, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, LabelWorld, LabelInteriorID, -1, 80.0);
	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_EXTRA_ID, label_uid);

	return _:label_id;
}

public Load3DTextLabels()
{
	new data[512];
	mysql_query(connHandle, "SELECT * FROM `"SQL_PREF"3dlabels`");

	new Text3D:label_id, label_uid, label_desc[128], label_color,
		Float:label_posx, Float:label_posy, Float:label_posz,
	    Float:label_drawdist, label_interior, label_world;

    print("[load] Rozpoczynam proces wczytywania wszystkich 3D tekst�w...");

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
	    sscanf(data, "p<|>ds[128]dffffdd", label_uid, label_desc, label_color, label_posx, label_posy, label_posz, label_drawdist, label_world, label_interior);
  		label_id = CreateDynamic3DTextLabel(WordWrap(label_desc, WRAP_MANUAL), label_color, label_posx, label_posy, label_posz, label_drawdist, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, label_world, label_interior, -1, 100.0);

        Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_EXTRA_ID, label_uid);
	}
	mysql_free_result();
	
	printf("[load] Proces wczytywania 3D tekst�w zosta� zako�czony (count: %d).", CountDynamic3DTextLabels());
	return 1;
}

public Destroy3DTextLabel(label_id)
{
	new label_uid = GetLabelUID(label_id);
	mysql_query_format("DELETE FROM `"SQL_PREF"3dlabels` WHERE label_uid = '%d' LIMIT 1", label_uid);

	DestroyDynamic3DTextLabel(Text3D:label_id);
	return 1;
}

public Save3DTextLabel(label_id)
{
	new label_uid = GetLabelUID(label_id),
	    Float:PosX, Float:PosY, Float:PosZ;

	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_X, PosX);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_Y, PosY);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_Z, PosZ);

	mysql_query_format("UPDATE `"SQL_PREF"3dlabels` SET label_posx = '%f', label_posy = '%f', label_posz = '%f' WHERE label_uid = '%d' LIMIT 1", PosX, PosY, PosZ, label_uid);
	return 1;
}

public LoadPlayerAccess(playerid)
{
	new data[256], access_model, access_bone, slot_index,
 		Float:access_posx, Float:access_posy, Float:access_posz,
  		Float:access_rotx, Float:access_roty, Float:access_rotz,
   		Float:access_scalex, Float:access_scaley, Float:access_scalez;

	mysql_query_format("SELECT `access_model`, `access_bone`, `access_posx`, `access_posy`, `access_posz`, `access_rotx`, `access_roty`, `access_rotz`, `access_scalex`, `access_scaley`, `access_scalez` FROM `"SQL_PREF"items`, `"SQL_PREF"access` WHERE (item_place = '%d' AND item_owner = '%d' AND item_type = '%d' AND item_used = '1') AND (access_uid = item_value1 OR access_uid = item_value2)", PLACE_PLAYER, PlayerCache[playerid][pUID], ITEM_CLOTH_ACCESS);

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
	    slot_index = GetPlayerFreeSlotAccess(playerid);
	    
		sscanf(data, "p<|>ddfffffffff", access_model, access_bone, access_posx, access_posy, access_posz, access_rotx, access_roty, access_rotz, access_scalex, access_scaley, access_scalez);
		SetPlayerAttachedObject(playerid, slot_index, access_model, access_bone, access_posx, access_posy, access_posz, access_rotx, access_roty, access_rotz, access_scalex, access_scaley, access_scalez);
 	}
	mysql_free_result();
	return 1;
}

public LoadAllAccess()
{
	new data[256], access_id;
	mysql_query_format("SELECT * FROM `"SQL_PREF"access` WHERE access_owner = '%d'", OWNER_NONE);
	
	print("[load] Rozpoczynam proces wczytywania akcesorii...");
	
	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
	    sscanf(data, "p<|>dds[32]dfffffffffd",
	    AccessData[access_id][aUID],
	    AccessData[access_id][aModel],
	    
	    AccessData[access_id][aName],
	    AccessData[access_id][aBone],
	    
	    AccessData[access_id][aPosX],
	    AccessData[access_id][aPosY],
	    AccessData[access_id][aPosZ],
	    
	    AccessData[access_id][aRotX],
	    AccessData[access_id][aRotY],
	    AccessData[access_id][aRotZ],

		AccessData[access_id][aScaleX],
		AccessData[access_id][aScaleY],
		AccessData[access_id][aScaleZ],

		AccessData[access_id][aPrice]);
	    
	    Iter_Add(Access, access_id);
	    access_id ++;
	}
	mysql_free_result();
	
	printf("[load] Proces wczytywania akcesori�w zosta� zako�czony (count: %d).", Iter_Count(Access));
	return 1;
}

public LoadAllSkins()
{
	new data[64], skin_id;
	mysql_query_format("SELECT `skin_id`, `skin_name`, `skin_price` FROM `"SQL_PREF"skins` WHERE skin_group = '0' AND skin_extraid = '0'");
	
	print("[load] Rozpoczynam proces wczytywania skin�w...");
	
	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
	    sscanf(data, "p<|>ds[32]d",
	    SkinData[skin_id][sModel],
	    
	    SkinData[skin_id][sName],
	    SkinData[skin_id][sPrice]);
	    
	    Iter_Add(Skin, skin_id);
	    skin_id ++;
	}
	mysql_free_result();
	
	printf("[load] Proces wczytywania skin�w zosta� zako�czony (count: %d).", Iter_Count(Skin));
	return 1;
}

public LoadAllAnims()
{
	new data[128], anim_id;
	mysql_query(connHandle, "SELECT * FROM `"SQL_PREF"anim` ORDER BY `anim_command` ASC");

	print("[load] Rozpoczynam proces wczytywania animacji...");

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
		sscanf(data, "p<|>ds[12]s[16]s[24]fdddddd",
		AnimCache[anim_id][aUID],
		
		AnimCache[anim_id][aCommand],
		AnimCache[anim_id][aLib],
		AnimCache[anim_id][aName],
		
		AnimCache[anim_id][aSpeed],
		
		AnimCache[anim_id][aOpt1],
		AnimCache[anim_id][aOpt2],
		AnimCache[anim_id][aOpt3],
		AnimCache[anim_id][aOpt4],
		AnimCache[anim_id][aOpt5],
		
		AnimCache[anim_id][aAction]);

		Iter_Add(Anim, anim_id);
  		anim_id ++;
	}
	mysql_free_result();

	printf("[load] Proces wczytywania skin�w zosta� zako�czony (count: %d).", Iter_Count(Anim));
	return 1;
}

public LoadAllCorpses()
{
	new data[256], item_uid, object_id,
		Float:PosX, Float:PosY, Float:PosZ, InteriorID, VirtualWorldID;
		
	mysql_query_format("SELECT `item_uid`, `item_posx`, `item_posy`, `item_posz`, `item_interior`, `item_world` FROM `"SQL_PREF"items`, `"SQL_PREF"corpses` WHERE item_type = '%d' AND item_place = '%d' AND corpse_uid = item_value1 AND corpse_date + (7 * 86000) >= '%d'", ITEM_CORPSE, PLACE_NONE, gettime());

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
	    sscanf(data, "p<|>dfffdd", item_uid, PosX, PosY, PosZ, InteriorID, VirtualWorldID);
    	object_id = CreateDynamicObject(ItemTypeInfo[ITEM_CORPSE][iTypeObjModel], PosX, PosY, PosZ - 1.0, ItemTypeInfo[ITEM_CORPSE][iTypeObjRotX], ItemTypeInfo[ITEM_CORPSE][iTypeObjRotY], 180.0, VirtualWorldID, InteriorID, -1, MAX_DRAW_DISTANCE);

		Streamer_SetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID, item_uid * -1);
	}
	mysql_free_result();
	return 1;
}

public OnPlayerSendOffer(playerid, customerid, OfferName[], OfferType, OfferValue1, OfferValue2, OfferPrice)
{
	if(OfferData[playerid][oCustomerID] != INVALID_PLAYER_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wys�a� kilku ofert jednocze�nie.");
	    return 1;
	}
	
	switch(OfferType)
	{
	    case OFFER_ITEM, OFFER_VEHICLE, OFFER_DOOR, OFFER_TOWING, OFFER_PAINT, OFFER_MONTAGE, OFFER_BUSINESS, OFFER_REGISTER, OFFER_PASS, OFFER_SALON:
	    {
   			if(PlayerCache[customerid][pHours] < 5)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz tego zaoferowa� temu graczowi, dop�ki ten nie przegra 5h.");
			    return 1;
			}
			if(PlayerCache[playerid][pHours] < 5)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz nic oferowa�, dop�ki nie przegrasz wi�cej ni� 5h w grze.");
			    return 1;
			}
	    }
	}
	
	new offer_desc[256];
	
	format(offer_desc, sizeof(offer_desc), "~y~~h~Oferta od %s ~>~ %s~n~~n~~b~~h~~h~Nazwa: ~w~%s~n~~g~~h~Koszt: ~w~$%d", PlayerName(playerid), OfferTypeInfo[OfferType][oTypeName], OfferName, OfferPrice);
	PlayerTextDrawSetString(customerid, TextDrawOfferDesc[customerid], offer_desc);
	
	TextDrawShowForPlayer(customerid, TextDrawOfferAccept);
	TextDrawShowForPlayer(customerid, TextDrawOfferReject);

	TextDrawShowForPlayer(customerid, TextDrawOfferBack);
	PlayerTextDrawShow(customerid, TextDrawOfferDesc[customerid]);
	
	SelectTextDraw(customerid, COLOR_GREEN);
	
	OfferData[playerid][oCustomerID] = customerid;
	OfferData[playerid][oType] = OfferType;
	
	strmid(OfferData[playerid][oName], OfferName, 0, strlen(OfferName), 32);
	
	OfferData[playerid][oValue1] = OfferValue1;
	OfferData[playerid][oValue2] = OfferValue2;
	
	OfferData[playerid][oPrice] = OfferPrice;
	OfferData[playerid][oPayType] = PAY_TYPE_NONE;
	
	if(OfferType == OFFER_PASSAGE)
	{
	    OfferData[playerid][oPayType] = PAY_TYPE_CASH;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "Oferta zosta�a wys�ana. Odczekaj chwil�, by przekona� si�, czy gracz zaakceptuje Twoj� ofert�.");
	printf("[offe] %s (UID: %d, GID: %d) wys�a� ofert� dla %s (UID: %d, GID: %d). Typ oferty: %s, nazwa: %s, warto�ci: %d/%d, cena: $%d", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], PlayerRealName(customerid), PlayerCache[customerid][pUID], PlayerCache[customerid][pGID], OfferTypeInfo[OfferType][oTypeName], OfferName, OfferValue1, OfferValue2, OfferPrice);
	return 1;
}

public OnPlayerAcceptOffer(playerid, offererid)
{
	if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	{
	    if(OfferData[offererid][oPrice] > PlayerCache[playerid][pCash])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz takiej ilo�ci got�wki.");
	        OnPlayerRejectOffer(playerid, offererid);
	        return 1;
	    }
	}
	
	if(OfferData[offererid][oPayType] == PAY_TYPE_CARD)
	{
	    if(OfferData[offererid][oPrice] > PlayerCache[playerid][pBankCash])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz takiej sumy pieni�nej w banku.");
	        OnPlayerRejectOffer(playerid, offererid);
	        return 1;
	    }
	}
	
	new string[256],
		offer_type = OfferData[offererid][oType], offer_price = OfferData[offererid][oPrice];
	
	if(offer_type == OFFER_ITEM)
	{
		if(!(PlayerCache[playerid][pAdmin] & A_PERM_ITEMS) && GetPlayerCapacity(playerid) <= 0)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Twoja posta� nie jest w stanie unie�� wi�cej przedmiot�w.");
  			OnPlayerRejectOffer(playerid, offererid);
	    	return 1;
		}
		
		new itemid = OfferData[offererid][oValue1];
		if(ItemCache[itemid][iPlace] != PLACE_PLAYER || ItemCache[itemid][iOwner] != PlayerCache[offererid][pUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie posiada tego przedmiotu w swoim ewkipunku.");
		    OnPlayerRejectOffer(playerid, offererid);
		    return 1;
		}
		
		if(offer_price > 0)
		{
			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
			{
			    crp_GivePlayerMoney(playerid, -offer_price);
			    crp_GivePlayerMoney(offererid, offer_price);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += offer_price;
			}
		}
		ItemCache[itemid][iPlace] = PLACE_PLAYER;
		ItemCache[itemid][iOwner] = PlayerCache[playerid][pUID];
		
		SaveItem(itemid, SAVE_ITEM_OWNER);
		
		format(string, sizeof(string), "* %s podaje przedmiot %s.", PlayerName(offererid), PlayerName(playerid));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		
		printf("[item] %s (UID: %d, GID: %d) poda� przedmiot %s (UID: %d) dla %s (UID: %d, GID: %d).", PlayerRealName(offererid), PlayerCache[offererid][pUID], PlayerCache[offererid][pGID], ItemCache[itemid][iName], ItemCache[itemid][iUID], PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID]);
	}
	
	if(offer_type == OFFER_VEHICLE)
	{
 		if(offer_price > 0)
   		{
     		if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
       		{
         		crp_GivePlayerMoney(playerid, -offer_price);
           		crp_GivePlayerMoney(offererid, offer_price);
	        }
	        else
			{
   				PlayerCache[playerid][pBankCash] -= offer_price;
       			PlayerCache[offererid][pBankCash] += offer_price;
   			}
   		}

		new vehid = OfferData[offererid][oValue1];

		CarInfo[vehid][cOwnerType] = OWNER_PLAYER;
		CarInfo[vehid][cOwner] = PlayerCache[playerid][pUID];

		SaveVehicle(vehid, SAVE_VEH_THINGS);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd %s (SampID: %d, UID: %d) kupiony.\nU�yj komendy /pomoc aby pozna� szczeg�y dotycz�ce pojazd�w.", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID]);
	}
	
	if(offer_type == OFFER_PRODUCT)
	{
		if(!(PlayerCache[playerid][pAdmin] & A_PERM_ITEMS) && GetPlayerCapacity(playerid) <= 0)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Twoja posta� nie jest w stanie unie�� wi�cej przedmiot�w.");
  			OnPlayerRejectOffer(playerid, offererid);
	    	return 1;
		}
		
		new product_id = OfferData[offererid][oValue1];
		if(product_id == INVALID_PRODUCT_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tego produktu nie ma ju� w magazynie.");
	    	return 1;
		}
		
	    if(offer_price > 0)
	    {
   			new group_cash = floatround(0.90 * offer_price),
				playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			
			if(PlayerCache[offererid][pDutyGroup])
			{
				new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
					group_activity = offer_price / 3;

				GroupData[group_id][gCash] += group_cash;
				GroupData[group_id][gActivity] += group_activity;

				SaveGroup(group_id);
				ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
			}
			else
			{
			    new doorid = GetDoorID(OfferData[offererid][oValue2]),
					group_id = GetGroupID(DoorCache[doorid][dOwner]);
					
				GroupData[group_id][gCash] += group_cash;
				SaveGroup(group_id);
				
				ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Sprzeda�e� produkt %s za cen� $%d. Otrzyma�e� premi� w wysoko�ci $%d!", OfferData[offererid][oName], offer_price, playercash);
			}
		}
   		ProductData[product_id][pCount] --;
   		ProductData[product_id][pPrice] = offer_price;
   		
     	new itemid = CreatePlayerItem(playerid, ProductData[product_id][pName], ProductData[product_id][pType], ProductData[product_id][pValue1], ProductData[product_id][pValue2]);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Zakupi�e� produkt %s.\nKoszt: $%d\n\nPrzedmiot (UID: %d) pojawi� si� w Twoim ekwipunku.\nSkorzystaj z komendy /p, by wy�wietli� list� posiadanych przedmiot�w.", ProductData[product_id][pName], offer_price, ItemCache[itemid][iUID]);

		ItemCache[itemid][iGroup] = ProductData[product_id][pOwner];
		SaveItem(itemid, SAVE_ITEM_GROUP);

		if(ProductData[product_id][pCount] <= 0)	DeleteProduct(product_id);
		else 										SaveProduct(product_id, SAVE_PRODUCT_VALUES);

		format(string, sizeof(string), "* %s podaje przedmiot %s.", PlayerName(offererid), PlayerName(playerid));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	}
	
	if(offer_type == OFFER_VCARD)
	{
 		mysql_query_format("INSERT INTO `"SQL_PREF"contacts` (contact_number, contact_name, contact_owner) VALUES ('%d', '%s', '%d')", OfferData[offererid][oValue1], PlayerRealName(offererid), PlayerCache[playerid][pPhoneNumber]);

		format(string, sizeof(string), "* %s wyjmuje telefon i wysy�a wizyt�wk� %s.", PlayerName(offererid), PlayerName(playerid));
		ProxDetector(10.0, offererid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Nowy kontakt zosta� dodany do listy.\nU�yj /tel, by sprawdzi� list� kontakt�w.");
	}
	
	if(offer_type == OFFER_DOOR)
	{
	    if(offer_price > 0)
	    {
			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, offer_price);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += offer_price;
			}
		}
		
	    new doorid = OfferData[offererid][oValue1];

	    DoorCache[doorid][dOwnerType] = OWNER_PLAYER;
	    DoorCache[doorid][dOwner] = PlayerCache[playerid][pUID];

	    SaveDoor(doorid, SAVE_DOOR_THINGS);
	    ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Gratulacje, zakupi�e� now� nieruchomo�� %s (SampID: %d, UID: %d).\nNieruchomo�ci� mo�esz zarz�dza� poprzez komend� /drzwi.", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
	}
	
	if(offer_type == OFFER_TOWING)
	{
	    if(offer_type > 0)
	    {
			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	  		{
	    		crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, offer_price);
			}
			else
			{
	  			PlayerCache[playerid][pBankCash] -= offer_price;
		    	PlayerCache[offererid][pBankCash] += offer_price;
			}
		}
		
		new towed_vehid = OfferData[offererid][oValue1], vehid = OfferData[offererid][oValue2];
		AttachTrailerToVehicle(vehid, towed_vehid);
		
		ShowPlayerInfoDialog(offererid, D_TYPE_SUCCESS, "Pojazd zostal pomy�lnie podczepiony.\nAby go odczepi� wci�nij klawisz \"N\".");
	}
	
	if(offer_type == OFFER_PASSAGE)
	{
		PlayerCache[offererid][pTaxiPassenger] = playerid;
		
		PlayerCache[playerid][pTaxiVeh] = OfferData[offererid][oValue1];
		PlayerCache[playerid][pTaxiPrice] = offer_price;
		
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Od teraz skrypt naliczy ka�de przejechane 100 metr�w.\nSkrypt automatycznie zabierze Ci pieni�dze po opuszczeniu pojazdu.");
	}
	
	if(offer_type == OFFER_REFUEL)
	{
	    if(offer_price > 0)
	    {
  			new group_cash = floatround(0.60 * offer_price),
				playercash = floatround(0.40 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}

			if(PlayerCache[offererid][pDutyGroup])
			{
			    new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]);
			    if(GroupData[group_id][gType] == G_TYPE_GASSTATION)
			    {
			        new group_activity = offer_price * 2;
			    
			        GroupData[group_id][gCash] += group_cash;
			        GroupData[group_id][gActivity] += group_activity;
			        
			        SaveGroup(group_id);
					ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
			    }
			}
	    }
	    
   		new vehid = OfferData[offererid][oValue1], value = OfferData[offererid][oValue2];

		CarInfo[vehid][cFuel] = floatadd(CarInfo[vehid][cFuel], value);
		SaveVehicle(vehid, SAVE_VEH_COUNT);

		SendClientFormatMessage(playerid, COLOR_LIGHTBLUE, "Zap�aci�e� $%d za %d litr�w paliwa.", offer_price, value);
		ApplyAnimation(offererid, "INT_HOUSE", "wash_up",4.1, 0, 0, 0, 0, 0, 1);

		format(string, sizeof(string), "* %s wk�ada w�� do baku.", PlayerName(offererid));
		ProxDetector(10.0, offererid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

		format(string, sizeof(string), "* Pojazd %s zosta� pomy�lnie zatankowany (( %s ))", GetVehicleName(CarInfo[vehid][cModel]), PlayerName(offererid));
  		ProxDetector(10.0, offererid, string, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO);
	}
	
	if(offer_type == OFFER_REPAIR)
	{
		if(offer_price)
	    {
  			new group_cash = floatround(0.60 * offer_price),
				playercash = floatround(0.40 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			if(PlayerCache[offererid][pDutyGroup])
			{
			    new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]);
			    if(GroupData[group_id][gType] == G_TYPE_WORKSHOP || GroupData[group_id][gType] == G_TYPE_GASSTATION)
		    	{
		    	    new group_activity = offer_price;
			    
			        GroupData[group_id][gCash] += group_cash;
			        GroupData[group_id][gActivity] += group_activity;
			        
			        SaveGroup(group_id);
       				ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
			    }
			}
		}
		new vehid = OfferData[offererid][oValue1], Text3D:label_id;
		
		PlayerCache[offererid][pRepairVeh] = vehid;
		PlayerCache[offererid][pRepairTime] = 180;
		
		label_id = CreateDynamic3DTextLabel("Naprawianie w toku...\n -- (0%) --", COLOR_LIGHTBLUE, 0.0, 0.0, 0.0, 20.0, INVALID_PLAYER_ID, vehid, 0, -1, -1, -1, 20.0);

		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_ATTACH_OFFSET_Z, 1.0);
		PlayerCache[offererid][pRepairTag] = label_id;
	}
	
	if(offer_type == OFFER_PAINT)
	{
		if(offer_price)
	    {
			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, offer_price);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += offer_price;
			}
		}
		new color1 = OfferData[offererid][oValue1],
		    color2 = OfferData[offererid][oValue2],
		    vehid = GetPlayerVehicleID(playerid), Text3D:label_id;

	    PlayerCache[offererid][pSprayVeh] = vehid;
	    PlayerCache[offererid][pSprayTime] = 1800;

	    PlayerCache[offererid][pSprayColor][0] = color1;
	    PlayerCache[offererid][pSprayColor][1] = color2;

	    PlayerCache[offererid][pSprayType] = SPRAY_TYPE_COLORS;
	    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Zaakceptowa�e� us�ug� lakierowania pojazdu.\nTeraz odczekaj chwil� a� mechanik sko�czy lakierowa� pojazd.");

		label_id = CreateDynamic3DTextLabel("Lakierowanie w toku...\n -- (0%) --", COLOR_LIGHTBLUE, 0.0, 0.0, 0.0, 20.0, INVALID_PLAYER_ID, vehid, 0, -1, -1, -1, 20.0);
		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_ATTACH_OFFSET_Z, 1.0);

		PlayerCache[offererid][pSprayTag] = label_id;
		ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Gracz zaakceptowa� Twoj� ofert�.\n\nMo�esz teraz zacz�� malowa� pojazd,\nu�yj do tego lakieru a nast�pnie psikaj w jego stron�.");
	}
	
	if(offer_type == OFFER_PAINTJOB)
	{
		if(offer_price)
	    {
			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, offer_price);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += offer_price;
			}
		}
		new paintjob_id = OfferData[offererid][oValue1],
			vehid = GetPlayerVehicleID(playerid), Text3D:label_id;
		
  		PlayerCache[offererid][pSprayVeh] = vehid;
	    PlayerCache[offererid][pSprayTime] = 30000;

	    PlayerCache[offererid][pSprayColor][0] = paintjob_id;
	    PlayerCache[offererid][pSprayColor][1] = 0;
	    
	    PlayerCache[offererid][pSprayType] = SPRAY_TYPE_PAINTJOB;
	    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Zaakceptowa�e� us�ug� lakierowania pojazdu.\nTeraz odczekaj chwil� a� oferuj�cy sko�czy lakierowa� pojazd.");

		label_id = CreateDynamic3DTextLabel("Lakierowanie pojazdu w toku...\n -- (0%) --.", COLOR_LIGHTBLUE, 0.0, 0.0, 0.0, 20.0, INVALID_PLAYER_ID, vehid, 0, -1, -1, -1, 20.0);
		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_ATTACH_OFFSET_Z, 1.0);

		PlayerCache[offererid][pSprayTag] = label_id;
		ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Gracz zaakceptowa� Twoj� ofert�.\n\nMo�esz teraz zacz�� malowa� pojazd,\nu�yj do tego lakieru a nast�pnie psikaj w jego stron�.");
	}
	
	if(offer_type == OFFER_MONTAGE)
	{
		if(offer_price)
	    {
			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, offer_price);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += offer_price;
			}
		}
		new itemid = OfferData[offererid][oValue1],
			vehid = OfferData[offererid][oValue2];
			
		ItemCache[itemid][iUsed] = true;
		
		PlayerCache[offererid][pMontageVeh] = vehid;
		PlayerCache[offererid][pMontageItem] = itemid;
  		
	    PlayerCache[offererid][pMontageTime] = 120;
	}
	
	if(offer_type == OFFER_MANDATE)
	{
		if(offer_price)
	    {
   			new group_cash = floatround(0.90 * offer_price),
				playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
			    group_activity = offer_price * 3;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;
			
			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
		}
		new mandate_reason[128], add_pdp = OfferData[offererid][oValue1];
		
		mysql_real_escape_string(OfferData[offererid][oName], mandate_reason);
		mysql_query_format("INSERT INTO `"SQL_PREF"directory` VALUES ('', '%d', '%d', '%s', '%d', NOW())", PlayerCache[playerid][pUID], PlayerCache[offererid][pUID], mandate_reason, add_pdp);

        PlayerCache[playerid][pPDP] += add_pdp;
	}
	
	if(offer_type == OFFER_UNBLOCK)
	{
   		if(offer_price)
	    {
   			new group_cash = floatround(0.90 * offer_price),
				playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
			    group_activity = offer_price / 3;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;
			
			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
		}
		new vehid = OfferData[offererid][oValue1];

		CarInfo[vehid][cBlockWheel] = 0;
		SaveVehicle(vehid, SAVE_VEH_ACCESS);

		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Blokada zosta�a zdj�ta z ko�a %s (SampID: %d, UID: %d).", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID]);
	}
	
	if(offer_type == OFFER_DOCUMENT)
	{
		if(offer_price)
	    {
   			new group_cash = floatround(0.90 * offer_price),
				playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
				group_activity = offer_price;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;
			
			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
		}
		PlayerCache[playerid][pDocuments] += OfferData[offererid][oValue1];
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Zakupi�e� nowy dokument.\nU�yj komendy /pokaz, aby zarz�dza� dokumentami.");
	}
	
	if(offer_type == OFFER_BUSINESS)
	{
		new group_slot = GetPlayerFreeGroupSlot(playerid);
		if(group_slot == INVALID_SLOT_ID)
		{
		    ShowPlayerInfoDialog(offererid, D_TYPE_ERROR, "Ten gracz nie posiada �adnego wolnego slotu dla grupy.");
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz �adnego wolnego slotu dla grupy.");

			OnPlayerRejectOffer(playerid, offererid);
			return 1;
		}

		if(offer_price)
	    {
   			new group_cash = floatround(0.99 * offer_price),
				playercash = floatround(0.01 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
			    group_activity = offer_price / 4;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;
			
			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
		}

		new group_id = CreateGroup(OfferData[offererid][oName]),
		    group_type = OfferData[offererid][oValue1];

		PlayerGroup[playerid][group_slot][gpUID] = GroupData[group_id][gUID];
		PlayerGroup[playerid][group_slot][gpID] = group_id;

		PlayerGroup[playerid][group_slot][gpPerm] = G_PERM_MAX;
		mysql_query_format("INSERT INTO `"SQL_PREF"char_groups` (`char_uid`, `group_belongs`, `group_perm`) VALUES ('%d', '%d', '%d')", PlayerCache[playerid][pUID], GroupData[group_id][gUID], G_PERM_MAX);

        GroupData[group_id][gType] 	= group_type;
        GroupData[group_id][gFlags] = GroupTypeInfo[group_type][gTypeFlags];

		mysql_query_format("UPDATE `"SQL_PREF"groups` SET group_type = '%d', group_flags = '%d' WHERE group_uid = '%d' LIMIT 1", GroupData[group_id][gType], GroupData[group_id][gFlags], GroupData[group_id][gUID]);
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Gratulacje! Od teraz jeste� w�a�cicielem nowego biznesu.\n\nNazwa biznesu: %s\nTyp: %s\nIdentyfikator (UID): %d\n\nSkorzystaj z komendy /g, by pozna� szczeg�y.", GroupData[group_id][gName], GroupTypeInfo[GroupData[group_id][gType]][gTypeName], GroupData[group_id][gUID]);
	}
	
	if(offer_type == OFFER_REGISTER)
	{
		if(offer_price)
	    {
   			new group_cash = floatround(0.90 * offer_price),
				playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
				group_activity = offer_price;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;
			
			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
		}
		
		new vehid = OfferData[offererid][oValue1];
        format(string, sizeof(string), "LS%d", CarInfo[vehid][cUID]);
        
        strmid(CarInfo[vehid][cRegister], string, 0, strlen(string), 12);
		SaveVehicle(vehid, SAVE_VEH_ACCESS);

	    SetVehicleNumberPlate(vehid, string);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd zosta� pomy�lnie zarejestrowany.\nTablice rejestracyjne zmieni�y si� automatycznie.");
	}
	
	if(offer_type == OFFER_HEAL)
	{
		if(offer_price)
	    {
   			new group_cash = floatround(0.90 * offer_price),
				playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
			    group_activity = offer_price * 3;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;
			
			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
		}
		PlayerCache[offererid][pHealing] = playerid;

		ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Postanowi�e� uleczy� gracza %s.\nProces leczenia potrwa chwile, nie oddalaj si� od pacjenta.", PlayerName(playerid));
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Gracz %s postanowi� Ci� uleczy�.\nProces leczenia potrwa chwile, nie oddalaj si� od medyka.", PlayerName(offererid));
	}
	
	if(offer_type == OFFER_PASS)
	{
		if(offer_price)
	    {
   			new group_cash = floatround(0.40 * offer_price),
				playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
			    group_activity = offer_price;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;
			
			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
		}
		new pass_time = OfferData[offererid][oValue1], group_uid = OfferData[offererid][oValue2];
        CreatePlayerItem(playerid, OfferData[offererid][oName], ITEM_PASS, pass_time, group_uid);
        
        ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Otrzyma�e� karnet na si�owni�.\nSkorzystaj z komendy /p, aby u�y� przedmiotu.\n\nPo u�yciu karnetu b�dziesz m�g� korzysta�\nz obiekt�w sportowych w budynku tej firmy.");
	}
	
	if(offer_type == OFFER_WELCOME)
	{
	    if(!PlayerToPlayer(5.0, playerid, offererid))
	    {
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
  			OnPlayerRejectOffer(playerid, offererid);
	        return 1;
	    }
	    
		new welcome_type = OfferData[offererid][oValue1],
		    Float:PosX, Float:PosY, Float:PosZ, Float:PosA;

		GetPlayerPos(offererid, PosX, PosY, PosZ);

		if(welcome_type <= 6)	GetXYInFrontOfPlayer(offererid, PosX, PosY, 1.0);
		else					GetXYInFrontOfPlayer(offererid, PosX, PosY, 0.5);

		GetPlayerFacingAngle(offererid, PosA);

		SetPlayerPos(playerid, PosX, PosY, PosZ);
		SetPlayerFacingAngle(playerid, (floatabs(PosA) - 180.0));

		switch(welcome_type)
		{
		    case 1:
		    {
  				ApplyAnimation(offererid, "GANGS", "hndshkfa", 4.1, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(playerid, "GANGS", "hndshkfa", 4.1, 0, 0, 0, 0, 0, 1);
		    }
		    case 2:
		    {
  				ApplyAnimation(offererid, "GANGS", "hndshkba", 4.1, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(playerid, "GANGS", "hndshkba", 4.1, 0, 0, 0, 0, 0, 1);
		    }
		    case 3:
		    {
		    	ApplyAnimation(offererid, "GANGS", "hndshkaa", 4.1, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(playerid, "GANGS", "hndshkaa", 4.1, 0, 0, 0, 0, 0, 1);
		    }
		    case 4:
		    {
  				ApplyAnimation(offererid, "GANGS", "hndshkda", 4.1, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(playerid, "GANGS", "hndshkda", 4.1, 0, 0, 0, 0, 0, 1);
		    }
		    case 5:
		    {
  				ApplyAnimation(offererid, "GANGS", "hndshkca", 4.1, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(playerid, "GANGS", "hndshkca", 4.1, 0, 0, 0, 0, 0, 1);
		    }
		    case 6:
		    {
  				ApplyAnimation(offererid, "GANGS", "hndshkcb", 4.1, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(playerid, "GANGS", "hndshkcb", 4.1, 0, 0, 0, 0, 0, 1);
		    }
		    case 7:
		    {
  				ApplyAnimation(offererid, "GANGS", "prtial_hndshk_biz_01", 4.1, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.1, 0, 0, 0, 0, 0, 1);
		    }
		    case 8:
		    {
				ApplyAnimation(offererid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
			}
			case 9:
			{
				ApplyAnimation(offererid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
			}
			case 10:
			{
				ApplyAnimation(offererid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
			}
		}
	}
	
	if(offer_type == OFFER_ADVERTISE)
	{
	    if(offer_price)
	    {
	        new group_cash = floatround(0.90 * offer_price),
	            playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
				group_activity = offer_price * 2;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;
			
			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
	    }
	}
	
	if(offer_type == OFFER_SALON)
	{
	    if(offer_price)
	    {
  			new group_cash = floatround(0.09 * offer_price),
				playercash = floatround(0.001 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
   				PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
			    group_activity = group_cash / 2;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;
			
			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
	    }
	    new veh_model = OfferData[offererid][oValue1], veh_uid, spawn_point = random(sizeof(SalonSpawnPos)), color = random(36);
	    veh_uid = CreateStaticVehicle(veh_model, SalonSpawnPos[spawn_point][0], SalonSpawnPos[spawn_point][1], SalonSpawnPos[spawn_point][2], SalonSpawnPos[spawn_point][3], color, color, 3600);
	    
		new vehid = GetVehicleID(veh_uid);
		
  		SetPlayerCheckpoint(playerid, SalonSpawnPos[spawn_point][0], SalonSpawnPos[spawn_point][1], SalonSpawnPos[spawn_point][2], 5.0);
    	PlayerCache[playerid][pCheckpoint] = CHECKPOINT_VEHICLE;

		CarInfo[vehid][cOwnerType] = OWNER_PLAYER;
		CarInfo[vehid][cOwner] = PlayerCache[playerid][pUID];
		
		SaveVehicle(vehid, SAVE_VEH_THINGS);
  		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Gratulacje! Zakupi�e� nowy pojazd.\nUdaj si� w wyznaczone miejsce na mapie, by odebra� sw�j pojazd.\n\nZapoznaj si� r�wnie� z komend� /pojazd.");
	}
	
	if(offer_type == OFFER_TAX)
	{
 		if(offer_price)
	    {
  			new group_cash = floatround(0.90 * offer_price),
				playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
   				PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
			    group_activity = group_cash / 2;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;

			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
	    }
	    
	    new group_id = OfferData[offererid][oValue1];
	    
	    GroupData[group_id][gLastTax] = gettime();
	    SaveGroup(group_id);
	    
	    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Podatek za firm� %s (UID: %d) zosta� pomy�lnie sp�acony.", GroupData[group_id][gName], GroupData[group_id][gUID]);
	}
	
	if(offer_type == OFFER_KEYS)
	{
		if(offer_price)
	    {
  			new group_cash = floatround(0.90 * offer_price),
				playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
   				PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
			    group_activity = group_cash / 2;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;

			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
	    }
		new vehid = OfferData[offererid][oValue1];

		format(string, sizeof(string), "Kluczyki do %s", GetVehicleName(CarInfo[vehid][cModel]));
		CreatePlayerItem(playerid, string, ITEM_KEYS, CarInfo[vehid][cUID], 0);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Kluczyki do pojazdu %s (UID: %d) zosta�y pomy�lnie wyrobione.\nPrzedmiot pojawi� si� w Twoim ekwipunku.", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID]);
	}
	
	if(offer_type == OFFER_STYLE)
	{
		if(offer_price)
	    {
  			new group_cash = floatround(0.90 * offer_price),
				playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
   				PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
			    group_activity = group_cash / 3;

			GroupData[group_id][gCash] += group_cash;
			GroupData[group_id][gActivity] += group_activity;

			SaveGroup(group_id);
			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
	    }
	    
		new style = OfferData[offererid][oValue1];
		GivePlayerAchievement(playerid, ACHIEVE_STYLE);
		
		PlayerCache[playerid][pFightStyle] = style + 4;
		SetPlayerFightingStyle(playerid, PlayerCache[playerid][pFightStyle]);
		
		OnPlayerSave(playerid, SAVE_PLAYER_SETTING);
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Gratulacje! Twoja posta� pozna�a now� sztuk� walki.\nOd teraz podczas walk pos�ugiwa� si� b�dzie tylko i wy��cznie nim.\n\nNauczono si� nowego stylu: %s", FightStyleData[style][0]);
	}
	
	if(offer_type == OFFER_LESSON)
	{
		if(offer_price)
	    {
   			new group_cash = floatround(0.90 * offer_price),
				playercash = floatround(0.10 * offer_price);

			if(OfferData[offererid][oPayType] == PAY_TYPE_CASH)
	        {
			    crp_GivePlayerMoney(playerid, -offer_price);
				crp_GivePlayerMoney(offererid, playercash);
			}
			else
			{
			    PlayerCache[playerid][pBankCash] -= offer_price;
			    PlayerCache[offererid][pBankCash] += playercash;
			}
			new group_id = GetPlayerGroupID(offererid, PlayerCache[offererid][pDutyGroup]),
			    group_activity = group_cash / 3;

			GroupData[group_id][gCash] += group_cash;
			SaveGroup(group_id);

			ShowPlayerInfoDialog(offererid, D_TYPE_INFO, "Otrzyma�e� premi� w wysoko�ci $%d!\n\nNa konto grupy dodano: $%d\nPunkty aktywno�ci: +%d", playercash, group_cash, group_activity);
		}
		new lesson_time = OfferData[offererid][oValue1],
			group_id = OfferData[offererid][oValue2];
			
		PlayerCache[playerid][pLesson]      = group_id;
		PlayerCache[playerid][pLessonTime] 	= lesson_time * 60;
	}
	
	TextDrawHideForPlayer(playerid, TextDrawOfferAccept);
	TextDrawHideForPlayer(playerid, TextDrawOfferReject);
	
	TextDrawHideForPlayer(playerid, TextDrawOfferBack);
	PlayerTextDrawHide(playerid, TextDrawOfferDesc[playerid]);
	
	TD_ShowSmallInfo(playerid, 5, "Oferta od %s zostala ~g~zaakceptowana~w~.", PlayerName(offererid));
	TD_ShowSmallInfo(offererid, 5, "%s ~g~zaakceptowal ~w~Twoja oferte.", PlayerName(playerid));

	OnPlayerSave(playerid, SAVE_PLAYER_BASIC);
	OnPlayerSave(offererid, SAVE_PLAYER_BASIC);
	
	printf("[offe] %s (UID: %d, GID: %d) zaakceptowa� ofert� gracza %s (UID: %d, GID: %d). Typ oferty: %s, nazwa: %s, warto�ci: %d/%d, cena: $%d.", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], PlayerName(offererid), PlayerCache[offererid][pUID], PlayerCache[offererid][pGID], OfferTypeInfo[OfferData[offererid][oType]][oTypeName], OfferData[offererid][oName], OfferData[offererid][oValue1], OfferData[offererid][oValue2], OfferData[offererid][oPrice]);

	OfferData[offererid][oCustomerID]	= INVALID_PLAYER_ID;
	OfferData[offererid][oType]  		= 0;

	OfferData[offererid][oValue1] 		= 0;
	OfferData[offererid][oValue2] 		= 0;

	OfferData[offererid][oPrice] 		= 0;
	OfferData[offererid][oPayType] 		= PAY_TYPE_NONE;
	return 1;
}

public OnPlayerRejectOffer(playerid, offererid)
{
	TextDrawHideForPlayer(playerid, TextDrawOfferAccept);
	TextDrawHideForPlayer(playerid, TextDrawOfferReject);

	TextDrawHideForPlayer(playerid, TextDrawOfferBack);
	PlayerTextDrawHide(playerid, TextDrawOfferDesc[playerid]);

	TD_ShowSmallInfo(playerid, 5, "Oferta od %s zostala ~r~odrzucona~w~.", PlayerName(offererid));
	TD_ShowSmallInfo(offererid, 5, "%s ~r~odrzucil ~w~Twoja oferte.", PlayerName(playerid));

	printf("[offe] %s (UID: %d, GID: %d) odrzuci� ofert� gracza %s (UID: %d, GID: %d). Typ oferty: %s, nazwa: %s, warto�ci: %d/%d, cena: $%d.", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], PlayerName(offererid), PlayerCache[offererid][pUID], PlayerCache[offererid][pGID], OfferTypeInfo[OfferData[offererid][oType]][oTypeName], OfferData[offererid][oName], OfferData[offererid][oValue1], OfferData[offererid][oValue2], OfferData[offererid][oPrice]);

	OfferData[offererid][oCustomerID]	= INVALID_PLAYER_ID;
	OfferData[offererid][oType]  		= 0;
	
	OfferData[offererid][oValue1] 		= 0;
	OfferData[offererid][oValue2] 		= 0;

	OfferData[offererid][oPrice] 		= 0;
	OfferData[offererid][oPayType] 		= PAY_TYPE_NONE;
	return 1;
}

public OnPlayerEnterDoor(playerid, doorid)
{
   	if(DoorCache[doorid][dLocked])
    {
    	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~r~Drzwi sa zamkniete", 4000, 3);
     	return 1;
    }
    if(PlayerCache[playerid][pCash] < DoorCache[doorid][dEnterPay])
    {
    	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~r~Brak gotowki na wstep", 4000, 3);
    	return 1;
    }
    if(!DoorCache[doorid][dExitX])
    {
    	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~w~Wnetrze jest w trakcie ~p~~h~remontu", 4000, 3);
     	return 1;
    }
   	if(PlayerCache[playerid][pRoll])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wej�� do budynku maj�c rolki na nogach.");
	    return 1;
	}
	if(DoorCache[doorid][dFireData][FIRE_TIME])
	{
	    if(!IsPlayerInGroupType(playerid, G_TYPE_FIREDEPT))
		{
	    	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Ten budynek p�onie!\n\nZadzwo� po s�u�by porz�dkowe, w przeciwnym wypadku\nbudynek ulegnie ca�kowitemu zniszczeniu!");
	    	return 1;
		}
		TD_ShowSmallInfo(playerid, 5, "Wszedles do ~r~palacego ~w~sie budynku. Uzywaj ~y~gasnicy ~w~by gasic pozar.");
	}
	if(PlayerCache[playerid][pFreeze] > 0)
	{
	    return 1;
	}
   	if(strlen(DoorCache[doorid][dAudioURL]))
	{
	    if(PlayerCache[playerid][pItemPlayer] != INVALID_ITEM_ID)
	    {
	        new itemid = PlayerCache[playerid][pItemPlayer];
	        ItemCache[itemid][iUsed] = false;
	    }
	    PlayStreamedAudioForPlayer(playerid, DoorCache[doorid][dAudioURL]);
	}
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    crp_SetPlayerPos(playerid, DoorCache[doorid][dExitX], DoorCache[doorid][dExitY], DoorCache[doorid][dExitZ]);
	    SetPlayerFacingAngle(playerid, DoorCache[doorid][dExitA]);

		SetPlayerInterior(playerid, DoorCache[doorid][dExitInt]);
		SetPlayerVirtualWorld(playerid, DoorCache[doorid][dExitVW]);
	}
	else
	{
	    new vehid = GetPlayerVehicleID(playerid);

		PlayerCache[playerid][pPosX] = DoorCache[doorid][dExitX];
		PlayerCache[playerid][pPosY] = DoorCache[doorid][dExitY];
		PlayerCache[playerid][pPosZ] = DoorCache[doorid][dExitZ];

		SetVehicleVirtualWorld(vehid, DoorCache[doorid][dExitVW]);
		SetVehiclePos(vehid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]);

		SetVehicleZAngle(vehid, DoorCache[doorid][dExitA]);
		LinkVehicleToInterior(vehid, DoorCache[doorid][dExitInt]);

		foreach(new i : Player)
		{
		    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
		    {
	  			if(GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
	    		{
					SetPlayerVirtualWorld(i, DoorCache[doorid][dExitVW]);
					SetPlayerInterior(i, DoorCache[doorid][dExitInt]);
				}
			}
		}
	}
	Streamer_Update(playerid);
	Streamer_UpdateEx(playerid, DoorCache[doorid][dExitX], DoorCache[doorid][dExitY], DoorCache[doorid][dExitZ], DoorCache[doorid][dExitVW], DoorCache[doorid][dExitInt]);
	
	CancelEdit(playerid);
	OnPlayerFreeze(playerid, true, 3);

	TD_HideDoor(playerid);
	ResetPlayerCamera(playerid);

	// Zabierz graczowi kas� za wst�p i przelej j� na konto w�a�ciciela
 	if(DoorCache[doorid][dEnterPay])
    {
        if(PlayerCache[playerid][pHours] > 5)
        {
			crp_GivePlayerMoney(playerid, -DoorCache[doorid][dEnterPay]);
			OnPlayerSave(playerid, SAVE_PLAYER_BASIC);
			
	        if(DoorCache[doorid][dOwnerType] == OWNER_PLAYER)
	        {
				new owner_id = GetPlayerID(DoorCache[doorid][dOwner]);
				if(owner_id != INVALID_PLAYER_ID && PlayerCache[owner_id][pLogged] && PlayerCache[owner_id][pSpawned])
				{
					PlayerCache[owner_id][pBankCash] += DoorCache[doorid][dEnterPay];
					OnPlayerSave(owner_id, SAVE_PLAYER_BASIC);
				}
				else
				{
				    mysql_query_format("UPDATE `"SQL_PREF"characters` SET char_bankcash = char_bankcash + %d WHERE char_uid = '%d' LIMIT 1", DoorCache[doorid][dEnterPay], DoorCache[doorid][dOwner]);
				}
	        }
	        if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
	        {
	            new group_id = GetGroupID(DoorCache[doorid][dOwner]);
	            
	            GroupData[group_id][gCash] += DoorCache[doorid][dEnterPay];
	            SaveGroup(group_id);
	        }
		}
    }
    
    // Podatek
    if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
    {
		if(IsPlayerInGroup(playerid, DoorCache[doorid][dOwner]))
		{
			new group_id = GetPlayerGroupID(playerid, DoorCache[doorid][dOwner]);

			if(GroupData[group_id][gFlags] & G_FLAG_TAX)
			{
			    if(GroupData[group_id][gLastTax] + (7 * 86000) <= gettime())
			    {
     				new time_string[64];
			   		//mtime_UnixToDate(time_string, sizeof(time_string), GroupData[group_id][gLastTax] + (15 * 86000));

					strmid(time_string, time_string, 0, 10, 64);
			        ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Uwaga! Firma ta nie wywi�za�a si� z obowi�zku sp�aty podatku.\nZaleca si� jak najpr�dzej sp�aci� d�ug, w przeciwnym wypadku firma zostanie usuni�ta!\n\nPodatek zap�aci� mo�na w Urz�dzie Miasta, udaj si� tam i popro� urz�dnika o ofert�.\nAktywno�� firmy wygasa: %s", time_string);
			    }
			}
		}
	}
	
	printf("[door] %s (UID: %d, GID: %d) wszed� przez drzwi %s (UID: %d). Koszt: $%d", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], DoorCache[doorid][dName], DoorCache[doorid][dUID], DoorCache[doorid][dEnterPay]);
	return 1;
}

public OnPlayerExitDoor(playerid, doorid)
{
	if(DoorCache[doorid][dLocked])
 	{
  		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~r~Drzwi sa zamkniete.", 4000, 3);
  		return 1;
 	}
	if(PlayerCache[playerid][pFreeze] > 0)
	{
	    return 1;
	}
 	if(strlen(DoorCache[doorid][dAudioURL]))
 	{
  		if(PlayerCache[playerid][pItemPlayer] != INVALID_ITEM_ID)
	    {
	        new itemid = PlayerCache[playerid][pItemPlayer];
	        ItemCache[itemid][iUsed] = false;
	    }
		StopStreamedAudioForPlayer(playerid);
	}
	
	if(PlayerCache[playerid][pItemPass] != INVALID_ITEM_ID)
	{
	    new itemid = PlayerCache[playerid][pItemPass];
	    
		ItemCache[itemid][iUsed] = false;
		ItemCache[itemid][iValue1] = PlayerCache[playerid][pGymTime] / 60;

		SaveItem(itemid, SAVE_ITEM_VALUES);

		PlayerCache[playerid][pItemPass]    = INVALID_ITEM_ID;
		PlayerCache[playerid][pGymTime]     = 0;
	}

  	if(!IsPlayerInAnyVehicle(playerid))
  	{
		crp_SetPlayerPos(playerid, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ]);
	  	SetPlayerFacingAngle(playerid, DoorCache[doorid][dEnterA]);

		SetPlayerInterior(playerid, DoorCache[doorid][dEnterInt]);
	 	SetPlayerVirtualWorld(playerid, DoorCache[doorid][dEnterVW]);
	}
	else
	{
	    new vehid = GetPlayerVehicleID(playerid);

		PlayerCache[playerid][pPosX] = DoorCache[doorid][dEnterX];
		PlayerCache[playerid][pPosY] = DoorCache[doorid][dEnterY];
		PlayerCache[playerid][pPosZ] = DoorCache[doorid][dEnterZ];

		SetVehicleVirtualWorld(vehid, DoorCache[doorid][dEnterVW]);
		SetVehiclePos(vehid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]);

		SetVehicleZAngle(vehid, DoorCache[doorid][dEnterA]);
		LinkVehicleToInterior(vehid, DoorCache[doorid][dEnterInt]);

		foreach(new i : Player)
		{
			if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
			{
	  			if(GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
		    	{
					SetPlayerVirtualWorld(i, DoorCache[doorid][dEnterVW]);
					SetPlayerInterior(i, DoorCache[doorid][dEnterInt]);
				}
			}
		}
	}
	Streamer_Update(playerid);
	Streamer_UpdateEx(playerid, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ], DoorCache[doorid][dEnterVW], DoorCache[doorid][dEnterInt]);
	
	CancelEdit(playerid);
    OnPlayerFreeze(playerid, true, 3);
    
	ResetPlayerCamera(playerid);
	printf("[door] %s (UID: %d, GID: %d) wyszed� przez drzwi %s (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], DoorCache[doorid][dName], DoorCache[doorid][dUID]);
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    PlayerCache[playerid][pCurrentArea] = areaid;
	if(strlen(AreaCache[areaid][aAudioURL]))
	{
	    if(PlayerCache[playerid][pItemPlayer] != INVALID_ITEM_ID)	return 1;
		PlayerCache[playerid][pAudioHandle] = Audio_PlayStreamed(playerid, AreaCache[areaid][aAudioURL]);
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    PlayerCache[playerid][pCurrentArea] = INVALID_AREA_ID;

	if(PlayerCache[playerid][pItemBoombox] != INVALID_ITEM_ID)
	{
		new itemid = PlayerCache[playerid][pItemBoombox];
		foreach(new i : Player)
		{
			if(i != playerid)
   			{
				if(PlayerCache[i][pCurrentArea] == areaid)
				{
    				Audio_Stop(i, PlayerCache[playerid][pAudioHandle]);
				    PlayerCache[i][pAudioHandle] = 0;
				}
			}
		}
		strmid(AreaCache[areaid][aAudioURL], "", 0, 0, 64);
		StopStreamedAudioForPlayer(playerid);

		PlayerCache[playerid][pItemBoombox] = INVALID_ITEM_ID;
		ItemCache[itemid][iUsed] = false;

		RemovePlayerAttachedObject(playerid, SLOT_BOOMBOX);
		TD_ShowSmallInfo(playerid, 3, "Odtwarzanie muzyki zostalo ~r~zakonczone~w~.");
	}
	if(strlen(AreaCache[areaid][aAudioURL]))
	{
 		if(PlayerCache[playerid][pItemPlayer] != INVALID_ITEM_ID)	return 1;
		Audio_Stop(playerid, PlayerCache[playerid][pAudioHandle]);
	}
	return 1;
}

public GivePlayerAchievement(playerid, achieve_type)
{
	if((PlayerCache[playerid][pAchievements] & achieve_type))
	{
	    return 1;
	}
	
	new achieve_id = GetAchieveIndex(achieve_type), string[256];
	format(string, sizeof(string), "Zdobyles osiagniecie: ~n~~y~%s", AchieveInfo[achieve_id][aName]);

	if(AchieveInfo[achieve_id][aPoints] < 0)    format(string, sizeof(string), "%s~n~~n~~w~Punkty: ~r~~h~(%d) cPoints", string, AchieveInfo[achieve_id][aPoints]);
	else                                        format(string, sizeof(string), "%s~n~~n~~w~Punkty: ~b~~h~(+%d) cPoints", string, AchieveInfo[achieve_id][aPoints]);

	PlayerTextDrawSetString(playerid, PlayerText:TextDrawAchieve[playerid], string);
	PlayerTextDrawShow(playerid, PlayerText:TextDrawAchieve[playerid]);
	
	PlayerCache[playerid][pPoints] 			+= AchieveInfo[achieve_id][aPoints];
	PlayerCache[playerid][pAchievements] 	+= achieve_type;
	
	PlayerCache[playerid][pAchieveInfoTime] = 10;
	SetPlayerScore(playerid, PlayerCache[playerid][pPoints]);
	
	Audio_Play(playerid, AUDIO_ACHIEVE);
	mysql_query_format("UPDATE `ipb_members`, `"SQL_PREF"characters` SET member_game_points = '%d', char_achievements = '%d' WHERE char_uid = '%d' AND member_id = '%d'", PlayerCache[playerid][pPoints], PlayerCache[playerid][pAchievements], PlayerCache[playerid][pUID], PlayerCache[playerid][pGID]);
	return 1;
}

public ShowPlayerDirectoryForPlayer(playerid, giveplayer_id)
{
	new data[256], string[128], list_directory[512];
	mysql_query_format("SELECT `directory_uid`, `directory_reason`, `directory_date` FROM `crp_directory` WHERE directory_owner = '%d' ORDER BY `directory_date` DESC", PlayerCache[playerid][pUID]);
	
	new directory_uid, dir_count,
		directory_reason[64], directory_date[24];
		
    format(list_directory, sizeof(list_directory), "Dodaj nowy wpis...\n-----");
		
	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
	    sscanf(data, "p<|>ds[64]s[24]", directory_uid, directory_reason, directory_date);
	    
	    strdel(directory_reason, 24, strlen(directory_reason));
	    format(list_directory, sizeof(list_directory), "%s\n%d\t%s\t\t%s...", list_directory, directory_uid, directory_date, directory_reason);
	    
	    dir_count ++;
	}
	mysql_free_result();
	if(!dir_count)	format(list_directory, sizeof(list_directory), "%s\n{FF3D3D}#\t\tNie znaleziono �adnych wpis�w w kartotece", list_directory);
	
 	format(string, sizeof(string), "Kartoteka - %s. Punkty Karne: %d (DNA: %s)", PlayerRealName(playerid), PlayerCache[playerid][pPDP], CharCode(PlayerCache[playerid][pUID]));
 	ShowPlayerDialog(giveplayer_id, D_DIRECTORY_LIST, DIALOG_STYLE_LIST, string, list_directory, "Szczeg�y", "Anuluj");
	return 1;
}

public GivePlayerPunish(playerid, giverid, punish_type, punish_reason[], punish_time, punish_extraid)
{
	new string[256], player_name[24], giver_name[24],
	    kick = false, punish_date = gettime(), punish_end;
	    
	if(giverid == INVALID_PLAYER_ID)    strmid(giver_name, "System", 0, 6, 24);
	else                                strmid(giver_name, PlayerName(giverid), 0, strlen(PlayerName(giverid)), 24);
	
	if(playerid == INVALID_PLAYER_ID)   strmid(player_name, "Niezalogowany", 0, 6, 24);
	else                                strmid(player_name, PlayerRealName(playerid), 0, strlen(PlayerRealName(playerid)), 24);
	
	switch(punish_type)
	{
	    case PUNISH_WARN:
	    {
	        PlayerCache[playerid][pWarns] ++;
	        mysql_query_format("UPDATE `ipb_members` SET member_game_warns = '%d' WHERE member_id = '%d' LIMIT 1", PlayerCache[playerid][pWarns], PlayerCache[playerid][pGID]);
	    
	        format(string, sizeof(string), "Warn (%d)", PlayerCache[playerid][pWarns]);
			TextDrawSetString(Text:TextDrawPunishTitle, string);
	    }
	    case PUNISH_KICK:
    	{
	        TextDrawSetString(Text:TextDrawPunishTitle, "Kick");
	        
	        kick = true;
	    }
	    case PUNISH_BAN:
    	{
			new IP[16];
			GetPlayerIp(playerid, IP, sizeof(IP));
	        mysql_query_format("INSERT INTO `"SQL_PREF"bans` (ban_owner, ban_ip, ban_reason) VALUES ('%d', '%s', '%s')", PlayerCache[playerid][pGID], IP, punish_reason);
	    
	        format(string, sizeof(string), "Ban (%d dni)", punish_time);
	        TextDrawSetString(Text:TextDrawPunishTitle, string);
	        
	        kick = true;
	        punish_end = punish_date + (punish_time * 86400);
	        
            PlayerCache[playerid][pBlock] += BLOCK_CHAR;
	        mysql_query_format("UPDATE `"SQL_PREF"characters` SET char_block = '%d' WHERE char_uid = '%d' LIMIT 1", PlayerCache[playerid][pBlock], PlayerCache[playerid][pUID]);
	    }
	    case PUNISH_BLOCK:
	    {
	        switch(punish_extraid)
	        {
	            case BLOCK_CHAR:
	            {
					
	                TextDrawSetString(Text:TextDrawPunishTitle, "Blokada postaci");
	                kick = true;
	            }
	            case BLOCK_VEH:
	            {
	                format(string, sizeof(string), "Blokada prowadzenia pojazdow (%d dni)", punish_time);
	                TextDrawSetString(Text:TextDrawPunishTitle, string);
	                
	                punish_end = punish_date + (punish_time * 86400);
	            }
	            case BLOCK_RUN:
	            {
             		format(string, sizeof(string), "Blokada biegania i bicia (%d dni)", punish_time);
	                TextDrawSetString(Text:TextDrawPunishTitle, string);
	                
	                punish_end = punish_date + (punish_time * 86400);
	            }
	            case BLOCK_OOC:
	            {
     				format(string, sizeof(string), "Blokada czatu OOC (%d dni)", punish_time);
	                TextDrawSetString(Text:TextDrawPunishTitle, string);
	                
	                punish_end = punish_date + (punish_time * 86400);
	            }
	        }
	        
	        PlayerCache[playerid][pBlock] += punish_extraid;
	        mysql_query_format("UPDATE `"SQL_PREF"characters` SET char_block = '%d' WHERE char_uid = '%d' LIMIT 1", PlayerCache[playerid][pBlock], PlayerCache[playerid][pUID]);
	    }
	    case PUNISH_AJ:
	    {
	        GivePlayerAchievement(playerid, ACHIEVE_AJ);
	        crp_SetPlayerPos(playerid, PosInfo[ADMIN_JAIL_POS][sPosX], PosInfo[ADMIN_JAIL_POS][sPosY], PosInfo[ADMIN_JAIL_POS][sPosZ]);
	        
	        SetPlayerInterior(playerid, 0);
	        SetPlayerVirtualWorld(playerid, playerid + 1000);
	    
	        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
	            new vehid = GetPlayerVehicleID(playerid);
				CarInfo[vehid][cLocked] = true;
	  			SetVehicleLock(vehid, CarInfo[vehid][cLocked]);

				ChangeVehicleEngineStatus(vehid, false);
				SaveVehicle(vehid, SAVE_VEH_COUNT | SAVE_VEH_LOCK);
			}
	        
	        PlayerCache[playerid][pAJ] = punish_time * 60;
			TextDrawSetString(Text:TextDrawPunishTitle, "AdminJail");
	    }
	}
	EscapePL(punish_reason);
    AddPlayerPunishLog(playerid, giverid, punish_type, punish_extraid, punish_reason, punish_date, punish_end);
	
	format(string, sizeof(string), "Nadawca: %s~n~Odbiorca: %s~n~~n~Powod:~n~%s", giver_name, player_name, punish_reason);
	TextDrawSetString(Text:TextDrawPunishDesc, string);

	TextDrawShowForAll(Text:TextDrawPunishTitle);
	TextDrawShowForAll(Text:TextDrawPunishDesc);
	
 	SendClientMessage(playerid, COLOR_RED, "Je�eli kara zosta�a nadana nies�usznie - mo�esz apelowa� na naszym forum.");
  	SendClientMessage(playerid, COLOR_RED, "Wszystkie nadane kary s� logowane i znale�� je mo�esz w swoim profilu na stronie.");
   	SendClientMessage(playerid, COLOR_RED, "Adres naszej strony: "WEB_URL". Pami�taj, by nie za�atwia� takich spraw w grze!");
	
	if(kick) defer OnKickPlayer(playerid);
	PunishTime = 15;
	return 1;
}

public AddPlayerPunishLog(playerid, punish_giver, punish_type, punish_extraid, punish_reason[], punish_date, punish_end)
{
	new player_uid = PlayerCache[playerid][pUID], giver_uid;
	if(punish_giver == INVALID_PLAYER_ID) 	giver_uid = -1;
	else                            		giver_uid = PlayerCache[punish_giver][pUID];
	
	mysql_query_format("INSERT INTO `"SQL_PREF"penalties` (penalty_owner, penalty_giver, penalty_type, penalty_extraid, penalty_reason, penalty_date, penalty_end) VALUES ('%d', '%d', '%d', '%d', '%s', '%d', '%d')", player_uid, giver_uid, punish_type, punish_extraid, punish_reason, punish_date, punish_end);
	return 1;
}

public LoadPlayerBans(playerid)
{
	new data[256], IP[16], ban_reason[128],
	    ban_serial[128];
	    
	GetPlayerIp(playerid, IP, sizeof(IP));
	//gpci(playerid, ban_serial, sizeof(ban_serial));
	
	mysql_query_format("SELECT `ban_reason` FROM `"SQL_PREF"bans` WHERE (ban_owner = '%d' OR ban_ip = '%s' OR ban_serial = '%s') AND ban_filter != '%d' LIMIT 1", PlayerCache[playerid][pGID], IP, ban_serial, PlayerCache[playerid][pGID]);

   	mysql_store_result();
   	if(mysql_fetch_row_format(data, "|"))
   	{
   	    sscanf(data, "p<|>s[128]", ban_reason);
   	   	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Zosta�e� zbanowany, pow�d: %s\nMo�esz z�o�y� apelacje na forum: "WEB_URL".", ban_reason);

		PlayerCache[playerid][pBanned] = true;
		defer OnKickPlayer(playerid);
   	}
   	mysql_free_result();
	return 1;
}

public CreatePackage(PackageDoorUID, PackageItemName[], PackageItemType, PackageItemValue1, PackageItemValue2, PackageItemNumber, PackageItemPrice, PackageType)
{
	new package_id, package_uid;
	mysql_query_format("INSERT INTO `"SQL_PREF"packages` (`package_dooruid`, `package_item_name`, `package_item_type`, `package_item_value1`, `package_item_value2`, `package_item_count`, `package_item_price`, `package_type`) VALUES ('%d', '%s', '%d', '%d', '%d', '%d', '%d', '%d')", PackageDoorUID, PackageItemName, PackageItemType, PackageItemValue1, PackageItemValue2, PackageItemNumber, PackageItemPrice, PackageType);

	package_uid = mysql_insert_id();
	package_id = Iter_Free(Package);

	PackageCache[package_id][pUID] = package_uid;
	PackageCache[package_id][pDoorUID] = PackageDoorUID;

	strmid(PackageCache[package_id][pItemName], PackageItemName, 0, strlen(PackageItemName), 32);
	PackageCache[package_id][pItemType] = PackageItemType;

	PackageCache[package_id][pItemValue1] = PackageItemValue1;
	PackageCache[package_id][pItemValue2] = PackageItemValue2;

	PackageCache[package_id][pItemCount] = PackageItemNumber;
	PackageCache[package_id][pItemPrice] = PackageItemPrice;

	PackageCache[package_id][pType] = PackageType;
	Iter_Add(Package, package_id);
	
	return package_id;
}

public LoadPackages()
{
	new data[64], package_id;
	mysql_query(connHandle, "SELECT * FROM `"SQL_PREF"packages`");

	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
	    package_id ++;

	    sscanf(data, "p<|>dds[32]dddddd",
	    PackageCache[package_id][pUID],
	    PackageCache[package_id][pDoorUID],

	    PackageCache[package_id][pItemName],
	    PackageCache[package_id][pItemType],

	    PackageCache[package_id][pItemValue1],
	    PackageCache[package_id][pItemValue2],

	    PackageCache[package_id][pItemCount],
		PackageCache[package_id][pItemPrice],

		PackageCache[package_id][pType]);
		Iter_Add(Package, package_id);
	}
	mysql_free_result();
	return 1;
}

public DeletePackage(package_id)
{
	mysql_query_format("DELETE FROM `"SQL_PREF"packages` WHERE package_uid = '%d' LIMIT 1", PackageCache[package_id][pUID]);

	PackageCache[package_id][pUID] = 0;
	PackageCache[package_id][pDoorUID] = 0;

	PackageCache[package_id][pItemType] = 0;

	PackageCache[package_id][pItemValue1] = 0;
	PackageCache[package_id][pItemValue2] = 0;

	PackageCache[package_id][pItemCount] = 0;
	PackageCache[package_id][pItemPrice] = 0;

	PackageCache[package_id][pType] = PACKAGE_NONE;
	Iter_Remove(Package, package_id);
	return package_id;
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
	    if(CarInfo[vehid][cGlass])
	    {
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
	    }
	    else
	    {
	        goto normal_chat;
	    }
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
					
					if(PlayerCache[i][pBW] && col1 != COLOR_PURPLE && col1 != COLOR_DO ||
					WorldID != WorldID2 ||
					col1 == COLOR_GREY && !PlayerCache[i][pOOC] ||
					IsPlayerInAnyVehicle(i) && CarInfo[GetPlayerVehicleID(i)][cGlass] && col1 == COLOR_FADE1) continue;

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

public UpdatePlayerStatus(playerid)
{
	new player_status = PlayerCache[playerid][pStatus],
		name_string[32], status_string[256];
	
	if(PlayerCache[playerid][pItemMask] == INVALID_ITEM_ID)	format(name_string, sizeof(name_string), "%s (%d)", PlayerName(playerid), playerid);
	else													format(name_string, sizeof(name_string), "%s", PlayerName(playerid));
	
    for(new status_id = 0; status_id < sizeof(StatusInfo); status_id++)
	{
	    if(StatusInfo[status_id][sType] & player_status)
	    {
	        if(StatusInfo[status_id][sType] & STATUS_TYPE_AFK)
	        {
	            new hour, minute;
	            gettime(hour, minute);
	            
	        	format(status_string, sizeof(status_string), "%s, %s %02d:%02d", status_string, StatusInfo[status_id][sName], hour, minute);
			}
			else
			{
  				format(status_string, sizeof(status_string), "%s, %s", status_string, StatusInfo[status_id][sName]);
			}
	    }
	}
	
	if(strlen(status_string))
	{
		strdel(status_string, 0, 2);
		format(status_string, sizeof(status_string), "%s\n(%s)", name_string, status_string);
	}
	else
	{
	    format(status_string, sizeof(status_string), "%s", name_string);
	}
	
	new player_color = Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pNameTag], E_STREAMER_COLOR);
	UpdateDynamic3DTextLabelText(Text3D:PlayerCache[playerid][pNameTag], player_color, status_string);
	return 1;
}

public CreatePlayerCorpse(playerid, killer_uid, weapon_uid)
{
	new	Float:PosX, Float:PosY, Float:PosZ, Float:PosA, InteriorID, VirtualWorldID,
	    date = gettime(), corpse_uid, corpse_death = PlayerCache[playerid][pDeathType], corpse_name[32];

	GetPlayerPos(playerid, PosX, PosY, PosZ);
	GetPlayerFacingAngle(playerid, PosA);

	InteriorID = GetPlayerInterior(playerid);
	VirtualWorldID = GetPlayerVirtualWorld(playerid);

	if(PlayerCache[playerid][pDocuments])	format(corpse_name, sizeof(corpse_name), "Zwloki %s", PlayerRealName(playerid));
	else                                    corpse_name = "Zwloki (niezidentyfikowane)";

	mysql_query_format("INSERT INTO `"SQL_PREF"corpses` (corpse_owner, corpse_death, corpse_killer, corpse_weapon, corpse_date) VALUES ('%d', '%d', '%d', '%d', '%d')", PlayerCache[playerid][pUID], corpse_death, killer_uid, weapon_uid, date);
	corpse_uid = mysql_insert_id();

	new item_uid, object_id;
	mysql_query_format("INSERT INTO `"SQL_PREF"items` (item_name, item_type, item_value1, item_place, item_owner, item_posx, item_posy, item_posz, item_interior, item_world) VALUES ('%s', '%d', '%d', '%d', '0', '%f', '%f', '%f', '%d', '%d')", corpse_name, ITEM_CORPSE, corpse_uid, PLACE_NONE, PosX, PosY, PosZ, InteriorID, VirtualWorldID);

	item_uid = mysql_insert_id();
	object_id = CreateDynamicObject(ItemTypeInfo[ITEM_CORPSE][iTypeObjModel], PosX, PosY, PosZ - 1.0, ItemTypeInfo[ITEM_CORPSE][iTypeObjRotX], ItemTypeInfo[ITEM_CORPSE][iTypeObjRotY], -PosA, VirtualWorldID, InteriorID, -1, MAX_DRAW_DISTANCE);

	Streamer_SetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID, item_uid * -1);
	return 1;
}

/*
public OnMysqlError(error[], errorid, MySQL:handle)
{
	printf("[mysql] [error: %d] - %s", errorid, error);
	return 1;
}
*/

/*
public OnMysqlQuery(resultid, spareid, MySQL:handle)
{
	return 1;
}
*/

/* Komendy */
CMD:qs(playerid, params[])
{
	new string[128],
	    Float:PosX, Float:PosY, Float:PosZ;
	    
    format(string, sizeof(string), "(( %s - /qs ))", PlayerRealName(playerid));
    GetPlayerPos(playerid, PosX, PosY, PosZ);

	PlayerCache[playerid][pPosX] = PosX;
	PlayerCache[playerid][pPosY] = PosY;
	PlayerCache[playerid][pPosZ] = PosZ;

	PlayerCache[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
	PlayerCache[playerid][pInteriorID] = GetPlayerInterior(playerid);
	
	new Text3D:reason_label = CreateDynamic3DTextLabel(string, 0xB4B5B766, PosX, PosY, PosZ + 0.3, 15.0);
	defer OnDestroyReasonLabel[15000](_:reason_label);

	PlayerCache[playerid][pCrash] = gettime();
	OnPlayerSave(playerid, SAVE_PLAYER_POS);

	defer OnKickPlayer(playerid);
	return 1;
}

CMD:stats(playerid, params[])
{
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowPlayerStatsForPlayer(playerid, playerid);
	    return 1;
	}
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerStatsForPlayer(playerid, playerid);
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    return 1;
	}
	ShowPlayerStatsForPlayer(giveplayer_id, playerid);
	return 1;
}

CMD:staty(playerid, params[]) return cmd_stats(playerid, params);

CMD:pomoc(playerid, params[])
{
	new list_help[256];
	strcat(list_help, "� Wprowadzenie\n", sizeof(list_help));
	strcat(list_help, "� Komendy podstawowe\n", sizeof(list_help));
	
	strcat(list_help, "� Pojazd\n", sizeof(list_help));
	strcat(list_help, "� Ekwipunek\n", sizeof(list_help));
	
	strcat(list_help, "� Praca dorywcza\n", sizeof(list_help));
	strcat(list_help, "� Animacje\n", sizeof(list_help));
	
	strcat(list_help, "� Dost�pne oferty\n", sizeof(list_help));
	
	if(IsPlayerInAnyGroup(playerid))	strcat(list_help, "� Grupy\n", sizeof(list_help));
	if(PlayerCache[playerid][pAdmin])	strcat(list_help, "� Administracja\n", sizeof(list_help));
	
	PlayerCache[playerid][pMainTable] = 0;
	ShowPlayerDialog(playerid, D_HELP_MAIN, DIALOG_STYLE_LIST, "Pomoc g��wna", list_help, "Wybierz", "Anuluj");
	return 1;
}

CMD:help(playerid, params[])  return cmd_pomoc(playerid, params);

CMD:ag(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_GROUPS))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz zarz�dza� grupami.");
 		return 1;
	}
	new type[32], varchar[64], string[256];
	if(sscanf(params, "s[32]S()[64]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/ag [stworz, lider, lista, nazwa, usun, info, typ, wypros, zapros]");
	    return 1;
	}
	if(!strcmp(type, "stworz", true) || !strcmp(type, "create", true))
	{
	    new group_name[32];
	    if(sscanf(varchar, "s[32]", group_name))
	    {
	        ShowTipForPlayer(playerid, "/ag stworz [Nazwa grupy]");
	        return 1;
	    }
	    
	    new group_id = CreateGroup(group_name);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pomy�lnie utworzono grup� o nazwie %s (UID: %d).", GroupData[group_id][gName], GroupData[group_id][gUID]);
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
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
	        return 1;
	    }
    	if(giveplayer_id == INVALID_PLAYER_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		   	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(IsPlayerInGroup(giveplayer_id, GroupData[group_id][gUID]) || (GroupData[group_id][gOwner] && IsPlayerInGroup(giveplayer_id, GroupData[group_id][gOwner])))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nale�y ju� do tej grupy lub jej podgrupy.");
		    return 1;
		}
		new group_slot = GetPlayerFreeGroupSlot(giveplayer_id);
		if(group_slot == INVALID_SLOT_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie posiada �adnego wolnego slotu dla grupy.");
		    return 1;
		}
		PlayerGroup[giveplayer_id][group_slot][gpUID] = GroupData[group_id][gUID];
		PlayerGroup[giveplayer_id][group_slot][gpID] = group_id;

		PlayerGroup[giveplayer_id][group_slot][gpPerm] = G_PERM_MAX;
		mysql_query_format("INSERT INTO `"SQL_PREF"char_groups` (`char_uid`, `group_belongs`, `group_perm`) VALUES ('%d', '%d', '%d')", PlayerCache[giveplayer_id][pUID], GroupData[group_id][gUID], G_PERM_MAX);

		ShowPlayerInfoDialog(giveplayer_id, D_TYPE_INFO, "Administrator %s przypisa� Ci lidera grupy %s (SampID: %d, UID: %d).\nSkorzystaj z komendy /pomoc, by zapozna� si� z komendami lidera.", PlayerName(playerid), GroupData[group_id][gName], group_id, GroupData[group_id][gUID]);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Gracz %s (ID: %d, UID: %d) otrzyma� lidera grupy %s (SampID: %d, UID: %d).", PlayerName(giveplayer_id), giveplayer_id, PlayerCache[giveplayer_id][pUID], GroupData[group_id][gName], group_id, GroupData[group_id][gUID]);
		return 1;
	}
	if(!strcmp(type, "nazwa", true) || !strcmp(type, "name", true))
	{
	    new group_uid, group_name[32];
	    if(sscanf(varchar, "ds[32]", group_uid, group_name))
	    {
	        ShowTipForPlayer(playerid, "/ag nazwa [UID grupy] [Nowa nazwa]");
	        return 1;
	    }
	    new group_id = GetGroupID(group_uid);
	    if(group_id == INVALID_GROUP_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
	        return 1;
	    }
	    mysql_real_escape_string(group_name, GroupData[group_id][gName]);
	    
		SaveGroup(group_id);
	    ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Nazwa grupy (UID: %d) zosta�a zmieniona pomy�lnie.\nNowa nazwa: %s", GroupData[group_id][gUID], group_name);
		return 1;
	}
	if(!strcmp(type, "usun", true) || !strcmp(type, "delete", true))
	{
	    new group_uid;
	    if(sscanf(varchar, "d", group_uid))
	    {
	        ShowTipForPlayer(playerid, "/ag usun [UID grupy]");
	        return 1;
	    }
	    new group_id = GetGroupID(group_uid);
	    if(group_id == INVALID_GROUP_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
	        return 1;
	    }
	    printf("[admin][grou] %s (UID: %d, GID: %d) usun�� grup� %s (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], GroupData[group_id][gName], GroupData[group_id][gUID]);
	    
	    DeleteGroup(group_id);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Grupa zosta�a pomy�lnie usuni�ta z bazy danych.");
	    return 1;
	}
	if(!strcmp(type, "info", true))
	{
	    new group_uid;
	    if(sscanf(varchar, "d", group_uid))
	    {
	        ShowTipForPlayer(playerid, "/ag info [UID grupy]");
	        return 1;
	    }
	    new group_id = GetGroupID(group_uid);
	    if(group_id == INVALID_GROUP_ID)
	    {
            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
	        return 1;
	    }
	    ShowPlayerGroupInfo(playerid, group_id);
	    return 1;
	}
	if(!strcmp(type, "typ", true))
	{
 		new group_uid;
	    if(sscanf(varchar, "d", group_uid))
	    {
	        ShowTipForPlayer(playerid, "/ag typ [UID grupy]");
	        return 1;
	    }
	    new group_id = GetGroupID(group_uid);
	    if(group_id == INVALID_GROUP_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
	        return 1;
	    }
	    PlayerCache[playerid][pMainTable] = group_id;

		new list_group_type[512];
		for (new i = 0; i < sizeof(GroupTypeInfo); i++)
		{
		    format(list_group_type, sizeof(list_group_type), "%s\n%d\t%s", list_group_type, i + 1, GroupTypeInfo[i][gTypeName]);
		}

		format(string, sizeof(string), "%s (UID: %d) � Zmiana typu", GroupData[group_id][gName], GroupData[group_id][gUID]);
		ShowPlayerDialog(playerid, D_GROUP_TYPE, DIALOG_STYLE_LIST, string, list_group_type, "Wybierz", "Anuluj");
	    return 1;
	}
	if(!strcmp(type, "wypros", true) || !strcmp(type, "uninvite", true))
	{
		new giveplayer_id, group_uid;
		if(sscanf(varchar, "ud", giveplayer_id, group_uid))
		{
		    ShowTipForPlayer(playerid, "/ag wypros [ID gracza] [UID grupy]");
		    return 1;
		}
 		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
   			return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
  		new group_id = GetGroupID(group_uid);
	    if(group_id == INVALID_GROUP_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
	        return 1;
	    }
		if(!IsPlayerInGroup(giveplayer_id, GroupData[group_id][gUID]))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie jest cz�onkiem tej grupy.");
		    return 1;
		}
		new group_slot = GetPlayerGroupSlot(giveplayer_id, GroupData[group_id][gUID]);

		if(PlayerCache[giveplayer_id][pDutyGroup] == GroupData[group_id][gUID])
		{
		    UpdatePlayerSession(giveplayer_id, SESSION_GROUP, PlayerCache[giveplayer_id][pDutyGroup]);

		    PlayerCache[giveplayer_id][pDutyGroup] = 0;
		    PlayerCache[giveplayer_id][pSession][SESSION_GROUP] = 0;
		}

  		PlayerGroup[giveplayer_id][group_slot][gpUID] = 0;
    	PlayerGroup[giveplayer_id][group_slot][gpID] = 0;

		PlayerGroup[giveplayer_id][group_slot][gpPerm] = 0;
  		strmid(PlayerGroup[giveplayer_id][group_slot][gpTitle], "Brak", 0, 4, 32);

		PlayerGroup[giveplayer_id][group_slot][gpPayment] = 0;
		mysql_query_format("DELETE FROM `"SQL_PREF"char_groups` WHERE char_uid = '%d' AND group_belongs = '%d'", PlayerCache[giveplayer_id][pUID], GroupData[group_id][gUID]);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Wyprosi�e� gracza %s z grupy %s (UID: %d).", PlayerName(giveplayer_id), GroupData[group_id][gName], GroupData[group_id][gUID]);
		ShowPlayerInfoDialog(giveplayer_id, D_TYPE_INFO, "Administrator %s wyprosi� Ci� z grupy %s (UID: %d).", PlayerName(playerid), GroupData[group_id][gName], GroupData[group_id][gUID]);
	    return 1;
	}
	if(!strcmp(type, "zapros", true) || !strcmp(type, "invite", true))
	{
		new giveplayer_id, group_uid;
		if(sscanf(varchar, "ud", giveplayer_id, group_uid))
		{
		    ShowTipForPlayer(playerid, "/ag zapros [ID gracza] [UID grupy]");
		    return 1;
		}
 		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
   			return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
  		new group_id = GetGroupID(group_uid);
	    if(group_id == INVALID_GROUP_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
	        return 1;
	    }
	    if(IsPlayerInGroup(giveplayer_id, GroupData[group_id][gUID]))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nale�y ju� do tej grupy.");
	        return 1;
	    }
		new group_slot = GetPlayerFreeGroupSlot(giveplayer_id);
		if(group_slot == INVALID_SLOT_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie posiada �adnego wolnego slotu dla grupy.");
		    return 1;
		}
		PlayerGroup[giveplayer_id][group_slot][gpUID] = GroupData[group_id][gUID];
		PlayerGroup[giveplayer_id][group_slot][gpID] = group_id;

	    mysql_query_format("INSERT INTO `"SQL_PREF"char_groups` (`char_uid`, `group_belongs`) VALUES ('%d', '%d')", PlayerCache[giveplayer_id][pUID], GroupData[group_id][gUID]);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Zaprosi�e� gracza %s do grupy %s (UID: %d).", PlayerName(giveplayer_id), GroupData[group_id][gName], GroupData[group_id][gUID]);
		ShowPlayerInfoDialog(giveplayer_id, D_TYPE_INFO, "Administrator %s zaprosi� Ci� do grupy %s (UID: %d).", PlayerName(playerid), GroupData[group_id][gName], GroupData[group_id][gUID]);
	    return 1;
	}
	return 1;
}

CMD:g(playerid, params[])
{
	new group_slot = INVALID_SLOT_ID, type[32], varchar[64];
	// if(isnull(params))	SendClientMessage(playerid, COLOR_GREY, "Je�eli jeste� na s�u�bie jednej z grup, nie musisz podawa� jej slotu - skrypt automatycznie go wyszuka.");

	if(sscanf(params, "ds[32]S()[64]", group_slot, type, varchar))
	{
		ShowTipForPlayer(playerid, "/g {slot (1-%d)} [info, online, duty, przebierz, zapros, wypros, wplac, wyplac, pojazdy, respawn, magazyn]", MAX_GROUP_SLOTS);
		
		if(IsPlayerInAnyGroup(playerid))
		{
			new string[128], group_id;
			GivePlayerAchievement(playerid, ACHIEVE_GROUP);
			TextDrawShowForPlayer(playerid, Text:TextDrawGroupsTitle);

			for (new slot = 0; slot < MAX_GROUP_SLOTS; slot++)
			{
			    if(PlayerGroup[playerid][slot][gpUID])
				{
			        group_id = PlayerGroup[playerid][slot][gpID];
			        if(PlayerCache[playerid][pDutyGroup] == GroupData[group_id][gUID])
			        {
			        	format(string, sizeof(string), "~g~~h~%d_____%s (%d)", slot + 1, GroupData[group_id][gName], GroupData[group_id][gUID]);
					}
					else
					{
					    format(string, sizeof(string), "%d_____%s (%d)", slot + 1, GroupData[group_id][gName], GroupData[group_id][gUID]);
					}
					PlayerTextDrawSetString(playerid, PlayerText:TextDrawGroups[playerid][slot], string);
					PlayerTextDrawShow(playerid, PlayerText:TextDrawGroups[playerid][slot]);

                    if(PlayerGroup[playerid][slot][gpPerm] & G_PERM_LEADER)   	GivePlayerAchievement(playerid, ACHIEVE_LEADER);
					for(new option_id = 0; option_id < 5; option_id++)			TextDrawShowForPlayer(playerid, Text:TextDrawGroupOption[slot][option_id]);
				}
			}
			SelectTextDraw(playerid, COLOR_RED);
		}
		else
		{
		    TD_ShowSmallInfo(playerid, 3, "Nie jestes czlonkiem ~r~zadnej ~w~grupy.");
		}
		return 1;
	}
	group_slot -= 1;
	if(group_slot < 0 || group_slot >= MAX_GROUP_SLOTS)
	{
	    GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
	    return 1;
	}
	if(!PlayerGroup[playerid][group_slot][gpUID])
	{
	    GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
	    return 1;
	}
	if(!strcmp(type, "info", true))
	{
	    new group_id = PlayerGroup[playerid][group_slot][gpID];
	    ShowPlayerGroupInfo(playerid, group_id);
	    return 1;
	}
	if(!strcmp(type, "online", true))
	{
  		new list_workers[1024];
    	foreach(new i : Player)
	    {
	        if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	        {
       			if(IsPlayerInGroup(i, PlayerGroup[playerid][group_slot][gpUID]))
				{
				    if(PlayerCache[i][pDutyGroup] == PlayerGroup[playerid][group_slot][gpUID])
				    {
						format(list_workers, sizeof(list_workers), "%s\n%d\t\t{008000}%s{FFFFFF}", list_workers, i, PlayerName(i));
					}
					else
					{
					    format(list_workers, sizeof(list_workers), "%s\n%d\t\t%s", list_workers, i, PlayerName(i));
					}
				}
        	}
	    }
	    
		ShowPlayerDialog(playerid, D_PLAYER_LIST, DIALOG_STYLE_LIST, "Cz�onkowie online:", list_workers, "PW", "Zamknij");
		return 1;
	}
	if(!strcmp(type, "sluzba", true) || !strcmp(type, "duty", true))
	{
		if(OfferData[playerid][oCustomerID] != INVALID_PLAYER_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz skorzysta� ze s�u�by zaraz po wys�aniu oferty.");
		    return 1;
		}
	    new group_id = PlayerGroup[playerid][group_slot][gpID];
	    if(PlayerCache[playerid][pDutyGroup])
	    {
			new group_activity = (floatround((gettime() - PlayerCache[playerid][pSession][SESSION_GROUP]) / 60)) * 3;
	    
   			GroupData[group_id][gActivity] += group_activity;
      		SaveGroup(group_id);
	    
	        if(PlayerCache[playerid][pDutyGroup] == GroupData[group_id][gUID])
	        {
        		new	duty_hours = floatround((gettime() - PlayerCache[playerid][pSession][SESSION_GROUP]) / 3600, floatround_floor),
					duty_minutes = floatround((gettime() - PlayerCache[playerid][pSession][SESSION_GROUP]) / 60, floatround_floor) % 60;
	        
	            UpdatePlayerSession(playerid, SESSION_GROUP, PlayerCache[playerid][pDutyGroup]);
	            
	            PlayerCache[playerid][pDutyGroup] = 0;
	            PlayerCache[playerid][pSession][SESSION_GROUP] = 0;

	            PlayerCache[playerid][pNickColor] = COLOR_NICK;
	            Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pNameTag], E_STREAMER_COLOR, PlayerCache[playerid][pNickColor]);
	            
				PlayerTextDrawHide(playerid, TextDrawDuty[playerid]);
	            SendClientFormatMessage(playerid, GroupData[group_id][gColor], "� Zszed�e� ze s�u�by grupy %s (UID: %d). Czas trwania sesji: %dh %dm.", GroupData[group_id][gName], GroupData[group_id][gUID], duty_hours, duty_minutes);
	            return 1;
	        }
	        else
			{
	            UpdatePlayerSession(playerid, SESSION_GROUP, PlayerCache[playerid][pDutyGroup]);
	        }
	    }
	    
	    PlayerCache[playerid][pDutyGroup] = GroupData[group_id][gUID];
	    PlayerCache[playerid][pSession][SESSION_GROUP] = gettime();
	    
	    new group_color = (GroupData[group_id][gColor] & 0xFFFFFF00) + 136,
			start_hour, start_minute;
			
		gettime(start_hour, start_minute);
        if(GroupData[group_id][gFlags] & G_FLAG_COLOR)
        {
            if(GroupData[group_id][gColor] != -1)
            {
			    PlayerCache[playerid][pNickColor] = group_color;
			    Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pNameTag], E_STREAMER_COLOR, PlayerCache[playerid][pNickColor]);
			}
		}
		TD_ShowLargeInfo(playerid, 10, "Sluzba: ~b~~h~grupa               ~y~%s (UID: %d)~n~~n~~w~Rozpoczeto: ~g~~h~%02d:%02d          ~w~Tytul: ~r~~h~%s", GroupData[group_id][gName], GroupData[group_id][gUID], start_hour, start_minute, PlayerGroup[playerid][group_slot][gpTitle]);
	    SendClientFormatMessage(playerid, GroupData[group_id][gColor], "� Wszed�e� na s�u�b� grupy %s (UID: %d). Aby zej�� ze s�u�by wpisz /g %d duty.", GroupData[group_id][gName], GroupData[group_id][gUID], group_slot + 1);

		PlayerTextDrawSetString(playerid, TextDrawDuty[playerid], GroupData[group_id][gTag]);
		PlayerTextDrawBackgroundColor(playerid, TextDrawDuty[playerid], group_color);

		PlayerTextDrawShow(playerid, TextDrawDuty[playerid]);
		return 1;
	}
	if(!strcmp(type, "przebierz", true))
	{
		if(PlayerGroup[playerid][group_slot][gpSkin])
		{
		    SetPlayerSkinEx(playerid, PlayerGroup[playerid][group_slot][gpSkin]);
		}
		else
		{
		    TD_ShowSmallInfo(playerid, 3, "Nie posiadasz ~r~tego ~w~ubrania.");
		}
		return 1;
	}
	if(!strcmp(type, "zapros", true) || !strcmp(type, "invite", true))
	{
	    if(!(PlayerGroup[playerid][group_slot][gpPerm] & G_PERM_LEADER))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz uprawnie� lidera grupy.");
			return 1;
	    }
	    new giveplayer_id;
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/g {slot (1-%d)} zapros [ID gracza]", MAX_GROUP_SLOTS);
	        return 1;
	    }
	    if(giveplayer_id == INVALID_PLAYER_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	        return 1;
	    }
	    if(!PlayerCache[giveplayer_id][pLogged])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	        return 1;
	    }
	    if(giveplayer_id == playerid)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zatrudni� siebie.");
	        return 1;
	    }
	    new group_id = PlayerGroup[playerid][group_slot][gpID];
	    if(IsPlayerInGroup(giveplayer_id, GroupData[group_id][gUID]))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nale�y ju� do tej grupy.");
	        return 1;
	    }
		new giveplayer_group_slot = GetPlayerFreeGroupSlot(giveplayer_id);
		if(giveplayer_group_slot == INVALID_SLOT_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie posiada �adnego wolnego slotu dla grupy.");
		    return 1;
		}
		PlayerGroup[giveplayer_id][giveplayer_group_slot][gpUID] = GroupData[group_id][gUID];
		PlayerGroup[giveplayer_id][giveplayer_group_slot][gpID] = group_id;
		
	    mysql_query_format("INSERT INTO `"SQL_PREF"char_groups` (`char_uid`, `group_belongs`) VALUES ('%d', '%d')", PlayerCache[giveplayer_id][pUID], GroupData[group_id][gUID]);
		
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Zaprosi�e� gracza %s do grupy %s (UID: %d).\nPami�taj, by ustawi� mu odpowiednie uprawnienia w panelu grupy.", PlayerName(giveplayer_id), GroupData[group_id][gName], GroupData[group_id][gUID]);
		SendClientFormatMessage(giveplayer_id, GroupData[group_id][gColor], "Gracz %s zaprosi� Ci� do grupy %s (UID: %d).", PlayerName(playerid), GroupData[group_id][gName], GroupData[group_id][gUID]);

		printf("[grou] %s (UID: %d, GID: %d) zaprosi� %s (UID: %d, GID: %d) do grupy %s (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], PlayerRealName(giveplayer_id), PlayerCache[giveplayer_id][pUID], PlayerCache[giveplayer_id][pGID], GroupData[group_id][gName], GroupData[group_id][gUID]);
		return 1;
	}
	if(!strcmp(type, "wypros", true) || !strcmp(type, "uninvite", true))
	{
		if(!(PlayerGroup[playerid][group_slot][gpPerm] & G_PERM_LEADER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz uprawnie� lidera grupy.");
	    	return 1;
		}
		new giveplayer_id;
		if(sscanf(varchar, "u", giveplayer_id))
		{
			ShowTipForPlayer(playerid, "/g {slot (1-%d)} wypros [ID gracza]", MAX_GROUP_SLOTS);
		    return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
   			return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(giveplayer_id == playerid)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wyprosi� siebie.");
		    return 1;
		}
		new group_id = PlayerGroup[playerid][group_slot][gpID];
		if(!IsPlayerInGroup(giveplayer_id, GroupData[group_id][gUID]))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie jest cz�onkiem tej grupy.");
		    return 1;
		}
		new giveplayer_group_slot = GetPlayerGroupSlot(giveplayer_id, GroupData[group_id][gUID]);
		
		if(PlayerCache[giveplayer_id][pDutyGroup] == GroupData[group_id][gUID])
		{
		    UpdatePlayerSession(giveplayer_id, SESSION_GROUP, PlayerCache[giveplayer_id][pDutyGroup]);
		    
		    PlayerCache[giveplayer_id][pDutyGroup] = 0;
		    PlayerCache[giveplayer_id][pSession][SESSION_GROUP] = 0;
		}

  		PlayerGroup[giveplayer_id][giveplayer_group_slot][gpUID] = 0;
    	PlayerGroup[giveplayer_id][giveplayer_group_slot][gpID] = 0;

		PlayerGroup[giveplayer_id][giveplayer_group_slot][gpPerm] = 0;
  		strmid(PlayerGroup[giveplayer_id][giveplayer_group_slot][gpTitle], "Brak", 0, 4, 32);

		PlayerGroup[giveplayer_id][giveplayer_group_slot][gpPayment] = 0;
		mysql_query_format("DELETE FROM `"SQL_PREF"char_groups` WHERE char_uid = '%d' AND group_belongs = '%d'", PlayerCache[giveplayer_id][pUID], GroupData[group_id][gUID]);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Wyprosi�e� gracza %s z grupy %s (UID: %d).", PlayerName(giveplayer_id), GroupData[group_id][gName], GroupData[group_id][gUID]);
		SendClientFormatMessage(giveplayer_id, GroupData[group_id][gColor], "Gracz %s wyprosi� Ci� z grupy %s (UID: %d).", PlayerName(playerid), GroupData[group_id][gName], GroupData[group_id][gUID]);

        printf("[grou] %s (UID: %d, GID: %d) wyprosi� %s (UID: %d, GID: %d) z grupy %s (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], PlayerRealName(giveplayer_id), PlayerCache[giveplayer_id][pUID], PlayerCache[giveplayer_id][pGID], GroupData[group_id][gName], GroupData[group_id][gUID]);
		return 1;
	}
	if(!strcmp(type, "wyplac", true))
	{
		if(!(PlayerGroup[playerid][group_slot][gpPerm] & G_PERM_LEADER))
		{
	    	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie�, aby u�y� tej komendy.");
	    	return 1;
		}
	   	new price;
	   	if(sscanf(varchar, "d", price))
	   	{
	   	    ShowTipForPlayer(playerid, "/g [slot (1-5)] wyplac [Kwota]");
	   	    return 1;
	   	}
		new doorid = GetPlayerDoorID(playerid);
		if(doorid == INVALID_DOOR_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w banku.");
		    return 1;
		}
	 	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
	  	{
	   		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w banku.");
	   		return 1;
	   	}
	   	new at_group_id = GetGroupID(DoorCache[doorid][dOwner]);
	   	if(GroupData[at_group_id][gType] != G_TYPE_BANK)
	   	{
	   	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w banku.");
	   	    return 1;
	   	}
	   	if(price <= 0)
	   	{
	   	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
	   	    return 1;
	   	}
	   	new group_id = PlayerGroup[playerid][group_slot][gpID];
	   	if(price > GroupData[group_id][gCash])
	   	{
	   	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz takiej ilo�ci got�wki na koncie biznesu.");
	   	    return 1;
	   	}
	   	if(PlayerCache[playerid][pHours] < 5)
	   	{
	   	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wyp�aca� pieni�dzy dop�ki nie przegrasz 5h.");
	   	    return 1;
	   	}
	   	crp_GivePlayerMoney(playerid, price);
	   	OnPlayerSave(playerid, SAVE_PLAYER_BASIC);

	   	GroupData[group_id][gCash] -= price;
	   	SaveGroup(group_id);

		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Wyp�aci�e� pieni�dze z konta grupy.\n\nZ konta grupy zosta�o wyp�acone: $%d\nPozosta�e �rodki na koncie: $%d", price, GroupData[group_id][gCash]);

		printf("[cash] %s (UID: %d, GID: %d) wyp�aci� $%d z konta grupy %s (UID: %d). Na koncie pozosta�o: $%d", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], price, GroupData[group_id][gName], GroupData[group_id][gUID], GroupData[group_id][gCash]);
		return 1;
	}
	if(!strcmp(type, "wplac", true))
	{
		if(!(PlayerGroup[playerid][group_slot][gpPerm] & G_PERM_LEADER))
		{
	    	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie�, aby u�y� tej komendy.");
	    	return 1;
		}
	   	new price;
	   	if(sscanf(varchar, "d", price))
	   	{
	   	    ShowTipForPlayer(playerid, "/g [slot (1-5)] wplac [Kwota]");
	   	    return 1;
	   	}
		new doorid = GetPlayerDoorID(playerid);
		if(doorid == INVALID_DOOR_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w banku.");
		    return 1;
		}
	 	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
	  	{
	   		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w banku.");
	   		return 1;
	   	}
	   	new at_group_id = GetGroupID(DoorCache[doorid][dOwner]);
	   	if(GroupData[at_group_id][gType] != G_TYPE_BANK)
	   	{
	   	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w banku.");
	   	    return 1;
	   	}
	   	if(price <= 0)
	   	{
	   	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
	   	    return 1;
	   	}
	   	if(price > PlayerCache[playerid][pCash])
	   	{
	   	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
	   	    return 1;
	   	}
	   	if(PlayerCache[playerid][pHours] < 5)
	   	{
	   	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wp�aca� pieni�dzy dop�ki nie przegrasz 5h.");
	   	    return 1;
	   	}
	   	new group_id = PlayerGroup[playerid][group_slot][gpID];

		crp_GivePlayerMoney(playerid, -price);
	   	OnPlayerSave(playerid, SAVE_PLAYER_BASIC);

	   	GroupData[group_id][gCash] += price;
	   	SaveGroup(group_id);

	   	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Wp�aci�e� pieni�dze na konto grupy.\n\nNa konto grupy zosta�o wp�acone: $%d\nNowy stan konta grupy: $%d", price, GroupData[group_id][gCash]);

        printf("[cash] %s (UID: %d, GID: %d) wp�aci� $%d na konto grupy %s (UID: %d). Nowy stan konta: $%d", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], price, GroupData[group_id][gName], GroupData[group_id][gUID], GroupData[group_id][gCash]);
		return 1;
	}
	if(!strcmp(type, "pojazdy", true) || !strcmp(type, "v", true))
	{
		if(!(PlayerGroup[playerid][group_slot][gpPerm] & G_PERM_CARS))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz uprawnie� prowadzenia pojazd�w.");
	    	return 1;
		}
	    new list_vehicles[1024];
	    foreach(new vehid : Vehicles)
	    {
     		if(CarInfo[vehid][cOwnerType] == OWNER_GROUP && CarInfo[vehid][cOwner] == PlayerGroup[playerid][group_slot][gpUID])
     		{
				format(list_vehicles, sizeof(list_vehicles), "%s\n%d\t\t%s (%d)", list_vehicles, vehid, GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID]);
	 		}
	    }
	    if(strlen(list_vehicles))
	    {
	    	ShowPlayerDialog(playerid, D_TARGET_VEH, DIALOG_STYLE_LIST, "Pojazdy nale��ce do grupy:", list_vehicles, "Namierz", "Anuluj");
		}
		else
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnych pojazd�w przypisanych pod grup�.");
		}
		return 1;
	}
	if(!strcmp(type, "respawn", true) || !strcmp(type, "res", true))
	{
	    if(!(PlayerGroup[playerid][group_slot][gpPerm] & G_PERM_LEADER))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie�, aby u�y� tej komendy.");
	        return 1;
	    }
     	foreach(new vehid : Vehicles)
      	{
       		if(CarInfo[vehid][cOwnerType] == OWNER_GROUP && CarInfo[vehid][cOwner] == PlayerGroup[playerid][group_slot][gpUID])
         	{
          		if(!IsAnyPlayerInVehicle(vehid))
          		{
					SetVehicleToRespawn(vehid);
					UpdateVehicleDamageStatus(vehid, CarInfo[vehid][cVisual][0], CarInfo[vehid][cVisual][1], CarInfo[vehid][cVisual][2], CarInfo[vehid][cVisual][3]);
     			}
			}
		}
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Wszystkie nieu�ywane pojazdy grupowe zosta�y przywr�cone na miejsce spawnu.");
		return 1;
	}
	if(!strcmp(type, "magazyn", true))
	{
		new doorid = GetPlayerDoorID(playerid);
		if(doorid == INVALID_DOOR_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w budynku nale��cym do grupy.");
		    return 1;
		}
		if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w budynku nale��cym do grupy.");
			return 1;
		}
		new group_id = PlayerGroup[playerid][group_slot][gpID];
		if(DoorCache[doorid][dOwner] != GroupData[group_id][gUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek nie nale�y do tej grupy.");
		    return 1;
		}
  		ListGroupProductsForPlayer(group_id, playerid, PRODUCT_LIST_NONE);
	    return 1;
	}
	if(!strcmp(type, "czat", true))
	{
		if(!(PlayerGroup[playerid][group_slot][gpPerm] & G_PERM_LEADER))
		{
	    	ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    	return 1;
		}

		new group_id = PlayerGroup[playerid][group_slot][gpID];
		if(GroupData[group_id][gToggleChat])
		{
		    GroupData[group_id][gToggleChat] = false;
			SendClientFormatMessage(playerid, GroupData[group_id][gColor], "Czat OOC grupy %s (UID: %d) zosta� w��czony.", GroupData[group_id][gName], GroupData[group_id][gUID]);
		}
		else
		{
  			GroupData[group_id][gToggleChat] = true;
			SendClientFormatMessage(playerid, GroupData[group_id][gColor], "Czat OOC grupy %s (UID: %d) zosta� wy��czony.", GroupData[group_id][gName], GroupData[group_id][gUID]);
		}
	    return 1;
	}
	return 1;
}

CMD:apojazd(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_CARS))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz zarz�dza� pojazdami.");
	    return 1;
	}
	new type[32], varchar[32];
	if(sscanf(params, "s[32]S()[32]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/apojazd [stworz, usun, model, kolor1, kolor2, paliwo, hp, zaparkuj, zamknij, info]");
		ShowTipForPlayer(playerid, "/apojazd [res, przebieg, visual, spawn, unspawn, resall, goto, gethere, id, przypisz]");
		return 1;
	}
	if(!strcmp(type, "stworz", true) || !strcmp(type, "create", true))
	{
	    new modelid, color1, color2;
	    if(sscanf(varchar, "ddd", modelid, color1, color2))
	    {
	        ShowTipForPlayer(playerid, "/apojazd stworz [Model] [Kolor1] [Kolor2]");
	        return 1;
	    }
	    if(modelid < 400 || modelid > 611)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Model pojazdu nie mo�e by� mniejszy ni� 400 oraz wi�kszy od 611.");
	        return 1;
	    }
     	if(color1 < 0 || color1 > 255 || color2 < 0 || color2 > 255)
      	{
      	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "ID koloru nie mo�e by� mniejsze ni� 0 a tak�e wi�ksze od 255.");
         	return 1;
       	}
        new Float:PosX, Float:PosY, Float:PosZ, veh_uid;
        
        GetPlayerPos(playerid, PosX, PosY, PosZ);
        veh_uid = CreateStaticVehicle(modelid, PosX + 2, PosY, PosZ, 0.0, color1, color2, 3600);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd zosta� stworzony pomy�lnie (UID: %d).", veh_uid);
		return 1;
	}
	if(!strcmp(type, "usun", true) || !strcmp(type, "del", true))
	{
	    new vehid;
 		if(sscanf(varchar, "d", vehid))
	    {
	        ShowTipForPlayer(playerid, "/apojazd usun [ID pojazdu]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
     	DeleteVehicle(vehid);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd zosta� pomy�lnie usuni�ty z bazy danych.");
		return 1;
	}
	if(!strcmp(type, "model", true))
	{
	    new vehid, modelid;
	    if(sscanf(varchar, "dd", vehid, modelid))
	    {
	        ShowTipForPlayer(playerid, "/apojazd model [ID pojazdu] [Model]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
	    if(modelid < 400 || modelid > 611)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Model pojazdu nie mo�e by� mniejszy ni� 400 oraz wi�kszy od 611.");
	        return 1;
	    }
     	new Float:VehPosX, Float:VehPosY, Float:VehPosZ, Float:VehPosA,
     	    veh_uid = CarInfo[vehid][cUID];
     	
      	GetVehiclePos(vehid, VehPosX, VehPosY, VehPosZ);
       	GetVehicleZAngle(vehid, VehPosA);

		CarInfo[vehid][cModel] = modelid;
		CarInfo[vehid][cFuel] = GetVehicleMaxFuel(modelid);
		SaveVehicle(vehid, SAVE_VEH_THINGS);
		
		DestroyVehicle(vehid);
		Iter_Remove(Vehicles, vehid);
		
		vehid = LoadVehicle(veh_uid);
		
		SetVehiclePos(vehid, VehPosX, VehPosY, VehPosZ);
		SetVehicleZAngle(vehid, VehPosA);
		
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Model pojazdu zosta� zmieniony pomy�lnie. Nowy model: %d (%s)", modelid, GetVehicleName(modelid));
		return 1;
	}
	if(!strcmp(type, "kolor1", true) || !strcmp(type, "color1", true))
	{
	    new vehid, color1;
	    if(sscanf(varchar, "dd", vehid, color1))
	    {
	        ShowTipForPlayer(playerid, "/apojazd kolor1 [ID pojazdu] [Kolor 1]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
    	if(color1 < 0 || color1 > 255)
      	{
       		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "ID koloru nie mo�e by� mniejsze ni� 0 a tak�e wi�ksze od 255.");
         	return 1;
       	}
		CarInfo[vehid][cColor1] = color1;
		ChangeVehicleColor(vehid, CarInfo[vehid][cColor1], CarInfo[vehid][cColor2]);

		SaveVehicle(vehid, SAVE_VEH_ACCESS);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Kolor pojazdu zosta� pomy�lnie zmieniony. Nowy kolor: %d", color1);
		return 1;
	}
	if(!strcmp(type, "kolor2", true))
	{
	    new vehid, color2;
	    if(sscanf(varchar, "dd", vehid, color2))
	    {
	        ShowTipForPlayer(playerid, "/apojazd kolor2 [ID pojazdu] [Kolor 2]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
    	if(color2 < 0 || color2 > 255)
      	{
       		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "ID koloru nie mo�e by� mniejsze ni� 0 a tak�e wi�ksze od 255.");
         	return 1;
       	}
		CarInfo[vehid][cColor2] = color2;
		ChangeVehicleColor(vehid, CarInfo[vehid][cColor1], CarInfo[vehid][cColor2]);

		SaveVehicle(vehid, SAVE_VEH_ACCESS);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Kolor pojazdu zosta� pomy�lnie zmieniony. Nowy kolor: %d", color2);
		return 1;
	}
	if(!strcmp(type, "paliwo", true))
	{
	    new vehid, Float: new_fuel;
	    if(sscanf(varchar, "df", vehid, new_fuel))
	    {
	        ShowTipForPlayer(playerid, "/apojazd paliwo [ID pojazdu] [Ilo�� litr�w]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
	    if(new_fuel > GetVehicleMaxFuel(CarInfo[vehid][cModel]))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz ustali� wi�cej paliwa ni� umie�ci bak.\nPojemno�� baku w tym poje�dzie wynosi: %d litry/�w.", GetVehicleMaxFuel(CarInfo[vehid][cModel]));
	        return 1;
	    }
		CarInfo[vehid][cFuel] = new_fuel;
		SaveVehicle(vehid, SAVE_VEH_COUNT);
		
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Zmieniono stan paliwa w poje�dzie %s.\nIlo�� paliwa: %.0fL", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cFuel]);
		return 1;
	}
	if(!strcmp(type, "hp", true) || !strcmp(type, "health", true))
	{
	    new vehid, Float:health;
 		if(sscanf(varchar, "df", vehid, health))
	    {
	        ShowTipForPlayer(playerid, "/apojazd hp [ID pojazdu] [HP]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
	    if(health < 350 || health > 1000)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "HP pojazdu nie mo�e by� mniejsze ni� 350 oraz wi�ksze od 1000.");
	        return 1;
	    }
     	CarInfo[vehid][cHealth] = health;
     	
      	SetVehicleHealth(vehid, health);
       	SaveVehicle(vehid, SAVE_VEH_COUNT);
       	
       	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Stan techniczny pojazdu zosta� zmieniony pomy�lnie.\nHP pojazdu wynosi teraz: %.0f HP.", CarInfo[vehid][cHealth]);
		return 1;
	}
	if(!strcmp(type, "zaparkuj", true))
	{
	    new vehid;
		if(sscanf(varchar, "d", vehid))
		{
		    ShowTipForPlayer(playerid, "/apojazd zaparkuj [ID pojazdu]");
		    return 1;
		}
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
	    new veh_uid = CarInfo[vehid][cUID];

		CarInfo[vehid][cWorldID] = GetPlayerVirtualWorld(playerid);
		CarInfo[vehid][cInteriorID] = GetPlayerInterior(playerid);

		GetVehiclePos(vehid, CarInfo[vehid][cPosX], CarInfo[vehid][cPosY], CarInfo[vehid][cPosZ]);
		GetVehicleZAngle(vehid, CarInfo[vehid][cPosA]);

		SaveVehicle(vehid, SAVE_VEH_POS);

		DestroyVehicle(vehid);
		Iter_Remove(Vehicles, vehid);

		LoadVehicle(veh_uid);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd zosta� zaparkowany w miejscu, na kt�rym w�a�nie stoi.");
		return 1;
	}
	if(!strcmp(type, "zamknij", true) || !strcmp(type, "z", true) || !strcmp(type, "lock", true))
	{
 		new vehid;
		if(sscanf(varchar, "d", vehid))
		{
		    ShowTipForPlayer(playerid, "/apojazd zamknij [ID pojazdu]");
		    return 1;
		}
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
	    if(CarInfo[vehid][cLocked])
	    {
  			CarInfo[vehid][cLocked] = false;
			SetVehicleLock(vehid, false);
			
			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Pojazd %s (SampID: %d, UID: %d) zosta� otwarty.", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID]);
	    }
	    else
	    {
  			CarInfo[vehid][cLocked] = true;
			SetVehicleLock(vehid, true);
			
			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Pojazd %s (SampID: %d, UID: %d) zosta� zamkni�ty.", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID]);
	    }
	    SaveVehicle(vehid, SAVE_VEH_LOCK);
	    return 1;
	}
	if(!strcmp(type, "info", true))
	{
	    new vehid;
	    if(sscanf(varchar, "d", vehid))
	    {
	        ShowTipForPlayer(playerid, "/apojazd info [ID pojazdu]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
	    ShowPlayerVehicleInfo(playerid, vehid);
	    return 1;
	}
	if(!strcmp(type, "res", true))
	{
	    new vehid;
	    if(sscanf(varchar, "d", vehid))
	    {
	        ShowTipForPlayer(playerid, "/apojazd res [ID pojazdu]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
     	SetVehicleToRespawn(vehid);
      	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd zosta� przywr�cony na miejsce spawnu.");
		return 1;
	}
	if(!strcmp(type, "przebieg", true) || !strcmp(type, "mileage", true))
	{
	    new vehid, Float:mileage;
	    if(sscanf(varchar, "df", vehid, mileage))
	    {
	        ShowTipForPlayer(playerid, "/apojazd przebieg [ID pojazdu] [Przebieg]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
	    CarInfo[vehid][cMileage] = mileage;
	    SaveVehicle(vehid, SAVE_VEH_COUNT);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Przebieg pojazdu %s (SampID: %d, UID: %d) zosta� pomy�lnie ustalony.\nNowy przebieg pojazdu: %.0f km", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID], CarInfo[vehid][cMileage]);
		return 1;
	}
	if(!strcmp(type, "visual", true))
	{
	    new vehid;
	    if(sscanf(varchar, "d", vehid))
		{
		    ShowTipForPlayer(playerid, "/apojazd visual [ID pojazdu]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
		UpdateVehicleDamageStatus(vehid, 0, 0, 0, 0);
		GetVehicleDamageStatus(vehid, CarInfo[vehid][cVisual][0], CarInfo[vehid][cVisual][1], CarInfo[vehid][cVisual][2], CarInfo[vehid][cVisual][3]);

		SaveVehicle(vehid, SAVE_VEH_COUNT);
	    return 1;
	}
	if(!strcmp(type, "spawn", true))
	{
	    new veh_uid;
	    if(sscanf(varchar, "d", veh_uid))
	    {
	        ShowTipForPlayer(playerid, "/apojazd spawn [UID pojazdu]");
	        return 1;
	    }
		new vehid = GetVehicleID(veh_uid);
		if(vehid != INVALID_VEHICLE_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten pojazd jest ju� zespawnowany (SampID: %d, UID: %d).", vehid, veh_uid);
		    return 1;
		}
		vehid = LoadVehicle(veh_uid);
		if(vehid == INVALID_VEHICLE_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono w bazie danych pojazdu o takim UID.");
		    return 1;
		}
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd %s (SampID: %d, UID: %d) zosta� zespawnowany pomy�lnie.", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID], vehid, CarInfo[vehid][cUID]);
		return 1;
	}
	if(!strcmp(type, "unspawn", true))
	{
 		new vehid;
	    if(sscanf(varchar, "d", vehid))
	    {
	        ShowTipForPlayer(playerid, "/apojazd unspawn [ID pojazdu]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
		DestroyVehicle(vehid);
		Iter_Remove(Vehicles, vehid);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd %s (SampID: %d, UID: %d) zosta� odspawnowany pomy�lnie.", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID]);
		return 1;
	}
	if(!strcmp(type, "resall", true))
	{
		foreach(new vehid : Vehicles)
		{
			if(!IsAnyPlayerInVehicle(vehid))
		    {
		        SetVehicleToRespawn(vehid);
		        UpdateVehicleDamageStatus(vehid, CarInfo[vehid][cVisual][0], CarInfo[vehid][cVisual][1], CarInfo[vehid][cVisual][2], CarInfo[vehid][cVisual][3]);
		    }
		}
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Wszystkie nieu�ywane pojazdy zosta�y przywr�cone na miejsce spawnu.");
		return 1;
	}
	if(!strcmp(type, "goto", true) || !strcmp(type, "to", true))
	{
 		new vehid;
	    if(sscanf(varchar, "d", vehid))
	    {
	        ShowTipForPlayer(playerid, "/apojazd goto [ID pojazdu]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
		new driverid = GetVehicleDriver(vehid);
		if(driverid != INVALID_VEHICLE_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Tym pojazdem w chwili obecnej kieruje %s (ID: %d).", PlayerName(driverid), driverid);
		    return 1;
		}
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
		{
			RemovePlayerFromVehicle(playerid);
		}
		PlayerCache[playerid][pLastVeh] = vehid;

		SetPlayerVirtualWorld(playerid, CarInfo[vehid][cWorldID]);
		SetPlayerInterior(playerid, CarInfo[vehid][cInteriorID]);

		PutPlayerInVehicle(playerid, vehid, 0);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Przeteleportowa�e� si� do pojazdu %s (SampID: %d, UID: %d).", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID]);
		return 1;
	}
	if(!strcmp(type, "gethere", true) || !strcmp(type, "tm", true))
	{
		new vehid;
	    if(sscanf(varchar, "d", vehid))
	    {
	        ShowTipForPlayer(playerid, "/apojazd gethere [ID pojazdu]");
	        return 1;
	    }
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
		new Float:PosX, Float:PosY, Float:PosZ,
		    interior_id = GetPlayerInterior(playerid), world_id = GetPlayerVirtualWorld(playerid);
		    
		GetPlayerPos(playerid, PosX, PosY, PosZ);
		SetVehiclePos(vehid, PosX + 3.0, PosY, PosZ);
		
		LinkVehicleToInterior(vehid, interior_id);
		SetVehicleVirtualWorld(vehid, world_id);
	    return 1;
	}
	if(!strcmp(type, "id", true) || !strcmp(type, "sampid", true))
	{
	    new veh_uid, vehid;
	    if(sscanf(varchar, "d", veh_uid))
	    {
	    	vehid = GetClosestVehicle(playerid);
	   		if(vehid == INVALID_VEHICLE_ID)
			{
				ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego pojazdu w pobli�u.");
			    return 1;
			}
			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Najbli�ej znajduj�cy si� pojazd to \"%s\" (SampID: %d, UID: %d).", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID]);
			return 1;
	    }
	    vehid = GetVehicleID(veh_uid);
		if(vehid == INVALID_VEHICLE_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Pojazd z tym UID nie jest zespawnowany.\nMo�esz go zespawnowa� komend� /av spawn.");
		    return 1;
		}
		
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Pojazd (UID: %d) to \"%s\" (SampID: %d).", veh_uid, GetVehicleName(CarInfo[vehid][cModel]), vehid);
	    return 1;
	}
	if(!strcmp(type, "przypisz", true) || !strcmp(type, "assign", true))
	{
		new vehid, owner_type[24], varchar2[24];
		if(sscanf(varchar, "ds[24]S()[24]", vehid, owner_type, varchar2))
		{
		    ShowTipForPlayer(playerid, "/apojazd przypisz [ID pojazdu] [Typ (gracz, grupa)]");
		    return 1;
		}
	    if(!Iter_Contains(Vehicles, vehid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID pojazdu.\nSkorzystaj z komendy /apojazd id, by sprawdzi� ID pojazdu.");
			return 1;
		}
	    if(!strcmp(owner_type, "gracz", true) || !strcmp(owner_type, "player", true))
	    {
	        new giveplayer_id;
			if(sscanf(varchar2, "u", giveplayer_id))
			{
			    ShowTipForPlayer(playerid, "/apojazd przypisz %d gracz [ID gracza]", vehid);
			    return 1;
			}
			if(giveplayer_id == INVALID_PLAYER_ID)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
			    return 1;
			}
			if(!PlayerCache[giveplayer_id][pLogged])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
			    return 1;
			}
			CarInfo[vehid][cOwnerType] = OWNER_PLAYER;
			CarInfo[vehid][cOwner] = PlayerCache[giveplayer_id][pUID];

			SaveVehicle(vehid, SAVE_VEH_THINGS);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd %s (SampID: %d, UID: %d) zosta� przypisany pomy�lnie.\n\nTyp w�a�ciciela: gracz\nW�a�ciciel: %s (ID: %d, UID: %d).", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID], PlayerName(giveplayer_id), giveplayer_id, PlayerCache[giveplayer_id][pUID]);
			return 1;
		}
		if(!strcmp(owner_type, "grupa", true) || !strcmp(owner_type, "group", true))
		{
		    new group_uid;
		    if(sscanf(varchar2, "d", group_uid))
		    {
		        ShowTipForPlayer(playerid, "/apojazd przypisz %d grupa [UID grupy]", vehid);
		        return 1;
		    }
		    new group_id = GetGroupID(group_uid);
 	    	if(group_id == INVALID_GROUP_ID)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
		        return 1;
		    }
			CarInfo[vehid][cOwnerType] = OWNER_GROUP;
			CarInfo[vehid][cOwner] = GroupData[group_id][gUID];

			SaveVehicle(vehid, SAVE_VEH_THINGS);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd %s (SampID: %d, UID: %d) zosta� przypisany pomy�lnie.\n\nTyp w�a�ciciela: grupa\nW�a�ciciel: %s (UID: %d)", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID], GroupData[group_id][gName], GroupData[group_id][gUID]);
			return 1;
		}
	    return 1;
	}
	return 1;
}

CMD:av(playerid, params[]) return cmd_apojazd(playerid, params);

CMD:pojazd(playerid, params[])
{
	new type[32], varchar[128];
	if(sscanf(params, "s[32]S()[128]", type, varchar))
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
	 		new veh_uid, veh_model, list_vehicles[256], data[256], list;
			mysql_query_format("SELECT `vehicle_uid`, `vehicle_model` FROM `"SQL_PREF"vehicles` WHERE vehicle_ownertype = '%d' AND vehicle_owner = '%d'", OWNER_PLAYER, PlayerCache[playerid][pUID]);

			mysql_store_result();
			while(mysql_fetch_row_format(data, "|"))
			{
			    list ++;

				sscanf(data, "p<|>dd", veh_uid, veh_model);
				format(list_vehicles, sizeof(list_vehicles), "%s\n%d\t\t%s", list_vehicles, veh_uid, GetVehicleName(veh_model));
			}
			mysql_free_result();
			if(strlen(list_vehicles))
			{
			    if(list >= 5) 	GivePlayerAchievement(playerid, ACHIEVE_COLLECTOR);
   				GivePlayerAchievement(playerid, ACHIEVE_FIRST_VEH);
			    
			    ShowPlayerDialog(playerid, D_SPAWN_VEH, DIALOG_STYLE_LIST, "Pojazdy nale��ce do Ciebie:", list_vehicles, "(Un)spawn", "Zamknij");
			}
			else
			{
			    TD_ShowSmallInfo(playerid, 3, "Nie posiadasz ~r~zadnych ~w~pojazdow.", 3000, 3);
			}
			
			ShowTipForPlayer(playerid, "/pojazd [namierz, zaparkuj, tuning, przypisz, zamknij, info, opis]");
		}
		else
		{
		    new vehid = GetPlayerVehicleID(playerid);
		    if(CarInfo[vehid][cOwnerType] == OWNER_NONE)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego pojazdu.");
		        return 1;
		    }
	   		if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER && CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego pojazdu.");
				return 1;
			}
			if(CarInfo[vehid][cOwnerType] == OWNER_GROUP)
			{
			    if(!HavePlayerGroupPerm(playerid, CarInfo[vehid][cOwner], G_PERM_CARS))
			    {
			        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz uprawnie� prowadzenia pojazd�w, w grupie do kt�rej przypisany jest pojazd.");
			        return 1;
			    }
			}
   			new list_manage[128];
   			if(GetVehicleBonnetStatus(vehid) == 1)	strcat(list_manage, "1 - Zamknij mask�\n");
			else									strcat(list_manage, "1 - Uchyl mask�\n");

			if(GetVehicleBootStatus(vehid) == 1)	strcat(list_manage, "2 - Zamknij baga�nik\n");
			else									strcat(list_manage, "2 - Otw�rz baga�nik\n");

			if(GetVehicleLightsStatus(vehid) == 1)	strcat(list_manage, "3 - Wy��cz �wiat�a\n");
			else									strcat(list_manage, "3 - W��cz �wiat�a\n");
			
			if(CarInfo[vehid][cGlass])              strcat(list_manage, "4 - Otw�rz szyb�\n");
			else                                    strcat(list_manage, "4 - Zamknij szyb�\n");
			
			strcat(list_manage, "5 - Opcje CB radio\n");
			strcat(list_manage, "6 - W�asna rejestracja");

 			ShowPlayerDialog(playerid, D_MANAGE_VEH, DIALOG_STYLE_LIST, "Zarz�dzanie pojazdem", list_manage, "Wybierz", "Anuluj");
		}
	    return 1;
	}
	if(!strcmp(type, "namierz", true) || !strcmp(type, "target", true))
	{
		if(PlayerCache[playerid][pCheckpoint] == CHECKPOINT_VEHICLE)
		{
		    DisablePlayerCheckpoint(playerid);
		    PlayerCache[playerid][pCheckpoint] = CHECKPOINT_NONE;

			TD_ShowSmallInfo(playerid, 3, "Namierzanie zostalo ~r~anulowane~w~.");
			return 1;
		}
		
		new list_vehicles[256];
  		foreach(new vehid : Vehicles)
		{
		    if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER && CarInfo[vehid][cOwner] == PlayerCache[playerid][pUID])
		    {
		        format(list_vehicles, sizeof(list_vehicles), "%s\n%d\t\t%s (%d)", list_vehicles, vehid, GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID]);
		    }
		}
		if(strlen(list_vehicles))
		{
		    ShowPlayerDialog(playerid, D_TARGET_VEH, DIALOG_STYLE_LIST, "Pojazdy zespawnowane:", list_vehicles, "Namierz", "Anuluj");
		}
		else
		{
		    TD_ShowSmallInfo(playerid, 3, "Zaden z Twoich pojazdow ~r~nie jest ~w~zespawnowany.");
		}
	    return 1;
	}
	if(!strcmp(type, "zaparkuj", true))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie jako kierowca, aby zaparkowa� pojazd.");
	        return 1;
	    }
	    new vehid = GetPlayerVehicleID(playerid);
   		if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER && CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego pojazdu.");
			return 1;
		}
		if(CarInfo[vehid][cOwnerType] == OWNER_GROUP)
		{
		    if(!HavePlayerGroupPerm(playerid, CarInfo[vehid][cOwner], G_PERM_LEADER))
		    {
                ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz lidera grupy, do kt�rej przypisany jest pojazd.");
		        return 1;
		    }
		}
		if(!IsVehiclePlaceFree(vehid))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "To miejsce parkingowe jest ju� zaj�te.");
		    return 1;
		}
  		new veh_uid = CarInfo[vehid][cUID],
		  	seatid = GetPlayerVehicleSeat(playerid);

		CarInfo[vehid][cWorldID] = GetPlayerVirtualWorld(playerid);
		CarInfo[vehid][cInteriorID] = GetPlayerInterior(playerid);

		GetVehiclePos(vehid, CarInfo[vehid][cPosX], CarInfo[vehid][cPosY], CarInfo[vehid][cPosZ]);
		GetVehicleZAngle(vehid, CarInfo[vehid][cPosA]);

		SaveVehicle(vehid, SAVE_VEH_COUNT | SAVE_VEH_POS);

		DestroyVehicle(vehid);
		Iter_Remove(Vehicles, vehid);

		vehid = LoadVehicle(veh_uid);
		
		PlayerCache[playerid][pLastVeh] = vehid;
		PutPlayerInVehicle(playerid, vehid, seatid);
		
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd zosta� zaparkowany pomy�lnie.");
	    return 1;
	}
	if(!strcmp(type, "tuning", true))
	{
 		if(!IsPlayerInAnyVehicle(playerid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie, aby m�c u�y� tej komendy.");
	        return 1;
	    }
	    new vehid = GetPlayerVehicleID(playerid);
   		if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER && CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego pojazdu.");
			return 1;
		}
		if(CarInfo[vehid][cOwnerType] == OWNER_GROUP)
		{
		    if(!HavePlayerGroupPerm(playerid, CarInfo[vehid][cOwner], G_PERM_CARS))
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz uprawnie� prowadzenia pojazd�w, w grupie do kt�rej przypisany jest pojazd.");
		        return 1;
		    }
		}
		new data[64], list_tuning_items[512],
		    item_uid, item_value1, item_name[32];

		mysql_query_format("SELECT `item_uid`, `item_value1`, `item_name` FROM `"SQL_PREF"items` WHERE item_vehuid = '%d'", CarInfo[vehid][cUID]);

		mysql_store_result();
		while(mysql_fetch_row_format(data, "|"))
		{
		    sscanf(data, "p<|>dds[32]", item_uid, item_value1, item_name);
		    format(list_tuning_items, sizeof(list_tuning_items), "%s\n%d\t%d\t%s", list_tuning_items, item_uid, item_value1, item_name);
		}
		mysql_free_result();
		if(strlen(list_tuning_items))
		{
		    ShowPlayerDialog(playerid, D_TUNING_UNMOUNT, DIALOG_STYLE_LIST, "Zamontowane cz�ci:", list_tuning_items, "Odmontuj", "Zamknij");
		}
		else
		{
		    TD_ShowSmallInfo(playerid, 3, "Nie znaleziono ~r~zadnych ~w~zamontowanych czesci.");
		}
	    return 1;
	}
	if(!strcmp(type, "zamknij", true) || !strcmp(type, "z", true) || !strcmp(type, "lock", true))
	{
		new vehid = GetClosestVehicle(playerid);
		if(vehid == INVALID_VEHICLE_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego pojazdu w pobli�u.");
		    return 1;
		}
 		if(CarInfo[vehid][cOwnerType] == OWNER_NONE && !(PlayerCache[playerid][pAdmin] & A_PERM_CARS))
  		{
      		ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz kluczyk�w do tego pojazdu.");
      		return 1;
  		}
		if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER)
		{
   			if(CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID] && !HavePlayerVehicleKeys(playerid, vehid))
   			{
				ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz kluczyk�w do tego pojazdu.");
				return 1;
			}
		}
		if(CarInfo[vehid][cOwnerType] == OWNER_GROUP)
		{
   			if(!HavePlayerGroupPerm(playerid, CarInfo[vehid][cOwner], G_PERM_CARS))
   			{
       			ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz kluczyk�w do tego pojazdu.");
				return 1;
	    	}
		}
  		new Float:VehPosX, Float:VehPosY, Float:VehPosZ;
  		GetVehiclePos(vehid, VehPosX, VehPosY, VehPosZ);

		if(CarInfo[vehid][cLocked])
		{
		    GameTextForPlayer(playerid, "~w~Pojazd ~g~otwarty", 4000, 6);
			CarInfo[vehid][cLocked] = false;
		}
		else
		{
		    GameTextForPlayer(playerid, "~w~Pojazd ~r~zamkniety", 4000, 6);
			CarInfo[vehid][cLocked] = true;
		}
		
		// Je�li ma alarm
  		if(CarInfo[vehid][cAccess] & VEH_ACCESS_ALARM)
    	{
  			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, 1);

			// Audio alarmu
			new audio_handle;
			foreach(new i : Player)
		 	{
				if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
				{
	   				if(IsPlayerInRangeOfPoint(i, 10.0, VehPosX, VehPosY, VehPosZ))
				    {
				    	audio_handle = Audio_Play(i, AUDIO_ALARM);
					    Audio_Set3DPosition(i, audio_handle, VehPosX, VehPosY, VehPosZ, 10.0);
					}
				}
    		}
    	}
	    else
	    {
			ApplyAnimation(playerid,"INT_HOUSE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
		
		SetVehicleLock(vehid, CarInfo[vehid][cLocked]);
		SaveVehicle(vehid, SAVE_VEH_LOCK);
	    return 1;
	}
	if(!strcmp(type, "info", true))
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie, by sprawdzi� jego informacje.");
	        return 1;
	    }
	    new vehid = GetPlayerVehicleID(playerid);
   		if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER && CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego pojazdu.");
			return 1;
		}
		if(CarInfo[vehid][cOwnerType] == OWNER_GROUP)
		{
		    if(!HavePlayerGroupPerm(playerid, CarInfo[vehid][cOwner], G_PERM_CARS))
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz uprawnie� prowadzenia pojazd�w, w grupie do kt�rej przypisany jest pojazd.");
		        return 1;
		    }
		}
		ShowPlayerVehicleInfo(playerid, vehid);
	    return 1;
	}
	if(!strcmp(type, "przypisz", true))
	{
		if(!IsPlayerInAnyVehicle(playerid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie, aby m�c u�y� tej komendy.");
	        return 1;
	    }
	    new vehid = GetPlayerVehicleID(playerid);
	    if(CarInfo[vehid][cOwnerType] == OWNER_NONE)
	    {
         	ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego pojazdu.");
	        return 1;
	    }
   		if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER && CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID])
		{
            ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego pojazdu.");
			return 1;
		}
		if(CarInfo[vehid][cOwnerType] == OWNER_GROUP)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten pojazd jest ju� przypisany pod grup�.");
		    return 1;
		}
  		new list_groups[256], group_id;
		for (new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
		{
			if(PlayerGroup[playerid][group_slot][gpUID])
  			{
  				group_id = PlayerGroup[playerid][group_slot][gpID];
				format(list_groups, sizeof(list_groups), "%s\n%d\t%s (%d)", list_groups, group_slot + 1, GroupData[group_id][gName], GroupData[group_id][gUID]);
 			}
		}
		ShowPlayerDialog(playerid, D_ASSIGN_VEH, DIALOG_STYLE_LIST, "SLOT      NAZWA GRUPY", list_groups, "Wybierz", "Anuluj");
	    return 1;
	}
	if(!strcmp(type, "opis", true))
	{
		if(!IsPlayerInAnyVehicle(playerid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie, aby m�c u�y� tej komendy.");
	        return 1;
	    }
		new vehid = GetPlayerVehicleID(playerid);
		if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER && CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie, aby m�c u�y� tej komendy.");
			return 1;
		}
		if(CarInfo[vehid][cOwnerType] == OWNER_GROUP)
		{
		    if(!HavePlayerGroupPerm(playerid, CarInfo[vehid][cOwner], G_PERM_CARS))
		    {
                ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz uprawnie� prowadzenia pojazd�w, w grupie do kt�rej przypisany jest pojazd.");
		        return 1;
		    }
		}
		new desc[128];
		if(sscanf(varchar, "s[128]", desc))
		{
		    ShowTipForPlayer(playerid, "/v opis [Tre�� opisu] | Aby usun�� opis, u�yj komendy /opis usun.");
			return 1;
		}
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if(Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[i][pDescTag], E_STREAMER_ATTACHED_VEHICLE) == vehid)
  			{
  				UpdateDynamic3DTextLabelText(Text3D:PlayerCache[i][pDescTag], COLOR_DESC, " ");
				Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[i][pDescTag], E_STREAMER_ATTACHED_PLAYER, i);
			}
		}
		format(desc, sizeof(desc), "%s", WordWrap(desc, WRAP_AUTO));
		
		UpdateDynamic3DTextLabelText(Text3D:PlayerCache[playerid][pDescTag], COLOR_DO, desc);
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Ustalono nowy opis pojazdu:\n\n%s", desc);

		Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pDescTag], E_STREAMER_ATTACHED_VEHICLE, vehid);
  		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pDescTag], E_STREAMER_Z, 0.3);
		return 1;
	}
	return 1;
}

CMD:v(playerid, params[]) return cmd_pojazd(playerid, params);

CMD:silnik(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		return 1;
	}
	new vehid = GetPlayerVehicleID(playerid);
	if(IsVehicleBike(vehid))
 	{
  		return 1;
 	}
  	if(CarInfo[vehid][cOwnerType] == OWNER_NONE && !(PlayerCache[playerid][pAdmin] & A_PERM_CARS))
   	{
   	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz kluczyk�w do tego pojazdu.");
     	return 1;
   	}
	if(CarInfo[vehid][cOwnerType] == OWNER_PLAYER)
	{
	    if(CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID] && !HavePlayerVehicleKeys(playerid, vehid))
	    {
 			ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz kluczyk�w do tego pojazdu.");
			return 1;
		}
	}
	if(CarInfo[vehid][cOwnerType] == OWNER_GROUP)
	{
		if(!HavePlayerGroupPerm(playerid, CarInfo[vehid][cOwner], G_PERM_CARS))
		{
       		ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz kluczyk�w do tego pojazdu.");
       		return 1;
       	}
	}
	if(CarInfo[vehid][cHealth] < 360)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Silnik w tym poje�dzie jest ca�kowicie zniszczony.");
   		return 1;
	}
    if(GetVehicleEngineStatus(vehid) == 1)
    {
    	ChangeVehicleEngineStatus(vehid, false);
     	TD_ShowSmallInfo(playerid, 0, "Aby uruchomic silnik, wcisnij ~y~~k~~VEHICLE_FIREWEAPON_ALT~~w~ + ~y~~k~~SNEAK_ABOUT~~w~.~n~Klawisz ~y~~k~~VEHICLE_FIREWEAPON~ ~w~kontroluje swiatla w pojezdzie.");

		printf("[cars] %s (UID: %d, GID: %d) zgasi� silnik pojazdu %s (UID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID]);
	}
	else
	{
	    new started_time = 3000 - floatround(CarInfo[vehid][cHealth]);
	
 		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~g~Trwa uruchamianie silnika...", 3000, 3);
 		defer OnVehicleEngineStarted[started_time](vehid);
	}
	return 1;
}

CMD:pasy(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w poje�dzie, by m�c zapi�� pasy.");
	    return 1;
	}
	if(PlayerCache[playerid][pBelts])
	{
		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		GameTextForPlayer(playerid, "~w~pasy ~g~odpiete", 3000, 6);

		PlayerCache[playerid][pBelts] = false;
	}
	else
	{
		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		GameTextForPlayer(playerid, "~w~pasy ~r~zapiete", 3000, 6);

		PlayerCache[playerid][pBelts] = true;
	}
	return 1;
}

CMD:adrzwi(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_DOORS))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz zarz�dza� drzwiami.");
	    return 1;
	}
	new type[32], varchar[64], string[128];
	if(sscanf(params, "s[32]S()[64]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/adrzwi [stworz, usun, nazwa, pickup, goto, przypisz, interior, zamknij]");
	    ShowTipForPlayer(playerid, "/adrzwi [wejscie, wyjscie, entervw, exitvw, lista, info, id, przeladuj]");
		return 1;
	}
	if(!strcmp(type, "stworz", true) || !strcmp(type, "create", true))
	{
 		new door_name[32];
	    if(sscanf(varchar, "s[32]", door_name))
	    {
	        ShowTipForPlayer(playerid, "/adrzwi stworz [Nazwa drzwi]");
	        return 1;
	    }
	    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby stworzy� drzwi, musisz by� w pozycji stoj�cej.");
	        return 1;
	    }
   		new Float:EnterX, Float:EnterY, Float:EnterZ, Float:EnterA,
			InteriorID, VirtualWorld, door_uid;

		GetPlayerPos(playerid, EnterX, EnterY, EnterZ);
		GetPlayerFacingAngle(playerid, EnterA);

		InteriorID = GetPlayerInterior(playerid);
		VirtualWorld = GetPlayerVirtualWorld(playerid);

		door_uid = CreateDoor(EnterX, EnterY, EnterZ, EnterA, InteriorID, VirtualWorld, door_name);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Drzwi zosta�y stworzone pomy�lnie %s (UID: %d).", door_name, door_uid);
		return 1;
	}
	if(!strcmp(type, "usun", true) || !strcmp(type, "delete", true))
	{
	    new doorid;
	    if(sscanf(varchar, "d", doorid))
	    {
	        ShowTipForPlayer(playerid, "/adrzwi usun [ID drzwi]");
	        return 1;
	    }
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
	    DeleteDoor(doorid);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Drzwi zosta�y pomy�lnie usuni�te z bazy danych.");
		return 1;
	}
	if(!strcmp(type, "nazwa", true) || !strcmp(type, "name", true))
	{
	    new doorid, door_name[32], door_real_name[64];
	    if(sscanf(varchar, "ds[32]", doorid, door_name))
	    {
	        ShowTipForPlayer(playerid, "/adrzwi nazwa [ID drzwi] [Nowa nazwa]");
	        return 1;
	    }
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
	    mysql_real_escape_string(door_name, door_real_name);
        strmid(DoorCache[doorid][dName], door_real_name, 0, strlen(door_real_name), 32);
        
        SaveDoor(doorid, SAVE_DOOR_THINGS);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Nazwa drzwi (UID: %d) zosta�a pomy�lnie zmieniona.\nNowa nazwa: %s", DoorCache[doorid][dUID], door_name);
		return 1;
	}
	if(!strcmp(type, "pickup", true))
	{
	    new doorid;
	    if(sscanf(varchar, "d", doorid))
	    {
	        ShowTipForPlayer(playerid, "/adrzwi pickup [ID drzwi]");
	        return 1;
	    }
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
	    PlayerCache[playerid][pMainTable] = doorid;

	    format(string, sizeof(string), "%s (SampID: %d, UID: %d) � Pickup", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
	    ShowPlayerDialog(playerid, D_DOOR_PICKUP, DIALOG_STYLE_LIST, string, "1. Informacja\n2. Banknot\n3. Zielony domek\n4. Niebieski domek\n5. Serduszko\n6. Gwiazdka\n7. Dyskietka\n8. Koszulka\n9. Bia�a strza�ka", "Wybierz", "Anuluj");
		return 1;
	}
	if(!strcmp(type, "goto", true) || !strcmp(type, "to", true))
	{
	    new doorid;
	    if(sscanf(varchar, "d", doorid))
	    {
	        ShowTipForPlayer(playerid, "/adrzwi goto [ID drzwi]");
	        return 1;
	    }
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
	    crp_SetPlayerPos(playerid, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ]);
	    SetPlayerInterior(playerid, DoorCache[doorid][dEnterInt]);

	    SetPlayerVirtualWorld(playerid, DoorCache[doorid][dEnterVW]);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Zosta�e� przeteleportowany do drzwi %s (SampID: %d, UID: %d).", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
		return 1;
	}
	if(!strcmp(type, "przypisz", true) || !strcmp(type, "assign", true))
	{
		new doorid, owner_type[24], varchar2[24];
		if(sscanf(varchar, "ds[24]S()[24]", doorid, owner_type, varchar2))
		{
		    ShowTipForPlayer(playerid, "/adrzwi przypisz [ID drzwi] [Typ (gracz, grupa)]");
		    return 1;
		}
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
	    if(!strcmp(owner_type, "gracz", true) || !strcmp(owner_type, "player", true))
	    {
	        new giveplayer_id;
			if(sscanf(varchar2, "u", giveplayer_id))
			{
			    ShowTipForPlayer(playerid, "/adrzwi przypisz %d gracz [ID gracza]", doorid);
			    return 1;
			}
			if(giveplayer_id == INVALID_PLAYER_ID)
			{
				ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
			    return 1;
			}
			if(!PlayerCache[playerid][pLogged])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
			    return 1;
			}
			DoorCache[doorid][dOwnerType] = OWNER_PLAYER;
			DoorCache[doorid][dOwner] = PlayerCache[giveplayer_id][pUID];

			SaveDoor(doorid, SAVE_DOOR_THINGS);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Drzwi %s (SampID: %d, UID: %d) zosta�y przypisane pomy�lnie.\n\nTyp w�a�ciciela: gracz\nW�a�ciciel: %s (ID: %d, UID: %d)", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID], PlayerName(giveplayer_id), giveplayer_id, PlayerCache[giveplayer_id][pUID]);
			return 1;
		}
		if(!strcmp(owner_type, "grupa", true) || !strcmp(owner_type, "group", true))
		{
			new group_uid;
			if(sscanf(varchar2, "d", group_uid))
			{
			    ShowTipForPlayer(playerid, "/adrzwi przypisz %d grupa [UID grupy]", doorid);
			    return 1;
			}
			new group_id = GetGroupID(group_uid);
  			if(group_id == INVALID_GROUP_ID)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
		        return 1;
			}
		    DoorCache[doorid][dOwnerType] = OWNER_GROUP;
		    DoorCache[doorid][dOwner] = GroupData[group_id][gUID];

		    SaveDoor(doorid, SAVE_DOOR_THINGS);
   			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Drzwi %s (SampID: %d, UID: %d) zosta�y przypisane pomy�lnie.\n\nTyp w�a�ciciela: grupa\nW�a�ciciel: %s (UID: %d)", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID], GroupData[group_id][gName], GroupData[group_id][gUID]);
			return 1;
		}
	    return 1;
	}
	if(!strcmp(type, "interior", true))
	{
		new interiorid;
		if(sscanf(varchar, "d", interiorid))
		{
		    new list_interiors[3064];
		    for (new int = 0; int < sizeof(InteriorInfo); int++)
		    {
		        format(list_interiors, sizeof(list_interiors), "%s\n%d\t%s", list_interiors, int, InteriorInfo[int][INTERIOR_NAME]);
		    }
		    ShowPlayerDialog(playerid, D_DOOR_INTERIOR, DIALOG_STYLE_LIST, "Dost�pne interiory:", list_interiors, "Wybierz", "Anuluj");
		    return 1;
		}
		if(interiorid > 145 || interiorid < 0)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "B��dne ID interioru, nie mo�e wynie�� wi�cej ni� 145 ani mniej ni� 0.");
		    return 1;
		}
	 	SetPlayerPos(playerid, InteriorInfo[interiorid][INTERIOR_X], InteriorInfo[interiorid][INTERIOR_Y], InteriorInfo[interiorid][INTERIOR_Z]);
	 	SetPlayerInterior(playerid, InteriorInfo[interiorid][INTERIOR_ID]);

	 	SetPlayerFacingAngle(playerid, InteriorInfo[interiorid][INTERIOR_A]);
	 	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Zosta�e� pomy�lnie przeteleportowany do interioru %s (InteriorID: %d).", InteriorInfo[interiorid][INTERIOR_NAME], InteriorInfo[interiorid][INTERIOR_ID]);
	    return 1;
	}
	if(!strcmp(type, "zamknij", true) || !strcmp(type, "lock", true))
	{
	    new doorid;
		if(sscanf(varchar, "d", doorid))
		{
		    ShowTipForPlayer(playerid, "/adrzwi zamknij [ID drzwi]");
		    return 1;
		}
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
	    
	    if(DoorCache[doorid][dLocked])
	    {
	        DoorCache[doorid][dLocked] = false;
	        ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Drzwi %s (SampID: %d, UID: %d) zosta�y otwarte.", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
	    }
	    else
	    {
	        DoorCache[doorid][dLocked] = true;
	        ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Drzwi %s (SampID: %d, UID: %d) zosta�y zamkni�te.", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
	    }
		SaveDoor(doorid, SAVE_DOOR_LOCK);
 		return 1;
	}
	if(!strcmp(type, "wejscie", true) || !strcmp(type, "enter", true))
	{
	    new doorid;
	    if(sscanf(varchar, "d", doorid))
	    {
	        ShowTipForPlayer(playerid, "/adrzwi wejscie [ID drzwi]");
	        return 1;
	    }
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
		new door_uid = DoorCache[doorid][dUID];
		
		GetPlayerPos(playerid, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ]);
		GetPlayerFacingAngle(playerid, DoorCache[doorid][dEnterA]);

		DoorCache[doorid][dEnterInt] = GetPlayerInterior(playerid);
		SaveDoor(doorid, SAVE_DOOR_ENTER);

		DestroyPickup(doorid);
		Iter_Remove(Door, doorid);
		
		doorid = LoadDoor(door_uid);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pozycja wej�cia dla drzwi %s (SampID: %d, UID: %d) zosta�a ustalona.", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
		return 1;
	}
	if(!strcmp(type, "wyjscie", true) || !strcmp(type, "exit", true))
	{
	    new doorid;
	    if(sscanf(varchar, "d", doorid))
	    {
	        ShowTipForPlayer(playerid, "/adrzwi wyjscie [ID drzwi]");
	        return 1;
	    }
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
		GetPlayerPos(playerid, DoorCache[doorid][dExitX], DoorCache[doorid][dExitY], DoorCache[doorid][dExitZ]);
		GetPlayerFacingAngle(playerid, DoorCache[doorid][dExitA]);

		DoorCache[doorid][dExitInt] = GetPlayerInterior(playerid);
		SaveDoor(doorid, SAVE_DOOR_EXIT);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pozycja wyj�cia dla drzwi %s (SampID: %d, UID: %d) zosta�a ustalona.", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
		return 1;
	}
	if(!strcmp(type, "entervw", true))
	{
	    new doorid, entervw;
	    if(sscanf(varchar, "dd", doorid, entervw))
	    {
	        ShowTipForPlayer(playerid, "/adrzwi entervw [ID drzwi] [VirtualWorld]");
	        return 1;
	    }
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
	    DoorCache[doorid][dEnterVW] = entervw;
	    SaveDoor(doorid, SAVE_DOOR_ENTER);

	    ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "VirtualWorld wej�cia dla drzwi %s (SampID: %d, UID: %d) zosta� ustalony (VW: %d).", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID], entervw);
		return 1;
	}
	if(!strcmp(type, "exitvw", true))
	{
	    new doorid, exitvw;
	    if(sscanf(varchar, "dd", doorid, exitvw))
	    {
	        ShowTipForPlayer(playerid, "/adrzwi exitvw [ID drzwi] [VirtualWorld]");
	        return 1;
	    }
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
	    DoorCache[doorid][dExitVW] = exitvw;
	    SaveDoor(doorid, SAVE_DOOR_EXIT);

	    ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "VirtualWorld wyj�cia dla drzwi %s (SampID: %d, UID: %d) zosta� ustalony (VW: %d).", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID], exitvw);
		return 1;
	}
	if(!strcmp(type, "info", true))
	{
	    new doorid;
	    if(sscanf(varchar, "d", doorid))
	    {
	        ShowTipForPlayer(playerid, "/adrzwi info [ID drzwi]");
	        return 1;
	    }
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
	    ShowPlayerDoorInfo(playerid, doorid);
		return 1;
	}
	if(!strcmp(type, "id", true) || !strcmp(type, "sampid", true))
	{
		new door_uid, doorid;
		if(sscanf(varchar, "d", door_uid))
		{
 			doorid = GetClosestDoor(playerid);
	   		if(doorid == INVALID_DOOR_ID)
			{
				ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnych drzwi w pobli�u.");
			    return 1;
			}
			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Najbli�ej znajduj�ce si� drzwi to \"%s\" (SampID: %d, UID: %d).", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
		    return 1;
		}
		doorid = GetDoorID(door_uid);
		if(doorid == INVALID_DOOR_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono drzwi o podanym UID.");
		    return 1;
		}
		
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Drzwi (UID: %d) to \"%s\" (SampID: %d).", door_uid, DoorCache[doorid][dName], doorid);
		return 1;
	}
	if(!strcmp(type, "przeladuj", true) || !strcmp(type, "reload", true))
	{
	    new doorid;
	    if(sscanf(varchar, "d", doorid))
	    {
	        ShowTipForPlayer(playerid, "/adrzwi przeladuj [ID drzwi]");
	        return 1;
	    }
	    if(!Iter_Contains(Door, doorid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne ID drzwi.\nSkorzystaj z komendy /adrzwi id, aby sprawdzi� ID drzwi.");
			return 1;
	    }
	    if(GetPlayerDoorID(playerid) == doorid)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz znajdowa� si� w tych drzwiach podczas prze�adowywania.");
	        return 1;
	    }
		new data[128];
		mysql_query_format("SELECT * FROM `"SQL_PREF"objects` WHERE object_world = '%d'", DoorCache[doorid][dUID]);

		mysql_store_result();
		if(mysql_num_rows() > 0)
		{
			// Usu� stare obiekty z tego VW (je�li s�)
			new object_counts = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT);
			for (new object_id = 0; object_id <= object_counts; object_id++)
			{
				if(IsValidDynamicObject(object_id))
    			{
					if(Streamer_IsInArrayData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_WORLD_ID, DoorCache[doorid][dUID]))
					{
						DestroyDynamicObject(object_id);
	  				}
				}
			}

			new object_id, object_uid, object_model,
				Float:object_posx, Float:object_posy, Float:object_posz,
				Float:object_rotx, Float:object_roty, Float:object_rotz,
				object_world, object_interior;

			while(mysql_fetch_row_format(data, "|"))
			{
  				sscanf(data, "p<|>ddffffffdd", object_uid, object_model, object_posx, object_posy, object_posz, object_rotx, object_roty, object_rotz, object_world, object_interior);
				object_id = CreateDynamicObject(object_model, object_posx, object_posy, object_posz, object_rotx, object_roty, object_rotz, object_world, object_interior, -1, MAX_DRAW_DISTANCE);

				Streamer_SetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID, object_uid);
			}

			DestroyPickup(doorid);
			Iter_Remove(Door, doorid);

			doorid = LoadDoor(DoorCache[doorid][dUID]);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Wn�trze drzwi %s (SampID: %d, UID: %d) zosta�o pomy�lnie wczytane.", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
		}
		else
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wn�trze nie zosta�o za�adowane.\nPrawdopodobnie nie zosta�o wgrane �adne wn�trze.");
		}
		mysql_free_result();
	    return 1;
	}
	return 1;
}

CMD:ad(playerid, params[]) return cmd_adrzwi(playerid, params);

CMD:drzwi(playerid, params[])
{
	new type[32], varchar[32], doorid = GetPlayerDoorID(playerid);
	if(sscanf(params, "s[32]S()[32]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/drzwi [info, zamknij, opcje]");
	 	return 1;
	}
	if(!strcmp(type, "info", true))
	{
	    if(doorid == INVALID_DOOR_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w drzwiach.");
	        return 1;
	    }
   		if(DoorCache[doorid][dOwnerType] == OWNER_NONE && !(PlayerCache[playerid][pAdmin] & A_PERM_DOORS))
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego budynku.");
		    return 1;
		}
		if(DoorCache[doorid][dOwnerType] == OWNER_PLAYER && DoorCache[doorid][dOwner] != PlayerCache[playerid][pUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego budynku.");
		    return 1;
		}
		if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
		{
		    if(!HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_DOORS))
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz uprawnie� dla drzwi, w grupie dla kt�rej s� one przypisane.");
		        return 1;
		    }
		}
		ShowPlayerDoorInfo(playerid, doorid);
	    return 1;
	}
	if(!strcmp(type, "zamknij", true))
	{
		foreach(new d : Door)
		{
		    doorid = d;
  			if((IsPlayerInRangeOfPoint(playerid, 2.0, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ]) && GetPlayerVirtualWorld(playerid) == DoorCache[doorid][dEnterVW]) || (IsPlayerInRangeOfPoint(playerid, 2.0, DoorCache[doorid][dExitX], DoorCache[doorid][dExitY], DoorCache[doorid][dExitZ]) && GetPlayerVirtualWorld(playerid) == DoorCache[doorid][dExitVW]))
	    	{
   				if(DoorCache[doorid][dOwnerType] == OWNER_NONE)
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz kluczy do tych drzwi.");
				    return 1;
				}
    			if(DoorCache[doorid][dOwnerType] == OWNER_PLAYER)
				{
				    if(DoorCache[doorid][dOwner] != PlayerCache[playerid][pUID] && PlayerCache[playerid][pHouse] != DoorCache[doorid][dUID])
				    {
    					ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz kluczy do tych drzwi.");
						return 1;
					}
				}
				if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
				{
    				if(!HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_DOORS))
				    {
        				ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz kluczy do tych drzwi.");
	       				return 1;
				    }
				}
				if(DoorCache[doorid][dLocked])
				{
    				GameTextForPlayer(playerid, "~w~Drzwi ~g~otwarte", 4000, 6);

					ApplyAnimation(playerid,"INT_HOUSE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

					DoorCache[doorid][dLocked] = false;
					SaveDoor(doorid, SAVE_DOOR_LOCK);
				}
				else
				{
    				GameTextForPlayer(playerid, "~w~Drzwi ~r~zamkniete", 4000, 6);

					ApplyAnimation(playerid,"INT_HOUSE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

					DoorCache[doorid][dLocked] = true;
					SaveDoor(doorid, SAVE_DOOR_LOCK);
				}
				break;
    		}
		}
	    return 1;
	}
	if(!strcmp(type, "opcje", true))
	{
	    new string[128];
	    if(doorid == INVALID_DOOR_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w drzwiach.");
	        return 1;
	    }
   		if(DoorCache[doorid][dOwnerType] == OWNER_NONE)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego budynku.");
		    return 1;
		}
		if(DoorCache[doorid][dOwnerType] == OWNER_PLAYER && DoorCache[doorid][dOwner] != PlayerCache[playerid][pUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego budynku.");
		    return 1;
		}
		if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
		{
		    if(!HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_LEADER))
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie jeste� w�a�cicielem tego budynku.");
		        return 1;
		    }
		}
		PlayerCache[playerid][pMainTable] = doorid;
		
		format(string, sizeof(string), "%s (SampID: %d, UID: %d) � Opcje", DoorCache[doorid][dName], doorid, DoorCache[doorid][dUID]);
		ShowPlayerDialog(playerid, D_DOOR_OPTIONS, DIALOG_STYLE_LIST, string, "1. Edytuj nazw� drzwi\n2. Ustal koszt wst�pu\n3. Przypisz drzwi\n4. Muzyka spoza gry\n5. Poka� magazyn\n6. Za�aduj wn�trze\n7. Mo�liwo�� przejazdu\n8. Ustal pozycj� wyj�ciow�\n9. Przedmioty w schowku", "Wybierz", "Anuluj");
	    return 1;
	}
	return 1;
}

CMD:aprzedmiot(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_ITEMS))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz zarz�dza� przedmiotami.");
	    return 1;
	}
	new type[32], varchar[64];
	if(sscanf(params, "s[32]S()[64]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/aprzedmiot [stworz, typ, value1, value2, info]");
	    return 1;
	}
	if(!strcmp(type, "stworz", true) || !strcmp(type, "create", true))
	{
	    new item_name[32], item_type, item_value1, item_value2;
	    if(sscanf(varchar, "s[32]ddd", item_name, item_type, item_value1, item_value2))
	    {
	        ShowTipForPlayer(playerid, "/aprzedmiot stworz [Nazwa przedmiotu] [Typ] [Warto�� 1] [Warto�� 2]");
	        return 1;
	    }
	    if(item_type < 0 || item_type > ITEM_COUNT)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owy typ przedmiotu.\nTyp powinien mie�ci� si� w przedziale od 0 do %d.", ITEM_COUNT);
	        return 1;
	    }
		new itemid = CreatePlayerItem(playerid, item_name, item_type, item_value1, item_value2);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Przedmiot %s (UID: %d) zosta� stworzony pomy�lnie.\nTyp przedmiotu: %s\n\nPrzedmiot znajdziesz w swoim ekwipunku.", item_name, ItemCache[itemid][iUID], ItemTypeInfo[item_type][iTypeName]);
		return 1;
	}
	if(!strcmp(type, "typ", true))
	{
	    new item_uid, item_type;
	    if(sscanf(varchar, "dd", item_uid, item_type))
	    {
	        ShowTipForPlayer(playerid, "/aprzedmiot typ [UID przedmiotu] [Typ]");
	        return 1;
	    }
	    new itemid = GetItemID(item_uid);
	    if(itemid == INVALID_ITEM_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID przedmiotu.\nPami�taj, �e przedmiot musi by� w posiadaniu gracza.");
	        return 1;
	    }
	    if(item_type < 0 || item_type > ITEM_COUNT)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owy typ przedmiotu.\nTyp powinien mie�ci� si� w przedziale od 0 do %d.", ITEM_COUNT);
	        return 1;
	    }
		ItemCache[itemid][iType] = item_type;
		SaveItem(itemid, SAVE_ITEM_TYPE);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Typ przedmiotu %s (UID: %d) zosta� pomy�lnie zmieniony.\nNowy typ przedmiotu: %s.", ItemCache[itemid][iName], ItemCache[itemid][iUID], ItemTypeInfo[item_type][iTypeName]);
		return 1;
	}
	if(!strcmp(type, "nazwa", true))
	{
 		new item_uid, item_name[32], real_item_name[32];
	    if(sscanf(varchar, "ds[32]", item_uid, item_name))
	    {
	        ShowTipForPlayer(playerid, "/aprzedmiot nazwa [UID przedmiotu] [Nazwa]");
	        return 1;
	    }
	    new itemid = GetItemID(item_uid);
	    if(itemid == INVALID_ITEM_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID przedmiotu.\nPami�taj, �e przedmiot musi by� w posiadaniu gracza.");
	        return 1;
	    }
	    mysql_real_escape_string(item_name, real_item_name);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Nazwa przedmiotu %s (UID: %d) zosta�a pomy�lnie zmieniona.\nNowa nazwa przedmiotu: %s.", ItemCache[itemid][iName], ItemCache[itemid][iUID], real_item_name);

		strmid(ItemCache[itemid][iName], real_item_name, 0, strlen(real_item_name), 32);
		SaveItem(itemid, SAVE_ITEM_NAME);
		return 1;
	}
	if(!strcmp(type, "value1", true))
	{
 		new item_uid, item_value1;
	    if(sscanf(varchar, "dd", item_uid, item_value1))
	    {
	        ShowTipForPlayer(playerid, "/aprzedmiot value1 [UID przedmiotu] [Value 1]");
	        return 1;
	    }
	    new itemid = GetItemID(item_uid);
	    if(itemid == INVALID_ITEM_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID przedmiotu.\nPami�taj, �e przedmiot musi by� w posiadaniu gracza.");
	        return 1;
	    }
		ItemCache[itemid][iValue1] = item_value1;
		SaveItem(itemid, SAVE_ITEM_VALUES);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Warto�� nr. 1 przedmiotu %s (UID: %d) zosta�a pomy�lnie zmieniona.\nNowa warto�� nr. 1 przedmiotu: %d.", ItemCache[itemid][iName], ItemCache[itemid][iUID], ItemCache[itemid][iValue1]);
		return 1;
	}
	if(!strcmp(type, "value2", true))
	{
 		new item_uid, item_value2;
	    if(sscanf(varchar, "dd", item_uid, item_value2))
	    {
	        ShowTipForPlayer(playerid, "/aprzedmiot value1 [UID przedmiotu] [Value 2]");
	        return 1;
	    }
	    new itemid = GetItemID(item_uid);
	    if(itemid == INVALID_ITEM_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID przedmiotu.\nPami�taj, �e przedmiot musi by� w posiadaniu gracza.");
	        return 1;
	    }
		ItemCache[itemid][iValue2] = item_value2;
		SaveItem(itemid, SAVE_ITEM_VALUES);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Warto�� nr. 2 przedmiotu %s (UID: %d) zosta�a pomy�lnie zmieniona.\nNowa warto�� nr. 2 przedmiotu: %d.", ItemCache[itemid][iName], ItemCache[itemid][iUID], ItemCache[itemid][iValue2]);
		return 1;
	}
	if(!strcmp(type, "info", true))
	{
		new item_uid;
	    if(sscanf(varchar, "d", item_uid))
	    {
	        ShowTipForPlayer(playerid, "/aprzedmiot info [UID przedmiotu]");
	        return 1;
	    }
	    new itemid = GetItemID(item_uid);
	    if(itemid == INVALID_ITEM_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID przedmiotu.\nPami�taj, �e przedmiot musi by� w posiadaniu gracza.");
	        return 1;
	    }
		ShowPlayerItemInfo(playerid, itemid);
	    return 1;
	}
	return 1;
}

CMD:ap(playerid, params[]) return cmd_aprzedmiot(playerid, params);

CMD:p(playerid, params[])
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
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
		   	return 1;
		}
		ListPlayerItemsForPlayer(playerid, giveplayer_id);

 		format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Gotowka gracza ~r~%s~y~: ~g~$%d~y~.", PlayerName(playerid), PlayerCache[playerid][pCash]);
		GameTextForPlayer(giveplayer_id, string, 6000, 3);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pokaza�e� swoje przedmioty dla gracza %s.", PlayerName(giveplayer_id));
		printf("[item] %s (UID: %d, GID: %d) pokaza� swoje przedmioty dla %s (UID: %d, GID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], PlayerRealName(giveplayer_id), PlayerCache[giveplayer_id][pUID], PlayerCache[giveplayer_id][pGID]);
		return 1;
	}
	
	if(!strcmp(type, "lista", true))
	{
 		new giveplayer_id;
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
            ListPlayerItems(playerid);
	        return 1;
	    }
   		if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
		{
   		    ListPlayerItems(playerid);
   		    return 1;
		}
 		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	 		return 1;
		}
		ListPlayerItemsForPlayer(giveplayer_id, playerid);
	    return 1;
	}
	
	foreach(new itemid : Item)
	{
	    if(ItemCache[itemid][iUID])
	    {
			if(ItemCache[itemid][iPlace] == PLACE_PLAYER && ItemCache[itemid][iOwner] == PlayerCache[playerid][pUID])
			{
   				if(strfind(ItemCache[itemid][iName], type, true) >= 0)
				{
					if(ItemCache[itemid][iType] == ITEM_WEAPON || ItemCache[itemid][iType] == ITEM_INHIBITOR || ItemCache[itemid][iType] == ITEM_PAINT)
					{
					    if(strlen(varchar) <= 0)
					    {
							ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Je�eli pr�bujesz wyj�� bro�, korzystaj�c ze sposobu szybkiego u�ytku,\nmusisz wpisa� dodatkowe parametry, dzi�ki kt�rym system sam u�o�y tre�� /me.\n\nPrzyk�ad:\n/p deagle zza paska.");
						    return 1;
						}
						
						if(!OnPlayerUseItem(playerid, itemid))
						{
						    return 1;
						}
						
						if(!ItemCache[itemid][iUsed])
						{
							format(string, sizeof(string), "** %s chowa %s %s", PlayerName(playerid), ItemCache[itemid][iName], varchar);
							ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
						}
						else
						{
						    format(string, sizeof(string), "** %s wyjmuje %s %s", PlayerName(playerid), ItemCache[itemid][iName], varchar);
						    ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
						    
						    TD_ShowSmallInfo(playerid, 5, "Uzyles przedmiotu ~y~%s (UID: %d)~w~.", ItemCache[itemid][iName], ItemCache[itemid][iUID]);
						}
					}
					else
					{
					    OnPlayerUseItem(playerid, itemid);
					}
				    break;
				}
			}
	    }
	}
	return 1;
}

CMD:strefa(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_AREAS))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz zarz�dza� strefami.");
	    return 1;
	}
	new type[32], varchar[64];
	if(sscanf(params, "s[32]S()[64]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/strefa [stworz, usun, przypisz, pokaz]");
		return 1;
	}
	if(!strcmp(type, "stworz", true) || !strcmp(type, "create", true))
	{
		new areaid = Iter_Free(Area), Float:PosZ;
		
		Iter_Add(Area, areaid);
		GetPlayerPos(playerid, AreaCache[areaid][aMinX], AreaCache[areaid][aMinY], PosZ);
		
		PlayerCache[playerid][pCreatingArea] = areaid;
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Udaj si� teraz po przek�tnej strefy, a nast�pnie wci�nij w wybranym miejscu klawisz PPM.\nAby anulowa� tworzenie strefy wci�nij klawisz ENTER.");
	    return 1;
	}
	if(!strcmp(type, "usun", true) || !strcmp(type, "delete", true))
	{
		new area_uid;
		if(sscanf(varchar, "d", area_uid))
		{
		    ShowTipForPlayer(playerid, "/strefa usun [UID strefy]");
		    return 1;
		}
		new areaid = GetAreaID(area_uid);
		if(areaid == INVALID_AREA_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wporowadzono b��dne UID strefy.");
		    return 1;
		}
		
		DeleteArea(areaid);
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Strefa (UID: %d) zosta�a pomy�lnie usuni�ta.", area_uid);
	    return 1;
	}
	if(!strcmp(type, "przypisz", true) || !strcmp(type, "assign", true))
	{
		new area_uid, owner_type[24], varchar2[24];
		if(sscanf(varchar, "ds[24]S()[24]", area_uid, owner_type, varchar2))
		{
		    ShowTipForPlayer(playerid, "/strefa przypisz [UID strefy] [Typ (gracz, grupa)]");
		    return 1;
		}
		new areaid = GetAreaID(area_uid);
		if(areaid == INVALID_AREA_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wporowadzono b��dne UID strefy.");
		    return 1;
		}
		if(!strcmp(owner_type, "gracz", true) || !strcmp(owner_type, "player", true))
		{
  			new giveplayer_id;
			if(sscanf(varchar2, "u", giveplayer_id))
			{
			    ShowTipForPlayer(playerid, "/strefa przypisz %d gracz [ID gracza]", area_uid);
			    return 1;
			}
			if(giveplayer_id == INVALID_PLAYER_ID)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
			    return 1;
			}
			if(!PlayerCache[giveplayer_id][pLogged])
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
			    return 1;
			}
			AreaCache[areaid][aOwnerType] = OWNER_PLAYER;
			AreaCache[areaid][aOwner] = PlayerCache[giveplayer_id][pUID];
			
			SaveArea(areaid);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Strefa (UID: %d) zosta�a przypisana pomy�lnie.\n\nTyp w�a�ciciela: gracz\nW�a�ciciel: %s (ID: %d, UID: %d).", AreaCache[areaid][aUID], PlayerName(giveplayer_id), giveplayer_id, PlayerCache[giveplayer_id][pUID]);
		    return 1;
		}
		if(!strcmp(owner_type, "grupa", true) || !strcmp(owner_type, "group", true))
		{
  			new group_uid;
		    if(sscanf(varchar2, "d", group_uid))
		    {
		        ShowTipForPlayer(playerid, "/strefa przypisz %d grupa [UID grupy]", area_uid);
		        return 1;
		    }
		    new group_id = GetGroupID(group_uid);
 	    	if(group_id == INVALID_GROUP_ID)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
		        return 1;
		    }
			AreaCache[areaid][aOwnerType] = OWNER_GROUP;
			AreaCache[areaid][aOwner] = GroupData[group_id][gUID];

			SaveArea(areaid);
			ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Strefa (UID: %d) zosta�a przypisana pomy�lnie.\n\nTyp w�a�ciciela: grupa\nW�a�ciciel: %s (UID: %d)", AreaCache[areaid][aUID], GroupData[group_id][gName], GroupData[group_id][gUID]);
			return 1;
		}
	    return 1;
	}
	if(!strcmp(type, "pokaz", true) || !strcmp(type, "show", true))
	{
	    new area_uid;
	    if(sscanf(varchar, "d", area_uid))
	    {
	        ShowTipForPlayer(playerid, "/strefa pokaz [UID strefy]");
	        return 1;
	    }
	    new areaid = GetAreaID(area_uid);
	    if(areaid == INVALID_AREA_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wporowadzono b��dne UID strefy.");
	        return 1;
	    }
	    GangZoneShowForPlayer(playerid, areaid, COLOR_AREA);
	    ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Strefa (UID: %d) zosta�a pomy�lnie pokazana na mapie.", area_uid);
	    return 1;
	}
	return 1;
}

CMD:tel(playerid, params[])
{
	if(!PlayerCache[playerid][pPhoneNumber])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz �adnego telefonu w u�yciu.\nSkorzystaj z komendy /p, by w��czy� telefon.");
	    return 1;
	}
	
	if(isnull(params))
	{
	    new itemid = GetPhoneItemID(PlayerCache[playerid][pPhoneNumber]);
   		OnPlayerUseItem(playerid, itemid);
   		return 1;
	}
	
	if(!strcmp(params, "zakoncz", true) || !strcmp(params, "z", true))
	{
		foreach(new i : Player)
		{
		    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
		    {
		        if(PlayerCache[i][pCallingTo] == playerid)
		        {
          			PlayerCache[i][pCallingTo] = INVALID_PLAYER_ID;
          			PlayerCache[playerid][pCallingTo] = INVALID_PLAYER_ID;

	   				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	   				RemovePlayerAttachedObject(playerid, SLOT_PHONE);

					SetPlayerSpecialAction(i, SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(i, SLOT_PHONE);
					
    				SendClientMessage(playerid, COLOR_YELLOW, "Rozmowa zosta�a pomy�lnie zako�czona.");
	            	SendClientMessage(i, COLOR_YELLOW, "Rozmowa zosta�a pomy�lnie zako�czona.");
		            return 1;
		        }
		    }
		}
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie z nikim nie rozmawiasz oraz nikt nie pr�buje si� z Tob� po��czy�.");
	    return 1;
	}
	
	if(!strcmp(params, "odbierz", true) || !strcmp(params, "od", true))
	{
		if(PlayerCache[playerid][pCallingTo] != INVALID_PLAYER_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie prowadzisz ju� jak�� rozmow� telefoniczn�.\nZako�cz obecn� rozmow�, by m�c zadzwoni� (/tel zakoncz).");
		    return 1;
		}
		
		foreach(new i : Player)
		{
		    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
		    {
		        if(PlayerCache[i][pCallingTo] == playerid)
		        {
		            PlayerCache[playerid][pCallingTo] = i;
		            
	         		SetPlayerAttachedObject(playerid, SLOT_PHONE, 330, 6);
		            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);

		            SendClientMessage(playerid, COLOR_YELLOW, "Odebra�e� telefon. Aby zako�czy� rozmow� u�yj komendy /tel zakoncz.");
	                SendClientMessage(i, COLOR_YELLOW, "Odebrano telefon. Aby zako�czy� rozmow� u�yj komendy /tel zakoncz.");
	                return 1;
		        }
		    }
		}
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nikt w danej chwili nie pr�buje si� z Tob� po��czy�.");
	    return 1;
	}
	
	if(!strval(params))	return 1;
	
	new phone_number = strval(params), string[128];
	if(phone_number == PlayerCache[playerid][pPhoneNumber])
	{
	    SendClientMessage(playerid, COLOR_DO, "* S�ycha� sygna� zaj�to�ci... *");
	    return 1;
	}
	if(PlayerCache[playerid][pCallingTo] != INVALID_PLAYER_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie prowadzisz ju� jak�� rozmow� telefoniczn�.\nZako�cz obecn� rozmow�, by m�c zadzwoni� (/tel zakoncz).");
	    return 1;
	}
	
	// Hurtownia
	if(phone_number == NUMBER_WHOLESALE)
	{
	    new doorid = GetPlayerDoorID(playerid);
	    if(doorid == INVALID_DOOR_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby m�c zam�wi� produkty, musisz znajdowa� si� w budynku grupowym.");
	        return 1;
	    }
	    if(DoorCache[doorid][dOwnerType] == OWNER_NONE || DoorCache[doorid][dOwnerType] == OWNER_PLAYER)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby m�c zam�wi� produkty, musisz znajdowa� si� w budynku grupowym.");
	        return 1;
	    }
	    if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
	    {
	        if(!HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_ORDER))
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz zamawia� produkt�w.");
	            return 1;
	        }
	    }
	    PlayerCache[playerid][pMainTable] = doorid;
	    PlayerCache[playerid][pCallingTo] = NUMBER_WHOLESALE;
	    
		SetPlayerAttachedObject(playerid, SLOT_PHONE, 330, 6);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		
		new data[48], list_category[512],
		    category_uid, category_name[32];

		mysql_query(connHandle, "SELECT * FROM `"SQL_PREF"order_category`");

		mysql_store_result();
		while(mysql_fetch_row_format(data, "|"))
		{
		    sscanf(data, "p<|>ds[32]", category_uid, category_name);
		    format(list_category, sizeof(list_category), "%s\n%d\t%s", list_category, category_uid, category_name);
		}
		mysql_free_result();
		
		if(strlen(list_category))
		{
		    ShowPlayerDialog(playerid, D_ORDER_CATEGORY, DIALOG_STYLE_LIST, "Wybierz kategori�:", list_category, "Wybierz", "Anuluj");
		}
		else
		{
		    TD_ShowSmallInfo(playerid, 3, "Nie znaleziono ~r~zadnych ~w~kategorii.");
		}
	    return 1;
	}
	
	// Taxi
	if(phone_number == NUMBER_TAXI)
	{
		new list_taxi_corp[1024];
		foreach(new group_id : Groups)
		{
            if(GroupData[group_id][gUID])
            {
                if(GroupData[group_id][gType] == G_TYPE_TAXI)
                {
                    new workers;
					foreach(new i : Player)
					{
					    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
					    {
					        if(PlayerCache[i][pDutyGroup] == GroupData[group_id][gUID])
					        {
             					workers ++;
					        }
					    }
					}
					if(workers)
					{
					    format(list_taxi_corp, sizeof(list_taxi_corp), "%s\n%d\t(na s�u�bie %d)\t%s", list_taxi_corp, group_id, workers, GroupData[group_id][gName]);
					}
                }
            }
        }
		if(strlen(list_taxi_corp))
		{
  			SetPlayerAttachedObject(playerid, SLOT_PHONE, 330, 6);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);

			PlayerCache[playerid][pCallingTo] = NUMBER_TAXI;
			ShowPlayerDialog(playerid, D_TAXI_CORP_SELECT, DIALOG_STYLE_LIST, "Firmy taks�wkarskie", list_taxi_corp, "Dalej", "Anuluj");
		}
		else
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W chwili obecnej nie ma �adnej taks�wki na s�u�bie.");
		}
	    return 1;
	}
	
	// Alarmowy
	if(phone_number == NUMBER_ALARM)
	{
 		SetPlayerAttachedObject(playerid, SLOT_PHONE, 330, 6);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);

		PlayerCache[playerid][pCallingTo] = NUMBER_ALARM;

		SendClientMessage(playerid, COLOR_YELLOW, "Sekretarka: Witaj, po��czy�e� si� z numerem alarmowym centrali Los Santos, z kim po��czy�?");
        ShowPlayerDialog(playerid, D_ALARM_SELECT, DIALOG_STYLE_LIST, "Z kim chcesz si� po��czy�?", "Los Santos Police Department\nLos Santos Medical Center\nLos Santos Fire Department", "Wybierz", "Anuluj");
	    return 1;
	}
	
	// San News
	if(phone_number == NUMBER_NEWS)
	{
		SetPlayerAttachedObject(playerid, SLOT_PHONE, 330, 6);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);

		PlayerCache[playerid][pCallingTo] = NUMBER_NEWS;
 		ShowPlayerDialog(playerid, D_CALL_NEWS, DIALOG_STYLE_INPUT, "Los Santos News", "Dodzwoni�e� si� do radiostacji w Los Santos.\nPowiedz nam po kr�tce w czym rzecz.", "Dalej", "Anuluj");
	    return 1;
	}
	
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pPhoneNumber] == phone_number)
	        {
	            if(PlayerCache[i][pCallingTo] != INVALID_PLAYER_ID)
	            {
	                SendClientMessage(playerid, COLOR_DO, "* S�ycha� sygna� zaj�to�ci... *");
	                return 1;
	            }
	            PlayerCache[playerid][pCallingTo] = i;
	            
 				SetPlayerAttachedObject(playerid, SLOT_PHONE, 330, 6);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
				
				format(string, sizeof(string), "* S�ycha� d�wi�k dzwoni�cego telefonu. (( %s ))", PlayerName(i));
				ProxDetector(10.0, i, string, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO);
				
				SendClientMessage(playerid, COLOR_DO, "* S�ycha� sygna� pr�by po��czenia si�... *");
				SendClientFormatMessage(i, COLOR_YELLOW, "Po��czenie przychodz�ce od %d, u�yj (/tel)efon odbierz, by odebra� rozmow�.", PlayerCache[playerid][pPhoneNumber]);

				new audio_handle;
				foreach(new player : Player)
			    {
					if(PlayerCache[player][pLogged] && PlayerCache[player][pSpawned])
					{
					    if(IsPlayerInRangeOfPoint(player, 10.0, PlayerCache[i][pPosX], PlayerCache[i][pPosY], PlayerCache[i][pPosZ]))
					    {
						    audio_handle = Audio_Play(player, AUDIO_CALLING, false, true);
						    Audio_Set3DPosition(player, audio_handle, PlayerCache[i][pPosX], PlayerCache[i][pPosY], PlayerCache[i][pPosZ], 10.0);
						}
					}
			    }
			    return 1;
			}
	    }
	}
	SendClientMessage(playerid, COLOR_DO, "* Nie mo�na po��czy� si� z wybranym numerem...");
	return 1;
}

CMD:telefon(playerid, params[]) return cmd_tel(playerid, params);
CMD:call(playerid, params[])    return cmd_tel(playerid, params);

CMD:sms(playerid, params[])
{
	if(!PlayerCache[playerid][pPhoneNumber])
  	{
   		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz �adnego telefonu w u�yciu.\nSkorzystaj z komendy /p, by w��czy� telefon.");
   		return 1;
   	}
	new number, text[128], string[256];
	if(sscanf(params, "ds[128]", number, text))
	{
	    ShowTipForPlayer(playerid, "/sms [Nr. tel] [Tre��]");
	    return 1;
	}
	
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pPhoneNumber] == number)
	        {
	            SendClientFormatMessage(i, COLOR_YELLOW, "[SMS] %d: %s", PlayerCache[playerid][pPhoneNumber], text);
	            SendClientFormatMessage(playerid, COLOR_YELLOW, "Wys�ano � [SMS] %d: %s", number, text);

	            format(string, sizeof(string), "* %s wysy�a SMS-a.", PlayerName(playerid));
	            ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

	            if(PlayerCache[i][pSex]) 			format(string, sizeof(string), "* %s otrzyma� SMS-a.", PlayerName(i));
	            else 								format(string, sizeof(string), "* %s otrzyma�a SMS-a.", PlayerName(i));

	            ProxDetector(10.0, i, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

				new audio_handle;
  				foreach(new player : Player)
			    {
					if(PlayerCache[player][pLogged] && PlayerCache[player][pSpawned])
					{
					    if(IsPlayerInRangeOfPoint(player, 10.0, PlayerCache[i][pPosX], PlayerCache[i][pPosY], PlayerCache[i][pPosZ]))
					    {
						    audio_handle = Audio_Play(player, AUDIO_SMS);
						    
						    Audio_SetFX(i, audio_handle, 6);
						    Audio_Set3DPosition(player, audio_handle, PlayerCache[i][pPosX], PlayerCache[i][pPosY], PlayerCache[i][pPosZ], 10.0);
						}
					}
			    }
				return 1;
			}
	    }
	}
	SendClientMessage(playerid, COLOR_DO, "* Wiadomo�� SMS nie zosta�a dostarczona...");
	return 1;
}

CMD:dom(playerid, params[])
{
	new doorid = GetPlayerDoorID(playerid);
	if(doorid == INVALID_DOOR_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w swoim domu.");
	    return 1;
	}
	if(DoorCache[doorid][dOwnerType] != OWNER_PLAYER || DoorCache[doorid][dOwner] != PlayerCache[playerid][pUID])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w swoim domu.");
	    return 1;
	}
	new type[32], varchar[64];
	GivePlayerAchievement(playerid, ACHIEVE_HOUSE);
	
	if(sscanf(params, "s[32]S()[64]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/dom [zapros, wypros]");
	    return 1;
	}
	if(!strcmp(type, "zapros", true))
	{
	    new giveplayer_id;
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/dom zapros [ID gracza]");
	        return 1;
	    }
    	if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaprosi� samego siebie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	 		return 1;
		}
		if(PlayerCache[giveplayer_id][pHouse])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz posiada ju� jaki� dom, b�d� jest gdzie� zameldowany.");
		    return 1;
		}
		PlayerCache[giveplayer_id][pHouse] = DoorCache[doorid][dUID];
		OnPlayerSave(giveplayer_id, SAVE_PLAYER_BASIC);

		SendClientFormatMessage(giveplayer_id, COLOR_LIGHTBLUE, "%s zaprosi� Ci� do swojego domu.", PlayerName(playerid));
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Zaprosi�e� gracza %s do swojego domu.", PlayerName(giveplayer_id));
	    return 1;
	}
	if(!strcmp(type, "wypros", true))
	{
	    new giveplayer_id;
	    if(sscanf(varchar, "u", giveplayer_id))
		{
		    ShowTipForPlayer(playerid, "/dom wypros [ID gracza]");
		    return 1;
		}
    	if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaprosi� samego siebie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pHouse] != DoorCache[doorid][dUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie jest zameldowany w Twoim domu.");
		    return 1;
		}
		PlayerCache[giveplayer_id][pHouse] = 0;
		OnPlayerSave(giveplayer_id, SAVE_PLAYER_BASIC);

		SendClientFormatMessage(giveplayer_id, COLOR_LIGHTBLUE, "%s wyprosi� Ci� ze swojego domu.", PlayerName(playerid));
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Wyprosi�e� gracza %s ze swojego domu.", PlayerName(giveplayer_id));
	    return 1;
	}
	return 1;
}

CMD:kup(playerid, params[])
{
	new doorid = GetPlayerDoorID(playerid);
	if(doorid == INVALID_DOOR_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku sklepu 24/7.");
	    return 1;
	}
	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku sklepu 24/7.");
	    return 1;
	}
	new group_id = GetGroupID(DoorCache[doorid][dOwner]);
	if(GroupData[group_id][gType] != G_TYPE_24/7)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku sklepu 24/7.");
	    return 1;
	}
	PlayerCache[playerid][pMainTable] = doorid;
	ListGroupProductsForPlayer(group_id, playerid, PRODUCT_LIST_BUY);
	return 1;
}

CMD:buy(playerid, params[]) return cmd_kup(playerid, params);

CMD:ubranie(playerid, params[])
{
	new doorid = GetPlayerDoorID(playerid);
	if(doorid == INVALID_DOOR_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku sklepu z odzie��.");
	    return 1;
	}
	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku sklepu z odzie��.");
	    return 1;
	}
	new group_id = GetGroupID(DoorCache[doorid][dOwner]);
	if(GroupData[group_id][gType] != G_TYPE_CLOTHES)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku sklepu z odzie��.");
	    return 1;
	}
	if(PlayerCache[playerid][pSelectSkin] != INVALID_SKIN_ID || PlayerCache[playerid][pSelectAccess] != INVALID_ACCESS_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie jeste� ju� w fazie wyboru.");
	    return 1;
	}

	ShowPlayerDialog(playerid, D_CLOTH_TYPE_SELECT, DIALOG_STYLE_LIST, "Co chcesz kupi�?", "1. Ubranie\n2. Akcesorie", "Wybierz", "Anuluj");
	return 1;
}

CMD:skuj(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby u�y� tej komendy, musisz by� na s�u�bie grupy z odpowiednimi uprawnieniami.");
		return 1;
 	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(!(GroupData[group_id][gFlags] & G_FLAG_HANDCUFFS))
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
		return 1;
	}
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/skuj [ID gracza]");
	    return 1;
	}
	if(giveplayer_id == playerid)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz sku� samego siebie.");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
    	return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
 		return 1;
	}
	if(!HavePlayerItemType(playerid, ITEM_HANDCUFFS))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiedniego przedmiotu w swoim ekwipunku.");
	    return 1;
	}
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pCuffedTo] == playerid)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz sku� wi�cej os�b.");
	            return 1;
	        }
	    }
	}
	PlayerCache[giveplayer_id][pCuffedTo] = playerid;
	
	SetPlayerSpecialAction(giveplayer_id, SPECIAL_ACTION_CUFFED);
  	SetPlayerAttachedObject(giveplayer_id, SLOT_HANDCUFFS, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);

	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Sku�e� gracza %s, aby rozku�, u�yj komendy /rozkuj.", PlayerName(giveplayer_id));
	return 1;
}

CMD:rozkuj(playerid, params[])
{
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
		ShowTipForPlayer(playerid, "/rozkuj [ID gracza]");
	    return 1;
	}
	if(giveplayer_id == playerid)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz rozku� siebie.");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
    	return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
 		return 1;
	}
	if(PlayerCache[giveplayer_id][pCuffedTo] != playerid)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie jest przykuty do Ciebie.");
	    return 1;
	}
	PlayerCache[giveplayer_id][pCuffedTo] = INVALID_PLAYER_ID;

	SetPlayerSpecialAction(giveplayer_id, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(giveplayer_id, SLOT_HANDCUFFS);

	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Gracz %s zosta� rozkuty.", PlayerName(giveplayer_id));
	return 1;
}

CMD:oferuj(playerid, params[])
{
	new type[32], varchar[64], string[256];
	if(sscanf(params, "s[32]S()[64]", type, varchar))
	{
	    new list_offers[256];
	    format(list_offers, sizeof(list_offers), "{C0C0C0}Podstawowe:{FFFFFF}");
	    
	    strcat(list_offers, "\n � przedmiot", sizeof(list_offers));
	    strcat(list_offers, "\n � pojazd", sizeof(list_offers));
	    strcat(list_offers, "\n � vcard", sizeof(list_offers));
	    strcat(list_offers, "\n � drzwi", sizeof(list_offers));
	    strcat(list_offers, "\n � holowanie", sizeof(list_offers));
	    
	    if(IsPlayerInAnyGroup(playerid))
	    {
	        format(list_offers, sizeof(list_offers), "%s\n \n{C0C0C0}Grupa:{FFFFFF}", list_offers);
	        
	        strcat(list_offers, "\n � produkt", sizeof(list_offers));
	        
	        if(IsPlayerInGroupType(playerid, G_TYPE_GYM))
	        {
                strcat(list_offers, "\n � karnet", sizeof(list_offers));
                strcat(list_offers, "\n � styl", sizeof(list_offers));
	        }
	        
	        if(IsPlayerInGroupType(playerid, G_TYPE_CARDEALER))
	        {
	            strcat(list_offers, "\n � salon", sizeof(list_offers));
	            strcat(list_offers, "\n � kluczyki", sizeof(list_offers));
	        }
	        
	        if(IsPlayerInGroupType(playerid, G_TYPE_TAXI))
	        {
	            strcat(list_offers, "\n � przejazd", sizeof(list_offers));
	        }
	        
	        if(IsPlayerInGroupType(playerid, G_TYPE_POLICE))
	        {
      			strcat(list_offers, "\n � mandat", sizeof(list_offers));
	            strcat(list_offers, "\n � odblokowanie", sizeof(list_offers));
	        }
	        
       		if(IsPlayerInGroupType(playerid, G_TYPE_GOV))
	     	{
    			strcat(list_offers, "\n � dokument", sizeof(list_offers));
	            strcat(list_offers, "\n � biznes", sizeof(list_offers));
	            
    			strcat(list_offers, "\n � rejestracje", sizeof(list_offers));
    			strcat(list_offers, "\n � podatek", sizeof(list_offers));
    			
    			strcat(list_offers, "\n � slub", sizeof(list_offers));
	     	}
	     	
	     	if(IsPlayerInGroupType(playerid, G_TYPE_MEDICAL) || IsPlayerInGroupType(playerid, G_TYPE_FIREDEPT))
	     	{
	     	    strcat(list_offers, "\n � leczenie", sizeof(list_offers));
	     	}
	     	
	     	if(IsPlayerInGroupType(playerid, G_TYPE_NEWS))
	     	{
           		strcat(list_offers, "\n � reklame", sizeof(list_offers));
	     	}
	     	
	     	if(IsPlayerInGroupType(playerid, G_TYPE_MOTORS))
	     	{
	     	    strcat(list_offers, "\n � paintjob", sizeof(list_offers));
	     	}
	     	
	     	if(IsPlayerInGroupType(playerid, G_TYPE_DRIVING))
	     	{
	     	    strcat(list_offers, "\n � lekcja", sizeof(list_offers));
	     	}
	    }
	    
	    if(PlayerCache[playerid][pJob] != JOB_NONE)
	    {
	        format(list_offers, sizeof(list_offers), "%s\n \n{C0C0C0}Praca:{FFFFFF}", list_offers);
	        
	        if(PlayerCache[playerid][pJob] == JOB_MECHANIC)
	        {
       			strcat(list_offers, "\n � tankowanie", sizeof(list_offers));
	       		strcat(list_offers, "\n � naprawe", sizeof(list_offers));

	         	strcat(list_offers, "\n � lakierowanie", sizeof(list_offers));
	          	strcat(list_offers, "\n � montaz", sizeof(list_offers));
	        }
	        
	        if(PlayerCache[playerid][pJob] == JOB_SELLER)
	        {
	            strcat(list_offers, "\n � produkt", sizeof(list_offers));
	        }
		}
	    
	    ShowPlayerDialog(playerid, D_OFFER_LIST, DIALOG_STYLE_LIST, "Dost�pne typy ofert:", list_offers, "Wybierz", "Anuluj");
	    return 1;
	}
	
	if(!strcmp(type, "przedmiot", true) || !strcmp(type, "item", true))
	{
 		new giveplayer_id, price, item_uid;
	    if(sscanf(varchar, "udd", giveplayer_id, item_uid, price))
	    {
	        ShowTipForPlayer(playerid, "/oferuj przedmiot [ID gracza] [UID przedmiotu] [Cena]");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBW])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
		    return 1;
		}
		new itemid = GetItemID(item_uid);
		if(itemid == INVALID_ITEM_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID przedmiotu.");
		    return 1;
		}
		if(ItemCache[itemid][iPlace] != PLACE_PLAYER || ItemCache[itemid][iOwner] != PlayerCache[playerid][pUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID przedmiotu.");
		    return 1;
		}
		if(ItemCache[itemid][iUsed])
  		{
  		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� tego przedmiotu.");
		    return 1;
		}
		if(price < 0)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
	    	return 1;
		}
		OnPlayerSendOffer(playerid, giveplayer_id, ItemCache[itemid][iName], OFFER_ITEM, itemid, 0, price);
	    return 1;
	}
	
	if(!strcmp(type, "pojazd", true) || !strcmp(type, "vehicle", true))
	{
 		new giveplayer_id, price;
	    if(sscanf(varchar, "ud", giveplayer_id, price))
	    {
	        ShowTipForPlayer(playerid, "/oferuj pojazd [ID gracza] [Cena]");
	        return 1;
	    }
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie kt�ry chcesz sprzeda�.");
	        return 1;
	    }
		new vehid = GetPlayerVehicleID(playerid);
		if(CarInfo[vehid][cOwnerType] != OWNER_PLAYER || CarInfo[vehid][cOwner] != PlayerCache[playerid][pUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten pojazd nie nale�y do Ciebie.");
		    return 1;
		}
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBW])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
		    return 1;
		}
		if(price < 0)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
  			return 1;
		}
		OnPlayerSendOffer(playerid, giveplayer_id, GetVehicleName(CarInfo[vehid][cModel]), OFFER_VEHICLE, vehid, 0, price);
	    return 1;
	}
	
	if(!strcmp(type, "produkt", true) || !strcmp(type, "product", true))
	{
		if(!PlayerCache[playerid][pDutyGroup] && PlayerCache[playerid][pJob] != JOB_SELLER)
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy lub posiada� prac� dorywcz� sprzedawcy, by m�c co� zaoferowa�.");
  	        return 1;
  	    }
	    new giveplayer_id;
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
			ShowTipForPlayer(playerid, "/oferuj produkt [ID gracza]");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBW])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
		    return 1;
		}
		
		new doorid = GetPlayerDoorID(playerid),
		    product_owner;
		    
		if(doorid == INVALID_DOOR_ID)
		{
		    new vehid = GetPlayerVehicleID(playerid);
		    if(vehid == INVALID_VEHICLE_ID)
		    {
		        new object_id = GetClosestObjectType(playerid, OBJECT_FOOD_BOX);
		        if(object_id == INVALID_OBJECT_ID)
		        {
		            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� produktu z magazynu w tym miejscu.");
		            return 1;
		        }
		        else
		        {
		            if(PlayerCache[playerid][pJob] != JOB_SELLER)
		            {
		                ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz pracy dorywczej jako sprzedawca.");
		                return 1;
		            }
		            
      	     		new	group_id,
					   	Float:DoorDistance,
						Float:LastDistance = 1000.0;
		            
				    foreach(new d : Door)
				    {
					    if(DoorCache[d][dEnterVW] == 0)
					    {
				  			if(DoorCache[d][dOwnerType] == OWNER_GROUP)
				  			{
				  			    if(IsPlayerInRangeOfPoint(playerid, LastDistance, DoorCache[d][dEnterX], DoorCache[d][dEnterY], DoorCache[d][dEnterZ]))
				  			    {
									group_id = GetGroupID(DoorCache[d][dOwner]);
									if(GroupData[group_id][gType] == G_TYPE_BAR)
									{
						          		DoorDistance = GetPlayerDistanceToPoint(playerid, DoorCache[d][dEnterX], DoorCache[d][dEnterY]);

										if((DoorDistance < LastDistance))
										{
											LastDistance = DoorDistance;
											product_owner = DoorCache[d][dOwner];
										}
									}
								}
							}
						}
					}
					
					if(product_owner <= 0)
					{
					    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnych produkt�w w magazynie.");
					    return 1;
					}
		        }
		    }
		    else
		    {
  				if(!HavePlayerGroupPerm(playerid, PlayerCache[playerid][pDutyGroup], G_PERM_OFFER))
			   	{
					ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz oferowa� produkt�w.");
					return 1;
				}
				if(CarInfo[vehid][cOwnerType] != OWNER_GROUP || CarInfo[vehid][cOwner] != PlayerCache[playerid][pDutyGroup])
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� produktu z magazynu w tym miejscu.");
		            return 1;
		        }
				new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
				if(GroupData[group_id][gType] != G_TYPE_BAR)
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� produktu z magazynu w tym miejscu.");
				    return 1;
				}
		        
		        product_owner = CarInfo[vehid][cOwner];
		    }
		}
		else
		{
			if(!HavePlayerGroupPerm(playerid, PlayerCache[playerid][pDutyGroup], G_PERM_OFFER))
  			{
				ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz oferowa� produkt�w.");
				return 1;
			}
			if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
			{
                ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� produktu z magazynu w tym miejscu.");
			    return 1;
			}
			
			product_owner = DoorCache[doorid][dOwner];
		}
		PlayerCache[playerid][pMainTable] = giveplayer_id;
		new group_id = GetGroupID(product_owner);
		
		ListGroupProductsForPlayer(group_id, playerid, PRODUCT_LIST_OFFER);
	    return 1;
	}
	
	if(!strcmp(type, "vcard", true))
	{
 		if(!PlayerCache[playerid][pPhoneNumber])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby m�c wys�a� vCard musisz mie� w��czony telefon.");
	        return 1;
	    }
	    new giveplayer_id;
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/oferuj vcard [ID gracza]");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
  		if(!PlayerCache[giveplayer_id][pPhoneNumber])
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie posiada telefonu w u�yciu.");
       		return 1;
    	}
		if(PlayerCache[giveplayer_id][pBW])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
		    return 1;
		}
     	OnPlayerSendOffer(playerid, giveplayer_id, "vCard", OFFER_VCARD, PlayerCache[playerid][pPhoneNumber], 0, 0);
	    return 1;
	}
	
	if(!strcmp(type, "drzwi", true))
	{
	    new giveplayer_id, price, doorid = GetPlayerDoorID(playerid);
	    if(sscanf(varchar, "ud", giveplayer_id, price))
	    {
	        ShowTipForPlayer(playerid, "/oferuj drzwi [ID gracza] [Cena]");
	        return 1;
	    }
		if(doorid == INVALID_DOOR_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku, kt�ry zamierzasz sprzeda�.");
		    return 1;
		}
		if(DoorCache[doorid][dOwnerType] != OWNER_PLAYER || DoorCache[doorid][dOwner] != PlayerCache[playerid][pUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie jeste� w�a�cicielem tego budynku.");
		    return 1;
		}
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBW])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
		    return 1;
		}
		if(price < 0)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
  			return 1;
		}
		OnPlayerSendOffer(playerid, giveplayer_id, DoorCache[doorid][dName], OFFER_DOOR, doorid, 0, price);
	    return 1;
	}
	
	if(!strcmp(type, "holowanie", true))
	{
 		new giveplayer_id, price;
	    if(sscanf(varchar, "ud", giveplayer_id, price))
	    {
	        ShowTipForPlayer(playerid, "/oferuj holowanie [ID gracza] [Cena]");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(10.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(!IsPlayerInAnyVehicle(playerid))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie, by m�c zaoferowa� holowanie.");
		    return 1;
		}
		if(!IsPlayerInAnyVehicle(giveplayer_id))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz musi siedzie� w poje�dzie, by m�c zaoferowa� holowanie.");
		    return 1;
		}
		if(GetPlayerState(giveplayer_id) != PLAYER_STATE_PASSENGER)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz musi siedzie� w poje�dzie jako pasa�er.", "Okej", "");
		    return 1;
		}
		new vehid = GetPlayerVehicleID(playerid);
		if(IsTrailerAttachedToVehicle(vehid))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Holujesz ju� aktualnie jaki� pojazd.");
		    return 1;
		}
		
		if(GetVehicleModel(vehid) == 525 || HavePlayerItemType(playerid, ITEM_LINE))
		{
			OnPlayerSendOffer(playerid, giveplayer_id, "Holowanie", OFFER_TOWING, vehid, GetPlayerVehicleID(giveplayer_id), price);
		}
		else
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz posiada� lin� holownicz�, b�d� siedzie� w holowniku.");
		}
	    return 1;
	}
	
	if(!strcmp(type, "przejazd", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_TAXI || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
	    new giveplayer_id, price;
	    if(sscanf(varchar, "ud", giveplayer_id, price))
	    {
			ShowTipForPlayer(playerid, "/oferuj przejazd [ID gracza] [Koszt/100m]");
	        return 1;
	    }
	    if(PlayerCache[playerid][pTaxiPassenger] != INVALID_PLAYER_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� przeja�d�ki drugiej osobie.");
	        return 1;
	    }
	    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie firmowym jako kierowca, aby m�c zaoferowa� przejazd.");
	        return 1;
	    }
		new vehid = GetPlayerVehicleID(playerid);
		if(CarInfo[vehid][cOwnerType] != OWNER_GROUP || CarInfo[vehid][cOwner] != GroupData[group_id][gUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie firmowym jako kierowca, aby m�c zaoferowa� przejazd.");
		    return 1;
		}
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(GetPlayerState(giveplayer_id) != PLAYER_STATE_PASSENGER || GetPlayerVehicleID(giveplayer_id) != vehid)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz musi siedzie� w Twoim poje�dzie jako pasa�er.");
		    return 1;
		}
		if(price <= 0 || price > 15)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nieprawid�owa kwota.");
		    return 1;
		}
		format(string, sizeof(string), "Kurs ($%d/100m)", price);
		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_PASSAGE, vehid, 0, price);
	    return 1;
	}
	
	if(!strcmp(type, "tankowanie", true) || !strcmp(type, "refuel", true))
	{
	    if(PlayerCache[playerid][pJob] != JOB_MECHANIC)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz pracy mechanika, jako dorywczej.");
	        return 1;
	    }
   		new object_id = GetClosestObjectType(playerid, OBJECT_FUELING);
		if(object_id == INVALID_OBJECT_ID)
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego dystrybutora w pobli�u.");
	   		return 1;
		}
	    new giveplayer_id, bens_type, value;
	    if(sscanf(varchar, "udd", giveplayer_id, bens_type, value))
	    {
	        ShowTipForPlayer(playerid, "/oferuj tankowanie [ID gracza] [Rodzaj paliwa] [Ilo�� litr�w]");
	        
	        SendClientMessage(playerid, COLOR_GREY, " ");
            SendClientMessage(playerid, COLOR_GREY, "Dost�pne rodzaje paliwa:");
            
	        SendClientMessage(playerid, COLOR_GREY, "1 - Benzyna");
	        SendClientMessage(playerid, COLOR_GREY, "2 - Gaz");
	        SendClientMessage(playerid, COLOR_GREY, "3 - Diesel");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
   		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBW])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
		    return 1;
		}
		if(!IsPlayerInAnyVehicle(giveplayer_id))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz musi siedzie� w poje�dzie, kt�ry zamierzasz zatankowa�.");
		    return 1;
		}
		if(bens_type < 0 || bens_type > 3)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wybrano nieprawid�owy rodzaj paliwa.");
		    return 1;
		}
		new vehid = GetPlayerVehicleID(giveplayer_id);
		if((bens_type - 1) != CarInfo[vehid][cFuelType])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wybrany rodzaj paliwa nie pasuje do tego pojazdu.");
		    return 1;
		}
		if(value < 0)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� ilo�� litr�w.");
		    return 1;
		}
		if(value + CarInfo[vehid][cFuel] > GetVehicleMaxFuel(CarInfo[vehid][cModel]))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W baku nie zmie�ci si� tyle paliwa.");
		    return 1;
		}
		new price;
		bens_type -= 1;

		if(bens_type == FUEL_TYPE_BENS) 			price = floatround(value * 3.5);
		else if(bens_type == FUEL_TYPE_GAS) 		price = floatround(value * 2.0);
		else if(bens_type == FUEL_TYPE_DIESEL) 		price = floatround(value * 3.0);

		format(string, sizeof(string), "%s (%dL)", FuelTypeName[bens_type], value);
		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_REFUEL, vehid, value, price);
	    return 1;
	}
	
	if(!strcmp(type, "naprawe", true) || !strcmp(type, "repair", true))
	{
		if(PlayerCache[playerid][pJob] != JOB_MECHANIC)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz pracy mechanika, jako dorywczej.");
		    return 1;
		}
	    new giveplayer_id;
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/oferuj naprawe [ID gracza]");
	        return 1;
	    }
	    if(PlayerCache[playerid][pRepairVeh] != INVALID_VEHICLE_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Obecnie jeste� ju� w trakcie naprawiania innego pojazdu.");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
   		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(!IsPlayerInAnyVehicle(giveplayer_id))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz musi siedzie� w poje�dzie, kt�ry zamierzasz naprawia�.");
		    return 1;
		}
		if(PlayerCache[giveplayer_id][pBW])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
		    return 1;
		}
		new vehid = GetPlayerVehicleID(giveplayer_id),
			price = 1000 - floatround(CarInfo[vehid][cHealth], floatround_ceil);

 		if(price < 0)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wysoko�� kwoty za napraw� pojazdu jest nieprawid�owa.");
		    return 1;
		}
		OnPlayerSendOffer(playerid, giveplayer_id, "Naprawa", OFFER_REPAIR, vehid, 0, price);
	    return 1;
	}
	
	if(!strcmp(type, "lakierowanie", true) || !strcmp(type, "painting", true))
	{
		if(PlayerCache[playerid][pJob] != JOB_MECHANIC)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz pracy mechanika, jako dorywczej.");
		    return 1;
		}
	    new giveplayer_id, color1, color2, price;
	    if(sscanf(varchar, "uddd", giveplayer_id, color1, color2, price))
	    {
	        ShowTipForPlayer(playerid, "/oferuj lakierowanie [ID gracza] [Kolor 1] [Kolor 2] [Robocizna]");
	        return 1;
	    }
	    if(PlayerCache[playerid][pSprayVeh] != INVALID_VEHICLE_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Obecnie jeste� ju� w trakcie lakierowania innego pojazdu.");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
		}
   		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBW])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
		    return 1;
		}
		if(!IsPlayerInAnyVehicle(giveplayer_id))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz musi siedzie� w poje�dzie, kt�ry zamierzasz przelakierowa�.");
		    return 1;
		}
 		if(color1 < 0 || color1 > 255 || color2 < 0 || color2 > 255)
		{
       		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "ID koloru nie mo�e by� mniejsze ni� 0 a tak�e wi�ksze ni� 255.");
         	return 1;
       	}
		if(price < 0)
		{
		   	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
		    return 1;
		}
		if(PlayerCache[playerid][pItemWeapon] == INVALID_ITEM_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz mie� lakier w u�yciu.");
		    return 1;
		}
		new itemid = PlayerCache[playerid][pItemWeapon];
		if(ItemCache[itemid][iType] != ITEM_PAINT)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz mie� lakier w u�yciu.");
		    return 1;
		}
		
		format(string, sizeof(string), "Kolory (%d/%d)", color1, color2);
		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_PAINT, color1, color2, price);
	    return 1;
	}
	
	if(!strcmp(type, "paintjob", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_MOTORS || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
  		new giveplayer_id, paintjob_id, price;
	    if(sscanf(varchar, "udd", giveplayer_id, paintjob_id, price))
	    {
	        ShowTipForPlayer(playerid, "/oferuj paintjob [ID gracza] [PaintJob ID] [Robocizna]");
	        return 1;
	    }
	    if(PlayerCache[playerid][pSprayVeh] != INVALID_VEHICLE_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Obecnie jeste� ju� w trakcie lakierowania innego pojazdu.");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
		}
   		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBW])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
		    return 1;
		}
		if(!IsPlayerInAnyVehicle(giveplayer_id))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz musi siedzie� w poje�dzie, kt�ry zamierzasz przelakierowa�.");
		    return 1;
		}
 		if(paintjob_id < 0 || paintjob_id > 3)
		{
       		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "PaintJob ID nie mo�e by� mniejsze ni� 0 oraz wi�ksze od 3.");
         	return 1;
       	}
		if(price < 0)
		{
		   	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
		    return 1;
		}
		if(PlayerCache[playerid][pItemWeapon] == INVALID_ITEM_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz mie� lakier w u�yciu.");
		    return 1;
		}
		new itemid = PlayerCache[playerid][pItemWeapon];
		if(ItemCache[itemid][iType] != ITEM_PAINT)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz mie� lakier w u�yciu.");
		    return 1;
		}
		
		format(string, sizeof(string), "PaintJob ID: %d", paintjob_id);
		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_PAINTJOB, paintjob_id, 0, price);
	    return 1;
	}
	
	if(!strcmp(type, "montaz", true))
	{
		if(PlayerCache[playerid][pJob] != JOB_MECHANIC)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz pracy mechanika, jako dorywczej.");
		    return 1;
		}
	    new item_uid, giveplayer_id, price;
	    if(sscanf(varchar, "dud", item_uid, giveplayer_id, price))
	    {
	        ShowTipForPlayer(playerid, "/oferuj montaz [UID przedmiotu] [ID gracza] [Robocizna]");
	        return 1;
	    }
   		new itemid = GetItemID(item_uid);
   		if(itemid == INVALID_ITEM_ID)
   		{
   		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID przedmiotu.");
   		    return 1;
   		}
		if(ItemCache[itemid][iPlace] != PLACE_PLAYER || ItemCache[itemid][iOwner] != PlayerCache[playerid][pUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID przedmiotu.");
		    return 1;
		}
		if(ItemCache[itemid][iType] != ITEM_TUNING && ItemCache[itemid][iType] != ITEM_VEH_ACCESS)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zamontowa� tego przedmiotu.");
		    return 1;
		}
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBW])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
		    return 1;
		}
		if(!IsPlayerInAnyVehicle(giveplayer_id))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz musi siedzie� w poje�dzie, w kt�rym zamierzasz co� zamontowa�.");
		    return 1;
		}
		new vehid = GetPlayerVehicleID(giveplayer_id);
		if(CarInfo[vehid][cModel] == 604 || CarInfo[vehid][cModel] == 605)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�na nic zamontowa� w tym poje�dzie.");
		    return 1;
		}
		if(ItemCache[itemid][iType] == ITEM_TUNING)
		{
			new slot = GetVehicleComponentType(ItemCache[itemid][iValue1]);
			if(CarInfo[vehid][cComponent][slot] != 0)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Jaki� komponent tego typu jest ju� zamontowany.\nMusi zosta� on odmontowany.");
			    return 1;
			}
		}
		if(ItemCache[itemid][iType] == ITEM_VEH_ACCESS)
		{
		    if(CarInfo[vehid][cAccess] & ItemCache[itemid][iValue1])
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W tym poje�dzie jest ju� zamontowane to akcesorie.");
		        return 1;
		    }
		}
		if(price < 0)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dn� kwot�.");
  			return 1;
		}
		
		format(string, sizeof(string), "%s (%d)", ItemCache[itemid][iName], ItemCache[itemid][iUID]);
		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_MONTAGE, itemid, vehid, price);
	    return 1;
	}
	
	if(!strcmp(type, "mandat", true) || !strcmp(type, "mandate", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_POLICE || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
	    new giveplayer_id, points, price, reason[32];
	    if(sscanf(varchar, "udds[32]", giveplayer_id, points, price, reason))
	    {
	        ShowTipForPlayer(playerid, "/oferuj mandat [ID gracza] [PKT. Karne] [Cena] [Pow�d]");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
   		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBW])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
		    return 1;
		}
		if(points < 0)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� ilo�� punkt�w karnych.");
		    return 1;
		}
		if(price < 0)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot� za mandat.");
		    return 1;
		}
		OnPlayerSendOffer(playerid, giveplayer_id, reason, OFFER_MANDATE, points, 0, price);
	    return 1;
	}
	
	if(!strcmp(type, "odblokowanie", true) || !strcmp(type, "unblock", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_POLICE || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
	    new giveplayer_id, veh_uid;
	    if(sscanf(varchar, "ud", giveplayer_id, veh_uid))
	    {
	        ShowTipForPlayer(playerid, "/oferuj odblokowanie [ID gracza] [UID pojazdu]");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
   		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		new vehid = GetVehicleID(veh_uid);
		if(vehid == INVALID_VEHICLE_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne UID pojazdu.");
		    return 1;
		}
		if(!CarInfo[vehid][cBlockWheel])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten pojazd nie ma za�o�onej blokady na ko�o.");
		    return 1;
		}
		format(string, sizeof(string), "Zdjecie blokady pojazdu (UID: %d)", CarInfo[vehid][cUID]);
		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_UNBLOCK, vehid, 0, CarInfo[vehid][cBlockWheel]);
		return 1;
	}
	
	if(!strcmp(type, "dokument", true) || !strcmp(type, "document", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
  	 	new doorid = GetPlayerDoorID(playerid);
	  	if(doorid == INVALID_DOOR_ID)
	  	{
        	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	  	{
            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	    new document_type[24], giveplayer_id;
	    if(sscanf(varchar, "us[24]", giveplayer_id, document_type))
	    {
	       	ShowTipForPlayer(playerid, "/oferuj dokument [ID gracza] [Typ dokumentu (dowod, prawko, metryczka, poczytalnosc)]");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
 			return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
  			return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
			return 1;
		}
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(!strcmp(document_type, "dowod", true))
		{
			if(GroupData[group_id][gType] != G_TYPE_GOV || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
			{
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz wyrobi� tego dokumentu.");
		        return 1;
		    }
		    if(PlayerCache[giveplayer_id][pDocuments] & DOC_PROOF)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz posiada ju� dow�d osobisty.");
		        return 1;
		    }
		    OnPlayerSendOffer(playerid, giveplayer_id, "Dowod osobisty", OFFER_DOCUMENT, DOC_PROOF, 0, 80);
		    return 1;
		}
		if(!strcmp(document_type, "prawko", true))
		{
			if(GroupData[group_id][gType] != G_TYPE_GOV || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
			{
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz wyrobi� tego dokumentu.");
		        return 1;
		    }
  			if(PlayerCache[giveplayer_id][pDocuments] & DOC_DRIVER)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz posiada ju� prawo jazdy.");
		        return 1;
		    }
		    if(PlayerCache[giveplayer_id][pMileage] < 15.0)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie potrafi prowadzi� pojazdu (ma przejechane mniej ni� 15km).");
		        return 1;
		    }
		    OnPlayerSendOffer(playerid, giveplayer_id, "Prawo jazdy", OFFER_DOCUMENT, DOC_DRIVER, 0, 350);
		    return 1;
		}
		if(!strcmp(document_type, "metryczka", true))
		{
			if(GroupData[group_id][gType] != G_TYPE_MEDICAL || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
			{
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz wyrobi� tego dokumentu.");
		        return 1;
		    }
   			if(PlayerCache[giveplayer_id][pDocuments] & DOC_SEND)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz posiada ju� metryczk� zdrowia.");
		        return 1;
		    }
		    OnPlayerSendOffer(playerid, giveplayer_id, "Metryczka zdrowia", OFFER_DOCUMENT, DOC_SEND, 0, 250);
		    return 1;
		}
		if(!strcmp(document_type, "poczytalnosc", true))
		{
			if(GroupData[group_id][gType] != G_TYPE_MEDICAL || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
			{
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz wyrobi� tego dokumentu.");
		        return 1;
		    }
   			if(PlayerCache[giveplayer_id][pDocuments] & DOC_SANITY)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz posiada ju� za�wiadczenie o poczytalno�ci.");
		        return 1;
		    }
		    OnPlayerSendOffer(playerid, giveplayer_id, "Zaswiadczenie - poczytalnosc", OFFER_DOCUMENT, DOC_SANITY, 0, 250);
		    return 1;
		}
	    return 1;
	}
	
	if(!strcmp(type, "biznes", true) || !strcmp(type, "business", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_GOV || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_LEADER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
  	 	new doorid = GetPlayerDoorID(playerid);
	  	if(doorid == INVALID_DOOR_ID)
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	new giveplayer_id, business_type, price, business_name[32];
	  	if(sscanf(varchar, "udds[32]", giveplayer_id, business_type, price, business_name))
	  	{
	  	    ShowTipForPlayer(playerid, "/oferuj biznes [ID gracza] [Typ] [Cena] [Nazwa]");
	  	    SendClientMessage(playerid, COLOR_GREY, "Lista dost�pnych typ�w grup, wraz z ich minimalnymi cenami:");

            for (new i = 0; i < sizeof(GroupTypeInfo); i++)
            {
                if(GroupTypeInfo[i][gTypePrice] > 0)
                {
                    SendClientFormatMessage(playerid, COLOR_GREY, "%d | %s | $%d", i + 1, GroupTypeInfo[i][gTypeName], GroupTypeInfo[i][gTypePrice]);
                }
            }
	  	    return 1;
	  	}
  		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
 			return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
  			return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
			return 1;
		}
	  	if(business_type - 1 > sizeof(GroupTypeInfo) || GroupTypeInfo[business_type - 1][gTypePrice] <= 0)
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano nieprawid�owy typ grupy.");
	  	    return 1;
	  	}
	  	if(price < GroupTypeInfo[business_type - 1][gTypePrice])
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podana cena jest mniejsza od minimalnej.");
	  	    return 1;
	  	}
	  	OnPlayerSendOffer(playerid, giveplayer_id, business_name, OFFER_BUSINESS, business_type - 1, 0, price);
	    return 1;
	}
	
	if(!strcmp(type, "rejestracje", true) || !strcmp(type, "register", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_GOV || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
  	 	new doorid = GetPlayerDoorID(playerid);
	  	if(doorid == INVALID_DOOR_ID)
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	    new giveplayer_id, veh_uid;
	    if(sscanf(varchar, "ud", giveplayer_id, veh_uid))
	    {
	        ShowTipForPlayer(playerid, "/oferuj rejestracje [ID gracza] [UID pojazdu]");
	        return 1;
	    }
   		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
   		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		new vehid = GetVehicleID(veh_uid);
		if(vehid == INVALID_VEHICLE_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne UID pojazdu.");
		    return 1;
		}
		if(strlen(CarInfo[vehid][cRegister]))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten pojazd jest ju� zarejestrowany.");
		    return 1;
		}
		format(string, sizeof(string), "Rejestracja pojazdu (UID: %d)", CarInfo[vehid][cUID]);
		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_REGISTER, vehid, 0, 150);
	    return 1;
	}
	
	if(!strcmp(type, "podatek", true) || !strcmp(type, "tax", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_GOV || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
  	 	new doorid = GetPlayerDoorID(playerid);
	  	if(doorid == INVALID_DOOR_ID)
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	new giveplayer_id, group_uid, price;
	  	if(sscanf(varchar, "udd", giveplayer_id, group_uid, price))
	  	{
	  	    ShowTipForPlayer(playerid, "/oferuj podatek [ID gracza] [UID grupy] [Kwota od pracownika]");
	  	    return 1;
	  	}
  		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
   		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		group_id = GetGroupID(group_uid);
		if(group_id == INVALID_GROUP_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
		    return 1;
		}
		if(!IsPlayerInGroup(giveplayer_id, GroupData[group_id][gUID]))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie jest cz�onkiem tej grupy.");
		    return 1;
		}
		if(price <= 0 || price > 300)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Kwota od pracownika nie mo�e by� mniejsza od $0 oraz wi�ksza ni� $200.");
		    return 1;
		}
		new data[12], members_count;
		mysql_query_format("SELECT COUNT(char_uid) FROM `"SQL_PREF"char_groups` WHERE group_belongs = '%d'", GroupData[group_id][gUID]);
		
		mysql_store_result();
		if(mysql_fetch_row_format(data, "|"))
		{
		    sscanf(data, "p<|>d", members_count);
		}
		mysql_free_result();
		
		format(string, sizeof(string), "Podatek - %s (UID: %d)", GroupData[group_id][gName], GroupData[group_id][gUID]);
		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_TAX, group_id, 0, price * members_count);
	    return 1;
	}
	
	if(!strcmp(type, "slub", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_GOV || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
 		new doorid = GetPlayerDoorID(playerid);
	  	if(doorid == INVALID_DOOR_ID)
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	new getplayer_id, giveplayer_id, price;
	  	if(sscanf(varchar, "uud", getplayer_id, giveplayer_id, price))
	  	{
	  	    ShowTipForPlayer(playerid, "/oferuj slub [ID gracza (M)] [ID gracza (K)] [Cena]");
	  	    return 1;
	  	}
  		if(giveplayer_id == playerid || getplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
       		return 1;
    	}
   		if(giveplayer_id == INVALID_PLAYER_ID || getplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged] || !PlayerCache[getplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id) || !PlayerToPlayer(5.0, playerid, getplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(IsPlayerInGroupType(giveplayer_id, G_TYPE_FAMILY) || IsPlayerInGroupType(getplayer_id, G_TYPE_FAMILY))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Kt�ry� z graczy ma ju� rodzin�.");
		    return 1;
		}
		if(!PlayerCache[getplayer_id][pSex] || PlayerCache[giveplayer_id][pSex])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wzi�� �lub mog� tylko p�ci przeciwne (M - m�czyzna, K - kobieta).");
		    return 1;
		}
		if(price < 2000)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Cena �lubu nie mo�e by� mniejsza ni� $2000.");
		    return 1;
		}
		/*
		format(string, sizeof(string), "Slub z %s", PlayerName(giveplayer_id));
		OnPlayerSendOffer(playerid, getplayer_id, string, OFFER_WEDDING, giveplayer_id, 0, price);
		
		format(string, sizeof(string), "Slub z %s", PlayerName(getplayer_id));
		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_WEDDING, giveplayer_id, 0, price);
		*/
	    return 1;
	}
	
	if(!strcmp(type, "leczenie", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_MEDICAL && GroupData[group_id][gType] != G_TYPE_FIREDEPT || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
	    new giveplayer_id, price;
	    if(sscanf(varchar, "ud", giveplayer_id, price))
	    {
	        ShowTipForPlayer(playerid, "/oferuj leczenie [ID gracza] [Cena]");
	        return 1;
	    }
		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	  		return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	  		return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
			return 1;
		}
		if(PlayerCache[giveplayer_id][pHealth] >= 100)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz jest zdrowy.");
		    return 1;
		}
		if(price < 0)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot� za leczenie.");
		    return 1;
		}
		OnPlayerSendOffer(playerid, giveplayer_id, "Leczenie", OFFER_HEAL, 0, 0, price);
		return 1;
	}
	
	if(!strcmp(type, "karnet", true) || !strcmp(type, "pass", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_GYM || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
	  	new doorid = GetPlayerDoorID(playerid);
	  	if(doorid == INVALID_DOOR_ID)
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	new giveplayer_id, price;
	  	if(sscanf(varchar, "ud", giveplayer_id, price))
	  	{
	  	    ShowTipForPlayer(playerid, "/oferuj karnet [ID gracza] [Cena]");
	  	    return 1;
	  	}
		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	  		return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	  		return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
			return 1;
		}
		if(price < 120)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Cena nie mo�e by� mniejsza ni� $120.");
		    return 1;
		}
		format(string, sizeof(string), "(K) %s", GroupData[group_id][gName]);
 		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_PASS, 15, GroupData[group_id][gUID], price);
	    return 1;
	}
	
	if(!strcmp(type, "styl", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_GYM || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
	  	new doorid = GetPlayerDoorID(playerid);
	  	if(doorid == INVALID_DOOR_ID)
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	new giveplayer_id, price, style;
	  	if(sscanf(varchar, "udd", giveplayer_id, price, style))
	  	{
	  	    ShowTipForPlayer(playerid, "/oferuj style [ID gracza] [Cena] [Styl walki (1-3)]");
	  	    
    	   	SendClientMessage(playerid, COLOR_GREY, " ");
	   	 	SendClientMessage(playerid, COLOR_GREY, "Dost�pne style walki:");

			for(new i = 1; i < sizeof(FightStyleData); i++)	SendClientFormatMessage(playerid, COLOR_GREY, "%d - %s", i, FightStyleData[i][0]);
	  	    return 1;
	  	}
		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	  		return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	  		return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
			return 1;
		}
		if(PlayerCache[giveplayer_id][pStrength] < 9000)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz nie posiada wystarczaj�cej ilo�ci si�y (9000j).");
		    return 1;
		}
		if(price < 500)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Cena nie mo�e by� mniejsza ni� $500.");
		    return 1;
		}
		if(style <= 0 || style > 3)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dny styl walki.");
		    return 1;
		}
		OnPlayerSendOffer(playerid, giveplayer_id, FightStyleData[style][0], OFFER_STYLE, style, 0, price);
	    return 1;
	}
	
	if(!strcmp(type, "salon", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_CARDEALER || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
	  	new doorid = GetPlayerDoorID(playerid);
	  	if(doorid == INVALID_DOOR_ID)
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
		}
	  	new giveplayer_id, veh_name[32];
	  	if(sscanf(varchar, "us[32]", giveplayer_id, veh_name))
	  	{
	  	    ShowTipForPlayer(playerid, "/oferuj salon [ID gracza] [Nazwa pojazdu]");
	  	    return 1;
	  	}
		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	  		return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	  		return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
			return 1;
		}
		new veh_model;
		for(new i = 0; i < sizeof(VehicleModelData); i++)
		{
			if(!strcmp(veh_name, VehicleModelData[i][vName], true))
			{
				veh_model = i + 400;
				break;
  			}
		}
		mysql_query_format("SELECT `salon_price` FROM `"SQL_PREF"salon_vehicles` WHERE salon_model = '%d' LIMIT 1", veh_model);
		mysql_store_result();
		
		new veh_price = cache_get_row_int(0, 0);
		mysql_free_result();
		
		if(veh_price > 0)
		{
			format(string, sizeof(string), "%s", GetVehicleName(veh_model));
 			OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_SALON, veh_model, 0, veh_price);
		}
		else
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono pojazdu o tej nazwie.");
		}
		return 1;
	}
	
	if(!strcmp(type, "kluczyki", true) || !strcmp(type, "keys", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_CARDEALER || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
 		new doorid = GetPlayerDoorID(playerid);
	  	if(doorid == INVALID_DOOR_ID)
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
  		new giveplayer_id, veh_uid;
		if(sscanf(varchar, "ud", giveplayer_id, veh_uid))
		{
		    ShowTipForPlayer(playerid, "/salon kluczyki [ID gracza] [UID pojazdu]");
		    return 1;
		}
		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	  		return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	  		return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
			return 1;
		}
	    new vehid = GetVehicleID(veh_uid);
	    if(vehid == INVALID_VEHICLE_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Pojazd musi by� zespawnowany.");
	        return 1;
	    }
	    if(CarInfo[vehid][cOwnerType] != OWNER_PLAYER)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz nie jest w�a�cicielem tego pojazdu.");
	        return 1;
	    }
	    if(CarInfo[vehid][cOwner] != PlayerCache[giveplayer_id][pUID])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz nie jest w�a�cicielem tego pojazdu.");
	        return 1;
	    }
   		format(string, sizeof(string), "Kluczyki - %s (UID: %d)", GetVehicleName(CarInfo[vehid][cModel]), CarInfo[vehid][cUID]);
 		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_KEYS, vehid, 0, 80);
	    return 1;
	}
	
	if(!strcmp(type, "reklame", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_NEWS || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
	    new giveplayer_id, time, price;
	    if(sscanf(varchar, "udd", giveplayer_id, time, price))
	    {
	        ShowTipForPlayer(playerid, "/oferuj reklame [ID gracza] [Czas (min)] [Cena]");
	        return 1;
	    }
		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	  		return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	  		return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
			return 1;
		}
		format(string, sizeof(string), "Nadanie reklamy (%d min)", time);
		OnPlayerSendOffer(playerid, giveplayer_id, string, OFFER_ADVERTISE, time, 0, price);
		return 1;
	}
	
	if(!strcmp(type, "lekcja", true) || !strcmp(type, "lesson", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
  	    {
  	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy, by m�c co� oferowa�.");
  	        return 1;
  	    }
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_DRIVING || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_OFFER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz niczego oferowa�.");
		    return 1;
		}
	  	new doorid = GetPlayerDoorID(playerid);
	  	if(doorid == INVALID_DOOR_ID)
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	  	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	  	{
	  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku grupy, by m�c oferowa�.");
	  	    return 1;
	  	}
	    new giveplayer_id, lesson_time, price;
	    if(sscanf(varchar, "udd", giveplayer_id, lesson_time, price))
	    {
	        ShowTipForPlayer(playerid, "/oferuj lekcja [ID gracza] [Czas (min)] [Cena]");
	        return 1;
	    }
		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaoferowa� czego� sobie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	  		return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	  		return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
			return 1;
		}
		if(price < 200)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Cena nie mo�e by� mniejsza ni� 200$!");
		    return 1;
		}
		if(lesson_time <= 0 || lesson_time > 10)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owy czas lekcji.\nNie mo�e by� wi�kszy ni� 10 min.");
		    return 1;
		}
		OnPlayerSendOffer(playerid, giveplayer_id, "Lekcja jazdy", OFFER_LESSON, lesson_time, group_id, price);
	    return 1;
	}
	return 1;
}

CMD:o(playerid, params[])   return cmd_oferuj(playerid, params);

CMD:bank(playerid, params[])
{
	new doorid = GetPlayerDoorID(playerid);
	if(doorid == INVALID_DOOR_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w banku.");
	    return 1;
	}
	if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w banku.");
	    return 1;
	}
	new group_id = GetGroupID(DoorCache[doorid][dOwner]);
	if(GroupData[group_id][gType] != G_TYPE_BANK)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w banku.");
	    return 1;
	}
	if(!PlayerCache[playerid][pBankNumber])
	{
		ShowPlayerDialog(playerid, D_BANK_CREATE_ACCOUNT, DIALOG_STYLE_MSGBOX, "Informacja", "Aby w pe�ni korzysta� z funkcji banku musisz za�o�y� konto bankowe,\ndo kt�rego b�dzie przypisany odpowiedni numer bankowy.\n\nNumer bankowy b�dzie wykorzystywany do wszystkich akcji zwi�zanych z pieni�dzmi w banku.\nCzy chcesz za�o�y� konto bankowe?", "Tak", "Nie");
  	}
  	else
  	{
   		ShowPlayerDialog(playerid, D_BANK_SELECT_OPTIONS, DIALOG_STYLE_LIST, "Wybierz opcj�", "1. Stan konta\n2. Wp�a� got�wk�\n3. Wyp�a� got�wk�\n4. Dokonaj przelewu", "Wybierz", "Anuluj");
   	}
	return 1;
}

CMD:bankomat(playerid, params[])
{
	new object_id = GetClosestObjectType(playerid, OBJECT_ATM);
	if(object_id == INVALID_OBJECT_ID)
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� przy bankomacie.");
   		return 1;
	}
	if(!PlayerCache[playerid][pBankNumber])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby m�c korzysta� z bankomatu, musisz posiada� konto bankowe.");
	    return 1;
	}
	ApplyAnimation(playerid, "PED", "ATM", 4.0, 0, 0, 0, 0, 0, true);
	ShowPlayerDialog(playerid, D_BANK_SELECT_OPTIONS, DIALOG_STYLE_LIST, "Bankomat", "1. Stan konta\n2. Wp�a� got�wk�\n3. Wyp�a� got�wk�", "Wybierz", "Anuluj");
	return 1;
}

CMD:mc(playerid, params[])
{
	new modelid;
	if(sscanf(params, "d", modelid))
	{
	    ShowTipForPlayer(playerid, "/mc [Model]");
	    return 1;
	}
	if(PlayerCache[playerid][pEditObject] != INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz tworzy� nowych obiekt�w podczas edycji.");
	    return 1;
	}
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_OBJECTS))
	{
		new doorid = GetPlayerDoorID(playerid);
		if(doorid != INVALID_DOOR_ID)
		{
			if(DoorCache[doorid][dOwnerType] == OWNER_NONE)
			{
				ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
				return 1;
			}
			if(DoorCache[doorid][dOwnerType] == OWNER_PLAYER)
			{
		 		if(DoorCache[doorid][dOwner] != PlayerCache[playerid][pUID])
		   		{
					ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		   			return 1;
				}
			}
			if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
			{
			    if(!HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_LEADER))
			    {
			        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
			        return 1;
			    }
			}
		}
		else
		{
		    new areaid = GetPlayerAreaID(playerid);
		    if(areaid == INVALID_AREA_ID)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby m�c stworzy� obiekt, musisz znajdowa� si� w budynku lub strefie.");
		        return 1;
		    }
		    if(AreaCache[areaid][aOwnerType] == OWNER_NONE)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		        return 1;
		    }
		    if(AreaCache[areaid][aOwnerType] == OWNER_PLAYER)
		    {
		        if(AreaCache[areaid][aOwner] != PlayerCache[playerid][pUID])
		        {
		            ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		            return 1;
		        }
		    }
		    if(AreaCache[areaid][aOwnerType] == OWNER_GROUP)
		    {
		        if(!HavePlayerGroupPerm(playerid, AreaCache[areaid][aOwner], G_PERM_LEADER))
		        {
		            ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		            return 1;
		        }
		    }
		    
    		new count_objects = Streamer_CountVisibleItems(playerid, STREAMER_TYPE_OBJECT),
    		    Float:objX, Float:objY, Float:objZ;
    		    
			for (new player_object = 0; player_object <= count_objects; player_object++)
			{
			    if(IsValidPlayerObject(playerid, player_object))
			    {
			        GetPlayerObjectPos(playerid, player_object, objX, objY, objZ);
			    
			    	if(!IsPointInDynamicArea(areaid, objX, objY, objZ))
			    	{
			    	    count_objects --;
			    	}
				}
			}
			
			new AreaField, Side[2], ObjectLimit;
  			Side[0] = floatround((AreaCache[areaid][aMinX] > AreaCache[areaid][aMaxX]) ? (AreaCache[areaid][aMinX] - AreaCache[areaid][aMaxX]) : (AreaCache[areaid][aMaxX] - AreaCache[areaid][aMinX]));
		    Side[1] = floatround((AreaCache[areaid][aMinY] > AreaCache[areaid][aMaxY]) ? (AreaCache[areaid][aMinY] - AreaCache[areaid][aMaxY]) : (AreaCache[areaid][aMaxY] - AreaCache[areaid][aMinY]));

		    AreaField = Side[0] * Side[1];
		    ObjectLimit = (IsPlayerPremium(playerid)) ? (AreaField / (Side[0] + Side[1])) * 2 : (AreaField / (Side[0] + Side[1]));
		    
			if(count_objects >= ObjectLimit)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz postawi� wi�cej ni� %d obiekt�w w tej strefie.", ObjectLimit);
			    return 1;
			}
		}
	}
	if(!IsValidObjectModel(modelid))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owy model obiektu.");
	    return 1;
	}
	new Float:PosX, Float:PosY, Float:PosZ,
	    interior_id = GetPlayerInterior(playerid), world_id = GetPlayerVirtualWorld(playerid);

	GetPlayerPos(playerid, PosX, PosY, PosZ);
	GetXYInFrontOfPlayer(playerid, PosX, PosY, 2.0);
	
	new object_id = crp_AddObject(modelid, PosX, PosY, PosZ, 0.0, 0.0, 0.0, interior_id, world_id);

	Streamer_Update(playerid);
	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Obiekt zosta� stworzony pomy�lnie, pownien pojawi� si� tu� przed Tob�.\nAby zarz�dza� stworzonym obiektem u�yj komendy /msel w pobli�u niego.\n\nModel obiektu: %d\nIdentyfikator: %d", modelid, GetObjectUID(object_id));
	return 1;
}

CMD:oc(playerid, params[])  return cmd_mc(playerid, params);

CMD:msel(playerid, params[])
{
	if(PlayerCache[playerid][pEditObject] != INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie edytujesz ju� jaki� obiekt.");
	    return 1;
	}
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_OBJECTS))
	{
		new doorid = GetPlayerDoorID(playerid);
		if(doorid != INVALID_DOOR_ID)
		{
			if(DoorCache[doorid][dOwnerType] == OWNER_NONE)
			{
				ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
				return 1;
			}
			if(DoorCache[doorid][dOwnerType] == OWNER_PLAYER)
			{
		 		if(DoorCache[doorid][dOwner] != PlayerCache[playerid][pUID])
		   		{
					ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		   			return 1;
				}
			}
			if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
			{
			    if(!HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_LEADER))
			    {
			        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
			        return 1;
			    }
			}
		}
		else
		{
		    new areaid = GetPlayerAreaID(playerid);
		    if(areaid == INVALID_AREA_ID)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby m�c edytowa� obiekt, musisz znajdowa� si� w budynku lub strefie.");
		        return 1;
		    }
		    if(AreaCache[areaid][aOwnerType] == OWNER_NONE)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		        return 1;
		    }
		    if(AreaCache[areaid][aOwnerType] == OWNER_PLAYER)
		    {
		        if(AreaCache[areaid][aOwner] != PlayerCache[playerid][pUID])
		        {
		            ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		            return 1;
		        }
		    }
		    if(AreaCache[areaid][aOwnerType] == OWNER_GROUP)
		    {
		        if(!HavePlayerGroupPerm(playerid, AreaCache[areaid][aOwner], G_PERM_LEADER))
		        {
		            ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		            return 1;
		        }
		    }
		    PlayerCache[playerid][pCurrentArea] = areaid;
		}
	}

	new object_model;
	if(sscanf(params, "d", object_model))
	{
		SelectObject(playerid);
		TD_ShowSmallInfo(playerid, 5, "Wybierz ~b~obiekt ~w~do edycji (klawisz ~r~~k~~PED_FIREWEAPON~~w~).");
		return 1;
	}

	new object_id = GetClosestObjectType(playerid, object_model);
	if(object_id == INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego obiektu o podanym modelu w pobli�u.");
	    return 1;
	}
	new Float:PosX, Float:PosY, Float:PosZ;
	GetDynamicObjectPos(object_id, PosX, PosY, PosZ);
	
	OnPlayerSelectDynamicObject(playerid, object_id, object_model, PosX, PosY, PosZ);
	return 1;
}

CMD:osel(playerid, params[])    return cmd_msel(playerid, params);

CMD:mdel(playerid, params[])
{
	if(PlayerCache[playerid][pEditObject] == INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie edytujesz aktualnie �adnego obiektu.");
	    return 1;
	}
	new object_id = PlayerCache[playerid][pEditObject];
	
	PlayerCache[playerid][pEditObject] = INVALID_OBJECT_ID;
	PlayerCache[playerid][pCurrentArea] = INVALID_AREA_ID;
	
	CancelEdit(playerid);
	DeleteObject(object_id);
	
	TD_HideLargeInfo(playerid);
	TD_ShowSmallInfo(playerid, 3, "~b~Obiekt ~w~zostal calkowicie ~r~usuniety~w~.");
	return 1;
}

CMD:odel(playerid, params[])    return cmd_mdel(playerid, params);

CMD:mgate(playerid, params[])
{
	if(PlayerCache[playerid][pEditObject] == INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie edytujesz aktualnie �adnego obiektu.");
	    return 1;
	}
	new object_id = PlayerCache[playerid][pEditObject], object_uid = GetObjectUID(object_id), player_object = PlayerCache[playerid][pMainTable],
		Float:GateX, Float:GateY, Float:GateZ, Float:GateRX, Float:GateRY, Float:GateRZ;

	GetPlayerObjectPos(playerid, player_object, GateX, GateY, GateZ);
	GetPlayerObjectRot(playerid, player_object, GateRX, GateRY, GateRZ);
	
	mysql_query_format("UPDATE `"SQL_PREF"objects` SET object_gatex = '%f', object_gatey = '%f', object_gatez = '%f', object_gaterx = '%f', object_gatery = '%f', object_gaterz = '%f', object_gate = '1' WHERE object_uid = '%d' LIMIT 1", GateX, GateY, GateZ, GateRX, GateRY, GateRZ, object_uid);
	
	Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_X, GateX);
	Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_Y, GateY);
	Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_Z, GateZ);
	
	Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RX, GateRX);
	Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RY, GateRY);
	Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RZ, GateRZ);
	
	CancelEdit(playerid);
	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Brama zosta�a utworzona.\nSkorzystaj z komendy /brama.");
	return 1;
}

CMD:ogate(playerid, params[])   return cmd_mgate(playerid, params);

CMD:mmat(playerid, params[])
{
	if(PlayerCache[playerid][pEditObject] == INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie edytujesz aktualnie �adnego obiektu.");
	    return 1;
	}
	new material_type, varchar[128];
	if(sscanf(params, "dS()[128]", material_type, varchar))
	{
	    ShowTipForPlayer(playerid, "/mmat [Typ 0 - tekstura, 1 - tekst] [Pozosta�e]");
	    return 1;
	}

	// Material
	if(material_type == 0)
	{
	    new index, color, modelid, txdname[32], texturename[64];
	    if(sscanf(varchar, "dxds[32]s[64]", index, color, modelid, txdname, texturename))
	    {
	        ShowTipForPlayer(playerid, "/mmat 0 [Index (0-5)] [Kolor (ARGB)] [Model] [Txdname] [Texturename]");
	        return 1;
	    }
	    new object_id = PlayerCache[playerid][pEditObject];
	    SetDynamicObjectMaterial(object_id, index, modelid, txdname, texturename, color);
	    
	    mysql_query_format("UPDATE `"SQL_PREF"objects` SET object_material = '%d %d %x %d %s %s' WHERE object_uid = '%d' LIMIT 1", material_type, index, color, modelid, txdname, texturename, GetObjectUID(object_id));
	    return 1;
	}

	// Tekst
	if(material_type == 1)
	{
	    new index, matsize, fontsize, bold, fontcolor, backcolor, alignment, fonttype[12], text[128];
	    if(sscanf(varchar, "ddddxxds[12]s[64]", index, matsize, fontsize, bold, fontcolor, backcolor, alignment, fonttype, text))
	    {
	        ShowTipForPlayer(playerid, "/mmat 1 [Index (0-5)] [Matsize (10-140)] [Fontsize (24-255)] [Bold] [Fontcol] [Backcol] [Align (0-2)] [Font] [Txt]");
	        return 1;
	    }
	    new object_id = PlayerCache[playerid][pEditObject];
	    format(text, sizeof(text), "%s", WordWrap(text, WRAP_MANUAL));
	    
	    SetDynamicObjectMaterialText(object_id, index, text, matsize, fonttype, fontsize, bold, fontcolor, backcolor, alignment);
	    mysql_query_format("UPDATE `"SQL_PREF"objects` SET object_material = '%d %d %d %d %d %x %x %d %s %s' WHERE object_uid = '%d' LIMIT 1", material_type, index, matsize, fontsize, bold, fontcolor, backcolor, alignment, fonttype, text, GetObjectUID(object_id));
	    return 1;
	}
	return 1;
}

CMD:omat(playerid, params[])    return cmd_mmat(playerid, params);

CMD:rx(playerid, params[])
{
	if(PlayerCache[playerid][pEditObject] == INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie edytujesz aktualnie �adnego obiektu.");
	    return 1;
	}
	new Float:rot_x;
	if(sscanf(params, "f", rot_x))
	{
	    ShowTipForPlayer(playerid, "/rx [Rotacja X]");
	    return 1;
	}
	new object_id = PlayerCache[playerid][pEditObject],
		Float:RotX, Float:RotY, Float:RotZ;
	
	GetDynamicObjectRot(object_id, RotX, RotY, RotZ);
	RotX = rot_x;
	
	SetDynamicObjectRot(object_id, RotX, RotY, RotZ);
	return 1;
}

CMD:ry(playerid, params[])
{
	if(PlayerCache[playerid][pEditObject] == INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie edytujesz aktualnie �adnego obiektu.");
	    return 1;
	}
	new Float:rot_y;
	if(sscanf(params, "f", rot_y))
	{
	    ShowTipForPlayer(playerid, "/ry [Rotacja Y]");
	    return 1;
	}
	new object_id = PlayerCache[playerid][pEditObject],
		Float:RotX, Float:RotY, Float:RotZ;

	GetDynamicObjectRot(object_id, RotX, RotY, RotZ);
	RotY = rot_y;

	SetDynamicObjectRot(object_id, RotX, RotY, RotZ);
	return 1;
}

CMD:rz(playerid, params[])
{
	if(PlayerCache[playerid][pEditObject] == INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie edytujesz aktualnie �adnego obiektu.");
	    return 1;
	}
	new Float:rot_z;
	if(sscanf(params, "f", rot_z))
	{
	    ShowTipForPlayer(playerid, "/rz [Rotacja Z]");
	    return 1;
	}
	new object_id = PlayerCache[playerid][pEditObject],
		Float:RotX, Float:RotY, Float:RotZ;

	GetDynamicObjectRot(object_id, RotX, RotY, RotZ);
	RotZ = rot_z;

	SetDynamicObjectRot(object_id, RotX, RotY, RotZ);
	return 1;
}

CMD:brama(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_OBJECTS))
	{
		new doorid = GetPlayerDoorID(playerid);
		if(doorid != INVALID_DOOR_ID)
		{
			if(DoorCache[doorid][dOwnerType] == OWNER_NONE)
			{
				ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
				return 1;
			}
			if(DoorCache[doorid][dOwnerType] == OWNER_PLAYER)
			{
		 		if(DoorCache[doorid][dOwner] != PlayerCache[playerid][pUID] && PlayerCache[playerid][pHouse] != DoorCache[doorid][dUID])
		   		{
					ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		   			return 1;
				}
			}
			if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
			{
			    if(!HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_GATE))
			    {
			        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
			        return 1;
			    }
			}
		}
		else
		{
		    new areaid = GetPlayerAreaID(playerid);
		    if(areaid == INVALID_AREA_ID)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby m�c skorzysta� z bramy, musisz znajdowa� si� w budynku lub strefie.");
		        return 1;
		    }
		    if(AreaCache[areaid][aOwnerType] == OWNER_NONE)
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		        return 1;
		    }
		    if(AreaCache[areaid][aOwnerType] == OWNER_PLAYER)
		    {
		        if(AreaCache[areaid][aOwner] != PlayerCache[playerid][pUID])
		        {
		            ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		            return 1;
		        }
		    }
		    if(AreaCache[areaid][aOwnerType] == OWNER_GROUP)
		    {
		        if(!HavePlayerGroupPerm(playerid, AreaCache[areaid][aOwner], G_PERM_GATE))
		        {
		            ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Ten budynek lub strefa nie nale�y do Ciebie.");
		            return 1;
		        }
		    }
		}
	}
	new count_objects = Streamer_CountVisibleItems(playerid, STREAMER_TYPE_OBJECT), object_id,
	    Float:PosX, Float:PosY, Float:PosZ, Float:dist, count_gates, gate_status;
	    
	new Float:object_pos[6], Float:object_gate[6], Float:object_move[6];
	
	if(IsPlayerInAnyVehicle(playerid))  	dist = 8.0;
	else                                	dist = 4.0;
	    
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	for (new player_object = 0; player_object <= count_objects; player_object++)
	{
	    if(IsValidPlayerObject(playerid, player_object))
	    {
			object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);
			if(GetDynamicObjectGatePos(object_id, object_gate[0], object_gate[1], object_gate[2], object_gate[3], object_gate[4], object_gate[5]))
			{
			    GetDynamicObjectPos(object_id, object_pos[0], object_pos[1], object_pos[2]);
			    GetDynamicObjectRot(object_id, object_pos[3], object_pos[4], object_pos[5]);
			    
				if(IsPlayerInRangeOfPoint(playerid, dist, object_pos[0], object_pos[1], object_pos[2]) || IsPlayerInRangeOfPoint(playerid, dist, object_gate[0], object_gate[1], object_gate[2]))
				{
          	 		if(!IsDynamicObjectMoving(object_id))
          	 		{
          	 		    object_move[0] = object_pos[0];
          	 		    object_move[1] = object_pos[1];
          	 		    object_move[2] = object_pos[2];
          	 		    
          	 		    object_move[3] = object_pos[3];
          	 		    object_move[4] = object_pos[4];
          	 		    object_move[5] = object_pos[5];
          	 		}
          	 		else
          	 		{
          	 		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_MOVE_X, object_move[0]);
          	 		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_MOVE_Y, object_move[1]);
          	 		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_MOVE_Z, object_move[2]);
          	 		    
          	 		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_MOVE_R_X, object_move[3]);
          	 		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_MOVE_R_Y, object_move[4]);
          	 		    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_MOVE_R_Z, object_move[5]);
					}
					
					gate_status = Streamer_GetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE);
	    			MoveDynamicObject(object_id, object_gate[0], object_gate[1], object_gate[2], 3.0, object_gate[3], object_gate[4], object_gate[5]);
			            
    			    if(gate_status)	GameTextForPlayer(playerid, "~w~Brama ~r~zamknieta", 4000, 6);
    			    else			GameTextForPlayer(playerid, "~w~Brama ~g~otwarta", 4000, 6);

					Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_X, object_move[0]);
      				Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_Y, object_move[1]);
       				Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_Z, object_move[2]);
       				
					Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RX, object_move[3]);
      				Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RY, object_move[4]);
       				Streamer_SetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE_RZ, object_move[5]);
			            
                    Streamer_SetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_GATE, (gate_status) ? false : true);
                    
           			count_gates ++;
           			continue;
      			}
			}
	    }
	}
	
	if(!count_gates)
	{
	    TD_ShowSmallInfo(playerid, 3, "Nie znaleziono ~r~zadnych ~w~bram w poblizu.");
	    return 1;
	}
	return 1;
}

CMD:ec(playerid, params[])
{
	new Float:distance, desc[128];
	if(sscanf(params, "fs[128]", distance, desc))
	{
	    ShowTipForPlayer(playerid, "/ec [Odleg�o��] [Tre��]");
	    return 1;
	}
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_3DTEXTS))
	{
		new doorid = GetPlayerDoorID(playerid);
		if(doorid == INVALID_DOOR_ID)
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby m�c stworzy� obiekt, musisz znajdowa� si� w budynku.");
	   		return 1;
		}
		if(DoorCache[doorid][dOwnerType] == OWNER_NONE)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten budynek nie nale�y do Ciebie.");
			return 1;
		}
		if(DoorCache[doorid][dOwnerType] == OWNER_PLAYER)
		{
	 		if(DoorCache[doorid][dOwner] != PlayerCache[playerid][pUID])
	   		{
				ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten budynek nie nale�y do Ciebie.");
	   			return 1;
			}
		}
		if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
		{
			if(!HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_LEADER))
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten budynek nie nale�y do Ciebie.");
			    return 1;
			}
		}
	}
	new Float:PosX, Float:PosY, Float:PosZ,
	    interior_id = GetPlayerInterior(playerid), world_id = GetPlayerVirtualWorld(playerid);

	GetPlayerPos(playerid, PosX, PosY, PosZ);
	GetXYInFrontOfPlayer(playerid, PosX, PosY, 2.0);

	Add3DTextLabel(WordWrap(desc, WRAP_MANUAL), COLOR_WHITE, PosX, PosY, PosZ, distance, world_id, interior_id);
	Streamer_Update(playerid);
	
	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Etykieta 3D zosta�a pomy�lnie stworzona, powinna pojawi� si� tu� przed Tob�.\nAby zarz�dza� stworzon� etykiet� u�yj komendy /esel w pobli�u jej.");
	return 1;
}

CMD:tc(playerid, params[])  return cmd_ec(playerid, params);

CMD:esel(playerid, params[])
{
	if(PlayerCache[playerid][pEdit3DText] != INVALID_3DTEXT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie edytujesz ju� jak�� etykiet�.");
	    return 1;
	}
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_3DTEXTS))
	{
		new doorid = GetPlayerDoorID(playerid);
		if(doorid == INVALID_DOOR_ID)
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Edytowa� etykiety mo�esz tylko b�d�c w budynku, kt�rego w�a�cicielem jeste�.");
	   		return 1;
		}
		if(DoorCache[doorid][dOwnerType] == OWNER_NONE)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Edytowa� etykiety mo�esz tylko b�d�c w budynku, kt�rego w�a�cicielem jeste�.");
			return 1;
		}
		if(DoorCache[doorid][dOwnerType] == OWNER_PLAYER)
		{
	 		if(DoorCache[doorid][dOwner] != PlayerCache[playerid][pUID])
	   		{
				ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Edytowa� etykiety mo�esz tylko b�d�c w budynku, kt�rego w�a�cicielem jeste�.");
	   			return 1;
			}
		}
		if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
		{
			if(!HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_LEADER))
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Edytowa� etykiety mo�esz tylko b�d�c w budynku, kt�rego w�a�cicielem jeste�.");
			    return 1;
			}
		}
	}
	new label_id = GetClosestLabel(playerid);
	if(label_id == INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnej etykiety w pobli�u.");
	    return 1;
	}
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pEdit3DText] == label_id)
			{
			    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Kto� aktualnie edytuje t� etykiet�.");
			    return 1;
			}
	    }
	}
	new Float:PosX, Float:PosY, Float:PosZ;
	
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_X, PosX);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_Y, PosY);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_Z, PosZ);

	SetPlayerCameraPos(playerid, PosX + 3, PosY + 4, PosZ + 4);
	SetPlayerCameraLookAt(playerid, PosX, PosY, PosZ);

	OnPlayerFreeze(playerid, true, 0);
	PlayerCache[playerid][pEdit3DText] = label_id;

	TD_ShowSmallInfo(playerid, 0, "Edytor etykiety ~g~aktywny~w~.~n~~n~~y~/esave ~w~- zapisz pozycje etykiety~n~~y~/edel ~w~- usun etykiete");
	return 1;
}

CMD:tsel(playerid, params[])  return cmd_esel(playerid, params);

CMD:esave(playerid, params[])
{
	if(PlayerCache[playerid][pEdit3DText] == INVALID_3DTEXT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie edytujesz aktualnie �adnej etykiety.");
	    return 1;
	}
	new label_id = PlayerCache[playerid][pEdit3DText];

	OnPlayerFreeze(playerid, false, 0);
	ResetPlayerCamera(playerid);

	Save3DTextLabel(label_id);
	PlayerCache[playerid][pEdit3DText] = INVALID_3DTEXT_ID;

	TD_ShowSmallInfo(playerid, 3, "Pozycja etykiety zostala ~g~pomyslnie ~w~zapisana.");
	return 1;
}

CMD:tsave(playerid, params[])  return cmd_esave(playerid, params);

CMD:edel(playerid, params[])
{
	if(PlayerCache[playerid][pEdit3DText] == INVALID_3DTEXT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie edytujesz aktualnie �adnej etykiety.");
	    return 1;
	}
	new label_id = PlayerCache[playerid][pEdit3DText];

	OnPlayerFreeze(playerid, false, 0);
	ResetPlayerCamera(playerid);

	Destroy3DTextLabel(label_id);
	PlayerCache[playerid][pEdit3DText] = INVALID_3DTEXT_ID;

	TD_ShowSmallInfo(playerid, 3, "Etykieta zostala ~r~calkowicie ~w~usunieta.");
	return 1;
}

CMD:tdel(playerid, params[])  return cmd_edel(playerid, params);

CMD:tankuj(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby zatankowa� pojazd musisz znajdowa� si� obok niego.");
	    return 1;
	}
	new object_id = GetClosestObjectType(playerid, OBJECT_FUELING);
	if(object_id == INVALID_OBJECT_ID)
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego dystrybutora w pobli�u.");
   		return 1;
	}
	new bens_type, value, string[128];
	if(sscanf(params, "dd", bens_type, value))
	{
	    ShowTipForPlayer(playerid, "/tankuj [Rodzaj paliwa] [Ilo�� litr�w]");
	    
	    SendClientMessage(playerid, COLOR_GREY, " ");
   	 	SendClientMessage(playerid, COLOR_GREY, "Dost�pne rodzaje paliwa:");

		SendClientMessage(playerid, COLOR_GREY, "1 - Benzyna");
		SendClientMessage(playerid, COLOR_GREY, "2 - Gaz");
		SendClientMessage(playerid, COLOR_GREY, "3 - Diesel");
	    return 1;
	}
	new vehid = GetClosestVehicle(playerid);
	if(vehid == INVALID_VEHICLE_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego pojazdu w pobli�u.");
	    return 1;
	}
	if(bens_type < 0 || bens_type > 3)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wybrano nieprawid�owy rodzaj paliwa.");
	    return 1;
	}
	if((bens_type - 1) != CarInfo[vehid][cFuelType])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wybrany rodzaj paliwa nie pasuje tego pojazdu.");
	    return 1;
	}
	if(value <= 0)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� ilo�� litr�w.");
	    return 1;
	}
	if(value + CarInfo[vehid][cFuel] > GetVehicleMaxFuel(CarInfo[vehid][cModel]))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W baku nie zmie�ci si� tyle paliwa.");
	    return 1;
	}
	new price;
	bens_type -= 1;

	if(bens_type == FUEL_TYPE_BENS) 			price = floatround(value * 4.5);
	else if(bens_type == FUEL_TYPE_GAS) 		price = floatround(value * 2.5);
	else if(bens_type == FUEL_TYPE_DIESEL) 		price = floatround(value * 4.0);

	if(PlayerCache[playerid][pCash] < price)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz takiej ilo�ci got�wki.");
	    return 1;
	}
	crp_GivePlayerMoney(playerid, -price);
	OnPlayerSave(playerid, SAVE_PLAYER_BASIC);

	CarInfo[vehid][cFuel] = floatadd(CarInfo[vehid][cFuel], value);
	SaveVehicle(vehid, SAVE_VEH_COUNT);

	SendClientFormatMessage(playerid, COLOR_LIGHTBLUE, "Zap�aci�e� $%d za %d litr�w paliwa.", price, value);
	ApplyAnimation(playerid, "INT_HOUSE", "wash_up",4.1, 0, 0, 0, 0, 0, 1);

	format(string, sizeof(string), "* %s wk�ada w�� do baku.", PlayerName(playerid));
	ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

	format(string, sizeof(string), "* Pojazd %s zosta� pomy�lnie zatankowany (( %s ))", GetVehicleName(CarInfo[vehid][cModel]), PlayerName(playerid));
    ProxDetector(10.0, playerid, string, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO);
    
    TD_ShowSmallInfo(playerid, 10, "Jezeli tankujesz z pomoca ~y~mechanika ~w~koszt za paliwo wychodzi nawet do ~r~40%% ~w~taniej! Warto wiec sprobowac.");
	return 1;
}

CMD:zatankuj(playerid, params[]) return cmd_tankuj(playerid, params);

CMD:pokoj(playerid, params[])
{
	new type[32], varchar[32], doorid = GetPlayerDoorID(playerid);
	if(sscanf(params, "s[32]S()[32]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/pokoj [zamelduj, wymelduj, wejdz, wyjdz, koszt]");
	    return 1;
	}
	if(!strcmp(type, "zamelduj", true))
	{
		if(doorid == INVALID_DOOR_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
		if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
		{
      		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
		new group_id = GetGroupID(DoorCache[doorid][dOwner]);
		if(GroupData[group_id][gType] != G_TYPE_HOTEL)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
	    if(PlayerCache[playerid][pHouse] == DoorCache[doorid][dOwner])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Jeste� ju� zameldowany w tym hotelu.");
	        return 1;
	    }
	    PlayerCache[playerid][pHouse] = DoorCache[doorid][dUID];
	    ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Wynaj��e� pok�j w hotelu \"%s\".\nOp�ata b�dzie pobierana przy ka�dej wyp�acie.\n\nTw�j numer pokoju to: %d", DoorCache[doorid][dName], PlayerCache[playerid][pUID]);
	    return 1;
	}
	if(!strcmp(type, "wymelduj", true))
	{
		if(doorid == INVALID_DOOR_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
		if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
		new group_id = GetGroupID(DoorCache[doorid][dOwner]);
		if(GroupData[group_id][gType] != G_TYPE_HOTEL)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
	    if(PlayerCache[playerid][pHouse] != DoorCache[doorid][dUID])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu, kt�rym jeste� zameldowany.");
	        return 1;
	    }
	    PlayerCache[playerid][pHouse] = 0;
	    ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Sko�czy�e� wynajmowanie pokoju w tym hotelu.\nOp�ata za wynajm nie b�dzie ju� wi�cej pobierana.");
	    return 1;
	}
	if(!strcmp(type, "wejdz", true))
	{
		if(doorid == INVALID_DOOR_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
		if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
		new group_id = GetGroupID(DoorCache[doorid][dOwner]);
		if(GroupData[group_id][gType] != G_TYPE_HOTEL)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
	    new room;
	    if(sscanf(varchar, "d", room))
	    {
	        ShowTipForPlayer(playerid, "/pokoj wejdz [Numer pokoju]");
	        return 1;
	    }
	    foreach(new i : Player)
		{
		    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
		    {
		        if(PlayerCache[i][pHouse] == DoorCache[doorid][dUID])
		        {
		            if(PlayerCache[i][pUID] == room)
		            {
						crp_SetPlayerPos(playerid, PosInfo[HOTEL_SPAWN_POS][sPosX], PosInfo[HOTEL_SPAWN_POS][sPosY], PosInfo[HOTEL_SPAWN_POS][sPosZ]);
						SetPlayerFacingAngle(playerid, PosInfo[HOTEL_SPAWN_POS][sPosA]);
						
						SetPlayerInterior(playerid, PosInfo[HOTEL_SPAWN_POS][sPosInterior]);
						SetPlayerVirtualWorld(playerid, PlayerCache[i][pUID]);
						
						ResetPlayerCamera(playerid);
						TD_ShowSmallInfo(playerid, 3, "Uzyj komendy ~y~/pokoj wyjdz~w~, aby opuscic pokoj.");
						return 1;
		            }
		        }
		    }
		}
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Drzwi od tego pokoju s� zamkni�te.");
		return 1;
	}
	if(!strcmp(type, "wyjdz", true))
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 30.0, PosInfo[HOTEL_SPAWN_POS][sPosX], PosInfo[HOTEL_SPAWN_POS][sPosY], PosInfo[HOTEL_SPAWN_POS][sPosZ]))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� w pokoju hotelowym.");
	        return 1;
	    }
	    foreach(new i : Player)
		{
		    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
		    {
		        if(PlayerCache[i][pHouse])
		        {
	      			if(PlayerCache[i][pUID] == GetPlayerVirtualWorld(playerid))
	      			{
	              		new hotel_doorid = GetDoorID(PlayerCache[i][pHouse]);

						crp_SetPlayerPos(playerid, DoorCache[hotel_doorid][dExitX], DoorCache[hotel_doorid][dExitY], DoorCache[hotel_doorid][dExitZ]);
						SetPlayerFacingAngle(playerid, DoorCache[hotel_doorid][dExitA]);

						SetPlayerInterior(playerid, DoorCache[hotel_doorid][dExitInt]);
						SetPlayerVirtualWorld(playerid, DoorCache[hotel_doorid][dExitVW]);

						OnPlayerFreeze(playerid, true, 3);
						return 1;
	      			}
				}
		    }
		}
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Drzwi od tego pokoju s� zamkni�te.");
	    return 1;
	}
	if(!strcmp(type, "koszt", true))
	{
	    new string[256];
		if(doorid == INVALID_DOOR_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
		if(DoorCache[doorid][dOwnerType] != OWNER_GROUP)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
		new group_id = GetGroupID(DoorCache[doorid][dOwner]);
		if(GroupData[group_id][gType] != G_TYPE_HOTEL)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w hotelu.");
		    return 1;
		}
		if(HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_LEADER))
		{
  			format(string, sizeof(string), "Wprowad� kwot�, jak� chcesz pobiera� za wynajem pokoju.\nObecny koszt wynajmu pokoju wynosi $%d.\n\nOp�ata za pok�j pobierana jest raz dziennie, razem z wydaniem wyp�at.", GroupData[group_id][gValue1]);
		    ShowPlayerDialog(playerid, D_ROOM_PRICE, DIALOG_STYLE_INPUT, "Zmie� koszt wynajmu", string, "Zmie�", "Anuluj");
		}
		else
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Koszt wynajmu pokoju wynosi $%d.\nOp�ata za pok�j pobierana jest raz dziennie, razem z wydaniem wyp�at.", GroupData[group_id][gValue1]);
		}
	    return 1;
	}
	return 1;
}

CMD:hotel(playerid, params[])	return cmd_pokoj(playerid, params);
CMD:motel(playerid, params[])	return cmd_pokoj(playerid, params);

// -- Czaty -- //
CMD:c(playerid, params[])
{
	if(PlayerCache[playerid][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz si� odzywa� podczas stanu nieprzytomno�ci.");
	    return 1;
	}
	if(isnull(params))
	{
	   	ShowTipForPlayer(playerid, "/c [Tekst]");
	    return 1;
	}
	new string[256];
	params[0] = chrtoupper(params[0]);

	if(strlen(params) < 78)
	{
		format(string, sizeof(string), "%s szepcze: %s", PlayerName(playerid), params);
		ProxDetector(2.5, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
	else
	{
	    new pos = strfind(params, " ", true, strlen(params) / 2);
		if(pos != -1)
		{
  			new text[64];

  			strmid(text, params, pos + 1, strlen(params));
			strdel(params, pos, strlen(params));

			format(string, sizeof(string), "%s szepcze: %s...", PlayerName(playerid), params);
			ProxDetector(2.5, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

			format(string, sizeof(string), "...%s", text);
			ProxDetector(2.5, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		}
	}
	return 1;
}

CMD:k(playerid, params[])
{
	if(PlayerCache[playerid][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz si� odzywa� podczas stanu nieprzytomno�ci.");
	    return 1;
	}
	if(isnull(params))
	{
	    ShowTipForPlayer(playerid, "/k [Tekst]");
	    return 1;
	}
	new string[256];
	params[0] = chrtoupper(params[0]);

	if(strlen(params) < 78)
	{
		format(string, sizeof(string), "%s krzyczy: %s!!", PlayerName(playerid), params);
		ProxDetector(25.0, playerid, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_FADE1, COLOR_FADE2);
	}
	else
	{
	    new pos = strfind(params, " ", true, strlen(params) / 2);
		if(pos != -1)
		{
  			new text[64];

  			strmid(text, params, pos + 1, strlen(params));
			strdel(params, pos, strlen(params));

			format(string, sizeof(string), "%s krzyczy: %s...", PlayerName(playerid), params);
			ProxDetector(25.0, playerid, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_FADE1, COLOR_FADE2);

			format(string, sizeof(string), "...%s!!", text);
			ProxDetector(25.0, playerid, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_FADE1, COLOR_FADE2);
		}
	}
	
	ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:s(playerid, params[]) 		return 	cmd_k(playerid, params);
CMD:krzycz(playerid, params[]) 	return 	cmd_k(playerid, params);

CMD:l(playerid, params[])
{
	if(PlayerCache[playerid][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz si� odzywa� podczas stanu nieprzytomno�ci.");
	    return 1;
	}
	if(isnull(params))
	{
	    ShowTipForPlayer(playerid, "/l [Tekst]");
	    return 1;
	}
	new string[256];
	params[0] = chrtoupper(params[0]);

	if(strlen(params) < 78)
	{
		format(string, sizeof(string), "%s m�wi: %s", PlayerName(playerid), params);
		ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
	else
	{
	    new pos = strfind(params, " ", true, strlen(params) / 2);
		if(pos != -1)
		{
  			new text[64];

  			strmid(text, params, pos + 1, strlen(params));
			strdel(params, pos, strlen(params));

			format(string, sizeof(string), "%s m�wi: %s...", PlayerName(playerid), params);
			ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

			format(string, sizeof(string), "...%s", text);
			ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		}
	}
	return 1;
}

CMD:b(playerid, params[])
{
	if(PlayerCache[playerid][pBW])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz teraz korzysta� z czatu.");
	    return 1;
	}
	if(PlayerCache[playerid][pBlock] & BLOCK_OOC)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Twoja posta� ma na�o�on� blokad� czatu OOC.");
	    return 1;
	}
	if(isnull(params))
	{
	    ShowTipForPlayer(playerid, "/b [Tekst]");
	    return 1;
	}
	new string[256], get_name[32];
	params[0] = chrtoupper(params[0]);
	
	format(string, sizeof(string), "(( %s ))", params);
	SetPlayerChatBubble(playerid, string, 0xAFAFAF88, 15.0, 10000);
	
	if(PlayerCache[playerid][pItemMask] == INVALID_ITEM_ID)	format(get_name, sizeof(get_name), "[%d] %s", playerid, PlayerName(playerid));
	else													format(get_name, sizeof(get_name), "%s", PlayerName(playerid));

	if(strlen(params) < 78)
	{
		format(string, sizeof(string), "(( %s: %s ))", get_name, params);
		ProxDetector(10.0, playerid, string, COLOR_GREY, COLOR_GREY, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
	else
	{
	    new pos = strfind(params, " ", true, strlen(params) / 2);
		if(pos != -1)
		{
  			new text[64];

  			strmid(text, params, pos + 1, strlen(params));
			strdel(params, pos, strlen(params));

            format(string, sizeof(string), "(( %s: %s...", get_name, params);
			ProxDetector(10.0, playerid, string, COLOR_GREY, COLOR_GREY, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

			format(string, sizeof(string), "...%s ))", text);
			ProxDetector(10.0, playerid, string, COLOR_GREY, COLOR_GREY, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		}
	}
	return 1;
}

CMD:me(playerid, params[])
{
	if(isnull(params))
	{
	    ShowTipForPlayer(playerid, "/me [Akcja]");
	    return 1;
	}
	new string[256];
	params[0] = chrtolower(params[0]);

	if(strlen(params) < 78)
	{
		format(string, sizeof(string), "** %s %s", PlayerName(playerid), params);
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	}
	else
	{
	    new pos = strfind(params, " ", true, strlen(params) / 2);
		if(pos != -1)
		{
  			new text[64];

  			strmid(text, params, pos + 1, strlen(params));
			strdel(params, pos, strlen(params));

			format(string, sizeof(string), "** %s %s...", PlayerName(playerid), params);
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

			format(string, sizeof(string), "...%s", text);
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		}
	}
	return 1;
}

CMD:ja(playerid, params[]) return cmd_me(playerid, params);

CMD:do(playerid, params[])
{
	if(isnull(params))
	{
	    ShowTipForPlayer(playerid, "/do [Sytuacja]");
	    return 1;
	}
	new string[256];
	params[0] = chrtoupper(params[0]);

	if(strlen(params) < 78)
	{
		format(string, sizeof(string), "** %s (( %s ))", params, PlayerName(playerid));
		ProxDetector(10.0, playerid, string, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO);
	}
	else
	{
	    new pos = strfind(params, " ", true, strlen(params) / 2);
		if(pos != -1)
		{
  			new text[64];

  			strmid(text, params, pos + 1, strlen(params));
			strdel(params, pos, strlen(params));

			format(string, sizeof(string), "** %s...", params);
			ProxDetector(10.0, playerid, string, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO);

			format(string, sizeof(string), "...%s (( %s ))", text, PlayerName(playerid));
			ProxDetector(10.0, playerid, string, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO, COLOR_DO);
		}
	}
	return 1;
}

CMD:sprobuj(playerid, params[])
{
	if(isnull(params))
	{
		ShowTipForPlayer(playerid, "/sprobuj [Akcja np. trafi� do kosza]");
	    return 1;
	}
	new string[256],
		loss = random(2);
		
	switch(loss)
	{
		case 0:
		{
  			if(PlayerCache[playerid][pSex])	format(string, sizeof(string), "*** %s zawi�d� pr�buj�c %s", PlayerName(playerid), params);
			else							format(string, sizeof(string), "*** %s zawiod�a pr�buj�c %s", PlayerName(playerid), params);
		}
		case 1:
		{
  			if(PlayerCache[playerid][pSex])	format(string, sizeof(string), "*** %s odni�s� sukces pr�buj�c %s", PlayerName(playerid), params);
			else							format(string, sizeof(string), "*** %s odnios�a sukces pr�buj�c %s", PlayerName(playerid), params);
		}
	}
	
	ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:w(playerid, params[])
{
	new giveplayer_id, text[128], string[256];
	if(sscanf(params, "us[128]", giveplayer_id, text))
	{
	    ShowTipForPlayer(playerid, "/w [ID gracza] [Tekst]");
	    return 1;
	}
	if(giveplayer_id == playerid)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wysy�a� prywatnej wiadomo�ci do siebie.");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
    	return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
 		return 1;
	}
	if((PlayerCache[playerid][pBlock] & BLOCK_OOC) && !(PlayerCache[giveplayer_id][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Twoja posta� ma na�o�on� blokad� czatu OOC.");
	    return 1;
	}
	if(PlayerCache[giveplayer_id][pTogW] && !(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma wy��czone otrzymywanie prywatnych wiadomo�ci.");
	    return 1;
	}
	if(PlayerCache[playerid][pBW] && !PlayerToPlayer(25.0, playerid, giveplayer_id) && !(PlayerCache[giveplayer_id][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podczas stanu nieprzytomno�ci, wiadomo�ci prywatne mo�esz wysy�a� na okre�lon� odleg�o��.");
    	return 1;
	}
	if(PlayerCache[giveplayer_id][pIgnored][playerid])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ignoruje wiadomo�ci przychodz�ce od Ciebie.");
	    return 1;
	}
	new get_player_name[32], get_giveplayer_name[32]; text[0] = chrtoupper(text[0]);
	printf("[priv] %s (UID: %d, GID: %d) � %s (UID: %d, GID: %d): %s", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], PlayerRealName(giveplayer_id), PlayerCache[giveplayer_id][pUID], PlayerCache[giveplayer_id][pGID], text);

	if(PlayerCache[playerid][pItemMask] == INVALID_ITEM_ID)			format(get_player_name, sizeof(get_player_name), "%s [%d]", PlayerName(playerid), playerid);
	else															format(get_player_name, sizeof(get_player_name), "%s", PlayerName(playerid));
	
	if(PlayerCache[giveplayer_id][pItemMask] == INVALID_ITEM_ID)	format(get_giveplayer_name, sizeof(get_giveplayer_name), "%s [%d]", PlayerName(giveplayer_id), giveplayer_id);
	else															format(get_giveplayer_name, sizeof(get_giveplayer_name), "%s", PlayerName(giveplayer_id));

	if(strlen(text) < 78)
	{
	    format(string, sizeof(string), "(( %s: %s ))", get_player_name, text);
	    SendClientMessage(giveplayer_id, COLOR_GOT_PW, string);
	    
	    format(string, sizeof(string), "(( � %s: %s ))", get_giveplayer_name, text);
	    SendClientMessage(playerid, COLOR_SEND_PW, string);
	}
	else
	{
	    new pos = strfind(text, " ", true, strlen(text) / 2);
		if(pos != -1)
		{
  			new text2[64];

  			strmid(text2, text, pos + 1, strlen(text));
			strdel(text, pos, strlen(text));
			
   			format(string, sizeof(string), "(( %s: %s...", get_player_name, text);
		    SendClientMessage(giveplayer_id, COLOR_GOT_PW, string);

		    format(string, sizeof(string), "(( � %s: %s...", get_giveplayer_name, text);
		    SendClientMessage(playerid, COLOR_SEND_PW, string);
		    
   			format(string, sizeof(string), "...%s ))", text2);
   			
		    SendClientMessage(giveplayer_id, COLOR_GOT_PW, string);
		    SendClientMessage(playerid, COLOR_SEND_PW, string);
		}
	}
	Audio_Play(giveplayer_id, AUDIO_MESSAGE);
	
	PlayerCache[giveplayer_id][pLastW] = playerid;
	PlayerCache[playerid][pLastW] = giveplayer_id;
	
	if(PlayerCache[playerid][pTogW])
	{
	    TD_ShowSmallInfo(playerid, 3, "Pamietaj, ze masz ~r~wylaczona ~w~mozliwosc otrzymywania prywatnych ~y~wiadomosci~w~.");
		return 1;
	}

	if(PlayerCache[giveplayer_id][pAFK] > 0)
	{
	    TD_ShowSmallInfo(playerid, 3, "Gracz, do ktorego ~g~wyslano ~w~ta ~y~wiadomosc ~w~jest teraz AFK.");
		return 1;
	}
	return 1;
}

CMD:pm(playerid, params[]) 			return cmd_w(playerid, params);
CMD:wiadomosc(playerid, params[]) 	return cmd_w(playerid, params);

CMD:re(playerid, params[])
{
	if(PlayerCache[playerid][pLastW] == INVALID_PLAYER_ID)
	{
	   	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Z nikim nie pisa�e� przez ostatni czas.");
	    return 1;
	}
	if(isnull(params))
	{
	    ShowTipForPlayer(playerid, "/re [Tekst]");
	    return 1;
	}
	new string[256];

	format(string, sizeof(string), "%d %s", PlayerCache[playerid][pLastW], params);
	cmd_w(playerid, string);
	return 1;
}

CMD:wr(playerid, params[]) return cmd_re(playerid, params);

CMD:tog(playerid, params[])
{
	new type[12], varchar[24];
	if(sscanf(params, "s[12]S()[24]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/tog [w, g]");
	    return 1;
	}
	if(!strcmp(type, "w", true))
	{
	    if(PlayerCache[playerid][pTogW])
	    {
	        PlayerCache[playerid][pTogW] = false;
	        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~y~Otrzymywanie wiadomosci ~g~wlaczone", 3000, 3);
	    }
	    else
	    {
			PlayerCache[playerid][pTogW] = true;
			GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~y~Otrzymywanie wiadomosci ~r~wylaczone", 3000, 3);
	    }
	    return 1;
	}
	if(!strcmp(type, "g", true))
	{
	    new group_slot;
	    if(sscanf(varchar, "d", group_slot))
	    {
	        ShowTipForPlayer(playerid, "/tog g [slot (1-%d)]", MAX_GROUP_SLOTS);
	        return 1;
	    }
	    group_slot -= 1;
		if(group_slot < 0 || group_slot >= MAX_GROUP_SLOTS)
	    {
	        GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
	        return 1;
	    }
		if(!PlayerGroup[playerid][group_slot][gpUID])
		{
			GameTextForPlayer(playerid, "~r~Nieprawidlowy slot grupy.", 3000, 3);
  			return 1;
		}
	    if(PlayerGroup[playerid][group_slot][gpTogG])
	    {
	        PlayerGroup[playerid][group_slot][gpTogG] = false;
	        TD_ShowSmallInfo(playerid, 5, "Czat OOC grupy (slot: %d) zostal ~g~wlaczony~w~.", group_slot + 1);
	    }
	    else
	    {
     		PlayerGroup[playerid][group_slot][gpTogG] = true;
	        TD_ShowSmallInfo(playerid, 5, "Czat OOC grupy (slot: %d) zostal ~r~wylaczony~w~.", group_slot + 1);
	    }
	    return 1;
	}
	return 1;
}

CMD:ignoruj(playerid, params[])
{
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/ignoruj [ID gracza]");
	    return 1;
	}
	if(giveplayer_id == playerid)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz ignorowa� swoich wiadomo�ci.");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
  		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
  		return 1;
	}
	if(PlayerCache[playerid][pIgnored][giveplayer_id])
	{
	    PlayerCache[playerid][pIgnored][giveplayer_id] = false;
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Wiadomo�ci przychodz�ce od gracza %s nie b�d� ju� ignorowane.", PlayerName(giveplayer_id));
	}
	else
	{
	    PlayerCache[playerid][pIgnored][giveplayer_id] = true;
	    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Wiadomo�ci przychodz�ce od gracza %s b�d� od teraz ignorowane.", PlayerName(giveplayer_id));
	}
	return 1;
}

CMD:m(playerid, params[])
{
	if(PlayerCache[playerid][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz skorzysta� teraz z tej komendy.");
	    return 1;
	}
	if(isnull(params))
	{
	    ShowTipForPlayer(playerid, "/m [Tekst]");
	    return 1;
	}
	if(!HavePlayerItemType(playerid, ITEM_MEGAPHONE))
	{
	     ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiedniego przedmiotu w swoim ekwipunku.");
	     return 1;
	}
	new string[256];
	if(!strcmp(params, "#M1", true))
	{
	    if(!IsPlayerInGroupType(playerid, G_TYPE_POLICE))
	    {
	        return 1;
	    }
	    
		new audio_handle;
		foreach(new i : Player)
 		{
			if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
			{
				if(IsPlayerInRangeOfPoint(i, 80.0, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]))
    			{
    				audio_handle = Audio_Play(i, AUDIO_LSPD);
    				
    				Audio_SetFX(i, audio_handle, 4);
				    Audio_Set3DPosition(i, audio_handle, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ], 80.0);
				}
			}
 		}
		format(string, sizeof(string), "%s (megafon): Tutaj LSPD, zjed� na pobocze i zga� silnik!!!", PlayerName(playerid));
		ProxDetector(40.0, playerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
	    return 1;
	}
 	params[0] = chrtoupper(params[0]);

	if(strlen(params) < 78)
	{
		format(string, sizeof(string), "%s (megafon): %s!!!", PlayerName(playerid), params);
		ProxDetector(40.0, playerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
	}
	else
	{
	    new pos = strfind(params, " ", true, strlen(params) / 2);
		if(pos != -1)
		{
  			new text[64];

  			strmid(text, params, pos + 1, strlen(params));
			strdel(params, pos, strlen(params));

			format(string, sizeof(string), "%s (megafon): %s...", PlayerName(playerid), params);
			ProxDetector(40.0, playerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);

			format(string, sizeof(string), "...%s!!!", text);
			ProxDetector(40.0, playerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
		}
	}
	return 1;
}

CMD:i(playerid, params[])
{
	if(PlayerCache[playerid][pAdmin] < A_PERM_MAX)
	{
	   	ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz pisa� na czacie globalnym.");
	    return 1;
	}
	if(isnull(params))
	{
		ShowTipForPlayer(playerid, "/i [Tekst]");
	  	return 1;
	}
	new string[256];
	params[0] = chrtoupper(params[0]);

	if(strlen(params) < 78)
	{
		format(string, sizeof(string), "(( %s: %s ))", PlayerName(playerid), params);
		SendClientMessageToAll(COLOR_WHITE, string);
	}
	else
	{
	    new pos = strfind(params, " ", true, strlen(params) / 2);
		if(pos != -1)
		{
  			new text[64];

  			strmid(text, params, pos + 1, strlen(params));
			strdel(params, pos, strlen(params));

			format(string, sizeof(string), "(( %s: %s... ))", PlayerName(playerid), params);
			SendClientMessageToAll(COLOR_WHITE, string);

			format(string, sizeof(string), "(( ...%s ))", text);
			SendClientMessageToAll(COLOR_WHITE, string);
		}
	}
	return 1;
}

CMD:d(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(!(GroupData[group_id][gFlags] & G_FLAG_DEPARTMENT))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie posiadasz odpowiednich uprawnie� do u�ycia tej komendy.");
	    return 1;
	}
	if(PlayerCache[playerid][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz skorzysta� teraz z tej komendy.");
	    return 1;
	}
	new text[128], string[256];
	if(sscanf(params, "s[128]", text))
	{
	    ShowTipForPlayer(playerid, "/d [Tekst]");
	    return 1;
	}
	text[0] = chrtoupper(text[0]);
	format(string, sizeof(string), "** [%s] %s: %s **", GroupData[group_id][gTag], PlayerName(playerid), text);

	new other_group_id;
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pDutyGroup])
	        {
	            other_group_id = GetPlayerGroupID(i, PlayerCache[i][pDutyGroup]);
	            if((GroupData[other_group_id][gFlags] & G_FLAG_DEPARTMENT))
	       		{
	        		SendClientMessage(i, COLOR_KREM, string);
				}
			}
	    }
	}
	format(string, sizeof(string), "%s m�wi (radio): %s", PlayerName(playerid), text);
	ProxDetector(10.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	return 1;
}

CMD:cb(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby korzysta� z CB radio musisz siedzie� w poje�dzie.");
	    return 1;
	}
	new vehid = GetPlayerVehicleID(playerid);
	if(!(CarInfo[vehid][cAccess] & VEH_ACCESS_RADIO))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "W tym poje�dzie nie ma zamontowanego CB radio.");
	    return 1;
	}
	if(!CarInfo[vehid][cRadioCanal])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie ustawi�e� �adnego kana�u!");
	    return 1;
	}
	if(isnull(params))
	{
	   	ShowTipForPlayer(playerid, "/cb [Tekst]");
	    return 1;
	}
	new string[256], radio_canal = CarInfo[vehid][cRadioCanal];

	params[0] = chrtoupper(params[0]);
	format(string, sizeof(string), "[K:%d] %s: %s", radio_canal, PlayerName(playerid), params);

	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
		    if(IsPlayerInAnyVehicle(i))
		    {
				vehid = GetPlayerVehicleID(i);
				if(CarInfo[vehid][cAccess] & VEH_ACCESS_RADIO)
				{
				    if(CarInfo[vehid][cRadioCanal] == radio_canal)
				    {
				        SendClientMessage(i, COLOR_CB_RADIO, string);
				    }
				}
		    }
		}
	}
	return 1;
}

CMD:report(playerid, params[])
{
	new giveplayer_id, text[128], string[256];
	if(sscanf(params, "us[128]", giveplayer_id, text))
	{
	    ShowTipForPlayer(playerid, "/report [ID gracza] [Tre��]");
	    return 1;
	}
	if(giveplayer_id == playerid)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wys�a� raportu na siebie.");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
  		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
  		return 1;
	}
	if((PlayerCache[playerid][pLastReport]) && PlayerCache[playerid][pLastReport] + 20 >= gettime())
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Zamierzasz wys�a� raport zaraz po poprzednim, odczekaj chwil�.");
	    return 1;
	}
	format(string, sizeof(string), "[Raport] %s [%d]: %s (%s [%d])", PlayerName(playerid), playerid, text, PlayerName(giveplayer_id), giveplayer_id);
	SendClientMessage(playerid, COLOR_RED, string);

	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if((PlayerCache[i][pAdmin] & A_PERM_BASIC) && PlayerCache[i][pDutyAdmin])
	        {
	            SendClientMessage(i, COLOR_LIGHTRED, string);
	        }
	    }
	}
	PlayerCache[playerid][pLastReport] = gettime();
	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Za co mo�esz zosta� ukarany?\n\n1. Za kilkukrotne wysy�anie powtarzaj�cych si� raport�w.\n2. Za pytania odnosz�ce si� do administracji na /raport.\n3. Wyzwiska oraz obraz� w stosunku do administracji.");
	return 1;
}

CMD:raport(playerid, params[])  return cmd_report(playerid, params);

// -- Komendy frakcyjne -- //
CMD:dotacja(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(GroupData[group_id][gType] != G_TYPE_GOV || !HavePlayerGroupPerm(playerid, GroupData[group_id][gUID], G_PERM_LEADER))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
	
  	new group_uid, price;
  	if(sscanf(params, "dd", group_uid, price))
  	{
  	    ShowTipForPlayer(playerid, "/dotacja [UID grupy] [Kwota]");
  	    return 1;
  	}
  	group_id = GetGroupID(group_uid);
  	if(group_id == INVALID_GROUP_ID)
  	{
  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono b��dne UID grupy.");
  	    return 1;
  	}
  	if(price < 0)
  	{
  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
  	    return 1;
  	}
  	new max_dotation = GroupTypeInfo[GroupData[group_id][gType]][gTypeMaxDotation];
  	if(price <= max_dotation)
  	{
		GroupData[group_id][gDotation] = price;
		SaveGroup(group_id);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pomy�lnie ustalono wyoko�� dotacji na pracownika dla grupy.\n\nGrupa: %s (UID: %d)\nAktualna kwota dotacji: $%d", GroupData[group_id][gName], GroupData[group_id][gUID], GroupData[group_id][gDotation]);
  	}
  	else
  	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Dla tego typu grupy maksymalna dotacja mo�e wynie�� $%d.", max_dotation);
  	}
	return 1;
}

CMD:kartoteka(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(GroupData[group_id][gType] != G_TYPE_POLICE && GroupData[group_id][gType] != G_TYPE_FBI)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/kartoteka [ID gracza]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
    	return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
		new vehid = GetPlayerVehicleID(playerid);
		if(CarInfo[vehid][cOwnerType] != OWNER_GROUP || CarInfo[vehid][cOwner] != PlayerCache[playerid][pDutyGroup])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w poje�dzie lub budynku nale��cym do grupy.");
		    return 1;
		}
	}
	else
	{
	    new doorid = GetPlayerDoorID(playerid);
	    if(doorid == INVALID_DOOR_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w poje�dzie lub budynku nale��cym do grupy.");
	        return 1;
	    }
	    if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w poje�dzie lub budynku nale��cym do grupy.");
	        return 1;
	    }
	}
	ShowPlayerDirectoryForPlayer(giveplayer_id, playerid);
	PlayerCache[playerid][pMainTable] = PlayerCache[giveplayer_id][pUID];
	return 1;
}

CMD:przeszukaj(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(!(GroupData[group_id][gFlags] & G_FLAG_SEARCHING))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
	new giveplayer_id, string[128];
	if(sscanf(params, "u", giveplayer_id))
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
	    	ShowTipForPlayer(playerid, "/przeszukaj [ID gracza]");
		}
		else
		{
		    new vehid = GetPlayerVehicleID(playerid);
		    ListVehicleItemsForPlayer(vehid, playerid);
		    
	    	format(string, sizeof(string), "* %s przeszukuje pojazd %s.", PlayerName(playerid), GetVehicleName(CarInfo[vehid][cModel]));
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		}
	    return 1;
	}
	if(giveplayer_id == playerid)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz przeszukiwa� siebie.");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
    	return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
 		return 1;
	}
	if(PlayerCache[playerid][pSearches] != INVALID_PLAYER_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie przeszukujesz ju� jakiego� gracza, odczekaj chwil�.");
	    return 1;
	}
	PlayerCache[playerid][pSearches] = giveplayer_id;
	PlayerCache[playerid][pSearchTime] = 15;

	format(string, sizeof(string), "* %s przeszukuje %s.", PlayerName(playerid), PlayerName(giveplayer_id));
	ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Przeszukiwanie gracza w toku.\nOdczekaj kilka sekund, a� przeszukiwanie dobiegnie ko�ca.");
	return 1;
}

CMD:blokuj(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(GroupData[group_id][gType] != G_TYPE_POLICE)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
  	new vehid = GetClosestVehicle(playerid), string[256];
  	if(vehid == INVALID_VEHICLE_ID)
  	{
  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego pojazdu w pobli�u.");
  	    return 1;
  	}
  	PlayerCache[playerid][pMainTable] = vehid;

  	format(string, sizeof(string), "Wprowad� cen� zdj�cia blokady dla pojazdu %s (SampID: %d, UID: %d).\nW�a�ciciel pojazdu b�dzie musia� zg�osi� si� na komisariat, by zdj�� blokad� za podan� kwot� pieni�dzy.", GetVehicleName(CarInfo[vehid][cModel]), vehid, CarInfo[vehid][cUID]);
  	ShowPlayerDialog(playerid, D_BLOCK_WHEEL, DIALOG_STYLE_INPUT, "Blokada ko�a", string, "Blokuj", "Anuluj");
	return 1;
}

CMD:blokada(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(!(GroupData[group_id][gFlags] & G_FLAG_BLOCADE))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
  	new blockade_type, blockade_id;
  	if(sscanf(params, "dd", blockade_type, blockade_id))
  	{
  	    ShowTipForPlayer(playerid, "/blokada [Typ blokady(1-8)] [ID blokady(1-20)]");
  	    return 1;
  	}
  	if(blockade_type <= 0 || blockade_type > 8)
  	{
  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nieprawid�owy typ blokady.");
  	    return 1;
  	}
  	if(blockade_id <= 0 || blockade_id > 20)
  	{
  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nieprawid�owe ID blokady.");
  	    return 1;
  	}
  	if(blockade_type == 7 && GroupData[group_id][gType] != G_TYPE_POLICE)
  	{
  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Grupa, na kt�rej s�u�bie jeste� nie posiada uprawnie� do rozk�adania tego typu blokad.");
  	    return 1;
  	}
  	if(blockade_type == 8 && GroupData[group_id][gType] != G_TYPE_FIREDEPT)
  	{
  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Grupa, na kt�rej s�u�bie jeste� nie posiada uprawnie� do rozk�adania tego typu blokad.");
  	    return 1;
  	}
  	if(IsPlayerInAnyVehicle(playerid))
  	{
  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz siedzie� w poje�dzie podczas stawiania blokady.");
  	    return 1;
  	}
  	if(IsValidDynamicObject(GroupData[group_id][gExtraArray][blockade_id - 1]))
  	{
  	    DestroyDynamicObject(GroupData[group_id][gExtraArray][blockade_id - 1]);
  	    TD_ShowSmallInfo(playerid, 3, "Blokada zostala ~r~usunieta~w~.");
  	    return 1;
  	}
  	new object_id, Float:PosX, Float:PosY, Float:PosZ, Float:PosA,
  	    virtual_world, interior_id, Float:dist;
  	    
	virtual_world = GetPlayerVirtualWorld(playerid);
	interior_id = GetPlayerInterior(playerid);

  	GetPlayerPos(playerid, PosX, PosY, PosZ);
  	GetPlayerFacingAngle(playerid, PosA);
	
	switch(blockade_type - 1)
	{
	    case 0:
	    {
			dist = 5.0;
		}
		case 1:
		{
			PosA = PosA - 90.0;
			dist = 3.0;
		}
		case 2:
		{
		    PosZ = PosZ - 0.5;
		    dist = 3.0;
		}
		case 3:
		{
			dist = 3.0;
		}
		case 4:
		{
  			PosA = PosA - 180.0;
		    dist = 5.0;
		}
		case 5:
		{
  			PosA = PosA - 180.0;
		    dist = 5.0;
		}
		case 6:
		{
		    PosZ = PosZ - 0.5;
			dist = 5.0;
			
			ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.0, 0, 0, 0, 0, 0, true);
		}
		case 7:
		{
			PosA = PosA - 180.0;
		    dist = 5.0;
		}
	}
	
	GetXYInFrontOfPlayer(playerid, PosX, PosY, dist);
	
	object_id = CreateDynamicObject(BlockadeType[blockade_type - 1], PosX, PosY, PosZ - 0.5, 0.0, 0.0, PosA, virtual_world, interior_id, -1, MAX_DRAW_DISTANCE);
	if(blockade_type == 1)	SetDynamicObjectMaterialText(object_id, 0, GroupData[group_id][gTag], 50, "Arial", 40, 1, -1, 0xFFFFD942, 1);
	
    GroupData[group_id][gExtraArray][blockade_id - 1] = object_id;

	Streamer_Update(playerid);
	TD_ShowSmallInfo(playerid, 3, "Blokada zostala ~y~postawiona~w~.");
	return 1;
}

CMD:zabierz(playerid, params[])
{
	new type[32], varchar[32];
	if(sscanf(params, "s[32]S()[32]", type, varchar))
	{
		ShowTipForPlayer(playerid, "/zabierz [dowod | prawko | przedmiot]");
	    return 1;
	}
	if(!strcmp(type, "przedmiot", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
		    return 1;
		}
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_POLICE && GroupData[group_id][gType] != G_TYPE_ARMY)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
		    return 1;
		}
	    new giveplayer_id, item_uid;
	    if(sscanf(varchar, "ud", giveplayer_id, item_uid))
		{
		    ShowTipForPlayer(playerid, "/zabierz przedmiot [ID gracza] [UID przedmiotu]");
	        return 1;
	    }
 		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zabra� przedmiotu sobie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	 		return 1;
		}
		new itemid = GetItemID(item_uid);
		if(itemid == INVALID_ITEM_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owe UID przedmiotu.");
		    return 1;
		}
		if(ItemCache[itemid][iPlace] != PLACE_PLAYER || ItemCache[itemid][iOwner] != PlayerCache[giveplayer_id][pUID])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owe UID przedmiotu.");
		    return 1;
		}
		if(ItemCache[itemid][iUsed])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zabra� tego przedmiotu, poniewa� jest on w u�ytku.", "Okej", "");
		    return 1;
		}
		ItemCache[itemid][iPlace] = PLACE_PLAYER;
		ItemCache[itemid][iOwner] = PlayerCache[playerid][pUID];
		
		SaveItem(itemid, SAVE_ITEM_OWNER);

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Zabra�e� przedmiot %s (UID: %d) graczowi %s.\nPrzedmiot pojawi� si� w Twoim ekwipunku.", ItemCache[itemid][iName], ItemCache[itemid][iUID], PlayerName(giveplayer_id));
		ShowPlayerInfoDialog(giveplayer_id, D_TYPE_INFO, "Gracz %s zabra� Ci przedmiot %s (UID: %d).", PlayerName(playerid), ItemCache[itemid][iName], ItemCache[itemid][iUID]);
	    return 1;
	}
	if(!strcmp(type, "prawko", true))
	{
		if(!PlayerCache[playerid][pDutyGroup])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
		    return 1;
		}
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
		if(GroupData[group_id][gType] != G_TYPE_POLICE)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
		    return 1;
		}
 		new giveplayer_id;
	    if(sscanf(varchar, "ud", giveplayer_id))
		{
		    ShowTipForPlayer(playerid, "/zabierz prawko [ID gracza]");
	        return 1;
	    }
  		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zabra� przedmiotu sobie.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	 		return 1;
		}
		if(!(PlayerCache[giveplayer_id][pDocuments] & DOC_DRIVER))
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie posiada prawa jazdy.");
		    return 1;
		}
		if(PlayerCache[giveplayer_id][pPDP] < 21)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz musi mie� przyznanych conajmniej 21 pkt karnych.");
		    return 1;
		}
		PlayerCache[giveplayer_id][pDocuments] -= DOC_DRIVER;
		PlayerCache[giveplayer_id][pPDP] = 0;

		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Zabra�e� prawo jazdy gracza %s.", PlayerName(giveplayer_id));
		ShowPlayerInfoDialog(giveplayer_id, D_TYPE_INFO, "Gracz %s zabra� Ci prawo jazdy.", PlayerName(playerid));
	    return 1;
	}
	return 1;
}

CMD:hak(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(GroupData[group_id][gType] != G_TYPE_POLICE)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
  	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
  	{
  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w holowniku.");
  	    return 1;
  	}
	new vehid = GetPlayerVehicleID(playerid);
	if(CarInfo[vehid][cOwnerType] != OWNER_GROUP || CarInfo[vehid][cOwner] != PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Pojazd musi by� przypisany pod grup�.");
	 	return 1;
	}
	if(GetVehicleModel(vehid) != 525)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w holowniku.");
	    return 1;
	}
	new Float:vPosX, Float:vPosY, Float:vPosZ;

	foreach(new carid : Vehicles)
	{
	    if(carid != vehid)
	    {
		    if(CarInfo[carid][cUID])
		    {
			    GetVehiclePos(carid, vPosX, vPosY, vPosZ);
			    if(IsPlayerInRangeOfPoint(playerid, 10.0, vPosX, vPosY, vPosZ))
			    {
			        AttachTrailerToVehicle(carid, vehid);
                    ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pojazd zostal pomy�lnie podczepiony.\nAby go odczepi� wci�nij klawisz \"N\".");
					return 1;
			    }
			}
		}
	}
	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego pojazdu w pobli�u.");
	return 1;
}

CMD:gps(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(GroupData[group_id][gType] != G_TYPE_POLICE)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
  	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
  	{
  	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie jako kierowca, by m�c w��czy� GPS.");
		return 1;
  	}
	new vehid = GetPlayerVehicleID(playerid);
	if(CarInfo[vehid][cOwnerType] != OWNER_GROUP || CarInfo[vehid][cOwner] != PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie nale��cym do grupy.");
	    return 1;
	}
	if(!CarInfo[vehid][cGPS])
	{
		CarInfo[vehid][cGPS] = true;
		TD_ShowSmallInfo(playerid, 3, "Nadajnik ~b~GPS ~w~zostal ~g~uruchomiony~w~.");
	}
	else
	{
	    CarInfo[vehid][cGPS] = false;
   		TD_ShowSmallInfo(playerid, 3, "Nadajnik ~b~GPS ~w~zostal ~r~wylaczony~w~.");
   		
   		for(new icon_id = 0; icon_id < 100; icon_id++) RemovePlayerMapIcon(playerid, icon_id);
	}
	return 1;
}

CMD:areszt(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(!(GroupData[group_id][gFlags] & G_FLAG_ARREST))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
	new giveplayer_id, time;
	if(sscanf(params, "ud", giveplayer_id, time))
	{
	    ShowTipForPlayer(playerid, "/areszt [ID gracza] [Czas (godz.)]");
	    return 1;
	}
	if(giveplayer_id == playerid)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz aresztowa� siebie.");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
 		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
 		return 1;
	}
	if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
		return 1;
	}
	if(PlayerCache[giveplayer_id][pArrest])
	{
	    if(time <= 0)
	    {
	        PlayerCache[giveplayer_id][pArrest] = 0;
	        
			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Gracz %s zosta� zwolniony z aresztu.", PlayerName(giveplayer_id));
			SendClientFormatMessage(giveplayer_id, COLOR_INFO, "%s zwolni� Ci� z aresztu.", PlayerName(playerid));
			return 1;
	    }
	    
	    PlayerCache[giveplayer_id][pArrest] = gettime() + (time * 3600);
	    
	    ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Pomy�lnie zmieniono czas trwania aresztu graczowi %s. Aktualnie %d godzin.", PlayerName(giveplayer_id), time);
	    SendClientFormatMessage(giveplayer_id, COLOR_INFO, "%s zmieni� Ci czas trwania aresztu na %d godzin.", PlayerName(playerid), time);
	}
	else
	{
	    if(time <= 0)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz aresztowa� gracza na czas mniejszy ni� 1 godzina.");
	        return 1;
	    }
	    
	    PlayerCache[giveplayer_id][pArrest] = gettime() + (time * 3600);
	    
		PlayerCache[giveplayer_id][pInteriorID] = GetPlayerInterior(giveplayer_id);
		PlayerCache[giveplayer_id][pVirtualWorld] = GetPlayerVirtualWorld(giveplayer_id);

		GetPlayerPos(giveplayer_id, PlayerCache[giveplayer_id][pPosX], PlayerCache[giveplayer_id][pPosY], PlayerCache[giveplayer_id][pPosZ]);
		OnPlayerSave(giveplayer_id, SAVE_PLAYER_POS);
		
		ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "%s zosta� pomy�lnie aresztowany na czas %d godzin.", PlayerName(giveplayer_id), time);
		SendClientFormatMessage(giveplayer_id, COLOR_INFO, "%s aresztowa� Ci� na czas %d godzin.", PlayerName(playerid), time);
	}
	return 1;
}

CMD:aresztuj(playerid, params[])    return cmd_areszt(playerid, params);

CMD:kogut(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(GroupData[group_id][gType] != G_TYPE_POLICE && GroupData[group_id][gType] != G_TYPE_FBI)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie jako kierowca, by m�c u�y� tej komendy.");
	    return 1;
	}
	new vehid = GetPlayerVehicleID(playerid);
	if(CarInfo[vehid][cOwnerType] != OWNER_GROUP || CarInfo[vehid][cOwner] != PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w poje�dzie nale��cym do grupy.");
	    return 1;
	}
	new count_objects = Streamer_CountVisibleItems(playerid, STREAMER_TYPE_OBJECT), object_id;
	for (new player_object = 0; player_object <= count_objects; player_object++)
	{
	    if(IsValidPlayerObject(playerid, player_object))
	    {
	        object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);
  			if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_ATTACHED_VEHICLE) == vehid)
  			{
  			    DestroyDynamicObject(object_id);
				TD_ShowSmallInfo(playerid, 3, "Syrena ~b~policyjna ~w~zostala ~r~schowana~w~.");
  			    return 1;
  			}
	    }
	}
	
	new Float:PosX, Float:PosY, Float:PosZ;
	GetVehicleModelInfo(CarInfo[vehid][cModel], VEHICLE_MODEL_INFO_FRONTSEAT, PosX, PosY, PosZ);
	
	object_id = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.00, 0.0, -1, -1, -1, MAX_DRAW_DISTANCE);
	AttachDynamicObjectToVehicle(object_id, vehid, PosX, PosY, PosZ + 0.95, -2.0, 0.0, 4.0);
		
	Streamer_Update(playerid);
	TD_ShowSmallInfo(playerid, 3, "Syrena ~b~policyjna ~w~zostala ~g~wyjeta~w~.");
	return 1;
}

CMD:syrena(playerid, params[])  return cmd_kogut(playerid, params);

CMD:reanimuj(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
   		return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(GroupData[group_id][gType] != G_TYPE_MEDICAL && GroupData[group_id][gType] != G_TYPE_FIREDEPT)
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
   		return 1;
	}
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/reanimuj [ID gracza]");
	    return 1;
	}
	if(giveplayer_id == playerid)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz reanimowa� siebie.");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
 		return 1;
	}
	if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie ma BW.");
	    return 1;
	}
	PlayerCache[giveplayer_id][pBW] = 0;

	ApplyAnimation(giveplayer_id, "Attractors", "Stepsit_out", 4.0, 0, 1, 1, 0, 1, true);
	OnPlayerFreeze(giveplayer_id, false, 0);

	ResetPlayerCamera(giveplayer_id);
	crp_SetPlayerHealth(giveplayer_id, 20);
	return 1;
}

CMD:reklama(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(GroupData[group_id][gType] != G_TYPE_NEWS)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
	new desc[128], string[256];
	if(sscanf(params, "s[128]", desc))
	{
 		ShowTipForPlayer(playerid, "/reklama [Tre��]");
   		return 1;
	}
	if(!strcmp(desc, "stop", true))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Transmisja reklamy zosta�a przerwana.");
	    TextDrawSetString(Text:TextDrawNews, "~y~~h~LSN ~w~~>~ Brak sygnalu nadawania.");
		return 1;
	}
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pRadioLive] || PlayerCache[i][pRadioInterview] != INVALID_PLAYER_ID)
	        {
	            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Stacja radiowa jest aktualnie zaj�ta.");
	            return 1;
	        }
	    }
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
		new vehid = GetPlayerVehicleID(playerid);
		if(CarInfo[vehid][cOwnerType] != OWNER_GROUP || CarInfo[vehid][cOwner] != PlayerCache[playerid][pDutyGroup])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w poje�dzie lub budynku nale��cym do grupy.");
	    	return 1;
		}
	}
	else
	{
 		new doorid = GetPlayerDoorID(playerid);
   		if(doorid == INVALID_DOOR_ID)
	    {
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w poje�dzie lub budynku nale��cym do grupy.");
       		return 1;
	    }
	    if(DoorCache[doorid][dOwnerType] != OWNER_GROUP || DoorCache[doorid][dOwner] != PlayerCache[playerid][pDutyGroup])
	    {
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w poje�dzie lub budynku nale��cym do grupy.");
       		return 1;
	    }
	}
	EscapePL(desc);

	format(string, sizeof(string), "~y~~h~LSN ~w~~>~ ~g~~h~Reklama: ~w~%s", FormatTextDrawColors(desc));
	TextDrawSetString(Text:TextDrawNews, string);
	return 1;
}

CMD:live(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(GroupData[group_id][gType] != G_TYPE_NEWS)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
	new type[24], varchar[24];
	if(sscanf(params, "s[24]S()[24]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/live [start | stop]");
	    return 1;
	}
	if(!strcmp(type, "start", true))
	{
	    if(PlayerCache[playerid][pRadioLive])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie prowadzisz ju� jak�� transmisj� na �ywo.");
	        return 1;
	    }
	    
	    foreach(new i : Player)
	    {
	        if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	        {
	            if(PlayerCache[i][pRadioLive] || PlayerCache[i][pRadioInterview] != INVALID_PLAYER_ID)
	            {
	                ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Stacja radiowa jest aktualnie zaj�ta.");
	                return 1;
	            }
	        }
	    }
	    
		PlayerCache[playerid][pRadioLive] = true;

		TextDrawSetString(Text:TextDrawNews, "~y~~h~LSN ~w~~>~ Aktualnie prowadzona jest transmisja na zywo.");
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Transmisja na �ywo zosta�a rozpocz�ta.\nU�ywaj g��wnego czatu w celu nadawania w radiu.");
		return 1;
	}
	if(!strcmp(type, "stop", true))
	{
	    if(!PlayerCache[playerid][pRadioLive])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie prowadzisz �adnej transmisji na �ywo.");
	        return 1;
	    }
	    PlayerCache[playerid][pRadioLive] = false;

	    TextDrawSetString(Text:TextDrawNews, "~y~~h~LSN ~w~~>~ Brak sygnalu nadawania.");
	    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Transmisja na �ywo zosta�a zako�czona pomy�lnie.");
	    return 1;
	}
	return 1;
}

CMD:wywiad(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(GroupData[group_id][gType] != G_TYPE_NEWS)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Grupa, na kt�rej s�u�bie jeste� nie posiada do tego uprawnie�.");
	    return 1;
	}
	new type[32], varchar[32];
	if(sscanf(params, "s[32]S()[32]", type, varchar))
	{
		ShowTipForPlayer(playerid, "/wywiad [start | stop]");
	    return 1;
	}
	if(!strcmp(type, "start", true))
	{
	    if(PlayerCache[playerid][pRadioInterview] != INVALID_PLAYER_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie prowadzisz ju� jaki� wywiad.");
	        return 1;
	    }
	    new giveplayer_id;
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/wywiad start [ID gracza]");
	        return 1;
	    }
		if(giveplayer_id == playerid)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz prowadzi� wywiadu ze sob�.");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	 		return 1;
		}
		
  		foreach(new i : Player)
	    {
	        if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	        {
	            if(PlayerCache[i][pRadioLive] || PlayerCache[i][pRadioInterview] != INVALID_PLAYER_ID)
	            {
	                ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Stacja radiowa jest aktualnie zaj�ta.");
	                return 1;
	            }
	        }
	    }
		
		PlayerCache[playerid][pRadioInterview] = giveplayer_id;
		PlayerCache[giveplayer_id][pRadioInterview] = playerid;

		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Roczpocz��e� wywiad z %s.\nPos�uguj si� g��wnym czatem, aby nadawa� na antenie.", PlayerName(giveplayer_id));
        ShowPlayerInfoDialog(giveplayer_id, D_TYPE_INFO, "%s rozpocz�� z Tob� wywiad.\nPos�uguj si� g��wnym czatem, aby nadawa� na antenie.", PlayerName(playerid));
		return 1;
	}
	if(!strcmp(type, "stop", true))
	{
	    if(PlayerCache[playerid][pRadioInterview] == INVALID_PLAYER_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie nie prowadzisz �adnego wywiadu.");
	        return 1;
	    }
	    new interviewer_id = PlayerCache[playerid][pRadioInterview];

	    PlayerCache[playerid][pRadioInterview] = INVALID_PLAYER_ID;
	    PlayerCache[interviewer_id][pRadioInterview] = INVALID_PLAYER_ID;

	    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Wywiad zosta� zako�czony.");
        ShowPlayerInfoDialog(interviewer_id, D_TYPE_INFO, "Wywiad zosta� zako�czony.");

		TextDrawSetString(Text:TextDrawNews, "~y~~h~LSN ~w~~>~ Brak sygnalu nadawania.");
		return 1;
	}
	return 1;
}

// --- Komendy podstawowe --- //

/*
CMD:bilard(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz sta� obok sto�u bilardowego.");
	    return 1;
	}
	new object_id = GetClosestObjectType(playerid, OBJECT_POOL_TABLE);
	if(object_id == INVALID_OBJECT_ID)
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego sto�u bilardowego w pobli�u.");
   		return 1;
	}
	new Float:ObjectPosX, Float:ObjectPosY, Float:ObjectPosZ,
		Float:ObjectRotX, Float:ObjectRotY, Float:ObjectRotZ;

	GetDynamicObjectPos(object_id, ObjectPosX, ObjectPosY, ObjectPosZ);
	GetDynamicObjectRot(object_id, ObjectRotX, ObjectRotY, ObjectRotZ);

    new Float:Distance, Float:XMultiplier, Float:YMultiplier;
    Distance = floatsqroot(floatpower(ObjectPosX + 0.5 - ObjectPosX, 2) - floatpower(ObjectPosY - ObjectPosY, 2));
    
	ObjectPosX += ((Distance * floatsin(90 + ObjectRotZ, degrees) / floatsin(90, degrees)));
	ObjectPosY += ((Distance * floatsin(ObjectRotZ, degrees) / floatsin(90, degrees)));
    
    // Bia�a bila
    CreateDynamicObject(3003, ObjectPosX, ObjectPosY, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);

	for(new i = 0; i < 14; i++)
	{


	    if(i == 0)
	    {
	        object_id = CreateDynamicObject(2996 + i, ObjectPosX + 0.05, ObjectPosY + 0.05, ObjectPosZ, 0, 0, 0);
	    }

	    if(i > 0 && i < 2)
	    {
	        object_id = CreateDynamicObject(2996 + i, ObjectPosX + 0.05, ObjectPosY + 0.05, ObjectPosZ, 0, 0, 0);
            object_id = CreateDynamicObject(3100 + i, ObjectPosX + 0.05, ObjectPosY - 0.05, ObjectPosZ, 0, 0, 0);
		}

	    if(i > 2 && i < 5)
	    {
	        object_id = CreateDynamicObject(2996 + i, ObjectPosX + 0.05, ObjectPosY + 0.05, ObjectPosZ, 0, 0, 0);
	        object_id = CreateDynamicObject(3100 + i, ObjectPosX + 0.05, ObjectPosY - 0.05, ObjectPosZ, 0, 0, 0);
	    }

	    GetDynamicObjectPos(object_id, ObjectPosX, ObjectPosY, ObjectPosZ);
	}
	
	CreateDynamicObject(3100, ObjectPosX + 0.3, ObjectPosY, ObjectPosZ + 0.95, 0, 0, 0);

	CreateDynamicObject(3101, ObjectPosX + 0.35, ObjectPosY + 0.03, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);
	CreateDynamicObject(3102, ObjectPosX + 0.35, ObjectPosY - 0.03, ObjectPosZ + 0.95, 0, 0, 0);

	CreateDynamicObject(3103, ObjectPosX + 0.40, ObjectPosY + 0.08, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);
	CreateDynamicObject(3104, ObjectPosX + 0.40, ObjectPosY - 0.08, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);
	CreateDynamicObject(3105, ObjectPosX + 0.40, ObjectPosY, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);

	CreateDynamicObject(2995, ObjectPosX + 0.45, ObjectPosY + 0.13, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);
	CreateDynamicObject(2996, ObjectPosX + 0.45, ObjectPosY - 0.13, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);
	CreateDynamicObject(2997, ObjectPosX + 0.45, ObjectPosY + 0.03, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);
	CreateDynamicObject(2998, ObjectPosX + 0.45, ObjectPosY - 0.03, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);

	CreateDynamicObject(2999, ObjectPosX + 0.50, ObjectPosY + 0.18, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);
	CreateDynamicObject(3000, ObjectPosX + 0.50, ObjectPosY - 0.18, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);
	CreateDynamicObject(3001, ObjectPosX + 0.50, ObjectPosY + 0.08, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);
	CreateDynamicObject(3002, ObjectPosX + 0.50, ObjectPosY - 0.08, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);
	CreateDynamicObject(3106, ObjectPosX + 0.50, ObjectPosY, ObjectPosZ + 0.95, 0, 0, ObjectRotZ);
	
	return 1;
}
*/

CMD:wyscig(playerid, params[])
{
	if(!PlayerCache[playerid][pDutyGroup])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	    return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(!(GroupData[group_id][gFlags] & G_FLAG_RACE))
	{
	  	ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie� do u�ycia tej komendy.");
	    return 1;
	}
	new type[32], varchar[32];
	if(sscanf(params, "s[32]S()[32]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/wyscig [stworz, zapros, wypros, zapisz, wczytaj, zakoncz]");
	    return 1;
	}
	if(!strcmp(type, "stworz", true))
	{
 		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie jako kierowca, aby m�c stworzy� wy�cig.");
	        return 1;
	    }
	    if(PlayerCache[playerid][pRaceCreating])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie tworzysz ju� jaki� wy�cig.");
	        return 1;
	    }
	    if(RaceInfo[playerid][rStart])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie uczestniczysz ju� w jakim� wy�cigu.");
	        return 1;
	    }
	    RaceInfo[playerid][rOwner] 				= playerid;
	    RaceInfo[playerid][rPoint]              = 0;
	    
	    PlayerCache[playerid][pRaceCheckpoints] = 0;
   		for (new checkpoint = 0; checkpoint < MAX_RACE_CP; checkpoint++)
		{
		    RaceInfo[playerid][rCPX][checkpoint] = 0.0;
		    RaceInfo[playerid][rCPY][checkpoint] = 0.0;
		    RaceInfo[playerid][rCPZ][checkpoint] = 0.0;
		}
	    
	    PlayerCache[playerid][pRaceCreating] 	= true;
	    TD_ShowSmallInfo(playerid, 0, "Rozpoczales ~r~proces ~w~tworzenia wyscigu, ~g~legenda~w~:~n~~n~~y~~k~~VEHICLE_FIREWEAPON~ ~w~- stawia checkpoint~n~~y~~k~~VEHICLE_FIREWEAPON_ALT~ ~w~- ustala linie mety~n~~n~Checkpointy: ~y~%d/%d", RaceInfo[playerid][rPoint], MAX_RACE_CP);
		return 1;
	}
	if(!strcmp(type, "zapros", true))
	{
	    if(RaceInfo[playerid][rOwner] != playerid)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� liderem wy�cigu, by m�c zaprasza� rywali.");
	        return 1;
	    }
 		if(PlayerCache[playerid][pRaceCreating])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz teraz zaprasza� rywali.");
	        return 1;
	    }
	    new giveplayer_id;
		if(sscanf(varchar, "u", giveplayer_id))
		{
		    ShowTipForPlayer(playerid, "/wyscig zapros [ID gracza]");
		    return 1;
		}
  		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz zaprosi� do wy�cigu siebie.");
       		return 1;
     	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
   			return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(10.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(RaceInfo[giveplayer_id][rOwner] != INVALID_PLAYER_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz uczestniczy ju� w jakim� wy�cigu.");
		    return 1;
		}
		RaceInfo[giveplayer_id][rOwner] = playerid;
		PlayerCache[giveplayer_id][pRaceCheckpoints] = PlayerCache[playerid][pRaceCheckpoints];
		
		for (new checkpoint = 0; checkpoint < MAX_RACE_CP; checkpoint++)
		{
		    RaceInfo[giveplayer_id][rCPX][checkpoint] = 0.0;
		    RaceInfo[giveplayer_id][rCPY][checkpoint] = 0.0;
		    RaceInfo[giveplayer_id][rCPZ][checkpoint] = 0.0;
		    
			if(checkpoint <= PlayerCache[giveplayer_id][pRaceCheckpoints])
			{
   				RaceInfo[giveplayer_id][rCPX][checkpoint] = RaceInfo[playerid][rCPX][checkpoint];
			    RaceInfo[giveplayer_id][rCPY][checkpoint] = RaceInfo[playerid][rCPY][checkpoint];
			    RaceInfo[giveplayer_id][rCPZ][checkpoint] = RaceInfo[playerid][rCPZ][checkpoint];
			}
		}
		
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Gracz %s zosta� zaproszony do wy�cigu.", PlayerName(giveplayer_id));
		SendClientFormatMessage(giveplayer_id, COLOR_INFO, "Gracz %s zaprosi� Ci� do wy�cigu.", PlayerName(playerid));
	    return 1;
	}
	if(!strcmp(type, "wypros", true))
	{
	    if(RaceInfo[playerid][rOwner] != playerid)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� liderem wy�cigu, by m�c zaprasza� rywali.");
	        return 1;
	    }
	    if(RaceInfo[playerid][rStart])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz teraz wyprasza� rywali.");
	        return 1;
	    }
	    new giveplayer_id;
		if(sscanf(varchar, "u", giveplayer_id))
		{
		    ShowTipForPlayer(playerid, "/wyscig wypros [ID gracza]");
		    return 1;
		}
  		if(giveplayer_id == playerid)
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wyprosi� z wy�cigu siebie.");
       		return 1;
     	}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
   			return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(10.0, playerid, giveplayer_id))
		{
  			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	    	return 1;
		}
		if(RaceInfo[giveplayer_id][rOwner] != playerid)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie uczestniczy w Twoim wy�cigu.");
		    return 1;
		}
		RaceInfo[giveplayer_id][rOwner] = INVALID_PLAYER_ID;
		PlayerCache[giveplayer_id][pRaceCheckpoints] = 0;
		
		for (new checkpoint = 0; checkpoint < MAX_RACE_CP; checkpoint++)
		{
		    RaceInfo[giveplayer_id][rCPX][checkpoint] = 0.0;
		    RaceInfo[giveplayer_id][rCPY][checkpoint] = 0.0;
		    RaceInfo[giveplayer_id][rCPZ][checkpoint] = 0.0;
		}
		
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Gracz %s zosta� wyproszony z wy�cigu.", PlayerName(giveplayer_id));
		SendClientFormatMessage(giveplayer_id, COLOR_INFO, "Gracz %s wyprosi� Ci� z wy�cigu.", PlayerName(playerid));
	    return 1;
	}
	if(!strcmp(type, "start", true))
	{
 		if(RaceInfo[playerid][rOwner] != playerid)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie jeste� liderem �adnego wy�cigu.");
	        return 1;
	    }
		if(PlayerCache[playerid][pRaceCreating])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz teraz rozpocz�� wy�cigu.");
		    return 1;
		}
		if(RaceInfo[playerid][rStart])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz teraz rozpocz�� wy�cigu.");
		    return 1;
		}
		
		new racer_count;
		foreach(new i : Player)
		{
		    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
		    {
		        if(RaceInfo[i][rOwner] != INVALID_PLAYER_ID && RaceInfo[i][rOwner] == playerid)
		        {
		            racer_count ++;
		        
		            GameTextForPlayer(i, "~w~Wyscig ~g~rozpoczety!", 5000, 3);
		        
		            RaceInfo[i][rPoint] = 0;
		            RaceInfo[i][rStart] = gettime();
		            
		            SetPlayerRaceCheckpoint(i, 0, RaceInfo[i][rCPX][0], RaceInfo[i][rCPY][0], RaceInfo[i][rCPZ][0], RaceInfo[i][rCPX][1], RaceInfo[i][rCPY][1], RaceInfo[i][rCPZ][1], 10.0);
					TD_ShowSmallInfo(i, 0, "Wyscig ~y~trwa ~w~wjezdzaj w ~r~czerwone punkty~w~.~n~Nie opuszczaj swojego pojazdu.~n~~n~Checkpoint: ~y~%d/%d~n~~w~Twoj czas: ~p~~h~00:00", RaceInfo[i][rPoint], PlayerCache[i][pRaceCheckpoints]);
				}
		    }
		}
	    return 1;
	}
	if(!strcmp(type, "zapisz", true))
	{
		if(RaceInfo[playerid][rOwner] != playerid)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie jeste� liderem �adnego wy�cigu.");
	        return 1;
	    }
		if(PlayerCache[playerid][pRaceCreating])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz teraz zapisa� wy�cigu.");
		    return 1;
		}
		if(RaceInfo[playerid][rStart])
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz teraz zapisa� wy�cigu.");
		    return 1;
		}
		if(RaceInfo[playerid][rPoint] < 10)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Zapisa� mo�esz tylko wy�cigi maj�ce wi�cej ni� 10 checkpoint�w.");
		    return 1;
		}
  		if(!IsPlayerPremium(playerid))
    	{
     		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ta opcja jest dost�pna tylko dla graczy posiadaj�cych aktywne konto premium.");
     		return 1;
	    }
		new string[256];
		
		format(string, sizeof(string), "Wprowad� poni�ej nazw� dla tego wy�cigu.\nNazwa nie mo�e przekracza� 64 znak�w.\n\nPr�bujesz zapisa� wy�cig z %d checkpointami.", RaceInfo[playerid][rPoint]);
		ShowPlayerDialog(playerid, D_RACE_SAVE, DIALOG_STYLE_INPUT, "Zapisz wy�cig", string, "Zapisz", "Anuluj");
	    return 1;
	}
	if(!strcmp(type, "wczytaj", true))
	{
 		if(PlayerCache[playerid][pRaceCreating])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie tworzysz ju� jaki� wy�cig.");
	        return 1;
	    }
	    if(RaceInfo[playerid][rStart])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie uczestniczysz ju� w jakim� wy�cigu.");
	        return 1;
	    }
	    new data[128], race_list[512],
	        race_uid, race_title[64];
	        
	    mysql_query_format("SELECT `race_uid`, `race_title` FROM `crp_races` WHERE race_owner = '%d'", GroupData[group_id][gUID]);
	    
	    mysql_store_result();
	    while(mysql_fetch_row_format(data, "|"))
	    {
	        sscanf(data, "p<|>ds[64]", race_uid, race_title);
			format(race_list, sizeof(race_list), "%s\n%d\t\t%s", race_list, race_uid, race_title);
	    }
	    mysql_free_result();
	    
	    if(strlen(race_list) > 0)
	    {
	    	ShowPlayerDialog(playerid, D_RACE_SELECT, DIALOG_STYLE_LIST, "Lista wy�cig�w grupy", race_list, "Wybierz", "Anuluj");
		}
		else
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie ma �adnych wy�cig�w przypisanych pod grup�.");
		}
	    return 1;
	}
	if(!strcmp(type, "zakoncz", true))
	{
	    if(RaceInfo[playerid][rOwner] == INVALID_PLAYER_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie bierzesz udzia�u w �adnym wy�cigu.");
	        return 1;
	    }
	    DisablePlayerRaceCheckpoint(playerid);
	    
		RaceInfo[playerid][rOwner]				= INVALID_PLAYER_ID;
		RaceInfo[playerid][rStart]				= 0;

		RaceInfo[playerid][rPoint]				= 0;
		RaceInfo[playerid][rTime]				= 0;

		RaceInfo[playerid][rPosition]			= 0;
		
		PlayerCache[playerid][pRaceCreating]	= false;
		PlayerCache[playerid][pRaceCheckpoints]	= 0;
		
		TD_ShowSmallInfo(playerid, 10, "Przestales ~r~brac udzial ~w~w wyscigu.");
	    return 1;
	}
	return 1;
}

CMD:race(playerid, params[])    return cmd_wyscig(playerid, params);

CMD:taguj(playerid, params[])
{
	if(PlayerCache[playerid][pTaggingObject] != INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aktualnie malujesz ju� jaki� tag.");
	    return 1;
	}
	if(!PlayerCache[playerid][pDutyGroup])
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz by� na s�u�bie grupy gangu, �eby m�c namalowa� tag.");
   		return 1;
	}
	new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]);
	if(!(GroupData[group_id][gFlags] & G_FLAG_TAG))
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz odpowiednich uprawnie� do tagowania.");
   		return 1;
	}
	if(PlayerCache[playerid][pItemWeapon] == INVALID_ITEM_ID)
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz mie� spray w u�yciu.");
   		return 1;
	}
	new itemid = PlayerCache[playerid][pItemWeapon];
	if(ItemCache[itemid][iType] != ITEM_WEAPON || ItemCache[itemid][iValue1] != 41)
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz mie� spray w u�yciu.");
 		return 1;
	}
	new object_id = GetClosestObjectType(playerid, OBJECT_TAG);
	if(object_id == INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� przy znaczniku, na kt�rym mo�esz namalowa� tag.");
	    return 1;
	}
	PlayerCache[playerid][pTaggingObject] 	= object_id;
	PlayerCache[playerid][pTaggingTime]     = 750;
	
	PlayerCache[playerid][pMainTable]       = group_id;
	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Mo�esz zacz�� rzutowa� TAG.\nU�yj spraya i zacznij psika� nim na znacznik.");
	return 1;
}

CMD:kosz(playerid, params[])
{
	if(PlayerCache[playerid][pBasketObject] != INVALID_OBJECT_ID)
	{
	    DestroyDynamicObject(PlayerCache[playerid][pBasketBall]);
	    
	    PlayerCache[playerid][pBasketObject] 	= INVALID_OBJECT_ID;
	    PlayerCache[playerid][pBasketBall]      = INVALID_OBJECT_ID;
	    
		TD_ShowSmallInfo(playerid, 3, "Gra w kosza zostala ~r~zakonczona~w~.");
	}
	else
	{
		new object_id = GetClosestObjectType(playerid, OBJECT_BASKET);
		if(object_id == INVALID_OBJECT_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono u�ywalnego obiektu kosza w pobli�u.");
		    return 1;
		}
		foreach(new i : Player)
		{
		    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
		    {
		        if(PlayerCache[i][pBasketObject] == object_id)
		        {
		            ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Kto� aktualnie rzuca do tego kosza.");
		            return 1;
		        }
		    }
		}
	    PlayerCache[playerid][pBasketObject] = object_id;
		PlayerCache[playerid][pBasketBall] = CreateDynamicObject(2114, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, MAX_DRAW_DISTANCE);
	    
	    TD_ShowSmallInfo(playerid, 0, "Rozpoczales gre w ~y~kosza~w~.~n~Uzyj klawisza ~g~PPM~w~, by ustalic pozycje rzutu.");
	}
	return 1;
}

CMD:admins(playerid, params[])
{
	new list_admins[1024];
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pDutyAdmin])
	        {
	            if(PlayerCache[i][pAdmin] >= A_PERM_MAX)
	            {
	                format(list_admins, sizeof(list_admins), "%s\n%d\t---\t{FF0000}%s{FFFFFF}", list_admins, i, PlayerName(i));
	            }
	            else
	            {
	            	format(list_admins, sizeof(list_admins), "%s\n%d\t---\t{800080}%s{FFFFFF}", list_admins, i, PlayerName(i));
				}
	        }
	    }
	}
	if(strlen(list_admins))
	{
	    ShowPlayerDialog(playerid, D_PERMS, DIALOG_STYLE_LIST, "Administratorzy on-line:", list_admins, "Uprawnienia", "Zamknij");
	}
	else
	{
	    TD_ShowSmallInfo(playerid, 3, "Nie ma ~r~zadnych ~w~administratorow online.");
	}
	return 1;
}

CMD:a(playerid, params[])   return cmd_admins(playerid, params);

CMD:pokaz(playerid, params[])
{
	new type[32], varchar[32];
	if(sscanf(params, "s[32]S()[32]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/pokaz [dowod, prawko, metryczke, poczytalnosc, id, cennik]");
	    return 1;
	}
	if(!strcmp(type, "dowod", true))
	{
		if(!(PlayerCache[playerid][pDocuments] & DOC_PROOF))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz tego dokumentu.");
	        return 1;
	    }
	    new giveplayer_id, string[256];
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/pokaz dowod [ID gracza]");
	        return 1;
	    }
    	if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	 		return 1;
		}
		format(string, sizeof(string), "Imi�, nazwisko:\t%s\nRok urodzenia:\t%d", PlayerRealName(playerid), PlayerCache[playerid][pBirth]);
		ShowPlayerDialog(giveplayer_id, D_NONE, DIALOG_STYLE_MSGBOX, "** Dow�d osobisty **", string, "OK", "");

		format(string, sizeof(string), "* %s pokaza� dow�d osobisty %s.", PlayerName(playerid), PlayerName(giveplayer_id));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	    return 1;
	}
	if(!strcmp(type, "prawko", true))
	{
		if(!(PlayerCache[playerid][pDocuments] & DOC_DRIVER))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz tego dokumentu.");
	        return 1;
	    }
	    new giveplayer_id, string[256];
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/pokaz prawko [ID gracza]");
	        return 1;
	    }
    	if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	 		return 1;
		}
		format(string, sizeof(string), "Imi�, nazwisko:\t%s\nRok urodzenia:\t%d", PlayerRealName(playerid), PlayerCache[playerid][pBirth]);
		ShowPlayerDialog(giveplayer_id, D_NONE, DIALOG_STYLE_MSGBOX, "** Prawo jazdy **", string, "OK", "");

		format(string, sizeof(string), "* %s pokaza� prawo jazdy %s.", PlayerName(playerid), PlayerName(giveplayer_id));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	    return 1;
	}
	if(!strcmp(type, "metryczke", true))
	{
		if(!(PlayerCache[playerid][pDocuments] & DOC_SEND))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz tego dokumentu.");
	        return 1;
	    }
	    new giveplayer_id, string[256];
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/pokaz metryczke [ID gracza]");
	        return 1;
	    }
    	if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	 		return 1;
		}
		format(string, sizeof(string), "Imi�, nazwisko:\t%s\nRok urodzenia:\t%d\n\nStan zdrowia:\tNienaganny", PlayerRealName(playerid), PlayerCache[playerid][pBirth]);
		ShowPlayerDialog(giveplayer_id, D_NONE, DIALOG_STYLE_MSGBOX, "** Metryczka zdrowia **", string, "OK", "");

		format(string, sizeof(string), "* %s pokaza� metryczk� zdrowia %s.", PlayerName(playerid), PlayerName(giveplayer_id));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	    return 1;
	}
	if(!strcmp(type, "poczytalnosc", true))
	{
		if(!(PlayerCache[playerid][pDocuments] & DOC_SANITY))
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz tego dokumentu.");
	        return 1;
	    }
	    new giveplayer_id, string[256];
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/pokaz poczytalnosc [ID gracza]");
	        return 1;
	    }
    	if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	 		return 1;
		}
		format(string, sizeof(string), "Imi�, nazwisko:\t%s\nRok urodzenia:\t%d", PlayerRealName(playerid), PlayerCache[playerid][pBirth]);
		ShowPlayerDialog(giveplayer_id, D_NONE, DIALOG_STYLE_MSGBOX, "** Za�wiadczenie o poczytalno�ci **", string, "OK", "");

		format(string, sizeof(string), "* %s pokaza� za�wiadczenie o poczytalno�ci %s.", PlayerName(playerid), PlayerName(giveplayer_id));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	    return 1;
	}
	if(!strcmp(type, "id", true))
	{
	    if(!PlayerCache[playerid][pDutyGroup])
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Aby skorzysta� z tej komendy, musisz by� na s�u�bie grupy.");
	        return 1;
	    }
	    new giveplayer_id, title[64], string[256];
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/pokaz id [ID gracza]");
	        return 1;
	    }
    	if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	 		return 1;
		}
		new group_id = GetPlayerGroupID(playerid, PlayerCache[playerid][pDutyGroup]), group_slot = GetPlayerGroupSlot(playerid, GroupData[group_id][gUID]);
		format(title, sizeof(title), "** %s **", GroupData[group_id][gName]);

		format(string, sizeof(string), "Imi�, nazwisko:\t%s\nRok urodzenia:\t%d\nTytu�:\t\t%s", PlayerRealName(playerid), PlayerCache[playerid][pBirth], PlayerGroup[playerid][group_slot][gpTitle]);
		ShowPlayerDialog(giveplayer_id, D_NONE, DIALOG_STYLE_MSGBOX, title, string, "OK", "");

		format(string, sizeof(string), "* %s pokaza� identyfikator %s.", PlayerName(playerid), PlayerName(giveplayer_id));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		return 1;
	}
	if(!strcmp(type, "cennik", true))
	{
	    new giveplayer_id;
	    if(sscanf(varchar, "u", giveplayer_id))
	    {
	        ShowTipForPlayer(playerid, "/pokaz cennik [ID gracza]");
	        return 1;
	    }
    	if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
	    	return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
		{
	 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
	 		return 1;
		}
		new doorid = GetPlayerDoorID(playerid);
		if(doorid == INVALID_DOOR_ID)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w budynku firmy, aby m�c pokaza� cennik.");
		    return 1;
		}
		if(DoorCache[doorid][dOwnerType] == OWNER_GROUP)
		{
		    if(!HavePlayerGroupPerm(playerid, DoorCache[doorid][dOwner], G_PERM_OFFER))
		    {
		        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz pokaza� cennika.");
		        return 1;
		    }
		}
		new group_id = GetGroupID(DoorCache[doorid][dOwner]), string[128];
		if(GroupData[group_id][gType] == G_TYPE_CARDEALER)
		{
			new data[64], cat_list[256],
			    category_uid, category_name[24];
			    
			mysql_query(connHandle, "SELECT * FROM `"SQL_PREF"salon_category`");
			
			mysql_store_result();
			while(mysql_fetch_row_format(data, "|"))
			{
			    sscanf(data, "p<|>ds[24]", category_uid, category_name);
			    format(cat_list, sizeof(cat_list), "%s\n%d. %s", cat_list, category_uid, category_name);
			}
			mysql_free_result();
			
			if(strlen(cat_list))
			{
			    ShowPlayerDialog(giveplayer_id, D_SALON_CATEGORY, DIALOG_STYLE_LIST, "Wybierz kategori�:", cat_list, "Wybierz", "Anuluj");
			    
   				format(string, sizeof(string), "* %s pokaza� cennik %s.", PlayerName(playerid), PlayerName(giveplayer_id));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			}
			else
			{
			    TD_ShowSmallInfo(playerid, 3, "Nie znaleziono ~r~zadnych ~w~pojazdow w salonie.");
			}
		}
		else
		{
			ListGroupProductsForPlayer(group_id, giveplayer_id, PRODUCT_LIST_PRICE);
			
			format(string, sizeof(string), "* %s pokaza� cennik %s.", PlayerName(playerid), PlayerName(giveplayer_id));
			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		}
  		return 1;
	}
	return 1;
}

CMD:pay(playerid, params[])
{
	new giveplayer_id, price, string[128];
	if(sscanf(params, "ud", giveplayer_id, price))
	{
	    ShowTipForPlayer(playerid, "/pay [ID gracza] [Kwota]");
	    return 1;
	}
	if(PlayerCache[playerid][pHours] < 5)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz mie� przegrane conajmniej 5h, by m�c u�y� tej komendy.");
	    return 1;
	}
	if(giveplayer_id == playerid)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz poda� pieniedzy sobie.");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
  		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
  		return 1;
	}
	if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
		return 1;
	}
	if(PlayerCache[giveplayer_id][pHours] < 5)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz poda� pieni�dzy temu graczu, dop�ki nie przegra 5h.");
	    return 1;
	}
	if(price <= 0)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�ow� kwot�.");
	    return 1;
	}
	if(PlayerCache[playerid][pCash] < price)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz takiej ilo�ci got�wki.");
	    return 1;
	}
	crp_GivePlayerMoney(playerid, -price);
	crp_GivePlayerMoney(giveplayer_id, price);

	OnPlayerSave(playerid, SAVE_PLAYER_BASIC);
	OnPlayerSave(giveplayer_id, SAVE_PLAYER_BASIC);

	ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0, true);

	format(string, sizeof(string), "* %s podaje troch� got�wki %s.", PlayerName(playerid), PlayerName(giveplayer_id));
	ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

	SendClientFormatMessage(playerid, COLOR_LIGHTBLUE, "Poda�e� $%d dla gracza %s.", price, PlayerName(giveplayer_id));
	SendClientFormatMessage(giveplayer_id, COLOR_LIGHTBLUE, "Otrzyma�e� $%d od gracza %s.", price, PlayerName(playerid));
	
	printf("[cash] %s (UID: %d, GID: %d) poda� $%d dla %s (UID: %d, GID: %d).", PlayerRealName(playerid), PlayerCache[playerid][pUID], PlayerCache[playerid][pGID], price, PlayerRealName(giveplayer_id), PlayerCache[giveplayer_id][pUID], PlayerCache[giveplayer_id][pGID]);
	return 1;
}

CMD:plac(playerid, params[]) return cmd_pay(playerid, params);

CMD:getvw(playerid, params[])
{
	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "VirtualWorld w kt�rym si� obecnie znajdujesz to %d.", GetPlayerVirtualWorld(playerid));
	return 1;
}

CMD:time(playerid, params[])
{
	if(PlayerCache[playerid][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz tego zrobi� b�d�c nieprzytomnym.");
	    return 1;
	}
	if(!HavePlayerItemType(playerid, ITEM_WATCH))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz zegarka w swoim ekwipunku.");
	    return 1;
	}
	new hour, minute, second, string[128];
	gettime(hour, minute, second);

	format(string, sizeof(string), "~w~Godzina: ~p~%02d:%02d:%02d", hour, minute, second);
	GameTextForPlayer(playerid, string, 5000, 1);

	format(string, sizeof(string), "* %s spogl�da na zegarek.", PlayerName(playerid));
	ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

	ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:czas(playerid, params[]) 	return cmd_time(playerid, params);
CMD:zegarek(playerid, params[]) return cmd_time(playerid, params);

CMD:kostka(playerid, params[])
{
	if(PlayerCache[playerid][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz tego zrobi� b�d�c nieprzytomnym.");
	    return 1;
	}
	if(!HavePlayerItemType(playerid, ITEM_CUBE))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie posiadasz kostki do gry w swoim ekwipunku.");
	    return 1;
	}
	new rand = 1 + random(6), string[128];

	format(string, sizeof(string), "* %s wyrzuci� %d oczek na 6.", PlayerName(playerid), rand);
	ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:wepchnij(playerid, params[])
{
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/wepchnij [ID gracza]");
	    return 1;
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie jako kierowca.");
	    return 1;
	}
	if(giveplayer_id == playerid)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wepchn�� siebie.");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
    	return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	if(!PlayerToPlayer(5.0, playerid, giveplayer_id))
	{
 		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID znajduje si� zbyt daleko od Ciebie.");
 		return 1;
	}
	if(!PlayerCache[giveplayer_id][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz, kt�rego chcesz wepchn�� musi by� nieprzytomny.");
	    return 1;
	}
 	new vehid = GetPlayerVehicleID(playerid),
		seatid = GetFreeVehicleSeat(vehid);

	if(seatid != INVALID_VEHICLE_ID)
 	{
  		PlayerCache[giveplayer_id][pLastVeh] = vehid;

		PutPlayerInVehicle(giveplayer_id, vehid, seatid);
		OnPlayerFreeze(giveplayer_id, true, 0);
  	}
   	else
   	{
    	TD_ShowSmallInfo(playerid, 3, "Brak ~r~wolnego miejsca ~w~w pojezdzie.");
   	}
	return 1;
}

CMD:wyrzuc(playerid, params[])
{
	new giveplayer_id, string[128];
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/wyrzuc [ID gracza]");
	    return 1;
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz siedzie� w poje�dzie jako kierowca.");
		return 1;
	}
	if(giveplayer_id == playerid)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz wyrzuci� siebie.");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
  		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
  		return 1;
	}
	if(!IsPlayerInAnyVehicle(giveplayer_id))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz musi siedzie� w poje�dzie.");
		return 1;
	}
	if(GetPlayerVehicleID(playerid) != GetPlayerVehicleID(giveplayer_id))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz musi siedzie� w tym samym poje�dzie.");
	    return 1;
	}
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~w~Gracz ~p~%s ~w~wyrzuca Cie z pojazdu", PlayerName(playerid));
	GameTextForPlayer(giveplayer_id, string, 5000, 3);

	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~w~Wyrzucasz gracza ~p~%s ~w~z pojazdu", PlayerName(giveplayer_id));
	GameTextForPlayer(playerid, string, 5000, 3);

	RemovePlayerFromVehicle(giveplayer_id);
	return 1;
}

CMD:zapukaj(playerid, params[])
{
	new string[128];
	foreach(new doorid : Door)
	{
 		if(DoorCache[doorid][dUID])
   		{
	    	if(IsPlayerInRangeOfPoint(playerid, 2.0, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ]) || IsPlayerInRangeOfPoint(playerid, 2.0, DoorCache[doorid][dExitX], DoorCache[doorid][dExitY], DoorCache[doorid][dExitZ]) && GetPlayerVirtualWorld(playerid) == DoorCache[doorid][dExitVW])
		    {
				foreach(new i : Player)
				{
				    if(i != playerid)
				    {
					    if(GetPlayerDoorID(i) == doorid)
					    {
							SendClientMessage(i, COLOR_DO, "** S�ycha� d�wi�k pukania dobiegaj�cy od drzwi wej�ciowych. **");
					    }
					}
				}
				ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, true);

				format(string, sizeof(string), "* %s puka do drzwi.", PlayerName(playerid));
    			ProxDetector(10.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		        break;
			}
		}
	}
	return 1;
}

CMD:silownia(playerid, params[])
{
	if(PlayerCache[playerid][pGymObject] != INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Obecnie korzystasz ju� z jakiego� obiektu sportowego.");
	    return 1;
	}
	if(!PlayerCache[playerid][pGymTime])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Zanim zaczniesz trening, musisz u�y� karnetu.");
	    return 1;
	}
	new type[12];
	if(sscanf(params, "s[12]", type))
	{
	    ShowTipForPlayer(playerid, "/silownia [laweczka, hantle]");
	    return 1;
	}
	if(!strcmp(type, "laweczka", true))
	{
	    new object_id = GetClosestObjectType(playerid, OBJECT_BENCH);
	    if(object_id == INVALID_OBJECT_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �aweczki w pobli�u.");
	        return 1;
	    }
	    
	    foreach(new i : Player)
	    {
	        if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	        {
				if(PlayerCache[i][pGymObject] == object_id)
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Kto� aktualnie korzysta z tego obiektu sportowego.");
				    return 1;
				}
	        }
	    }
	    new Float:ObjPosX, Float:ObjPosY, Float:ObjPosZ,
	        Float:ObjRotX, Float:ObjRotY, Float:ObjRotZ;
	        
		GetDynamicObjectPos(object_id, ObjPosX, ObjPosY, ObjPosZ);
		GetDynamicObjectRot(object_id, ObjRotX, ObjRotY, ObjRotZ);
		
		GetXYInFrontOfObject(object_id, ObjPosX, ObjPosY, 1.0);
	    
	    SetPlayerPos(playerid, ObjPosX, ObjPosY, ObjPosZ + 1.0);
	    SetPlayerFacingAngle(playerid, ObjRotZ);
	    
	    PlayerCache[playerid][pGymObject] = object_id;

	   	ApplyAnimation(playerid, "BENCHPRESS", "gym_bp_down", 4.0, 0, 0, 0, 1, 0, true);
	    SetPlayerAttachedObject(playerid, SLOT_TRAIN, 2913, 6, 0.0, 0.0, -0.2);

        ShowPlayerInfoDialog(playerid, D_TYPE_HELP, "Rozpocz��e� trening na �aweczce wyciskanej.\n\nWci�nij i przytrzymaj klawisz sprintu, aby wykona� pe�ne powt�rzenie,\nje�eli zobaczysz, �e wycisn��e� sztang� maksymalnie, upu�� klawisz.\n\nPowtarzaj opisan� czynno��, by zdoby� wi�ksz� ilo�� punkt�w si�y.\nAby zako�czy� trening wci�nij ENTER.");
		TD_ShowSmallInfo(playerid, 0, "Powtorzenia: ~b~~h~%d~n~~n~Mozesz sprobowac tez ~r~treningu ~w~po uzyciu ~y~odzywek~w~, ktore zakupisz w silowni.", PlayerCache[playerid][pGymRepeat]);
	    return 1;
	}
	
	if(!strcmp(type, "hantle", true))
	{
 		new object_id = GetClosestObjectType(playerid, OBJECT_BARBELL);
	    if(object_id == INVALID_OBJECT_ID)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �aweczki w pobli�u.");
	        return 1;
	    }

	    foreach(new i : Player)
	    {
	        if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	        {
				if(PlayerCache[i][pGymObject] == object_id)
				{
				    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Kto� aktualnie korzysta z tego obiektu sportowego.");
				    return 1;
				}
	        }
	    }
	    new Float:ObjPosX, Float:ObjPosY, Float:ObjPosZ,
	        Float:ObjRotX, Float:ObjRotY, Float:ObjRotZ;

		GetDynamicObjectPos(object_id, ObjPosX, ObjPosY, ObjPosZ);
		GetDynamicObjectRot(object_id, ObjRotX, ObjRotY, ObjRotZ);

		GetXYInFrontOfObject(object_id, ObjPosX, ObjPosY, 1.0);

	    SetPlayerPos(playerid, ObjPosX, ObjPosY, ObjPosZ + 1.0);
	    SetPlayerFacingAngle(playerid, ObjRotZ);
	    
	    PlayerCache[playerid][pGymObject] = object_id;

	   	ApplyAnimation(playerid, "FREEWEIGHTS", "gym_free_down", 4.0, 0, 0, 0, 1, 0, true);
	    SetPlayerAttachedObject(playerid, SLOT_TRAIN, 2915, 6, 0.0, 0.0, -0.45, 0.0, 90.0, 0.0);
	    
	    ShowPlayerInfoDialog(playerid, D_TYPE_HELP, "Rozpocz��e� trening za pomoc� hantli.\n\nWci�nij i przytrzymaj klawisz sprintu, aby wykona� pe�ne powt�rzenie,\nje�eli zobaczysz, �e wycisn��e� hantle maksymalnie, upu�� klawisz.\n\nPowtarzaj opisan� czynno��, by zdoby� wi�ksz� ilo�� punkt�w si�y.\nAby zako�czy� trening wci�nij ENTER.");
	    TD_ShowSmallInfo(playerid, 0, "Powtorzenia: ~b~~h~%d~n~~n~Mozesz sprobowac tez ~r~treningu ~w~po uzyciu ~y~odzywek~w~, ktore zakupisz w silowni.", PlayerCache[playerid][pGymRepeat]);
		return 1;
	}
	return 1;
}

CMD:trenuj(playerid, params[])  return cmd_silownia(playerid, params);

CMD:bus(playerid, params[])
{
	if(PlayerCache[playerid][pBW] || PlayerCache[playerid][pBusRide] || PlayerCache[playerid][pBusStart] != INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz teraz u�y� tej komendy.");
	    return 1;
	}
	new object_id = GetClosestObjectType(playerid, OBJECT_BUSSTOP);
	if(object_id == INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� na przystanku autobusowym.");
	    return 1;
	}
	new player_group,
	    taxi_workers;
	    
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pDutyGroup])
	        {
				player_group = GetPlayerGroupID(i, PlayerCache[i][pDutyGroup]);
				if(GroupData[player_group][gType] == G_TYPE_TAXI)
				{
				    taxi_workers ++;
				}
	        }
	    }
	}
	
	if(taxi_workers >= 3)
	{
	    if(PlayerCache[playerid][pHours] > 5)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Na s�u�bie taxi jest wi�cej ni� 3 pracownik�w!\nSkorzystaj z taks�wki (/tel %d), by dotrze� w docelowe miejsce.", NUMBER_TAXI);
	        return 1;
	    }
	}
	
	new bus_object_uid;
	if(sscanf(params, "d", bus_object_uid))
	{
		new Float:ObjPosX, Float:ObjPosY, Float:ObjPosZ;
		GetDynamicObjectPos(object_id, ObjPosX, ObjPosY, ObjPosZ);

		SetPlayerCameraPos(playerid, ObjPosX, ObjPosY, ObjPosZ + 60.0);
	    SetPlayerCameraLookAt(playerid, ObjPosX, ObjPosY + 2, ObjPosZ, CAMERA_MOVE);

		PlayerCache[playerid][pBusPosition][0] = ObjPosX;
		PlayerCache[playerid][pBusPosition][1] = ObjPosY;
		PlayerCache[playerid][pBusPosition][2] = ObjPosZ;

		OnPlayerFreeze(playerid, true, 0);
		PlayerCache[playerid][pBusStart] = object_id;

		TD_ShowSmallInfo(playerid, 0, "Uzywaj klawiszy ~y~strzalek, ~w~by dowolnie zmieniac pozycje widoku z lotu ptaka.~n~~n~~y~~k~~PED_JUMPING~ ~w~- wybierz najblizszy przystanek~n~~y~~k~~VEHICLE_ENTER_EXIT~ ~w~- anuluj przejazdzke");
		return 1;
	}
	
    new bus_object_id = GetObjectID(bus_object_uid);
    if(bus_object_id == INVALID_OBJECT_ID || GetObjectModel(bus_object_id) != OBJECT_BUSSTOP || bus_object_id == object_id)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owy numer przystanku.");
	    return 1;
	}
	new Float:PosX, Float:PosY, Float:PosZ,
	    Float:Distance, string[256];
	    
	PlayerCache[playerid][pBusTravel] = bus_object_id;
	GetDynamicObjectPos(object_id, PosX, PosY, PosZ);
	
	Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, bus_object_id, Distance);

	PlayerCache[playerid][pBusTime] = floatround(Distance, floatround_floor) / 15;
	PlayerCache[playerid][pBusPrice] = floatround(Distance, floatround_floor) / 20;

	if(PlayerCache[playerid][pHours] < 5)	PlayerCache[playerid][pBusPrice] = 0;

	format(string, sizeof(string), "Przejazd: %d <-> %d\n\nCzas trwania jazdy: %ds\nKoszt przejazdu: $%d\n\nCzy jeste� pewien, �e chcesz si� tutaj uda�?", GetObjectUID(object_id), GetObjectUID(bus_object_id), PlayerCache[playerid][pBusTime], PlayerCache[playerid][pBusPrice]);
	ShowPlayerDialog(playerid, D_BUS_ACCEPT, DIALOG_STYLE_MSGBOX, "Bus", string, "Tak", "Nie");
	return 1;
}

CMD:anim(playerid, params[])
{
	new list_anims[2048];
	foreach(new anim_id : Anim)
	{
	    format(list_anims, sizeof(list_anims), "%s\n%s", list_anims, AnimCache[anim_id][aCommand]);
	}
	
	if(strlen(list_anims))
	{
	    ShowPlayerDialog(playerid, D_PLAY_ANIM, DIALOG_STYLE_LIST, "Lista animacji:", list_anims, "Start", "Zamknij");
	}
	else
	{
	    TD_ShowSmallInfo(playerid, 3, "Nie znaleziono ~r~zadnych ~w~animacji.");
	}
	return 1;
}

CMD:animacje(playerid, params[])    return cmd_anim(playerid, params);

CMD:opis(playerid, params[])
{
	new desc[128];
	if(sscanf(params, "s[128]", desc))
	{
	    ShowTipForPlayer(playerid, "/opis [Tre�� opisu] | Aby usun�� opis, u�yj komendy /opis usun.");
		return 1;
	}
	if(!strcmp(desc, "usun", true))
	{
 		UpdateDynamic3DTextLabelText(Text3D:PlayerCache[playerid][pDescTag], COLOR_DESC, " ");
		TD_ShowSmallInfo(playerid, 3, "Opis zostal ~g~pomyslnie ~w~usuniety.");
	    return 1;
	}
	format(desc, sizeof(desc), "%s", WordWrap(desc, WRAP_AUTO));
	
	UpdateDynamic3DTextLabelText(Text3D:PlayerCache[playerid][pDescTag], COLOR_DESC, desc);
 	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Ustalono nowy opis postaci:\n\n%s", desc);

    Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pDescTag], E_STREAMER_ATTACHED_PLAYER, playerid);
    Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:PlayerCache[playerid][pDescTag], E_STREAMER_Z, -0.6);
	return 1;
}

CMD:id(playerid, params[])
{
	new nick[24], list_players[256];
    if(sscanf(params, "s[24]", nick))
	{
        foreach(new i : Player)
        {
            if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
            {
                if(PlayerToPlayer(10.0, playerid, i))
                {
                    format(list_players, sizeof(list_players), "%s\n%d\t%s", list_players, i, PlayerName(i));
                }
            }
        }
        if(strlen(list_players))
        {
            ShowPlayerDialog(playerid, D_PLAYER_LIST, DIALOG_STYLE_LIST, "Gracze znajduj�cy si� w pobli�u:", list_players, "PW", "Zamknij");
        }
        else
        {
            ShowTipForPlayer(playerid, "/id [Cz�� nicku]");
        }
		return 1;
    }
	if(strlen(nick) < 3)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz wpisa� przynajmniej 3 znaki.");
		return 1;
	}
	new name[24];
	foreach(new i : Player)
   	{
   	    GetPlayerName(i, name, sizeof(name));
        if(strfind(name, nick, true) >= 0)
		{
			format(list_players, sizeof(list_players), "%s\n%d\t%s", list_players, i, PlayerName(i));
		}
    }
	if(strlen(list_players))
	{
	    ShowPlayerDialog(playerid, D_PLAYER_LIST, DIALOG_STYLE_LIST, "Znaleziono graczy:", list_players, "PW", "Zamknij");
	}
	else
	{
	    TD_ShowSmallInfo(playerid, 3, "Nie znaleziono ~r~zadnych ~w~graczy.");
	}
    return 1;
}

CMD:yo(playerid, params[])
{
	new type;
	if(sscanf(params, "d", type))
	{
		ShowTipForPlayer(playerid, "/yo [typ (1-7)]");
	    return 1;
	}
	if(type < 1 || type > 7)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owy typ powitania (1-7).");
	    return 1;
	}
	new giveplayer_id = GetClosestPlayer(playerid);
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego gracza w pobli�u.");
	    return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
 		return 1;
	}
 	OnPlayerSendOffer(playerid, giveplayer_id, "Powitanie", OFFER_WELCOME, type, 0, 0);
	return 1;
}

CMD:kiss(playerid, params[])
{
	new type;
	if(sscanf(params, "d", type))
	{
		ShowTipForPlayer(playerid, "/kiss [1-3]");
	    return 1;
	}
	if(type < 1 || type > 3)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owy typ poca�unku (1-3).");
	    return 1;
	}
	new giveplayer_id = GetClosestPlayer(playerid);
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znaleziono �adnego gracza w pobli�u.");
	    return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
 		return 1;
	}
	OnPlayerSendOffer(playerid, giveplayer_id, "Pocalunek", OFFER_WELCOME, type + 7, 0, 0);
	return 1;
}

CMD:paczka(playerid, params[])
{
	if(PlayerCache[playerid][pPackage] != INVALID_PACKAGE_ID)
	{
		DisablePlayerCheckpoint(playerid);
		
		PlayerCache[playerid][pCheckpoint] 	= CHECKPOINT_NONE;
		PlayerCache[playerid][pPackage]	 	= INVALID_PACKAGE_ID;
		
		TD_ShowSmallInfo(playerid, 3, "Dostarczanie paczki zostalo ~r~anulowane~w~.");
	    return 1;
	}

	new list_packages[1024], doorid;
	foreach(new package_id : Package)
	{
	    if(PackageCache[package_id][pUID])
	    {
	        doorid = GetDoorID(PackageCache[package_id][pDoorUID]);
	        
	        switch(PackageCache[package_id][pType])
	        {
	            case PACKAGE_PRODUCT:					if(PlayerCache[playerid][pJob] != JOB_COURIER)  			continue;
	            case PACKAGE_DRUGS, PACKAGE_WEAPON:		if(!IsPlayerInGroup(playerid, DoorCache[doorid][dOwner]))	continue;
	        }
	        format(list_packages, sizeof(list_packages), "%s\n%d\t\t%s", list_packages, PackageCache[package_id][pUID], DoorCache[doorid][dName]);
	    }
	}
	
	if(strlen(list_packages))
	{
	    ShowPlayerDialog(playerid, D_PACKAGE_GET, DIALOG_STYLE_LIST, "Dost�pne dla Ciebie paczki:", list_packages, "Dostarcz", "Anuluj");
	}
	else
	{
	    TD_ShowSmallInfo(playerid, 3, "Nie ma ~r~zadnych ~w~dostepnych paczek.");
	}
	return 1;
}

CMD:hurtownia(playerid, params[])   return cmd_paczka(playerid, params);

CMD:przejazd(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Musisz znajdowa� si� w poje�dzie.");
	    return 1;
	}
	foreach(new doorid : Door)
	{
	    if(DoorCache[doorid][dGarage])
	    {
	 		if(IsPlayerInRangeOfPoint(playerid, 5.0, DoorCache[doorid][dEnterX], DoorCache[doorid][dEnterY], DoorCache[doorid][dEnterZ]) && GetPlayerVirtualWorld(playerid) == DoorCache[doorid][dEnterVW])
	   		{
	   		    OnPlayerEnterDoor(playerid, doorid);
	   		    break;
	   		}
	     	else if(IsPlayerInRangeOfPoint(playerid, 5.0, DoorCache[doorid][dExitX], DoorCache[doorid][dExitY], DoorCache[doorid][dExitZ]) && GetPlayerVirtualWorld(playerid) == DoorCache[doorid][dExitVW])
	        {
	            OnPlayerExitDoor(playerid, doorid);
	            break;
	        }
	   }
	}
	return 1;
}

CMD:craft(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� przy stole do craftingu (model %d).", OBJECT_CRAFT);
		return 1;
	}
	new object_id = GetClosestObjectType(playerid, OBJECT_CRAFT);
	if(object_id == INVALID_OBJECT_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie znajdujesz si� przy stole do craftingu (model %d).", OBJECT_CRAFT);
	    return 1;
	}
	
	new object_uid = GetObjectUID(object_id), data[64], list_craft[512],
	    item_uid, item_name[32], item_value1, craft_value = 0;
	    
	mysql_query_format("SELECT `item_uid`, `item_name`, `item_value1` FROM `"SQL_PREF"items` WHERE item_place = '%d' AND item_owner = '%d'", PLACE_CRAFT, object_uid);
	
	mysql_store_result();
	while(mysql_fetch_row_format(data, "|"))
	{
	    sscanf(data, "p<|>ds[32]d", item_uid, item_name, item_value1);
	    format(list_craft, sizeof(list_craft), "%s\n%d\t\t%s", list_craft, item_uid, item_name);
	    
		craft_value += item_value1;
	}
	mysql_free_result();
	
	if(strlen(list_craft))
	{
		strcat(list_craft, "\n----", sizeof(list_craft));

		switch(craft_value)
		{
		    case 53:	strcat(list_craft, "\nW\t24\tDesert Eagle", sizeof(list_craft));
		    case 455:  	strcat(list_craft, "\nW\t30\tAK47", sizeof(list_craft));
		    case 647:   strcat(list_craft, "\nW\t29\tMP5", sizeof(list_craft));
		    case 1035:  strcat(list_craft, "\nW\t25\tShotgun", sizeof(list_craft));
		    case 2061:  strcat(list_craft, "\nW\t32\tTec9", sizeof(list_craft));
		    case 4140:  strcat(list_craft, "\nW\t22\tGlock", sizeof(list_craft));
		    case 8391:  strcat(list_craft, "\nW\t31\tM4", sizeof(list_craft));
		    default:    strcat(list_craft, "\n{FB5006}#\t\tNieprawid�owo dopasowane cz�ci", sizeof(list_craft));
		}
	}
	else
	{
	    TD_ShowSmallInfo(playerid, 3, "Nie ma ~r~zadnych ~w~przedmiotow do craftingu.");
	}
	
	PlayerCache[playerid][pMainTable] = object_uid;
	ShowPlayerDialog(playerid, D_ITEM_CRAFT, DIALOG_STYLE_LIST, "Crafting", list_craft, "Wyjmij", "Zamknij");
	return 1;
}


// --- Komendy administracji --- //
CMD:aj(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_PUNISH))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz nadawa� kar.");
	    return 1;
	}
	new giveplayer_id, time, reason[128];
	if(sscanf(params, "uds[128]", giveplayer_id, time, reason))
	{
	    ShowTipForPlayer(playerid, "/aj [ID gracza] [Czas (min - 0 uwalnia z AJ, je�li jest)] [Pow�d]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	if(PlayerCache[giveplayer_id][pBW])
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma BW.");
	    return 1;
	}
	reason[0] = chrtoupper(reason[0]);
	if(PlayerCache[giveplayer_id][pAJ])
	{
	    if(time <= 0)
	    {
	        PlayerCache[giveplayer_id][pAJ] = 0;
			SetPlayerSpawn(giveplayer_id);
			
			SendClientFormatMessage(giveplayer_id, COLOR_INFO, "%s uwolni� Ci� z AJ. Pow�d: %s", PlayerName(playerid), reason);
			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Pomy�lnie uwolniono gracza %s z AJ.\nPow�d: %s", PlayerName(giveplayer_id), reason);
	        return 1;
	    }
	    PlayerCache[giveplayer_id][pAJ] = time * 60;
	    
	    SendClientFormatMessage(giveplayer_id, COLOR_INFO, "%s zmieni� Ci czas AJ. Aktualnie %d min. Pow�d: %s", PlayerName(playerid), time, reason);
	    ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Pomy�lnie zmieniono czas trwania AJ graczowi %s. Aktualnie %d min.\nPow�d: %s", PlayerName(giveplayer_id), time, reason);
	}
	else
	{
	    if(time <= 0)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz umie�ci� gracza w AJ na czas mniejszy ni� 0.");
	        return 1;
	    }
		GivePlayerPunish(giveplayer_id, playerid, PUNISH_AJ, reason, time, 0);
	}
	return 1;
}

CMD:kick(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_PUNISH))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz nadawa� kar.");
	    return 1;
	}
	new giveplayer_id, reason[128];
	if(sscanf(params, "us[128]", giveplayer_id, reason))
	{
	    ShowTipForPlayer(playerid, "/kick [ID gracza] [Pow�d]");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	reason[0] = chrtoupper(reason[0]);
	GivePlayerPunish(giveplayer_id, playerid, PUNISH_KICK, reason, 0, 0);
	return 1;
}

CMD:warn(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_PUNISH))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz nadawa� kar.");
	    return 1;
	}
	new giveplayer_id, reason[128];
	if(sscanf(params, "us[128]", giveplayer_id, reason))
	{
	    ShowTipForPlayer(playerid, "/warn [ID gracza] [Pow�d]");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	reason[0] = chrtoupper(reason[0]);
	GivePlayerPunish(giveplayer_id, playerid, PUNISH_WARN, reason, 0, 0);
	return 1;
}

CMD:unwarn(playerid, params[])
{
    if(!(PlayerCache[playerid][pAdmin] & A_PERM_PUNISH))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz nadawa� kar.");
	    return 1;
	}
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/unwarn [ID gracza]");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	if(PlayerCache[giveplayer_id][pWarns] <= 0)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz nie ma na swoim koncie �adnych warn�w.");
	    return 1;
	}
	PlayerCache[giveplayer_id][pWarns] --;
	mysql_query_format("UPDATE `ipb_members` SET member_game_warns = '%d' WHERE member_id = '%d' LIMIT 1", PlayerCache[giveplayer_id][pWarns], PlayerCache[giveplayer_id][pGID]);

	SendClientFormatMessage(giveplayer_id, COLOR_INFO, "%s zdj�� Ci warna. Obecny stan ostrze�e�: %d", PlayerName(playerid), PlayerCache[giveplayer_id][pWarns]);
	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Zdj��e� warna graczowi %s. Obecny stan ostrze�e�: %d", PlayerName(giveplayer_id), PlayerCache[giveplayer_id][pWarns]);
	return 1;
}

CMD:block(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_PUNISH))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz nadawa� kar.");
	    return 1;
	}
	new type[12], varchar[256];
	if(sscanf(params, "s[12]S()[256]", type, varchar))
	{
	    ShowTipForPlayer(playerid, "/block [char | veh | run | ooc]");
	    return 1;
	}
	if(!strcmp(type, "char", true))
	{
	   	new giveplayer_id, reason[128];
		if(sscanf(varchar, "us[128]", giveplayer_id, reason))
		{
		    ShowTipForPlayer(playerid, "/block char [ID gracza] [Pow�d]");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
			return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBlock] & BLOCK_CHAR)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ta posta� zosta�a ju� zablokowana!");
		    return 1;
		}
		reason[0] = chrtoupper(reason[0]);
        GivePlayerPunish(giveplayer_id, playerid, PUNISH_BLOCK, reason, 0, BLOCK_CHAR);
	    return 1;
	}
	if(!strcmp(type, "veh", true))
	{
		new giveplayer_id, time, reason[128];
		if(sscanf(varchar, "uds[128]", giveplayer_id, time, reason))
		{
		    ShowTipForPlayer(playerid, "/block veh [ID gracza] [Czas (dni)] [Pow�d]");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
			return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBlock] & BLOCK_VEH)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma ju� na�o�on� blokad� prowadzenia pojazd�w.");
		    return 1;
		}
		if(time <= 0 || time > 30)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Czas nie mo�e by� mniejszy ni� 0 i 30.");
		    return 1;
		}
		reason[0] = chrtoupper(reason[0]);
        GivePlayerPunish(giveplayer_id, playerid, PUNISH_BLOCK, reason, time, BLOCK_VEH);
	    return 1;
	}
	if(!strcmp(type, "run", true))
	{
		new giveplayer_id, time, reason[128];
		if(sscanf(varchar, "uds[128]", giveplayer_id, time, reason))
		{
		    ShowTipForPlayer(playerid, "/block run [ID gracza] [Czas (dni)] [Pow�d]");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
			return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBlock] & BLOCK_RUN)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma ju� na�o�on� blokad� biegania.");
		    return 1;
		}
		if(time <= 0 || time > 30)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Czas nie mo�e by� mniejszy ni� 0 i 30.");
		    return 1;
		}
  		reason[0] = chrtoupper(reason[0]);
		GivePlayerPunish(giveplayer_id, playerid, PUNISH_BLOCK, reason, time, BLOCK_RUN);
	    return 1;
	}
	if(!strcmp(type, "ooc", true))
	{
		new giveplayer_id, time, reason[128];
		if(sscanf(varchar, "uds[128]", giveplayer_id, time, reason))
		{
		    ShowTipForPlayer(playerid, "/block ooc [ID gracza] [Czas (dni)] [Pow�d]");
			return 1;
		}
		if(giveplayer_id == INVALID_PLAYER_ID)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
			return 1;
		}
		if(!PlayerCache[giveplayer_id][pLogged])
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
	    	return 1;
		}
		if(PlayerCache[giveplayer_id][pBlock] & BLOCK_OOC)
		{
		    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz ma ju� na�o�on� blokad� pisania na czacie OOC.");
		    return 1;
		}
		if(time <= 0 || time > 30)
		{
			ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Czas nie mo�e by� mniejszy ni� 0 i 30.");
		    return 1;
		}
  		reason[0] = chrtoupper(reason[0]);
		GivePlayerPunish(giveplayer_id, playerid, PUNISH_BLOCK, reason, time, BLOCK_OOC);
	    return 1;
	}
	return 1;
}

CMD:ban(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_PUNISH))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz nadawa� kar.");
	    return 1;
	}
	new giveplayer_id, time, reason[128];
	if(sscanf(params, "uds[128]", giveplayer_id, time, reason))
	{
	    ShowTipForPlayer(playerid, "/ban [ID gracza] [Czas (dni)] [Pow�d]");
		return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	if(time <= 0 || time > 365)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Czas nie mo�e by� mniejszy ni� 0 i wi�kszy od 365.");
  		return 1;
	}
	reason[0] = chrtoupper(reason[0]);
	GivePlayerPunish(giveplayer_id, playerid, PUNISH_BAN, reason, time, 0);
	return 1;
}

CMD:bw(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz u�ywa� tej komendy.");
	    return 1;
	}
	new giveplayer_id, time;
	if(sscanf(params, "ud", giveplayer_id, time))
	{
	    ShowTipForPlayer(playerid, "/bw [ID gracza] [Czas (min - 0 zdejmuje bw, je�li ma)]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
    	return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
 		return 1;
	}
	if(PlayerCache[giveplayer_id][pBW])
	{
		if(time <= 0)
		{
			PlayerCache[giveplayer_id][pBW] = 0;

			ApplyAnimation(giveplayer_id, "Attractors", "Stepsit_out", 4.0, 0, 1, 1, 0, 1, true);
			OnPlayerFreeze(giveplayer_id, false, 0);

			ResetPlayerCamera(giveplayer_id);
			crp_SetPlayerHealth(giveplayer_id, 20);

			SendClientFormatMessage(giveplayer_id, COLOR_INFO, "%s zdj�� Ci BW.", PlayerName(playerid));
			ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Pomy�lnie zdj�to BW graczowi %s.", PlayerName(giveplayer_id));
		    return 1;
		}

		PlayerCache[giveplayer_id][pBW] = time * 60;

		SendClientFormatMessage(giveplayer_id, COLOR_INFO, "%s zmieni� Ci czas BW. Aktualnie %d min.", PlayerName(playerid), time);
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Pomy�lnie zmieniono czas trwania BW graczowi %s. Aktualnie %d min.", PlayerName(giveplayer_id), time);
	}
	else
	{
	    if(time <= 0)
	    {
	        ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz na�o�y� BW na czas mniejszy ni� 0.");
	        return 1;
	    }
	    PlayerCache[giveplayer_id][pBW] = time * 60;

		PlayerCache[giveplayer_id][pInteriorID] = GetPlayerInterior(giveplayer_id);
		PlayerCache[giveplayer_id][pVirtualWorld] = GetPlayerVirtualWorld(giveplayer_id);

		GetPlayerPos(giveplayer_id, PlayerCache[giveplayer_id][pPosX], PlayerCache[giveplayer_id][pPosY], PlayerCache[giveplayer_id][pPosZ]);

		SetPlayerCameraPos(giveplayer_id, PlayerCache[giveplayer_id][pPosX] + 3, PlayerCache[giveplayer_id][pPosY] + 4, PlayerCache[giveplayer_id][pPosZ] + 7);
		SetPlayerCameraLookAt(giveplayer_id, PlayerCache[giveplayer_id][pPosX], PlayerCache[giveplayer_id][pPosY], PlayerCache[giveplayer_id][pPosZ], CAMERA_CUT);

        OnPlayerFreeze(giveplayer_id, true, 0);
		OnPlayerSave(giveplayer_id, SAVE_PLAYER_POS);

		SendClientFormatMessage(giveplayer_id, COLOR_INFO, "%s na�o�y� Ci BW na czas %d min.", PlayerName(playerid), time);
		ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Pomy�lnie na�o�ono BW graczowi %s na czas %d min.", PlayerName(giveplayer_id), time);
	}
	return 1;
}

CMD:akceptujsmierc(playerid, params[])
{
	if(!PlayerCache[playerid][pBW])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "U�ywanie tej komendy dost�pne jest tylko podczas stanu nieprzytomno�ci.");
	    return 1;
	}
	if((!IsPlayerPremium(playerid) && PlayerCache[playerid][pHours] < 10) || PlayerCache[playerid][pHours] < 3)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz u�mierci� postaci, na kt�rej przegra�e� mniej ni� 10 godzin (konto premium - 3).");
	    return 1;
	}
	new killer_uid = PlayerCache[playerid][pDeathKiller],
		weapon_uid = PlayerCache[playerid][pDeathWeapon];

	CreatePlayerCorpse(playerid, killer_uid, weapon_uid);
	PlayerCache[playerid][pBlock] += BLOCK_CHAR;
	
	mysql_query_format("UPDATE `"SQL_PREF"characters` SET char_block = '%d' WHERE char_uid = '%d' LIMIT 1", PlayerCache[playerid][pBlock], PlayerCache[playerid][pUID]);
	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Twoja posta� zosta�a u�miercona.\nOd tej pory posta�, kt�ra zosta�a u�miercona jest ju� nieaktywna.\n\nZostajesz wyrzucony z serwera.");

	defer OnKickPlayer(playerid);
	return 1;
}

CMD:tp(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new Float:PosX, Float:PosY, Float:PosZ,
		interior_id, virtual_world;
		
	if(sscanf(params, "fffdd", PosX, PosY, PosZ, interior_id, virtual_world))
	{
	    ShowTipForPlayer(playerid, "/tp [PosX] [PosY] [PosZ] [Int] [Vw]");
	    return 1;
	}
	crp_SetPlayerPos(playerid, PosX, PosY, PosZ);

	SetPlayerInterior(playerid, interior_id);
	SetPlayerVirtualWorld(playerid, virtual_world);
	return 1;
}

CMD:teleport(playerid, params[])    return cmd_tp(playerid, params);

CMD:ptp(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new getplayer_id, giveplayer_id;
	if(sscanf(params, "uu", getplayer_id, giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/ptp [ID gracza (1)] [ID gracza (2)]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	new Float:PosX, Float:PosY, Float:PosZ,
	    interior_id, virtual_world;

	GetPlayerPos(giveplayer_id, PosX, PosY, PosZ);

	interior_id = GetPlayerInterior(giveplayer_id);
	virtual_world = GetPlayerVirtualWorld(giveplayer_id);

	crp_SetPlayerPos(getplayer_id, PosX, PosY, PosZ);

	SetPlayerInterior(getplayer_id, interior_id);
	SetPlayerVirtualWorld(getplayer_id, virtual_world);

	ShowPlayerInfoDialog(playerid, D_TYPE_INFO, "Gracz %s zosta� przeteleportowany do gracza %s pomy�lnie.", PlayerName(getplayer_id), PlayerName(giveplayer_id));
	return 1;
}

CMD:goto(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/goto [ID gracza]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	new Float:PosX, Float:PosY, Float:PosZ,
	    interior_id, virtual_world;
	    
	GetPlayerPos(giveplayer_id, PosX, PosY, PosZ);

	interior_id = GetPlayerInterior(giveplayer_id);
	virtual_world = GetPlayerVirtualWorld(giveplayer_id);

	crp_SetPlayerPos(playerid, PosX + 3.0, PosY, PosZ);

	SetPlayerInterior(playerid, interior_id);
	SetPlayerVirtualWorld(playerid, virtual_world);
	return 1;
}

CMD:to(playerid, params[])  return cmd_goto(playerid, params);

CMD:gethere(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/gethere [ID gracza]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	new Float:PosX, Float:PosY, Float:PosZ,
	    interior_id, virtual_world;
	    
	GetPlayerPos(playerid, PosX, PosY, PosZ);

	interior_id = GetPlayerInterior(playerid);
	virtual_world = GetPlayerVirtualWorld(playerid);

	crp_SetPlayerPos(giveplayer_id, PosX + 3.0, PosY, PosZ);

	SetPlayerInterior(giveplayer_id, interior_id);
	SetPlayerVirtualWorld(giveplayer_id, virtual_world);
	return 1;
}

CMD:tm(playerid, params[])  return cmd_gethere(playerid, params);

CMD:spec(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
		if(PlayerCache[playerid][pSpectate] != INVALID_PLAYER_ID)
		{
			SetPlayerSpawn(playerid);
		    return 1;
		}
		ShowTipForPlayer(playerid, "/spec [ID gracza]");
	    return 1;
	}
	if(giveplayer_id == playerid)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Nie mo�esz podgl�da� siebie.");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	if(PlayerCache[giveplayer_id][pSpectate] != INVALID_PLAYER_ID)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Ten gracz podgl�da innego gracza.");
	    return 1;
	}
	if(PlayerCache[playerid][pSpectate] == INVALID_PLAYER_ID)
	{
		GetPlayerPos(playerid, PlayerCache[playerid][pPosX], PlayerCache[playerid][pPosY], PlayerCache[playerid][pPosZ]);

		PlayerCache[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
		PlayerCache[playerid][pInteriorID] = GetPlayerInterior(playerid);
	}

	// Je�li ma bro�
	if(PlayerCache[playerid][pItemWeapon] != INVALID_ITEM_ID)
	{
	    new itemid = PlayerCache[playerid][pItemWeapon];

		PlayerCache[playerid][pItemWeapon] = INVALID_ITEM_ID;
  		ResetPlayerWeaponsEx(playerid);

		RemovePlayerAttachedObject(playerid, SLOT_WEAPON);

  		PlayerCache[playerid][pCheckWeapon] = false;
   		ItemCache[itemid][iUsed] = false;

		SaveItem(itemid, SAVE_ITEM_VALUES);
	}
	PlayerCache[playerid][pSpectate] = giveplayer_id;

	new player_state = GetPlayerState(giveplayer_id);
	TogglePlayerSpectating(playerid, true);

	SetPlayerInterior(playerid, GetPlayerInterior(giveplayer_id));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayer_id));

	switch(player_state)
	{
		case 0, 1, 7, 8:	PlayerSpectatePlayer(playerid, giveplayer_id);
		case 2, 3:			PlayerSpectateVehicle(playerid , GetPlayerVehicleID(giveplayer_id));
	}
	
	TD_ShowSmallInfo(playerid, 0, "Podglad gracza jest teraz ~y~aktywny~w~.~n~~n~Uzywaj klawiszy ~r~~k~~SNEAK_ABOUT~ ~w~oraz ~r~~k~~PED_SPRINT~~w~, aby swobodnie ~g~przeskakiwac ~w~miedzy graczami.");
	return 1;
}

CMD:recon(playerid, params[])   return cmd_spec(playerid, params);
CMD:rc(playerid, params[])      return cmd_spec(playerid, params);

CMD:setint(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new giveplayer_id, interior_id;
	if(sscanf(params, "ud", giveplayer_id, interior_id))
	{
	    ShowTipForPlayer(playerid, "/setint [ID gracza] [Interior]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	SetPlayerInterior(giveplayer_id, interior_id);
	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "InteriorID gracza %s zosta� zmieniony pomy�lnie.\nNowy interior: %d", PlayerName(giveplayer_id), interior_id);
	return 1;
}

CMD:setvw(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new giveplayer_id, virtual_world;
	if(sscanf(params, "ud", giveplayer_id, virtual_world))
	{
	    ShowTipForPlayer(playerid, "/setvw [ID gracza] [VirtualWorld]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	SetPlayerVirtualWorld(giveplayer_id, virtual_world);
	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "VirualWorld gracza %s zosta� zmieniony pomy�lnie.\nNowy VirtualWorld: %d", PlayerName(giveplayer_id), virtual_world);
	return 1;
}

CMD:sethp(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new giveplayer_id, Float:health;
	if(sscanf(params, "uf", giveplayer_id, health))
	{
	    ShowTipForPlayer(playerid, "/sethp [ID gracza] [Ilo�� HP]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	crp_SetPlayerHealth(giveplayer_id, health);
	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "HP gracza %s zosta�o pomy�lnie zmienione. Nowy stan HP: %.1f", PlayerName(giveplayer_id), health);
	return 1;
}

CMD:hp(playerid, params[])  return cmd_sethp(playerid, params);

CMD:setskin(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new giveplayer_id, skin_id;
	if(sscanf(params, "ud", giveplayer_id, skin_id))
	{
	    ShowTipForPlayer(playerid, "/setskin [ID gracza] [ID skina]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	if(skin_id < 0 || skin_id > 300)
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Wprowadzono nieprawid�owe ID skina.");
	    return 1;
	}
	crp_SetPlayerSkin(giveplayer_id, skin_id);
	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Skin gracza %s zosta� pomy�lnie zmieniony. Nowy skin: %d", PlayerName(giveplayer_id), skin_id);
	return 1;
}

CMD:freeze(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/freeze [ID gracza]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	OnPlayerFreeze(giveplayer_id, true, 0);
	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Gracz %s zosta� pomy�lnie zamro�ony.", PlayerName(giveplayer_id));
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/unfreeze [ID gracza]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	OnPlayerFreeze(giveplayer_id, false, 0);
	ShowPlayerInfoDialog(playerid, D_TYPE_SUCCESS, "Gracz %s zosta� pomy�lnie odmro�ony.", PlayerName(giveplayer_id));
	return 1;
}

CMD:ac(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	if(isnull(params))
	{
	    ShowTipForPlayer(playerid, "/ac [Tekst]");
	    return 1;
	}
	new string[256];
	params[0] = chrtoupper(params[0]);

	if(PlayerCache[playerid][pAdmin] >= A_PERM_MAX)
	{
		format(string, sizeof(string), "(( [AC] {FF0000}%s{EEE8AA}: %s ))", PlayerName(playerid), params);
	}
	else
	{
	    format(string, sizeof(string), "(( [AC] {800080}%s{EEE8AA}: %s ))", PlayerName(playerid), params);
	}

	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pAdmin] & A_PERM_BASIC)
	        {
	            SendClientMessage(i, COLOR_ADMIN, string);
	        }
	    }
	}
	return 1;
}

CMD:ado(playerid, params[])
{
	if(PlayerCache[playerid][pAdmin] < A_PERM_MAX)
	{
        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
        return 1;
	}
	if(isnull(params))
	{
		ShowTipForPlayer(playerid, "/ado [Sytuacja]");
	    return 1;
	}
	new string[256];
	params[0] = chrtoupper(params[0]);

	format(string, sizeof(string), "** %s **", params);
	SendClientMessageToAll(COLOR_DO, string);
	return 1;
}

CMD:slap(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new giveplayer_id;
	if(sscanf(params, "u", giveplayer_id))
	{
	    ShowTipForPlayer(playerid, "/slap [ID gracza]");
	    return 1;
	}
	if(giveplayer_id == INVALID_PLAYER_ID)
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Podano b��dne ID gracza.");
		return 1;
	}
	if(!PlayerCache[giveplayer_id][pLogged])
	{
		ShowPlayerInfoDialog(playerid, D_TYPE_ERROR, "Gracz o podanym ID nie jest zalogowany.");
    	return 1;
	}
	new Float:PosX, Float:PosY, Float:PosZ;
	
	GetPlayerPos(giveplayer_id, PosX, PosY, PosZ);
	crp_SetPlayerPos(giveplayer_id, PosX, PosY, PosZ + 5.0);

	GameTextForPlayer(giveplayer_id, "~n~~n~~n~~r~SLAP!", 3000, 3);
	GameTextForPlayer(playerid, "~n~~n~~n~~r~SLAP!", 3000, 3);
	return 1;
}

CMD:duty(playerid, params[])
{
	if(!(PlayerCache[playerid][pAdmin] & A_PERM_BASIC))
	{
	    ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
	    return 1;
	}
	new name[32];
	if(!PlayerCache[playerid][pDutyAdmin])
	{
 		PlayerCache[playerid][pDutyAdmin] = true;
	    PlayerCache[playerid][pSession][SESSION_ADMIN] = gettime();
	    
	   	format(name, sizeof(name), "%s", PlayerCache[playerid][pGlobName]);
		strmid(PlayerCache[playerid][pCharName], name, 0, strlen(name), 32);
	    
	    UpdatePlayerStatus(playerid);
	    SendClientMessage(playerid, COLOR_INFO, "Wszed�e� na s�u�b� administratora. Aby zej��, u�yj ponownie tej komendy.");
	}
	else
	{
		new	duty_hours = floatround((gettime() - PlayerCache[playerid][pSession][SESSION_ADMIN]) / 3600, floatround_floor),
			duty_minutes = floatround((gettime() - PlayerCache[playerid][pSession][SESSION_ADMIN]) / 60, floatround_floor) % 60;
	
	    UpdatePlayerSession(playerid, SESSION_ADMIN, 0);
	
	    PlayerCache[playerid][pDutyAdmin] = false;
	    PlayerCache[playerid][pSession][SESSION_ADMIN] = 0;
	    
	    GetPlayerName(playerid, name, sizeof(name));
		strmid(PlayerCache[playerid][pCharName], name, 0, strlen(name), 32);

	    UpdatePlayerStatus(playerid);
	    SendClientFormatMessage(playerid, COLOR_INFO, "Zszed�e� ze s�u�by administratora. Czas trwania sesji: %dh %dm", duty_hours, duty_minutes);
	}
	return 1;
}

CMD:sluzba(playerid, params[])  return cmd_duty(playerid, params);

CMD:limits(playerid, params[])
{
	if(PlayerCache[playerid][pAdmin] < A_PERM_MAX)
	{
        ShowPlayerInfoDialog(playerid, D_TYPE_NO_PERM, "Nie mo�esz skorzysta� z tej komendy.");
        return 1;
	}
	new string[256];
	
	format(string, sizeof(string), "Gracze:\t\t\t%d/%d\nPojazdy:\t\t%d/%d\nDrzwi:\t\t\t%d/%d\nStrefy:\t\t\t%d/%d\nPrzedmioty:\t\t%d/%d\nProdukty:\t\t%d/%d\nGrupy:\t\t\t%d/%d", Iter_Count(Player), MAX_PLAYERS, Iter_Count(Vehicles), MAX_VEHICLES, Iter_Count(Door), MAX_DOORS, Iter_Count(Area), MAX_AREAS, Iter_Count(Item), MAX_ITEM_CACHE, Iter_Count(Product), MAX_PRODUCTS, Iter_Count(Groups), MAX_GROUPS);
	ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_LIST, "Limity serwerowe", string, "OK", "");
	return 1;
}

/*
CMD:test(playerid, params[])
{
	new Float:mapMinX = -2874.0000,
	    Float:mapMinY = 2874.0000;
	    
	new Float:mapMaxX = 2874.0000,
	    Float:mapMaxY = -2874.0000;
	    
	new Float:areaMinX, Float:areaMinY,
	    Float:areaMaxX, Float:areaMaxY;

	new Float:distance = 100.0;
	
	new zone, color, counts;
	while((areaMinX < mapMaxX) && (areaMinY > mapMaxY) && counts < 100)
	{
		areaMinX = mapMinX + distance;
		areaMinY = mapMinY - distance;
		
		mapMinX = areaMinX;
		mapMinY = areaMinY;

		switch(random(5))
		{
			case 0: color = COLOR_RED;
			case 1: color = COLOR_YELLOW;
			case 2: color = COLOR_GREEN;
			case 3: color = COLOR_PURPLE;
			case 4: color = COLOR_BLUE;
		}
		
		zone = GangZoneCreate(areaMinX, areaMinY, areaMinX + distance, areaMinY - distance);
		GangZoneShowForPlayer(playerid, zone, color);
		
		counts ++;
	}
	SendClientFormatMessage(playerid, COLOR_RED, "Utworzono %d stref uko�nych.", counts);
	
	counts = 0;
	
	areaMinX = 0.0;
	areaMinY = 0.0;
	
	mapMinX = -2874.0000,
 	mapMinY = 2874.0000;

	mapMaxX = 2874.0000,
 	mapMaxY = -2874.0000;
	
	while((areaMinX < mapMaxX) && (areaMinY > mapMaxY) && counts < 100)
	{
		areaMinX = mapMinX + distance;
		areaMinY = mapMinY;

		mapMinX = areaMinX;
		mapMinY = areaMinY;

		switch(random(5))
		{
			case 0: color = COLOR_RED;
			case 1: color = COLOR_YELLOW;
			case 2: color = COLOR_GREEN;
			case 3: color = COLOR_PURPLE;
			case 4: color = COLOR_BLUE;
		}

		zone = GangZoneCreate(areaMinX, areaMinY, areaMinX, areaMinY - distance);
		GangZoneShowForPlayer(playerid, zone, color);

		counts ++;
	}
	SendClientFormatMessage(playerid, COLOR_RED, "Utworzono %d stref poziomych.", counts);
	return 1;
}
*/

/* STOCKI */
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

stock PlayerRealName(playerid)
{
	new pos, name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));

    pos = strfind(name, "_", true);
	while(pos != -1)
	{
		name[pos] = ' ';
		pos = strfind(name, "_", true);
	}
	return name;
}

stock PlayerOriginalName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock crp_SetPlayerHealth(playerid, Float:health)
{
	PlayerCache[playerid][pHealth] = health;
	SetPlayerHealth(playerid, PlayerCache[playerid][pHealth]);
	return 1;
}

stock crp_SetPlayerSkin(playerid, skinid)
{
	SetPlayerSkin(playerid, skinid);

	PlayerCache[playerid][pSkin] 		= skinid;
	PlayerCache[playerid][pLastSkin] 	= 0;
	return 1;
}

stock SetPlayerSkinEx(playerid, skinid)
{
	SetPlayerSkin(playerid, skinid);
	PlayerCache[playerid][pLastSkin] = skinid;
	return 1;
}

stock ResetPlayerCamera(playerid)
{
	new object_id = PlayerCache[playerid][pFirstPersonObject];
	if(object_id == INVALID_OBJECT_ID)
	{
	    SetCameraBehindPlayer(playerid);
	}
	else
	{
	    AttachObjectToPlayer(object_id, playerid, 0.0, 0.10, 0.65, 0.0, 0.0, 0.0);
	    AttachCameraToObject(playerid, object_id);
	}
	return 1;
}

stock crp_GivePlayerMoney(playerid, money)
{
	PlayerCache[playerid][pCash] += money;
	GivePlayerMoney(playerid, money);
	return 1;
}

stock crp_SetPlayerPos(playerid, Float:PosX, Float:PosY, Float:PosZ)
{
	PlayerCache[playerid][pCheckPos] = false;
    SetPlayerPos(playerid, PosX, PosY, PosZ);

	PlayerCache[playerid][pPosX] = PosX;
 	PlayerCache[playerid][pPosY] = PosY;
    PlayerCache[playerid][pPosZ] = PosZ;
	return 1;
}

stock IsGlobalLogged(player_gid)
{
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
	        if(PlayerCache[i][pGID] == player_gid)
	        {
	            return true;
	        }
	    }
	}
	return false;
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

stock GetClosestPlayer(playerid)
{
	new Float:dist, Float:prevdist = 5.000,
		prevplayer = INVALID_PLAYER_ID;

	foreach(new i : Player)
	{
	    if(i != playerid)
	    {
			dist = GetDistanceToPlayer(playerid, i);
			if ((dist < prevdist))
			{
				prevdist = dist;
				prevplayer = i;
			}
		}
	}
	return prevplayer;
}

stock GetDistanceToPlayer(playerid, giveplayer_id)
{
	new Float:x1, Float:y1, Float:z1,
		Float:x2, Float:y2, Float:z2, Float:dis;

	GetPlayerPos(playerid, x1, y1, z1);
	GetPlayerPos(giveplayer_id, x2, y2, z2);

	dis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
	return floatround(dis);
}

stock GetPlayerID(player_uid)
{
	new playerid = INVALID_PLAYER_ID;
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
			if(PlayerCache[i][pUID] == player_uid)
			{
				playerid = i;
				break;
			}
		}
	}
	return playerid;
}

stock GetOffererID(playerid)
{
	new customerid = INVALID_PLAYER_ID;
	foreach(new i : Player)
	{
	    if(OfferData[i][oCustomerID] == playerid)
	    {
	        customerid = i;
	        break;
	    }
	}
	return customerid;
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance) //by Y_Less
{
 	new Float:a;
 	GetPlayerPos(playerid, x, y, a);
 	GetPlayerFacingAngle(playerid, a);

 	x += (distance * floatsin(-a, degrees));
 	y += (distance * floatcos(-a, degrees));
}

stock CharCode(player_uid)
{
    new string[32], charcode[5];
	format(string, sizeof(string), "%d", player_uid);

	strmid(charcode, MD5_Hash(string), 0, strlen(MD5_Hash(string)), 5);
	strmid(charcode, charcode, 0, 4, 5);

	return charcode;
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
	new string_desc[512];
	va_format(string_desc, sizeof(string_desc), desc, va_start<3>);
	
	switch(dialog_type)
	{
	    case D_TYPE_INFO:
	    {
			ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Informacja", string_desc, "OK", "");
	    }
	    case D_TYPE_ERROR:
	    {
	        ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Wyst�pi� b��d!", string_desc, "OK", "");
	    }
	    case D_TYPE_SUCCESS:
	    {
	        ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Powodzenie", string_desc, "OK", "");
	    }
	    case D_TYPE_HELP:
	    {
	        ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Pomoc", string_desc, "OK", "");
	    }
	    case D_TYPE_NO_PERM:
	    {
	        ShowPlayerDialog(playerid, D_NONE, DIALOG_STYLE_MSGBOX, "Brak uprawnie�", string_desc, "OK", "");
	    }
	}
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

stock mysql_query_format(format_query[], va_args<>)
{
	new query[512];

	va_format(query, sizeof(query), format_query, va_start<1>);
	mysql_query(connHandle, query);
	return 1;
}

stock PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid, animlib, "null", 0.0, 0, 0, 0, 0, 0);
	return 1;
}

stock PreloadPlayerAnimLib(playerid)
{
	PreloadAnimLib(playerid, "GHANDS");
	PreloadAnimLib(playerid, "GANGS");
	PreloadAnimLib(playerid, "PED");
	PreloadAnimLib(playerid, "MISC");
	PreloadAnimLib(playerid, "CRACK");
	PreloadAnimLib(playerid, "INT_HOUSE");
	PreloadAnimLib(playerid, "MUSCULAR");
	PreloadAnimLib(playerid, "ON_LOOKERS");
	PreloadAnimLib(playerid, "Attractors");
	PreloadAnimLib(playerid, "POOL");
	PreloadAnimLib(playerid, "INT_OFFICE");
	PreloadAnimLib(playerid, "BSKTBALL");
	PreloadAnimLib(playerid, "RAPPING");
	PreloadAnimLib(playerid, "BAR");
	PreloadAnimLib(playerid, "BEACH");
	PreloadAnimLib(playerid, "benchpress");
	PreloadAnimLib(playerid, "BASEBALL");
	PreloadAnimLib(playerid, "BLOWJOBZ");
	PreloadAnimLib(playerid, "BOMBER");
	PreloadAnimLib(playerid, "BOX");
	PreloadAnimLib(playerid, "BUDDY");
	PreloadAnimLib(playerid, "BUS");
	PreloadAnimLib(playerid, "CAMERA");
	PreloadAnimLib(playerid, "CAR");
	PreloadAnimLib(playerid, "CARRY");
	PreloadAnimLib(playerid, "CAR_CHAT");
	PreloadAnimLib(playerid, "CASINO");
	PreloadAnimLib(playerid, "CHAINSAW");
	PreloadAnimLib(playerid, "CHOPPA");
	PreloadAnimLib(playerid, "CLOTHES");
	PreloadAnimLib(playerid, "COACH");
	PreloadAnimLib(playerid, "COLT45");
	PreloadAnimLib(playerid, "COP_AMBIENT");
	PreloadAnimLib(playerid, "COP_DVBYZ");
	PreloadAnimLib(playerid, "CRIB");
	PreloadAnimLib(playerid, "DANCING");
	PreloadAnimLib(playerid, "DEALER");
	PreloadAnimLib(playerid, "DILDO");
	PreloadAnimLib(playerid, "DODGE");
	PreloadAnimLib(playerid, "DOZER");
	PreloadAnimLib(playerid, "DRIVEBYS");
	PreloadAnimLib(playerid, "FAT");
	PreloadAnimLib(playerid, "FIGHT_B");
	PreloadAnimLib(playerid, "FIGHT_C");
	PreloadAnimLib(playerid, "FIGHT_D");
	PreloadAnimLib(playerid, "FIGHT_E");
	PreloadAnimLib(playerid, "FINALE");
	PreloadAnimLib(playerid, "FINALE2");
	PreloadAnimLib(playerid, "FLAME");
	PreloadAnimLib(playerid, "Flowers");
	PreloadAnimLib(playerid, "FOOD");
	PreloadAnimLib(playerid, "Freeweights");
	PreloadAnimLib(playerid, "GHETTO_DB");
	PreloadAnimLib(playerid, "goggles");
	PreloadAnimLib(playerid, "GRAFFITI");
	PreloadAnimLib(playerid, "GRAVEYARD");
	PreloadAnimLib(playerid, "GRENADE");
	PreloadAnimLib(playerid, "GYMNASIUM");
	PreloadAnimLib(playerid, "HAIRCUTS");
	PreloadAnimLib(playerid, "HEIST9");
	PreloadAnimLib(playerid, "INT_OFFICE");
	PreloadAnimLib(playerid, "INT_SHOP");
	PreloadAnimLib(playerid, "JST_BUISNESS");
	PreloadAnimLib(playerid, "KART");
	PreloadAnimLib(playerid, "KISSING");
	PreloadAnimLib(playerid, "KNIFE");
	PreloadAnimLib(playerid, "LAPDAN1");
	PreloadAnimLib(playerid, "LAPDAN2");
	PreloadAnimLib(playerid, "LAPDAN3");
	PreloadAnimLib(playerid, "LOWRIDER");
	PreloadAnimLib(playerid, "MD_CHASE");
	PreloadAnimLib(playerid, "MD_END");
	PreloadAnimLib(playerid, "MEDIC");
	PreloadAnimLib(playerid, "MTB");
	PreloadAnimLib(playerid, "NEVADA");
	PreloadAnimLib(playerid, "OTB");
	PreloadAnimLib(playerid, "PARACHUTE");
	PreloadAnimLib(playerid, "PARK");
	PreloadAnimLib(playerid, "PAULNMAC");
	PreloadAnimLib(playerid, "PLAYER_DVBYS");
	PreloadAnimLib(playerid, "PLAYIDLES");
	PreloadAnimLib(playerid, "POLICE");
	PreloadAnimLib(playerid, "POOR");
	PreloadAnimLib(playerid, "PYTHON");
	PreloadAnimLib(playerid, "RIFLE");
	PreloadAnimLib(playerid, "RIOT");
	PreloadAnimLib(playerid, "ROB_BANK");
	PreloadAnimLib(playerid, "ROCKET");
	PreloadAnimLib(playerid, "RUSTLER");
	PreloadAnimLib(playerid, "RYDER");
	PreloadAnimLib(playerid, "SCRATCHING");
	PreloadAnimLib(playerid, "SHAMAL");
	PreloadAnimLib(playerid, "SHOP");
	PreloadAnimLib(playerid, "SHOTGUN");
	PreloadAnimLib(playerid, "SILENCED");
	PreloadAnimLib(playerid, "SKATE");
	PreloadAnimLib(playerid, "SMOKING");
	PreloadAnimLib(playerid, "SNIPER");
	PreloadAnimLib(playerid, "SPRAYCAN");
	PreloadAnimLib(playerid, "STRIP");
	PreloadAnimLib(playerid, "SUNBATHE");
	PreloadAnimLib(playerid, "SWAT");
	PreloadAnimLib(playerid, "SWEET");
	PreloadAnimLib(playerid, "SWIM");
	PreloadAnimLib(playerid, "SWORD");
	PreloadAnimLib(playerid, "TANK");
	PreloadAnimLib(playerid, "TATTOOS");
	PreloadAnimLib(playerid, "TEC");
	PreloadAnimLib(playerid, "TRAIN");
	PreloadAnimLib(playerid, "TRUCK");
	PreloadAnimLib(playerid, "UZI");
	PreloadAnimLib(playerid, "VAN");
	PreloadAnimLib(playerid, "VENDING");
	PreloadAnimLib(playerid, "VORTEX");
	PreloadAnimLib(playerid, "WAYFARER");
	PreloadAnimLib(playerid, "WEAPONS");
	PreloadAnimLib(playerid, "WUZI");
	return 1;
}

stock ClearPlayerChat(playerid)
{
	for(new i = 1; i < 40; i++)
	{
		SendClientMessage(playerid, COLOR_WHITE, " ");
	}
	return 1;
}

stock OnPlayerFreeze(playerid, bool: freeze, time)
{
	if(freeze)
	{
		TogglePlayerControllable(playerid, false);
		
		if(time)	PlayerCache[playerid][pFreeze] = time;
		else        PlayerCache[playerid][pFreeze] = -1;
	}
	else
	{
	    TogglePlayerControllable(playerid, true);
	    PlayerCache[playerid][pFreeze] = 0;
	}
	return 1;
}

stock SetPlayerMoney(playerid, money)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, money);
	return 1;
}

stock TD_ShowSmallInfo(playerid, showTime = 5, infoString[], va_args<>)
{
	new string[512];
	va_format(string, sizeof(string), infoString, va_start<3>);
	
	PlayerTextDrawSetString(playerid, PlayerText:TextDrawSmallInfo[playerid], string);
	PlayerTextDrawAlignment(playerid, PlayerText:TextDrawSmallInfo[playerid], 1);
	
	PlayerTextDrawShow(playerid, PlayerText:TextDrawSmallInfo[playerid]);
	PlayerCache[playerid][pSmallTextTime] = showTime;
	return 1;
}

stock TD_ShowLargeInfo(playerid, showTime = 5, infoString[], va_args<>)
{
	new string[512];
	
	va_format(string, sizeof(string), infoString, va_start<3>);
	PlayerTextDrawSetString(playerid, PlayerText:TextDrawLargeInfo[playerid][1], string);
	
	PlayerTextDrawShow(playerid, PlayerText:TextDrawLargeInfo[playerid][0]);
	PlayerTextDrawShow(playerid, PlayerText:TextDrawLargeInfo[playerid][1]);
	
	PlayerCache[playerid][pLargeTextTime] = showTime;
	return 1;
}

stock TD_HideSmallInfo(playerid)
{
	PlayerTextDrawHide(playerid, PlayerText:TextDrawSmallInfo[playerid]);
	PlayerCache[playerid][pSmallTextTime] = 0;
	return 1;
}

stock TD_HideLargeInfo(playerid)
{
    PlayerTextDrawHide(playerid, PlayerText:TextDrawLargeInfo[playerid][0]);
    PlayerTextDrawHide(playerid, PlayerText:TextDrawLargeInfo[playerid][1]);
    
	PlayerCache[playerid][pLargeTextTime] = 0;
	return 1;
}

stock TD_ShowDoor(playerid, showTime = 5, doorString[], va_args<>)
{
	new string[512];
	va_format(string, sizeof(string), doorString, va_start<3>);

	PlayerTextDrawSetString(playerid, PlayerText:TextDrawSmallInfo[playerid], string);
	PlayerTextDrawAlignment(playerid, PlayerText:TextDrawSmallInfo[playerid], 2);
	
	PlayerTextDrawShow(playerid, PlayerText:TextDrawSmallInfo[playerid]);
	PlayerCache[playerid][pSmallTextTime] = showTime;
	return 1;
}

stock TD_HideDoor(playerid)
{
	PlayerTextDrawHide(playerid, PlayerText:TextDrawSmallInfo[playerid]);
	PlayerCache[playerid][pSmallTextTime] = 0;
	return 1;
}

stock TD_CreateForPlayer(playerid)
{
	// TextDraw informacyjny (small)
	TextDrawSmallInfo[playerid] = CreatePlayerTextDraw(playerid, 450.000000, 360.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, TextDrawSmallInfo[playerid], 255);
	PlayerTextDrawFont(playerid, TextDrawSmallInfo[playerid], 1);
	PlayerTextDrawLetterSize(playerid, TextDrawSmallInfo[playerid], 0.200000, 1.000000);
	PlayerTextDrawColor(playerid, TextDrawSmallInfo[playerid], -1);
	PlayerTextDrawSetOutline(playerid, TextDrawSmallInfo[playerid], 0);
	PlayerTextDrawSetProportional(playerid, TextDrawSmallInfo[playerid], 1);
	PlayerTextDrawSetShadow(playerid, TextDrawSmallInfo[playerid], 1);
	PlayerTextDrawUseBox(playerid, TextDrawSmallInfo[playerid], 1);
	PlayerTextDrawBoxColor(playerid, TextDrawSmallInfo[playerid], 85);
	PlayerTextDrawTextSize(playerid, TextDrawSmallInfo[playerid], 614.000000, 140.000000);
	//  *** *** //
	
	// TextDraw grup
    for(new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
    {
		TextDrawGroups[playerid][group_slot] = CreatePlayerTextDraw(playerid, 100.000000, 182.000000 + group_slot * 15 + 1, "_");
		PlayerTextDrawLetterSize(playerid, PlayerText:TextDrawGroups[playerid][group_slot], 0.219999, 1.100000);
		PlayerTextDrawSetOutline(playerid, PlayerText:TextDrawGroups[playerid][group_slot], 1);
		PlayerTextDrawUseBox(playerid, PlayerText:TextDrawGroups[playerid][group_slot], 1);
		PlayerTextDrawBoxColor(playerid, PlayerText:TextDrawGroups[playerid][group_slot], 68);
		PlayerTextDrawTextSize(playerid, PlayerText:TextDrawGroups[playerid][group_slot], 496.000000, 0.000000);
	}
	// ***  *** //
	
	// TextDrawOferty
	TextDrawOfferDesc[playerid] = CreatePlayerTextDraw(playerid, 211.000000, 290.000000, "_");
	PlayerTextDrawLetterSize(playerid, TextDrawOfferDesc[playerid], 0.219999, 0.899999);
	PlayerTextDrawColor(playerid, TextDrawOfferDesc[playerid], -1);
	PlayerTextDrawSetOutline(playerid, TextDrawOfferDesc[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TextDrawOfferDesc[playerid], 1);
	// ***  *** //
	
	// Osi�gni�cia
	TextDrawAchieve[playerid] = CreatePlayerTextDraw(playerid, 498.000000, 101.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, TextDrawAchieve[playerid], 255);
	PlayerTextDrawLetterSize(playerid, TextDrawAchieve[playerid], 0.210000, 1.000000);
	PlayerTextDrawColor(playerid, TextDrawAchieve[playerid], -1);
	PlayerTextDrawSetOutline(playerid, TextDrawAchieve[playerid], 1);
	PlayerTextDrawUseBox(playerid, TextDrawAchieve[playerid], 1);
	PlayerTextDrawBoxColor(playerid, TextDrawAchieve[playerid], 68);
	PlayerTextDrawTextSize(playerid, TextDrawAchieve[playerid], 606.000000, 170.000000);
	// ***  *** //
	
	// ***	TextDraw informacyjny (large)   *** //
	TextDrawLargeInfo[playerid][0] = CreatePlayerTextDraw(playerid, 0.000000, 337.000000, "_");
	PlayerTextDrawLetterSize(playerid, TextDrawLargeInfo[playerid][0], 0.300000, 12.300001);
	PlayerTextDrawUseBox(playerid, TextDrawLargeInfo[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, TextDrawLargeInfo[playerid][0], -1715157214);
	PlayerTextDrawTextSize(playerid, TextDrawLargeInfo[playerid][0], 640.000000, 600.000000);
	
	TextDrawLargeInfo[playerid][1] = CreatePlayerTextDraw(playerid, 150.000000, 350.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, TextDrawLargeInfo[playerid][1], 255);
	PlayerTextDrawFont(playerid, TextDrawLargeInfo[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, TextDrawLargeInfo[playerid][1], 0.339999, 1.200000);
	PlayerTextDrawColor(playerid, TextDrawLargeInfo[playerid][1], -1);
	PlayerTextDrawSetOutline(playerid, TextDrawLargeInfo[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, TextDrawLargeInfo[playerid][1], 1);
	// ***  *** //
	
	// ***  TextDraw CB Radio   *** //
	TextDrawRadioCB[playerid] = CreatePlayerTextDraw(playerid, 499.000000, 98.799987, "_");
	PlayerTextDrawBackgroundColor(playerid, TextDrawRadioCB[playerid], 255);
	PlayerTextDrawFont(playerid, TextDrawRadioCB[playerid], 3);
	PlayerTextDrawLetterSize(playerid, TextDrawRadioCB[playerid], 0.300000, 1.000000);
	PlayerTextDrawColor(playerid, TextDrawRadioCB[playerid], -2925313);
	PlayerTextDrawSetOutline(playerid, TextDrawRadioCB[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TextDrawRadioCB[playerid], 1);
	// ***  *** //
	
	// ***  TextDraw s�u�by grupy   *** //
	TextDrawDuty[playerid] = CreatePlayerTextDraw(playerid, 7.000000, 424.800000, "_");
	PlayerTextDrawBackgroundColor(playerid, TextDrawDuty[playerid], COLOR_WHITE);
	PlayerTextDrawLetterSize(playerid, TextDrawDuty[playerid], 0.300000, 1.000000);
	PlayerTextDrawColor(playerid, TextDrawDuty[playerid], -1);
	PlayerTextDrawSetOutline(playerid, TextDrawDuty[playerid], 1);
	// ***  *** //
	return 1;
}

stock HidePlayerGroups(playerid)
{
	TextDrawHideForPlayer(playerid, Text:TextDrawGroupsTitle);
	for (new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
	{
	    PlayerTextDrawSetString(playerid, PlayerText:TextDrawGroups[playerid][group_slot], "_");
		PlayerTextDrawHide(playerid, PlayerText:TextDrawGroups[playerid][group_slot]);
		
		for(new option_id = 0; option_id < 5; option_id++)
		{
			TextDrawHideForPlayer(playerid, Text:TextDrawGroupOption[group_slot][option_id]);
		}
	}
	CancelSelectTextDraw(playerid);
	return 1;
}

stock GetGroupID(group_uid)
{
	new group_id = INVALID_GROUP_ID;
	foreach(new i : Groups)
	{
	    if(GroupData[i][gUID] == group_uid)
	    {
			group_id = i;
			break;
	    }
	}
	return group_id;
}

stock GetPlayerGroupID(playerid, group_uid)
{
	new group_id = INVALID_GROUP_ID;
	for (new slot = 0; slot < MAX_GROUP_SLOTS; slot++)
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
	for (new slot = 0; slot < MAX_GROUP_SLOTS; slot++)
	{
	    if(PlayerGroup[playerid][slot][gpUID] == group_uid)
	    {
	        return true;
	    }
	}
	return false;
}

stock GetPlayerGroupSlot(playerid, group_uid)
{
	new group_slot = INVALID_SLOT_ID;
	for (new slot = 0; slot < MAX_GROUP_SLOTS; slot++)
	{
	    if(PlayerGroup[playerid][slot][gpUID])
	    {
		    if(PlayerGroup[playerid][slot][gpUID] == group_uid)
		    {
	     		group_slot = slot;
	     		break;
		    }
		}
	}
	return group_slot;
}

stock GetPlayerFreeGroupSlot(playerid)
{
	new group_slot = INVALID_SLOT_ID;
	for (new slot = 0; slot < MAX_GROUP_SLOTS; slot++)
	{
	    if(!PlayerGroup[playerid][slot][gpUID])
	    {
     		group_slot = slot;
     		break;
	    }
	}
	return group_slot;
}

stock IsPlayerInGroupType(playerid, type)
{
	new group_id;
	for (new slot = 0; slot < MAX_GROUP_SLOTS; slot++)
	{
	    if(PlayerGroup[playerid][slot][gpUID])
	    {
	        group_id = PlayerGroup[playerid][slot][gpID];
	        if(GroupData[group_id][gType] == type)
	        {
	        	return true;
			}
	    }
	}
	return false;
}

stock IsPlayerInAnyGroup(playerid)
{
	for (new slot = 0; slot < MAX_GROUP_SLOTS; slot++)
	{
	    if(PlayerGroup[playerid][slot][gpUID])
	    {
    		return true;
	    }
	}
	return false;
}

stock HavePlayerGroupPerm(playerid, group_uid, permission)
{
	new group_id;
	for (new group_slot = 0; group_slot < MAX_GROUP_SLOTS; group_slot++)
	{
	    if((PlayerGroup[playerid][group_slot][gpPerm] & permission))
	    {
		    if(PlayerGroup[playerid][group_slot][gpUID] == group_uid)
		    {
				return true;
			}
			else
			{
			    group_id = GetGroupID(group_uid);
			    if(GroupData[group_id][gOwner] == PlayerGroup[playerid][group_slot][gpUID])
			    {
			        return true;
			    }
			}
		}
	}
	return false;
}

stock GetVehicleID(veh_uid)
{
	new vehid = INVALID_VEHICLE_ID;
	foreach(new car : Vehicles)
	{
		if(CarInfo[car][cUID] == veh_uid)
		{
			vehid = car;
			break;
		}
	}
	return vehid;
}

stock GetClosestVehicle(playerid)
{
	new Float:dist, Float:prevdist = 5.000,
		prevcar = INVALID_VEHICLE_ID;
		
	foreach(new carid : Vehicles)
	{
		dist = GetDistanceToVehicle(playerid, carid);
		if ((dist < prevdist))
		{
			prevdist = dist;
			prevcar = carid;
		}
	}
	return prevcar;
}

stock GetDistanceToVehicle(playerid, carid)
{
	new Float:x1, Float:y1, Float:z1,
		Float:x2, Float:y2, Float:z2, Float:dis;

	GetPlayerPos(playerid, x1, y1, z1);
	GetVehiclePos(carid, x2, y2, z2);

	dis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
	return floatround(dis);
}


stock IsAnyPlayerInVehicle(vehicleid)
{
	foreach(new i : Player)
	{
	    if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
	    {
			if(GetPlayerVehicleID(i) == vehicleid)
			{
				return true;
			}
		}
	}
	return false;
}

stock GetFreeVehicleSeat(vehicleid)
{
    new bool: vehicleSeatStatus[4];
    foreach(new i : Player)
    {
        if(PlayerCache[i][pLogged] && PlayerCache[i][pSpawned])
        {
	        if(GetPlayerVehicleID(i) == vehicleid)
	        {
	            vehicleSeatStatus[GetPlayerVehicleSeat(i)] = false;
	        }
		}
    }

    for(new i = 0; i < 4; i++)
    {
        if(vehicleSeatStatus[i] == true)
        {
            return i;
        }
    }

    return INVALID_VEHICLE_ID;
}

stock GetPlayerSpawnedVehicles(playerid)
{
	new vehicles;
	foreach(new i : Vehicles)
	{
	    if(CarInfo[i][cOwnerType] == OWNER_PLAYER && CarInfo[i][cOwner] == PlayerCache[playerid][pUID])
	    {
	        vehicles ++;
	    }
	}
	return vehicles;
}

stock IsPlayerFacingVehicle(playerid, vehicleid)
{
	new Float:plPosX, Float:plPosZ, Float:plPosY, Float:vePosX, Float:vePosY, Float:vePosZ, Float:MainAngle;

	GetVehiclePos(vehicleid, vePosX, vePosY, vePosZ);
	GetPlayerPos(playerid, plPosX, plPosY, plPosZ);

	if( vePosY > plPosY ) MainAngle = (-acos((vePosX - plPosX) / floatsqroot((vePosX - plPosX) * (vePosX - plPosX) + (vePosY - plPosY) * (vePosY - plPosY))) - 90.0);
	else if( vePosY < plPosY && vePosX < plPosX ) MainAngle = (acos((vePosX - plPosX) / floatsqroot((vePosX - plPosX) * (vePosX - plPosX) + (vePosY - plPosY) * (vePosY - plPosY))) - 450.0);
	else if( vePosY < plPosY ) MainAngle = (acos((vePosX - plPosX) / floatsqroot((vePosX - plPosX) * (vePosX - plPosX) + (vePosY - plPosY) * (vePosY - plPosY))) - 90.0);

	if(vePosX > plPosX) MainAngle = (floatabs(floatabs(MainAngle) + 180.0));
	else MainAngle = (floatabs(MainAngle) - 180.0);

	new Float:plAngle;
	GetPlayerFacingAngle(playerid, plAngle);

	if(MainAngle - plAngle < -130 || MainAngle - plAngle > 130)
	{
		return 0;
	}
	return 1;
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

stock crp_AddVehicleComponent(vehicleid, componentid)
{
	new slot = GetVehicleComponentType(componentid);
	if(slot != -1)
	{
	    AddVehicleComponent(vehicleid, componentid);
	    CarInfo[vehicleid][cComponent][slot] = componentid - 999;
	}
	return 1;
}

stock crp_RemoveVehicleComponent(vehicleid, componentid)
{
	new slot = GetVehicleComponentType(componentid);
	if(slot != 1)
	{
	    RemoveVehicleComponent(vehicleid, componentid);
	    CarInfo[vehicleid][cComponent][slot] = 0;
	}
	return 1;
}

stock GetVehicleRotation(vehicleid, &Float: heading,  &Float: attitude,  &Float: bank)
{
    new
		Float: quat_w,
		Float: quat_x,
		Float: quat_y,
		Float: quat_z;

    GetVehicleRotationQuat(vehicleid, quat_w, quat_x, quat_y, quat_z);
    ConvertNonNormaQuatToEuler(quat_w, quat_x, quat_z, quat_y,  heading,  attitude,  bank);

	bank = -1 * bank;
    return 1;
}

stock SetPlayerVehicleRadioCanal(playerid, vehicleid, radio_canal)
{
	new string[64];
	CarInfo[vehicleid][cRadioCanal] = radio_canal;
	
	format(string, sizeof(string), "CB radio: (%d) hz", radio_canal);
	PlayerTextDrawSetString(playerid, TextDrawRadioCB[playerid], string);
	
	PlayerTextDrawShow(playerid, TextDrawRadioCB[playerid]);
	return 1;
}

stock IsVehiclePlaceFree(vehid)
{
	new Float:VehPosX, Float:VehPosY, Float:VehPosZ, bool: IsFree = true;
 	GetVehiclePos(vehid, VehPosX, VehPosY, VehPosZ);

  	mysql_query_format("SELECT vehicle_uid FROM `"SQL_PREF"vehicles` WHERE vehicle_posx < %f + 4 AND vehicle_posx > %f - 4 AND vehicle_posy < %f + 4 AND vehicle_posy > %f - 4 AND vehicle_posz < %f + 4 AND vehicle_posz > %f - 4 LIMIT 1", VehPosX, VehPosX, VehPosY, VehPosY, VehPosZ, VehPosZ);

    mysql_store_result();
    if(mysql_num_rows())
    {
    	IsFree = false;
    }
    mysql_free_result();
	return IsFree;

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

stock GetPlayerSpeed(playerid, get3d)
{
	new Float:PosX, Float:PosY, Float:PosZ;
	if(IsPlayerInAnyVehicle(playerid))
	{
	    new vehid = GetPlayerVehicleID(playerid);
		GetVehicleVelocity(vehid, PosX, PosY, PosZ);
	}
	else
	{
		GetPlayerVelocity(playerid, PosX, PosY, PosZ);
	}
	return floatround(floatsqroot((get3d)?(PosX * PosX + PosY * PosY + PosZ * PosZ):(PosX * PosX + PosY * PosY)) * 100.0 * 1.6);
}

stock SetPlayerSpeed(playerid, Float:speed)
{
    new Float:x1, Float:y1, Float:z1, Float:x2,
		Float:y2, Float:z2, Float:a;

	if(IsPlayerInAnyVehicle(playerid))
	{
	    new vehid = GetPlayerVehicleID(playerid);
	    
	    GetVehicleVelocity(vehid, x1, y1, z1);
	    GetVehiclePos(vehid, x2, y2, z2);
	    
	    GetVehicleZAngle(vehid, a);
	    a = 360 - a;
	    
     	x1 = (floatsin(a, degrees) * (speed / 100) + floatcos(a, degrees) * 0 + x2) - x2;
    	y1 = (floatcos(a, degrees) * (speed / 100) + floatsin(a, degrees) * 0 + y2) - y2;
    	
    	SetVehicleVelocity(vehid, x1, y1, z1);
	}
	else
	{
	    GetPlayerVelocity(playerid, x1, y1, z1);
	    GetPlayerPos(playerid, x2, y2, z2);
	    
	    GetPlayerFacingAngle(playerid, a);
	    a = 360 - a;
	    
    	x1 = (floatsin(a, degrees) * (speed / 100) + floatcos(a, degrees) * 0 + x2) - x2;
    	y1 = (floatcos(a, degrees) * (speed / 100) + floatsin(a, degrees) * 0 + y2) - y2;
    	
    	SetPlayerVelocity(playerid, x1, y1, z1);
	}
	return 1;
}

stock IsVehicleBike(vehid)
{
	new model = GetVehicleModel(vehid);
	if(model == 509 || model == 510 || model == 481)
	{
	    return true;
	}
	return false;
}

stock GetDoorID(door_uid)
{
	new doorid = INVALID_DOOR_ID;
	foreach(new d : Door)
	{
	    if(DoorCache[d][dUID] == door_uid)
	    {
	        doorid = d;
			break;
	    }
	}
	return doorid;
}

stock GetClosestDoor(playerid)
{
	new Float:prevdist = 5.000, prevdoor = INVALID_DOOR_ID;
	foreach(new doorid : Door)
	{
		new Float:dist = GetDistanceToDoor(playerid, doorid);
		if ((dist < prevdist))
		{
			prevdist = dist;
			prevdoor = doorid;
		}
	}
	return prevdoor;
}

stock GetDistanceToDoor(playerid, doorid)
{
	new Float:x1, Float:y1, Float:z1,
		Float:x2, Float:y2, Float:z2, Float:dis;

	GetPlayerPos(playerid, x1, y1, z1);
	
	x2 = DoorCache[doorid][dEnterX];
	y2 = DoorCache[doorid][dEnterY];
	z2 = DoorCache[doorid][dEnterZ];

	dis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
	return floatround(dis);
}

stock GetPlayerDoorID(playerid)
{
	new doorid = INVALID_DOOR_ID;
	foreach(new d : Door)
	{
		if(GetPlayerVirtualWorld(playerid) != 0 && GetPlayerVirtualWorld(playerid) == DoorCache[d][dExitVW])
		{
			doorid = d;
			break;
		}
	}
	return doorid;
}

stock WordWrap(givenString[128], wrap_type)
{
	new editingString[128], spaceCounter = 0;
	memcpy(editingString, givenString, 0, 128 * 4);

	switch(wrap_type)
	{
	    // Automatyczne
	    case WRAP_AUTO:
	    {
    		for (new i = 0; editingString[i] != 0; i++)
			{
			    if(editingString[i] == ',' || editingString[i] == '.')
			    {
					if(editingString[i+1] != ' ')
					{
						strins(editingString, " ", i + 1);
					}
				}

			    if(editingString[i] == ' ' && editingString[i+1] != ' ')
				{
					spaceCounter++;
				}

			    if(spaceCounter >= 5)
				{
					editingString[i] = '\n';
					spaceCounter = 0;
			 	}
			}
	    }
	    // Manualne
	    case WRAP_MANUAL:
	    {
    		for (new i = 0; editingString[i] != 0; i++)
			{
				if(editingString[i] == '(' && editingString[i + 7] == ')')
				{
				    editingString[i] = '{';
					editingString[i + 7] = '}';
				}

			    if(editingString[i] == ',' || editingString[i] == '.')
			    {
					if(editingString[i+1] != ' ')
					{
						strins(editingString, " ", i + 1);
					}
				}

			    if(editingString[i] == '|')
				{
					editingString[i] = '\n';
			 	}
			}
	    }
	}
	return editingString;
}

stock FormatTextDrawColors(givenString[])
{
    new pos, editingString[128];
    memcpy(editingString, givenString, 0, 128 * 4);

    pos = strfind(editingString, "[w]", true);
    while(pos != -1)
    {
        strdel(editingString, pos, pos + 3);
        strins(editingString, "~w~", pos);

        pos = strfind(editingString, "[w]", true, pos + 3);
    }

    pos = strfind(editingString, "[b]", true);
    while(pos != -1)
    {
        strdel(editingString, pos, pos + 3);
        strins(editingString, "~b~", pos);

        pos = strfind(editingString, "[b]", true, pos + 3);
    }

    pos = strfind(editingString, "[g]", true);
    while(pos != -1)
    {
        strdel(editingString, pos, pos + 3);
        strins(editingString, "~g~", pos);

        pos = strfind(editingString, "[g]", true, pos + 3);
    }

    pos = strfind(editingString, "[r]", true);
    while(pos != -1)
    {
        strdel(editingString, pos, pos + 3);
        strins(editingString, "~r~", pos);

        pos = strfind(editingString, "[r]", true, pos + 3);
    }

    pos = strfind(editingString, "[p]", true);
    while(pos != -1)
    {
        strdel(editingString, pos, pos + 3);
        strins(editingString, "~p~", pos);

        pos = strfind(editingString, "[p]", true, pos + 3);
    }

    pos = strfind(editingString, "[y]", true);
    while(pos != -1)
    {
        strdel(editingString, pos, pos + 3);
        strins(editingString, "~y~", pos);

        pos = strfind(editingString, "[y]", true, pos + 3);
    }

    pos = strfind(editingString, "[h]", true);
    while(pos != -1)
    {
        strdel(editingString, pos, pos + 3);
        strins(editingString, "~h~", pos);

        pos = strfind(editingString, "[h]", true, pos + 3);
    }
    return editingString;
}

stock ColorFade(color, value, maxvalue)
{
    if (0 <= value <= maxvalue)
    {
        new
            Float: ratio = float (value) / float (maxvalue);
        new
            r = max (0, min (255, floatround (float ((color >> 24) & 0xFF) * ratio))),
            g = max (0, min (255, floatround (float ((color >> 16) & 0xFF) * ratio))),
            b = max (0, min (255, floatround (float ((color >> 8) & 0xFF) * ratio)));
        return (r << 24) | (g << 16) | (b << 8) | (value & 0xFF);
    }
    return 0;
}

stock EscapePL(name[])
{
    for(new i = 0; name[i] != 0; i++)
    {
	    if(name[i] == '�') name[i] = 's';
	    else if(name[i] == '�') name[i] = 'e';
	    else if(name[i] == '�') name[i] = 'o';
	    else if(name[i] == '�') name[i] = 'a';
	    else if(name[i] == '�') name[i] = 'l';
	    else if(name[i] == '�') name[i] = 'z';
	    else if(name[i] == '�') name[i] = 'z';
	    else if(name[i] == '�') name[i] = 'c';
	    else if(name[i] == '�') name[i] = 'n';
	    else if(name[i] == '�') name[i] = 'S';
	    else if(name[i] == '�') name[i] = 'E';
	    else if(name[i] == '�') name[i] = 'O';
	    else if(name[i] == '�') name[i] = 'A';
	    else if(name[i] == '�') name[i] = 'L';
	    else if(name[i] == '�') name[i] = 'Z';
	    else if(name[i] == '�') name[i] = 'Z';
	    else if(name[i] == '�') name[i] = 'C';
	    else if(name[i] == '�') name[i] = 'N';
    }
}

stock GetItemID(item_uid)
{
	new itemid = INVALID_ITEM_ID;
  	foreach(new i : Item)
	{
	    if(ItemCache[i][iUID] == item_uid)
	    {
	        itemid = i;
	        break;
	    }
	}
	return itemid;
}

stock GetPhoneItemID(phone_number)
{
	new itemid = INVALID_ITEM_ID;
	foreach(new i : Item)
	{
	    if(ItemCache[i][iType] == ITEM_PHONE)
	    {
	        if(ItemCache[i][iUsed])
	        {
		        if(ItemCache[i][iValue1] == phone_number)
		        {
			        itemid = i;
			        break;
				}
			}
	    }
	}
	return itemid;
}

stock ClearItemCache(itemid)
{
	ItemCache[itemid][iUID] 	= 0;

	ItemCache[itemid][iValue1] 	= 0;
	ItemCache[itemid][iValue2] 	= 0;

	ItemCache[itemid][iType] 	= 0;

	ItemCache[itemid][iPlace] 	= 0;
	ItemCache[itemid][iOwner] 	= 0;
	
	ItemCache[itemid][iUsed] 	= false;
	Iter_Remove(Item, itemid);
	return 1;
}

stock GetItemWeight(itemid)
{
	new item_weight = 0,
	    item_value1 = ItemCache[itemid][iValue1], item_type = ItemCache[itemid][iType];
	    
	switch(item_type)
	{
	    case ITEM_WEAPON, ITEM_PAINT, ITEM_INHIBITOR:
	    {
	        item_weight = WeaponInfoData[item_value1][wWeight];
	    }
	    case ITEM_BAG:
	    {
	        item_weight = ItemTypeInfo[item_type][iTypeWeight] + item_value1;
	    }
	    case ITEM_CANISTER:
	    {
	        item_weight = ItemTypeInfo[item_type][iTypeWeight] + item_value1 * 800;
	    }
	    default:
	    {
	        item_weight = ItemTypeInfo[ItemCache[itemid][iType]][iTypeWeight];
	    }
	}
	return item_weight;
}

stock HavePlayerItemType(playerid, item_type)
{
	foreach(new itemid : Item)
	{
	    if(ItemCache[itemid][iUID])
	    {
	        if(ItemCache[itemid][iPlace] == PLACE_PLAYER && ItemCache[itemid][iOwner] == PlayerCache[playerid][pUID])
	        {
	            if(ItemCache[itemid][iType] == item_type)
	            {
	                return true;
	            }
	        }
	    }
	}
	return false;
}

stock HavePlayerVehicleKeys(playerid, vehid)
{
	foreach(new itemid : Item)
	{
	    if(ItemCache[itemid][iUID])
	    {
	        if(ItemCache[itemid][iPlace] == PLACE_PLAYER && ItemCache[itemid][iOwner] == PlayerCache[playerid][pUID])
	        {
	            if(ItemCache[itemid][iType] == ITEM_KEYS)
	            {
	                if(ItemCache[itemid][iValue1] == CarInfo[vehid][cUID])
					{
	                	return true;
					}
	            }
	        }
	    }
	}
	return false;
}

stock GetPlayerCapacity(playerid)
{
	new capacity = PlayerCache[playerid][pStrength] * 2;
	foreach(new itemid : Item)
	{
	    if(ItemCache[itemid][iUID])
	    {
     		if(ItemCache[itemid][iPlace] == PLACE_PLAYER && ItemCache[itemid][iOwner] == PlayerCache[playerid][pUID])
       		{
				capacity -= GetItemWeight(itemid);

				if(capacity <= 0)
				{
				    capacity = 0;
				    break;
				}
       		}
	    }
	}
	return capacity;
}

stock GetPlayerWeaponAmmo(playerid, weaponid)
{
	new ammo, weapons[13][2];
	for (new i = 0; i < 13; i++)
	{
		GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
		if(weapons[i][0] == weaponid)
		{
			ammo = weapons[i][1];
		}
	}
	return ammo;
}

stock GetPlayerWeaponID(playerid)
{
	new weapon_id = GetPlayerWeapon(playerid);
	/*
	if(IsPlayerInAnyVehicle(playerid))
	{
	    new weapons[13][2];
		for (new i = 0; i < 13; i++)
		{
			GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
			if(weapons[i][0] && weapons[i][1])
			{
	   		    weapon_id = weapons[i][0];
			}
		}
	}
	else
	{
	    weapon_id = GetPlayerWeapon(playerid);
	}
	*/
	return weapon_id;
}

stock GetPlayerWeaponSlot(playerid, weaponid)
{
	new slotid, weapons[13][2];
	for (new i = 0; i < 13; i++)
	{
		GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
		if(weapons[i][0] == weaponid)
		{
   			slotid = i;
		}
	}
	return slotid;
}

stock HavePlayerAnyWeapon(playerid)
{
	new weapons[13][2];
	for (new i = 0; i < 13; i++)
	{
		GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
		if(weapons[i][0])
		{
		    return true;
		}
	}
	return false;
}

stock GetWeaponType(weaponid)
{
	switch(weaponid)
 	{
  		case 22, 23, 24, 26, 28, 32:
    		return WEAPON_TYPE_LIGHT;

		case 3, 4, 16, 17, 18, 39, 10, 11, 12, 13, 14, 40, 41:
  			return WEAPON_TYPE_MELEE;

		case 2, 6, 7, 8, 9, 25, 27, 29, 30, 31, 33, 34, 35, 36, 37, 38:
  			return WEAPON_TYPE_HEAVY;
	}
	return WEAPON_TYPE_NONE;
}

stock ResetPlayerWeaponsEx(playerid)
{
	for (new i = 0; i < 13; i++)	SetPlayerAmmo(playerid, i, 0);
	ResetPlayerWeapons(playerid);
	return 1;
}

stock IsPlayerAiming(playerid)
{
	new anim = GetPlayerAnimationIndex(playerid);
	if (((anim >= 1160) && (anim <= 1163)) || (anim == 1167) || (anim == 1365) || (anim == 1643) || (anim == 1453) || (anim == 220))
	{
		return true;
	}
 	return false;
}

stock GetAreaID(area_uid)
{
	new areaid = INVALID_AREA_ID;
	foreach(new i : Area)
	{
	    if(AreaCache[i][aUID] == area_uid)
	    {
	        areaid = i;
	        break;
	    }
	}
	return areaid;
}

stock GetPlayerAreaID(playerid)
{
	new areaid = INVALID_AREA_ID;
	foreach(new i : Area)
	{
	    if(AreaCache[i][aUID])
	    {
	        if(IsPlayerInDynamicArea(playerid, i))
	        {
				areaid = i;
				break;
	        }
	    }
	}
	return areaid;
}

stock GetProductID(product_uid)
{
	new product_id = INVALID_PRODUCT_ID;
	foreach(new i : Product)
	{
	    if(ProductData[i][pUID] == product_uid)
	    {
	        product_id = i;
	        break;
	    }
	}
	return product_id;
}

stock GetPlayerDistanceToPoint(playerid, Float:x, Float:y)
{
	new Float:PosX, Float:PosY, Float:PosZ, Float:dis;
	
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	dis = floatsqroot(floatpower(floatabs(floatsub(PosX, x)), 2) + floatpower(floatabs(floatsub(PosY, y)), 2));
	
	return floatround(dis);
}

stock ResetDynamicObjectPos(object_id)
{
	new Float:ObjPosX, Float:ObjPosY, Float:ObjPosZ,
	    Float:ObjRotX, Float:ObjRotY, Float:ObjRotZ;
	    
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_X, ObjPosX);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_Y, ObjPosY);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_Z, ObjPosZ);
	
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_R_X, ObjRotX);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_R_Y, ObjRotY);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_R_Z, ObjRotZ);
	
	SetDynamicObjectPos(object_id, ObjPosX, ObjPosY, ObjPosZ);
	SetDynamicObjectRot(object_id, ObjRotX, ObjRotY, ObjRotZ);
	return 1;
}

stock GetClosestObjectType(playerid, object_model)
{
	new count_objects = Streamer_CountVisibleItems(playerid, STREAMER_TYPE_OBJECT), object_id,
	    Float:prevdist = 5.0, ObjectID = INVALID_OBJECT_ID, Float:PosX, Float:PosY, Float:PosZ, Float:dist;
	    
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	for (new player_object = 0; player_object <= count_objects; player_object++)
	{
	    if(IsValidPlayerObject(playerid, player_object))
	    {
	        object_id = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, player_object);
         	if(GetObjectModel(object_id) == object_model)
          	{
				Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_OBJECT, object_id, dist);
				if((dist < prevdist))
				{
		   			prevdist = dist;
					ObjectID = object_id;
				}
	        }
	    }
	}
	return ObjectID;
}

stock GetObjectID(object_uid)
{
	new object_counts = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT);
	for (new object_id = 0; object_id <= object_counts; object_id++)
	{
	    if(IsValidDynamicObject(object_id))
	    {
		    if(Streamer_GetIntData(STREAMER_TYPE_OBJECT, object_id, E_STREAMER_EXTRA_ID) == object_uid)
		    {
		        return object_id;
		    }
		}
	}
	return INVALID_OBJECT_ID;
}

stock GetXYInFrontOfObject(object_id, &Float:x, &Float:y, Float:distance)
{
 	new Float:z,
 	    Float:rotx, Float:roty, Float:rotz;

 	GetDynamicObjectPos(object_id, x, y, z);
	GetDynamicObjectRot(object_id, rotx, roty, rotz);

 	x -= (distance * floatsin(-rotz, degrees));
 	y -= (distance * floatcos(-rotz, degrees));
}

stock GetXYBehindOfObject(object_id, &Float:x, &Float:y, Float:distance)
{
 	new Float:z,
 	    Float:rotx, Float:roty, Float:rotz;

 	GetDynamicObjectPos(object_id, x, y, z);
	GetDynamicObjectRot(object_id, rotx, roty, rotz);

 	x += (distance * floatsin(-rotz, degrees));
 	y += (distance * floatcos(-rotz, degrees));
}

stock IsPlayerFacingObject(playerid, objectid)
{
	new Float:plPosX, Float:plPosZ, Float:plPosY,
		Float:obPosX, Float:obPosY, Float:obPosZ, Float:MainAngle;

	GetDynamicObjectPos(objectid, obPosX, obPosY, obPosZ);
	GetPlayerPos(playerid, plPosX, plPosY, plPosZ);

	if( obPosY > plPosY ) MainAngle = (-acos((obPosX - plPosX) / floatsqroot((obPosX - plPosX) * (obPosX - plPosX) + (obPosY - plPosY) * (obPosY - plPosY))) - 90.0);
	else if( obPosY < plPosY && obPosX < plPosX ) MainAngle = (acos((obPosX - plPosX) / floatsqroot((obPosX - plPosX) * (obPosX - plPosX) + (obPosY - plPosY) * (obPosY - plPosY))) - 450.0);
	else if( obPosY < plPosY ) MainAngle = (acos((obPosX - plPosX) / floatsqroot((obPosX - plPosX) * (obPosX - plPosX) + (obPosY - plPosY) * (obPosY - plPosY))) - 90.0);

	if(obPosX > plPosX) MainAngle = (floatabs(floatabs(MainAngle) + 180.0));
	else MainAngle = (floatabs(MainAngle) - 180.0);

	new Float:plAngle;
	GetPlayerFacingAngle(playerid, plAngle);

	if(MainAngle - plAngle < -130 || MainAngle - plAngle > 130)
	{
		return 0;
	}
	return 1;
}

stock GetDynamicObjectGatePos(objectid, &Float:gX, &Float:gY, &Float:gZ, &Float:gRX, &Float:gRY, &Float:gRZ)
{
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_GATE_X, gX);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_GATE_Y, gY);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_GATE_Z, gZ);
    
   	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_GATE_RX, gRX);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_GATE_RY, gRY);
    Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_GATE_RZ, gRZ);
    
	return (gX == 0 && gY == 0 && gZ == 0) ? false : true;
}

stock GetClosestLabel(playerid)
{
	new Float:prevdist = 5.0, LabelID = INVALID_3DTEXT_ID, count_labels = CountDynamic3DTextLabels(),
		visible_items = Streamer_CountVisibleItems(playerid, STREAMER_TYPE_3D_TEXT_LABEL), Float:PosX, Float:PosY, Float:PosZ, Float:dist;
		
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	
	for (new label_id = 0; label_id <= count_labels; label_id++)
	{
 		if(IsValidDynamic3DTextLabel(Text3D:label_id))
	    {
	 		if(Streamer_IsItemVisible(playerid, STREAMER_TYPE_3D_TEXT_LABEL, label_id))
	        {
	            if(Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_ATTACHED_PLAYER) == INVALID_PLAYER_ID && Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL, label_id, E_STREAMER_ATTACHED_VEHICLE) == INVALID_VEHICLE_ID)
	            {
					visible_items --;
					Streamer_GetDistanceToItem(PosX, PosY, PosZ, STREAMER_TYPE_3D_TEXT_LABEL, label_id, dist);

					if((dist < prevdist))
					{
		   				prevdist = dist;
						LabelID = label_id;
					}

		   			if(visible_items <= 0)
		            {
		                break;
		            }
				}
			}
		}
	}
	return LabelID;
}

stock GetClosestBusStop(playerid)
{
    new ObjectID = INVALID_OBJECT_ID, Float:BusStopDistance, Float:LastDistance = 500.0,
        object_counts = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT);
        
	for (new object_id = 0; object_id <= object_counts; object_id++)
	{
		if(IsValidDynamicObject(object_id))
		{
			if(GetObjectModel(object_id) == OBJECT_BUSSTOP)
			{
				if(object_id != PlayerCache[playerid][pBusStart])
			 	{
					Streamer_GetDistanceToItem(PlayerCache[playerid][pBusPosition][0], PlayerCache[playerid][pBusPosition][1], PlayerCache[playerid][pBusPosition][2], STREAMER_TYPE_OBJECT, object_id, BusStopDistance);

					if((BusStopDistance < LastDistance))
					{
						LastDistance = BusStopDistance;
						ObjectID = object_id;
					}
				}
			}
		}
	}
	return ObjectID;
}

stock IsValidObjectModel(model)
{
	static
		valid_model[] = //credits to Slice
		{
			0b11111111111011111110110111111110, 0b00000000001111111111111111111111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111111111111110000000,
			0b11100001001111111111111111111111, 0b11110111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000001111000000111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111100011111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111011111, 0b11111111111111111111111101111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111100000000000001111111111,
			0b11111111111111111111111111111111, 0b11111111111010111101111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111001111111111111,
			0b11111111111111111111111111111111, 0b10000000000011111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111011111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111101011101111111111, 0b11111111111111111111111111110111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111110011,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111100111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111011110111101111,
			0b10000000000000000000000000000000, 0b00000010000010000000010011111111,
			0b00000000001000000100000000000000, 0b11111111101101100101111000000000,
			0b01110000111111111111111111111011, 0b00000000001111111111111111000000,
			0b10011111110000000000001111001100, 0b11111111101111001100000000011110,
			0b00001110110111111100111111111111, 0b11111111111111111111111111001110,
			0b11111000000011111111111111111111, 0b11111111111111111110111101101011,
			0b01000000000000000111111101110111, 0b11010111111111111111000001111100,
			0b11110011111111111111111001111111, 0b01011111111111111111111111111111,
			0b01111110100001111011111010101011, 0b10001001010101100100001000010000,
			0b10100000000000000001010000101010, 0b00001000001111101010111100100000,
			0b11111111111111111111111010100001, 0b00000000011111111111110101111111,
			0b00001111111111111111110000111100, 0b11011110111111001111011011111011,
			0b11111111111001111111110011001110, 0b11111111111111111111111111111111,
			0b01111111111111111111111110111111, 0b01111000111111111111110111111111,
			0b00011100000000010000000000000111, 0b00001111111100001000000000000000,
			0b10101111001001110111110011111000, 0b01010101010101010110100000101011,
			0b01110111110101011111110100101001, 0b01111111111100101110111011111011,
			0b11111111111111111100101111001000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000000011111111111111111111111, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111000000000000000000000000, 0b00010100101000001111111111111111,
			0b11111111101111011111111111000000, 0b00111111111111111111111100000001,
			0b11110000000000000000000000000000, 0b00000101010101010111111111111111,
			0b11110010110111000011111010000000, 0b11111110111110000111110111010000,
			0b00000000000000011111111111111111, 0b00000000000000000000000000000000,
			0b11111111111111111111111111000000, 0b11111111111111111111111111111111,
			0b11011111111111111111111111111111, 0b00000000000000000000000000000111,
			0b00000000000000000000000000000000, 0b11010111111000000000000000000000,
			0b10110011001000101111111111111111, 0b00011000010111010101011111010111,
			0b11011111111111111111010101111111, 0b11111111111111100000000000000011,
			0b11111111111111111111111111111111, 0b11111111111111111100000101111111,
			0b00000000000000000000000111111111, 0b00011000000001111000000000000000,
			0b11111111111111100111100000000100, 0b11110100011011111111110000000000,
			0b11111110001001111111110000000111, 0b11111111110110000100101010101000,
			0b11111111111111111100000000000000, 0b11111111111111111111111111111111,
			0b11101011111011110011111111111111, 0b11111111111111111111111111111111,
			0b00010001000001111100001111111111, 0b00100000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111101000000000000000000000000,
			0b11110001110101000001111111111111, 0b00000000000001101111010000010010,
			0b11111111111111111111111110000000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11100001111100000111100000000000, 0b11100110011111111101011111111011,
			0b00000000000000000000000100111001, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000100110000101100111111001100,
			0b11111111111110000000000000000000, 0b00000000000001111111111111111111,
			0b11000001111111011100000110000000, 0b00000111111101111111111111111111,
			0b00000000001000011110000111010010, 0b00111000100111110011110000000000,
			0b00111111111110101000001001111110, 0b00000000000000100001111100000000,
			0b11111111111111111111111100000000, 0b01111111111111111111111111111111,
			0b01011100001111111110101111110111, 0b11100010111111100000000000111111,
			0b11011000011000110011100011111001, 0b01100110000011110001100000010000,
			0b00000111100000000000000000000100, 0b00010111111101100011100001101010,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111101111111000000000000000, 0b01111000000111100000000111111111,
			0b00000000011111110111111110111111, 0b11111111111111111111111111111111,
			0b00000000101001101111111111111111, 0b11111111111111111111111111111110,
			0b10100001000000111111111111111111, 0b11111111111111111111111111111011,
			0b00000000000000000000000000000011, 0b00000000000000100000000000000000,
			0b01110001111111010000000000010000, 0b11111101111101100011011111111111,
			0b10000000011111111111110101010111, 0b11011111100000010011001010110111,
			0b11010011101011111111111111111111, 0b10101010000010010000001111111000,
			0b11111000101111100000111110010110, 0b11111111100000000000000000000001,
			0b11111111111111111111111111111111, 0b01111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111101111111111,
			0b11111111111111111111111111111111, 0b00000000000001111111111111111111,
			0b00111000000000010001000000000010, 0b00000000000011100000000000000000,
			0b00000000000000000000100000000000, 0b00000000000000000000000000000000,
			0b11110101000000000000000000000000, 0b00011111111000000101001000000111,
			0b11110000011110100011011101000000, 0b01111110111111111111111111111111,
			0b10101000000111110100101111011100, 0b11111111111111111111110000111010,
			0b00000000000000000000011111111111, 0b11111111111111111111111111111110,
			0b00001000111111111111111111111111, 0b00000000000000000000000000000000,
			0b00001111111110000000001111111101, 0b00111110000001111111101110100000,
			0b00001111111101111100011111000100, 0b11101010111101010011000111110000,
			0b11101010000000000000000111010001, 0b10001110110101100101000001110101,
			0b11000011111010101011111111111111, 0b11010110101111110000000000111111,
			0b00011111111111111111111111010100, 0b11111111111111111111111111111111,
			0b00111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b10000000001111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00000000000000111111111111111111,
			0b00000000000000000000000001000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00011111000000000000000000000000,
			0b00011111111111100111111111111111, 0b00000011111111111111111111111110,
			0b00000000000000000000000000000000, 0b00101100000110000000000000010000,
			0b11100000111110000000001000000000, 0b11111000000000011111111100000000,
			0b11010000111111101011111111111111, 0b11001101010100011100011101000011,
			0b11111111111101010011110011100111, 0b01000000000111111001101111111111,
			0b00000000111010111111110010000111, 0b11111111111000000000001111111111,
			0b11111111111111111111111111111111, 0b11111111111011110111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000000000001100000001111111111, 0b00000000000000000000000000000000,
			0b11100000000000000000000000000000, 0b00000000000000000000000000000001,
			0b11111111111111111111110000010000, 0b00000111111111111111111111111111,
			0b11111111111111111110100000000000, 0b11111111111111111111111110111111,
			0b00000011100001111111111111111111, 0b00000000001100000000000000000000,
			0b01100110001011010000000000000000, 0b11111111111111111111111111111111,
			0b00000111111111111111111111111111, 0b00000000000000000000000011111110,
			0b11111111110100000000000000000000, 0b00000000000000000111111111101011,
			0b01100000000000000000000110011100, 0b11111111111111111111111111101010,
			0b11111100000000000111111111111111, 0b00000000000000000000000001111111,
			0b11101111000000000000000000000000, 0b11111110111111111111111111111111,
			0b11111111111111111111011111111111, 0b11000000001000000000000011011001,
			0b11011111111111111111111111111111, 0b11100000011000000000011111111110,
			0b00000000001111100011111111111111, 0b00011110111111000000000000000000,
			0b11001111111100001001011111110100, 0b00110001110001111000011101011110,
			0b00000000000000000000000001110110, 0b11111111111111111100000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00111111111111111111111111111111,
			0b00000000000000000000000000000000, 0b11000000000000000000000000000000,
			0b00000000000000011111111111111111, 0b11101111111111110100001000000000,
			0b00001010000000001111111111111111, 0b00001100000110011000000000000000,
			0b01010011111111111111111111000000, 0b11000001111111111100000000000100,
			0b11111111111111111111111111111111, 0b11001111110000000000111111111111,
			0b11111111111111111111111111111111, 0b00001111111111111111111111011111,
			0b00000011100000000000111000100000, 0b11111111111111111110000000100000,
			0b11111111111001111111111111111111, 0b11111111111111111111111111111111,
			0b00000000000000000000000011111111, 0b10000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111001111,
			0b00000000000000000111111000001111, 0b00000000000000000000000000000000,
			0b11110111100000000000000000000000, 0b00111111111100001011111111111111,
			0b10110111101010010000000000000000, 0b11010000111111110001011011101010,
			0b10000011100000101101001011010000, 0b11111111111110000100000010111101,
			0b11110011011111110100001100011111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00000000000110011111111111111111,
			0b00001111100000000000000000000000, 0b10000000000000001011111010000000,
			0b11100100000001111000000000000000, 0b00000000000000000000000000000011,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111011,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00001110001111111101111001011011,
			0b00011110011000011100011000111100, 0b11000000001011111111111110010001,
			0b01111111111111111101101111111111, 0b00111111111111111010100001110010,
			0b01111111111000000100000001011000, 0b00000000001110000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000111000000000000000,
			0b01000001000100000011101000000001, 0b11001111100110110000000000111010,
			0b00000000000000000000000000000000, 0b11111000000000000100000000000000,
			0b01000000001000000001111110111111, 0b11111111111011100111000000000000,
			0b11111111111111111111111111111111, 0b00001111111111111111111111111111,
			0b11111111110000000000000000000000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111100001111,
			0b11111111111111111111111111111111, 0b01111111101111011111111111111111,
			0b00100001000000000000000000000010, 0b10110111011001100111011000001000,
			0b00000000001000000000000010000111, 0b10000100000000011000001111100000,
			0b00000000000000000000000000000100, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111111000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11010111111111111111111111111101, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111100000011111111111111111111,
			0b11111111111111111111111111110011, 0b11111111111111111111100011111111,
			0b11111111111111111000000111111111, 0b11111111111111000011111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111110111111111, 0b00000000111101111111111111101111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111100000000000000000,
			0b00000001111111111111111111111111, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111000000011111110111111111, 0b11111111111111111111111111111111,
			0b11111111111111101111111111111111, 0b00000111111111111111111111111111,
			0b00001111111111111111111111111111, 0b01110100111101000100000111110000,
			0b10101000000000000000000000000001, 0b00000000111101000000000000000011,
			0b00000000111111000000000000000000, 0b00001001000111000000000000000000,
			0b00100010100000100000000000000000, 0b11111111111110001100000000100100,
			0b11111111111111111111111111111111, 0b01110000011101100011111001111010,
			0b11111000000000000000000000011110, 0b11000001111101100000111111111111,
			0b00000000011111111111111111101110, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b11111111111111111111111100000000,
			0b11111110001111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b01010111111111111111111111111111,
			0b01010101010101010101010101010101, 0b01010101000101010101010101010101,
			0b01010101010101010101010101010101, 0b10101010101010000101010101010101,
			0b01111010111111111111111111111010, 0b00000000111010101101100000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b10000000000000111100000000000000,
			0b11110000000000000000000000000101, 0b11111111111111111111111011111111,
			0b11111111111111111111111111111111, 0b11111101101101101100111111100001,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b00000000000000000000000000011111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000101011000000000000, 0b01111011000000100000000000100000,
			0b11000011111111010000111111011000, 0b11111011100011110110111001111001,
			0b11001101111111110110000111100111, 0b00000101011110110000000001111110,
			0b11111111111111110000000000000000, 0b11111111110111111111111111111111,
			0b11111111111111111111111111111111, 0b00100011011111111111111111111111,
			0b00000000000000000000000000000001, 0b00000000000000000000000000000000,
			0b11111111000000000000000000000000, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b00000111111111111111111111111111, 0b00000000000000000000000000000000,
			0b11111111111111111111111111111111, 0b00000000001111111111111111111111,
			0b00000000010000000000000000000001, 0b00000011100000000000000000000000,
			0b00000000000000000000001111101010, 0b11111111111111110000000000000000,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b10111111111111111111111111111111, 0b11111111111111111100111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b01111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111110011111111111, 0b11101111111111111111000111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11111111111111111111111111111111, 0b11111111111111111111111111111111,
			0b11110000000001111111111111111111, 0b00001111111111111111111111111111,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00000000000000000000000000000000,
			0b00000000000000000000000000000000, 0b00100000000000000000000000000000
	};
	
	if (model > 19901)
	{
		return 0;
	}
	model -= 320;
	if (model < 0)
	{
		return 0;
	}
	return (valid_model[model >> 5] & (1 << (model & 0x1F)));
}

stock PlayStreamedAudioForPlayer(playerid, streamString[])
{
	// Je�li klient w��czony
	if(Audio_IsClientConnected(playerid))
	{
	    Audio_StopRadio(playerid);
	
		Audio_Stop(playerid, PlayerCache[playerid][pAudioHandle]);
 		PlayerCache[playerid][pAudioHandle] = Audio_PlayStreamed(playerid, streamString);
	}
	else
	{
		StopAudioStreamForPlayer(playerid);
		PlayAudioStreamForPlayer(playerid, streamString);
	}
	return 1;
}

stock PlayStreamedAudio3DForPlayer(playerid, streamString[], Float:PosX, Float:PosY, Float:PosZ)
{
	if(Audio_IsClientConnected(playerid))
	{
	    Audio_StopRadio(playerid);

		Audio_Stop(playerid, PlayerCache[playerid][pAudioHandle]);
 		PlayerCache[playerid][pAudioHandle] = Audio_PlayStreamed(playerid, streamString);

 		Audio_Set3DPosition(playerid, PlayerCache[playerid][pAudioHandle], PosX, PosY, PosZ, 10.0);
	}
	else
	{
		StopAudioStreamForPlayer(playerid);
		PlayAudioStreamForPlayer(playerid, streamString, PosX, PosY, PosZ, 10.0, true);
	}
	return 1;
}

stock StopStreamedAudioForPlayer(playerid)
{
	if(PlayerCache[playerid][pAudioHandle])
	{
	    if(Audio_IsClientConnected(playerid))
	    {
	        Audio_Stop(playerid, PlayerCache[playerid][pAudioHandle]);
	    }
	    
	    PlayerCache[playerid][pAudioHandle] = 0;
	}
	else
	{
	    StopAudioStreamForPlayer(playerid);
	}
	return 1;
}

stock GetAccessID(access_uid)
{
	new access_id = INVALID_ACCESS_ID;
	foreach(new i : Access)
	{
	    if(AccessData[i][aUID] == access_uid)
	    {
	        access_id = i;
	        break;
	    }
	}
	return access_id;
}

stock GetPlayerFreeSlotAccess(playerid)
{
	new slot_index = INVALID_SLOT_ID;
	if(!IsPlayerAttachedObjectSlotUsed(playerid, SLOT_ACCESS_1))
	{
	    slot_index = SLOT_ACCESS_1;
	}
	else if(!IsPlayerAttachedObjectSlotUsed(playerid, SLOT_ACCESS_2))
	{
	    slot_index = SLOT_ACCESS_2;
	}
	else if(IsPlayerPremium(playerid) && !IsPlayerAttachedObjectSlotUsed(playerid, SLOT_ACCESS_3))
	{
	    slot_index = SLOT_ACCESS_3;
	}
	return slot_index;
}

stock GetPackageID(package_uid)
{
	new package_id = INVALID_PACKAGE_ID;
	foreach(new i : Package)
	{
	    if(PackageCache[i][pUID] == package_uid)
	    {
	        package_id = i;
			break;
	    }
	}
	return package_id;
}

stock GetAnimID(anim_uid)
{
	new anim_id = INVALID_ANIM_ID;
	foreach(new i : Anim)
	{
	    if(AnimCache[i][aUID] == anim_uid)
		{
		    anim_id = i;
	        break;
	    }
	}
	return anim_id;
}

stock GetAnimUID(anim_id)
{
	new anim_uid = 0;
	foreach(new i : Anim)
	{
	    if(i == anim_id)
	    {
	        anim_uid = AnimCache[i][aUID];
	        break;
	    }
	}
	return anim_uid;
}

stock GetPlayerStatus(playerid)
{
	new player_status = 1023;
	
	if(PlayerCache[playerid][pBW] <= 0) 								player_status -= STATUS_TYPE_DAZED;
	if(GetPlayerDrunkLevel(playerid) < 10000)   						player_status -= STATUS_TYPE_DRUNK;
	if(PlayerCache[playerid][pStrength] < 6500) 						player_status -= STATUS_TYPE_MUSCLE;
	if(!PlayerCache[playerid][pRoll])               					player_status -= STATUS_TYPE_ROLL;
	if(PlayerCache[playerid][pItemMask] == INVALID_ITEM_ID)				player_status -= STATUS_TYPE_MASKED;
	if(PlayerCache[playerid][pItemPlayer] == INVALID_ITEM_ID)           player_status -= STATUS_TYPE_EARPIECE;
	if(PlayerCache[playerid][pAFK] < 0)                                 player_status -= STATUS_TYPE_AFK;
	if(!PlayerCache[playerid][pBelts])                                  player_status -= STATUS_TYPE_BELTS;
	if(PlayerCache[playerid][pDrugLevel] < 10)                          player_status -= STATUS_TYPE_STONED;
	if(!PlayerCache[playerid][pGlove])                                  player_status -= STATUS_TYPE_GLOVES;
	
	return player_status;
}

stock GetAchieveIndex(achieve_type)
{
	new achieve_index;
 	for(new achieve_id = 0; achieve_id < sizeof(AchieveInfo); achieve_id++)
	{
	    if(AchieveInfo[achieve_id][aType] & achieve_type)
	    {
	        achieve_index = achieve_id;
	        break;
	    }
	}
	return achieve_index;
}

stock GetSexName(sex_type)
{
	new sex_name[24];
	switch(sex_type)
	{
	    case 0: sex_name = "kobieta";
	    case 1: sex_name = "m�czyzna";
	}
	return sex_name;
}
