/decl/hierarchy/supply_pack/security
	name = "Security"


// revamp note: idea  is that weapons legally should be permitted by security before code red+ for roleplay purposes -nianoru
// access note: items that are armory access should be permitted by the PSECO/CSECO as they are high level equipment


// TIER I: CODE GREEN / SECURITY ACCESS (bypassable by shooting crates, which is legal after code blue)

/decl/hierarchy/supply_pack/security/weapon_divetpistol
	name = "T1 Weaponry - Divet Pistol"
	contains = list(/obj/item/ammo_magazine/divet = 2,
	/obj/item/gun/projectile/divet/empty = 1)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper divet pistol crate"
	access = access_security

/decl/hierarchy/supply_pack/security/weapon_suppressionkit
	name = "T1 Weaponry - Suppression Kit"
	contains = list(/obj/item/reagent_containers/spray/pepper = 1,
					/obj/item/baton = 1,
					/obj/item/flash = 1)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper suppression kit crate"
	access = access_security

/decl/hierarchy/supply_pack/security/ammo_dsmag
	name = "T1 Ammunition - Divet Slugs Magazines"
	contains = list(/obj/item/ammo_magazine/divet = 3)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper ds magazine crate"
	access = access_security

/decl/hierarchy/supply_pack/security/ammo_drbmag
	name = "T1 Ammunition - Divet RB Magazines"
	contains = list(/obj/item/ammo_casing/ls_slug/rb = 3)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper drb magazine crate"
	access = access_security

/decl/hierarchy/supply_pack/security/armor_light
	name = "T1 Armor Kit - Light"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/light = 4,
					/obj/item/clothing/head/helmet = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper light armor kit crate"
	access = access_security

/decl/hierarchy/supply_pack/security/armor_ballistic
	name = "T1 Armor Kit - Ballistic"
	contains = list(/obj/item/clothing/head/helmet/ballistic = 4,
					/obj/item/clothing/suit/armor/bulletproof = 4)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper ballistic armor kit crate"
	access = access_security

/decl/hierarchy/supply_pack/security/forensics_auxkit
	name = "T1 Forensics - Auxiliary Kit"
	contains = list(/obj/item/forensics/sample_kit,
					/obj/item/forensics/sample_kit/powder,
					/obj/item/storage/box/swabs = 3,
					/obj/item/reagent_containers/spray/luminol)
	cost = 30
	containername = "\improper auxiliary tools crate"

/decl/hierarchy/supply_pack/security/forensics_equipment
	name = "T1 Forensics - Investigation Equipment"
	contains = list(/obj/item/storage/box/evidence = 2,
					/obj/item/radio/headset/headset_sec,
					/obj/item/taperoll/police,
					/obj/item/clothing/glasses/sunglasses,
					/obj/item/camera,
					/obj/item/folder/red,
					/obj/item/folder/blue,
					/obj/item/clothing/gloves/forensic,
					/obj/item/taperecorder,
					/obj/item/mass_spectrometer,
					/obj/item/camera_film = 2,
					/obj/item/storage/photo_album,
					/obj/item/reagent_scanner,
					/obj/item/storage/briefcase/crimekit = 2)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper investigation equipment crate"
	access = access_security

/decl/hierarchy/supply_pack/security/sec_biohazard_gear
	name = "T1 Misc. - Security Biohazard Gear"
	contains = list(/obj/item/clothing/head/bio_hood/security,
					/obj/item/clothing/suit/bio_suit/security,
					/obj/item/clothing/mask/gas,
					/obj/item/tank/oxygen,
					/obj/item/clothing/gloves/latex)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper security biohazard gear crate"
	access = access_security


// TIER II: CODE BLUE / SECURITY ACCESS (bypassable by shooting crate, which is legal after code blue)

/decl/hierarchy/supply_pack/security/weapon_sclshotgun
	name = "T2 Weaponry - SCL Shotgun"
	contains = list(/obj/item/gun/projectile/shotgun/bola_lancher = 1,
					/obj/item/ammo_magazine/shotgun = 2)
	cost = 80
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper SCL shotgun crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/ammo_dhpmag
	name = "T2 Ammunition - Divet HP Magazines"
	contains = list(/obj/item/ammo_magazine/divet/hollow_point = 3)
	cost = 45
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper dhp magazine crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/ammo_shotgunshells
	name = "T2 Ammunition - Shotgun Shells"
	contains = list(/obj/item/ammo_magazine/shotgun = 3)
	cost = 65
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper shotgun shells crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/shield_combat
	name = "T2 Shield Kit - Combat"
	contains = list(/obj/item/shield/riot = 2)
	cost = 140
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper shield kit crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/armor_unmarked
	name = "T2 Armor Kit - Unmarked"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/medium = 2,
					/obj/item/clothing/head/helmet =2)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper unmarked armor kit crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/armor_riotgear
	name = "T2 Armor Kit - Riot"
	contains = list(/obj/item/clothing/head/helmet/riot = 4,
					/obj/item/clothing/suit/armor/riot = 4,
					/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/teargas)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper armor riot kit crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/rig_security
	name = "T2 RIG - Security"
	contains = list(/obj/item/rig/pcsi/security = 1)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper security RIG crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/rig_patrol
	name = "T2 RIG - Patrol"
	contains = list(/obj/item/rig/riot/patrol = 1)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper patrol RIG crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/misc_secbarriers
	name = "T2 Misc. - Security Barriers"
	contains = list(/obj/machinery/deployable/barrier = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper security barriers crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/misc_shieldgenerators
	name = "T2 Misc. - Wall Shield Generators"
	contains = list(/obj/machinery/shieldwallgen = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper wall shield generators crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED


// TIER III: CODE RED+ / CREW ACCESS

/decl/hierarchy/supply_pack/security/weapon_pulserifle
	name = "T3 Weaponry - Pulse Rifle"
	contains = list(/obj/item/ammo_magazine/pulse = 2,
	/obj/item/gun/projectile/automatic/pulse_rifle = 1)
	cost = 90
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper pulse rifle crate"
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/weapon_seeker
	name = "T3 Weaponry - Seeker Rifle"
	contains = list(/obj/item/ammo_magazine/seeker = 4,
	/obj/item/gun/projectile/seeker/empty = 1)
	cost = 130
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper seeker rifle crate"
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/weapon_heavypulserifle
	name = "T3 Weaponry - Heavy Pulse Rifle"
	contains = list(/obj/item/gun/projectile/automatic/pulse_heavy = 1)
	cost = 450
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper HPR crate"
	security_level = SUPPLY_SECURITY_HIGH
	access = access_armory //requires armory access for balance purposes

/decl/hierarchy/supply_pack/security/ammo_pulsernds
	name = "T3 Ammunition - Pulse Rounds"
	contains = list(/obj/item/ammo_magazine/pulse = 4)
	cost = 75
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper pulse rounds crate"
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/ammo_seekershells
	name = "T3 Ammunition - Seeker Shells"
	contains = list(/obj/item/ammo_magazine/seeker = 4)
	cost = 80
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper seeker shells crate"
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/shield_advcombat
	name = "T3 Shield Kit - Advanced Combat"
	contains = list(/obj/item/shield/riot/advanced = 1)
	cost = 160
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper advanced shield kit crate"
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/rig_vintage
	name = "T3 RIG - Antique CEC"
	contains = list(/obj/item/rig/vintage = 1)
	cost = 200
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper antique CEC RIG crate"
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/rig_advanced
	name = "T3 RIG - Advanced"
	contains = list(/obj/item/rig/advanced = 1)
	cost = 190
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper advanced RIG crate"
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/rig_riot
	name = "T3 RIG - Riot"
	contains = list(/obj/item/rig/riot = 1)
	cost = 180
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper riot RIG crate"
	security_level = SUPPLY_SECURITY_HIGH