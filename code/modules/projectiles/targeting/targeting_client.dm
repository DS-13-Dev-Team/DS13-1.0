//These are called by the on-screen buttons, adjusting what the victim can and cannot do.
/client/proc/add_gun_icons()
	if(!usr || !usr.hud_used.item_use_icon) return 1 // This can runtime if someone manages to throw a gun out of their hand before the proc is called.
	screen |= usr.hud_used.item_use_icon
	screen |= usr.hud_used.gun_move_icon
	screen |= usr.hud_used.radio_use_icon

/client/proc/remove_gun_icons()
	if(!usr) return 1 // Runtime prevention on N00k agents spawning with SMG
	screen -= usr.hud_used.item_use_icon
	screen -= usr.hud_used.gun_move_icon
	screen -= usr.hud_used.radio_use_icon
