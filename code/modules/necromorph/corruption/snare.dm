/*
	The snare node is a necromorph trap. It will attempt to trip a human who walks over it. This is not luck based though.
	If successful, the human is knocked down for a significant period, and all the necromorphs are alerted to the location.
	Snares are single use and delete themselves on a successful trip

	Snare is avoidable, quite easily. If a player interacts with it in any manner to indicate that they've noticed it, they become immune
	to that particular snare for several minutes.

	It's main design goal is to act as a chilling effect. To force crew players to slow down and pay attention to their environment
*/
#define SNARE_PLACEMENT_BUFFER	3
/obj/structure/corruption_node/snare
	name = "Snare"
	desc = "<span class='notice'>That looks dangerous, good thing you noticed before tripping over it!</span>"
	icon_state = "snare"
	max_health = 50

	//Stores ref = time of players who interact with this
	var/aware = list()

	//Players who notice it are immune for this long
	var/awareness_timeout = 3 MINUTES

	default_alpha = 250
	alpha = 250

	//The snare's alpha gradually decreases over time, as it gets harder and harder to spot
	var/minimum_alpha = 150
	var/fade_chance = 10	//Roughly once every 10 seconds it drops a point
	random_rotation = TRUE
	randpixel = 4

/obj/structure/corruption_node/snare/get_blurb()
	. = "Places a trap on the floor which attempts to trip crewmembers who walk over it.<br>\
	If successful, the victim is knocked down for quite a long time and takes some damage. Snares are single use, and will vanish after successfully tripping someone<br>\<br>\
	Although snare can be placed near live crew, it must be placed at least [SNARE_PLACEMENT_BUFFER] tiles away<br>\<br>\
	The snare can only trip people as long as they don't notice it. If a human clicks on it or examines it, that specific snare becomes unable to trip them for the next few minutes, allowing them to harmlessly walk over it.<br>\
	<br>\
	Snares should be placed somewhere that people are likely to walk over them without noticing. However, if a snare is left alone for a long time, it gradually fades out and becomes harder to see. Eventually becoming nearly invisible.<br>\
	While snares can have some utility, their real benefit is a chilling effect.<br>\
	The potential threat of invisible snares around every corner can be used to wage psychological warfare, and curb crew aggression into corrupted areas"

/obj/structure/corruption_node/snare/update_icon()
	alpha = default_alpha
	.=..()

/obj/structure/corruption_node/snare/Process()
	if (prob(fade_chance) && default_alpha > minimum_alpha)
		default_alpha -= 1
		update_icon()

	.=..()




/obj/structure/corruption_node/snare/can_stop_processing()
	if (alpha > minimum_alpha)
		return FALSE

	return ..()


/obj/structure/corruption_node/snare/Crossed(var/atom/movable/AM)
	if (ishuman(AM) && !AM.is_necromorph())
		attempt_trip(AM)


/obj/structure/corruption_node/snare/proc/attempt_trip(var/mob/living/carbon/human/H)
	var/reference = "\ref[H]"
	var/last_time = aware[reference]
	if (isnum(last_time) && world.time - last_time < awareness_timeout)
		H.visible_message("[H] carefully steps over \the [src]")
		return FALSE


	//Success!
	trip(H)

/obj/structure/corruption_node/snare/proc/trip(var/mob/living/carbon/human/H)
	H.visible_message(SPAN_DANGER("[H] trips over \the [src]"))
	H.take_overall_damage(20)
	playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
	H.Weaken(5)



/*
	Interaction
*/
/obj/structure/corruption_node/snare/Click(var/location, var/control, var/params)
	register_awareness(usr)
	.=..()


//Record that this user indicated awareness of us at this time. They wont trip over this snare for a few minutes
/obj/structure/corruption_node/snare/proc/register_awareness(var/mob/user)
	//We dont register necros, they cant be tripped anyway
	if (user.is_necromorph())
		return
	var/reference = "\ref[user]"
	aware[reference] = world.time

	if (user.client)
		var/obj/screen/movable/tracker/tracker = null
		for (var/obj/screen/movable/tracker/snare_highlight/T in user.client.screen)
			if (T.tracked == src)
				tracker = T
				tracker.set_lifetime(awareness_timeout)
				break

		if (!tracker)
			tracker = new /obj/screen/movable/tracker/snare_highlight(user, src, awareness_timeout)




//Snare highlight, used to show where a seen snare is
/obj/screen/movable/tracker/snare_highlight
	alpha = 255

/obj/screen/movable/tracker/snare_highlight/setup()
	appearance = new /mutable_appearance(tracked)
	alpha = 255
	mouse_opacity = 0
	var/newfilter = filter(type="outline", size=1, color=COLOR_NECRO_YELLOW)
	filters.Add(newfilter)
/*
	Signal Ability
*/
/datum/signal_ability/placement/corruption/snare
	name = "Snare"
	id = "snare"
	desc = ""
	energy_cost = 50
	LOS_block = FALSE
	placement_atom = /obj/structure/corruption_node/snare
	click_handler_type = /datum/click_handler/placement/ability/snare



/*
	Mostly copypaste of above clickhandler
*/
/datum/click_handler/placement/ability/snare
	rotate_angle = 0

//Check we have a surface to place it on
/datum/click_handler/placement/ability/snare/placement_blocked(var/turf/candidate)
	for (var/mob/living/carbon/human/H in orange(SNARE_PLACEMENT_BUFFER, candidate))
		if (!H.is_necromorph() && !H.stat)
			return "Cannot be placed within [SNARE_PLACEMENT_BUFFER] tiles of a conscious crewmember."

	.=..()

