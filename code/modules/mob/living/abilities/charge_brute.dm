/atom/movable/proc/brute_charge_attack(atom/_target, _speed = 7, _lifespan = 2 SECONDS, _maxrange = null, _homing = TRUE, _inertia = FALSE, _power = 0, _cooldown = 20 SECONDS, _delay = 0)
	//First of all, lets check if we're currently able to charge
	if (!can_charge(_target, TRUE))
		return FALSE


	//Ok we've passed all safety checks, let's commence charging!
	//We simply create the extension on the movable atom, and everything works from there
	set_extension(src, /datum/extension/charge/brute, _target, _speed, _lifespan, _maxrange, _homing, _inertia, _power, _cooldown, _delay)

	return TRUE


/datum/extension/charge/brute/moved(var/atom/movable/mover, oldloc, newloc)
	.=..()
	//Parent will return false if something stopped our charge
	if (.)
		//When the brute moves, it also impacts mobs in tiles either side of it
		var/charge_direction = get_dir(oldloc, newloc)
		var/list/turfs = list(get_step(mover, turn(charge_direction, 90)), get_step(mover, turn(charge_direction, -90)))

		var/continue_charge = TRUE
		for (var/turf/T in turfs)
			if (!continue_charge)
				break

			for (var/mob/A in T)
				if (ismob(A))
					continue_charge = src.bump(mover, A)

				if (!continue_charge)
					break