/datum/surgery/implant_removal
	name = "Удаление имплантата"
	target_mobtypes = list(/mob/living)
	possible_locs = list(BODY_ZONE_CHEST)
	surgery_flags = SURGERY_REQUIRE_RESTING
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/extract_implant,
		/datum/surgery_step/close,
	)

//extract implant
/datum/surgery_step/extract_implant
	name = "извлечение имплантата (гемостат)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_CROWBAR = 65,
		/obj/item/kitchen/fork = 35)
	time = 64
	success_sound = 'sound/items/handling/surgery/hemostat1.ogg'
	var/obj/item/implant/implant

/datum/surgery_step/extract_implant/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	for(var/obj/item/object in target.implants)
		implant = object
		break
	if(implant)
		display_results(
			user,
			target,
			span_notice("Вы начинаете извлекать [implant] из [target_zone]..."),
			span_notice("[user] начинает извлекать [implant] из [target_zone]."),
			span_notice("[user] начинает извлекать что-либо из [target_zone]."),
		)
		display_pain(target, "Вы чувствуете сильную боль в [target_zone]!")
	else
		display_results(
			user,
			target,
			span_notice("Вы ищете имплантат в [target_zone]..."),
			span_notice("[user] ищет имплантат в [target_zone]."),
			span_notice("[user] ищет что-то в [target_zone]."),
		)

/datum/surgery_step/extract_implant/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(implant)
		display_results(
			user,
			target,
			span_notice("Вы успешно удалили [implant] из [target_zone]."),
			span_notice("[user] успешно удаляет [implant] из [target_zone]!"),
			span_notice("[user] успешно удаляет что-то из [target_zone]!"),
		)
		display_pain(target, "Вы можете почувствовать, как из вас вытащили [implant.name]!")
		implant.removed(target)

		if (QDELETED(implant))
			return ..()

		var/obj/item/implantcase/case
		for(var/obj/item/implantcase/implant_case in user.held_items)
			case = implant_case
			break
		if(!case)
			case = locate(/obj/item/implantcase) in get_turf(target)
		if(case && !case.imp)
			case.imp = implant
			implant.forceMove(case)
			case.update_appearance()
			display_results(
				user,
				target,
				span_notice("Вы помещаете [implant] в [case]."),
				span_notice("[user] помещает [implant] в [case]!"),
				span_notice("[user] помещает это в [case]!"),
			)
		else
			qdel(implant)

	else
		to_chat(user, span_warning("Вы ничего не можете найти в [target_zone]!"))
	return ..()

/datum/surgery/implant_removal/mechanic
	name = "Удаление имплантата"
	requires_bodypart_type = BODYTYPE_ROBOTIC
	target_mobtypes = list(/mob/living/carbon/human) // Simpler mobs don't have bodypart types
	surgery_flags = parent_type::surgery_flags | SURGERY_REQUIRE_LIMB
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/extract_implant,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close)
