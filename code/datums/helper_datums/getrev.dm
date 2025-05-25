/datum/getrev
	var/commit  // git rev-parse HEAD
	var/date
	var/originmastercommit  // git rev-parse origin/master
	var/list/testmerge = list()

/datum/getrev/New()
	commit = rustg_git_revparse("HEAD")
	if(commit)
		date = rustg_git_commit_date(commit)
	originmastercommit = rustg_git_revparse("origin/master")

/datum/getrev/proc/load_tgs_info()
	testmerge = world.TgsTestMerges()
	var/datum/tgs_revision_information/revinfo = world.TgsRevision()
	if(revinfo)
		commit = revinfo.commit
		originmastercommit = revinfo.origin_commit
		date = revinfo.timestamp || rustg_git_commit_date(commit)

	// goes to DD log and config_error.txt
	log_world(get_log_message())

/datum/getrev/proc/get_log_message()
	var/list/msg = list()
	msg += "Running /tg/ revision: [date]"
	if(originmastercommit)
		msg += "origin/master: [originmastercommit]"

	for(var/line in testmerge)
		var/datum/tgs_revision_information/test_merge/tm = line
		msg += "Test merge active of PR #[tm.number] commit [tm.head_commit]"
		SSblackbox.record_feedback("associative", "testmerged_prs", 1, list("number" = "[tm.number]", "commit" = "[tm.head_commit]", "title" = "[tm.title]", "author" = "[tm.author]"))

	if(commit && commit != originmastercommit)
		msg += "HEAD: [commit]"
	else if(!originmastercommit)
		msg += "No commit information"

	msg += "Running rust-g version [rustg_get_version()]"

	return msg.Join("\n")

/datum/getrev/proc/GetTestMergeInfo(header = TRUE)
	if(!testmerge.len)
		return ""
	. = header ? "The following pull requests are currently test merged:<br>" : ""
	for(var/line in testmerge)
		var/datum/tgs_revision_information/test_merge/tm = line
		var/cm = tm.head_commit
		var/details = ": '" + html_encode(tm.title) + "' by " + html_encode(tm.author) + " at commit " + html_encode(copytext_char(cm, 1, 11))
		. += "<a href=\"[CONFIG_GET(string/githuburl)]/pull/[tm.number]\">#[tm.number][details]</a><br>"

/client/verb/showrevinfo()
	set category = "OOC"
	set name = "Показать версию сервера"
	set desc = "Проверьте текущую версию кода сервера"

	var/list/msg = list()
	// Round ID
	if(GLOB.round_id)
		msg += "<b>ID Раунда:</b> [GLOB.round_id]"

	msg += "<b>Версия BYOND:</b> [world.byond_version].[world.byond_build]"
	if(DM_VERSION != world.byond_version || DM_BUILD != world.byond_build)
		msg += "<b>Скомпилировано версий BYOND:</b> [DM_VERSION].[DM_BUILD]"

	// Revision information
	var/datum/getrev/revdata = GLOB.revdata
	msg += "<b>Версия сервера, скомпилированная на:</b> [revdata.date]"
	var/pc = revdata.originmastercommit
	if(pc)
		msg += "<b>Последний коммит GitHub (Master):</b> <a href=\"[CONFIG_GET(string/githuburl)]/commit/[pc]\">[pc]</a>"
	if(length(revdata.testmerge))
		msg += revdata.GetTestMergeInfo()
	if(revdata.commit && revdata.commit != revdata.originmastercommit)
		msg += "<b>Локальный коммит:</b> [revdata.commit]"
	else if(!pc)
		msg += "Нет информации о коммите"
	if(world.TgsAvailable())
		var/datum/tgs_version/version = world.TgsVersion()
		msg += "<b>Версия TGS</b>: [version.raw_parameter]"
		msg += "<b>Версия DMAPI</b>: [TGS_DMAPI_VERSION]"

	// Game mode odds
	msg += "<br><b>Текущие информационные настройки:</b>"
	msg += "<b>Защищайта авторитетных Ролей от Предателя:</b> [CONFIG_GET(flag/protect_roles_from_antagonist) ? "Да" : "Нет"]"
	msg += "<b>Защищайта роли ассистента от Предателя:</b> [CONFIG_GET(flag/protect_assistant_from_antagonist) ? "Да" : "Нет"]"
	msg += "<b>Укреплять человеческую власть:</b> [CONFIG_GET(string/human_authority) ? "Да" : "Нет"]"
	msg += "<b>Позволяют поздно присоединяться к антагонистам:</b> [CONFIG_GET(flag/allow_latejoin_antagonists) ? "Да" : "Нет"]"
	to_chat(src, fieldset_block("Информация о версии сервера", span_infoplain(jointext(msg, "<br>")), "boxed_message"), type = MESSAGE_TYPE_INFO)
