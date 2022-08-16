/decl/hierarchy/supply_pack/security
	name = "Security"

/decl/hierarchy/supply_pack/security/lightarmor
	name = "Armor - Light"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/light = 4,
					/obj/item/clothing/head/helmet =4)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Light armor crate"
	access = access_security

/decl/hierarchy/supply_pack/security/armor
	name = "Armor - Unmarked"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/medium = 2,
					/obj/item/clothing/head/helmet =2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Armor crate"
	access = access_security
/*
/decl/hierarchy/supply_pack/security/tacticalarmor
	name = "Armor - Tactical"
	contains = list(/obj/item/clothing/under/tactical,
					/obj/item/clothing/suit/armor/pcarrier/tan/tactical,
					/obj/item/clothing/glasses/tacgoggles,
					/obj/item/storage/belt/holster/security/tactical,
					/obj/item/clothing/shoes/tactical,
					/obj/item/clothing/gloves/tactical)
	cost = 70
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Tactical armor crate"
	access = access_armory
*/
/decl/hierarchy/supply_pack/security/blackguards
	name = "Armor - Arm and leg guards, black"
	contains = list(/obj/item/clothing/accessory/armguards = 2,
					/obj/item/clothing/accessory/legguards = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Arm and leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/blueguards
	name = "Armor - Arm and leg guards, blue"
	contains = list(/obj/item/clothing/accessory/armguards/blue = 2,
					/obj/item/clothing/accessory/legguards/blue = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Arm and leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/greenguards
	name = "Armor - Arm and leg guards, green"
	contains = list(/obj/item/clothing/accessory/armguards/green = 2,
					/obj/item/clothing/accessory/legguards/green = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Arm and leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/navyguards
	name = "Armor - Arm and leg guards, navy blue"
	contains = list(/obj/item/clothing/accessory/armguards/navy = 2,
					/obj/item/clothing/accessory/legguards/navy = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Arm and leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/tanguards
	name = "Armor - Arm and leg guards, tan"
	contains = list(/obj/item/clothing/accessory/armguards/tan = 2,
					/obj/item/clothing/accessory/legguards/tan = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Arm and leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/riotarmor
	name = "Armor - Riot gear"
	contains = list(/obj/item/shield/riot = 4,
					/obj/item/clothing/head/helmet/riot = 4,
					/obj/item/clothing/suit/armor/riot = 4,
					/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/teargas)
	cost = 80
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Riot armor crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/ballisticarmor
	name = "Armor - Ballistic"
	contains = list(/obj/item/clothing/head/helmet/ballistic = 4,
					/obj/item/clothing/suit/armor/bulletproof = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Ballistic suit crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/rig
	name = "Armor - Security RIG"
	contains = list(/obj/item/rig/security)
	cost = 120
	containername = "\improper Security RIG crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_security

/decl/hierarchy/supply_pack/security/rig
	name = "Armor - Riot RIG"
	contains = list(/obj/item/rig/riot)
	cost = 240
	containername = "\improper Riot RIG crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_security

/decl/hierarchy/supply_pack/security/weapons
	name = "Weapons - Security basic"
	contains = list(/obj/item/reagent_containers/spray/pepper = 4,
					/obj/item/baton/loaded = 4)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Weapons crate"
	access = access_security

/decl/hierarchy/supply_pack/security/flashbang
	name = "Weapons - Flashbangs"
	contains = list(/obj/item/storage/box/flashbangs = 2)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Flashbang crate"
	access = access_security

/decl/hierarchy/supply_pack/security/teargas
	name = "Weapons - Tear gas grenades"
	contains = list(/obj/item/storage/box/teargas = 2)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Tear gas grenades crate"
	access = access_security

/decl/hierarchy/supply_pack/security/forensics //Not access-restricted so PIs can use it.
	name = "Forensics - Auxiliary tools"
	contains = list(/obj/item/forensics/sample_kit,
					/obj/item/forensics/sample_kit/powder,
					/obj/item/storage/box/swabs = 3,
					/obj/item/reagent_containers/spray/luminol)
	cost = 30
	containername = "\improper Auxiliary forensic tools crate"

/decl/hierarchy/supply_pack/security/detectivegear
	name = "Forensics - investigation equipment"
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
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Forensic equipment crate"
	access = access_security

/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Misc - Barrier crate"
	contains = list(/obj/machinery/deployable/barrier = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Security barrier crate"
	access = access_security

/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Misc - Wall shield Generators"
	contains = list(/obj/machinery/shieldwallgen = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper wall shield generators crate"
	access = access_security

/decl/hierarchy/supply_pack/security/securitybiosuit
	name = "Misc - Security biohazard gear"
	contains = list(/obj/item/clothing/head/bio_hood/security,
					/obj/item/clothing/suit/bio_suit/security,
					/obj/item/clothing/mask/gas,
					/obj/item/tank/oxygen,
					/obj/item/clothing/gloves/latex)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Security biohazard gear crate"
	access = access_security


/decl/hierarchy/supply_pack/security/random_weapon
	name = "Weapons - Assorted Surplus"
	contains = list(/obj/random/gun = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper surplus weapons crate"
	access = access_security

/decl/hierarchy/supply_pack/security/random_ammo
	name = "Ammunition - Assorted Surplus"
	contains = list(/obj/random/ammo = 7)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper surplus ammunition crate"
	access = access_security


/decl/hierarchy/supply_pack/security/divet
	name = "Weapon - Divet handgun"
	contains = list(/obj/item/ammo_magazine/divet = 3,
	/obj/item/gun/projectile/divet/empty = 1)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper divet handgun crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/divet_ammo
	name = "Ammunition - Divet Slugs"
	contains = list(/obj/item/ammo_magazine/divet = 6)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper divet slug crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED


/decl/hierarchy/supply_pack/security/pulse_rifle
	name = "Weapon - Pulse Rifle"
	contains = list(/obj/item/ammo_magazine/pulse = 3,
	/obj/item/gun/projectile/automatic/pulse_rifle = 1)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper pulse rifle crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/pulse_ammo
	name = "Ammunition - Pulse Rounds"
	contains = list(/obj/item/ammo_magazine/pulse = 6)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper pulse ammunition crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED


/decl/hierarchy/supply_pack/security/seeker_rifle
	name = "Weapon - Seeker Rifle"
	contains = list(/obj/item/ammo_magazine/seeker = 4,
	/obj/item/gun/projectile/seeker/empty = 1)
	cost = 80
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper seeker rifle crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/seeker_ammo
	name = "Ammunition - Seeker Shells"
	contains = list(/obj/item/ammo_magazine/seeker = 8)
	cost = 80
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper seeker shells crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

