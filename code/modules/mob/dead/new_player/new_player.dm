///Cooldown for the Reset Lobby Menu HUD verb
#define RESET_HUD_INTERVAL 15 SECONDS
/mob/dead/new_player
	flags_1 = NONE
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	stat = DEAD
	//hud_type = /datum/hud/new_player SKYRAT EDIT REMOVAL
	hud_possible = list()

	var/ready = FALSE
	/// Referenced when you want to delete the new_player later on in the code.
	var/spawning = FALSE
	/// For instant transfer once the round is set up
	var/mob/living/new_character
	///Used to make sure someone doesn't get spammed with messages if they're ineligible for roles.
	var/ineligible_for_roles = FALSE
	/// Used to track if the player's jobs menu sent a message saying it successfully mounted.
	var/jobs_menu_mounted = FALSE
	///Cooldown for the Reset Lobby Menu HUD verb
	COOLDOWN_DECLARE(reset_hud_cooldown)

/mob/dead/new_player/Initialize(mapload)
	if(client && SSticker.state == GAME_STATE_STARTUP)
		var/atom/movable/screen/splash/fade_out = new(null, null, client, TRUE)
		fade_out.Fade(TRUE)

	if(length(GLOB.newplayer_start))
		forceMove(pick(GLOB.newplayer_start))
	else
		forceMove(locate(1,1,1))

	. = ..()

	GLOB.new_player_list += src
	add_verb(src, /mob/dead/new_player/proc/reset_menu_hud)

/mob/dead/new_player/Destroy()
	GLOB.new_player_list -= src

	return ..()

/mob/dead/new_player/mob_negates_gravity()
	return TRUE //no need to calculate if they have gravity.

/mob/dead/new_player/prepare_huds()
	return

/mob/dead/new_player/Topic(href, href_list)
	if (usr != src)
		return

	if (!client)
		return

	if (client.interviewee)
		return

	if (href_list["viewpoll"])
		var/datum/poll_question/poll = locate(href_list["viewpoll"]) in GLOB.polls
		poll_player(poll)

	if (href_list["votepollref"])
		var/datum/poll_question/poll = locate(href_list["votepollref"]) in GLOB.polls
		vote_on_poll_handler(poll, href_list)

//When you cop out of the round (NB: this HAS A SLEEP FOR PLAYER INPUT IN IT)
/mob/dead/new_player/proc/make_me_an_observer()
	if(QDELETED(src) || !src.client)
		ready = PLAYER_NOT_READY
		return FALSE

	var/less_input_message
	if(SSlag_switch.measures[DISABLE_DEAD_KEYLOOP])
		less_input_message = " - Уведомление: Наблюдатель freelook в настоящее время отключен."
	// Don't convert this to tgui please, it's way too important
	var/this_is_like_playing_right = alert(usr, "Вы уверены, что хотите наблюдать?[less_input_message]", "Наблюдать", "Да", "Нет") //SKYRAT EDIT CHANGE
	if(QDELETED(src) || !src.client || this_is_like_playing_right != "Да")
		ready = PLAYER_NOT_READY
		show_title_screen() // SKYRAT EDIT ADDITION
		return FALSE

	hide_title_screen() // SKYRAT EDIT ADDITION - Skyrat Titlescreen
	var/mob/dead/observer/observer = new()
	spawning = TRUE

	observer.started_as_observer = TRUE
	var/obj/effect/landmark/observer_start/O = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
	to_chat(src, span_notice("Можно телепортироваться."))
	if (O)
		observer.forceMove(O.loc)
	else
		to_chat(src, span_notice("Телепортация не удалась. Помогите администратору, пожалуйста"))
		stack_trace("На этой карте нет ни одного свободного ориентира для наблюдателей, или вы создаете наблюдателей до инициализации карты")

	observer.PossessByPlayer(key)
	observer.client = client
	observer.set_ghost_appearance()
	if(observer.client && observer.client.prefs)
		observer.real_name = observer.client.prefs.read_preference(/datum/preference/name/real_name)
		observer.name = observer.real_name
		observer.client.init_verbs()
		observer.persistent_client.time_of_death = world.time

	observer.update_appearance()
	observer.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	deadchat_broadcast(" наблюдает.", "<b>[observer.real_name]</b>", follow_target = observer, turf_target = get_turf(observer), message_type = DEADCHAT_DEATHRATTLE)
	QDEL_NULL(mind)
	qdel(src)
	return TRUE

/proc/get_job_unavailable_error_message(retval, jobtitle)
	switch(retval)
		if(JOB_AVAILABLE)
			return "[jobtitle] доступен."
		if(JOB_UNAVAILABLE_GENERIC)
			return "[jobtitle] недоступен."
		if(JOB_UNAVAILABLE_BANNED)
			return "В настоящее время вам запрещено играть за [jobtitle]."
		if(JOB_UNAVAILABLE_PLAYTIME)
			return "У вас недостаточно игрового времени для [jobtitle]."
		if(JOB_UNAVAILABLE_ACCOUNTAGE)
			return "Ваша учетная запись недостаточно старая для [jobtitle]."
		if(JOB_UNAVAILABLE_SLOTFULL)
			return "[jobtitle] уже заполнен до отказа."
		//SKYRAT EDIT ADDITION
		if(JOB_UNAVAILABLE_QUIRK)
			return "[jobtitle] ограничено из-за ваших навыков."
		if(JOB_UNAVAILABLE_LANGUAGE)
			return "[jobtitle] ограничено из-за выбранных вами языков."
		if(JOB_UNAVAILABLE_SPECIES)
			return "[jobtitle] ограничено из-за выбранного вами вида."
		//BUBBER EDIT BEGIN: Silicon flavor text
		if(JOB_UNAVAILABLE_FLAVOUR)
			return "[jobtitle] требует от вас наличия [CONFIG_GET(number/flavor_text_character_requirement)] текста с описанием аромата. Перейдите к настройке символов и напишите больше."
		if(JOB_UNAVAILABLE_FLAVOUR_SILICON)
			return "[jobtitle] требует от вас наличия [CONFIG_GET(number/silicon_flavor_text_character_requirement)] текста с описанием аромата синта. Перейдите к настройке символов и напишите больше."
		//BUBBER EDIT END: Silicon flavor text
		if(JOB_UNAVAILABLE_AUGMENT)
			return "[jobtitle] ограничено из-за выбранных вами аугментаций тела."
		//SKYRAT EDIT END
		if(JOB_UNAVAILABLE_ANTAG_INCOMPAT)
			return "[jobtitle] не совместима с какой-то назначенной вам ролью антагониста."
		if(JOB_UNAVAILABLE_AGE)
			return "Ваш персонаж недостаточно взрослый для [jobtitle]."

	return GENERIC_JOB_UNAVAILABLE_ERROR

/mob/dead/new_player/proc/IsJobUnavailable(rank, latejoin = FALSE)
	var/datum/job/job = SSjob.get_job(rank)
	if(!(job.job_flags & JOB_NEW_PLAYER_JOINABLE))
		return JOB_UNAVAILABLE_GENERIC
	if((job.current_positions >= job.total_positions) && job.total_positions != -1)
		if(is_assistant_job(job))
			if(isnum(client.player_age) && client.player_age <= 14) //Newbies can always be assistants
				return JOB_AVAILABLE
			for(var/datum/job/other_job as anything in SSjob.joinable_occupations)
				if(other_job.current_positions < other_job.total_positions && other_job != job)
					return JOB_UNAVAILABLE_SLOTFULL
		else
			return JOB_UNAVAILABLE_SLOTFULL

	var/eligibility_check = SSjob.check_job_eligibility(src, job, "Mob IsJobUnavailable")
	if(eligibility_check != JOB_AVAILABLE)
		return eligibility_check

	if(latejoin && !job.special_check_latejoin(client))
		return JOB_UNAVAILABLE_GENERIC
	//SKYRAT EDIT ADDITION
	if(!job.has_required_languages(client.prefs))
		return JOB_UNAVAILABLE_LANGUAGE
	if(job.has_banned_quirk(client.prefs))
		return JOB_UNAVAILABLE_QUIRK
	if(job.has_banned_species(client.prefs))
		return JOB_UNAVAILABLE_SPECIES
	//SKYRAT EDIT END
	return JOB_AVAILABLE


/mob/dead/new_player/proc/AttemptLateSpawn(rank)
	// Check that they're picking someone new for new character respawning
	if(CONFIG_GET(flag/allow_respawn) == RESPAWN_FLAG_NEW_CHARACTER)
		if("[client.prefs.default_slot]" in persistent_client.joined_as_slots)
			tgui_alert(usr, "Вы уже играли этим персонажем в этом раунде! Зайдите за другого персонажа!")
			return FALSE

	var/error = IsJobUnavailable(rank)
	if(error != JOB_AVAILABLE)
		tgui_alert(usr, get_job_unavailable_error_message(error, rank))
		return FALSE

	if(SSshuttle.arrivals)
		if(SSshuttle.arrivals.damaged && CONFIG_GET(flag/arrivals_shuttle_require_safe_latejoin))
			tgui_alert(usr,"Шаттл прибытия сейчас неисправен! Вы не можете присоединиться.")
			return FALSE

		if(CONFIG_GET(flag/arrivals_shuttle_require_undocked))
			SSshuttle.arrivals.RequireUndocked(src)

	//Remove the player from the join queue if he was in one and reset the timer
	SSticker.queued_players -= src
	SSticker.queue_delay = 4

	var/datum/job/job = SSjob.get_job(rank)

	if(!SSjob.assign_role(src, job, TRUE))
		tgui_alert(usr, "Произошла непредвиденная ошибка, в результате которой вы не оказались на требуемой работе. Если вы не можете присоединиться к какому-либо должности, вам следует обратиться к администратору.")
		return FALSE

	hide_title_screen()// SKYRAT EDIT ADDITION
	mind.late_joiner = TRUE
	var/atom/destination = mind.assigned_role.get_latejoin_spawn_point()
	if(!destination)
		CRASH("Не удалось найти точку появления позднего соединения.")
	var/mob/living/character = create_character(destination)
	if(!character)
		CRASH("Не удалось создать персонажа для позднего присоединения.")
	transfer_character()

	SSjob.equip_rank(character, job, character.client)
	job.after_latejoin_spawn(character)

	#define IS_NOT_CAPTAIN 0
	#define IS_ACTING_CAPTAIN 1
	#define IS_FULL_CAPTAIN 2
	var/is_captain = IS_NOT_CAPTAIN
	var/captain_sound = 'sound/announcer/notice/notice2.ogg'
	// If we already have a captain, are they a "Captain" rank and are we allowing multiple of them to be assigned?
	if(is_captain_job(job))
		is_captain = IS_FULL_CAPTAIN
		captain_sound = ANNOUNCER_DEPARTMENTAL // SKYRAT EDIT CHANGE - Announcer Sounds
	// If we don't have an assigned cap yet, check if this person qualifies for some from of captaincy.
	else if(!SSjob.assigned_captain && ishuman(character) && SSjob.chain_of_command[rank] && !is_banned_from(character.ckey, list(JOB_CAPTAIN)))
		is_captain = IS_ACTING_CAPTAIN
	if(is_captain != IS_NOT_CAPTAIN)
		minor_announce(job.get_captaincy_announcement(character), sound_override = captain_sound)
		SSjob.promote_to_captain(character, is_captain == IS_ACTING_CAPTAIN)
	#undef IS_NOT_CAPTAIN
	#undef IS_ACTING_CAPTAIN
	#undef IS_FULL_CAPTAIN

	SSticker.minds += character.mind
	character.client.init_verbs() // init verbs for the late join
	var/mob/living/carbon/human/humanc
	if(ishuman(character))
		humanc = character //Let's retypecast the var to be human,

	if(humanc) //These procs all expect humans
		// BEGIN SKYRAT EDIT CHANGE - ALTERNATIVE_JOB_TITLES
		var/chosen_rank = humanc.client?.prefs.alt_job_titles?[rank] || rank
		if(SSshuttle.arrivals)
			SSshuttle.arrivals.QueueAnnounce(humanc, chosen_rank)
		else
			announce_arrival(humanc, chosen_rank)
		// END SKYRAT EDIT CHANGE - customization
		AddEmploymentContract(humanc)

		humanc.increment_scar_slot()
		humanc.load_persistent_scars()

		SSpersistence.load_modular_persistence(humanc.get_organ_slot(ORGAN_SLOT_BRAIN)) // SKYRAT EDIT ADDITION - MODULAR_PERSISTENCE


		if(GLOB.curse_of_madness_triggered)
			give_madness(humanc, GLOB.curse_of_madness_triggered)

	GLOB.joined_player_list += character.ckey

	if(CONFIG_GET(flag/allow_latejoin_antagonists) && humanc) //Borgs aren't allowed to be antags. Will need to be tweaked if we get true latejoin ais.
		if(SSshuttle.emergency)
			switch(SSshuttle.emergency.mode)
				if(SHUTTLE_RECALL, SHUTTLE_IDLE)
					SSdynamic.make_antag_chance(humanc)
				if(SHUTTLE_CALL)
					if(SSshuttle.emergency.timeLeft(1) > initial(SSshuttle.emergency_call_time)*0.5)
						SSdynamic.make_antag_chance(humanc)

	if((job.job_flags & JOB_ASSIGN_QUIRKS) && humanc && CONFIG_GET(flag/roundstart_traits))
		SSquirks.AssignQuirks(humanc, humanc.client)

	if(humanc) // Quirks may change manifest datapoints, so inject only after assigning quirks
		GLOB.manifest.inject(humanc, null, humanc.client) // SKYRAT EDIT - Added humanc.client - ALTERNATIVE_JOB_TITLES
		SEND_SIGNAL(humanc, COMSIG_HUMAN_CHARACTER_SETUP_FINISHED)
	var/area/station/arrivals = GLOB.areas_by_type[/area/station/hallway/secondary/entry]
	if(humanc && arrivals && !arrivals.power_environ) //arrivals depowered
		humanc.put_in_hands(new /obj/item/crowbar/large/emergency(get_turf(humanc))) //if hands full then just drops on the floor
	log_manifest(character.mind.key, character.mind, character, latejoin = TRUE)

/mob/dead/new_player/proc/AddEmploymentContract(mob/living/carbon/human/employee)
	//TODO:  figure out a way to exclude wizards/nukeops/demons from this.
	for(var/C in GLOB.employmentCabinets)
		var/obj/structure/filingcabinet/employment/employmentCabinet = C
		if(!employmentCabinet.virgin)
			employmentCabinet.addFile(employee)

/// Creates, assigns and returns the new_character to spawn as. Assumes a valid mind.assigned_role exists.
/mob/dead/new_player/proc/create_character(atom/destination)
	spawning = TRUE

	hide_title_screen() // SKYRAT EDIT ADDITION - titlescreen

	mind.active = FALSE //we wish to transfer the key manually
	var/mob/living/spawning_mob = mind.assigned_role.get_spawn_mob(client, destination)
	if(QDELETED(src) || !HAS_CONNECTED_PLAYER(src))
		return // Disconnected while checking for the appearance ban.

	if(!isAI(spawning_mob)) // Unfortunately there's still snowflake AI code out there.
		// transfer_to sets mind to null
		var/datum/mind/preserved_mind = mind
		preserved_mind.original_character_slot_index = client.prefs.default_slot
		preserved_mind.transfer_to(spawning_mob) //won't transfer key since the mind is not active
		preserved_mind.set_original_character(spawning_mob)

	LAZYADD(persistent_client.joined_as_slots, "[client.prefs.default_slot]")
	client.init_verbs()
	. = spawning_mob
	new_character = .


/mob/dead/new_player/proc/transfer_character()
	. = new_character
	if(!.)
		return
	new_character.PossessByPlayer(key) //Manually transfer the key to log them in,
	new_character.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	var/area/joined_area = get_area(new_character.loc)
	if(joined_area)
		joined_area.on_joining_game(new_character)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_CREWMEMBER_JOINED, new_character, new_character.mind.assigned_role.title)
	new_character = null
	qdel(src)

/mob/dead/new_player/proc/ViewManifest()
	if(!client)
		return
	GLOB.manifest.ui_interact(src)

/mob/dead/new_player/Move()
	return 0

// Used to make sure that a player has a valid job preference setup, used to knock players out of eligibility for anything if their prefs don't make sense.
// A "valid job preference setup" in this situation means at least having one job set to low, or not having "return to lobby" enabled
// Prevents "antag rolling" by setting antag prefs on, all jobs to never, and "return to lobby if preferences not available"
// Doing so would previously allow you to roll for antag, then send you back to lobby if you didn't get an antag role
// This also does some admin notification and logging as well, as well as some extra logic to make sure things don't go wrong
/mob/dead/new_player/proc/check_preferences()
	if(!client)
		return FALSE //Not sure how this would get run without the mob having a client, but let's just be safe.
	if(client.prefs.read_preference(/datum/preference/choiced/jobless_role) != RETURNTOLOBBY)
		return TRUE
	// If they have antags enabled, they're potentially doing this on purpose instead of by accident. Notify admins if so.
	var/has_antags = FALSE
	if(client.prefs.be_special.len > 0)
		has_antags = TRUE
	if(client.prefs.job_preferences.len == 0)
		if(!ineligible_for_roles)
			to_chat(src, span_danger("У вас не включены должности, а также возможность вернуться в лобби, если должность недоступна. Это лишает вас права претендовать на какую-либо роль в начале раунда, пожалуйста, обновите свои настройки работы."))
		ineligible_for_roles = TRUE
		ready = PLAYER_NOT_READY
		if(has_antags)
			log_admin("У [src.ckey] не включена ни одна должность, возвращиение в лобби, если должность недоступна и [client.prefs.be_special.len] включены настройки антага. Игрок был принудительно возвращен в лобби.")
			message_admins("У [src.ckey] не включена ни одна должность, возвращиение в лобби, если должность недоступна и [client.prefs.be_special.len] включены настройки антага. Это старый метод выбора антагонистов. Игрока попросили обновить свои рабочие настройки, и он был принудительно возвращен в лобби.")
		return FALSE //This is the only case someone should actually be completely blocked from antag rolling as well
	return TRUE

/**
 * Prepares a client for the interview system, and provides them with a new interview
 *
 * This proc will both prepare the user by removing all verbs from them, as well as
 * giving them the interview form and forcing it to appear.
 */
/mob/dead/new_player/proc/register_for_interview()
	// First we detain them by removing all the verbs they have on client
	for (var/v in client.verbs)
		var/procpath/verb_path = v
		remove_verb(client, verb_path)

	// Then remove those on their mob as well
	for (var/v in verbs)
		var/procpath/verb_path = v
		remove_verb(src, verb_path)

	// Then we create the interview form and show it to the client
	var/datum/interview/I = GLOB.interviews.interview_for_client(client)
	if (I)
		I.ui_interact(src)

	// Add verb for re-opening the interview panel, fixing chat and re-init the verbs for the stat panel
	add_verb(src, /mob/dead/new_player/proc/open_interview)
	add_verb(client, /client/verb/fix_tgui_panel)

///Resets the Lobby Menu HUD, recreating and reassigning it to the new player
/mob/dead/new_player/proc/reset_menu_hud()
	set name = "Рестарт лобби HUD"
	set category = "OOC"
	var/mob/dead/new_player/new_player = usr
	if(!COOLDOWN_FINISHED(new_player, reset_hud_cooldown))
		to_chat(new_player, span_warning("Вы должны подождать <b>[DisplayTimeText(COOLDOWN_TIMELEFT(new_player, reset_hud_cooldown))]</b> перед повторным сбросом настроек лобби-меню!"))
		return
	if(!new_player?.client)
		return
	COOLDOWN_START(new_player, reset_hud_cooldown, RESET_HUD_INTERVAL)
	qdel(new_player.hud_used)
	create_mob_hud()
	to_chat(new_player, span_info("Сброс настроек HUD в лобби-меню. Вы можете снова сбросить настройки HUD в <b>[DisplayTimeText(RESET_HUD_INTERVAL)]</b>."))
	hud_used.show_hud(hud_used.hud_version)

///Auto deadmins an admin when they click to toggle the ready button or join game button in the menu
/mob/dead/new_player/proc/auto_deadmin_on_ready_or_latejoin()
	if(!client?.holder) //If they aren't an admin we dont care
		return TRUE
	if(CONFIG_GET(flag/auto_deadmin_on_ready_or_latejoin) || (client.prefs.read_preference(/datum/preference/toggle/auto_deadmin_on_ready_or_latejoin)) || (client.prefs?.toggles & DEADMIN_ALWAYS))
		return client.holder.auto_deadmin()

#undef RESET_HUD_INTERVAL
