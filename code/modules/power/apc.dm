// APC electronics status:
/// There are no electronics in the APC.
#define APC_ELECTRONICS_MISSING 0
/// The electronics are installed but not secured.
#define APC_ELECTRONICS_INSTALLED 1
/// The electronics are installed and secured.
#define APC_ELECTRONICS_SECURED 2

// APC cover status:
/// The APCs cover is closed.
#define APC_COVER_CLOSED 0
/// The APCs cover is open.
#define APC_COVER_OPENED 1
/// The APCs cover is missing.
#define APC_COVER_REMOVED 2

// APC charging status:
/// The APC is not charging.
#define APC_NOT_CHARGING 0
/// The APC is charging.
#define APC_CHARGING 1
/// The APC is fully charged.
#define APC_FULLY_CHARGED 2

#define MAXIMUM_COG_REGAIN 100 //How much charge drained by an integration cog can be priority-recharged in one processing-tick
// APC channel status:
/// The APCs power channel is manually set off.
#define APC_CHANNEL_OFF 0
/// The APCs power channel is automatically off.
#define APC_CHANNEL_AUTO_OFF 1
/// The APCs power channel is manually set on.
#define APC_CHANNEL_ON 2
/// The APCs power channel is automatically on.
#define APC_CHANNEL_AUTO_ON 3


// APC autoset enums:
/// The APC turns automated and manual power channels off.
#define AUTOSET_FORCE_OFF 0
/// The APC turns automated power channels off.
#define AUTOSET_OFF 2
/// The APC turns automated power channels on.
#define AUTOSET_ON 1

// External power status:
/// The APC either isn't attached to a powernet or there is no power on the external powernet.
#define APC_NO_POWER 0
/// The APCs external powernet does not have enough power to charge the APC.
#define APC_LOW_POWER 1
/// The APCs external powernet has enough power to charge the APC.
#define APC_HAS_POWER 2

// Ethereals:
/// How long it takes an ethereal to drain or charge APCs. Also used as a spam limiter.
#define APC_DRAIN_TIME (7.5 SECONDS)
/// How much power ethereals gain/drain from APCs.
#define APC_POWER_GAIN 200

// Wires & EMPs:
/// The wire value used to reset the APCs wires after one's EMPed.
#define APC_RESET_EMP "emp"

// update_state
// Bitshifts: (If you change the status values to be something other than an int or able to exceed 3 you will need to change these too)
/// The bit shift for the APCs cover status.
#define UPSTATE_COVER_SHIFT (0)
	/// The bitflag representing the APCs cover being open for icon purposes.
	#define UPSTATE_OPENED1 (APC_COVER_OPENED << UPSTATE_COVER_SHIFT)
	/// The bitflag representing the APCs cover being missing for icon purposes.
	#define UPSTATE_OPENED2 (APC_COVER_REMOVED << UPSTATE_COVER_SHIFT)

// Bitflags:
/// The APC has a power cell.
#define UPSTATE_CELL_IN (1<<2)
/// The APC is broken or damaged.
#define UPSTATE_BROKE (1<<3)
/// The APC is undergoing maintenance.
#define UPSTATE_MAINT (1<<4)
/// The APC is emagged or malfed.
#define UPSTATE_BLUESCREEN (1<<5)
/// The APCs wires are exposed.
#define UPSTATE_WIREEXP (1<<6)

// update_overlay
// Bitflags:
/// Bitflag indicating that the APCs operating status overlay should be shown.
#define UPOVERLAY_OPERATING (1<<0)
/// Bitflag indicating that the APCs locked status overlay should be shown.
#define UPOVERLAY_LOCKED (1<<1)

// Bitshifts: (If you change the status values to be something other than an int or able to exceed 3 you will need to change these too)
/// Bit shift for the charging status of the APC.
#define UPOVERLAY_CHARGING_SHIFT (2)
/// Bit shift for the equipment status of the APC.
#define UPOVERLAY_EQUIPMENT_SHIFT (4)
/// Bit shift for the lighting channel status of the APC.
#define UPOVERLAY_LIGHTING_SHIFT (6)
/// Bit shift for the environment channel status of the APC.
#define UPOVERLAY_ENVIRON_SHIFT (8)
///Update for hijack overlays
#define UPOVERLAY_HIJACKED (10)

// the Area Power Controller (APC), formerly Power Distribution Unit (PDU)
// one per area, needs wire connection to power network through a terminal

// controls power to devices in that area
// may be opened to change power cell
// three different channels (lighting/equipment/environ) - may each be set to on, off, or auto

/obj/machinery/power/apc
	name = "терминал управления питания"
	desc = "Терминал управления электрическими системами этого помещения."
	plane = ABOVE_WALL_PLANE

	icon_state = "apc0"
	use_power = NO_POWER_USE
	req_access = null
	max_integrity = 300
	integrity_failure = 0.17
	damage_deflection = 10
	resistance_flags = FIRE_PROOF
	armor = list(MELEE = 40, BULLET = 40, LASER = 40, ENERGY = 100, BOMB = 30, BIO = 100, RAD = 100, FIRE = 90, ACID = 50)
	req_access = list(ACCESS_ENGINE_EQUIP)
	interaction_flags_machine = INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON

	var/lon_range = 1.5
	var/area/area
	var/areastring = null
	var/obj/item/stock_parts/cell/cell
	var/start_charge = 90 // initial cell charge %
	var/cell_type = /obj/item/stock_parts/cell/upgraded //Base cell has 2500 capacity. Enter the path of a different cell you want to use. cell determines charge rates, max capacity, ect. These can also be changed with other APC vars, but isn't recommended to minimize the risk of accidental usage of dirty editted APCs
	var/opened = APC_COVER_CLOSED
	var/shorted = FALSE
	var/lighting = APC_CHANNEL_AUTO_ON
	var/equipment = APC_CHANNEL_AUTO_ON
	var/environ = APC_CHANNEL_AUTO_ON
	var/operating = TRUE
	var/charging = APC_NOT_CHARGING
	var/chargemode = 1
	var/chargecount = 0
	var/locked = TRUE
	var/coverlocked = TRUE
	var/aidisabled = FALSE
	var/tdir = null
	var/obj/machinery/power/terminal/terminal = null
	var/lastused_light = 0
	var/lastused_equip = 0
	var/lastused_environ = 0
	var/lastused_total = 0
	var/main_status = 0
	powernet = FALSE // set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :(
	var/malfhack = FALSE //New var for my changes to AI malf. --NeoFite
	var/mob/living/silicon/ai/malfai = null //See above --NeoFite
	var/has_electronics = APC_ELECTRONICS_MISSING // 0 - none, 1 - plugged in, 2 - secured by screwdriver
	var/overload = 1 //used for the Blackout malf module
	var/beenhit = 0 // used for counting how many times it has been hit, used for Aliens at the moment
	var/mob/living/silicon/ai/occupier = null
	var/transfer_in_progress = FALSE //Is there an AI being transferred out of us?
	var/obj/item/clockwork/integration_cog/integration_cog //Is there a cog siphoning power?
	var/cog_drained = 0 //How much of the cell's charge was drained by an integration cog, recovering this amount takes priority over the normal APC cell recharge calculations, but comes after powering Essentials.
	var/longtermpower = 10
	var/auto_name = FALSE
	var/failure_timer = 0
	var/force_update = FALSE
	var/emergency_lights = FALSE
	var/nightshift_lights = FALSE
	var/nightshift_requires_auth = FALSE
	var/last_nightshift_switch = 0
	var/update_state = -1
	var/update_overlay = -1
	var/icon_update_needed = FALSE
	var/obj/machinery/computer/apc_control/remote_control = null
	///Represents a signel source of power alarms for this apc
	var/datum/alarm_handler/alarm_manager

	var/mob/living/carbon/hijacker
	var/hijackerlast = TRUE
	var/being_hijacked = FALSE

/obj/machinery/power/apc/unlocked
	locked = FALSE

/obj/machinery/power/apc/syndicate //general syndicate access
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/power/apc/inteq //general inteq access
	req_access = list(ACCESS_INTEQ)

/obj/machinery/power/apc/away //general away mission access
	req_access = list(ACCESS_AWAY_GENERAL)

/obj/machinery/power/apc/highcap/five_k
	cell_type = /obj/item/stock_parts/cell/upgraded/plus

/obj/machinery/power/apc/highcap/ten_k
	cell_type = /obj/item/stock_parts/cell/high

/obj/machinery/power/apc/highcap/fifteen_k
	cell_type = /obj/item/stock_parts/cell/high/plus

/obj/machinery/power/apc/auto_name
	auto_name = TRUE

/obj/machinery/power/apc/auto_name/north //Pixel offsets get overwritten on New()
	dir = NORTH
	pixel_y = 23

/obj/machinery/power/apc/auto_name/south
	dir = SOUTH
	pixel_y = -23

/obj/machinery/power/apc/auto_name/east
	dir = EAST
	pixel_x = 24

/obj/machinery/power/apc/auto_name/west
	dir = WEST
	pixel_x = -25

/obj/machinery/power/apc/get_cell()
	return cell

/obj/machinery/power/apc/connect_to_network()
	//Override because the APC does not directly connect to the network; it goes through a terminal.
	//The terminal is what the power computer looks for anyway.
	if(terminal)
		terminal.connect_to_network()

/obj/machinery/power/apc/Initialize(mapload, ndir, building = FALSE)
	. = ..()
	alarm_manager = new(src)
	tdir = ndir || dir
	var/area/A = get_base_area(src)
	if(!building)
		has_electronics = APC_ELECTRONICS_SECURED
		// is starting with a power cell installed, create it and set its charge level
		if(cell_type)
			cell = new cell_type
			cell.charge = start_charge * cell.maxcharge / 100 		// (convert percentage to actual value)

		//if area isn't specified use current
		if(areastring)
			area = get_area_instance_from_text(areastring)
			if(!area)
				area = A
				stack_trace("Bad areastring path for [src], [src.areastring]")
		else if(isarea(A) && !areastring)
			area = A
		if(auto_name)
			name = "\improper [A.name] APC"

		make_terminal()
		update_nightshift_auth_requirement()

	else
		area = A
		opened = APC_COVER_OPENED
		operating = FALSE
		name = "\improper [A.name] APC"
		set_machine_stat(machine_stat | MAINT)

	update_appearance()
	addtimer(CALLBACK(src, PROC_REF(update)), 5)

	GLOB.apcs_list += src

	set_wires(new /datum/wires/apc(src))
	// offset 24 pixels in direction of dir
	// this allows the APC to be embedded in a wall, yet still inside an area
	if (building)
		setDir(ndir)
	tdir = dir // to fix Vars bug
	setDir(SOUTH)

	switch(tdir)
		if(NORTH)
			if((pixel_y != initial(pixel_y)) && (pixel_y != 23))
				log_mapping("APC: ([src]) at [AREACOORD(src)] with dir ([tdir] | [uppertext(dir2text(tdir))]) has pixel_y value ([pixel_y] - should be 23.)")
			pixel_y = 23
		if(SOUTH)
			if((pixel_y != initial(pixel_y)) && (pixel_y != -23))
				log_mapping("APC: ([src]) at [AREACOORD(src)] with dir ([tdir] | [uppertext(dir2text(tdir))]) has pixel_y value ([pixel_y] - should be -23.)")
			pixel_y = -23
		if(EAST)
			if((pixel_y != initial(pixel_x)) && (pixel_x != 24))
				log_mapping("APC: ([src]) at [AREACOORD(src)] with dir ([tdir] | [uppertext(dir2text(tdir))]) has pixel_x value ([pixel_x] - should be 24.)")
			pixel_x = 24
		if(WEST)
			if((pixel_y != initial(pixel_x)) && (pixel_x != -25))
				log_mapping("APC: ([src]) at [AREACOORD(src)] with dir ([tdir] | [uppertext(dir2text(tdir))]) has pixel_x value ([pixel_x] - should be -25.)")
			pixel_x = -25
	if (building)
		area = get_area(src)
		opened = APC_COVER_OPENED
		operating = FALSE
		name = "\improper [get_area_name(area, TRUE)] APC"
		set_machine_stat(machine_stat | MAINT)
		update_appearance()
		addtimer(CALLBACK(src, PROC_REF(update)), 5)
	register_context()

/obj/machinery/power/apc/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	if(operating)
		LAZYSET(context[SCREENTIP_CONTEXT_ALT_LMB], INTENT_ANY, locked ? "Unlock" : "Lock")
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/power/apc/Destroy()
	GLOB.apcs_list -= src

	if(malfai && operating)
		malfai.malf_picker.processing_time = clamp(malfai.malf_picker.processing_time - 10,0,1000)
	if(area)
		area.power_light = FALSE
		area.power_equip = FALSE
		area.power_environ = FALSE
		area.power_change()
		QDEL_NULL(alarm_manager)
	if(occupier)
		malfvacate(1)
	if(wires)
		QDEL_NULL(wires)
	if(cell)
		QDEL_NULL(cell)
	if(terminal)
		disconnect_terminal()
	. = ..()

/obj/machinery/power/apc/handle_atom_del(atom/A)
	if(A == cell)
		cell = null
		update_appearance()
		updateUsrDialog()

/obj/machinery/power/apc/proc/make_terminal()
	// create a terminal object at the same position as original turf loc
	// wires will attach to this
	terminal = new/obj/machinery/power/terminal(src.loc)
	terminal.setDir(tdir)
	terminal.master = src

/obj/machinery/power/apc/examine(mob/user)
	. = ..()
	if(machine_stat & BROKEN)
		return
	if(opened)
		if(has_electronics && terminal)
			. += "The cover is [opened==APC_COVER_REMOVED?"removed":"open"] and the power cell is [ cell ? "installed" : "missing"]."
		else
			. += "It's [ !terminal ? "not" : "" ] wired up."
			. += "The electronics are[!has_electronics?"n't":""] installed."
		if(user.Adjacent(src) && integration_cog)
			. += "<span class='warning'>[src]'s innards have been replaced by strange brass machinery!</span>"

	else
		if (machine_stat & MAINT)
			. += "The cover is closed. Something is wrong with it. It doesn't work."
		else if (malfhack)
			. += "The cover is broken. It may be hard to force it open."
		else
			. += "The cover is closed."

	if(integration_cog && is_servant_of_ratvar(user))
		. += "<span class='brass'>There is an integration cog installed!</span>"

	. += "<span class='notice'>Alt-Click the APC to [ locked ? "unlock" : "lock"] the interface.</span>"

	if(area.hasSiliconAccessInArea(user))
		. += "<span class='notice'>Ctrl-Click the APC to switch the breaker [ operating ? "off" : "on"].</span>"

// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/update_appearance(updates=check_updates())
	icon_update_needed = FALSE
	if(!updates)
		return

	. = ..()
	// And now, separately for cleanness, the lighting changing
	if(!update_state)
		switch(charging)
			if(APC_NOT_CHARGING)
				set_light_color(COLOR_SOFT_RED)
			if(APC_CHARGING)
				set_light_color(LIGHT_COLOR_BLUE)
			if(APC_FULLY_CHARGED)
				set_light_color(LIGHT_COLOR_GREEN)
		set_light(lon_range)
		return

	if(update_state & UPSTATE_BLUESCREEN)
		set_light_color(LIGHT_COLOR_BLUE)
		set_light(lon_range)
		return

	set_light(0)

// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/update_icon_state()
	if(!update_state)
		icon_state = "apc0"
		return ..()
	if(update_state & (UPSTATE_OPENED1|UPSTATE_OPENED2))
		var/basestate = "apc[cell ? 2 : 1]"
		if(update_state & UPSTATE_OPENED1)
			icon_state = (update_state & (UPSTATE_MAINT|UPSTATE_BROKE)) ? "apcmaint" : basestate
		else if(update_state & UPSTATE_OPENED2)
			icon_state = "[basestate][((update_state & UPSTATE_BROKE) || malfhack) ? "-b" : null]-nocover"
		return ..()
	if(update_state & UPSTATE_BROKE)
		icon_state = "apc-b"
		return ..()
	if(update_state & UPSTATE_BLUESCREEN)
		icon_state = "apcemag"
		return ..()
	if(update_state & UPSTATE_WIREEXP)
		icon_state = "apcewires"
		return ..()
	if(update_state & UPSTATE_MAINT)
		icon_state = "apc0"
	return ..()

/obj/machinery/power/apc/update_overlays()
	. = ..()
	if((machine_stat & (BROKEN|MAINT)) || update_state)
		return

	. += mutable_appearance(icon, "apcox-[locked]")
	. += emissive_appearance(icon, "apcox-[locked]")
	. += mutable_appearance(icon, "apco3-[hijackerreturn() ? "3" : charging]")
	. += emissive_appearance(icon, "apco3-[hijackerreturn() ? "3" : charging]")
	if(!operating)
		return

	. += mutable_appearance(icon, "apco0-[equipment]")
	. += emissive_appearance(icon, "apco0-[equipment]")
	. += mutable_appearance(icon, "apco1-[lighting]")
	. += emissive_appearance(icon, "apco1-[lighting]")
	. += mutable_appearance(icon, "apco2-[environ]")
	. += emissive_appearance(icon, "apco2-[environ]")

/// Checks for what icon updates we will need to handle
/obj/machinery/power/apc/proc/check_updates()
	SIGNAL_HANDLER
	. = NONE

	// Handle icon status:
	var/new_update_state = NONE
	if(machine_stat & BROKEN)
		new_update_state |= UPSTATE_BROKE
	if(machine_stat & MAINT)
		new_update_state |= UPSTATE_MAINT

	if(opened)
		new_update_state |= (opened << UPSTATE_COVER_SHIFT)
		if(cell)
			new_update_state |= UPSTATE_CELL_IN

	else if((obj_flags & EMAGGED) || malfai)
		new_update_state |= UPSTATE_BLUESCREEN
	else if(panel_open)
		new_update_state |= UPSTATE_WIREEXP

	if(new_update_state != update_state)
		update_state = new_update_state
		. |= UPDATE_ICON_STATE

	// Handle overlay status:
	var/new_update_overlay = NONE
	if(operating)
		new_update_overlay |= UPOVERLAY_OPERATING
	if(!update_state)
		if(locked)
			new_update_overlay |= UPOVERLAY_LOCKED

		new_update_overlay |= (charging << UPOVERLAY_CHARGING_SHIFT)
		new_update_overlay |= (equipment << UPOVERLAY_EQUIPMENT_SHIFT)
		new_update_overlay |= (lighting << UPOVERLAY_LIGHTING_SHIFT)
		new_update_overlay |= (environ << UPOVERLAY_ENVIRON_SHIFT)
		new_update_overlay |= (hijackerreturn() << UPOVERLAY_HIJACKED)

	if(new_update_overlay != update_overlay)
		update_overlay = new_update_overlay
		. |= UPDATE_OVERLAYS

// Used in process so it doesn't update the icon too much
/obj/machinery/power/apc/proc/queue_icon_update()
	icon_update_needed = TRUE

/obj/machinery/power/apc/proc/hijackerreturn()
	if(!hijacker)
		return FALSE
	var/obj/item/implant/hijack/implant = hijacker.getImplant(/obj/item/implant/hijack)
	if(implant && !implant.stealthmode)
		return TRUE
//attack with an item - open/close cover, insert cell, or (un)lock interface

/obj/machinery/power/apc/crowbar_act(mob/user, obj/item/W)
	. = TRUE
	if (opened)
		if (has_electronics == APC_ELECTRONICS_INSTALLED)
			if (terminal)
				to_chat(user, "<span class='warning'>Disconnect the wires first!</span>")
				return
			W.play_tool_sound(src)
			to_chat(user, "<span class='notice'>You attempt to remove the power control board...</span>" )
			if(W.use_tool(src, user, 50))
				if (has_electronics == APC_ELECTRONICS_INSTALLED)
					has_electronics = APC_ELECTRONICS_MISSING
					if (machine_stat & BROKEN)
						user.visible_message(\
							"[user.name] has broken the power control board inside [src.name]!",\
							"<span class='notice'>You break the charred power control board and remove the remains.</span>",
							"<span class='italics'>You hear a crack.</span>")
						return
					else if (obj_flags & EMAGGED)
						obj_flags &= ~EMAGGED
						user.visible_message(\
							"[user.name] has discarded an emagged power control board from [src.name]!",\
							"<span class='notice'>You discard the emagged power control board.</span>")
						return
					else if (malfhack)
						user.visible_message(\
							"[user.name] has discarded a strangely programmed power control board from [src.name]!",\
							"<span class='notice'>You discard the strangely programmed board.</span>")
						malfai = null
						malfhack = 0
						return
					else
						user.visible_message(\
							"[user.name] has removed the power control board from [src.name]!",\
							"<span class='notice'>You remove the power control board.</span>")
						new /obj/item/electronics/apc(loc)
						return
		else if(integration_cog)
			user.visible_message("<span class='notice'>[user] starts prying [integration_cog] from [src]...</span>", \
			"<span class='notice'>You painstakingly start tearing [integration_cog] out of [src]'s guts...</span>")
			W.play_tool_sound(src)
			if(W.use_tool(src, user, 100))
				user.visible_message("<span class='notice'>[user] destroys [integration_cog] in [src]!</span>", \
				"<span class='notice'>[integration_cog] comes free with a clank and snaps in two as the machinery returns to normal!</span>")
				playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
				QDEL_NULL(integration_cog)
			return
		else if (opened!=APC_COVER_REMOVED)
			opened = APC_COVER_CLOSED
			coverlocked = TRUE //closing cover relocks it
			update_appearance()
			return
	else if (!(machine_stat & BROKEN))
		if(coverlocked && !(machine_stat & MAINT)) // locked...
			to_chat(user, "<span class='warning'>The cover is locked and cannot be opened!</span>")
			return
		else if (panel_open)
			to_chat(user, "<span class='warning'>Exposed wires prevents you from opening it!</span>")
			return
		else
			opened = APC_COVER_OPENED
			update_appearance()
			return

/obj/machinery/power/apc/screwdriver_act(mob/living/user, obj/item/W)
	if(..())
		return TRUE
	. = TRUE
	if(opened)
		if(cell)
			user.visible_message("[user] removes \the [cell] from [src]!","<span class='notice'>You remove \the [cell].</span>")
			var/turf/T = get_turf(user)
			cell.forceMove(T)
			cell.update_appearance()
			cell = null
			cog_drained = 0 //No more cell means no more averting celldrain
			charging = APC_NOT_CHARGING
			update_appearance()
			return
		else
			switch (has_electronics)
				if (APC_ELECTRONICS_INSTALLED)
					has_electronics = APC_ELECTRONICS_SECURED
					machine_stat &= ~MAINT
					W.play_tool_sound(src)
					to_chat(user, "<span class='notice'>You screw the circuit electronics into place.</span>")
				if (APC_ELECTRONICS_SECURED)
					has_electronics = APC_ELECTRONICS_INSTALLED
					set_machine_stat(machine_stat | MAINT)
					W.play_tool_sound(src)
					to_chat(user, "<span class='notice'>You unfasten the electronics.</span>")
				else
					to_chat(user, "<span class='warning'>There is nothing to secure!</span>")
					return
			update_appearance()
	else if(obj_flags & EMAGGED)
		to_chat(user, "<span class='warning'>The interface is broken!</span>")
		return
	else
		panel_open = !panel_open
		to_chat(user, "The wires have been [panel_open ? "exposed" : "unexposed"]")
		update_appearance()

/obj/machinery/power/apc/wirecutter_act(mob/living/user, obj/item/W)
	. = ..()
	if (terminal && opened)
		terminal.dismantle(user, W)
		return TRUE


/obj/machinery/power/apc/welder_act(mob/living/user, obj/item/W)
	. = ..()
	if (opened && !has_electronics && !terminal)
		if(!W.tool_start_check(user, amount=3))
			return
		user.visible_message("[user.name] welds [src].", \
							"<span class='notice'>You start welding the APC frame...</span>", \
							"<span class='italics'>You hear welding.</span>")
		if(W.use_tool(src, user, 50, volume=50, amount=3))
			if ((machine_stat & BROKEN) || opened==APC_COVER_REMOVED)
				new /obj/item/stack/sheet/metal(loc)
				user.visible_message(\
					"[user.name] has cut [src] apart with [W].",\
					"<span class='notice'>You disassembled the broken APC frame.</span>")
			else
				new /obj/item/wallframe/apc(loc)
				user.visible_message(\
					"[user.name] has cut [src] from the wall with [W].",\
					"<span class='notice'>You cut the APC frame from the wall.</span>")
			qdel(src)
			return TRUE

/obj/machinery/power/apc/attackby(obj/item/W, mob/living/user, params)

	if(area.hasSiliconAccessInArea(user) && get_dist(src,user)>1)
		return attack_hand(user)

	if(istype(W, /obj/item/stock_parts/cell) && opened)
		if(cell)
			to_chat(user, "<span class='warning'>There is a power cell already installed!</span>")
			return
		else
			if(machine_stat & MAINT)
				to_chat(user, "<span class='warning'>There is no connector for your power cell!</span>")
				return
			if(!user.transferItemToLoc(W, src))
				return
			cell = W
			user.visible_message(\
				"[user.name] has inserted the power cell to [src.name]!",\
				"<span class='notice'>You insert the power cell.</span>")
			chargecount = 0
			update_appearance()
	else if (W.GetID())
		togglelock(user)
	else if (istype(W, /obj/item/stack/cable_coil) && opened)
		var/turf/host_turf = get_turf(src)
		if(!host_turf)
			CRASH("attackby on APC when it's not on a turf")
		if (host_turf.intact)
			to_chat(user, "<span class='warning'>You must remove the floor plating in front of the APC first!</span>")
			return
		else if (terminal)
			to_chat(user, "<span class='warning'>This APC is already wired!</span>")
			return
		else if (!has_electronics)
			to_chat(user, "<span class='warning'>There is nothing to wire!</span>")
			return

		var/obj/item/stack/cable_coil/C = W
		if(C.get_amount() < 10)
			to_chat(user, "<span class='warning'>You need ten lengths of cable for APC!</span>")
			return
		user.visible_message("[user.name] adds cables to the APC frame.", \
							"<span class='notice'>You start adding cables to the APC frame...</span>")
		playsound(src.loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		if(do_after(user, 20, target = src))
			if (C.get_amount() < 10 || !C)
				return
			if (C.get_amount() >= 10 && !terminal && opened && has_electronics)
				var/turf/T = get_turf(src)
				var/obj/structure/cable/N = T.get_cable_node()
				if (prob(50) && electrocute_mob(usr, N, N, 1, TRUE))
					do_sparks(5, TRUE, src)
					return
				C.use(10)
				to_chat(user, "<span class='notice'>You add cables to the APC frame.</span>")
				make_terminal()
				terminal.connect_to_network()
	else if (istype(W, /obj/item/electronics/apc) && opened)
		if (has_electronics)
			to_chat(user, "<span class='warning'>There is already a board inside the [src]!</span>")
			return
		else if (machine_stat & BROKEN)
			to_chat(user, "<span class='warning'>You cannot put the board inside, the frame is damaged!</span>")
			return

		user.visible_message("[user.name] inserts the power control board into [src].", \
							"<span class='notice'>You start to insert the power control board into the frame...</span>")
		playsound(src.loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		if(do_after(user, 10, target = src))
			if(!has_electronics)
				has_electronics = APC_ELECTRONICS_INSTALLED
				locked = FALSE
				to_chat(user, "<span class='notice'>You place the power control board inside the frame.</span>")
				qdel(W)
	else if(istype(W, /obj/item/electroadaptive_pseudocircuit) && opened)
		var/obj/item/electroadaptive_pseudocircuit/P = W
		if(!has_electronics)
			if(machine_stat & BROKEN)
				to_chat(user, "<span class='warning'>[src]'s frame is too damaged to support a circuit.</span>")
				return
			if(!P.adapt_circuit(user, 50))
				return
			user.visible_message("<span class='notice'>[user] fabricates a circuit and places it into [src].</span>", \
			"<span class='notice'>You adapt a power control board and click it into place in [src]'s guts.</span>")
			has_electronics = APC_ELECTRONICS_INSTALLED
			locked = FALSE
		else if(!cell)
			if(machine_stat & MAINT)
				to_chat(user, "<span class='warning'>There's no connector for a power cell.</span>")
				return
			if(!P.adapt_circuit(user, 500))
				return
			var/obj/item/stock_parts/cell/crap/empty/C = new(src)
			C.forceMove(src)
			cell = C
			chargecount = 0
			user.visible_message("<span class='notice'>[user] fabricates a weak power cell and places it into [src].</span>", \
			"<span class='warning'>Your [P.name] whirrs with strain as you create a weak power cell and place it into [src]!</span>")
			update_appearance()
		else
			to_chat(user, "<span class='warning'>[src] has both electronics and a cell.</span>")
			return
	else if (istype(W, /obj/item/wallframe/apc) && opened)
		if (!(machine_stat & BROKEN || opened==APC_COVER_REMOVED || obj_integrity < max_integrity)) // There is nothing to repair
			to_chat(user, "<span class='warning'>You found no reason for repairing this APC</span>")
			return
		if (!(machine_stat & BROKEN) && opened==APC_COVER_REMOVED) // Cover is the only thing broken, we do not need to remove elctronicks to replace cover
			user.visible_message("[user.name] replaces missing APC's cover.",\
							"<span class='notice'>You begin to replace APC's cover...</span>")
			if(do_after(user, 20, target = src)) // replacing cover is quicker than replacing whole frame
				to_chat(user, "<span class='notice'>You replace missing APC's cover.</span>")
				qdel(W)
				opened = APC_COVER_OPENED
				update_appearance()
			return
		if (has_electronics)
			to_chat(user, "<span class='warning'>You cannot repair this APC until you remove the electronics still inside!</span>")
			return
		user.visible_message("[user.name] replaces the damaged APC frame with a new one.",\
							"<span class='notice'>You begin to replace the damaged APC frame...</span>")
		if(do_after(user, 50, target = src))
			to_chat(user, "<span class='notice'>You replace the damaged APC frame with a new one.</span>")
			qdel(W)
			machine_stat &= ~BROKEN
			obj_integrity = max_integrity
			if (opened==APC_COVER_REMOVED)
				opened = APC_COVER_OPENED
			update_appearance()
	else if(istype(W, /obj/item/clockwork/integration_cog) && is_servant_of_ratvar(user))
		if(integration_cog)
			to_chat(user, "<span class='warning'>This APC already has a cog.</span>")
			return
		if(!opened)
			user.visible_message("<span class='warning'>[user] slices [src]'s cover lock, and it swings wide open!</span>", \
			"<span class='alloy'>You slice [src]'s cover lock apart with [W], and the cover swings open.</span>")
			opened = APC_COVER_OPENED
			update_appearance()
		else
			user.visible_message("<span class='warning'>[user] presses [W] into [src]!</span>", \
			"<span class='alloy'>You hold [W] in place within [src], and it slowly begins to warm up...</span>")
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
			if(!do_after(user, 70, target = src))
				return
			user.visible_message("<span class='warning'>[user] installs [W] in [src]!</span>", \
			"<span class='alloy'>Replicant alloy rapidly covers the APC's innards, replacing the machinery.</span><br>\
			<span class='brass'>This APC will now passively provide power for the cult!</span>")
			playsound(user, 'sound/machines/clockcult/integration_cog_install.ogg', 50, TRUE)
			user.transferItemToLoc(W, src)
			integration_cog = W
			START_PROCESSING(SSfastprocess, W)
			playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 50, FALSE)
			opened = APC_COVER_CLOSED
			locked = TRUE //Clockies get full APC access on cogged APCs, but they can't lock or unlock em unless they steal some ID to give all of them APC access, soo this is pretty much just QoL for them and makes cogs a tiny bit more stealthy
			update_appearance()
		return
	else if(panel_open && !opened && is_wire_tool(W))
		wires.interact(user)
	else
		return ..()

/obj/machinery/power/apc/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.upgrade & RCD_UPGRADE_SIMPLE_CIRCUITS)
		if(!has_electronics)
			if(machine_stat & BROKEN)
				to_chat(user, "<span class='warning'>[src]'s frame is too damaged to support a circuit.</span>")
				return FALSE
			return list("mode" = RCD_UPGRADE_SIMPLE_CIRCUITS, "delay" = 20, "cost" = 1)
		else if(!cell)
			if(machine_stat & MAINT)
				to_chat(user, "<span class='warning'>There's no connector for a power cell.</span>")
				return FALSE
			return list("mode" = RCD_UPGRADE_SIMPLE_CIRCUITS, "delay" = 50, "cost" = 10) //16 for a wall
		else
			to_chat(user, "<span class='warning'>[src] has both electronics and a cell.</span>")
			return FALSE
	return FALSE

/obj/machinery/power/apc/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_UPGRADE_SIMPLE_CIRCUITS)
			if(!has_electronics)
				if(machine_stat & BROKEN)
					to_chat(user, "<span class='warning'>[src]'s frame is too damaged to support a circuit.</span>")
					return
				user.visible_message("<span class='notice'>[user] fabricates a circuit and places it into [src].</span>", \
				"<span class='notice'>You adapt a power control board and click it into place in [src]'s guts.</span>")
				has_electronics = TRUE
				locked = TRUE
				return TRUE
			else if(!cell)
				if(machine_stat & MAINT)
					to_chat(user, span_warning("There's no connector for a power cell."))
					return FALSE
				var/obj/item/stock_parts/cell/crap/empty/C = new(src)
				C.forceMove(src)
				cell = C
				chargecount = 0
				user.visible_message("<span class='notice'>[user] fabricates a weak power cell and places it into [src].</span>", \
				"<span class='warning'>Your [the_rcd.name] whirrs with strain as you create a weak power cell and place it into [src]!</span>")
				update_appearance()
				return TRUE
			else
				to_chat(user, "<span class='warning'>[src] has both electronics and a cell.</span>")
				return FALSE
	return FALSE

/obj/machinery/power/apc/AltClick(mob/user)
	. = ..()
	if(!user.canUseTopic(src, !area.hasSiliconAccessInArea(user)) || !isturf(loc))
		return
	togglelock(user)
	return TRUE

/obj/machinery/power/apc/proc/togglelock(mob/living/user)
	if(obj_flags & EMAGGED)
		to_chat(user, "<span class='warning'>The interface is broken!</span>")
	else if(opened)
		to_chat(user, "<span class='warning'>You must close the cover to swipe an ID card!</span>")
	else if(panel_open)
		to_chat(user, "<span class='warning'>You must close the panel!</span>")
	else if(machine_stat & (BROKEN|MAINT))
		to_chat(user, "<span class='warning'>Nothing happens!</span>")
	else
		if(allowed(usr) && !wires.is_cut(WIRE_IDSCAN) && !malfhack)
			locked = !locked
			to_chat(user, "<span class='notice'>You [ locked ? "lock" : "unlock"] the APC interface.</span>")
			update_appearance()
			updateUsrDialog()
		else
			to_chat(user, "<span class='warning'>Доступ запрещён.</span>")

/obj/machinery/power/apc/proc/toggle_nightshift_lights(mob/living/user)
	if(last_nightshift_switch > world.time - 100) //~10 seconds between each toggle to prevent spamming
		to_chat(usr, "<span class='warning'>[src]'s night lighting circuit breaker is still cycling!</span>")
		return
	last_nightshift_switch = world.time
	set_nightshift(!nightshift_lights)

/obj/machinery/power/apc/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == MELEE && damage_amount < 10 && (!(machine_stat & BROKEN) || malfai))
		return FALSE
	. = ..()


/obj/machinery/power/apc/obj_break(damage_flag)
	. = ..()
	if(.)
		set_broken()

/obj/machinery/power/apc/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!(machine_stat & BROKEN))
			set_broken()
		if(opened != APC_COVER_REMOVED)
			opened = APC_COVER_REMOVED
			coverlocked = FALSE
			visible_message("<span class='warning'>The APC cover is knocked down!</span>")
			update_appearance()

/obj/machinery/power/apc/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED || malfhack)
		return
	if(opened)
		to_chat(user, "<span class='warning'>You must close the cover to swipe an ID card!</span>")
	else if(panel_open)
		to_chat(user, "<span class='warning'>You must close the panel first!</span>")
	else if(machine_stat & (BROKEN|MAINT))
		to_chat(user, "<span class='warning'>Nothing happens!</span>")
	else
		flick("apc-spark", src)
		playsound(src, "sparks", 75, 1)
		obj_flags |= EMAGGED
		locked = FALSE
		to_chat(user, "<span class='notice'>You emag the APC interface.</span>")
		log_admin("[key_name(usr)] emagged [src] at [AREACOORD(src)]")
		update_appearance()
	return TRUE

// attack with hand - remove cell (if cover open) or interact with the APC

/obj/machinery/power/apc/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(isethereal(user))
		var/mob/living/carbon/human/H = user
		if(H.a_intent == INTENT_HARM)
			if(cell.charge <= (cell.maxcharge / 2)) // if charge is under 50% you shouldnt drain it
				to_chat(H, "<span class='warning'>The APC doesn't have much power, you probably shouldn't drain any.</span>")
				return
			var/obj/item/organ/stomach/ethereal/stomach = H.getorganslot(ORGAN_SLOT_STOMACH)
			if(stomach.crystal_charge > 145)
				to_chat(H, "<span class='warning'>Your charge is full!</span>")
				return
			to_chat(H, "<span class='notice'>You start channeling some power through the APC into your body.</span>")
			if(do_after(user, 75, target = src))
				if(cell.charge <= (cell.maxcharge / 2) || (stomach.crystal_charge > 145))
					return
				if(istype(stomach))
					to_chat(H, "<span class='notice'>You receive some charge from the APC.</span>")
					stomach.adjust_charge(10)
					cell.charge -= 10
				else
					to_chat(H, "<span class='warning'>You can't receive charge from the APC!</span>")
			return
		if(H.a_intent == INTENT_GRAB)
			if(cell.charge == cell.maxcharge)
				to_chat(H, "<span class='warning'>The APC is full!</span>")
				return
			var/obj/item/organ/stomach/ethereal/stomach = H.getorganslot(ORGAN_SLOT_STOMACH)
			if(stomach.crystal_charge < 10)
				to_chat(H, "<span class='warning'>Your charge is too low!</span>")
				return
			to_chat(H, "<span class='notice'>You start channeling power through your body into the APC.</span>")
			if(do_after(user, 75, target = src))
				if(cell.charge == cell.maxcharge || (stomach.crystal_charge < 10))
					return
				if(istype(stomach))
					to_chat(H, "<span class='notice'>You transfer some power to the APC.</span>")
					stomach.adjust_charge(-10)
					cell.charge += 10
				else
					to_chat(H, "<span class='warning'>You can't transfer power to the APC!</span>")
			return
	if(opened && (!issilicon(user)))
		if(cell)
			user.visible_message("[user] removes \the [cell] from [src]!","<span class='notice'>You remove \the [cell].</span>")
			user.put_in_hands(cell)
			cell.update_appearance()
			src.cell = null
			charging = APC_NOT_CHARGING
			src.update_appearance()
		return
	if((machine_stat & MAINT) && !opened) //no board; no interface
		return

/obj/machinery/power/apc/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Apc", name)
		ui.open()

/obj/machinery/power/apc/ui_data(mob/user)
	var/obj/item/implant/hijack/H = user.getImplant(/obj/item/implant/hijack)
	var/abilitiesavail = FALSE
	if(H && !H.stealthmode && H.toggled)
		abilitiesavail = TRUE
	var/list/data = list(
		"locked" = locked && !(integration_cog && is_servant_of_ratvar(user)) && !area.hasSiliconAccessInArea(user, PRIVILEGES_SILICON|PRIVILEGES_DRONE),
		"failTime" = failure_timer,
		"isOperating" = operating,
		"externalPower" = main_status,
		"powerCellStatus" = cell ? cell.percent() : null,
		"chargeMode" = chargemode,
		"chargingStatus" = charging,
		"totalLoad" = DisplayPower(lastused_total),
		"coverLocked" = coverlocked,
		"siliconUser" = user.using_power_flow_console() || area.hasSiliconAccessInArea(user),
		"malfStatus" = get_malf_status(user),
		"emergencyLights" = !emergency_lights,
		"nightshiftLights" = nightshift_lights,
		"hijackable" = HAS_TRAIT(user, TRAIT_HIJACKER),
		"hijacked" = hijacker && hasSiliconAccessInArea(hijacker),
		"hijacker" = hijacker == user ? TRUE : FALSE,
		"drainavail" = cell && cell.percent() >= 85 && abilitiesavail,
		"lockdownavail" = cell && cell.percent() >= 35 && abilitiesavail,
		"powerChannels" = list(
			list(
				"title" = "Equipment",
				"powerLoad" = DisplayPower(lastused_equip),
				"status" = equipment,
				"topicParams" = list(
					"auto" = list("eqp" = 3),
					"on"   = list("eqp" = 2),
					"off"  = list("eqp" = 1)
				)
			),
			list(
				"title" = "Lighting",
				"powerLoad" = DisplayPower(lastused_light),
				"status" = lighting,
				"topicParams" = list(
					"auto" = list("lgt" = 3),
					"on"   = list("lgt" = 2),
					"off"  = list("lgt" = 1)
				)
			),
			list(
				"title" = "Environment",
				"powerLoad" = DisplayPower(lastused_environ),
				"status" = environ,
				"topicParams" = list(
					"auto" = list("env" = 3),
					"on"   = list("env" = 2),
					"off"  = list("env" = 1)
				)
			)
		)
	)
	return data


/obj/machinery/power/apc/proc/get_malf_status(mob/living/silicon/ai/malf)
	if(istype(malf) && malf.malf_picker)
		if(malfai == (malf.parent || malf))
			if(occupier == malf)
				return 3 // 3 = User is shunted in this APC
			else if(istype(malf.loc, /obj/machinery/power/apc))
				return 4 // 4 = User is shunted in another APC
			else
				return 2 // 2 = APC hacked by user, and user is in its core.
		else
			return 1 // 1 = APC not hacked.
	else
		return 0 // 0 = User is not a Malf AI

/obj/machinery/power/apc/proc/report()
	return "[area.name] : [equipment]/[lighting]/[environ] ([lastused_equip+lastused_light+lastused_environ]) : [cell? cell.percent() : "N/C"] ([charging])"

/obj/machinery/power/apc/proc/update()
	if(operating && !shorted && !failure_timer)
		area.power_light = (lighting > APC_CHANNEL_AUTO_OFF)
		area.power_equip = (equipment > APC_CHANNEL_AUTO_OFF)
		area.power_environ = (environ > APC_CHANNEL_AUTO_OFF)
	else
		area.power_light = FALSE
		area.power_equip = FALSE
		area.power_environ = FALSE
	area.power_change()

/obj/machinery/power/apc/proc/can_use(mob/user, loud = 0) //used by attack_hand() and Topic()
	if(IsAdminGhost(user))
		return TRUE
	if (user == hijacker || (area.hasSiliconAccessInArea(user) && !aidisabled))
		return TRUE
	if(user.silicon_privileges & PRIVILEGES_SILICON)
		var/mob/living/silicon/ai/AI = user
		var/mob/living/silicon/robot/robot = user
		if (src.aidisabled || malfhack && istype(malfai) && ((istype(AI) && (malfai!=AI && malfai != AI.parent)) || (istype(robot) && (robot in malfai.connected_robots))))
			if(!loud)
				to_chat(user, "<span class='danger'>\The [src] has eee disabled!</span>")
			return FALSE
	return TRUE

/obj/machinery/power/apc/can_interact(mob/user)
	. = ..()
	if (!. && !QDELETED(remote_control))
		. = remote_control.can_interact(user)
	if (hijacker == user && area.hasSiliconAccessInArea(user))
		return TRUE

/obj/machinery/power/apc/ui_status(mob/user)
	. = ..()
	if (!QDELETED(remote_control) && user == remote_control.operator)
		. = UI_INTERACTIVE
	if (user == hijacker && area.hasSiliconAccessInArea(user))
		. = UI_INTERACTIVE

/obj/machinery/power/apc/ui_act(action, params)
	if(..() || !can_use(usr, 1))
		return
	if(action == "hijack" && can_use(usr, 1)) //don't need auth for hijack button
		hijack(usr)
		return
	if(locked && !area.hasSiliconAccessInArea(usr, PRIVILEGES_SILICON|PRIVILEGES_DRONE) && !failure_timer && action != "toggle_nightshift" && (!integration_cog || !(is_servant_of_ratvar(usr))))
		return
	switch(action)
		if("lock")
			if(area.hasSiliconAccessInArea(usr))
				if((obj_flags & EMAGGED) || (machine_stat & (BROKEN|MAINT)))
					to_chat(usr, "<span class='warning'>The APC does not respond to the command!</span>")
				else
					locked = !locked
					update_appearance()
					. = TRUE
		if("cover")
			coverlocked = !coverlocked
			. = TRUE
		if("breaker")
			toggle_breaker(usr)
			. = TRUE
		if("toggle_nightshift")
			toggle_nightshift_lights()
			. = TRUE
		if("charge")
			chargemode = !chargemode
			if(!chargemode)
				charging = APC_NOT_CHARGING
				update_appearance()
			. = TRUE
		if("channel")
			if(params["eqp"])
				equipment = setsubsystem(text2num(params["eqp"]))
				update_appearance()
				update()
			else if(params["lgt"])
				lighting = setsubsystem(text2num(params["lgt"]))
				update_appearance()
				update()
			else if(params["env"])
				environ = setsubsystem(text2num(params["env"]))
				update_appearance()
				update()
			. = TRUE
		if("overload")
			if(area.hasSiliconAccessInArea(usr, PRIVILEGES_SILICON|PRIVILEGES_DRONE)) //usr.has_unlimited_silicon_privilege)
				overload_lighting()
				. = TRUE
		if("hack")
			if(get_malf_status(usr))
				malfhack(usr)
		if("drain")
			cell.use(cell.charge)
			hijacker.toggleSiliconAccessArea(area)
			hijacker = null
			set_hijacked_lighting()
			update_appearance()
			var/obj/item/implant/hijack/H = usr.getImplant(/obj/item/implant/hijack)
			H.stealthcooldown = world.time + 2 MINUTES
			energy_fail(30 SECONDS * (cell.charge / cell.maxcharge))
		if("lockdown")
			var/celluse = rand(20,35)
			celluse = celluse /100
			if(!cell.use(cell.maxcharge*celluse))
				return
			for (var/obj/machinery/door/D in GLOB.airlocks)
				if (get_area(D) == area)
					INVOKE_ASYNC(D,TYPE_PROC_REF(/obj/machinery/door, hostile_lockdown),usr, FALSE)
					addtimer(CALLBACK(D,TYPE_PROC_REF(/obj/machinery/door, disable_lockdown), FALSE), 30 SECONDS)
			var/obj/item/implant/hijack/H = usr.getImplant(/obj/item/implant/hijack)
			H.stealthcooldown = world.time + 3 MINUTES
		if("occupy")
			if(get_malf_status(usr))
				malfoccupy(usr)
		if("deoccupy")
			if(get_malf_status(usr))
				malfvacate()
		if("reboot")
			failure_timer = 0
			force_update = FALSE
			update_appearance()
			update()
		if("emergency_lighting")
			emergency_lights = !emergency_lights
			for(var/obj/machinery/light/L in area)
				if(!initial(L.no_emergency)) //If there was an override set on creation, keep that override
					L.no_emergency = emergency_lights
					INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light, update), FALSE)
				CHECK_TICK
	return TRUE

/obj/machinery/power/apc/proc/toggle_breaker(mob/user)
	if(!is_operational() || failure_timer)
		return
	operating = !operating
	add_hiddenprint(user) //delete when runtime
	log_game("[key_name(user)] turned [operating ? "on" : "off"] the [src] in [AREACOORD(src)]")
	update()
	update_appearance()

/obj/machinery/power/apc/proc/hijack(mob/living/L)
	if (!istype(L))
		return
	if(being_hijacked)
		to_chat(L, "<span class='warning'>This APC is already being hijacked!</span>")
		return
	if (hijacker && hijacker != L)
		var/obj/item/implant/hijack/H = L.getImplant(/obj/item/implant/hijack)
		to_chat(L, "<span class='warning'>Someone already has control of this APC. Beginning counter-hijack.</span>")
		H.hijacking = TRUE
		being_hijacked = TRUE
		if (do_after(L,20 SECONDS,target=src))
			hijacker.toggleSiliconAccessArea(area)
			if (L.toggleSiliconAccessArea(area))
				hijacker = L
				update_appearance()
				set_hijacked_lighting()
			H.hijacking = FALSE
			being_hijacked = FALSE
			return
		else
			to_chat(L, "<span class='warning'>Aborting.</span>")
			H.hijacking = FALSE
			being_hijacked = FALSE
			return
	to_chat(L, "<span class='notice'>Beginning hijack of APC.</span>")
	var/obj/item/implant/hijack/H = L.getImplant(/obj/item/implant/hijack)
	H.hijacking = TRUE
	being_hijacked = TRUE
	if (do_after(L,H.stealthmode ? 12 SECONDS : 5 SECONDS,target=src))
		if (L.toggleSiliconAccessArea(area))
			hijacker = L
			update_appearance()
			set_hijacked_lighting()
			H.hijacking = FALSE
			being_hijacked = FALSE
	else
		to_chat(L, "<span class='warning'>Aborting.</span>")
		H.hijacking = FALSE
		being_hijacked = FALSE
		return

/obj/machinery/power/apc/proc/malfhack(mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(get_malf_status(malf) != 1)
		return
	if(malf.malfhacking)
		to_chat(malf, "You are already hacking an APC.")
		return
	var/area/ourarea = get_area(src)
	if(!ourarea.valid_malf_hack)
		to_chat(malf, "This APC is not well connected enough to the Exonet to provide any useful processing capabilities.")
		return
	to_chat(malf, "Beginning override of APC systems. This takes some time, and you cannot perform other actions during the process.")
	malf.malfhack = src
	malf.malfhacking = addtimer(CALLBACK(malf, TYPE_PROC_REF(/mob/living/silicon/ai, malfhacked), src), 600, TIMER_STOPPABLE)

	var/atom/movable/screen/alert/hackingapc/A
	A = malf.throw_alert("hackingapc", /atom/movable/screen/alert/hackingapc)
	A.target = src

/obj/machinery/power/apc/proc/malfoccupy(mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(istype(malf.loc, /obj/machinery/power/apc)) // Already in an APC
		to_chat(malf, "<span class='warning'>You must evacuate your current APC first!</span>")
		return
	if(!malf.can_shunt)
		to_chat(malf, "<span class='warning'>You cannot shunt!</span>")
		return
	if(!is_station_level(z))
		return
	malf.ShutOffDoomsdayDevice()
	occupier = new /mob/living/silicon/ai(src, malf.laws, malf) //DEAR GOD WHY?	//IKR????
	occupier.adjustOxyLoss(malf.getOxyLoss())
	if(!findtext(occupier.name, "APC Copy"))
		occupier.name = "[malf.name] APC Copy"
	if(malf.parent)
		occupier.parent = malf.parent
	else
		occupier.parent = malf
	malf.shunted = 1
	occupier.eyeobj.name = "[occupier.name] (AI Eye)"
	if(malf.parent)
		qdel(malf)
	add_verb(occupier, /mob/living/silicon/ai/proc/corereturn)
	occupier.cancel_camera()

/obj/machinery/power/apc/proc/malfvacate(forced)
	if(!occupier)
		return
	if(occupier.parent && occupier.parent.stat != DEAD)
		occupier.mind.transfer_to(occupier.parent)
		occupier.parent.shunted = 0
		occupier.parent.setOxyLoss(occupier.getOxyLoss())
		occupier.parent.cancel_camera()
		remove_verb(occupier.parent, /mob/living/silicon/ai/proc/corereturn)
		qdel(occupier)
	else
		to_chat(occupier, "<span class='danger'>Primary core damaged, unable to return core processes.</span>")
		if(forced)
			occupier.forceMove(drop_location())
			occupier.death()
			occupier.gib()
			for(var/obj/item/pinpointer/nuke/P in GLOB.pinpointer_list)
				P.switch_mode_to(TRACK_NUKE_DISK) //Pinpointers go back to tracking the nuke disk
				P.alert = FALSE

/obj/machinery/power/apc/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(card.AI)
		to_chat(user, "<span class='warning'>[card] is already occupied!</span>")
		return
	if(!occupier)
		to_chat(user, "<span class='warning'>There's nothing in [src] to transfer!</span>")
		return
	if(!occupier.mind || !occupier.client)
		to_chat(user, "<span class='warning'>[occupier] is either inactive or destroyed!</span>")
		return
	if(!occupier.parent.stat)
		to_chat(user, "<span class='warning'>[occupier] is refusing all attempts at transfer!</span>" )
		return
	if(transfer_in_progress)
		to_chat(user, "<span class='warning'>There's already a transfer in progress!</span>")
		return
	if(interaction != AI_TRANS_TO_CARD || occupier.stat)
		return
	var/turf/T = get_turf(user)
	if(!T)
		return
	transfer_in_progress = TRUE
	user.visible_message("<span class='notice'>[user] slots [card] into [src]...</span>", "<span class='notice'>Transfer process initiated. Sending request for AI approval...</span>")
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	SEND_SOUND(occupier, sound('sound/misc/notice2.ogg')) //To alert the AI that someone's trying to card them if they're tabbed out
	if(alert(occupier, "[user] is attempting to transfer you to \a [card.name]. Do you consent to this?", "APC Transfer", "Yes - Transfer Me", "No - Keep Me Here") == "No - Keep Me Here")
		to_chat(user, "<span class='danger'>AI denied transfer request. Process terminated.</span>")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
		transfer_in_progress = FALSE
		return
	if(user.loc != T)
		to_chat(user, "<span class='danger'>Location changed. Process terminated.</span>")
		to_chat(occupier, "<span class='warning'>[user] moved away! Transfer canceled.</span>")
		transfer_in_progress = FALSE
		return
	to_chat(user, "<span class='notice'>AI accepted request. Transferring stored intelligence to [card]...</span>")
	to_chat(occupier, "<span class='notice'>Transfer starting. You will be moved to [card] shortly.</span>")
	if(!do_after(user, 50, target = src))
		to_chat(occupier, "<span class='warning'>[user] was interrupted! Transfer canceled.</span>")
		transfer_in_progress = FALSE
		return
	if(!occupier || !card)
		transfer_in_progress = FALSE
		return
	user.visible_message("<span class='notice'>[user] transfers [occupier] to [card]!</span>", "<span class='notice'>Transfer complete! [occupier] is now stored in [card].</span>")
	to_chat(occupier, "<span class='notice'>Transfer complete! You've been stored in [user]'s [card.name].</span>")
	occupier.forceMove(card)
	card.AI = occupier
	occupier.parent.shunted = FALSE
	occupier.cancel_camera()
	occupier = null
	transfer_in_progress = FALSE
	return

/obj/machinery/power/apc/surplus()
	if(terminal)
		return terminal.surplus()
	else
		return FALSE

/obj/machinery/power/apc/add_load(amount)
	if(terminal && terminal.powernet)
		terminal.add_load(amount)

/obj/machinery/power/apc/avail(amount)
	if(terminal)
		return terminal.avail(amount)
	else
		return FALSE

/obj/machinery/power/apc/process()
	if(icon_update_needed)
		update_appearance()
	if(machine_stat & (BROKEN|MAINT))
		return
	if(!area || !area.requires_power)
		return
	if(failure_timer)
		failure_timer--
		force_update = TRUE
		return

	lastused_light = area.usage(STATIC_LIGHT)
	lastused_light += area.usage(LIGHT)
	lastused_equip = area.usage(EQUIP)
	lastused_equip += area.usage(STATIC_EQUIP)
	lastused_environ = area.usage(ENVIRON)
	lastused_environ += area.usage(STATIC_ENVIRON)
	area.clear_usage()

	lastused_total = lastused_light + lastused_equip + lastused_environ

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/excess = surplus()

	if(!avail())
		main_status = APC_NO_POWER
	else if(excess < 0)
		main_status = APC_LOW_POWER
	else
		main_status = APC_HAS_POWER

	if(cell && !shorted)
		// draw power from cell as before to power the area
		var/cellused = min(cell.charge, lastused_total JOULES) // clamp deduction to a max, amount left in cell
		cell.use(cellused)
	//If drained by an integration cog: Forcefully avert as much of the powerdrain as possible, though a maximum of MAXIMUM_COG_REGAIN
		if(excess && cog_drained)
			var/cog_regain = cell.give(min(min(cog_drained, excess), MAXIMUM_COG_REGAIN))
			excess -= cog_regain
			cog_drained = max(0, cog_drained - cog_regain)

		if(excess > lastused_total) // if power excess recharge the cell
										// by the same amount just used
			cell.give(cellused)
			add_load(cellused WATTS) // add the load used to recharge the cell
		else // no excess, and not enough per-apc
			if((cell.charge WATTS + excess) >= lastused_total) // can we draw enough from cell+grid to cover last usage?
				cell.charge = min(cell.maxcharge, cell.charge + excess JOULES) //recharge with what we can
				add_load(excess) // so draw what we can from the grid
				charging = APC_NOT_CHARGING

			else // not enough power available to run the last tick!
				charging = APC_NOT_CHARGING
				chargecount = 0
				// This turns everything off in the case that there is still a charge left on the battery, just not enough to run the room.
				equipment = autoset(equipment, AUTOSET_FORCE_OFF)
				lighting = autoset(lighting, AUTOSET_FORCE_OFF)
				environ = autoset(environ, AUTOSET_FORCE_OFF)


		// set channels depending on how much charge we have left

		// Allow the APC to operate as normal if the cell can charge
		if(charging && longtermpower < 10)
			longtermpower += 1
		else if(longtermpower > -10)
			longtermpower -= 2

		if(cell.charge <= 0) // zero charge, turn all off
			equipment = autoset(equipment, AUTOSET_FORCE_OFF)
			lighting = autoset(lighting, AUTOSET_FORCE_OFF)
			environ = autoset(environ, AUTOSET_FORCE_OFF)
			alarm_manager.send_alarm(ALARM_POWER)
		else if(cell.percent() < 15 && longtermpower < 0) // <15%, turn off lighting & equipment
			equipment = autoset(equipment, AUTOSET_OFF)
			lighting = autoset(lighting, AUTOSET_OFF)
			environ = autoset(environ, AUTOSET_ON)
			alarm_manager.send_alarm(ALARM_POWER)
		else if(cell.percent() < 30 && longtermpower < 0) // <30%, turn off equipment
			equipment = autoset(equipment, AUTOSET_OFF)
			lighting = autoset(lighting, AUTOSET_ON)
			environ = autoset(environ, AUTOSET_ON)
			alarm_manager.send_alarm(ALARM_POWER)
		else // otherwise all can be on
			equipment = autoset(equipment, AUTOSET_ON)
			lighting = autoset(lighting, AUTOSET_ON)
			environ = autoset(environ, AUTOSET_ON)
			if(cell.percent() > 75)
				alarm_manager.clear_alarm(ALARM_POWER)

		// now trickle-charge the cell
		if(chargemode && charging == APC_CHARGING && operating)
			if(excess > 0) // check to make sure we have enough to charge
				// Max charge is capped to % per second constant
				var/ch = min(excess JOULES, cell.maxcharge JOULES)
				add_load(ch WATTS) // Removes the power we're taking from the grid
				cell.give(ch) // actually recharge the cell

			else
				charging = APC_NOT_CHARGING // stop charging
				chargecount = 0

		// show cell as fully charged if so
		if(cell.charge >= cell.maxcharge)
			cell.charge = cell.maxcharge
			charging = APC_FULLY_CHARGED

		if(chargemode)
			if(!charging)
				if(excess > cell.maxcharge*GLOB.CHARGELEVEL)
					chargecount++
				else
					chargecount = 0

				if(chargecount == 10)

					chargecount = 0
					charging = APC_CHARGING

		else // chargemode off
			charging = APC_NOT_CHARGING
			chargecount = 0

	else // no cell, switch everything off

		charging = APC_NOT_CHARGING
		chargecount = 0
		equipment = autoset(equipment, AUTOSET_FORCE_OFF)
		lighting = autoset(lighting, AUTOSET_FORCE_OFF)
		environ = autoset(environ, AUTOSET_FORCE_OFF)
		alarm_manager.send_alarm(ALARM_POWER)

	// update icon & area power if anything changed

	if(last_lt != lighting || last_eq != equipment || last_en != environ || force_update)
		force_update = FALSE
		queue_icon_update()
		update()
	else if (last_ch != charging)
		queue_icon_update()

/**
 * Returns the new status value for an APC channel.
 *
 * // val 0=off, 1=off(auto) 2=on 3=on(auto)
 * // on 0=off, 1=on, 2=autooff
 * TODO: Make this use bitflags instead. It should take at most three lines, but it's out of scope for now.
 *
 * Arguments:
 * - val: The current status of the power channel.
 *   - [APC_CHANNEL_OFF]: The APCs channel has been manually set to off. This channel will not automatically change.
 *   - [APC_CHANNEL_AUTO_OFF]: The APCs channel is running on automatic and is currently off. Can be automatically set to [APC_CHANNEL_AUTO_ON].
 *   - [APC_CHANNEL_ON]: The APCs channel has been manually set to on. This will be automatically changed only if the APC runs completely out of power or is disabled.
 *   - [APC_CHANNEL_AUTO_ON]: The APCs channel is running on automatic and is currently on. Can be automatically set to [APC_CHANNEL_AUTO_OFF].
 * - on: An enum dictating how to change the channel's status.
 *   - [AUTOSET_FORCE_OFF]: The APC forces the channel to turn off. This includes manually set channels.
 *   - [AUTOSET_ON]: The APC allows automatic channels to turn back on.
 *   - [AUTOSET_OFF]: The APC turns automatic channels off.
 */
/obj/machinery/power/apc/proc/autoset(val, on)
	if(on == AUTOSET_FORCE_OFF)
		if(val == APC_CHANNEL_ON) // if on, return off
			return APC_CHANNEL_OFF
		else if(val == APC_CHANNEL_AUTO_ON) // if auto-on, return auto-off
			return APC_CHANNEL_AUTO_OFF
	else if(on == AUTOSET_ON)
		if(val == APC_CHANNEL_AUTO_OFF) // if auto-off, return auto-on
			return APC_CHANNEL_AUTO_ON
	else if(on == AUTOSET_OFF)
		if(val == APC_CHANNEL_AUTO_ON) // if auto-on, return auto-off
			return APC_CHANNEL_AUTO_OFF
	return val

/**
 * Used by external forces to set the APCs channel status's.
 *
 * Arguments:
 * - val: The desired value of the subsystem:
 *   - 1: Manually sets the APCs channel to be [APC_CHANNEL_OFF].
 *   - 2: Manually sets the APCs channel to be [APC_CHANNEL_AUTO_ON]. If the APC doesn't have any power this defaults to [APC_CHANNEL_OFF] instead.
 *   - 3: Sets the APCs channel to be [APC_CHANNEL_AUTO_ON]. If the APC doesn't have enough power this defaults to [APC_CHANNEL_AUTO_OFF] instead.
 */
/obj/machinery/power/apc/proc/setsubsystem(val)
	if(cell && cell.charge > 0)
		return (val == 1) ? APC_CHANNEL_OFF : val
	if(val == 3)
		return APC_CHANNEL_AUTO_OFF
	return APC_CHANNEL_OFF

/obj/machinery/power/apc/proc/reset(wire)
	switch(wire)
		if(WIRE_IDSCAN)
			locked = TRUE
		if(WIRE_POWER1, WIRE_POWER2)
			if(!wires.is_cut(WIRE_POWER1) && !wires.is_cut(WIRE_POWER2))
				shorted = FALSE
		if(WIRE_AI)
			if(!wires.is_cut(WIRE_AI))
				aidisabled = FALSE
		if(APC_RESET_EMP)
			equipment = APC_CHANNEL_AUTO_ON
			environ = APC_CHANNEL_AUTO_ON
			update_appearance()
			update()

// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
	. = ..()
	if (!(. & EMP_PROTECT_CONTENTS))
		if(cell)
			cell.emp_act(severity)
		if(occupier)
			occupier.emp_act(severity)
	if(. & EMP_PROTECT_SELF)
		return
	lighting = APC_CHANNEL_OFF
	equipment = APC_CHANNEL_OFF
	environ = APC_CHANNEL_OFF
	update_appearance()
	update()
	addtimer(CALLBACK(src, PROC_REF(reset), APC_RESET_EMP), 600)

/obj/machinery/power/apc/blob_act(obj/structure/blob/B)
	set_broken()

/obj/machinery/power/apc/disconnect_terminal()
	if(terminal)
		terminal.master = null
		terminal = null

/obj/machinery/power/apc/proc/set_broken()
	if(malfai && operating)
		malfai.malf_picker.processing_time = clamp(malfai.malf_picker.processing_time - 10,0,1000)
	operating = FALSE
	obj_break()
	if(occupier)
		malfvacate(1)
	update()

// overload all the lights in this APC area

/obj/machinery/power/apc/proc/overload_lighting()
	if(/* !get_connection() || */ !operating || shorted)
		return
	if( cell && cell.charge>=20)
		cell.use(20)
		INVOKE_ASYNC(src, PROC_REF(break_lights))

/obj/machinery/power/apc/proc/break_lights()
	for(var/obj/machinery/light/L in area)
		L.on = TRUE
		INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light, break_light_tube))
		L.on = FALSE
		stoplag()

/obj/machinery/power/apc/proc/shock(mob/user, prb)
	if(!prob(prb))
		return FALSE
	do_sparks(5, TRUE, src)
	if(isalien(user))
		return FALSE
	if(electrocute_mob(user, src, src, 1, TRUE))
		return TRUE
	else
		return FALSE

/obj/machinery/power/apc/proc/energy_fail(duration)
	for(var/obj/machinery/M in area.contents)
		if(M.critical_machine)
			return
	for(var/A in GLOB.ai_list)
		var/mob/living/silicon/ai/I = A
		if(get_base_area(I) == area)
			return

	failure_timer = max(failure_timer, round(duration))
	update()
	queue_icon_update()

/obj/machinery/power/apc/proc/set_nightshift(on)
	set waitfor = FALSE
	if(nightshift_lights == on)
		return
	nightshift_lights = on
	for(var/obj/machinery/light/L in area)
		if(L.nightshift_allowed)
			L.nightshift_enabled = nightshift_lights
			INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light, update), FALSE)
		CHECK_TICK

/obj/machinery/power/apc/proc/set_hijacked_lighting()
	set waitfor = FALSE
	for(var/obj/machinery/light/L in area)
		L.hijacked = hijackerreturn()
		INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light, break_light_tube), FALSE)
		CHECK_TICK

/obj/machinery/power/apc/proc/update_nightshift_auth_requirement()
	nightshift_requires_auth = nightshift_toggle_requires_auth()

/obj/machinery/power/apc/proc/nightshift_toggle_requires_auth()
	if(!area)
		return FALSE
	var/configured_level = CONFIG_GET(number/night_shift_public_areas_only)
	var/our_level = area.nightshift_public_area
	var/public_requires_auth = CONFIG_GET(flag/nightshift_toggle_public_requires_auth)
	var/normal_requires_auth = CONFIG_GET(flag/nightshift_toggle_requires_auth)
	return (configured_level && our_level && ((our_level <= configured_level)? public_requires_auth : normal_requires_auth))


#undef APC_CHANNEL_OFF
#undef APC_CHANNEL_AUTO_OFF
#undef APC_CHANNEL_ON
#undef APC_CHANNEL_AUTO_ON

#undef AUTOSET_FORCE_OFF
#undef AUTOSET_OFF
#undef AUTOSET_ON

#undef APC_NO_POWER
#undef APC_LOW_POWER
#undef APC_HAS_POWER

#undef APC_ELECTRONICS_MISSING
#undef APC_ELECTRONICS_INSTALLED
#undef APC_ELECTRONICS_SECURED

#undef APC_COVER_CLOSED
#undef APC_COVER_OPENED
#undef APC_COVER_REMOVED

#undef APC_NOT_CHARGING
#undef APC_CHARGING
#undef APC_FULLY_CHARGED

#undef APC_DRAIN_TIME
#undef APC_POWER_GAIN

#undef APC_RESET_EMP

// update_state
#undef UPSTATE_CELL_IN
#undef UPSTATE_COVER_SHIFT
#undef UPSTATE_BROKE
#undef UPSTATE_MAINT
#undef UPSTATE_BLUESCREEN
#undef UPSTATE_WIREEXP

//update_overlay
#undef UPOVERLAY_OPERATING
#undef UPOVERLAY_LOCKED
#undef UPOVERLAY_CHARGING_SHIFT
#undef UPOVERLAY_EQUIPMENT_SHIFT
#undef UPOVERLAY_LIGHTING_SHIFT
#undef UPOVERLAY_ENVIRON_SHIFT
#undef MAXIMUM_COG_REGAIN

/*Power module, used for APC construction*/
/obj/item/electronics/apc
	name = "power control module"
	icon_state = "power_mod"
	custom_price = PRICE_CHEAP
	desc = "Heavy-duty switching circuits for power control."
