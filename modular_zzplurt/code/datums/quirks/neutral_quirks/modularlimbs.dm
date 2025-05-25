#define MODLIMB_TIME_ADJUST 40

/datum/quirk/modularlimbs
	name = "Modular Limbs"
	desc = "Вы перенесли экспериментальную операцию по зацеплению связок, благодаря которой ваши конечности можно легко присоединять и отсоединять. К сожалению, это означает, что все остальные тоже могут изменять ваши конечности!"
	value = 0
	gain_text = span_notice("Кажется, что ваши конечности могут оторваться при небольшом усилии.")
	lose_text = span_notice("Ваши конечности чувствуют себя более прочно.")
	medical_record_text = "У пациента отсоединяемые конечности."
	mob_trait = TRAIT_MODULAR_LIMBS
	icon = FA_ICON_PUZZLE_PIECE

/datum/quirk/modularlimbs/add(client/client_source)
	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Add new quirk verb
	add_verb(quirk_mob,/mob/living/proc/alterlimbs)

	// Add limb modification traits
	quirk_mob.add_traits(list(
		TRAIT_EASYDISMEMBER,
		TRAIT_LIMBATTACHMENT,
	), TRAIT_MODULAR_LIMBS)

	// Self-amputation ability from Autotomy genetic
	// Define quirk action
	var/datum/action/cooldown/spell/modularlimbs/quirk_action = new

	// Grant quirk action
	quirk_action.Grant(quirk_holder)

/datum/quirk/modularlimbs/remove()
	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Remove quirk verb
	remove_verb(quirk_mob,/mob/living/proc/alterlimbs)

	// Remove limb modification traits
	quirk_mob.remove_traits(list(
		TRAIT_EASYDISMEMBER,
		TRAIT_LIMBATTACHMENT,
	), TRAIT_MODULAR_LIMBS)

	// Define quirk action
	var/datum/action/cooldown/spell/modularlimbs/quirk_action = new

	// Revoke quirk action
	quirk_action.Remove(quirk_holder)

// Variant of self amputation spell
/datum/action/cooldown/spell/modularlimbs
	// More descriptive text, with warning
	name = "Выброс случайной конечности"
	desc = "Выбросьте случайную конечность из своего тела."
	button_icon_state = "autotomy"

	cooldown_time = 1 SECONDS
	spell_requirements = NONE
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS

	// Default ability background
	background_icon = 'icons/mob/actions/backgrounds.dmi'
	background_icon_state = ACTION_BUTTON_DEFAULT_BACKGROUND
	overlay_icon = 'icons/mob/actions/backgrounds.dmi'
	overlay_icon_state = null

/datum/action/cooldown/spell/modularlimbs/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/modularlimbs/cast(mob/living/carbon/cast_on)
	. = ..()
	if(HAS_TRAIT(cast_on, TRAIT_NODISMEMBER))
		to_chat(cast_on, span_notice("Вы очень сильно концентрируетесь, но ничего не происходит."))
		return

	var/list/parts = list()
	for(var/obj/item/bodypart/to_remove as anything in cast_on.bodyparts)
		if(to_remove.body_zone == BODY_ZONE_HEAD || to_remove.body_zone == BODY_ZONE_CHEST)
			continue
		if(to_remove.bodypart_flags & BODYPART_UNREMOVABLE)
			continue
		parts += to_remove

	if(!length(parts))
		to_chat(cast_on, span_notice("Вы не можете больше отбрасывать конечности!"))
		return

	var/obj/item/bodypart/to_remove = pick(parts)
	to_remove.drop_limb()
	playsound(cast_on, 'sound/effects/cartoon_sfx/cartoon_pop.ogg', 70)

// New verb to alter limbs
/mob/living/proc/alterlimbs()
	// Verb definitions
	set name = "Изменение конечностей"
	set desc = "Удалите или прикрепите конечность!"
	set category = "IC"
	set src in view(usr.client)

	// Define mobs involved
	var/mob/living/carbon/human/mob_initiator = usr
	var/mob/living/carbon/human/mob_target = src

	// Check for self-interacting
	// This causes a runtime error
	if(mob_initiator == mob_target)
		// Alert initiator and return
		to_chat(mob_initiator, span_warning("Вы не можете изменить свои собственные конечности! Попросите кого-нибудь другого о помощи."))
		return

	// Check if initiator is adjacent
	if(!mob_target.Adjacent(mob_initiator))
		// Alert initiator and return
		to_chat(mob_initiator, span_warning("Для этого вы должны находиться рядом с [mob_target]!"))
		return

	// Note: Limb attachment is redundant with TRAIT_LIMBATTACHMENT

	// Define item held by initiator
	var/obj/item/held_initiator = mob_initiator.get_active_held_item()
	var/obj/item/bodypart/part_held = held_initiator

	// Check if held item is a body part
	if(part_held)
		// Check if a limb already exists
		if(mob_target.get_bodypart(part_held.body_zone))
			// Alert initiator and return
			to_chat(mob_initiator, span_warning("У [mob_target.p_They()] уже [mob_target.p_have()] есть прикрепленная конечность!"))
			return

		// Limb does not already exist!
		// Alert target of interaction attempt
		mob_target.visible_message(span_warning("[mob_initiator]  пытается прикрепить \the [part_held] к [mob_target]!"), span_userdanger("[mob_initiator] пытается прикрепить \the [part_held] к вам!"))

		// Attempt interaction timer
		if(do_after(mob_initiator, MODLIMB_TIME_ADJUST, target = mob_target))
			// Attempt to attach limb
			part_held.try_attach_limb(mob_target)

			// Alert users and return
			mob_target.visible_message(span_warning("[mob_initiator] успешно прикрепляет \the [part_held] к [mob_target]"), span_warning("[mob_initiator] успешно прикрепил \the [part_held.name] к вам; вы можете снова использовать эту конечность!"))
			return

		// Interaction timer failed
		else
			// Alert users and return
			to_chat(mob_initiator, span_warning("Вы и [mob_target] должны оба стоять неподвижно, чтобы вы могли изменить их конечности!"))
			return

	// Initiator is not holding a body part!

	// Check for valid target region
	if(mob_initiator.zone_selected == BODY_ZONE_CHEST || mob_initiator.zone_selected == BODY_ZONE_HEAD)
		// Alert initiator and return
		to_chat(mob_initiator, span_warning("Вы должны выбрать руку или ногу!"))
		return
	if(mob_initiator.zone_selected == BODY_ZONE_PRECISE_GROIN || mob_initiator.zone_selected == BODY_ZONE_PRECISE_EYES || mob_initiator.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		// Alert initiator and return
		to_chat(mob_initiator, span_warning("Здесь нет конечности; выберите руку или ногу!"))
		return

	// Define target body part
	var/obj/item/bodypart/part_target = mob_target.get_bodypart(mob_initiator.zone_selected)

	// Check if the limb exists to be removed
	if(!part_target)
		// Alert initiator and return
		to_chat(mob_initiator, span_warning("[mob_target.p_They()] [mob_target.p_are()] уже лишен этой конечности!"))
		return

	// Check if part is irremovable
	if(part_target.bodypart_flags & BODYPART_UNREMOVABLE)
		// Alert initiator and return
		to_chat(mob_initiator, span_warning("[mob_target.p_Their()] конечность прикреплена слишком прочно!"))
		return

	// Region is valid and has a limb!

	// Define body part name
	var/part_name = part_target.name

	// Alert users of interaction attempt
	mob_target.visible_message(span_warning("[mob_initiator] пытается отсоединить [mob_target] [part_name]!"), span_userdanger("[mob_initiator] пытается отсоединить вашу [part_name]!"))

	// Attempt interaction timer
	if(do_after(mob_initiator, MODLIMB_TIME_ADJUST, target = mob_target))
		// Define target again
		var/obj/item/bodypart/part_target_check = mob_target.get_bodypart(mob_initiator.zone_selected)

		// Check if redefined target matches
		if(part_target != part_target_check)
			// Alert initiator and return
			to_chat(mob_initiator, span_warning("Вы не можете выбрать другую конечность, когда уже убрали одну!"))
			return

		// Remove targeted limb
		part_target_check.drop_limb()

		// Play sound effect
		// Taken from admin panel
		playsound(mob_target, 'sound/effects/cartoon_sfx/cartoon_pop.ogg', 70)

		// Update target's equipment
		mob_target.update_equipment_speed_mods()

		// Alert users and return
		mob_target.visible_message(span_warning("[mob_initiator] принудительно отключает [mob_target]'s [part_name]!"), span_userdanger("[mob_initiator] принудительно отключил вашу [part_name]!"))
		return

	// Interaction timer failed
	else
		// Alert users and return
		to_chat(mob_initiator, span_warning("Вы и [mob_target] должны оба стоять неподвижно, чтобы вы могли изменить их конечности!"))
		return

#undef MODLIMB_TIME_ADJUST
