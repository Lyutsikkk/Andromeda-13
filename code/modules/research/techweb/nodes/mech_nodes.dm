/datum/techweb_node/mech_assembly
	id = TECHWEB_NODE_MECH_ASSEMBLY
	starting_node = TRUE
	display_name = "Сборка Экзокостюма"
	description = "Разработка механических экзокостюмов, предназначенных для борьбы с искусственной гравитацией при транспортировке грузов."
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"mechapower",
		"mech_recharger",
		"ripley_chassis",
		"ripley_torso",
		"ripley_left_arm",
		"ripley_right_arm",
		"ripley_left_leg",
		"ripley_right_leg",
		"ripley_main",
		"ripley_peri",
		"mech_hydraulic_clamp",
	)

/datum/techweb_node/mech_equipment
	id = TECHWEB_NODE_MECH_EQUIPMENT
	display_name = "Экспедиционное Оборудование"
	description = "Специализированное снаряжение для экзокостюмов, предназначенное для навигации в космосе и на небесных телах, обеспечивает долговечность и функциональность в самых суровых условиях."
	prereq_ids = list(TECHWEB_NODE_MECH_ASSEMBLY)
	design_ids = list(
		"mechacontrol",
		"botpad",
		"botpad_remote",
		"ripleyupgrade",
		"mech_air_tank",
		"mech_thrusters",
		"mech_extinguisher",
		"mecha_camera",
		"mecha_tracking",
		"mech_radio",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/mech_clown
	id = TECHWEB_NODE_MECH_CLOWN
	display_name = "Веселые Роботы"
	description = "Запитаны смехом."
	prereq_ids = list(TECHWEB_NODE_MECH_ASSEMBLY)
	design_ids = list(
		"honk_chassis",
		"honk_torso",
		"honk_head",
		"honk_left_arm",
		"honk_right_arm",
		"honk_left_leg",
		"honk_right_leg",
		"honker_main",
		"honker_peri",
		"honker_targ",
		"mech_banana_mortar",
		"mech_honker",
		"mech_mousetrap_mortar",
		"mech_punching_face",
		"borg_transform_clown",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY) //The dread upon security when they hear this...

/datum/techweb_node/mech_medical
	id = TECHWEB_NODE_MECH_MEDICAL
	display_name = "Медицинский Экзокостюм"
	description = "Передовой роботизированный аппарат, оснащенный шприц-пистолетами и лечебными лучами, революционизирующий медицинскую помощь в опасных условиях."
	prereq_ids = list(TECHWEB_NODE_MECH_ASSEMBLY, TECHWEB_NODE_CHEM_SYNTHESIS)
	design_ids = list(
		"odysseus_chassis",
		"odysseus_torso",
		"odysseus_head",
		"odysseus_left_arm",
		"odysseus_right_arm",
		"odysseus_left_leg",
		"odysseus_right_leg",
		"odysseus_main",
		"odysseus_peri",
		"mech_medi_beam",
		"mech_syringe_gun",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)

/datum/techweb_node/mech_mining
	id = TECHWEB_NODE_MECH_MINING
	display_name = "Шахтёрский Экзокостюм"
	description = "Прочный экзокостюм, созданный для противостояния лаве и штормам, для непрерывной добычи полезных ископаемых вне станции."
	prereq_ids = list(TECHWEB_NODE_MECH_EQUIPMENT, TECHWEB_NODE_MINING)
	design_ids = list(
		"clarke_chassis",
		"clarke_torso",
		"clarke_head",
		"clarke_left_arm",
		"clarke_right_arm",
		"clarke_main",
		"clarke_peri",
		"mecha_kineticgun",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SUPPLY)

/datum/techweb_node/mech_combat
	id = TECHWEB_NODE_MECH_COMBAT
	display_name = "Боевой Экзокостюм"
	description = "Модульные обновления брони и специализированное оборудование для защитных экзокостюмов."
	prereq_ids = list(TECHWEB_NODE_MECH_EQUIPMENT)
	design_ids = list(
		"mech_ccw_armor",
		"mech_proj_armor",
		"mech_emp_armor",
		"paddyupgrade",
		"mech_hydraulic_claw",
		"mech_disabler",
		"mech_repair_droid",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	required_experiments = list(/datum/experiment/scanning/random/mecha_equipped_scan)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/mech_assault
	id = TECHWEB_NODE_MECH_ASSAULT
	display_name = "Штурмовой Экзокостюм"
	description = "Тяжелые боевые экзокостюмы, обладающие прочной броней, но жертвующие скоростью ради повышенной прочности."
	prereq_ids = list(TECHWEB_NODE_MECH_COMBAT)
	design_ids = list(
		"durand_armor",
		"durand_chassis",
		"durand_torso",
		"durand_head",
		"durand_left_arm",
		"durand_right_arm",
		"durand_left_leg",
		"durand_right_leg",
		"durand_main",
		"durand_peri",
		"durand_targ",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/mech_light
	id = TECHWEB_NODE_MECH_LIGHT
	display_name = "Лёгкий Боевой Экзокостюм"
	description = "Маневренные боевые экзокостюмы, оснащенные функцией разгона для временного увеличения скорости, в которых приоритет отдается скорости, а не прочности на поле боя."
	prereq_ids = list(TECHWEB_NODE_MECH_COMBAT)
	design_ids = list(
		"gygax_armor",
		"gygax_chassis",
		"gygax_torso",
		"gygax_head",
		"gygax_left_arm",
		"gygax_right_arm",
		"gygax_left_leg",
		"gygax_right_leg",
		"gygax_main",
		"gygax_peri",
		"gygax_targ",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/mech_heavy
	id = TECHWEB_NODE_MECH_HEAVY
	display_name = "Тяжёлый Экзокостюм"
	description = "Передовое тяжелое механизированное подразделение с возможностью двойного пилотирования, разработанное для обеспечения надежной работы на поле боя и повышения тактической универсальности."
	prereq_ids = list(TECHWEB_NODE_MECH_ASSAULT)
	design_ids = list(
		"savannah_ivanov_armor",
		"savannah_ivanov_chassis",
		"savannah_ivanov_torso",
		"savannah_ivanov_head",
		"savannah_ivanov_left_arm",
		"savannah_ivanov_right_arm",
		"savannah_ivanov_left_leg",
		"savannah_ivanov_right_leg",
		"savannah_ivanov_main",
		"savannah_ivanov_peri",
		"savannah_ivanov_targ",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/mech_infiltrator
	id = TECHWEB_NODE_MECH_INFILTRATOR
	display_name = "Проникаэщий Экзокостюм"
	description = "Продвинутый экзокостюм с фазовыми возможностями, позволяющими ему перемещаться сквозь стены и препятствия, идеально подходит для тайных и специальных операций."
	prereq_ids = list(TECHWEB_NODE_MECH_LIGHT, TECHWEB_NODE_ANOMALY_RESEARCH)
	design_ids = list(
		"phazon_armor",
		"phazon_chassis",
		"phazon_torso",
		"phazon_head",
		"phazon_left_arm",
		"phazon_right_arm",
		"phazon_left_leg",
		"phazon_right_leg",
		"phazon_main",
		"phazon_peri",
		"phazon_targ",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/justice
	id = "mecha_justice"
	display_name = "Экзокостюм: Правосудие"
	description = "Дизайн экзокостюма правосудия"
	design_ids = list(
		"justice_armor",
		"justice_chassis",
		"justice_left_arm",
		"justice_left_leg",
		"justice_right_arm",
		"justice_right_leg",
		"justice_torso",
	)
	hidden = TRUE
	illegal_mech_node = TRUE

/datum/techweb_node/mech_energy_guns
	id = TECHWEB_NODE_MECH_ENERGY_GUNS
	display_name = "Энергетическое Оружие Экзокостюма"
	description = "Масштабные версии электрического оружия, оптимизированные для использования в экзокостюме."
	prereq_ids = list(TECHWEB_NODE_MECH_COMBAT, TECHWEB_NODE_ELECTRIC_WEAPONS)
	design_ids = list(
		"mech_laser",
		"mech_laser_heavy",
		"mech_ion",
		"mech_tesla",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	discount_experiments = list(/datum/experiment/scanning/random/mecha_damage_scan = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/mech_firearms
	id = TECHWEB_NODE_MECH_FIREARMS
	display_name = "Вооружённый Экзокостюм"
	description = "Навесное баллистическое оружие, повышающее боевые возможности механизированных подразделений."
	prereq_ids = list(TECHWEB_NODE_MECH_ENERGY_GUNS, TECHWEB_NODE_EXOTIC_AMMO)
	design_ids = list(
		"mech_lmg",
		"mech_lmg_ammo",
		"mech_scattershot",
		"mech_scattershot_ammo",
		"mech_carbine",
		"mech_carbine_ammo",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/mech_heavy_arms
	id = TECHWEB_NODE_MECH_HEAVY_ARMS
	display_name = "Тяжёлый Вооружённый Экзокостюм"
	description = "Ударное оружие, встроенное в мехи, оптимизировано для максимальной огневой мощи."
	prereq_ids = list(TECHWEB_NODE_MECH_HEAVY, TECHWEB_NODE_EXOTIC_AMMO)
	design_ids = list(
		"clusterbang_launcher",
		"clusterbang_launcher_ammo",
		"mech_grenade_launcher",
		"mech_grenade_launcher_ammo",
		"mech_missile_rack",
		"mech_missile_rack_ammo",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/mech_equip_bluespace
	id = TECHWEB_NODE_MECH_EQUIP_BLUESPACE
	display_name = "Блюспейс Оборудование Экзокостюма"
	description = "Массив оборудования, созданный с помощью блюспейс, обеспечивает непревзойденную мобильность и практичность."
	prereq_ids = list(TECHWEB_NODE_MECH_INFILTRATOR, TECHWEB_NODE_BLUESPACE_TRAVEL)
	design_ids = list(
		"mech_gravcatapult",
		"mech_teleporter",
		"mech_wormhole_gen",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)
