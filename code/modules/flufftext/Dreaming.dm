
var/list/dreams = list(
	"an ID card","a bottle","a familiar face","a crewmember","a toolbox","a security officer","the captain",
	"voices from all around","deep space","a doctor","the engine","a unitologist","an ally","darkness",
	"light","a research assistant","a monkey","a catastrophe","a loved one","a gun","warmth","freezing","the sun",
	"a hat","a ruined station","a planet",MATERIAL_PHORON,"air","the medical bay","the bridge","blinking lights",
	"a blue light","an abandoned laboratory","EarthGov","CEC","pirates", "mercenaries","blood","healing","power","respect",
	"riches","space","a crash","happiness","pride","a fall","water","flames","ice","melons","flying","the eggs","money",
	"the chief engineer","the chief science officer","the chief medical officer",
	"a technical engineer",
	"a cargo technician","the botanist","a planet cracker","the research assistant",
	"a line cook","the bartender","a librarian","a mouse",
	"a beach","a smokey room","a voice","the cold","an operating table","the rain","a beaker of strange liquid","the supermatter", "a creature built completely of stolen flesh",
	"a GAS", "a being made of light", "the first lieutenant", "the bridge ensign", "the chief security officer",
	"the earthgov offical",
	"an old friend", "the chief security officer",
	"the security officer", "the tower", "the man with no face", "a field of flowers", "an old home", "the merc",
	"a surgery table", "a needle", "a blade", "an ocean", "right behind you", "standing above you", "someone near by", "a place forgotten", "the exodus",
	)

mob/living/carbon/proc/dream()
	dreaming = 1

	spawn(0)
		for(var/i = rand(1,4),i > 0, i--)
			to_chat(src, "<span class='notice'><i>... [pick(dreams)] ...</i></span>")
			sleep(rand(40,70))
			if(paralysis <= 0)
				dreaming = 0
				return
		dreaming = 0
		return

mob/living/carbon/proc/handle_dreams()
	if(client && !dreaming && prob(5))
		dream()

mob/living/carbon/var/dreaming = 0
