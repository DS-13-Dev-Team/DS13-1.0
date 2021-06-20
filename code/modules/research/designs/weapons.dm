/datum/design/item/weapon
	category = "Weapons"
	price = 7000
	build_type = STORE
	materials = list(MATERIAL_STEEL = 30000, MATERIAL_GLASS = 2000, MATERIAL_SILVER = 4000, MATERIAL_URANIUM = 4000)
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5)


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
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer
	sort_string = "TAAAA"

/datum/design/item/weapon/rapidsyringe
	name = "large capacity syringe gun"
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	sort_string = "TAAAB"

/datum/design/item/weapon/large_grenade
	name = "large chemical grenade case"
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 3000)
	build_path = /obj/item/weapon/grenade/chem_grenade/large
	sort_string = "TABAA"
/* Re-add when the flashes are reworked.
/datum/design/item/weapon/advancedflash
	name = "advanced flash"
	id = "advancedflash"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 2000, MATERIAL_SILVER = 500)
	build_path = /obj/item/device/flash/advanced
	sort_string = "TADAA"
*/
/datum/design/item/weapon/contactbeam
	name = "C99 Supercollider Contact Beam"
	id = "contactbeam"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GOLD = 1500, "uranium" = 1450)
	build_path = /obj/item/weapon/gun/energy/contact
	sort_string = "TAEAA"
	price = 9000

/datum/design/item/weapon/miningcutter
	name = "210-V mining cutter"
	id = "miningcutter"
	req_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 3, TECH_POWER = 1)
	materials = list(MATERIAL_STEEL = 7500, MATERIAL_GLASS = 2500)
	build_path = /obj/item/weapon/gun/energy/cutter
	sort_string = "TAEAB"
	price = 2000

/datum/design/item/weapon/plasmacutter
	name = "211-V plasma cutter"
	id = "plasmacutter"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 5000, "gold" = 400)
	build_path = /obj/item/weapon/gun/energy/cutter/plasma
	sort_string = "TAEAC"
	price = 4000

/datum/design/item/weapon/advancedshield
	name = "Advanced Combat Shield"
	id = "advancedcombatshield"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 6)
	materials = list(MATERIAL_PLASTEEL = 10000, MATERIAL_GLASS = 2000)
	build_path = /obj/item/weapon/shield/riot/advanced
	sort_string = "TAEAD"

/datum/design/item/weapon/divet
	name = "Winchester NK Divet pistol"
	id = "divet"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)
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

	price = 8000

/datum/design/item/weapon/linecutter
	name = "IM-822 Handheld Ore Cutter Line Gun"
	id = "linecutter"
	build_path = /obj/item/weapon/gun/projectile/linecutter
	sort_string = "TBECF"

	price = 9000


/datum/design/item/weapon/javelingun
	name = "T15 Javelin Gun"
	id = "javgun"
	build_path = /obj/item/weapon/gun/projectile/javelin_gun
	sort_string = "TBECF"

	price = 11000


/datum/design/item/weapon/flamethrower
	name = "PFM-100 Industrial Torch"
	id = "flamethrower"
	build_path = /obj/item/weapon/gun/spray/hydrazine_torch
	sort_string = "TBECF"

	price = 11000




/datum/design/item/ammo
	category = "Ammunition"
	price = 2000


//Sidearms
/datum/design/item/ammo/divetslug
	name = "divet magazine"
	id = "divetslug"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 4000)
	build_path = /obj/item/ammo_magazine/divet
	sort_string = "TACEB"
	price = 1200

/datum/design/item/ammo/fiftycal/ammo
	name = ".50 AE magazine"
	id = "50cal"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5)
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_GOLD = 2000, MATERIAL_DIAMOND = 1000, MATERIAL_PLASTEEL = 2000) // Plasteel can be changed to deuterium later when I get around to defining material for it. If you have an idea for a reagent that could be used to minimize production of these, please add it.
	build_path = /obj/item/ammo_magazine/a50
	sort_string = "TACEH"
	price = 1200

/datum/design/item/ammo/plasma_energy
	name = "plasma energy"
	id = "plasma_energy"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 10000)
	build_path =/obj/item/weapon/cell/plasmacutter
	price = 1200


/datum/design/item/ammo/rivet_bolts
	name = "rivet bolts"
	id = "rivet_bolts"
	build_path = /obj/item/ammo_magazine/rivet
	price = 500




//Standard weapons
/datum/design/item/ammo/pulseslug
	name = "pulse rounds"
	id = "pulseslug"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 10000) // Same thing here. It might need tweaking with exotic materials to stop people getting a lot of it early on though.
	build_path = /obj/item/ammo_magazine/pulse
	sort_string = "TBECD"
	price = 1250

/datum/design/item/ammo/pulsehighvel
	name = "high velocity pulse rounds"
	id = "pulsehighvel"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	materials = list(MATERIAL_PLASTEEL = 17500, MATERIAL_DIAMOND = 5500, MATERIAL_SILVER = 2500) // Same thing here. It might need tweaking with exotic materials to stop people getting a lot of it early on though.
	build_path = /obj/item/ammo_magazine/pulse/hv
	sort_string = "TBECE"
	price = 2500



/datum/design/item/ammo/fuel_tank
	name = "fuel tank (gasoline)"
	id = "fuel_tank"
	build_path = /obj/item/weapon/reagent_containers/glass/fuel_tank/fuel
	price = 1000


/datum/design/item/ammo/hydrazine_tank
	name = "fuel tank (hydrazine)"
	id = "hydrazine_tank"
	build_path = /obj/item/weapon/reagent_containers/glass/fuel_tank/hydrazine
	price = 2000



/datum/design/item/ammo/ripper_blades
	name = "ripper blades (steel)"
	id = "ripper_blades"
	build_path = /obj/item/weapon/reagent_containers/glass/fuel_tank/hydrazine
	price = 1800


/datum/design/item/ammo/diamond_blades
	name = "ripper blades (diamond)"
	id = "diamond_blades"
	build_path = /obj/item/ammo_magazine/sawblades/diamond
	price = 3600


//Support Weapons
/datum/design/item/ammo/line_rack
	name = "line racks"
	id = "line_rack"
	build_path = /obj/item/ammo_magazine/lineracks
	price = 4000

/datum/design/item/ammo/force_energy
	name = "force energy"
	id = "force_energy"
	build_path = /obj/item/weapon/cell/force
	price = 2500

/datum/design/item/ammo/contact_energy
	name = "contact energy"
	id = "contact_energy"
	build_path = /obj/item/weapon/cell/contact
	price = 5000



/datum/design/item/weapon/grenadelauncher
	name = "junk grenade launcher"
	id = "grenadelauncher"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/weapon/gun/launcher/grenade
	sort_string = "TAGAA"