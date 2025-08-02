/mob/living/carbon/verb/army_crawl()
	set name = "Залезть под.."
	set category = "IC"

	var/mob/living/carbon/crawler = src

	if(HAS_TRAIT(crawler, TRAIT_PRONE))
		visible_message("[crawler] начинает вставать")
		if(!do_after(crawler, 5 DECISECONDS))
			return
		SEND_SIGNAL(crawler, COMSIG_MOVABLE_REMOVE_PRONE_STATE)
	else if(crawler.can_army_crawl())
		visible_message("[crawler] начинает опускаться еще ниже")
		if(!do_after(crawler, 5 DECISECONDS, extra_checks = CALLBACK(crawler, PROC_REF(can_army_crawl))))
			if(!crawler.resting)
				balloon_alert(crawler, "должен лежать!")
			return
		crawler.AddComponent(/datum/component/prone_mob, block_hands = TRUE)
	else
		balloon_alert(crawler, "должен лежать!")

/mob/living/carbon/proc/can_army_crawl()
	return resting
