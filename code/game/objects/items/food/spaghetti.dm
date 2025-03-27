///spaghetti prototype used by all subtypes
/obj/item/food/spaghetti
	icon = 'icons/obj/food/spaghetti.dmi'
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	foodtypes = GRAIN
	venue_value = FOOD_PRICE_CHEAP
	crafting_complexity = FOOD_COMPLEXITY_2

// Why are you putting cooked spaghetti in your pockets?
/obj/item/food/spaghetti/make_microwaveable()
	var/list/display_message = list(
		span_notice("Something wet falls out of their pocket and hits the ground. Is that... [name]?"),
		span_warning("Oh shit! All your pocket [name] fell out!"))
	AddComponent(/datum/component/spill, display_message, 'sound/effects/splat.ogg', /datum/memory/lost_spaghetti)

	return ..()

/obj/item/food/spaghetti/raw
	name = "Спагетти"
	desc = "Вот это вкусная паста!"
	icon_state = "spaghetti"
	tastes = list("pasta" = 1)
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/spaghetti/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/spaghetti/boiledspaghetti, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/spaghetti/raw/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/spaghetti/boiledspaghetti)

/obj/item/food/spaghetti/boiledspaghetti
	name = "Отварные спагетти"
	desc = "Это простое блюдо из лапши, но для его приготовления требуется больше ингредиентов."
	icon_state = "spaghettiboiled"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/spaghetti/boiledspaghetti/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, null, CUSTOM_INGREDIENT_ICON_SCATTER, max_ingredients = 6)

/obj/item/food/spaghetti/pastatomato
	name = "Спагетти"
	desc = "Спагетти с измельченными помидорами. Прямо как готовил твой жестокий отец!"
	icon_state = "pastatomato"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/tomatojuice = 10,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("pasta" = 1, "tomato" = 1)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/spaghetti/pastatomato/soulful
	name = "Соул-фуд"
	desc = "Именно так готовила его мама."
	food_reagents = list(
		// same as normal pasghetti
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/tomatojuice = 10,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		// where the soul comes from
		/datum/reagent/pax = 5,
		/datum/reagent/medicine/psicodine = 10,
		/datum/reagent/medicine/morphine = 5,
	)
	tastes = list("nostalgia" = 1, "happiness" = 1)

/obj/item/food/spaghetti/copypasta
	name = "Копипаста"
	desc = "Вам, наверное, не стоит это пробовать, вы всегда слышите, как люди говорят о том, как это плохо..."
	icon_state = "copypasta"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/tomatojuice = 20,
		/datum/reagent/consumable/nutriment/vitamin = 8,
	)
	tastes = list("pasta" = 1, "tomato" = 1)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/spaghetti/meatballspaghetti
	name = "Спагетти с фрикадельками"
	desc = "Now that's a nic'e meatball!"
	icon_state = "meatballspaghetti"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("pasta" = 1, "meat" = 1)
	foodtypes = GRAIN | MEAT
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/spaghetti/spesslaw
	name = "Салат-пюре"
	desc = "Любимое блюдо юристов."
	icon_state = "spesslaw"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 20,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("pasta" = 1, "meat" = 1)
	foodtypes = GRAIN | MEAT
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/spaghetti/chowmein
	name = "Чоу-мейн"
	desc = "Отличное сочетание лапши и жареных овощей."
	icon_state = "chowmein"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("noodle" = 1, "meat" = 1, "fried vegetables" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/spaghetti/beefnoodle
	name = "Говяжья лапша"
	desc = "Питательный, мясистый и аппетитный."
	icon_state = "beefnoodle"
	trash_type = /obj/item/reagent_containers/cup/bowl
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/liquidgibs = 3,
	)
	tastes = list("noodles" = 1, "meat" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/spaghetti/butternoodles
	name = "Лапша с маслом"
	desc = "Лапша, политая пикантным сливочным маслом. Просто и скользко, но очень вкусно."
	icon_state = "butternoodles"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 9,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("noodles" = 1, "butter" = 1)
	foodtypes = GRAIN | DAIRY
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/spaghetti/mac_n_cheese
	name = "Макароны с сыром"
	desc = "Приготовленный надлежащим образом, только с отборным сыром и панировочными сухарями. И все же, он не вызывает такого острого аппетита, как готовая булочка."
	icon_state = "mac_n_cheese"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 9,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("cheese" = 1, "breadcrumbs" = 1, "pasta" = 1)
	foodtypes = GRAIN | DAIRY
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/spaghetti/shoyu_tonkotsu_ramen
	name = "Рамен сею тонкоцу"
	desc = "Простой рамен из мяса, яиц, лука и морских водорослей."
	icon_state = "shoyu_tonkotsu_ramen"
	trash_type = /obj/item/reagent_containers/cup/bowl
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/nutriment/protein = 6,
	)
	tastes = list("noodles" = 5, "meat" = 3, "egg" = 4, "dried seaweed" = 2)
	foodtypes = GRAIN | MEAT | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/spaghetti/kitakata_ramen
	name = "Рамен китаката"
	desc = "Сытный рамен, состоящий из мяса, грибов, лука и чеснока. Его часто дают больным, чтобы успокоить их"
	icon_state = "kitakata_ramen"
	trash_type = /obj/item/reagent_containers/cup/bowl
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/nutriment/protein = 8,
	)
	tastes = list("noodles" = 5, "meat" = 4, "mushrooms" = 3, "onion" = 2)
	foodtypes = GRAIN | MEAT | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/spaghetti/kitsune_udon
	name = "Кицунэ удон"
	desc = "Вегетарианский удон, приготовленный из обжаренного тофу и лука, с добавлением сахара и соевого соуса. Название происходит от старой народной сказки о лисе, которая наслаждалась жареным тофу."
	icon_state = "kitsune_udon"
	trash_type = /obj/item/reagent_containers/cup/bowl
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 4,
	)
	tastes = list("noodles" = 5, "tofu" = 4, "sugar" = 3, "soy sauce" = 2)
	foodtypes = GRAIN | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/spaghetti/nikujaga
	name = "Никуджага"
	desc = "Восхитительное японское рагу из лапши, лука, картофеля и мяса с овощной смесью."
	icon_state = "nikujaga"
	trash_type = /obj/item/reagent_containers/cup/bowl
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 16,
		/datum/reagent/consumable/nutriment/vitamin = 12,
		/datum/reagent/consumable/nutriment/protein = 8,
	)
	tastes = list("noodles" = 5, "meat" = 4, "potato" = 3, "onion" = 2, "mixed veggies" = 2)
	foodtypes = GRAIN | VEGETABLES | MEAT
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/spaghetti/pho
	name = "Пхо"
	desc = "Вьетнамское блюдо, приготовленное из лапши, овощей, зелени и мяса. Это очень популярное уличное блюдо."
	icon_state = "pho"
	trash_type = /obj/item/reagent_containers/cup/bowl
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 8,
		/datum/reagent/consumable/nutriment/protein = 8,
	)
	tastes = list("noodles" = 5, "meat" = 4, "cabbage" = 3, "onion" = 2, "herbs" = 2)
	foodtypes = GRAIN | VEGETABLES | MEAT
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/spaghetti/pad_thai
	name = "Пад-тай"
	desc = "Популярное в Таиланде блюдо с лапшой, обжаренной во фритюре, приготовленное из арахиса, тофу, лайма и лука."
	icon_state = "pad_thai"
	trash_type = /obj/item/reagent_containers/cup/bowl
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 4,
	)
	tastes = list("noodles" = 5, "fried tofu" = 4, "lime" = 2, "peanut" = 3, "onion" = 2)
	foodtypes = GRAIN | VEGETABLES | NUTS | FRUIT
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/spaghetti/carbonara
	name = "Спагетти карбонара"
	desc = "Шелковистые яйца, хрустящая свинина, сырное блаженство. Mamma mia!"
	icon_state = "carbonara"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("spaghetti" = 1, "parmigiano reggiano" = 1,  "guanciale" = 1)
	foodtypes = GRAIN | MEAT | DAIRY
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/spaghetti/carbonara/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/love_food_buff, /datum/status_effect/food/speech/italian)
