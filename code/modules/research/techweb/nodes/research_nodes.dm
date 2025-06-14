/datum/techweb_node/fundamental_sci
	id = TECHWEB_NODE_FUNDIMENTAL_SCI
	starting_node = TRUE
	display_name = "Фундаментальная Наука"
	description = "Закладывает основы научного понимания, прокладывая путь к более глубоким исследованиям и теоретическим изысканиям."
	design_ids = list(
		"rdserver",
		"rdservercontrol",
		"rdconsole",
		"tech_disk",
		"doppler_array",
		"experimentor",
		"destructive_analyzer",
		"destructive_scanner",
		"experi_scanner",
		"laptop",
		"portadrive_basic",
		"portadrive_advanced",
		"portadrive_super",
	)

/datum/techweb_node/bluespace_theory
	id = TECHWEB_NODE_BLUESPACE_THEORY
	display_name = "Теория Блюспейс"
	description = "Базовые исследования таинственного альтернативного измерения, известного как блюспейс."
	prereq_ids = list(TECHWEB_NODE_FUNDIMENTAL_SCI)
	design_ids = list(
		"bluespace_crystal",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/applied_bluespace
	id = TECHWEB_NODE_APPLIED_BLUESPACE
	display_name = "Прикладное Исследование Блюспейса"
	description = "Благодаря более глубокому пониманию динамики блюспейс, можно разрабатывать сложные приложения и технологии, используя данные анализа голубых кристаллов."
	prereq_ids = list(TECHWEB_NODE_BLUESPACE_THEORY)
	design_ids = list(
		"ore_silo",
		"minerbag_holding",
		"plumbing_receiver",
		"bluespacebeaker",
		"adv_watering_can",
		"bluespace_coffeepot",
		"bluespacesyringe",
		"blutrash",
		"light_replacer_blue",
		"bluespacebodybag",
		"gigabeacon",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	discount_experiments = list(/datum/experiment/scanning/points/bluespace_crystal = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SERVICE, RADIO_CHANNEL_SUPPLY)

/datum/techweb_node/bluespace_travel
	id = TECHWEB_NODE_BLUESPACE_TRAVEL
	display_name = "Блюспейс Скачёк"
	description = "Способствуйте развитию методов телепортации, основанных на принципах блюспейс, для революционного повышения эффективности логистики."
	prereq_ids = list(TECHWEB_NODE_APPLIED_BLUESPACE)
	design_ids = list(
		"teleconsole",
		"tele_station",
		"tele_hub",
		"launchpad_console",
		"quantumpad",
		"launchpad",
		"bluespace_pod",
		"quantum_keycard",
		"swapper",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/anomaly_research
	id = TECHWEB_NODE_ANOMALY_RESEARCH
	display_name = "Исследование Аномалий"
	description = "Углубляясь в изучение загадочных аномалий, он исследует методы совершенствования и использования их непредсказуемой энергии."
	prereq_ids = list(TECHWEB_NODE_APPLIED_BLUESPACE)
	design_ids = list(
		"anomaly_refinery",
		"anomaly_neutralizer",
		"reactive_armour",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/anomaly_shells
	id = TECHWEB_NODE_ANOMALY_SHELLS
	display_name = "Усовершенствованные оболочки аномалий"
	description = "Новые оболочки, разработанные для использования ядер аномалий, максимально раскрывают их потенциал инновационными способами."
	prereq_ids = list(TECHWEB_NODE_ANOMALY_RESEARCH)
	design_ids = list(
		"bag_holding",
		"cybernetic_heart_anomalock",
		"wormholeprojector",
		"gravitygun",
		"polymorph_belt",
		"perceptomatrix",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	discount_experiments = list(/datum/experiment/scanning/points/anomalies = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)
