/datum/surgery/cavity_implant
	name = "Полостное имплантирование"
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/handle_cavity,
		/datum/surgery_step/close)

GLOBAL_LIST_INIT(heavy_cavity_implants, typecacheof(list(/obj/item/transfer_valve)))

//handle cavity
/datum/surgery_step/handle_cavity
	name = "вставьте предмет"
	accept_hand = 1
	implements = list(/obj/item = 100)
	repeatable = TRUE
	time = 32
	preop_sound = 'sound/items/handling/surgery/organ1.ogg'
	success_sound = 'sound/items/handling/surgery/organ2.ogg'
	var/obj/item/item_for_cavity

/datum/surgery_step/handle_cavity/tool_check(mob/user, obj/item/tool)
	if(tool.tool_behaviour == TOOL_CAUTERY || istype(tool, /obj/item/gun/energy/laser)) // BUBBER EDIT: adds TOOL_WRENCH and TOOL_RETRACTOR to the list of excluded items so that the robotic surgery functions
		return FALSE
	return !tool.get_temperature()

/datum/surgery_step/handle_cavity/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/chest/target_chest = target.get_bodypart(BODY_ZONE_CHEST)
	item_for_cavity = target_chest.cavity_item
	if(tool)
		display_results(
			user,
			target,
			span_notice("Вы начинаете вставлять [tool] в [target_zone] у [target]..."),
			span_notice("[user] начинает вставлять [tool] в [target_zone] у [target]."),
			span_notice("[user] начинает вставлять [tool.w_class > WEIGHT_CLASS_SMALL ? tool : "что-то"] в [target_zone] у [target]."),
		)
		display_pain(target, "Вы чувствуете, как что-то вставляют в вашу [target_zone], это чертовски больно!")
		return

	display_results(
		user,
		target,
		span_notice("Вы проверяете на наличие предметов в [target_zone] у [target]..."),
		span_notice("[user] проверяет на наличие предметов в [target_zone] у [target]."),
		span_notice("[user] ищет что-то в [target_zone] у [target]."),
	)

/datum/surgery_step/handle_cavity/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery = FALSE)
	var/obj/item/bodypart/chest/target_chest = target.get_bodypart(BODY_ZONE_CHEST)
	if(tool)
		if(item_for_cavity || ((tool.w_class > WEIGHT_CLASS_NORMAL) && !is_type_in_typecache(tool, GLOB.heavy_cavity_implants)) || HAS_TRAIT(tool, TRAIT_NODROP) || (tool.item_flags & ABSTRACT) || isorgan(tool))
			to_chat(user, span_warning("Кажется, вы не можете поместить [tool] в [target_zone] у [target]!"))
			return FALSE

		display_results(
			user,
			target,
			span_notice("Вы помещаете [tool] в [target_zone] у [target]."),
			span_notice("[user] помещает [tool] в [target_zone] у [target]!"),
			span_notice("[user] помещает [tool.w_class > WEIGHT_CLASS_SMALL ? tool : "что-то"] в [target_zone] у [target]."),
		)

		if (!user.transferItemToLoc(tool, target, TRUE))
			return FALSE

		target_chest.cavity_item = tool
		return ..()

	if(!item_for_cavity)
		to_chat(user, span_warning("Вы ничего не находите у [target] в [target_zone]."))
		return FALSE

	display_results(
		user,
		target,
		span_notice("Вы вытягиваете [item_for_cavity] из [target_zone] у [target]."),
		span_notice("[user] вытягивает [item_for_cavity] из [target_zone] у [target]!"),
		span_notice("[user] вытягивает [item_for_cavity.w_class > WEIGHT_CLASS_SMALL ? item_for_cavity : "что-то"] из [target_zone] у [target]."),
	)
	display_pain(target, "Что-то вытягивают из вашей [target_zone]! Это чертовски больно!")
	user.put_in_hands(item_for_cavity)
	target_chest.cavity_item = null
	return ..()
