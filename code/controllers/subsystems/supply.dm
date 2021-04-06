SUBSYSTEM_DEF(supply)
	name = "Supply"
	wait = 20 SECONDS
	priority = SS_PRIORITY_SUPPLY
	//Initializes at default time
	flags = SS_NO_TICK_CHECK

	//supply points
	var/points = 50
	var/points_per_process = 1.5
	var/points_per_slip = 2
	var/material_buy_prices = list(
		/material/platinum = 0.3, // Idem as below. Used for manufacturing plasteel.
		/material/phoron = 0.4, // Phoron is super common now, and yields high per-vein results.
		/material/diamond = 1.5, // Rare. Higher price.
		/material/gold = 0.8, // Timeless commodity of wealth.
		/material/silver = 0.6, // Timeless commodity of minor wealth.
		/material/mhydrogen = 0.2, // Useless. Used to create hydrogen fuel. We do not use this. Comes up from the drill nowadays.
		/material/steel = 0.1, // Common material. C'mon guys.
		/material/plasteel = 0.5, // Less common material.
		/material/glass = 0.1, // Super common. Just press real hard on sand apparently.
		/material/uranium = 0.5, // Uncommon material. Lesser yield per-vein.
		/material/wood = 0.1, // This just fancies up an office.
		/material/osmium = 0.3 // I actually do not know what this is used for, nor how it is gained.
	) //Should only contain material datums, with values the profit per sheet sold.
	var/point_sources = list()
	var/pointstotalsum = 0
	var/pointstotal = 0
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/donelist = list()
	var/list/master_supply_list = list()
	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/autodock/ferry/supply/shuttle
	//Material descriptions are added automatically; add to material_buy_prices instead.
	var/list/point_source_descriptions = list(
		"time" = "Base station supply",
		"manifest" = "From exported manifests",
		"crate" = "From exported crates",
		"virology" = "From uploaded antibody data",
		"gep" = "From uploaded good explorer points",
		"total" = "Total" // If you're adding additional point sources, add it here in a new line. Don't forget to put a comma after the old last line.
	)

/datum/controller/subsystem/supply/Initialize()
	. = ..()
	ordernum = rand(1,9000)

	//Build master supply list
	for(var/decl/hierarchy/supply_pack/sp in cargo_supply_pack_root.children)
		if(sp.is_category())
			for(var/decl/hierarchy/supply_pack/spc in sp.children)
				master_supply_list += spc

	for(var/material_type in material_buy_prices)
		var/material/material = material_type //False typing
		var/material_name = initial(material.name)
		point_source_descriptions[material_name] = "From exported [material_name]"

// Just add points over time.
/datum/controller/subsystem/supply/fire()
	add_points_from_source(points_per_process, "time")

/datum/controller/subsystem/supply/stat_entry()
	..("Points: [points]")

//Supply-related helper procs.

/datum/controller/subsystem/supply/proc/add_points_from_source(amount, source)
	points += amount
	point_sources[source] += amount
	point_sources["total"] += amount

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/subsystem/supply/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		return 1
	if(istype(A,/obj/item/weapon/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

/datum/controller/subsystem/supply/proc/sell()
	var/list/material_count = list()
	var/list/exports = list()
	var/list/crate_areas = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/atom/movable/AM in subarea)
			if(AM.anchored)
				continue
			if(istype(AM, /obj/structure/closet))
				var/obj/structure/closet/C = AM
				for(var/atom/movable/A in C.GetAllContents())
					exports |= A
				if(istype(AM, /obj/structure/closet/crate))
					crate_areas[AM] = subarea
			exports |= AM

	for(var/atom/movable/AM in exports)
		if(istype(AM, /obj/structure/closet/crate))
			var/obj/structure/closet/crate/CR = AM
			callHook("sell_crate", list(CR, crate_areas[AM]))
			add_points_from_source(CR.points_per_crate, "crate")
			var/find_slip = 1

			for(var/atom/movable/A in CR.GetAllContents())
				// Sell manifests
				if(find_slip && istype(A,/obj/item/weapon/paper/manifest))
					var/obj/item/weapon/paper/manifest/slip = A
					if(!slip.is_copy && slip.stamped && slip.stamped.len) //Any stamp works.
						add_points_from_source(points_per_slip, "manifest")
						find_slip = 0
					continue

		// Sell materials
		if(istype(AM, /obj/item/stack))
			var/obj/item/stack/P = AM
			var/material/material = P.get_material()
			if(material_buy_prices[material.type])
				material_count[material.type] += P.get_amount()
			continue

		// Must sell ore detector disks in crates
		if(istype(AM, /obj/item/weapon/disk/survey))
			var/obj/item/weapon/disk/survey/D = AM
			add_points_from_source(round(D.Value() * 0.005), "gep")

	for(var/atom/movable/AM in exports)
		qdel(AM)

	if(material_count.len)
		for(var/material_type in material_count)
			var/profit = material_count[material_type] * material_buy_prices[material_type]
			var/material/material = material_type //False typing.
			add_points_from_source(profit, initial(material.name))

//Buyin
/datum/controller/subsystem/supply/proc/buy()
	if(!shoppinglist.len)
		return
	var/list/clear_turfs = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)
				continue
			var/occupied = 0
			for(var/atom/A in T.contents)
				if(!A.simulated)
					continue
				occupied = 1
				break
			if(!occupied)
				clear_turfs += T
	for(var/S in shoppinglist)
		if(!clear_turfs.len)
			break
		var/turf/pickedloc = pick_n_take(clear_turfs)
		shoppinglist -= S
		donelist += S

		var/datum/supply_order/SO = S
		var/decl/hierarchy/supply_pack/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.SetName("[SP.containername][SO.comment ? " ([SO.comment])":"" ]")
		//supply manifest generation begin

		var/obj/item/weapon/paper/manifest/slip
		if(!SP.contraband)
			var/info = list()
			info +="<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			info +="Order #[SO.ordernum]<br>"
			info +="Destination: [GLOB.using_map.station_name]<br>"
			info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			info +="CONTENTS:<br><ul>"

			slip = new /obj/item/weapon/paper/manifest(A, JOINTEXT(info))
			slip.is_copy = 0

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			if(!islist(SP.access))
				A.req_access = list(SP.access)
			else if(islist(SP.access))
				var/list/L = SP.access // access var is a plain var, we need a list
				A.req_access = L.Copy()

		var/list/spawned = SP.spawn_contents(A)
		if(slip)
			for(var/atom/content in spawned)
				slip.info += "<li>[content.name]</li>" //add the item to the manifest
			slip.info += "</ul><br>CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"

/datum/supply_order
	var/ordernum
	var/decl/hierarchy/supply_pack/object = null
	var/orderedby = null
	var/comment = null
	var/reason = null
	var/orderedrank = null //used for supply console printing
