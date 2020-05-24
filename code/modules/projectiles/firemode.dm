/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/list/settings = list()
	var/obj/item/weapon/gun/gun = null
	var/override_fire = FALSE	//If true, this firemode has its own firing proc which replaces that of the gun
	var/list/original_vars = list()

/datum/firemode/New(obj/item/weapon/gun/_gun, list/properties = null)
	..()
	if(!properties) return

	gun = _gun //Cache the weapon

	for(var/propname in properties)
		var/propvalue = properties[propname]

		if(propname == "mode_name")
			name = propvalue
		else if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like burst_accuracy
		else
			settings[propname] = propvalue

/datum/firemode/Destroy()
	gun = null
	original_vars = list()
	.=..()

/datum/firemode/proc/apply_to(obj/item/weapon/gun/_gun)
	gun = _gun
	gun.current_firemode = src
	for(var/propname in settings)
		if (propname in gun.vars)
			original_vars[propname] = gun.vars[propname]
			gun.vars[propname] = settings[propname]


/datum/firemode/proc/unapply_to(obj/item/weapon/gun/_gun)
	gun = _gun
	if (gun.current_firemode == src)
		gun.current_firemode = null
	for(var/propname in settings)
		if (propname in gun.vars)
			gun.vars[propname] = original_vars[propname]

/datum/firemode/proc/fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	return

/datum/firemode/proc/on_fire(var/atom/target, var/mob/living/user, var/clickparams, var/pointblank=0, var/reflex=0, var/obj/projectile)
	return

//Called whenever the firemode is switched to, or the gun is picked up while its active
/datum/firemode/proc/update()
	return