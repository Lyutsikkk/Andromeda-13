/datum/techweb_node/atmos
	id = TECHWEB_NODE_ATMOS
	starting_node = TRUE
	display_name = "Атмосферика"
	description = "Поддержание в рабочем состоянии воздушных и смежных систем жизнеобеспечения станции."
	design_ids = list(
		"atmos_control",
		"atmosalerts",
		"thermomachine",
		"space_heater",
		"scrubber",
		"generic_tank",
		"oxygen_tank",
		"plasma_tank",
		"plasmaman_tank_belt",
		"plasmarefiller",
		"extinguisher",
		"pocketfireextinguisher",
		"gas_filter",
		"plasmaman_gas_filter",
		"analyzer",
		"pipe_painter",
	)

/datum/techweb_node/gas_compression
	id = TECHWEB_NODE_GAS_COMPRESSION
	display_name = "Компрессия Газа"
	description = "Газы под высоким давлением способны раскрыть огромные энергетические возможности."
	prereq_ids = list(TECHWEB_NODE_ATMOS)
	design_ids = list(
		"tank_compressor",
		"pump",
		"emergency_oxygen",
		"emergency_oxygen_engi",
		"power_turbine_console",
		"turbine_part_compressor",
		"turbine_part_rotor",
		"turbine_part_stator",
		"turbine_compressor",
		"turbine_rotor",
		"turbine_stator",
		"atmos_thermal",
		"pneumatic_seal",
		"large_welding_tool",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	experiments_to_unlock = list(
		/datum/experiment/ordnance/gaseous/plasma,
		/datum/experiment/ordnance/gaseous/nitrous_oxide,
		/datum/experiment/ordnance/gaseous/bz,
		/datum/experiment/ordnance/gaseous/noblium,
	)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)

/datum/techweb_node/plasma_control
	id = TECHWEB_NODE_PLASMA_CONTROL
	display_name = "Контролируемая Плазма"
	description = "Эксперименты с газами высокого давления и электричеством, приводящие к кристаллизации и контролируемым плазменным реакциям."
	prereq_ids = list(TECHWEB_NODE_GAS_COMPRESSION, TECHWEB_NODE_ENERGY_MANIPULATION)
	design_ids = list(
		"electrolyzer",
		"pipe_scrubber",
		"pacman",
		"mech_generator",
		"plasmacutter",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	discount_experiments = list(/datum/experiment/ordnance/gaseous/plasma = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)

/datum/techweb_node/fusion
	id = TECHWEB_NODE_FUSION
	display_name = "ТРГ"
	description = "Исследование технологии термоядерного реактора для достижения устойчивого и эффективного производства энергии с помощью контролируемых плазменных реакций с участием инертных газов."
	prereq_ids = list(TECHWEB_NODE_PLASMA_CONTROL)
	design_ids = list(
		"HFR_core",
		"HFR_corner",
		"HFR_fuel_input",
		"HFR_interface",
		"HFR_moderator_input",
		"HFR_waste_output",
		"adv_fire_extinguisher",
		"bolter_wrench",
		"rpd_loaded",
		"engine_goggles",
		"crystallizer",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	discount_experiments = list(/datum/experiment/ordnance/gaseous/nitrous_oxide = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)

/datum/techweb_node/exp_tools
	id = TECHWEB_NODE_EXP_TOOLS
	display_name = "Экспериментальные Инструменты"
	description = "Повышает функциональность и универсальность инструментов станции."
	prereq_ids = list(TECHWEB_NODE_FUSION)
	design_ids = list(
		"flatpacker",
		"handdrill",
		"exwelder",
		"jawsoflife",
		"rangedanalyzer",
		"rtd_loaded",
		"mech_rcd",
		"rcd_loaded",
		"rcd_ammo",
		"weldingmask",
		"magboots",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	discount_experiments = list(/datum/experiment/ordnance/gaseous/bz = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)

/datum/techweb_node/rcd_upgrade
	id = TECHWEB_NODE_RCD_UPGRADE
	display_name = "Модернизация Устройств Быстрого Строительства"
	description = "Новые конструкции и усовершенствования для RCD и RPD."
	prereq_ids = list(TECHWEB_NODE_EXP_TOOLS, TECHWEB_NODE_PARTS_BLUESPACE)
	design_ids = list(
		"rcd_upgrade_silo_link",
		"rcd_upgrade_anti_interrupt",
		"rcd_upgrade_cooling",
		"rcd_upgrade_frames",
		"rcd_upgrade_furnishing",
		"rcd_upgrade_simple_circuits",
		"rpd_upgrade_unwrench",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	discount_experiments = list(/datum/experiment/ordnance/gaseous/noblium = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)
