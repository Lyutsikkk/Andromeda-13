// IF you have linked your account, this will trigger a verify of the user
/client/verb/verify_in_discord()
	set category = "OOC"
	set name = "Верификация аккаунта Discord"
	set desc = "Подтвердите свою учетную запись discord с вашей учетной записью BYOND"

	// Safety checks
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("Эта функция требует, чтобы бэкэнд SQL был запущен."))
		return

	// Why this would ever be unset, who knows
	var/prefix = CONFIG_GET(string/discordbotcommandprefix)
	if(!prefix)
		to_chat(src, span_warning("Эта функция отключена."))
		return

	if(!SSdiscord || !SSdiscord.reverify_cache)
		to_chat(src, span_warning("Дождитесь окончания инициализации подсистемы Discord"))
		return
	var/message = ""
	// Simple sanity check to prevent a user doing this too often
	var/cached_one_time_token = SSdiscord.reverify_cache[usr.ckey]
	if(cached_one_time_token && cached_one_time_token != "")
		message = "Вы уже сгенерировали свой одноразовый токен, это [cached_one_time_token]. Если вам нужен новый, придется ждать окончания раунда; верифицируйте себя в Discord, скопировав эту команду: <span class='code user-select'>[prefix]verify [cached_one_time_token]</span> и вставляем его в канал проверки."


	else
		//SPLURT EDIT - Only one linked account
		var/datum/discord_link_record/existing_link = SSdiscord.find_discord_link_by_ckey(usr?.ckey, only_valid = TRUE)
		//Do not create a new entry if they already have a linked account
		if(existing_link?.discord_id)
			message = "У вас уже есть связанный аккаунт дискорда ([existing_link.discord_id]) привязанный к [existing_link.timestamp]. Если вы хотите изменить свою учетную запись, пожалуйста, свяжитесь с персоналом."
		else
			// Will generate one if an expired one doesn't exist already, otherwise will grab existing token
			var/one_time_token = SSdiscord.get_or_generate_one_time_token_for_ckey(ckey)
			SSdiscord.reverify_cache[usr.ckey] = one_time_token
			message = "Ваш одноразовый токен: [one_time_token]. Предполагая, что у вас есть необходимое время пребывания в игре, теперь вы можете подтвердить свое участие в Discord с помощью команды: <span class='code user-select'>[prefix]verify [one_time_token]</span>"
		//SPLURT EDIT END

	//Now give them a browse window so they can't miss whatever we told them
	//SPLURT EDIT - Notify if they must stay in our discord server
	if(CONFIG_GET(flag/forced_discord_stay))
		message += span_warning("Помните, что для получения верификации вы ДОЛЖНЫ оставаться на сервере discord")
	//SPLURT EDIT END
	var/datum/browser/window = new /datum/browser(usr, "discordverification", "Верификация в Дискорде")
	window.set_content("<div>[message]</div>")
	window.open()


