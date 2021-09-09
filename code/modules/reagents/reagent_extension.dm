/*
	A reagent extension is a usefully hollow framework for complex reagent effects on a mob.
	It is applied to the mob when any quantity of a reagent at all is put into their body.

	It recieves various proc hooks when things happen related to that reagent.
	Quantity increasing, running out, entering overdose state, etc

*/
/datum/extension/reagent

	var/datum/reagent/R
	flags = EXTENSION_FLAG_IMMEDIATE
	//If nonzero, this effect will remain on the victim for this much time after the reagent clears their body
	var/linger = 0
	var/linger_handle


/datum/extension/reagent/New(var/mob/holder, var/datum/reagent/R)
	src.R = R
	.=..()

/datum/extension/reagent/proc/Initialize()

/*
	This is called whenever the quantity of this reagent in the mob goes up.

	Note that no proc is called when it goes down, because that's constantly happening every tick and it'd be a lot of spam.
	Poll it periodically if you care about falling below specific levels
*/
/datum/extension/reagent/proc/volume_increased()

	//This could be set in a case where this reagent ran out, but the host recieved more of the chemical before the linger time expired. We reset that timer
	if (linger_handle)
		deltimer(linger_handle)

/*
	Called when there is no more of our reagent left in the host's body.
*/
/datum/extension/reagent/proc/reagent_expired()
	R = null //So we don't interfere with garbage collection. It will null out its own reference to us too

	if (linger)
		linger_handle = addtimer(CALLBACK(src, /datum/extension/proc/remove_self), linger, flags = TIMER_STOPPABLE)

	else
		remove_self()


/*
	Called each tick while the mob is in overdose state. Because that's how the reagent already handles it.
	Do your own tracking here if needed
*/
/datum/extension/reagent/proc/overdose()