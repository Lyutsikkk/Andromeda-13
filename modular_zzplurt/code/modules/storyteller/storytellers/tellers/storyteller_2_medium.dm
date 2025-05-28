/datum/storyteller/medium
	name = "Sueta (Medium)"
	desc = "Средний Хаос - это рассказчик по умолчанию и точка сравнения для всех остальных рассказчиков. \
	События происходят чаще, чем в «Низком хаосе», но реже, чем в «Высоком хаосе». Лучше всего подходит для среднего, разнообразного опыта."
	welcome_text = "Вот бы забить тебя и кинуть в техи..."
	antag_divisor = 8

	tag_multipliers = list(
		TAG_COMBAT = 0.3,
		TAG_CHAOTIC = 0.1,
		TAG_DESTRUCTIVE = 0.3,
		TAG_LOW = 1,
		TAG_MEDIUM = 1,
		TAG_HIGH = 0
	)

	track_data = /datum/storyteller_data/tracks/medium
/datum/storyteller_data/tracks/medium
	threshold_mundane = 1000
	threshold_moderate = 1300
	threshold_major = 6000
	threshold_crewset = 1300
	threshold_ghostset = 5000
