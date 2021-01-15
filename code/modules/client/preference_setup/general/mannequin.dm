

/datum/preferences/proc/dress_preview_mob(mob/living/carbon/human/mannequin)
	copy_to(mannequin, TRUE)

	var/datum/job/previewJob
	if(equip_preview_mob && job_master)
		// Determine what job is marked as 'High' priority, and dress them up as such.
		if("Assistant" in job_low)
			previewJob = job_master.GetJob("Assistant")
		else
			for( var/datum/job/job in job_master.occupations)
				if(job.title == job_high)
					previewJob = job
					break

	//Can't dress it without a job to draw from
	if (!previewJob)
		return

	mannequin.job = previewJob.title

	LOADOUT_CHECK_PREF

	loadout.rank = previewJob.title
	loadout.assignment = player_alt_titles[previewJob.title]
	loadout.set_human(mannequin)
	loadout.set_job(previewJob, FALSE)
	loadout.equip_to_mob(TRUE)

	mannequin.update_icons()







/datum/preferences/proc/update_preview_icon()
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	mannequin.delete_inventory(TRUE)
	dress_preview_mob(mannequin)

	preview_icon = icon('icons/effects/128x48.dmi', bgstate)
	preview_icon.Scale(48+32, 16+32)

	mannequin.dir = NORTH
	var/icon/stamp = getFlatIcon(mannequin, NORTH, always_use_defdir = 1)
	preview_icon.Blend(stamp, ICON_OVERLAY, 25, 17)

	mannequin.dir = WEST
	stamp = getFlatIcon(mannequin, WEST, always_use_defdir = 1)
	preview_icon.Blend(stamp, ICON_OVERLAY, 1, 9)

	mannequin.dir = SOUTH
	stamp = getFlatIcon(mannequin, SOUTH, always_use_defdir = 1)
	preview_icon.Blend(stamp, ICON_OVERLAY, 49, 1)

	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
