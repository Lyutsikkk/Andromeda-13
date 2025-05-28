/datum/storyteller/low
	name = "Rabotka (Low)"
	desc = "По сравнению с другими рассказчиками, «Низкий Хаос» будет светлым на события, особенно на те, которые связаны с боем, разрушением или хаосом. \
	Наименее суетливый рассказчик из всех, но при этом не лишенный некоторой остроты. Лучше всего подходит для раундов, ориентированных на RP, с небольшим количеством событий."
	welcome_text = "Работка с говнюками."
	antag_divisor = 16

	guarantees_roundstart_crewset = FALSE
	tag_multipliers = list(
		TAG_COMBAT = 0.3,
		TAG_CHAOTIC = 0.1,
		TAG_DESTRUCTIVE = 0.3,
		TAG_LOW = 1,
		TAG_MEDIUM = 0,
		TAG_HIGH = 0
	)

	track_data = /datum/storyteller_data/tracks/low
/datum/storyteller_data/tracks/low
	threshold_mundane = 1200
	threshold_moderate = 1800
	threshold_major = 8000
	threshold_crewset = 1800
	threshold_ghostset = 7000
