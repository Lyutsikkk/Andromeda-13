////////////////////////////////////////////DONK POCKETS////////////////////////////////////////////

/obj/item/food/donkpocket
	name = "\improper Донк-донкпокет"
	desc = "Лучшая еда для бывалого предателя."
	icon_state = "donkpocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("umami" = 2, "dough" = 2, "laziness" = 1)
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

	/// What type of donk pocket we're warmed into via baking or microwaving.
	var/warm_type = /obj/item/food/donkpocket/warm
	/// The lower end for how long it takes to bake
	var/baking_time_short = 25 SECONDS
	/// The upper end for how long it takes to bake
	var/baking_time_long = 30 SECONDS
	/// The reagents added when microwaved. Needed since microwaving ignores food_reagents
	var/static/list/added_reagents = list(/datum/reagent/medicine/omnizine = 6)
	/// The reagents that most child types add when microwaved. Needed because you can't override static lists.
	var/static/list/child_added_reagents = list(/datum/reagent/medicine/omnizine = 2)

/obj/item/food/donkpocket/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, added_reagents)

/obj/item/food/donkpocket/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, added_reagents)

/obj/item/food/donkpocket/warm
	name = "Теплый Донк-донкпокет"
	desc = "Горячее блюдо, которое по вкусу даже опытному предателю."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 6,
	)
	tastes = list("umami" = 2, "dough" = 2, "laziness" = 1)
	foodtypes = GRAIN

	// Warmed donk pockets will burn if you leave them in the oven or microwave.
	warm_type = /obj/item/food/badrecipe
	baking_time_short = 10 SECONDS
	baking_time_long = 15 SECONDS

/obj/item/food/donkpocket/homemade
	foodtypes = MEAT|GRAIN
	tastes = list("meat" = 2, "dough" = 2, "comfiness" = 1)
	warm_type = /obj/item/food/donkpocket/warm/homemade

/obj/item/food/donkpocket/warm/homemade
	foodtypes = MEAT|GRAIN
	tastes = list("meat" = 2, "dough" = 2, "comfiness" = 1)

/obj/item/food/donkpocket/dank
	name = "\improper Промозглый донкпокет"
	desc = "Идеальное блюдо для опытного ботаника."
	icon_state = "dankpocket"
	food_reagents = list(
		/datum/reagent/toxin/lipolicide = 3,
		/datum/reagent/drug/space_drugs = 3,
		/datum/reagent/consumable/nutriment = 4,
	)
	tastes = list("weed" = 2, "dough" = 2)
	foodtypes = GRAIN|VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2
	warm_type = /obj/item/food/donkpocket/warm/dank

/obj/item/food/donkpocket/dank/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, child_added_reagents)

/obj/item/food/donkpocket/dank/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, child_added_reagents)

/obj/item/food/donkpocket/warm/dank
	name = "Теплый Промозглый донкпокет"
	desc = "Идеальное блюдо для опытного ботаника."
	icon_state = "dankpocket"
	food_reagents = list(
		/datum/reagent/toxin/lipolicide = 3,
		/datum/reagent/drug/space_drugs = 3,
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/medicine/omnizine = 2,
	)
	tastes = list("weed" = 2, "dough" = 2)
	foodtypes = GRAIN|VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/donkpocket/spicy
	name = "\improper Пикантный донкпокет"
	desc = "Классическая закуска, получившая пикантный вкус благодаря термической обработке."
	icon_state = "donkpocketspicy"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/capsaicin = 2,
	)
	tastes = list("umami" = 2, "dough" = 2, "spice" = 1)
	foodtypes = VEGETABLES|GRAIN
	warm_type = /obj/item/food/donkpocket/warm/spicy

/obj/item/food/donkpocket/spicy/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, child_added_reagents)

/obj/item/food/donkpocket/spicy/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, child_added_reagents)

/obj/item/food/donkpocket/warm/spicy
	name = "Теплый Пикантный донкпокет"
	desc = "Классическая закуска, теперь, возможно, слишком острая."
	icon_state = "donkpocketspicy"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/capsaicin = 5,
	)
	tastes = list("umami" = 2, "dough" = 2, "weird spices" = 2)
	foodtypes = VEGETABLES|GRAIN

/obj/item/food/donkpocket/spicy/homemade
	tastes = list("meat" = 2, "dough" = 2, "spice" = 1)
	foodtypes = MEAT|VEGETABLES|GRAIN
	warm_type = /obj/item/food/donkpocket/warm/spicy/homemade

/obj/item/food/donkpocket/warm/spicy/homemade
	tastes = list("meat" = 2, "dough" = 2, "weird spices" = 1)
	foodtypes = MEAT|VEGETABLES|GRAIN

/obj/item/food/donkpocket/teriyaki
	name = "\improper Терияки-донкпокет"
	desc = "Классический привокзальный перекус в восточноазиатском стиле."
	icon_state = "donkpocketteriyaki"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/soysauce = 2,
	)
	tastes = list("umami" = 2, "dough" = 2, "soy sauce" = 2)
	foodtypes = GRAIN
	warm_type = /obj/item/food/donkpocket/warm/teriyaki

/obj/item/food/donkpocket/teriyaki/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, child_added_reagents)

/obj/item/food/donkpocket/teriyaki/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, child_added_reagents)

/obj/item/food/donkpocket/warm/teriyaki
	name = "Теплый Терияки-донкпокет"
	desc = "Классический привокзальный перекус в восточноазиатском стиле, приготовленный горячим на пару."
	icon_state = "donkpocketteriyaki"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/soysauce = 2,
	)
	tastes = list("umami" = 2, "dough" = 2, "soy sauce" = 2)
	foodtypes = GRAIN

/obj/item/food/donkpocket/teriyaki/homemade
	tastes = list("meat" = 2, "dough" = 2, "soy sauce" = 2)
	foodtypes = MEAT|GRAIN
	warm_type = /obj/item/food/donkpocket/warm/teriyaki/homemade

/obj/item/food/donkpocket/warm/teriyaki/homemade
	tastes = list("meat" = 2, "dough" = 2, "soy sauce" = 2)
	foodtypes = MEAT|GRAIN

/obj/item/food/donkpocket/pizza
	name = "\improper Пиццный-донкпоке"
	desc = "Вкусный, сырный и на удивление сытный."
	icon_state = "donkpocketpizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/tomatojuice = 2,
	)
	tastes = list("tomato" = 2, "dough" = 2, "cheese"= 2)
	foodtypes = VEGETABLES|GRAIN|DAIRY
	warm_type = /obj/item/food/donkpocket/warm/pizza

/obj/item/food/donkpocket/pizza/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, child_added_reagents)

/obj/item/food/donkpocket/pizza/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, child_added_reagents)

/obj/item/food/donkpocket/warm/pizza
	name = "Теплый Пиццный-донкпокет"
	desc = "Вкусный, сырный, а в горячем виде еще вкуснее."
	icon_state = "donkpocketpizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/tomatojuice = 2,
	)
	tastes = list("tomato" = 2, "dough" = 2, "melty cheese"= 2)
	foodtypes = VEGETABLES|GRAIN|DAIRY

/obj/item/food/donkpocket/honk
	name = "\improper Хонк-донкпокет"
	desc = "Отмеченный наградами донк-карман, который покорил сердца как клоунов, так и людей."
	icon_state = "donkpocketbanana"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/banana = 4,
	)
	tastes = list("banana" = 2, "dough" = 2, "children's antibiotics" = 1)
	foodtypes = GRAIN|FRUIT|SUGAR
	warm_type = /obj/item/food/donkpocket/warm/honk
	crafting_complexity = FOOD_COMPLEXITY_3
	var/static/list/honk_added_reagents = list(
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/laughter = 6,
	)

/obj/item/food/donkpocket/honk/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, honk_added_reagents)

/obj/item/food/donkpocket/honk/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, honk_added_reagents)

/obj/item/food/donkpocket/warm/honk
	name = "Теплый Хонк-донкпокет"
	desc = "Отмеченный наградами батончик с начинкой, теперь теплый и подрумяненный."
	icon_state = "donkpocketbanana"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/banana = 4,
		/datum/reagent/consumable/laughter = 6,
	)
	tastes = list("banana" = 2, "dough" = 2, "children's antibiotics" = 1)
	foodtypes = GRAIN|FRUIT|SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/donkpocket/berry
	name = "\improper Ягодный-донкпокет"
	desc = "Невероятно сладкий десертный пирог, впервые созданный для использования в операции Десертный шторм."
	icon_state = "donkpocketberry"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/berryjuice = 3,
	)
	tastes = list("dough" = 2, "jam" = 2)
	foodtypes = GRAIN|FRUIT|SUGAR
	warm_type = /obj/item/food/donkpocket/warm/berry

/obj/item/food/donkpocket/berry/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, child_added_reagents)

/obj/item/food/donkpocket/berry/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, child_added_reagents)

/obj/item/food/donkpocket/warm/berry
	name = "Теплый Ягодный-донкпокет"
	desc = "Невероятно сладкий пончик, ставший теплым и восхитительным."
	icon_state = "donkpocketberry"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/berryjuice = 3,
	)
	tastes = list("dough" = 2, "warm jam" = 2)
	foodtypes = GRAIN|FRUIT|SUGAR

/obj/item/food/donkpocket/gondola
	name = "\improper Гондола-донкпокет"
	desc = "Выбор в пользу использования настоящего мяса гондолы в рецепте, мягко говоря, спорный." //Only a monster would craft this.
	icon_state = "donkpocketgondola"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/gondola_mutation_toxin = 5,
	)
	tastes = list("meat" = 2, "dough" = 2, "inner peace" = 1)
	foodtypes = GRAIN|MEAT

	warm_type = /obj/item/food/donkpocket/warm/gondola
	var/static/list/gondola_added_reagents = list(
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/gondola_mutation_toxin = 5,
	)

/obj/item/food/donkpocket/gondola/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, gondola_added_reagents)

/obj/item/food/donkpocket/gondola/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, gondola_added_reagents)

/obj/item/food/donkpocket/warm/gondola
	name = "Теплый Гондола-донкпокет"
	desc = "Выбор в пользу использования настоящего мяса гондолы в рецепте, мягко говоря, спорный."
	icon_state = "donkpocketgondola"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/gondola_mutation_toxin = 10,
	)
	tastes = list("meat" = 2, "dough" = 2, "inner peace" = 1)
	foodtypes = GRAIN|MEAT

/obj/item/food/donkpocket/deluxe
	name = "\improper Донк-покет Делюкс"
	desc = "Новейший продукт компании Donk Co. Его рецепт держится в строжайшем секрете."
	icon_state = "donkpocketdeluxe"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/medicine/omnizine = 2,
	)
	tastes = list("quality meat" = 2, "dough" = 2, "raw fanciness" = 1)
	foodtypes = GRAIN|MEAT|VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_4

	warm_type = /obj/item/food/donkpocket/warm/deluxe
	var/static/list/deluxe_added_reagents = list(
		/datum/reagent/medicine/omnizine = 8,
	)

/obj/item/food/donkpocket/deluxe/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, deluxe_added_reagents)

/obj/item/food/donkpocket/deluxe/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, deluxe_added_reagents)

/obj/item/food/donkpocket/warm/deluxe
	name = "Теплый Донк-покет Делюкс"
	desc = "Новейший продукт компании Donk Co. Он получается хрустящим, теплым и идеально поджаренным. Черт возьми, какая аппетитная булочка."
	icon_state = "donkpocketdeluxe"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/medicine/omnizine = 10,
	)
	tastes = list("quality meat" = 2, "dough" = 2, "fanciness" = 1)
	foodtypes = GRAIN|MEAT|VEGETABLES|FRIED

/obj/item/food/donkpocket/deluxe/nocarb
	name = "\improper Мясной-донкпокет"
	desc = "Лучшая еда для плотоядного предателя."
	icon_state = "donkpocketdeluxenocarb"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/medicine/omnizine = 2,
	)
	tastes = list("raw meat" = 2, "more meat" = 2, "no carbs" = 1)
	foodtypes = MEAT|RAW
	crafting_complexity = FOOD_COMPLEXITY_4
	warm_type = /obj/item/food/donkpocket/warm/deluxe/nocarb

/obj/item/food/donkpocket/deluxe/meat/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, deluxe_added_reagents)

/obj/item/food/donkpocket/deluxe/meat/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, deluxe_added_reagents)

/obj/item/food/donkpocket/warm/deluxe/nocarb
	name = "Теплый Мясной-донкпокет"
	desc = "Горячая еда, которую предпочитает плотоядный предатель."
	icon_state = "donkpocketdeluxenocarb"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/medicine/omnizine = 10,
	)
	tastes = list("meat" = 2, "more meat" = 2, "no carbs" = 1)
	foodtypes = MEAT

/obj/item/food/donkpocket/deluxe/vegan
	name = "\improper Донк-ролл"
	desc = "Классический перекус, теперь с рисом! Сертифицированный Фронт освобождения животных как веганский и не допускающий жестокого обращения."
	icon_state = "donkpocketdeluxevegan"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/medicine/omnizine = 2,
	)
	tastes = list("rice patty" = 2, "dough" = 2, "peppery kick" = 1)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_4
	warm_type = /obj/item/food/donkpocket/warm/deluxe/vegan

/obj/item/food/donkpocket/deluxe/vegan/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, deluxe_added_reagents)

/obj/item/food/donkpocket/deluxe/vegan/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, deluxe_added_reagents)

/obj/item/food/donkpocket/warm/deluxe/vegan
	name = "Теплый Донк-ролл"
	desc = "Классическая домашняя закуска, теперь с рисом! Она идеально прожарена."
	icon_state = "donkpocketdeluxevegan"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/medicine/omnizine = 10,
	)
	tastes = list("rice patty" = 2, "fried dough" = 2, "peppery kick" = 1)
	foodtypes = GRAIN | VEGETABLES | FRIED
