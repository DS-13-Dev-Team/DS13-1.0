/**
 * Paper
 * also scraps of paper
 */

#define MAX_PAPER_LENGTH 5000
#define MAX_PAPER_STAMPS 30 // Too low?
#define MAX_PAPER_STAMPS_OVERLAYS 4
#define MODE_READING 0
#define MODE_WRITING 1
#define MODE_STAMPING 2

/obj/item/weapon/paper
	name = "sheet of paper"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	randpixel = 8
	throwforce = 0
	w_class = ITEM_SIZE_TINY
	throw_range = 1

	layer = ABOVE_OBJ_LAYER
	slot_flags = SLOT_HEAD
	body_parts_covered = HEAD
	attack_verb = list("bapped")

	/// What's actually written on the paper.
	var/info = ""

	/// The (text for the) stamps on the paper.
	var/list/stamps /// Positioning for the stamp in tgui
	var/list/stamped /// Overlay info

	var/fields		//Amount of user created fields
	var/free_space = MAX_PAPER_MESSAGE_LEN
	var/list/ico[0]      //Icons and
	var/list/offset_x[0] //offsets stored for later
	var/list/offset_y[0] //usage by the photocopier
	var/rigged = 0
	var/spam_flag = 0

	/// When the sheet can be "filled out"
	/// This is an associated list
	var/list/form_fields = list()
	var/field_counter = 1

/obj/item/weapon/paper/Destroy()
	form_fields = null
	. = ..()

/obj/item/weapon/paper/update_icon()
	if(icon_state == "paper_talisman")
		return
	else if(info)
		icon_state = "paper_words"
	else
		icon_state = "paper"

/obj/item/weapon/paper/examine(mob/user)
	. = ..()
	if(name != "sheet of paper")
		to_chat(user, "It's titled '[name]'.")
	if(in_range(user, src) || isghost(user))
		tgui_interact(user)
	else
		to_chat(user, "<span class='notice'>You have to go closer if you want to read it.</span>")

/obj/item/paper/ui_status(mob/user,/datum/ui_state/state)
	if(!in_range(user, src) && !isobserver(user))
		return UI_CLOSE
	if(user.incapacitated(TRUE, TRUE) || (isobserver(user) && !IsAdminGhost(user)))
		return UI_UPDATE
	return ..()

/obj/item/weapon/paper/verb/rename()
	set name = "Rename paper"
	set category = "Object"
	set src in usr

	if((CLUMSY in usr.mutations) && prob(50))
		to_chat(usr, "<span class='warning'>You cut yourself on the paper.</span>")
		return
	var/n_name = sanitizeSafe(input(usr, "What would you like to label the paper?", "Paper Labelling", null)  as text, MAX_NAME_LEN)

	// We check loc one level up, so we can rename in clipboards and such. See also: /obj/item/weapon/photo/rename()
	if((loc == usr || loc.loc && loc.loc == usr) && usr.stat == 0 && n_name)
		SetName(n_name)
		add_fingerprint(usr)

/obj/item/weapon/paper/attack_self(mob/living/user as mob)
	if(user.a_intent == I_HURT)
		if(icon_state == "scrap")
			user.show_message("<span class='warning'>\The [src] is already crumpled.</span>")
			return
		//crumple dat paper
		info = stars(info,85)
		user.visible_message("\The [user] crumples \the [src] into a ball!")
		icon_state = "scrap"
		return
	user.examinate(src)
	if(rigged && (Holiday == "April Fool's Day"))
		if(spam_flag == 0)
			spam_flag = 1
			playsound(loc, 'sound/items/bikehorn.ogg', 50, 1)
			spawn(20)
				spam_flag = 0

/obj/item/weapon/paper/attack_ai(var/mob/living/silicon/ai/user)
	tgui_interact(user)

/obj/item/weapon/paper/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(get_zone_sel(user) == BP_EYES)
		user.visible_message("<span class='notice'>You show the paper to [M]. </span>", \
			"<span class='notice'> [user] holds up a paper and shows it to [M]. </span>")
		M.examinate(src)

	else if(get_zone_sel(user) == BP_MOUTH) // lipstick wiping
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H == user)
				to_chat(user, "<span class='notice'>You wipe off the lipstick with [src].</span>")
				H.lip_style = null
				H.update_body()
			else
				user.visible_message("<span class='warning'>[user] begins to wipe [H]'s lipstick off with \the [src].</span>", \
								 	 "<span class='notice'>You begin to wipe off [H]'s lipstick.</span>")
				if(do_after(user, 10, H) && do_after(H, 10, needhand = 0))	//user needs to keep their active hand, H does not.
					user.visible_message("<span class='notice'>[user] wipes [H]'s lipstick off with \the [src].</span>", \
										 "<span class='notice'>You wipe off [H]'s lipstick.</span>")
					H.lip_style = null
					H.update_body()


/obj/item/weapon/paper/proc/clearpaper()
	info = null
	stamps = null
	free_space = MAX_PAPER_MESSAGE_LEN
	stamped = list()
	overlays.Cut()
	update_icon()

/obj/item/weapon/paper/proc/get_signature(var/obj/item/weapon/pen/P, mob/user as mob)
	if(P && istype(P, /obj/item/weapon/pen))
		return P.get_signature(user)
	return (user && user.real_name) ? user.real_name : "Anonymous"

/obj/item/weapon/paper/proc/burn_with_object(obj/item/weapon/flame/P, mob/user)
	var/class = "warning"

	if(P.lit && !user.restrained())
		if(istype(P, /obj/item/weapon/flame/lighter/zippo))
			class = "rose"

		user.visible_message("<span class='[class]'>[user] holds \the [P] up to \the [src], it looks like \he's trying to burn it!</span>", \
		"<span class='[class]'>You hold \the [P] up to \the [src], burning it slowly.</span>")

		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P && P.lit)
				user.visible_message("<span class='[class]'>[user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
				"<span class='[class]'>You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")

				burn()

			else
				to_chat(user, "<span class='warning'>You must hold \the [P] steady to burn \the [src].</span>")

//We won't even bother with damage, paper exposed to fire is just gone
/obj/item/weapon/paper/fire_act()
	burn()

/obj/item/weapon/paper/proc/burn()
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)


/obj/item/weapon/paper/attackby(obj/item/P, mob/living/user, params)
	// Enable picking paper up by clicking on it with the clipboard or folder
	if(istype(P, /obj/item/weapon/clipboard) || istype(P, /obj/item/weapon/folder))
		P.attackby(src, user)
		return
	else if(istype(P, /obj/item/weapon/pen))
		if(length(info) >= MAX_PAPER_LENGTH) // Sheet must have less than 1000 charaters
			to_chat(user, "<span class='warning'>This sheet of paper is full!</span>")
			return
		tgui_interact(user)
		return
	else if(istype(P, /obj/item/weapon/stamp))
		to_chat(user, "<span class='notice'>You ready your stamp over the paper! </span>")
		tgui_interact(user)
		return /// Normaly you just stamp, you don't need to read the thing
	else
		// cut paper?  the sky is the limit!
		tgui_interact(user) // The other ui will be created with just read mode outside of this

	return ..()

/obj/item/weapon/paper/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/simple/paper),
	)

/obj/item/weapon/paper/tgui_interact(mob/user, datum/tgui/ui)
	// Update the UI
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PaperSheet", name)
		ui.open()


/obj/item/weapon/paper/ui_static_data(mob/user)
	. = list()
	.["text"] = info
	.["max_length"] = MAX_PAPER_LENGTH
	.["paper_color"] = !color || color == "white" ? "#FFFFFF" : color // color might not be set
	.["paper_state"] = icon_state /// TODO: show the sheet will bloodied or crinkling?
	.["stamps"] = stamps


/obj/item/weapon/paper/ui_data(mob/user)
	var/list/data = list()
	data["edit_usr"] = "[user]"

	var/obj/holding = user.get_active_hand()
	// Use a clipboard's pen, if applicable
	if(istype(loc, /obj/item/weapon/clipboard))
		var/obj/item/weapon/clipboard/clipboard = loc
		// This is just so you can still use a stamp if you're holding one. Otherwise, it'll
		// use the clipboard's pen, if applicable.
		if(!istype(holding, /obj/item/weapon/stamp) && clipboard.haspen)
			holding = clipboard.haspen
	else if(istype(holding, /obj/item/weapon/pen))
		var/obj/item/weapon/pen/PEN = holding
		data["pen_font"] = PEN.font
		data["pen_color"] = PEN.colour
		data["edit_mode"] = MODE_WRITING
		data["is_crayon"] = FALSE
		data["stamp_class"] = "FAKE"
		data["stamp_icon_state"] = "FAKE"
	else if(istype(holding, /obj/item/weapon/stamp))
		var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/simple/paper)
		data["stamp_icon_state"] = holding.icon_state
		data["stamp_class"] = sheet.icon_class_name(holding.icon_state)
		data["edit_mode"] = MODE_STAMPING
		data["pen_font"] = "FAKE"
		data["pen_color"] = "FAKE"
		data["is_crayon"] = FALSE
	else
		data["edit_mode"] = MODE_READING
		data["pen_font"] = "FAKE"
		data["pen_color"] = "FAKE"
		data["is_crayon"] = FALSE
		data["stamp_icon_state"] = "FAKE"
		data["stamp_class"] = "FAKE"
	if(istype(loc, /obj/structure/noticeboard))
		var/obj/structure/noticeboard/noticeboard = loc
		if(!noticeboard.allowed(user))
			data["edit_mode"] = MODE_READING
	data["field_counter"] = field_counter
	data["form_fields"] = form_fields

	return data

/obj/item/weapon/paper/ui_act(action, params,datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("stamp")
			var/stamp_x = text2num(params["x"])
			var/stamp_y = text2num(params["y"])
			var/stamp_r = text2num(params["r"]) // rotation in degrees
			var/stamp_icon_state = params["stamp_icon_state"]
			var/stamp_class = params["stamp_class"]
			if (isnull(stamps))
				stamps = list()
			if(stamps.len < MAX_PAPER_STAMPS)
				// I hate byond when dealing with freaking lists
				stamps[++stamps.len] = list(stamp_class, stamp_x, stamp_y, stamp_r) /// WHHHHY

				/// This does the overlay stuff
				if (isnull(stamped))
					stamped = list()
				if(stamped.len < MAX_PAPER_STAMPS_OVERLAYS)
					var/mutable_appearance/stampoverlay = mutable_appearance('icons/obj/bureaucracy.dmi', "paper_[stamp_icon_state]")
					stampoverlay.pixel_x = rand(-2, 2)
					stampoverlay.pixel_y = rand(-3, 2)
					overlays += stampoverlay
					LAZYADD(stamped, stamp_icon_state)
					update_icon()

				update_static_data(usr,ui)
				var/obj/O = ui.user.get_active_hand()
				ui.user.visible_message("<span class='notice'>[ui.user] stamps [src] with \the [O.name]!</span>", "<span class='notice'>You stamp [src] with \the [O.name]!</span>")
			else
				to_chat(usr, pick("You try to stamp but you miss!", "There is no where else you can stamp!"))
			. = TRUE

		if("save")
			var/in_paper = params["text"]
			var/paper_len = length(in_paper)
			field_counter = params["field_counter"] ? text2num(params["field_counter"]) : field_counter

			if(paper_len > MAX_PAPER_LENGTH)
				// Side note, the only way we should get here is if
				// the javascript was modified, somehow, outside of
				// byond.  but right now we are logging it as
				// the generated html might get beyond this limit
				log_paper("[key_name(ui.user)] writing to paper [name], and overwrote it by [paper_len-MAX_PAPER_LENGTH]")
			if(paper_len == 0)
				to_chat(ui.user, pick("Writing block strikes again!", "You forgot to write anthing!"))
			else
				log_paper("[key_name(ui.user)] writing to paper [name]")
				if(info != in_paper)
					to_chat(ui.user, "You have added to your paper masterpiece!");
					info = in_paper
					update_static_data(usr,ui)


			. = TRUE

//For supply.
/obj/item/weapon/paper/manifest
	name = "supply manifest"
	var/is_copy = 1
/*
 * Premade paper
 */
/obj/item/weapon/paper/Court
	name = "Judgement"
	info = "For crimes as specified, the offender is sentenced to:<BR>\n<BR>\n"

/obj/item/weapon/paper/crumpled
	name = "paper scrap"
	icon_state = "scrap"

/obj/item/weapon/paper/crumpled/update_icon()
	return

/obj/item/weapon/paper/crumpled/bloody
	icon_state = "scrap_bloodied"

/obj/item/weapon/paper/exodus_armory
	name = "armory inventory"
	info = "<center>\[logo]<BR><b><large>NSS Exodus</large></b><BR><i><date></i><BR><i>Armoury Inventory - Revision <field></i></center><hr><center>Armoury</center><list>\[*]<b>Deployable barriers</b>: 4\[*]<b>Biohazard suit(s)</b>: 1\[*]<b>Biohazard hood(s)</b>: 1\[*]<b>Face Mask(s)</b>: 1\[*]<b>Extended-capacity emergency oxygen tank(s)</b>: 1\[*]<b>Bomb suit(s)</b>: 1\[*]<b>Bomb hood(s)</b>: 1\[*]<b>Security officer's jumpsuit(s)</b>: 1\[*]<b>Brown shoes</b>: 1\[*]<b>Handcuff(s)</b>: 14\[*]<b>R.O.B.U.S.T. cartridges</b>: 7\[*]<b>Flash(s)</b>: 4\[*]<b>Can(s) of pepperspray</b>: 4\[*]<b>Gas mask(s)</b>: 6<field></list><hr><center>Secure Armoury</center><list>\[*]<b>LAEP90 Perun energy guns</b>: 4\[*]<b>Stun Revolver(s)</b>: 1\[*]<b>Taser Gun(s)</b>: 4\[*]<b>Stun baton(s)</b>: 4\[*]<b>Airlock Brace</b>: 3\[*]<b>Maintenance Jack</b>: 1\[*]<b>Stab Vest(s)</b>: 3\[*]<b>Riot helmet(s)</b>: 3\[*]<b>Riot shield(s)</b>: 3\[*]<b>Corporate security heavy armoured vest(s)</b>: 4\[*]<b>NanoTrasen helmet(s)</b>: 4\[*]<b>Portable flasher(s)</b>: 3\[*]<b>Tracking implant(s)</b>: 4\[*]<b>Chemical implant(s)</b>: 5\[*]<b>Implanter(s)</b>: 2\[*]<b>Implant pad(s)</b>: 2\[*]<b>Locator(s)</b>: 1<field></list><hr><center>Tactical Equipment</center><list>\[*]<b>Implanter</b>: 1\[*]<b>Death Alarm implant(s)</b>: 7\[*]<b>Security radio headset(s)</b>: 4\[*]<b>Ablative vest(s)</b>: 2\[*]<b>Ablative helmet(s)</b>: 2\[*]<b>Ballistic vest(s)</b>: 2\[*]<b>Ballistic helmet(s)</b>: 2\[*]<b>Tear Gas Grenade(s)</b>: 7\[*]<b>Flashbang(s)</b>: 7\[*]<b>Beanbag Shell(s)</b>: 7\[*]<b>Stun Shell(s)</b>: 7\[*]<b>Illumination Shell(s)</b>: 7\[*]<b>W-T Remmington 29x shotgun(s)</b>: 2\[*]<b>NT Mk60 EW Halicon ion rifle(s)</b>: 2\[*]<b>Hephaestus Industries G40E laser carbine(s)</b>: 4\[*]<b>Flare(s)</b>: 4<field></list><hr><b>Warden (print)</b>:<field><b>Signature</b>:<br>"

/obj/item/weapon/paper/exodus_cmo
	name = "outgoing CMO's notes"
	info = "<I><center>To the incoming CMO of Exodus:</I></center><BR><BR>I wish you and your crew well. Do take note:<BR><BR><BR>The Medical Emergency Red Phone system has proven itself well. Take care to keep the phones in their designated places as they have been optimised for broadcast. The two handheld green radios (I have left one in this office, and one near the Emergency Entrance) are free to be used. The system has proven effective at alerting Medbay of important details, especially during power outages.<BR><BR>I think I may have left the toilet cubicle doors shut. It might be a good idea to open them so the staff and patients know they are not engaged.<BR><BR>The new syringe gun has been stored in secondary storage. I tend to prefer it stored in my office, but 'guidelines' are 'guidelines'.<BR><BR>Also in secondary storage is the grenade equipment crate. I've just realised I've left it open - you may wish to shut it.<BR><BR>There were a few problems with their installation, but the Medbay Quarantine shutters should now be working again  - they lock down the Emergency and Main entrances to prevent travel in and out. Pray you shan't have to use them.<BR><BR>The new version of the Medical Diagnostics Manual arrived. I distributed them to the shelf in the staff break room, and one on the table in the corner of this room.<BR><BR>The exam/triage room has the walking canes in it. I'm not sure why we'd need them - but there you have it.<BR><BR>Emergency Cryo bags are beside the emergency entrance, along with a kit.<BR><BR>Spare paper cups for the reception are on the left side of the reception desk.<BR><BR>I've fed Runtime. She should be fine.<BR><BR><BR><center>That should be all. Good luck!</center>"

/obj/item/weapon/paper/exodus_bartender
	name = "shotgun permit"
	info = "This permit signifies that the Bartender is permitted to posess this firearm in the bar, and ONLY the bar. Failure to adhere to this permit will result in confiscation of the weapon and possibly arrest."

/obj/item/weapon/paper/exodus_holodeck
	name = "holodeck disclaimer"
	info = "Bruises sustained in the holodeck can be healed simply by sleeping."

/obj/item/weapon/paper/workvisa
	name = "Sol Work Visa"
	info = "<center><b><large>Work Visa of the Sol Central Government</large></b></center><br><center><img src = sollogo.png><br><br><i><small>Issued on behalf of the Secretary-General.</small></i></center><hr><BR>This paper hereby permits the carrier to travel unhindered through Sol territories, colonies, and space for the purpose of work and labor."
	desc = "A flimsy piece of laminated cardboard issued by the Sol Central Government."

/obj/item/weapon/paper/workvisa/New()
	..()
	icon_state = "workvisa" //Has to be here or it'll assume default paper sprites.

/obj/item/weapon/paper/travelvisa
	name = "Sol Travel Visa"
	info = "<center><b><large>Travel Visa of the Sol Central Government</large></b></center><br><center><img src = sollogo.png><br><br><i><small>Issued on behalf of the Secretary-General.</small></i></center><hr><BR>This paper hereby permits the carrier to travel unhindered through Sol territories, colonies, and space for the purpose of pleasure and recreation."
	desc = "A flimsy piece of laminated cardboard issued by the Sol Central Government."

/obj/item/weapon/paper/travelvisa/New()
	..()
	icon_state = "travelvisa"
