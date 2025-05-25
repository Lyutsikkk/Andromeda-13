//Nodes that are found inside Bepis Disks.

/datum/techweb_node/light_apps
	id = TECHWEB_NODE_LIGHT_APPS
	display_name = "Осветительные Приборы"
	description = "Применение технологий освещения и зрения, которые изначально не считались коммерчески выгодными."
	design_ids = list(
		"bright_helmet",
		"rld_mini",
		"photon_cannon",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_COMMON)

/datum/techweb_node/extreme_office
	id = TECHWEB_NODE_EXTREME_OFFICE
	display_name = "Расширенные Офисные Приложения"
	description = "Несколько самых умных сотрудников нашей лаборатории собрались в пятницу и повысили эффективность работы нашего офиса на 350 %. Вот как."
	design_ids = list(
		"mauna_mug",
		"rolling_table",
		"plasticducky",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_COMMON)

/datum/techweb_node/spec_eng
	id = TECHWEB_NODE_SPEC_ENG
	display_name = "Специализированная Инженерия"
	description = "Традиционная мудрость считает эти инженерные продукты «технически» безопасными, но слишком опасными, чтобы традиционно их одобрять."
	design_ids = list(
		"eng_gloves",
		"lava_rods",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)

/datum/techweb_node/aus_security
	id = TECHWEB_NODE_AUS_SECURITY
	display_name = "Протоколы Безопасности Австраликус"
	description = "Говорят, что безопасность в секторе Австраликус очень жесткая, поэтому мы взяли несколько примеров из их снаряжения. К счастью, в нашем секторе нет никаких признаков этих «медведей-дропперов»."
	design_ids = list(
		"pin_explorer",
		"stun_boomerang",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_SECURITY)

/datum/techweb_node/interrogation
	id = TECHWEB_NODE_INTERROGATION
	display_name = "Усовершенствованная Технология Допроса"
	description = "Сопоставив несколько рассекреченных документов прошлых диктаторских режимов, мы смогли разработать невероятно эффективное устройство для допроса. \
	Согласно галактическим законам, этические проблемы, связанные с потерей свободы воли, не распространяются на преступников."
	design_ids = list(
		"hypnochair",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_SECURITY)

/datum/techweb_node/sticky_advanced
	id = TECHWEB_NODE_STICKY_ADVANCED
	display_name = "Продвинутая Липкая Технология"
	description = "Хорошая шутка зашла слишком далеко? Глупости!"
	design_ids = list(
		"pointy_tape",
		"super_sticky_tape",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_COMMON)

/datum/techweb_node/tackle_advanced
	id = TECHWEB_NODE_TACKLE_ADVANCED
	display_name = "Передовая Технология Грейфера"
	description = "Нанотразен хотел бы напомнить своим научным сотрудникам, что никогда не допустимо \"гломить\" своих коллег, и дальнейшие \"научные испытания\" на эту тему \
	больше не будут приниматься в научных журналах компании."
	design_ids = list(
		"tackle_dolphin",
		"tackle_rocket",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_SECURITY)

/datum/techweb_node/mod_experimental
	id = TECHWEB_NODE_MOD_EXPERIMENTAL
	display_name = "Экспериментальные Модульные Костюмы"
	description = "Применение экспериментальности при создании МОДов позволило создать эти..."
	design_ids = list(
		"mod_disposal",
		"mod_joint_torsion",
		"mod_recycler",
		"mod_shooting",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_COMMON)

/datum/techweb_node/posisphere
	id = TECHWEB_NODE_POSITRONIC_SPHERE
	display_name = "Экспериментальный Сферический Позитронный Мозг"
	description = "Последние разработки по снижению затрат позволили нам разрезать позитронные мозговые кубы на вдвое более дешевые сферы. К сожалению, это также позволяет им перемещаться по лаборатории с помощью маневров качения."
	design_ids = list(
		"posisphere",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/donk_shell
	id = TECHWEB_NODE_DONK_PRODUCTS
	display_name = "Donk Co. Схемы Отказавших Изделий"
	description = "Мы не хотим знать, почему вы заполняете свои базы данных заведомо провальными продуктами вражеской корпорации. Это ваш выбор. Я просто хочу сказать, что не надо плакаться нам \
		когда выяснится, что вы скачали какую-то ужасную вредоносную программу, связанную с Donk-Pocket, которая украла ваш пароль от Starscape. Эти ублюдки из Donk Co. удалят вашего персонажа."
	design_ids = list(
		"donkshell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_SECURITY)
