/datum/surgery/coronary_bypass
	name = "Коронарное шунтирование"
	organ_to_manipulate = ORGAN_SLOT_HEART
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise_heart,
		/datum/surgery_step/coronary_bypass,
		/datum/surgery_step/close,
	)

/datum/surgery/coronary_bypass/mechanic
	name = "Диагностика двигателя"
	requires_bodypart_type = BODYTYPE_ROBOTIC
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/incise_heart/mechanic,
		/datum/surgery_step/coronary_bypass/mechanic,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close,
	)

/datum/surgery/coronary_bypass/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/heart/target_heart = target.get_organ_slot(ORGAN_SLOT_HEART)
	if(isnull(target_heart) || target_heart.damage < 60 || target_heart.operated)
		return FALSE
	return ..()


//an incision but with greater bleed, and a 90% base success chance
/datum/surgery_step/incise_heart
	name = "вырезать сердце (скальпель)"
	implements = list(
		TOOL_SCALPEL = 90,
		/obj/item/melee/energy/sword = 45,
		/obj/item/knife = 45,
		/obj/item/shard = 25)
	time = 16
	preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
	success_sound = 'sound/items/handling/surgery/scalpel2.ogg'
	failure_sound = 'sound/items/handling/surgery/organ2.ogg'
	surgery_effects_mood = TRUE

/datum/surgery_step/incise_heart/mechanic
	name = "доступ к внутренним устройствам двигателя (скальпель или лом)"
	implements = list(
		TOOL_SCALPEL = 95,
		TOOL_CROWBAR = 95,
		/obj/item/melee/energy/sword = 65,
		/obj/item/knife = 45,
		/obj/item/shard = 35)
	preop_sound = 'sound/items/tools/ratchet.ogg'
	success_sound = 'sound/machines/airlock/doorclick.ogg'

/datum/surgery_step/incise_heart/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете делать надрез в сердце..."),
		span_notice("[user] начинает делать надрез в сердце."),
		span_notice("[user] начинает делать надрез в сердце."),
	)
	display_pain(target, "Вы чувствуете ужасную боль в своем сердце, этого почти достаточно, чтобы вы потеряли сознание!")

/datum/surgery_step/incise_heart/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		if (!HAS_TRAIT(target_human, TRAIT_NOBLOOD))
			display_results(
				user,
				target,
				span_notice("Кровь скапливается вокруг разреза в сердце [target_human]."),
				span_notice("Кровь скапливается вокруг разреза в сердце [target_human]."),
				span_notice("Кровь скапливается вокруг разреза в сердце [target_human]."),
			)
			var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
			target_bodypart.adjustBleedStacks(10)
			target_human.adjustBruteLoss(10)
	return ..()

/datum/surgery_step/incise_heart/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_warning("Ты облажался, ранив слишком глубоко в сердце!"),
			span_warning("[user] облажался, из-за чего кровь хлынула из груди [target_human]!"),
			span_warning("[user] облажался, из-за чего кровь хлынула из груди [target_human]!"),
		)
		var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
		target_bodypart.adjustBleedStacks(10)
		target_human.adjustOrganLoss(ORGAN_SLOT_HEART, 10)
		target_human.adjustBruteLoss(10)

//grafts a coronary bypass onto the individual's heart, success chance is 90% base again
/datum/surgery_step/coronary_bypass
	name = "коронарное шунтирование (гемостат)"
	implements = list(
		TOOL_HEMOSTAT = 90,
		TOOL_WIRECUTTER = 35,
		/obj/item/stack/package_wrap = 15,
		/obj/item/stack/cable_coil = 5)
	time = 90
	preop_sound = 'sound/items/handling/surgery/hemostat1.ogg'
	success_sound = 'sound/items/handling/surgery/hemostat1.ogg'
	failure_sound = 'sound/items/handling/surgery/organ2.ogg'

/datum/surgery_step/coronary_bypass/mechanic
	name = "perform maintenance (hemostat or wrench)"
	implements = list(
		TOOL_HEMOSTAT = 90,
		TOOL_WRENCH = 90,
		TOOL_WIRECUTTER = 35,
		/obj/item/stack/package_wrap = 15,
		/obj/item/stack/cable_coil = 5)
	preop_sound = 'sound/items/tools/ratchet.ogg'
	success_sound = 'sound/machines/airlock/doorclick.ogg'

/datum/surgery_step/coronary_bypass/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете подключать шунтирующий аппарат к сердцу [target]..."),
		span_notice("[user] начинает подключать что-то к сердцу [target]!"),
		span_notice("[user] начинает подключать что-то к сердцу [target]!"),
	)
	display_pain(target, "Боль в вашей груди невыносима! Вы едва можете это выносить!")

/datum/surgery_step/coronary_bypass/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	target.setOrganLoss(ORGAN_SLOT_HEART, 60)
	var/obj/item/organ/heart/target_heart = target.get_organ_slot(ORGAN_SLOT_HEART)
	if(target_heart) //slightly worrying if we lost our heart mid-operation, but that's life
		target_heart.operated = TRUE
		if(target_heart.organ_flags & ORGAN_EMP) //If our organ is failing due to an EMP, fix that
			target_heart.organ_flags &= ~ORGAN_EMP
	display_results(
		user,
		target,
		span_notice("Вы успешно подключили шунтирующее устройство к сердцу [target]."),
		span_notice("[user] заканчивает пересадку чего-то на сердце [target]."),
		span_notice("[user] заканчивает пересадку чего-то на сердце [target]."),
	)
	display_pain(target, "Боль в вашей груди пульсирует, но ваше сердце чувствует себя лучше, чем когда-либо!")
	return ..()

/datum/surgery_step/coronary_bypass/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_warning("Вы допустили ошибку при установке трансплантата, и он оторвался, оторвав часть сердца!"),
			span_warning("[user] допустил ошибку, в результате чего из груди [target_human] хлынула кровь!"),
			span_warning("[user] допустил ошибку, в результате чего из груди [target_human] хлынула кровь!"),
		)
		display_pain(target, "У вас агония в груди; вы чувствуете, что сходите с ума!")
		target_human.adjustOrganLoss(ORGAN_SLOT_HEART, 20)
		var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
		target_bodypart.adjustBleedStacks(30)
	return FALSE
