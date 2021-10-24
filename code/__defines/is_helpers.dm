
#define isweakref(D) (istype(D, /datum/weakref))

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define isalien(A) istype(A, /mob/living/carbon/alien)

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isatom(A) istype(A, /atom)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define iscarbon(A) istype(A, /mob/living/carbon)

#define iscolorablegloves(A) (istype(A, /obj/item/clothing/gloves/color)||istype(A, /obj/item/clothing/gloves/insulated)||istype(A, /obj/item/clothing/gloves/thick))

#define isclient(A) istype(A, /client)

#define isclothing(A)	istype(A, /obj/item/clothing)

#define iscorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define iscredits(A) istype(A, /obj/item/weapon/spacecash/ewallet)

#define is_drone(A) istype(A, /mob/living/silicon/robot/drone)

#define isEye(A) istype(A, /mob/dead/observer/eye)

#define ishuman(A) istype(A, /mob/living/carbon/human)

#define isitem(A) istype(A, /obj/item)

#define islist(A) istype(A, /list)

#define isliving(A) istype(A, /mob/living)

#define ismouse(A) istype(A, /mob/living/simple_animal/mouse)

#define ismovable(A) istype(A, /atom/movable)

#define isnewplayer(A) istype(A, /mob/dead/new_player)

#define isobj(A) istype(A, /obj)

#define isghost(A) istype(A, /mob/dead/observer/ghost)

#define isobserver(A) istype(A, /mob/dead/observer)

#define isorgan(A) istype(A, /obj/item/organ/external)

#define isprojectile(A)	istype(A, /obj/item/projectile)

#define isrig(A)	istype(A, /obj/item/weapon/rig)

#define issignal(A) istype(A, /mob/dead/observer/eye/signal)

#define isstack(A) istype(A, /obj/item/stack)

#define isspace(A) istype(A, /area/space)

#define isspaceturf(A) istype(A, /turf/space)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define issilicon(A) istype(A, /mob/living/silicon)

#define isslime(A) istype(A, /mob/living/carbon/slime)

#define isstructure(A)	istype(A, /obj/structure)

#define isbst(A) istype(A, /mob/living/carbon/human/bst)

#define isunderwear(A) istype(A, /obj/item/underwear)

#define isvirtualmob(A) istype(A, /mob/dead/observer/virtual)

#define attack_animation(A) if(istype(A)) A.do_attack_animation(src)

#define isopenspace(A) istype(A, /turf/simulated/open)

#define isWrench(A) A.has_quality(QUALITY_BOLT_TURNING)

#define isWelder(A) A.has_quality(QUALITY_WELDING)

#define isCoil(A) istype(A, /obj/item/stack/cable_coil)

#define iswindow(A)	istype(A, /obj/structure/window)

#define isWirecutter(A) A.has_quality(QUALITY_WIRE_CUTTING)

#define isScrewdriver(A) A.has_quality(QUALITY_SCREW_DRIVING)

#define isMultitool(A) A.has_quality(QUALITY_PULSING)

#define isCrowbar(A) A.has_quality(QUALITY_PRYING)

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

#define iscloset(A)	istype(A, /obj/structure/closet)

#define istable(A)	istype(A, /obj/structure/table)

#define islight(A)	istype(A, /obj/machinery/light)
