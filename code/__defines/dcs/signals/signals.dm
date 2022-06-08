#define COMSIG_ATOM_ENTERED "atom_entered"
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"
#define COMSIG_ATOM_DENSITY_CHANGE "atom_density_change"
#define COMSIG_ATOM_INVISIBILITY_SET "atom_invisibility_set"
#define COMSIG_TURF_CLARITY_SET "turf_clarity_set"
#define COMSIG_TURF_OPACITY_SET "trf_opacity_set"
#define COMSIG_MOVABLE_BUMP "movable_bump"
#define COMSIG_MOVABLE_PRE_MOVE "movable_pre_move"
#define COMSIG_MOVABLE_MOVED "movable_moved"
#define COMSIG_MOB_STATCHANGE "mob_statchange"
#define COMSIG_MOB_SIGHT_SET "mob_sight_set"
#define COMSIG_MOB_SEE_INVISIBLE_SET "mob_invisibility_set"
#define COMSIG_MOB_SEE_IN_DARK_SET "mob_see_in_dark_set"
#define COMSIG_MOB_VIEW_CHANGED "mob_view_changed"
#define COMSIG_MOB_HEALTH_CHANGED "mob_health_changed"
#define COMSIG_MOB_LOGIN "mob_login"
#define COMSIG_MOB_LOGOUT "mob_logout"
#define COMSIG_MOB_DAMAGE_HIT "mob_damage_hit"
#define COMSIG_LIVING_DEATH "living_death"
#define COMSIG_CARBON_HEART_STOPPED "carbon_heart_stopped"
#define COMSIG_CARBON_SWAP_HANDS "carbon_swap_hands"
#define COMSIG_PARENT_QDELETING "parent_qdeleting"
#define COMSIG_ITEM_EQUIPPED "item_equipped"
#define COMSIG_ITEM_UNEQUIPPED "item_unequipped"
#define COMSIG_GLOB_MOB_LOGGED_IN "glob_mob_logged_in"
/// fires on the target datum when an element is attached to it (/datum/element)
#define COMSIG_ELEMENT_ATTACH "element_attach"
/// fires on the target datum when an element is attached to it  (/datum/element)
#define COMSIG_ELEMENT_DETACH "element_detach"
///from base of turf/multiz_turf_del(): (turf/source, direction)
#define COMSIG_TURF_MULTIZ_DEL "turf_multiz_del"
///from base of turf/multiz_turf_new: (turf/source, direction)
#define COMSIG_TURF_MULTIZ_NEW "turf_multiz_new"
///from base of obj/item/afterattack(): (atom/target, mob/user, proximity_flag, click_parameters)
#define COMSIG_ITEM_AFTERATTACK "item_afterattack"
// Lighting:
///from base of [atom/proc/set_light]: (l_range, l_power, l_color, l_on)
#define COMSIG_ATOM_SET_LIGHT "atom_set_light"
	/// Blocks [/atom/proc/set_light], [/atom/proc/set_light_power], [/atom/proc/set_light_range], [/atom/proc/set_light_color], [/atom/proc/set_light_on], and [/atom/proc/set_light_flags].
	#define COMPONENT_BLOCK_LIGHT_UPDATE (1<<0)
///Called right before the atom changes the value of light_power to a different one, from base [atom/proc/set_light_power]: (new_power)
#define COMSIG_ATOM_SET_LIGHT_POWER "atom_set_light_power"
///Called right after the atom changes the value of light_power to a different one, from base of [/atom/proc/set_light_power]: (old_power)
#define COMSIG_ATOM_UPDATE_LIGHT_POWER "atom_update_light_power"
///Called right before the atom changes the value of light_range to a different one, from base [atom/proc/set_light_range]: (new_range)
#define COMSIG_ATOM_SET_LIGHT_RANGE "atom_set_light_range"
///Called right after the atom changes the value of light_range to a different one, from base of [/atom/proc/set_light_range]: (old_range)
#define COMSIG_ATOM_UPDATE_LIGHT_RANGE "atom_update_light_range"
///Called right before the atom changes the value of light_color to a different one, from base [atom/proc/set_light_color]: (new_color)
#define COMSIG_ATOM_SET_LIGHT_COLOR "atom_set_light_color"
///Called right after the atom changes the value of light_color to a different one, from base of [/atom/proc/set_light_color]: (old_color)
#define COMSIG_ATOM_UPDATE_LIGHT_COLOR "atom_update_light_color"
///Called right before the atom changes the value of light_on to a different one, from base [atom/proc/set_light_on]: (new_value)
#define COMSIG_ATOM_SET_LIGHT_ON "atom_set_light_on"
///Called right after the atom changes the value of light_on to a different one, from base of [/atom/proc/set_light_on]: (old_value)
#define COMSIG_ATOM_UPDATE_LIGHT_ON "atom_update_light_on"
///Called right before the atom changes the value of light_flags to a different one, from base [atom/proc/set_light_flags]: (new_flags)
#define COMSIG_ATOM_SET_LIGHT_FLAGS "atom_set_light_flags"
///Called right after the atom changes the value of light_flags to a different one, from base of [/atom/proc/set_light_flags]: (old_flags)
#define COMSIG_ATOM_UPDATE_LIGHT_FLAGS "atom_update_light_flags"
/// when a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_ADDED "component_added"
/// before a component is removed from a datum because of ClearFromParent: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"
///from base of atom/set_opacity(): (new_opacity)
#define COMSIG_ATOM_SET_OPACITY "atom_set_opacity"
