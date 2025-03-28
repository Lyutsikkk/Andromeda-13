/datum/surgery/cavity_implant
	name = "Имплантация"
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
	name = "элемент имплантата"
	accept_hand = 1
	implements = list(/obj/item = 100)
	repeatable = TRUE
	time = 32
	preop_sound = 'sound/items/handling/surgery/organ1.ogg'
	success_sound = 'sound/items/handling/surgery/organ2.ogg'
	var/obj/item/item_for_cavity

/datum/surgery_step/handle_cavity/tool_check(mob/user, obj/item/tool)
	if(tool.tool_behaviour == TOOL_CAUTERY || istype(tool, /obj/item/gun/energy/laser))
		return FALSE
	return !tool.get_temperature()

/datum/surgery_step/handle_cavity/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/chest/target_chest = target.get_bodypart(BODY_ZONE_CHEST)
	item_for_cavity = target_chest.cavity_item
	if(tool)
		display_results(
			user,
			target,
			span_notice("Вы начинаете вставлять [tool] в [target_zone]..."),
			span_notice("[user] начинает вставлять [tool] в [target_zone]."),
			span_notice("[user] начинает вставлять [tool.w_class > WEIGHT_CLASS_SMALL ? tool : "что-то"] в [target_zone]."),
		)
		display_pain(target, "Вы можете почувствовать, как что-то вставляется в вашу [target_zone], это чертовски больно!")
		return

	display_results(
		user,
		target,
		span_notice("Вы проверяете наличие элементов в [target_zone]..."),
		span_notice("[user] проверяет наличие элементов в  [target_zone]."),
		span_notice("[user] ищет что-то в [target_zone]."),
	)

/datum/surgery_step/handle_cavity/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery = FALSE)
	var/obj/item/bodypart/chest/target_chest = target.get_bodypart(BODY_ZONE_CHEST)
	if(tool)
		if(item_for_cavity || ((tool.w_class > WEIGHT_CLASS_NORMAL) && !is_type_in_typecache(tool, GLOB.heavy_cavity_implants)) || HAS_TRAIT(tool, TRAIT_NODROP) || (tool.item_flags & ABSTRACT) || isorgan(tool))
			to_chat(user, span_warning("Похоже, вы не можете поместить [tool] в [target_zone]!"))
			return FALSE

		display_results(
			user,
			target,
			span_notice("Вы помещаете [tool] в [target_zone]."),
			span_notice("[user] помещает [tool] в [target_zone]!"),
			span_notice("[user] помещает [tool.w_class > WEIGHT_CLASS_SMALL ? tool : "что-то"] в [target_zone]."),
		)

		if (!user.transferItemToLoc(tool, target, TRUE))
			return FALSE

		target_chest.cavity_item = tool
		return ..()

	if(!item_for_cavity)
		to_chat(user, span_warning("Вы ничего не нашли в [target_zone]."))
		return FALSE

	display_results(
		user,
		target,
		span_notice("Вы извлекаете [item_for_cavity] из [target_zone]."),
		span_notice("[user] извлекает [item_for_cavity] из [target_zone]!"),
		span_notice("[user] извлекает [item_for_cavity.w_class > WEIGHT_CLASS_SMALL ? item_for_cavity : "что-то"] из [target_zone]."),
	)
	display_pain(target, "Что-то вытащено из вашей [target_zone]! Это чертовски больно!")
	user.put_in_hands(item_for_cavity)
	target_chest.cavity_item = null
	return ..()
