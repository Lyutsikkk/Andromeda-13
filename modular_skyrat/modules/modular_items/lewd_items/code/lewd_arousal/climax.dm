//SPLURT EDIT REMOVAL BEGIN - Interactions - Moved climax defines to global defines
/*
#define CLIMAX_VAGINA "Vagina"
#define CLIMAX_PENIS "Penis"
#define CLIMAX_BOTH "Both"
*/
//SPLURT EDIT REMOVAL END

#define CLIMAX_ON_FLOOR "На пол"
#define CLIMAX_IN_OR_ON "Кульминация на/в кого то"
#define CLIMAX_OPEN_CONTAINER "Заполнить контейнер для реагентов"

/mob/living/proc/climax(manual = TRUE, mob/living/partner = null, datum/interaction/climax_interaction = null, interaction_position = null) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	if (CONFIG_GET(flag/disable_erp_preferences))
		return

	var/nonhuman_bypass_self = !ishuman(src) && !src.client && !SSinteractions.is_blacklisted(src) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	var/nonhuman_bypass_partner = !ishuman(partner) && !partner?.client && !SSinteractions.is_blacklisted(partner) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable

	if(!(client?.prefs?.read_preference(/datum/preference/toggle/erp/autocum) || nonhuman_bypass_self) && !manual)
		return
	if(refractory_period > REALTIMEOFDAY)
		return
	refractory_period = REALTIMEOFDAY + 30 SECONDS
	if(has_status_effect(/datum/status_effect/climax_cooldown) || !(client?.prefs?.read_preference(/datum/preference/toggle/erp) || nonhuman_bypass_self))
		return

	if(HAS_TRAIT(src, TRAIT_NEVERBONER) || has_status_effect(/datum/status_effect/climax_cooldown) || (!has_vagina() && !has_penis()))
		visible_message(span_purple("[src] дергается, пытаясь кончить, но безрезультатно."), \
			span_purple("Вы не можете кончить!"))
		return TRUE

	// Reduce pop-ups and make it slightly more frictionless (lewd).
	var/climax_choice = has_penis() ? CLIMAX_PENIS : CLIMAX_VAGINA

	if(manual)
		var/list/genitals = list()
		if(has_vagina())
			genitals.Add(CLIMAX_VAGINA)
			if(has_penis())
				genitals.Add(CLIMAX_PENIS)
				genitals.Add(CLIMAX_BOTH)
		else if(has_penis())
			genitals.Add(CLIMAX_PENIS)
		climax_choice = tgui_alert(src, "Вы достигаете кульминации, выберите, какими гениталиями вы будете кончать.", "Предпочтение гениталий!", genitals)
	else if(istype(climax_interaction, /datum/interaction) && climax_interaction.cum_genital?.len && climax_interaction.cum_genital[interaction_position])
		climax_choice = climax_interaction.cum_genital[interaction_position]
	conditional_pref_sound(get_turf(src), 'modular_zzplurt/sound/interactions/end.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
	//SPLURT EDIT ADDITION END
	switch(gender)
		if(MALE)
			conditional_pref_sound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_m1.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m2.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
		if(FEMALE)
			conditional_pref_sound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_f1.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f2.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f3.ogg'), 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)

	var/self_orgasm = FALSE
	var/self_their = p_their()

	if(climax_choice == CLIMAX_PENIS || climax_choice == CLIMAX_BOTH)
		var/obj/item/organ/genital/penis/penis = get_organ_slot(ORGAN_SLOT_PENIS)
		if(!get_organ_slot(ORGAN_SLOT_TESTICLES) && ishuman(src)) //If we have no god damn balls, we can't cum anywhere... GET BALLS! // SPLURT EDIT - Interactions
			visible_message(span_userlove("[src] оргазмирует, но из [self_their] пениса ничего не выходит!"), \
				span_userlove("Вы испытываете оргазм, ощущения великолепные, но из вашего пениса ничего не выходит!"))

		else if(is_wearing_condom())
			var/obj/item/clothing/sextoy/condom/condom = src:penis // bruh 💀⚰️💀⚰️💀⚰️💀⚰️💀
			condom.condom_use()
			visible_message(span_userlove("[src] кончает [self_their] заполняя [condom] до отказа!"), \
				span_userlove("Вы выплёскиваете липкую жидкость в [condom] и он заполняется!"))

		else if(!is_bottomless() && penis.visibility_preference != GENITAL_ALWAYS_SHOW)
			visible_message(span_userlove("[src] кончает внутрь [self_their] одежды!"), \
				span_userlove("Вы кончили, но вы не были голыми, поэтому запачкали свою одежду!"))
			self_orgasm = TRUE

		else
			var/list/interactable_inrange_mobs = list()
			var/target_choice //SPLURT EDIT CHANGE - Interactions
			// monkey see, monkey do
			var/list/interactable_inrange_open_containers = list()

			// Unfortunately prefs can't be checked here, because byond/tgstation moment.
			for(var/mob/living/iterating_mob in (view(1, src) - src))
				interactable_inrange_mobs[iterating_mob.name] = iterating_mob

			// this should be making a list of cups(?)
			for(var/obj/item/reagent_containers/cup/iterating_open_container in (view(1, src) - src))
				interactable_inrange_open_containers[iterating_open_container.name] = iterating_open_container

			var/list/buttons = list(CLIMAX_ON_FLOOR)
			if(interactable_inrange_mobs.len)
				buttons += CLIMAX_IN_OR_ON

			var/penis_climax_choice = climax_interaction && !manual ? CLIMAX_IN_OR_ON : tgui_alert(src, "Выберите куда будете стрелять.", "Загрузить предпочтения", buttons) //SPLURT EDIT CHANGE - Interactions

			var/create_cum_decal = FALSE

			if(!penis_climax_choice || penis_climax_choice == CLIMAX_ON_FLOOR)
				create_cum_decal = TRUE
				visible_message(span_userlove("[src] стреляет [self_their] липким семенем на пол!"), \
					span_userlove("Вы выстреливаете струю за струей, попадая на пол!"))

			else
				target_choice = climax_interaction && !manual ? partner?.name : tgui_input_list(src, "Выберите человека, в которого можно кончить или на которого можно кончить.", "Выберите цель!", interactable_inrange_mobs) //SPLURT EDIT CHANGE - Interactions
				if(!target_choice)
					create_cum_decal = TRUE
					visible_message(span_userlove("[src] выстреливает [self_their] горячей спермой на пол!"), \
						span_userlove("Вы выпускаете струю за струёй горячей спермы, попадая на пол!"))
				else
					var/mob/living/target_mob = climax_interaction && !manual && partner ? partner : interactable_inrange_mobs[target_choice] //SPLURT EDIT CHANGE - Interactions
					var/target_mob_them = target_mob.p_them()

					var/list/target_buttons = list()

					if(istype(target_mob, /mob/living/carbon/human))
						var/mob/living/carbon/human/target_human = target_mob
						if(!target_human.wear_mask)
							target_buttons += "рот"
					else
						target_buttons += "рот"
					if(target_mob.has_vagina(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_VAGINA
					if(target_mob.has_anus(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_ANUS //SPLURT EDIT CHANGE - Interactions - Changed asshole to anus for consistency
					if(target_mob.has_penis(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_PENIS
						var/obj/item/organ/genital/penis/other_penis = target_mob.get_organ_slot(ORGAN_SLOT_PENIS)
						if(other_penis.sheath != "None")
							target_buttons += "sheath"
					target_buttons += "На [target_mob_them]"

					//SPLURT EDIT CHANGE BEGIN - Interactions
					var/climax_into_choice
					var/interaction_inside = partner?.get_organ_slot(climax_interaction?.cum_target[interaction_position])
					if(!interaction_inside)
						interaction_inside = target_buttons.Find(climax_interaction?.cum_target[interaction_position])
						if(interaction_inside)
							interaction_inside = climax_interaction.cum_target[interaction_position]
					else
						var/obj/item/organ/genital = interaction_inside
						interaction_inside = genital.slot

					if(climax_interaction && !manual && interaction_inside)
						climax_into_choice = climax_interaction.cum_target[interaction_position]
					else if(manual)
						climax_into_choice = tgui_input_list(src, "Куда в/на [target_mob] ты хочешь кончить?", "Куда кончить?", target_buttons)
					else
						climax_into_choice = "На [target_mob_them]"

					if(climax_interaction && !manual && climax_interaction.show_climax(src, target_mob, interaction_position))
						create_cum_decal = !interaction_inside
					else if(!climax_into_choice)
					//SPLURT EDIT CHANGE END
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] выстреливает горячей спермой на пол!"), \
							span_userlove("Вы выпускаете струю за струёй горячей спермы, попадая на пол!"))
						conditional_pref_sound(get_turf(src), 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
					else if(climax_into_choice == "На [target_mob_them]")
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] выстреливает своей горячей спермой в [target_mob]!"), \
							span_userlove("Вы выпускаете струю за струёй горячей спермы на [target_mob]!"))
						conditional_pref_sound(get_turf(src), 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
					else
						visible_message(span_userlove("[src] вонзает [self_their] член в [target_mob] [climax_into_choice], выстреливая горячей спермой в [target_mob_them]!"), \
							span_userlove("Вы вонзаете свой член в [target_mob] [climax_into_choice], выстреливая горячей спермой в [target_mob_them]!"))
						to_chat(target_mob, span_userlove("Ваша [climax_into_choice]наполняется теплой, когда [src] кончает в [self_their]."))
						conditional_pref_sound(get_turf(target_mob), climax_into_choice == "рот" ? pick('modular_zzplurt/sound/interactions/mouthend (1).ogg', 'modular_zzplurt/sound/interactions/mouthend (2).ogg') : 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
						//SPLURT EDIT ADDITION BEGIN - Genital Inflation and pregnancy
						var/datum/component/interactable/interactable = target_mob.GetComponent(/datum/component/interactable)
						if(interactable)
							interactable.climax_inflate_genital(src, "testicles", climax_into_choice)
						var/client/preference_source = GET_CLIENT(target_mob)
						#ifdef TESTING
						if(!preference_source)
							preference_source = GET_CLIENT(src)
						#endif
						if(ishuman(target_mob) && preference_source && \
							!HAS_TRAIT(src, TRAIT_INFERTILE) && !HAS_TRAIT(target_mob, TRAIT_INFERTILE))
							var/genital_pass = FALSE
							switch(interaction_inside)
								if(ORGAN_SLOT_ANUS)
									genital_pass = preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/anal_insemination)
								if(ORGAN_SLOT_VAGINA)
									genital_pass = preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/vaginal_insemination)
								if(CLIMAX_TARGET_MOUTH)
									genital_pass = preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/oral_insemination)
							if(genital_pass && prob(preference_source.prefs.read_preference(/datum/preference/numeric/pregnancy/chance)))
								target_mob.apply_status_effect(/datum/status_effect/pregnancy, target_mob, src)
						//SPLURT EDIT ADDITION END

			var/obj/item/organ/genital/testicles/testicles = get_organ_slot(ORGAN_SLOT_TESTICLES)
			//SPLURT EDIT CHANGE BEGIN - Interactions
			if(!(climax_interaction?.interaction_modifier_flags & INTERACTION_OVERRIDE_FLUID_TRANSFER) && ishuman(src))
				if(create_cum_decal)
					if(HAS_TRAIT(src, TRAIT_MESSY))
						// Transfer reagents to the turf using liquids system
						var/datum/reagents/R = new(testicles.internal_fluid_maximum)
						testicles.transfer_internal_fluid(R, testicles.internal_fluid_count * 0.6)
						if(partner && partner != src)
							// Get turf between src and partner for directional splatter
							var/turf/T = get_turf(partner)
							T.add_liquid_from_reagents(R, FALSE, 1, get_turf(src), partner)
						else
							var/turf/T = get_turf(src)
							T.add_liquid_from_reagents(R, FALSE, 1)
						qdel(R)
					else
						testicles.transfer_internal_fluid(null, testicles.internal_fluid_count * 0.6)
						add_cum_splatter_floor(get_turf(src), cum_reagent = testicles.internal_fluid_datum)
				else if(partner || interactable_inrange_mobs[target_choice])
					// Transfer reagents directly to partner
					var/mob/living/target_mob = partner || interactable_inrange_mobs[target_choice]

					//Check if the target has custom genital fluids enabled
					var/datum/reagent/original_fluid_datum = testicles.internal_fluid_datum
					if(!(target_mob.client?.prefs?.read_preference(/datum/preference/toggle/erp/custom_genital_fluids) || nonhuman_bypass_partner))
						testicles.internal_fluid_datum = initial(testicles.internal_fluid_datum)

					var/datum/reagents/R = new(testicles.internal_fluid_maximum)
					testicles.transfer_internal_fluid(R, testicles.internal_fluid_count * 0.6)
					R.trans_to(target_mob, R.total_volume)

					testicles.internal_fluid_datum = original_fluid_datum
					qdel(R)
				else
					testicles.transfer_internal_fluid(null, testicles.internal_fluid_count * 0.6)
			//SPLURT EDIT CHANGE END

		try_lewd_autoemote("moan")
		if(climax_choice == CLIMAX_PENIS)
			apply_status_effect(/datum/status_effect/climax)
			apply_status_effect(/datum/status_effect/climax_cooldown)
			if(self_orgasm)
				add_mood_event("orgasm", /datum/mood_event/climaxself)
			return TRUE

	if(climax_choice == CLIMAX_VAGINA || climax_choice == CLIMAX_BOTH)
		var/obj/item/organ/genital/vagina/vagina = get_organ_slot(ORGAN_SLOT_VAGINA)
		//SPLURT EDIT CHANGE BEGIN - Interactions
		if(!is_bottomless() && vagina.visibility_preference != GENITAL_ALWAYS_SHOW)
			visible_message(span_userlove("[src] кончает в [self_their] нижнее белье из [self_their] вагины!"), \
					span_userlove("Вы кончаете в нижнее белье из своего влагалища!"))
			self_orgasm = TRUE
		else
			var/list/interactable_inrange_mobs = list()
			var/target_choice //SPLURT EDIT CHANGE - Interactions

			for(var/mob/living/iterating_mob in (view(1, src) - src))
				interactable_inrange_mobs[iterating_mob.name] = iterating_mob

			var/list/buttons = list(CLIMAX_ON_FLOOR)
			if(interactable_inrange_mobs.len)
				buttons += CLIMAX_IN_OR_ON

			var/vagina_climax_choice = climax_interaction && !manual ? CLIMAX_IN_OR_ON : tgui_alert(src, "Выбирайте, куда спускать.", "Куда сквиртить?", buttons)

			var/create_cum_decal = FALSE

			if(!vagina_climax_choice || vagina_climax_choice == CLIMAX_ON_FLOOR)
				create_cum_decal = TRUE
				visible_message(span_userlove("[src] дергается и стонет, когда [p_they()] сквиртит на пол!"), \
					span_userlove("Вы дергаетесь и стонете, когда сквиртите на пол!"))

			else
				target_choice = climax_interaction && !manual ? partner.name : tgui_input_list(src, "Выбирайте, на кого сквиртить.", "Выберите цель!", interactable_inrange_mobs)
				if(!target_choice)
					create_cum_decal = TRUE
					visible_message(span_userlove("[src] дергается и стонет, когда [p_they()] сквиртит на пол!"), \
						span_userlove("Вы дергаетесь и стонете, когда сквиртите на пол!"))
				else
					var/mob/living/target_mob = climax_interaction && !manual ? partner : interactable_inrange_mobs[target_choice]
					var/target_mob_them = target_mob.p_them()

					var/list/target_buttons = list()

					if(istype(target_mob, /mob/living/carbon/human))
						var/mob/living/carbon/human/target_human = target_mob
						if(!target_human.wear_mask)
							target_buttons += "рот"
					else
						target_buttons += "рот"
					if(target_mob.has_vagina(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_VAGINA
					if(target_mob.has_anus(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_ANUS
					if(target_mob.has_penis(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_PENIS
						var/obj/item/organ/genital/penis/other_penis = target_mob.get_organ_slot(ORGAN_SLOT_PENIS)
						if(other_penis.sheath != "None")
							target_buttons += "sheath"
					target_buttons += "На [target_mob_them]"

					var/climax_into_choice
					var/interaction_inside = partner?.get_organ_slot(climax_interaction?.cum_target[interaction_position])
					if(!interaction_inside)
						interaction_inside = target_buttons.Find(climax_interaction?.cum_target[interaction_position])
						if(interaction_inside)
							interaction_inside = climax_interaction.cum_target[interaction_position]
					else
						var/obj/item/organ/genital = interaction_inside
						interaction_inside = genital.slot

					if(climax_interaction && !manual && interaction_inside)
						climax_into_choice = climax_interaction.cum_target[interaction_position]
					else if(manual)
						climax_into_choice = tgui_input_list(src, "Куда в/на [target_mob] ты хочешь кончить?", "Куда кончить?", target_buttons)
					else
						climax_into_choice = "На [target_mob_them]"

					if(climax_interaction && !manual && climax_interaction.show_climax(src, target_mob, interaction_position))
						create_cum_decal = !interaction_inside
					else if(!climax_into_choice)
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] сквиртит на пол!"), \
							span_userlove("Вы сквиртите на пол!"))
						conditional_pref_sound(get_turf(src), 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
					else if(climax_into_choice == "На [target_mob_them]")
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] сквиртит на всего [target_mob]!"), \
							span_userlove("Вы сквиртите на всего [target_mob]!"))
						conditional_pref_sound(get_turf(src), 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
					else
						visible_message(span_userlove("[src] сквиртит на [target_mob] в [climax_into_choice]!"), \
							span_userlove("Вы сквиртите на [target_mob] в [climax_into_choice]!"))
						to_chat(target_mob, span_userlove("У вас наполняется [climax_into_choice] жидкостями [src]."))
						conditional_pref_sound(get_turf(target_mob), climax_into_choice == "рот" ? pick('modular_zzplurt/sound/interactions/mouthend (1).ogg', 'modular_zzplurt/sound/interactions/mouthend (2).ogg') : 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
						//SPLURT EDIT ADDITION BEGIN - Genital Inflation
						var/datum/component/interactable/interactable = target_mob.GetComponent(/datum/component/interactable)
						if(interactable)
							interactable.climax_inflate_genital(src, "вагина", climax_into_choice)
						//SPLURT EDIT ADDITION END
			if(!(climax_interaction?.interaction_modifier_flags & INTERACTION_OVERRIDE_FLUID_TRANSFER))
				if(create_cum_decal)
					if(HAS_TRAIT(src, TRAIT_MESSY))
						var/datum/reagents/R = new(vagina.internal_fluid_maximum)
						vagina.transfer_internal_fluid(R, vagina.internal_fluid_count)
						if(partner && partner != src)
							var/turf/T = get_turf(partner)
							T.add_liquid_from_reagents(R, FALSE, 1, get_turf(src), partner)
						else
							var/turf/T = get_turf(src)
							T.add_liquid_from_reagents(R, FALSE, 1)
						qdel(R)
					else
						vagina.transfer_internal_fluid(null, vagina.internal_fluid_count)
						add_cum_splatter_floor(get_turf(src), female = TRUE, cum_reagent = vagina.internal_fluid_datum)
				else if(partner || interactable_inrange_mobs[target_choice])
					var/mob/living/target_mob = partner || interactable_inrange_mobs[target_choice]

					//Check if the target has custom genital fluids enabled
					var/datum/reagent/original_fluid_datum = vagina.internal_fluid_datum
					if(!(target_mob.client?.prefs?.read_preference(/datum/preference/toggle/erp/custom_genital_fluids) || nonhuman_bypass_partner))
						vagina.internal_fluid_datum = initial(vagina.internal_fluid_datum)

					var/datum/reagents/R = new(vagina.internal_fluid_maximum)
					vagina.transfer_internal_fluid(R, vagina.internal_fluid_count)
					R.trans_to(target_mob, R.total_volume)

					vagina.internal_fluid_datum = original_fluid_datum
					qdel(R)
				else
					vagina.transfer_internal_fluid(null, vagina.internal_fluid_count)
		//SPLURT EDIT CHANGE END

	apply_status_effect(/datum/status_effect/climax)
	apply_status_effect(/datum/status_effect/climax_cooldown)
	if(self_orgasm)
		add_mood_event("orgasm", /datum/mood_event/climaxself)

	// SPLURT EDIT ADDITION BEGIN - Interactions
	if(climax_interaction && !manual)
		climax_interaction.post_climax(src, partner, interaction_position)
	//SPLURT EDIT ADDITION END
	return TRUE

//SPLURT EDIT REMOVAL BEGIN - Interactions - Moved climax defines to global defines
/*
#undef CLIMAX_VAGINA
#undef CLIMAX_PENIS
#undef CLIMAX_BOTH
*/
//SPLURT EDIT REMOVAL END

#undef CLIMAX_ON_FLOOR
#undef CLIMAX_IN_OR_ON
#undef CLIMAX_OPEN_CONTAINER
