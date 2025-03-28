//open shell
/datum/surgery_step/mechanic_open
	name = "отвинтите корпус (отверткой или скальпелем)"
	implements = list(
		TOOL_SCREWDRIVER = 100,
		TOOL_SCALPEL = 75, // med borgs could try to unscrew shell with scalpel
		/obj/item/knife = 50,
		/obj/item = 10) // 10% success with any sharp item.
	time = 24
	preop_sound = 'sound/items/tools/screwdriver.ogg'
	success_sound = 'sound/items/tools/screwdriver2.ogg'

/datum/surgery_step/mechanic_open/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете отвинчивать оболочку объекта [target] в [target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user] начинает отвинчивать оболочку объекта [target] в [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] начинает отвинчивать оболочку объекта [target] в [target.parse_zone_with_bodypart(target_zone)]."),
	)
	display_pain(target, "Вы можете почувствовать, как ваша [target.parse_zone_with_bodypart(target_zone)] когда откручивается сенсорная панель.", TRUE)

/datum/surgery_step/mechanic_open/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE
	if(tool.usesound)
		preop_sound = tool.usesound

	return TRUE

//close shell
/datum/surgery_step/mechanic_close
	name = "завинтите корпус (отвертка или скальпель)"
	implements = list(
		TOOL_SCREWDRIVER = 100,
		TOOL_SCALPEL = 75,
		/obj/item/knife = 50,
		/obj/item = 10) // 10% success with any sharp item.
	time = 24
	preop_sound = 'sound/items/tools/screwdriver.ogg'
	success_sound = 'sound/items/tools/screwdriver2.ogg'

/datum/surgery_step/mechanic_close/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете подключать оболочку [target] к [target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user] начинает настраивать оболочку [target] к [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] начинает настраивать оболочку [target] к [target.parse_zone_with_bodypart(target_zone)]."),
	)
	display_pain(target, "Вы чувствуете, как возвращаются слабые ощущения, когда ваша панель [target.parse_zone_with_bodypart(target_zone)] завинчивается.", TRUE)

/datum/surgery_step/mechanic_close/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE
	if(tool.usesound)
		preop_sound = tool.usesound

	return TRUE

//prepare electronics
/datum/surgery_step/prepare_electronics
	name = "подготовьте электронику (мультитул или гемостат)"
	implements = list(
		TOOL_MULTITOOL = 100,
		TOOL_HEMOSTAT = 75)
	time = 24
	preop_sound = 'sound/items/taperecorder/tape_flip.ogg'
	success_sound = 'sound/items/taperecorder/taperecorder_close.ogg'

/datum/surgery_step/prepare_electronics/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете подготавливать электронику [target] в [target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user] начинает подготавливать электронику [target] в [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] начинает подготавливать электронику [target] в [target.parse_zone_with_bodypart(target_zone)]."),
	)
	display_pain(target, "Вы можете почувствовать слабое жужжание в вашем [target.parse_zone_with_bodypart(target_zone)] при перезагрузке электроники.", TRUE)

//unwrench
/datum/surgery_step/mechanic_unwrench
	name = "отвернуть болты (гаечным ключом или ретрактором)"
	implements = list(
		TOOL_WRENCH = 100,
		TOOL_RETRACTOR = 75)
	time = 24
	preop_sound = 'sound/items/tools/ratchet.ogg'

/datum/surgery_step/mechanic_unwrench/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете откручивать некоторые болты [target] в [target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user] начинает откручивать некоторые болты [target] в [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] начинает откручивать некоторые болты [target] в [target.parse_zone_with_bodypart(target_zone)]."),
	)
	display_pain(target, "Вы чувствуете толчок в вашей [target.parse_zone_with_bodypart(target_zone)] части тела, когда болты начинают ослабевать.", TRUE)

/datum/surgery_step/mechanic_unwrench/tool_check(mob/user, obj/item/tool)
	if(tool.usesound)
		preop_sound = tool.usesound

	return TRUE

//wrench
/datum/surgery_step/mechanic_wrench
	name = "закрутить болты (гаечным ключом или ретрактором)"
	implements = list(
		TOOL_WRENCH = 100,
		TOOL_RETRACTOR = 75)
	time = 24
	preop_sound = 'sound/items/tools/ratchet.ogg'

/datum/surgery_step/mechanic_wrench/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете закручивать некоторые болты [target] в [target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user] начинает закручивать некоторые болты [target] в [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] начинает закручивать некоторые болты [target] в [target.parse_zone_with_bodypart(target_zone)]."),
	)
	display_pain(target, "Вы чувствуете толчок в вашей [target.parse_zone_with_bodypart(target_zone)] части тела, когда болты начинают затягиваться.", TRUE)

/datum/surgery_step/mechanic_wrench/tool_check(mob/user, obj/item/tool)
	if(tool.usesound)
		preop_sound = tool.usesound

	return TRUE

//open hatch
/datum/surgery_step/open_hatch
	name = "открыть панель (рукой)"
	accept_hand = TRUE
	time = 10
	preop_sound = 'sound/items/tools/ratchet.ogg'
	preop_sound = 'sound/machines/airlock/doorclick.ogg'

/datum/surgery_step/open_hatch/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете открывать панель [target] в [target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user] начинает открывать панель [target] в [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] начинает открывать панель [target] в [target.parse_zone_with_bodypart(target_zone)]."),
	)
	display_pain(target, "Последние слабые тактильные ощущения исчезают у вас [target.parse_zone_with_bodypart(target_zone)] когда открывается панелька.", TRUE)

/datum/surgery_step/open_hatch/tool_check(mob/user, obj/item/tool)
	if(tool.usesound)
		preop_sound = tool.usesound

	return TRUE
