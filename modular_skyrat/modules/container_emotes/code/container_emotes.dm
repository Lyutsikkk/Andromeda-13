#define EXME_MAX_LOC_RECURSION 10 //no infinite loops

/mob/living/verb/container_emote()
	set name = "Использование эмоций Транспорт/Контейнер"
	set category = "IC"

	if (isturf(src.loc))
		to_chat(src, span_danger("Вы не находитесь ни в чем!"))
		return
	if (loc && (!src.IsUnconscious())) // If user's location is a turf, if it is not null, and if the user is not unconcious, continue.
		usr.emote("exme")

/datum/emote/container_emote
	key = "exme"
	message = null

/datum/emote/container_emote/run_emote(mob/living/user, params, type_override = null, intentional = TRUE)
	/// The message that will be sent from the container emote.
	var/container_message
	/// What was inputted by the user.
	var/container_emote = params
	if(QDELETED(user))
		return FALSE
	if(is_banned_from(user, "emote"))
		tgui_alert(user, "Вы не можете отправлять эмоции (бан).")
		return FALSE
	else if(user.client?.prefs?.muted & MUTE_IC)
		tgui_alert(user, "Вы не можете отправлять эмоции (мут).")
		return FALSE

	var/times_searched = 0
	var/can_use = TRUE
	var/atom/current_loc = user.loc
	var/list/locs_we_can_use = list()
	if (current_loc && !isturf(current_loc))
		locs_we_can_use += current_loc

		while (times_searched < EXME_MAX_LOC_RECURSION)
			times_searched++
			var/atom/recursive_loc = current_loc.loc

			if (!recursive_loc || isarea(recursive_loc)) // if youre in something already, its fair to say you might be in, say, a pipe. you cant use that for emoting, so the floor will have to do
				break

			locs_we_can_use += recursive_loc
			current_loc = recursive_loc

	else
		can_use = FALSE

	if (!can_use)
		to_chat(user, span_danger("Вы не находитесь ни в чем!")) // If user is banned from chat, emotes, or the user is not within anything (ex. a locker) return.
		return FALSE //im keeping this to_chat because this seems like a really common use case and i dont want to annoy players
	else if(!params) // User didn't put anything after *exme when using the say hotkey, or just used the emote raw? Open a window.
		container_emote = tgui_input_text(user, "Что бы вы хотели выразить в эмоциях?", "Эмоция контейнера" , null, MAX_MESSAGE_LEN, TRUE, TRUE, 0)
		if(!container_emote)
			return FALSE
		var/list/choices = list("Видимая","Слышимая")
		var/type = tgui_input_list(user, "Это видимая или слышимая эмоция?", "Эмоция контейнера", choices, FALSE)
		switch(type)
			if("Видимая")
				emote_type = EMOTE_VISIBLE
			if("Слышимая")
				emote_type = EMOTE_AUDIBLE
			else
				tgui_alert(user, "Невозможно использовать этот эмоут, он должен быть либо слышен, либо виден.")
				return
		container_message = container_emote //Ill be honest I dont know why this is a thing but I'm too afraid to remove it.
	else
		container_message = params // Same as above.
		if(type_override)
			emote_type = type_override
		else
			emote_type = EMOTE_VISIBLE
	. = TRUE

	if(!can_run_emote(user))
		return FALSE

	user.log_message(container_message, LOG_EMOTE)

	var/space = should_have_space_before_emote(html_decode(container_emote)[1]) ? " " : ""

	container_message = ("[user.apply_message_emphasis(container_message)]")

	var/atom/picked_loc
	if (!length(locs_we_can_use))
		return FALSE

	if (length(locs_we_can_use) == 1)
		picked_loc = pick(locs_we_can_use)
	else
		picked_loc = tgui_input_list(user, "Из какого контейнера вы хотели бы получить свою эмоцию?", "Эмоция контейнера", locs_we_can_use, FALSE)

	// Since the tgui input sleeps, we can no longer trust the status of any variable after this point
	// Ex. we cannot assume the user exists anymore
	if(!can_run_emote(user))
		return FALSE

	if ((!picked_loc) || (isarea(picked_loc)) || QDELETED(picked_loc) || user.IsUnconscious() || QDELETED(user)) //one last sanity check
		return FALSE

	if(emote_type == EMOTE_AUDIBLE)
		picked_loc.audible_message(message = container_message, self_message = container_message, audible_message_flags = EMOTE_MESSAGE, separation = space)

	else if (emote_type == EMOTE_VISIBLE)
		picked_loc.visible_message(message = container_message, self_message = container_message, visible_message_flags = EMOTE_MESSAGE, separation = space)

#undef EXME_MAX_LOC_RECURSION
