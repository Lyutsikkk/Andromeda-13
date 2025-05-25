/// Действия с сиськами

//-// -Rewokin_fun_comment //-//
// -Мы хотим больше сисек! Мы хотим больше.. эээ... -Что самое главное в женщине? *задумался*
// -Душа.. Душа! -А как же сиськи? -Сиськи это хорошо, но.. главное это.. душа...

/// ADD ANDROMEDA-13 (@ms_kira): Перевод, масштабное дополнение ЕРП контента.
/datum/interaction/lewd/breastfeed
	name = "Кормежка грудью (Грудь)"
	description = "Накормить своего партнера своей грудью. (Это заводит, Немного приятно)"
	user_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_EXPOSED)
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH, INTERACTION_REQUIRE_SELF_HUMAN)
	additional_details = list(INTERACTION_MAY_CONTAIN_DRINK)
	message = list(
		"Прижимает свои груди ко рту %TARGET%, выплескивая свои теплые %MILK% прямо в рот.",
		"Наполняет рот %TARGET% теплым и сладким %MILK% пока грудь сжата.",
		"Стреляет в ротик %TARGET% своим %MILK% сжавши свою грудку.",
		"Отстреливается из груди в ротик %TARGET% сладким %MILK%.",
		"Небрежно тычась грудкой в ротик %TARGET% стреляет теплым и сладким %MILK%.",
		"Нежно сжимает свою грудь, заставляя вытечь сладкое %MILK% в ротик %TARGET%.",
		"Возится своей грудью с ртом %TARGET% наполняя тот теплым и сладким %MILK%.",
		"Пускает большую струю своей %MILK% прямо на заднюю стенку горла %TARGET%."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/oral1.ogg',
		'modular_zzplurt/sound/interactions/oral2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 2
	user_arousal = 3
	target_pleasure = 0
	target_arousal = 2

/datum/interaction/lewd/breastfeed/act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/genital/breasts/breasts = user.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(!breasts?.internal_fluid_datum)
		return

	var/datum/reagent/milk = find_reagent_object_from_type(breasts.internal_fluid_datum)
	var/list/original_messages = message.Copy()
	var/chosen_message = pick(message)
	chosen_message = replacetext(chosen_message, "%MILK%", LOWER_TEXT(milk.name))
	message = list(chosen_message)
	. = ..()
	message = original_messages

/datum/interaction/lewd/breastfeed/post_interaction(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/obj/item/organ/genital/breasts/breasts = user.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(breasts?.internal_fluid_datum)
		// Calculate milk amount based on how full the breasts are (0.5 to 2 multiplier)
		// Рассчитайте количество молока в зависимости от наполненности груди (множитель от 0,5 до 2)
		var/milk_multiplier = 0.5
		if(breasts.internal_fluid_maximum > 0)
			milk_multiplier = 0.5 + (1.5 * (breasts.internal_fluid_count / breasts.internal_fluid_maximum))

		var/transfer_amount = rand(1, 3 * milk_multiplier)
		var/datum/reagents/R = new(breasts.internal_fluid_maximum)
		breasts.transfer_internal_fluid(R, transfer_amount)
		R.trans_to(target, R.total_volume)
		qdel(R)

/datum/interaction/lewd/titgrope
	name = "Поласкать грудь"
	description = "Поласкать чьи-бы то нибыло груди/сиськи/титьки/сосочки. (Это заводит, Немного приятно)"
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	target_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_ANY)
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	message = list(
		"Нежно хватается за груди %TARGET%.",
		"Мягко жамкает груди %TARGET%.",
		"Обхватывает груди %TARGET%.",
		"Проводит несколькими пальцами по сосочкам груди %TARGET%.",
		"Настойчиво дразнит соски %TARGET%.",
		"Аккуратно сжимает груди %TARGET% в своих конечностях.",
		"Обхватывает груди %TARGET% начиная водить их по часовой стрелке разминая.",
		"Сдавливает груди %TARGET% вместе, затем плавно разминая.",
		"Настойчиво жамкает груди %TARGET% нежно сдавливая их.",
		"Проводит пальцем по груди %TARGET%."
	)
	sound_possible = list('modular_zzplurt/sound/interactions/squelch1.ogg')
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	user_arousal = 4
	target_pleasure = 2
	target_arousal = 5

/datum/interaction/lewd/titgrope/act(mob/living/user, mob/living/target)
	var/obj/item/liquid_container
	var/list/original_messages = message.Copy()

	// Check for container
	// Проверьте наличие контейнера
	var/obj/item/cached_item = user.get_active_held_item()
	if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
		liquid_container = cached_item
	else
		cached_item = user.pulling
		if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
			liquid_container = cached_item

	if(liquid_container)
		message = list("Сцеживает грудь %TARGET% в [liquid_container].")
		interaction_modifier_flags |= INTERACTION_OVERRIDE_FLUID_TRANSFER
		. = ..()
		interaction_modifier_flags &= ~INTERACTION_OVERRIDE_FLUID_TRANSFER
		message = original_messages
		return

	// Вариации действий от интента
	switch(resolve_intent_name(user.combat_mode))
		if("harm")
			message = list(
				"Агрессивно хватается за груди %TARGET% и крепко сжимает их.",
				"Берется за груди %TARGET% и начинает крепко сдавливать их.",
				"Крепко сдавливает груди %TARGET% в своих конечностях.",
				"Неаккуратно сильно шлепает %TARGET% по груди.",
				"Насильно и с силой сжимает груди %TARGET%.",
				"Насильно лапает груди %TARGET% доставляя боль.",
				"Крепко ухватившись, насильно облапывает груди %TARGET%.",
				"Агрессивно берется за груди %TARGET% и тянет их в разные стороны, сдавливая.",
				"Грубо лапает груди %TARGET% вдавливая их"
			)
		if("disarm")
			message = list(
				"Игриво ласкает груди %TARGET%.",
				"Дразняще лапает груди %TARGET%.",
				"Игриво сжимает груди %TARGET%.",
				"Заигрывающе мягко водит грудями %TARGET% в разные стороны.",
				"Озорнисто сдавливает груди %TARGET%.",
				"Игриво подразнивает соски на груди %TARGET% своими пальцами."
			)
		if("grab")
			message = list(
				"Крепко и настойчиво обхватывает груди %TARGET%.",
				"Словно они собственность, лапает груди %TARGET%.",
				"Жадко и беспощадно разминает груди %TARGET% потягивая те к себе.",
				"Грубо и собственнически ласкает груди %TARGET%.",
				"Жадно крутит сосочки на груди %TARGET% потягивая те.",
				"Жадно потягивает сосочки %TARGET%.",
				"Жадно потягивает груди %TARGET%."
			)
	. = ..()
	message = original_messages

/datum/interaction/lewd/titgrope/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(interaction_modifier_flags & INTERACTION_OVERRIDE_FLUID_TRANSFER)
		var/obj/item/liquid_container

		var/obj/item/cached_item = user.get_active_held_item()
		if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
			liquid_container = cached_item
		else
			cached_item = user.pulling
			if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
				liquid_container = cached_item

		if(liquid_container)
			var/obj/item/organ/genital/breasts/breasts = target.get_organ_slot(ORGAN_SLOT_BREASTS)
			if(breasts?.internal_fluid_datum)
				// Calculate milk amount based on how full the breasts are (0.5 to 2 multiplier)
				// Рассчитайте количество молока в зависимости от наполненности груди (множитель от 0,5 до 2)
				var/milk_multiplier = 0.5
				if(breasts.internal_fluid_maximum > 0)
					milk_multiplier = 0.5 + (1.5 * (breasts.internal_fluid_count / breasts.internal_fluid_maximum))

				var/transfer_amount = rand(1, 3 * milk_multiplier)
				var/datum/reagents/R = new(breasts.internal_fluid_maximum)
				breasts.transfer_internal_fluid(R, transfer_amount)
				R.trans_to(liquid_container, R.total_volume)
				qdel(R)

	// Handle arousal effects based on intent
	// Обработка эффектов возбуждения в зависимости от интента
	var/intent = resolve_intent_name(user.combat_mode)
	if(intent != "harm" && prob(5 + target.arousal))
		var/list/arousal_messages
		switch(intent)
			if("help")
				arousal_messages = list(
					"%TARGET% Подрагивает от возбуждения.",
					"%TARGET% Подрагивает от возбуждения, слегка отклоняясь.",
					"%TARGET% Тихо постанывает.",
					"%TARGET% Тихо постанывает, слегка отклоняясь.",
					"%TARGET% Выдыхает тихий постон.",
					"%TARGET% Выдыхает тихий постон, слегка откинув голову.",
					"%TARGET% Задыхается в удовольствии.",
					"%TARGET% Задыхается в удовольствии, интенсивно подрагивая.",
					"%TARGET% Тихонько вздрагивает.",
					"%TARGET% Тихонько вздрагивает, зажмурив глаза.",
					"%TARGET% Дрожит, когда руки проходят по её груди."
				)
			if("disarm")
				arousal_messages = list(
					"%TARGET% Игриво извивается.",
					"%TARGET% Игриво извивается и ерзает.",
					"%TARGET% Испускает подразнивающее хихиканье.",
					"%TARGET% Испускает подразнивающее хихиканье, нежно извиваясь.",
					"%TARGET% Прикусывает свою губу, нежно вздыхая.",
					"%TARGET% Прикусывает свои губы, аккуратно выдыхая.",
					"%TARGET% Дразняще покачивается из стороны в сторону.",
					"%TARGET% Дразняще покачивается ерзая на месте.",
					"%TARGET% Кокетливо хихикает с удовольствием в глазах.",
					"%TARGET% Делает кокетливый вздох."
				)
			if("harm")
				arousal_messages = list(
					"%TARGET% Извивается от ласкающей боли.",
					"%TARGET% Протяжно подрагивает от применяемого насилия.",
					"%TARGET% Болезненно содрагается от грубости.",
					"%TARGET% Болезненно постанывает зажмурив глаза и покосившись.",
					"%TARGET% Дрожит от боли, выдыхая.",
					"%TARGET% С болью постанывает, извиваясь и дрожа.",
					"%TARGET% Извивается в попытке вырваться из грубого захвата, испуская протяжный постон."
				)
			if("grab")
				arousal_messages = list(
					"%TARGET% Жадно стонет.",
					"%TARGET% Жадно постанывает.",
					"%TARGET% Подается навстречу прикосновениям.",
					"%TARGET% Подается навстречу прикосновениям, протяжно подрагивая.",
					"%TARGET% Издает жаждящий постон.",
					"%TARGET% Издает жаждящий постон, извиваясь от удовольствия.",
					"%TARGET% Подрагивает от возбуждения.",
					"%TARGET% Извиваясь дрожит от возбуждения.",
					"%TARGET% Извивается, дрожа от предвкушения и нежно вздыхая.",
					"%TARGET% Дрожит от предвкушения застонав."
				)

		if(arousal_messages)
			var/target_message = list(pick(arousal_messages))
			target.visible_message(span_lewd(replacetext(target_message, "%TARGET%", target)))

/datum/interaction/lewd/breastsmother
	name = "Придушить грудью"
	description = "Задушите кого-нибудь своей грудью. (Это заводит, Немного душит)"
	interaction_requires = list(
		INTERACTION_REQUIRE_TARGET_MOUTH
	)
	user_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_EXPOSED)
	message = list(
		"Прижимает свои груди к лицу %TARGET%.",
		"Вздохнув прижимает свои груди к лицу %TARGET% и елозит ими.",
		"Душит лицо %TARGET% своими титьками.",
		"Плавно придушивает %TARGET% своими сисечками.",
		"Возится грудью о лицо %TARGET% сжимая то между полусфер.",
		"Грубо сжимает голову %TARGET% между своими титьками.",
		"Крепко прижимает лицо %TARGET% к своим грудям, зажимая его.",
		"Зажимает голову %TARGET% между своих сисек, начиная елозить ими."
	)
	user_messages = list(
		"Вы чувствуете как лицо %TARGET% крепко зажато между ваших сисек.",
		"Вы крепко прижимаете голову %TARGET% к своей груди.",
		"Вы доминантно жмете %TARGET% в своей груди.",
		"Вы грубо возитесь грудью о лицо %TARGET%.",
		"Вы держите лицо %TARGET% в своем декольте."
	)
	target_messages = list(
		"Ваше лицо зажато между грудей %USER%.",
		"Сиськи %USER% постепенно душат вас.",
		"Нежные на первый взгляд сисечки %USER% придушивают вас.",
		"Титьки %USER% грубо сжимают ваше лико, затрудняя дыхание.",
		"Вы ничего не видите, кроме декальте %USER%."
	)
	sound_range = 1
	sound_use = FALSE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 3
	target_arousal = 3

/datum/interaction/lewd/breastsmother/post_interaction(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!istype(user))
		return
	if(prob((user.dna.features["sexual_potency"] * 5) + 15))
		target.adjustOxyLoss(2)
		target.adjust_arousal(5)
		user.adjust_arousal(8)

/datum/interaction/lewd/do_boobjob
	name = "Сделать работу сиськами"
	description = "Он же буб-джоб, поработай полусферами, покажи свою мощь. (Это заводит, Это приятно)" //-// -Rewokin_fun_comment //-// буб-джоб, фак-сис, дрочь-шарс
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	user_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%TARGET% Обильно пачкает грудь %USER% своим семенем.",
			"%TARGET% Кончает на грудь %USER% своим семенем.",
			"%TARGET% Небрежно стреляет горячим семенем в грудки %USER%.",
			"%TARGET% Несдерживаясь обильно стреляет в титьки %USER% своим семенем.",
			"%TARGET% Обильно пачкает грудь и лицо %USER% своим семенем.",
			"%TARGET% Испускает своё семя прямо в титьки %USER%.",
			"%TARGET% Обильно стреляет семенем в сиськи %USER% брызгая в лицо.",
			"%TARGET% Покрывает грудь %USER% в своем семени."
		)
    )
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%TARGET% Обильно кончает на вашу грудь.",
			"%TARGET% Кончает на вашу грудь своим семенем.",
			"%TARGET% Небрежно стреляет горячим сенем в ваши грудки.",
			"%TARGET% Несдержанно обильно стреляет в ваши титьки семенем.",
			"%TARGET% Обильно кончает на вашу грудь и попадает в ваше лицо.",
			"%TARGET% Стреляет семенем в ваши сиськи.",
			"%TARGET% Неумолимо стреляет семенем в ваши сиськи, пачкая ваше лицо вдобавок.",
			"%TARGET% Покрывает вашу грудь семенем, пульсируя между ваших сисек."
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_USER = list(
			"Вы обильно кончаете на грудь %USER%.",
			"Вы кончаете на грудь %USER% своим семенем.",
			"Вы небрежно стреляете горячим семенем в грудки %USER%.",
			"Вы несдержанно обильно стреляете в титьки %USER% горячим семенем.",
			"Вы неаккуратно кончаете на грудь %USER% попадая в лицо.",
			"Вы кончаете прямо в сиськи %USER%.",
			"Вы неаккуратно стреляете в грудь %USER% пачкая лицо.",
			"Вы покрываете титьки %USER% своим семенем."
		)
    )
	message = list(
		"Обхватывает грудью пенис %TARGET%.",
		"Игриво водит своей грудью вокруг пениса %TARGET%.",
		"Нежно надрачивает член %TARGET% своими грудями.",
		"Вздрачивает своими титьками член %TARGET% вверх-вниз.",
		"Неаккуратно сжимает сисечками член %TARGET%.",
		"Елозит своими полусферками вокруг члена %TARGET%.",
		"Аккуратно возится своими грудками вокруг пениса %TARGET%.",
		"Работает своей грудью с членом %TARGET%.",
		"Ублажает член %TARGET% своей грудью.",
		"Двигает своими грудями вверх-вниз ухватив между ними член %TARGET%.",
		"Сжимает свои груди вокруг члена %TARGET%."
	)
	user_messages = list(
		"Вы чувствуете как пенис %TARGET% содрагается в пульсации между ваших грудей.",
		"Тепло ствола %TARGET% довольно приятно ощущается между ваших грудей.",
		"Член %TARGET% будоражаще пульсирует между ваших грудок.",
		"Горячий член %TARGET% нежно содрагается от удовольствия, между ваших титек.",
		"Вы ощущаете как груди трутся все легче, постепенно двигая своей грудью вверх-вниз, обхватив член %TARGET% ею же.",
		"Вы сжимаете свою грудь вокруг члена %TARGET%."
	)
	target_messages = list(
		"Мягкая грудь %USER% нежно сжимает ваш член.",
		"Нежная работа грудью %USER% сводит вашего друга с ума.",
		"Плавные и мягкие движения титьками %USER% заставляет дрожать.",
		"Ваш ствол с легкостью скользит между титек %USER%.",
		"Вы ощущаете как груди %USER% двигаются вверх-вниз обхватывая ваш член и создавая еще большее тепло.",
		"Мягкость груди %USER% сводит вас с ума."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 4
	user_arousal = 4
	target_arousal = 6
