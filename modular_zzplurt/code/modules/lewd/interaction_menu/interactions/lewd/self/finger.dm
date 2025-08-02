/// Пальчик в киску/анал

/// ADD ANDROMEDA-13 (@rewokin): Перевод, дополнение ЕРП контента.
/datum/interaction/lewd/finger_self_vagina
	name = "Пальчики в киску (Себе)"
	description = "Поиграйте со своей киской~."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	user_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	usage = INTERACTION_SELF
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_VAGINA)
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(
		"сильно обильно на пальцы",
		"содрогается, когда кончает на руку",
		"пальцами доводит себя до кульминации"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(
		"Вы обильно кончаете на свои пальцы",
		"Вы содрогаетесь, когда кончаете на руку",
		"Вы доводите себя пальцами до кульминации"
	))
	message = list(
		"глубоко вводит пальцы в киску",
		"проникает пальцами в киску",
		"играет их киской",
		"активно вводит пальцами в киску"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ_fingering.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 4
	user_arousal = 6

/datum/interaction/lewd/finger_self_vagina/act(mob/living/user, mob/living/target)
	var/obj/item/liquid_container

	var/obj/item/cached_item = user.get_active_held_item()
	if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
		liquid_container = cached_item
	else
		cached_item = user.pulling
		if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
			liquid_container = cached_item

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

/datum/interaction/lewd/finger_self_anus
	name = "Пальчики в анал (Себе)"
	description = "Поиграйте со своей задницей"
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	user_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	usage = INTERACTION_SELF
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_BOTH)
	message = list(
		"глубоко вводит пальцы в анал",
		"проникает пальцами в анал",
		"активно вводит пальцами в анал"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ_fingering.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 3
	user_arousal = 5
