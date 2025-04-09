///Data holder for the announcers that can be used in a game, this can be used to have alternative announcements outside of the default e.g.the intern
/datum/centcom_announcer
	/// Начало раунда
	var/welcome_sounds = list()
	/// Обычный анонс
	var/alert_sounds = list()
	/// ЦентКом анонс
	var/command_report_sounds = list()
	/// Анонсы ивентов
	var/event_sounds = list()
	/// Кастомные анонсы
	var/custom_alert_message


/datum/centcom_announcer/proc/get_rand_welcome_sound()
	return pick(welcome_sounds)


/datum/centcom_announcer/proc/get_rand_alert_sound()
	return pick(alert_sounds)

/datum/centcom_announcer/proc/get_rand_report_sound()
	return pick(command_report_sounds)
