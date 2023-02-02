/*
List of circuit's designs:
Guns:
+	chemsprayer
+	large capacity syringe gun
+	large chemical grenade case
//	advanced flash
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
+	Incendiary Divet Magazine
+	Hollow Point Divet Magazine
+	Armor Piercing Divet Magazine
+	Rubber Divet Magazine
+	speed loader (.44 magnum)
+	plasma energy
+	rivet bolts
+	pulse rounds
+	high velocity pulse rounds
+	deflection pulse rounds
+	seeker shell
S	fuel tank (gasoline)
S	fuel tank (hydrazine)
+	ripper blades (steel)
+	ripper blades (diamond)
+	line racks
+	force energy
+	contact energy
*/
/datum/design/item/weapon
	category = "Weapons"
	build_type = PROTOLATHE | STORE_SCHEMATICS
	price = 7000
	materials = list(MATERIAL_STEEL = 30000, MATERIAL_GLASS = 2000, MATERIAL_SILVER = 4000, MATERIAL_URANIUM = 4000)

/datum/design/item/weapon/chemsprayer
	name = "chemsprayer"
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/reagent_containers/spray/chemsprayer

/datum/design/item/weapon/rapidsyringe
	name = "large capacity syringe gun"
	id = "rapidsyringe"
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/gun/launcher/syringe/rapid

/datum/design/item/weapon/large_grenade
	name = "large chemical grenade case"
	id = "large_grenade"
	materials = list(MATERIAL_STEEL = 3000)
	build_path = /obj/item/grenade/chem_grenade/large

/* Re-add when the flashes are reworked.
/datum/design/item/weapon/advancedflash
	name = "advanced flash"
	id = "advancedflash"
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 2000, MATERIAL_SILVER = 500)
	build_path = /obj/item/flash/advanced
*/

/datum/design/item/weapon/contactbeam
	name = "C99 Supercollider Contact Beam"
	id = "contactbeam"
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GOLD = 1500, "uranium" = 1450)
	build_path = /obj/item/gun/energy/contact
	price = 11000

/datum/design/item/weapon/miningcutter
	name = "210-V mining cutter"
	id = "miningcutter"
	materials = list(MATERIAL_STEEL = 7500, MATERIAL_GLASS = 2500)
	build_path = /obj/item/gun/energy/cutter
	price = 1000

/datum/design/item/weapon/plasmacutter
	name = "211-V plasma cutter"
	id = "plasmacutter"
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 5000, "gold" = 400)
	build_path = /obj/item/gun/energy/cutter/plasma
	price = 4000

/datum/design/item/weapon/riot
	name = "Combat Shield"
	id = "riot"
	materials = list(MATERIAL_STEEL = 7500, MATERIAL_PLASTEEL = 1000)
	build_path = /obj/item/shield/riot
	price = 8000

/datum/design/item/weapon/advancedshield
	name = "Advanced Combat Shield"
	id = "advancedcombatshield"
	materials = list(MATERIAL_PLASTEEL = 10000, MATERIAL_GLASS = 2000)
	build_path = /obj/item/shield/riot/advanced
	price = 10000

/datum/design/item/weapon/divet
	name = "Winchester NK Divet pistol"
	id = "divet"
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_PLASTEEL = 4000)
	build_path = /obj/item/gun/projectile/divet
	price = 5000

/datum/design/item/weapon/divet/silenced
	name = "Silenced Divet Pistol"
	id = "sdivet"
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_PLASTEEL = 4000, MATERIAL_PLASTIC = 1500)
	build_path = /obj/item/gun/projectile/divet/silenced
	build_type = PROTOLATHE		//Earth Gov Agent gun

/datum/design/item/weapon/pulserifle
	name = "SWS Motorized Pulse Rifle"
	id = "pulserifle"
	build_path = /obj/item/gun/projectile/automatic/pulse_rifle
	price = 10000

/datum/design/item/weapon/ripper
	name = "RC-DS Remote Control Disc Ripper"
	id = "ripper"
	build_path = /obj/item/gun/projectile/ripper
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 500, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 2000)
	price = 8500

/datum/design/item/weapon/linecutter
	name = "IM-822 Handheld Ore Cutter Line Gun"
	id = "linecutter"
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 1000, MATERIAL_SILVER = 2000, MATERIAL_URANIUM = 2000)
	build_path = /obj/item/gun/projectile/linecutter
	price = 11000

/datum/design/item/weapon/javelingun
	name = "T15 Javelin Gun"
	id = "javgun"
	materials = list(MATERIAL_PLASTEEL = 4000, MATERIAL_STEEL = 35000, MATERIAL_PHORON = 4000)
	build_path = /obj/item/gun/projectile/javelin_gun
	price = 11000

/datum/design/item/weapon/flamethrower
	name = "PFM-100 Industrial Torch"
	id = "flamethrower"
	build_path = /obj/item/gun/spray/hydrazine_torch
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GLASS = 100, MATERIAL_GOLD = 4000, MATERIAL_SILVER = 4000)
	price = 13000

/datum/design/item/weapon/seeker
	name = "Seeker Rifle"
	id = "seeker"
	build_path = /obj/item/gun/projectile/seeker
	materials = list(MATERIAL_STEEL = 12500, MATERIAL_PLASTEEL = 10000, MATERIAL_GLASS = 350, MATERIAL_DIAMOND = 800, MATERIAL_PLASTIC = 2000)
	price = 15000

/datum/design/item/weapon/forcegun
	name = "Handheld Graviton Accelerator"
	id = "forcegun"
	build_path = /obj/item/gun/energy/forcegun
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_PLASTIC = 3500, MATERIAL_GLASS = 500, MATERIAL_SILVER = 500)
	price = 9000

/datum/design/item/ammo
	category = "Ammunition"
	build_type = PROTOLATHE | STORE_SCHEMATICS
	price = 2000

//Sidearms
/datum/design/item/ammo/divetslug
	name = "divet magazine"
	id = "divetslug"
	materials = list(MATERIAL_STEEL = 4000)
	build_path = /obj/item/ammo_magazine/divet
	price = 1200

/datum/design/item/ammo/extds
	name = "divet magazine extended"
	id = "extds"
	materials = list(MATERIAL_STEEL = 5000)
	build_path = /obj/item/ammo_magazine/divet/extended
	price = 1500

/datum/design/item/ammo/icds
	name = "Incendiary Divet Magazine"
	id = "icds"
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_PHORON = 750)
	chemicals = list(/datum/reagent/water = 50)	// From lore perspective oxyphoron will be inside of bullets
	build_path = /obj/item/ammo_magazine/divet/incendiary
	build_type = PROTOLATHE

/datum/design/item/ammo/hpds
	name = "Hollow Point Divet Magazine"
	id = "hpds"
	materials = list(MATERIAL_STEEL = 4000)
	build_path = /obj/item/ammo_magazine/divet/hollow_point
	build_type = PROTOLATHE

/datum/design/item/ammo/rbds
	name = "Rubber Divet Magazine"
	id = "rbds"
	materials = list(MATERIAL_PLASTIC = 2500)
	build_path = /obj/item/ammo_magazine/divet/rb
	build_type = PROTOLATHE
	price = 900

/datum/design/item/ammo/apds
	name = "Armor Piercing Divet Magazine"
	id = "apds"
	materials = list(MATERIAL_STEEL = 4000)
	build_path = /obj/item/ammo_magazine/divet/ap
	build_type = PROTOLATHE

/datum/design/item/ammo/fiftycal/ammo
	name = "speed loader (.44 magnum)"
	id = "speedloader"
	materials = list(MATERIAL_STEEL = 750)
	build_path = /obj/item/ammo_magazine/c44
	price = 1300

/datum/design/item/ammo/plasma_energy
	name = "plasma energy"
	id = "plasma_energy"
	build_path = /obj/item/cell/plasmacutter
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_GLASS = 1000)
	price = 1600

/datum/design/item/ammo/rivet_bolts
	name = "rivet bolts"
	id = "rivet_bolts"
	build_path = /obj/item/ammo_magazine/rivet
	materials = list(MATERIAL_STEEL = 2700, MATERIAL_GLASS = 200, MATERIAL_PLASTIC = 4000)
	price = 2000



//Standard weapons
/datum/design/item/ammo/pulseslug
	name = "pulse rounds"
	id = "pulseslug"
	materials = list(MATERIAL_STEEL = 7500, MATERIAL_DIAMOND = 1500)
	build_path = /obj/item/ammo_magazine/pulse
	price = 2000

/datum/design/item/ammo/pulsedeflect
	name = "deflection pulse rounds"
	id = "pulsedeflect"
	materials = list(MATERIAL_PLASTEEL = 5000, MATERIAL_DIAMOND = 2000, MATERIAL_PHORON = 500)
	build_path = /obj/item/ammo_magazine/pulse/df
	price = 3250

/datum/design/item/ammo/pulsehighvel
	name = "high velocity pulse rounds"
	id = "pulsehighvel"
	materials = list(MATERIAL_PLASTEEL = 7500, MATERIAL_DIAMOND = 3000, MATERIAL_PHORON = 500)
	build_path = /obj/item/ammo_magazine/pulse/hv
	build_type = PROTOLATHE


/datum/design/item/ammo/shotgun
	name = "shotgun shell"
	id = "shotgun_ammo"
	materials = list(MATERIAL_PLASTIC = 2500, MATERIAL_STEEL = 3000)
	build_path = /obj/item/ammo_magazine/shotgun
	price = 1500

/datum/design/item/ammo/seeker_ammo
	name = "seeker shell"
	id = "seeker_ammo"
	materials = list(MATERIAL_PLASTEEL = 5000, MATERIAL_DIAMOND = 1250, MATERIAL_URANIUM = 500)
	build_path = /obj/item/ammo_magazine/seeker
	price = 3000


/datum/design/item/ammo/jav_ammo
	name = "javelin rack"
	desc = "A set of javelins for the launcher"
	id = "javelin_rack"
	materials = list(MATERIAL_PLASTEEL = 4000, MATERIAL_PHORON = 2500)
	build_path = /obj/item/ammo_magazine/javelin
	price = 2800


/datum/design/item/ammo/fuel_tank
	name = "fuel tank (gasoline)"
	id = "fuel_tank"
	build_type = STORE_SCHEMATICS
	build_path = /obj/item/reagent_containers/glass/fuel_tank/fuel
	price = 3000

/datum/design/item/ammo/hydrazine_tank
	name = "fuel tank (hydrazine)"
	id = "hydrazine_tank"
	build_type = STORE_SCHEMATICS
	build_path = /obj/item/reagent_containers/glass/fuel_tank/hydrazine
	price = 5000



/datum/design/item/ammo/ripper_blades
	name = "ripper blades (steel)"
	id = "ripper_blades"
	materials = list(MATERIAL_STEEL = 5000)
	build_path = /obj/item/ammo_magazine/sawblades
	price = 2300


/datum/design/item/ammo/diamond_blades
	name = "ripper blades (diamond)"
	id = "diamond_blades"
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/ammo_magazine/sawblades/diamond
	price = 2900

/datum/design/item/weapon/plasmasword
	name = "experimental mining blade"
	id = "plasmasword"
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_DIAMOND = 4000)
	build_path = /obj/item/material/twohanded/muramasa/plasmasword
	price = 4000

/datum/design/item/weapon/sheath
	name = "experimental blade sheath"
	id = "sheath"
	materials = list(MATERIAL_STEEL = 4000)
	build_path = /obj/item/storage/belt/holster/sheath
	price = 3000

//Support Weapons
/datum/design/item/ammo/line_rack
	name = "line racks"
	id = "line_rack"
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GLASS = 500)
	build_path = /obj/item/ammo_magazine/lineracks
	price = 3000

/datum/design/item/ammo/force_energy
	name = "force energy"
	id = "force_energy"
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_SILVER = 500)
	build_path = /obj/item/cell/force
	price = 2800

/datum/design/item/ammo/contact_energy
	name = "contact energy"
	id = "contact_energy"
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GOLD = 1200, "diamond" = 800)
	build_path = /obj/item/cell/contact
	price = 3500