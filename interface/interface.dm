//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "wiki"
	set desc = "Введите информацию, о которой вы хотите узнать.  Это откроет вики в вашем веб-браузере. Чтобы перейти на главную страницу, введите «ничего»."
	set hidden = TRUE
	var/wikiurl = CONFIG_GET(string/wikiurl)
	if(wikiurl)
		if(query)
			var/output = wikiurl + "/index.php?title=Special%3ASearch&profile=default&search=" + query
			src << link(output)
		else if (query != null)
			src << link(wikiurl)
	else
		to_chat(src, span_danger("URL-адрес wiki не задан в конфигурации сервера."))
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Посетите форум."
	set hidden = TRUE
	var/forumurl = CONFIG_GET(string/forumurl)
	if(forumurl)
		if(tgui_alert(src, "Это откроет форум в вашем браузере. Вы уверены?",, list("Да","Нет"))!="Да")
			return
		src << link(forumurl)
	else
		to_chat(src, span_danger("URL-адрес форума не задан в конфигурации сервера."))
	return

/client/verb/rules()
	set name = "rules"
	set desc = "Показать правила сервера."
	set hidden = TRUE
	var/rulesurl = CONFIG_GET(string/rulesurl)
	if(rulesurl)
		if(tgui_alert(src, "Это откроет правила в вашем браузере. Вы уверены?",, list("Да","Нет"))!="Да")
			return
		src << link(rulesurl)
	else
		to_chat(src, span_danger("URL-адрес правил не задан в конфигурации сервера."))
	return

/client/verb/github()
	set name = "github"
	set desc = "Посетите GitHub"
	set hidden = TRUE
	var/githuburl = CONFIG_GET(string/githuburl)
	if(githuburl)
		if(tgui_alert(src, "Это откроет репозиторий GitHub в вашем браузере. Вы уверены?",, list("Да","Нет"))!="Да")
			return
		src << link(githuburl)
	else
		to_chat(src, span_danger("URL-адрес GitHub не задан в конфигурации сервера."))
	return

/client/verb/reportissue()
	set name = "report-issue"
	set desc = "Сообщить о проблеме"
	set hidden = TRUE
	var/githuburl = CONFIG_GET(string/githuburl)
	if(!githuburl)
		to_chat(src, span_danger("URL-адрес GitHub не задан в конфигурации сервера."))
		return

	var/testmerge_data = GLOB.revdata.testmerge
	var/has_testmerge_data = (length(testmerge_data) != 0)

	var/message = "Это откроет отчет о проблеме на GitHub в вашем браузере. Вы уверены?"
	if(has_testmerge_data)
		message += "<br>Следующие экспериментальные изменения активны и, вероятно, являются причиной любых новых или внезапных проблем, с которыми вы можете столкнуться. Если возможно, постарайтесь найти конкретную тему для вашей проблемы, а не писать в общий трекер проблем:<br>"
		message += GLOB.revdata.GetTestMergeInfo(FALSE)

	// We still use tg_alert here because some people were concerned that if someone wanted to report that tgui wasn't working
	// then the report issue button being tgui-based would be problematic.
	if(tg_alert(src, message, "Сообщить о проблеме", "Да", "Нет") != "Да")
		return

	var/base_link = githuburl + "/issues/new?template=bug_report_form.yml"
	var/list/concatable = list(base_link)

	var/client_version = "[byond_version].[byond_build]"
	concatable += ("&reporting-version=" + client_version)

	// the way it works is that we use the ID's that are baked into the template YML and replace them with values that we can collect in game.
	if(GLOB.round_id)
		concatable += ("&round-id=" + GLOB.round_id)

	// Insert testmerges
	if(has_testmerge_data)
		var/list/all_tms = list()
		for(var/entry in testmerge_data)
			var/datum/tgs_revision_information/test_merge/tm = entry
			all_tms += "- \[[tm.title]\]([githuburl]/pull/[tm.number])"
		var/all_tms_joined = jointext(all_tms, "\n")

		concatable += ("&test-merges=" + url_encode(all_tms_joined))

	DIRECT_OUTPUT(src, link(jointext(concatable, "")))


/client/verb/changelog()
	set name = "Changelog"
	set category = "OOC"
	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog()

	GLOB.changelog_tgui.ui_interact(mob)
	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		prefs.save_preferences()
		winset(src, "infobuttons.changelog", "font-style=;")

/client/verb/hotkeys_help()
	set name = "Хоткеи"
	set category = "OOC"

	if(!GLOB.hotkeys_tgui)
		GLOB.hotkeys_tgui = new /datum/hotkeys_help()

	GLOB.hotkeys_tgui.ui_interact(mob)
