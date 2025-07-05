/datum/storyteller/extended
	name = "Rassos (No chaos)"
	desc = "Расширение - это отсутствие Рассказчика. Он не породит ни одного события и не запустит ни одного антагониста. Лучше всего подходит для раундов, где население настолько мало, что даже мирные рассказчики не могут быть достаточно низкими."
	welcome_text = "Как это дормы уже переполнены? Смена еще даже не началась."
	disable_distribution = TRUE
	population_max = 40
	antag_divisor = 32
	storyteller_type = STORYTELLER_TYPE_CALM
	votable = FALSE
	display_setting = STORYTELLER_DISPLAY_NEVER_SECRET
