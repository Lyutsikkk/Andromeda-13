/obj/item/stack/light_w
	name = "проволочная стеклянная плитка"
	singular_name = "wired glass floor tile"
	desc = "Стеклянная плитка, которая каким-то образом соединена проволокой."
	icon = 'icons/obj/tiles.dmi'
	icon_state = "glass_wire"
	w_class = WEIGHT_CLASS_NORMAL
	force = 3
	throwforce = 5
	throw_speed = 3
	throw_range = 7
	obj_flags = CONDUCTS_ELECTRICITY
	max_amount = 60
	grind_results = list(/datum/reagent/silicon = 20, /datum/reagent/copper = 5)
	merge_type = /obj/item/stack/light_w

/obj/item/stack/light_w/examine(mob/user)
	. = ..()
	. += span_warning("\The [src] выглядит незаконченным, добавьте <b>железо</b> чтобы завершить его.")

/obj/item/stack/light_w/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/stack/sheet/iron))
		var/obj/item/stack/sheet/iron/M = O
		if (M.use(1))
			var/obj/item/L = new /obj/item/stack/tile/light(user.drop_location())
			to_chat(user, span_notice("Вы делаете светлую плитку."))
			if (!QDELETED(L))
				L.add_fingerprint(user)
			use(1)
		else
			to_chat(user, span_warning("Вам понадобится один железный лист, чтобы отделать светлую плитку!"))
	else
		return ..()

/obj/item/stack/light_w/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	var/atom/Tsec = user.drop_location()
	var/obj/item/stack/cable_coil/CC = new (Tsec, 5)
	if (!QDELETED(CC))
		CC.add_fingerprint(user)
	var/obj/item/stack/sheet/glass/G = new (Tsec)
	if (!QDELETED(G))
		G.add_fingerprint(user)
	use(1)
