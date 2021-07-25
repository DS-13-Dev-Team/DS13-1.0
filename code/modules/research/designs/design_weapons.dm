/*
List of circuit's designs:
Guns:
+	chemsprayer
+	large capacity syringe gun
+	large chemical grenade case
	//advanced flash
+	C99 Supercollider Contact Beam
+	210-V mining cutter
+	211-V plasma cutter
+	Advanced Combat Shield
+	Winchester NK Divet pistol
+	SWS Motorized Pulse Rifle
+	RC-DS Remote Control Disc Ripper
+	IM-822 Handheld Ore Cutter Line Gun
+	T15 Javelin Gun
+	PFM-100 Industrial Torch
+	Seeker Rifle
Ammo:
+	divet magazine
+	speed loader (.44 magnum)
+	plasma energy
+	rivet bolts
+	pulse rounds
+	high velocity pulse rounds
+	ripper blades (steel)
+	ripper blades (diamond)
+	line racks
+	force energy
+	contact energy
*/
/datum/design/item/weapon
	category = "Weapons"
	build_type = PROTOLATHE | STORE
	price = 7000
	materials = list(MATERIAL_STEEL = 30000, MATERIAL_GLASS = 2000, MATERIAL_SILVER = 4000, MATERIAL_URANIUM = 4000)


/datum/design/item/weapon/AssembleDesignName()
	..()
	name = "Weapon prototype ([item_name])"

/datum/design/item/weapon/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()


/datum/design/item/weapon/chemsprayer
	name = "chemsprayer"
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer
	sort_string = "TAAAA"

/datum/design/item/weapon/rapidsyringe
	name = "large capacity syringe gun"
	id = "rapidsyringe"
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	sort_string = "TAAAB"

/datum/design/item/weapon/large_grenade
	name = "large chemical grenade case"
	id = "large_grenade"
	materials = list(MATERIAL_STEEL = 3000)
	build_path = /obj/item/weapon/grenade/chem_grenade/large
	sort_string = "TABAA"
/* Re-add when the flashes are reworked.
/datum/design/item/weapon/advancedflash
	name = "advanced flash"
	id = "advancedflash"
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 2000, MATERIAL_SILVER = 500)
	build_path = /obj/item/device/flash/advanced
	sort_string = "TADAA"
*/
/datum/design/item/weapon/stunbaton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	id = "stunbaton"
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 500)
	build_path = /obj/item/weapon/melee/baton/loaded
	sort_string = "TABAA"

/datum/design/item/weapon/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	id = "handcuffs"
	materials = list(MATERIAL_STEEL = 1000)
	build_path = /obj/item/weapon/handcuffs
	sort_string = "TABAA"

/datum/design/item/weapon/contactbeam
	name = "C99 Supercollider Contact Beam"
	id = "contactbeam"
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GOLD = 1500, "uranium" = 1450)
	build_path = /obj/item/weapon/gun/energy/contact
	sort_string = "TAEAA"
	price = 9000

/datum/design/item/weapon/miningcutter
	name = "210-V mining cutter"
	id = "miningcutter"
	materials = list(MATERIAL_STEEL = 7500, MATERIAL_GLASS = 2500)
	build_path = /obj/item/weapon/gun/energy/cutter
	sort_string = "TAEAB"
	price = 2000

/datum/design/item/weapon/plasmacutter
	name = "211-V plasma cutter"
	id = "plasmacutter"
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 5000, "gold" = 400)
	build_path = /obj/item/weapon/gun/energy/cutter/plasma
	sort_string = "TAEAC"
	price = 4000

/datum/design/item/weapon/advancedshield
	name = "Advanced Combat Shield"
	id = "advancedcombatshield"
	materials = list(MATERIAL_PLASTEEL = 10000, MATERIAL_GLASS = 2000)
	build_path = /obj/item/weapon/shield/riot/advanced
	sort_string = "TAEAD"

/datum/design/item/weapon/divet
	name = "Winchester NK Divet pistol"
	id = "divet"
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_PLASTEEL = 4000)
	build_path = /obj/item/weapon/gun/projectile/divet
	sort_string = "TACEA"

	price = 4000


/datum/design/item/weapon/pulserifle
	name = "SWS Motorized Pulse Rifle"
	id = "pulserifle"
	build_path = /obj/item/weapon/gun/projectile/automatic/pulse_rifle
	sort_string = "TBECF"

	price = 7000


/datum/design/item/weapon/ripper
	name = "RC-DS Remote Control Disc Ripper"
	id = "ripper"
	build_path = /obj/item/weapon/gun/projectile/ripper
	sort_string = "TBECF"
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 500, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 2000)
	price = 8000

/datum/design/item/weapon/linecutter
	name = "IM-822 Handheld Ore Cutter Line Gun"
	id = "linecutter"
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 1000, MATERIAL_SILVER = 2000, MATERIAL_URANIUM = 2000)
	build_path = /obj/item/weapon/gun/projectile/linecutter
	sort_string = "TBECF"

	price = 9000


/datum/design/item/weapon/javelingun
	name = "T15 Javelin Gun"
	id = "javgun"
	build_path = /obj/item/weapon/gun/projectile/javelin_gun
	sort_string = "TBECF"
	materials = list(MATERIAL_PLASTEEL = 4000, MATERIAL_STEEL = 35000, MATERIAL_TRITIUM = 4000, MATERIAL_PHORON = 4000)
	price = 11000


/datum/design/item/weapon/flamethrower
	name = "PFM-100 Industrial Torch"
	id = "flamethrower"
	build_path = /obj/item/weapon/gun/spray/hydrazine_torch
	sort_string = "TBECF"
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GLASS = 100, MATERIAL_GOLD = 4000, MATERIAL_SILVER = 4000)
	price = 11000

/datum/design/item/weapon/seeker
	name = "Seeker Rifle"
	id = "seeker"
	build_path = /obj/item/weapon/gun/projectile/seeker
	build_type = PROTOLATHE		//Temp. Add to store once proper price specifide
	sort_string = "TBECF"
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_PLASTEEL = 7500, MATERIAL_GLASS = 100, MATERIAL_DIAMOND = 800, MATERIAL_PLASTIC = 2000)

/datum/design/item/ammo
	category = "Ammunition"
	build_type = PROTOLATHE | STORE
	price = 2000


//Sidearms
/datum/design/item/ammo/divetslug
	name = "divet magazine"
	id = "divetslug"
	materials = list(MATERIAL_STEEL = 4000)
	build_path = /obj/item/ammo_magazine/divet
	sort_string = "TBECG"
	price = 1200

/datum/design/item/ammo/fiftycal/ammo
	name = "speed loader (.44 magnum)"
	id = "44cal"
	materials = list(MATERIAL_STEEL = 750)
	build_path = /obj/item/ammo_magazine/c44
	sort_string = "TBECG"
	price = 1200

/datum/design/item/ammo/plasma_energy
	name = "plasma energy"
	id = "plasma_energy"
	build_path =/obj/item/weapon/cell/plasmacutter
	sort_string = "TBECG"
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_GLASS = 1000)
	price = 1200


/datum/design/item/ammo/rivet_bolts
	name = "rivet bolts"
	id = "rivet_bolts"
	build_path = /obj/item/ammo_magazine/rivet
	sort_string = "TBECG"
	materials = list(MATERIAL_STEEL = 2700, MATERIAL_GLASS = 200, MATERIAL_PLASTIC = 4000)
	price = 500




//Standard weapons
/datum/design/item/ammo/pulseslug
	name = "pulse rounds"
	id = "pulseslug"
	materials = list(MATERIAL_STEEL = 7500, MATERIAL_DIAMOND = 1500)
	build_path = /obj/item/ammo_magazine/pulse
	sort_string = "TBECG"
	price = 1250

/datum/design/item/ammo/pulsehighvel
	name = "high velocity pulse rounds"
	id = "pulsehighvel"
	materials = list(MATERIAL_PLASTEEL = 7500, MATERIAL_DIAMOND = 2500, MATERIAL_PHORON = 500)
	build_path = /obj/item/ammo_magazine/pulse/hv
	sort_string = "TBECG"
	price = 2500

/datum/design/item/ammo/seeker_ammo
	name = "seeker shell"
	id = "seeker_ammo"
	materials = list(MATERIAL_PLASTEEL = 5000, MATERIAL_DIAMOND = 1250, MATERIAL_URANIUM = 500)
	build_path = /obj/item/projectile/bullet/seeker
	build_type = PROTOLATHE //Temp. Add to the store once proper price will be specified
	sort_string = "TBECG"



/datum/design/item/ammo/fuel_tank
	name = "fuel tank (gasoline)"
	id = "fuel_tank"
	build_type = STORE
	build_path = /obj/item/weapon/reagent_containers/glass/fuel_tank/fuel
	price = 1000

/datum/design/item/ammo/hydrazine_tank
	name = "fuel tank (hydrazine)"
	id = "hydrazine_tank"
	build_type = STORE
	build_path = /obj/item/weapon/reagent_containers/glass/fuel_tank/hydrazine
	price = 2000



/datum/design/item/ammo/ripper_blades
	name = "ripper blades (steel)"
	id = "ripper_blades"
	materials = list(MATERIAL_STEEL = 5000)
	build_path = /obj/item/ammo_magazine/sawblades
	sort_string = "TBECG"
	price = 1800


/datum/design/item/ammo/diamond_blades
	name = "ripper blades (diamond)"
	id = "diamond_blades"
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/ammo_magazine/sawblades/diamond
	sort_string = "TBECG"
	price = 3600


//Support Weapons
/datum/design/item/ammo/line_rack
	name = "line racks"
	id = "line_rack"
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GLASS = 500)
	sort_string = "TBECG"
	build_path = /obj/item/ammo_magazine/lineracks
	price = 4000

/datum/design/item/ammo/force_energy
	name = "force energy"
	id = "force_energy"
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_SILVER = 500)
	sort_string = "TBECG"
	build_path = /obj/item/weapon/cell/force
	price = 2500

/datum/design/item/ammo/contact_energy
	name = "contact energy"
	id = "contact_energy"
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GOLD = 1200, "diamond" = 800)
	build_path = /obj/item/weapon/cell/contact
	sort_string = "TBECG"
	price = 5000