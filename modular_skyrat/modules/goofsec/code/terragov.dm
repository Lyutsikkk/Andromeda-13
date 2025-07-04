#define TERRAGOV_AMT "amount"
#define TERRAGOV_VOTES "votes"
#define TERRAGOV_DECLARED "declared"
#define TERRAGOV_FINE_AMOUNT -20000

#define EMERGENCY_RESPONSE_POLICE "WOOP WOOP THAT'S THE SOUND OF THE POLICE"
#define EMERGENCY_RESPONSE_ATMOS "DISCO INFERNO"
#define EMERGENCY_RESPONSE_EMT "AAAAAUGH, I'M DYING, I NEEEEEEEEEED A MEDIC BAG"
#define EMERGENCY_RESPONSE_EMAG "AYO THE PIZZA HERE"

GLOBAL_VAR(caller_of_911)
GLOBAL_VAR(call_911_msg)
GLOBAL_VAR(pizza_order)
GLOBAL_VAR_INIT(terragov_tech_charge, -7500)
GLOBAL_LIST_INIT(pizza_names, list(
	"Dixon Buttes",
	"I. C. Weiner",
	"Seymour Butz",
	"I. P. Freely",
	"Pat Myaz",
	"Vye Agra",
	"Harry Balsack",
	"Lee Nover",
	"Maya Buttreeks",
	"Amanda Hugginkiss",
	"Bwight K. Brute", // Github Copilot suggested dwight from the office like 10 times
	"John Nanotrasen",
	"Mike Rotch",
	"Hugh Jass",
	"Oliver Closeoff",
	"Hugh G. Recktion",
	"Phil McCrevis",
	"Willie Lickerbush",
	"Ben Dover",
	"Steve", // REST IN PEACE MAN
	"Avery Goodlay",
	"Anne Fetamine",
	"Amanda Peon",
	"Tara Newhole",
	"Penny Tration",
	"Joe Mama"
))
GLOBAL_LIST_INIT(emergency_responders, list())
GLOBAL_LIST_INIT(terragov_responder_info, list(
	"911_responders" = list(
		TERRAGOV_AMT = 0,
		TERRAGOV_VOTES = 0,
		TERRAGOV_DECLARED = FALSE
	),
	"swat" = list(
		TERRAGOV_AMT = 0,
		TERRAGOV_VOTES = 0,
		TERRAGOV_DECLARED = FALSE
	),
	"national_guard" = list(
		TERRAGOV_AMT = 0,
		TERRAGOV_VOTES = 0,
		TERRAGOV_DECLARED = FALSE
	),
	"dogginos" = list(
		TERRAGOV_AMT = 0,
		TERRAGOV_VOTES = 0,
		TERRAGOV_DECLARED = FALSE
	),
	"dogginos_manager" = list(
		TERRAGOV_AMT = 0,
		TERRAGOV_VOTES = 0,
		TERRAGOV_DECLARED = FALSE
	)
))
GLOBAL_LIST_INIT(call911_do_and_do_not, list(
	EMERGENCY_RESPONSE_EMT = "You SHOULD call EMTs for:\n\
		Large or excessive amounts of dead bodies, emergency medical situations that the station can't handle, etc.\n\
		You SHOULD NOT call EMTs for:\n\
		The Captain stubbing their toe, one or two dead bodies, minor viral outbreaks, etc.\n\
		Are you sure you want to call EMTs?",
	EMERGENCY_RESPONSE_POLICE = "You SHOULD call Marshals for:\n\
		Security ignoring Command, Security violating civil rights, Security engaging in Mutiny, \
		General Violation of Terran Government Citizen Rights by Command/Security, etc.\n\
		You SHOULD NOT call Marshals for:\n\
		Corporate affairs, manhunts, settling arguments, etc.\n\
		Are you sure you want to call Marshals?",
	EMERGENCY_RESPONSE_ATMOS = "You SHOULD call Advanced Atmospherics for:\n\
		Stationwide atmospherics loss, wide-scale supermatter delamination related repairs, unending fires filling the hallways, or department-sized breaches with Engineering and Atmospherics unable to handle it, etc. \n\
		You SHOULD NOT call Advanced Atmospherics for:\n\
		A trashcan on fire in the library, a single breached room, heating issues, etc. - especially with capable Engineers/Atmos Techs.\n\
		There is a response fee of [abs(GLOB.terragov_tech_charge)] credits per emergency responder.\n\
		Are you sure you want to call Advanced Atmospherics?"
))

/// Internal. Polls ghosts and sends in a team of space cops according to the alert level, accompanied by an announcement.
/obj/machinery/computer/communications/proc/call_911(ordered_team)
	var/team_size
	var/cops_to_send
	var/announcement_message = "sussus amogus"
	var/announcer = "Terran Government Marshal Department"
	var/poll_question = "fuck you leatherman"
	var/cell_phone_number = "911"
	var/list_to_use = "911_responders"
	switch(ordered_team)
		if(EMERGENCY_RESPONSE_POLICE)
			team_size = 8
			cops_to_send = /datum/antagonist/ert/request_911/police
			announcement_message = "Crewmembers of [station_name()]. this is the Terran Government. We've received a request for immediate marshal support, and we are \
				sending our best marshals to support your station.\n\n\
				If the first responders request that they need SWAT support to do their job, or to report a faulty 911 call, we will send them in at additional cost to your station to the \
				tune of $20,000.\n\n\
				The transcript of the call is as follows:\n\
				[GLOB.call_911_msg]"
			announcer = "Terran Government Marshal Department"
			poll_question = "The station has called for the Marshals. Will you respond?"
		if(EMERGENCY_RESPONSE_ATMOS)
			team_size = tgui_input_number(usr, "How many techs would you like dispatched?", "How badly did you screw up?", 3, 3, 1)
			cops_to_send = /datum/antagonist/ert/request_911/atmos
			announcement_message = "Crewmembers of [station_name()]. this is the Terran Government's 811 dispatch. We've received a report of stationwide structural damage, atmospherics loss, fire, or otherwise, and we are \
				sending an Advanced Atmospherics team to support your station.\n\n\
				The transcript of the call is as follows:\n\
				[GLOB.call_911_msg]"
			announcer = "Terran Government 811 Dispatch - Advanced Atmospherics"
			poll_question = "The station has called for an advanced engineering support team. Will you respond?"
			cell_phone_number = "911"	//This needs to stay so they can communicate with SWAT
		if(EMERGENCY_RESPONSE_EMT)
			team_size = 8
			cops_to_send = /datum/antagonist/ert/request_911/emt
			announcement_message = "Crewmembers of [station_name()]. this is the Terran Government. We've received a request for immediate medical support, and we are \
				sending our best emergency medical technicians to support your station.\n\n\
				If the first responders request that they need SWAT support to do their job, or to report a faulty 911 call, we will send them in at additional cost to your station to the \
				tune of $20,000.\n\n\
				The transcript of the call is as follows:\n\
				[GLOB.call_911_msg]"
			announcer = "Terran Government EMTs"
			poll_question = "The station has called for medical support. Will you respond?"
		if(EMERGENCY_RESPONSE_EMAG)
			team_size = 8
			cops_to_send = /datum/antagonist/ert/pizza/false_call
			announcement_message = "Thank you for ordering from Dogginos, [GLOB.pizza_order]! We're sending you that extra-large party package pizza delivery \
				right away!\n\n\
				Thank you for choosing our premium Fifteen Minutes or Less delivery option! Our pizza will be at your doorstep at [station_name()] as soon as possible thanks \
				to our lightning-fast warp drives installed on all Dogginos delivery shuttles!\n\
				Distance from your chosen Dogginos: 70,000 Lightyears"
			announcer = "Dogginos"
			poll_question = "The station has ordered $35,000 in pizza. Will you deliver?"
			cell_phone_number = "Dogginos"
			list_to_use = "dogginos"
	priority_announce(announcement_message, announcer, 'sound/effects/families_police.ogg', has_important_message=TRUE, color_override = "yellow")
	var/list/candidates = SSpolling.poll_ghost_candidates(poll_question, check_jobban = "deathsquad", alert_pic = /obj/item/card/id/advanced/terragov, role_name_text = "Terran Government response team")

	if(candidates.len)
		//Pick the (un)lucky players
		var/agents_number = min(team_size, candidates.len)

		var/list/spawnpoints = GLOB.emergencyresponseteamspawn
		var/index = 0
		GLOB.terragov_responder_info[list_to_use][TERRAGOV_AMT] = agents_number
		while(agents_number && candidates.len)
			var/spawn_loc = spawnpoints[index + 1]
			//loop through spawnpoints one at a time
			index = (index + 1) % spawnpoints.len
			var/mob/dead/observer/chosen_candidate = pick(candidates)
			candidates -= chosen_candidate
			if(!chosen_candidate.key)
				continue

			//Spawn the body
			var/mob/living/carbon/human/cop = new(spawn_loc)
			chosen_candidate.client.prefs.safe_transfer_prefs_to(cop, is_antag = TRUE)
			cop.key = chosen_candidate.key

			//Give antag datum
			var/datum/antagonist/ert/request_911/ert_antag = new cops_to_send

			cop.mind.add_antag_datum(ert_antag)
			cop.mind.set_assigned_role(SSjob.get_job_type(ert_antag.ert_job_path))
			SSjob.send_to_late_join(cop)
			cop.grant_language(/datum/language/common, source = LANGUAGE_SPAWNER)

			if(cops_to_send == /datum/antagonist/ert/request_911/atmos) // charge for atmos techs
				var/datum/bank_account/station_balance = SSeconomy.get_dep_account(ACCOUNT_CAR)
				station_balance?.adjust_money(GLOB.terragov_tech_charge)
			else
				var/obj/item/gangster_cellphone/phone = new() // biggest gang in the city
				phone.gang_id = cell_phone_number
				phone.name = "[cell_phone_number] branded cell phone"
				phone.w_class = WEIGHT_CLASS_SMALL	//They get that COMPACT phone hell yea
				var/phone_equipped = phone.equip_to_best_slot(cop)
				if(!phone_equipped)
					to_chat(cop, "Your [phone.name] has been placed at your feet.")
					phone.forceMove(get_turf(cop))

			//Logging and cleanup
			log_game("[key_name(cop)] has been selected as an [ert_antag.name]")
			if(cops_to_send == /datum/antagonist/ert/request_911/atmos)
				log_game("[abs(GLOB.terragov_tech_charge)] has been charged from the station budget for [key_name(cop)]")
			agents_number--
	GLOB.cops_arrived = TRUE
	return TRUE

/obj/machinery/computer/communications/proc/pre_911_check(mob/user)
	if (!authenticated_as_silicon_or_captain(user))
		return FALSE

	if (GLOB.cops_arrived)
		to_chat(user, span_warning("911 has already been called this shift!"))
		playsound(src, 'sound/machines/terminal/terminal_prompt_deny.ogg', 50, FALSE)
		return FALSE

	if (!issilicon(user))
		var/obj/item/held_item = user.get_active_held_item()
		var/obj/item/card/id/id_card = held_item?.GetID()
		if (!istype(id_card))
			to_chat(user, span_warning("You need to swipe your ID!"))
			playsound(src, 'sound/machines/terminal/terminal_prompt_deny.ogg', 50, FALSE)
			return FALSE
		if (!(ACCESS_CAPTAIN in id_card.access))
			to_chat(user, span_warning("You are not authorized to do this!"))
			playsound(src, 'sound/machines/terminal/terminal_prompt_deny.ogg', 50, FALSE)
			return FALSE
	else
		to_chat(user, "The console refuses to let you dial 911 as an AI or Cyborg!")
		return FALSE
	return TRUE

/obj/machinery/computer/communications/proc/calling_911(mob/user, called_group_pretty = "EMTs", called_group = EMERGENCY_RESPONSE_EMT)
	message_admins("[ADMIN_LOOKUPFLW(user)] is considering calling the Terran Government [called_group_pretty].")
	var/call_911_msg_are_you_sure = "Are you sure you want to call 911? Faulty 911 calls results in a $20,000 fine and a 5 year superjail \
		sentence."
	if(tgui_alert(user, call_911_msg_are_you_sure, "Call 911", list("No", "Yes")) != "Yes")
		return
	message_admins("[ADMIN_LOOKUPFLW(user)] has acknowledged the faulty 911 call consequences.")
	if(tgui_alert(user, GLOB.call911_do_and_do_not[called_group], "Call [called_group_pretty]", list("No", "Yes")) != "Yes")
		return
	message_admins("[ADMIN_LOOKUPFLW(user)] has read and acknowleged the recommendations for what to call and not call [called_group_pretty] for.")
	var/reason_to_call_911 = tgui_input_text(user, "What do you wish to call 911 [called_group_pretty] for?", "Call 911", null, MAX_MESSAGE_LEN)
	if(!reason_to_call_911)
		to_chat(user, "You decide not to call 911.")
		return
	GLOB.cops_arrived = TRUE
	GLOB.call_911_msg = reason_to_call_911
	GLOB.caller_of_911 = user.name
	log_game("[key_name(user)] has called the Terran Government [called_group_pretty] for the following reason:\n[GLOB.call_911_msg]")
	message_admins("[ADMIN_LOOKUPFLW(user)] has called the Terran Government [called_group_pretty] for the following reason:\n[GLOB.call_911_msg]")
	deadchat_broadcast(" has called the Terran Government [called_group_pretty] for the following reason:\n[GLOB.call_911_msg]", span_name("[user.real_name]"), user, message_type = DEADCHAT_ANNOUNCEMENT)

	call_911(called_group)
	to_chat(user, span_notice("Authorization confirmed. 911 call dispatched to the Terran Government [called_group_pretty]."))
	playsound(src, 'sound/machines/terminal/terminal_prompt_confirm.ogg', 50, FALSE)

/datum/antagonist/ert/request_911
	name = "911 Responder"
	antag_hud_name = "hud_spacecop"
	suicide_cry = "FOR THE Terran Government!!"
	var/department = "Some stupid shit"

/datum/antagonist/ert/request_911/apply_innate_effects(mob/living/mob_override)
	..()
	var/mob/living/M = mob_override || owner.current
	if(M.hud_used)
		var/datum/hud/H = M.hud_used
		var/atom/movable/screen/wanted/giving_wanted_lvl = new /atom/movable/screen/wanted(null, H)
		H.wanted_lvl = giving_wanted_lvl
		H.infodisplay += giving_wanted_lvl
		H.mymob.client.screen += giving_wanted_lvl


/datum/antagonist/ert/request_911/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	if(M.hud_used)
		var/datum/hud/H = M.hud_used
		H.infodisplay -= H.wanted_lvl
		QDEL_NULL(H.wanted_lvl)
	..()

/datum/antagonist/ert/request_911/greet()
	var/missiondesc =  ""
	missiondesc += "<B><font size=5 color=red>You are NOT a Nanotrasen Employee. You work for the Terran Government as a [role].</font></B>"
	missiondesc += "<BR>You are responding to emergency calls from the station for immediate TerraGov [department] assistance!\n"
	missiondesc += "<BR>Use the Cell Phone in your backpack to confer with fellow first responders!\n"
	missiondesc += "<BR><B>911 Transcript is as follows</B>:"
	missiondesc += "<BR> [GLOB.call_911_msg]"
	missiondesc += "<BR><B>Your Mission</B>:"
	missiondesc += "<BR> <B>1.</B> Contact [GLOB.caller_of_911] and assist them in resolving the matter."
	missiondesc += "<BR> <B>2.</B> Protect, ensure, and uphold the rights of Terran Government citizens on board [station_name()]."
	missiondesc += "<BR> <B>3.</B> If you believe yourself to be in danger, unable to do the job assigned to you due to a dangerous situation, \
		or that the 911 call was made in error, you can use the S.W.A.T. Backup Caller in your backpack to vote on calling a S.W.A.T. team to assist in the situation."
	missiondesc += "<BR> <B>4.</B> When you have finished with your work on the station, use the Beamout Tool in your backpack to beam out yourself \
		along with anyone you are pulling."
	to_chat(owner, missiondesc)
	var/mob/living/greeted_mob = owner.current
	greeted_mob.playsound_local(greeted_mob, 'sound/effects/families_police.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/datum/outfit/request_911
	name = "911 Response: Base"
	back = /obj/item/storage/backpack/duffelbag/cops
	backpack_contents = list(/obj/item/terragov_reporter/swat_caller = 1)

	id_trim = /datum/id_trim/space_police

/datum/outfit/request_911/post_equip(mob/living/carbon/human/human_to_equip, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/ID_to_give = human_to_equip.wear_id
	if(istype(ID_to_give))
		shuffle_inplace(ID_to_give.access) // Shuffle access list to make NTNet passkeys less predictable
		ID_to_give.registered_name = human_to_equip.real_name
		if(human_to_equip.age)
			ID_to_give.registered_age = human_to_equip.age
		ID_to_give.update_label()
		ID_to_give.update_icon()
		human_to_equip.sec_hud_set_ID()

/obj/item/modular_computer/pda/request_911
	name = "Terragov PDA"
	desc = "A small experimental microcomputer, up to Terragov 911 Responder standards."
	icon_state = "/obj/item/modular_computer/pda/request_911"
	greyscale_config = /datum/greyscale_config/tablet/captain
	greyscale_colors = "#EAEAEA#66CCFF#FFCC00#5F5F5F"
	max_capacity = parent_type::max_capacity * 2
	inserted_item = /obj/item/pen/fountain
	long_ranged = TRUE
	starting_programs = list(
	)

/obj/item/modular_computer/pda/request_911/police
	name = "Terragov Marshal PDA"
	icon_state = "/obj/item/modular_computer/pda/request_911/police"
	greyscale_colors = "#EAEAEA#66CCFF#FFD900#CC5075"
	inserted_item = /obj/item/pen/red/security
	starting_programs = list(
		/datum/computer_file/program/records/security,
	)

/obj/item/modular_computer/pda/request_911/atmos
	name = "Terragov Atmospherics PDA"
	icon_state = "/obj/item/modular_computer/pda/request_911/atmos"
	greyscale_colors = "#EAEAEA#66CCFF#FFD900#7DDEFF"
	starting_programs = list(
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/supermatter_monitor,
	)

/obj/item/modular_computer/pda/request_911/emt
	name = "Terragov Medical PDA"
	icon_state = "/obj/item/modular_computer/pda/request_911/emt"
	greyscale_colors = "#EAEAEA#66CCFF#FFD900#7284D4"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/radar/lifeline,
		/datum/computer_file/program/supermatter_monitor,
	)

/*
*	POLICE
*/

/datum/antagonist/ert/request_911/police
	name = "Marshal"
	role = "Marshal"
	department = "Marshal"
	outfit = /datum/outfit/request_911/police

/datum/outfit/request_911/police
	name = "911 Response: Marshal"
	back = /obj/item/storage/backpack/satchel
	uniform = /obj/item/clothing/under/sol_peacekeeper
	suit = /obj/item/clothing/suit/armor/vest/det_suit/terra
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/jackboots
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/headset_sec/alt
	head = /obj/item/clothing/head/soft/black
	suit_store = /obj/item/gun/energy/disabler
	belt = /obj/item/storage/belt/security/full
	r_pocket = /obj/item/flashlight/seclite
	l_pocket = /obj/item/gun/ballistic/revolver/sol
	id = /obj/item/card/id/advanced/terragov
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/ammo_box/c35sol = 1,
		/obj/item/terragov_reporter/swat_caller = 1,
		/obj/item/beamout_tool = 1,
		/obj/item/taperecorder = 1,
		/obj/item/storage/box/evidence = 1,
		/obj/item/modular_computer/pda/request_911/police = 1,
		/obj/item/holosign_creator/security = 1,
	)

	id_trim = /datum/id_trim/terragov

/*
*	ADVANCED ATMOSPHERICS
*/

/datum/antagonist/ert/request_911/atmos
	name = "Adv. Atmos Tech"
	role = "Adv. Atmospherics Technician"
	department = "Advanced Atmospherics"
	outfit = /datum/outfit/request_911/atmos

/datum/outfit/request_911/atmos
	name = "811 Response: Advanced Atmospherics"
	back = /obj/item/mod/control/pre_equipped/advanced/atmos
	uniform = /obj/item/clothing/under/rank/engineering/atmospheric_technician/skyrat/utility/advanced
	shoes = /obj/item/clothing/shoes/jackboots/peacekeeper
	ears = /obj/item/radio/headset/headset_terragov/atmos
	mask = /obj/item/clothing/mask/gas/atmos/glass
	belt = /obj/item/storage/belt/utility/full/powertools/ircd
	suit_store = /obj/item/tank/internals/oxygen/yellow
	id = /obj/item/card/id/advanced/terragov
	r_pocket = /obj/item/modular_computer/pda/request_911/atmos
	l_pocket = /obj/item/holosign_creator/atmos
	backpack_contents = list(/obj/item/storage/box/rcd_ammo = 1,
		/obj/item/storage/box/smart_metal_foam = 1,
		/obj/item/multitool = 1,
		/obj/item/extinguisher/advanced = 1,
		/obj/item/rwd/loaded = 1,
		/obj/item/beamout_tool = 1,
		/obj/item/terragov_reporter/swat_caller = 1,
		/obj/item/inducer = 1,
	)
	id_trim = /datum/id_trim/terragov/atmos

/obj/item/radio/headset/headset_terragov/atmos
	name = "\improper TerraGov adv. atmos headset"
	desc = "A headset used by the Terran Government response teams."
	icon_state = "med_headset"
	keyslot = /obj/item/encryptionkey/headset_terragov/atmos
	radiosound = 'modular_skyrat/modules/radiosound/sound/radio/security.ogg'

/obj/item/encryptionkey/headset_terragov/atmos
	name = "\improper TerraGov adv. atmos encryption key"
	icon_state = "/obj/item/encryptionkey/headset_terragov/atmos"
	post_init_icon_state = "cypherkey_medical"
	special_channels = RADIO_SPECIAL_CENTCOM
	channels = list(RADIO_CHANNEL_TERRAGOV = 1, RADIO_CHANNEL_ENGINEERING = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_medical
	greyscale_colors = "#ebebeb#2b2793"

/*
*	EMT
*/

/datum/antagonist/ert/request_911/emt
	name = "Emergency Medical Technician"
	role = "EMT"
	department = "EMT"
	outfit = /datum/outfit/request_911/emt

/datum/outfit/request_911/emt
	name = "911 Response: EMT"
	back = /obj/item/storage/backpack/medic
	uniform = /obj/item/clothing/under/sol_emt
	shoes = /obj/item/clothing/shoes/jackboots
	ears = /obj/item/radio/headset/headset_med
	mask = /obj/item/clothing/mask/gas/alt
	head = /obj/item/clothing/head/helmet/toggleable/sf_hardened/emt
	id = /obj/item/card/id/advanced/terragov
	suit = /obj/item/clothing/suit/armor/sf_hardened/emt
	gloves = /obj/item/clothing/gloves/latex/nitrile
	belt = /obj/item/storage/backpack/duffelbag/deforest_medkit/stocked
	suit_store = /obj/item/tank/internals/emergency_oxygen/engi
	r_pocket = /obj/item/flashlight/seclite
	l_pocket = /obj/item/storage/medkit/civil_defense
	r_hand = /obj/item/storage/backpack/duffelbag/deforest_surgical/stocked
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/emergency_bed = 1,
		/obj/item/terragov_reporter/swat_caller = 1,
		/obj/item/beamout_tool = 1,
		/obj/item/defibrillator/compact/loaded = 1,
		/obj/item/modular_computer/pda/request_911/emt = 1,
		/obj/item/holosign_creator/medical = 1,
		/obj/item/holosign_creator/medical/treatment_zone = 1,
	)

	id_trim = /datum/id_trim/terragov

/datum/antagonist/ert/request_911/condom_destroyer
	name = "Armed S.W.A.T. Officer"
	role = "S.W.A.T. Officer"
	department = "Police"
	outfit = /datum/outfit/request_911/condom_destroyer

/datum/antagonist/ert/request_911/condom_destroyer/greet()
	var/missiondesc =  ""
	missiondesc += "<B><font size=5 color=red>You are NOT a Nanotrasen Employee. You work for the Terran Government as a [role].</font></B>"
	missiondesc += "<BR>You are here to backup the 911 first responders, as they have reported for your assistance..\n"
	missiondesc += "<BR><B>Your Mission</B>:"
	missiondesc += "<BR> <B>1.</B> Contact the first responders using the Cell Phone in your backpack to figure out the situation."
	missiondesc += "<BR> <B>2.</B> Arrest anyone who interferes the work of the first responders."
	missiondesc += "<BR> <B>3.</B> Use lethal force in the arrest of the suspects if they will not comply, or the station refuses to comply."
	missiondesc += "<BR> <B>4.</B> If you believe the station is engaging in treason and is firing upon first responders and S.W.A.T. members, use the \
		Treason Reporter in your backpack to call the military."
	missiondesc += "<BR> <B>5.</B> When you have finished with your work on the station, use the Beamout Tool in your backpack to beam out yourself \
		along with anyone you are pulling."
	to_chat(owner, missiondesc)
	var/mob/living/greeted_mob = owner.current
	greeted_mob.playsound_local(greeted_mob, 'sound/effects/families_police.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/datum/outfit/request_911/condom_destroyer
	name = "911 Response: Armed S.W.A.T. Officer"
	back = /obj/item/storage/backpack
	uniform = /obj/item/clothing/under/sol_peacekeeper
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/tackler/combat
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/headset_sec/alt
	head = /obj/item/clothing/head/helmet/sf_peacekeeper
	belt = /obj/item/gun/energy/e_gun
	suit = /obj/item/clothing/suit/armor/sf_peacekeeper
	r_pocket = /obj/item/flashlight/seclite
	l_pocket = /obj/item/restraints/handcuffs
	id = /obj/item/card/id/advanced/terragov
	l_hand = /obj/item/gun/ballistic/automatic/sol_rifle
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/melee/baton/telescopic = 1,
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = 3,
		/obj/item/terragov_reporter/treason_reporter = 1,
		/obj/item/beamout_tool = 1,
	)

	id_trim = /datum/id_trim/terragov

/datum/antagonist/ert/request_911/treason_destroyer
	name = "Terran Government Peacekeeper"
	role = "Private"
	department = "Military"
	outfit = /datum/outfit/request_911/treason_destroyer

/datum/antagonist/ert/request_911/treason_destroyer/greet()
	var/missiondesc =  ""
	missiondesc += "<B><font size=5 color=red>You are NOT a Nanotrasen Employee. You work for the Terran Government as a [role].</font></B>"
	missiondesc += "<BR>You are here to assume control of [station_name()] due to the occupants engaging in Treason as reported by our SWAT team.\n"
	missiondesc += "<BR><B>Your Mission</B>:"
	missiondesc += "<BR> <B>1.</B> Contact the SWAT Team and the First Responders via your cell phone to get the situation from them."
	missiondesc += "<BR> <B>2.</B> Arrest all suspects involved in the treason attempt."
	missiondesc += "<BR> <B>3.</B> Assume control of the station for the Terran Government, and initiate evacuation procedures to get non-offending citizens \
		away from the scene."
	missiondesc += "<BR> <B>4.</B> If you need to use lethal force, do so, but only if you must."
	to_chat(owner, missiondesc)
	var/mob/living/greeted_mob = owner.current
	greeted_mob.playsound_local(greeted_mob, 'sound/effects/families_police.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/datum/outfit/request_911/treason_destroyer
	name = "911 Response: TerraGov Military"

	uniform = /obj/item/clothing/under/sol_peacekeeper
	head = /obj/item/clothing/head/helmet/sf_sacrificial
	mask = /obj/item/clothing/mask/gas/alt
	gloves = /obj/item/clothing/gloves/combat
	suit = /obj/item/clothing/suit/armor/sf_sacrificial
	shoes = /obj/item/clothing/shoes/jackboots

	back = /obj/item/storage/backpack
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/headset_sec/alt
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/flashlight/seclite
	id = /obj/item/card/id/advanced/terragov
	r_hand = /obj/item/gun/ballistic/automatic/sol_rifle
	backpack_contents = list(
		/obj/item/storage/box/handcuffs = 1,
		/obj/item/sacrificial_face_shield = 1,
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = 4,
	)

	id_trim = /datum/id_trim/terragov

/obj/item/terragov_reporter
	name = "TerraGov reporter"
	desc = "Use this in-hand to vote to call TerraGov backup. If half your team votes for it, SWAT will be dispatched."
	icon = 'modular_skyrat/modules/goofsec/icons/reporter.dmi'
	icon_state = "reporter_off"
	w_class = WEIGHT_CLASS_SMALL
	/// Was the reporter turned on?
	var/activated = FALSE
	/// What antagonist should be required to use the reporter?
	var/type_to_check = /datum/antagonist/ert/request_911
	/// What table should we be incrementing votes in and checking against in the terragov responders global?
	var/type_of_callers = "911_responders"
	/// What source should be supplied for the announcement message?
	var/announcement_source = "Terran Government S.W.A.T."
	/// Should the station be issued a fine when the vote completes?
	var/fine_station = TRUE
	/// What poll message should we show to the ghosts when they are asked to join the squad?
	var/ghost_poll_msg = "example crap"
	/// How many ghosts should we pick from the applicants to become members of the squad?
	var/amount_to_summon = 4
	/// What antagonist type should we give to the ghosts?
	var/type_to_summon = /datum/antagonist/ert/request_911/condom_destroyer
	/// What table should be be incrementing amount in in the terragov responders global?
	var/summoned_type = "swat"
	/// What name and ID should be on the cell phone given to the squad members?
	var/cell_phone_number = "911"
	/// What jobban should we be checking for the ghost polling?
	var/jobban_to_check = ROLE_DEATHSQUAD
	/// What announcement message should be displayed if the vote succeeds?
	var/announcement_message = "Пример сообщения об объявлении"

/obj/item/terragov_reporter/proc/pre_checks(mob/user)
	if(GLOB.terragov_responder_info[type_of_callers][TERRAGOV_AMT] == 0)
		to_chat(user, span_warning("There are no responders. You likely spawned this in as an admin. Please don't do this."))
		return FALSE
	if(!user.mind.has_antag_datum(type_to_check))
		to_chat(user, span_warning("You don't know how to use this!"))
		return FALSE
	return TRUE

/obj/item/terragov_reporter/proc/questions(mob/user)
	return TRUE

/obj/item/terragov_reporter/attack_self(mob/user, modifiers)
	. = ..()
	if(!pre_checks(user))
		return
	if(!activated && !GLOB.terragov_responder_info[type_of_callers][TERRAGOV_DECLARED])
		if(!questions(user))
			return
		activated = TRUE
		icon_state = "reporter_on"
		GLOB.terragov_responder_info[type_of_callers][TERRAGOV_VOTES]++
		var/current_votes = GLOB.terragov_responder_info[type_of_callers][TERRAGOV_VOTES]
		var/amount_of_responders = GLOB.terragov_responder_info[type_of_callers][TERRAGOV_AMT]
		to_chat(user, span_warning("You have activated the device. \
		Current Votes: [current_votes]/[amount_of_responders] votes."))
		if(current_votes >= amount_of_responders * 0.5)
			GLOB.terragov_responder_info[type_of_callers][TERRAGOV_DECLARED] = TRUE
			if(fine_station)
				var/datum/bank_account/station_balance = SSeconomy.get_dep_account(ACCOUNT_CAR)
				station_balance?.adjust_money(TERRAGOV_FINE_AMOUNT) // paying for the gas to drive all the fuckin' way out to the frontier

			priority_announce(announcement_message, announcement_source, 'sound/effects/families_police.ogg', has_important_message = TRUE, color_override = "yellow")
			var/list/candidates = SSpolling.poll_ghost_candidates(ghost_poll_msg, jobban_to_check)

			if(candidates.len)
				//Pick the (un)lucky players
				var/agents_number = min(amount_to_summon, candidates.len)
				GLOB.terragov_responder_info[summoned_type][TERRAGOV_AMT] = agents_number

				var/list/spawnpoints = GLOB.emergencyresponseteamspawn
				var/index = 0
				while(agents_number && candidates.len)
					var/spawn_loc = spawnpoints[index + 1]
					//loop through spawnpoints one at a time
					index = (index + 1) % spawnpoints.len
					var/mob/dead/observer/chosen_candidate = pick(candidates)
					candidates -= chosen_candidate
					if(!chosen_candidate.key)
						continue

					//Spawn the body
					var/mob/living/carbon/human/cop = new(spawn_loc)
					chosen_candidate.client.prefs.safe_transfer_prefs_to(cop, is_antag = TRUE)
					cop.key = chosen_candidate.key

					//Give antag datum
					var/datum/antagonist/ert/request_911/ert_antag = new type_to_summon

					cop.mind.add_antag_datum(ert_antag)
					cop.mind.set_assigned_role(SSjob.get_job_type(ert_antag.ert_job_path))
					SSjob.send_to_late_join(cop)
					cop.grant_language(/datum/language/common, source = LANGUAGE_SPAWNER)

					var/obj/item/gangster_cellphone/phone = new() // biggest gang in the city
					phone.gang_id = cell_phone_number
					phone.name = "[cell_phone_number] branded cell phone"
					var/phone_equipped = phone.equip_to_best_slot(cop)
					if(!phone_equipped)
						to_chat(cop, "Your [phone.name] has been placed at your feet.")
						phone.forceMove(get_turf(cop))

					//Logging and cleanup
					log_game("[key_name(cop)] has been selected as an [ert_antag.name]")
					agents_number--

/obj/item/terragov_reporter/swat_caller
	name = "S.W.A.T. backup caller"
	desc = "Use this in-hand to vote to call TerraGov S.W.A.T. backup. If half your team votes for it, SWAT will be dispatched."
	type_to_check = /datum/antagonist/ert/request_911
	type_of_callers = "911_responders"
	announcement_source = "Terran Government S.W.A.T."
	fine_station = TRUE
	ghost_poll_msg = "The Sol-Fed 911 services have requested a S.W.A.T. backup. Do you wish to become a S.W.A.T. member?"
	amount_to_summon = 6
	type_to_summon = /datum/antagonist/ert/request_911/condom_destroyer
	summoned_type = "swat"
	announcement_message = "Hello, crewmembers. Our emergency services have requested S.W.A.T. backup, either for assistance doing their job due to crew \
		impediment, or due to a fraudulent 911 call. We have billed the station $20,000 for this, to cover the expenses of flying a second emergency response to \
		your station. Please comply with all requests by said S.W.A.T. members."

/obj/item/terragov_reporter/swat_caller/questions(mob/user)
	var/question = "Does the situation require additional S.W.A.T. backup, involve the station impeding you from doing your job, \
		or involve the station making a fraudulent 911 call and needing an arrest made on the caller?"
	if(tgui_alert(user, question, "S.W.A.T. Backup Caller", list("No", "Yes")) != "Yes")
		to_chat(user, "You decide not to request S.W.A.T. backup.")
		return FALSE
	message_admins("[ADMIN_LOOKUPFLW(user)] has voted to summon S.W.A.T backup.")
	return TRUE

/obj/item/terragov_reporter/treason_reporter
	name = "treason reporter"
	desc = "Use this in-hand to vote that the station is engaging in Treason. If half your team votes for it, the Military will handle the situation."
	type_to_check = /datum/antagonist/ert/request_911/condom_destroyer
	type_of_callers = "swat"
	announcement_source = "Terran Government National Guard"
	fine_station = FALSE
	ghost_poll_msg = "The station has decided to engage in treason. Do you wish to join the Terran Government Military?"
	amount_to_summon = 12
	type_to_summon = /datum/antagonist/ert/request_911/treason_destroyer
	summoned_type = "national_guard"
	announcement_message = "Crewmembers of the station. You have refused to comply with first responders and SWAT officers, and have assaulted them, \
		and they are unable to carry out the wills of the Terran Government, despite residing within Terran Government borders.\n\
		As such, we are charging those responsible with Treason. The penalty of which is death, or no less than twenty-five years in Superjail.\n\
		Treason is a serious crime. Our military forces are en route to your station. They will be assuming direct control of the station, and \
		will be evacuating civilians from the scene.\n\
		Non-offending citizens, prepare for evacuation. Comply with all orders given to you by Terran Government military personnel.\n\
		To all those who are engaging in treason, lay down your weapons and surrender. Refusal to comply may be met with lethal force."

/obj/item/terragov_reporter/treason_reporter/questions(mob/user)
	var/list/list_of_questions = list(
		"Treason is the crime of attacking a state authority to which one owes allegiance. The station is located within Terran Government space, \
			and owes allegiance to the Terran Government despite being owned by Nanotrasen. Did the station engage in this today?",
		"Did station crewmembers assault you or the SWAT team at the direction of Security and/or Command?",
		"Did station crewmembers actively prevent you and the SWAT team from accomplishing your objectives at the direction of Security and/or Command?",
		"Were you and your fellow SWAT members unable to handle the issue on your own?",
		"Are you absolutely sure you wish to declare the station as engaging in Treason? Misuse of this can and will result in \
			administrative action against your account."
	)
	for(var/question in list_of_questions)
		if(tgui_alert(user, question, "Treason Reporter", list("No", "Yes")) != "Yes")
			to_chat(user, "You decide not to declare the station as treasonous.")
			return FALSE
	message_admins("[ADMIN_LOOKUPFLW(user)] has acknowledged the consequences of a false claim of Treason administratively, \
		and has voted that the station is engaging in Treason.")
	return TRUE

/obj/item/terragov_reporter/pizza_managers
	name = "Dogginos uncompliant customer reporter"
	desc = "Use this in-hand to vote to call for Dogginos Regional Managers if the station refuses to pay for their pizza. \
		If half your delivery squad votes for it, Dogginos Regional Managers will be dispatched."
	type_to_check = /datum/antagonist/ert/pizza/false_call
	type_of_callers = "dogginos"
	announcement_message = "Hey there, custo-mores! Our delivery drivers have reported that you guys are having some issues with payment for your order that \
		you placed at the Dogginos that's the seventh furthest Dogginos in the galaxy from your station, and we want to ensure maximum customer satisfaction and \
		employee satisfaction as well.\n\
		We've gone ahead and sent some some of our finest regional managers to handle the situation.\n\
		We hope you enjoy your pizzas, and that we'll be able to receive the bill of $35,000 plus the fifteen percent tip for our drivers shortly!"
	announcement_source = "Dogginos"
	fine_station = FALSE
	ghost_poll_msg = "Dogginos is sending regional managers to get the station to pay up the pizza money they owe. Are you ready to do some Customer Relations?"
	amount_to_summon = 8
	type_to_summon = /datum/antagonist/ert/pizza/leader/false_call
	summoned_type = "dogginos_manager"
	cell_phone_number = "Dogginos"

/obj/item/terragov_reporter/pizza_managers/questions(mob/user)
	if(tgui_alert(user, "Is the station refusing to pay their bill of $35,000, including a fifteen percent tip for delivery drivers?", "Dogginos Uncompliant Customer Reporter", list("No", "Yes")) != "Yes")
		to_chat(user, "You decide not to request management assist you with the delivery.")
		return FALSE
	message_admins("[ADMIN_LOOKUPFLW(user)] has voted to summon Dogginos management to resolve the lack of payment.")
	return TRUE

/datum/antagonist/ert/pizza/false_call
	outfit = /datum/outfit/centcom/ert/pizza/false_call

/datum/outfit/centcom/ert/pizza/false_call
	backpack_contents = list(
		/obj/item/storage/box/survival,
		/obj/item/knife,
		/obj/item/storage/box/ingredients/italian,
		/obj/item/terragov_reporter/pizza_managers,
	)
	r_hand = /obj/item/pizzabox/meat
	l_hand = /obj/item/pizzabox/vegetable

/datum/antagonist/ert/pizza/false_call/greet()
	var/missiondesc =  ""
	missiondesc += "<B><font size=5 color=red>You are NOT a Nanotrasen Employee. You work for Dogginos as a delivery person.</font></B>"
	missiondesc += "<BR>You are here to deliver some pizzas from Dogginos!\n"
	missiondesc += "<BR>Use the Cell Phone in your backpack to confer with fellow Dogginos employees!\n"
	missiondesc += "<BR><B>Your Mission</B>:"
	missiondesc += "<BR> <B>1.</B> Deliver the pizzas ordered by [GLOB.pizza_order]."
	missiondesc += "<BR> <B>2.</B> Collect the bill, which totals to $35,000 plus a fifteen percent tip for delivery drivers."
	missiondesc += "<BR> <B>3.</B> If they refuse to pay, you may summon the Dogginos Regional Managers to help resolve the issue."
	to_chat(owner, missiondesc)

/datum/antagonist/ert/pizza/leader/false_call/greet()
	var/missiondesc =  ""
	missiondesc += "<B><font size=5 color=red>You are NOT a Nanotrasen Employee. You work for Dogginos as a Regional Manager.</font></B>"
	missiondesc += "<BR>You are here to resolve a dispute with some customers who refuse to pay their bill!\n"
	missiondesc += "<BR>Use the Cell Phone in your backpack to confer with fellow Dogginos employees!\n"
	missiondesc += "<BR><B>Your Mission</B>:"
	missiondesc += "<BR> <B>1.</B> Collect the money owed by [GLOB.pizza_order], which amounts to $35,000 plus a fifteen percent tip for the delivery drivers."
	missiondesc += "<BR> <B>2.</B> Use any means necessary to collect the owed funds. The thousand degree knife in your backpack will help in this task."
	to_chat(owner, missiondesc)

/obj/item/beamout_tool
	name = "beam-out tool" // TODO, find a way to make this into drop pods cuz that's cooler visually
	desc = "Use this to begin the lengthy beam-out  process to return to Terran Government space. It will bring anyone you are pulling with you."
	icon = 'modular_skyrat/modules/goofsec/icons/reporter.dmi'
	icon_state = "beam_me_up_scotty"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/beamout_tool/attack_self(mob/user, modifiers)
	. = ..()
	if(!user.mind.has_antag_datum(/datum/antagonist/ert))
		to_chat(user, span_warning("You don't understand how to use this device."))
		return
	message_admins("[ADMIN_LOOKUPFLW(user)] has begun to beam-out using their beam-out tool.")
	to_chat(user, "You have begun the beam-out process. Please wait for the beam to reach the station.")
	user.balloon_alert(user, "begun beam-out")
	if(do_after(user, 30 SECONDS))
		to_chat(user, "You have completed the beam-out process and are returning to the Terran Government.")
		message_admins("[ADMIN_LOOKUPFLW(user)] has beamed themselves out.")
		if(isliving(user))
			var/mob/living/living_user = user
			if(living_user.pulling)
				if(ishuman(living_user.pulling))
					var/mob/living/carbon/human/beamed_human = living_user.pulling
					message_admins("[ADMIN_LOOKUPFLW(user)] has beamed out [ADMIN_LOOKUPFLW(beamed_human)] alongside them.")
				else
					message_admins("[ADMIN_LOOKUPFLW(user)] has beamed out [living_user.pulling] alongside them.")
				var/turf/pulling_turf = get_turf(living_user.pulling)
				playsound(pulling_turf, 'sound/effects/magic/Repulse.ogg', 100, 1)
				var/datum/effect_system/spark_spread/quantum/sparks = new
				sparks.set_up(10, 1, pulling_turf)
				sparks.attach(pulling_turf)
				sparks.start()
				qdel(living_user.pulling)
			var/turf/user_turf = get_turf(living_user)
			playsound(user_turf, 'sound/effects/magic/Repulse.ogg', 100, 1)
			var/datum/effect_system/spark_spread/quantum/sparks = new
			sparks.set_up(10, 1, user_turf)
			sparks.attach(user_turf)
			sparks.start()
			qdel(user)
	else
		user.balloon_alert(user, "beam-out cancelled")

#undef TERRAGOV_AMT
#undef TERRAGOV_VOTES
#undef TERRAGOV_DECLARED
#undef TERRAGOV_FINE_AMOUNT

#undef EMERGENCY_RESPONSE_POLICE
#undef EMERGENCY_RESPONSE_ATMOS
#undef EMERGENCY_RESPONSE_EMT
#undef EMERGENCY_RESPONSE_EMAG
