/datum/storyteller/gamer
	name = "Gamer (High Chaos)"
	desc = "Gamer будет стараться создавать наиболее боевые события, стараясь избегать чисто разрушительных. \
	Более боевые и частые события, чем по умолчанию, но, в отличие от клоуна, старается не создавать адский сдвиг."
	welcome_text = "Добро пожаловать в «Геймерский рассказчик». Теперь на 50 % больше помощи!"

	storyteller_type = STORYTELLER_TYPE_INTENSE
	track_data = /datum/storyteller_data/tracks/heavy
	guarantees_roundstart_crewset = TRUE
	antag_divisor = 5
	tag_multipliers = list(
		TAG_COMBAT = 1.5,
		TAG_DESTRUCTIVE = 0.7,
		TAG_CHAOTIC = 1.3,
		TAG_BIG_THREE = 1.1,
	)

/datum/storyteller_data/tracks/heavy
	threshold_moderate = 1300
	threshold_major = 4000
	threshold_ghostset = 6000
