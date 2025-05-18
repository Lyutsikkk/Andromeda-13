/datum/brain_trauma/hypnosis
	name = "Гипноз"
	desc = "Бессознательное пациента полностью захватывается словом или предложением, фокусируя на нем свои мысли и действия."
	scan_desc = "Зацикленный мыслительный паттерн"
	gain_text = ""
	lose_text = ""
	resilience = TRAUMA_RESILIENCE_SURGERY
	/// Associated antag datum, used for displaying objectives and antag hud
	var/datum/antagonist/hypnotized/antagonist
	var/hypnotic_phrase = ""
	var/regex/target_phrase

/datum/brain_trauma/hypnosis/New(phrase)
	if(!phrase)
		qdel(src)
		return
	hypnotic_phrase = phrase
	try
		target_phrase = new("(\\b[REGEX_QUOTE(hypnotic_phrase)]\\b)","ig")
	catch(var/exception/e)
		stack_trace("[e] on [e.file]:[e.line]")
		qdel(src)
	..()

/datum/brain_trauma/hypnosis/on_gain()
	message_admins("[ADMIN_LOOKUPFLW(owner)] был загипнотизирован фразой '[hypnotic_phrase]'.")
	owner.log_message("был загипнотизирован фразой '[hypnotic_phrase]'.", LOG_GAME)
	to_chat(owner, span_reallybig(span_hypnophrase("[hypnotic_phrase]")))
	to_chat(owner, span_notice("[pick(list(
			"Что-то в этом звучит... правильно, по какой-то причине. Вы чувствуете, что должны следовать этим словам.",
			"Эти слова продолжают звучать в вашем сознании. Вы находите себя совершенно очарованным ими.",
			"Вы чувствуете, что какая-то часть вашего сознания повторяет это снова и снова. Вы должны следовать этим словам.",
			"Вы чувствуете, что ваши мысли сосредоточены на этой фразе... кажется, вы не можете выбросить ее из головы.",
			"У вас болит голова, но это все, о чем вы можете думать. Это должно быть жизненно важно.",
	))]"))
	to_chat(owner, span_boldwarning("Вы загипнотизированы этим предложением. Вы должны следовать этим словам. \
		Если это не четкий приказ, вы можете свободно интерпретировать, как это сделать, если только вы ведете себя так, как будто слова являются вашим главным приоритетом."))
	var/atom/movable/screen/alert/hypnosis/hypno_alert = owner.throw_alert(ALERT_HYPNOSIS, /atom/movable/screen/alert/hypnosis)
	owner.mind.add_antag_datum(/datum/antagonist/hypnotized)
	antagonist = owner.mind.has_antag_datum(/datum/antagonist/hypnotized)
	antagonist.trauma = src

	// Add the phrase to objectives
	var/datum/objective/fixation = new ()
	fixation.explanation_text = hypnotic_phrase
	fixation.completed = TRUE
	antagonist.objectives = list(fixation)

	hypno_alert.desc = "\"[hypnotic_phrase]\"... ваш разум, кажется, зациклился на этой концепции."
	. = ..()

/datum/brain_trauma/hypnosis/on_lose()
	message_admins("[ADMIN_LOOKUPFLW(owner)] больше не загипнотизирован фразой '[hypnotic_phrase]'.")
	owner.log_message("больше не загипнотизирован фразой '[hypnotic_phrase]'.", LOG_GAME)
	to_chat(owner, span_userdanger("Вы внезапно выходите из состояния гипноза. Фраза '[hypnotic_phrase]' больше не кажется вам важной."))
	owner.clear_alert(ALERT_HYPNOSIS)
	..()
	if (!isnull(antagonist))
		antagonist.trauma = null
	owner.mind.remove_antag_datum(/datum/antagonist/hypnotized)
	antagonist = null

/datum/brain_trauma/hypnosis/on_life(seconds_per_tick, times_fired)
	..()
	if(SPT_PROB(1, seconds_per_tick))
		if(prob(50))
			to_chat(owner, span_hypnophrase("<i>...[LOWER_TEXT(hypnotic_phrase)]...</i>"))
		else
			owner.cause_hallucination( \
				/datum/hallucination/chat, \
				"hypnosis", \
				force_radio = TRUE, \
				specific_message = span_hypnophrase("[hypnotic_phrase]"), \
			)

/datum/brain_trauma/hypnosis/handle_hearing(datum/source, list/hearing_args)
	if(!owner.can_hear() || owner == hearing_args[HEARING_SPEAKER])
		return
	hearing_args[HEARING_RAW_MESSAGE] = target_phrase.Replace(hearing_args[HEARING_RAW_MESSAGE], span_hypnophrase("$1"))
