
/////ОПЕРАЦИИ ПО УСТРАНЕНИЮ ОЖОГОВ//////

//номера этапов каждого из этих двух, в настоящее время мы используем только первый, чтобы переключаться между ними из-за продвижения вперед после завершения этапов в любом случае
#define REALIGN_INNARDS 1
#define WELD_VEINS 2

///// Заживление колотых ран
/datum/surgery/repair_puncture
	name = "Отремонтировать прокол"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/pierce/bleed
	target_mobtypes = list(/mob/living/carbon)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/repair_innards,
		/datum/surgery_step/seal_veins,
		/datum/surgery_step/close,
	)

/datum/surgery/repair_puncture/can_start(mob/living/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return .

	var/datum/wound/pierce/bleed/pierce_wound = target.get_bodypart(user.zone_selected).get_wound_type(targetable_wound)
	ASSERT(pierce_wound, "[type] на [target] е имеет пробивной раны, в то время как can_start должен был гарантировать ее наличие")
	return pierce_wound.blood_flow > 0

//SURGERY STEPS

///// realign the blood vessels so we can reweld them
/datum/surgery_step/repair_innards
	name = "восстанавливает кровеносные сосуды (гемостат)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCALPEL = 85,
		TOOL_WIRECUTTER = 40)
	time = 3 SECONDS
	preop_sound = 'sound/items/handling/surgery/hemostat1.ogg'
	surgery_effects_mood = TRUE

/datum/surgery_step/repair_innards/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		user.visible_message(span_notice("[user] ище [target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("Вы ищете [target.parse_zone_with_bodypart(user.zone_selected)]..."))
		return

	if(pierce_wound.blood_flow <= 0)
		to_chat(user, span_notice("[target]'s [target.parse_zone_with_bodypart(user.zone_selected)] нет проблем с исправлением!"))
		surgery.status++
		return

	display_results(
		user,
		target,
		span_notice("Вы начинаете восстанавливать поврежденные кровеносные сосуды в [target.parse_zone_with_bodypart(user.zone_selected)]..."),
		span_notice("[user] начинает восстанавливать поврежденные кровеносные сосуды в [target.parse_zone_with_bodypart(user.zone_selected)] с помощью [tool]."),
		span_notice("[user] начинает восстанавливать поврежденные кровеносные сосуды в [target.parse_zone_with_bodypart(user.zone_selected)]."),
	)
	display_pain(target, "Вы чувствуете ужасную колющую боль в [target.parse_zone_with_bodypart(user.zone_selected)]!")

/datum/surgery_step/repair_innards/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		to_chat(user, span_warning("[target] там нет колотой раны!"))
		return ..()

	display_results(
		user,
		target,
		span_notice("Вы успешно восстановили некоторые кровеносные сосуды в [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] успешно восстановил некоторые кровеносные сосуды в [target.parse_zone_with_bodypart(target_zone)] с помощью [tool]!"),
		span_notice("[user] успешно восстановил некоторые кровеносные сосуды в [target.parse_zone_with_bodypart(target_zone)]!"),
	)
	log_combat(user, target, "восстановленные кровеносные сосуды в", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
	target.apply_damage(3, BRUTE, surgery.operated_bodypart, wound_bonus = CANT_WOUND, sharpness = SHARP_EDGED, attacking_item = tool)
	pierce_wound.adjust_blood_flow(-0.25)
	return ..()

/datum/surgery_step/repair_innards/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	. = ..()
	display_results(
		user,
		target,
		span_notice("Вы разрываете некоторые кровеносные сосуды в [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] разрывает некоторые кровеносные сосуды в [target.parse_zone_with_bodypart(target_zone)] с помощью [tool]!"),
		span_notice("[user] разрывает некоторые кровеносные сосуды в [target.parse_zone_with_bodypart(target_zone)]!"),
	)
	target.apply_damage(rand(4, 8), BRUTE, surgery.operated_bodypart, wound_bonus = 10, sharpness = SHARP_EDGED, attacking_item = tool)

///// Sealing the vessels back together
/datum/surgery_step/seal_veins
	name = "сращивание вен (прижигание)" // если ваш врач говорит, что они собираются снова сращивать ваши кровеносные сосуды, вы либо А) принимаете SS13, либо Б) подвергаетесь серьезной смертельной опасности
	implements = list(
		TOOL_CAUTERY = 100,
		/obj/item/gun/energy/laser = 90,
		TOOL_WELDER = 70,
		/obj/item = 30)
	time = 4 SECONDS
	preop_sound = 'sound/items/handling/surgery/cautery1.ogg'
	success_sound = 'sound/items/handling/surgery/cautery2.ogg'

/datum/surgery_step/seal_veins/tool_check(mob/user, obj/item/tool)
	if(implement_type == TOOL_WELDER || implement_type == /obj/item)
		return tool.get_temperature()

	return TRUE

/datum/surgery_step/seal_veins/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		user.visible_message(span_notice("[user] ищет [target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("Вы ищите [target.parse_zone_with_bodypart(user.zone_selected)]..."))
		return
	display_results(
		user,
		target,
		span_notice("Вы начинаете сращивать некоторые из разделенных кровеносных сосудов в [target.parse_zone_with_bodypart(user.zone_selected)]..."),
		span_notice("[user] начинает сращивать некоторые из разделенных кровеносных сосудов в [target.parse_zone_with_bodypart(user.zone_selected)] с помощью [tool]."),
		span_notice("[user] начинает сращивать некоторые из разделенных кровеносных сосудов в [target.parse_zone_with_bodypart(user.zone_selected)]."),
	)
	display_pain(target, "Вы сгораете внутри вашей [target.parse_zone_with_bodypart(user.zone_selected)]!")

/datum/surgery_step/seal_veins/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		to_chat(user, span_warning("у [target] там нет прокола!"))
		return ..()

	display_results(
		user,
		target,
		span_notice("Вы успешно объединили некоторые разделенные кровеносные сосуды в [target.parse_zone_with_bodypart(target_zone)] с помощью [tool]."),
		span_notice("[user] успешно объединил некоторые разделенные кровеносные сосуды в [target.parse_zone_with_bodypart(target_zone)] с помощью [tool]!"),
		span_notice("[user] успешно объединил некоторые разделенные кровеносные сосуды в [target.parse_zone_with_bodypart(target_zone)]!"),
	)
	log_combat(user, target, "ожоги обёрнуты в", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
	pierce_wound.adjust_blood_flow(-0.5)
	if(!QDELETED(pierce_wound) && pierce_wound.blood_flow > 0)
		surgery.status = REALIGN_INNARDS
		to_chat(user, span_notice("<i>Кажется, кровеносные сосуды все еще не объединены, чтобы закончить...</i>"))
	else
		to_chat(user, span_green("Вы устранили все внутренние повреждения в [target.parse_zone_with_bodypart(target_zone)]!"))
	return ..()

#undef REALIGN_INNARDS
#undef WELD_VEINS
