//This file is for defines related to damage, armor, and generally violence

//Weapon Force: Provides the base damage for melee weapons.
//These are due for a review and overhaul, generally too powerful
#define WEAPON_FORCE_HARMLESS    3
#define WEAPON_FORCE_WEAK        7
#define WEAPON_FORCE_NORMAL      8
#define WEAPON_FORCE_PAINFUL     12
#define WEAPON_FORCE_DANGEROUS   16
#define WEAPON_FORCE_ROBUST      22
#define WEAPON_FORCE_LETHAL      30


//Resistance values, used on floors, windows, airlocks, girders, and similar hard targets
//Reduces the damage they take by flat amounts
#define RESISTANCE_FRAGILE 				4
#define RESISTANCE_AVERAGE 				8
#define RESISTANCE_IMPROVED 			12
#define RESISTANCE_TOUGH 				15
#define RESISTANCE_ARMOURED 			20
#define RESISTANCE_HEAVILY_ARMOURED 	25
#define RESISTANCE_VAULT 				30
#define RESISTANCE_UNBREAKABLE 			100


//Structure damage values: Multipliers on base damage for attacking hard targets
//Blades are weaker, and heavy/blunt weapons are stronger.
//Drills, fireaxes and energy melee weapons are the high end
#define STRUCTURE_DAMAGE_BLADE 			0.5
#define STRUCTURE_DAMAGE_WEAK 			0.8
#define STRUCTURE_DAMAGE_NORMAL 		1.0
#define STRUCTURE_DAMAGE_BLUNT 			1.3
#define STRUCTURE_DAMAGE_HEAVY 			1.5
#define STRUCTURE_DAMAGE_BREACHING 		1.8
#define STRUCTURE_DAMAGE_BORING 		3

//Quick defines for rapid fire
#define FULL_AUTO_300	list(mode_name="full auto",  mode_type = /datum/firemode/automatic, fire_delay=2)
#define FULL_AUTO_400	list(mode_name="full auto",  mode_type = /datum/firemode/automatic, fire_delay=1.5)
#define FULL_AUTO_600	list(mode_name="full auto",  mode_type = /datum/firemode/automatic, fire_delay=1)

//Defines used for how bullets expire
#define EXPIRY_DELETE	1	//Delete the bullet as soon as it's done
#define EXPIRY_FADEOUT	2	//Fade to zero alpha over some time, then delete
#define EXPIRY_ANIMATION	3	//Play an animation over some time, then delete



//Gun loading types
#define SINGLE_CASING 	1	//The gun only accepts ammo_casings. ammo_magazines should never have this as their mag_type.
#define SPEEDLOADER 	2	//Transfers casings from the mag to the gun when used.
#define MAGAZINE 		4	//The magazine item itself goes inside the gun



#define BASE_DEFENSE_CHANCE	85	//The basic chance of a human to block incoming hits, assuming they're conscious and facing the right direction
//This is extremely high so that humans will reliably lose limbs before core parts in combat.


//How fast most objects are thrown by an ordinary human, measured in metres per second
#define BASE_THROW_SPEED	6
