/obj/item/weldingtool
	name = "сварочный инструмент"
	desc = "Сварочный аппарат стандартной комплектации от Nanotrasen. Сварщик-сварщик, парень наш робастный! Сварщик-сварщик, самопалак ящик!"
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder"
	inhand_icon_state = "welder"
	worn_icon_state = "welder"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	force = 3
	throwforce = 5
	hitsound = SFX_SWING_HIT
	usesound = list('sound/items/tools/welder.ogg', 'sound/items/tools/welder2.ogg')
	drop_sound = 'sound/items/handling/tools/weldingtool_drop.ogg'
	pickup_sound = 'sound/items/handling/tools/weldingtool_pickup.ogg'
	light_system = OVERLAY_LIGHT
	light_range = 2
	light_power = 1.5
	light_color = LIGHT_COLOR_FIRE
	light_on = FALSE
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	armor_type = /datum/armor/item_weldingtool
	resistance_flags = FIRE_PROOF
	heat = 3800
	tool_behaviour = TOOL_WELDER
	toolspeed = 1
	wound_bonus = 10
	bare_wound_bonus = 15
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.7, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.3)
	/// Whether the welding tool is on or off.
	var/welding = FALSE
	/// Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/status = TRUE
	/// The max amount of fuel the welder can hold
	var/max_fuel = 20
	/// Does the welder start with fuel.
	var/starting_fuel = TRUE
	/// Whether or not we're changing the icon based on fuel left.
	var/change_icons = TRUE
	/// Used in process(), dictates whether or not we're calling STOP_PROCESSING whilst we're not welding.
	var/can_off_process = FALSE
	/// When fuel was last removed.
	var/burned_fuel_for = 0

	var/activation_sound = 'sound/items/tools/welderactivate.ogg'
	var/deactivation_sound = 'sound/items/tools/welderdeactivate.ogg'

/datum/armor/item_weldingtool
	fire = 100
	acid = 30

/obj/item/weldingtool/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddElement(/datum/element/tool_flash, light_range)
	AddElement(/datum/element/falling_hazard, damage = force, wound_bonus = wound_bonus, hardhat_safety = TRUE, crushes = FALSE, impact_sound = hitsound)

	create_reagents(max_fuel)
	if(starting_fuel)
		reagents.add_reagent(/datum/reagent/fuel, max_fuel)
	update_appearance()

/obj/item/weldingtool/update_icon_state()
	if(welding)
		inhand_icon_state = "[initial(inhand_icon_state)]1"
	else
		inhand_icon_state = "[initial(inhand_icon_state)]"
	return ..()


/obj/item/weldingtool/update_overlays()
	. = ..()
	if(change_icons)
		var/ratio = get_fuel() / max_fuel
		ratio = CEILING(ratio*4, 1) * 25
		. += "[initial(icon_state)][ratio]"
	if(welding)
		. += "[initial(icon_state)]-on"


/obj/item/weldingtool/process(seconds_per_tick)
	if(welding)
		force = 15
		damtype = BURN
		burned_fuel_for += seconds_per_tick
		if(burned_fuel_for >= TOOL_FUEL_BURN_INTERVAL)
			use(TRUE)
		update_appearance()

	//Welders left on now use up fuel, but lets not have them run out quite that fast
	else
		force = 3
		damtype = BRUTE
		update_appearance()
		if(!can_off_process)
			STOP_PROCESSING(SSobj, src)
		return

	//This is to start fires. process() is only called if the welder is on.
	open_flame()


/obj/item/weldingtool/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] сваривает [user.p_their()] все отверстия! Похоже, что [user.p_theyre()] пытается покончить с собой!"))
	return FIRELOSS

/obj/item/weldingtool/screwdriver_act(mob/living/user, obj/item/tool)
	flamethrower_screwdriver(tool, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/weldingtool/attackby(obj/item/tool, mob/user, params)
	if(istype(tool, /obj/item/stack/rods))
		flamethrower_rods(tool, user)
	else
		. = ..()
	update_appearance()

/obj/item/weldingtool/proc/explode()
	var/plasmaAmount = reagents.get_reagent_amount(/datum/reagent/toxin/plasma)
	dyn_explosion(src, plasmaAmount/5, explosion_cause = src) // 20 plasma in a standard welder has a 4 power explosion. no breaches, but enough to kill/dismember holder
	qdel(src)

/obj/item/weldingtool/use_tool(atom/target, mob/living/user, delay, amount, volume, datum/callback/extra_checks)
	var/mutable_appearance/sparks = mutable_appearance('icons/effects/welding_effect.dmi', "welding_sparks", GASFIRE_LAYER, src, ABOVE_LIGHTING_PLANE)
	target.add_overlay(sparks)
	LAZYADD(target.update_overlays_on_z, sparks)
	. = ..()
	LAZYREMOVE(target.update_overlays_on_z, sparks)
	target.cut_overlay(sparks)

/obj/item/weldingtool/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!status && interacting_with.is_refillable())
		reagents.trans_to(interacting_with, reagents.total_volume, transferred_by = user)
		to_chat(user, span_notice("Вы сливаете топливо из топливного бака [src] в [interacting_with]."))
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	if(!ishuman(interacting_with))
		return NONE
	if(user.combat_mode)
		return NONE

	return try_heal_loop(interacting_with, user)

/obj/item/weldingtool/proc/try_heal_loop(atom/interacting_with, mob/living/user, repeating = FALSE)
	var/mob/living/carbon/human/attacked_humanoid = interacting_with
	var/obj/item/bodypart/affecting = attacked_humanoid.get_bodypart(check_zone(user.zone_selected))
	if(isnull(affecting) || !IS_ROBOTIC_LIMB(affecting))
		return NONE

	if (!affecting.brute_dam)
		balloon_alert(user, "конечность не повреждена")
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice("[user] начинает исправлять некоторые дефекты на [attacked_humanoid == user ? user.p_their() : "[attacked_humanoid]"] [affecting.name]."),
		span_notice("Вы начинаете исправлять некоторые дефекты на [attacked_humanoid == user ? "ваша" : "[attacked_humanoid]"] [affecting.name]."))
	var/use_delay = repeating ? 1 SECONDS : 0
	if(user == attacked_humanoid)
		use_delay = 5 SECONDS

	if(!use_tool(attacked_humanoid, user, use_delay, volume=50, amount=1))
		return ITEM_INTERACT_BLOCKING

	if (!attacked_humanoid.item_heal(user, brute_heal = 15, burn_heal = 0, heal_message_brute = "dents", heal_message_burn = "burnt wires", required_bodytype = BODYTYPE_ROBOTIC))
		return ITEM_INTERACT_BLOCKING

	INVOKE_ASYNC(src, PROC_REF(try_heal_loop), interacting_with, user, TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/item/weldingtool/afterattack(atom/target, mob/user, click_parameters)
	if(!isOn())
		return
	use(1)
	var/turf/location = get_turf(user)
	location.hotspot_expose(700, 50, 1)
	if(QDELETED(target) || !isliving(target)) // can't ignite something that doesn't exist
		return
	var/mob/living/attacked_mob = target
	if(attacked_mob.ignite_mob())
		message_admins("[ADMIN_LOOKUPFLW(user)] активировал [key_name_admin(attacked_mob)] с помощью [src] в [AREACOORD(user)]")
		user.log_message("активируйте [key_name(attacked_mob)] с помощью [src].", LOG_ATTACK)

/obj/item/weldingtool/attack_self(mob/user)
	if(reagents.has_reagent(/datum/reagent/toxin/plasma))
		message_admins("[ADMIN_LOOKUPFLW(user)] активировал сварщика в [AREACOORD(user)].")
		user.log_message("активировал оборудованный сварочный аппарат", LOG_VICTIM)
		explode()
		return

	switched_on(user)
	update_appearance()

/// Returns the amount of fuel in the welder
/obj/item/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount(/datum/reagent/fuel)

/// Uses fuel from the welding tool.
/obj/item/weldingtool/use(used = 0)
	if(!isOn() || !check_fuel())
		return FALSE

	if(used > 0)
		burned_fuel_for = 0

	if(get_fuel() >= used)
		reagents.remove_reagent(/datum/reagent/fuel, used)
		check_fuel()
		return TRUE
	else
		return FALSE


/// Toggles the welding value.
/obj/item/weldingtool/proc/set_welding(new_value)
	if(welding == new_value)
		return
	. = welding
	welding = new_value
	set_light_on(welding)


/// Turns off the welder if there is no more fuel (does this really need to be its own proc?)
/obj/item/weldingtool/proc/check_fuel(mob/user)
	if(get_fuel() <= 0 && welding)
		set_light_on(FALSE)
		switched_on(user)
		update_appearance()
		return FALSE
	return TRUE

// /Switches the welder on
/obj/item/weldingtool/proc/switched_on(mob/user)
	if(!status)
		balloon_alert(user, "unsecured!")
		return
	set_welding(!welding)
	if(welding)
		if(get_fuel() >= 1)
			playsound(loc, activation_sound, 50, TRUE)
			force = 15
			damtype = BURN
			hitsound = 'sound/items/tools/welder.ogg'
			update_appearance()
			START_PROCESSING(SSobj, src)
		else
			balloon_alert(user, "нет топлива!")
			switched_off(user)
	else
		playsound(loc, deactivation_sound, 50, TRUE)
		switched_off(user)

/// Switches the welder off
/obj/item/weldingtool/proc/switched_off(mob/user)
	set_welding(FALSE)

	force = 3
	damtype = BRUTE
	hitsound = SFX_SWING_HIT
	update_appearance()


/obj/item/weldingtool/examine(mob/user)
	. = ..()
	. += "Он содержит [get_fuel()] единицы топлива из [max_fuel]."

/obj/item/weldingtool/get_temperature()
	return welding * heat

/// Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return welding

/// If welding tool ran out of fuel during a construction task, construction fails.
/obj/item/weldingtool/tool_use_check(mob/living/user, amount, heat_required)
	if(!isOn() || !check_fuel())
		to_chat(user, span_warning("[src] должен быть включен, чтобы выполнить эту задачу!"))
		return FALSE
	if(get_fuel() < amount)
		to_chat(user, span_warning("Для выполнения этой задачи вам потребуется больше сварочного топлива!"))
		return FALSE
	if(heat < heat_required)
		to_chat(user, span_warning("[src] недостаточно температуры для выполнения этой задачи!"))
		return FALSE
	return TRUE

/// Ran when the welder is attacked by a screwdriver.
/obj/item/weldingtool/proc/flamethrower_screwdriver(obj/item/tool, mob/user)
	if(welding)
		to_chat(user, span_warning("Сначала выключи его!"))
		return
	status = !status
	if(status)
		to_chat(user, span_notice("Вы снова закрепляете [src] и закрываете топливный бак."))
		reagents.flags &= ~(OPENCONTAINER)
	else
		to_chat(user, span_notice("[src] теперь можно подключать, модифицировать и заправлять."))
		reagents.flags |= OPENCONTAINER
	add_fingerprint(user)

/// First step of building a flamethrower (when a welder is attacked by rods)
/obj/item/weldingtool/proc/flamethrower_rods(obj/item/tool, mob/user)
	if(!status)
		var/obj/item/stack/rods/used_rods = tool
		if (used_rods.use(1))
			var/obj/item/flamethrower/flamethrower_frame = new /obj/item/flamethrower(user.loc)
			if(!remove_item_from_storage(flamethrower_frame, user))
				user.transferItemToLoc(src, flamethrower_frame, TRUE)
			flamethrower_frame.weldtool = src
			add_fingerprint(user)
			to_chat(user, span_notice("Вы добавляете стержень к сварочному аппарату, начиная строить огнемет."))
			user.put_in_hands(flamethrower_frame)
		else
			to_chat(user, span_warning("Вам нужен один стержень, чтобы начать строить огнемет!"))

/obj/item/weldingtool/ignition_effect(atom/ignitable_atom, mob/user)
	if(use_tool(ignitable_atom, user, 0))
		return span_rose("[user]  случайно зажигает [ignitable_atom] с помощью [src], какой крутой.")
	else
		return ""

/obj/item/weldingtool/empty
	starting_fuel = FALSE

/obj/item/weldingtool/largetank
	name = "промышленный сварочный инструмент"
	desc = "Сварочный аппарат чуть большего размера с большим баком."
	icon_state = "indwelder"
	max_fuel = 40
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT*0.6)

/obj/item/weldingtool/largetank/flamethrower_screwdriver()
	return

/obj/item/weldingtool/largetank/empty
	starting_fuel = FALSE

/obj/item/weldingtool/largetank/cyborg
	name = "встроенный сварочный инструмент"
	desc = "Современный сварочный аппарат, предназначенный для использования в роботизированных системах. Специальная конструкция удваивает скорость сварки."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "indwelder_cyborg"
	toolspeed = 0.5

/obj/item/weldingtool/largetank/cyborg/cyborg_unequip(mob/user)
	if(!isOn())
		return
	switched_on(user)


/obj/item/weldingtool/mini
	name = "аварийная ручная сварка"
	desc = "Миниатюрный сварочный аппарат, используемый в чрезвычайных ситуациях."
	icon_state = "miniwelder"
	max_fuel = 10
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.3, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.1)
	change_icons = FALSE

/obj/item/weldingtool/mini/flamethrower_screwdriver()
	return

/obj/item/weldingtool/mini/empty
	starting_fuel = FALSE

/obj/item/weldingtool/abductor
	name = "инопланетный сварочный инструмент"
	desc = "Инопланетный сварочный инструмент. Какое бы топливо он ни использовал, оно никогда не заканчивается."
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "welder"
	toolspeed = 0.1
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/titanium =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT)
	light_system = NO_LIGHT_SUPPORT
	light_range = 0
	change_icons = FALSE

/obj/item/weldingtool/abductor/process()
	if(get_fuel() <= max_fuel)
		reagents.add_reagent(/datum/reagent/fuel, 1)
	..()

/obj/item/weldingtool/hugetank
	name = "улучшенный промышленный сварочный инструмент"
	desc = "Модернизированный сварочный аппарат на базе промышленного сварочного аппарата."
	icon_state = "upindwelder"
	inhand_icon_state = "upindwelder"
	max_fuel = 80
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.7, /datum/material/glass=SMALL_MATERIAL_AMOUNT*1.2)

/obj/item/weldingtool/experimental
	name = "эксперементальный сварочный инструмент"
	desc = "Экспериментальный сварочный аппарат, способный самостоятельно вырабатывать топливо и менее вредный для глаз."
	icon_state = "exwelder"
	inhand_icon_state = "exwelder"
	max_fuel = 40
	custom_materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT*5, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT*1.5, /datum/material/uranium =SMALL_MATERIAL_AMOUNT * 2)
	change_icons = FALSE
	can_off_process = TRUE
	light_range = 1
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.5
	var/last_gen = 0
	var/nextrefueltick = 0

/obj/item/weldingtool/experimental/process()
	..()
	if(get_fuel() < max_fuel && nextrefueltick < world.time)
		nextrefueltick = world.time + 10
		reagents.add_reagent(/datum/reagent/fuel, 1)
