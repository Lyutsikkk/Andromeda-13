/datum/storyteller/high
	name = "ROBASTER (HARD)"
	desc = "High Chaos будет стараться создавать наиболее боевые события, стараясь избегать чисто разрушительных. \
	Более боевые и частые события, чем по умолчанию, но, в отличие от клоуна, старается не создавать адский сдвиг."
	welcome_text = "Эта смена станет твоей последней!"
	antag_divisor = 4

	tag_multipliers = list(
		TAG_COMBAT = 1.5,
		TAG_CHAOTIC = 1.3,
		TAG_DESTRUCTIVE = 0.7,
		TAG_LOW = 1,
		TAG_MEDIUM = 1,
		TAG_HIGH = 1
	)

	track_data = /datum/storyteller_data/tracks/high
/datum/storyteller_data/tracks/high
	threshold_mundane = 600
	threshold_moderate = 900
	threshold_major = 4000
	threshold_crewset = 900
	threshold_ghostset = 3500
