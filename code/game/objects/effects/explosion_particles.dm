/obj/effect/expl_particles
	name = "explosive particles"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	opacity = 1
	anchored = 1
	mouse_opacity = 0

/obj/effect/expl_particles/Initialize()
	QDEL_IN(src, 1 SECOND)
	return ..()

/datum/effect/system/expl_particles
	var/number = 10
	var/turf/location
	var/total_particles = 0

/datum/effect/system/expl_particles/proc/set_up(n = 10, loca)
	number = n
	if(istype(loca, /turf/)) location = loca
	else location = get_turf(loca)

/datum/effect/system/expl_particles/proc/start()
	var/i = 0
	for(i=0 to number)
		spawn(0)
			var/obj/effect/expl_particles/expl = new /obj/effect/expl_particles(src.location)
			var/direct = pick(GLOB.alldirs)
			for(i=0 to pick(1;25, 2;50, 3, 4;200))
				sleep(1)
				if(QDELING(expl))
					break
				expl.Move(get_step(expl, direct), direct)

/obj/effect/explosion
	name = "explosive particles"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	opacity = 1
	anchored = 1
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -32

/obj/effect/explosion/Initialize()
	QDEL_IN(src, 1 SECOND)
	return ..()

/datum/effect/system/explosion
	var/turf/location
	var/use_smoke = FALSE

/datum/effect/system/explosion/proc/set_up(loca, use_smoke)
	src.use_smoke = use_smoke
	if(istype(loca, /turf/)) location = loca
	else location = get_turf(loca)

/datum/effect/system/explosion/proc/start()
	new/obj/effect/explosion( location )
	var/datum/effect/system/expl_particles/P = new/datum/effect/system/expl_particles()
	P.set_up(10,location)
	P.start()
	if(use_smoke)
		addtimer(CALLBACK(src, .proc/make_smoke), 5)

/datum/effect/system/explosion/proc/make_smoke()
	var/datum/effect/effect/system/smoke_spread/S = new/datum/effect/effect/system/smoke_spread()
	S.set_up(5,0,location,null)
	S.start()


/proc/explosion_fx(var/atom/source)
	var/turf/T = get_turf(source)
	var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
	E.set_up(T, FALSE)
	E.start()
	QDEL_IN(E, 2 SECOND)
