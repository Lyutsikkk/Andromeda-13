// Terror effect handlers

#define FEAR_SCALING(base, min, max) clamp(base * (terror_buildup - min) / (max - min), 0, base)

/// Causes mild jittering, scaling with current terror level
/datum/terror_handler/jittering
	handler_type = TERROR_HANDLER_EFFECT
	default = TRUE
	COOLDOWN_DECLARE(message_cd)

/datum/terror_handler/jittering/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (owner.stat >= UNCONSCIOUS)
		return

	if (terror_buildup < TERROR_BUILDUP_FEAR)
		return

	// If we're terrified, keep constant jittering and dizzyness
	if (terror_buildup > TERROR_BUILDUP_TERROR)
		owner.adjust_dizzy_up_to(10 SECONDS * seconds_per_tick, 10 SECONDS)
		owner.adjust_jitter_up_to(10 SECONDS * seconds_per_tick, 10 SECONDS)
		return

	if (!SPT_PROB(1 + FEAR_SCALING(4, TERROR_BUILDUP_FEAR, TERROR_BUILDUP_TERROR), seconds_per_tick)) // 1% to 5% chance
		return

	if (COOLDOWN_FINISHED(src, message_cd) && !owner.has_status_effect(/datum/status_effect/jitter)) // Don't display the message if we're already shaking
		to_chat(owner, span_warning("Вы не можете перестать дрожать..."))
		COOLDOWN_START(src, message_cd, TERROR_MESSAGE_CD)

	owner.set_jitter_if_lower(20 SECONDS)
	owner.set_dizzy_if_lower(20 SECONDS)

/// Stutter when afraid
/datum/terror_handler/stuttering
	handler_type = TERROR_HANDLER_EFFECT
	default = TRUE

/datum/terror_handler/stuttering/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (owner.stat >= UNCONSCIOUS)
		return

	if (terror_buildup < TERROR_BUILDUP_FEAR)
		return

	if (terror_buildup > TERROR_BUILDUP_TERROR || SPT_PROB(1 + FEAR_SCALING(4, TERROR_BUILDUP_FEAR, TERROR_BUILDUP_TERROR), seconds_per_tick))
		owner.set_stutter_if_lower(10 SECONDS)

/// Can randomly give you some oxyloss, and cause a heart attack past TERROR_BUILDUP_HEART_ATTACK
/datum/terror_handler/heart_problems
	handler_type = TERROR_HANDLER_EFFECT
	default = TRUE
	COOLDOWN_DECLARE(effect_cd)

/datum/terror_handler/heart_problems/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (owner.stat >= UNCONSCIOUS)
		return

	if (terror_buildup < TERROR_BUILDUP_FEAR)
		return

	if (!SPT_PROB(1 + FEAR_SCALING(4, TERROR_BUILDUP_FEAR, TERROR_BUILDUP_PANIC), seconds_per_tick)) // 1% to 5% chance
		return

	if (terror_buildup < TERROR_BUILDUP_HEART_ATTACK || !prob(15))
		owner.adjustOxyLoss(8)
		if (terror_buildup < TERROR_BUILDUP_FEAR)
			to_chat(owner, span_warning("Ваше сердце учащенно забилось."))
		else
			to_chat(owner, span_userdanger("Вы чувствуете, как сердце колотится в груди..."))
		return

	owner.visible_message(
		span_warning("[owner] на мгновение хватается за [owner.p_their()] грудь, а затем рушится на пол."),
		span_alert("Тени начинают подкрадываться из уголков вашего зрения, а затем ничего нет..."),
		span_hear("Вы слышите, как что-то тяжелое ударяется о землю."),
	)
	owner.apply_status_effect(/datum/status_effect/heart_attack)
	owner.Unconscious(20 SECONDS)

/// Low chance to vomit when terrified, increases significantly during panic attacks
/datum/terror_handler/vomiting
	handler_type = TERROR_HANDLER_EFFECT

/datum/terror_handler/vomiting/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (owner.stat >= UNCONSCIOUS)
		return

	if (terror_buildup < TERROR_BUILDUP_TERROR)
		return

	if (SPT_PROB((terror_buildup >= TERROR_BUILDUP_PANIC) ? 3 : 1, seconds_per_tick))
		to_chat(owner, span_warning("Вам плохо..."))
		// Vomit blood if we're *really* freaking out
		addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon, vomit), terror_buildup >= TERROR_BUILDUP_PASSIVE_MAXIMUM), 5 SECONDS)

/// Causes tunnel vision, blurry eyes and periodic panic attacks when panicking
/datum/terror_handler/panic
	handler_type = TERROR_HANDLER_EFFECT
	default = TRUE
	/// Has the panic message been shown yet?
	var/active = FALSE
	/// Are we in a state of a panic attack currently? Only really used for tracking our breath loop
	var/active_attack = FALSE
	/// Breath loop used during a panic attack
	var/datum/looping_sound/breathing/breath_loop

/datum/terror_handler/panic/New(mob/living/new_owner, datum/component/fearful/new_component)
	. = ..()
	breath_loop = new(owner, _direct = TRUE)

/datum/terror_handler/panic/Destroy(force)
	owner.remove_fov_trait(type, FOV_270_DEGREES)
	QDEL_NULL(breath_loop)
	return ..()

/datum/terror_handler/panic/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (owner.stat >= UNCONSCIOUS)
		active_attack = FALSE
		active = FALSE
		owner.remove_fov_trait(type, FOV_270_DEGREES)
		return

	if (terror_buildup < TERROR_BUILDUP_PANIC)
		if (active_attack) // No you don't
			return TERROR_BUILDUP_PANIC - terror_buildup
		active = FALSE
		owner.remove_fov_trait(type, FOV_270_DEGREES)
		return

	if (!active)
		active = TRUE
		to_chat(owner, span_userdanger("Вы чувствуете, как колотится ваше сердце!"))
		owner.add_fov_trait(type, FOV_270_DEGREES) // Terror induced tunnel vision

	owner.playsound_local(owner, 'sound/effects/health/slowbeat.ogg', 40, FALSE, channel = CHANNEL_HEARTBEAT, use_reverb = FALSE)
	if (SPT_PROB(5, seconds_per_tick))
		owner.set_eye_blur_if_lower(10 SECONDS)

	if (active_attack)
		owner.losebreath += 0.25 // Miss 1/4 breaths
		return

	if (SPT_PROB(2 + FEAR_SCALING(3, TERROR_BUILDUP_PANIC, TERROR_BUILDUP_MAXIMUM), seconds_per_tick))
		. += panic_attack(terror_buildup)

/datum/terror_handler/panic/proc/panic_attack(terror_buildup)
	active_attack = TRUE
	owner.emote("gasp")
	owner.Knockdown(0.5 SECONDS)
	breath_loop.start()
	addtimer(CALLBACK(src, PROC_REF(stop_panic_attack)), rand(3 SECONDS, 5 SECONDS))
	owner.visible_message(span_warning("[owner] на мгновение опускается на пол, схватившись за грудь.."), span_alert("Сердце колотится в груди. Вы не можете больше терпеть!"))
	return PANIC_ATTACK_TERROR_AMOUNT

/datum/terror_handler/panic/proc/stop_panic_attack()
	breath_loop.stop()
	active_attack = FALSE

#undef FEAR_SCALING
