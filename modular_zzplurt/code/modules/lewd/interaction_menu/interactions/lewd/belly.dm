/// Действия с животиком

/// ADD ANDROMEDA-13 (@ms_kira): Перевод, большое дополнение ЕРП контента.
/datum/interaction/lewd/bellyfuck
	name = "Тереться о живот (Членом)"
	description = "Трахнись о животик своего партнера. (Это сильно заводит, Немного приятно)"
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_TOPLESS)
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%USER% Обильно кончает на животик %TARGET%.",
		"%USER% Обильно испускает горячее семя на живот %TARGET%.",
		"%USER% Грубо стреляет на животик %TARGET% горячим семенем.",
		"%USER% Выпускает своё горячее семя на животик %TARGET%.",
		"%USER% Покрывает животик %TARGET% своим семенем."
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(
		"Вы обильно кончаете на животик %TARGET%.",
		"Вы обильно испускаете горячее семя на живот %TARGET%.",
		"Вы грубо стреляете на животик %TARGET% горячим семенем.",
		"Вы сдавленно выпускаете свое семя на животик %TARGET%.",
		"Вы покрываете животик %TARGET% в своем семени."
	))
	cum_partner_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%USER% Обильно кончает на ваш животик.",
		"%USER% Обильно испускает семя на ваш животик.",
		"%USER% Грубо стреляет на ваш животик горячим семенем... тепло.",
		"%USER% Струйчато выпускает свое семя на ваш животик.",
		"%USER% Покрывает ваш живот своими соками."
	))
	message = list(
		"Трется своим членом о животик %TARGET%.",
		"Грубо толкается о животик %TARGET%.",
		"Входит вскользь проходясь по животику %TARGET% горячим членом.",
		"Специально мажет мимо промежножья, толкаясь в животик %TARGET%.",
		"Втирается своим членом в живот %TARGET%.",
		"Пихается членом между ног по животику %TARGET%.",
		"Растирается своим членом о животик %TARGET%.",
		"Долбится о животик %TARGET%."
	)
	user_messages = list(
		"Вы чувствуете тепло животика %TARGET% проходясь своим членом по животику %TARGET%.",
		"Вы невероятно чувствительно дрожите от животика %TARGET% обвалакивающего ваш ствол.",
		"Вы содрагаетсь от возбуждающих ощущений, скользя по животику %TARGET% своим пенисом.",
		"Вы прекрасно ощущаете мягкость животика %TARGET% своим стволом.",
		"Вы ощущаете как животик %TARGET% обволакивает ваш грубый член."
	)
	target_messages = list(
		"Вы чувствуете как %USER% грубо проходится членом по вашему животику.",
		"Вы приятно ощущаете грубость члена %USER% скользящего по животику.",
		"Вы содрагаетесь, когда член %USER% пульсирует, упираясь в ваш животик.",
		"Вы ощущаете как член %USER% скользит по вашему животику, пачкая тот соками.",
		"Тепло члена %USER% влажно и горячо расплывается по вашему животику."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 3
	target_pleasure = 0
	user_arousal = 8
	target_arousal = 4

/datum/interaction/lewd/nuzzle_belly
	name = "Прижаться лицом в животик"
	description = "Прижмитесь своим лицом и головой к животику Партнера. (Это только заводит)"
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_TOPLESS)
	message = list(
		"Гладится лицом о животик %TARGET%.",
		"Гладится лицом о животик %TARGET%.",
		"Гладится лицом о животик %TARGET%.",
		"Трется своим лицом о живот %TARGET%.",
		"Прижимается своей щекой к животику %TARGET% и гладится.",
		"Тычется своим лицом в животик %TARGET%."
	)
	user_messages = list(
		"Вы ощущаете приятное тепло животика %TARGET% на своем лице.",
		"Вы ощущаете приятное тепло животика %TARGET% на своем лице.",
		"Мягкость животика %TARGET% вызывает у вас легкие подрагивания.",
		"Животик %TARGET% манит вас, с каждым разом как вы гладитесь о него."
	)
	target_messages = list(
		"Вы ощущаете как лицо %USER% гладится о ваш животик.",
		"%USER% Гладится своей щечкой о ваш животик.",
		"%USER% Гладится своей щечкой о ваш животик.",
		"Тепло лица %USER% гладящегося о ваш животик, заставляет вас вздрогнуть!"
	)
	sound_range = 1
	sound_use = FALSE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 3
	target_arousal = 3

//-// -Rewokin_comment //-//
// Бимбофикация, боже, удалим нахер

// /datum/interaction/lewd/deflate_belly
//	name = "Deflate Belly"
//	description = "Deflate belly."
//	user_required_parts = list(ORGAN_SLOT_BELLY = REQUIRE_GENITAL_ANY)
//	interaction_requires = list(INTERACTION_REQUIRE_SELF_HUMAN)
//	usage = INTERACTION_SELF
//	message = list(
//		"deflates their belly",
//		"lets out air from their belly",
//		"makes their belly smaller"
//	)
//	sound_range = 1
//	sound_use = FALSE
//	user_pleasure = 0
//	user_arousal = 0

// /datum/interaction/lewd/deflate_belly/post_interaction(mob/living/carbon/human/user, mob/living/carbon/human/target)
//	. = ..()
//	var/obj/item/organ/genital/belly/gut = user.get_organ_slot(ORGAN_SLOT_BELLY)
//	if(gut)
//		gut.set_size(gut.genital_size - 1)
//		user.update_body()

// /datum/interaction/lewd/inflate_belly
//	name = "Inflate Belly"
//	description = "Inflate belly."
//	user_required_parts = list(ORGAN_SLOT_BELLY = REQUIRE_GENITAL_ANY)
//	interaction_requires = list(INTERACTION_REQUIRE_SELF_HUMAN)
//	usage = INTERACTION_SELF
//	message = list(
//		"inflates their belly",
//		"makes their belly bigger",
//		"expands their belly"
//	)
//	sound_range = 1
//	sound_use = FALSE
//	user_pleasure = 0
//	user_arousal = 0

// /datum/interaction/lewd/inflate_belly/post_interaction(mob/living/carbon/human/user, mob/living/carbon/human/target)
//	. = ..()
//	var/obj/item/organ/genital/belly/gut = user.get_organ_slot(ORGAN_SLOT_BELLY)
//	if(gut)
//		gut.set_size(gut.genital_size + 1)
//		user.update_body()
