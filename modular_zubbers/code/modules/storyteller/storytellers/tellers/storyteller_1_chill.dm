/datum/storyteller/chill
	name = "Chill (Low Chaos)"
	desc = "По сравнению с другими сказочниками, «Озноб» будет мало освещать события, особенно те, которые связаны с боем, разрушением или хаосом. \
	Наименее суетливый из всех рассказчиков, но при этом не лишенный некоторой остроты. Лучше всего подходит для раундов, ориентированных на RP, с небольшим количеством событий."
	welcome_text = "Если вы проголосуете за этого сказочника на Ice Box, у вас нет оригинальности."

	storyteller_type = STORYTELLER_TYPE_CALM
	track_data = /datum/storyteller_data/tracks/light
	guarantees_roundstart_crewset = FALSE
	antag_divisor = 16
	tag_multipliers = list(
		TAG_COMBAT = 0.5,
		TAG_DESTRUCTIVE = 0.3,
		TAG_CHAOTIC = 0.1,
		TAG_BIG_THREE = 0,
	)

/datum/storyteller_data/tracks/light
	threshold_mundane = 1400
	threshold_moderate = 2400
	threshold_major = 10000
	threshold_crewset = 3200
	threshold_ghostset = 8000
