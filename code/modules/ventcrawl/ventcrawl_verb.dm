/mob/living/proc/ventcrawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Abilities"
	var/pipe = start_ventcrawl()
	if(pipe)
		handle_ventcrawl()


/obj/machinery/atmospherics/unary/vent/verb/ventcrawl_verb()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Abilities"
	set src in view()
	
	
	var/mob/living/L = usr
	if (L && locate(/mob/living/proc/ventcrawl) in L.verbs)
		L.ventcrawl()
	else
		to_chat(L, SPAN_DANGER("You don't have the ability to ventcrawl!"))
