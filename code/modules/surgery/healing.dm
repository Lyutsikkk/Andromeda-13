/datum/surgery/healing
	target_mobtypes = list(/mob/living)
	requires_bodypart_type = NONE
	replaced_by = /datum/surgery
	surgery_flags = SURGERY_IGNORE_CLOTHES | SURGERY_REQUIRE_RESTING
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/heal,
		/datum/surgery_step/close,
	)

	var/healing_step_type
	var/antispam = FALSE

/datum/surgery/healing/can_start(mob/user, mob/living/patient)
	. = ..()
	if(!.)
		return .
	if(!(patient.mob_biotypes & (MOB_ORGANIC|MOB_HUMANOID)))
		return FALSE
	return .

/datum/surgery/healing/New(surgery_target, surgery_location, surgery_bodypart)
	..()
	if(healing_step_type)
		steps = list(
			/datum/surgery_step/incise/nobleed,
			healing_step_type, //hehe cheeky
			/datum/surgery_step/close,
		)

/datum/surgery_step/heal
	name = "восстановление тела (гемостат)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 65,
		TOOL_WIRECUTTER = 60,
		/obj/item/pen = 55)
	repeatable = TRUE
	time = 25
	success_sound = 'sound/items/handling/surgery/retractor2.ogg'
	failure_sound = 'sound/items/handling/surgery/organ2.ogg'
	var/brutehealing = 0
	var/burnhealing = 0
	var/brute_multiplier = 0 //multiplies the damage that the patient has. if 0 the patient wont get any additional healing from the damage he has.
	var/burn_multiplier = 0

/// Returns a string letting the surgeon know roughly how much longer the surgery is estimated to take at the going rate
/datum/surgery_step/heal/proc/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	return

/datum/surgery_step/heal/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/woundtype
	if(brutehealing && burnhealing)
		woundtype = "ран"
	else if(brutehealing)
		woundtype = "гематом"
	else //why are you trying to 0,0...?
		woundtype = "ожогов"
	if(istype(surgery,/datum/surgery/healing))
		var/datum/surgery/healing/the_surgery = surgery
		if(!the_surgery.antispam)
			display_results(
				user,
				target,
				span_notice("Вы пытаетесь исправить некоторые из [woundtype]."),
				span_notice("[user] пытается исправить некоторые из [woundtype]."),
				span_notice("[user] пытается исправить некоторые из [woundtype]."),
			)
		display_pain(target, "Ваш [woundtype] чертвоски болят!")

/datum/surgery_step/heal/initiate(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	if(!..())
		return
	while((brutehealing && target.getBruteLoss()) || (burnhealing && target.getFireLoss()))
		if(!..())
			break

/datum/surgery_step/heal/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/user_msg = "Вам удалось залечить некоторые раны [target]" //no period, add initial space to "addons"
	var/target_msg = "[user] вылечил некоторые раны [target]" //see above
	var/brute_healed = brutehealing
	var/burn_healed = burnhealing
	var/dead_patient = FALSE
	if(target.stat == DEAD) //dead patients get way less additional heal from the damage they have.
		brute_healed += round((target.getBruteLoss() * (brute_multiplier * 0.2)),0.1)
		burn_healed += round((target.getFireLoss() * (burn_multiplier * 0.2)),0.1)
		dead_patient = TRUE
	else
		brute_healed += round((target.getBruteLoss() * brute_multiplier),0.1)
		burn_healed += round((target.getFireLoss() * burn_multiplier),0.1)
		dead_patient = FALSE
	if(!get_location_accessible(target, target_zone))
		brute_healed *= 0.55
		burn_healed *= 0.55
		user_msg += " как можно лучше, пока  [target.p_they()] [target.p_have()] одет"
		target_msg += " как можно лучше, пока [user.p_they()] [target.p_they()] [target.p_have()] одет"
	target.heal_bodypart_damage(brute_healed,burn_healed)

	user_msg += get_progress(user, target, brute_healed, burn_healed)

	if(HAS_MIND_TRAIT(user, TRAIT_MORBID) && ishuman(user) && !dead_patient) //Morbid folk don't care about tending the dead as much as tending the living
		var/mob/living/carbon/human/morbid_weirdo = user
		morbid_weirdo.add_mood_event("morbid_tend_wounds", /datum/mood_event/morbid_tend_wounds)

	display_results(
		user,
		target,
		span_notice("[user_msg]."),
		span_notice("[target_msg]."),
		span_notice("[target_msg]."),
	)
	if(istype(surgery, /datum/surgery/healing))
		var/datum/surgery/healing/the_surgery = surgery
		the_surgery.antispam = TRUE
	return ..()

/datum/surgery_step/heal/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("Ты облажался!"),
		span_warning("[user] облажался!"),
		span_notice("[user] вылечивает некоторые раны [target]."),
		target_detailed = TRUE,
	)
	var/brute_dealt = brutehealing * 0.8
	var/burn_dealt = burnhealing * 0.8
	brute_dealt += round((target.getBruteLoss() * (brute_multiplier * 0.5)),0.1)
	burn_dealt += round((target.getFireLoss() * (burn_multiplier * 0.5)),0.1)
	target.take_bodypart_damage(brute_dealt, burn_dealt, wound_bonus=CANT_WOUND)
	return FALSE

/***************************БРУТ УРОН***************************/
/datum/surgery/healing/brute
	name = "Обработайте раны (Рана)"

/datum/surgery/healing/brute/basic
	name = "Обработайте раны (Рана, база)"
	replaced_by = /datum/surgery/healing/brute/upgraded
	healing_step_type = /datum/surgery_step/heal/brute/basic
	desc = "Хирургическая процедура, которая обеспечивает базовое лечение серьезных травм пациента. При серьезных травмах заживление идет немного быстрее."

/datum/surgery/healing/brute/upgraded
	name = "Обработайте раны (Рана, продвинуто.)"
	replaced_by = /datum/surgery/healing/brute/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded
	desc = "Хирургическая процедура, которая обеспечивает эффективное лечение серьезных травм пациента. При серьезных травмах заживление происходит быстрее."

/datum/surgery/healing/brute/upgraded/femto
	name = "Обработайте раны (Рана, эксперт.)"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded/femto
	desc = "Хирургическая процедура, которая обеспечивает экспериментальное лечение серьезных травм пациента. При серьезных травмах заживление происходит значительно быстрее."

/********************BRUTE STEPS********************/
/datum/surgery_step/heal/brute/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	if(!brute_healed)
		return

	var/estimated_remaining_steps = target.getBruteLoss() / brute_healed
	var/progress_text

	if(locate(/obj/item/healthanalyzer) in user.held_items)
		progress_text = ". Remaining brute: <font color='#ff3333'>[target.getBruteLoss()]</font>"
	else
		switch(estimated_remaining_steps)
			if(-INFINITY to 1)
				return
			if(1 to 3)
				progress_text = ", вы обрабатываете последние раны"
			if(3 to 6)
				progress_text = ", вы накладываете швы"
			if(6 to 9)
				progress_text = ", вы продолжаете устранять обширный раны"
			if(9 to 12)
				progress_text = ", вы продолжаете сводить и шунтировать крупные разрывы"
			if(12 to 15)
				progress_text = ", вы продолжаете, хотя тело всё ещё имеет фатальные повреждения"
			if(15 to INFINITY)
				progress_text = ", вы продолжаете, хотя тело всё ещё походит на фарш"

	return progress_text

/datum/surgery_step/heal/brute/basic
	name = "лечение ран (гемостат)"
	brutehealing = 5
	brute_multiplier = 0.07

/datum/surgery_step/heal/brute/upgraded
	brutehealing = 5
	brute_multiplier = 0.1

/datum/surgery_step/heal/brute/upgraded/femto
	brutehealing = 5
	brute_multiplier = 0.2

/***************************ОЖОГИ***************************/
/datum/surgery/healing/burn
	name = "Обработайте раны (Ожог)"

/datum/surgery/healing/burn/basic
	name = "Обработайте раны (Ожог, база)"
	replaced_by = /datum/surgery/healing/burn/upgraded
	healing_step_type = /datum/surgery_step/heal/burn/basic
	desc = "Хирургическая процедура, которая обеспечивает базовое лечение ожогов пациента. При серьезных травмах заживление происходит немного быстрее."

/datum/surgery/healing/burn/upgraded
	name = "Обработайте раны (Ожог, продвинуто.)"
	replaced_by = /datum/surgery/healing/burn/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded
	desc = "Хирургическая процедура, которая обеспечивает эффективное лечение ожогов у пациента. При серьезных травмах заживление происходит быстрее."

/datum/surgery/healing/burn/upgraded/femto
	name = "Обработайте раны (Ожог, эксперт.)"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded/femto
	desc = "Хирургическая процедура, которая обеспечивает экспериментальное лечение ожогов у пациента. При серьезных травмах заживление происходит значительно быстрее."

/********************BURN STEPS********************/
/datum/surgery_step/heal/burn/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	if(!burn_healed)
		return
	var/estimated_remaining_steps = target.getFireLoss() / burn_healed
	var/progress_text

	if(locate(/obj/item/healthanalyzer) in user.held_items)
		progress_text = ". Remaining burn: <font color='#ff9933'>[target.getFireLoss()]</font>"
	else
		switch(estimated_remaining_steps)
			if(-INFINITY to 1)
				return
			if(1 to 3)
				progress_text = ", вы завершаете обработку последних ожогов"
			if(3 to 6)
				progress_text = ", вы обрабатываете остаточные волдыри"
			if(6 to 9)
				progress_text = ", вы обрабаттываете большие области ожогов"
			if(9 to 12)
				progress_text = ", вы продолжаете убирать обгоревшие ткани и обрабатвать кожу"
			if(12 to 15)
				progress_text = ", вы продолжаете, хотя тело всё ещё имеет ожоги дермы и частично гиподермы"
			if(15 to INFINITY)
				progress_text = ", вы продолжаете, хотя тело более походит на уголёк, чем на пациента"

	return progress_text

/datum/surgery_step/heal/burn/basic
	name = "обработка ожогов(гемоста)"
	burnhealing = 5
	burn_multiplier = 0.07

/datum/surgery_step/heal/burn/upgraded
	burnhealing = 5
	burn_multiplier = 0.1

/datum/surgery_step/heal/burn/upgraded/femto
	burnhealing = 5
	burn_multiplier = 0.2

/***************************КОМБО ХИЛ***************************/
/datum/surgery/healing/combo


/datum/surgery/healing/combo
	name = "Обработайте раны (Комбинированное, база)"
	replaced_by = /datum/surgery/healing/combo/upgraded
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/combo
	desc = "Хирургическая процедура, которая обеспечивает базовое лечение ожогов и других серьезных травм пациента. При серьезных травмах заживление идет немного быстрее."

/datum/surgery/healing/combo/upgraded
	name = "Обработайте раны (Комбинированное, продвинуто.)"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	healing_step_type = /datum/surgery_step/heal/combo/upgraded
	desc = "Хирургическая процедура, которая обеспечивает усовершенствованное лечение ожогов и серьезных травм пациента. При серьезных травмах заживление идет быстрее."


/datum/surgery/healing/combo/upgraded/femto //no real reason to type it like this except consistency, don't worry you're not missing anything
	name = "Обработайте раны (Комбинированное, эксперт.)"
	replaced_by = null
	healing_step_type = /datum/surgery_step/heal/combo/upgraded/femto
	desc = "Хирургическая процедура, которая обеспечивает экспериментальное лечение ожогов и серьезных травм пациента. При серьезных травмах заживление происходит значительно быстрее."

/********************COMBO STEPS********************/
/datum/surgery_step/heal/combo/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	var/estimated_remaining_steps = 0
	if(brute_healed > 0)
		estimated_remaining_steps = max(0, (target.getBruteLoss() / brute_healed))
	if(burn_healed > 0)
		estimated_remaining_steps = max(estimated_remaining_steps, (target.getFireLoss() / burn_healed)) // whichever is higher between brute or burn steps

	var/progress_text

	if(locate(/obj/item/healthanalyzer) in user.held_items)
		if(target.getBruteLoss())
			progress_text = ". Remaining brute: <font color='#ff3333'>[target.getBruteLoss()]</font>"
		if(target.getFireLoss())
			progress_text += ". Remaining burn: <font color='#ff9933'>[target.getFireLoss()]</font>"
	else
		switch(estimated_remaining_steps)
			if(-INFINITY to 1)
				return
			if(1 to 3)
				progress_text = ", вы устраняете последния повреждения"
			if(3 to 6)
				progress_text = ", вы ведёте обратный отсчет последних нескольких участков с травмами"
			if(6 to 9)
				progress_text = ", вы продолжаете работать над устранением обширных травм"
			if(9 to 12)
				progress_text = ", вы продолжаете операцию над телом"
			if(12 to 15)
				progress_text = ", вы продолжаете, но тело имеет фатальные повреждения и ожоги"
			if(15 to INFINITY)
				progress_text = ", вы продолжаете, но всё ещё имеете сомнения на сборку этого конструктора"

	return progress_text

/datum/surgery_step/heal/combo
	name = "обрабатывайте физические раны (гемостат)"
	brutehealing = 3
	burnhealing = 3
	brute_multiplier = 0.07
	burn_multiplier = 0.07
	time = 10

/datum/surgery_step/heal/combo/upgraded
	brutehealing = 3
	burnhealing = 3
	brute_multiplier = 0.1
	burn_multiplier = 0.1

/datum/surgery_step/heal/combo/upgraded/femto
	brutehealing = 1
	burnhealing = 1
	brute_multiplier = 0.4
	burn_multiplier = 0.4

/datum/surgery_step/heal/combo/upgraded/femto/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("Ты облажался!"),
		span_warning("[user] облажался!"),
		span_notice("[user] исправляет некоторые ошибки [target]."),
		target_detailed = TRUE,
	)
	target.take_bodypart_damage(5,5)
