SUBSYSTEM_DEF(modpacks)
	name = "Modpacks"
	init_stage = INITSTAGE_FIRST
	flags = SS_NO_FIRE
	var/list/loaded_modpacks = list()

/datum/controller/subsystem/modpacks/Initialize()
	var/list/all_modpacks = list()
	for(var/modpack in subtypesof(/datum/modpack/))
		all_modpacks.Add(new modpack)
	// Pre-init and register all compiled modpacks.
	for(var/datum/modpack/package as anything in all_modpacks)
		var/fail_msg = package.pre_initialize()
		if(QDELETED(package))
			CRASH("Модпак типа [package.type] равен null или помечен на удаление.")
		if(fail_msg)
			CRASH("Модпак [package.name] не смог выполнить пре-инициализацию: [fail_msg].")
		if(loaded_modpacks[package.name])
			CRASH("Попытка зарегистрировать дублирующийся модпак [package.name].")
		loaded_modpacks.Add(package)

	// Handle init and post-init (two stages in case a modpack needs to implement behavior based on the presence of other packs).
	for(var/datum/modpack/package as anything in all_modpacks)
		var/fail_msg = package.initialize()
		if(fail_msg)
			CRASH("Модпак [(istype(package) && package.name) || "Неизвестный"] не удалось инициализировать: [fail_msg]")
	for(var/datum/modpack/package as anything in all_modpacks)
		var/fail_msg = package.post_initialize()
		if(fail_msg)
			CRASH("Модпак [(istype(package) && package.name) || "Неизвестный"] не удалось пост-инициализировать: [fail_msg]")

	return SS_INIT_SUCCESS
