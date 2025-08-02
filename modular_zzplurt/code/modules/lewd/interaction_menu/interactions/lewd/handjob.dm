// Действия с членом при помощи ручек

/// ADD ANDROMEDA-13 (@ms_kira): Перевод, масштабное дополнение ЕРП контента.
/datum/interaction/lewd/handjob
	name = "Подрочить член (ХэндДжоб)"
	description = "Поработай ручками с кем-нибудь. (Это заводит, Немного приятно)"
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	message = list(
		"Вздрачивает член %TARGET%.",
		"Грубо подрачивает пенис %TARGET%.",
		"Неаккуратно продрачивает член %TARGET%.",
		"Ласково играется с пенисом %TARGET%.",
		"Брутально надрачивает член %TARGET%.",
		"Резкими движениями дрочит член %TARGET%.",
		"Работает со стволом %TARGET% своими руками.",
		"Жестко вздрачивает %TARGET% за член."
	)
	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Кончает на руки %USER%.",
			"Судорожно кончает в ладошки %USER%.",
			"Сжав ягодицы и ноги, кончает на ручки %USER%.",
			"Выплескивает свое семя на руки %USER%.",
			"Покрывает семенем пальцы %USER%."
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Вы кончаете на руки %USER%.",
			"Вы судорожно кончаете в ладошки %USER%.",
			"Вы сжимаете ягодицы и поджимаете ноги, кончая на ручки %USER%.",
			"Вы стреляете на ладошки %USER%.",
			"Вы покрываете семенем пальчики %USER%."
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%TARGET% Кончает на ваши руки.",
			"%TARGET% Судорожно кончает в ваши ладошки.",
			"%TARGET% Сжавшись стреляет горячим семенем на ваши ручки.",
			"%TARGET% Стреляет на ваши ладошки.",
			"%TARGET% Покрывает семенем ваши пальчики."
		)
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	user_arousal = 3
	target_pleasure = 4
	target_arousal = 6

/datum/interaction/lewd/handjob/act(mob/living/user, mob/living/target)
	var/obj/item/liquid_container

	// Check active hand first
	// Проверка, активная рука
	var/obj/item/cached_item = user.get_active_held_item()
	if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
		liquid_container = cached_item
	else
		// Check if pulling a container
		// Проверка, есть ли контейнер
		cached_item = user.pulling
		if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
			liquid_container = cached_item

	// Add container text to message if needed
	// Добавьте текст контейнера в сообщение, если это необходимо
	if(liquid_container)
		var/list/original_messages = message.Copy()
		var/chosen_message = pick(message)
		LAZYADD(fluid_transfer_objects, list("[REF(target)]" = liquid_container))
		message = list("[chosen_message] над [liquid_container]")
		. = ..()
		LAZYREMOVE(fluid_transfer_objects, REF(target))
		message = original_messages
	else
		. = ..()
