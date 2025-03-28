/// Disk containing info for doing advanced plastic surgery. Spawns in maint and available as a role-restricted item in traitor uplinks.
/obj/item/disk/surgery/advanced_plastic_surgery
	name = "Диск для продвинутой пластической хирургии"
	desc = "На диске представлены инструкции о том, как сделать продвинутую пластическую операцию, которая позволяет полностью переделать лицо человека на лицо другого человека. При условии, что у человека есть фотография, на которой он запечатлен при изменении формы лица. С развитием генетических технологий эта операция давно устарела. Этот предмет стал предметом старины для многих коллекционеров, и в большинстве мест по-прежнему используется только более дешевая и простая базовая форма пластической хирургии."
	surgeries = list(/datum/surgery/plastic_surgery/advanced)

/datum/surgery/plastic_surgery
	name = "Пластическая хирургия"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB | SURGERY_MORBID_CURIOSITY
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/reshape_face,
		/datum/surgery_step/close,
	)

/datum/surgery/plastic_surgery/advanced
	name = "Продвинутая пластическая хирургия"
	desc =  "Хирургия позволяет полностью переделать чье-то лицо под лицо другого человека. При условии, что у человека есть фотография, на которой он запечатлен при изменении формы лица."
	requires_tech = TRUE
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/insert_plastic,
		/datum/surgery_step/reshape_face,
		/datum/surgery_step/close,
	)

//Insert plastic step, It ain't called plastic surgery for nothing! :)
/datum/surgery_step/insert_plastic
	name = "вставка пластики (пластик)"
	implements = list(
		/obj/item/stack/sheet/plastic = 100,
		/obj/item/stack/sheet/meat = 100)
	time = 3.2 SECONDS
	preop_sound = 'sound/effects/blob/blobattack.ogg'
	success_sound = 'sound/effects/blob/attackblob.ogg'
	failure_sound = 'sound/effects/blob/blobattack.ogg'

/datum/surgery_step/insert_plastic/preop(mob/user, mob/living/target, target_zone, obj/item/stack/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете вставлять[tool] в разрез [target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user] начинает вставлять [tool] в разрез [target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user] начинает вставлять [tool] в разрез [target.parse_zone_with_bodypart(target_zone)]."),
	)
	display_pain(target, "Вы чувствуете, как что-то проникает прямо под кожу в [target.parse_zone_with_bodypart(target_zone)].")

/datum/surgery_step/insert_plastic/success(mob/user, mob/living/target, target_zone, obj/item/stack/tool, datum/surgery/surgery, default_display_results)
	. = ..()
	tool.use(1)

//reshape_face
/datum/surgery_step/reshape_face
	name = "изменение формы лица (скальпель)"
	implements = list(
		TOOL_SCALPEL = 100,
		/obj/item/knife = 50,
		TOOL_WIRECUTTER = 35)
	time = 64
	surgery_effects_mood = TRUE

/datum/surgery_step/reshape_face/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message(span_notice("[user] начинает изменять внешний вид [target]."), span_notice("Вы начинаете изменять внешний вид [target]..."))
	display_results(
		user,
		target,
		span_notice("Вы начинаете изменять внешность [target]..."),
		span_notice("[user] начинает изменять внешность [target]."),
		span_notice("[user] начинает делать надрезы на лице [target]."),
	)
	display_pain(target, "Вы чувствуете режущую боль на своем лице!")

/datum/surgery_step/reshape_face/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(HAS_TRAIT_FROM(target, TRAIT_DISFIGURED, TRAIT_GENERIC))
		REMOVE_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
		display_results(
			user,
			target,
			span_notice("Вы успешно восстановили внешний вид [target]."),
			span_notice("[user] успешно восстановил внешний вид [target]!"),
			span_notice("[user] завершает операцию на лице [target]."),
		)
		display_pain(target, "Боль проходит, ваше лицо снова выглядит нормально!")
	else
		var/list/names = list()
		if(!isabductor(user))
			var/obj/item/offhand = user.get_inactive_held_item()
			if(istype(offhand, /obj/item/photo) && istype(surgery, /datum/surgery/plastic_surgery/advanced))
				var/obj/item/photo/disguises = offhand
				for(var/namelist as anything in disguises.picture?.names_seen)
					names += namelist
			else
				user.visible_message(span_warning("У вас нет изображения, на котором можно было бы основывать внешний вид, и вы возвращаетесь к случайным появлениям."))
				for(var/i in 1 to 10)
					names += target.generate_random_mob_name(TRUE)
		else
			for(var/j in 1 to 9)
				names += "Субъект [target.gender == MALE ? "i" : "o"]-[pick("a", "b", "c", "d", "e")]-[rand(10000, 99999)]"
			names += target.generate_random_mob_name(TRUE) //give one normal name in case they want to do regular plastic surgery
		var/chosen_name = tgui_input_list(user, "Назначить новое имя", "Пластическая хирургия", names)
		if(isnull(chosen_name))
			return
		var/oldname = target.real_name
		target.real_name = chosen_name
		var/newname = target.real_name //something about how the code handles names required that I use this instead of target.real_name
		display_results(
			user,
			target,
			span_notice("Вы полностью изменили внешний вид [oldname], [target.p_they()] теперь [newname]."),
			span_notice("[user] полностью изменили внешний вид [oldname], [target.p_they()] теперь [newname]!"),
			span_notice("[user] завершает операцию на лице [target]."),
		)
		display_pain(target, "Боль проходит, ваше лицо кажется новым и незнакомым!")
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		human_target.sec_hud_set_ID()
	if(HAS_MIND_TRAIT(user, TRAIT_MORBID) && ishuman(user))
		var/mob/living/carbon/human/morbid_weirdo = user
		morbid_weirdo.add_mood_event("morbid_abominable_surgery_success", /datum/mood_event/morbid_abominable_surgery_success)
	return ..()

/datum/surgery_step/reshape_face/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("Вы облажались, оставив внешний вид [target] изуродованным!"),
		span_notice("[user] облажался, изуродовав внешний вид [target]!"),
		span_notice("[user] завершает операцию на лице [target]."),
	)
	display_pain(target, "Ваше лицо покрыто ужасными шрамами и деформировано!")
	ADD_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
	return FALSE
