client/verb/discord()
	set category = "OOC"
	set name ="Join the Discord"
	if( config.discord_url )
		if(alert("This will open the Dead Space 13 Discord invite in your Browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.discord_url)
	else
		to_chat(src, "<span class='warning'>The Discord URL is not set in the server configuration. Please contact a developer.</span>")
	return
