/datum/surgery/lobectomy
	name = "Лобэктомия" //не путать с лоботомией
	organ_to_manipulate = ORGAN_SLOT_LUNGS
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/lobectomy,
		/datum/surgery_step/close,
	)

/datum/surgery/lobectomy/mechanic
	name = "Диагностика фильтрации воздуха"
	requires_bodypart_type = BODYTYPE_ROBOTIC
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/lobectomy/mechanic,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close,
	)

/datum/surgery/lobectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/lungs/target_lungs = target.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(isnull(target_lungs) || target_lungs.damage < 60 || target_lungs.operated)
		return FALSE
	return ..()

//lobectomy, removes the most damaged lung lobe with a 95% base success chance
/datum/surgery_step/lobectomy
	name = "удаляют поврежденный легочный узел (скальпель)"
	implements = list(
		TOOL_SCALPEL = 95,
		/obj/item/melee/energy/sword = 65,
		/obj/item/knife = 45,
		/obj/item/shard = 35)
	time = 42
	preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
	success_sound = 'sound/items/handling/surgery/organ1.ogg'
	failure_sound = 'sound/items/handling/surgery/organ2.ogg'
	surgery_effects_mood = TRUE

/datum/surgery_step/lobectomy/mechanic
	name = "Выполните техническое обслуживание (скальпелем или гаечным ключом)"
	implements = list(
		TOOL_SCALPEL = 95,
		TOOL_WRENCH = 95,
		/obj/item/melee/energy/sword = 65,
		/obj/item/knife = 45,
		/obj/item/shard = 35)
	preop_sound = 'sound/items/tools/ratchet.ogg'
	success_sound = 'sound/machines/airlock/doorclick.ogg'

/datum/surgery_step/lobectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете делать надрез в легких [target]..."),
		span_notice("[user] начинает делать надрез в [target]."),
		span_notice("[user] начинает делать надрез в [target]."),
	)
	display_pain(target, "Вы чувствуете острую боль в груди!")

/datum/surgery_step/lobectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/organ/lungs/target_lungs = human_target.get_organ_slot(ORGAN_SLOT_LUNGS)
		human_target.setOrganLoss(ORGAN_SLOT_LUNGS, 60)
		if(target_lungs)
			target_lungs.operated = TRUE
			if(target_lungs.organ_flags & ORGAN_EMP) //If our organ is failing due to an EMP, fix that
				target_lungs.organ_flags &= ~ORGAN_EMP
		display_results(
			user,
			target,
			span_notice("Вы успешно удалили наиболее поврежденную долю лёгких [human_target]."),
			span_notice("Успешно удалили часть легких [human_target]."),
			"",
		)
		display_pain(target, "Ваша грудь адски болит, но дышать становится немного легче.")
	return ..()

/datum/surgery_step/lobectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		display_results(
			user,
			target,
			span_warning("Ты облажался, не сумев удалить поврежденную долю лёгкого [human_target]!"),
			span_warning("[user] облажался!"),
			span_warning("[user] облажался!"),
		)
		display_pain(target, "Вы чувствуете острый укол в грудь; у вас перехватывает дыхание, и вам больно переводить дыхание!")
		human_target.losebreath += 4
		human_target.adjustOrganLoss(ORGAN_SLOT_LUNGS, 10)
	return FALSE
