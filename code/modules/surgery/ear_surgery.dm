//Head surgery to fix the ears organ
/datum/surgery/ear_surgery
	name = "Хирургия уха"
	requires_bodypart_type = NONE
	organ_to_manipulate = ORGAN_SLOT_EARS
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/fix_ears,
		/datum/surgery_step/close,
	)

//fix ears
/datum/surgery_step/fix_ears
	name = "лечение ушей (гемостат)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 45,
		/obj/item/pen = 25)
	time = 64

/datum/surgery/ear_surgery/can_start(mob/user, mob/living/carbon/target)
	return target.get_organ_slot(ORGAN_SLOT_EARS) && ..()

/datum/surgery_step/fix_ears/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете лечить уши [target]..."),
		span_notice("[user] леччит уши [target]."),
		span_notice("[user] начинает выполнять операцию на ушах [target]."),
	)
	display_pain(target, "Вы чувствуете головокружительную боль в голове!")

/datum/surgery_step/fix_ears/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/obj/item/organ/ears/target_ears = target.get_organ_slot(ORGAN_SLOT_EARS)
	display_results(
		user,
		target,
		span_notice("Вам удалось вылечить уши [target]."),
		span_notice("[user] успешно вылечил уши [target]!"),
		span_notice("[user] завершил операцию на ушах [target]."),
	)
	display_pain(target, "У вас кружится голова, но кажется, что вы чувствуете, как возвращается слух!")
	target_ears.deaf = (20) // глухота снимает тики, так что это должно продлиться примерно 30-40 секунд
	target_ears.set_organ_damage(0)
	return ..()

/datum/surgery_step/fix_ears/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
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
			span_warning("Вы случайно ранили прямо в мозг! [target] Или сделал бы, если бы у [target] был мозг."),
			span_warning("[user] случайно ранит прямо в мозг [target] Или сделал бы, если бы у [target] был мозг."),
			span_warning("[user] случайно ранит прямо в мозг [target]"),
		)
		display_pain(target, "Вы чувствуете внутреннюю пронзительную боль прямо в голове!") // dunno who can feel pain w/o a brain but may as well be consistent.
	return FALSE
