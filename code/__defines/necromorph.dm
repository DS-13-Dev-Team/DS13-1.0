//Spawning methods for things purchased at necroshop
#define SPAWN_POINT		1	//The thing is spawned in a random clear tile around a specified spawnpoint
#define SPAWN_PLACE		2	//The thing is manually placed by the user on a viable corruption tile

#define NECROMORPH_ACID_POWER	0.7	//Damage per unit of necromorph organic acid, used by many things
#define NECROMORPH_FRIENDLY_FIRE_FACTOR	0.5	//All damage dealt by necromorphs TO necromorphs, is multiplied by this
#define NECROMORPH_ACID_COLOR	"#946b36"

//Maximum bonus to evasion tripod gets for being in an open space
#define TRIPOD_PERSONAL_SPACE_MAX_EVASION	35

//Minimum power levels for bioblasts to trigger the appropriate ex_act tier
#define BIOBLAST_TIER_1	120
#define BIOBLAST_TIER_2	60
#define BIOBLAST_TIER_3	30



//Errorcodes returned from a biomass source
#define MASS_READY	"ready"	//Nothing is wrong, ready to absorb
#define MASS_ACTIVE	"active"//The source is ready to absorb, but it needs to be handled carefully and asked each time you absorb from it
#define MASS_PAUSE	"pause"	//Not ready to deliver, but keep this source in the list and check again next tick
#define MASS_EXHAUST	"exhaust"	//All mass is gone, delete this source
#define MASS_FAIL	"fail"	//The source can't deliver anymore, maybe its not in range of where it needs to be



#define CORRUPTION_SPREAD_RANGE	12	//How far from the source corruption spreads
#define CORRUPTION_FIRE_DAMAGE_FACTOR	2	//Damage dealt to corruption from high heat is multiplied by this value
#define CORRUPTION_SCORCH_DURATION	(1 MINUTE)	//Corruption hit by fire cannot regrow in that tile for this quantity of time


#define MAW_EAT_RANGE	2	//Nom distance of a maw node


//Biomass harvest defines. These are quantites per second that a machine gives when under the grip of a harvester
//Remember that there are often 10+ of any such machine in its appropriate room, and each gives a quantity
#define BIOMASS_HARVEST_LARGE	0.04
#define BIOMASS_HARVEST_MEDIUM	0.03
#define BIOMASS_HARVEST_SMALL	0.015

//This is intended for use with active sources which have a limited total quantity to distribute.
//Don't allow infinite sources to give out biomass at this rate
#define BIOMASS_HARVEST_ACTIVE	0.1

//Not for gameplay use, debugging only
#define BIOMASS_HARVEST_DEBUG	10

//Items in vendors are worth this* their usual biomass, to make them last longer as sources
#define VENDOR_BIOMASS_MULT	5

//One unit (10ml) of purified liquid biomass can be multiplied by this value to create one kilogram of solid biomass
#define REAGENT_TO_BIOMASS	0.01

#define BIOMASS_TO_REAGENT	100



#define PLACEMENT_FLOOR	"floor"
#define PLACEMENT_WALL	"wall"


#define BIOMASS_REQ_T2	850
#define BIOMASS_REQ_T3	1350
#define BIOMASS_REQ_T4	3825

#define DAM_MOD_T1 0.91
#define DAM_MOD_T2 1.25
#define DAM_MOD_T3 1.35

/*
	Customisation parameters
*/
#define SIGNAL_DEFAULT	"red"
#define VARIANT	"variant"
#define OUTFIT	"outfit"
#define WEIGHT	"weight"
#define PATRON	"patron"



/*

*/
#define OBJECTIVE_BIOMASS_VERY_LOW	140
#define OBJECTIVE_BIOMASS_LOW	    270
#define OBJECTIVE_BIOMASS_MED   	595
#define OBJECTIVE_BIOMASS_HIGH	    810