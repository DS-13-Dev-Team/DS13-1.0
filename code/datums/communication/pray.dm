/decl/communication_channel/pray
	name = "PRAY"
	log_proc = /proc/log_say
	flags = COMMUNICATION_ADMIN_FOLLOW
	mute_setting = MUTE_PRAY

/decl/communication_channel/pray/do_communicate(var/mob/communicator, var/message, var/override_sender, var/speech_method_type)
	var/image/cross = image('icons/obj/storage.dmi',"bible")
	for(var/m in GLOB.player_list)
		var/mob/M = m
		if(!M.client)
			continue
		if(M.client.holder && M.client.get_preference_value(/datum/client_preference/staff/show_chat_prayers) == GLOB.PREF_SHOW)
			receive_communication(communicator, M, "[override_sender ? override_sender : "\[<A HREF='?_src_=holder;adminspawncookie=\ref[communicator]'>SC</a>\]"] \[<A HREF='?_src_=holder;take_ic=\ref[src]'>TAKE</a>\]<span class='notice'>\icon[cross] <b><font color=purple>PRAY: </font>[override_sender ? override_sender : key_name(communicator, 1)]: </b>[message]</span>")
		else if(communicator == M) //Give it to ourselves
			receive_communication(communicator, M, "<span class='notice'>\icon[cross] <b>You send the prayer, \"[message]\" out into the heavens.</b></span>")

/decl/communication_channel/pray/receive_communication(var/mob/communicator, var/mob/receiver, var/message)
	..()
	sound_to(receiver, 'sound/effects/ding.ogg')


/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	sanitize_and_communicate(/decl/communication_channel/pray, src, msg)
	feedback_add_details("admin_verb","PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/Centcomm_announce(var/msg, var/mob/Sender, var/iamessage)
	var/mob/intercepted = check_for_interception()
	msg = "<span class='notice'><b><font color=orange>[uppertext(GLOB.using_map.boss_short)]M[iamessage ? " IA" : ""][intercepted ? "(Intercepted by [intercepted])" : null]:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) ([admin_jump_link(Sender, src)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;CentcommReply=\ref[Sender]'>RPLY</A>):</b> [msg]</span>"
	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)
			sound_to(C, 'sound/machines/signal.ogg')

/proc/Syndicate_announce(var/msg, var/mob/Sender)
	var/mob/intercepted = check_for_interception()
	msg = "<span class='notice'><b><font color=crimson>ILLEGAL[intercepted ? "(Intercepted by [intercepted])" : null]:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) ([admin_jump_link(Sender, src)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;take_ic=\ref[src]'>TAKE</a>) (<A HREF='?_src_=holder;SyndicateReply=\ref[Sender]'>RPLY</A>):</b> [msg]</span>"
	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)
			sound_to(C, 'sound/machines/signal.ogg')