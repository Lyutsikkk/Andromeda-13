/datum/language_menu
	var/datum/language_holder/language_holder

/datum/language_menu/New(_language_holder)
	language_holder = _language_holder

/datum/language_menu/Destroy()
	language_holder = null
	. = ..()

/datum/language_menu/ui_state(mob/user)
	return GLOB.language_menu_state

/datum/language_menu/ui_interact(mob/user, datum/tgui/ui)
	if(isnull(language_holder.selected_language))
		language_holder.get_selected_language()

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LanguageMenu")
		ui.open()

/datum/language_menu/ui_data(mob/user)
	var/list/data = list()

	var/atom/movable/speaker = language_holder.owner
	var/list/partial_languages = speaker?.get_partially_understood_languages()
	data["languages"] = list()
	for(var/datum/language/language as anything in GLOB.all_languages)
		var/list/lang_data = list()

		lang_data["name"] = initial(language.name)
		lang_data["desc"] = initial(language.desc)
		lang_data["key"] = initial(language.key)
		lang_data["is_default"] = (language == language_holder.selected_language)
		lang_data["icon"] = initial(language.icon)
		lang_data["icon_state"] = initial(language.icon_state)
		if(speaker)
			lang_data["can_speak"] = !!speaker.has_language(language, SPOKEN_LANGUAGE)
			lang_data["could_speak"] = !!(language_holder.omnitongue || speaker.could_speak_language(language))
			lang_data["can_understand"] = !!speaker.has_language(language, UNDERSTOOD_LANGUAGE)
			lang_data["partial_understanding"] = partial_languages?[language] || 0

		UNTYPED_LIST_ADD(data["languages"], lang_data)

	data["is_living"] = isliving(speaker)
	data["admin_mode"] = check_rights_for(user.client, R_ADMIN) || isobserver(speaker)
	data["omnitongue"] = language_holder.omnitongue

	return data

/datum/language_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	var/atom/movable/speaker = language_holder.owner
	var/is_admin = check_rights_for(user.client, R_ADMIN)
	var/language_name = params["language_name"]
	var/datum/language/language_datum
	for(var/datum/language/language as anything in GLOB.all_languages)
		if(language_name == initial(language.name))
			language_datum = language

	switch(action)
		if("select_default")
			if(language_datum && speaker.can_speak_language(language_datum))
				language_holder.selected_language = language_datum
				. = TRUE
		if("grant_language")
			if((is_admin || isobserver(speaker)) && language_datum)
				var/list/choices = list("Только разговорный", "Только понимание", "Полное владение")
				var/choice = tgui_input_list(user, "Как вы хотите добавить этот язык?", "[language_datum]", choices)
				if(isnull(choice))
					return
				var/adding_flags = NONE
				switch(choice)
					if("Только разговорный")
						adding_flags |= SPOKEN_LANGUAGE
					if("Только понимание")
						adding_flags |= UNDERSTOOD_LANGUAGE
					if("Полное владение")
						adding_flags |= ALL

				if(LAZYACCESS(language_holder.blocked_languages, language_datum))
					choice = tgui_alert(user, "Хотите ли вы снять блокировку, которая мешает разговаривать или понимать язык?", "[language_datum]", list("Да", "Нет"))
					if(choice == "Нет")
						language_holder.remove_blocked_language(language_datum, LANGUAGE_ALL)
				language_holder.grant_language(language_datum, adding_flags)
				if(is_admin)
					message_admins("[key_name_admin(user)] даровал понимание язык [language_name] игроку [key_name_admin(speaker)].")
					log_admin("[key_name(user)] даровал понимание язык [language_name] игроку [key_name(speaker)].")
				. = TRUE
		if("remove_language")
			if((is_admin || isobserver(speaker)) && language_datum)
				var/list/choices = list("Только разговорный", "Только понимание", "Полное владение")
				var/choice = tgui_input_list(user, "Какую именно часть вы хотите удалить?", "[language_datum]", choices)
				if(isnull(choice))
					return
				var/removing_flags = NONE
				switch(choice)
					if("Только разговорный")
						removing_flags |= SPOKEN_LANGUAGE
					if("Только понимание")
						removing_flags |= UNDERSTOOD_LANGUAGE
					if("Полное владение")
						removing_flags |= ALL

				language_holder.remove_language(language_datum, removing_flags)
				if(is_admin)
					message_admins("[key_name_admin(user)] лишил понимание языка [language_name] у игрока [key_name_admin(speaker)].")
					log_admin("[key_name(user)] лишил понимание языка [language_name] у игрока [key_name(speaker)].")
				. = TRUE
		if("toggle_omnitongue")
			if(is_admin || isobserver(speaker))
				language_holder.omnitongue = !language_holder.omnitongue
				if(is_admin)
					message_admins("[key_name_admin(user)] [language_holder.omnitongue ? "включил" : "отключил"] способность (Полиглот) говорить на всех языках игрку [key_name_admin(speaker)].")
					log_admin("[key_name(user)] [language_holder.omnitongue ? "включил" : "отключил"] способность (Полиглот) говорить на всех языках игрку [key_name(speaker)].")
				. = TRUE
