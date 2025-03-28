/obj/item/disk/surgery/sleeper_protocol
	name = "Диск с подозрительной хирургией"
	desc = "На диске содержатся инструкции о том, как превратить кого-либо в тайного агента Синдиката"
	surgeries = list(
		/datum/surgery/advanced/brainwashing_sleeper,
		/datum/surgery/advanced/brainwashing_sleeper/mechanic,
		)

/datum/surgery/advanced/brainwashing_sleeper
	name = "Хирургия спящего агента"
	desc = "Хирургическая процедура, при которой в мозг пациента внедряется протокол sleeper, что делает его абсолютным приоритетом. Это можно устранить с помощью имплантата mind shield."
	requires_bodypart_type = NONE
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/brainwash/sleeper_agent,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/brainwashing_sleeper/mechanic
	name = "Перепрограммирование спящего агента"
	desc = "Вредоносное ПО, которое напрямую внедряет директиву протокола sleeper в операционную систему робота-пациента, что делает его их абсолютным приоритетом. От него можно избавиться с помощью имплантата mind shield."
	requires_bodypart_type = BODYTYPE_ROBOTIC
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/brainwash/sleeper_agent/mechanic,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close,
	)

/datum/surgery/advanced/brainwashing_sleeper/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/organ/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE
	return TRUE

/datum/surgery_step/brainwash/sleeper_agent
	time = 25 SECONDS
	var/static/list/possible_objectives = list(
		"Ты любишь Синдикат!",
		"Не доверяй Нанотразену!",
		"Капитан - ящерица.",
		"Капитан - розовая вульпа..",
		"Нанотразен ненастоящий.",
		"Они что-то подсыпают в еду, чтобы ты забыл.",
		"Ты единственный реальный человек на станции.",
		"На станции было бы намного лучше, если бы больше людей кричали, кто-то должен что-то с этим сделать.",
		"У здешних руководителей плохие намерения по отношению к команде.",
		"Помочь команде? Что они вообще для тебя когда-нибудь делали?",
		"Твоя сумка стала легче? Держу пари, эти парни из службы безопасности что-то украли из нее. Иди и верни это.",
		"Командование некомпетентно, кто-то с РЕАЛЬНОЙ властью должен принять командование здесь.",
		"Киборги и искусственный интеллект преследуют вас. Что они планируют?",
	)

/datum/surgery_step/brainwash/sleeper_agent/mechanic
	name = "перепрограммирование (мультитул)"
	implements = list(
		TOOL_MULTITOOL = 85,
		TOOL_HEMOSTAT = 50,
		TOOL_WIRECUTTER = 50,
		/obj/item/stack/package_wrap = 35,
		/obj/item/stack/cable_coil = 15)
	preop_sound = 'sound/items/handling/surgery/hemostat1.ogg'
	success_sound = 'sound/items/handling/surgery/hemostat1.ogg'

/datum/surgery_step/brainwash/sleeper_agent/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	objective = pick(possible_objectives)
	display_results(
		user,
		target,
		span_notice("Вы начинаете промывать мозги [target]..."),
		span_notice("[user] начинает исправлять мозг [target]."),
		span_notice("[user] начинает выполнять операцию на мозге [target]."),
	)
	display_pain(target, "Ваша голова раскалывается от невообразимой боли!") // Same message as other brain surgeries

/datum/surgery_step/brainwash/sleeper_agent/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(target.stat == DEAD)
		to_chat(user, span_warning("Они должны быть живы, чтобы выполнить эту операцию!"))
		return FALSE
	. = ..()
	if(!.)
		return
	target.gain_trauma(new /datum/brain_trauma/mild/phobia/conspiracies(), TRAUMA_RESILIENCE_LOBOTOMY)
