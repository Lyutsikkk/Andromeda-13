
/datum/wires/emitter
	holder_type = /obj/machinery/power/emitter
	req_knowledge = JOB_SKILL_TRAINED
	req_skill = JOB_SKILL_UNTRAINED
	visibility_trait = TRAIT_KNOW_ENGI_WIRES // BLUEMOON ADD

/datum/wires/emitter/New(atom/holder)
	wires = list(WIRE_ZAP,WIRE_HACK)
	..()

/datum/wires/emitter/on_pulse(wire)
	var/obj/machinery/power/emitter/E = holder
	switch(wire)
		if(WIRE_ZAP)
			E.fire_beam_pulse()
		if(WIRE_HACK)
			E.mode = !E.mode
			E.set_projectile()
	..()
