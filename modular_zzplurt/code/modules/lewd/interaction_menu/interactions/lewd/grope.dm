// Действия с попкой

/// ADD ANDROMEDA-13 (@ms_kira): Перевод, масштабное дополнение ЕРП контента.
/datum/interaction/lewd/grope_ass
	name = "Потрогать задницу"
	description = "Потрогай чью-нибудь задницу или возьмись за неё. (Это заводит)"
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	message = list(
		"Смачно лапает %TARGET% за задницу.",
		"Пошлепывая облапывает булки %TARGET%.",
		"Тискает попку %TARGET%.",
		"Раздвигает булки %TARGET% в стороны.",
		"Играется с попкой %TARGET% взяв ту в свои руки.",
		"Жамкает попень %TARGET% в порыве страсти.",
		"Нежно проходится руками по попе %TARGET%.",
		"Наглаживает попеньку %TARGET% в своих руках.",
		"Предельно нагло сжимает булки %TARGET%.",
		"Неаккуратно разводит булки %TARGET% в стороны.",
		"Брутально хватается за булку %TARGET% начиная ту жать.",
		"Гладит попку %TARGET% слегка давя на неё.",
		"Игриво водит руками булки %TARGET%.",
		"Игриво шлепнувши, обхватывает жопку %TARGET% массируя её.",
		"Сжимает булочки %TARGET% в своих руках.",
		"Ласково поглаживает попку %TARGET%.",
		"Хватает %TARGET% за попку и сжимает её."
	)
	user_messages = list(
		"Вы чувствуете мягкую попку %TARGET% в своих руках.",
		"Вы игриво лапаете попку %TARGET% наслаждаясь упругостью.",
		"Вы разводите мягкие булочки %TARGET% в стороны, сдавливая их.",
		"Вы наслаждаетесь неплохой задницей %TARGET%.",
		"Вы чувственно сжимаете задницу %TARGET% испытывая её упругость.",
		"Вы бесцеремонно жамкаете за попу %TARGET% и довольно улыбаетесь.",
		"Упругость попы %TARGET% удобно ощущается в вашей ладони.",
		"Вы сжимаете пухлый опрятный зад %TARGET%."
	)
	target_messages = list(
		"Вы чувствуете, как рука %USER% ощупывает вашу мягкую попку.",
		"Вы игриво дрожите, когда %USER% проверяет упругость вашей попы.",
		"Вы ощущаете как вашу попу разводят сжимающие руки %USER% задрожав в момент.",
		"Вы наслажденно дрожите, когда %USER% нежно сжимает вашу попу.",
		"Вы чувственно дрожите, в момент как %USER% испытывает вашу попень на упругость.",
		"Вы слегка сгинаетесь, ведь %USER% грубо и бесцеремонно лапает вашу жопку.",
		"Вы чувствуете как пальчики %USER% сжимают вашу попку.",
		"Тепло ладони %USER% легко ощущается на вашей заднице."
	)
	sound_range = 1
	sound_use = FALSE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 3
	target_arousal = 3
