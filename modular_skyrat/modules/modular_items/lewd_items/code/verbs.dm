/mob/living/carbon/human/verb/climax_verb()
	set name = "(ЕРП)Кульминация"
	set category = "IC"

	if(!has_status_effect(/datum/status_effect/climax_cooldown))
		if(tgui_alert(usr, "Ты уверена, что хочешь кончить?", "Кульминация", list("Да", "Нет")) == "Да")
			if(stat != CONSCIOUS)
				to_chat(usr, span_warning("Ты не можешь достичь кульминации прямо сейчас..."))
				return
			else
				climax(TRUE)
	else
		to_chat(src, span_warning("Ты не можешь кончить прямо сейчас!"))

/mob/living/verb/reflexes_verb()
	set name = "(ЕРП)Переключить рефлексы"
	set category = "IC"
	if(!HAS_TRAIT_FROM(src, TRAIT_QUICKREFLEXES, REF(src)))
		ADD_TRAIT(src, TRAIT_QUICKREFLEXES, REF(src))
		to_chat(src, span_notice("[get_reflexes_gain_text()]"))
	else
		REMOVE_TRAIT(src, TRAIT_QUICKREFLEXES, REF(src))
		to_chat(src, span_notice("[get_reflexes_lose_text()]"))

/mob/living/proc/get_reflexes_gain_text()
	return "Сейчас вам не хочется, чтобы к вам прикасались."

/mob/living/proc/get_reflexes_lose_text()
	return "Теперь вы позволите к себе прикоснуться."

/mob/living/silicon/get_reflexes_gain_text()
	return "Наши системы не допускают платонических контактов."

/mob/living/silicon/get_reflexes_lose_text()
	return "Наши системы допускают платонические контакты."

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	if(CONFIG_GET(flag/disable_erp_preferences))
		verbs -= /mob/living/carbon/human/verb/climax_verb
	if(CONFIG_GET(flag/disable_lewd_items))
		verbs -= /mob/living/carbon/human/verb/safeword

/mob/living/carbon/human/verb/remove_lewd_items()
	set name = "Удалить непристойные слова"
	set category = "OOC"
	set desc = "Удаляет с вас все непристойные слова."
	// literally just another way to safeword
	safeword()

/mob/living/carbon/human/verb/safeword()
	set name = "Безопасные слова OOC"
	set category = "OOC"
	set desc = "Удаляет с вас все непристойные слова."
	SEND_SIGNAL(src, COMSIG_OOC_ESCAPE)
	log_message("[key_name(src)] использовал Безопасные слова OOC.", LOG_ATTACK)
	for(var/obj/item/equipped_item in get_equipped_items())
		if(!(equipped_item.type in GLOB.pref_checked_clothes))
			continue

		log_message("[equipped_item] удалён из [key_name(src)].", LOG_ATTACK)
		dropItemToGround(equipped_item, TRUE)

	// Leashes are treated a smidge different than the rest of the clothing; and need their own handling here.
	var/leash_check = src?.GetComponent(/datum/component/leash/erp)
	if(leash_check)
		qdel(leash_check)

	// Vore Edit
	if(istype(loc, /obj/vore_belly))
		forceMove(get_turf(src))

	return TRUE

/mob/living/carbon/human/verb/lick(mob/living/carbon/human/target in get_adjacent_humans())
	set name = "(ЕРП)Лизать"
	set category = "IC"

	if(!istype(target))
		return FALSE

	var/taste = target?.dna?.features["taste"]
	if(!taste)
		to_chat(src, span_warning("Похоже, у [target] нет вкуса."))
		return FALSE

	to_chat(src, span_notice("[target] на вкус [taste]."))
	to_chat(target, span_notice("[src] облизывает тебя."))

/mob/living/carbon/human/verb/smell(mob/living/carbon/human/target in get_adjacent_humans())
	set name = "(ЕРП)Понюхать"
	set category = "IC"

	if(!istype(target))
		return FALSE

	var/smell = target?.dna?.features["smell"]
	if(!smell)
		to_chat(src, span_warning("Похоже, у [target] нет запаха."))
		return FALSE

	to_chat(src, span_notice("[target] пахнет как [smell]."))

/// Returns a list containing all of the humans adjacent to the user.
/mob/living/proc/get_adjacent_humans()
	var/list/nearby_humans = orange(1, src)
	for(var/mob/living/carbon/human/nearby_human as anything in nearby_humans)
		if(ishuman(nearby_human))
			continue

		nearby_humans -= nearby_human

	return nearby_humans

