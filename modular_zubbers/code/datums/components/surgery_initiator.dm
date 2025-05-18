/datum/component/surgery_initiator/try_choose_surgery(mob/user, mob/living/target, datum/surgery/surgery)
	. = ..()
	if(!.)
		return

	var/list/passed_check = list()
	var/list/failed_check = list()
	var/turf/mob_turf = get_turf(target)
	var/obj/structure/table/optable/operating_table = locate(/obj/structure/table/optable, mob_turf)
	if(!isnull(operating_table))
		if(operating_table.computer?.is_operational)
			passed_check += "операционный стол/компьютер"
		else
			passed_check += "операционный стол"
			failed_check += "операционный компьютер"

	if(!issynthetic(target))
		if((HAS_TRAIT(target, TRAIT_ANALGESIA) && !(HAS_TRAIT(target, TRAIT_STASIS))) || target.stat == DEAD)
			passed_check += "обезболивание"
		else if(!(HAS_TRAIT(target, TRAIT_STASIS)))
			failed_check += "использование анестетиков"

		if(target.has_sterilizine(target))
			passed_check += "стерилизатор/криостилан"
		else
			failed_check += "использование стерилизина или криостилана"

	if(length(passed_check) > 0)
		to_chat(user, span_greenannounce("У вас есть бонусы к скорости операции от [english_list(passed_check)]!"))
	if(length(failed_check) > 0)
		to_chat(user, span_boldnotice("<b>Вы можете увеличить скорость операции, имея [english_list(failed_check)].</b>"))

	if(!(HAS_TRAIT(target, TRAIT_ANALGESIA) || target.stat == DEAD) && !issynthetic(target))
		to_chat(user, span_bolddanger("У [target] нет лечения, чтобы справиться с болью при операции!"))
