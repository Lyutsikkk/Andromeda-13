/datum/tgs_chat_command/restart
	name = "restart"
	help_text = "Forces a restart on the server"
	admin_only = TRUE

/datum/tgs_chat_command/restart/Run(datum/tgs_chat_user/sender)
	. = new /datum/tgs_message_content("Перезапуск.")
	to_chat(world, span_boldwarning("Перезапуск сервера - инициализирован [sender.friendly_name] в Discord."))
	send2adminchat("Сервер", "[sender.friendly_name] вынужденно перезапустился.")
	addtimer(CALLBACK(src, PROC_REF(DoEndProcess)), 1 SECONDS)

/datum/tgs_chat_command/restart/proc/DoEndProcess()
	world.TgsEndProcess()
