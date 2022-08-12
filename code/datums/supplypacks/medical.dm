/decl/hierarchy/supply_pack/medical
	name = "Medical"
	containertype = /obj/structure/closet/crate/medical

/decl/hierarchy/supply_pack/medical/medical
	name = "Medical crate"
	contains = list(/obj/item/storage/firstaid/regular,
					/obj/item/storage/firstaid/trauma,
					/obj/item/storage/firstaid/fire,
					/obj/item/storage/firstaid/toxin,
					/obj/item/storage/firstaid/o2,
					/obj/item/storage/firstaid/adv,
					/obj/item/storage/firstaid/stab,
					/obj/item/reagent_containers/glass/bottle/antitoxin,
					/obj/item/reagent_containers/glass/bottle/inaprovaline,
					/obj/item/reagent_containers/glass/bottle/stoxin,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/autoinjectors)
	cost = 70
	containername = "\improper Medical crate"

/decl/hierarchy/supply_pack/medical/atk
	name = "Advanced trauma crate"
	contains = list(/obj/item/stack/medical/advanced/bruise_pack = 6)
	cost = 30
	containername = "\improper Advanced trauma crate"

/decl/hierarchy/supply_pack/medical/abk
	name = "Advanced burn crate"
	contains = list(/obj/item/stack/medical/advanced/ointment = 6)
	cost = 30
	containername = "\improper Advanced burn crate"

/decl/hierarchy/supply_pack/medical/trauma
	name = "Trauma pouch crate"
	contains = list(/obj/item/storage/firstaid/trauma = 3)
	cost = 10
	containername = "\improper Trauma pouch crate"

/decl/hierarchy/supply_pack/medical/burn
	name = "Burn pouch crate"
	contains = list(/obj/item/storage/firstaid/fire = 3)
	cost = 10
	containername = "\improper Burn pouch crate"

/decl/hierarchy/supply_pack/medical/toxin
	name = "Toxin pouch crate"
	contains = list(/obj/item/storage/firstaid/toxin = 3)
	cost = 10
	containername = "\improper Toxin pouch crate"

/decl/hierarchy/supply_pack/medical/oxyloss
	name = "Low oxygen pouch crate"
	contains = list(/obj/item/storage/firstaid/o2 = 3)
	cost = 10
	containername = "\improper Low oxygen pouch crate"

/decl/hierarchy/supply_pack/medical/stab
	name = "Stability kit crate"
	contains = list(/obj/item/storage/firstaid/stab = 3)
	cost = 60
	containername = "\improper Stability kit crate"

/decl/hierarchy/supply_pack/medical/bloodpack
	name = "Blood pack crate"
	contains = list(/obj/item/storage/box/bloodpacks = 3)
	cost = 10
	containername = "\improper Blood pack crate"

/decl/hierarchy/supply_pack/medical/blood
	name = "Nanoblood crate"
	contains = list(/obj/item/reagent_containers/ivbag/nanoblood = 4)
	cost = 15
	containername = "\improper Nanoblood crate"

/decl/hierarchy/supply_pack/medical/bodybag
	name = "Body bag crate"
	contains = list(/obj/item/storage/box/bodybags = 3)
	cost = 10
	containername = "\improper Body bag crate"

/decl/hierarchy/supply_pack/medical/cryobag
	name = "Stasis bag crate"
	contains = list(/obj/item/bodybag/cryobag = 3)
	cost = 50
	containername = "\improper Stasis bag crate"

/decl/hierarchy/supply_pack/medical/medicalextragear
	name = "Medical surplus equipment"
	contains = list(/obj/item/storage/belt/medical = 3,
					/obj/item/clothing/glasses/hud/health = 3)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Medical surplus equipment"
	access = access_medical

/decl/hierarchy/supply_pack/medical/smogear
	name = "Senior Medical Officer equipment"
	contains = list(/obj/item/storage/belt/medical,
					/obj/item/radio/headset/heads/smo,
					/obj/item/clothing/under/deadspace/senior_medical_officer,
					/obj/item/reagent_containers/hypospray/vial,
					/obj/item/clothing/accessory/stethoscope,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/mask/surgical,
					/obj/item/clothing/shoes/white,
					/obj/item/clothing/gloves/latex,
					/obj/item/healthanalyzer,
					/obj/item/flashlight/pen,
					/obj/item/reagent_containers/syringe)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Senior Medical Officer equipment"
	access = access_smo

/decl/hierarchy/supply_pack/medical/doctorgear
	name = "Medical Doctor equipment"
	contains = list(/obj/item/storage/belt/medical,
					/obj/item/radio/headset/headset_med,
					/obj/item/clothing/under/deadspace/doctor,
					/obj/item/clothing/accessory/stethoscope,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/mask/surgical,
					/obj/item/storage/firstaid/adv,
					/obj/item/clothing/shoes/white,
					/obj/item/clothing/gloves/latex,
					/obj/item/healthanalyzer,
					/obj/item/flashlight/pen,
					/obj/item/reagent_containers/syringe)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Medical Doctor equipment"
	access = access_medical

/decl/hierarchy/supply_pack/medical/psychiatristgear
	name = "Psychiatrist equipment"
	contains = list(/obj/item/clothing/under/rank/psych,
					/obj/item/radio/headset/headset_med,
					/obj/item/clothing/under/rank/psych/sweater,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/clothing/shoes/white,
					/obj/item/clipboard,
					/obj/item/folder/white,
					/obj/item/pen)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Psychiatrist equipment"
	access = access_medical

/decl/hierarchy/supply_pack/medical/medicalscrubs
	name = "Medical scrubs"
	contains = list(/obj/item/clothing/shoes/white = 4,
					/obj/item/clothing/under/rank/medical/scrubs/blue,
					/obj/item/clothing/under/rank/medical/scrubs/green,
					/obj/item/clothing/under/rank/medical/scrubs/purple,
					/obj/item/clothing/under/rank/medical/scrubs/black,
					/obj/item/clothing/head/surgery/black,
					/obj/item/clothing/head/surgery/purple,
					/obj/item/clothing/head/surgery/blue,
					/obj/item/clothing/head/surgery/green,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Medical scrubs crate"
	access = access_medical

/decl/hierarchy/supply_pack/medical/autopsy
	name = "Autopsy equipment"
	contains = list(/obj/item/folder/white,
					/obj/item/camera,
					/obj/item/camera_film = 2,
					/obj/item/autopsy_scanner,
					/obj/item/tool/scalpel,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves,
					/obj/item/pen)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Autopsy equipment crate"
	access = access_medical

/decl/hierarchy/supply_pack/medical/medicaluniforms
	name = "Medical uniforms"
	contains = list(/obj/item/clothing/shoes/white = 3,
					/obj/item/clothing/under/deadspace/surgeon = 2,
					/obj/item/clothing/under/deadspace/doctor = 4,
					/obj/item/clothing/under/deadspace/senior_medical_officer,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Medical uniform crate"
	access = access_medical

/decl/hierarchy/supply_pack/medical/medicalbiosuits
	name = "Medical biohazard gear"
	contains = list(/obj/item/clothing/head/bio_hood = 3,
					/obj/item/clothing/suit/bio_suit = 3,
					/obj/item/clothing/head/bio_hood/virology = 2,
					/obj/item/clothing/suit/bio_suit/cmo = 2,
					/obj/item/clothing/mask/gas = 5,
					/obj/item/tank/oxygen = 5,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Medical biohazard equipment"
	access = access_medical

/decl/hierarchy/supply_pack/medical/portablefreezers
	name = "Portable freezers crate"
	contains = list(/obj/item/storage/box/freezer = 7)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Portable freezers"
	access = access_medical

/decl/hierarchy/supply_pack/medical/surgery
	name = "Surgery crate"
	contains = list(/obj/item/tool/cautery,
					/obj/item/tool/surgicaldrill,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/tank/anesthetic,
					/obj/item/FixOVein,
					/obj/item/tool/hemostat,
					/obj/item/tool/scalpel,
					/obj/item/bonegel,
					/obj/item/tool/retractor,
					/obj/item/tool/bonesetter,
					/obj/item/tool/saw/circular)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Surgery crate"
	access = access_medical

/decl/hierarchy/supply_pack/medical/sterile
	name = "Sterile equipment crate"
	contains = list(/obj/item/clothing/under/rank/medical/scrubs/green = 2,
					/obj/item/clothing/head/surgery/green = 2,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves,
					/obj/item/storage/belt/medical = 3)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "\improper Sterile equipment crate"

/decl/hierarchy/supply_pack/medical/voidsuit
	name = "Medical voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/medical/alt,
					/obj/item/clothing/head/helmet/space/void/medical/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 120
	containername = "\improper Medical voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_medical

/decl/hierarchy/supply_pack/medical/scanner_module
	name = "Medical scanner module crate"
	contains = list(/obj/item/computer_hardware/scanner/medical = 4)
	cost = 20
	containername = "\improper Medical scanner module crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_medical