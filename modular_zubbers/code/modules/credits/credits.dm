#define CREDIT_ROLL_SPEED 100
#define CREDIT_SPAWN_SPEED 20
#define CREDIT_ANIMATE_HEIGHT (14 * world.icon_size)
#define CREDIT_EASE_DURATION 22

#define JOINTEXT(X) jointext(X, null) // Why is this needed? Why is this here? Oh well

GLOBAL_VAR_INIT(end_credits_song, null)
GLOBAL_VAR_INIT(end_credits_title, null)
GLOBAL_LIST(end_titles)

/datum/controller/subsystem/ticker/declare_completion(force_ending)

	if(!GLOB.end_titles)
		GLOB.end_titles = generate_titles()

	for(var/client/C)
		if(!C?.credits)
			C?.RollCredits()

/* 	for(var/thing in GLOB.clients)
		var/client/C = thing
		if (!C)
			continue */
	. = ..()

/* /datum/controller/subsystem/ticker/show_roundend_report(client/C, report_type = null)
	. = ..()
	for(var/iteration in GLOB.clients)
		var/client/clients = iteration
		if(!clients.credits)
			clients.RollCredits() */
/* /client
	var/list/credits */


/client/proc/RollCredits()
	set waitfor = FALSE
	var/credit_pref = mob.client?.prefs?.read_preference(/datum/preference/toggle/see_credits)
	if(!credit_pref)
		return

	LAZYINITLIST(credits)

/* 	if(mob)
		mob.overlay_fullscreen("meeting",/atom/movable/screen/fullscreen/emergency_meeting) */
//	sound_to_playing_players('modular_skyrat/master_files/sound/music/elibao.ogg', volume = 100, vary = FALSE, frequency = 0, channel = 0, pressure_affected = FALSE)

	var/list/_credits = credits
	verbs += /client/proc/ClearCredits
	for(var/I in GLOB.end_titles)
		if(!credits)
			return
		var/atom/movable/screen/credit/T = new(null, null, I, src)
		_credits += T
		T.rollem()
		sleep(CREDIT_SPAWN_SPEED)
	sleep(CREDIT_ROLL_SPEED - CREDIT_SPAWN_SPEED)

	ClearCredits()
	verbs -= /client/proc/ClearCredits

/client/proc/ClearCredits()
	set name = "Остановить титры"
	set category = "OOC"
	verbs -= /client/proc/ClearCredits
	QDEL_LAZYLIST(credits)

/atom/movable/screen/credit
	icon_state = "blank"
	mouse_opacity = 0
	alpha = 0
	screen_loc = "CENTER-7,CENTER-7"
	plane = HUD_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	var/client/parent
	var/matrix/target

/atom/movable/screen/credit/Initialize(mapload, datum/hud/hud_owner, credited, client/P)
	. = ..()
	parent = P
	maptext = {"<div style="font:'Small Fonts'">[credited]</div>"}
	maptext_height = world.icon_size * 2
	maptext_width = world.icon_size * 14

/atom/movable/screen/credit/proc/rollem()
	var/matrix/direction = matrix(transform)
	direction.Translate(0, CREDIT_ANIMATE_HEIGHT)
	animate(src, transform = direction, time = CREDIT_ROLL_SPEED)
	animate(src, alpha = 255, time = CREDIT_EASE_DURATION, flags = ANIMATION_PARALLEL)
	UNLINT(animate(src, alpha = 0, flags = ANIMATION_PARALLEL, time = CREDIT_EASE_DURATION, delay = CREDIT_ROLL_SPEED - CREDIT_EASE_DURATION))
	parent?.screen += src

/atom/movable/screen/credit/proc/fadeout(matrix/direction)

	sleep(CREDIT_EASE_DURATION)
	qdel(src)

/atom/movable/screen/credit/Destroy()
	var/client/P = parent
	if(parent)
		P.screen -= src
	LAZYREMOVE(P?.credits, src)
	parent = null
	. = ..()

/proc/generate_titles()
	var/list/titles = list()
	var/list/cast = list()
	var/list/chunk = list()
	var/list/possible_titles = list()
	var/chunksize = 0
	if(!GLOB.end_credits_title)
		/* Establish a big-ass list of potential titles for the "episode". */
		/* Создайте большой список потенциальных названий для «эпизода». */
		possible_titles += "[pick("ПАДЕНИЕ", "ВОЗВЫШЕНИЕ", "БЕДА", "РАССЛОЕНИЕ СМ", "ТЕМНАЯ СТОРОНА", "ЗАПУСТЕНИЕ", "РАЗРУШЕНИЕ", "КРИЗИС")]\
							[pick("КОСМОНАВТОВ", "ЧЕЛОВЕЧЕСТВА", "ДОСТОИНСТВА", "ЗДРАВОМЫСЛИЯ", "ШИМПАНЗЕ", "ЦЕНЫ НА ВЕНДОМАТЫ", "ГАЗОВЫЙ УБОРЩИК",\
							"КРИСТАЛЛА СУПЕРМАТЕРИИ", "МЕДИЦИНЫ", "ИНЖЕНЕРИИ", "БЕЗОПАСНОСТИ", "ИССЛЕДОВАНИЯ", "СЕРВИСНИКА", "КОМАНДОВАНИЯ", "ИССЛЕДОВАТЕЛЯ", "СЛЕДОПЫТА")]"
		possible_titles += "КОМАНДА ПОЛУЧАЕТ [pick("ЦЕННЫЙ УРОК", "КАЙФ", "ПИЦЦУ", "ПТРС", "КОНТУЗИЮ", "РОЗОВУЮ ВУЛЬПУ", "ЖЕЛАНИЕ ПОТРОГАТЬ ТРАВУ", "ЖИЗНЬ", "СЕРБЁЗНЫЙ УРОК О [pick("НАРКОМАНИИ", "ПРЕСТУПНОСТИ", "ПРОИЗВОДИТЕЛЬНОСТИ", "ДЕКОМПРЕССИОННЫХ ПРОЦЕДУРАХ", "ОТСУТСТВИИ НАВЫКА")]")]"
		possible_titles += "КОМАНДА УЗНАЕТ О [pick("ЛЮБВИ", "НАРКОТИКАХ", "ОПАСНОСТИ ОТМЫВАНИЯ ДЕНЕГ", "КСЕНОЧУВСТВИТЕЛЬНОСТИ", "ИНВЕСТИЦИОННЫХ МОШЕННИЧЕСТВАХ", "ЗЛОУПОТРЕБЛЕНИЕ КЕЛОТАНОМ", "ЗАЩИТЕ ОТ РАДИАЦИИ", "ТЕОРИИ СТРУН", "ВОЕННЫХ ПРЕСТУПЛЕНИЯХ АРМАТУРОВА", "ДРЕВНЕКИТАЙСКОЙ МЕДИЦИНЕ", "ПРОЦЕССЕ СПАРИВАНИЯ [pick("РОЗОВЫХ ВУЛЬП", "ПЛОХИХ АДМИНОВ", "ЖИТЕЛЕЙ ДОРМ", "НЕТАКУСЬ")]")]"
		possible_titles += "ОЧЕНЬ [pick("КОРПОРАТИВНЫЙ", "НАНОТРЕЙЗЕН", "БОЛЬШОЙ ФЛОТ", "РОБАСТНЫЙ", "ПИВАСНЫЙ", "ЭКСПЕДИЦИОННЫЙ")] [pick("РОЖДЕСТВО", "ПАСХА", "ПРАЗДНИК", "ВЫХОДНЫЕ", "СРЕДА", "ОТДЫХ")]"
		possible_titles += "[pick("ОРУЖИЕ, ОРУЖИЕ ПОВСЮДУ", "САМЫЙ МАЛЕНЬКИЙ АРМАЛИС", "ЗАЙТИ В КАМЕРУ СМА БЕЗ МАГНИТОК", "АТАКА! АТАКА! АТАКА!", "СЕКС БОМБА", "ЛЕГЕНДА ОБ КОСМОНАВТИКАХ: ЧАСТЬ [pick("I","II","III","IV","V","VI","VII","VIII","IX", "X", "C","M","L")]")]"
		possible_titles += "[pick("КОСМОС", "СЕКСУАЛЬНЫЙ", "ДРАКОН", "ОРУЖИЕ", "РЕКЛАМА", "СОБАКА", "УГАРНЫЙ ГАЗ", "НИНДЗЯ", "ВОЛШЕБНИК", "СОКРАТИЯ", "МАЛОЛЕТНИЕ ДЕБИЛЫ", "ПОЛИТИЧЕСКИ ДЕБАТЫ", "РАДИКАЛЬНАЯ БОЛЕЗНЬ")] [pick("КВЕСТ", "ФОРСАЖ", "ПРЕКЛЮЧЕНИЕ")]"
		possible_titles += "[pick("ДЕНЬ [pick("НАНОТРЕЙЗЕН", "СИНДИКАТА", "КОРПОРАЦИИ ПИВА")]", "ОХОТА НА ЗЕЛЕНУЮ СОСИСКУ", "РОБАСТЕР ПРОТИВ ВЕНДОМАТА", "КОСМИЧЕСКАЯ ТРАССА")]"
		titles += "<center><h1>ЭПИЗОД [rand(1,1000)]<br>[pick(possible_titles)]<h1></h1></h1></center>"
	else
		titles += "<center><h1>ЭПИЗОД [rand(1,1000)]<br>[GLOB.end_credits_title]<h1></h1></h1></center>"

	for(var/datum/mind/mind in get_crewmember_minds())
		if(!mind)
			continue
		if(!cast.len && !chunksize)
			chunk += "В РОЛЯХ:"
		var/datum/job/job = mind?.assigned_role
		var/jobtitle = job?.title || "Без названия"
		var/used_name = mind?.current?.name
		var/antag_string
		for(var/datum/antagonist/antagonist as anything in mind?.antag_datums)
			antag_string ? (antag_string += ", ") : (antag_string += "...")
			antag_string += "[antagonist?.name]"
		chunk += "[used_name] как [mind?.antag_datums ? "[antag_string] и [jobtitle]" : jobtitle]"
		chunksize++

		if(chunksize > 2)
			cast += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0
	if(chunk.len)
		cast += "<center>[jointext(chunk,"<br>")]</center>"

	titles += cast

	var/list/corpses = list()
	var/list/monkies = list()
	for(var/mob/living/carbon/human/H in GLOB.dead_mob_list)
		if(H.timeofdeath < 5 MINUTES) //no prespawned corpses
			continue
		if(ismonkey(H))
			monkies[H?.name] += 1
		else if(H?.real_name)
			corpses += H?.real_name
	if(corpses.len)
		titles += "<center>ОСНОВАНО НА РЕАЛЬНЫХ СОБЫТИЯХ<br>В память о [english_list(corpses)].</center>"

	var/list/staff = list("ОСОБЫЕ АКТЁРЫ:")
	var/static/list/staffjobs = list("Камерамен", "Конченый идиот", "Самый сексуальный мужик в мире", "Горячая чикса", "Злодей британец", "Так себе шутник", "Пубертатная язва", "Какой-то мужик", "Говнюки", "Недопонятый гений")
	var/list/goodboys = list()
	for(var/client/C)
		if(!C?.holder)
			continue
		if(C?.holder)
			staff += "[uppertext(pick(staffjobs))] также известный как '[C?.key]'"

	titles += "<center>[jointext(staff,"<br>")]</center>"
	if(goodboys.len)
		titles += "<center>ХОРОШИЕ МАЛЬЧИКИ:<br>[english_list(goodboys)]</center><br>"

	var/disclaimer = "<br>Спонсор [pick("Нанотрейзен", "Синдикат", "Кремль", "Партия ЛДПР", "Партия КПРФ", "Партия КПРФ", "Mastur'Bist")].<br>Все права защищены.<br>\
					Этот фильм защищен законами об авторском праве правительства сектора Андромеда<br> и других стран галактики.<br>\
					Колония Первого издания: [pick("Марс", "Луна", "Земля", "Венера", "Фобос", "Церера", "Тиамат", "Плутон")].<br>"
	disclaimer += pick("Использование для пародий запрещено. ЗАПРЕЩЕНО.",
					   "Все трюки были выполнены низкооплачиваемыми стажерами. Не пытайтесь сделать это дома.",
					   "[pick("Нанотрейзен", "Синдикат", "Кремль", "Партия ЛДПР", "Партия КПРФ", "Партия КПРФ", "Mastur'Bist")] не одобряет изображенное поведение в фильме. Пробуйте на свой страх и риск.",
					   "Любой несанкционированный показ, распространение или копирование данного фильма или любой его части (включая саундтрек)<br>\
						может привести к тому, что будет вызвана ОБР для штурма вашего дома и его силового захвата.",
						"История, все имена, персонажи и происшествия, изображенные в этой постановке, являются вымышленными. Никакого отождествления с реальными<br>\
						людьми (живыми или умершими), местами, зданиями и продуктами не предполагается и не должно предполагаться.<br>\
						Этот фильм основан на правдивой истории, и все изображенные в нем личности основаны на реальных людях, несмотря на то, что мы только что сказали.",
						"Ни одно физическое или юридическое лицо, связанное с этим фильмом, не получало оплату или что-либо ценное, и не заключало никаких соглашений в связи<br>\
						с изображением табачных изделий, несмотря на большое количество курения, показанного в фильме.<br>\
						(Этот отказ от ответственности спонсируется компанией Слилсякорпорейт. Слилсякорпорейт - наше дело вовремя слиться!(TM)).",
						"Ни одно животное не пострадало при создании этого фильма, за исключением тех, которые были указаны ранее как мертвые. Не пытайтесь сделать это дома.")
	titles += "<hr>"
	titles += "<center><span style='font-size:6pt;'>[JOINTEXT(disclaimer)]</span></center>"

	return titles

/// Enables the choice of players disabling seeing the credits
/datum/preference/toggle/see_credits
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "see_credits"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = TRUE

#undef CREDIT_ROLL_SPEED
#undef CREDIT_SPAWN_SPEED
#undef CREDIT_ANIMATE_HEIGHT
#undef CREDIT_EASE_DURATION
#undef JOINTEXT
