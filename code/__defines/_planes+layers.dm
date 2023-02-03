/*This file is a list of all preclaimed planes & layers

All planes & layers should be given a value here instead of using a magic/arbitrary number.

After fiddling with planes and layers for some time, I figured I may as well provide some documentation:

What are planes?
	Think of Planes as a sort of layer for a layer - if plane X is a larger number than plane Y, the highest number for a layer in X will be below the lowest
	number for a layer in Y.
	Planes also have the added bonus of having planesmasters.

What are Planesmasters?
	Planesmasters, when in the sight of a player, will have its appearance properties (for example, colour matrices, alpha, transform, etc)
	applied to all the other objects in the plane. This is all client sided.
	Usually you would want to add the planesmaster as an invisible image in the client's screen.

What can I do with Planesmasters?
	You can: Make certain players not see an entire plane,
	Make an entire plane have a certain colour matrices,
	Make an entire plane transform in a certain way,
	Make players see a plane which is hidden to normal players - I intend to implement this with the antag HUDs for example.
	Planesmasters can be used as a neater way to deal with client images or potentially to do some neat things

How do planes work?
	A plane can be any integer from -100 to 100. (If you want more, bug lummox.)
	All planes above 0, the 'base plane', are visible even when your character cannot 'see' them, for example, the HUD.
	All planes below 0, the 'base plane', are only visible when a character can see them.

How do I add a plane?
	Think of where you want the plane to appear, look through the pre-existing planes and find where it is above and where it is below
	Slot it in in that place, and change the pre-existing planes, making sure no plane shares a number.
	Add a description with a comment as to what the plane does.

How do I make something a planesmaster?
	Add the PLANE_MASTER appearance flag to the appearance_flags variable.

What is the naming convention for planes or layers?
	Make sure to use the name of your object before the _LAYER or _PLANE, eg: [NAME_OF_YOUR_OBJECT HERE]_LAYER or [NAME_OF_YOUR_OBJECT HERE]_PLANE
	Also, as it's a define, it is standard practice to use capital letters for the variable so people know this.

*/

/*
	from stddef.dm, planes & layers built into byond.

	FLOAT_LAYER = -1
	AREA_LAYER = 1
	TURF_LAYER = 2
	OBJ_LAYER = 3
	MOB_LAYER = 4
	FLY_LAYER = 5
	EFFECTS_LAYER = 5000
	TOPDOWN_LAYER = 10000
	BACKGROUND_LAYER = 20000
	EFFECTS_LAYER = 5000
	TOPDOWN_LAYER = 10000
	BACKGROUND_LAYER = 20000
	------

	FLOAT_PLANE = -32767
*/

//NEVER HAVE ANYTHING BELOW THIS PLANE ADJUST IF YOU NEED MORE SPACE
#define LOWEST_EVER_PLANE				-200

#define CLICKCATCHER_PLANE				-100

#define SPACE_PLANE						-99
#define SKYBOX_PLANE					-98

#define DUST_PLANE -97
	#define DEBRIS_LAYER 1
	#define DUST_LAYER 2

#define OPENSPACE_PLANE -9 //Openspace plane below all turfs
#define OPENSPACE_BACKDROP_PLANE -8 //Black square just over openspace plane to guaranteed cover all in openspace turf
	#define OPENSPACE_LAYER 600 //Openspace layer over all

#define FLOOR_PLANE						-7
#define GAME_PLANE						-6
#define GAME_PLANE_UPPER				-4

#define ABOVE_GAME_PLANE -2

#define PLATING_LAYER               1
//ABOVE PLATING
#define HOLOMAP_LAYER               1.01
#define DECAL_PLATING_LAYER         1.02
#define DISPOSALS_PIPE_LAYER        1.03
#define LATTICE_LAYER               1.04
#define PIPE_LAYER                  1.05
#define WIRE_LAYER                  1.06
#define WIRE_TERMINAL_LAYER         1.07
#define ABOVE_WIRE_LAYER            1.08
//TURF PLANE
//TURF_LAYER = 2
#define TURF_DETAIL_LAYER           2.01
#define TURF_SHADOW_LAYER           2.02
//ABOVE TURF
#define DECAL_LAYER                 2.03
#define RUNE_LAYER                  2.04
#define ABOVE_TILE_LAYER            2.05
#define EXPOSED_PIPE_LAYER          2.06
#define EXPOSED_WIRE_LAYER          2.07
#define EXPOSED_WIRE_TERMINAL_LAYER	2.08
#define CATWALK_LAYER               2.09
#define ABOVE_CATWALK_LAYER			2.10
#define BLOOD_LAYER					2.11
#define MOUSETRAP_LAYER				2.12
#define PLANT_LAYER					2.13
//HIDING MOB
#define HIDING_MOB_LAYER			2.14
#define SHALLOW_FLUID_LAYER			2.15
#define MOB_SHADOW_LAYER			2.16
//OBJ
#define LOW_OBJ_LAYER				2.17
#define BELOW_DOOR_LAYER			2.18
#define OPEN_DOOR_LAYER				2.19
#define LADDER_LAYER				2.20
#define BELOW_TABLE_LAYER           2.21
#define TABLE_LAYER                 2.22
#define BELOW_OBJ_LAYER             2.23
#define STRUCTURE_LAYER             2.24
// OBJ_LAYER                        3
#define ABOVE_OBJ_LAYER             3.01
#define CLOSED_DOOR_LAYER           3.02
#define ABOVE_DOOR_LAYER            3.03
#define SIDE_WINDOW_LAYER           3.04
#define FULL_WINDOW_LAYER           3.05
#define ABOVE_WINDOW_LAYER          3.06
//LYING MOB AND HUMAN
#define BELOW_MOB_LAYER				3.07
#define LYING_MOB_LAYER             3.08
#define LYING_HUMAN_LAYER           3.09
#define BASE_ABOVE_OBJ_LAYER        3.10
//MOB
#define MECH_UNDER_LAYER            3.11
// MOB_LAYER                        4
#define MECH_BASE_LAYER             4.01
#define MECH_INTERMEDIATE_LAYER     4.02
#define MECH_PILOT_LAYER            4.03
#define MECH_LEG_LAYER              4.04
#define MECH_COCKPIT_LAYER          4.05
#define MECH_ARM_LAYER              4.06
#define MECH_GEAR_LAYER             4.07
//ABOVE HUMAN
#define ABOVE_HUMAN_LAYER           4.08
#define VEHICLE_LOAD_LAYER          4.09
#define CAMERA_LAYER                4.10
//LARGE MOB LAYER
#define BELOW_LARGE_MOB_LAYER		4.11
#define LARGE_MOB_LAYER				4.12

//BLOB
#define BLOB_SHIELD_LAYER           4.13
#define BLOB_NODE_LAYER             4.14
#define BLOB_CORE_LAYER	            4.15

// Intermediate layer used by ABOVE_GAME_PLANE
#define ABOVE_ALL_MOB_LAYER			4.16

//EFFECTS BELOW LIGHTING
#define BELOW_PROJECTILE_LAYER      4.17
#define DEEP_FLUID_LAYER            4.18
#define FIRE_LAYER                  4.19
#define PROJECTILE_LAYER            4.20
#define ABOVE_PROJECTILE_LAYER      4.21
#define SINGULARITY_LAYER           4.22
#define POINTER_LAYER               4.23

//FLY_LAYER                          5
//OBSERVER
#define OBSERVER_LAYER              5.1

#define OBFUSCATION_LAYER           5.2
#define BASE_AREA_LAYER             999

#define BLACKNESS_PLANE					0 //To keep from conflicts with SEE_BLACKNESS internals

#define AREA_PLANE						60
#define MASSIVE_OBJ_PLANE				70
#define OBSERVER_PLANE					80 // For observers and ghosts
#define POINT_PLANE						90

//---------- LIGHTING -------------
///Normal 1 per turf dynamic lighting underlays
#define LIGHTING_PLANE 100

///Lighting objects that are "free floating"
#define O_LIGHTING_VISUAL_PLANE 110
#define O_LIGHTING_VISUAL_RENDER_TARGET "O_LIGHT_VISUAL_PLANE"

///Things that should render ignoring lighting
#define ABOVE_LIGHTING_PLANE 120

#define LIGHTING_PRIMARY_LAYER 15	//The layer for the main lights of the station
#define LIGHTING_PRIMARY_DIMMER_LAYER 15.1	//The layer that dims the main lights of the station
#define LIGHTING_SECONDARY_LAYER 16	//The colourful, usually small lights that go on top


///visibility + hiding of things outside of light source range
#define BYOND_LIGHTING_PLANE 130

//---------- EMISSIVES -------------
//Layering order of these is not particularly meaningful.
//Important part is the seperation of the planes for control via plane_master

/// This plane masks out lighting to create an "emissive" effect, ie for glowing lights in otherwise dark areas.
#define EMISSIVE_PLANE 150
/// The render target used by the emissive layer.
#define EMISSIVE_RENDER_TARGET "*EMISSIVE_PLANE"
/// The layer you should use if you _really_ don't want an emissive overlay to be blocked.
#define EMISSIVE_LAYER_UNBLOCKABLE 9999

///Popup Chat Messages
#define RUNECHAT_PLANE					200

#define OBSCURITY_PLANE_MARKER 210

#define OBSCURITY_MASKING_PLANE 215
#define OBSCURITY_MASKING_RENDER_TARGET "*OBSCURITY_MASKING_RENDER_TARGET"

#define OBSCURITY_PLANE					300 // For visualnets, such as the AI's static.

#define ABOVE_OBSCURITY_PLANE			400	//For objects that are seen even on obscured tiles. Mainly AI/signal eye sprites

#define FULLSCREEN_PLANE				500 // for fullscreen overlays that do not cover the hud.

	#define FULLSCREEN_LAYER			0
	#define DAMAGE_LAYER				1
	#define IMPAIRED_LAYER				2
	#define BLIND_LAYER					3
	#define CRIT_LAYER					4

#define RENDER_PLANE_GAME				990
#define RENDER_PLANE_NON_GAME			995
#define RENDER_PLANE_MASTER				999

#define HUD_PLANE                       1000 // For the Head-Up Display

	#define UNDER_HUD_LAYER				0
	#define HUD_BASE_LAYER				1
	#define HUD_ITEM_LAYER				2
	#define HUD_ABOVE_ITEM_LAYER		3
	#define HUD_TEXT_LAYER				4

#define ABOVE_HUD_PLANE 1100
	#define ABOVE_HUD_LAYER 1

#define RADIAL_BACKGROUND_LAYER 0
///1000 is an unimportant number, it's just to normalize copied layers
#define RADIAL_CONTENT_LAYER 1000

/image/proc/plating_decal_layerise()
	plane = FLOOR_PLANE
	layer = DECAL_PLATING_LAYER

/atom/proc/hud_layerise()
	plane = ABOVE_HUD_PLANE
	layer = ABOVE_HUD_LAYER

///Plane master controller keys
#define PLANE_MASTERS_GAME "plane_masters_game"
