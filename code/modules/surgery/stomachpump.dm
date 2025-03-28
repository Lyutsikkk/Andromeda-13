/datum/surgery/stomach_pump
	name = "Очистить желудок"
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/stomach_pump,
		/datum/surgery_step/close,
	)

/datum/surgery/stomach_pump/mechanic
	name = "Очистка от питательных веществ"
	requires_bodypart_type = BODYTYPE_ROBOTIC
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/stomach_pump,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close,
	)

/datum/surgery/stomach_pump/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/stomach/target_stomach = target.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(HAS_TRAIT(target, TRAIT_HUSK))
		return FALSE
	if(!target_stomach)
		return FALSE
	return ..()

//Working the stomach by hand in such a way that you induce vomiting.
/datum/surgery_step/stomach_pump
	name = "очистка желудка (рука)"
	accept_hand = TRUE
	repeatable = TRUE
	time = 20
	success_sound = 'sound/items/handling/surgery/organ2.ogg'

/datum/surgery_step/stomach_pump/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете очищать желудок [target]..."),
		span_notice("[user] начинает очищать желудок [target]."),
		span_notice("[user] начинает вставлять два пальца в рот [target]."),
	)
	display_pain(target, "Ты чувствуешь ужасное горечь в горле! Тебя сейчас стошнит!")

/datum/surgery_step/stomach_pump/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_notice("[user] вызывает рвоту у [target_human] очищая его желудок от некоторых химических веществ!"),
			span_notice("[user] вызывает рвоту у [target_human] очищая его желудок от некоторых химических веществ!"),
			span_notice("[user] вызывает рвоту у [target_human]!"),
		)
		target_human.vomit((MOB_VOMIT_MESSAGE | MOB_VOMIT_STUN), lost_nutrition = 20, purge_ratio = 0.67) //higher purge ratio than regular vomiting
	return ..()

/datum/surgery_step/stomach_pump/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_warning("Ты облажался, [target_human] не вырвало!"),
			span_warning("[user] облажался, [target_human] не вырвало!"),
			span_warning("[user] облажался!"),
		)
		target_human.adjustOrganLoss(ORGAN_SLOT_STOMACH, 5)
		target_human.adjustBruteLoss(5)
