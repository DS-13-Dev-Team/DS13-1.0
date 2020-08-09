/turf/simulated/floor/plating
	icon = 'icons/turf/flooring/plating.dmi'
	name = "plating"
	icon_state = "plating"
	initial_flooring = /decl/flooring/reinforced/plating

/turf/simulated/floor/plating/under
	name = "underplating"
	icon_state = "under"
	icon = 'icons/turf/flooring/plating.dmi'
	initial_flooring = /decl/flooring/reinforced/plating/under



/turf/simulated/floor/hull
	name = "hull"
	icon = 'icons/turf/flooring/hull.dmi'
	icon_state = "hullcenter0"
	initial_flooring = /decl/flooring/reinforced/plating/hull


/turf/simulated/floor/hull/New()
	if(icon_state != "hullcenter0")
		overrided_icon_state = icon_state
	..()