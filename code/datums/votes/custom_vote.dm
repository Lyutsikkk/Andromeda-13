/// The max amount of options someone can have in a custom vote.
#define MAX_CUSTOM_VOTE_OPTIONS 10

/datum/vote/custom_vote
	name = "Кастом"
	default_message = "Нажмите здесь, чтобы начать кастомный голосование."

// Custom votes ares always accessible.
/datum/vote/custom_vote/is_accessible_vote()
	return TRUE

/datum/vote/custom_vote/reset()
	default_choices = null
	override_question = null
	count_method = VOTE_COUNT_METHOD_SINGLE
	return ..()

/datum/vote/custom_vote/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .
	if(forced)
		return .

	// Custom votes can only be created if they're forced to be made.
	// (Either an admin makes it, or otherwise.)
	return "Только администраторы могут создавать пользовательские голоса."

/datum/vote/custom_vote/create_vote(mob/vote_creator)
	var/custom_count_method = tgui_input_list(
		user = vote_creator,
		message = "Одиночный, множественный или рейтинг выбор?", // BUBBER EDIT CHANGE - Ranked Choice Voting - Original: "Single or multiple choice?"
		title = "Метод выбора",
		items = list("Одиночный", "Множественный", "Рейтинг"), // BUBBER EDIT CHANGE - Ranked Choice Voting - Original: ("Single", "Multiple")
		default = "Одиночный",
	)
	switch(custom_count_method)
		if("Одиночный")
			count_method = VOTE_COUNT_METHOD_SINGLE
		if("Множественный")
			count_method = VOTE_COUNT_METHOD_MULTI
		// BUBBER EDIT ADDITION BEGIN - Ranked Choice Voting
		if("Рейтинг")
			count_method = VOTE_COUNT_METHOD_RANKED
			// Ask for the threshold if it's ranked voting
			var/threshold = tgui_input_number(
				user = vote_creator,
				message = "Установите процент порога победы (1-100)",
				title = "Порог ранжированного выбора",
				default = 50,
				min_value = 1,
				max_value = 100
			)
			if(isnull(threshold))
				return FALSE
			ranked_winner_threshold = threshold
		// BUBBER EDIT ADDITION END
		if(null)
			return FALSE
		else
			stack_trace("Получил '[custom_count_method]' в create_vote() для пользовательского голосования.")
			to_chat(vote_creator, span_boldwarning("Метод выбора неизвестен. Обратитесь к кодеру."))
			return FALSE

	var/custom_win_method = tgui_input_list(
		user = vote_creator,
		message = "Как следует определять победителя голосования?",
		title = "Метод выбора победителя",
		items = list("Простой", "Случайные голоса", "Без победителя", "Рейтинг"), // SPLURT EDIT ADDITION - Ranked Choice Voting
		default = "Простой",
	)
	switch(custom_win_method)
		if("Простой")
			winner_method = VOTE_WINNER_METHOD_SIMPLE
		if("Случайные голоса")
			winner_method = VOTE_WINNER_METHOD_WEIGHTED_RANDOM
		// BUBBER EDIT ADDITION BEGIN - Ranked Choice Voting
		if("Рейтинг")
			winner_method = VOTE_WINNER_METHOD_RANKED
		// BUBBER EDIT ADDITION END
		if("No Winner")
			winner_method = VOTE_WINNER_METHOD_NONE
		if(null)
			return FALSE
		else
			stack_trace("Получил '[custom_win_method]' в create_vote() для пользовательского голосования.")
			to_chat(vote_creator, span_boldwarning("Способ получения выигрыша неизвестен. Обратитесь к кодеру."))
			return FALSE

	var/display_stats = tgui_alert(
		vote_creator,
		"Должна ли статистика голосования быть общедоступной?",
		"Показывать статистику голосования?",
		list("Да", "Нет"),
	)

	if(isnull(display_stats))
		return FALSE
	display_statistics = display_stats == "Да"

	override_question = tgui_input_text(vote_creator, "За что мы голосуем?", "Кастомное голосование")
	if(!override_question)
		return FALSE

	default_choices = list()
	for(var/i in 1 to MAX_CUSTOM_VOTE_OPTIONS)
		var/option = tgui_input_text(vote_creator, "Пожалуйста, введите желаемый вариант или нажмите 'Отмена', чтобы завершить. [MAX_CUSTOM_VOTE_OPTIONS] макс.", "Опции", max_length = MAX_NAME_LEN)
		if(!vote_creator?.client)
			return FALSE
		if(!option)
			break

		default_choices += capitalize(option)

	if(!length(default_choices))
		return FALSE
	// Sanity for all the tgui input stalling we are doing
	if(isnull(vote_creator.client?.holder))
		return FALSE

	return ..()

/datum/vote/custom_vote/initiate_vote(initiator, duration)
	. = ..()
	. += "\n[override_question]"

#undef MAX_CUSTOM_VOTE_OPTIONS
