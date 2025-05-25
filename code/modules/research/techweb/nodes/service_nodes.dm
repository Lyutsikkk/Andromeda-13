/datum/techweb_node/office_equip
	id = TECHWEB_NODE_OFFICE_EQUIP
	starting_node = TRUE
	display_name = "Офисное Оборудование"
	description = "Лучшие эргономичные офисные технологии Нанотрейзен обеспечивают продуктивную работу администраторов станции и соблюдение корпоративных правил - ведь даже в космосе бумажная работа никогда не прекращается."
	design_ids = list(
		"fax",
		"sec_pen",
		"handlabel",
		"roll",
		"universal_scanner",
		"desttagger",
		"packagewrap",
		"sticky_tape",
		"toner_large",
		"toner",
		"boxcutter",
		"bounced_radio",
		"radio_headset",
		"earmuffs",
		"recorder",
		"tape",
		"toy_balloon",
		"pet_carrier",
		"chisel",
		"spraycan",
		"camera_film",
		"camera",
		"razor",
		"bucket",
		"mop",
		"pushbroom",
		"normtrash",
		"wirebrush",
		"flashlight",
		"water_balloon",
		"ticket_machine",
		"radio_entertainment",
		"photocopier",
	)

/datum/techweb_node/sanitation
	id = TECHWEB_NODE_SANITATION
	display_name = "Продвинутые Санитарные Технологии"
	description = "Нанотразен - новейшая техника для уборки, которая следит за тем, чтобы станция оставалась чистой и без медведей."
	prereq_ids = list(TECHWEB_NODE_OFFICE_EQUIP)
	design_ids = list(
		"advmop",
		"light_replacer",
		"spraybottle",
		"paint_remover",
		"beartrap",
		"buffer",
		"vacuum",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	discount_experiments = list(/datum/experiment/scanning/random/janitor_trash = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE)

/datum/techweb_node/consoles
	id = TECHWEB_NODE_CONSOLES
	display_name = "Гражданские Консоли"
	description = "Удобные консоли для нетехнических членов экипажа, улучшающие коммуникацию и доступ к важной информации о станции."
	prereq_ids = list(TECHWEB_NODE_OFFICE_EQUIP)
	design_ids = list(
		"comconsole",
		"automated_announcement",
		"cargo",
		"cargorequest",
		"med_data",
		"crewconsole",
		"bankmachine",
		"account_console",
		"idcard",
		"c-reader",
		"libraryconsole",
		"libraryscanner",
		"bookbinder",
		"barcode_scanner",
		"vendor",
		"custom_vendor_refill",
		"bounty_pad_control",
		"bounty_pad",
		"digital_clock_frame",
		"telescreen_research",
		"telescreen_ordnance",
		"telescreen_interrogation",
		"telescreen_prison",
		"telescreen_bar",
		"telescreen_entertainment",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE)

/datum/techweb_node/gaming
	id = TECHWEB_NODE_GAMING
	display_name = "Игры"
	description = "Для бездельников на станции."
	prereq_ids = list(TECHWEB_NODE_CONSOLES)
	design_ids = list(
		"arcade_battle",
		"arcade_orion",
		"slotmachine",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	discount_experiments = list(/datum/experiment/physical/arcade_winner = TECHWEB_TIER_2_POINTS)

// Kitchen root node
/datum/techweb_node/cafeteria_equip
	id = TECHWEB_NODE_CAFETERIA_EQUIP
	starting_node = TRUE
	display_name = "Оборудование для Кафетериев"
	description = "Когда стандартная еда в тюбиках перестает удовлетворять аппетит экипажа станции... Но почему?"
	design_ids = list(
		"griddle",
		"microwave",
		"bowl",
		"plate",
		"oven_tray",
		"servingtray",
		"tongs",
		"spoon",
		"fork",
		"kitchen_knife",
		"plastic_spoon",
		"plastic_fork",
		"plastic_knife",
		"shaker",
		"drinking_glass",
		"shot_glass",
		"coffee_cartridge",
		"coffeemaker",
		"coffeepot",
		"syrup_bottle",
		"foodtray",
		"restaurant_portal",
	)

/datum/techweb_node/food_proc
	id = TECHWEB_NODE_FOOD_PROC
	display_name = "Пищевая Промышленность"
	description = "Кухонная техника высшего класса от Нанотрейзен, созданная для того, чтобы экипаж был сыт и доволен."
	prereq_ids = list(TECHWEB_NODE_CAFETERIA_EQUIP)
	design_ids = list(
		"deepfryer",
		"oven",
		"stove",
		"range",
		"souppot",
		"processor",
		"gibber",
		"monkey_recycler",
		"reagentgrinder",
		"microwave_engineering",
		"smartfridge",
		"dehydrator",
		"sheetifier",
		"fat_sucker",
		"dish_drive",
		"roastingstick",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE)

// Fishing root node
/datum/techweb_node/fishing_equip
	id = TECHWEB_NODE_FISHING_EQUIP
	starting_node = TRUE
	display_name = "Рыболовное Снаряжение"
	description = "Базовые рыболовные снасти, адаптированные для условий космической станции, идеально подходят для внеземных водных развлечений."
	design_ids = list(
		"fishing_portal_generator",
		"fishing_rod",
		"fish_case",
		"aquarium_kit",
	)

/datum/techweb_node/fishing_equip_adv
	id = TECHWEB_NODE_FISHING_EQUIP_ADV
	display_name = "Продвинутые Рыболовные Инструменты"
	description = "Продолжаем развивать рыболовные технологии, внедряя самые современные возможности в космическую рыбалку. Только не пробуйте это на космических карпах..."
	prereq_ids = list(TECHWEB_NODE_FISHING_EQUIP)
	design_ids = list(
		"fishing_rod_tech",
		"fishing_gloves",
		"mod_fishing",
		"stabilized_hook",
		"auto_reel",
		"fish_analyzer",
		"bluespace_fish_case",
		"bluespace_fish_tank_kit",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	required_experiments = list(/datum/experiment/scanning/fish)

/datum/techweb_node/marine_util
	id = TECHWEB_NODE_MARINE_UTIL
	display_name = "Морские Утилиты"
	description = "На рыбок приятно смотреть, но их можно использовать."
	prereq_ids = list(TECHWEB_NODE_FISHING_EQUIP_ADV)
	design_ids = list(
		"bioelec_gen",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	// only available if you've done the first fishing experiment (thus unlocking fishing tech), but not a strict requirement to get the tech
	discount_experiments = list(/datum/experiment/scanning/fish/second = TECHWEB_TIER_3_POINTS)
