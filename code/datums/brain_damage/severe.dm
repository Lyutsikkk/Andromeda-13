//Severe traumas, when your brain gets abused way too much.
//These range from very annoying to completely debilitating.
//They cannot be cured with chemicals, and require brain surgery to solve.

/datum/brain_trauma/severe
	abstract_type = /datum/brain_trauma/severe
	resilience = TRAUMA_RESILIENCE_SURGERY

/datum/brain_trauma/severe/mute
	name = "Мутизм"
	desc = "Пациент полностью лишен способности говорить."
	scan_desc = "обширное повреждение речевого центра мозга"
	gain_text = span_warning("Вы забыли как говорить!")
	lose_text = span_notice("Вы вдруг вспомнили, как говорить.")

/datum/brain_trauma/severe/mute/on_gain()
	ADD_TRAIT(owner, TRAIT_MUTE, TRAUMA_TRAIT)
	. = ..()

/datum/brain_trauma/severe/mute/on_lose()
	REMOVE_TRAIT(owner, TRAIT_MUTE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/aphasia
	name = "Афазия"
	desc = "Пациент не может говорить или понимать какой-либо язык."
	scan_desc = "обширное повреждение языкового центра мозга"
	gain_text = span_warning("У вас есть проблемы с формированием слов в голове...")
	lose_text = span_notice("Вы вдруг вспомнили, как работают языки.")

/datum/brain_trauma/severe/aphasia/on_gain()
	owner.add_blocked_language(subtypesof(/datum/language) - /datum/language/aphasia, LANGUAGE_APHASIA)
	owner.grant_language(/datum/language/aphasia, source = LANGUAGE_APHASIA)
	. = ..()

/datum/brain_trauma/severe/aphasia/on_lose()
	if(!QDELING(owner))
		owner.remove_blocked_language(subtypesof(/datum/language), LANGUAGE_APHASIA)
		owner.remove_language(/datum/language/aphasia, source = LANGUAGE_APHASIA)

	..()

/datum/brain_trauma/severe/blindness
	name = "Церебральная слепота"
	desc = "Мозг пациента больше не связан с его глазами."
	scan_desc = "обширное повреждение затылочной доли мозга"
	gain_text = span_warning("Вы не видите!")
	lose_text = span_notice("Ваше зрение возвращается.")

/datum/brain_trauma/severe/blindness/on_gain()
	owner.become_blind(TRAUMA_TRAIT)
	. = ..()

/datum/brain_trauma/severe/blindness/on_lose()
	owner.cure_blind(TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/paralysis
	name = "Паралич"
	desc = "Мозг пациента больше не может контролировать часть его двигательных функций."
	scan_desc = "церебральный паралич"
	gain_text = ""
	lose_text = ""
	var/paralysis_type
	var/list/paralysis_traits = list()
	//for descriptions

/datum/brain_trauma/severe/paralysis/New(specific_type)
	if(specific_type)
		paralysis_type = specific_type
	if(!paralysis_type)
		paralysis_type = pick("full","left","right","arms","legs","r_arm","l_arm","r_leg","l_leg")
	var/subject
	switch(paralysis_type)
		if("full")
			subject = "Ваше тело"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG)
		if("left")
			subject = "Ваша левая сторона тела"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_L_LEG)
		if("right")
			subject = "Ваша правая сторона тела"
			paralysis_traits = list(TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_R_LEG)
		if("arms")
			subject = "Ваши руки"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM)
		if("legs")
			subject = "Ваши ноги"
			paralysis_traits = list(TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG)
		if("r_arm")
			subject = "Ваша правая рука"
			paralysis_traits = list(TRAIT_PARALYSIS_R_ARM)
		if("l_arm")
			subject = "Ваша левая рука"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM)
		if("r_leg")
			subject = "Ваша правая нога"
			paralysis_traits = list(TRAIT_PARALYSIS_R_LEG)
		if("l_leg")
			subject = "Ваша левая нога"
			paralysis_traits = list(TRAIT_PARALYSIS_L_LEG)

	gain_text = span_warning("[subject] немеет и более не потдаётся управлению!")
	lose_text = span_notice("[subject] сново ощущается и управляется вами!")

/datum/brain_trauma/severe/paralysis/on_gain()
	. = ..()
	for(var/X in paralysis_traits)
		ADD_TRAIT(owner, X, TRAUMA_TRAIT)


/datum/brain_trauma/severe/paralysis/on_lose()
	..()
	for(var/X in paralysis_traits)
		REMOVE_TRAIT(owner, X, TRAUMA_TRAIT)


/datum/brain_trauma/severe/paralysis/paraplegic
	random_gain = FALSE
	paralysis_type = "legs"
	resilience = TRAUMA_RESILIENCE_ABSOLUTE

/datum/brain_trauma/severe/paralysis/hemiplegic
	random_gain = FALSE
	resilience = TRAUMA_RESILIENCE_ABSOLUTE

/datum/brain_trauma/severe/paralysis/hemiplegic/left
	paralysis_type = "left"

/datum/brain_trauma/severe/paralysis/hemiplegic/right
	paralysis_type = "right"

/datum/brain_trauma/severe/narcolepsy
	name = "Нарколепсия"
	desc = "Пациент может непроизвольно засыпать во время обычной деятельности."
	scan_desc = "травматическая нарколепсия"
	gain_text = span_warning("У вас постоянное чувство сонливости...")
	lose_text = span_notice("Вы снова чувствуете себя бодрым и осознанным.")
	/// Odds seconds_per_tick the user falls asleep
	var/sleep_chance = 1
	/// Odds seconds_per_tick the user falls asleep while running
	var/sleep_chance_running = 2
	/// Odds seconds_per_tick the user falls asleep while drowsy
	var/sleep_chance_drowsy = 3
	/// Time values for how long the user will stay drowsy
	var/drowsy_time_minimum = 20 SECONDS
	var/drowsy_time_maximum = 30 SECONDS
	/// Time values for how long the user will stay asleep
	var/sleep_time_minimum = 6 SECONDS
	var/sleep_time_maximum = 6 SECONDS

/datum/brain_trauma/severe/narcolepsy/on_life(seconds_per_tick, times_fired)
	if(owner.IsSleeping())
		return

	/// If any of these are in the user's blood, return early
	var/static/list/immunity_medicine = list(
		/datum/reagent/medicine/modafinil,
		/datum/reagent/medicine/synaptizine,
	) //don't add too many, as most stimulant reagents already have a drowsy-removing effect
	for(var/medicine in immunity_medicine)
		if(owner.reagents.has_reagent(medicine))
			return

	var/drowsy = !!owner.has_status_effect(/datum/status_effect/drowsiness)
	var/caffeinated = HAS_TRAIT(owner, TRAIT_STIMULATED)
	if(owner.move_intent == MOVE_INTENT_RUN)
		sleep_chance += sleep_chance_running
	if(drowsy)
		sleep_chance += sleep_chance_drowsy //stack drowsy ontop of base or running odds with the += operator
	if(caffeinated)
		sleep_chance = sleep_chance / 2 //make it harder to fall asleep on caffeine

	if (!SPT_PROB(sleep_chance, seconds_per_tick))
		return

	//if not drowsy, don't fall asleep but make them drowsy
	if(!drowsy)
		to_chat(owner, span_warning("Вы чувствуете усталость..."))
		owner.adjust_drowsiness(rand(drowsy_time_minimum, drowsy_time_maximum))
		if(prob(50))
			owner.emote("yawn")
		else if(prob(33)) //rarest message is a custom emote
			owner.visible_message("потирает [owner.p_their()] глаза.", visible_message_flags = EMOTE_MESSAGE)
	//drowsy, so fall asleep. you've had your chance to remedy it
	else
		to_chat(owner, span_warning("Вы засыпаете."))
		owner.Sleeping(rand(sleep_time_minimum, sleep_time_maximum))
		if(prob(50) && owner.IsSleeping())
			owner.emote("snore")

/datum/brain_trauma/severe/narcolepsy/permanent
	scan_desc = "chronic narcolepsy" //less odds to fall asleep than parent, but sleeps for longer
	sleep_chance = 0.333
	sleep_chance_running = 0.333
	sleep_chance_drowsy = 1
	sleep_time_minimum = 20 SECONDS
	sleep_time_maximum = 30 SECONDS

/datum/brain_trauma/severe/monophobia
	name = "Монофобия"
	desc = "Пациент чувствует себя больным и подавленным, когда не находится рядом с другими людьми, что приводит к потенциально смертельному уровню стресса."
	scan_desc = "монофобия"
	gain_text = span_warning("Вы чувствуете себя очень одиноко...")
	lose_text = span_notice("Вы чувствуете, что можете быть в безопасности, если одни.")
	var/stress = 0

/datum/brain_trauma/severe/monophobia/on_gain()
	. = ..()
	owner.AddComponentFrom(REF(src), /datum/component/fearful, list(/datum/terror_handler/vomiting, /datum/terror_handler/simple_source/monophobia))

/datum/brain_trauma/severe/monophobia/on_lose(silent)
	. = ..()
	owner.RemoveComponentSource(REF(src), /datum/component/fearful)

/datum/brain_trauma/severe/discoordination
	name = "Дискоординация"
	desc = "Пациент не может пользоваться сложными инструментами или механизмами."
	scan_desc = "экстремальная дискоординация"
	gain_text = span_warning("Вы едва можете контролировать свои руки!")
	lose_text = span_notice("Вы снова чувствуете контроль над своими руками.")

/datum/brain_trauma/severe/discoordination/on_gain()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/discoordinated)

/datum/brain_trauma/severe/discoordination/on_lose()
	owner.remove_status_effect(/datum/status_effect/discoordinated)
	return ..()

/datum/brain_trauma/severe/pacifism
	name = "Пацифизм"
	desc = "Пациент крайне не желает причинять вред окружающим насильственными методами."
	scan_desc = "синдром пацифизма"
	gain_text = span_notice("Вы чувствуете странное умиротворение.")
	lose_text = span_notice("Вы больше не чувствуете себя обязанным не причинять вреда.")

/datum/brain_trauma/severe/pacifism/on_gain()
	ADD_TRAIT(owner, TRAIT_PACIFISM, TRAUMA_TRAIT)
	. = ..()

/datum/brain_trauma/severe/pacifism/on_lose()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/hypnotic_stupor
	name = "Гипнотический ступор"
	desc = "Пациент склонен к приступам крайнего оцепенения, что делает его чрезвычайно внушаемым."
	scan_desc = "онейрическая петля обратной связи"
	gain_text = span_warning("Вы чувствуете легкое оцепенение.")
	lose_text = span_notice("Вы чувствуете, что с вашего разума словно сошел туман.")

/datum/brain_trauma/severe/hypnotic_stupor/on_lose() //hypnosis must be cleared separately, but brain surgery should get rid of both anyway
	..()
	owner.remove_status_effect(/datum/status_effect/trance)

/datum/brain_trauma/severe/hypnotic_stupor/on_life(seconds_per_tick, times_fired)
	..()
	if(SPT_PROB(0.5, seconds_per_tick) && !owner.has_status_effect(/datum/status_effect/trance))
		owner.apply_status_effect(/datum/status_effect/trance, rand(100,300), FALSE)

/datum/brain_trauma/severe/hypnotic_trigger
	name = "Гипнотический триггер"
	desc = "В подсознании пациента заложена пусковая фраза, которая вызывает внушаемое трансовое состояние."
	scan_desc = "онейрическая петля обратной связи"
	gain_text = span_warning("Вы чувствуете себя странно, как будто забыли что-то важное.")
	lose_text = span_notice("Вы чувствуете, что с вас словно сняли груз.")
	random_gain = FALSE
	var/trigger_phrase = "Нанотрейзен"

/datum/brain_trauma/severe/hypnotic_trigger/New(phrase)
	..()
	if(phrase)
		trigger_phrase = phrase

/datum/brain_trauma/severe/hypnotic_trigger/on_lose() //hypnosis must be cleared separately, but brain surgery should get rid of both anyway
	..()
	owner.remove_status_effect(/datum/status_effect/trance)

/datum/brain_trauma/severe/hypnotic_trigger/handle_hearing(datum/source, list/hearing_args)
	if(!owner.can_hear() || owner == hearing_args[HEARING_SPEAKER])
		return

	var/regex/reg = new("(\\b[REGEX_QUOTE(trigger_phrase)]\\b)","ig")

	if(findtext(hearing_args[HEARING_RAW_MESSAGE], reg))
		addtimer(CALLBACK(src, PROC_REF(hypnotrigger)), 1 SECONDS) //to react AFTER the chat message
		hearing_args[HEARING_RAW_MESSAGE] = reg.Replace(hearing_args[HEARING_RAW_MESSAGE], span_hypnophrase("*********"))

/datum/brain_trauma/severe/hypnotic_trigger/proc/hypnotrigger()
	to_chat(owner, span_warning("Слова вызывают что-то глубоко внутри вас, и вы чувствуете, как ваше сознание ускользает..."))
	owner.apply_status_effect(/datum/status_effect/trance, rand(100,300), FALSE)

/datum/brain_trauma/severe/dyslexia
	name = "Дислексия"
	desc = "Пациент не умеет читать и писать."
	scan_desc = "дислексия"
	gain_text = span_warning("У вас проблемы с чтением или письмом...")
	lose_text = span_notice("Вы вдруг вспомнили, как читать и писать.")

/datum/brain_trauma/severe/dyslexia/on_gain()
	ADD_TRAIT(owner, TRAIT_ILLITERATE, TRAUMA_TRAIT)
	. = ..()

/datum/brain_trauma/severe/dyslexia/on_lose()
	REMOVE_TRAIT(owner, TRAIT_ILLITERATE, TRAUMA_TRAIT)
	..()

/*
 * Brain traumas that eldritch paintings apply
 * This one is for "The Sister and He Who Wept" or /obj/structure/sign/painting/eldritch
 */
/datum/brain_trauma/severe/weeping
	name = "Психотическая депрессия"
	desc = "Пациент страдает от тяжелых депрессивных эпизодов. Во время этих эпизодов у пациента иногда возникают галлюцинации."
	scan_desc = "депрессия"
	gain_text = span_warning("Плач... Это преследует мой разум...")
	lose_text = span_notice("Ваша зацикленность заканчивается. Вы чувствуете себя значительно менее напряженно.")
	random_gain = FALSE
	/// Our cooldown declare for causing hallucinations
	COOLDOWN_DECLARE(weeping_hallucinations)

/datum/brain_trauma/severe/weeping/on_life(seconds_per_tick, times_fired)
	if(owner.stat != CONSCIOUS || owner.IsSleeping() || owner.IsUnconscious())
		return
	// If they have examined a painting recently
	if(HAS_TRAIT(owner, TRAIT_ELDRITCH_PAINTING_EXAMINE))
		return
	if(!COOLDOWN_FINISHED(src, weeping_hallucinations))
		return
	owner.cause_hallucination(/datum/hallucination/delusion/preset/heretic, "Вызвано травмой мозга «Плачущего».")
	owner.add_mood_event("eldritch_weeping", /datum/mood_event/eldritch_painting/weeping)
	COOLDOWN_START(src, weeping_hallucinations, 10 SECONDS)
	return ..()

//This one is for "The First Desire" or /obj/structure/sign/painting/eldritch/desire
/datum/brain_trauma/severe/flesh_desire
	name = "Расстройство Бина"
	desc = "Пациент зациклен на потреблении сырой плоти, особенно плоти одного вида. Пациент также страдает от психосоматических приступов голода."
	scan_desc = "умеренное расстройство пищевого поведения"
	gain_text = span_warning("Вы чувствуете голод, жажду органов и сырого мяса...")
	lose_text = span_notice("Ваш аппетит приходит в норму.")
	random_gain = FALSE
	/// How much faster we loose hunger
	var/hunger_rate = 15

/datum/brain_trauma/severe/flesh_desire/on_gain()
	// Allows them to eat faster, mainly for flavor
	ADD_TRAIT(owner, TRAIT_VORACIOUS, REF(src))
	ADD_TRAIT(owner, TRAIT_FLESH_DESIRE, REF(src))
	return ..()

/datum/brain_trauma/severe/flesh_desire/on_life(seconds_per_tick, times_fired)
	// Causes them to need to eat at 10x the normal rate
	owner.adjust_nutrition(-hunger_rate * HUNGER_FACTOR)
	if(SPT_PROB(10, seconds_per_tick))
		to_chat(owner, span_notice(pick("Вы не можете перестать думать о сыром мясе...", "Тебе НУЖНО кого-нибудь съесть.", "Чувство голода вернулось...", "Ты жаждешь плоти.", "Вы умираете от голода!")))
	owner.overeatduration = max(owner.overeatduration - 200 SECONDS, 0)

/datum/brain_trauma/severe/flesh_desire/on_lose()
	REMOVE_TRAIT(owner, TRAIT_VORACIOUS, REF(src))
	REMOVE_TRAIT(owner, TRAIT_FLESH_DESIRE, REF(src))
	return ..()

// This one is for "Lady out of gates" or /obj/item/wallframe/painting/eldritch/beauty
/datum/brain_trauma/severe/eldritch_beauty
	name = "Навязчивый перфекционизм"
	desc = "Пациент зациклен на воспринимаемом 'несовершенстве' окружающих его предметов. Пациента возбуждает ощущение одежды на теле."
	scan_desc = "обсессивное расстройство личности"
	gain_text = span_warning("Все вокруг *неидеально*! Я не выношу, когда ко мне прикасаются!")
	lose_text = span_notice("Ваш разум успокаивается.")
	random_gain = FALSE
	/// How much damage we deal with each scratch
	var/scratch_damage = 0.5

/datum/brain_trauma/severe/eldritch_beauty/on_life(seconds_per_tick, times_fired)
	if(owner.incapacitated)
		return

	// Scratching code
	var/obj/item/bodypart/bodypart = owner.get_bodypart(owner.get_random_valid_zone(even_weights = TRUE))
	if(!bodypart || !IS_ORGANIC_LIMB(bodypart) || (bodypart.bodypart_flags & BODYPART_PSEUDOPART))
		return
	if(!ishuman(owner))
		return
	// Jumpsuits ruin the "perfection" of the body
	var/mob/living/carbon/human/scratcher = owner
	if(!length(scratcher.get_clothing_on_part(bodypart)))
		return

	owner.apply_damage(scratch_damage, BRUTE, bodypart)
	if(SPT_PROB(33, seconds_per_tick))
		to_chat(owner, span_notice("Вы яростно царапаете свою одежду [bodypart.plaintext_zone]!"))

// This one is for "Climb over the rusted mountain" or /obj/structure/sign/painting/eldritch/rust
/datum/brain_trauma/severe/rusting
	name = "Синдром периодических психических проявлений"
	desc = "Пациент страдает от редкого психического расстройства и может проявлять или усиливать психические явления в округе. Пациент не контролирует эти явления."
	scan_desc = "опасная пси-волновая активность"
	gain_text = span_warning("Поднимитесь над ржавчиной. Овладейте энтропией.")
	lose_text = span_notice("Вы чувствуете себя так, будто только что проснулись от дурного сна.")
	random_gain = FALSE

/datum/brain_trauma/severe/rusting/on_life(seconds_per_tick, times_fired)
	var/atom/tile = get_turf(owner)
	// Examining a painting should stop this effect to give counterplay
	if(HAS_TRAIT(owner, TRAIT_ELDRITCH_PAINTING_EXAMINE))
		return

	if(SPT_PROB(50, seconds_per_tick))
		to_chat(owner, span_notice("Вы чувствуете упадок..."))
		tile.rust_heretic_act()

/datum/brain_trauma/severe/kleptomaniac
	name = "Клептомания"
	desc = "Пациент склонен к краже вещей."
	scan_desc = "клептомания"
	gain_text = span_warning("Вы чувствуете внезапное желание взять это. Конечно, никто не заметит.")
	lose_text = span_notice("Вы больше не испытываете желания брать вещи.")
	/// Cooldown between allowing steal attempts
	COOLDOWN_DECLARE(steal_cd)

/datum/brain_trauma/severe/kleptomaniac/on_gain()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(damage_taken))

/datum/brain_trauma/severe/kleptomaniac/on_lose()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE)

/datum/brain_trauma/severe/kleptomaniac/proc/damage_taken(datum/source, damage_amount, damage_type, ...)
	SIGNAL_HANDLER
	// While you're fighting someone (or dying horribly) your mind has more important things to focus on than pocketing stuff
	if(damage_amount >= 5 && (damage_type == BRUTE || damage_type == BURN || damage_type == STAMINA))
		COOLDOWN_START(src, steal_cd, 12 SECONDS)

/datum/brain_trauma/severe/kleptomaniac/on_life(seconds_per_tick, times_fired)
	if(owner.usable_hands <= 0)
		return
	if(!SPT_PROB(5, seconds_per_tick))
		return
	if(!COOLDOWN_FINISHED(src, steal_cd))
		return
	if(!owner.has_active_hand() || !owner.get_empty_held_indexes())
		return

	// If our main hand is full, that means our offhand is empty, so try stealing with that
	var/steal_to_offhand = !!owner.get_active_held_item()
	var/curr_index = owner.active_hand_index
	var/pre_dir = owner.dir
	if(steal_to_offhand)
		owner.swap_hand(owner.get_inactive_hand_index())

	var/list/stealables = list()
	for(var/obj/item/potential_stealable in oview(1, owner))
		if(potential_stealable.w_class >= WEIGHT_CLASS_BULKY)
			continue
		if(potential_stealable.anchored || !(potential_stealable.interaction_flags_item & INTERACT_ITEM_ATTACK_HAND_PICKUP))
			continue
		stealables += potential_stealable

	for(var/obj/item/stealable as anything in shuffle(stealables))
		if(!owner.CanReach(stealable, view_only = TRUE) || stealable.IsObscured())
			continue
		// Try to do a raw click on the item with one of our empty hands, to pick it up (duh)
		owner.log_message("попытка взять вещи (клептомания)", LOG_ATTACK, color = "orange")
		owner.ClickOn(stealable)
		// No feedback message. Intentional, you may not even realize you picked up something
		break

	if(steal_to_offhand)
		owner.swap_hand(curr_index)
	owner.setDir(pre_dir)
	// Gives you a small buffer - not to avoid spam, but to make it more subtle / less predictable
	COOLDOWN_START(src, steal_cd, 8 SECONDS)
