/datum/controller/subsystem/map_vote/finalize_map_vote(datum/vote/map_vote/map_vote, winning_option) // BUBBER EDIT CHANGE - Ranked Choice Voting - add winning_option
	if(already_voted)
		message_admins("Попытка завершить голосование по карте после того, как голосование по карте уже было завершено.")
		return
	already_voted = TRUE

	var/flat = CONFIG_GET(number/map_vote_flat_bonus)
	previous_cache = map_vote_cache.Copy()
	for(var/map_id in map_vote.choices)
		var/datum/map_config/map = config.maplist[map_id]
		map_vote_cache[map_id] += (map_vote.choices[map_id] * map.voteweight) + flat
	sanitize_cache()
	write_cache()
	update_tally_printout()

	if(admin_override)
		send_map_vote_notice("Действует запрет администратора. Карта не будет изменена.", "Подсчеты записываются и сохраняются.")
		return


	// BUBBER EDIT CHANGE BEGIN - Ranked Choice Voting
	/*
	var/list/message_data = list()
	var/winner
	var/winner_amount = 0
	for(var/map in map_vote.choices)
		message_data += "[map] - [map_vote_cache[map]]"
		if(!winner_amount)
			winner = map
			winner_amount = map_vote_cache[map]
			continue
		if(map_vote_cache[map] <= winner_amount)
			continue
		winner = map
		winner_amount = map_vote_cache[map]

	var/filtered_vote_results = "[span_bold("Результаты голосования (включая перенос)")]\n\n[message_data.Join("\n")]"

	ASSERT(winner, "В голосовании по картам победитель не выявлен.")
	set_next_map(config.maplist[winner])
	var/list/vote_result_message = list(filtered_vote_results)
	vote_result_message += list("<hr>Следующая карта: [span_cyan(span_bold(next_map_config.map_name))]")
	var/carryover_percentage = CONFIG_GET(number/map_vote_tally_carryover_percentage)
	if(carryover_percentage)
		vote_result_message += list("\n[CONFIG_GET(number/map_vote_tally_carryover_percentage)]% голоса с проигравших карт будут перенесены и применены к голосованию за следующую карту.")

	// do not reset tallies if only one map is even possible
	if(length(map_vote.choices) > 1)
		map_vote_cache[winner] = CONFIG_GET(number/map_vote_minimum_tallies)
		write_cache()
		update_tally_printout()
	else
		vote_result_message += "Можно было использовать только одну карту, подсчеты не сбрасывались."
	*/
	set_next_map(config.maplist[winning_option])
	var/list/vote_results = map_vote.elimination_results
	var/serialized_vote_results = "[vote_results.Join("\n")]"
	var/list/vote_result_message = list("Method: Ranked Vote\n\nElimination order:\n[serialized_vote_results]\n\nNext Map: [span_vote_notice(span_bold(winning_option))]")
	// BUBBER EDIT CHANGE END - Ranked Choice Voting

	send_map_vote_notice(arglist(vote_result_message))

/datum/controller/subsystem/map_vote/send_map_vote_notice(...)
	var/static/last_message_at
	if(last_message_at == world.time)
		message_admins("Вызов send_map_vote_notice дважды за один игровой тик. Накричать на кого-нибудь, чтобы сгустить сообщения.")
	last_message_at = world.time

	var/list/messages = args.Copy()
	//to_chat(world, custom_boxed_message("purple_box", vote_font("[span_bold("Голосование за Карту")]\n<hr>[messages.Join("\n")]"))) // BUBBER EDIT CHANGE - Ranked Choice Voting
	to_chat(world, vote_font(fieldset_block("Map Vote - Results", "[messages.Join("\n")]", "boxed_message purple_box")))

/datum/controller/subsystem/map_vote/update_tally_printout()
	var/list/data = list()
	for(var/map_id in map_vote_cache)
		var/datum/map_config/map = config.maplist[map_id]
		data += "[map.map_name] - [map_vote_cache[map_id]]"
	tally_printout = "[span_bold("Текущие показатели карт (включая перенос)")]\n\n[data.Join("\n")]"
