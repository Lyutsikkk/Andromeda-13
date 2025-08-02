// Действия с сосочками

/// ADD ANDROMEDA-13 (@rewokin/@ms_kira): Перевод/ До-перевод, среднее дополнение ЕРП контента.
/datum/interaction/lewd/nipsuck
	name = "Пососать соски"
	description = "Посасывайте чьи-нибудь сосочки. (Это заводит, Немного приятно)"
	interaction_requires = list(INTERACTION_REQUIRE_SELF_MOUTH)
	target_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_EXPOSED)
	additional_details = list(INTERACTION_MAY_CONTAIN_DRINK)
	message = list(
		"Нежно посасывает сосочек на груди %TARGET%.",
		"Плавно и спокойно посасывает титьку %TARGET%.",
		"Аккуратно и тактно сосет титьки %TARGET%.",
		"Тихоньо всасывае титечку %TARGET% в свой рот.",
		"Слегка прикусив сосочек, посасывает грудь %TARGET%.",
		"Облизывает сосочек %TARGET% заставляя тот возбудиться.",
		"Лижет сосочки груди %TARGET%."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/oral1.ogg',
		'modular_zzplurt/sound/interactions/oral2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	user_arousal = 3
	target_pleasure = 2.5
	target_arousal = 5

/datum/interaction/lewd/nipsuck/act(mob/living/user, mob/living/target)
	var/list/original_messages = message.Copy()

	// Handle different intents
	// Вариации действий от интента
	switch(resolve_intent_name(user.combat_mode))
		if("harm")
			message = list(
				"Неаккуратно кусает сосочек %TARGET%.",
				"Дерзко покусывает соски %TARGET%.",
				"Грубо и больно кусает сосочки %TARGET%.",
				"Напряженно и брутально сосет сосочек %TARGET%.",
				"Агрессиво сосет сосочки %TARGET%."
			)
			target_pleasure = 4 // Aggressive sucking has higher rewards	// Агрессивное сосание приносит больше пользы
			target_arousal = 5
		if("disarm")
			message = list(
				"Игриво кусает сосочек %TARGET%.",
				"Игриво сжимая титьки %TARGET% ласково кусается.",
				"Дразня кусается за сиськи %TARGET%.",
				"Дразняще крутит соски %TARGET% в своих зубах.",
				"Страстно всасывает сосочек %TARGET% в ротик."
			)
		if("grab")
			message = list(
				"Сосредоточившись вполне напряженно сосет сосок %TARGET%.",
				"Втягивает сосочек %TARGET% в ротик не отпуская.",
				"Жадно сосет сосочки %TARGET%.",
				"Беспощадно и собственно всасывает соски %TARGET%.",
				"Кусает сосочек %TARGET% и тянет на себя.",
			)
			target_pleasure = 4 // Intent sucking has higher rewards	// Интент сосания имеет более высокую награду
			target_arousal = 5
	. = ..()
	message = original_messages

/datum/interaction/lewd/nipsuck/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	var/obj/item/organ/genital/breasts/breasts = target.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(breasts?.internal_fluid_datum)
		// Calculate milk amount based on how full the breasts are (0.5 to 2 multiplier)
		// Рассчитайте количество молока в зависимости от наполненности груди (множитель от 0,5 до 2)
		var/milk_multiplier = 1
		if(breasts.internal_fluid_maximum > 0)
			milk_multiplier = 1 + (3 * (breasts.reagents.total_volume / breasts.internal_fluid_maximum))

		var/transfer_amount = rand(2, 4 * milk_multiplier)
		var/intent = resolve_intent_name(user.combat_mode)
		if(intent == "harm" || intent == "grab")
			transfer_amount = rand(2, 6 * milk_multiplier) // More aggressive sucking gets more milk	// Более агрессивное сосание позволяет получить больше молока

		var/datum/reagents/R = new(breasts.internal_fluid_maximum)
		breasts.reagents.trans_to(R, transfer_amount)
		R.trans_to(user, R.total_volume, transferred_by = target)
		qdel(R)

	if(!user.combat_mode && prob(5 + target.arousal))
		var/list/arousal_messages
		switch(resolve_intent_name(user.combat_mode))
			if("help")
				arousal_messages = list(
					"%TARGET% Подрагивает от возбуждения.",
					"%TARGET% Тихонько вздрагивает, постанывая.",
					"%TARGET% Нежно вздыхает.",
					"%TARGET% Тихо постанывает.",
					"%TARGET% Выдыхает тихий постон.",
					"%TARGET% Задыхается от удовольствия.",
					"%TARGET% Возбужденно дрыгается тельцем.",
					"%TARGET% вздрагивает от приставаний к своей груди."
				)
			if("harm")
				arousal_messages = list(
					"%TARGET% Судорожно дрожит от боли.",
					"%TARGET% Брутально стонет, ощущая боль.",
					"%TARGET% Постанывает от жгучей боли в груди.",
					"%TARGET% Возбужденно от боли, дрыгается тельцем.",
					"%TARGET% Дергается от боли и удовольствия."
				)
			if("disarm")
				arousal_messages = list(
					"%TARGET% Игриво-нежно извивается.",
					"%TARGET% Слегка сжимается игриво хихикая от приятности.",
					"%TARGET% Нежно подрагивает.",
					"%TARGET% Дразняще качается.",
					"%TARGET% Испускает сладкие стоны.",
					"%TARGET% Прикусывает губу от возбуждения.",
					"%TARGET% Извивается от прилюдий."
				)
			if("grab")
				arousal_messages = list(
					"%TARGET% Стонет от нетерпеливости.",
					"%TARGET% Нетерпеливо дрожит с удовольствием.",
					"%TARGET% Жаждуще постанывает.",
					"%TARGET% Выпячивается вперед грудью, возбужденно вздыхая.",
					"%TARGET% Трудно издает желанный постон.",
					"%TARGET% Содрагается в дрожании от возбуждения.",
					"%TARGET% Судорожно дрожит от предвкушения."
				)

		if(arousal_messages)
			message = list(pick(arousal_messages))
