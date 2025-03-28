/datum/surgery/eye_surgery
	name = "Глазная хирургия"
	requires_bodypart_type = NONE
	organ_to_manipulate = ORGAN_SLOT_EYES
	possible_locs = list(BODY_ZONE_PRECISE_EYES)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/fix_eyes,
		/datum/surgery_step/close,
	)

//fix eyes
/datum/surgery_step/fix_eyes
	name = "лечение глаз (гемостат)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 45,
		/obj/item/pen = 25)
	time = 64

/datum/surgery/eye_surgery/can_start(mob/user, mob/living/carbon/target)
	return target.get_organ_slot(ORGAN_SLOT_EYES) && ..()

/datum/surgery_step/fix_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете исправлять зрение [target]..."),
		span_notice("[user] начинает исправлять зрение [target]."),
		span_notice("[user] начинает выполнять операцию на глазах [target]."),
	)
	display_pain(target, "Вы чувствуете острую боль в глазах!")

/datum/surgery_step/fix_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/obj/item/organ/eyes/target_eyes = target.get_organ_slot(ORGAN_SLOT_EYES)
	user.visible_message(span_notice("[user] успешно исправляет зрение [target]!"), span_notice("Вам удалось исправить зрение [target]."))
	display_results(
		user,
		target,
		span_notice("Вам удалось вылечить глаза [target]."),
		span_notice("[user] успешно вылечил глаза [target]!"),
		span_notice("[user] завершил операцию на глазах [target]."),
	)
	display_pain(target, "Ваше зрение затуманивается, но, похоже, теперь вы можете видеть немного лучше!")
	target.remove_status_effect(/datum/status_effect/temporary_blindness)
	target.set_eye_blur_if_lower(70 SECONDS) //this will fix itself slowly.
	target_eyes.set_organ_damage(0) // heals nearsightedness and blindness from eye damage
	return ..()

/datum/surgery_step/fix_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_by_type(/obj/item/organ/brain))
		display_results(
			user,
			target,
			span_warning("Вы случайно наносите удар прямо в мозг [target]!"),
			span_warning("[user] случайно наносит удар прямо в мозг [target]!"),
			span_warning("[user] случайно наносит удар прямо в мозг [target]!"),
		)
		display_pain(target, "Вы чувствуете внутреннюю пронзительную боль, проходящую прямо через вашу голову, в мозг!")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 70)
	else
		display_results(
			user,
			target,
			span_warning("Вы случайно ранили прямо в мозг [target]! Или ранили бы, если бы у [target] был мозг."),
			span_warning("[user] случайно ранит прямо в мозг [target]! Или ранили бы, если бы у [target] был мозг."),
			span_warning("[user] случайно ранит прямо в мозг [target]!"),
		)
		display_pain(target, "Вы чувствуете внутреннюю пронзительную боль прямо в голове!") // dunno who can feel pain w/o a brain but may as well be consistent.
	return FALSE
