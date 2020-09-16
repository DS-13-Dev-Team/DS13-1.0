

/datum/design/item
	build_type = PROTOLATHE

/datum/design/item/disk/AssembleDesignName()
	..()
	name = "Storage disk ([item_name])"

/datum/design/item/disk/design
	name = "research design"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 10)
	build_path = /obj/item/weapon/disk/design_disk
	sort_string = "AAAAA"

/datum/design/item/disk/tech
	name = "technology data"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 10)
	build_path = /obj/item/weapon/disk/tech_disk
	sort_string = "AAAAB"

/datum/design/item/stock_part
	build_type = PROTOLATHE

/datum/design/item/stock_part/AssembleDesignName()
	..()
	name = "Component design ([item_name])"

/datum/design/item/stock_part/AssembleDesignDesc()
	if(!desc)
		desc = "A stock part used in the construction of various devices."

/datum/design/item/stock_part/basic_capacitor
	name = "basic capacitor"
	id = "basic_capacitor"
	req_tech = list(TECH_POWER = 1)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor
	sort_string = "CAAAA"

/datum/design/item/stock_part/adv_capacitor
	name = "advanced capacitor"
	id = "adv_capacitor"
	req_tech = list(TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor/adv
	sort_string = "CAAAB"

/datum/design/item/stock_part/super_capacitor
	name = "super capacitor"
	id = "super_capacitor"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50, MATERIAL_GOLD = 20)
	build_path = /obj/item/weapon/stock_parts/capacitor/super
	sort_string = "CAAAC"

/datum/design/item/stock_part/micro_mani
	name = "micro-manipulator"
	id = "micro_mani"
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	materials = list(MATERIAL_STEEL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator
	sort_string = "CAABA"

/datum/design/item/stock_part/nano_mani
	name = "nano-manipulator"
	id = "nano_mani"
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	materials = list(MATERIAL_STEEL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator/nano
	sort_string = "CAABB"

/datum/design/item/stock_part/pico_mani
	name = "pico-manipulator"
	id = "pico_mani"
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	materials = list(MATERIAL_STEEL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator/pico
	sort_string = "CAABC"

/datum/design/item/stock_part/basic_matter_bin
	name = "matter bin"
	id = "basic_matter_bin"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(MATERIAL_STEEL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin
	sort_string = "CAACA"

/datum/design/item/stock_part/adv_matter_bin
	name = "advanced matter bin"
	id = "adv_matter_bin"
	req_tech = list(TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin/adv
	sort_string = "CAACB"

/datum/design/item/stock_part/super_matter_bin
	name = "super matter bin"
	id = "super_matter_bin"
	req_tech = list(TECH_MATERIAL = 5)
	materials = list(MATERIAL_STEEL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin/super
	sort_string = "CAACC"

/datum/design/item/stock_part/basic_micro_laser
	name = "micro-laser"
	id = "basic_micro_laser"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GLASS = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser
	sort_string = "CAADA"

/datum/design/item/stock_part/high_micro_laser
	name = "high-power micro-laser"
	id = "high_micro_laser"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GLASS = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser/high
	sort_string = "CAADB"

/datum/design/item/stock_part/ultra_micro_laser
	name = "ultra-high-power micro-laser"
	id = "ultra_micro_laser"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GLASS = 20, "uranium" = 10)
	build_path = /obj/item/weapon/stock_parts/micro_laser/ultra
	sort_string = "CAADC"

/datum/design/item/stock_part/basic_sensor
	name = "scanning module"
	id = "basic_sensor"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module
	sort_string = "CAAEA"

/datum/design/item/stock_part/adv_sensor
	name = "advanced scanning module"
	id = "adv_sensor"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module/adv
	sort_string = "CAAEB"

/datum/design/item/stock_part/phasic_sensor
	name = "phasic scanning module"
	id = "phasic_sensor"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 20, MATERIAL_SILVER = 10)
	build_path = /obj/item/weapon/stock_parts/scanning_module/phasic
	sort_string = "CAAEC"

/datum/design/item/stock_part/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	id = "rped"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 5000)
	build_path = /obj/item/weapon/storage/part_replacer
	sort_string = "CBAAA"

/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB
	category = "Misc"

/datum/design/item/powercell/AssembleDesignName()
	name = "Power cell model ([item_name])"

/datum/design/item/powercell/device/AssembleDesignName()
	name = "Device cell model ([item_name])"

/datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/weapon/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/item/powercell/Fabricate()
	var/obj/item/weapon/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	return C

/datum/design/item/powercell/contact
	name = "contact energy"
	id = "contact_energy"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 1250, MATERIAL_GLASS = 250, "uranium" = 125)
	build_path = /obj/item/weapon/cell/contact
	sort_string = "DAAAA"

/datum/design/item/powercell/basic
	name = "basic power cell"
	id = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	materials = list(MATERIAL_STEEL = 700, MATERIAL_GLASS = 50)
	build_path = /obj/item/weapon/cell
	sort_string = "DAAAA"

/datum/design/item/powercell/high
	name = "advanced power cell"
	id = "high_cell"
	req_tech = list(TECH_POWER = 2)
	materials = list(MATERIAL_STEEL = 700, MATERIAL_GLASS = 60)
	build_path = /obj/item/weapon/cell/high
	sort_string = "DAAAB"

/datum/design/item/powercell/super
	name = "enhanced power cell"
	id = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 700, MATERIAL_GLASS = 70)
	build_path = /obj/item/weapon/cell/super
	sort_string = "DAAAC"

/datum/design/item/powercell/hyper
	name = "hyper-capacity power cell"
	id = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 400, MATERIAL_GOLD = 150, MATERIAL_SILVER = 150, MATERIAL_GLASS = 70)
	build_path = /obj/item/weapon/cell/hyper
	sort_string = "DAAAD"

/datum/design/item/powercell/device/standard
	name = "device power cell"
	id = "device_cell_standard"
	req_tech = list(TECH_POWER = 1)
	materials = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 5)
	build_path = /obj/item/weapon/cell/device/standard
	sort_string = "DAAAE"

/datum/design/item/powercell/device/high
	name = "advanced device power cell"
	build_type = PROTOLATHE | MECHFAB
	id = "device_cell_high"
	req_tech = list(TECH_POWER = 2)
	materials = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 6)
	build_path = /obj/item/weapon/cell/device/high
	sort_string = "DAAAF"

/datum/design/item/hud
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/hud/AssembleDesignName()
	..()
	name = "HUD glasses design ([item_name])"

/datum/design/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/item/hud/health
	name = "health scanner hud"
	id = "health_hud"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health
	sort_string = "GAAAA"

/datum/design/item/hud/security
	name = "security scanner hud"
	id = "security_hud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	sort_string = "GAAAB"

/datum/design/item/optical/AssembleDesignName()
	..()
	name = "Optical glasses design ([item_name])"

/datum/design/item/optical/mesons
	name = "meson goggles"
	desc = "Using the meson-scanning technology those glasses allow you to see through walls, floor or anything else."
	id = "mesons"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/clothing/glasses/meson
	sort_string = "GBAAA"

/datum/design/item/optical/material
	name = "material goggles"
	id = "mesons_material"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/clothing/glasses/material
	sort_string = "GAAAB"

/datum/design/item/optical/tactical
	name = "tactical goggles"
	id = "tactical_goggles"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 5)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50, MATERIAL_SILVER = 50, MATERIAL_GOLD = 50)
	build_path = /obj/item/clothing/glasses/tacgoggles
	sort_string = "GAAAC"

/datum/design/item/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"
/*
/datum/design/item/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 500, MATERIAL_SILVER = 500)
	build_path = /obj/item/weapon/tool/pickaxe/jackhammer
	sort_string = "KAAAA"

/datum/design/item/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 1000) //expensive, but no need for miners.
	build_path = /obj/item/weapon/tool/pickaxe/drill
	sort_string = "KAAAB"
*/
/datum/design/item/mining/depth_scanner
	name = "depth scanner"
	desc = "Used to check spatial depth and density of rock outcroppings."
	id = "depth_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 1000,MATERIAL_GLASS = 1000)
	build_path = /obj/item/device/depth_scanner
	sort_string = "KAAAD"

/datum/design/item/medical
	materials = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 20)

/datum/design/item/medical/AssembleDesignName()
	..()
	name = "Biotech device prototype ([item_name])"

/datum/design/item/medical/mass_spectrometer
	name = "mass spectrometer"
	desc = "A device for analyzing chemicals in blood."
	id = "mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/mass_spectrometer
	sort_string = "MACAA"

/datum/design/item/medical/adv_mass_spectrometer
	name = "advanced mass spectrometer"
	desc = "A device for analyzing chemicals in blood and their quantities."
	id = "adv_mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/mass_spectrometer/adv
	sort_string = "MACAB"

/datum/design/item/medical/reagent_scanner
	name = "reagent scanner"
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/reagent_scanner
	sort_string = "MACBA"

/datum/design/item/medical/adv_reagent_scanner
	name = "advanced reagent scanner"
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/reagent_scanner/adv
	sort_string = "MACBB"

/datum/design/item/medical/nanopaste
	name = "nanopaste"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 7000, MATERIAL_GLASS = 7000)
	build_path = /obj/item/stack/nanopaste
	sort_string = "MADAA"

/datum/design/item/medical/hypospray
	name = "hypospray"
	desc = "A sterile, air-needle autoinjector for rapid administration of drugs"
	id = "hypospray"
	req_tech = list(TECH_MATERIAL = 4, TECH_BIO = 5)
	materials = list(MATERIAL_STEEL = 8000, MATERIAL_GLASS = 8000, MATERIAL_SILVER = 2000)
	build_path = /obj/item/weapon/reagent_containers/hypospray/vial
	sort_string = "MAEAA"

/datum/design/item/surgery/AssembleDesignName()
	..()
	name = "Surgical tool design ([item_name])"

/datum/design/item/surgery/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	id = "scalpel_laser1"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list(MATERIAL_STEEL = 12500, MATERIAL_GLASS = 7500)
	build_path = /obj/item/weapon/scalpel/laser1
	sort_string = "MBEAA"

/datum/design/item/surgery/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	id = "scalpel_laser2"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(MATERIAL_STEEL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 2500)
	build_path = /obj/item/weapon/scalpel/laser2
	sort_string = "MBEAB"

/datum/design/item/surgery/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	id = "scalpel_laser3"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list(MATERIAL_STEEL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 2000, MATERIAL_GOLD = 1500)
	build_path = /obj/item/weapon/scalpel/laser3
	sort_string = "MBEAC"

/datum/design/item/surgery/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list (MATERIAL_STEEL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 1500, MATERIAL_GOLD = 1500, MATERIAL_DIAMOND = 750)
	build_path = /obj/item/weapon/scalpel/manager
	sort_string = "MBEAD"

/datum/design/item/beaker/AssembleDesignName()
	name = "Beaker prototype ([item_name])"

/datum/design/item/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 3000)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/noreact
	sort_string = "MCAAA"

/datum/design/item/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bluespacebeaker"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_PHORON = 3000, MATERIAL_DIAMOND = 500)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bluespace
	sort_string = "MCAAB"

/datum/design/item/implant
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/implant/AssembleDesignName()
	..()
	name = "Implantable biocircuit design ([item_name])"

/datum/design/item/implant/chemical
	name = "chemical implant"
	id = "implant_chem"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/weapon/implantcase/chem
	sort_string = "MFAAA"

/datum/design/item/implant/death_alarm
	name = "death alarm"
	id = "implant_death"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_DATA = 2)
	build_path = /obj/item/weapon/implantcase/death_alarm
	sort_string = "MFAAB"

/datum/design/item/implant/tracking
	name = "tracking implant"
	id = "implant_tracking"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_BLUESPACE = 3)
	build_path = /obj/item/weapon/implantcase/tracking
	sort_string = "MFAAC"

/datum/design/item/implant/imprinting
	name = "imprinting implant"
	id = "implant_imprinting"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_DATA = 4)
	build_path = /obj/item/weapon/implantcase/imprinting
	sort_string = "MFAAD"

/datum/design/item/implant/adrenaline
	name = "adrenaline implant"
	id = "implant_adrenaline"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ILLEGAL = 3)
	build_path = /obj/item/weapon/implantcase/adrenalin
	sort_string = "MFAAE"

/datum/design/item/implant/freedom
	name = "freedom implant"
	id = "implant_free"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ILLEGAL = 3)
	build_path = /obj/item/weapon/implantcase/freedom
	sort_string = "MFAAF"

/datum/design/item/implant/explosive
	name = "explosive implant"
	id = "implant_explosive"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ILLEGAL = 4)
	build_path = /obj/item/weapon/implantcase/explosive
	sort_string = "MFAAG"

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

/datum/design/item/weapon/anti_photon
	name = "anti-photon grenade"
	id = "anti_photon"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 1000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/weapon/grenade/anti_photon
	sort_string = "TABAB"

/datum/design/item/weapon/advancedflash
	name = "advanced flash"
	id = "advancedflash"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 2000, MATERIAL_SILVER = 500)
	build_path = /obj/item/device/flash/advanced
	sort_string = "TADAA"

/datum/design/item/weapon/stunrevolver
	name = "stun revolver"
	id = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MATERIAL_STEEL = 4000)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	sort_string = "TADAB"

/datum/design/item/weapon/stunrifle
	name = "stun rifle"
	id = "stun_rifle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_GLASS = 1000, MATERIAL_SILVER = 500)
	build_path = /obj/item/weapon/gun/energy/stunrevolver/rifle
	sort_string = "TADAC"

/datum/design/item/weapon/contactbeam
	name = "C99 Supercollider Contact Beam"
	id = "contactbeam"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000, "diamond" = 400)
	build_path = /obj/item/weapon/gun/energy/contact
	sort_string = "TAEAA"

/datum/design/item/weapon/miningcutter
	name = "210-V mining cutter"
	id = "miningcutter"
	req_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 3, TECH_POWER = 1)
	materials = list(MATERIAL_STEEL = 7500, MATERIAL_GLASS = 2500)
	build_path = /obj/item/weapon/gun/energy/cutter
	sort_string = "TAEAB"

/datum/design/item/weapon/plasmacutter
	name = "211-V plasma cutter"
	id = "plasmacutter"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 5000, "gold" = 400)
	build_path = /obj/item/weapon/gun/energy/cutter/plasma
	sort_string = "TAEAC"

/datum/design/item/weapon/divet
	name = "Winchester NK Divet pistol"
	id = "divet"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_SILVER = 4000)
	build_path = /obj/item/weapon/gun/projectile/divet
	sort_string = "TACEA"

/datum/design/item/weapon/divetslug
	name = "divet magazine"
	id = "divetslug"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 4000)
	build_path = /obj/item/ammo_magazine/divet
	sort_string = "TACEB"

<<<<<<< HEAD
=======
/datum/design/item/weapon/fiftycal/ammo
	name = ".50 AE magazine"
	id = "50cal"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5)
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_GOLD = 2000, MATERIAL_DIAMOND = 1000, MATERIAL_PLASTEEL = 2000) // Plasteel can be changed to deuterium later when I get around to defining material for it. If you have an idea for a reagent that could be used to minimize production of these, please add it.
	build_path = /obj/item/ammo_magazine/a50
	sort_string = "TACEH"

>>>>>>> a7c5293c0f98745acf8bf4c5db8ad4b30826482f
/datum/design/item/weapon/pulserifle
	name = "SWS Motorized Pulse Rifle"
	id = "pulserifle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5)
	materials = list(MATERIAL_STEEL = 30000, MATERIAL_GLASS = 2000, MATERIAL_SILVER = 4000, MATERIAL_URANIUM = 4000) // times 6 the cost of a contact beam, the basic idea is that the massive steel cost will make getting a lot difficult due to transport of materials, what if you just brought the R&D set down to cargo, not gonna work because I'm pretty sure R&D servers aren't Multi-Z.
	build_path = /obj/item/weapon/gun/projectile/automatic/pulse_rifle
	sort_string = "TBECF"

/datum/design/item/weapon/pulseslug
	name = "rifle slug magazine"
	id = "pulseslug"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 10000) // Same thing here. It might need tweaking with exotic materials to stop people getting a lot of it early on though.
	build_path = /obj/item/ammo_magazine/pulse
	sort_string = "TBECD"

/datum/design/item/weapon/grenadelauncher
	name = "junk grenade launcher"
	id = "grenadelauncher"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/weapon/gun/launcher/grenade
	sort_string = "TAGAA"

/datum/design/item/weapon/flechette
	name = "F1-73 Fletchette Launcher"
	id = "flechette"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(MATERIAL_STEEL = 8000, MATERIAL_GOLD = 4000, MATERIAL_SILVER = 4000, MATERIAL_DIAMOND = 2000)
	build_path = /obj/item/weapon/gun/magnetic/railgun/flechette
	sort_string = "TAHAA"

/datum/design/item/stock_part/subspace_ansible
	name = "subspace ansible"
	id = "s-ansible"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 80, MATERIAL_SILVER = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/ansible
	sort_string = "UAAAA"

/datum/design/item/stock_part/hyperwave_filter
	name = "hyperwave filter"
	id = "s-filter"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	materials = list(MATERIAL_STEEL = 40, MATERIAL_SILVER = 10)
	build_path = /obj/item/weapon/stock_parts/subspace/filter
	sort_string = "UAAAB"

/datum/design/item/stock_part/subspace_amplifier
	name = "subspace amplifier"
	id = "s-amplifier"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GOLD = 30, "uranium" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/amplifier
	sort_string = "UAAAC"

/datum/design/item/stock_part/subspace_treatment
	name = "subspace treatment disk"
	id = "s-treatment"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_SILVER = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/treatment
	sort_string = "UAAAD"

/datum/design/item/stock_part/subspace_analyzer
	name = "subspace wavelength analyzer"
	id = "s-analyzer"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GOLD = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/analyzer
	sort_string = "UAAAE"

/datum/design/item/stock_part/subspace_crystal
	name = "ansible crystal"
	id = "s-crystal"
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_GLASS = 1000, MATERIAL_SILVER = 20, MATERIAL_GOLD = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/crystal
	sort_string = "UAAAF"

/datum/design/item/stock_part/subspace_transmitter
	name = "subspace transmitter"
	id = "s-transmitter"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	materials = list(MATERIAL_GLASS = 100, MATERIAL_SILVER = 10, "uranium" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/transmitter
	sort_string = "UAAAG"

/datum/design/item/biostorage/AssembleDesignName()
	..()
	name = "Biological intelligence storage ([item_name])"

/datum/design/item/biostorage/neural_lace
	name = "neural lace"
	id = "neural lace"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_DATA = 3)
	materials = list (MATERIAL_STEEL = 10000, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 1000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/organ/internal/stack
	sort_string = "VACBA"

/datum/design/item/bluespace/AssembleDesignName()
	..()
	name = "Bluespace device ([item_name])"

/datum/design/item/bluespace/beacon
	name = "tracking beacon"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (MATERIAL_STEEL = 20, MATERIAL_GLASS = 10)
	build_path = /obj/item/device/radio/beacon
	sort_string = "VADAA"

/datum/design/item/bluespace/gps
	name = "triangulating device"
	desc = "Triangulates approximate co-ordinates using a nearby satellite network."
	id = "gps"
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 500)
	build_path = /obj/item/device/gps
	sort_string = "VADAB"

/datum/design/item/bluespace/beacon_locator
	name = "beacon tracking pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "beacon_locator"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials = list(MATERIAL_STEEL = 1000,MATERIAL_GLASS = 500)
	build_path = /obj/item/weapon/pinpointer/radio
	sort_string = "VADAC"

/datum/design/item/bluespace/ano_scanner
	name = "Alden-Saraspova counter"
	id = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(MATERIAL_STEEL = 10000,MATERIAL_GLASS = 5000)
	build_path = /obj/item/device/ano_scanner
	sort_string = "VAEAA"

// tools

/datum/design/item/tool/AssembleDesignName()
	..()
	name = "Tool design ([item_name])"

/datum/design/item/tool/light_replacer
	name = "light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 1500, MATERIAL_SILVER = 150, MATERIAL_GLASS = 3000)
	build_path = /obj/item/device/lightreplacer
	sort_string = "VAGAB"

/datum/design/item/tool/airlock_brace
	name = "airlock brace"
	desc = "Special door attachment that can be used to provide extra security."
	id = "brace"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 50)
	build_path = /obj/item/weapon/airlock_brace
	sort_string = "VAGAC"

/datum/design/item/tool/brace_jack
	name = "maintenance jack"
	desc = "A special maintenance tool that can be used to remove airlock braces."
	id = "bracejack"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 120)
	build_path = /obj/item/weapon/tool/crowbar/brace_jack
	sort_string = "VAGAD"

/datum/design/item/tool/clamp
	name = "stasis clamp"
	desc = "A magnetic clamp which can halt the flow of gas in a pipe, via a localised stasis field."
	id = "stasis_clamp"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MAGNET = 4)
	materials = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 500)
	build_path = /obj/item/clamp
	sort_string = "VAGAE"

/datum/design/item/tool/price_scanner
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	id = "price_scanner"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 3000, MATERIAL_SILVER = 250)
	build_path = /obj/item/device/price_scanner
	sort_string = "VAGAF"

/datum/design/item/tool/advanced_welder
	name = "advanced welding tool"
	desc = "This welding tool feels heavier in your possession than is normal."
	id = "experimental_welder"
	req_tech = list(TECH_ENGINEERING = 5, TECH_PHORON = 4)
	materials = list(MATERIAL_STEEL = 120, MATERIAL_GLASS = 50)
	build_path = /obj/item/weapon/tool/weldingtool/advanced
	sort_string = "VAGAG"

/datum/design/item/tool/oxycandle
	name = "oxycandle"
	desc = "a device which, via a chemical reaction, can pressurise small areas."
	id="oxycandle"
	req_tech = list(TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 3000)
	chemicals = list(/datum/reagent/sodiumchloride = 20, /datum/reagent/acetone = 20)
	build_path = /obj/item/device/oxycandle
	sort_string = "VAGAI"

/datum/design/item/encryptionkey/AssembleDesignName()
	..()
	name = "Encryption key design ([item_name])"

/datum/design/item/camouflage/AssembleDesignName()
	..()
	name = "Camouflage design ([item_name])"

// Superconductive magnetic coils
/datum/design/item/smes_coil/AssembleDesignName()
	..()
	name = "Superconductive magnetic coil ([item_name])"

/datum/design/item/smes_coil
	desc = "A superconductive magnetic coil used to store power in magnetic fields."
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000, MATERIAL_SILVER = 1000)

/datum/design/item/smes_coil/standard
	name = "superconductive magnetic coil"
	id = "smes_coil_standard"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/weapon/smes_coil
	sort_string = "VAXAA"

/datum/design/item/smes_coil/super_capacity
	name = "superconductive capacitance coil"
	id = "smes_coil_super_capacity"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 8, TECH_ENGINEERING = 6)
	build_path = /obj/item/weapon/smes_coil/super_capacity
	sort_string = "VAXAB"

/datum/design/item/smes_coil/super_io
	name = "superconductive transmission coil"
	id = "smes_coil_super_io"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 8, TECH_ENGINEERING = 6)
	build_path = /obj/item/weapon/smes_coil/super_io
	sort_string = "VAXAC"


// Modular computer components
// Hard drives
/datum/design/item/modularcomponent/disk/AssembleDesignName()
	..()
	name = "Hard drive design ([item_name])"

/datum/design/item/modularcomponent/disk/normal
	name = "basic hard drive"
	id = "hdd_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 400, MATERIAL_GLASS = 100)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/
	sort_string = "VBAAA"

/datum/design/item/modularcomponent/disk/advanced
	name = "advanced hard drive"
	id = "hdd_advanced"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 800, MATERIAL_GLASS = 200)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/advanced
	sort_string = "VBAAB"

/datum/design/item/modularcomponent/disk/super
	name = "super hard drive"
	id = "hdd_super"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 1600, MATERIAL_GLASS = 400)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/super
	sort_string = "VBAAC"

/datum/design/item/modularcomponent/disk/cluster
	name = "cluster hard drive"
	id = "hdd_cluster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 3200, MATERIAL_GLASS = 800)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/cluster
	sort_string = "VBAAD"

/datum/design/item/modularcomponent/disk/micro
	name = "micro hard drive"
	id = "hdd_micro"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 400, MATERIAL_GLASS = 100)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/micro
	sort_string = "VBAAE"

/datum/design/item/modularcomponent/disk/small
	name = "small hard drive"
	id = "hdd_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 800, MATERIAL_GLASS = 200)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/small
	sort_string = "VBAAF"

// Network cards
/datum/design/item/modularcomponent/netcard/AssembleDesignName()
	..()
	name = "Network card design ([item_name])"

/datum/design/item/modularcomponent/netcard/basic
	name = "basic network card"
	id = "netcard_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 250, MATERIAL_GLASS = 100)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/network_card
	sort_string = "VBABA"

/datum/design/item/modularcomponent/netcard/advanced
	name = "advanced network card"
	id = "netcard_advanced"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 200)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/network_card/advanced
	sort_string = "VBABB"

/datum/design/item/modularcomponent/netcard/wired
	name = "wired network card"
	id = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GLASS = 400)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/network_card/wired
	sort_string = "VBABC"

// Data crystals (USB flash drives)
/datum/design/item/modularcomponent/portabledrive/AssembleDesignName()
	..()
	name = "Portable drive design ([item_name])"

/datum/design/item/modularcomponent/portabledrive/basic
	name = "basic data crystal"
	id = "portadrive_basic"
	req_tech = list(TECH_DATA = 1)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 800)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable
	sort_string = "VBACA"

/datum/design/item/modularcomponent/portabledrive/advanced
	name = "advanced data crystal"
	id = "portadrive_advanced"
	req_tech = list(TECH_DATA = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 1600)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/advanced
	sort_string = "VBACB"

/datum/design/item/modularcomponent/portabledrive/super
	name = "super data crystal"
	id = "portadrive_super"
	req_tech = list(TECH_DATA = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 3200)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/super
	sort_string = "VBACC"

// Card slot
/datum/design/item/modularcomponent/accessory/AssembleDesignName()
	..()
	name = "Computer accessory ([item_name])"

/datum/design/item/modularcomponent/accessory/cardslot
	name = "RFID card slot"
	id = "cardslot"
	req_tech = list(TECH_DATA = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600)
	build_path = /obj/item/weapon/computer_hardware/card_slot
	sort_string = "VBADA"

// Nano printer
/datum/design/item/modularcomponent/accessory/nanoprinter
	name = "nano printer"
	id = "nanoprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600)
	build_path = /obj/item/weapon/computer_hardware/nano_printer
	sort_string = "VBADB"

// Tesla Link
/datum/design/item/modularcomponent/accessory/teslalink
	name = "tesla link"
	id = "teslalink"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 2000)
	build_path = /obj/item/weapon/computer_hardware/tesla_link
	sort_string = "VBADC"

//Scanners
/datum/design/item/modularcomponent/accessory/reagent_scanner
	name = "reagent scanner module"
	id = "scan_reagent"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2, TECH_BIO = 2, TECH_MAGNET = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600, MATERIAL_GLASS = 200)
	build_path = /obj/item/weapon/computer_hardware/scanner/reagent
	sort_string = "VBADD"

/datum/design/item/modularcomponent/accessory/paper_scanner
	name = "paper scanner module"
	id = "scan_paper"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600, MATERIAL_GLASS = 200)
	build_path = /obj/item/weapon/computer_hardware/scanner/paper
	sort_string = "VBADE"

/datum/design/item/modularcomponent/accessory/atmos_scanner
	name = "atmospheric scanner module"
	id = "scan_atmos"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2, TECH_MAGNET = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600, MATERIAL_GLASS = 200)
	build_path = /obj/item/weapon/computer_hardware/scanner/atmos
	sort_string = "VBADF"

/datum/design/item/modularcomponent/accessory/medical_scanner
	name = "medical scanner module"
	id = "scan_medical"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2, TECH_MAGNET = 2, TECH_BIO = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600, MATERIAL_GLASS = 200)
	build_path = /obj/item/weapon/computer_hardware/scanner/medical
	sort_string = "VBADG"

// Batteries
/datum/design/item/modularcomponent/battery/AssembleDesignName()
	..()
	name = "Battery design ([item_name])"

/datum/design/item/modularcomponent/battery/normal
	name = "standard battery module"
	id = "bat_normal"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 400)
	build_path = /obj/item/weapon/computer_hardware/battery_module
	sort_string = "VBAEA"

/datum/design/item/modularcomponent/battery/advanced
	name = "advanced battery module"
	id = "bat_advanced"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 800)
	build_path = /obj/item/weapon/computer_hardware/battery_module/advanced
	sort_string = "VBAEB"

/datum/design/item/modularcomponent/battery/super
	name = "super battery module"
	id = "bat_super"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 1600)
	build_path = /obj/item/weapon/computer_hardware/battery_module/super
	sort_string = "VBAEC"

/datum/design/item/modularcomponent/battery/ultra
	name = "ultra battery module"
	id = "bat_ultra"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 3200)
	build_path = /obj/item/weapon/computer_hardware/battery_module/ultra
	sort_string = "VBAED"

/datum/design/item/modularcomponent/battery/nano
	name = "nano battery module"
	id = "bat_nano"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 200)
	build_path = /obj/item/weapon/computer_hardware/battery_module/nano
	sort_string = "VBAEE"

/datum/design/item/modularcomponent/battery/micro
	name = "micro battery module"
	id = "bat_micro"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 400)
	build_path = /obj/item/weapon/computer_hardware/battery_module/micro
	sort_string = "VBAEF"

// Processor unit
/datum/design/item/modularcomponent/cpu/AssembleDesignName()
	..()
	name = "CPU design ([item_name])"

/datum/design/item/modularcomponent/cpu/
	name = "computer processor unit"
	id = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 1600)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/processor_unit
	sort_string = "VBAFA"

/datum/design/item/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	id = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 800)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/small
	sort_string = "VBAFB"

/datum/design/item/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	id = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 6400, glass = 2000)
	chemicals = list(/datum/reagent/acid = 40)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic
	sort_string = "VBAFC"

/datum/design/item/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 3200, glass = 1000)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic/small
	sort_string = "VBAFD"

//RIG Modules
//Sidenote; Try to keep a requirement of 5 engineering for each, but keep the rest as similiar to it's original as possible.
/datum/design/item/rig/AssembleDesignName()
	..()
	name = "RIG module ([item_name])"

/datum/design/item/rig/meson
	name = "Meson Scanner"
	desc = "A layered, translucent visor system for a RIG."
	id = "rig_meson"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200, "plastic" = 300)
	build_path = /obj/item/rig_module/vision/meson
	sort_string = "WCAAA"

/datum/design/item/rig/medhud
	name = "Medical HUD"
	desc = "A simple medical status indicator for a RIG."
	id = "rig_medhud"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200,  "plastic" = 300)
	build_path = /obj/item/rig_module/vision/medhud
	sort_string = "WCAAB"

/datum/design/item/rig/sechud
	name = "Security HUD"
	desc = "A simple security status indicator for a RIG."
	id = "rig_sechud"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200,  "plastic" = 300)
	build_path = /obj/item/rig_module/vision/sechud
	sort_string = "WCAAC"

/datum/design/item/rig/nvg
	name = "Night Vision"
	desc = "A night vision module, mountable on a RIG."
	id = "rig_nvg"
	req_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6)
	materials = list("plastic" = 500, MATERIAL_STEEL = 300, MATERIAL_GLASS = 200, "uranium" = 200)
	build_path = /obj/item/rig_module/vision/nvg
	sort_string = "WCAAD"

/datum/design/item/rig/healthscanner
	name = "Medical Scanner"
	desc = "A device able to distinguish vital signs of the subject, mountable on a RIG."
	id = "rig_healthscanner"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ENGINEERING = 5)
	materials = list("plastic" = 1000, MATERIAL_STEEL = 700, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/healthscanner
	sort_string = "WCBAA"

/datum/design/item/rig/drill
	name = "Mining Drill"
	desc = "A diamond mining drill, mountable on a RIG."
	id = "rig_drill"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 3500, MATERIAL_GLASS = 1500, MATERIAL_DIAMOND = 2000, "plastic" = 1000)
	build_path = /obj/item/rig_module/device/drill
	sort_string = "WCCAA"

/datum/design/item/rig/orescanner
	name = "Ore Scanner"
	desc = "A sonar system for detecting large masses of ore, mountable on a RIG."
	id = "rig_orescanner"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 4, TECH_ENGINEERING = 6)
	materials = list("plastic" = 1000, MATERIAL_STEEL = 800, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/orescanner
	sort_string = "WCDAA"

/datum/design/item/rig/anomaly_scanner
	name = "Anomaly Scanner"
	desc = "An exotic particle detector commonly used by xenoarchaeologists, mountable on a RIG."
	id = "rig_anomaly_scanner"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MAGNET = 4, TECH_ENGINEERING = 6)
	materials = list("plastic" = 1000, MATERIAL_STEEL = 800, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/anomaly_scanner
	sort_string = "WCDAB"

/datum/design/item/rig/rcd
	name = "RCD"
	desc = "A Rapid Construction Device, mountable on a RIG."
	id = "rig_rcd"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 5, TECH_ENGINEERING = 7)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 1000, "plastic" = 1000,MATERIAL_GOLD = 700, MATERIAL_SILVER = 700)
	build_path = /obj/item/rig_module/device/rcd
	sort_string = "WCEAA"

/datum/design/item/rig/jets
	name = "Maneuvering Jets"
	desc = "A compact gas thruster system, mountable on a RIG."
	id = "rig_jets"
	req_tech = list(TECH_MATERIAL = 6,  TECH_ENGINEERING = 7)
	materials = list(MATERIAL_STEEL = 3000, "plastic" = 2000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/rig_module/maneuvering_jets
	sort_string = "WCFAA"

//I think this is like a janitor thing but seems like it could be useful for engis
/datum/design/item/rig/decompiler
	name = "Matter Decompiler"
	desc = "A drone matter decompiler reconfigured to be mounted onto a RIG."
	id = "rig_decompiler"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 3000, "plastic" = 2000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/rig_module/device/decompiler
	sort_string = "WCGAA"

/datum/design/item/rig/powersink
	name = "Power Sink"
	desc = "A RIG module that allows the user to recharge their RIG's power cell without removing it."
	id = "rig_powersink"
	req_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000, "plastic" = 1000)
	build_path = /obj/item/rig_module/power_sink
	sort_string = "WCHAA"

/datum/design/item/rig/ai_container
	name = "IIS"
	desc = "An integrated intelligence system module suitable for most RIGs."
	id = "rig_ai_container"
	req_tech = list(TECH_DATA = 6, TECH_MATERIAL = 5, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 1000, "plastic" = 1000, MATERIAL_GOLD = 500)
	build_path = /obj/item/rig_module/ai_container
	sort_string = "WCIAA"

/datum/design/item/rig/flash
	name = "Flash"
	desc = "A normal flash, mountable on a RIG."
	id = "rig_flash"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 5)
	materials = list("plastic" = 1500, MATERIAL_STEEL = 1000, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/flash
	sort_string = "WCJAA"

/datum/design/item/rig/taser
	name = "Taser"
	desc = "A taser, mountable on a RIG."
	id = "rig_taser"
	req_tech = list(TECH_POWER = 5, TECH_COMBAT = 5, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 4000, "plastic" = 2500, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/rig_module/mounted/taser
	sort_string = "WCKAA"

/datum/design/item/rig/egun
	name = "Energy Gun"
	desc = "An energy gun, mountable on a RIG."
	id = "rig_egun"
	req_tech = list(TECH_POWER = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 3000, "plastic" = 2500, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 1000)
	build_path = /obj/item/rig_module/mounted/egun
	sort_string = "WCKAB"

/datum/design/item/rig/enet
	name = "Energy Net"
	desc = "An advanced energy-patterning projector used to capture targets, mountable on a RIG."
	id = "rig_enet"
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 6, TECH_MAGNET = 5, TECH_ILLEGAL = 4, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 3000, MATERIAL_DIAMOND = 2000, "plastic" = 2000)
	build_path = /obj/item/rig_module/fabricator/energy_net
	sort_string = "WCKAC"

/datum/design/item/rig/cooling_unit
	name = "Cooling Unit"
	desc = "A suit cooling unit, mountable on a RIG."
	id = "rig_cooler"
	req_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 3500, "plastic" = 2000)
	build_path = /obj/item/rig_module/cooling_unit
	sort_string = "WCLAB"


/datum/design/prefab
	name = "Device"
	desc = "A blueprint made from a design built here."
	materials = list(MATERIAL_STEEL = 200)
	id = "prefab"
	build_type = PROTOLATHE
	sort_string = "ZAAAA"
	var/decl/prefab/ic_assembly/fabrication
	var/global/count = 0

/datum/design/prefab/New(var/research, var/fab)
	if(fab)
		fabrication = fab
		materials = list(MATERIAL_STEEL = fabrication.metal_amount)
		build_path = /obj/item/device/electronic_assembly //put this here so that the default made one doesn't show up in protolathe list
		id = "prefab[++count]"
	sort_string = "Z"
	var/cur_count = count
	while(cur_count > 25)
		sort_string += ascii2text(cur_count%25+65)
		cur_count = (cur_count - cur_count%25)/25
	sort_string += ascii2text(cur_count + 65)
	while(length(sort_string) < 5)
		sort_string += "A"
	..()

/datum/design/prefab/AssembleDesignName()
	..()
	if(fabrication)
		name = "Device ([fabrication.assembly_name])"

/datum/design/prefab/Fabricate(var/newloc)
	if(!fabrication)
		return
	var/obj/O = fabrication.create(newloc)
	for(var/obj/item/integrated_circuit/circ in O.contents)
		circ.removable = 0
	return O

/*
CIRCUITS BELOW
*/

/datum/design/circuit
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 2)
	materials = list(MATERIAL_GLASS = 2000)
	chemicals = list(/datum/reagent/acid = 20)
	time = 5

/datum/design/circuit/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/weapon/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			name = "Machine circuit design ([item_name])"
		else if(initial(C.board_type) == "computer")
			name = "Computer circuit design ([item_name])"
		else
			name = "Circuit design ([item_name])"

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."

/datum/design/circuit/arcademachine
	name = "battle arcade machine"
	id = "arcademachine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/arcade/battle
	sort_string = "MAAAA"

/datum/design/circuit/oriontrail
	name = "orion trail arcade machine"
	id = "oriontrail"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/arcade/orion_trail
	sort_string = "MABAA"

/datum/design/circuit/prisonmanage
	name = "prisoner management console"
	id = "prisonmanage"
	build_path = /obj/item/weapon/circuitboard/prisoner
	sort_string = "DACAA"

/datum/design/circuit/operating
	name = "patient monitoring console"
	id = "operating"
	build_path = /obj/item/weapon/circuitboard/operating
	sort_string = "FACAA"

/datum/design/circuit/resleever
	name = "neural lace resleever"
	id = "resleever"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/resleever
	sort_string = "FAGAH"

/datum/design/circuit/crewconsole
	name = "crew monitoring console"
	id = "crewconsole"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/crew
	sort_string = "FAGAI"

/datum/design/circuit/rdconsole
	name = "R&D control console"
	id = "rdconsole"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/rdconsole
	sort_string = "HAAAA"

/datum/design/circuit/comm_monitor
	name = "telecommunications monitoring console"
	id = "comm_monitor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/comm_monitor
	sort_string = "HAACA"

/datum/design/circuit/comm_server
	name = "telecommunications server monitoring console"
	id = "comm_server"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/comm_server
	sort_string = "HAACB"

/datum/design/circuit/comm_traffic
	name = "telecommunications traffic control console"
	id = "comm_traffic"
	req_tech = list(TECH_DATA = 6)
	build_path = /obj/item/weapon/circuitboard/comm_traffic
	sort_string = "HAACC"

/datum/design/circuit/message_monitor
	name = "messaging monitor console"
	id = "message_monitor"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/weapon/circuitboard/message_monitor
	sort_string = "HAACD"

/datum/design/circuit/destructive_analyzer
	name = "destructive analyzer"
	id = "destructive_analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/destructive_analyzer
	sort_string = "HABAA"

/datum/design/circuit/protolathe
	name = "protolathe"
	id = "protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/protolathe
	sort_string = "HABAB"

/datum/design/circuit/circuit_imprinter
	name = "circuit imprinter"
	id = "circuit_imprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/circuit_imprinter
	sort_string = "HABAC"

/datum/design/circuit/autolathe
	name = "autolathe board"
	id = "autolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/autolathe
	sort_string = "HABAD"

/datum/design/circuit/rdservercontrol
	name = "R&D server control console"
	id = "rdservercontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/rdservercontrol
	sort_string = "HABBA"

/datum/design/circuit/rdserver
	name = "R&D server"
	id = "rdserver"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/rdserver
	sort_string = "HABBB"

/datum/design/circuit/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/mechfab
	sort_string = "HABAE"

/datum/design/circuit/atmosalerts
	name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/weapon/circuitboard/atmos_alert
	sort_string = "JAAAA"

/datum/design/circuit/air_management
	name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/weapon/circuitboard/air_management
	sort_string = "JAAAB"

/datum/design/circuit/rcon_console
	name = "RCON remote control console"
	id = "rcon_console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
	build_path = /obj/item/weapon/circuitboard/rcon_console
	sort_string = "JAAAC"

/datum/design/circuit/powermonitor
	name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/weapon/circuitboard/powermonitor
	sort_string = "JAAAD"

/datum/design/circuit/solarcontrol
	name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/weapon/circuitboard/solar_control
	sort_string = "JAAAE"

/datum/design/circuit/pacman
	name = "PACMAN-type generator"
	id = "pacman"
	req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/pacman
	sort_string = "JBAAA"

/datum/design/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	id = "superpacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/weapon/circuitboard/pacman/super
	sort_string = "JBAAB"

/datum/design/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	id = "mrspacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/weapon/circuitboard/pacman/mrs
	sort_string = "JBAAC"

/datum/design/circuit/batteryrack
	name = "cell rack PSU"
	id = "batteryrack"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/batteryrack
	sort_string = "JBABA"

/datum/design/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/weapon/circuitboard/smes
	sort_string = "JBABB"

/datum/design/circuit/gas_heater
	name = "gas heating system"
	id = "gasheater"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/heater
	sort_string = "JCAAA"

/datum/design/circuit/gas_cooler
	name = "gas cooling system"
	id = "gascooler"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/cooler
	sort_string = "JCAAB"

/datum/design/circuit/secure_airlock
	name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	id = "securedoor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/airlock_electronics/secure
	sort_string = "JDAAA"

/datum/design/circuit/biogenerator
	name = "biogenerator"
	id = "biogenerator"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/weapon/circuitboard/biogenerator
	sort_string = "KBAAA"

/datum/design/circuit/miningdrill
	name = "mining drill head"
	id = "mining drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/miningdrill
	sort_string = "KCAAA"

/datum/design/circuit/miningdrillbrace
	name = "mining drill brace"
	id = "mining drill brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/miningdrillbrace
	sort_string = "KCAAB"

/datum/design/circuit/tcom
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/tcom/AssembleDesignName()
	name = "Telecommunications machinery circuit design ([name])"
/datum/design/circuit/tcom/AssembleDesignDesc()
	desc = "Allows for the construction of a telecommunications [name] circuit board."

/datum/design/circuit/tcom/server
	name = "server mainframe"
	id = "tcom-server"
	build_path = /obj/item/weapon/circuitboard/telecomms/server
	sort_string = "PAAAA"

/datum/design/circuit/tcom/processor
	name = "processor unit"
	id = "tcom-processor"
	build_path = /obj/item/weapon/circuitboard/telecomms/processor
	sort_string = "PAAAB"

/datum/design/circuit/tcom/bus
	name = "bus mainframe"
	id = "tcom-bus"
	build_path = /obj/item/weapon/circuitboard/telecomms/bus
	sort_string = "PAAAC"

/datum/design/circuit/tcom/hub
	name = "hub mainframe"
	id = "tcom-hub"
	build_path = /obj/item/weapon/circuitboard/telecomms/hub
	sort_string = "PAAAD"

/datum/design/circuit/tcom/relay
	name = "relay mainframe"
	id = "tcom-relay"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/weapon/circuitboard/telecomms/relay
	sort_string = "PAAAE"

/datum/design/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	id = "tcom-broadcaster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/broadcaster
	sort_string = "PAAAF"

/datum/design/circuit/tcom/receiver
	name = "subspace receiver"
	id = "tcom-receiver"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/receiver
	sort_string = "PAAAG"

/datum/design/circuit/shield_generator
	name = "Shield Generator"
	desc = "Allows for the construction of a shield generator circuit board."
	id = "shield_generator"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/shield_generator
	sort_string = "VAAAC"

/datum/design/circuit/shield_diffuser
	name = "Shield Diffuser"
	desc = "Allows for the construction of a shield generator circuit board."
	id = "shield_diffuser"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/shield_diffuser
	sort_string = "VAAAB"

/datum/design/circuit/ntnet_relay
	name = "SolNet Quantum Relay"
	id = "ntnet_relay"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/ntnet_relay
	sort_string = "WAAAA"

/datum/design/circuit/integrated
	name = "integrated circuit"
	id = "integrated"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/integrated_printer
	sort_string = "WAAAS"