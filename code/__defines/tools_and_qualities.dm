#define ABORT_CHECK						-1
#define TOOL_USE_FAIL					-1
#define TOOL_USE_CANCEL					0
#define TOOL_USE_SUCCESS				1

#define QUALITY_BOLT_TURNING			"bolt turning"
#define QUALITY_PULSING					"pulsing"
#define QUALITY_PRYING					"prying"
#define QUALITY_WELDING					"welding"
#define QUALITY_SCREW_DRIVING			"screw driving"
#define QUALITY_WIRE_CUTTING			"wire cutting"
#define QUALITY_CLAMPING				"clamping"
#define QUALITY_CAUTERIZING				"cauterizing"
#define QUALITY_RETRACTING				"retracting"
#define QUALITY_DRILLING				"drilling"
#define QUALITY_SAWING					"sawing"
#define QUALITY_BONE_SETTING			"bone setting"
#define QUALITY_SHOVELING				"shoveling"
#define QUALITY_DIGGING					"digging"
#define QUALITY_EXCAVATION				"excavation"
#define QUALITY_CUTTING					"cutting"
#define QUALITY_LASER_CUTTING			"laser cutting"	//laser scalpels and e-swords - bloodless cutting
#define QUALITY_ADHESIVE				"adhesive"
#define QUALITY_SEALING					"sealing"
#define QUALITY_WORKBENCH				"workbench"

//Time for a work for tool system calculated in that way: basic time - tool level - stat check..
//It means that basic tools will give -30 on time, and people on right job should have -20 at least, or even more.
#define WORKTIME_INSTANT				0
#define WORKTIME_NEAR_INSTANT			30
#define WORKTIME_FAST					60
#define WORKTIME_NORMAL					90
#define WORKTIME_SLOW					120
#define WORKTIME_VERY_SLOW					170
#define WORKTIME_EXTREMELY_LONG			250

//Fail chance for tool system calculated in that way: basic chance - tool level - stat check.
//Basic tools will give -30% on fail chance, and people on right job should have -20% at least.
#define FAILCHANCE_ZERO					0
#define FAILCHANCE_VERY_EASY			15
#define FAILCHANCE_EASY					35
#define FAILCHANCE_NORMAL				45
#define FAILCHANCE_HARD					65
#define FAILCHANCE_CHALLENGING			75
#define FAILCHANCE_VERY_HARD			105
#define FAILCHANCE_IMPOSSIBLE			135

//Sounds for working with tools
#define NO_WORKSOUND					-1

#define WORKSOUND_CIRCULAR_SAW			'sound/weapons/circsawhit.ogg'
#define WORKSOUND_SIMPLE_SAW			'sound/items/saw.ogg'
#define WORKSOUND_WRENCHING				'sound/items/Ratchet.ogg'
#define WORKSOUND_WIRECUTTING			'sound/items/Wirecutter.ogg'
#define WORKSOUND_WELDING				"weld"
#define WORKSOUND_PULSING				'sound/items/multitool_pulse.ogg'
#define WORKSOUND_SCREW_DRIVING			'sound/items/Screwdriver.ogg'
#define WORKSOUND_EASY_CROWBAR			'sound/items/Crowbar.ogg'
#define WORKSOUND_REMOVING				'sound/items/Deconstruct.ogg'
#define WORKSOUND_DRIVER_TOOL			'sound/items/e_screwdriver.ogg'
#define WORKSOUND_PICKAXE				'sound/items/pickaxe.ogg'
#define WORKSOUND_HARD_SLASH			'sound/weapons/bladeslice.ogg'
#define WORKSOUND_CHAINSAW				'sound/items/chainsaw.ogg'
#define WORKSOUND_TAPE					'sound/items/duct_tape.ogg'

#define DEGRADATION_NORMAL	0.065

#define DEGRADATION_WEAK_1	0.075
#define DEGRADATION_WEAK_2	0.1
#define DEGRADATION_WEAK_3	0.12
#define DEGRADATION_WEAK_4	0.2

#define DEGRADATION_FRAGILE		1


#define DEGRADATION_TOUGH_1	0.06
#define DEGRADATION_TOUGH_2	0.05


#define DEGRADATION_DIAMOND	0.01