/obj/item/food/bait
	name = "Приманка"
	desc = "ты попался на удочку."
	icon = 'icons/obj/fishing.dmi'
	/// Quality trait of this bait
	var/bait_quality = TRAIT_BASIC_QUALITY_BAIT
	/// Icon state added to main fishing rod icon when this bait is equipped
	var/rod_overlay_icon_state
	/// Is this included in the autowiki?
	var/show_on_wiki = TRUE

/obj/item/food/bait/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, bait_quality, INNATE_TRAIT)

/obj/item/food/bait/worm
	name = "Червяк"
	desc = "Это извивающийся червяк из банки с наживкой для рыбалки. Ты же не собираешься его есть, правда?"
	icon = 'icons/obj/fishing.dmi'
	icon_state = "worm"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("meat" = 1, "worms" = 1)
	foodtypes = GROSS | MEAT | BUGS
	w_class = WEIGHT_CLASS_TINY
	bait_quality = TRAIT_BASIC_QUALITY_BAIT
	rod_overlay_icon_state = "worm_overlay"

/obj/item/food/bait/worm/premium
	name = "Очень скользкий червяк"
	desc = "Этот червь выглядит очень утонченно."
	bait_quality = TRAIT_GOOD_QUALITY_BAIT

/obj/item/food/bait/natural
	name = "Натуральная приманка"
	desc = "Рыба, кажется, никак не может насытиться этим!"
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "pill9"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	inhand_icon_state = "pen"
	bait_quality = TRAIT_GREAT_QUALITY_BAIT //this is only here for autowiki purposes, it's removed on init.
	food_reagents = list(/datum/reagent/drug/kronkaine = 2) //The kronkaine is the thing that makes this a great bait.
	tastes = list("hypocrisy" = 1)

/obj/item/food/bait/natural/Initialize(mapload)
	. = ..()
	REMOVE_TRAIT(src, bait_quality, INNATE_TRAIT)

/obj/item/food/bait/doughball
	name = "Пончик"
	desc = "Небольшой кусочек теста. Простая, но эффективная приманка для рыбалки."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "doughball"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("dough" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_TINY
	bait_quality = TRAIT_BASIC_QUALITY_BAIT
	rod_overlay_icon_state = "dough_overlay"

///The abstract synthetic doughball type.
/obj/item/food/bait/doughball/synthetic
	name = "Синтетический пончиковый шарик"
	icon_state = "doughball_blue"
	rod_overlay_icon_state = "dough_blue_overlay"
	preserved_food = TRUE
	show_on_wiki = FALSE //It's an abstract item.

/obj/item/food/bait/doughball/synthetic/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_OMNI_BAIT, INNATE_TRAIT)

///Found in the can of omni-baits, only available from the super fishing toolbox, from the fishing mystery box.
/obj/item/food/bait/doughball/synthetic/super
	name = "Супер-пончик"
	desc = "Будь то травоядные или плотоядные животные, ни одна рыба не сможет устоять перед этим."
	bait_quality = TRAIT_GREAT_QUALITY_BAIT
	show_on_wiki = TRUE

/**
 * Bound to the tech fishing rod, from which cannot be removed,
 * Bait-related preferences and traits, both negative and positive,
 * should be ignored by this bait.
 * Otherwise it'd be hard/impossible to cath some fish with it,
 * making that rod a shoddy choice in the long run.
 */
/obj/item/food/bait/doughball/synthetic/unconsumable

/obj/item/food/bait/doughball/synthetic/unconsumable/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_BAIT_UNCONSUMABLE, INNATE_TRAIT)

