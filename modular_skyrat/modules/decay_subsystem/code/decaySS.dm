/*
This is the decay subsystem that is run once at startup.
These procs are incredibly expensive and should only really be run once. That's why the only run once.
*/


#define WALL_RUST_PERCENT_CHANCE 15

#define FLOOR_DIRT_PERCENT_CHANCE 15
#define FLOOR_BLOOD_PERCENT_CHANCE 1
#define FLOOR_VOMIT_PERCENT_CHANCE 1
#define FLOOR_OIL_PERCENT_CHANCE 5
#define FLOOR_TILE_MISSING_PERCENT_CHANCE 1
#define FLOOR_COBWEB_PERCENT_CHANCE 1

#define NEST_PERCENT_CHANCE 1

SUBSYSTEM_DEF(decay)
	name = "Decay System"
	flags = SS_NO_FIRE
	dependencies = list(
		/datum/controller/subsystem/mapping,
		/datum/controller/subsystem/atoms,
	)

	/// This is used to determine what maps we should not spawn on.
	var/list/station_filter = list("Catwalk Station", "Runtime Station", "MultiZ Debug", "Gateway Test")
	var/list/possible_turfs = list()
	var/list/possible_areas = list()
	var/severity_modifier = 1

	var/list/possible_nests = list(
		/obj/structure/mob_spawner/spiders,
		/obj/structure/mob_spawner/bush,
		/obj/structure/mob_spawner/beehive,
		/obj/structure/mob_spawner/rats
		)

/datum/controller/subsystem/decay/Initialize()
	if(CONFIG_GET(flag/ssdecay_disabled))
		message_admins("SSDecay was disabled in config.")
		log_world("SSDecay was disabled in config.")
		return SS_INIT_NO_NEED

	if(SSmapping.current_map.map_name in station_filter)
		message_admins("SSDecay was disabled due to map filter.")
		log_world("SSDecay was disabled due to map filter.")
		return SS_INIT_NO_NEED

	for(var/area/iterating_area as anything in GLOB.areas)
		if(!is_station_level(iterating_area.z))
			continue
		possible_areas += iterating_area

		// Now add the turfs
		for(var/list/zlevel_turfs as anything in iterating_area.get_zlevel_turf_lists())
			for(var/turf/area_turf as anything in zlevel_turfs)
				if(!(area_turf.flags_1 & CAN_BE_DIRTY_1))
					continue
				possible_turfs += area_turf

	if(!possible_turfs)
		CRASH("SSDecay had no possible turfs to use!")

	var/severity_modifier = CONFIG_GET(number/ssdecay_intensity)
	if(!severity_modifier || severity_modifier == 5)
		severity_modifier = rand(1, 4)

	message_admins("Модификатор тяжести SSDecay установлен на [severity_modifier]")
	log_world("Модификатор тяжести SSDecay установлен на [severity_modifier]")

	do_common()

	do_maintenance()

	do_engineering()

	do_medical()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/decay/proc/do_common()
	for(var/turf/open/floor/iterating_floor in possible_turfs)
		if(iterating_floor.turf_flags & CAN_DECAY_BREAK_1)
			if(prob(FLOOR_TILE_MISSING_PERCENT_CHANCE * severity_modifier) && prob(60))
				iterating_floor.break_tile_to_plating()

		if(prob(FLOOR_DIRT_PERCENT_CHANCE * severity_modifier))
			new /obj/effect/decal/cleanable/dirt(iterating_floor)

		if(prob(FLOOR_DIRT_PERCENT_CHANCE * severity_modifier))
			new /obj/effect/decal/cleanable/dirt(iterating_floor)

	for(var/turf/closed/iterating_wall in possible_turfs)
		if(HAS_TRAIT(iterating_wall, TRAIT_RUSTY))
			continue
		if(prob(WALL_RUST_PERCENT_CHANCE * severity_modifier))
			iterating_wall.AddElement(/datum/element/rust)

/datum/controller/subsystem/decay/proc/do_maintenance()
	for(var/area/station/maintenance/iterating_maintenance in possible_areas)
		for(var/turf/open/iterating_floor in iterating_maintenance)
			if(prob(FLOOR_BLOOD_PERCENT_CHANCE * severity_modifier))
				var/obj/effect/decal/cleanable/blood/spawned_blood = new (iterating_floor)
				spawned_blood.dry()
				if(!iterating_floor.Enter(spawned_blood))
					qdel(spawned_blood) //No blood under windows.

			if(prob(FLOOR_COBWEB_PERCENT_CHANCE * severity_modifier))
				var/obj/structure/spider/stickyweb/spawned_web = new (iterating_floor)
				if(!iterating_floor.Enter(spawned_web))
					qdel(spawned_web)

			if(!CONFIG_GET(flag/ssdecay_disable_nests) && prob(NEST_PERCENT_CHANCE * severity_modifier) && prob(50))
				var/spawner_to_spawn = pick(possible_nests)
				var/obj/structure/mob_spawner/spawned_spawner = new spawner_to_spawn(iterating_floor)
				if(!iterating_floor.Enter(spawned_spawner))
					qdel(spawned_spawner)

/datum/controller/subsystem/decay/proc/do_engineering()
	for(var/area/station/engineering/iterating_engineering in possible_areas)
		for(var/turf/open/iterating_floor in iterating_engineering)
			if(prob(FLOOR_BLOOD_PERCENT_CHANCE * severity_modifier))
				var/obj/effect/decal/cleanable/blood/spawned_blood = new (iterating_floor)
				spawned_blood.dry()
				if(!iterating_floor.Enter(spawned_blood))
					qdel(spawned_blood)

			if(prob(FLOOR_OIL_PERCENT_CHANCE * severity_modifier))
				var/obj/effect/decal/cleanable/blood/oil/spawned_oil = new (iterating_floor)
				if(!iterating_floor.Enter(spawned_oil))
					qdel(spawned_oil)

/datum/controller/subsystem/decay/proc/do_medical()
	for(var/area/station/medical/iterating_medical in possible_areas)
		for(var/turf/open/iterating_floor in iterating_medical)
			if(prob(FLOOR_BLOOD_PERCENT_CHANCE * severity_modifier))
				var/obj/effect/decal/cleanable/blood/spawned_blood = new (iterating_floor)
				spawned_blood.dry()
				if(!iterating_floor.Enter(spawned_blood))
					qdel(spawned_blood)

			if(prob(FLOOR_VOMIT_PERCENT_CHANCE * severity_modifier))
				var/obj/effect/decal/cleanable/vomit/spawned_vomit = new (iterating_floor)
				if(!iterating_floor.Enter(spawned_vomit))
					qdel(spawned_vomit)

#undef WALL_RUST_PERCENT_CHANCE
#undef FLOOR_DIRT_PERCENT_CHANCE
#undef FLOOR_BLOOD_PERCENT_CHANCE
#undef FLOOR_VOMIT_PERCENT_CHANCE
#undef FLOOR_OIL_PERCENT_CHANCE
#undef FLOOR_TILE_MISSING_PERCENT_CHANCE
#undef FLOOR_COBWEB_PERCENT_CHANCE
#undef NEST_PERCENT_CHANCE
