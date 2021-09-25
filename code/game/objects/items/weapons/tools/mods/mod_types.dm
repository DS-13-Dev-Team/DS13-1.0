/******************************
	modification TYPES
******************************/
// 	 REINFORCEMENT: REDUCES TOOL DEGRADATION
//------------------------------------------------

//This can be attached to basically any long tool
//This includes most mechanical ones
/obj/item/weapon/tool_modification/reinforcement/stick
	name = "brace bar"
	desc = "A sturdy pole made of fiber tape and metal rods. Can be used to reinforce the shaft of many tools."
	icon_state = "brace_bar"
	required_qualities = list(QUALITY_BOLT_TURNING,QUALITY_PRYING, QUALITY_SAWING,QUALITY_SHOVELING,QUALITY_DIGGING,QUALITY_EXCAVATION)
	adjective = "braced"
	degradation_mult = 0.65
	force_mod = 1
	//price_tag = 120


//Heatsink can be attached to any tool that uses fuel or power
/obj/item/weapon/tool_modification/reinforcement/heatsink
	name = "heatsink"
	desc = "An array of aluminium fins which dissipates heat, reducing damage and extending the lifespan of power tools."
	icon_state = "heatsink"
	adjective = "heatsunk"
	adjective_type = ADJECTIVE_TYPE_PURPOSE
	degradation_mult = 0.65


/obj/item/weapon/tool_modification/reinforcement/heatsink/can_apply(var/obj/item/weapon/tool/T, var/mob/user)
	.=..()
	if (.)
		if (T.use_fuel_cost || T.use_power_cost)
			return TRUE
		return FALSE

/obj/item/weapon/tool_modification/reinforcement/plating
	name = "reinforced plating"
	desc = "A sturdy bit of metal that can be bolted onto any tool to protect it. Tough, but bulky."
	icon_state = "plate"
	adjective = "reinforced"
	degradation_mult = 0.55
	force_mod = 1
	precision = -5
	bulk_mod = 1
	adjective_type = ADJECTIVE_TYPE_MATERIAL

/obj/item/weapon/tool_modification/reinforcement/guard
	name = "metal guard"
	desc = "A bent piece of metal that wraps around sensitive parts of a tool, protecting it from impacts, debris, and stray fingers."
	icon_state = "guard"
	required_qualities = list(QUALITY_CUTTING,QUALITY_DRILLING, QUALITY_SAWING, QUALITY_DIGGING, QUALITY_EXCAVATION, QUALITY_WELDING)
	adjective = "shielded"
	degradation_mult = 0.75
	precision = 5
	adjective_type = ADJECTIVE_TYPE_SHAPE





// 	 PRODUCTIVITY: INCREASES WORKSPEED
//------------------------------------------------
/obj/item/weapon/tool_modification/productivity/ergonomic_grip
	name = "ergonomic grip"
	desc = "A replacement grip for a tool which allows it to be more precisely controlled with one hand."
	icon_state = "ergonomic"
	adjective = "ergonomic"
	workspeed = 0.15
	adjective_type = ADJECTIVE_TYPE_OPINION


/obj/item/weapon/tool_modification/productivity/ratchet
	name = "ratcheting mechanism"
	desc = "A mechanical modification for wrenches and screwdrivers which allows the tool to only turn in one direction."
	icon_state = "ratchet"
	required_qualities = list(QUALITY_BOLT_TURNING,QUALITY_SCREW_DRIVING)
	adjective = "ratcheting"
	workspeed = 0.25
	adjective_type = ADJECTIVE_TYPE_PURPOSE

/obj/item/weapon/tool_modification/productivity/red_paint
	name = "red paint"
	desc = "Do red tools really work faster, or is the effect purely psychological?"
	icon_state = "paint_red"
	adjective = "red"
	workspeed = 0.20
	precision = -10
	recoverable = FALSE //What are you gonna do, scrape it off and glue the paint flakes onto something else?
	adjective_type = ADJECTIVE_TYPE_COLOR

/obj/item/weapon/tool_modification/productivity/red_paint/apply_values()
	if (..())
		holder.color = "#FF4444"

/obj/item/weapon/tool_modification/productivity/whetstone
	name = "sharpening block"
	desc = "A rough single-use block to sharpen a blade. The honed edge cuts smoothly."
	icon_state = "whetstone"
	required_qualities = list(QUALITY_CUTTING,QUALITY_SAWING, QUALITY_WIRE_CUTTING)
	adjective = "sharpened"
	workspeed = 0.15
	precision = 5
	force_mult = 1.15
	recoverable = FALSE
	removeable = FALSE


/obj/item/weapon/tool_modification/productivity/diamond_blade
	name = "Asters \"Gleaming Edge\": Diamond blade"
	desc = "An adaptable industrial grade cutting disc, with diamond dust worked into the metal. Exceptionally durable."
	icon_state = "diamond_blade"
	required_qualities = list(QUALITY_CUTTING,QUALITY_SAWING, QUALITY_WIRE_CUTTING, QUALITY_PRYING)
	adjective = "dikoted"
	//price_tag = 300
	workspeed = 0.25
	degradation_mult = 0.85
	force_mult = 1.10
	matter = list(MATERIAL_STEEL = 1, MATERIAL_DIAMOND = 1)
	adjective_type = ADJECTIVE_TYPE_MATERIAL

/obj/item/weapon/tool_modification/productivity/diamond_blade/can_apply(var/obj/item/weapon/tool/T, var/mob/user)
	.=..()
	if (.)
		if (T.ever_has_quality(QUALITY_WELDING) || T.ever_has_quality(QUALITY_LASER_CUTTING))
			to_chat(user, SPAN_WARNING("This tool doesn't use a physical edge!"))
			return FALSE



/obj/item/weapon/tool_modification/productivity/oxyjet
	name = "oxyjet canister"
	desc = "A canister of pure, compressed oxygen with adapters for mounting onto a welding tool. Used alongside fuel, it allows for higher burn temperatures."
	icon_state = "oxyjet"
	required_qualities = list(QUALITY_WELDING)
	adjective = "oxyjet"
	workspeed = 0.20
	force_mult = 1.15
	degradation_mult = 1.15
	adjective_type = ADJECTIVE_TYPE_PURPOSE


//Enhances power tools majorly, but also increases costs
/obj/item/weapon/tool_modification/productivity/motor
	name = "high power motor"
	desc = "A motor for power tools with a higher horsepower than usually expected. Significantly enhances productivity and lifespan, but more expensive to run and harder to control."
	icon_state = "motor"
	required_qualities = list(QUALITY_SCREW_DRIVING, QUALITY_DRILLING, QUALITY_SAWING, QUALITY_DIGGING, QUALITY_EXCAVATION)
	adjective = "high-power"
	workspeed = 0.50
	force_mult = 1.15

	degradation_mult = 1.15
	powercost_mult = 1.35
	fuelcost_mult = 1.35
	precision = -10

/obj/item/weapon/tool_modification/productivity/motor/can_apply(var/obj/item/weapon/tool/T, var/mob/user)
	.=..()
	if (.)
		if (T.use_fuel_cost || T.use_power_cost)
			return TRUE
		return FALSE






// 	 REFINEMENT: INCREASES PRECISION
//------------------------------------------------
/obj/item/weapon/tool_modification/refinement/laserguide
	name = "Asters \"Guiding Light\" laser guide"
	desc = "A small visible laser which can be strapped onto any tool, giving an accurate representation of its target. Helps improve precision."
	icon_state = "laser_guide"
	adjective = "laser-guided"
	precision = 10
	matter = list(MATERIAL_PLASTIC = 1, MATERIAL_URANIUM = 1)
	adjective_type = ADJECTIVE_TYPE_PURPOSE


//Fits onto generally small tools that require precision, especially surgical tools
//Doesn't work onlarger things like crowbars and drills
/obj/item/weapon/tool_modification/refinement/stabilized_grip
	name = "gyrostabilized grip"
	desc = "A fancy mechanical grip that partially floats around a tool, absorbing tremors and shocks. Allows precise work with a shaky hand."
	icon_state = "stabilizing"
	required_qualities = list(QUALITY_CUTTING,QUALITY_WIRE_CUTTING, QUALITY_SCREW_DRIVING, QUALITY_WELDING,
	QUALITY_PULSING, QUALITY_CLAMPING, QUALITY_CAUTERIZING, QUALITY_BONE_SETTING, QUALITY_LASER_CUTTING)
	adjective = "stabilized"
	adjective_type = ADJECTIVE_TYPE_PURPOSE
	precision = 10

/obj/item/weapon/tool_modification/refinement/magbit
	name = "magnetic bit"
	desc = "Magnetises tools used for handling small objects, reducing instances of dropping screws and bolts."
	icon_state = "magnetic"
	required_qualities = list(QUALITY_SCREW_DRIVING, QUALITY_BOLT_TURNING, QUALITY_CLAMPING, QUALITY_BONE_SETTING)
	adjective = "magnetic"
	precision = 10
	adjective_type = ADJECTIVE_TYPE_PURPOSE


/obj/item/weapon/tool_modification/refinement/ported_barrel
	name = "ported barrel"
	desc = "A barrel extension for a welding tool which helps manage gas pressure and keep the torch steady."
	icon_state = "ported_barrel"
	required_qualities = list(QUALITY_WELDING)
	adjective = "ported"
	precision = 12
	degradation_mult = 1.15
	bulk_mod = 1
	adjective_type = ADJECTIVE_TYPE_SHAPE









// 		AUGMENTS: MISCELLANEOUS AND UTILITY
//------------------------------------------------

//DISABLED BECAUSE DS13 DOES NOT SUPPORT VARYING CELL SIZES
//Allows the tool to use a cell one size category larger than it currently uses. Small to medium, medium to large, etc
/*
/obj/item/weapon/tool_modification/augment/cell_mount
	name = "heavy cell mount"
	icon_state = "cell_mount"
	desc = "A bulky adapter which allows oversized power cells to be installed into small tools"
	req_cell = TRUE
	adjective = "medium-cell"
	bulk_mod = 1
	degradation_mult = 1.15
	adjective_type = ADJECTIVE_TYPE_SIZE

/obj/item/weapon/tool_modification/augment/cell_mount/can_apply(var/obj/item/weapon/tool/T, var/mob/user)
	.=..()
	if (.)
		if (T.suitable_cell == /obj/item/weapon/cell || T.suitable_cell == /obj/item/weapon/cell)
			if (T.cell)
				to_chat(user, SPAN_DANGER("You'll need to remove the power cell before installing this modification. It won't be compatible afterwards"))
				return FALSE
			return TRUE
		else
			return FALSE

/obj/item/weapon/tool_modification/augment/cell_mount/apply_values()
	if (!holder)
		return
	if (holder.suitable_cell == /obj/item/weapon/cell)
		holder.suitable_cell = /obj/item/weapon/cell
		adjective = "large-cell"
	else if (holder.suitable_cell == /obj/item/weapon/cell)
		holder.suitable_cell = /obj/item/weapon/cell
		adjective = "medium-cell"
	..()
*/



//Stores moar fuel!
/obj/item/weapon/tool_modification/augment/fuel_tank
	name = "expanded fuel tank"
	desc = "An auxiliary tank which stores 30 extra units of fuel."
	icon_state = "canister"
	req_fuel = TRUE
	adjective = "expanded"
	bulk_mod = 1
	adjective_type = ADJECTIVE_TYPE_SIZE

/obj/item/weapon/tool_modification/augment/fuel_tank/apply_values()
	if (..())
		holder.max_fuel += 60


//Penalises the tool, but unlocks several more augment slots.
/obj/item/weapon/tool_modification/augment/expansion
	name = "expansion port"
	icon_state = "expand"
	desc = "A bulky adapter which more modifications to be attached to the tool.  A bit fragile but you can compensate."
	adjective = "custom"
	bulk_mod = 2
	degradation_mult = 1.3
	precision = -10
	adjective_type = ADJECTIVE_TYPE_ORIGIN
	removeable = FALSE

/obj/item/weapon/tool_modification/augment/expansion/apply_values()
	if (..())
		holder.max_modifications += 3


/obj/item/weapon/tool_modification/augment/spikes
	name = "spikes"
	icon_state = "spike"
	desc = "An array of sharp bits of metal, seemingly adapted for easy affixing to a tool. Would make it into a better weapon, but won't do much for productivity."
	adjective = "spiked"
	force_mod = 4
	precision = -5
	degradation_mult = 1.15
	workspeed = -0.15
	adjective_type = ADJECTIVE_TYPE_SHAPE
	//price_tag = 100

/obj/item/weapon/tool_modification/augment/spikes/apply_values()
	if (..())
		holder.sharp = TRUE

//Vastly reduces tool sounds, for stealthy hacking
/obj/item/weapon/tool_modification/augment/dampener
	name = "aural dampener"
	desc = "This aural dampener is a cutting edge tool attachment which mostly nullifies sound waves within a tiny radius. It minimises the noise created during use, perfect for stealth operations."
	icon_state = "dampener"
	adjective = "silenced"
	adjective_type = ADJECTIVE_TYPE_PURPOSE


/obj/item/weapon/tool_modification/augment/dampener/apply_values()
	if (..())
		holder.silenced = TRUE
		holder.color = "#AAAAAA"
