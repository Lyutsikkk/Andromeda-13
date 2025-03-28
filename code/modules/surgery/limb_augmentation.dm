
/////AUGMENTATION SURGERIES//////


//SURGERY STEPS

/datum/surgery_step/replace_limb
	name = "изменение конечности"
	implements = list(
		/obj/item/bodypart = 100,
		/obj/item/borg/apparatus/organ_storage = 100)
	time = 32
	var/obj/item/bodypart/target_limb


/datum/surgery_step/replace_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(HAS_TRAIT(target, TRAIT_NO_AUGMENTS))
		to_chat(user, span_warning("[target] не может быть дополнена!"))
		return SURGERY_STEP_FAIL
	if(istype(tool, /obj/item/borg/apparatus/organ_storage) && istype(tool.contents[1], /obj/item/bodypart))
		tool = tool.contents[1]
	var/obj/item/bodypart/aug = tool
	if(IS_ORGANIC_LIMB(aug))
		to_chat(user, span_warning("Это не дополнение, глупышка!"))
		return SURGERY_STEP_FAIL
	if(aug.body_zone != target_zone)
		to_chat(user, span_warning("[tool] неподходящий тип для [target.parse_zone_with_bodypart(target_zone)]."))
		return SURGERY_STEP_FAIL
	target_limb = surgery.operated_bodypart
	if(target_limb)
		display_results(
			user,
			target,
			span_notice("Вы начинаете дополнять [target.parse_zone_with_bodypart(user.zone_selected)]..."),
			span_notice("[user] начинает дополнять [target.parse_zone_with_bodypart(user.zone_selected)] с помощью [aug]."),
			span_notice("[user] начинает дополнять [target.parse_zone_with_bodypart(user.zone_selected)]."),
		)
		display_pain(target, "Вы чувствуете ужасную боль в [target.parse_zone_with_bodypart(user.zone_selected)]!")
	else
		user.visible_message(span_notice("[user] ищет [target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("Вы ищете [target.parse_zone_with_bodypart(user.zone_selected)]..."))


//ACTUAL SURGERIES

/datum/surgery/augmentation
	name = "Дополнение"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
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
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/replace_limb,
	)

//SURGERY STEP SUCCESSES

/datum/surgery_step/replace_limb/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/bodypart/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(target_limb)
		if(istype(tool, /obj/item/borg/apparatus/organ_storage))
			tool.icon_state = initial(tool.icon_state)
			tool.desc = initial(tool.desc)
			tool.cut_overlays()
			tool = tool.contents[1]
		if(istype(tool) && user.temporarilyRemoveItemFromInventory(tool))
			if(!tool.replace_limb(target))
				display_results(
					user,
					target,
					span_warning("Вам не удалось дополнить [target.parse_zone_with_bodypart(target_zone)]! Тело отклонило [tool]!"),
					span_warning("[user] не удается дополнить [target.parse_zone_with_bodypart(target_zone)]!"),
					span_warning("[user] не удается дополнить [target.parse_zone_with_bodypart(target_zone)]!"),
				)
				tool.forceMove(target.loc)
				return
		if(tool.check_for_frankenstein(target))
			tool.bodypart_flags |= BODYPART_IMPLANTED
		display_results(
			user,
			target,
			span_notice("Вы успешно дополняет [target.parse_zone_with_bodypart(target_zone)]."),
			span_notice("[user] успешно дополняет [target.parse_zone_with_bodypart(target_zone)] с помощью [tool]!"),
			span_notice("[user] успешно дополняет [target.parse_zone_with_bodypart(target_zone)]!"),
		)
		display_pain(target, "Ваша [target.parse_zone_with_bodypart(target_zone)] наполнена синтетическими ощущениями!", mechanical_surgery = TRUE)
		log_combat(user, target, "дополняет", addition="путем присвоения ему нового [target.parse_zone_with_bodypart(target_zone)] COMBAT MODE: [uppertext(user.combat_mode)]")
	else
		to_chat(user, span_warning("[target] нет органического [target.parse_zone_with_bodypart(target_zone)]!"))
	return ..()
