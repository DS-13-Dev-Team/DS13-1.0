#define LOADOUT_CHECK	if (!pref.loadout) {pref.loadout = create_loadout_from_preferences((pref.client.mob ? pref.client.mob : pref.client), pref)}
#define LOADOUT_CHECK_PREF	if (!loadout) {loadout = create_loadout_from_preferences((client.mob ? client.mob : client), src)}


#define LOADOUT_TAG_SPECIAL	"special"

#define LOADOUT_TAG_RIG	"RIG"


//Rig storage exclusion tags
#define LOADOUT_TAG_RIG_STORAGE	"storage"
#define LOADOUT_TAG_RIG_STORAGE_1	"storage_1"
#define LOADOUT_TAG_RIG_STORAGE_2	"storage_2"
#define LOADOUT_TAG_RIG_STORAGE_3	"storage_3"
#define LOADOUT_TAG_RIG_STORAGE_ANY	"anystorage"	//Indicates that the user has picked any kind of storage loadout module


#define LOADOUT_TAG_RIG_HOTSWAP	"hotswap"

#define LOADOUT_TAG_RIG_JETPACK	"jetpack"

#define LOADOUT_TAG_RIG_KINESIS	"kinesis"

#define LOADOUT_TAG_RIG_MOVESPEED	"movespeed"

#define LOADOUT_TAG_RIG_HEALTHBAR	"healthbar"

#define LOADOUT_TAG_RIG_POWERSIPHON	"siphon"

//If a loadout gear is designated for any of these slots, we will put it in storage if its desired slot is taken, even if its set to override
//Additionally, gear designated for these slots won't delete parts of the outfit to make room for themselves, they'll just be stored
#define LOADOUT_SLOT_STORE	list(slot_tie, slot_in_backpack, slot_l_store, slot_r_store, slot_s_store)


//If this is set as a gear's slot var, it will call spawn_special to create that gear item, allowing it to be overridden and placed manually
#define GEAR_EQUIP_SPECIAL	"special"


#define CATEGORY_ACCESSORIES	"Accessories"
#define CATEGORY_CLOTHING	"Clothing"
#define CATEGORY_EARWEAR	 "Earwear"
#define CATEGORY_EYEWEAR	"Eyewear"
#define CATEGORY_GLOVES		"Gloves"
#define CATEGORY_HEADWEAR	"Headwear"
#define CATEGORY_RIG	"RIG"
#define CATEGORY_GENERAL	"General"
#define CATEGORY_MISC	"Misc"
#define CATEGORY_TOOLS	"Tools"

#define SUBCATEGORY_FRAMES	"Frames"
#define SUBCATEGORY_MODULES	 "Modules"
#define SUBCATEGORY_DANGEROUS_TOOLS	 "Dangerous Tools"


//Access defines for custom items, one is applied to each distribution channel for obtaining the item. An item can have different access in different channels
#define ACCESS_PUBLIC	"public"
#define ACCESS_PATRONS	"patrons"
#define ACCESS_WHITELIST	"whitelist"