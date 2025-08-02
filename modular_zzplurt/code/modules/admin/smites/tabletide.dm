/datum/smite/tabletide
	name = "Божественный стол (С)"

/datum/smite/tabletide/effect(client/user, mob/living/target)
	. = ..()
	priority_announce(html_decode("[target] навлек на себя гнев богов и сейчас размазывается по всей станции. Пожалуйста, будьте наготове."), "Божественный стол")
	var/list/areas = list()
	for(var/area/A in GLOB.areas)
		if(A.z == SSmapping.station_start)
			areas += A
	SEND_SOUND(target, sound('modular_zzplurt/sound/misc/slamofthenorthstar.ogg', volume=60))
	for(var/area/A in areas)
		for(var/obj/structure/table/T in A)
			var/datum/component/table_smash/table_smash = T.GetComponent(/datum/component/table_smash)
			table_smash.tablepush(target, target)
			sleep(1)
