
/////BONE FIXING SURGERIES//////

///// Repair Hairline Fracture (Severe)
/datum/surgery/repair_bone_hairline
	name = "Восстановление перелома кости"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/blunt/bone/severe
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
		/datum/surgery_step/repair_bone_hairline,
		/datum/surgery_step/close,
	)

///// Repair Compound Fracture (Critical)
/datum/surgery/repair_bone_compound
	name = "Восстанавливать сложный перелом"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/blunt/bone/critical
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
		/datum/surgery_step/reset_compound_fracture,
		/datum/surgery_step/repair_bone_compound,
		/datum/surgery_step/close,
	)

//SURGERY STEPS

///// Repair Hairline Fracture (Severe)
/datum/surgery_step/repair_bone_hairline
	name = "repair hairline fracture (костоправ/костный гель/пластырь)"
	implements = list(
		TOOL_BONESET = 100,
		/obj/item/stack/medical/bone_gel = 100,
		/obj/item/stack/sticky_tape/surgical = 100,
		/obj/item/stack/sticky_tape/super = 50,
		/obj/item/stack/sticky_tape = 30)
	time = 40

/datum/surgery_step/repair_bone_hairline/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("Вы начинаете восстанавливать перелом в [target.parse_zone_with_bodypart(user.zone_selected)]..."),
			span_notice("[user] начинает восстанавливать перелом в [target.parse_zone_with_bodypart(user.zone_selected)] с помощью [tool]."),
			span_notice("[user] начинает восстанавливать перелом в [target.parse_zone_with_bodypart(user.zone_selected)]."),
		)
		display_pain(target, "Ваш/а [target.parse_zone_with_bodypart(user.zone_selected)] страдает от боли!")
	else
		user.visible_message(span_notice("[user] ищет объект [target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("Вы ищете объект [target.parse_zone_with_bodypart(user.zone_selected)]..."))

/datum/surgery_step/repair_bone_hairline/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(
			user,
			target,
			span_notice("Вы успешно устранили перелом в [target.parse_zone_with_bodypart(target_zone)]."),
			span_notice("[user] успешно устранил перелом в [target.parse_zone_with_bodypart(target_zone)] с помощью [tool]!"),
			span_notice("[user] успешно устранил перелом в [target.parse_zone_with_bodypart(target_zone)]!"),
		)
		log_combat(user, target, "залечил перелом", addition="COMBAT_MODE: [uppertext(user.combat_mode)]")
		qdel(surgery.operated_wound)
	else
		to_chat(user, span_warning("[target] нет перелома!"))
	return ..()

/datum/surgery_step/repair_bone_hairline/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)



///// Reset Compound Fracture (Crticial)
/datum/surgery_step/reset_compound_fracture
	name = "вправить кость (костоправ)"
	implements = list(
		TOOL_BONESET = 100,
		/obj/item/stack/sticky_tape/surgical = 60,
		/obj/item/stack/sticky_tape/super = 40,
		/obj/item/stack/sticky_tape = 20)
	time = 40

/datum/surgery_step/reset_compound_fracture/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("Вы начинаете вправлять кость в [target.parse_zone_with_bodypart(user.zone_selected)]..."),
			span_notice("[user] начинает вправлять кости в [target.parse_zone_with_bodypart(user.zone_selected)] с помощью [tool]."),
			span_notice("[user] начинает вправлять кости в [target.parse_zone_with_bodypart(user.zone_selected)]."),
		)
		display_pain(target, "начинает вправлять кость в [target.parse_zone_with_bodypart(user.zone_selected)] это ошеломляет!")
	else
		user.visible_message(span_notice("[user] ищет [target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("Вы ищете [target.parse_zone_with_bodypart(user.zone_selected)]..."))

/datum/surgery_step/reset_compound_fracture/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(
			user,
			target,
			span_notice("Вы успешно восстановили кость в [target.parse_zone_with_bodypart(target_zone)]."),
			span_notice("[user] успешно восстановил кость в [target.parse_zone_with_bodypart(target_zone)] с помощью [tool]!"),
			span_notice("[user] успешно восстановил кость в [target.parse_zone_with_bodypart(target_zone)]!"),
		)
		log_combat(user, target, "восстановление сложного перелома в", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
	else
		to_chat(user, span_warning("[target] нет сложного перелома!"))
	return ..()

/datum/surgery_step/reset_compound_fracture/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)

#define IMPLEMENTS_THAT_FIX_BONES list( \
	/obj/item/stack/medical/bone_gel = 100, \
	/obj/item/stack/sticky_tape/surgical = 100, \
	/obj/item/stack/sticky_tape/super = 50, \
	/obj/item/stack/sticky_tape = 30, \
)


///// Восстановление сложного перелома (критического)
/datum/surgery_step/repair_bone_compound
	name = "восстановление сложного перелома (костный гель/пластырь)"
	implements = IMPLEMENTS_THAT_FIX_BONES
	time = 40

/datum/surgery_step/repair_bone_compound/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("Вы начинаете восстанавливать перелом в [target.parse_zone_with_bodypart(user.zone_selected)]..."),
			span_notice("[user] начинает восстанавливать перелом в [target.parse_zone_with_bodypart(user.zone_selected)] с помощью [tool]."),
			span_notice("[user] начинает восстанавливать перелом в [target.parse_zone_with_bodypart(user.zone_selected)]."),
		)
		display_pain(target, "Ноющая боль в вашей [target.parse_zone_with_bodypart(user.zone_selected)] просто невыносима")
	else
		user.visible_message(span_notice("[user] ищет [target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("Вы ищете [target.parse_zone_with_bodypart(user.zone_selected)]..."))

/datum/surgery_step/repair_bone_compound/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(
			user,
			target,
			span_notice("Вы успешно устранили перелом в [target.parse_zone_with_bodypart(target_zone)]."),
			span_notice("[user] успешно устранил перелом в [target.parse_zone_with_bodypart(target_zone)] с помощью [tool]!"),
			span_notice("[user] успешно устранил перелом в [target.parse_zone_with_bodypart(target_zone)]!"),
		)
		log_combat(user, target, "восстановлен сложный перелом в", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
		qdel(surgery.operated_wound)
	else
		to_chat(user, span_warning("[target] нет сложного перелома!"))
	return ..()

/datum/surgery_step/repair_bone_compound/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)

/// Операция по устранению трещин черепа
/datum/surgery/cranial_reconstruction
	name = "Реконструкция черепа"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/cranial_fissure
	possible_locs = list(
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/clamp_bleeders/discard_skull_debris,
		/datum/surgery_step/repair_skull
	)

/datum/surgery_step/clamp_bleeders/discard_skull_debris
	name = "удалить осколки черепа (гемостат)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_WIRECUTTER = 40,
		TOOL_SCREWDRIVER = 40,
	)
	time = 2.4 SECONDS
	preop_sound = 'sound/items/handling/surgery/hemostat1.ogg'

/datum/surgery_step/clamp_bleeders/discard_skull_debris/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете удалять мелкие фрагменты черепа в [target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user] начинает удалять мелкие фрагменты черепа в [target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user] начинает копаться в [target.parse_zone_with_bodypart(target_zone)]..."),
	)

	display_pain(target, "Ваш мозг чувствует себя так, словно в него вонзаются маленькие осколки стекла!")

/datum/surgery_step/repair_skull
	name = "восстановление черепа (костный гель/пластырь)"
	implements = IMPLEMENTS_THAT_FIX_BONES
	time = 4 SECONDS

/datum/surgery_step/repair_skull/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	ASSERT(surgery.operated_wound, "Восстановление черепа без раны")

	display_results(
		user,
		target,
		span_notice("Вы начинаете восстанавливать череп [target] насколько это возможно..."),
		span_notice("[user] начинает восстанавливать череп [target] с помощью [tool]."),
		span_notice("[user] начинает восстанавливать череп [target]."),
	)

	display_pain(target, "Вы можете почувствовать, как осколки вашего черепа трутся о ваш мозг!")

/datum/surgery_step/repair_skull/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if (isnull(surgery.operated_wound))
		to_chat(user, span_warning("Череп [target] в порядке!"))
		return ..()


	if (isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)

	display_results(
		user,
		target,
		span_notice("Вы успешно восстановили череп [target]."),
		span_notice("[user] успешно восстановил череп [target] с помощью [tool]."),
		span_notice("[user] успешно восстановил череп [target].")
	)

	qdel(surgery.operated_wound)

	return ..()

#undef IMPLEMENTS_THAT_FIX_BONES
