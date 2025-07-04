/datum/round_event_control/communications_blackout
	name = "Отключение связи"
	typepath = /datum/round_event/communications_blackout
	weight = 30
	category = EVENT_CATEGORY_ENGINEERING
	description = "Сильно поражает ЭМИ все телекоммуникационные машины, на некоторое время блокируя связь."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 3

/datum/round_event/communications_blackout
	announce_when = 1

/datum/round_event/communications_blackout/announce(fake)
	var/alert = pick( "Обнаружены ионосферные аномалии. Временный сбой телекоммуникаций неизбежен. Пожалуйста, свяжитесь с *%fj00)`5vc-BZZT",
		"Обнаружены ионосферные аномалии. Временный сбой телекоммуникаций чере*3mga;b4;'1v¬-BZZZT",
		"Обнаружены ионосферные аномалии. Временный сбой телеком#МУi46:5.;@63-BZZZZT",
		"Обнаружены ионосферные ан'fZ\\kg5_0-BZZZZZT",
		"Ионосферные:%£ MCayj^j<.3-BZZZZZZT",
		"#4nd%;f4y6,>£%-BZZZZZZZT",
	)

	for(var/mob/living/silicon/ai/A in GLOB.ai_list) //AIs are always aware of communication blackouts.
		to_chat(A, "<br>[span_warning("<b>[alert]</b>")]<br>")
		to_chat(A, span_notice("Remember, you can transmit over holopads by right clicking on them, and can speak through them with \".[/datum/saymode/holopad::key]\"."))

	if(prob(30) || fake) //most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		priority_announce(alert, "Предупреждение об аномалии", sound = ANNOUNCER_COMMSBLACKOUT) //SKYRAT EDIT CHANGE - ORIGINAL: priority_announce(alert, "Предупреждение об аномалии")


/datum/round_event/communications_blackout/start()
	for(var/obj/machinery/telecomms/shhh as anything in GLOB.telecomm_machines)
		shhh.emp_act(EMP_HEAVY)
	for(var/datum/transport_controller/linear/tram/transport as anything in SStransport.transports_by_type[TRANSPORT_TYPE_TRAM])
		if(!isnull(transport.home_controller))
			var/obj/machinery/transport/tram_controller/tcomms/controller = transport.home_controller
			controller.emp_act(EMP_HEAVY)
