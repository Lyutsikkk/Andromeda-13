/datum/surgery/brain_surgery
	name = "Хирургия головного мозга"
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/fix_brain,
		/datum/surgery_step/close,
	)

/datum/surgery/brain_surgery/mechanic
	name = "Диагностика операционной системы"
	requires_bodypart_type = BODYTYPE_ROBOTIC
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/fix_brain/mechanic,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close,
	)

/datum/surgery_step/fix_brain
	name = "починка мозга (гемостат)"
	implements = list(
		TOOL_HEMOSTAT = 85,
		TOOL_SCREWDRIVER = 35,
		/obj/item/pen = 15) //don't worry, pouring some alcohol on their open brain will get that chance to 100
	repeatable = TRUE
	time = 100 //long and complicated
	preop_sound = 'sound/items/handling/surgery/hemostat1.ogg'
	success_sound = 'sound/items/handling/surgery/hemostat1.ogg'
	failure_sound = 'sound/items/handling/surgery/organ2.ogg'

/datum/surgery_step/fix_brain/mechanic
	name = "выполнить нейронную отладку (гемостат или мультитул)"
	implements = list(
		TOOL_HEMOSTAT = 85,
		TOOL_MULTITOOL = 85,
		TOOL_SCREWDRIVER = 35,
		/obj/item/pen = 15)
	preop_sound = 'sound/items/taperecorder/tape_flip.ogg'
	success_sound = 'sound/items/taperecorder/taperecorder_close.ogg'

/datum/surgery/brain_surgery/can_start(mob/user, mob/living/carbon/target)
	return target.get_organ_slot(ORGAN_SLOT_BRAIN) && ..()

/datum/surgery_step/fix_brain/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете восстанавливать мозг [target]..."),
		span_notice("[user] начинает восстанавливать мозг [target]."),
		span_notice("[user] начинает выполнять операцию на мозге [target]."),
	)
	display_pain(target, "Ваша голова раскалывается от невообразимой боли!")

/datum/surgery_step/fix_brain/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("Вам удалось восстановить мозг [target]."),
		span_notice("[user] успешно восстановил мозг [target]!"),
		span_notice("[user] завершил операцию на мозге [target]."),
	)
	display_pain(target, "Боль в голове отступает, думать становится немного легче!")
	if(target.mind?.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	target.setOrganLoss(ORGAN_SLOT_BRAIN, target.get_organ_loss(ORGAN_SLOT_BRAIN) - 50) //we set damage in this case in order to clear the "failing" flag
	target.cure_all_traumas(TRAUMA_RESILIENCE_SURGERY)
	if(target.get_organ_loss(ORGAN_SLOT_BRAIN) > 0)
		to_chat(user, "мозг [target] похоже, может быть восстановлен.")
	return ..()

/datum/surgery_step/fix_brain/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_slot(ORGAN_SLOT_BRAIN))
		display_results(
			user,
			target,
			span_warning("Вы облажались, нанеся еще повреждение на мозг!"),
			span_warning("[user] облажался, нанеся повреждение мозгу!"),
			span_notice("[user] завершил операцию на мозге [target]."),
		)
		display_pain(target, "Ваша голова раскалывается от ужасной боли; думать больно!")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	else
		user.visible_message(span_warning("[user] внезапно замечает, что мозг, над которым [user.p_they()] [user.p_were()] работал, больше не существует."), span_warning("Вы внезапно замечаете, что мозг, над которым вы работали, больше не существует."))
	return FALSE
