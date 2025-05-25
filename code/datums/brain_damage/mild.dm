//Mild traumas are the most common; they are generally minor annoyances.
//They can be cured with mannitol and patience, although brain surgery still works.
//Most of the old brain damage effects have been transferred to the dumbness trauma.

/datum/brain_trauma/mild
	abstract_type = /datum/brain_trauma/mild

/datum/brain_trauma/mild/hallucinations
	name = "Галлюцинации"
	desc = "Пациент страдает от постоянных галлюцинаций."
	scan_desc = "шизофрения"
	gain_text = span_warning("Вы чувствуете, что ваша хватка за реальность ослабевает...")
	lose_text = span_notice("Вы чувствуете себя более уравновешенным.")
	/// Whether the hallucinations we give are uncapped, ie all the wacky ones
	var/uncapped = FALSE

/datum/brain_trauma/mild/hallucinations/on_life(seconds_per_tick, times_fired)
	if(owner.stat >= UNCONSCIOUS)
		return
	if(HAS_TRAIT(owner, TRAIT_RDS_SUPPRESSED))
		owner.remove_language(/datum/language/aphasia, source = LANGUAGE_APHASIA)
		owner.adjust_hallucinations(-10 SECONDS * seconds_per_tick)
		return

	owner.grant_language(/datum/language/aphasia, source = LANGUAGE_APHASIA)
	owner.adjust_hallucinations_up_to(((uncapped ? 12 SECONDS : 5 SECONDS) * seconds_per_tick), (uncapped ? 240 SECONDS : 60 SECONDS))

/datum/brain_trauma/mild/hallucinations/on_lose()
	owner.remove_status_effect(/datum/status_effect/hallucination)
	if(!QDELING(owner))
		owner.remove_language(/datum/language/aphasia, source = LANGUAGE_APHASIA)
	return ..()

/datum/brain_trauma/mild/stuttering
	name = "Заикание"
	desc = "Пациент не может правильно говорить."
	scan_desc = "снижение координации рта"
	gain_text = span_warning("Говорить четко становится труднее.")
	lose_text = span_notice("Вы чувствуете, что контролируете свою речь.")

/datum/brain_trauma/mild/stuttering/on_life(seconds_per_tick, times_fired)
	owner.adjust_stutter_up_to(5 SECONDS * seconds_per_tick, 50 SECONDS)

/datum/brain_trauma/mild/stuttering/on_lose()
	owner.remove_status_effect(/datum/status_effect/speech/stutter)
	return ..()

/datum/brain_trauma/mild/dumbness
	name = "Тупость"
	desc = "У пациента снижена активность мозга, что делает его менее сообразительным."
	scan_desc = "снижение мозговой активности"
	gain_text = span_warning("Вы чувствуете себя тупее.")
	lose_text = span_notice("Вы снова чувствуете себя умным.")

/datum/brain_trauma/mild/dumbness/on_gain()
	ADD_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	owner.add_mood_event("dumb", /datum/mood_event/oblivious)
	return ..()

/datum/brain_trauma/mild/dumbness/on_life(seconds_per_tick, times_fired)
	owner.adjust_derpspeech_up_to(5 SECONDS * seconds_per_tick, 50 SECONDS)
	if(SPT_PROB(1.5, seconds_per_tick))
		owner.emote("drool")
	else if(owner.stat == CONSCIOUS && SPT_PROB(1.5, seconds_per_tick))
		owner.say(pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage"), forced = "brain damage", filterproof = TRUE)

/datum/brain_trauma/mild/dumbness/on_lose()
	REMOVE_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	owner.remove_status_effect(/datum/status_effect/speech/stutter/derpspeech)
	owner.clear_mood_event("dumb")
	return ..()

/datum/brain_trauma/mild/speech_impediment
	name = "Затруднение речи"
	desc = "Пациент не может строить связные предложения."
	scan_desc = "communication disorder"
	gain_text = span_danger("Вы не можете сформировать ни одной связной мысли!")
	lose_text = span_danger("Ваш разум становится более ясным.")

/datum/brain_trauma/mild/speech_impediment/on_gain()
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	. = ..()

/datum/brain_trauma/mild/speech_impediment/on_lose()
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/concussion
	name = "Сотрясение мозга"
	desc = "У пациента сотрясение мозга."
	scan_desc = "сотрясение мозга"
	gain_text = span_warning("Ваша голова болит!")
	lose_text = span_notice("Давление внутри вашей головы начинает ослабевать.")

/datum/brain_trauma/mild/concussion/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(2.5, seconds_per_tick))
		switch(rand(1,11))
			if(1)
				owner.vomit(VOMIT_CATEGORY_DEFAULT)
			if(2,3)
				owner.adjust_dizzy(20 SECONDS)
			if(4,5)
				owner.adjust_confusion(10 SECONDS)
				owner.set_eye_blur_if_lower(20 SECONDS)
			if(6 to 9)
				owner.adjust_slurring(1 MINUTES)
			if(10)
				to_chat(owner, span_notice("Вы на мгновение забываете, чем занимались."))
				owner.Stun(20)
			if(11)
				to_chat(owner, span_warning("Вы падаете в обморок."))
				owner.Unconscious(80)

	..()

/datum/brain_trauma/mild/healthy
	name = "Анозогнозия"
	desc = "Пациент всегда чувствует себя здоровым, независимо от его состояния."
	scan_desc = "дефицит самосознания"
	gain_text = span_notice("Вы чувствуете себя превосходно!")
	lose_text = span_warning("Вы больше не чувствуете себя абсолютно здоровым.")

/datum/brain_trauma/mild/healthy/on_gain()
	owner.apply_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)
	return ..()

/datum/brain_trauma/mild/healthy/on_life(seconds_per_tick, times_fired)
	owner.adjustStaminaLoss(-6 * seconds_per_tick) //no pain, no fatigue

/datum/brain_trauma/mild/healthy/on_lose()
	owner.remove_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)
	return ..()

/datum/brain_trauma/mild/muscle_weakness
	name = "Мышечная слабость"
	desc = "Пациент периодически испытывает приступы мышечной слабости."
	scan_desc = "слабый сигнал двигательного нерва"
	gain_text = span_warning("Ваши мышцы странно затекли.")
	lose_text = span_notice("Вы снова чувствуете контроль над своими мышцами.")

/datum/brain_trauma/mild/muscle_weakness/on_life(seconds_per_tick, times_fired)
	var/fall_chance = 1
	if(owner.move_intent == MOVE_INTENT_RUN)
		fall_chance += 2
	if(SPT_PROB(0.5 * fall_chance, seconds_per_tick) && owner.body_position == STANDING_UP)
		to_chat(owner, span_warning("У вас отказала нога!"))
		owner.Paralyze(35)

	else if(owner.get_active_held_item())
		var/drop_chance = 1
		var/obj/item/I = owner.get_active_held_item()
		drop_chance += I.w_class
		if(SPT_PROB(0.5 * drop_chance, seconds_per_tick) && owner.dropItemToGround(I))
			to_chat(owner, span_warning("Вы бросаете [I]!"))

	else if(SPT_PROB(1.5, seconds_per_tick))
		to_chat(owner, span_warning("Вы чувствуете внезапную слабость в мышцах!"))
		owner.adjustStaminaLoss(50)
	..()

/datum/brain_trauma/mild/muscle_spasms
	name = "Мышечные спазмы"
	desc = "Пациент периодически испытывает мышечные спазмы, что приводит к непроизвольным движениям."
	scan_desc = "нервные спазмы"
	gain_text = span_warning("Ваши мышцы странно затекли.")
	lose_text = span_notice("Вы снова чувствуете контроль над своими мышцами.")

/datum/brain_trauma/mild/muscle_spasms/on_gain()
	owner.apply_status_effect(/datum/status_effect/spasms)
	. = ..()

/datum/brain_trauma/mild/muscle_spasms/on_lose()
	owner.remove_status_effect(/datum/status_effect/spasms)
	..()

/datum/brain_trauma/mild/nervous_cough
	name = "Нервный кашель"
	desc = "Пациент испытывает постоянную потребность откашляться."
	scan_desc = "нервный кашель"
	gain_text = span_warning("У вас непрерывно чешется горло...")
	lose_text = span_notice("Ваше горло перестанет чесаться.")

/datum/brain_trauma/mild/nervous_cough/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(6, seconds_per_tick) && !HAS_TRAIT(owner, TRAIT_SOOTHED_THROAT))
		if(prob(5))
			to_chat(owner, span_warning("[pick("У вас приступ кашля!", "Вы не можете перестать кашлять!")]"))
			owner.Immobilize(20)
			owner.emote("cough")
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/, emote), "cough"), 0.6 SECONDS)
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/, emote), "cough"), 1.2 SECONDS)
		owner.emote("cough")
	..()

/datum/brain_trauma/mild/expressive_aphasia
	name = "Экспрессивная афазия"
	desc = "Пациент страдает частичной потерей речи, что приводит к сокращению словарного запаса."
	scan_desc = "неспособность формировать сложные предложения"
	gain_text = span_warning("Вы перестаете понимать сложные слова.")
	lose_text = span_notice("Вы чувствуете, как ваш словарный запас снова приходит в норму.")

/datum/brain_trauma/mild/expressive_aphasia/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		var/list/message_split = splittext(message, " ")
		var/list/new_message = list()

		for(var/word in message_split)
			var/suffix = ""
			var/suffix_foundon = 0
			for(var/potential_suffix in list("." , "," , ";" , "!" , ":" , "?"))
				suffix_foundon = findtext(word, potential_suffix, -length(potential_suffix))
				if(suffix_foundon)
					suffix = potential_suffix
					break

			if(suffix_foundon)
				word = copytext(word, 1, suffix_foundon)
			word = html_decode(word)

			if(GLOB.most_common_words[LOWER_TEXT(word)])
				new_message += word + suffix
			else
				if(prob(30) && message_split.len > 2)
					new_message += pick("эм","эээх")
					break
				else
					var/list/charlist = text2charlist(word)
					charlist.len = round(charlist.len * 0.5, 1)
					shuffle_inplace(charlist)
					new_message += jointext(charlist, "") + suffix

		message = jointext(new_message, " ")

	speech_args[SPEECH_MESSAGE] = trim(message)

/datum/brain_trauma/mild/mind_echo
	name = "Эхо разума"
	desc = "Языковые нейроны пациента не завершаются должным образом, в результате чего прежние речевые паттерны иногда спонтанно всплывают."
	scan_desc = "циклический нейронный паттерн"
	gain_text = span_warning("Вы чувствуете слабое эхо своих мыслей...")
	lose_text = span_notice("Слабое эхо исчезает.")
	var/list/hear_dejavu = list()
	var/list/speak_dejavu = list()

/datum/brain_trauma/mild/mind_echo/handle_hearing(datum/source, list/hearing_args)
	if(!owner.can_hear() || owner == hearing_args[HEARING_SPEAKER])
		return

	if(hear_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(hear_dejavu)
			var/static/regex/quoted_spoken_message = regex("\".+\"", "gi")
			hearing_args[HEARING_RAW_MESSAGE] = quoted_spoken_message.Replace(hearing_args[HEARING_RAW_MESSAGE], "\"[deja_vu]\"") //Quotes included to avoid cases where someone says part of their name
			return
	if(hear_dejavu.len >= 15)
		if(prob(50))
			popleft(hear_dejavu) //Remove the oldest
			hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]
	else
		hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]

/datum/brain_trauma/mild/mind_echo/handle_speech(datum/source, list/speech_args)
	if(speak_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(speak_dejavu)
			speech_args[SPEECH_MESSAGE] = deja_vu
			return
	if(speak_dejavu.len >= 15)
		if(prob(50))
			popleft(speak_dejavu) //Remove the oldest
			speak_dejavu += speech_args[SPEECH_MESSAGE]
	else
		speak_dejavu += speech_args[SPEECH_MESSAGE]

/datum/brain_trauma/mild/color_blindness
	name = "Ахроматопсия"
	desc = "Затылочная доля пациента не способна распознавать и интерпретировать цвета, в результате чего пациент полностью лишается зрения."
	scan_desc = "дальтонизм"
	gain_text = span_warning("Кажется, что мир вокруг вас теряет свои краски.")
	lose_text = span_notice("Мир снова кажется ярким и красочным.")

/datum/brain_trauma/mild/color_blindness/on_gain()
	owner.add_client_colour(/datum/client_colour/monochrome, TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/mild/color_blindness/on_lose(silent)
	owner.remove_client_colour(TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/mild/possessive
	name = "Собственник"
	desc = "Пациент чрезвычайно бережно относится к своим вещам."
	scan_desc = "собственничество"
	gain_text = span_warning("Вы начинаете беспокоиться о своих вещах.")
	lose_text = span_notice("Вы меньше беспокоитесь о своих вещах.")

/datum/brain_trauma/mild/possessive/on_lose(silent)
	. = ..()
	for(var/obj/item/thing in owner.held_items)
		clear_trait(thing)

/datum/brain_trauma/mild/possessive/on_life(seconds_per_tick, times_fired)
	if(!SPT_PROB(5, seconds_per_tick))
		return

	var/obj/item/my_thing = pick(owner.held_items) // can pick null, that's fine
	if(isnull(my_thing) || HAS_TRAIT(my_thing, TRAIT_NODROP) || (my_thing.item_flags & (HAND_ITEM|ABSTRACT)))
		return

	ADD_TRAIT(my_thing, TRAIT_NODROP, TRAUMA_TRAIT)
	RegisterSignals(my_thing, list(COMSIG_ITEM_DROPPED, COMSIG_MOVABLE_MOVED), PROC_REF(clear_trait))
	to_chat(owner, span_warning("Вы чувствуете потребность держать [my_thing] у себя..."))
	addtimer(CALLBACK(src, PROC_REF(relax), my_thing), rand(30 SECONDS, 3 MINUTES), TIMER_DELETE_ME)

/datum/brain_trauma/mild/possessive/proc/relax(obj/item/my_thing)
	if(QDELETED(my_thing))
		return
	if(HAS_TRAIT_FROM_ONLY(my_thing, TRAIT_NODROP, TRAUMA_TRAIT)) // in case something else adds nodrop, somehow?
		to_chat(owner, span_notice("Вы чувствуете себя более комфортно, отпуская [my_thing]."))
	clear_trait(my_thing)

/datum/brain_trauma/mild/possessive/proc/clear_trait(obj/item/my_thing, ...)
	SIGNAL_HANDLER

	REMOVE_TRAIT(my_thing, TRAIT_NODROP, TRAUMA_TRAIT)
	UnregisterSignal(my_thing, list(COMSIG_ITEM_DROPPED, COMSIG_MOVABLE_MOVED))
